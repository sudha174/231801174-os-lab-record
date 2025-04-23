#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <string.h>

#define SHM_SIZE 1024  // Size of shared memory

int main() {
    key_t key = ftok("shmfile",65); // Generate unique key
    int shmid = shmget(key, SHM_SIZE, 0666|IPC_CREAT); // Locate shared memory segment

    if (shmid < 0) {
        perror("shmget");
        exit(1);
    }

    char *str = (char*) shmat(shmid, (void*)0, 0); // Attach to shared memory

    if (str == (char*)-1) {
        perror("shmat");
        exit(1);
    }

    printf("Message Received: %s\n", str); // Print message

    shmdt(str); // Detach from shared memory

    return 0;
}