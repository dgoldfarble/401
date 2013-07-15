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
   reg                    comment;
   


   	initial comment = 0;  //show EXE displays


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

endmodule
