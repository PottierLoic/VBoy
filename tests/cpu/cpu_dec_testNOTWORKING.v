module main

import vboy

pub fn test_dec() {
	mut cpu := vboy.Cpu{}

	// no half/full overflow and non-zero result
	cpu.registers.a = 2
	cpu.execute(vboy.Instruction{instruction: .dec})
	assert cpu.registers.a == 1
	assert cpu.registers.f == 0b01000000

	// half overflow and non-zero result
	cpu.registers.a = 128
	cpu.execute(vboy.Instruction{instruction: .dec})
	assert cpu.registers.a == 127
	assert cpu.registers.f == 0b01100000

	// half/full overflow and non-zero result
	cpu.registers.a = 0
	cpu.execute(vboy.Instruction{instruction: .dec})
	assert cpu.registers.a == 255
	assert cpu.registers.f == 0b01000000
}