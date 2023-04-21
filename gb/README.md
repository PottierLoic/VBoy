# Game Boy emulator

## 8-Bit CPU :
- 0000 0000  
A -> u8  
B -> u8  
C -> u8  
D -> u8  
E -> u8  
F -> u8  
G -> u8  
H -> u8 

## 4 "Virtual" 16 bit registers

- AF is create by transforming A into u16  
- bit shifting A by 8  
- adding F to A  

AF -> u16 = u16(A) << 8 + F  
BC -> u16 = u16(C) << 8 + C  
DE -> u16 = u16(D) << 8 + E  
HL -> u16 = u16(H) << 8 + L  

## Flags register

### F contains flags on bites 4, 5, 6 and 7
- Bit 7: zero
- Bit 6: subtraction
- Bit 5: half carry
- Bit 4: carry