#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>

#define N 1000 // Define a ordem das matrizes

int** allocate_matrix(int rows, int cols) {
    int* data = (int*)malloc(rows * cols * sizeof(int));
    int** matrix = (int**)malloc(rows * sizeof(int*));
    for (int i = 0; i < rows; i++) {
        matrix[i] = &(data[cols * i]);
    }
    return matrix;
}

void free_matrix(int** matrix) {
    free(matrix[0]);
    free(matrix);
}

void initialize_matrices(int** A, int** B, int rows, int cols) {
    #pragma omp parallel for collapse(2)
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            A[i][j] = rand() % 100;
            B[i][j] = rand() % 100;
        }
    }
}

void multiply_matrices_serial(int** A, int** B, int** C, int rows, int cols, int* even_count) {
    *even_count = 0;
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            int sum = 0;
            for (int k = 0; k < cols; k++) {
                sum += A[i][k] * B[k][j];
            }
            C[i][j] = sum;
            if (sum % 2 == 0) {
                (*even_count)++;
            }
        }
    }
}

void multiply_matrices_parallel(int** A, int** B, int** C, int rows, int cols, int* even_count) {
    int local_even_count = 0;
    #pragma omp parallel for collapse(2) reduction(+:local_even_count)
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            int sum = 0;
            for (int k = 0; k < cols; k++) {
                sum += A[i][k] * B[k][j];
            }
            C[i][j] = sum;
            if (sum % 2 == 0) {
                local_even_count++;
            }
        }
    }
    *even_count = local_even_count;
}

int main() {
    int** A = allocate_matrix(N, N);
    int** B = allocate_matrix(N, N);
    int** C = allocate_matrix(N, N);
    int even_count_serial = 0, even_count_parallel = 0;
    double start, end;

    srand(time(NULL));
    
    start = omp_get_wtime();
    initialize_matrices(A, B, N, N);
    end = omp_get_wtime();
    printf("Tempo de inicialização das matrizes: %f segundos\n\n", end - start);

    // Multiplicação serial
    start = omp_get_wtime();
    multiply_matrices_serial(A, B, C, N, N, &even_count_serial);
    end = omp_get_wtime();
    printf("Tempo de execução serial: %f segundos\n", end - start);
    printf("Quantidade de elementos pares na matriz resultado (serial): %d\n\n", even_count_serial);

    // Multiplicação paralela
    start = omp_get_wtime();
    multiply_matrices_parallel(A, B, C, N, N, &even_count_parallel);
    end = omp_get_wtime();
    printf("Tempo de execução paralelo: %f segundos\n", end - start);
    printf("Quantidade de elementos pares na matriz resultado (paralelo): %d\n", even_count_parallel);

    // Liberar a memória alocada
    free_matrix(A);
    free_matrix(B);
    free_matrix(C);

    return 0;
}