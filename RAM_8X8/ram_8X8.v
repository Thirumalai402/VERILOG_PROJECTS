`timescale 1ns / 1ps

module ram(
input clk,rst,w_enable,
input[2:0]w_addr,r_addr,
input[7:0] data,
output reg [7:0] data_out
    );
 reg [7:0] mem [7:0];
 integer m;
 always @(posedge clk or posedge rst)
 begin
 if(rst)
 begin
 for(m=0;m<7;m=m+1)
 mem[m]<=0;
 end
 else
 if(w_enable)
 mem[w_addr] <= data;
 else if(w_enable == 0)
 data_out <= mem[r_addr];
 end
endmodule
