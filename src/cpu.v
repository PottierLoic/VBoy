module main

import instructions

@[heap]
struct Cpu {
mut:
	emu                 &Emulator = unsafe { nil }
	registers           Registers
	halted              bool
	ie_register         u8
	interruption_flags  u8
	int_master_enabled  bool
	ime_enabled         bool
	func                [256]fn ()
	fetched_opcode      u8
	fetched_instruction instructions.Instruction
	fetched_data        u16
	destination         u16
	memory              bool
}

//  Get the opcode at PC and retrieve the corresponding instruction
fn (mut cpu Cpu) fetch_instruction() {
	cpu.fetched_opcode = cpu.read_byte(cpu.registers.pc)
	cpu.fetched_instruction = instructions.instruction_from_byte(cpu.fetched_opcode)
	cpu.registers.pc++
}

// Extract the next instruction and execute it.
fn (mut cpu Cpu) step() {
	if !cpu.halted {
		cpu.fetch_instruction()
		// // cpu.emu.timer_cycle(1)
		cpu.fetch_data()
		cpu.cpu_exec()
	} else {
		// // cpu.emu.timer_cycle(1)
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

// Get data depending on the fetched instruction addressing mode
fn (mut cpu Cpu) fetch_data() {
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
			// cpu.emu.timer_cycle(1)
			cpu.registers.pc++
		}
		.am_r_d16, .am_d16 {
			lower_byte := cpu.read_byte(cpu.registers.pc)
			// cpu.emu.timer_cycle(1)
			higher_byte := u16(cpu.read_byte(cpu.registers.pc + 1))
			// cpu.emu.timer_cycle(1)
			cpu.fetched_data = lower_byte | (higher_byte << 8)
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
			// cpu.emu.timer_cycle(1)
			cpu.fetched_data = cpu.read_byte(destination)
		}
		.am_r_hli {
			cpu.fetched_data = cpu.read_byte(cpu.get_reg(cpu.fetched_instruction.reg_2))
			// cpu.emu.timer_cycle(1)
			cpu.registers.set_hl(cpu.registers.get_hl() + 1)
		}
		.am_r_hld {
			cpu.fetched_data = cpu.read_byte(cpu.get_reg(cpu.fetched_instruction.reg_2))
			// cpu.emu.timer_cycle(1)
			cpu.registers.set_hl(cpu.registers.get_hl() - 1)
		}
		.am_hli_r {
			cpu.fetched_data = cpu.get_reg(cpu.fetched_instruction.reg_2)
			cpu.destination = cpu.get_reg(cpu.fetched_instruction.reg_1)
			cpu.memory = true
			cpu.registers.set_hl(cpu.registers.get_hl() + 1)
		}
		.am_hld_r {
			cpu.fetched_data = cpu.get_reg(cpu.fetched_instruction.reg_2)
			cpu.destination = cpu.get_reg(cpu.fetched_instruction.reg_1)
			cpu.memory = true
			cpu.registers.set_hl(cpu.registers.get_hl() + 1)
		}
		.am_r_a8 {
			cpu.fetched_data = cpu.read_byte(cpu.registers.pc)
			// cpu.emu.timer_cycle(1)
			cpu.registers.pc++
		}
		.am_a8_r {
			cpu.destination = cpu.read_byte(cpu.registers.pc)
			cpu.memory = true
			// cpu.emu.timer_cycle(1)
			cpu.registers.pc++
		}
		.am_hl_spr {
			cpu.fetched_data = cpu.read_byte(cpu.registers.pc)
			// cpu.emu.timer_cycle(1)
			cpu.registers.pc++
		}
		.am_d8 {
			cpu.fetched_data = cpu.read_byte(cpu.registers.pc)
			// cpu.emu.timer_cycle(1)
			cpu.registers.pc++
		}
		.am_a16_r, .am_d16_r {
			lower_byte := cpu.read_byte(cpu.registers.pc)
			// cpu.emu.timer_cycle(1)
			higher_byte := u16(cpu.read_byte(cpu.registers.pc + 1))
			// cpu.emu.timer_cycle(1)
			cpu.destination = lower_byte | (higher_byte << 8)
			cpu.fetched_data = cpu.get_reg(cpu.fetched_instruction.reg_2)
			cpu.memory = true
			cpu.registers.pc += 2
		}
		.am_mr_d8 {
			cpu.fetched_data = cpu.read_byte(cpu.get_reg(cpu.fetched_instruction.reg_1))
			// cpu.emu.timer_cycle(1)
			cpu.destination = cpu.get_reg(cpu.fetched_instruction.reg_1)
			cpu.memory = true
			cpu.registers.pc++
		}
		.am_mr {
			cpu.fetched_data = cpu.read_byte(cpu.get_reg(cpu.fetched_instruction.reg_1))
			cpu.destination = cpu.get_reg(cpu.fetched_instruction.reg_1)
			cpu.memory = true
			// cpu.emu.timer_cycle(1)
		}
		.am_r_a16 {
			lower_byte := cpu.read_byte(cpu.registers.pc)
			// cpu.emu.timer_cycle(1)
			higher_byte := u16(cpu.read_byte(cpu.registers.pc + 1))
			// cpu.emu.timer_cycle(1)
			cpu.fetched_data = lower_byte | (higher_byte << 8)
			// cpu.emu.timer_cycle(1)
			cpu.registers.pc++
		}
		.am_none {
			panic('am_none, this should never happen.')
		}
	}
}

