#include <iostream>
#include <string>


int main(int argc, char** argv){
    std::cout << "You entered the word: ";
    for (int i = 1; i < argc; i++) {
        // Convert the arg to the unsigned int
        unsigned int val = std::stoi(argv[i]);

        // Extract the 27th bit & the following 26 bits
        bool isUpper = (val >> 26) & 1;
        unsigned int num = val & 0x3FFFFFF;

        int pos = 0;

        // Find the position of 1
        while (pos < 26){
            if ((num >> pos) & 1){
                break;
            }
            pos++;
        }

        char letter = 'a' + pos;

        // An Uppercase or a Lowercase letter
        if (isUpper){
            letter = letter - 32;
        }

        std::cout << letter;
    }    
}