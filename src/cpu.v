type Instruction = InstructionTarget | InstructionCondition

struct Cpu {
mut:
  registers Registers
  pc u16
  bus MemoryBus
}

/* Execute the provided instruction and return next program counter. */
fn (mut cpu Cpu) execute(instr Instruction) u16 {

  match instr {
    InstructionCondition {
      match instr.jump_instruction {
        .jp {
          should_jump := match instr.condition {
            .not_zero { u8_to_flag(cpu.registers.f).zero }
            else { panic("not supported jump condition: ${instr.condition}") }
          }
          cpu.jump(should_jump)
          return cpu.pc
        }
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
      return cpu.pc
    }
  }
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
fn (mut cpu Cpu) add(value u8) u8 {
  new_value, did_overflow := cpu.registers.overflowing_add('a', value)
  flags := FlagsRegister{
    zero: new_value == 0
    subtract: false
    half_carry: (cpu.registers.a & 0xf) + (value & 0xf) > 0xf
    carry: did_overflow
  }
  cpu.registers.f = flag_to_u8(flags)
  return new_value
}
