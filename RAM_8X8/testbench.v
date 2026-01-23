`timescale 1ns / 1ps

module ram_tb();
reg clk,rst,w_enable;
reg[2:0] w_addr,r_addr;
reg[7:0] data;
wire [7:0] data_out;

ram dut (.clk(clk),.rst(rst),.w_enable(w_enable),.w_addr(w_addr),.r_addr(r_addr),.data(data),.data_out(data_out));
always #5 clk = ~clk;
initial 
begin
clk = 0;
rst = 1;
w_enable = 0;
w_addr = 0;
r_addr = 0;
data = 0;
#20
rst = 0;
w_enable = 1;
w_addr = 3'b010;
data = 8'd10;
#20
w_enable = 1;
w_addr = 3'b110;
data = 8'd5;
#20
w_enable = 0;
r_addr = 3'b010;
#20
r_addr = 3'b110;
#20;
$finish;
end
endmodule
