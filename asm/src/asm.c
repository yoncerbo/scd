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

Reg Asm_parse_register(Asm *a) {
  Token tok = a->tokens[a->tok_pos++];
  assert(tok.tag == TOK_SYMBOL);
  assert(a->source[tok.start] == 'x');
  uint8_t reg = atoi(&a->source[tok.start + 1]);
  assert(reg < 16);
  return reg;
}

Token Asm_expected(Asm *a, TokenTag tag) {
  Token tok = a->tokens[a->tok_pos++];
  if (tok.tag == tag) return tok;
  print_error(a->source, tok.start, tok.len, "Expected token %s", TOK_NAME[tag]);
  exit(1);
}

void Asm_end_inst(Asm *a) {
  Token tok = a->tokens[a->tok_pos];
  if (tok.tag == TOK_NEWLINE || tok.tag == TOK_NONE) return;
  print_error(a->source, tok.start, tok.len, "Expected end of instruction (newline or end of file)");
}

void Asm_parse_inst_reg2(Asm *a, Reg *out_r0, Reg *out_r1) {
  *out_r0 = Asm_parse_register(a);
  Asm_expected(a, TOK_COMMA);
  *out_r1 = Asm_parse_register(a);
  Asm_end_inst(a);
}

void Asm_parse_inst_reg3(Asm *a, Reg *out_r0, Reg *out_r1, Reg *out_r2) {
  *out_r0 = Asm_parse_register(a);
  Asm_expected(a, TOK_COMMA);
  *out_r1 = Asm_parse_register(a);
  Asm_expected(a, TOK_COMMA);
  *out_r2 = Asm_parse_register(a);
  Asm_end_inst(a);
}

void Asm_parse_inst_imm2(Asm *a, Reg *out_r0, uint8_t *out_imm) {
    *out_r0 = Asm_parse_register(a);
    Asm_expected(a, TOK_COMMA);
    Token tok = Asm_expected(a, TOK_DECIMAL);
    int32_t imm = atoi(&a->source[tok.start]);
    // TODO: proper range checking
    if (imm > 255) {
      print_error(a->source, tok.start, tok.len, "Immediate value cannot be bigger than 255");
      exit(1);
    }
    Asm_end_inst(a);
    *out_imm = (uint8_t)imm;
}

void Asm_parse_inst_imm1(Asm *a, uint8_t *out_imm) {
    Token tok = Asm_expected(a, TOK_DECIMAL);
    int32_t imm = atoi(&a->source[tok.start]);
    // TODO: proper range checking
    if (imm > 255) {
      print_error(a->source, tok.start, tok.len, "Immediate value cannot be bigger than 255");
      exit(1);
    }
    Asm_end_inst(a);
    *out_imm = (uint8_t)imm;
}

