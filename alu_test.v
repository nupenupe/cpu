`timescale 1ns/1ns
module mem_test;
//input signal (clock)
reg tclk = 1;
always #(STEP/2) tclk<=!tclk;

//input signal
reg [4:0] a_bus; 
reg [7:0] inp; 
reg [7:0] instruction; 
reg dbusSelect; 
reg [7:0] in_d_bus;

//output siganl
wire [7:0] oup;
wire [7:0] d_bus;
wire [7:0] view_mem;
//inout信号の入力をそのまま出力に流すか(d_busの中身を変えるため)
reg inout_flag ;

//双方向信号対応用
assign d_bus = (inout_flag)? in_d_bus: 8'bz;

parameter STEP = 100;

mem mem( tclk, a_bus, inp, oup, instruction, dbusSelect, d_bus, view_mem );

    initial begin

        instruction=8'b010xxxxx; inp = 8'h0; dbusSelect = 1'b1; 
        in_d_bus = 8'bz; inout_flag = 1'b0;

        //正常動作の確認
            //0~4番地までを読みだしてd_busに流す
            #STEP dbusSelect = 1'b0; a_bus = 4'd0;
            #STEP a_bus = 4'd1;
            #STEP a_bus = 4'd2;
            #STEP a_bus = 4'd3;
            #STEP a_bus = 4'd4;
            //30番地(input)をd_busに流す
            #STEP a_bus = 30; inp=8'b11111111;
            //LD命令の時
                //d_busの内容をoutputするとき
                #STEP instruction = 8'b10000000; in_d_bus = 8'b01010101; a_bus = 31; inout_flag = 1'b1; dbusSelect = 1'b1;
                //d_busの内容をRAMに書き込むとき
                #STEP a_bus = 5; 
        
        //異常入力の時の動作
            //制御信号がおかしい時
            #STEP dbusSelect = 1'bx; inout_flag = 1'b0; instruction=8'b010xxxxx;
            #STEP dbusSelect = 1'bz;

            //番地がおかしい時にどうd_busにながれるか
            #STEP dbusSelect = 1'b0; a_bus = 4'b000x; inout_flag = 1'b0; dbusSelect = 1'b0;
            #STEP a_bus = 4'b000z;


        #STEP $finish;
    end

    initial begin
        $dumpfile("mem_out.vcd");
        $dumpvars(0, mem_test);
    end


endmodule
