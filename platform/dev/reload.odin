package platform_dev
import "../../shared"
import "base:intrinsics"
import "core:dynlib"
import "core:fmt"
import "core:math/rand"
import "core:os"
import "core:strconv"
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
	for !sync.atomic_load(&should_exit) {
		// do work
		n := posix.read(posix.FD(fd), &buf[0], len(buf))
		// TODO(antony0101): handle the events properly to check whether it needs full restart or just update function swapping
		if n > 0 {
			fmt.println("something changed")
			// os.file_de
			b_state, b_stdout, b_stderr, b_err := os.process_exec(
				{command = command},
				context.allocator,
			)
			out_str := string(b_stdout)
			err_str := string(b_stderr)
			fmt.println("p state", b_state)
			fmt.println("stdout", out_str)
			fmt.println("stderr", err_str)
			fmt.println("berr", b_err)

			should_lib_reload = true
		} else do fmt.println("no changes")
		fmt.println("thread running")
		time.sleep(1 * time.Second)
	}
	fmt.println("thread exiting")
}

load_or_update_game :: proc(path: string, game_code: ^Game_Lib) {
	// time.sleep(10 * time.Second)
	fileVer := fmt.tprint(rand.int31_max(1000))
	copy_path := strings.concatenate([]string{path, fileVer, Game_Lib_Ex})
	copy_err := os.copy_file(copy_path, strings.concatenate([]string{path, Game_Lib_Ex}))
	fmt.printfln("here12")
	assert(copy_err == os.ERROR_NONE, "lib copy is not successful")

	count, ok := dynlib.initialize_symbols(game_code, copy_path, "game_", "lib")
	// if game_code.lib != nil do unload_game(game_code)
	// handle, ok := dynlib.load_library(copy_path)
	// fmt.println("here23")
	// if !ok {
	// 	fmt.printfln("Failed loading game lib: {0}", dynlib.last_error())
	// 	panic("failed loading game lib")
	// }
	// fmt.println("handle::", handle)
	// fmt.println("dddhhhh134")
	// game_code.lib = handle
	// s1_addr, s1_ok := dynlib.symbol_address(handle, "game_loop")
	// fmt.println("hereddkadjkdf")
	// if s1_ok do game_code.loop = cast(shared.game_loop)s1_addr
	// s2_addr, s2_ok := dynlib.symbol_address(handle, "game_init")
	// if s2_ok do game_code.init = cast(shared.game_init)s2_addr
	// s3_addr, s3_ok := dynlib.symbol_address(handle, "game_commit")
	// if s3_ok do game_code.commit = cast(shared.game_commit)s3_addr
	// s4_addr, s4_ok := dynlib.symbol_address(handle, "game_exit")
	// if s4_ok do game_code.exit = cast(shared.game_exit)s4_addr
	// fmt.println("dddd1324")


	assert(
		count == intrinsics.type_struct_field_count(Game_Lib) - 1,
		"game lib all symbols are not loaded",
	)

}


unload_game :: proc(code: ^Game_Lib) {
	dynlib.unload_library(code.lib)
}
