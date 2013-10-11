//-----------------------------------------
//            Pipelined MIPS
//-----------------------------------------
module MIPS (	R2_output,
             	MemRead,
             	MemWrite,
             	dBlkRead,
             	dBlkWrite,
             	iBlkRead,
             	iBlkWrite,
             	data_write_2DM,
             	//data_read_fDM,
				block_write_2IM,
				block_write_2DM,
				block_read_fIM,
				block_read_fDM,
             	//Instr1_fIM,
				//Instr2_fIM,
             	data_address_2DM,
             	CLK,
				RESET,
             	R2_input,
             	PC_init
            	);

   output [31: 0] R2_output;
   output [31: 0] data_address_2DM;
   output [31: 0] data_write_2DM;
   output[255: 0] block_write_2DM;
   output[255: 0] block_write_2IM;
   output         MemRead;
   output         MemWrite;
   output         dBlkRead;
   output         dBlkWrite;
   output         iBlkRead;
   output         iBlkWrite;

   input  [31: 0]  PC_init;
   input  [31: 0]  R2_input;
//   input  [31: 0]  data_read_fDM;
//   input  [31: 0]  Instr1_fIM;
//   input  [31: 0]  Instr2_fIM;
   input [255: 0]  block_read_fDM;
   input [255: 0]  block_read_fIM;
   input 	   CLK;
   input           RESET;

   //connecting wires (signals passing through more than 1 stage)
   wire [31: 0]   R2_output_ID/*verilator public*/;
   wire [31: 0]   Instr_fMEM/*verilator public*/;
   wire [31: 0]   Reg_ID [0:31]/*verilator public*/;  
   wire [31: 0]   Instr_address_2IM/*verilator public*/;
   wire [31: 0]   CIA_IFID/*verilator public*/;
   wire [31: 0]   PCA_IFID/*verilator public*/;
   wire [31: 0]   nextInstruction_address_IDIF/*verilator public*/;
   wire           no_fetch/*verilator public*/;
   wire           SYS/*verilator public*/;
   // wire           single_fetch_IDIF/*verilator public*/;

   //connecting wires (bifurcated signals passing through more than 1 stage)
   wire [31: 0]   writeData1_WBID/*verilator public*/;
   wire [31: 0]   writeData2_WBID/*verilator public*/;
   wire [31: 0]   writeData1_WBEXE/*verilator public*/;
   wire [31: 0]   writeData2_WBEXE/*verilator public*/;
   wire [31: 0]   writeData1_MID/*verilator public*/;
   wire [31: 0]   writeData2_MID/*verilator public*/;
   wire [31: 0]   Dest_Value1_IDEXE/*verilator public*/;
   wire [31: 0]   Dest_Value2_IDEXE/*verilator public*/;
   wire [31: 0]   Dest_Value1_EXEM/*verilator public*/;
   wire [31: 0]   Dest_Value2_EXEM/*verilator public*/;
   wire [31: 0]   Instr1_IDREN/*verilator public*/;
   wire [31: 0]   Instr2_IDEXE/*verilator public*/;
   wire [31: 0]   Instr1_EXEM/*verilator public*/;
   wire [31: 0]   Instr2_EXEM/*verilator public*/;
