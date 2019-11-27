`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2019 13:30:57
// Design Name: 
// Module Name: test
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


module test();

wire [11:0] pix_r;
wire [11:0] pix_g;
wire [11:0] pix_b;
reg clk;
wire hsync;
wire vsync;
wire[10:0] testvalue;
wire [20:0 ] hcount;
wire [20:0] vcount;
vga_out vga(.clk(clk),.pix_r(pix_r),.pix_g(pix_g),.pix_b(pix_b),.hsync(hsync),.testvalue(testvalue),.vsync(vsync),.hcount(hcount),.vcount(vcount));

initial clk = 0;
always #1 clk = ~clk;

endmodule
