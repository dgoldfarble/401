//-----------------------------------------
//           Data Memory Stage
//-----------------------------------------
module MEM (	FREEZE, CLK, RESET,
				result,
				data_write_2DM, 
				data_address_2DM,
				Instr_OUT,
				Data1_2ID,
				writeRegister1_PR,
				do_writeback1_PR,
				MemRead_2DM,
				MemWrite_2DM,
				taken_branch1_OUT,
				target_PC_OUT,
				Mem_Hazard_OUT,
				ROBPointer_OUT,
				
				ROBPointer_IN,
				Mem_Hazard_IN,
				target_PC_IN,
				aluResult1,
				address,
				data_read_fDM,
				Dest_Value1,
				readDataB1,
				Instr1,
				ALU_control1,
				writeRegister1,
				do_writeback1,
				MemRead1,
				MemWrite1,
				taken_branch1_IN,
				
				Valid_Instruction_IN,
				Valid_Instruction_OUT,
				Mem_Instruction_IN
			);

   output reg    [31: 0] result;
   output reg    [31: 0] data_write_2DM; 
   output reg    [31: 0] data_address_2DM;
   output reg    [31: 0] Instr_OUT;
   output reg    [31: 0] Data1_2ID;
   output reg    [ 5: 0] writeRegister1_PR;
   output reg            do_writeback1_PR;
   output reg	         MemRead_2DM;
   output reg            MemWrite_2DM;
   output reg            taken_branch1_OUT;
   output reg    [31: 0] target_PC_OUT;
   output reg            Mem_Hazard_OUT;
   output reg    [ 5: 0] ROBPointer_OUT;
				
   input         [ 5: 0] ROBPointer_IN;
   input                 Mem_Hazard_IN;
   input         [31: 0] target_PC_IN;
   input         [31: 0] aluResult1;
   input         [31: 0] address;
   input         [31: 0] data_read_fDM;
   input         [31: 0] Dest_Value1;
   input         [31: 0] readDataB1;
   input         [31: 0] Instr1;
   input         [ 5: 0] ALU_control1;
//  input         [ 4: 0] writeRegister1_WB;
   input         [ 5: 0] writeRegister1;
//   input                 do_writeback1_WB;
   input                 do_writeback1;
   input                 CLK;
   input                 RESET;
   input                 MemRead1;
   input                 MemWrite1;
   input                 FREEZE;
   input                 taken_branch1_IN;
   input                 Mem_Instruction_IN;
   
   input 					Valid_Instruction_IN;
   output reg 				Valid_Instruction_OUT;
   

   wire         [31: 0] data_read_aligned;
   wire         [31: 0] Dest_Value;
   wire         [31: 0] aluResult;
   wire         [31: 0] readDataB;
   wire         [31: 0] writeData_WB;
   wire         [31: 0] Instr;
   wire         [ 5: 0] ALU_control;
   wire                 MemRead;
   wire                 MemWrite;
   wire                 select1_WB;

   reg                  comment;

   initial comment = 0;  //show MEM displays

   assign Instr_OUT = Instr1;
   assign MemRead_2DM = MemRead1;
   assign MemWrite_2DM = MemWrite1;
