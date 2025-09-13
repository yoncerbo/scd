#include <stdio.h>
#include <string.h>

#include "common.h"
#include "asm.h"

#include "fs.c"
#include "asm.c"

const char *USAGE = \
"USAGE: %s in_path [-o out_path] [-f format]";

typedef enum {
  CMD_FLAG_NONE,
  CMD_FLAG_OUTPUT,
} CmdFlag;

typedef enum {
  OUTPUT_BINARY,
  OUTPUT_VERILOG,
} AsmOutputFormat;

int main(int argc, char *argv[]) {
  // TODO: reading from stdin
  // TODO: writing to stdout
  const char *in_filename;
  const char *out_filename = 0;
  AsmOutputFormat output_format = OUTPUT_BINARY;

  if (argc <= 2) {
    fprintf(stderr, USAGE, argv[0]);
    return 1;
  }
  in_filename = argv[1];

  CmdFlag flag = CMD_FLAG_NONE;
  for (int i = 2; i < argc; ++i) {
    if (argv[i][0] == '-') {
      switch (argv[i][1]) {
        case 'o':
          flag = CMD_FLAG_OUTPUT;
          break;
        case 'V':
          output_format = OUTPUT_VERILOG;
          break;
        case 'B':
          output_format = OUTPUT_BINARY;
          break;
      }
      continue;
    }
    switch (flag) {
      case CMD_FLAG_NONE:
        in_filename = argv[i];
        break;
      case CMD_FLAG_OUTPUT:
        out_filename = argv[i];
        break;
      default: assert(0);
    }
  }

  Str file = map_file_readonly(in_filename);
  assert(file.ptr);

  Asm asm;
  Asm_assemble(file, &asm);

  FILE *out_file;
  switch (output_format) {
    case OUTPUT_VERILOG:
      out_file = fopen(out_filename, "w");
      assert(out_file);
      write_inst_hex(out_file, asm.memory);
      fclose(out_file);
      break;
    case OUTPUT_BINARY:
      out_file = fopen(out_filename, "wb");
      assert(out_file);
      fwrite(asm.memory, MEM_SIZE, 1, out_file);
      fclose(out_file);
      break;
    default: assert(0);
  }

  return 0;
}
