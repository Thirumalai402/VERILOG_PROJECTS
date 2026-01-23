`timescale 1ns / 1ps

module receiver(
    input clk,clk_en,rst,rx,rdy_clr,
    output reg rdy,
    output reg [7:0] data_out
    );

parameter START = 2'b00;
parameter DATA  = 2'b01;
parameter STOP  = 2'b10;

reg [1:0] state = START;
reg [3:0] sample = 0;
reg [2:0] index = 0;
reg [7:0] temp_register = 8'b0;

always @(posedge clk) begin
if (rst) begin
rdy <= 0;
data_out <= 0;
state <= START;
sample <= 0;
index <= 0;
temp_register <= 0;
end 
else begin
if (rdy_clr)
rdy <= 0;
if (clk_en) begin

case (state)
START: begin
if (rx == 0)
sample <= sample + 1;
else
sample <= 0;
if (sample == 15) begin
state <= DATA;
sample <= 0;
index <= 0;
end
end

DATA: begin
sample <= sample + 1;
if (sample == 8) begin
                    temp_register[index] <= rx;
                    index <= index + 1;
                end
					  if (index == 8 && sample == 15) begin
                    state <= STOP;
                    sample <= 0;
                end
            end
				 STOP: begin
                sample <= sample + 1;

                if (sample == 15) begin
                    data_out <= temp_register;
                    rdy <= 1'b1;
                    state <= START;
                    sample <= 0;
                end
            end

            default: state <= START;

 endcase
        end
    end
end

endmodule