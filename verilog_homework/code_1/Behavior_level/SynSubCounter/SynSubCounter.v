`timescale 1ns/1ns
module SynSubCounter(clk,reset,dout);

	input clk,reset;
	output [6:0] dout;
	reg [3:0] Q;
	
	always @(negedge reset or posedge clk)
	begin
		if(~reset)
			Q<=4'b0000;
		else
		begin
			if(Q==4'b0000)
				Q<=4'b1111;
			else
				Q<=Q-1;
		end
	end
	
	BCD7 bcd7(.din(Q),.dout(dout));

endmodule