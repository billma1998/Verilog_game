`timescale 1ns / 1ps
module LDSR7(
 				input    					  CLK,
				input    					  RESET,
				output      reg    [6:0]	  Random_Data   
         );
initial begin
Random_Data=7'd50;
end

parameter   PRI_DATA    =    7'd50;
integer  i;

always@(posedge CLK)begin
	if(RESET)
	   Random_Data<=PRI_DATA;
	else  begin
    for(i=1;i<7;i=i+1) begin
	Random_Data[i]<=Random_Data[i-1];
	end
	Random_Data[0]<=Random_Data[6]^Random_Data[2];
    end	

end

endmodule
