module vboy

pub enum States {
	tile
	data_0
	data_1
	idle
	push
}

pub struct Oam {
pub mut:
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

pub struct Ppu {
pub mut:
	oam          [40]Oam
	vram         [0x2000]u8
	sprite_count u8
	// current sprites
	// mem for list
	window_line u8
	curr_frame  u32
	buffer      u32
}

pub fn (mut ppu Ppu) ppu_tick() {
	// Check mode and call the right ppu function
}

pub fn (ppu Ppu) read_oam(address u16) u8 {
	return 0
}

pub fn (mut ppu Ppu) write_oam(address u16, value u8) {}

pub fn (ppu Ppu) read_vram(address u16) u8 {
	return ppu.vram[address - 0x8000]
}

pub fn (mut ppu Ppu) write_vram(address u16, value u8) {
	ppu.vram[address - 0x8000] = value
}
