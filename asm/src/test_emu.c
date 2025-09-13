#include <stdlib.h>
#include <stdio.h>

#include "common.h"
#include "emu.h"

#include "emu.c"

int main(void) {
  Emu *e = malloc(sizeof *e);
  Emu_init(e);

  uint16_t *insts = (void *)e->memory;

  insts[0] = 0xF10A;
  insts[1] = 0xF202;
  insts[2] = 0x0312;
  Emu_run(e, 3);
  DEBUGD(e->regs[1]);
  DEBUGD(e->regs[2]);
  DEBUGD(e->regs[3]);
  return 0;
}
