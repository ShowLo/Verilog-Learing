`timescale 1ns / 1ns
//module to test the module UART (sysclk,reset,UART_RX,UART_TX)
module UART_tb;

  reg sysclk,reset,UART_RX;

  initial
  begin
    reset<=0;
	#2 reset<=1;
    sysclk<=0;
    repeat(500000)
      #1 sysclk<=~sysclk;
  end

  initial
  begin
    UART_RX<=1;
    #10416 UART_RX<=0;
    #10416 UART_RX<=1;
	#83328 UART_RX<=1;
	#10416 UART_RX<=0;
    #10416 UART_RX<=1;
    #10416 UART_RX<=0;
	#72912 UART_RX<=1;
  end

  UART uart(.sysclk(sysclk),.reset(reset),.UART_RX(UART_RX),.UART_TX(UART_TX));

endmodule
