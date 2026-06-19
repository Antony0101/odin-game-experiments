package PngAtlasGenerator

import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"
import rl "vendor:raylib"


Frame :: struct {
	x: i32,
	y: i32,
	w: i32,
	h: i32,
}

Entry :: struct {
	name:  string,
	frame: Frame,
}

Atlas_Metadata :: struct {
	frames: [dynamic]Entry,
}

OutputReferenceWidth: i32 = 500

Sprite :: struct {
	name:  string,
	image: rl.Image,
}

folder :: "desert"

main :: proc() {
	sprite_paths: [dynamic]string = {}
	dir, err01 := os.open(folder)
	if err01 != nil {
		fmt.println("err in opening the folder")
		return
	}
	defer os.close(dir)
	entries, err0 := os.read_dir(dir, -1, context.allocator)
	if err0 != nil {
		fmt.println("err in reading the folder")
		return
	}
	defer delete(entries)

	for entry in entries {
		if entry.type != .Regular {
			continue
		}

		if strings.has_suffix(entry.name, ".png") {
			fmt.print()
			path := strings.concatenate({folder, "/", entry.name})
			defer delete(path)
			// use path
			append(&sprite_paths, strings.clone(path))
		}
	}

	sprites := make([dynamic]Sprite)
	defer delete(sprites)

	atlas_width: i32 = 0
	atlas_height: i32 = 0

	// Load images and calculate atlas size
	temp_max_x: i32 = 0
	temp_max_y: i32 = 0
	for path in sprite_paths {
		img := rl.LoadImage(strings.clone_to_cstring(path))

		if img.data == nil {
			fmt.printf("Failed to load %s\n", path)
			continue
		}

		name := path

		append(&sprites, Sprite{name = name, image = img})

		temp_max_x += img.width
		temp_max_y = max(temp_max_y, img.height)

		if (temp_max_x > OutputReferenceWidth) {
			atlas_width = max(temp_max_x, atlas_width)
			temp_max_x = 0
			atlas_height = atlas_height + temp_max_y
			temp_max_y = 0
		}

	}
	atlas_height += temp_max_y
	fmt.println("atlas width: ", atlas_width, "atlas h: ", atlas_height)

	atlas := rl.GenImageColor(atlas_width, atlas_height, rl.BLANK)

	metadata := Atlas_Metadata {
		frames = make([dynamic]Entry),
	}
	defer delete(metadata.frames)

	current_x: i32 = 0
	max_y: i32 = 0
	current_y: i32 = 0

	for sprite in sprites {

		src := rl.Rectangle{0, 0, f32(sprite.image.width), f32(sprite.image.height)}

		dst := rl.Rectangle {
			f32(current_x),
			f32(current_y),
			f32(sprite.image.width),
			f32(sprite.image.height),
		}

		rl.ImageDraw(&atlas, sprite.image, src, dst, rl.WHITE)

		// metadata.frames[sprite.name] = Frame {
		// 	x = current_x,
		// 	y = 0,
		// 	w = sprite.image.width,
		// 	h = sprite.image.height,
		// }
		append(
			&metadata.frames,
			Entry {
				name = filepath.base(sprite.name),
				frame = Frame {
					x = current_x,
					y = current_y,
					w = sprite.image.width,
					h = sprite.image.height,
				},
			},
		)

		current_x += sprite.image.width
		max_y = max(max_y, sprite.image.height)
		if (current_x > OutputReferenceWidth) {
			current_y = current_y + max_y
			max_y = 0
			current_x = 0
		}
	}

	rl.ExportImage(atlas, folder + ".png")

	json_bytes, err := json.marshal(metadata)
	if err != nil {
		fmt.println("Failed to create JSON")
		return
	}

	err_o := os.write_entire_file(folder + ".json", json_bytes)
	if err_o != nil {
		fmt.println("Failed to write file:", err)
		return
	}
	fmt.println("Created atlas.png")
	fmt.println("Created atlas.json")

	for sprite in sprites {
		rl.UnloadImage(sprite.image)
	}

	rl.UnloadImage(atlas)
}
