package jupyter

import ui "../ui"
import "core:fmt"
import mu "vendor:microui"

Notebook :: struct {
    title:       string,
    cells:       [dynamic]Cell,
    using frame: ui.Frame,
}

add_cell :: proc(notebook: ^Notebook) {
    append(&notebook.cells, Cell{})
}

remove_cell :: proc(ctx: ^mu.Context, notebook: ^Notebook, cell_index: i32) {
    remove_range(&notebook.cells, cell_index, cell_index + 1)
}

draw :: proc(ctx: ^mu.Context, notebook: ^Notebook) {
    if (mu.begin_window(ctx, notebook.title, notebook.frame.rect, {.NO_RESIZE, .NO_CLOSE})) {
        nb := notebook
        for &cell, i in nb.cells {
            cell_id := fmt.tprintf("cell_%d", i)
            mu.push_id(ctx, cell_id)
            
            mu.layout_row(ctx, {-1, 200, 50})
            mu.layout_height(ctx, 200)
            cell_rect := mu.layout_next(ctx)
            mu.draw_rect(ctx, cell_rect, ctx.style.colors[.TEXT])
            mu.layout_set_next(ctx, cell_rect, false)
            
            tb := ui.create_textbox(true)
            tb.rect = mu.layout_next(ctx)
            ui.update_textbox(ctx, &tb)
            
            mu.layout_row(ctx, {200, 50})
            mu.button(ctx, "Run")
            delete_button_rect := mu.layout_next(ctx)
            mu.layout_set_next(
                ctx,
                mu.Rect {
                    delete_button_rect.x * 3,
                    delete_button_rect.y,
                    delete_button_rect.w,
                    delete_button_rect.h,
                },
                false,
            )
            
            if mu.button(ctx, "Delete") == {.SUBMIT} {
                remove_cell(ctx, notebook, i32(i))
            }
            
            mu.pop_id(ctx)
        }
        
        mu.layout_row(ctx, {-1})
        if mu.button(ctx, "Add new Cell") == {.SUBMIT} {
            add_cell(notebook)
        }
        mu.end_window(ctx)
    }
}
