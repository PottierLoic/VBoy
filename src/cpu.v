module vboy

[heap]
pub struct Cpu {
pub mut:
	vboy               &VBoy = unsafe { nil }
	registers          Registers
	halted             bool
	ie_register        u8
	interruption_flags u8
	int_master_enabled bool
	ime_enabled        bool

	func [34]fn ()

	/* Step processing */
	fetched_opcode      u8
	fetched_instruction Instruction
	fetched_data        u16
	destination         u16
	memory              bool
}

/* Get the opcode at PC and retrieve the corresponding instruction */
pub fn (mut cpu Cpu) fetch_instruction() {
	cpu.fetched_opcode = cpu.read_byte(cpu.registers.pc)
	cpu.fetched_instruction = instruction_from_byte(cpu.fetched_opcode)
}

/* Get datas depending on the fetched instruction addressing mode */
pub fn (mut cpu Cpu) fetch_data() {
	match cpu.fetched_instruction.mode {
		.am_imp {}
		.am_r {
			cpu.fetched_data = cpu.get_reg(cpu.fetched_instruction.reg_1)
		}
		.am_r_r {
			cpu.fetched_data = cpu.get_reg(cpu.fetched_instruction.reg_2)
		}
		.am_r_d8 {
			cpu.fetched_data = cpu.read_byte(cpu.registers.pc)
			cpu.vboy.timer_cycle(1)
			cpu.registers.pc++
		}
		.am_r_d16, .am_d16 {
			lower__byte := cpu.read_byte(cpu.registers.pc)
			cpu.vboy.timer_cycle(1)
			higher_byte := cpu.read_byte(cpu.registers.pc + 1)
			cpu.vboy.timer_cycle(1)
			cpu.fetched_data = lower__byte | (higher_byte << 8)
			cpu.registers.pc += 2
		}
		.am_mr_r {
			cpu.fetched_data = cpu.get_reg(cpu.fetched_instruction.reg_2)
			cpu.destination = cpu.get_reg(cpu.fetched_instruction.reg_1)
			cpu.memory = true
			if cpu.fetched_instruction.reg_1 == .reg_c {
				cpu.destination |= 0xFF00
			}
		}
		.am_r_mr {
			mut destination := cpu.get_reg(cpu.fetched_instruction.reg_2)
			if cpu.fetched_instruction.reg_2 == .reg_c {
				destination |= 0xFF00
			}
			cpu.vboy.timer_cycle(1)
			cpu.fetched_data = cpu.read_byte(destination)
		}
		.am_r_hli {
			cpu.fetched_data = cpu.vboy.read_byte(cpu.get_reg(fetched_instruction.reg_2))
			cpu.vboy.timer_cycle(1)
			cpu.registers.set_hl(cpu.get_reg(.reg_hl) + 1)
		}
		.am_r_hld {}
		.am_hli_r {}
		.am_hld_r {}
		.am_r_a8 {}
		.am_a8_r {}
		.am_hl_spr {}
		.am_d8 {}
		.am_a16_r, .am_d16_r {}
		.am_mr_d8 {}
		.am_mr {}
		.am_r_a16 {}
		.am_none {
			panic('am_none, this should never happend.')
		}
		else {
			panic('Unknown addressing mode: ${cpu.fetched_instruction.mode}')
		}
	}
}

// Initialize the cpu with default values.
pub fn (mut cpu Cpu) init() {
	cpu.registers.set_af(0x01B0)
	cpu.registers.set_bc(0x0013)
	cpu.registers.set_de(0x00D8)
	cpu.registers.set_hl(0x014D)
	cpu.registers.pc = 0x0100
	cpu.registers.sp = 0xFFFE
}

// Extract the next instruction and execute it.
pub fn (mut cpu Cpu) step() {
	if !cpu.halted {
		cpu.fetch_instruction()
		cpu.vboy.timer_cycle(1) // must be verified
		cpu.fetch_data()
		// put compile time debug here
		cpu.cpu_exec()
	} else {
		cpu.vboy.timer_cycle(1)
		// if cpu.interruption_flags {
		// 	cpu.halted = false
		// }
	}

	if cpu.int_master_enabled {
		cpu.handle_interrupts()
		cpu.ime_enabled = false
	}

	if cpu.ime_enabled {
		cpu.int_master_enabled = true
	}
}

