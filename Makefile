
out/%: src/%.sv src
	iverilog -I src $< -o $@

clean:
	rm -rf out

assembler:
	mkdir -p out/assembler
	make -C asm release OUT_DIR=../out/assembler RELEASE_EXE=../out/asm

code.txt: code.asm assembler
	out/asm $< $@

cpu: out/tb_cpu code.txt
	$<

