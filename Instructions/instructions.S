addi x3, x0, 4 #0x00400193
addi x4, x3, 2 #0x00218213
add x4, x4, x3 #0x00320233
sw x4, 8(x3) #0x0041A423
lw x5, 8(x3) #0x0081A283
beq x4, x5, pass #0x00520463
addi x6, x0, 1 #0x00100313
pass: beq x0, x0, pass #0x00000063



