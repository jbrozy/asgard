package jupyter

import "core:fmt"

CodeCell :: struct {
	content: string,
	output:  string,
	hidden:  bool,
	focus:   bool,
}

MarkdownCell :: struct {
	content: string,
}

Cell :: union {
	CodeCell,
	MarkdownCell,
}

run :: proc(cell: ^CodeCell) {
	fmt.println("Running Cell")
}

draw_cell :: proc(cell: ^Cell) {
	switch &c in cell {
	case CodeCell:
		break
	case MarkdownCell:
		break
	}
	fmt.println("Rendering cell")
}

on_input :: proc(input: u8) {
}
