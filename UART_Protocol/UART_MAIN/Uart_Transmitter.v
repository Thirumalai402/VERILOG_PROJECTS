`timescale 1ns / 1ps

module Transmitter(
    input clk,rst,wr_en,en,
    input [7:0] data_input,
    output reg tx,
    output busy
    );
parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

reg [1:0] state;
reg [7:0] data_reg;
reg [2:0] bit_index;
         

assign busy = (state!= IDLE);

always @(posedge clk) begin

    if (rst) begin
        state <= IDLE;
        tx <= 1'b1;
        bit_index <= 0;
        data_reg <= 0;
    end

    else begin
        case(state)
		   IDLE: begin
            tx <= 1'b1;
            if (wr_en) begin
                data_reg <= data_input;
                bit_index <= 0;
                state <= START;
            end
        end
		  START: begin
            if (en) begin
                tx <= 1'b0;
                state <= DATA;
            end
        end
		   DATA: begin
            if (en) begin
                tx <= data_reg[bit_index];
                if (bit_index == 3'h7)
                    state <= STOP;
                else
                    bit_index <= bit_index + 1;
            end
        end
 STOP: begin
            if (en) begin
                tx <= 1'b1;
                state <= IDLE;
            end
        end

        endcase
    end
end

endmodule

