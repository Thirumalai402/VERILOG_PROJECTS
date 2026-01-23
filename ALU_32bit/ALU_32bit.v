`timescale 1ns / 1ps

module ALU_32bit(
    input [31:0] a,
    input [31:0] b,
    input [3:0] op_code,
    output reg [31:0] out
    );
always @(*) begin

case(op_code)
4'b0000 : out = a+b;
4'b0001 : out = a-b;
4'b0010 : out = ~(a|b);
4'b0011 : out = a/b;
4'b0100 : out = a%b;
4'b0101 : out = a>>1;
4'b0110 : out = a<<1;
4'b0111 : out= {a[30:0],a[1]};
4'b1000 : out = {a[0], a[31:1]};
4'b1001 : out = a & b;
4'b1010 : out = a|b;
4'b1011 : out = a^b;
4'b1100 :out = ~(a^b);
4'b1101 : out = ~(a&b);
4'b1110: out = (a>b) ? 32'd1 :32'd0;
4'b1111 : out = (a<b) ? 32'd1 : 32'd0;

default : out = 32'hxxxx_xxxx;
endcase
end 

endmodule
