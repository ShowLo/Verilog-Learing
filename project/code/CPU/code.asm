j Main
j Interrupt
j Exception

Main:
add $sp,$zero,$zero   #sp=0
lui $s7, 16384        #s7=0x40000000  address of peripheral
nor $s6,$zero,$zero   #s6=0xffffffff
sw $zero,12($s7)      #LED=0
sw $s6,20($s7)        #digi=0xffffffff
sw $zero,8($s7)       #TCON=0
addi $t0,$s6,-25000
addi $t0,$t0,-25000
sw $t0,0($s7)         #set the period
sw $s6,4($s7)         #TL=0xffffffff
addi $t0,$zero,3
sw $t0,8($s7)         #TCON=3 
sw $t0,32($s7)
add $s0,$zero,$zero   #s0:UART Recieve?
sll $zero,$zero,0
Polling:              #UART polling
lw $t0,32($s7)        #Read UART_CON
addi $t1,$zero,8
and $t2,$t1,$t0       #Read UART_CON[3]
beq $t2,$zero,Polling #UART_[3]==1,Recieve
bne $s0,$zero,MemRd
lw $a0,28($s7)        #a0=UART_RXD
addi $s0,$zero,1
j Polling 
MemRd:
lw $a1,28($s7)
jal GCD
add $s0,$zero,$zero
sw $v0,12($s7)
Sending:
lw $t0,32($s7)
addi $t1,$zero,16
and $t2,$t0,$t1
srl $t2,$t2,4
bne $t2,$zero,Sending
sw $v0,24($s7)

j Polling
GCD:
add $t0,$a0,$zero
add $t1,$a1,$zero
While:
beq $t0,$t1,GCD_Exit
sub $t2,$t0,$t1
bgtz $t2,Sub
add $t2,$t0,$zero
add $t0,$t1,$zero
add $t1,$t2,$zero
Sub:
sub $t0,$t0,$t1
j While

GCD_Exit:
add $v0,$t0,$zero
jr $ra



Interrupt:
lw $s5,8($s7)         #Read TCON
addi $s4,$s6,-6       #t1=0xfffffff9
and $s5,$s4,$s5
sw $s5,8($s7)         #Set TCON
sw $t0,0($sp)         #Save Instance State
sw $t1,4($sp)
sw $t2,8($sp)
sw $t3,12($sp)
sw $t4,16($sp)
sw $t5,20($sp)
addi $sp,$sp,20
lw $t0,20($s7)        #Read digutube
srl $t0,$t0,8         #Get AN0~AN3
andi $t1,$a0,240      #t1=a0&11110000
srl $t1,$t1,4         #high 4 bits of a0
addi $t2,$zero,14     #1110
addi $t3,$zero,7      #0111
beq $t0,$t2,Decoding
andi $t1,$a0,15
addi $t2,$zero,7      #0111
addi $t3,$zero,11     #1011
beq $t0,$t2,Decoding
andi $t1,$a1,240
srl $t1,$t1,4
addi $t2,$zero,11     #1011
addi $t3,$zero,13     #1101
beq $t0,$t2,Decoding
andi $t1,$a1,15
addi $t2,$zero,13     #1101
addi $t3,$zero,14     #1110
beq $t0,$t2,Decoding

Decoding:
addi $t4,$zero,192    #11000000
addi $t5,$zero,0      #0
beq $t1,$t5,Exit
addi $t4,$zero,249    #11111001
addi $t5,$zero,1      #1
beq $t1,$t5,Exit
addi $t4,$zero,164    #10100100
addi $t5,$zero,2      #2
beq $t1,$t5,Exit
addi $t4,$zero,176    #10110000
addi $t5,$zero,3      #3
beq $t1,$t5,Exit
addi $t4,$zero,153    #10011001
addi $t5,$zero,4      #4
beq $t1,$t5,Exit
addi $t4,$zero,146    #10010010
addi $t5,$zero,5      #5
beq $t1,$t5,Exit
addi $t4,$zero,130    #10000010
addi $t5,$zero,6      #6
beq $t1,$t5,Exit
addi $t4,$zero,248    #11111000
addi $t5,$zero,7      #7
beq $t1,$t5,Exit      
addi $t4,$zero,128    #10000000
addi $t5,$zero,8      #8
beq $t1,$t5,Exit
addi $t4,$zero,144    #10010000
addi $t5,$zero,9      #9
beq $t1,$t5,Exit
addi $t4,$zero,136    #10001000
addi $t5,$zero,10     #10
beq $t1,$t5,Exit
addi $t4,$zero,131    #10000011
addi $t5,$zero,11     #11
beq $t1,$t5,Exit
addi $t4,$zero,198    #11000110
addi $t5,$zero,12     #12
beq $t1,$t5,Exit
addi $t4,$zero,161    #10100001
addi $t5,$zero,13     #13
beq $t1,$t5,Exit
addi $t4,$zero,134    #10000110
addi $t5,$zero,14     #14
beq $t1,$t5,Exit 
addi $t4,$zero,142    #10001110
addi $t5,$zero,15     #15
beq $t1,$t5,Exit

Exit:
sll $t3,$t3,8
add $t0,$t3,$t4
sw  $t0,20($s7)
lw $t5,0($sp)         #Resume Scene
lw $t4,-4($sp)
lw $t3,-8($sp)
lw $t2,-12($sp)
lw $t1,-16($sp)
lw $t0,-20($sp)
addi $sp,$sp,-20
lw $s5,8($s7)
addi $s4,$zero,2
or $s5,$s4,$s5
sw $s5,8($s7)
jr $k0


Exception:
sll $zero,$zero,0
jr $k0



