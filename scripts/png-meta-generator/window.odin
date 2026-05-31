package PngMetaGenerator
import "core:math/linalg"
import "core:strings"
import rl "vendor:raylib"


Window :: struct {
	using bounds:    rl.Rectangle,
	title:           string,
	open:            bool,
	focused:         rl.Rectangle,
	is_exit_focused: bool,
	content:         proc(),
}

update_window :: proc(window: ^Window, g_pos_matrix: matrix[3, 3]f32) {
	title_height := f32(30)

	close_btn := rl.Rectangle {
		window.bounds.x + window.bounds.width - 25,
		window.bounds.y + 5,
		20,
		20,
	}

	mouse := rl.GetMousePosition()
	mouse_normalised: rl.Vector3
	mouse_normalised = {mouse.x, mouse.y, 1}
	mouse_normalised = linalg.inverse(g_pos_matrix) * mouse_normalised
	window.focused = {
		height = 40,
		width  = 40,
		x      = mouse_normalised.x,
		y      = mouse_normalised.y,
	}

	if rl.CheckCollisionPointRec(mouse_normalised.xy, close_btn) &&
	   rl.IsMouseButtonPressed(.LEFT) {
		window.open = false
	}

	if rl.CheckCollisionPointRec(mouse_normalised.xy, close_btn) {
		window.is_exit_focused = true
	} else {
		window.is_exit_focused = false
	}
	_ = title_height
}

draw_window :: proc(window: Window, draw_content: proc(window: Window)) {
	if (!window.open) {
		return
	}
	title_height := f32(30)

	// Main window
	rl.DrawRectangleRec(window.bounds, rl.LIGHTGRAY)
	rl.DrawRectangleLinesEx(window.bounds, 2, rl.BLACK)

	// Title bar
	title_bar := rl.Rectangle{window.bounds.x, window.bounds.y, window.bounds.width, title_height}

	rl.DrawRectangleRec(title_bar, rl.DARKGRAY)

	// Title
	rl.DrawText(
		strings.clone_to_cstring(window.title),
		i32(window.bounds.x + 10),
		i32(window.bounds.y + 7),
		16,
		rl.WHITE,
	)

	// Close button
	close_btn := rl.Rectangle {
		window.bounds.x + window.bounds.width - 25,
		window.bounds.y + 5,
		20,
		20,
	}

	rl.DrawRectangleRec(window.focused, rl.BLUE)
	rl.DrawRectangleRec(close_btn, window.is_exit_focused ? rl.GREEN : rl.RED)

	rl.DrawText("X", i32(close_btn.x + 5), i32(close_btn.y + 2), 16, rl.WHITE)

	draw_content(window)
}
