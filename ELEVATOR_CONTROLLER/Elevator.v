`timescale 1ns / 1ps

module Elevator(
input clk,rst,emergency_stop,
input[4:0] floor_request,
output reg motor_stop,
output reg [2:0] current_floor
 );
parameter idle = 2'b00;
parameter move_up = 2'b01;
parameter move_down = 2'b10;
parameter emergency = 2'b11;

reg[1:0] present_state,nxt_state;
reg[2:0] target_floor;

always @(*) begin
target_floor = current_floor;
if(floor_request[0])
target_floor = 3'd0;
else if(floor_request[1])
target_floor = 3'd1;
else if(floor_request[2])
target_floor = 3'd2;
else if(floor_request[3])
target_floor = 3'd3;
else if (floor_request[4])
target_floor = 3'd4;
end
 
 always @(posedge clk) begin
 if(rst)
 present_state <= idle;
 else
 present_state <= nxt_state;
 end
 
 always @(posedge clk or posedge rst) begin
 if(rst)
 current_floor <= 3'd0;
 else if (present_state == move_up)
 current_floor <= current_floor + 1'b1;
 else if (present_state == move_down)
 current_floor <= current_floor - 1'b1;
 end
 
 always @(*) begin
 nxt_state = present_state;
 if(emergency_stop)
 nxt_state = emergency;
 else
 begin
 case(present_state)
 idle: begin
 if(target_floor > current_floor)
 nxt_state = move_up;
 else if(target_floor < current_floor)
 nxt_state = move_down;
 end
 
 move_up: begin
 if(current_floor == target_floor)
 nxt_state = idle;
 else
 nxt_state = move_up;
 end
 
 move_down: begin
 if(current_floor == target_floor)
 nxt_state = idle;
 else
 nxt_state = move_down;
 end
 
 emergency: begin
 if(!emergency_stop)
 nxt_state = idle;
 else
 nxt_state = emergency;
 end
 default: nxt_state = idle;
 endcase
 end
 end
 
 always@(*) begin
 motor_stop = 1'b0;
 case(present_state)
 idle: motor_stop = 1'b1;
 emergency: motor_stop = 1'b1;
 default: motor_stop = 1'b0;
 endcase
 end
 
endmodule
