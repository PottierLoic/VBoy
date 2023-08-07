// Jump to next address if the condition is met.
fn (mut cpu Cpu) jump(should_jump bool) {
	if should_jump {
		mut least_significant_byte := u16(cpu.read_byte(cpu.pc + 1))
		mut most_significant_byte := u16(cpu.read_byte(cpu.pc + 2))
		cpu.pc = most_significant_byte << 8 | least_significant_byte
		cpu.vboy.timer_cycle(4)
	} else {
		cpu.pc += 3
		cpu.vboy.timer_cycle(3)
	}
}

// Jump to the next pc + offset (signed u8 direct read)
fn (mut cpu Cpu) jr(should_jump bool) {
	if should_jump {
		mut offset := int(cpu.read_byte(cpu.pc + 1))
		if offset > 127 { offset -= 256 }
		cpu.pc += 2
		cpu.pc += u16(offset)
		cpu.vboy.timer_cycle(3)
	} else {
		cpu.pc += 2
		cpu.vboy.timer_cycle(2)
	}
}

fn (mut cpu Cpu) rst(loc RSTLocation) {
	cpu.push_u16(cpu.pc + 1)
	cpu.pc = match loc {
		.x00 { 0x0000 }
		.x08 { 0x0008 }
		.x10 { 0x0010 }
		.x18 { 0x0018 }
		.x20 { 0x0020 }
		.x28 { 0x0028 }
		.x30 { 0x0030 }
		.x38 { 0x0038 }
	}
	cpu.vboy.timer_cycle(4)
}

// Add the target value to register A and change flags.
fn (mut cpu Cpu) add(reg RegisterU8) u8 {
	value := match reg {
		.hli {
			cpu.vboy.timer_cycle(1)
			cpu.read_byte(cpu.registers.get_hl())
		}
		.d8 {
			cpu.vboy.timer_cycle(1)
			cpu.read_byte(cpu.pc + 1)
		}
		else {
			cpu.registers.target_to_reg8(reg)
		}
	}
	new_value, did_overflow := overflowing_add(cpu.registers.a, value)
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: (cpu.registers.a & 0xf) + (value & 0xf) > 0xf
		carry: did_overflow
	}
	cpu.registers.f = flag_to_u8(flags)
	cpu.vboy.timer_cycle(1)
	return new_value
}

// Add the target value to register A, change flags and add carry value to register A.
fn (mut cpu Cpu) adc(reg RegisterU8) u8 {
	value := match reg {
		.hli {
			cpu.vboy.timer_cycle(1)
			cpu.read_byte(cpu.registers.get_hl())
		}
		.d8 {
			cpu.vboy.timer_cycle(1)
			cpu.read_byte(cpu.pc + 1)
		}
		else {
			cpu.registers.target_to_reg8(reg)
		}
	}
	mut new_value, did_overflow := overflowing_add(cpu.registers.a, value)
	if did_overflow {
		new_value++
	}
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: (cpu.registers.a & 0xf) + (value & 0xf) > 0xf
		carry: did_overflow
	}
	cpu.registers.f = flag_to_u8(flags)
	cpu.vboy.timer_cycle(1)
	return new_value
}

// Subtract the value from register A and change flags.
fn (mut cpu Cpu) sub(reg RegisterU8) u8 {
	value := match reg {
		.hli {
			cpu.vboy.timer_cycle(1)
			cpu.read_byte(cpu.registers.get_hl())
		}
		.d8 {
			cpu.vboy.timer_cycle(1)
			cpu.read_byte(cpu.pc + 1)
		}
		else {
			cpu.registers.target_to_reg8(reg)
		}
	}
	new_value, did_underflow := underflowing_subtract(cpu.registers.a, value)
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: true
		half_carry: (cpu.registers.a & 0xF) < (value & 0xF)
		carry: did_underflow
	}
	cpu.registers.f = flag_to_u8(flags)
	cpu.vboy.timer_cycle(1)
	return new_value
}

