#ifndef INCLUDE_INST
#define INCLUDE_INST

typedef enum {
  OP_ADD = 0x0,
  OP_SUB = 0x1,
  OP_XOR = 0x2,
  OP_NOR = 0x3,
  OP_AND = 0x4,
  OP_ROT = 0x5,
  OP_JLR = 0x7,
  OP_JLI = 0x8,
  OP_B__ = 0x9,
  OP_ADI = 0xC,
  OP_STB = 0xD,
  OP_LDB = 0xE,
  OP_LDI = 0xF,

  OP_COUNT,
} Opcode;

typedef enum {
  COND_ZS = 0,
  COND_ZC = 1,
  COND_CS = 2,
  COND_CC = 3,
} OpCond;

#endif
