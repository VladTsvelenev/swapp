#include <inc/vsyscall.h>
#include <inc/lib.h>

static inline uint64_t
vsyscall(int num) {
    // LAB 12: Your code here
    return vsys[num];
}

int
vsys_gettime(void) {
    return vsyscall(VSYS_gettime);
}
