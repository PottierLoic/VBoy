import os
import time

struct VBoy {
mut:
  // Emulator components
  cart Cart
  cpu Cpu
  memory MemoryBus
  ppu Ppu

  // Emulator states
  paused bool
  running bool
  tick u64
}

fn main() {
  args := os.args.clone()
  if args.len == 1 {
    println("Missing parameter: rom_path.")
    return
  } else if args.len > 2 {
    println("Too many parameters, only specify rom_path.")
    return
  }

  println("Starting VBoy")
  mut vboy := VBoy{}

  /* Cart initialization */
  println("Loading ROM file: ${args[1]}")
  if !vboy.cart.load_rom(args[1]) {
    println("Error loading rom: ${args[1]}")
    return
  } else { println("Rom loaded succesfully") }


  /* Cpu initialization */
  println("Initializing CPU")
  vboy.cpu.init()
  vboy.cpu.vboy = &vboy
  println("CPU initialized succesfully")

  /* Starting emulation */
  println("Starting emulation")
  vboy.running = true

  /* Cpu loop */
  for vboy.running {
    if vboy.paused { delay(10) } else {
      vboy.cpu.print()
      vboy.cpu.step()
    }
  }
}

fn delay(ms u32) {
  time.sleep(ms)
}