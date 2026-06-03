package atlasViewer

import rl "vendor:raylib"
import "views/mainPage"

draw :: proc() {
	rl.ClearBackground(rl.WHITE)
	mainPage.draw()
}
