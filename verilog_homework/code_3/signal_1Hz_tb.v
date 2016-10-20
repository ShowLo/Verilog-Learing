`timescale 1ns/1ns
//module that test the module signal_1Hz
module signal_1Hz_tb;

	reg sysclk;
	wire sig1Hz;
	
	initial                  //simulate the system clock
	begin
		sysclk<=0;
		repeat(200000000)
		#2 sysclk<=~sysclk;
	end
	
	signal_1Hz s1Hz(.sysclk(sysclk),.sig1Hz(sig1Hz));

endmodule