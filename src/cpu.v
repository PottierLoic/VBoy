module main

@[heap]
struct Cpu {
mut:
  bus                 &Bus
	registers           Registers
	halted              bool
	ie_register         u8
	interruption_flags  u8
	int_master_enabled  bool
	ime_enabled         bool
	fetched_opcode      u8
	fetched_instruction Instruction
	fetched_data        u16
	destination         u16
  memory              bool
	func                [256]fn ()
}

// Initialize the cpu with default values.
fn (mut cpu Cpu) init(bus &Bus) {
	unsafe {
		cpu.bus = bus
	}
	cpu.registers.set_af(0x01B0)
	cpu.registers.set_bc(0x0013)
	cpu.registers.set_de(0x00D8)
	cpu.registers.set_hl(0x014D)
	cpu.registers.pc = 0x100
	cpu.registers.sp = 0xFFFE
	cpu.init_functions()
}


// Extract the next instruction and execute it.
fn (mut cpu Cpu) step() {
	if !cpu.halted {
		cpu.fetch_instruction()
		operands := cpu.fetch_operands()
		cpu.fetched_data = operands.data
		cpu.destination = operands.destination
		cpu.memory = operands.write_in_mem
		cpu.cpu_exec()
	}
	if cpu.int_master_enabled {
		cpu.handle_interrupts()
		cpu.ime_enabled = false
	}
	if cpu.ime_enabled {
		cpu.int_master_enabled = true
	}
}

//  Get the opcode at PC and retrieve the corresponding instruction
fn (mut cpu Cpu) fetch_instruction() {
	cpu.fetched_opcode = cpu.read_byte(cpu.registers.pc)
	cpu.fetched_instruction = instructions.instruction_from_byte(cpu.fetched_opcode)
	cpu.registers.pc++
}

fn (mut cpu Cpu) read_bytes(addr u16) u8 {
	return cpu.bus.read(addr)
}

fn (mut cpu Cpu) write_byte(addr u16, data u8) {
	cpu.bus.write(addr, data)
}

fn (cpu &Cpu) read_u16(addr u16) u16 {
	lo := cpu.read_byte(addr)
	hi := cpu.read_byte(addr + 1)
	return (u16(hi) << 8) | u16(lo)
}
