`timescale 1ns/1ns
//module to test the module Decimal_counter(sigIn,enable,reset,count)
module Decimal_counter_tb;

  reg sigIn,enable,reset;
  wire [15:0] count;

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

  Decimal_counter dc(.sigIn(sigIn),.enable(enable),.reset(reset),.count(count));

endmodule
