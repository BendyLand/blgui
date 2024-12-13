package buttons

import "core:fmt"
import "vendor:sdl2"

Button :: struct {
    rect: sdl2.Rect,
    color: sdl2.Color,
    text: string,
    on_click: proc(), // Callback function
}

DrawButton :: proc(renderer: ^sdl2.Renderer, button: Button) {
    sdl2.SetRenderDrawColor(renderer, button.color.r, button.color.g, button.color.b, button.color.a)
    rect := button.rect // Create a mutable variable
    sdl2.RenderFillRect(renderer, &rect)  
}

IsMouseInside :: proc(x, y: i32, rect: sdl2.Rect) -> bool {
    return x >= rect.x && x <= rect.x + rect.w && y >= rect.y && y <= rect.y + rect.h
}

HandleButtonEvent :: proc(button: ^Button, event: ^sdl2.Event) {
    if event.type == sdl2.EventType.MOUSEBUTTONDOWN {
        mouse_event := cast(^sdl2.MouseButtonEvent)(event)
        if IsMouseInside(mouse_event.x, mouse_event.y, button.rect) {
            button.on_click()
        }
    }
}
