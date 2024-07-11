module main

import instructions

//  Should never happend
fn (mut cpu Cpu) cpu_none() {
	panic('Invalid instruction: ${cpu.fetched_instruction}')
}

//  Does nothing
fn (mut cpu Cpu) cpu_nop() {}

//  Load value from one point to another
fn (mut cpu Cpu) cpu_ld() {
	//  If the instruction need to write values in memory
	if cpu.memory {
		if instructions.is_16_bit(cpu.fetched_instruction.reg_2) {
			// cpu.emu.timer_cycle(1)
			cpu.write_u16_byte(cpu.destination, cpu.fetched_data)
		} else {
			cpu.write_byte(cpu.destination, u8(cpu.fetched_data))
		}
		// cpu.emu.timer_cycle(1)
		return
	}

	if cpu.fetched_instruction.mode == .am_hl_spr {
		h := (cpu.get_reg(cpu.fetched_instruction.reg_2) & 0xF) + (cpu.fetched_data & 0xF) >= 0x10
		c := (cpu.get_reg(cpu.fetched_instruction.reg_2) & 0xFF) + (cpu.fetched_data & 0xFF) >= 0x100
		cpu.set_flags(0, 0, int(h), int(c))
		cpu.set_reg(cpu.fetched_instruction.reg_1, cpu.get_reg(cpu.fetched_instruction.reg_2) +
			u8(cpu.fetched_data))
		return
	}

	cpu.set_reg(cpu.fetched_instruction.reg_1, cpu.fetched_data)
}

//  Load fetched_data & 0xFF00 into destination
fn (mut cpu Cpu) cpu_ldh() {
	if cpu.fetched_instruction.reg_1 == .reg_a {
		cpu.registers.a = cpu.read_byte(cpu.fetched_data & 0xFF00)
	} else {
		cpu.write_byte(cpu.destination, cpu.registers.a)
	}
	// cpu.emu.timer_cycle(1)
}

//  Jump to address if condition is valid
fn (mut cpu Cpu) cpu_jp() {
	if cpu.cond_is_valid() {
		cpu.registers.pc = cpu.fetched_data
		// cpu.emu.timer_cycle(1)
	}
}

//  Disable interrupts
fn (mut cpu Cpu) cpu_di() {
	cpu.int_master_enabled = false
}

//  Retrieve the last value pushed on the stack
fn (mut cpu Cpu) cpu_pop() {
	lower_byte := cpu.pop()
	// cpu.emu.timer_cycle(1)
	higher_byte := u16(cpu.pop())
	// cpu.emu.timer_cycle(1)

	value := (higher_byte << 8) | lower_byte
	cpu.set_reg(cpu.fetched_instruction.reg_1, value)
	if cpu.fetched_instruction.reg_1 == .reg_af {
		cpu.set_reg(cpu.fetched_instruction.reg_1, value & 0xFFF0)
	}
}

//  Send values on the stack
fn (mut cpu Cpu) cpu_push() {
	higher_byte := u8(cpu.get_reg(cpu.fetched_instruction.reg_1) >> 8)
	// cpu.emu.timer_cycle(1)
	cpu.push(higher_byte)

	lower_byte := u8(cpu.get_reg(cpu.fetched_instruction.reg_1))
	// cpu.emu.timer_cycle(1)
	cpu.push(lower_byte)

	// cpu.emu.timer_cycle(1)
}

//  Jump by a certain number if condition is valid
fn (mut cpu Cpu) cpu_jr() {
	delta := cpu.fetched_data & 0xFF
	if cpu.cond_is_valid() {
		cpu.registers.pc += delta
		// cpu.emu.timer_cycle(1)
	}
}

//  Jump and save pc to stack if condition is valid
fn (mut cpu Cpu) cpu_call() {
	if cpu.cond_is_valid() {
		cpu.push_u16(cpu.registers.pc)
		// cpu.emu.timer_cycle(2)
		cpu.registers.pc = cpu.fetched_data
		// cpu.emu.timer_cycle(1)
	}
}

//  Return to the last pc pushed in stack if condition is valid
fn (mut cpu Cpu) cpu_ret() {
	if cpu.fetched_instruction.cond_type != .cond_none {
		// cpu.emu.timer_cycle(1)
	}
	if cpu.cond_is_valid() {
		address := cpu.pop_u16()
		// cpu.emu.timer_cycle(2)
		cpu.registers.pc = address
		// cpu.emu.timer_cycle(1)
	}
}

