#include "MyFloat.h"


MyFloat::MyFloat(){
  sign = 0;
  exponent = 0;
  mantissa = 0;
}

MyFloat::MyFloat(float f){
  unpackFloat(f);
}

MyFloat::MyFloat(const MyFloat & rhs){
	sign = rhs.sign;
	exponent = rhs.exponent;
	mantissa = rhs.mantissa;
}

ostream& operator<<(std::ostream &strm, const MyFloat &f){
	//this function is complete. No need to modify it.
	strm << f.packFloat();
	return strm;
}


MyFloat MyFloat::operator+(const MyFloat& rhs) const {
    MyFloat res(0);  // Result initialized to zero
    MyFloat a(*this);
    MyFloat b(rhs);

    // Special case: a + b == 0 (opposite numbers)
    if ((a.sign != b.sign) && (a.exponent == b.exponent) && (a.mantissa == b.mantissa)) {
        return res;  // Return zero
    }

    // Restore implicit 1 for normalized numbers
    if (a.exponent != 0) {
        a.mantissa += (1 << 23);
    }
    if (b.exponent != 0) {
        b.mantissa += (1 << 23);
    }

    // Align exponents by shifting mantissas
    if (a.exponent < b.exponent) {
        int shift = b.exponent - a.exponent;
        a.mantissa >>= shift;
        a.exponent = b.exponent;
    } else if (a.exponent > b.exponent) {
        int shift = a.exponent - b.exponent;
        b.mantissa >>= shift;
        b.exponent = a.exponent;
    }

    // Set the exponent of the result
    res.exponent = a.exponent;

    // Perform addition or subtraction based on signs
    if (a.sign == b.sign) {
        res.mantissa = a.mantissa + b.mantissa;
        res.sign = a.sign;
    } else {
        if (a.mantissa >= b.mantissa) {
            res.mantissa = a.mantissa - b.mantissa;
            res.sign = a.sign;
        } else {
            res.mantissa = b.mantissa - a.mantissa;
            res.sign = b.sign;
        }
    }

    // Normalize the result mantissa and adjust the exponent
    if (res.mantissa == 0) {
        res.sign = 0;
        res.exponent = 0;
    } else {
        while (res.mantissa >= (1 << 24)) {  // Check for overflow
            res.mantissa >>= 1;
            res.exponent++;
        }

        while ((res.mantissa & (1 << 23)) == 0 && res.exponent > 0) {  // Check for underflow
            res.mantissa <<= 1;
            res.exponent--;
        }
    }

    // Remove the implicit 1
    if (res.exponent > 0) {
        res.mantissa -= (1 << 23);
    }

    return res;
}

MyFloat MyFloat::operator-(const MyFloat& rhs) const{
  MyFloat res;
  MyFloat a(*this);
  MyFloat b(rhs);

  // Flip the sign of b
  // a - b = a + (-b)
  b.sign = (b.sign == 0) ? 1 : 0;
  res = a + b;
	return res;
}

bool MyFloat::operator==(const float rhs) const{
  MyFloat b(rhs);
  if ((this->sign == b.sign) && (this->exponent == b.exponent) 
                      && (this->mantissa == b.exponent)){
    return true;
  } else{
    return false;
  }
}

void MyFloat::unpackFloat(float f) {
    //this function must be written in inline assembly
    //extracts the fields of f into sign, exponent, and mantissa
    __asm__(
      //extracts float to sign
      "movl %[f], %%eax;"
      "movb $1, %%ch;"
      "movb $31, %%cl;"
      "bextr %%ecx, %%eax, %%ebx;"
      "movl %%ebx, %[sign];"

      //extracts float to exponent
      "movl %[f], %%eax;"
      "movb $8, %%ch;"
      "movb $23, %%cl;"
      "bextr %%ecx, %%eax, %%ebx;"
      "movl %%ebx, %[exponent];"

      //extracts exponent to mantissa
      "movl %[f], %%eax;"
      "movb $23, %%ch;"
      "movb $0, %%cl;"
      "bextr %%ecx, %%eax, %%ebx;"
      "movl %%ebx, %[mantissa];"

      :[sign] "=r" (sign), [exponent] "=r" (exponent), [mantissa] "=r" (mantissa)
      :[f] "r" (f)
      :"cc", "%eax", "%ebx", "%ecx"
    );

    return;
}//unpackFloat


float MyFloat::packFloat() const{
    //this function must be written in inline assembly
    //returns the floating point number represented by this
    float f = 0;
    __asm__(

      // Init the float
      "movl $0, %[f];"

      // Shift and place the sign in float
      "shll $31, %[sign];"
      "orl %[sign], %[f];"
      "orl %[mantissa], %[f];"

      // Shift and place the exponent in float
      "shll $23, %[exponent];"
      "orl %[exponent], %[f];"



      :[f] "=&r" (f)
      :[sign] "r" (sign), [exponent] "r" (exponent), [mantissa] "r" (mantissa)
      :"cc"
    );

    return f;
}//packFloat