//   wire [31: 0]   Instr1_fIM/*verilator public*/;
//   wire [31: 0]   Instr2_fIM/*verilator public*/;
   wire [31: 0]   Instr1_IFID/*verilator public*/;
   wire [31: 0]   Instr2_IFID/*verilator public*/;
   wire [31: 0]   Operand_A1_IDEXE/*verilator public*/;
   wire [31: 0]   Operand_A2_IDEXE/*verilator public*/;
   wire [31: 0]   Operand_B1_IDEXE/*verilator public*/;
   wire [31: 0]   Operand_B2_IDEXE/*verilator public*/;
   wire [31: 0]   aluResult1_EXEM/*verilator public*/;
   wire [31: 0]   aluResult2_EXEM/*verilator public*/;
   wire [31: 0]   aluResult1_EXEID/*verilator public*/;
   wire [31: 0]   aluResult2_EXEID/*verilator public*/;
   wire [31: 0]   aluResult1_MEMW/*verilator public*/;
   wire [31: 0]   aluResult2_MEMW/*verilator public*/;
   wire [31: 0]   aluResult1_WBID/*verilator public*/;
   wire [31: 0]   aluResult2_WBID/*verilator public*/;
   wire [31: 0]   data_read1_MEMW/*verilator public*/;
   wire [31: 0]   data_read2_MEMW/*verilator public*/;
   wire [31: 0]   readDataB1_IDEXE/*verilator public*/;
   wire [31: 0]   readDataB2_IDEXE/*verilator public*/;
   wire [31: 0]   readDataB1_EXEM/*verilator public*/;
   wire [31: 0]   readDataB2_EXEM/*verilator public*/;
   wire [ 5: 0]   ALU_control1_IDEXE/*verilator public*/;
   wire [ 5: 0]   ALU_control2_IDEXE/*verilator public*/;
   wire [ 5: 0]   ALU_control1_EXEM/*verilator public*/;
   wire [ 5: 0]   ALU_control2_EXEM/*verilator public*/;
   wire [ 4: 0]   wWrRegID_IDREN/*verilator public*/;
   wire [ 4: 0]   writeRegister1_IDEXE/*verilator public*/;
   wire [ 4: 0]   writeRegister2_IDEXE/*verilator public*/;
   wire [ 4: 0]   writeRegister1_EXEM/*verilator public*/;
   wire [ 4: 0]   writeRegister2_EXEM/*verilator public*/;
   wire [ 4: 0]   writeRegister1_MEMW/*verilator public*/;
   wire [ 4: 0]   writeRegister2_MEMW/*verilator public*/;
   wire [ 4: 0]   writeRegister1_WBID/*verilator public*/;
   wire [ 4: 0]   writeRegister2_WBID/*verilator public*/;
   wire [ 4: 0]   writeRegister1_WBEXE/*verilator public*/;
   wire [ 4: 0]   writeRegister2_WBEXE/*verilator public*/;
   wire [ 4: 0]   Instr1_10_6_IDEXE/*verilator public*/;
   wire [ 4: 0]   Instr2_10_6_IDEXE/*verilator public*/;
   wire [ 4: 0]   readRegisterA2_IDEXE/*verilator public*/;
   wire [ 4: 0]   readRegisterA1_IDEXE/*verilator public*/;
   wire [ 4: 0]   readRegisterB1_IDEXE/*verilator public*/;
   wire [ 4: 0]   readRegisterB2_IDEXE/*verilator public*/;
   wire           MemtoReg1_IDEXE/*verilator public*/;
   wire           MemtoReg2_IDEXE/*verilator public*/;
   wire 	  MemtoReg1_EXEM/*verilator public*/;
   wire 	  MemtoReg2_EXEM/*verilator public*/;
   wire           MemtoReg1_MEMW/*verilator public*/;
   wire           MemtoReg2_MEMW/*verilator public*/;
   wire 	  MemRead1_IDEXE/*verilator public*/;
   wire           MemRead2_IDEXE/*verilator public*/;
   wire           MemRead1_EXEM/*verilator public*/;
   wire           MemRead2_EXEM/*verilator public*/;
   wire 	  MemWrite1_IDEXE/*verilator public*/;
   wire           MemWrite2_IDEXE/*verilator public*/;
   wire           MemWrite1_EXEM/*verilator public*/;
   wire           MemWrite2_EXEM/*verilator public*/;
   wire           do_writeback1_WBID/*verilator public*/;
   wire           do_writeback2_WBID/*verilator public*/;
   wire           do_writeback1_IDEXE/*verilator public*/;
   wire           do_writeback2_IDEXE/*verilator public*/;
   wire           do_writeback1_MEMW/*verilator public*/;
   wire           do_writeback2_MEMW/*verilator public*/;
   wire           do_writeback1_EXEM/*verilator public*/;
   wire           do_writeback2_EXEM/*verilator public*/;
   wire           do_writeback1_WBEXE/*verilator public*/;
   wire           do_writeback2_WBEXE/*verilator public*/;
   wire           taken_branch1_IDIF/*verilator public*/;
   wire           taken_branch2_IDIF/*verilator public*/;
   wire           fetchNull1_fID/*verilator public*/;
   wire           fetchNull2_fID/*verilator public*/;
   wire           ALUSrc1_IDEXE/*verilator public*/;
   wire           ALUSrc2_IDEXE/*verilator public*/;
   wire           ALUSrc1_EXEM/*verilator public*/;
   wire           ALUSrc2_EXEM/*verilator public*/;
   wire           FREEZE/*verilator public*/;
   wire [ 31: 0]  Instr1_fIC/*verilator public*/;
   wire [ 31: 0]  Instr2_fIC/*verilator public*/;
   // wire           single_fetch_iCache;

   wire [1:0]     isRegWrInstr_IDREN/*verilator public*/;
   
   wire [  1: 0]  MVECT/*verilator public*/;
   wire [  1: 0]  DataWriteMode;
   wire [ 31: 0]  data_read_fDC;
   wire           IMISS;
   wire           DMISS;
   wire           do_fetch;

   assign do_fetch = ~no_fetch;
   assign FREEZE = DMISS | IMISS;
   assign DataWriteMode = (Instr_fMEM[31: 26]==40)? 2'b01: ((Instr_fMEM[31: 26]==41)? 2'b10: 2'b00);
   // assign single_fetch_iCache = single_fetch_IDIF;


  iCache iCache1 (CLK, RESET, SYS, do_fetch, iBlkRead, iBlkWrite, Instr_address_2IM, block_read_fIM, block_write_2IM, Instr1_fIC, Instr2_fIC, IMISS, MVECT);

	// URGENT: THESE CONNECTIONS I BELIEVE ARE WRONG
  dCache dCache1 (CLK, RESET, SYS, MemRead, MemWrite, DataWriteMode, dBlkRead, dBlkWrite, data_address_2DM, data_write_2DM, block_read_fDM, block_write_2DM, data_read_fDC, DMISS);

   integer n;
   always @ (posedge CLK) begin
     //$display("[%d] %x %x %x %x %x %x %x", n, SYS, do_fetch, iBlkRead, iBlkWrite, Instr_address_2IM, Instr1_fIC, IMISS);
     if(!FREEZE && do_fetch) begin
       //if(!single_fetch_iCache && Instr2_fIC != Instr2_fIM) begin
         //$display("[%d] @%x (%x) %x != %x", n, Instr_address_2IM, MVECT, Instr2_fIC, Instr2_fIM);
         //$stop();
       //end
     end
     n = n+1;
   end

	wire branch_misprediction;
	wire [31:0] branch_address_COMMIT;
   // Pipeline Stages Instantiation
   IF #(.comment(0))
   	IF1( CLK,
        RESET,
        .FREEZE(FREEZE || wQ_IFID_full),
        .fetchNull2(0),//.fetchNull2(fetchNull2_fID),
        PCA_IFID,
        CIA_IFID,
        no_fetch,
        // /*single_fetch_IDIF*/single_fetch_iCache,
        // taken branch flag comes from commit stage
        .taken_branch1(branch_misprediction),//.taken_branch1(taken_branch1_IDIF),
        .nextInstruction_address(branch_address_COMMIT),//.nextInstruction_address(nextInstruction_address_IDIF),
        PC_init,
        /*Instr1_fIM*/Instr1_fIC,
        Instr1_IFID,
        Instr2_IFID,
        Instr_address_2IM,
		.tQ_IFID_pushReq(wQ_IFID_pushReq),
		.tQ_IFID_full(wQ_IFID_full)
    );
   


	////////////////////////////////////////////////////////////////////////////
	// Q_IFID///////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	parameter Q_IFID_DATAWIDTH = 32 + 32 + 32; 	// PCA + CIA + Instr
	parameter Q_IFID_ADDRWIDTH = 3;		// bits in addr ptr. 2^x elems in queue
	
	wire wQ_IFID_empty;
	wire wQ_IFID_full;
	wire wQ_IFID_pushReq;
	wire wQ_IFID_popReq;
	wire wQ_IFID_popValid;
	wire [Q_IFID_DATAWIDTH -1:0] wQ_IFID_pushData;
	wire [Q_IFID_DATAWIDTH -1:0] wQ_IFID_popData;
	wire wQ_IFID_curTail_OUT;
	wire wQ_IFID_curHead_OUT;
	wire wQ_IFID_probeIdx_IN;
	wire wQ_IFID_probeData_OUT;
	wire wQ_IFID_probePushReq_IN;
	wire wQ_IFID_probeData_IN;
	
	
	
	
		
	assign wQ_IFID_pushData = {PCA_IFID, CIA_IFID, Instr1_IFID};
			
	queue #(.DATA_WIDTH(Q_IFID_DATAWIDTH), 	// in bits
			.ADDR_WIDTH(Q_IFID_ADDRWIDTH), 	// in bits
			.SHOW_DEBUG(0),					// True/False
			.QUEUE_NAME("IFID"))			// Name for debuging
		Q_IFID (.clk(CLK),
			.reset(RESET),
			.pushReq_IN(wQ_IFID_pushReq),		// from IF
			.data_IN(wQ_IFID_pushData),			// from IF
			.popReq_IN(wQ_IFID_popReq),			// from ID
			.data_OUT(wQ_IFID_popData),			// to ID
			.emptyFlag_OUT(wQ_IFID_empty), 		// to ID
			.fullFlag_OUT(wQ_IFID_full),		// to IF
			.flush_IN(0),

			.curTail_OUT(wQ_IFID_curTail_OUT),
			.curHead_OUT(wQ_IFID_curHead_OUT),

			
			
	
	// // Queue popping check
	// popCheck #(.DATA_WIDTH(Q_IFID_DATAWIDTH))
		// popCheckIFID  (
			// .clk(CLK), 
			// .reset(RESET), 
			// .popOut(wQ_IFID_popReq), 
			// .dataIn(wQ_IFID_popData), 
			// .emptyIn(wQ_IFID_empty));
	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
/*
	DECODE
		Modifications
			Freeze logic - should freeze when it cannot push or when it cannot pull

		Issues
			Syscalls - SYS and no_fetch? - connected to iCache right now thru do_fetch.
			So this DOES stall IF and i$.
			
*/
	wire wFreezeID;
	assign wFreezeID = wQ_IFID_empty || wQ_IDREN_full;
	
   ID #(.comment1(1), .comment3(0))
   		ID1( CLK,
        RESET,
        .FREEZE(wFreezeID),					// *
        ALUSrc1_IDEXE,			// 2REN
        fetchNull2_fID,						// 2IF - Now hardcoded to 0 at IF
        // single_fetch_IDIF,				// 2IF - unused. Commented out from everywhere by me 
        Instr1_IDREN,			// 2REN
        Dest_Value1_IDEXE,		// 2REN
        no_fetch,							// 2IF - Problems!
        SYS,								// 2 i$ and d$
        readDataB1_IDEXE,		// 2REN	
        Instr1_10_6_IDEXE,		// 2REN
        do_writeback1_EXEM,
        writeRegister1_EXEM,
        writeData1_MID,
        do_writeback1_WBID,
        writeRegister1_WBID,
        writeData1_WBID,
        aluResult1_EXEID,
        do_writeback1_IDEXE,	// 2REN
        readRegisterA1_IDEXE,	// 2REN
        readRegisterB1_IDEXE,	// 2REN
        taken_branch1_IDIF,					// 2IF - Removed from IF
        aluResult1_WBID,
        nextInstruction_address_IDIF,		// 2IF - Removed from IF
        Reg_ID,
        R2_output_ID,
        Operand_A1_IDEXE,		// 2REN
        Operand_B1_IDEXE,		// 2REN
        ALU_control1_IDEXE,		// 2REN
        MemRead1_IDEXE,			// 2REN
        MemWrite1_IDEXE,		// 2REN	
        MemtoReg1_IDEXE,		// 2REN
        .fQ_IFID_Instr1	(wQ_IFID_popData[31:0]),	// fIF Queue
        .fQ_IFID_PCA	(wQ_IFID_popData[95:64]),	// fIF Queue
        writeData1_WBID,
        R2_input,
        .fQ_IFID_CIA	(wQ_IFID_popData[63:32]),	// fIF Queue
		.tQ_IFID_popReq_OUT (wQ_IFID_popReq),
		.fQ_IFID_empty_IN	(wQ_IFID_empty),
		.tQ_IDREN_pushReq_OUT(wQ_IDREN_pushReq),
		.fQ_IDREN_full_IN	(wQ_IDREN_full),
		
		// to rename
	 	.writeRegister1_PR(wWrRegID_IDREN),
		.isRegWriteInstr_OUT(isRegWrInstr_IDREN),
		.isJump_OUT(jump_IDREN),
		.isJumpReg_OUT(jumpReg_IDREN),
		.isBranch_OUT(branch_IDREN),
		.isLink_OUT(link_IDREN),
		.PCA_OUT(PCA_IDREN),
		.CIA_OUT(CIA_IDREN),
		.signExtImm_OUT(signExtImm_IDREN)
    );
	/*
EXE EXE1( CLK, RESET, FREEZE,ALUSrc1_EXEM,ALUSrc1_IDEXE,Instr1_IDREN,Instr1_EXEM,
	Dest_Value1_IDEXE,Dest_Value1_EXEM,readDataB1_IDEXE,readDataB1_EXEM,aluResult1_EXEID,
	do_writeback1_WBEXE,writeRegister1_WBEXE,writeData1_WBEXE,ALU_control1_EXEM,
	ALU_control1_IDEXE,writeData1_WBID,writeRegister1_MEMW,do_writeback1_MEMW,do_writeback1_EXEM,
	do_writeback1_IDEXE,readRegisterA1_IDEXE,readRegisterB1_IDEXE,wWrRegID_IDREN,
	writeRegister1_EXEM,Instr1_10_6_IDEXE,MemRead1_IDEXE,MemWrite1_IDEXE,MemRead1_EXEM,
	MemWrite1_EXEM,Operand_A1_IDEXE,Operand_B1_IDEXE,MemtoReg1_IDEXE,MemtoReg1_EXEM,aluResult1_EXEM
);*/
	
	wire	link_IDREN,	jumpReg_IDREN, jump_IDREN, branch_IDREN;
	wire [31:0] PCA_IDREN, CIA_IDREN, signExtImm_IDREN;
	
	////////////////////////////////////////////////////////////////////////////
	// Q_IDREN (ID-RegRename queue)/////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////

	parameter Q_IDREN_DATAWIDTH = 126;
	parameter Q_IDREN_ADDRWIDTH = 3;
	
	wire wQ_IDREN_empty;
	wire wQ_IDREN_full;
	wire wQ_IDREN_pushReq;
	wire wQ_IDREN_popReq;
	wire wQ_IDREN_popValid;
	wire [Q_IDREN_DATAWIDTH - 1:0] wQ_IDREN_pushData;
	wire [Q_IDREN_DATAWIDTH - 1:0] wQ_IDREN_popData;
	
	assign wQ_IDREN_pushData = {ALUSrc1_IDEXE,		//1		125:125
								signExtImm_IDREN,	//32	124:093
								ALU_control1_IDEXE,	//6		092:087
								CIA_IDREN,			//32	086:055
								readRegisterA1_IDEXE,//5	054:050
								readRegisterB1_IDEXE,//5	049:045
								link_IDREN,			//1		044:044
								jumpReg_IDREN,		//1		043:043
								jump_IDREN,			//1		042:042
								branch_IDREN,		//1		041:041
								MemWrite1_IDEXE,	//1		040:040
								MemRead1_IDEXE, 	//1		039:039
								wWrRegID_IDREN, 	//5		038:034
								isRegWrInstr_IDREN, //2		033:032
								Instr1_IDREN};		//32	031:000
				
	queue #(.DATA_WIDTH(Q_IDREN_DATAWIDTH),
			.ADDR_WIDTH(Q_IDREN_ADDRWIDTH),
			.SHOW_DEBUG(0),				
			.QUEUE_NAME("IDREN"))
		Q_IDREN (
			.clk(CLK),
			.reset(RESET),
			.pushReq_IN(wQ_IDREN_pushReq),	
			.data_IN(wQ_IDREN_pushData),	
			.fullFlag_OUT(wQ_IDREN_full),	
			
			.popReq_IN(wQ_IDREN_popReq),	
			.data_OUT(wQ_IDREN_popData),	
			.emptyFlag_OUT(wQ_IDREN_empty),
			.flush_IN(wfROB_flushALL));
	
	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// REG RENAME - REN.v///////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	
	parameter PHYSREGS_DEPTH = 6;				// 64 phys regs
	parameter ARCHREGS_DEPTH = 5;				// 32 architectural regs
	
	
	// Issue stage input data width
	parameter RENISSUE_WIDTH = 	183;	// See ren.v for members
	
	// Rename-ROB data width
	parameter RENROB_DATAWIDTH = 	RENISSUE_WIDTH;	
	
	wire wFreezeREN;
	wire wfROB_full;
	assign wFreezeREN = wQ_IDREN_empty || wfROB_full;
	
	wire wtIQ_pushReq;
	wire [RENISSUE_WIDTH-1:0] wtIQ_pushData;
	wire wfIQ_full;
	wire wtLSQ_pushReq;
	wire [RENISSUE_WIDTH-1:0] wtLSQ_pushData;
	wire wfLSQ_full;
	wire FreeL_push_Req;
	wire [5:0] FreeL_push_Data;
	
	wire [PHYSREGS_DEPTH-1: 0]	renrat [31:0] /*verilator public*/;
	
	REN #(	.IDREN_POP_WIDTH(Q_IDREN_DATAWIDTH),
			.PHYSREGS_DEPTH(PHYSREGS_DEPTH),
			.ARCHREGS_DEPTH(ARCHREGS_DEPTH),
			.RENISSUE_WIDTH(RENISSUE_WIDTH),
			.RENROB_DATAWIDTH(RENROB_DATAWIDTH),
			.ROB_ADDRWIDTH(ROB_ADDRWIDTH),
			.comment(0),
			.SHOW_FREELIST(0))
	rename (CLK, RESET, 
	
		.FREEZE(wFreezeREN),
		
		// Decode
		.tQ_IDREN_popReq_OUT (wQ_IDREN_popReq),
		.fQ_IDREN_empty_IN	(wQ_IDREN_empty),
		.fQ_IDREN_popData_IN (wQ_IDREN_popData),
		
		// Issue/LSQ
		.tIQ_pushReq_OUT(wtIQ_pushReq),
		.tIQ_pushData_OUT(wtIQ_pushData),
		.fIQ_full_IN(wfIQ_full),
		.tLSQ_pushReq_OUT(wtLSQ_pushReq),
		.tLSQ_pushData_OUT(wtLSQ_pushData),
		.fLSQ_full_IN(wfLSQ_full),
		
		// ROB
		.fROB_full_IN(wfROB_full),
		.tROB_pushReq_OUT(wtROB_pushReq),
		.tROB_pushData_OUT(wtROB_pushData),
		.fROB_curTail_IN(wfROB_curTail),
		
		// Rename RAT overwrite
		.tRenRatOverwrite_IN(wfRETRAT_copyRetRat),
		.tRenRatOverwriteData_IN(wRetRat),
		
		// Freelist push interfaces
		.tFreeL_pushReq_IN (FreeL_push_Req),
		.tFreeL_pushData_IN (FreeL_push_Data),
		.fFreeL_full_OUT(),
		
		.renrat(renrat)
		);

	
	
