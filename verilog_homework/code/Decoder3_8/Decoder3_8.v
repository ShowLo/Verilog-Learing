`timescale 1ns/1ps
module Decoder3_8(A2,A1,A0,D7,D6,D5,D4,D3,D2,D1,D0);
	
	input A2,A1,A0;
	output D7,D6,D5,D4,D3,D2,D1,D0;
	wire D7,D6,D5,D4,D3,D2,D1,D0;
	wire notA0,notA1,notA2;
	
	not notA_0(notA0,A0);
	not notA_1(notA1,A1);
	not notA_2(notA2,A2);

	and D_7(D7,A2,A1,A0);
	and D_6(D6,A2,A1,notA0);
	and D_5(D5,A2,notA1,A0);
	nor D_4(D4,notA2,A1,A0);
	and D_3(D3,notA2,A1,A0);
	nor D_2(D2,A2,notA1,A0);
	nor D_1(D1,A2,A1,notA0);
	nor D_0(D0,A2,A1,A0);
	
endmodule