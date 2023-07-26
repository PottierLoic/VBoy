struct Cpu {
mut:
  registers Registers
  pc u16
  sp u16
  bus MemoryBus
}

/* Execute the provided instruction and return next program counter. */
fn (mut cpu Cpu) execute(instr Instruction) u16 {
  match instr.instruction {
    .nop {
      cpu.pc++
    }
    .halt {
      // should maybe be a flag on a register not sure of that
      // THIS IS A TEMPORARY MEASURE IT SHOULD AND WILL NOT STAY LIKE THIS
    }
    .jp {
      should_jump := match instr.jump_test {
        .not_zero { !u8_to_flag(cpu.registers.f).zero }
        .not_carry { !u8_to_flag(cpu.registers.f).carry }
        .zero { u8_to_flag(cpu.registers.f).zero }
        .carry { u8_to_flag (cpu.registers.f).carry }
        .always { true }
      }
      cpu.jump(should_jump)
    }
    .call {
      should_jump := match instr.jump_test {
        .not_zero { !u8_to_flag(cpu.registers.f).zero }
        .not_carry { !u8_to_flag(cpu.registers.f).carry }
        .zero { u8_to_flag(cpu.registers.f).zero }
        .carry { u8_to_flag (cpu.registers.f).carry }
        .always { true }
      }
      cpu.call(should_jump)
    }
    .ret {
      should_jump := match instr.jump_test {
        .not_zero { !u8_to_flag(cpu.registers.f).zero }
        .not_carry { !u8_to_flag(cpu.registers.f).carry }
        .zero { u8_to_flag(cpu.registers.f).zero }
        .carry { u8_to_flag (cpu.registers.f).carry }
        .always { true }
      }
      cpu.ret(should_jump)
    }
    .add {
      cpu.registers.a = cpu.add(cpu.registers.target_to_reg8(instr.target_u8))
      cpu.pc++
    }
    .adc {
      cpu.registers.a = cpu.adc(cpu.registers.target_to_reg8(instr.target_u8))
      cpu.pc++
    }
    .sub {
      cpu.registers.a = cpu.sub(cpu.registers.target_to_reg8(instr.target_u8))
      cpu.pc++
    }
    .sbc {
      cpu.registers.a = cpu.sbc(cpu.registers.target_to_reg8(instr.target_u8))
      cpu.pc++
    }
    .and {
      cpu.registers.a = cpu.and(cpu.registers.target_to_reg8(instr.target_u8))
      cpu.pc++
    }
    .or_ {
      cpu.registers.a = cpu.or_(cpu.registers.target_to_reg8(instr.target_u8))
      cpu.pc++
    }
    .xor {
      cpu.registers.a = cpu.xor(cpu.registers.target_to_reg8(instr.target_u8))
      cpu.pc++
    }
    .cp {
      cpu.cp(cpu.registers.target_to_reg8(instr.target_u8))
      cpu.pc++
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
        else { panic("Not supported target for inc instruction: ${instr.target_u8}") }
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
        else { panic("Not supported target for dec instruction: ${instr.target_u8}") }
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
        else { panic("Not supported target for res instruction: ${instr.target_u8}") }
      }
      cpu.pc++
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
        else { panic("Not supported target for set instruction: ${instr.target_u8}") }
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
        else { panic("Not supported target for srl instruction: ${instr.target_u8}") }
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
        else { panic("Not supported target for rr instruction: ${instr.target_u8}") }
      }
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
        else { panic("Not supported target for rl instruction: ${instr.target_u8}") }
      }
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
        else { panic("Not supported target for rrc instruction: ${instr.target_u8}") }
      }
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
        else { panic("Not supported target for rlc instruction: ${instr.target_u8}") }
      }
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
        else { panic("Not supported target for sra instruction: ${instr.target_u8}") }
      }
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
        else { panic("Not supported target for sla instruction: ${instr.target_u8}") }
      }
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
        else { panic("Not supported target for swap instruction: ${instr.target_u8}") }
      }
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
            .d8 { cpu.bus.read_byte(cpu.pc + 1) }
            .hli { cpu.bus.read_byte(cpu.registers.get_hl()) }
          }
          match instr.byte_target {
            .a { cpu.registers.a = source_value }
            .b { cpu.registers.b = source_value }
            .c { cpu.registers.c = source_value }
            .d { cpu.registers.d = source_value }
            .e { cpu.registers.e = source_value }
            .h { cpu.registers.h = source_value }
            .l { cpu.registers.l = source_value }
            .hli { cpu.bus.write_byte(cpu.registers.get_hl(), source_value) }
          }
          match instr.byte_source {
            .d8 { cpu.pc += 2 }
            else { cpu.pc++ }
          }
        }
        else { panic("Unknown load type: ${instr.load_type}") }
      }
    }
    .push {
      value := match instr.target_u16 {
        .bc { cpu.registers.get_bc() }
        .de { cpu.registers.get_de() }
        .hl { cpu.registers.get_hl() }
        .af { cpu.registers.get_af() }
        else { panic("Target not supported for push instruction: ${instr.target_u16}") }
      }
      cpu.push(value)
      cpu.pc++
    }
    .pop {
      result := cpu.pop()
      match instr.target_u16 {
        .bc { cpu.registers.set_bc(result) }
        .de { cpu.registers.set_de(result) }
        .hl { cpu.registers.set_hl(result) }
        .af { cpu.registers.set_af(result) }
        else { panic("Target not supported for pop instruction: ${instr.target_u16}") }
      }
      cpu.pc++
    }
    else { panic("Instruction not supported: ${instr.instruction}.") }
  }
  return cpu.pc
}

