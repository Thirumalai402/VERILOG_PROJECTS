`timescale 1ns / 1ps

module fifo_tb();
parameter DATA_WIDTH = 8;
parameter DEPTH = 16;
reg wr_clk, rd_clk;
reg rst;
reg wr_en, rd_en;
reg [DATA_WIDTH-1:0] din;
wire [DATA_WIDTH-1:0] dout;
wire full, empty;

fifo_async #(.DATA_WIDTH(DATA_WIDTH),.DEPTH(DEPTH)) 
DUT (.wr_clk(wr_clk),.rd_clk(rd_clk),.rst(rst),.wr_en(wr_en),.rd_en(rd_en),.din(din),.dout(dout),.full(full),.empty(empty));
always #5 wr_clk = ~wr_clk;
always #7 rd_clk = ~rd_clk;

task write_data(input [DATA_WIDTH-1:0] val);
begin
@(posedge wr_clk);
if (!full) begin
wr_en = 1;
din = val;
$display( $time, val);
end
else begin
wr_en = 0;
$display("%0t FIFO_FULL", $time);
end
end
endtask

task read_data;
begin
@(posedge rd_clk);
if (!empty) begin
rd_en = 1;
$display("%0t READ %0d", $time, dout);
end
else begin
rd_en = 0;
$display("%0t FIFO_EMPTY", $time);
end
end
endtask

integer i;

initial begin
wr_clk = 0;
rd_clk = 0;
rst = 1;
wr_en = 0;
rd_en = 0;
din = 0;
$display("RESET FIFO ");
#20 rst = 0;

write_data(10);
write_data(20);
write_data(30);
read_data();
read_data();
read_data();

$display("FILL FIFO UNTIL FULL ");
for (i = 0; i < DEPTH+2; i = i + 1)
write_data(i);

$display("READ UNTIL EMPTY ");
for (i = 0; i < DEPTH+2; i = i + 1)
read_data();

$display("RANDOM READ/WRITE ");
for (i = 0; i < 20; i = i + 1) begin
if ($random % 2)
write_data($random % 256);
else
read_data();
end
#100 $finish;
end
initial begin
$dumpfile("async_fifo_tb.vcd");
$dumpvars;
end
endmodule