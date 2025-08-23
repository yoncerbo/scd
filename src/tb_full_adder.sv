`include "full_adder.sv"
`include "assert.sv"

module tb_full_adder;

  reg [2:0] in;
  wire [1:0] out;

  FullAdder full_adder(in[0], in[1], in[2], out[0], out[1]);

initial begin
  in = 'b000;
  #1 `ASSERT(out, 0);
  in = 'b001;
  #1 `ASSERT(out, 1);
  in = 'b010;
  #1 `ASSERT(out, 1);
  in = 'b011;
  #1 `ASSERT(out, 2);
  in = 'b100;
  #1 `ASSERT(out, 1);
  in = 'b101;
  #1 `ASSERT(out, 2);
  in = 'b110;
  #1 `ASSERT(out, 2);
  in = 'b111;
  #1 `ASSERT(out, 3);

  $finish;
end

endmodule;
