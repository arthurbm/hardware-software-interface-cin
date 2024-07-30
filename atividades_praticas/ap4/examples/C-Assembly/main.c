#include <stdio.h>

extern float calc_circ_area(float raio);

int main() {

    float ret = calc_circ_area(5.0);

    printf("area de circ com raio 5 eh igual ah: %f \n", ret);

    return 0;

}

