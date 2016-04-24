`timescale 1ns/1ps
module MUX4x1(c0,c1,c2,c3,s0,s1,z);
	
	input c0,c1,c2,c3,s0,s1;
	output z;
	wire c0_c1,c2_c3;
	
	MUX2x1_noConflict M1(.a(c0),.b(c1),.s(s0),.y(c0_c1));
	MUX2x1_noConflict M2(.a(c2),.b(c3),.s(s0),.y(c2_c3));
	MUX2x1_noConflict M(.a(c0_c1),.b(c2_c3),.s(s1),.y(z));
	
endmodule