`timescale 1ns/1ns
//g. module to decode and display
module BCD7 (din,dout);

  input [3:0] din;
  output [6:0] dout;

  assign dout=(din==4'd0)?7'b1000000:
              (din==4'd1)?7'b1111001:
              (din==4'd2)?7'b0100100:
              (din==4'd3)?7'b0110000:
              (din==4'd4)?7'b0011001:
              (din==4'd5)?7'b0010010:
              (din==4'd6)?7'b0000010:
              (din==4'd7)?7'b1111000:
              (din==4'd8)?7'b0000000:
              (din==4'd9)?7'b0010000:7'b0;

endmodule

module Decoding_diplay (out0,out1,out2,out3,Hex0,Hex1,Hex2,Hex3);

  input [3:0] out0,out1,out2,out3;
  output [6:0] Hex0,Hex1,Hex2,Hex3;

  BCD7 hex0(.din(out0),.dout(Hex0));
  BCD7 hex1(.din(out1),.dout(Hex1));
  BCD7 hex2(.din(out2),.dout(Hex2));
  BCD7 hex3(.din(out3),.dout(Hex3));

endmodule
