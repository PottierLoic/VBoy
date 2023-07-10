fn main() {
  println("Starting VBoy")
  println("Initializing CPU...")
  mut cpu := Cpu{}
  println("CPU Initialized succesfully.")

  cpu.registers.a = 127
  cpu.registers.c = 136

  cpu.registers.print()
  println("Test a + c . . . ")
  cpu.execute(InstructionTarget{.adc, .c})
  cpu.registers.print()
}
