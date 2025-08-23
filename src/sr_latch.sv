
module SRLatch (input set, reset, output q, nq);

  assign q = ~(reset | nq);
  assign nq = ~(set | q);

endmodule;
