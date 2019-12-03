`timescale 1ns / 1ps
module clk_div(
          input     		clk,
          output  reg  		CLK_25M
			 );
initial begin
CLK_25M=1'b0;
end			 

reg [3:0] counter=4'd0;

always@(posedge clk)begin
  if(counter==1'b1)begin
  counter<=4'd0;
  CLK_25M<=!CLK_25M;
  end
  else begin
  counter<=counter+1'b1;
  end
end

endmodule
