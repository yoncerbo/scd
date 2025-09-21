#include "emu.h"
#include "common.h"
#include "inst.h"
#include <stdint.h>

void Emu_init(Emu *e) {
  *e = (Emu){0};
}

uint16_t Emu_update_flags(Emu *e, uint32_t value) {
  e->flags = (value == 0) | ((value > UINT16_MAX) >> 1);
  return value;
}

void Emu_run(Emu *e, uint32_t cycles) {
  for (uint32_t i = 0; i < cycles; ++i) {
    uint16_t inst = ((uint16_t *)e->memory)[e->pc >> 1];
    e->pc += 2;
    Opcode op = inst >> 12;
    uint8_t r0 = (inst >> 8) & 15;
    uint8_t r1 = (inst >> 4) & 15;
    uint8_t r2 = inst & 15;
    uint8_t imm = inst & 255;
    uint8_t simm = r2;
    uint8_t cond = r0;
    switch (op) {
      case OP_ADD:
        e->regs[r0] = Emu_update_flags(e, e->regs[r1] + e->regs[r2]);
        break;
      case OP_SUB:
        e->regs[r0] = Emu_update_flags(e, e->regs[r1] - e->regs[r2]);
        break;
      case OP_XOR:
        e->regs[r0] = Emu_update_flags(e, e->regs[r1] ^ e->regs[r2]);
        break;
      case OP_NOR:
        e->regs[r0] = Emu_update_flags(e, ~(e->regs[r1] | e->regs[r2]));
        break;
      case OP_AND:
        e->regs[r0] = Emu_update_flags(e, e->regs[r1] & e->regs[r2]);
        break;
      case OP_ROT:
        uint8_t rot = e->regs[r2] & 15;
        uint8_t rotated_bits = e->regs[r1] & (0xffff >> (16 - rot));
        e->regs[r0] = Emu_update_flags(e, (e->regs[r1] >> rot) | rotated_bits << (16 - rot));
        break;
      case OP_ROI:
        rot = r2 & 15;
        rotated_bits = e->regs[r1] & (0xffff >> (16 - rot));
        e->regs[r0] = Emu_update_flags(e, (e->regs[r1] >> rot) | rotated_bits << (16 - rot));
        break;
      case OP_JLR:
        uint8_t prev_pc = e->pc;
        e->pc = Emu_update_flags(e, e->regs[r1] + e->regs[r2]) & ~1;
        e->regs[r0] = prev_pc;
        break;
      case OP_JAL:
        prev_pc = e->pc;
        e->pc = Emu_update_flags(e, e->pc + (int16_t)imm << 1) & ~1;
        e->regs[r0] = prev_pc;
        break;
      case OP_B__:
        uint8_t offset = 0;
        if (cond == COND_ZS && e->flags & ZF) offset = imm;
        else if (cond == COND_ZC && e->flags ^ ZF) offset = imm;
        else if (cond == COND_CS && e->flags & CF) offset = imm;
        else if (cond == COND_CC && e->flags ^ CF) offset = imm;
        e->pc = Emu_update_flags(e, e->pc + (int16_t)offset << 1) & ~1;
        break;
      case OP_ADI:
        int16_t value = (simm ^ 8) - 8; // sign extend the value - sing bit has value 8
        e->regs[r0] = Emu_update_flags(e, e->regs[r1] + value);
        break;
      case OP_ST_:
        uint8_t byte_or_half = (inst >> 3) & 1;
        uint16_t addr = Emu_update_flags(e, e->regs[r1] + ((simm & 7) << byte_or_half));
        switch (addr) {
          case 0xff00:
            printf("%d\n", (uint16_t)e->regs[r0]);
            break;
          case 0xff02:
            printf("%d\n", (int16_t)e->regs[r0]);
            break;
          default:
            if (byte_or_half) {
              e->memory[addr & ~1] = (uint8_t)(e->regs[r0] >> 8);
              e->memory[addr | 1] = (uint8_t)e->regs[r0];
            }
            else e->memory[addr] = (uint8_t)e->regs[r0];
        }
        break;
      case OP_LD_:
        byte_or_half = (inst >> 3) & 1;
        addr = Emu_update_flags(e, e->regs[r1] + ((simm & 7) << byte_or_half));
        e->regs[r0] = byte_or_half ? (
            ((uint16_t)e->memory[addr & ~1] << 8) | e->memory[addr | 1]
        ) : e->memory[addr];
        break;
      case OP_LDI:
        e->regs[r0] = (int16_t)((imm ^ 128) - 128);
        break;
      case OP_LUI:
        e->regs[r0] = (e->regs[r0] & 255) | ((uint16_t)imm << 8);
        break;
      case OP_SCR:
        uint16_t new_val = e->sc_regs[simm & 15] ^ e->regs[r1];
        e->regs[r0] = new_val;
        e->sc_regs[simm & 15] = new_val;
        break;
    }
    e->regs[0] = 0;
  }
}