/*	always @(posedge CLK) begin
		$display("+++++++++ MIPS - RENAME (OUT)ERFACE");
		$display ("IQPUSH:%x I:%x IsRegWr:%x aRegID:%d IsMemR:%x IsMemWr:%x PhReg:%d", 
					wtIQ_pushReq, 
					wtIQ_pushData[31:0],
					wtIQ_pushData[33:32],
					wtIQ_pushData[38:34],
					wtIQ_pushData[39],
					wtIQ_pushData[40],		
					wtIQ_pushData[46:41]);

		$display ("LSQPUSH:%x I:%x IsRegWr:%x aRegID:%d IsMemR:%x IsMemWr:%x PhReg:%d", 
					wtLSQ_pushReq, 
					wtLSQ_pushData[31:0],
					wtLSQ_pushData[33:32],
					wtLSQ_pushData[38:34],
					wtLSQ_pushData[39],
					wtLSQ_pushData[40],		
					wtLSQ_pushData[46:41]);

					
		$display ("ROBpush: %x", wtROB_pushReq);
		// $display ("", );
	end*/
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// ISSUE - ISS.v////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	parameter IQLSQ_WIDTH = 137;
	
	wire [IQLSQ_WIDTH-1:0]	wIQLSQ_popData;
	wire			wValid_Instruction;
	wire			wMem_Instruction;
	wire wFreezeISS;
	assign wFreezeISS = DMISS;
	
	ISS #(	.RENISS_WIDTH(RENISSUE_WIDTH),
			.IDREN_WIDTH(Q_IDREN_DATAWIDTH),
			.IQLSQ_WIDTH(IQLSQ_WIDTH))
	issue (	CLK, RESET, 
			.FREEZE(wFreezeISS),
			
			// IQ inputs
			.IQ_pushReq_IN (wtIQ_pushReq),
			.IQ_pushData_IN(wtIQ_pushData),
			
			// LSQ inputs
			.LSQ_pushReq_IN(wtLSQ_pushReq),
			.LSQ_pushData_IN(wtLSQ_pushData),				
			
		// outputs
			.IQLSQ_popData_OUT(wIQLSQ_popData),
			.Valid_Instruction(wValid_Instruction),
			.Mem_Instruction(wMem_Instruction),
			// IQ outputs
			.IQ_full_OUT(wfIQ_full),
			
			// LSQ outputs
			.LSQ_full_OUT(wfLSQ_full)
			);
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// RF_Read/Write - RF_RW.v//////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	wire wIQ_LSQ_pop;
	wire [ROB_ADDRWIDTH-1:0] wRF_RW_EXE_ROBPointer;
	wire [31: 0]	wRF_RW_EXE_PCA;
	wire [31: 0]	wRF_RW_EXE_Instr1;
	wire [ 5: 0]	wRF_RW_EXE_writeRegister1;
	wire [ 5: 0]	wRF_RW_EXE_readRegisterA1;
	wire [31: 0]	wRF_RW_EXE_Operand_A1;
	wire [31: 0]	wRF_RW_EXE_Immediate;
	wire [ 5: 0]	wRF_RW_EXE_ALU_control1;
	wire			wRF_RW_EXE_Mem_Instruction;
	wire [ 5: 0]	wRF_RW_EXE_readRegisterB1;
	wire [31: 0]	wRF_RW_EXE_Operand_B1;
	wire [ 4: 0]	wRF_RW_EXE_Instr1_10_6;	
	wire 		 	wRF_RW_EXE_ALUSrc1;
	wire 		 	wRF_RW_EXE_RegDest;
	wire 		 	wRF_RW_EXE_Branch_flag;
	wire			wRF_RW_EXE_jump_flag;
	wire [31: 0]	wRF_RW_EXE_Dest_Value1;
	wire 			wRF_RW_EXE_MemRead1;
	wire			wRF_RW_EXE_MemWrite1;
	wire [31: 0]	wMEM_RF_write_register_data;
	wire [ 5: 0]	wMEM_RF_write_register_index;
	wire			wMEM_RF_write_register_flag;
	wire			wRF_RW_EXE_Valid_Instruction;
	wire [31: 0]	Reg_RF [63:0] /*verilator public*/;
		
	RF #(.RENISS_WIDTH(IQLSQ_WIDTH),
			.IDREN_WIDTH(Q_IDREN_DATAWIDTH),
			.ROBINDEX(ROB_ADDRWIDTH))
	RF_ReadWrite	(	.FREEZE(DMISS), .CLK(CLK), .RESET(RESET),
						//inputs
						.IQLSQ_popData_IN(wIQLSQ_popData),
						.Valid_Instruction_IN(wValid_Instruction),
						.Mem_Instruction_IN(wMem_Instruction),
						.IQ_LSQ_pop(wIQ_LSQ_pop),
						//unpacked outputs
						// common
						.Valid_Instruction_OUT(wRF_RW_EXE_Valid_Instruction),
						.ROBPointer(wRF_RW_EXE_ROBPointer),
						.PCA(wRF_RW_EXE_PCA),
						.Instr1(wRF_RW_EXE_Instr1),
						.writeRegister1(wRF_RW_EXE_writeRegister1),
						.readRegisterA1(wRF_RW_EXE_readRegisterA1),
						.Operand_A1(wRF_RW_EXE_Operand_A1),
						.Immediate(wRF_RW_EXE_Immediate),
						.ALU_control1(wRF_RW_EXE_ALU_control1),
						.Mem_Instruction_OUT(wRF_RW_EXE_Mem_Instruction),
						// not memory
						.readRegisterB1(wRF_RW_EXE_readRegisterB1),
						.Operand_B1(wRF_RW_EXE_Operand_B1),
						.Instr1_10_6(wRF_RW_EXE_Instr1_10_6),
						.ALUSrc1(wRF_RW_EXE_ALUSrc1),
						.RegDest(wRF_RW_EXE_RegDest),
						.Branch_flag(wRF_RW_EXE_Branch_flag),
						.jump_flag(wRF_RW_EXE_jump_flag),
						// memory
						.Dest_Value1(wRF_RW_EXE_Dest_Value1),
						.MemRead1(wRF_RW_EXE_MemRead1),
						.MemWrite1(wRF_RW_EXE_MemWrite1),
						//write back
						.write_register_data(wMEM_RF_write_register_data),
						.write_register_index(wMEM_RF_write_register_index),
						.write_register_flag(wMEM_RF_write_register_flag),
						.Reg(Reg_RF)
					);
	
	
	////////////////////////////////////////////////////////////////////////////
	// EXE - EXE.v?/////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	wire [ROB_ADDRWIDTH-1:0] wEXE_MEM_ROBPointer;
	wire [31: 0]	wEXE_MEM_PCA;
	wire [31: 0]	wEXE_MEM_target_PC;
	wire [31: 0]	wEXE_MEM_Instr1;
	wire [31: 0]	wEXE_MEM_aluresult;
	wire [31: 0]	wEXE_MEM_address;
	wire [ 5: 0]	wEXE_MEM_writeRegister1;
	wire [ 5: 0]	wEXE_MEM_readRegisterA1;
	wire [ 5: 0]	wEXE_MEM_ALU_control1;
	wire			wEXE_MEM_Mem_Instruction;
	wire 		 	wEXE_MEM_RegDest;
	wire 		 	wEXE_MEM_Branch_flag;
	wire [31: 0]	wEXE_MEM_Dest_Value1;
	wire 			wEXE_MEM_MemRead1;
	wire			wEXE_MEM_MemWrite1;
	wire			wEXE_MEM_Hazard;
	wire			wEXE_MEM_Valid_Instruction;
	
	EXE EXE1(	// outputs
				.ROBPointer_OUT(wEXE_MEM_ROBPointer),
				.PCA_OUT(wEXE_MEM_PCA),
				.target_PC_OUT(wEXE_MEM_target_PC),
				.Instr1_OUT(wEXE_MEM_Instr1),
				.writeRegister1_OUT(wEXE_MEM_writeRegister1),
				.ALU_control1_OUT(wEXE_MEM_ALU_control1),
				.Dest_Value1_OUT(wEXE_MEM_Dest_Value1),
				.aluresult_OUT(wEXE_MEM_aluresult),
				.address_OUT(wEXE_MEM_address),
				.RegDest_OUT(wEXE_MEM_RegDest),
				.Branch_flag_OUT(wEXE_MEM_Branch_flag),
				.Mem_Instruction_OUT(wEXE_MEM_Mem_Instruction),

				.MemRead1_OUT(wEXE_MEM_MemRead1),
				.MemWrite1_OUT(wEXE_MEM_MemWrite1),
				.Mem_Hazard_PR_OUT(wEXE_MEM_Hazard),

				// COMMON SIGNALS
				.ROBPointer_IN(wRF_RW_EXE_ROBPointer),
				.PCA_IN(wRF_RW_EXE_PCA),
				.Instr1_IN(wRF_RW_EXE_Instr1),
				.writeRegister1_IN(wRF_RW_EXE_writeRegister1),
				.readRegisterA1_IN(wRF_RW_EXE_readRegisterA1),
				.Operand_A1_IN(wRF_RW_EXE_Operand_A1),
				.Immediate_IN(wRF_RW_EXE_Immediate),
				.ALU_control1_IN(wRF_RW_EXE_ALU_control1),
				.Dest_Value1_IN(wRF_RW_EXE_Dest_Value1),
				.Mem_Instruction_IN(wRF_RW_EXE_Mem_Instruction),

				.readRegisterB1_IN(wRF_RW_EXE_readRegisterB1),
				.Operand_B1_IN(wRF_RW_EXE_Operand_B1),
				.Instr1_10_6_IN(wRF_RW_EXE_Instr1_10_6),
				.ALUSrc1_IN(wRF_RW_EXE_ALUSrc1),
				.RegDest_IN(wRF_RW_EXE_RegDest),
				.Branch_flag_IN(wRF_RW_EXE_Branch_flag),
				.jump_flag_IN(wRF_RW_EXE_jump_flag),

				.MemRead1_IN(wRF_RW_EXE_MemRead1),
				.MemWrite1_IN(wRF_RW_EXE_MemWrite1),
					
				   // forward data
				.fwd_data_1_COM(wMEM_ROB_ALUResult),
				.fwd_reg_1_COM(wMEM_ROB_writeRegister1),
				.fwd_data_1_COM_flag(wMEM_EXE_RegDest),
				.LS_fwd_data_COM(wMEM_ROB_Dest_Value1),
				.LS_fwd_reg_COM(wMEM_ROB_writeRegister1),
				.LS_fwd_data_COM_flag(MemRead),
				
				.Valid_Instruction_IN(wRF_RW_EXE_Valid_Instruction),
				.Valid_Instruction_OUT(wEXE_MEM_Valid_Instruction),
				.FREEZE(DMISS), .CLK(CLK), .RESET(RESET)
				);

	
	
	////////////////////////////////////////////////////////////////////////////
	// MEM - MEM.v?/////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	wire [31: 0]	wMEM_ROB_target_PC;
	wire [31: 0]	wMEM_ROB_Instr1;
	wire [31: 0]	wMEM_ROB_ALUResult;
	wire [ 5: 0]	wMEM_ROB_writeRegister1;
	wire 		 	wMEM_ROB_Branch_flag;
	wire [31: 0]	wMEM_ROB_Dest_Value1;
	wire			wMEM_ROB_Hazard;
	wire			wMEM_EXE_RegDest;
	wire			wMEM_ROB_Valid_Instruction;

   MEM MEM1( .FREEZE(DMISS), .CLK(CLK), .RESET(RESET),
				.result(wMEM_ROB_ALUResult),
				.data_write_2DM(data_write_2DM), 
				.data_address_2DM(data_address_2DM),
				.Instr_OUT(wMEM_ROB_Instr1),
				.Data1_2ID(wMEM_ROB_Dest_Value1),
				.writeRegister1_PR(wMEM_ROB_writeRegister1),
				.do_writeback1_PR(wMEM_EXE_RegDest),
				.MemRead_2DM(MemRead),
				.MemWrite_2DM(MemWrite),
				.taken_branch1_OUT(wMEM_ROB_Branch_flag),
				.target_PC_OUT(wMEM_ROB_target_PC),
				.Mem_Hazard_OUT(wMEM_ROB_Hazard),
				.ROBPointer_OUT(wtROB_probeIdx),
				
				.ROBPointer_IN(wEXE_MEM_ROBPointer),
				.Mem_Hazard_IN(wEXE_MEM_Hazard),                
				.target_PC_IN(wEXE_MEM_target_PC),
				.aluResult1(wEXE_MEM_aluresult),
				.address(wEXE_MEM_address),
				.data_read_fDM(data_read_fDC),
				.Dest_Value1(wEXE_MEM_Dest_Value1),
				.Instr1(wEXE_MEM_Instr1),
				.ALU_control1(wEXE_MEM_ALU_control1),
				.writeRegister1(wEXE_MEM_writeRegister1),
				.do_writeback1(wEXE_MEM_RegDest),
				.MemRead1(wEXE_MEM_MemRead1),
				.MemWrite1(wEXE_MEM_MemWrite1),
				.taken_branch1_IN(wEXE_MEM_Branch_flag),
				.Mem_Instruction_IN(wEXE_MEM_Mem_Instruction),
				
				.Valid_Instruction_IN(wEXE_MEM_Valid_Instruction),
				.Valid_Instruction_OUT(wMEM_ROB_Valid_Instruction)
    );

	assign wMEM_RF_write_register_flag = (MemRead && !DMISS) || wMEM_EXE_RegDest;
	assign wMEM_RF_write_register_data = MemRead ? wMEM_ROB_Dest_Value1 : wMEM_EXE_RegDest ? wMEM_ROB_ALUResult : 0;
	assign wMEM_RF_write_register_index = wMEM_ROB_writeRegister1;


	////////////////////////////////////////////////////////////////////////////
	// COMMIT - COMMIT.v///////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	
	
	/* ROB supposed to have:
 		Finished bit ---> Should be written when the result is ready on 
						  one of the forwarding paths or the result has
						  been written to the physical registers.
		Instr type
		Arch: dest reg id
 		Phys: Dest mem addr or dest reg id
 		Dest write value
 		Exception/Branch Misprediction flag
		Instruction address -> for recovery from exception/misprediction
		
 		SEE REN.v
	*/
