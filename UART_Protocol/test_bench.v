`timescale 1ns / 1ps

module uart;

// Inputs
reg clk;
reg rst;
reg [7:0] data_in;
reg wr_en;
reg rdy_clr;

// Outputs
wire rdy;
wire busy;
wire [7:0] data_out;

// Instantiate the Unit Under Test (UUT)
Uart_main uut (
		.clk(clk), 
		.rst(rst), 
		.data_in(data_in), 
		.wr_en(wr_en), 
		.rdy_clr(rdy_clr), 
		.rdy(rdy), 
		.busy(busy), 
		.data_out(data_out)
);
always #10 clk = ~clk;
initial begin
// Initialize Inputs
clk = 0;
        rst = 1;
        wr_en = 0;
        rdy_clr = 0;
        data_in = 8'h00;

        // Apply reset
        #50;
        rst = 0;
		   // Wait stable
        #100;

        data_in = 8'hA5;
        wr_en = 1;     
        #20;
        wr_en = 0;
        wait(busy == 1);
        wait(busy == 0);
        wait(rdy == 1);
        $display("Time=%0t | Received Byte = %h", $time, data_out);
        rdy_clr = 1;
        #20;
        rdy_clr = 0;

        #200;
		   $finish;

	end
      
endmodule

