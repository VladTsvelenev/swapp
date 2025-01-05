
obj/user/faultwrite:     file format elf64-x86-64


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
  80001e:	e8 12 00 00 00       	call   800035 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* Buggy program - faults with a write to location zero */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
#ifndef __clang_analyzer__
    *(volatile unsigned *)0 = 0;
  800029:	c7 04 25 00 00 00 00 	movl   $0x0,0x0
  800030:	00 00 00 00 
#endif
}
  800034:	c3                   	ret

0000000000800035 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800035:	f3 0f 1e fa          	endbr64
  800039:	55                   	push   %rbp
  80003a:	48 89 e5             	mov    %rsp,%rbp
  80003d:	41 56                	push   %r14
  80003f:	41 55                	push   %r13
  800041:	41 54                	push   %r12
  800043:	53                   	push   %rbx
  800044:	41 89 fd             	mov    %edi,%r13d
  800047:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80004a:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800051:	00 00 00 
  800054:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80005b:	00 00 00 
  80005e:	48 39 c2             	cmp    %rax,%rdx
  800061:	73 17                	jae    80007a <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800063:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800066:	49 89 c4             	mov    %rax,%r12
  800069:	48 83 c3 08          	add    $0x8,%rbx
  80006d:	b8 00 00 00 00       	mov    $0x0,%eax
  800072:	ff 53 f8             	call   *-0x8(%rbx)
  800075:	4c 39 e3             	cmp    %r12,%rbx
  800078:	72 ef                	jb     800069 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  80007a:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  800081:	00 00 00 
  800084:	ff d0                	call   *%rax
  800086:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80008f:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800093:	48 c1 e0 04          	shl    $0x4,%rax
  800097:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  80009e:	00 00 00 
  8000a1:	48 01 d0             	add    %rdx,%rax
  8000a4:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000ab:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000ae:	45 85 ed             	test   %r13d,%r13d
  8000b1:	7e 0d                	jle    8000c0 <libmain+0x8b>
  8000b3:	49 8b 06             	mov    (%r14),%rax
  8000b6:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000bd:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000c0:	4c 89 f6             	mov    %r14,%rsi
  8000c3:	44 89 ef             	mov    %r13d,%edi
  8000c6:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000d2:	48 b8 e7 00 80 00 00 	movabs $0x8000e7,%rax
  8000d9:	00 00 00 
  8000dc:	ff d0                	call   *%rax
#endif
}
  8000de:	5b                   	pop    %rbx
  8000df:	41 5c                	pop    %r12
  8000e1:	41 5d                	pop    %r13
  8000e3:	41 5e                	pop    %r14
  8000e5:	5d                   	pop    %rbp
  8000e6:	c3                   	ret

00000000008000e7 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000e7:	f3 0f 1e fa          	endbr64
  8000eb:	55                   	push   %rbp
  8000ec:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000ef:	48 b8 b9 08 80 00 00 	movabs $0x8008b9,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8000fb:	bf 00 00 00 00       	mov    $0x0,%edi
  800100:	48 b8 74 01 80 00 00 	movabs $0x800174,%rax
  800107:	00 00 00 
  80010a:	ff d0                	call   *%rax
}
  80010c:	5d                   	pop    %rbp
  80010d:	c3                   	ret

000000000080010e <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80010e:	f3 0f 1e fa          	endbr64
  800112:	55                   	push   %rbp
  800113:	48 89 e5             	mov    %rsp,%rbp
  800116:	53                   	push   %rbx
  800117:	48 89 fa             	mov    %rdi,%rdx
  80011a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80011d:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800122:	bb 00 00 00 00       	mov    $0x0,%ebx
  800127:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80012c:	be 00 00 00 00       	mov    $0x0,%esi
  800131:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800137:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800139:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80013d:	c9                   	leave
  80013e:	c3                   	ret

000000000080013f <sys_cgetc>:

int
sys_cgetc(void) {
  80013f:	f3 0f 1e fa          	endbr64
  800143:	55                   	push   %rbp
  800144:	48 89 e5             	mov    %rsp,%rbp
  800147:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800148:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80014d:	ba 00 00 00 00       	mov    $0x0,%edx
  800152:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800157:	bb 00 00 00 00       	mov    $0x0,%ebx
  80015c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800161:	be 00 00 00 00       	mov    $0x0,%esi
  800166:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80016c:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80016e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800172:	c9                   	leave
  800173:	c3                   	ret

0000000000800174 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800174:	f3 0f 1e fa          	endbr64
  800178:	55                   	push   %rbp
  800179:	48 89 e5             	mov    %rsp,%rbp
  80017c:	53                   	push   %rbx
  80017d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800181:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800184:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800189:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80018e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800193:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800198:	be 00 00 00 00       	mov    $0x0,%esi
  80019d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001a3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001a5:	48 85 c0             	test   %rax,%rax
  8001a8:	7f 06                	jg     8001b0 <sys_env_destroy+0x3c>
}
  8001aa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001ae:	c9                   	leave
  8001af:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001b0:	49 89 c0             	mov    %rax,%r8
  8001b3:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001b8:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8001bf:	00 00 00 
  8001c2:	be 26 00 00 00       	mov    $0x26,%esi
  8001c7:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8001ce:	00 00 00 
  8001d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d6:	49 b9 de 1b 80 00 00 	movabs $0x801bde,%r9
  8001dd:	00 00 00 
  8001e0:	41 ff d1             	call   *%r9

00000000008001e3 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001e3:	f3 0f 1e fa          	endbr64
  8001e7:	55                   	push   %rbp
  8001e8:	48 89 e5             	mov    %rsp,%rbp
  8001eb:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001ec:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8001f6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800200:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800205:	be 00 00 00 00       	mov    $0x0,%esi
  80020a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800210:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800212:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800216:	c9                   	leave
  800217:	c3                   	ret

0000000000800218 <sys_yield>:

void
sys_yield(void) {
  800218:	f3 0f 1e fa          	endbr64
  80021c:	55                   	push   %rbp
  80021d:	48 89 e5             	mov    %rsp,%rbp
  800220:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800221:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800226:	ba 00 00 00 00       	mov    $0x0,%edx
  80022b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800230:	bb 00 00 00 00       	mov    $0x0,%ebx
  800235:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80023a:	be 00 00 00 00       	mov    $0x0,%esi
  80023f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800245:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  800247:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80024b:	c9                   	leave
  80024c:	c3                   	ret

000000000080024d <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80024d:	f3 0f 1e fa          	endbr64
  800251:	55                   	push   %rbp
  800252:	48 89 e5             	mov    %rsp,%rbp
  800255:	53                   	push   %rbx
  800256:	48 89 fa             	mov    %rdi,%rdx
  800259:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80025c:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800261:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800268:	00 00 00 
  80026b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800270:	be 00 00 00 00       	mov    $0x0,%esi
  800275:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80027b:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80027d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800281:	c9                   	leave
  800282:	c3                   	ret

0000000000800283 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  800283:	f3 0f 1e fa          	endbr64
  800287:	55                   	push   %rbp
  800288:	48 89 e5             	mov    %rsp,%rbp
  80028b:	53                   	push   %rbx
  80028c:	49 89 f8             	mov    %rdi,%r8
  80028f:	48 89 d3             	mov    %rdx,%rbx
  800292:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  800295:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80029a:	4c 89 c2             	mov    %r8,%rdx
  80029d:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002a0:	be 00 00 00 00       	mov    $0x0,%esi
  8002a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002ab:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002ad:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002b1:	c9                   	leave
  8002b2:	c3                   	ret

00000000008002b3 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002b3:	f3 0f 1e fa          	endbr64
  8002b7:	55                   	push   %rbp
  8002b8:	48 89 e5             	mov    %rsp,%rbp
  8002bb:	53                   	push   %rbx
  8002bc:	48 83 ec 08          	sub    $0x8,%rsp
  8002c0:	89 f8                	mov    %edi,%eax
  8002c2:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002c5:	48 63 f9             	movslq %ecx,%rdi
  8002c8:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002cb:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002d0:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002d3:	be 00 00 00 00       	mov    $0x0,%esi
  8002d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002de:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002e0:	48 85 c0             	test   %rax,%rax
  8002e3:	7f 06                	jg     8002eb <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002e5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002e9:	c9                   	leave
  8002ea:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002eb:	49 89 c0             	mov    %rax,%r8
  8002ee:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002f3:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8002fa:	00 00 00 
  8002fd:	be 26 00 00 00       	mov    $0x26,%esi
  800302:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800309:	00 00 00 
  80030c:	b8 00 00 00 00       	mov    $0x0,%eax
  800311:	49 b9 de 1b 80 00 00 	movabs $0x801bde,%r9
  800318:	00 00 00 
  80031b:	41 ff d1             	call   *%r9

000000000080031e <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80031e:	f3 0f 1e fa          	endbr64
  800322:	55                   	push   %rbp
  800323:	48 89 e5             	mov    %rsp,%rbp
  800326:	53                   	push   %rbx
  800327:	48 83 ec 08          	sub    $0x8,%rsp
  80032b:	89 f8                	mov    %edi,%eax
  80032d:	49 89 f2             	mov    %rsi,%r10
  800330:	48 89 cf             	mov    %rcx,%rdi
  800333:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  800336:	48 63 da             	movslq %edx,%rbx
  800339:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80033c:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800341:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800344:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  800347:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800349:	48 85 c0             	test   %rax,%rax
  80034c:	7f 06                	jg     800354 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80034e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800352:	c9                   	leave
  800353:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800354:	49 89 c0             	mov    %rax,%r8
  800357:	b9 05 00 00 00       	mov    $0x5,%ecx
  80035c:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800363:	00 00 00 
  800366:	be 26 00 00 00       	mov    $0x26,%esi
  80036b:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800372:	00 00 00 
  800375:	b8 00 00 00 00       	mov    $0x0,%eax
  80037a:	49 b9 de 1b 80 00 00 	movabs $0x801bde,%r9
  800381:	00 00 00 
  800384:	41 ff d1             	call   *%r9

0000000000800387 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  800387:	f3 0f 1e fa          	endbr64
  80038b:	55                   	push   %rbp
  80038c:	48 89 e5             	mov    %rsp,%rbp
  80038f:	53                   	push   %rbx
  800390:	48 83 ec 08          	sub    $0x8,%rsp
  800394:	49 89 f9             	mov    %rdi,%r9
  800397:	89 f0                	mov    %esi,%eax
  800399:	48 89 d3             	mov    %rdx,%rbx
  80039c:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80039f:	49 63 f0             	movslq %r8d,%rsi
  8003a2:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8003a5:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8003aa:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003ad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003b3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003b5:	48 85 c0             	test   %rax,%rax
  8003b8:	7f 06                	jg     8003c0 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8003ba:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003be:	c9                   	leave
  8003bf:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003c0:	49 89 c0             	mov    %rax,%r8
  8003c3:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003c8:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8003cf:	00 00 00 
  8003d2:	be 26 00 00 00       	mov    $0x26,%esi
  8003d7:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8003de:	00 00 00 
  8003e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e6:	49 b9 de 1b 80 00 00 	movabs $0x801bde,%r9
  8003ed:	00 00 00 
  8003f0:	41 ff d1             	call   *%r9

00000000008003f3 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8003f3:	f3 0f 1e fa          	endbr64
  8003f7:	55                   	push   %rbp
  8003f8:	48 89 e5             	mov    %rsp,%rbp
  8003fb:	53                   	push   %rbx
  8003fc:	48 83 ec 08          	sub    $0x8,%rsp
  800400:	48 89 f1             	mov    %rsi,%rcx
  800403:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  800406:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800409:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80040e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800413:	be 00 00 00 00       	mov    $0x0,%esi
  800418:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80041e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800420:	48 85 c0             	test   %rax,%rax
  800423:	7f 06                	jg     80042b <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  800425:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800429:	c9                   	leave
  80042a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80042b:	49 89 c0             	mov    %rax,%r8
  80042e:	b9 07 00 00 00       	mov    $0x7,%ecx
  800433:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80043a:	00 00 00 
  80043d:	be 26 00 00 00       	mov    $0x26,%esi
  800442:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800449:	00 00 00 
  80044c:	b8 00 00 00 00       	mov    $0x0,%eax
  800451:	49 b9 de 1b 80 00 00 	movabs $0x801bde,%r9
  800458:	00 00 00 
  80045b:	41 ff d1             	call   *%r9

000000000080045e <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80045e:	f3 0f 1e fa          	endbr64
  800462:	55                   	push   %rbp
  800463:	48 89 e5             	mov    %rsp,%rbp
  800466:	53                   	push   %rbx
  800467:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80046b:	48 63 ce             	movslq %esi,%rcx
  80046e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800471:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800476:	bb 00 00 00 00       	mov    $0x0,%ebx
  80047b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800480:	be 00 00 00 00       	mov    $0x0,%esi
  800485:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80048b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80048d:	48 85 c0             	test   %rax,%rax
  800490:	7f 06                	jg     800498 <sys_env_set_status+0x3a>
}
  800492:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800496:	c9                   	leave
  800497:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800498:	49 89 c0             	mov    %rax,%r8
  80049b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8004a0:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8004a7:	00 00 00 
  8004aa:	be 26 00 00 00       	mov    $0x26,%esi
  8004af:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8004b6:	00 00 00 
  8004b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004be:	49 b9 de 1b 80 00 00 	movabs $0x801bde,%r9
  8004c5:	00 00 00 
  8004c8:	41 ff d1             	call   *%r9

00000000008004cb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8004cb:	f3 0f 1e fa          	endbr64
  8004cf:	55                   	push   %rbp
  8004d0:	48 89 e5             	mov    %rsp,%rbp
  8004d3:	53                   	push   %rbx
  8004d4:	48 83 ec 08          	sub    $0x8,%rsp
  8004d8:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8004db:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004de:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004e8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004ed:	be 00 00 00 00       	mov    $0x0,%esi
  8004f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004f8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004fa:	48 85 c0             	test   %rax,%rax
  8004fd:	7f 06                	jg     800505 <sys_env_set_trapframe+0x3a>
}
  8004ff:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800503:	c9                   	leave
  800504:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800505:	49 89 c0             	mov    %rax,%r8
  800508:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80050d:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800514:	00 00 00 
  800517:	be 26 00 00 00       	mov    $0x26,%esi
  80051c:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800523:	00 00 00 
  800526:	b8 00 00 00 00       	mov    $0x0,%eax
  80052b:	49 b9 de 1b 80 00 00 	movabs $0x801bde,%r9
  800532:	00 00 00 
  800535:	41 ff d1             	call   *%r9

0000000000800538 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  800538:	f3 0f 1e fa          	endbr64
  80053c:	55                   	push   %rbp
  80053d:	48 89 e5             	mov    %rsp,%rbp
  800540:	53                   	push   %rbx
  800541:	48 83 ec 08          	sub    $0x8,%rsp
  800545:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  800548:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80054b:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800550:	bb 00 00 00 00       	mov    $0x0,%ebx
  800555:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80055a:	be 00 00 00 00       	mov    $0x0,%esi
  80055f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800565:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800567:	48 85 c0             	test   %rax,%rax
  80056a:	7f 06                	jg     800572 <sys_env_set_pgfault_upcall+0x3a>
}
  80056c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800570:	c9                   	leave
  800571:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800572:	49 89 c0             	mov    %rax,%r8
  800575:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80057a:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800581:	00 00 00 
  800584:	be 26 00 00 00       	mov    $0x26,%esi
  800589:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800590:	00 00 00 
  800593:	b8 00 00 00 00       	mov    $0x0,%eax
  800598:	49 b9 de 1b 80 00 00 	movabs $0x801bde,%r9
  80059f:	00 00 00 
  8005a2:	41 ff d1             	call   *%r9

00000000008005a5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8005a5:	f3 0f 1e fa          	endbr64
  8005a9:	55                   	push   %rbp
  8005aa:	48 89 e5             	mov    %rsp,%rbp
  8005ad:	53                   	push   %rbx
  8005ae:	89 f8                	mov    %edi,%eax
  8005b0:	49 89 f1             	mov    %rsi,%r9
  8005b3:	48 89 d3             	mov    %rdx,%rbx
  8005b6:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8005b9:	49 63 f0             	movslq %r8d,%rsi
  8005bc:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8005bf:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005c4:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005cd:	cd 30                	int    $0x30
}
  8005cf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005d3:	c9                   	leave
  8005d4:	c3                   	ret

00000000008005d5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8005d5:	f3 0f 1e fa          	endbr64
  8005d9:	55                   	push   %rbp
  8005da:	48 89 e5             	mov    %rsp,%rbp
  8005dd:	53                   	push   %rbx
  8005de:	48 83 ec 08          	sub    $0x8,%rsp
  8005e2:	48 89 fa             	mov    %rdi,%rdx
  8005e5:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8005e8:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005f7:	be 00 00 00 00       	mov    $0x0,%esi
  8005fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800602:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800604:	48 85 c0             	test   %rax,%rax
  800607:	7f 06                	jg     80060f <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800609:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80060d:	c9                   	leave
  80060e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80060f:	49 89 c0             	mov    %rax,%r8
  800612:	b9 0f 00 00 00       	mov    $0xf,%ecx
  800617:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80061e:	00 00 00 
  800621:	be 26 00 00 00       	mov    $0x26,%esi
  800626:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80062d:	00 00 00 
  800630:	b8 00 00 00 00       	mov    $0x0,%eax
  800635:	49 b9 de 1b 80 00 00 	movabs $0x801bde,%r9
  80063c:	00 00 00 
  80063f:	41 ff d1             	call   *%r9

0000000000800642 <sys_gettime>:

