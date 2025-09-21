
module MemoryController(
  input clk, we, byte_half,
  input [15:0] addr, data_in,
  output [15:0] data_out,
  input [15:0] mem_out,
  output [15:0] mem_in,
  output [14:0] mem_addr
);

assign mem_addr = addr[15:1];

assign data_out = byte_half == 1 ? mem_out : {8'b0, addr[0] == 0 ? mem_out[7:0] : mem_out[15:8]};

assign mem_in = byte_half == 1 ? data_in : (
  addr[0] == 0 ? {mem_out[15:8], data_in[7:0]} : {data_in[7:0], mem_out[7:0]});

endmodule;
