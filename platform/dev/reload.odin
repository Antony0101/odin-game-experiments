package platform_dev
import "base:intrinsics"
import "core:dynlib"
import "core:fmt"
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
		"src",
		"-build-mode:shared",
		"-debug",
		"-out:output/game.so",
		"-define:RAYLIB_SHARED=true",
	}

	fd := inotify_init1(posix.O_NONBLOCK)
	// TODO(antony0101): implement recursive watch
	inotify_add_watch(fd, "./src", IN_MODIFY | IN_CREATE | IN_DELETE)

	fd_handle := new(os.File)
	for !sync.atomic_load(&should_exit) {
		// do work
		n := posix.read(posix.FD(fd), &buf[0], len(buf))
		// TODO(antony0101): handle the events properly to check whether it needs full restart or just update function swapping
		if n > 0 {
			fmt.println("something changed")
			b_state, b_stdout, b_stderr, b_err := os.process_exec(
				{command = command},
				context.allocator,
			)
			fmt.println(b_stdout)

			fmt.println("hg1")
			old_lib := game_lib
			fmt.println("hg2")
			updated_lib := load_game(lib_path)
			fmt.println("hh1")
			sync.lock(&lib_mutex)
			fmt.println("hh2")
			game_lib = updated_lib
			fmt.println("hh3")
			sync.unlock(&lib_mutex)
			fmt.println("hh4")
			unload_game(&old_lib)
			fmt.println("hh5")
		} else do fmt.println("no changes")
		fmt.println("thread running")
		time.sleep(1 * time.Second)
	}
	fmt.println("thread exiting")
}

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


unload_game :: proc(code: ^Game_Code) {
	dynlib.unload_library(code.lib)
}
