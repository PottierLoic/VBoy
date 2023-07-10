struct Registers {
mut:
  a u8
  b u8
  c u8
  d u8
  e u8
  f u8
  h u8
  l u8
}

fn (reg Registers) get_af() u16 {
  return u16(reg.a) << 8 | u16(reg.f)
}

fn (reg Registers) get_bc() u16 {
  return u16(reg.b) << 8 | u16(reg.c)
}

fn (reg Registers) get_de() u16 {
  return u16(reg.d) << 8 | u16(reg.e)
}

fn (reg Registers) get_hl() u16 {
  return u16(reg.h) << 8 | u16(reg.l)
}

fn (mut reg Registers) set_af(value u16) {
  reg.a = u8((value & 0xFF00) >> 8)
  reg.f = u8(value & 0xFF)
}

fn (mut reg Registers) set_bc(value u16) {
  reg.b = u8((value & 0xFF00) >> 8)
  reg.c = u8(value & 0xFF)
}

fn (mut reg Registers) set_de(value u16) {
  reg.d = u8((value & 0xFF00) >> 8)
  reg.e = u8(value & 0xFF)
}

fn (mut reg Registers) set_hl(value u16) {
  reg.h = u8((value & 0xFF00) >> 8)
  reg.l = u8(value & 0xFF)
}

/* Add value to the target and handle overflow */
fn (mut reg Registers) overflowing_add (target u8, value u8) (u8, bool){
  mut new_value := u16(target) + u16(value)
  new_value = new_value >> 8
  return u8(target + value), new_value > 0
}

fn (reg Registers) print () {
  flag := u8_to_flag(reg.f)
  println("----------------------")
  print("| a | ") print_full_b2(reg.a) print(" | ") print_full_b10(reg.a) println(" |")
  print("| b | ") print_full_b2(reg.b) print(" | ") print_full_b10(reg.b) println(" |")
  print("| c | ") print_full_b2(reg.c) print(" | ") print_full_b10(reg.c) println(" |")
  print("| d | ") print_full_b2(reg.d) print(" | ") print_full_b10(reg.d) println(" |")
  print("| e | ") print_full_b2(reg.e) print(" | ") print_full_b10(reg.e) println(" |")
  print("| f | ") print_full_b2(reg.f) print(" | ") print_full_b10(reg.f) println(" |")
  print("| h | ") print_full_b2(reg.h) print(" | ") print_full_b10(reg.h) println(" |")
  print("| l | ") print_full_b2(reg.l) print(" | ") print_full_b10(reg.l) println(" |")
  println("----------------------")
  print("| zero       | ${flag.zero} ") if flag.zero { print(" ")} println("|")
  print("| subtract   | ${flag.subtract} ") if flag.subtract { print(" ")} println("|")
  print("| half-carry | ${flag.half_carry} ") if flag.half_carry { print(" ")} println("|")
  print("| carry      | ${flag.carry} ") if flag.carry { print(" ")} println("|")
  println("----------------------")
}

fn print_full_b2 (nb u8) {
	for i in 0 .. 8 {
		print(nb >> (7 - i) & 1)
	}
}

fn print_full_b10 (nb u8) {
  mut tmp := nb
  mut digits := 0
  for tmp != 0 {
    tmp /= 10
    digits++
  }
  for _ in 0 .. 3 - digits - int(nb == 0) { print("0") }
  print(nb)
}