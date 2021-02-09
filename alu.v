
module alu( reset, tclk, instruction, ldAcc, useAlu, dbusSelect, acc, latch, c, z, d_bus );

input reset, tclk; //reset ,clock
input [7:0] instruction; //instruction register
input ldAcc, useAlu, dbusSelect;
output [7:0] acc, latch; //accumulator,latch
reg [7:0] acc, latch;
output c,z; //carry_flag ,zero_flag
reg c, z;
inout [7:0] d_bus; //data bus

always @(posedge tclk or posedge reset) begin
    if (reset) begin 
        acc<=8'b0; latch<=8'b0; c<=1'b0; z<=1'b0; 
    end
    else begin
    if(useAlu) begin //EXEC_Aの時,算術命令とSTを行う
        casex(instruction[7:5])
            3'b000: begin//ADD 
                {c,latch}<=acc + d_bus;
                z<=((acc + d_bus)==8'b0);
                end 
            3'b001: begin//SUB
                {c,latch}<=acc - d_bus; 
                z<=((acc - d_bus)==8'b0);
                end 
            3'b010: begin//NAND 
                {c,latch}<=~(acc & d_bus); 
                z<=((~(acc & d_bus))==8'b0);
                end
            3'b011: begin //SHIFT
                if(instruction[4:0]==5'h1f)begin //RIGHT SHIFT
                {c,latch}<=acc >> 1; 
                z<=((acc >>1 )==8'b0);
                end
                else begin {c,latch}<=acc << 1; //LEFT SHIFT
                z<=((acc <<1 )==8'b0); 
                end
                end
            3'b101: latch<=acc; //ST
        endcase
    end
    if(ldAcc) acc<=d_bus; //EXEC_Aの時LD行う
    end
end

assign d_bus= (dbusSelect)? latch: 8'bz; //EXEC_Bの時latchの値をd_busへ流すor流さない(ハイインピーダンス) 

parameter FETCH = 2'b00, DECODE = 2'b01, EXEC_A = 2'b10, EXEC_B = 2'b11;

endmodule
