package main

import "../shared"
import "core:fmt"
import rl "vendor:raylib"

SCREEN_X_DIM :: 1280
SCREEN_Y_DIM :: 720


@(export)
game_init :: proc(g_state: ^shared.Global_State) {
	g_state.system.target = rl.LoadRenderTexture(SCREEN_X_DIM, SCREEN_Y_DIM)
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
game_loop :: proc(g_state: ^shared.Global_State, dt: f32) -> bool {
	should_run := true
	g_state.pf.flogger(g_state.frameId, .Info, "sample log")
	if rl.WindowShouldClose() {
		fmt.println("window exit triggered")
		should_run = false
		return should_run
	}
	update(&g_state.game_state, dt)
	rl.BeginTextureMode(g_state.system.target)
	draw()
	rl.DrawTextureEx(g_state.system.texture, g_state.game_state.position, 1, 5, rl.WHITE)
	rl.EndTextureMode()


	return should_run
}

@(export)
game_commit :: proc(g_state: ^shared.Global_State) {
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
	rl.ClearBackground(rl.BLACK)

	rl.DrawTexturePro(g_state.system.target.texture, source, dest, {0, 0}, 0, rl.WHITE)
}
