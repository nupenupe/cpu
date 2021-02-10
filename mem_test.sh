#!/bin/sh
iverilog mem.v mem_test.v 
vvp a.out
gtkwave mem_out.vcd
