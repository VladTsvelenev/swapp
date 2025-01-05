
obj/user/faultevilhandler:     file format elf64-x86-64


Disassembly of section .text:

0000000000800000 <__text_start>:
.globl _start
_start:
    # See if we were started with arguments on the stack

#ifndef CONFIG_KSPACE
    movabs $USER_STACK_TOP, %rax
  800000:	48 b8 00 70 ff ff 7f 	movabs $0x7fffff7000,%rax
  800007:	00 00 00 
    cmpq %rax, %rsp
  80000a:	48 39 c4             	cmp    %rax,%rsp
    jne args_exist
  80000d:	75 04                	jne    800013 <args_exist>

    # If not, push dummy argc/argv arguments.
    # This happens when we are loaded by the kernel,
    # because the kernel does not know about passing arguments.
    # Marking argc and argv as zero.
    pushq $0
  80000f:	6a 00                	push   $0x0
    pushq $0
  800011:	6a 00                	push   $0x0

0000000000800013 <args_exist>:

args_exist:
    movq 8(%rsp), %rsi
  800013:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
    movq (%rsp), %rdi
  800018:	48 8b 3c 24          	mov    (%rsp),%rdi
    xorl %ebp, %ebp
  80001c:	31 ed                	xor    %ebp,%ebp
    call libmain
  80001e:	e8 52 00 00 00       	call   800075 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* Test evil pointer for user-level fault handler */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
#ifndef __clang_analyzer__
    sys_alloc_region(0, (void *)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  80002d:	b9 06 00 00 00       	mov    $0x6,%ecx
  800032:	ba 00 10 00 00       	mov    $0x1000,%edx
  800037:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  80003e:	00 00 00 
  800041:	bf 00 00 00 00       	mov    $0x0,%edi
  800046:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  80004d:	00 00 00 
  800050:	ff d0                	call   *%rax
    sys_env_set_pgfault_upcall(0, (void *)0xF0100020);
  800052:	be 20 00 10 f0       	mov    $0xf0100020,%esi
  800057:	bf 00 00 00 00       	mov    $0x0,%edi
  80005c:	48 b8 78 05 80 00 00 	movabs $0x800578,%rax
  800063:	00 00 00 
  800066:	ff d0                	call   *%rax
    *(volatile int *)0 = 0;
  800068:	c7 04 25 00 00 00 00 	movl   $0x0,0x0
  80006f:	00 00 00 00 
#endif
}
  800073:	5d                   	pop    %rbp
  800074:	c3                   	ret

0000000000800075 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800075:	f3 0f 1e fa          	endbr64
  800079:	55                   	push   %rbp
  80007a:	48 89 e5             	mov    %rsp,%rbp
  80007d:	41 56                	push   %r14
  80007f:	41 55                	push   %r13
  800081:	41 54                	push   %r12
  800083:	53                   	push   %rbx
  800084:	41 89 fd             	mov    %edi,%r13d
  800087:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80008a:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800091:	00 00 00 
  800094:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80009b:	00 00 00 
  80009e:	48 39 c2             	cmp    %rax,%rdx
  8000a1:	73 17                	jae    8000ba <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8000a3:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8000a6:	49 89 c4             	mov    %rax,%r12
  8000a9:	48 83 c3 08          	add    $0x8,%rbx
  8000ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b2:	ff 53 f8             	call   *-0x8(%rbx)
  8000b5:	4c 39 e3             	cmp    %r12,%rbx
  8000b8:	72 ef                	jb     8000a9 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8000ba:	48 b8 23 02 80 00 00 	movabs $0x800223,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	call   *%rax
  8000c6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000cb:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000cf:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000d3:	48 c1 e0 04          	shl    $0x4,%rax
  8000d7:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000de:	00 00 00 
  8000e1:	48 01 d0             	add    %rdx,%rax
  8000e4:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000eb:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000ee:	45 85 ed             	test   %r13d,%r13d
  8000f1:	7e 0d                	jle    800100 <libmain+0x8b>
  8000f3:	49 8b 06             	mov    (%r14),%rax
  8000f6:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000fd:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800100:	4c 89 f6             	mov    %r14,%rsi
  800103:	44 89 ef             	mov    %r13d,%edi
  800106:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80010d:	00 00 00 
  800110:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800112:	48 b8 27 01 80 00 00 	movabs $0x800127,%rax
  800119:	00 00 00 
  80011c:	ff d0                	call   *%rax
#endif
}
  80011e:	5b                   	pop    %rbx
  80011f:	41 5c                	pop    %r12
  800121:	41 5d                	pop    %r13
  800123:	41 5e                	pop    %r14
  800125:	5d                   	pop    %rbp
  800126:	c3                   	ret

0000000000800127 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800127:	f3 0f 1e fa          	endbr64
  80012b:	55                   	push   %rbp
  80012c:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80012f:	48 b8 f9 08 80 00 00 	movabs $0x8008f9,%rax
  800136:	00 00 00 
  800139:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80013b:	bf 00 00 00 00       	mov    $0x0,%edi
  800140:	48 b8 b4 01 80 00 00 	movabs $0x8001b4,%rax
  800147:	00 00 00 
  80014a:	ff d0                	call   *%rax
}
  80014c:	5d                   	pop    %rbp
  80014d:	c3                   	ret

000000000080014e <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80014e:	f3 0f 1e fa          	endbr64
  800152:	55                   	push   %rbp
  800153:	48 89 e5             	mov    %rsp,%rbp
  800156:	53                   	push   %rbx
  800157:	48 89 fa             	mov    %rdi,%rdx
  80015a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800162:	bb 00 00 00 00       	mov    $0x0,%ebx
  800167:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800177:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800179:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80017d:	c9                   	leave
  80017e:	c3                   	ret

000000000080017f <sys_cgetc>:

int
sys_cgetc(void) {
  80017f:	f3 0f 1e fa          	endbr64
  800183:	55                   	push   %rbp
  800184:	48 89 e5             	mov    %rsp,%rbp
  800187:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800188:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80018d:	ba 00 00 00 00       	mov    $0x0,%edx
  800192:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800197:	bb 00 00 00 00       	mov    $0x0,%ebx
  80019c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001a1:	be 00 00 00 00       	mov    $0x0,%esi
  8001a6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001ac:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8001ae:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001b2:	c9                   	leave
  8001b3:	c3                   	ret

00000000008001b4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8001b4:	f3 0f 1e fa          	endbr64
  8001b8:	55                   	push   %rbp
  8001b9:	48 89 e5             	mov    %rsp,%rbp
  8001bc:	53                   	push   %rbx
  8001bd:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8001c1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8001c4:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001c9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001d3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001d8:	be 00 00 00 00       	mov    $0x0,%esi
  8001dd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001e3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001e5:	48 85 c0             	test   %rax,%rax
  8001e8:	7f 06                	jg     8001f0 <sys_env_destroy+0x3c>
}
  8001ea:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001ee:	c9                   	leave
  8001ef:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001f0:	49 89 c0             	mov    %rax,%r8
  8001f3:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001f8:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8001ff:	00 00 00 
  800202:	be 26 00 00 00       	mov    $0x26,%esi
  800207:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80020e:	00 00 00 
  800211:	b8 00 00 00 00       	mov    $0x0,%eax
  800216:	49 b9 1e 1c 80 00 00 	movabs $0x801c1e,%r9
  80021d:	00 00 00 
  800220:	41 ff d1             	call   *%r9

0000000000800223 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800223:	f3 0f 1e fa          	endbr64
  800227:	55                   	push   %rbp
  800228:	48 89 e5             	mov    %rsp,%rbp
  80022b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80022c:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800231:	ba 00 00 00 00       	mov    $0x0,%edx
  800236:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80023b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800240:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800245:	be 00 00 00 00       	mov    $0x0,%esi
  80024a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800250:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800252:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800256:	c9                   	leave
  800257:	c3                   	ret

0000000000800258 <sys_yield>:

void
sys_yield(void) {
  800258:	f3 0f 1e fa          	endbr64
  80025c:	55                   	push   %rbp
  80025d:	48 89 e5             	mov    %rsp,%rbp
  800260:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800261:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800266:	ba 00 00 00 00       	mov    $0x0,%edx
  80026b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800270:	bb 00 00 00 00       	mov    $0x0,%ebx
  800275:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80027a:	be 00 00 00 00       	mov    $0x0,%esi
  80027f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800285:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  800287:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80028b:	c9                   	leave
  80028c:	c3                   	ret

000000000080028d <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80028d:	f3 0f 1e fa          	endbr64
  800291:	55                   	push   %rbp
  800292:	48 89 e5             	mov    %rsp,%rbp
  800295:	53                   	push   %rbx
  800296:	48 89 fa             	mov    %rdi,%rdx
  800299:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80029c:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8002a1:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8002a8:	00 00 00 
  8002ab:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002b0:	be 00 00 00 00       	mov    $0x0,%esi
  8002b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002bb:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8002bd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002c1:	c9                   	leave
  8002c2:	c3                   	ret

00000000008002c3 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8002c3:	f3 0f 1e fa          	endbr64
  8002c7:	55                   	push   %rbp
  8002c8:	48 89 e5             	mov    %rsp,%rbp
  8002cb:	53                   	push   %rbx
  8002cc:	49 89 f8             	mov    %rdi,%r8
  8002cf:	48 89 d3             	mov    %rdx,%rbx
  8002d2:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8002d5:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002da:	4c 89 c2             	mov    %r8,%rdx
  8002dd:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002e0:	be 00 00 00 00       	mov    $0x0,%esi
  8002e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002eb:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002ed:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002f1:	c9                   	leave
  8002f2:	c3                   	ret

00000000008002f3 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002f3:	f3 0f 1e fa          	endbr64
  8002f7:	55                   	push   %rbp
  8002f8:	48 89 e5             	mov    %rsp,%rbp
  8002fb:	53                   	push   %rbx
  8002fc:	48 83 ec 08          	sub    $0x8,%rsp
  800300:	89 f8                	mov    %edi,%eax
  800302:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  800305:	48 63 f9             	movslq %ecx,%rdi
  800308:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80030b:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800310:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800313:	be 00 00 00 00       	mov    $0x0,%esi
  800318:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80031e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800320:	48 85 c0             	test   %rax,%rax
  800323:	7f 06                	jg     80032b <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  800325:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800329:	c9                   	leave
  80032a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80032b:	49 89 c0             	mov    %rax,%r8
  80032e:	b9 04 00 00 00       	mov    $0x4,%ecx
  800333:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80033a:	00 00 00 
  80033d:	be 26 00 00 00       	mov    $0x26,%esi
  800342:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800349:	00 00 00 
  80034c:	b8 00 00 00 00       	mov    $0x0,%eax
  800351:	49 b9 1e 1c 80 00 00 	movabs $0x801c1e,%r9
  800358:	00 00 00 
  80035b:	41 ff d1             	call   *%r9

000000000080035e <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80035e:	f3 0f 1e fa          	endbr64
  800362:	55                   	push   %rbp
  800363:	48 89 e5             	mov    %rsp,%rbp
  800366:	53                   	push   %rbx
  800367:	48 83 ec 08          	sub    $0x8,%rsp
  80036b:	89 f8                	mov    %edi,%eax
  80036d:	49 89 f2             	mov    %rsi,%r10
  800370:	48 89 cf             	mov    %rcx,%rdi
  800373:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  800376:	48 63 da             	movslq %edx,%rbx
  800379:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80037c:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800381:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800384:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  800387:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800389:	48 85 c0             	test   %rax,%rax
  80038c:	7f 06                	jg     800394 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80038e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800392:	c9                   	leave
  800393:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800394:	49 89 c0             	mov    %rax,%r8
  800397:	b9 05 00 00 00       	mov    $0x5,%ecx
  80039c:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8003a3:	00 00 00 
  8003a6:	be 26 00 00 00       	mov    $0x26,%esi
  8003ab:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8003b2:	00 00 00 
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ba:	49 b9 1e 1c 80 00 00 	movabs $0x801c1e,%r9
  8003c1:	00 00 00 
  8003c4:	41 ff d1             	call   *%r9

00000000008003c7 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8003c7:	f3 0f 1e fa          	endbr64
  8003cb:	55                   	push   %rbp
  8003cc:	48 89 e5             	mov    %rsp,%rbp
  8003cf:	53                   	push   %rbx
  8003d0:	48 83 ec 08          	sub    $0x8,%rsp
  8003d4:	49 89 f9             	mov    %rdi,%r9
  8003d7:	89 f0                	mov    %esi,%eax
  8003d9:	48 89 d3             	mov    %rdx,%rbx
  8003dc:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8003df:	49 63 f0             	movslq %r8d,%rsi
  8003e2:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8003e5:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8003ea:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003f3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003f5:	48 85 c0             	test   %rax,%rax
  8003f8:	7f 06                	jg     800400 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8003fa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003fe:	c9                   	leave
  8003ff:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800400:	49 89 c0             	mov    %rax,%r8
  800403:	b9 06 00 00 00       	mov    $0x6,%ecx
  800408:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80040f:	00 00 00 
  800412:	be 26 00 00 00       	mov    $0x26,%esi
  800417:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80041e:	00 00 00 
  800421:	b8 00 00 00 00       	mov    $0x0,%eax
  800426:	49 b9 1e 1c 80 00 00 	movabs $0x801c1e,%r9
  80042d:	00 00 00 
  800430:	41 ff d1             	call   *%r9

0000000000800433 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  800433:	f3 0f 1e fa          	endbr64
  800437:	55                   	push   %rbp
  800438:	48 89 e5             	mov    %rsp,%rbp
  80043b:	53                   	push   %rbx
  80043c:	48 83 ec 08          	sub    $0x8,%rsp
  800440:	48 89 f1             	mov    %rsi,%rcx
  800443:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  800446:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800449:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80044e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800453:	be 00 00 00 00       	mov    $0x0,%esi
  800458:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80045e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800460:	48 85 c0             	test   %rax,%rax
  800463:	7f 06                	jg     80046b <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  800465:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800469:	c9                   	leave
  80046a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80046b:	49 89 c0             	mov    %rax,%r8
  80046e:	b9 07 00 00 00       	mov    $0x7,%ecx
  800473:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80047a:	00 00 00 
  80047d:	be 26 00 00 00       	mov    $0x26,%esi
  800482:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800489:	00 00 00 
  80048c:	b8 00 00 00 00       	mov    $0x0,%eax
  800491:	49 b9 1e 1c 80 00 00 	movabs $0x801c1e,%r9
  800498:	00 00 00 
  80049b:	41 ff d1             	call   *%r9

000000000080049e <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80049e:	f3 0f 1e fa          	endbr64
  8004a2:	55                   	push   %rbp
  8004a3:	48 89 e5             	mov    %rsp,%rbp
  8004a6:	53                   	push   %rbx
  8004a7:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8004ab:	48 63 ce             	movslq %esi,%rcx
  8004ae:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004b1:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004bb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004c0:	be 00 00 00 00       	mov    $0x0,%esi
  8004c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004cb:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004cd:	48 85 c0             	test   %rax,%rax
  8004d0:	7f 06                	jg     8004d8 <sys_env_set_status+0x3a>
}
  8004d2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004d6:	c9                   	leave
  8004d7:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004d8:	49 89 c0             	mov    %rax,%r8
  8004db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8004e0:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8004e7:	00 00 00 
  8004ea:	be 26 00 00 00       	mov    $0x26,%esi
  8004ef:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8004f6:	00 00 00 
  8004f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fe:	49 b9 1e 1c 80 00 00 	movabs $0x801c1e,%r9
  800505:	00 00 00 
  800508:	41 ff d1             	call   *%r9

000000000080050b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80050b:	f3 0f 1e fa          	endbr64
  80050f:	55                   	push   %rbp
  800510:	48 89 e5             	mov    %rsp,%rbp
  800513:	53                   	push   %rbx
  800514:	48 83 ec 08          	sub    $0x8,%rsp
  800518:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80051b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80051e:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800523:	bb 00 00 00 00       	mov    $0x0,%ebx
  800528:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80052d:	be 00 00 00 00       	mov    $0x0,%esi
  800532:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800538:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80053a:	48 85 c0             	test   %rax,%rax
  80053d:	7f 06                	jg     800545 <sys_env_set_trapframe+0x3a>
}
  80053f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800543:	c9                   	leave
  800544:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800545:	49 89 c0             	mov    %rax,%r8
  800548:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80054d:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800554:	00 00 00 
  800557:	be 26 00 00 00       	mov    $0x26,%esi
  80055c:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800563:	00 00 00 
  800566:	b8 00 00 00 00       	mov    $0x0,%eax
  80056b:	49 b9 1e 1c 80 00 00 	movabs $0x801c1e,%r9
  800572:	00 00 00 
  800575:	41 ff d1             	call   *%r9

0000000000800578 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  800578:	f3 0f 1e fa          	endbr64
  80057c:	55                   	push   %rbp
  80057d:	48 89 e5             	mov    %rsp,%rbp
  800580:	53                   	push   %rbx
  800581:	48 83 ec 08          	sub    $0x8,%rsp
  800585:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  800588:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80058b:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800590:	bb 00 00 00 00       	mov    $0x0,%ebx
  800595:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80059a:	be 00 00 00 00       	mov    $0x0,%esi
  80059f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005a5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8005a7:	48 85 c0             	test   %rax,%rax
  8005aa:	7f 06                	jg     8005b2 <sys_env_set_pgfault_upcall+0x3a>
}
  8005ac:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005b0:	c9                   	leave
  8005b1:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8005b2:	49 89 c0             	mov    %rax,%r8
  8005b5:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8005ba:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8005c1:	00 00 00 
  8005c4:	be 26 00 00 00       	mov    $0x26,%esi
  8005c9:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8005d0:	00 00 00 
  8005d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d8:	49 b9 1e 1c 80 00 00 	movabs $0x801c1e,%r9
  8005df:	00 00 00 
  8005e2:	41 ff d1             	call   *%r9

00000000008005e5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8005e5:	f3 0f 1e fa          	endbr64
  8005e9:	55                   	push   %rbp
  8005ea:	48 89 e5             	mov    %rsp,%rbp
  8005ed:	53                   	push   %rbx
  8005ee:	89 f8                	mov    %edi,%eax
  8005f0:	49 89 f1             	mov    %rsi,%r9
  8005f3:	48 89 d3             	mov    %rdx,%rbx
  8005f6:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8005f9:	49 63 f0             	movslq %r8d,%rsi
  8005fc:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8005ff:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800604:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800607:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80060d:	cd 30                	int    $0x30
}
  80060f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800613:	c9                   	leave
  800614:	c3                   	ret

0000000000800615 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  800615:	f3 0f 1e fa          	endbr64
  800619:	55                   	push   %rbp
  80061a:	48 89 e5             	mov    %rsp,%rbp
  80061d:	53                   	push   %rbx
  80061e:	48 83 ec 08          	sub    $0x8,%rsp
  800622:	48 89 fa             	mov    %rdi,%rdx
  800625:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800628:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80062d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800632:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800637:	be 00 00 00 00       	mov    $0x0,%esi
  80063c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800642:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800644:	48 85 c0             	test   %rax,%rax
  800647:	7f 06                	jg     80064f <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800649:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80064d:	c9                   	leave
  80064e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80064f:	49 89 c0             	mov    %rax,%r8
  800652:	b9 0f 00 00 00       	mov    $0xf,%ecx
  800657:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80065e:	00 00 00 
  800661:	be 26 00 00 00       	mov    $0x26,%esi
  800666:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80066d:	00 00 00 
  800670:	b8 00 00 00 00       	mov    $0x0,%eax
  800675:	49 b9 1e 1c 80 00 00 	movabs $0x801c1e,%r9
  80067c:	00 00 00 
  80067f:	41 ff d1             	call   *%r9

0000000000800682 <sys_gettime>:

