package game

import "../shared"
import rl "vendor:raylib"

@(export)
game_init :: proc(g_state: ^shared.Global_State) {
	g_state.system.target = rl.LoadRenderTexture(shared.SCREEN_X_DIM, shared.SCREEN_Y_DIM)
	rl.SetTargetFPS(60)
	// g_state.system.texture = rl.LoadTexture("assets/green-3.png")

}

@(export)
game_exit :: proc(g_state: ^shared.Global_State) {
	rl.UnloadRenderTexture(g_state.system.target)
	// rl.UnloadTexture(g_state.system.texture)
}
