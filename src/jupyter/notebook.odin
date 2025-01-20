package jupyter

import "core:fmt"

Notebook :: struct {
	notebook_title: string,
	cells:          [dynamic]Cell,
}

get_cell :: proc(notebook: ^Notebook) -> ^Cell {
	for cell in notebook.cells {
		// if c.focus {
		// 	return cell
		// }
	}
	return nil
}

draw_notebook :: proc(notebook: ^Notebook) {
	for &cell in notebook.cells {
		fmt.printfln("%v", cell)
		#partial switch c in &cell {
		case CodeCell:
			draw_cell(&cell)
		}
	}
}
