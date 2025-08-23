
out/%: src/%.sv src
	iverilog -I src $< -o $@

clean:
	rm -rf out
