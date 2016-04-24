//无静态1冒险
`timescale 1ns/1ps
module MUX2x1_noConflict(a,b,s,y);
  
  input a,b,s;
  output y;
  wire y;
  wire notS,notS_a,s_b;

  not #2 N(notS,s);
  and #2 A1(notS_a,notS,a);
  and #2 A2(s_b,s,b);
  and #2 A3(a_b,a,b);           //添加冗余项消除冒险
  or  #2 O(y,notS_a,s_b,a_b);

endmodule