`include "assert.sv"
`include "alu.sv"
`include "inst_rom.sv"
`include "register_file.sv"

module tb_cpu_v1;

reg clk;
reg [15:0] inst;

wire ldi;
wire [2:0] flags;
wire [7:0] imm;
wire [7:0] alu_flags, alu_out, alu_a, alu_b, reg_in;

assign imm = inst[7:0];
assign reg_in = ldi == 0 ? alu_out : imm;

InstRom inst_rom(inst[15:12], alu_flags, ldi);

RegisterFile register_file(
  clk, inst[11:8], inst[7:4], inst[3:0],
  reg_in, alu_a, alu_b
);

ALU alu(
  alu_a, alu_b,
  alu_flags[7], alu_flags[6], alu_flags[5], alu_flags[4],
  alu_flags[3], alu_flags[2], alu_flags[1], alu_flags[0],
  alu_out,
  flags[2], flags[1], flags[0]
);

always @(posedge clk) begin
  #1 clk <= ~clk;
end

always @(negedge clk) begin
  #1 clk <= ~clk;
end

initial begin
  clk <= 0;
  inst <= 'hf10a; // load 10 into x1
  #2 `ASSERT(register_file.registers[1], 10);

  inst <= 'hf202; // load 2 into x2
  #2 `ASSERT(register_file.registers[2], 2);

  inst <= 'h0112; // add x1 and x2 into x1
  #2 `ASSERT(register_file.registers[1], 12);

  inst <= 'hf203; // load 3 into x2
  #2 `ASSERT(register_file.registers[2], 3);

  inst <= 'h1112; // subtract x2 from x1 into x1
  #2 `ASSERT(register_file.registers[1], 9);

  $finish();
end

endmodule;
