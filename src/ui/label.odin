package ui

import "core:fmt"
import strings "core:strings"
import SDL "vendor:sdl2"
import ttf "vendor:sdl2/ttf"

Label :: struct {
	text:       cstring,
	surface:    ^SDL.Surface,
	font_size:  i32,
	texture:    ^SDL.Texture,
	font:       ^ttf.Font,
	using rect: SDL.Rect,
}

build_label :: proc(text: string) -> Label {
	font_size: i32 = 32 // Default font size
	font := ttf.OpenFont("fonts/pt-mono-regular.ttf", font_size)
	if font == nil {
		fmt.printfln("Failed to load font: %s", ttf.GetError())
		return Label{}
	}

	label := Label{}
	label.text = strings.unsafe_string_to_cstring(text)
	label.w = 125
	label.h = 25

	// Measure the text dimensions at the default font size
	width: i32 = 0
	height: i32 = 0
	ttf.SizeUTF8(font, label.text, &width, &height)

	// Calculate the ideal font size based on label width
	if label.w > 0 && width > 0 {
		ideal_font_size: f32 = f32(font_size) * f32(label.w) / f32(width)

		// Reload the font with the new font size
		font_size = i32(ideal_font_size)
		fmt.printfln("ideal size: %v", font_size)
		ttf.CloseFont(font) // Close the old font
		font = ttf.OpenFont("fonts/pt-mono-regular.ttf", font_size)
		if font == nil {
			fmt.printfln("Failed to load resized font: %s", ttf.GetError())
			return Label{}
		}

		// Re-measure the text with the resized font
		ttf.SizeUTF8(font, label.text, &width, &height)
	}

	fmt.printfln("Text dimensions: width=%v, height=%v, font_size=%v", width, height, font_size)

	// Set label dimensions
	label.w = width
	label.h = height

	// Create a surface for the text
	surface := ttf.RenderText_Blended(font, label.text, SDL.Color{255, 255, 255, 0})
	if surface == nil {
		fmt.printfln("Failed to render text: %s", ttf.GetError())
		return Label{}
	}
	label.surface = surface

	// Clean up font after use (if not needed elsewhere)
	ttf.CloseFont(font)

	return label
}

draw_label :: proc(label: ^Label) {
	// texture := SDL.CreateTextureFromSurface(renderer, label.surface)
	// SDL.RenderCopy(renderer, texture, nil, &label.rect)
}
