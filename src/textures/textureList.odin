package textures

import "../../shared"
import "core:math"
import rl "vendor:raylib"

draw_textureList :: proc(g_state: ^shared.Global_State, dt: f32) {
	col_count :: 4
	side :: 80
	view := &g_state.t_state.view
	selectedTile := &g_state.t_state.selectedTile
	textureW := &g_state.t_state.textureWindow
	rl.ClearBackground(rl.WHITE)

	row_count := g_state.system.texture_count / col_count

	keyPressed := rl.GetKeyPressed()
	if keyPressed == .DOWN || keyPressed == .UP || keyPressed == .LEFT || keyPressed == .RIGHT {
		if keyPressed == .DOWN do selectedTile.y = selectedTile.y + 1
		else if keyPressed == .UP do selectedTile.y = selectedTile.y - 1
		else if keyPressed == .LEFT do selectedTile.x = selectedTile.x - 1
		else if keyPressed == .RIGHT do selectedTile.x = selectedTile.x + 1
	}

	if rl.IsKeyPressed(.O) {
		textureW.isOpen = !textureW.isOpen
	}

	if rl.IsKeyPressed(.R) {
		selectedTile^ = {0, 0}
		view.target = {0, 0}
		view.zoom = 1
		return
	}

	rl.BeginMode2D(view^)
	for y in 0 ..< row_count + 1 {
		for x in 0 ..< col_count + 1 {
			if int(y) * int(col_count) + x < int(g_state.system.texture_count) {
				rl.DrawTextureEx(
					g_state.system.textures[int(y) * int(col_count) + x].texture,
					rl.Vector2{f32(x * side), f32(y * side)},
					0,
					0.25,
					rl.WHITE,
				)}
		}
	}
	// player draw
	rl.DrawRectangleLines(
		i32(selectedTile.x * side),
		i32(selectedTile.y * side),
		side,
		side,
		rl.ORANGE,
	)


	rl.EndMode2D()
	// mouse pointer location
	mp := rl.GetMousePosition()
	rl.DrawRectangle(i32(mp.x), i32(mp.y), 30, 30, rl.BROWN)

	if int(selectedTile.y) * int(col_count) + int(selectedTile.x) <
		   int(g_state.system.texture_count) &&
	   textureW.isOpen {
		t := &g_state.system.textures[int(selectedTile.y) * int(col_count) + int(selectedTile.x)]
		popup_window(g_state, dt, t)
	}
}


popup_window :: proc(g_state: ^shared.Global_State, dt: f32, texture: ^shared.TextureStruct) {
	textureW := &g_state.t_state.textureWindow
	mp := rl.GetMousePosition()
	popupRectangle := rl.Rectangle {
		textureW.veiw.offset.x,
		textureW.veiw.offset.y,
		f32(texture.texture.width),
		f32(texture.texture.height),
	}
	if rl.IsMouseButtonPressed(.LEFT) && rl.CheckCollisionPointRec(mp, popupRectangle) {
		textureW.isDrag = true
		textureW.dragoff.x = mp.x - textureW.veiw.offset.x
		textureW.dragoff.y = mp.y - textureW.veiw.offset.y
	}
	if rl.IsMouseButtonDown(.LEFT) && textureW.isDrag {
		textureW.veiw.offset.x = mp.x - textureW.dragoff.x
		textureW.veiw.offset.y = mp.y - textureW.dragoff.y

	}
	if rl.IsMouseButtonReleased(.LEFT) && textureW.isDrag do textureW.isDrag = false
	rl.BeginMode2D(textureW.veiw)
	rl.DrawTexture(texture.texture, 0, 0, rl.WHITE)
	rl.EndMode2D()
}
