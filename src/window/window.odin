package window

import "../"
import "../jupyter"
import "../logging"
import "../ui"
import "core:fmt"
import "core:time"
import rl "vendor:raylib"

Window :: struct {
	window_width:  i32,
	window_height: i32,
	window_title:  cstring,
	menu:          ui.MenuBar,
	notebook:      Maybe(jupyter.Notebook),
}

SCREEN_HEIGHT :: 768
SCREEN_WIDTH :: 1024

test :: proc() {
	fmt.printfln("button pressed")
}

build :: proc(window_width: i32, window_height: i32) -> Window {
	logger: []logging.Logger
	menu := ui.MenuBar{}
	menu.background = {52, 62, 77, 0}
	menu.items = {}
	file_button := ui.create_labeled_button("File", test)
	append(&menu.items, file_button)
	notebook := jupyter.Notebook{}
	cell := jupyter.create_code_cell()
	append(&notebook.cells, cell)
	return {window_width, window_height, "Asgard", menu, notebook}
}

start :: proc(ctx: ^src.Context, win: ^Window) {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Asgard")
	defer rl.CloseWindow()
	rl.MaximizeWindow()
	rl.SetTargetFPS(60)
	rl.GuiLoadStyleDefault()

	for !rl.WindowShouldClose() { 	// Detect window close button or ESC key
		ctx.dt = rl.GetFrameTime()
		mouse_pos := rl.GetMousePosition()
		{
			rl.BeginDrawing()
			rl.ClearBackground(rl.Color{32, 31, 41, 255})
			for &item in win.menu.items {
				if (rl.CheckCollisionPointRec(mouse_pos, item.rect)) {
					if (!item.hovering) {
						ui.on_hover(&item)
						break
					}
				} else {
					item.hovering = false
				}
			}
			ui.draw_menu(ctx, &win.menu)
			nb, ok := win.notebook.?
			mouse_on_text := false
			if ok {
				cell_iter: for &cell in nb.cells {
					#partial switch &c in cell {
					case jupyter.CodeCell:
						mouse_on_text = rl.CheckCollisionPointRec(mouse_pos, c.rect)
						break cell_iter
					}
				}
				fmt.printfln("mouse_on_text: %v", mouse_on_text)
				if mouse_on_text {
					rl.SetMouseCursor(rl.MouseCursor.IBEAM)
				} else {
					rl.SetMouseCursor(rl.MouseCursor.DEFAULT)
				}
				jupyter.draw_notebook(&nb)
			}

		}
		rl.EndDrawing()
	}
}
