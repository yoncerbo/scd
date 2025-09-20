module mux2(input i0, i1, s, output o);
  assign o = (i0 & ~s) | (i1 & s);
endmodule;

module BarrelShifter(
  input [15:0] a,
  input [3:0] b,
  output [15:0] o
);

wire [15:0] x, y, z;

// Rotate by 8 bits
for (genvar i = 0; i < 8; i = i + 1) begin
  mux2 mux_x(a[i], a[i + 8], b[3], x[i]);
end

for (genvar i = 0; i < 8; i = i + 1) begin
  mux2 mux_x(a[i + 8], a[i], b[3], x[i + 8]);
end

// Rotate by 4 bits
for (genvar i = 0; i < 12; i = i + 1) begin
  mux2 mux_y(x[i], x[i + 4], b[2], y[i]);
end

for (genvar i = 0; i < 4; i = i + 1) begin
  mux2 mux_y(x[i + 12], x[i], b[2], y[i + 12]);
end

// Rotate by 2 bits
for (genvar i = 0; i < 14; i = i + 1) begin
  mux2 mux_z(y[i], y[i + 2], b[1], z[i]);
end

for (genvar i = 0; i < 2; i = i + 1) begin
  mux2 mux_z(y[i + 14], x[i], b[1], z[i + 14]);
end

// Rotate by 1 bit
for (genvar i = 0; i < 15; i = i + 1) begin
  mux2 mux_o(z[i], z[i + 1], b[0], o[i]);
end

for (genvar i = 0; i < 1; i = i + 1) begin
  mux2 mux_o(z[i + 15], z[i], b[0], o[i + 15]);
end

endmodule;
