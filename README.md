
Simple 8-bit cpu design in verilog using logic gates.

# Architecture

## Registers

Register file has 16 8-bit registers x0-x16.

Register x0 is a zero register (hard-wired to zero) - always reads 0 and writes are discarded.

Register x1 is a used in pseudo instructions for storing the return address.

### Register aliases

| Alias | Register |
| --- | --- |
| zero | x0 |
| ra | x1 |

## Memory

127 16-bit cells - 255 bytes

## Instructions

### Instruction table

| Name | Description | Op | Type | Effect |
| --- | --- | --- | --- | --- |
| ADD | add | 0 | R | `r0 = r1 + r2` |
| SUB | subtract | 1 | R | `r0 = r1 - r2` |
| XOR | logical xor | 2 | R | `r0 = r1 ^ r2` |
| NOR | logical nor | 3 | R | `r0 = ~(r1 \| r2)` |
| AND | logical and | 4 | R | `r0 = r1 & r2` |
| SRL | shift right logical | 5 | S | `r0 = r1 >> 1` |
| SRA | shift right arithmetic | 6 | S | `r0 = r1 >> 1` |
| STB | store byte | D | R | `memory[r1] = r2` |
| LDB | load byte | E | R | `r0 = memory[r1]` |
| LDI | load immediate | F | R | `r0 = imm` |
| JLR | jump and link register | 7 | R | `r0 = pc + 2; pc = r1 + r2` |
| JLI | jump and link immediate | 8 | I | `r0 = pc + 2; pc = imm` |
| | | 8 | | |
| | | 9 | | |
| | | A | | |
| | | B | | |
| | | C | | |

#### Notes
Jumps and branches ignore least significant bit in the address.

### Instruction types

| Type | 15:12 | 11:8 | 7:4 | 3:0 |
| --- | --- | --- | --- | --- |
| R | op | r0 | r1 | r2 |
| S | op | r0 | r1 | ignored  |
| I | op | r0 | imm hi | imm lo |

### Pseudo instructions

| Name | Description | Arguments | Instructions |
| --- | --- | --- | --- |
| NOP | no operation | | `ADD zero, zero, zero` |
| NOT | logical not | r0, r1 | `NOR r0, r1, r1` |
| SLL | shift left logical | r0, r1 | `ADD r0, r1, r1` |
| NEG | negation | r0, r1 | `SUB r0, zero, r1` |
| JMR | jump register | r0, r1 | `JLR x0, r0, r1` |
| JMI | jump immediate | imm | `JLR x0, imm` |
| CSI | call subroutine immediate | imm | `JLR ra, imm` |
| CSR | call subroutine register | r0, r1 | `JLR ra, r0, r1` |
| RET | return from subroutine | | `JLR zero, ra, zero` |
