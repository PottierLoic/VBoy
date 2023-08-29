module vboy

/* Should never happend */
fn (mut cpu Cpu) cpu_none () {
	panic("Invalid instruction: ${cpu.fetched_instruction}")
}

/* Nop does nothing */
fn (mut cpu Cpu) cpu_nop () {}

/*  */
fn (mut cpu Cpu) cpu_ld () {}

fn (mut cpu Cpu) cpu_ldh () {}

fn (mut cpu Cpu) cpu_jp () {}

fn (mut cpu Cpu) cpu_di () {}

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

/* Apply AND operation to between A register and fetched data */
fn (mut cpu Cpu) cpu_and () {
	cpu.registers.a &= u8(cpu.fetched_data)
	cpu.set_flags(int(cpu.registers.a == 0), 0, 1, 0)
}

fn (mut cpu Cpu) cpu_xor () {}

fn (mut cpu Cpu) cpu_or () {}

fn (mut cpu Cpu) cpu_cp () {}

fn (mut cpu Cpu) cpu_cb () {}

fn (mut cpu Cpu) cpu_rrca () {}

fn (mut cpu Cpu) cpu_rlca () {}

fn (mut cpu Cpu) cpu_rra () {}

fn (mut cpu Cpu) cpu_rla () {}

fn (mut cpu Cpu) cpu_stop () {}

fn (mut cpu Cpu) cpu_halt () {}

fn (mut cpu Cpu) cpu_daa () {}

fn (mut cpu Cpu) cpu_cpl () {}

fn (mut cpu Cpu) cpu_scf () {}

fn (mut cpu Cpu) cpu_ccf () {}

fn (mut cpu Cpu) cpu_ei () {}

fn (mut cpu Cpu) cpu_reti () {}


/* Place all the cpu functions in the array for direct access later */
/* May be nice to find a way to just declare them in it directly as */
/* it looks really ugly like that 																	*/
/* Need to add: some fn that are not done yet */
fn (mut cpu Cpu) init_functions () {
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


fn (mut cpu Cpu) cpu_exec (opcode u8)  {
	cpu.func[opcode]()
}
