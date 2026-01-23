`timescale 1ns / 1ps

module modn_tb();
reg clk;
reg rst;
reg enable;
reg [1:0] select;
wire [3:0] count;

mod_n dut (.clk(clk),.rst(rst),.enable(enable),.select(select),.count(count));
always #5 clk = ~clk;

initial begin
clk = 0;
rst = 1;
enable = 0;
select = 2'b00;
#10 rst = 0;
 enable = 1;

//mod_3
select = 2'b00;
#60;

// mod_5
select = 2'b01;
#100;

//mod_7
select = 2'b10;
#140;

//mod_9
 select = 2'b11;
#180;
enable = 0;
#20 $finish;
end
endmodule