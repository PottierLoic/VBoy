struct MemoryBus {
	memory [65536]u8
}

fn (bus MemoryBus) read_byte(adress u16) u8 {
	return bus.memory[adress]
}