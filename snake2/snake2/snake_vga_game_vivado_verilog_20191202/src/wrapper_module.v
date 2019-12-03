`timescale 1ns / 1ps
module wrapper_module(
				input   wire 				CLK,
				input   wire 				RESET,
			   	input   wire				BINC,
			   	input   wire				BINL,
			   	input   wire				BINU,
			   	input   wire				BIND,
			   	input   wire				BINR,
				output  wire    [11:0]		COLOUR_OUT,
				output  wire                HS,
				output  wire                VS			
					);
					
wire   [1:0]		  MSM_State;
wire   [3:0]       	  State_Maza_OUT;
wire   [3:0]       	  LED_DisplaySM_out;



wire    [7:0]		  game_Score; 
wire				  Bit17TriggerOut; 
wire    [1:0]		  StrobeCount;
wire    [1:0]		  Navigation_State;
wire    [3:0]		  BIN_IN;
wire				  Reached_Target;
wire				  Hit_wall_sig;
wire				  Hit_body_sig;
wire				  Hit_block_sig;
wire    [18:0]		  VGA_Address;
wire    [2:0]		  Object;
wire    [14:0]		  Random_Target_Address;
wire    [14:0]		  Block_Address1;
wire    [14:0]		  Block_Address2;
wire    [14:0]		  Block_Address3;
wire    [14:0]		  Block_Address4;
wire				  BINC_flag;
					
wire				  BINL_flag;
wire				  BINU_flag;
wire				  BIND_flag;
wire				  BINR_flag;	
				
Navigation_State_Machine Navigation_State_Machine_inst(//这个模�?�主�?是通过按键的按下，控制蛇的移动方�?�，把Navigation_State传递给蛇�??标控制模�?�
    .CLK(CLK), 											///蛇�??标控制模�?�根�?�方�?�，更新蛇的�??标，
    .RESET(!RESET), 
    .Navigation_State(Navigation_State), 
    .BINL(BINL_flag), 
    .BINU(BINU_flag), 
    .BIND(BIND_flag), 
    .BINR(BINR_flag)
    );

Master_State_Machine Master_State_Machine_inst (//////这个模�?�为系统的主控制模�?�，主�?根�?�别的模�?�传递过�?�的信�?�，决定游�?是结�?�了还是继续，
    .CLK(CLK), 									////比如当接收到装墙的信�?�，那么游�?就结�?�了。
    .RESET(!RESET), 
    .MSM_State(MSM_State), 
    .Hit_wall_sig(Hit_wall_sig), 
    .Hit_body_sig(Hit_body_sig), 
    .Hit_block_sig(Hit_block_sig), 
    .BINL(BINL_flag), 
    .BINU(BINU_flag), 
    .BIND(BIND_flag), 
    .BINR(BINR_flag), 
    .SCORE(game_Score)
    );	
					
Target_Generate Target_Generate_inst (/////////这个模�?�主�?是因为蛇会�?�?�的把苹果�?�了，需�?�?新产生苹果，这个模�?�主�?是控制新产生的苹果的�?置
    .CLK(CLK), 
    .RESET(!RESET), 
    .Reached_Target(Reached_Target), 
    .Block_Address1(Block_Address1), 
    .Block_Address2(Block_Address2), 
    .Block_Address3(Block_Address3), 
    .Block_Address4(Block_Address4), 
    .Random_Target_Address(Random_Target_Address)
    );

Snake_Control Snake_Control_inst (///////////这个模�?�主�?是通过控制蛇的移动，�?�时给出对应的标志�?给其他模�?�判断用
    .CLK(CLK), 
    .RESET(!RESET), 
    .Navigation_State(Navigation_State), 
    .MSM_State(MSM_State), 
    .VGA_Address(VGA_Address), 
    .Reached_Target(Reached_Target),
    .game_Score(game_Score),
    .Object(Object),
    .BINC_flag(BINC_flag),
    .Block_Address1(Block_Address1), 
    .Block_Address2(Block_Address2), 
    .Block_Address3(Block_Address3), 
    .Block_Address4(Block_Address4), 
    .Hit_wall_sig(Hit_wall_sig), 
    .Hit_body_sig(Hit_body_sig), 
    .Hit_block_sig(Hit_block_sig), 	
	.Random_Target_Address(Random_Target_Address)
    );


		
Vga_module Vga_module_inst (//////这个模�?�主�?是实现VGA标准时�?，显示所有的东西
    .CLK(CLK), 
    .RESET(!RESET), 
    .MSM_State(MSM_State), 
    .COLOUR_OUT(COLOUR_OUT), 
    .VGA_Address(VGA_Address), 
	.Random_Target_Address(Random_Target_Address),
    .Object(Object), 
    .HS(HS), 
    .VS(VS)
    );	
/////////////////////////////////////////////
////assignment  test
/////////////////////////////////////////////
key_filter key_filter_inst0(
	.Clk(CLK),
	.Rst_n(RESET),
	.key_in(!BINC),
	.key_in_flag(BINC_flag)
	);
key_filter key_filter_inst1(
	.Clk(CLK),
	.Rst_n(RESET),
	.key_in(!BINU),
	.key_in_flag(BINU_flag)
	);
key_filter key_filter_inst2(
	.Clk(CLK),
	.Rst_n(RESET),
	.key_in(!BIND),
	.key_in_flag(BIND_flag)
	);
key_filter key_filter_inst3(
	.Clk(CLK),
	.Rst_n(RESET),
	.key_in(!BINL),
	.key_in_flag(BINL_flag)
	);
key_filter key_filter_inst4(
	.Clk(CLK),
	.Rst_n(RESET),
	.key_in(!BINR),
	.key_in_flag(BINR_flag)
	);	
endmodule				
