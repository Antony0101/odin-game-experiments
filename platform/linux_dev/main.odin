package platform_linux

import "core:dynlib"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:time"
import rl "vendor:raylib"

import "../../shared"


Game_Code :: struct {
	lib:       dynlib.Library,
	game_init: shared.game_init,
	game_loop: shared.game_main_loop,
	game_exit: shared.game_exit,
}

Game_Lib_Path :: "/game"
Game_Lib_Ex :: ".so"

load_game :: proc(path: string) -> Game_Code {
	code: Game_Code
	time.sleep(2 * time.Second)
	copy_path := strings.concatenate([]string{path, "dd", Game_Lib_Ex})
	copy_err := os.copy_file(copy_path, strings.concatenate([]string{path, Game_Lib_Ex}))

	assert(copy_err == os.ERROR_NONE, "lib copy is not successfuly")
	lib, ok := dynlib.load_library(copy_path)
	assert(ok, "failed to load main game lib")
	code.lib = lib

	// proc_addr := dynlib.symbol_address(code.lib, "update")
	// code.update = cast(shared.Update_Proc)proc_addr
	init_addr := dynlib.symbol_address(code.lib, "game_init")
	assert(init_addr != nil, "game init function linking failed")
	code.game_init = cast(shared.game_init)init_addr
	loop_addr := dynlib.symbol_address(code.lib, "game_main_loop")
	assert(loop_addr != nil, "game loop function linking failed")
	code.game_loop = cast(shared.game_main_loop)loop_addr
	exit_addr := dynlib.symbol_address(code.lib, "game_exit")
	assert(exit_addr != nil, "game exit function linking failed")
	code.game_exit = cast(shared.game_exit)exit_addr

	return code
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
	// dynlib.initialize_symbols()
	global_state := new(shared.Global_State)

	fmt.println("exe directory:", cwd)
	lib_path := strings.concatenate([]string{cwd, Game_Lib_Path})
	defer delete(lib_path)
	fmt.println("lib path:", lib_path)
	state := shared.Game_State{}
	game := load_game(lib_path)
	lib_path_ex := strings.concatenate([]string{lib_path, Game_Lib_Ex})
	fmt.println("game init")
	rl.SetConfigFlags({.VSYNC_HINT, .WINDOW_RESIZABLE, .WINDOW_TOPMOST})
	rl.InitWindow(1600, 900, "prototype")
	rl.SetWindowPosition(200, 200)
	game.game_init(global_state)

	last_write: time.Time
	should_run := true
	fmt.println("here1")

	for should_run {
		info, ok_file := os.stat(lib_path_ex, context.temp_allocator)

		new_write := info.modification_time

		if new_write != last_write {
			unload_game(&game)
			game = load_game(lib_path)
			last_write = new_write
		}
		should_run = game.game_loop(global_state)

	}
	fmt.println("clean game artifacts")
	game.game_exit(global_state)
}
