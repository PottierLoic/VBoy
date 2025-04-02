
module main

pub struct Io {}

pub fn (io &Io) read(addr u16) u8 {
  return 0
}

pub fn (io &Io) write(addr u16, value u8) {}
