enum ArithmeticTarget {
	a b c d e h l
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

fn instruction_from_byte(value u8, prefixed bool) InstructionTarget {
	if prefixed {
		return instruction_from_byte_prefixed(value)
	} else {
		return instruction_from_byte_not_prefixed(value)
	}
}

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
