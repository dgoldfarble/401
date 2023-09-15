//-----------------------------------------
//         Instruction Decode Stage
//-----------------------------------------

`timescale 1ns / 1ps

module ID (
    CLK,
    RESET,
    FREEZE,
    ALUSrc1_PR,
    fetchNull2_OUT,
    // single_fetch_OUT,
    Instr1_PR,
    Dest_Value1_PR,
    insertBubble_OUT,
    SYS_OUT,
    readDataB1_PR,
    Instr1_10_6_PR,
    do_writeback1_MEM,
    writeRegister1_MEM,
    Data1_MEM,
    do_writeback1_WB,
    writeRegister1_WB,
    Data1_WB,
    aluResult1,
    do_writeback1_PR,  // Used in rename
    readRegisterA1_PR,
    readRegisterB1_PR,
    taken_branch1_PR,
    aluResult1_WB,
    nextInstruction_address_PR,
    Reg,
    R2_output_PR,
    Operand_A1_PR,
    Operand_B1_PR,
    ALU_control1_PR,
    MemRead1_PR,
    MemWrite1_PR,
    MemtoReg1_PR,
    fQ_IFID_Instr1,  // From IFID Queue
    fQ_IFID_PCA,  // From IFID Queue
    writeData1_WB,
    R2_input,
    fQ_IFID_CIA,  // From IFID Queue
    tQ_IFID_popReq_OUT,
    fQ_IFID_empty_IN,
    tQ_IDREN_pushReq_OUT,
    fQ_IDREN_full_IN,

    // to rename
    writeRegister1_PR,
    isRegWriteInstr_OUT,
    isJump_OUT,
    isJumpReg_OUT,
    isBranch_OUT,
    isLink_OUT,
    PCA_OUT,
    CIA_OUT,

    signExtImm_OUT
);

  output reg [31:0] R2_output_PR;
  output reg [31:0] Operand_A1_PR;
  output reg [31:0] Operand_B1_PR;
  output reg [31:0] Dest_Value1_PR;
  output reg [31:0] nextInstruction_address_PR;
  output reg [31:0] Reg [0:31];
  output reg [31:0] readDataB1_PR;
  output reg [31:0] Instr1_PR;
  output reg [5:0] ALU_control1_PR;
  output reg [4:0] readRegisterA1_PR;
  output reg [4:0] readRegisterB1_PR;
  output reg [4:0] Instr1_10_6_PR;
  output reg ALUSrc1_PR;
  // output reg 	        single_fetch_OUT;
  output reg taken_branch1_PR;
  output reg MemRead1_PR;
  output reg MemtoReg1_PR;
  output reg MemWrite1_PR;
  output reg do_writeback1_PR;
  output reg insertBubble_OUT;
  output reg SYS_OUT;
  output reg fetchNull2_OUT;
  output reg tQ_IFID_popReq_OUT;
  output reg tQ_IDREN_pushReq_OUT;
  output reg [4:0] writeRegister1_PR;
  output reg [1:0] isRegWriteInstr_OUT;

  output reg isJump_OUT;
  output reg isJumpReg_OUT;
  output reg isBranch_OUT;
  output reg isLink_OUT;
  output reg [31:0] PCA_OUT, CIA_OUT, signExtImm_OUT;


  input [31:0] Data1_MEM;
  input [31 : 0] Data1_WB;
  input [31:0] fQ_IFID_Instr1;  //_IN;
  input [31:0] aluResult1;
  input [31:0] aluResult1_WB;
  input [31:0] fQ_IFID_PCA;  //wPCA;
  input [31:0] writeData1_WB;
  input [31:0] R2_input;
  input [31:0] fQ_IFID_CIA;  //wCIA;
  input [4:0] writeRegister1_WB;
  input [4:0] writeRegister1_MEM;
  input do_writeback1_WB;
  input do_writeback1_MEM;
  input FREEZE;
  input CLK;
  input RESET;
  input fQ_IDREN_full_IN;
  input fQ_IFID_empty_IN;

  reg  [31:0] com_OpA1;
  reg  [31:0] com_OpB1;
  wire [31:0] signExtended_output1;
  wire [31:0] Shift_addResult1;
  wire [31:0] Jump_address1;
  wire [31:0] R2_output;
  wire [31:0] readDataA1;
  wire [31:0] readDataB1;
  wire [31:0] Operand_B1;
  wire [31:0] nextInstruction_address;
  wire [31:0] CIAp4;
  wire [31:0] PCAp4;
  wire [31:0] nia1;
  reg  [ 5:0] ALU_control1;
  reg  [ 5:0] opcode1;
  reg  [ 5:0] funct1;
  wire [ 4:0] readRegisterA1;
  wire [ 4:0] readRegisterB1;
  reg  [ 4:0] format1;
  reg  [ 4:0] rt1;
  wire [ 4:0] writeRegister1;
  wire        taken_branch1;
  reg         link1;
  reg         RegDst1;
  reg         jump1;
  reg         branch1;
  reg         MemRead1;
  reg         MemtoReg1;
  reg         MemWrite1;
  reg         ALUSrc1;
  reg         RegWrite1;
  reg         jumpRegister_Flag1;
  reg         sign_or_zero_Flag1;
  reg         syscal1;
  wire        MemHazard;
  wire        SysHazard;
  wire        WAWHazard;
  wire        RAWHazard;
  wire        JMPHazard;
  wire        NOPHazard;

  wire        wCarryOn;
  assign wCarryOn = !FREEZE;
  //////////////////////////////////////////////////////////////////////////
  //QUEUE BUSINESS//////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////

  //////// Q_IFID
  wire [31:0] wInstr1, wPCA, wCIA;

  assign wInstr1 = (tQ_IFID_popReq_OUT) ? fQ_IFID_Instr1 : 0;
  assign wPCA = (tQ_IFID_popReq_OUT) ? fQ_IFID_PCA : 0;
  assign wCIA = (tQ_IFID_popReq_OUT) ? fQ_IFID_CIA : 0;

  assign tQ_IFID_popReq_OUT = wCarryOn && RESET;

  //////// Q_IDREN
  parameter PUSH_DATAWIDTH = 0;  // From module instantiation

  always @(posedge CLK) begin
    tQ_IDREN_pushReq_OUT <= wCarryOn && RESET;
  end


  //////////////////////////////////////////////////////////////////////////
  //Things to pass on to Rename/////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////

  assign isRegWriteInstr_OUT = {do_writeback1_PR, RegDst1};
  assign isJump_OUT = jump1;
  assign isJumpReg_OUT = jumpRegister_Flag1;
  assign isBranch_OUT = branch1;
  assign isLink_OUT = link1;
  assign PCA_OUT = wPCA;
  assign CIA_OUT = wCIA;

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////




  reg [1:0] syscalBubbleCounter;
  parameter comment1 = 0;
  parameter comment2 = 0;
  parameter comment3 = 0;
  parameter LOGGING_PREFIX = "ID";
  // reg			single_fetch_PR;

  assign fetchNull2_OUT = taken_branch1;

  assign CIAp4 = wCIA + 32'h00000004;
  assign PCAp4 = wPCA + 32'h00000004;
  assign insertBubble_OUT = syscal1 && (syscalBubbleCounter != 0);
  assign SYS_OUT = syscal1 && (syscalBubbleCounter == 0);
  assign Jump_address1=(jumpRegister_Flag1)?{wCIA[31:28],wInstr1[25:0],2'b0}:com_OpA1;//readDataA1;
  assign signExtended_output1 = (sign_or_zero_Flag1)?{{16{wInstr1[15]}},wInstr1[15:0]}:{16'b0,wInstr1[15:0]};
  assign Shift_addResult1 = wPCA + (signExtended_output1 << 2);
  assign nia1 = (jump1) ? Jump_address1 : ((taken_branch1) ? Shift_addResult1 : wPCA);
  assign nextInstruction_address = nia1;
  assign readRegisterA1 = wInstr1[25:21];
  assign readRegisterB1 = wInstr1[20:16];
  assign writeRegister1 = (RegDst1)?wInstr1[15:11]:((link1)?5'b11111:((syscal1)?5'b00000:wInstr1[20:16]));
  assign readDataA1 = Reg[readRegisterA1];
  assign readDataB1 = Reg[readRegisterB1];
  assign Operand_B1 = (ALUSrc1) ? signExtended_output1 : readDataB1;
  assign R2_output = Reg[2];

  assign signExtImm_OUT = signExtended_output1;

  always begin
    //Forwarded Operand A
    if (do_writeback1_PR && (readRegisterA1 == writeRegister1_PR)) com_OpA1 = aluResult1;
    else if (do_writeback1_MEM && (readRegisterA1 == writeRegister1_MEM)) com_OpA1 = Data1_MEM;
    else if (do_writeback1_WB && (readRegisterA1 == writeRegister1_WB)) com_OpA1 = Data1_WB;
    else com_OpA1 = readDataA1;
    //Forwarded Operand B
    if (do_writeback1_PR && (readRegisterB1 == writeRegister1_PR)  /* && (ALUSrc1!=1)/**/)
      com_OpB1 = aluResult1;
    else if (do_writeback1_MEM && (readRegisterB1 == writeRegister1_MEM)  /* && (ALUSrc1!=1)/**/)
      com_OpB1 = Data1_MEM;
    else if (do_writeback1_WB && (readRegisterB1 == writeRegister1_WB)  /* && (ALUSrc1!=1)/**/)
      com_OpB1 = Data1_WB;
    else com_OpB1 = Operand_B1;
  end

  compare compare1 (
      jump1,
      com_OpA1,
      com_OpB1,
      wInstr1,
      taken_branch1
  );
  /* TA: These signals may be used for superscalar operation
	assign MemHazard =
	assign SysHazard =
	assign WAWHazard =
	assign RAWHazard =
	assign JMPHazard =
	assign NOPHazard =
	assign single_fetch_OUT =
	*/

  instr_logger #(
      .comment(comment1),
      .name(LOGGING_PREFIX)
  ) instr_logger1 (
      CLK,
      wInstr1
  );

  //CONTROLLER1
  //*note, syscall, and all link instructions have been assigned alucontrol of addi
  always begin
    opcode1 = wInstr1[31:26];
    format1 = wInstr1[25:21];
    rt1     = wInstr1[20:16];
    funct1  = wInstr1[5:0];
    case (opcode1)
      6'b000000: begin  //SPECIAL
        case (funct1)
          6'b000000: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001000010011; //SLL,NOP
          6'b100001: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001100110111; //addu
          6'b000010: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001000011011; //SRL
          6'b000011: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001000011001; //SRA
          6'b000100: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001000010100; //SLLV
          6'b000110: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001000011100; //SRLV
          6'b000111: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001000011010; //SRAV
          6'b001000: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b001100000000111110; //JR
          6'b001001: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b101100001000000001; //JALR
          6'b001100: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000011011000001; //syscal1*
          6'b001101: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000011000010011; //BREAK*
          6'b010000: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001000001001; //MFHI
          6'b010001: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000000000001011; //MTHI
          6'b010010: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001000001010; //MFLO
          6'b010011: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000000000001100; //MTLO
          6'b011000: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000000000001101; //mult
          6'b011001: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000000000001101; //multu
          6'b011010: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000000000000101; //div
          6'b011011: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000000000000110; //divu
          6'b100000: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001100000000; //add
          6'b100010: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001100011101; //sub
          6'b100011: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001100011110; //subu
          6'b100100: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001100000100; //and
          6'b100101: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001100010000; //or
          6'b100110: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001100011111; //Xor
          6'b100111: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001100001111; //nor
          6'b101010: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001100010101; //slt
          6'b101011: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000001000111111; //sltu
          default: $write("Not an Instruction!");
        endcase
      end
      6'b000001: begin
        case (rt1)
          5'b00000: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000100000010100111; //BLTZ
          5'b00001: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000100000010100011; //BGEZ
          5'b10000: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b100100011010000001; //BLTZAL
          5'b10001: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b100100011010000001; //BGEZAL
          default: $display("Not an Instruction!");
        endcase
      end
      6'b000010: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b001100000100001110;  //J
      6'b000011: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b101000011010000001; //JAL
      6'b000100: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000100000010100010;//BEQ
      6'b000101: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000100000010101001;//BNE
      6'b000110: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000100000010100110;//BLEZ
      6'b000111: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000100000010100101;//BGTZ
      6'b001000: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000011010000001;//ADDI
      6'b001001: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000011010000010;//ADDIU
      6'b001010: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000011010010101;//SLTI
      6'b001011: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000011010010101;//SLTIU
      6'b001100: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000011000000100;//ANDI
      6'b001101: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000011000010000;//ORI
      6'b001110: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000011000100000;//XorI
      6'b001111: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000011000001000;//LUI
      6'b010001: begin  //COP1
        case (format1)
          5'b00000: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000001010011100;//MFC1
          5'b00010: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000001010011010;//CFC1
          5'b00100: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000000010111000;//MTC1
          5'b00110: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000000010110100; //CTC1
          5'b01000: begin
            case (wInstr1[16])
              1'b1: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000100000010011101; //BC1T
              1'b0: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000100000010001111; //BC1F
            endcase
          end
          5'b10000: begin
            if (wInstr1[7:4] == 4'b0011) {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b000000000000011111;//fp c.cond
            else begin
              case (funct1)
                6'b000000: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000000000011011;//fp add
                6'b000001: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000000000000000;//fp sub
                6'b000010: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000000000001101;//fp mul
                6'b000011: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000000000000101;//fp div
                6'b000101: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000000000110111;//fp abs
                6'b000110: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000000010000100;//MOV.FMT
                6'b000111: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000000000010000; //fp neg
                default: $display("Not an Instruction!");
              endcase
            end
          end
          5'b10001: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 18'b010000000010001000; //CVT.S.FMT
          default: $display("Not an Instruction!");
        endcase
      end
      6'b100000: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000011011100100001;//LB
      6'b100001: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000011011100101011;//LH
      6'b100010: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000011011100101101;//LWL
      6'b100011: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000011011100111101;//LW
      6'b110000: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 	18'b000011011100111101;//LWC0
      6'b100100: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000011011100101010; //LBU
      6'b100101: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000011011100101100;//LHU
      6'b100110: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000011011100101110;//LWR
      6'b101000: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000000110100101111;//SB
      6'b101001: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000000110100110000;//SH
      6'b101010: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000000110100110010;//SWL
      6'b101011: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000000110100110001;//SW
      6'b111000: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 	18'b000000110100110001;//SWC0
      6'b101110: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000000110100110011;//SWR
      6'b110001: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000011010010110101;//LWC1
      6'b111001: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000000110010111001;//SWC1
      6'b010100: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000100000010111010;  //BEQL
      6'b010110: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000100000010111011; //BLEZL
      6'b010101: {link1,RegDst1,jump1,branch1,MemRead1,MemtoReg1,MemWrite1,ALUSrc1,RegWrite1,jumpRegister_Flag1,sign_or_zero_Flag1,syscal1,ALU_control1} = 		18'b000100000010111100; //BNEL
      default: $display("Not an Instruction!");
    endcase
    if (comment1) begin
      $write("[%s] ", LOGGING_PREFIX);
      if (link1) $write("link1 ");
      if (RegDst1) $write("RegDst1 ");
      if (jump1) $write("jump1 ");
      if (branch1) $write("branch1 ");
      if (MemRead1) $write("MemRead1 ");
      if (MemtoReg1) $write("MemtoReg1 ");
      if (MemWrite1) $write("MemWrite1 ");
      if (ALUSrc1) $write("ALUSrc1 ");
      if (RegWrite1) $write("RegWrite1 ");
      if (jumpRegister_Flag1) $write("jumpRegister_Flag1 ");
      if (sign_or_zero_Flag1) $write("sign_or_zero_Flag1 ");
      if (syscal1) $write("syscal1 ");
      $write("ALU_control1: %b", ALU_control1);
      $write("\n");
    end
  end

  // PIPE REGISTERS 0
  always @(posedge CLK or negedge RESET) begin
    if (!RESET) begin
      R2_output_PR <= 32'b0;
      nextInstruction_address_PR <= 32'b0;
      syscalBubbleCounter <= 2'b11;  /// only allowed here
      // single_fetch_PR <= 1'b0;
    end else if (!FREEZE) begin
      R2_output_PR <= (insertBubble_OUT) ? 0 : R2_output;
      nextInstruction_address_PR <= (insertBubble_OUT) ? 0 : nextInstruction_address;
      syscalBubbleCounter <= (syscal1) ? syscalBubbleCounter - 1 : 2'b11;
      // single_fetch_PR <= single_fetch_OUT;
    end
  end
  //REGISTER FILE
  always @(posedge CLK) begin
    if (do_writeback1_WB) Reg[writeRegister1_WB] = writeData1_WB;
  end

  //PIPE REGISTERS 1
  always @(posedge CLK or negedge RESET) begin
    if (!RESET || insertBubble_OUT) begin
      Operand_A1_PR <= 32'b0;
      Operand_B1_PR <= 32'b0;
      writeRegister1_PR <= 5'b0;
      taken_branch1_PR <= 1'b0;
      MemRead1_PR <= 1'b0;
      MemtoReg1_PR <= 1'b0;
      MemWrite1_PR <= 1'b0;
      ALU_control1_PR <= 6'b0;
      readRegisterA1_PR <= 5'b0;
      readRegisterB1_PR <= 5'b0;
      do_writeback1_PR <= 1'b0;
      Instr1_10_6_PR <= 5'b0;
      readDataB1_PR <= 32'b0;
      Dest_Value1_PR <= 32'b0;
      Instr1_PR <= 32'b0;
      ALUSrc1_PR <= 1'b0;
    end else if (!FREEZE) begin
      Operand_A1_PR <= (link1) ? wPCA : ((syscal1) ? R2_input : readDataA1);
      Operand_B1_PR <= (link1) ? 32'h00000004 : ((syscal1) ? 32'h00000000 : Operand_B1);
      writeRegister1_PR <= writeRegister1;
      taken_branch1_PR <= taken_branch1;
      MemRead1_PR <= MemRead1;
      MemtoReg1_PR <= MemtoReg1;
      MemWrite1_PR <= MemWrite1;
      ALU_control1_PR <= ALU_control1;
      readRegisterA1_PR <= (link1 || syscal1) ? 5'b00000 : readRegisterA1;
      readRegisterB1_PR <= (ALUSrc1 || link1 || syscal1) ? 5'b00000 : readRegisterB1;
      do_writeback1_PR <= ((RegWrite1)&&(writeRegister1!=5'b00000)&&(ALU_control1!=6'b110100))||MemtoReg1;
      Instr1_10_6_PR <= wInstr1[10:6];
      readDataB1_PR <= readDataB1;
      Dest_Value1_PR <= Reg[writeRegister1];
      Instr1_PR <= wInstr1;
      ALUSrc1_PR <= ALUSrc1;
    end
  end

  always @(posedge CLK) begin
    if (comment2) begin
      $display(
          "[%s]link1:%x\tRegDst1:%x\tjump1:%x\tbranch1:%x\tMemRead1:%x\tMemtoReg1:%x\tMemWrite1:%x\tALUSrc1:%x\tRegWrite1:%x\tjumpRegister_Flag1:%x\tsign_or_zero_Flag1:%x\tsyscal1:%x\tALU_control1:%b",
          LOGGING_PREFIX, link1, RegDst1, jump1, branch1, MemRead1, MemtoReg1, MemWrite1, ALUSrc1,
          RegWrite1, jumpRegister_Flag1, sign_or_zero_Flag1, syscal1, ALU_control1);
    end

    if (comment3) begin
      $display("==ID===========================================================");
      /*	$display("[ID]:Read Register A1:%d\t\t|Read Register A2:%d",readRegisterA1,readRegisterA2);
		$display("[ID]:Read Register B1:%d\t\t|Read Register B2:%d",readRegisterB1,readRegisterB2);
		$display("[ID]:Write Register 1:%d\t\t|Write Register 2:%d",writeRegister1,writeRegister2);
		$display("[ID]:\tsyscalBubbleCounter:%x",syscalBubbleCounter);
                $display("[ID]:\tinsertBubble_OUT:%x",insertBubble_OUT);
		$display("[ID]:\tsingle_fetch_OUT:%x",single_fetch_OUT);
		$display("[ID]:\tsingle_fetch_PR:%x",single_fetch_PR);
                $display("[ID]:\tSYS_OUT:%x",SYS_OUT);
		*/ $display(
          "[ID]:\tPCA:%x", wPCA);
      $display("[ID]:\tCIA:%x", wCIA);
      /*$display("[ID]:\tbranch1:%x\n[ID]:\tbranch2:%x",branch1,branch2);
		*/ $display(
          "[ID]:\tInstr1:%x", wInstr1);
      /*$display("[ID]:\tnextInstruction_address:%x",nextInstruction_address);
                $display("[ID]:syscal1:%x\t\t\t|syscal2:%x",syscal1,syscal2);
	 	$display("[ID]:writeRegister1_PR:%x\t|writeRegister2_PR:%x",writeRegister1_PR,writeRegister2_PR);
		$display("[ID]:com_OpA1:%x\t\t|com_OpA2:%x",com_OpA1,com_OpA2);
		$display("[ID]:com_OpB1:%x\t\t|com_OpB1:%x",com_OpB1,com_OpB2);
		$display("[ID]:writeRegister1_WB:%x\t|writeRegister2_WB:%x",writeRegister1_WB,writeRegister2_WB);
                $display("[ID]:writeRegister1_MEM:%x\t|writeRegister2_MEM:%x",writeRegister1_MEM,writeRegister2_MEM);
		$display("[ID]:readRegisterA1:%x\t\t|readRegisterA1:%x",readRegisterA1,readRegisterA2);
		$display("[ID]:readRegisterB1:%x\t\t|readRegisterB1:%x",readRegisterB1,readRegisterB2);
		$display("[ID]:writeRegister1:%x\t\t|writeRegister2:%x",writeRegister1,writeRegister2);
		$display("[ID]:do_writeback1_WB:%x\t\t|do_writeback2_WB:%x",do_writeback1_WB,do_writeback2_WB);
                $display("[ID]:do_writeback1_MEM:%x\t|do_writeback2_MEM:%x",do_writeback1_MEM,do_writeback2_MEM);
		$display("[ID]:do_writeback1_PR:%x\t\t|do_writeback2_PR:%x",do_writeback1_PR,do_writeback2_PR);
		$display("[ID]:aluResult1:%x\t|aluResult2:%x",aluResult1,aluResult2);
		$display("[ID]:aluResult1_WB:%x\t|aluResult2_WB:%x",aluResult1_WB,aluResult2_WB);
		$display("[ID]:aluResult1:%x\t|aluResult2:%x",aluResult1,aluResult2);
		$display("[ID]:writeData1_WB:%x\t|writeData2_WB:%x",writeData1_WB,writeData2_WB);
                $display("[ID]:writeRegister1_WB:%x\t|writeRegister2_WB:%x",writeRegister1_WB,writeRegister2_WB);
		$display("[ID]:readRegisterA1_PR:%x\t|readRegisterA2_PR:%x",readRegisterA1_PR,readRegisterA2_PR);
		$display("[ID]:readRegisterB1_PR:%x\t|readRegisterB2_PR:%x",readRegisterB1_PR,readRegisterB2_PR);
		$display("[ID]:Operand_A1:%x\t|Operand_A2:%x",(link1)?wPCA:((syscal1)?R2_input:readDataA1), (link2)?wPCA:((syscal2)?R2_input:readDataA2));
		$display("[ID]:readDataA1:%x\t|readDataA2:%x",readDataA1,readDataA2);
		$display("[ID]:Operand_B1:%x\t|Operand_B2:%x",(link1)?32'h00000008:((syscal1)?32'h00000000:Operand_B1),(link2)?32'h00000008:((syscal2)?32'h00000000:Operand_B2));
		$display("[ID]:readDataB1:%x\t|readDataB2:%x",readDataB1,readDataB2);
		$display("[ID]:wInstr1:%x\t\t|Instr2:%x",wInstr1,Instr2);
		$display("[ID]:Jump_address1:%x\t|Jump_address2:%x",Jump_address1,Jump_address2);
		$display("[ID]:Shift_addResult1:%x\t|Shift_addResult2:%x",Shift_addResult1,Shift_addResult2);
		$display("[ID]:Data1_MEM:%x\t\t|Data1_MEM:%x",Data1_MEM,Data2_MEM);
		$display("[ID]:Data1_WB:%x\t\t|Data2_WB:%x",Data1_WB,Data2_WB);
		$display("[ID]:taken_branch1:%x\t\t|taken_branch2:%x",taken_branch1,taken_branch2);
		$display("[ID]:RegDst1:%x\t\t\t|RegDst2:%x",RegDst1,RegDst2);
		$display("[ID]:link1:%x\t\t\t|link2:%x",link1,link2);
		$display("=============================================================");
		$display("[EXE]:Read Register A1:%d\t\t|Read Register A2:%d",readRegisterA1_PR,readRegisterA2_PR);
		$display("[EXE]:Read Register B1:%d\t\t|Read Register B2:%d",readRegisterB1_PR,readRegisterB2_PR);
		$display("[EXE]:Write Register 1:%d\t\t|Write Register 2:%d",writeRegister1_PR,writeRegister2_PR);
		/**/
    end
  end

endmodule
