package PngMetaGenerator

import rl "vendor:raylib"

ContentData :: struct {
	texture: rl.Texture,
}

content_data: ContentData = {}

window_content :: proc(window: Window) {
	// Content
	// rl.DrawText(
	// 	"Player Inventory",
	// 	i32(window.bounds.x + 20),
	// 	i32(window.bounds.y + 60),
	// 	20,
	// 	rl.BLACK,
	// )

	// rl.DrawText("- Sword", i32(window.bounds.x + 20), i32(window.bounds.y + 90), 18, rl.BLACK)

	// rl.DrawText("- Shield", i32(window.bounds.x + 20), i32(window.bounds.y + 120), 18, rl.BLACK)
	if (content_data.texture.id == 0) {
		rl.DrawText("No image loaded", i32(window.x + 20), i32(window.y + 60), 20, rl.BLACK)
		return
	}
	rl.DrawTexture(content_data.texture, i32(window.x + 20), i32(window.y + 40), rl.WHITE)
}
