#include "asm.h"
#include <stdint.h>
#include <stdio.h>

void Asm_assemble(Str file, Asm *a) {
  *a = (Asm){
    .memory = {
      [1] = 0xF1,
      [0] = 10,
      [3] = 0xF2,
      [2] = 2,
      [5] = 0x03,
      [4] = 0x12,
    },
  };
}

const char *HEX_CHAR = "0123456789ABCDEF";

void write_inst_hex(FILE *file, const uint8_t source[MEM_SIZE]) {
  uint16_t *arr = (void *)source;
  for (int i = 0; i < MEM_SIZE / 2; ++i) {
    fprintf(file, "%04X\n", arr[i]);
  }
}
