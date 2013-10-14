// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "VMIPS__Syms.h"
#include "VMIPS.h"
#include "VMIPS_MIPS.h"

// FUNCTIONS
VMIPS__Syms::VMIPS__Syms(VMIPS* topp, const char* namep)
	// Setup locals
	: __Vm_namep(namep)
	, __Vm_activity(false)
	, __Vm_didInit(false)
	// Setup submodule names
	, TOP__v                         (Verilated::catName(topp->name(),"v"))
{
    // Pointer to top level
    TOPp = topp;
    // Setup each module's pointers to their submodules
    TOPp->v                         = &TOP__v;
    // Setup each module's pointer back to symbol table (for public functions)
    TOPp->__Vconfigure(this, true);
    TOP__v.__Vconfigure(this, true);
    // Setup scope names
    __Vscope_v.configure(this,name(),"v");
    // Setup export functions
    for (int __Vfinal=0; __Vfinal<2; __Vfinal++) {
	__Vscope_v.varInsert(__Vfinal,"ALUSrc1_EXEM", &(TOP__v.ALUSrc1_EXEM), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"ALUSrc1_IDEXE", &(TOP__v.ALUSrc1_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"ALUSrc2_EXEM", &(TOP__v.ALUSrc2_EXEM), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"ALUSrc2_IDEXE", &(TOP__v.ALUSrc2_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"ALU_control1_EXEM", &(TOP__v.ALU_control1_EXEM), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,5,0);
	__Vscope_v.varInsert(__Vfinal,"ALU_control1_IDEXE", &(TOP__v.ALU_control1_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,5,0);
	__Vscope_v.varInsert(__Vfinal,"ALU_control2_EXEM", &(TOP__v.ALU_control2_EXEM), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,5,0);
	__Vscope_v.varInsert(__Vfinal,"ALU_control2_IDEXE", &(TOP__v.ALU_control2_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,5,0);
	__Vscope_v.varInsert(__Vfinal,"CIA_IFID", &(TOP__v.CIA_IFID), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Dest_Value1_EXEM", &(TOP__v.Dest_Value1_EXEM), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Dest_Value1_IDEXE", &(TOP__v.Dest_Value1_IDEXE), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Dest_Value2_EXEM", &(TOP__v.Dest_Value2_EXEM), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Dest_Value2_IDEXE", &(TOP__v.Dest_Value2_IDEXE), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"FREEZE", &(TOP__v.FREEZE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"Instr1_10_6_IDEXE", &(TOP__v.Instr1_10_6_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"Instr1_EXEM", &(TOP__v.Instr1_EXEM), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Instr1_IDEXE", &(TOP__v.Instr1_IDEXE), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Instr1_IFID", &(TOP__v.Instr1_IFID), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Instr1_fIC", &(TOP__v.Instr1_fIC), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Instr2_10_6_IDEXE", &(TOP__v.Instr2_10_6_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"Instr2_EXEM", &(TOP__v.Instr2_EXEM), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Instr2_IDEXE", &(TOP__v.Instr2_IDEXE), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Instr2_IFID", &(TOP__v.Instr2_IFID), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Instr2_fIC", &(TOP__v.Instr2_fIC), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Instr_address_2IM", &(TOP__v.Instr_address_2IM), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Instr_fMEM", &(TOP__v.Instr_fMEM), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"MVECT", &(TOP__v.MVECT), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
	__Vscope_v.varInsert(__Vfinal,"MemRead1_EXEM", &(TOP__v.MemRead1_EXEM), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"MemRead1_IDEXE", &(TOP__v.MemRead1_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"MemRead2_EXEM", &(TOP__v.MemRead2_EXEM), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"MemRead2_IDEXE", &(TOP__v.MemRead2_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"MemWrite1_EXEM", &(TOP__v.MemWrite1_EXEM), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"MemWrite1_IDEXE", &(TOP__v.MemWrite1_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"MemWrite2_EXEM", &(TOP__v.MemWrite2_EXEM), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"MemWrite2_IDEXE", &(TOP__v.MemWrite2_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"MemtoReg1_EXEM", &(TOP__v.MemtoReg1_EXEM), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"MemtoReg1_IDEXE", &(TOP__v.MemtoReg1_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"MemtoReg1_MEMW", &(TOP__v.MemtoReg1_MEMW), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"MemtoReg2_EXEM", &(TOP__v.MemtoReg2_EXEM), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"MemtoReg2_IDEXE", &(TOP__v.MemtoReg2_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"MemtoReg2_MEMW", &(TOP__v.MemtoReg2_MEMW), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"Operand_A1_IDEXE", &(TOP__v.Operand_A1_IDEXE), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Operand_A2_IDEXE", &(TOP__v.Operand_A2_IDEXE), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Operand_B1_IDEXE", &(TOP__v.Operand_B1_IDEXE), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Operand_B2_IDEXE", &(TOP__v.Operand_B2_IDEXE), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"PCA_IFID", &(TOP__v.PCA_IFID), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"R2_output_ID", &(TOP__v.R2_output_ID), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"Reg_ID", &(TOP__v.Reg_ID), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,2 ,31,0 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"SYS", &(TOP__v.SYS), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"aluResult1_EXEID", &(TOP__v.aluResult1_EXEID), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"aluResult1_EXEM", &(TOP__v.aluResult1_EXEM), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"aluResult1_MEMW", &(TOP__v.aluResult1_MEMW), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"aluResult1_WBID", &(TOP__v.aluResult1_WBID), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"aluResult2_EXEID", &(TOP__v.aluResult2_EXEID), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"aluResult2_EXEM", &(TOP__v.aluResult2_EXEM), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"aluResult2_MEMW", &(TOP__v.aluResult2_MEMW), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"aluResult2_WBID", &(TOP__v.aluResult2_WBID), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"data_read1_MEMW", &(TOP__v.data_read1_MEMW), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"data_read2_MEMW", &(TOP__v.data_read2_MEMW), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"do_writeback1_EXEM", &(TOP__v.do_writeback1_EXEM), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"do_writeback1_IDEXE", &(TOP__v.do_writeback1_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"do_writeback1_MEMW", &(TOP__v.do_writeback1_MEMW), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"do_writeback1_WBEXE", &(TOP__v.do_writeback1_WBEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"do_writeback1_WBID", &(TOP__v.do_writeback1_WBID), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"do_writeback2_EXEM", &(TOP__v.do_writeback2_EXEM), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"do_writeback2_IDEXE", &(TOP__v.do_writeback2_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"do_writeback2_MEMW", &(TOP__v.do_writeback2_MEMW), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"do_writeback2_WBEXE", &(TOP__v.do_writeback2_WBEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"do_writeback2_WBID", &(TOP__v.do_writeback2_WBID), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"fetchNull1_fID", &(TOP__v.fetchNull1_fID), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"fetchNull2_fID", &(TOP__v.fetchNull2_fID), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"nextInstruction_address_IDIF", &(TOP__v.nextInstruction_address_IDIF), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"no_fetch", &(TOP__v.no_fetch), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"readDataB1_EXEM", &(TOP__v.readDataB1_EXEM), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"readDataB1_IDEXE", &(TOP__v.readDataB1_IDEXE), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"readDataB2_EXEM", &(TOP__v.readDataB2_EXEM), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"readDataB2_IDEXE", &(TOP__v.readDataB2_IDEXE), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"readRegisterA1_IDEXE", &(TOP__v.readRegisterA1_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"readRegisterA2_IDEXE", &(TOP__v.readRegisterA2_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"readRegisterB1_IDEXE", &(TOP__v.readRegisterB1_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"readRegisterB2_IDEXE", &(TOP__v.readRegisterB2_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"single_fetch_IDIF", &(TOP__v.single_fetch_IDIF), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"taken_branch1_IDIF", &(TOP__v.taken_branch1_IDIF), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"taken_branch2_IDIF", &(TOP__v.taken_branch2_IDIF), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
	__Vscope_v.varInsert(__Vfinal,"writeData1_MID", &(TOP__v.writeData1_MID), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"writeData1_WBEXE", &(TOP__v.writeData1_WBEXE), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"writeData1_WBID", &(TOP__v.writeData1_WBID), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"writeData2_MID", &(TOP__v.writeData2_MID), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"writeData2_WBEXE", &(TOP__v.writeData2_WBEXE), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"writeData2_WBID", &(TOP__v.writeData2_WBID), VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
	__Vscope_v.varInsert(__Vfinal,"writeRegister1_EXEM", &(TOP__v.writeRegister1_EXEM), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"writeRegister1_IDEXE", &(TOP__v.writeRegister1_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"writeRegister1_MEMW", &(TOP__v.writeRegister1_MEMW), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"writeRegister1_WBEXE", &(TOP__v.writeRegister1_WBEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"writeRegister1_WBID", &(TOP__v.writeRegister1_WBID), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"writeRegister2_EXEM", &(TOP__v.writeRegister2_EXEM), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"writeRegister2_IDEXE", &(TOP__v.writeRegister2_IDEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"writeRegister2_MEMW", &(TOP__v.writeRegister2_MEMW), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"writeRegister2_WBEXE", &(TOP__v.writeRegister2_WBEXE), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
	__Vscope_v.varInsert(__Vfinal,"writeRegister2_WBID", &(TOP__v.writeRegister2_WBID), VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
    }
}
