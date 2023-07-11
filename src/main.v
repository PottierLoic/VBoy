fn main() {
  println("Starting VBoy")
  println("Initializing CPU...")
  mut cpu := Cpu{}
  println("CPU Initialized succesfully.")

  cpu.registers.a = 156
  cpu.registers.c = 1

  cpu.registers.print()
  println("Test a + c . . . ")
  cpu.execute(Instruction{instruction: .rl, target_u8: .c, bit_position: .b0})
  cpu.registers.print()
}
