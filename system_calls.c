#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    int pid = fork();

    printf("THIS LINE EXECUTED TWICE\n");

    if (pid == -1) {
        printf("CHILD PROCESS NOT CREATED\n");
        exit(0);
    }

    if (pid == 0) {
        // Child process
        printf("Child Process ID: %d\n", getpid());
        printf("Parent Process ID (from child): %d\n", getppid());
        // Example of execlp usage (uncomment to use):
        // execlp("ls", "ls", NULL);
    } else if (pid > 0) {
        // Parent process
        printf("Parent Process ID: %d\n", getpid());
        printf("Parent's Parent Process ID: %d\n", getppid());
    }

    printf("End of program\n");
    return 0;
}