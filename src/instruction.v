/* Register instructions part, each register instruction is composed of an instruction and a target */
enum RegisterU8 {
  a b c d e h l d8 hli
}

enum RegisterU16 {
  af bc de hl sp
}

enum Instruction_ {
  // Arithmetic instr
  add     //yeah
  decr    //yeah
  inc     //yeah
  adc     //yeah
  addhl   //NOPE
  addsp   //NOPE
  sub     //yeah
  sbc     //yeah
  and     //yeah
  or_     //yeah
  xor     //yeah
  cp      //yeah

  ccf     //yeah
  scf     //yeah

  rra     //yeah
  rla     //yeah
  rrca    //yeah
  rlca    //yeah
  cpl     //yeah
  daa     //NOPE

  // Prefix instr
  bit     //yeah
  res     //yeah
  set     //yeah
  srl     //yeah
  rr      //yeah
  rl      //yeah
  rrc     //yeah
  rlc     //yeah
  sra     //yeah
  sla     //yeah
  swap    //yeah

  // Jump instr
  jp      //yeah
  jr      //NOPE
  jpi     //NOPE

  // Load instr
  ld      //yeah

  // Stack instr
  push    //yeah
  pop     //yeah
  call    //NOPE
  ret     //yeah
  reti    //NOPE
  rst     //NOPE

  // Control instr
  halt    // A VOIR SI CA RESTE COMME CA
  nop     //yeah
  di      //NOPE
  ei      //NOPE
}

/* Jump instructions part, each jump instruction is composed of an instruction and a condition */
enum JumpTest {
  not_zero
  zero
  not_carry
  carry
  always
}

/* Memory reading / writing part */
enum LoadByteTarget {
	a b c d e h l hli
}
enum LoadByteSource {
	a b c d e h l d8 hli
}
enum LoadWordTarget {
  bc de hl sp
}
enum Indirect {
  bc_indirect
  de_indirect
  hl_indirect_minus
  hl_indirect_plus
  word_indirect
  last_byte_indirect
}
enum LoadType {
	byte                  // done
	word                  // not done
	a_from_indirect       // not done
	indirect_from_a       // not done
	a_from_byte_address   // not done
	byte_address_from_a   // not done
  sp_from_hl            // not done
  hl_from_spn           // not done
  indirect_from_sp      // not done
}

/* Stack targets and Instruction/Target struct */
enum StackTarget {
	bc de hl af
}

enum Position {
  b0 b1 b2 b3 b4 b5 b6 b7
}

struct Instruction {
  instruction Instruction_
  target_u8 RegisterU8
  target_u16 RegisterU16
  jump_test JumpTest
  byte_target LoadByteTarget
  byte_source LoadByteSource
  word_target LoadWordTarget
  indirect Indirect
  load_type LoadType
  stack_target StackTarget
  bit_position Position
}

/* Choose the correct method to read the instruction */
fn instruction_from_byte(value u8, prefixed bool) Instruction {
  if prefixed { return instruction_from_byte_prefixed(value) }
  else { return instruction_from_byte_not_prefixed(value) }
}

fn instruction_from_byte_prefixed(value u8) Instruction {
  match value {
    0x00 { return Instruction{instruction: .add, target_u8: .c} }
    else { panic("Instruction not found: ${value}") } // add all remaining instruct
  }
}

fn instruction_from_byte_not_prefixed(value u8) Instruction {
  match value {
    0x02 { return Instruction{instruction: .add, target_u8: .c} }
    else { panic("Instruction not found: ${value}") } // add all remaining instruct
  }
}