int
sys_gettime(void) {
  800682:	f3 0f 1e fa          	endbr64
  800686:	55                   	push   %rbp
  800687:	48 89 e5             	mov    %rsp,%rbp
  80068a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80068b:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800690:	ba 00 00 00 00       	mov    $0x0,%edx
  800695:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80069a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80069f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8006a4:	be 00 00 00 00       	mov    $0x0,%esi
  8006a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8006af:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8006b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8006b5:	c9                   	leave
  8006b6:	c3                   	ret

00000000008006b7 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  8006b7:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8006bb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8006c2:	ff ff ff 
  8006c5:	48 01 f8             	add    %rdi,%rax
  8006c8:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8006cc:	c3                   	ret

00000000008006cd <fd2data>:

char *
fd2data(struct Fd *fd) {
  8006cd:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8006d1:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8006d8:	ff ff ff 
  8006db:	48 01 f8             	add    %rdi,%rax
  8006de:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8006e2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8006e8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006ec:	c3                   	ret

00000000008006ed <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8006ed:	f3 0f 1e fa          	endbr64
  8006f1:	55                   	push   %rbp
  8006f2:	48 89 e5             	mov    %rsp,%rbp
  8006f5:	41 57                	push   %r15
  8006f7:	41 56                	push   %r14
  8006f9:	41 55                	push   %r13
  8006fb:	41 54                	push   %r12
  8006fd:	53                   	push   %rbx
  8006fe:	48 83 ec 08          	sub    $0x8,%rsp
  800702:	49 89 ff             	mov    %rdi,%r15
  800705:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80070a:	49 bd 4c 18 80 00 00 	movabs $0x80184c,%r13
  800711:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  800714:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  80071a:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  80071d:	48 89 df             	mov    %rbx,%rdi
  800720:	41 ff d5             	call   *%r13
  800723:	83 e0 04             	and    $0x4,%eax
  800726:	74 17                	je     80073f <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  800728:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80072f:	4c 39 f3             	cmp    %r14,%rbx
  800732:	75 e6                	jne    80071a <fd_alloc+0x2d>
  800734:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  80073a:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  80073f:	4d 89 27             	mov    %r12,(%r15)
}
  800742:	48 83 c4 08          	add    $0x8,%rsp
  800746:	5b                   	pop    %rbx
  800747:	41 5c                	pop    %r12
  800749:	41 5d                	pop    %r13
  80074b:	41 5e                	pop    %r14
  80074d:	41 5f                	pop    %r15
  80074f:	5d                   	pop    %rbp
  800750:	c3                   	ret

0000000000800751 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  800751:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  800755:	83 ff 1f             	cmp    $0x1f,%edi
  800758:	77 39                	ja     800793 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80075a:	55                   	push   %rbp
  80075b:	48 89 e5             	mov    %rsp,%rbp
  80075e:	41 54                	push   %r12
  800760:	53                   	push   %rbx
  800761:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  800764:	48 63 df             	movslq %edi,%rbx
  800767:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80076e:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800772:	48 89 df             	mov    %rbx,%rdi
  800775:	48 b8 4c 18 80 00 00 	movabs $0x80184c,%rax
  80077c:	00 00 00 
  80077f:	ff d0                	call   *%rax
  800781:	a8 04                	test   $0x4,%al
  800783:	74 14                	je     800799 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  800785:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  800789:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80078e:	5b                   	pop    %rbx
  80078f:	41 5c                	pop    %r12
  800791:	5d                   	pop    %rbp
  800792:	c3                   	ret
        return -E_INVAL;
  800793:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800798:	c3                   	ret
        return -E_INVAL;
  800799:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079e:	eb ee                	jmp    80078e <fd_lookup+0x3d>

00000000008007a0 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8007a0:	f3 0f 1e fa          	endbr64
  8007a4:	55                   	push   %rbp
  8007a5:	48 89 e5             	mov    %rsp,%rbp
  8007a8:	41 54                	push   %r12
  8007aa:	53                   	push   %rbx
  8007ab:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  8007ae:	48 b8 40 33 80 00 00 	movabs $0x803340,%rax
  8007b5:	00 00 00 
  8007b8:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  8007bf:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8007c2:	39 3b                	cmp    %edi,(%rbx)
  8007c4:	74 47                	je     80080d <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  8007c6:	48 83 c0 08          	add    $0x8,%rax
  8007ca:	48 8b 18             	mov    (%rax),%rbx
  8007cd:	48 85 db             	test   %rbx,%rbx
  8007d0:	75 f0                	jne    8007c2 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8007d2:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8007d9:	00 00 00 
  8007dc:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8007e2:	89 fa                	mov    %edi,%edx
  8007e4:	48 bf 78 32 80 00 00 	movabs $0x803278,%rdi
  8007eb:	00 00 00 
  8007ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f3:	48 b9 7a 1d 80 00 00 	movabs $0x801d7a,%rcx
  8007fa:	00 00 00 
  8007fd:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8007ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  800804:	49 89 1c 24          	mov    %rbx,(%r12)
}
  800808:	5b                   	pop    %rbx
  800809:	41 5c                	pop    %r12
  80080b:	5d                   	pop    %rbp
  80080c:	c3                   	ret
            return 0;
  80080d:	b8 00 00 00 00       	mov    $0x0,%eax
  800812:	eb f0                	jmp    800804 <dev_lookup+0x64>

0000000000800814 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  800814:	f3 0f 1e fa          	endbr64
  800818:	55                   	push   %rbp
  800819:	48 89 e5             	mov    %rsp,%rbp
  80081c:	41 55                	push   %r13
  80081e:	41 54                	push   %r12
  800820:	53                   	push   %rbx
  800821:	48 83 ec 18          	sub    $0x18,%rsp
  800825:	48 89 fb             	mov    %rdi,%rbx
  800828:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80082b:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  800832:	ff ff ff 
  800835:	48 01 df             	add    %rbx,%rdi
  800838:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80083c:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800840:	48 b8 51 07 80 00 00 	movabs $0x800751,%rax
  800847:	00 00 00 
  80084a:	ff d0                	call   *%rax
  80084c:	41 89 c5             	mov    %eax,%r13d
  80084f:	85 c0                	test   %eax,%eax
  800851:	78 06                	js     800859 <fd_close+0x45>
  800853:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  800857:	74 1a                	je     800873 <fd_close+0x5f>
        return (must_exist ? res : 0);
  800859:	45 84 e4             	test   %r12b,%r12b
  80085c:	b8 00 00 00 00       	mov    $0x0,%eax
  800861:	44 0f 44 e8          	cmove  %eax,%r13d
}
  800865:	44 89 e8             	mov    %r13d,%eax
  800868:	48 83 c4 18          	add    $0x18,%rsp
  80086c:	5b                   	pop    %rbx
  80086d:	41 5c                	pop    %r12
  80086f:	41 5d                	pop    %r13
  800871:	5d                   	pop    %rbp
  800872:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800873:	8b 3b                	mov    (%rbx),%edi
  800875:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800879:	48 b8 a0 07 80 00 00 	movabs $0x8007a0,%rax
  800880:	00 00 00 
  800883:	ff d0                	call   *%rax
  800885:	41 89 c5             	mov    %eax,%r13d
  800888:	85 c0                	test   %eax,%eax
  80088a:	78 1b                	js     8008a7 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80088c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800890:	48 8b 40 20          	mov    0x20(%rax),%rax
  800894:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80089a:	48 85 c0             	test   %rax,%rax
  80089d:	74 08                	je     8008a7 <fd_close+0x93>
  80089f:	48 89 df             	mov    %rbx,%rdi
  8008a2:	ff d0                	call   *%rax
  8008a4:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8008a7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8008ac:	48 89 de             	mov    %rbx,%rsi
  8008af:	bf 00 00 00 00       	mov    $0x0,%edi
  8008b4:	48 b8 33 04 80 00 00 	movabs $0x800433,%rax
  8008bb:	00 00 00 
  8008be:	ff d0                	call   *%rax
    return res;
  8008c0:	eb a3                	jmp    800865 <fd_close+0x51>

00000000008008c2 <close>:

int
close(int fdnum) {
  8008c2:	f3 0f 1e fa          	endbr64
  8008c6:	55                   	push   %rbp
  8008c7:	48 89 e5             	mov    %rsp,%rbp
  8008ca:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8008ce:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8008d2:	48 b8 51 07 80 00 00 	movabs $0x800751,%rax
  8008d9:	00 00 00 
  8008dc:	ff d0                	call   *%rax
    if (res < 0) return res;
  8008de:	85 c0                	test   %eax,%eax
  8008e0:	78 15                	js     8008f7 <close+0x35>

    return fd_close(fd, 1);
  8008e2:	be 01 00 00 00       	mov    $0x1,%esi
  8008e7:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8008eb:	48 b8 14 08 80 00 00 	movabs $0x800814,%rax
  8008f2:	00 00 00 
  8008f5:	ff d0                	call   *%rax
}
  8008f7:	c9                   	leave
  8008f8:	c3                   	ret

00000000008008f9 <close_all>:

void
close_all(void) {
  8008f9:	f3 0f 1e fa          	endbr64
  8008fd:	55                   	push   %rbp
  8008fe:	48 89 e5             	mov    %rsp,%rbp
  800901:	41 54                	push   %r12
  800903:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  800904:	bb 00 00 00 00       	mov    $0x0,%ebx
  800909:	49 bc c2 08 80 00 00 	movabs $0x8008c2,%r12
  800910:	00 00 00 
  800913:	89 df                	mov    %ebx,%edi
  800915:	41 ff d4             	call   *%r12
  800918:	83 c3 01             	add    $0x1,%ebx
  80091b:	83 fb 20             	cmp    $0x20,%ebx
  80091e:	75 f3                	jne    800913 <close_all+0x1a>
}
  800920:	5b                   	pop    %rbx
  800921:	41 5c                	pop    %r12
  800923:	5d                   	pop    %rbp
  800924:	c3                   	ret

0000000000800925 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  800925:	f3 0f 1e fa          	endbr64
  800929:	55                   	push   %rbp
  80092a:	48 89 e5             	mov    %rsp,%rbp
  80092d:	41 57                	push   %r15
  80092f:	41 56                	push   %r14
  800931:	41 55                	push   %r13
  800933:	41 54                	push   %r12
  800935:	53                   	push   %rbx
  800936:	48 83 ec 18          	sub    $0x18,%rsp
  80093a:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80093d:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  800941:	48 b8 51 07 80 00 00 	movabs $0x800751,%rax
  800948:	00 00 00 
  80094b:	ff d0                	call   *%rax
  80094d:	89 c3                	mov    %eax,%ebx
  80094f:	85 c0                	test   %eax,%eax
  800951:	0f 88 b8 00 00 00    	js     800a0f <dup+0xea>
    close(newfdnum);
  800957:	44 89 e7             	mov    %r12d,%edi
  80095a:	48 b8 c2 08 80 00 00 	movabs $0x8008c2,%rax
  800961:	00 00 00 
  800964:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  800966:	4d 63 ec             	movslq %r12d,%r13
  800969:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  800970:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  800974:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  800978:	4c 89 ff             	mov    %r15,%rdi
  80097b:	49 be cd 06 80 00 00 	movabs $0x8006cd,%r14
  800982:	00 00 00 
  800985:	41 ff d6             	call   *%r14
  800988:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  80098b:	4c 89 ef             	mov    %r13,%rdi
  80098e:	41 ff d6             	call   *%r14
  800991:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  800994:	48 89 df             	mov    %rbx,%rdi
  800997:	48 b8 4c 18 80 00 00 	movabs $0x80184c,%rax
  80099e:	00 00 00 
  8009a1:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8009a3:	a8 04                	test   $0x4,%al
  8009a5:	74 2b                	je     8009d2 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8009a7:	41 89 c1             	mov    %eax,%r9d
  8009aa:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8009b0:	4c 89 f1             	mov    %r14,%rcx
  8009b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b8:	48 89 de             	mov    %rbx,%rsi
  8009bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8009c0:	48 b8 5e 03 80 00 00 	movabs $0x80035e,%rax
  8009c7:	00 00 00 
  8009ca:	ff d0                	call   *%rax
  8009cc:	89 c3                	mov    %eax,%ebx
  8009ce:	85 c0                	test   %eax,%eax
  8009d0:	78 4e                	js     800a20 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  8009d2:	4c 89 ff             	mov    %r15,%rdi
  8009d5:	48 b8 4c 18 80 00 00 	movabs $0x80184c,%rax
  8009dc:	00 00 00 
  8009df:	ff d0                	call   *%rax
  8009e1:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8009e4:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8009ea:	4c 89 e9             	mov    %r13,%rcx
  8009ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f2:	4c 89 fe             	mov    %r15,%rsi
  8009f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8009fa:	48 b8 5e 03 80 00 00 	movabs $0x80035e,%rax
  800a01:	00 00 00 
  800a04:	ff d0                	call   *%rax
  800a06:	89 c3                	mov    %eax,%ebx
  800a08:	85 c0                	test   %eax,%eax
  800a0a:	78 14                	js     800a20 <dup+0xfb>

    return newfdnum;
  800a0c:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  800a0f:	89 d8                	mov    %ebx,%eax
  800a11:	48 83 c4 18          	add    $0x18,%rsp
  800a15:	5b                   	pop    %rbx
  800a16:	41 5c                	pop    %r12
  800a18:	41 5d                	pop    %r13
  800a1a:	41 5e                	pop    %r14
  800a1c:	41 5f                	pop    %r15
  800a1e:	5d                   	pop    %rbp
  800a1f:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  800a20:	ba 00 10 00 00       	mov    $0x1000,%edx
  800a25:	4c 89 ee             	mov    %r13,%rsi
  800a28:	bf 00 00 00 00       	mov    $0x0,%edi
  800a2d:	49 bc 33 04 80 00 00 	movabs $0x800433,%r12
  800a34:	00 00 00 
  800a37:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  800a3a:	ba 00 10 00 00       	mov    $0x1000,%edx
  800a3f:	4c 89 f6             	mov    %r14,%rsi
  800a42:	bf 00 00 00 00       	mov    $0x0,%edi
  800a47:	41 ff d4             	call   *%r12
    return res;
  800a4a:	eb c3                	jmp    800a0f <dup+0xea>

0000000000800a4c <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800a4c:	f3 0f 1e fa          	endbr64
  800a50:	55                   	push   %rbp
  800a51:	48 89 e5             	mov    %rsp,%rbp
  800a54:	41 56                	push   %r14
  800a56:	41 55                	push   %r13
  800a58:	41 54                	push   %r12
  800a5a:	53                   	push   %rbx
  800a5b:	48 83 ec 10          	sub    $0x10,%rsp
  800a5f:	89 fb                	mov    %edi,%ebx
  800a61:	49 89 f4             	mov    %rsi,%r12
  800a64:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a67:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800a6b:	48 b8 51 07 80 00 00 	movabs $0x800751,%rax
  800a72:	00 00 00 
  800a75:	ff d0                	call   *%rax
  800a77:	85 c0                	test   %eax,%eax
  800a79:	78 4c                	js     800ac7 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a7b:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800a7f:	41 8b 3e             	mov    (%r14),%edi
  800a82:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800a86:	48 b8 a0 07 80 00 00 	movabs $0x8007a0,%rax
  800a8d:	00 00 00 
  800a90:	ff d0                	call   *%rax
  800a92:	85 c0                	test   %eax,%eax
  800a94:	78 35                	js     800acb <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a96:	41 8b 46 08          	mov    0x8(%r14),%eax
  800a9a:	83 e0 03             	and    $0x3,%eax
  800a9d:	83 f8 01             	cmp    $0x1,%eax
  800aa0:	74 2d                	je     800acf <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800aa2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800aa6:	48 8b 40 10          	mov    0x10(%rax),%rax
  800aaa:	48 85 c0             	test   %rax,%rax
  800aad:	74 56                	je     800b05 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  800aaf:	4c 89 ea             	mov    %r13,%rdx
  800ab2:	4c 89 e6             	mov    %r12,%rsi
  800ab5:	4c 89 f7             	mov    %r14,%rdi
  800ab8:	ff d0                	call   *%rax
}
  800aba:	48 83 c4 10          	add    $0x10,%rsp
  800abe:	5b                   	pop    %rbx
  800abf:	41 5c                	pop    %r12
  800ac1:	41 5d                	pop    %r13
  800ac3:	41 5e                	pop    %r14
  800ac5:	5d                   	pop    %rbp
  800ac6:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800ac7:	48 98                	cltq
  800ac9:	eb ef                	jmp    800aba <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800acb:	48 98                	cltq
  800acd:	eb eb                	jmp    800aba <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800acf:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800ad6:	00 00 00 
  800ad9:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800adf:	89 da                	mov    %ebx,%edx
  800ae1:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  800ae8:	00 00 00 
  800aeb:	b8 00 00 00 00       	mov    $0x0,%eax
  800af0:	48 b9 7a 1d 80 00 00 	movabs $0x801d7a,%rcx
  800af7:	00 00 00 
  800afa:	ff d1                	call   *%rcx
        return -E_INVAL;
  800afc:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800b03:	eb b5                	jmp    800aba <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800b05:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800b0c:	eb ac                	jmp    800aba <read+0x6e>

0000000000800b0e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800b0e:	f3 0f 1e fa          	endbr64
  800b12:	55                   	push   %rbp
  800b13:	48 89 e5             	mov    %rsp,%rbp
  800b16:	41 57                	push   %r15
  800b18:	41 56                	push   %r14
  800b1a:	41 55                	push   %r13
  800b1c:	41 54                	push   %r12
  800b1e:	53                   	push   %rbx
  800b1f:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800b23:	48 85 d2             	test   %rdx,%rdx
  800b26:	74 54                	je     800b7c <readn+0x6e>
  800b28:	41 89 fd             	mov    %edi,%r13d
  800b2b:	49 89 f6             	mov    %rsi,%r14
  800b2e:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800b31:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800b36:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800b3b:	49 bf 4c 0a 80 00 00 	movabs $0x800a4c,%r15
  800b42:	00 00 00 
  800b45:	4c 89 e2             	mov    %r12,%rdx
  800b48:	48 29 f2             	sub    %rsi,%rdx
  800b4b:	4c 01 f6             	add    %r14,%rsi
  800b4e:	44 89 ef             	mov    %r13d,%edi
  800b51:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800b54:	85 c0                	test   %eax,%eax
  800b56:	78 20                	js     800b78 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  800b58:	01 c3                	add    %eax,%ebx
  800b5a:	85 c0                	test   %eax,%eax
  800b5c:	74 08                	je     800b66 <readn+0x58>
  800b5e:	48 63 f3             	movslq %ebx,%rsi
  800b61:	4c 39 e6             	cmp    %r12,%rsi
  800b64:	72 df                	jb     800b45 <readn+0x37>
    }
    return res;
  800b66:	48 63 c3             	movslq %ebx,%rax
}
  800b69:	48 83 c4 08          	add    $0x8,%rsp
  800b6d:	5b                   	pop    %rbx
  800b6e:	41 5c                	pop    %r12
  800b70:	41 5d                	pop    %r13
  800b72:	41 5e                	pop    %r14
  800b74:	41 5f                	pop    %r15
  800b76:	5d                   	pop    %rbp
  800b77:	c3                   	ret
        if (inc < 0) return inc;
  800b78:	48 98                	cltq
  800b7a:	eb ed                	jmp    800b69 <readn+0x5b>
    int inc = 1, res = 0;
  800b7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b81:	eb e3                	jmp    800b66 <readn+0x58>

