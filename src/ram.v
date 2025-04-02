module main

pub struct Ram {}

pub fn (ram &Ram) read_wram(addr u16) u8 {
  return 0
}

pub fn (ram &Ram) write_wram(addr u16, value u8) {}

pub fn (ram &Ram) read_hram(addr u16) u8 {
  return 0
}

pub fn (ram &Ram) write_hram(addr u16, value u8) {}