`timescale 1ns / 1ps

module fifo_tb();
parameter FIFO_DEPTH = 8;
parameter DATA_WIDTH = 32;

reg clk;
reg rst;
reg cs;
reg wr_en;
reg rd_en;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out;
wire empty;
wire full;


FIFO_Sync #(
    .fifo_depth(FIFO_DEPTH),
    .data_width(DATA_WIDTH)
) DUT (
    .clk(clk),
    .rst(rst),
    .cs(cs),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),
    .data_out(data_out),
    .empty(empty),
    .full(full)
);
always #5 clk = ~clk;
integer i;
task write_data(input [DATA_WIDTH-1:0] din);
begin
@(posedge clk);
if (!full) begin
cs = 1;
wr_en = 1;
rd_en = 0;
data_in = din;
$display("%0t WRITE %0d", $time, din);
end
end
endtask

task read_data;
begin
@(posedge clk);
if (!empty) begin
cs = 1;
wr_en = 0;
rd_en = 1;
$display("%0t READ %0d", $time, data_out);
end
end
endtask

initial begin
clk = 0;
rst = 0;       
cs = 0;
wr_en = 0;
rd_en = 0;
#10;
@(posedge clk);
rst = 1;       
write_data(5);
write_data(10);
write_data(100);
read_data();
read_data();
read_data();
$display($time);
for(i = 0; i < FIFO_DEPTH; i = i + 1) begin
write_data(2**i);
read_data();
end
$display($time, "\n SCENARIO 3");
for(i = 0; i < FIFO_DEPTH; i = i + 1)
write_data(2**i);
for(i = 0; i < FIFO_DEPTH; i = i + 1)
read_data();
#40 
$finish;
end
initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
end

endmodule