/* Select the struct to read in vboy components */
/* TODO: make it fast (~80% of the execution time is wasted here). */
pub fn (mut cpu Cpu) read_byte(address u16) u8 {
	if address < 0x8000 {
		// ROM Data
		return cpu.vboy.cart.read_byte(address)
	} else if address < 0xA000 {
		// Char/map data
		panic('PPU vram reading not implemented')
	} else if address < 0xC000 {
		// Cart RAM
		return cpu.vboy.cart.read_byte(address)
	} else if address < 0xE000 {
		// WRAM
		return cpu.vboy.ram.read_wram(address)
	} else if address < 0xFE00 {
		// Reserved echo ram
		return 0
	} else if address < 0xFEA0 {
		// OAM
		panic('PPU OAM writing not implemented')
	} else if address < 0xFF00 {
		// Reserved unusable
		return 0
	} else if address < 0xFF80 {
		// IO Registers
		return cpu.vboy.io.read_io(address)
	} else if address < 0xFFFF {
		// CPU enable register
		return cpu.ie_register
	} else {
		// HRAM
		return cpu.vboy.ram.read_hram(address)
	}
}

/* Select the struct to write in vboy componnents */
pub fn (mut cpu Cpu) write_byte(address u16, value u8) {
	if address < 0x8000 {
		// ROM Data
		cpu.vboy.cart.write_byte(address, value)
	} else if address < 0xA000 {
		// Char/map data
		panic('ppu vram writing not implemented')
	} else if address < 0xC000 {
		// Cart RAM
		cpu.vboy.cart.write_byte(address, value)
	} else if address < 0xE000 {
		// WRAM
		cpu.vboy.ram.write_wram(address, value)
	} else if address < 0xFE00 {
		// Reserved echo ram
	} else if address < 0xFEA0 {
		// OAM
		panic('PPU OAM writing not implemented')
	} else if address < 0xFF00 {
		// Reserved unusable
	} else if address < 0xFF80 {
		// IO Registers
		cpu.vboy.io.write_io(address, value)
	} else if address < 0xFFFF {
		// CPU enable register
		cpu.ie_register = value
	} else {
		// HRAM
		cpu.vboy.ram.write_hram(address, value)
	}
}

pub fn (cpu Cpu) get_interruption_flags() u8 {
	return cpu.interruption_flags
}

pub fn (mut cpu Cpu) set_interruption_flags(value u8) {
	cpu.interruption_flags = value
}

pub fn (mut cpu Cpu) set_flags(z int, n int, h int, c int) {
	if z != -1 {
		bit_set(cpu.registers.f, zero_flag_byte_position, z)
	}
	if n != -1 {
		bit_set(cpu.registers.f, subtract_flag_byte_position, n)
	}
	if h != -1 {
		bit_set(cpu.registers.f, half_carry_flag_byte_position, h)
	}
	if c != -1 {
		bit_set(cpu.registers.f, carry_flag_byte_position, c)
	}
}

fn (mut cpu Cpu) get_reg(reg Reg) u16 {
	return match reg {
		.reg_a { cpu.registers.a }
		.reg_f { cpu.registers.f }
		.reg_b { cpu.registers.b }
		.reg_c { cpu.registers.c }
		.reg_d { cpu.registers.d }
		.reg_e { cpu.registers.e }
		.reg_h { cpu.registers.h }
		.reg_l { cpu.registers.l }
		.reg_af { cpu.registers.get_af() }
		.reg_bc { cpu.registers.get_bc() }
		.reg_de { cpu.registers.get_de() }
		.reg_hl { cpu.registers.get_hl() }
		.reg_pc { cpu.registers.pc }
		.reg_sp { cpu.registers.sp }
		.reg_none { panic('Reg none should never happend, unless..') }
	}
}