0000000000800b83 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800b83:	f3 0f 1e fa          	endbr64
  800b87:	55                   	push   %rbp
  800b88:	48 89 e5             	mov    %rsp,%rbp
  800b8b:	41 56                	push   %r14
  800b8d:	41 55                	push   %r13
  800b8f:	41 54                	push   %r12
  800b91:	53                   	push   %rbx
  800b92:	48 83 ec 10          	sub    $0x10,%rsp
  800b96:	89 fb                	mov    %edi,%ebx
  800b98:	49 89 f4             	mov    %rsi,%r12
  800b9b:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b9e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800ba2:	48 b8 51 07 80 00 00 	movabs $0x800751,%rax
  800ba9:	00 00 00 
  800bac:	ff d0                	call   *%rax
  800bae:	85 c0                	test   %eax,%eax
  800bb0:	78 47                	js     800bf9 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bb2:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800bb6:	41 8b 3e             	mov    (%r14),%edi
  800bb9:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800bbd:	48 b8 a0 07 80 00 00 	movabs $0x8007a0,%rax
  800bc4:	00 00 00 
  800bc7:	ff d0                	call   *%rax
  800bc9:	85 c0                	test   %eax,%eax
  800bcb:	78 30                	js     800bfd <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bcd:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  800bd2:	74 2d                	je     800c01 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800bd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800bd8:	48 8b 40 18          	mov    0x18(%rax),%rax
  800bdc:	48 85 c0             	test   %rax,%rax
  800bdf:	74 56                	je     800c37 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  800be1:	4c 89 ea             	mov    %r13,%rdx
  800be4:	4c 89 e6             	mov    %r12,%rsi
  800be7:	4c 89 f7             	mov    %r14,%rdi
  800bea:	ff d0                	call   *%rax
}
  800bec:	48 83 c4 10          	add    $0x10,%rsp
  800bf0:	5b                   	pop    %rbx
  800bf1:	41 5c                	pop    %r12
  800bf3:	41 5d                	pop    %r13
  800bf5:	41 5e                	pop    %r14
  800bf7:	5d                   	pop    %rbp
  800bf8:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800bf9:	48 98                	cltq
  800bfb:	eb ef                	jmp    800bec <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bfd:	48 98                	cltq
  800bff:	eb eb                	jmp    800bec <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c01:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800c08:	00 00 00 
  800c0b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800c11:	89 da                	mov    %ebx,%edx
  800c13:	48 bf 34 30 80 00 00 	movabs $0x803034,%rdi
  800c1a:	00 00 00 
  800c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c22:	48 b9 7a 1d 80 00 00 	movabs $0x801d7a,%rcx
  800c29:	00 00 00 
  800c2c:	ff d1                	call   *%rcx
        return -E_INVAL;
  800c2e:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800c35:	eb b5                	jmp    800bec <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800c37:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800c3e:	eb ac                	jmp    800bec <write+0x69>

0000000000800c40 <seek>:

int
seek(int fdnum, off_t offset) {
  800c40:	f3 0f 1e fa          	endbr64
  800c44:	55                   	push   %rbp
  800c45:	48 89 e5             	mov    %rsp,%rbp
  800c48:	53                   	push   %rbx
  800c49:	48 83 ec 18          	sub    $0x18,%rsp
  800c4d:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c4f:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c53:	48 b8 51 07 80 00 00 	movabs $0x800751,%rax
  800c5a:	00 00 00 
  800c5d:	ff d0                	call   *%rax
  800c5f:	85 c0                	test   %eax,%eax
  800c61:	78 0c                	js     800c6f <seek+0x2f>

    fd->fd_offset = offset;
  800c63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c67:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800c6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c6f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c73:	c9                   	leave
  800c74:	c3                   	ret

0000000000800c75 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800c75:	f3 0f 1e fa          	endbr64
  800c79:	55                   	push   %rbp
  800c7a:	48 89 e5             	mov    %rsp,%rbp
  800c7d:	41 55                	push   %r13
  800c7f:	41 54                	push   %r12
  800c81:	53                   	push   %rbx
  800c82:	48 83 ec 18          	sub    $0x18,%rsp
  800c86:	89 fb                	mov    %edi,%ebx
  800c88:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c8b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800c8f:	48 b8 51 07 80 00 00 	movabs $0x800751,%rax
  800c96:	00 00 00 
  800c99:	ff d0                	call   *%rax
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	78 38                	js     800cd7 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c9f:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  800ca3:	41 8b 7d 00          	mov    0x0(%r13),%edi
  800ca7:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800cab:	48 b8 a0 07 80 00 00 	movabs $0x8007a0,%rax
  800cb2:	00 00 00 
  800cb5:	ff d0                	call   *%rax
  800cb7:	85 c0                	test   %eax,%eax
  800cb9:	78 1c                	js     800cd7 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800cbb:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  800cc0:	74 20                	je     800ce2 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800cc2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cc6:	48 8b 40 30          	mov    0x30(%rax),%rax
  800cca:	48 85 c0             	test   %rax,%rax
  800ccd:	74 47                	je     800d16 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  800ccf:	44 89 e6             	mov    %r12d,%esi
  800cd2:	4c 89 ef             	mov    %r13,%rdi
  800cd5:	ff d0                	call   *%rax
}
  800cd7:	48 83 c4 18          	add    $0x18,%rsp
  800cdb:	5b                   	pop    %rbx
  800cdc:	41 5c                	pop    %r12
  800cde:	41 5d                	pop    %r13
  800ce0:	5d                   	pop    %rbp
  800ce1:	c3                   	ret
                thisenv->env_id, fdnum);
  800ce2:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800ce9:	00 00 00 
  800cec:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800cf2:	89 da                	mov    %ebx,%edx
  800cf4:	48 bf 98 32 80 00 00 	movabs $0x803298,%rdi
  800cfb:	00 00 00 
  800cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  800d03:	48 b9 7a 1d 80 00 00 	movabs $0x801d7a,%rcx
  800d0a:	00 00 00 
  800d0d:	ff d1                	call   *%rcx
        return -E_INVAL;
  800d0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d14:	eb c1                	jmp    800cd7 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800d16:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800d1b:	eb ba                	jmp    800cd7 <ftruncate+0x62>

0000000000800d1d <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800d1d:	f3 0f 1e fa          	endbr64
  800d21:	55                   	push   %rbp
  800d22:	48 89 e5             	mov    %rsp,%rbp
  800d25:	41 54                	push   %r12
  800d27:	53                   	push   %rbx
  800d28:	48 83 ec 10          	sub    $0x10,%rsp
  800d2c:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800d2f:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800d33:	48 b8 51 07 80 00 00 	movabs $0x800751,%rax
  800d3a:	00 00 00 
  800d3d:	ff d0                	call   *%rax
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	78 4e                	js     800d91 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800d43:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  800d47:	41 8b 3c 24          	mov    (%r12),%edi
  800d4b:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800d4f:	48 b8 a0 07 80 00 00 	movabs $0x8007a0,%rax
  800d56:	00 00 00 
  800d59:	ff d0                	call   *%rax
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	78 32                	js     800d91 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800d63:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800d68:	74 30                	je     800d9a <fstat+0x7d>

    stat->st_name[0] = 0;
  800d6a:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800d6d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800d74:	00 00 00 
    stat->st_isdir = 0;
  800d77:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800d7e:	00 00 00 
    stat->st_dev = dev;
  800d81:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800d88:	48 89 de             	mov    %rbx,%rsi
  800d8b:	4c 89 e7             	mov    %r12,%rdi
  800d8e:	ff 50 28             	call   *0x28(%rax)
}
  800d91:	48 83 c4 10          	add    $0x10,%rsp
  800d95:	5b                   	pop    %rbx
  800d96:	41 5c                	pop    %r12
  800d98:	5d                   	pop    %rbp
  800d99:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d9a:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800d9f:	eb f0                	jmp    800d91 <fstat+0x74>

0000000000800da1 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800da1:	f3 0f 1e fa          	endbr64
  800da5:	55                   	push   %rbp
  800da6:	48 89 e5             	mov    %rsp,%rbp
  800da9:	41 54                	push   %r12
  800dab:	53                   	push   %rbx
  800dac:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800daf:	be 00 00 00 00       	mov    $0x0,%esi
  800db4:	48 b8 82 10 80 00 00 	movabs $0x801082,%rax
  800dbb:	00 00 00 
  800dbe:	ff d0                	call   *%rax
  800dc0:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800dc2:	85 c0                	test   %eax,%eax
  800dc4:	78 25                	js     800deb <stat+0x4a>

    int res = fstat(fd, stat);
  800dc6:	4c 89 e6             	mov    %r12,%rsi
  800dc9:	89 c7                	mov    %eax,%edi
  800dcb:	48 b8 1d 0d 80 00 00 	movabs $0x800d1d,%rax
  800dd2:	00 00 00 
  800dd5:	ff d0                	call   *%rax
  800dd7:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800dda:	89 df                	mov    %ebx,%edi
  800ddc:	48 b8 c2 08 80 00 00 	movabs $0x8008c2,%rax
  800de3:	00 00 00 
  800de6:	ff d0                	call   *%rax

    return res;
  800de8:	44 89 e3             	mov    %r12d,%ebx
}
  800deb:	89 d8                	mov    %ebx,%eax
  800ded:	5b                   	pop    %rbx
  800dee:	41 5c                	pop    %r12
  800df0:	5d                   	pop    %rbp
  800df1:	c3                   	ret

0000000000800df2 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800df2:	f3 0f 1e fa          	endbr64
  800df6:	55                   	push   %rbp
  800df7:	48 89 e5             	mov    %rsp,%rbp
  800dfa:	41 54                	push   %r12
  800dfc:	53                   	push   %rbx
  800dfd:	48 83 ec 10          	sub    $0x10,%rsp
  800e01:	41 89 fc             	mov    %edi,%r12d
  800e04:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800e07:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800e0e:	00 00 00 
  800e11:	83 38 00             	cmpl   $0x0,(%rax)
  800e14:	74 6e                	je     800e84 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  800e16:	bf 03 00 00 00       	mov    $0x3,%edi
  800e1b:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  800e22:	00 00 00 
  800e25:	ff d0                	call   *%rax
  800e27:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e2e:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800e30:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800e36:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800e3b:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800e42:	00 00 00 
  800e45:	44 89 e6             	mov    %r12d,%esi
  800e48:	89 c7                	mov    %eax,%edi
  800e4a:	48 b8 bc 2b 80 00 00 	movabs $0x802bbc,%rax
  800e51:	00 00 00 
  800e54:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800e56:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800e5d:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800e5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e63:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e67:	48 89 de             	mov    %rbx,%rsi
  800e6a:	bf 00 00 00 00       	mov    $0x0,%edi
  800e6f:	48 b8 23 2b 80 00 00 	movabs $0x802b23,%rax
  800e76:	00 00 00 
  800e79:	ff d0                	call   *%rax
}
  800e7b:	48 83 c4 10          	add    $0x10,%rsp
  800e7f:	5b                   	pop    %rbx
  800e80:	41 5c                	pop    %r12
  800e82:	5d                   	pop    %rbp
  800e83:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800e84:	bf 03 00 00 00       	mov    $0x3,%edi
  800e89:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  800e90:	00 00 00 
  800e93:	ff d0                	call   *%rax
  800e95:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e9c:	00 00 
  800e9e:	e9 73 ff ff ff       	jmp    800e16 <fsipc+0x24>

0000000000800ea3 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800ea3:	f3 0f 1e fa          	endbr64
  800ea7:	55                   	push   %rbp
  800ea8:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800eab:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800eb2:	00 00 00 
  800eb5:	8b 57 0c             	mov    0xc(%rdi),%edx
  800eb8:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800eba:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800ebd:	be 00 00 00 00       	mov    $0x0,%esi
  800ec2:	bf 02 00 00 00       	mov    $0x2,%edi
  800ec7:	48 b8 f2 0d 80 00 00 	movabs $0x800df2,%rax
  800ece:	00 00 00 
  800ed1:	ff d0                	call   *%rax
}
  800ed3:	5d                   	pop    %rbp
  800ed4:	c3                   	ret

0000000000800ed5 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800ed5:	f3 0f 1e fa          	endbr64
  800ed9:	55                   	push   %rbp
  800eda:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800edd:	8b 47 0c             	mov    0xc(%rdi),%eax
  800ee0:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ee7:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800ee9:	be 00 00 00 00       	mov    $0x0,%esi
  800eee:	bf 06 00 00 00       	mov    $0x6,%edi
  800ef3:	48 b8 f2 0d 80 00 00 	movabs $0x800df2,%rax
  800efa:	00 00 00 
  800efd:	ff d0                	call   *%rax
}
  800eff:	5d                   	pop    %rbp
  800f00:	c3                   	ret

0000000000800f01 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800f01:	f3 0f 1e fa          	endbr64
  800f05:	55                   	push   %rbp
  800f06:	48 89 e5             	mov    %rsp,%rbp
  800f09:	41 54                	push   %r12
  800f0b:	53                   	push   %rbx
  800f0c:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800f0f:	8b 47 0c             	mov    0xc(%rdi),%eax
  800f12:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800f19:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800f1b:	be 00 00 00 00       	mov    $0x0,%esi
  800f20:	bf 05 00 00 00       	mov    $0x5,%edi
  800f25:	48 b8 f2 0d 80 00 00 	movabs $0x800df2,%rax
  800f2c:	00 00 00 
  800f2f:	ff d0                	call   *%rax
    if (res < 0) return res;
  800f31:	85 c0                	test   %eax,%eax
  800f33:	78 3d                	js     800f72 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800f35:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  800f3c:	00 00 00 
  800f3f:	4c 89 e6             	mov    %r12,%rsi
  800f42:	48 89 df             	mov    %rbx,%rdi
  800f45:	48 b8 c3 26 80 00 00 	movabs $0x8026c3,%rax
  800f4c:	00 00 00 
  800f4f:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800f51:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  800f58:	00 
  800f59:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800f5f:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  800f66:	00 
  800f67:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f72:	5b                   	pop    %rbx
  800f73:	41 5c                	pop    %r12
  800f75:	5d                   	pop    %rbp
  800f76:	c3                   	ret

0000000000800f77 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f77:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  800f7b:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  800f82:	77 41                	ja     800fc5 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f84:	55                   	push   %rbp
  800f85:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  800f88:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f8f:	00 00 00 
  800f92:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f95:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  800f97:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  800f9b:	48 8d 78 10          	lea    0x10(%rax),%rdi
  800f9f:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  800fa6:	00 00 00 
  800fa9:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  800fab:	be 00 00 00 00       	mov    $0x0,%esi
  800fb0:	bf 04 00 00 00       	mov    $0x4,%edi
  800fb5:	48 b8 f2 0d 80 00 00 	movabs $0x800df2,%rax
  800fbc:	00 00 00 
  800fbf:	ff d0                	call   *%rax
  800fc1:	48 98                	cltq
}
  800fc3:	5d                   	pop    %rbp
  800fc4:	c3                   	ret
        return -E_INVAL;
  800fc5:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  800fcc:	c3                   	ret

0000000000800fcd <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800fcd:	f3 0f 1e fa          	endbr64
  800fd1:	55                   	push   %rbp
  800fd2:	48 89 e5             	mov    %rsp,%rbp
  800fd5:	41 55                	push   %r13
  800fd7:	41 54                	push   %r12
  800fd9:	53                   	push   %rbx
  800fda:	48 83 ec 08          	sub    $0x8,%rsp
  800fde:	49 89 f4             	mov    %rsi,%r12
  800fe1:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800fe4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800feb:	00 00 00 
  800fee:	8b 57 0c             	mov    0xc(%rdi),%edx
  800ff1:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  800ff3:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  800ff7:	be 00 00 00 00       	mov    $0x0,%esi
  800ffc:	bf 03 00 00 00       	mov    $0x3,%edi
  801001:	48 b8 f2 0d 80 00 00 	movabs $0x800df2,%rax
  801008:	00 00 00 
  80100b:	ff d0                	call   *%rax
  80100d:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  801010:	4d 85 ed             	test   %r13,%r13
  801013:	78 2a                	js     80103f <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  801015:	4c 89 ea             	mov    %r13,%rdx
  801018:	4c 39 eb             	cmp    %r13,%rbx
  80101b:	72 30                	jb     80104d <devfile_read+0x80>
  80101d:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  801024:	7f 27                	jg     80104d <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  801026:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  80102d:	00 00 00 
  801030:	4c 89 e7             	mov    %r12,%rdi
  801033:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  80103a:	00 00 00 
  80103d:	ff d0                	call   *%rax
}
  80103f:	4c 89 e8             	mov    %r13,%rax
  801042:	48 83 c4 08          	add    $0x8,%rsp
  801046:	5b                   	pop    %rbx
  801047:	41 5c                	pop    %r12
  801049:	41 5d                	pop    %r13
  80104b:	5d                   	pop    %rbp
  80104c:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  80104d:	48 b9 51 30 80 00 00 	movabs $0x803051,%rcx
  801054:	00 00 00 
  801057:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  80105e:	00 00 00 
  801061:	be 7b 00 00 00       	mov    $0x7b,%esi
  801066:	48 bf 83 30 80 00 00 	movabs $0x803083,%rdi
  80106d:	00 00 00 
  801070:	b8 00 00 00 00       	mov    $0x0,%eax
  801075:	49 b8 1e 1c 80 00 00 	movabs $0x801c1e,%r8
  80107c:	00 00 00 
  80107f:	41 ff d0             	call   *%r8

0000000000801082 <open>:
open(const char *path, int mode) {
  801082:	f3 0f 1e fa          	endbr64
  801086:	55                   	push   %rbp
  801087:	48 89 e5             	mov    %rsp,%rbp
  80108a:	41 55                	push   %r13
  80108c:	41 54                	push   %r12
  80108e:	53                   	push   %rbx
  80108f:	48 83 ec 18          	sub    $0x18,%rsp
  801093:	49 89 fc             	mov    %rdi,%r12
  801096:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801099:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  8010a0:	00 00 00 
  8010a3:	ff d0                	call   *%rax
  8010a5:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8010ab:	0f 87 8a 00 00 00    	ja     80113b <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8010b1:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8010b5:	48 b8 ed 06 80 00 00 	movabs $0x8006ed,%rax
  8010bc:	00 00 00 
  8010bf:	ff d0                	call   *%rax
  8010c1:	89 c3                	mov    %eax,%ebx
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	78 50                	js     801117 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  8010c7:	4c 89 e6             	mov    %r12,%rsi
  8010ca:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  8010d1:	00 00 00 
  8010d4:	48 89 df             	mov    %rbx,%rdi
  8010d7:	48 b8 c3 26 80 00 00 	movabs $0x8026c3,%rax
  8010de:	00 00 00 
  8010e1:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8010e3:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8010ea:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8010ee:	bf 01 00 00 00       	mov    $0x1,%edi
  8010f3:	48 b8 f2 0d 80 00 00 	movabs $0x800df2,%rax
  8010fa:	00 00 00 
  8010fd:	ff d0                	call   *%rax
  8010ff:	89 c3                	mov    %eax,%ebx
  801101:	85 c0                	test   %eax,%eax
  801103:	78 1f                	js     801124 <open+0xa2>
    return fd2num(fd);
  801105:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801109:	48 b8 b7 06 80 00 00 	movabs $0x8006b7,%rax
  801110:	00 00 00 
  801113:	ff d0                	call   *%rax
  801115:	89 c3                	mov    %eax,%ebx
}
  801117:	89 d8                	mov    %ebx,%eax
  801119:	48 83 c4 18          	add    $0x18,%rsp
  80111d:	5b                   	pop    %rbx
  80111e:	41 5c                	pop    %r12
  801120:	41 5d                	pop    %r13
  801122:	5d                   	pop    %rbp
  801123:	c3                   	ret
        fd_close(fd, 0);
  801124:	be 00 00 00 00       	mov    $0x0,%esi
  801129:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80112d:	48 b8 14 08 80 00 00 	movabs $0x800814,%rax
  801134:	00 00 00 
  801137:	ff d0                	call   *%rax
        return res;
  801139:	eb dc                	jmp    801117 <open+0x95>
        return -E_BAD_PATH;
  80113b:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801140:	eb d5                	jmp    801117 <open+0x95>

