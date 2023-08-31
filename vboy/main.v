module vboy

import os
import sdl
import time

const (
	debug_mode = true
)

pub struct VBoy {
pub mut:
	// Emulator components
	cpu  Cpu
	ppu  Ppu
	cart Cart
	ram  Ram
  io   Io
  timer Timer
	lcd Lcd

	// Emulator states
	paused  bool
	running bool
	tick    u64
}

pub fn run() {
	args := os.args.clone()
	if args.len == 1 {
		println('Missing parameters: rom_path')
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
	sdl_ctx.vboy = &vboy

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

	// Timer Initialization
	vboy.timer.vboy = &vboy

	// IO Initialization
	vboy.io.vboy = &vboy

	// Starting emulation
	println('Starting emulation')
	vboy.running = true
	vboy.paused = debug_mode

	mut instruction_count := 0
	mut time_count := time.new_stopwatch()
	mut sec_timer := time.new_stopwatch()

	// Main loop
	for vboy.running {
		if vboy.paused {
			delay(10)
		} else {
			vboy.cpu.step()
			instruction_count++
		}
		event := sdl.Event{}
		if sec_timer.elapsed().milliseconds() > 16 { // Used to check input every ~1/60 seconds and reduce lag.
			for 0 < sdl.poll_event(&event) {
				match event.@type {
					.quit {
						println("The program took ${time_count.elapsed().milliseconds()} ms to run ${instruction_count} instructions.")
						return
					}
					.keydown { sdl_ctx.handle_keydown(event) }
					.keyup { sdl_ctx.handle_keyup(event) }
					else {}
				}
				if sdl_ctx.quit { return }
			}
			sec_timer.restart()
		}
	}
}

// Execute one processing step at a time.
pub fn (mut vboy VBoy) debug_step() {
	println("Manual step.")
	vboy.cpu.step()
}

// Increment the differents timers.
pub fn (mut vboy VBoy) timer_cycle(amount int) {
	for _ in 0 .. amount {
		for _ in 0 .. 4 {
			vboy.tick++
			vboy.timer.timer_tick()
			// PPU tick once it is done
		}
		// DMA tick when it is done
	}
}

pub fn delay(ms u32) {
	sdl.delay(ms)
}
