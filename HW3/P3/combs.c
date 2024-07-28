#include "combs.h"
#include <stdio.h>


/**
 * @param mat: all combinactories
 * @param temp_arr: each combinactory
 * @param items: the int pointer contain all items
 * @param k: numbers taken from items
 * @param len: number of items
 * @param begin: beginning of the iteration
 * @param result_index: index of the matrix
 * @param temp_index: index of the temporary array
 */
void combs_recursive(int** mat, int* temp_arr, int* items, 
        int k, int len, int begin, int* result_index, int temp_index){
    // Base case -> if numbers taken are full
    if (temp_index == k){
        // Store k elements from the temp array -> the matrix
        for (size_t i = 0; i < k; i++){
            mat[*result_index][i] = temp_arr[i];       
        }
        (*result_index)++;
        return;
    } 

    // pick k elements from len numbers of the items
    for (size_t i = begin; i < len; i++){
        // Store one element from items -> the temp array
        temp_arr[temp_index] = items[i];   
        combs_recursive(mat, temp_arr, items, 
            k, len, i + 1, result_index, temp_index + 1);
    }   
}   


/**
 * @param items: the int pointer contain all items
 * @param k: numbers taken from items
 * @param len: number of items
 * @return the matrix contains all combinactories 
 */
int** get_combs(int* items, int k, int len){   
    int total_nums = num_combs(len, k);

    // Allocate a 2D array -> all combinactories
    int** result_mat = (int**)malloc(total_nums * sizeof(int*));
    for (size_t i = 0; i < total_nums; i++){
        result_mat[i] = (int*)malloc(k * sizeof(int));
    }

    // Init a 1D array -> 1 temp combinactory
    int* temp_arr = (int*)malloc(k * sizeof(int));

    // Get the combs recursively
    int result_index = 0;
    combs_recursive(result_mat, temp_arr, items, k, len, 0, &result_index, 0);


    free(temp_arr);
    return result_mat;
}

