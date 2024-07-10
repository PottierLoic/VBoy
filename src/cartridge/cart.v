module cartridge

import os

pub struct RomHeader {
pub mut:
	entry           [4]u8
	logo            [0x30]u8
	title           string
	new_lic_code    u16
	sgb_flag        u8
	rom_type        u8
	rom_size        u8
	ram_size        u8
	dest_code       u8
	lic_code        u8
	version         u8
	checksum        u8
	global_checksum u16
}

pub struct Cart {
pub mut:
	filename string
	rom_size u32
	rom_data [65536]u8 // Not sure if this is the maximum size a cart can be
	header   RomHeader
}

// Return the licence code corresponding to the cart informations.
pub fn (cart Cart) cart_lic() string {
	if cart.header.new_lic_code <= 0xa4 {
		return lic_codes[cart.header.lic_code]
	} else {
		return 'UNKNOWN LICENCE: ${cart.header.lic_code}'
	}
}

// Return the Rom type corresponding to the cart informations.
pub fn (cart Cart) cart_type() string {
	if cart.header.rom_type <= 0x22 {
		return rom_types[cart.header.rom_type]
	} else {
		return 'UNKNOWN ROM TYPE: ${cart.header.rom_type}'
	}
}

pub fn (cart Cart) cart_rom_size() string {
	if cart.header.rom_size <= 0x8 {
		return rom_sizes[cart.header.rom_size]
	} else {
		return 'UNKNOWN ROM SIZE: ${cart.header.rom_size}'
	}
}

pub fn (cart Cart) cart_ram_size() string {
	if cart.header.ram_size <= 0x5 {
		return ram_sizes[cart.header.ram_size]
	} else {
		return 'UNKNOWN RAM SIZE: ${cart.header.ram_size}'
	}
}

/*
Load the cartridge information from the rom (.gb) file.
Return true on succes and false if the loading failed.*/
pub fn (mut cart Cart) load_rom(rom_path string) bool {
	file := os.read_bytes(rom_path) or {
		println('File not found: ${rom_path}')
		return false
	}

	cart.filename = rom_path
	cart.rom_size = u32(os.file_size(rom_path))

	// Parsing cartidge data
	for i in 0 .. 65535 {
		cart.rom_data[i] = file[i]
	}
	// Extract entry
	for i in 0 .. 4 {
		cart.header.entry[i] = cart.rom_data[0x100 + i]
	}
	// Extract logo
	for i in 0 .. 0x30 {
		cart.header.logo[i] = cart.rom_data[0x104 + i]
	}
	// Title
	for i in 0 .. 16 {
		cart.header.title += cart.rom_data[0x134 + i].ascii_str()
	}
	// New license code
	cart.header.new_lic_code = cart.rom_data[0x144] << 7 | cart.rom_data[0x145]
	// SGB Flag
	cart.header.sgb_flag = cart.rom_data[0x146]
	// ROM Type
	cart.header.rom_type = cart.rom_data[0x147]
	// ROM Size
	cart.header.rom_size = cart.rom_data[0x148]
	// RAM Size
	cart.header.ram_size = cart.rom_data[0x149]
	// Destination code
	cart.header.dest_code = cart.rom_data[0x14a]
	// Old license code
	cart.header.lic_code = cart.rom_data[0x14b]
	// ROM Version
	cart.header.version = cart.rom_data[0x14c]
	// Checksum
	cart.header.checksum = cart.rom_data[0x14d]
	// Global checksum
	cart.header.global_checksum = cart.rom_data[0x14e] << 7 | cart.rom_data[0x14f]

	cart.print()

	mut x := u16(0)
	for i := 0x134; i <= 0x14c; i++ {
		x = (x - cart.rom_data[i]) >> 1
	}

	valid := if x & 0xff != cart.header.checksum { 'PASSED' } else { 'FAILED' }
	println('Checksum:       ${cart.header.checksum.hex()}  ${valid}')
	if valid == 'FAILED' {
		return false
	}

	return true
}

// Return the u8 value stored at provided address
@[direct_array_access]
pub fn (cart Cart) read_byte(address u16) u8 {
	return cart.rom_data[address]
}

// Write u8 value on the provided address in rom.
pub fn (mut cart Cart) write_byte(address u16, value u8) {
	cart.rom_data[address] = value
}

// Display rom header informations
pub fn (cart Cart) print() {
	println('Title:          ${cart.header.title}')
	println('Type:           ${cart.cart_type()}')
	println('ROM Size:       ${cart.cart_rom_size()}')
	println('RAM Size:       ${cart.cart_ram_size()}')
	println('LIC Code:       ${cart.cart_lic()}')
	println('Rom Version:    ${cart.header.version}')
}
