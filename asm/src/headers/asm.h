#ifndef INCLUDE_ASM
#define INCLUDE_ASM

#include <stdint.h>
#include <stdio.h>

#include "common.h"
#include "inst.h"

typedef enum {
  TOK_NONE,
  TOK_DECIMAL,
  TOK_HEX,
  TOK_SYMBOL,
  TOK_NEWLINE,
  TOK_COMMA,

  TOK_COUNT,
} TokenTag;

const char *TOK_NAME[TOK_COUNT] = {
  [TOK_NONE] = "none",
  [TOK_DECIMAL] = "decimal",
  [TOK_HEX] = "hex",
  [TOK_SYMBOL] = "symbol",
  [TOK_NEWLINE] = "nl",
  [TOK_COMMA] = ",",
};

typedef struct {
  uint32_t start;
  uint16_t len;
  TokenTag tag;
} Token;

#define MAX_TOKENS 256

uint16_t tokenize(const char *source, Token token_arr[MAX_TOKENS]);

#define MEM_SIZE 256
#define MAX_SYMBOLS 256

typedef enum {
  FORMAT_NONE,

  FORMAT_REG3,
  FORMAT_IMM,
  FORMAT_SIMM,
  FORMAT_COND,
  FORMAT_PSEUDO,
} InstFormat;

typedef enum {
  OP_BZS = 0x10,
  OP_BCS = 0x11,
  OP_BZC = 0x12,
  OP_BCC = 0x13,
  OP_NOP,
  OP_MOV,
  OP_NOT,
  OP_SLL,
  OP_NEG,
  OP_JMR,
  OP_JMI,
  OP_CSI,
  OP_CSR,
  OP_RET,
  OP_INC,
  OP_DEC,
  OP_CMP,
  OP_TST,
} InstOpcode;

typedef struct {
  char name[3];
  InstOpcode opcode;
  InstFormat format;
} Inst;

const Inst INSTRUCTIONS[] = {
  { "add", OP_ADD, FORMAT_REG3 },
  { "sub", OP_SUB, FORMAT_REG3 },
  { "xor", OP_XOR, FORMAT_REG3 },
  { "nor", OP_NOR, FORMAT_REG3 },
  { "and", OP_AND, FORMAT_REG3 },
  { "rot", OP_ROT, FORMAT_REG3 },
  { "roi", OP_ROI, FORMAT_SIMM },
  { "jlr", OP_JLR, FORMAT_REG3 },
  { "jli", OP_JLI, FORMAT_IMM },

  { "bzs", OP_BZS, FORMAT_COND },
  { "bzc", OP_BZC, FORMAT_COND },
  { "bcs", OP_BCS, FORMAT_COND },
  { "bcc", OP_BCC, FORMAT_COND },

  { "beq", OP_BZS, FORMAT_COND },
  { "bne", OP_BZC, FORMAT_COND },
  { "blt", OP_BCS, FORMAT_COND },
  { "bge", OP_BCC, FORMAT_COND },

  { "adi", OP_ADI, FORMAT_SIMM },
  { "ldi", OP_LDI, FORMAT_IMM },
  { "ldb", OP_LDB, FORMAT_REG3 },
  { "stb", OP_STB, FORMAT_REG3 },

  { "nop", OP_NOP, FORMAT_PSEUDO },
  { "mov", OP_MOV, FORMAT_PSEUDO },
  { "not", OP_NOT, FORMAT_PSEUDO },
  { "neg", OP_NEG, FORMAT_PSEUDO },
  { "jmr", OP_JMR, FORMAT_PSEUDO },
  { "jmi", OP_JMI, FORMAT_PSEUDO },
  { "csi", OP_CSI, FORMAT_PSEUDO },
  { "csr", OP_CSR, FORMAT_PSEUDO },
  { "ret", OP_RET, FORMAT_PSEUDO },
  { "inc", OP_INC, FORMAT_PSEUDO },
  { "dec", OP_DEC, FORMAT_PSEUDO },
  { "cmp", OP_CMP, FORMAT_PSEUDO },
  { "tst", OP_TST, FORMAT_PSEUDO },
};

const uint32_t INSTRUCTIONS_LEN = sizeof(INSTRUCTIONS) / sizeof(Inst);

typedef struct {
  Token tokens[MAX_TOKENS];
  uint8_t memory[MEM_SIZE];
  uint8_t symbols[MAX_SYMBOLS];
  const char *source;
  uint16_t mem_pos;
  uint16_t tok_pos;
} Asm;

void Asm_assemble(const char *source, Asm *a);

void write_inst_hex(FILE *file, const uint8_t source[MEM_SIZE]);


#endif
