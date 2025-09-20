`include "barrel_shifter.sv"

// TODO: remove ss - shift signed
module ALU (
  input [15:0] a, b,
  input ci, nb, ic, na, xo, no, rot, ss,
  output [15:0] o,
  output cf, zf
);

wire [16-1:0] carry_in, carry_out, carry, x, y, and_ab, z, out;

assign carry_in[0] = ci;

for (genvar i = 0; i < 16; i = i + 1) begin
  assign y[i] = (b[i] ^ nb);
  assign carry[i] = carry_in[i] & ~ic;
  assign x[i] = a[i] ^ na;
  assign and_ab[i] = x[i] & y[i] & xo;
end

assign z = (x ^ y ^ carry) | and_ab;
assign carry_out = (x & y) | ((x ^ y) & carry);

for (genvar i = 0; i < 16 - 1; i = i + 1) begin
  assign carry_in[i + 1] = carry_out[i];
  assign out[i] = z[i] ^ no;
end

assign out[16-1] = z[16-1] ^ no;

assign cf = carry_out[16-1];
assign sf = out[16-1];
assign zf = out == 0;

wire [15:0] barrel_out;
BarrelShifter bs(a, b[3:0], barrel_out);

assign o = rot == 0 ? out : barrel_out;

endmodule;
