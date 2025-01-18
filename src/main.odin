package main

import "ui"
import "window"

main :: proc() {
	win := window.build(1024, 768)
	scene := window.build_menu_scene()
	window.add_scene(&win, &scene)
	window.render(&win)
}
