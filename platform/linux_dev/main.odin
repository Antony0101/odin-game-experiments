package platform_linux

import "../../shared"
import "base:intrinsics"
import "core:dynlib"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:time"
import rl "vendor:raylib"


Game_Code :: struct {
	lib:      dynlib.Library,
	init:     shared.game_init,
	loop:     shared.game_loop,
	exit:     shared.game_exit,
	modified: time.Time,
}


Game_Lib_Path :: "/game"
Game_Lib_Ex :: ".so"

load_game :: proc(path: string) -> Game_Code {
	code: Game_Code
	time.sleep(2 * time.Second)
	copy_path := strings.concatenate([]string{path, "dd", Game_Lib_Ex})
	copy_err := os.copy_file(copy_path, strings.concatenate([]string{path, Game_Lib_Ex}))

	assert(copy_err == os.ERROR_NONE, "lib copy is not successful")

	count, ok := dynlib.initialize_symbols(&code, copy_path, "game_", "lib")
	if !ok {
		fmt.printfln("Failed loading game lib: {0}", dynlib.last_error())
		panic("failed loading game lib")
	}
	assert(
		count == intrinsics.type_struct_field_count(Game_Code) - 2,
		"game lib all symbols are not loaded",
	)
	// code.modified = lib_time

	return code
}

init :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT, .WINDOW_RESIZABLE, .WINDOW_TOPMOST})
	rl.InitWindow(1600, 900, "prototype")
	rl.SetWindowPosition(200, 200)
}

unload_game :: proc(code: ^Game_Code) {
	dynlib.unload_library(code.lib)
}

main :: proc() {
	// exe_path := os.args[0]
	// exe_dir := filepath.dir(string(exe_path))
	// os.set_working_directory(exe_dir)
	cwd, err := os.get_executable_directory(context.allocator)
	if err != nil {
		fmt.println("Failed:", err)
		return
	}
	global_state := new(shared.Global_State)

	fmt.println("exe directory:", cwd)
	lib_path := strings.concatenate([]string{cwd, Game_Lib_Path})
	defer delete(lib_path)
	fmt.println("lib path:", lib_path)
	// state := shared.Game_State{}
	game := load_game(lib_path)
	lib_path_ex := strings.concatenate([]string{lib_path, Game_Lib_Ex})
	fmt.println("game init")
	init()
	game.init(global_state)

	last_write: time.Time
	should_run := true

	for should_run {
		info, ok_file := os.stat(lib_path_ex, context.temp_allocator)

		new_write := info.modification_time

		if new_write != last_write {
			unload_game(&game)
			game = load_game(lib_path)
			last_write = new_write
		}
		should_run = game.loop(global_state)

	}
	fmt.println("clean game artifacts")
	game.exit(global_state)
}
