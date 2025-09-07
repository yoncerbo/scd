module Memory(input clk, we, input [6:0] addr, input [15:0] din, output [15:0] dout);

reg [15:0] memory [127:0];

initial begin
  for (integer i = 0; i < 128; i = i + 1) begin
    memory[i] <= 0;
  end
end

always @(posedge clk) begin
  if (we) memory[addr] <= din;
end

assign dout = memory[addr];

endmodule