//  set pc to a specific value (0x00, 0x008 etc..)
fn (mut cpu Cpu) cpu_rst() {
	if cpu.cond_is_valid() {
		cpu.push_u16(cpu.registers.pc)
		// cpu.emu.timer_cycle(2)
		cpu.registers.pc = cpu.fetched_instruction.parameter
		// cpu.emu.timer_cycle(1)
	}
}

//  Decrement a register
fn (mut cpu Cpu) cpu_dec() {
	mut value := cpu.get_reg(cpu.fetched_instruction.reg_1) - 1
	is_word := if instructions.is_16_bit(cpu.fetched_instruction.reg_1) {
		// cpu.emu.timer_cycle(1)
		true
	} else {
		false
	}

	if cpu.fetched_instruction.reg_1 == .reg_hl && cpu.fetched_instruction.mode == .am_mr {
		value = cpu.read_byte(cpu.registers.get_hl()) - 1
		cpu.write_byte(cpu.registers.get_hl(), u8(value))
	} else {
		cpu.set_reg(cpu.fetched_instruction.reg_1, value)
	}

	if !is_word {
		cpu.set_flags(int(value == 0), 1, int((value & 0x0F) == 0x0F), -1)
	}
}

//  Increment a register
fn (mut cpu Cpu) cpu_inc() {
	mut value := cpu.get_reg(cpu.fetched_instruction.reg_1) + 1
	is_16bit := if instructions.is_16_bit(cpu.fetched_instruction.reg_1) {
		// cpu.emu.timer_cycle(1)
		true
	} else {
		false
	}

	if cpu.fetched_instruction.reg_1 == .reg_hl && cpu.fetched_instruction.mode == .am_mr {
		value = cpu.read_byte(cpu.registers.get_hl()) + 1
		cpu.write_byte(cpu.registers.get_hl(), u8(value))
	} else {
		cpu.set_reg(cpu.fetched_instruction.reg_1, value)
	}

	if !is_16bit {
		cpu.set_flags(int(value == 0), 0, int((value & 0x0F) == 0), -1)
	}
}

//  Add fetched_data to target register
fn (mut cpu Cpu) cpu_add() {
	mut value := u32(cpu.get_reg(cpu.fetched_instruction.reg_1) + cpu.fetched_data)
	is_16bit := if instructions.is_16_bit(cpu.fetched_instruction.reg_2) {
		// cpu.emu.timer_cycle(1)
		true
	} else {
		false
	}

	if cpu.fetched_instruction.reg_1 == .reg_sp {
		value = cpu.registers.sp + u8(cpu.fetched_data)
	}

	mut zero := int(u8(value) == 0)
	mut half_carry := int((cpu.get_reg(cpu.fetched_instruction.reg_1) & 0xF) +
		(cpu.fetched_data & 0xF) >= 0x10)
	mut carry := int(u8(cpu.get_reg(cpu.fetched_instruction.reg_1)) + (cpu.fetched_data & 0xFF) >= 0x100)

	if is_16bit {
		zero = -1
		half_carry = int((cpu.get_reg(cpu.fetched_instruction.reg_1) & 0xFFF) +
			(cpu.fetched_data & 0xFFF) >= 0x100)
		carry = int((u32(cpu.get_reg(cpu.fetched_instruction.reg_1)) + u32(cpu.fetched_data)) >= 0x10000)
	}

	if cpu.fetched_instruction.reg_1 == .reg_sp {
		zero = 0
		half_carry = int((cpu.registers.sp & 0xF) + (cpu.fetched_data & 0xF) >= 0x10)
		carry = int(u8(cpu.registers.sp) + u8(cpu.fetched_data) >= 0x100)
	}

	cpu.set_reg(cpu.fetched_instruction.reg_1, u16(value))
	cpu.set_flags(zero, 0, half_carry, carry)
}

//  Add fetched_data and carry flag value to target register
fn (mut cpu Cpu) cpu_adc() {
	value := u8(cpu.registers.a + cpu.fetched_data + bit(cpu.registers.f, carry_flag_byte_position))
	half_carry := int((cpu.registers.a & 0xF) + (cpu.fetched_data & 0xF) >= 0xF)
	carry := cpu.registers.a + cpu.fetched_data + bit(cpu.registers.f, carry_flag_byte_position)
	cpu.set_flags(int(value == 0), 0, half_carry, carry)
	cpu.registers.a = value
}

//  Subtract fetched value from target register
fn (mut cpu Cpu) cpu_sub() {
	value := cpu.get_reg(cpu.fetched_instruction.reg_1) - cpu.fetched_data

	half_carry := int((cpu.get_reg(cpu.fetched_instruction.reg_1) & 0xF) - (cpu.fetched_data & 0xF) < 0)
	carry := int(cpu.get_reg(cpu.fetched_instruction.reg_1) - cpu.fetched_data < 0)
	cpu.set_reg(cpu.fetched_instruction.reg_1, value)

	cpu.set_flags(int(value == 0), 1, half_carry, carry)
}

//  Subtract fetched value and carry flag value from target register
fn (mut cpu Cpu) cpu_sbc() {
	value := cpu.get_reg(cpu.fetched_instruction.reg_1) - cpu.fetched_data - bit(cpu.registers.f,
		carry_flag_byte_position)

	half_carry := int((cpu.get_reg(cpu.fetched_instruction.reg_1) & 0xF) - (cpu.fetched_data & 0xF) - bit(cpu.registers.f,
		carry_flag_byte_position) < 0)
	carry := int((cpu.get_reg(cpu.fetched_instruction.reg_1)) - (cpu.fetched_data) - bit(cpu.registers.f,
		carry_flag_byte_position) < 0)

	cpu.set_reg(cpu.fetched_instruction.reg_1, value)
	cpu.set_flags(int(value == 0), 1, half_carry, carry)
}

//  Apply AND operation between A register and fetched data
fn (mut cpu Cpu) cpu_and() {
	cpu.registers.a &= u8(cpu.fetched_data)
	cpu.set_flags(int(cpu.registers.a == 0), 0, 1, 0)
}

//  Apply XOR operation between A register and fetched data
fn (mut cpu Cpu) cpu_xor() {
	cpu.registers.a ^= u8(cpu.fetched_data)
	cpu.set_flags(int(cpu.registers.a == 0), 0, 0, 0)
}

//  Apply OR operation between A register and fetched data
fn (mut cpu Cpu) cpu_or() {
	cpu.registers.a |= u8(cpu.fetched_data)
	cpu.set_flags(int(cpu.registers.a == 0), 0, 0, 0)
}

//  Compare reg A - fetched data
fn (mut cpu Cpu) cpu_cp() {
	val := int(cpu.registers.a) - int(cpu.fetch_data)
	cpu.set_flags(int(val == 0), 1, int((int(cpu.registers.a & 0x0F) - int(cpu.fetched_data & 0x0F)) < 0),
		int(val < 0))
}

