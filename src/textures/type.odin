package textures
import rl "vendor:raylib"


basic_textures := [?]struct {
	name:  string,
	color: rl.Color,
} {
	{"desert", rl.Color{224, 197, 125, 255}},
	{"grassland", rl.Color{76, 140, 58, 255}},
	{"dirt", rl.Color{126, 90, 60, 255}},
	{"mud", rl.Color{90, 75, 60, 255}},
	{"stone", rl.Color{120, 120, 120, 255}},
	{"snow", rl.Color{240, 243, 248, 255}},
	{"water", rl.Color{70, 150, 200, 255}},
	{"beach", rl.Color{215, 200, 145, 255}},
	{"forest", rl.Color{92, 82, 45, 255}},
	{"lava", rl.Color{255, 85, 25, 255}},
}
