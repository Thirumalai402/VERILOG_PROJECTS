`timescale 1ns / 1ps

module mod_n(
input clk,
input rst,
input enable,
input [1:0] select,        
output reg [3:0] count
);
always @(posedge clk)
begin
if(rst)
count <= 4'd0;
else if(enable) begin
case(select)

// mod_3
2'b00: begin
if(count < 2)
count <= count + 1'b1;
else
count <= 4'd0;
end

//mod_5
2'b01: begin
if(count < 4)
count <= count + 1'b1;
else
count <= 4'd0;
end

//mod_7
2'b10: begin
if(count < 6)
count <= count + 1'b1;
else
count <= 4'd0;
end

//mod_9
2'b11: begin
if(count < 8)
count <= count + 1'b1;
else
count <= 4'd0;
end

default: count <= 4'd0;
endcase
end
else
count <= count;
end
endmodule
