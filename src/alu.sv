module ALU (
  input [7:0] a, b,
  input ci, nb, ic, na, xo, no, sr, ss,
  output [7:0] out,
  output cf, zf
);

wire [7:0] carry_in, carry_out, carry, x, y, and_ab, z;

assign carry_in[0] = ci;

for (genvar i = 0; i < 8; i = i + 1) begin
  assign y[i] = (b[i] ^ nb);
  assign carry[i] = carry_in[i] & ~ic;
  assign x[i] = a[i] ^ na;
  assign and_ab[i] = x[i] & y[i] & xo;
end

assign z = (x ^ y ^ carry) | and_ab;
assign carry_out = (x & y) | ((x ^ y) & carry);

for (genvar i = 0; i < 7; i = i + 1) begin
  assign carry_in[i + 1] = carry_out[i];
  assign out[i] = sr ? z[i + 1] ^ no : z[i] ^ no;
end

assign out[7] = sr ? (ss ? z[7] ^ no : 0) : z[7] ^ no;

assign cf = carry_out[7];
assign sf = out[7];
assign zf = out == 0;

endmodule;
