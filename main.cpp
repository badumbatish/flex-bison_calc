#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <unistd.h>
#include<sys/wait.h> 
#include <iostream>

extern int calc(char str[]);

int main(int argc, char *argv[]) {
    calc("1+2");
    return 0;
}
