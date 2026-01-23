module FIFO_Sync
#( parameter fifo_depth =8,
   parameter data_width = 32
   )
(
    input clk,
    input rst,
    input cs,
    input wr_en,
    input rd_en,
    input [data_width-1:0]data_in,
    output reg [data_width-1:0]data_out,
    output empty,
    output full
    );
localparam fifo_depth_log = $clog2(fifo_depth);
reg [data_width-1:0] fifo [0:fifo_depth-1];
reg [fifo_depth_log:0] write_pointer;
reg [fifo_depth_log:0] read_pointer;

always@ (posedge clk or negedge rst)
begin
if(!rst)
write_pointer <= 0;
else if (cs && wr_en && !full)
begin 
fifo[write_pointer[fifo_depth_log-1:0]] <= data_in;
write_pointer <= write_pointer + 1'b1;
end
end

always@ (posedge clk or negedge rst)
begin
if(!rst)
read_pointer <= 0;
else if (cs && rd_en && !empty)
begin
data_out <= fifo[read_pointer [fifo_depth_log-1:0]];
read_pointer <= read_pointer + 1'b1;
end 
end

assign empty = (read_pointer == write_pointer );
assign full = ( read_pointer == {~write_pointer[fifo_depth_log],write_pointer[fifo_depth_log-1:0]});