int
sys_gettime(void) {
  800642:	f3 0f 1e fa          	endbr64
  800646:	55                   	push   %rbp
  800647:	48 89 e5             	mov    %rsp,%rbp
  80064a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80064b:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800650:	ba 00 00 00 00       	mov    $0x0,%edx
  800655:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80065a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80065f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800664:	be 00 00 00 00       	mov    $0x0,%esi
  800669:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80066f:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  800671:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800675:	c9                   	leave
  800676:	c3                   	ret

0000000000800677 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  800677:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80067b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800682:	ff ff ff 
  800685:	48 01 f8             	add    %rdi,%rax
  800688:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80068c:	c3                   	ret

000000000080068d <fd2data>:

char *
fd2data(struct Fd *fd) {
  80068d:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800691:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800698:	ff ff ff 
  80069b:	48 01 f8             	add    %rdi,%rax
  80069e:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8006a2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8006a8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006ac:	c3                   	ret

00000000008006ad <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8006ad:	f3 0f 1e fa          	endbr64
  8006b1:	55                   	push   %rbp
  8006b2:	48 89 e5             	mov    %rsp,%rbp
  8006b5:	41 57                	push   %r15
  8006b7:	41 56                	push   %r14
  8006b9:	41 55                	push   %r13
  8006bb:	41 54                	push   %r12
  8006bd:	53                   	push   %rbx
  8006be:	48 83 ec 08          	sub    $0x8,%rsp
  8006c2:	49 89 ff             	mov    %rdi,%r15
  8006c5:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8006ca:	49 bd 0c 18 80 00 00 	movabs $0x80180c,%r13
  8006d1:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8006d4:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8006da:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8006dd:	48 89 df             	mov    %rbx,%rdi
  8006e0:	41 ff d5             	call   *%r13
  8006e3:	83 e0 04             	and    $0x4,%eax
  8006e6:	74 17                	je     8006ff <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8006e8:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8006ef:	4c 39 f3             	cmp    %r14,%rbx
  8006f2:	75 e6                	jne    8006da <fd_alloc+0x2d>
  8006f4:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8006fa:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8006ff:	4d 89 27             	mov    %r12,(%r15)
}
  800702:	48 83 c4 08          	add    $0x8,%rsp
  800706:	5b                   	pop    %rbx
  800707:	41 5c                	pop    %r12
  800709:	41 5d                	pop    %r13
  80070b:	41 5e                	pop    %r14
  80070d:	41 5f                	pop    %r15
  80070f:	5d                   	pop    %rbp
  800710:	c3                   	ret

0000000000800711 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  800711:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  800715:	83 ff 1f             	cmp    $0x1f,%edi
  800718:	77 39                	ja     800753 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80071a:	55                   	push   %rbp
  80071b:	48 89 e5             	mov    %rsp,%rbp
  80071e:	41 54                	push   %r12
  800720:	53                   	push   %rbx
  800721:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  800724:	48 63 df             	movslq %edi,%rbx
  800727:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80072e:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800732:	48 89 df             	mov    %rbx,%rdi
  800735:	48 b8 0c 18 80 00 00 	movabs $0x80180c,%rax
  80073c:	00 00 00 
  80073f:	ff d0                	call   *%rax
  800741:	a8 04                	test   $0x4,%al
  800743:	74 14                	je     800759 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  800745:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  800749:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80074e:	5b                   	pop    %rbx
  80074f:	41 5c                	pop    %r12
  800751:	5d                   	pop    %rbp
  800752:	c3                   	ret
        return -E_INVAL;
  800753:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800758:	c3                   	ret
        return -E_INVAL;
  800759:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80075e:	eb ee                	jmp    80074e <fd_lookup+0x3d>

0000000000800760 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  800760:	f3 0f 1e fa          	endbr64
  800764:	55                   	push   %rbp
  800765:	48 89 e5             	mov    %rsp,%rbp
  800768:	41 54                	push   %r12
  80076a:	53                   	push   %rbx
  80076b:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  80076e:	48 b8 40 33 80 00 00 	movabs $0x803340,%rax
  800775:	00 00 00 
  800778:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  80077f:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  800782:	39 3b                	cmp    %edi,(%rbx)
  800784:	74 47                	je     8007cd <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  800786:	48 83 c0 08          	add    $0x8,%rax
  80078a:	48 8b 18             	mov    (%rax),%rbx
  80078d:	48 85 db             	test   %rbx,%rbx
  800790:	75 f0                	jne    800782 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800792:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800799:	00 00 00 
  80079c:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8007a2:	89 fa                	mov    %edi,%edx
  8007a4:	48 bf 78 32 80 00 00 	movabs $0x803278,%rdi
  8007ab:	00 00 00 
  8007ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b3:	48 b9 3a 1d 80 00 00 	movabs $0x801d3a,%rcx
  8007ba:	00 00 00 
  8007bd:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8007bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8007c4:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8007c8:	5b                   	pop    %rbx
  8007c9:	41 5c                	pop    %r12
  8007cb:	5d                   	pop    %rbp
  8007cc:	c3                   	ret
            return 0;
  8007cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d2:	eb f0                	jmp    8007c4 <dev_lookup+0x64>

00000000008007d4 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8007d4:	f3 0f 1e fa          	endbr64
  8007d8:	55                   	push   %rbp
  8007d9:	48 89 e5             	mov    %rsp,%rbp
  8007dc:	41 55                	push   %r13
  8007de:	41 54                	push   %r12
  8007e0:	53                   	push   %rbx
  8007e1:	48 83 ec 18          	sub    $0x18,%rsp
  8007e5:	48 89 fb             	mov    %rdi,%rbx
  8007e8:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8007eb:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8007f2:	ff ff ff 
  8007f5:	48 01 df             	add    %rbx,%rdi
  8007f8:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8007fc:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800800:	48 b8 11 07 80 00 00 	movabs $0x800711,%rax
  800807:	00 00 00 
  80080a:	ff d0                	call   *%rax
  80080c:	41 89 c5             	mov    %eax,%r13d
  80080f:	85 c0                	test   %eax,%eax
  800811:	78 06                	js     800819 <fd_close+0x45>
  800813:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  800817:	74 1a                	je     800833 <fd_close+0x5f>
        return (must_exist ? res : 0);
  800819:	45 84 e4             	test   %r12b,%r12b
  80081c:	b8 00 00 00 00       	mov    $0x0,%eax
  800821:	44 0f 44 e8          	cmove  %eax,%r13d
}
  800825:	44 89 e8             	mov    %r13d,%eax
  800828:	48 83 c4 18          	add    $0x18,%rsp
  80082c:	5b                   	pop    %rbx
  80082d:	41 5c                	pop    %r12
  80082f:	41 5d                	pop    %r13
  800831:	5d                   	pop    %rbp
  800832:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800833:	8b 3b                	mov    (%rbx),%edi
  800835:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800839:	48 b8 60 07 80 00 00 	movabs $0x800760,%rax
  800840:	00 00 00 
  800843:	ff d0                	call   *%rax
  800845:	41 89 c5             	mov    %eax,%r13d
  800848:	85 c0                	test   %eax,%eax
  80084a:	78 1b                	js     800867 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80084c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800850:	48 8b 40 20          	mov    0x20(%rax),%rax
  800854:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80085a:	48 85 c0             	test   %rax,%rax
  80085d:	74 08                	je     800867 <fd_close+0x93>
  80085f:	48 89 df             	mov    %rbx,%rdi
  800862:	ff d0                	call   *%rax
  800864:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  800867:	ba 00 10 00 00       	mov    $0x1000,%edx
  80086c:	48 89 de             	mov    %rbx,%rsi
  80086f:	bf 00 00 00 00       	mov    $0x0,%edi
  800874:	48 b8 f3 03 80 00 00 	movabs $0x8003f3,%rax
  80087b:	00 00 00 
  80087e:	ff d0                	call   *%rax
    return res;
  800880:	eb a3                	jmp    800825 <fd_close+0x51>

0000000000800882 <close>:

int
close(int fdnum) {
  800882:	f3 0f 1e fa          	endbr64
  800886:	55                   	push   %rbp
  800887:	48 89 e5             	mov    %rsp,%rbp
  80088a:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80088e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800892:	48 b8 11 07 80 00 00 	movabs $0x800711,%rax
  800899:	00 00 00 
  80089c:	ff d0                	call   *%rax
    if (res < 0) return res;
  80089e:	85 c0                	test   %eax,%eax
  8008a0:	78 15                	js     8008b7 <close+0x35>

    return fd_close(fd, 1);
  8008a2:	be 01 00 00 00       	mov    $0x1,%esi
  8008a7:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8008ab:	48 b8 d4 07 80 00 00 	movabs $0x8007d4,%rax
  8008b2:	00 00 00 
  8008b5:	ff d0                	call   *%rax
}
  8008b7:	c9                   	leave
  8008b8:	c3                   	ret

00000000008008b9 <close_all>:

void
close_all(void) {
  8008b9:	f3 0f 1e fa          	endbr64
  8008bd:	55                   	push   %rbp
  8008be:	48 89 e5             	mov    %rsp,%rbp
  8008c1:	41 54                	push   %r12
  8008c3:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8008c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008c9:	49 bc 82 08 80 00 00 	movabs $0x800882,%r12
  8008d0:	00 00 00 
  8008d3:	89 df                	mov    %ebx,%edi
  8008d5:	41 ff d4             	call   *%r12
  8008d8:	83 c3 01             	add    $0x1,%ebx
  8008db:	83 fb 20             	cmp    $0x20,%ebx
  8008de:	75 f3                	jne    8008d3 <close_all+0x1a>
}
  8008e0:	5b                   	pop    %rbx
  8008e1:	41 5c                	pop    %r12
  8008e3:	5d                   	pop    %rbp
  8008e4:	c3                   	ret

00000000008008e5 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8008e5:	f3 0f 1e fa          	endbr64
  8008e9:	55                   	push   %rbp
  8008ea:	48 89 e5             	mov    %rsp,%rbp
  8008ed:	41 57                	push   %r15
  8008ef:	41 56                	push   %r14
  8008f1:	41 55                	push   %r13
  8008f3:	41 54                	push   %r12
  8008f5:	53                   	push   %rbx
  8008f6:	48 83 ec 18          	sub    $0x18,%rsp
  8008fa:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8008fd:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  800901:	48 b8 11 07 80 00 00 	movabs $0x800711,%rax
  800908:	00 00 00 
  80090b:	ff d0                	call   *%rax
  80090d:	89 c3                	mov    %eax,%ebx
  80090f:	85 c0                	test   %eax,%eax
  800911:	0f 88 b8 00 00 00    	js     8009cf <dup+0xea>
    close(newfdnum);
  800917:	44 89 e7             	mov    %r12d,%edi
  80091a:	48 b8 82 08 80 00 00 	movabs $0x800882,%rax
  800921:	00 00 00 
  800924:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  800926:	4d 63 ec             	movslq %r12d,%r13
  800929:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  800930:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  800934:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  800938:	4c 89 ff             	mov    %r15,%rdi
  80093b:	49 be 8d 06 80 00 00 	movabs $0x80068d,%r14
  800942:	00 00 00 
  800945:	41 ff d6             	call   *%r14
  800948:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  80094b:	4c 89 ef             	mov    %r13,%rdi
  80094e:	41 ff d6             	call   *%r14
  800951:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  800954:	48 89 df             	mov    %rbx,%rdi
  800957:	48 b8 0c 18 80 00 00 	movabs $0x80180c,%rax
  80095e:	00 00 00 
  800961:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  800963:	a8 04                	test   $0x4,%al
  800965:	74 2b                	je     800992 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  800967:	41 89 c1             	mov    %eax,%r9d
  80096a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800970:	4c 89 f1             	mov    %r14,%rcx
  800973:	ba 00 00 00 00       	mov    $0x0,%edx
  800978:	48 89 de             	mov    %rbx,%rsi
  80097b:	bf 00 00 00 00       	mov    $0x0,%edi
  800980:	48 b8 1e 03 80 00 00 	movabs $0x80031e,%rax
  800987:	00 00 00 
  80098a:	ff d0                	call   *%rax
  80098c:	89 c3                	mov    %eax,%ebx
  80098e:	85 c0                	test   %eax,%eax
  800990:	78 4e                	js     8009e0 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  800992:	4c 89 ff             	mov    %r15,%rdi
  800995:	48 b8 0c 18 80 00 00 	movabs $0x80180c,%rax
  80099c:	00 00 00 
  80099f:	ff d0                	call   *%rax
  8009a1:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8009a4:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8009aa:	4c 89 e9             	mov    %r13,%rcx
  8009ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b2:	4c 89 fe             	mov    %r15,%rsi
  8009b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8009ba:	48 b8 1e 03 80 00 00 	movabs $0x80031e,%rax
  8009c1:	00 00 00 
  8009c4:	ff d0                	call   *%rax
  8009c6:	89 c3                	mov    %eax,%ebx
  8009c8:	85 c0                	test   %eax,%eax
  8009ca:	78 14                	js     8009e0 <dup+0xfb>

    return newfdnum;
  8009cc:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8009cf:	89 d8                	mov    %ebx,%eax
  8009d1:	48 83 c4 18          	add    $0x18,%rsp
  8009d5:	5b                   	pop    %rbx
  8009d6:	41 5c                	pop    %r12
  8009d8:	41 5d                	pop    %r13
  8009da:	41 5e                	pop    %r14
  8009dc:	41 5f                	pop    %r15
  8009de:	5d                   	pop    %rbp
  8009df:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8009e0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009e5:	4c 89 ee             	mov    %r13,%rsi
  8009e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8009ed:	49 bc f3 03 80 00 00 	movabs $0x8003f3,%r12
  8009f4:	00 00 00 
  8009f7:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8009fa:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009ff:	4c 89 f6             	mov    %r14,%rsi
  800a02:	bf 00 00 00 00       	mov    $0x0,%edi
  800a07:	41 ff d4             	call   *%r12
    return res;
  800a0a:	eb c3                	jmp    8009cf <dup+0xea>

0000000000800a0c <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800a0c:	f3 0f 1e fa          	endbr64
  800a10:	55                   	push   %rbp
  800a11:	48 89 e5             	mov    %rsp,%rbp
  800a14:	41 56                	push   %r14
  800a16:	41 55                	push   %r13
  800a18:	41 54                	push   %r12
  800a1a:	53                   	push   %rbx
  800a1b:	48 83 ec 10          	sub    $0x10,%rsp
  800a1f:	89 fb                	mov    %edi,%ebx
  800a21:	49 89 f4             	mov    %rsi,%r12
  800a24:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a27:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800a2b:	48 b8 11 07 80 00 00 	movabs $0x800711,%rax
  800a32:	00 00 00 
  800a35:	ff d0                	call   *%rax
  800a37:	85 c0                	test   %eax,%eax
  800a39:	78 4c                	js     800a87 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a3b:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800a3f:	41 8b 3e             	mov    (%r14),%edi
  800a42:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800a46:	48 b8 60 07 80 00 00 	movabs $0x800760,%rax
  800a4d:	00 00 00 
  800a50:	ff d0                	call   *%rax
  800a52:	85 c0                	test   %eax,%eax
  800a54:	78 35                	js     800a8b <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a56:	41 8b 46 08          	mov    0x8(%r14),%eax
  800a5a:	83 e0 03             	and    $0x3,%eax
  800a5d:	83 f8 01             	cmp    $0x1,%eax
  800a60:	74 2d                	je     800a8f <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800a62:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a66:	48 8b 40 10          	mov    0x10(%rax),%rax
  800a6a:	48 85 c0             	test   %rax,%rax
  800a6d:	74 56                	je     800ac5 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  800a6f:	4c 89 ea             	mov    %r13,%rdx
  800a72:	4c 89 e6             	mov    %r12,%rsi
  800a75:	4c 89 f7             	mov    %r14,%rdi
  800a78:	ff d0                	call   *%rax
}
  800a7a:	48 83 c4 10          	add    $0x10,%rsp
  800a7e:	5b                   	pop    %rbx
  800a7f:	41 5c                	pop    %r12
  800a81:	41 5d                	pop    %r13
  800a83:	41 5e                	pop    %r14
  800a85:	5d                   	pop    %rbp
  800a86:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a87:	48 98                	cltq
  800a89:	eb ef                	jmp    800a7a <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a8b:	48 98                	cltq
  800a8d:	eb eb                	jmp    800a7a <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800a8f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800a96:	00 00 00 
  800a99:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800a9f:	89 da                	mov    %ebx,%edx
  800aa1:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  800aa8:	00 00 00 
  800aab:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab0:	48 b9 3a 1d 80 00 00 	movabs $0x801d3a,%rcx
  800ab7:	00 00 00 
  800aba:	ff d1                	call   *%rcx
        return -E_INVAL;
  800abc:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800ac3:	eb b5                	jmp    800a7a <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800ac5:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800acc:	eb ac                	jmp    800a7a <read+0x6e>

0000000000800ace <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800ace:	f3 0f 1e fa          	endbr64
  800ad2:	55                   	push   %rbp
  800ad3:	48 89 e5             	mov    %rsp,%rbp
  800ad6:	41 57                	push   %r15
  800ad8:	41 56                	push   %r14
  800ada:	41 55                	push   %r13
  800adc:	41 54                	push   %r12
  800ade:	53                   	push   %rbx
  800adf:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800ae3:	48 85 d2             	test   %rdx,%rdx
  800ae6:	74 54                	je     800b3c <readn+0x6e>
  800ae8:	41 89 fd             	mov    %edi,%r13d
  800aeb:	49 89 f6             	mov    %rsi,%r14
  800aee:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800af1:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800af6:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800afb:	49 bf 0c 0a 80 00 00 	movabs $0x800a0c,%r15
  800b02:	00 00 00 
  800b05:	4c 89 e2             	mov    %r12,%rdx
  800b08:	48 29 f2             	sub    %rsi,%rdx
  800b0b:	4c 01 f6             	add    %r14,%rsi
  800b0e:	44 89 ef             	mov    %r13d,%edi
  800b11:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800b14:	85 c0                	test   %eax,%eax
  800b16:	78 20                	js     800b38 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  800b18:	01 c3                	add    %eax,%ebx
  800b1a:	85 c0                	test   %eax,%eax
  800b1c:	74 08                	je     800b26 <readn+0x58>
  800b1e:	48 63 f3             	movslq %ebx,%rsi
  800b21:	4c 39 e6             	cmp    %r12,%rsi
  800b24:	72 df                	jb     800b05 <readn+0x37>
    }
    return res;
  800b26:	48 63 c3             	movslq %ebx,%rax
}
  800b29:	48 83 c4 08          	add    $0x8,%rsp
  800b2d:	5b                   	pop    %rbx
  800b2e:	41 5c                	pop    %r12
  800b30:	41 5d                	pop    %r13
  800b32:	41 5e                	pop    %r14
  800b34:	41 5f                	pop    %r15
  800b36:	5d                   	pop    %rbp
  800b37:	c3                   	ret
        if (inc < 0) return inc;
  800b38:	48 98                	cltq
  800b3a:	eb ed                	jmp    800b29 <readn+0x5b>
    int inc = 1, res = 0;
  800b3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b41:	eb e3                	jmp    800b26 <readn+0x58>

0000000000800b43 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800b43:	f3 0f 1e fa          	endbr64
  800b47:	55                   	push   %rbp
  800b48:	48 89 e5             	mov    %rsp,%rbp
  800b4b:	41 56                	push   %r14
  800b4d:	41 55                	push   %r13
  800b4f:	41 54                	push   %r12
  800b51:	53                   	push   %rbx
  800b52:	48 83 ec 10          	sub    $0x10,%rsp
  800b56:	89 fb                	mov    %edi,%ebx
  800b58:	49 89 f4             	mov    %rsi,%r12
  800b5b:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b5e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800b62:	48 b8 11 07 80 00 00 	movabs $0x800711,%rax
  800b69:	00 00 00 
  800b6c:	ff d0                	call   *%rax
  800b6e:	85 c0                	test   %eax,%eax
  800b70:	78 47                	js     800bb9 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b72:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800b76:	41 8b 3e             	mov    (%r14),%edi
  800b79:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800b7d:	48 b8 60 07 80 00 00 	movabs $0x800760,%rax
  800b84:	00 00 00 
  800b87:	ff d0                	call   *%rax
  800b89:	85 c0                	test   %eax,%eax
  800b8b:	78 30                	js     800bbd <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b8d:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  800b92:	74 2d                	je     800bc1 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800b94:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b98:	48 8b 40 18          	mov    0x18(%rax),%rax
  800b9c:	48 85 c0             	test   %rax,%rax
  800b9f:	74 56                	je     800bf7 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  800ba1:	4c 89 ea             	mov    %r13,%rdx
  800ba4:	4c 89 e6             	mov    %r12,%rsi
  800ba7:	4c 89 f7             	mov    %r14,%rdi
  800baa:	ff d0                	call   *%rax
}
  800bac:	48 83 c4 10          	add    $0x10,%rsp
  800bb0:	5b                   	pop    %rbx
  800bb1:	41 5c                	pop    %r12
  800bb3:	41 5d                	pop    %r13
  800bb5:	41 5e                	pop    %r14
  800bb7:	5d                   	pop    %rbp
  800bb8:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800bb9:	48 98                	cltq
  800bbb:	eb ef                	jmp    800bac <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bbd:	48 98                	cltq
  800bbf:	eb eb                	jmp    800bac <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800bc1:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bc8:	00 00 00 
  800bcb:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800bd1:	89 da                	mov    %ebx,%edx
  800bd3:	48 bf 34 30 80 00 00 	movabs $0x803034,%rdi
  800bda:	00 00 00 
  800bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800be2:	48 b9 3a 1d 80 00 00 	movabs $0x801d3a,%rcx
  800be9:	00 00 00 
  800bec:	ff d1                	call   *%rcx
        return -E_INVAL;
  800bee:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800bf5:	eb b5                	jmp    800bac <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800bf7:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800bfe:	eb ac                	jmp    800bac <write+0x69>

