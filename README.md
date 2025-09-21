
Simple cpu design with assembler and emulator.

# Features
- Simple machine code format.
- Only few instructions.
- Word size is 8-bits - addresses, registers, program counter.
- Fifteen general purpose registers x1-x15.
- Zero register x0.
- 256 bytes of unified (instructions and data) memory.
- Load-store architecture - separate instructions for memory manipulation.
- Von-Neuman architecture - one memory for instructions and data.
- Pseudo instructions to better express intent and simplify writing assembly code.

# Architecture

## Register aliases

| Alias | Register |
| --- | --- |
| zero | x0 |
| ra | x15 |

## Flags

| Flag | Name |
| --- | --- |
| Z | zero flag |
| C | carry flag |

## Instructions

### Instruction table

| Name | Description | Op | Type | Effect | Flags |
| --- | --- | --- | --- | --- | --- |
| ADD | add | 0 | R | `r0 = r1 + r2` | Z, C |
| SUB | subtract | 1 | R | `r0 = r1 - r2` | Z, C |
| XOR | logical xor | 2 | R | `r0 = r1 ^ r2` | Z, C |
| NOR | logical nor | 3 | R | `r0 = ~(r1 \| r2)` | Z, C |
| AND | logical and | 4 | R | `r0 = r1 & r2` | Z, C |
| ROT | rotate bits right | 5 | R | `r0 = rot_right(r1, r2)` | Z, C |
| ROI | rotate right immediate | 6 | S | `r0 = rot_right(r1, imm)` | Z, C |
| JLR | jump and link register | 7 | R | `r0 = pc + 2; pc = r1 + r2` | Z, C |
| JAL | jump and link immediate | 8 | I | `r0 = pc + 2; pc = imm` | |
| B-- | branch instructions | 9 | B | `if (cond) { pc = imm }` | |
| ADI | add 4-bit sign extended immediate | C | S | `r0 = r1 + imm` | Z, C |
| MR- | memory read | D | M | `memory[r1 + imm] = r0` | Z, C |
| MW- | memory write | E | M | `r0 = memory[r1 + imm]` | Z, C |
| LDI | load immediate | F | I | `r0 = imm` | |
| | | A | | |
| | | B | | |

#### Notes

Jumps and branches ignore least significant bit in the address.

JLR instruction uses ALU to add r1 and r2, therefore it updates the flags.

ROT instruction uses only 3 lowest bits of r2 and ignores the rest.

Instructions LDB and STB use ALU for calculating the addres,
therefore they update the flags based on the address calculated.

In M-type instrution can either address byte or half (16 bits).
The immediate in M-type instrutions isn't sign extended.

### Instruction types

| Type | 15:12 | 11:8 | 7:4 | 3:0 |
| --- | --- | --- | --- | --- |
| R | op | r0 | r1 | r2 |
| I | op | r0 | imm hi | imm lo |
| S | op | r0 | r1 | imm |
| B | op | cond | imm hi | imm lo |
| M | op | r0 | r1 | b/h, imm 3-bit |

### Branch instructions

| Name | Description | Cond |
| --- | --- | --- |
| BZR | branch if zero flag set | 0 |
| BNZ | branch if carry set | 1 |
| BCR | branch if zero flag cleared | 2 |
| BNC | branch if carry cleared | 3 |

### Pseudo instructions

| Name | Args | Description | Instructions |
| --- | --- | --- | --- |
| NOP | | no operation | `ADD zero, zero, zero` |
| MOV | r0, r1 | move (copy) register to another | `ADD r0, zero, r1` |
| NOT | r0, r1 | logical not | `NOR r0, r1, r1` |
| NEG | r0, r1 | negation | `SUB r0, zero, r1` |
| JMP | r0, r1 | jump register | `JLR x0, r0, r1` |
| JMP | imm | jump immediate | `JLI x0, imm` |
| CAL | r0, r1 | call subroutine register | `JLI ra, r0, r1` |
| CAL | imm | call subroutine immediate | `JLR ra, imm` |
| RET | | return from subroutine | `JLR zero, ra, zero` |
| INC | r0, r1 | increment | `ADI r0, r1, 1` |
| DEC | r0, r1 | decrement | `ADI r0, r1, -1` |
| CMP | r0, r1 | compare | `SUB zero, r0, r1` |
| TST | r0, r1 | bit test | `AND zero, r0, r1` |
| BEQ | imm | branch if equal | `BZS imm` |
| BNE | imm | branch if not equal | `BZC imm` |
| BLT | imm | branch if less than | `BCS imm` |
| BGE | imm | branch if greater or equal | `BCC imm` |
