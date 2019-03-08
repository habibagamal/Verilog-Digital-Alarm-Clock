// file: ring_counter.v
// author: @habibagamal

`timescale 1ns/1ns

module ring_counter(clk,rst,r,en);
input clk, rst, en;
output reg [3:0] r; 
always @(posedge clk or posedge rst)begin
	if (rst)begin
		r<=4'b0001;
	end
	else if (en) begin 
		r<={r[2],r[1],r[0],r[3]};
	end
	end
endmodule