0000000000800c00 <seek>:

int
seek(int fdnum, off_t offset) {
  800c00:	f3 0f 1e fa          	endbr64
  800c04:	55                   	push   %rbp
  800c05:	48 89 e5             	mov    %rsp,%rbp
  800c08:	53                   	push   %rbx
  800c09:	48 83 ec 18          	sub    $0x18,%rsp
  800c0d:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c0f:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c13:	48 b8 11 07 80 00 00 	movabs $0x800711,%rax
  800c1a:	00 00 00 
  800c1d:	ff d0                	call   *%rax
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	78 0c                	js     800c2f <seek+0x2f>

    fd->fd_offset = offset;
  800c23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c27:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800c2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c2f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c33:	c9                   	leave
  800c34:	c3                   	ret

0000000000800c35 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800c35:	f3 0f 1e fa          	endbr64
  800c39:	55                   	push   %rbp
  800c3a:	48 89 e5             	mov    %rsp,%rbp
  800c3d:	41 55                	push   %r13
  800c3f:	41 54                	push   %r12
  800c41:	53                   	push   %rbx
  800c42:	48 83 ec 18          	sub    $0x18,%rsp
  800c46:	89 fb                	mov    %edi,%ebx
  800c48:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c4b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800c4f:	48 b8 11 07 80 00 00 	movabs $0x800711,%rax
  800c56:	00 00 00 
  800c59:	ff d0                	call   *%rax
  800c5b:	85 c0                	test   %eax,%eax
  800c5d:	78 38                	js     800c97 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c5f:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  800c63:	41 8b 7d 00          	mov    0x0(%r13),%edi
  800c67:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800c6b:	48 b8 60 07 80 00 00 	movabs $0x800760,%rax
  800c72:	00 00 00 
  800c75:	ff d0                	call   *%rax
  800c77:	85 c0                	test   %eax,%eax
  800c79:	78 1c                	js     800c97 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c7b:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  800c80:	74 20                	je     800ca2 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c82:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c86:	48 8b 40 30          	mov    0x30(%rax),%rax
  800c8a:	48 85 c0             	test   %rax,%rax
  800c8d:	74 47                	je     800cd6 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  800c8f:	44 89 e6             	mov    %r12d,%esi
  800c92:	4c 89 ef             	mov    %r13,%rdi
  800c95:	ff d0                	call   *%rax
}
  800c97:	48 83 c4 18          	add    $0x18,%rsp
  800c9b:	5b                   	pop    %rbx
  800c9c:	41 5c                	pop    %r12
  800c9e:	41 5d                	pop    %r13
  800ca0:	5d                   	pop    %rbp
  800ca1:	c3                   	ret
                thisenv->env_id, fdnum);
  800ca2:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800ca9:	00 00 00 
  800cac:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800cb2:	89 da                	mov    %ebx,%edx
  800cb4:	48 bf 98 32 80 00 00 	movabs $0x803298,%rdi
  800cbb:	00 00 00 
  800cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc3:	48 b9 3a 1d 80 00 00 	movabs $0x801d3a,%rcx
  800cca:	00 00 00 
  800ccd:	ff d1                	call   *%rcx
        return -E_INVAL;
  800ccf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cd4:	eb c1                	jmp    800c97 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800cd6:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800cdb:	eb ba                	jmp    800c97 <ftruncate+0x62>

0000000000800cdd <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800cdd:	f3 0f 1e fa          	endbr64
  800ce1:	55                   	push   %rbp
  800ce2:	48 89 e5             	mov    %rsp,%rbp
  800ce5:	41 54                	push   %r12
  800ce7:	53                   	push   %rbx
  800ce8:	48 83 ec 10          	sub    $0x10,%rsp
  800cec:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800cef:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800cf3:	48 b8 11 07 80 00 00 	movabs $0x800711,%rax
  800cfa:	00 00 00 
  800cfd:	ff d0                	call   *%rax
  800cff:	85 c0                	test   %eax,%eax
  800d01:	78 4e                	js     800d51 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800d03:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  800d07:	41 8b 3c 24          	mov    (%r12),%edi
  800d0b:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800d0f:	48 b8 60 07 80 00 00 	movabs $0x800760,%rax
  800d16:	00 00 00 
  800d19:	ff d0                	call   *%rax
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	78 32                	js     800d51 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d1f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800d23:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800d28:	74 30                	je     800d5a <fstat+0x7d>

    stat->st_name[0] = 0;
  800d2a:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800d2d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800d34:	00 00 00 
    stat->st_isdir = 0;
  800d37:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800d3e:	00 00 00 
    stat->st_dev = dev;
  800d41:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800d48:	48 89 de             	mov    %rbx,%rsi
  800d4b:	4c 89 e7             	mov    %r12,%rdi
  800d4e:	ff 50 28             	call   *0x28(%rax)
}
  800d51:	48 83 c4 10          	add    $0x10,%rsp
  800d55:	5b                   	pop    %rbx
  800d56:	41 5c                	pop    %r12
  800d58:	5d                   	pop    %rbp
  800d59:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d5a:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800d5f:	eb f0                	jmp    800d51 <fstat+0x74>

0000000000800d61 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800d61:	f3 0f 1e fa          	endbr64
  800d65:	55                   	push   %rbp
  800d66:	48 89 e5             	mov    %rsp,%rbp
  800d69:	41 54                	push   %r12
  800d6b:	53                   	push   %rbx
  800d6c:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800d6f:	be 00 00 00 00       	mov    $0x0,%esi
  800d74:	48 b8 42 10 80 00 00 	movabs $0x801042,%rax
  800d7b:	00 00 00 
  800d7e:	ff d0                	call   *%rax
  800d80:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800d82:	85 c0                	test   %eax,%eax
  800d84:	78 25                	js     800dab <stat+0x4a>

    int res = fstat(fd, stat);
  800d86:	4c 89 e6             	mov    %r12,%rsi
  800d89:	89 c7                	mov    %eax,%edi
  800d8b:	48 b8 dd 0c 80 00 00 	movabs $0x800cdd,%rax
  800d92:	00 00 00 
  800d95:	ff d0                	call   *%rax
  800d97:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800d9a:	89 df                	mov    %ebx,%edi
  800d9c:	48 b8 82 08 80 00 00 	movabs $0x800882,%rax
  800da3:	00 00 00 
  800da6:	ff d0                	call   *%rax

    return res;
  800da8:	44 89 e3             	mov    %r12d,%ebx
}
  800dab:	89 d8                	mov    %ebx,%eax
  800dad:	5b                   	pop    %rbx
  800dae:	41 5c                	pop    %r12
  800db0:	5d                   	pop    %rbp
  800db1:	c3                   	ret

0000000000800db2 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800db2:	f3 0f 1e fa          	endbr64
  800db6:	55                   	push   %rbp
  800db7:	48 89 e5             	mov    %rsp,%rbp
  800dba:	41 54                	push   %r12
  800dbc:	53                   	push   %rbx
  800dbd:	48 83 ec 10          	sub    $0x10,%rsp
  800dc1:	41 89 fc             	mov    %edi,%r12d
  800dc4:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800dc7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800dce:	00 00 00 
  800dd1:	83 38 00             	cmpl   $0x0,(%rax)
  800dd4:	74 6e                	je     800e44 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  800dd6:	bf 03 00 00 00       	mov    $0x3,%edi
  800ddb:	48 b8 3e 2c 80 00 00 	movabs $0x802c3e,%rax
  800de2:	00 00 00 
  800de5:	ff d0                	call   *%rax
  800de7:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800dee:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800df0:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800df6:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800dfb:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800e02:	00 00 00 
  800e05:	44 89 e6             	mov    %r12d,%esi
  800e08:	89 c7                	mov    %eax,%edi
  800e0a:	48 b8 7c 2b 80 00 00 	movabs $0x802b7c,%rax
  800e11:	00 00 00 
  800e14:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800e16:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800e1d:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800e1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e23:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e27:	48 89 de             	mov    %rbx,%rsi
  800e2a:	bf 00 00 00 00       	mov    $0x0,%edi
  800e2f:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  800e36:	00 00 00 
  800e39:	ff d0                	call   *%rax
}
  800e3b:	48 83 c4 10          	add    $0x10,%rsp
  800e3f:	5b                   	pop    %rbx
  800e40:	41 5c                	pop    %r12
  800e42:	5d                   	pop    %rbp
  800e43:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800e44:	bf 03 00 00 00       	mov    $0x3,%edi
  800e49:	48 b8 3e 2c 80 00 00 	movabs $0x802c3e,%rax
  800e50:	00 00 00 
  800e53:	ff d0                	call   *%rax
  800e55:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e5c:	00 00 
  800e5e:	e9 73 ff ff ff       	jmp    800dd6 <fsipc+0x24>

0000000000800e63 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800e63:	f3 0f 1e fa          	endbr64
  800e67:	55                   	push   %rbp
  800e68:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800e6b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e72:	00 00 00 
  800e75:	8b 57 0c             	mov    0xc(%rdi),%edx
  800e78:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800e7a:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800e7d:	be 00 00 00 00       	mov    $0x0,%esi
  800e82:	bf 02 00 00 00       	mov    $0x2,%edi
  800e87:	48 b8 b2 0d 80 00 00 	movabs $0x800db2,%rax
  800e8e:	00 00 00 
  800e91:	ff d0                	call   *%rax
}
  800e93:	5d                   	pop    %rbp
  800e94:	c3                   	ret

0000000000800e95 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800e95:	f3 0f 1e fa          	endbr64
  800e99:	55                   	push   %rbp
  800e9a:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800e9d:	8b 47 0c             	mov    0xc(%rdi),%eax
  800ea0:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ea7:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800ea9:	be 00 00 00 00       	mov    $0x0,%esi
  800eae:	bf 06 00 00 00       	mov    $0x6,%edi
  800eb3:	48 b8 b2 0d 80 00 00 	movabs $0x800db2,%rax
  800eba:	00 00 00 
  800ebd:	ff d0                	call   *%rax
}
  800ebf:	5d                   	pop    %rbp
  800ec0:	c3                   	ret

0000000000800ec1 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800ec1:	f3 0f 1e fa          	endbr64
  800ec5:	55                   	push   %rbp
  800ec6:	48 89 e5             	mov    %rsp,%rbp
  800ec9:	41 54                	push   %r12
  800ecb:	53                   	push   %rbx
  800ecc:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ecf:	8b 47 0c             	mov    0xc(%rdi),%eax
  800ed2:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ed9:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800edb:	be 00 00 00 00       	mov    $0x0,%esi
  800ee0:	bf 05 00 00 00       	mov    $0x5,%edi
  800ee5:	48 b8 b2 0d 80 00 00 	movabs $0x800db2,%rax
  800eec:	00 00 00 
  800eef:	ff d0                	call   *%rax
    if (res < 0) return res;
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	78 3d                	js     800f32 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800ef5:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  800efc:	00 00 00 
  800eff:	4c 89 e6             	mov    %r12,%rsi
  800f02:	48 89 df             	mov    %rbx,%rdi
  800f05:	48 b8 83 26 80 00 00 	movabs $0x802683,%rax
  800f0c:	00 00 00 
  800f0f:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800f11:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  800f18:	00 
  800f19:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800f1f:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  800f26:	00 
  800f27:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800f2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f32:	5b                   	pop    %rbx
  800f33:	41 5c                	pop    %r12
  800f35:	5d                   	pop    %rbp
  800f36:	c3                   	ret

0000000000800f37 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f37:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  800f3b:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  800f42:	77 41                	ja     800f85 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f44:	55                   	push   %rbp
  800f45:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  800f48:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f4f:	00 00 00 
  800f52:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f55:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  800f57:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  800f5b:	48 8d 78 10          	lea    0x10(%rax),%rdi
  800f5f:	48 b8 9e 28 80 00 00 	movabs $0x80289e,%rax
  800f66:	00 00 00 
  800f69:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  800f6b:	be 00 00 00 00       	mov    $0x0,%esi
  800f70:	bf 04 00 00 00       	mov    $0x4,%edi
  800f75:	48 b8 b2 0d 80 00 00 	movabs $0x800db2,%rax
  800f7c:	00 00 00 
  800f7f:	ff d0                	call   *%rax
  800f81:	48 98                	cltq
}
  800f83:	5d                   	pop    %rbp
  800f84:	c3                   	ret
        return -E_INVAL;
  800f85:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  800f8c:	c3                   	ret

0000000000800f8d <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800f8d:	f3 0f 1e fa          	endbr64
  800f91:	55                   	push   %rbp
  800f92:	48 89 e5             	mov    %rsp,%rbp
  800f95:	41 55                	push   %r13
  800f97:	41 54                	push   %r12
  800f99:	53                   	push   %rbx
  800f9a:	48 83 ec 08          	sub    $0x8,%rsp
  800f9e:	49 89 f4             	mov    %rsi,%r12
  800fa1:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800fa4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800fab:	00 00 00 
  800fae:	8b 57 0c             	mov    0xc(%rdi),%edx
  800fb1:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  800fb3:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  800fb7:	be 00 00 00 00       	mov    $0x0,%esi
  800fbc:	bf 03 00 00 00       	mov    $0x3,%edi
  800fc1:	48 b8 b2 0d 80 00 00 	movabs $0x800db2,%rax
  800fc8:	00 00 00 
  800fcb:	ff d0                	call   *%rax
  800fcd:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  800fd0:	4d 85 ed             	test   %r13,%r13
  800fd3:	78 2a                	js     800fff <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  800fd5:	4c 89 ea             	mov    %r13,%rdx
  800fd8:	4c 39 eb             	cmp    %r13,%rbx
  800fdb:	72 30                	jb     80100d <devfile_read+0x80>
  800fdd:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  800fe4:	7f 27                	jg     80100d <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  800fe6:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800fed:	00 00 00 
  800ff0:	4c 89 e7             	mov    %r12,%rdi
  800ff3:	48 b8 9e 28 80 00 00 	movabs $0x80289e,%rax
  800ffa:	00 00 00 
  800ffd:	ff d0                	call   *%rax
}
  800fff:	4c 89 e8             	mov    %r13,%rax
  801002:	48 83 c4 08          	add    $0x8,%rsp
  801006:	5b                   	pop    %rbx
  801007:	41 5c                	pop    %r12
  801009:	41 5d                	pop    %r13
  80100b:	5d                   	pop    %rbp
  80100c:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  80100d:	48 b9 51 30 80 00 00 	movabs $0x803051,%rcx
  801014:	00 00 00 
  801017:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  80101e:	00 00 00 
  801021:	be 7b 00 00 00       	mov    $0x7b,%esi
  801026:	48 bf 83 30 80 00 00 	movabs $0x803083,%rdi
  80102d:	00 00 00 
  801030:	b8 00 00 00 00       	mov    $0x0,%eax
  801035:	49 b8 de 1b 80 00 00 	movabs $0x801bde,%r8
  80103c:	00 00 00 
  80103f:	41 ff d0             	call   *%r8

0000000000801042 <open>:
open(const char *path, int mode) {
  801042:	f3 0f 1e fa          	endbr64
  801046:	55                   	push   %rbp
  801047:	48 89 e5             	mov    %rsp,%rbp
  80104a:	41 55                	push   %r13
  80104c:	41 54                	push   %r12
  80104e:	53                   	push   %rbx
  80104f:	48 83 ec 18          	sub    $0x18,%rsp
  801053:	49 89 fc             	mov    %rdi,%r12
  801056:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801059:	48 b8 3e 26 80 00 00 	movabs $0x80263e,%rax
  801060:	00 00 00 
  801063:	ff d0                	call   *%rax
  801065:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80106b:	0f 87 8a 00 00 00    	ja     8010fb <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801071:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801075:	48 b8 ad 06 80 00 00 	movabs $0x8006ad,%rax
  80107c:	00 00 00 
  80107f:	ff d0                	call   *%rax
  801081:	89 c3                	mov    %eax,%ebx
  801083:	85 c0                	test   %eax,%eax
  801085:	78 50                	js     8010d7 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  801087:	4c 89 e6             	mov    %r12,%rsi
  80108a:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801091:	00 00 00 
  801094:	48 89 df             	mov    %rbx,%rdi
  801097:	48 b8 83 26 80 00 00 	movabs $0x802683,%rax
  80109e:	00 00 00 
  8010a1:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8010a3:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8010aa:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8010ae:	bf 01 00 00 00       	mov    $0x1,%edi
  8010b3:	48 b8 b2 0d 80 00 00 	movabs $0x800db2,%rax
  8010ba:	00 00 00 
  8010bd:	ff d0                	call   *%rax
  8010bf:	89 c3                	mov    %eax,%ebx
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	78 1f                	js     8010e4 <open+0xa2>
    return fd2num(fd);
  8010c5:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010c9:	48 b8 77 06 80 00 00 	movabs $0x800677,%rax
  8010d0:	00 00 00 
  8010d3:	ff d0                	call   *%rax
  8010d5:	89 c3                	mov    %eax,%ebx
}
  8010d7:	89 d8                	mov    %ebx,%eax
  8010d9:	48 83 c4 18          	add    $0x18,%rsp
  8010dd:	5b                   	pop    %rbx
  8010de:	41 5c                	pop    %r12
  8010e0:	41 5d                	pop    %r13
  8010e2:	5d                   	pop    %rbp
  8010e3:	c3                   	ret
        fd_close(fd, 0);
  8010e4:	be 00 00 00 00       	mov    $0x0,%esi
  8010e9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010ed:	48 b8 d4 07 80 00 00 	movabs $0x8007d4,%rax
  8010f4:	00 00 00 
  8010f7:	ff d0                	call   *%rax
        return res;
  8010f9:	eb dc                	jmp    8010d7 <open+0x95>
        return -E_BAD_PATH;
  8010fb:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801100:	eb d5                	jmp    8010d7 <open+0x95>

0000000000801102 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801102:	f3 0f 1e fa          	endbr64
  801106:	55                   	push   %rbp
  801107:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80110a:	be 00 00 00 00       	mov    $0x0,%esi
  80110f:	bf 08 00 00 00       	mov    $0x8,%edi
  801114:	48 b8 b2 0d 80 00 00 	movabs $0x800db2,%rax
  80111b:	00 00 00 
  80111e:	ff d0                	call   *%rax
}
  801120:	5d                   	pop    %rbp
  801121:	c3                   	ret

0000000000801122 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801122:	f3 0f 1e fa          	endbr64
  801126:	55                   	push   %rbp
  801127:	48 89 e5             	mov    %rsp,%rbp
  80112a:	41 54                	push   %r12
  80112c:	53                   	push   %rbx
  80112d:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801130:	48 b8 8d 06 80 00 00 	movabs $0x80068d,%rax
  801137:	00 00 00 
  80113a:	ff d0                	call   *%rax
  80113c:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80113f:	48 be 8e 30 80 00 00 	movabs $0x80308e,%rsi
  801146:	00 00 00 
  801149:	48 89 df             	mov    %rbx,%rdi
  80114c:	48 b8 83 26 80 00 00 	movabs $0x802683,%rax
  801153:	00 00 00 
  801156:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801158:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80115d:	41 2b 04 24          	sub    (%r12),%eax
  801161:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801167:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80116e:	00 00 00 
    stat->st_dev = &devpipe;
  801171:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801178:	00 00 00 
  80117b:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801182:	b8 00 00 00 00       	mov    $0x0,%eax
  801187:	5b                   	pop    %rbx
  801188:	41 5c                	pop    %r12
  80118a:	5d                   	pop    %rbp
  80118b:	c3                   	ret

