`timescale 1ns/1ns
//d. the module that use the 1Hz signal to generate enable,reset and lock signal
module Control(signal_1Hz,enable,reset,lock);

  input signal_1Hz;
  output reg enable,reset,lock;  //Effective when enable=1,reset=0,lock=1
  reg [1:0] count;

  initial
  begin
    enable=0;
    reset=1;
    lock=0;
    count<=2'b00;
  end

  always @(posedge signal_1Hz)
  begin
    if(count==2'b10)
      count<=2'b00;
    else
      count<=count+2'b01;
  end

  always @ (count)
  begin
    case(count)
    2'b00:                       //clear to zero
    begin
      reset<=0;
      enable<=0;
      lock<=1;
    end
    2'b01:                       //count
    begin
      reset<=1;
      enable<=1;
      lock<=0;
    end
    2'b10:                       //latch
    begin
      reset<=1;
      enable<=0;
      lock<=1;
    end
    default:
	begin
      reset<=0;
      enable<=0;
      lock<=1;
    end	
    endcase
  end

endmodule
