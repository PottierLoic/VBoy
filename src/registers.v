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
  reg.h = u8(value & 0xFF)
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

fn (mut reg Registers) overflowing_add (r string, value u8) (u8, bool){
  mut target := 0
  match r {
    'a' {target = reg.a}
    'b' {target = reg.b}
    'c' {target = reg.c}
    'd' {target = reg.d}
    'e' {target = reg.e}
    'f' {target = reg.f}
    'h' {target = reg.h}
    'l' {target = reg.l}
    else {target = reg.a}
  }
  mut new_value := u16(target) + u16(value)
  new_value = new_value >> 8
  return u8(target + value), new_value > 0
}

fn (reg Registers) print_binary () {
  println("a : ${reg.a:b}")
  println("b : ${reg.b:b}")
  println("c : ${reg.c:b}")
  println("d : ${reg.d:b}")
  println("e : ${reg.e:b}")
  println("f : ${reg.f:b}")
  println("h : ${reg.h:b}")
  println("l : ${reg.l:b}")
}

fn (reg Registers) print_decimal () {
  println("a : ${reg.a}")
  println("b : ${reg.b}")
  println("c : ${reg.c}")
  println("d : ${reg.d}")
  println("e : ${reg.e}")
  println("f : ${reg.f}")
  println("h : ${reg.h}")
  println("l : ${reg.l}")
}
