`timescale 1ns/1ns
module SynAddCounter(clk,reset,dout);

	input clk,reset;
	wire [3:0]Q;
	output [6:0]dout;
	wire T2,T3;
	
	and T_2(T2,Q[0],Q[1]);
	and T_3(T3,T2,Q[2]);
	
	Tflip_flop Q_0(.T(1'b1),.clk(clk),.reset(reset),.Q(Q[0]));
	Tflip_flop Q_1(.T(Q[0]),.clk(clk),.reset(reset),.Q(Q[1]));
	Tflip_flop Q_2(.T(T2),.clk(clk),.reset(reset),.Q(Q[2]));
	Tflip_flop Q_3(.T(T3),.clk(clk),.reset(reset),.Q(Q[3]));
	
	BCD7 bcd7(.din(Q),.dout(dout));
	
endmodule