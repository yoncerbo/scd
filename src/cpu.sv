`include "alu.sv"
`include "inst_rom.sv"
`include "register_file.sv"
`include "control_unit.sv"
`include "memory_controller.sv"

module CPU (
  input clk,
  input [15:0] mem_out,
  output mem_we,
  output [14:0] mem_addr,
  output [15:0] mem_in
);

wire reg_we;
wire [1:0] flags;
wire [15:0] ctrl_flags;
wire [7:0] alu_flags;
wire [15:0] inst, alu_out, reg_in, reg_o0, reg_o1, reg_o2, alu_b;
wire [15:0] mc_addr, mc_in, mc_out;

InstRom inst_rom(inst[15:12], alu_flags, ctrl_flags);

MemoryController mc(clk, mem_we, mem_byte_half, mc_addr, mc_in, mc_out, mem_out, mem_in, mem_addr);

ControlUnit ctrl(
  clk,
  flags,
  ctrl_flags,
  reg_o0, reg_o1, reg_o2, alu_out,
  mc_out, mc_addr, mc_in,
  inst,
  reg_in, alu_b,
  reg_we, mem_we, mem_byte_half
);

RegisterFile register_file(
  clk, reg_we,
  inst[11:8], inst[7:4], inst[3:0],
  reg_in, reg_o0, reg_o1, reg_o2
);

ALU alu(
  reg_o1, alu_b,
  alu_flags[7], alu_flags[6], alu_flags[5], alu_flags[4],
  alu_flags[3], alu_flags[2], alu_flags[1], alu_flags[0],
  alu_out,
  flags[1], flags[0]
);

endmodule
