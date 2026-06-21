package main

import "../shared"
import "core:fmt"
import math "core:math"
import "core:time"
import rl "vendor:raylib"

SCREEN_X_DIM :: 1280
SCREEN_Y_DIM :: 720

// should_run := true

frame_timers := struct {
	sum_time: f32,
	max_time: f32,
	min_time: f32,
	count:    i16,
} {
	min_time = math.F32_MAX,
}

dt: f32


@(export)
game_init :: proc(g_state: ^shared.Global_State) {
	fmt.println("here123 init")
	// dt: f32
	// rl.SetConfigFlags({.VSYNC_HINT, .WINDOW_RESIZABLE, .WINDOW_TOPMOST})
	// rl.InitWindow(1600, 900, "prototype")
	// rl.SetWindowPosition(200, 200)
	g_state.system.target = rl.LoadRenderTexture(SCREEN_X_DIM, SCREEN_Y_DIM)
	fmt.println("here 1123 init")
	// defer rl.UnloadRenderTexture(target)
	rl.SetTargetFPS(60)
	init()
	g_state.system.texture = rl.LoadTexture("assets/green-3.png")
}

@(export)
game_exit :: proc(g_state: ^shared.Global_State) {
	rl.UnloadRenderTexture(g_state.system.target)
	rl.UnloadTexture(g_state.system.texture)
}

@(export)
game_main_loop :: proc(g_state: ^shared.Global_State) -> bool {
	should_run := true
	if frame_timers.count >= 300 {
		fmt.println()
		fmt.println("avg frame time:", frame_timers.sum_time / f32(frame_timers.count), "\u03BCs")
		fmt.println("min frame time:", frame_timers.min_time, "\u03BCs")
		fmt.println("max frame time:", frame_timers.max_time, "\u03BCs")
		frame_timers.count = 0
		frame_timers.max_time = 0
		frame_timers.min_time = math.F32_MAX
		frame_timers.sum_time = 0
	}
	start_time := time.now()
	if rl.WindowShouldClose() {
		fmt.println("window exit triggered")
		should_run = false
		return should_run
	}
	update(&main_data, dt)
	rl.BeginTextureMode(g_state.system.target)
	draw()
	rl.DrawTextureEx(g_state.system.texture, main_data.position, 1, 5, rl.WHITE)
	rl.EndTextureMode()
	// rl.BeginDrawing()
	screen_w := f32(rl.GetScreenWidth())
	screen_h := f32(rl.GetScreenHeight())

	scale := min(screen_w / SCREEN_X_DIM, screen_h / SCREEN_Y_DIM)

	draw_w := f32(SCREEN_X_DIM) * scale
	draw_h := f32(SCREEN_Y_DIM) * scale

	offset_x := (screen_w - draw_w) * 0.5
	offset_y := (screen_h - draw_h) * 0.5

	source := rl.Rectangle {
		0,
		0,
		f32(g_state.system.target.texture.width),
		-f32(g_state.system.target.texture.height), // flip Y
	}

	dest := rl.Rectangle{offset_x, offset_y, draw_w, draw_h}

	rl.BeginDrawing()

	// draw()
	rl.ClearBackground(rl.BLACK)

	rl.DrawTexturePro(g_state.system.target.texture, source, dest, {0, 0}, 0, rl.WHITE)
	elapsed_time_micro_seconds := f32(time.since(start_time)) / 1000
	frame_timers.max_time = max(frame_timers.max_time, elapsed_time_micro_seconds)
	frame_timers.min_time = min(frame_timers.min_time, elapsed_time_micro_seconds)
	frame_timers.sum_time += elapsed_time_micro_seconds
	frame_timers.count += 1

	rl.EndDrawing()
	dt = rl.GetFrameTime()
	return should_run
}
