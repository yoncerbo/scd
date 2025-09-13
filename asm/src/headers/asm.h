#ifndef INCLUDE_ASM
#define INCLUDE_ASM

#include <stdint.h>
#include <stdio.h>

#include "common.h"
#include "inst.h"

#define MEM_SIZE 256
#define MAX_SYMBOLS 256

const char OPCODES[OP_COUNT][4] = {
  [OP_ADD] = "add",
  [OP_LDI] = "ldi",
};

typedef struct {
  uint8_t memory[MEM_SIZE];
  uint8_t symbols[MAX_SYMBOLS];
  uint16_t mem_pos;
} Asm;

void Asm_assemble(Str file, Asm *a);

void write_inst_hex(FILE *file, const uint8_t source[MEM_SIZE]);

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

#endif
