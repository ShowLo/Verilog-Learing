`timescale 1ns/1ns
module Sequence_detector(clk,reset,in,out,state);

	input clk,reset,in;
	output out;
	output [2:0] state;
	reg out;
	reg [2:0] state;
	
	always @(negedge reset or posedge clk)
	begin
		if(~reset)
		begin
			state<=3'b000;
			out<=0;
		end
		else
		begin
			case(state)
			3'b000:
			begin
				if(in==0)
				begin
					state<=3'b000;
					out<=0;
				end
				else
				begin
					state<=3'b100;
					out<=0;
				end
			end
			3'b100:
			begin
				if(in==0)
				begin
					state<=3'b010;
					out<=0;
				end
				else
				begin
					state<=3'b100;
					out<=0;
				end
			end
			3'b010:
			begin
				if(in==0)
				begin
					state<=3'b000;
					out<=0;
				end
				else
				begin
					state<=3'b001;
					out<=0;
				end
			end
			3'b001:
			begin
				if(in==0)
				begin
					state<=3'b110;
					out<=0;
				end
				else
				begin
					state<=3'b100;
					out<=0;
				end
			end
			3'b110:
			begin
				if(in==0)
				begin
					state<=3'b000;
					out<=0;
				end
				else
				begin
					state<=3'b101;
					out<=0;
				end
			end
			3'b101:
			begin
				if(in==0)
				begin
					state<=3'b110;
					out<=0;
				end
				else
				begin
					state<=3'b100;
					out<=1;
				end
			end
			default:
				state<=3'b000;
			endcase
		end
	end

endmodule