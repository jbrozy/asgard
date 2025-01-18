package window

import "../ui"
import "core:fmt"
import "core:time"

BaseScene :: struct {
	scene_name: string,
	components: []ui.Component,
}

MenuScene :: struct {
	using base: BaseScene,
}

create_button_fn :: proc() {
}

Scene :: union {
	MenuScene,
}

build_menu_scene :: proc() -> Scene {
	create_button := ui.Button{50, 50, 100, 20, "test", create_button_fn}
	return (MenuScene){}
}

render_current_scene :: proc(win: ^Window) {
	if win.scene == nil {
		return
	}

	#partial switch &s in win.scene {
	case MenuScene:
		current_time := time.now()
		fmt.printf("[%v] Rendering Scene : MenuScene\n", current_time)
		for &component in s.components {
			ui.draw_component(&component)
		}
		break
	}
}
