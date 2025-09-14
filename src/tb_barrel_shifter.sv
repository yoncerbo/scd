`include "assert.sv"
`include "barrel_shifter.sv"

module tb_barrel_shifter;

reg [7:0] a;
reg [2:0] b;
wire [7:0] o;

BarrelShifter bs(a, b, o);

initial begin
  a <= 8'b00010000;
  b <= 3'b100;

  #1 `ASSERT(o, 1);

  a <= 8'b00000100;
  b <= 3'b010;

  #1 `ASSERT(o, 1);

  a <= 8'b00000010;
  b <= 3'b001;

  #1 `ASSERT(o, 1);

  a <= 8'b10000000;
  b <= 3'b111;

  #1 `ASSERT(o, 1);
  $finish();

  $finish();
end

endmodule;
