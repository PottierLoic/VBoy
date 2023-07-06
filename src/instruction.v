enum ArithmeticTarget {
	a b c d e h l
}

enum Instruction {
	add
	decr
	inc
}

struct Instruction_Target {
	instruction Instruction
	target ArithmeticTarget
}


fn instruction_from_byte(value u8, prefixed bool) Instruction_Target {
	if prefixed {
		return instruction_from_byte_prefixed(value)
	} else {
		return instruction_from_byte_not_prefixed(value)
	}
}

fn instruction_from_byte_prefixed(value u8) Instruction_Target {
	match value {
		0x00 { return Instruction_Target{Instruction.inc, ArithmeticTarget.b} }
		else { panic("Instruction not found: ${value}") } // add all remaining instruct
	}
}

fn instruction_from_byte_not_prefixed(value u8) Instruction_Target {
	match value {
		0x02 { return Instruction_Target{Instruction.inc, ArithmeticTarget.b} }
		else { panic("Instruction not found: ${value}") } // add all remaining instruct
	}
}
