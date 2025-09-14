`include "barrel_shifter.sv"

// TODO: remove ss - shift signed
module ALU (
  input [7:0] a, b,
  input ci, nb, ic, na, xo, no, rot, ss,
  output [7:0] o,
  output cf, zf
);

wire [7:0] carry_in, carry_out, carry, x, y, and_ab, z, out;

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
  assign out[i] = z[i] ^ no;
end

assign out[7] = z[7] ^ no;

assign cf = carry_out[7];
assign sf = out[7];
assign zf = out == 0;

wire [7:0] barrel_out;
BarrelShifter bs(a, b[2:0], barrel_out);

assign o = rot == 0 ? out : barrel_out;

endmodule;
