`timescale 1ns/1ns
//module to test the module Frequence_range
module Frequence_range_tb;

	reg sigIn,modeControl;
	wire sigOut;
	
	initial
	begin
		modeControl<=0;            //low range
		#630 modeControl<=1;       //high range
	end
	
	//simulate the sigIn
	initial
	begin
		sigIn<=0;
		repeat(10)
			#50 sigIn<=~sigIn;
		repeat(44)
			#50 sigIn<=~sigIn;
	end

	Frequence_range fr(.modeControl(modeControl),.sigIn(sigIn),.sigOut(sigOut));
	
endmodule