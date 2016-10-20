`timescale 1ns/1ns
module Sequence_detector_tb;
	
	reg clk,reset,in;
	wire [2:0] state;
	wire out;
	
	initial
	begin
		clk<=0;
		repeat(67)
		#50 clk<=~clk;
	end
	
	initial
	begin
		reset<=0;
		#60 reset<=~reset;
		#3220 reset<=~reset;
		#100 reset<=~reset;
	end
	
	initial
	begin
	//input00101011010111000101011001010110
		in<=0;
		#400 in<=1;
		#100 in<=0;
		#100 in<=1;
		#100 in<=0;
		#100 in<=1;
		#200 in<=0;
		#100 in<=1;
		#100 in<=0;
		#100 in<=1;
		#300 in<=0;
		#300 in<=1;
		#100 in<=0;
		#100 in<=1;
		#100 in<=0;
		#100 in<=1;
		#200 in<=0;
		#200 in<=1;
		#100 in<=0;
		#100 in<=1;
		#100 in<=0;
		#100 in<=1;
		#200 in<=0;
	end
	
	Sequence_detector sd(.clk(clk),.reset(reset),.in(in),.out(out),.state(state));
	
endmodule