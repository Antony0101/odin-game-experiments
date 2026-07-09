package textures

import "../../shared"
import "core:math"
import rl "vendor:raylib"

draw_textureList :: proc(g_state: ^shared.Global_State, dt: f32) {
	side :: 80
	view := &g_state.game_state.view
	player := &g_state.game_state.player
	rl.ClearBackground(rl.WHITE)

	keyPressed := rl.GetKeyPressed()
	if keyPressed == .DOWN || keyPressed == .UP || keyPressed == .LEFT || keyPressed == .RIGHT {
		if keyPressed == .DOWN do player.y = player.y + side
		else if keyPressed == .UP do player.y = player.y - side
		else if keyPressed == .LEFT do player.x = player.x - side
		else if keyPressed == .RIGHT do player.x = player.x + side
	}

	if rl.IsKeyPressed(.O) {
		player.isMoving = !player.isMoving
	}

	if rl.IsKeyPressed(.R) {
		player.pos = {0, 0}
		player.nextpos = {0, 0}
		view.target = {0, 0}
		view.zoom = 1
		return
	}

	rl.BeginMode2D(view^)
	for y in 0 ..< 1 {
		for x in 0 ..< g_state.system.texture_count {
			rl.DrawTextureEx(
				g_state.system.textures[x].texture,
				rl.Vector2{f32(x * side), f32(y * side)},
				0,
				0.25,
				rl.WHITE,
			)
		}
	}
	// player draw
	rl.DrawRectangleLines(i32(player.x), i32(player.y), side, side, rl.ORANGE)
	if (player.isMoving) {
		index := u16(math.floor(player.x / side))
		if index < g_state.system.texture_count {
			rl.DrawTexture(g_state.system.textures[index].texture, 200, 200, rl.WHITE)
		}
	}
	rl.EndMode2D()
}
