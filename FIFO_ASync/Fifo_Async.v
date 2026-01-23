`timescale 1ns / 1ps

module fifo_async
#(
parameter DATA_WIDTH = 8,
parameter DEPTH = 16
)
(
input  wr_clk,
input  rd_clk,
input  rst,
input  wr_en,
input  rd_en,
input  [DATA_WIDTH-1:0] din,
output [DATA_WIDTH-1:0] dout,
output full,
output empty
);

localparam ADDR_WIDTH = $clog2(DEPTH);
reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
reg [ADDR_WIDTH:0] wr_ptr_bin, wr_ptr_gray;
reg [ADDR_WIDTH:0] rd_ptr_bin, rd_ptr_gray;
reg [ADDR_WIDTH:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;
reg [ADDR_WIDTH:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;


always @(posedge wr_clk or posedge rst) begin
if (rst) begin
wr_ptr_bin  <= 0;
wr_ptr_gray <= 0;
end else begin
if (wr_en && !full) begin
mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= din;
wr_ptr_bin <= wr_ptr_bin + 1;
wr_ptr_gray <= (wr_ptr_bin + 1) ^ ((wr_ptr_bin + 1) >> 1);
end
end
end
reg [DATA_WIDTH-1:0] dout_reg;
assign dout = dout_reg;

always @(posedge rd_clk or posedge rst) begin
if (rst) begin
rd_ptr_bin  <= 0;
rd_ptr_gray <= 0;
dout_reg <= 0;
end 
else begin
if (rd_en && !empty) begin
dout_reg <= mem[rd_ptr_bin[ADDR_WIDTH-1:0]];
rd_ptr_bin <= rd_ptr_bin + 1;
rd_ptr_gray <= (rd_ptr_bin + 1) ^ ((rd_ptr_bin + 1) >> 1);
end
end
end


always @(posedge wr_clk or posedge rst) begin
if (rst) begin
rd_ptr_gray_sync1 <= 0;
rd_ptr_gray_sync2 <= 0;
end 
else begin
rd_ptr_gray_sync1 <= rd_ptr_gray;
rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
end
end

always @(posedge rd_clk or posedge rst) begin
if (rst) begin
wr_ptr_gray_sync1 <= 0;
wr_ptr_gray_sync2 <= 0;
end 
else begin
wr_ptr_gray_sync1 <= wr_ptr_gray;
wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
end
end

assign full  = (wr_ptr_gray == {~rd_ptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1],rd_ptr_gray_sync2[ADDR_WIDTH-2:0]});
assign empty = (rd_ptr_gray == wr_ptr_gray_sync2);

endmodule