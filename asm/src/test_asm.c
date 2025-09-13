#include "common.h"
#include "asm.h"

#include "asm.c"
#include "tokenizer.c"
#include "error_reporting.c"

#include <stdint.h>
#include <stdio.h>

int main(void) {
  Asm assembler;
  Asm *a = &assembler;

  const char *source = " ldi x1, 10\n ldi x2, 2\n add x3, x1, x2";
  Asm_assemble(source, a);

  return 0;
}
