module ALU (
  input [15:0] a, b,
  input ci, nb, ic, na, xo, no, sr, ss,
  output [15:0] out,
  output co
);

wire [15:0] carry_in, carry_out, carry, x, y, and_ab, z;

assign carry_in[0] = ci;

for (genvar i = 0; i < 16; i = i + 1) begin
  assign y[i] = (b[i] ^ nb);
  assign carry[i] = carry_in[i] & ~ic;
  assign x[i] = a[i] ^ na;
  assign and_ab[i] = x[i] & y[i] & xo;
end

assign z = (x ^ y ^ carry) | and_ab;
assign carry_out = (x & y) | ((x ^ y) & carry);

assign co = carry_out[15];

for (genvar i = 0; i < 15; i = i + 1) begin
  assign carry_in[i + 1] = carry_out[i];
  assign out[i] = sr ? z[i + 1] ^ no : z[i] ^ no;
end

assign out[15] = sr ? (ss ? z[15] ^ no : 0) : z[15] ^ no;

endmodule;
