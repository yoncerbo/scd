#include "emu.h"
#include "common.h"
#include "inst.h"
#include <stdint.h>

void Emu_init(Emu *e) {
  *e = (Emu){0};
}

uint8_t Emu_update_flags(Emu *e, uint16_t value) {
  e->flags = (value == 0) | ((value > 255) >> 1);
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
        uint8_t rot = e->regs[r2] & 7;
        uint8_t rotated_bits = e->regs[r1] & (0xff >> (8 - rot));
        e->regs[r0] = Emu_update_flags(e, (e->regs[r1] >> rot) | rotated_bits << (8 - rot));
        break;
      case OP_ROI:
        rot = r2 & 7;
        rotated_bits = e->regs[r1] & (0xff >> (8 - rot));
        e->regs[r0] = Emu_update_flags(e, (e->regs[r1] >> rot) | rotated_bits << (8 - rot));
        break;
      case OP_JLR:
        uint8_t prev_pc = e->pc;
        e->pc = Emu_update_flags(e, e->regs[r1] + e->regs[r2]) & ~1;
        e->regs[r0] = prev_pc;
        break;
      case OP_JLI:
        e->regs[r0] = e->pc;
        e->pc = imm & ~1;
        break;
      case OP_B__:
        if (cond == COND_ZS && e->flags & ZF) e->pc = imm;
        else if (cond == COND_ZC && e->flags ^ ZF) e->pc = imm;
        else if (cond == COND_CS && e->flags & CF) e->pc = imm;
        else if (cond == COND_CC && e->flags ^ CF) e->pc = imm;
        break;
      case OP_ADI:
        int8_t value = (simm ^ 8) - 8; // sign extend the value - sing bit has value 8
        e->regs[r0] = Emu_update_flags(e, e->regs[r1] + value);
        break;
      case OP_STB:
        uint8_t addr = Emu_update_flags(e, e->regs[r1] + simm);
        switch (addr) {
          case 254:
            printf("%d\n", (int8_t)e->regs[r0]);
            break;
          case 255:
            printf("%d\n", e->regs[r0]);
            break;
          default:
            e->memory[addr] = e->regs[r0];
        }
        break;
      case OP_LDB:
        addr = Emu_update_flags(e, e->regs[r1] + simm);
        e->regs[r0] = e->memory[addr];
        break;
      case OP_LDI:
        e->regs[r0] = imm;
        break;
    }
    e->regs[0] = 0;
  }
}
