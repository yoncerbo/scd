
module InstRom(
  input [3:0] opcode,
  output reg [7:0] alu_flags,
  // wpc spc mw mr ld
  output reg [15:0] ctrl_flags
);

initial begin
  alu_flags <= 0;
  ctrl_flags <= 0;
end

always @(opcode) begin
  case (opcode)
    // ci nb ic na xo no rot -
    'h0: begin // add
      alu_flags <= 'b00000000;
      ctrl_flags <= 0;
    end
    'h1: begin // sub
      alu_flags <= 'b11000000;
      ctrl_flags <= 0;
    end
    'h2: begin // xor
      alu_flags <= 'b00100000; 
      ctrl_flags <= 0;
    end
    'h3: begin // nor
      alu_flags <= 'b00101100; 
      ctrl_flags <= 0;
    end
    'h4: begin // and
      alu_flags <= 'b01111100; 
      ctrl_flags <= 0;
    end
    'h5: begin // rot
      alu_flags <= 'b00000010; 
      ctrl_flags <= 0;
    end
    'h6: begin // roi
      alu_flags <= 'b00000010; 
      ctrl_flags <= 'b01000000;
    end
    'h7: begin // jlr
      alu_flags <= 0;
      ctrl_flags <= 'b00011000;
    end
    'h8: begin // jli
      alu_flags <= 0;
      ctrl_flags <= 'b00111000;
    end
    'h9: begin // b--
      alu_flags <= 0;
      ctrl_flags <= 'b10110000;
    end
    'hA: begin // lui
      alu_flags <= 0;
      ctrl_flags <= 'b1000000000;
    end
    'hB: begin // scr
      alu_flags <= 'b00100000; // xor
      ctrl_flags <= 'b10000000000;
    end
    'hC: begin // adi
      alu_flags <= 0;
      ctrl_flags <= 'b01000000;
    end
    'hD: begin // stb
      alu_flags <= 0;
      ctrl_flags <= 'b101000100;
    end
    'hE: begin // ldb
      alu_flags <= 0;
      ctrl_flags <= 'b101000010;
    end
    'hF: begin // ldi
      alu_flags <= 0;
      ctrl_flags <= 'b00000001;
    end
  endcase
end

endmodule;
