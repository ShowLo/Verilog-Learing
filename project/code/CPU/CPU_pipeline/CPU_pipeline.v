module CPU_pipeline(sysclk,reset,led,switch,digi_out1,digi_out2,digi_out3,digi_out4,UART_RX,UART_TX);
input sysclk,reset;
input [7:0] switch;
input UART_RX;
output UART_TX;
output [6:0] digi_out1,digi_out2,digi_out3,digi_out4;
output [7:0] led;
wire [11:0] digi;
wire [31:0] Instruct;
wire [31:0] pc;
//clk
wire count,clk;
/*
always@(posedge sysclk or negedge reset)
begin
if(~reset)begin
count<=0;
clk<=0;
end
else begin
count<=count+1;
if(count==1)begin
clk<=~clk;
count<=0;
end
end
end
*/
assign clk=sysclk;
//digitube_scan
digitube_scan Scan1(.digi_in(digi),.digi_out1(digi_out1),.digi_out2(digi_out2),.digi_out3(digi_out3),.digi_out4(digi_out4));

//Hazard&Forwarding
wire IF_ID_Flush,ID_EX_Flush,ID_EX_MemRd_out,ID_EX_RegWr_out,ID_EX_ALUSrc1_out,ID_EX_ALUSrc2_out;
wire EX_MEM_RegWr_out,MEM_WB_RegWr_out;
wire PC_Write,IF_ID_Write;
wire [2:0] PCSrc,ID_EX_PCSrc_out;
wire [31:0]IF_ID_Instruct_out;
wire [31:0] ALUOut;
wire [4:0] ID_EX_Rs_out,ID_EX_Rt_out;
wire [4:0] AddrC,EX_MEM_AddrC_out,MEM_WB_AddrC_out;
wire [1:0] ForwardA,ForwardB1,ForwardB2,ForwardJR;
Hazard_Forwarding HF1(.IF_ID_Rs(IF_ID_Instruct_out[25:21]),.IF_ID_Rt(IF_ID_Instruct_out[20:16]),.ID_Rs(IF_ID_Instruct_out[25:21]),.ID_PCSrc(PCSrc),
	.ID_EX_MemRead(ID_EX_MemRd_out),.ID_EX_Rs(ID_EX_Rs_out),.ID_EX_Rt(ID_EX_Rt_out),.ID_EX_RegWrite(ID_EX_RegWr_out),
	.ID_EX_ALUSrc1(ID_EX_ALUSrc1_out),.ID_EX_ALUSrc2(ID_EX_ALUSrc2_out),.ID_EX_PCSrc(ID_EX_PCSrc_out),.EX_ALUOut0(ALUOut[0]),
	.EX_MEM_RegWrite(EX_MEM_RegWr_out),.EX_AddrC(AddrC),.EX_MEM_AddrC(EX_MEM_AddrC_out),.MEM_WB_RegWrite(MEM_WB_RegWr_out),
	.MEM_WB_AddrC(MEM_WB_AddrC_out),.ForwardA(ForwardA),.ForwardB1(ForwardB1),.ForwardB2(ForwardB2),
	.ForwardJR(ForwardJR),.IF_ID_Flush(IF_ID_Flush),.ID_EX_Flush(ID_EX_Flush),.PC_Write(PC_Write),.IF_ID_Write(IF_ID_Write));



//IF_ID
wire [31:0] IF_ID_pc_plus_4_out;
wire [31:0] pc_plus_4;
assign pc_plus_4[30:0]=pc[30:0]+4;
assign pc_plus_4[31]=pc[31];
IF_ID IF_ID1(.clk(clk),.reset(reset),.Instruct_in(Instruct),.Instruct_out(IF_ID_Instruct_out)
	,.pc_plus_4_in(pc_plus_4),.pc_plus_4_out(IF_ID_pc_plus_4_out),.IF_ID_Flush(IF_ID_Flush),
	.IF_ID_Write(IF_ID_Write));

//ID

