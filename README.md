
Simple 8-bit cpu design in verilog using logic gates.


# Instructions

## Instruction table

| Name | Full name | Op | Type | Effect |
| --- | --- | --- | --- | --- |
| ADD | add | 0 | A | `r0 = r1 + r2` |
| SUB | subtract | 1 | A | `r0 = r1 - r2` |
| XOR | xor | 2 | A | `r0 = r1 ^ r2` |
| NOR | nor | 3 | A | `r0 = ~(r1 \| r2)` |
| AND | and | 4 | A | `r0 = r1 & r2` |
| SRL | shift right logical | 5 | S | `r0 = r1 << 1` |
| SRA | shift right arithmetic | 6 | S | `r0 = r1 << 1` |
| STB | store byte | D | A | `memory[r1] = r2` |
| LDB | load byte | E | A | `r0 = memory[r1]` |
| LDI | load immediate | F | L | `r0 = imm` |

## Instruction types

| Type | 15:12 | 11:8 | 7:4 | 3:0 |
| --- | --- | --- | --- | --- |
| A | op | r0 | r1 | r2 |
| S | op | r0 | r1 | -  |
| L | op | r0 | imm hi | imm lo |
