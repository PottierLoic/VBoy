/* Choose the correct to get instruction name */
fn instruction_name_from_byte(value u8, prefixed bool) string {
  if prefixed { return prefixed_instruction_name(value) }
  else { return unprefixed_instruction_name(value) }
}

fn prefixed_instruction_name(value u8) string {
  match value {
    /* RLC instruction */
    0x00 { return "instruction: .rlc, target_u8: .b" }
    0x01 { return "instruction: .rlc, target_u8: .c" }
    0x02 { return "instruction: .rlc, target_u8: .d" }
    0x03 { return "instruction: .rlc, target_u8: .e" }
    0x04 { return "instruction: .rlc, target_u8: .h" }
    0x05 { return "instruction: .rlc, target_u8: .l" }
    0x06 { return "instruction: .rlc, target_u16: .hl" }
    0x07 { return "instruction: .rlc, target_u8: .a" }

    /* RRC instruction */
    0x08 { return "instruction: .rrc, target_u8: .b" }
    0x09 { return "instruction: .rrc, target_u8: .c" }
    0x0A { return "instruction: .rrc, target_u8: .d" }
    0x0B { return "instruction: .rrc, target_u8: .e" }
    0x0C { return "instruction: .rrc, target_u8: .h" }
    0x0D { return "instruction: .rrc, target_u8: .l" }
    0x0E { return "instruction: .rrc, target_u16: .hl" }
    0x0F { return "instruction: .rrc, target_u8: .a" }

    /* RL instruction */
    0x10 { return "instruction: .rl, target_u8: .b" }
    0x11 { return "instruction: .rl, target_u8: .c" }
    0x12 { return "instruction: .rl, target_u8: .d" }
    0x13 { return "instruction: .rl, target_u8: .e" }
    0x14 { return "instruction: .rl, target_u8: .h" }
    0x15 { return "instruction: .rl, target_u8: .l" }
    0x16 { return "instruction: .rl, target_u16: .hl" }
    0x17 { return "instruction: .rl, target_u8: .a" }

    /* RR instruction */
    0x18 { return "instruction: .rr, target_u8: .b" }
    0x19 { return "instruction: .rr, target_u8: .c" }
    0x1A { return "instruction: .rr, target_u8: .d" }
    0x1B { return "instruction: .rr, target_u8: .e" }
    0x1C { return "instruction: .rr, target_u8: .h" }
    0x1D { return "instruction: .rr, target_u8: .l" }
    0x1E { return "instruction: .rr, target_u16: .hl" }
    0x1F { return "instruction: .rr, target_u8: .a" }

    /* SLA instruction */
    0x20 { return "instruction: .sla, target_u8: .b" }
    0x21 { return "instruction: .sla, target_u8: .c" }
    0x22 { return "instruction: .sla, target_u8: .d" }
    0x23 { return "instruction: .sla, target_u8: .e" }
    0x24 { return "instruction: .sla, target_u8: .h" }
    0x25 { return "instruction: .sla, target_u8: .l" }
    0x26 { return "instruction: .sla, target_u16: .hl" }
    0x27 { return "instruction: .sla, target_u8: .a" }

    /* SRA instruction */
    0x28 { return "instruction: .sra, target_u8: .b" }
    0x29 { return "instruction: .sra, target_u8: .c" }
    0x2A { return "instruction: .sra, target_u8: .d" }
    0x2B { return "instruction: .sra, target_u8: .e" }
    0x2C { return "instruction: .sra, target_u8: .h" }
    0x2D { return "instruction: .sra, target_u8: .l" }
    0x2E { return "instruction: .sra, target_u16: .hl" }
    0x2F { return "instruction: .sra, target_u8: .a" }

    /* SWAP instruction */
    0x30 { return "instruction: .swap, target_u8: .b" }
    0x31 { return "instruction: .swap, target_u8: .c" }
    0x32 { return "instruction: .swap, target_u8: .d" }
    0x33 { return "instruction: .swap, target_u8: .e" }
    0x34 { return "instruction: .swap, target_u8: .h" }
    0x35 { return "instruction: .swap, target_u8: .l" }
    0x36 { return "instruction: .swap, target_u16: .hl" }
    0x37 { return "instruction: .swap, target_u8: .a" }

    /* SRL instruction */
    0x38 { return "instruction: .srl, target_u8: .b" }
    0x39 { return "instruction: .srl, target_u8: .c" }
    0x3A { return "instruction: .srl, target_u8: .d" }
    0x3B { return "instruction: .srl, target_u8: .e" }
    0x3C { return "instruction: .srl, target_u8: .h" }
    0x3D { return "instruction: .srl, target_u8: .l" }
    0x3E { return "instruction: .srl, target_u16: .hl" }
    0x3F { return "instruction: .srl, target_u8: .a" }

    /* BIT instruction */
    0x40 { return "instruction: .bit, bit_position: .b0, target_u8: .b" }
    0x41 { return "instruction: .bit, bit_position: .b0, target_u8: .c" }
    0x42 { return "instruction: .bit, bit_position: .b0, target_u8: .d" }
    0x43 { return "instruction: .bit, bit_position: .b0, target_u8: .e" }
    0x44 { return "instruction: .bit, bit_position: .b0, target_u8: .h" }
    0x45 { return "instruction: .bit, bit_position: .b0, target_u8: .l" }
    0x46 { return "instruction: .bit, bit_position: .b0, target_u16: .hl" }
    0x47 { return "instruction: .bit, bit_position: .b0, target_u8: .a" }
    0x48 { return "instruction: .bit, bit_position: .b1, target_u8: .b" }
    0x49 { return "instruction: .bit, bit_position: .b1, target_u8: .c" }
    0x4A { return "instruction: .bit, bit_position: .b1, target_u8: .d" }
    0x4B { return "instruction: .bit, bit_position: .b1, target_u8: .e" }
    0x4C { return "instruction: .bit, bit_position: .b1, target_u8: .h" }
    0x4D { return "instruction: .bit, bit_position: .b1, target_u8: .l" }
    0x4E { return "instruction: .bit, bit_position: .b1, target_u16: .hl" }
    0x4F { return "instruction: .bit, bit_position: .b1, target_u8: .a" }

    0x50 { return "instruction: .bit, bit_position: .b2, target_u8: .b" }
    0x51 { return "instruction: .bit, bit_position: .b2, target_u8: .c" }
    0x52 { return "instruction: .bit, bit_position: .b2, target_u8: .d" }
    0x53 { return "instruction: .bit, bit_position: .b2, target_u8: .e" }
    0x54 { return "instruction: .bit, bit_position: .b2, target_u8: .h" }
    0x55 { return "instruction: .bit, bit_position: .b2, target_u8: .l" }
    0x56 { return "instruction: .bit, bit_position: .b2, target_u16: .hl" }
    0x57 { return "instruction: .bit, bit_position: .b2, target_u8: .a" }
    0x58 { return "instruction: .bit, bit_position: .b3, target_u8: .b" }
    0x59 { return "instruction: .bit, bit_position: .b3, target_u8: .c" }
    0x5A { return "instruction: .bit, bit_position: .b3, target_u8: .d" }
    0x5B { return "instruction: .bit, bit_position: .b3, target_u8: .e" }
    0x5C { return "instruction: .bit, bit_position: .b3, target_u8: .h" }
    0x5D { return "instruction: .bit, bit_position: .b3, target_u8: .l" }
    0x5E { return "instruction: .bit, bit_position: .b3, target_u16: .hl" }
    0x5F { return "instruction: .bit, bit_position: .b3, target_u8: .a" }

    0x60 { return "instruction: .bit, bit_position: .b4, target_u8: .b" }
    0x61 { return "instruction: .bit, bit_position: .b4, target_u8: .c" }
    0x62 { return "instruction: .bit, bit_position: .b4, target_u8: .d" }
    0x63 { return "instruction: .bit, bit_position: .b4, target_u8: .e" }
    0x64 { return "instruction: .bit, bit_position: .b4, target_u8: .h" }
    0x65 { return "instruction: .bit, bit_position: .b4, target_u8: .l" }
    0x66 { return "instruction: .bit, bit_position: .b4, target_u16: .hl" }
    0x67 { return "instruction: .bit, bit_position: .b4, target_u8: .a" }
    0x68 { return "instruction: .bit, bit_position: .b5, target_u8: .b" }
    0x69 { return "instruction: .bit, bit_position: .b5, target_u8: .c" }
    0x6A { return "instruction: .bit, bit_position: .b5, target_u8: .d" }
    0x6B { return "instruction: .bit, bit_position: .b5, target_u8: .e" }
    0x6C { return "instruction: .bit, bit_position: .b5, target_u8: .h" }
    0x6D { return "instruction: .bit, bit_position: .b5, target_u8: .l" }
    0x6E { return "instruction: .bit, bit_position: .b5, target_u16: .hl" }
    0x6F { return "instruction: .bit, bit_position: .b5, target_u8: .a" }

    0x70 { return "instruction: .bit, bit_position: .b6, target_u8: .b" }
    0x71 { return "instruction: .bit, bit_position: .b6, target_u8: .c" }
    0x72 { return "instruction: .bit, bit_position: .b6, target_u8: .d" }
    0x73 { return "instruction: .bit, bit_position: .b6, target_u8: .e" }
    0x74 { return "instruction: .bit, bit_position: .b6, target_u8: .h" }
    0x75 { return "instruction: .bit, bit_position: .b6, target_u8: .l" }
    0x76 { return "instruction: .bit, bit_position: .b6, target_u16: .hl" }
    0x77 { return "instruction: .bit, bit_position: .b6, target_u8: .a" }
    0x78 { return "instruction: .bit, bit_position: .b7, target_u8: .b" }
    0x79 { return "instruction: .bit, bit_position: .b7, target_u8: .c" }
    0x7A { return "instruction: .bit, bit_position: .b7, target_u8: .d" }
    0x7B { return "instruction: .bit, bit_position: .b7, target_u8: .e" }
    0x7C { return "instruction: .bit, bit_position: .b7, target_u8: .h" }
    0x7D { return "instruction: .bit, bit_position: .b7, target_u8: .l" }
    0x7E { return "instruction: .bit, bit_position: .b7, target_u16: .hl" }
    0x7F { return "instruction: .bit, bit_position: .b7, target_u8: .a" }

    /* RES instruction */
    0x80 { return "instruction: .res, bit_position: .b0, target_u8: .b" }
    0x81 { return "instruction: .res, bit_position: .b0, target_u8: .c" }
    0x82 { return "instruction: .res, bit_position: .b0, target_u8: .d" }
    0x83 { return "instruction: .res, bit_position: .b0, target_u8: .e" }
    0x84 { return "instruction: .res, bit_position: .b0, target_u8: .h" }
    0x85 { return "instruction: .res, bit_position: .b0, target_u8: .l" }
    0x86 { return "instruction: .res, bit_position: .b0, target_u16: .hl" }
    0x87 { return "instruction: .res, bit_position: .b0, target_u8: .a" }
    0x88 { return "instruction: .res, bit_position: .b1, target_u8: .b" }
    0x89 { return "instruction: .res, bit_position: .b1, target_u8: .c" }
    0x8A { return "instruction: .res, bit_position: .b1, target_u8: .d" }
    0x8B { return "instruction: .res, bit_position: .b1, target_u8: .e" }
    0x8C { return "instruction: .res, bit_position: .b1, target_u8: .h" }
    0x8D { return "instruction: .res, bit_position: .b1, target_u8: .l" }
    0x8E { return "instruction: .res, bit_position: .b1, target_u16: .hl" }
    0x8F { return "instruction: .res, bit_position: .b1, target_u8: .a" }

    0x90 { return "instruction: .res, bit_position: .b2, target_u8: .b" }
    0x91 { return "instruction: .res, bit_position: .b2, target_u8: .c" }
    0x92 { return "instruction: .res, bit_position: .b2, target_u8: .d" }
    0x93 { return "instruction: .res, bit_position: .b2, target_u8: .e" }
    0x94 { return "instruction: .res, bit_position: .b2, target_u8: .h" }
    0x95 { return "instruction: .res, bit_position: .b2, target_u8: .l" }
    0x96 { return "instruction: .res, bit_position: .b2, target_u16: .hl" }
    0x97 { return "instruction: .res, bit_position: .b2, target_u8: .a" }
    0x98 { return "instruction: .res, bit_position: .b3, target_u8: .b" }
    0x99 { return "instruction: .res, bit_position: .b3, target_u8: .c" }
    0x9A { return "instruction: .res, bit_position: .b3, target_u8: .d" }
    0x9B { return "instruction: .res, bit_position: .b3, target_u8: .e" }
    0x9C { return "instruction: .res, bit_position: .b3, target_u8: .h" }
    0x9D { return "instruction: .res, bit_position: .b3, target_u8: .l" }
    0x9E { return "instruction: .res, bit_position: .b3, target_u16: .hl" }
    0x9F { return "instruction: .res, bit_position: .b3, target_u8: .a" }

    0xA0 { return "instruction: .res, bit_position: .b4, target_u8: .b" }
    0xA1 { return "instruction: .res, bit_position: .b4, target_u8: .c" }
    0xA2 { return "instruction: .res, bit_position: .b4, target_u8: .d" }
    0xA3 { return "instruction: .res, bit_position: .b4, target_u8: .e" }
    0xA4 { return "instruction: .res, bit_position: .b4, target_u8: .h" }
    0xA5 { return "instruction: .res, bit_position: .b4, target_u8: .l" }
    0xA6 { return "instruction: .res, bit_position: .b4, target_u16: .hl" }
    0xA7 { return "instruction: .res, bit_position: .b4, target_u8: .a" }
    0xA8 { return "instruction: .res, bit_position: .b5, target_u8: .b" }
    0xA9 { return "instruction: .res, bit_position: .b5, target_u8: .c" }
    0xAA { return "instruction: .res, bit_position: .b5, target_u8: .d" }
    0xAB { return "instruction: .res, bit_position: .b5, target_u8: .e" }
    0xAC { return "instruction: .res, bit_position: .b5, target_u8: .h" }
    0xAD { return "instruction: .res, bit_position: .b5, target_u8: .l" }
    0xAE { return "instruction: .res, bit_position: .b5, target_u16: .hl" }
    0xAF { return "instruction: .res, bit_position: .b5, target_u8: .a" }

    0xB0 { return "instruction: .res, bit_position: .b6, target_u8: .b" }
    0xB1 { return "instruction: .res, bit_position: .b6, target_u8: .c" }
    0xB2 { return "instruction: .res, bit_position: .b6, target_u8: .d" }
    0xB3 { return "instruction: .res, bit_position: .b6, target_u8: .e" }
    0xB4 { return "instruction: .res, bit_position: .b6, target_u8: .h" }
    0xB5 { return "instruction: .res, bit_position: .b6, target_u8: .l" }
    0xB6 { return "instruction: .res, bit_position: .b6, target_u16: .hl" }
    0xB7 { return "instruction: .res, bit_position: .b6, target_u8: .a" }
    0xB8 { return "instruction: .res, bit_position: .b7, target_u8: .b" }
    0xB9 { return "instruction: .res, bit_position: .b7, target_u8: .c" }
    0xBA { return "instruction: .res, bit_position: .b7, target_u8: .d" }
    0xBB { return "instruction: .res, bit_position: .b7, target_u8: .e" }
    0xBC { return "instruction: .res, bit_position: .b7, target_u8: .h" }
    0xBD { return "instruction: .res, bit_position: .b7, target_u8: .l" }
    0xBE { return "instruction: .res, bit_position: .b7, target_u16: .hl" }
    0xBF { return "instruction: .res, bit_position: .b7, target_u8: .a" }

    /* SET instruction */
    0xC0 { return "instruction: .set, bit_position: .b0, target_u8: .b" }
    0xC1 { return "instruction: .set, bit_position: .b0, target_u8: .c" }
    0xC2 { return "instruction: .set, bit_position: .b0, target_u8: .d" }
    0xC3 { return "instruction: .set, bit_position: .b0, target_u8: .e" }
    0xC4 { return "instruction: .set, bit_position: .b0, target_u8: .h" }
    0xC5 { return "instruction: .set, bit_position: .b0, target_u8: .l" }
    0xC6 { return "instruction: .set, bit_position: .b0, target_u16: .hl" }
    0xC7 { return "instruction: .set, bit_position: .b0, target_u8: .a" }
    0xC8 { return "instruction: .set, bit_position: .b1, target_u8: .b" }
    0xC9 { return "instruction: .set, bit_position: .b1, target_u8: .c" }
    0xCA { return "instruction: .set, bit_position: .b1, target_u8: .d" }
    0xCB { return "instruction: .set, bit_position: .b1, target_u8: .e" }
    0xCC { return "instruction: .set, bit_position: .b1, target_u8: .h" }
    0xCD { return "instruction: .set, bit_position: .b1, target_u8: .l" }
    0xCE { return "instruction: .set, bit_position: .b1, target_u16: .hl" }
    0xCF { return "instruction: .set, bit_position: .b1, target_u8: .a" }

    0xD0 { return "instruction: .set, bit_position: .b2, target_u8: .b" }
    0xD1 { return "instruction: .set, bit_position: .b2, target_u8: .c" }
    0xD2 { return "instruction: .set, bit_position: .b2, target_u8: .d" }
    0xD3 { return "instruction: .set, bit_position: .b2, target_u8: .e" }
    0xD4 { return "instruction: .set, bit_position: .b2, target_u8: .h" }
    0xD5 { return "instruction: .set, bit_position: .b2, target_u8: .l" }
    0xD6 { return "instruction: .set, bit_position: .b2, target_u16: .hl" }
    0xD7 { return "instruction: .set, bit_position: .b2, target_u8: .a" }
    0xD8 { return "instruction: .set, bit_position: .b3, target_u8: .b" }
    0xD9 { return "instruction: .set, bit_position: .b3, target_u8: .c" }
    0xDA { return "instruction: .set, bit_position: .b3, target_u8: .d" }
    0xDB { return "instruction: .set, bit_position: .b3, target_u8: .e" }
    0xDC { return "instruction: .set, bit_position: .b3, target_u8: .h" }
    0xDD { return "instruction: .set, bit_position: .b3, target_u8: .l" }
    0xDE { return "instruction: .set, bit_position: .b3, target_u16: .hl" }
    0xDF { return "instruction: .set, bit_position: .b3, target_u8: .a" }

    0xE0 { return "instruction: .set, bit_position: .b4, target_u8: .b" }
    0xE1 { return "instruction: .set, bit_position: .b4, target_u8: .c" }
    0xE2 { return "instruction: .set, bit_position: .b4, target_u8: .d" }
    0xE3 { return "instruction: .set, bit_position: .b4, target_u8: .e" }
    0xE4 { return "instruction: .set, bit_position: .b4, target_u8: .h" }
    0xE5 { return "instruction: .set, bit_position: .b4, target_u8: .l" }
    0xE6 { return "instruction: .set, bit_position: .b4, target_u16: .hl" }
    0xE7 { return "instruction: .set, bit_position: .b4, target_u8: .a" }
    0xE8 { return "instruction: .set, bit_position: .b5, target_u8: .b" }
    0xE9 { return "instruction: .set, bit_position: .b5, target_u8: .c" }
    0xEA { return "instruction: .set, bit_position: .b5, target_u8: .d" }
    0xEB { return "instruction: .set, bit_position: .b5, target_u8: .e" }
    0xEC { return "instruction: .set, bit_position: .b5, target_u8: .h" }
    0xED { return "instruction: .set, bit_position: .b5, target_u8: .l" }
    0xEE { return "instruction: .set, bit_position: .b5, target_u16: .hl" }
    0xEF { return "instruction: .set, bit_position: .b5, target_u8: .a" }

    0xF0 { return "instruction: .set, bit_position: .b6, target_u8: .b" }
    0xF1 { return "instruction: .set, bit_position: .b6, target_u8: .c" }
    0xF2 { return "instruction: .set, bit_position: .b6, target_u8: .d" }
    0xF3 { return "instruction: .set, bit_position: .b6, target_u8: .e" }
    0xF4 { return "instruction: .set, bit_position: .b6, target_u8: .h" }
    0xF5 { return "instruction: .set, bit_position: .b6, target_u8: .l" }
    0xF6 { return "instruction: .set, bit_position: .b6, target_u16: .hl" }
    0xF7 { return "instruction: .set, bit_position: .b6, target_u8: .a" }
    0xF8 { return "instruction: .set, bit_position: .b7, target_u8: .b" }
    0xF9 { return "instruction: .set, bit_position: .b7, target_u8: .c" }
    0xFA { return "instruction: .set, bit_position: .b7, target_u8: .d" }
    0xFB { return "instruction: .set, bit_position: .b7, target_u8: .e" }
    0xFC { return "instruction: .set, bit_position: .b7, target_u8: .h" }
    0xFD { return "instruction: .set, bit_position: .b7, target_u8: .l" }
    0xFE { return "instruction: .set, bit_position: .b7, target_u16: .hl" }
    0xFF { return "instruction: .set, bit_position: .b7, target_u8: .a" }

    else { panic("Prefixed instruction not found: ${value}") }
  }
}

