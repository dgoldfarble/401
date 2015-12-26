//CONTROLLER1
//*note, syscall, and all link instructions have been assigned alucontrol of addi
always begin
      opcode1 = wInstr1[31:26];
      format1 = wInstr1[25:21];
      rt1     = wInstr1[20:16];
      funct1  = wInstr1[5:0];
  case ( opcode1 )
       6'b000000: begin //SPECIAL
                    case ( funct1 )
                  6'b000000: begin    if(comment1)$display("[EXE]sll,nop\n");end//SLL,NOP
        6'b000010: begin  if(comment1)$display("[EXE]srl\n");end//SRL
        6'b000011: begin  if(comment1)$display("[EXE]sra\n");end//SRA
        6'b000100: begin  if(comment1)$display("[EXE]sllv\n");end//SLLV
        6'b000110: begin  if(comment1)$display("[EXE]srlv\n");end//SRLV
        6'b000111: begin  if(comment1)$display("[EXE]srav\n");end//SRAV
        6'b001000: begin  if(comment1)$display("[EXE]jr\n");end//JR
        6'b001001: begin  if(comment1)$display("[EXE]jalr\n");end//JALR
        6'b001100: begin  if(comment1)$display("[EXE]syscal1\n");end//syscal1*
        6'b001101: begin  if(comment1)$display("[EXE]break\n");end//BREAK*
        6'b010000: begin  if(comment1)$display("[EXE]mfhi\n");end//MFHI
        6'b010001: begin  if(comment1)$display("[EXE]mthi\n");end//MTHI
        6'b010010: begin  if(comment1)$display("[EXE]mflo\n");end//MFLO
        6'b010011: begin  if(comment1)$display("[EXE]mtlo\n");end//MTLO
        6'b011000: begin  if(comment1)$display("[EXE]mult\n");end//mult
        6'b011001: begin  if(comment1)$display("[EXE]multu\n");end//multu
        6'b011010: begin  if(comment1)$display("[EXE]div\n");end//div
        6'b011011: begin  if(comment1)$display("[EXE]divu\n");end//divu
        6'b100000: begin  if(comment1)$display("[EXE]add\n");end//add
        6'b100001: begin  if(comment1)$display("[EXE]addu\n");end//addu
        6'b100010: begin  if(comment1)$display("[EXE]sub\n");end//sub
        6'b100011: begin  if(comment1)$display("[EXE]subu\n");end//subu
        6'b100100: begin  if(comment1)$display("[EXE]and\n");end//and
        6'b100101: begin  if(comment1)$display("[EXE]or\n");end//or
        6'b100110: begin  if(comment1)$display("[EXE]xor\n");end//Xor
        6'b100111: begin  if(comment1)$display("[EXE]nor\n");end//nor
        6'b101010: begin  if(comment1)$display("[EXE]slt\n");end//slt
        6'b101011: begin  if(comment1)$display("[EXE]sltu\n");end//sltu
                          default: $display("Not an Instruction!");
                      endcase
                end
    6'b000001: begin
                  case ( rt1 )
                        5'b00000: begin  if(comment1)$display("[EXE]bltz\n");end//BLTZ
        5'b00001: begin  if(comment1)$display("[EXE]bgez\n");end//BGEZ
        5'b10000: begin  if(comment1)$display("[EXE]bltzal\n");end//BLTZAL
        5'b10001: begin  if(comment1)$display("[EXE]bgezal\n");end//BGEZAL
                          default: $display("Not an Instruction!");
                      endcase
                end
    6'b000010: begin  if(comment1)$display("[EXE]jump\n");end//J
    6'b000011: begin  if(comment1)$display("[EXE]jal\n");end//JAL
    6'b000100: begin  if(comment1)$display("[EXE]beq\n");end//BEQ
    6'b000101: begin  if(comment1)$display("[EXE]bne\n");end//BNE
    6'b000110: begin  if(comment1)$display("[EXE]blez\n");end//BLEZ
    6'b000111: begin  if(comment1)$display("[EXE]bgtz\n");end//BGTZ
    6'b001000: begin  if(comment1)$display("[EXE]addi\n");end//ADDI
    6'b001001: begin  if(comment1)$display("[EXE]addiu\n");end//ADDIU
    6'b001010: begin  if(comment1)$display("[EXE]slti\n");end//SLTI
    6'b001011: begin  if(comment1)$display("[EXE]sltiu\n");end//SLTIU
    6'b001100: begin  if(comment1)$display("[EXE]andi\n");end//ANDI
    6'b001101: begin  if(comment1)$display("[EXE]ori\n");end//ORI
    6'b001110: begin  if(comment1)$display("[EXE]xori\n");end//XorI
    6'b001111: begin  if(comment1)$display("[EXE]lui\n");end//LUI
          6'b010001: begin //COP1
          case( format1 )
                5'b00000: begin  if(comment1)$display("[EXE]mfc1\n");end//MFC1
          5'b00010: begin  if(comment1)$display("[EXE]cfc1\n");end//CFC1
          5'b00100: begin  if(comment1)$display("[EXE]mtc1\n");end//MTC1
          5'b00110: begin  if(comment1)$display("[EXE]ctc1\n");end//CTC1
          5'b01000:begin
                case( wInstr1[16] )
                      1'b1: begin  if(comment1)$display("[EXE]bc1t\n");end//BC1T
                1'b0: begin  if(comment1)$display("[EXE]bc1f\n");end//BC1F
                endcase
          end
          5'b10000:begin
          if( wInstr1[7:4] == 4'b0011 ) begin  if(comment1)$display("[EXE]fp c.cond\n");end//fp c.cond
                else begin
                  case( funct1 )
                    6'b000000: begin  if(comment1)$display("[EXE]fp add\n");end//fp add
                          6'b000001: begin  if(comment1)$display("[EXE]fp sub\n");end//fp sub
                                          6'b000010: begin  if(comment1)$display("[EXE]fp mul\n");end//fp mul
                                          6'b000011: begin  if(comment1)$display("[EXE]fp div\n");end//fp div
                                          6'b000101: begin  if(comment1)$display("[EXE]fp abs\n");end//fp abs
                                          6'b000110: begin  if(comment1)$display("[EXE]fp mov\n");end//MOV.FMT
                                        6'b000111: begin  if(comment1)$display("[EXE]fp neg\n");end//fp neg
                    default: $display("Not an Instruction!");
                      endcase
                end
        end
            5'b10001: begin  if(comment1)$display("[EXE]fp cvt.s\n");end//CVT.S.FMT
                default: $display("Not an Instruction!");
      endcase
    end
    6'b100000: begin  if(comment1)$display("[EXE]lb\n");end//LB
    6'b100001: begin  if(comment1)$display("[EXE]lh\n");end//LH
    6'b100010: begin  if(comment1)$display("[EXE]lwl\n");end//LWL
    6'b100011: begin  if(comment1)$display("[EXE]lw\n");end//LW
          6'b110000: begin if(comment1)$display("[EXE]lwc0\n");end//LWC0
    6'b100100: begin  if(comment1)$display("[EXE]lbu\n");end//LBU
    6'b100101: begin  if(comment1)$display("[EXE]lhu\n");end//LHU
    6'b100110: begin  if(comment1)$display("[EXE]lwr\n");end//LWR
    6'b101000: begin  if(comment1)$display("[EXE]sb\n");end//SB
    6'b101001: begin  if(comment1)$display("[EXE]sh\n");end//SH
    6'b101010: begin  if(comment1)$display("[EXE]swl\n");end//SWL
    6'b101011: begin  if(comment1)$display("[EXE]sw\n");end//SW
          6'b111000: begin if(comment1)$display("[EXE]swc0\n");end//SWC0
    6'b101110: begin  if(comment1)$display("[EXE]swr\n");end//SWR
    6'b110001: begin  if(comment1)$display("[EXE]lwc1\n");end//LWC1
    6'b111001: begin  if(comment1)$display("[EXE]swc1\n");end//SWC1
    6'b010100: begin  if(comment1)$display("[EXE]beql\n");end//BEQL
    6'b010110: begin  if(comment1)$display("[EXE]blezl\n");end//BLEZL
    6'b010101: begin  if(comment1)$display("[EXE]bnel\n");end//BNEL
    default: $display("Not an Instruction!");
  endcase
end
