module Control(Instruct,IRQ,PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp);
input[31:0] Instruct;
input IRQ;
output reg RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp;
output reg [2:0] PCSrc;
output reg [1:0] RegDst,MemToReg;
output reg [5:0] ALUFun;

initial begin 
RegWr=0;
ALUSrc1=0;
ALUSrc2=0;
Sign=0;
MemWr=0;
MemRd=0;
EXTOp=0;
LUOp=0;
PCSrc=0;
RegDst=0;
MemToReg=0;
ALUFun=0;
end

always @(*)
begin
if(Instruct[31:26]==0) //R-type j
begin
ALUSrc2=0;
MemWr=0;
MemRd=0;
case(Instruct[5:0])
6'h20:  //add
begin
PCSrc=0;
RegDst=0;
MemToReg=0;
ALUFun=6'b000000;
RegWr=1;
ALUSrc1=0;
Sign=1;
end

6'h21:  //addu
begin
PCSrc=0;
RegDst=0;
MemToReg=0;
ALUFun=6'b000000;
RegWr=1;
ALUSrc1=0;
Sign=0;
end

6'h22:  //sub
begin
PCSrc=0;
RegDst=0;
MemToReg=0;
ALUFun=6'b000001;
RegWr=1;
ALUSrc1=0;
Sign=1;
end

6'h23:  //subu
begin
PCSrc=0;
RegDst=0;
MemToReg=0;
ALUFun=6'b000001;
RegWr=1;
ALUSrc1=0;
Sign=0;
end

6'h24:  //and
begin
PCSrc=0;
RegDst=0;
MemToReg=0;
ALUFun=6'b011000;
RegWr=1;
ALUSrc1=0;
Sign=1;
end

6'h25:  //or
begin
PCSrc=0;
RegDst=0;
MemToReg=0;
ALUFun=6'b011110;
RegWr=1;
ALUSrc1=0;
Sign=1;
end

6'h26:  //xor
begin
PCSrc=0;
RegDst=0;
MemToReg=0;
ALUFun=6'b010110;
RegWr=1;
ALUSrc1=0;
Sign=1;
end

6'h27: //nor
begin
PCSrc=0;
RegDst=0;
MemToReg=0;
ALUFun=6'b010001;
RegWr=1;
ALUSrc1=0;
Sign=1;
end

6'h00: //sll
begin
PCSrc=0;
RegDst=0;
MemToReg=0;
ALUFun=6'b100000;
RegWr=1;
ALUSrc1=1;
Sign=0;
end
  
6'h02:  //srl
begin
PCSrc=0;
RegDst=0;
MemToReg=0;
ALUFun=6'b100001;
RegWr=1;
ALUSrc1=1;
Sign=0;
end

6'h03:  //sra
begin
PCSrc=0;
RegDst=0;
MemToReg=0;
ALUFun=6'b100011;
RegWr=1;
ALUSrc1=1;
Sign=1;
end

6'h2a: //slt
begin
PCSrc=0;
RegDst=0;
MemToReg=0;
ALUFun=6'b110101;
RegWr=1;
ALUSrc1=0;
Sign=1;
end

6'h2b:  //sltu
begin
PCSrc=0;
RegDst=0;
MemToReg=0;
ALUFun=6'b110101;
RegWr=1;
ALUSrc1=0;
Sign=0;
end

6'h8:  //jr
begin
PCSrc=3'b011;
RegDst=0;
MemToReg=0;
ALUFun=6'b000000;
RegWr=0;
ALUSrc1=0;
Sign=1;
end

6'h9:  //jalr
begin
PCSrc=3'b011;
RegDst=2'b10;
MemToReg=2'b10;
ALUFun=6'b000000;
RegWr=1;
ALUSrc1=0;
Sign=1;
end

endcase
end

else  //I-type&J-type
begin
case(Instruct[31:26])
6'h01:  //bltz
begin
PCSrc=3'b001;
RegDst=2'b01;
MemToReg=0;
ALUFun=6'b110101;
RegWr=0;
ALUSrc1=0;
ALUSrc2=0;
Sign=1;
MemWr=0;
MemRd=0;
EXTOp=1;
LUOp=0;
end

6'h02:  //j
begin
PCSrc=3'b010;
RegDst=0;
MemToReg=0;
ALUFun=6'b000000;
RegWr=0;
ALUSrc1=0;
ALUSrc2=1;
Sign=0;
MemWr=0;
MemRd=0;
EXTOp=1;
LUOp=0;
end

