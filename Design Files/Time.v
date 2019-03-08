`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:02:11 12/10/2017 
// Design Name: 
// Module Name:    Time 
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
module Time(clk, RESET, clockDisp, rInv, enIN, dataIN_12, dataIN_24, dataOUT_12, dataOUT_24, hours12_24);

input clk, RESET, enIN, hours12_24;
input [15:0] dataIN_12, dataIN_24;

output [6:0] clockDisp;
output [3:0] rInv;
output [15:0] dataOUT_12, dataOUT_24;

wire [3:0] disp;

wire clkDiv, clk500, clkInt;

wire [7:0] minsC, hrsC, hrsC24, hrsC12;
wire [3:0] MinC0, MinC1, HrC0, HrC1, ring;
wire [1:0] MinC2, HrC2;
wire rst; 
wire [7:0] data0;
wire [7:0] data1_12, data1_24;

assign rInv = ~ring;

assign data0 = dataIN_12[7:0];
assign data1_12 = dataIN_12[15:8];
assign data1_24 = dataIN_24[15:8];

assign dataOUT_24 = {hrsC24, minsC};
assign dataOUT_12 = {hrsC12, minsC};edgeD e(.clk(clk), .rst(RESET), .w(enIN), .z(rst));

clock_divider #(50000000, 500) divRing(.clk(clk), .rst(RESET), .div(clk500));

clock_divider #(50000000, 1) divMinINT(.clk(clk), .rst(RESET), .div(clkInt));
clock_divider #(60, 1) divMin(.clk(clkInt), .rst(RESET), .div(clkDiv));


counter_n #(8, 60) cMin(.q(minsC), .clk(clkDiv), .rst(RESET), .en(                  enIN), .ud(1'b0), .inc(1'b0), .ld(rst), .x(data0));
counter_n #(8, 24) cHr24 (.q( hrsC24), .clk(clkDiv), .rst(RESET), .en(minsC == 8'd59 && enIN), .ud(1'b0), .inc(1'b0), .ld(rst), .x(data1_24));

counter_n #(8, 12) cHr12 (.q( hrsC12), .clk(clkDiv), .rst(RESET), .en(minsC == 8'd59 && enIN), .ud(1'b0), .inc(1'b0), .ld(rst || hours12_24), .x(data1_12));

assign hrsC= hours12_24 ? hrsC12 : hrsC24;

binary_to_BCD BCDmin(.A(minsC), .ONES(MinC0), .TENS(MinC1), .HUNDREDS(MinC2));
binary_to_BCD BCDhr (.A( hrsC), .ONES( HrC0), .TENS( HrC1), .HUNDREDS( HrC2));

ring_counter dispRing(.clk(clk500), .rst(RESET || rst), .r(ring), .en(enIN));
mux muxMin(.a(HrC1), .b(HrC0), .c(MinC1), .d(MinC0), .out(disp), .sel(ring));

sevenSeg sevSeg(.In(disp), .en(enIN), .Y(clockDisp));

endmodule