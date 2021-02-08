`timescale 1ns/1ns
module alu_test;

//input signal (clock)
reg tclk = 1;
always #(STEP/2) tclk<=!tclk;

//input signal
reg reset;
reg [7:0] instruction;
reg [1:0] state;
reg [7:0] view_d_bus; //d_busの状態を見る変数
//reg [7:0] view_acc, view_latch; //acc,latchの状態を見る変数

//output siganl
wire c,z;
wire [7:0] acc,latch;
wire [7:0] d_bus

//双方向信号対応用
assign d_bus = view_d_bus

parameter STEP = 100;
parameter FETCH = 2'b00, DECODE = 2'b01, EXEC_A = 2'b10, EXEC_B = 2'b11;

alu alu( reset, tclk, instruction, state, acc, latch, c, z, d_bus );

    initial begin

        reset=1'b0; bus=8'h0; instruction=8'b01100000; state = EXEC_B; acc = 8'h0 d_bus = 8'h0;
        view_d_bus = 8'bz

        #STEP reset = 1'b1
        #STEP enable=1'b1; bus= 8'b0000_1111;
        #STEP enable=1'b0;
        #STEP enable=1'b1; bus= 8'b1111_0000;
        #STEP enable=1'b0;
        #STEP enable=1'b1; bus= 8'hxx;
        #STEP enable=1'b0;
        #STEP enable=1'b1; bus= 8'h0x;
        #STEP enable=1'b0;
        #STEP enable=1'b1; bus= 8'hzz;
        #STEP enable=1'b0;
        #STEP enable=1'b1; bus= 8'h0z;
        #STEP enable=1'b0;
        #STEP enable=1'bx; bus= 8'b1111_0000;
        #STEP enable=1'bz; bus= 8'b1111_0000;

        #STEP $finish;
    end

    initial begin
        $monitor( $stime, " enable=%h, bus=%h, DOUT=%h", enable, bus, DOUT);
        $dumpfile("alu_out.vcd");
        $dumpvars(0, alu_test);
    end


endmodule
