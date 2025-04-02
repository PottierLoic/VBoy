module main

struct Bus {
mut:
  cart  &Cart
  ram   &Ram
  ppu   &Ppu
  timer &Timer
  io    &Io
  intr  &Interrupts
}

fn (bus &Bus) read(addr u16) u8 {
  if addr <= 0x7FFF {
    return bus.cart.read(addr)
  } else if addr <= 0x9FFF {
    return bus.ppu.read_vram(addr)
  } else if addr <= 0xBFFF {
    return bus.cart.read(addr)
  } else if addr <= 0xDFFF {
    return bus.ram.read_wram(addr)
  } else if addr <= 0xFDFF {
    // Echo RAM (not implemented): return WRAM mirror
    return bus.ram.read_wram(addr - 0x2000)
  } else if addr <= 0xFE9F {
    return bus.ppu.read_oam(addr)
  } else if addr <= 0xFF7F {
    return bus.io.read(addr)
  } else if addr <= 0xFFFE {
    return bus.ram.read_hram(addr)
  } else {
    return bus.intr.read(addr)
  }
}

fn (mut bus Bus) write(addr u16, value u8) {
  if addr <= 0x7FFF {
    bus.cart.write(addr, value)
  } else if addr <= 0x9FFF {
    bus.ppu.write_vram(addr, value)
  } else if addr <= 0xBFFF {
    bus.cart.write(addr, value)
  } else if addr <= 0xDFFF {
    bus.ram.write_wram(addr, value)
  } else if addr <= 0xFDFF {
    // Echo RAM (not implemented): mirror to WRAM
    bus.ram.write_wram(addr - 0x2000, value)
  } else if addr <= 0xFE9F {
    bus.ppu.write_oam(addr, value)
  } else if addr <= 0xFF7F {
    bus.io.write(addr, value)
  } else if addr <= 0xFFFE {
    bus.ram.write_hram(addr, value)
  } else {
    bus.intr.write(addr, value)
  }
}
