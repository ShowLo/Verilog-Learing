`timescale 1ns/1ns
//module to test the module Receiver (UART_RX,BaudRate_clk,reset,RX_DATA,RX_STATUS)
module Receiver_tb;

  reg UART_RX,BaudRate_clk,reset;
  wire [7:0] RX_DATA;
  wire RX_STATUS;

  initial
  begin
    reset<=1;
    BaudRate_clk<=0;
    repeat(1200)
      #1 BaudRate_clk<=~BaudRate_clk;
  end

  initial
  begin
    UART_RX<=1;
    #11 UART_RX<=0;
    #32 UART_RX<=1;
    #32 UART_RX<=0;
    #32 UART_RX<=1;
    #32 UART_RX<=0;
    #32 UART_RX<=1;
    #64 UART_RX<=0;
    #64 UART_RX<=1;
    #160 UART_RX<=0;
    #64 UART_RX<=1;
    #32 UART_RX<=0;
    #32 UART_RX<=1;
    #64 UART_RX<=0;
    #64 UART_RX<=1;
    #100 reset<=0;
  end

  Receiver r(.UART_RX(UART_RX),.BaudRate_clk(BaudRate_clk),
            .reset(reset),.RX_DATA(RX_DATA),.RX_STATUS(RX_STATUS));

endmodule
