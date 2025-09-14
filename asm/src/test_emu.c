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

  Emu_run(e, 32);
  return 0;
}
