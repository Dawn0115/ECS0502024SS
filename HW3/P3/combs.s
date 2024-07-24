/*

int** get_combs(int* items, int k, int len){
    for (int i = 1; i < k; i++) {
        int k *= i;
    }
    for (int i = 1; i < len; i++) {
        int len *= i;
    }
    for (int i = 1; i < len - k; i++) {
        int diff *= i;
    }
    int total = len / (k * diff);


    int** result = (int**)malloc(total_combinations * sizeof(int*));
    for (int i = 0; i < total_combinations; i++) {
        result[i] = (int*)malloc(k * sizeof(int));
    }
    

}

*/
