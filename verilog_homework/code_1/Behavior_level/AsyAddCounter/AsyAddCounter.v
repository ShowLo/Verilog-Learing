`timescale 1ns/1ns
module AsyAddCounter(clk,reset,dout);

	input clk,reset;
	reg [3:0]Q;
	output [6:0]dout;
	
	always @(negedge reset or posedge clk)
	begin
		if(~reset)
			Q[0]<=1'b0;
		else
			Q[0]<=~Q[0];
	end
	
	always @(negedge reset or negedge Q[0])
	begin
		if(~reset)
			Q[1]<=1'b0;
		else
			Q[1]<=~Q[1];
	end
	
	always @(negedge reset or negedge Q[1])
	begin
		if(~reset)
			Q[2]<=1'b0;
		else
			Q[2]<=~Q[2];
	end
	
	always @(negedge reset or negedge Q[2])
	begin
		if(~reset)
			Q[3]<=1'b0;
		else
			Q[3]<=~Q[3];
	end

	BCD7 bcd7(.din(Q),.dout(dout));
	
endmodule