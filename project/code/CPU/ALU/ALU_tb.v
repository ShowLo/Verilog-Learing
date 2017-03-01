`timescale 1ns/1ps
//module to test the module ALU (A,B,ALUFun,Sign,Z,Zero,Overflow,Negative)
module ALU_tb;
    reg [31:0] A,B;
    reg [5:0] ALUFun;
    reg Sign;
    wire [31:0] Z;

    //test the ADD/SUB
    initial
    begin
        //normal unsigned add
        A = 32'd5;
        B = 32'd33;
        ALUFun = 6'b00_0000;
        Sign = 0;
        #20
        //normal signed add
        A = 32'h7fffffff;       //2^31-1
        B = 32'h80000001;       //1-2^31
        ALUFun = 6'b00_0000;
        Sign = 1;
        #20
        //unsigned sub and test Overflow
        A = 32'd5;
        B = 32'd10;
        ALUFun = 6'b00_0001;
        Sign = 0;
        #20
        //normal unsigned sub
        A = 32'd10;
        B = 32'd0;
        ALUFun = 6'b00_0001;
        Sign = 0;
        #20
        //normal signed sub
        A = 32'd5;
        B = 32'd10;
        ALUFun = 6'b00_0001;
        Sign = 1;
        #20
        //normal unsigned sub and test the Zero
        A = 32'd50;
        B = 32'd50;
        ALUFun = 6'b00_0001;
        Sign = 0;
        #20
        //unsigned add and test Overflow
        A = 32'd4294967295;
        B = 32'd2;
        ALUFun = 6'b00_0000;
        Sign = 0;
    end

    //test the CMP
    /*initial
    begin
        //test EQ
        A = 32'd1;
        B = 32'd2;
        ALUFun = 6'b11_0011;
        Sign = 0;
        #20
        A = 32'd1;
        B = 32'd1;
        ALUFun = 6'b11_0011;
        Sign = 0;
        #20
        //test NEQ
        A = 32'd1;
        B = 32'd2;
        ALUFun = 6'b11_0001;
        Sign = 0;
        #20
        A = 32'd1;
        B = 32'd1;
        ALUFun = 6'b11_0001;
        Sign = 0;
        #20
        //test LT
        A = 32'd1;
        B = 32'd2;
        ALUFun = 6'b11_0101;
        Sign = 0;
        #20
        A = 32'd1;
        B = 32'd1;
        ALUFun = 6'b11_0101;
        Sign = 0;
        #20
        //test LEZ
        A = 32'd1;
        B = 32'd0;
        ALUFun = 6'b11_1101;
        Sign = 0;
        #20
        A = 32'd0;
        B = 32'd0;
        ALUFun = 6'b11_1101;
        Sign = 0;
        #20
        A = 32'hffffffff;
        B = 32'd0;
        ALUFun = 6'b11_1101;
        Sign = 1;
        #20
        //test LTZ
        A = 32'd1;
        B = 32'd0;
        ALUFun = 6'b11_1011;
        Sign = 0;
        #20
        A = 32'd0;
        B = 32'd0;
        ALUFun = 6'b11_1011;
        Sign = 0;
        #20
        A = 32'hffffffff;
        B = 32'd0;
        ALUFun = 6'b11_1011;
        Sign = 1;
        #20
        //test GTZ
        A = 32'd1;
        B = 32'd0;
        ALUFun = 6'b11_1111;
        Sign = 0;
        #20
        A = 32'd0;
        B = 32'd0;
        ALUFun = 6'b11_1111;
        Sign = 0;
        #20
        A = 32'hffffffff;
        B = 32'd0;
        ALUFun = 6'b11_1111;
        Sign = 1;
    end*/

    //test the Logic
    /*initial
    begin
        Sign = 0;
        //test AND
        A = 32'd1;
        B = 32'd0;
        ALUFun = 6'b01_1000;
        #20
        A = 32'd1;
        B = 32'd1;
        ALUFun = 6'b01_1000;
        #20
        //test OR
        A = 32'd0;
        B = 32'd0;
        ALUFun = 6'b01_1110;
        #20
        A = 32'd1;
        B = 32'd0;
        ALUFun = 6'b01_1110;
        #20
        //test XOR
        A = 32'd1;
        B = 32'd1;
        ALUFun = 6'b01_0110;
        #20
        A = 32'd1;
        B = 32'd0;
        ALUFun = 6'b01_0110;
        #20
        //test NOR
        A = 32'd0;
        B = 32'd0;
        ALUFun = 6'b01_0001;
        #20
        A = 32'd1;
        B = 32'd0;
        ALUFun = 6'b01_0001;
        #20
        //test MOV("A")
        A = 32'd1;
        ALUFun = 6'b01_1010;
    end*/

    //test the Shift
    /*initial
    begin
        Sign = 0;
        //test SLL
        B = 32'h0000ffff;
        A = 32'd16;
        ALUFun = 6'b10_0000;
        #20
        //test SRL
        B = 32'hffff0000;
        A = 32'd16;
        ALUFun = 6'b10_0001;
        #20
        //test SRA
        B = 32'hffff0000;
        A = 32'd8;
        ALUFun = 6'b10_0011;
        #20
        B = 32'h00ff0000;
        A = 32'd8;
        ALUFun = 6'b10_0011;
    end*/

    ALU alu(.A(A),.B(B),.ALUFun(ALUFun),.Sign(Sign),.Z(Z));

endmodule
