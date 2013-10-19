// COMMIT

/*
TO DO:

	SETUP DATA STRUCTURES:
		Retirement Rat					- done
		ROB                                             - done

	UPDATE ROB ENTRIES (finished bit, branch Misprediction etc)
		has to be done externally. 			- Interfaces in place
		
	MONITOR ROB HEAD ENTRY
		READ ENTRY, DECIDE WHETHER FIT FOR POPPING 	- done
		
	HANDLE SUCCESSFUL ROB POP
		DECODE ROB ENTRY				- not done
		UPDATE RETRAT					- not done
		UPDATE FREELIST					- not done
	
	HANDLE MISPREDICTION
		COPY RETRAT                                     - Connections in place
		Flush everything				- Connections in place
*/
module COMMIT (
	CLK, 
	RESET,
	FREEZE,
    		
	//-------------------------------------------------------------
	// ROB
	//-------------------------------------------------------------
	fROB_full_OUT,	
	tROB_pushReq_IN,
	tROB_pushData_IN,
	fROB_curTail_OUT,
	fROB_curHead_OUT,
	tROB_probeIdx_IN,
	//fROB_probeData_OUT,
	//tROB_probePushReq_IN,
	//tROB_probePushData_IN,
			
	tROB_probeSetFinBit_IN,
	tROB_probeSetExpBit_IN,
	tROB_probe_taken_branch,
	tROB_probe_target_PC,
				
	flushEm_OUT,
				
	copyRetRat_OUT,
	retRat_OUT,
				
	tROB_reg_dest,
	fROB_free_register_flag_OUT,
	fROB_free_register_Id_OUT,
				
	fROB_target_PC_OUT,
	fROB_set_PC_OUT,
				
	retrat
	);

	//-------------------------------------------------------------
   	// Global parameters and inputs
    	//-------------------------------------------------------------
	parameter comment = 0;
				
	input CLK, RESET, FREEZE;

	//-------------------------------------------------------------
	// ROB input/output from others Rename
	//-------------------------------------------------------------
	parameter RENROB_DATAWIDTH = 0;
	parameter ROB_ADDRWIDTH = 0;
				
	input					tROB_pushReq_IN;//, tROB_probePushReq_IN
	input 					tROB_probeSetFinBit_IN;
	input 	           	             	tROB_probeSetExpBit_IN;
	input 		[RENROB_DATAWIDTH-1:0] 	tROB_pushData_IN;//, tROB_probePushData_IN;
	input		[ROB_ADDRWIDTH-1:0]	tROB_probeIdx_IN;
	input 		[31:0]			tROB_probe_target_PC;
	input					tROB_probe_taken_branch;
				
	//output 	[RENROB_DATAWIDTH-1:0] 	fROB_probeData_OUT;
	output  reg 				fROB_full_OUT;
	output		[ROB_ADDRWIDTH-1:0]	fROB_curTail_OUT;
	output		[ROB_ADDRWIDTH-1:0]	fROB_curHead_OUT;
	output					flushEm_OUT;
				
	input					tROB_reg_dest;
	output reg               	      	fROB_free_register_flag_OUT;
	output reg	[5:0]			fROB_free_register_Id_OUT;
				
	output reg	[31:0]			fROB_target_PC_OUT;
	output reg				fROB_set_PC_OUT;
				
	//-------------------------------------------------------------
	// Retirement RAT
	//-------------------------------------------------------------
	parameter RETRAT_WIDTH = 0;
	parameter RETRAT_DEPTH = 0;

	output reg	[RETRAT_WIDTH*RETRAT_DEPTH-1:0] 	retRat_OUT;// 	[1<<RETRAT_DEPTH-1:0];
	output reg				copyRetRat_OUT;
	output reg 	[RETRAT_WIDTH-1:0] 	retrat [RETRAT_DEPTH-1:0];
	reg 		[RETRAT_DEPTH-1:0]	retrat_valid;
   	assign retRat_OUT = {
	        retrat[0],
        	retrat[1],
        	retrat[2],
        	retrat[3],
        	retrat[4],
        	retrat[5],
        	retrat[6],
        	retrat[7],
        	retrat[8],
        	retrat[9],
        	retrat[10],
        	retrat[11],
        	retrat[12],
        	retrat[13],
        	retrat[14],
        	retrat[15],
        	retrat[16],
        	retrat[17],
        	retrat[18],
        	retrat[19],                                    
        	retrat[20],
        	retrat[21],
        	retrat[22],
        	retrat[23],
        	retrat[24],
        	retrat[25],
        	retrat[26],
        	retrat[27],
        	retrat[28],
        	retrat[29],
        	retrat[30],
        	retrat[31]
    	};
				
				
	//-------------------------------------------------------------------------
	/* ROB: Convert be internal and external ROB signals 
		Flags over and above external ROB data
			FinishedBit:			1
			ExceptionBit:			1			
			(stuff added by ren.v):	RENROB_DATAWIDTH-1:0
	*/
	//-------------------------------------------------------------------------	
	parameter ROB_DATAWIDTH = RENROB_DATAWIDTH + 3;
	parameter pFINISH_DEFAULT = 1'b0; parameter pEXCEPT_DEFAULT = 1'b0;
	parameter pBRANCH_DEFAULT = 1'b0;
	integer i;
	
	/*				
    wTarget			     		// 182:151 target PC placeholder
	fQ_IDREN_popData_IN [125],	// 	150:150 1 ALU Src (Imm flag)
	wDestRegReqd,				// 	149:149 1 Dest reg reqd
	fQ_IDREN_popData_IN [124:93]// 148:117 32 signExt Imm
	fQ_IDREN_popData_IN [92:87],// 116:111 6 ALU control
	fROB_curTail_IN,			//	110:105	6 						
	rPhysSrc2Reg, 				//	104:099	6
	rPhysSrc1Reg, 				//	098:093	6
	rPhysDestReg,				//	092:087	6
	fQ_IDREN_popData_IN [86:55],// 086:055	32 PCA_IDREN
	fQ_IDREN_popData_IN [54:50],// 054:050	5 readRegisterA1_IDEXE
	fQ_IDREN_popData_IN [49:45],// 049:045	5 readRegisterB1_IDEXE
	fQ_IDREN_popData_IN [44:44],// 044:044	1 link_IDREN
	fQ_IDREN_popData_IN [43:43],// 043:043	1 jumpReg_IDREN
	fQ_IDREN_popData_IN [42:42],// 042:042	1 jump_IDREN
	fQ_IDREN_popData_IN [41:41],// 041:041	1 branch_IDREN
	fQ_IDREN_popData_IN [40:40],// 040:040	1 MemWrite1_IDEXE
	fQ_IDREN_popData_IN [39:39],// 039:039	1 MemRead1_IDEXE
	fQ_IDREN_popData_IN [38:34],// 038:034	5 wWrRegID_IDREN
	fQ_IDREN_popData_IN [33:32],// 033:032	2 isRegWrInstr_IDREN
	fQ_IDREN_popData_IN [31:00]}// 031:000	32 Instr1_IDREN
    */
	
	wire [ROB_DATAWIDTH-1:0] wROB_pushData, wROB_popData, wROB_probeDataOut, wROB_probeDataIn;
	wire wROB_popReq, wROB_empty;
	
	assign wROB_pushData 		= {pFINISH_DEFAULT, pEXCEPT_DEFAULT, pBRANCH_DEFAULT, tROB_pushData_IN};
	//assign fROB_probeData_OUT 	= wROB_probeDataOut[RENROB_DATAWIDTH-1:0];
	
	queue #(.DATA_WIDTH(ROB_DATAWIDTH), .ADDR_WIDTH(ROB_ADDRWIDTH), 
			.SHOW_DEBUG(comment), .QUEUE_NAME("Reorder Buffer"))
	ROB	(	CLK, RESET,
			.pushReq_IN(tROB_pushReq_IN), 	.data_IN(wROB_pushData),
			.popReq_IN(wROB_popReq), 		.data_OUT(wROB_popData),
			.emptyFlag_OUT(wROB_empty), 	.fullFlag_OUT(fROB_full_OUT),
			.curTail_OUT(fROB_curTail_OUT), .flush_IN (flushEm_OUT),
			.probeIdx_IN(tROB_probeIdx_IN),	.probeData_OUT(wROB_probeDataOut),
			.probePushReq_IN(tROB_probeSetFinBit_IN), .probeData_IN(wROB_probeDataIn),
			.curHead_OUT(fROB_curHead_OUT)
		);
	//-------------------------------------------------------------------------
	// ROB: Operations
	//-------------------------------------------------------------------------

	wire [ROB_DATAWIDTH-1:0]	wROBhead;
	wire wROBheadFin, wROBheadSafe, wROBheadRdy2Com, wROBhead_jump;
	wire [31:0]	 wROBhead_target_PC;
	
	assign wROBhead 		= (!wROB_empty)?wROB_popData:0;
	assign wROBheadFin 		= wROBhead[RENROB_DATAWIDTH+1];
	assign wROBheadSafe 	= !wROBhead[RENROB_DATAWIDTH];
	assign wROBheadRdy2Com 	=  wROBheadFin && wROBheadSafe;
	assign wROBhead_jump 	= wROBhead[42];
	assign wROBhead_target_PC = wROBhead[182:151];
	
	initial begin
		for(i = 1; i < 32; i=i+1) begin
			retrat[i] = retrat[i-1] +1;
		end
	end
	
	always @(posedge CLK) begin
		if (!RESET) begin
		
			flushEm_OUT <= 0;
			copyRetRat_OUT <= 0;
		end else if (!FREEZE) begin
			// Can we pop ROB?
			if (wROBheadRdy2Com) begin
				// We're ready to pop.
				wROB_popReq <= 1;
				// Now use wROB_popData and do your thang.
				
				if(tROB_reg_dest) begin
					retrat[wROBhead[038:034]] <= wROBhead[092:087]; // retrat indexed by architectural register gets physical register specifier 
					retrat_valid[wROBhead[038:034]] <= 1;
				
					// Access current RetRat, add it to free list
					fROB_free_register_flag_OUT <= tROB_reg_dest && retrat_valid[wROBhead[038:034]]; // if a physical register is allocated when a result comes, push request to freelist
					fROB_free_register_Id_OUT <= retrat[wROBhead[038:034]];
				end
				
				if(wROBhead_jump) begin
					fROB_set_PC_OUT <= 1;								// tell pc to reset
					fROB_target_PC_OUT <= wROBhead_target_PC;			// this is the value
					flushEm_OUT <= 1;									// flush the pipeline
					copyRetRat_OUT <= 1;								// copy the ret_rat
				end
				
			end else begin
				// Cannot pop ROB
				wROB_popReq <= 0;
				
				// Check why we cannot pop
				
				if (wROB_empty || !wROBheadFin) begin
					// Either ROB is empty or the head is not yet ready.
					// Chill. Do nothing.
					
				end else begin
					if (!wROBheadSafe) begin
						// aww he'yell no
						// Exception!
						
						// Flush everything! Connect wires in MIPs
						flushEm_OUT <= 1;
						
						// Copy retirement rat
						copyRetRat_OUT <= 1;
						
						// ANything else?
						
					end
				end
			
			end
		
			// probe push data
			if(tROB_probeSetFinBit_IN) begin
				wROB_probeDataIn 	= wROB_probeDataOut; 	// get data already in ROB entry and set the input to that
				if(tROB_probe_taken_branch) begin			// if we have a taken branch, do that stuff
					wROB_probeDataIn[42] = 1;
					wROB_probeDataIn[182:151] = tROB_probe_target_PC;
				end
				wROB_probeDataIn[RENROB_DATAWIDTH+1:RENROB_DATAWIDTH] = {tROB_probeSetFinBit_IN, tROB_probeSetExpBit_IN}; // if we have an exception, write it-
			end
			
			
		end
	
	end
	
	always @(posedge CLK) begin
		if(comment) begin
			//$display(
		end
	end
endmodule
