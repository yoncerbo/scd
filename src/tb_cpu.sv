`include "assert.sv"
`include "memory.sv"
`include "cpu.sv"

module tb_cpu_v1;

reg clk;
wire mem_we;
wire [7:0] mem_addr;
wire [15:0] mem_in, mem_out;

CPU cpu(clk, mem_out, mem_we, mem_addr, mem_in);

Memory mem(clk, mem_we, mem_addr[7:1], mem_in, mem_out);

always @(negedge clk) #1 clk <= ~clk;
always @(posedge clk) #1 clk <= ~clk;

initial begin
  for (integer i = 0; i < 128; i = i + 1) begin
    mem.memory[i] <= 0;
  end

  // #1 $readmemh("code.txt", mem.memory, 0, 127);
  
  #1
  mem.memory[0] <= 'hF10A;
  mem.memory[1] <= 'hF20A;
  mem.memory[3] <= 'hD122;

  clk <= 0;

  #4 $display(cpu.register_file.registers[1]);
  #4 $display(cpu.register_file.registers[2]);
  #4 $display(mem.memory[6]);
  // FIXME: why is it getting updated only after 2 cycles?
  #4 $display(mem.memory[6]);

  $finish();
end

endmodule;
