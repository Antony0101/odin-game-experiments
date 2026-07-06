package shared
import rl "vendor:raylib"

Log_Level :: enum {
	Debug,
	Info,
	Warning,
	Error,
}

System :: struct {
	target:    rl.RenderTexture2D,
	texture:   rl.Texture2D,
	layoutmap: [11][16]u8,
}
Game_State :: struct {
	player: struct {
		using pos: rl.Vector2,
		isMoving:  bool,
		nextpos:   rl.Vector2,
		movements: struct {
			stack: [10]rl.KeyboardKey,
			top:   i8,
		},
	},
	view:   rl.Camera2D,
}

PlatFormFunctions :: struct {
	flogger:  proc(frame: u64, level: Log_Level, msg: string),
	floggerf: proc(frame: u64, level: Log_Level, fmt_string: string, args: ..any),
}

Global_State :: struct {
	frameId:    u64,
	system:     System,
	game_state: Game_State,
	pf:         PlatFormFunctions,
}

game_loop :: #type proc(g_state: ^Global_State, dt: f32) -> bool
game_commit :: #type proc(g_state: ^Global_State)
game_init :: #type proc(g_state: ^Global_State)
game_setup :: #type proc(g_state: ^Global_State)
game_exit :: #type proc(g_state: ^Global_State)
