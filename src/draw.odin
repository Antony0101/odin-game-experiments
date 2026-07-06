package game

import "../shared"
import rl "vendor:raylib"

draw :: proc(g_state: ^shared.Global_State, dt: f32) {
	side :: 80
	view := &g_state.game_state.view
	player := &g_state.game_state.player
	rl.ClearBackground(rl.PINK)
	mtop := &player.movements.top

	keyPressed := rl.GetKeyPressed()
	if mtop^ < len(player.movements.stack) &&
	   (keyPressed == .DOWN || keyPressed == .UP || keyPressed == .LEFT || keyPressed == .RIGHT) {
		player.movements.stack[mtop^] = keyPressed
		mtop^ = min(mtop^ + 1, len(player.movements.stack))
	}
	// if rl.IsKeyPressed(.UP) do player.nextpos.y = player.y - side
	// if rl.IsKeyPressed(.LEFT) do player.nextpos.x = player.x - side
	// if rl.IsKeyPressed(.RIGHT) do player.nextpos.x = player.x + side
	if !player.isMoving && mtop^ > 0 {
		key := player.movements.stack[mtop^ - 1]
		mtop^ = max(0, mtop^ - 1)
		if key == .DOWN do player.nextpos.y = player.y + side
		else if key == .UP do player.nextpos.y = player.y - side
		else if key == .LEFT do player.nextpos.x = player.x - side
		else if key == .RIGHT do player.nextpos.x = player.x + side
	}
	if rl.IsKeyPressed(.R) {
		player.pos = {0, 0}
		player.nextpos = {0, 0}
		view.target = {0, 0}
		view.zoom = 1
		return
	}
	if rl.IsKeyPressed(.Q) {
		view.zoom += 0.2
	}
	if rl.IsKeyPressed(.W) {
		view.zoom -= 0.2
	}

	if player.y + side > view.target.y + SCREEN_Y_DIM do view.target.y += (player.y + side) - (view.target.y + SCREEN_Y_DIM)
	if player.y < view.target.y do view.target.y -= (view.target.y) - (player.y)
	if player.x + side > view.target.x + SCREEN_X_DIM do view.target.x += (player.x + side) - (view.target.x + SCREEN_X_DIM)
	if player.x < view.target.x do view.target.x -= (view.target.x) - (player.x)
	is_collided: bool = false
	rl.BeginMode2D(view^)
	for y in 0 ..< len(g_state.system.layoutmap) {
		for x in 0 ..< len(g_state.system.layoutmap[y]) {
			colour: rl.Color
			if g_state.system.layoutmap[y][x] == 0 do colour = rl.WHITE
			else do colour = rl.BLUE
			if g_state.system.layoutmap[y][x] != 0 &&
			   rl.CheckCollisionRecs(
				   rl.Rectangle{player.nextpos.x, player.nextpos.y, side, side},
				   rl.Rectangle{f32(x * side), f32(y * side), side, side},
			   ) {
				is_collided = true
				player.nextpos = player.pos
				// playerx
			}
			rl.DrawRectangle(i32(x * side), i32(y * side), side, side, colour)
		}
	}
	if (player.y < player.nextpos.y) {
		player.y = min(player.y + dt * 360, player.nextpos.y)
		player.isMoving = true
	} else if (player.y > player.nextpos.y) {
		player.y = max(player.y - dt * 360, player.nextpos.y)
		player.isMoving = true
	} else if (player.x < player.nextpos.x) {
		player.x = min(player.x + dt * 360, player.nextpos.x)
		player.isMoving = true
	} else if (player.x > player.nextpos.x) {
		player.x = max(player.x - dt * 360, player.nextpos.x)
		player.isMoving = true
	} else {
		player.isMoving = false
	}
	// if !is_collided {
	// 	player.x = playerx
	// 	player.y = playery
	// }
	// player draw
	rl.DrawRectangle(i32(player.x), i32(player.y), side, side, rl.ORANGE)
	rl.EndMode2D()
}
