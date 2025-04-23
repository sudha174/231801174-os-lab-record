#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>
#include <signal.h>

#define SIZE 3
#define MAX_ITEMS 10

int buffer[SIZE];
int in = 0, out = 0, count = 0;
sem_t empty, full, mutex;
volatile int running = 1;

void cleanup() {
    running = 0;
    sem_destroy(&empty);
    sem_destroy(&full);
    sem_destroy(&mutex);
    exit(0);
}

void* producer(void* arg) {
    int item = 0;
    while (running && item < MAX_ITEMS) {
        sem_wait(&empty);
        sem_wait(&mutex);

        if (count < SIZE) {
            item++;
            buffer[in] = item;
            in = (in + 1) % SIZE;
            count++;
            printf("Producer produces item %d\n", item);
        }

        sem_post(&mutex);
        sem_post(&full);
        sleep(1);
    }
    return NULL;
}

void* consumer(void* arg) {
    while (running) {
        sem_wait(&full);
        sem_wait(&mutex);

        if (count > 0) {
            int item = buffer[out];
            out = (out + 1) % SIZE;
            count--;
            printf("Consumer consumes item %d\n", item);
        }

        sem_post(&mutex);
        sem_post(&empty);
        sleep(1);
    }
    return NULL;
}

int main() {
    pthread_t prod, cons;
    int choice;

    signal(SIGINT, cleanup);

    if (sem_init(&empty, 0, SIZE) < 0 || 
        sem_init(&full, 0, 0) < 0 || 
        sem_init(&mutex, 0, 1) < 0) {
        perror("Semaphore initialization failed");
        return 1;
    }

    if (pthread_create(&prod, NULL, producer, NULL) != 0 ||
        pthread_create(&cons, NULL, consumer, NULL) != 0) {
        perror("Thread creation failed");
        cleanup();
        return 1;
    }

    while (running) {
        printf("\n1. Producer\n2. Consumer\n3. Exit\nEnter your choice: ");
        if (scanf("%d", &choice) != 1) {
            printf("Invalid input\n");
            while (getchar() != '\n');
            continue;
        }

        switch (choice) {
            case 1:
                printf("Triggering producer...\n");
                break;
            case 2:
                printf("Triggering consumer...\n");
                break;
            case 3:
                cleanup();
                break;
            default:
                printf("Invalid choice\n");
        }
        sleep(1);
    }

    pthread_join(prod, NULL);
    pthread_join(cons, NULL);

    return 0;
}