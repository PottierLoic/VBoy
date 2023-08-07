enum Interruption_types {
  it_vblanks = 0b1
	it_lcd_stat = 0b10
	it_timer = 0b100
	it_serial = 0b1000
	it_joypad = 0b10000
}

fn (mut cpu Cpu) interrupt(address u16, interrupt Interruption_types) bool {
	return if (cpu.interruption_flags & 0b1) == u8(interrupt) && (cpu.ie_register & 0b1) == u8(interrupt) {
		cpu.push_u16(cpu.pc)
		cpu.pc = address
		cpu.interruption_flags &= ~u8(interrupt)
		cpu.halted = false
		// int master enabled ?
		true
	} else { false }

}

fn (mut cpu Cpu) handle_interrupts() {
	// Finding a way to loop on enum remove necessity for this function
	if cpu.interrupt(0x40, .it_vblanks) {}
	else if cpu.interrupt(0x48, .it_lcd_stat) {}
	else if cpu.interrupt(0x50, .it_timer) {}
	else if cpu.interrupt(0x58, .it_joypad) {}
	else if cpu.interrupt(0x60, .it_serial) {}
}

fn (mut cpu Cpu) request_interrupt(interrupt Interruption_types) {
	cpu.interruption_flags |= u8(interrupt)
}
