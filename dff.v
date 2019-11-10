module dff(q,qn,D,clk,set_n,reset_n);
	
  input D,clk,set_n,reset_n;
	
  output q,qn;
	
  reg q,qn;
	
  always@(posedge clk)
      begin
	if(!reset_n)
	    begin q <= 1'b0;
		  qn <= 1'b1;
	    end
	else if(!set_n)
	    begin q <= 1'b1;
		  qn <= 1'b0;
	    end
	else 
	    begin q <= D;
		  qn <= ~D;
	    end
      end
	
endmodule
