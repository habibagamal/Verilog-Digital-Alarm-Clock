`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:36:53 12/10/2017 
// Design Name: 
// Module Name:    Melody 
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
module Melody(clk, speaker, enIN);

input clk, enIN; 
output reg speaker;

reg [30:0] tone;
always @ (posedge clk) tone <= tone+1;

wire [7:0] fullnote;
melodyROM rom(.clk(clk), .address(tone[26:22]), .note(fullnote));

wire [2:0] octave;
wire [3:0] note;
div_12 div12(.numerator(fullnote[5:0]), .quotient(octave), .remainder(note));

reg [8:0] clkdivider;
always @(*)
case(note)
  0: clkdivider = 9'd511; // A 
  1: clkdivider = 9'd482; // A#/Bb
  2: clkdivider = 9'd455; // B 
  3: clkdivider = 9'd430; // C 
  4: clkdivider = 9'd405; // C#/Db
  5: clkdivider = 9'd383; // D 
  6: clkdivider = 9'd361; // D#/Eb
  7: clkdivider = 9'd341; // E 
  8: clkdivider = 9'd322; // F 
  9: clkdivider = 9'd303; // F#/Gb
 10: clkdivider = 9'd286; // G 
 11: clkdivider = 9'd270; // G#/Ab
 default: clkdivider = 9'd0;
endcase

reg [8:0] counter_note;
always @(posedge clk) begin
	if(counter_note == 0) begin
	counter_note <= clkdivider;
	end
	else begin
	counter_note <= counter_note-1;
	end
end

reg [7:0] counter_octave;
always @(posedge clk) begin
	if(counter_note == 0) begin
		if(counter_octave == 0) begin
			counter_octave <= (octave == 0 ? 255 :
									 octave == 1 ? 127 :
									 octave == 2 ? 63  :
									 octave == 3 ? 31  :
									 octave == 4 ? 15  : 7);
		end
		else begin
			counter_octave <= counter_octave-1;
		end
	end
end

always @(posedge clk) begin
	if (!enIN) begin 
		speaker <= 0; 
	end 
	if(counter_note == 0
		&& counter_octave == 0
		&& fullnote != 0
		&& tone[21:8] != 0
		&& enIN) begin
			speaker <= ~speaker;
	end
end
endmodule
