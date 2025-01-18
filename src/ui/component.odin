package ui

Component :: union {
	Button,
	Label,
	TextArea,
}

draw_component :: proc(component: ^Component) {
	#partial switch &itm in component {
	case Button:
		draw_button(&itm)
		break
	case Label:
		draw_label(&itm)
		break
	case TextArea:
		draw_textarea(&itm)
		break
	}
}
