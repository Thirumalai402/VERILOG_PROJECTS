`timescale 1ns / 1ps

module ahb_multiplexer( 
input [1:0] select, 
input [31:0] hrdata1, 
input [31:0] hrdata2, 
input [31:0] hrdata3, 
input [31:0] hrdata4, 
input hreadyout1, 
input hreadyout2, 
input hreadyout3, 
input hreadyout4, 
input hresp1, 
input hresp2, 
input hresp3, 
input hresp4, 
output reg [31:0] hrdata, 
output reg hreadyout, 
output reg hresp ); 

always @(*) begin 
case(select) 
2'b00: begin 
hrdata = hrdata1; 
hreadyout = hreadyout1; 
hresp = hresp1; 
end 

2'b01: begin 
hrdata = hrdata2; 
hreadyout = hreadyout2; 
hresp = hresp2; 
end 

2'b10: begin 
hrdata = hrdata3; 
hreadyout = hreadyout3; 
hresp = hresp3; 
end 

2'b11: begin 
hrdata = hrdata4; 
hreadyout = hreadyout4; 
hresp = hresp4; 
end 

default : begin 
hrdata = 32'b0; 
hreadyout = 1'b1; 
hresp = 1'b0; 
end 
endcase 
end 

endmodule