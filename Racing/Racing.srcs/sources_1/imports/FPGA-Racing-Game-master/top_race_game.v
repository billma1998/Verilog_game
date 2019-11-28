`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly Pomona
// Engineer: Ashot Hambardzumyan
// 
// Create Date: 10/27/2016 05:57:13 PM
// Design Name: 
// Module Name: top_race_game
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


module top_race_game(
input miso,
output mosi, ss, sclk,
input wire clk, reset, ps2d, ps2c, 
output wire hsync, vsync,
output wire [11:0] rgb_out, output pwm, aud_on,
    output a ,b,c,d,e,f,g,
            output [7:0] an
);

    assign dig0 = x_out[2:2];
    assign dig1 = x_out[3:3];
    assign dig2 = x_out[4:4];
    assign dig3 = x_out[5:5];
        assign dig4 = x_out[6:6];
        assign dig5 = x_out[7:7];
        assign dig6 = x_out[8:8];
        assign dig7 = x_out[9:9];


   seginterface M1 (.clk(clk),.dig7(dig7),.dig6(dig6),.dig5(dig5),.dig4(dig4),.dig3(dig3),.dig2(dig2),.dig1(dig1),.dig0(dig0),.a(a),.b(b),.c(c),.d(d),.e(e),.f(f),.g(g),.an(an));


  wire [13:0] x_out;
//variables
wire left_key, right_key, enter_key, key_relese, game_reset;
wire video_on, p_tick, road_on, finish_line, car_on, 
start_en, crash_en, finish_en;
wire [9:0] pixel_x, pixel_y;
//intantiate models
//keyboard
keyboard inkey(clk, reset, ps2d, ps2c,
                enter_key, key_relese);
                
//left_key right_key           
//graphics

graphics race_graph(clk, game_reset, pause, left_key,
                right_key, enter_key, video_on, start_en,crash_en,
                finish_en, pixel_x, pixel_y, road_on, finish_line,
                car_on,rgb_out);

//game_state
game_state game_states(clk, reset, video_on, road_on, finish_line,
         car_on, enter_key, key_relese,
           start_en,crash_en,finish_en, pause, game_reset);

//vga_sync
vga_sync vga(clk, reset, hsync, vsync, video_on,
             p_tick, pixel_x, pixel_y);
             
Acce in(x_out,left_key,right_key);
//Sound
song1 mysong(clk, reset, pause, aud_on, pwm);

    AccelerometerCtl2_2 acc(.SYSCLK(clk), .RESET(reset), .SCLK(sclk), .MOSI(mosi), .MISO(miso), .SS(ss), .ACCEL_X_OUT(x_out));

endmodule
