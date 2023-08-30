module vboy

/* Should never happend */
fn (mut cpu Cpu) cpu_none () {
	panic("Invalid instruction: ${cpu.fetched_instruction}")
}

/* Does nothing */
fn (mut cpu Cpu) cpu_nop () {}

/*  */
fn (mut cpu Cpu) cpu_ld () {}

fn (mut cpu Cpu) cpu_ldh () {}

fn (mut cpu Cpu) cpu_jp () {}

/* Disable interrupts */
fn (mut cpu Cpu) cpu_di () { cpu.int_master_enabled = false }

fn (mut cpu Cpu) cpu_pop () {}

fn (mut cpu Cpu) cpu_push () {}

fn (mut cpu Cpu) cpu_jr () {}

fn (mut cpu Cpu) cpu_call () {}

fn (mut cpu Cpu) cpu_ret () {}

fn (mut cpu Cpu) cpu_rst () {}

fn (mut cpu Cpu) cpu_dec () {}

fn (mut cpu Cpu) cpu_inc () {}

fn (mut cpu Cpu) cpu_add () {}

fn (mut cpu Cpu) cpu_adc () {}

fn (mut cpu Cpu) cpu_sub () {}

fn (mut cpu Cpu) cpu_sbc () {}

/* Apply AND operation between A register and fetched data */
fn (mut cpu Cpu) cpu_and () {
	cpu.registers.a &= u8(cpu.fetched_data)
	cpu.set_flags(int(cpu.registers.a == 0), 0, 1, 0)
}

/* Apply XOR operation between A register and fetched data */
fn (mut cpu Cpu) cpu_xor () {
	cpu.registers.a ^= u8(cpu.fetched_data)
	cpu.set_flags(int(cpu.registers.a == 0), 0, 0, 0)
}

/* Apply OR operation between A register and fetched data */
fn (mut cpu Cpu) cpu_or () {
	cpu.registers.a |= u8(cpu.fetched_data)
	cpu.set_flags(int(cpu.registers.a == 0), 0, 0, 0)
}

/* Compare reg A - fetched data */
fn (mut cpu Cpu) cpu_cp () {
	val := int(cpu.registers.a) - int(cpu.fetch_data)
	cpu.set_flags(int(val == 0), 1, int((int(cpu.registers.a & 0x0F) - int(cpu.fetched_data & 0x0F)) < 0), int(val < 0))
}

fn (mut cpu Cpu) cpu_cb () {}

/* Rotate register A to righ and keep carry */
fn (mut cpu Cpu) cpu_rrca () {
	mut carry := cpu.registers.a & 1
	cpu.registers.a = (cpu.registers.a >> 1) | carry
	cpu.set_flags(0, 0, 0, carry)
}

/* Rotate register A to left and keep carry */
fn (mut cpu Cpu) cpu_rlca () {
	mut val := cpu.registers.a
	mut carry := (cpu.registers.a >> 7) & 0x1
	cpu.registers.a = (val << 1) | carry
	cpu.set_flags(0, 0, 0, carry)
}

/* Rotate register A to right, add old carry and keep new carry */
fn (mut cpu Cpu) cpu_rra () {
	mut new_carry := cpu.registers.a & 1
	cpu.registers.a = (cpu.registers.a >> 1) | (bit(cpu.registers.f, carry_flag_byte_position) << 7 )
	cpu.set_flags(0, 0, 0, new_carry)
}

/* Rotate register A to left, add old carry and keep new carry */
fn (mut cpu Cpu) cpu_rla () {
	mut val := cpu.registers.a
	mut new_carry := (cpu.registers.a >> 7) & 1
	cpu.registers.a = (val << 1) | bit(cpu.registers.f, carry_flag_byte_position)
	cpu.set_flags(0, 0, 0, new_carry)
}

/* Stop the emulator */
fn (mut cpu Cpu) cpu_stop () { panic("Stop instruction received!") }

fn (mut cpu Cpu) cpu_halt () { cpu.halted = true }

fn (mut cpu Cpu) cpu_daa () {}

