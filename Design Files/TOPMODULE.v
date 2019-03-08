`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:07:43 12/10/2017 
// Design Name: 
// Module Name:    TOPMODULE
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
module TOPMODULE(clk, RESET, B1, B2, B3, B4, DISP, ledOUT, rInv, speaker, hours12_24);
//Declaration
input clk, RESET, B1, B2, B3, B4, hours12_24;

output [6:0] DISP;
output ledOUT;
output [3:0] rInv;
output speaker; 

wire clkDiv, clk500, clkMEL, ledADJ;
//wire speaker;
wire [15:0] ClockTIME, ClockTIME_12, ClockTIME_24, ADJclockTIME, ADJclockTIME_12, ADJclockTIME_24, AlarmTIMEwireOUT_12, AlarmTIMEwireOUT_24, AlarmTIMEwireOUT;
//wire [15:0] AlarmTIMEwireIN;
wire [6:0] dispALARM, dispTIME, dispADJ, dispSTOP;
wire [3:0] rTIME, rADJ, rSTOP, rALARMout, rALARMinv, segA;
wire [3:0] minA0, minA1, hrA0, hrA1;
wire [1:0] minA2, hrA2;
wire [2:0] ENwire;
wire [3:0] dispSELwire;
wire  [15:0] AlarmTIME;

reg		  ledALARM, ALARM, enSPKR;
reg  [3:0] dispSEL;
reg  [31:0] c1, c2;
reg  [2:0] EN;
reg  [15:0] AlarmTIME_12, AlarmTIME_24;

parameter CLK = 3'b100, ADJ = 3'b010, STOP = 3'b101;

//assign AlarmTIMEwireIN = AlarmTIME;
assign ENwire = EN;
assign dispSELwire = dispSEL;
//END Declaration

// MODULE Call

Time timemode(.clk(clk), .RESET(RESET), .clockDisp(dispTIME), .rInv(rTIME), .enIN(ENwire[2]), .dataIN_12(ADJclockTIME_12), 
					.dataIN_24(ADJclockTIME_24), .dataOUT_12(ClockTIME_12), .dataOUT_24(ClockTIME_24), .hours12_24(hours12_24));


adjustMode adjustmode(.clk(clk), .B2(B2), .B3(B3), .B4(B4), .RESET(RESET), .led(ledADJ), .rcout_inv(rADJ), .out(dispADJ), .enIN(ENwire[1]), .dataA12_IN(AlarmTIME_12), 
							.dataA24_IN(AlarmTIME_24), .dataC12_IN(ClockTIME_12), .dataC24_IN(ClockTIME_24), .dataA12_OUT( AlarmTIMEwireOUT_12 ), .dataA24_OUT( AlarmTIMEwireOUT_24 ),
							.dataC12_OUT(ADJclockTIME_12), .dataC24_OUT(ADJclockTIME_24), .hours12_24(hours12_24));
stopWatch stopwatchmode(.clk(clk), .RESET(RESET), .rest(B3), .y(dispSTOP), .rcout_inv(rSTOP), .stop(B2), .enIN(ENwire[0]));

Melody M(.clk(clkMEL), .speaker(speaker), .enIN(ALARM));
//END MODULE Call
clock_divider #(50000000, 40000000) divMEL(.clk(clk), .rst(RESET), .div(clkMEL));

assign ledOUT = (ledADJ || ledALARM);
assign rALARMinv = ~rALARMout;

//Button Debouncers
Debouncer dbB1(.in(B1), .out(dB1), .rst(RESET), .clk(clk));
edgeD edB1(.clk(clk), .rst(RESET), .w(dB1), .z(eB1));

Debouncer dbB2(.in(B2), .out(dB2), .rst(RESET), .clk(clk));
//edgeD edB2(.clk(clk), .rst(RESET), .w(dB2), .z(eB2));
//END Button Debouncers

//Alarm Time Display
binary_to_BCD bcdMINalarm(.A(AlarmTIME[7:0]), .ONES(minA0), .TENS(minA1), .HUNDREDS(minA2));
binary_to_BCD  bcdHRalarm(.A(AlarmTIME[15:8]), .ONES(hrA0), .TENS(hrA1), .HUNDREDS(hrA2));

ring_counter dispRA(.clk(clk500), .rst(RESET), .r(rALARMout), .en(1'b1));

mux muxRA(.a(hrA1), .b(hrA0), .c(minA1), .d(minA0), .out(segA), .sel(rALARMout));

sevenSeg sevSeg(.In(segA), .en(1'b1), .Y(dispALARM));
//END Alarm Time Display

clock_divider #(50000000, 10) divi(.clk(clk), .rst(RESET), .div(clkDiv));
clock_divider #(50000000, 1000) alarmDiv(.clk(clk), .rst(RESET), .div(alarmClk));
clock_divider #(50000000, 500) div500(.clk(clk), .rst(RESET), .div(clk500));

mux #(7) dispMUX(.a(dispTIME), .b(dispALARM), .c(dispADJ), .d(dispSTOP), .out(DISP), .sel(dispSELwire));
mux 		ringMUX(.a(rTIME), .b(rALARMinv), .c(rADJ), .d(rSTOP), .out(rInv), .sel(dispSELwire));

assign AlarmTIME= hours12_24? AlarmTIME_12: AlarmTIME_24;
assign ClockTIME= hours12_24? ClockTIME_12: ClockTIME_24; 
 
always @ (posedge clk or posedge RESET) begin
	if (RESET) begin 
		ALARM <= 1'b0;
		AlarmTIME_12 <= {8'd11, 8'd59};
		AlarmTIME_24 <= {8'd23, 8'd59};
	end
	else begin
		if(EN == ADJ) begin
				AlarmTIME_12 <= AlarmTIMEwireOUT_12;
				AlarmTIME_24 <= AlarmTIMEwireOUT_24;
		end	 
		if(EN == CLK) begin
			if (AlarmTIME==ClockTIME) begin
				ALARM <= 1'b1; 
			end
			else begin
				ALARM <= 1'b0;
			end
		end
		else begin 
			ALARM <= 1'b0;
		end
	end
end

always @ (posedge clkDiv or posedge RESET) begin
	if (RESET) begin 
	ledALARM <= 1'b0;
	end 
	else if(ALARM) begin
			ledALARM <= ~ledALARM;
		end
	else begin
		ledALARM <= 1'b0;			
	end
end

always @ (posedge clk or posedge RESET) begin
	if (RESET) begin 
		c1<=0; 
		c2<=0; 
	end 
	else if(EN == CLK) begin
		if(dB1 && !dB2) begin
			c1 <= c1 + 1;
			if (c1 == 100000001) begin
				c1 <= 0;
			end
		end
		else if(!dB1) begin
			c1 <= 0;
		end
	
		if(dB2 && !dB1) begin
			c2 <= c2 + 1;
			if (c2 == 100000001) begin
				c2 <= 0;
			end
		end
		else if(!dB2) begin
			c2 <= 0;
		end
	end
end

always @ (posedge clk or posedge RESET) begin
	if (RESET) begin
		EN <= CLK;
	end 
	else if(EN == STOP || EN == ADJ) begin
		////use eB1
		if(eB1) begin
		EN <= CLK;
		end
	end
	else if (EN == CLK) begin
		if (c1 == 100000000 && dB1) begin
			EN <= ADJ;
		end
		else if (c2 == 100000000 && dB2) begin
			EN <= STOP; 
		end
	end
end

always @ (posedge clk or posedge RESET) begin 
	if (RESET) begin 
		dispSEL <= 4'b1000; 
	end
	else if(EN == CLK) begin
		if(dB1) begin
			dispSEL <= 4'b0100;
		end
		else begin
			dispSEL <= 4'b1000;
		end
	end
	else if(EN == ADJ) begin
		dispSEL <= 4'b0010;
	end
	else if(EN == STOP) begin
		dispSEL <= 4'b0001;
	end
end
//END NEW

endmodule
