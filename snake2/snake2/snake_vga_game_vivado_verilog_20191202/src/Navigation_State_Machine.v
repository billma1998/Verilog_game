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
							  

//这个模�?�主�?是通过特定的按键被按下，进而改�?�当�?蛇的移动方�?�
always@(Curr_state or BINL or BINU or BIND or BINR)begin
  case(Curr_state)
               Up:
			       begin
					if(BINL)
						Next_state = Left;/////当蛇方�?��?网上�?行时，这个时候�?�能按下左�?�按键�?�?�以改�?�对应的方�?�
					else if(BINR)
						Next_state = Right;//////当�?�上�?行时，按下�?�键，蛇的移动方�?�改�?��?了�?��?�移动。下�?�的几个�?�样的分�?
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
							  
							  
always@(posedge CLK)begin//////这个是状�?机的状�?更新。当时钟上�?�沿到�?�进行更新
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
