`timescale 1ns/1ns
//module to test the module Controller (reset,sysclk,RX_DATA,RX_STATUS,TX_STATUS,TX_DATA,TX_EN)
module Controller_tb;

  reg reset,sysclk,RX_STATUS,TX_STATUS;
  wire TX_EN;
  reg [7:0] RX_DATA;
  wire [7:0] TX_DATA;

  initial
  begin
    sysclk<=0;
    repeat(100)
    #1 sysclk<=~sysclk;
  end

  initial
  begin
    RX_DATA[7:0]<=8'd35;
    reset<=1;
    RX_STATUS<=0;
    TX_STATUS<=0;
    #10 RX_STATUS<=1;
	#2 RX_STATUS<=0;
    #10 TX_STATUS<=1;
    #20 TX_STATUS<=0;
	#20 RX_STATUS<=1;
	#2 RX_STATUS<=0;
    #4 TX_STATUS<=1;
    #10 reset<=0;

  end

  Controller c(.reset(reset),.sysclk(sysclk),.RX_DATA(RX_DATA),.RX_STATUS(RX_STATUS),
              .TX_STATUS(TX_STATUS),.TX_DATA(TX_DATA),.TX_EN(TX_EN));

endmodule
