`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:50:14 12/10/2017 
// Design Name: 
// Module Name:    melodyROM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module melodyROM(clk, address, note);

input clk;
input [4:0] address;
output reg [7:0] note;
	
always @(posedge clk) begin
case(address)
			0: note<= 8'd22;
			1: note<= 8'd0;
			2: note<= 8'd22;
			3: note<= 8'd0;
			4: note<= 8'd29;
			5: note<= 8'd0;
			6: note<= 8'd29;
			7: note<= 8'd0;
			8: note<= 8'd19;
			9: note<= 8'd0;
		  10: note<= 8'd19;
		  11: note<= 8'd0;
		  12: note<= 8'd29;
		  13: note<= 8'd0;
		  14: note<= 8'd27;
		  15: note<= 8'd0;
		  16: note<= 8'd27;
		  17: note<= 8'd0;
		  18: note<= 8'd26;
		  19: note<= 8'd0;
		  20: note<= 8'd26;
		  21: note<= 8'd0;
		  22: note<= 8'd24;
		  23: note<= 8'd0;
		  24: note<= 8'd24;
		  25: note<= 8'd0;
		  26: note<= 8'd22;
		  27: note<= 8'd0;
		  28: note<= 8'd0;
		  29: note<= 8'd0;
		  30: note<= 8'd0;
		  31: note<= 8'd0;
	default: note <= 8'd0;
	endcase
end
endmodule
