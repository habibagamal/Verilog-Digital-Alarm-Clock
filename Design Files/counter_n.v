// file: counter_n.v
// author: @habibagamal

`timescale 1ns/1ns

module counter_n(q, clk, rst, en, ud, inc, ld, x);
parameter n = 4;
parameter m = 10;
parameter rstV = {n{1'b0}};

input clk, rst, en, ud, inc, ld;
input [n-1:0] x;

output reg [n-1:0] q;

always @ (posedge clk or posedge rst or posedge ld) begin
	if (ld) begin
			q <= x;
	end
	else if (rst) begin
		q <= rstV;
	end
	else if (en) begin
		 if(ud) begin
			if(q == 0 || q > m-1) begin
				q <= m-1;
			end
			else begin
				q <= q - {{n-1{1'b0}},1'b1} - inc;
			end
		end
		else if (q >= m-1 || (q <= m-2 && inc)) begin
			q <= {n{1'b0}};
		end
		else begin
			q <= q + {{n-1{1'b0}}, 1'b1} + inc;
		end
	end
end
endmodule
