`timescale 1ns/1ns
module Sender(sysclk,reset,TX_DATA,TX_EN,TX_STATUS,UART_TX);

  input sysclk,reset,TX_EN;
  input [7:0] TX_DATA;
  output reg TX_STATUS,UART_TX;

  reg [7:0] count;

  initial
  begin
    TX_STATUS<=1;
    count<=8'd11;
  end

  always @ ( posedge sysclk)
  begin
    if(TX_EN)                        //start sending data
    begin
      count<=4'd0;                   //start counting
      TX_STATUS<=0;                  //mark that the sender is sending data
    end
    else
    begin
      if(~TX_STATUS)                 //while sendig data
        count<=count+8'd1;           //send one more data
      if(count==8'd9)                //have sent all the 8 data
        TX_STATUS<=1;                //mark that the sender has sent all data
    end
  end
  
  always @ ( count )
  begin
      case(count)                    //send data
      8'd0:UART_TX<=0;
      8'd1:UART_TX<=TX_DATA[0];
      8'd2:UART_TX<=TX_DATA[1];
      8'd3:UART_TX<=TX_DATA[2];
      8'd4:UART_TX<=TX_DATA[3];
      8'd5:UART_TX<=TX_DATA[4];
      8'd6:UART_TX<=TX_DATA[5];
      8'd7:UART_TX<=TX_DATA[6];
      8'd8:UART_TX<=TX_DATA[7];
      8'd9:UART_TX<=1;
	  default:UART_TX<=1;
      endcase
  end

endmodule
