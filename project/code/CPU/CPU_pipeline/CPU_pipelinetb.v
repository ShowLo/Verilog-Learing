`timescale 1ns/1ns
module CPU_pipelinetb;
reg reset,sysclk,UART_RX;
wire [7:0] led;
reg [7:0] switch;
wire [6:0] digi_out1,digi_out2,digi_out3,digi_out4;
wire UART_TX;
reg [7:0] a0,a1;
CPU_pipeline CPU1(sysclk,reset,led,switch,digi_out1,digi_out2,digi_out3,digi_out4,UART_RX,UART_TX);
initial begin
reset=1;
sysclk=0;
UART_RX=1;
a0=8'b00100100;//32
a1=8'b00110000;//48
UART_RX=1;
#23 reset=0;
#23 reset=1;
end
wire sam_clk;
reg Baud_clk;
reg [5:0]count;
reg [8:0] Count;
initial begin
Baud_clk<=0;
count<=0;
Count<=0;
end
Baud_Rate_Generator B1(.sys_clk(sysclk),.reset(reset),.sam_clk(sam_clk));
always@(posedge sam_clk or negedge reset)
begin
if(~reset) begin
Baud_clk<=0;
count<=0;
end
else begin
count<=count+1;
if(count==7) begin
Baud_clk<=~Baud_clk;
count<=0;
end
end
end
always @(posedge Baud_clk) begin
Count <= Count + 1;
if((Count >=10&&Count<20)||Count>=30) begin
UART_RX <= 1;
if(Count == 40)
Count <= 0;
end
else if(Count == 0)
UART_RX <= 0;  
else if(Count == 9)
UART_RX <= 1;
else if(Count>0&&Count<9)
UART_RX <= a0[Count - 1];
else if(Count == 20)
UART_RX <= 0;  
else if(Count == 29)
UART_RX <= 1;
else if(Count>20&&Count<29)
UART_RX <= a1[Count - 21];
end

always #50 sysclk<=~sysclk;
endmodule
