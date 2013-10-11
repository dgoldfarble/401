#!/bin/sh

# run Verilator to translate Verilog into C++, including testbench
verilator -Wall --cc --trace queue.v --exe queue_tb.cpp

make -j -C obj_dir/ -f Vqueue.mk Vqueue

obj_dir/Vqueue

gtkwave queue.vcd counter.sav &
