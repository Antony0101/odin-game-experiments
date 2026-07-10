package textures

import "core:math"
//---------------------------------------------------------------
// Linear interpolation
//---------------------------------------------------------------
lerp :: proc(a, b: f32, t: f32) -> f32 {
	return a + (b - a) * t
}

//---------------------------------------------------------------
// Clamp
//---------------------------------------------------------------
clamp :: proc(v, min_v, max_v: f32) -> f32 {
	if v < min_v do return min_v
	if v > max_v do return max_v
	return v
}

//---------------------------------------------------------------
// Value noise
//---------------------------------------------------------------
value_noise :: proc(x, y: f32) -> f32 {

	xi := int(math.floor(x))
	yi := int(math.floor(y))

	xf := x - f32(xi)
	yf := y - f32(yi)

	hash :: proc(x, y: int) -> f32 {
		n := x * 374761393 + y * 668265263
		n = (n ~ (n >> 13)) * 1274126177
		n = n ~ (n >> 16)

		return f32(n & 0xffff) / 65535.0
	}

	v00 := hash(xi, yi)
	v10 := hash(xi + 1, yi)
	v01 := hash(xi, yi + 1)
	v11 := hash(xi + 1, yi + 1)

	sx := xf * xf * (3.0 - 2.0 * xf)
	sy := yf * yf * (3.0 - 2.0 * yf)

	ix0 := lerp(v00, v10, sx)
	ix1 := lerp(v01, v11, sx)

	return lerp(ix0, ix1, sy)
}

//---------------------------------------------------------------
// Fractal noise
//---------------------------------------------------------------
fbm :: proc(x, y: f32) -> f32 {

	value: f32 = 0
	amplitude: f32 = 0.5
	frequency: f32 = 1.0

	for i in 0 ..< 4 {
		value += amplitude * value_noise(x * frequency, y * frequency)
		frequency *= 2
		amplitude *= 0.5
	}

	return value
}

SEED: u64 : 123
