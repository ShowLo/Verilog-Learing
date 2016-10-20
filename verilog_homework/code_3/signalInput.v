`timescale 1ns/1ns
//a. the module that generates the signal to be measured
module signalInput(sysclk,resetb,testmode,sigIn);

	input sysclk;                         //50MHz system clock
	input resetb;                         //asynchronous reset signal
	input [1:0] testmode;                 //use SW1~SW0 to control
	output sigIn;                         //its frequence is chose by testmode
	
	reg sigIn;
	reg [20:0] divide;
	reg [20:0] state;
	
	initial
	begin
		state<=21'd0;
		sigIn<=0;
	end
	
	always @(*)
	begin
		case(testmode)
			2'b00:divide=21'd16000;       //3125Hz
			2'b01:divide=21'd8000;        //6250Hz
			2'b10:divide=21'd1000000;     //50Hz
			2'b11:divide=21'd4000;        //12500Hz
		endcase
	end
	
	always @(posedge sysclk or negedge resetb)
	begin
		if(~resetb)
		begin
			sigIn<=1'b0;
			state<=21'd2;
		end
		else
		begin
			if(state==divide)
				state<=21'd2;
			else
				state<=state+21'd2;
			sigIn<=(state==21'd2)?~sigIn:sigIn;
		end
	end

endmodule