0000000000801142 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801142:	f3 0f 1e fa          	endbr64
  801146:	55                   	push   %rbp
  801147:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80114a:	be 00 00 00 00       	mov    $0x0,%esi
  80114f:	bf 08 00 00 00       	mov    $0x8,%edi
  801154:	48 b8 f2 0d 80 00 00 	movabs $0x800df2,%rax
  80115b:	00 00 00 
  80115e:	ff d0                	call   *%rax
}
  801160:	5d                   	pop    %rbp
  801161:	c3                   	ret

0000000000801162 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801162:	f3 0f 1e fa          	endbr64
  801166:	55                   	push   %rbp
  801167:	48 89 e5             	mov    %rsp,%rbp
  80116a:	41 54                	push   %r12
  80116c:	53                   	push   %rbx
  80116d:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801170:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  801177:	00 00 00 
  80117a:	ff d0                	call   *%rax
  80117c:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80117f:	48 be 8e 30 80 00 00 	movabs $0x80308e,%rsi
  801186:	00 00 00 
  801189:	48 89 df             	mov    %rbx,%rdi
  80118c:	48 b8 c3 26 80 00 00 	movabs $0x8026c3,%rax
  801193:	00 00 00 
  801196:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801198:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80119d:	41 2b 04 24          	sub    (%r12),%eax
  8011a1:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8011a7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8011ae:	00 00 00 
    stat->st_dev = &devpipe;
  8011b1:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8011b8:	00 00 00 
  8011bb:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8011c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c7:	5b                   	pop    %rbx
  8011c8:	41 5c                	pop    %r12
  8011ca:	5d                   	pop    %rbp
  8011cb:	c3                   	ret

00000000008011cc <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8011cc:	f3 0f 1e fa          	endbr64
  8011d0:	55                   	push   %rbp
  8011d1:	48 89 e5             	mov    %rsp,%rbp
  8011d4:	41 54                	push   %r12
  8011d6:	53                   	push   %rbx
  8011d7:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8011da:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011df:	48 89 fe             	mov    %rdi,%rsi
  8011e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8011e7:	49 bc 33 04 80 00 00 	movabs $0x800433,%r12
  8011ee:	00 00 00 
  8011f1:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8011f4:	48 89 df             	mov    %rbx,%rdi
  8011f7:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  8011fe:	00 00 00 
  801201:	ff d0                	call   *%rax
  801203:	48 89 c6             	mov    %rax,%rsi
  801206:	ba 00 10 00 00       	mov    $0x1000,%edx
  80120b:	bf 00 00 00 00       	mov    $0x0,%edi
  801210:	41 ff d4             	call   *%r12
}
  801213:	5b                   	pop    %rbx
  801214:	41 5c                	pop    %r12
  801216:	5d                   	pop    %rbp
  801217:	c3                   	ret

0000000000801218 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  801218:	f3 0f 1e fa          	endbr64
  80121c:	55                   	push   %rbp
  80121d:	48 89 e5             	mov    %rsp,%rbp
  801220:	41 57                	push   %r15
  801222:	41 56                	push   %r14
  801224:	41 55                	push   %r13
  801226:	41 54                	push   %r12
  801228:	53                   	push   %rbx
  801229:	48 83 ec 18          	sub    $0x18,%rsp
  80122d:	49 89 fc             	mov    %rdi,%r12
  801230:	49 89 f5             	mov    %rsi,%r13
  801233:	49 89 d7             	mov    %rdx,%r15
  801236:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80123a:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  801241:	00 00 00 
  801244:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801246:	4d 85 ff             	test   %r15,%r15
  801249:	0f 84 af 00 00 00    	je     8012fe <devpipe_write+0xe6>
  80124f:	48 89 c3             	mov    %rax,%rbx
  801252:	4c 89 f8             	mov    %r15,%rax
  801255:	4d 89 ef             	mov    %r13,%r15
  801258:	4c 01 e8             	add    %r13,%rax
  80125b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80125f:	49 bd c3 02 80 00 00 	movabs $0x8002c3,%r13
  801266:	00 00 00 
            sys_yield();
  801269:	49 be 58 02 80 00 00 	movabs $0x800258,%r14
  801270:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801273:	8b 73 04             	mov    0x4(%rbx),%esi
  801276:	48 63 ce             	movslq %esi,%rcx
  801279:	48 63 03             	movslq (%rbx),%rax
  80127c:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801282:	48 39 c1             	cmp    %rax,%rcx
  801285:	72 2e                	jb     8012b5 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801287:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80128c:	48 89 da             	mov    %rbx,%rdx
  80128f:	be 00 10 00 00       	mov    $0x1000,%esi
  801294:	4c 89 e7             	mov    %r12,%rdi
  801297:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80129a:	85 c0                	test   %eax,%eax
  80129c:	74 66                	je     801304 <devpipe_write+0xec>
            sys_yield();
  80129e:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8012a1:	8b 73 04             	mov    0x4(%rbx),%esi
  8012a4:	48 63 ce             	movslq %esi,%rcx
  8012a7:	48 63 03             	movslq (%rbx),%rax
  8012aa:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8012b0:	48 39 c1             	cmp    %rax,%rcx
  8012b3:	73 d2                	jae    801287 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8012b5:	41 0f b6 3f          	movzbl (%r15),%edi
  8012b9:	48 89 ca             	mov    %rcx,%rdx
  8012bc:	48 c1 ea 03          	shr    $0x3,%rdx
  8012c0:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8012c7:	08 10 20 
  8012ca:	48 f7 e2             	mul    %rdx
  8012cd:	48 c1 ea 06          	shr    $0x6,%rdx
  8012d1:	48 89 d0             	mov    %rdx,%rax
  8012d4:	48 c1 e0 09          	shl    $0x9,%rax
  8012d8:	48 29 d0             	sub    %rdx,%rax
  8012db:	48 c1 e0 03          	shl    $0x3,%rax
  8012df:	48 29 c1             	sub    %rax,%rcx
  8012e2:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8012e7:	83 c6 01             	add    $0x1,%esi
  8012ea:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012ed:	49 83 c7 01          	add    $0x1,%r15
  8012f1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012f5:	49 39 c7             	cmp    %rax,%r15
  8012f8:	0f 85 75 ff ff ff    	jne    801273 <devpipe_write+0x5b>
    return n;
  8012fe:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801302:	eb 05                	jmp    801309 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  801304:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801309:	48 83 c4 18          	add    $0x18,%rsp
  80130d:	5b                   	pop    %rbx
  80130e:	41 5c                	pop    %r12
  801310:	41 5d                	pop    %r13
  801312:	41 5e                	pop    %r14
  801314:	41 5f                	pop    %r15
  801316:	5d                   	pop    %rbp
  801317:	c3                   	ret

0000000000801318 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  801318:	f3 0f 1e fa          	endbr64
  80131c:	55                   	push   %rbp
  80131d:	48 89 e5             	mov    %rsp,%rbp
  801320:	41 57                	push   %r15
  801322:	41 56                	push   %r14
  801324:	41 55                	push   %r13
  801326:	41 54                	push   %r12
  801328:	53                   	push   %rbx
  801329:	48 83 ec 18          	sub    $0x18,%rsp
  80132d:	49 89 fc             	mov    %rdi,%r12
  801330:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801334:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801338:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  80133f:	00 00 00 
  801342:	ff d0                	call   *%rax
  801344:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  801347:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80134d:	49 bd c3 02 80 00 00 	movabs $0x8002c3,%r13
  801354:	00 00 00 
            sys_yield();
  801357:	49 be 58 02 80 00 00 	movabs $0x800258,%r14
  80135e:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801361:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801366:	74 7d                	je     8013e5 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801368:	8b 03                	mov    (%rbx),%eax
  80136a:	3b 43 04             	cmp    0x4(%rbx),%eax
  80136d:	75 26                	jne    801395 <devpipe_read+0x7d>
            if (i > 0) return i;
  80136f:	4d 85 ff             	test   %r15,%r15
  801372:	75 77                	jne    8013eb <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801374:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801379:	48 89 da             	mov    %rbx,%rdx
  80137c:	be 00 10 00 00       	mov    $0x1000,%esi
  801381:	4c 89 e7             	mov    %r12,%rdi
  801384:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801387:	85 c0                	test   %eax,%eax
  801389:	74 72                	je     8013fd <devpipe_read+0xe5>
            sys_yield();
  80138b:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80138e:	8b 03                	mov    (%rbx),%eax
  801390:	3b 43 04             	cmp    0x4(%rbx),%eax
  801393:	74 df                	je     801374 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801395:	48 63 c8             	movslq %eax,%rcx
  801398:	48 89 ca             	mov    %rcx,%rdx
  80139b:	48 c1 ea 03          	shr    $0x3,%rdx
  80139f:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8013a6:	08 10 20 
  8013a9:	48 89 d0             	mov    %rdx,%rax
  8013ac:	48 f7 e6             	mul    %rsi
  8013af:	48 c1 ea 06          	shr    $0x6,%rdx
  8013b3:	48 89 d0             	mov    %rdx,%rax
  8013b6:	48 c1 e0 09          	shl    $0x9,%rax
  8013ba:	48 29 d0             	sub    %rdx,%rax
  8013bd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8013c4:	00 
  8013c5:	48 89 c8             	mov    %rcx,%rax
  8013c8:	48 29 d0             	sub    %rdx,%rax
  8013cb:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8013d0:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8013d4:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8013d8:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8013db:	49 83 c7 01          	add    $0x1,%r15
  8013df:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8013e3:	75 83                	jne    801368 <devpipe_read+0x50>
    return n;
  8013e5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013e9:	eb 03                	jmp    8013ee <devpipe_read+0xd6>
            if (i > 0) return i;
  8013eb:	4c 89 f8             	mov    %r15,%rax
}
  8013ee:	48 83 c4 18          	add    $0x18,%rsp
  8013f2:	5b                   	pop    %rbx
  8013f3:	41 5c                	pop    %r12
  8013f5:	41 5d                	pop    %r13
  8013f7:	41 5e                	pop    %r14
  8013f9:	41 5f                	pop    %r15
  8013fb:	5d                   	pop    %rbp
  8013fc:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801402:	eb ea                	jmp    8013ee <devpipe_read+0xd6>

0000000000801404 <pipe>:
pipe(int pfd[2]) {
  801404:	f3 0f 1e fa          	endbr64
  801408:	55                   	push   %rbp
  801409:	48 89 e5             	mov    %rsp,%rbp
  80140c:	41 55                	push   %r13
  80140e:	41 54                	push   %r12
  801410:	53                   	push   %rbx
  801411:	48 83 ec 18          	sub    $0x18,%rsp
  801415:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  801418:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80141c:	48 b8 ed 06 80 00 00 	movabs $0x8006ed,%rax
  801423:	00 00 00 
  801426:	ff d0                	call   *%rax
  801428:	89 c3                	mov    %eax,%ebx
  80142a:	85 c0                	test   %eax,%eax
  80142c:	0f 88 a0 01 00 00    	js     8015d2 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  801432:	b9 46 00 00 00       	mov    $0x46,%ecx
  801437:	ba 00 10 00 00       	mov    $0x1000,%edx
  80143c:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801440:	bf 00 00 00 00       	mov    $0x0,%edi
  801445:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  80144c:	00 00 00 
  80144f:	ff d0                	call   *%rax
  801451:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801453:	85 c0                	test   %eax,%eax
  801455:	0f 88 77 01 00 00    	js     8015d2 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80145b:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80145f:	48 b8 ed 06 80 00 00 	movabs $0x8006ed,%rax
  801466:	00 00 00 
  801469:	ff d0                	call   *%rax
  80146b:	89 c3                	mov    %eax,%ebx
  80146d:	85 c0                	test   %eax,%eax
  80146f:	0f 88 43 01 00 00    	js     8015b8 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  801475:	b9 46 00 00 00       	mov    $0x46,%ecx
  80147a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80147f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801483:	bf 00 00 00 00       	mov    $0x0,%edi
  801488:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  80148f:	00 00 00 
  801492:	ff d0                	call   *%rax
  801494:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  801496:	85 c0                	test   %eax,%eax
  801498:	0f 88 1a 01 00 00    	js     8015b8 <pipe+0x1b4>
    va = fd2data(fd0);
  80149e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8014a2:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  8014a9:	00 00 00 
  8014ac:	ff d0                	call   *%rax
  8014ae:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8014b1:	b9 46 00 00 00       	mov    $0x46,%ecx
  8014b6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8014bb:	48 89 c6             	mov    %rax,%rsi
  8014be:	bf 00 00 00 00       	mov    $0x0,%edi
  8014c3:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  8014ca:	00 00 00 
  8014cd:	ff d0                	call   *%rax
  8014cf:	89 c3                	mov    %eax,%ebx
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	0f 88 c5 00 00 00    	js     80159e <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8014d9:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8014dd:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  8014e4:	00 00 00 
  8014e7:	ff d0                	call   *%rax
  8014e9:	48 89 c1             	mov    %rax,%rcx
  8014ec:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8014f2:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8014f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fd:	4c 89 ee             	mov    %r13,%rsi
  801500:	bf 00 00 00 00       	mov    $0x0,%edi
  801505:	48 b8 5e 03 80 00 00 	movabs $0x80035e,%rax
  80150c:	00 00 00 
  80150f:	ff d0                	call   *%rax
  801511:	89 c3                	mov    %eax,%ebx
  801513:	85 c0                	test   %eax,%eax
  801515:	78 6e                	js     801585 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  801517:	be 00 10 00 00       	mov    $0x1000,%esi
  80151c:	4c 89 ef             	mov    %r13,%rdi
  80151f:	48 b8 8d 02 80 00 00 	movabs $0x80028d,%rax
  801526:	00 00 00 
  801529:	ff d0                	call   *%rax
  80152b:	83 f8 02             	cmp    $0x2,%eax
  80152e:	0f 85 ab 00 00 00    	jne    8015df <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  801534:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80153b:	00 00 
  80153d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801541:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  801543:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801547:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80154e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801552:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801554:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801558:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80155f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801563:	48 bb b7 06 80 00 00 	movabs $0x8006b7,%rbx
  80156a:	00 00 00 
  80156d:	ff d3                	call   *%rbx
  80156f:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801573:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801577:	ff d3                	call   *%rbx
  801579:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80157e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801583:	eb 4d                	jmp    8015d2 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  801585:	ba 00 10 00 00       	mov    $0x1000,%edx
  80158a:	4c 89 ee             	mov    %r13,%rsi
  80158d:	bf 00 00 00 00       	mov    $0x0,%edi
  801592:	48 b8 33 04 80 00 00 	movabs $0x800433,%rax
  801599:	00 00 00 
  80159c:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80159e:	ba 00 10 00 00       	mov    $0x1000,%edx
  8015a3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8015a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8015ac:	48 b8 33 04 80 00 00 	movabs $0x800433,%rax
  8015b3:	00 00 00 
  8015b6:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8015b8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8015bd:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8015c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8015c6:	48 b8 33 04 80 00 00 	movabs $0x800433,%rax
  8015cd:	00 00 00 
  8015d0:	ff d0                	call   *%rax
}
  8015d2:	89 d8                	mov    %ebx,%eax
  8015d4:	48 83 c4 18          	add    $0x18,%rsp
  8015d8:	5b                   	pop    %rbx
  8015d9:	41 5c                	pop    %r12
  8015db:	41 5d                	pop    %r13
  8015dd:	5d                   	pop    %rbp
  8015de:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8015df:	48 b9 c0 32 80 00 00 	movabs $0x8032c0,%rcx
  8015e6:	00 00 00 
  8015e9:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  8015f0:	00 00 00 
  8015f3:	be 2e 00 00 00       	mov    $0x2e,%esi
  8015f8:	48 bf 95 30 80 00 00 	movabs $0x803095,%rdi
  8015ff:	00 00 00 
  801602:	b8 00 00 00 00       	mov    $0x0,%eax
  801607:	49 b8 1e 1c 80 00 00 	movabs $0x801c1e,%r8
  80160e:	00 00 00 
  801611:	41 ff d0             	call   *%r8

0000000000801614 <pipeisclosed>:
pipeisclosed(int fdnum) {
  801614:	f3 0f 1e fa          	endbr64
  801618:	55                   	push   %rbp
  801619:	48 89 e5             	mov    %rsp,%rbp
  80161c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801620:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801624:	48 b8 51 07 80 00 00 	movabs $0x800751,%rax
  80162b:	00 00 00 
  80162e:	ff d0                	call   *%rax
    if (res < 0) return res;
  801630:	85 c0                	test   %eax,%eax
  801632:	78 35                	js     801669 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  801634:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801638:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  80163f:	00 00 00 
  801642:	ff d0                	call   *%rax
  801644:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801647:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80164c:	be 00 10 00 00       	mov    $0x1000,%esi
  801651:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801655:	48 b8 c3 02 80 00 00 	movabs $0x8002c3,%rax
  80165c:	00 00 00 
  80165f:	ff d0                	call   *%rax
  801661:	85 c0                	test   %eax,%eax
  801663:	0f 94 c0             	sete   %al
  801666:	0f b6 c0             	movzbl %al,%eax
}
  801669:	c9                   	leave
  80166a:	c3                   	ret

000000000080166b <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  80166b:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80166f:	48 89 f8             	mov    %rdi,%rax
  801672:	48 c1 e8 27          	shr    $0x27,%rax
  801676:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80167d:	7f 00 00 
  801680:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801684:	f6 c2 01             	test   $0x1,%dl
  801687:	74 6d                	je     8016f6 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801689:	48 89 f8             	mov    %rdi,%rax
  80168c:	48 c1 e8 1e          	shr    $0x1e,%rax
  801690:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801697:	7f 00 00 
  80169a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80169e:	f6 c2 01             	test   $0x1,%dl
  8016a1:	74 62                	je     801705 <get_uvpt_entry+0x9a>
  8016a3:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8016aa:	7f 00 00 
  8016ad:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8016b1:	f6 c2 80             	test   $0x80,%dl
  8016b4:	75 4f                	jne    801705 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8016b6:	48 89 f8             	mov    %rdi,%rax
  8016b9:	48 c1 e8 15          	shr    $0x15,%rax
  8016bd:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016c4:	7f 00 00 
  8016c7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8016cb:	f6 c2 01             	test   $0x1,%dl
  8016ce:	74 44                	je     801714 <get_uvpt_entry+0xa9>
  8016d0:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016d7:	7f 00 00 
  8016da:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8016de:	f6 c2 80             	test   $0x80,%dl
  8016e1:	75 31                	jne    801714 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  8016e3:	48 c1 ef 0c          	shr    $0xc,%rdi
  8016e7:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8016ee:	7f 00 00 
  8016f1:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8016f5:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8016f6:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8016fd:	7f 00 00 
  801700:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801704:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801705:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80170c:	7f 00 00 
  80170f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801713:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801714:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80171b:	7f 00 00 
  80171e:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801722:	c3                   	ret

