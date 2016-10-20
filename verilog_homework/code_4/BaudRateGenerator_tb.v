`timescale 1ns/1ns
//module to test the module BaudRateGenerator(sysclk,BaudRate_clk)
module BaudRateGenerator_tb;

  reg sysclk;
  wire BaudRate_clk1,BaudRate_clk2;

  initial
  begin
    sysclk<=0;
    repeat(52080)
    #1 sysclk<=~sysclk;
  end

  BaudRateGenerator #(5208) brg1(.sysclk(sysclk),.BaudRate_clk(BaudRate_clk1));
  BaudRateGenerator #(326) brg2(.sysclk(sysclk),.BaudRate_clk(BaudRate_clk2));

endmodule
