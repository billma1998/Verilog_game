`timescale 1ns / 1ps
module Target_Generate(
 				input    					  CLK,
				input    					  RESET,
				input              			  Reached_Target,/////这个信�?�表示苹果被�?�了，需�?�?新产生苹果的请求信�?�
				input    wire [14:0]		  Block_Address1,//////因为我们设计了4个障�?物，所以我们产生苹果的时候，是�?能和障�?物�?�?�的，�?然游�?必然失败
				input    wire [14:0]		  Block_Address2,
				input    wire [14:0]		  Block_Address3,
				input    wire [14:0]		  Block_Address4,
				output   reg [14:0]          Random_Target_Address
						);

initial begin
Random_Target_Address={8'd55,7'd13};
end
						
wire    [7:0]    Random_Data_LDSR8;						
wire    [6:0]    Random_Data_LDSR7;	

					
						
always@(posedge CLK)begin
    if(RESET)
	    Random_Target_Address<={8'd55,7'd13};/////�?�?给一个默认的苹果的�?置
	else if((Reached_Target==1'b1)&&(Random_Data_LDSR8>=8'd1)&&(Random_Data_LDSR8<8'd159)&&(Random_Data_LDSR7>=7'd1)&&(Random_Data_LDSR7<7'd119))/////因为我们游�?的范围是框起�?�的，所以新产生的苹果�?置必须�?游�?的框内，这里通过�??标控制一下
       if((Block_Address1[14:7]==Random_Data_LDSR8)&&(Block_Address1[6:0]==Random_Data_LDSR7))begin//////但是我们�?防止产生的�?机�??标刚好和苹果的�?置�?�?�了，所以这里判断一下，如果�?�?�了，我们就移动到它�?边去
        Random_Target_Address[14:7]<=Random_Data_LDSR8+1;   
        Random_Target_Address[6:0]<=Random_Data_LDSR7;   
	   end	
       else if((Block_Address2[14:7]==Random_Data_LDSR8)&&(Block_Address2[6:0]==Random_Data_LDSR7))begin/////和上�?�一样的解释
        Random_Target_Address[14:7]<=Random_Data_LDSR8+1;   
        Random_Target_Address[6:0]<=Random_Data_LDSR7;   
	   end	
       else if((Block_Address3[14:7]==Random_Data_LDSR8)&&(Block_Address3[6:0]==Random_Data_LDSR7))begin
        Random_Target_Address[14:7]<=Random_Data_LDSR8+1;   
        Random_Target_Address[6:0]<=Random_Data_LDSR7;   
	   end	
       else if((Block_Address4[14:7]==Random_Data_LDSR8)&&(Block_Address4[6:0]==Random_Data_LDSR7))begin
        Random_Target_Address[14:7]<=Random_Data_LDSR8+1;   
        Random_Target_Address[6:0]<=Random_Data_LDSR7;   
	   end		   
	   else begin
        Random_Target_Address[14:7]<=Random_Data_LDSR8;   
        Random_Target_Address[6:0]<=Random_Data_LDSR7;  	   
	   end
	else if(Reached_Target)begin/////如果超出范围，就直接�?去一个值，让其回到游�?的�??标范围里�?�
	    if(Random_Data_LDSR8>=160)
		  Random_Target_Address[14:7]<=Random_Data_LDSR8-100;
		else  
          Random_Target_Address[14:7]<=8'd10;  
		  
		if(Random_Data_LDSR7>=119)
          Random_Target_Address[6:0]<=Random_Data_LDSR7-50;	
        else
          Random_Target_Address[6:0]<=8'd15;  		
     end	
end

///////这里我们为了达到�?机的效果，我们 产生的�??标�?置采用了伪�?机�?列，具体你�?�以百度下伪�?机�?列的东西，很多，很容易�?�解的
LDSR8 LDSR8_inst (
    .CLK(CLK), 
    .RESET(RESET), 
    .Random_Data(Random_Data_LDSR8)
    );
LDSR7 LDSR7_inst (
    .CLK(CLK), 
    .RESET(RESET), 
    .Random_Data(Random_Data_LDSR7)
    );	
endmodule