// Initialize the cpu with default values.
fn (mut cpu Cpu) init(emu &Emulator) {
	unsafe {
		cpu.emu = emu
	}
	cpu.registers.set_af(0x01B0)
	cpu.registers.set_bc(0x0013)
	cpu.registers.set_de(0x00D8)
	cpu.registers.set_hl(0x014D)
	cpu.registers.pc = 0x100
	cpu.registers.sp = 0xFFFE
	cpu.init_functions()
}

//  Select the struct to read in emulator components
//  TODO: make it fast (~80% of the execution time is wasted here).
fn (mut cpu Cpu) read_byte(address u16) u8 {
	if address < 0x8000 {
		// ROM Data
		return cpu.emu.cart.read_byte(address)
	} else if address < 0xA000 {
		// Char/map data
		panic('PPU vram reading not implemented')
	} else if address < 0xC000 {
		// Cart RAM
		return cpu.emu.cart.read_byte(address)
	} else if address < 0xE000 {
		// WRAM
		return cpu.emu.ram.read_wram(address)
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
		panic('IO reading not implemented')
	} else if address < 0xFFFF {
		// CPU enable register
		return cpu.ie_register
	} else {
		// HRAM
		return cpu.emu.ram.read_hram(address)
	}
}

fn (mut cpu Cpu) read_u16_byte(address u16) u16 {
	lower_byte := cpu.read_byte(address)
	higher_byte := u16(cpu.read_byte(address + 1))
	return lower_byte | (higher_byte << 8)
}

fn (mut cpu Cpu) write_u16_byte(address u16, value u16) {
	cpu.write_byte(address + 1, u8(value >> 8))
	cpu.write_byte(address, u8(value))
}

//  Select the struct to write in emulator componnents
fn (mut cpu Cpu) write_byte(address u16, value u8) {
	if address < 0x8000 {
		// ROM Data
		cpu.emu.cart.write_byte(address, value)
	} else if address < 0xA000 {
		// Char/map data
		panic('ppu vram writing not implemented')
	} else if address < 0xC000 {
		// Cart RAM
		cpu.emu.cart.write_byte(address, value)
	} else if address < 0xE000 {
		// WRAM
		cpu.emu.ram.write_wram(address, value)
	} else if address < 0xFE00 {
		// Reserved echo ram
	} else if address < 0xFEA0 {
		// OAM
		panic('PPU OAM writing not implemented')
	} else if address < 0xFF00 {
		// Reserved unusable
	} else if address < 0xFF80 {
		// IO Registers
		panic('IO writing not implemented')
	} else if address < 0xFFFF {
		// CPU enable register
		cpu.ie_register = value
	} else {
		// HRAM
		cpu.emu.ram.write_hram(address, value)
	}
}
