#!/bin/sh
iverilog alu.v alu_test.v 
vvp a.out
gtkwave alu_out.vcd
