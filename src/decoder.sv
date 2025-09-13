
module Decoder (input [1:0] sel, output [3:0] sig);

  assign sig[0] = ~sel[1] & ~sel[0];
  assign sig[1] = ~sel[1] & sel[0];
  assign sig[2] = sel[1] & ~sel[0];
  assign sig[3] = sel[1] & sel[0];

endmodule;

