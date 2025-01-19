package ui

import "core:fmt"
import strings "core:strings"
import SDL "vendor:sdl2"
import ttf "vendor:sdl2/ttf"

Button :: struct {
	text:        string,
	callback_fn: proc(),
	using rect:  SDL.Rect,
}

draw_button :: proc(renderer: ^SDL.Renderer, button: ^Button) {
	SDL.SetRenderDrawColor(renderer, 255, 0, 0, 255)
	SDL.RenderFillRect(renderer, &((button^).rect))
	SDL.SetRenderDrawColor(renderer, 255, 255, 0, 255)
	SDL.RenderDrawRect(renderer, &((button^).rect))
	//     SDL_Surface *text_surface = TTF_RenderText_Solid(font, "Hello, SDL_ttf!", white);
	font_size: i32 = 0
	font := ttf.OpenFont("font/pt-mono-regular.ttf", font_size)
	if font == nil {
		fmt.printfln("font error")
		return
	}
	defer ttf.CloseFont(font)
	cstr := strings.unsafe_string_to_cstring(button.text)
	surface := ttf.RenderText_Blended(font, cstr, SDL.Color{100, 100, 100, 255})
	defer SDL.FreeSurface(surface)
	texture := SDL.CreateTextureFromSurface(renderer, surface)
	// renderer: ^Renderer, texture: ^Texture, srcrect: ^Rect, dstrect: ^Rect
	SDL.RenderCopy(renderer, texture, nil, &((button^).rect))
}
