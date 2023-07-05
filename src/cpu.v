struct Cpu {
mut:
  registers Registers
  pc u16
  bus MemoryBus
}

/* Execute the provided instruction and resturn next program counter. */
fn (mut cpu Cpu) execute(instr Instruction_Target) u16 {
  instruction := instr.instruction
  target := instr.target
  match instruction {
    .add {
      match target {
        .c {
          mut value := cpu.registers.c
          mut new_value := cpu.add(value)
          cpu.registers.a = new_value
          cpu.pc += 1
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
