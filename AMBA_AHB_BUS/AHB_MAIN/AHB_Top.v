`timescale 1ns / 1ps

module ahb_top(
input hclk,
input hreset,
input enable,
input [31:0] data_a,
input [31:0] data_b,
input [31:0] addr,
input write,
input [1:0] slave_select,
output [31:0] data_out,
output [31:0] hwdata,     
output [31:0] hrdata,     
output hreadyout   
);

 // Master 
 wire [1:0] select;
 wire [31:0] haddr;
 wire hwrite;
 wire [2:0] hsize;
 wire [2:0] hburst;
 wire [3:0] hprot;
 wire [1:0] htrans;
 wire [31:0] hwrite_data;

 // Slave 
 wire [31:0] hrdata1, hrdata2, hrdata3, hrdata4;
 wire hreadyout1, hreadyout2, hreadyout3, hreadyout4;
 wire hresp1, hresp2, hresp3, hresp4;

 // Decoder 
 wire hsel0, hsel1, hsel2, hsel3;

 // Mux 
 wire [31:0] hrdata_int;
 wire hreadyout_int;
 wire hresp;

 // Master
 ahb_master master (
    .hclk(hclk),
    .hreset(hreset),
    .enable(enable),
    .data_a(data_a),
    .data_b(data_b),
    .addr(addr),
    .write(write),
    .slave_select(slave_select),
    .select(select),
    .haddr(haddr),
    .hwrite(hwrite),
    .hsize(hsize),
    .hburst(hburst),
    .hprot(hprot),
    .htrans(htrans),
    .hready(hreadyout_int),     
    .hwrite_data(hwrite_data),
    .data_out(data_out),
    .hrdata(hrdata_int),
    .hresp(hresp)
 );

 // Decoder
 ahb_decoder decoder (
    .select(select),
    .hsel0(hsel0),
    .hsel1(hsel1),
    .hsel2(hsel2),
    .hsel3(hsel3)
 );

 // Slave1
 ahb_slave slave_1 (
    .hclk(hclk),
    .hreset(hreset),
    .hselect(hsel0),
    .haddr(haddr),
    .hwdata(hwrite_data),
    .hwrite(hwrite),
    .hburst(hburst),
    .hready(1'b1),
    .hmasterclk(hclk),
    .htrans(htrans),
    .hreadyout(hreadyout1),
    .hresp(hresp1),
    .hrdata(hrdata1)
 );

 // Slave2
 ahb_slave slave_2 (
    .hclk(hclk),
    .hreset(hreset),
    .hselect(hsel1),
    .haddr(haddr),
    .hwdata(hwrite_data),
    .hwrite(hwrite),
    .hburst(hburst),
    .hready(1'b1),
    .hmasterclk(hclk),
    .htrans(htrans),
    .hreadyout(hreadyout2),
    .hresp(hresp2),
    .hrdata(hrdata2)
 );

 // Slave3
 ahb_slave slave_3 (
    .hclk(hclk),
    .hreset(hreset),
    .hselect(hsel2),
    .haddr(haddr),
    .hwdata(hwrite_data),
    .hwrite(hwrite),
    .hburst(hburst),
    .hready(1'b1),
    .hmasterclk(hclk),
    .htrans(htrans),
    .hreadyout(hreadyout3),
    .hresp(hresp3),
    .hrdata(hrdata3)
 );

 // Slave4
 ahb_slave slave_4 (
    .hclk(hclk),
    .hreset(hreset),
    .hselect(hsel3),
    .haddr(haddr),
    .hwdata(hwrite_data),
    .hwrite(hwrite),
    .hburst(hburst),
    .hready(1'b1),
    .hmasterclk(hclk),
    .htrans(htrans),
    .hreadyout(hreadyout4),
    .hresp(hresp4),
    .hrdata(hrdata4)
 );

 // Mux
 ahb_multiplexer mux (
    .select(select),
    .hrdata1(hrdata1),
    .hrdata2(hrdata2),
    .hrdata3(hrdata3),
    .hrdata4(hrdata4),
    .hreadyout1(hreadyout1),
    .hreadyout2(hreadyout2),
    .hreadyout3(hreadyout3),
    .hreadyout4(hreadyout4),
    .hresp1(hresp1),
    .hresp2(hresp2),
    .hresp3(hresp3),
    .hresp4(hresp4),
    .hrdata(hrdata_int),
    .hreadyout(hreadyout_int),
    .hresp(hresp)
 );

 assign hwdata = hwrite_data;
 assign hrdata = hrdata_int;
 assign hreadyout = hreadyout_int;

endmodule
