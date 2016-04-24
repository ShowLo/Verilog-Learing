//测试代码
`timescale 1ns/1ps
module MUX2x1_tb;
  
	reg a,b,s;
	wire y;
	
	initial
	begin
		a<=1;
		b<=1;
		s<=0;
		repeat(5)
		begin
			#20 a<=~a;
			#20 b<=~b;
			#20 s<=~s;
		end
	end
	
	MUX2x1 mux2x1(.a(a),.b(b),.s(s),.y(y));

endmodule