#ifndef INCLUDE_ASM
#define INCLUDE_ASM

#include <stdint.h>
#include <stdio.h>

#define MEM_SIZE 256

typedef enum {
  OP_ADD = 0x0,
  OP_SUB = 0x1,
  OP_XOR = 0x2,
  OP_NOR = 0x3,
  OP_AND = 0x4,
  OP_SRL = 0x5,
  OP_SRA = 0x6,
  OP_STB = 0xD,
  OP_LDB = 0xE,
  OP_LDI = 0xF,
} Opcode;

typedef struct {
  uint8_t memory[MEM_SIZE];
  uint16_t mem_pos;
} Asm;

void Asm_assemble(Str file, Asm *a);

void write_inst_hex(FILE *file, const uint8_t source[MEM_SIZE]);

#endif
