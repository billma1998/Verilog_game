`timescale 1ns / 1ps
module VGA_Interface(
			input    wire					clk,
			input    wire   [11:0]			COLOUR_IN,
			output   reg    [9:0]			ADDRH,
			output   reg    [8:0]			ADDRV,
			output   reg    [11:0]			COLOUR_OUT,
			output   reg 			HS,
			output   reg 			VS
					);

					
initial begin
ADDRH=10'd0;
ADDRV=9'd0;
COLOUR_OUT=12'd0;
HS=1'b1;
VS=1'b1;
end

				
parameter      VertTimeToPulseWidthEnd				=10'd2;					
parameter      VertTimeToBackPorchEnd				=10'd31;					
parameter      VertTimeToDispayTimeEnd				=10'd511;					
parameter      VertTimeToFrontPorchEnd				=10'd521;		


parameter      HorzTimeToPulseWidthEnd				=10'd96;					
parameter      HorzTimeToBackPorchEnd				=10'd144;					
parameter      HorzTimeToDispayTimeEnd				=10'd784;					
parameter      HorzTimeToFrontPorchEnd				=10'd800;	


reg [9:0] hcnt=10'd0; 
reg [9:0] vcnt=10'd0; 


reg   	Vaild_x=1'b0;
reg   	Vaild_y=1'b0;
wire   	Vaild;
reg   	Vaild_display=1'b0;





always@(posedge clk )begin
   if(hcnt<HorzTimeToFrontPorchEnd-1)
		hcnt<=hcnt+1'b1;
   else
        hcnt<=10'd0;   
end				



always@(posedge clk)begin
   if(hcnt==HorzTimeToFrontPorchEnd-1)begin
     if(vcnt<VertTimeToFrontPorchEnd-1)
	    vcnt<=vcnt+1'b1;
	 else
        vcnt<=10'd0;	 
   end
   else
       vcnt<=vcnt;
end



always@(posedge clk)begin
   if(hcnt==10'd0)
    HS<=1'b0;
   else if(hcnt==HorzTimeToPulseWidthEnd)
    HS<=1'b1;
   else
    HS<=HS;   
end



always@(posedge clk)begin
   if(vcnt==10'd0)
    VS<=1'b0;
   else if(vcnt==VertTimeToPulseWidthEnd)
    VS<=1'b1;
   else
    VS<=VS;   
end

always@(posedge clk)begin
   if(hcnt==(HorzTimeToBackPorchEnd-1))
    Vaild_x<=1'b1;
   else if(hcnt==HorzTimeToDispayTimeEnd-1)
    Vaild_x<=1'b0;   
end

always@(posedge clk)begin
   if(vcnt==(VertTimeToBackPorchEnd-1))
    Vaild_y<=1'b1;
   else if(vcnt==VertTimeToDispayTimeEnd-1)
    Vaild_y<=1'b0;   
end
assign Vaild=Vaild_x&Vaild_y;

always@(posedge clk)begin
  if(Vaild==1'b1)begin
    ADDRH<=hcnt-(HorzTimeToBackPorchEnd-1);
    ADDRV<=vcnt-(VertTimeToBackPorchEnd-1);
  end
  else begin
    ADDRH<=10'd0;
    ADDRV<=9'd0;
  end
end

always@(posedge clk)begin
 Vaild_display<=Vaild;
 end

always@(posedge clk)begin
  if(!Vaild_display)begin
    COLOUR_OUT<=12'd0;
  end
  else
    COLOUR_OUT<=COLOUR_IN;
end



endmodule
