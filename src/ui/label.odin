package ui

import SDL "vendor:sdl2"

Label :: struct {
	text:       string,
	using rect: SDL.Rect,
}

draw_label :: proc(label: ^Label) {
	// flags: u32, width, height, depth: c.int, Rmask, Gmask, Bmask, Amask: u32
	surface := SDL.CreateRGBSurface(0, label.rect.w, label.rect.h, 255, 255, 255, 255, 0)
}
