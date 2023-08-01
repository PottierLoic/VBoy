const boot_rom_begin = 0x00
const boot_rom_end = 0xFF
const boot_rom_size = boot_rom_end - boot_rom_begin + 1

const rom_bank_0_begin = 0x0000
const rom_bank_0_end = 0x3FFF
const rom_bank_0_size = rom_bank_0_end - rom_bank_0_begin + 1

const rom_bank_n_begin = 0x4000
const rom_bank_n_end = 0x7fff
const rom_bank_n_size = rom_bank_n_end - rom_bank_n_begin + 1

const vram_begin = 0x8000
const vram_end = 0x9fff
const vram_size = vram_end - vram_begin + 1

const external_ram_begin = 0xA000
const external_ram_end = 0xBFFF
const extrenal_ram_size = external_ram_end - external_ram_begin + 1

const working_ram_begin = 0xC000
const working_ram_end = 0xDFFF
const working_ram_size = working_ram_end - working_ram_begin + 1

const echo_ram_begin = 0xE000
const echo_ram_end = 0xFDFF
const echo_ram_size = echo_ram_end - echo_ram_begin + 1

const oam_begin = 0xFE00
const oam_end = 0xFE9F
const oam_size = oam_end - oam_begin + 1

const unused_begin = 0xFEA0
const unused_end = 0xFEFF
const unused_size = unused_end - unused_begin + 1

const io_register_begin = 0xFF00
const io_register_end = 0xFF7F
const io_register_size = io_register_end - io_register_begin + 1

const zero_page_begin = 0xFF80
const zero_page_end = 0xFFFE
const zero_page_size = zero_page_end - zero_page_begin + 1

const interrupt_enable_register = 0xFFFF
const vblank_vector = 0x40
const lcdstat_vector = 0x48
const timer_vector = 0x50

// struct MemoryBus {
// mut:
//   memory [65536]u8
// }

// fn (bus MemoryBus) read_byte(address u16) u8 {
//   return bus.memory[address]
// }

// fn (mut bus MemoryBus) write_byte(address u16, value u8) {
//   bus.memory[address] = value
// }
