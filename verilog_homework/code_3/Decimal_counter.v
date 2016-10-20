`timescale 1ns/1ns
//e. moudule to count the sigIn when enable=1 and clear to 0 when reset=0
module Decimal_counter (sigIn,enable,reset,count);

  input sigIn,enable,reset;
  output reg [15:0] count;      //count[3:0] for the unit,[7:4] for decade,[11:8] for hundreds,[15:12] for thousand

  always @ ( negedge reset or posedge sigIn )
  begin
    if(~reset)
      count[15:0]<=16'd0;       //cleat to zero
    else if(enable)             //start counting
    begin
      if(count[3:0]==4'd9)      //will produce carry
      begin
        count[3:0]<=4'd0;       //set to 0 and send carry to count[7:4]
        if(count[7:4]==4'd9)    //will produce carry
        begin
          count[7:4]<=4'd0;     //set to 0 and send carry to count[11:8]
          if(count[11:8]==4'd9) //will produce carry
          begin
            count[11:8]<=4'd0;  //set to 0 and send carry to count[15:12]
            if(count[15:12]==4'd9)
				count[15:12]<=4'd0;
			else
				count[15:12]<=count[15:12]+4'd1;
          end
          else
            count[11:8]<=count[11:8]+4'd1;
        end
        else
          count[7:4]<=count[7:4]+4'd1;
      end
      else
        count[3:0]<=count[3:0]+4'd1;
    end
  end
  
endmodule