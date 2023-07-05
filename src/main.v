fn main() {

  println("Starting VBoy")
  mut cpu := Cpu{}
  cpu.registers.a = 120
  cpu.registers.c = 136

  cpu.registers.print_decimal()
  println("calcul . . . ")

  cpu.execute(Instruction_Target{.add, .c})
  cpu.registers.print_decimal()
  println(u8_to_flag(cpu.registers.f))
}
