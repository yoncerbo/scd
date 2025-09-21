#ifndef INCLUDE_EMU
#define INCLUDE_EMU

#define MEM_SIZE KB(10)

#include "common.h"
#include <stdint.h>

typedef enum {
  ZF = 0,
  CF = 1,
} EmuFlags;

typedef struct {
  uint8_t memory[MEM_SIZE];
  uint16_t pc;
  uint16_t regs[16];
  uint16_t sc_regs[16];
  EmuFlags flags;
} Emu;

void Emu_init(Emu *e);
void Emu_run(Emu *e, uint32_t cycles);

#endif
