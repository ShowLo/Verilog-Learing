module Controller(sys_clk,clk,reset,RX_DATA,RX_STATUS,TX_DATA,TX_EN,TX_STATUS,MemRd,MemWr,WriteData,ReadData,Addr);
input sys_clk,clk,reset,RX_STATUS,TX_STATUS,MemRd,MemWr;
input [7:0] RX_DATA;
input [31:0] Addr,WriteData;
output reg [31:0] ReadData;
output reg TX_EN=0;
output reg[7:0] TX_DATA=0;

reg [7:0] UART_TXD;
reg [7:0] UART_RXD;
reg [4:0] UART_CON;
always@(*)begin
TX_DATA=UART_TXD;
end
reg temp=0;
always@(posedge clk or negedge reset)
begin
if(~reset) temp<=1;
else temp<=TX_STATUS;
end
wire OVER;
assign OVER=(~temp)&TX_STATUS;
always@(*)
begin
if(MemRd)
begin
case(Addr)
32'h40000018: ReadData={24'h0,UART_TXD};
32'h4000001C: ReadData={24'h0,UART_RXD};
32'h40000020: ReadData={27'h0,UART_CON};
default: ReadData=32'h00000000;
endcase
end
else ReadData=32'h00000000;
end


always@(posedge clk or negedge reset)
begin
if(~reset) begin
TX_EN<=0;
UART_TXD<=8'b0;
UART_CON<=5'b0;
UART_RXD<=8'b0;
end
else begin
if(RX_STATUS)begin
UART_RXD=RX_DATA;
if(UART_CON[1]) UART_CON[3]<=1;
end
if(OVER&&UART_CON[0]) UART_CON[2]<=1;
if(~TX_STATUS) UART_CON[4]<=1;
else UART_CON[4]<=0;
if(MemRd&&Addr==32'h40000020) begin
UART_CON[2]<=0;
if(~RX_STATUS)
UART_CON[3]<=0;
end
if(MemWr)
begin
case(Addr)
32'h40000018:begin
UART_TXD<=WriteData[7:0];
TX_EN<=1;
end
32'h40000020: UART_CON[1:0]<=WriteData[1:0];
default:;
endcase
end
if(TX_EN) TX_EN<=0;
end
end
endmodule
