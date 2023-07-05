fn print_u8_b2(nb u8) {
	for i in 0..8 {
		print(nb >> i & 1)
	}
}