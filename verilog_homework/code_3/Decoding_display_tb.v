`timescale 1ns/1ns
// module to test the module Decoding_diplay(out0,out1,out2,out3,Hex0,Hex1,Hex2,Hex3)
module Decoding_diplay_tb;

  reg [3:0] out0,out1,out2,out3;
  wire [6:0] Hex0,Hex1,Hex2,Hex3;

  initial
  begin
    out0<=9;
    out1<=0;
    out2<=9;
    out3<=0;
    repeat(9)
    begin
      #10 out0<=out0-1;
      out1<=out1+1;
      out2<=out2-1;
      out3<=out3+1;
    end
  end

  Decoding_diplay dd(.out0(out0),.out1(out1),.out2(out2),.out3(out3),.Hex0(Hex0),.Hex1(Hex1),.Hex2(Hex2),.Hex3(Hex3));
  
endmodule
