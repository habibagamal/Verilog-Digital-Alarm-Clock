`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:48:51 12/03/2017 
// Design Name: 
// Module Name:    Debouncer 
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
module Debouncer(in, out, rst, clk);
input in, clk, rst;
output out;
reg [2:0]save;
assign out = (save == 3'b111);
always@(posedge clk or posedge rst) begin
if(rst) save <= 3'b000;
//else save <= {~in,save[2],save[1]};
else save <= {in,save[2],save[1]};
end
endmodule
