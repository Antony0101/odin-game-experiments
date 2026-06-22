package platform_dev

import "../../shared"
import "core:dynlib"
import "core:fmt"
import "core:math"
import "core:os"
import "core:strings"
import "core:sync"
import "core:thread"
import "core:time"
import rl "vendor:raylib"

should_exit := false
lib_mutex := sync.Mutex{}

Game_Code :: struct {
	lib:      dynlib.Library,
	init:     shared.game_init,
	loop:     shared.game_loop,
	commit:   shared.game_commit,
	exit:     shared.game_exit,
	modified: time.Time,
}

game_lib: Game_Code

Frame_Timers :: struct {
	sum_time: f32,
	max_time: f32,
	min_time: f32,
	count:    i16,
}
dt: f32

Game_Lib_Path :: "/game"
Game_Lib_Ex :: ".so"
lib_path: string

frame_timer_begin :: proc(frame_timers: ^Frame_Timers) {
	if frame_timers.count >= 300 {
		fmt.println()
		fmt.println("avg frame time:", frame_timers.sum_time / f32(frame_timers.count), "\u03BCs")
		fmt.println("min frame time:", frame_timers.min_time, "\u03BCs")
		fmt.println("max frame time:", frame_timers.max_time, "\u03BCs")
		frame_timers.count = 0
		frame_timers.max_time = 0
		frame_timers.min_time = math.F32_MAX
		frame_timers.sum_time = 0
	}
}

frame_timer_end :: proc(frame_timers: ^Frame_Timers, start_time: time.Time) {
	elapsed_time_micro_seconds := f32(time.since(start_time)) / 1000
	frame_timers.max_time = max(frame_timers.max_time, elapsed_time_micro_seconds)
	frame_timers.min_time = min(frame_timers.min_time, elapsed_time_micro_seconds)
	frame_timers.sum_time += elapsed_time_micro_seconds
	frame_timers.count += 1
}

init :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT, .WINDOW_RESIZABLE, .WINDOW_TOPMOST})
	rl.InitWindow(1600, 900, "prototype")
	rl.SetWindowPosition(200, 200)
}


main :: proc() {
	frame_timers := Frame_Timers {
		min_time = math.F32_MAX,
	}

	// exe_path := os.args[0]
	// exe_dir := filepath.dir(string(exe_path))
	// os.set_working_directory(exe_dir)
	t: thread.Thread

	t = thread.create_and_start(worker_proc, nil)^
	cwd, err := os.get_executable_directory(context.allocator)
	if err != nil {
		fmt.println("Failed:", err)
		return
	}
	global_state := new(shared.Global_State)

	fmt.println("exe directory:", cwd)
	lib_path = strings.concatenate([]string{cwd, Game_Lib_Path})
	// defer delete(lib_path)
	fmt.println("lib path:", lib_path)
	// state := shared.Game_State{}
	game_lib = load_game(lib_path)
	lib_path_ex := strings.concatenate([]string{lib_path, Game_Lib_Ex})
	fmt.println("game init")
	init()
	game_lib.init(global_state)

	// last_write: time.Time
	should_run := true

	for should_run {
		start_time := time.now()
		frame_timer_begin(&frame_timers)

		// info, ok_file := os.stat(lib_path_ex, context.temp_allocator)

		// new_write := info.modification_time

		// if new_write != last_write {
		// 	unload_game(&game)
		// 	game = load_game(lib_path)
		// 	last_write = new_write
		// }
		sync.lock(&lib_mutex)
		should_run = game_lib.loop(global_state, dt)
		rl.BeginDrawing()
		game_lib.commit(global_state)
		sync.unlock(&lib_mutex)
		frame_timer_end(&frame_timers, start_time)
		rl.EndDrawing()

		dt = rl.GetFrameTime()

		sync.atomic_store(&should_exit, !should_run)

	}
	fmt.println("clean game artifacts")
	game_lib.exit(global_state)
	thread.join(&t)
	fmt.println("thread control recieved")
}
