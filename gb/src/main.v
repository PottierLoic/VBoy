

fn main() {

	println("test cpu")
	mut cpu := Cpu{}
	cpu.registers.a = 250
	cpu.registers.c = 12

	cpu.registers.print_binary()
	println("calcul . . . ")

	cpu.execute(Instruction_Target{.add, .c})
	cpu.registers.print_binary()
	println(u8_to_flag(cpu.registers.f))
}