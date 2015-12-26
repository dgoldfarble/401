//-----------------------------------------
//           Execute Stage
//-----------------------------------------
module EXE(	// outputs
				ROBPointer_OUT,
				PCA_OUT,
				target_PC_OUT,
				Instr1_OUT,
				writeRegister1_OUT,
				ALU_control1_OUT,
				Dest_Value1_OUT,
				aluresult_OUT,
				address_OUT,
				RegDest_OUT,
				Branch_flag_OUT,
				Mem_Instruction_OUT,

				MemRead1_OUT,
				MemWrite1_OUT,
				Mem_Hazard_PR_OUT,

				// COMMON SIGNALS
				ROBPointer_IN,
				PCA_IN,
				Instr1_IN,
				writeRegister1_IN,
				readRegisterA1_IN,
				Operand_A1_IN,
				Immediate_IN,
				ALU_control1_IN,
				Dest_Value1_IN,
				Mem_Instruction_IN,

				readRegisterB1_IN,
				Operand_B1_IN,
				Instr1_10_6_IN,
				ALUSrc1_IN,
				RegDest_IN,
				Branch_flag_IN,
				jump_flag_IN,
				jump_register_IN,

				MemRead1_IN,
				MemWrite1_IN,
				Valid_Instruction_IN,
				Valid_Instruction_OUT,

				   // forward data
				fwd_data_1_COM,
				fwd_reg_1_COM,
				fwd_data_1_COM_flag,
				LS_fwd_data_COM,
				LS_fwd_reg_COM,
				LS_fwd_data_COM_flag,

				FREEZE, CLK, RESET
				);

				parameter comment = 0;
	parameter ROBWIDTH = 6;

   	// COMMON SIGNALS
	output reg		[ROBWIDTH-1:0]	ROBPointer_OUT;
	output reg		[31: 0] 		PCA_OUT;
	output reg		[31: 0]			target_PC_OUT;
    output reg		[31: 0]			Instr1_OUT;
    output reg		[ 5: 0]			writeRegister1_OUT;
    output reg		[ 5: 0]			ALU_control1_OUT;
    output reg		[31: 0]			Dest_Value1_OUT;
    output reg		[31: 0]			aluresult_OUT;
    output reg		[31: 0] 		address_OUT;
    output reg						RegDest_OUT;
    output reg						Branch_flag_OUT;
    output reg						Mem_Instruction_OUT;
	// LS output
    output reg						MemRead1_OUT;
    output reg						MemWrite1_OUT;
	output reg						Mem_Hazard_PR_OUT;

	// COMMON SIGNALS
	input		[ROBWIDTH-1:0]	ROBPointer_IN;
	input		[31: 0] 		PCA_IN;
    input		[31: 0]			Instr1_IN;
    input		[ 5: 0]			writeRegister1_IN;
    input		[ 5: 0]			readRegisterA1_IN;
    input		[31: 0]			Operand_A1_IN;
    input		[31: 0]			Immediate_IN;
    input		[ 5: 0]			ALU_control1_IN;
    input		[31: 0]			Dest_Value1_IN;
    input						Mem_Instruction_IN;
		// instruction 1 input
    input		[ 5: 0] 		readRegisterB1_IN;
    input		[31: 0]			Operand_B1_IN;
    input		[ 4: 0]			Instr1_10_6_IN;
    input						ALUSrc1_IN;
    input						RegDest_IN;
    input						Branch_flag_IN;
    input						jump_flag_IN;
    input						jump_register_IN;
	// LS output
    input						MemRead1_IN;
    input						MemWrite1_IN;

   // forward data
   input          [31: 0] fwd_data_1_COM;
   input          [ 5: 0] fwd_reg_1_COM;
   input                  fwd_data_1_COM_flag;
   input          [31: 0] LS_fwd_data_COM;
   input          [ 5: 0] LS_fwd_reg_COM;
   input                  LS_fwd_data_COM_flag;


   input 					Valid_Instruction_IN;
   output reg 				Valid_Instruction_OUT;

   // other
   input                  FREEZE;
   input                  CLK;
   input                  RESET;

   wire           [31: 0] aluResult1;
   wire           [31: 0] address_out;
   wire           [31: 0] OpA1, Operand1;
   wire           [31: 0] OpB1, Operand2;
   wire           [31: 0] OpLS1;
   wire           [31: 0] OpLS2;
   wire           [31: 0] Dst1;
   wire						Hazard_flag;
   wire						taken_branch1;
   reg            [31: 0] HI1, HI2;
   reg            [31: 0] LO1, LO2;

	 /* strictly for comments */
	 wire            [ 5: 0] opcode1;
	 wire            [ 5: 0] funct1;
	 wire            [ 4: 0] format1;
	 wire            [ 4: 0] rt1;



	always begin
		Hazard_flag = 0;
	// Forwarding for Instr 1
		// Operand A1
		if(RegDest_OUT && (writeRegister1_OUT == readRegisterA1_IN)) // if the last instruction is an execute and writing back
			OpA1 = aluresult_OUT;
		else if(MemRead1_OUT && (writeRegister1_OUT == readRegisterA1_IN)) // if the last instruction is a load and writing back
			Hazard_flag = 1;
		else if(fwd_data_1_COM_flag && (fwd_reg_1_COM == readRegisterA1_IN)) // if the two instructions past is an execute and writing back
			OpA1 = fwd_data_1_COM;
		else if(LS_fwd_data_COM_flag && (LS_fwd_reg_COM == readRegisterA1_IN)) // if two instructions past is a load and writing back
			OpA1 = LS_fwd_data_COM;
		else OpA1 = Operand_A1_IN;


		// Operand B1
		if(!ALUSrc1_IN) begin
			if(RegDest_OUT && (writeRegister1_OUT == readRegisterB1_IN))
				OpB1 = aluresult_OUT;
			else if(MemRead1_OUT && (writeRegister1_OUT == readRegisterB1_IN))
				Hazard_flag = 1;
			else if(fwd_data_1_COM_flag && (fwd_reg_1_COM == readRegisterB1_IN))
				OpB1 = fwd_data_1_COM;
			else if(LS_fwd_data_COM_flag && (LS_fwd_reg_COM == readRegisterB1_IN))
				OpB1 = LS_fwd_data_COM;
			else OpB1 = Operand_B1_IN;
		end


		// LSQ register operand
		/*if(RegDest_OUT && (writeRegister1_OUT == readRegisterA1_IN))
			OpB1 = aluresult_OUT;
		else if(MemRead1_OUT && (writeRegister1_OUT == readRegisterA1_IN))
			Hazard_flag = 1;
		else if(fwd_data_1_COM_flag && (fwd_reg_1_COM == readRegisterA1_IN))
			OpB1 = fwd_data_1_COM;
		else if(LS_fwd_data_COM_flag && (LS_fwd_reg_COM == readRegisterA1_IN))
			OpB1 = LS_fwd_data_COM;
		else OpB1 = ;*/

		if(Branch_flag_IN) begin
			Operand1 = PCA_IN;
			Operand2 = (Immediate_IN<<2);
		end
		else begin
			Operand1 = OpA1;
			Operand2 = OpB1;
		end
	end



	ALU ALU1(HI1, LO1, aluResult1, Operand1, Operand2, ALU_control1_IN, Instr1_10_6_IN, CLK);
	ALU AGU(HI2, LO2, address_out, OpLS1, OpLS2, ALU_control1_IN, 0, CLK);
	compare compare1(0,OpA1,OpB1,Instr1_IN,taken_branch1);


	//Pipeline Stage 1
	always @ (posedge CLK or negedge RESET) begin
		if(!RESET)
		begin
			ROBPointer_OUT <= 0;
			Instr1_OUT<= 0;
			writeRegister1_OUT <= 0;
			ALU_control1_OUT <= 0;
			// instruction 1 input
			RegDest_OUT <= 0;
			Branch_flag_OUT <= 0;
			// LS output
			Dest_Value1_OUT <= 0;
			MemRead1_OUT <= 0;
			MemWrite1_OUT <= 0;
			Mem_Instruction_OUT <= 0;
			Valid_Instruction_OUT <= 1'b0;
		end
		else if(!FREEZE)
		begin
			ROBPointer_OUT <= ROBPointer_IN;
			Instr1_OUT<= Instr1_IN;
			PCA_OUT <= PCA_IN;
			target_PC_OUT <= jump_flag_IN? {PCA_IN[31:28],Instr1_IN[25:0],2'b0} : Branch_flag_IN? aluResult1 : 0;// this could cause problems
			writeRegister1_OUT <= writeRegister1_IN;
			ALU_control1_OUT <= ALU_control1_IN;
			Dest_Value1_OUT <= Dest_Value1_IN;
			aluresult_OUT <= aluResult1; // this is dubious...
			address_OUT <= address_out;
			// instruction 1 input
			RegDest_OUT <= RegDest_IN;
			Branch_flag_OUT <= Branch_flag_IN? taken_branch1 : jump_flag_IN? 1 : 0 ;
			// LS output
			MemRead1_OUT <= MemRead1_IN;
			MemWrite1_OUT <= MemWrite1_IN;
			Mem_Instruction_OUT <= Mem_Instruction_IN;
			Valid_Instruction_OUT <= Valid_Instruction_IN;
		end
	end


  always begin
	if(comment) begin
		$display("=============================================================");
/*		$display("[EXE]:Data1_WB:%x\t\t|Data2_WB:%x", Data1_WB, Data2_WB);
                $display("[EXE]:Data1_MEM:%x\t|Data2_MEM:%x", Data1_MEM, Data2_MEM);
		$display("[EXE]:OpA1:%x\t\t|OpA2:%x",OpA1,OpA2);
		$display("[EXE]:OpB1:%x\t\t|OpB2:%x",OpB1,OpB2);
		$display("[EXE]:Operand_A1:%x\t|Operand_A2:%x",Operand_A1,Operand_A2);
		$display("[EXE]:Operand_B1:%x\t|Operand_B2:%x",Operand_B1,Operand_B2);
		$display("[EXE]:aluResult1:%x\t|aluResult2:%x",aluResult1,aluResult2);
		$display("[EXE]:readRegisterA1:%x\t\t|readRegisterA2:%x",readRegisterA1,readRegisterA2);
		$display("[EXE]:readRegisterB1:%x\t\t|readRegisterB2:%x",readRegisterB1,readRegisterB2);
		$display("[EXE]:writeRegister1:%x\t\t|writeRegister2:%x",writeRegister1,writeRegister2);
		$display("[EXE]:RegDest_OUT:%x\t|do_writeback2_PR:%x",RegDest_OUT,do_writeback2_PR);
		$display("[EXE]:writeRegister1_OUT:%x\t|writeRegister2_PR:%x",writeRegister1_OUT,writeRegister2_PR);
		$display("[EXE]:aluResult1_PR:%x\t|aluResult2_PR:%x",aluResult1_PR,aluResult2_PR);
		$display("[EXE]:do_writeback1_MEM:%x\t|do_writeback2_MEM:%x",do_writeback1_MEM,do_writeback2_MEM);
 		$display("[EXE]:writeRegister1_MEM:%x\t|writeRegister2_MEM:%x",writeRegister1_MEM,writeRegister2_MEM);
		$display("[EXE]:Data1_MEM:%x\t|Data2_MEM:%x",Data1_MEM,Data2_MEM);
 		$display("[EXE]:do_writeback1_WB:%x\t|do_writeback2_WB:%x",do_writeback1_WB,do_writeback2_WB);
		$display("[EXE]:writeRegister1_WB:%x\t|writeRegister2_WB:%x",writeRegister1_WB,writeRegister2_WB);
		$display("[EXE]:Data1_WB:%x\t\t|Data2_WB:%x",Data1_WB,Data2_WB);
		$display("[EXE]:readDataB1_PR:%x\t|readDataB2_PR:%x",readDataB1_PR,readDataB2_PR);
		/**/


	end
   end

	 //CONTROLLER1
	 //*note, syscall, and all link instructions have been assigned alucontrol of addi
	 always begin
	       opcode1 = Instr1_OUT[31:26];
	       format1 = Instr1_OUT[25:21];
	       rt1     = Instr1_OUT[20:16];
	       funct1  = Instr1_OUT[5:0];
	   case ( opcode1 )
	        6'b000000: begin //SPECIAL
	                     case ( funct1 )
	                   6'b000000: begin if(comment)$display("[EXE]sll,nop\n");end//SLL,NOP
	         6'b000010: begin  if(comment)$display("[EXE]srl\n");end//SRL
	         6'b000011: begin  if(comment)$display("[EXE]sra\n");end//SRA
	         6'b000100: begin  if(comment)$display("[EXE]sllv\n");end//SLLV
	         6'b000110: begin  if(comment)$display("[EXE]srlv\n");end//SRLV
	         6'b000111: begin  if(comment)$display("[EXE]srav\n");end//SRAV
	         6'b001000: begin  if(comment)$display("[EXE]jr\n");end//JR
	         6'b001001: begin  if(comment)$display("[EXE]jalr\n");end//JALR
	         6'b001100: begin  if(comment)$display("[EXE]syscal1\n");end//syscal1*
	         6'b001101: begin  if(comment)$display("[EXE]break\n");end//BREAK*
	         6'b010000: begin  if(comment)$display("[EXE]mfhi\n");end//MFHI
	         6'b010001: begin  if(comment)$display("[EXE]mthi\n");end//MTHI
	         6'b010010: begin  if(comment)$display("[EXE]mflo\n");end//MFLO
	         6'b010011: begin  if(comment)$display("[EXE]mtlo\n");end//MTLO
	         6'b011000: begin  if(comment)$display("[EXE]mult\n");end//mult
	         6'b011001: begin  if(comment)$display("[EXE]multu\n");end//multu
	         6'b011010: begin  if(comment)$display("[EXE]div\n");end//div
	         6'b011011: begin  if(comment)$display("[EXE]divu\n");end//divu
	         6'b100000: begin  if(comment)$display("[EXE]add\n");end//add
	         6'b100001: begin  if(comment)$display("[EXE]addu\n");end//addu
	         6'b100010: begin  if(comment)$display("[EXE]sub\n");end//sub
	         6'b100011: begin  if(comment)$display("[EXE]subu\n");end//subu
	         6'b100100: begin  if(comment)$display("[EXE]and\n");end//and
	         6'b100101: begin  if(comment)$display("[EXE]or\n");end//or
	         6'b100110: begin  if(comment)$display("[EXE]xor\n");end//Xor
	         6'b100111: begin  if(comment)$display("[EXE]nor\n");end//nor
	         6'b101010: begin  if(comment)$display("[EXE]slt\n");end//slt
	         6'b101011: begin  if(comment)$display("[EXE]sltu\n");end//sltu
	                           default: $display("Not an Instruction!");
	                       endcase
	                 end
	     6'b000001: begin
	                   case ( rt1 )
	                         5'b00000: begin  if(comment)$display("[EXE]bltz\n");end//BLTZ
	         5'b00001: begin  if(comment)$display("[EXE]bgez\n");end//BGEZ
	         5'b10000: begin  if(comment)$display("[EXE]bltzal\n");end//BLTZAL
	         5'b10001: begin  if(comment)$display("[EXE]bgezal\n");end//BGEZAL
	                           default: $display("Not an Instruction!");
	                       endcase
	                 end
	     6'b000010: begin  if(comment)$display("[EXE]jump\n");end//J
	     6'b000011: begin  if(comment)$display("[EXE]jal\n");end//JAL
	     6'b000100: begin  if(comment)$display("[EXE]beq\n");end//BEQ
	     6'b000101: begin  if(comment)$display("[EXE]bne\n");end//BNE
	     6'b000110: begin  if(comment)$display("[EXE]blez\n");end//BLEZ
	     6'b000111: begin  if(comment)$display("[EXE]bgtz\n");end//BGTZ
	     6'b001000: begin  if(comment)$display("[EXE]addi\n");end//ADDI
	     6'b001001: begin  if(comment)$display("[EXE]addiu\n");end//ADDIU
	     6'b001010: begin  if(comment)$display("[EXE]slti\n");end//SLTI
	     6'b001011: begin  if(comment)$display("[EXE]sltiu\n");end//SLTIU
	     6'b001100: begin  if(comment)$display("[EXE]andi\n");end//ANDI
	     6'b001101: begin  if(comment)$display("[EXE]ori\n");end//ORI
	     6'b001110: begin  if(comment)$display("[EXE]xori\n");end//XorI
	     6'b001111: begin  if(comment)$display("[EXE]lui\n");end//LUI
	           6'b010001: begin //COP1
	           case( format1 )
	                 5'b00000: begin  if(comment)$display("[EXE]mfc1\n");end//MFC1
	           5'b00010: begin  if(comment)$display("[EXE]cfc1\n");end//CFC1
	           5'b00100: begin  if(comment)$display("[EXE]mtc1\n");end//MTC1
	           5'b00110: begin  if(comment)$display("[EXE]ctc1\n");end//CTC1
	           5'b01000:begin
	                 case( Instr1_OUT[16] )
	                       1'b1: begin  if(comment)$display("[EXE]bc1t\n");end//BC1T
	                 1'b0: begin  if(comment)$display("[EXE]bc1f\n");end//BC1F
	                 endcase
	           end
	           5'b10000:begin
	           if( Instr1_OUT[7:4] == 4'b0011 ) begin  if(comment)$display("[EXE]fp c.cond\n");end//fp c.cond
	                 else begin
	                   case( funct1 )
	                     6'b000000: begin  if(comment)$display("[EXE]fp add\n");end//fp add
	                           6'b000001:  begin  if(comment)$display("[EXE]fp sub\n");end//fp sub
	                                           6'b000010: begin  if(comment)$display("[EXE]fp mul\n");end//fp mul
	                                           6'b000011: begin  if(comment)$display("[EXE]fp div\n");end//fp div
	                                           6'b000101: begin  if(comment)$display("[EXE]fp abs\n");end//fp abs
	                                           6'b000110: begin  if(comment)$display("[EXE]fp mov\n");end//MOV.FMT
	                                         6'b000111: begin  if(comment)$display("[EXE]fp neg\n");end//fp neg
	                     default: $display("Not an Instruction!");
	                       endcase
	                 end
	         end
	             5'b10001: begin  if(comment)$display("[EXE]fp cvt.s\n");end//CVT.S.FMT
	                 default: $display("Not an Instruction!");
	       endcase
	     end
	     6'b100000: begin if(comment)$display("[EXE]lb\n");end//LB
	     6'b100001: begin if(comment)$display("[EXE]lh\n");end//LH
	     6'b100010: begin if(comment)$display("[EXE]lwl\n");end//LWL
	     6'b100011: begin if(comment)$display("[EXE]lw\n");end//LW
	           6'b110000: begin if(comment)$display("[EXE]lwc0\n");end//LWC0
	     6'b100100: begin if(comment)$display("[EXE]lbu\n");end//LBU
	     6'b100101: begin if(comment)$display("[EXE]lhu\n");end//LHU
	     6'b100110: begin if(comment)$display("[EXE]lwr\n");end//LWR
	     6'b101000: begin if(comment)$display("[EXE]sb\n");end//SB
	     6'b101001: begin if(comment)$display("[EXE]sh\n");end//SH
	     6'b101010: begin if(comment)$display("[EXE]swl\n");end//SWL
	     6'b101011: begin if(comment)$display("[EXE]sw\n");end//SW
	           6'b111000: begin if(comment)$display("[EXE]swc0\n");end//SWC0
	     6'b101110: begin if(comment)$display("[EXE]swr\n");end//SWR
	     6'b110001: begin if(comment)$display("[EXE]lwc1\n");end//LWC1
	     6'b111001: begin if(comment)$display("[EXE]swc1\n");end//SWC1
	     6'b010100: begin if(comment)$display("[EXE]beql\n");end//BEQL
	     6'b010110: begin if(comment)$display("[EXE]blezl\n");end//BLEZL
	     6'b010101: begin if(comment)$display("[EXE]bnel\n");end//BNEL
	     default: $display("Not an Instruction!");
	   endcase
	 end

endmodule
