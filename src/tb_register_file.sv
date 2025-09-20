`include "register_file.sv"
`include "assert.sv"

module tb_register_file;

  reg clk;
  reg we;
  reg [3:0] sel_in, sel_o1, sel_o2;
  reg [15:0] in;
  wire [15:0] o0, o1, o2;
  RegisterFile rf(clk, we, sel_in, sel_o1, sel_o2, in, o0, o1, o2);

always @(posedge clk) #1 clk = ~clk;
always @(negedge clk) #1 clk = ~clk;

initial begin
  clk <= 0;
  we <= 0;
  sel_in <= 0;
  sel_o1 <= 0;
  sel_o2 <= 0;
  in <= 0;
  #2

  we <= 1;
  sel_in <= 0;
  in <= 0;
  #2
  we <= 0;
  #2 `ASSERT(o1, 0);

  we <= 1;
  sel_in <= 1;
  in <= 1;
  #2
  we <= 1;
  sel_o1 <= 1;
  #2 `ASSERT(o1, 1);

  we <= 1;
  sel_in <= 2;
  in <= 2;
  #2
  we <= 0;
  sel_o1 <= 2;
  #2 `ASSERT(o1, 2);

  sel_o1 <= 1;
  #2
  `ASSERT(o1, 1);

  $finish();
end

endmodule;
