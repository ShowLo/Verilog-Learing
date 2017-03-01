module IF_ID(clk,reset,Instruct_in,Instruct_out,pc_plus_4_in,pc_plus_4_out,IF_ID_Flush,IF_ID_Write);
input clk,reset;
input IF_ID_Flush,IF_ID_Write;
input [31:0] Instruct_in,pc_plus_4_in;
output reg [31:0] Instruct_out,pc_plus_4_out;
always@(posedge clk or negedge reset)
begin
if(~reset) begin
Instruct_out<=0;
pc_plus_4_out<=0;
end
else if(IF_ID_Flush)begin
Instruct_out<=0;
pc_plus_4_out<=pc_plus_4_in;
//pc_plus_4_out<=0;
end
else if(IF_ID_Write) begin
Instruct_out<=Instruct_in;
pc_plus_4_out<=pc_plus_4_in;
end
end

endmodule
