package platform_dev

import "../../shared"
import "core:dynlib"
import "core:log"
import "core:math"
import "core:os"
import "core:path/filepath"
import "core:sync"
import "core:thread"
import "core:time"
import rl "vendor:raylib"

// Contants
Game_Lib_Path :: "./game"
Game_Lib_Ex :: ".so"
LogFile :: "./logs/frame_log.txt"


// main structs and global vars
// TODO(antony0101): check for unwanted race conditions as this boolean is used in reload thread
should_lib_reload := false
should_exit := false

Game_Lib :: struct {
	lib:    dynlib.Library,
	init:   shared.game_init,
	loop:   shared.game_loop,
	commit: shared.game_commit,
	exit:   shared.game_exit,
}

game_lib: Game_Lib

Frame_Timers :: struct {
	sum_time:      f32,
	max_time:      f32,
	min_time:      f32,
	count:         i16,
	global_couter: u64,
}
dt: f32


lib_path: string

frame_timer_begin :: proc(frame_timers: ^Frame_Timers) {
	if frame_timers.count >= 300 {
		log.info("current frame counter:", frame_timers.global_couter)
		log.info("avg frame time:", frame_timers.sum_time / f32(frame_timers.count), "\u03BCs")
		log.info("min frame time:", frame_timers.min_time, "\u03BCs")
		log.info("max frame time:", frame_timers.max_time, "\u03BCs")
		frame_timers.count = 0
		frame_timers.max_time = 0
		frame_timers.min_time = math.F32_MAX
		frame_timers.sum_time = 0
	}
}

frame_timer_end :: proc(frame_timers: ^Frame_Timers, start_time: time.Time) -> f32 {
	elapsed_time_micro_seconds := f32(time.since(start_time)) / 1000
	frame_timers.max_time = max(frame_timers.max_time, elapsed_time_micro_seconds)
	frame_timers.min_time = min(frame_timers.min_time, elapsed_time_micro_seconds)
	frame_timers.sum_time += elapsed_time_micro_seconds
	frame_timers.count += 1
	frame_timers.global_couter += 1
	return elapsed_time_micro_seconds
}

init :: proc(gs: ^shared.Global_State) {
	// init the raylib
	rl.SetConfigFlags({.VSYNC_HINT, .WINDOW_RESIZABLE, .WINDOW_TOPMOST})
	rl.InitWindow(1600, 900, "prototype")
	rl.SetWindowPosition(200, 200)

	// setup the global state
	gs.pf.flogger = frame_log
	gs.pf.floggerf = frame_logf
}


main :: proc() {
	// update the cwd
	exe_path := os.args[0]
	exe_dir := filepath.dir(string(exe_path))
	os.set_working_directory(exe_dir)
	// setup loggers
	//frame ring logger (this will also create logs directory if not created)
	logHandler := frame_logger_setup(LogFile)
	handle, err := os.open(
		"logs/logs.txt",
		os.O_RDWR | os.O_APPEND | os.O_CREATE,
		os.Permissions_Read_All + {.Write_User},
	)
	assert(err == nil, "Cannot open log file")

	file_logger := log.create_file_logger(handle)
	// This closes the file handle
	defer log.destroy_file_logger(file_logger)

	console_logger := log.create_console_logger()
	defer log.destroy_console_logger(console_logger)

	multi_logger := log.create_multi_logger(console_logger, file_logger)
	defer log.destroy_multi_logger(multi_logger)

	context.logger = multi_logger

	log.info("current working dir:", exe_dir)
	frame_timers := Frame_Timers {
		min_time = math.F32_MAX,
	}


	// start the check and build thread for hor reloading
	check_and_build_thread: thread.Thread
	check_and_build_thread = thread.create_and_start(worker_proc, context)^


	// load the game lib
	load_or_update_game(Game_Lib_Path, &game_lib)

	// setup Global State and complete initialization
	global_state := new(shared.Global_State)
	init(global_state)
	game_lib.init(global_state)

	should_run := true

	for should_run {
		global_state.frameId = frame_timers.global_couter

		// reload game lib if changes are detected by worker thread
		if should_lib_reload {
			load_or_update_game(Game_Lib_Path, &game_lib)
			should_lib_reload = false
		}
		start_time := time.now()
		frame_timer_begin(&frame_timers)
		frame_log(frame_timers.global_couter, .Info, "frame begin")

		should_run = game_lib.loop(global_state, dt)
		rl.BeginDrawing()
		game_lib.commit(global_state)
		time_micro_sec := frame_timer_end(&frame_timers, start_time)
		rl.EndDrawing()

		dt = rl.GetFrameTime()
		// counter -1 because counter get updated in frame_time_end proc
		frame_logf(
			frame_timers.global_couter - 1,
			.Info,
			"frame end, dt:%v, time:%v\u03BCs ",
			dt,
			time_micro_sec,
		)

		sync.atomic_store(&should_exit, !should_run)

	}
	// write frame logs
	frame_dump_to_file(logHandler)
	log.info("cleaning game artifacts")
	game_lib.exit(global_state)
	thread.join(&check_and_build_thread)
	log.info("thread control recieved from reload thread")
}
