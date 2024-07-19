 /*
 int fib(int){
    if (n == 0||n == 1){
        return 1;
    }
    else{
        return fib(n-1) + fib(n-2);
    }
 }
 */

 .global fib
 .equ ws,4
 .text

 fib:
    #+2: n
    #+1: return address
    #ebp: old ebp
    # -1: fib(n-1)
    # esp: n-1 [line65]



    prologue_start:
        push %ebp #save old ebp
        movl %esp, %ebp #establish stack frame for this func
        
         .equ num_locals, 1 
        .equ use_ebx, 0
        .equ use_esi, 0
        .equ use_edi, 0
        .equ num_saved_regs, (use_edi + use_esi + use_ebx)
        subl $(num_locals + num_saved_regs) * ws, %esp # allocate space for locals

        .equ n, (2 * ws) #ebp
        .equ fib_n1, -1 * ws #ebp

        #sace callee saved regs

    prologue_end:

    // if (n == 0||n == 1)
    #eax will be n
    movl n(%ebp), %eax #eax = n
    cmpl $0 , %eax # n -0
    je base_case
    cmpl $1, %eax # n - 1
    je base_case
    jmp recursive_case


    base_case:
    #return 1
    movl $1, %eax
    jmp epilogue_start

    recursive_case:
    #return fib(n-1) + fib(n-2);

    #call fib(n-1)
    subl$1, %eax
    push %eax
    call fib #eax = fib(n-1)
    movl %eax, fib_n1(%ebp) #fib_n1 = fib(n-1) 
    
    //decl (%ebp)
    addl $1*ws, %esp #pop eax from stack    
    movl n(%ebp), ecx #ecx = n
    subl $2, ecx #ecx = n-2
    push ecx


    call fib #eax = fib(n-2)
    addl $1*ws, %esp #pop ecx from stack
    addl fib_n1(%ebp), %eax #eax = fib(n-1) + fib(n-2) 

    eqilogue_start:
        #no saved register to restore
        movl %ebp, %esp #restore esp
        pop %ebp #restore old ebp
        ret


    eqilogue_end: