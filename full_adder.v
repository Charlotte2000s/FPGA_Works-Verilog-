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

module full_adder(sum, cnt, rst, clk, show, calc, segdata1, segdata2, segled1, segled2);
	input clk;
	input rst;
	input calc;
	input show;  //三个按键
	
	//input [3:0] num1, num2;   //两个输入数
	//数码管显示   
	input [3:0] segdata1;     //第一个数码管对应十六进制数
	input [3:0] segdata2;     //第二个数码管对应十六进制数
	
	wire [3:0] c_temp;
	
	
	
	output [3:0] sum;
	output [3:0] cnt;
	output [8:0] segled1;
	output [8:0] segled2;
	
	
	reg [8:0] seg [15:0]; 
	
	reg sega = 0;
	reg segb = 0;
	
	integer i;
	
	
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
			if(!rst)
				begin
					sega <= 0;  //数据清零
					segb <= 0;
				end
			else if(!calc)
				begin
					//输出计算结果
				end
			else if(!show)
				begin
					for( i=0; i<2; i=i+1)
						begin
						if(i == 0)
							sega <= segdata1;//显示当前的数
						else
							segb <= segdata2;
						end
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
		
		
		
		
		
