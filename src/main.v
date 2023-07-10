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

  cpu.registers.set_bc(541)
  cpu.execute(InstructionStack{.push, .bc})
  cpu.registers.set_bc(497)
  cpu.execute(InstructionStack{.push, .bc})
  println(cpu.pop())
  cpu.registers.set_bc(124)
  cpu.execute(InstructionStack{.push, .bc})
  println(cpu.pop())
  println(cpu.pop())
}
