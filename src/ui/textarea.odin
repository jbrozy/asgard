package ui

TextArea :: struct {
	text_input:      string,
	textarea_height: i32,
	textarea_width:  i32,
	x:               f32,
	y:               f32,
}

draw_textarea :: proc(textarea: ^TextArea) {
}
