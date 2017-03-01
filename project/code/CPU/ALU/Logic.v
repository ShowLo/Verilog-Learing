`timescale 1ns/1ps
module Logic (A,B,ALUFun3to0,S);

    input [31:0] A,B;               //two operands
    input [3:0] ALUFun3to0;         //ALUFun[3:0]

    output reg [31:0] S;            //result

    localparam  AND = 4'b1000,
                OR  = 4'b1110,
                XOR = 4'b0110,
                NOR = 4'b0001,
                MOV = 4'b1010;      //which is written as "A" in the guiding book

    always @ ( * )
    begin
        case(ALUFun3to0)
        AND:
            S <= A & B;
        OR:
            S <= A | B;
        XOR:
            S <= A ^ B;
        NOR:
            S <= ~(A | B);
        MOV:
            S <= A;
        default: ;
        endcase
    end

endmodule
