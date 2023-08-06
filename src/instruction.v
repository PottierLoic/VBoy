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

/* Choose the correct method to get the instruction */
fn instruction_from_byte(value u8, prefixed bool) Instruction {
  if prefixed { return instruction_from_byte_prefixed(value) }
  else { return instruction_from_byte_not_prefixed(value) }
}

fn instruction_from_byte_prefixed(value u8) Instruction {
  match value {
    /* RLC instruction */
    0x00 { return Instruction{instruction: .rlc, target_u8: .b} }
    0x01 { return Instruction{instruction: .rlc, target_u8: .c} }
    0x02 { return Instruction{instruction: .rlc, target_u8: .d} }
    0x03 { return Instruction{instruction: .rlc, target_u8: .e} }
    0x04 { return Instruction{instruction: .rlc, target_u8: .h} }
    0x05 { return Instruction{instruction: .rlc, target_u8: .l} }
    0x06 { return Instruction{instruction: .rlc, target_u16: .hl} }
    0x07 { return Instruction{instruction: .rlc, target_u8: .a} }

    /* RRC instruction */
    0x08 { return Instruction{instruction: .rrc, target_u8: .b} }
    0x09 { return Instruction{instruction: .rrc, target_u8: .c} }
    0x0A { return Instruction{instruction: .rrc, target_u8: .d} }
    0x0B { return Instruction{instruction: .rrc, target_u8: .e} }
    0x0C { return Instruction{instruction: .rrc, target_u8: .h} }
    0x0D { return Instruction{instruction: .rrc, target_u8: .l} }
    0x0E { return Instruction{instruction: .rrc, target_u16: .hl} }
    0x0F { return Instruction{instruction: .rrc, target_u8: .a} }

    /* RL instruction */
    0x10 { return Instruction{instruction: .rl, target_u8: .b} }
    0x11 { return Instruction{instruction: .rl, target_u8: .c} }
    0x12 { return Instruction{instruction: .rl, target_u8: .d} }
    0x13 { return Instruction{instruction: .rl, target_u8: .e} }
    0x14 { return Instruction{instruction: .rl, target_u8: .h} }
    0x15 { return Instruction{instruction: .rl, target_u8: .l} }
    0x16 { return Instruction{instruction: .rl, target_u16: .hl} }
    0x17 { return Instruction{instruction: .rl, target_u8: .a} }

    /* RR instruction */
    0x18 { return Instruction{instruction: .rr, target_u8: .b} }
    0x19 { return Instruction{instruction: .rr, target_u8: .c} }
    0x1A { return Instruction{instruction: .rr, target_u8: .d} }
    0x1B { return Instruction{instruction: .rr, target_u8: .e} }
    0x1C { return Instruction{instruction: .rr, target_u8: .h} }
    0x1D { return Instruction{instruction: .rr, target_u8: .l} }
    0x1E { return Instruction{instruction: .rr, target_u16: .hl} }
    0x1F { return Instruction{instruction: .rr, target_u8: .a} }

    /* SLA instruction */
    0x20 { return Instruction{instruction: .sla, target_u8: .b} }
    0x21 { return Instruction{instruction: .sla, target_u8: .c} }
    0x22 { return Instruction{instruction: .sla, target_u8: .d} }
    0x23 { return Instruction{instruction: .sla, target_u8: .e} }
    0x24 { return Instruction{instruction: .sla, target_u8: .h} }
    0x25 { return Instruction{instruction: .sla, target_u8: .l} }
    0x26 { return Instruction{instruction: .sla, target_u16: .hl} }
    0x27 { return Instruction{instruction: .sla, target_u8: .a} }

    /* SRA instruction */
    0x28 { return Instruction{instruction: .sra, target_u8: .b} }
    0x29 { return Instruction{instruction: .sra, target_u8: .c} }
    0x2A { return Instruction{instruction: .sra, target_u8: .d} }
    0x2B { return Instruction{instruction: .sra, target_u8: .e} }
    0x2C { return Instruction{instruction: .sra, target_u8: .h} }
    0x2D { return Instruction{instruction: .sra, target_u8: .l} }
    0x2E { return Instruction{instruction: .sra, target_u16: .hl} }
    0x2F { return Instruction{instruction: .sra, target_u8: .a} }

    /* SWAP instruction */
    0x30 { return Instruction{instruction: .swap, target_u8: .b} }
    0x31 { return Instruction{instruction: .swap, target_u8: .c} }
    0x32 { return Instruction{instruction: .swap, target_u8: .d} }
    0x33 { return Instruction{instruction: .swap, target_u8: .e} }
    0x34 { return Instruction{instruction: .swap, target_u8: .h} }
    0x35 { return Instruction{instruction: .swap, target_u8: .l} }
    0x36 { return Instruction{instruction: .swap, target_u16: .hl} }
    0x37 { return Instruction{instruction: .swap, target_u8: .a} }

    /* SRL instruction */
    0x38 { return Instruction{instruction: .srl, target_u8: .b} }
    0x39 { return Instruction{instruction: .srl, target_u8: .c} }
    0x3A { return Instruction{instruction: .srl, target_u8: .d} }
    0x3B { return Instruction{instruction: .srl, target_u8: .e} }
    0x3C { return Instruction{instruction: .srl, target_u8: .h} }
    0x3D { return Instruction{instruction: .srl, target_u8: .l} }
    0x3E { return Instruction{instruction: .srl, target_u16: .hl} }
    0x3F { return Instruction{instruction: .srl, target_u8: .a} }

    /* BIT instruction */
    0x40 { return Instruction{instruction: .bit, bit_position: .b0, target_u8: .b} }
    0x41 { return Instruction{instruction: .bit, bit_position: .b0, target_u8: .c} }
    0x42 { return Instruction{instruction: .bit, bit_position: .b0, target_u8: .d} }
    0x43 { return Instruction{instruction: .bit, bit_position: .b0, target_u8: .e} }
    0x44 { return Instruction{instruction: .bit, bit_position: .b0, target_u8: .h} }
    0x45 { return Instruction{instruction: .bit, bit_position: .b0, target_u8: .l} }
    0x46 { return Instruction{instruction: .bit, bit_position: .b0, target_u16: .hl} }
    0x47 { return Instruction{instruction: .bit, bit_position: .b0, target_u8: .a} }
    0x48 { return Instruction{instruction: .bit, bit_position: .b1, target_u8: .b} }
    0x49 { return Instruction{instruction: .bit, bit_position: .b1, target_u8: .c} }
    0x4A { return Instruction{instruction: .bit, bit_position: .b1, target_u8: .d} }
    0x4B { return Instruction{instruction: .bit, bit_position: .b1, target_u8: .e} }
    0x4C { return Instruction{instruction: .bit, bit_position: .b1, target_u8: .h} }
    0x4D { return Instruction{instruction: .bit, bit_position: .b1, target_u8: .l} }
    0x4E { return Instruction{instruction: .bit, bit_position: .b1, target_u16: .hl} }
    0x4F { return Instruction{instruction: .bit, bit_position: .b1, target_u8: .a} }

    0x50 { return Instruction{instruction: .bit, bit_position: .b2, target_u8: .b} }
    0x51 { return Instruction{instruction: .bit, bit_position: .b2, target_u8: .c} }
    0x52 { return Instruction{instruction: .bit, bit_position: .b2, target_u8: .d} }
    0x53 { return Instruction{instruction: .bit, bit_position: .b2, target_u8: .e} }
    0x54 { return Instruction{instruction: .bit, bit_position: .b2, target_u8: .h} }
    0x55 { return Instruction{instruction: .bit, bit_position: .b2, target_u8: .l} }
    0x56 { return Instruction{instruction: .bit, bit_position: .b2, target_u16: .hl} }
    0x57 { return Instruction{instruction: .bit, bit_position: .b2, target_u8: .a} }
    0x58 { return Instruction{instruction: .bit, bit_position: .b3, target_u8: .b} }
    0x59 { return Instruction{instruction: .bit, bit_position: .b3, target_u8: .c} }
    0x5A { return Instruction{instruction: .bit, bit_position: .b3, target_u8: .d} }
    0x5B { return Instruction{instruction: .bit, bit_position: .b3, target_u8: .e} }
    0x5C { return Instruction{instruction: .bit, bit_position: .b3, target_u8: .h} }
    0x5D { return Instruction{instruction: .bit, bit_position: .b3, target_u8: .l} }
    0x5E { return Instruction{instruction: .bit, bit_position: .b3, target_u16: .hl} }
    0x5F { return Instruction{instruction: .bit, bit_position: .b3, target_u8: .a} }

    0x60 { return Instruction{instruction: .bit, bit_position: .b4, target_u8: .b} }
    0x61 { return Instruction{instruction: .bit, bit_position: .b4, target_u8: .c} }
    0x62 { return Instruction{instruction: .bit, bit_position: .b4, target_u8: .d} }
    0x63 { return Instruction{instruction: .bit, bit_position: .b4, target_u8: .e} }
    0x64 { return Instruction{instruction: .bit, bit_position: .b4, target_u8: .h} }
    0x65 { return Instruction{instruction: .bit, bit_position: .b4, target_u8: .l} }
    0x66 { return Instruction{instruction: .bit, bit_position: .b4, target_u16: .hl} }
    0x67 { return Instruction{instruction: .bit, bit_position: .b4, target_u8: .a} }
    0x68 { return Instruction{instruction: .bit, bit_position: .b5, target_u8: .b} }
    0x69 { return Instruction{instruction: .bit, bit_position: .b5, target_u8: .c} }
    0x6A { return Instruction{instruction: .bit, bit_position: .b5, target_u8: .d} }
    0x6B { return Instruction{instruction: .bit, bit_position: .b5, target_u8: .e} }
    0x6C { return Instruction{instruction: .bit, bit_position: .b5, target_u8: .h} }
    0x6D { return Instruction{instruction: .bit, bit_position: .b5, target_u8: .l} }
    0x6E { return Instruction{instruction: .bit, bit_position: .b5, target_u16: .hl} }
    0x6F { return Instruction{instruction: .bit, bit_position: .b5, target_u8: .a} }

    0x70 { return Instruction{instruction: .bit, bit_position: .b6, target_u8: .b} }
    0x71 { return Instruction{instruction: .bit, bit_position: .b6, target_u8: .c} }
    0x72 { return Instruction{instruction: .bit, bit_position: .b6, target_u8: .d} }
    0x73 { return Instruction{instruction: .bit, bit_position: .b6, target_u8: .e} }
    0x74 { return Instruction{instruction: .bit, bit_position: .b6, target_u8: .h} }
    0x75 { return Instruction{instruction: .bit, bit_position: .b6, target_u8: .l} }
    0x76 { return Instruction{instruction: .bit, bit_position: .b6, target_u16: .hl} }
    0x77 { return Instruction{instruction: .bit, bit_position: .b6, target_u8: .a} }
    0x78 { return Instruction{instruction: .bit, bit_position: .b7, target_u8: .b} }
    0x79 { return Instruction{instruction: .bit, bit_position: .b7, target_u8: .c} }
    0x7A { return Instruction{instruction: .bit, bit_position: .b7, target_u8: .d} }
    0x7B { return Instruction{instruction: .bit, bit_position: .b7, target_u8: .e} }
    0x7C { return Instruction{instruction: .bit, bit_position: .b7, target_u8: .h} }
    0x7D { return Instruction{instruction: .bit, bit_position: .b7, target_u8: .l} }
    0x7E { return Instruction{instruction: .bit, bit_position: .b7, target_u16: .hl} }
    0x7F { return Instruction{instruction: .bit, bit_position: .b7, target_u8: .a} }

    /* RES instruction */
    0x80 { return Instruction{instruction: .res, bit_position: .b0, target_u8: .b} }
    0x81 { return Instruction{instruction: .res, bit_position: .b0, target_u8: .c} }
    0x82 { return Instruction{instruction: .res, bit_position: .b0, target_u8: .d} }
    0x83 { return Instruction{instruction: .res, bit_position: .b0, target_u8: .e} }
    0x84 { return Instruction{instruction: .res, bit_position: .b0, target_u8: .h} }
    0x85 { return Instruction{instruction: .res, bit_position: .b0, target_u8: .l} }
    0x86 { return Instruction{instruction: .res, bit_position: .b0, target_u16: .hl} }
    0x87 { return Instruction{instruction: .res, bit_position: .b0, target_u8: .a} }
    0x88 { return Instruction{instruction: .res, bit_position: .b1, target_u8: .b} }
    0x89 { return Instruction{instruction: .res, bit_position: .b1, target_u8: .c} }
    0x8A { return Instruction{instruction: .res, bit_position: .b1, target_u8: .d} }
    0x8B { return Instruction{instruction: .res, bit_position: .b1, target_u8: .e} }
    0x8C { return Instruction{instruction: .res, bit_position: .b1, target_u8: .h} }
    0x8D { return Instruction{instruction: .res, bit_position: .b1, target_u8: .l} }
    0x8E { return Instruction{instruction: .res, bit_position: .b1, target_u16: .hl} }
    0x8F { return Instruction{instruction: .res, bit_position: .b1, target_u8: .a} }

    0x90 { return Instruction{instruction: .res, bit_position: .b2, target_u8: .b} }
    0x91 { return Instruction{instruction: .res, bit_position: .b2, target_u8: .c} }
    0x92 { return Instruction{instruction: .res, bit_position: .b2, target_u8: .d} }
    0x93 { return Instruction{instruction: .res, bit_position: .b2, target_u8: .e} }
    0x94 { return Instruction{instruction: .res, bit_position: .b2, target_u8: .h} }
    0x95 { return Instruction{instruction: .res, bit_position: .b2, target_u8: .l} }
    0x96 { return Instruction{instruction: .res, bit_position: .b2, target_u16: .hl} }
    0x97 { return Instruction{instruction: .res, bit_position: .b2, target_u8: .a} }
    0x98 { return Instruction{instruction: .res, bit_position: .b3, target_u8: .b} }
    0x99 { return Instruction{instruction: .res, bit_position: .b3, target_u8: .c} }
    0x9A { return Instruction{instruction: .res, bit_position: .b3, target_u8: .d} }
    0x9B { return Instruction{instruction: .res, bit_position: .b3, target_u8: .e} }
    0x9C { return Instruction{instruction: .res, bit_position: .b3, target_u8: .h} }
    0x9D { return Instruction{instruction: .res, bit_position: .b3, target_u8: .l} }
    0x9E { return Instruction{instruction: .res, bit_position: .b3, target_u16: .hl} }
    0x9F { return Instruction{instruction: .res, bit_position: .b3, target_u8: .a} }

    0xA0 { return Instruction{instruction: .res, bit_position: .b4, target_u8: .b} }
    0xA1 { return Instruction{instruction: .res, bit_position: .b4, target_u8: .c} }
    0xA2 { return Instruction{instruction: .res, bit_position: .b4, target_u8: .d} }
    0xA3 { return Instruction{instruction: .res, bit_position: .b4, target_u8: .e} }
    0xA4 { return Instruction{instruction: .res, bit_position: .b4, target_u8: .h} }
    0xA5 { return Instruction{instruction: .res, bit_position: .b4, target_u8: .l} }
    0xA6 { return Instruction{instruction: .res, bit_position: .b4, target_u16: .hl} }
    0xA7 { return Instruction{instruction: .res, bit_position: .b4, target_u8: .a} }
    0xA8 { return Instruction{instruction: .res, bit_position: .b5, target_u8: .b} }
    0xA9 { return Instruction{instruction: .res, bit_position: .b5, target_u8: .c} }
    0xAA { return Instruction{instruction: .res, bit_position: .b5, target_u8: .d} }
    0xAB { return Instruction{instruction: .res, bit_position: .b5, target_u8: .e} }
    0xAC { return Instruction{instruction: .res, bit_position: .b5, target_u8: .h} }
    0xAD { return Instruction{instruction: .res, bit_position: .b5, target_u8: .l} }
    0xAE { return Instruction{instruction: .res, bit_position: .b5, target_u16: .hl} }
    0xAF { return Instruction{instruction: .res, bit_position: .b5, target_u8: .a} }

    0xB0 { return Instruction{instruction: .res, bit_position: .b6, target_u8: .b} }
    0xB1 { return Instruction{instruction: .res, bit_position: .b6, target_u8: .c} }
    0xB2 { return Instruction{instruction: .res, bit_position: .b6, target_u8: .d} }
    0xB3 { return Instruction{instruction: .res, bit_position: .b6, target_u8: .e} }
    0xB4 { return Instruction{instruction: .res, bit_position: .b6, target_u8: .h} }
    0xB5 { return Instruction{instruction: .res, bit_position: .b6, target_u8: .l} }
    0xB6 { return Instruction{instruction: .res, bit_position: .b6, target_u16: .hl} }
    0xB7 { return Instruction{instruction: .res, bit_position: .b6, target_u8: .a} }
    0xB8 { return Instruction{instruction: .res, bit_position: .b7, target_u8: .b} }
    0xB9 { return Instruction{instruction: .res, bit_position: .b7, target_u8: .c} }
    0xBA { return Instruction{instruction: .res, bit_position: .b7, target_u8: .d} }
    0xBB { return Instruction{instruction: .res, bit_position: .b7, target_u8: .e} }
    0xBC { return Instruction{instruction: .res, bit_position: .b7, target_u8: .h} }
    0xBD { return Instruction{instruction: .res, bit_position: .b7, target_u8: .l} }
    0xBE { return Instruction{instruction: .res, bit_position: .b7, target_u16: .hl} }
    0xBF { return Instruction{instruction: .res, bit_position: .b7, target_u8: .a} }

    /* SET instruction */
    0xC0 { return Instruction{instruction: .set, bit_position: .b0, target_u8: .b} }
    0xC1 { return Instruction{instruction: .set, bit_position: .b0, target_u8: .c} }
    0xC2 { return Instruction{instruction: .set, bit_position: .b0, target_u8: .d} }
    0xC3 { return Instruction{instruction: .set, bit_position: .b0, target_u8: .e} }
    0xC4 { return Instruction{instruction: .set, bit_position: .b0, target_u8: .h} }
    0xC5 { return Instruction{instruction: .set, bit_position: .b0, target_u8: .l} }
    0xC6 { return Instruction{instruction: .set, bit_position: .b0, target_u16: .hl} }
    0xC7 { return Instruction{instruction: .set, bit_position: .b0, target_u8: .a} }
    0xC8 { return Instruction{instruction: .set, bit_position: .b1, target_u8: .b} }
    0xC9 { return Instruction{instruction: .set, bit_position: .b1, target_u8: .c} }
    0xCA { return Instruction{instruction: .set, bit_position: .b1, target_u8: .d} }
    0xCB { return Instruction{instruction: .set, bit_position: .b1, target_u8: .e} }
    0xCC { return Instruction{instruction: .set, bit_position: .b1, target_u8: .h} }
    0xCD { return Instruction{instruction: .set, bit_position: .b1, target_u8: .l} }
    0xCE { return Instruction{instruction: .set, bit_position: .b1, target_u16: .hl} }
    0xCF { return Instruction{instruction: .set, bit_position: .b1, target_u8: .a} }

    0xD0 { return Instruction{instruction: .set, bit_position: .b2, target_u8: .b} }
    0xD1 { return Instruction{instruction: .set, bit_position: .b2, target_u8: .c} }
    0xD2 { return Instruction{instruction: .set, bit_position: .b2, target_u8: .d} }
    0xD3 { return Instruction{instruction: .set, bit_position: .b2, target_u8: .e} }
    0xD4 { return Instruction{instruction: .set, bit_position: .b2, target_u8: .h} }
    0xD5 { return Instruction{instruction: .set, bit_position: .b2, target_u8: .l} }
    0xD6 { return Instruction{instruction: .set, bit_position: .b2, target_u16: .hl} }
    0xD7 { return Instruction{instruction: .set, bit_position: .b2, target_u8: .a} }
    0xD8 { return Instruction{instruction: .set, bit_position: .b3, target_u8: .b} }
    0xD9 { return Instruction{instruction: .set, bit_position: .b3, target_u8: .c} }
    0xDA { return Instruction{instruction: .set, bit_position: .b3, target_u8: .d} }
    0xDB { return Instruction{instruction: .set, bit_position: .b3, target_u8: .e} }
    0xDC { return Instruction{instruction: .set, bit_position: .b3, target_u8: .h} }
    0xDD { return Instruction{instruction: .set, bit_position: .b3, target_u8: .l} }
    0xDE { return Instruction{instruction: .set, bit_position: .b3, target_u16: .hl} }
    0xDF { return Instruction{instruction: .set, bit_position: .b3, target_u8: .a} }

    0xE0 { return Instruction{instruction: .set, bit_position: .b4, target_u8: .b} }
    0xE1 { return Instruction{instruction: .set, bit_position: .b4, target_u8: .c} }
    0xE2 { return Instruction{instruction: .set, bit_position: .b4, target_u8: .d} }
    0xE3 { return Instruction{instruction: .set, bit_position: .b4, target_u8: .e} }
    0xE4 { return Instruction{instruction: .set, bit_position: .b4, target_u8: .h} }
    0xE5 { return Instruction{instruction: .set, bit_position: .b4, target_u8: .l} }
    0xE6 { return Instruction{instruction: .set, bit_position: .b4, target_u16: .hl} }
    0xE7 { return Instruction{instruction: .set, bit_position: .b4, target_u8: .a} }
    0xE8 { return Instruction{instruction: .set, bit_position: .b5, target_u8: .b} }
    0xE9 { return Instruction{instruction: .set, bit_position: .b5, target_u8: .c} }
    0xEA { return Instruction{instruction: .set, bit_position: .b5, target_u8: .d} }
    0xEB { return Instruction{instruction: .set, bit_position: .b5, target_u8: .e} }
    0xEC { return Instruction{instruction: .set, bit_position: .b5, target_u8: .h} }
    0xED { return Instruction{instruction: .set, bit_position: .b5, target_u8: .l} }
    0xEE { return Instruction{instruction: .set, bit_position: .b5, target_u16: .hl} }
    0xEF { return Instruction{instruction: .set, bit_position: .b5, target_u8: .a} }

    0xF0 { return Instruction{instruction: .set, bit_position: .b6, target_u8: .b} }
    0xF1 { return Instruction{instruction: .set, bit_position: .b6, target_u8: .c} }
    0xF2 { return Instruction{instruction: .set, bit_position: .b6, target_u8: .d} }
    0xF3 { return Instruction{instruction: .set, bit_position: .b6, target_u8: .e} }
    0xF4 { return Instruction{instruction: .set, bit_position: .b6, target_u8: .h} }
    0xF5 { return Instruction{instruction: .set, bit_position: .b6, target_u8: .l} }
    0xF6 { return Instruction{instruction: .set, bit_position: .b6, target_u16: .hl} }
    0xF7 { return Instruction{instruction: .set, bit_position: .b6, target_u8: .a} }
    0xF8 { return Instruction{instruction: .set, bit_position: .b7, target_u8: .b} }
    0xF9 { return Instruction{instruction: .set, bit_position: .b7, target_u8: .c} }
    0xFA { return Instruction{instruction: .set, bit_position: .b7, target_u8: .d} }
    0xFB { return Instruction{instruction: .set, bit_position: .b7, target_u8: .e} }
    0xFC { return Instruction{instruction: .set, bit_position: .b7, target_u8: .h} }
    0xFD { return Instruction{instruction: .set, bit_position: .b7, target_u8: .l} }
    0xFE { return Instruction{instruction: .set, bit_position: .b7, target_u16: .hl} }
    0xFF { return Instruction{instruction: .set, bit_position: .b7, target_u8: .a} }

    else { panic("Prefixed instruction not found: ${value}") }
  }
}

