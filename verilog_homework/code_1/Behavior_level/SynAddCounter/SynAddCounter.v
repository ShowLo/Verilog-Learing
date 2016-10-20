`timescale 1ns/1ns
module SynAddCounter(clk,reset,dout);

	input clk,reset;
	reg [3:0]Q;
	output [6:0]dout;
	
	always @(negedge reset or posedge clk)
	begin
		if(~reset)
			Q<=4'b0000;
		else
		begin
			if(Q==4'b1111)
				Q<=4'b0000;
			else
				Q<=Q+1;
		end
	end

	BCD7 bcd7(.din(Q),.dout(dout));
	
endmodule