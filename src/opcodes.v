// will probably never be used

const opcodes_unprefixed = [
  Instruction{instruction: .nop}										                    // 0x00
  Instruction{instruction: .ld}  	  // 0x01 NOT DONE
  Instruction{instruction: .ld}		  // 0x02 NOT DONE
  Instruction{instruction: .inc, target_u16: .bc} // 0x03 NOT DONE
  Instruction{instruction: .inc, target_u8: .b}                         // 0x04
  Instruction{instruction: .dec, target_u8: .b}                         // 0x05
  Instruction{instruction: .ld}     // 0x06 NOT DONE
  Instruction{instruction: .rlca}                                       // 0x07
  Instruction{instruction: .ld}     // 0x08 NOT DONE
  Instruction{instruction: .addhl, target_u16: .bc}                     // 0x09
  Instruction{instruction: .ld}     // 0x0a NOT DONE
  Instruction{instruction: .dec, target_u16: .bc} // 0x0b NOT DONE
]
