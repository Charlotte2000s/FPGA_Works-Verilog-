module D_ST(q, d, clk, reset, set);//synchronizer trigger
	output q;
	reg q;
	input d,clk,reset,set;
	
	always@(posedge clk)
		begin
			if(reset == 1)
					q <= 0;
			else if(set == 1)
					q <= 1;
			else  
					q <= d;
					
		end
endmodule

