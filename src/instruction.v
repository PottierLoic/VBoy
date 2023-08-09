/* Register instructions part, each register instruction is composed of an instruction and a target */
enum RegisterU8 {
  a b c d e h l d8 hli
}

enum RegisterU16 {
  bc de hl af sp
}

enum Instruction_ {
  // Arithmetic instr
  add
  dec
  inc
  adc
  addhl
  addsp
  sub
  sbc
  and
  @or
  xor
  cp

  ccf
  scf

  rra
  rla
  rrca
  rlca
  cpl
  daa

  // Prefix instr
  bit
  res
  set
  srl
  rr
  rl
  rrc
  rlc
  sra
  sla
  swap

  // Jump instr
  jp
  jr
  jpi

  // Load instr
  ld

  // Stack instr
  push
  pop
  call
  ret
  reti
  rst

  // Control instr
  halt
  nop
  di
  ei
}

/* Jump conditions */
enum JumpTest {
  not_zero
  zero
  not_carry
  carry
  always
}

/* Memory reading / writing part */
enum LoadByteTarget {
  a b c d e h l hli
}
enum LoadByteSource {
  a b c d e h l d8 hli
}
enum LoadWordTarget {
  bc de hl sp
}
enum Indirect {
  bc_indirect
  de_indirect
  hl_indirect_minus
  hl_indirect_plus
  word_indirect
  last_byte_indirect
}
enum LoadType {
  byte                  // done
  word                  // not done
  a_from_indirect       // not done
  indirect_from_a       // not done
  a_from_byte_address   // not done
  byte_address_from_a   // not done
  sp_from_hl            // not done
  hl_from_spn           // not done
  indirect_from_sp      // not done
}

/* Stack part*/
enum StackTarget {
  bc de hl af
}

enum Position {
  b0 b1 b2 b3 b4 b5 b6 b7
}

enum RSTLocation {
  x00
  x10
  x20
  x30
  x08
  x18
  x28
  x38
}

/* Instruction struct that can hold multiple optional values, it can represent any of the instruction, prefixed or not */
struct Instruction {
  instruction Instruction_
  target_u8 RegisterU8
  target_u16 RegisterU16
  jump_test JumpTest
  byte_target LoadByteTarget
  byte_source LoadByteSource
  word_target LoadWordTarget
  indirect Indirect
  load_type LoadType
  stack_target StackTarget
  bit_position Position
  rst_location RSTLocation
}

/* return the right instruction */
[direct_array_access]
fn instruction_from_byte(value u8, prefixed bool) Instruction {
  return if prefixed { instruction_prefixed[value] }
  else { instruction_not_prefixed[value] }
}

