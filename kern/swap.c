#include <kern/swap.h>

#include <kern/lz4.h>

#include <inc/lib.h>

#include <kern/pmap.h>


#define Test 1

extern struct swap swap_info[SWAP_AMOUNT];

void swap_init()
{
#ifdef Test

    char src[] = "Ветер в поле закружил\n"
                    "Ветер в поле закружил\n"
                    "Ветер в поле закружил\n"
                    "Ветер в поле закружил\n"
                    "\n"
                    "     Лоботомия \n"
                    "\n"
                    "Поздний дождик напугал\n"
                    "Поздний дождик напугал\n"
                    "Поздний дождик напугал\n"
                    "Поздний дождик напугал\n"
                    "\n"
                    "     Лоботомия\n"
                    "\n"
                    "Зацвела в саду сирень\n"
                    "Зацвела в саду сирень\n"
                    "Зацвела в саду сирень\n"
                    "Зацвела в саду сирень\n"
                    "\n"
                    "     Лоботомия\n"
                    "\n";;

    src[0] = src[0];

    /*char dst[LZ4_compressBound(321)];
    cprintf("%d\n", LZ4_compressBound(4096));
    int cur_size = LZ4_compress_default(src, dst, 321, LZ4_compressBound(321));
    cprintf("%d\n", LZ4_compressBound(cur_size));
    cprintf("%s\n", dst);
    char final[321];
    LZ4_decompress_safe(dst, final, cur_size, 321);
    cprintf("%s\n", final);
    */
#endif

}

void swap_shift(int k)
{
    char *tmp = swap_info[k].buffer;
    cprintf("%ld\n", (uintptr_t)tmp);
    cprintf("%ld\n", (uintptr_t) tmp);
    for (int i = k; i < SWAP_AMOUNT - 1; i++) {
        memmove(tmp, swap_info[i + 1].buffer, swap_info[i + 1].size);
        tmp += swap_info[i + 1].size;
        swap_info[i + 1].buffer = tmp; //?
        swap_info[i].size = swap_info[i + 1].size;
        cprintf("%ld\n", (uintptr_t) tmp);
    }

}


void add_to_lru_list(struct Page *pg) {
    if (pg == NULL) {
        panic("add_to_lru_list: page is NULL");
    }

    cprintf("Adding page %p to LRU list. Head: %p, Tail: %p, Size: %d\n",
            pg, lru_list->head, lru_list->tail, lru_list->size);

    if (lru_list->size == 0) {
        lru_list->head = pg;
        lru_list->tail = pg;
        pg->lru_next = NULL;
        pg->lru_prev = NULL;
    } else {
        pg->lru_next = lru_list->head;
        if (lru_list->head) lru_list->head->lru_prev = pg;
        lru_list->head = pg;
        pg->lru_prev = NULL;
    }

    lru_list->size++;
}
void delete_from_lru_list(struct Page *pg)
{
    if (!pg->lru_prev && !pg->lru_next) {
        return;
    }
    cprintf("!!\n");
    if (pg == NULL) {
        
        panic("delete_from_lru_list: page is NULL");
    }
    cprintf("!!1\n");
    cprintf("Deleting page %p from LRU list. Head: %p, Tail: %p, Size: %d\n",
            pg, lru_list->head, lru_list->tail, lru_list->size);

    if (lru_list->size == 1) {
        lru_list->head = NULL;
        lru_list->tail = NULL;
    } 
    else if (pg == lru_list->head) {
        lru_list->head = pg->lru_next;
        lru_list->head->lru_prev = NULL;
    }
    else if (pg == lru_list->tail) {
        lru_list->tail = pg->lru_prev;
        lru_list->tail->lru_next = NULL;
    } else {
        if (pg->lru_prev) pg->lru_prev->lru_next = pg->lru_next;
        if (pg->lru_next) pg->lru_next->lru_prev = pg->lru_prev;
     }

    pg->lru_next = pg->lru_prev = NULL;
    lru_list->size--;

    cprintf("Page %p deleted. New Head: %p, Tail: %p, Size: %d\n",
            pg, lru_list->head, lru_list->tail, lru_list->size);
}