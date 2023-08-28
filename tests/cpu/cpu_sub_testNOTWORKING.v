module main

import vboy

pub fn test_sub() {
	mut vb := vboy.VBoy{}

	// no half/full overflow and non-zero result
	vb.cpu.registers.a = 3
	vb.cpu.registers.c = 1
	vb.cpu.execute(vboy.Instruction{instruction: .sub, target_u8: .c})
	assert vb.cpu.registers.a == 2
	assert vb.cpu.registers.f == 0b01000000

	// no half/full overflow and zero result
	vb.cpu.registers.a = 1
	vb.cpu.registers.c = 1
	vb.cpu.execute(vboy.Instruction{instruction: .sub, target_u8: .c})
	assert vb.cpu.registers.a == 0
	assert vb.cpu.registers.f == 0b11000000

	// TODO: full/half overflow and non-zero result
	vb.cpu.registers.a = 0
	vb.cpu.registers.c = 1
	vb.cpu.execute(vboy.Instruction{instruction: .sub, target_u8: .c})
	assert vb.cpu.registers.a == 255
	assert vb.cpu.registers.f == 0b01110000

	// TODO: half overflow and non-zero result
	vb.cpu.registers.a = 16
	vb.cpu.registers.c = 1
	vb.cpu.execute(vboy.Instruction{instruction: .sub, target_u8: .c})
	assert vb.cpu.registers.a == 15
	assert vb.cpu.registers.f == 0b01100000

	// TODO: half overflow and zero result
	vb.cpu.registers.a = 16
	vb.cpu.registers.c = 16
	vb.cpu.execute(vboy.Instruction{instruction: .sub, target_u8: .c})
	assert vb.cpu.registers.a == 0
	assert vb.cpu.registers.f == 0b11000000
}