0000000000801723 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  801723:	f3 0f 1e fa          	endbr64
  801727:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  80172a:	48 89 f9             	mov    %rdi,%rcx
  80172d:	48 c1 e9 27          	shr    $0x27,%rcx
  801731:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  801738:	7f 00 00 
  80173b:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  80173f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  801746:	f6 c1 01             	test   $0x1,%cl
  801749:	0f 84 b2 00 00 00    	je     801801 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80174f:	48 89 f9             	mov    %rdi,%rcx
  801752:	48 c1 e9 1e          	shr    $0x1e,%rcx
  801756:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80175d:	7f 00 00 
  801760:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801764:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80176b:	40 f6 c6 01          	test   $0x1,%sil
  80176f:	0f 84 8c 00 00 00    	je     801801 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  801775:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80177c:	7f 00 00 
  80177f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801783:	a8 80                	test   $0x80,%al
  801785:	75 7b                	jne    801802 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  801787:	48 89 f9             	mov    %rdi,%rcx
  80178a:	48 c1 e9 15          	shr    $0x15,%rcx
  80178e:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801795:	7f 00 00 
  801798:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80179c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  8017a3:	40 f6 c6 01          	test   $0x1,%sil
  8017a7:	74 58                	je     801801 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  8017a9:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8017b0:	7f 00 00 
  8017b3:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017b7:	a8 80                	test   $0x80,%al
  8017b9:	75 6c                	jne    801827 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  8017bb:	48 89 f9             	mov    %rdi,%rcx
  8017be:	48 c1 e9 0c          	shr    $0xc,%rcx
  8017c2:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8017c9:	7f 00 00 
  8017cc:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8017d0:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  8017d7:	40 f6 c6 01          	test   $0x1,%sil
  8017db:	74 24                	je     801801 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  8017dd:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8017e4:	7f 00 00 
  8017e7:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017eb:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017f2:	ff ff 7f 
  8017f5:	48 21 c8             	and    %rcx,%rax
  8017f8:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8017fe:	48 09 d0             	or     %rdx,%rax
}
  801801:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  801802:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801809:	7f 00 00 
  80180c:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801810:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  801817:	ff ff 7f 
  80181a:	48 21 c8             	and    %rcx,%rax
  80181d:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  801823:	48 01 d0             	add    %rdx,%rax
  801826:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  801827:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80182e:	7f 00 00 
  801831:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801835:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80183c:	ff ff 7f 
  80183f:	48 21 c8             	and    %rcx,%rax
  801842:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  801848:	48 01 d0             	add    %rdx,%rax
  80184b:	c3                   	ret

000000000080184c <get_prot>:

int
get_prot(void *va) {
  80184c:	f3 0f 1e fa          	endbr64
  801850:	55                   	push   %rbp
  801851:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801854:	48 b8 6b 16 80 00 00 	movabs $0x80166b,%rax
  80185b:	00 00 00 
  80185e:	ff d0                	call   *%rax
  801860:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  801863:	83 e0 01             	and    $0x1,%eax
  801866:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  801869:	89 d1                	mov    %edx,%ecx
  80186b:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  801871:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  801873:	89 c1                	mov    %eax,%ecx
  801875:	83 c9 02             	or     $0x2,%ecx
  801878:	f6 c2 02             	test   $0x2,%dl
  80187b:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80187e:	89 c1                	mov    %eax,%ecx
  801880:	83 c9 01             	or     $0x1,%ecx
  801883:	48 85 d2             	test   %rdx,%rdx
  801886:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801889:	89 c1                	mov    %eax,%ecx
  80188b:	83 c9 40             	or     $0x40,%ecx
  80188e:	f6 c6 04             	test   $0x4,%dh
  801891:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801894:	5d                   	pop    %rbp
  801895:	c3                   	ret

0000000000801896 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801896:	f3 0f 1e fa          	endbr64
  80189a:	55                   	push   %rbp
  80189b:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80189e:	48 b8 6b 16 80 00 00 	movabs $0x80166b,%rax
  8018a5:	00 00 00 
  8018a8:	ff d0                	call   *%rax
    return pte & PTE_D;
  8018aa:	48 c1 e8 06          	shr    $0x6,%rax
  8018ae:	83 e0 01             	and    $0x1,%eax
}
  8018b1:	5d                   	pop    %rbp
  8018b2:	c3                   	ret

00000000008018b3 <is_page_present>:

bool
is_page_present(void *va) {
  8018b3:	f3 0f 1e fa          	endbr64
  8018b7:	55                   	push   %rbp
  8018b8:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8018bb:	48 b8 6b 16 80 00 00 	movabs $0x80166b,%rax
  8018c2:	00 00 00 
  8018c5:	ff d0                	call   *%rax
  8018c7:	83 e0 01             	and    $0x1,%eax
}
  8018ca:	5d                   	pop    %rbp
  8018cb:	c3                   	ret

00000000008018cc <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8018cc:	f3 0f 1e fa          	endbr64
  8018d0:	55                   	push   %rbp
  8018d1:	48 89 e5             	mov    %rsp,%rbp
  8018d4:	41 57                	push   %r15
  8018d6:	41 56                	push   %r14
  8018d8:	41 55                	push   %r13
  8018da:	41 54                	push   %r12
  8018dc:	53                   	push   %rbx
  8018dd:	48 83 ec 18          	sub    $0x18,%rsp
  8018e1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8018e5:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8018e9:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8018ee:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8018f5:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8018f8:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8018ff:	7f 00 00 
    while (va < USER_STACK_TOP) {
  801902:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  801909:	00 00 00 
  80190c:	eb 73                	jmp    801981 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  80190e:	48 89 d8             	mov    %rbx,%rax
  801911:	48 c1 e8 15          	shr    $0x15,%rax
  801915:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  80191c:	7f 00 00 
  80191f:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  801923:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  801929:	f6 c2 01             	test   $0x1,%dl
  80192c:	74 4b                	je     801979 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  80192e:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  801932:	f6 c2 80             	test   $0x80,%dl
  801935:	74 11                	je     801948 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  801937:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  80193b:	f6 c4 04             	test   $0x4,%ah
  80193e:	74 39                	je     801979 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  801940:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  801946:	eb 20                	jmp    801968 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801948:	48 89 da             	mov    %rbx,%rdx
  80194b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80194f:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801956:	7f 00 00 
  801959:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  80195d:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801963:	f6 c4 04             	test   $0x4,%ah
  801966:	74 11                	je     801979 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  801968:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  80196c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801970:	48 89 df             	mov    %rbx,%rdi
  801973:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801977:	ff d0                	call   *%rax
    next:
        va += size;
  801979:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  80197c:	49 39 df             	cmp    %rbx,%r15
  80197f:	72 3e                	jb     8019bf <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  801981:	49 8b 06             	mov    (%r14),%rax
  801984:	a8 01                	test   $0x1,%al
  801986:	74 37                	je     8019bf <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801988:	48 89 d8             	mov    %rbx,%rax
  80198b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80198f:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  801994:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80199a:	f6 c2 01             	test   $0x1,%dl
  80199d:	74 da                	je     801979 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  80199f:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  8019a4:	f6 c2 80             	test   $0x80,%dl
  8019a7:	0f 84 61 ff ff ff    	je     80190e <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  8019ad:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8019b2:	f6 c4 04             	test   $0x4,%ah
  8019b5:	74 c2                	je     801979 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  8019b7:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  8019bd:	eb a9                	jmp    801968 <foreach_shared_region+0x9c>
    }
    return res;
}
  8019bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c4:	48 83 c4 18          	add    $0x18,%rsp
  8019c8:	5b                   	pop    %rbx
  8019c9:	41 5c                	pop    %r12
  8019cb:	41 5d                	pop    %r13
  8019cd:	41 5e                	pop    %r14
  8019cf:	41 5f                	pop    %r15
  8019d1:	5d                   	pop    %rbp
  8019d2:	c3                   	ret

00000000008019d3 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  8019d3:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  8019d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019dc:	c3                   	ret

00000000008019dd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8019dd:	f3 0f 1e fa          	endbr64
  8019e1:	55                   	push   %rbp
  8019e2:	48 89 e5             	mov    %rsp,%rbp
  8019e5:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8019e8:	48 be a5 30 80 00 00 	movabs $0x8030a5,%rsi
  8019ef:	00 00 00 
  8019f2:	48 b8 c3 26 80 00 00 	movabs $0x8026c3,%rax
  8019f9:	00 00 00 
  8019fc:	ff d0                	call   *%rax
    return 0;
}
  8019fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801a03:	5d                   	pop    %rbp
  801a04:	c3                   	ret

0000000000801a05 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  801a05:	f3 0f 1e fa          	endbr64
  801a09:	55                   	push   %rbp
  801a0a:	48 89 e5             	mov    %rsp,%rbp
  801a0d:	41 57                	push   %r15
  801a0f:	41 56                	push   %r14
  801a11:	41 55                	push   %r13
  801a13:	41 54                	push   %r12
  801a15:	53                   	push   %rbx
  801a16:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  801a1d:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  801a24:	48 85 d2             	test   %rdx,%rdx
  801a27:	74 7a                	je     801aa3 <devcons_write+0x9e>
  801a29:	49 89 d6             	mov    %rdx,%r14
  801a2c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a32:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  801a37:	49 bf de 28 80 00 00 	movabs $0x8028de,%r15
  801a3e:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  801a41:	4c 89 f3             	mov    %r14,%rbx
  801a44:	48 29 f3             	sub    %rsi,%rbx
  801a47:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a4c:	48 39 c3             	cmp    %rax,%rbx
  801a4f:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801a53:	4c 63 eb             	movslq %ebx,%r13
  801a56:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801a5d:	48 01 c6             	add    %rax,%rsi
  801a60:	4c 89 ea             	mov    %r13,%rdx
  801a63:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a6a:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  801a6d:	4c 89 ee             	mov    %r13,%rsi
  801a70:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a77:	48 b8 4e 01 80 00 00 	movabs $0x80014e,%rax
  801a7e:	00 00 00 
  801a81:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801a83:	41 01 dc             	add    %ebx,%r12d
  801a86:	49 63 f4             	movslq %r12d,%rsi
  801a89:	4c 39 f6             	cmp    %r14,%rsi
  801a8c:	72 b3                	jb     801a41 <devcons_write+0x3c>
    return res;
  801a8e:	49 63 c4             	movslq %r12d,%rax
}
  801a91:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801a98:	5b                   	pop    %rbx
  801a99:	41 5c                	pop    %r12
  801a9b:	41 5d                	pop    %r13
  801a9d:	41 5e                	pop    %r14
  801a9f:	41 5f                	pop    %r15
  801aa1:	5d                   	pop    %rbp
  801aa2:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  801aa3:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801aa9:	eb e3                	jmp    801a8e <devcons_write+0x89>

0000000000801aab <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801aab:	f3 0f 1e fa          	endbr64
  801aaf:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801ab2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab7:	48 85 c0             	test   %rax,%rax
  801aba:	74 55                	je     801b11 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801abc:	55                   	push   %rbp
  801abd:	48 89 e5             	mov    %rsp,%rbp
  801ac0:	41 55                	push   %r13
  801ac2:	41 54                	push   %r12
  801ac4:	53                   	push   %rbx
  801ac5:	48 83 ec 08          	sub    $0x8,%rsp
  801ac9:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801acc:	48 bb 7f 01 80 00 00 	movabs $0x80017f,%rbx
  801ad3:	00 00 00 
  801ad6:	49 bc 58 02 80 00 00 	movabs $0x800258,%r12
  801add:	00 00 00 
  801ae0:	eb 03                	jmp    801ae5 <devcons_read+0x3a>
  801ae2:	41 ff d4             	call   *%r12
  801ae5:	ff d3                	call   *%rbx
  801ae7:	85 c0                	test   %eax,%eax
  801ae9:	74 f7                	je     801ae2 <devcons_read+0x37>
    if (c < 0) return c;
  801aeb:	48 63 d0             	movslq %eax,%rdx
  801aee:	78 13                	js     801b03 <devcons_read+0x58>
    if (c == 0x04) return 0;
  801af0:	ba 00 00 00 00       	mov    $0x0,%edx
  801af5:	83 f8 04             	cmp    $0x4,%eax
  801af8:	74 09                	je     801b03 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  801afa:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801afe:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801b03:	48 89 d0             	mov    %rdx,%rax
  801b06:	48 83 c4 08          	add    $0x8,%rsp
  801b0a:	5b                   	pop    %rbx
  801b0b:	41 5c                	pop    %r12
  801b0d:	41 5d                	pop    %r13
  801b0f:	5d                   	pop    %rbp
  801b10:	c3                   	ret
  801b11:	48 89 d0             	mov    %rdx,%rax
  801b14:	c3                   	ret

0000000000801b15 <cputchar>:
cputchar(int ch) {
  801b15:	f3 0f 1e fa          	endbr64
  801b19:	55                   	push   %rbp
  801b1a:	48 89 e5             	mov    %rsp,%rbp
  801b1d:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801b21:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801b25:	be 01 00 00 00       	mov    $0x1,%esi
  801b2a:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801b2e:	48 b8 4e 01 80 00 00 	movabs $0x80014e,%rax
  801b35:	00 00 00 
  801b38:	ff d0                	call   *%rax
}
  801b3a:	c9                   	leave
  801b3b:	c3                   	ret

0000000000801b3c <getchar>:
getchar(void) {
  801b3c:	f3 0f 1e fa          	endbr64
  801b40:	55                   	push   %rbp
  801b41:	48 89 e5             	mov    %rsp,%rbp
  801b44:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801b48:	ba 01 00 00 00       	mov    $0x1,%edx
  801b4d:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801b51:	bf 00 00 00 00       	mov    $0x0,%edi
  801b56:	48 b8 4c 0a 80 00 00 	movabs $0x800a4c,%rax
  801b5d:	00 00 00 
  801b60:	ff d0                	call   *%rax
  801b62:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801b64:	85 c0                	test   %eax,%eax
  801b66:	78 06                	js     801b6e <getchar+0x32>
  801b68:	74 08                	je     801b72 <getchar+0x36>
  801b6a:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  801b6e:	89 d0                	mov    %edx,%eax
  801b70:	c9                   	leave
  801b71:	c3                   	ret
    return res < 0 ? res : res ? c :
  801b72:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801b77:	eb f5                	jmp    801b6e <getchar+0x32>

0000000000801b79 <iscons>:
iscons(int fdnum) {
  801b79:	f3 0f 1e fa          	endbr64
  801b7d:	55                   	push   %rbp
  801b7e:	48 89 e5             	mov    %rsp,%rbp
  801b81:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801b85:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b89:	48 b8 51 07 80 00 00 	movabs $0x800751,%rax
  801b90:	00 00 00 
  801b93:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b95:	85 c0                	test   %eax,%eax
  801b97:	78 18                	js     801bb1 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  801b99:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b9d:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801ba4:	00 00 00 
  801ba7:	8b 00                	mov    (%rax),%eax
  801ba9:	39 02                	cmp    %eax,(%rdx)
  801bab:	0f 94 c0             	sete   %al
  801bae:	0f b6 c0             	movzbl %al,%eax
}
  801bb1:	c9                   	leave
  801bb2:	c3                   	ret

0000000000801bb3 <opencons>:
opencons(void) {
  801bb3:	f3 0f 1e fa          	endbr64
  801bb7:	55                   	push   %rbp
  801bb8:	48 89 e5             	mov    %rsp,%rbp
  801bbb:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801bbf:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801bc3:	48 b8 ed 06 80 00 00 	movabs $0x8006ed,%rax
  801bca:	00 00 00 
  801bcd:	ff d0                	call   *%rax
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	78 49                	js     801c1c <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801bd3:	b9 46 00 00 00       	mov    $0x46,%ecx
  801bd8:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bdd:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801be1:	bf 00 00 00 00       	mov    $0x0,%edi
  801be6:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  801bed:	00 00 00 
  801bf0:	ff d0                	call   *%rax
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	78 26                	js     801c1c <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  801bf6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bfa:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801c01:	00 00 
  801c03:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801c05:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801c09:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801c10:	48 b8 b7 06 80 00 00 	movabs $0x8006b7,%rax
  801c17:	00 00 00 
  801c1a:	ff d0                	call   *%rax
}
  801c1c:	c9                   	leave
  801c1d:	c3                   	ret

0000000000801c1e <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801c1e:	f3 0f 1e fa          	endbr64
  801c22:	55                   	push   %rbp
  801c23:	48 89 e5             	mov    %rsp,%rbp
  801c26:	41 56                	push   %r14
  801c28:	41 55                	push   %r13
  801c2a:	41 54                	push   %r12
  801c2c:	53                   	push   %rbx
  801c2d:	48 83 ec 50          	sub    $0x50,%rsp
  801c31:	49 89 fc             	mov    %rdi,%r12
  801c34:	41 89 f5             	mov    %esi,%r13d
  801c37:	48 89 d3             	mov    %rdx,%rbx
  801c3a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c3e:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801c42:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801c46:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801c4d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c51:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801c55:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801c59:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801c5d:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801c64:	00 00 00 
  801c67:	4c 8b 30             	mov    (%rax),%r14
  801c6a:	48 b8 23 02 80 00 00 	movabs $0x800223,%rax
  801c71:	00 00 00 
  801c74:	ff d0                	call   *%rax
  801c76:	89 c6                	mov    %eax,%esi
  801c78:	45 89 e8             	mov    %r13d,%r8d
  801c7b:	4c 89 e1             	mov    %r12,%rcx
  801c7e:	4c 89 f2             	mov    %r14,%rdx
  801c81:	48 bf e8 32 80 00 00 	movabs $0x8032e8,%rdi
  801c88:	00 00 00 
  801c8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c90:	49 bc 7a 1d 80 00 00 	movabs $0x801d7a,%r12
  801c97:	00 00 00 
  801c9a:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801c9d:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801ca1:	48 89 df             	mov    %rbx,%rdi
  801ca4:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  801cab:	00 00 00 
  801cae:	ff d0                	call   *%rax
    cprintf("\n");
  801cb0:	48 bf 32 30 80 00 00 	movabs $0x803032,%rdi
  801cb7:	00 00 00 
  801cba:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbf:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801cc2:	cc                   	int3
  801cc3:	eb fd                	jmp    801cc2 <_panic+0xa4>

0000000000801cc5 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801cc5:	f3 0f 1e fa          	endbr64
  801cc9:	55                   	push   %rbp
  801cca:	48 89 e5             	mov    %rsp,%rbp
  801ccd:	53                   	push   %rbx
  801cce:	48 83 ec 08          	sub    $0x8,%rsp
  801cd2:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801cd5:	8b 06                	mov    (%rsi),%eax
  801cd7:	8d 50 01             	lea    0x1(%rax),%edx
  801cda:	89 16                	mov    %edx,(%rsi)
  801cdc:	48 98                	cltq
  801cde:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801ce3:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801ce9:	74 0a                	je     801cf5 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801ceb:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801cef:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cf3:	c9                   	leave
  801cf4:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  801cf5:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801cf9:	be ff 00 00 00       	mov    $0xff,%esi
  801cfe:	48 b8 4e 01 80 00 00 	movabs $0x80014e,%rax
  801d05:	00 00 00 
  801d08:	ff d0                	call   *%rax
        state->offset = 0;
  801d0a:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801d10:	eb d9                	jmp    801ceb <putch+0x26>

0000000000801d12 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801d12:	f3 0f 1e fa          	endbr64
  801d16:	55                   	push   %rbp
  801d17:	48 89 e5             	mov    %rsp,%rbp
  801d1a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801d21:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801d24:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801d2b:	b9 21 00 00 00       	mov    $0x21,%ecx
  801d30:	b8 00 00 00 00       	mov    $0x0,%eax
  801d35:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801d38:	48 89 f1             	mov    %rsi,%rcx
  801d3b:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801d42:	48 bf c5 1c 80 00 00 	movabs $0x801cc5,%rdi
  801d49:	00 00 00 
  801d4c:	48 b8 da 1e 80 00 00 	movabs $0x801eda,%rax
  801d53:	00 00 00 
  801d56:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801d58:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801d5f:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801d66:	48 b8 4e 01 80 00 00 	movabs $0x80014e,%rax
  801d6d:	00 00 00 
  801d70:	ff d0                	call   *%rax

    return state.count;
}
  801d72:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801d78:	c9                   	leave
  801d79:	c3                   	ret

0000000000801d7a <cprintf>:

