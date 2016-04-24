`timescale 1ns/1ps
module Decoder3_8_tb;
	reg A2,A1,A0;
	wire D7,D6,D5,D4,D3,D2,D1,D0;
	
	initial
	begin
		A0<=0;
		repeat(7)
		  #20 A0<=~A0;
	end
	initial
	begin
		A1<=0;
		repeat(3)
		  #40 A1<=~A1;
	end
	initial
	begin
		A2<=0;
		repeat(2)
		  #80 A2<=~A2;
	end
	
	Decoder3_8 decoder3_8(.A2(A2),.A1(A1),.A0(A0),
	           .D7(D7),.D6(D6),.D5(D5),.D4(D4),
			       .D3(D3),.D2(D2),.D1(D1),.D0(D0));
	
endmodule