`timescale 1ns/1ns
//module to test the module Control
module Control_tb;

  reg signal_1Hz;
  wire enable,reset,lock;

  initial
  begin
    signal_1Hz<=0;
    repeat(33)
    #10 signal_1Hz<=~signal_1Hz;
  end

  Control c(.signal_1Hz(signal_1Hz),.enable(enable),.reset(reset),.lock(lock));

endmodule
