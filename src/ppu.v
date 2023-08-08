enum States {
	tile
	data_0
	data_1
	idle
	push
}

struct Oam {
	y                   u8
	x                   u8
	tile_index          u8
	flag_cgb_palette_nb u8
	flag_cgb_vram       u8
	flag_palette_nb     u8
	flag_x_flip         u8
	flag_y_flip         u8
	flag_bg             u8
}

struct Ppu {
	oam          [40]Oam
	vram         [0x2000]u8
	sprite_count u8
	// current sprites
	// mem for list
	window_line u8
	curr_frame  u32
	buffer      u32
}

fn (mut ppu Ppu) ppu_tick() {
	// Check mode and call the right ppu function
}

fn (ppu Ppu) read_oam(address u8) {}

fn (mut ppu Ppu) write_oam(address u8, value u8) {}

fn (ppu Ppu) read_vram(address u8) {
	return ppu.wram[address - 0x8000]
}

fn (mut ppu Ppu) write_vram(address u8, value u8) {
	ppu.wram[address - 0x8000] = value
}
