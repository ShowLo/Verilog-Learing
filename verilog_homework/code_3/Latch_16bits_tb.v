`timescale 1ns/1ns
//module to test the module Latch_16bits(count,lock,out0,out1,out2,out3)
module Latch_16bits_tb;

  wire [15:0] count;
  reg lock;
  wire [3:0] out0,out1,out2,out3;
  reg sigIn;
  reg reset;
  reg enable;

  initial
  begin
    sigIn<=0;
    reset<=0;
    #10 reset<=1;
    repeat(2006)
      #1 sigIn<=~sigIn;
    #1 reset<=0;
    #2 reset<=1;
    repeat(1100)
      #1 sigIn<=~sigIn;
  end

  initial
  begin
    enable<=0;
    #11 enable<=1;
    #2012 enable<=0;
    #6 enable<=1;
  end

  initial
  begin
    lock<=0;
    repeat(7)
    #500 lock<=~lock;
  end

  Decimal_counter dc(.sigIn(sigIn),.enable(enable),.reset(reset),.count(count));
  Latch_16bits l(.count(count),.lock(lock),.out0(out0),.out1(out1),.out2(out2),.out3(out3));

endmodule
