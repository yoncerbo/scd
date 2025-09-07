`include "gated_latch.sv"

module Register (input we, input [7:0] d_in, output [7:0] d_out);

for (genvar i = 0; i < 8; i = i + 1) begin
  GatedLatch latch(we, d_in[i], d_out[i]);
end

endmodule;

module RegisterFile (
  input we,
  input [3:0] sel_in, sel_o1, sel_o2,
  input [7:0] in,
  output [7:0] o1, o2);

wire [7:0] outs [15:0];

for (genvar i = 0; i < 16; i = i + 1) begin
  assign enable = (sel_in == i) & we;
  Register register(enable, in, outs[i]);
end

assign o1 = outs[sel_o1];
assign o2 = outs[sel_o2];

endmodule;
