//-----------------------------------------
//           Write Back Stage
//-----------------------------------------
module WB (	CLK,
		RESET,
		FREEZE,
                do_writeback1_PR,
		writeRegister1_PR,
		writeData1_PR,
		do_writeback1,
		aluResult1_OUT,
		writeRegister1,
		writeRegister1_OUT,
		writeData1_OUT,
		do_writeback1_OUT,
		aluResult1,
		Data_input1,
		MemtoReg1
		);

   output reg      [31: 0] writeData1_OUT;
   output reg      [31: 0] aluResult1_OUT;
   output reg      [31: 0] writeData1_PR;
   output reg      [ 4: 0] writeRegister1_PR;
   output reg      [ 4: 0] writeRegister1_OUT;
   output reg              do_writeback1_OUT;
   output reg              do_writeback1_PR;
     
   input           [31: 0] aluResult1;
   input           [31: 0] Data_input1;
   input           [ 4: 0] writeRegister1;
   input   	           MemtoReg1;
   input  	           CLK;
   input   	           RESET;
   input            	   do_writeback1;     
   input		   FREEZE;

   wire                    do_writeback1;     
   
   reg                     comment;

   initial comment = 0; //show WB displays

   assign writeRegister1_OUT = writeRegister1; 
   assign do_writeback1_OUT = do_writeback1;
   assign aluResult1_OUT = aluResult1;
   assign writeData1_OUT = (MemtoReg1)?Data_input1:aluResult1;

  //Pipe Register 1

   always @ (posedge CLK or negedge RESET) begin
       if(!RESET) begin
             writeData1_PR <= 32'b0;
	     writeRegister1_PR <= 5'b0;
             do_writeback1_PR <= 1'b0;
       end
       else if(!FREEZE)
	begin
             writeData1_PR <= writeData1_OUT;
	     writeRegister1_PR <= writeRegister1;
             do_writeback1_PR <= do_writeback1;
       end
    end

    always begin
       if (comment) begin
		$display("=============================================================");
/*		$display ("[WB]:\t\tData_input1:%x",Data_input1);
		$display ("[WB]:writeData1_PR:%x\t|writeData2_PR:%x",writeData1_PR,writeData2_PR);
		$display ("[WB]:MemtoReg1:%x\t\t|MemtoReg2:%x",MemtoReg1,MemtoReg2);
		$display ("[WB]:aluResult1:%x\t|aluResult2:%x",aluResult1,aluResult2);
		$display ("[WB]:writeRegister1_PR:%x\t|writeRegister2_PR:%x",writeRegister1_PR,writeRegister2_PR);
		$display ("[WB]:do_writeback1_PR:%x\t\t|do_writeback2_PR:%x",do_writeback1_PR,do_writeback2_PR);
		$display ("[WB]:do_writeback1_OUT:%x\t|do_writeback2_OUT:%x",do_writeback1_OUT,do_writeback2_OUT);
		$display ("[WB]:writeRegister1_OUT:%x\t|writeRegister2_OUT:%x",writeRegister1_OUT,writeRegister2_OUT);
		$display ("[WB]:writeData1_OUT:%x\t|writeData2_OUT:%x",writeData1_OUT,writeData2_OUT);
		/**/ 
      end
    end   



endmodule
