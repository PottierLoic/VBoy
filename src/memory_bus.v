struct MemoryBus {
  mut:
  memory [65536]u8
}

fn (bus MemoryBus) read_byte(address u16) u8 {
  return bus.memory[address]
}

fn (mut bus MemoryBus) write_byte(address u16, value u8) {
  bus.memory[address] = value
}
