package ui

import ".."
import strings "core:strings"
import rl "vendor:raylib"

TextArea :: struct {
	focus:      bool,
	text:       cstring,
	background: rl.Color,
	using rect: rl.Rectangle,
}

build_textarea :: proc() -> TextArea {
	textarea := TextArea{}
	textarea.focus = false
	textarea.text = "hallo"
	cstr := strings.unsafe_string_to_cstring("")
	textarea.rect = rl.Rectangle {
		x      = 250,
		y      = 250,
		width  = 640,
		height = 320,
	}
	textarea.text = cstr
	// textarea.background = rl.Color{52, 62, 77, 0}

	return textarea
}

draw_textarea :: proc(ctx: ^src.Context, textarea: ^TextArea) {
	rl.GuiTextBox(textarea.rect, textarea.text, 12, true)
}
