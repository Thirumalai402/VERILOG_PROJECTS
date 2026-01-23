`timescale 1ns / 1ps

module ahb_to_apb_bridge(
input hclk,hreset,hselapb,hwrite,
input [1:0] htrans, 
input[31:0] haddr,
input[31:0] hwdata,
input[31:0] prdata,
output reg [31:0] paddr,pwdata,
output reg psel,penable,pwrite,hresp,hready,
output reg [31:0] hrdata
 );
 
 reg[31:0]  haddr_temp,hwdata_temp;
 reg[2:0] present_state, next_state;
 reg valid,hwrite_temp;
 
 parameter idle = 3'b000;
 parameter read = 3'b001;
 parameter wwait = 3'b010;
 parameter write = 3'b011;
 parameter write_p = 3'b100;
 parameter wenable = 3'b110;
 parameter wenable_p = 3'b101;
 parameter renable = 3'b111;
 
 always @(posedge hclk) begin
 if (!hreset)
 valid <= 1'b0;
 else
 valid <= hselapb && (htrans == 2'b10 || htrans == 2'b11);
 end
 
  always @(posedge hclk) begin
  if (!hreset)
  present_state <= idle;
  else
  present_state <= next_state;
  end

 always @(posedge hclk) begin
 if (!hreset) begin
 haddr_temp <= 32'b0;
 hwdata_temp <= 32'b0;
 hwrite_temp <= 1'b0;
 end 
 else if (valid) begin
 haddr_temp <= haddr;
 hwdata_temp <= hwdata;
 hwrite_temp <= hwrite;
 end
 end
    
    
 always @(*) begin
 psel = 1'b0;
 penable = 1'b0;
 pwrite  = 1'b0;
 paddr   = 32'b0;
 pwdata  = 32'b0;
 hready  = 1'b1;
 hresp   = 1'b0;   
 hrdata  = 32'b0;
 next_state = present_state;
        
        
 case(present_state)
 
 idle:begin
 psel =1'b0;
 penable = 1'b0;
 hready = 1'b1;
 if(valid == 1'b0)
 next_state = idle;
 else if (valid == 1'b1 && hwrite == 1'b0)
 next_state = read;
 else if(valid == 1'b1 && hwrite == 1'b1)
 next_state = wwait;
 end
 
 read : begin
 psel =1'b1;
 paddr = haddr;
 pwrite = 1'b0;
 penable = 1'b0;
 hready = 1'b0;
 next_state = renable;
 end
 
 renable : begin
 psel    = 1'b1;
 penable = 1'b1;
 hready  = 1'b1;
 hrdata  = prdata;
 if(valid == 1'b0)
 next_state = idle;
 else if (valid == 1'b1 && hwrite == 1'b0)
 next_state = read;
 else if(valid == 1'b1 && hwrite == 1'b1)
 next_state = wwait;
 end
 
 wwait : begin
 hready = 1'b0;
 if(valid == 1'b0)
 next_state = write;
 else if(valid == 1'b1)
 next_state = write_p;
 end
 
 write : begin
 psel = 1'b1;
 paddr = haddr_temp;
 pwdata = hwdata;
 pwrite = 1'b1;
 penable = 1'b0;
 hready = 1'b0;
 if(valid == 1'b0)
 next_state = wenable;
 else if(valid == 1'b1)
 next_state = wenable_p;
 end
 
 write_p: begin
 psel = 1'b1;
 paddr = haddr_temp;
 pwdata = hwdata_temp;
 pwrite = 1'b1;
 hready = 1'b0;
 next_state = wenable_p;
 end
 
 wenable : begin
 psel = 1'b1;
 penable = 1'b1;
 pwrite = 1'b1;
 hready = 1'b1;
 if(valid == 1'b1 && hwrite == 1'b1)
 next_state = wwait; 
 else if(valid == 1'b1 && hwrite == 1'b0)
 next_state = read;
 else if(valid == 1'b0)
 next_state = idle;
 end
 
 wenable_p : begin
 psel    = 1'b1;
 penable = 1'b1;
 pwrite  = 1'b1;
 hready  = 1'b1;
 if(valid == 1'b0 && hwrite == 1'b1 )
 next_state = write;
 else if(valid == 1'b1 && hwrite == 1'b1)
 next_state = write_p;
 else if(valid == 1'b0)
 next_state = read;
 end
 default: next_state = idle;
 endcase
 end
 
endmodule
