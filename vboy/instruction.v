module vboy

pub enum Reg {
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

pub enum Addr_mode {
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

pub enum Condition {
  cond_none
  cond_nz
  cond_z
  cond_nc
  cond_c
}

pub struct Instruction {
  instr_type Instr
  mode Addr_mode
  reg_1 Reg // target
  reg_2 Reg // source
  cond_type Condition
  parameter u8
}

/* return the right instruction */
@[direct_array_access]
pub fn instruction_from_byte(opcode u8) Instruction {
  return instruction[opcode]
}

pub const instruction = [
  // 0x0X
  Instruction{instr_type: .instr_nop, mode: .am_imp}
  Instruction{instr_type: .instr_ld, mode: .am_r_d16, reg_1: .reg_bc},
  Instruction{instr_type: .instr_ld, mode: .am_mr_r, reg_1: .reg_bc, reg_2: .reg_a},
  Instruction{instr_type: .instr_inc, mode: .am_r, reg_1: .reg_bc},
  Instruction{instr_type: .instr_inc, mode: .am_r, reg_1: .reg_b},
  Instruction{instr_type: .instr_dec, mode: .am_r, reg_1: .reg_b},
  Instruction{instr_type: .instr_ld, mode: .am_r_d8, reg_1: .reg_b},
  Instruction{instr_type: .instr_rlca},
  Instruction{instr_type: .instr_ld, mode: .am_a16_r, reg_1: .reg_none, reg_2: .reg_sp},
  Instruction{instr_type: .instr_add, mode: .am_r_r, reg_1: .reg_hl, reg_2: .reg_bc},
  Instruction{instr_type: .instr_ld, mode: .am_r_mr, reg_1: .reg_a, reg_2: .reg_bc},
  Instruction{instr_type: .instr_dec, mode: .am_r, reg_1: .reg_bc},
  Instruction{instr_type: .instr_inc, mode: .am_r, reg_1: .reg_c},
  Instruction{instr_type: .instr_dec, mode: .am_r, reg_1: .reg_c},
  Instruction{instr_type: .instr_ld, mode: .am_r_d8, reg_1: .reg_c},
  Instruction{instr_type: .instr_rrca},

  //0x1X
  Instruction{instr_type: .instr_stop},
  Instruction{instr_type: .instr_ld, mode: .am_r_d16, reg_1: .reg_de},
  Instruction{instr_type: .instr_ld, mode: .am_mr_r, reg_1: .reg_de, reg_2: .reg_a},
  Instruction{instr_type: .instr_ld, mode: .am_r, reg_1: .reg_de},
  Instruction{instr_type: .instr_ld, mode: .am_r, reg_1: .reg_d},
  Instruction{instr_type: .instr_dec, mode: .am_r, reg_1: .reg_d},
  Instruction{instr_type: .instr_ld, mode: .am_r_d8, reg_1: .reg_d},
  Instruction{instr_type: .instr_rla},
  Instruction{instr_type: .instr_jr, mode: .am_d8},
  Instruction{instr_type: .instr_add, mode: .am_r_r, reg_1: .reg_hl, reg_2: .reg_de},
  Instruction{instr_type: .instr_ld, mode: .am_r_mr, reg_1: .reg_a, reg_2: .reg_de},
  Instruction{instr_type: .instr_dec, mode: .am_r, reg_1: .reg_de},
  Instruction{instr_type: .instr_ld, mode: .am_r, reg_1: .reg_e},
  Instruction{instr_type: .instr_dec, mode: .am_r, reg_1: .reg_e},
  Instruction{instr_type: .instr_ld, mode: .am_r_d8, reg_1: .reg_e},
  Instruction{instr_type: .instr_rra},

  //0x2X
  Instruction{instr_type: .instr_jr, mode: .am_d8, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_nz},
  Instruction{instr_type: .instr_ld, mode: .am_r_d16, reg_1: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_hli_r, reg_1: .reg_hl, reg_2: .reg_a},
  Instruction{instr_type: .instr_ld, mode: .am_r, reg_1: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_r, reg_1: .reg_h},
  Instruction{instr_type: .instr_dec, mode: .am_r, reg_1: .reg_h},
  Instruction{instr_type: .instr_ld, mode: .am_r_d8, reg_1: .reg_h},
  Instruction{instr_type: .instr_daa},
  Instruction{instr_type: .instr_jr, mode: .am_d8, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_z},
  Instruction{instr_type: .instr_add, mode: .am_r_r, reg_1: .reg_hl, reg_2: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_r_hli, reg_1: .reg_a, reg_2: .reg_hl},
  Instruction{instr_type: .instr_dec, mode: .am_r, reg_1: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_r, reg_1: .reg_l},
  Instruction{instr_type: .instr_dec, mode: .am_r, reg_1: .reg_l},
  Instruction{instr_type: .instr_ld, mode: .am_r_d8, reg_1: .reg_l},
  Instruction{instr_type: .instr_cpl},

  //0x3X
  Instruction{instr_type: .instr_jr, mode: .am_d8, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_nc},
  Instruction{instr_type: .instr_ld, mode: .am_r_d16, reg_1: .reg_sp},
  Instruction{instr_type: .instr_ld, mode: .am_hld_r, reg_1: .reg_hl, reg_2: .reg_a},
  Instruction{instr_type: .instr_ld, mode: .am_r, reg_1: .reg_sp},
  Instruction{instr_type: .instr_ld, mode: .am_mr, reg_1: .reg_hl},
  Instruction{instr_type: .instr_dec, mode: .am_mr, reg_1: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_mr_d8, reg_1: .reg_hl},
  Instruction{instr_type: .instr_scf},
  Instruction{instr_type: .instr_jr, mode: .am_d8, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_c},
  Instruction{instr_type: .instr_add, mode: .am_r_r, reg_1: .reg_hl, reg_2: .reg_sp},
  Instruction{instr_type: .instr_ld, mode: .am_r_hld, reg_1: .reg_a, reg_2: .reg_hl},
  Instruction{instr_type: .instr_dec, mode: .am_r, reg_1: .reg_sp},
  Instruction{instr_type: .instr_ld, mode: .am_r, reg_1: .reg_a},
  Instruction{instr_type: .instr_dec, mode: .am_r, reg_1: .reg_a},
  Instruction{instr_type: .instr_ld, mode: .am_r_d8, reg_1: .reg_a},
  Instruction{instr_type: .instr_ccf},

  //0x4X
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_b, reg_2: .reg_b},
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_b, reg_2: .reg_c},
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_b, reg_2: .reg_d},
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_b, reg_2: .reg_e},
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_b, reg_2: .reg_h},
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_b, reg_2: .reg_l},
  Instruction{instr_type: .instr_ld, mode: .am_r_mr, reg_1: .reg_b, reg_2: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_b, reg_2: .reg_a},
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_c, reg_2: .reg_b},
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_c, reg_2: .reg_c},
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_c, reg_2: .reg_d},
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_c, reg_2: .reg_e},
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_c, reg_2: .reg_h},
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_c, reg_2: .reg_l},
  Instruction{instr_type: .instr_ld, mode: .am_r_mr, reg_1: .reg_c, reg_2: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_c, reg_2: .reg_a},

  //0x5X
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_d, reg_2: .reg_b},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_d, reg_2: .reg_c},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_d, reg_2: .reg_d},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_d, reg_2: .reg_e},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_d, reg_2: .reg_h},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_d, reg_2: .reg_l},
  Instruction{instr_type: .instr_ld, mode: .am_r_mr, reg_1: .reg_d, reg_2: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_d, reg_2: .reg_a},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_e, reg_2: .reg_b},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_e, reg_2: .reg_c},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_e, reg_2: .reg_d},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_e, reg_2: .reg_e},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_e, reg_2: .reg_h},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_e, reg_2: .reg_l},
  Instruction{instr_type: .instr_ld, mode: .am_r_mr, reg_1: .reg_e, reg_2: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_e, reg_2: .reg_a},

  //0x6X
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_h, reg_2: .reg_b},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_h, reg_2: .reg_c},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_h, reg_2: .reg_d},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_h, reg_2: .reg_e},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_h, reg_2: .reg_h},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_h, reg_2: .reg_l},
  Instruction{instr_type: .instr_ld, mode: .am_r_mr, reg_1: .reg_h, reg_2: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_h, reg_2: .reg_a},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_l, reg_2: .reg_b},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_l, reg_2: .reg_c},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_l, reg_2: .reg_d},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_l, reg_2: .reg_e},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_l, reg_2: .reg_h},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_l, reg_2: .reg_l},
  Instruction{instr_type: .instr_ld, mode: .am_r_mr, reg_1: .reg_l, reg_2: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_l, reg_2: .reg_a},

  //0x7X
  Instruction{instr_type: .instr_ld, mode: .am_mr_r,  reg_1: .reg_hl, reg_2: .reg_b},
  Instruction{instr_type: .instr_ld, mode: .am_mr_r,  reg_1: .reg_hl, reg_2: .reg_c},
  Instruction{instr_type: .instr_ld, mode: .am_mr_r,  reg_1: .reg_hl, reg_2: .reg_d},
  Instruction{instr_type: .instr_ld, mode: .am_mr_r,  reg_1: .reg_hl, reg_2: .reg_e},
  Instruction{instr_type: .instr_ld, mode: .am_mr_r,  reg_1: .reg_hl, reg_2: .reg_h},
  Instruction{instr_type: .instr_ld, mode: .am_mr_r,  reg_1: .reg_hl, reg_2: .reg_l},
  Instruction{instr_type: .instr_halt},
  Instruction{instr_type: .instr_ld, mode: .am_mr_r,  reg_1: .reg_hl, reg_2: .reg_a},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_a, reg_2: .reg_b},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_a, reg_2: .reg_c},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_a, reg_2: .reg_d},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_a, reg_2: .reg_e},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_a, reg_2: .reg_h},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_a, reg_2: .reg_l},
  Instruction{instr_type: .instr_ld, mode: .am_r_mr, reg_1: .reg_a, reg_2: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_r_r,  reg_1: .reg_a, reg_2: .reg_a},

  //0x8X
  Instruction{instr_type: .instr_add, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_b},
  Instruction{instr_type: .instr_add, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_c},
  Instruction{instr_type: .instr_add, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_d},
  Instruction{instr_type: .instr_add, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_e},
  Instruction{instr_type: .instr_add, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_h},
  Instruction{instr_type: .instr_add, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_l},
  Instruction{instr_type: .instr_add, mode: .am_r_mr, reg_1: .reg_a, reg_2: .reg_hl},
  Instruction{instr_type: .instr_add, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_a},
  Instruction{instr_type: .instr_adc, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_b},
  Instruction{instr_type: .instr_adc, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_c},
  Instruction{instr_type: .instr_adc, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_d},
  Instruction{instr_type: .instr_adc, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_e},
  Instruction{instr_type: .instr_adc, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_h},
  Instruction{instr_type: .instr_adc, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_l},
  Instruction{instr_type: .instr_adc, mode: .am_r_mr, reg_1: .reg_a, reg_2: .reg_hl},
  Instruction{instr_type: .instr_adc, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_a},

  //0x9X
  Instruction{instr_type: .instr_sub, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_b},
  Instruction{instr_type: .instr_sub, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_c},
  Instruction{instr_type: .instr_sub, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_d},
  Instruction{instr_type: .instr_sub, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_e},
  Instruction{instr_type: .instr_sub, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_h},
  Instruction{instr_type: .instr_sub, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_l},
  Instruction{instr_type: .instr_sub, mode: .am_r_mr, reg_1: .reg_a, reg_2: .reg_hl},
  Instruction{instr_type: .instr_sub, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_a},
  Instruction{instr_type: .instr_sbc, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_b},
  Instruction{instr_type: .instr_sbc, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_c},
  Instruction{instr_type: .instr_sbc, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_d},
  Instruction{instr_type: .instr_sbc, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_e},
  Instruction{instr_type: .instr_sbc, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_h},
  Instruction{instr_type: .instr_sbc, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_l},
  Instruction{instr_type: .instr_sbc, mode: .am_r_mr, reg_1: .reg_a, reg_2: .reg_hl},
  Instruction{instr_type: .instr_sbc, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_a},


  //0xAX
  Instruction{instr_type: .instr_and, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_b},
  Instruction{instr_type: .instr_and, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_c},
  Instruction{instr_type: .instr_and, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_d},
  Instruction{instr_type: .instr_and, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_e},
  Instruction{instr_type: .instr_and, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_h},
  Instruction{instr_type: .instr_and, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_l},
  Instruction{instr_type: .instr_and, mode: .am_r_mr, reg_1: .reg_a, reg_2: .reg_hl},
  Instruction{instr_type: .instr_and, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_a},
  Instruction{instr_type: .instr_xor, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_b},
  Instruction{instr_type: .instr_xor, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_c},
  Instruction{instr_type: .instr_xor, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_d},
  Instruction{instr_type: .instr_xor, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_e},
  Instruction{instr_type: .instr_xor, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_h},
  Instruction{instr_type: .instr_xor, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_l},
  Instruction{instr_type: .instr_xor, mode: .am_r_mr, reg_1: .reg_a, reg_2: .reg_hl},
  Instruction{instr_type: .instr_xor, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_a},

  //0xBX
  Instruction{instr_type: .instr_or, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_b},
  Instruction{instr_type: .instr_or, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_c},
  Instruction{instr_type: .instr_or, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_d},
  Instruction{instr_type: .instr_or, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_e},
  Instruction{instr_type: .instr_or, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_h},
  Instruction{instr_type: .instr_or, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_l},
  Instruction{instr_type: .instr_or, mode: .am_r_mr, reg_1: .reg_a, reg_2: .reg_hl},
  Instruction{instr_type: .instr_or, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_a},
  Instruction{instr_type: .instr_cp, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_b},
  Instruction{instr_type: .instr_cp, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_c},
  Instruction{instr_type: .instr_cp, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_d},
  Instruction{instr_type: .instr_cp, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_e},
  Instruction{instr_type: .instr_cp, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_h},
  Instruction{instr_type: .instr_cp, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_l},
  Instruction{instr_type: .instr_cp, mode: .am_r_mr, reg_1: .reg_a, reg_2: .reg_hl},
  Instruction{instr_type: .instr_cp, mode: .am_r_r, reg_1: .reg_a, reg_2: .reg_a},

  Instruction{instr_type: .instr_ret, mode: .am_imp, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_nz},
  Instruction{instr_type: .instr_pop, mode: .am_r, reg_1: .reg_bc},
  Instruction{instr_type: .instr_jp, mode: .am_d16, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_nz},
  Instruction{instr_type: .instr_jp, mode: .am_d16},
  Instruction{instr_type: .instr_call, mode: .am_d16, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_nz},
  Instruction{instr_type: .instr_push, mode: .am_r, reg_1: .reg_bc},
  Instruction{instr_type: .instr_add, mode: .am_r_d8, reg_1: .reg_a},
  Instruction{instr_type: .instr_rst, mode: .am_imp, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_none, parameter: 0x00},
  Instruction{instr_type: .instr_ret, mode: .am_imp, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_z},
  Instruction{instr_type: .instr_ret},
  Instruction{instr_type: .instr_jp, mode: .am_d16, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_z},
  Instruction{instr_type: .instr_cb, mode: .am_d8},
  Instruction{instr_type: .instr_call, mode: .am_d16, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_z},
  Instruction{instr_type: .instr_call, mode: .am_d16},
  Instruction{instr_type: .instr_adc, mode: .am_r_d8, reg_1: .reg_a},
  Instruction{instr_type: .instr_rst, mode: .am_imp, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_none, parameter: 0x08},

  Instruction{instr_type: .instr_ret, mode: .am_imp, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_nc},
  Instruction{instr_type: .instr_pop, mode: .am_r, reg_1: .reg_de},
  Instruction{instr_type: .instr_jp, mode: .am_d16, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_nc},
  Instruction{instr_type: .instr_call, mode: .am_d16, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_nc},
  Instruction{instr_type: .instr_push, mode: .am_r, reg_1: .reg_de},
  Instruction{instr_type: .instr_sub, mode: .am_r_d8, reg_1: .reg_a},
  Instruction{instr_type: .instr_rst, mode: .am_imp, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_none, parameter: 0x10},
  Instruction{instr_type: .instr_ret, mode: .am_imp, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_c},
  Instruction{instr_type: .instr_reti},
  Instruction{instr_type: .instr_jp, mode: .am_d16, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_c},
  Instruction{instr_type: .instr_call, mode: .am_d16, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_c},
  Instruction{instr_type: .instr_sbc, mode: .am_r_d8, reg_1: .reg_a},
  Instruction{instr_type: .instr_rst, mode: .am_imp, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_none, parameter: 0x18},

  //0xEX
  Instruction{instr_type: .instr_ldh, mode: .am_a8_r, reg_1: .reg_none, reg_2: .reg_a},
  Instruction{instr_type: .instr_pop, mode: .am_r, reg_1: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_mr_r, reg_1: .reg_c, reg_2: .reg_a},
  Instruction{instr_type: .instr_push, mode: .am_r, reg_1: .reg_hl},
  Instruction{instr_type: .instr_and, mode: .am_r_d8, reg_1: .reg_a},
  Instruction{instr_type: .instr_rst, mode: .am_imp, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_none, parameter: 0x20},
  Instruction{instr_type: .instr_add, mode: .am_r_d8, reg_1: .reg_sp},
  Instruction{instr_type: .instr_jp, mode: .am_r, reg_1: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_a16_r, reg_1: .reg_none, reg_2: .reg_a},
  Instruction{instr_type: .instr_xor, mode: .am_r_d8, reg_1: .reg_a},
  Instruction{instr_type: .instr_rst, mode: .am_imp, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_none, parameter: 0x28},


  //0xFX
  Instruction{instr_type: .instr_ldh, mode: .am_r_a8, reg_1: .reg_a},
  Instruction{instr_type: .instr_pop, mode: .am_r, reg_1: .reg_af},
  Instruction{instr_type: .instr_ld, mode: .am_r_mr, reg_1: .reg_a, reg_2: .reg_c},
  Instruction{instr_type: .instr_di},
  Instruction{instr_type: .instr_push, mode: .am_r, reg_1: .reg_af},
  Instruction{instr_type: .instr_or, mode: .am_r_d8, reg_1: .reg_a},
  Instruction{instr_type: .instr_rst, mode: .am_imp, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_none, parameter: 0x30},
  Instruction{instr_type: .instr_ld, mode: .am_hl_spr, reg_1: .reg_hl, reg_2: .reg_sp},
  Instruction{instr_type: .instr_ld, mode: .am_r_r, reg_1: .reg_sp, reg_2: .reg_hl},
  Instruction{instr_type: .instr_ld, mode: .am_r_a16, reg_1: .reg_a},
  Instruction{instr_type: .instr_ei},
  Instruction{instr_type: .instr_cp, mode: .am_r_d8, reg_1: .reg_a},
  Instruction{instr_type: .instr_rst, mode: .am_imp, reg_1: .reg_none, reg_2: .reg_none, cond_type: .cond_none, parameter: 0x38},
]!
