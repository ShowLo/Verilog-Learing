`timescale 1ns/1ps
module Hazard_Forwarding (IF_ID_Rs,IF_ID_Rt,ID_Rs,ID_PCSrc,ID_EX_MemRead,ID_EX_Rs,ID_EX_Rt,ID_EX_RegWrite,
                        ID_EX_ALUSrc1,ID_EX_ALUSrc2,ID_EX_PCSrc,EX_ALUOut0,EX_MEM_RegWrite,EX_AddrC,
                        EX_MEM_AddrC,MEM_WB_RegWrite,MEM_WB_AddrC,ForwardA,ForwardB1,ForwardB2,
                        ForwardJR,IF_ID_Flush,ID_EX_Flush,PC_Write,IF_ID_Write);

    input ID_EX_MemRead,ID_EX_RegWrite,ID_EX_ALUSrc1,ID_EX_ALUSrc2,EX_ALUOut0,EX_MEM_RegWrite,
            MEM_WB_RegWrite;
    input [2:0] ID_PCSrc,ID_EX_PCSrc;
    input [4:0] IF_ID_Rs,IF_ID_Rt,ID_Rs,ID_EX_Rs,ID_EX_Rt,EX_AddrC,EX_MEM_AddrC,MEM_WB_AddrC;

    output reg [1:0] ForwardA,ForwardB1,ForwardB2,ForwardJR;
    output IF_ID_Flush,ID_EX_Flush,PC_Write,IF_ID_Write;

    reg IF_ID_Flush_load,IF_ID_Flush_branch,IF_ID_Flush_jump;
    reg ID_EX_Flush_load,ID_EX_Flush_branch,ID_EX_Flush_jump;
    reg PC_Write_load,PC_Write_branch,PC_Write_jump;
    reg IF_ID_Write_load,IF_ID_Write_branch,IF_ID_Write_jump;

    //data association hazard
    always @ ( * )
    begin
        //for ForwardA
        //EX hazard
        if(EX_MEM_RegWrite && (EX_MEM_AddrC != 0) && (EX_MEM_AddrC == ID_EX_Rs) && (ID_EX_ALUSrc1 == 0))
            ForwardA <= 2'b10;       //from EX_MEM
        //MEM hazard
        else if(MEM_WB_RegWrite && (MEM_WB_AddrC != 0) && (EX_MEM_AddrC != ID_EX_Rs || ~EX_MEM_RegWrite)
                && (MEM_WB_AddrC == ID_EX_Rs) && (ID_EX_ALUSrc1 == 0))
            ForwardA <= 2'b01;       //from MEM_WB
        else
            ForwardA <= 2'b00;       //from ID_EX

        //for ForwardB1 and ForwardB2
        //EX hazard
        if(EX_MEM_RegWrite && (EX_MEM_AddrC != 0) && (EX_MEM_AddrC == ID_EX_Rt))
        begin
            ForwardB1 <= (ID_EX_ALUSrc2)?2'b00:2'b10;
            ForwardB2 <= 2'b10;      //from EX_MEM
        end
        //MEM hazard
        else if(MEM_WB_RegWrite && (MEM_WB_AddrC != 0) && (EX_MEM_AddrC != ID_EX_Rt || ~EX_MEM_RegWrite)
                && MEM_WB_AddrC == ID_EX_Rt)
        begin
            ForwardB1 <= (ID_EX_ALUSrc2)?2'b00:2'b01;
            ForwardB2 <= 2'b01;      //from MEM_WB
        end
        else
        begin                       //from ID_EX
            ForwardB1 <= 2'b00;
            ForwardB2 <= 2'b00;
        end
    end

    //Load-use hazard
    always @ ( * )
    begin
        if (ID_EX_MemRead && ((ID_EX_Rt == IF_ID_Rs && IF_ID_Rs != 5'd0)
            || (ID_EX_Rt == IF_ID_Rt && IF_ID_Rt != 5'd0)))
        begin
            IF_ID_Flush_load <= 0;  //hold
            ID_EX_Flush_load <= 1;  //stall the pipeline
            PC_Write_load <= 0;     //PC hold
            IF_ID_Write_load <= 0;  //hold
        end
        else                        //normal
        begin
            IF_ID_Flush_load <= 0;
            ID_EX_Flush_load <= 0;
            PC_Write_load <= 1;
            IF_ID_Write_load <= 1;
        end
    end

    //Branch hazard
    always @ ( * )
    begin
        if((ID_EX_PCSrc == 3'b001) && EX_ALUOut0)
        begin                       //branch succeed
            IF_ID_Flush_branch <= 1;//flush
            ID_EX_Flush_branch <= 1;//flush
            PC_Write_branch <= 1;
            IF_ID_Write_branch <= 1;
        end
        else
        begin                       //branch fail
            IF_ID_Flush_branch <= 0;
            ID_EX_Flush_branch <= 0;
            PC_Write_branch <= 1;
            IF_ID_Write_branch <= 1;
        end
    end

    //J_type Instruction hazard
    always @ ( * )
    begin
        if(ID_PCSrc == 3'd2 || ID_PCSrc == 3'd3 || ID_PCSrc == 3'd4 || ID_PCSrc == 3'd5)
        begin                       //stall for 1 clock cycle
            IF_ID_Flush_jump <= 1;
            ID_EX_Flush_jump <= 0;
            PC_Write_jump <= 1;
            IF_ID_Write_jump <= 1;
        end
        else
        begin
            IF_ID_Flush_jump <= 0;
            ID_EX_Flush_jump <= 0;
            PC_Write_jump <= 1;
            IF_ID_Write_jump <= 1;
        end
    end

    //jr hazard
    always @ ( * )
    begin
        if((ID_PCSrc == 3'd3) && (ID_Rs == EX_AddrC) && (EX_AddrC != 0) && (ID_EX_RegWrite))
            ForwardJR <= 2'b01;     //fowarding from EX_AddrC
        else if((ID_PCSrc == 3'd3) && (ID_Rs == EX_MEM_AddrC) && (EX_MEM_AddrC != 0)
                && EX_MEM_RegWrite && (ID_Rs != EX_AddrC))
            ForwardJR <= 2'b10;     //fowarding from output of "jal"
        else if((ID_PCSrc == 3'd3) && (ID_Rs == MEM_WB_AddrC) && (MEM_WB_AddrC != 0)
                && MEM_WB_RegWrite && (ID_Rs != EX_AddrC) && (ID_Rs != EX_MEM_AddrC))
            ForwardJR <= 2'b11;     //forwarding from DataBusC
        else
            ForwardJR <= 2'b00;
    end

    //Flush
    assign IF_ID_Flush = IF_ID_Flush_load || IF_ID_Flush_branch || IF_ID_Flush_jump;
    assign ID_EX_Flush = ID_EX_Flush_load || ID_EX_Flush_branch || ID_EX_Flush_jump;
    assign PC_Write = PC_Write_load && PC_Write_branch && PC_Write_jump;
    assign IF_ID_Write = IF_ID_Write_load && IF_ID_Write_branch && IF_ID_Write_jump;
endmodule
