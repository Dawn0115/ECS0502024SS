#include <iostream>
#include <bitset>

/**
 * Print all binary digits of the mantissa excepts 0's at the end
 * @param val: mantissa
 * @param begin: the largest significant level of the val
 * @param end: pos before 0's at the end
 */
void printBits(unsigned int val, int begin, int end){
    for (int i = begin; i >= end; i--) {
        std::cout << ((val >> i) & 1);
    }
}


int main(){
    float f;
    std::cout << "Please enter a float: ";
    std::cin >> f;

    // Convert float to unsigned int
    unsigned int float_int = *((unsigned int*) &f);

    // Extract sign, exponent value and mantissa
    unsigned int sign = (float_int >> 31) & 1;
    unsigned int exp = (float_int >> 23) & 0xFF;
    unsigned int mantissa = float_int & 0x7FFFFF;

    // Find the position before all 0's at the end
    int pos = 0;
    while (pos < 23){
        if ((mantissa >> pos) & 1){
            break;
        }
        pos++;
    }

    // Check the sign of float
    if (sign){
        std::cout << "-";
    }

    std::cout << "1.";
    printBits(mantissa, 22, pos);
    std::cout << "E" << exp-127;
}