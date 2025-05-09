module main

pub struct Timer {
pub mut:
	emu  &Emulator = unsafe { nil }
	div  u16
	tima u8
	tma  u8
	tac  u8
}

pub fn (mut timer Timer) init() {
	timer.div = 0xAC00
}

pub fn (mut timer Timer) tick() {
	// TODO: implement timer
	last_div := timer.div
	timer.div++
	mut update := false
	match timer.tac & 0x03 {
		0x00 {
			update = ((last_div & 0b1000000000) >> 9) == 1 && ((timer.div & 0b1000000000) >> 9) == 1
		}
		0x01 {
			update = ((last_div & 0b1000) >> 3) == 1 && ((timer.div & 0b1000) >> 3) == 1
		}
		0x02 {
			update = ((last_div & 0b100000) >> 5) == 1 && ((timer.div & 0b100000) >> 5) == 1
		}
		0x03 {
			update = ((last_div & 0b10000000) >> 7) == 1 && ((timer.div & 0b10000000) >> 7) == 1
		}
		else {}
	}

	if update && (timer.tac & 0b100) == 0b100 {
		timer.tima++

		if timer.tima == 0xFF {
			timer.tima = timer.tma
			timer.emu.cpu.request_interrupt(.it_timer)
		}
	}
}

pub fn (mut timer Timer) read(address u16) u8 {
	return match address {
		0xFF04 { u8(timer.div >> 8) }
		0xFF05 { timer.tima }
		0xFF06 { timer.tma }
		0xFF07 { timer.tac }
		else { panic('Unsupported timer read: ${address}') }
	}
}

pub fn (mut timer Timer) write(address u16, value u8) {
	match address {
		0xFF04 { timer.div = 0 }
		0xFF05 { timer.tima = value }
		0xFF06 { timer.tma = value }
		0xFF07 { timer.tac = value }
		else { panic('Unsupported timer write: ${address} | ${value}') }
	}
}
