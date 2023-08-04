struct Oam {
	y u8
	x u8
	tile_index u8
	flag_cgb_palette_nb u8
	flag_cgb_vram u8
	flag_palette_nb u8
	flag_x_flip u8
	flag_y_flip u8
	flag_bg u8
}

struct Ppu {
	oam[40] Oam
	vram[0x2000] u8

	sprite_count u8
}

fn (mut ppu Ppu) init() {}

fn (mut ppu Ppu) ppu_tick() {}

fn (ppu Ppu) read_oam(address u8) {}
fn (mut ppu Ppu) write_oam(address u8, value u8) {}

fn (ppu Ppu) read_vram(address u8) {}
fn (mut ppu Ppu) write_vram(address u8, value u8) {}