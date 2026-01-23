`timescale 1ns / 1ps

module ahb_top_tb;

reg hclk;
reg hreset;
reg enable;
reg [31:0] data_a;
reg [31:0] data_b;
reg [31:0] addr;
reg write;
reg [1:0] slave_select;

wire [31:0] data_out;
wire [31:0] hwdata;
wire [31:0] hrdata;
wire hreadyout;

ahb_top dut (
    .hclk(hclk),
    .hreset(hreset),
    .enable(enable),
    .data_a(data_a),
    .data_b(data_b),
    .addr(addr),
    .write(write),
    .slave_select(slave_select),
    .data_out(data_out),
    .hwdata(hwdata),
    .hrdata(hrdata),
    .hreadyout(hreadyout)
  );

always #5 hclk = ~hclk;

// Reset task
task reset_dut;
begin
hreset = 0;
enable = 0;
write  = 0;
slave_select = 0;
data_a = 0;
data_b = 0;
addr   = 0;
#20;
hreset = 1;
end
endtask

// Write task 
task ahb_write(input [1:0] sel,input [31:0] address,input [31:0] da,input [31:0] db);
begin
 @(negedge hclk);
slave_select = sel;
addr = address;
data_a = da;
data_b = db;
write = 1'b1;
enable = 1'b1;

// Hold for 3 cycles 
@(negedge hclk);
@(negedge hclk);
@(negedge hclk);
$display("TIME=%0t, WRITE to SLAVE %0d @ %h, hwdata=%h",$time, sel, address, hwdata);

enable = 1'b0;
write  = 1'b0;
end
endtask

// Read task 
task ahb_read(input [1:0] sel,input [31:0] address);
begin
@(negedge hclk);
slave_select = sel;
addr = address;
write = 1'b0;
enable = 1'b1;

// Hold for 3 cycles
@(negedge hclk);
@(negedge hclk);
@(negedge hclk);
enable = 1'b0;
wait(hreadyout == 1'b1);
@(posedge hclk);
$display("TIME=%0t, READ from SLAVE %0d @ %h, hrdata=%h, data_out=%h", $time, sel, address, hrdata, data_out);
end
endtask

// Main test sequences
initial begin
hclk = 0;
 reset_dut();

// Slave 0
ahb_write(2'b00, 32'h0000_0010, 32'h00000005, 32'h00000003); // expect 8
ahb_read (2'b00, 32'h0000_0010);

// Slave 1
ahb_write(2'b01, 32'h0000_0020, 32'h0000000A, 32'h00000002); // expect 12
ahb_read (2'b01, 32'h0000_0020);

// Slave 2
ahb_write(2'b10, 32'h0000_0030, 32'h0000000F, 32'h00000001); // expect 16
ahb_read (2'b10, 32'h0000_0030);

// Slave 3
ahb_write(2'b11, 32'h0000_0040, 32'h0000000D, 32'h00000009); // expect 22
ahb_read (2'b11, 32'h0000_0040);
#50;
$finish;
end

endmodule
