`timescale 1ns / 1ps

module ALU_31;

// Inputs
reg [31:0] a;
reg [31:0] b;
reg [3:0] op_code;

// Outputs
wire [31:0] out;

// Instantiate the Unit Under Test (UUT)
ALU_32bit uut (
		.a(a), 
		.b(b), 
		.op_code(op_code), 
		.out(out)
);

initial begin
$monitor("Time=%0t  a=%h  b=%h  op_code=%b  out=%h",$time, a, b,op_code, out);
a = 32'h00000014;   
b= 32'h00000014;   
op_code = 4'b0000; 
#10;
op_code= 4'b0001; 
#10;
op_code= 4'b0010; 
#10;
op_code = 4'b0011;
 #10;
op_code= 4'b0100; 
#10;
op_code= 4'b0101; 
#10;
op_code = 4'b0110; 
#10;
op_code= 4'b0111; 
#10;
op_code = 4'b1000; 
#10;
op_code = 4'b1001; 
#10;
op_code= 4'b1010; 
#10;
op_code= 4'b1011; 
#10;
op_code= 4'b1100;
#10;
op_code = 4'b1101; 
#10;
op_code = 4'b1110; 
#10;
op_code = 4'b1111; 
#10;
#20;
end   
endmodule