const instruction_prefixed = [
  /* RLC instruction */
  Instruction{instruction: .rlc, target_u8: .b},
  Instruction{instruction: .rlc, target_u8: .c},
  Instruction{instruction: .rlc, target_u8: .d},
  Instruction{instruction: .rlc, target_u8: .e},
  Instruction{instruction: .rlc, target_u8: .h},
  Instruction{instruction: .rlc, target_u8: .l},
  Instruction{instruction: .rlc, target_u16: .hl},
  Instruction{instruction: .rlc, target_u8: .a},

  /* RRC instruction */
  Instruction{instruction: .rrc, target_u8: .b},
  Instruction{instruction: .rrc, target_u8: .c},
  Instruction{instruction: .rrc, target_u8: .d},
  Instruction{instruction: .rrc, target_u8: .e},
  Instruction{instruction: .rrc, target_u8: .h},
  Instruction{instruction: .rrc, target_u8: .l},
  Instruction{instruction: .rrc, target_u16: .hl},
  Instruction{instruction: .rrc, target_u8: .a},

  /* RL instruction */
  Instruction{instruction: .rl, target_u8: .b},
  Instruction{instruction: .rl, target_u8: .c},
  Instruction{instruction: .rl, target_u8: .d},
  Instruction{instruction: .rl, target_u8: .e},
  Instruction{instruction: .rl, target_u8: .h},
  Instruction{instruction: .rl, target_u8: .l},
  Instruction{instruction: .rl, target_u16: .hl},
  Instruction{instruction: .rl, target_u8: .a},

  /* RR instruction */
  Instruction{instruction: .rr, target_u8: .b},
  Instruction{instruction: .rr, target_u8: .c},
  Instruction{instruction: .rr, target_u8: .d},
  Instruction{instruction: .rr, target_u8: .e},
  Instruction{instruction: .rr, target_u8: .h},
  Instruction{instruction: .rr, target_u8: .l},
  Instruction{instruction: .rr, target_u16: .hl},
  Instruction{instruction: .rr, target_u8: .a},

  /* SLA instruction */
  Instruction{instruction: .sla, target_u8: .b},
  Instruction{instruction: .sla, target_u8: .c},
  Instruction{instruction: .sla, target_u8: .d},
  Instruction{instruction: .sla, target_u8: .e},
  Instruction{instruction: .sla, target_u8: .h},
  Instruction{instruction: .sla, target_u8: .l},
  Instruction{instruction: .sla, target_u16: .hl},
  Instruction{instruction: .sla, target_u8: .a},

  /* SRA instruction */
  Instruction{instruction: .sra, target_u8: .b},
  Instruction{instruction: .sra, target_u8: .c},
  Instruction{instruction: .sra, target_u8: .d},
  Instruction{instruction: .sra, target_u8: .e},
  Instruction{instruction: .sra, target_u8: .h},
  Instruction{instruction: .sra, target_u8: .l},
  Instruction{instruction: .sra, target_u16: .hl},
  Instruction{instruction: .sra, target_u8: .a},

  /* SWAP instruction */
  Instruction{instruction: .swap, target_u8: .b},
  Instruction{instruction: .swap, target_u8: .c},
  Instruction{instruction: .swap, target_u8: .d},
  Instruction{instruction: .swap, target_u8: .e},
  Instruction{instruction: .swap, target_u8: .h},
  Instruction{instruction: .swap, target_u8: .l},
  Instruction{instruction: .swap, target_u16: .hl},
  Instruction{instruction: .swap, target_u8: .a},

  /* SRL instruction */
  Instruction{instruction: .srl, target_u8: .b},
  Instruction{instruction: .srl, target_u8: .c},
  Instruction{instruction: .srl, target_u8: .d},
  Instruction{instruction: .srl, target_u8: .e},
  Instruction{instruction: .srl, target_u8: .h},
  Instruction{instruction: .srl, target_u8: .l},
  Instruction{instruction: .srl, target_u16: .hl},
  Instruction{instruction: .srl, target_u8: .a},

  /* BIT instruction */
  Instruction{instruction: .bit, bit_position: .b0, target_u8: .b},
  Instruction{instruction: .bit, bit_position: .b0, target_u8: .c},
  Instruction{instruction: .bit, bit_position: .b0, target_u8: .d},
  Instruction{instruction: .bit, bit_position: .b0, target_u8: .e},
  Instruction{instruction: .bit, bit_position: .b0, target_u8: .h},
  Instruction{instruction: .bit, bit_position: .b0, target_u8: .l},
  Instruction{instruction: .bit, bit_position: .b0, target_u16: .hl},
  Instruction{instruction: .bit, bit_position: .b0, target_u8: .a},
  Instruction{instruction: .bit, bit_position: .b1, target_u8: .b},
  Instruction{instruction: .bit, bit_position: .b1, target_u8: .c},
  Instruction{instruction: .bit, bit_position: .b1, target_u8: .d},
  Instruction{instruction: .bit, bit_position: .b1, target_u8: .e},
  Instruction{instruction: .bit, bit_position: .b1, target_u8: .h},
  Instruction{instruction: .bit, bit_position: .b1, target_u8: .l},
  Instruction{instruction: .bit, bit_position: .b1, target_u16: .hl},
  Instruction{instruction: .bit, bit_position: .b1, target_u8: .a},

  Instruction{instruction: .bit, bit_position: .b2, target_u8: .b},
  Instruction{instruction: .bit, bit_position: .b2, target_u8: .c},
  Instruction{instruction: .bit, bit_position: .b2, target_u8: .d},
  Instruction{instruction: .bit, bit_position: .b2, target_u8: .e},
  Instruction{instruction: .bit, bit_position: .b2, target_u8: .h},
  Instruction{instruction: .bit, bit_position: .b2, target_u8: .l},
  Instruction{instruction: .bit, bit_position: .b2, target_u16: .hl},
  Instruction{instruction: .bit, bit_position: .b2, target_u8: .a},
  Instruction{instruction: .bit, bit_position: .b3, target_u8: .b},
  Instruction{instruction: .bit, bit_position: .b3, target_u8: .c},
  Instruction{instruction: .bit, bit_position: .b3, target_u8: .d},
  Instruction{instruction: .bit, bit_position: .b3, target_u8: .e},
  Instruction{instruction: .bit, bit_position: .b3, target_u8: .h},
  Instruction{instruction: .bit, bit_position: .b3, target_u8: .l},
  Instruction{instruction: .bit, bit_position: .b3, target_u16: .hl},
  Instruction{instruction: .bit, bit_position: .b3, target_u8: .a},

  Instruction{instruction: .bit, bit_position: .b4, target_u8: .b},
  Instruction{instruction: .bit, bit_position: .b4, target_u8: .c},
  Instruction{instruction: .bit, bit_position: .b4, target_u8: .d},
  Instruction{instruction: .bit, bit_position: .b4, target_u8: .e},
  Instruction{instruction: .bit, bit_position: .b4, target_u8: .h},
  Instruction{instruction: .bit, bit_position: .b4, target_u8: .l},
  Instruction{instruction: .bit, bit_position: .b4, target_u16: .hl},
  Instruction{instruction: .bit, bit_position: .b4, target_u8: .a},
  Instruction{instruction: .bit, bit_position: .b5, target_u8: .b},
  Instruction{instruction: .bit, bit_position: .b5, target_u8: .c},
  Instruction{instruction: .bit, bit_position: .b5, target_u8: .d},
  Instruction{instruction: .bit, bit_position: .b5, target_u8: .e},
  Instruction{instruction: .bit, bit_position: .b5, target_u8: .h},
  Instruction{instruction: .bit, bit_position: .b5, target_u8: .l},
  Instruction{instruction: .bit, bit_position: .b5, target_u16: .hl},
  Instruction{instruction: .bit, bit_position: .b5, target_u8: .a},

  Instruction{instruction: .bit, bit_position: .b6, target_u8: .b},
  Instruction{instruction: .bit, bit_position: .b6, target_u8: .c},
  Instruction{instruction: .bit, bit_position: .b6, target_u8: .d},
  Instruction{instruction: .bit, bit_position: .b6, target_u8: .e},
  Instruction{instruction: .bit, bit_position: .b6, target_u8: .h},
  Instruction{instruction: .bit, bit_position: .b6, target_u8: .l},
  Instruction{instruction: .bit, bit_position: .b6, target_u16: .hl},
  Instruction{instruction: .bit, bit_position: .b6, target_u8: .a},
  Instruction{instruction: .bit, bit_position: .b7, target_u8: .b},
  Instruction{instruction: .bit, bit_position: .b7, target_u8: .c},
  Instruction{instruction: .bit, bit_position: .b7, target_u8: .d},
  Instruction{instruction: .bit, bit_position: .b7, target_u8: .e},
  Instruction{instruction: .bit, bit_position: .b7, target_u8: .h},
  Instruction{instruction: .bit, bit_position: .b7, target_u8: .l},
  Instruction{instruction: .bit, bit_position: .b7, target_u16: .hl},
  Instruction{instruction: .bit, bit_position: .b7, target_u8: .a},

  /* RES instruction */
  Instruction{instruction: .res, bit_position: .b0, target_u8: .b},
  Instruction{instruction: .res, bit_position: .b0, target_u8: .c},
  Instruction{instruction: .res, bit_position: .b0, target_u8: .d},
  Instruction{instruction: .res, bit_position: .b0, target_u8: .e},
  Instruction{instruction: .res, bit_position: .b0, target_u8: .h},
  Instruction{instruction: .res, bit_position: .b0, target_u8: .l},
  Instruction{instruction: .res, bit_position: .b0, target_u16: .hl},
  Instruction{instruction: .res, bit_position: .b0, target_u8: .a},
  Instruction{instruction: .res, bit_position: .b1, target_u8: .b},
  Instruction{instruction: .res, bit_position: .b1, target_u8: .c},
  Instruction{instruction: .res, bit_position: .b1, target_u8: .d},
  Instruction{instruction: .res, bit_position: .b1, target_u8: .e},
  Instruction{instruction: .res, bit_position: .b1, target_u8: .h},
  Instruction{instruction: .res, bit_position: .b1, target_u8: .l},
  Instruction{instruction: .res, bit_position: .b1, target_u16: .hl},
  Instruction{instruction: .res, bit_position: .b1, target_u8: .a},

  Instruction{instruction: .res, bit_position: .b2, target_u8: .b},
  Instruction{instruction: .res, bit_position: .b2, target_u8: .c},
  Instruction{instruction: .res, bit_position: .b2, target_u8: .d},
  Instruction{instruction: .res, bit_position: .b2, target_u8: .e},
  Instruction{instruction: .res, bit_position: .b2, target_u8: .h},
  Instruction{instruction: .res, bit_position: .b2, target_u8: .l},
  Instruction{instruction: .res, bit_position: .b2, target_u16: .hl},
  Instruction{instruction: .res, bit_position: .b2, target_u8: .a},
  Instruction{instruction: .res, bit_position: .b3, target_u8: .b},
  Instruction{instruction: .res, bit_position: .b3, target_u8: .c},
  Instruction{instruction: .res, bit_position: .b3, target_u8: .d},
  Instruction{instruction: .res, bit_position: .b3, target_u8: .e},
  Instruction{instruction: .res, bit_position: .b3, target_u8: .h},
  Instruction{instruction: .res, bit_position: .b3, target_u8: .l},
  Instruction{instruction: .res, bit_position: .b3, target_u16: .hl},
  Instruction{instruction: .res, bit_position: .b3, target_u8: .a},

  Instruction{instruction: .res, bit_position: .b4, target_u8: .b},
  Instruction{instruction: .res, bit_position: .b4, target_u8: .c},
  Instruction{instruction: .res, bit_position: .b4, target_u8: .d},
  Instruction{instruction: .res, bit_position: .b4, target_u8: .e},
  Instruction{instruction: .res, bit_position: .b4, target_u8: .h},
  Instruction{instruction: .res, bit_position: .b4, target_u8: .l},
  Instruction{instruction: .res, bit_position: .b4, target_u16: .hl},
  Instruction{instruction: .res, bit_position: .b4, target_u8: .a},
  Instruction{instruction: .res, bit_position: .b5, target_u8: .b},
  Instruction{instruction: .res, bit_position: .b5, target_u8: .c},
  Instruction{instruction: .res, bit_position: .b5, target_u8: .d},
  Instruction{instruction: .res, bit_position: .b5, target_u8: .e},
  Instruction{instruction: .res, bit_position: .b5, target_u8: .h},
  Instruction{instruction: .res, bit_position: .b5, target_u8: .l},
  Instruction{instruction: .res, bit_position: .b5, target_u16: .hl},
  Instruction{instruction: .res, bit_position: .b5, target_u8: .a},

  Instruction{instruction: .res, bit_position: .b6, target_u8: .b},
  Instruction{instruction: .res, bit_position: .b6, target_u8: .c},
  Instruction{instruction: .res, bit_position: .b6, target_u8: .d},
  Instruction{instruction: .res, bit_position: .b6, target_u8: .e},
  Instruction{instruction: .res, bit_position: .b6, target_u8: .h},
  Instruction{instruction: .res, bit_position: .b6, target_u8: .l},
  Instruction{instruction: .res, bit_position: .b6, target_u16: .hl},
  Instruction{instruction: .res, bit_position: .b6, target_u8: .a},
  Instruction{instruction: .res, bit_position: .b7, target_u8: .b},
  Instruction{instruction: .res, bit_position: .b7, target_u8: .c},
  Instruction{instruction: .res, bit_position: .b7, target_u8: .d},
  Instruction{instruction: .res, bit_position: .b7, target_u8: .e},
  Instruction{instruction: .res, bit_position: .b7, target_u8: .h},
  Instruction{instruction: .res, bit_position: .b7, target_u8: .l},
  Instruction{instruction: .res, bit_position: .b7, target_u16: .hl},
  Instruction{instruction: .res, bit_position: .b7, target_u8: .a},

  /* SET instruction */
  Instruction{instruction: .set, bit_position: .b0, target_u8: .b},
  Instruction{instruction: .set, bit_position: .b0, target_u8: .c},
  Instruction{instruction: .set, bit_position: .b0, target_u8: .d},
  Instruction{instruction: .set, bit_position: .b0, target_u8: .e},
  Instruction{instruction: .set, bit_position: .b0, target_u8: .h},
  Instruction{instruction: .set, bit_position: .b0, target_u8: .l},
  Instruction{instruction: .set, bit_position: .b0, target_u16: .hl},
  Instruction{instruction: .set, bit_position: .b0, target_u8: .a},
  Instruction{instruction: .set, bit_position: .b1, target_u8: .b},
  Instruction{instruction: .set, bit_position: .b1, target_u8: .c},
  Instruction{instruction: .set, bit_position: .b1, target_u8: .d},
  Instruction{instruction: .set, bit_position: .b1, target_u8: .e},
  Instruction{instruction: .set, bit_position: .b1, target_u8: .h},
  Instruction{instruction: .set, bit_position: .b1, target_u8: .l},
  Instruction{instruction: .set, bit_position: .b1, target_u16: .hl},
  Instruction{instruction: .set, bit_position: .b1, target_u8: .a},

  Instruction{instruction: .set, bit_position: .b2, target_u8: .b},
  Instruction{instruction: .set, bit_position: .b2, target_u8: .c},
  Instruction{instruction: .set, bit_position: .b2, target_u8: .d},
  Instruction{instruction: .set, bit_position: .b2, target_u8: .e},
  Instruction{instruction: .set, bit_position: .b2, target_u8: .h},
  Instruction{instruction: .set, bit_position: .b2, target_u8: .l},
  Instruction{instruction: .set, bit_position: .b2, target_u16: .hl},
  Instruction{instruction: .set, bit_position: .b2, target_u8: .a},
  Instruction{instruction: .set, bit_position: .b3, target_u8: .b},
  Instruction{instruction: .set, bit_position: .b3, target_u8: .c},
  Instruction{instruction: .set, bit_position: .b3, target_u8: .d},
  Instruction{instruction: .set, bit_position: .b3, target_u8: .e},
  Instruction{instruction: .set, bit_position: .b3, target_u8: .h},
  Instruction{instruction: .set, bit_position: .b3, target_u8: .l},
  Instruction{instruction: .set, bit_position: .b3, target_u16: .hl},
  Instruction{instruction: .set, bit_position: .b3, target_u8: .a},

  Instruction{instruction: .set, bit_position: .b4, target_u8: .b},
  Instruction{instruction: .set, bit_position: .b4, target_u8: .c},
  Instruction{instruction: .set, bit_position: .b4, target_u8: .d},
  Instruction{instruction: .set, bit_position: .b4, target_u8: .e},
  Instruction{instruction: .set, bit_position: .b4, target_u8: .h},
  Instruction{instruction: .set, bit_position: .b4, target_u8: .l},
  Instruction{instruction: .set, bit_position: .b4, target_u16: .hl},
  Instruction{instruction: .set, bit_position: .b4, target_u8: .a},
  Instruction{instruction: .set, bit_position: .b5, target_u8: .b},
  Instruction{instruction: .set, bit_position: .b5, target_u8: .c},
  Instruction{instruction: .set, bit_position: .b5, target_u8: .d},
  Instruction{instruction: .set, bit_position: .b5, target_u8: .e},
  Instruction{instruction: .set, bit_position: .b5, target_u8: .h},
  Instruction{instruction: .set, bit_position: .b5, target_u8: .l},
  Instruction{instruction: .set, bit_position: .b5, target_u16: .hl},
  Instruction{instruction: .set, bit_position: .b5, target_u8: .a},

  Instruction{instruction: .set, bit_position: .b6, target_u8: .b},
  Instruction{instruction: .set, bit_position: .b6, target_u8: .c},
  Instruction{instruction: .set, bit_position: .b6, target_u8: .d},
  Instruction{instruction: .set, bit_position: .b6, target_u8: .e},
  Instruction{instruction: .set, bit_position: .b6, target_u8: .h},
  Instruction{instruction: .set, bit_position: .b6, target_u8: .l},
  Instruction{instruction: .set, bit_position: .b6, target_u16: .hl},
  Instruction{instruction: .set, bit_position: .b6, target_u8: .a},
  Instruction{instruction: .set, bit_position: .b7, target_u8: .b},
  Instruction{instruction: .set, bit_position: .b7, target_u8: .c},
  Instruction{instruction: .set, bit_position: .b7, target_u8: .d},
  Instruction{instruction: .set, bit_position: .b7, target_u8: .e},
  Instruction{instruction: .set, bit_position: .b7, target_u8: .h},
  Instruction{instruction: .set, bit_position: .b7, target_u8: .l},
  Instruction{instruction: .set, bit_position: .b7, target_u16: .hl},
  Instruction{instruction: .set, bit_position: .b7, target_u8: .a},
]!

