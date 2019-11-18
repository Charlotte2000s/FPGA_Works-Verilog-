module key_counter(clk, rst, key, seg_led);

input clk, rst;
input key;

output [8:0] seg_led;

reg [3:0] seg_r=4'b0;

reg [8:0] seg [15:0]; 

key_debounce u1(.clk2(clk), .i_key(key), .o_key(key_1));
key_debounce u2(.clk2(clk), .i_key(rst), .o_key(rst_n));

always@(negedge key_1 or negedge rst_n)
begin
	if(!rst_n)
		begin
			seg_r<=4'b0000;
		end
	else if(!key_1)
	begin
		if(seg_r>=4'b1111)
			seg_r<=4'b0000;
		else
			seg_r<=seg_r+1'b1;
	end
end
		
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
	

assign seg_led = seg[seg_r];		
	
endmodule

module key_debounce        //消抖,输入k1,输出k
(    input  clk2,
    input  i_key,
    output  o_key);
reg r_key,  r_key_buf1, r_key_buf2;
 
assign o_key = r_key;
reg[15:0]cnt7;
reg clk_100hz;
always@(posedge clk2)   //12mhz分为100hz
begin
	if(cnt7<59999)      //12mhz/100hz=120000cnt<[1200002-1=59999
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
