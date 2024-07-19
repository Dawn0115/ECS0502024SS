.global sum
.text
.equ wordsize, 4

/*
int sum(int nums[], int size){
    int total = 0;
    for(i = 0; i < size; i++){
        total += nums[i];
    
    }
    return total;
}
*/
sum: # int sum(int nums[], int size)

#size
#nums
#esp + 1:return address
#esp, ebp: old ebp
#-1:total
#esp :-2 : i
#-3: old ebx

prologue: 
    push %ebp # save old ebp
    movl %esp, %ebp # initialize new stack frame
    .equ numlocals, 2
    .equ use_ebx, 1
    .equ use_esi, 0
    .equ use_edi, 0
    .equ num_saved_regs, (use_edi+use_esi+use_ebx) 
    subl $(numlocals + use_ebx) * wordsize, %esp # allocate space for locals
    



    .equ nums, 2*wordsize #2words away from ebp
    .equ size, 3*wordsize #(%ebp)
    .equ total, (-1 * wordsize) # (%ebp)
    .equ i, (-2 * wordsize) # (%ebp)
    .equ old_ebx , (-3 * wordsize) # (%ebp)

    #save calle saved reg
    movl %ebx, old_ebx(%ebp)

end_prologue:
# eax will be total
movl $0, %eax#total = 0
#ebx will be nums
movl nums(%ebp), %ebx # ebx = nums


# for(i = 0; i < size; i++)
#ecx will be i
movl $0, %ecx # i = 0  
for_start:
    # i < size
    #neg: i - size >=0
    cmpl size(%ebp), %ecx
    jge for_end

    # total += nums[i];
    addl (%ebx, %ecx, wordsize), %eax # total += nums[i]
    # NOT THE SAME IS ABOVE LINE
    # DON'T DO!!! addl nums(%ebx,%ecx,wordsize),%eax == total+=*(&nums + i)


    incl %ecx # i++
    jmp for_start

for_end:

#return total;
epilogue_start:
    #restore  ebx to its original value
    movl old_ebx(%ebp), %ebx
    #remove the sapce
    movl %ebp, %esp
    pop %ebp # restore old ebp
    ret
end_prologue: 

sum_end:
 



 
