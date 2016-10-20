`timescale 1ns/1ns
//using system clock to generate 16 times the baud rate clock
module BaudRateGenerator(sysclk,BaudRate_clk);

  input sysclk;
  output reg BaudRate_clk;
  reg [12:0] state;

  parameter divide=13'd5208;  //can be changed as a parameter when the module is called

  initial
  begin
    state<=13'd0;
    BaudRate_clk<=0;
  end

  always @ ( posedge sysclk )
  begin
    if(state==divide)
      state<=13'd2;
    else
      state<=state+13'd2;
    BaudRate_clk<=(state==13'd2)?~BaudRate_clk:BaudRate_clk;
  end

endmodule
