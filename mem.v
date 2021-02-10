module mem(tclk, a_bus, inp, oup, instruction, dbusSelect, d_bus, view_mem);

input tclk; //clock
input [4:0] a_bus; //adress bas
input [7:0] inp; //input
input [7:0] instruction; //instruction register
input dbusSelect; //control signal
output [7:0] oup; // output
inout [7:0] d_bus; //data bas
reg [7:0] mem[0:31];
reg [7:0] oup;

//------memの内容を見るための変数 結合テストの時には消す-----
output [7:0] view_mem; 
assign view_mem =mem[a_bus];
//----------------------------------------

function [7:0] memout; // memory read
    input [4:0] a_bus;
    case(a_bus)
        //ROM 0~4番地
        0:memout =8'b10011110; //inputをACCにLD
        1:memout =8'b10111111; //ACCをoutputにST
        2:memout =8'b01000100; //ACCと5'b00100(=4)番地の内容とのnand後にACCに代入
        3:memout =8'b11100000; //JPNZ
        4:memout =8'b00000000; //ACCと5'b00000のADD後にACCに代入

        //RAM 5~29番地

        //input=30 output=31番地
        30:memout =inp;
        default: memout =mem[a_bus];
    endcase
endfunction

always @(posedge tclk) begin
    if(instruction[7:5] == 3'b100 )begin
        if (a_bus==31) oup<=d_bus;  
        else mem[a_bus] <=d_bus;
    end
end

assign d_bus = (~(dbusSelect))? memout(a_bus): 8'bz;//EXEC_Bの時memoutの値をd_busへ流すor流さない(ハイインピーダンス) 

endmodule