//   assign select1_WB = (do_writeback1_WB&&(writeRegister1_WB==writeRegister1));
   assign data_write_2DM = Dest_Value1; // (select1_WB)?result:Dest_Value1;
   assign data_address_2DM = address;
   
   assign Data1_2ID = (MemRead_2DM)?data_read_aligned:aluResult1;


   always
     begin
        data_read_aligned = (select1_WB)?result:Dest_Value1;
	ALU_control = ALU_control1;
	aluResult = aluResult1;
	
	       case(ALU_control)
        		6'b101101: begin //LWX
                        	case( aluResult[1:0] )
                       	   		0:  data_read_aligned = data_read_fDM;
                      	        	1:  data_read_aligned[31:8] = data_read_fDM[23:0];
                       	        	2:  data_read_aligned[31:16] = data_read_fDM[15:0];
                       	        	3:  data_read_aligned[31:24] = data_read_fDM[7:0];
               		        endcase
                        end
                	6'b101110: begin //LWX
                    		case( aluResult[1:0] )
                     		   	0:  data_read_aligned[7:0] = data_read_fDM[31:24];
                        		1:  data_read_aligned[15:0] = data_read_fDM[31:16];
                        		2:  data_read_aligned[23:0] = data_read_fDM[31:8];
                       		 	3:  data_read_aligned = data_read_fDM;
                    		endcase
                	end
                	6'b100001: begin //LB
		    		case( aluResult[1:0] )
		  			3: data_read_aligned={{24{data_read_fDM[7]}},data_read_fDM[7:0]};
					2: data_read_aligned={{24{data_read_fDM[15]}},data_read_fDM[15:8]};
					1: data_read_aligned={{24{data_read_fDM[23]}},data_read_fDM[23:16]};
					0: data_read_aligned={{24{data_read_fDM[31]}},data_read_fDM[31:24]};
					default: begin end
		    		endcase
      	         	end
         	        6'b101011: begin //LH
		    		case( aluResult[1:0] )
					0:data_read_aligned={{16{data_read_fDM[15]}},data_read_fDM[15:0]};
					2:data_read_aligned={{16{data_read_fDM[31]}},data_read_fDM[31:16]};
					default: begin end
		    		endcase
                	end
                	6'b101010: begin //LBU
                    		case( aluResult[1:0] )
					0: data_read_aligned={24'b0,data_read_fDM[31:24]};
					1: data_read_aligned={24'b0,data_read_fDM[23:16]};
					2: data_read_aligned={24'b0,data_read_fDM[15:8]};
					3: data_read_aligned={24'b0,data_read_fDM[7:0]};
					default: begin end 
		    		endcase
                	end
                	6'b101100: begin //LHU
		    		case(aluResult%4)
					0:data_read_aligned={16'b0,data_read_fDM[15:0]};
	            			2:data_read_aligned={16'b0,data_read_fDM[31:16]};
					default: begin end
		    		endcase
                	end
                        default: data_read_aligned = data_read_fDM;  
		endcase
     end


    // Pipeline Register 1 (MEM/WB)
   always @ (posedge CLK or posedge RESET)
     begin
       if(RESET == 1'b0)
         begin
			writeRegister1_PR <= 6'b0;
			result <= 32'b0;
			do_writeback1_PR <= 1'b0;
			taken_branch1_OUT <= 1'b0;
			target_PC_OUT <= 32'b0;
			Mem_Hazard_OUT <= 1'b0;
			ROBPointer_OUT <= 6'b0;
			Valid_Instruction_OUT <= 1'b0;
         end
       else if(!FREEZE)
         begin
           writeRegister1_PR <= writeRegister1;
           result <= Mem_Instruction_IN? data_read_aligned : aluResult1;
           do_writeback1_PR <= do_writeback1;
			taken_branch1_OUT <= taken_branch1_IN;
			target_PC_OUT <= target_PC_IN;
			Mem_Hazard_OUT <= Mem_Hazard_IN;
			ROBPointer_OUT <= ROBPointer_IN;
			Valid_Instruction_OUT <= Valid_Instruction_IN;
         end
     end

     always @ (posedge CLK) begin
/*         if (comment) begin 
		$display("=============================================================");
		$display("[MEM]:Write Register 1:%d\t\t|Write Register 2:%x",writeRegister1,writeRegister2);
		$display("=============================================================");
		$display("[WB]:Write Register 1:%d\t\t|Write Register 2:%x",writeRegister1_PR,writeRegister2_PR);	
		$display("[MEM]:MemRead_2DM:%x",MemRead_2DM);
		$display("[MEM]:MemWrite_2DM:%x",MemWrite_2DM);
		$display("[MEM]:data_address_2DM:%x",data_address_2DM);
		$display("[MEM]:data_write_2DM:%x",data_write_2DM);
		$display("[MEM]:data_read_fDM:%x",data_read_fDM);
		$display("[MEM]:Data1_2ID:%x/t/tData2_2ID:%x",Data1_2ID,Data2_2ID);
		$display("[MEM]:aluResult1:%x\t|aluResult2:%x",aluResult1,aluResult2);
                $display("[MEM]:do_writeback1:%x\t\t|do_writeback2:%x",do_writeback1,do_writeback2);
		$display("[MEM]:data_read1_PR:%x\t|data_read2_PR:%x",data_read1_PR,data_read2_PR);
		$display("[MEM]:result:%x\t|aluResult2_PR:%x",result,aluResult2_PR);
		$display("[MEM]:MemWrite1:%x\t\t|MemWrite2:%x",MemWrite1,MemWrite2);
		$display("[MEM]:MemRead1:%x\t\t|MemRead2:%x",MemRead1,MemRead2);
                $display("[MEM]:do_writeback1_PR:%x\t|do_writeback2_PR:%x",do_writeback1_PR,do_writeback2_PR);
		/**/
     end
endmodule

