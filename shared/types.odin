package shared
import rl "vendor:raylib"

fColor :: [4]f32

color_f_u :: proc(color: fColor) -> rl.Color {
	t: rl.Color = {u8(color.r * 255), u8(color.g * 255), u8(color.b * 255), u8(color.a * 255)}
	return t
}

color_u_f :: proc(color: rl.Color) -> fColor {
	t: fColor = {f32(color.r) / 255, f32(color.g) / 255, f32(color.b) / 255, f32(color.a) / 255}
	return t
}

SCREEN_X_DIM :: 1280
SCREEN_Y_DIM :: 720
