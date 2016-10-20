`timescale 1ns/1ns
module Receiver (UART_RX,BaudRate_clk,reset,RX_DATA,RX_STATUS);

  input UART_RX,BaudRate_clk,reset;
  output reg [7:0] RX_DATA;
  output reg RX_STATUS;

  reg [7:0] count;               //count the posedge of BaudRate_clk
  reg [3:0] times;               //count the number of sampled_signal
  reg sampled_signal,enable;
  reg [7:0] lock;                //lock RX_DATA before RX_STATUS is valid

  initial
  begin
    count<=8'd1;
    times<=4'd0;
    sampled_signal<=0;
    enable<=0;
    RX_STATUS<=0;
  end

  always @ ( posedge BaudRate_clk or negedge reset )
  begin
    if(~reset)
    begin
      count<=8'd1;
      enable<=0;
    end
    else if(UART_RX==0&&~enable) //start counting
    begin
      enable<=1;
      count<=8'd1;
      times<=4'd0;
    end
    else if(enable)
    begin
      if(count==8'd24||count==8'd40||count==8'd56||count==8'd72
         ||count==8'd88||count==8'd104||count==8'd120||count==8'd136)
        times<=times+4'd1;       //count one more sampled signal
      else ;
      if(count==8'd144)          //have generated 8 sampled signals
        enable<=0;
      else
        count<=count+8'd1;
    end
    else ;
  end

  always @ ( posedge BaudRate_clk )
  begin
    if(enable)                   //enable it to count
    begin
      case(count)
      8'd24,8'd40,8'd56,8'd72,8'd88,8'd104,8'd120,8'd136:
        sampled_signal<=1;       //generate sampled signal,followed by "default" to generate a pulse
      8'd144:
        RX_STATUS<=1;            //have generated 8 sampled signals,followed by "default" and "else" to generate a pulse
      default:
      begin
        sampled_signal<=0;
        RX_STATUS<=0;
      end
      endcase
    end
    else
      RX_STATUS<=0;
  end

  always @ ( posedge sampled_signal )
  begin
    case(times)                  //lock the data before RX_STATUS is valid
    4'd1:lock[0]<=UART_RX;
    4'd2:lock[1]<=UART_RX;
    4'd3:lock[2]<=UART_RX;
    4'd4:lock[3]<=UART_RX;
    4'd5:lock[4]<=UART_RX;
    4'd6:lock[5]<=UART_RX;
    4'd7:lock[6]<=UART_RX;
    4'd8:lock[7]<=UART_RX;
    default: ;
    endcase
  end

  always @ ( posedge RX_STATUS )
    RX_DATA[7:0]<=lock[7:0];     //send the locked data to RX_DATA

endmodule
