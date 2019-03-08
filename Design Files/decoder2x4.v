`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:25:04 11/08/2017 
// Design Name: 
// Module Name:    DECODER 
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
module decoder2x4(In, en, Y);
input [1:0]In;
input en;
output reg [3:0] Y;
always@(In or en) begin
    if(en == 1'b1) begin
        case(In)
            2'b00: Y = 4'b0001;
            2'b01: Y = 4'b0010;
            2'b10: Y = 4'b0100;
            2'b11: Y = 4'b1000;
				default: Y = 4'b0000;
        endcase
    end
    else
        Y = 4'b0000;
end
endmodule
