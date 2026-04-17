.section .text
.globl make_node
.globl insert
.globl get
.globl getAtMost
make_node:
addi sp,sp,-16 # making space to store return address and val on stack
sd ra,8(sp) # store return address on stack
sw a0,4(sp) # store val on stack
li a0,24 # making space for 24 bytes for the tree struct
call malloc # call malloc
lw t0,4(sp) # load val back from stack and store it in tempoarary register t0
sw t0,0(a0) # store the value stored in t0(val) as node->val (only 4 int bytes)
li t1,0 # NULL=0
sd t1,8(a0) # node->left=NULL
sd t1,16(a0) # node->right=NULL
ld ra,8(sp) # load the return address in the return address register
addi sp,sp,16
ret



insert:
addi sp,sp,-32
sd ra,24(sp) # store the return address in the stack
sd a0,16(sp) # store the root node pointer on the stack
sw a1,12(sp) # store val on the stack
beq a0,x0,base_insert  # if root==NULL, branch to base case
lw t0,0(a0)  # root->val is loaded into temporary register t0
blt a1,t0,left_insert  # if new val<root->val, insert in left sub branch of tree

ld t1,16(a0) # load root->right into t1
mv a0,t1 # root=root->right
lw a1,12(sp) # load val back into a1
call insert
ld t2,16(sp) # load original root
sd a0,16(t2) # root->right=a0 linking after every insert in right subtree, updating root->right
mv a0,t2 # store the original root in the a0 return register 
j exit_insert

left_insert:
ld t1,8(a0) # load root->left into t1
mv a0,t1 # root=root->left
lw a1,12(sp) # load val back into a1
call insert
ld t2,16(sp) # load original root
sd a0,8(t2) # root->left=a0 linking after every insert in left subtree, updating root->left
mv a0,t2 # store the original root in the a0 return register
j exit_insert

base_insert:
lw a0,12(sp) # putting val in a0 argurment register for make_node
call make_node

exit_insert:
ld ra,24(sp) # load the return address in return address register ra
addi sp,sp,32
ret



get:
addi sp,sp,-32
sd ra,24(sp) # store the return address on the stack
sd a0,16(sp) # store the original root on the stack
sw a1,12(sp) # store the val on the stack
beq a0,x0,notfound_get  # if root==NULL, jump to notfound_get
lw t0,0(a0) # load root->val in temporary register a0
beq a1,t0,found_get # if val==root->val, go to branch found_get
blt a1,t0,left_get # if val<root->val, go to left branch
ld t1,16(a0) # load root->right in t1
mv a0,t1 # root=root->right
lw a1,12(sp) # load val back into a1
call get
j exit_get

left_get:
ld t1,8(a0) # load root->left into t1
mv a0,t1 # root=root->left
lw a1,12(sp) # load val back into a1
call get
j exit_get

found_get:
# a0 has the root we are finding for
j exit_get

notfound_get:
mv a0,x0 # move NULL to the function return register a0

exit_get:
ld ra,24(sp) # store the return address in ra register
addi sp,sp,32
ret



getAtMost:

li t0,-1 # initialise predecessor value to -1
loop: beq a1,x0,exit # if root==NULL, jump to exit
lw t1,0(a1) # load root->val in t1
blt t1,a0,less_than_or_equal_to
beq t1,a0,less_than_or_equal_to
ld t2,8(a1) # copy root->left into t2
mv a1,t2 # root=root->left
j loop

less_than_or_equal_to:
mv t0,t1 # copy root->val to predecessor value
ld t2,16(a1) # copy root->right into t2
mv a1,t2 # root=root->right
j loop

exit:
mv a0,t0 # copy predecessor value into function result register a0
ret

