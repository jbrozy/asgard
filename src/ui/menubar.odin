package ui

import ".."
import rl "vendor:raylib"

MenuBar :: struct {
	background: rl.Color,
	items:      [dynamic]Button,
}

draw_menu :: proc(ctx: ^src.Context, menu_bar: ^MenuBar) {
	for &menu_item in menu_bar.items {
		draw_button(ctx, &menu_item)
	}
}
