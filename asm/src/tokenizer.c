#include "common.h"
#include "asm.h"
#include <assert.h>
#include <ctype.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

uint16_t tokenize(const char *source, Token token_arr[MAX_TOKENS]) {
  uint16_t token_len = 0;
  const char *ch = source;

  while (*ch) {
    const char *start = ch;
    TokenTag tag = TOK_NONE;

    // Skip whitespaces
    while (*ch == ' ') ch++;

    // Skip comments
    if (*ch == '#' || *ch == ';') {
      ch++;
      while (*ch != '\n' || ch == 0) ch++;
      ch++;
      continue;
    }

    if (*ch == '\n') {
      tag = TOK_NEWLINE;
      ch++;
    } else if (*ch == ',') {
      tag = TOK_COMMA;
      ch++;
    } else if (isalpha(*ch) || *ch == '_') {
      ch++;
      while (isalnum(*ch) || *ch == '_') ch++;
      tag = TOK_SYMBOL;
    } else if (isdigit(*ch)) {
      ch++;
      while (isdigit(*ch)) ch++;
      tag = TOK_DECIMAL;
    } else {
      fprintf(stderr, "Unknown character at %d\n", (int)(ch - source));
      exit(1);
    }

    assert(token_len < MAX_TOKENS);
    token_arr[token_len++] = (Token) {
      .tag = tag,
      .start = start - source,
      .len = ch - start,
    };
  }

  return token_len;
}
