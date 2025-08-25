`include "gated_latch.sv"

module Register (input we, input [15:0] d_in, output [15:0] d_out);

for (genvar i = 0; i < 16; i = i + 1) begin
  GatedLatch latch(we, d_in[i], d_out[i]);
end

endmodule;

module RegisterFile (
  input we,
  input [3:0] sel_in, sel_o1, sel_o2,
  input [15:0] in,
  output [15:0] o1, o2);

wire [15:0] [15:0] outs;

wire [3:0] sig1, sig2;
Decoder dec1(sel_in[1:0], sig1);
Decoder dec2(sel_in[3:2], sig2);

for (genvar i = 0; i < 4; i = i + 1) begin
  for (genvar j = 0; j < 4; j = j + 1) begin
    assign enable = sig1[j] & sig2[i] & we;
    Register register(enable, in, outs[4 * i + j]);
  end
end

assign o1 = outs[sel_o1];
assign o2 = outs[sel_o2];

endmodule;
