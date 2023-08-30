module vboy

const colors = [u32(0xFFFFFFFF), u32(0xFFAAAAAA), u32(0xFF555555), u32(0xFF000000)]

pub enum Lcd_modes {
	hblank
	vblank
	oam
	xfer
}

pub struct Lcd {
pub mut:
	lcdc        u8
	lcds        u8
	scroll_y    u8
	scroll_x    u8
	ly          u8
	ly_compare  u8
	dma         u8
	bg_palette  u8
	obj_palette [2]u8
	win_y       u8
	win_x       u8
	bg_colors   [4]u32
	sp1_colors  [4]u32
	sp2_colors  [4]u32
}

pub fn (mut lcd Lcd) init() {
	lcd.lcdc = 0x91
	lcd.bg_palette = 0xFC
	lcd.obj_palette[0], lcd.obj_palette[1] = u8(0xFF), u8(0xFF)

	for i in 0 .. 4 {
		lcd.bg_colors[i] = colors[i]
		lcd.sp1_colors[i] = colors[i]
		lcd.sp2_colors[i] = colors[i]
	}
}

pub fn (lcd Lcd) read(address u16) u8 {
	return match address {
		0xFF40 { lcd.lcdc }
		0xFF41 { lcd.lcds }
		0xFF42 { lcd.scroll_y }
		0xFF43 { lcd.scroll_x }
		0xFF44 { lcd.ly }
		0xFF45 { lcd.ly_compare }
		0xFF46 { lcd.dma }
		0xFF47 { lcd.bg_palette }
		0xFF48...0xFF49 { lcd.obj_palette[address - 0xFF48] }
		0xFF4A { lcd.win_y }
		0xFF4B { lcd.win_x }
		else { panic('invalid lcd read on address: ${address}') }
	}
}

pub fn (mut lcd Lcd) color_update(data u8, address u16) {
	match address {
		0xFF47 {
			lcd.bg_colors[0] = colors[data & 0b11]
			lcd.bg_colors[1] = colors[(data >> 2) & 0b11]
			lcd.bg_colors[2] = colors[(data >> 4) & 0b11]
			lcd.bg_colors[3] = colors[(data >> 6) & 0b11]
		}
		0xFF48 {
			lcd.sp1_colors[0] = colors[data & 0b11]
			lcd.sp1_colors[1] = colors[(data >> 2) & 0b11]
			lcd.sp1_colors[2] = colors[(data >> 4) & 0b11]
			lcd.sp1_colors[3] = colors[(data >> 6) & 0b11]
		}
		0xFF49 {
			lcd.sp2_colors[0] = colors[data & 0b11]
			lcd.sp2_colors[1] = colors[(data >> 2) & 0b11]
			lcd.sp2_colors[2] = colors[(data >> 4) & 0b11]
			lcd.sp2_colors[3] = colors[(data >> 6) & 0b11]
		}
		else {
			panic('Not supported palette address: ${address}')
		}
	}
}

pub fn (mut lcd Lcd) write(address u16, value u8) {
	match address {
		0xFF40 { lcd.lcdc = value }
		0xFF41 { lcd.lcds = value }
		0xFF42 { lcd.scroll_y = value }
		0xFF43 { lcd.scroll_x = value }
		0xFF44 { lcd.ly = value }
		0xFF45 { lcd.ly_compare = value }
		0xFF46 { /* TODO: DMA should start here */ }
		0xFF47 ... 0xFF49 { lcd.color_update(value, address) }
		0xFF48 { /* TODO: set colors */ }
		0xFF4A { lcd.win_y = value }
		0xFF4B { lcd.win_x = value }
		else { panic("invalid lcd write on address: ${address}") }
	}
}
