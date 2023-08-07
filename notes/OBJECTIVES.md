# Roadmap

Replace all timer_cycle(int) by timer_cycle(instruction.opcode), edit the instruction struct to add the opcode field.
This way, it is possible to create new instruction without having to count and write every case.

Find a way to stop repeating cpu.pc++ for every case, maybe put it in each respecting functions to make it cleaner ?

Leave the FlagsRegister struct and only work with u8

Implement remaining memory loading / reading instructions.

Finish cpu.call function that is missing read_next_word() to work.

rework all cpu calls to make them work the same way (to be a minimum coherent at least)