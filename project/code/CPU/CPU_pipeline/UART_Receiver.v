module UART_Receiver(clk,sam_clk,reset,UART_RX,RX_STATUS,RX_DATA);
input clk,sam_clk,reset,UART_RX;
output RX_STATUS;
output reg [7:0] RX_DATA=0;
reg [7:0] count=0;
reg temp=0,enable=0;
wire beginning;

always@(posedge clk or negedge reset)
begin
if(~reset) temp<=0;
else temp<=UART_RX;
end
assign beginning=temp&~UART_RX;

always@(posedge clk or negedge reset)
begin
if(~reset) enable<=0;
else if(beginning) enable<=1;
else if(count==152) enable<=0;
end

always@(posedge sam_clk or negedge reset)
begin
if(~reset) count<=0;
else if(enable) count<=count+1;
else count<=0;
end

always@(posedge sam_clk or negedge reset)
begin
if(~reset) RX_DATA<=8'b00000000;
else if(enable) 
begin
if(count==24) RX_DATA[0]=UART_RX;
if(count==40) RX_DATA[1]=UART_RX;
if(count==56) RX_DATA[2]=UART_RX;
if(count==72) RX_DATA[3]=UART_RX;
if(count==88) RX_DATA[4]=UART_RX;
if(count==104) RX_DATA[5]=UART_RX;
if(count==120) RX_DATA[6]=UART_RX;
if(count==136) RX_DATA[7]=UART_RX;
end
end
reg Ending;
always@(posedge clk or negedge reset)
begin
if(~reset) Ending<=0;
else if(count==152) Ending<=1;
else Ending<=0;
end
reg Temp;
always@(posedge clk or negedge reset)
begin
if(~reset) Temp<=0;
else Temp<=Ending;
end
assign RX_STATUS=~Temp&Ending;
endmodule
