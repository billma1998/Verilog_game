`timescale 1ns / 1ps 
module Navigation_State_Machine(
				input    			CLK,
				input    			RESET,
				output [1:0]		Navigation_State,
				input    			BINL,
				input    			BINU,
				input    			BIND,
				input    			BINR 
							  );

parameter        Up 						= 						2'b00;
parameter        Down 						= 						2'b01;
parameter        Left 						= 						2'b10;
parameter        Right 						= 						2'b11;

reg			[1:0]  Curr_state;
reg			[1:0]  Next_state;							  
							  

//è¿™ä¸ªæ¨¡å?—ä¸»è¦?æ˜¯é€šè¿‡ç‰¹å®šçš„æŒ‰é”®è¢«æŒ‰ä¸‹ï¼Œè¿›è€Œæ”¹å?˜å½“å‰?è›‡çš„ç§»åŠ¨æ–¹å?‘
always@(Curr_state or BINL or BINU or BIND or BINR)begin
  case(Curr_state)
               Up:
			       begin
					if(BINL)
						Next_state = Left;/////å½“è›‡æ–¹å?‘å†?ç½‘ä¸Šè¿?è¡Œæ—¶ï¼Œè¿™ä¸ªæ—¶å€™å?ªèƒ½æŒ‰ä¸‹å·¦å?³æŒ‰é”®æ‰?å?¯ä»¥æ”¹å?˜å¯¹åº”çš„æ–¹å?‘
					else if(BINR)
						Next_state = Right;//////å½“å?‘ä¸Šè¿?è¡Œæ—¶ï¼ŒæŒ‰ä¸‹å?³é”®ï¼Œè›‡çš„ç§»åŠ¨æ–¹å?‘æ”¹å?˜æˆ?äº†å?‘å?³ç§»åŠ¨ã€‚ä¸‹é?¢çš„å‡ ä¸ªå?Œæ ·çš„åˆ†æž?
					else
						Next_state = Up;
				   end
			Down:
				begin
					if(BINL)
						Next_state = Left;
					else if(BINR)
						Next_state = Right;
					else
						Next_state = Down;
				end		
			Left:
				begin
					if(BINU)
						Next_state = Up;
					else if(BIND)
						Next_state = Down;
					else
						Next_state = Left;
				end
			
			Right:
				begin
					if(BINU)
						Next_state = Up;
					else if(BIND)
						Next_state = Down;
					else
						Next_state = Right;
				end		
		endcase				   
end
							  
							  
always@(posedge CLK)begin//////è¿™ä¸ªæ˜¯çŠ¶æ€?æœºçš„çŠ¶æ€?æ›´æ–°ã€‚å½“æ—¶é’Ÿä¸Šå?‡æ²¿åˆ°æ?¥è¿›è¡Œæ›´æ–°
	if(RESET)begin
	Curr_state<=Up;
	end
	else begin
	Curr_state<=Next_state;
	end
end						  
/////////////////////////////////////////////////////////////////////
///assignment
/////////////////////////////////////////////////////////////////////
assign  Navigation_State	=	Curr_state;						  
endmodule
