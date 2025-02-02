package main

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strings"
import "core:unicode/utf8"
import "src/jupyter"
import mu "vendor:microui"
import rl "vendor:raylib"

CellType :: enum {
	Code,
	Markdown,
	Raw,
}

Cell :: struct {
	content:     string,
	output:      string,
	cell_type:   CellType,
	is_selected: bool,
}

state := struct {
	mu_ctx:          mu.Context,
	log_buf:         [1 << 16]byte,
	log_buf_len:     int,
	log_buf_updated: bool,
	bg:              mu.Color,
	atlas_texture:   rl.Texture2D,
	notebook:        ^jupyter.Notebook,
} {
	bg = {90, 95, 100, 255},
}

WIDTH :: 800
HEIGHT :: 600

main :: proc() {
	rl.InitWindow(WIDTH, HEIGHT, "Notebook UI")
	defer rl.CloseWindow()

	pixels := make([][4]u8, mu.DEFAULT_ATLAS_WIDTH * mu.DEFAULT_ATLAS_HEIGHT)
	for alpha, i in mu.default_atlas_alpha {
		pixels[i] = {0xff, 0xff, 0xff, alpha}
	}
	defer delete(pixels)

	image := rl.Image {
		data    = raw_data(pixels),
		width   = mu.DEFAULT_ATLAS_WIDTH,
		height  = mu.DEFAULT_ATLAS_HEIGHT,
		mipmaps = 1,
		format  = .UNCOMPRESSED_R8G8B8A8,
	}
	state.atlas_texture = rl.LoadTextureFromImage(image)
	defer rl.UnloadTexture(state.atlas_texture)

	ctx := state.mu_ctx
	mu.init(&ctx)

	ctx.text_width = mu.default_atlas_text_width
	ctx.text_height = mu.default_atlas_text_height

	rl.SetTargetFPS(30)

	nb_frame := jupyter.Notebook{}
	nb_frame.w = WIDTH
	nb_frame.h = HEIGHT
	nb_frame.x = 0
	nb_frame.y = 0
	nb_frame.title = "Test Notebook"
	jupyter.add_cell(&nb_frame)
	state.notebook = &nb_frame

	main_loop: for !rl.WindowShouldClose() {
		{ 	// text input
			text_input: [512]byte = ---
			text_input_offset := 0
			for text_input_offset < len(text_input) {
				ch := rl.GetCharPressed()
				if ch == 0 {
					break
				}
				b, w := utf8.encode_rune(ch)
				copy(text_input[text_input_offset:], b[:w])
				text_input_offset += w
			}
			mu.input_text(&ctx, string(text_input[:text_input_offset]))
		}
		// mouse coordinates
		mouse_pos := [2]i32{rl.GetMouseX(), rl.GetMouseY()}
		mu.input_mouse_move(&ctx, mouse_pos.x, mouse_pos.y)
		mu.input_scroll(&ctx, 0, i32(rl.GetMouseWheelMove() * -30))
		// mouse buttons
		@(static) buttons_to_key := [?]struct {
			rl_button: rl.MouseButton,
			mu_button: mu.Mouse,
		}{{.LEFT, .LEFT}, {.RIGHT, .RIGHT}, {.MIDDLE, .MIDDLE}}
		for button in buttons_to_key {
			if rl.IsMouseButtonPressed(button.rl_button) {
				mu.input_mouse_down(&ctx, mouse_pos.x, mouse_pos.y, button.mu_button)
			} else if rl.IsMouseButtonReleased(button.rl_button) {
				mu.input_mouse_up(&ctx, mouse_pos.x, mouse_pos.y, button.mu_button)
			}

		}
		// micro ui rendering
		render_microui(&ctx)
		render(&ctx)
	}
}

render_microui :: proc(ctx: ^mu.Context) {
	mu.begin(ctx)
	jupyter.draw(ctx, state.notebook)
	mu.end(ctx)
}

render :: proc(ctx: ^mu.Context) {
	render_texture :: proc(rect: mu.Rect, pos: [2]i32, color: mu.Color) {
		source := rl.Rectangle{f32(rect.x), f32(rect.y), f32(rect.w), f32(rect.h)}
		position := rl.Vector2{f32(pos.x), f32(pos.y)}

		rl.DrawTextureRec(state.atlas_texture, source, position, transmute(rl.Color)color)
	}
	// // raylib rendering
	rl.ClearBackground(transmute(rl.Color)state.bg)

	rl.BeginDrawing()
	rl.BeginScissorMode(0, 0, rl.GetScreenWidth(), rl.GetScreenHeight())
	command_backing: ^mu.Command
	for variant in mu.next_command_iterator(ctx, &command_backing) {
		switch cmd in variant {
		case ^mu.Command_Text:
			pos := [2]i32{cmd.pos.x, cmd.pos.y}
			for ch in cmd.str do if ch & 0xc0 != 0x80 {
				r := min(int(ch), 127)
				rect := mu.default_atlas[mu.DEFAULT_ATLAS_FONT + r]
				render_texture(rect, pos, cmd.color)
				pos.x += rect.w
			}
		case ^mu.Command_Rect:
			rl.DrawRectangle(
				cmd.rect.x,
				cmd.rect.y,
				cmd.rect.w,
				cmd.rect.h,
				transmute(rl.Color)cmd.color,
			)
		case ^mu.Command_Icon:
			rect := mu.default_atlas[cmd.id]
			x := cmd.rect.x + (cmd.rect.w - rect.w) / 2
			y := cmd.rect.y + (cmd.rect.h - rect.h) / 2
			render_texture(rect, {x, y}, cmd.color)
		case ^mu.Command_Clip:
			rl.EndScissorMode()
			rl.BeginScissorMode(cmd.rect.x, cmd.rect.y, cmd.rect.w, cmd.rect.h)
		case ^mu.Command_Jump:
			unreachable()
		}
	}
	rl.EndScissorMode()
	rl.EndDrawing()
}
