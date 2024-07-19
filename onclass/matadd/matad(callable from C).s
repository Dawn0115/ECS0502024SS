# another version of matadd that is callable from C
.global matadd
.equ ws, 4
.text

matadd:

    # ebp+5:num_cols
    # ebp+4:num_rows
    # ebp+3:B
    # ebp+2:A
    # ebp+1:return address
    # ebp : old ebp
    # ebp-1:i
    # ebp-2:j
    # ebp-3:C

    prologue_start:
    push %ebp # save old ebp
    movl %esp, %ebp # establish stack frame for this func
    
    



    .equ A, 2*ws # ebp
    .equ B, 3*ws # ebp
    .equ num_rows, 4*ws # ebp
    .equ num_cols, 5*ws # ebp
    .equ i, -1*ws # ebp
    .equ j, -2*ws # ebp
    .equ C, -3*ws # ebp 
    .equ old_edi, -4*ws # ebp
    .equ old_esi, -5*ws # ebp

    # save calle saved regs

    movl %edi, old_edi(%ebp)
    movl %esi, old_esi(%ebp)

    prologue_end:

    #ecx will be i

    # C = (int**)malloc(num_rows * sizeof(int*)) 

    //movl $4, %eax
    //imull num_rows(%ebp)
    //push %eax

    #save ecx(i) before function call to malloc
    #because we are the caller
    mov; %ecx , i(%ebp)

    movl num_rows(%ebp), %eax # eax = num_rows
    shll $2, %eax # eax = num_rows * sizeof(int*)
    push %eax # push eax to stack
    call malloc
    addl $1*ws, %esp # pop eax from stack to malloc
    movl %eax, C(%ebp) # C = malloc(num_rows * sizeof(int*))

    # for(i=0; i < num_rows; ++i)
    movl $0, %ecx
    outer_for_start:
        # i < num_rows
        # neg i - num_rows >= 0
        cmpl num_rows(%ebp), %ecx # i - num_rows
        jge outer_for_end

        # C[i] = (int*)malloc(num_cols * sizeof(int))
        movl num_cols(%ebp), %eax # eax = num_cols
        shll $2, %eax # eax = num_cols * sizeof(int)
        push %eax # push eax to stack
        call malloc # eax = malloc(num_cols * sizeof(int))
        addl $1*ws, %esp # pop eax from stack to malloc
        movl C(%ebp) , %edx # edx = C
        movl i(%ebp), %ecx # restore ecx back to i
        movl %eax, (%edx, %ecx, 4) # C[i] = (int*)malloc(num_cols * sizeof(int)) 

        #edi will be j
        movl $0, %edi # j = 0
        #for(j=0; j < num_cols; ++j)
        inner_for_start:
            # j < num_cols
            # neg j - num_cols >= 0
            cmpl num_cols(%ebp), %edi # j - num_cols
            jge inner_for_end

            # C[i][j] = A[i][j] + B[i][j]
            # *(*(C+i)+j) = *(*(A+i)+j) + *(*(B+i)+j)

            #A[i][j] == *(A + i*num_cols + j)
            movl A(%ebp), %edx # edx = A 
            movl (%edx, %ecx, 4), %edx # edx = A[i]
            movl (%edx, %edi, 4), %edx # edx = A[i][j]

            #B[i][j] == *(B + i*num_cols + j)
            movl B(%ebp), %esi # esi = B
            movl (%esi, %ecx, ws), %esi # esi = B[i]
            addl (%esi, %edi, ws), %edx # edx = A[i][j] + B[i][j]
            
            movl %edx, (%eax, %edi, 4) # C[i][j] = A[i][j] + B[i][j]

            incl %edi # ++j
            jmp inner_for_start
        inner_for_end:


        incl %ecx # ++i
        jmp outer_for_start 
    outer_for_end:

    #return C
    movl C(%ebp), %eax
    eqilogue_start:
        #restore callee saved regs
        movl old_edi(%ebp), %edi
        movl old_esi(%ebp), %esi

        movl %ebp, %esp # restore old esp
        pop %ebp # restore old ebp
        ret

    eqilogue_end:
