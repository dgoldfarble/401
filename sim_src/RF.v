module RF	(	FREEZE,
				CLK,
				RESET,
				//inputs
				IQLSQ_popData_IN,
				Valid_Instruction_IN,
				Mem_Instruction_IN,
				Mem_Instruction_OUT,
				IQ_LSQ_pop,
				//unpacked outputs
				// common
				Valid_Instruction_OUT,
				ROBPointer,
				PCA,
				Instr1,
				writeRegister1,
				readRegisterA1,
				Operand_A1,
				Immediate,
				ALU_control1,
				mem_or_not_mem,
				// not memory
				readRegisterB1,
				Operand_B1,
				Instr1_10_6,
				ALUSrc1,
				RegDest,
				Branch_flag,
				jump_flag,
				jump_register,
				// memory
				Dest_Value1,
				MemRead1,
				MemWrite1,
				//write back
				write_register_data,
				write_register_index,
				write_register_flag,
				Reg
			);

			
	parameter RENISS_WIDTH = 0; // Width of the incoming data from Rename
	parameter IDREN_WIDTH = 0;
	parameter ROBINDEX = 6;
	parameter RF_DEBUG = 0;
	
	input [RENISS_WIDTH-1:0]	IQLSQ_popData_IN;
	input 						Valid_Instruction_IN;
	input						Mem_Instruction_IN;
	
	output reg					IQ_LSQ_pop;
	output reg					Valid_Instruction_OUT;
	output reg					Mem_Instruction_OUT;
	
	// other
	input                  FREEZE;
	input                  CLK;
	input                  RESET;
	
	// COMMON SIGNALS
	output reg		[ROBINDEX-1:0]	ROBPointer;
	output reg		[31: 0] 		PCA;
    output reg		[31: 0]			Instr1;
    output reg		[ 5: 0]			writeRegister1;
    output reg		[ 5: 0]			readRegisterA1;
    output reg		[31: 0]			Operand_A1;
    output reg		[31: 0]			Immediate;
    output reg		[ 5: 0]			ALU_control1;
    output reg		[31: 0]			Dest_Value1;
    output reg						mem_or_not_mem;
		// instruction 1 input
    output reg		[ 5: 0] 		readRegisterB1;
    output reg		[31: 0]			Operand_B1;
    output reg		[ 4: 0]			Instr1_10_6;
    output reg						ALUSrc1;
    output reg						RegDest;
    output reg						Branch_flag;
    output reg 					jump_flag;
    output reg 					jump_register;
	// LS output
    output reg						MemRead1;
    output reg						MemWrite1;
    
    input			[31: 0]			write_register_data;
    input			[ 5: 0]			write_register_index;
    input							write_register_flag;
    
	output reg		[31: 0] Reg [63:0];
    
    wire							wmem_or_not_mem;
    assign wmem_or_not_mem = Mem_Instruction_IN;
    
    
		// 103:103	1 link
		// 102:102	1 jumpReg
		// 101:101	1 jump
		// 100:100	1 branch
		// 099:099	1 MemWrite
		// 098:098	1 MemRead							
		// 097:097 Imm src			- LSQ & IQ
		// 096:096 Need Dest Reg?	- LSQ & IQ
		// 095:090 dest reg			- LSQ & IQ
		// 089:089 Src2 rdy			- IQ only
		// 088:083 Src2 phys reg 	- IQ only
		// 082:082 Src1 rdy 		- LSQ & IQ
		// 081:076 Src1 phys reg 	- LSQ & IQ
		// 075:044 32b signExt Imm	- LSQ & IQ
		// 043:038 ALU control		- LSQ & IQ
		// 031:000 Instr			- LSQ & IQ
	
	wire	[ 5: 0] wROBPointer;
    wire	[31: 0] wInstr;
    wire	[ 5: 0] wwriteRegister1;
    wire	[ 5: 0]	wreadRegisterA1;
	wire	[31: 0] wImmediate;
    wire	[ 5: 0]	wALU_control1;
	assign wROBPointer = IQLSQ_popData_IN[037:032];
    assign wInstr = IQLSQ_popData_IN[031:000] ;
    assign writeRegister1 = IQLSQ_popData_IN[095:090];
    assign readRegisterA1 = IQLSQ_popData_IN[081:076];
	assign Immediate = IQLSQ_popData_IN[075:044];
    assign ALU_control1 = IQLSQ_popData_IN[043:038];
	
	
	always @ (posedge CLK or negedge RESET) begin
		if(!RESET)
		begin
			ROBPointer <= 0;
			Instr1 <= 0;
			// writeRegister1 <= 0;
			// readRegisterA1 <= 0;
			Operand_A1 <= 0;
			// Immediate <= 0;
			// ALU_control1 <= 0;
			// instruction 1 input
			readRegisterB1 <= 0;
			Operand_B1 <= 0;
			Instr1_10_6 <= 0;
			ALUSrc1 <= 0;
			RegDest <= 0;
			Branch_flag <= 0;
			jump_flag <= 0;
			jump_register <= 0;
			// LS output
			Dest_Value1 <= 0;
			MemRead1 <= 0;
			MemWrite1 <= 0;
			Valid_Instruction_OUT <= 1'b0;
		end
		else if(!FREEZE)
		begin
			ROBPointer <= wROBPointer;
			Instr1 <= wInstr;
			PCA <= IQLSQ_popData_IN[136:105];
			// writeRegister1 <= wwriteRegister1;
			// readRegisterA1 <= wreadRegisterA1;
			Operand_A1 <= Reg[readRegisterA1];
			// Immediate <= wImmediate;
			// ALU_control1 <= wALU_control1;
			Dest_Value1 <= Reg[writeRegister1];
			// instruction 1 input
			readRegisterB1 <= !wmem_or_not_mem? IQLSQ_popData_IN[088:083] : 0;
			Operand_B1 <= !wmem_or_not_mem? Reg[IQLSQ_popData_IN[088:083]] : 0;
			Instr1_10_6 <= !wmem_or_not_mem? wInstr[10:6] : 0;
			ALUSrc1 <= !wmem_or_not_mem? IQLSQ_popData_IN[097:097] : 0;
			RegDest <= !wmem_or_not_mem? IQLSQ_popData_IN[096:096] : 0;
			Branch_flag <= !wmem_or_not_mem? IQLSQ_popData_IN[100:100] : 0;
			jump_flag <= !wmem_or_not_mem? IQLSQ_popData_IN[101:101] : 0;
			jump_register <= !wmem_or_not_mem? IQLSQ_popData_IN[102:102] : 0;
			// LS output
			MemRead1 <= wmem_or_not_mem? IQLSQ_popData_IN[098:098] : 0;
			MemWrite1 <= wmem_or_not_mem? IQLSQ_popData_IN[099:099] : 0;
			Valid_Instruction_OUT <= Valid_Instruction_IN;
		end
	end
	
	always @ (posedge CLK)
	begin
		if (write_register_flag) 
			Reg[write_register_index] = write_register_data;
	end
	
	always @ (posedge CLK)
	begin
		if (RF_DEBUG)
		begin
			$display("==RF===================================================");
		end
	end	

endmodule
