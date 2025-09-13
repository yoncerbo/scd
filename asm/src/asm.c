#include "asm.h"
#include "common.h"
#include "inst.h"
#include <stdint.h>
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <stdbool.h>

typedef uint8_t Reg;

void Asm_append_inst_reg(Asm *a, Opcode opcode, Reg r0, Reg r1, Reg r2) {
  assert(a->mem_pos + 1 < MEM_SIZE);
  a->memory[a->mem_pos + 1] = (opcode << 4) | r0;
  a->memory[a->mem_pos + 0] = (r1 << 4) | r2;
  a->mem_pos += 2;
}

void Asm_append_inst_imm(Asm *a, Opcode opcode, Reg r0, uint8_t imm) {
  assert(a->mem_pos + 1 < MEM_SIZE);
  a->memory[a->mem_pos + 1] = (opcode << 4) | r0;
  a->memory[a->mem_pos + 0] = imm;
  a->mem_pos += 2;
}

uint8_t Asm_parse_register(Asm *a) {
  Token tok = a->tokens[a->tok_pos++];
  assert(tok.tag == TOK_SYMBOL);
  assert(a->source[tok.start] == 'x');
  uint8_t reg = atoi(&a->source[tok.start + 1]);
  assert(reg < 16);
  return reg;
}

bool Asm_parse_inst(Asm *a) {
  Token tok;
  do { tok = a->tokens[a->tok_pos++]; } while (tok.tag == TOK_NEWLINE);
  if (tok.tag == TOK_NONE) return 0;
  assert(tok.tag == TOK_SYMBOL);
  assert(tok.len == 3);

  uint8_t op = UINT8_MAX;
  for (uint32_t i = 0; i < INSTRUCTIONS_LEN; ++i) {
    Inst inst = INSTRUCTIONS[i];
    if (inst.name[0] != a->source[tok.start + 0]) continue;
    if (inst.name[1] != a->source[tok.start + 1]) continue;
    if (inst.name[2] != a->source[tok.start + 2]) continue;
    op = inst.opcode;
  }

  switch (op) {
    case OP_LDI:
      uint8_t reg = Asm_parse_register(a);
      assert(a->tokens[a->tok_pos++].tag == TOK_COMMA);
      tok = a->tokens[a->tok_pos++];
      assert(tok.tag == TOK_DECIMAL);
      uint8_t imm = atoi(&a->source[tok.start]);
      assert(a->tokens[a->tok_pos].tag == TOK_NEWLINE ||
        a->tokens[a->tok_pos].tag == TOK_NONE);
      Asm_append_inst_imm(a, op, reg, imm);
      printf("ldi x%d, %d\n", reg, imm);
      break;
    case OP_ADD:
      uint8_t r0 = Asm_parse_register(a);
      assert(a->tokens[a->tok_pos++].tag == TOK_COMMA);
      uint8_t r1 = Asm_parse_register(a);
      assert(a->tokens[a->tok_pos++].tag == TOK_COMMA);
      uint8_t r2 = Asm_parse_register(a);
      assert(a->tokens[a->tok_pos].tag == TOK_NEWLINE ||
        a->tokens[a->tok_pos].tag == TOK_NONE);
      Asm_append_inst_reg(a, op, r0, r1, r2);
      printf("add x%d, x%d, x%d\n", r0, r1, r2);
      break;
    default:
      fprintf(stderr, "Unknown instruction: %.*s\n", tok.len, &a->source[tok.start]);
      exit(1);
  }

  return 1;
}

void Asm_assemble(const char *source, Asm *a) {
  tokenize(source, a->tokens);
  a->source = source;
  a->tok_pos = 0;
  a->mem_pos = 0;

  while (Asm_parse_inst(a));
}

const char *HEX_CHAR = "0123456789ABCDEF";

void write_inst_hex(FILE *file, const uint8_t source[MEM_SIZE]) {
  uint16_t *arr = (void *)source;
  for (int i = 0; i < MEM_SIZE / 2; ++i) {
    fprintf(file, "%04X\n", arr[i]);
  }
}
