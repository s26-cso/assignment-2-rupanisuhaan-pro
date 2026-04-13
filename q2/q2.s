.section .rodata
fmt:
.string "%d "
fmt1:
.string "\n"
.section .text
.globl main
# given integers, which are 32 bit (word)
main:
addi sp,sp,-48
sd ra,40(sp)
sd s0,32(sp)
sd s1,24(sp)
sd s2,16(sp)
sd s3,8(sp)
mv s0,a0
addi s0,s0,-1 # s0=n, the number of elements

mv s1,a1 # a1 contains the base address of the command line argument elements
addi s1,s1,8 # s1=base address of arguments array

slli a0,s0,2 # total bytes required for the input integer array
call malloc
mv s2,a0 # Base address for the new integer array
li t0,0 # i=0
start_loop:
beq t0,s0,start
slli t1,t0,3 # offset
add t1,s1,t1 # argument address=base+offset
ld a0,0(t1)
call atoi # converting the string command line argument to a 32-bit integer
slli t1,t0,2 # offset
add t1,s2,t1
sw a0,0(t1)
addi t0,t0,1
j start_loop

start:
mv s1,s2

li t2,4
mul a0,s0,t2 # total int bytes req for result
call malloc
mv s2,a0 # s2=base address of result array

li t2,4
mul a0,s0,t2 # total int bytes req for newstack
call malloc
mv s3,a0 # s3=base address of newstack

# initialisation of result array
li t0,0
loop1: beq t0,s0,completed_init
slli t1,t0,2 # i=i*4 offset calculation
add t1,t1,s2 # address=base+offset
li t2,-1
sw t2,0(t1) # set result[i]=-1;
addi t0,t0,1
j loop1

completed_init:
li t0,-1 # t0=-1 fixed
li t1,0 # set i=0
li t2,-1 # top=-1
loop2:
beq t1,s0,exit
slli t3,t1,2 # offset calculation
add t3,s1,t3 # arr address=base+offset
lw t4,0(t3) # t4=arr[i]

loop3: 
beq t2,t0,next
slli t3,t2,2
add t3,s3,t3 # newstack address=base+offset
lw t5,0(t3) # load stack[top] in t5
slli t3,t5,2 # offset calculation
add t3,s1,t3 # arr address=base+offset
lw t6,0(t3) # t6=arr[stack[top]]
bge t6,t4,next
slli t3,t5,2 # offset calculation
add t3,t3,s2 # result address= base+offset
sw t1,0(t3) # result[stack[top]]=i;
addi t2,t2,-1 # top--;
j loop3


next:
addi t2,t2,1
slli t3,t2,2
add t3,s3,t3 # newstack address=base+offset
sw t1,0(t3) # stack[++top]=i;
addi t1,t1,1 # i=i+1
j loop2

exit:
li s1,0 # i=0;
loop4: beq s1,s0,final
slli s3,s1,2 # offset
add s3,s2,s3 # result address=base+offset
lla a0,fmt
lw a1,0(s3)
call printf
addi s1,s1,1
j loop4

final:
lla a0,fmt1
call printf
ld ra,40(sp)
ld s0,32(sp)
ld s1,24(sp)
ld s2,16(sp)
ld s3,8(sp)
addi sp,sp,48
ret