6'h03:  //jal
begin
PCSrc=3'b010;
RegDst=2'b10;
MemToReg=2'b10;
ALUFun=6'b000000;
RegWr=1;
ALUSrc1=0;
ALUSrc2=1;
Sign=0;
MemWr=0;
MemRd=0;
EXTOp=1;
LUOp=0;
end

6'h04: //beq
begin
PCSrc=3'b001;
RegDst=2'b01;
MemToReg=0;
ALUFun=6'b110011;
RegWr=0;
ALUSrc1=0;
ALUSrc2=0;
Sign=1;
MemWr=0;
MemRd=0;
EXTOp=1;
LUOp=0;
end

6'h05:  //bne
begin
PCSrc=3'b001;
RegDst=2'b01;
MemToReg=0;
ALUFun=6'b110001;
RegWr=0;
ALUSrc1=0;
ALUSrc2=0;
Sign=1;
MemWr=0;
MemRd=0;
EXTOp=1;
LUOp=0;
end

6'h06:  //blez
begin
PCSrc=3'b001;
RegDst=2'b01;
MemToReg=0;
ALUFun=6'b111101;
RegWr=0;
ALUSrc1=0;
ALUSrc2=0;
Sign=1;
MemWr=0;
MemRd=0;
EXTOp=1;
LUOp=0;
end

6'h07:  //bgtz
begin
PCSrc=3'b001;
RegDst=2'b01;
MemToReg=0;
ALUFun=6'b111111;
RegWr=0;
ALUSrc1=0;
ALUSrc2=0;
Sign=1;
MemWr=0;
MemRd=0;
EXTOp=1;
LUOp=0;
end

6'h08: //addi
begin
PCSrc=0;
RegDst=2'b01;
MemToReg=0;
ALUFun=6'b000000;
RegWr=1;
ALUSrc1=0;
ALUSrc2=1;
Sign=1;
MemWr=0;
MemRd=0;
EXTOp=1;
LUOp=0;
end

6'h09:  //addiu
begin
PCSrc=0;
RegDst=2'b01;
MemToReg=0;
ALUFun=6'b000000;
RegWr=1;
ALUSrc1=0;
ALUSrc2=1;
Sign=0;
MemWr=0;
MemRd=0;
EXTOp=0;
LUOp=0;
end

6'h0a:  //slti
begin
PCSrc=0;
RegDst=2'b01;
MemToReg=0;
ALUFun=6'b110101;
RegWr=1;
ALUSrc1=0;
ALUSrc2=1;
Sign=1;
MemWr=0;
MemRd=0;
EXTOp=1;
LUOp=0;
end

6'h0b:  //sltiu
begin
PCSrc=0;
RegDst=2'b01;
MemToReg=0;
ALUFun=6'b110101;
RegWr=1;
ALUSrc1=0;
ALUSrc2=1;
Sign=0;
MemWr=0;
MemRd=0;
EXTOp=0;
LUOp=0;
end

6'h0c:  //andi
begin
PCSrc=0;
RegDst=2'b01;
MemToReg=0;
ALUFun=6'b011000;
RegWr=1;
ALUSrc1=0;
ALUSrc2=1;
Sign=1;
MemWr=0;
MemRd=0;
EXTOp=1;
LUOp=0;
end

6'h0f:  //lui
begin
PCSrc=0;
RegDst=2'b01;
MemToReg=0;
ALUFun=6'b000000;
RegWr=1;
ALUSrc1=0;
ALUSrc2=1;
Sign=0;
MemWr=0;
MemRd=0;
LUOp=1;
end

6'h23:  //lw
begin
PCSrc=0;
RegDst=2'b01;
MemToReg=2'b01;
ALUFun=6'b000000;
RegWr=1;
ALUSrc1=0;
ALUSrc2=1;
Sign=1;
MemWr=0;
MemRd=1;
EXTOp=1;
LUOp=0;
end

6'h2b:  //sw
begin
PCSrc=0;
RegDst=2'b01;
MemToReg=0;
ALUFun=6'b000000;
RegWr=0;
ALUSrc1=0;
ALUSrc2=1;
Sign=1;
MemWr=1;
MemRd=0;
EXTOp=1;
LUOp=0;
end
default:
begin   //Exception
RegWr=1;
PCSrc=3'b101;
RegDst=2'b11;
MemToReg=2'b11;


end
endcase
end
if(IRQ==1)//interrupt
begin
RegWr=1;
PCSrc=3'b100;
RegDst=2'b11;
MemToReg=2'b11;
end
end
endmodule
