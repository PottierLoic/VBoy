module vboy

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

pub fn (cpu Cpu) get_reg(reg Reg) u16 {
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
		.reg_none { panic('Reg none should never happend in get_reg, unless..') }
	}
}

pub fn (mut cpu Cpu) set_reg(reg Reg, value u16) {
	match reg {
		.reg_a { cpu.registers.a = u8(value) }
		.reg_f { cpu.registers.f = u8(value)  }
		.reg_b { cpu.registers.b = u8(value)  }
		.reg_c { cpu.registers.c = u8(value)  }
		.reg_d { cpu.registers.d = u8(value)  }
		.reg_e { cpu.registers.e = u8(value)  }
		.reg_h { cpu.registers.h = u8(value)  }
		.reg_l { cpu.registers.l = u8(value)  }
		.reg_af { cpu.registers.set_af(value) }
		.reg_bc { cpu.registers.set_bc(value) }
		.reg_de { cpu.registers.set_de(value) }
		.reg_hl { cpu.registers.set_hl(value) }
		.reg_pc { cpu.registers.pc = value }
		.reg_sp { cpu.registers.sp = value }
		.reg_none { panic('Reg none should never happend in set_reg, unless..') }
	}
}
