//simplified T flip_flop
`timescale 1ns/1ns
module SimpleTff(notQ,clk,reset,Q);
	
	input notQ,clk,reset;
	output Q;
	reg Q;
	
	always @(negedge reset or posedge clk)
	begin	
		if(!reset) Q<=1'b0;
		else Q<=notQ;
	end
	
endmodule