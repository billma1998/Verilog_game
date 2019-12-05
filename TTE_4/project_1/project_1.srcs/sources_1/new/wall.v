`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.12.2019 18:06:56
// Design Name: 
// Module Name: wall
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


module wall(
input wire CLK,
input wire [9:0] x, 
input wire [8:0] y,
output wire wall_b

    );
    
    
    
            //Size of wall
        reg [8:0] BAR_H   = 9'd10;
        reg [9:0] BAR_W   = 10'd100;
        wire block_x, block_y;
        localparam U_BOUND = 9'd80;
        localparam D_BOUND = 9'd120;
        localparam L_BOUND = 10'd120;
        localparam R_BOUND = 10'd420;
        
        //assign block_x = ((x < R_BOUND) & (x > L_BOUND))?1:0;
        //assign block_y =( (y < U_BOUND) & (y > D_BOUND))?1:0;
      //  assign wall_b = ((block_x ==1) & (block_y == 1))? 0:1;
        assign wall_b = ((x < R_BOUND) & (x > L_BOUND) & (y < U_BOUND) & (y > D_BOUND))? 1:0;
        
endmodule
