/*
CIRCULAR FIFO Implementation - Akshay Rao

RULES:
	Producer:
		Check whether queue is full before pushing.
		The pushReq flag must go high AFTER valid data has been put at the 
		input of the queue. Otherwise invalid data might get written to it.
		
	Consumer:
		Check whether queue is empty before popping. Otherwise, popped value MAY be invalid.
		Gets the value instantaneously.
		
	Probe:
		curTail_OUT 	- Current value of the tail ptr
		probeIdx_IN	- Index that is to be read/written from/to
		probeData_OUT	- Data read out from buffer[probeIdx_IN]
		probePusheq_IN	- Push enable for probeData_IN to be written to buffer[probeIdx_IN]
		probeData_IN	- Data written to buffer[probeIdx_IN] when probePusheq_IN is high
	
Internal:
PUSH: Buffer is written at the next clock edge.
POP : Buffer is read from in the same cycle. (continuous assignment)
*/

module queue (			clk,
				reset,
				pushReq_IN,		// Push	requested
				data_IN,		// Pushed data
				popReq_IN,		// Pop requested
				data_OUT,		// Popped data. Check popValid_OUT also
				emptyFlag_OUT,	// high when buffer is empty
				fullFlag_OUT,	// High when buffer is full
				flush_IN,
				
				// Current tail pointer
				curTail_OUT,
				curHead_OUT,
				
				// Probe stuff
				probeIdx_IN,		// Index you want to read/write to
				probeData_OUT,		// Data at that index
				probePushReq_IN,	// Write enable for the probe data
				probeData_IN);		// Probe data input
	

// SUPPLY DURING INSTANTIATION:
	parameter	DATA_WIDTH 	= 8; 	// in bits
	parameter	ADDR_WIDTH 	= 4;	// in bits
	parameter 	SHOW_DEBUG 	= 1; 	// True/False. Show debugging comments or not
	parameter	INIT_CODE	= 0;	// 0: init with 0. 1: init with 0 to MAX_BUF
	parameter	QUEUE_NAME	= "Q";	// Name of queue. Useful in debugging


/////////////////////////////////////////////////////////////////////////////////
input 						clk;
input						reset;
input						pushReq_IN;
input						popReq_IN;
input 	[DATA_WIDTH-1:0]	data_IN;
input 						flush_IN;

input 	[DATA_WIDTH-1:0]	probeData_IN;
input	[ADDR_WIDTH-1:0]	probeIdx_IN;
input						probePushReq_IN;

output 						emptyFlag_OUT;
output 						fullFlag_OUT;
output 	[DATA_WIDTH-1:0]	data_OUT;
output 	[DATA_WIDTH-1:0]	probeData_OUT;
output	[ADDR_WIDTH-1:0]	curTail_OUT, curHead_OUT;

`define MAX_BUF (1<<ADDR_WIDTH)	// Max no of elements in buf

reg	[DATA_WIDTH-1:0]	buffer [`MAX_BUF-1:0];
reg	[ADDR_WIDTH-1:0]	head;
reg [ADDR_WIDTH-1:0]	tail;
reg [ADDR_WIDTH :0]		count;

reg [DATA_WIDTH-1:0] rData2Buf;

wire validPush, validPop;
////////////////////////////////////////////////////////////

assign 	emptyFlag_OUT 	= (count == 0);// && doBypassBuf == 0);
assign 	fullFlag_OUT	= (count == `MAX_BUF);
assign 	rData2Buf 		= data_IN;
assign	validPush		= (!fullFlag_OUT && pushReq_IN);
assign	validPop		= (!emptyFlag_OUT && popReq_IN);

integer genctr;
reg [DATA_WIDTH-1:0] genval;
initial begin
	genval = 0;
	for (genctr = 0; genctr < `MAX_BUF; genctr = genctr + 1) begin
		buffer[genctr] = (INIT_CODE==1)?genval:((INIT_CODE==0)?0:0);
		genval = genval + 1;
	end
	
	if (INIT_CODE == 1) begin
		count = `MAX_BUF;
	end
end


// Update buffer counter
always @(posedge clk) begin

	if (!reset || flush_IN)
		count		<= 0;
	else begin
		if (validPush && !validPop)
			count <= count + 1;
			
		if (validPop && !validPush)
			count <= count - 1;
	end
end

// Get some tail or a head
assign curTail_OUT = tail;
assign curHead_OUT = head;
always @(posedge clk) begin
	if (!reset || flush_IN) begin
		tail 		<= 0;
		head 		<= 0;
	end else begin
		if (validPush)
			tail <= tail + 1;

		if (validPop)
			head <= head + 1;	
	end
end

// Do push
 always @(posedge clk) begin
	if (!reset)
		buffer[tail] <= 0;
	else begin		
		if (validPush)
			buffer[tail] <= rData2Buf;
			
		if (probePushReq_IN)
			buffer[probeIdx_IN] <= probeData_IN;
	end
 end

// Do pop
assign data_OUT = buffer[head];

// Probe stuff
assign probeData_OUT = buffer [probeIdx_IN];
////////////// DEBUG STUFF////////////////////////////////////////////////

integer	idx;
reg [ADDR_WIDTH-1:0]	shortIdx;

always /*@(posedge clk) */begin
	if (SHOW_DEBUG)
	begin
		$display("----------------Q: %s------------------",QUEUE_NAME);
		// $display("INITCODE:%x",INIT_CODE);
		if (flush_IN) $display("\n----------------FLUSH!!!!!!-----------------\n");
		$display("Count: %d %s%s"/* %s"*/, count, (emptyFlag_OUT)?"EMPTY!":" ", (fullFlag_OUT)?"FULL!":" ");//, (doBypassBuf)?"<---BYPASS!":" ");
		$display("Push: %s(%x) Pop: %s(%x) %s", (pushReq_IN)?"Y":"N", data_IN, (popReq_IN)?"Y":"N", data_OUT, (validPush&&validPop)?"<---PUSHPOP":"       ");
		
		
		$display("curTail:     %x, ", curTail_OUT);
		$display("ProbeIdxIN:  %x, ProbeDataOUT: %x", probeIdx_IN, probeData_OUT);
		$display("ProbePushIN: %x, ProbeDataIN:  %x", probePushReq_IN, probeData_IN);
		
		
		for (idx = 0; idx < `MAX_BUF; idx = idx + 1)
		begin
			shortIdx = idx[ADDR_WIDTH-1:0];
			
			if (shortIdx == tail && shortIdx== head)
				$display ("BUF[%d]: %x %s", idx, buffer[idx], 		"<--HEAD <--TAIL");
			else begin
				if (shortIdx == head)
					$display ("BUF[%d]: %x %s", idx, buffer[idx], 	"<--HEAD");
				
				if (shortIdx == tail)
					$display ("BUF[%d]: %x %s", idx, buffer[idx], 	"        <--TAIL");
			end

			if (shortIdx != tail && shortIdx!= head)
				$display ("BUF[%d]: %x %s", idx, buffer[idx], "");		
		end
	
	end // if (SHOW_DEBUG)
end

endmodule
