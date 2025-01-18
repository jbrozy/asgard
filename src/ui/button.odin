package ui

import "core:fmt"
import "vendor:sdl2"

Button :: struct {
	x:             f32,
	y:             f32,
	button_width:  i32,
	button_height: i32,
	button_text:   string,
	callback_fn:   proc(),
}

draw_button :: proc(button: ^Button) {
	fmt.printfln("Drawing Button")
}
