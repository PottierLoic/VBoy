enum Instruction {
	add
	decr
}

enum ArithmeticTarget {
	a b c d e h l
}

fn main() {
	mut reg := Registers{b: 1}
	println(reg.get_bc())
	reg.set_bc(127)
	println(reg.get_bc())
}