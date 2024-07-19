uint32_t  
shll %cl %eax # ea x = eax << cl
cl is the lower 8 bits of ecx, so movl $3, %ecx will set cl to 3
ecx, edx, and eax are caller saved register, so we hav to save their value before any function call if we care their value
