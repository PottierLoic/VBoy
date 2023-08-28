module main

import vboy

pub fn test_adc() {
	mut vb := vboy.VBoy{}

	// no half/full overflow and non-zero result
	vb.cpu.registers.a = 1
	vb.cpu.registers.c = 2
	vb.cpu.execute(vboy.Instruction{instruction: .adc, target_u8: .c})
	assert vb.cpu.registers.a == 3
	assert vb.cpu.registers.f == 0b00000000

	// half overflow and non-zero result
	vb.cpu.registers.a = 127
	vb.cpu.registers.c = 4
	vb.cpu.execute(vboy.Instruction{instruction: .adc, target_u8: .c})
	assert vb.cpu.registers.a == 131
	assert vb.cpu.registers.f == 0b00100000

	// full overflow and non-zero result
	vb.cpu.registers.a = 255
	vb.cpu.registers.c = 1
	vb.cpu.execute(vboy.Instruction{instruction: .adc, target_u8: .c})
	assert vb.cpu.registers.a == 1
	assert vb.cpu.registers.f == 0b00010000
}