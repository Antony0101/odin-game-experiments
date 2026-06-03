package atlasViewer

import "core:fmt"
import math "core:math"
import "core:time"
import rl "vendor:raylib"

// SCREEN_X_DIM :: 1280
// SCREEN_Y_DIM :: 720

SCREEN_X_DIM :: 720
SCREEN_Y_DIM :: 480

should_run := true

frame_timers := struct {
	sum_time: f32,
	max_time: f32,
	min_time: f32,
	count:    i16,
} {
	min_time = math.F32_MAX,
}

global_pos: rl.Vector2 = {0, 0}
scale: f32 = 1

global_pos_matrix: matrix[3, 3]f32 = f32(1)


main :: proc() {
	dt: f32
	rl.SetConfigFlags({.VSYNC_HINT, .WINDOW_RESIZABLE})
	rl.InitWindow(1600, 900, "prototype")
	target := rl.LoadRenderTexture(SCREEN_X_DIM, SCREEN_Y_DIM)
	defer rl.UnloadRenderTexture(target)
	rl.SetTargetFPS(60)
	init()
	for should_run {
		if frame_timers.count >= 300 {
			fmt.println()
			fmt.println(
				"avg frame time:",
				frame_timers.sum_time / f32(frame_timers.count),
				"\u03BCs",
			)
			fmt.println("min frame time:", frame_timers.min_time, "\u03BCs")
			fmt.println("max frame time:", frame_timers.max_time, "\u03BCs")
			frame_timers.count = 0
			frame_timers.max_time = 0
			frame_timers.min_time = math.F32_MAX
			frame_timers.sum_time = 0
		}
		start_time := time.now()
		if rl.WindowShouldClose() {
			should_run = false
		}
		// update(&main_data, dt)
		rl.BeginTextureMode(target)
		rl.SetMouseOffset(i32(-global_pos.x), i32(-global_pos.y))
		rl.SetMouseScale(1.0 / scale, 1.0 / scale)
		draw()
		// rl.DrawTextureEx(texture, main_data.position, 1, 5, rl.WHITE)
		rl.EndTextureMode()
		rl.BeginDrawing()
		// covert to screen size to maintain aspect ratio
		screen_w := f32(rl.GetScreenWidth())
		screen_h := f32(rl.GetScreenHeight())

		scale = min(screen_w / SCREEN_X_DIM, screen_h / SCREEN_Y_DIM)

		draw_w := f32(SCREEN_X_DIM) * scale
		draw_h := f32(SCREEN_Y_DIM) * scale

		offset_x := (screen_w - draw_w) * 0.5
		offset_y := (screen_h - draw_h) * 0.5

		global_pos = {offset_x, offset_y}
		global_pos_matrix = {scale, 0, offset_x, 0, scale, offset_y, 0, 0, 1}

		source := rl.Rectangle {
			0,
			0,
			f32(target.texture.width),
			-f32(target.texture.height), // flip Y
		}

		dest := rl.Rectangle{offset_x, offset_y, draw_w, draw_h}

		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)

		rl.DrawTexturePro(target.texture, source, dest, {0, 0}, 0, rl.WHITE)
		// frame performance calculator
		elapsed_time_micro_seconds := f32(time.since(start_time)) / 1000
		frame_timers.max_time = max(frame_timers.max_time, elapsed_time_micro_seconds)
		frame_timers.min_time = min(frame_timers.min_time, elapsed_time_micro_seconds)
		frame_timers.sum_time += elapsed_time_micro_seconds
		frame_timers.count += 1

		rl.EndDrawing()
		dt = rl.GetFrameTime()
	}
}
