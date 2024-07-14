#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv){
    unsigned int dividend = (unsigned int)strtoul(argv[1], 0, 10);
    unsigned int divisor = (unsigned int)strtoul(argv[2], 0, 10);

    unsigned int quotient = 0, remainder;

    // Division in binary
    for (int i = 31; i >= 0; --i) {
        if ((dividend >> i) >= divisor){
            quotient |= (1 << i); // set 1 to the ith bit
            dividend -= (divisor << i);
        }
    }

    remainder = dividend;
    printf("%s / %s = %u R %u", argv[1], argv[2], quotient, remainder);


    return 0;
}