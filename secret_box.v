// ********************************************************************
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ********************************************************************
// File name    : secret_box.v
// Module name  : secret_box
// Author       : Charlotte2000s
// Description  : a safe box
// Web          : Charlotte2000s.github.io
// 
// --------------------------------------------------------------------
// Code Revision History : 
// --------------------------------------------------------------------
// Version: |Mod. Date:   |Changes Made:
// V1.0     |2019/10/7   |Initial ver
// --------------------------------------------------------------------
// Module Function:安全的密码箱
//1.初始状态：四路开关全部归零，开关按键按下锁上密码箱，rgb灯发紫光，led灯为红灯常亮
//2.开箱：拨动四路开关使其对应二进制数等于所设密码，晶体管会显示相应16进制数，按开关键打开
//       rgb灯由紫变蓝，led灯变为呼吸灯闪烁提醒箱子已经打开。若想关闭led闪烁功能，可以按
//		 清除键，此时led会保持常亮，要重新开启的话，打开箱子按清除键开启。
//3.关闭箱子：在拨动四路开关使密码处于错误状态，按开关按键，恢复初始状态。
//4.防盗设计：三次输入密码错误，rgb灯会由紫变白。

module secret_box(rgb_led, led, segdata, rst, clk, segled, key_pulse, ce);
	input [3:0] segdata;  //四位密码
	input clk;            //时钟信号
	input rst;            //复位信号
	input key_pulse;      //开关键
	input ce;             //警报开关键
	
	output led;           //呼吸灯
	output [2:0] rgb_led; //对应的rgb灯
	output [8:0] segled;  //数码管灯
	
	reg [8:0] seg [15:0];
	reg [15:0] cnt;        //密码输入计数器
	reg [1:0] ini_cnt;     //报警模块控制
	reg [2:0] rgb_cnt;    //rgb灯控制
	
	reg [3:0] password = 4'b0110;  //密码设置
	
//segment 模块	
//用于密码的显示

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
		 
	assign segled = seg[segdata];
		
	
	
	//报警模块
	always@(negedge ce)
		begin
			if(segdata != password)   //箱子处于关闭状态，常亮
			begin
				ini_cnt <= 1;          
			end
			else
			begin
				ini_cnt <= 0;          //箱子处于开启状态，对应闪烁提示
			end
		end

		
	//按键确认
	always @ (posedge key_pulse)
		begin
			if (segdata == password) //如果密码正确
			begin
				cnt <= 0;             //次数归0
				rgb_cnt <= 1;         //rgb显示蓝色
			end
			
			else        //密码错误
			begin
				cnt <= cnt + 1;   //错误累计次数加一
				rgb_cnt <= 2;     //调整对应的rgb灯颜色控制
				if (cnt >= 6)     //如果错误三次及以上
					begin
						rgb_cnt <= 0;   //锁死，rgb显示白色
					end
			end
		end


 //breath_led 模块
 
	reg [24:0] cnt1;       //计数器1
	reg [24:0] cnt2;       //计数器2
	reg flag;              //呼吸灯变亮和变暗的标志位
 
	parameter   CNT_NUM = 2400;	//计数器的最大值 period = (2400^2)*2 = 24000000 = 2s
	//产生计数器cnt1
	always@(posedge clk or negedge rst) begin 
		if(!rst) begin
			cnt1<=13'd0;
			end 
                else begin
		     if(cnt1>=CNT_NUM-1) 
                        cnt1<=1'b0;
		     else 
                        cnt1<=cnt1+1'b1; 
                    end
		end
 
	//产生计数器cnt2
	always@(posedge clk or negedge rst) begin 
		if(!rst) begin
			cnt2<=13'd0;
			flag<=1'b0;
			end 
                else begin
		     if(cnt1==CNT_NUM-1) begin              //当计数器1计满时计数器2开始计数加一或减一
			if(!flag) begin                     //当标志位为0时计数器2递增计数，表示呼吸灯效果由暗变亮
				if(cnt2>=CNT_NUM-1)         //计数器2计满时，表示亮度已最大，标志位变高，之后计数器2开始递减
                                    flag<=1'b1;
				else
                                    cnt2<=cnt2+1'b1;
			end else begin                     //当标志位为高时计数器2递减计数
				if(cnt2<=0)                //计数器2级到0，表示亮度已最小，标志位变低，之后计数器2开始递增
                                    flag<=1'b0;
				else 
                                    cnt2<=cnt2-1'b1;
			end
			end
                            else cnt2<=cnt2;              //计数器1在计数过程中计数器2保持不变
			end
			end
 
	//比较计数器1和计数器2的值产生自动调整占空比输出的信号，输出到led产生呼吸灯效果

	assign	led = ((cnt1<cnt2)&(cnt == 0)&(ini_cnt == 0))?1'b1:1'b0;
	assign   rgb_led = rgb_cnt;
	
endmodule
