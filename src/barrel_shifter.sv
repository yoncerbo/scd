module mux2(input i0, i1, s, output o);
  assign o = (i0 & ~s) | (i1 & s);
endmodule;

module BarrelShifter(
  input [7:0] a,
  input [2:0] b,
  output [7:0] o
);

wire [7:0] x, y, z;

assign x = a;

// Rotate by 4 bits
for (genvar i = 0; i < 4; i = i + 1) begin
  mux2 mux_y(x[i], x[i + 4], b[2], y[i]);
end

for (genvar i = 0; i < 4; i = i + 1) begin
  mux2 mux_y(x[i + 4], x[i], b[2], y[i + 4]);
end

// Rotate by 2 bits
for (genvar i = 0; i < 6; i = i + 1) begin
  mux2 mux_z(y[i], y[i + 2], b[1], z[i]);
end

for (genvar i = 0; i < 2; i = i + 1) begin
  mux2 mux_z(y[i + 6], x[i], b[1], z[i + 6]);
end

// Rotate by 1 bits
for (genvar i = 0; i < 7; i = i + 1) begin
  mux2 mux_o(z[i], z[i + 1], b[0], o[i]);
end

for (genvar i = 0; i < 1; i = i + 1) begin
  mux2 mux_o(z[i + 7], z[i], b[0], o[i + 7]);
end

endmodule;
