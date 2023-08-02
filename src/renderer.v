import sdl

const (
	screen_width  = 320
	screen_height = 280
)

struct SdlContext {
	width  int = screen_width
	height int = screen_height

	window   &sdl.Window   = sdl.null
	renderer &sdl.Renderer = sdl.null
}

fn (mut ctx SdlContext) init() bool {
	sdl.init(sdl.init_video)
	sdl.create_window_and_renderer(ctx.width, ctx.height, 0, &ctx.window, &ctx.renderer)
	sdl.set_window_title(ctx.window, 'VBoy'.str)
	return true
}

fn (mut ctx SdlContext) handle_input() {
}
