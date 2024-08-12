.global get_combs
.equ ws, 4
.text

// int** get_combs(int* items, int k, int len)

# 4: len
# 3: k
# 2: items
# 1: return address
# 0: old ebp
# -1: combs
# -2: old_esi
# -3: old_edi
# -4: result_index
# -5: temp_index
# -6: begain
# i

get_combs:
    prologue_start:
        push %ebp # save old ebp
        movl %esp, %ebp # establish stack frame for this func
        .equ num_locals,4
        .equ use_ebx, 0
        .equ use_esi, 0
        .equ use_edi, 0
        .equ num_saved_regs, (use_edi + use_esi + use_ebx)
        subl $(num_locals + num_saved_regs) * ws, %esp # allocate space for locals

        .equ items, 2 * ws # ebp
        .equ k, 3 * ws # ebp
        .equ len, 4 * ws # ebp
        .equ combs, -1 * ws # ebp
        .equ mat, -2 * ws
        .equ temp_arr, -3 * ws # ebp
        .equ result_index, -4 * ws # ebp
        
        #save calle saved regs
        
    prologue_end:
    // int combs = num_combs(len, k);
    push k(%ebp)
    push len(%ebp)

    call num_combs
    addl $2 * ws, %esp
    movl %eax, combs(%ebp) # combs is total combinations

    //%eax is combs
    //edi is result_mat
    //ecx is i

    //int** result_mat = (int**)malloc(total_nums * sizeof(int*));
    movl combs(%ebp), %eax
    shll $2, %eax   # eax = combs * sizeof(int*)
    push %eax
    call malloc
    addl $1 * ws, %esp
    movl %eax, mat(%ebp) # result_mat = malloc(combs * sizeof(int*))
    //for (size_t i = 0; i < total_nums; i++)
    
    movl $0, %esi
    for_start:
        cmpl combs(%ebp), %esi
        jge for_end
 
        //result_mat[i] = (int*)malloc(k * sizeof(int));
        movl k(%ebp), %eax
        shll $2, %eax
        push %eax
        call malloc
        addl $1 * ws, %esp

        movl mat(%ebp), %ebx
        movl %eax, (%ebx,%esi,ws) # result_mat[i] = malloc(k * sizeof(int))
      
        incl %esi
        jmp for_start
    for_end:

    // esi is temp_arr
    //edi is result_mat
    //%ebx is result_index
    //int* temp_arr = (int*)malloc(k * sizeof(int));
    movl k(%ebp), %eax
    shll $2, %eax
    push %eax
    call malloc
    addl $1 * ws, %esp
    movl %eax, temp_arr(%ebp) # temp_arr = malloc(k * sizeof(int))

    // combs_recursive(result_mat, temp_arr, items, k, len, 0, &result_index, 0);
    movl $0, result_index(%ebp) # result_index = 0
    leal result_index(%ebp), %eax # ebx = result_index

  

    push $0
    push %eax 
    push $0
    push len(%ebp)
    push k(%ebp)
    push items(%ebp)
    push temp_arr(%ebp)
    push mat(%ebp)
    call combs_recursive
    addl $8 * ws, %esp
    movl mat(%ebp), %eax


    epilogue_start:
        movl %ebp, %esp
        pop %ebp
        ret

    epilogue_end:

//void combs_recursive(int** mat, int* temp_arr, int* items, 
        //int k, int len, int begin, int* result_index, int temp_index)
combs_recursive:
    push %ebp
    movl %esp, %ebp
    
    .equ num_locals,1
    .equ used_ebx, 0
    .equ used_esi, 0
    .equ used_edi, 0
    .equ num_saved_regs, (used_edi + used_esi + used_ebx)
    subl $(num_locals + num_saved_regs) * ws, %esp

    .equ mat, (2 * ws)
    .equ temp_arr, (3 * ws)
    .equ items, (4 * ws)
    .equ k, (5 * ws)
    .equ len, (6 * ws)
    .equ begain, (7 * ws)
    .equ result_index, (8 * ws)
    .equ temp_index, (9 * ws)


    // local vars (caller saved)
    .equ i, (-1 * ws)
    #save callee saved regs



    
    // esi is temp_arr
    //edi is result_mat
    //%ebx is result_index

    //if (temp_index == k)
    
    if_start:
        movl temp_index(%ebp), %ebx
        cmpl k(%ebp), %ebx
        jne if_end

        # for (size_t i = 0; i < k; i++)
        movl $0, i(%ebp)
        for_loopin_start:
            movl i(%ebp), %ecx
            cmpl k(%ebp), %ecx
            jge for_end

            //mat[*result_index][i] = temp_arr[i]
            movl temp_arr(%ebp), %esi
            movl (%esi, %ecx, ws), %esi

            movl result_index(%ebp), %edx
            movl (%edx), %edx
            movl mat(%ebp), %eax
            movl (%eax, %edx, 4), %eax
            movl %esi, (%eax, %ecx, ws) # mat[*result_index][i] = temp_arr[i]

           
            incl i(%ebp)
            jmp for_loopin_start

        for_loopin_end: 
            //(*result_index)++;
            movl result_index(%ebp), %ebx
            incl (%ebx)
       
            
            jmp epilogue_return


    if_end:

    movl begain(%ebp), %ecx 
    movl %ecx, i(%ebp) # ecx = i = begin
    for_loop_start:
        // for (size_t i = begin; i < len; i++)
        movl i(%ebp), %ecx
        cmpl len(%ebp), %ecx
        jge for_loop_end
        //temp_arr[temp_index] = items[i];
        movl items(%ebp), %ebx
        movl (%ebx, %ecx, ws), %edx 

        movl temp_arr(%ebp), %eax
        movl temp_index(%ebp), %esi
        movl %edx, (%eax, %esi, ws) # temp[temp_index] = items[i]



        //combs_recursive(mat, temp_arr, items, 
            //k, len, i + 1, result_index, temp_index + 1);
        movl temp_index(%ebp), %eax
        incl %eax
        movl i(%ebp), %ecx
        incl %ecx
        push %eax
        push result_index(%ebp)
        push %ecx
        push len(%ebp)
        push k(%ebp)    
        push items(%ebp)
        push temp_arr(%ebp)
        push mat(%ebp)
        call combs_recursive
        addl $8 * ws, %esp

        incl i(%ebp)
        jmp for_loop_start

    for_loop_end:

    epilogue_return:

        movl %ebp, %esp
        pop %ebp
        ret