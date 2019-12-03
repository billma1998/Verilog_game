`timescale 1ns / 1ps
module Colour_Memory(
			input 		wire         			clk,
			input       wire	[1:0]			MSM_State,
			input       wire	[14:0]			Random_Target_Address,
			input       wire	[2:0]			Object,
			input   	wire    [9:0]			ADDRH,
			input   	wire    [8:0]			ADDRV,
			output  	reg  	[11:0]			COLOUR_OUT			
					);

initial begin
COLOUR_OUT=12'd0;
end

parameter       IDLE   	 		=			2'b00;
parameter       PLAY		   	=			2'b01;
parameter       WIN			   	=			2'b10;
parameter       FAIL			=			2'b11;

reg				[15:0]				  FrameCount=16'd0;


reg				[11:0]				 COLOUR_IN=12'd0;

parameter             NONE = 3'b000;
parameter             HEAD = 3'b001;
parameter             BODY = 3'b010;
parameter             WALL = 3'b011;
parameter             BLOCK=3'b100;

localparam 			  HEAD_COLOR = 3'b010;
localparam 			  BODY_COLOR = 3'b011;
wire  	start_Vga_red;
wire  	start_Vga_green;
wire  	start_Vga_blue;	

reg [2:0] Vga_rgb;//RGB


wire    play_VGA_red;
wire    play_VGA_green;
wire    play_VGA_blue;



always@(posedge clk)begin
  if(ADDRV==479)
  FrameCount<=FrameCount+1'b1;
end


always@(posedge clk)begin
	if(MSM_State==WIN)begin
		if(ADDRV>240)begin
			if(ADDRH>320)
			COLOUR_IN<=FrameCount[15:8]+ADDRV[7:0]+ADDRH[7:0]-240-320;/////这个是当游�?进入赢的状�?时，显示的一个效果图，具体�?�以上�?��?看
			else
			COLOUR_IN<=FrameCount[15:8]+ADDRV[7:0]+ADDRH[7:0]-240+320;
		end
	   else begin
	    if(ADDRH>320)
			COLOUR_IN<=FrameCount[15:8]-ADDRV[7:0]+ADDRH[7:0]+240-320;
			else
			COLOUR_IN<=FrameCount[15:8]-ADDRV[7:0]-ADDRH[7:0]+240+320;		   
	   end
	end
end

always@(posedge clk)begin
  if((ADDRH>=0)&&(ADDRH<640)&&(ADDRV>=0)&&(ADDRV<480))
      if((ADDRH[9:2]==Random_Target_Address[14:7])&&(ADDRV[8:2]==Random_Target_Address[6:0]))
				Vga_rgb = 3'b001;/////这个是苹果的�?置，我们给出红色				
		else if(Object == NONE)
				Vga_rgb = 3'b000;//////背景为黑色
		else if(Object == WALL)		
				Vga_rgb = 3'b101;////墙体颜色
		else if(Object == BLOCK)
		      	Vga_rgb = 3'b111;////障�?物颜色
		else if(Object == HEAD)//根�?�当�?扫�??到的点是哪一部分输出相应颜色
			    Vga_rgb = HEAD_COLOR;
		else if(Object == BODY)		
	            Vga_rgb = BODY_COLOR;
		else
        	  Vga_rgb = 3'b000;//其他地方输出黑色	
  else
            Vga_rgb = 3'b000;//其他地方输出黑色  
end


always@(*) begin
 if((ADDRH>=0)&&(ADDRH<640)&&(ADDRV>=0)&&(ADDRV<480))begin
 case(MSM_State)
  IDLE:
      COLOUR_OUT<=12'h0F0;
  PLAY:
      COLOUR_OUT<={{4{Vga_rgb[2]}},{4{Vga_rgb[1]}},{4{Vga_rgb[0]}}};
  WIN:
       COLOUR_OUT<=COLOUR_IN; 
  FAIL:
       COLOUR_OUT<=12'hF00;  
  default:COLOUR_OUT<=COLOUR_IN;	
  endcase
  end
  else
     COLOUR_OUT<=12'h000;  	
end


endmodule
