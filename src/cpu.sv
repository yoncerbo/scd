`include "alu.sv"
`include "inst_rom.sv"
`include "register_file.sv"
`include "control_unit.sv"

module CPU (
  input clk,
  input [15:0] mem_out,
  output mem_we,
  output [7:0] mem_addr,
  output [15:0] mem_in
);

wire reg_we;
wire [2:0] flags;
wire [7:0] ctrl_flags, alu_flags, alu_out, reg_in, reg_o1, reg_o2;
wire [15:0] inst;

InstRom inst_rom(inst[15:12], alu_flags, ctrl_flags);

ControlUnit ctrl(
  clk,
  ctrl_flags,
  reg_o1, reg_o2, alu_out,
  mem_out, mem_addr, mem_in,
  inst,
  reg_in,
  reg_we, mem_we
);

RegisterFile register_file(
  clk, reg_we,
  inst[11:8], inst[7:4], inst[3:0],
  reg_in, reg_o1, reg_o2
);

ALU alu(
  reg_o1, reg_o2,
  alu_flags[7], alu_flags[6], alu_flags[5], alu_flags[4],
  alu_flags[3], alu_flags[2], alu_flags[1], alu_flags[0],
  alu_out,
  flags[2], flags[1], flags[0]
);

endmodule
