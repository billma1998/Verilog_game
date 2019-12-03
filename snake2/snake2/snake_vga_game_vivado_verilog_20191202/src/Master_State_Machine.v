`timescale 1ns / 1ps
module Master_State_Machine(
				input    			CLK,
				input    			RESET,
				output [1:0]		MSM_State,
				input   wire        Hit_wall_sig,//撞墙信�?�
				input   wire        Hit_body_sig,//撞到自己的身体信�?�
				input   wire        Hit_block_sig,////撞到障�?物
				input    			BINL, 
				input    			BINU,
				input    			BIND,
				input    			BINR,
				input [7:0]			SCORE    
							);

parameter       IDLE   	 		=			2'b00;
parameter       PLAY		   	=			2'b01;
parameter       WIN			   	=			2'b10;
parameter       FAIL			=			2'b11;

parameter       TIME_OUT		=           38'h1BF08EB000;//////20分钟的超时
        
reg         [37:0] time_cnt=38'd0;
reg			[1:0]  Curr_state=IDLE;
reg			[1:0]  Next_state=IDLE;

always@(Curr_state or BINL or BINU or BINR or BIND)begin
	case(Curr_state)
		 IDLE:   begin
					if(BINL|BINU|BINR|BIND) begin//////当开始状�?时，�?��?按下任�?一个方�?�按键，就会�?�动游�?
					  Next_state<=PLAY;
					  end
					 else begin
					  Next_state<=IDLE;     
					 end
				  end
	      PLAY:begin
		         if(SCORE==8'h40)/////当�?�下40个苹果时，也就是得分为40时，那么游�?就赢了，也就是结�?�了游�?
				  Next_state<=WIN;
				 else if(Hit_wall_sig | Hit_body_sig|Hit_block_sig)	///////当蛇撞上自己的身体，或者墙体，还有设定的障�?物，游�?就输了，进入失败状�?
                  Next_state<=FAIL;
                 else if(time_cnt>=TIME_OUT)//////游�?最多玩20份分钟，超时还没结�?�强行结�?�，进入失败状�?	
                  Next_state<=FAIL;				 
				  else
                  Next_state<=PLAY;
				  end
          WIN: begin
				  Next_state<=WIN;/////当赢了，除�?��?�?系统，�?然状�?�?�?�?�?�
			   end	  
				  
		  FAIL:begin
				 Next_state<=FAIL;/////当输了，除�?��?�?系统，�?然状�?�?�?�?�?�
               end		  
		  default: Next_state<=IDLE;	
         endcase		  
end



always@(posedge CLK)begin
      if(RESET)
	     time_cnt<=38'd0;
	  else if(Curr_state==PLAY)	 //////当系统进入游�?状�?时，�?�动超时计时器，当超时了游�?就结�?�了
	     time_cnt<=time_cnt+1'b1;
	  else
         time_cnt<=38'd0;	  
end

always@(posedge CLK)begin
   if(RESET)
     Curr_state<=IDLE; 
   else
     Curr_state<=Next_state;   //////根�?�时钟上沿更新状�?机的状�?
end

//////////////////////////////////////////////////////////////
////assignment
//////////////////////////////////////////////////////////////
assign MSM_State=Curr_state;
endmodule
