`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.11.2019 17:15:45
// Design Name: 
// Module Name: Acce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Acce(
    input [13:0] acc_x,
    output left_key,
    output right_key
    );
    assign left_key = (acc_x<14'b000011111111)? 1:0;
        assign right_key = (acc_x>14'b000011111111)? 1:0;
endmodule
