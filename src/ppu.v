module main

pub struct Ppu {}

pub fn (ppu &Ppu) read_vram(addr u16) u8 {
  return 0
}

pub fn (ppu &Ppu) read_oam(addr u16) u8 {
  return 0
}

pub fn (ppu &Ppu) write_vram(addr u16, value u8) {}

pub fn (ppu &Ppu) write_oam(addr u16, value u8) {}
