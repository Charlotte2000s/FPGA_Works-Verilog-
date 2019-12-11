module basketball_game(clk, rst_n, shota, shotb, show, led_color, seg_led_1, seg_led_2);

input clk, rst_n;
input shota;
input shotb;
input show;

output [2:0] led_color;

reg [2:0] led_color=2;

output [8:0] seg_led_1, seg_led_2;

reg [28:0] cnt1=0;
reg [4:0] stime = 5'd0;
reg [3:0] data1=4'b0000;
reg [3:0] data2=4'b0000;


reg [20:0] pa=0;
reg [20:0] pb=0;

reg [2:0] flag=0;

reg clk_1hz=0;

key_debounce u1(.clk2(clk), .i_key(shota), .o_key(sa));
key_debounce u2(.clk2(clk), .i_key(shotb), .o_key(sb));
key_debounce u3(.clk2(clk), .i_key(rst_n), .o_key(rst));
key_debounce u4(.clk2(clk), .i_key(show), .o_key(show_out));


always@(posedge clk)
	begin
		if(cnt1<5999999)
			cnt1<=cnt1+1'b1;
		else
		begin
			cnt1<=0;
			clk_1hz<=!clk_1hz;
		end
	end
	
always@(negedge sa or negedge rst or negedge show_out)
begin
	if(!rst)
		pa<=0;
	else if(!show_out)
		pa<=pa;
	else if(!sa)
	begin
		if(stime==0 || flag==0)
			pa<=pa;
		else
			pa<=pa+1;
	end
end

always@(negedge sb or negedge rst or negedge show_out)
begin
	if(!rst)
		pb<=0;
	else if(!show_out)
		pb<=pb;
	else if(!sb)
	begin
		if(stime==0 || flag==0)
			pb<=pb;
		else
			pb<=pb+1;
	end
end
	
always@(*)
begin
	if(pa>pb)
		led_color<=1;
	else if(pa<pb)
		led_color<=2;
	else if(pa==pb)
		led_color<=0;
end

always@(posedge clk_1hz or negedge rst )
	begin 
		if(!rst)
			begin
				stime<=5'd3;
				flag<=0;
			end
		else if(stime>1)
			stime<=stime-1;
		else if(flag==0)
			begin
				stime<=5'd10;
				flag<=1;
			end	
		else if(flag==1)
			if(stime==1)
				stime<=0;
	end
	
	
   reg [8:0] seg [15:0];                                            //定义了一个reg型的数组变量，相当于一个16*9的存储器，存储器一共有16个数，每个数有9位宽
 
       initial                                                         //在过程块中只能给reg型变量赋值，Verilog中有两种过程块always和initial
                                                                        //initial和always不同，其中语句只执行一次
	    begin
         seg[0] = 9'h3f;                                           //对存储器中第一个数赋值9'b00_0011_1111,相当于共阴极接地，DP点变低不亮，7段显示数字0
	      seg[1] = 9'h06;                                           //7段显示数字  1
	      seg[2] = 9'h5b;                                           //7段显示数字  2
	      seg[3] = 9'h4f;                                           //7段显示数字  3
	      seg[4] = 9'h66;                                           //7段显示数字  4
	      seg[5] = 9'h6d;                                           //7段显示数字  5
	      seg[6] = 9'h7d;                                           //7段显示数字  6
	      seg[7] = 9'h07;                                           //7段显示数字  7
	      seg[8] = 9'h7f;                                           //7段显示数字  8
	      seg[9] = 9'h6f;                                           //7段显示数字  9
			seg[10] = 9'h77;                                          //7段显示数字  a	
			seg[11] = 9'h7c;                                          //7段显示数字  b
			seg[12] = 9'h39;                                          //7段显示数字  c
			seg[13] = 9'h5e;                                          //7段显示数字  d
			seg[14] = 9'h79;                                          //7段显示数字  e
			seg[15] = 9'h71;                                          //7段显示数字  f
       end
		 
always@(*)	
begin
	if(!show_out)
	begin
		if(!sa)
		begin
			data1<=pa/10;
			data2<=pa%10;
		end
		else if(!sb)
		begin
			data1<=pb/10;
			data2<=pb%10;
		end
	end
	else 
	begin
		data1<=stime/10;
		data2<=stime%10;
	end

end
		 
	assign seg_led_1 = seg[data1];
	assign seg_led_2 = seg[data2];
	


	
endmodule


module key_debounce        //消抖,输入k1,输出k
(    input  clk2,
    input  i_key,
    output  o_key);
reg r_key,  r_key_buf1, r_key_buf2;
 
assign o_key = r_key;
reg[15:0]cnt7;
reg clk_100hz;
always@(posedge clk2)   //12.5mhz分为100hz
begin
if(cnt7<59999)      //12.5mhz/100hz=125000,cnt<[125000/2-1=1]
cnt7=cnt7+1;
else 
begin 
cnt7=0;
clk_100hz=!clk_100hz; 
end
 end
always@(posedge clk_100hz)
begin
   r_key_buf1 <= i_key;
   r_key_buf2 <= r_key_buf1;
   if((r_key_buf1~^r_key_buf2) == 1'b1)    
           r_key <= r_key_buf2;
   else  
           r_key<=0;
end
endmodule


