package shared
import rl "vendor:raylib"

Log_Level :: enum {
	Debug,
	Info,
	Warning,
	Error,
}

TextureStruct :: struct {
	name:    string,
	texture: rl.Texture2D,
}

currentDisplay :: enum {
	Game,
	Texture,
}

System :: struct {
	target:        rl.RenderTexture2D,
	currentDisp:   currentDisplay,
	// texture:   rl.Texture2D,
	// layoutmap: [11][16]Tile,
	layoutmap:     [11][16]u8,
	textures:      [30]TextureStruct,
	texture_count: u16,
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
Texture_Window_State :: struct {
	selectedTile:  [2]i16,
	textureWindow: struct {
		isOpen:  bool,
		pos:     rl.Vector2,
		veiw:    rl.Camera2D,
		dragoff: rl.Vector2,
		isDrag:  bool,
	},
	view:          rl.Camera2D,
}

PlatFormFunctions :: struct {
	flogger:  proc(frame: u64, level: Log_Level, msg: string),
	floggerf: proc(frame: u64, level: Log_Level, fmt_string: string, args: ..any),
}

Global_State :: struct {
	frameId:    u64,
	system:     System,
	game_state: Game_State,
	t_state:    Texture_Window_State,
	pf:         PlatFormFunctions,
}

game_loop :: #type proc(g_state: ^Global_State, dt: f32) -> bool
game_commit :: #type proc(g_state: ^Global_State)
game_init :: #type proc(g_state: ^Global_State)
game_setup :: #type proc(g_state: ^Global_State)
game_exit :: #type proc(g_state: ^Global_State)
