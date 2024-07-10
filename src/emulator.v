module main

import cartridge

struct Emulator {
mut:
	cpu   Cpu
	// ppu   Ppu
	cart cartridge.Cart
	ram  Ram
	// io    Io
	// timer Timer
	// lcd   Lcd
	// Emulator states
	paused  bool
	running bool
	tick    u64
}
