/*	
	/// COMMON 
	// I'm making a common buffer for both LSQ and IQ
	
	
Todo: 
	
*/		

module ISS	(	
			// inputs
			CLK, RESET, FREEZE,
				// IQ inputs
				IQ_pushReq_IN,
				IQ_pushData_IN,
				
				// LSQ inputs
				LSQ_pushReq_IN,
				LSQ_pushData_IN,
				
			// outputs
				IQLSQ_popData_OUT,
				Valid_Instruction,
				Mem_Instruction,
			
				// IQ outputs
				IQ_full_OUT,
				
				// LSQ outputs
				LSQ_full_OUT
			);

parameter reg_specifier_bits = 6;
parameter ROB_pointer_bits = 6;

parameter RENISS_WIDTH = 0; // Width of the incoming data from Rename
parameter IDREN_WIDTH = 0;

parameter IQLSQ_WIDTH = 0; // Change this in MIPS.v
parameter IQLSQ_DEPTH = 4;

input CLK;
input RESET;
input FREEZE;

//IQLSQ output
output reg [IQLSQ_WIDTH-1:0] IQLSQ_popData_OUT;
output reg 					Valid_Instruction;
output reg 					Mem_Instruction;

//LSQ
input LSQ_pushReq_IN;
output reg LSQ_full_OUT;
input [RENISS_WIDTH-1:0] LSQ_pushData_IN;

//IQ
input IQ_pushReq_IN;
output reg IQ_full_OUT;
input [RENISS_WIDTH-1:0] IQ_pushData_IN;

// forward data
// input          [ 5: 0] fwd_reg_1;
// input                  fwd_data_1_WB;
// input          [ 5: 0] fwd_reg_2;
// input                  fwd_data_2_WB;
// input          [ 5: 0] LS_fwd_reg;
// input                  LS_fwd_data_WB;


//==============================================================================
// CREATE COMMON IQ/LSQ ENTRY
//==============================================================================


wire [RENISS_WIDTH-1:0] wRENISS_pushData;
wire [IQLSQ_WIDTH-1:0] wIQLSQ_pushData;

wire wSrc2Rdy, wSrc1Rdy, wNeedDestReg, wImmSrc;
assign wNeedDestReg = wRENISS_pushData[149:149];
assign wSrc1Rdy = !busy_bits[wRENISS_pushData[98:93]];
assign wSrc2Rdy = wImmSrc || !busy_bits[wRENISS_pushData[104:99]];
assign wImmSrc = wRENISS_pushData[150];


/*	See REN.v for contents (section IQ/LSQ) */
assign wRENISS_pushData = (IQ_pushReq_IN)?IQ_pushData_IN:(LSQ_pushReq_IN)? LSQ_pushData_IN: 0;

assign wIQLSQ_pushData = {	wRENISS_pushData[086:055],	// 136:105 PCA
							wSrc1Rdy && wSrc2Rdy,		// 104:104 READY (both srcs)
							wRENISS_pushData [44], 		// 103:103 link
							wRENISS_pushData [43], 		// 102:102 jumpReg
							wRENISS_pushData [42], 		// 101:101 jump
							wRENISS_pushData [41], 		// 100:100 branch
							wRENISS_pushData [40], 		// 099:099 MemWrite
							wRENISS_pushData [39], 		// 098:098 MemRead							
							wImmSrc,					// 097:097 Imm src			- LSQ & IQ
							wNeedDestReg,				// 096:096 Need Dest Reg?	- LSQ & IQ
							wRENISS_pushData[92:87],	// 095:090 dest reg			- LSQ & IQ
							wSrc2Rdy,					// 089:089 Src2 rdy			- IQ only
							wRENISS_pushData[104:99],	// 088:083 Src2 phys reg 	- IQ only
							wSrc1Rdy,					// 082:082 Src1 rdy 		- LSQ & IQ
							wRENISS_pushData[98:93],	// 081:076 Src1 phys reg 	- LSQ & IQ
							wRENISS_pushData[124:93],	// 075:044 32b signExt Imm	- LSQ & IQ
							wRENISS_pushData[92:87],	// 043:038 ALU control		- LSQ & IQ
							wRENISS_pushData[110:105],	// 037:032 ROB ptr			- LSQ & IQ
							wRENISS_pushData[31:00]		// 031:000 Instr			- LSQ & IQ
						 };

// Select whether to send IQ or LSQ
reg		rPr; /* priority of IQ vs LSQ */ always @(posedge CLK) 	rPr <= rPr + 1;



	wire [137-1:0] wLSQ_headData, wLSQ_tailData;

wire wIQselected, wLSQselected, wIQrdy, wLSQrdy;
assign IQLSQ_popData_OUT = wIQselected? wIQ_popData: (wLSQselected? wLSQ_popData: 0);
assign Valid_Instruction = wIQselected || wLSQselected;
assign Mem_Instruction = wLSQselected;
assign wIQrdy = !wIQ_empty && instruction_ready;
assign wLSQrdy = !wLSQ_empty && !busy_bits[wLSQ_headData[081:076]];

