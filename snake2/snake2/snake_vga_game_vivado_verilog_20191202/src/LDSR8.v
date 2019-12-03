`timescale 1ns / 1ps
module LDSR8(
 				input    					  CLK,
				input    					  RESET,
				output      reg    [7:0]	  Random_Data
			);
initial begin
Random_Data=8'd100;
end

parameter   PRI_DATA    =    8'd10;
integer  i;

always@(posedge CLK)begin
	if(RESET)
	   Random_Data<=PRI_DATA;
	else  begin
    for(i=1;i<8;i=i+1) begin
	Random_Data[i]<=Random_Data[i-1];
	end
	Random_Data[0]<=((Random_Data[7]^Random_Data[3])^Random_Data[2])^Random_Data[1];
    end	

end

endmodule
