#include <iostream>
#include <fstream>
#include <vector>
#include <string>

using namespace std;

void readMatrx(const string& filename, int& n, vector<int>& matrix) {
    ifstream infile(filename);
    if (!infile.is_open()) {
        exit(1);
    }
    infile >> n;
    matrix.resize((n * n+n) / 2);
    for (int i = 0; i < n*(n+1)/2; ++i) {
        infile >> matrix[i];
    }
    infile.close();
}


int pullVal(const vector<int>& matrix, int n, int i, int j) {
    if (i > j) return 0;
    if(i==0){
        int index = j;
        return matrix[index];
    }
    else{
    int k = 0;
    for(int q =1;q<=i;q++){
        k+=q;
    }
    int index = (i+1)*n-(n-j-1)-k-1;
    return matrix[index];
    }
}

vector<int> Matrimulti(const vector<int>& A, const vector<int>& B, int n) {
    vector<int> C(n * (n + 1) / 2, 0);
    for (int i = 0; i < n; ++i) {
        for (int j = i; j < n; ++j) {
            for (int k = i; k <= j; ++k) {
                C[(i * n) - (i * (i + 1) / 2) + j] += pullVal(A, n, i, k) * pullVal(B, n, k, j);
            }
        }
    }
    return C;

}

// Main function
int main(int argc, char *argv[]){
    if (argc != 3){
        return 1;
    }
    int n; 
    vector<int> A, B;
    readMatrx(argv[1], n,A);
    readMatrx(argv[2], n,B);
    vector<int> C = Matrimulti(A,B,n);

    for (size_t i =0; i < C.size(); i++){
        cout << C[i] << " ";
    }
    cout << endl;
    return 0;
}