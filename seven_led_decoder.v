//用Verilog HDL设计一个七段显示译码器，该译码器输入为BCD码，输出驱动七段数码管。
//要求：将七段显示译码器封装为模块，然后在顶层模块调用该译码器驱动七段数码管，并在开发板上验证通过。	
// ********************************************************************
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ********************************************************************
// File name    : seven_led_decoder.v
// Module name  : seven_led_decoder
// Author       : Charlotte2000s
// Description  : seven led decoder
// Web          : Charlotte2000s.github.io
// 
// --------------------------------------------------------------------
// Code Revision History : 
// --------------------------------------------------------------------
// Version: |Mod. Date:   |Changes Made:
// V1.0     |2019/10/30   |Initial ver
// --------------------------------------------------------------------


module seven_led_decoder (data_in, seg_led);

input [3:0] data_in;
output [8:0] seg_led;

segment decoder (data_in, seg_led);   //实例化对象

endmodule


module segment (data_in, seg_led);
 
	input [3:0] data_in;						//数码管需要显示0~f十六个数字，所以最少需要4位输入做译码
					
	output [8:0] seg_led;						//在小脚丫上第一个数码管的控制信号  MSB~LSB=DIG、DP、G、F、E、D、C、B、A
 
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
	
 
        assign seg_led = seg[data_in];                         //连续赋值，这样输入不同四位数，就能输出对于译码的16位输出
 
endmodule
