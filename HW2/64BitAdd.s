.global _start

.data
num1:
    .quad 0x0000000100000002 

num2:
    .quad 0x0000000300000004 

.text

_start:
#deal with the lower 32 bits
movl num1+4, %eax # eax = num1
movl num2+4, %ebx # ebx = num2
addl %ebx, %eax # eax = eax + ebx

#deal with the higher 32 bits
movl num1, %ecx # eax = num1
movl num2, %ebx # ebx = num2
adcl %ebx, %ecx # eax = eax + ebx[add with carry]

#move the higher 32 bits to edx
movl %ecx, %edx # ebx = eax

done:
    nop





