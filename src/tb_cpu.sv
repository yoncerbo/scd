`include "assert.sv"
`include "memory.sv"
`include "cpu.sv"

module tb_cpu_v1;

reg clk;
wire mem_we;
wire [15:0] mem_addr, mem_in, mem_out;

CPU cpu(clk, mem_out, mem_we, mem_addr[15:1], mem_in);

Memory mem(clk, mem_we, mem_addr[7:1], mem_in, mem_out);

always @(negedge clk) #1 clk <= ~clk;
always @(posedge clk) #1 clk <= ~clk;

initial begin
  for (integer i = 0; i < 128; i = i + 1) begin
    mem.memory[i] <= 0;
  end

  // #1 $readmemh("code.txt", mem.memory, 0, 127);

  cpu.ctrl.sc_regs[0] <= 255;
  
  #1
  mem.memory[0] <= 0;
  mem.memory[1] <= 0;
  mem.memory[2] <= 'h81ff;

  clk <= 0;

  #4
  #4
  #4
  $display("reg=%0d", cpu.register_file.registers[1]);
  $display("pc=%0d", {cpu.ctrl.pc, 1'b0});
  #4
  $display("reg=%0d", cpu.register_file.registers[1]);
  $display("pc=%0d", {cpu.ctrl.pc, 1'b0});
  #4
  $display("reg=%0d", cpu.register_file.registers[1]);
  $display("pc=%0d", {cpu.ctrl.pc, 1'b0});

  $finish();
end

endmodule;
