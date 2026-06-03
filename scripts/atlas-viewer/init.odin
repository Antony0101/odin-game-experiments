package atlasViewer

import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"
import gd "data"
import rl "vendor:raylib"

init :: proc() {
	data, err1 := os.read_entire_file_from_path("ruins.json", context.allocator)
	if err1 != os.ERROR_NONE {
		fmt.println("Failed to read file")
		return
	}
	defer delete(data)


	err2 := json.unmarshal(data, &gd.atlasJsonData)
	if err2 != nil {
		fmt.println("JSON error:", err2)
		return
	}
	for frame in gd.atlasJsonData.frames {
		append(&gd.atlasNames, strings.clone_to_cstring(frame.name))
		append(
			&gd.atlasFrames,
			rl.Rectangle{frame.frame.x, frame.frame.y, frame.frame.w, frame.frame.h},
		)
	}
	fmt.println("SAmple", gd.atlasJsonData.frames[0].name)
	gd.atlasTexture = rl.LoadTexture("ruins.png")
}
