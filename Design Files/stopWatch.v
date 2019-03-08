`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:07:07 12/10/2017 
// Design Name: 
// Module Name:    stopWatch 
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
module stopWatch(clk, RESET, rest, y, rcout_inv, stop, enIN);
 
//rst is B3. Stop is B2 
input RESET, clk, rest, stop, enIN;

output [6:0] y;
output [3:0] rcout_inv;

reg en1;
wire en;

assign en = en1;

wire [3:0] rcout;
wire Brst, Estop, drst, dstop;
wire div, div500;
wire [3:0] q0, q1, q2, q3, mout;

edgeD e(.clk(clk), .rst(RESET), .w(enIN), .z(rst));

Debouncer db1(.in(rest), .out(drst), .rst(RESET), .clk(clk));
Debouncer db2(.in(stop), .out(dstop), .rst(RESET), .clk(clk));

edgeD e1(.clk(clk), .rst(RESET), .w(drst), .z(Brst));
edgeD e2(.clk(clk), .rst(RESET), .w(dstop), .z(Estop));

clock_divider #(50000000, 100) c1(.div(div),.rst(RESET),.clk(clk));
clock_divider #(50000000, 500) c100(.div(div500),.rst(RESET),.clk(clk));

counter_n #(4,10) d0 (.q(q0),.clk(div),.rst(Brst || rst || RESET),.en(en && enIN),.ud(1'b0),.inc(1'b0), .ld(1'b0), .x(4'd0));
counter_n #(4,10) d1 (.q(q1),.clk(div),.rst(Brst || rst || RESET),.en(q0==4'd9 && en && enIN),.ud(1'b0),.inc(1'b0), .ld(1'b0), .x(4'd0));
counter_n #(4,10) d2 (.q(q2),.clk(div),.rst(Brst || rst || RESET),.en(q1==4'd9 && q0==4'd9  && en && enIN),.ud(1'b0),.inc(1'b0), .ld(1'b0), .x(4'd0));
counter_n #(4, 6) d3 (.q(q3),.clk(div),.rst(Brst || rst || RESET),.en(q2==4'd9 && q1==4'd9 && q0==4'd9 && en && enIN),.ud(1'b0),.inc(1'b0), .ld(1'b0), .x(4'd0));

ring_counter rc1(.clk(div500),.rst(rst || RESET),.r(rcout),.en(enIN));
mux m1(.a(q3),.b(q2),.c(q1),.d(q0),.out(mout),.sel(rcout));
sevenSeg seg(.In(mout),.en(enIN), .Y(y));

assign rcout_inv = ~rcout;

always @ (posedge clk) begin
	if (RESET || Brst || rst) begin
		en1 = 1'b0;
	end
	else if (Estop) begin
		en1 = ~en1;
	end
end
endmodule
