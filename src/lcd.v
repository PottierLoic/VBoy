const colors = [u32(0xFFFFFFFF), u32(0xFFAAAAAA), u32(0xFF555555), u32(0xFF000000)]

enum Lcd_modes {
	hblank
	vblank
	oam
	xfer
}

struct Lcd {
mut:
	lcdc u8
	lcds u8
	scroll_y u8
	scroll_x u8
	ly u8
	ly_compare u8
	dma u8
	bg_palette u8
	obj_palette[2] u8
	win_y u8
	win_x u8

	bg_colors[4] u32
	sp1_colors[4] u32
	sp2_colors[4] u32
}

fn (mut lcd Lcd) init() {
	lcd.lcdc = 0x91
	lcd.bg_palette = 0xFC
	lcd.obj_palette[0], lcd.obj_palette[1] = u8(0xFF), u8(0xFF)

	for i in 0 .. 4 {
		lcd.bg_colors[i] = colors[i]
		lcd.sp1_colors[i] = colors[i]
		lcd.sp2_colors[i] = colors[i]
	}
}