`timescale 1ns / 1ps
module ram_tb();
reg clk;
reg rst;
reg write_en;
reg chip_select;
reg out_en;
reg [2:0] addr;
reg [7:0] data_in;
wire [7:0] data;

// Bidirectional_data_bus
assign data = (write_en && chip_select) ? data_in : 8'bz;
ram dut (.clk(clk),.rst(rst),.write_en(write_en),.chip_select(chip_select),.out_en(out_en),.addr(addr),.data(data));
always #5 clk = ~clk;

initial begin
clk = 0;
rst = 1;
write_en = 0;
chip_select = 0;
out_en = 0;
addr = 3'b000;
data_in = 8'h00;
#10 
rst = 0;

chip_select = 1;
write_en = 1;
out_en = 0;
addr = 3'd0; data_in = 8'h11; 
#10;
addr = 3'd1; data_in = 8'haa; 
#10;
addr = 3'd2; data_in = 8'h03; 
#10;
addr = 3'd3; data_in = 8'h50; 
#10;
addr = 3'd4; data_in = 8'h55; 
#10;
addr = 3'd5; data_in = 8'h86; 
#10;

write_en = 0;
out_en = 1;
addr = 3'd0; 
#10;
addr = 3'd1; 
#10;
addr = 3'd2; 
#10;
addr = 3'd3; 
#10;
addr = 3'd4; 
#10;
addr = 3'd5; 
#10;

chip_select = 0;
out_en = 0;
#20 $finish;
end
endmodule

