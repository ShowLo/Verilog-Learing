`timescale 1ns/1ps
//the module of ADD/SUB
module AddSub (A,B,ALUFun0,Sign,S,Zero,Overflow,Negative);

input [31:0] A,B;                   //two operands
input ALUFun0,Sign;                 //ALUFun[0] and sign of operation,1 -- signed,0 -- unsigned

output reg [31:0] S;                ///result
output reg Zero,Overflow,Negative;  //bit zone
reg [31:0] Bcomplement;             //twos complement of B
reg beforeB;                        //used in split joint

always @ ( * )
begin
    case (ALUFun0)
        1'b0:                       //ADD
        begin
            if(Sign)                //signed number
            begin
                S = A + B;
                Zero = (S == 0);
                //if the two numbers have the same sign bit and differ from that in the result,Overflow occurs
                Overflow = (A[31] == B[31] && A[31] != S[31]);
                Negative = S[31];
            end
            else                    //unsigned number
            begin
                //if Carry out of MSB exits,Overflow occurs
                {Overflow,S} = {1'b0,A} + {1'b0,B};
                Zero = (S == 0);
                Negative = 0;
            end
        end
        1'b1:                       //SUB
        begin
            {beforeB,Bcomplement} = ~{1'b0,B} + 1'b1;//twos complement
            if(Sign)                //signed number
            begin
                S = A + Bcomplement;
                Zero = (S == 0);
                Overflow = (A[31] == Bcomplement[31] && A[31] != S[31]);
                Negative = S[31];
            end
            else
            begin
                {Overflow,S} = {1'b0,A} + {beforeB,Bcomplement};
                Zero = (S == 0);
                Negative = 0;
            end
        end
        default: ;
    endcase
end

endmodule
