module main

import vboy

pub fn test_add() {
	mut vb := vboy.VBoy{}

	// no half/full overflow and non-zero result
	vb.cpu.registers.a = 1
	vb.cpu.registers.c = 2
	vb.cpu.execute(vboy.Instruction{instruction: .add, target_u8: .c})
	assert vb.cpu.registers.a == 3
	assert vb.cpu.registers.f == 0b00000000

	// half/full overflow and zero result
	vb.cpu.registers.a = 127
	vb.cpu.registers.c = 129
	vb.cpu.execute(vboy.Instruction{instruction: .add, target_u8: .c})
	assert vb.cpu.registers.a == 0
	assert vb.cpu.registers.f == 0b10110000
}