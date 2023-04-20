module main

struct Cpu {
mut:
	registers Registers
}

fn (mut cpu Cpu) execute(instruction Instruction, target ArithmeticTarget) {
	match instruction {
		add {
			match target {
				c {
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

fn (cpu Cpu) add(value u8) u8 {
	print("add")
	return u8(1)
}
