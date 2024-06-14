module vboy

import os
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

	// VBoy initialization
	println('Starting VBoy')
	mut vb := VBoy{}

	// Cart initialization
	println('Loading ROM file: ${args[1]}')
	if !vb.cart.load_rom(args[1]) {
		println('Error loading rom: ${args[1]}')
		return
	} else {
		println('Rom loaded succesfully')
	}

	// Cpu initialization
	println('Initializing CPU')
	vb.cpu.init()
	vb.cpu.vb = &vb
	println('CPU initialized succesfully')

	// Timer Initialization
	vb.timer.vb = &vb

	// IO Initialization
	vb.io.vb = &vb

	// Starting emulation
	println('Starting emulation')
	vb.running = true
	vb.paused = debug_mode

	mut instruction_count := 0

	// Main loop
	for vb.running {
		vb.cpu.step()
		instruction_count++
	}
}

// Increment the differents timers.
pub fn (mut vb VBoy) timer_cycle(amount int) {
	for _ in 0 .. amount {
		for _ in 0 .. 4 {
			vb.tick++
			vb.timer.timer_tick()
			// PPU tick once it is done
		}
		// DMA tick when it is done
	}
}

