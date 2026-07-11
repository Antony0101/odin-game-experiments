package game

import "../shared"
import rl "vendor:raylib"

@(export)
game_init :: proc(g_state: ^shared.Global_State) {
	g_state.system.target = rl.LoadRenderTexture(shared.SCREEN_X_DIM, shared.SCREEN_Y_DIM)
	rl.SetTargetFPS(60)

}

@(export)
game_exit :: proc(g_state: ^shared.Global_State) {
	rl.UnloadRenderTexture(g_state.system.target)
	g_state.game_state = {}
	g_state.system = {}
	g_state.t_state = {}
	g_state.frameId = 0
}
