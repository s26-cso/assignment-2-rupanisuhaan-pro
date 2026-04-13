.section .data
filename: .string "input.txt"
mode: .string "r"
format: .string "%s"
palindrome: .string "Yes\n"
notpalindrome : .string "No\n"

.section .text
.globl main
# making file functions accessible
.extern fopen
.extern fclose
.extern fseek
.extern ftell
.extern fgetc
.extern printf

main:
addi sp,sp,-64
sd s0,56(sp)
sd s1,48(sp)
sd s2,40(sp)
sd s3,32(sp)
sd s4,24(sp)
sd s5,16(sp)
sd s6,8(sp)
sd ra,0(sp)

# fopen(filename,mode)
lla a0,filename
lla a1,mode
call fopen
mv s0,a0 # s0 now contains a pointer to the file : f

# fseek(f,offset,pointofaction)
# move file pointer to end of file, for getting size
mv a0,s0
li a1,0
li a2,2
call fseek

# ftell(f) gives the size
mv a0,s0
call ftell
mv s1,a0 # s1 contains n, the total number of words in file

li s2,0 # i=0
addi s3,s1,-1 # j=n-1
li s4,1 # is_palindrome bit, originally set to 1
read:
bge s2,s3,check
mv a0,s0
mv a1,s2 # to move the pointer i positions right
li a2,0 # from beginning of the file
call fseek
mv a0,s0 
call fgetc # read the ith character from the left
mv s5,a0 # s5 contains the left character

mv a0,s0
mv a1,s3 # to move the pointer j positions right
li a2,0 # from beginning of the file
call fseek
mv a0,s0
call fgetc # read the jth character from the right
mv s6,a0 # s6 contains the right character

bne s5,s6,not
addi s2,s2,1 # i++
addi s3,s3,-1 # j--
j read

not:
li s4,0

check:
beq s4,x0,print_no
lla a0,format
lla a1,palindrome
call printf
j exit

print_no:
lla a0,format
lla a1,notpalindrome
call printf

exit:
# fclose(f)
mv a0,s0
call fclose # close the file
ld ra,0(sp)
ld s6,8(sp)
ld s5,16(sp)
ld s4,24(sp)
ld s3,32(sp)
ld s2,40(sp)
ld s1,48(sp)
ld s0,56(sp)
addi sp,sp,64
ret

