import os
import sdl

struct VBoy {
mut:
	// Emulator components
	cpu  Cpu
	ppu  Ppu
	cart Cart
	ram  Ram
  io   Io
  timer Timer
	// Emulator states
	paused  bool
	running bool
	tick    u64
}

fn main() {
	args := os.args.clone()
	if args.len == 1 {
		println('Missing parameter: rom_path')
		return
	} else if args.len > 2 {
		println('Too many parameters, only specify rom_path')
		return
	}

	// SDL initialization
	println('Starting SDL')
	mut sdl_ctx := Sdl_context{}
	if sdl_ctx.init() == false {
		println('Error initalizing SDL')
		return
	} else {
		println('SDL initialized succesfully')
	}

	// VBoy initialization
	println('Starting VBoy')
	mut vboy := VBoy{}

	// Cart initialization
	println('Loading ROM file: ${args[1]}')
	if !vboy.cart.load_rom(args[1]) {
		println('Error loading rom: ${args[1]}')
		return
	} else {
		println('Rom loaded succesfully')
	}

	// Cpu initialization
	println('Initializing CPU')
	vboy.cpu.init()
	vboy.cpu.vboy = &vboy
	println('CPU initialized succesfully')

	// Starting emulation
	println('Starting emulation')
	vboy.running = true
	vboy.paused = true

	// Main loop
	for vboy.running {
		if vboy.paused {
			delay(10)
		} else {
			vboy.cpu.print()
			vboy.cpu.step()
		}
		event := sdl.Event{}
		for 0 < sdl.poll_event(&event) {
			match event.@type {
				.quit {	return }				
				.keydown { sdl_ctx.handle_keydown(event) }
				.keyup { sdl_ctx.handle_keyup(event) }
				else {}
			}
			if sdl_ctx.quit { return }
		}
	}
}

// quite useless but prevent from importing sdl in each file
fn delay(ms u32) {
	sdl.delay(ms)
}
