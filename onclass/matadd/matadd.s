/*

void matAdd(int A[3][4], int B[3][4], int numRows, int numCols, int C[3][4]){
    for(int i=0; i<numRows; i++){
        for(int j=0; j<numCols; j++){
            C[i][j] = A[i][j] + B[i][j];
        }
    }
}

*/

# This is designed for one big chunk of memory
.global _start
.equ ws,4

.data

matA:
    .long 10
    .lomg 20
    .long 30
    .long 40

    .long 50
    .long 60
    .long 70
    .long 80

    .long 90
    .long 100
    .long 110
    .long 120

matB:
    .long 10*10
    .lomg 20*10
    .long 30 * 10
    .long 40 * 10

    .long 50 * 10
    .long 60 * 10
    .long 70 * 10
    .long 80 * 10

    .long 90 * 10
    .long 100 * 10
    .long 110 * 10
    .long 120 * 10

matC:
    .space 12 * ws

numRows:
    .long 3
     
numCols:
    .long 4

i:
    .long 0


.text
_start:
    #eax will be i
    #ebx will be j
    # for(int i=0; i<numRows; i++)
    movl $0, %eax

    outer_for_start:
        # i<numRows
        # i-numRows < 0
        # neg i - numRows >=0 
        cmpl numRows, %eax
        jge outer_for_end
        imull numCols # eax = i * numCols

        # for(int j=0; j<numCols; j++)
        movl $0, %ebx # j=0
        inner_for_start:
            # j < numCols
            # j - numCols < 0
            # neg j - numCols >= 0
            movl %eax, i # save value of i to memory
            cmpl numCols, %ebx # j - numCols
            jge inner_for_end
            # C[i][j] = A[i][j] + B[i][j]
            # *(C + i * numCols + j) = *(A + i * numCols + j) + *(B + i * numCols + j)

            #ECX = A[i][j]
            # *(A + i * numCols + j)
            
            addl %ebx, %eax # eax = i * numCols + j
            movl matA(,%eax,ws), %ecx # ecx = A[i][j]

            # *(B + i * numCols + j)
            addl matB(,%eax,ws), %ecx # ecx = A[i][j] + B[i][j]
            #C[i][j] = A[i][j] + B[i][j]
            movl %ecx,matC(,%eax,ws)

            
            incl %ebx 
            jmp inner_for_start 
        inner_for_end:
        movl i, %eax # restore value of i
        incl %eax
        jmp outer_for_start
    outer_for_end:
done:
    nop


/*
# a = b + c++
movl %ebx, %eax # a = b
addl %ecx, %eax # a = a + c
incl %ecx # c++  
*/







 

