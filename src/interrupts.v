module main

pub struct Interrupts {
pub mut:
  ie u8 = 0  // Interrupt Enable Register (0xFFFF)
  if_ u8 = 0 // Interrupt Flag Register (0xFF0F)
}

pub fn (i &Interrupts) read(addr u16) u8 {
  return match addr {
    0xFFFF { i.ie }
    0xFF0F { i.if_ }
    else { 0 }
  }
}

pub fn (mut i Interrupts) write(addr u16, value u8) {
  match addr {
    0xFFFF { i.ie = value }
    0xFF0F { i.if_ = value }
    else {}
  }
}
