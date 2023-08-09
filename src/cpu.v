struct Cpu {
mut:
	vboy               &VBoy = unsafe { nil }
	registers          Registers
	pc                 u16
	sp                 u16
	halted             bool
	ie_register        u8
	interruption_flags u8
}

// Execute the provided instruction and return next program counter.
fn (mut cpu Cpu) execute(instr Instruction) u16 {
	match instr.instruction {
		.nop {
			cpu.pc++
			cpu.vboy.timer_cycle(1)
		}
		.halt {
			cpu.vboy.timer_cycle(1)
		}
		.jp {
			should_jump := match instr.jump_test {
				.not_zero { !u8_to_flag(cpu.registers.f).zero }
				.not_carry { !u8_to_flag(cpu.registers.f).carry }
				.zero { u8_to_flag(cpu.registers.f).zero }
				.carry { u8_to_flag(cpu.registers.f).carry }
				.always { true }
			}
			cpu.jump(should_jump)
		}
		.jr {
			should_jump := match instr.jump_test {
				.not_zero { !u8_to_flag(cpu.registers.f).zero }
				.not_carry { !u8_to_flag(cpu.registers.f).carry }
				.zero { u8_to_flag(cpu.registers.f).zero }
				.carry { u8_to_flag(cpu.registers.f).carry }
				.always { true }
			}
			cpu.jr(should_jump)
		}
		.call {
			should_jump := match instr.jump_test {
				.not_zero { !u8_to_flag(cpu.registers.f).zero }
				.not_carry { !u8_to_flag(cpu.registers.f).carry }
				.zero { u8_to_flag(cpu.registers.f).zero }
				.carry { u8_to_flag(cpu.registers.f).carry }
				.always { true }
			}
			cpu.call(should_jump)
		}
		.ret {
			should_jump := match instr.jump_test {
				.not_zero { !u8_to_flag(cpu.registers.f).zero }
				.not_carry { !u8_to_flag(cpu.registers.f).carry }
				.zero { u8_to_flag(cpu.registers.f).zero }
				.carry { u8_to_flag(cpu.registers.f).carry }
				.always { true }
			}
			cpu.ret(should_jump)
		}
		.add {
			cpu.registers.a = cpu.add(instr.target_u8)
			cpu.pc++
		}
		.adc {
			cpu.registers.a = cpu.adc(instr.target_u8)
			cpu.pc++
		}
		.sub {
			cpu.registers.a = cpu.sub(instr.target_u8)
			cpu.pc++
		}
		.sbc {
			cpu.registers.a = cpu.sbc(instr.target_u8)
			cpu.pc++
		}
		.and {
			cpu.registers.a = cpu.and(cpu.registers.target_to_reg8(instr.target_u8))
			cpu.pc++
		}
		.@or {
			cpu.registers.a = cpu.@or(cpu.registers.target_to_reg8(instr.target_u8))
			cpu.pc++
		}
		.xor {
			cpu.registers.a = cpu.xor(cpu.registers.target_to_reg8(instr.target_u8))
			cpu.pc++
		}
		.cp {
			match instr.target_u8 {
				.d8 {
					cpu.cp(cpu.read_byte(cpu.pc + 1))
					cpu.pc += 2
				}
				else {
					cpu.cp(cpu.registers.target_to_reg8(instr.target_u8))
					cpu.pc++
				}
			}
		}
		.inc {
			match instr.target_u8 {
				.a { cpu.registers.a = cpu.inc(instr.target_u8) }
				.b { cpu.registers.b = cpu.inc(instr.target_u8) }
				.c { cpu.registers.c = cpu.inc(instr.target_u8) }
				.d { cpu.registers.d = cpu.inc(instr.target_u8) }
				.e { cpu.registers.e = cpu.inc(instr.target_u8) }
				.h { cpu.registers.h = cpu.inc(instr.target_u8) }
				.l { cpu.registers.l = cpu.inc(instr.target_u8) }
				else { panic('Not supported target for inc instruction: ${instr.target_u8}') }
			}
			cpu.pc++
		}
		.dec {
			match instr.target_u8 {
				.a { cpu.registers.a = cpu.dec(instr.target_u8) }
				.b { cpu.registers.b = cpu.dec(instr.target_u8) }
				.c { cpu.registers.c = cpu.dec(instr.target_u8) }
				.d { cpu.registers.d = cpu.dec(instr.target_u8) }
				.e { cpu.registers.e = cpu.dec(instr.target_u8) }
				.h { cpu.registers.h = cpu.dec(instr.target_u8) }
				.l { cpu.registers.l = cpu.dec(instr.target_u8) }
				else { panic('Not supported target for dec instruction: ${instr.target_u8}') }
			}
			cpu.pc++
		}
		.ccf {
			cpu.ccf()
			cpu.pc++
		}
		.scf {
			cpu.scf()
			cpu.pc++
		}
		.rra {
			cpu.registers.a = cpu.rra()
			cpu.pc++
		}
		.rla {
			cpu.registers.a = cpu.rla()
			cpu.pc++
		}
		.rrca {
			cpu.registers.a = cpu.rrca()
			cpu.pc++
		}
		.rlca {
			cpu.registers.a = cpu.rlca()
			cpu.pc++
		}
		.cpl {
			cpu.registers.a = cpu.cpl()
			cpu.pc++
		}
		.bit {
			cpu.bit(instr.bit_position, cpu.registers.target_to_reg8(instr.target_u8))
			cpu.pc++
		}
		.res {
			match instr.target_u8 {
				.a { cpu.registers.a = cpu.res(instr.bit_position, cpu.registers.a) }
				.b { cpu.registers.b = cpu.res(instr.bit_position, cpu.registers.b) }
				.c { cpu.registers.c = cpu.res(instr.bit_position, cpu.registers.c) }
				.d { cpu.registers.d = cpu.res(instr.bit_position, cpu.registers.d) }
				.e { cpu.registers.e = cpu.res(instr.bit_position, cpu.registers.e) }
				.h { cpu.registers.h = cpu.res(instr.bit_position, cpu.registers.h) }
				.l { cpu.registers.l = cpu.res(instr.bit_position, cpu.registers.l) }
				else { panic('Not supported target for res instruction: ${instr.target_u8}') }
			}
			cpu.pc+=2
		}
		.set {
			match instr.target_u8 {
				.a { cpu.registers.a = cpu.set(instr.bit_position, cpu.registers.a) }
				.b { cpu.registers.b = cpu.set(instr.bit_position, cpu.registers.b) }
				.c { cpu.registers.c = cpu.set(instr.bit_position, cpu.registers.c) }
				.d { cpu.registers.d = cpu.set(instr.bit_position, cpu.registers.d) }
				.e { cpu.registers.e = cpu.set(instr.bit_position, cpu.registers.e) }
				.h { cpu.registers.h = cpu.set(instr.bit_position, cpu.registers.h) }
				.l { cpu.registers.l = cpu.set(instr.bit_position, cpu.registers.l) }
				else { panic('Not supported target for set instruction: ${instr.target_u8}') }
			}
			cpu.pc++
		}
		.srl {
			match instr.target_u8 {
				.a { cpu.registers.a = cpu.srl(cpu.registers.a) }
				.b { cpu.registers.b = cpu.srl(cpu.registers.b) }
				.c { cpu.registers.c = cpu.srl(cpu.registers.c) }
				.d { cpu.registers.d = cpu.srl(cpu.registers.d) }
				.e { cpu.registers.e = cpu.srl(cpu.registers.e) }
				.h { cpu.registers.h = cpu.srl(cpu.registers.h) }
				.l { cpu.registers.l = cpu.srl(cpu.registers.l) }
				else { panic('Not supported target for srl instruction: ${instr.target_u8}') }
			}
			cpu.pc++
		}
		.rr {
			match instr.target_u8 {
				.a { cpu.registers.a = cpu.rr(cpu.registers.a) }
				.b { cpu.registers.b = cpu.rr(cpu.registers.b) }
				.c { cpu.registers.c = cpu.rr(cpu.registers.c) }
				.d { cpu.registers.d = cpu.rr(cpu.registers.d) }
				.e { cpu.registers.e = cpu.rr(cpu.registers.e) }
				.h { cpu.registers.h = cpu.rr(cpu.registers.h) }
				.l { cpu.registers.l = cpu.rr(cpu.registers.l) }
				else { panic('Not supported target for rr instruction: ${instr.target_u8}') }
			}
			cpu.pc++
		}
		.rl {
			match instr.target_u8 {
				.a { cpu.registers.a = cpu.rl(cpu.registers.a) }
				.b { cpu.registers.b = cpu.rl(cpu.registers.b) }
				.c { cpu.registers.c = cpu.rl(cpu.registers.c) }
				.d { cpu.registers.d = cpu.rl(cpu.registers.d) }
				.e { cpu.registers.e = cpu.rl(cpu.registers.e) }
				.h { cpu.registers.h = cpu.rl(cpu.registers.h) }
				.l { cpu.registers.l = cpu.rl(cpu.registers.l) }
				else { panic('Not supported target for rl instruction: ${instr.target_u8}') }
			}
			cpu.pc++
		}
		.rrc {
			match instr.target_u8 {
				.a { cpu.registers.a = cpu.rrc(cpu.registers.a) }
				.b { cpu.registers.b = cpu.rrc(cpu.registers.b) }
				.c { cpu.registers.c = cpu.rrc(cpu.registers.c) }
				.d { cpu.registers.d = cpu.rrc(cpu.registers.d) }
				.e { cpu.registers.e = cpu.rrc(cpu.registers.e) }
				.h { cpu.registers.h = cpu.rrc(cpu.registers.h) }
				.l { cpu.registers.l = cpu.rrc(cpu.registers.l) }
				else { panic('Not supported target for rrc instruction: ${instr.target_u8}') }
			}
			cpu.pc++
		}
		.rlc {
			match instr.target_u8 {
				.a { cpu.registers.a = cpu.rlc(cpu.registers.a) }
				.b { cpu.registers.b = cpu.rlc(cpu.registers.b) }
				.c { cpu.registers.c = cpu.rlc(cpu.registers.c) }
				.d { cpu.registers.d = cpu.rlc(cpu.registers.d) }
				.e { cpu.registers.e = cpu.rlc(cpu.registers.e) }
				.h { cpu.registers.h = cpu.rlc(cpu.registers.h) }
				.l { cpu.registers.l = cpu.rlc(cpu.registers.l) }
				else { panic('Not supported target for rlc instruction: ${instr.target_u8}') }
			}
			cpu.pc++
		}
		.sra {
			match instr.target_u8 {
				.a { cpu.registers.a = cpu.sra(cpu.registers.a) }
				.b { cpu.registers.b = cpu.sra(cpu.registers.b) }
				.c { cpu.registers.c = cpu.sra(cpu.registers.c) }
				.d { cpu.registers.d = cpu.sra(cpu.registers.d) }
				.e { cpu.registers.e = cpu.sra(cpu.registers.e) }
				.h { cpu.registers.h = cpu.sra(cpu.registers.h) }
				.l { cpu.registers.l = cpu.sra(cpu.registers.l) }
				else { panic('Not supported target for sra instruction: ${instr.target_u8}') }
			}
			cpu.pc++
		}
		.sla {
			match instr.target_u8 {
				.a { cpu.registers.a = cpu.sla(cpu.registers.a) }
				.b { cpu.registers.b = cpu.sla(cpu.registers.b) }
				.c { cpu.registers.c = cpu.sla(cpu.registers.c) }
				.d { cpu.registers.d = cpu.sla(cpu.registers.d) }
				.e { cpu.registers.e = cpu.sla(cpu.registers.e) }
				.h { cpu.registers.h = cpu.sla(cpu.registers.h) }
				.l { cpu.registers.l = cpu.sla(cpu.registers.l) }
				else { panic('Not supported target for sla instruction: ${instr.target_u8}') }
			}
			cpu.pc++
		}
		.swap {
			match instr.target_u8 {
				.a { cpu.registers.a = cpu.swap(cpu.registers.a) }
				.b { cpu.registers.b = cpu.swap(cpu.registers.b) }
				.c { cpu.registers.c = cpu.swap(cpu.registers.c) }
				.d { cpu.registers.d = cpu.swap(cpu.registers.d) }
				.e { cpu.registers.e = cpu.swap(cpu.registers.e) }
				.h { cpu.registers.h = cpu.swap(cpu.registers.h) }
				.l { cpu.registers.l = cpu.swap(cpu.registers.l) }
				else { panic('Not supported target for swap instruction: ${instr.target_u8}') }
			}
			cpu.pc++
		}
		.ld {
			match instr.load_type {
				.byte {
					source_value := match instr.byte_source {
						.a { cpu.registers.a }
						.b { cpu.registers.b }
						.c { cpu.registers.c }
						.d { cpu.registers.d }
						.e { cpu.registers.e }
						.h { cpu.registers.h }
						.l { cpu.registers.l }
						.d8 { cpu.read_byte(cpu.pc + 1) }
						.hli { cpu.read_byte(cpu.registers.get_hl()) }
					}
					match instr.byte_target {
						.a { cpu.registers.a = source_value }
						.b { cpu.registers.b = source_value }
						.c { cpu.registers.c = source_value }
						.d { cpu.registers.d = source_value }
						.e { cpu.registers.e = source_value }
						.h { cpu.registers.h = source_value }
						.l { cpu.registers.l = source_value }
						.hli { cpu.write_byte(cpu.registers.get_hl(), source_value) }
					}
					match instr.byte_source {
						.d8 { cpu.pc += 2 }
						else { cpu.pc++ }
					}
				}
				.word {
					match instr.word_target {
						.bc {
							least_significant_byte := cpu.read_byte(cpu.pc + 1)
							most_significant_byte := cpu.read_byte(cpu.pc + 2)
							cpu.registers.set_bc(most_significant_byte << 7 | least_significant_byte)
							cpu.pc += 3
						}
						.de {
							least_significant_byte := cpu.read_byte(cpu.pc + 1)
							most_significant_byte := cpu.read_byte(cpu.pc + 2)
							cpu.registers.set_de(most_significant_byte << 7 | least_significant_byte)
							cpu.pc += 3
						}
						.hl {
							least_significant_byte := cpu.read_byte(cpu.pc + 1)
							most_significant_byte := cpu.read_byte(cpu.pc + 2)
							cpu.registers.set_hl(most_significant_byte << 7 | least_significant_byte)
							cpu.pc += 3
						}
						.sp {
							least_significant_byte := cpu.read_byte(cpu.pc + 1)
							most_significant_byte := cpu.read_byte(cpu.pc + 2)
							cpu.sp = most_significant_byte << 7 | least_significant_byte
							cpu.pc += 3
						}
					}
				}
				.a_from_byte_address {
					address := cpu.read_byte(cpu.pc + 1)
					cpu.registers.a = cpu.read_byte(0xFF00 | address)
					cpu.pc += 2
				}
				.byte_address_from_a {
					address := cpu.read_byte(cpu.pc + 1)
					cpu.write_byte(0xFF00 | address, cpu.registers.a)
					cpu.pc += 2
				}
				.indirect_from_a {
					match instr.indirect {
						.bc_indirect {
							cpu.write_byte(cpu.registers.get_bc(), cpu.registers.a)
						}
						.de_indirect {
							cpu.write_byte(cpu.registers.get_de(), cpu.registers.a)
						}
						.hl_indirect_minus {
							cpu.write_byte(cpu.registers.get_hl(), cpu.registers.a)
							cpu.registers.set_hl(cpu.registers.get_hl() - 1)
						}
						.hl_indirect_plus {
							cpu.write_byte(cpu.registers.get_hl(), cpu.registers.a)
							cpu.registers.set_hl(cpu.registers.get_hl() + 1)
						}
						else {
							panic('Unknown indirect mode: ${instr.indirect}')
						}
					}
					cpu.pc++
				}
				else {
					panic('Unknown load type: ${instr.load_type}')
				}
			}
		}
		.push {
			value := match instr.target_u16 {
				.bc { cpu.registers.get_bc() }
				.de { cpu.registers.get_de() }
				.hl { cpu.registers.get_hl() }
				.af { cpu.registers.get_af() }
				else { panic('Target not supported for push instruction: ${instr.target_u16}') }
			}
			cpu.push_u16(value)
			cpu.pc++
		}
		.pop {
			result := cpu.pop_u16()
			match instr.target_u16 {
				.bc { cpu.registers.set_bc(result) }
				.de { cpu.registers.set_de(result) }
				.hl { cpu.registers.set_hl(result) }
				.af { cpu.registers.set_af(result) }
				else { panic('Target not supported for pop instruction: ${instr.target_u16}') }
			}
			cpu.pc++
		}
		.rst {
			cpu.rst(instr.rst_location)
		}
		else {
			panic('Instruction not supported: ${instr.instruction}.')
		}
	}
	return cpu.pc
}

