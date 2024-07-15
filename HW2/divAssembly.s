.global _start

.data

dividend:
    .long 2017

divisor:
    .long 423

.text

_start:

    movl $0, %eax # quotient
    movl $0, %edx # remainder
    movl dividend, %ebx # temp for dividend
    movl divisor, %esi # temp for divisor
    movl $31, %ecx # index i 

for_start:
    # i >= 0 -> i - 0 >=0 -> jump: i - 0 < 0
    cmpl $0, %ecx
    jl for_end

    movl %ebx, %edx # edx = temp dividend
    shrl %cl, %edx # dividend >> i

    // if ((dividend >> i) >= divisor)
    // %edx - %cl < 0
    if:
        cmpl %esi, %edx
        jl end_if

        movl $1, %edx 
        shll %cl, %edx # (1 << i)
        orl %edx, %eax # quotient |= (1 << i);

        movl %esi, %edx # edx = divisor
        shll %cl, %edx # divisor << i
        subl %edx, %ebx
    end_if:

    decl %ecx # i--
    jmp for_start # iteration

for_end:
    movl %ebx, %edx # remainder = dividend;

done:
    nop
