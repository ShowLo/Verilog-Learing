`timescale 1ns/1ps
module Shift (A,B,ALUFun1to0,S);

    input [31:0] A,B;
    input [1:0] ALUFun1to0;

    output reg [31:0] S;

    reg [31:0] S_Shift2,S_Shift4,S_Shift8,S_Shift16;

    localparam  SLL = 2'b00,
                SRL = 2'b01,
                SRA = 2'b11;

    always @ ( * )
    begin
        case (ALUFun1to0)           //split into combination of 16/8/4/2/1-bit shift
        SLL:
        begin
            S_Shift16 = (A[4])?{B[15:0],16'b0}:B;
            S_Shift8 = (A[3])?{S_Shift16[23:0],8'b0}:S_Shift16;
            S_Shift4 = (A[2])?{S_Shift8[27:0],4'b0}:S_Shift8;
            S_Shift2 = (A[1])?{S_Shift4[29:0],2'b0}:S_Shift4;
            S = (A[0])?{S_Shift2[30:0],1'b0}:S_Shift2;
        end
        SRL:
        begin
            S_Shift16 = (A[4])?{16'b0,B[31:16]}:B;
            S_Shift8 = (A[3])?{8'b0,S_Shift16[31:8]}:S_Shift16;
            S_Shift4 = (A[2])?{4'b0,S_Shift8[31:4]}:S_Shift8;
            S_Shift2 = (A[1])?{2'b0,S_Shift4[31:2]}:S_Shift4;
            S = (A[0])?{1'b0,S_Shift2[31:1]}:S_Shift2;
        end
        SRA:
        begin
            if(B[31])               //negative number
            begin
                S_Shift16 = (A[4])?{16'b1111_1111_1111_1111,B[31:16]}:B;
                S_Shift8 = (A[3])?{8'b1111_1111,S_Shift16[31:8]}:S_Shift16;
                S_Shift4 = (A[2])?{4'b1111,S_Shift8[31:4]}:S_Shift8;
                S_Shift2 = (A[1])?{2'b11,S_Shift4[31:2]}:S_Shift4;
                S = (A[0])?{1'b1,S_Shift2[31:1]}:S_Shift2;
            end
            else                    //postive number
            begin
                S_Shift16 = (A[4])?{16'b0,B[31:16]}:B;
                S_Shift8 = (A[3])?{8'b0,S_Shift16[31:8]}:S_Shift16;
                S_Shift4 = (A[2])?{4'b0,S_Shift8[31:4]}:S_Shift8;
                S_Shift2 = (A[1])?{2'b0,S_Shift4[31:2]}:S_Shift4;
                S = (A[0])?{1'b0,S_Shift2[31:1]}:S_Shift2;
            end
        end
        default: ;
        endcase
    end

endmodule
