package jupyter

Notebook :: struct {
	notebook_title: string,
	cells:          map[Cell]int,
}
