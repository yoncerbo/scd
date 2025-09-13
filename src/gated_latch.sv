`include "decoder.sv"

module GatedLatch (input we, d_in, output d_out);

  assign set = we & d_in;
  assign res = we & ~d_in;

  assign q = ~(res | nq);
  assign nq = ~(set | q);

  assign d_out = q;

endmodule;

