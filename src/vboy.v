import os

struct VBoy {
  // Emulator components
mut:
  cart Cart
  cpu Cpu
  memory MemoryBus
  ppu Ppu


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
  println("CPU initialized succesfully")

  vboy.cpu.registers.print()

  /* Starting emulation */
  // vboy.running = true

  /* Cpu loop */
  for vboy.running {
    if vboy.paused { delay(10) } else {
      vboy.cpu.step()
    }
  }
}

fn delay(ms u32) {
  // Do the delay with sdl wrapper / gg / sokol once graphics are added
}