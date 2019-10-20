// ********************************************************************
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ********************************************************************
// File name    : decode38.v
// Module name  : decode
// Author       : Charlotte2000s
// Description  : segment initial
// Web          : charlotte2000s.github.io
// 
// --------------------------------------------------------------------
// Code Revision History : 
// --------------------------------------------------------------------
// Version: |Mod. Date:   |Changes Made:
// V1.0     |2019/10/20   |Initial ver
// --------------------------------------------------------------------
// Module Function:实现38译码器功能 并实现全加器功能

module decode38(led, sw);
	input [2:0] sw;
	output [7:0] led;
	reg [7:0] led;
	
   always@(sw)
			begin
				case(sw)
					3'b000: led=8'b0111_1111;
					3'b001: led=8'b1011_1111;
					3'b010: led=8'b1101_1111;
					3'b011: led=8'b1110_1111;
					3'b100: led=8'b1111_0111;
					3'b101: led=8'b1111_1011;
					3'b110: led=8'b1111_1101;
					3'b111: led=8'b1111_1110;
					default:;
				endcase
			end
	
endmodule



//另一种38译码器的写法
/*
module decode38(led, sw);
	input [2:0] sw;
	output [7:0] led;
	assign led = ~(1'b1<<sw);
	
endmodule
*/
