#include <stdio.h>

int rec_sum(int*nums, int len);
int main(){
    int nums[]= {10,20,5,13};
    int len = 4;
    printf("Sum of the array is %d\n", rec_sum(nums, len));
    return 0;
}