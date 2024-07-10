module instructions

pub enum Instr_reg {
	reg_none
	reg_a
	reg_f
	reg_b
	reg_c
	reg_d
	reg_e
	reg_h
	reg_l
	reg_af
	reg_bc
	reg_de
	reg_hl
	reg_sp
	reg_pc
}

pub enum Instr_addr_mode {
	am_none
	am_imp // No address
	am_r_d16 // register and direct 16bit value
	am_r_r // register to register
	am_mr_r // register to memory
	am_r // register
	am_r_d8 // direct 8bit value to register
	am_r_mr // memory to register
	am_r_hli // memory at HL to register AND increase HL
	am_r_hld // memory at HL to register AND decrease HL
	am_hli_r // register to memory at HL AND increase HL
	am_hld_r // register to memory at HL AND decrease HL
	am_r_a8 // memory at PC to register
	am_a8_r // register to memory at PC
	am_hl_spr // memory at PC to HL
	am_d16 // memory at PC and PC + 1
	am_d8 // memory at PC
	am_d16_r // memory at PC and PC + 1 to register
	am_mr_d8 // direct 8bit value to memory at reg1
	am_mr // strange
	am_a16_r // register to memory at PC and PC + 1
	am_r_a16 // memory at PC and PC + 1 to register
}

pub enum Instr {
	instr_none
	// not prefixed
	instr_nop
	instr_ld
	instr_inc
	instr_dec
	instr_rlca
	instr_add
	instr_rrca
	instr_stop
	instr_rla
	instr_jr
	instr_rra
	instr_daa
	instr_cpl
	instr_scf
	instr_ccf
	instr_halt
	instr_adc
	instr_sub
	instr_sbc
	instr_and
	instr_xor
	instr_or
	instr_cp
	instr_pop
	instr_jp
	instr_push
	instr_ret
	instr_cb
	instr_call
	instr_reti
	instr_ldh
	instr_jphl
	instr_di
	instr_ei
	instr_rst
	instr_err
	// prefixed
	instr_rlc
	instr_rrc
	instr_rl
	instr_rr
	instr_sla
	instr_sra
	instr_swap
	instr_srl
	instr_bit
	instr_res
	instr_set
}

pub enum Instr_condition {
	cond_none
	cond_nz
	cond_z
	cond_nc
	cond_c
}

pub struct Instruction {
pub:
	instr_type Instr
	mode       Instr_addr_mode
	reg_1      Instr_reg // target
	reg_2      Instr_reg // source
	cond_type  Instr_condition
	parameter  u8
}

pub fn is_16_bit(reg Instr_reg) bool {
	return match reg {
		.reg_af { true }
		.reg_bc { true }
		.reg_de { true }
		.reg_hl { true }
		else { false }
	}
}