//Control
wire RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp;
wire [1:0] RegDst,MemToReg;
wire [5:0] ALUFun;
wire IRQ;
//IRQ
wire irqout;
assign IRQ=pc[31]?1'b0:irqout;

Control Control1(.Instruct(IF_ID_Instruct_out),.IRQ(IRQ),.PCSrc(PCSrc),
.RegDst(RegDst),.RegWr(RegWr),
.ALUSrc1(ALUSrc1),.ALUSrc2(ALUSrc2),.ALUFun(ALUFun),
.Sign(Sign),.MemWr(MemWr),.MemRd(MemRd),
.MemToReg(MemToReg),.EXTOp(EXTOp),.LUOp(LUOp));

//RegFile

wire [31:0] DataBusA,DataBusB,DataBusC;

RegFile RegFile1(.reset(reset),.clk(clk),.addr1(IF_ID_Instruct_out[25:21]),
.data1(DataBusA),.addr2(IF_ID_Instruct_out[20:16]),.data2(DataBusB),
.wr(MEM_WB_RegWr_out),.addr3(MEM_WB_AddrC_out),.data3(DataBusC));

//EXT
wire [31:0] EXT32;
assign EXT32=EXTOp?{{16{IF_ID_Instruct_out[15]}},IF_ID_Instruct_out[15:0]}:{16'h0000,IF_ID_Instruct_out[15:0]};

//LU
wire [31:0] LU32;
assign LU32=LUOp?{IF_ID_Instruct_out[15:0],16'h0000}:EXT32;

//JT
wire [31:0] JT;
assign JT={IF_ID_pc_plus_4_out[31:28],IF_ID_Instruct_out[25:0],2'b00};

//ID_EX
wire ID_EX_Sign_out,ID_EX_MemWr_out;
wire [1:0] ID_EX_RegDst_out,ID_EX_MemToReg_out;
wire [4:0] ID_EX_Rd_out,ID_EX_Shamt_out;
wire [5:0] ID_EX_ALUFun_out,ID_EX_Opcode_out;
wire [31:0] ID_EX_LU32_out,ID_EX_EXT32_out,ID_EX_pc_plus_4_out;
wire [31:0] ID_EX_DataBusA_out,ID_EX_DataBusB_out;

ID_EX ID_EX1(.clk(clk),.reset(reset),.flush(ID_EX_Flush),.PCSrc_in(PCSrc),.PCSrc_out(ID_EX_PCSrc_out),
	.RegDst_in(RegDst),.RegDst_out(ID_EX_RegDst_out),
	.RegWr_in(RegWr),.RegWr_out(ID_EX_RegWr_out),.ALUSrc1_in(ALUSrc1),
	.ALUSrc1_out(ID_EX_ALUSrc1_out),.ALUSrc2_in(ALUSrc2),
	.ALUSrc2_out(ID_EX_ALUSrc2_out),.ALUFun_in(ALUFun),.ALUFun_out(ID_EX_ALUFun_out),
	.Sign_in(Sign),.Sign_out(ID_EX_Sign_out),.MemWr_in(MemWr),
	.MemWr_out(ID_EX_MemWr_out),.MemRd_in(MemRd),.MemRd_out(ID_EX_MemRd_out),
	.MemToReg_in(MemToReg),.MemToReg_out(ID_EX_MemToReg_out),.LU32_in(LU32),
	.LU32_out(ID_EX_LU32_out),.pc_plus_4_in(IF_ID_pc_plus_4_out),
	.pc_plus_4_out(ID_EX_pc_plus_4_out),.DataBusA_in(DataBusA),.DataBusA_out(ID_EX_DataBusA_out),
	.DataBusB_in(DataBusB),.DataBusB_out(ID_EX_DataBusB_out),.EXT32_in(EXT32),
	.EXT32_out(ID_EX_EXT32_out),.Rd_in(IF_ID_Instruct_out[15:11]),.Rd_out(ID_EX_Rd_out),
	.Rt_in(IF_ID_Instruct_out[20:16]),.Rt_out(ID_EX_Rt_out),
	.Rs_in(IF_ID_Instruct_out[25:21]),.Rs_out(ID_EX_Rs_out),
	.Shamt_in(IF_ID_Instruct_out[10:6]),.Shamt_out(ID_EX_Shamt_out),
	.Opcode_in(IF_ID_Instruct_out[31:26]),.Opcode_out(ID_EX_Opcode_out));

//EX


//ConBA;
wire [31:0] ConBA;
assign ConBA=ALUOut[0]?(ID_EX_pc_plus_4_out+{ID_EX_EXT32_out[29:0],2'b00}):ID_EX_pc_plus_4_out;

//AddrC
parameter Xp=5'd26;
parameter Ra=5'd31;
assign AddrC=(ID_EX_RegDst_out==2'd0)?ID_EX_Rd_out:
	(ID_EX_RegDst_out==2'd1)?ID_EX_Rt_out:
	(ID_EX_RegDst_out==2'd2)?Ra:Xp;


//ALU
wire [31:0] A,B;
wire [31:0] ALU_in1,ALU_in2;
wire [31:0] jal_out;
assign ALU_in1=ID_EX_ALUSrc1_out?{27'h0,ID_EX_Shamt_out}:ID_EX_DataBusA_out;
assign ALU_in2=ID_EX_ALUSrc2_out?ID_EX_LU32_out:ID_EX_DataBusB_out;
assign A=(ForwardA==2'b10)?jal_out:(ForwardA==2'b01)?DataBusC:ALU_in1;                     
assign B=(ForwardB1==2'b10)?jal_out:(ForwardB1==2'b01)?DataBusC:ALU_in2;                      

ALU ALU1(.A(A),.B(B),.ALUFun(ID_EX_ALUFun_out),.Sign(ID_EX_Sign_out),.Z(ALUOut));
//WriteData
wire [31:0] WriteData;
assign WriteData=(ForwardB2==2'b10)?jal_out:(ForwardB2==2'b01)?DataBusC:ID_EX_DataBusB_out;            
//EX_MEM
wire EX_MEM_MemRd_out,EX_MEM_MemWr_out;
wire [1:0] EX_MEM_MemToReg_out;
wire [5:0] EX_MEM_Opcode_out;
wire [31:0] EX_MEM_ALUOut_out,EX_MEM_WriteData_out,EX_MEM_pc_plus_4_out;

EX_MEM EX_MEM1(.clk(clk),.reset(reset),.MemRd_in(ID_EX_MemRd_out),.MemRd_out(EX_MEM_MemRd_out),
	.MemWr_in(ID_EX_MemWr_out),.MemWr_out(EX_MEM_MemWr_out),.MemToReg_in(ID_EX_MemToReg_out),
	.MemToReg_out(EX_MEM_MemToReg_out),.RegWr_in(ID_EX_RegWr_out),.RegWr_out(EX_MEM_RegWr_out),
	.ALUOut_in(ALUOut),.ALUOut_out(EX_MEM_ALUOut_out),.WriteData_in(WriteData),
	.WriteData_out(EX_MEM_WriteData_out),.pc_plus_4_in(ID_EX_pc_plus_4_out),
	.pc_plus_4_out(EX_MEM_pc_plus_4_out),.AddrC_in(AddrC),.AddrC_out(EX_MEM_AddrC_out),
	.Opcode_in(ID_EX_Opcode_out),.Opcode_out(EX_MEM_Opcode_out));
//MEM

//DataMem
wire [31:0] ReadData;
wire [31:0] Mem_ReadData;
DataMem RAM1(.reset(reset),.clk(clk),.rd(EX_MEM_MemRd_out),.wr(EX_MEM_MemWr_out),.addr(EX_MEM_ALUOut_out),.wdata(EX_MEM_WriteData_out),.rdata(Mem_ReadData));


assign jal_out=(EX_MEM_Opcode_out==6'h3)?EX_MEM_pc_plus_4_out:EX_MEM_ALUOut_out;
//MEM_WB

wire [1:0] MEM_WB_MemToReg_out;
wire [31:0] MEM_WB_ALUOut_out,MEM_WB_ReadData_out,MEM_WB_pc_plus_4_out;

MEM_WB MEM_WB1(.clk(clk),.reset(reset),.RegWr_in(EX_MEM_RegWr_out),.RegWr_out(MEM_WB_RegWr_out),
	.MemToReg_in(EX_MEM_MemToReg_out),.MemToReg_out(MEM_WB_MemToReg_out),
	.ALUOut_in(EX_MEM_ALUOut_out),.ALUOut_out(MEM_WB_ALUOut_out),.ReadData_in(ReadData),
	.ReadData_out(MEM_WB_ReadData_out),.pc_plus_4_in(EX_MEM_pc_plus_4_out),
	.pc_plus_4_out(MEM_WB_pc_plus_4_out),.AddrC_in(EX_MEM_AddrC_out),
	.AddrC_out(MEM_WB_AddrC_out));
//WB
assign DataBusC=(MEM_WB_MemToReg_out==2'b00)? MEM_WB_ALUOut_out:(MEM_WB_MemToReg_out==2'b01)?MEM_WB_ReadData_out:(MEM_WB_MemToReg_out==2'b10)?MEM_WB_pc_plus_4_out:(EX_MEM_pc_plus_4_out-8);
// pc_next need to be set;
//PC
wire [31:0] PC_JR_in;
wire [2:0] PCSRC;
assign PCSRC=(ID_EX_PCSrc_out==3'b001&&ALUOut[0]==1'b1)?ID_EX_PCSrc_out:(PCSrc==3'b001)?3'b000:PCSrc;
assign PC_JR_in=(ForwardJR==2'b11)?DataBusC:(ForwardJR==2'b10)?jal_out:(ForwardJR==2'b01)?ALUOut:DataBusA;
PC PC1(.pc(pc),.reset(reset),.clk(clk),.PCSrc(PCSRC),.ConBA(ConBA),.JT(JT),.DataBusA(PC_JR_in),.ALUOut0(ALUOut[0]),.PC_Write(PC_Write));
//wire [31:0] pc_next;
//assign pc_next=((Instruct[31:26]==6'h01||Instruct[31:26]==6'h04||Instruct[31:26]==6'h05||Instruct[31:26]==6'h06||Instruct[31:26]==6'h07)&&ALUOut[0])?ConBA:(Instruct[31:26]==6'h02)?JT:(Instruct[31:26]==0&&(Instruct[5:0]==6'h8||Instruct[5:0]==6'h9))?DataBusA:pc_plus_4;

//ROM
ROM ROM1(.addr(pc),.data(Instruct));
//Peripheral
wire [31:0] Peripheral_ReadData;
Peripheral Ph1(.reset(reset),.clk(clk),.rd(EX_MEM_MemRd_out),.wr(EX_MEM_MemWr_out),.addr(EX_MEM_ALUOut_out),.wdata(EX_MEM_WriteData_out),
	.rdata(Peripheral_ReadData),.led(led),.switch(switch),.digi(digi),.irqout(irqout));
//UART
wire [31:0] UART_ReadData;
UART UART1(.UART_RX(UART_RX),.sys_clk(sysclk),.clk(clk),.reset(reset),.UART_TX(UART_TX),.MemRd(EX_MEM_MemRd_out),.MemWr(EX_MEM_MemWr_out),
	.WriteData(EX_MEM_WriteData_out),.ReadData(UART_ReadData),.Addr(EX_MEM_ALUOut_out));
assign ReadData=(EX_MEM_ALUOut_out<32'h40000000)? Mem_ReadData:(EX_MEM_ALUOut_out<32'h40000018)?Peripheral_ReadData:UART_ReadData;
endmodule
