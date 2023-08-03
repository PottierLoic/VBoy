// TODO:Maybe remove this quite useless struct
struct Io {
mut:
	data [2]u8	// Supposed to be a char, will change later
}

fn (io Io) read_io(address u16) u8 {
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
		0xFF04...0xFF07 {
			// TODO: Timer div, tima, tma, tac read
			0
		}
		0xFF0F {
			// TODO: Get cpu interruption flags
			0
		}
		0xFF10...0xFF3F {
			// TODO: Sound
			0
		}
		0xFF40...0xFF4B {
			// TODO: LCD Read
			0
		}
		else {
			panic('Unsupported bus read: ${address}')
		}
	}
}

fn (mut io Io) write_io(address u16, value u8) {
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
		0xFF04...0xFF07 {
			// TODO: Timer div, tima, tma, tac write

		}
		0xFF0F {
			// TODO: Set cpu interruption flags

		}
		0xFF10...0xFF3F {
			// Ignore sounds
		}
		0xFF40...0xFF4B {
			// TODO: LCD Write

		}
		else {
			panic('Unsupported bus write: ${address} | ${value}')
		}
	}
}
