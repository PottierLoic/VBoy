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
      match instr.jump_instruction {
        .jp { cpu.jump(should_jump) }
        .call { cpu.call(should_jump) }
        .ret { cpu.ret(should_jump) }
      }
    }
    InstructionTarget {
      match instr.reg_instruction {
        .add {
          match instr.target {
            .c {
              mut value := cpu.registers.c
              mut new_value := cpu.add(value)
              cpu.registers.a = new_value
              cpu.pc++
            }
            /* TODO: Support all remaining targets. */
            else { println("not supported target") }
          }
        }
        /* TODO: Support all remaining instructions. */
        else { println("not supported instruction") }
      }
    }
    InstructionLoad {
      match instr.mem_instruction {
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
  new_value, did_overflow := cpu.registers.overflowing_add(cpu.registers.a, value)
  flags := FlagsRegister{
    zero: new_value == 0
    subtract: false
    half_carry: (cpu.registers.a & 0xf) + (value & 0xf) > 0xf
    carry: did_overflow
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
