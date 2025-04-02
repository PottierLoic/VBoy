module main

const zero_flag_byte_position = 7
const subtract_flag_byte_position = 6
const half_carry_flag_byte_position = 5
const carry_flag_byte_position = 4

fn bin(n u8) string {
  mut s := ''
  for i := 7; i >= 0; i-- {
    s += if (n >> u8(i)) & 1 == 1 { '1' } else { '0' }
  }
  return s
}

struct Registers {
mut:
	a  u8
	f  u8
	b  u8
	c  u8
	d  u8
	e  u8
	h  u8
	l  u8
	pc u16
	sp u16
}

fn (reg Registers) get_af() u16 {
	return u16(reg.a) << 8 | reg.f
}

fn (reg Registers) get_bc() u16 {
	return u16(reg.b) << 8 | reg.c
}

fn (reg Registers) get_de() u16 {
	return u16(reg.d) << 8 | reg.e
}

fn (reg Registers) get_hl() u16 {
	return u16(reg.h) << 8 | reg.l
}

fn (mut reg Registers) set_af(value u16) {
	reg.a = u8((value & 0xFF00) >> 8)
	reg.f = u8(value & 0xF0)
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

fn bit_set(nb u8, idx u8, value int) u8 {
	return if value == 1 { nb | 1 << idx } else { nb & ~(1 << idx) }
}

fn bit(nb u8, idx u8) u8 {
	return (nb >> idx) & 1
}

fn (reg Registers) print() {
  println('----------------------')
  println('| A  | ${reg.a.hex()} | ${bin(reg.a)} |')
  println('| B  | ${reg.b.hex()} | ${bin(reg.b)} |')
  println('| C  | ${reg.c.hex()} | ${bin(reg.c)} |')
  println('| D  | ${reg.d.hex()} | ${bin(reg.d)} |')
  println('| E  | ${reg.e.hex()} | ${bin(reg.e)} |')
  println('| F  | ${reg.f.hex()} | ${bin(reg.f)} |')
  println('| H  | ${reg.h.hex()} | ${bin(reg.h)} |')
  println('| L  | ${reg.l.hex()} | ${bin(reg.l)} |')
  println('----------------------')
  println('| AF | 0x${reg.get_af():04x} |')
  println('| BC | 0x${reg.get_bc():04x} |')
  println('| DE | 0x${reg.get_de():04x} |')
  println('| HL | 0x${reg.get_hl():04x} |')
  println('----------------------')

  zero_flag := bit(reg.f, zero_flag_byte_position)
  subtract_flag := bit(reg.f, subtract_flag_byte_position)
  half_carry_flag := bit(reg.f, half_carry_flag_byte_position)
  carry_flag := bit(reg.f, carry_flag_byte_position)

  println('| Zero      | $zero_flag |')
  println('| Subtract  | $subtract_flag |')
  println('| HalfCarry | $half_carry_flag |')
  println('| Carry     | $carry_flag |')
  println('----------------------')

  println('| PC | 0x${reg.pc.hex()} |')
  println('| SP | 0x${reg.sp.hex()} |')
  println('----------------------')
}

