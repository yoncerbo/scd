
Simple 8-bit cpu design in verilog using logic gates.

# Architecture

## Registers

Register file has 16 8-bit registers x0-x16.

Register x0 is a zero register (hard-wired to zero) - always reads 0 and writes are discarded.

## Memory

127 16-bit cells - 255 bytes

## Instructions

### Instruction table

| Name | Description | Op | Type | Effect |
| --- | --- | --- | --- | --- |
| ADD | add | 0 | A | `r0 = r1 + r2` |
| SUB | subtract | 1 | A | `r0 = r1 - r2` |
| XOR | logical xor | 2 | A | `r0 = r1 ^ r2` |
| NOR | logical nor | 3 | A | `r0 = ~(r1 \| r2)` |
| AND | logical and | 4 | A | `r0 = r1 & r2` |
| SRL | shift right logical | 5 | S | `r0 = r1 >> 1` |
| SRA | shift right arithmetic | 6 | S | `r0 = r1 >> 1` |
| STB | store byte | D | A | `memory[r1] = r2` |
| LDB | load byte | E | A | `r0 = memory[r1]` |
| LDI | load immediate | F | L | `r0 = imm` |
| | | 7 | | |
| | | 8 | | |
| | | 9 | | |
| | | A | | |
| | | B | | |
| | | C | | |

### Instruction types

| Type | 15:12 | 11:8 | 7:4 | 3:0 |
| --- | --- | --- | --- | --- |
| A | op | r0 | r1 | r2 |
| S | op | r0 | r1 | ignored  |
| L | op | r0 | imm hi | imm lo |

### Pseudo instructions

| Name | Description | Arguments | Effect | Instructions |
| --- | --- | --- | --- | --- |
| NOP | no operation | | | `ADD x0, x0, x0` |
| NOT | logical not | r0, r1 | `r0 = ~r1` | `NOR r0, r1, r1` |
| SLL | shift left logical | x0, x1 | `x0 = x1 << 1` | `ADD x0, x1, x1` |
| NEG | negation | r0, r1 | `r0 = -r1` | `SUB r0, x0, r1` |
