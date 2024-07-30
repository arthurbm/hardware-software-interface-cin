#include <stdio.h>

extern float calc_cone_volume(float raio, float altura);

int main() {
    float raio = 3.0f;
    float altura = 4.0f;
    float volume;

    volume = calc_cone_volume(raio, altura);

    printf("O volume do cone com raio %.2f e altura %.2f é: %.2f\n", raio, altura, volume);

    return 0;
}