/* Initialize the cpu with default values. */
fn (mut cpu Cpu) init () {
  cpu.registers.a = 0x1
  cpu.pc = 100
}

/* Jump to next address if the condition is met. */
fn (mut cpu Cpu) jump (should_jump bool) {
  if should_jump {
    mut least_significant_byte := u16(cpu.bus.read_byte(cpu.pc + 1))
    mut most_significant_byte := u16(cpu.bus.read_byte(cpu.pc + 2))
    cpu.pc = most_significant_byte << 8 | least_significant_byte
  } else {
    cpu.pc += 3
  }
}

/* Extract the next instruction and execute it. */
fn (mut cpu Cpu) step() {
  mut instruction_byte := cpu.bus.read_byte(cpu.pc)
  println(instruction_byte)
  prefixed := instruction_byte == 0xCB
  if prefixed {
    instruction_byte = cpu.bus.read_byte(cpu.pc + 1)
  }
  instruction := instruction_from_byte(instruction_byte, prefixed)
  next_pc := if instruction == instruction_from_byte(instruction_byte, prefixed) {
    cpu.execute(instruction)
  } else {
    x := if prefixed { "cb" } else { "" }
    description := "0x${x}${instruction_byte}"
    panic("Unknown instruction found for : ${description}")
  }
  cpu.pc = next_pc
}

/* Add the target value to register A and change flags. */
fn (mut cpu Cpu) add (value u8) u8 {
  new_value, did_overflow := overflowing_add(cpu.registers.a, value)
  flags := FlagsRegister{
    zero: new_value == 0
    subtract: false
    half_carry: (cpu.registers.a & 0xf) + (value & 0xf) > 0xf
    carry: did_overflow
  }
  cpu.registers.f = flag_to_u8(flags)
  return new_value
}

/* Add the target value to register A, change flags and add carry value to register A. */
fn (mut cpu Cpu) adc (value u8) u8 {
  mut new_value, did_overflow := overflowing_add(cpu.registers.a, value)
  if did_overflow { new_value++ }
  flags := FlagsRegister{
    zero: new_value == 0
    subtract: false
    half_carry: (cpu.registers.a & 0xf) + (value & 0xf) > 0xf
    carry: did_overflow
  }
  cpu.registers.f = flag_to_u8(flags)
  return new_value
}

/* Subtract the value from register A and change flags. */
fn (mut cpu Cpu) sub (value u8) u8 {
  new_value, did_underflow := underflowing_subtract(cpu.registers.a, value)
  flags := FlagsRegister{
    zero: new_value == 0
    subtract: true
    half_carry: (cpu.registers.a & 0xF) < (value & 0xF)
    carry: did_underflow
  }
  cpu.registers.f = flag_to_u8(flags)
  return new_value
}

/* Subtract the value from register A, change flags and subtract carry value from register A. */
fn (mut cpu Cpu) sbc (value u8) u8 {
  mut new_value, did_underflow := underflowing_subtract(cpu.registers.a, value)
  if did_underflow { new_value-- }
  flags := FlagsRegister{
    zero: new_value == 0
    subtract: true
    half_carry: (cpu.registers.a & 0xF) < (value & 0xF)
    carry: did_underflow
  }
  cpu.registers.f = flag_to_u8(flags)
  return new_value
}

