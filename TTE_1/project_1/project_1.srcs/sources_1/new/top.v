`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.11.2019 02:17:32
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
input miso,
output mosi, ss, sclk,
    input wire CLK,             // board clock: 100 MHz on Arty/Basys3/Nexys
    input wire RST_BTN,         // reset button
    input wire [3:0] sw,        // four switches
    output wire VGA_HS,       // horizontal sync output
    output wire VGA_VS,       // vertical sync output
    output reg [3:0] VGA_R,     // 4-bit VGA red output
    output reg [3:0] VGA_G,     // 4-bit VGA green output
    output reg [3:0] VGA_B,      // 4-bit VGA blue output
        output a ,b,c,d,e,f,g,
            output [7:0] an,
            output pwm, aud_on,
            
              input vauxp2,
   input vauxn2,
   input vauxp3,
   input vauxn3,
   input vauxp10,
   input vauxn10,
   input vauxp11,
   input vauxn11,
   input vp_in,
   input vn_in
            
    );
wire left_key, right_key, up_key,down_key;
    wire rst = RST_BTN;     // reset is active high
  wire [13:0] x_out;
  wire [13:0] y_out;
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



   wire enable;  
   wire ready;
   wire [15:0] data;   
  reg [6:0] Address_in  = 8'h1b;    
   reg [32:0] decimal;   
   reg [3:0] digital0;
   reg [3:0] digital1;
   reg [3:0] digital2;
   reg [3:0] digital3;
   reg [3:0] digital4;
   reg [3:0] digital5;
   reg [3:0] digital6;

        localparam U_BOUND = 9'd120;
       localparam D_BOUND = 9'd180;
       localparam L_BOUND = 10'd120;
        localparam R_BOUND = 10'd420;


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

    // VRAM frame buffers (read-write)
    localparam SCREEN_WIDTH = 640;
    localparam SCREEN_HEIGHT = 360;
    localparam VRAM_DEPTH = SCREEN_WIDTH * SCREEN_HEIGHT; 
    localparam VRAM_A_WIDTH = 18;  
    localparam VRAM_D_WIDTH = 8;   // colour bits per pixel

    reg [VRAM_A_WIDTH-1:0] address_a, address_b;
    reg [VRAM_D_WIDTH-1:0] datain_a, datain_b;
    wire [VRAM_D_WIDTH-1:0] dataout_a, dataout_b;
    reg we_a = 0, we_b = 1;  // write enable bit

    // frame buffer A VRAM
    sram #(
        .ADDR_WIDTH(VRAM_A_WIDTH), 
        .DATA_WIDTH(VRAM_D_WIDTH), 
        .DEPTH(VRAM_DEPTH), 
        .MEMFILE("")) 
        vram_a (
        .i_addr(address_a), 
        .i_clk(CLK), 
        .i_write(we_a),
        .i_data(datain_a), 
        .o_data(dataout_a)
    );

    // frame buffer B VRAM
    sram #(
        .ADDR_WIDTH(VRAM_A_WIDTH), 
        .DATA_WIDTH(VRAM_D_WIDTH), 
        .DEPTH(VRAM_DEPTH), 
        .MEMFILE("")) 
        vram_b (
        .i_addr(address_b), 
        .i_clk(CLK), 
        .i_write(we_b),
        .i_data(datain_b), 
        .o_data(dataout_b)
    );

    // sprite buffer (read-only)
    localparam SPRITE_SIZE = 32;  // dimensions of square sprites in pixels
    localparam SPRITE_COUNT = 8;  // number of sprites in buffer
    localparam SPRITEBUF_D_WIDTH = 8;  // colour bits per pixel
    localparam SPRITEBUF_DEPTH = SPRITE_SIZE * SPRITE_SIZE * SPRITE_COUNT;    
    localparam SPRITEBUF_A_WIDTH = 13;  // 2^13 == 8,096 == 32 x 256 

    reg [SPRITEBUF_A_WIDTH-1:0] address_s;
    wire [SPRITEBUF_D_WIDTH-1:0] dataout_s;

    // sprite buffer memory
    sram #(
        .ADDR_WIDTH(SPRITEBUF_A_WIDTH), 
        .DATA_WIDTH(SPRITEBUF_D_WIDTH), 
        .DEPTH(SPRITEBUF_DEPTH), 
        .MEMFILE("sprites.mem"))
        spritebuf (
        .i_addr(address_s), 
        .i_clk(CLK), 
        .i_write(0),  // read only
        .i_data(0), 
        .o_data(dataout_s)
    );

    reg [11:0] palette [0:255];  // 256 x 12-bit colour palette entries
    reg [11:0] colour;
    initial begin
        $display("Loading palette.");
        $readmemh("sprites_palette.mem", palette);
    end

    // sprites to load and position of player sprite in frame
    localparam SPRITE_BG_INDEX = 7;  // background sprite
    localparam SPRITE_PL_INDEX = 0;  // player sprite
    localparam SPRITE_BG_OFFSET = SPRITE_BG_INDEX * SPRITE_SIZE * SPRITE_SIZE;
    localparam SPRITE_PL_OFFSET = SPRITE_PL_INDEX * SPRITE_SIZE * SPRITE_SIZE;
    localparam SPRITE_PL_X = SCREEN_WIDTH - SPRITE_SIZE >> 1; // centre
    localparam SPRITE_PL_Y = SCREEN_HEIGHT - SPRITE_SIZE;     // bottom

    reg [9:0] draw_x;
    reg [8:0] draw_y;
    reg [9:0] pl_x = SPRITE_PL_X; 
    reg [9:0] pl_y = SPRITE_PL_Y; 
    reg [9:0] pl_pix_x; 
    reg [8:0] pl_pix_y;

    // pipeline registers for for address calculation
    reg [VRAM_A_WIDTH-1:0] address_fb1;  
    reg [VRAM_A_WIDTH-1:0] address_fb2;

    always @ (posedge CLK)
    begin
        // reset drawing
        if (rst)
        begin
            draw_x <= 0;
            draw_y <= 0;
            pl_x <= SPRITE_PL_X; 
            pl_y <= SPRITE_PL_Y; 
            pl_pix_x <= 0; 
            pl_pix_y <= 0;
        end

        // draw background
        if (address_fb1 < VRAM_DEPTH)
        begin
            if (draw_x < SCREEN_WIDTH)
                draw_x <= draw_x + 1;
            else
            begin
                draw_x <= 0;
                draw_y <= draw_y + 1;
            end

            // calculate address of sprite and frame buffer (with pipeline)
            address_s <= SPRITE_BG_OFFSET + 
                        (SPRITE_SIZE * draw_y[4:0]) + draw_x[4:0];
            address_fb1 <= (SCREEN_WIDTH * draw_y) + draw_x;
            address_fb2 <= address_fb1;

            if (we_a)
            begin
                address_a <= address_fb2;
                datain_a <= dataout_s;
            end
            else
            begin
                address_b <= address_fb2;
                datain_b <= dataout_s;
            end
        end

        // draw player ship
        if (address_fb1 >= VRAM_DEPTH)  // background drawing is finished 
        begin
            if (pl_pix_y < SPRITE_SIZE)
            begin
                if (pl_pix_x < SPRITE_SIZE - 1)
                    pl_pix_x <= pl_pix_x + 1;
                else
                begin
                    pl_pix_x <= 0;
                    pl_pix_y <= pl_pix_y + 1;
                end

                address_s <= SPRITE_PL_OFFSET 
                            + (SPRITE_SIZE * pl_pix_y) + pl_pix_x;
                address_fb1 <= SCREEN_WIDTH * (pl_y + pl_pix_y) 
                            + pl_x + pl_pix_x;
                address_fb2 <= address_fb1;

                if (we_a)
                begin
                    address_a <= address_fb2;
                    datain_a <= dataout_s;
                end
                else
                begin
                    address_b <= address_fb2;
                    datain_b <= dataout_s;
                end
            end
        end

        if (pix_stb)  // once per pixel
        begin
            if (we_a)  // when drawing to A, output from B
            begin
                address_b <= y * SCREEN_WIDTH + x;
                colour <= active ? palette[dataout_b] : 0;
            end
            else  // otherwise output from A
            begin
                address_a <= y * SCREEN_WIDTH + x;
                colour <= active ? palette[dataout_a] : 0;
            end

            if (screenend)  // switch active buffer once per frame
            begin
                we_a <= ~we_a;
                we_b <= ~we_b;
                // reset background position at start of frame
                draw_x <= 0;
                draw_y <= 0;
                // reset player position
                pl_pix_x <= 0;
                pl_pix_y <= 0;
                // reset frame address
                address_fb1 <= 0;
                
                
        //                localparam U_BOUND = 9'd120;
      // localparam D_BOUND = 9'd180;
      // localparam L_BOUND = 10'd120;
      //  localparam R_BOUND = 10'd420;
                // update ship position based on switches
                if ((right_key_1) && (pl_x < SCREEN_WIDTH - SPRITE_SIZE)&&((pl_x + SPRITE_SIZE<L_BOUND)&(pl_y +SPRITE_SIZE> U_BOUND) & (pl_y <D_BOUND)||(pl_x > R_BOUND)))
                    pl_x <= pl_x + 1;
                if ((left_key_1) && (pl_x > 0)&&((pl_x >R_BOUND)&(pl_y +SPRITE_SIZE > U_BOUND )& (pl_y <D_BOUND)||(pl_x-SPRITE_SIZE < L_BOUND)))
                    pl_x <= pl_x - 1;      
                if ((down_key_1) && (pl_y < SCREEN_HEIGHT - SPRITE_SIZE) &&((pl_y+SPRITE_SIZE<U_BOUND)&(pl_x<R_BOUND)&(pl_x +SPRITE_SIZE>L_BOUND)||(pl_y > D_BOUND)))
                    pl_y <= pl_y + 1;
                if ((up_key_1) && (pl_y > 0)&&((pl_y > D_BOUND)&(pl_x<R_BOUND)&(pl_x+SPRITE_SIZE>L_BOUND)||(pl_y + SPRITE_SIZE < U_BOUND)))
                    pl_y <= pl_y - 1;    
                 
                 
                if ((right_key_1) && (pl_x < SCREEN_WIDTH - SPRITE_SIZE)&&((pl_y +SPRITE_SIZE <= U_BOUND) || pl_y >D_BOUND))
                    pl_x <= pl_x + 1;
                if ((left_key_1) && (pl_x > 0)&&((pl_y +SPRITE_SIZE <= U_BOUND )|| (pl_y >=D_BOUND)))
                    pl_x <= pl_x - 1;      
                if ((down_key_1) && (pl_y < SCREEN_HEIGHT - SPRITE_SIZE) &&((pl_x>=R_BOUND)||(pl_x +SPRITE_SIZE<=L_BOUND)))
                    pl_y <= pl_y + 1;
                if ((up_key_1) && (pl_y > 0)&&((pl_x>=R_BOUND)||(pl_x+SPRITE_SIZE<=L_BOUND)))
                    pl_y <= pl_y - 1;    
                 

               /* if (right_key_2 && pl_x < SCREEN_WIDTH -1 - SPRITE_SIZE)
                  pl_x <= pl_x + 2;
                if (left_key_2 && pl_x > 1)
                    pl_x <= pl_x - 2;      
                if (up_key_2 && pl_y < SCREEN_HEIGHT-1 - SPRITE_SIZE)
                    pl_y <= pl_y + 2;
                if (down_key_2 & pl_y > 1)
                    pl_y <= pl_y - 2;          
                if (right_key_3 && pl_x < SCREEN_WIDTH -2 - SPRITE_SIZE)
                  pl_x <= pl_x + 3;
                if (left_key_3 && pl_x > 2)
                    pl_x <= pl_x - 3;      
                if (up_key_3 && pl_y < SCREEN_HEIGHT-2 - SPRITE_SIZE)
                    pl_y <= pl_y + 3;
                if (down_key_3 & pl_y > 2)
                    pl_y <= pl_y - 3;          
                    
                    */                              
            end
        end

       // VGA_R <= colour[11:8];
      //  VGA_G <= colour[7:4];
        //VGA_B <= colour[3:0];
        
        
    end
        assign dig0 = x_out[2:2];
    assign dig1 = x_out[3:3];
    assign dig2 = x_out[4:4];
    assign dig3 = x_out[5:5];
        assign dig4 = x_out[6:6];
        assign dig5 = x_out[7:7];
        assign dig6 = x_out[8:8];
        assign dig7 = x_out[9:9];


   seginterface M1 (.clk(CLK),.dig7(digital6),.dig6(digital5),.dig5(digital4),.dig4(digital3),.dig3(digital2),.dig2(digital1),.dig1(digital0),.dig0(0),.a(a),.b(b),.c(c),.d(d),.e(e),.f(f),.g(g),.an(an));
assign left_key_1 = ((x_out<200))? 1:0;
    assign right_key_1 = ((x_out>300))? 1:0;
    assign down_key_1 = ((y_out<200))? 1:0;
    assign up_key_1 = (y_out>300)? 1:0;
   // assign left_key_1 = ((x_out>160)&(x_out<200))? 1:0;
   // assign right_key_1 = ((340 > x_out)&(x_out>300))? 1:0;
   // assign up_key_1 = ((y_out>160)&(y_out<200))? 1:0;
   // assign down_key_1 = ((340 > y_out)&(y_out>300))? 1:0;
   //   assign left_key_2 = (x_out<161)? 1:0;
    //assign right_key_2 = (339 < x_out)? 1:0;
    //assign up_key_2 = (y_out<161)? 1:0;
//assign down_key_2 = ((380>y_out)&(339< y_out))? 1:0;


/*
      assign left_key_2 = ((x_out>120)&(x_out<161))? 1:0;
    assign right_key_2 = ((380>x_out)&(339 < x_out))? 1:0;
    assign up_key_2 = ((y_out>120)&(y_out<161))? 1:0;
assign down_key_2 = ((380>x_out)&(339< y_out))? 1:0;
assign left_key_3 = (x_out<121)?1:0;
assign right_key_3 = (x_out>379)?1:0;
assign up_key_3 = (y_out<121)?1:0;
assign down_key_3 =(y_out>379)?1:0;
*/

  xadc_wiz_0  XLXI_7 (.daddr_in(Address_in), //addresses can be found in the artix 7 XADC user guide DRP register space
                     .dclk_in(CLK), 
                     .den_in(enable), 
                     .di_in(0), 
                     .dwe_in(0), 
                     .busy_out(),                    
                     .vauxp2(vauxp2),
                     .vauxn2(vauxn2),
                     .vauxp3(vauxp3),
                     .vauxn3(vauxn3),
                     .vauxp10(vauxp10),
                     .vauxn10(vauxn10),
                     .vauxp11(vauxp11),
                     .vauxn11(vauxn11),
                     .vn_in(vn_in), 
                     .vp_in(vp_in), 
                     .alarm_out(), 
                     .do_out(data), 
                     .reset_in(0),
                     .eoc_out(enable),
                     .channel_out(),
                     .drdy_out(ready));
                     
                     
        reg [32:0] count; 
     //binary to decimal conversion
      always @ (posedge(CLK))
      begin
      
        if(count == 10000000)begin
        
        decimal = data >> 4;
        //looks nicer if our max value is 1V instead of .999755
        if(decimal >= 4093)
        begin
            digital0 = 0;
            digital1 = 0;
            digital2 = 0;
            digital3 = 0;
            digital4 = 0;
            digital5 = 0;
            digital6 = 1;
            count = 0;
        end
        else 
        begin
            decimal = decimal * 250000;
            decimal = decimal >> 10;
            
            
            digital0 = decimal % 10;
            decimal = decimal / 10;
            
            digital1 = decimal % 10;
            decimal = decimal / 10;
                   
            digital2 = decimal % 10;
            decimal = decimal / 10;
            
            digital3 = decimal % 10;
            decimal = decimal / 10;
            
            digital4 = decimal % 10;
            decimal = decimal / 10;
                   
            digital5 = decimal % 10;
            decimal = decimal / 10; 
            
            digital6 = decimal % 10;
            decimal = decimal / 10; 
            
            count = 0;
        end
       end
       
      count = count + 1;
               
      end
                      
         

    //assign left_key = (x_out<14'b000011111111)? 1:0;
   // assign left_key = (x_out<14'b000011001000)? 1:0;
   // assign right_key = (x_out>14'b000100101100)? 1:0;
//    assign up_key = (y_out<14'b000011001000)? 1:0;
  //  assign down_key = (y_out>14'b000100101100)? 1:0;
        AccelerometerCtl2_2 acc(.SYSCLK(CLK), .RESET(RST_BTN), .SCLK(sclk), .MOSI(mosi), .MISO(miso), .SS(ss), .ACCEL_X_OUT(x_out), .ACCEL_Y_OUT(y_out));
//song1 mysong(clk, reset, pause, aud_on, pwm);
song1 mysong(clk, reset,aud_on, pwm);

wire [11:0] sq_b;
reg [11:0] sq_b1;
always @(posedge CLK)
begin
sq_b1 <= sq_b;
end
assign sq_b = ((x>0)&(x<1000)&(y>=0)&(y<1000))?12'h266:0;


assign sq_a = (wall_b == 1)?(digital6 ? 12'hf00:12'h0f0):
                            (digital6 ? 12'h000 : 12'h000);

        assign wall_b = ((x < R_BOUND) & (x > L_BOUND) & (y > U_BOUND) & (y < D_BOUND))? 1:0;
 wire [11:0] sq_a;
    //wall blockwall( CLK, x, y, wall_b); 
    reg [11:0] sq_a1;
always @(posedge CLK)
begin
sq_a1 <= sq_a;
end

//assign sq_a = (wall_b == 1)?12'hf00:12'h000;

always @(posedge CLK)
begin
VGA_R[3:0] <= (sq_a1[11:8]+colour[11:8])/2;
VGA_G[3:0] <= (sq_a1[7:4]+colour[7:4])/2;
VGA_B[3:0] <= (sq_a1[3:0]+colour[3:0])/2;
end

       // VGA_R <= colour[11:8];
      //  VGA_G <= colour[7:4];
        //VGA_B <= colour[3:0];
endmodule