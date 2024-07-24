/*
int rec_strcmp(const char* str1, const char*str2){
    if(str1[0] == '\0' && str2[0] == '\0'){
        return 0;
    }else if(str1[0] != str2[0]){
        return str1[0] - str2[0];
    }else{
    return rec_strcmp(str1+1, str2+1);
    }
}       
*/

.global rec_strcmp
.equ ws, 4

.text

rec_strcmp:

    # str2
    # str1
    # rerurn address
    # %ebp: old ebp
    # -1: old_ebx


    prologue_start:
        push %ebp # save old ebp
        movl %esp, %ebp # establish stack frame for this func
        .equ num_locals, 0
        .equ use_ebx, 0
        .equ use_esi, 0
        .equ use_edi, 0
        .equ num_saved_regs, (use_edi + use_esi + use_ebx)
        subl $(num_locals + num_saved_regs) * ws, %esp # allocate space for locals
        
        .equ str1, (2 * ws) # ebp
        .equ str2, (3 * ws) # ebp
        .equ old_ebx, (-1 * ws) # ebp

        # save callee saved regs

    prologue_end:

    # str1 is eax
    # str2 is ecx
    # str1[0] is edx
    # str2[0] is ebx

    // if (str1[0] == '\0' && str2[0] == '\0')
    movl str1(%ebp), %eax # eax = str1
    movl str2(%ebp), %ecx # edx = str2
    movb (%eax), %dl # dl = str1[0]
    movb (%ecx), %dh # dh = str2[0]

    empty_base_case_start:
        cmpb $0, %dl # compare str1[0] - 0
        jnz first_character_different_base_case_start
        cmpb $0, %dh  # compare str2[0] - 0
        jnz first_character_different_base_case_start

        movl $0, %eax # return 0
        jmp epilogue_start
    empty_base_case_end:

    first_character_different_base_case_start:
        // else if (str1[0] != str2[0])
        //str1[0] - str2[0]!=0
        sub %dh, %dl # dl = str1[0] - str2[0]        je recursive_case_start
        je recursive_case_start
        #return str1[0] - str2[0]
     
        movsx  %dl, %eax # eax = str1[0] - str2[0]
        jmp epilogue_start



    first_character_different_base_case_end:


    recursive_case_start:
        #return rec_strcmp(str1+1, str2+1)
        addl $1 %ecx // leal 1(%ecx), %ecx
        push %ecx
        addl $1 %eax // leal 1(%eax), %eax
        push %eax
        call rec_strcmp
        addl $2 * ws, %esp
    recursive_case_end:

    epilogue_start:
        # restore callee saved regs


        movl old_ebx(%ebp), %ebx
        movl %ebp, %esp
        pop %ebp
        ret
    epilogue_end:

