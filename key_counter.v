module key_counter(clk,key,rst,dig,seg);
input clk;
input rst;
input key;
output[7:0]	dig;						  
output[7:0] seg;

reg clk_1s;	//1s计数时钟信号
reg clk_1ms;//1ms扫描时钟信号
reg key_r;		//按键输入寄存器变量
reg cntclk;		//动态扫描计数变量，根据此变量的值来选通位码和显示值

reg[3:0] unit; //个位数
reg[3:0] decade;  //十位数
reg[7:0] seg_r;//段码
reg[7:0] dig_r;//位码
reg[3:0] disp_dat;			
reg[36:0] cnt_1s;//1Hz分频信号计数值
reg[20:0] cnt_1ms;//1kHz分频信号计数值
reg[4:0] cnt;//计数器计数值

assign dig = dig_r;
assign seg = seg_r;


always @(posedge clk)		//分频
begin
  if(cnt_1s >=25000000) begin   cnt_1s <= 1'b0;  clk_1s = ~clk_1s;  end
  else cnt_1s <= cnt_1s + 1'b1;	//计数分频
  
	if(cnt_1ms >= 50000)  begin	  cnt_1ms <= 1'b0;	clk_1k = ~clk_1k;	end
	else cnt_1ms <= cnt_1ms + 1'b1;	//扫描分频
end


always @(posedge clk_1s or negedge rst)		//计数
begin
	key_r <= key;
	if(!rst) 	cnt <= 0;		
	else 
		begin 
		if(!key)  cnt <= 5'd8;		//是否按键清零
		else if(cnt >= 5'd20) cnt <= 1'b0;		//是否到时间
		else cnt <= cnt + 1'b1;		//计数加1
		end
end


always @(posedge clk_1s or negedge rst) 		//赋值
begin
	if(!rst)		begin		unit <= 4'd0;		decade <= 4'd0;		end	//位数清零
	else	begin		unit <= cnt % 10;	decade <= cnt / 10;		end	//位数赋值
end


always @(posedge clk_1ms)		//选择扫描
begin
	cntclk = cntclk + 1'b1;
	case(cntclk)
	1'b0: dig_r <= 8'b10111111;	//位选
	1'b1: dig_r <= 8'b01111111;
	default: dig_r <= 8'b11111111;
	endcase
	case(cntclk)
	1'b0:disp_dat <= unit;
	1'b1:disp_dat <= decade;
	default:disp_dat = 4'h0;
	endcase
end


always @(disp_dat)
begin
	case(disp_dat)						 //段译码    
		4'h0:seg_r = 8'hc0;				//显示0
		4'h1:seg_r = 8'hf9;				//显示1
		4'h2:seg_r = 8'ha4;				//显示2
		4'h3:seg_r = 8'hb0;				//显示3
		4'h4:seg_r = 8'h99;				//显示4
		4'h5:seg_r = 8'h92;				//显示5
		4'h6:seg_r = 8'h82;				//显示6
		4'h7:seg_r = 8'hf8;				//显示7
		4'h8:seg_r = 8'h80;				//显示8
		4'h9:seg_r = 8'h90;				//显示9
		default:seg_r = 8'hc0;		//显示0
	endcase
end

endmodule 

