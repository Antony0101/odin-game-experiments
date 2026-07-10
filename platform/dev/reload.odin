package platform_dev

import "base:intrinsics"
import "core:dynlib"
import "core:fmt"
import "core:log"
import "core:math/rand"
import "core:os"
import "core:strings"
import "core:sync"
import "core:sys/posix"
import "core:time"

foreign import libc "system:c"

@(default_calling_convention = "c")
foreign libc {
	inotify_init1 :: proc(_: int) -> int ---
	inotify_add_watch :: proc(fd: int, pathname: cstring, mask: u32) -> int ---
	// read :: proc(fd: int, buf: rawptr, count: int) -> int ---
}

IN_MODIFY := u32(0x00000002)
IN_CREATE := u32(0x00000100)
IN_DELETE := u32(0x00000200)
// posix.O_NONBLOCK

worker_proc :: proc() {
	buf: [4096]u8
	command := []string {
		"odin",
		"build",
		"../src",
		"-build-mode:shared",
		"-debug",
		"-out:game.so",
		"-define:RAYLIB_SHARED=true",
	}

	fd := inotify_init1(posix.O_NONBLOCK)
	// TODO(antony0101): implement recursive watch
	inotify_add_watch(fd, "../src", IN_MODIFY | IN_CREATE | IN_DELETE)

	fd_handle := new(os.File)
	log.info("starting game code reloader thread")
	for !sync.atomic_load(&should_exit) {
		// do work
		n := posix.read(posix.FD(fd), &buf[0], len(buf))
		// TODO(antony0101): handle the events properly to check whether it needs full restart or just update function swapping
		if n > 0 || force_lib_build {
			if force_lib_build do log.info("force building game code")
			else do log.info("changes detected in game code")
			force_lib_build = false
			// os.file_de
			b_state, b_stdout, b_stderr, b_err := os.process_exec(
				{command = command},
				context.allocator,
			)
			if (b_state.success) {
				log.info("game code build successful")
				should_lib_reload = true
			} else {
				log.error("game code build failed")
				out_str := string(b_stdout)
				err_str := string(b_stderr)
				log.info("p state", b_state)
				log.info("stdout", out_str)
				log.error("stderr", err_str)
			}
		}
		time.sleep(1 * time.Second)
	}
	log.info("game code reloader thread exiting")
}

load_or_update_game :: proc(path: string, game_code: ^Game_Lib) {
	log.info("loading the updated game lib")
	fileVer := fmt.tprint(rand.int31_max(1000))
	copy_path := strings.concatenate([]string{path, fileVer, Game_Lib_Ex})
	copy_err := os.copy_file(copy_path, strings.concatenate([]string{path, Game_Lib_Ex}))
	assert(copy_err == os.ERROR_NONE, "lib copy is not successful")

	count, ok := dynlib.initialize_symbols(game_code, copy_path, "game_", "lib")

	assert(
		count == intrinsics.type_struct_field_count(Game_Lib) - 1,
		"game lib all symbols are not loaded",
	)

}


unload_game :: proc(code: ^Game_Lib) {
	dynlib.unload_library(code.lib)
}
