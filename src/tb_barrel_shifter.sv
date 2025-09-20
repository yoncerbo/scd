`include "assert.sv"
`include "barrel_shifter.sv"

module tb_barrel_shifter;

reg [15:0] a;
reg [3:0] b;
wire [15:0] o;

BarrelShifter bs(a, b, o);

initial begin
  a <= 'b100000000;
  b <= 4'b1000;
  #1 `ASSERT(o, 1);

  a <= 'b10000;
  b <= 4'b0100;

  #1 `ASSERT(o, 1);

  a <= 'b100;
  b <= 4'b0010;

  #1 `ASSERT(o, 1);

  a <= 'b10;
  b <= 4'b0001;

  #1 `ASSERT(o, 1);

  a <= 'b10000000;
  b <= 4'b0111;

  #1 `ASSERT(o, 1);

  a <= 'b1000000000000000;
  b <= 4'b1111;

  #1 `ASSERT(o, 1);

  $finish();
end

endmodule;
