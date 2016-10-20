`timescale 1ns/1ns
module Tflip_flop(T,clk,reset,Q);

	input T,clk,reset;
	output Q;
	reg Q;
	wire D;
	
	xor XOR(D,T,Q);
	always @(negedge reset or posedge clk)
	begin	
		if(~reset) Q<=1'b0;
		else Q<=D;
	end
	
endmodule