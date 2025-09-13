#ifndef INCLUDE_EMU
#define INCLUDE_EMU

#include "common.h"
#include <stdint.h>

typedef enum {
  ZF = 0,
  CF = 1,
} EmuFlags;

typedef struct {
  uint8_t memory[256];
  uint8_t pc;
  uint8_t regs[16];
  EmuFlags flags;
} Emu;

void Emu_init(Emu *e);
void Emu_run(Emu *e, uint32_t cycles);

#endif
