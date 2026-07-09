package game
import "../shared"
import "./textures"
import rl "vendor:raylib"

@(export)
game_setup :: proc(g_state: ^shared.Global_State) {
	g_state.game_state.view = {
		target   = {0, 0},
		offset   = {0, 0},
		zoom     = 1,
		rotation = 0,
	}
	g_state.system.layoutmap = [11][16]u8 {
		{0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0},
		{1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0},
		{1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0},
		{1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0},
		{1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0},
		{1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0},
		{1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0},
		{1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0},
		{1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0},
	}
	image := rl.GenImageColor(80, 80, rl.BLANK)
	textures.generateDesertTexture(&image)
	enum1 :: textures.texture_enums
	g_state.system.textures[enum1.desert1].texture = rl.LoadTextureFromImage(image)
	g_state.system.textures[enum1.desert1].name = "desert1"
	g_state.system.textures[enum1.desert2].texture = rl.LoadTextureFromImage(image)
	g_state.system.textures[enum1.desert2].name = "desert2"
	g_state.system.texture_count = 2
	rl.UnloadImage(image)
}
