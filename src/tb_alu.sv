`include "alu.sv"
`include "assert.sv"

module tb_alu;

reg ci, nb, ic, zb, na, xo, no;
wire co;
reg [15:0] a, b;
wire [15:0] out;
wire signed [15:0] sout;

assign sout = out;

ALU alu(a, b, ci, nb, ic, zb, na, xo, no, out, co);

initial begin
  ci = 0;
  nb = 0;
  ic = 0;
  zb = 0;
  na = 0;
  xo = 0;
  no = 0;

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

  // Not
  ci = 0;
  zb = 1;
  nb = 1;
  ic = 1;
  a = 16;
  #1 `ASSERT(out, 65519);

  // Negate
  ci = 1;
  zb = 1;
  nb = 0;
  ic = 0;
  na = 1;
  a = 16;
  #1 `ASSERT(sout, -16);

  // Or
  ci = 0;
  zb = 0;
  nb = 0;
  ic = 1;
  na = 0;
  xo = 1;
  a = 10;
  b = 9;
  #1 `ASSERT(out, 11);

  // And
  ci = 0;
  zb = 0;
  ic = 1;
  na = 1;
  nb = 1;
  no = 1;
  xo = 1;
  a = 10;
  b = 9;
  #1 `ASSERT(out, 8);

  // Shift left - multiply by 2
  // 2x = x + x, also sets carry out
  ci = 0;
  zb = 0;
  ic = 0;
  na = 0;
  nb = 0;
  no = 0;
  xo = 0;
  a = 4;
  b = a;
  #1 `ASSERT(out, 8);

  // Shift right

  // TODO: Shift right
  // TODO: Shift right signed

  $finish;
end

endmodule;