//	parameter	RENROB_DATAWIDTH 	= RENISS_WIDTH; 	// maybe diff from what RENAME pushes
	parameter	ROB_ADDRWIDTH 		= 6;	// in bits
	parameter RETRAT_WIDTH 		= 6;
	parameter RETRAT_DEPTH			= 32;
	
	wire wCommitFreeze, wtROB_pushReq, tROB_probePushReq_IN;
	wire [RENROB_DATAWIDTH-1:0] wtROB_pushData, wfROB_probeData, wtROB_probePushData;
	wire [ROB_ADDRWIDTH-1:0] 	wfROB_curTail, wfROB_curHead, wtROB_probeIdx;
	wire wfROB_flushALL, wfRETRAT_copyRetRat;	
	reg [RETRAT_WIDTH*RETRAT_DEPTH-1:0] 	wRetRat;// [1<<RETRAT_DEPTH-1:0];
	//assign wCommitFreeze = 
	
	wire [PHYSREGS_DEPTH-1: 0]	retrat [31:0] /*verilator public*/;

	COMMIT #(	.RENROB_DATAWIDTH(RENROB_DATAWIDTH), 
				.ROB_ADDRWIDTH(ROB_ADDRWIDTH),
				.RETRAT_WIDTH(PHYSREGS_DEPTH),
				.RETRAT_DEPTH(RETRAT_DEPTH),
				.comment(0))
	commit (CLK, RESET, .FREEZE(wCommitFreeze),
	
			.fROB_full_OUT(wfROB_full),
			.tROB_pushReq_IN(wtROB_pushReq),
			.tROB_pushData_IN(wtROB_pushData),
			.fROB_curTail_OUT(wfROB_curTail),
			.fROB_curHead_OUT(wfROB_curHead),
			
			.tROB_probeIdx_IN(wtROB_probeIdx),
			.tROB_probeSetFinBit_IN(wMEM_ROB_Valid_Instruction),
			.tROB_probeSetExpBit_IN(wMEM_ROB_Hazard),
			.tROB_probe_taken_branch(wMEM_ROB_Branch_flag),
			.tROB_probe_target_PC(wMEM_ROB_target_PC),
			// .fROB_probeData_OUT(wfROB_probeData),
			// .tROB_probePushReq_IN(wtROB_probePushReq),
			// .tROB_probePushData_IN(wtROB_probePushData),
			.flushEm_OUT (wfROB_flushALL),
		
			.copyRetRat_OUT (wfRETRAT_copyRetRat),
			.retRat_OUT (wRetRat),
			
			.tROB_reg_dest(wMEM_RF_write_register_flag),
			.fROB_free_register_flag_OUT(FreeL_push_Req),
			.fROB_free_register_Id_OUT(FreeL_push_Data),
			
			.fROB_target_PC_OUT(branch_address_COMMIT),
			.fROB_set_PC_OUT(branch_misprediction),
			
			.retrat(retrat)
		   );
		   

	always @(posedge CLK) begin
