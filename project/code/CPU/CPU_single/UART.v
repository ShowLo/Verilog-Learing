module UART(UART_RX,sys_clk,clk,reset,UART_TX,MemRd,MemWr,WriteData,ReadData,Addr);
input UART_RX,sys_clk,reset,MemRd,MemWr,clk;
input [31:0] Addr,WriteData;
output [31:0] ReadData;
output UART_TX;
wire sam_clk,RX_STATUS,TX_EN,TX_STATUS;
wire [7:0] RX_DATA,TX_DATA;
Baud_Rate_Generator b1(sys_clk,reset,sam_clk);
UART_Receiver r1(clk,sam_clk,reset,UART_RX,RX_STATUS,RX_DATA);
Controller c1(sys_clk,clk,reset,RX_DATA,RX_STATUS,TX_DATA,TX_EN,TX_STATUS,MemRd,MemWr,WriteData,ReadData,Addr);
UART_Sender s1(clk,sam_clk,reset,TX_DATA,TX_EN,TX_STATUS,UART_TX);

endmodule
