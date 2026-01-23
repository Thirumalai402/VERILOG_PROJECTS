`timescale 1ns / 1ps

module ram(
input clk,rst,write_en,chip_select,out_en,
input [2:0] addr,
inout [7:0]data 
);
reg [7:0] mem [0:7];
reg [7:0] temp_data;
reg [7:0] decoder_out;
integer m;
//decoder_logic
always @(*) begin
decoder_out = 8'b0000_0000;
if (chip_select)
decoder_out[addr] = 1'b1;
end

//RAM_logic
always @(posedge clk) begin
if (rst) begin
for (m = 0; m < 8; m=m + 1)
mem[m] <= 8'd0;
end
else if (chip_select && write_en) begin 
for (m = 0; m < 8; m=m + 1)
if (decoder_out[m])
mem[m] <= data;
end
end

always @(*) begin
temp_data = 8'd0;
if (chip_select && out_en) begin
for (m = 0; m < 8; m=m + 1)
if (decoder_out[m])
temp_data = mem[m];
end
end
assign data = (chip_select && out_en && !write_en) ? temp_data : 8'bz;
endmodule
