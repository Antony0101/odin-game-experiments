package UiKitState

// import "core:strings"
import rl "vendor:raylib"

Cid :: u32

CidEmpty: u32 : 0

UIState :: struct {
	active: Cid,
	hot:    Cid,
}

uiState: UIState = {
	active = 0,
	hot    = 0,
}

font: rl.Font
