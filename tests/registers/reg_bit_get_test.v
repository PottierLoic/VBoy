module main

import vboy

pub fn test_bit_get() {
	nb := u8(0b10010110)

	assert vboy.bit(nb, 0) == 0
	assert vboy.bit(nb, 1) == 1
	assert vboy.bit(nb, 2) == 1
	assert vboy.bit(nb, 3) == 0
	assert vboy.bit(nb, 4) == 1
	assert vboy.bit(nb, 5) == 0
	assert vboy.bit(nb, 6) == 0
	assert vboy.bit(nb, 7) == 1
}
