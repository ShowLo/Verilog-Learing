`timescale 1ns/1ns
module AsyAddCounter(clk,reset,dout);

	input clk,reset;
	wire [3:0]Q;
	output [6:0]dout;
	wire T2,T3;
	wire notQ0,notQ1,notQ2,notQ3;
	
	not NOT0(notQ0,Q[0]);
	not NOT1(notQ1,Q[1]);
	not NOT2(notQ2,Q[2]);
	not NOT3(notQ3,Q[3]);
	
	SimpleTff Q_0(.notQ(notQ0),.clk(clk),.reset(reset),.Q(Q[0]));
	SimpleTff Q_1(.notQ(notQ1),.clk(notQ0),.reset(reset),.Q(Q[1]));
	SimpleTff Q_2(.notQ(notQ2),.clk(notQ1),.reset(reset),.Q(Q[2]));
	SimpleTff Q_3(.notQ(notQ3),.clk(notQ2),.reset(reset),.Q(Q[3]));
	
	BCD7 bcd7(.din(Q),.dout(dout));
	
endmodule