module main

import os
import gg
import gx

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

	mut context := gg.new_context(
		bg_color: gx.rgb(255, 255, 255)
		width: screen_width * scale
		height: screen_height * scale
		window_title: 'Vboy'
		frame_fn: frame
	)

	// Emulator initialization
	println('Starting VBoy')
	mut emu := Emulator{}

	// Cart initialization
	println('Loading ROM file: ${args[1]}')
	if !emu.cart.load_rom(args[1]) {
		println('Error loading rom: ${args[1]}')
		return
	} else {
		println('Rom loaded succesfully')
	}

	// Cpu initialization
	println('Initializing CPU')
	emu.cpu.init(&emu)
	println('CPU initialized succesfully')

	context.run()
}

fn frame(mut ctx gg.Context) {
	// TODO: Need to ensure we do 65905 cycle between each frame update
	// and 60 frame update each seconds
	ctx.begin()

	ctx.end()
}
