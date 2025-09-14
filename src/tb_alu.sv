`include "alu.sv"
`include "assert.sv"

module tb_alu;

reg ci, nb, ic, na, xo, no, sr, ss;
wire cf, zf;
reg [7:0] a, b;
wire [7:0] out;
wire signed [7:0] sout;

assign sout = out;

ALU alu(
  a, b,
  ci, nb, ic, na, xo, no, sr, ss,
  out,
  cf, zf
);

initial begin
  ci = 0;
  nb = 0;
  ic = 0;
  na = 0;
  xo = 0;
  no = 0;
  sr = 0;
  ss = 0;

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
  // TODO: fix
  // `ASSERT(cf, 1);

  // Biggest unsigned number in out
  a = 254;
  b = 1;
  #1 `ASSERT(out, 255);

  // Overflow
  a = 254;
  b = 2;
  #1 `ASSERT(out, 0);
  `ASSERT(cf, 1);
  `ASSERT(zf, 1);

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
  a = 16;
  b = 0;
  #1 `ASSERT(out, 17);

  // Decrement
  ci = 0;
  nb = 1;
  ic = 0;
  a = 16;
  b = 0;
  #1 `ASSERT(out, 15);

  // Not
  ci = 0;
  nb = 1;
  ic = 1;
  a = 16;
  b = 0;
  #1 `ASSERT(out, 239);

  // Negate
  ci = 1;
  nb = 0;
  ic = 0;
  na = 1;
  a = 16;
  b = 0;
  #1 `ASSERT(sout, -16);

  // Or
  ci = 0;
  nb = 0;
  ic = 1;
  na = 0;
  xo = 1;
  a = 10;
  b = 9;
  #1 `ASSERT(out, 11);

  // And
  ci = 0;
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
  ic = 0;
  na = 0;
  nb = 0;
  no = 0;
  xo = 0;
  a = 4;
  b = a;
  #1 `ASSERT(out, 8);

  // Rotate right
  sr = 1;
  a = 4;
  b = 1;
  #1 `ASSERT(out, 2);

  // Rotate left
  sr = 1;
  a = 4;
  b[2:0] = -1;
  #1 `ASSERT(out, 8);

  $finish;
end

endmodule;
