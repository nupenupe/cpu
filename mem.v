module mem(tclk, a_bus, inp, oup, instruction, state, d_bus);

input tclk;　//clock
input [4:0] a_bus; //adress bas
input [7:0] inp; //input
input [7:0] instruction; //instruction register
input [1:0] state; //state (instrucrtion cycle)
output [7:0] oup; // output
inout [7:0] d_bus; //data bas
reg [7:0] mem[0:31];
reg [7:0] oup;

function [7:0] memout; // memory read
    input [4:0] a_bus;
    case(a_bus)
        0:memout =8'b10011110; //inputをACCにLD
        1:memout =8'b10111111; //ACCをoutputにST
        2:memout =8'b01000100; //ACCと5'b00100(=4)番地の内容とのnand後にACCに代入
        3:memout =8'b11100000; //JPNZ
        4:memout =8'b00000000; //ACCと5'b00000のADD後にACCに代入
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

assign d_bus = (~((instruction[7:5] == 3'b0xx)||(instruction[7:5] == 3'b100))&&(state == EXEC_B))? memout(a_bus): 8'bz;//EXEC_Bの時memoutの値をd_busへ流すor流さない(ハイインピーダンス) 

parameter FETCH = 2'b00, DECODE = 2'b01, EXEC_A = 2'b10, EXEC_B = 2'b11;

endmodule
