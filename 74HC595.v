module 74HC595(input clk,
					input rst_n,
					output shcp,   //shift clk
					output stcp,   //latch clk
					output seg_data); 

/********************Common code****************/
//------------duan xuan------------------------
parameter 	SEG_NUM0 	= 8'h3f,//c0,
				SEG_NUM1 	= 8'h06,//f9,
				SEG_NUM2 	= 8'h5b,//a4,
				SEG_NUM3 	= 8'h4f,//b0,
				SEG_NUM4 	= 8'h66,//99,
				SEG_NUM5 	= 8'h6d,//92,
				SEG_NUM6 	= 8'h7d,//82,
				SEG_NUM7 	= 8'h07,//F8,
				SEG_NUM8 	= 8'h7f,//80,
				SEG_NUM9 	= 8'h6f,//90,
				SEG_NUMA 	= 8'h77,//88,
				SEG_NUMB 	= 8'h7c,//83,
				SEG_NUMC 	= 8'h39,//c6,
				SEG_NUMD 	= 8'h5e,//a1,
				SEG_NUME 	= 8'h79,//86,
				SEG_NUMF 	= 8'h71;//8e;
			 
//--------------wei xuan----------------------
parameter wei_all = 8'b0000_0000;
	
/****************************seg display data**********************************/
//---------------------data conventer----------------------------
reg [7:0] seg_num;
wire [7:0] wei_data;
assign wei_data = wei_all; 
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
			seg_num <= 1'b0;
		end
	else 
		begin
			case(data)
				8'h0: seg_num <= SEG_NUM0;
				8'h1: seg_num <= SEG_NUM1;
				8'h2: seg_num <= SEG_NUM2;
				8'h3: seg_num <= SEG_NUM3;
				8'h4: seg_num <= SEG_NUM4;
				8'h5: seg_num <= SEG_NUM5;
				8'h6: seg_num <= SEG_NUM6;
				8'h7: seg_num <= SEG_NUM7;
				8'h8: seg_num <= SEG_NUM8;
				8'h9: seg_num <= SEG_NUM9;
				8'ha: seg_num <= SEG_NUMA;
				8'hb: seg_num <= SEG_NUMB;
				8'hc: seg_num <= SEG_NUMC;
				8'hd: seg_num <= SEG_NUMD;
				8'he: seg_num <= SEG_NUME;
				8'hf: seg_num <= SEG_NUMF;
				default: seg_num <= SEG_NUM0;
			endcase
		end
end

//------------------1s counter-----------------------
reg [31:0] cnt;
reg [7:0] data;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
			cnt <= 1'b0;
			data <= 1'b0;
		end
	else if(cnt==32'd50000000)
		begin
			cnt <= 1'b0;
			if(data==8'hf)
				data <= 1'b0;
			else
				data <= data + 1'b1;
		end
	else
		cnt <= cnt + 1'b1;
end	

/*****************************seg driver*************************************/
//---------------shift clk----------------------
reg [2:0] cnt_st;
reg shcp_r;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
			cnt_st <= 1'b0;
			shcp_r <= 1'b1;
		end
	else if(cnt_st==3'd4)
		begin
			cnt_st <= 3'd0;
			shcp_r <= ~shcp_r;      //10M
		end
	else
		cnt_st <= cnt_st + 1'b1;
end

//--------------------capture the shift clk trailing edge----------------------
reg shcp_r0,shcp_r1;
wire shcp_flag;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
			shcp_r0 <= 1'b1;
			shcp_r1 <= 1'b1;
		end
	else
		begin
			shcp_r0 <= shcp_r;
			shcp_r1 <= shcp_r0;
		end
end 

assign shcp_flag = (~shcp_r0 && shcp_r1) ? 1'b1:1'b0;  //shcp_clk negedge
			
//-----------------------------seg display state----------------------------
reg [4:0] state;
reg stcp_r;
reg seg_data_r;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
			state <= 1'b0;
			stcp_r <= 1'b1;
			seg_data_r <= 1'b0;
		end
	else if(shcp_flag)
		begin
			case(state)
				//--------------------duan xuan--------------------------
				5'd0:	begin
							seg_data_r <= seg_num[7];
							stcp_r <= 1'b1;							
							state <= state + 1'b1;
						end
				5'd1: begin
							seg_data_r <= seg_num[6];
							state <= state + 1'b1;
						end
				5'd2: begin
							seg_data_r <= seg_num[5];
							state <= state + 1'b1;
						end
				5'd3: begin
							seg_data_r <= seg_num[4];
							state <= state + 1'b1;
						end
				5'd4: begin
							seg_data_r <= seg_num[3];
							state <= state + 1'b1;
						end
				5'd5: begin
							seg_data_r <= seg_num[2];
							state <= state + 1'b1;
						end
				5'd6: begin
							seg_data_r <= seg_num[1];
							state <= state + 1'b1;
						end
				5'd7: begin
							seg_data_r <= seg_num[0];
							state <= state + 1'b1;
						end
				5'd8:	begin
							seg_data_r <= seg_num[7];
							stcp_r <= 1'b1;							
							state <= state + 1'b1;
						end
				5'd9: begin
							seg_data_r <= seg_num[6];
							state <= state + 1'b1;
						end
				5'd10: begin
							seg_data_r <= seg_num[5];
							state <= state + 1'b1;
						end
				5'd11: begin
							seg_data_r <= seg_num[4];
							state <= state + 1'b1;
						end
				5'd12: begin
							seg_data_r <= seg_num[3];
							state <= state + 1'b1;
						end
				5'd13: begin
							seg_data_r <= seg_num[2];
							state <= state + 1'b1;
						end
				5'd14: begin
							seg_data_r <= seg_num[1];
							state <= state + 1'b1;
						end
				5'd15: begin
							seg_data_r <= seg_num[0];
							state <= state + 1'b1;
						 end
				//-----------------------wei xuan------------------------------
				5'd16: begin
							seg_data_r <= wei_data[0];
							state <= state + 1'b1;
						end
				5'd17: begin
							seg_data_r <= wei_data[1];
							state <= state + 1'b1;
						end
				5'd18: begin
							seg_data_r <= wei_data[2];
							state <= state + 1'b1;
						 end
				5'd19: begin
							seg_data_r <= wei_data[3];
							state <= state + 1'b1;
						 end
				5'd20: begin
							seg_data_r <= wei_data[4];
							state <= state + 1'b1;
						 end
				5'd21: begin
							seg_data_r <= wei_data[5];
							state <= state + 1'b1;
						 end
				5'd22: begin
							seg_data_r <= wei_data[6];
							state <= state + 1'b1;
						 end
				5'd23: begin
							seg_data_r <= wei_data[7];
							stcp_r <= 1'b0;    //latch the all data
							state <= 1'b0;
						 end
				default: state <= 5'bxxxxx;
			endcase	
		end
end

assign shcp = shcp_r1;  //output to drive 74HC595 shift reg
assign stcp = stcp_r;  //output to drive 74HC595 latch reg
assign seg_data = seg_data_r;  
			
endmodule
