package main

import "../shared"
import rl "vendor:raylib"

SPEED: f32 = 80

update :: proc(main_data: ^shared.Game_State, dt: f32) {
	if rl.IsKeyDown(.DOWN) {
		main_data.position.y = min(720, main_data.position.y + SPEED * dt)
	}
	if rl.IsKeyDown(.UP) {
		main_data.position.y = max(0, main_data.position.y - SPEED * dt)
	}
	if rl.IsKeyDown(.RIGHT) {
		main_data.position.x = min(1280, main_data.position.x + SPEED * dt)
	}
	if rl.IsKeyDown(.LEFT) {
		main_data.position.x = max(0, main_data.position.x - SPEED * dt)
	}
}
