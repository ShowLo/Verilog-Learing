`timescale 1ns / 1ns
//top module
module UART (sysclk,reset,UART_RX,UART_TX);

  input sysclk,reset,UART_RX;
  output UART_TX;

  wire clk_9600,clk_9600_16,RX_STATUS,TX_STATUS,TX_EN;
  wire [7:0] RX_DATA,TX_DATA;

  BaudRateGenerator #(326) Clk_9600_16(.sysclk(sysclk),.BaudRate_clk(clk_9600_16));
  BaudRateGenerator #(5208) Clk_9600(.sysclk(sysclk),.BaudRate_clk(clk_9600));
  Receiver r(.UART_RX(UART_RX),.BaudRate_clk(clk_9600_16),
            .reset(reset),.RX_DATA(RX_DATA),.RX_STATUS(RX_STATUS));
  Controller c(.reset(reset),.sysclk(clk_9600),.RX_DATA(RX_DATA),.RX_STATUS(RX_STATUS),
              .TX_STATUS(TX_STATUS),.TX_DATA(TX_DATA),.TX_EN(TX_EN));
  Sender s(.sysclk(clk_9600),.reset(reset),.TX_DATA(TX_DATA),
            .TX_EN(TX_EN),.TX_STATUS(TX_STATUS),.UART_TX(UART_TX));

endmodule
