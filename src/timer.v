module main

pub struct Timer {}

pub fn (t &Timer) read(addr u16) u8 {
  return 0
}

pub fn (t &Timer) write(addr u16, value u8) {}
