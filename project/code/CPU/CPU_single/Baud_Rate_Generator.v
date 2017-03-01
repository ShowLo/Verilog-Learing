module Baud_Rate_Generator(sys_clk,reset,sam_clk);
input sys_clk,reset;
output reg sam_clk;
reg [8:0] count;
initial begin
count=0;
sam_clk=0;
end

always @(posedge sys_clk or negedge reset)
begin
if(~reset)
begin
count<=0;
sam_clk<=0;
end
else begin
if(count==162)
begin
count<=0;
sam_clk<=~sam_clk;
end
else count<=count+1;
end

end
endmodule
