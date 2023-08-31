module vboy

pub struct Ram {
pub mut:	
	wram [0x2000]u8
	hram [0x80]u8
}

pub fn (ram Ram) read_wram(address u16) u8 {
	if address >= 0x2000 - 0xC000 {
		panic('Invalid wram address: ${address}')
	}
	return ram.wram[address - 0xC000]
}

pub fn (mut ram Ram) write_wram(address u16, value u8) {
	ram.wram[address - 0xC000] = value
}

pub fn (ram Ram) read_hram(address u16) u8 {
	return ram.hram[address - 0xFF80]
}

pub fn (mut ram Ram) write_hram(address u16, value u8) {
	ram.hram[address - 0xFF80] = value
}
