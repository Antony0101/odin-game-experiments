package UiKit

import p "./primitive"
import state "./state"
import rl "vendor:raylib"

should_run := true
main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(900, 900, "prototype")
	rl.SetTargetFPS(60)
	state.font = rl.GetFontDefault()
	for should_run {
		if rl.WindowShouldClose() {
			should_run = false
		}
		rl.BeginDrawing()
		mousePointer := rl.GetMousePosition()
		p.Element(
			2,
			[2]f32{100, 100},
			cstring("hello world"),
			mousePointer,
			nil,
			.Paint,
			"pt-10 pb-25 bg-yellow hover:bg-#1122ff hover:border-red hover:border-5",
		)
		p.Element(
			3,
			[2]f32{300, 100},
			cstring("hello sample"),
			mousePointer,
			nil,
			.Paint,
			"pr-10 pl-50 m-15",
		)
		rl.ClearBackground(rl.WHITE)
		rl.EndDrawing()
	}
}
