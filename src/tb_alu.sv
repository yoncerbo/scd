`include "alu.sv"
`include "assert.sv"

module tb_alu;

reg ci, nb, ic, zb;
wire co;
reg [15:0] a, b;
wire [15:0] out;
wire signed [15:0] sout;

assign sout = out;

ALU alu(a, b, ci, nb, ic, zb, out, co);

initial begin
  ci = 0;
  nb = 0;
  ic = 0;
  zb = 0;

  // Addition
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
  a = 65534;
  b = 1;
  #1 `ASSERT(out, 65535);

  // Overflow
  a = 65534;
  b = 2;
  #1 `ASSERT(out, 0);
  `ASSERT(co, 1);

  // Subtraction
  ci = 1;
  nb = 1;
  a = 10;
  b = 4;
  #1 `ASSERT(out, 6);

  // Xor
  ci = 0;
  nb = 0;
  ic = 1;
  a = 10;
  b = 9;
  #1 `ASSERT(out, 3);

  // Increment
  ci = 1;
  nb = 0;
  ic = 0;
  zb = 1;
  a = 16;
  #1 `ASSERT(out, 17);

  // Decrement
  ci = 0;
  nb = 1;
  ic = 0;
  zb = 1;
  a = 16;
  #1 `ASSERT(out, 15);

  // TODO: And
  // TODO: Or
  // TODO: Not
  // TODO: Negate
  // TODO: Shift left
  // TODO: Shift right
  // TODO: Shift right signed

  $finish;
end

endmodule;