000000000080118c <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80118c:	f3 0f 1e fa          	endbr64
  801190:	55                   	push   %rbp
  801191:	48 89 e5             	mov    %rsp,%rbp
  801194:	41 54                	push   %r12
  801196:	53                   	push   %rbx
  801197:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80119a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80119f:	48 89 fe             	mov    %rdi,%rsi
  8011a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8011a7:	49 bc f3 03 80 00 00 	movabs $0x8003f3,%r12
  8011ae:	00 00 00 
  8011b1:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8011b4:	48 89 df             	mov    %rbx,%rdi
  8011b7:	48 b8 8d 06 80 00 00 	movabs $0x80068d,%rax
  8011be:	00 00 00 
  8011c1:	ff d0                	call   *%rax
  8011c3:	48 89 c6             	mov    %rax,%rsi
  8011c6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8011d0:	41 ff d4             	call   *%r12
}
  8011d3:	5b                   	pop    %rbx
  8011d4:	41 5c                	pop    %r12
  8011d6:	5d                   	pop    %rbp
  8011d7:	c3                   	ret

00000000008011d8 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8011d8:	f3 0f 1e fa          	endbr64
  8011dc:	55                   	push   %rbp
  8011dd:	48 89 e5             	mov    %rsp,%rbp
  8011e0:	41 57                	push   %r15
  8011e2:	41 56                	push   %r14
  8011e4:	41 55                	push   %r13
  8011e6:	41 54                	push   %r12
  8011e8:	53                   	push   %rbx
  8011e9:	48 83 ec 18          	sub    $0x18,%rsp
  8011ed:	49 89 fc             	mov    %rdi,%r12
  8011f0:	49 89 f5             	mov    %rsi,%r13
  8011f3:	49 89 d7             	mov    %rdx,%r15
  8011f6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8011fa:	48 b8 8d 06 80 00 00 	movabs $0x80068d,%rax
  801201:	00 00 00 
  801204:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801206:	4d 85 ff             	test   %r15,%r15
  801209:	0f 84 af 00 00 00    	je     8012be <devpipe_write+0xe6>
  80120f:	48 89 c3             	mov    %rax,%rbx
  801212:	4c 89 f8             	mov    %r15,%rax
  801215:	4d 89 ef             	mov    %r13,%r15
  801218:	4c 01 e8             	add    %r13,%rax
  80121b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80121f:	49 bd 83 02 80 00 00 	movabs $0x800283,%r13
  801226:	00 00 00 
            sys_yield();
  801229:	49 be 18 02 80 00 00 	movabs $0x800218,%r14
  801230:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801233:	8b 73 04             	mov    0x4(%rbx),%esi
  801236:	48 63 ce             	movslq %esi,%rcx
  801239:	48 63 03             	movslq (%rbx),%rax
  80123c:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801242:	48 39 c1             	cmp    %rax,%rcx
  801245:	72 2e                	jb     801275 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801247:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80124c:	48 89 da             	mov    %rbx,%rdx
  80124f:	be 00 10 00 00       	mov    $0x1000,%esi
  801254:	4c 89 e7             	mov    %r12,%rdi
  801257:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80125a:	85 c0                	test   %eax,%eax
  80125c:	74 66                	je     8012c4 <devpipe_write+0xec>
            sys_yield();
  80125e:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801261:	8b 73 04             	mov    0x4(%rbx),%esi
  801264:	48 63 ce             	movslq %esi,%rcx
  801267:	48 63 03             	movslq (%rbx),%rax
  80126a:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801270:	48 39 c1             	cmp    %rax,%rcx
  801273:	73 d2                	jae    801247 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801275:	41 0f b6 3f          	movzbl (%r15),%edi
  801279:	48 89 ca             	mov    %rcx,%rdx
  80127c:	48 c1 ea 03          	shr    $0x3,%rdx
  801280:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801287:	08 10 20 
  80128a:	48 f7 e2             	mul    %rdx
  80128d:	48 c1 ea 06          	shr    $0x6,%rdx
  801291:	48 89 d0             	mov    %rdx,%rax
  801294:	48 c1 e0 09          	shl    $0x9,%rax
  801298:	48 29 d0             	sub    %rdx,%rax
  80129b:	48 c1 e0 03          	shl    $0x3,%rax
  80129f:	48 29 c1             	sub    %rax,%rcx
  8012a2:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8012a7:	83 c6 01             	add    $0x1,%esi
  8012aa:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012ad:	49 83 c7 01          	add    $0x1,%r15
  8012b1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012b5:	49 39 c7             	cmp    %rax,%r15
  8012b8:	0f 85 75 ff ff ff    	jne    801233 <devpipe_write+0x5b>
    return n;
  8012be:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8012c2:	eb 05                	jmp    8012c9 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8012c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c9:	48 83 c4 18          	add    $0x18,%rsp
  8012cd:	5b                   	pop    %rbx
  8012ce:	41 5c                	pop    %r12
  8012d0:	41 5d                	pop    %r13
  8012d2:	41 5e                	pop    %r14
  8012d4:	41 5f                	pop    %r15
  8012d6:	5d                   	pop    %rbp
  8012d7:	c3                   	ret

00000000008012d8 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8012d8:	f3 0f 1e fa          	endbr64
  8012dc:	55                   	push   %rbp
  8012dd:	48 89 e5             	mov    %rsp,%rbp
  8012e0:	41 57                	push   %r15
  8012e2:	41 56                	push   %r14
  8012e4:	41 55                	push   %r13
  8012e6:	41 54                	push   %r12
  8012e8:	53                   	push   %rbx
  8012e9:	48 83 ec 18          	sub    $0x18,%rsp
  8012ed:	49 89 fc             	mov    %rdi,%r12
  8012f0:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8012f4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8012f8:	48 b8 8d 06 80 00 00 	movabs $0x80068d,%rax
  8012ff:	00 00 00 
  801302:	ff d0                	call   *%rax
  801304:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  801307:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80130d:	49 bd 83 02 80 00 00 	movabs $0x800283,%r13
  801314:	00 00 00 
            sys_yield();
  801317:	49 be 18 02 80 00 00 	movabs $0x800218,%r14
  80131e:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801321:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801326:	74 7d                	je     8013a5 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801328:	8b 03                	mov    (%rbx),%eax
  80132a:	3b 43 04             	cmp    0x4(%rbx),%eax
  80132d:	75 26                	jne    801355 <devpipe_read+0x7d>
            if (i > 0) return i;
  80132f:	4d 85 ff             	test   %r15,%r15
  801332:	75 77                	jne    8013ab <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801334:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801339:	48 89 da             	mov    %rbx,%rdx
  80133c:	be 00 10 00 00       	mov    $0x1000,%esi
  801341:	4c 89 e7             	mov    %r12,%rdi
  801344:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801347:	85 c0                	test   %eax,%eax
  801349:	74 72                	je     8013bd <devpipe_read+0xe5>
            sys_yield();
  80134b:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80134e:	8b 03                	mov    (%rbx),%eax
  801350:	3b 43 04             	cmp    0x4(%rbx),%eax
  801353:	74 df                	je     801334 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801355:	48 63 c8             	movslq %eax,%rcx
  801358:	48 89 ca             	mov    %rcx,%rdx
  80135b:	48 c1 ea 03          	shr    $0x3,%rdx
  80135f:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  801366:	08 10 20 
  801369:	48 89 d0             	mov    %rdx,%rax
  80136c:	48 f7 e6             	mul    %rsi
  80136f:	48 c1 ea 06          	shr    $0x6,%rdx
  801373:	48 89 d0             	mov    %rdx,%rax
  801376:	48 c1 e0 09          	shl    $0x9,%rax
  80137a:	48 29 d0             	sub    %rdx,%rax
  80137d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801384:	00 
  801385:	48 89 c8             	mov    %rcx,%rax
  801388:	48 29 d0             	sub    %rdx,%rax
  80138b:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  801390:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801394:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  801398:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80139b:	49 83 c7 01          	add    $0x1,%r15
  80139f:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8013a3:	75 83                	jne    801328 <devpipe_read+0x50>
    return n;
  8013a5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013a9:	eb 03                	jmp    8013ae <devpipe_read+0xd6>
            if (i > 0) return i;
  8013ab:	4c 89 f8             	mov    %r15,%rax
}
  8013ae:	48 83 c4 18          	add    $0x18,%rsp
  8013b2:	5b                   	pop    %rbx
  8013b3:	41 5c                	pop    %r12
  8013b5:	41 5d                	pop    %r13
  8013b7:	41 5e                	pop    %r14
  8013b9:	41 5f                	pop    %r15
  8013bb:	5d                   	pop    %rbp
  8013bc:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8013bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c2:	eb ea                	jmp    8013ae <devpipe_read+0xd6>

00000000008013c4 <pipe>:
pipe(int pfd[2]) {
  8013c4:	f3 0f 1e fa          	endbr64
  8013c8:	55                   	push   %rbp
  8013c9:	48 89 e5             	mov    %rsp,%rbp
  8013cc:	41 55                	push   %r13
  8013ce:	41 54                	push   %r12
  8013d0:	53                   	push   %rbx
  8013d1:	48 83 ec 18          	sub    $0x18,%rsp
  8013d5:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8013d8:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8013dc:	48 b8 ad 06 80 00 00 	movabs $0x8006ad,%rax
  8013e3:	00 00 00 
  8013e6:	ff d0                	call   *%rax
  8013e8:	89 c3                	mov    %eax,%ebx
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	0f 88 a0 01 00 00    	js     801592 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8013f2:	b9 46 00 00 00       	mov    $0x46,%ecx
  8013f7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8013fc:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801400:	bf 00 00 00 00       	mov    $0x0,%edi
  801405:	48 b8 b3 02 80 00 00 	movabs $0x8002b3,%rax
  80140c:	00 00 00 
  80140f:	ff d0                	call   *%rax
  801411:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801413:	85 c0                	test   %eax,%eax
  801415:	0f 88 77 01 00 00    	js     801592 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80141b:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80141f:	48 b8 ad 06 80 00 00 	movabs $0x8006ad,%rax
  801426:	00 00 00 
  801429:	ff d0                	call   *%rax
  80142b:	89 c3                	mov    %eax,%ebx
  80142d:	85 c0                	test   %eax,%eax
  80142f:	0f 88 43 01 00 00    	js     801578 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  801435:	b9 46 00 00 00       	mov    $0x46,%ecx
  80143a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80143f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801443:	bf 00 00 00 00       	mov    $0x0,%edi
  801448:	48 b8 b3 02 80 00 00 	movabs $0x8002b3,%rax
  80144f:	00 00 00 
  801452:	ff d0                	call   *%rax
  801454:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  801456:	85 c0                	test   %eax,%eax
  801458:	0f 88 1a 01 00 00    	js     801578 <pipe+0x1b4>
    va = fd2data(fd0);
  80145e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801462:	48 b8 8d 06 80 00 00 	movabs $0x80068d,%rax
  801469:	00 00 00 
  80146c:	ff d0                	call   *%rax
  80146e:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801471:	b9 46 00 00 00       	mov    $0x46,%ecx
  801476:	ba 00 10 00 00       	mov    $0x1000,%edx
  80147b:	48 89 c6             	mov    %rax,%rsi
  80147e:	bf 00 00 00 00       	mov    $0x0,%edi
  801483:	48 b8 b3 02 80 00 00 	movabs $0x8002b3,%rax
  80148a:	00 00 00 
  80148d:	ff d0                	call   *%rax
  80148f:	89 c3                	mov    %eax,%ebx
  801491:	85 c0                	test   %eax,%eax
  801493:	0f 88 c5 00 00 00    	js     80155e <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  801499:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80149d:	48 b8 8d 06 80 00 00 	movabs $0x80068d,%rax
  8014a4:	00 00 00 
  8014a7:	ff d0                	call   *%rax
  8014a9:	48 89 c1             	mov    %rax,%rcx
  8014ac:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8014b2:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8014b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8014bd:	4c 89 ee             	mov    %r13,%rsi
  8014c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8014c5:	48 b8 1e 03 80 00 00 	movabs $0x80031e,%rax
  8014cc:	00 00 00 
  8014cf:	ff d0                	call   *%rax
  8014d1:	89 c3                	mov    %eax,%ebx
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	78 6e                	js     801545 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014d7:	be 00 10 00 00       	mov    $0x1000,%esi
  8014dc:	4c 89 ef             	mov    %r13,%rdi
  8014df:	48 b8 4d 02 80 00 00 	movabs $0x80024d,%rax
  8014e6:	00 00 00 
  8014e9:	ff d0                	call   *%rax
  8014eb:	83 f8 02             	cmp    $0x2,%eax
  8014ee:	0f 85 ab 00 00 00    	jne    80159f <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8014f4:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8014fb:	00 00 
  8014fd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801501:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  801503:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801507:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80150e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801512:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801514:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801518:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80151f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801523:	48 bb 77 06 80 00 00 	movabs $0x800677,%rbx
  80152a:	00 00 00 
  80152d:	ff d3                	call   *%rbx
  80152f:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801533:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801537:	ff d3                	call   *%rbx
  801539:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80153e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801543:	eb 4d                	jmp    801592 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  801545:	ba 00 10 00 00       	mov    $0x1000,%edx
  80154a:	4c 89 ee             	mov    %r13,%rsi
  80154d:	bf 00 00 00 00       	mov    $0x0,%edi
  801552:	48 b8 f3 03 80 00 00 	movabs $0x8003f3,%rax
  801559:	00 00 00 
  80155c:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80155e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801563:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801567:	bf 00 00 00 00       	mov    $0x0,%edi
  80156c:	48 b8 f3 03 80 00 00 	movabs $0x8003f3,%rax
  801573:	00 00 00 
  801576:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  801578:	ba 00 10 00 00       	mov    $0x1000,%edx
  80157d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801581:	bf 00 00 00 00       	mov    $0x0,%edi
  801586:	48 b8 f3 03 80 00 00 	movabs $0x8003f3,%rax
  80158d:	00 00 00 
  801590:	ff d0                	call   *%rax
}
  801592:	89 d8                	mov    %ebx,%eax
  801594:	48 83 c4 18          	add    $0x18,%rsp
  801598:	5b                   	pop    %rbx
  801599:	41 5c                	pop    %r12
  80159b:	41 5d                	pop    %r13
  80159d:	5d                   	pop    %rbp
  80159e:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80159f:	48 b9 c0 32 80 00 00 	movabs $0x8032c0,%rcx
  8015a6:	00 00 00 
  8015a9:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  8015b0:	00 00 00 
  8015b3:	be 2e 00 00 00       	mov    $0x2e,%esi
  8015b8:	48 bf 95 30 80 00 00 	movabs $0x803095,%rdi
  8015bf:	00 00 00 
  8015c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c7:	49 b8 de 1b 80 00 00 	movabs $0x801bde,%r8
  8015ce:	00 00 00 
  8015d1:	41 ff d0             	call   *%r8

00000000008015d4 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8015d4:	f3 0f 1e fa          	endbr64
  8015d8:	55                   	push   %rbp
  8015d9:	48 89 e5             	mov    %rsp,%rbp
  8015dc:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8015e0:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8015e4:	48 b8 11 07 80 00 00 	movabs $0x800711,%rax
  8015eb:	00 00 00 
  8015ee:	ff d0                	call   *%rax
    if (res < 0) return res;
  8015f0:	85 c0                	test   %eax,%eax
  8015f2:	78 35                	js     801629 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8015f4:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8015f8:	48 b8 8d 06 80 00 00 	movabs $0x80068d,%rax
  8015ff:	00 00 00 
  801602:	ff d0                	call   *%rax
  801604:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801607:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80160c:	be 00 10 00 00       	mov    $0x1000,%esi
  801611:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801615:	48 b8 83 02 80 00 00 	movabs $0x800283,%rax
  80161c:	00 00 00 
  80161f:	ff d0                	call   *%rax
  801621:	85 c0                	test   %eax,%eax
  801623:	0f 94 c0             	sete   %al
  801626:	0f b6 c0             	movzbl %al,%eax
}
  801629:	c9                   	leave
  80162a:	c3                   	ret

000000000080162b <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  80162b:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80162f:	48 89 f8             	mov    %rdi,%rax
  801632:	48 c1 e8 27          	shr    $0x27,%rax
  801636:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80163d:	7f 00 00 
  801640:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801644:	f6 c2 01             	test   $0x1,%dl
  801647:	74 6d                	je     8016b6 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801649:	48 89 f8             	mov    %rdi,%rax
  80164c:	48 c1 e8 1e          	shr    $0x1e,%rax
  801650:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801657:	7f 00 00 
  80165a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80165e:	f6 c2 01             	test   $0x1,%dl
  801661:	74 62                	je     8016c5 <get_uvpt_entry+0x9a>
  801663:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80166a:	7f 00 00 
  80166d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801671:	f6 c2 80             	test   $0x80,%dl
  801674:	75 4f                	jne    8016c5 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801676:	48 89 f8             	mov    %rdi,%rax
  801679:	48 c1 e8 15          	shr    $0x15,%rax
  80167d:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  801684:	7f 00 00 
  801687:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80168b:	f6 c2 01             	test   $0x1,%dl
  80168e:	74 44                	je     8016d4 <get_uvpt_entry+0xa9>
  801690:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  801697:	7f 00 00 
  80169a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80169e:	f6 c2 80             	test   $0x80,%dl
  8016a1:	75 31                	jne    8016d4 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  8016a3:	48 c1 ef 0c          	shr    $0xc,%rdi
  8016a7:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8016ae:	7f 00 00 
  8016b1:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8016b5:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8016b6:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8016bd:	7f 00 00 
  8016c0:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016c4:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8016c5:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8016cc:	7f 00 00 
  8016cf:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016d3:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8016d4:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016db:	7f 00 00 
  8016de:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016e2:	c3                   	ret

00000000008016e3 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8016e3:	f3 0f 1e fa          	endbr64
  8016e7:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8016ea:	48 89 f9             	mov    %rdi,%rcx
  8016ed:	48 c1 e9 27          	shr    $0x27,%rcx
  8016f1:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8016f8:	7f 00 00 
  8016fb:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8016ff:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  801706:	f6 c1 01             	test   $0x1,%cl
  801709:	0f 84 b2 00 00 00    	je     8017c1 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80170f:	48 89 f9             	mov    %rdi,%rcx
  801712:	48 c1 e9 1e          	shr    $0x1e,%rcx
  801716:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80171d:	7f 00 00 
  801720:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801724:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80172b:	40 f6 c6 01          	test   $0x1,%sil
  80172f:	0f 84 8c 00 00 00    	je     8017c1 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  801735:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80173c:	7f 00 00 
  80173f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801743:	a8 80                	test   $0x80,%al
  801745:	75 7b                	jne    8017c2 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  801747:	48 89 f9             	mov    %rdi,%rcx
  80174a:	48 c1 e9 15          	shr    $0x15,%rcx
  80174e:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801755:	7f 00 00 
  801758:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80175c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  801763:	40 f6 c6 01          	test   $0x1,%sil
  801767:	74 58                	je     8017c1 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  801769:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801770:	7f 00 00 
  801773:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801777:	a8 80                	test   $0x80,%al
  801779:	75 6c                	jne    8017e7 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  80177b:	48 89 f9             	mov    %rdi,%rcx
  80177e:	48 c1 e9 0c          	shr    $0xc,%rcx
  801782:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801789:	7f 00 00 
  80178c:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801790:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  801797:	40 f6 c6 01          	test   $0x1,%sil
  80179b:	74 24                	je     8017c1 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  80179d:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8017a4:	7f 00 00 
  8017a7:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017ab:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017b2:	ff ff 7f 
  8017b5:	48 21 c8             	and    %rcx,%rax
  8017b8:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8017be:	48 09 d0             	or     %rdx,%rax
}
  8017c1:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8017c2:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8017c9:	7f 00 00 
  8017cc:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017d0:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017d7:	ff ff 7f 
  8017da:	48 21 c8             	and    %rcx,%rax
  8017dd:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8017e3:	48 01 d0             	add    %rdx,%rax
  8017e6:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8017e7:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8017ee:	7f 00 00 
  8017f1:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017f5:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017fc:	ff ff 7f 
  8017ff:	48 21 c8             	and    %rcx,%rax
  801802:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  801808:	48 01 d0             	add    %rdx,%rax
  80180b:	c3                   	ret

