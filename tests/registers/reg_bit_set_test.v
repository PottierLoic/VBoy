module main

import vboy

pub fn test_bit_set() {
	mut nb := u8(0)

	nb = vboy.bit_set(nb, 0, 1)
	nb = vboy.bit_set(nb, 1, 1)
	nb = vboy.bit_set(nb, 2, 1)
	nb = vboy.bit_set(nb, 3, 1)
	nb = vboy.bit_set(nb, 4, 1)
	nb = vboy.bit_set(nb, 5, 1)
	nb = vboy.bit_set(nb, 6, 1)
	nb = vboy.bit_set(nb, 7, 1)

	assert nb == 0b11111111
}
