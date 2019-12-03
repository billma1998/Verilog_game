module key_filter(Clk,Rst_n,key_in,key_in_flag);

	input Clk;
	input Rst_n;
	input key_in;
	
	 reg key_flag;
	 output key_in_flag;
	
	localparam
		IDEL		= 4'b0001,
		WAIT0	= 4'b0010;
		
	reg [3:0]state;
	reg [19:0]counter;
	reg cnt_enable;	//使能计数寄存器
	

	
	reg key_sync0,key_sync1;
	wire key_pedge,key_nedge;
	reg time_arrive;//计数满标志信号
	
//使用D触发器存储两个相邻时钟上升沿时外部输入信号（已经同步到系统时钟域中）的电平状态
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		key_sync0 <= 1'b0;
		key_sync1 <= 1'b0;
	end
	else begin
		key_sync0 <= key_in;
		key_sync1 <= key_sync0;	
	end

//产生跳变沿信号	
	assign key_nedge = !key_sync0 & key_sync1;
	assign key_pedge = key_sync0 & (!key_sync1);
	
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		cnt_enable <= 1'b0;
		state <= IDEL;
		key_flag <= 1'b0;
	end
	else begin
		case(state)
			IDEL :
				begin
					key_flag <= 1'b0;
					if(key_nedge)begin
						state <= WAIT0;
						cnt_enable <= 1'b1;
					end
					else
						state <= IDEL;
				end	
			WAIT0:
				if(time_arrive)begin
					key_flag <= 1'b1;
					cnt_enable <= 1'b0;
					state <= IDEL;
				end
				else if(key_pedge)begin
					state <= IDEL;
					cnt_enable <= 1'b0;
				end
				else
					state <= WAIT0;
			default:;		
		endcase	
	end
	
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)
		counter <= 20'd0;
	else if(cnt_enable)
		counter <= counter + 1'b1;
	else
		counter <= 20'd0;
	
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)
		time_arrive <= 1'b0;
	else if(counter == 4999)/////消抖10ms  
		time_arrive <= 1'b1;
	else
		time_arrive <= 1'b0;	


		
assign key_in_flag=key_flag;
endmodule
