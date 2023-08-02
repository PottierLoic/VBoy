import os

const rom_types = [
  'ROM ONLY',
  'MBC1',
  'MBC1+RAM',
  'MBC1+RAM+BATTERY',
  '0x04 ???',
  'MBC2',
  'MBC2+BATTERY',
  '0x07 ???',
  'ROM+RAM 1',
  'ROM+RAM+BATTERY 1',
  '0x0A ???',
  'MMM01',
  'MMM01+RAM',
  'MMM01+RAM+BATTERY',
  '0x0E ???',
  'MBC3+TIMER+BATTERY',
  'MBC3+TIMER+RAM+BATTERY 2',
  'MBC3',
  'MBC3+RAM 2',
  'MBC3+RAM+BATTERY 2',
  '0x14 ???',
  '0x15 ???',
  '0x16 ???',
  '0x17 ???',
  '0x18 ???',
  'MBC5',
  'MBC5+RAM',
  'MBC5+RAM+BATTERY',
  'MBC5+RUMBLE',
  'MBC5+RUMBLE+RAM',
  'MBC5+RUMBLE+RAM+BATTERY',
  '0x1F ???',
  'MBC6',
  '0x21 ???',
  'MBC7+SENSOR+RUMBLE+RAM+BATTERY',
]

const lic_codes = [
  'None',
  'Nintendo R&D1',
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Capcom',
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Electronic Arts',
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Hudson Soft',
  'b-ai',
  'kss',
  'Unknown',
  'pow',
  'Unknown',
  'PCM Complete',
  'san-x',
  'Unknown',
  'Unknown',
  'Kemco Japan',
  'seta',
  'Viacom',
  'Nintendo',
  'Bandai',
  'Ocean/Acclaim',
  'Konami',
  'Hector',
  'Unknown',
  'Taito',
  'Hudson',
  'Banpresto',
  'Unknown',
  'Ubi Soft',
  'Atlus',
  'Unknown',
  'Malibu',
  'Unknown',
  'angel',
  'Bullet-Proof',
  'Unknown',
  'irem',
  'Absolute',
  'Acclaim',
  'Activision',
  'American sammy',
  'Konami',
  'Hi tech entertainment',
  'LJN',
  'Matchbox',
  'Mattel',
  'Milton Bradley',
  'Titus',
  'Virgin',
  'Unknown',
  'Unknown',
  'LucasArts',
  'Unknown',
  'Unknown',
  'Ocean',
  'Unknown',
  'Electronic Arts',
  'Infogrames',
  'Interplay',
  'Broderbund',
  'sculptured',
  'Unknown',
  'sci',
  'Unknown',
  'Unknown',
  'THQ',
  'Accolade',
  'misawa',
  'Unknown',
  'Unknown',
  'lozc',
  'Unknown',
  'Unknown',
  'Tokuma Shoten Intermedia',
  'Tsukuda Original',
  'Unknown',
  'Unknown',
  'Unknown',
  'Chunsoft',
  'Video system',
  'Ocean/Acclaim',
  'Unknown',
  'Varie',
  "Yonezawa/s'pal",
  'Kaneko',
  'Unknown',
  'Pack in soft',
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Konami (Yu-Gi-Oh!)',
]

const rom_sizes = [
  '32 KiB',
  '64 KiB',
  '128 KiB',
  '256 KiB',
  '512 KiB',
  '1 MiB',
  '2 MiB',
  '4 MiB',
  '8 MiB',
]

const ram_sizes = [
  '0',
  '-',
  '8 KiB',
  '32 KiB',
  '128 KiB',
  '64 KiB',
]

struct RomHeader {
mut:
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

struct Cart {
mut:
  filename string
  rom_size u32
  rom_data [65536]u8 // Not sure if this is the maximum size a cart can be
  header   RomHeader
}

// Return the licence code corresponding to the cart informations.
fn (cart Cart) cart_lic() string {
  if cart.header.new_lic_code <= 0xa4 {
    return lic_codes[cart.header.lic_code]
  } else {
    return 'UNKNOWN LICENCE: ${cart.header.lic_code}'
  }
}

// Return the Rom type corresponding to the cart informations.
fn (cart Cart) cart_type() string {
  if cart.header.rom_type <= 0x22 {
    return rom_types[cart.header.rom_type]
  } else {
    return 'UNKNOWN ROM TYPE: ${cart.header.rom_type}'
  }
}

fn (cart Cart) cart_rom_size() string {
  if cart.header.rom_size <= 0x8 {
    return rom_sizes[cart.header.rom_size]
  } else {
    return 'UNKNOWN ROM SIZE: ${cart.header.rom_size}'
  }
}

fn (cart Cart) cart_ram_size() string {
  if cart.header.ram_size <= 0x5 {
    return ram_sizes[cart.header.ram_size]
  } else {
    return 'UNKNOWN RAM SIZE: ${cart.header.ram_size}'
  }
}

/*
Load the cartridge information from the rom (.gb) file.
Return true on succes and false if the loading failed.*/
fn (mut cart Cart) load_rom(rom_path string) bool {
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
fn (cart Cart) read_byte(address u16) u8 {
  return cart.rom_data[address]
}

/*
Write u8 value on the provided address in rom.
This does not save a new file but just modify the values in the cart struct.*/
fn (mut cart Cart) write_byte(address u16, value u8) u16 {
  panic('Cart writting not implemented yet')
}

// Display rom header informations
fn (cart Cart) print() {
  println('Title:          ${cart.header.title}')
  println('Type:           ${cart.cart_type()}')
  println('ROM Size:       ${cart.cart_rom_size()}')
  println('RAM Size:       ${cart.cart_ram_size()}')
  println('LIC Code:       ${cart.cart_lic()}')
  println('Rom Version:    ${cart.header.version}')
}
