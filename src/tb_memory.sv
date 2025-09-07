`include "memory.sv"

module tb_memory_1bit;

reg we, re, d_in;
reg [0:3] addr;
wire data;
wire d_out;

assign data = (we == 1'b1) ? d_in : 1'bz;

Memory_1bit mem(we, re, addr, data);

initial begin
  we = 1;
  re = 0;
  addr = 0;
  d_in = 1;

  #1
  we = 0;
  re = 1;
  addr = 0;

  #1
  $display(d_out);

  #1
  $display(d_out);

  
end

endmodule;
