module vboy

/* Choose the correct method to get instruction name */
pub fn instruction_name_from_byte(value u8, prefixed bool) string {
  if prefixed { return prefixed_instruction_name(value) }
  else { return unprefixed_instruction_name(value) }
}

pub fn prefixed_instruction_name(value u8) string {
  match value {
    /* RLC instruction */
    0x00 { return "rlc, b" }
    0x01 { return "rlc, c" }
    0x02 { return "rlc, d" }
    0x03 { return "rlc, e" }
    0x04 { return "rlc, h" }
    0x05 { return "rlc, l" }
    0x06 { return "rlc, hl" }
    0x07 { return "rlc, a" }

    /* RRC instruction */
    0x08 { return "rrc, b" }
    0x09 { return "rrc, c" }
    0x0A { return "rrc, d" }
    0x0B { return "rrc, e" }
    0x0C { return "rrc, h" }
    0x0D { return "rrc, l" }
    0x0E { return "rrc, hl" }
    0x0F { return "rrc, a" }

    /* RL instruction */
    0x10 { return "rl, b" }
    0x11 { return "rl, c" }
    0x12 { return "rl, d" }
    0x13 { return "rl, e" }
    0x14 { return "rl, h" }
    0x15 { return "rl, l" }
    0x16 { return "rl, hl" }
    0x17 { return "rl, a" }

    /* RR instruction */
    0x18 { return "rr, b" }
    0x19 { return "rr, c" }
    0x1A { return "rr, d" }
    0x1B { return "rr, e" }
    0x1C { return "rr, h" }
    0x1D { return "rr, l" }
    0x1E { return "rr, hl" }
    0x1F { return "rr, a" }

    /* SLA instruction */
    0x20 { return "sla, b" }
    0x21 { return "sla, c" }
    0x22 { return "sla, d" }
    0x23 { return "sla, e" }
    0x24 { return "sla, h" }
    0x25 { return "sla, l" }
    0x26 { return "sla, hl" }
    0x27 { return "sla, a" }

    /* SRA instruction */
    0x28 { return "sra, b" }
    0x29 { return "sra, c" }
    0x2A { return "sra, d" }
    0x2B { return "sra, e" }
    0x2C { return "sra, h" }
    0x2D { return "sra, l" }
    0x2E { return "sra, hl" }
    0x2F { return "sra, a" }

    /* SWAP instruction */
    0x30 { return "swap, b" }
    0x31 { return "swap, c" }
    0x32 { return "swap, d" }
    0x33 { return "swap, e" }
    0x34 { return "swap, h" }
    0x35 { return "swap, l" }
    0x36 { return "swap, hl" }
    0x37 { return "swap, a" }

    /* SRL instruction */
    0x38 { return "srl, b" }
    0x39 { return "srl, c" }
    0x3A { return "srl, d" }
    0x3B { return "srl, e" }
    0x3C { return "srl, h" }
    0x3D { return "srl, l" }
    0x3E { return "srl, hl" }
    0x3F { return "srl, a" }

    /* BIT instruction */
    0x40 { return "bit, b0, b" }
    0x41 { return "bit, b0, c" }
    0x42 { return "bit, b0, d" }
    0x43 { return "bit, b0, e" }
    0x44 { return "bit, b0, h" }
    0x45 { return "bit, b0, l" }
    0x46 { return "bit, b0, hl" }
    0x47 { return "bit, b0, a" }
    0x48 { return "bit, b1, b" }
    0x49 { return "bit, b1, c" }
    0x4A { return "bit, b1, d" }
    0x4B { return "bit, b1, e" }
    0x4C { return "bit, b1, h" }
    0x4D { return "bit, b1, l" }
    0x4E { return "bit, b1, hl" }
    0x4F { return "bit, b1, a" }

    0x50 { return "bit, b2, b" }
    0x51 { return "bit, b2, c" }
    0x52 { return "bit, b2, d" }
    0x53 { return "bit, b2, e" }
    0x54 { return "bit, b2, h" }
    0x55 { return "bit, b2, l" }
    0x56 { return "bit, b2, hl" }
    0x57 { return "bit, b2, a" }
    0x58 { return "bit, b3, b" }
    0x59 { return "bit, b3, c" }
    0x5A { return "bit, b3, d" }
    0x5B { return "bit, b3, e" }
    0x5C { return "bit, b3, h" }
    0x5D { return "bit, b3, l" }
    0x5E { return "bit, b3, hl" }
    0x5F { return "bit, b3, a" }

    0x60 { return "bit, b4, b" }
    0x61 { return "bit, b4, c" }
    0x62 { return "bit, b4, d" }
    0x63 { return "bit, b4, e" }
    0x64 { return "bit, b4, h" }
    0x65 { return "bit, b4, l" }
    0x66 { return "bit, b4, hl" }
    0x67 { return "bit, b4, a" }
    0x68 { return "bit, b5, b" }
    0x69 { return "bit, b5, c" }
    0x6A { return "bit, b5, d" }
    0x6B { return "bit, b5, e" }
    0x6C { return "bit, b5, h" }
    0x6D { return "bit, b5, l" }
    0x6E { return "bit, b5, hl" }
    0x6F { return "bit, b5, a" }

    0x70 { return "bit, b6, b" }
    0x71 { return "bit, b6, c" }
    0x72 { return "bit, b6, d" }
    0x73 { return "bit, b6, e" }
    0x74 { return "bit, b6, h" }
    0x75 { return "bit, b6, l" }
    0x76 { return "bit, b6, hl" }
    0x77 { return "bit, b6, a" }
    0x78 { return "bit, b7, b" }
    0x79 { return "bit, b7, c" }
    0x7A { return "bit, b7, d" }
    0x7B { return "bit, b7, e" }
    0x7C { return "bit, b7, h" }
    0x7D { return "bit, b7, l" }
    0x7E { return "bit, b7, hl" }
    0x7F { return "bit, b7, a" }

    /* RES instruction */
    0x80 { return "res, b0, b" }
    0x81 { return "res, b0, c" }
    0x82 { return "res, b0, d" }
    0x83 { return "res, b0, e" }
    0x84 { return "res, b0, h" }
    0x85 { return "res, b0, l" }
    0x86 { return "res, b0, hl" }
    0x87 { return "res, b0, a" }
    0x88 { return "res, b1, b" }
    0x89 { return "res, b1, c" }
    0x8A { return "res, b1, d" }
    0x8B { return "res, b1, e" }
    0x8C { return "res, b1, h" }
    0x8D { return "res, b1, l" }
    0x8E { return "res, b1, hl" }
    0x8F { return "res, b1, a" }

    0x90 { return "res, b2, b" }
    0x91 { return "res, b2, c" }
    0x92 { return "res, b2, d" }
    0x93 { return "res, b2, e" }
    0x94 { return "res, b2, h" }
    0x95 { return "res, b2, l" }
    0x96 { return "res, b2, hl" }
    0x97 { return "res, b2, a" }
    0x98 { return "res, b3, b" }
    0x99 { return "res, b3, c" }
    0x9A { return "res, b3, d" }
    0x9B { return "res, b3, e" }
    0x9C { return "res, b3, h" }
    0x9D { return "res, b3, l" }
    0x9E { return "res, b3, hl" }
    0x9F { return "res, b3, a" }

    0xA0 { return "res, b4, b" }
    0xA1 { return "res, b4, c" }
    0xA2 { return "res, b4, d" }
    0xA3 { return "res, b4, e" }
    0xA4 { return "res, b4, h" }
    0xA5 { return "res, b4, l" }
    0xA6 { return "res, b4, hl" }
    0xA7 { return "res, b4, a" }
    0xA8 { return "res, b5, b" }
    0xA9 { return "res, b5, c" }
    0xAA { return "res, b5, d" }
    0xAB { return "res, b5, e" }
    0xAC { return "res, b5, h" }
    0xAD { return "res, b5, l" }
    0xAE { return "res, b5, hl" }
    0xAF { return "res, b5, a" }

    0xB0 { return "res, b6, b" }
    0xB1 { return "res, b6, c" }
    0xB2 { return "res, b6, d" }
    0xB3 { return "res, b6, e" }
    0xB4 { return "res, b6, h" }
    0xB5 { return "res, b6, l" }
    0xB6 { return "res, b6, hl" }
    0xB7 { return "res, b6, a" }
    0xB8 { return "res, b7, b" }
    0xB9 { return "res, b7, c" }
    0xBA { return "res, b7, d" }
    0xBB { return "res, b7, e" }
    0xBC { return "res, b7, h" }
    0xBD { return "res, b7, l" }
    0xBE { return "res, b7, hl" }
    0xBF { return "res, b7, a" }

    /* SET instruction */
    0xC0 { return "set, b0, b" }
    0xC1 { return "set, b0, c" }
    0xC2 { return "set, b0, d" }
    0xC3 { return "set, b0, e" }
    0xC4 { return "set, b0, h" }
    0xC5 { return "set, b0, l" }
    0xC6 { return "set, b0, hl" }
    0xC7 { return "set, b0, a" }
    0xC8 { return "set, b1, b" }
    0xC9 { return "set, b1, c" }
    0xCA { return "set, b1, d" }
    0xCB { return "set, b1, e" }
    0xCC { return "set, b1, h" }
    0xCD { return "set, b1, l" }
    0xCE { return "set, b1, hl" }
    0xCF { return "set, b1, a" }

    0xD0 { return "set, b2, b" }
    0xD1 { return "set, b2, c" }
    0xD2 { return "set, b2, d" }
    0xD3 { return "set, b2, e" }
    0xD4 { return "set, b2, h" }
    0xD5 { return "set, b2, l" }
    0xD6 { return "set, b2, hl" }
    0xD7 { return "set, b2, a" }
    0xD8 { return "set, b3, b" }
    0xD9 { return "set, b3, c" }
    0xDA { return "set, b3, d" }
    0xDB { return "set, b3, e" }
    0xDC { return "set, b3, h" }
    0xDD { return "set, b3, l" }
    0xDE { return "set, b3, hl" }
    0xDF { return "set, b3, a" }

    0xE0 { return "set, b4, b" }
    0xE1 { return "set, b4, c" }
    0xE2 { return "set, b4, d" }
    0xE3 { return "set, b4, e" }
    0xE4 { return "set, b4, h" }
    0xE5 { return "set, b4, l" }
    0xE6 { return "set, b4, hl" }
    0xE7 { return "set, b4, a" }
    0xE8 { return "set, b5, b" }
    0xE9 { return "set, b5, c" }
    0xEA { return "set, b5, d" }
    0xEB { return "set, b5, e" }
    0xEC { return "set, b5, h" }
    0xED { return "set, b5, l" }
    0xEE { return "set, b5, hl" }
    0xEF { return "set, b5, a" }

    0xF0 { return "set, b6, b" }
    0xF1 { return "set, b6, c" }
    0xF2 { return "set, b6, d" }
    0xF3 { return "set, b6, e" }
    0xF4 { return "set, b6, h" }
    0xF5 { return "set, b6, l" }
    0xF6 { return "set, b6, hl" }
    0xF7 { return "set, b6, a" }
    0xF8 { return "set, b7, b" }
    0xF9 { return "set, b7, c" }
    0xFA { return "set, b7, d" }
    0xFB { return "set, b7, e" }
    0xFC { return "set, b7, h" }
    0xFD { return "set, b7, l" }
    0xFE { return "set, b7, hl" }
    0xFF { return "set, b7, a" }

    else { panic("Prefixed instruction not found: ${value}") }
  }
}

