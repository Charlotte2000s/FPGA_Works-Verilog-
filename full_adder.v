// ********************************************************************
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ********************************************************************
//File_name：full_adder.v
//Module_name: full_adder
//Author: Charlotte2000s
//Description: design a full adder and achieve 4 bit plus
//Web: Charlotte2000s.github.io
//
//---------------------------------------------------------------------
//Code Revision History:
//---------------------------------------------------------------------
//Version: | Mod.Date:  |Changes Made:
//V1.0     | 2019.10.13 |Initial ver
//---------------------------------------------------------------------
//Fuction: 设计一个全加器，并用该全加器实现4位串行进位加法器。
//Improvement: Pro: 用七段数码管显示两个加数，按键显示相加的结果

module full_adder(rst, clk, show, calc, sum, cnt, segdata, segled1, segled2);
	input clk;
	input rst;
	input calc;
	input show;  //三个按键
	
	//input [3:0] num1, num2;   //两个输入数
	//数码管显示   
	input [3:0] segdata;     //第一个数码管对应十六进制数
	//input [3:0] segdata2;     //第二个数码管对应十六进制数
	
	wire [3:0] c_temp;
	
	
	
	output [3:0] sum;
	output  cnt;
	
	reg  c_in = 0;
	output [8:0] segled1;
	output [8:0] segled2;
	
	
	reg [8:0] seg [15:0]; 
	
	reg [3:0] sega = 0;
	reg [3:0] segb = 0;
	
	//integer i;
	integer value=2;
	
	add_4 digiadd (.a(sega), .b(segb), .c_in(c_in), .sum(sum), .c_out(cnt));
//数码管显示模块	
	initial
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
		 
	//assign (sega == 0)?(segled1 = seg[0]):(segled1 = seg[segdata1]);       //第一个数码管
	//assign (segb == 0)?(segled2 = seg[0]):(segled2 = seg[segdata2]); 		  //第二个数码管
	assign segled1 = seg[sega];
	assign segled2 = seg[segb];
	
	always@(posedge clk or negedge rst or negedge calc or negedge show)
		begin
			if(!show)
				begin
					if(value%2 == 0)
					begin
						sega <= segdata;
						value <= value+1;
					end
					else
					begin
						segb <= segdata;
						value <= value+1;
					end
				end	
		
			else if(!calc)
				begin
					sega <= cnt;//输出计算结果
					segb <= sum;
				end
			else if(!rst)
				begin
					sega <= 0;  //数据清零
					segb <= 0;
				end
				
		end
		
endmodule


//module add_full(s, count, cin, a, b);
//	input a,b,cin;
//	output s, count;
//	assign s = a^b^c;
//	assign count = (a&b) | ((a|b)&cin);
//endmodule
//		
		
module full_adder_1 (
input a,
input b,
input c_in,
output sum,
output c_out
);
wire S1, T1, T2, T3;

xor x1 (S1, a, b);
xor x2 (Sum, S1, c_in);
and A1 (T3, a, b );
and A2 (T2, b, c_in);
and A3 (T1, a, c_in);
or O1 (c_out, T1, T2, T3 );
endmodule

	
	
module add_4 ( 
input [3:0]a, 
input [3:0]b, 
input c_in, 
output [3:0] sum, 
output c_out 
); 
wire [3:0] c_tmp; 

full_adder_1 i0 ( a[0], b[0], c_in, sum[0], c_tmp[0]); 
full_adder_1 i1 ( a[1], b[1], c_tmp[0], sum[1], c_tmp[1] );  
full_adder_1 i2 ( a[2], b[2], c_tmp[1], sum[2], c_tmp[2] );  
full_adder_1 i3 ( a[3], b[3], c_tmp[2], sum[3], c_tmp[3] );  
assign c_out = c_tmp[3];
endmodule

	
	
	
	
	
	
	
	
		
		
		
		
