package UiKitPrimitive

import state "../state"
import style "../style"
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

/*
// box model
+-------------------------------------------------------+
|                        MARGIN                         |
|  +-----------------------------------------------+    |
|  |                    BORDER                     |    |
|  |  +---------------------------------------+    |    |
|  |  |                PADDING                |    |    |
|  |  |  +-------------------------------+    |    |    |
|  |  |  |            CONTENT            |    |    |    |
|  |  |  +-------------------------------+    |    |    |
|  |  +---------------------------------------+    |    |
|  +-----------------------------------------------+    |
+-------------------------------------------------------+

container_rect
border_rect
content_rect
*/

/*
for width and height we will currently only do border box
*/

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
	isClicked:      bool,
	container_rect: rl.Rectangle,
	border_rect:    rl.Rectangle,
	content_rect:   rl.Rectangle,
}

Style :: style.Style_Param


Element :: proc(
	id: state.Cid,
	pos: [2]f32,
	content: Content,
	mousePointer: rl.Vector2,
	uiState: ^state.UIState = nil,
	pass: Pass = Pass.Paint,
	style_str: string,
	debug_border: bool = false,
) -> Return {
	style_param := style.parse_style_string(style_str)
	defer delete(style_param)

	fontSize := f32(25)
	result: Return
	uiState := uiState
	if (uiState == nil) {
		uiState = &state.uiState
	}
	// style struct
	isHover := uiState.hover == id
	isFocus := uiState.focus == id
	isActive := uiState.active == id
	st := style.generate_style_struct(style_param, isHover, isFocus, isActive)
	defer free(st)

	pl := st.pl.? or_else f32(0)
	pr := st.pr.? or_else f32(0)
	pb := st.pb.? or_else f32(0)
	pt := st.pt.? or_else f32(0)
	ml := st.mr.? or_else f32(0)
	mr := st.mr.? or_else f32(0)
	mb := st.mb.? or_else f32(0)
	mt := st.mt.? or_else f32(0)
	h := st.h.? or_else f32(0)
	w := st.w.? or_else f32(0)
	bg_color := st.bg_color.? or_else rl.WHITE
	text_color := st.text_color.? or_else rl.BLACK
	text_size := st.text_size.? or_else f32(10)
	border_color := st.border_color.? or_else rl.BLACK
	border_width := st.border_width.? or_else f32(1)


	// layout calculation - all box model rectangle will be calculated

	// container rect position - (main invisible reactangle with margin and everything)
	container_pos := pos

	// border rect position
	border_pos := rl.Vector2{container_pos.x + ml, container_pos.y + mt}

	// content rect position
	content_pos := rl.Vector2{border_pos.x + border_width + pl, border_pos.y + border_width + pt}

	// content rect width height
	content_wh: rl.Vector2
	switch val in content {
	case string:
		cs := strings.clone_to_cstring(val, context.allocator)
		content_wh = rl.MeasureTextEx(state.font, cs, fontSize, 2)
	case cstring:
		content_wh = rl.MeasureTextEx(state.font, val, fontSize, 2)
	case rl.Texture:
		content_wh = rl.Vector2{f32(val.width), f32(val.height)}
	}

	// border rect width height
	border_wh := rl.Vector2 {
		content_wh.x + pl + pr + 2 * border_width,
		content_wh.y + pb + pt + 2 * border_width,
	}

	// container rect width height
	container_wh := rl.Vector2{border_wh.x + ml + mr, border_wh.y + mb + mt}

	// reactangle calculation
	container_rect := rl.Rectangle {
		container_pos.x,
		container_pos.y,
		container_wh.x,
		container_wh.y,
	}
	border_rect := rl.Rectangle{border_pos.x, border_pos.y, border_wh.x, border_wh.y}
	content_rect := rl.Rectangle{content_pos.x, content_pos.y, content_wh.x, content_wh.y}
	result.border_rect = border_rect
	result.content_rect = content_rect
	result.container_rect = container_rect

	if (pass == .Layout) do return result

	// paint Phase
	result.isClicked = false

	// input state handling
	if uiState.active == id {
		if rl.IsMouseButtonReleased(.LEFT) {
			if uiState.hover == id do result.isClicked = true
			uiState.active = state.CidEmpty
		}
	} else if uiState.hover == id {
		if rl.IsMouseButtonPressed(.LEFT) do uiState.active = id
		// if element is clicked it will also come into focus
		// it will remain focused until a new element claims it or mouse is clicked outside the element
		// TODO(vimal): The clicked outside case need to done in the frame loop itself at the starting of the loop check its feasiblity
		uiState.focus = id
	}
	if rl.CheckCollisionPointRec(mousePointer, border_rect) && uiState.active == state.CidEmpty {
		uiState.hover = id
	} else {
		if uiState.hover == id do uiState.hover = state.CidEmpty
		if (uiState.focus == id && rl.IsMouseButtonPressed(.LEFT)) {
			uiState.focus = state.CidEmpty
		}
	}

	// painting the screen
	if debug_border {
		rl.DrawRectangleLinesEx(container_rect, 1, rl.RED)
	}
	rl.DrawRectangleRec(border_rect, bg_color)
	if border_width > 0 {
		rl.DrawRectangleLinesEx(border_rect, border_width, border_color)
	}
	// if uiState.hover == id {
	// 	// rl.DrawRectangleRec(button_rec, style.hover)
	// } else {
	// 	// rl.DrawRectangleRec(button_rec, style.backgroundColour)
	// 	rl.DrawRectangleRec(button_rec, rl.GREEN)
	// }
	// // rl.DrawRectangleLinesEx(button_rec, 2, style.borderColour)
	// rl.DrawRectangleLinesEx(button_rec, 2, rl.BLACK)
	switch val in content {
	case string:
		cs := strings.clone_to_cstring(val, context.allocator)
		rl.DrawTextEx(state.font, cs, content_pos, fontSize, 2, rl.RED)
	// rl.DrawTextEx(state.font, cs, content_pos, fontSize, 2, style.fontColour)
	case cstring:
		rl.DrawTextEx(state.font, val, content_pos, fontSize, 2, rl.RED)
	case rl.Texture:
		rl.DrawTextureEx(val, content_pos, 0, 1, rl.WHITE)
	}
	return result
}
