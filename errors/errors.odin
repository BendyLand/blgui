package errors

Error :: union {
    SDL2_Error,
}

SDL2_Error :: struct {
    kind:    SDL2_Error_Kind,
    message: string,
}

SDL2_Error_Kind :: enum {
    Init_Error,
    Window_Error,
    Renderer_Error,
}

create_sdl2_error :: proc(
    kind:    SDL2_Error_Kind, 
    message: string
) -> SDL2_Error {
    return SDL2_Error{ kind, message }
}

create_error :: proc{ create_sdl2_error }

get_error_message :: proc(err: Error) -> string {
    result: string
    switch _ in err {
    case SDL2_Error:
        result = err.(SDL2_Error).message
    case:
        result = "I don't even know what you did."
    }
    return result
}