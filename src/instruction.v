/* Register instructions part, each register instruction is composed of an instruction and a target */
enum ArithmeticTarget {
  a b c d e f h l
}
enum RegistersInstruction {
  add
  decr
  inc
}
struct InstructionTarget {
  reg_instruction RegistersInstruction
  target ArithmeticTarget
}

/* Jump instructions part, each jump instruction is composed of an instruction and a condition */
enum JumpTest {
  not_zero
  zero
  not_carry
  carry
  always
}
enum JumpInstruction {
  jp
  call
  ret
}
struct InstructionCondition {
  jump_instruction JumpInstruction
  condition JumpTest
}

/* Memory reading / writing part */
enum LoadByteTarget {
	a b c d e h l hli
}
enum LoadByteSource {
	a b c d e h l d8 hli
}
enum LoadType {
	byte
	word
	a_from_indirect
	indirect_from_a
	a_from_byte_address
	byte_address_from_a
}
enum LoadInstruction {
	ld
}
struct InstructionLoad {
	mem_instruction LoadInstruction
	load_type LoadType
	source LoadByteSource
	target LoadByteTarget
}

/* Stack targets and Instruction/Target struct */
enum StackTarget {
	bc de hl af
}
enum StackInstruction {
	push
	pop
}
struct InstructionStack {
	instruction StackInstruction
	target StackTarget
}

/* Waiting instructions, they have no targets */
enum WaitingInstruction {
	nop
	halt
}

/* An instruction can be a jump, an arithmetic instruction, or a memory reading/writing */
type Instruction = InstructionTarget | InstructionCondition | InstructionLoad | InstructionStack | WaitingInstruction

/* Choose the correct method to read the instruction */
fn instruction_from_byte(value u8, prefixed bool) InstructionTarget {
  if prefixed { return instruction_from_byte_prefixed(value) }
  else { return instruction_from_byte_not_prefixed(value) }
}

/*  */
fn instruction_from_byte_prefixed(value u8) InstructionTarget {
  match value {
    0x00 { return InstructionTarget{RegistersInstruction.inc, ArithmeticTarget.b} }
    else { panic("Instruction not found: ${value}") } // add all remaining instruct
  }
}

fn instruction_from_byte_not_prefixed(value u8) InstructionTarget {
  match value {
    0x02 { return InstructionTarget{RegistersInstruction.inc, ArithmeticTarget.b} }
    else { panic("Instruction not found: ${value}") } // add all remaining instruct
  }
}