/* Perform the and operation between register A and the target */
fn (mut cpu Cpu) and (value u8) u8 {
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

/* Perform the or operation between register A and the target */
fn (mut cpu Cpu) or_ (value u8) u8 {
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

/* Perform the xor operation between register A and the target */
fn (mut cpu Cpu) xor (value u8) u8 {
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

/* Subtract target value from register A and change flags but don't change A value */
fn (mut cpu Cpu) cp (value u8) {
  new_value, did_underflow := underflowing_subtract(cpu.registers.a, value)
  flags := FlagsRegister{
    zero: new_value == 0
    subtract: true
    half_carry: (cpu.registers.a & 0xF) < (value & 0xF)
    carry: did_underflow
  }
  cpu.registers.f = flag_to_u8(flags)
}

/* Increment the value of the target register and change flags */
fn (mut cpu Cpu) inc (reg RegisterU8) u8 {
  mut new_value := cpu.registers.target_to_reg8(reg)
  new_value++
  mut flags := u8_to_flag(cpu.registers.f)
  flags.zero = new_value == 0
  flags.subtract = false
  flags.half_carry = (cpu.registers.a & 0xf) + 1 > 0xf
  cpu.registers.f = flag_to_u8(flags)
  return new_value
}

/* decement the value of the target register and change flags */
fn (mut cpu Cpu) dec (reg RegisterU8) u8 {
  mut new_value := cpu.registers.target_to_reg8(reg)
  new_value--
  mut flags := u8_to_flag(cpu.registers.f)
  flags.zero = new_value == 0
  flags.subtract = true
  flags.half_carry = (cpu.registers.a & 0xF) < 1
  cpu.registers.f = flag_to_u8(flags)
  return new_value
}

/* Rotate the bits or register A to the right and set the carry to the left most bit of the register */
fn (mut cpu Cpu) rra () u8 {
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

/* Rotate the bits or register A to the left and set the carry to the right most bit of the register */
fn (mut cpu Cpu) rla () u8 {
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

/* Rotate the bits or register A to the right and set carry bit value to old bit 0 value */
fn (mut cpu Cpu) rrca () u8 {
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

/* Rotate the bits or register A to the left and set carry bit value to old bit 7 value*/
fn (mut cpu Cpu) rlca () u8 {
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

/* Toggle all the bits or register A */
fn (mut cpu Cpu) cpl () u8 {
  mut new_value := cpu.registers.a
  new_value ^= 0xFF
  mut flags := u8_to_flag(cpu.registers.f)
  flags.subtract = true
  flags.half_carry = true
  cpu.registers.f = flag_to_u8(flags)
  return new_value
}

/* Toggle the value of the carry flag */
fn (mut cpu Cpu) ccf () {
  mut flags := u8_to_flag(cpu.registers.f)
  flags.carry = !flags.carry
  cpu.registers.f = flag_to_u8(flags)
}

/* Set the value of the carry flag to true */
fn (mut cpu Cpu) scf () {
  mut flags := u8_to_flag(cpu.registers.f)
  flags.carry = true
  cpu.registers.f = flag_to_u8(flags)
}

/* Set zero flag to the value of the provided bit position in provided register */
fn (mut cpu Cpu) bit (bit Position, value u8) {
  mut flags := u8_to_flag(cpu.registers.f)
  flags.zero = (value & (1 << int(bit))) == 0
  flags.subtract = false
  flags.half_carry = true
  cpu.registers.f = flag_to_u8(flags)
}

/* Set the value of the provided bit position in provided register to 0 */
fn (mut cpu Cpu) res (bit Position, value u8) u8 {
  return value^(1 << int(bit))
}

/* Set the value of the provided bit position in provided register to 1 */
fn (mut cpu Cpu) set (bit Position, value u8) u8 {
  return value | (1 << int(bit))
}

/* bit shift value right by 1 */
fn (mut cpu Cpu) srl (value u8) u8 {
  return value >> 1
}

fn (mut cpu Cpu) rr (value u8) u8 {
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

fn (mut cpu Cpu) rl (value u8) u8 {
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

fn (mut cpu Cpu) rrc (value u8) u8 {
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

fn (mut cpu Cpu) rlc (value u8) u8 {
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

fn (mut cpu Cpu) sra (value u8) u8 {
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

fn (mut cpu Cpu) sla (value u8) u8 {
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

fn (mut cpu Cpu) swap (value u8) u8 {
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

fn (mut cpu Cpu) push (value u16) {
  cpu.sp--
  cpu.bus.write_byte(cpu.sp, u8((value & 0xFF00) >> 8))
  cpu.sp--
  cpu.bus.write_byte(cpu.sp, u8(value & 0xFF))
}

fn (mut cpu Cpu) pop () u16 {
  lsb := u16(cpu.bus.read_byte(cpu.sp))
  cpu.sp++
  msb := u16(cpu.bus.read_byte(cpu.sp))
  cpu.sp++
  return (msb << 8) | lsb
}

fn (mut cpu Cpu) call (should_jump bool) {
  next_pc := cpu.pc + 3
  if should_jump {
    cpu.push(next_pc)
    // MUST IMPLEMENT READ NEXT WORD
  } else {
    cpu.pc = next_pc
  }
}

fn (mut cpu Cpu) ret (should_jump bool) {
  if should_jump {
    cpu.pop()
  } else {
    cpu.pc++
  }
}


fn (mut cpu Cpu) print () {
  cpu.registers.print()
  println("| PC: ${cpu.pc}")
  println("| SP: ${cpu.sp}")
  println("----------------------")
}
