module main

import vboy

pub fn test_get() {
	mut vb := vboy.VBoy{}

	vb.cpu.registers.a = 0x10
	vb.cpu.registers.f = 0x11
	vb.cpu.registers.b = 0x12
	vb.cpu.registers.c = 0x13
	vb.cpu.registers.d = 0x14
	vb.cpu.registers.e = 0x15
	vb.cpu.registers.h = 0x16
	vb.cpu.registers.l = 0x17
	vb.cpu.registers.pc = 0x18
	vb.cpu.registers.sp = 0x19

	// Check if all the get functions return the good values
	assert vb.cpu.get_reg(.reg_a) == 0x10
	assert vb.cpu.get_reg(.reg_f) == 0x11
	assert vb.cpu.get_reg(.reg_b) == 0x12
	assert vb.cpu.get_reg(.reg_c) == 0x13
	assert vb.cpu.get_reg(.reg_d) == 0x14
	assert vb.cpu.get_reg(.reg_e) == 0x15
	assert vb.cpu.get_reg(.reg_h) == 0x16
	assert vb.cpu.get_reg(.reg_l) == 0x17
	assert vb.cpu.get_reg(.reg_pc) == 0x18
	assert vb.cpu.get_reg(.reg_sp) == 0x19

	assert vb.cpu.get_reg(.reg_af) == 0x1011
	assert vb.cpu.get_reg(.reg_bc) == 0x1213
	assert vb.cpu.get_reg(.reg_de) == 0x1415
	assert vb.cpu.get_reg(.reg_hl) == 0x1617
}
