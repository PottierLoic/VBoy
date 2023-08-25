module main

import vboy

pub fn test_inc() {
	mut cpu := vboy.Cpu{}

	// no half/full overflow and non-zero result
	cpu.registers.a = 1
	cpu.execute(vboy.Instruction{instruction: .inc})
	assert cpu.registers.a == 2
	assert cpu.registers.f == 0b00000000

	// half overflow and non-zero result
	cpu.registers.a = 127
	cpu.execute(vboy.Instruction{instruction: .inc})
	assert cpu.registers.a == 128
	assert cpu.registers.f == 0b00100000

	// full overflow and zero result
	cpu.registers.a = 255
	cpu.execute(vboy.Instruction{instruction: .inc})
	assert cpu.registers.a == 0
	assert cpu.registers.f == 0b10100000
}