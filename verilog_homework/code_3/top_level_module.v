`timescale 1ns/1ns
//the top-level module
module top_level_module (testmode,sysclk,modeControl,resetb,Hex0,Hex1,Hex2,Hex3,LEDR);

  input [1:0] testmode;
  input sysclk,modeControl,resetb;

  output [6:0] Hex0,Hex1,Hex2,Hex3;
  output LEDR;

  wire sigIn,sigOut,sig1Hz,enable,reset,lock;
  wire [15:0] count;
  wire [3:0] out0,out1,out2,out3;

  assign LEDR=(modeControl)?1'b1:1'b0;

  signalInput si(.sysclk(sysclk),.resetb(resetb),.testmode(testmode),.sigIn(sigIn));
  Frequence_range fr(.modeControl(modeControl),.sigIn(sigIn),.sigOut(sigOut));
  signal_1Hz s_1(.sysclk(sysclk),.sig1Hz(sig1Hz));
  Control c(.signal_1Hz(sig1Hz),.enable(enable),.reset(reset),.lock(lock));
  Decimal_counter dc(.sigIn(sigOut),.enable(enable),.reset(reset),.count(count));
  Latch_16bits l(.count(count),.lock(lock),.out0(out0),.out1(out1),.out2(out2),.out3(out3));
  Decoding_diplay dd(.out0(out0),.out1(out1),.out2(out2),.out3(out3),.Hex0(Hex0),.Hex1(Hex1),.Hex2(Hex2),.Hex3(Hex3));

endmodule
