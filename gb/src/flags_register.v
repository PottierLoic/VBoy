const (
	zero_flag_byte_position = 7
	substract_flag_byte_position = 6
	half_carry_flag_byte_position = 5
	carry_flag_byte_position = 4
)

struct FlagsRegister {
	zero bool
	subtract bool
	half_carry bool
	carry bool
}

fn flag_to_u8 (reg FlagsRegister) u8 {
	return u8((if reg.zero == true { 1 } else { 0 }) << zero_flag_byte_position |
			  (if reg.subtract == true { 1 } else { 0 }) << substract_flag_byte_position |
			  (if reg.half_carry == true { 1 } else { 0 }) << half_carry_flag_byte_position |
			  (if reg.carry == true { 1 } else { 0 }) << carry_flag_byte_position)
} 

fn u8_to_flag (val u8) FlagsRegister {
	zero := ((val >> zero_flag_byte_position) & 0b1) != 0
	subtract := ((val >> substract_flag_byte_position) & 0b1) != 0
	half_carry := ((val >> half_carry_flag_byte_position) & 0b1) != 0
    carry := ((val >> carry_flag_byte_position) & 0b1) != 0

	return FlagsRegister{
		zero: zero
		subtract: subtract
		half_carry: half_carry
		carry: carry
	}
}