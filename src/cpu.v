struct Cpu {
mut:
  registers Registers
  pc u16
  sp u16
  bus MemoryBus
}

/* Execute the provided instruction and return next program counter. */
fn (mut cpu Cpu) execute(instr Instruction) u16 {
  match instr {
    WaitingInstruction {
      match instr {
        .nop {
          cpu.pc++
        }
        .halt {
          // should maybe be a flag on a register not sure of that
          // THIS IS A TEMPORARY MEASURE IT SHOULD AND WILL NOT STAY LIKE THIS
        }
      }
    }
    InstructionCondition {
      should_jump := match instr.condition {
        .not_zero { !u8_to_flag(cpu.registers.f).zero }
        .not_carry { !u8_to_flag(cpu.registers.f).carry }
        .zero { u8_to_flag(cpu.registers.f).zero }
        .carry { u8_to_flag (cpu.registers.f).carry }
        .always { true }
      }
      match instr.instruction {
        .jp { cpu.jump(should_jump) }
        .call { cpu.call(should_jump) }
        .ret { cpu.ret(should_jump) }
        else { panic("Instruction not supported ${instr.instruction}.") }
      }
    }
    InstructionTarget {
      match instr.instruction {
        .add {
          cpu.registers.a = cpu.add(cpu.registers.target_to_reg8(instr.target))
          cpu.pc++
        }
        .adc {
          cpu.registers.a = cpu.adc(cpu.registers.target_to_reg8(instr.target))
          cpu.pc++
        }
        .sub {
          cpu.registers.a = cpu.sub(cpu.registers.target_to_reg8(instr.target))
          cpu.pc++
        }
        .sbc {
          cpu.registers.a = cpu.sbc(cpu.registers.target_to_reg8(instr.target))
          cpu.pc++
        }
        .and {
          cpu.registers.a = cpu.and(cpu.registers.target_to_reg8(instr.target))
          cpu.pc++
        }
        .or_ {
          cpu.registers.a = cpu.or_(cpu.registers.target_to_reg8(instr.target))
          cpu.pc++
        }
        .xor {
          cpu.registers.a = cpu.xor(cpu.registers.target_to_reg8(instr.target))
          cpu.pc++
        }
        .cp {
          cpu.cp(cpu.registers.target_to_reg8(instr.target))
          cpu.pc++
        }
        .inc {
          match instr.target {
            .a { cpu.registers.a = cpu.inc(instr.target) }
            .b { cpu.registers.b = cpu.inc(instr.target) }
            .c { cpu.registers.c = cpu.inc(instr.target) }
            .d { cpu.registers.d = cpu.inc(instr.target) }
            .e { cpu.registers.e = cpu.inc(instr.target) }
            .h { cpu.registers.h = cpu.inc(instr.target) }
            .l { cpu.registers.l = cpu.inc(instr.target) }
            else { panic("Not supported target: ${instr.target}") }
          }
          cpu.pc++
        }
        .decr {
          match instr.target {
            .a { cpu.registers.a = cpu.decr(instr.target) }
            .b { cpu.registers.b = cpu.decr(instr.target) }
            .c { cpu.registers.c = cpu.decr(instr.target) }
            .d { cpu.registers.d = cpu.decr(instr.target) }
            .e { cpu.registers.e = cpu.decr(instr.target) }
            .h { cpu.registers.h = cpu.decr(instr.target) }
            .l { cpu.registers.l = cpu.decr(instr.target) }
            else { panic("Not supported target: ${instr.target}") }
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
          // need to create a struct that can hold target register + target position
        }
        .res {
          // need to create a struct that can hold target register + target position
        }
        .set {
          // need to create a struct that can hold target register + target position
        }
        /* TODO: Support all remaining instructions. */
        else { println("not supported instruction") }
      }
    }
    InstructionLoad {
      match instr.instruction {
        .ld {
          match instr.load_type {
            .byte {
              source_value := match instr.source {
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
              match instr.target {
                .a { cpu.registers.a = source_value }
                .b { cpu.registers.b = source_value }
                .c { cpu.registers.c = source_value }
                .d { cpu.registers.d = source_value }
                .e { cpu.registers.e = source_value }
                .h { cpu.registers.h = source_value }
                .l { cpu.registers.l = source_value }
                .hli { cpu.bus.write_byte(cpu.registers.get_hl(), source_value) }
              }
              match instr.source {
                .d8 { cpu.pc += 2 }
                else { cpu.pc++ }
              }
            }
            else { panic("Unknown instruction") }
          }
        }
        else { panic("Instruction not supported ${instr.instruction}.") }
      }
    }
    InstructionStack {
      match instr.instruction {
        .push {
          value := match instr.target {
            .bc { cpu.registers.get_bc() }
            .de { cpu.registers.get_de() }
            .hl { cpu.registers.get_hl() }
            .af { cpu.registers.get_af() }
          }
          cpu.push(value)
          cpu.pc++
        }
        .pop {
          result := cpu.pop()
          match instr.target {
            .bc { cpu.registers.set_bc(result) }
            .de { cpu.registers.set_de(result) }
            .hl { cpu.registers.set_hl(result) }
            .af { cpu.registers.set_af(result) }
          }
          cpu.pc++
        }
        else { panic("Instruction not supported ${instr.instruction}.") }
      }
    }
  }
  return cpu.pc
}

/* Jump to next address if the condition is met */
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

/* Decrement the value of the target register and change flags */
fn (mut cpu Cpu) decr (reg RegisterU8) u8 {
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

/* Rotate the bits or register A to the right and set the carry to the left most bit of the register */
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

/* Rotate the bits or register A to the left and set the carry to the right most bit of the register */
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
fn (mut cpu Cpu) bit (bit u8, value u8) {
  mut flags := u8_to_flag(cpu.registers.f)
  flags.zero = (value & (1 << bit)) == 0
  flags.subtract = false
  flags.half_carry = true
  cpu.registers.f = flag_to_u8(flags)
}

/* Set the value of the provided bit position in provided register to 0 */
fn (mut cpu Cpu) res (bit u8, value u8) u8 {
  return value^(1 << bit)
}

/* Set the value of the provided bit position in provided register to 1 */
fn (mut cpu Cpu) set (bit u8, value u8) u8 {
  return value | (1 << bit)
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
