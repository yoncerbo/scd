#include "asm.h"

#include "tokenizer.c"
#include <stdint.h>
#include <stdio.h>

int main(void) {
  const char *source = " ; comment\n ldi x1, 10\n # comment\n add x1, x1, x1 \n";
  Token token_arr[MAX_TOKENS];
  uint16_t token_len = tokenize(source, token_arr);
  for (int i = 0; i < token_len; ++i) {
    Token tok = token_arr[i];
    printf("%s %d:%d\n", TOK_NAME[tok.tag], tok.start, tok.len);
  }
  return 0;
}
