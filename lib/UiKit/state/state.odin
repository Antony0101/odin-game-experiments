package UiKitState

// import "core:strings"
import rl "vendor:raylib"

Cid :: u32

CidEmpty: u32 : 0

UIState :: struct {
	// element is active in a sense that mouse is pressed down on this element
	active: Cid,
	// element is focused or currently active in a sense that interaction from keyboard other is will result on this element
	focus:  Cid,
	// hot or hover state
	hover:  Cid,
}

uiState: UIState = {
	focus = 0,
	hover = 0,
}

font: rl.Font
