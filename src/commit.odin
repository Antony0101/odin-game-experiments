package game
import "../shared"
import rl "vendor:raylib"

@(export)
game_commit :: proc(g_state: ^shared.Global_State) {
	screen_w := f32(rl.GetScreenWidth())
	screen_h := f32(rl.GetScreenHeight())

	scale := min(screen_w / SCREEN_X_DIM, screen_h / SCREEN_Y_DIM)

	draw_w := f32(SCREEN_X_DIM) * scale
	draw_h := f32(SCREEN_Y_DIM) * scale

	offset_x := (screen_w - draw_w) * 0.5
	offset_y := (screen_h - draw_h) * 0.5

	source := rl.Rectangle {
		0,
		0,
		f32(g_state.system.target.texture.width),
		-f32(g_state.system.target.texture.height), // flip Y
	}

	dest := rl.Rectangle{offset_x, offset_y, draw_w, draw_h}
	rl.ClearBackground(rl.BLACK)

	rl.DrawTexturePro(g_state.system.target.texture, source, dest, {0, 0}, 0, rl.WHITE)
}
