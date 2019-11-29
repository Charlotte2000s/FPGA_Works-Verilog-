module JK
(input CK
,input RST
,input J
,input K
,output reg Q
);
always@(negedge CK)
if(RST)
    Q<=0;
else
    case({J,K})
    2'b00:Q<=Q;
    2'b01:Q<=1'b0;
    2'b10:Q<=1'b1;
    default:Q<=~Q;
    endcase
endmodule

module jk_counter
(input CK
,input RST
,output[3:0]Q
);
JK FFI(CK,RST,1,1,Q[0]);
JK FFII(Q[0],RST,~Q[3],~Q[3],Q[1]);
JK FFIII(Q[1],RST,1,1,Q[2]);
JK FFIV(Q[0],RST,Q[1]&Q[2],Q[3],Q[3]);
endmodule
