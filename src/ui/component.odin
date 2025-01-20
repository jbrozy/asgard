package ui

import "../"
import "core:fmt"
import SDL "vendor:sdl2"

Component :: union {
	Button,
	Label,
	TextArea,
}

draw_component :: proc(ctx: ^src.Context, component: Component) {
	switch &itm in component {
	case Button:
		draw_button(ctx, &itm)
		break
	case Label:
		draw_label(&itm)
		break
	case TextArea:
		draw_textarea(ctx, &itm)
		break
	}
}