//  Prefixed instruction: determine which action to do
fn (mut cpu Cpu) cpu_cb() {
	// Everything is shifted by one byte because first byte is the prefix
	opcode := cpu.fetched_data
	// The lowest 3 bits of the opcode represent the target register
	reg := match opcode & 0b111 {
		0b0 { instructions.Instr_reg.reg_b }
		0b1 { instructions.Instr_reg.reg_c }
		0b10 { instructions.Instr_reg.reg_d }
		0b11 { instructions.Instr_reg.reg_e }
		0b100 { instructions.Instr_reg.reg_h }
		0b101 { instructions.Instr_reg.reg_l }
		0b110 { instructions.Instr_reg.reg_hl }
		0b111 { instructions.Instr_reg.reg_a }
		else { panic("Opcode doesn't correspond to any register: cpu_cb error in reg match") }
	}
	// The 3 next bits of the opcode represent the bit index concerned by this instruction
	idx := (opcode >> 3) & 0b111
	// The 2 highest bits of the opcode help us know the instruction (bit, res or set)
	op_instr := (opcode >> 6) & 0b11

	mut fetched_value := cpu.get_reg(reg)

	// cpu.emu.timer_cycle(1)

	if reg == .reg_hl {
		// cpu.emu.timer_cycle(2)
	}

	match op_instr {
		0b1 { // BIT
			cpu.set_flags(int((fetched_value & (1 << idx)) > 0), 0, 1, -1)
			return
		}
		0b10 { // RES
			fetched_value &= ~(1 << idx)
			cpu.set_reg(reg, fetched_value)
			return
		}
		0b11 { // SET
			fetched_value |= 1 << idx
			cpu.set_reg(reg, fetched_value)
			return
		}
		else {
			panic('op_instr in cpu_cb have an anormal value ${op_instr}.')
		}
	}

	carry_flag := bit(cpu.registers.f, carry_flag_byte_position)

	match idx {
		0 {
			// RLC Instruction
			mut carry := false
			mut value := (fetched_value << 1) & 0xFF
			if fetched_value & (1 << 7) != 0 {
				carry = true
				value |= 1
			}
			cpu.set_reg(reg, value)
			cpu.set_flags(int(value == 0), 0, 0, int(carry))
			return
		}
		1 {
			// RRC Instruction
			old_value := fetched_value
			fetched_value = (fetched_value >> 1) | old_value << 7
			cpu.set_reg(reg, fetched_value)
			cpu.set_flags(int(fetched_value == 0), 0, 0, int(old_value & 1))
			return
		}
		2 {
			// RL Instruction
			old_value := fetched_value
			fetched_value = (fetched_value << 1) | carry_flag
			cpu.set_reg(reg, fetched_value)
			cpu.set_flags(int(fetched_value == 0), 0, 0, int(old_value & (1 << 7)))
			return
		}
		3 {
			// RR Instruction
			old_value := fetched_value
			fetched_value = (fetched_value >> 1) | carry_flag << 7
			cpu.set_reg(reg, fetched_value)
			cpu.set_flags(int(fetched_value == 0), 0, 0, int(old_value & 1))
			return
		}
		4 {
			// SLA Instruction
			old_value := fetched_value
			fetched_value = (fetched_value << 1)
			cpu.set_reg(reg, fetched_value)
			cpu.set_flags(int(fetched_value == 0), 0, 0, int(old_value & (1 << 7)))
			return
		}
		5 {
			// SRA Instruction
			value := fetched_value >> 1
			cpu.set_reg(reg, value)
			cpu.set_flags(int(value == 0), 0, 0, int(fetched_value & 1))
			return
		}
		6 {
			// SWAP Instruction
			value := ((fetched_value & 0xF) << 4) | ((fetched_value & 0xF0) >> 4)
			cpu.set_reg(reg, value)
			cpu.set_flags(int(value == 0), 0, 0, 0)
			return
		}
		7 {
			// SRL Instruction
			value := fetched_value >> 1
			cpu.set_reg(reg, value)
			cpu.set_flags(int(value == 0), 0, 0, int(fetched_value & 1))
			return
		}
		else {
			panic('idx in cpu_cb have an anormal value ${idx}.')
		}
	}
}

//  Rotate register A to righ and keep carry
fn (mut cpu Cpu) cpu_rrca() {
	mut carry := cpu.registers.a & 1
	cpu.registers.a = (cpu.registers.a >> 1) | carry
	cpu.set_flags(0, 0, 0, carry)
}

//  Rotate register A to left and keep carry
fn (mut cpu Cpu) cpu_rlca() {
	mut val := cpu.registers.a
	mut carry := (cpu.registers.a >> 7) & 0x1
	cpu.registers.a = (val << 1) | carry
	cpu.set_flags(0, 0, 0, carry)
}

//  Rotate register A to right, add old carry and keep new carry
fn (mut cpu Cpu) cpu_rra() {
	mut new_carry := cpu.registers.a & 1
	cpu.registers.a = (cpu.registers.a >> 1) | (bit(cpu.registers.f, carry_flag_byte_position) << 7)
	cpu.set_flags(0, 0, 0, new_carry)
}

//  Rotate register A to left, add old carry and keep new carry
fn (mut cpu Cpu) cpu_rla() {
	mut val := cpu.registers.a
	mut new_carry := (cpu.registers.a >> 7) & 1
	cpu.registers.a = (val << 1) | bit(cpu.registers.f, carry_flag_byte_position)
	cpu.set_flags(0, 0, 0, new_carry)
}

//  Exit the emulator with panic
fn (mut cpu Cpu) cpu_stop() {
	panic('Stop instruction received!')
}

//  Pause the processor
fn (mut cpu Cpu) cpu_halt() {
	cpu.halted = true
}

fn (mut cpu Cpu) cpu_daa() {}

//  Invert register A bits
fn (mut cpu Cpu) cpu_cpl() {
	cpu.registers.a = ~cpu.registers.a
	cpu.set_flags(-1, 1, 1, -1)
}

