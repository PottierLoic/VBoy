import os
import sdl

struct VBoy {
mut:
  // Emulator components
  cart Cart
  cpu Cpu
  ppu Ppu

  // Emulator states
  paused bool
  running bool
  tick u64
}

fn main() {
  sdl.init(sdl.init_video)
	window := sdl.create_window('VBoy'.str, 300, 300, 500, 300, 0)
	renderer := sdl.create_renderer(window, -1, u32(sdl.RendererFlags.accelerated) | u32(sdl.RendererFlags.presentvsync))

  args := os.args.clone()
  if args.len == 1 {
    println("Missing parameter: rom_path.")
    return
  } else if args.len > 2 {
    println("Too many parameters, only specify rom_path.")
    return
  }

  println("Starting VBoy")
  mut vboy := VBoy{}

  /* Cart initialization */
  println("Loading ROM file: ${args[1]}")
  if !vboy.cart.load_rom(args[1]) {
    println("Error loading rom: ${args[1]}")
    return
  } else { println("Rom loaded succesfully") }


  /* Cpu initialization */
  println("Initializing CPU")
  vboy.cpu.init()
  vboy.cpu.vboy = &vboy
  println("CPU initialized succesfully")

  /* Starting emulation */
  println("Starting emulation")
  vboy.running = true

  /* Cpu loop */
  for vboy.running {
    if vboy.paused { delay(10) } else {
      vboy.cpu.print()
      vboy.cpu.step()
    }
    sdl.set_render_draw_color(renderer, 255, 255, 255, 255)
		sdl.render_clear(renderer)
		sdl.render_present(renderer)
  }

  sdl.destroy_renderer(renderer)
	sdl.destroy_window(window)
	sdl.quit()
}

fn delay(ms u32) {
  sdl.delay(ms)
}