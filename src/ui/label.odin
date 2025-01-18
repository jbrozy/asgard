package ui

import SDL "vendor:sdl2"

Label :: struct {
	x:            f32,
	y:            f32,
	label_width:  i32,
	label_height: i32,
	label_text:   string,
}

draw_label :: proc(label: ^Label) {
	// flags: u32, width, height, depth: c.int, Rmask, Gmask, Bmask, Amask: u32
	surface := SDL.CreateRGBSurface(
		0,
		label.label_width,
		label.label_height,
		255,
		255,
		255,
		255,
		0,
	)

	rect := SDL.Rect{}
	rect.x = 0
	rect.y = 0
	rect.w = label.label_width
	rect.h = label.label_height
}
