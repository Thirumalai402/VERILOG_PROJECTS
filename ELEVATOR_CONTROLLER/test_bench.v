`timescale 1ns / 1ps

module ElevatorController_tb();
reg clk;
reg rst;
reg emergency_stop;
reg [4:0] floor_request;
wire motor_stop;
wire [2:0] current_floor;

Elevator dut (.clk(clk),.rst(rst),.emergency_stop(emergency_stop),.floor_request(floor_request),.motor_stop(motor_stop),.current_floor(current_floor));
always #5 clk = ~clk;

initial begin
clk = 0;
rst = 1;
emergency_stop = 0;
floor_request = 5'b00000;
#20;
rst = 0;
#10;
//floor_3
floor_request = 5'b01000;
#100;

//floor_1
floor_request = 5'b00010;
#100;
//emergency_stop
emergency_stop = 1;
#50;
emergency_stop = 0;
#50;
//floor_4
floor_request = 5'b10000;  
#150;
$stop;
end
endmodule
