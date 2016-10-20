`timescale 1ns/1ns
//f. the module of Latch,output the latch when lock=1,otherwise,output the count[15:0]
module Latch_16bits (count,lock,out0,out1,out2,out3);

  input [15:0] count;
  input lock;
  output [3:0] out0,out1,out2,out3;
  reg [3:0] out0,out1,out2,out3;

  always @ ( * )
  begin
    if(~lock)
      {out3[3:0],out2[3:0],out1[3:0],out0[3:0]}<=count[15:0];
    else
	  {out3[3:0],out2[3:0],out1[3:0],out0[3:0]}<={out3[3:0],out2[3:0],out1[3:0],out0[3:0]};
  end

endmodule
