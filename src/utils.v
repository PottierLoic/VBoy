/* used for debug, print all digits of u8 number */
fn print_u8_b2(nb u8) {
	for i in 0..8 {
		print(nb >> i & 1)
	}
}

/* Add value to the target and handle overflow */
fn overflowing_add (target u8, value u8) (u8, bool){
  mut new_value := u16(target) + u16(value)
  new_value = new_value >> 8
  return u8(target + value), new_value > 0
}

/* Substract value to the target and handle underflow */
fn underflowing_subtract (target u8, value u8) (u8, bool){
  mut new_value := u16(target) - u16(value)
  new_value = new_value >> 8
  return u8(target - value), new_value > 0
}