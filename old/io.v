module vboy

// TODO:Maybe remove this quite useless struct
pub struct Io {
pub mut:
	vb   &VBoy = unsafe { nil }
	data [2]u8 // Supposed to be a char, will change later
}

pub fn (io Io) read_io(address u16) u8 {
	return match address {
		0xFF00 {
			// TODO: Gamepad
			0
		}
		0xFF01 {
			// Serial transfer data
			io.data[0]
		}
		0xFF02 {
			// Serial transfer control
			io.data[1]
		}
		0xFF04 {
			io.vb.timer.div >> 8
		}
		0xFF05 {
			io.vb.timer.tima
		}
		0xFF06 {
			io.vb.timer.tma
		}
		0xFF07 {
			io.vb.timer.tac
		}
		0xFF0F {
			io.vb.cpu.get_interruption_flags()
		}
		0xFF10...0xFF3F {
			// TODO: Sound
			0
		}
		0xFF40...0xFF4B {
			io.vb.lcd.read(address)
		}
		else {
			panic('Unsupported bus read: ${address}')
		}
	}
}

pub fn (mut io Io) write_io(address u16, value u8) {
	match address {
		0xFF00 {
			// TODO: Gamepad
		}
		0xFF01 {
			// Serial transfer data
			io.data[0] = value
		}
		0xFF02 {
			// Serial transfer control
			io.data[1] = value
		}
		0xFF04 {
			io.vb.timer.div = 0
		}
		0xFF05 {
			io.vb.timer.tima = value
		}
		0xFF06 {
			io.vb.timer.tma = value
		}
		0xFF07 {
			io.vb.timer.tac = value
		}
		0xFF0F {
			io.vb.cpu.set_interruption_flags(value)
		}
		0xFF10...0xFF3F {
			// Ignore sounds
		}
		0xFF40...0xFF4B {
			io.vb.lcd.write(address, value)
		}
		else {
			panic('Unsupported bus write: ${address} | ${value}')
		}
	}
}
