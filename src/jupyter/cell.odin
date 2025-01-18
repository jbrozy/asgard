package jupyter

import "core:fmt"


Cell :: struct {
	content: string,
	output:  string,
}

run :: proc(cell: ^Cell) {
	fmt.println("Running Cell")
}

render :: proc(cell: ^Cell) {
	fmt.println("Rendering cell")
}
