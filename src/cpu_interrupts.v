enum Interrupt_types {
  it_vblanks = 0b1
	it_lcd_stat = 0b10
	it_timer = 0b100
	it_serial = 0b1000
	it_joypad = 0b10000
}

fn (mut cpu Cpu) handle_interrupts() {

}

fn (mut cpu Cpu) request_interrupt(inter Interrupt_types) {
	cpu.interruption_flags |= u8(inter)
}
