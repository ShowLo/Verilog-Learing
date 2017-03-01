module ID_EX(clk,reset,flush,PCSrc_in,PCSrc_out,RegDst_in,RegDst_out
	,RegWr_in,RegWr_out,ALUSrc1_in,ALUSrc1_out,ALUSrc2_in,
	ALUSrc2_out,ALUFun_in,ALUFun_out,Sign_in,Sign_out,MemWr_in,
	MemWr_out,MemRd_in,MemRd_out,MemToReg_in,MemToReg_out,LU32_in,
	LU32_out,pc_plus_4_in,pc_plus_4_out,DataBusA_in,DataBusA_out,
	DataBusB_in,DataBusB_out,EXT32_in,EXT32_out,Rd_in,Rd_out,Rt_in,
	Rt_out,Rs_in,Rs_out,Shamt_in,Shamt_out,Opcode_in,Opcode_out);
input clk,reset,flush;
input RegWr_in,ALUSrc1_in,ALUSrc2_in,Sign_in,MemWr_in,MemRd_in;
input [2:0] PCSrc_in;
input [1:0] RegDst_in,MemToReg_in;
input [4:0] Rd_in,Rt_in,Rs_in,Shamt_in;
input [5:0] ALUFun_in,Opcode_in;
input [31:0] LU32_in,EXT32_in,pc_plus_4_in;
input [31:0] DataBusA_in,DataBusB_in;

output reg RegWr_out,ALUSrc1_out,ALUSrc2_out,Sign_out,MemWr_out,MemRd_out;
output reg [2:0] PCSrc_out;
output reg [1:0] RegDst_out,MemToReg_out;
output reg [4:0] Rd_out,Rt_out,Rs_out,Shamt_out;
output reg [5:0] ALUFun_out,Opcode_out;
output reg [31:0] LU32_out,EXT32_out,pc_plus_4_out;
output reg [31:0] DataBusA_out,DataBusB_out;

always@(posedge clk or negedge reset)
begin
if(~reset) begin
RegWr_out<=1'b0;
ALUSrc1_out<=1'b0;
ALUSrc2_out<=1'b0;
Sign_out<=1'b0;
MemWr_out<=1'b0;
MemRd_out<=1'b0;
PCSrc_out<=3'b0;
RegDst_out<=2'b0;
MemToReg_out<=2'b0;
Rd_out<=5'b0;
Rt_out<=5'b0;
Rs_out<=5'b0;
Shamt_out<=5'b0;
ALUFun_out<=6'b0;
LU32_out<=32'h0;
EXT32_out<=32'h0;
pc_plus_4_out<=32'h0;
DataBusA_out<=32'h0;
DataBusB_out<=32'h0;
Opcode_out<=6'b0;
end

else if(flush) begin
RegWr_out<=1'b0;
ALUSrc1_out<=1'b0;
ALUSrc2_out<=1'b0;
Sign_out<=1'b0;
MemWr_out<=1'b0;
MemRd_out<=1'b0;
PCSrc_out<=3'b0;
RegDst_out<=2'b0;
MemToReg_out<=2'b0;
Rd_out<=5'b0;
Rt_out<=5'b0;
Rs_out<=5'b0;
Shamt_out<=5'b0;
ALUFun_out<=6'b0;
LU32_out<=32'h0;
EXT32_out<=32'h0;
//pc_plus_4_out<=32'h0;
pc_plus_4_out<=pc_plus_4_in;
DataBusA_out<=32'h0;
DataBusB_out<=32'h0;
Opcode_out<=6'b0;
end

else begin
RegWr_out<=RegWr_in;
ALUSrc1_out<=ALUSrc1_in;
ALUSrc2_out<=ALUSrc2_in;
Sign_out<=Sign_in;
MemWr_out<=MemWr_in;
MemRd_out<=MemRd_in;
PCSrc_out<=PCSrc_in;
RegDst_out<=RegDst_in;
MemToReg_out<=MemToReg_in;
Rd_out<=Rd_in;
Rt_out<=Rt_in;
Rs_out<=Rs_in;
Shamt_out<=Shamt_in;
ALUFun_out<=ALUFun_in;
LU32_out<=LU32_in;
EXT32_out<=EXT32_in;
pc_plus_4_out<=pc_plus_4_in;
DataBusA_out<=DataBusA_in;
DataBusB_out<=DataBusB_in;
Opcode_out<=Opcode_in;
end
end
endmodule
