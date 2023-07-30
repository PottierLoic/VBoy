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
  vboy.cpu.vboy = &vboy
  println("CPU initialized succesfully")

  /* Starting emulation */
  println("Starting emulation")
  vboy.running = true

  // // This should not stay like this, just for testing
  // // write rom to memory bus for now
  // for i in 0 .. 65536 {
  //   vboy.memory.write_byte(i, vboy.cart.rom_data[i])
  // }

  /* Cpu loop */
  for vboy.running {
    if vboy.paused { delay(10) } else {
      vboy.cpu.print()
      vboy.cpu.step()
    }
  }
}

fn delay(ms u32) {
  // Do the delay with sdl wrapper / gg / sokol once graphics are added
}