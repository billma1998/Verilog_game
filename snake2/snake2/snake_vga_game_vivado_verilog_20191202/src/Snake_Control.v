`timescale 1ns / 1ps
module Snake_Control(
 				input    					  	  CLK,
				input    					  	  RESET,
				input    					  	  BINC_flag,
				input    	 [1:0]				  Navigation_State,
				input    	 [1:0]				  MSM_State,
				input	  	  wire    [18:0]	  VGA_Address,
				output        reg      			  Reached_Target,
				input         wire    [14:0]       Random_Target_Address,
				output        wire    [14:0]       Block_Address1,
				output        wire    [14:0]       Block_Address2,
				output        wire    [14:0]       Block_Address3,
				output        wire    [14:0]       Block_Address4,
				output        reg    [2:0]        Object,
				output		  reg    [7:0]		  game_Score,  
				output  	  reg        	 	  Hit_wall_sig,//撞墙信�?�
				output  	  reg        	 	  Hit_body_sig,//撞到自己的身体信�?�
				output  	  reg        	 	  Hit_block_sig////撞到障�?物				
				
				
					);

parameter   SnakeLength	=50;
parameter       IDLE   	 		=			2'b00;
parameter       PLAY		   	=			2'b01;
parameter       WIN			   	=			2'b10;
parameter       FAIL			=			2'b11;


parameter        Up 						= 						2'b00;
parameter        Down 						= 						2'b01;
parameter        Left 						= 						2'b10;
parameter        Right 						= 						2'b11;

parameter  		TIME_1S		 	 =     32'd29_999_999;
reg             [31:0]        	refresh_time_cnt=TIME_1S;
//parameter  		TIME_1S		 	 =     32'd9;


//****************障�?物�??标
parameter    	 block1_x=8'd28;
parameter    	 block1_y=7'd11;



parameter    	 block2_x=8'd40;
parameter    	 block2_y=7'd15;




parameter    	 block3_x=8'd55;
parameter    	 block3_y=7'd33;



parameter    	 block4_x=8'd60;
parameter    	 block4_y=7'd60;


parameter         NONE = 3'b000;
parameter         HEAD = 3'b001;
parameter         BODY = 3'b010;
parameter         WALL = 3'b011;
parameter         BLOCK=3'b100;  
					

reg  	[7:0]   SnakeState_X [0:SnakeLength-1];				
reg  	[6:0]   SnakeState_Y [0:SnakeLength-1];				
reg		[29:0]	Counter=30'd0;				
reg		[SnakeLength-1:0]   Snake_light_sig; 
reg		[SnakeLength-2:0]   Search_body_num='d0; 


reg     [3:0]				Block_light_sig=4'd0;

assign Block_Address1={block1_x,block1_y};
assign Block_Address2={block1_x,block1_y};
assign Block_Address3={block1_x,block1_y};
assign Block_Address4={block1_x,block1_y};

reg     [6:0]   Body_num=7'd1;
genvar   PixNo;
generate
for(PixNo=0;PixNo<SnakeLength-1;PixNo=PixNo+1)//////////这
 begin:PixShift
   always@(posedge CLK)begin
     if(RESET) begin
	  SnakeState_X[PixNo+1]<=79;   ////给一个蛇头的�?置
	  SnakeState_Y[PixNo+1]<=100;  ////给一个蛇头的�?置
	 end
	 else if(Counter==0) begin
	  SnakeState_X[PixNo+1]<=SnakeState_X[PixNo];////// 当定时到时，我们为了得到一个蛇�?移动的效果，就是将他们的�??标更新，就是�?一个�??标给它�?�一个蛇身的�??标，看到的效果就是移动的了
	  SnakeState_Y[PixNo+1]<=SnakeState_Y[PixNo];//////	当定时到时，我们为了得到一个蛇�?移动的效果，就是将他们的�??标更新，就是�?一个�??标给它�?�一个蛇身的�??标，看到的效果就是移动的了 
	 end
   end
 end 
 endgenerate
					

////////////////////////////////////////////////////////////////////
///蛇头�??标控制
////////////////////////////////////////////////////////////////////
always@(posedge CLK)begin
 if(RESET)begin
 SnakeState_X[0]<=80;
 SnakeState_Y[0]<=100;
 Hit_wall_sig<=1'b0;
  Hit_block_sig<=1'b0;
 end
 else if(Counter==0)begin////////定时到了�?判断
 case(MSM_State)
   IDLE:
          begin
			 SnakeState_X[0]<=80;
			 SnakeState_Y[0]<=100;	
			 Hit_wall_sig<=1'b0;
			Hit_block_sig<=1'b0;			 
		  end
   PLAY:
         begin 
           if((SnakeState_Y[0]==block1_y)&&(SnakeState_X[0]==block1_x)&&(Block_light_sig[0]==1'b1))	//////当�?�现蛇头的�??标和我们蛇的障�?物的�??标一致，那么就是撞上障�?物了，这个时候就给出装上障�?物的标准信�?�
			Hit_block_sig<=1'b1;	
		   else if((SnakeState_Y[0]==block2_y)&&(SnakeState_X[0]==block2_x)&&(Block_light_sig[1]==1'b1))////�?�上	
            Hit_block_sig<=1'b1;
		   else if((SnakeState_Y[0]==block3_y)&&(SnakeState_X[0]==block3_x)&&(Block_light_sig[2]==1'b1))////�?�上		
            Hit_block_sig<=1'b1;
		   else if((SnakeState_Y[0]==block4_y)&&(SnakeState_X[0]==block4_x)&&(Block_light_sig[3]==1'b1))	////�?�上	
            Hit_block_sig<=1'b1;			
           else			
			case(Navigation_State)
								Up:
									begin
									if(SnakeState_Y[0] == 7'd1)//如果第一个移动的节�??标已�?是1了，�?按上，则会撞墙
											Hit_wall_sig <= 1'd1;
										else
											SnakeState_Y[0] <= SnakeState_Y[0] - 7'd1;//注�?�??标系，这里是 - 1，因为最上�?�是0，所以�?�上走的�?，Y是 - 1的。
									end
								
								Down:
									begin
										if(SnakeState_Y[0] == 7'd118)/////装上下边的墙了
											Hit_wall_sig <= 1'd1;
										else
											SnakeState_Y[0] <= SnakeState_Y[0] + 7'd1;//////如果�?会，那就纵�??标加1
									end
								Left:
									begin
										if(SnakeState_X[0] == 8'd1)
											Hit_wall_sig <= 1'd1;
										else
											SnakeState_X[0] <= SnakeState_X[0] - 8'd1;//注�?�??标系，这里是 + 1，因为最左�?�是0，所以�?�左走的�?，X是 - 1的。	
									end
								
								Right:
									begin
										if(SnakeState_X[0] == 8'd159)
											Hit_wall_sig <= 1'd1;
										else
											SnakeState_X[0] <= SnakeState_X[0] + 8'd1;
									end
								default:;	
							endcase				
			
         end		 
   WIN:
          begin
			 SnakeState_X[0]<=80; /////进入赢的状�?，�??标就�?�?更新了
			 SnakeState_Y[0]<=100;/////进入赢的状�?，�??标就�?�?更新了
			 Hit_wall_sig<=1'b0;  /////进入赢的状�?，�??标就�?�?更新了
			 Hit_block_sig<=1'b0; /////进入赢的状�?，�??标就�?�?更新了
		  end
   FAIL:
          begin
			 SnakeState_X[0]<=80;
			 SnakeState_Y[0]<=100;	
			 Hit_wall_sig<=1'b0;
			 Hit_block_sig<=1'b0;				 
		  end		  
default:;	
endcase
end					
end


/////////////////////////////////////////////////////
///�?�蛇头逻辑
////////////////////////////////////////////////////
always@(posedge CLK)begin
  if(RESET)begin
  Reached_Target<=1'b0;
  end
  else if(Counter==0) begin
  if((Random_Target_Address[14:7]==SnakeState_X[0])&&(Random_Target_Address[6:0]==SnakeState_Y[0]))/////当苹果的的�?置和蛇头的�?置一样时，代表�?�上苹果了，给出对应的标志信�?�
   Reached_Target<=1'b1;
  else
    Reached_Target<=1'b0;
  end	
  else
  Reached_Target<=1'b0;  
end

always@(posedge CLK)begin
  if(RESET)
	game_Score<=8'h0;
  else if((MSM_State==PLAY)&&(Reached_Target==1'b1))begin//////当系统�?正常的游�?时，�?��?�现蛇头�?�上苹果了，那么我们的得分就加一，显示在数�?管上
		if(game_Score[3:0]==4'd9)
			 if(game_Score[7:4]==4'd9)
					game_Score<=8'd0;
				 else
				 begin
				 game_Score[7:4]<=game_Score[7:4]+1'b1;//////这里我们为了两个数�?管显示分数，所以我们把8bit的信�?�拆分，高4�?表示�??�?，低4�?表示�?��?
				 game_Score[3:0]<=4'd0;
				 end
			else
	         game_Score[3:0]<= game_Score[3:0]+1'b1;		   
		end
  else if(MSM_State!=PLAY)///////�?�?游�?状�?，那么分数就清0处�?�了
    game_Score <=8'h0;
end


always@(posedge  CLK)begin
  if(RESET) begin
	Block_light_sig<=4'd0;
  end
  else if((Reached_Target==1'b1)&&(game_Score==8'h01)&&(MSM_State==PLAY))///////这个是障�?物我们�?是一上�?�就给4个障�?物了，而是�?游�?的过程中，得分到了一定的时刻，挨个递增障�?物的
    Block_light_sig<=4'h1;                        
  else if((Reached_Target==1'b1)&&(game_Score==8'h04)&&(MSM_State==PLAY))
    Block_light_sig<=4'h3;                         
  else if((Reached_Target==1'b1)&&(game_Score==8'h10)&&(MSM_State==PLAY))
    Block_light_sig<=4'h7; 	                       
  else if((Reached_Target==1'b1)&&(game_Score==8'h13)&&(MSM_State==PLAY))
    Block_light_sig<=4'hf; 	
  else if(MSM_State!=PLAY)
	Block_light_sig<=4'h0; 	  
  else
    Block_light_sig<=Block_light_sig; 	  
end






/////////////////////////////////////////////////////////
//蛇身点亮控制
////////////////////////////////////////////////////////
always@(posedge CLK)begin
if(RESET) begin
   Snake_light_sig<='d1;
   Body_num<=7'd1;
   end
 else 
   if(MSM_State!=PLAY)begin
   Snake_light_sig<='d1;
   Body_num<=7'd1;   
   end
   else if(MSM_State==PLAY) begin
   if(Reached_Target==1'b1)begin/////////�?次蛇头�?�上苹果了，蛇身�?会�?�长
   Snake_light_sig[Body_num]<=1'b1;
   Body_num<=Body_num+1'b1;
   end
   else begin
   Snake_light_sig<=Snake_light_sig;
   Body_num<=Body_num;
   end
   end
end

//////////////////////////////////////////////////////////////////////////////
///刷新速度控制
//////////////////////////////////////////////////////////////////////////////
always@(posedge CLK)begin
  if(RESET)
     refresh_time_cnt<=TIME_1S;
  else if((Reached_Target==1'b1)&&(MSM_State==PLAY))
     refresh_time_cnt<=refresh_time_cnt-1000000;//////�?次快20ms   这个是控制蛇的移动速度，�?次�?�上一个苹果，我们刷新的时间就�?�快20ms
  else if(MSM_State!=PLAY)	
	 refresh_time_cnt<=TIME_1S;  
end

reg    Pause_flag=1'b0;

always@(posedge CLK)begin
  if(RESET) begin
    Pause_flag<=1'b0;
  end
  else if(BINC_flag==1'b1)///////我们�?�了一个游�?暂�?�的功能，就是通过按下中间的按键，游�?就会进入暂�?�模�?
    Pause_flag<=!Pause_flag;
  else
    Pause_flag<=Pause_flag;  
end

always@(posedge CLK)begin
   if(RESET)
	Counter<=30'd0;
   else if((Counter>=refresh_time_cnt))	
   Counter<=30'd0;
   else if(Pause_flag==1'b0)//////�?�有游�?�?是暂�?�模�?，�?会�?�动刷新。�?然蛇的身体就�?�?�生移动
   Counter<=Counter+1'b1;
   else
   Counter<=Counter;
end
//////////////////////////////////////////////////////////////////////////////
///目标输出显示
//////////////////////////////////////////////////////////////////////////////

generate
for(PixNo=1;PixNo<SnakeLength-1;PixNo=PixNo+1)
 begin:BodyShift
   always@(posedge CLK)begin
			if(RESET)
			Search_body_num[PixNo-1]<=1'b0;
            else if((VGA_Address[18:11]==SnakeState_X[PixNo])&&(VGA_Address[8:2]==SnakeState_Y[PixNo])&&(Snake_light_sig[PixNo]==1'b1)) 	
            Search_body_num[PixNo-1]<=1'b1;////////当VGA的时�?扫�??到蛇的�?置，我们当�?就知�?��?把蛇画出�?�，给出对应的标志
            else 
            Search_body_num[PixNo-1]<=1'b0;			
	   end
 end 
endgenerate
 
////////这个模�?�主�?判断当�?时刻应该显示的是哪个部�?，都是通过�??标判断的 
always@(VGA_Address or Snake_light_sig)begin
       if((VGA_Address[18:9]>=0)&&(VGA_Address[18:9]<640)&&(VGA_Address[8:0]>=0)&&(VGA_Address[8:0]<480))begin
	       if((VGA_Address[18:11]==8'd0)|(VGA_Address[18:11]==8'd159)|(VGA_Address[8:2]==7'd0)|(VGA_Address[8:2]==7'd119))
	         Object = WALL;//扫�??对象是墙
			else if((VGA_Address[18:11]==SnakeState_X[0])&&(VGA_Address[8:2]==SnakeState_Y[0])&&(Snake_light_sig[0]==1'b1)) 
	        Object = HEAD;//扫�??对象是蛇头
            else if((VGA_Address[18:11]==block1_x)&&(VGA_Address[8:2]==block1_y)&&(Block_light_sig[0]==1'b1)) 	
            Object = BLOCK;//扫�??对象是障�?物
            else if((VGA_Address[18:11]==block2_x)&&(VGA_Address[8:2]==block2_y)&&(Block_light_sig[1]==1'b1)) 	
            Object = BLOCK;//扫�??对象是障�?物
            else if((VGA_Address[18:11]==block3_x)&&(VGA_Address[8:2]==block3_y)&&(Block_light_sig[2]==1'b1)) 	
            Object = BLOCK;//扫�??对象是障�?物
            else if((VGA_Address[18:11]==block4_x)&&(VGA_Address[8:2]==block4_y)&&(Block_light_sig[3]==1'b1)) 	
            Object = BLOCK;	//扫�??对象是障�?物		
            else if(Search_body_num!=0) begin
			Object = BODY;	//扫�??对象是蛇身
             end			
           	else 
			Object = NONE;//////扫�??对象是背景			
	   end
	   else
	   Object = NONE;
end  
  
endmodule
