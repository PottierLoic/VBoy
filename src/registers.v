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
  return u16(reg.a) << 8 | u16(reg.f)
}

pub fn (reg Registers) get_bc() u16 {
  return u16(reg.b) << 8 | u16(reg.c)
}

pub fn (reg Registers) get_de() u16 {
  return u16(reg.d) << 8 | u16(reg.e)
}

pub fn (reg Registers) get_hl() u16 {
  return u16(reg.h) << 8 | u16(reg.l)
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

pub fn (reg Registers) target_to_reg8(target RegisterU8) u8 {
  return match target {
    .a { reg.a }
    .f { reg.f }
    .b { reg.b }
    .c { reg.c }
    .d { reg.d }
    .e { reg.e }
    .h { reg.h }
    .l { reg.l }
    else { panic('missing a case in target_to_reg8: ${target}') }
  }
}

pub fn (reg Registers) target_to_reg16(target RegisterU16) u16 {
  return match target {
    .af { reg.get_af() }
    .bc { reg.get_bc() }
    .de { reg.get_de() }
    .hl { reg.get_hl() }
    else { panic('missing a case in target_to_reg16: ${target}') }
  }
}

pub fn bit_set(nb u8, idx u8, value bool) u8 {
	return if value { nb |  1 << idx } else { nb & ~(1 << idx) }
}

pub fn bit(nb u8, idx u8) bool {
  return if nb >> idx & 1 == 1 { true } else { false }
}

pub fn (reg Registers) print () {
  println("----------------------")
  print("| a | ") print_full_b2(reg.a) print(" | ") print("${reg.a.hex()} ") println(" |")
  print("| b | ") print_full_b2(reg.b) print(" | ") print("${reg.b.hex()} ") println(" |")
  print("| c | ") print_full_b2(reg.c) print(" | ") print("${reg.c.hex()} ") println(" |")
  print("| d | ") print_full_b2(reg.d) print(" | ") print("${reg.d.hex()} ") println(" |")
  print("| e | ") print_full_b2(reg.e) print(" | ") print("${reg.e.hex()} ") println(" |")
  print("| f | ") print_full_b2(reg.f) print(" | ") print("${reg.f.hex()} ") println(" |")
  print("| h | ") print_full_b2(reg.h) print(" | ") print("${reg.h.hex()} ") println(" |")
  print("| l | ") print_full_b2(reg.l) print(" | ") print("${reg.l.hex()} ") println(" |")
  println("----------------------")
  print("| zero       | ${bit(reg.f, zero_flag_byte_position)} ") if bit(reg.f, zero_flag_byte_position) { print(" ")} println("|")
  print("| subtract   | ${bit(reg.f, subtract_flag_byte_position)} ") if bit(reg.f, subtract_flag_byte_position) { print(" ")} println("|")
  print("| half-carry | ${bit(reg.f, half_carry_flag_byte_position)} ") if bit(reg.f, half_carry_flag_byte_position) { print(" ")} println("|")
  print("| carry      | ${bit(reg.f, carry_flag_byte_position)} ") if bit(reg.f, carry_flag_byte_position) { print(" ")} println("|")
  println("----------------------")
  println("| PC | ${reg.pc}")
  println("| SP | ${reg.sp}")
  println("----------------------")
}

pub fn print_full_b2(nb u8) {
  for i in 0 .. 8 {
    print(nb >> (7 - i) & 1)
  }
}