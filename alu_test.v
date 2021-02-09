`timescale 1ns/1ns
module alu_test;

//input signal (clock)
reg tclk = 1;
always #(STEP/2) tclk<=!tclk;

//input signal
reg reset;
reg [7:0] instruction;
reg ldAcc, useAlu, dbusSelect;
reg [7:0] view_d_bus; //d_busの状態を見る変数
//reg [7:0] view_acc, view_latch; //acc,latchの状態を見る変数

//output siganl
wire c,z;
wire [7:0] acc,latch;
wire [7:0] d_bus;

//双方向信号対応用
assign d_bus = view_d_bus;

parameter STEP = 100;

alu alu( reset, tclk, instruction, ldAcc, useAlu, dbusSelect, acc, latch, c, z, d_bus );

    initial begin

        reset=1'b0; instruction=8'b01100000; ldAcc = 1'b0; useAlu = 1'b0; dbusSelect = 1'b0; 
        view_d_bus = 8'bz;

        //正常動作の確認
            //Fetch cycle　ALU付近は何もしない
            #STEP instruction =8'b01101000;
            #STEP

            //reset
            #STEP reset = 1'b1;
            #STEP reset = 1'b0;

            //Execute cycle A
                //LD命令
                #STEP view_d_bus = 8'b10011110; ldAcc = 1'b1;
                //ADD命令
                #STEP ldAcc = 1'b0; useAlu = 1'b1; view_d_bus = 8'b01100001; instruction = 8'b000xxxxx;
                //SUB命令
                #STEP instruction = 8'b001xxxxx; view_d_bus = 8'b11111111; 
                //NAND命令
                #STEP instruction = 8'b010xxxxx; view_d_bus = 8'b10101010; 
                //SHIFT命令
                #STEP instruction = 8'b01100000; //LEFT SHIFT
                #STEP instruction = 8'b01111111; //RIGHT SHIFT
                //ST命令
                #STEP instruction = 8'b101xxxxx;

                #STEP useAlu = 1'b0; 
            
            //Execute cycle B
                #STEP dbusSelect = 1'b1;
                #STEP dbusSelect = 1'b0;
        
        //異常入力の時の動作
            //reset
            #STEP reset = 1'bx;
            #STEP reset = 1'bz;

            //Execute cycle A
                #STEP useAlu = 1'b1;
                #STEP instruction = 8'bxxxxxxxx;
                #STEP instruction = 8'bzzzzzzzz;
                #STEP useAlu = 1'bx;
                #STEP instruction = 8'b001xxxxx;
                #STEP useAlu = 1'bz;
                #STEP instruction = 8'b001xxxxx;

            //Execute cycle B
                #STEP dbusSelect = 1'bx;
                #STEP dbusSelect = 1'bz;

        #STEP $finish;
    end

    initial begin
        $dumpfile("alu_out.vcd");
        $dumpvars(0, alu_test);
    end


endmodule