000000000080180c <get_prot>:

int
get_prot(void *va) {
  80180c:	f3 0f 1e fa          	endbr64
  801810:	55                   	push   %rbp
  801811:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801814:	48 b8 2b 16 80 00 00 	movabs $0x80162b,%rax
  80181b:	00 00 00 
  80181e:	ff d0                	call   *%rax
  801820:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  801823:	83 e0 01             	and    $0x1,%eax
  801826:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  801829:	89 d1                	mov    %edx,%ecx
  80182b:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  801831:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  801833:	89 c1                	mov    %eax,%ecx
  801835:	83 c9 02             	or     $0x2,%ecx
  801838:	f6 c2 02             	test   $0x2,%dl
  80183b:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80183e:	89 c1                	mov    %eax,%ecx
  801840:	83 c9 01             	or     $0x1,%ecx
  801843:	48 85 d2             	test   %rdx,%rdx
  801846:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801849:	89 c1                	mov    %eax,%ecx
  80184b:	83 c9 40             	or     $0x40,%ecx
  80184e:	f6 c6 04             	test   $0x4,%dh
  801851:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801854:	5d                   	pop    %rbp
  801855:	c3                   	ret

0000000000801856 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801856:	f3 0f 1e fa          	endbr64
  80185a:	55                   	push   %rbp
  80185b:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80185e:	48 b8 2b 16 80 00 00 	movabs $0x80162b,%rax
  801865:	00 00 00 
  801868:	ff d0                	call   *%rax
    return pte & PTE_D;
  80186a:	48 c1 e8 06          	shr    $0x6,%rax
  80186e:	83 e0 01             	and    $0x1,%eax
}
  801871:	5d                   	pop    %rbp
  801872:	c3                   	ret

0000000000801873 <is_page_present>:

bool
is_page_present(void *va) {
  801873:	f3 0f 1e fa          	endbr64
  801877:	55                   	push   %rbp
  801878:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80187b:	48 b8 2b 16 80 00 00 	movabs $0x80162b,%rax
  801882:	00 00 00 
  801885:	ff d0                	call   *%rax
  801887:	83 e0 01             	and    $0x1,%eax
}
  80188a:	5d                   	pop    %rbp
  80188b:	c3                   	ret

000000000080188c <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80188c:	f3 0f 1e fa          	endbr64
  801890:	55                   	push   %rbp
  801891:	48 89 e5             	mov    %rsp,%rbp
  801894:	41 57                	push   %r15
  801896:	41 56                	push   %r14
  801898:	41 55                	push   %r13
  80189a:	41 54                	push   %r12
  80189c:	53                   	push   %rbx
  80189d:	48 83 ec 18          	sub    $0x18,%rsp
  8018a1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8018a5:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8018a9:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8018ae:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8018b5:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8018b8:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8018bf:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8018c2:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8018c9:	00 00 00 
  8018cc:	eb 73                	jmp    801941 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018ce:	48 89 d8             	mov    %rbx,%rax
  8018d1:	48 c1 e8 15          	shr    $0x15,%rax
  8018d5:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8018dc:	7f 00 00 
  8018df:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8018e3:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018e9:	f6 c2 01             	test   $0x1,%dl
  8018ec:	74 4b                	je     801939 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8018ee:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8018f2:	f6 c2 80             	test   $0x80,%dl
  8018f5:	74 11                	je     801908 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8018f7:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8018fb:	f6 c4 04             	test   $0x4,%ah
  8018fe:	74 39                	je     801939 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  801900:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  801906:	eb 20                	jmp    801928 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801908:	48 89 da             	mov    %rbx,%rdx
  80190b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80190f:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801916:	7f 00 00 
  801919:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  80191d:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801923:	f6 c4 04             	test   $0x4,%ah
  801926:	74 11                	je     801939 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  801928:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  80192c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801930:	48 89 df             	mov    %rbx,%rdi
  801933:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801937:	ff d0                	call   *%rax
    next:
        va += size;
  801939:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  80193c:	49 39 df             	cmp    %rbx,%r15
  80193f:	72 3e                	jb     80197f <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  801941:	49 8b 06             	mov    (%r14),%rax
  801944:	a8 01                	test   $0x1,%al
  801946:	74 37                	je     80197f <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801948:	48 89 d8             	mov    %rbx,%rax
  80194b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80194f:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  801954:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80195a:	f6 c2 01             	test   $0x1,%dl
  80195d:	74 da                	je     801939 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  80195f:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  801964:	f6 c2 80             	test   $0x80,%dl
  801967:	0f 84 61 ff ff ff    	je     8018ce <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  80196d:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  801972:	f6 c4 04             	test   $0x4,%ah
  801975:	74 c2                	je     801939 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  801977:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  80197d:	eb a9                	jmp    801928 <foreach_shared_region+0x9c>
    }
    return res;
}
  80197f:	b8 00 00 00 00       	mov    $0x0,%eax
  801984:	48 83 c4 18          	add    $0x18,%rsp
  801988:	5b                   	pop    %rbx
  801989:	41 5c                	pop    %r12
  80198b:	41 5d                	pop    %r13
  80198d:	41 5e                	pop    %r14
  80198f:	41 5f                	pop    %r15
  801991:	5d                   	pop    %rbp
  801992:	c3                   	ret

0000000000801993 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  801993:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  801997:	b8 00 00 00 00       	mov    $0x0,%eax
  80199c:	c3                   	ret

000000000080199d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80199d:	f3 0f 1e fa          	endbr64
  8019a1:	55                   	push   %rbp
  8019a2:	48 89 e5             	mov    %rsp,%rbp
  8019a5:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8019a8:	48 be a5 30 80 00 00 	movabs $0x8030a5,%rsi
  8019af:	00 00 00 
  8019b2:	48 b8 83 26 80 00 00 	movabs $0x802683,%rax
  8019b9:	00 00 00 
  8019bc:	ff d0                	call   *%rax
    return 0;
}
  8019be:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c3:	5d                   	pop    %rbp
  8019c4:	c3                   	ret

00000000008019c5 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8019c5:	f3 0f 1e fa          	endbr64
  8019c9:	55                   	push   %rbp
  8019ca:	48 89 e5             	mov    %rsp,%rbp
  8019cd:	41 57                	push   %r15
  8019cf:	41 56                	push   %r14
  8019d1:	41 55                	push   %r13
  8019d3:	41 54                	push   %r12
  8019d5:	53                   	push   %rbx
  8019d6:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8019dd:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8019e4:	48 85 d2             	test   %rdx,%rdx
  8019e7:	74 7a                	je     801a63 <devcons_write+0x9e>
  8019e9:	49 89 d6             	mov    %rdx,%r14
  8019ec:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8019f2:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8019f7:	49 bf 9e 28 80 00 00 	movabs $0x80289e,%r15
  8019fe:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  801a01:	4c 89 f3             	mov    %r14,%rbx
  801a04:	48 29 f3             	sub    %rsi,%rbx
  801a07:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a0c:	48 39 c3             	cmp    %rax,%rbx
  801a0f:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801a13:	4c 63 eb             	movslq %ebx,%r13
  801a16:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801a1d:	48 01 c6             	add    %rax,%rsi
  801a20:	4c 89 ea             	mov    %r13,%rdx
  801a23:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a2a:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  801a2d:	4c 89 ee             	mov    %r13,%rsi
  801a30:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a37:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  801a3e:	00 00 00 
  801a41:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801a43:	41 01 dc             	add    %ebx,%r12d
  801a46:	49 63 f4             	movslq %r12d,%rsi
  801a49:	4c 39 f6             	cmp    %r14,%rsi
  801a4c:	72 b3                	jb     801a01 <devcons_write+0x3c>
    return res;
  801a4e:	49 63 c4             	movslq %r12d,%rax
}
  801a51:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801a58:	5b                   	pop    %rbx
  801a59:	41 5c                	pop    %r12
  801a5b:	41 5d                	pop    %r13
  801a5d:	41 5e                	pop    %r14
  801a5f:	41 5f                	pop    %r15
  801a61:	5d                   	pop    %rbp
  801a62:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  801a63:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a69:	eb e3                	jmp    801a4e <devcons_write+0x89>

0000000000801a6b <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a6b:	f3 0f 1e fa          	endbr64
  801a6f:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801a72:	ba 00 00 00 00       	mov    $0x0,%edx
  801a77:	48 85 c0             	test   %rax,%rax
  801a7a:	74 55                	je     801ad1 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a7c:	55                   	push   %rbp
  801a7d:	48 89 e5             	mov    %rsp,%rbp
  801a80:	41 55                	push   %r13
  801a82:	41 54                	push   %r12
  801a84:	53                   	push   %rbx
  801a85:	48 83 ec 08          	sub    $0x8,%rsp
  801a89:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801a8c:	48 bb 3f 01 80 00 00 	movabs $0x80013f,%rbx
  801a93:	00 00 00 
  801a96:	49 bc 18 02 80 00 00 	movabs $0x800218,%r12
  801a9d:	00 00 00 
  801aa0:	eb 03                	jmp    801aa5 <devcons_read+0x3a>
  801aa2:	41 ff d4             	call   *%r12
  801aa5:	ff d3                	call   *%rbx
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	74 f7                	je     801aa2 <devcons_read+0x37>
    if (c < 0) return c;
  801aab:	48 63 d0             	movslq %eax,%rdx
  801aae:	78 13                	js     801ac3 <devcons_read+0x58>
    if (c == 0x04) return 0;
  801ab0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab5:	83 f8 04             	cmp    $0x4,%eax
  801ab8:	74 09                	je     801ac3 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  801aba:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801abe:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801ac3:	48 89 d0             	mov    %rdx,%rax
  801ac6:	48 83 c4 08          	add    $0x8,%rsp
  801aca:	5b                   	pop    %rbx
  801acb:	41 5c                	pop    %r12
  801acd:	41 5d                	pop    %r13
  801acf:	5d                   	pop    %rbp
  801ad0:	c3                   	ret
  801ad1:	48 89 d0             	mov    %rdx,%rax
  801ad4:	c3                   	ret

0000000000801ad5 <cputchar>:
cputchar(int ch) {
  801ad5:	f3 0f 1e fa          	endbr64
  801ad9:	55                   	push   %rbp
  801ada:	48 89 e5             	mov    %rsp,%rbp
  801add:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801ae1:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801ae5:	be 01 00 00 00       	mov    $0x1,%esi
  801aea:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801aee:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  801af5:	00 00 00 
  801af8:	ff d0                	call   *%rax
}
  801afa:	c9                   	leave
  801afb:	c3                   	ret

0000000000801afc <getchar>:
getchar(void) {
  801afc:	f3 0f 1e fa          	endbr64
  801b00:	55                   	push   %rbp
  801b01:	48 89 e5             	mov    %rsp,%rbp
  801b04:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801b08:	ba 01 00 00 00       	mov    $0x1,%edx
  801b0d:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801b11:	bf 00 00 00 00       	mov    $0x0,%edi
  801b16:	48 b8 0c 0a 80 00 00 	movabs $0x800a0c,%rax
  801b1d:	00 00 00 
  801b20:	ff d0                	call   *%rax
  801b22:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801b24:	85 c0                	test   %eax,%eax
  801b26:	78 06                	js     801b2e <getchar+0x32>
  801b28:	74 08                	je     801b32 <getchar+0x36>
  801b2a:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  801b2e:	89 d0                	mov    %edx,%eax
  801b30:	c9                   	leave
  801b31:	c3                   	ret
    return res < 0 ? res : res ? c :
  801b32:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801b37:	eb f5                	jmp    801b2e <getchar+0x32>

0000000000801b39 <iscons>:
iscons(int fdnum) {
  801b39:	f3 0f 1e fa          	endbr64
  801b3d:	55                   	push   %rbp
  801b3e:	48 89 e5             	mov    %rsp,%rbp
  801b41:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801b45:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b49:	48 b8 11 07 80 00 00 	movabs $0x800711,%rax
  801b50:	00 00 00 
  801b53:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b55:	85 c0                	test   %eax,%eax
  801b57:	78 18                	js     801b71 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  801b59:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b5d:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801b64:	00 00 00 
  801b67:	8b 00                	mov    (%rax),%eax
  801b69:	39 02                	cmp    %eax,(%rdx)
  801b6b:	0f 94 c0             	sete   %al
  801b6e:	0f b6 c0             	movzbl %al,%eax
}
  801b71:	c9                   	leave
  801b72:	c3                   	ret

0000000000801b73 <opencons>:
opencons(void) {
  801b73:	f3 0f 1e fa          	endbr64
  801b77:	55                   	push   %rbp
  801b78:	48 89 e5             	mov    %rsp,%rbp
  801b7b:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801b7f:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801b83:	48 b8 ad 06 80 00 00 	movabs $0x8006ad,%rax
  801b8a:	00 00 00 
  801b8d:	ff d0                	call   *%rax
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	78 49                	js     801bdc <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801b93:	b9 46 00 00 00       	mov    $0x46,%ecx
  801b98:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b9d:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801ba1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba6:	48 b8 b3 02 80 00 00 	movabs $0x8002b3,%rax
  801bad:	00 00 00 
  801bb0:	ff d0                	call   *%rax
  801bb2:	85 c0                	test   %eax,%eax
  801bb4:	78 26                	js     801bdc <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  801bb6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bba:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801bc1:	00 00 
  801bc3:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801bc5:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801bc9:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801bd0:	48 b8 77 06 80 00 00 	movabs $0x800677,%rax
  801bd7:	00 00 00 
  801bda:	ff d0                	call   *%rax
}
  801bdc:	c9                   	leave
  801bdd:	c3                   	ret

0000000000801bde <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801bde:	f3 0f 1e fa          	endbr64
  801be2:	55                   	push   %rbp
  801be3:	48 89 e5             	mov    %rsp,%rbp
  801be6:	41 56                	push   %r14
  801be8:	41 55                	push   %r13
  801bea:	41 54                	push   %r12
  801bec:	53                   	push   %rbx
  801bed:	48 83 ec 50          	sub    $0x50,%rsp
  801bf1:	49 89 fc             	mov    %rdi,%r12
  801bf4:	41 89 f5             	mov    %esi,%r13d
  801bf7:	48 89 d3             	mov    %rdx,%rbx
  801bfa:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801bfe:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801c02:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801c06:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801c0d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c11:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801c15:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801c19:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801c1d:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801c24:	00 00 00 
  801c27:	4c 8b 30             	mov    (%rax),%r14
  801c2a:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  801c31:	00 00 00 
  801c34:	ff d0                	call   *%rax
  801c36:	89 c6                	mov    %eax,%esi
  801c38:	45 89 e8             	mov    %r13d,%r8d
  801c3b:	4c 89 e1             	mov    %r12,%rcx
  801c3e:	4c 89 f2             	mov    %r14,%rdx
  801c41:	48 bf e8 32 80 00 00 	movabs $0x8032e8,%rdi
  801c48:	00 00 00 
  801c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c50:	49 bc 3a 1d 80 00 00 	movabs $0x801d3a,%r12
  801c57:	00 00 00 
  801c5a:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801c5d:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801c61:	48 89 df             	mov    %rbx,%rdi
  801c64:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  801c6b:	00 00 00 
  801c6e:	ff d0                	call   *%rax
    cprintf("\n");
  801c70:	48 bf 32 30 80 00 00 	movabs $0x803032,%rdi
  801c77:	00 00 00 
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7f:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801c82:	cc                   	int3
  801c83:	eb fd                	jmp    801c82 <_panic+0xa4>

0000000000801c85 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801c85:	f3 0f 1e fa          	endbr64
  801c89:	55                   	push   %rbp
  801c8a:	48 89 e5             	mov    %rsp,%rbp
  801c8d:	53                   	push   %rbx
  801c8e:	48 83 ec 08          	sub    $0x8,%rsp
  801c92:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801c95:	8b 06                	mov    (%rsi),%eax
  801c97:	8d 50 01             	lea    0x1(%rax),%edx
  801c9a:	89 16                	mov    %edx,(%rsi)
  801c9c:	48 98                	cltq
  801c9e:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801ca3:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801ca9:	74 0a                	je     801cb5 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801cab:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801caf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cb3:	c9                   	leave
  801cb4:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  801cb5:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801cb9:	be ff 00 00 00       	mov    $0xff,%esi
  801cbe:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  801cc5:	00 00 00 
  801cc8:	ff d0                	call   *%rax
        state->offset = 0;
  801cca:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801cd0:	eb d9                	jmp    801cab <putch+0x26>

0000000000801cd2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801cd2:	f3 0f 1e fa          	endbr64
  801cd6:	55                   	push   %rbp
  801cd7:	48 89 e5             	mov    %rsp,%rbp
  801cda:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801ce1:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801ce4:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801ceb:	b9 21 00 00 00       	mov    $0x21,%ecx
  801cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf5:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801cf8:	48 89 f1             	mov    %rsi,%rcx
  801cfb:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801d02:	48 bf 85 1c 80 00 00 	movabs $0x801c85,%rdi
  801d09:	00 00 00 
  801d0c:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  801d13:	00 00 00 
  801d16:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801d18:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801d1f:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801d26:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  801d2d:	00 00 00 
  801d30:	ff d0                	call   *%rax

    return state.count;
}
  801d32:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801d38:	c9                   	leave
  801d39:	c3                   	ret

0000000000801d3a <cprintf>:

