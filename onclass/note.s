uint32_t  
shll %cl %eax # ea x = eax << cl
cl is the lower 8 bits of ecx, so movl $3, %ecx will set cl to 3
