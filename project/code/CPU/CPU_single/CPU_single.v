module CPU_single(sysclk,reset,led,switch,digi_out1,digi_out2,digi_out3,digi_out4,UART_RX,UART_TX);
input sysclk,reset;
input [7:0] switch;
input UART_RX;
output UART_TX;
output [6:0] digi_out1,digi_out2,digi_out3,digi_out4;
output [7:0] led;
wire [11:0] digi;
wire [31:0] Instruct;
//clk
reg count,clk;
always@(posedge sysclk or negedge reset)
begin
if(~reset)begin
count=0;
clk=0;
end
else begin
count<=count+1;
if(count==1)begin
clk<=~clk;
count<=0;
end
end
end

//digitube_scan
digitube_scan Scan1(.digi_in(digi),.digi_out1(digi_out1),.digi_out2(digi_out2),.digi_out3(digi_out3),.digi_out4(digi_out4));
//Control
wire RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp;
wire [2:0] PCSrc;
wire [1:0] RegDst,MemToReg;
wire [5:0] ALUFun;
wire IRQ;
wire [31:0] pc;
wire irqout;
assign IRQ=pc[31]?1'b0:irqout;
Control Control1(.Instruct(Instruct),.IRQ(IRQ),.PCSrc(PCSrc),
.RegDst(RegDst),.RegWr(RegWr),
.ALUSrc1(ALUSrc1),.ALUSrc2(ALUSrc2),.ALUFun(ALUFun),
.Sign(Sign),.MemWr(MemWr),.MemRd(MemRd),
.MemToReg(MemToReg),.EXTOp(EXTOp),.LUOp(LUOp));

//RegFile
parameter Xp=5'd26;
parameter Ra=5'd31;
wire [31:0] DataBusA,DataBusB,DataBusC;
wire [4:0] AddrC;
assign AddrC=(RegDst==2'd0)?Instruct[15:11]:
	(RegDst==2'd1)?Instruct[20:16]:
	(RegDst==2'd2)?Ra:Xp;
RegFile RegFile1(.reset(reset),.clk(clk),.addr1(Instruct[25:21]),
.data1(DataBusA),.addr2(Instruct[20:16]),.data2(DataBusB),
.wr(RegWr),.addr3(AddrC),.data3(DataBusC));

//EXT
wire [31:0] EXT32;
assign EXT32=EXTOp?{{16{Instruct[15]}},Instruct[15:0]}:{16'h0000,Instruct[15:0]};

//LU
wire [31:0] LU32;
assign LU32=LUOp?{Instruct[15:0],16'h0000}:EXT32;

wire [31:0] A,B;
assign A=ALUSrc1?{27'h0,Instruct[10:6]}:DataBusA;
assign B=ALUSrc2?LU32:DataBusB;

//ConBA;
wire [31:0] pc_plus_4,ConBA;
assign pc_plus_4[30:0]=pc[30:0]+4;
assign pc_plus_4[31]=pc[31];
assign ConBA=pc_plus_4+{EXT32[29:0],2'b00};

//JT
wire [31:0] JT;
assign JT={pc_plus_4[31:28],Instruct[25:0],2'b00};
//ALU
wire[31:0] ALUOut;
ALU ALU1(.A(A),.B(B),.ALUFun(ALUFun),.Sign(Sign),.Z(ALUOut));
//PC
PC PC1(.pc(pc),.reset(reset),.clk(clk),.PCSrc(PCSrc),.ConBA(ConBA),.JT(JT),.DataBusA(DataBusA),.ALUOut0(ALUOut[0]));
wire [31:0] ReadData;
wire [31:0] pc_next;
assign pc_next=((Instruct[31:26]==6'h01||Instruct[31:26]==6'h04||Instruct[31:26]==6'h05||Instruct[31:26]==6'h06||Instruct[31:26]==6'h07)&&ALUOut[0])?ConBA:(Instruct[31:26]==6'h02)?JT:(Instruct[31:26]==0&&(Instruct[5:0]==6'h8||Instruct[5:0]==6'h9))?DataBusA:pc_plus_4;
assign DataBusC=(MemToReg==2'b00)? ALUOut:(MemToReg==2'b01)?ReadData:pc_next;
//ROM
ROM ROM1(.addr(pc),.data(Instruct));
//DataMem
wire [31:0] Mem_ReadData;
DataMem RAM1(.reset(reset),.clk(clk),.rd(MemRd),.wr(MemWr),.addr(ALUOut),.wdata(DataBusB),.rdata(Mem_ReadData));
//Peripheral
wire [31:0] Peripheral_ReadData;
Peripheral Ph1(.reset(reset),.clk(clk),.rd(MemRd),.wr(MemWr),.addr(ALUOut),.wdata(DataBusB),.rdata(Peripheral_ReadData),.led(led),.switch(switch),.digi(digi),.irqout(irqout));
//UART
wire [31:0] UART_ReadData;
UART UART1(.UART_RX(UART_RX),.sys_clk(sysclk),.clk(clk),.reset(reset),.UART_TX(UART_TX),.MemRd(MemRd),.MemWr(MemWr),.WriteData(DataBusB),.ReadData(UART_ReadData),.Addr(ALUOut));
assign ReadData=(ALUOut<32'h40000000)? Mem_ReadData:(ALUOut<32'h40000018)?Peripheral_ReadData:UART_ReadData;
endmodule
