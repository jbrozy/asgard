package jupyter

import "../ui"
import "core:fmt"
import rl "vendor:raylib"

CellBase :: struct {
	output:     string,
	text:       cstring,
	active:     bool,
	background: rl.Color,
	using rect: rl.Rectangle,
}

CodeCell :: struct {
	using base: CellBase,
}

MarkdownCell :: struct {
	using base: CellBase,
}

Cell :: union {
	CodeCell,
	MarkdownCell,
}

on_click :: proc(cell: ^Cell) {
	#partial switch &c in cell {
	case CodeCell:
		c.base.active = c.active
		break
	}
}

create_code_cell :: proc() -> Cell {
	bg := rl.Color{52, 62, 77, 0}
	// #466070
	// #598590
	// #73acaa
	// #9ad2bf
	code_cell := CodeCell{}
	code_cell.rect = rl.Rectangle {
		x      = 100,
		y      = 400,
		width  = 500,
		height = 250,
	}
	code_cell.background = bg
	code_cell.text = ""
	return code_cell
}

run :: proc(cell: ^CodeCell) {
	fmt.println("Running Cell")
}

draw_cell :: proc(cell: ^Cell) {
	fmt.printfln("%v", cell)
	switch &c in cell {
	case CodeCell:
		id := rl.GuiTextBox(c.rect, c.text, 12, c.active)
		fmt.printfln("textbox_id: %v", id)
		break
	case MarkdownCell:
		break
	}
}

on_input :: proc(input: u8) {
}
