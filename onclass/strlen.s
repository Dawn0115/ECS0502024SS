/*
In C code

strlen(const char *s){
    for(int i  = , str[i] != '\0'; ++i)
    //empty on purpose
    return i;
}

*/
.global _start
.data

test_string:
    .stri ng "Cat"
test_string_2:
    .string"Truth is a lie. Everything is permitted."
str_len_arg:
    .long 0

str_len_ret:
    .long 0
.text
my_strlen_reg:
    # argumens s shoulbe be placed in str_len_arg
    # return calue will be placed in str_len_ret
    # register should be caller saved

    #ecx will be i
    #eax will be s
    push %ecx # save old ecx
    push %eax # save old eax
    movl str_len_arg, %eax # eax = s


    # for(int i  = , str[i] != '\0'; ++i)
    movl $0, %ecx # i = 0

    strlen_reg_for_start1:
        # str[i] != '\0'
        # str[i] - '\0' != 0
        # neg `str[i] - '\0'` == 0
        cmpb  $0, str_len_arg  (%eax, %ecx, 1) # str[i] - '\0'
        je strlen_reg_f or_end1
        incl %ecx # ++i
        jmp strlen_reg_for_start1

    strlen_reg_for_end1:
    movl %ecx, str_len_ret # set return value
    pop %eax # restore old eax
    pop %ecx # restore old ecx  
    ret
my_strlen_mem_end:
    
 _start:
    movl $25, %eax
    movl $16, %ebx
    movl $99, %ecx

    push %eax
    push %ebx
    push %ecx

    movl $test_string, %eax
    call my_strlen_reg

    pop %ecx
    pop %ebx
    pop %eax

    movl $test_string_2, %eax
    call my_strlen_mem_end
    # result will be stored  str_len_ret

    movl  strlen_ret, %esi