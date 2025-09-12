
module InstRom(
  input [3:0] opcode,
  output reg [7:0] alu_flags,
  // wpc spc mw mr ld
  output reg [7:0] ctrl_flags
);

initial begin
  alu_flags <= 0;
  ctrl_flags <= 0;
end

always @(opcode) begin
  case (opcode)
    // ci nb ic na xo no sr ss
    'h0: begin // add
      alu_flags <= 8'b00000000;
      ctrl_flags <= 0;
    end
    'h1: begin // sub
      alu_flags <= 8'b11000000;
      ctrl_flags <= 0;
    end
    'h2: begin // xor
      alu_flags <= 8'b00100000; 
      ctrl_flags <= 0;
    end
    'h3: begin // nor
      alu_flags <= 8'b00101100; 
      ctrl_flags <= 0;
    end
    'h4: begin // and
      alu_flags <= 8'b01111100; 
      ctrl_flags <= 0;
    end
    'h5: begin // srl
      alu_flags <= 8'b00000010; 
      ctrl_flags <= 0;
    end
    'h6: begin // sra
      alu_flags <= 8'b00000011; 
      ctrl_flags <= 0;
    end
    'h7: begin // jlr
      alu_flags <= 0;
      ctrl_flags <= 8'b00011000;
    end
    'h8: begin // jli
      alu_flags <= 0;
      ctrl_flags <= 8'b00101000;
    end
    'hC: begin // adi
      alu_flags <= 0;
      ctrl_flags <= 8'b01000000;
    end
    'hD: begin // stb
      alu_flags <= 0;
      ctrl_flags <= 8'b00000100;
    end
    'hE: begin // ldb
      alu_flags <= 0;
      ctrl_flags <= 8'b00000010;
    end
    'hF: begin // ldi
      alu_flags <= 0;
      ctrl_flags <= 8'b00000001;
    end
    default: begin
      alu_flags <= 0;
      ctrl_flags <= 0;
    end
  endcase
end

endmodule;