fn instruction_from_byte_not_prefixed(value u8) Instruction {
  match value {
    /* INC instruction */
    0x3c { return Instruction{instruction: .inc, target_u8: .a} }
    0x04 { return Instruction{instruction: .inc, target_u8: .b} }
    0x0c { return Instruction{instruction: .inc, target_u8: .c} }
    0x14 { return Instruction{instruction: .inc, target_u8: .d} }
    0x1c { return Instruction{instruction: .inc, target_u8: .e} }
    0x24 { return Instruction{instruction: .inc, target_u8: .h} }
    0x2c { return Instruction{instruction: .inc, target_u8: .l} }
    0x34 { return Instruction{instruction: .inc, target_u8: .hli} }
    0x03 { return Instruction{instruction: .inc, target_u16: .bc} }
    0x13 { return Instruction{instruction: .inc, target_u16: .de} }
    0x23 { return Instruction{instruction: .inc, target_u16: .hl} }
    0x33 { return Instruction{instruction: .inc, target_u16: .sp} }

    /* DEC instruction */
    0x3d { return Instruction{instruction: .dec, target_u8: .a} }
    0x05 { return Instruction{instruction: .dec, target_u8: .b} }
    0x0d { return Instruction{instruction: .dec, target_u8: .c} }
    0x15 { return Instruction{instruction: .dec, target_u8: .d} }
    0x1d { return Instruction{instruction: .dec, target_u8: .e} }
    0x25 { return Instruction{instruction: .dec, target_u8: .h} }
    0x2d { return Instruction{instruction: .dec, target_u8: .l} }
    0x35 { return Instruction{instruction: .dec, target_u8: .hli} }
    0x0b { return Instruction{instruction: .dec, target_u16: .bc} }
    0x1b { return Instruction{instruction: .dec, target_u16: .de} }
    0x2b { return Instruction{instruction: .dec, target_u16: .hl} }
    0x3b { return Instruction{instruction: .dec, target_u16: .sp} }

    /* ADD instruction */
    0x87 { return Instruction{instruction: .add, target_u8: .a} }
    0x80 { return Instruction{instruction: .add, target_u8: .b} }
    0x81 { return Instruction{instruction: .add, target_u8: .c} }
    0x82 { return Instruction{instruction: .add, target_u8: .d} }
    0x83 { return Instruction{instruction: .add, target_u8: .e} }
    0x84 { return Instruction{instruction: .add, target_u8: .h} }
    0x85 { return Instruction{instruction: .add, target_u8: .l} }
    0x86 { return Instruction{instruction: .add, target_u8: .hli} }
    0xc6 { return Instruction{instruction: .add, target_u8: .d8} }

    /* ADD HL instruction */
    0x09 { return Instruction{instruction: .addhl, target_u16: .bc} }
    0x19 { return Instruction{instruction: .addhl, target_u16: .de} }
    0x29 { return Instruction{instruction: .addhl, target_u16: .hl} }
    0x39 { return Instruction{instruction: .addhl, target_u16: .sp} }

    /* ADC instruction */
    0x8f { return Instruction{instruction: .adc, target_u8: .a} }
    0x88 { return Instruction{instruction: .adc, target_u8: .b} }
    0x89 { return Instruction{instruction: .adc, target_u8: .c} }
    0x8a { return Instruction{instruction: .adc, target_u8: .d} }
    0x8b { return Instruction{instruction: .adc, target_u8: .e} }
    0x8c { return Instruction{instruction: .adc, target_u8: .h} }
    0x8d { return Instruction{instruction: .adc, target_u8: .l} }
    0x8e { return Instruction{instruction: .adc, target_u8: .hli} }
    0xce { return Instruction{instruction: .adc, target_u8: .d8} }

    /* SUB instruction */
    0x97 { return Instruction{instruction: .sub, target_u8: .a} }
    0x90 { return Instruction{instruction: .sub, target_u8: .b} }
    0x91 { return Instruction{instruction: .sub, target_u8: .c} }
    0x92 { return Instruction{instruction: .sub, target_u8: .d} }
    0x93 { return Instruction{instruction: .sub, target_u8: .e} }
    0x94 { return Instruction{instruction: .sub, target_u8: .h} }
    0x95 { return Instruction{instruction: .sub, target_u8: .l} }
    0x96 { return Instruction{instruction: .sub, target_u8: .hli} }
    0xd6 { return Instruction{instruction: .sub, target_u8: .d8} }

    /* SBC instruction */
    0x9f { return Instruction{instruction: .sbc, target_u8: .a} }
    0x98 { return Instruction{instruction: .sbc, target_u8: .b} }
    0x99 { return Instruction{instruction: .sbc, target_u8: .c} }
    0x9a { return Instruction{instruction: .sbc, target_u8: .d} }
    0x9b { return Instruction{instruction: .sbc, target_u8: .e} }
    0x9c { return Instruction{instruction: .sbc, target_u8: .h} }
    0x9d { return Instruction{instruction: .sbc, target_u8: .l} }
    0x9e { return Instruction{instruction: .sbc, target_u8: .hli} }
    0xde { return Instruction{instruction: .sbc, target_u8: .d8} }

    /* AND instruction */
    0xa7 { return Instruction{instruction: .and, target_u8: .a} }
    0xa0 { return Instruction{instruction: .and, target_u8: .b} }
    0xa1 { return Instruction{instruction: .and, target_u8: .c} }
    0xa2 { return Instruction{instruction: .and, target_u8: .d} }
    0xa3 { return Instruction{instruction: .and, target_u8: .e} }
    0xa4 { return Instruction{instruction: .and, target_u8: .h} }
    0xa5 { return Instruction{instruction: .and, target_u8: .l} }
    0xa6 { return Instruction{instruction: .and, target_u8: .hli} }
    0xe6 { return Instruction{instruction: .and, target_u8: .d8} }

    /* OR instruction */
    0xb7 { return Instruction{instruction: .@or, target_u8: .a} }
    0xb0 { return Instruction{instruction: .@or, target_u8: .b} }
    0xb1 { return Instruction{instruction: .@or, target_u8: .c} }
    0xb2 { return Instruction{instruction: .@or, target_u8: .d} }
    0xb3 { return Instruction{instruction: .@or, target_u8: .e} }
    0xb4 { return Instruction{instruction: .@or, target_u8: .h} }
    0xb5 { return Instruction{instruction: .@or, target_u8: .l} }
    0xb6 { return Instruction{instruction: .@or, target_u8: .hli} }
    0xf6 { return Instruction{instruction: .@or, target_u8: .d8} }

    /* XOR instruction */
    0xaf { return Instruction{instruction: .xor, target_u8: .a} }
    0xa8 { return Instruction{instruction: .xor, target_u8: .b} }
    0xa9 { return Instruction{instruction: .xor, target_u8: .c} }
    0xaa { return Instruction{instruction: .xor, target_u8: .d} }
    0xab { return Instruction{instruction: .xor, target_u8: .e} }
    0xac { return Instruction{instruction: .xor, target_u8: .h} }
    0xad { return Instruction{instruction: .xor, target_u8: .l} }
    0xae { return Instruction{instruction: .xor, target_u8: .hli} }
    0xee { return Instruction{instruction: .xor, target_u8: .d8} }

    /* CP instruction */
    0xbf { return Instruction{instruction: .cp, target_u8: .a} }
    0xb8 { return Instruction{instruction: .cp, target_u8: .b} }
    0xb9 { return Instruction{instruction: .cp, target_u8: .c} }
    0xba { return Instruction{instruction: .cp, target_u8: .d} }
    0xbb { return Instruction{instruction: .cp, target_u8: .e} }
    0xbc { return Instruction{instruction: .cp, target_u8: .h} }
    0xbd { return Instruction{instruction: .cp, target_u8: .l} }
    0xbe { return Instruction{instruction: .cp, target_u8: .hli} }
    0xfe { return Instruction{instruction: .cp, target_u8: .d8} }

    /* ADDSP instruction */
    0xe8 { return Instruction{instruction: .addsp} }

    /* Misc instruction */
    0x3f { return Instruction{instruction: .ccf} }
    0x37 { return Instruction{instruction: .scf} }
    0x1f { return Instruction{instruction: .rra} }
    0x17 { return Instruction{instruction: .rla} }
    0x0f { return Instruction{instruction: .rrca} }
    0x07 { return Instruction{instruction: .rlca} }
    0x2f { return Instruction{instruction: .cpl} }

    0x27 { return Instruction{instruction: .daa} }

    /* JP instruction */
    0xc3 { return Instruction{instruction: .jp, jump_test: .always} }
    0xca { return Instruction{instruction: .jp, jump_test: .zero} }
    0xda { return Instruction{instruction: .jp, jump_test: .carry} }
    0xc2 { return Instruction{instruction: .jp, jump_test: .not_zero} }
    0xd2 { return Instruction{instruction: .jp, jump_test: .not_carry} }

    /* JR instruction */
    0x18 { return Instruction{instruction: .jr, jump_test: .always} }
    0x28 { return Instruction{instruction: .jr, jump_test: .zero} }
    0x38 { return Instruction{instruction: .jr, jump_test: .carry} }
    0x20 { return Instruction{instruction: .jr, jump_test: .not_zero} }
    0x30 { return Instruction{instruction: .jr, jump_test: .not_carry} }

    /* JPI instruction */
    0xe9 { return Instruction{instruction: .jpi} }

    /* LD instruction */
    0xf2 { return Instruction{instruction: .ld, load_type: .a_from_indirect, indirect: .last_byte_indirect} }
    0x0a { return Instruction{instruction: .ld, load_type: .a_from_indirect, indirect: .bc_indirect} }
    0x1a { return Instruction{instruction: .ld, load_type: .a_from_indirect, indirect: .de_indirect} }
    0x2a { return Instruction{instruction: .ld, load_type: .a_from_indirect, indirect: .hl_indirect_plus} }
    0x3a { return Instruction{instruction: .ld, load_type: .a_from_indirect, indirect: .hl_indirect_minus} }
    0xfa { return Instruction{instruction: .ld, load_type: .a_from_indirect, indirect: .word_indirect} }

    0xe2 { return Instruction{instruction: .ld, load_type: .indirect_from_a, indirect: .last_byte_indirect} }
    0x02 { return Instruction{instruction: .ld, load_type: .indirect_from_a, indirect: .bc_indirect} }
    0x12 { return Instruction{instruction: .ld, load_type: .indirect_from_a, indirect: .de_indirect} }
    0x22 { return Instruction{instruction: .ld, load_type: .indirect_from_a, indirect: .hl_indirect_plus} }
    0x32 { return Instruction{instruction: .ld, load_type: .indirect_from_a, indirect: .hl_indirect_minus} }
    0xea { return Instruction{instruction: .ld, load_type: .indirect_from_a, indirect: .word_indirect} }

    0x01 { return Instruction{instruction: .ld, load_type: .word, word_target: .bc} }
    0x11 { return Instruction{instruction: .ld, load_type: .word, word_target: .de} }
    0x21 { return Instruction{instruction: .ld, load_type: .word, word_target: .hl} }
    0x31 { return Instruction{instruction: .ld, load_type: .word, word_target: .sp} }

    0x40 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .b} }
    0x41 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .c} }
    0x42 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .d} }
    0x43 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .e} }
    0x44 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .h} }
    0x45 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .l} }
    0x46 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .hli} }
    0x47 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .a} }

    0x48 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .b} }
    0x49 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .c} }
    0x4a { return Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .d} }
    0x4b { return Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .e} }
    0x4c { return Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .h} }
    0x4d { return Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .l} }
    0x4e { return Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .hli} }
    0x4f { return Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .a} }

    0x50 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .b} }
    0x51 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .c} }
    0x52 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .d} }
    0x53 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .e} }
    0x54 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .h} }
    0x55 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .l} }
    0x56 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .hli} }
    0x57 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .a} }

    0x58 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .b} }
    0x59 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .c} }
    0x5a { return Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .d} }
    0x5b { return Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .e} }
    0x5c { return Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .h} }
    0x5d { return Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .l} }
    0x5e { return Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .hli} }
    0x5f { return Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .a} }

    0x60 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .b} }
    0x61 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .c} }
    0x62 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .d} }
    0x63 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .e} }
    0x64 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .h} }
    0x65 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .l} }
    0x66 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .hli} }
    0x67 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .a} }

    0x68 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .b} }
    0x69 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .c} }
    0x6a { return Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .d} }
    0x6b { return Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .e} }
    0x6c { return Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .h} }
    0x6d { return Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .l} }
    0x6e { return Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .hli} }
    0x6f { return Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .a} }

    0x70 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .b} }
    0x71 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .c} }
    0x72 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .d} }
    0x73 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .e} }
    0x74 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .h} }
    0x75 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .l} }
    0x77 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .a} }

    0x78 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .b} }
    0x79 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .c} }
    0x7a { return Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .d} }
    0x7b { return Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .e} }
    0x7c { return Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .h} }
    0x7d { return Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .l} }
    0x7e { return Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .hli} }
    0x7f { return Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .a} }

    0x3e { return Instruction{instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .d8} }
    0x06 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .d8} }
    0x0e { return Instruction{instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .d8} }
    0x16 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .d8} }
    0x1e { return Instruction{instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .d8} }
    0x26 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .d8} }
    0x2e { return Instruction{instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .d8} }
    0x36 { return Instruction{instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .d8} }

    0xe0 { return Instruction{instruction: .ld, load_type: .byte_address_from_a} }
    0xf0 { return Instruction{instruction: .ld, load_type: .a_from_byte_address} }

    0x08 { return Instruction{instruction: .ld, load_type: .indirect_from_sp} }
    0xf9 { return Instruction{instruction: .ld, load_type: .sp_from_hl} }
    0xf8 { return Instruction{instruction: .ld, load_type: .hl_from_spn} }

    /* PUSH instruction */
    0xc5 { return Instruction{instruction: .push, stack_target: .bc} }
    0xd5 { return Instruction{instruction: .push, stack_target: .de} }
    0xe5 { return Instruction{instruction: .push, stack_target: .hl} }
    0xf5 { return Instruction{instruction: .push, stack_target: .af} }

    /* POP instruction */
    0xc1 { return Instruction{instruction: .pop, stack_target: .bc} }
    0xd1 { return Instruction{instruction: .pop, stack_target: .de} }
    0xe1 { return Instruction{instruction: .pop, stack_target: .hl} }
    0xf1 { return Instruction{instruction: .pop, stack_target: .af} }

    /* CALL instruction */
    0xc4 { return Instruction{instruction: .call, jump_test: .not_zero} }
    0xd4 { return Instruction{instruction: .call, jump_test: .not_carry} }
    0xcc { return Instruction{instruction: .call, jump_test: .zero} }
    0xdc { return Instruction{instruction: .call, jump_test: .carry} }
    0xcd { return Instruction{instruction: .call, jump_test: .always} }

    /* RET instruction */
    0xc0 { return Instruction{instruction: .ret, jump_test: .not_zero} }
    0xd0 { return Instruction{instruction: .ret, jump_test: .not_carry} }
    0xc8 { return Instruction{instruction: .ret, jump_test: .zero} }
    0xd8 { return Instruction{instruction: .ret, jump_test: .carry} }
    0xc9 { return Instruction{instruction: .ret, jump_test: .always} }
    0xd9 { return Instruction{instruction: .reti} }

    /* RST instruction */
    0xc7 { return Instruction{instruction: .rst, rst_location: .x00} }
    0xd7 { return Instruction{instruction: .rst, rst_location: .x10} }
    0xe7 { return Instruction{instruction: .rst, rst_location: .x20} }
    0xf7 { return Instruction{instruction: .rst, rst_location: .x30} }
    0xcf { return Instruction{instruction: .rst, rst_location: .x08} }
    0xdf { return Instruction{instruction: .rst, rst_location: .x18} }
    0xef { return Instruction{instruction: .rst, rst_location: .x28} }
    0xff { return Instruction{instruction: .rst, rst_location: .x38} }

    /* MISC instruction */
    0x00 { return Instruction{instruction: .nop} }
    0x76 { return Instruction{instruction: .halt} }
    0xf3 { return Instruction{instruction: .di} }
    0xfb { return Instruction{instruction: .ei} }

    else { panic("Unprefixed instruction not found: ${value}") }
  }
}
