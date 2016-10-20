`timescale 1ns/1ns
module Sequence_detector_sc(clk,reset,in,out,state);

	input clk,reset,in;
	output out;
	output [5:0] state;
	reg [5:0] state;
	
	always @(negedge reset or posedge clk)
	begin
		if(~reset)
			state<=0;
		else
			state<={state[4:0],in};
	end
	
	assign out=state[5]&(~state[4])&state[3]&(~state[2])&state[1]&state[0];

endmodule