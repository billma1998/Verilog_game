`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.12.2019 17:36:18
// Design Name: 
// Module Name: top
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


module top(
    input wire CLK,             // board clock: 100 MHz on Arty/Basys3/Nexys
    input wire RST_BTN,         // reset button
    input wire [3:0] sw,        // four switches
    output wire VGA_HS,       // horizontal sync output
    output wire VGA_VS,       // vertical sync output
    output reg [3:0] VGA_R,     // 4-bit VGA red output
    output reg [3:0] VGA_G,     // 4-bit VGA green output
    output reg [3:0] VGA_B,      // 4-bit VGA blue output
        output a ,b,c,d,e,f,g,
            output [7:0] an
    );

    wire rst = RST_BTN;     // reset is active high

reg [3:0] dig7 ,dig6,dig5,dig4,dig3,dig2,dig1,dig0;

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;
    always @(posedge CLK)
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000

    wire [9:0] x;       // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;       // current pixel y position:  9-bit value: 0-511
    wire blanking;      // high within the blanking period
    wire active;        // high during active pixel drawing
    wire screenend;     // high for one tick at the end of screen
    wire animate;       // high for one tick at end of active drawing
    wire wall_b;        // position of wall


    vga640x480 display (
        .i_clk(CLK), 
        .i_pix_stb(pix_stb),
        .i_rst(rst),
        .o_hs(VGA_HS), 
        .o_vs(VGA_VS), 
        .o_x(x), 
        .o_y(y),
        .o_blanking(blanking),
        .o_active(active),
        .o_screenend(screenend),
        .o_animate(animate)
    );


wire [11:0] sq_b;
reg [11:0] sq_b1;
always @(posedge CLK)
begin
sq_b1 <= sq_b;
end
assign sq_b = ((x>0)&(x<1000)&(y>=0)&(y<1000))?12'h266:0;


        localparam U_BOUND = 9'd100;
       localparam D_BOUND = 9'd20;
       localparam L_BOUND = 10'd120;
        localparam R_BOUND = 10'd420;


      //wire block_x, block_y;
      
       // assign block_x = ((x < R_BOUND) & (x > L_BOUND))?1:0;
       // assign block_y =( (y < U_BOUND) & (y > D_BOUND))?1:0;
        assign wall_b = ((x < R_BOUND) & (x > L_BOUND) & (y < U_BOUND) & (y > D_BOUND))? 1:0;
 wire [11:0] sq_a;
    //wall blockwall( CLK, x, y, wall_b); 
    reg [11:0] sq_a1;
always @(posedge CLK)
begin
sq_a1 <= sq_a;
end

assign sq_a = (wall_b == 1)?12'hf00:12'h000;
always @(posedge CLK)
begin
VGA_R[3:0] <= (sq_a1[11:8]+sq_b1[11:8])/2;
VGA_G[3:0] <= (sq_a1[7:4]+sq_b1[7:4])/2;
VGA_B[3:0] <= (sq_a1[3:0]+sq_b1[3:0])/2;
end

seginterface M1 (.clk(CLK),.dig7(dig7),.dig6(VGA_B),.dig5(VGA_G),.dig4(VGA_R),.dig3(wall_b),.dig2(dig2),.dig1(block_y),.dig0(block_x),.a(a),.b(b),.c(c),.d(d),.e(e),.f(f),.g(g),.an(an));
  










//reg [11:0] colour_now;

/*
    always @ (posedge CLK)
    begin
    
    if (wall_b)
        colour_now = 12'hf00;
    else
    colour_now = 12'hb0;

        VGA_R <= colour_now[11:8];
        VGA_G <= colour_now[7:4];
        VGA_B <= colour_now[3:0];
         
    end
        assign sq_a = ((x > 120) & (y >  40) & (x < 280) & (y < 200)) ? 1 : 0;
    assign sq_b = ((x > 200) & (y > 120) & (x < 360) & (y < 280)) ? 1 : 0;
    assign sq_c = ((x > 280) & (y > 200) & (x < 440) & (y < 360)) ? 1 : 0;
    assign sq_d = ((x > 360) & (y > 280) & (x < 520) & (y < 440)) ? 1 : 0;
    
    
*/

 //     wire sq_a, sq_b, sq_c, sq_d;
    //assign sq_a = ((x > 120) & (y >  40) & (x < R_BOUND) & (y < U_BOUND)) ? 1 : 0;
 //     assign sq_a = ((x > 120) & (y >  40) & (x < 280) & (y < 200)) ? 1 : 0;
 //  assign sq_b = ((x > L_BOUND) & (y > D_BOUND) & (x < R_BOUND) & (y < U_BOUND)) ? 1 : 0;
 //   assign sq_c = ((x > L_BOUND) & (y > D_BOUND) & (x < R_BOUND) & (y < U_BOUND)) ? 1 : 0;
 //   assign sq_d = ((x > 360) & (y > 280) & (x < 520) & (y < 440)) ? 1 : 0;
  //      assign sq_a = ((x > 120) & (y >  40) & (x < 280) & (y < 200)) ? 1 : 0;
//    assign sq_b = ((x > 200) & (y > 120) & (x < 360) & (y < 280)) ? 1 : 0;
 //   assign sq_c = ((x > 280) & (y > 200) & (x < 440) & (y < 360)) ? 1 : 0;
 //   assign sq_d = ((x > 360) & (y > 280) & (x < 520) & (y < 440)) ? 1 : 0;
    
  //  assign VGA_R[3] = sq_b;         // square b is red
  //  assign VGA_G[3] = sq_a | sq_d;  // squares a and d are green
  //  assign VGA_B[3] = sq_c;         // square c is blue  
      
//seginterface M1 (.clk(CLK),.dig7(dig7),.dig6(VGA_B),.dig5(VGA_G),.dig4(VGA_R),.dig3(wall_b),.dig2(dig2),.dig1(dig1),.dig0(dig0),.a(a),.b(b),.c(c),.d(d),.e(e),.f(f),.g(g),.an(an));

endmodule
