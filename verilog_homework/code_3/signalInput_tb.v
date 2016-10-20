`timescale 1ns/1ns
module signalInput_tb;

	reg sysclk,resetb;
	reg [1:0] testmode;
	
	initial
	begin
		sysclk<=0;
		resetb<=0;
		testmode<=2'b11;
		#1 resetb<=1;
		#9000 resetb<=0;
	end
	
	initial
	begin
		repeat(10000)
		#1 sysclk<=~sysclk;
	end

	signalInput si(.sysclk(sysclk),.resetb(resetb),.testmode(testmode),.sigIn(sigIn));
	
endmodule