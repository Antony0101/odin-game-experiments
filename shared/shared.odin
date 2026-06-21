package shared
import rl "vendor:raylib"

System :: struct {
	target:  rl.RenderTexture2D,
	texture: rl.Texture2D,
}
Game_State :: struct {
	player: rl.Vector2,
}
Global_State :: struct {
	system:     System,
	game_state: Game_State,
}

game_main_loop :: #type proc(g_state: ^Global_State) -> bool
game_init :: #type proc(g_state: ^Global_State)
game_exit :: #type proc(g_state: ^Global_State)
