module main

import vboy

pub fn test_set() {
	mut vb := vboy.VBoy{}

	// Check if all the set functions set the good values
	vb.cpu.set_reg(.reg_a, 0x10)
	vb.cpu.set_reg(.reg_f, 0x11)
	vb.cpu.set_reg(.reg_b, 0x12)
	vb.cpu.set_reg(.reg_c, 0x13)
	vb.cpu.set_reg(.reg_d, 0x14)
	vb.cpu.set_reg(.reg_e, 0x15)
	vb.cpu.set_reg(.reg_h, 0x16)
	vb.cpu.set_reg(.reg_l, 0x17)
	vb.cpu.set_reg(.reg_pc, 0x18)
	vb.cpu.set_reg(.reg_sp, 0x19)

	assert vb.cpu.registers.a == 0x10
	assert vb.cpu.registers.f == 0x11
	assert vb.cpu.registers.b == 0x12
	assert vb.cpu.registers.c == 0x13
	assert vb.cpu.registers.d == 0x14
	assert vb.cpu.registers.e == 0x15
	assert vb.cpu.registers.h == 0x16
	assert vb.cpu.registers.l == 0x17
	assert vb.cpu.registers.pc == 0x18
	assert vb.cpu.registers.sp == 0x19

	vb.cpu.registers.set_af(0x4567)
	vb.cpu.registers.set_bc(0xABCD)
	vb.cpu.registers.set_de(0xEF12)
	vb.cpu.registers.set_hl(0x3456)

	assert vb.cpu.registers.a == 0x45
	assert vb.cpu.registers.f == 0x67
	assert vb.cpu.registers.b == 0xAB
	assert vb.cpu.registers.c == 0xCD
	assert vb.cpu.registers.d == 0xEF
	assert vb.cpu.registers.e == 0x12
	assert vb.cpu.registers.h == 0x34
	assert vb.cpu.registers.l == 0x56
}
