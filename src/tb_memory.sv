`include "assert.sv"
`include "memory.sv"

module tb_memory;

reg clk, we;

reg [7:0] addr, in;
wire [7:0] out;

Memory mem(clk, we, addr, in, out);

always @(posedge clk) #1 clk <= ~clk;
always @(negedge clk) #1 clk <= ~clk;

initial begin
  clk <= 0;

  addr <= 0;
  in <= 10;
  we <= 1;
  #2 `ASSERT(out, 10);

  addr <= 1;
  in <= 11;
  we <= 1;
  #2 `ASSERT(out, 11);

  addr <= 0;
  in <= 12;
  we <= 0;
  #2 `ASSERT(out, 10);

  $finish();
end

endmodule;
