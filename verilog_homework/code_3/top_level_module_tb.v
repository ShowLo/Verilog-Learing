`timescale 1ns/1ns
//module to test the module top_level_module(testmode,sysclk,modeControl,resetb,Hex0,Hex1,Hex2,Hex3)
module top_level_module_tb;

  reg [1:0] testmode;
  reg sysclk,modeControl,resetb;
  wire [6:0] Hex0,Hex1,Hex2,Hex3;

  initial
  begin
    testmode<=2'b01;
    modeControl<=0;
    sysclk<=0;
	  resetb<=0;
   	#1 resetb<=1;
    repeat(150000000)
    #1 sysclk<=~sysclk;
  end

  top_level_module tlm(.testmode(testmode),.sysclk(sysclk),.modeControl(modeControl),.resetb(resetb),
                        .Hex0(Hex0),.Hex1(Hex1),.Hex2(Hex2),.Hex3(Hex3));

endmodule
