.global get_combs
.equ ws, 4
.text

get_combs:
    prologue_start:

    // init the stack
    push %ebp
    movl %esp, %ebp

    .equ num_locals,4
    .equ used_ebx, 0
    .equ used_esi, 0
    .equ used_edi, 0
    .equ num_saved_regs, (used_edi + used_esi + used_ebx)
    subl $(num_locals + num_saved_regs) * ws, %esp

    // set index of args (%ebp)
    .equ items, (2 * ws)
    .equ k, (3 * ws) 
    .equ len, (4 * ws)  

    // local vars (caller saved)
    .equ mat_rows, (-1 * ws)
    .equ mat, (-2 * ws)
    .equ temp, (-3 * ws)
    .equ mat_index, (-4 * ws)
  
    prologue_end:

    // int mat_rows = num_combs(len, k);
    push k(%ebp)
    push len(%ebp)
    call num_combs
    addl $2 * ws, %esp
    movl %eax, mat_rows(%ebp)

    // int** mat = (int**)malloc(mat_rows * sizeof(int*));
    movl mat_rows(%ebp), %eax # eax = mat_rows 
    shll $2, %eax # eax = mat_rows * sizeof(int*)
    push %eax
    call malloc
    addl $1 * ws, %esp
    movl %eax, mat(%ebp)

    // for(i = 0; i < mat_rows; i++)
    movl $0, %esi
    for_malloc_start:
        # i - mat_rows < 0
        cmpl mat_rows(%ebp), %esi
        jge for_malloc_end

        movl k(%ebp), %eax # eax = k
        shll $2, %eax # eax = k * sizeof(int)
        push %eax
        call malloc
        addl $1 * ws, %esp

        // mat[i] = (int*)malloc(k * sizeof(int));
        movl mat(%ebp), %ebx # ebx = mat
        movl %eax, (%ebx, %esi, ws) # mat[i] = malloc
        incl %esi
        jmp for_malloc_start
    for_malloc_end:

    // int* temp = (int*)malloc(k * sizeof(int));
    movl k(%ebp), %eax # eax = k
    shll $2, %eax # eax = k * sizeof(int)
    push %eax
    call malloc
    addl $1 * ws, %esp
    movl %eax, temp(%ebp)

    // Get the combs recursively
    /* 
        combs_recursive(int** mat, int* temp, int* items, 
            int k, int len, int begin, int* mat_index, int temp_index)
    */
    movl $0, mat_index(%ebp)
    leal mat_index(%ebp), %eax # &mat_index

    push $0 # temp_index 
    push %eax # &mat_index
    push $0 # begin
    push len(%ebp)
    push k(%ebp)
    push items(%ebp)
    push temp(%ebp)
    push mat(%ebp)
    call combs_recursive
    addl $8 * ws, %esp
    movl mat(%ebp), %eax

    epilogue:
        movl %ebp, %esp
        pop %ebp
        ret


combs_recursive:
    prologue_recur_start:
        // Init the stack
        push %ebp
        movl %esp, %ebp

        .equ num_locals,1
        .equ used_ebx, 0
        .equ used_esi, 0
        .equ used_edi, 0
        .equ num_saved_regs, (used_edi + used_esi + used_ebx)
        subl $(num_locals + num_saved_regs) * ws, %esp

        // set index of args (%ebp)
        .equ mat, (2 * ws)
        .equ temp, (3 * ws)
        .equ items, (4 * ws)
        .equ k, (5 * ws)
        .equ len, (6 * ws)
        .equ begin, (7 * ws)
        .equ mat_index, (8 * ws)
        .equ temp_index, (9 * ws)

        // local vars (caller saved)
        .equ i, (-1 * ws)
    prologue_recur_end: 

    // Base case: if (temp_index == k)
    if_base_start:
        movl temp_index(%ebp), %ebx
        cmpl k(%ebp), %ebx
        jne else

        // for (int i = 0; i < k; i++)
        movl $0, i(%ebp)
        for_temp_start:
            movl i(%ebp), %ecx # ecx = i
            cmpl k(%ebp), %ecx
            jge for_temp_end

            // mat[*mat_index][i] = temp[i];
            movl temp(%ebp), %esi
            movl (%esi, %ecx, ws), %esi # edi = temp[i]

            movl mat_index(%ebp), %edx # edx = &mat_index
            movl (%edx), %edx # edx = *(&mat_index)
            movl mat(%ebp), %eax # eax = mat
            movl (%eax, %edx, ws), %eax # eax = mat[*mat_index][]
            movl %esi, (%eax, %ecx, ws) # mat[*mat_index][i] = temp[i]

            incl i(%ebp) # i++
            jmp for_temp_start
        for_temp_end:

        // (*mat_index)++;
        movl mat_index(%ebp), %ebx # ebx = &mat_index
        incl (%ebx) # ebx = mat_index
        // movl (%ebx), %ebx # ebx = *(&mat_index)
        // incl %ebx # ebx = (*(&mat_index))++
        // movl mat_index(%ebp), %eax #eax = &mat_index
        // movl %ebx, (%eax) # &mat_index = (*(&mat_index))++
        jmp recur_epilogue     
    
    else: 
    // for (int i = begin; i < len; i++)
    movl begin(%ebp), %ecx
    movl %ecx, i(%ebp) # ecx = i = begin
    for_mat_start:
        movl i(%ebp), %ecx
        cmpl len(%ebp), %ecx
        jge for_mat_end

        // temp[temp_index] = items[i];
        movl items(%ebp), %ebx # ebx = &(item[0])
        movl (%ebx, %ecx, ws), %edx # edx = item[i]

        movl temp(%ebp), %eax # eax = &(temp[0])
        movl temp_index(%ebp), %esi # esi = &(temp_index[0])
        movl %edx, (%eax, %esi, ws) # temp[temp_index] = items[i]

        // Get the combs recursively
        /* 
            combs_recursive(int** mat, int* temp, int* items, 
            int k, int len, int begin + 1, int* mat_index, int temp_index + 1)
        */ 

        // temp_index + 1 & begin + 1
        movl temp_index(%ebp), %eax
        incl %eax
        movl i(%ebp), %ecx
        incl %ecx

        // push all args
        push %eax # temp_index + 1
        push mat_index(%ebp)
        push %ecx # begin + 1
        push len(%ebp)
        push k(%ebp)
        push items(%ebp)
        push temp(%ebp)
        push mat(%ebp)

        call combs_recursive
        addl $8 * ws, %esp

        incl i(%ebp) # i++
        jmp for_mat_start
    for_mat_end:
  
    recur_epilogue:
        movl %ebp, %esp
        pop %ebp
        ret
