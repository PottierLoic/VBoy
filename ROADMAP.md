# Roadmap

Find a way to stop repeating cpu.pc++ for every casxe, maybe put it in the respecting functions ?

Rename / rework the instructions file, specifically the struct / enum part.
Naming is really bad and lead to missunderstandings.

Implement the following cpu instructions that act on register data:

- [x] ADD (add to a) - add the value of the target to the a register
- [ ] ADDHL (add to HL) - just like ADD except that the target is added to the HL register
- [x] ADC (add with carry) - just like ADD except that the value of the carry flag is also added to the number
- [x] SUB (subtract) - subtract the value stored in a specific register with the value in the A register
- [x] SBC (subtract with carry) - just like ADD except that the value of the carry flag is also subtracted from the number
- [x] AND (logical and) - do a bitwise and on the value in a specific register and the value in the A register
- [x] OR (logical or) - do a bitwise or on the value in a specific register and the value in the A register
- [x] XOR (logical xor) - do a bitwise xor on the value in a specific register and the value in the A register
- [x] CP (compare) - just like SUB except the result of the subtraction is not stored back into A
- [x] INC (increment) - increment the value in a specific register by 1
- [x] DEC (decrement) - decrement the value in a specific register by 1
- [x] CCF (complement carry flag) - toggle the value of the carry flag
- [x] SCF (set carry flag) - set the carry flag to true
- [x] RRA (rotate right A register) - bit rotate A register right through the carry flag
- [x] RLA (rotate left A register) - bit rotate A register left through the carry flag
- [x] RRCA (rotate right A register) - bit rotate A register right (not through the carry flag)
- [x] RRLA (rotate left A register) - bit rotate A register left (not through the carry flag)
- [x] CPL (complement) - toggle every bit of the A register
- [Need to find a way to call it correctly but works] BIT (bit test) - test to see if a specific bit of a specific register is set
- [Need to find a way to call it correctly but works] RESET (bit reset) - set a specific bit of a specific register to 0
- [Need to find a way to call it correctly but works] SET (bit set) - set a specific bit of a specific register to 1
- [ ] SRL (shift right logical) - bit shift a specific register right by 1
- [ ] RR (rotate right) - bit rotate a specific register right by 1 through the carry flag
- [ ] RL (rotate left) - bit rotate a specific register left by 1 through the carry flag
- [ ] RRC (rorate right) - bit rotate a specific register right by 1 (not through the carry flag)
- [ ] RLC (rorate left) - bit rotate a specific register left by 1 (not through the carry flag)
- [ ] SRA (shift right arithmetic) - arithmetic shift a specific register right by 1
- [ ] SLA (shift left arithmetic) - arithmetic shift a specific register left by 1
- [ ] SWAP (swap nibbles) - switch upper and lower nibble of a specific register

Implement remaining memory loading / reading instructions.

Finish cpu.call function that is missing read_next_word() to work.