// Subtract the value from register A, change flags and subtract carry value from register A.
fn (mut cpu Cpu) sbc(reg RegisterU8) u8 {
	value := match reg {
		.hli {
			cpu.vboy.timer_cycle(1)
			cpu.read_byte(cpu.registers.get_hl())
		}
		.d8 {
			cpu.vboy.timer_cycle(1)
			cpu.read_byte(cpu.pc + 1)
		}
		else {
			cpu.registers.target_to_reg8(reg)
		}
	}
	mut new_value, did_underflow := underflowing_subtract(cpu.registers.a, value)
	if did_underflow {
		new_value--
	}
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: true
		half_carry: (cpu.registers.a & 0xF) < (value & 0xF)
		carry: did_underflow
	}
	cpu.registers.f = flag_to_u8(flags)
	cpu.vboy.timer_cycle(1)
	return new_value
}

// Perform the and operation between register A and the target
fn (mut cpu Cpu) and(value u8) u8 {
	new_value := cpu.registers.a & value
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: true
		carry: false
	}
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

// Perform the or operation between register A and the target
fn (mut cpu Cpu) @or(value u8) u8 {
	new_value := cpu.registers.a | value
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: false
		carry: false
	}
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

// Perform the xor operation between register A and the target
fn (mut cpu Cpu) xor(value u8) u8 {
	new_value := cpu.registers.a ^ value
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: false
		carry: false
	}
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

// Subtract target value from register A and change flags but don't change A value
fn (mut cpu Cpu) cp(value u8) {
	new_value, did_underflow := underflowing_subtract(cpu.registers.a, value)
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: true
		half_carry: (cpu.registers.a & 0xF) < (value & 0xF)
		carry: did_underflow
	}
	cpu.registers.f = flag_to_u8(flags)
}

