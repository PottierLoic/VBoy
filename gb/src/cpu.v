module main

struct Cpu {
mut:
	registers Registers
}

fn (mut cpu Cpu) execute(instruction Instruction, target ArithmeticTarget) {
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

fn (mut cpu Cpu) add(value u8) u8 {
	// must replace overflowing_add that works in rust with a v equivalent
	new_value, did_overflow := cpu.registers.a.overflowing_add(value)
	flags := FlagsRegister{
		zero: new_value == 0
		subtract: false
		half_carry: (cpu.registers.a & 0xf) + (value & 0xf) > 0xf
		carry: did_overflow
	}
	cpu.registers.f = flags
	return new_value
}
