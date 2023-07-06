fn main() {
  println("Starting VBoy")
  println("Initializing CPU...")
  mut cpu := Cpu{}
  println("CPU Initialized succesfully.")

  cpu.registers.a = 127
  cpu.registers.c = 136

  cpu.registers.print()
  println("Test a + c . . . ")
  cpu.execute(InstructionTarget{.add, .c})
  cpu.registers.print()

  println("Test l = a . . . ")
  cpu.execute(InstructionLoad{.ld, .byte, .a, .l})
  cpu.registers.print()
}
