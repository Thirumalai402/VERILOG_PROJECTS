`timescale 1ns / 1ps 

module ahb_decoder( 
input [1:0] select, 
output reg hsel0, 
output reg hsel1, 
output reg hsel2, 
output reg hsel3 
); 

always@(*) begin 
case(select) 
2'b00: begin 
hsel0 = 1'b1; 
hsel1 = 1'b0; 
hsel2 = 1'b0; 
hsel3 = 1'b0; 
end 

2'b01: begin 
hsel0 = 1'b0; 
hsel1 = 1'b1; 
hsel2 = 1'b0; 
hsel3 = 1'b0; 
end 

2'b10: begin 
hsel0 = 1'b0; 
hsel1 = 1'b0; 
hsel2 = 1'b1; 
hsel3 = 1'b0; 
end 

2'b11:begin 
hsel0 = 1'b0; 
hsel1 = 1'b0; 
hsel2 = 1'b0; 
hsel3 = 1'b1; 
end 

default : begin 
hsel0 = 1'b0; 
hsel1 = 1'b0; 
hsel2 = 1'b0; 
hsel3 = 1'b0; 
end 
endcase 
end 

endmodule