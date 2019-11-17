module jk_ff(clk, rst_n, set_n, j, k, q);
	input clk, rst_n， set_n;
	input j,k;
	output q;
	
	reg q;
	
	always@(negedge clk or negedge rst_n or negedge set_n)
		if(!rst_n)
			begin 
				q<=1'b0;
			end
		else if(!set_n)
			begin
				q<=1'b1;
			end
		else
			begin
				case({j,k})
					2'b00: q<=q;
					2'b01: q<=0;
					2'b10: q<=1;
					default: q<=~q;
				endcase
			end
endmodule
