`include "sr_latch.sv"
`include "assert.sv"

module tb_sr_latch;

  reg set, res;
  wire q, nq;
  SRLatch latch(set, res, q, nq);

initial begin
  set = 0;
  res = 1;
  #1 `ASSERT(q, 0);

  res = 0;
  #1 `ASSERT(q, 0);

  set = 1;
  #1 `ASSERT(q, 1);

  set = 0;
  #1 `ASSERT(q, 1);

  res = 1;
  #1 `ASSERT(q, 0);

  $finish;
end

endmodule;
