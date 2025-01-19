package ui

import "core:fmt"
import SDL "vendor:sdl2"

Component :: union {
	Button,
	Label,
	TextArea,
}

draw_component :: proc(renderer: ^SDL.Renderer, component: Component) {
	switch &itm in component {
	case Button:
		draw_button(renderer, &itm)
		break
	case Label:
		draw_label(&itm)
		break
	case TextArea:
		draw_textarea(&itm)
		break
	}
}