pub fn unprefixed_instruction_name(value u8) string {
  match value {
    /* INC instruction */
    0x3c { return "inc, a" }
    0x04 { return "inc, b" }
    0x0c { return "inc, c" }
    0x14 { return "inc, d" }
    0x1c { return "inc, e" }
    0x24 { return "inc, h" }
    0x2c { return "inc, l" }
    0x34 { return "inc, hli" }
    0x03 { return "inc, bc" }
    0x13 { return "inc, de" }
    0x23 { return "inc, hl" }
    0x33 { return "inc, sp" }

    /* DEC instruction */
    0x3d { return "dec, a" }
    0x05 { return "dec, b" }
    0x0d { return "dec, c" }
    0x15 { return "dec, d" }
    0x1d { return "dec, e" }
    0x25 { return "dec, h" }
    0x2d { return "dec, l" }
    0x35 { return "dec, hli" }
    0x0b { return "dec, bc" }
    0x1b { return "dec, de" }
    0x2b { return "dec, hl" }
    0x3b { return "dec, sp" }

    /* ADD instruction */
    0x87 { return "add, a" }
    0x80 { return "add, b" }
    0x81 { return "add, c" }
    0x82 { return "add, d" }
    0x83 { return "add, e" }
    0x84 { return "add, h" }
    0x85 { return "add, l" }
    0x86 { return "add, hli" }
    0xc6 { return "add, d8" }

    /* ADD HL instruction */
    0x09 { return "addhl, bc" }
    0x19 { return "addhl, de" }
    0x29 { return "addhl, hl" }
    0x39 { return "addhl, sp" }

    /* ADC instruction */
    0x8f { return "adc, a" }
    0x88 { return "adc, b" }
    0x89 { return "adc, c" }
    0x8a { return "adc, d" }
    0x8b { return "adc, e" }
    0x8c { return "adc, h" }
    0x8d { return "adc, l" }
    0x8e { return "adc, hli" }
    0xce { return "adc, d8" }

    /* SUB instruction */
    0x97 { return "sub, a" }
    0x90 { return "sub, b" }
    0x91 { return "sub, c" }
    0x92 { return "sub, d" }
    0x93 { return "sub, e" }
    0x94 { return "sub, h" }
    0x95 { return "sub, l" }
    0x96 { return "sub, hli" }
    0xd6 { return "sub, d8" }

    /* SBC instruction */
    0x9f { return "sbc, a" }
    0x98 { return "sbc, b" }
    0x99 { return "sbc, c" }
    0x9a { return "sbc, d" }
    0x9b { return "sbc, e" }
    0x9c { return "sbc, h" }
    0x9d { return "sbc, l" }
    0x9e { return "sbc, hli" }
    0xde { return "sbc, d8" }

    /* AND instruction */
    0xa7 { return "and, a" }
    0xa0 { return "and, b" }
    0xa1 { return "and, c" }
    0xa2 { return "and, d" }
    0xa3 { return "and, e" }
    0xa4 { return "and, h" }
    0xa5 { return "and, l" }
    0xa6 { return "and, hli" }
    0xe6 { return "and, d8" }

    /* OR instruction */
    0xb7 { return "@or, a" }
    0xb0 { return "@or, b" }
    0xb1 { return "@or, c" }
    0xb2 { return "@or, d" }
    0xb3 { return "@or, e" }
    0xb4 { return "@or, h" }
    0xb5 { return "@or, l" }
    0xb6 { return "@or, hli" }
    0xf6 { return "@or, d8" }

    /* XOR instruction */
    0xaf { return "xor, a" }
    0xa8 { return "xor, b" }
    0xa9 { return "xor, c" }
    0xaa { return "xor, d" }
    0xab { return "xor, e" }
    0xac { return "xor, h" }
    0xad { return "xor, l" }
    0xae { return "xor, hli" }
    0xee { return "xor, d8" }

    /* CP instruction */
    0xbf { return "cp, a" }
    0xb8 { return "cp, b" }
    0xb9 { return "cp, c" }
    0xba { return "cp, d" }
    0xbb { return "cp, e" }
    0xbc { return "cp, h" }
    0xbd { return "cp, l" }
    0xbe { return "cp, hli" }
    0xfe { return "cp, d8" }

    /* ADDSP instruction */
    0xe8 { return "addsp" }

    /* Misc instruction */
    0x3f { return "ccf" }
    0x37 { return "scf" }
    0x1f { return "rra" }
    0x17 { return "rla" }
    0x0f { return "rrca" }
    0x07 { return "rlca" }
    0x2f { return "cpl" }

    0x27 { return "daa" }

    /* JP instruction */
    0xc3 { return "jp, always" }
    0xca { return "jp, zero" }
    0xda { return "jp, carry" }
    0xc2 { return "jp, not_zero" }
    0xd2 { return "jp, not_carry" }

    /* JR instruction */
    0x18 { return "jr, always" }
    0x28 { return "jr, zero" }
    0x38 { return "jr, carry" }
    0x20 { return "jr, not_zero" }
    0x30 { return "jr, not_carry" }

    /* JPI instruction */
    0xe9 { return "jpi" }

    /* LD instruction */
    0xf2 { return "ld, a_from_indirect, indirect: last_byte_indirect" }
    0x0a { return "ld, a_from_indirect, indirect: bc_indirect" }
    0x1a { return "ld, a_from_indirect, indirect: de_indirect" }
    0x2a { return "ld, a_from_indirect, indirect: hl_indirect_plus" }
    0x3a { return "ld, a_from_indirect, indirect: hl_indirect_minus" }
    0xfa { return "ld, a_from_indirect, indirect: word_indirect" }

    0xe2 { return "ld, indirect_from_a, indirect: last_byte_indirect" }
    0x02 { return "ld, indirect_from_a, indirect: bc_indirect" }
    0x12 { return "ld, indirect_from_a, indirect: de_indirect" }
    0x22 { return "ld, indirect_from_a, indirect: hl_indirect_plus" }
    0x32 { return "ld, indirect_from_a, indirect: hl_indirect_minus" }
    0xea { return "ld, indirect_from_a, indirect: word_indirect" }

    0x01 { return "ld, word, word_target: bc" }
    0x11 { return "ld, word, word_target: de" }
    0x21 { return "ld, word, word_target: hl" }
    0x31 { return "ld, word, word_target: sp" }

    0x40 { return "ld, byte, byte_target: b, byte_source: b" }
    0x41 { return "ld, byte, byte_target: b, byte_source: c" }
    0x42 { return "ld, byte, byte_target: b, byte_source: d" }
    0x43 { return "ld, byte, byte_target: b, byte_source: e" }
    0x44 { return "ld, byte, byte_target: b, byte_source: h" }
    0x45 { return "ld, byte, byte_target: b, byte_source: l" }
    0x46 { return "ld, byte, byte_target: b, byte_source: hli" }
    0x47 { return "ld, byte, byte_target: b, byte_source: a" }

    0x48 { return "ld, byte, byte_target: c, byte_source: b" }
    0x49 { return "ld, byte, byte_target: c, byte_source: c" }
    0x4a { return "ld, byte, byte_target: c, byte_source: d" }
    0x4b { return "ld, byte, byte_target: c, byte_source: e" }
    0x4c { return "ld, byte, byte_target: c, byte_source: h" }
    0x4d { return "ld, byte, byte_target: c, byte_source: l" }
    0x4e { return "ld, byte, byte_target: c, byte_source: hli" }
    0x4f { return "ld, byte, byte_target: c, byte_source: a" }

    0x50 { return "ld, byte, byte_target: d, byte_source: b" }
    0x51 { return "ld, byte, byte_target: d, byte_source: c" }
    0x52 { return "ld, byte, byte_target: d, byte_source: d" }
    0x53 { return "ld, byte, byte_target: d, byte_source: e" }
    0x54 { return "ld, byte, byte_target: d, byte_source: h" }
    0x55 { return "ld, byte, byte_target: d, byte_source: l" }
    0x56 { return "ld, byte, byte_target: d, byte_source: hli" }
    0x57 { return "ld, byte, byte_target: d, byte_source: a" }

    0x58 { return "ld, byte, byte_target: e, byte_source: b" }
    0x59 { return "ld, byte, byte_target: e, byte_source: c" }
    0x5a { return "ld, byte, byte_target: e, byte_source: d" }
    0x5b { return "ld, byte, byte_target: e, byte_source: e" }
    0x5c { return "ld, byte, byte_target: e, byte_source: h" }
    0x5d { return "ld, byte, byte_target: e, byte_source: l" }
    0x5e { return "ld, byte, byte_target: e, byte_source: hli" }
    0x5f { return "ld, byte, byte_target: e, byte_source: a" }

    0x60 { return "ld, byte, byte_target: h, byte_source: b" }
    0x61 { return "ld, byte, byte_target: h, byte_source: c" }
    0x62 { return "ld, byte, byte_target: h, byte_source: d" }
    0x63 { return "ld, byte, byte_target: h, byte_source: e" }
    0x64 { return "ld, byte, byte_target: h, byte_source: h" }
    0x65 { return "ld, byte, byte_target: h, byte_source: l" }
    0x66 { return "ld, byte, byte_target: h, byte_source: hli" }
    0x67 { return "ld, byte, byte_target: h, byte_source: a" }

    0x68 { return "ld, byte, byte_target: l, byte_source: b" }
    0x69 { return "ld, byte, byte_target: l, byte_source: c" }
    0x6a { return "ld, byte, byte_target: l, byte_source: d" }
    0x6b { return "ld, byte, byte_target: l, byte_source: e" }
    0x6c { return "ld, byte, byte_target: l, byte_source: h" }
    0x6d { return "ld, byte, byte_target: l, byte_source: l" }
    0x6e { return "ld, byte, byte_target: l, byte_source: hli" }
    0x6f { return "ld, byte, byte_target: l, byte_source: a" }

    0x70 { return "ld, byte, byte_target: hli, byte_source: b" }
    0x71 { return "ld, byte, byte_target: hli, byte_source: c" }
    0x72 { return "ld, byte, byte_target: hli, byte_source: d" }
    0x73 { return "ld, byte, byte_target: hli, byte_source: e" }
    0x74 { return "ld, byte, byte_target: hli, byte_source: h" }
    0x75 { return "ld, byte, byte_target: hli, byte_source: l" }
    0x77 { return "ld, byte, byte_target: hli, byte_source: a" }

    0x78 { return "ld, byte, byte_target: a, byte_source: b" }
    0x79 { return "ld, byte, byte_target: a, byte_source: c" }
    0x7a { return "ld, byte, byte_target: a, byte_source: d" }
    0x7b { return "ld, byte, byte_target: a, byte_source: e" }
    0x7c { return "ld, byte, byte_target: a, byte_source: h" }
    0x7d { return "ld, byte, byte_target: a, byte_source: l" }
    0x7e { return "ld, byte, byte_target: a, byte_source: hli" }
    0x7f { return "ld, byte, byte_target: a, byte_source: a" }

    0x3e { return "ld, byte, byte_target: a, byte_source: d8" }
    0x06 { return "ld, byte, byte_target: b, byte_source: d8" }
    0x0e { return "ld, byte, byte_target: c, byte_source: d8" }
    0x16 { return "ld, byte, byte_target: d, byte_source: d8" }
    0x1e { return "ld, byte, byte_target: e, byte_source: d8" }
    0x26 { return "ld, byte, byte_target: h, byte_source: d8" }
    0x2e { return "ld, byte, byte_target: l, byte_source: d8" }
    0x36 { return "ld, byte, byte_target: hli, byte_source: d8" }

    0xe0 { return "ld, byte_address_from_a" }
    0xf0 { return "ld, a_from_byte_address" }

    0x08 { return "ld, indirect_from_sp" }
    0xf9 { return "ld, sp_from_hl" }
    0xf8 { return "ld, hl_from_spn" }

    /* PUSH instruction */
    0xc5 { return "push, bc" }
    0xd5 { return "push, de" }
    0xe5 { return "push, hl" }
    0xf5 { return "push, af" }

    /* POP instruction */
    0xc1 { return "pop, bc" }
    0xd1 { return "pop, de" }
    0xe1 { return "pop, hl" }
    0xf1 { return "pop, af" }

    /* CALL instruction */
    0xc4 { return "call, not_zero" }
    0xd4 { return "call, not_carry" }
    0xcc { return "call, zero" }
    0xdc { return "call, carry" }
    0xcd { return "call, always" }

    /* RET instruction */
    0xc0 { return "ret, not_zero" }
    0xd0 { return "ret, not_carry" }
    0xc8 { return "ret, zero" }
    0xd8 { return "ret, carry" }
    0xc9 { return "ret, always" }
    0xd9 { return "reti" }

    /* RST instruction */
    0xc7 { return "rst, x00" }
    0xd7 { return "rst, x10" }
    0xe7 { return "rst, x20" }
    0xf7 { return "rst, x30" }
    0xcf { return "rst, x08" }
    0xdf { return "rst, x18" }
    0xef { return "rst, x28" }
    0xff { return "rst, x38" }

    /* MISC instruction */
    0x00 { return "nop" }
    0x76 { return "halt" }
    0xf3 { return "di" }
    0xfb { return "ei" }

    else { panic("Unprefixed instruction name not found: ${value}") }
  }
}
