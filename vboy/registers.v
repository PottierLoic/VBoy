module vboy

const (
  zero_flag_byte_position       = 7
  subtract_flag_byte_position   = 6
  half_carry_flag_byte_position = 5
  carry_flag_byte_position      = 4
)

pub struct Registers {
pub mut:
  a u8
  f u8
  b u8
  c u8
  d u8
  e u8
  h u8
  l u8
  pc u16
  sp u16
}

pub fn (reg Registers) get_af() u16 {
  return u16(reg.a) << 8 | reg.f
}

pub fn (reg Registers) get_bc() u16 {
  return u16(reg.b) << 8 | reg.c
}

pub fn (reg Registers) get_de() u16 {
  return u16(reg.d) << 8 | reg.e
}

pub fn (reg Registers) get_hl() u16 {
  return u16(reg.h) << 8 | reg.l
}

pub fn (mut reg Registers) set_af(value u16) {
  reg.a = u8((value & 0xFF00) >> 8)
  reg.f = u8(value & 0xFF)
}

pub fn (mut reg Registers) set_bc(value u16) {
  reg.b = u8((value & 0xFF00) >> 8)
  reg.c = u8(value & 0xFF)
}

pub fn (mut reg Registers) set_de(value u16) {
  reg.d = u8((value & 0xFF00) >> 8)
  reg.e = u8(value & 0xFF)
}

pub fn (mut reg Registers) set_hl(value u16) {
  reg.h = u8((value & 0xFF00) >> 8)
  reg.l = u8(value & 0xFF)
}

pub fn bit_set(nb u8, idx u8, value int) u8 {
	return if value == 1 { nb |  1 << idx } else { nb & ~(1 << idx) }
}

pub fn bit(nb u8, idx u8) u8 {
  return if (nb >> idx) & 1 == 1 { u8(1) } else { u8(0) }
}

pub fn is_16_bit(reg Reg) bool {
  return match reg {
    .reg_af { true }
    .reg_bc { true }
    .reg_de { true }
    .reg_hl { true }
    else { false }
  }
}

pub fn (reg Registers) print () {
  println("----------------------")
  print("| a | ") print_full_b2(reg.a) print(" | ") print("0x${reg.a.hex()}") println("|")
  print("| b | ") print_full_b2(reg.b) print(" | ") print("0x${reg.b.hex()}") println("|")
  print("| c | ") print_full_b2(reg.c) print(" | ") print("0x${reg.c.hex()}") println("|")
  print("| d | ") print_full_b2(reg.d) print(" | ") print("0x${reg.d.hex()}") println("|")
  print("| e | ") print_full_b2(reg.e) print(" | ") print("0x${reg.e.hex()}") println("|")
  print("| f | ") print_full_b2(reg.f) print(" | ") print("0x${reg.f.hex()}") println("|")
  print("| h | ") print_full_b2(reg.h) print(" | ") print("0x${reg.h.hex()}") println("|")
  print("| l | ") print_full_b2(reg.l) print(" | ") print("0x${reg.l.hex()}") println("|")
  println("----------------------")
  print("| zero       | ${bit(reg.f, zero_flag_byte_position)} ") if bit(reg.f, zero_flag_byte_position) == 1 { print(" ")} println("|")
  print("| subtract   | ${bit(reg.f, subtract_flag_byte_position)} ") if bit(reg.f, subtract_flag_byte_position) == 1 { print(" ")} println("|")
  print("| half-carry | ${bit(reg.f, half_carry_flag_byte_position)} ") if bit(reg.f, half_carry_flag_byte_position) == 1 { print(" ")} println("|")
  print("| carry      | ${bit(reg.f, carry_flag_byte_position)} ") if bit(reg.f, carry_flag_byte_position) == 1 { print(" ")} println("|")
  println("----------------------")
  println("| PC | 0x${reg.pc.hex()}")
  println("| SP | 0x${reg.sp.hex()}")
  println("----------------------")
}

pub fn print_full_b2(nb u8) {
  for i in 0 .. 8 {
    print((nb >> (7 - i)) & 1)
  }
}