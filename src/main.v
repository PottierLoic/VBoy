fn main() {
  println("Starting VBoy")
  println("Initializing CPU...")
  mut cpu := Cpu{}
  println("CPU Initialized succesfully")

  cpu.registers.a = 128
  cpu.registers.c = 136

  cpu.registers.print()
  println("calcul . . . ")
  cpu.execute(InstructionTarget{.add, .c})

  cpu.registers.print()
}
