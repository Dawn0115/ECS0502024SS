#include<stdio.h>
int rec_strcmp(char* str1,char* str2);

int main(int argc, char* argv[]){
    int result = rec_strcmp(argv[1],argv[2]);
    if (result == 0)
    {
        printf("The strings are equal\n");
    }
    else if(result == 0){
        printf("%s comes after %s\n",argv[1],argv[2]);
    }else{
        printf("%s comes before %s\n",argv[1],argv[2]);
    }  
}