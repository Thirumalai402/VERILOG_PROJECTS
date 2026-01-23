`timescale 1ns / 1ps

module Uart_main(
    input        clk,
    input        rst,
    input  [7:0] data_in,
    input        wr_en,
    input        rdy_clr,
    output       rdy,
    output       busy,
    output [7:0] data_out
    );

wire rx_clk_en;   
wire tx_clk_en;   
wire tx_temp;     
baud_rate_generator bg(.clk(clk),.tx_en(tx_clk_en),.rx_en(rx_clk_en));

Transmitter TX(.clk(clk),.rst(rst),.wr_en(wr_en),.en(tx_clk_en)
,.data_input(data_in),.tx(tx_wire),.busy(busy));

receiver RX(.clk(clk),.clk_en(rx_clk_en),.rst(rst),.rx(tx_wire),.rdy_clr(rdy_clr),.rdy(rdy),
.data_out(data_out));

endmodule
