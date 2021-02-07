
module alu( reset, tclk, instruction, state, acc, latch, c, z, d_bus );

input reset, tclk;
input [7:0] instruction;
input [1:0] state;
output [7:0] acc, latch;
reg [7:0] acc, latch
output c,z;
reg c, z;
inout [7:0] d_bus;

always @(posedge tclk or posedge reset) begin
    if (reset) begin 
        acc<=8'b0; latch<=8'b0; c<=1'b0; z<=1'b0; 
    end
    else begin
    if(((instruction[7:5] == 2'b0xx)||(instruction[7:5] == 2'b101))&&(state == EXEC_B)) begin //EXEC_Bの時,算術命令とSTを行う
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
                if(instruction[4:0]==5'h1f) {c,latch}<=acc >> 1; z<=((acc >>1 )==8'b0);//RIGHT SHIFT
                else {c,latch}<=acc << 1; z<=((acc <<1 )==8'b0); //LEFT SHIFT
                end
            3'b101: latch<=acc; //ST
        endcase
    end
    if((instruction[7:5] == 2'b100) && (state == EXEC_A)) acc<=d_bus; //EXEC_Aの時LD行う
    end
end
