

/*
int rec_sum(int* nums, int len){
    if (len == 0){
        return 0;
    }
    else{
        return nums[0] + rec_sum(nums + 1, len-1);
    } 

}



*/




.global rec_sum
.text
.equ ws, 4
rec_sum:
    #3: len
    #2:nums
    #return address
    # ebp: old ebp

    prologue_start:
        push %ebp #save old ebp
        movl %esp, %ebp #establish stack frame for this func

        .equ num_locals, 0
        .equ use_ebx, 0
        .equ use_esi, 0
        .equ use_edi, 0
        .equ num_saved_regs, (use_edi + use_esi + use_ebx)
        subl $(num_locals + num_saved_regs) * ws, %esp # allocate space for locals

        .equ len, 2 * ws #ebp
        .equ nums, 3 * ws #ebp
        #sav any callee saved regs

    prologue_end:

    // if (len == 0)

    movl len(%ebp), %ecx # ecx = len
    cmpl $0, len(%ebp) # len - 0
    jne recursive_case

    base_case_start:
        #return 0;
        jmp epilogue_start
    base_case_end:


    recursive_case_start:
        # return nums[0] + rec_sum(nums + 1, len - 1);
        subl $1, %ecx # ecx= len - 1
        push %ecx # push len to stack


        movl nums(%ebp), %ecx # ecx = nums

        //addl $4, %ecx # ecx = nums + 1
        leal  1 * ws(%ecx), %ecx # ecx = nums + 1
       
        push %ecx # push ecx to stack


        call rec_sum # eax = rec_sum(nums + 1, len - 1)
        addl $2 * ws, %esp # clear arguments on stack
        movl nums(%ebp), %edx # edx = nums
        addl (%edx), %eax # eax = nums[0] + rec_sum(nums + 1, len - 1)
        # 

    recursive_case_end:


    epilogue_start:
        #no saved regs to restore
        movl %ebp, %esp # restore esp
        pop %ebp # restore ebp
        ret

    epilogue_end:

done:
    nop
