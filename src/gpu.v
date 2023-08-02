const object_amount = 40

enum Color {
	white = 255
	light_grey = 192
	dark_grey = 96
	black = 0
}

fn u8_to_color(n u8) Color {
	return match n {
		0 { .white }
		1 { .light_grey }
		2 { .dark_grey }
		3 { .black }
		else { panic('Cannot convert ${n} to color') }
	}
}

struct BackgroundColor {
	color0 Color
	color1 Color
	color2 Color
	color3 Color
}

fn new_backgound_color() BackgroundColor {
	return BackgroundColor{.white, .light_grey, .dark_grey, .black}
}

fn u8_to_background_color(value u8) BackgroundColor {
	return BackgroundColor{u8_to_color(value & 0b11), u8_to_color((value >> 2) & 0b11), u8_to_color((value >> 4) & 0b11), u8_to_color(value >> 6)}
}
