`include "alu.sv"
`include "inst_rom.sv"
`include "register_file.sv"

module CPU (
  input clk,
  input [15:0] mem_out,
  output [7:0] mem_addr,
  output [15:0] mem_in
);

reg fetch_inst;

reg [6:0] pc;
reg [15:0] inst;
wire [7:0] ctrl_flags;
wire wpc, spc, mem_we, mem_re, ldi;

assign wpc = ctrl_flags[4];
assign spc = ctrl_flags[3];
assign mem_we = ctrl_flags[2];
assign mem_re = ctrl_flags[1];
assign ldi = ctrl_flags[0];

wire reg_we;
wire [2:0] flags;
wire [7:0] imm;
wire [7:0] alu_flags, alu_out, reg_in, reg_o1, reg_o2;

assign imm = inst[7:0];
assign reg_in = spc == 1 ? {pc, 1'b0} : (ldi == 0 ? (mem_re == 0 ? alu_out :
  (mem_addr[0] == 0 ? mem_out[7:0] : mem_out[15:8])) : imm);
assign reg_we = ~(fetch_inst | mem_we);

assign mem_addr = fetch_inst == 1 ? {pc, 1'b0} : reg_o1;
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

initial begin
  fetch_inst <= 1;
  inst <= 0;
  pc <= 0;
end

always @(posedge clk) begin
  if (fetch_inst) begin
    inst <= mem_out;
    pc <= pc + 1;
  end else if (wpc) begin
    pc <= alu_out[7:1];
  end
  fetch_inst = ~fetch_inst;
end

endmodule