bool Asm_parse_inst(Asm *a) {
  Token tok;
  do { tok = a->tokens[a->tok_pos++]; } while (tok.tag == TOK_NEWLINE);
  if (tok.tag == TOK_NONE) return 0;
  assert(tok.tag == TOK_SYMBOL);
  assert(tok.len == 3);

  Inst result = (Inst){0};
  for (uint32_t i = 0; i < INSTRUCTIONS_LEN; ++i) {
    Inst inst = INSTRUCTIONS[i];
    if (inst.name[0] != a->source[tok.start + 0]) continue;
    if (inst.name[1] != a->source[tok.start + 1]) continue;
    if (inst.name[2] != a->source[tok.start + 2]) continue;
    result = inst;
  }

  if (result.format == FORMAT_NONE) {
    print_error(a->source, tok.start, tok.len, "Unknown instruction");
    exit(1);
  }

  uint8_t r0, r1, r2, imm;

  switch (result.format) {
    case FORMAT_IMM:
      Asm_parse_inst_imm2(a, &r0, &imm);
      Asm_append_inst_imm(a, result.opcode, r0, imm);
      break;
    case FORMAT_SIMM:
      uint8_t r0 = Asm_parse_register(a);
      Asm_expected(a, TOK_COMMA);
      uint8_t r1 = Asm_parse_register(a);
      Asm_expected(a, TOK_COMMA);
      tok = Asm_expected(a, TOK_DECIMAL);
      imm = atoi(&a->source[tok.start]);
      // TODO: proper range checking
      if (imm > 16) {
        print_error(a->source, tok.start, tok.len, "Immediate value cannot be bigger than 16");
        exit(1);
      }
      Asm_end_inst(a);
      Asm_append_inst_reg(a, result.opcode, r0, r1, imm & 15);
      break;
    case FORMAT_REG3:
      Asm_parse_inst_reg3(a, &r0, &r1, &r2);
      Asm_append_inst_reg(a, result.opcode, r0, r1, r2);
      break;
    case FORMAT_COND:
      tok = Asm_expected(a, TOK_DECIMAL);
      imm = atoi(&a->source[tok.start]);
      // TODO: proper range checking
      if (imm > 255) {
        print_error(a->source, tok.start, tok.len, "Immediate value cannot be bigger than 255");
        exit(1);
      }
      Asm_end_inst(a);
      Asm_append_inst_imm(a, OP_B__, result.opcode - 0xf, imm);
      break;
    case FORMAT_PSEUDO:
      switch (result.opcode) {
        case OP_NOP:
          Asm_end_inst(a);
          Asm_append_inst_reg(a, OP_ADD, 0, 0, 0);
          break;
        case OP_MOV:
          Asm_parse_inst_reg2(a, &r0, &r1);
          Asm_append_inst_reg(a, OP_ADD, r0, 0, r1);
          break;
        case OP_NOT:
          Asm_parse_inst_reg2(a, &r0, &r1);
          Asm_append_inst_reg(a, OP_NOR, r0, r1, r1);
          break;
        case OP_SLL:
          Asm_parse_inst_reg2(a, &r0, &r1);
          Asm_append_inst_reg(a, OP_ADD, r0, r1, r1);
          break;
        case OP_NEG:
          Asm_parse_inst_reg2(a, &r0, &r1);
          Asm_append_inst_reg(a, OP_SUB, r0, 0, r1);
          break;
        case OP_JMR:
          Asm_parse_inst_reg2(a, &r0, &r1);
          Asm_append_inst_reg(a, OP_JLR, 0, r0, r1);
          break;
        case OP_JMI:
          Asm_parse_inst_imm1(a, &imm);
          Asm_append_inst_imm(a, OP_JLI, 0, imm);
          break;
        case OP_CSR:
          Asm_parse_inst_reg2(a, &r0, &r1);
          Asm_append_inst_reg(a, OP_JLR, 15, r0, r1);
          break;
        case OP_CSI:
          Asm_parse_inst_imm1(a, &imm);
          Asm_append_inst_imm(a, OP_JLI, 15, imm);
          break;
        case OP_RET:
          Asm_end_inst(a);
          Asm_append_inst_reg(a, OP_JLR, 0, 15, 0);
          break;
        case OP_INC:
          Asm_parse_inst_reg2(a, &r0, &r1);
          Asm_append_inst_reg(a, OP_ADI, r0, r1, 1);
          break;
        case OP_DEC:
          Asm_parse_inst_reg2(a, &r0, &r1);
          Asm_append_inst_reg(a, OP_ADI, r0, r1, -1 & 15);
          break;
        case OP_CMP:
          Asm_parse_inst_reg2(a, &r0, &r1);
          Asm_append_inst_reg(a, OP_SUB, 0, r0, r1);
          break;
        case OP_TST:
          Asm_parse_inst_reg2(a, &r0, &r1);
          Asm_append_inst_reg(a, OP_AND, 0, r0, r1);
          break;
      }
      break;
    default:
      fprintf(stderr, "Unknown instruction: %.*s\n", tok.len, &a->source[tok.start]);
      exit(1);
  }

  return 1;
}

void Asm_assemble(const char *source, Asm *a) {
  *a = (Asm){
    .source = source,
  };
  tokenize(source, a->tokens);

  while (Asm_parse_inst(a));
}

const char *HEX_CHAR = "0123456789ABCDEF";

void write_inst_hex(FILE *file, const uint8_t source[MEM_SIZE]) {
  uint16_t *arr = (void *)source;
  for (int i = 0; i < MEM_SIZE / 2; ++i) {
    fprintf(file, "%04X\n", arr[i]);
  }
}
