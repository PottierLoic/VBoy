module main

import cartridge
import gg
import gx

struct Emulator {
mut:
	// gg context
	ctx &gg.Context = unsafe { nil }
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

	emulator.ctx = gg.new_context(
		bg_color: gx.rgb(255, 255, 255)
		width: screen_width * scale
		height: screen_height * scale
		window_title: 'Vboy'
		frame_fn: frame
	)
	emulator.ctx.run()
}

// TODO: The frame function should bne called precisely each 65905 cpu cycle
// Keeping this can hav estrange behavior.
fn frame(mut ctx gg.Context) {
	// TODO: Need to ensure we do 65905 cycle between each frame update
	// and 60 frame update each seconds
	// TODO: determine if we do this here
	ctx.begin()
	ctx.draw_rect(gg.DrawRectParams{0, 0, 160, 144, gx.black, .fill, false, 0})
	ctx.show_fps()
	ctx.end()
}
