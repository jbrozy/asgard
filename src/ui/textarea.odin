package ui

import SDL "vendor:sdl2"

TextArea :: struct {
	focus:      bool,
	text:       string,
	using rect: SDL.Rect,
}

draw_textarea :: proc(textarea: ^TextArea) {
}
