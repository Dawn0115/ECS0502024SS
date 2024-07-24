
/*

int** matMult(int **a, int num_rows_a, int num_cols_a, int** b, int num_rows_b, int num_cols_b); {
    int **result = (int **) malloc(num_rows_a * sizeof(int *));
    for(int i = 0; i < num_rows_a; i++){
        result[i] = (int *) malloc(num_cols_b * sizeof(int));
    }
    for(int i = 0; i < num_rows_a; i++){
        for(int j = 0; j < num_cols_b; j++){
            result[i][j] = 0;
            for(int k = 0; k < num_cols_a; k++){
                result[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    return result;
}

*/

.global matMult
.text
.equ ws, 4

# 7: num_cols_b
# 6: num_rows_b
# 5: b
# 4: num_cols_a
# 3: num_rows_a
# 2: a
# 1: return address
# ebp: old ebp
# -1 : i
# -2 : j
# -3 : C
# -4: old_ebx
# -5: old_esi
# -6: old_edi


matMult:
    prologue_start:
            push %ebp #save old ebp
            movl %esp, %ebp #establish stack frame for this func
            
            .equ num_locals, 2
            .equ use_ebx, 1
            .equ use_esi, 1

            .equ use_edi, 1
            .equ num_saved_regs, (use_edi + use_esi + use_ebx)
            subl $(num_locals + num_saved_regs) * ws, %esp # allocate space for locals

            .equ a, 2 * ws #ebp
            .equ num_rows_a, 3 * ws #ebp
            .equ num_cols_a, 4 * ws #ebp
            .equ b, 5 * ws #ebp
            .equ num_rows_b, 6 * ws #ebp
            .equ num_cols_b, 7 * ws #ebp
            .equ i, -1 * ws #ebp
            .equ j, -2 * ws #ebp
            .equ C, -3 * ws #ebp
            .equ old_ebx, -4 * ws #ebp
            .equ old_esi, -5 * ws #ebp
            .equ old_edi, -6 * ws #ebp



            #save callee saved regs
            movl %ebx, old_ebx(%ebp)
            movl %esi, old_esi(%ebp)

        prologue_end:

        # int **result = (int **) malloc(num_rows_a * sizeof(int *));

        movl num_rows_a(%ebp), %eax # eax = num_rows_a
        shll $2, %eax # eax = num_rows_a * sizeof(int *)
        push %eax # push eax to stack
        call malloc
        addl $1 * ws, %esp # pop eax from stack to malloc
        movl %eax, C(%ebp)

        # for(int i = 0; i < num_rows_a; i++)
        # ecx will be i
        movl $0, %ecx # i = 0

        first_for_start:
            movl %ecx, i(%ebp)
            # i < num_rows_a
            #neg: i - num_rows_a >= 0
            cmpl num_rows_a(%ebp), %ecx
            jge first_for_end
            # result[i] = (int *) malloc(num_cols_b * sizeof(int));
            movl num_cols_b(%ebp), %eax # eax = num_cols_b
            shll $2, %eax # eax = num_cols_b * sizeof(int)
            push %eax # push eax to stack
            call malloc
            addl $1 * ws, %esp # pop eax from stack to malloc
            movl C(%ebp), %edx # edx = C
            movl i(%ebp), %ecx
            movl %eax, (%edx, %ecx, 4) # result[i] = malloc(num_cols_b * sizeof(int))

            incl %ecx # i++
            jmp first_for_start
        first_for_end:

        movl $0, %ecx # i = 0
        second_for_start:
            # for(int i = 0; i < num_rows_a; i++){
            cmpl num_rows_a(%ebp), %ecx # i < num_rows_a
            jge second_for_end

            movl $0, %edx # j = 0
            inner_for_start:
                # for(int j = 0; j < num_cols_b; j++){
                cmpl num_cols_b(%ebp), %edx # j < num_cols_b
                jge inner_for_end
                # result[i][j] = 0;
                movl C(%ebp), %ebx
                movl (%ebx, %ecx, 4), %ebx # ebx = result[i]
                movl $0, (%ebx, %edx, 4) # result[i][j] = 0

                movl $0, %edi # k = 0
                multi_for_start:
                    # for(int k = 0; k < num_cols_a; k++){
                    cmpl num_cols_a(%ebp), %edi # k < num_cols_a
                    jge multi_for_end
                    # result[i][j] += a[i][k] * b[k][j];
                    movl a(%ebp), %eax # eax = a
                    movl (%eax, %ecx, 4), %eax # eax = a[i]
                    movl (%eax, %edi, 4), %eax # eax = a[i][k]
                    movl b(%ebp), %esi # edx = b
                    movl (%esi, %edi, 4), %esi # edx = b[k]
                    imull (%esi, %edx, 4), %eax # eax = a[i][k] * b[k][j]

                    movl C(%ebp), %ebx
                    movl (%ebx, %ecx, 4), %ebx # ebx = result[i]
                    addl %eax, (%ebx, %edx, 4)
                    incl %edi # k++
                    jmp multi_for_start
                multi_for_end:
                incl %edx # j++
                jmp inner_for_start
            inner_for_end:

            incl %ecx # i++
            jmp second_for_start
        second_for_end:
    # return result;
    movl C(%ebp), %eax
    epilogue_start:
    #restore callee saved regs
    movl old_ebx(%ebp), %ebx
    movl old_esi(%ebp), %esi
    movl old_edi(%ebp), %edi

    movl %ebp, %esp #restore esp
    pop %ebp #restore old ebp
    ret
    epilogue_end:
