#include <stdio.h>

#include "common.h"
#include "asm.h"

#include "fs.c"
#include "asm.c"

int main(int argc, char *argv[]) {
  const char *in_filename;
  const char *out_filename = "insts.txt";
  switch (argc) {
    case 2: // cmd in
      in_filename = argv[1];
      break;
    case 3: // cmd in out
      in_filename = argv[1];
      out_filename = argv[2];
      break;
    default:
      fprintf(stderr, "USAGE: %s in_path [out_path]\n", argv[0]);
      return 1;
  }

  Str file = map_file_readonly(in_filename);

  Asm asm;
  Asm_assemble(file, &asm);

  FILE *out_file = fopen(out_filename, "w");
  write_inst_hex(out_file, asm.memory);
  fclose(out_file);
  return 0;
}
