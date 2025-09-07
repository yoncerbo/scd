`include "gated_latch.sv"

module Cell (input we, re, inout data);

  wire d_in, d_out;
  GatedLatch latch(we, d_in, d_out);
  assign data = re ? d_in : d_out;

endmodule;

module Memory_1bit (input we, re, input [3:0] sel, inout data);

  wire [3:0] sig1, sig2;
  Decoder dec1(sel[1:0], sig1);
  Decoder dec2(sel[3:2], sig2);

for (genvar i = 0; i < 4; i = i + 1) begin
  for (genvar j = 0; j < 4; j = j + 1) begin
    assign enable = sig1[i] & sig2[j];
    Cell c(we & enable, re & enable, data);
  end
end

endmodule;
