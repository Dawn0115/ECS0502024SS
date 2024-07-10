#include <iostream>
#include <string>
#include <algorithm>
#include <cmath>
#include <cctype>

// Function to convert a character to its corresponding integer value
int charToValue(char c) {
    if (std::isdigit(c)) {
        return c - '0';
    } else if (std::isalpha(c)) {
        return std::toupper(c) - 'A' + 10;
    }
    return -1; // Invalid character
}

// Function to convert an integer value to its corresponding character
char valueToChar(int value) {
    if (value >= 0 && value <= 9) {
        return '0' + value;
    } else if (value >= 10 && value <= 35) {
        return 'A' + value - 10;
    }
    return '?'; // Invalid value
}

// Function to convert a number from a given base to decimal (base 10)
long long NumtoDeci(const std::string &number, int base) {
    long long Decimal = 0;
    int len = number.size();
    for (int i = 0; i < len; ++i) {
        Decimal *= base;
        Decimal += charToValue(number[i]);
    }
    return Decimal;
}

// Function to convert a number from decimal (base 10) to a given base
std::string DecitoNewnum(long long decimal, int base) {
    if (decimal == 0) return "0";

    std::string result;
    while (decimal > 0) {
        int remainder = decimal % base;
        result += valueToChar(remainder);
        decimal /= base;
    }
    std::reverse(result.begin(), result.end());
    return result;
}

int main() {
    int currentBase, newBase;
    std::string number;

    std::cout << "Please enter the number's base: ";
    std::cin >> currentBase;
    std::cout << "Please enter the number: ";
    std::cin >> number;
    std::cout << "Please enter the new base: ";
    std::cin >> newBase;

    // Convert the number to decimal
    auto Decimal = NumtoDeci(number, currentBase);

    // Convert the decimal number to the new base
    std::string newNumber = DecitoNewnum(Decimal, newBase);

    std::cout << number << " base " << currentBase << " is " << newNumber << " base " << newBase << std::endl;

    return 0;
}