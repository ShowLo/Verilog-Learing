`timescale 1ns/1ns

module ALU (A,B,ALUFun,Sign,Z);

    input [31:0] A,B;                   //two operand for ALU
    input [5:0] ALUFun;                 //control the function of ALU
    input Sign;                         //sign of operation,1 -- signed,0 -- unsigned

    output reg [31:0] Z;                //the result of ALU

    wire Zero,Overflow,Negative;        //bit zone output by ADD/SUB
    wire [31:0] S_AddSub;               //result of ADD/SUB
    wire [31:0] S_CMP;                  //result of CMP
    wire [31:0] S_Logic;                //result of Logic
    wire [31:0] S_Shift;                //result of Shift

    localparam  AddSub = 2'b00,
                Logic  = 2'b01,
                Shift  = 2'b10,
                CMP    = 2'b11;

    AddSub addsub(.A(A),.B(B),.ALUFun0(ALUFun[0]),.Sign(Sign),.S(S_AddSub),
                  .Zero(Zero),.Overflow(Overflow),.Negative(Negative));
    CMP cmp(.Zero(Zero),.Overflow(Overflow),.Negative(Negative),
            .ALUFun3to1(ALUFun[3:1]),.S(S_CMP));
    Logic logic(.A(A),.B(B),.ALUFun3to0(ALUFun[3:0]),.S(S_Logic));
    Shift shift(.A(A),.B(B),.ALUFun1to0(ALUFun[1:0]),.S(S_Shift));

    always @(*)
    begin
        case(ALUFun[5:4])
        AddSub:
            Z = S_AddSub;
        CMP:
            Z = S_CMP;
        Logic:
            Z = S_Logic;
        Shift:
            Z = S_Shift;
        endcase
    end

endmodule
