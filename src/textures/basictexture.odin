package textures

import "core:math"
// import "core:math/rand"
import rl "vendor:raylib"


//---------------------------------------------------------------
// Create desert image
//---------------------------------------------------------------
create_basic_texture_image :: proc(image: ^rl.Image, base_color: rl.Color, seed: u64 = 0) {

	pixels := cast([^]rl.Color)(image.data)

	// setup random generator
	// currently random number are not used
	// seed := seed
	// if seed == 0 do seed = SEED
	// gen := rand.xoshiro256_random_generator()
	// rand.reset(seed, gen)

	for y in 0 ..< image.height {
		for x in 0 ..< image.width {

			//---------------------------------------------------
			// Base color
			//---------------------------------------------------

			base := base_color

			//---------------------------------------------------
			// Fine grain
			//---------------------------------------------------

			grain := fbm(f32(x) * 0.20, f32(y) * 0.20)

			//---------------------------------------------------
			// Wind ripple
			//---------------------------------------------------

			ripple := math.sin(f32(x) * 0.45 + fbm(f32(x) * 0.08, f32(y) * 0.08) * 6.0)

			//---------------------------------------------------
			// Brightness
			//---------------------------------------------------

			brightness := grain * 20.0 + ripple * 8.0

			r := clamp(f32(base.r) + brightness, 0, 255)
			g := clamp(f32(base.g) + brightness, 0, 255)
			b := clamp(f32(base.b) + brightness, 0, 255)

			color := rl.Color{u8(r), u8(g), u8(b), 255}

			pixels[y * image.width + x] = color
		}
	}

}
