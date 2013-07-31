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
   wire           single_fetch_IDIF/*verilator public*/;

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
   wire [31: 0]   Instr1_IDEXE/*verilator public*/;
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
   wire           single_fetch_iCache;

   wire [  1: 0]  MVECT/*verilator public*/;
   wire [  1: 0]  DataWriteMode;
   wire [ 31: 0]  data_read_fDC;
   wire           IMISS;
   wire           DMISS;
   wire           do_fetch;

   assign do_fetch = ~no_fetch;
   assign FREEZE = DMISS | IMISS;
   assign DataWriteMode = (Instr_fMEM[31: 26]==40)? 2'b01: ((Instr_fMEM[31: 26]==41)? 2'b10: 2'b00);
   assign single_fetch_iCache = single_fetch_IDIF;


  iCache iCache1 (CLK, RESET, SYS, do_fetch, iBlkRead, iBlkWrite, Instr_address_2IM, block_read_fIM, block_write_2IM, Instr1_fIC, Instr2_fIC, IMISS, MVECT);

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

   // Pipeline Stages Instantiation
   IF IF1( CLK,
        RESET,
        FREEZE,
        fetchNull2_fID,
        PCA_IFID,
        CIA_IFID,
        no_fetch,
        /*single_fetch_IDIF*/single_fetch_iCache,
        taken_branch1_IDIF,
        nextInstruction_address_IDIF,
        PC_init,
        /*Instr1_fIM*/Instr1_fIC,
        Instr1_IFID,
        Instr2_IFID,
        Instr_address_2IM
    );

   ID ID1( CLK,
        RESET,
        FREEZE,
        ALUSrc1_IDEXE,
        fetchNull2_fID,
        single_fetch_IDIF,
        Instr1_IDEXE,
        Dest_Value1_IDEXE,
        no_fetch,
        SYS,
        readDataB1_IDEXE,
        Instr1_10_6_IDEXE,
        do_writeback1_EXEM,
        writeRegister1_EXEM,
        writeData1_MID,
        do_writeback1_WBID,
        writeRegister1_WBID,
        writeData1_WBID,
        aluResult1_EXEID,
        do_writeback1_IDEXE,
        readRegisterA1_IDEXE,
        readRegisterB1_IDEXE,
        taken_branch1_IDIF,
        aluResult1_WBID,
        writeRegister1_IDEXE,
        nextInstruction_address_IDIF,
        Reg_ID,
        R2_output_ID,
        Operand_A1_IDEXE,
        Operand_B1_IDEXE,
        ALU_control1_IDEXE,
        MemRead1_IDEXE,
        MemWrite1_IDEXE,
        MemtoReg1_IDEXE,
        Instr1_IFID,
        PCA_IFID,
        writeData1_WBID,
        R2_input,
        CIA_IFID
    );

   EXE EXE1( CLK,
        RESET,
        FREEZE,
        ALUSrc1_EXEM,
        ALUSrc1_IDEXE,
        Instr1_IDEXE,
        Instr1_EXEM,
        Dest_Value1_IDEXE,
        Dest_Value1_EXEM,
        readDataB1_IDEXE,
        readDataB1_EXEM,
        aluResult1_EXEID,
        do_writeback1_WBEXE,
        writeRegister1_WBEXE,
        writeData1_WBEXE,
        ALU_control1_EXEM,
        ALU_control1_IDEXE,
        writeData1_WBID,
        writeRegister1_MEMW,
        do_writeback1_MEMW,
        do_writeback1_EXEM,
        do_writeback1_IDEXE,
        /**/readRegisterA1_IDEXE,
        readRegisterB1_IDEXE,
        /**/writeRegister1_IDEXE,
        writeRegister1_EXEM,
        Instr1_10_6_IDEXE,
        MemRead1_IDEXE,
        MemWrite1_IDEXE,
        MemRead1_EXEM,
        MemWrite1_EXEM,
        Operand_A1_IDEXE,
        Operand_B1_IDEXE,
        MemtoReg1_IDEXE,
        MemtoReg1_EXEM,
        aluResult1_EXEM
    );

   MEM MEM1( CLK,
        RESET,
        FREEZE,
        ALUSrc1_EXEM,
        Instr1_EXEM,
        Instr_fMEM,
        writeData1_WBID,
        writeRegister1_WBID,
        do_writeback1_WBID,
        Dest_Value1_EXEM,
        readDataB1_EXEM,
        /**/writeData1_MID,
        /**/ do_writeback1_MEMW,
        do_writeback1_EXEM,
        writeRegister1_EXEM,
        writeRegister1_MEMW,
        /**/data_write_2DM,
        data_address_2DM,
        MemRead,
        MemWrite,
        /*data_read_fDM*/data_read_fDC,
        MemtoReg1_EXEM,
        MemtoReg1_MEMW,
        MemRead1_EXEM,
        MemWrite1_EXEM,
        ALU_control1_EXEM,
        aluResult1_EXEM,
        aluResult1_MEMW,
        data_read1_MEMW
    );

   WB WriteBack ( CLK,
        RESET,
        FREEZE,
        do_writeback1_WBEXE,
        writeRegister1_WBEXE,
        writeData1_WBEXE,
        do_writeback1_MEMW,
        aluResult1_WBID,
        writeRegister1_MEMW,
        writeRegister1_WBID,
        writeData1_WBID,
        do_writeback1_WBID,
        aluResult1_MEMW,
        data_read1_MEMW,
        MemtoReg1_MEMW
    );

endmodule
