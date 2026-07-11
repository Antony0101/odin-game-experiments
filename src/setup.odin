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
	g_state.t_state.view = {
		target   = {0, 0},
		offset   = {0, 0},
		zoom     = 1,
		rotation = 0,
	}
	g_state.t_state.textureWindow.veiw = {
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
	image := rl.GenImageColor(320, 320, rl.BLANK)
	assert(
		len(g_state.system.textures) >= len(textures.basic_textures),
		"texture count is greater than texture list count",
	)
	for i in 0 ..< len(textures.basic_textures) {
		textures.create_basic_texture_image(&image, textures.basic_textures[i].color)
		g_state.system.textures[i].texture = rl.LoadTextureFromImage(image)
		g_state.system.textures[i].name = textures.basic_textures[i].name
	}
	g_state.system.texture_count = len(textures.basic_textures)
	rl.UnloadImage(image)
}
