package jupyter

Notebook :: struct {
	notebook_title: string,
	cells:          map[^Cell]int,
}

get_cell :: proc(notebook: ^Notebook) -> ^Cell {
	for cell in notebook.cells {
		if cell.focus {
			return cell
		}
	}
	return nil
}
