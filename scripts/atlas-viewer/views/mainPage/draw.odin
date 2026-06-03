package atlasViewerViewsMainPage

import gd "../../data"
import "core:encoding/json"
import "core:strings"
import rl "vendor:raylib"

state: struct {
	windowOpen: bool,
} = {
	windowOpen = true,
}

focus: i32 = -1
scroll: i32 = 0
active: i32 = -1


draw :: proc() {
	if state.windowOpen {
		isClose := rl.GuiWindowBox(rl.Rectangle{0, 0, 720, 480}, "main window")
		if isClose == 1 do state.windowOpen = false


		rl.GuiListViewEx(
			rl.Rectangle{0, 23, 150, 480 - 23},
			raw_data(gd.atlasNames),
			i32(len(gd.atlasNames)),
			&scroll,
			&active,
			&focus,
		)
		if active <= -1 do rl.GuiLabel(rl.Rectangle{160, 25, 100, 100}, "Select Something")
		else {
			// gg, err1 := json.marshal(gd.atlasFrames[active])
			// defer delete(gg)
			// ggs := strings.clone_to_cstring(string(gg))
			// defer delete(ggs)
			// rl.GuiLabel(rl.Rectangle{160, 25, 720, 200}, ggs)
			rl.DrawTextureRec(gd.atlasTexture, gd.atlasFrames[active], [2]f32{160, 25}, rl.WHITE)
			// rl.DrawTexture(gd.atlasTexture, 160, 25, rl.WHITE)
		}
	}
}
