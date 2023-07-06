enum JumpTest {
	not_zero
	zero
	not_carry
	carry
	always
}

enum JumpInstruction {
	jp
}

struct InstructionCondition {
	jump_instruction JumpInstruction
	condition JumpTest
}