// Initialize the cpu with default values.
fn (mut cpu Cpu) init() {
	cpu.registers.set_af(0x01B0)
	cpu.registers.set_bc(0x0013)
	cpu.registers.set_de(0x00D8)
	cpu.registers.set_hl(0x014D)
	cpu.pc = 0x0100
	cpu.sp = 0xFFFE
}

// Extract the next instruction and execute it.
fn (mut cpu Cpu) step() {
	mut instruction_byte := cpu.read_byte(cpu.pc)
	prefixed := instruction_byte == 0xCB
	if prefixed {
		instruction_byte = cpu.read_byte(cpu.pc + 1)
	}
	//println('pc ${cpu.pc.hex()}: ${instruction_byte.hex()} | ${instruction_name_from_byte(instruction_byte,	prefixed)}')
	instruction := instruction_from_byte(instruction_byte, prefixed)
	next_pc := if instruction == instruction_from_byte(instruction_byte, prefixed) {
		cpu.execute(instruction)
	} else {
		x := if prefixed { 'cb' } else { '' }
		description := '0x${x}${instruction_byte}'
		panic('Unknown instruction found for : ${description}')
	}
	cpu.pc = next_pc
}

fn (mut cpu Cpu) read_byte(address u16) u8 {
	if address < 0x8000 {
		// ROM Data
		return cpu.vboy.cart.read_byte(address)
	} else if address < 0xA000 {
		// Char/map data
		panic('PPU vram writing not implemented')
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

fn (mut cpu Cpu) write_byte(address u16, value u8) {
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

fn (mut cpu Cpu) read_u16(address u16) u16 {
	low := u16(cpu.read_byte(address))
	high := u16(cpu.read_byte(address + 1))
	return low | high << 8
}

fn (mut cpu Cpu) write_u16(address u16, value u16) {
	cpu.write_byte(address + 1, u8(value >> 8))
	cpu.write_byte(address, u8(value))
}

fn (cpu Cpu) get_interruption_flags() u8 {
	return cpu.interruption_flags
}

fn (mut cpu Cpu) set_interruption_flags(value u8) {
	cpu.interruption_flags = value
}

fn (mut cpu Cpu) print() {
	cpu.registers.print()
	println('| PC: ${cpu.pc.hex()}')
	println('| SP: ${cpu.sp.hex()}')
	println('----------------------')
}