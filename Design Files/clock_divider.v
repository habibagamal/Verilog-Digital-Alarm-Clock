// file: clock_divider.v
// author: @habibagamal

`timescale 1ns/1ns
module clock_divider(div,rst,clk);
parameter n=50000000;
parameter k=1;
reg [31:0] counter;
input rst,clk;
output reg div;
always @ (posedge clk or posedge rst) begin
if (rst) begin 
	counter<=32'b0;
	div <= 1'b0;
	end
else if (counter== n/(2*k)) begin
		div<=!div; 
		counter<=32'b0;
		end
	else counter<=counter+1;
end
endmodule