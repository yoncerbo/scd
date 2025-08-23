`include "full_adder.sv"

module ALU (input [15:0] a, b, input ci, nb, output [15:0] out);

wire [16:0] carry;

assign carry[0] = ci;

for (genvar i = 0; i <= 15; i = i + 1) begin
  FullAdder fa(a[i], b[i] ^ nb, carry[i], out[i], carry[i + 1]);
end

endmodule;
