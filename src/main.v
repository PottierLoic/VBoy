module main

import os

const screen_width = 160
const screen_height = 144
const scale = 4

fn main() {
	args := os.args.clone()
	if args.len == 1 {
		println('Missing parameters: rom_path')
		return
	} else if args.len > 2 {
		println('Too many parameters, only specify rom_path')
		return
	}

	// Emulator initialization
	mut emulator := Emulator{}
	emulator.init(args[1])
}
