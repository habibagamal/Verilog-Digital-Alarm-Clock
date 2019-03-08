`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:04:15 12/10/2017 
// Design Name: 
// Module Name:    adjustMode 
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
module adjustMode(clk, B2, B3, B4, RESET, led, rcout_inv, out, enIN, dataA12_IN, dataA24_IN, dataC12_IN, dataC24_IN, dataA12_OUT, dataA24_OUT, dataC12_OUT,dataC24_OUT, hours12_24);
/////////////////////////////////////////////////////////////////////////////
input clk; //clock
input B2,B4,B3; //buttons
input enIN; //Module Enable 
input [15:0] dataA12_IN, dataC12_IN, dataA24_IN, dataC24_IN; //Current Alarm & Clock
input RESET;
input hours12_24;

output [15:0] dataA12_OUT, dataC12_OUT, dataA24_OUT, dataC24_OUT;
output [3:0] rcout_inv;  
output [6:0] out;
output led;


wire dB4, dB2, dB3, eB4, eB2, eB3; //outputs of debouncer and edge detector
wire [7:0] hrT, minT, hrA, minA, hrT_24, hrT_12, hrA_12, hrA_24; //outputs of counters
wire [3:0] ONEShrT, TENShrT, ONESminT, TENSminT, ONEShrA, TENShrA, ONESminA, TENSminA; //outputs of BCD
wire [1:0] HUNDREDShrT, HUNDREDSminT, HUNDREDShrA, HUNDREDSminA; //outputs of BCD
wire [3:0] Amux, Tmux, disp;
wire [3:0] rcout; 
wire clk500;
wire [1:0] c1;
wire [3:0] cursor; 
wire AorT; 
wire enhrT, enminT, enhrA, enminA; 
wire rst;

wire [7:0] dataA0, dataC0;
wire [7:0] dataA1_12, dataC1_12, dataA1_24, dataC1_24;

assign dataA0 = dataA12_IN[7:0];
assign dataA1_12 = dataA12_IN[15:8];
assign dataA1_24 = dataA24_IN[15:8];

assign dataC0 = dataC12_IN[7:0];
assign dataC1_12 = dataC12_IN[15:8];
assign dataC1_24 = dataC24_IN[15:8];

assign dataC12_OUT = {hrT_12, minT};
assign dataA12_OUT = {hrA_12, minA};
assign dataC24_OUT = {hrT_24, minT};
assign dataA24_OUT = {hrA_24, minA};

edgeD e(.clk(clk), .rst(RESET), .w(enIN), .z(rst));

//led is on as long as we're in adjust mode
assign led = enIN; 
assign rcout_inv = ~rcout;

//clock divider for input of ring counter 
clock_divider  #(50000000, 500) c100(.div(clk500), .rst(RESET), .clk(clk));
//
////debouncer for all buttons 
Debouncer db2(.in(B2), .out(dB2), .rst(RESET), .clk(clk));
Debouncer db3(.in(B3), .out(dB3), .rst(RESET), .clk(clk));
Debouncer db4(.in(B4), .out(dB4), .rst(RESET), .clk(clk));
//
////edge detector for all buttons 
edgeD e2(.clk(clk), .rst(RESET), .w(dB2), .z(eB2));
edgeD e3(.clk(clk), .rst(RESET), .w(dB3), .z(eB3));
edgeD e4(.clk(clk), .rst(RESET), .w(dB4), .z(eB4));

//counter and decoder for choosing between current mins, current hours, alarm minutes, alarm hours
counter_n #(2,4) c(.q(c1), .clk(clk), .rst(RESET), .en(eB2), .ud(1'b0), .inc(1'b0), .ld(rst), .x(2'b01));
decoder2x4 decoder (.In(c1), .en(enIN), .Y(cursor));

// up/down for counters
assign UD = eB3 & ~eB4;

//current time counter
counter_n #(8,60) CminT (.q(minT), .clk(clk), .rst(RESET), .en(enminT), .ud(UD), .inc(1'b0), .ld(rst), .x(dataC0)); //mins current

counter_n #(8,24) ChrT_24  (.q(hrT_24), .clk(clk), .rst(RESET), .en(enhrT), .ud(UD), .inc(1'b0), .ld(rst), .x(dataC1_24)); //hour current

counter_n #(8,12) ChrT_12  (.q(hrT_12), .clk(clk), .rst(RESET), .en(enhrT), .ud(UD), .inc(1'b0), .ld(rst), .x(dataC1_12)); //hour current

assign hrT = hours12_24? hrT_12 : hrT_24; 
//alarm time counter
counter_n #(.n(8),.m(60),.rstV(8'd59)) CminA (.q(minA), .clk(clk), .rst(RESET), .en(enminA), .ud(UD), .inc(1'b0), .ld(rst), .x(dataA0)); //min alarm
counter_n #(.n(8),.m(24),.rstV(8'd23)) ChrA_24  (.q(hrA_24), .clk(clk), .rst(RESET), .en(enhrA), .ud(UD), .inc(1'b0), .ld((rst)), .x(dataA1_24)); //hour alarm

counter_n #(.n(8),.m(12),.rstV(8'd11)) ChrA_12  (.q(hrA_12), .clk(clk), .rst(RESET), .en(enhrA), .ud(UD), .inc(1'b0), .ld(rst), .x(dataA1_12)); //hour current

assign hrA = hours12_24? hrA_12 : hrA_24; 

//current time binary to BCD
binary_to_BCD BCDminT(.A(minT), .ONES(ONESminT), .TENS(TENSminT), .HUNDREDS(HUNDREDSminT));
binary_to_BCD BCDhrT (.A(hrT), .ONES(ONEShrT), .TENS(TENShrT), .HUNDREDS(HUNDREDShrT));

//alarm time binary to BCD
binary_to_BCD BCDminA(.A(minA), .ONES(ONESminA), .TENS(TENSminA), .HUNDREDS(HUNDREDSminA));
binary_to_BCD BCDhrA (.A(hrA), .ONES(ONEShrA), .TENS(TENShrA), .HUNDREDS(HUNDREDShrA));

//ring counter for FPGA digits
ring_counter rc1(.clk(clk500), .rst(RESET), .r(rcout), .en(enIN));
//mux for current time 
mux m1(.a(TENShrT), .b(ONEShrT), .c(TENSminT), .d(ONESminT), .out(Tmux), .sel(rcout));
//mux for alarm time
mux m2(.a(TENShrA), .b(ONEShrA), .c(TENSminA), .d(ONESminA), .out(Amux), .sel(rcout));


//selection line of display on FPGA
assign AorT = (cursor[3] || cursor[0]); 

//mux of display on FPGA
assign disp = (AorT) ? Amux : Tmux;

//seven segment
sevenSeg seg1(.In(disp), .en(enIN), .Y(out));

//enables for counters
assign enhrT  = (eB3 ^ eB4) && (cursor[1]) && enIN;
assign enminT = (eB3 ^ eB4) && (cursor[2]) && enIN;
assign enhrA  = (eB3 ^ eB4) && (cursor[3]) && enIN;
assign enminA = (eB3 ^ eB4) && (cursor[0]) && enIN;



endmodule