assign IQ_full_OUT = wIQ_full;
assign LSQ_full_OUT = wLSQ_full;
//==============================================================================
// BUSY REGISTER
//==============================================================================
	parameter phys_reg_specifier = 64;
	reg busy_bits [phys_reg_specifier-1:0];
//==============================================================================
// END
//==============================================================================


//==============================================================================
// IQ AND LSQ - wires and stuff
//==============================================================================	
	
	reg [IQLSQ_WIDTH-1:0]	IQ [1<<IQLSQ_DEPTH-1:0];
	
	wire [3:0] PE_Request, PE_Grant;
	wire [15:0] request_bus, grant_bus;
	wire instruction_ready;
		 
	wire [IQLSQ_WIDTH-1:0] wIQ_popData, wLSQ_popData;
	
	assign request_bus[0] = IQ[0][104]; // Ready bit
	assign request_bus[1] = IQ[1][104]; // Ready bit
	assign request_bus[2] = IQ[2][104]; // Ready bit
	assign request_bus[3] = IQ[3][104]; // Ready bit
	assign request_bus[4] = IQ[4][104]; // Ready bit
	assign request_bus[5] = IQ[5][104]; // Ready bit
	assign request_bus[6] = IQ[6][104]; // Ready bit
	assign request_bus[7] = IQ[7][104]; // Ready bit
	assign request_bus[8] = IQ[8][104]; // Ready bit
	assign request_bus[9] = IQ[9][104]; // Ready bit
	assign request_bus[10] = IQ[10][104]; // Ready bit
	assign request_bus[11] = IQ[11][104]; // Ready bit
	assign request_bus[12] = IQ[12][104]; // Ready bit
	assign request_bus[13] = IQ[13][104]; // Ready bit
	assign request_bus[14] = IQ[14][104]; // Ready bit
	assign request_bus[15] = IQ[15][104]; // Ready bit

	PE PE_top(FREEZE, PE_Request, PE_Grant, instruction_ready);
	PE PE0 (PE_Grant[0], request_bus[3:0], grant_bus[3:0], PE_Request[0]);
	PE PE1 (PE_Grant[1], request_bus[7:4], grant_bus[7:4], PE_Request[1]);
	PE PE2 (PE_Grant[2], request_bus[11:8], grant_bus[11:8], PE_Request[2]);
	PE PE3 (PE_Grant[3], request_bus[15:12], grant_bus[15:12], PE_Request[3]);
	
	integer counter, pos;
	reg	[5:0] pos1;
			
	integer IQcount;
	
	wire wIQ_empty, wIQ_full;
	assign wIQ_empty = IQcount == 0;
	assign wIQ_full = IQcount == 16;
			
	// LSQ
	wire wLSQ_pushReq, wLSQ_popReq, wLSQ_empty, wLSQ_full;
	wire [5:0] wLSQ_srcReg, wLSQ_destReg_IN;
//	wire [IQLSQ_WIDTH-1:0] wLSQ_headData, wLSQ_tailData;
	
	assign LSQ_full_OUT 	= wLSQ_full;
	assign wLSQ_srcReg 		= wRENISS_pushData[98:93];
	assign wLSQ_destReg_IN 	= wRENISS_pushData[92:87];
	
	queue #(.DATA_WIDTH(IQLSQ_WIDTH),
			.ADDR_WIDTH(IQLSQ_DEPTH),
			.SHOW_DEBUG(0),
			.INIT_CODE(0),
			.QUEUE_NAME("Load/Store Queue"))
	LSQ (
			.clk(CLK),
			.reset(RESET),
			.pushReq_IN(wLSQ_pushReq),
			.data_IN(wLSQ_tailData),
			.fullFlag_OUT(wLSQ_full),
			
			.popReq_IN(wLSQ_popReq),
			.data_OUT(wLSQ_headData),
			.emptyFlag_OUT(wLSQ_empty),
			.flush_IN(0));
		

