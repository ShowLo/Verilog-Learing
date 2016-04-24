`timescale 1ns/1ps
module Dflip_flop_tb;
	
	reg D,clk,r,s;
	wire Q,notQ;
	
	initial
	fork
		D<=0;
		clk<=0;
		repeat(5)
		#77 D<=~D;
		repeat(25)
		#20 clk<=~clk;
	join
	initial
	begin
		r<=1;
		#115 r<=~r;
		#15 r<=~r;
	end
	initial
	begin
		s<=1;
		#190 s<=~s;
		#15 s<=~s;
	end
	
	Dflip_flop dff(.D(D),.clk(clk),.r(r),.s(s),.Q(Q),.notQ(notQ));
	
endmodule