// Increment the value of the target register and change flags
fn (mut cpu Cpu) inc(reg RegisterU8) u8 {
	mut new_value := cpu.registers.target_to_reg8(reg)
	new_value++
	mut flags := u8_to_flag(cpu.registers.f)
	flags.zero = new_value == 0
	flags.subtract = false
	flags.half_carry = (cpu.registers.a & 0xf) + 1 > 0xf
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

// decement the value of the target register and change flags
fn (mut cpu Cpu) dec(reg RegisterU8) u8 {
	mut new_value := cpu.registers.target_to_reg8(reg)
	new_value--
	mut flags := u8_to_flag(cpu.registers.f)
	flags.zero = new_value == 0
	flags.subtract = true
	flags.half_carry = (cpu.registers.a & 0xF) < 1
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

// Rotate the bits or register A to the right and set the carry to the left most bit of the register
fn (mut cpu Cpu) rra() u8 {
	mut new_value := cpu.registers.a
	carry := new_value & 0x1
	new_value >>= 1
	new_value |= carry << 7
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: false
		carry: carry == 1
	}
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

// Rotate the bits or register A to the left and set the carry to the right most bit of the register
fn (mut cpu Cpu) rla() u8 {
	mut new_value := cpu.registers.a
	carry := new_value >> 7
	new_value <<= 1
	new_value |= carry
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: false
		carry: carry == 1
	}
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

// Rotate the bits or register A to the right and set carry bit value to old bit 0 value
fn (mut cpu Cpu) rrca() u8 {
	mut new_value := cpu.registers.a
	carry := new_value & 0x1
	new_value >>= 1
	new_value |= carry << 7
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: false
		carry: carry == 1
	}
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

// Rotate the bits or register A to the left and set carry bit value to old bit 7 value
fn (mut cpu Cpu) rlca() u8 {
	mut new_value := cpu.registers.a
	carry := new_value >> 7
	new_value <<= 1
	new_value |= carry
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: false
		carry: carry == 1
	}
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

// Toggle all the bits or register A
fn (mut cpu Cpu) cpl() u8 {
	mut new_value := cpu.registers.a
	new_value ^= 0xFF
	mut flags := u8_to_flag(cpu.registers.f)
	flags.subtract = true
	flags.half_carry = true
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

// Toggle the value of the carry flag
fn (mut cpu Cpu) ccf() {
	mut flags := u8_to_flag(cpu.registers.f)
	flags.carry = !flags.carry
	cpu.registers.f = flag_to_u8(flags)
}

// Set the value of the carry flag to true
fn (mut cpu Cpu) scf() {
	mut flags := u8_to_flag(cpu.registers.f)
	flags.carry = true
	cpu.registers.f = flag_to_u8(flags)
}

// Set zero flag to the value of the provided bit position in provided register
fn (mut cpu Cpu) bit(bit Position, value u8) {
	mut flags := u8_to_flag(cpu.registers.f)
	flags.zero = (value & (1 << int(bit))) == 0
	flags.subtract = false
	flags.half_carry = true
	cpu.registers.f = flag_to_u8(flags)
}

// Set the value of the provided bit position in provided register to 0
fn (mut cpu Cpu) res(bit Position, value u8) u8 {
	return value ^ (1 << int(bit))
}

// Set the value of the provided bit position in provided register to 1
fn (mut cpu Cpu) set(bit Position, value u8) u8 {
	return value | (1 << int(bit))
}

// bit shift value right by 1
fn (mut cpu Cpu) srl(value u8) u8 {
	return value >> 1
}

fn (mut cpu Cpu) rr(value u8) u8 {
	mut new_value := value
	carry := new_value & 0x1
	new_value >>= 1
	new_value |= carry << 7
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: false
		carry: carry == 1
	}
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

fn (mut cpu Cpu) rl(value u8) u8 {
	mut new_value := value
	carry := new_value >> 7
	new_value <<= 1
	new_value |= carry
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: false
		carry: carry == 1
	}
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

fn (mut cpu Cpu) rrc(value u8) u8 {
	mut new_value := value
	carry := new_value & 0x1
	new_value >>= 1
	new_value |= carry << 7
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: false
		carry: carry == 1
	}
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

fn (mut cpu Cpu) rlc(value u8) u8 {
	mut new_value := value
	carry := new_value >> 7
	new_value <<= 1
	new_value |= carry
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: false
		carry: carry == 1
	}
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

fn (mut cpu Cpu) sra(value u8) u8 {
	mut new_value := value
	carry := value & 0x1
	msb := (value >> 7) & 0x1
	new_value >>= 1
	new_value |= (msb << 7)
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: false
		carry: carry == 1
	}
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

fn (mut cpu Cpu) sla(value u8) u8 {
	mut new_value := value
	carry := (value >> 7) & 0x1
	lsb := value & 0x1
	new_value <<= 1
	new_value |= lsb
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: false
		carry: carry == 1
	}
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

fn (mut cpu Cpu) swap(value u8) u8 {
	upper := (value >> 4) & 0xF
	lower := value & 0xF
	new_value := (lower << 4) + upper
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: false
		carry: false
	}
	cpu.registers.f = flag_to_u8(flags)
	return new_value
}

fn (mut cpu Cpu) push(value u8) {
	cpu.sp--
	cpu.write_byte(cpu.sp, value)
}

fn (mut cpu Cpu) pop() u8 {
	value := cpu.read_byte(cpu.sp)
	cpu.sp--
	return value
}

fn (mut cpu Cpu) push_u16(value u16) {
	cpu.push(u8((value & 0xFF00) >> 8))
	cpu.push(u8(value))
}

fn (mut cpu Cpu) pop_u16() u16 {
	low := u16(cpu.pop())
	high := u16(cpu.pop())
	return (high << 8) | low
}

fn (mut cpu Cpu) call(should_jump bool) {
	next_pc := cpu.pc + 3
	if should_jump {
		cpu.push_u16(next_pc)
		byte_low := u16(cpu.read_byte(cpu.pc + 1))
		byte_high := u16(cpu.read_byte(cpu.pc + 2))
		cpu.pc = byte_high << 8 | byte_low
	} else {
		cpu.pc = next_pc
	}
}

// At the end of a call, get the top value of the stack and 
fn (mut cpu Cpu) ret(should_jump bool) {
	if should_jump {
		cpu.pc = cpu.pop_u16()
	} else {
		cpu.pc++
	}
}

// Add value to the target and handle overflow
fn overflowing_add(target u8, value u8) (u8, bool) {
	mut new_value := u16(target) + u16(value)
	new_value = new_value >> 8
	return u8(target + value), new_value > 0
}

// Substract value to the target and handle underflow
fn underflowing_subtract(target u8, value u8) (u8, bool) {
	mut new_value := u16(target) - u16(value)
	new_value = new_value >> 8
	return u8(target - value), new_value > 0
}
