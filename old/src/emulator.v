module main

import cartridge

struct Emulator {
mut:
	// Peripherals etc.
	cpu   Cpu
	cart  cartridge.Cart
	ram   Ram
	timer Timer
	// States
	running bool
}

fn (mut emulator Emulator) init(rom_path string) {
	println('Initializing VBoy')

	println('Loading ROM file: ${rom_path}')
	if !emulator.cart.load_rom(rom_path) {
		println('Error loading ROM file: ${rom_path}')
		return
	} else {
		println('Rom loaded successfully')
	}

	println('Initializing CPU')
	emulator.cpu.init(&emulator)
	println('CPU initialized successfully')

	for {
		println("cpu Step started")
		emulator.cpu.registers.print()
		emulator.cpu.step()
	}
}

