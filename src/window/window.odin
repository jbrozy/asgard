package window

import "../logging"
import "../ui"
import "core:fmt"
import "core:time"
import gl "vendor:OpenGL"
import SDL "vendor:sdl2"

Window :: struct {
	window_width:  i32,
	window_height: i32,
	window_title:  cstring,
	logger:        []logging.Logger,
	scene:         Scene,
}

build :: proc(window_width: i32, window_height: i32, scene: ^Scene) -> Window {
	logger: []logging.Logger
	return {window_width, window_height, "Asgard", logger, scene^}
}

add_scene :: proc(window: ^Window, scene: ^Scene) {
	window.scene = scene^
}

render :: proc(win: ^Window) {
	sdl_window := SDL.CreateWindow(
		(win^).window_title,
		SDL.WINDOWPOS_UNDEFINED,
		SDL.WINDOWPOS_UNDEFINED,
		(win^).window_width,
		(win^).window_height,
		{.OPENGL},
	)
	gl_context := SDL.GL_CreateContext(sdl_window)

	SDL.GL_MakeCurrent(sdl_window, gl_context)
	gl.load_up_to(3, 3, SDL.gl_set_proc_address)

	renderer := SDL.CreateRenderer(sdl_window, -1, nil)
	if renderer == nil {
		fmt.printf("Failed to create renderer\n")
		return
	}

	defer SDL.DestroyWindow(sdl_window)
	defer SDL.DestroyRenderer(renderer)

	update_interval :: 20
	running := true

	event: SDL.Event
	loop: for running {
		event: SDL.Event
		for SDL.PollEvent(&event) {
			#partial switch event.type {
			case .KEYDOWN:
				#partial switch event.key.keysym.sym {
				case .ESCAPE:
					break loop
				}
			case .QUIT:
				break loop
			}
		}

		SDL.SetRenderDrawColor(renderer, 32, 31, 41, 255) // Black
		SDL.RenderClear(renderer)

		render_current_scene(renderer, win)
		SDL.RenderPresent(renderer)

		// gl.ClearColor()
		SDL.Delay(16)
	}
}
