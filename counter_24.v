module counter_24(clk, rst, seg_led_1,seg_led_2);

input clk, rst;

output [8:0] seg_led_1, seg_led_2;

reg [28:0] cnt1=0;
reg [4:0] stime = 5'd24;
reg [3:0] data1=4'b0010;
reg [3:0] data2=4'b0100;

reg clk_1hz=0;

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
	
	
always@(posedge clk_1hz or negedge rst)
	begin 
		if(!rst)
			stime<=5'd24;
		else if(stime>0)
			stime<=stime-1;
		else
			stime<=5'd24;
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
	data1<=stime/10;
	data2<=stime%10;
end
		 
	assign seg_led_1 = seg[data1];
	assign seg_led_2 = seg[data2];
	
endmodule
