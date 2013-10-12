#include "Vqueue.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

Vqueue *top;

int main(int argc, char **argv, char**env) {
	int i;
	int clk;
	Verilated::commandArgs(argc, argv);
	top = new Vqueue;
	Verilated::traceEverOn(true);
	VerilatedVcdC* tfp = new VerilatedVcdC;
	top->trace(tfp, 99);
	top->clk = 1;
	top->reset = 0;
	for (i=0; i<20; i++) {
		top->reset = (i < 2);
		for (clk = 0; clk < 2; clk++) {
			tfp->dump(2*i + clk);
			top->clk = !top->clk;
			top->eval();
		}
		if(Verilated::gotFinish()) exit(0);
	}
	tfp->close();
	exit(0);
}
