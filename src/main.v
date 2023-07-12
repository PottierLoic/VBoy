fn main() {
  println("Starting VBoy")
  println("Initializing CPU...")
  mut cpu := Cpu{}
  println("CPU Initialized succesfully.")
  cpu.bus.load_rom("01-special.gb")

  cpu.registers.a = 159
  cpu.registers.c = 1

  cpu.registers.print()
  println("Test a + c . . . ")
  cpu.execute(Instruction{instruction: .swap, target_u8: .a, bit_position: .b0})
  cpu.registers.print()
}
