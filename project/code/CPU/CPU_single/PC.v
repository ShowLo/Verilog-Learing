module PC(pc,reset,clk,PCSrc,ConBA,JT,DataBusA,ALUOut0);
input clk,reset,ALUOut0;
input [2:0] PCSrc;
input [31:0] DataBusA,ConBA,JT;
output reg [31:0] pc;
wire [31:0] pc_plus_4;
parameter ILLOP=32'h80000004;
parameter XADR=32'h80000008;

assign pc_plus_4[30:0]=pc[30:0]+4;
assign pc_plus_4[31]=pc[31];
always@(posedge clk or negedge reset)
begin
if(~reset) pc<=32'h00000000;
else 
case(PCSrc)
3'd0: pc<=pc_plus_4;
3'd1: pc<=(ALUOut0)?ConBA:pc_plus_4;
3'd2: pc<=JT;
3'd3: pc<=DataBusA;
3'd4: pc<=ILLOP;
3'd5: pc<=XADR;
endcase
end
endmodule
