package main

import "ui"
import "window"

main :: proc() {
	scene := window.build_menu_scene()
	win := window.build(1024, 768, &scene)
	window.render(&win)
}
