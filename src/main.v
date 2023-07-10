fn main() {
  println("Starting VBoy")
  println("Initializing CPU...")
  mut cpu := Cpu{}
  println("CPU Initialized succesfully.")

  cpu.registers.a = 0
  cpu.registers.c = 248

  cpu.registers.print()
  println("Test a - c . . . ")
  cpu.execute(InstructionTarget{.decr, .a})
  cpu.registers.print()
}
