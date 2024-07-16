.global _start

.data

string1:
    // .space 101
    .space 101

string2:
    // .space 101
    .space 101

string1_len:
    .long 0

string2_len:
    .long 0

oldDist:
    .space 404

curDist:
    .space 404

.text

# args: %eax = a, %ebx = b, return: %eax = a or b
min:
    // return a < b ? a:b
    // if (a < b) {return a}; else {return b};
    // if (a - b < 0) {return a}; else {return b};
    if_min_start: 
        cmpl %ebx, %eax # if (a - b < 0)
        jge else_min_start
        jmp if_min_end

    else_min_start:
        movl %ebx, %eax

    if_min_end:

    ret

# args: ecx,edx return edx,ecx (after swap)
swap:
    movl $0, %edx # %edx = i = 0

    for_swap_start:
        // i < wordlen(max = 100)
        // i - wordlen < 0
        cmpl $101, %edx
        jge for_swap_end

        movl oldDist(, %edx, 4), %eax # %eax = temp = oldDist[i]
        movl curDist(, %edx, 4), %ebx # %ebx = temp = curDist[i]
        movl %eax, curDist(, %edx, 4) # oldDist[i] = %eax = curDist[i]
        movl %ebx, oldDist(, %edx, 4) # curDist[i] = %ebx = oldDist[i]
        
        incl %edx # i++
        jmp for_swap_start # !!!
    for_swap_end:

    ret


# the method strlen()
#arg: s -> eax, return: i -> ebx
strlen:
    /* int strlen(const char* s)
       int i;
       for(i = 0; str[i] != '\0'; i++){}
       return i; 
    */

    movl $0, %ecx # ecx = i = 0
    strlen_reg_for_start:
        # str[i] - '\0' !=0 -> = 0
        cmpb $0, (%eax, %ecx, 1) # str[i] - '\0'
        je strlen_reg_for_end

        incl %ecx
        jmp strlen_reg_for_start
    strlen_reg_for_end:
    movl %ecx, %ebx

    ret

_start:
    movl $string1, %eax
    call strlen
    movl %ebx, string1_len
    movl $string2, %eax
    call strlen
    movl %ebx, string2_len

    movl $0, %ecx # %ecx = i
    movl string2_len, %edi # %edi = string2_len 
    addl $1, %edi # %edi = string2_len + 1

    for_start: 
        cmpl %edi, %ecx # i - (string2_len + 1) < 0
        jge for_end
        movl %ecx, oldDist(, %ecx,4) # oldDist[i] = i;
        movl %ecx, curDist(, %ecx,4) # curDist[i] = i;
        incl %ecx # i++
        jmp for_start
    for_end:

    movl $1, %ecx # %ecx = i = 1
    movl string1_len, %esi # %esi = string1_len 
    addl $1, %esi # %esi = string1_len + 1

    for_outer_start:
        // i - (string1_len + 1) < 0
        cmpl %esi, %ecx
        jge for_outer_end

        movl %ecx, curDist # curDist[0] = i;

        movl $1, %edx # %ecx = j = 1

        for_inner_start:
            // j - (string2_len + 1) < 0
            cmpl %edi, %edx
            jge for_inner_end

            // word[i-1] = *(word + i - 1)
            movb string1 - 1(, %ecx, 1), %al # %al = string1[i - 1]
            movb string2 - 1(, %edx, 1), %bl # %bl = string2[j - 1]

            if_start:
                // string1[i - 1] == string2[j - 1]
                // string1[i - 1] - string2[j - 1] == 0
                cmpb %bl, %al
                jne else_start

                movl oldDist - 1 * 4(, %edx, 4), %eax # %eax = temp = oldDist[j - 1]
                movl %eax, curDist(, %edx, 4) # curDist[j] = %eax = oldDist[j - 1]
                jmp else_end
            
            else_start:
                // curDist[j] = min(min(oldDist[j], curDist[j-1]), oldDist[j-1]) + 1;
                movl oldDist(, %edx, 4), %eax # %eax = oldDist[j]
                movl curDist - 1 * 4(, %edx, 4), %ebx # %ebx = curDist[j-1]
                call min # %eax = return val
                movl oldDist - 1 * 4(, %edx, 4), %ebx # %ebx = oldDist[j-1]
                call min
                incl %eax
                movl %eax, curDist(, %edx, 4) # curDist[j] = %eax

            else_end:

            incl %edx # j ++
            jmp for_inner_start

        for_inner_end:
    
        call swap
        incl %ecx # i++
        jmp for_outer_start
    for_outer_end:

    // dist = oldDist[string2_len];
    movl oldDist - 1 * 4(,%edi,4), %eax # oldDist[string2_len] = oldDist[%edi - 1]

done:
    nop
    