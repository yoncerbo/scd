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

typedef struct {
  char name[3];
  uint8_t opcode;
} Inst;

const Inst INSTRUCTIONS[] = {
  { "add", OP_ADD },
  { "ldi", OP_LDI },
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
