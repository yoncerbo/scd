`include "register_file.sv"
`include "assert.sv"

module tb_register_file;

  reg we;
  reg [3:0] sel_in, sel_o1, sel_o2;
  reg [7:0] in;
  wire [7:0] o1, o2;
  RegisterFile rf(we, sel_in, sel_o1, sel_o2, in, o1, o2);

initial begin
  we = 0;
  sel_in = 0;
  sel_o1 = 0;
  sel_o2 = 0;
  in = 0;

  we = 1;
  sel_in = 0;
  in = 0;
  #1
  we = 0;
  #1 `ASSERT(o1, 0);

  we = 1;
  sel_in = 1;
  in = 1;
  #1
  we = 1;
  sel_o1 = 1;
  #1 `ASSERT(o1, 1);

  we = 1;
  sel_in = 2;
  in = 2;
  #1
  we = 0;
  sel_o1 = 2;
  #1 `ASSERT(o1, 2);

  sel_o1 = 1;
  #1
  `ASSERT(o1, 1);

end

endmodule;
