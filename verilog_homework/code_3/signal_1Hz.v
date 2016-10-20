`timescale 1ns/1ns
//c. module that generates 1Hz signal
module signal_1Hz(sysclk,sig1Hz);

	input sysclk;                //system clock of 50M Hz
	output reg sig1Hz;           //output signal of 1 Hz

	reg [25:0] count;

	initial
	begin
		count<=26'd0;
		sig1Hz<=0;
	end

	always @(posedge sysclk)
	begin
		if(count==26'd50000000)
			count<=26'd2;
		else
			count<=count+26'd2;
		sig1Hz<=(count==26'd2)?~sig1Hz:sig1Hz;
	end

endmodule
