# Game Boy emulator

## 8-Bit CPU :
- 0000 0000  
A -> u8  
B -> u8  
C -> u8  
D -> u8  
E -> u8  
F -> u8  
H -> u8  
L -> u8  

## 4 "Virtual" 16 bit registers

- AF is created by transforming A into u16  
- bit shifting A by 8
- adding F to A  

AF -> u16 = u16(A) << 8 + F  
BC -> u16 = u16(C) << 8 + C  
DE -> u16 = u16(D) << 8 + E  
HL -> u16 = u16(H) << 8 + L  

## Flags register

### F contains flags on bytes 4, 5, 6 and 7
- Bit 7: zero  
- Bit 6: subtraction  
- Bit 5: half carry  
- Bit 4: carry  

## Opcodes  

Opcodes goes from 0x00 to 0xFF and are 1 byte long.  
So there are 256 basic opcodes.  

But if an opcode is 0xCB, it means that the next byte is an opcode too.  
So there are 512 opcodes in total. (somes are unused)  

## Memory map

0x0000 - 0x3FFF : 16KB ROM bank 00  
0x4000 - 0x7FFF : 16KB ROM Bank 01~NN  
0x8000 - 0x9FFF : 8KB Video RAM (VRAM)  
0xA000 - 0xBFFF : 8KB External RAM  
0xC000 - 0xCFFF : 4KB Work RAM (WRAM) bank 0  
0xD000 - 0xDFFF : 4KB Work RAM (WRAM) bank 1~N  
0xE000 - 0xFDFF : Mirror of C000~DDFF (ECHO RAM)  
0xFE00 - 0xFE9F : Sprite attribute table (OAM)  
0xFEA0 - 0xFEFF : Not Usable  
0xFF00 - 0xFF7F : I/O Registers  
0xFF80 - 0xFFFE : High RAM (HRAM)  
0xFFFF - 0xFFFF : Interrupts Enable Register  

## Interrupts

Interrupts are enabled by setting the corresponding bit in the Interrupt Enable Register (0xFFFF).

- Bit 0: V-Blank  Interrupt Enable  (INT 40h)  (1=Enable)  
- Bit 1: LCD STAT Interrupt Enable  (INT 48h)  (1=Enable)  
- Bit 2: Timer    Interrupt Enable  (INT 50h)  (1=Enable)  
- Bit 3: Serial   Interrupt Enable  (INT 58h)  (1=Enable)  
- Bit 4: Joypad   Interrupt Enable  (INT 60h)  (1=Enable)  
