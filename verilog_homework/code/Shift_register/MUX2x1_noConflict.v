`timescale 1ns/1ps
module MUX2x1_noConflict(a,b,s,y);
  
  input a,b,s;
  output y;
  wire y;
  wire notS,notS_a,s_b;

  not #1 N(notS,s);
  and #1 A1(notS_a,notS,a);
  and #1 A2(s_b,s,b);
  and #1 A3(a_b,a,b);
  or  #1 O(y,notS_a,s_b,a_b);

endmodule