//==============================================================================
// BusyBits/IQ/LSQ operations
//==============================================================================
	wire [5:0] wbusy_temp;
	always @(posedge CLK) begin
	
		if (!RESET) begin
		
			IQcount = 0;
			
		end else if (!FREEZE) begin
		
		wIQselected <= (wIQrdy && (!rPr || (rPr && !wLSQrdy)));
		wLSQselected <= (wLSQrdy && (rPr || (!rPr && !wIQrdy)));
		
			// -----------------------------
			// IQ: UPDATE READY FLAG(s) ACC TO BUSY_BITS
			// -----------------------------
			for (pos = 0; pos < IQcount; pos = pos + 1) begin
		
				
				
				// is srcReg1 ready? Update
				IQ[pos][082] = IQ[pos][082] || !busy_bits[IQ[pos][081:076]];
				
				// is srcReg2 ready? Update
				IQ[pos][089] = IQ[pos][089] || !busy_bits[IQ[pos][088:083]];
				
				// Overall ready bit
				IQ[pos][104] = IQ[pos][104] || (IQ[pos][082] && IQ[pos][089]);
			end
			
			// -----------------------------
			// IQ: POP
			// -----------------------------
			if (wIQselected) begin
				
				// Guaranteed to find an instruction that has woken up
				
				// Loop until we find the correct instruction
				for(pos = 0; (!grant_bus[pos]) && (pos < IQcount); pos = pos + 1);

				// pop that data
				//$display("pos: %x IQ[pos]: %x", pos, IQ[pos]);
				//for(pos = 0; pos < 16; pos = pos+1) begin
				//	$display("IQ[%d]: %x", pos, IQ[pos]);
				//end
				//	$display("tits");
				wIQ_popData = IQ[pos-1];
				//$display("IQ[pos]: %x, wIQ_popData: %x", IQ[pos-1], wIQ_popData);

				// compress the queue
				for(counter = pos; counter < IQcount - 1; counter = counter + 1) begin
					IQ[counter] = IQ[counter + 1];
				end
				
				// Update busy bits
				//Did it NEED a dest reg?
				if (IQ[pos][96]) begin
					wbusy_temp = IQ[pos[3:0]][095:090];
					busy_bits[wbusy_temp] = 0; // Clear dest busy bit
				end
				
				// update counter
				if(IQcount != 0)
				IQcount = IQcount - 1;
			end
			
			// -----------------------------
			// IQ: PUSH
			// -----------------------------
			if (!wIQ_full && IQ_pushReq_IN) begin
				
				IQ[IQcount] = wIQLSQ_pushData;
				
				// Update busy bits
				if (wIQLSQ_pushData[96] /* Did it NEED a dest reg? */)
					busy_bits[wIQLSQ_pushData[095:090]] = 1; // Clear dest busy bit
				
				// update counter
				IQcount = IQcount + 1;
			end
		
	
	// -----------------------------------------------------------------------
			
			// -----------------------------
			// LSQ pop
			// -----------------------------
			if (wLSQselected) begin
			
				// We are ready to pop. Should we?
				wLSQ_popReq <= 1;			
				
				// Modify src ready bit and go ahead
				wLSQ_popData <= {wLSQ_headData[IQLSQ_WIDTH-1:83], 1'b1, wLSQ_headData[81:0]};
				
				if (wLSQ_headData[96] /* Did it NEED a dest reg? */)
					busy_bits[wLSQ_headData[095:090]] = 0; // Clear dest busy bit
					
			end else begin
				wLSQ_popReq <= 0;
			end
			
			// -----------------------------
			// LSQ push
			// -----------------------------
			if (!wLSQ_full && LSQ_pushReq_IN) begin
				wLSQ_pushReq <= LSQ_pushReq_IN;
				wLSQ_tailData <= wIQLSQ_pushData;
				
				if (wNeedDestReg)
					busy_bits[wIQLSQ_pushData[095:090]] = 1; // Set dest busy bit
					
			end else begin		
				wLSQ_pushReq <= 0;
			end
			
			
		end
	end
	
parameter comment = 0;
integer idx;
integer shortIdx;

	always begin
	if (comment)
	begin
		$display("----------------IQ------------------");
//		if (flush_IN) $display("\n----------------FLUSH!!!!!!-----------------\n");
		$display("Count: %d %s%s"/* %s"*/, IQcount, (wIQ_empty)?"EMPTY!":" ", (wIQ_full)?"FULL!":" ");//, (doBypassBuf)?"<---BYPASS!":" ");
		$display("Push: %s(%x) Pop: %s(%x)", (IQ_pushReq_IN)?"Y":"N", wIQLSQ_pushData, (wIQselected)?"Y":"N", IQLSQ_popData_OUT);//, (validPush&&validPop)?"<---PUSHPOP":"       ");
		$display("wIQselected = %d = (%d && (!%d || (%d && !%d)));", wIQselected, wIQrdy, rPr, rPr, wLSQrdy);
		$display("!wIQ_empty:!%d && instruction_ready:%d PE_Request:%x, request_bus:%x, wIQ_popData:%x", wIQ_empty, instruction_ready, PE_Request, request_bus, wIQ_popData);
		$display("POS:%x", pos);
		
		/*$display("curTail:     %x, ", curTail_OUT);
		$display("ProbeIdxIN:  %x, ProbeDataOUT: %x", probeIdx_IN, probeData_OUT);
		$display("ProbePushIN: %x, ProbeDataIN:  %x", probePushReq_IN, probeData_IN);*/
		
		
		for (idx = 0; idx <= 15; idx = idx + 1)
		begin
			shortIdx = idx;
			
			if (shortIdx == IQcount && shortIdx== 0)
				$display ("BUF[%d]: %x %s", idx, IQ[idx], 		"<--HEAD <--TAIL");
			else begin
				if (shortIdx == 0)
					$display ("BUF[%d]: %x %s", idx, IQ[idx], 	"<--HEAD");
				
				if (shortIdx == IQcount)
					$display ("BUF[%d]: %x %s", idx, IQ[idx], 	"        <--TAIL");
			end

			if (shortIdx != IQcount && shortIdx!= 0)
				$display ("BUF[%d]: %x %s", idx, IQ[idx], "");		
		end
	
	end // if (SHOW_DEBUG)
end
		
endmodule
	

	
