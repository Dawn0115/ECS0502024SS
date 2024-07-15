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
    .string "Cat"

.text
my_strlen_reg:
    # argumens s shoulbe be placed in eax
    # return calue will be placed in ebx
    # register should be caller saved

    #ecx will be i


    # for(int i  = , str[i] != '\0'; ++i)
    movl $0, %ecx # i = 0

    strlen_reg_for_start:
        # str[i] != '\0'
        # str[i] - '\0' != 0
        # neg `str[i] - '\0'` == 0
        cmpl $0, (%eax, %ecx, 1) # str[i] - '\0'
        je strlen_reg_for_end
        incl %ecx # ++i
    strlen_reg_for_end:
    movl %ecx, %ebx # set return value
    ret
    
 _start:
    movl $test_string, %eax
    call my_strlen_reg
    


