package blgui

import "core:fmt"
import "core:mem"
import "core:strings"
import "vendor:sdl2"
import "errors"

// Descriptions of procs are found at their definitions. 
// Comments are removed from `main` as logic is abstracted into procs.
main :: proc() {
    err := InitSDL2()
    if err != nil {
        fmt.println(errors.get_error_message(err))
        return
    }
    defer sdl2.Quit()

    window: ^sdl2.Window; window, err = CreateWindow(
        title = "Test",
        width = 800,
        height = 600
    )
    if err != nil {
        fmt.println(errors.get_error_message(err))
        return
    }
    defer sdl2.DestroyWindow(window)

    renderer: ^sdl2.Renderer; renderer, err = CreateRenderer(window, -1)
    if err != nil {
        fmt.println(errors.get_error_message(err))
        return
    }
    defer sdl2.DestroyRenderer(renderer)

    // Start the mainloop
    running := true
    for running {
        // Handle Events
        event: sdl2.Event
        for sdl2.PollEvent(&event) {
            if event.type == sdl2.EventType.QUIT do running = false
        }
        // Clear Screen with a Color
        sdl2.SetRenderDrawColor(renderer, 255, 255, 255, 255) // RGBA color
        sdl2.RenderClear(renderer)

        // Present Renderer
        sdl2.RenderPresent(renderer)
    }
}

// Initializes SDL2.
// Should be followed with `defer sdl2.Quit()`.
InitSDL2 :: proc() -> errors.Error {
    using errors
    if sdl2.Init(sdl2.INIT_VIDEO) != 0 {
        parts := []string{"Failed to initialize SDL2: ", string(sdl2.GetError())}
        message := strings.concatenate(parts)
        sdl_err := create_error(SDL2_Error_Kind.Init_Error, message)
        return sdl_err
    }
    return nil
}

// Create an SDL2 Window.
// Should be followed with `defer sdl2.DestroyWindow(<returned window>)`.
CreateWindow :: proc(
    title:  string = "Untitled Window",
    x:      i32 = sdl2.WINDOWPOS_CENTERED,
    y:      i32 = sdl2.WINDOWPOS_CENTERED,
    width:  i32 = 800,
    height: i32 = 600
) -> (^sdl2.Window, errors.Error) {
    using errors
    title := strings.clone_to_cstring(title)
    defer mem.free(rawptr(title))
    window := sdl2.CreateWindow(
        title, x, y, width, height,
        sdl2.WINDOW_SHOWN // Flags
    )
    err: Error = nil
    if window == nil {
        parts := []string{"Failed to create window: ", string(sdl2.GetError())}
        message := strings.concatenate(parts)
        err = create_error(SDL2_Error_Kind.Window_Error, message)
        // falls through to return. `window` is still nil.
    }
    return window, err
}

// Create a Renderer.
// Should be followed with `defer sdl2.DestroyRenderer(<returned renderer>)`.
CreateRenderer :: proc(
    window: ^sdl2.Window,
    index:  i32 = -1,
    flags: sdl2.RendererFlags = sdl2.RENDERER_ACCELERATED
) -> (^sdl2.Renderer, errors.Error) {
    using errors
    renderer := sdl2.CreateRenderer(window, index, flags)
    err: Error = nil
    if renderer == nil {
        parts := []string{"Failed to create renderer:", string(sdl2.GetError())}
        message := strings.concatenate(parts)
        err = create_error(SDL2_Error_Kind.Renderer_Error, message)
        // falls through to return. `renderer` is still nil.
    }
    return renderer, err
}