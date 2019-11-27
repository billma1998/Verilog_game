`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2019 14:00:58
// Design Name: 
// Module Name: vga_out
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


module vga_out(
    input clk,
    input rst,
    output reg [3:0] pix_r,
    output reg [3:0] pix_g,
    output reg [3:0] pix_b,
    output  hsync,
    output  vsync

    );
  // reg [10:0] hcount;
  wire pixclk;
  clk_wiz_0 timer(.clk_out1(pixclk),.reset(rst),.clk_in1(clk));
  reg [20:0] curr_x = 0;
  reg [20:0] curr_y = 0;
   reg [20:0] vcount = 0;
   reg [10:0]   testvalue  = 5 ;
   reg [20:0] hcount = 0;
   //reg [   3:0] pix_b = 0;
   always @(posedge pixclk)
   begin
       hcount = hcount + 1;
           if (384< hcount)
           begin
          //    if (hcount < 1823)
//              begin
           curr_x = curr_x +1;
           //   end
           end
       if (hcount == 1903)
       begin
           hcount = 0;
           curr_x = 0;
           curr_y = curr_y + 1;
           vcount = vcount +1;

       end
           if (vcount == 930)
           begin
              vcount = 0;
              curr_y = 0;
           end

//    assign hsync = (hcount > 11'd151 )? 1'd1 :1'd0;
// assign vsync = ( vcount < 10'd3) ? 1'd1 :1'd0; 
//assign pix_r = (11'd384 < hcount <11'd1823) ? ((10'd31< vcount<10'd930) ?  8'd50 : 8'd0):
//                                                ((10'd31< vcount<10'd930) ?  8'd0 : 8'd0);
 
// assign pix_b = (11'd384 < hcount <11'd1823) ? ((10'd31< vcount<10'd930) ?  8'd50 : 8'd0):
//                                                ((10'd31< vcount<10'd930) ?  8'd0 : 8'd0);
  
//  assign pix_g = (11'd384 < hcount <11'd1823) ? ((10'd31< vcount<10'd930) ?  8'd50 : 8'd0):
//                                                ((10'd31< vcount<10'd930) ?  8'd0 : 8'd0);
   //    assign hsync = (hcount > 11'd151 )? 1'd1 :1'd0;
 //assign vsync = ( vcount < 10'd3) ? 1'd1 :1'd0; 
  pix_r = ((384 < hcount)&(hcount <1823)&(31< vcount)&(vcount<930)&(curr_x<820)&(720<curr_x)&(300<curr_y)&(curr_y < 400)) ? 4'b1111 : 0;
 //pix_r = ((curr_x<820)&(720>curr_x)&(300<curr_y)&(curr_y < 400)) ? 4'b1111 : 0;
 // pix_b = ((384 < hcount)&(hcount <1823)&(31< vcount)&(vcount<930)) ? 0 : 0;
                                                 pix_b = ((484 < hcount)&(hcount <1023)&(231< vcount)&(vcount<830)) ? 4'b1111 : 0;
 //  pix_b = ((curr_x<120)&(220>curr_x)&(500<curr_y)&(curr_y < 600)) ? 4'b1111 : 0;
  pix_g = ((384 < hcount)&(hcount <1823)&(31< vcount)&(vcount<930)) ? 0 : 0;
                                                  //pix_r = ((384 < hcount)&(hcount <1823)&(31< vcount)&(vcount<930)) ? 0 : 0;
   //pix_b = ((curr_x<1019)&(1020>curr_x)&(500<curr_y)&(curr_y < 700)) ? 4'b1111 : 0;
   end
       assign hsync = (hcount > 11'd151 )? 1'd1 :1'd0;
 assign vsync = ( vcount < 10'd3) ? 1'd1 :1'd0; 
//assign vsync = ((10'd3<vcount) < 10'd5) ? 1'd1: 1'd0;
endmodule