/* Invert A bits */
fn (mut cpu Cpu) cpu_cpl () {
	cpu.registers.a = ~cpu.registers.a
	cpu.set_flags(-1, 1, 1, -1)
}

/* Set carry flag */
fn (mut cpu Cpu) cpu_scf () { cpu.set_flags(-1, 0, 0, 1) }

/* Invert cary flag */
fn (mut cpu Cpu) cpu_ccf () { cpu.set_flags(-1, 0, 0, bit(cpu.registers.f, carry_flag_byte_position) ^ 1) }

/* Enable interrupts */
fn (mut cpu Cpu) cpu_ei () { cpu.int_master_enabled = true }

fn (mut cpu Cpu) cpu_reti () {}


/* Place all the cpu functions in the array for direct access later */
/* May be nice to find a way to just declare them in it directly as */
/* it looks really ugly like that 																	*/
/* Need to add: some fn that are not done yet */
fn (mut cpu Cpu) init_functions () {
	for i in 0 .. 255 {
		cpu.func[i] = cpu.cpu_none
	}

	cpu.func[int(Instr.instr_none)] = cpu.cpu_none
	cpu.func[int(Instr.instr_nop)] = cpu.cpu_nop
	cpu.func[int(Instr.instr_ld)] = cpu.cpu_ld
	cpu.func[int(Instr.instr_ldh)] = cpu.cpu_ldh
	cpu.func[int(Instr.instr_jp)] = cpu.cpu_jp
	cpu.func[int(Instr.instr_di)] = cpu.cpu_di
	cpu.func[int(Instr.instr_pop)] = cpu.cpu_pop
	cpu.func[int(Instr.instr_push)] = cpu.cpu_push
	cpu.func[int(Instr.instr_jr)] = cpu.cpu_jr
	cpu.func[int(Instr.instr_call)] = cpu.cpu_call
	cpu.func[int(Instr.instr_ret)] = cpu.cpu_ret
	cpu.func[int(Instr.instr_rst)] = cpu.cpu_rst
	cpu.func[int(Instr.instr_dec)] = cpu.cpu_dec
	cpu.func[int(Instr.instr_inc)] = cpu.cpu_inc
	cpu.func[int(Instr.instr_add)] = cpu.cpu_add
	cpu.func[int(Instr.instr_adc)] = cpu.cpu_adc
	cpu.func[int(Instr.instr_sub)] = cpu.cpu_sub
	cpu.func[int(Instr.instr_sbc)] = cpu.cpu_sbc
	cpu.func[int(Instr.instr_and)] = cpu.cpu_and
	cpu.func[int(Instr.instr_xor)] = cpu.cpu_xor
	cpu.func[int(Instr.instr_or)] = cpu.cpu_or
	cpu.func[int(Instr.instr_cp)] = cpu.cpu_cp
	cpu.func[int(Instr.instr_cb)] = cpu.cpu_cb
	cpu.func[int(Instr.instr_rrca)] = cpu.cpu_rrca
	cpu.func[int(Instr.instr_rlca)] = cpu.cpu_rlca
	cpu.func[int(Instr.instr_rra)] = cpu.cpu_rra
	cpu.func[int(Instr.instr_rla)] = cpu.cpu_rla
	cpu.func[int(Instr.instr_stop)] = cpu.cpu_stop
	cpu.func[int(Instr.instr_halt)] = cpu.cpu_halt
	cpu.func[int(Instr.instr_daa)] = cpu.cpu_daa
	cpu.func[int(Instr.instr_cpl)] = cpu.cpu_cpl
	cpu.func[int(Instr.instr_scf)] = cpu.cpu_scf
	cpu.func[int(Instr.instr_ccf)] = cpu.cpu_ccf
	cpu.func[int(Instr.instr_ei)] = cpu.cpu_ei
	cpu.func[int(Instr.instr_reti)] = cpu.cpu_reti
}

fn (mut cpu Cpu) cpu_exec ()  {
	cpu.func[cpu.fetched_instruction.instr_type]()
}
