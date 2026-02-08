#include <stdlib.h>
#include <stdio.h>

// This leaks buffers AND is unsafe
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
    unsigned char u; // Un nombre positif sur 8 bits
    u = 127;
    printf("u \t %d \t\t %s \n", u, toBinary(u));
    u = u + 1;
    printf("u + 1 \t %d \t\t %s \n", u, toBinary(u));
    printf("\n");
    u = 0;
    printf("u \t %d \t\t %s \n", u, toBinary(u));
    u = u - 1;
    printf("u - 1 \t %d \t\t %s \n", u, toBinary(u));
    printf("\n");
    printf("\n");

    char s; // Un nombre relatif sur 8 bits
    s = 127;
    printf("s \t %d \t\t %s \n", s, toBinary(s));
    s = s + 1;
    printf("s + 1 \t %d \t\t %s \n", s, toBinary(s));
    printf("\n");
    s = 0;
    printf("s \t %d \t\t %s \n", s, toBinary(s));
    s = s - 1;
    printf("s - 1 \t %d \t\t %s \n", s, toBinary(s));
    printf("\n");

    return 0;
}
