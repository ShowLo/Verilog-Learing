module MEM_WB(clk,reset,RegWr_in,RegWr_out,MemToReg_in,MemToReg_out,
	ALUOut_in,ALUOut_out,ReadData_in,ReadData_out,pc_plus_4_in,
	pc_plus_4_out,AddrC_in,AddrC_out);
input clk,reset,RegWr_in;
input [1:0] MemToReg_in;
input [4:0] AddrC_in;
input [31:0] ALUOut_in,ReadData_in,pc_plus_4_in;
output reg RegWr_out;
output reg [1:0] MemToReg_out;
output reg [4:0] AddrC_out;
output reg [31:0] ALUOut_out,ReadData_out,pc_plus_4_out;

always@(posedge clk or negedge reset)
begin
if(~reset) begin
RegWr_out<=1'b0;
MemToReg_out<=2'b00;
ALUOut_out<=32'h00000000;
ReadData_out<=32'h00000000;
pc_plus_4_out<=32'h00000000;
AddrC_out<=32'h00000000;
end
else begin
RegWr_out<=RegWr_in;
MemToReg_out<=MemToReg_in;
ALUOut_out<=ALUOut_in;
ReadData_out<=ReadData_in;
pc_plus_4_out<=pc_plus_4_in;
AddrC_out<=AddrC_in;
end

end
endmodule
