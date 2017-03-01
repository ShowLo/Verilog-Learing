module UARTtb;
reg sys_clk,reset,UART_RX;
wire UART_TX;
reg MemRd,MemWr;
reg [31:0] WriteData,Addr;
wire [31:0] ReadData;
UART u1(UART_RX,sys_clk,reset,UART_TX,MemRd,MemWr,WriteData,ReadData,Addr);
always #5 sys_clk=~sys_clk;
initial begin
sys_clk=0;
reset=1;
MemRd=0;
MemWr=1;
Addr=32'h40000020;
WriteData=32'b11;
#10 MemRd=1;
MemWr=0;
UART_RX=1;
Addr=32'h4000001C;
#52160 UART_RX=1;
#52160 UART_RX=0;
#52160 UART_RX=1;
#52160 UART_RX=0;
#52160 UART_RX=0;
#52160 UART_RX=0;
#52160 UART_RX=1;
#52160 UART_RX=0;
#52160 UART_RX=0;
#52160 UART_RX=1;
#52160 UART_RX=1;
#52160 UART_RX=1;
#52160 UART_RX=0;
#52160 UART_RX=1;
#52160 UART_RX=0;
#52160 UART_RX=1;
#52160 UART_RX=0;
#52160 UART_RX=1;
#52160 UART_RX=0;
#52160 UART_RX=1;
#52160 UART_RX=0;
#52160 UART_RX=1;
#52160 UART_RX=1;

end
endmodule
