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


fn byte_to_instruction(value u8) Instruction_Target {
	match value {
		// all of thoses instructions are wrong and are only here for tests
		0x02 { return Instruction_Target{Instruction.inc, ArithmeticTarget.b}}
		0x13 { return Instruction_Target{Instruction.inc, ArithmeticTarget.d}}
		else { return Instruction_Target{Instruction.add, ArithmeticTarget.b}}
	}
}
