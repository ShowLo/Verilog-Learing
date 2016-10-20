`timescale 1ns/1ns
module SynAddCounter_tb;
	
	reg clk,reset;
	wire [6:0]dout;
	
	initial
	begin
		clk<=0;
		repeat(40)
		#55 clk<=~clk;
	end
	
	initial
	begin
		reset<=0;
		#10 reset<=~reset;
		#2000 reset<=~reset;
		#50 reset<=~reset;
	end
	
	AsyAddCounter asyaddcounter(.clk(clk),.reset(reset),.dout(dout));
	
endmodule