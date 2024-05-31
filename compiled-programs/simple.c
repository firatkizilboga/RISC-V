#include <stdint.h>
uint16_t *a = (uint16_t*)0x00000000;
uint16_t *b = (uint16_t*)0x0000000A;
uint16_t *c = (uint16_t*)0x00000010;

int main (){
    *a = 12;
    *b = 24;
    *c = 0;

    *c = *a + *b;

    return 0;
}
