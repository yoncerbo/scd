module Memory(input clk, we, input [7:0] addr, din, output [7:0] dout);

reg [7:0] memory [255:0];

initial begin
  for (integer i = 0; i < 256; i = i + 1) begin
    memory[i] <= 0;
  end
end

always @(posedge clk) begin
  if (we) memory[addr] <= din;
end

assign dout = memory[addr];

endmodule
