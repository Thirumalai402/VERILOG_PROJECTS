`timescale 1ns / 1ps

module ahb_master(
input hclk,
input hreset,
input enable,
input [31:0] data_a,
input [31:0] data_b,
input [31:0] addr,
input write,
input hreadyout,
input hresp,
input [31:0] hrdata,
input [1:0]  slave_select,

output reg [1:0]  select,
output reg [31:0] haddr,
output reg hwrite,
output reg [2:0]  hsize,
output reg [2:0]  hburst,
output reg [3:0]  hprot,
output reg [1:0]  htrans,
output reg hready,
output reg [31:0] hwrite_data,
output reg [31:0] data_out
);

reg [1:0] present_state, next_state;
parameter idle = 2'b00;
parameter A = 2'b01;
parameter B = 2'b10;
parameter C = 2'b11;


always @(posedge hclk) begin
if (!hreset)
present_state <= idle;
else
present_state <= next_state;
end

// Next-state and output logic
always @(*) begin
case (present_state)
idle: begin
select = 2'b00;
haddr = 32'h0000_0000;
hwrite = 1'b0;
hsize = 3'b000;
hburst = 3'b000;
hprot = 4'b0000;
htrans = 2'b00;
hready = 1'b0;
hwrite_data = 32'h0000_0000;
next_state  = (enable) ? A : idle;end

A: begin
select = slave_select;
haddr = addr;
hwrite = write;
hburst = 3'b000;
htrans = 2'b10; 
hready = 1'b1;
hwrite_data = data_a + data_b;
next_state  = (write) ? B : C;
end

B: begin
select = slave_select;
haddr = addr;
hwrite = 1'b1;
htrans = 2'b10;
hwrite_data = data_a + data_b;
next_state  = (enable) ? A : idle;
end

C: begin
select = slave_select;
haddr = addr;
hwrite = 1'b0;
htrans = 2'b10;
next_state  = (enable) ? A : idle;
end

default: next_state = idle;
endcase
end

always @(posedge hclk) begin
if (!hreset)
data_out <= 32'b0;
else if (present_state == C && hreadyout)
data_out <= hrdata;
end

endmodule
