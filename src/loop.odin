package game

import "../shared"
import "core:log"
import rl "vendor:raylib"

SCREEN_X_DIM :: 1280
SCREEN_Y_DIM :: 720


@(export)
game_loop :: proc(g_state: ^shared.Global_State, dt: f32) -> bool {
	should_run := true
	g_state.pf.flogger(g_state.frameId, .Info, "sample log")
	if rl.WindowShouldClose() {
		log.info("window exit triggered")
		should_run = false
		return should_run
	}
	// update(&g_state.game_state, dt)
	rl.BeginTextureMode(g_state.system.target)
	draw(g_state, dt)
	// rl.DrawTextureEx(g_state.system.texture, g_state.game_state.position, 1, 5, rl.WHITE)
	rl.EndTextureMode()


	return should_run
}
