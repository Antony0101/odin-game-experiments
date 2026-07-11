package game

import "../shared"
import "./textures"
import "core:log"
import rl "vendor:raylib"

scale: f32
offset_x: f32
offset_y: f32

@(export)
game_loop :: proc(g_state: ^shared.Global_State, dt: f32) -> bool {
	should_run := true
	rl.BeginTextureMode(g_state.system.target)
	// mouse is updated to match the location of texture
	rl.SetMouseOffset(i32(-offset_x), i32(-offset_y))
	rl.SetMouseScale(1.0 / scale, 1.0 / scale)
	// draw(g_state, dt)
	textures.draw_textureList(g_state, dt)
	rl.EndTextureMode()
	return should_run
}
