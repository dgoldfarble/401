// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See VMIPS.h for the primary calling header

#ifndef _VMIPS_MIPS_H_
#define _VMIPS_MIPS_H_

#include "verilated.h"
#include "VMIPS__Inlines.h"
class VMIPS__Syms;

//----------

VL_MODULE(VMIPS_MIPS) {
  public:
    // CELLS
    
    // PORTS
    VL_IN8(CLK,0,0);
    VL_IN8(RESET,0,0);
    VL_OUT8(MemRead,0,0);
    VL_OUT8(MemWrite,0,0);
    VL_OUT8(dBlkRead,0,0);
    VL_OUT8(dBlkWrite,0,0);
    VL_OUT8(iBlkRead,0,0);
    VL_OUT8(iBlkWrite,0,0);
    VL_OUT(R2_output,31,0);
    VL_OUT(data_address_2DM,31,0);
    VL_OUT(data_write_2DM,31,0);
    //char	__VpadToAlign20[4];
    VL_OUTW(block_write_2DM,255,0,8);
    VL_OUTW(block_write_2IM,255,0,8);
    VL_IN(PC_init,31,0);
    VL_IN(R2_input,31,0);
    VL_INW(block_read_fDM,255,0,8);
    VL_INW(block_read_fIM,255,0,8);
    
    // LOCAL SIGNALS
    VL_SIG8(no_fetch,0,0);
    VL_SIG8(SYS,0,0);
    VL_SIG8(single_fetch_IDIF,0,0);
    VL_SIG8(ALU_control1_IDEXE,5,0);
    VL_SIG8(ALU_control2_IDEXE,5,0);
    VL_SIG8(ALU_control1_EXEM,5,0);
    VL_SIG8(ALU_control2_EXEM,5,0);
    VL_SIG8(writeRegister1_IDEXE,4,0);
    VL_SIG8(writeRegister2_IDEXE,4,0);
    VL_SIG8(writeRegister1_EXEM,4,0);
    VL_SIG8(writeRegister2_EXEM,4,0);
    VL_SIG8(writeRegister1_MEMW,4,0);
    VL_SIG8(writeRegister2_MEMW,4,0);
    VL_SIG8(writeRegister1_WBID,4,0);
    VL_SIG8(writeRegister2_WBID,4,0);
    VL_SIG8(writeRegister1_WBEXE,4,0);
    VL_SIG8(writeRegister2_WBEXE,4,0);
    VL_SIG8(Instr1_10_6_IDEXE,4,0);
    VL_SIG8(Instr2_10_6_IDEXE,4,0);
    VL_SIG8(readRegisterA2_IDEXE,4,0);
    VL_SIG8(readRegisterA1_IDEXE,4,0);
    VL_SIG8(readRegisterB1_IDEXE,4,0);
    VL_SIG8(readRegisterB2_IDEXE,4,0);
    VL_SIG8(MemtoReg1_IDEXE,0,0);
    VL_SIG8(MemtoReg2_IDEXE,0,0);
    VL_SIG8(MemtoReg1_EXEM,0,0);
    VL_SIG8(MemtoReg2_EXEM,0,0);
    VL_SIG8(MemtoReg1_MEMW,0,0);
    VL_SIG8(MemtoReg2_MEMW,0,0);
    VL_SIG8(MemRead1_IDEXE,0,0);
    VL_SIG8(MemRead2_IDEXE,0,0);
    VL_SIG8(MemRead1_EXEM,0,0);
    VL_SIG8(MemRead2_EXEM,0,0);
    VL_SIG8(MemWrite1_IDEXE,0,0);
    VL_SIG8(MemWrite2_IDEXE,0,0);
    VL_SIG8(MemWrite1_EXEM,0,0);
    VL_SIG8(MemWrite2_EXEM,0,0);
    VL_SIG8(do_writeback1_WBID,0,0);
    VL_SIG8(do_writeback2_WBID,0,0);
    VL_SIG8(do_writeback1_IDEXE,0,0);
    VL_SIG8(do_writeback2_IDEXE,0,0);
    VL_SIG8(do_writeback1_MEMW,0,0);
    VL_SIG8(do_writeback2_MEMW,0,0);
    VL_SIG8(do_writeback1_EXEM,0,0);
    VL_SIG8(do_writeback2_EXEM,0,0);
    VL_SIG8(do_writeback1_WBEXE,0,0);
    VL_SIG8(do_writeback2_WBEXE,0,0);
    VL_SIG8(taken_branch1_IDIF,0,0);
    VL_SIG8(taken_branch2_IDIF,0,0);
    VL_SIG8(fetchNull1_fID,0,0);
    VL_SIG8(fetchNull2_fID,0,0);
    VL_SIG8(ALUSrc1_IDEXE,0,0);
    VL_SIG8(ALUSrc2_IDEXE,0,0);
    VL_SIG8(ALUSrc1_EXEM,0,0);
    VL_SIG8(ALUSrc2_EXEM,0,0);
    VL_SIG8(FREEZE,0,0);
    VL_SIG8(MVECT,1,0);
    VL_SIG8(__PVT__DataWriteMode,1,0);
    VL_SIG8(__PVT__IMISS,0,0);
    VL_SIG8(__PVT__DMISS,0,0);
    VL_SIG8(__PVT__iCache1__DOT__hit1,0,0);
    VL_SIG8(__PVT__iCache1__DOT__hit2,0,0);
    VL_SIG8(__PVT__iCache1__DOT__waitCount,3,0);
    VL_SIG8(__PVT__dCache1__DOT__hit0,0,0);
    VL_SIG8(__PVT__dCache1__DOT__hit1,0,0);
    VL_SIG8(__PVT__dCache1__DOT__waitCount,3,0);
    VL_SIG8(__PVT__ID1__DOT__ALU_control1,5,0);
    VL_SIG8(__PVT__ID1__DOT__opcode1,5,0);
    VL_SIG8(__PVT__ID1__DOT__funct1,5,0);
    VL_SIG8(__PVT__ID1__DOT__format1,4,0);
    VL_SIG8(__PVT__ID1__DOT__rt1,4,0);
    VL_SIG8(__PVT__ID1__DOT__writeRegister1,4,0);
    VL_SIG8(__PVT__ID1__DOT__taken_branch1,0,0);
    VL_SIG8(__PVT__ID1__DOT__link1,0,0);
    VL_SIG8(__PVT__ID1__DOT__RegDst1,0,0);
    VL_SIG8(__PVT__ID1__DOT__jump1,0,0);
    VL_SIG8(__PVT__ID1__DOT__MemRead1,0,0);
    VL_SIG8(__PVT__ID1__DOT__MemtoReg1,0,0);
    VL_SIG8(__PVT__ID1__DOT__MemWrite1,0,0);
    VL_SIG8(__PVT__ID1__DOT__ALUSrc1,0,0);
    VL_SIG8(__PVT__ID1__DOT__RegWrite1,0,0);
    VL_SIG8(__PVT__ID1__DOT__jumpRegister_Flag1,0,0);
    VL_SIG8(__PVT__ID1__DOT__sign_or_zero_Flag1,0,0);
    VL_SIG8(__PVT__ID1__DOT__syscal1,0,0);
    VL_SIG8(__PVT__ID1__DOT__syscalBubbleCounter,1,0);
    VL_SIG8(__PVT__ID1__DOT__comment1,0,0);
    VL_SIG8(__PVT__EXE1__DOT__ALU1__DOT__i,4,0);
    VL_SIG8(__PVT__MEM1__DOT__ALU_control,5,0);
    VL_SIG8(__PVT__MEM1__DOT__select1_WB,0,0);
    //char	__VpadToAlign253[3];
    VL_SIG(R2_output_ID,31,0);
    VL_SIG(Instr_fMEM,31,0);
    VL_SIG(Instr_address_2IM,31,0);
    VL_SIG(CIA_IFID,31,0);
    VL_SIG(PCA_IFID,31,0);
    VL_SIG(nextInstruction_address_IDIF,31,0);
    VL_SIG(writeData1_WBID,31,0);
    VL_SIG(writeData2_WBID,31,0);
    VL_SIG(writeData1_WBEXE,31,0);
    VL_SIG(writeData2_WBEXE,31,0);
    VL_SIG(writeData1_MID,31,0);
    VL_SIG(writeData2_MID,31,0);
    VL_SIG(Dest_Value1_IDEXE,31,0);
    VL_SIG(Dest_Value2_IDEXE,31,0);
    VL_SIG(Dest_Value1_EXEM,31,0);
    VL_SIG(Dest_Value2_EXEM,31,0);
    VL_SIG(Instr1_IDEXE,31,0);
    VL_SIG(Instr2_IDEXE,31,0);
    VL_SIG(Instr1_EXEM,31,0);
    VL_SIG(Instr2_EXEM,31,0);
    VL_SIG(Instr1_IFID,31,0);
    VL_SIG(Instr2_IFID,31,0);
    VL_SIG(Operand_A1_IDEXE,31,0);
    VL_SIG(Operand_A2_IDEXE,31,0);
    VL_SIG(Operand_B1_IDEXE,31,0);
    VL_SIG(Operand_B2_IDEXE,31,0);
    VL_SIG(aluResult1_EXEM,31,0);
    VL_SIG(aluResult2_EXEM,31,0);
    VL_SIG(aluResult1_EXEID,31,0);
    VL_SIG(aluResult2_EXEID,31,0);
    VL_SIG(aluResult1_MEMW,31,0);
    VL_SIG(aluResult2_MEMW,31,0);
    VL_SIG(aluResult1_WBID,31,0);
    VL_SIG(aluResult2_WBID,31,0);
    VL_SIG(data_read1_MEMW,31,0);
    VL_SIG(data_read2_MEMW,31,0);
    VL_SIG(readDataB1_IDEXE,31,0);
    VL_SIG(readDataB2_IDEXE,31,0);
    VL_SIG(readDataB1_EXEM,31,0);
    VL_SIG(readDataB2_EXEM,31,0);
    VL_SIG(Instr1_fIC,31,0);
    VL_SIG(Instr2_fIC,31,0);
    VL_SIG(__PVT__data_read_fDC,31,0);
    //char	__VpadToAlign428[4];
    VL_SIGW(__PVT__iCache1__DOT__cc0__DOT__valid,1023,0,32);
    VL_SIGW(__PVT__iCache1__DOT__cc0__DOT__dirty,1023,0,32);
    VL_SIGW(__PVT__iCache1__DOT__cc0__DOT__block_out1,255,0,8);
    VL_SIGW(__PVT__iCache1__DOT__cc0__DOT__block_out2,255,0,8);
    VL_SIGW(__PVT__dCache1__DOT__block_out0,255,0,8);
    VL_SIGW(__PVT__dCache1__DOT__block_out1,255,0,8);
    VL_SIGW(__PVT__dCache1__DOT__policy,256,0,9);
    //char	__VpadToAlign852[4];
    VL_SIGW(__PVT__dCache1__DOT__cc0__DOT__valid,511,0,16);
    VL_SIGW(__PVT__dCache1__DOT__cc0__DOT__dirty,511,0,16);
    VL_SIGW(__PVT__dCache1__DOT__cc1__DOT__valid,511,0,16);
    VL_SIGW(__PVT__dCache1__DOT__cc1__DOT__dirty,511,0,16);
    VL_SIG(__PVT__IF1__DOT__PC,31,0);
    VL_SIG(__PVT__IF1__DOT__FPC,31,0);
    VL_SIG(__PVT__ID1__DOT__com_OpA1,31,0);
    VL_SIG(__PVT__ID1__DOT__com_OpB1,31,0);
    VL_SIG(__PVT__ID1__DOT__signExtended_output1,31,0);
    VL_SIG(__PVT__ID1__DOT__R2_output,31,0);
    VL_SIG(__PVT__ID1__DOT__readDataA1,31,0);
    VL_SIG(__PVT__ID1__DOT__readDataB1,31,0);
    VL_SIG(__PVT__ID1__DOT__Operand_B1,31,0);
    VL_SIG(__PVT__EXE1__DOT__aluResult1,31,0);
    VL_SIG(__PVT__EXE1__DOT__OpA1,31,0);
    VL_SIG(__PVT__EXE1__DOT__OpB1,31,0);
    VL_SIG(__PVT__EXE1__DOT__Dst1,31,0);
    VL_SIG(__PVT__EXE1__DOT__HI,31,0);
    VL_SIG(__PVT__EXE1__DOT__LO,31,0);
    VL_SIG(__PVT__MEM1__DOT__data_read_aligned,31,0);
    VL_SIG(__PVT__MEM1__DOT__aluResult,31,0);
    //char	__VpadToAlign1180[4];
    VL_SIG64(__PVT__EXE1__DOT__ALU1__DOT__temp,63,0);
    VL_SIG(Reg_ID[32],31,0);
    VL_SIG(__PVT__iCache1__DOT__cc0__DOT__tags[1024],16,0);
    VL_SIGW(__PVT__iCache1__DOT__cc0__DOT__blocks[1024],255,0,8);
    VL_SIG(__PVT__dCache1__DOT__cc0__DOT__tags[512],17,0);
    VL_SIGW(__PVT__dCache1__DOT__cc0__DOT__blocks[512],255,0,8);
    VL_SIG(__PVT__dCache1__DOT__cc1__DOT__tags[512],17,0);
    VL_SIGW(__PVT__dCache1__DOT__cc1__DOT__blocks[512],255,0,8);
    
    // LOCAL VARIABLES
    VL_SIG8(dCache1__DOT____Vlvbound1,0,0);
    VL_SIG8(__Vdly__iCache1__DOT__waitCount,3,0);
    VL_SIG8(__Vdly__dCache1__DOT__waitCount,3,0);
    VL_SIG8(__Vdly__ID1__DOT__syscalBubbleCounter,1,0);
    VL_SIG8(__Vdly__writeRegister1_MEMW,4,0);
    VL_SIG8(__Vdly__do_writeback1_MEMW,0,0);
    //char	__VpadToAlign75058[2];
    VL_SIG(__Vdly__Instr2_IFID,31,0);
    VL_SIG(__Vdly__IF1__DOT__FPC,31,0);
    VL_SIG(__Vdly__IF1__DOT__PC,31,0);
    
    // INTERNAL VARIABLES
  private:
    //char	__VpadToAlign75076[4];
    VMIPS__Syms*	__VlSymsp;		// Symbol table
  public:
    
    // PARAMETERS
    
    // CONSTRUCTORS
  private:
    VMIPS_MIPS& operator= (const VMIPS_MIPS&);	///< Copying not allowed
    VMIPS_MIPS(const VMIPS_MIPS&);	///< Copying not allowed
  public:
    VMIPS_MIPS(const char* name="TOP");
    ~VMIPS_MIPS();
    
    // USER METHODS
    
    // API METHODS
    
    // INTERNAL METHODS
    void __Vconfigure(VMIPS__Syms* symsp, bool first);
    static void	_initial__TOP__v(VMIPS__Syms* __restrict vlSymsp);
    static void	_multiclk__TOP__v__12(VMIPS__Syms* __restrict vlSymsp);
    static void	_multiclk__TOP__v__15(VMIPS__Syms* __restrict vlSymsp);
    static void	_multiclk__TOP__v__17(VMIPS__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__v__10(VMIPS__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__v__13(VMIPS__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__v__2(VMIPS__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__v__3(VMIPS__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__v__4(VMIPS__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__v__6(VMIPS__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__v__7(VMIPS__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__v__9(VMIPS__Syms* __restrict vlSymsp);
    static void	_settle__TOP__v__1(VMIPS__Syms* __restrict vlSymsp);
    static void	_settle__TOP__v__11(VMIPS__Syms* __restrict vlSymsp);
    static void	_settle__TOP__v__14(VMIPS__Syms* __restrict vlSymsp);
    static void	_settle__TOP__v__16(VMIPS__Syms* __restrict vlSymsp);
    static void	_settle__TOP__v__18(VMIPS__Syms* __restrict vlSymsp);
    static void	_settle__TOP__v__5(VMIPS__Syms* __restrict vlSymsp);
    static void	_settle__TOP__v__8(VMIPS__Syms* __restrict vlSymsp);
} VL_ATTR_ALIGNED(64);

#endif  /*guard*/
