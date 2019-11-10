module 74LS374(D,clk,en_able,Q);

input [7:0] D;
input en_able;
input clk;

output [7:0] Q;

wire [7:0] D;
reg [7:0] Q;

always @ ( posedge clk )
begin
  if (en_able==0)
     Q <= D;
  else 
    Q <= 8'bzzzzzzzz;
end

endmodule

