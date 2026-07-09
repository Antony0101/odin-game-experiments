package game

import "../shared"
import "./textures"
import "core:log"
import rl "vendor:raylib"


@(export)
game_loop :: proc(g_state: ^shared.Global_State, dt: f32) -> bool {
	should_run := true
	g_state.pf.flogger(g_state.frameId, .Info, "sample log")
	if rl.WindowShouldClose() {
		log.info("window exit triggered")
		should_run = false
		return should_run
	}
	rl.BeginTextureMode(g_state.system.target)
	// draw(g_state, dt)
	textures.draw_textureList(g_state, dt)
	rl.EndTextureMode()
	return should_run
}
