`timescale 1ns/1ns
//b. module that processes the frequence range
module Frequence_range(modeControl,sigIn,sigOut);

	input modeControl;               //control the frequence range
	input sigIn;                     //signal from outside
	output sigOut;                   //signal to be tested
	
	reg [2:0] count;
	reg sigOut_10;                   //10-dividing-frequence signal 
	
	initial 
	begin
		count<=3'd0;
		sigOut_10<=0;
	end
	
	always @(posedge sigIn)
	begin
		if(count==3'd5)              //reset to 1 every 5 posedge
			count<=3'd1;
		else
			count<=count+3'd1;
		sigOut_10<=(count==3'd1)?~sigOut_10:sigOut_10;
	end
	
	assign sigOut=modeControl?sigOut_10:sigIn;
	
endmodule