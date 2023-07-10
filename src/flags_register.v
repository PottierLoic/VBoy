const (
  zero_flag_byte_position = 7
  subtract_flag_byte_position = 6
  half_carry_flag_byte_position = 5
  carry_flag_byte_position = 4
)

struct FlagsRegister {
mut:
  zero bool
  subtract bool
  half_carry bool
  carry bool
}

fn flag_to_u8 (reg FlagsRegister) u8 {
  return u8(reg.zero) << zero_flag_byte_position |
         u8(reg.subtract) << subtract_flag_byte_position |
         u8(reg.half_carry)<< half_carry_flag_byte_position |
         u8(reg.carry) << carry_flag_byte_position
}

fn u8_to_flag (val u8) FlagsRegister {
  zero := ((val >> zero_flag_byte_position) & 0b1) != 0
  subtract := ((val >> subtract_flag_byte_position) & 0b1) != 0
  half_carry := ((val >> half_carry_flag_byte_position) & 0b1) != 0
  carry := ((val >> carry_flag_byte_position) & 0b1) != 0

  return FlagsRegister{
    zero: zero
    subtract: subtract
    half_carry: half_carry
    carry: carry
  }
}
