package jupyter

import "../ui"
import "core:fmt"
import mu "vendor:microui"
import rl "vendor:raylib"

CellBase :: struct {
	output: string,
	input:  string,
	focus:  bool,
}

CodeCell :: struct {
	using base: CellBase,
}

MarkdownCell :: struct {
	using base: CellBase,
}

RawCell :: struct {
	using base: CellBase,
}

Cell :: union {
	CodeCell,
	MarkdownCell,
	RawCell,
}