/*		$display("==IF================================================");
		$display("CIA:%x\tInstruction OUT:%x", CIA_IFID, Instr1_IFID);
		$display("==ID================================================");
		$display("CIA:%x\tInstruction OUT:%x", CIA_IDREN, Instr1_IDREN);
		$display("==REN===============================================");
		if(wtROB_pushReq) $display("ROB: %b",wfROB_curTail);
		if(wtIQ_pushReq) $display("IQ CIA:%x\tInstruction OUT:%x", wtIQ_pushData[086:055], wtIQ_pushData[031:000]);
		if(wtLSQ_pushReq) $display("LSQ CIA:%x\tInstruction OUT:%x", wtLSQ_pushData[086:055], wtLSQ_pushData[031:000]);
		$display("==ISS===============================================\n");
		//$display("ROB Pointer OUT: %x", wIQLSQ_popData[037:032]);
		$display("==RF================================================");
		$display("ROB: %x", wRF_RW_EXE_ROBPointer);
		if(wRF_RW_EXE_Valid_Instruction) $display("Read: REG[%d]: %d",wRF_RW_EXE_readRegisterA1, wRF_RW_EXE_Operand_A1);
		if(wMEM_RF_write_register_flag) $display("Write: REG[%d]: %d %x", wMEM_RF_write_register_index, wMEM_RF_write_register_data, wMEM_RF_write_register_data);
		$display("==EXE===============================================");
		$display("ROB Pointer OUT: %x; RESET: %d, FREEZE: %d", wEXE_MEM_ROBPointer, RESET, DMISS);
		$display("==MEM===============================================");
		$display("ROB Pointer OUT: %x", wtROB_probeIdx);
		$display("==COM===============================================");
		$display("Head Pointer: %x", wfROB_curHead);*/
		
	end
				
	
endmodule