int
cprintf(const char *fmt, ...) {
  801d7a:	f3 0f 1e fa          	endbr64
  801d7e:	55                   	push   %rbp
  801d7f:	48 89 e5             	mov    %rsp,%rbp
  801d82:	48 83 ec 50          	sub    $0x50,%rsp
  801d86:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801d8a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801d8e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d92:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801d96:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801d9a:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801da1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801da5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801da9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801dad:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801db1:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801db5:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  801dbc:	00 00 00 
  801dbf:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801dc1:	c9                   	leave
  801dc2:	c3                   	ret

0000000000801dc3 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801dc3:	f3 0f 1e fa          	endbr64
  801dc7:	55                   	push   %rbp
  801dc8:	48 89 e5             	mov    %rsp,%rbp
  801dcb:	41 57                	push   %r15
  801dcd:	41 56                	push   %r14
  801dcf:	41 55                	push   %r13
  801dd1:	41 54                	push   %r12
  801dd3:	53                   	push   %rbx
  801dd4:	48 83 ec 18          	sub    $0x18,%rsp
  801dd8:	49 89 fc             	mov    %rdi,%r12
  801ddb:	49 89 f5             	mov    %rsi,%r13
  801dde:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801de2:	8b 45 10             	mov    0x10(%rbp),%eax
  801de5:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801de8:	41 89 cf             	mov    %ecx,%r15d
  801deb:	4c 39 fa             	cmp    %r15,%rdx
  801dee:	73 5b                	jae    801e4b <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801df0:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801df4:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801df8:	85 db                	test   %ebx,%ebx
  801dfa:	7e 0e                	jle    801e0a <print_num+0x47>
            putch(padc, put_arg);
  801dfc:	4c 89 ee             	mov    %r13,%rsi
  801dff:	44 89 f7             	mov    %r14d,%edi
  801e02:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801e05:	83 eb 01             	sub    $0x1,%ebx
  801e08:	75 f2                	jne    801dfc <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801e0a:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801e0e:	48 b9 c2 30 80 00 00 	movabs $0x8030c2,%rcx
  801e15:	00 00 00 
  801e18:	48 b8 b1 30 80 00 00 	movabs $0x8030b1,%rax
  801e1f:	00 00 00 
  801e22:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801e26:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2f:	49 f7 f7             	div    %r15
  801e32:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801e36:	4c 89 ee             	mov    %r13,%rsi
  801e39:	41 ff d4             	call   *%r12
}
  801e3c:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801e40:	5b                   	pop    %rbx
  801e41:	41 5c                	pop    %r12
  801e43:	41 5d                	pop    %r13
  801e45:	41 5e                	pop    %r14
  801e47:	41 5f                	pop    %r15
  801e49:	5d                   	pop    %rbp
  801e4a:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801e4b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e4f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e54:	49 f7 f7             	div    %r15
  801e57:	48 83 ec 08          	sub    $0x8,%rsp
  801e5b:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801e5f:	52                   	push   %rdx
  801e60:	45 0f be c9          	movsbl %r9b,%r9d
  801e64:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801e68:	48 89 c2             	mov    %rax,%rdx
  801e6b:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  801e72:	00 00 00 
  801e75:	ff d0                	call   *%rax
  801e77:	48 83 c4 10          	add    $0x10,%rsp
  801e7b:	eb 8d                	jmp    801e0a <print_num+0x47>

0000000000801e7d <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  801e7d:	f3 0f 1e fa          	endbr64
    state->count++;
  801e81:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801e85:	48 8b 06             	mov    (%rsi),%rax
  801e88:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801e8c:	73 0a                	jae    801e98 <sprintputch+0x1b>
        *state->start++ = ch;
  801e8e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e92:	48 89 16             	mov    %rdx,(%rsi)
  801e95:	40 88 38             	mov    %dil,(%rax)
    }
}
  801e98:	c3                   	ret

0000000000801e99 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801e99:	f3 0f 1e fa          	endbr64
  801e9d:	55                   	push   %rbp
  801e9e:	48 89 e5             	mov    %rsp,%rbp
  801ea1:	48 83 ec 50          	sub    $0x50,%rsp
  801ea5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ea9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801ead:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801eb1:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801eb8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ebc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ec0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801ec4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801ec8:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801ecc:	48 b8 da 1e 80 00 00 	movabs $0x801eda,%rax
  801ed3:	00 00 00 
  801ed6:	ff d0                	call   *%rax
}
  801ed8:	c9                   	leave
  801ed9:	c3                   	ret

0000000000801eda <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801eda:	f3 0f 1e fa          	endbr64
  801ede:	55                   	push   %rbp
  801edf:	48 89 e5             	mov    %rsp,%rbp
  801ee2:	41 57                	push   %r15
  801ee4:	41 56                	push   %r14
  801ee6:	41 55                	push   %r13
  801ee8:	41 54                	push   %r12
  801eea:	53                   	push   %rbx
  801eeb:	48 83 ec 38          	sub    $0x38,%rsp
  801eef:	49 89 fe             	mov    %rdi,%r14
  801ef2:	49 89 f5             	mov    %rsi,%r13
  801ef5:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  801ef8:	48 8b 01             	mov    (%rcx),%rax
  801efb:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801eff:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801f03:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801f07:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801f0b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801f0f:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  801f13:	0f b6 3b             	movzbl (%rbx),%edi
  801f16:	40 80 ff 25          	cmp    $0x25,%dil
  801f1a:	74 18                	je     801f34 <vprintfmt+0x5a>
            if (!ch) return;
  801f1c:	40 84 ff             	test   %dil,%dil
  801f1f:	0f 84 b2 06 00 00    	je     8025d7 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  801f25:	40 0f b6 ff          	movzbl %dil,%edi
  801f29:	4c 89 ee             	mov    %r13,%rsi
  801f2c:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  801f2f:	4c 89 e3             	mov    %r12,%rbx
  801f32:	eb db                	jmp    801f0f <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  801f34:	be 00 00 00 00       	mov    $0x0,%esi
  801f39:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  801f3d:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801f42:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f48:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801f4f:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f53:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  801f58:	41 0f b6 04 24       	movzbl (%r12),%eax
  801f5d:	88 45 a0             	mov    %al,-0x60(%rbp)
  801f60:	83 e8 23             	sub    $0x23,%eax
  801f63:	3c 57                	cmp    $0x57,%al
  801f65:	0f 87 52 06 00 00    	ja     8025bd <vprintfmt+0x6e3>
  801f6b:	0f b6 c0             	movzbl %al,%eax
  801f6e:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  801f75:	00 00 00 
  801f78:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  801f7c:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  801f7f:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  801f83:	eb ce                	jmp    801f53 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  801f85:	49 89 dc             	mov    %rbx,%r12
  801f88:	be 01 00 00 00       	mov    $0x1,%esi
  801f8d:	eb c4                	jmp    801f53 <vprintfmt+0x79>
            padc = ch;
  801f8f:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  801f93:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f96:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801f99:	eb b8                	jmp    801f53 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f9e:	83 f8 2f             	cmp    $0x2f,%eax
  801fa1:	77 24                	ja     801fc7 <vprintfmt+0xed>
  801fa3:	89 c1                	mov    %eax,%ecx
  801fa5:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  801fa9:	83 c0 08             	add    $0x8,%eax
  801fac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801faf:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  801fb2:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  801fb5:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801fb9:	79 98                	jns    801f53 <vprintfmt+0x79>
                width = precision;
  801fbb:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  801fbf:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801fc5:	eb 8c                	jmp    801f53 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801fc7:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801fcb:	48 8d 41 08          	lea    0x8(%rcx),%rax
  801fcf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fd3:	eb da                	jmp    801faf <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  801fd5:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  801fda:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fde:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  801fe4:	3c 39                	cmp    $0x39,%al
  801fe6:	77 1c                	ja     802004 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  801fe8:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  801fec:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  801ff0:	0f b6 c0             	movzbl %al,%eax
  801ff3:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801ff8:	0f b6 03             	movzbl (%rbx),%eax
  801ffb:	3c 39                	cmp    $0x39,%al
  801ffd:	76 e9                	jbe    801fe8 <vprintfmt+0x10e>
        process_precision:
  801fff:	49 89 dc             	mov    %rbx,%r12
  802002:	eb b1                	jmp    801fb5 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  802004:	49 89 dc             	mov    %rbx,%r12
  802007:	eb ac                	jmp    801fb5 <vprintfmt+0xdb>
            width = MAX(0, width);
  802009:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  80200c:	85 c9                	test   %ecx,%ecx
  80200e:	b8 00 00 00 00       	mov    $0x0,%eax
  802013:	0f 49 c1             	cmovns %ecx,%eax
  802016:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  802019:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80201c:	e9 32 ff ff ff       	jmp    801f53 <vprintfmt+0x79>
            lflag++;
  802021:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  802024:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  802027:	e9 27 ff ff ff       	jmp    801f53 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  80202c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80202f:	83 f8 2f             	cmp    $0x2f,%eax
  802032:	77 19                	ja     80204d <vprintfmt+0x173>
  802034:	89 c2                	mov    %eax,%edx
  802036:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80203a:	83 c0 08             	add    $0x8,%eax
  80203d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802040:	8b 3a                	mov    (%rdx),%edi
  802042:	4c 89 ee             	mov    %r13,%rsi
  802045:	41 ff d6             	call   *%r14
            break;
  802048:	e9 c2 fe ff ff       	jmp    801f0f <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  80204d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802051:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802055:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802059:	eb e5                	jmp    802040 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  80205b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80205e:	83 f8 2f             	cmp    $0x2f,%eax
  802061:	77 5a                	ja     8020bd <vprintfmt+0x1e3>
  802063:	89 c2                	mov    %eax,%edx
  802065:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802069:	83 c0 08             	add    $0x8,%eax
  80206c:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  80206f:	8b 02                	mov    (%rdx),%eax
  802071:	89 c1                	mov    %eax,%ecx
  802073:	f7 d9                	neg    %ecx
  802075:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  802078:	83 f9 13             	cmp    $0x13,%ecx
  80207b:	7f 4e                	jg     8020cb <vprintfmt+0x1f1>
  80207d:	48 63 c1             	movslq %ecx,%rax
  802080:	48 ba 20 36 80 00 00 	movabs $0x803620,%rdx
  802087:	00 00 00 
  80208a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80208e:	48 85 c0             	test   %rax,%rax
  802091:	74 38                	je     8020cb <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  802093:	48 89 c1             	mov    %rax,%rcx
  802096:	48 ba 80 30 80 00 00 	movabs $0x803080,%rdx
  80209d:	00 00 00 
  8020a0:	4c 89 ee             	mov    %r13,%rsi
  8020a3:	4c 89 f7             	mov    %r14,%rdi
  8020a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ab:	49 b8 99 1e 80 00 00 	movabs $0x801e99,%r8
  8020b2:	00 00 00 
  8020b5:	41 ff d0             	call   *%r8
  8020b8:	e9 52 fe ff ff       	jmp    801f0f <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8020bd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8020c1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8020c5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020c9:	eb a4                	jmp    80206f <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8020cb:	48 ba da 30 80 00 00 	movabs $0x8030da,%rdx
  8020d2:	00 00 00 
  8020d5:	4c 89 ee             	mov    %r13,%rsi
  8020d8:	4c 89 f7             	mov    %r14,%rdi
  8020db:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e0:	49 b8 99 1e 80 00 00 	movabs $0x801e99,%r8
  8020e7:	00 00 00 
  8020ea:	41 ff d0             	call   *%r8
  8020ed:	e9 1d fe ff ff       	jmp    801f0f <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8020f2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020f5:	83 f8 2f             	cmp    $0x2f,%eax
  8020f8:	77 6c                	ja     802166 <vprintfmt+0x28c>
  8020fa:	89 c2                	mov    %eax,%edx
  8020fc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802100:	83 c0 08             	add    $0x8,%eax
  802103:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802106:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  802109:	48 85 d2             	test   %rdx,%rdx
  80210c:	48 b8 d3 30 80 00 00 	movabs $0x8030d3,%rax
  802113:	00 00 00 
  802116:	48 0f 45 c2          	cmovne %rdx,%rax
  80211a:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  80211e:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  802122:	7e 06                	jle    80212a <vprintfmt+0x250>
  802124:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  802128:	75 4a                	jne    802174 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80212a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80212e:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802132:	0f b6 00             	movzbl (%rax),%eax
  802135:	84 c0                	test   %al,%al
  802137:	0f 85 9a 00 00 00    	jne    8021d7 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  80213d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802140:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  802144:	85 c0                	test   %eax,%eax
  802146:	0f 8e c3 fd ff ff    	jle    801f0f <vprintfmt+0x35>
  80214c:	4c 89 ee             	mov    %r13,%rsi
  80214f:	bf 20 00 00 00       	mov    $0x20,%edi
  802154:	41 ff d6             	call   *%r14
  802157:	41 83 ec 01          	sub    $0x1,%r12d
  80215b:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  80215f:	75 eb                	jne    80214c <vprintfmt+0x272>
  802161:	e9 a9 fd ff ff       	jmp    801f0f <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  802166:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80216a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80216e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802172:	eb 92                	jmp    802106 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  802174:	49 63 f7             	movslq %r15d,%rsi
  802177:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80217b:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  802182:	00 00 00 
  802185:	ff d0                	call   *%rax
  802187:	48 89 c2             	mov    %rax,%rdx
  80218a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80218d:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80218f:	8d 70 ff             	lea    -0x1(%rax),%esi
  802192:	89 75 ac             	mov    %esi,-0x54(%rbp)
  802195:	85 c0                	test   %eax,%eax
  802197:	7e 91                	jle    80212a <vprintfmt+0x250>
  802199:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80219e:	4c 89 ee             	mov    %r13,%rsi
  8021a1:	44 89 e7             	mov    %r12d,%edi
  8021a4:	41 ff d6             	call   *%r14
  8021a7:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8021ab:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8021ae:	83 f8 ff             	cmp    $0xffffffff,%eax
  8021b1:	75 eb                	jne    80219e <vprintfmt+0x2c4>
  8021b3:	e9 72 ff ff ff       	jmp    80212a <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8021b8:	0f b6 f8             	movzbl %al,%edi
  8021bb:	4c 89 ee             	mov    %r13,%rsi
  8021be:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8021c1:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8021c5:	49 83 c4 01          	add    $0x1,%r12
  8021c9:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  8021cf:	84 c0                	test   %al,%al
  8021d1:	0f 84 66 ff ff ff    	je     80213d <vprintfmt+0x263>
  8021d7:	45 85 ff             	test   %r15d,%r15d
  8021da:	78 0a                	js     8021e6 <vprintfmt+0x30c>
  8021dc:	41 83 ef 01          	sub    $0x1,%r15d
  8021e0:	0f 88 57 ff ff ff    	js     80213d <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8021e6:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8021ea:	74 cc                	je     8021b8 <vprintfmt+0x2de>
  8021ec:	8d 50 e0             	lea    -0x20(%rax),%edx
  8021ef:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8021f4:	80 fa 5e             	cmp    $0x5e,%dl
  8021f7:	77 c2                	ja     8021bb <vprintfmt+0x2e1>
  8021f9:	eb bd                	jmp    8021b8 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8021fb:	40 84 f6             	test   %sil,%sil
  8021fe:	75 26                	jne    802226 <vprintfmt+0x34c>
    switch (lflag) {
  802200:	85 d2                	test   %edx,%edx
  802202:	74 59                	je     80225d <vprintfmt+0x383>
  802204:	83 fa 01             	cmp    $0x1,%edx
  802207:	74 7b                	je     802284 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  802209:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80220c:	83 f8 2f             	cmp    $0x2f,%eax
  80220f:	0f 87 96 00 00 00    	ja     8022ab <vprintfmt+0x3d1>
  802215:	89 c2                	mov    %eax,%edx
  802217:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80221b:	83 c0 08             	add    $0x8,%eax
  80221e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802221:	4c 8b 22             	mov    (%rdx),%r12
  802224:	eb 17                	jmp    80223d <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  802226:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802229:	83 f8 2f             	cmp    $0x2f,%eax
  80222c:	77 21                	ja     80224f <vprintfmt+0x375>
  80222e:	89 c2                	mov    %eax,%edx
  802230:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802234:	83 c0 08             	add    $0x8,%eax
  802237:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80223a:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  80223d:	4d 85 e4             	test   %r12,%r12
  802240:	78 7a                	js     8022bc <vprintfmt+0x3e2>
            num = i;
  802242:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  802245:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80224a:	e9 50 02 00 00       	jmp    80249f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80224f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802253:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802257:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80225b:	eb dd                	jmp    80223a <vprintfmt+0x360>
        return va_arg(*ap, int);
  80225d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802260:	83 f8 2f             	cmp    $0x2f,%eax
  802263:	77 11                	ja     802276 <vprintfmt+0x39c>
  802265:	89 c2                	mov    %eax,%edx
  802267:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80226b:	83 c0 08             	add    $0x8,%eax
  80226e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802271:	4c 63 22             	movslq (%rdx),%r12
  802274:	eb c7                	jmp    80223d <vprintfmt+0x363>
  802276:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80227a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80227e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802282:	eb ed                	jmp    802271 <vprintfmt+0x397>
        return va_arg(*ap, long);
  802284:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802287:	83 f8 2f             	cmp    $0x2f,%eax
  80228a:	77 11                	ja     80229d <vprintfmt+0x3c3>
  80228c:	89 c2                	mov    %eax,%edx
  80228e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802292:	83 c0 08             	add    $0x8,%eax
  802295:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802298:	4c 8b 22             	mov    (%rdx),%r12
  80229b:	eb a0                	jmp    80223d <vprintfmt+0x363>
  80229d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8022a1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8022a5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022a9:	eb ed                	jmp    802298 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  8022ab:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8022af:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8022b3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022b7:	e9 65 ff ff ff       	jmp    802221 <vprintfmt+0x347>
                putch('-', put_arg);
  8022bc:	4c 89 ee             	mov    %r13,%rsi
  8022bf:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8022c4:	41 ff d6             	call   *%r14
                i = -i;
  8022c7:	49 f7 dc             	neg    %r12
  8022ca:	e9 73 ff ff ff       	jmp    802242 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  8022cf:	40 84 f6             	test   %sil,%sil
  8022d2:	75 32                	jne    802306 <vprintfmt+0x42c>
    switch (lflag) {
  8022d4:	85 d2                	test   %edx,%edx
  8022d6:	74 5d                	je     802335 <vprintfmt+0x45b>
  8022d8:	83 fa 01             	cmp    $0x1,%edx
  8022db:	0f 84 82 00 00 00    	je     802363 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8022e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022e4:	83 f8 2f             	cmp    $0x2f,%eax
  8022e7:	0f 87 a5 00 00 00    	ja     802392 <vprintfmt+0x4b8>
  8022ed:	89 c2                	mov    %eax,%edx
  8022ef:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022f3:	83 c0 08             	add    $0x8,%eax
  8022f6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022f9:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  802301:	e9 99 01 00 00       	jmp    80249f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  802306:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802309:	83 f8 2f             	cmp    $0x2f,%eax
  80230c:	77 19                	ja     802327 <vprintfmt+0x44d>
  80230e:	89 c2                	mov    %eax,%edx
  802310:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802314:	83 c0 08             	add    $0x8,%eax
  802317:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80231a:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80231d:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802322:	e9 78 01 00 00       	jmp    80249f <vprintfmt+0x5c5>
  802327:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80232b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80232f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802333:	eb e5                	jmp    80231a <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  802335:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802338:	83 f8 2f             	cmp    $0x2f,%eax
  80233b:	77 18                	ja     802355 <vprintfmt+0x47b>
  80233d:	89 c2                	mov    %eax,%edx
  80233f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802343:	83 c0 08             	add    $0x8,%eax
  802346:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802349:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  80234b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802350:	e9 4a 01 00 00       	jmp    80249f <vprintfmt+0x5c5>
  802355:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802359:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80235d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802361:	eb e6                	jmp    802349 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  802363:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802366:	83 f8 2f             	cmp    $0x2f,%eax
  802369:	77 19                	ja     802384 <vprintfmt+0x4aa>
  80236b:	89 c2                	mov    %eax,%edx
  80236d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802371:	83 c0 08             	add    $0x8,%eax
  802374:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802377:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80237a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80237f:	e9 1b 01 00 00       	jmp    80249f <vprintfmt+0x5c5>
  802384:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802388:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80238c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802390:	eb e5                	jmp    802377 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  802392:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802396:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80239a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80239e:	e9 56 ff ff ff       	jmp    8022f9 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  8023a3:	40 84 f6             	test   %sil,%sil
  8023a6:	75 2e                	jne    8023d6 <vprintfmt+0x4fc>
    switch (lflag) {
  8023a8:	85 d2                	test   %edx,%edx
  8023aa:	74 59                	je     802405 <vprintfmt+0x52b>
  8023ac:	83 fa 01             	cmp    $0x1,%edx
  8023af:	74 7f                	je     802430 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  8023b1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023b4:	83 f8 2f             	cmp    $0x2f,%eax
  8023b7:	0f 87 9f 00 00 00    	ja     80245c <vprintfmt+0x582>
  8023bd:	89 c2                	mov    %eax,%edx
  8023bf:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023c3:	83 c0 08             	add    $0x8,%eax
  8023c6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023c9:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023cc:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8023d1:	e9 c9 00 00 00       	jmp    80249f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8023d6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023d9:	83 f8 2f             	cmp    $0x2f,%eax
  8023dc:	77 19                	ja     8023f7 <vprintfmt+0x51d>
  8023de:	89 c2                	mov    %eax,%edx
  8023e0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023e4:	83 c0 08             	add    $0x8,%eax
  8023e7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023ea:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023ed:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8023f2:	e9 a8 00 00 00       	jmp    80249f <vprintfmt+0x5c5>
  8023f7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023fb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023ff:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802403:	eb e5                	jmp    8023ea <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  802405:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802408:	83 f8 2f             	cmp    $0x2f,%eax
  80240b:	77 15                	ja     802422 <vprintfmt+0x548>
  80240d:	89 c2                	mov    %eax,%edx
  80240f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802413:	83 c0 08             	add    $0x8,%eax
  802416:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802419:	8b 12                	mov    (%rdx),%edx
            base = 8;
  80241b:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  802420:	eb 7d                	jmp    80249f <vprintfmt+0x5c5>
  802422:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802426:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80242a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80242e:	eb e9                	jmp    802419 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  802430:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802433:	83 f8 2f             	cmp    $0x2f,%eax
  802436:	77 16                	ja     80244e <vprintfmt+0x574>
  802438:	89 c2                	mov    %eax,%edx
  80243a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80243e:	83 c0 08             	add    $0x8,%eax
  802441:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802444:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  802447:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  80244c:	eb 51                	jmp    80249f <vprintfmt+0x5c5>
  80244e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802452:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802456:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80245a:	eb e8                	jmp    802444 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  80245c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802460:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802464:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802468:	e9 5c ff ff ff       	jmp    8023c9 <vprintfmt+0x4ef>
            putch('0', put_arg);
  80246d:	4c 89 ee             	mov    %r13,%rsi
  802470:	bf 30 00 00 00       	mov    $0x30,%edi
  802475:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  802478:	4c 89 ee             	mov    %r13,%rsi
  80247b:	bf 78 00 00 00       	mov    $0x78,%edi
  802480:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  802483:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802486:	83 f8 2f             	cmp    $0x2f,%eax
  802489:	77 47                	ja     8024d2 <vprintfmt+0x5f8>
  80248b:	89 c2                	mov    %eax,%edx
  80248d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802491:	83 c0 08             	add    $0x8,%eax
  802494:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802497:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80249a:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80249f:	48 83 ec 08          	sub    $0x8,%rsp
  8024a3:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  8024a7:	0f 94 c0             	sete   %al
  8024aa:	0f b6 c0             	movzbl %al,%eax
  8024ad:	50                   	push   %rax
  8024ae:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  8024b3:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8024b7:	4c 89 ee             	mov    %r13,%rsi
  8024ba:	4c 89 f7             	mov    %r14,%rdi
  8024bd:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  8024c4:	00 00 00 
  8024c7:	ff d0                	call   *%rax
            break;
  8024c9:	48 83 c4 10          	add    $0x10,%rsp
  8024cd:	e9 3d fa ff ff       	jmp    801f0f <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  8024d2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024d6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8024da:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024de:	eb b7                	jmp    802497 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  8024e0:	40 84 f6             	test   %sil,%sil
  8024e3:	75 2b                	jne    802510 <vprintfmt+0x636>
    switch (lflag) {
  8024e5:	85 d2                	test   %edx,%edx
  8024e7:	74 56                	je     80253f <vprintfmt+0x665>
  8024e9:	83 fa 01             	cmp    $0x1,%edx
  8024ec:	74 7f                	je     80256d <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  8024ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024f1:	83 f8 2f             	cmp    $0x2f,%eax
  8024f4:	0f 87 a2 00 00 00    	ja     80259c <vprintfmt+0x6c2>
  8024fa:	89 c2                	mov    %eax,%edx
  8024fc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802500:	83 c0 08             	add    $0x8,%eax
  802503:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802506:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802509:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  80250e:	eb 8f                	jmp    80249f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  802510:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802513:	83 f8 2f             	cmp    $0x2f,%eax
  802516:	77 19                	ja     802531 <vprintfmt+0x657>
  802518:	89 c2                	mov    %eax,%edx
  80251a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80251e:	83 c0 08             	add    $0x8,%eax
  802521:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802524:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802527:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80252c:	e9 6e ff ff ff       	jmp    80249f <vprintfmt+0x5c5>
  802531:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802535:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802539:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80253d:	eb e5                	jmp    802524 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  80253f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802542:	83 f8 2f             	cmp    $0x2f,%eax
  802545:	77 18                	ja     80255f <vprintfmt+0x685>
  802547:	89 c2                	mov    %eax,%edx
  802549:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80254d:	83 c0 08             	add    $0x8,%eax
  802550:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802553:	8b 12                	mov    (%rdx),%edx
            base = 16;
  802555:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  80255a:	e9 40 ff ff ff       	jmp    80249f <vprintfmt+0x5c5>
  80255f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802563:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802567:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80256b:	eb e6                	jmp    802553 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  80256d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802570:	83 f8 2f             	cmp    $0x2f,%eax
  802573:	77 19                	ja     80258e <vprintfmt+0x6b4>
  802575:	89 c2                	mov    %eax,%edx
  802577:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80257b:	83 c0 08             	add    $0x8,%eax
  80257e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802581:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802584:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  802589:	e9 11 ff ff ff       	jmp    80249f <vprintfmt+0x5c5>
  80258e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802592:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802596:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80259a:	eb e5                	jmp    802581 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  80259c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025a0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8025a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8025a8:	e9 59 ff ff ff       	jmp    802506 <vprintfmt+0x62c>
            putch(ch, put_arg);
  8025ad:	4c 89 ee             	mov    %r13,%rsi
  8025b0:	bf 25 00 00 00       	mov    $0x25,%edi
  8025b5:	41 ff d6             	call   *%r14
            break;
  8025b8:	e9 52 f9 ff ff       	jmp    801f0f <vprintfmt+0x35>
            putch('%', put_arg);
  8025bd:	4c 89 ee             	mov    %r13,%rsi
  8025c0:	bf 25 00 00 00       	mov    $0x25,%edi
  8025c5:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  8025c8:	48 83 eb 01          	sub    $0x1,%rbx
  8025cc:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  8025d0:	75 f6                	jne    8025c8 <vprintfmt+0x6ee>
  8025d2:	e9 38 f9 ff ff       	jmp    801f0f <vprintfmt+0x35>
}
  8025d7:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8025db:	5b                   	pop    %rbx
  8025dc:	41 5c                	pop    %r12
  8025de:	41 5d                	pop    %r13
  8025e0:	41 5e                	pop    %r14
  8025e2:	41 5f                	pop    %r15
  8025e4:	5d                   	pop    %rbp
  8025e5:	c3                   	ret

00000000008025e6 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  8025e6:	f3 0f 1e fa          	endbr64
  8025ea:	55                   	push   %rbp
  8025eb:	48 89 e5             	mov    %rsp,%rbp
  8025ee:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  8025f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025f6:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  8025fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8025ff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  802606:	48 85 ff             	test   %rdi,%rdi
  802609:	74 2b                	je     802636 <vsnprintf+0x50>
  80260b:	48 85 f6             	test   %rsi,%rsi
  80260e:	74 26                	je     802636 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  802610:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802614:	48 bf 7d 1e 80 00 00 	movabs $0x801e7d,%rdi
  80261b:	00 00 00 
  80261e:	48 b8 da 1e 80 00 00 	movabs $0x801eda,%rax
  802625:	00 00 00 
  802628:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  80262a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262e:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  802631:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802634:	c9                   	leave
  802635:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  802636:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80263b:	eb f7                	jmp    802634 <vsnprintf+0x4e>

000000000080263d <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  80263d:	f3 0f 1e fa          	endbr64
  802641:	55                   	push   %rbp
  802642:	48 89 e5             	mov    %rsp,%rbp
  802645:	48 83 ec 50          	sub    $0x50,%rsp
  802649:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80264d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802651:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802655:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80265c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802660:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802664:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802668:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  80266c:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  802670:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  802677:	00 00 00 
  80267a:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  80267c:	c9                   	leave
  80267d:	c3                   	ret

000000000080267e <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  80267e:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  802682:	80 3f 00             	cmpb   $0x0,(%rdi)
  802685:	74 10                	je     802697 <strlen+0x19>
    size_t n = 0;
  802687:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  80268c:	48 83 c0 01          	add    $0x1,%rax
  802690:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  802694:	75 f6                	jne    80268c <strlen+0xe>
  802696:	c3                   	ret
    size_t n = 0;
  802697:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  80269c:	c3                   	ret

000000000080269d <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  80269d:	f3 0f 1e fa          	endbr64
  8026a1:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  8026a4:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  8026a9:	48 85 f6             	test   %rsi,%rsi
  8026ac:	74 10                	je     8026be <strnlen+0x21>
  8026ae:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  8026b2:	74 0b                	je     8026bf <strnlen+0x22>
  8026b4:	48 83 c2 01          	add    $0x1,%rdx
  8026b8:	48 39 d0             	cmp    %rdx,%rax
  8026bb:	75 f1                	jne    8026ae <strnlen+0x11>
  8026bd:	c3                   	ret
  8026be:	c3                   	ret
  8026bf:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  8026c2:	c3                   	ret

00000000008026c3 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  8026c3:	f3 0f 1e fa          	endbr64
  8026c7:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8026ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8026cf:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  8026d3:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  8026d6:	48 83 c2 01          	add    $0x1,%rdx
  8026da:	84 c9                	test   %cl,%cl
  8026dc:	75 f1                	jne    8026cf <strcpy+0xc>
        ;
    return res;
}
  8026de:	c3                   	ret

00000000008026df <strcat>:

char *
strcat(char *dst, const char *src) {
  8026df:	f3 0f 1e fa          	endbr64
  8026e3:	55                   	push   %rbp
  8026e4:	48 89 e5             	mov    %rsp,%rbp
  8026e7:	41 54                	push   %r12
  8026e9:	53                   	push   %rbx
  8026ea:	48 89 fb             	mov    %rdi,%rbx
  8026ed:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8026f0:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  8026f7:	00 00 00 
  8026fa:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  8026fc:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  802700:	4c 89 e6             	mov    %r12,%rsi
  802703:	48 b8 c3 26 80 00 00 	movabs $0x8026c3,%rax
  80270a:	00 00 00 
  80270d:	ff d0                	call   *%rax
    return dst;
}
  80270f:	48 89 d8             	mov    %rbx,%rax
  802712:	5b                   	pop    %rbx
  802713:	41 5c                	pop    %r12
  802715:	5d                   	pop    %rbp
  802716:	c3                   	ret

0000000000802717 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802717:	f3 0f 1e fa          	endbr64
  80271b:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  80271e:	48 85 d2             	test   %rdx,%rdx
  802721:	74 1f                	je     802742 <strncpy+0x2b>
  802723:	48 01 fa             	add    %rdi,%rdx
  802726:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  802729:	48 83 c1 01          	add    $0x1,%rcx
  80272d:	44 0f b6 06          	movzbl (%rsi),%r8d
  802731:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  802735:	41 80 f8 01          	cmp    $0x1,%r8b
  802739:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  80273d:	48 39 ca             	cmp    %rcx,%rdx
  802740:	75 e7                	jne    802729 <strncpy+0x12>
    }
    return ret;
}
  802742:	c3                   	ret

