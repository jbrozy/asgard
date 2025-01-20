package main

import "src"
import "src/ui"
import "src/window"
import "vendor:sdl2/ttf"

main :: proc() {
	ctx := src.Context{}
	win := window.build(1024, 768)
	window.start(&ctx, &win)
}
