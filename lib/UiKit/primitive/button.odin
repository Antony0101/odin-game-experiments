package UiKitPrimitive

import state "../state"
import "core:strings"
import rl "vendor:raylib"

Content :: union #no_nil {
	string,
	cstring,
	rl.Texture,
}

Pass :: enum {
	Layout,
	Paint,
}

@(private = "file")
Return :: struct {
	isClicked: bool,
	width:     f32,
	height:    f32,
}

Style :: struct {
	padding:          f32,
	fontSize:         f32,
	fontColour:       rl.Color,
	borderColour:     rl.Color,
	backgroundColour: rl.Color,
	hover:            rl.Color,
}

default_style: Style = {
	padding          = 10,
	fontSize         = 20,
	fontColour       = rl.BLACK,
	backgroundColour = rl.BEIGE,
	borderColour     = rl.BLACK,
	hover            = rl.WHITE,
}


Button :: proc(
	id: state.Cid,
	pos: [2]f32,
	content: Content,
	mousePointer: rl.Vector2,
	uiState: ^state.UIState = nil,
	pass: Pass = Pass.Paint,
	style: Style = default_style,
) -> Return {
	fontSize := style.fontSize
	result: Return
	uiState := uiState
	if (uiState == nil) {
		uiState = &state.uiState
	}
	// layout calculation
	switch val in content {
	case string:
		cs := strings.clone_to_cstring(val, context.allocator)
		vec := rl.MeasureTextEx(state.font, cs, fontSize, 2)
		result.width = vec.x
		result.height = vec.y
	case cstring:
		vec := rl.MeasureTextEx(state.font, val, fontSize, 2)
		result.width = vec.x
		result.height = vec.y
	case rl.Texture:
		result.width = f32(val.width)
		result.height = f32(val.height)
	}
	content_pos := pos + f32(style.padding)
	if (pass == .Layout) do return result
	result.isClicked = false
	button_rec := rl.Rectangle {
		pos.x,
		pos.y,
		result.width + 2 * f32(style.padding),
		result.height + 2 * f32(style.padding),
	}

	// input state handling
	if uiState.active == id {
		if rl.IsMouseButtonReleased(.LEFT) {
			if uiState.hot == id do result.isClicked = false
			uiState.active = state.CidEmpty
		}
	} else if uiState.hot == id {
		if rl.IsMouseButtonPressed(.LEFT) do uiState.active = id
	}
	if rl.CheckCollisionPointRec(mousePointer, button_rec) && uiState.active == state.CidEmpty {
		uiState.hot = id
	} else {
		uiState.hot = state.CidEmpty
	}

	// painting the screen
	if uiState.hot == id {
		rl.DrawRectangleRec(button_rec, style.hover)
	} else {
		rl.DrawRectangleRec(button_rec, style.backgroundColour)
	}
	rl.DrawRectangleLinesEx(button_rec, 2, style.borderColour)
	switch val in content {
	case string:
		cs := strings.clone_to_cstring(val, context.allocator)
		rl.DrawTextEx(state.font, cs, content_pos, fontSize, 2, style.fontColour)
	case cstring:
		rl.DrawTextEx(state.font, val, content_pos, fontSize, 2, style.fontColour)
	case rl.Texture:
		rl.DrawTextureEx(val, content_pos, 0, 1, rl.WHITE)
	}
	return result
}
