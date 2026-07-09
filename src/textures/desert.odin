package textures

import "core:math/rand"
import rl "vendor:raylib"

SEED: u64 : 123
BASE_COLOR :: rl.Color{0xE8, 0xD2, 0x9B, 0xFF}

generateDesertTexture :: proc(image: ^rl.Image, seed: u64 = 0) {
	// setup random generator
	seed := seed
	if seed == 0 do seed = SEED
	gen := rand.xoshiro256_random_generator()

	rand.reset(seed, gen)


	// setup color
	sand_dark := rl.GetColor(0xCFA95EFF)
	sand := rl.GetColor(0xDDBB72FF)
	sand_light := rl.GetColor(0xE8CC8FFF)

	// image vars
	IHeight := image.height
	IWidth := image.width

	for y in 0 ..< IHeight {
		for x in 0 ..< IWidth {

			// Small brightness variation
			r := rand.float32(gen)

			color := sand

			if r < 0.12 {
				color = sand_dark
			} else if r > 0.88 {
				color = sand_light
			}

			rl.ImageDrawPixel(image, x, y, color)
		}
	}
}
