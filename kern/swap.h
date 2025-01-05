#ifndef LAB_SWAP_H
#define LAB_SWAP_H


#include <inc/memlayout.h>
//#include <kern/env.h>
#include <kern/lz4.h>


//uint32_t swap_bitmap[];

extern char *SwapBuffer;

extern char *SwapShift;

extern char CompressionBuffer[COMP_SIZE];

struct lru_list1 {
    struct Page *head;
    struct Page *tail;
    int size;
};

extern struct lru_list1 *lru_list;

struct swap {
    char *buffer;
    int size;
};

extern struct swap swap_info[SWAP_AMOUNT];

void swap_init();

void swap_shift(int k);

void add_to_lru_list(struct Page *pg);
void delete_from_lru_list(struct Page *pg);


#endif //LAB_SWAP_H
