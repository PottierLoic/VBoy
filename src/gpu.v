const object_amount = 40

enum Color {
	white = 255
	light_grey = 192
	dark_grey = 96
	black = 0
}

fn u8_to_color (n u8) Color {
	return match n {
		0 { .white }
		1 { .light_grey }
		2 { .dark_grey }
		3 { .black }
		else { panic("Cannot convert ${n} to color") }
	}
}
