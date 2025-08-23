`include "alu.sv"
`include "assert.sv"

module tb_alu;

reg ci, nb;
reg [15:0] a, b;
wire [15:0] out;
wire signed [15:0] sout;

assign sout = out;

ALU alu(a, b, ci, nb, out);

initial begin

  // Addition
  ci = 0;
  nb = 0;
  a = 9;
  b = 8;
  #1 `ASSERT(out, 17);

  // Add negative
  a = 7;
  b = -6;
  #1 `ASSERT(out, 1);

  // Negative number in out
  a = 7;
  b = -9;
  #1 `ASSERT(sout, -2);

  // Biggest unsigned number in out
  a = 65533;
  b = 1;
  #1 `ASSERT(out, 65534);

  // Subtraction
  ci = 1;
  nb = 1;
  a = 10;
  b = 4;
  #1 `ASSERT(out, 6);



  // Subtraction
  $finish;
end

endmodule;
