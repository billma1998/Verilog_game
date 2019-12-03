`timescale 1ns / 1ps
module Vga_module(
				input   wire 				CLK,
				input   wire 				RESET,
				input   wire	[1:0]		MSM_State,
				input   wire	[2:0]		Object,
				input   wire    [14:0]      Random_Target_Address,
				output  wire    [11:0]		COLOUR_OUT,
				output  wire    [18:0]		VGA_Address,
				output  wire                HS,
				output  wire                VS

					
					);

					
wire  						 CLK_25M;
wire  	  [11:0]			 COLOUR_LOGIC;
wire  	  [9:0]			 	 ADDRH;
wire  	  [8:0]				 ADDRV;

clk_div clk_div_inst (//////因为我们�?��?是100M的主时钟，但是我们�?�游�?，分辨率是640*480的，所以我们�?用的时钟是25M，这里我们就对时钟进行一个4分频得到25M
    .clk(CLK), 
    .CLK_25M(CLK_25M)
    );

Colour_Memory Colour_Memory_inst (
    .clk(CLK_25M), 
    .ADDRH(ADDRH), 
    .ADDRV(ADDRV),
    .MSM_State(MSM_State),
    .Random_Target_Address(Random_Target_Address),
    .Object(Object),
    .COLOUR_OUT(COLOUR_LOGIC)
    );

///////这个模�?�主�?是实现标准的时�?，这个�?看点相关的基础
VGA_Interface VGA_Interface_inst (
    .clk(CLK_25M), 
    .COLOUR_IN(COLOUR_LOGIC), 
    .ADDRH(ADDRH), 
    .ADDRV(ADDRV), 
    .COLOUR_OUT(COLOUR_OUT), 
    .HS(HS), 
    .VS(VS)
    );


///////////////////////////////////////////////////////
////assignement
/////////////////////////////////////////////////////	
assign VGA_Address={ADDRH,ADDRV};				
	
endmodule
