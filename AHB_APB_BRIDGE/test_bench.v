`timescale 1ns / 1ps

module bridge_tb();
  reg hclk;
  reg hreset;
  reg hselapb;
  reg hwrite;
  reg [1:0] htrans;
  reg [31:0] haddr;
  reg [31:0] hwdata;
  wire [31:0] paddr;
  wire [31:0] pwdata;
  wire psel;
  wire penable;
  wire pwrite;
  wire hresp;
  wire hready;
  wire [31:0] hrdata;
  reg  [31:0] prdata;

  ahb_to_apb_bridge dut (.hclk(hclk),.hreset(hreset),.hselapb(hselapb),.hwrite(hwrite),.htrans(htrans),.haddr(haddr),.hwdata(hwdata),.prdata(prdata),.paddr(paddr),
  .pwdata(pwdata),.psel(psel),.penable(penable),.pwrite(pwrite),.hresp(hresp),.hready(hready),.hrdata(hrdata));

  always #5 hclk = ~hclk;
  
  initial begin
   hclk = 0;
   hreset = 0;
   hselapb = 0;
   hwrite = 0;
   htrans = 2'b00;
   haddr = 32'b0;
   hwdata = 32'b0;
   prdata = 32'h0000ACAA;
   
   #20;
   hreset = 1;
   @(posedge hclk);
   hselapb = 1;
   hwrite = 1;
   htrans = 2'b10;     
   haddr = 32'h1000_0044;
   hwdata = 32'h1000ABBB;
   wait(hready);
   @(posedge hclk);
   hselapb = 0;
   htrans = 2'b00;
   #20;
   @(posedge hclk);
   hselapb = 1;
   hwrite = 0;
   htrans = 2'b10;      
   haddr = 32'h1000_0004;
   prdata = 32'h000000AA;
   wait(hready);

   @(posedge hclk);
   hselapb = 0;
   htrans  = 2'b00;
   #50;
   $display("READ DATA = %h", hrdata);
   $finish;
   end

endmodule
