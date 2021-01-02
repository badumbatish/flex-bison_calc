#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <unistd.h>
#include<sys/wait.h> 
#include <iostream>

int main(int argc, char *argv[]) {
    // We use two pipes 
    // First pipe to send input string from parent 
    // Second pipe to send concatenated string from child 
  
    int pip1[2];  // Used to store two ends of first pipe // parent write child read
    int pip2[2];  // Used to store two ends of second pipe // parent read child write


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
    setvbuf(stdout, NULL, _IONBF, 0);

    if(p < 0 ) {
        fprintf(stderr,"Forking failed");
        return 1;
    }


    // https://stackoverflow.com/questions/19265191/why-should-you-close-a-pipe-in-linux

    else if (p>0) { // parent code
        close(pip1[0]); 
        close(pip2[1]);
        close(pip2[0]);
        char writer[100];
        while(fgets(writer,100,stdin)) {
            //std::cout << "Writing" << std::endl;
            if(write(pip1[1],writer,strlen(writer))<0) return -1;
            //read(pip2[0],writer,100);
            //printf("%s",writer);
        }

    } else if(p==0) { // child code
        /*
        dup2(pip1[0],0);
        char  str[100];
        while(1) {
            
            fgets(str,100,stdin);
            printf("%.*s",int(strlen(str)),str);
        }
        */
        
        dup2(pip1[0],0);
        //dup2(pip2[1],1);
        close(pip1[0]); 
        close(pip1[1]);
        //close(pip2[1]); 
        close(pip2[0]);
        execvp("unbuffer -p ./b",argv);
        std::cout << "Program exits prematurely" << std::endl;
    } 
    return 0;
}