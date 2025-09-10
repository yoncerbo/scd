module Memory(input clk, we, input [6:0] addr, input [15:0] din, output [15:0] dout);

reg [15:0] memory [127:0];

always @(posedge clk) begin
  if (we) memory[addr] <= din;
end

assign dout = memory[addr];

endmodule
