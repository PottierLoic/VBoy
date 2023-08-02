struct Timer {
mut:
	div  u16
	tima u8
	tma  u8
	tac  u8
}

fn (mut timer Timer) timer_init() {
	timer.div = 0xAC00
}

fn (mut timer Timer) timer_tick() {
	// TODO: implement timer
}

// TODO: Check if return type u16 is good
fn (mut timer Timer) timer_read(address u16) u16 {
	return match address {
		0xFF04 { timer.div >> 8 }
		0xFF05 { timer.tima }
		0xFF06 { timer.tma }
		0xFF07 { timer.tac }
		else { panic('Unsupported timer read: ${address}') }
	}
}

fn (mut timer Timer) timer_write(address u16, value u8) {
	match address {
		0xFF04 { timer.div = 0 }
		0xFF05 { timer.tima = value }
		0xFF06 { timer.tma = value }
		0xFF07 { timer.tac = value }
		else { panic('Unsupported timer write: ${address} | ${value}') }
	}
}
