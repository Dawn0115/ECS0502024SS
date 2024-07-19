/*
    int recstrcmp(const char* str 1, const char * str2){
        if(str1[0] == '\0' && str[2] == '\0'){
            return 0;
        }
        else if(str1[0] != str2[0]){
            return str1[0] - str2[0];
        }
        else{
            return recstrcmp(str1 + 1, str2 + 1);
        }
    }

*/

.global rec_strcmp
.equ