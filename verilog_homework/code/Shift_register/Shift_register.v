`timescale 1ns/1ps
module Shift_register(ResetB,Clk,Load,D,Q);

	input ResetB,Clk,Load;
	input [3:0]D;
	output [3:0]Q;
	wire notQ,M_1,M_2,M_3;
	
	MUX2x1_noConflict M1(.a(Q[0]),.b(D[1]),.s(Load),.y(M_1));
	MUX2x1_noConflict M2(.a(Q[1]),.b(D[2]),.s(Load),.y(M_2));
	MUX2x1_noConflict M3(.a(Q[2]),.b(D[3]),.s(Load),.y(M_3));
	
	Dflip_flop D0(.D(D[0]),.clk(Clk),.r(ResetB),.s(1'b1),.Q(Q[0]));
	Dflip_flop D1(.D(M_1),.clk(Clk),.r(ResetB),.s(1'b1),.Q(Q[1]));
	Dflip_flop D2(.D(M_2),.clk(Clk),.r(ResetB),.s(1'b1),.Q(Q[2]));
	Dflip_flop D3(.D(M_3),.clk(Clk),.r(ResetB),.s(1'b1),.Q(Q[3]));
	
endmodule