import sdl

const (
	screen_width  = 320
	screen_height = 280
)

struct Sdl_context {
mut:
	width  int = screen_width
	height int = screen_height

	window   &sdl.Window   = sdl.null
	renderer &sdl.Renderer = sdl.null

	quit bool
}

fn (mut ctx Sdl_context) init() bool {
	sdl.init(sdl.init_video)
	sdl.create_window_and_renderer(ctx.width, ctx.height, 0, &ctx.window, &ctx.renderer)
	sdl.set_window_title(ctx.window, 'VBoy'.str)
	return true
}

fn (mut ctx Sdl_context) handle_keydown(event sdl.Event) {
	key := unsafe { sdl.KeyCode(event.key.keysym.sym) }
	if key == sdl.KeyCode.escape {
		ctx.quit = true
	} else if key == sdl.KeyCode.w || key == sdl.KeyCode.up {
		println("Up key pressed")
	} else if key == sdl.KeyCode.s || key == sdl.KeyCode.down {
		println("Down key pressed")
	} else if key == sdl.KeyCode.a || key == sdl.KeyCode.left {
		println("Left key pressed")
	} else if key == sdl.KeyCode.d || key == sdl.KeyCode.right {
		println("Right key pressed")
	} else if key == sdl.KeyCode.u {
		println("B key pressed")
	} else if key == sdl.KeyCode.i {
		println("A key pressed")
	} else if key == sdl.KeyCode.n {
		println("Select key pressed")
	} else if key == sdl.KeyCode.m {
		println("Start key pressed")
	}
}

fn (mut ctx Sdl_context) handle_keyup(event sdl.Event) {
	
}