const instruction_not_prefixed = [
  Instruction{instruction: .nop},
  Instruction{instruction: .ld, load_type: .word, word_target: .bc},
  Instruction{instruction: .ld, load_type: .indirect_from_a, indirect: .bc_indirect},
  Instruction{instruction: .inc, target_u16: .bc},
  Instruction{instruction: .inc, target_u8: .b},
  Instruction{instruction: .dec, target_u8: .b},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .d8},
  Instruction{instruction: .rlca},
  Instruction{instruction: .ld, load_type: .indirect_from_sp},
  Instruction{instruction: .addhl, target_u16: .bc},
  Instruction{instruction: .ld, load_type: .a_from_indirect, indirect: .bc_indirect},
  Instruction{instruction: .dec, target_u16: .bc},
  Instruction{instruction: .inc, target_u8: .c},
  Instruction{instruction: .dec, target_u8: .c},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .d8},
  Instruction{instruction: .rrca},
  Instruction{}, //STOP INSTRUCTION
  Instruction{instruction: .ld, load_type: .word, word_target: .de},
  Instruction{instruction: .ld, load_type: .indirect_from_a, indirect: .de_indirect},
  Instruction{instruction: .inc, target_u16: .de},
  Instruction{instruction: .inc, target_u8: .d},
  Instruction{instruction: .dec, target_u8: .d},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .d8},
  Instruction{instruction: .rla},
  Instruction{instruction: .jr, jump_test: .always},
  Instruction{instruction: .addhl, target_u16: .de},
  Instruction{instruction: .ld, load_type: .a_from_indirect, indirect: .de_indirect},
  Instruction{instruction: .dec, target_u16: .de},
  Instruction{instruction: .inc, target_u8: .e},
  Instruction{instruction: .dec, target_u8: .e},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .d8},
  Instruction{instruction: .rra},
  Instruction{instruction: .jr, jump_test: .not_zero},
  Instruction{instruction: .ld, load_type: .word, word_target: .hl},
  Instruction{instruction: .ld, load_type: .indirect_from_a, indirect: .hl_indirect_plus},
  Instruction{instruction: .inc, target_u16: .hl},
  Instruction{instruction: .inc, target_u8: .h},
  Instruction{instruction: .dec, target_u8: .h},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .d8},
  Instruction{instruction: .daa},
  Instruction{instruction: .jr, jump_test: .zero},
  Instruction{instruction: .addhl, target_u16: .hl},
  Instruction{instruction: .ld, load_type: .a_from_indirect, indirect: .hl_indirect_plus},
  Instruction{instruction: .dec, target_u16: .hl},
  Instruction{instruction: .inc, target_u8: .l},
  Instruction{instruction: .dec, target_u8: .l},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .d8},
  Instruction{instruction: .cpl},
  Instruction{instruction: .jr, jump_test: .not_carry},
  Instruction{instruction: .ld, load_type: .word, word_target: .sp},
  Instruction{instruction: .ld, load_type: .indirect_from_a, indirect: .hl_indirect_minus},
  Instruction{instruction: .inc, target_u16: .sp},
  Instruction{instruction: .inc, target_u8: .hli},
  Instruction{instruction: .dec, target_u8: .hli},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .d8},
  Instruction{instruction: .scf},
  Instruction{instruction: .jr, jump_test: .carry},
  Instruction{instruction: .addhl, target_u16: .sp},
  Instruction{instruction: .ld, load_type: .a_from_indirect, indirect: .hl_indirect_minus},
  Instruction{instruction: .dec, target_u16: .sp},
  Instruction{instruction: .inc, target_u8: .a},
  Instruction{instruction: .dec, target_u8: .a},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .d8},
  Instruction{instruction: .ccf},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .b},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .c},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .d},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .e},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .h},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .l},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .hli},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .a},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .b},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .c},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .d},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .e},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .h},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .l},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .hli},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .a},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .b},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .c},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .d},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .e},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .h},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .l},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .hli},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .a},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .b},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .c},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .d},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .e},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .h},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .l},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .hli},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .a},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .b},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .c},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .d},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .e},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .h},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .l},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .hli},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .a},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .b},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .c},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .d},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .e},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .h},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .l},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .hli},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .a},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .b},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .c},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .d},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .e},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .h},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .l},
  Instruction{instruction: .halt},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .a},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .b},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .c},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .d},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .e},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .h},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .l},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .hli},
  Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .a},
  Instruction{instruction: .add, target_u8: .b},
  Instruction{instruction: .add, target_u8: .c},
  Instruction{instruction: .add, target_u8: .d},
  Instruction{instruction: .add, target_u8: .e},
  Instruction{instruction: .add, target_u8: .h},
  Instruction{instruction: .add, target_u8: .l},
  Instruction{instruction: .add, target_u8: .hli},
  Instruction{instruction: .add, target_u8: .a},
  Instruction{instruction: .adc, target_u8: .b},
  Instruction{instruction: .adc, target_u8: .c},
  Instruction{instruction: .adc, target_u8: .d},
  Instruction{instruction: .adc, target_u8: .e},
  Instruction{instruction: .adc, target_u8: .h},
  Instruction{instruction: .adc, target_u8: .l},
  Instruction{instruction: .adc, target_u8: .hli},
  Instruction{instruction: .adc, target_u8: .a},
  Instruction{instruction: .sub, target_u8: .b},
  Instruction{instruction: .sub, target_u8: .c},
  Instruction{instruction: .sub, target_u8: .d},
  Instruction{instruction: .sub, target_u8: .e},
  Instruction{instruction: .sub, target_u8: .h},
  Instruction{instruction: .sub, target_u8: .l},
  Instruction{instruction: .sub, target_u8: .hli},
  Instruction{instruction: .sub, target_u8: .a},
  Instruction{instruction: .sbc, target_u8: .b},
  Instruction{instruction: .sbc, target_u8: .c},
  Instruction{instruction: .sbc, target_u8: .d},
  Instruction{instruction: .sbc, target_u8: .e},
  Instruction{instruction: .sbc, target_u8: .h},
  Instruction{instruction: .sbc, target_u8: .l},
  Instruction{instruction: .sbc, target_u8: .hli},
  Instruction{instruction: .sbc, target_u8: .a},
  Instruction{instruction: .and, target_u8: .b},
  Instruction{instruction: .and, target_u8: .c},
  Instruction{instruction: .and, target_u8: .d},
  Instruction{instruction: .and, target_u8: .e},
  Instruction{instruction: .and, target_u8: .h},
  Instruction{instruction: .and, target_u8: .l},
  Instruction{instruction: .and, target_u8: .hli},
  Instruction{instruction: .and, target_u8: .a},
  Instruction{instruction: .xor, target_u8: .b},
  Instruction{instruction: .xor, target_u8: .c},
  Instruction{instruction: .xor, target_u8: .d},
  Instruction{instruction: .xor, target_u8: .e},
  Instruction{instruction: .xor, target_u8: .h},
  Instruction{instruction: .xor, target_u8: .l},
  Instruction{instruction: .xor, target_u8: .hli},
  Instruction{instruction: .xor, target_u8: .a},
  Instruction{instruction: .@or, target_u8: .b},
  Instruction{instruction: .@or, target_u8: .c},
  Instruction{instruction: .@or, target_u8: .d},
  Instruction{instruction: .@or, target_u8: .e},
  Instruction{instruction: .@or, target_u8: .h},
  Instruction{instruction: .@or, target_u8: .l},
  Instruction{instruction: .@or, target_u8: .hli},
  Instruction{instruction: .@or, target_u8: .a},
  Instruction{instruction: .cp, target_u8: .b},
  Instruction{instruction: .cp, target_u8: .c},
  Instruction{instruction: .cp, target_u8: .d},
  Instruction{instruction: .cp, target_u8: .e},
  Instruction{instruction: .cp, target_u8: .h},
  Instruction{instruction: .cp, target_u8: .l},
  Instruction{instruction: .cp, target_u8: .hli},
  Instruction{instruction: .cp, target_u8: .a},
  Instruction{instruction: .ret, jump_test: .not_zero},
  Instruction{instruction: .pop, stack_target: .bc},
  Instruction{instruction: .jp, jump_test: .not_zero},
  Instruction{instruction: .jp, jump_test: .always},
  Instruction{instruction: .call, jump_test: .not_zero},
  Instruction{instruction: .push, stack_target: .bc},
  Instruction{instruction: .add, target_u8: .d8},
  Instruction{instruction: .rst, rst_location: .x00},
  Instruction{instruction: .ret, jump_test: .zero},
  Instruction{instruction: .ret, jump_test: .always},
  Instruction{instruction: .jp, jump_test: .zero},
  Instruction{}, // Empty
  Instruction{instruction: .call, jump_test: .zero},
  Instruction{instruction: .call, jump_test: .always},
  Instruction{instruction: .adc, target_u8: .d8},
  Instruction{instruction: .rst, rst_location: .x08},
  Instruction{instruction: .ret, jump_test: .not_carry},
  Instruction{instruction: .pop, stack_target: .de},
  Instruction{instruction: .jp, jump_test: .not_carry},
  Instruction{}, // Empty
  Instruction{instruction: .call, jump_test: .not_carry},
  Instruction{instruction: .push, stack_target: .de},
  Instruction{instruction: .sub, target_u8: .d8},
  Instruction{instruction: .rst, rst_location: .x10},
  Instruction{instruction: .ret, jump_test: .carry},
  Instruction{instruction: .reti},
  Instruction{instruction: .jp, jump_test: .carry},
  Instruction{}, // Empty
  Instruction{instruction: .call, jump_test: .carry},
  Instruction{}, // Empty
  Instruction{instruction: .sbc, target_u8: .d8},
  Instruction{instruction: .rst, rst_location: .x18},
  Instruction{instruction: .ld, load_type: .byte_address_from_a},
  Instruction{instruction: .pop, stack_target: .hl},
  Instruction{instruction: .ld, load_type: .indirect_from_a, indirect: .last_byte_indirect},
  Instruction{}, // Empty
  Instruction{}, // Empty
  Instruction{instruction: .push, stack_target: .hl},
  Instruction{instruction: .and, target_u8: .d8},
  Instruction{instruction: .rst, rst_location: .x20},
  Instruction{instruction: .addsp},
  Instruction{instruction: .jpi},
  Instruction{instruction: .ld, load_type: .indirect_from_a, indirect: .word_indirect},
  Instruction{}, // Empty
  Instruction{}, // Empty
  Instruction{}, // Empty
  Instruction{instruction: .xor, target_u8: .d8},
  Instruction{instruction: .rst, rst_location: .x28},
  Instruction{instruction: .ld, load_type: .a_from_byte_address},
  Instruction{instruction: .pop, stack_target: .af},
  Instruction{instruction: .ld, load_type: .a_from_indirect, indirect: .last_byte_indirect},
  Instruction{instruction: .di},
  Instruction{}, // Empty
  Instruction{instruction: .push, stack_target: .af},
  Instruction{instruction: .@or, target_u8: .d8},
  Instruction{instruction: .rst, rst_location: .x30},
  Instruction{instruction: .ld, load_type: .hl_from_spn},
  Instruction{instruction: .ld, load_type: .sp_from_hl},
  Instruction{instruction: .ld, load_type: .a_from_indirect, indirect: .word_indirect},
  Instruction{instruction: .ei},
  Instruction{}, // Empty
  Instruction{}, // Empty
  Instruction{instruction: .cp, target_u8: .d8},
  Instruction{instruction: .rst, rst_location: .x38}
]!
