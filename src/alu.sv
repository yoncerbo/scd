module ALU (input [15:0] a, b, input ci, nb, ic, zb, output [15:0] out, output co);

wire [15:0] carry_in, carry_out, carry, x, y;

assign carry_in[0] = ci;
assign x = a;

for (genvar i = 0; i < 16; i = i + 1) begin
  assign y[i] = (b[i] & ~zb) ^ nb;
  assign carry[i] = carry_in[i] & ~ic;
end

assign out = x ^ y ^ carry;
assign carry_out = (x & y) | ((x ^ y) & carry);

assign co = carry_out[15];

for (genvar i = 0; i < 15; i = i + 1) begin
  assign carry_in[i + 1] = carry_out[i];
end

endmodule;
