`timescale 1ns / 1ps

module ahb_slave(
input hclk,
input hreset,
input hselect,
input [31:0] haddr,
input [31:0] hwdata,
input hwrite,
input [2:0] hburst,
input hready,
input hmasterclk,
input [1:0] htrans, 

output reg hreadyout,
output reg hresp,
output reg [31:0] hrdata
);

reg [31:0] memory_array [31:0];
reg [4:0] waddr;
reg [4:0] raddr;

reg [1:0] present_state , next_state;
parameter IDLE = 2'b00;
parameter A    = 2'b01;
parameter B    = 2'b10;
parameter C    = 2'b11;

always @(posedge hclk) begin
 if(!hreset)
present_state <= IDLE;
else
present_state <= next_state;
 end

always @(*) begin
next_state = present_state;
case (present_state)
IDLE: 
if (hselect && hready && htrans[1]) 
next_state = A;

A:
if (hwrite && hready) 
next_state = B;
else if (!hwrite && hready) 
next_state = C;
            
B:
if (hselect && hready && htrans[1]) 
next_state = A;
else 
next_state = IDLE;

C:    
if (hselect && hready && htrans[1]) 
next_state = A;
else 
next_state = IDLE;

default: 
next_state = IDLE;
endcase
end

always @(posedge hclk or negedge hreset) begin
if (!hreset) begin
hreadyout <= 1'b0;
hresp  <= 1'b0;
hrdata <= 32'b0;
waddr <= 5'b0;
raddr <= 5'b0;
end 

else 
begin
case (present_state)
IDLE: begin
hreadyout <= 1'b0;
hresp  <= 1'b0;
end

A: begin
hreadyout <= 1'b0;
hresp <= 1'b0;
waddr  <= haddr[6:2]; 
raddr <= haddr[6:2];
end

B: begin
hreadyout <= 1'b1;
hresp <= 1'b0;
memory_array[waddr] <= hwdata;
if (hburst != 3'b000) 
waddr <= waddr + 1'b1;
end

C: begin
hreadyout <= 1'b1;
hresp <= 1'b0;
hrdata <= memory_array[raddr];
if (hburst != 3'b000) 
raddr <= raddr + 1'b1;
end

default: begin
hreadyout <= 1'b0;
hresp     <= 1'b0;
end
endcase
end
end

endmodule
