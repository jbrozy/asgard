package window

import "../ui"
import "core:fmt"
import "core:reflect"
import "core:time"
import SDL "vendor:sdl2"

MenuScene :: struct {
	scene_name: string,
	components: [dynamic]ui.Component,
}

create_button_fn :: proc() {
}

Scene :: union {
	MenuScene,
}

build_menu_scene :: proc() -> Scene {
	create_button := ui.Button{"test", create_button_fn, SDL.Rect{50, 50, 125, 30}}
	menu_scene := MenuScene {
		scene_name = "Main Menu",
		components = [dynamic]ui.Component{create_button},
	}

	fmt.printfln("%v", menu_scene)

	return menu_scene
}

render_current_scene :: proc(renderer: ^SDL.Renderer, win: ^Window) {
	if (win^).scene == nil {
		fmt.printf("Scene was null\n")
		return
	}

	#partial switch &s in (win^).scene {
	case MenuScene:
		current_time := time.now()
		if len(s.components) == 0 || s.components == nil {
			fmt.println("Components slice is empty!")
		} else {
			for &component in s.components {
				ui.draw_component(renderer, component)
			}
			break
		}
	}
}
