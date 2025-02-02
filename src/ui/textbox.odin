package ui

import "core:fmt"
import "vendor:microui"

TextBox :: struct {
	text:          [1024]u8,
	text_len:      int,
	scroll_offset: int,
	cursor_pos:    int,
	multiline:     bool,
	focus:         bool,
	using rect:    microui.Rect,
}

create_textbox :: proc(multiline: bool = false) -> TextBox {
	return TextBox {
		text = {},
		text_len = 0,
		scroll_offset = 0,
		cursor_pos = 0,
		multiline = multiline,
		focus = false,
	}
}

update_textbox :: proc(ctx: ^microui.Context, textbox: ^TextBox) -> (changed: bool) {
	tb := textbox
	id := microui.get_id(ctx, &tb, size_of(textbox))

	// Handle focus
	if microui.mouse_over(ctx, tb.rect) && ctx.mouse_pressed_bits == {.LEFT} {
		ctx.focus_id = id
		tb.focus = !tb.focus
	} else if ctx.focus_id != id {
		tb.focus = false
	}

	// Draw background
	bg_color := tb.focus
	microui.draw_rect(ctx, tb.rect, microui.Color{220, 220, 220, 255})

	// Handle text input when focused
	if tb.focus {
		fmt.printfln("%v", tb.focus)
		// Handle text input
		if len(ctx.text_input.buf) > 0 {
			input := ctx.text_input.buf[:len(ctx.text_input.buf[:])]
			for ch in input {
				if tb.text_len < len(tb.text) {
					tb.text[tb.text_len] = u8(ch)
					tb.text_len += 1
					changed = true
				}
			}
		}
	}

	// Draw text
	if tb.text_len > 0 {
		text_str := string(tb.text[:tb.text_len])
		text_pos := microui.Vec2{tb.rect.x + 5, tb.rect.y + (tb.rect.h - 18) / 2}
		microui.draw_text(ctx, microui.Font{}, text_str, text_pos, microui.Color{0, 0, 0, 255})
	}

	// Update control state
	microui.update_control(ctx, id, tb.rect)

	return changed
}

// Helper function to get the current text content
get_text :: proc(textbox: ^TextBox) -> string {
	return string(textbox.text[:textbox.text_len])
}