int
cprintf(const char *fmt, ...) {
  801d3a:	f3 0f 1e fa          	endbr64
  801d3e:	55                   	push   %rbp
  801d3f:	48 89 e5             	mov    %rsp,%rbp
  801d42:	48 83 ec 50          	sub    $0x50,%rsp
  801d46:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801d4a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801d4e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d52:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801d56:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801d5a:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801d61:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d65:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d69:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801d6d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801d71:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801d75:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  801d7c:	00 00 00 
  801d7f:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801d81:	c9                   	leave
  801d82:	c3                   	ret

0000000000801d83 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801d83:	f3 0f 1e fa          	endbr64
  801d87:	55                   	push   %rbp
  801d88:	48 89 e5             	mov    %rsp,%rbp
  801d8b:	41 57                	push   %r15
  801d8d:	41 56                	push   %r14
  801d8f:	41 55                	push   %r13
  801d91:	41 54                	push   %r12
  801d93:	53                   	push   %rbx
  801d94:	48 83 ec 18          	sub    $0x18,%rsp
  801d98:	49 89 fc             	mov    %rdi,%r12
  801d9b:	49 89 f5             	mov    %rsi,%r13
  801d9e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801da2:	8b 45 10             	mov    0x10(%rbp),%eax
  801da5:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801da8:	41 89 cf             	mov    %ecx,%r15d
  801dab:	4c 39 fa             	cmp    %r15,%rdx
  801dae:	73 5b                	jae    801e0b <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801db0:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801db4:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801db8:	85 db                	test   %ebx,%ebx
  801dba:	7e 0e                	jle    801dca <print_num+0x47>
            putch(padc, put_arg);
  801dbc:	4c 89 ee             	mov    %r13,%rsi
  801dbf:	44 89 f7             	mov    %r14d,%edi
  801dc2:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801dc5:	83 eb 01             	sub    $0x1,%ebx
  801dc8:	75 f2                	jne    801dbc <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801dca:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801dce:	48 b9 c2 30 80 00 00 	movabs $0x8030c2,%rcx
  801dd5:	00 00 00 
  801dd8:	48 b8 b1 30 80 00 00 	movabs $0x8030b1,%rax
  801ddf:	00 00 00 
  801de2:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801de6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801dea:	ba 00 00 00 00       	mov    $0x0,%edx
  801def:	49 f7 f7             	div    %r15
  801df2:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801df6:	4c 89 ee             	mov    %r13,%rsi
  801df9:	41 ff d4             	call   *%r12
}
  801dfc:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801e00:	5b                   	pop    %rbx
  801e01:	41 5c                	pop    %r12
  801e03:	41 5d                	pop    %r13
  801e05:	41 5e                	pop    %r14
  801e07:	41 5f                	pop    %r15
  801e09:	5d                   	pop    %rbp
  801e0a:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801e0b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e0f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e14:	49 f7 f7             	div    %r15
  801e17:	48 83 ec 08          	sub    $0x8,%rsp
  801e1b:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801e1f:	52                   	push   %rdx
  801e20:	45 0f be c9          	movsbl %r9b,%r9d
  801e24:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801e28:	48 89 c2             	mov    %rax,%rdx
  801e2b:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  801e32:	00 00 00 
  801e35:	ff d0                	call   *%rax
  801e37:	48 83 c4 10          	add    $0x10,%rsp
  801e3b:	eb 8d                	jmp    801dca <print_num+0x47>

0000000000801e3d <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  801e3d:	f3 0f 1e fa          	endbr64
    state->count++;
  801e41:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801e45:	48 8b 06             	mov    (%rsi),%rax
  801e48:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801e4c:	73 0a                	jae    801e58 <sprintputch+0x1b>
        *state->start++ = ch;
  801e4e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e52:	48 89 16             	mov    %rdx,(%rsi)
  801e55:	40 88 38             	mov    %dil,(%rax)
    }
}
  801e58:	c3                   	ret

0000000000801e59 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801e59:	f3 0f 1e fa          	endbr64
  801e5d:	55                   	push   %rbp
  801e5e:	48 89 e5             	mov    %rsp,%rbp
  801e61:	48 83 ec 50          	sub    $0x50,%rsp
  801e65:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e69:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801e6d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801e71:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801e78:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e7c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e80:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801e84:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801e88:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801e8c:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  801e93:	00 00 00 
  801e96:	ff d0                	call   *%rax
}
  801e98:	c9                   	leave
  801e99:	c3                   	ret

0000000000801e9a <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801e9a:	f3 0f 1e fa          	endbr64
  801e9e:	55                   	push   %rbp
  801e9f:	48 89 e5             	mov    %rsp,%rbp
  801ea2:	41 57                	push   %r15
  801ea4:	41 56                	push   %r14
  801ea6:	41 55                	push   %r13
  801ea8:	41 54                	push   %r12
  801eaa:	53                   	push   %rbx
  801eab:	48 83 ec 38          	sub    $0x38,%rsp
  801eaf:	49 89 fe             	mov    %rdi,%r14
  801eb2:	49 89 f5             	mov    %rsi,%r13
  801eb5:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  801eb8:	48 8b 01             	mov    (%rcx),%rax
  801ebb:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801ebf:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801ec3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ec7:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801ecb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801ecf:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  801ed3:	0f b6 3b             	movzbl (%rbx),%edi
  801ed6:	40 80 ff 25          	cmp    $0x25,%dil
  801eda:	74 18                	je     801ef4 <vprintfmt+0x5a>
            if (!ch) return;
  801edc:	40 84 ff             	test   %dil,%dil
  801edf:	0f 84 b2 06 00 00    	je     802597 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  801ee5:	40 0f b6 ff          	movzbl %dil,%edi
  801ee9:	4c 89 ee             	mov    %r13,%rsi
  801eec:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  801eef:	4c 89 e3             	mov    %r12,%rbx
  801ef2:	eb db                	jmp    801ecf <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  801ef4:	be 00 00 00 00       	mov    $0x0,%esi
  801ef9:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  801efd:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801f02:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f08:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801f0f:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f13:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  801f18:	41 0f b6 04 24       	movzbl (%r12),%eax
  801f1d:	88 45 a0             	mov    %al,-0x60(%rbp)
  801f20:	83 e8 23             	sub    $0x23,%eax
  801f23:	3c 57                	cmp    $0x57,%al
  801f25:	0f 87 52 06 00 00    	ja     80257d <vprintfmt+0x6e3>
  801f2b:	0f b6 c0             	movzbl %al,%eax
  801f2e:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  801f35:	00 00 00 
  801f38:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  801f3c:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  801f3f:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  801f43:	eb ce                	jmp    801f13 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  801f45:	49 89 dc             	mov    %rbx,%r12
  801f48:	be 01 00 00 00       	mov    $0x1,%esi
  801f4d:	eb c4                	jmp    801f13 <vprintfmt+0x79>
            padc = ch;
  801f4f:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  801f53:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f56:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801f59:	eb b8                	jmp    801f13 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f5e:	83 f8 2f             	cmp    $0x2f,%eax
  801f61:	77 24                	ja     801f87 <vprintfmt+0xed>
  801f63:	89 c1                	mov    %eax,%ecx
  801f65:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  801f69:	83 c0 08             	add    $0x8,%eax
  801f6c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f6f:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  801f72:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  801f75:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801f79:	79 98                	jns    801f13 <vprintfmt+0x79>
                width = precision;
  801f7b:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  801f7f:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f85:	eb 8c                	jmp    801f13 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f87:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801f8b:	48 8d 41 08          	lea    0x8(%rcx),%rax
  801f8f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801f93:	eb da                	jmp    801f6f <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  801f95:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  801f9a:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801f9e:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  801fa4:	3c 39                	cmp    $0x39,%al
  801fa6:	77 1c                	ja     801fc4 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  801fa8:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  801fac:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  801fb0:	0f b6 c0             	movzbl %al,%eax
  801fb3:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fb8:	0f b6 03             	movzbl (%rbx),%eax
  801fbb:	3c 39                	cmp    $0x39,%al
  801fbd:	76 e9                	jbe    801fa8 <vprintfmt+0x10e>
        process_precision:
  801fbf:	49 89 dc             	mov    %rbx,%r12
  801fc2:	eb b1                	jmp    801f75 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  801fc4:	49 89 dc             	mov    %rbx,%r12
  801fc7:	eb ac                	jmp    801f75 <vprintfmt+0xdb>
            width = MAX(0, width);
  801fc9:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  801fcc:	85 c9                	test   %ecx,%ecx
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd3:	0f 49 c1             	cmovns %ecx,%eax
  801fd6:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801fd9:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fdc:	e9 32 ff ff ff       	jmp    801f13 <vprintfmt+0x79>
            lflag++;
  801fe1:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801fe4:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fe7:	e9 27 ff ff ff       	jmp    801f13 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  801fec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fef:	83 f8 2f             	cmp    $0x2f,%eax
  801ff2:	77 19                	ja     80200d <vprintfmt+0x173>
  801ff4:	89 c2                	mov    %eax,%edx
  801ff6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801ffa:	83 c0 08             	add    $0x8,%eax
  801ffd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802000:	8b 3a                	mov    (%rdx),%edi
  802002:	4c 89 ee             	mov    %r13,%rsi
  802005:	41 ff d6             	call   *%r14
            break;
  802008:	e9 c2 fe ff ff       	jmp    801ecf <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  80200d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802011:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802015:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802019:	eb e5                	jmp    802000 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  80201b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80201e:	83 f8 2f             	cmp    $0x2f,%eax
  802021:	77 5a                	ja     80207d <vprintfmt+0x1e3>
  802023:	89 c2                	mov    %eax,%edx
  802025:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802029:	83 c0 08             	add    $0x8,%eax
  80202c:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  80202f:	8b 02                	mov    (%rdx),%eax
  802031:	89 c1                	mov    %eax,%ecx
  802033:	f7 d9                	neg    %ecx
  802035:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  802038:	83 f9 13             	cmp    $0x13,%ecx
  80203b:	7f 4e                	jg     80208b <vprintfmt+0x1f1>
  80203d:	48 63 c1             	movslq %ecx,%rax
  802040:	48 ba 20 36 80 00 00 	movabs $0x803620,%rdx
  802047:	00 00 00 
  80204a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80204e:	48 85 c0             	test   %rax,%rax
  802051:	74 38                	je     80208b <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  802053:	48 89 c1             	mov    %rax,%rcx
  802056:	48 ba 80 30 80 00 00 	movabs $0x803080,%rdx
  80205d:	00 00 00 
  802060:	4c 89 ee             	mov    %r13,%rsi
  802063:	4c 89 f7             	mov    %r14,%rdi
  802066:	b8 00 00 00 00       	mov    $0x0,%eax
  80206b:	49 b8 59 1e 80 00 00 	movabs $0x801e59,%r8
  802072:	00 00 00 
  802075:	41 ff d0             	call   *%r8
  802078:	e9 52 fe ff ff       	jmp    801ecf <vprintfmt+0x35>
            int err = va_arg(aq, int);
  80207d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802081:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802085:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802089:	eb a4                	jmp    80202f <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  80208b:	48 ba da 30 80 00 00 	movabs $0x8030da,%rdx
  802092:	00 00 00 
  802095:	4c 89 ee             	mov    %r13,%rsi
  802098:	4c 89 f7             	mov    %r14,%rdi
  80209b:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a0:	49 b8 59 1e 80 00 00 	movabs $0x801e59,%r8
  8020a7:	00 00 00 
  8020aa:	41 ff d0             	call   *%r8
  8020ad:	e9 1d fe ff ff       	jmp    801ecf <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8020b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020b5:	83 f8 2f             	cmp    $0x2f,%eax
  8020b8:	77 6c                	ja     802126 <vprintfmt+0x28c>
  8020ba:	89 c2                	mov    %eax,%edx
  8020bc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8020c0:	83 c0 08             	add    $0x8,%eax
  8020c3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020c6:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8020c9:	48 85 d2             	test   %rdx,%rdx
  8020cc:	48 b8 d3 30 80 00 00 	movabs $0x8030d3,%rax
  8020d3:	00 00 00 
  8020d6:	48 0f 45 c2          	cmovne %rdx,%rax
  8020da:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8020de:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8020e2:	7e 06                	jle    8020ea <vprintfmt+0x250>
  8020e4:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8020e8:	75 4a                	jne    802134 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8020ea:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8020ee:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8020f2:	0f b6 00             	movzbl (%rax),%eax
  8020f5:	84 c0                	test   %al,%al
  8020f7:	0f 85 9a 00 00 00    	jne    802197 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8020fd:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802100:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  802104:	85 c0                	test   %eax,%eax
  802106:	0f 8e c3 fd ff ff    	jle    801ecf <vprintfmt+0x35>
  80210c:	4c 89 ee             	mov    %r13,%rsi
  80210f:	bf 20 00 00 00       	mov    $0x20,%edi
  802114:	41 ff d6             	call   *%r14
  802117:	41 83 ec 01          	sub    $0x1,%r12d
  80211b:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  80211f:	75 eb                	jne    80210c <vprintfmt+0x272>
  802121:	e9 a9 fd ff ff       	jmp    801ecf <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  802126:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80212a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80212e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802132:	eb 92                	jmp    8020c6 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  802134:	49 63 f7             	movslq %r15d,%rsi
  802137:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80213b:	48 b8 5d 26 80 00 00 	movabs $0x80265d,%rax
  802142:	00 00 00 
  802145:	ff d0                	call   *%rax
  802147:	48 89 c2             	mov    %rax,%rdx
  80214a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80214d:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80214f:	8d 70 ff             	lea    -0x1(%rax),%esi
  802152:	89 75 ac             	mov    %esi,-0x54(%rbp)
  802155:	85 c0                	test   %eax,%eax
  802157:	7e 91                	jle    8020ea <vprintfmt+0x250>
  802159:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80215e:	4c 89 ee             	mov    %r13,%rsi
  802161:	44 89 e7             	mov    %r12d,%edi
  802164:	41 ff d6             	call   *%r14
  802167:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80216b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80216e:	83 f8 ff             	cmp    $0xffffffff,%eax
  802171:	75 eb                	jne    80215e <vprintfmt+0x2c4>
  802173:	e9 72 ff ff ff       	jmp    8020ea <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  802178:	0f b6 f8             	movzbl %al,%edi
  80217b:	4c 89 ee             	mov    %r13,%rsi
  80217e:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802181:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  802185:	49 83 c4 01          	add    $0x1,%r12
  802189:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  80218f:	84 c0                	test   %al,%al
  802191:	0f 84 66 ff ff ff    	je     8020fd <vprintfmt+0x263>
  802197:	45 85 ff             	test   %r15d,%r15d
  80219a:	78 0a                	js     8021a6 <vprintfmt+0x30c>
  80219c:	41 83 ef 01          	sub    $0x1,%r15d
  8021a0:	0f 88 57 ff ff ff    	js     8020fd <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8021a6:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8021aa:	74 cc                	je     802178 <vprintfmt+0x2de>
  8021ac:	8d 50 e0             	lea    -0x20(%rax),%edx
  8021af:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8021b4:	80 fa 5e             	cmp    $0x5e,%dl
  8021b7:	77 c2                	ja     80217b <vprintfmt+0x2e1>
  8021b9:	eb bd                	jmp    802178 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8021bb:	40 84 f6             	test   %sil,%sil
  8021be:	75 26                	jne    8021e6 <vprintfmt+0x34c>
    switch (lflag) {
  8021c0:	85 d2                	test   %edx,%edx
  8021c2:	74 59                	je     80221d <vprintfmt+0x383>
  8021c4:	83 fa 01             	cmp    $0x1,%edx
  8021c7:	74 7b                	je     802244 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8021c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021cc:	83 f8 2f             	cmp    $0x2f,%eax
  8021cf:	0f 87 96 00 00 00    	ja     80226b <vprintfmt+0x3d1>
  8021d5:	89 c2                	mov    %eax,%edx
  8021d7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021db:	83 c0 08             	add    $0x8,%eax
  8021de:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021e1:	4c 8b 22             	mov    (%rdx),%r12
  8021e4:	eb 17                	jmp    8021fd <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8021e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021e9:	83 f8 2f             	cmp    $0x2f,%eax
  8021ec:	77 21                	ja     80220f <vprintfmt+0x375>
  8021ee:	89 c2                	mov    %eax,%edx
  8021f0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021f4:	83 c0 08             	add    $0x8,%eax
  8021f7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021fa:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8021fd:	4d 85 e4             	test   %r12,%r12
  802200:	78 7a                	js     80227c <vprintfmt+0x3e2>
            num = i;
  802202:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  802205:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80220a:	e9 50 02 00 00       	jmp    80245f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80220f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802213:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802217:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80221b:	eb dd                	jmp    8021fa <vprintfmt+0x360>
        return va_arg(*ap, int);
  80221d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802220:	83 f8 2f             	cmp    $0x2f,%eax
  802223:	77 11                	ja     802236 <vprintfmt+0x39c>
  802225:	89 c2                	mov    %eax,%edx
  802227:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80222b:	83 c0 08             	add    $0x8,%eax
  80222e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802231:	4c 63 22             	movslq (%rdx),%r12
  802234:	eb c7                	jmp    8021fd <vprintfmt+0x363>
  802236:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80223a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80223e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802242:	eb ed                	jmp    802231 <vprintfmt+0x397>
        return va_arg(*ap, long);
  802244:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802247:	83 f8 2f             	cmp    $0x2f,%eax
  80224a:	77 11                	ja     80225d <vprintfmt+0x3c3>
  80224c:	89 c2                	mov    %eax,%edx
  80224e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802252:	83 c0 08             	add    $0x8,%eax
  802255:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802258:	4c 8b 22             	mov    (%rdx),%r12
  80225b:	eb a0                	jmp    8021fd <vprintfmt+0x363>
  80225d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802261:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802265:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802269:	eb ed                	jmp    802258 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  80226b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80226f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802273:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802277:	e9 65 ff ff ff       	jmp    8021e1 <vprintfmt+0x347>
                putch('-', put_arg);
  80227c:	4c 89 ee             	mov    %r13,%rsi
  80227f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802284:	41 ff d6             	call   *%r14
                i = -i;
  802287:	49 f7 dc             	neg    %r12
  80228a:	e9 73 ff ff ff       	jmp    802202 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  80228f:	40 84 f6             	test   %sil,%sil
  802292:	75 32                	jne    8022c6 <vprintfmt+0x42c>
    switch (lflag) {
  802294:	85 d2                	test   %edx,%edx
  802296:	74 5d                	je     8022f5 <vprintfmt+0x45b>
  802298:	83 fa 01             	cmp    $0x1,%edx
  80229b:	0f 84 82 00 00 00    	je     802323 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8022a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022a4:	83 f8 2f             	cmp    $0x2f,%eax
  8022a7:	0f 87 a5 00 00 00    	ja     802352 <vprintfmt+0x4b8>
  8022ad:	89 c2                	mov    %eax,%edx
  8022af:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022b3:	83 c0 08             	add    $0x8,%eax
  8022b6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022b9:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8022c1:	e9 99 01 00 00       	jmp    80245f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8022c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022c9:	83 f8 2f             	cmp    $0x2f,%eax
  8022cc:	77 19                	ja     8022e7 <vprintfmt+0x44d>
  8022ce:	89 c2                	mov    %eax,%edx
  8022d0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022d4:	83 c0 08             	add    $0x8,%eax
  8022d7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022da:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8022e2:	e9 78 01 00 00       	jmp    80245f <vprintfmt+0x5c5>
  8022e7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8022eb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8022ef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022f3:	eb e5                	jmp    8022da <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8022f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022f8:	83 f8 2f             	cmp    $0x2f,%eax
  8022fb:	77 18                	ja     802315 <vprintfmt+0x47b>
  8022fd:	89 c2                	mov    %eax,%edx
  8022ff:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802303:	83 c0 08             	add    $0x8,%eax
  802306:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802309:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  80230b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802310:	e9 4a 01 00 00       	jmp    80245f <vprintfmt+0x5c5>
  802315:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802319:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80231d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802321:	eb e6                	jmp    802309 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  802323:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802326:	83 f8 2f             	cmp    $0x2f,%eax
  802329:	77 19                	ja     802344 <vprintfmt+0x4aa>
  80232b:	89 c2                	mov    %eax,%edx
  80232d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802331:	83 c0 08             	add    $0x8,%eax
  802334:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802337:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80233a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80233f:	e9 1b 01 00 00       	jmp    80245f <vprintfmt+0x5c5>
  802344:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802348:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80234c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802350:	eb e5                	jmp    802337 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  802352:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802356:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80235a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80235e:	e9 56 ff ff ff       	jmp    8022b9 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  802363:	40 84 f6             	test   %sil,%sil
  802366:	75 2e                	jne    802396 <vprintfmt+0x4fc>
    switch (lflag) {
  802368:	85 d2                	test   %edx,%edx
  80236a:	74 59                	je     8023c5 <vprintfmt+0x52b>
  80236c:	83 fa 01             	cmp    $0x1,%edx
  80236f:	74 7f                	je     8023f0 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  802371:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802374:	83 f8 2f             	cmp    $0x2f,%eax
  802377:	0f 87 9f 00 00 00    	ja     80241c <vprintfmt+0x582>
  80237d:	89 c2                	mov    %eax,%edx
  80237f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802383:	83 c0 08             	add    $0x8,%eax
  802386:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802389:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80238c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  802391:	e9 c9 00 00 00       	jmp    80245f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  802396:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802399:	83 f8 2f             	cmp    $0x2f,%eax
  80239c:	77 19                	ja     8023b7 <vprintfmt+0x51d>
  80239e:	89 c2                	mov    %eax,%edx
  8023a0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023a4:	83 c0 08             	add    $0x8,%eax
  8023a7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023aa:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023ad:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8023b2:	e9 a8 00 00 00       	jmp    80245f <vprintfmt+0x5c5>
  8023b7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023bb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023bf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023c3:	eb e5                	jmp    8023aa <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8023c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023c8:	83 f8 2f             	cmp    $0x2f,%eax
  8023cb:	77 15                	ja     8023e2 <vprintfmt+0x548>
  8023cd:	89 c2                	mov    %eax,%edx
  8023cf:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023d3:	83 c0 08             	add    $0x8,%eax
  8023d6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023d9:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8023db:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8023e0:	eb 7d                	jmp    80245f <vprintfmt+0x5c5>
  8023e2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023e6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023ea:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023ee:	eb e9                	jmp    8023d9 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8023f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023f3:	83 f8 2f             	cmp    $0x2f,%eax
  8023f6:	77 16                	ja     80240e <vprintfmt+0x574>
  8023f8:	89 c2                	mov    %eax,%edx
  8023fa:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023fe:	83 c0 08             	add    $0x8,%eax
  802401:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802404:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  802407:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  80240c:	eb 51                	jmp    80245f <vprintfmt+0x5c5>
  80240e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802412:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802416:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80241a:	eb e8                	jmp    802404 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  80241c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802420:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802424:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802428:	e9 5c ff ff ff       	jmp    802389 <vprintfmt+0x4ef>
            putch('0', put_arg);
  80242d:	4c 89 ee             	mov    %r13,%rsi
  802430:	bf 30 00 00 00       	mov    $0x30,%edi
  802435:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  802438:	4c 89 ee             	mov    %r13,%rsi
  80243b:	bf 78 00 00 00       	mov    $0x78,%edi
  802440:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  802443:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802446:	83 f8 2f             	cmp    $0x2f,%eax
  802449:	77 47                	ja     802492 <vprintfmt+0x5f8>
  80244b:	89 c2                	mov    %eax,%edx
  80244d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802451:	83 c0 08             	add    $0x8,%eax
  802454:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802457:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80245a:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80245f:	48 83 ec 08          	sub    $0x8,%rsp
  802463:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  802467:	0f 94 c0             	sete   %al
  80246a:	0f b6 c0             	movzbl %al,%eax
  80246d:	50                   	push   %rax
  80246e:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  802473:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  802477:	4c 89 ee             	mov    %r13,%rsi
  80247a:	4c 89 f7             	mov    %r14,%rdi
  80247d:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  802484:	00 00 00 
  802487:	ff d0                	call   *%rax
            break;
  802489:	48 83 c4 10          	add    $0x10,%rsp
  80248d:	e9 3d fa ff ff       	jmp    801ecf <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  802492:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802496:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80249a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80249e:	eb b7                	jmp    802457 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  8024a0:	40 84 f6             	test   %sil,%sil
  8024a3:	75 2b                	jne    8024d0 <vprintfmt+0x636>
    switch (lflag) {
  8024a5:	85 d2                	test   %edx,%edx
  8024a7:	74 56                	je     8024ff <vprintfmt+0x665>
  8024a9:	83 fa 01             	cmp    $0x1,%edx
  8024ac:	74 7f                	je     80252d <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  8024ae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024b1:	83 f8 2f             	cmp    $0x2f,%eax
  8024b4:	0f 87 a2 00 00 00    	ja     80255c <vprintfmt+0x6c2>
  8024ba:	89 c2                	mov    %eax,%edx
  8024bc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024c0:	83 c0 08             	add    $0x8,%eax
  8024c3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024c6:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024c9:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8024ce:	eb 8f                	jmp    80245f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8024d0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024d3:	83 f8 2f             	cmp    $0x2f,%eax
  8024d6:	77 19                	ja     8024f1 <vprintfmt+0x657>
  8024d8:	89 c2                	mov    %eax,%edx
  8024da:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024de:	83 c0 08             	add    $0x8,%eax
  8024e1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024e4:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024e7:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8024ec:	e9 6e ff ff ff       	jmp    80245f <vprintfmt+0x5c5>
  8024f1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024f5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8024f9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024fd:	eb e5                	jmp    8024e4 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8024ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802502:	83 f8 2f             	cmp    $0x2f,%eax
  802505:	77 18                	ja     80251f <vprintfmt+0x685>
  802507:	89 c2                	mov    %eax,%edx
  802509:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80250d:	83 c0 08             	add    $0x8,%eax
  802510:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802513:	8b 12                	mov    (%rdx),%edx
            base = 16;
  802515:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  80251a:	e9 40 ff ff ff       	jmp    80245f <vprintfmt+0x5c5>
  80251f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802523:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802527:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80252b:	eb e6                	jmp    802513 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  80252d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802530:	83 f8 2f             	cmp    $0x2f,%eax
  802533:	77 19                	ja     80254e <vprintfmt+0x6b4>
  802535:	89 c2                	mov    %eax,%edx
  802537:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80253b:	83 c0 08             	add    $0x8,%eax
  80253e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802541:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802544:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  802549:	e9 11 ff ff ff       	jmp    80245f <vprintfmt+0x5c5>
  80254e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802552:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802556:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80255a:	eb e5                	jmp    802541 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  80255c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802560:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802564:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802568:	e9 59 ff ff ff       	jmp    8024c6 <vprintfmt+0x62c>
            putch(ch, put_arg);
  80256d:	4c 89 ee             	mov    %r13,%rsi
  802570:	bf 25 00 00 00       	mov    $0x25,%edi
  802575:	41 ff d6             	call   *%r14
            break;
  802578:	e9 52 f9 ff ff       	jmp    801ecf <vprintfmt+0x35>
            putch('%', put_arg);
  80257d:	4c 89 ee             	mov    %r13,%rsi
  802580:	bf 25 00 00 00       	mov    $0x25,%edi
  802585:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  802588:	48 83 eb 01          	sub    $0x1,%rbx
  80258c:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  802590:	75 f6                	jne    802588 <vprintfmt+0x6ee>
  802592:	e9 38 f9 ff ff       	jmp    801ecf <vprintfmt+0x35>
}
  802597:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80259b:	5b                   	pop    %rbx
  80259c:	41 5c                	pop    %r12
  80259e:	41 5d                	pop    %r13
  8025a0:	41 5e                	pop    %r14
  8025a2:	41 5f                	pop    %r15
  8025a4:	5d                   	pop    %rbp
  8025a5:	c3                   	ret

00000000008025a6 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  8025a6:	f3 0f 1e fa          	endbr64
  8025aa:	55                   	push   %rbp
  8025ab:	48 89 e5             	mov    %rsp,%rbp
  8025ae:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  8025b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025b6:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  8025bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8025bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8025c6:	48 85 ff             	test   %rdi,%rdi
  8025c9:	74 2b                	je     8025f6 <vsnprintf+0x50>
  8025cb:	48 85 f6             	test   %rsi,%rsi
  8025ce:	74 26                	je     8025f6 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8025d0:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8025d4:	48 bf 3d 1e 80 00 00 	movabs $0x801e3d,%rdi
  8025db:	00 00 00 
  8025de:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  8025e5:	00 00 00 
  8025e8:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8025ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ee:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8025f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025f4:	c9                   	leave
  8025f5:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  8025f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025fb:	eb f7                	jmp    8025f4 <vsnprintf+0x4e>

00000000008025fd <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8025fd:	f3 0f 1e fa          	endbr64
  802601:	55                   	push   %rbp
  802602:	48 89 e5             	mov    %rsp,%rbp
  802605:	48 83 ec 50          	sub    $0x50,%rsp
  802609:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80260d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802611:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802615:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80261c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802620:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802624:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802628:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  80262c:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  802630:	48 b8 a6 25 80 00 00 	movabs $0x8025a6,%rax
  802637:	00 00 00 
  80263a:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  80263c:	c9                   	leave
  80263d:	c3                   	ret

000000000080263e <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  80263e:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  802642:	80 3f 00             	cmpb   $0x0,(%rdi)
  802645:	74 10                	je     802657 <strlen+0x19>
    size_t n = 0;
  802647:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  80264c:	48 83 c0 01          	add    $0x1,%rax
  802650:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  802654:	75 f6                	jne    80264c <strlen+0xe>
  802656:	c3                   	ret
    size_t n = 0;
  802657:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  80265c:	c3                   	ret

000000000080265d <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  80265d:	f3 0f 1e fa          	endbr64
  802661:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  802664:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  802669:	48 85 f6             	test   %rsi,%rsi
  80266c:	74 10                	je     80267e <strnlen+0x21>
  80266e:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  802672:	74 0b                	je     80267f <strnlen+0x22>
  802674:	48 83 c2 01          	add    $0x1,%rdx
  802678:	48 39 d0             	cmp    %rdx,%rax
  80267b:	75 f1                	jne    80266e <strnlen+0x11>
  80267d:	c3                   	ret
  80267e:	c3                   	ret
  80267f:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  802682:	c3                   	ret

0000000000802683 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  802683:	f3 0f 1e fa          	endbr64
  802687:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80268a:	ba 00 00 00 00       	mov    $0x0,%edx
  80268f:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  802693:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  802696:	48 83 c2 01          	add    $0x1,%rdx
  80269a:	84 c9                	test   %cl,%cl
  80269c:	75 f1                	jne    80268f <strcpy+0xc>
        ;
    return res;
}
  80269e:	c3                   	ret

000000000080269f <strcat>:

char *
strcat(char *dst, const char *src) {
  80269f:	f3 0f 1e fa          	endbr64
  8026a3:	55                   	push   %rbp
  8026a4:	48 89 e5             	mov    %rsp,%rbp
  8026a7:	41 54                	push   %r12
  8026a9:	53                   	push   %rbx
  8026aa:	48 89 fb             	mov    %rdi,%rbx
  8026ad:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8026b0:	48 b8 3e 26 80 00 00 	movabs $0x80263e,%rax
  8026b7:	00 00 00 
  8026ba:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  8026bc:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8026c0:	4c 89 e6             	mov    %r12,%rsi
  8026c3:	48 b8 83 26 80 00 00 	movabs $0x802683,%rax
  8026ca:	00 00 00 
  8026cd:	ff d0                	call   *%rax
    return dst;
}
  8026cf:	48 89 d8             	mov    %rbx,%rax
  8026d2:	5b                   	pop    %rbx
  8026d3:	41 5c                	pop    %r12
  8026d5:	5d                   	pop    %rbp
  8026d6:	c3                   	ret

00000000008026d7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8026d7:	f3 0f 1e fa          	endbr64
  8026db:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  8026de:	48 85 d2             	test   %rdx,%rdx
  8026e1:	74 1f                	je     802702 <strncpy+0x2b>
  8026e3:	48 01 fa             	add    %rdi,%rdx
  8026e6:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  8026e9:	48 83 c1 01          	add    $0x1,%rcx
  8026ed:	44 0f b6 06          	movzbl (%rsi),%r8d
  8026f1:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  8026f5:	41 80 f8 01          	cmp    $0x1,%r8b
  8026f9:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8026fd:	48 39 ca             	cmp    %rcx,%rdx
  802700:	75 e7                	jne    8026e9 <strncpy+0x12>
    }
    return ret;
}
  802702:	c3                   	ret

