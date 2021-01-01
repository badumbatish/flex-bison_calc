#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <unistd.h>
#include<sys/wait.h> 

int main() {
    // We use two pipes 
    // First pipe to send input string from parent 
    // Second pipe to send concatenated string from child 
  
    int pip1[2];  // Used to store two ends of first pipe 
    int pip2[2];  // Used to store two ends of second pipe 

    char fixed_str[] = "forgeeks.org";
    char input_str[100];

    pid_t p; // The pid_t data type is a signed integer type which is capable of representing a process ID. In the GNU C Library, this is an int.
    if(pipe(pip1)==-1) {
        fprintf(stderr,"First pipe failed");
        return 1;
    }
    if(pipe(pip2)==-1) {
        fprintf(stderr,"Second pipe failed");
        return 1;
    }

    p = fork();
    if(p < 0 ) {
        fprintf(stderr,"Forking failed");
        return 1;
    }


    // https://stackoverflow.com/questions/19265191/why-should-you-close-a-pipe-in-linux

    else if (p>0) { // parent code
        close(pip1[0]);

        char writer[100];
        while(true) {
            fgets(writer,100,stdin);
            std::cout << "Parent said something" << std::endl;
            write(pip1[1],writer,100);
        }
        close(pip1[1]);

    } else { // child code
        close(pip1[1]);
        char str[100];
        while(true) {
            read(pip1[0],str,100);
            printf("Child has received message: %s\n",str);
        }
        close(pip1[0]);
    } 
    return 0;
}