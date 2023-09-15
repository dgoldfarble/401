//-----------------------------------------
//         Instruction Logger
//-----------------------------------------

`timescale 1ns / 1ps

module instr_logger (
    CLK,
    Instr1
);
  parameter comment = 0;
  parameter name = "??";
  input [31:0] Instr1;  //_IN;
  input CLK;
  reg [5:0] opcode1;
  reg [5:0] funct1;
  reg [4:0] format1;
  reg [4:0] rt1;
  always @(posedge CLK) begin
    if (comment) begin
      opcode1 = Instr1[31:26];
      format1 = Instr1[25:21];
      rt1     = Instr1[20:16];
      funct1  = Instr1[5:0];
      case (opcode1)
        6'b000000: begin  //SPECIAL
          case (funct1)
            6'b000000: $write("[%s]sll,nop\t", name);  //SLL,NOP
            6'b100001: $write("[%s]addu\t", name);  //addu
            6'b000010: $write("[%s]srl\t", name);  //SRL
            6'b000011: $write("[%s]sra\t", name);  //SRA
            6'b000100: $write("[%s]sllv\t", name);  //SLLV
            6'b000110: $write("[%s]srlv\t", name);  //SRLV
            6'b000111: $write("[%s]srav\t", name);  //SRAV
            6'b001000: $write("[%s]jr\t", name);  //JR
            6'b001001: $write("[%s]jalr\t", name);  //JALR
            6'b001100: $write("[%s]syscal1\t", name);  //syscal1*
            6'b001101: $write("[%s]break\t", name);  //BREAK*
            6'b010000: $write("[%s]mfhi\t", name);  //MFHI
            6'b010001: $write("[%s]mthi\t", name);  //MTHI
            6'b010010: $write("[%s]mflo\t", name);  //MFLO
            6'b010011: $write("[%s]mtlo\t", name);  //MTLO
            6'b011000: $write("[%s]mult\t", name);  //mult
            6'b011001: $write("[%s]multu\t", name);  //multu
            6'b011010: $write("[%s]div\t", name);  //div
            6'b011011: $write("[%s]divu\t", name);  //divu
            6'b100000: $write("[%s]add\t", name);  //add
            6'b100010: $write("[%s]sub\t", name);  //sub
            6'b100011: $write("[%s]subu\t", name);  //subu
            6'b100100: $write("[%s]and\t", name);  //and
            6'b100101: $write("[%s]or\t", name);  //or
            6'b100110: $write("[%s]xor\t", name);  //Xor
            6'b100111: $write("[%s]nor\t", name);  //nor
            6'b101010: $write("[%s]slt\t", name);  //slt
            6'b101011: $write("[%s]sltu\t", name);  //sltu
            default:   $write("Not an Instruction!", name);
          endcase
        end
        6'b000001: begin
          case (rt1)
            5'b00000: $write("[%s]bltz\n", name);  //BLTZ
            5'b00001: $write("[%s]bgez\n", name);  //BGEZ
            5'b10000: $write("[%s]bltzal\n", name);  //BLTZAL
            5'b10001: $write("[%s]bgezal\n", name);  //BGEZAL
            default:  $write("Not an Instruction!", name);
          endcase
        end
        6'b000010: $write("[%s]jump\n", name);  //J
        6'b000011: $write("[%s]jal\n", name);  //JAL
        6'b000100: $write("[%s]beq\n", name);  //BEQ
        6'b000101: $write("[%s]bne\n", name);  //BNE
        6'b000110: $write("[%s]blez\n", name);  //BLEZ
        6'b000111: $write("[%s]bgtz\n", name);  //BGTZ
        6'b001000: $write("[%s]addi\n", name);  //ADDI
        6'b001001: $write("[%s]addiu\n", name);  //ADDIU
        6'b001010: $write("[%s]slti\n", name);  //SLTI
        6'b001011: $write("[%s]sltiu\n", name);  //SLTIU
        6'b001100: $write("[%s]andi\n", name);  //ANDI
        6'b001101: $write("[%s]ori\n", name);  //ORI
        6'b001110: $write("[%s]xori\n", name);  //XorI
        6'b001111: $write("[%s]lui\n", name);  //LUI
        6'b010001: begin  //COP1
          case (format1)
            5'b00000: $write("[%s]mfc1\n", name);  //MFC1
            5'b00010: $write("[%s]cfc1\n", name);  //CFC1
            5'b00100: $write("[%s]mtc1\n", name);  //MTC1
            5'b00110: $write("[%s]ctc1\n", name);  //CTC1
            5'b01000: begin
              case (Instr1[16])
                1'b1: $write("[%s]bc1t\n", name);  //BC1T
                1'b0: $write("[%s]bc1f\n", name);  //BC1F
              endcase
            end
            5'b10000: begin
              if (Instr1[7:4] == 4'b0011) $write("[%s]fp c.cond\n", name);  //fp c.cond
              else begin
                case (funct1)
                  6'b000000: $write("[%s]fp add\n", name);  //fp add
                  6'b000001: $write("[%s]fp sub\n", name);  //fp sub
                  6'b000010: $write("[%s]fp mul\n", name);  //fp mul
                  6'b000011: $write("[%s]fp div\n", name);  //fp div
                  6'b000101: $write("[%s]fp abs\n", name);  //fp abs
                  6'b000110: $write("[%s]fp mov\n", name);  //MOV.FMT
                  6'b000111: $write("[%s]fp neg\n", name);  //fp neg
                  default:   $write("Not an Instruction!", name);
                endcase
              end
            end
            5'b10001: $write("[%s]fp cvt.s\n", name);  //CVT.S.FMT
            default:  $write("Not an Instruction!", name);
          endcase
        end
        6'b100000: $write("[%s]lb\n", name);  //LB
        6'b100001: $write("[%s]lh\n", name);  //LH
        6'b100010: $write("[%s]lwl\n", name);  //LWL
        6'b100011: $write("[%s]lw\n", name);  //LW
        6'b110000: $write("[%s]lwc0\n", name);  //LWC0
        6'b100100: $write("[%s]lbu\n", name);  //LBU
        6'b100101: $write("[%s]lhu\n", name);  //LHU
        6'b100110: $write("[%s]lwr\n", name);  //LWR
        6'b101000: $write("[%s]sb\n", name);  //SB
        6'b101001: $write("[%s]sh\n", name);  //SH
        6'b101010: $write("[%s]swl\n", name);  //SWL
        6'b101011: $write("[%s]sw\n", name);  //SW
        6'b111000: $write("[%s]swc0\n", name);  //SWC0
        6'b101110: $write("[%s]swr\n", name);  //SWR
        6'b110001: $write("[%s]lwc1\n", name);  //LWC1
        6'b111001: $write("[%s]swc1\n", name);  //SWC1
        6'b010100: $write("[%s]beql\n", name);  //BEQL
        6'b010110: $write("[%s]blezl\n", name);  //BLEZL
        6'b010101: $write("[%s]bnel\n", name);  //BNEL
        default:   $write("Not an Instruction!", name);
      endcase
    end
    $write("\n");
  end

endmodule
