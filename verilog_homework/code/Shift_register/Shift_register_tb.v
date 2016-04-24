`timescale 1ns/1ps
module Shift_register_tb;

	reg ResetB,Clk,Load;
	reg [3:0]D;
	wire [3:0]Q;

	initial
	begin
		Clk<=0;
		repeat(33)
		#85 Clk<=~Clk;
	end
	initial
	begin
		ResetB<=1;
		#2000 ResetB<=~ResetB;
		#50 ResetB<=~ResetB;
	end
	initial
	begin
		Load<=0;
		#870 Load<=~Load;
		#100 Load<=~Load;
	end
	initial
	begin
		repeat(2)
		begin
			D[3:0]<=4'b0000;
			repeat(15)
				#95 D[3:0]<=D[3:0]+1;
		end
	end
	
	Shift_register shift_register(.ResetB(ResetB),.Clk(Clk),.Load(Load),.D(D),.Q(Q));
	
endmodule