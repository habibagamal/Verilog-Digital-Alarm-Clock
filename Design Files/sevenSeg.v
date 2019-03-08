// file: sevenSeg.v
// author: @habibagamal

`timescale 1ns/1ns

module sevenSeg(In, en, Y);
input [3:0] In;
input en;
output reg[6:0] Y;
always @(In or en) begin
    if(en) begin
        case(In)
            4'd0: Y=7'b0000001;
            4'd1: Y=7'b1001111;
            4'd2: Y=7'b0010010;
            4'd3: Y=7'b0000110;
            4'd4: Y=7'b1001100;
            4'd5: Y=7'b0100100;
            4'd6: Y=7'b0100000;
            4'd7: Y=7'b0001111;
            4'd8: Y=7'b0000000;
            4'd9: Y=7'b0000100;
            default: Y=7'b1111111;
        endcase
    end
        else
            Y = 7'b1111111;
end
endmodule
