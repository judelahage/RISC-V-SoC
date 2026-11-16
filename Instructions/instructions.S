addi x3, x0, 4 #0x00400193
addi x4, x3, 2 #0x00218213
add x4, x4, x3 #0x00320233
sw x4, 8(x3) #0x0041A423
lw x5, 8(x3) #0x0081A283
beq x4, x5, pass #0x00520463
addi x6, x0, 1 #0x00100313
pass: lui x7, 0x10000 #100003B7
sw x4, 0(x7) #0043A023
done: lw x1, 4(x7) #0x0043A083
sw x1, 0(x7) #0x0013A023
beq x0, x0, done #0xFE000CE3


