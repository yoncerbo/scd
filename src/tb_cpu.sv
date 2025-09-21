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
  mem.memory[0] <= 'hF201;
  mem.memory[1] <= 'hB100;
  mem.memory[2] <= 'hB120;

  clk <= 0;

  #4 $display(cpu.register_file.registers[2]);
  #4 $display("r1=", cpu.register_file.registers[1]);
  #4 $display("r1=", cpu.register_file.registers[1]);

  $finish();
end

endmodule;
