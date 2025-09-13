#ifndef INCLUDE_ASM
#define INCLUDE_ASM

#include <stdint.h>
#include <stdio.h>

#define MEM_SIZE 256

typedef struct {
  uint8_t memory[MEM_SIZE];
  uint16_t mem_pos;
} Asm;

void Asm_assemble(Str file, Asm *a);

void write_inst_hex(FILE *file, const uint8_t source[MEM_SIZE]);

typedef enum {
  TOK_DECIMAL,
  TOK_HEX,
  TOK_SYMBOL,
} TokenTag;

typedef struct {
  uint32_t start;
  uint16_t len;
  TokenTag tag;
} Token;

#define MAX_TOKENS 256

void tokenize(Str source, Token token_arr[MAX_TOKENS]);

#endif
