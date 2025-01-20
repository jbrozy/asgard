package ui

import "../"
import "core:fmt"
import "core:math"
import strings "core:strings"
import rl "vendor:raylib"

Button :: struct {
	label:       Label,
	callback_fn: proc(),
	background:  rl.Color,
	border:      rl.Color,
	hovering:    bool,
	using rect:  rl.Rectangle,
}

create_labeled_button :: proc(text: string, callback_fn: proc()) -> Button {
	btn := Button{}
	btn.rect = rl.Rectangle{100, 100, 125, 25}
	btn.background = rl.Color{70, 96, 112, 0}
	btn.border = rl.Color{115, 172, 170, 0}
	btn.hovering = false
	btn.callback_fn = callback_fn
	gap_size: i32 = 75
	label := build_label("test")
	return btn
}

on_hover :: proc(button: ^Button) {
	button.hovering = !button.hovering
}

draw_button :: proc(ctx: ^src.Context, button: ^Button) {
	fmt.printfln("delta: %v", ctx.dt)
	roundness: f32 = 0.3
	btn := (button^)
	rl.GuiButton(btn.rect, "test")
	// if btn.hovering {
	// 	rl.DrawRectangleRounded(btn.rect, roundness, 0, rl.GREEN)
	// } else {
	// 	rl.DrawRectangleRounded(btn.rect, roundness, 0, rl.RED)
	// }
}
