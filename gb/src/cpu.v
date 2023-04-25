struct Cpu {
mut:
	registers Registers
	pc u16
	bus MemoryBus
}

fn (mut cpu Cpu) execute(instr Instruction_Target) {
	instruction := instr.instruction
	target := instr.target
	match instruction {
		.add {
			match target {
				.c {
					mut value := cpu.registers.c
					mut new_value := cpu.add(value)
					cpu.registers.a = new_value
				}
				else {
					println("not supported target")
				}
			}
		}
		else {
			println("not supported instruction")
		}
	}
}

fn (mut cpu Cpu) step() {
	mut instruction_byte := cpu.bus.read_byte(cpu.pc)
}

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




