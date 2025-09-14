module RegisterFile (
  input clk, we,
  input [3:0] sel_in, sel_o1, sel_o2,
  input [7:0] in,
  output [7:0] o0, o1, o2);

reg [7:0] registers [15:0];

initial begin
  for (integer i = 0; i < 16; i = i + 1) begin
    registers[i] <= 0;
  end
end

always @(posedge clk) begin
  if (sel_in && we) registers[sel_in] <= in;
end

assign o0 = registers[sel_in];
assign o1 = registers[sel_o1];
assign o2 = registers[sel_o2];

endmodule;
