`include "register_file.sv"
`include "assert.sv"

module tb_register_file;

  reg reg_we;
  reg [15:0] d_in;
  wire [15:0] d_out;

  Register register(reg_we, d_in, d_out);

  reg we;
  reg [3:0] sel_in, sel_o1, sel_o2;
  reg [15:0] in;
  wire [15:0] o1, o2;
  RegisterFile rf(we, sel_in, sel_o1, sel_o2, in, o1, o2);

initial begin
  reg_we = 1;
  d_in = 0;
  #1 `ASSERT(d_out, 0);

  reg_we = 0;
  d_in = 16;
  #1 `ASSERT(d_out, 0);

  reg_we = 1;
  #1 `ASSERT(d_out, 16);

  we = 1;
  sel_in = 0;
  sel_o1 = 0;
  sel_o2 = 0;
  in = 0;
  #1 `ASSERT(o1, 0);

  sel_in = 1;
  in = 1;
  sel_o2 = 1;
  #1 `ASSERT(o2, 1);

end

endmodule;
