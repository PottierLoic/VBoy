fn main() {
  println("Starting VBoy")
  println("Initializing CPU...")
  mut cpu := Cpu{}
  println("CPU Initialized succesfully.")

  cpu.registers.a = 255
  cpu.registers.c = 248

  cpu.registers.print()
  println("Test a - c . . . ")
  cpu.execute(InstructionTarget{.cpl, .c})
  cpu.registers.print()

  cpu.registers.a = cpu.set(0, cpu.registers.a)
  cpu.registers.print()
}
