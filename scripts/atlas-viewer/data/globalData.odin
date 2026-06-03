package data

import rl "vendor:raylib"

FrameDimentions :: struct {
	x: f32,
	y: f32,
	w: f32,
	h: f32,
}
Frame :: struct {
	name:  string,
	frame: FrameDimentions,
}


AtlasJson :: struct {
	frames: []Frame,
}

atlasNames: [dynamic]cstring
atlasFrames: [dynamic]rl.Rectangle

atlasJsonData: AtlasJson

atlasTexture: rl.Texture
