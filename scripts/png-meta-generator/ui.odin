package PngMetaGenerator

import rl "vendor:raylib"

Input_State :: struct {
	mouse_pos:     rl.Vector2,
	left_pressed:  bool,
	left_down:     bool,
	left_released: bool,
}

UI_Context :: struct {
	using input: Input_State,
	hot:         u64,
	active:      u64,
	focused:     u64,
}

ui_begin :: proc(ui: ^UI_Context) {
	ui.hot = 0
	ui.active = 0
	ui.focused = 0

	ui.mouse_pos = rl.GetMousePosition()
	ui.left_pressed = rl.IsMouseButtonPressed(.LEFT)
	ui.left_released = rl.IsMouseButtonReleased(.LEFT)
	ui.left_down = rl.IsMouseButtonDown(.LEFT)
}