0000000000802703 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  802703:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  802707:	48 89 f8             	mov    %rdi,%rax
  80270a:	48 85 d2             	test   %rdx,%rdx
  80270d:	74 24                	je     802733 <strlcpy+0x30>
        while (--size > 0 && *src)
  80270f:	48 83 ea 01          	sub    $0x1,%rdx
  802713:	74 1b                	je     802730 <strlcpy+0x2d>
  802715:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802719:	0f b6 16             	movzbl (%rsi),%edx
  80271c:	84 d2                	test   %dl,%dl
  80271e:	74 10                	je     802730 <strlcpy+0x2d>
            *dst++ = *src++;
  802720:	48 83 c6 01          	add    $0x1,%rsi
  802724:	48 83 c0 01          	add    $0x1,%rax
  802728:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80272b:	48 39 c8             	cmp    %rcx,%rax
  80272e:	75 e9                	jne    802719 <strlcpy+0x16>
        *dst = '\0';
  802730:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  802733:	48 29 f8             	sub    %rdi,%rax
}
  802736:	c3                   	ret

0000000000802737 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  802737:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  80273b:	0f b6 07             	movzbl (%rdi),%eax
  80273e:	84 c0                	test   %al,%al
  802740:	74 13                	je     802755 <strcmp+0x1e>
  802742:	38 06                	cmp    %al,(%rsi)
  802744:	75 0f                	jne    802755 <strcmp+0x1e>
  802746:	48 83 c7 01          	add    $0x1,%rdi
  80274a:	48 83 c6 01          	add    $0x1,%rsi
  80274e:	0f b6 07             	movzbl (%rdi),%eax
  802751:	84 c0                	test   %al,%al
  802753:	75 ed                	jne    802742 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  802755:	0f b6 c0             	movzbl %al,%eax
  802758:	0f b6 16             	movzbl (%rsi),%edx
  80275b:	29 d0                	sub    %edx,%eax
}
  80275d:	c3                   	ret

000000000080275e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  80275e:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  802762:	48 85 d2             	test   %rdx,%rdx
  802765:	74 1f                	je     802786 <strncmp+0x28>
  802767:	0f b6 07             	movzbl (%rdi),%eax
  80276a:	84 c0                	test   %al,%al
  80276c:	74 1e                	je     80278c <strncmp+0x2e>
  80276e:	3a 06                	cmp    (%rsi),%al
  802770:	75 1a                	jne    80278c <strncmp+0x2e>
  802772:	48 83 c7 01          	add    $0x1,%rdi
  802776:	48 83 c6 01          	add    $0x1,%rsi
  80277a:	48 83 ea 01          	sub    $0x1,%rdx
  80277e:	75 e7                	jne    802767 <strncmp+0x9>

    if (!n) return 0;
  802780:	b8 00 00 00 00       	mov    $0x0,%eax
  802785:	c3                   	ret
  802786:	b8 00 00 00 00       	mov    $0x0,%eax
  80278b:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  80278c:	0f b6 07             	movzbl (%rdi),%eax
  80278f:	0f b6 16             	movzbl (%rsi),%edx
  802792:	29 d0                	sub    %edx,%eax
}
  802794:	c3                   	ret

0000000000802795 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  802795:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  802799:	0f b6 17             	movzbl (%rdi),%edx
  80279c:	84 d2                	test   %dl,%dl
  80279e:	74 18                	je     8027b8 <strchr+0x23>
        if (*str == c) {
  8027a0:	0f be d2             	movsbl %dl,%edx
  8027a3:	39 f2                	cmp    %esi,%edx
  8027a5:	74 17                	je     8027be <strchr+0x29>
    for (; *str; str++) {
  8027a7:	48 83 c7 01          	add    $0x1,%rdi
  8027ab:	0f b6 17             	movzbl (%rdi),%edx
  8027ae:	84 d2                	test   %dl,%dl
  8027b0:	75 ee                	jne    8027a0 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  8027b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b7:	c3                   	ret
  8027b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bd:	c3                   	ret
            return (char *)str;
  8027be:	48 89 f8             	mov    %rdi,%rax
}
  8027c1:	c3                   	ret

00000000008027c2 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  8027c2:	f3 0f 1e fa          	endbr64
  8027c6:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  8027c9:	0f b6 17             	movzbl (%rdi),%edx
  8027cc:	84 d2                	test   %dl,%dl
  8027ce:	74 13                	je     8027e3 <strfind+0x21>
  8027d0:	0f be d2             	movsbl %dl,%edx
  8027d3:	39 f2                	cmp    %esi,%edx
  8027d5:	74 0b                	je     8027e2 <strfind+0x20>
  8027d7:	48 83 c0 01          	add    $0x1,%rax
  8027db:	0f b6 10             	movzbl (%rax),%edx
  8027de:	84 d2                	test   %dl,%dl
  8027e0:	75 ee                	jne    8027d0 <strfind+0xe>
        ;
    return (char *)str;
}
  8027e2:	c3                   	ret
  8027e3:	c3                   	ret

00000000008027e4 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8027e4:	f3 0f 1e fa          	endbr64
  8027e8:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  8027eb:	48 89 f8             	mov    %rdi,%rax
  8027ee:	48 f7 d8             	neg    %rax
  8027f1:	83 e0 07             	and    $0x7,%eax
  8027f4:	49 89 d1             	mov    %rdx,%r9
  8027f7:	49 29 c1             	sub    %rax,%r9
  8027fa:	78 36                	js     802832 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8027fc:	40 0f b6 c6          	movzbl %sil,%eax
  802800:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  802807:	01 01 01 
  80280a:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80280e:	40 f6 c7 07          	test   $0x7,%dil
  802812:	75 38                	jne    80284c <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  802814:	4c 89 c9             	mov    %r9,%rcx
  802817:	48 c1 f9 03          	sar    $0x3,%rcx
  80281b:	74 0c                	je     802829 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80281d:	fc                   	cld
  80281e:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802821:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  802825:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  802829:	4d 85 c9             	test   %r9,%r9
  80282c:	75 45                	jne    802873 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  80282e:	4c 89 c0             	mov    %r8,%rax
  802831:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  802832:	48 85 d2             	test   %rdx,%rdx
  802835:	74 f7                	je     80282e <memset+0x4a>
  802837:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  80283a:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  80283d:	48 83 c0 01          	add    $0x1,%rax
  802841:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  802845:	48 39 c2             	cmp    %rax,%rdx
  802848:	75 f3                	jne    80283d <memset+0x59>
  80284a:	eb e2                	jmp    80282e <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  80284c:	40 f6 c7 01          	test   $0x1,%dil
  802850:	74 06                	je     802858 <memset+0x74>
  802852:	88 07                	mov    %al,(%rdi)
  802854:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  802858:	40 f6 c7 02          	test   $0x2,%dil
  80285c:	74 07                	je     802865 <memset+0x81>
  80285e:	66 89 07             	mov    %ax,(%rdi)
  802861:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  802865:	40 f6 c7 04          	test   $0x4,%dil
  802869:	74 a9                	je     802814 <memset+0x30>
  80286b:	89 07                	mov    %eax,(%rdi)
  80286d:	48 83 c7 04          	add    $0x4,%rdi
  802871:	eb a1                	jmp    802814 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  802873:	41 f6 c1 04          	test   $0x4,%r9b
  802877:	74 1b                	je     802894 <memset+0xb0>
  802879:	89 07                	mov    %eax,(%rdi)
  80287b:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80287f:	41 f6 c1 02          	test   $0x2,%r9b
  802883:	74 07                	je     80288c <memset+0xa8>
  802885:	66 89 07             	mov    %ax,(%rdi)
  802888:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80288c:	41 f6 c1 01          	test   $0x1,%r9b
  802890:	74 9c                	je     80282e <memset+0x4a>
  802892:	eb 06                	jmp    80289a <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  802894:	41 f6 c1 02          	test   $0x2,%r9b
  802898:	75 eb                	jne    802885 <memset+0xa1>
        if (ni & 1) *ptr = k;
  80289a:	88 07                	mov    %al,(%rdi)
  80289c:	eb 90                	jmp    80282e <memset+0x4a>

