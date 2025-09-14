module mux2(input i0, i1, s, output o);
  assign o = (i0 & ~s) | (i1 & s);
endmodule;

module BarrelShifter(
  input [7:0] a,
  input [2:0] b,
  output [7:0] o
);

wire [7:0] x, y;

// Shift right by 4
for (genvar i = 0; i < 4; i = i + 1) begin
  mux2 mux_x(a[i], a[i + 4], b[2], x[i]);
end

for (genvar i = 0; i < 4; i = i + 1) begin
  mux2 mux_x(a[i + 4], 1'b0, b[2], x[i + 4]);
end

// Shift right by 2
for (genvar i = 0; i < 6; i = i + 1) begin
  mux2 mux_y(x[i], x[i + 2], b[1], y[i]);
end

for (genvar i = 0; i < 2; i = i + 1) begin
  mux2 mux_y(x[i + 6], 1'b0, b[1], y[i + 6]);
end

// Shift right by 1
for (genvar i = 0; i < 7; i = i + 1) begin
  mux2 mux_o(y[i], y[i + 1], b[0], o[i]);
end

for (genvar i = 0; i < 1; i = i + 1) begin
  mux2 mux_y(y[i + 7], 1'b0, b[0], o[i + 7]);
end

endmodule;