fn unprefixed_instruction_name(value u8) string {
  match value {
    /* INC instruction */
    0x3c { return "instruction: .inc, target_u8: .a" }
    0x04 { return "instruction: .inc, target_u8: .b" }
    0x0c { return "instruction: .inc, target_u8: .c" }
    0x14 { return "instruction: .inc, target_u8: .d" }
    0x1c { return "instruction: .inc, target_u8: .e" }
    0x24 { return "instruction: .inc, target_u8: .h" }
    0x2c { return "instruction: .inc, target_u8: .l" }
    0x34 { return "instruction: .inc, target_u8: .hli" }
    0x03 { return "instruction: .inc, target_u16: .bc" }
    0x13 { return "instruction: .inc, target_u16: .de" }
    0x23 { return "instruction: .inc, target_u16: .hl" }
    0x33 { return "instruction: .inc, target_u16: .sp" }

    /* DEC instruction */
    0x3d { return "instruction: .dec, target_u8: .a" }
    0x05 { return "instruction: .dec, target_u8: .b" }
    0x0d { return "instruction: .dec, target_u8: .c" }
    0x15 { return "instruction: .dec, target_u8: .d" }
    0x1d { return "instruction: .dec, target_u8: .e" }
    0x25 { return "instruction: .dec, target_u8: .h" }
    0x2d { return "instruction: .dec, target_u8: .l" }
    0x35 { return "instruction: .dec, target_u8: .hli" }
    0x0b { return "instruction: .dec, target_u16: .bc" }
    0x1b { return "instruction: .dec, target_u16: .de" }
    0x2b { return "instruction: .dec, target_u16: .hl" }
    0x3b { return "instruction: .dec, target_u16: .sp" }

    /* ADD instruction */
    0x87 { return "instruction: .add, target_u8: .a" }
    0x80 { return "instruction: .add, target_u8: .b" }
    0x81 { return "instruction: .add, target_u8: .c" }
    0x82 { return "instruction: .add, target_u8: .d" }
    0x83 { return "instruction: .add, target_u8: .e" }
    0x84 { return "instruction: .add, target_u8: .h" }
    0x85 { return "instruction: .add, target_u8: .l" }
    0x86 { return "instruction: .add, target_u8: .hli" }
    0xc6 { return "instruction: .add, target_u8: .d8" }

    /* ADD HL instruction */
    0x09 { return "instruction: .addhl, target_u16: .bc" }
    0x19 { return "instruction: .addhl, target_u16: .de" }
    0x29 { return "instruction: .addhl, target_u16: .hl" }
    0x39 { return "instruction: .addhl, target_u16: .sp" }

    /* ADC instruction */
    0x8f { return "instruction: .adc, target_u8: .a" }
    0x88 { return "instruction: .adc, target_u8: .b" }
    0x89 { return "instruction: .adc, target_u8: .c" }
    0x8a { return "instruction: .adc, target_u8: .d" }
    0x8b { return "instruction: .adc, target_u8: .e" }
    0x8c { return "instruction: .adc, target_u8: .h" }
    0x8d { return "instruction: .adc, target_u8: .l" }
    0x8e { return "instruction: .adc, target_u8: .hli" }
    0xce { return "instruction: .adc, target_u8: .d8" }

    /* SUB instruction */
    0x97 { return "instruction: .sub, target_u8: .a" }
    0x90 { return "instruction: .sub, target_u8: .b" }
    0x91 { return "instruction: .sub, target_u8: .c" }
    0x92 { return "instruction: .sub, target_u8: .d" }
    0x93 { return "instruction: .sub, target_u8: .e" }
    0x94 { return "instruction: .sub, target_u8: .h" }
    0x95 { return "instruction: .sub, target_u8: .l" }
    0x96 { return "instruction: .sub, target_u8: .hli" }
    0xd6 { return "instruction: .sub, target_u8: .d8" }

    /* SBC instruction */
    0x9f { return "instruction: .sbc, target_u8: .a" }
    0x98 { return "instruction: .sbc, target_u8: .b" }
    0x99 { return "instruction: .sbc, target_u8: .c" }
    0x9a { return "instruction: .sbc, target_u8: .d" }
    0x9b { return "instruction: .sbc, target_u8: .e" }
    0x9c { return "instruction: .sbc, target_u8: .h" }
    0x9d { return "instruction: .sbc, target_u8: .l" }
    0x9e { return "instruction: .sbc, target_u8: .hli" }
    0xde { return "instruction: .sbc, target_u8: .d8" }

    /* AND instruction */
    0xa7 { return "instruction: .and, target_u8: .a" }
    0xa0 { return "instruction: .and, target_u8: .b" }
    0xa1 { return "instruction: .and, target_u8: .c" }
    0xa2 { return "instruction: .and, target_u8: .d" }
    0xa3 { return "instruction: .and, target_u8: .e" }
    0xa4 { return "instruction: .and, target_u8: .h" }
    0xa5 { return "instruction: .and, target_u8: .l" }
    0xa6 { return "instruction: .and, target_u8: .hli" }
    0xe6 { return "instruction: .and, target_u8: .d8" }

    /* OR instruction */
    0xb7 { return "instruction: .or_, target_u8: .a" }
    0xb0 { return "instruction: .or_, target_u8: .b" }
    0xb1 { return "instruction: .or_, target_u8: .c" }
    0xb2 { return "instruction: .or_, target_u8: .d" }
    0xb3 { return "instruction: .or_, target_u8: .e" }
    0xb4 { return "instruction: .or_, target_u8: .h" }
    0xb5 { return "instruction: .or_, target_u8: .l" }
    0xb6 { return "instruction: .or_, target_u8: .hli" }
    0xf6 { return "instruction: .or_, target_u8: .d8" }

    /* XOR instruction */
    0xaf { return "instruction: .xor, target_u8: .a" }
    0xa8 { return "instruction: .xor, target_u8: .b" }
    0xa9 { return "instruction: .xor, target_u8: .c" }
    0xaa { return "instruction: .xor, target_u8: .d" }
    0xab { return "instruction: .xor, target_u8: .e" }
    0xac { return "instruction: .xor, target_u8: .h" }
    0xad { return "instruction: .xor, target_u8: .l" }
    0xae { return "instruction: .xor, target_u8: .hli" }
    0xee { return "instruction: .xor, target_u8: .d8" }

    /* CP instruction */
    0xbf { return "instruction: .cp, target_u8: .a" }
    0xb8 { return "instruction: .cp, target_u8: .b" }
    0xb9 { return "instruction: .cp, target_u8: .c" }
    0xba { return "instruction: .cp, target_u8: .d" }
    0xbb { return "instruction: .cp, target_u8: .e" }
    0xbc { return "instruction: .cp, target_u8: .h" }
    0xbd { return "instruction: .cp, target_u8: .l" }
    0xbe { return "instruction: .cp, target_u8: .hli" }
    0xfe { return "instruction: .cp, target_u8: .d8" }

    /* ADDSP instruction */
    0xe8 { return "instruction: .addsp" }

    /* Misc instruction */
    0x3f { return "instruction: .ccf" }
    0x37 { return "instruction: .scf" }
    0x1f { return "instruction: .rra" }
    0x17 { return "instruction: .rla" }
    0x0f { return "instruction: .rrca" }
    0x07 { return "instruction: .rlca" }
    0x2f { return "instruction: .cpl" }

    0x27 { return "instruction: .daa" }

    /* JP instruction */
    0xc3 { return "instruction: .jp, jump_test: .always" }
    0xca { return "instruction: .jp, jump_test: .zero" }
    0xda { return "instruction: .jp, jump_test: .carry" }
    0xc2 { return "instruction: .jp, jump_test: .not_zero" }
    0xd2 { return "instruction: .jp, jump_test: .not_carry" }

    /* JR instruction */
    0x18 { return "instruction: .jr, jump_test: .always" }
    0x28 { return "instruction: .jr, jump_test: .zero" }
    0x38 { return "instruction: .jr, jump_test: .carry" }
    0x20 { return "instruction: .jr, jump_test: .not_zero" }
    0x30 { return "instruction: .jr, jump_test: .not_carry" }

    /* JPI instruction */
    0xe9 { return "instruction: .jpi" }

    /* LD instruction */
    0xf2 { return "instruction: .ld, load_type: .a_from_indirect, indirect: .last_byte_indirect" }
    0x0a { return "instruction: .ld, load_type: .a_from_indirect, indirect: .bc_indirect" }
    0x1a { return "instruction: .ld, load_type: .a_from_indirect, indirect: .de_indirect" }
    0x2a { return "instruction: .ld, load_type: .a_from_indirect, indirect: .hl_indirect_plus" }
    0x3a { return "instruction: .ld, load_type: .a_from_indirect, indirect: .hl_indirect_minus" }
    0xfa { return "instruction: .ld, load_type: .a_from_indirect, indirect: .word_indirect" }

    0xe2 { return "instruction: .ld, load_type: .indirect_from_a, indirect: .last_byte_indirect" }
    0x02 { return "instruction: .ld, load_type: .indirect_from_a, indirect: .bc_indirect" }
    0x12 { return "instruction: .ld, load_type: .indirect_from_a, indirect: .de_indirect" }
    0x22 { return "instruction: .ld, load_type: .indirect_from_a, indirect: .hl_indirect_plus" }
    0x32 { return "instruction: .ld, load_type: .indirect_from_a, indirect: .hl_indirect_minus" }
    0xea { return "instruction: .ld, load_type: .indirect_from_a, indirect: .word_indirect" }

    0x01 { return "instruction: .ld, load_type: .word, word_target: .bc" }
    0x11 { return "instruction: .ld, load_type: .word, word_target: .de" }
    0x21 { return "instruction: .ld, load_type: .word, word_target: .hl" }
    0x31 { return "instruction: .ld, load_type: .word, word_target: .sp" }

    0x40 { return "instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .b" }
    0x41 { return "instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .c" }
    0x42 { return "instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .d" }
    0x43 { return "instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .e" }
    0x44 { return "instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .h" }
    0x45 { return "instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .l" }
    0x46 { return "instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .hli" }
    0x47 { return "instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .a" }

    0x48 { return "instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .b" }
    0x49 { return "instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .c" }
    0x4a { return "instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .d" }
    0x4b { return "instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .e" }
    0x4c { return "instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .h" }
    0x4d { return "instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .l" }
    0x4e { return "instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .hli" }
    0x4f { return "instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .a" }

    0x50 { return "instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .b" }
    0x51 { return "instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .c" }
    0x52 { return "instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .d" }
    0x53 { return "instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .e" }
    0x54 { return "instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .h" }
    0x55 { return "instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .l" }
    0x56 { return "instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .hli" }
    0x57 { return "instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .a" }

    0x58 { return "instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .b" }
    0x59 { return "instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .c" }
    0x5a { return "instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .d" }
    0x5b { return "instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .e" }
    0x5c { return "instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .h" }
    0x5d { return "instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .l" }
    0x5e { return "instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .hli" }
    0x5f { return "instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .a" }

    0x60 { return "instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .b" }
    0x61 { return "instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .c" }
    0x62 { return "instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .d" }
    0x63 { return "instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .e" }
    0x64 { return "instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .h" }
    0x65 { return "instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .l" }
    0x66 { return "instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .hli" }
    0x67 { return "instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .a" }

    0x68 { return "instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .b" }
    0x69 { return "instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .c" }
    0x6a { return "instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .d" }
    0x6b { return "instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .e" }
    0x6c { return "instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .h" }
    0x6d { return "instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .l" }
    0x6e { return "instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .hli" }
    0x6f { return "instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .a" }

    0x70 { return "instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .b" }
    0x71 { return "instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .c" }
    0x72 { return "instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .d" }
    0x73 { return "instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .e" }
    0x74 { return "instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .h" }
    0x75 { return "instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .l" }
    0x77 { return "instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .a" }

    0x78 { return "instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .b" }
    0x79 { return "instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .c" }
    0x7a { return "instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .d" }
    0x7b { return "instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .e" }
    0x7c { return "instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .h" }
    0x7d { return "instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .l" }
    0x7e { return "instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .hli" }
    0x7f { return "instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .a" }

    0x3e { return "instruction: .ld, load_type: .byte, byte_target: .a, byte_source: .d8" }
    0x06 { return "instruction: .ld, load_type: .byte, byte_target: .b, byte_source: .d8" }
    0x0e { return "instruction: .ld, load_type: .byte, byte_target: .c, byte_source: .d8" }
    0x16 { return "instruction: .ld, load_type: .byte, byte_target: .d, byte_source: .d8" }
    0x1e { return "instruction: .ld, load_type: .byte, byte_target: .e, byte_source: .d8" }
    0x26 { return "instruction: .ld, load_type: .byte, byte_target: .h, byte_source: .d8" }
    0x2e { return "instruction: .ld, load_type: .byte, byte_target: .l, byte_source: .d8" }
    0x36 { return "instruction: .ld, load_type: .byte, byte_target: .hli, byte_source: .d8" }

    0xe0 { return "instruction: .ld, load_type: .byte_address_from_a" }
    0xf0 { return "instruction: .ld, load_type: .a_from_byte_address" }

    0x08 { return "instruction: .ld, load_type: .indirect_from_sp" }
    0xf9 { return "instruction: .ld, load_type: .sp_from_hl" }
    0xf8 { return "instruction: .ld, load_type: .hl_from_spn" }

    /* PUSH instruction */
    0xc5 { return "instruction: .push, stack_target: .bc" }
    0xd5 { return "instruction: .push, stack_target: .de" }
    0xe5 { return "instruction: .push, stack_target: .hl" }
    0xf5 { return "instruction: .push, stack_target: .af" }

    /* POP instruction */
    0xc1 { return "instruction: .pop, stack_target: .bc" }
    0xd1 { return "instruction: .pop, stack_target: .de" }
    0xe1 { return "instruction: .pop, stack_target: .hl" }
    0xf1 { return "instruction: .pop, stack_target: .af" }

    /* CALL instruction */
    0xc4 { return "instruction: .call, jump_test: .not_zero" }
    0xd4 { return "instruction: .call, jump_test: .not_carry" }
    0xcc { return "instruction: .call, jump_test: .zero" }
    0xdc { return "instruction: .call, jump_test: .carry" }
    0xcd { return "instruction: .call, jump_test: .always" }

    /* RET instruction */
    0xc0 { return "instruction: .ret, jump_test: .not_zero" }
    0xd0 { return "instruction: .ret, jump_test: .not_carry" }
    0xc8 { return "instruction: .ret, jump_test: .zero" }
    0xd8 { return "instruction: .ret, jump_test: .carry" }
    0xc9 { return "instruction: .ret, jump_test: .always" }
    0xd9 { return "instruction: .reti" }

    /* RST instruction */
    0xc7 { return "instruction: .rst, rst_location: .x00" }
    0xd7 { return "instruction: .rst, rst_location: .x10" }
    0xe7 { return "instruction: .rst, rst_location: .x20" }
    0xf7 { return "instruction: .rst, rst_location: .x30" }
    0xcf { return "instruction: .rst, rst_location: .x08" }
    0xdf { return "instruction: .rst, rst_location: .x18" }
    0xef { return "instruction: .rst, rst_location: .x28" }
    0xff { return "instruction: .rst, rst_location: .x38" }

    /* MISC instruction */
    0x00 { return "instruction: .nop" }
    0x76 { return "instruction: .halt" }
    0xf3 { return "instruction: .di" }
    0xfb { return "instruction: .ei" }

    else { panic("Unprefixed instruction name not found: ${value}") }
  }
}
