module dff(clk, d, reset, q);

input clk, d, reset;

output q;

reg q;

always@(posedge clk)

	begin 
	if(reset)
		q <= 1'b0; //时钟边沿到来且有复位信号，触发器被复位
	else
		q <= d;
	end
	
endmodule
