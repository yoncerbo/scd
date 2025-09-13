RELEASE_FLAGS = -O2
DEV_FLAGS = -O0 -g3
TEST_FLAGS = -O0 -g3
CFLAGS = -std=c99 -Wall -Wextra -I ./src/headers -I ./src
OUT_DIR = out
RELEASE_EXE = ${OUT_DIR}/release

.PHONY: run

release: src/*
	mkdir -p ${OUT_DIR}
	gcc ${CFLAGS} ${RELEASE_FLAGS} -o $(RELEASE_EXE) src/main.c

build: src/*
	mkdir -p out
	gcc ${CFLAGS} ${DEV_FLAGS} -o ${OUT_DIR}/dev src/main.c

run: build
	./out/dev $(in) -o $(out)

${OUT_DIR}/test_%: src/test_%.c src/*
	mkdir -p ${OUT_DIR}
	gcc ${CFLAGS} ${TEST_FLAGS} -o $@ $<

test_%: ${OUT_DIR}/test_%
	$<