//  Set carry flag
fn (mut cpu Cpu) cpu_scf() {
	cpu.set_flags(-1, 0, 0, 1)
}

//  Invert cary flag
fn (mut cpu Cpu) cpu_ccf() {
	cpu.set_flags(-1, 0, 0, bit(cpu.registers.f, carry_flag_byte_position) ^ 1)
}

//  Enable interrupts
fn (mut cpu Cpu) cpu_ei() {
	cpu.int_master_enabled = true
}

//  Enable interrupts and return
fn (mut cpu Cpu) cpu_reti() {
	cpu.int_master_enabled = true
	cpu.cpu_ret()
}

//  Place all the cpu functions in the array for direct access later
//  May be nice to find a way to just declare them in it directly as
//  it looks really ugly like that
//  Need to add: some fn that are not done yet
fn (mut cpu Cpu) init_functions() {
	for i in 0 .. 255 {
		cpu.func[i] = cpu.cpu_none
	}
	cpu.func[int(instructions.Instr.instr_none)] = cpu.cpu_none
	cpu.func[int(instructions.Instr.instr_nop)] = cpu.cpu_nop
	cpu.func[int(instructions.Instr.instr_ld)] = cpu.cpu_ld
	cpu.func[int(instructions.Instr.instr_ldh)] = cpu.cpu_ldh
	cpu.func[int(instructions.Instr.instr_jp)] = cpu.cpu_jp
	cpu.func[int(instructions.Instr.instr_di)] = cpu.cpu_di
	cpu.func[int(instructions.Instr.instr_pop)] = cpu.cpu_pop
	cpu.func[int(instructions.Instr.instr_push)] = cpu.cpu_push
	cpu.func[int(instructions.Instr.instr_jr)] = cpu.cpu_jr
	cpu.func[int(instructions.Instr.instr_call)] = cpu.cpu_call
	cpu.func[int(instructions.Instr.instr_ret)] = cpu.cpu_ret
	cpu.func[int(instructions.Instr.instr_rst)] = cpu.cpu_rst
	cpu.func[int(instructions.Instr.instr_dec)] = cpu.cpu_dec
	cpu.func[int(instructions.Instr.instr_inc)] = cpu.cpu_inc
	cpu.func[int(instructions.Instr.instr_add)] = cpu.cpu_add
	cpu.func[int(instructions.Instr.instr_adc)] = cpu.cpu_adc
	cpu.func[int(instructions.Instr.instr_sub)] = cpu.cpu_sub
	cpu.func[int(instructions.Instr.instr_sbc)] = cpu.cpu_sbc
	cpu.func[int(instructions.Instr.instr_and)] = cpu.cpu_and
	cpu.func[int(instructions.Instr.instr_xor)] = cpu.cpu_xor
	cpu.func[int(instructions.Instr.instr_or)] = cpu.cpu_or
	cpu.func[int(instructions.Instr.instr_cp)] = cpu.cpu_cp
	cpu.func[int(instructions.Instr.instr_cb)] = cpu.cpu_cb
	cpu.func[int(instructions.Instr.instr_rrca)] = cpu.cpu_rrca
	cpu.func[int(instructions.Instr.instr_rlca)] = cpu.cpu_rlca
	cpu.func[int(instructions.Instr.instr_rra)] = cpu.cpu_rra
	cpu.func[int(instructions.Instr.instr_rla)] = cpu.cpu_rla
	cpu.func[int(instructions.Instr.instr_stop)] = cpu.cpu_stop
	cpu.func[int(instructions.Instr.instr_halt)] = cpu.cpu_halt
	cpu.func[int(instructions.Instr.instr_daa)] = cpu.cpu_daa
	cpu.func[int(instructions.Instr.instr_cpl)] = cpu.cpu_cpl
	cpu.func[int(instructions.Instr.instr_scf)] = cpu.cpu_scf
	cpu.func[int(instructions.Instr.instr_ccf)] = cpu.cpu_ccf
	cpu.func[int(instructions.Instr.instr_ei)] = cpu.cpu_ei
	cpu.func[int(instructions.Instr.instr_reti)] = cpu.cpu_reti
}

@[direct_array_access]
fn (mut cpu Cpu) cpu_exec() {
	cpu.func[cpu.fetched_instruction.instr_type]()
}
