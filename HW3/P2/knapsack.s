.global knapsack
.equ ws, 4

.text


knapsack:
    prologue_start:
        // init the stack
        push %ebp
        movl %esp, %ebp

        // set the space
        .equ num_locals, 2
        .equ used_ebx, 0
        .equ used_esi, 0
        .equ used_edi, 0
        .equ num_saved_regs, (used_ebx + used_edi + used_esi)
        subl $(num_locals + num_saved_regs) * ws, %esp

        // set index for data (%ebp)
        .equ weights, (2 * ws)
        .equ values, (3 * ws)
        .equ num_items, (4 * ws)
        .equ capacity, (5 * ws)
        .equ cur_value, (6 * ws)

        // TODO: for callee saved regs
        .equ i, (-1 * ws)
        .equ best_values, (-2 * ws) 

    prologue_end:
    // int best_values = cur_value;
    movl cur_value(%ebp), %eax
    movl %eax, best_values(%ebp)

    // for(i = 0; i < num_items; i++)
    movl $0, %ecx # ecx = i = 0
    movl %ecx, i(%ebp)

    for_start:
        movl i(%ebp), %ecx
        movl num_items(%ebp), %eax # eax = num_items
        // i - num_items <  0
        cmpl %eax, %ecx
        jae for_end

        // if(capacity - weights[i] >= 0 )
        if_start:
            movl capacity(%ebp), %eax # eax = capacity
            movl weights(%ebp), %edx # edx = weights
            movl (%edx, %ecx, ws), %edx # edx = weights[i]
            cmpl %edx, %eax 
            jl if_end

            // push the last 2 args
            subl %edx, %eax # eax = 5th arg
            movl values(%ebp), %edx # edx = values
            movl (%edx, %ecx, ws), %edx # edx = values[i]
            addl cur_value(%ebp), %edx # edx = 6th arg
            push %edx
            push %eax

            // 4th: num_items - i - 1
            incl %ecx # i + 1
            movl num_items(%ebp), %eax # eax = num_items
            subl %ecx, %eax # eax = num_items - i - 1
            push %eax

            // 3rd: values + i + 1
            movl values(%ebp), %eax
            leal (%eax, %ecx, ws), %eax
            push %eax

            // 2nd: weights + i + 1
            movl weights(%ebp), %eax
            leal (%eax, %ecx, ws), %eax
            push %eax

            // call knapsack 
            call knapsack
            addl $5*ws, %esp

            // call max
            // best_values(in memo) - eax > 0
            if_max_start:
                movl best_values(%ebp), %edx
                cmpl %edx, %eax
                jae if_max_end
                movl %edx, %eax
            if_max_end:
                movl %eax, best_values(%ebp)
            
        if_end:

        movl i(%ebp), %ecx
        incl %ecx # i++
        movl %ecx, i(%ebp)
        jmp for_start

    for_end:

    // base case
    movl best_values(%ebp), %eax

    epilogue_start:
        // TODO: Restore callee saved regs
        movl %ebp, %esp 
        pop %ebp
        ret

    epilogue_end:
