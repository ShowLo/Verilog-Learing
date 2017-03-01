module EX_MEM(clk,reset,MemRd_in,MemRd_out,MemWr_in,MemWr_out,MemToReg_in,
	MemToReg_out,RegWr_in,RegWr_out,ALUOut_in,ALUOut_out,WriteData_in,
	WriteData_out,pc_plus_4_in,pc_plus_4_out,AddrC_in,AddrC_out,Opcode_in,Opcode_out);
input clk,reset,MemRd_in,MemWr_in,RegWr_in;
input [1:0] MemToReg_in;
input [4:0] AddrC_in;
input [5:0] Opcode_in;
input [31:0] ALUOut_in,WriteData_in,pc_plus_4_in;
output reg MemRd_out,MemWr_out,RegWr_out;
output reg [1:0] MemToReg_out;
output reg [4:0] AddrC_out;
output reg [5:0] Opcode_out;
output reg [31:0] ALUOut_out,WriteData_out,pc_plus_4_out;

always@(posedge clk or negedge reset)
begin
if(~reset) begin
MemRd_out<=1'b0;
MemWr_out<=1'b0;
RegWr_out<=1'b0;
MemToReg_out<=2'b00;
ALUOut_out<=32'h00000000;
WriteData_out<=32'h00000000;
pc_plus_4_out<=32'h00000000;
AddrC_out<=32'h00000000;
Opcode_out<=6'b0;
end

else begin
MemRd_out<=MemRd_in;
MemWr_out<=MemWr_in;
RegWr_out<=RegWr_in;
MemToReg_out<=MemToReg_in;
ALUOut_out<=ALUOut_in;
WriteData_out<=WriteData_in;
pc_plus_4_out<=pc_plus_4_in;
AddrC_out<=AddrC_in;
Opcode_out<=Opcode_in;
end

end
endmodule
