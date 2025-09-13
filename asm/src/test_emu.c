#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "common.h"
#include "emu.h"

#include "emu.c"
#include "fs.c"

int main(void) {
  Emu *e = malloc(sizeof *e);
  Emu_init(e);

  const char *filename = "out/insts";
  Str file = map_file_readonly(filename);
  assert(file.ptr);
  assert(file.len = 256);
  memcpy(e->memory, file.ptr, 256);

  // uint16_t *insts = (void *)e->memory;
  // insts[0] = 0xF10A;
  // insts[1] = 0xF202;
  // insts[2] = 0x0312;
  Emu_run(e, 3);

  DEBUGD(e->regs[1]);
  DEBUGD(e->regs[2]);
  DEBUGD(e->regs[3]);
  return 0;
}
