
module ControlUnit(
  input clk, 
  input [7:0] ctrl_flags, reg_o1, reg_o2, alu_out,
  input [15:0] mem_out,
  output [7:0] mem_addr,
  output [15:0] mem_in,
  output reg [15:0] inst,
  output [7:0] reg_in,
  output reg_we, mem_we
);

wire wpc, spc, mem_re, ldi;
wire [7:0] imm;

assign wpc = ctrl_flags[4];
assign spc = ctrl_flags[3];
assign mem_we = ctrl_flags[2];
assign mem_re = ctrl_flags[1];
assign ldi = ctrl_flags[0];

reg fetch_inst;

reg [6:0] pc;

assign imm = inst[7:0];

assign reg_in = spc == 1 ? {pc, 1'b0} : (ldi == 0 ? (mem_re == 0 ? alu_out :
  (mem_addr[0] == 0 ? mem_out[7:0] : mem_out[15:8])) : imm);
assign reg_we = ~(fetch_inst | mem_we);

assign mem_addr = fetch_inst == 1 ? {pc, 1'b0} : reg_o1;
assign mem_in[7:0] = mem_addr[0] == 0 ? reg_o2 : mem_out[7:0];
assign mem_in[15:8] = mem_addr[0] == 1 ? reg_o2 : mem_out[15:8];

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

endmodule;
