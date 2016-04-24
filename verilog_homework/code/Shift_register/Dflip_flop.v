`timescale 1ns/1ps
module Dflip_flop(D,clk,r,s,Q);
	input D,clk,r,s;
	output Q;
	wire A_2,A_3,A_4,Q,notQ;
	
	nand #1 A1(A_1,s,A_4,A_2);
	nand #1	A2(A_2,A_1,r,clk);
	nand #1 A3(A_3,A_2,clk,A_4);
	nand #1	A4(A_4,A_3,r,D);
	nand #1 A5(Q,s,A_2,notQ);
	nand #1 A6(notQ,Q,r,A_3);
	
endmodule