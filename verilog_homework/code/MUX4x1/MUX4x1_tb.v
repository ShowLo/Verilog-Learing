`timescale 1ns/1ps
module MUX4x1_tb;
	reg c0,c1,c2,c3;
	reg s0,s1;
	wire z;
	
	initial
	begin
		c0<=0;
		c1<=0;
		c2<=0;
		c3<=0;
		s0<=0;
		s1<=0;
		repeat(2)
		begin
			#20 c0<=~c0;
			#20 c2<=~c2;
			#20 c1<=~c1;
			#20 c3<=~c3;
		end
	end
	
	initial
	begin
		repeat(3)
			#45 s0<=~s0;
	end
	
	initial
	begin
			#90 s1<=~s1;
	end
	
	MUX4x1 mux4x1(.c0(c0),.c1(c1),.c2(c2),.c3(c3),.s0(s0),.s1(s1),.z(z));
	
endmodule