0000000000802743 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  802743:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  802747:	48 89 f8             	mov    %rdi,%rax
  80274a:	48 85 d2             	test   %rdx,%rdx
  80274d:	74 24                	je     802773 <strlcpy+0x30>
        while (--size > 0 && *src)
  80274f:	48 83 ea 01          	sub    $0x1,%rdx
  802753:	74 1b                	je     802770 <strlcpy+0x2d>
  802755:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802759:	0f b6 16             	movzbl (%rsi),%edx
  80275c:	84 d2                	test   %dl,%dl
  80275e:	74 10                	je     802770 <strlcpy+0x2d>
            *dst++ = *src++;
  802760:	48 83 c6 01          	add    $0x1,%rsi
  802764:	48 83 c0 01          	add    $0x1,%rax
  802768:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80276b:	48 39 c8             	cmp    %rcx,%rax
  80276e:	75 e9                	jne    802759 <strlcpy+0x16>
        *dst = '\0';
  802770:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  802773:	48 29 f8             	sub    %rdi,%rax
}
  802776:	c3                   	ret

0000000000802777 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  802777:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  80277b:	0f b6 07             	movzbl (%rdi),%eax
  80277e:	84 c0                	test   %al,%al
  802780:	74 13                	je     802795 <strcmp+0x1e>
  802782:	38 06                	cmp    %al,(%rsi)
  802784:	75 0f                	jne    802795 <strcmp+0x1e>
  802786:	48 83 c7 01          	add    $0x1,%rdi
  80278a:	48 83 c6 01          	add    $0x1,%rsi
  80278e:	0f b6 07             	movzbl (%rdi),%eax
  802791:	84 c0                	test   %al,%al
  802793:	75 ed                	jne    802782 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  802795:	0f b6 c0             	movzbl %al,%eax
  802798:	0f b6 16             	movzbl (%rsi),%edx
  80279b:	29 d0                	sub    %edx,%eax
}
  80279d:	c3                   	ret

000000000080279e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  80279e:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  8027a2:	48 85 d2             	test   %rdx,%rdx
  8027a5:	74 1f                	je     8027c6 <strncmp+0x28>
  8027a7:	0f b6 07             	movzbl (%rdi),%eax
  8027aa:	84 c0                	test   %al,%al
  8027ac:	74 1e                	je     8027cc <strncmp+0x2e>
  8027ae:	3a 06                	cmp    (%rsi),%al
  8027b0:	75 1a                	jne    8027cc <strncmp+0x2e>
  8027b2:	48 83 c7 01          	add    $0x1,%rdi
  8027b6:	48 83 c6 01          	add    $0x1,%rsi
  8027ba:	48 83 ea 01          	sub    $0x1,%rdx
  8027be:	75 e7                	jne    8027a7 <strncmp+0x9>

    if (!n) return 0;
  8027c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c5:	c3                   	ret
  8027c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cb:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  8027cc:	0f b6 07             	movzbl (%rdi),%eax
  8027cf:	0f b6 16             	movzbl (%rsi),%edx
  8027d2:	29 d0                	sub    %edx,%eax
}
  8027d4:	c3                   	ret

00000000008027d5 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  8027d5:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  8027d9:	0f b6 17             	movzbl (%rdi),%edx
  8027dc:	84 d2                	test   %dl,%dl
  8027de:	74 18                	je     8027f8 <strchr+0x23>
        if (*str == c) {
  8027e0:	0f be d2             	movsbl %dl,%edx
  8027e3:	39 f2                	cmp    %esi,%edx
  8027e5:	74 17                	je     8027fe <strchr+0x29>
    for (; *str; str++) {
  8027e7:	48 83 c7 01          	add    $0x1,%rdi
  8027eb:	0f b6 17             	movzbl (%rdi),%edx
  8027ee:	84 d2                	test   %dl,%dl
  8027f0:	75 ee                	jne    8027e0 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  8027f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f7:	c3                   	ret
  8027f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fd:	c3                   	ret
            return (char *)str;
  8027fe:	48 89 f8             	mov    %rdi,%rax
}
  802801:	c3                   	ret

0000000000802802 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  802802:	f3 0f 1e fa          	endbr64
  802806:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  802809:	0f b6 17             	movzbl (%rdi),%edx
  80280c:	84 d2                	test   %dl,%dl
  80280e:	74 13                	je     802823 <strfind+0x21>
  802810:	0f be d2             	movsbl %dl,%edx
  802813:	39 f2                	cmp    %esi,%edx
  802815:	74 0b                	je     802822 <strfind+0x20>
  802817:	48 83 c0 01          	add    $0x1,%rax
  80281b:	0f b6 10             	movzbl (%rax),%edx
  80281e:	84 d2                	test   %dl,%dl
  802820:	75 ee                	jne    802810 <strfind+0xe>
        ;
    return (char *)str;
}
  802822:	c3                   	ret
  802823:	c3                   	ret

0000000000802824 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  802824:	f3 0f 1e fa          	endbr64
  802828:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80282b:	48 89 f8             	mov    %rdi,%rax
  80282e:	48 f7 d8             	neg    %rax
  802831:	83 e0 07             	and    $0x7,%eax
  802834:	49 89 d1             	mov    %rdx,%r9
  802837:	49 29 c1             	sub    %rax,%r9
  80283a:	78 36                	js     802872 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  80283c:	40 0f b6 c6          	movzbl %sil,%eax
  802840:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  802847:	01 01 01 
  80284a:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80284e:	40 f6 c7 07          	test   $0x7,%dil
  802852:	75 38                	jne    80288c <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  802854:	4c 89 c9             	mov    %r9,%rcx
  802857:	48 c1 f9 03          	sar    $0x3,%rcx
  80285b:	74 0c                	je     802869 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80285d:	fc                   	cld
  80285e:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802861:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  802865:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  802869:	4d 85 c9             	test   %r9,%r9
  80286c:	75 45                	jne    8028b3 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  80286e:	4c 89 c0             	mov    %r8,%rax
  802871:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  802872:	48 85 d2             	test   %rdx,%rdx
  802875:	74 f7                	je     80286e <memset+0x4a>
  802877:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  80287a:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  80287d:	48 83 c0 01          	add    $0x1,%rax
  802881:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  802885:	48 39 c2             	cmp    %rax,%rdx
  802888:	75 f3                	jne    80287d <memset+0x59>
  80288a:	eb e2                	jmp    80286e <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  80288c:	40 f6 c7 01          	test   $0x1,%dil
  802890:	74 06                	je     802898 <memset+0x74>
  802892:	88 07                	mov    %al,(%rdi)
  802894:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  802898:	40 f6 c7 02          	test   $0x2,%dil
  80289c:	74 07                	je     8028a5 <memset+0x81>
  80289e:	66 89 07             	mov    %ax,(%rdi)
  8028a1:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8028a5:	40 f6 c7 04          	test   $0x4,%dil
  8028a9:	74 a9                	je     802854 <memset+0x30>
  8028ab:	89 07                	mov    %eax,(%rdi)
  8028ad:	48 83 c7 04          	add    $0x4,%rdi
  8028b1:	eb a1                	jmp    802854 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8028b3:	41 f6 c1 04          	test   $0x4,%r9b
  8028b7:	74 1b                	je     8028d4 <memset+0xb0>
  8028b9:	89 07                	mov    %eax,(%rdi)
  8028bb:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8028bf:	41 f6 c1 02          	test   $0x2,%r9b
  8028c3:	74 07                	je     8028cc <memset+0xa8>
  8028c5:	66 89 07             	mov    %ax,(%rdi)
  8028c8:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8028cc:	41 f6 c1 01          	test   $0x1,%r9b
  8028d0:	74 9c                	je     80286e <memset+0x4a>
  8028d2:	eb 06                	jmp    8028da <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8028d4:	41 f6 c1 02          	test   $0x2,%r9b
  8028d8:	75 eb                	jne    8028c5 <memset+0xa1>
        if (ni & 1) *ptr = k;
  8028da:	88 07                	mov    %al,(%rdi)
  8028dc:	eb 90                	jmp    80286e <memset+0x4a>

