// file: mux.v
// author: @habibagamal

`timescale 1ns/1ns

module mux(a, b, c, d, out, sel);
parameter n=4;

output reg [n-1:0] out;

input [n-1:0] a, b, c, d;

input [3:0] sel;

always @ (*) begin
	case (sel)
		4'b0001: out <= d;
		4'b0010: out <= c;
		4'b0100: out <= b;
		4'b1000: out <= a;
		default: out <= {n{1'b0}};
	endcase
end
endmodule
