#include <stdlib.h>
#include <stdio.h>

// This leaks buffers and is unsafe
char *toBinary(char num)
{
    char *buffer = malloc(50);
    int index = 0;

    for (int i = sizeof(char) * 8 - 1; i >= 0; i--)
    {
        buffer[index++] = ((num >> i) & 1) + '0';
        if (i % 4 == 0)
            buffer[index++] = ' ';
    }
    buffer[index] = 0;
    return buffer;
}

int main()
{
    unsigned char x = 127;
    char y = 127;

    printf("x: \t %d \t\t %s \n", x, toBinary(x));
    printf("y: \t %d \t\t %s \n", x, toBinary(y));

    x = x + 1;
    y = y + 1;

    printf("x + 1: \t %d \t\t %s \n", x, toBinary(x));
    printf("y + 1: \t %d \t\t %s \n", y, toBinary(y));

    printf("\n\n");

    x = 0;
    y = 0;
    printf("x: \t %d \t\t %s \n", x, toBinary(x));
    printf("y: \t %d \t\t %s \n", y, toBinary(y));

    x = x - 1;
    y = y - 1;
    printf("x - 1: \t %d \t\t %s \n", x, toBinary(x));
    printf("y - 1: \t %d \t\t %s \n", y, toBinary(y));

    return 0;
}
