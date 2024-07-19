#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>

#define N 1000 // Define a ordem das matrizes

int** allocate_matrix(int rows, int cols) {
    int** matrix = (int**)malloc(rows * sizeof(int*));
    for (int i = 0; i < rows; i++) {
        matrix[i] = (int*)malloc(cols * sizeof(int));
    }
    return matrix;
}

void free_matrix(int** matrix, int rows) {
    for (int i = 0; i < rows; i++) {
        free(matrix[i]);
    }
    free(matrix);
}

void initialize_matrices(int** A, int** B, int rows, int cols) {
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
            C[i][j] = 0;
            for (int k = 0; k < cols; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
            if (C[i][j] % 2 == 0) {
                (*even_count)++;
            }
        }
    }
}

void multiply_matrices_parallel(int** A, int** B, int** C, int rows, int cols, int* even_count) {
    int local_even_count = 0;
    #pragma omp parallel for reduction(+:local_even_count)
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            C[i][j] = 0;
            for (int k = 0; k < cols; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
            if (C[i][j] % 2 == 0) {
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
    initialize_matrices(A, B, N, N);

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
    free_matrix(A, N);
    free_matrix(B, N);
    free_matrix(C, N);

    return 0;
}