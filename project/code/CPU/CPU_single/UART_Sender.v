module UART_Sender(sys_clk,sam_clk,reset,TX_DATA,TX_EN,TX_STATUS,UART_TX);
input sys_clk,sam_clk,reset,TX_EN;
input [7:0] TX_DATA;
output reg TX_STATUS=1,UART_TX=1;
reg enable=0;
reg [7:0] count=0;
always@(posedge sys_clk or negedge reset)
begin
if(~reset)begin
enable<=0;
TX_STATUS<=1;
end
else if(TX_EN)begin
enable<=1;
TX_STATUS=0;
end
else if(count==160)begin
enable<=0;
TX_STATUS<=1;
end
end

always@(posedge sam_clk or negedge reset)
begin
if(~reset) count<=0;
else if(enable) count<=count+1;
else count<=0;
end

always@(posedge sam_clk or negedge reset)
begin
if(~reset) UART_TX<=1;
else if(enable) begin
if(count==0) UART_TX<=0;
if(count==16) UART_TX<=TX_DATA[0];
if(count==32) UART_TX<=TX_DATA[1];
if(count==48) UART_TX<=TX_DATA[2];
if(count==64) UART_TX<=TX_DATA[3];
if(count==80) UART_TX<=TX_DATA[4];
if(count==96) UART_TX<=TX_DATA[5];
if(count==112) UART_TX<=TX_DATA[6];
if(count==128) UART_TX<=TX_DATA[7];
if(count==144) UART_TX<=1;
end
else UART_TX<=1;
end
endmodule
