`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:21 12/10/2017 
// Design Name: 
// Module Name:    div_12 
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
module div_12(numerator, quotient, remainder);

input [5:0] numerator;
output reg [2:0] quotient;
output [3:0] remainder;

reg [3:0] remainder_bits;

assign remainder = {remainder_bits, numerator[1:0]};

always @(*) begin
case(numerator[5:2])
   0: begin quotient = 0; remainder_bits = 2'b00; end
   1: begin quotient = 0; remainder_bits = 2'b01; end
   2: begin quotient = 0; remainder_bits = 2'b10; end
   3: begin quotient = 1; remainder_bits = 2'b00; end
   4: begin quotient = 1; remainder_bits = 2'b01; end
   5: begin quotient = 1; remainder_bits = 2'b10; end
   6: begin quotient = 2; remainder_bits = 2'b00; end
   7: begin quotient = 2; remainder_bits = 2'b01; end
   8: begin quotient = 2; remainder_bits = 2'b10; end
   9: begin quotient = 3; remainder_bits = 2'b00; end
  10: begin quotient = 3; remainder_bits = 2'b01; end
  11: begin quotient = 3; remainder_bits = 2'b10; end
  12: begin quotient = 4; remainder_bits = 2'b00; end
  13: begin quotient = 4; remainder_bits = 2'b01; end
  14: begin quotient = 4; remainder_bits = 2'b10; end
  15: begin quotient = 5; remainder_bits = 2'b00; end
endcase
end
endmodule
