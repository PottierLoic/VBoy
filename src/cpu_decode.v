module main

struct Operand {
	data u16
	destination u16
	write_in_mem bool
}

fn (mut cpu Cpu) fetch_operands() Operand {
	mut data := u16(0)
	mut destination := u16(0)
	mut write := false

	match cpu.fetched_instruction {
		.am_imp {}
		.am_r {
			data = cpu.get_reg(cpu.fetched_instruction.reg_1)
		}
		.am_r_r {
     data = cpu.get_reg(cpu.fetched_instruction.reg_2)
    }
    .am_r_d8 {
      data = cpu.bus.read(cpu.registers.pc)
      cpu.registers.pc++
    }
    .am_r_d16, .am_d16 {
      lo := cpu.bus.read(cpu.registers.pc)
      hi := cpu.bus.read(cpu.registers.pc + 1)
      data = lo | (u16(hi) << 8)
      cpu.registers.pc += 2
    }
    .am_mr_r {
      data = cpu.get_reg(cpu.fetched_instruction.reg_2)
      destination = cpu.get_reg(cpu.fetched_instruction.reg_1)
      if cpu.fetched_instruction.reg_1 == .reg_c {
        destination |= 0xFF00
      }
      write = true
    }
    .am_r_mr {
      mut addr := cpu.get_reg(cpu.fetched_instruction.reg_2)
      if cpu.fetched_instruction.reg_2 == .reg_c {
        addr |= 0xFF00
      }
      data = cpu.bus.read(addr)
    }
    .am_r_hli {
      addr := cpu.get_reg(cpu.fetched_instruction.reg_2)
      data = cpu.bus.read(addr)
      cpu.registers.set_hl(cpu.registers.get_hl() + 1)
    }
    .am_r_hld {
      addr := cpu.get_reg(cpu.fetched_instruction.reg_2)
      data = cpu.bus.read(addr)
      cpu.registers.set_hl(cpu.registers.get_hl() - 1)
    }
    .am_hli_r {
      data = cpu.get_reg(cpu.fetched_instruction.reg_2)
      destination = cpu.get_reg(cpu.fetched_instruction.reg_1)
      write = true
      cpu.registers.set_hl(cpu.registers.get_hl() + 1)
    }
    .am_hld_r {
      data = cpu.get_reg(cpu.fetched_instruction.reg_2)
      destination = cpu.get_reg(cpu.fetched_instruction.reg_1)
      write = true
      cpu.registers.set_hl(cpu.registers.get_hl() - 1)
    }
    .am_r_a8 {
      data = cpu.bus.read(cpu.registers.pc)
      cpu.registers.pc++
    }
    .am_a8_r {
      destination = cpu.bus.read(cpu.registers.pc)
      cpu.registers.pc++
      destination |= 0xFF00
      write = true
    }
    .am_hl_spr {
      data = cpu.bus.read(cpu.registers.pc)
      cpu.registers.pc++
    }
    .am_d8 {
      data = cpu.bus.read(cpu.registers.pc)
      cpu.registers.pc++
    }
    .am_a16_r, .am_d16_r {
      lo := cpu.bus.read(cpu.registers.pc)
      hi := cpu.bus.read(cpu.registers.pc + 1)
      destination = lo | (u16(hi) << 8)
      data = cpu.get_reg(cpu.fetched_instruction.reg_2)
      write = true
      cpu.registers.pc += 2
    }
    .am_mr_d8 {
      destination = cpu.get_reg(cpu.fetched_instruction.reg_1)
      data = cpu.bus.read(destination)
      write = true
      cpu.registers.pc++
    }
    .am_mr {
      destination = cpu.get_reg(cpu.fetched_instruction.reg_1)
      data = cpu.bus.read(destination)
      write = true
    }
    .am_r_a16 {
      lo := cpu.bus.read(cpu.registers.pc)
      hi := cpu.bus.read(cpu.registers.pc + 1)
      addr := lo | (u16(hi) << 8)
      data = cpu.bus.read(addr)
      cpu.registers.pc += 2
    }
    .am_none {
      panic('fetch_operands: am_none is invalid')
    }
  }

	return Operand{
		data: data,
		destination: destination,
		write_in_mem: write,
	}
}