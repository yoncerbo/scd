`include "decoder.sv"

module ControlUnit (
  input clk,
  input [1:0] flags,
  input [15:0] ctrl_flags,
  input [15:0] reg_o0, reg_o1, reg_o2, alu_out, mem_out,
  output [15:0] mem_addr, mem_in,
  output reg [15:0] inst,
  output [15:0] reg_in, alu_b,
  output reg_we, mem_we, mem_byte_half
);

wire cond, adi, ipc, wpc, spc, mem_re, ldi, imm3;
wire [7:0] imm;

assign lui = ctrl_flags[9];
assign imm3 = ctrl_flags[8];
assign cond = ctrl_flags[7];
assign adi = ctrl_flags[6];
assign ipc = ctrl_flags[5];
assign wpc = ctrl_flags[4];
assign spc = ctrl_flags[3];
assign mem_we = ctrl_flags[2];
assign mem_re = ctrl_flags[1];
assign ldi = ctrl_flags[0];

reg fetch_inst;

reg [14:0] pc;

assign imm = inst[7:0];
wire [15:0] imm16 = { imm[7], imm[7], imm[7], imm[7], imm[7], imm[7], imm[7], imm[7], imm };
wire [15:0] simm16 = { imm[3], imm[3], imm[3], imm[3], imm[3], imm[3], imm[3],
  imm[3], imm[3], imm[3], imm[3], imm[3], imm[3:0] };

assign reg_in = spc == 1 ? {pc, 1'b0} : (ldi == 1 ? imm16 : (
  mem_re == 1 ? mem_out : (lui == 1 ? {imm, reg_o0[7:0]} : alu_out)));
assign reg_we = ~(fetch_inst | mem_we);

assign mem_addr = fetch_inst == 1 ? {pc, 1'b0} : alu_out;
assign mem_in = reg_o0;

assign mem_byte_half = fetch_inst == 1 ? 1'b1 : inst[3];

assign alu_b = adi == 1 ? simm16 : (imm3 == 1 ? {13'b0, inst[2:0]} : reg_o2);

initial begin
  fetch_inst <= 1;
  inst <= 0;
  pc <= 0;
end

wire [3:0] cond_type;

Decoder flags_dec(flags, cond_type);

always @(posedge clk) begin
  if (fetch_inst) begin
    inst <= mem_out;
    pc <= pc + 1;
  end else begin
    if ((cond_type[0] & flags[0]) | (cond_type[1] & flags[1]) |
      (cond_type[2] & ~flags[0]) | (cond_type[2] & ~flags[1]) | ~cond) begin
      if (wpc) pc <= alu_out[7:1];
      else if (ipc) pc <= imm[7:1];
    end
  end
  fetch_inst = ~fetch_inst;
end

endmodule;