000000000080289e <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  80289e:	f3 0f 1e fa          	endbr64
  8028a2:	48 89 f8             	mov    %rdi,%rax
  8028a5:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8028a8:	48 39 fe             	cmp    %rdi,%rsi
  8028ab:	73 3b                	jae    8028e8 <memmove+0x4a>
  8028ad:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8028b1:	48 39 d7             	cmp    %rdx,%rdi
  8028b4:	73 32                	jae    8028e8 <memmove+0x4a>
        s += n;
        d += n;
  8028b6:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028ba:	48 89 d6             	mov    %rdx,%rsi
  8028bd:	48 09 fe             	or     %rdi,%rsi
  8028c0:	48 09 ce             	or     %rcx,%rsi
  8028c3:	40 f6 c6 07          	test   $0x7,%sil
  8028c7:	75 12                	jne    8028db <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8028c9:	48 83 ef 08          	sub    $0x8,%rdi
  8028cd:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8028d1:	48 c1 e9 03          	shr    $0x3,%rcx
  8028d5:	fd                   	std
  8028d6:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8028d9:	fc                   	cld
  8028da:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8028db:	48 83 ef 01          	sub    $0x1,%rdi
  8028df:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8028e3:	fd                   	std
  8028e4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8028e6:	eb f1                	jmp    8028d9 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028e8:	48 89 f2             	mov    %rsi,%rdx
  8028eb:	48 09 c2             	or     %rax,%rdx
  8028ee:	48 09 ca             	or     %rcx,%rdx
  8028f1:	f6 c2 07             	test   $0x7,%dl
  8028f4:	75 0c                	jne    802902 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8028f6:	48 c1 e9 03          	shr    $0x3,%rcx
  8028fa:	48 89 c7             	mov    %rax,%rdi
  8028fd:	fc                   	cld
  8028fe:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  802901:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  802902:	48 89 c7             	mov    %rax,%rdi
  802905:	fc                   	cld
  802906:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  802908:	c3                   	ret

0000000000802909 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  802909:	f3 0f 1e fa          	endbr64
  80290d:	55                   	push   %rbp
  80290e:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802911:	48 b8 9e 28 80 00 00 	movabs $0x80289e,%rax
  802918:	00 00 00 
  80291b:	ff d0                	call   *%rax
}
  80291d:	5d                   	pop    %rbp
  80291e:	c3                   	ret

000000000080291f <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80291f:	f3 0f 1e fa          	endbr64
  802923:	55                   	push   %rbp
  802924:	48 89 e5             	mov    %rsp,%rbp
  802927:	41 57                	push   %r15
  802929:	41 56                	push   %r14
  80292b:	41 55                	push   %r13
  80292d:	41 54                	push   %r12
  80292f:	53                   	push   %rbx
  802930:	48 83 ec 08          	sub    $0x8,%rsp
  802934:	49 89 fe             	mov    %rdi,%r14
  802937:	49 89 f7             	mov    %rsi,%r15
  80293a:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  80293d:	48 89 f7             	mov    %rsi,%rdi
  802940:	48 b8 3e 26 80 00 00 	movabs $0x80263e,%rax
  802947:	00 00 00 
  80294a:	ff d0                	call   *%rax
  80294c:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80294f:	48 89 de             	mov    %rbx,%rsi
  802952:	4c 89 f7             	mov    %r14,%rdi
  802955:	48 b8 5d 26 80 00 00 	movabs $0x80265d,%rax
  80295c:	00 00 00 
  80295f:	ff d0                	call   *%rax
  802961:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  802964:	48 39 c3             	cmp    %rax,%rbx
  802967:	74 36                	je     80299f <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  802969:	48 89 d8             	mov    %rbx,%rax
  80296c:	4c 29 e8             	sub    %r13,%rax
  80296f:	49 39 c4             	cmp    %rax,%r12
  802972:	73 31                	jae    8029a5 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  802974:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  802979:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80297d:	4c 89 fe             	mov    %r15,%rsi
  802980:	48 b8 09 29 80 00 00 	movabs $0x802909,%rax
  802987:	00 00 00 
  80298a:	ff d0                	call   *%rax
    return dstlen + srclen;
  80298c:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  802990:	48 83 c4 08          	add    $0x8,%rsp
  802994:	5b                   	pop    %rbx
  802995:	41 5c                	pop    %r12
  802997:	41 5d                	pop    %r13
  802999:	41 5e                	pop    %r14
  80299b:	41 5f                	pop    %r15
  80299d:	5d                   	pop    %rbp
  80299e:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  80299f:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  8029a3:	eb eb                	jmp    802990 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  8029a5:	48 83 eb 01          	sub    $0x1,%rbx
  8029a9:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8029ad:	48 89 da             	mov    %rbx,%rdx
  8029b0:	4c 89 fe             	mov    %r15,%rsi
  8029b3:	48 b8 09 29 80 00 00 	movabs $0x802909,%rax
  8029ba:	00 00 00 
  8029bd:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8029bf:	49 01 de             	add    %rbx,%r14
  8029c2:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8029c7:	eb c3                	jmp    80298c <strlcat+0x6d>

00000000008029c9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8029c9:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8029cd:	48 85 d2             	test   %rdx,%rdx
  8029d0:	74 2d                	je     8029ff <memcmp+0x36>
  8029d2:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8029d7:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8029db:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8029e0:	44 38 c1             	cmp    %r8b,%cl
  8029e3:	75 0f                	jne    8029f4 <memcmp+0x2b>
    while (n-- > 0) {
  8029e5:	48 83 c0 01          	add    $0x1,%rax
  8029e9:	48 39 c2             	cmp    %rax,%rdx
  8029ec:	75 e9                	jne    8029d7 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8029ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f3:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8029f4:	0f b6 c1             	movzbl %cl,%eax
  8029f7:	45 0f b6 c0          	movzbl %r8b,%r8d
  8029fb:	44 29 c0             	sub    %r8d,%eax
  8029fe:	c3                   	ret
    return 0;
  8029ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a04:	c3                   	ret

0000000000802a05 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  802a05:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  802a09:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802a0d:	48 39 c7             	cmp    %rax,%rdi
  802a10:	73 0f                	jae    802a21 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802a12:	40 38 37             	cmp    %sil,(%rdi)
  802a15:	74 0e                	je     802a25 <memfind+0x20>
    for (; src < end; src++) {
  802a17:	48 83 c7 01          	add    $0x1,%rdi
  802a1b:	48 39 f8             	cmp    %rdi,%rax
  802a1e:	75 f2                	jne    802a12 <memfind+0xd>
  802a20:	c3                   	ret
  802a21:	48 89 f8             	mov    %rdi,%rax
  802a24:	c3                   	ret
  802a25:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802a28:	c3                   	ret

0000000000802a29 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802a29:	f3 0f 1e fa          	endbr64
  802a2d:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802a30:	0f b6 37             	movzbl (%rdi),%esi
  802a33:	40 80 fe 20          	cmp    $0x20,%sil
  802a37:	74 06                	je     802a3f <strtol+0x16>
  802a39:	40 80 fe 09          	cmp    $0x9,%sil
  802a3d:	75 13                	jne    802a52 <strtol+0x29>
  802a3f:	48 83 c7 01          	add    $0x1,%rdi
  802a43:	0f b6 37             	movzbl (%rdi),%esi
  802a46:	40 80 fe 20          	cmp    $0x20,%sil
  802a4a:	74 f3                	je     802a3f <strtol+0x16>
  802a4c:	40 80 fe 09          	cmp    $0x9,%sil
  802a50:	74 ed                	je     802a3f <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802a52:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802a55:	83 e0 fd             	and    $0xfffffffd,%eax
  802a58:	3c 01                	cmp    $0x1,%al
  802a5a:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a5e:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  802a64:	75 0f                	jne    802a75 <strtol+0x4c>
  802a66:	80 3f 30             	cmpb   $0x30,(%rdi)
  802a69:	74 14                	je     802a7f <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802a6b:	85 d2                	test   %edx,%edx
  802a6d:	b8 0a 00 00 00       	mov    $0xa,%eax
  802a72:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  802a75:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  802a7a:	4c 63 ca             	movslq %edx,%r9
  802a7d:	eb 36                	jmp    802ab5 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a7f:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  802a83:	74 0f                	je     802a94 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  802a85:	85 d2                	test   %edx,%edx
  802a87:	75 ec                	jne    802a75 <strtol+0x4c>
        s++;
  802a89:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  802a8d:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  802a92:	eb e1                	jmp    802a75 <strtol+0x4c>
        s += 2;
  802a94:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  802a98:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  802a9d:	eb d6                	jmp    802a75 <strtol+0x4c>
            dig -= '0';
  802a9f:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  802aa2:	44 0f b6 c1          	movzbl %cl,%r8d
  802aa6:	41 39 d0             	cmp    %edx,%r8d
  802aa9:	7d 21                	jge    802acc <strtol+0xa3>
        val = val * base + dig;
  802aab:	49 0f af c1          	imul   %r9,%rax
  802aaf:	0f b6 c9             	movzbl %cl,%ecx
  802ab2:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  802ab5:	48 83 c7 01          	add    $0x1,%rdi
  802ab9:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  802abd:	80 f9 39             	cmp    $0x39,%cl
  802ac0:	76 dd                	jbe    802a9f <strtol+0x76>
        else if (dig - 'a' < 27)
  802ac2:	80 f9 7b             	cmp    $0x7b,%cl
  802ac5:	77 05                	ja     802acc <strtol+0xa3>
            dig -= 'a' - 10;
  802ac7:	83 e9 57             	sub    $0x57,%ecx
  802aca:	eb d6                	jmp    802aa2 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  802acc:	4d 85 d2             	test   %r10,%r10
  802acf:	74 03                	je     802ad4 <strtol+0xab>
  802ad1:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802ad4:	48 89 c2             	mov    %rax,%rdx
  802ad7:	48 f7 da             	neg    %rdx
  802ada:	40 80 fe 2d          	cmp    $0x2d,%sil
  802ade:	48 0f 44 c2          	cmove  %rdx,%rax
}
  802ae2:	c3                   	ret

0000000000802ae3 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802ae3:	f3 0f 1e fa          	endbr64
  802ae7:	55                   	push   %rbp
  802ae8:	48 89 e5             	mov    %rsp,%rbp
  802aeb:	41 54                	push   %r12
  802aed:	53                   	push   %rbx
  802aee:	48 89 fb             	mov    %rdi,%rbx
  802af1:	48 89 f7             	mov    %rsi,%rdi
  802af4:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802af7:	48 85 f6             	test   %rsi,%rsi
  802afa:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b01:	00 00 00 
  802b04:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b08:	be 00 10 00 00       	mov    $0x1000,%esi
  802b0d:	48 b8 d5 05 80 00 00 	movabs $0x8005d5,%rax
  802b14:	00 00 00 
  802b17:	ff d0                	call   *%rax
    if (res < 0) {
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	78 45                	js     802b62 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b1d:	48 85 db             	test   %rbx,%rbx
  802b20:	74 12                	je     802b34 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b22:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b29:	00 00 00 
  802b2c:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b32:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b34:	4d 85 e4             	test   %r12,%r12
  802b37:	74 14                	je     802b4d <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b39:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b40:	00 00 00 
  802b43:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b49:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b4d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b54:	00 00 00 
  802b57:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b5d:	5b                   	pop    %rbx
  802b5e:	41 5c                	pop    %r12
  802b60:	5d                   	pop    %rbp
  802b61:	c3                   	ret
        if (from_env_store != NULL) {
  802b62:	48 85 db             	test   %rbx,%rbx
  802b65:	74 06                	je     802b6d <ipc_recv+0x8a>
            *from_env_store = 0;
  802b67:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b6d:	4d 85 e4             	test   %r12,%r12
  802b70:	74 eb                	je     802b5d <ipc_recv+0x7a>
            *perm_store = 0;
  802b72:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b79:	00 
  802b7a:	eb e1                	jmp    802b5d <ipc_recv+0x7a>

0000000000802b7c <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b7c:	f3 0f 1e fa          	endbr64
  802b80:	55                   	push   %rbp
  802b81:	48 89 e5             	mov    %rsp,%rbp
  802b84:	41 57                	push   %r15
  802b86:	41 56                	push   %r14
  802b88:	41 55                	push   %r13
  802b8a:	41 54                	push   %r12
  802b8c:	53                   	push   %rbx
  802b8d:	48 83 ec 18          	sub    $0x18,%rsp
  802b91:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802b94:	48 89 d3             	mov    %rdx,%rbx
  802b97:	49 89 cc             	mov    %rcx,%r12
  802b9a:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b9d:	48 85 d2             	test   %rdx,%rdx
  802ba0:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802ba7:	00 00 00 
  802baa:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bae:	89 f0                	mov    %esi,%eax
  802bb0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802bb4:	48 89 da             	mov    %rbx,%rdx
  802bb7:	48 89 c6             	mov    %rax,%rsi
  802bba:	48 b8 a5 05 80 00 00 	movabs $0x8005a5,%rax
  802bc1:	00 00 00 
  802bc4:	ff d0                	call   *%rax
    while (res < 0) {
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	79 65                	jns    802c2f <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bca:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bcd:	75 33                	jne    802c02 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802bcf:	49 bf 18 02 80 00 00 	movabs $0x800218,%r15
  802bd6:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bd9:	49 be a5 05 80 00 00 	movabs $0x8005a5,%r14
  802be0:	00 00 00 
        sys_yield();
  802be3:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802be6:	45 89 e8             	mov    %r13d,%r8d
  802be9:	4c 89 e1             	mov    %r12,%rcx
  802bec:	48 89 da             	mov    %rbx,%rdx
  802bef:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802bf3:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802bf6:	41 ff d6             	call   *%r14
    while (res < 0) {
  802bf9:	85 c0                	test   %eax,%eax
  802bfb:	79 32                	jns    802c2f <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bfd:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c00:	74 e1                	je     802be3 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c02:	89 c1                	mov    %eax,%ecx
  802c04:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  802c0b:	00 00 00 
  802c0e:	be 42 00 00 00       	mov    $0x42,%esi
  802c13:	48 bf 4b 32 80 00 00 	movabs $0x80324b,%rdi
  802c1a:	00 00 00 
  802c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c22:	49 b8 de 1b 80 00 00 	movabs $0x801bde,%r8
  802c29:	00 00 00 
  802c2c:	41 ff d0             	call   *%r8
    }
}
  802c2f:	48 83 c4 18          	add    $0x18,%rsp
  802c33:	5b                   	pop    %rbx
  802c34:	41 5c                	pop    %r12
  802c36:	41 5d                	pop    %r13
  802c38:	41 5e                	pop    %r14
  802c3a:	41 5f                	pop    %r15
  802c3c:	5d                   	pop    %rbp
  802c3d:	c3                   	ret

0000000000802c3e <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c3e:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c42:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c47:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c4e:	00 00 00 
  802c51:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c55:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c59:	48 c1 e2 04          	shl    $0x4,%rdx
  802c5d:	48 01 ca             	add    %rcx,%rdx
  802c60:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c66:	39 fa                	cmp    %edi,%edx
  802c68:	74 12                	je     802c7c <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c6a:	48 83 c0 01          	add    $0x1,%rax
  802c6e:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c74:	75 db                	jne    802c51 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802c76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c7b:	c3                   	ret
            return envs[i].env_id;
  802c7c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c80:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c84:	48 c1 e2 04          	shl    $0x4,%rdx
  802c88:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802c8f:	00 00 00 
  802c92:	48 01 d0             	add    %rdx,%rax
  802c95:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c9b:	c3                   	ret

0000000000802c9c <__text_end>:
  802c9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ca3:	00 00 00 
  802ca6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cad:	00 00 00 
  802cb0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cb7:	00 00 00 
  802cba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cc1:	00 00 00 
  802cc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ccb:	00 00 00 
  802cce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cd5:	00 00 00 
  802cd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cdf:	00 00 00 
  802ce2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ce9:	00 00 00 
  802cec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cf3:	00 00 00 
  802cf6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cfd:	00 00 00 
  802d00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d07:	00 00 00 
  802d0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d11:	00 00 00 
  802d14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d1b:	00 00 00 
  802d1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d25:	00 00 00 
  802d28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d2f:	00 00 00 
  802d32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d39:	00 00 00 
  802d3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d43:	00 00 00 
  802d46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d4d:	00 00 00 
  802d50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d57:	00 00 00 
  802d5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d61:	00 00 00 
  802d64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d6b:	00 00 00 
  802d6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d75:	00 00 00 
  802d78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d7f:	00 00 00 
  802d82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d89:	00 00 00 
  802d8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d93:	00 00 00 
  802d96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d9d:	00 00 00 
  802da0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802da7:	00 00 00 
  802daa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802db1:	00 00 00 
  802db4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dbb:	00 00 00 
  802dbe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dc5:	00 00 00 
  802dc8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dcf:	00 00 00 
  802dd2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd9:	00 00 00 
  802ddc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de3:	00 00 00 
  802de6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ded:	00 00 00 
  802df0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df7:	00 00 00 
  802dfa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e01:	00 00 00 
  802e04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e0b:	00 00 00 
  802e0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e15:	00 00 00 
  802e18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e1f:	00 00 00 
  802e22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e29:	00 00 00 
  802e2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e33:	00 00 00 
  802e36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e3d:	00 00 00 
  802e40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e47:	00 00 00 
  802e4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e51:	00 00 00 
  802e54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e5b:	00 00 00 
  802e5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e65:	00 00 00 
  802e68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e6f:	00 00 00 
  802e72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e79:	00 00 00 
  802e7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e83:	00 00 00 
  802e86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e8d:	00 00 00 
  802e90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e97:	00 00 00 
  802e9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea1:	00 00 00 
  802ea4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eab:	00 00 00 
  802eae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb5:	00 00 00 
  802eb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ebf:	00 00 00 
  802ec2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec9:	00 00 00 
  802ecc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed3:	00 00 00 
  802ed6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802edd:	00 00 00 
  802ee0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee7:	00 00 00 
  802eea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef1:	00 00 00 
  802ef4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802efb:	00 00 00 
  802efe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f05:	00 00 00 
  802f08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f0f:	00 00 00 
  802f12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f19:	00 00 00 
  802f1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f23:	00 00 00 
  802f26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f2d:	00 00 00 
  802f30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f37:	00 00 00 
  802f3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f41:	00 00 00 
  802f44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f4b:	00 00 00 
  802f4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f55:	00 00 00 
  802f58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f5f:	00 00 00 
  802f62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f69:	00 00 00 
  802f6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f73:	00 00 00 
  802f76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f7d:	00 00 00 
  802f80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f87:	00 00 00 
  802f8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f91:	00 00 00 
  802f94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f9b:	00 00 00 
  802f9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa5:	00 00 00 
  802fa8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802faf:	00 00 00 
  802fb2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb9:	00 00 00 
  802fbc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc3:	00 00 00 
  802fc6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fcd:	00 00 00 
  802fd0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd7:	00 00 00 
  802fda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe1:	00 00 00 
  802fe4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802feb:	00 00 00 
  802fee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff5:	00 00 00 
  802ff8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802fff:	00 
