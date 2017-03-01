`timescale 1ns/1ps
module CMP (Zero,Overflow,Negative,ALUFun3to1,S);

    input Zero,Overflow,Negative;   //bit zone output by ADD/SUB
    input [2:0] ALUFun3to1;         //ALUFun[3:1]

    output reg [31:0] S;            //result

    localparam  EQ  = 3'b001,
                NEQ = 3'b000,
                LT  = 3'b010,
                LEZ = 3'b110,
                LTZ = 3'b101,
                GTZ = 3'b111;

    always @ ( * )
    begin
        case (ALUFun3to1)           //use the result of SUB
            EQ:                     //if(A==B) S=1
                S <= (Zero == 1);
            NEQ:                    //if(A!=B) S=1
                S <= (Zero == 0);
            LT:                     //if(A<B) S=1
                S <= ((Overflow == 1 && Negative == 0) || (Overflow == 0 && Negative == 1));
            LEZ:                    //if(A<=0) S=1
                S <= (Negative == 1 || Zero == 1);
            LTZ:                    //if(A<0) S=1
                S <= (Negative == 1);
            GTZ:                    //if(A>0) S=1
                S <= (Negative == 0 && Zero == 0);
            default: ;
        endcase
    end

endmodule
