`include "assert.sv"
`include "alu.sv"
`include "inst_rom.sv"
`include "register_file.sv"
`include "memory.sv"

module tb_cpu_v1;

reg clk;

reg [15:0] inst;
wire [2:0] ctrl_flags;
wire mem_we, mem_re, ldi;

assign mem_we = ctrl_flags[2];
assign mem_re = ctrl_flags[1];
assign ldi = ctrl_flags[0];

wire reg_we;
wire [2:0] flags;
wire [7:0] imm;
wire [7:0] alu_flags, alu_out, reg_in, reg_o1, reg_o2, mem_addr;
wire [15:0] mem_out, mem_in;

assign imm = inst[7:0];
assign reg_in = ldi == 0 ? (mem_re == 0 ? alu_out :
  (mem_addr[0] == 0 ? mem_out[7:0] : mem_out[15:8])) : imm;
assign reg_we = ~mem_we;
assign mem_addr = reg_o1;
assign mem_in[7:0] = mem_addr[0] == 0 ? reg_o2 : mem_out[7:0];
assign mem_in[15:8] = mem_addr[0] == 1 ? reg_o2 : mem_out[15:8];

InstRom inst_rom(inst[15:12], alu_flags, ctrl_flags);

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

Memory mem(clk, mem_we, mem_addr[7:1], mem_in, mem_out);

always @(posedge clk) #1 clk <= ~clk;
always @(negedge clk) #1 clk <= ~clk;

initial begin
  clk <= 0;

  inst <= 'hF10a; // load 10 into x1
  #2 `ASSERT(register_file.registers[1], 10);

  inst <= 'hF202; // load 2 into x2
  #2 `ASSERT(register_file.registers[2], 2);

  inst <= 'h0112; // add x1 and x2 into x1
  #2 `ASSERT(register_file.registers[1], 12);

  inst <= 'hF203; // load 3 into x2
  #2 `ASSERT(register_file.registers[2], 3);

  inst <= 'h1112; // subtract x2 from x1 into x1
  #2 `ASSERT(register_file.registers[1], 9);

  inst <= 'hF104; // load 4 into x1
  #2 `ASSERT(register_file.registers[1], 4);

  inst <= 'hF20a; // load 10 into x2
  #2 `ASSERT(register_file.registers[2], 10);

  inst <= 'hD012; // store value in x2 into memory at addresss in x1
  #2 `ASSERT(mem.memory[2], 10);

  inst <= 'hE310; // load into register x3 value in memory at address x1
  #2 `ASSERT(register_file.registers[3], 10);


  $finish();
end

endmodule;