00000000008028de <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8028de:	f3 0f 1e fa          	endbr64
  8028e2:	48 89 f8             	mov    %rdi,%rax
  8028e5:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8028e8:	48 39 fe             	cmp    %rdi,%rsi
  8028eb:	73 3b                	jae    802928 <memmove+0x4a>
  8028ed:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8028f1:	48 39 d7             	cmp    %rdx,%rdi
  8028f4:	73 32                	jae    802928 <memmove+0x4a>
        s += n;
        d += n;
  8028f6:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028fa:	48 89 d6             	mov    %rdx,%rsi
  8028fd:	48 09 fe             	or     %rdi,%rsi
  802900:	48 09 ce             	or     %rcx,%rsi
  802903:	40 f6 c6 07          	test   $0x7,%sil
  802907:	75 12                	jne    80291b <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  802909:	48 83 ef 08          	sub    $0x8,%rdi
  80290d:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  802911:	48 c1 e9 03          	shr    $0x3,%rcx
  802915:	fd                   	std
  802916:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  802919:	fc                   	cld
  80291a:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80291b:	48 83 ef 01          	sub    $0x1,%rdi
  80291f:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  802923:	fd                   	std
  802924:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  802926:	eb f1                	jmp    802919 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802928:	48 89 f2             	mov    %rsi,%rdx
  80292b:	48 09 c2             	or     %rax,%rdx
  80292e:	48 09 ca             	or     %rcx,%rdx
  802931:	f6 c2 07             	test   $0x7,%dl
  802934:	75 0c                	jne    802942 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  802936:	48 c1 e9 03          	shr    $0x3,%rcx
  80293a:	48 89 c7             	mov    %rax,%rdi
  80293d:	fc                   	cld
  80293e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  802941:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  802942:	48 89 c7             	mov    %rax,%rdi
  802945:	fc                   	cld
  802946:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  802948:	c3                   	ret

0000000000802949 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  802949:	f3 0f 1e fa          	endbr64
  80294d:	55                   	push   %rbp
  80294e:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802951:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  802958:	00 00 00 
  80295b:	ff d0                	call   *%rax
}
  80295d:	5d                   	pop    %rbp
  80295e:	c3                   	ret

000000000080295f <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80295f:	f3 0f 1e fa          	endbr64
  802963:	55                   	push   %rbp
  802964:	48 89 e5             	mov    %rsp,%rbp
  802967:	41 57                	push   %r15
  802969:	41 56                	push   %r14
  80296b:	41 55                	push   %r13
  80296d:	41 54                	push   %r12
  80296f:	53                   	push   %rbx
  802970:	48 83 ec 08          	sub    $0x8,%rsp
  802974:	49 89 fe             	mov    %rdi,%r14
  802977:	49 89 f7             	mov    %rsi,%r15
  80297a:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  80297d:	48 89 f7             	mov    %rsi,%rdi
  802980:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802987:	00 00 00 
  80298a:	ff d0                	call   *%rax
  80298c:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80298f:	48 89 de             	mov    %rbx,%rsi
  802992:	4c 89 f7             	mov    %r14,%rdi
  802995:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  80299c:	00 00 00 
  80299f:	ff d0                	call   *%rax
  8029a1:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8029a4:	48 39 c3             	cmp    %rax,%rbx
  8029a7:	74 36                	je     8029df <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  8029a9:	48 89 d8             	mov    %rbx,%rax
  8029ac:	4c 29 e8             	sub    %r13,%rax
  8029af:	49 39 c4             	cmp    %rax,%r12
  8029b2:	73 31                	jae    8029e5 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  8029b4:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8029b9:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8029bd:	4c 89 fe             	mov    %r15,%rsi
  8029c0:	48 b8 49 29 80 00 00 	movabs $0x802949,%rax
  8029c7:	00 00 00 
  8029ca:	ff d0                	call   *%rax
    return dstlen + srclen;
  8029cc:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8029d0:	48 83 c4 08          	add    $0x8,%rsp
  8029d4:	5b                   	pop    %rbx
  8029d5:	41 5c                	pop    %r12
  8029d7:	41 5d                	pop    %r13
  8029d9:	41 5e                	pop    %r14
  8029db:	41 5f                	pop    %r15
  8029dd:	5d                   	pop    %rbp
  8029de:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  8029df:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  8029e3:	eb eb                	jmp    8029d0 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  8029e5:	48 83 eb 01          	sub    $0x1,%rbx
  8029e9:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8029ed:	48 89 da             	mov    %rbx,%rdx
  8029f0:	4c 89 fe             	mov    %r15,%rsi
  8029f3:	48 b8 49 29 80 00 00 	movabs $0x802949,%rax
  8029fa:	00 00 00 
  8029fd:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8029ff:	49 01 de             	add    %rbx,%r14
  802a02:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  802a07:	eb c3                	jmp    8029cc <strlcat+0x6d>

0000000000802a09 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  802a09:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  802a0d:	48 85 d2             	test   %rdx,%rdx
  802a10:	74 2d                	je     802a3f <memcmp+0x36>
  802a12:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  802a17:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  802a1b:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  802a20:	44 38 c1             	cmp    %r8b,%cl
  802a23:	75 0f                	jne    802a34 <memcmp+0x2b>
    while (n-- > 0) {
  802a25:	48 83 c0 01          	add    $0x1,%rax
  802a29:	48 39 c2             	cmp    %rax,%rdx
  802a2c:	75 e9                	jne    802a17 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  802a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a33:	c3                   	ret
            return (int)*s1 - (int)*s2;
  802a34:	0f b6 c1             	movzbl %cl,%eax
  802a37:	45 0f b6 c0          	movzbl %r8b,%r8d
  802a3b:	44 29 c0             	sub    %r8d,%eax
  802a3e:	c3                   	ret
    return 0;
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a44:	c3                   	ret

0000000000802a45 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  802a45:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  802a49:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802a4d:	48 39 c7             	cmp    %rax,%rdi
  802a50:	73 0f                	jae    802a61 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802a52:	40 38 37             	cmp    %sil,(%rdi)
  802a55:	74 0e                	je     802a65 <memfind+0x20>
    for (; src < end; src++) {
  802a57:	48 83 c7 01          	add    $0x1,%rdi
  802a5b:	48 39 f8             	cmp    %rdi,%rax
  802a5e:	75 f2                	jne    802a52 <memfind+0xd>
  802a60:	c3                   	ret
  802a61:	48 89 f8             	mov    %rdi,%rax
  802a64:	c3                   	ret
  802a65:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802a68:	c3                   	ret

0000000000802a69 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802a69:	f3 0f 1e fa          	endbr64
  802a6d:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802a70:	0f b6 37             	movzbl (%rdi),%esi
  802a73:	40 80 fe 20          	cmp    $0x20,%sil
  802a77:	74 06                	je     802a7f <strtol+0x16>
  802a79:	40 80 fe 09          	cmp    $0x9,%sil
  802a7d:	75 13                	jne    802a92 <strtol+0x29>
  802a7f:	48 83 c7 01          	add    $0x1,%rdi
  802a83:	0f b6 37             	movzbl (%rdi),%esi
  802a86:	40 80 fe 20          	cmp    $0x20,%sil
  802a8a:	74 f3                	je     802a7f <strtol+0x16>
  802a8c:	40 80 fe 09          	cmp    $0x9,%sil
  802a90:	74 ed                	je     802a7f <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802a92:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802a95:	83 e0 fd             	and    $0xfffffffd,%eax
  802a98:	3c 01                	cmp    $0x1,%al
  802a9a:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a9e:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  802aa4:	75 0f                	jne    802ab5 <strtol+0x4c>
  802aa6:	80 3f 30             	cmpb   $0x30,(%rdi)
  802aa9:	74 14                	je     802abf <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802aab:	85 d2                	test   %edx,%edx
  802aad:	b8 0a 00 00 00       	mov    $0xa,%eax
  802ab2:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  802ab5:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  802aba:	4c 63 ca             	movslq %edx,%r9
  802abd:	eb 36                	jmp    802af5 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802abf:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  802ac3:	74 0f                	je     802ad4 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  802ac5:	85 d2                	test   %edx,%edx
  802ac7:	75 ec                	jne    802ab5 <strtol+0x4c>
        s++;
  802ac9:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  802acd:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  802ad2:	eb e1                	jmp    802ab5 <strtol+0x4c>
        s += 2;
  802ad4:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  802ad8:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  802add:	eb d6                	jmp    802ab5 <strtol+0x4c>
            dig -= '0';
  802adf:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  802ae2:	44 0f b6 c1          	movzbl %cl,%r8d
  802ae6:	41 39 d0             	cmp    %edx,%r8d
  802ae9:	7d 21                	jge    802b0c <strtol+0xa3>
        val = val * base + dig;
  802aeb:	49 0f af c1          	imul   %r9,%rax
  802aef:	0f b6 c9             	movzbl %cl,%ecx
  802af2:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  802af5:	48 83 c7 01          	add    $0x1,%rdi
  802af9:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  802afd:	80 f9 39             	cmp    $0x39,%cl
  802b00:	76 dd                	jbe    802adf <strtol+0x76>
        else if (dig - 'a' < 27)
  802b02:	80 f9 7b             	cmp    $0x7b,%cl
  802b05:	77 05                	ja     802b0c <strtol+0xa3>
            dig -= 'a' - 10;
  802b07:	83 e9 57             	sub    $0x57,%ecx
  802b0a:	eb d6                	jmp    802ae2 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  802b0c:	4d 85 d2             	test   %r10,%r10
  802b0f:	74 03                	je     802b14 <strtol+0xab>
  802b11:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802b14:	48 89 c2             	mov    %rax,%rdx
  802b17:	48 f7 da             	neg    %rdx
  802b1a:	40 80 fe 2d          	cmp    $0x2d,%sil
  802b1e:	48 0f 44 c2          	cmove  %rdx,%rax
}
  802b22:	c3                   	ret

0000000000802b23 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802b23:	f3 0f 1e fa          	endbr64
  802b27:	55                   	push   %rbp
  802b28:	48 89 e5             	mov    %rsp,%rbp
  802b2b:	41 54                	push   %r12
  802b2d:	53                   	push   %rbx
  802b2e:	48 89 fb             	mov    %rdi,%rbx
  802b31:	48 89 f7             	mov    %rsi,%rdi
  802b34:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b37:	48 85 f6             	test   %rsi,%rsi
  802b3a:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b41:	00 00 00 
  802b44:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b48:	be 00 10 00 00       	mov    $0x1000,%esi
  802b4d:	48 b8 15 06 80 00 00 	movabs $0x800615,%rax
  802b54:	00 00 00 
  802b57:	ff d0                	call   *%rax
    if (res < 0) {
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	78 45                	js     802ba2 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b5d:	48 85 db             	test   %rbx,%rbx
  802b60:	74 12                	je     802b74 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b62:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b69:	00 00 00 
  802b6c:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b72:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b74:	4d 85 e4             	test   %r12,%r12
  802b77:	74 14                	je     802b8d <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b79:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b80:	00 00 00 
  802b83:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b89:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b8d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b94:	00 00 00 
  802b97:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b9d:	5b                   	pop    %rbx
  802b9e:	41 5c                	pop    %r12
  802ba0:	5d                   	pop    %rbp
  802ba1:	c3                   	ret
        if (from_env_store != NULL) {
  802ba2:	48 85 db             	test   %rbx,%rbx
  802ba5:	74 06                	je     802bad <ipc_recv+0x8a>
            *from_env_store = 0;
  802ba7:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802bad:	4d 85 e4             	test   %r12,%r12
  802bb0:	74 eb                	je     802b9d <ipc_recv+0x7a>
            *perm_store = 0;
  802bb2:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802bb9:	00 
  802bba:	eb e1                	jmp    802b9d <ipc_recv+0x7a>

0000000000802bbc <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802bbc:	f3 0f 1e fa          	endbr64
  802bc0:	55                   	push   %rbp
  802bc1:	48 89 e5             	mov    %rsp,%rbp
  802bc4:	41 57                	push   %r15
  802bc6:	41 56                	push   %r14
  802bc8:	41 55                	push   %r13
  802bca:	41 54                	push   %r12
  802bcc:	53                   	push   %rbx
  802bcd:	48 83 ec 18          	sub    $0x18,%rsp
  802bd1:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802bd4:	48 89 d3             	mov    %rdx,%rbx
  802bd7:	49 89 cc             	mov    %rcx,%r12
  802bda:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802bdd:	48 85 d2             	test   %rdx,%rdx
  802be0:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802be7:	00 00 00 
  802bea:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bee:	89 f0                	mov    %esi,%eax
  802bf0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802bf4:	48 89 da             	mov    %rbx,%rdx
  802bf7:	48 89 c6             	mov    %rax,%rsi
  802bfa:	48 b8 e5 05 80 00 00 	movabs $0x8005e5,%rax
  802c01:	00 00 00 
  802c04:	ff d0                	call   *%rax
    while (res < 0) {
  802c06:	85 c0                	test   %eax,%eax
  802c08:	79 65                	jns    802c6f <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c0a:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c0d:	75 33                	jne    802c42 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802c0f:	49 bf 58 02 80 00 00 	movabs $0x800258,%r15
  802c16:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c19:	49 be e5 05 80 00 00 	movabs $0x8005e5,%r14
  802c20:	00 00 00 
        sys_yield();
  802c23:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c26:	45 89 e8             	mov    %r13d,%r8d
  802c29:	4c 89 e1             	mov    %r12,%rcx
  802c2c:	48 89 da             	mov    %rbx,%rdx
  802c2f:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802c33:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802c36:	41 ff d6             	call   *%r14
    while (res < 0) {
  802c39:	85 c0                	test   %eax,%eax
  802c3b:	79 32                	jns    802c6f <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c3d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c40:	74 e1                	je     802c23 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c42:	89 c1                	mov    %eax,%ecx
  802c44:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  802c4b:	00 00 00 
  802c4e:	be 42 00 00 00       	mov    $0x42,%esi
  802c53:	48 bf 4b 32 80 00 00 	movabs $0x80324b,%rdi
  802c5a:	00 00 00 
  802c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c62:	49 b8 1e 1c 80 00 00 	movabs $0x801c1e,%r8
  802c69:	00 00 00 
  802c6c:	41 ff d0             	call   *%r8
    }
}
  802c6f:	48 83 c4 18          	add    $0x18,%rsp
  802c73:	5b                   	pop    %rbx
  802c74:	41 5c                	pop    %r12
  802c76:	41 5d                	pop    %r13
  802c78:	41 5e                	pop    %r14
  802c7a:	41 5f                	pop    %r15
  802c7c:	5d                   	pop    %rbp
  802c7d:	c3                   	ret

0000000000802c7e <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c7e:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c82:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c87:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c8e:	00 00 00 
  802c91:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c95:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c99:	48 c1 e2 04          	shl    $0x4,%rdx
  802c9d:	48 01 ca             	add    %rcx,%rdx
  802ca0:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802ca6:	39 fa                	cmp    %edi,%edx
  802ca8:	74 12                	je     802cbc <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802caa:	48 83 c0 01          	add    $0x1,%rax
  802cae:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802cb4:	75 db                	jne    802c91 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cbb:	c3                   	ret
            return envs[i].env_id;
  802cbc:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802cc0:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802cc4:	48 c1 e2 04          	shl    $0x4,%rdx
  802cc8:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802ccf:	00 00 00 
  802cd2:	48 01 d0             	add    %rdx,%rax
  802cd5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cdb:	c3                   	ret

0000000000802cdc <__text_end>:
  802cdc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ce3:	00 00 00 
  802ce6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ced:	00 00 00 
  802cf0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cf7:	00 00 00 
  802cfa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d01:	00 00 00 
  802d04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d0b:	00 00 00 
  802d0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d15:	00 00 00 
  802d18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d1f:	00 00 00 
  802d22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d29:	00 00 00 
  802d2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d33:	00 00 00 
  802d36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d3d:	00 00 00 
  802d40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d47:	00 00 00 
  802d4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d51:	00 00 00 
  802d54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d5b:	00 00 00 
  802d5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d65:	00 00 00 
  802d68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d6f:	00 00 00 
  802d72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d79:	00 00 00 
  802d7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d83:	00 00 00 
  802d86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d8d:	00 00 00 
  802d90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d97:	00 00 00 
  802d9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802da1:	00 00 00 
  802da4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dab:	00 00 00 
  802dae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802db5:	00 00 00 
  802db8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dbf:	00 00 00 
  802dc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dc9:	00 00 00 
  802dcc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd3:	00 00 00 
  802dd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ddd:	00 00 00 
  802de0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de7:	00 00 00 
  802dea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df1:	00 00 00 
  802df4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dfb:	00 00 00 
  802dfe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e05:	00 00 00 
  802e08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e0f:	00 00 00 
  802e12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e19:	00 00 00 
  802e1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e23:	00 00 00 
  802e26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e2d:	00 00 00 
  802e30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e37:	00 00 00 
  802e3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e41:	00 00 00 
  802e44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e4b:	00 00 00 
  802e4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e55:	00 00 00 
  802e58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e5f:	00 00 00 
  802e62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e69:	00 00 00 
  802e6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e73:	00 00 00 
  802e76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e7d:	00 00 00 
  802e80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e87:	00 00 00 
  802e8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e91:	00 00 00 
  802e94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e9b:	00 00 00 
  802e9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea5:	00 00 00 
  802ea8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eaf:	00 00 00 
  802eb2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb9:	00 00 00 
  802ebc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec3:	00 00 00 
  802ec6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ecd:	00 00 00 
  802ed0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed7:	00 00 00 
  802eda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee1:	00 00 00 
  802ee4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eeb:	00 00 00 
  802eee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef5:	00 00 00 
  802ef8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eff:	00 00 00 
  802f02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f09:	00 00 00 
  802f0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f13:	00 00 00 
  802f16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f1d:	00 00 00 
  802f20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f27:	00 00 00 
  802f2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f31:	00 00 00 
  802f34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f3b:	00 00 00 
  802f3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f45:	00 00 00 
  802f48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f4f:	00 00 00 
  802f52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f59:	00 00 00 
  802f5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f63:	00 00 00 
  802f66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f6d:	00 00 00 
  802f70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f77:	00 00 00 
  802f7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f81:	00 00 00 
  802f84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f8b:	00 00 00 
  802f8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f95:	00 00 00 
  802f98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f9f:	00 00 00 
  802fa2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa9:	00 00 00 
  802fac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb3:	00 00 00 
  802fb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fbd:	00 00 00 
  802fc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc7:	00 00 00 
  802fca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd1:	00 00 00 
  802fd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fdb:	00 00 00 
  802fde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe5:	00 00 00 
  802fe8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fef:	00 00 00 
  802ff2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff9:	00 00 00 
  802ffc:	0f 1f 40 00          	nopl   0x0(%rax)
