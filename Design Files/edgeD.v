// file: edgeD.v
// author: @habibagamal

`timescale 1ns/1ns
module edgeD(clk, rst, w, z);
input clk, rst, w; 
output z;
reg [1:0] state, nextState;
// States Encoding
parameter [1:0] A=2'b00, B=2'b01, C=2'b10;
// Next state Logic
always @ (w or state)
case (state)
 A: if (w) nextState = B;
else nextState = A;
 B: if (w) nextState = C;
else nextState = A;
 C: if (w) nextState = C;
else nextState = A;
endcase
// Update state FF's with the triggering edge of the clock
always @ (posedge clk or posedge rst) begin
if(rst) state <= A;
else state <= nextState;
end
// Output Logic
assign z = (state == B);
endmodule
