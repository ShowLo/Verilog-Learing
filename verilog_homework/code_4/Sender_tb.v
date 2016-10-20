`timescale 1ns/1ns
//module to test the module Sender(sysclk,reset,TX_DATA,TX_EN,TX_STATUS,UART_TX)
module Sender_tb;

  reg sysclk,reset,TX_EN;
  reg [7:0] TX_DATA;
  wire TX_STATUS,UART_TX;

  initial
  begin
    sysclk<=0;
    reset<=1;
    TX_DATA[7:0]<=8'h35;
    repeat(70)
    #2 sysclk<=~sysclk;
  end

  initial
  begin
    TX_EN<=0;
    #10 TX_EN<=1;
    #4 TX_EN<=0;
    #44 TX_EN<=1;
    TX_DATA[7:0]<=8'h23;
    #4 TX_EN<=0;
  end

  Sender s(.sysclk(sysclk),.reset(reset),.TX_DATA(TX_DATA),
          .TX_EN(TX_EN),.TX_STATUS(TX_STATUS),.UART_TX(UART_TX));

endmodule
