
obj/user/buggyhello:     file format elf64-x86-64


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
  80001e:	e8 22 00 00 00       	call   800045 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
 * kernel should destroy user environment in response */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
    sys_cputs((char *)1, 1);
  80002d:	be 01 00 00 00       	mov    $0x1,%esi
  800032:	bf 01 00 00 00       	mov    $0x1,%edi
  800037:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  80003e:	00 00 00 
  800041:	ff d0                	call   *%rax
}
  800043:	5d                   	pop    %rbp
  800044:	c3                   	ret

0000000000800045 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800045:	f3 0f 1e fa          	endbr64
  800049:	55                   	push   %rbp
  80004a:	48 89 e5             	mov    %rsp,%rbp
  80004d:	41 56                	push   %r14
  80004f:	41 55                	push   %r13
  800051:	41 54                	push   %r12
  800053:	53                   	push   %rbx
  800054:	41 89 fd             	mov    %edi,%r13d
  800057:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80005a:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800061:	00 00 00 
  800064:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80006b:	00 00 00 
  80006e:	48 39 c2             	cmp    %rax,%rdx
  800071:	73 17                	jae    80008a <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800073:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800076:	49 89 c4             	mov    %rax,%r12
  800079:	48 83 c3 08          	add    $0x8,%rbx
  80007d:	b8 00 00 00 00       	mov    $0x0,%eax
  800082:	ff 53 f8             	call   *-0x8(%rbx)
  800085:	4c 39 e3             	cmp    %r12,%rbx
  800088:	72 ef                	jb     800079 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  80008a:	48 b8 f3 01 80 00 00 	movabs $0x8001f3,%rax
  800091:	00 00 00 
  800094:	ff d0                	call   *%rax
  800096:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80009f:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000a3:	48 c1 e0 04          	shl    $0x4,%rax
  8000a7:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000ae:	00 00 00 
  8000b1:	48 01 d0             	add    %rdx,%rax
  8000b4:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000bb:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000be:	45 85 ed             	test   %r13d,%r13d
  8000c1:	7e 0d                	jle    8000d0 <libmain+0x8b>
  8000c3:	49 8b 06             	mov    (%r14),%rax
  8000c6:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000cd:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000d0:	4c 89 f6             	mov    %r14,%rsi
  8000d3:	44 89 ef             	mov    %r13d,%edi
  8000d6:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000e2:	48 b8 f7 00 80 00 00 	movabs $0x8000f7,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	call   *%rax
#endif
}
  8000ee:	5b                   	pop    %rbx
  8000ef:	41 5c                	pop    %r12
  8000f1:	41 5d                	pop    %r13
  8000f3:	41 5e                	pop    %r14
  8000f5:	5d                   	pop    %rbp
  8000f6:	c3                   	ret

00000000008000f7 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000f7:	f3 0f 1e fa          	endbr64
  8000fb:	55                   	push   %rbp
  8000fc:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000ff:	48 b8 c9 08 80 00 00 	movabs $0x8008c9,%rax
  800106:	00 00 00 
  800109:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80010b:	bf 00 00 00 00       	mov    $0x0,%edi
  800110:	48 b8 84 01 80 00 00 	movabs $0x800184,%rax
  800117:	00 00 00 
  80011a:	ff d0                	call   *%rax
}
  80011c:	5d                   	pop    %rbp
  80011d:	c3                   	ret

000000000080011e <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80011e:	f3 0f 1e fa          	endbr64
  800122:	55                   	push   %rbp
  800123:	48 89 e5             	mov    %rsp,%rbp
  800126:	53                   	push   %rbx
  800127:	48 89 fa             	mov    %rdi,%rdx
  80012a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80012d:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800132:	bb 00 00 00 00       	mov    $0x0,%ebx
  800137:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80013c:	be 00 00 00 00       	mov    $0x0,%esi
  800141:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800147:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800149:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80014d:	c9                   	leave
  80014e:	c3                   	ret

000000000080014f <sys_cgetc>:

int
sys_cgetc(void) {
  80014f:	f3 0f 1e fa          	endbr64
  800153:	55                   	push   %rbp
  800154:	48 89 e5             	mov    %rsp,%rbp
  800157:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800158:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80015d:	ba 00 00 00 00       	mov    $0x0,%edx
  800162:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800167:	bb 00 00 00 00       	mov    $0x0,%ebx
  80016c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800171:	be 00 00 00 00       	mov    $0x0,%esi
  800176:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80017c:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80017e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800182:	c9                   	leave
  800183:	c3                   	ret

0000000000800184 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800184:	f3 0f 1e fa          	endbr64
  800188:	55                   	push   %rbp
  800189:	48 89 e5             	mov    %rsp,%rbp
  80018c:	53                   	push   %rbx
  80018d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800191:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800194:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800199:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80019e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001a3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001a8:	be 00 00 00 00       	mov    $0x0,%esi
  8001ad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001b3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001b5:	48 85 c0             	test   %rax,%rax
  8001b8:	7f 06                	jg     8001c0 <sys_env_destroy+0x3c>
}
  8001ba:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001be:	c9                   	leave
  8001bf:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001c0:	49 89 c0             	mov    %rax,%r8
  8001c3:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001c8:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8001cf:	00 00 00 
  8001d2:	be 26 00 00 00       	mov    $0x26,%esi
  8001d7:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8001de:	00 00 00 
  8001e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e6:	49 b9 ee 1b 80 00 00 	movabs $0x801bee,%r9
  8001ed:	00 00 00 
  8001f0:	41 ff d1             	call   *%r9

00000000008001f3 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001f3:	f3 0f 1e fa          	endbr64
  8001f7:	55                   	push   %rbp
  8001f8:	48 89 e5             	mov    %rsp,%rbp
  8001fb:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001fc:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800201:	ba 00 00 00 00       	mov    $0x0,%edx
  800206:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80020b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800210:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800215:	be 00 00 00 00       	mov    $0x0,%esi
  80021a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800220:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800222:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800226:	c9                   	leave
  800227:	c3                   	ret

0000000000800228 <sys_yield>:

void
sys_yield(void) {
  800228:	f3 0f 1e fa          	endbr64
  80022c:	55                   	push   %rbp
  80022d:	48 89 e5             	mov    %rsp,%rbp
  800230:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800231:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800236:	ba 00 00 00 00       	mov    $0x0,%edx
  80023b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800240:	bb 00 00 00 00       	mov    $0x0,%ebx
  800245:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80024a:	be 00 00 00 00       	mov    $0x0,%esi
  80024f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800255:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  800257:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80025b:	c9                   	leave
  80025c:	c3                   	ret

000000000080025d <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80025d:	f3 0f 1e fa          	endbr64
  800261:	55                   	push   %rbp
  800262:	48 89 e5             	mov    %rsp,%rbp
  800265:	53                   	push   %rbx
  800266:	48 89 fa             	mov    %rdi,%rdx
  800269:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80026c:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800271:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800278:	00 00 00 
  80027b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800280:	be 00 00 00 00       	mov    $0x0,%esi
  800285:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80028b:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80028d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800291:	c9                   	leave
  800292:	c3                   	ret

0000000000800293 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  800293:	f3 0f 1e fa          	endbr64
  800297:	55                   	push   %rbp
  800298:	48 89 e5             	mov    %rsp,%rbp
  80029b:	53                   	push   %rbx
  80029c:	49 89 f8             	mov    %rdi,%r8
  80029f:	48 89 d3             	mov    %rdx,%rbx
  8002a2:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8002a5:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002aa:	4c 89 c2             	mov    %r8,%rdx
  8002ad:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002b0:	be 00 00 00 00       	mov    $0x0,%esi
  8002b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002bb:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002bd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002c1:	c9                   	leave
  8002c2:	c3                   	ret

00000000008002c3 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002c3:	f3 0f 1e fa          	endbr64
  8002c7:	55                   	push   %rbp
  8002c8:	48 89 e5             	mov    %rsp,%rbp
  8002cb:	53                   	push   %rbx
  8002cc:	48 83 ec 08          	sub    $0x8,%rsp
  8002d0:	89 f8                	mov    %edi,%eax
  8002d2:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002d5:	48 63 f9             	movslq %ecx,%rdi
  8002d8:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002db:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002e0:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002e3:	be 00 00 00 00       	mov    $0x0,%esi
  8002e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002ee:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002f0:	48 85 c0             	test   %rax,%rax
  8002f3:	7f 06                	jg     8002fb <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002f5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002f9:	c9                   	leave
  8002fa:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002fb:	49 89 c0             	mov    %rax,%r8
  8002fe:	b9 04 00 00 00       	mov    $0x4,%ecx
  800303:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80030a:	00 00 00 
  80030d:	be 26 00 00 00       	mov    $0x26,%esi
  800312:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800319:	00 00 00 
  80031c:	b8 00 00 00 00       	mov    $0x0,%eax
  800321:	49 b9 ee 1b 80 00 00 	movabs $0x801bee,%r9
  800328:	00 00 00 
  80032b:	41 ff d1             	call   *%r9

000000000080032e <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80032e:	f3 0f 1e fa          	endbr64
  800332:	55                   	push   %rbp
  800333:	48 89 e5             	mov    %rsp,%rbp
  800336:	53                   	push   %rbx
  800337:	48 83 ec 08          	sub    $0x8,%rsp
  80033b:	89 f8                	mov    %edi,%eax
  80033d:	49 89 f2             	mov    %rsi,%r10
  800340:	48 89 cf             	mov    %rcx,%rdi
  800343:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  800346:	48 63 da             	movslq %edx,%rbx
  800349:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80034c:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800351:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800354:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  800357:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800359:	48 85 c0             	test   %rax,%rax
  80035c:	7f 06                	jg     800364 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80035e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800362:	c9                   	leave
  800363:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800364:	49 89 c0             	mov    %rax,%r8
  800367:	b9 05 00 00 00       	mov    $0x5,%ecx
  80036c:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800373:	00 00 00 
  800376:	be 26 00 00 00       	mov    $0x26,%esi
  80037b:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800382:	00 00 00 
  800385:	b8 00 00 00 00       	mov    $0x0,%eax
  80038a:	49 b9 ee 1b 80 00 00 	movabs $0x801bee,%r9
  800391:	00 00 00 
  800394:	41 ff d1             	call   *%r9

0000000000800397 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  800397:	f3 0f 1e fa          	endbr64
  80039b:	55                   	push   %rbp
  80039c:	48 89 e5             	mov    %rsp,%rbp
  80039f:	53                   	push   %rbx
  8003a0:	48 83 ec 08          	sub    $0x8,%rsp
  8003a4:	49 89 f9             	mov    %rdi,%r9
  8003a7:	89 f0                	mov    %esi,%eax
  8003a9:	48 89 d3             	mov    %rdx,%rbx
  8003ac:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8003af:	49 63 f0             	movslq %r8d,%rsi
  8003b2:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8003b5:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8003ba:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003c3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003c5:	48 85 c0             	test   %rax,%rax
  8003c8:	7f 06                	jg     8003d0 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8003ca:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003ce:	c9                   	leave
  8003cf:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003d0:	49 89 c0             	mov    %rax,%r8
  8003d3:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003d8:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8003df:	00 00 00 
  8003e2:	be 26 00 00 00       	mov    $0x26,%esi
  8003e7:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8003ee:	00 00 00 
  8003f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f6:	49 b9 ee 1b 80 00 00 	movabs $0x801bee,%r9
  8003fd:	00 00 00 
  800400:	41 ff d1             	call   *%r9

0000000000800403 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  800403:	f3 0f 1e fa          	endbr64
  800407:	55                   	push   %rbp
  800408:	48 89 e5             	mov    %rsp,%rbp
  80040b:	53                   	push   %rbx
  80040c:	48 83 ec 08          	sub    $0x8,%rsp
  800410:	48 89 f1             	mov    %rsi,%rcx
  800413:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  800416:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800419:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80041e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800423:	be 00 00 00 00       	mov    $0x0,%esi
  800428:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80042e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800430:	48 85 c0             	test   %rax,%rax
  800433:	7f 06                	jg     80043b <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  800435:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800439:	c9                   	leave
  80043a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80043b:	49 89 c0             	mov    %rax,%r8
  80043e:	b9 07 00 00 00       	mov    $0x7,%ecx
  800443:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80044a:	00 00 00 
  80044d:	be 26 00 00 00       	mov    $0x26,%esi
  800452:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800459:	00 00 00 
  80045c:	b8 00 00 00 00       	mov    $0x0,%eax
  800461:	49 b9 ee 1b 80 00 00 	movabs $0x801bee,%r9
  800468:	00 00 00 
  80046b:	41 ff d1             	call   *%r9

000000000080046e <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80046e:	f3 0f 1e fa          	endbr64
  800472:	55                   	push   %rbp
  800473:	48 89 e5             	mov    %rsp,%rbp
  800476:	53                   	push   %rbx
  800477:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80047b:	48 63 ce             	movslq %esi,%rcx
  80047e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800481:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800486:	bb 00 00 00 00       	mov    $0x0,%ebx
  80048b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800490:	be 00 00 00 00       	mov    $0x0,%esi
  800495:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80049b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80049d:	48 85 c0             	test   %rax,%rax
  8004a0:	7f 06                	jg     8004a8 <sys_env_set_status+0x3a>
}
  8004a2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004a6:	c9                   	leave
  8004a7:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004a8:	49 89 c0             	mov    %rax,%r8
  8004ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8004b0:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8004b7:	00 00 00 
  8004ba:	be 26 00 00 00       	mov    $0x26,%esi
  8004bf:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8004c6:	00 00 00 
  8004c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ce:	49 b9 ee 1b 80 00 00 	movabs $0x801bee,%r9
  8004d5:	00 00 00 
  8004d8:	41 ff d1             	call   *%r9

00000000008004db <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8004db:	f3 0f 1e fa          	endbr64
  8004df:	55                   	push   %rbp
  8004e0:	48 89 e5             	mov    %rsp,%rbp
  8004e3:	53                   	push   %rbx
  8004e4:	48 83 ec 08          	sub    $0x8,%rsp
  8004e8:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8004eb:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004ee:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004f8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004fd:	be 00 00 00 00       	mov    $0x0,%esi
  800502:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800508:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80050a:	48 85 c0             	test   %rax,%rax
  80050d:	7f 06                	jg     800515 <sys_env_set_trapframe+0x3a>
}
  80050f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800513:	c9                   	leave
  800514:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800515:	49 89 c0             	mov    %rax,%r8
  800518:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80051d:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800524:	00 00 00 
  800527:	be 26 00 00 00       	mov    $0x26,%esi
  80052c:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800533:	00 00 00 
  800536:	b8 00 00 00 00       	mov    $0x0,%eax
  80053b:	49 b9 ee 1b 80 00 00 	movabs $0x801bee,%r9
  800542:	00 00 00 
  800545:	41 ff d1             	call   *%r9

0000000000800548 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  800548:	f3 0f 1e fa          	endbr64
  80054c:	55                   	push   %rbp
  80054d:	48 89 e5             	mov    %rsp,%rbp
  800550:	53                   	push   %rbx
  800551:	48 83 ec 08          	sub    $0x8,%rsp
  800555:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  800558:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80055b:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800560:	bb 00 00 00 00       	mov    $0x0,%ebx
  800565:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80056a:	be 00 00 00 00       	mov    $0x0,%esi
  80056f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800575:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800577:	48 85 c0             	test   %rax,%rax
  80057a:	7f 06                	jg     800582 <sys_env_set_pgfault_upcall+0x3a>
}
  80057c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800580:	c9                   	leave
  800581:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800582:	49 89 c0             	mov    %rax,%r8
  800585:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80058a:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800591:	00 00 00 
  800594:	be 26 00 00 00       	mov    $0x26,%esi
  800599:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8005a0:	00 00 00 
  8005a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a8:	49 b9 ee 1b 80 00 00 	movabs $0x801bee,%r9
  8005af:	00 00 00 
  8005b2:	41 ff d1             	call   *%r9

00000000008005b5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8005b5:	f3 0f 1e fa          	endbr64
  8005b9:	55                   	push   %rbp
  8005ba:	48 89 e5             	mov    %rsp,%rbp
  8005bd:	53                   	push   %rbx
  8005be:	89 f8                	mov    %edi,%eax
  8005c0:	49 89 f1             	mov    %rsi,%r9
  8005c3:	48 89 d3             	mov    %rdx,%rbx
  8005c6:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8005c9:	49 63 f0             	movslq %r8d,%rsi
  8005cc:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8005cf:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005d4:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005dd:	cd 30                	int    $0x30
}
  8005df:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005e3:	c9                   	leave
  8005e4:	c3                   	ret

00000000008005e5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8005e5:	f3 0f 1e fa          	endbr64
  8005e9:	55                   	push   %rbp
  8005ea:	48 89 e5             	mov    %rsp,%rbp
  8005ed:	53                   	push   %rbx
  8005ee:	48 83 ec 08          	sub    $0x8,%rsp
  8005f2:	48 89 fa             	mov    %rdi,%rdx
  8005f5:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8005f8:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800602:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800607:	be 00 00 00 00       	mov    $0x0,%esi
  80060c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800612:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800614:	48 85 c0             	test   %rax,%rax
  800617:	7f 06                	jg     80061f <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800619:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80061d:	c9                   	leave
  80061e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80061f:	49 89 c0             	mov    %rax,%r8
  800622:	b9 0f 00 00 00       	mov    $0xf,%ecx
  800627:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80062e:	00 00 00 
  800631:	be 26 00 00 00       	mov    $0x26,%esi
  800636:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80063d:	00 00 00 
  800640:	b8 00 00 00 00       	mov    $0x0,%eax
  800645:	49 b9 ee 1b 80 00 00 	movabs $0x801bee,%r9
  80064c:	00 00 00 
  80064f:	41 ff d1             	call   *%r9

0000000000800652 <sys_gettime>:

int
sys_gettime(void) {
  800652:	f3 0f 1e fa          	endbr64
  800656:	55                   	push   %rbp
  800657:	48 89 e5             	mov    %rsp,%rbp
  80065a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80065b:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800660:	ba 00 00 00 00       	mov    $0x0,%edx
  800665:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80066a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80066f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800674:	be 00 00 00 00       	mov    $0x0,%esi
  800679:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80067f:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  800681:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800685:	c9                   	leave
  800686:	c3                   	ret

0000000000800687 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  800687:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80068b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800692:	ff ff ff 
  800695:	48 01 f8             	add    %rdi,%rax
  800698:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80069c:	c3                   	ret

000000000080069d <fd2data>:

char *
fd2data(struct Fd *fd) {
  80069d:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8006a1:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8006a8:	ff ff ff 
  8006ab:	48 01 f8             	add    %rdi,%rax
  8006ae:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8006b2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8006b8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006bc:	c3                   	ret

00000000008006bd <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8006bd:	f3 0f 1e fa          	endbr64
  8006c1:	55                   	push   %rbp
  8006c2:	48 89 e5             	mov    %rsp,%rbp
  8006c5:	41 57                	push   %r15
  8006c7:	41 56                	push   %r14
  8006c9:	41 55                	push   %r13
  8006cb:	41 54                	push   %r12
  8006cd:	53                   	push   %rbx
  8006ce:	48 83 ec 08          	sub    $0x8,%rsp
  8006d2:	49 89 ff             	mov    %rdi,%r15
  8006d5:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8006da:	49 bd 1c 18 80 00 00 	movabs $0x80181c,%r13
  8006e1:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8006e4:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8006ea:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8006ed:	48 89 df             	mov    %rbx,%rdi
  8006f0:	41 ff d5             	call   *%r13
  8006f3:	83 e0 04             	and    $0x4,%eax
  8006f6:	74 17                	je     80070f <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8006f8:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8006ff:	4c 39 f3             	cmp    %r14,%rbx
  800702:	75 e6                	jne    8006ea <fd_alloc+0x2d>
  800704:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  80070a:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  80070f:	4d 89 27             	mov    %r12,(%r15)
}
  800712:	48 83 c4 08          	add    $0x8,%rsp
  800716:	5b                   	pop    %rbx
  800717:	41 5c                	pop    %r12
  800719:	41 5d                	pop    %r13
  80071b:	41 5e                	pop    %r14
  80071d:	41 5f                	pop    %r15
  80071f:	5d                   	pop    %rbp
  800720:	c3                   	ret

0000000000800721 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  800721:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  800725:	83 ff 1f             	cmp    $0x1f,%edi
  800728:	77 39                	ja     800763 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80072a:	55                   	push   %rbp
  80072b:	48 89 e5             	mov    %rsp,%rbp
  80072e:	41 54                	push   %r12
  800730:	53                   	push   %rbx
  800731:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  800734:	48 63 df             	movslq %edi,%rbx
  800737:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80073e:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800742:	48 89 df             	mov    %rbx,%rdi
  800745:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  80074c:	00 00 00 
  80074f:	ff d0                	call   *%rax
  800751:	a8 04                	test   $0x4,%al
  800753:	74 14                	je     800769 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  800755:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  800759:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80075e:	5b                   	pop    %rbx
  80075f:	41 5c                	pop    %r12
  800761:	5d                   	pop    %rbp
  800762:	c3                   	ret
        return -E_INVAL;
  800763:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800768:	c3                   	ret
        return -E_INVAL;
  800769:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80076e:	eb ee                	jmp    80075e <fd_lookup+0x3d>

0000000000800770 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  800770:	f3 0f 1e fa          	endbr64
  800774:	55                   	push   %rbp
  800775:	48 89 e5             	mov    %rsp,%rbp
  800778:	41 54                	push   %r12
  80077a:	53                   	push   %rbx
  80077b:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  80077e:	48 b8 40 33 80 00 00 	movabs $0x803340,%rax
  800785:	00 00 00 
  800788:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  80078f:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  800792:	39 3b                	cmp    %edi,(%rbx)
  800794:	74 47                	je     8007dd <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  800796:	48 83 c0 08          	add    $0x8,%rax
  80079a:	48 8b 18             	mov    (%rax),%rbx
  80079d:	48 85 db             	test   %rbx,%rbx
  8007a0:	75 f0                	jne    800792 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8007a2:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8007a9:	00 00 00 
  8007ac:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8007b2:	89 fa                	mov    %edi,%edx
  8007b4:	48 bf 78 32 80 00 00 	movabs $0x803278,%rdi
  8007bb:	00 00 00 
  8007be:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c3:	48 b9 4a 1d 80 00 00 	movabs $0x801d4a,%rcx
  8007ca:	00 00 00 
  8007cd:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8007cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8007d4:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8007d8:	5b                   	pop    %rbx
  8007d9:	41 5c                	pop    %r12
  8007db:	5d                   	pop    %rbp
  8007dc:	c3                   	ret
            return 0;
  8007dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e2:	eb f0                	jmp    8007d4 <dev_lookup+0x64>

00000000008007e4 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8007e4:	f3 0f 1e fa          	endbr64
  8007e8:	55                   	push   %rbp
  8007e9:	48 89 e5             	mov    %rsp,%rbp
  8007ec:	41 55                	push   %r13
  8007ee:	41 54                	push   %r12
  8007f0:	53                   	push   %rbx
  8007f1:	48 83 ec 18          	sub    $0x18,%rsp
  8007f5:	48 89 fb             	mov    %rdi,%rbx
  8007f8:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8007fb:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  800802:	ff ff ff 
  800805:	48 01 df             	add    %rbx,%rdi
  800808:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80080c:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800810:	48 b8 21 07 80 00 00 	movabs $0x800721,%rax
  800817:	00 00 00 
  80081a:	ff d0                	call   *%rax
  80081c:	41 89 c5             	mov    %eax,%r13d
  80081f:	85 c0                	test   %eax,%eax
  800821:	78 06                	js     800829 <fd_close+0x45>
  800823:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  800827:	74 1a                	je     800843 <fd_close+0x5f>
        return (must_exist ? res : 0);
  800829:	45 84 e4             	test   %r12b,%r12b
  80082c:	b8 00 00 00 00       	mov    $0x0,%eax
  800831:	44 0f 44 e8          	cmove  %eax,%r13d
}
  800835:	44 89 e8             	mov    %r13d,%eax
  800838:	48 83 c4 18          	add    $0x18,%rsp
  80083c:	5b                   	pop    %rbx
  80083d:	41 5c                	pop    %r12
  80083f:	41 5d                	pop    %r13
  800841:	5d                   	pop    %rbp
  800842:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800843:	8b 3b                	mov    (%rbx),%edi
  800845:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800849:	48 b8 70 07 80 00 00 	movabs $0x800770,%rax
  800850:	00 00 00 
  800853:	ff d0                	call   *%rax
  800855:	41 89 c5             	mov    %eax,%r13d
  800858:	85 c0                	test   %eax,%eax
  80085a:	78 1b                	js     800877 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80085c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800860:	48 8b 40 20          	mov    0x20(%rax),%rax
  800864:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80086a:	48 85 c0             	test   %rax,%rax
  80086d:	74 08                	je     800877 <fd_close+0x93>
  80086f:	48 89 df             	mov    %rbx,%rdi
  800872:	ff d0                	call   *%rax
  800874:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  800877:	ba 00 10 00 00       	mov    $0x1000,%edx
  80087c:	48 89 de             	mov    %rbx,%rsi
  80087f:	bf 00 00 00 00       	mov    $0x0,%edi
  800884:	48 b8 03 04 80 00 00 	movabs $0x800403,%rax
  80088b:	00 00 00 
  80088e:	ff d0                	call   *%rax
    return res;
  800890:	eb a3                	jmp    800835 <fd_close+0x51>

0000000000800892 <close>:

int
close(int fdnum) {
  800892:	f3 0f 1e fa          	endbr64
  800896:	55                   	push   %rbp
  800897:	48 89 e5             	mov    %rsp,%rbp
  80089a:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80089e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8008a2:	48 b8 21 07 80 00 00 	movabs $0x800721,%rax
  8008a9:	00 00 00 
  8008ac:	ff d0                	call   *%rax
    if (res < 0) return res;
  8008ae:	85 c0                	test   %eax,%eax
  8008b0:	78 15                	js     8008c7 <close+0x35>

    return fd_close(fd, 1);
  8008b2:	be 01 00 00 00       	mov    $0x1,%esi
  8008b7:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8008bb:	48 b8 e4 07 80 00 00 	movabs $0x8007e4,%rax
  8008c2:	00 00 00 
  8008c5:	ff d0                	call   *%rax
}
  8008c7:	c9                   	leave
  8008c8:	c3                   	ret

00000000008008c9 <close_all>:

void
close_all(void) {
  8008c9:	f3 0f 1e fa          	endbr64
  8008cd:	55                   	push   %rbp
  8008ce:	48 89 e5             	mov    %rsp,%rbp
  8008d1:	41 54                	push   %r12
  8008d3:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8008d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008d9:	49 bc 92 08 80 00 00 	movabs $0x800892,%r12
  8008e0:	00 00 00 
  8008e3:	89 df                	mov    %ebx,%edi
  8008e5:	41 ff d4             	call   *%r12
  8008e8:	83 c3 01             	add    $0x1,%ebx
  8008eb:	83 fb 20             	cmp    $0x20,%ebx
  8008ee:	75 f3                	jne    8008e3 <close_all+0x1a>
}
  8008f0:	5b                   	pop    %rbx
  8008f1:	41 5c                	pop    %r12
  8008f3:	5d                   	pop    %rbp
  8008f4:	c3                   	ret

00000000008008f5 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8008f5:	f3 0f 1e fa          	endbr64
  8008f9:	55                   	push   %rbp
  8008fa:	48 89 e5             	mov    %rsp,%rbp
  8008fd:	41 57                	push   %r15
  8008ff:	41 56                	push   %r14
  800901:	41 55                	push   %r13
  800903:	41 54                	push   %r12
  800905:	53                   	push   %rbx
  800906:	48 83 ec 18          	sub    $0x18,%rsp
  80090a:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80090d:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  800911:	48 b8 21 07 80 00 00 	movabs $0x800721,%rax
  800918:	00 00 00 
  80091b:	ff d0                	call   *%rax
  80091d:	89 c3                	mov    %eax,%ebx
  80091f:	85 c0                	test   %eax,%eax
  800921:	0f 88 b8 00 00 00    	js     8009df <dup+0xea>
    close(newfdnum);
  800927:	44 89 e7             	mov    %r12d,%edi
  80092a:	48 b8 92 08 80 00 00 	movabs $0x800892,%rax
  800931:	00 00 00 
  800934:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  800936:	4d 63 ec             	movslq %r12d,%r13
  800939:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  800940:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  800944:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  800948:	4c 89 ff             	mov    %r15,%rdi
  80094b:	49 be 9d 06 80 00 00 	movabs $0x80069d,%r14
  800952:	00 00 00 
  800955:	41 ff d6             	call   *%r14
  800958:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  80095b:	4c 89 ef             	mov    %r13,%rdi
  80095e:	41 ff d6             	call   *%r14
  800961:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  800964:	48 89 df             	mov    %rbx,%rdi
  800967:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  80096e:	00 00 00 
  800971:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  800973:	a8 04                	test   $0x4,%al
  800975:	74 2b                	je     8009a2 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  800977:	41 89 c1             	mov    %eax,%r9d
  80097a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800980:	4c 89 f1             	mov    %r14,%rcx
  800983:	ba 00 00 00 00       	mov    $0x0,%edx
  800988:	48 89 de             	mov    %rbx,%rsi
  80098b:	bf 00 00 00 00       	mov    $0x0,%edi
  800990:	48 b8 2e 03 80 00 00 	movabs $0x80032e,%rax
  800997:	00 00 00 
  80099a:	ff d0                	call   *%rax
  80099c:	89 c3                	mov    %eax,%ebx
  80099e:	85 c0                	test   %eax,%eax
  8009a0:	78 4e                	js     8009f0 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  8009a2:	4c 89 ff             	mov    %r15,%rdi
  8009a5:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  8009ac:	00 00 00 
  8009af:	ff d0                	call   *%rax
  8009b1:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8009b4:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8009ba:	4c 89 e9             	mov    %r13,%rcx
  8009bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c2:	4c 89 fe             	mov    %r15,%rsi
  8009c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8009ca:	48 b8 2e 03 80 00 00 	movabs $0x80032e,%rax
  8009d1:	00 00 00 
  8009d4:	ff d0                	call   *%rax
  8009d6:	89 c3                	mov    %eax,%ebx
  8009d8:	85 c0                	test   %eax,%eax
  8009da:	78 14                	js     8009f0 <dup+0xfb>

    return newfdnum;
  8009dc:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8009df:	89 d8                	mov    %ebx,%eax
  8009e1:	48 83 c4 18          	add    $0x18,%rsp
  8009e5:	5b                   	pop    %rbx
  8009e6:	41 5c                	pop    %r12
  8009e8:	41 5d                	pop    %r13
  8009ea:	41 5e                	pop    %r14
  8009ec:	41 5f                	pop    %r15
  8009ee:	5d                   	pop    %rbp
  8009ef:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8009f0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009f5:	4c 89 ee             	mov    %r13,%rsi
  8009f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8009fd:	49 bc 03 04 80 00 00 	movabs $0x800403,%r12
  800a04:	00 00 00 
  800a07:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  800a0a:	ba 00 10 00 00       	mov    $0x1000,%edx
  800a0f:	4c 89 f6             	mov    %r14,%rsi
  800a12:	bf 00 00 00 00       	mov    $0x0,%edi
  800a17:	41 ff d4             	call   *%r12
    return res;
  800a1a:	eb c3                	jmp    8009df <dup+0xea>

0000000000800a1c <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800a1c:	f3 0f 1e fa          	endbr64
  800a20:	55                   	push   %rbp
  800a21:	48 89 e5             	mov    %rsp,%rbp
  800a24:	41 56                	push   %r14
  800a26:	41 55                	push   %r13
  800a28:	41 54                	push   %r12
  800a2a:	53                   	push   %rbx
  800a2b:	48 83 ec 10          	sub    $0x10,%rsp
  800a2f:	89 fb                	mov    %edi,%ebx
  800a31:	49 89 f4             	mov    %rsi,%r12
  800a34:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a37:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800a3b:	48 b8 21 07 80 00 00 	movabs $0x800721,%rax
  800a42:	00 00 00 
  800a45:	ff d0                	call   *%rax
  800a47:	85 c0                	test   %eax,%eax
  800a49:	78 4c                	js     800a97 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a4b:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800a4f:	41 8b 3e             	mov    (%r14),%edi
  800a52:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800a56:	48 b8 70 07 80 00 00 	movabs $0x800770,%rax
  800a5d:	00 00 00 
  800a60:	ff d0                	call   *%rax
  800a62:	85 c0                	test   %eax,%eax
  800a64:	78 35                	js     800a9b <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a66:	41 8b 46 08          	mov    0x8(%r14),%eax
  800a6a:	83 e0 03             	and    $0x3,%eax
  800a6d:	83 f8 01             	cmp    $0x1,%eax
  800a70:	74 2d                	je     800a9f <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800a72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a76:	48 8b 40 10          	mov    0x10(%rax),%rax
  800a7a:	48 85 c0             	test   %rax,%rax
  800a7d:	74 56                	je     800ad5 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  800a7f:	4c 89 ea             	mov    %r13,%rdx
  800a82:	4c 89 e6             	mov    %r12,%rsi
  800a85:	4c 89 f7             	mov    %r14,%rdi
  800a88:	ff d0                	call   *%rax
}
  800a8a:	48 83 c4 10          	add    $0x10,%rsp
  800a8e:	5b                   	pop    %rbx
  800a8f:	41 5c                	pop    %r12
  800a91:	41 5d                	pop    %r13
  800a93:	41 5e                	pop    %r14
  800a95:	5d                   	pop    %rbp
  800a96:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a97:	48 98                	cltq
  800a99:	eb ef                	jmp    800a8a <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a9b:	48 98                	cltq
  800a9d:	eb eb                	jmp    800a8a <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800a9f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800aa6:	00 00 00 
  800aa9:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800aaf:	89 da                	mov    %ebx,%edx
  800ab1:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  800ab8:	00 00 00 
  800abb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac0:	48 b9 4a 1d 80 00 00 	movabs $0x801d4a,%rcx
  800ac7:	00 00 00 
  800aca:	ff d1                	call   *%rcx
        return -E_INVAL;
  800acc:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800ad3:	eb b5                	jmp    800a8a <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800ad5:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800adc:	eb ac                	jmp    800a8a <read+0x6e>

0000000000800ade <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800ade:	f3 0f 1e fa          	endbr64
  800ae2:	55                   	push   %rbp
  800ae3:	48 89 e5             	mov    %rsp,%rbp
  800ae6:	41 57                	push   %r15
  800ae8:	41 56                	push   %r14
  800aea:	41 55                	push   %r13
  800aec:	41 54                	push   %r12
  800aee:	53                   	push   %rbx
  800aef:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800af3:	48 85 d2             	test   %rdx,%rdx
  800af6:	74 54                	je     800b4c <readn+0x6e>
  800af8:	41 89 fd             	mov    %edi,%r13d
  800afb:	49 89 f6             	mov    %rsi,%r14
  800afe:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800b01:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800b06:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800b0b:	49 bf 1c 0a 80 00 00 	movabs $0x800a1c,%r15
  800b12:	00 00 00 
  800b15:	4c 89 e2             	mov    %r12,%rdx
  800b18:	48 29 f2             	sub    %rsi,%rdx
  800b1b:	4c 01 f6             	add    %r14,%rsi
  800b1e:	44 89 ef             	mov    %r13d,%edi
  800b21:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800b24:	85 c0                	test   %eax,%eax
  800b26:	78 20                	js     800b48 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  800b28:	01 c3                	add    %eax,%ebx
  800b2a:	85 c0                	test   %eax,%eax
  800b2c:	74 08                	je     800b36 <readn+0x58>
  800b2e:	48 63 f3             	movslq %ebx,%rsi
  800b31:	4c 39 e6             	cmp    %r12,%rsi
  800b34:	72 df                	jb     800b15 <readn+0x37>
    }
    return res;
  800b36:	48 63 c3             	movslq %ebx,%rax
}
  800b39:	48 83 c4 08          	add    $0x8,%rsp
  800b3d:	5b                   	pop    %rbx
  800b3e:	41 5c                	pop    %r12
  800b40:	41 5d                	pop    %r13
  800b42:	41 5e                	pop    %r14
  800b44:	41 5f                	pop    %r15
  800b46:	5d                   	pop    %rbp
  800b47:	c3                   	ret
        if (inc < 0) return inc;
  800b48:	48 98                	cltq
  800b4a:	eb ed                	jmp    800b39 <readn+0x5b>
    int inc = 1, res = 0;
  800b4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b51:	eb e3                	jmp    800b36 <readn+0x58>

0000000000800b53 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800b53:	f3 0f 1e fa          	endbr64
  800b57:	55                   	push   %rbp
  800b58:	48 89 e5             	mov    %rsp,%rbp
  800b5b:	41 56                	push   %r14
  800b5d:	41 55                	push   %r13
  800b5f:	41 54                	push   %r12
  800b61:	53                   	push   %rbx
  800b62:	48 83 ec 10          	sub    $0x10,%rsp
  800b66:	89 fb                	mov    %edi,%ebx
  800b68:	49 89 f4             	mov    %rsi,%r12
  800b6b:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b6e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800b72:	48 b8 21 07 80 00 00 	movabs $0x800721,%rax
  800b79:	00 00 00 
  800b7c:	ff d0                	call   *%rax
  800b7e:	85 c0                	test   %eax,%eax
  800b80:	78 47                	js     800bc9 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b82:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800b86:	41 8b 3e             	mov    (%r14),%edi
  800b89:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800b8d:	48 b8 70 07 80 00 00 	movabs $0x800770,%rax
  800b94:	00 00 00 
  800b97:	ff d0                	call   *%rax
  800b99:	85 c0                	test   %eax,%eax
  800b9b:	78 30                	js     800bcd <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b9d:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  800ba2:	74 2d                	je     800bd1 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800ba4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ba8:	48 8b 40 18          	mov    0x18(%rax),%rax
  800bac:	48 85 c0             	test   %rax,%rax
  800baf:	74 56                	je     800c07 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  800bb1:	4c 89 ea             	mov    %r13,%rdx
  800bb4:	4c 89 e6             	mov    %r12,%rsi
  800bb7:	4c 89 f7             	mov    %r14,%rdi
  800bba:	ff d0                	call   *%rax
}
  800bbc:	48 83 c4 10          	add    $0x10,%rsp
  800bc0:	5b                   	pop    %rbx
  800bc1:	41 5c                	pop    %r12
  800bc3:	41 5d                	pop    %r13
  800bc5:	41 5e                	pop    %r14
  800bc7:	5d                   	pop    %rbp
  800bc8:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800bc9:	48 98                	cltq
  800bcb:	eb ef                	jmp    800bbc <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bcd:	48 98                	cltq
  800bcf:	eb eb                	jmp    800bbc <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800bd1:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bd8:	00 00 00 
  800bdb:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800be1:	89 da                	mov    %ebx,%edx
  800be3:	48 bf 34 30 80 00 00 	movabs $0x803034,%rdi
  800bea:	00 00 00 
  800bed:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf2:	48 b9 4a 1d 80 00 00 	movabs $0x801d4a,%rcx
  800bf9:	00 00 00 
  800bfc:	ff d1                	call   *%rcx
        return -E_INVAL;
  800bfe:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800c05:	eb b5                	jmp    800bbc <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800c07:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800c0e:	eb ac                	jmp    800bbc <write+0x69>

0000000000800c10 <seek>:

int
seek(int fdnum, off_t offset) {
  800c10:	f3 0f 1e fa          	endbr64
  800c14:	55                   	push   %rbp
  800c15:	48 89 e5             	mov    %rsp,%rbp
  800c18:	53                   	push   %rbx
  800c19:	48 83 ec 18          	sub    $0x18,%rsp
  800c1d:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c1f:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c23:	48 b8 21 07 80 00 00 	movabs $0x800721,%rax
  800c2a:	00 00 00 
  800c2d:	ff d0                	call   *%rax
  800c2f:	85 c0                	test   %eax,%eax
  800c31:	78 0c                	js     800c3f <seek+0x2f>

    fd->fd_offset = offset;
  800c33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c37:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800c3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c3f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c43:	c9                   	leave
  800c44:	c3                   	ret

0000000000800c45 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800c45:	f3 0f 1e fa          	endbr64
  800c49:	55                   	push   %rbp
  800c4a:	48 89 e5             	mov    %rsp,%rbp
  800c4d:	41 55                	push   %r13
  800c4f:	41 54                	push   %r12
  800c51:	53                   	push   %rbx
  800c52:	48 83 ec 18          	sub    $0x18,%rsp
  800c56:	89 fb                	mov    %edi,%ebx
  800c58:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c5b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800c5f:	48 b8 21 07 80 00 00 	movabs $0x800721,%rax
  800c66:	00 00 00 
  800c69:	ff d0                	call   *%rax
  800c6b:	85 c0                	test   %eax,%eax
  800c6d:	78 38                	js     800ca7 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c6f:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  800c73:	41 8b 7d 00          	mov    0x0(%r13),%edi
  800c77:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800c7b:	48 b8 70 07 80 00 00 	movabs $0x800770,%rax
  800c82:	00 00 00 
  800c85:	ff d0                	call   *%rax
  800c87:	85 c0                	test   %eax,%eax
  800c89:	78 1c                	js     800ca7 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c8b:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  800c90:	74 20                	je     800cb2 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c92:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c96:	48 8b 40 30          	mov    0x30(%rax),%rax
  800c9a:	48 85 c0             	test   %rax,%rax
  800c9d:	74 47                	je     800ce6 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  800c9f:	44 89 e6             	mov    %r12d,%esi
  800ca2:	4c 89 ef             	mov    %r13,%rdi
  800ca5:	ff d0                	call   *%rax
}
  800ca7:	48 83 c4 18          	add    $0x18,%rsp
  800cab:	5b                   	pop    %rbx
  800cac:	41 5c                	pop    %r12
  800cae:	41 5d                	pop    %r13
  800cb0:	5d                   	pop    %rbp
  800cb1:	c3                   	ret
                thisenv->env_id, fdnum);
  800cb2:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800cb9:	00 00 00 
  800cbc:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800cc2:	89 da                	mov    %ebx,%edx
  800cc4:	48 bf 98 32 80 00 00 	movabs $0x803298,%rdi
  800ccb:	00 00 00 
  800cce:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd3:	48 b9 4a 1d 80 00 00 	movabs $0x801d4a,%rcx
  800cda:	00 00 00 
  800cdd:	ff d1                	call   *%rcx
        return -E_INVAL;
  800cdf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ce4:	eb c1                	jmp    800ca7 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800ce6:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800ceb:	eb ba                	jmp    800ca7 <ftruncate+0x62>

0000000000800ced <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800ced:	f3 0f 1e fa          	endbr64
  800cf1:	55                   	push   %rbp
  800cf2:	48 89 e5             	mov    %rsp,%rbp
  800cf5:	41 54                	push   %r12
  800cf7:	53                   	push   %rbx
  800cf8:	48 83 ec 10          	sub    $0x10,%rsp
  800cfc:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800cff:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800d03:	48 b8 21 07 80 00 00 	movabs $0x800721,%rax
  800d0a:	00 00 00 
  800d0d:	ff d0                	call   *%rax
  800d0f:	85 c0                	test   %eax,%eax
  800d11:	78 4e                	js     800d61 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800d13:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  800d17:	41 8b 3c 24          	mov    (%r12),%edi
  800d1b:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800d1f:	48 b8 70 07 80 00 00 	movabs $0x800770,%rax
  800d26:	00 00 00 
  800d29:	ff d0                	call   *%rax
  800d2b:	85 c0                	test   %eax,%eax
  800d2d:	78 32                	js     800d61 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800d33:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800d38:	74 30                	je     800d6a <fstat+0x7d>

    stat->st_name[0] = 0;
  800d3a:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800d3d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800d44:	00 00 00 
    stat->st_isdir = 0;
  800d47:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800d4e:	00 00 00 
    stat->st_dev = dev;
  800d51:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800d58:	48 89 de             	mov    %rbx,%rsi
  800d5b:	4c 89 e7             	mov    %r12,%rdi
  800d5e:	ff 50 28             	call   *0x28(%rax)
}
  800d61:	48 83 c4 10          	add    $0x10,%rsp
  800d65:	5b                   	pop    %rbx
  800d66:	41 5c                	pop    %r12
  800d68:	5d                   	pop    %rbp
  800d69:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d6a:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800d6f:	eb f0                	jmp    800d61 <fstat+0x74>

0000000000800d71 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800d71:	f3 0f 1e fa          	endbr64
  800d75:	55                   	push   %rbp
  800d76:	48 89 e5             	mov    %rsp,%rbp
  800d79:	41 54                	push   %r12
  800d7b:	53                   	push   %rbx
  800d7c:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800d7f:	be 00 00 00 00       	mov    $0x0,%esi
  800d84:	48 b8 52 10 80 00 00 	movabs $0x801052,%rax
  800d8b:	00 00 00 
  800d8e:	ff d0                	call   *%rax
  800d90:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800d92:	85 c0                	test   %eax,%eax
  800d94:	78 25                	js     800dbb <stat+0x4a>

    int res = fstat(fd, stat);
  800d96:	4c 89 e6             	mov    %r12,%rsi
  800d99:	89 c7                	mov    %eax,%edi
  800d9b:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  800da2:	00 00 00 
  800da5:	ff d0                	call   *%rax
  800da7:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800daa:	89 df                	mov    %ebx,%edi
  800dac:	48 b8 92 08 80 00 00 	movabs $0x800892,%rax
  800db3:	00 00 00 
  800db6:	ff d0                	call   *%rax

    return res;
  800db8:	44 89 e3             	mov    %r12d,%ebx
}
  800dbb:	89 d8                	mov    %ebx,%eax
  800dbd:	5b                   	pop    %rbx
  800dbe:	41 5c                	pop    %r12
  800dc0:	5d                   	pop    %rbp
  800dc1:	c3                   	ret

0000000000800dc2 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800dc2:	f3 0f 1e fa          	endbr64
  800dc6:	55                   	push   %rbp
  800dc7:	48 89 e5             	mov    %rsp,%rbp
  800dca:	41 54                	push   %r12
  800dcc:	53                   	push   %rbx
  800dcd:	48 83 ec 10          	sub    $0x10,%rsp
  800dd1:	41 89 fc             	mov    %edi,%r12d
  800dd4:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800dd7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800dde:	00 00 00 
  800de1:	83 38 00             	cmpl   $0x0,(%rax)
  800de4:	74 6e                	je     800e54 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  800de6:	bf 03 00 00 00       	mov    $0x3,%edi
  800deb:	48 b8 4e 2c 80 00 00 	movabs $0x802c4e,%rax
  800df2:	00 00 00 
  800df5:	ff d0                	call   *%rax
  800df7:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800dfe:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800e00:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800e06:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800e0b:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800e12:	00 00 00 
  800e15:	44 89 e6             	mov    %r12d,%esi
  800e18:	89 c7                	mov    %eax,%edi
  800e1a:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  800e21:	00 00 00 
  800e24:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800e26:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800e2d:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800e2e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e33:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e37:	48 89 de             	mov    %rbx,%rsi
  800e3a:	bf 00 00 00 00       	mov    $0x0,%edi
  800e3f:	48 b8 f3 2a 80 00 00 	movabs $0x802af3,%rax
  800e46:	00 00 00 
  800e49:	ff d0                	call   *%rax
}
  800e4b:	48 83 c4 10          	add    $0x10,%rsp
  800e4f:	5b                   	pop    %rbx
  800e50:	41 5c                	pop    %r12
  800e52:	5d                   	pop    %rbp
  800e53:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800e54:	bf 03 00 00 00       	mov    $0x3,%edi
  800e59:	48 b8 4e 2c 80 00 00 	movabs $0x802c4e,%rax
  800e60:	00 00 00 
  800e63:	ff d0                	call   *%rax
  800e65:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e6c:	00 00 
  800e6e:	e9 73 ff ff ff       	jmp    800de6 <fsipc+0x24>

0000000000800e73 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800e73:	f3 0f 1e fa          	endbr64
  800e77:	55                   	push   %rbp
  800e78:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800e7b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e82:	00 00 00 
  800e85:	8b 57 0c             	mov    0xc(%rdi),%edx
  800e88:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800e8a:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800e8d:	be 00 00 00 00       	mov    $0x0,%esi
  800e92:	bf 02 00 00 00       	mov    $0x2,%edi
  800e97:	48 b8 c2 0d 80 00 00 	movabs $0x800dc2,%rax
  800e9e:	00 00 00 
  800ea1:	ff d0                	call   *%rax
}
  800ea3:	5d                   	pop    %rbp
  800ea4:	c3                   	ret

0000000000800ea5 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800ea5:	f3 0f 1e fa          	endbr64
  800ea9:	55                   	push   %rbp
  800eaa:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800ead:	8b 47 0c             	mov    0xc(%rdi),%eax
  800eb0:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800eb7:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800eb9:	be 00 00 00 00       	mov    $0x0,%esi
  800ebe:	bf 06 00 00 00       	mov    $0x6,%edi
  800ec3:	48 b8 c2 0d 80 00 00 	movabs $0x800dc2,%rax
  800eca:	00 00 00 
  800ecd:	ff d0                	call   *%rax
}
  800ecf:	5d                   	pop    %rbp
  800ed0:	c3                   	ret

0000000000800ed1 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800ed1:	f3 0f 1e fa          	endbr64
  800ed5:	55                   	push   %rbp
  800ed6:	48 89 e5             	mov    %rsp,%rbp
  800ed9:	41 54                	push   %r12
  800edb:	53                   	push   %rbx
  800edc:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800edf:	8b 47 0c             	mov    0xc(%rdi),%eax
  800ee2:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ee9:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800eeb:	be 00 00 00 00       	mov    $0x0,%esi
  800ef0:	bf 05 00 00 00       	mov    $0x5,%edi
  800ef5:	48 b8 c2 0d 80 00 00 	movabs $0x800dc2,%rax
  800efc:	00 00 00 
  800eff:	ff d0                	call   *%rax
    if (res < 0) return res;
  800f01:	85 c0                	test   %eax,%eax
  800f03:	78 3d                	js     800f42 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800f05:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  800f0c:	00 00 00 
  800f0f:	4c 89 e6             	mov    %r12,%rsi
  800f12:	48 89 df             	mov    %rbx,%rdi
  800f15:	48 b8 93 26 80 00 00 	movabs $0x802693,%rax
  800f1c:	00 00 00 
  800f1f:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800f21:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  800f28:	00 
  800f29:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800f2f:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  800f36:	00 
  800f37:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800f3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f42:	5b                   	pop    %rbx
  800f43:	41 5c                	pop    %r12
  800f45:	5d                   	pop    %rbp
  800f46:	c3                   	ret

0000000000800f47 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f47:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  800f4b:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  800f52:	77 41                	ja     800f95 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f54:	55                   	push   %rbp
  800f55:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  800f58:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f5f:	00 00 00 
  800f62:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f65:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  800f67:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  800f6b:	48 8d 78 10          	lea    0x10(%rax),%rdi
  800f6f:	48 b8 ae 28 80 00 00 	movabs $0x8028ae,%rax
  800f76:	00 00 00 
  800f79:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  800f7b:	be 00 00 00 00       	mov    $0x0,%esi
  800f80:	bf 04 00 00 00       	mov    $0x4,%edi
  800f85:	48 b8 c2 0d 80 00 00 	movabs $0x800dc2,%rax
  800f8c:	00 00 00 
  800f8f:	ff d0                	call   *%rax
  800f91:	48 98                	cltq
}
  800f93:	5d                   	pop    %rbp
  800f94:	c3                   	ret
        return -E_INVAL;
  800f95:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  800f9c:	c3                   	ret

0000000000800f9d <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800f9d:	f3 0f 1e fa          	endbr64
  800fa1:	55                   	push   %rbp
  800fa2:	48 89 e5             	mov    %rsp,%rbp
  800fa5:	41 55                	push   %r13
  800fa7:	41 54                	push   %r12
  800fa9:	53                   	push   %rbx
  800faa:	48 83 ec 08          	sub    $0x8,%rsp
  800fae:	49 89 f4             	mov    %rsi,%r12
  800fb1:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800fb4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800fbb:	00 00 00 
  800fbe:	8b 57 0c             	mov    0xc(%rdi),%edx
  800fc1:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  800fc3:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  800fc7:	be 00 00 00 00       	mov    $0x0,%esi
  800fcc:	bf 03 00 00 00       	mov    $0x3,%edi
  800fd1:	48 b8 c2 0d 80 00 00 	movabs $0x800dc2,%rax
  800fd8:	00 00 00 
  800fdb:	ff d0                	call   *%rax
  800fdd:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  800fe0:	4d 85 ed             	test   %r13,%r13
  800fe3:	78 2a                	js     80100f <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  800fe5:	4c 89 ea             	mov    %r13,%rdx
  800fe8:	4c 39 eb             	cmp    %r13,%rbx
  800feb:	72 30                	jb     80101d <devfile_read+0x80>
  800fed:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  800ff4:	7f 27                	jg     80101d <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  800ff6:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800ffd:	00 00 00 
  801000:	4c 89 e7             	mov    %r12,%rdi
  801003:	48 b8 ae 28 80 00 00 	movabs $0x8028ae,%rax
  80100a:	00 00 00 
  80100d:	ff d0                	call   *%rax
}
  80100f:	4c 89 e8             	mov    %r13,%rax
  801012:	48 83 c4 08          	add    $0x8,%rsp
  801016:	5b                   	pop    %rbx
  801017:	41 5c                	pop    %r12
  801019:	41 5d                	pop    %r13
  80101b:	5d                   	pop    %rbp
  80101c:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  80101d:	48 b9 51 30 80 00 00 	movabs $0x803051,%rcx
  801024:	00 00 00 
  801027:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  80102e:	00 00 00 
  801031:	be 7b 00 00 00       	mov    $0x7b,%esi
  801036:	48 bf 83 30 80 00 00 	movabs $0x803083,%rdi
  80103d:	00 00 00 
  801040:	b8 00 00 00 00       	mov    $0x0,%eax
  801045:	49 b8 ee 1b 80 00 00 	movabs $0x801bee,%r8
  80104c:	00 00 00 
  80104f:	41 ff d0             	call   *%r8

0000000000801052 <open>:
open(const char *path, int mode) {
  801052:	f3 0f 1e fa          	endbr64
  801056:	55                   	push   %rbp
  801057:	48 89 e5             	mov    %rsp,%rbp
  80105a:	41 55                	push   %r13
  80105c:	41 54                	push   %r12
  80105e:	53                   	push   %rbx
  80105f:	48 83 ec 18          	sub    $0x18,%rsp
  801063:	49 89 fc             	mov    %rdi,%r12
  801066:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801069:	48 b8 4e 26 80 00 00 	movabs $0x80264e,%rax
  801070:	00 00 00 
  801073:	ff d0                	call   *%rax
  801075:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80107b:	0f 87 8a 00 00 00    	ja     80110b <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801081:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801085:	48 b8 bd 06 80 00 00 	movabs $0x8006bd,%rax
  80108c:	00 00 00 
  80108f:	ff d0                	call   *%rax
  801091:	89 c3                	mov    %eax,%ebx
  801093:	85 c0                	test   %eax,%eax
  801095:	78 50                	js     8010e7 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  801097:	4c 89 e6             	mov    %r12,%rsi
  80109a:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  8010a1:	00 00 00 
  8010a4:	48 89 df             	mov    %rbx,%rdi
  8010a7:	48 b8 93 26 80 00 00 	movabs $0x802693,%rax
  8010ae:	00 00 00 
  8010b1:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8010b3:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8010ba:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8010be:	bf 01 00 00 00       	mov    $0x1,%edi
  8010c3:	48 b8 c2 0d 80 00 00 	movabs $0x800dc2,%rax
  8010ca:	00 00 00 
  8010cd:	ff d0                	call   *%rax
  8010cf:	89 c3                	mov    %eax,%ebx
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	78 1f                	js     8010f4 <open+0xa2>
    return fd2num(fd);
  8010d5:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010d9:	48 b8 87 06 80 00 00 	movabs $0x800687,%rax
  8010e0:	00 00 00 
  8010e3:	ff d0                	call   *%rax
  8010e5:	89 c3                	mov    %eax,%ebx
}
  8010e7:	89 d8                	mov    %ebx,%eax
  8010e9:	48 83 c4 18          	add    $0x18,%rsp
  8010ed:	5b                   	pop    %rbx
  8010ee:	41 5c                	pop    %r12
  8010f0:	41 5d                	pop    %r13
  8010f2:	5d                   	pop    %rbp
  8010f3:	c3                   	ret
        fd_close(fd, 0);
  8010f4:	be 00 00 00 00       	mov    $0x0,%esi
  8010f9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010fd:	48 b8 e4 07 80 00 00 	movabs $0x8007e4,%rax
  801104:	00 00 00 
  801107:	ff d0                	call   *%rax
        return res;
  801109:	eb dc                	jmp    8010e7 <open+0x95>
        return -E_BAD_PATH;
  80110b:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801110:	eb d5                	jmp    8010e7 <open+0x95>

0000000000801112 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801112:	f3 0f 1e fa          	endbr64
  801116:	55                   	push   %rbp
  801117:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80111a:	be 00 00 00 00       	mov    $0x0,%esi
  80111f:	bf 08 00 00 00       	mov    $0x8,%edi
  801124:	48 b8 c2 0d 80 00 00 	movabs $0x800dc2,%rax
  80112b:	00 00 00 
  80112e:	ff d0                	call   *%rax
}
  801130:	5d                   	pop    %rbp
  801131:	c3                   	ret

0000000000801132 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801132:	f3 0f 1e fa          	endbr64
  801136:	55                   	push   %rbp
  801137:	48 89 e5             	mov    %rsp,%rbp
  80113a:	41 54                	push   %r12
  80113c:	53                   	push   %rbx
  80113d:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801140:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  801147:	00 00 00 
  80114a:	ff d0                	call   *%rax
  80114c:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80114f:	48 be 8e 30 80 00 00 	movabs $0x80308e,%rsi
  801156:	00 00 00 
  801159:	48 89 df             	mov    %rbx,%rdi
  80115c:	48 b8 93 26 80 00 00 	movabs $0x802693,%rax
  801163:	00 00 00 
  801166:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801168:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80116d:	41 2b 04 24          	sub    (%r12),%eax
  801171:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801177:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80117e:	00 00 00 
    stat->st_dev = &devpipe;
  801181:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801188:	00 00 00 
  80118b:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801192:	b8 00 00 00 00       	mov    $0x0,%eax
  801197:	5b                   	pop    %rbx
  801198:	41 5c                	pop    %r12
  80119a:	5d                   	pop    %rbp
  80119b:	c3                   	ret

000000000080119c <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80119c:	f3 0f 1e fa          	endbr64
  8011a0:	55                   	push   %rbp
  8011a1:	48 89 e5             	mov    %rsp,%rbp
  8011a4:	41 54                	push   %r12
  8011a6:	53                   	push   %rbx
  8011a7:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8011aa:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011af:	48 89 fe             	mov    %rdi,%rsi
  8011b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8011b7:	49 bc 03 04 80 00 00 	movabs $0x800403,%r12
  8011be:	00 00 00 
  8011c1:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8011c4:	48 89 df             	mov    %rbx,%rdi
  8011c7:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  8011ce:	00 00 00 
  8011d1:	ff d0                	call   *%rax
  8011d3:	48 89 c6             	mov    %rax,%rsi
  8011d6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011db:	bf 00 00 00 00       	mov    $0x0,%edi
  8011e0:	41 ff d4             	call   *%r12
}
  8011e3:	5b                   	pop    %rbx
  8011e4:	41 5c                	pop    %r12
  8011e6:	5d                   	pop    %rbp
  8011e7:	c3                   	ret

00000000008011e8 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8011e8:	f3 0f 1e fa          	endbr64
  8011ec:	55                   	push   %rbp
  8011ed:	48 89 e5             	mov    %rsp,%rbp
  8011f0:	41 57                	push   %r15
  8011f2:	41 56                	push   %r14
  8011f4:	41 55                	push   %r13
  8011f6:	41 54                	push   %r12
  8011f8:	53                   	push   %rbx
  8011f9:	48 83 ec 18          	sub    $0x18,%rsp
  8011fd:	49 89 fc             	mov    %rdi,%r12
  801200:	49 89 f5             	mov    %rsi,%r13
  801203:	49 89 d7             	mov    %rdx,%r15
  801206:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80120a:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  801211:	00 00 00 
  801214:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801216:	4d 85 ff             	test   %r15,%r15
  801219:	0f 84 af 00 00 00    	je     8012ce <devpipe_write+0xe6>
  80121f:	48 89 c3             	mov    %rax,%rbx
  801222:	4c 89 f8             	mov    %r15,%rax
  801225:	4d 89 ef             	mov    %r13,%r15
  801228:	4c 01 e8             	add    %r13,%rax
  80122b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80122f:	49 bd 93 02 80 00 00 	movabs $0x800293,%r13
  801236:	00 00 00 
            sys_yield();
  801239:	49 be 28 02 80 00 00 	movabs $0x800228,%r14
  801240:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801243:	8b 73 04             	mov    0x4(%rbx),%esi
  801246:	48 63 ce             	movslq %esi,%rcx
  801249:	48 63 03             	movslq (%rbx),%rax
  80124c:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801252:	48 39 c1             	cmp    %rax,%rcx
  801255:	72 2e                	jb     801285 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801257:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80125c:	48 89 da             	mov    %rbx,%rdx
  80125f:	be 00 10 00 00       	mov    $0x1000,%esi
  801264:	4c 89 e7             	mov    %r12,%rdi
  801267:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80126a:	85 c0                	test   %eax,%eax
  80126c:	74 66                	je     8012d4 <devpipe_write+0xec>
            sys_yield();
  80126e:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801271:	8b 73 04             	mov    0x4(%rbx),%esi
  801274:	48 63 ce             	movslq %esi,%rcx
  801277:	48 63 03             	movslq (%rbx),%rax
  80127a:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801280:	48 39 c1             	cmp    %rax,%rcx
  801283:	73 d2                	jae    801257 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801285:	41 0f b6 3f          	movzbl (%r15),%edi
  801289:	48 89 ca             	mov    %rcx,%rdx
  80128c:	48 c1 ea 03          	shr    $0x3,%rdx
  801290:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801297:	08 10 20 
  80129a:	48 f7 e2             	mul    %rdx
  80129d:	48 c1 ea 06          	shr    $0x6,%rdx
  8012a1:	48 89 d0             	mov    %rdx,%rax
  8012a4:	48 c1 e0 09          	shl    $0x9,%rax
  8012a8:	48 29 d0             	sub    %rdx,%rax
  8012ab:	48 c1 e0 03          	shl    $0x3,%rax
  8012af:	48 29 c1             	sub    %rax,%rcx
  8012b2:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8012b7:	83 c6 01             	add    $0x1,%esi
  8012ba:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012bd:	49 83 c7 01          	add    $0x1,%r15
  8012c1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012c5:	49 39 c7             	cmp    %rax,%r15
  8012c8:	0f 85 75 ff ff ff    	jne    801243 <devpipe_write+0x5b>
    return n;
  8012ce:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8012d2:	eb 05                	jmp    8012d9 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8012d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d9:	48 83 c4 18          	add    $0x18,%rsp
  8012dd:	5b                   	pop    %rbx
  8012de:	41 5c                	pop    %r12
  8012e0:	41 5d                	pop    %r13
  8012e2:	41 5e                	pop    %r14
  8012e4:	41 5f                	pop    %r15
  8012e6:	5d                   	pop    %rbp
  8012e7:	c3                   	ret

00000000008012e8 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8012e8:	f3 0f 1e fa          	endbr64
  8012ec:	55                   	push   %rbp
  8012ed:	48 89 e5             	mov    %rsp,%rbp
  8012f0:	41 57                	push   %r15
  8012f2:	41 56                	push   %r14
  8012f4:	41 55                	push   %r13
  8012f6:	41 54                	push   %r12
  8012f8:	53                   	push   %rbx
  8012f9:	48 83 ec 18          	sub    $0x18,%rsp
  8012fd:	49 89 fc             	mov    %rdi,%r12
  801300:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801304:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801308:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  80130f:	00 00 00 
  801312:	ff d0                	call   *%rax
  801314:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  801317:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80131d:	49 bd 93 02 80 00 00 	movabs $0x800293,%r13
  801324:	00 00 00 
            sys_yield();
  801327:	49 be 28 02 80 00 00 	movabs $0x800228,%r14
  80132e:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801331:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801336:	74 7d                	je     8013b5 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801338:	8b 03                	mov    (%rbx),%eax
  80133a:	3b 43 04             	cmp    0x4(%rbx),%eax
  80133d:	75 26                	jne    801365 <devpipe_read+0x7d>
            if (i > 0) return i;
  80133f:	4d 85 ff             	test   %r15,%r15
  801342:	75 77                	jne    8013bb <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801344:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801349:	48 89 da             	mov    %rbx,%rdx
  80134c:	be 00 10 00 00       	mov    $0x1000,%esi
  801351:	4c 89 e7             	mov    %r12,%rdi
  801354:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801357:	85 c0                	test   %eax,%eax
  801359:	74 72                	je     8013cd <devpipe_read+0xe5>
            sys_yield();
  80135b:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80135e:	8b 03                	mov    (%rbx),%eax
  801360:	3b 43 04             	cmp    0x4(%rbx),%eax
  801363:	74 df                	je     801344 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801365:	48 63 c8             	movslq %eax,%rcx
  801368:	48 89 ca             	mov    %rcx,%rdx
  80136b:	48 c1 ea 03          	shr    $0x3,%rdx
  80136f:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  801376:	08 10 20 
  801379:	48 89 d0             	mov    %rdx,%rax
  80137c:	48 f7 e6             	mul    %rsi
  80137f:	48 c1 ea 06          	shr    $0x6,%rdx
  801383:	48 89 d0             	mov    %rdx,%rax
  801386:	48 c1 e0 09          	shl    $0x9,%rax
  80138a:	48 29 d0             	sub    %rdx,%rax
  80138d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801394:	00 
  801395:	48 89 c8             	mov    %rcx,%rax
  801398:	48 29 d0             	sub    %rdx,%rax
  80139b:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8013a0:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8013a4:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8013a8:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8013ab:	49 83 c7 01          	add    $0x1,%r15
  8013af:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8013b3:	75 83                	jne    801338 <devpipe_read+0x50>
    return n;
  8013b5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013b9:	eb 03                	jmp    8013be <devpipe_read+0xd6>
            if (i > 0) return i;
  8013bb:	4c 89 f8             	mov    %r15,%rax
}
  8013be:	48 83 c4 18          	add    $0x18,%rsp
  8013c2:	5b                   	pop    %rbx
  8013c3:	41 5c                	pop    %r12
  8013c5:	41 5d                	pop    %r13
  8013c7:	41 5e                	pop    %r14
  8013c9:	41 5f                	pop    %r15
  8013cb:	5d                   	pop    %rbp
  8013cc:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8013cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d2:	eb ea                	jmp    8013be <devpipe_read+0xd6>

00000000008013d4 <pipe>:
pipe(int pfd[2]) {
  8013d4:	f3 0f 1e fa          	endbr64
  8013d8:	55                   	push   %rbp
  8013d9:	48 89 e5             	mov    %rsp,%rbp
  8013dc:	41 55                	push   %r13
  8013de:	41 54                	push   %r12
  8013e0:	53                   	push   %rbx
  8013e1:	48 83 ec 18          	sub    $0x18,%rsp
  8013e5:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8013e8:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8013ec:	48 b8 bd 06 80 00 00 	movabs $0x8006bd,%rax
  8013f3:	00 00 00 
  8013f6:	ff d0                	call   *%rax
  8013f8:	89 c3                	mov    %eax,%ebx
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	0f 88 a0 01 00 00    	js     8015a2 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  801402:	b9 46 00 00 00       	mov    $0x46,%ecx
  801407:	ba 00 10 00 00       	mov    $0x1000,%edx
  80140c:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801410:	bf 00 00 00 00       	mov    $0x0,%edi
  801415:	48 b8 c3 02 80 00 00 	movabs $0x8002c3,%rax
  80141c:	00 00 00 
  80141f:	ff d0                	call   *%rax
  801421:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801423:	85 c0                	test   %eax,%eax
  801425:	0f 88 77 01 00 00    	js     8015a2 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80142b:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80142f:	48 b8 bd 06 80 00 00 	movabs $0x8006bd,%rax
  801436:	00 00 00 
  801439:	ff d0                	call   *%rax
  80143b:	89 c3                	mov    %eax,%ebx
  80143d:	85 c0                	test   %eax,%eax
  80143f:	0f 88 43 01 00 00    	js     801588 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  801445:	b9 46 00 00 00       	mov    $0x46,%ecx
  80144a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80144f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801453:	bf 00 00 00 00       	mov    $0x0,%edi
  801458:	48 b8 c3 02 80 00 00 	movabs $0x8002c3,%rax
  80145f:	00 00 00 
  801462:	ff d0                	call   *%rax
  801464:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  801466:	85 c0                	test   %eax,%eax
  801468:	0f 88 1a 01 00 00    	js     801588 <pipe+0x1b4>
    va = fd2data(fd0);
  80146e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801472:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  801479:	00 00 00 
  80147c:	ff d0                	call   *%rax
  80147e:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801481:	b9 46 00 00 00       	mov    $0x46,%ecx
  801486:	ba 00 10 00 00       	mov    $0x1000,%edx
  80148b:	48 89 c6             	mov    %rax,%rsi
  80148e:	bf 00 00 00 00       	mov    $0x0,%edi
  801493:	48 b8 c3 02 80 00 00 	movabs $0x8002c3,%rax
  80149a:	00 00 00 
  80149d:	ff d0                	call   *%rax
  80149f:	89 c3                	mov    %eax,%ebx
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	0f 88 c5 00 00 00    	js     80156e <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8014a9:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8014ad:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  8014b4:	00 00 00 
  8014b7:	ff d0                	call   *%rax
  8014b9:	48 89 c1             	mov    %rax,%rcx
  8014bc:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8014c2:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8014c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8014cd:	4c 89 ee             	mov    %r13,%rsi
  8014d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8014d5:	48 b8 2e 03 80 00 00 	movabs $0x80032e,%rax
  8014dc:	00 00 00 
  8014df:	ff d0                	call   *%rax
  8014e1:	89 c3                	mov    %eax,%ebx
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	78 6e                	js     801555 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014e7:	be 00 10 00 00       	mov    $0x1000,%esi
  8014ec:	4c 89 ef             	mov    %r13,%rdi
  8014ef:	48 b8 5d 02 80 00 00 	movabs $0x80025d,%rax
  8014f6:	00 00 00 
  8014f9:	ff d0                	call   *%rax
  8014fb:	83 f8 02             	cmp    $0x2,%eax
  8014fe:	0f 85 ab 00 00 00    	jne    8015af <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  801504:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80150b:	00 00 
  80150d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801511:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  801513:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801517:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80151e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801522:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801524:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801528:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80152f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801533:	48 bb 87 06 80 00 00 	movabs $0x800687,%rbx
  80153a:	00 00 00 
  80153d:	ff d3                	call   *%rbx
  80153f:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801543:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801547:	ff d3                	call   *%rbx
  801549:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80154e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801553:	eb 4d                	jmp    8015a2 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  801555:	ba 00 10 00 00       	mov    $0x1000,%edx
  80155a:	4c 89 ee             	mov    %r13,%rsi
  80155d:	bf 00 00 00 00       	mov    $0x0,%edi
  801562:	48 b8 03 04 80 00 00 	movabs $0x800403,%rax
  801569:	00 00 00 
  80156c:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80156e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801573:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801577:	bf 00 00 00 00       	mov    $0x0,%edi
  80157c:	48 b8 03 04 80 00 00 	movabs $0x800403,%rax
  801583:	00 00 00 
  801586:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  801588:	ba 00 10 00 00       	mov    $0x1000,%edx
  80158d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801591:	bf 00 00 00 00       	mov    $0x0,%edi
  801596:	48 b8 03 04 80 00 00 	movabs $0x800403,%rax
  80159d:	00 00 00 
  8015a0:	ff d0                	call   *%rax
}
  8015a2:	89 d8                	mov    %ebx,%eax
  8015a4:	48 83 c4 18          	add    $0x18,%rsp
  8015a8:	5b                   	pop    %rbx
  8015a9:	41 5c                	pop    %r12
  8015ab:	41 5d                	pop    %r13
  8015ad:	5d                   	pop    %rbp
  8015ae:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8015af:	48 b9 c0 32 80 00 00 	movabs $0x8032c0,%rcx
  8015b6:	00 00 00 
  8015b9:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  8015c0:	00 00 00 
  8015c3:	be 2e 00 00 00       	mov    $0x2e,%esi
  8015c8:	48 bf 95 30 80 00 00 	movabs $0x803095,%rdi
  8015cf:	00 00 00 
  8015d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d7:	49 b8 ee 1b 80 00 00 	movabs $0x801bee,%r8
  8015de:	00 00 00 
  8015e1:	41 ff d0             	call   *%r8

00000000008015e4 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8015e4:	f3 0f 1e fa          	endbr64
  8015e8:	55                   	push   %rbp
  8015e9:	48 89 e5             	mov    %rsp,%rbp
  8015ec:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8015f0:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8015f4:	48 b8 21 07 80 00 00 	movabs $0x800721,%rax
  8015fb:	00 00 00 
  8015fe:	ff d0                	call   *%rax
    if (res < 0) return res;
  801600:	85 c0                	test   %eax,%eax
  801602:	78 35                	js     801639 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  801604:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801608:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  80160f:	00 00 00 
  801612:	ff d0                	call   *%rax
  801614:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801617:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80161c:	be 00 10 00 00       	mov    $0x1000,%esi
  801621:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801625:	48 b8 93 02 80 00 00 	movabs $0x800293,%rax
  80162c:	00 00 00 
  80162f:	ff d0                	call   *%rax
  801631:	85 c0                	test   %eax,%eax
  801633:	0f 94 c0             	sete   %al
  801636:	0f b6 c0             	movzbl %al,%eax
}
  801639:	c9                   	leave
  80163a:	c3                   	ret

000000000080163b <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  80163b:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80163f:	48 89 f8             	mov    %rdi,%rax
  801642:	48 c1 e8 27          	shr    $0x27,%rax
  801646:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80164d:	7f 00 00 
  801650:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801654:	f6 c2 01             	test   $0x1,%dl
  801657:	74 6d                	je     8016c6 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801659:	48 89 f8             	mov    %rdi,%rax
  80165c:	48 c1 e8 1e          	shr    $0x1e,%rax
  801660:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801667:	7f 00 00 
  80166a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80166e:	f6 c2 01             	test   $0x1,%dl
  801671:	74 62                	je     8016d5 <get_uvpt_entry+0x9a>
  801673:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80167a:	7f 00 00 
  80167d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801681:	f6 c2 80             	test   $0x80,%dl
  801684:	75 4f                	jne    8016d5 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801686:	48 89 f8             	mov    %rdi,%rax
  801689:	48 c1 e8 15          	shr    $0x15,%rax
  80168d:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  801694:	7f 00 00 
  801697:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80169b:	f6 c2 01             	test   $0x1,%dl
  80169e:	74 44                	je     8016e4 <get_uvpt_entry+0xa9>
  8016a0:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016a7:	7f 00 00 
  8016aa:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8016ae:	f6 c2 80             	test   $0x80,%dl
  8016b1:	75 31                	jne    8016e4 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  8016b3:	48 c1 ef 0c          	shr    $0xc,%rdi
  8016b7:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8016be:	7f 00 00 
  8016c1:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8016c5:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8016c6:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8016cd:	7f 00 00 
  8016d0:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016d4:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8016d5:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8016dc:	7f 00 00 
  8016df:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016e3:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8016e4:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016eb:	7f 00 00 
  8016ee:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016f2:	c3                   	ret

00000000008016f3 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8016f3:	f3 0f 1e fa          	endbr64
  8016f7:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8016fa:	48 89 f9             	mov    %rdi,%rcx
  8016fd:	48 c1 e9 27          	shr    $0x27,%rcx
  801701:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  801708:	7f 00 00 
  80170b:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  80170f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  801716:	f6 c1 01             	test   $0x1,%cl
  801719:	0f 84 b2 00 00 00    	je     8017d1 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80171f:	48 89 f9             	mov    %rdi,%rcx
  801722:	48 c1 e9 1e          	shr    $0x1e,%rcx
  801726:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80172d:	7f 00 00 
  801730:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801734:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80173b:	40 f6 c6 01          	test   $0x1,%sil
  80173f:	0f 84 8c 00 00 00    	je     8017d1 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  801745:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80174c:	7f 00 00 
  80174f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801753:	a8 80                	test   $0x80,%al
  801755:	75 7b                	jne    8017d2 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  801757:	48 89 f9             	mov    %rdi,%rcx
  80175a:	48 c1 e9 15          	shr    $0x15,%rcx
  80175e:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801765:	7f 00 00 
  801768:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80176c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  801773:	40 f6 c6 01          	test   $0x1,%sil
  801777:	74 58                	je     8017d1 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  801779:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801780:	7f 00 00 
  801783:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801787:	a8 80                	test   $0x80,%al
  801789:	75 6c                	jne    8017f7 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  80178b:	48 89 f9             	mov    %rdi,%rcx
  80178e:	48 c1 e9 0c          	shr    $0xc,%rcx
  801792:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801799:	7f 00 00 
  80179c:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8017a0:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  8017a7:	40 f6 c6 01          	test   $0x1,%sil
  8017ab:	74 24                	je     8017d1 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  8017ad:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8017b4:	7f 00 00 
  8017b7:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017bb:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017c2:	ff ff 7f 
  8017c5:	48 21 c8             	and    %rcx,%rax
  8017c8:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8017ce:	48 09 d0             	or     %rdx,%rax
}
  8017d1:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8017d2:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8017d9:	7f 00 00 
  8017dc:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017e0:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017e7:	ff ff 7f 
  8017ea:	48 21 c8             	and    %rcx,%rax
  8017ed:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8017f3:	48 01 d0             	add    %rdx,%rax
  8017f6:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8017f7:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8017fe:	7f 00 00 
  801801:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801805:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80180c:	ff ff 7f 
  80180f:	48 21 c8             	and    %rcx,%rax
  801812:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  801818:	48 01 d0             	add    %rdx,%rax
  80181b:	c3                   	ret

000000000080181c <get_prot>:

int
get_prot(void *va) {
  80181c:	f3 0f 1e fa          	endbr64
  801820:	55                   	push   %rbp
  801821:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801824:	48 b8 3b 16 80 00 00 	movabs $0x80163b,%rax
  80182b:	00 00 00 
  80182e:	ff d0                	call   *%rax
  801830:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  801833:	83 e0 01             	and    $0x1,%eax
  801836:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  801839:	89 d1                	mov    %edx,%ecx
  80183b:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  801841:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  801843:	89 c1                	mov    %eax,%ecx
  801845:	83 c9 02             	or     $0x2,%ecx
  801848:	f6 c2 02             	test   $0x2,%dl
  80184b:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80184e:	89 c1                	mov    %eax,%ecx
  801850:	83 c9 01             	or     $0x1,%ecx
  801853:	48 85 d2             	test   %rdx,%rdx
  801856:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801859:	89 c1                	mov    %eax,%ecx
  80185b:	83 c9 40             	or     $0x40,%ecx
  80185e:	f6 c6 04             	test   $0x4,%dh
  801861:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801864:	5d                   	pop    %rbp
  801865:	c3                   	ret

0000000000801866 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801866:	f3 0f 1e fa          	endbr64
  80186a:	55                   	push   %rbp
  80186b:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80186e:	48 b8 3b 16 80 00 00 	movabs $0x80163b,%rax
  801875:	00 00 00 
  801878:	ff d0                	call   *%rax
    return pte & PTE_D;
  80187a:	48 c1 e8 06          	shr    $0x6,%rax
  80187e:	83 e0 01             	and    $0x1,%eax
}
  801881:	5d                   	pop    %rbp
  801882:	c3                   	ret

0000000000801883 <is_page_present>:

bool
is_page_present(void *va) {
  801883:	f3 0f 1e fa          	endbr64
  801887:	55                   	push   %rbp
  801888:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80188b:	48 b8 3b 16 80 00 00 	movabs $0x80163b,%rax
  801892:	00 00 00 
  801895:	ff d0                	call   *%rax
  801897:	83 e0 01             	and    $0x1,%eax
}
  80189a:	5d                   	pop    %rbp
  80189b:	c3                   	ret

000000000080189c <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80189c:	f3 0f 1e fa          	endbr64
  8018a0:	55                   	push   %rbp
  8018a1:	48 89 e5             	mov    %rsp,%rbp
  8018a4:	41 57                	push   %r15
  8018a6:	41 56                	push   %r14
  8018a8:	41 55                	push   %r13
  8018aa:	41 54                	push   %r12
  8018ac:	53                   	push   %rbx
  8018ad:	48 83 ec 18          	sub    $0x18,%rsp
  8018b1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8018b5:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8018b9:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8018be:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8018c5:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8018c8:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8018cf:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8018d2:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8018d9:	00 00 00 
  8018dc:	eb 73                	jmp    801951 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018de:	48 89 d8             	mov    %rbx,%rax
  8018e1:	48 c1 e8 15          	shr    $0x15,%rax
  8018e5:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8018ec:	7f 00 00 
  8018ef:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8018f3:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018f9:	f6 c2 01             	test   $0x1,%dl
  8018fc:	74 4b                	je     801949 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8018fe:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  801902:	f6 c2 80             	test   $0x80,%dl
  801905:	74 11                	je     801918 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  801907:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  80190b:	f6 c4 04             	test   $0x4,%ah
  80190e:	74 39                	je     801949 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  801910:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  801916:	eb 20                	jmp    801938 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801918:	48 89 da             	mov    %rbx,%rdx
  80191b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80191f:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801926:	7f 00 00 
  801929:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  80192d:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801933:	f6 c4 04             	test   $0x4,%ah
  801936:	74 11                	je     801949 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  801938:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  80193c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801940:	48 89 df             	mov    %rbx,%rdi
  801943:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801947:	ff d0                	call   *%rax
    next:
        va += size;
  801949:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  80194c:	49 39 df             	cmp    %rbx,%r15
  80194f:	72 3e                	jb     80198f <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  801951:	49 8b 06             	mov    (%r14),%rax
  801954:	a8 01                	test   $0x1,%al
  801956:	74 37                	je     80198f <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801958:	48 89 d8             	mov    %rbx,%rax
  80195b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80195f:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  801964:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80196a:	f6 c2 01             	test   $0x1,%dl
  80196d:	74 da                	je     801949 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  80196f:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  801974:	f6 c2 80             	test   $0x80,%dl
  801977:	0f 84 61 ff ff ff    	je     8018de <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  80197d:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  801982:	f6 c4 04             	test   $0x4,%ah
  801985:	74 c2                	je     801949 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  801987:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  80198d:	eb a9                	jmp    801938 <foreach_shared_region+0x9c>
    }
    return res;
}
  80198f:	b8 00 00 00 00       	mov    $0x0,%eax
  801994:	48 83 c4 18          	add    $0x18,%rsp
  801998:	5b                   	pop    %rbx
  801999:	41 5c                	pop    %r12
  80199b:	41 5d                	pop    %r13
  80199d:	41 5e                	pop    %r14
  80199f:	41 5f                	pop    %r15
  8019a1:	5d                   	pop    %rbp
  8019a2:	c3                   	ret

00000000008019a3 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  8019a3:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  8019a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ac:	c3                   	ret

00000000008019ad <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8019ad:	f3 0f 1e fa          	endbr64
  8019b1:	55                   	push   %rbp
  8019b2:	48 89 e5             	mov    %rsp,%rbp
  8019b5:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8019b8:	48 be a5 30 80 00 00 	movabs $0x8030a5,%rsi
  8019bf:	00 00 00 
  8019c2:	48 b8 93 26 80 00 00 	movabs $0x802693,%rax
  8019c9:	00 00 00 
  8019cc:	ff d0                	call   *%rax
    return 0;
}
  8019ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d3:	5d                   	pop    %rbp
  8019d4:	c3                   	ret

00000000008019d5 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8019d5:	f3 0f 1e fa          	endbr64
  8019d9:	55                   	push   %rbp
  8019da:	48 89 e5             	mov    %rsp,%rbp
  8019dd:	41 57                	push   %r15
  8019df:	41 56                	push   %r14
  8019e1:	41 55                	push   %r13
  8019e3:	41 54                	push   %r12
  8019e5:	53                   	push   %rbx
  8019e6:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8019ed:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8019f4:	48 85 d2             	test   %rdx,%rdx
  8019f7:	74 7a                	je     801a73 <devcons_write+0x9e>
  8019f9:	49 89 d6             	mov    %rdx,%r14
  8019fc:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a02:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  801a07:	49 bf ae 28 80 00 00 	movabs $0x8028ae,%r15
  801a0e:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  801a11:	4c 89 f3             	mov    %r14,%rbx
  801a14:	48 29 f3             	sub    %rsi,%rbx
  801a17:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a1c:	48 39 c3             	cmp    %rax,%rbx
  801a1f:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801a23:	4c 63 eb             	movslq %ebx,%r13
  801a26:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801a2d:	48 01 c6             	add    %rax,%rsi
  801a30:	4c 89 ea             	mov    %r13,%rdx
  801a33:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a3a:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  801a3d:	4c 89 ee             	mov    %r13,%rsi
  801a40:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a47:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  801a4e:	00 00 00 
  801a51:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801a53:	41 01 dc             	add    %ebx,%r12d
  801a56:	49 63 f4             	movslq %r12d,%rsi
  801a59:	4c 39 f6             	cmp    %r14,%rsi
  801a5c:	72 b3                	jb     801a11 <devcons_write+0x3c>
    return res;
  801a5e:	49 63 c4             	movslq %r12d,%rax
}
  801a61:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801a68:	5b                   	pop    %rbx
  801a69:	41 5c                	pop    %r12
  801a6b:	41 5d                	pop    %r13
  801a6d:	41 5e                	pop    %r14
  801a6f:	41 5f                	pop    %r15
  801a71:	5d                   	pop    %rbp
  801a72:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  801a73:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a79:	eb e3                	jmp    801a5e <devcons_write+0x89>

0000000000801a7b <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a7b:	f3 0f 1e fa          	endbr64
  801a7f:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801a82:	ba 00 00 00 00       	mov    $0x0,%edx
  801a87:	48 85 c0             	test   %rax,%rax
  801a8a:	74 55                	je     801ae1 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a8c:	55                   	push   %rbp
  801a8d:	48 89 e5             	mov    %rsp,%rbp
  801a90:	41 55                	push   %r13
  801a92:	41 54                	push   %r12
  801a94:	53                   	push   %rbx
  801a95:	48 83 ec 08          	sub    $0x8,%rsp
  801a99:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801a9c:	48 bb 4f 01 80 00 00 	movabs $0x80014f,%rbx
  801aa3:	00 00 00 
  801aa6:	49 bc 28 02 80 00 00 	movabs $0x800228,%r12
  801aad:	00 00 00 
  801ab0:	eb 03                	jmp    801ab5 <devcons_read+0x3a>
  801ab2:	41 ff d4             	call   *%r12
  801ab5:	ff d3                	call   *%rbx
  801ab7:	85 c0                	test   %eax,%eax
  801ab9:	74 f7                	je     801ab2 <devcons_read+0x37>
    if (c < 0) return c;
  801abb:	48 63 d0             	movslq %eax,%rdx
  801abe:	78 13                	js     801ad3 <devcons_read+0x58>
    if (c == 0x04) return 0;
  801ac0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac5:	83 f8 04             	cmp    $0x4,%eax
  801ac8:	74 09                	je     801ad3 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  801aca:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801ace:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801ad3:	48 89 d0             	mov    %rdx,%rax
  801ad6:	48 83 c4 08          	add    $0x8,%rsp
  801ada:	5b                   	pop    %rbx
  801adb:	41 5c                	pop    %r12
  801add:	41 5d                	pop    %r13
  801adf:	5d                   	pop    %rbp
  801ae0:	c3                   	ret
  801ae1:	48 89 d0             	mov    %rdx,%rax
  801ae4:	c3                   	ret

0000000000801ae5 <cputchar>:
cputchar(int ch) {
  801ae5:	f3 0f 1e fa          	endbr64
  801ae9:	55                   	push   %rbp
  801aea:	48 89 e5             	mov    %rsp,%rbp
  801aed:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801af1:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801af5:	be 01 00 00 00       	mov    $0x1,%esi
  801afa:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801afe:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  801b05:	00 00 00 
  801b08:	ff d0                	call   *%rax
}
  801b0a:	c9                   	leave
  801b0b:	c3                   	ret

0000000000801b0c <getchar>:
getchar(void) {
  801b0c:	f3 0f 1e fa          	endbr64
  801b10:	55                   	push   %rbp
  801b11:	48 89 e5             	mov    %rsp,%rbp
  801b14:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801b18:	ba 01 00 00 00       	mov    $0x1,%edx
  801b1d:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801b21:	bf 00 00 00 00       	mov    $0x0,%edi
  801b26:	48 b8 1c 0a 80 00 00 	movabs $0x800a1c,%rax
  801b2d:	00 00 00 
  801b30:	ff d0                	call   *%rax
  801b32:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801b34:	85 c0                	test   %eax,%eax
  801b36:	78 06                	js     801b3e <getchar+0x32>
  801b38:	74 08                	je     801b42 <getchar+0x36>
  801b3a:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  801b3e:	89 d0                	mov    %edx,%eax
  801b40:	c9                   	leave
  801b41:	c3                   	ret
    return res < 0 ? res : res ? c :
  801b42:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801b47:	eb f5                	jmp    801b3e <getchar+0x32>

0000000000801b49 <iscons>:
iscons(int fdnum) {
  801b49:	f3 0f 1e fa          	endbr64
  801b4d:	55                   	push   %rbp
  801b4e:	48 89 e5             	mov    %rsp,%rbp
  801b51:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801b55:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b59:	48 b8 21 07 80 00 00 	movabs $0x800721,%rax
  801b60:	00 00 00 
  801b63:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b65:	85 c0                	test   %eax,%eax
  801b67:	78 18                	js     801b81 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  801b69:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b6d:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801b74:	00 00 00 
  801b77:	8b 00                	mov    (%rax),%eax
  801b79:	39 02                	cmp    %eax,(%rdx)
  801b7b:	0f 94 c0             	sete   %al
  801b7e:	0f b6 c0             	movzbl %al,%eax
}
  801b81:	c9                   	leave
  801b82:	c3                   	ret

0000000000801b83 <opencons>:
opencons(void) {
  801b83:	f3 0f 1e fa          	endbr64
  801b87:	55                   	push   %rbp
  801b88:	48 89 e5             	mov    %rsp,%rbp
  801b8b:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801b8f:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801b93:	48 b8 bd 06 80 00 00 	movabs $0x8006bd,%rax
  801b9a:	00 00 00 
  801b9d:	ff d0                	call   *%rax
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	78 49                	js     801bec <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801ba3:	b9 46 00 00 00       	mov    $0x46,%ecx
  801ba8:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bad:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801bb1:	bf 00 00 00 00       	mov    $0x0,%edi
  801bb6:	48 b8 c3 02 80 00 00 	movabs $0x8002c3,%rax
  801bbd:	00 00 00 
  801bc0:	ff d0                	call   *%rax
  801bc2:	85 c0                	test   %eax,%eax
  801bc4:	78 26                	js     801bec <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  801bc6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bca:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801bd1:	00 00 
  801bd3:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801bd5:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801bd9:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801be0:	48 b8 87 06 80 00 00 	movabs $0x800687,%rax
  801be7:	00 00 00 
  801bea:	ff d0                	call   *%rax
}
  801bec:	c9                   	leave
  801bed:	c3                   	ret

0000000000801bee <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801bee:	f3 0f 1e fa          	endbr64
  801bf2:	55                   	push   %rbp
  801bf3:	48 89 e5             	mov    %rsp,%rbp
  801bf6:	41 56                	push   %r14
  801bf8:	41 55                	push   %r13
  801bfa:	41 54                	push   %r12
  801bfc:	53                   	push   %rbx
  801bfd:	48 83 ec 50          	sub    $0x50,%rsp
  801c01:	49 89 fc             	mov    %rdi,%r12
  801c04:	41 89 f5             	mov    %esi,%r13d
  801c07:	48 89 d3             	mov    %rdx,%rbx
  801c0a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c0e:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801c12:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801c16:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801c1d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c21:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801c25:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801c29:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801c2d:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801c34:	00 00 00 
  801c37:	4c 8b 30             	mov    (%rax),%r14
  801c3a:	48 b8 f3 01 80 00 00 	movabs $0x8001f3,%rax
  801c41:	00 00 00 
  801c44:	ff d0                	call   *%rax
  801c46:	89 c6                	mov    %eax,%esi
  801c48:	45 89 e8             	mov    %r13d,%r8d
  801c4b:	4c 89 e1             	mov    %r12,%rcx
  801c4e:	4c 89 f2             	mov    %r14,%rdx
  801c51:	48 bf e8 32 80 00 00 	movabs $0x8032e8,%rdi
  801c58:	00 00 00 
  801c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c60:	49 bc 4a 1d 80 00 00 	movabs $0x801d4a,%r12
  801c67:	00 00 00 
  801c6a:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801c6d:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801c71:	48 89 df             	mov    %rbx,%rdi
  801c74:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  801c7b:	00 00 00 
  801c7e:	ff d0                	call   *%rax
    cprintf("\n");
  801c80:	48 bf 32 30 80 00 00 	movabs $0x803032,%rdi
  801c87:	00 00 00 
  801c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8f:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801c92:	cc                   	int3
  801c93:	eb fd                	jmp    801c92 <_panic+0xa4>

0000000000801c95 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801c95:	f3 0f 1e fa          	endbr64
  801c99:	55                   	push   %rbp
  801c9a:	48 89 e5             	mov    %rsp,%rbp
  801c9d:	53                   	push   %rbx
  801c9e:	48 83 ec 08          	sub    $0x8,%rsp
  801ca2:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801ca5:	8b 06                	mov    (%rsi),%eax
  801ca7:	8d 50 01             	lea    0x1(%rax),%edx
  801caa:	89 16                	mov    %edx,(%rsi)
  801cac:	48 98                	cltq
  801cae:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801cb3:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801cb9:	74 0a                	je     801cc5 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801cbb:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801cbf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cc3:	c9                   	leave
  801cc4:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  801cc5:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801cc9:	be ff 00 00 00       	mov    $0xff,%esi
  801cce:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  801cd5:	00 00 00 
  801cd8:	ff d0                	call   *%rax
        state->offset = 0;
  801cda:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801ce0:	eb d9                	jmp    801cbb <putch+0x26>

0000000000801ce2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801ce2:	f3 0f 1e fa          	endbr64
  801ce6:	55                   	push   %rbp
  801ce7:	48 89 e5             	mov    %rsp,%rbp
  801cea:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801cf1:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801cf4:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801cfb:	b9 21 00 00 00       	mov    $0x21,%ecx
  801d00:	b8 00 00 00 00       	mov    $0x0,%eax
  801d05:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801d08:	48 89 f1             	mov    %rsi,%rcx
  801d0b:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801d12:	48 bf 95 1c 80 00 00 	movabs $0x801c95,%rdi
  801d19:	00 00 00 
  801d1c:	48 b8 aa 1e 80 00 00 	movabs $0x801eaa,%rax
  801d23:	00 00 00 
  801d26:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801d28:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801d2f:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801d36:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  801d3d:	00 00 00 
  801d40:	ff d0                	call   *%rax

    return state.count;
}
  801d42:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801d48:	c9                   	leave
  801d49:	c3                   	ret

0000000000801d4a <cprintf>:

int
cprintf(const char *fmt, ...) {
  801d4a:	f3 0f 1e fa          	endbr64
  801d4e:	55                   	push   %rbp
  801d4f:	48 89 e5             	mov    %rsp,%rbp
  801d52:	48 83 ec 50          	sub    $0x50,%rsp
  801d56:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801d5a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801d5e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d62:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801d66:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801d6a:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801d71:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d75:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d79:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801d7d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801d81:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801d85:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  801d8c:	00 00 00 
  801d8f:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801d91:	c9                   	leave
  801d92:	c3                   	ret

0000000000801d93 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801d93:	f3 0f 1e fa          	endbr64
  801d97:	55                   	push   %rbp
  801d98:	48 89 e5             	mov    %rsp,%rbp
  801d9b:	41 57                	push   %r15
  801d9d:	41 56                	push   %r14
  801d9f:	41 55                	push   %r13
  801da1:	41 54                	push   %r12
  801da3:	53                   	push   %rbx
  801da4:	48 83 ec 18          	sub    $0x18,%rsp
  801da8:	49 89 fc             	mov    %rdi,%r12
  801dab:	49 89 f5             	mov    %rsi,%r13
  801dae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801db2:	8b 45 10             	mov    0x10(%rbp),%eax
  801db5:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801db8:	41 89 cf             	mov    %ecx,%r15d
  801dbb:	4c 39 fa             	cmp    %r15,%rdx
  801dbe:	73 5b                	jae    801e1b <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801dc0:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801dc4:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801dc8:	85 db                	test   %ebx,%ebx
  801dca:	7e 0e                	jle    801dda <print_num+0x47>
            putch(padc, put_arg);
  801dcc:	4c 89 ee             	mov    %r13,%rsi
  801dcf:	44 89 f7             	mov    %r14d,%edi
  801dd2:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801dd5:	83 eb 01             	sub    $0x1,%ebx
  801dd8:	75 f2                	jne    801dcc <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801dda:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801dde:	48 b9 c2 30 80 00 00 	movabs $0x8030c2,%rcx
  801de5:	00 00 00 
  801de8:	48 b8 b1 30 80 00 00 	movabs $0x8030b1,%rax
  801def:	00 00 00 
  801df2:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801df6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801dfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801dff:	49 f7 f7             	div    %r15
  801e02:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801e06:	4c 89 ee             	mov    %r13,%rsi
  801e09:	41 ff d4             	call   *%r12
}
  801e0c:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801e10:	5b                   	pop    %rbx
  801e11:	41 5c                	pop    %r12
  801e13:	41 5d                	pop    %r13
  801e15:	41 5e                	pop    %r14
  801e17:	41 5f                	pop    %r15
  801e19:	5d                   	pop    %rbp
  801e1a:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801e1b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e24:	49 f7 f7             	div    %r15
  801e27:	48 83 ec 08          	sub    $0x8,%rsp
  801e2b:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801e2f:	52                   	push   %rdx
  801e30:	45 0f be c9          	movsbl %r9b,%r9d
  801e34:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801e38:	48 89 c2             	mov    %rax,%rdx
  801e3b:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  801e42:	00 00 00 
  801e45:	ff d0                	call   *%rax
  801e47:	48 83 c4 10          	add    $0x10,%rsp
  801e4b:	eb 8d                	jmp    801dda <print_num+0x47>

0000000000801e4d <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  801e4d:	f3 0f 1e fa          	endbr64
    state->count++;
  801e51:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801e55:	48 8b 06             	mov    (%rsi),%rax
  801e58:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801e5c:	73 0a                	jae    801e68 <sprintputch+0x1b>
        *state->start++ = ch;
  801e5e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e62:	48 89 16             	mov    %rdx,(%rsi)
  801e65:	40 88 38             	mov    %dil,(%rax)
    }
}
  801e68:	c3                   	ret

0000000000801e69 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801e69:	f3 0f 1e fa          	endbr64
  801e6d:	55                   	push   %rbp
  801e6e:	48 89 e5             	mov    %rsp,%rbp
  801e71:	48 83 ec 50          	sub    $0x50,%rsp
  801e75:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e79:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801e7d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801e81:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801e88:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e8c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e90:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801e94:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801e98:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801e9c:	48 b8 aa 1e 80 00 00 	movabs $0x801eaa,%rax
  801ea3:	00 00 00 
  801ea6:	ff d0                	call   *%rax
}
  801ea8:	c9                   	leave
  801ea9:	c3                   	ret

0000000000801eaa <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801eaa:	f3 0f 1e fa          	endbr64
  801eae:	55                   	push   %rbp
  801eaf:	48 89 e5             	mov    %rsp,%rbp
  801eb2:	41 57                	push   %r15
  801eb4:	41 56                	push   %r14
  801eb6:	41 55                	push   %r13
  801eb8:	41 54                	push   %r12
  801eba:	53                   	push   %rbx
  801ebb:	48 83 ec 38          	sub    $0x38,%rsp
  801ebf:	49 89 fe             	mov    %rdi,%r14
  801ec2:	49 89 f5             	mov    %rsi,%r13
  801ec5:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  801ec8:	48 8b 01             	mov    (%rcx),%rax
  801ecb:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801ecf:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801ed3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ed7:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801edb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801edf:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  801ee3:	0f b6 3b             	movzbl (%rbx),%edi
  801ee6:	40 80 ff 25          	cmp    $0x25,%dil
  801eea:	74 18                	je     801f04 <vprintfmt+0x5a>
            if (!ch) return;
  801eec:	40 84 ff             	test   %dil,%dil
  801eef:	0f 84 b2 06 00 00    	je     8025a7 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  801ef5:	40 0f b6 ff          	movzbl %dil,%edi
  801ef9:	4c 89 ee             	mov    %r13,%rsi
  801efc:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  801eff:	4c 89 e3             	mov    %r12,%rbx
  801f02:	eb db                	jmp    801edf <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  801f04:	be 00 00 00 00       	mov    $0x0,%esi
  801f09:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  801f0d:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801f12:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f18:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801f1f:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f23:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  801f28:	41 0f b6 04 24       	movzbl (%r12),%eax
  801f2d:	88 45 a0             	mov    %al,-0x60(%rbp)
  801f30:	83 e8 23             	sub    $0x23,%eax
  801f33:	3c 57                	cmp    $0x57,%al
  801f35:	0f 87 52 06 00 00    	ja     80258d <vprintfmt+0x6e3>
  801f3b:	0f b6 c0             	movzbl %al,%eax
  801f3e:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  801f45:	00 00 00 
  801f48:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  801f4c:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  801f4f:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  801f53:	eb ce                	jmp    801f23 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  801f55:	49 89 dc             	mov    %rbx,%r12
  801f58:	be 01 00 00 00       	mov    $0x1,%esi
  801f5d:	eb c4                	jmp    801f23 <vprintfmt+0x79>
            padc = ch;
  801f5f:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  801f63:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f66:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801f69:	eb b8                	jmp    801f23 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f6b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f6e:	83 f8 2f             	cmp    $0x2f,%eax
  801f71:	77 24                	ja     801f97 <vprintfmt+0xed>
  801f73:	89 c1                	mov    %eax,%ecx
  801f75:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  801f79:	83 c0 08             	add    $0x8,%eax
  801f7c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f7f:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  801f82:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  801f85:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801f89:	79 98                	jns    801f23 <vprintfmt+0x79>
                width = precision;
  801f8b:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  801f8f:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f95:	eb 8c                	jmp    801f23 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f97:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801f9b:	48 8d 41 08          	lea    0x8(%rcx),%rax
  801f9f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fa3:	eb da                	jmp    801f7f <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  801fa5:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  801faa:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fae:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  801fb4:	3c 39                	cmp    $0x39,%al
  801fb6:	77 1c                	ja     801fd4 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  801fb8:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  801fbc:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  801fc0:	0f b6 c0             	movzbl %al,%eax
  801fc3:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fc8:	0f b6 03             	movzbl (%rbx),%eax
  801fcb:	3c 39                	cmp    $0x39,%al
  801fcd:	76 e9                	jbe    801fb8 <vprintfmt+0x10e>
        process_precision:
  801fcf:	49 89 dc             	mov    %rbx,%r12
  801fd2:	eb b1                	jmp    801f85 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  801fd4:	49 89 dc             	mov    %rbx,%r12
  801fd7:	eb ac                	jmp    801f85 <vprintfmt+0xdb>
            width = MAX(0, width);
  801fd9:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  801fdc:	85 c9                	test   %ecx,%ecx
  801fde:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe3:	0f 49 c1             	cmovns %ecx,%eax
  801fe6:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801fe9:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fec:	e9 32 ff ff ff       	jmp    801f23 <vprintfmt+0x79>
            lflag++;
  801ff1:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801ff4:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801ff7:	e9 27 ff ff ff       	jmp    801f23 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  801ffc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fff:	83 f8 2f             	cmp    $0x2f,%eax
  802002:	77 19                	ja     80201d <vprintfmt+0x173>
  802004:	89 c2                	mov    %eax,%edx
  802006:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80200a:	83 c0 08             	add    $0x8,%eax
  80200d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802010:	8b 3a                	mov    (%rdx),%edi
  802012:	4c 89 ee             	mov    %r13,%rsi
  802015:	41 ff d6             	call   *%r14
            break;
  802018:	e9 c2 fe ff ff       	jmp    801edf <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  80201d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802021:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802025:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802029:	eb e5                	jmp    802010 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  80202b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80202e:	83 f8 2f             	cmp    $0x2f,%eax
  802031:	77 5a                	ja     80208d <vprintfmt+0x1e3>
  802033:	89 c2                	mov    %eax,%edx
  802035:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802039:	83 c0 08             	add    $0x8,%eax
  80203c:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  80203f:	8b 02                	mov    (%rdx),%eax
  802041:	89 c1                	mov    %eax,%ecx
  802043:	f7 d9                	neg    %ecx
  802045:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  802048:	83 f9 13             	cmp    $0x13,%ecx
  80204b:	7f 4e                	jg     80209b <vprintfmt+0x1f1>
  80204d:	48 63 c1             	movslq %ecx,%rax
  802050:	48 ba 20 36 80 00 00 	movabs $0x803620,%rdx
  802057:	00 00 00 
  80205a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80205e:	48 85 c0             	test   %rax,%rax
  802061:	74 38                	je     80209b <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  802063:	48 89 c1             	mov    %rax,%rcx
  802066:	48 ba 80 30 80 00 00 	movabs $0x803080,%rdx
  80206d:	00 00 00 
  802070:	4c 89 ee             	mov    %r13,%rsi
  802073:	4c 89 f7             	mov    %r14,%rdi
  802076:	b8 00 00 00 00       	mov    $0x0,%eax
  80207b:	49 b8 69 1e 80 00 00 	movabs $0x801e69,%r8
  802082:	00 00 00 
  802085:	41 ff d0             	call   *%r8
  802088:	e9 52 fe ff ff       	jmp    801edf <vprintfmt+0x35>
            int err = va_arg(aq, int);
  80208d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802091:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802095:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802099:	eb a4                	jmp    80203f <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  80209b:	48 ba da 30 80 00 00 	movabs $0x8030da,%rdx
  8020a2:	00 00 00 
  8020a5:	4c 89 ee             	mov    %r13,%rsi
  8020a8:	4c 89 f7             	mov    %r14,%rdi
  8020ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b0:	49 b8 69 1e 80 00 00 	movabs $0x801e69,%r8
  8020b7:	00 00 00 
  8020ba:	41 ff d0             	call   *%r8
  8020bd:	e9 1d fe ff ff       	jmp    801edf <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8020c2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020c5:	83 f8 2f             	cmp    $0x2f,%eax
  8020c8:	77 6c                	ja     802136 <vprintfmt+0x28c>
  8020ca:	89 c2                	mov    %eax,%edx
  8020cc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8020d0:	83 c0 08             	add    $0x8,%eax
  8020d3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020d6:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8020d9:	48 85 d2             	test   %rdx,%rdx
  8020dc:	48 b8 d3 30 80 00 00 	movabs $0x8030d3,%rax
  8020e3:	00 00 00 
  8020e6:	48 0f 45 c2          	cmovne %rdx,%rax
  8020ea:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8020ee:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8020f2:	7e 06                	jle    8020fa <vprintfmt+0x250>
  8020f4:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8020f8:	75 4a                	jne    802144 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8020fa:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8020fe:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802102:	0f b6 00             	movzbl (%rax),%eax
  802105:	84 c0                	test   %al,%al
  802107:	0f 85 9a 00 00 00    	jne    8021a7 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  80210d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802110:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  802114:	85 c0                	test   %eax,%eax
  802116:	0f 8e c3 fd ff ff    	jle    801edf <vprintfmt+0x35>
  80211c:	4c 89 ee             	mov    %r13,%rsi
  80211f:	bf 20 00 00 00       	mov    $0x20,%edi
  802124:	41 ff d6             	call   *%r14
  802127:	41 83 ec 01          	sub    $0x1,%r12d
  80212b:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  80212f:	75 eb                	jne    80211c <vprintfmt+0x272>
  802131:	e9 a9 fd ff ff       	jmp    801edf <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  802136:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80213a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80213e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802142:	eb 92                	jmp    8020d6 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  802144:	49 63 f7             	movslq %r15d,%rsi
  802147:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80214b:	48 b8 6d 26 80 00 00 	movabs $0x80266d,%rax
  802152:	00 00 00 
  802155:	ff d0                	call   *%rax
  802157:	48 89 c2             	mov    %rax,%rdx
  80215a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80215d:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80215f:	8d 70 ff             	lea    -0x1(%rax),%esi
  802162:	89 75 ac             	mov    %esi,-0x54(%rbp)
  802165:	85 c0                	test   %eax,%eax
  802167:	7e 91                	jle    8020fa <vprintfmt+0x250>
  802169:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80216e:	4c 89 ee             	mov    %r13,%rsi
  802171:	44 89 e7             	mov    %r12d,%edi
  802174:	41 ff d6             	call   *%r14
  802177:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80217b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80217e:	83 f8 ff             	cmp    $0xffffffff,%eax
  802181:	75 eb                	jne    80216e <vprintfmt+0x2c4>
  802183:	e9 72 ff ff ff       	jmp    8020fa <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  802188:	0f b6 f8             	movzbl %al,%edi
  80218b:	4c 89 ee             	mov    %r13,%rsi
  80218e:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802191:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  802195:	49 83 c4 01          	add    $0x1,%r12
  802199:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  80219f:	84 c0                	test   %al,%al
  8021a1:	0f 84 66 ff ff ff    	je     80210d <vprintfmt+0x263>
  8021a7:	45 85 ff             	test   %r15d,%r15d
  8021aa:	78 0a                	js     8021b6 <vprintfmt+0x30c>
  8021ac:	41 83 ef 01          	sub    $0x1,%r15d
  8021b0:	0f 88 57 ff ff ff    	js     80210d <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8021b6:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8021ba:	74 cc                	je     802188 <vprintfmt+0x2de>
  8021bc:	8d 50 e0             	lea    -0x20(%rax),%edx
  8021bf:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8021c4:	80 fa 5e             	cmp    $0x5e,%dl
  8021c7:	77 c2                	ja     80218b <vprintfmt+0x2e1>
  8021c9:	eb bd                	jmp    802188 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8021cb:	40 84 f6             	test   %sil,%sil
  8021ce:	75 26                	jne    8021f6 <vprintfmt+0x34c>
    switch (lflag) {
  8021d0:	85 d2                	test   %edx,%edx
  8021d2:	74 59                	je     80222d <vprintfmt+0x383>
  8021d4:	83 fa 01             	cmp    $0x1,%edx
  8021d7:	74 7b                	je     802254 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8021d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021dc:	83 f8 2f             	cmp    $0x2f,%eax
  8021df:	0f 87 96 00 00 00    	ja     80227b <vprintfmt+0x3d1>
  8021e5:	89 c2                	mov    %eax,%edx
  8021e7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021eb:	83 c0 08             	add    $0x8,%eax
  8021ee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021f1:	4c 8b 22             	mov    (%rdx),%r12
  8021f4:	eb 17                	jmp    80220d <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8021f6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021f9:	83 f8 2f             	cmp    $0x2f,%eax
  8021fc:	77 21                	ja     80221f <vprintfmt+0x375>
  8021fe:	89 c2                	mov    %eax,%edx
  802200:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802204:	83 c0 08             	add    $0x8,%eax
  802207:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80220a:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  80220d:	4d 85 e4             	test   %r12,%r12
  802210:	78 7a                	js     80228c <vprintfmt+0x3e2>
            num = i;
  802212:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  802215:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80221a:	e9 50 02 00 00       	jmp    80246f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80221f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802223:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802227:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80222b:	eb dd                	jmp    80220a <vprintfmt+0x360>
        return va_arg(*ap, int);
  80222d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802230:	83 f8 2f             	cmp    $0x2f,%eax
  802233:	77 11                	ja     802246 <vprintfmt+0x39c>
  802235:	89 c2                	mov    %eax,%edx
  802237:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80223b:	83 c0 08             	add    $0x8,%eax
  80223e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802241:	4c 63 22             	movslq (%rdx),%r12
  802244:	eb c7                	jmp    80220d <vprintfmt+0x363>
  802246:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80224a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80224e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802252:	eb ed                	jmp    802241 <vprintfmt+0x397>
        return va_arg(*ap, long);
  802254:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802257:	83 f8 2f             	cmp    $0x2f,%eax
  80225a:	77 11                	ja     80226d <vprintfmt+0x3c3>
  80225c:	89 c2                	mov    %eax,%edx
  80225e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802262:	83 c0 08             	add    $0x8,%eax
  802265:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802268:	4c 8b 22             	mov    (%rdx),%r12
  80226b:	eb a0                	jmp    80220d <vprintfmt+0x363>
  80226d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802271:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802275:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802279:	eb ed                	jmp    802268 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  80227b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80227f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802283:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802287:	e9 65 ff ff ff       	jmp    8021f1 <vprintfmt+0x347>
                putch('-', put_arg);
  80228c:	4c 89 ee             	mov    %r13,%rsi
  80228f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802294:	41 ff d6             	call   *%r14
                i = -i;
  802297:	49 f7 dc             	neg    %r12
  80229a:	e9 73 ff ff ff       	jmp    802212 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  80229f:	40 84 f6             	test   %sil,%sil
  8022a2:	75 32                	jne    8022d6 <vprintfmt+0x42c>
    switch (lflag) {
  8022a4:	85 d2                	test   %edx,%edx
  8022a6:	74 5d                	je     802305 <vprintfmt+0x45b>
  8022a8:	83 fa 01             	cmp    $0x1,%edx
  8022ab:	0f 84 82 00 00 00    	je     802333 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8022b1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022b4:	83 f8 2f             	cmp    $0x2f,%eax
  8022b7:	0f 87 a5 00 00 00    	ja     802362 <vprintfmt+0x4b8>
  8022bd:	89 c2                	mov    %eax,%edx
  8022bf:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022c3:	83 c0 08             	add    $0x8,%eax
  8022c6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022c9:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8022d1:	e9 99 01 00 00       	jmp    80246f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8022d6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022d9:	83 f8 2f             	cmp    $0x2f,%eax
  8022dc:	77 19                	ja     8022f7 <vprintfmt+0x44d>
  8022de:	89 c2                	mov    %eax,%edx
  8022e0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022e4:	83 c0 08             	add    $0x8,%eax
  8022e7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022ea:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8022f2:	e9 78 01 00 00       	jmp    80246f <vprintfmt+0x5c5>
  8022f7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8022fb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8022ff:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802303:	eb e5                	jmp    8022ea <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  802305:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802308:	83 f8 2f             	cmp    $0x2f,%eax
  80230b:	77 18                	ja     802325 <vprintfmt+0x47b>
  80230d:	89 c2                	mov    %eax,%edx
  80230f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802313:	83 c0 08             	add    $0x8,%eax
  802316:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802319:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  80231b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802320:	e9 4a 01 00 00       	jmp    80246f <vprintfmt+0x5c5>
  802325:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802329:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80232d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802331:	eb e6                	jmp    802319 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  802333:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802336:	83 f8 2f             	cmp    $0x2f,%eax
  802339:	77 19                	ja     802354 <vprintfmt+0x4aa>
  80233b:	89 c2                	mov    %eax,%edx
  80233d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802341:	83 c0 08             	add    $0x8,%eax
  802344:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802347:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80234a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80234f:	e9 1b 01 00 00       	jmp    80246f <vprintfmt+0x5c5>
  802354:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802358:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80235c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802360:	eb e5                	jmp    802347 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  802362:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802366:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80236a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80236e:	e9 56 ff ff ff       	jmp    8022c9 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  802373:	40 84 f6             	test   %sil,%sil
  802376:	75 2e                	jne    8023a6 <vprintfmt+0x4fc>
    switch (lflag) {
  802378:	85 d2                	test   %edx,%edx
  80237a:	74 59                	je     8023d5 <vprintfmt+0x52b>
  80237c:	83 fa 01             	cmp    $0x1,%edx
  80237f:	74 7f                	je     802400 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  802381:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802384:	83 f8 2f             	cmp    $0x2f,%eax
  802387:	0f 87 9f 00 00 00    	ja     80242c <vprintfmt+0x582>
  80238d:	89 c2                	mov    %eax,%edx
  80238f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802393:	83 c0 08             	add    $0x8,%eax
  802396:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802399:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80239c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8023a1:	e9 c9 00 00 00       	jmp    80246f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8023a6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023a9:	83 f8 2f             	cmp    $0x2f,%eax
  8023ac:	77 19                	ja     8023c7 <vprintfmt+0x51d>
  8023ae:	89 c2                	mov    %eax,%edx
  8023b0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023b4:	83 c0 08             	add    $0x8,%eax
  8023b7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023ba:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023bd:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8023c2:	e9 a8 00 00 00       	jmp    80246f <vprintfmt+0x5c5>
  8023c7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023cb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023cf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023d3:	eb e5                	jmp    8023ba <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8023d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023d8:	83 f8 2f             	cmp    $0x2f,%eax
  8023db:	77 15                	ja     8023f2 <vprintfmt+0x548>
  8023dd:	89 c2                	mov    %eax,%edx
  8023df:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023e3:	83 c0 08             	add    $0x8,%eax
  8023e6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023e9:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8023eb:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8023f0:	eb 7d                	jmp    80246f <vprintfmt+0x5c5>
  8023f2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023f6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023fa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023fe:	eb e9                	jmp    8023e9 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  802400:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802403:	83 f8 2f             	cmp    $0x2f,%eax
  802406:	77 16                	ja     80241e <vprintfmt+0x574>
  802408:	89 c2                	mov    %eax,%edx
  80240a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80240e:	83 c0 08             	add    $0x8,%eax
  802411:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802414:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  802417:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  80241c:	eb 51                	jmp    80246f <vprintfmt+0x5c5>
  80241e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802422:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802426:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80242a:	eb e8                	jmp    802414 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  80242c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802430:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802434:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802438:	e9 5c ff ff ff       	jmp    802399 <vprintfmt+0x4ef>
            putch('0', put_arg);
  80243d:	4c 89 ee             	mov    %r13,%rsi
  802440:	bf 30 00 00 00       	mov    $0x30,%edi
  802445:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  802448:	4c 89 ee             	mov    %r13,%rsi
  80244b:	bf 78 00 00 00       	mov    $0x78,%edi
  802450:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  802453:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802456:	83 f8 2f             	cmp    $0x2f,%eax
  802459:	77 47                	ja     8024a2 <vprintfmt+0x5f8>
  80245b:	89 c2                	mov    %eax,%edx
  80245d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802461:	83 c0 08             	add    $0x8,%eax
  802464:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802467:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80246a:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80246f:	48 83 ec 08          	sub    $0x8,%rsp
  802473:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  802477:	0f 94 c0             	sete   %al
  80247a:	0f b6 c0             	movzbl %al,%eax
  80247d:	50                   	push   %rax
  80247e:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  802483:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  802487:	4c 89 ee             	mov    %r13,%rsi
  80248a:	4c 89 f7             	mov    %r14,%rdi
  80248d:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  802494:	00 00 00 
  802497:	ff d0                	call   *%rax
            break;
  802499:	48 83 c4 10          	add    $0x10,%rsp
  80249d:	e9 3d fa ff ff       	jmp    801edf <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  8024a2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024a6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8024aa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024ae:	eb b7                	jmp    802467 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  8024b0:	40 84 f6             	test   %sil,%sil
  8024b3:	75 2b                	jne    8024e0 <vprintfmt+0x636>
    switch (lflag) {
  8024b5:	85 d2                	test   %edx,%edx
  8024b7:	74 56                	je     80250f <vprintfmt+0x665>
  8024b9:	83 fa 01             	cmp    $0x1,%edx
  8024bc:	74 7f                	je     80253d <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  8024be:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024c1:	83 f8 2f             	cmp    $0x2f,%eax
  8024c4:	0f 87 a2 00 00 00    	ja     80256c <vprintfmt+0x6c2>
  8024ca:	89 c2                	mov    %eax,%edx
  8024cc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024d0:	83 c0 08             	add    $0x8,%eax
  8024d3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024d6:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024d9:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8024de:	eb 8f                	jmp    80246f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8024e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024e3:	83 f8 2f             	cmp    $0x2f,%eax
  8024e6:	77 19                	ja     802501 <vprintfmt+0x657>
  8024e8:	89 c2                	mov    %eax,%edx
  8024ea:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024ee:	83 c0 08             	add    $0x8,%eax
  8024f1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024f4:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024f7:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8024fc:	e9 6e ff ff ff       	jmp    80246f <vprintfmt+0x5c5>
  802501:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802505:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802509:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80250d:	eb e5                	jmp    8024f4 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  80250f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802512:	83 f8 2f             	cmp    $0x2f,%eax
  802515:	77 18                	ja     80252f <vprintfmt+0x685>
  802517:	89 c2                	mov    %eax,%edx
  802519:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80251d:	83 c0 08             	add    $0x8,%eax
  802520:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802523:	8b 12                	mov    (%rdx),%edx
            base = 16;
  802525:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  80252a:	e9 40 ff ff ff       	jmp    80246f <vprintfmt+0x5c5>
  80252f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802533:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802537:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80253b:	eb e6                	jmp    802523 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  80253d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802540:	83 f8 2f             	cmp    $0x2f,%eax
  802543:	77 19                	ja     80255e <vprintfmt+0x6b4>
  802545:	89 c2                	mov    %eax,%edx
  802547:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80254b:	83 c0 08             	add    $0x8,%eax
  80254e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802551:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802554:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  802559:	e9 11 ff ff ff       	jmp    80246f <vprintfmt+0x5c5>
  80255e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802562:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802566:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80256a:	eb e5                	jmp    802551 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  80256c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802570:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802574:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802578:	e9 59 ff ff ff       	jmp    8024d6 <vprintfmt+0x62c>
            putch(ch, put_arg);
  80257d:	4c 89 ee             	mov    %r13,%rsi
  802580:	bf 25 00 00 00       	mov    $0x25,%edi
  802585:	41 ff d6             	call   *%r14
            break;
  802588:	e9 52 f9 ff ff       	jmp    801edf <vprintfmt+0x35>
            putch('%', put_arg);
  80258d:	4c 89 ee             	mov    %r13,%rsi
  802590:	bf 25 00 00 00       	mov    $0x25,%edi
  802595:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  802598:	48 83 eb 01          	sub    $0x1,%rbx
  80259c:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  8025a0:	75 f6                	jne    802598 <vprintfmt+0x6ee>
  8025a2:	e9 38 f9 ff ff       	jmp    801edf <vprintfmt+0x35>
}
  8025a7:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8025ab:	5b                   	pop    %rbx
  8025ac:	41 5c                	pop    %r12
  8025ae:	41 5d                	pop    %r13
  8025b0:	41 5e                	pop    %r14
  8025b2:	41 5f                	pop    %r15
  8025b4:	5d                   	pop    %rbp
  8025b5:	c3                   	ret

00000000008025b6 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  8025b6:	f3 0f 1e fa          	endbr64
  8025ba:	55                   	push   %rbp
  8025bb:	48 89 e5             	mov    %rsp,%rbp
  8025be:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  8025c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025c6:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  8025cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8025cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8025d6:	48 85 ff             	test   %rdi,%rdi
  8025d9:	74 2b                	je     802606 <vsnprintf+0x50>
  8025db:	48 85 f6             	test   %rsi,%rsi
  8025de:	74 26                	je     802606 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8025e0:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8025e4:	48 bf 4d 1e 80 00 00 	movabs $0x801e4d,%rdi
  8025eb:	00 00 00 
  8025ee:	48 b8 aa 1e 80 00 00 	movabs $0x801eaa,%rax
  8025f5:	00 00 00 
  8025f8:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8025fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025fe:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  802601:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802604:	c9                   	leave
  802605:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  802606:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80260b:	eb f7                	jmp    802604 <vsnprintf+0x4e>

000000000080260d <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  80260d:	f3 0f 1e fa          	endbr64
  802611:	55                   	push   %rbp
  802612:	48 89 e5             	mov    %rsp,%rbp
  802615:	48 83 ec 50          	sub    $0x50,%rsp
  802619:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80261d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802621:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802625:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80262c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802630:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802634:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802638:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  80263c:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  802640:	48 b8 b6 25 80 00 00 	movabs $0x8025b6,%rax
  802647:	00 00 00 
  80264a:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  80264c:	c9                   	leave
  80264d:	c3                   	ret

000000000080264e <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  80264e:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  802652:	80 3f 00             	cmpb   $0x0,(%rdi)
  802655:	74 10                	je     802667 <strlen+0x19>
    size_t n = 0;
  802657:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  80265c:	48 83 c0 01          	add    $0x1,%rax
  802660:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  802664:	75 f6                	jne    80265c <strlen+0xe>
  802666:	c3                   	ret
    size_t n = 0;
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  80266c:	c3                   	ret

000000000080266d <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  80266d:	f3 0f 1e fa          	endbr64
  802671:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  802674:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  802679:	48 85 f6             	test   %rsi,%rsi
  80267c:	74 10                	je     80268e <strnlen+0x21>
  80267e:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  802682:	74 0b                	je     80268f <strnlen+0x22>
  802684:	48 83 c2 01          	add    $0x1,%rdx
  802688:	48 39 d0             	cmp    %rdx,%rax
  80268b:	75 f1                	jne    80267e <strnlen+0x11>
  80268d:	c3                   	ret
  80268e:	c3                   	ret
  80268f:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  802692:	c3                   	ret

0000000000802693 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  802693:	f3 0f 1e fa          	endbr64
  802697:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80269a:	ba 00 00 00 00       	mov    $0x0,%edx
  80269f:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  8026a3:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  8026a6:	48 83 c2 01          	add    $0x1,%rdx
  8026aa:	84 c9                	test   %cl,%cl
  8026ac:	75 f1                	jne    80269f <strcpy+0xc>
        ;
    return res;
}
  8026ae:	c3                   	ret

00000000008026af <strcat>:

char *
strcat(char *dst, const char *src) {
  8026af:	f3 0f 1e fa          	endbr64
  8026b3:	55                   	push   %rbp
  8026b4:	48 89 e5             	mov    %rsp,%rbp
  8026b7:	41 54                	push   %r12
  8026b9:	53                   	push   %rbx
  8026ba:	48 89 fb             	mov    %rdi,%rbx
  8026bd:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8026c0:	48 b8 4e 26 80 00 00 	movabs $0x80264e,%rax
  8026c7:	00 00 00 
  8026ca:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  8026cc:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8026d0:	4c 89 e6             	mov    %r12,%rsi
  8026d3:	48 b8 93 26 80 00 00 	movabs $0x802693,%rax
  8026da:	00 00 00 
  8026dd:	ff d0                	call   *%rax
    return dst;
}
  8026df:	48 89 d8             	mov    %rbx,%rax
  8026e2:	5b                   	pop    %rbx
  8026e3:	41 5c                	pop    %r12
  8026e5:	5d                   	pop    %rbp
  8026e6:	c3                   	ret

00000000008026e7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8026e7:	f3 0f 1e fa          	endbr64
  8026eb:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  8026ee:	48 85 d2             	test   %rdx,%rdx
  8026f1:	74 1f                	je     802712 <strncpy+0x2b>
  8026f3:	48 01 fa             	add    %rdi,%rdx
  8026f6:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  8026f9:	48 83 c1 01          	add    $0x1,%rcx
  8026fd:	44 0f b6 06          	movzbl (%rsi),%r8d
  802701:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  802705:	41 80 f8 01          	cmp    $0x1,%r8b
  802709:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  80270d:	48 39 ca             	cmp    %rcx,%rdx
  802710:	75 e7                	jne    8026f9 <strncpy+0x12>
    }
    return ret;
}
  802712:	c3                   	ret

0000000000802713 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  802713:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  802717:	48 89 f8             	mov    %rdi,%rax
  80271a:	48 85 d2             	test   %rdx,%rdx
  80271d:	74 24                	je     802743 <strlcpy+0x30>
        while (--size > 0 && *src)
  80271f:	48 83 ea 01          	sub    $0x1,%rdx
  802723:	74 1b                	je     802740 <strlcpy+0x2d>
  802725:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802729:	0f b6 16             	movzbl (%rsi),%edx
  80272c:	84 d2                	test   %dl,%dl
  80272e:	74 10                	je     802740 <strlcpy+0x2d>
            *dst++ = *src++;
  802730:	48 83 c6 01          	add    $0x1,%rsi
  802734:	48 83 c0 01          	add    $0x1,%rax
  802738:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80273b:	48 39 c8             	cmp    %rcx,%rax
  80273e:	75 e9                	jne    802729 <strlcpy+0x16>
        *dst = '\0';
  802740:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  802743:	48 29 f8             	sub    %rdi,%rax
}
  802746:	c3                   	ret

0000000000802747 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  802747:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  80274b:	0f b6 07             	movzbl (%rdi),%eax
  80274e:	84 c0                	test   %al,%al
  802750:	74 13                	je     802765 <strcmp+0x1e>
  802752:	38 06                	cmp    %al,(%rsi)
  802754:	75 0f                	jne    802765 <strcmp+0x1e>
  802756:	48 83 c7 01          	add    $0x1,%rdi
  80275a:	48 83 c6 01          	add    $0x1,%rsi
  80275e:	0f b6 07             	movzbl (%rdi),%eax
  802761:	84 c0                	test   %al,%al
  802763:	75 ed                	jne    802752 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  802765:	0f b6 c0             	movzbl %al,%eax
  802768:	0f b6 16             	movzbl (%rsi),%edx
  80276b:	29 d0                	sub    %edx,%eax
}
  80276d:	c3                   	ret

000000000080276e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  80276e:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  802772:	48 85 d2             	test   %rdx,%rdx
  802775:	74 1f                	je     802796 <strncmp+0x28>
  802777:	0f b6 07             	movzbl (%rdi),%eax
  80277a:	84 c0                	test   %al,%al
  80277c:	74 1e                	je     80279c <strncmp+0x2e>
  80277e:	3a 06                	cmp    (%rsi),%al
  802780:	75 1a                	jne    80279c <strncmp+0x2e>
  802782:	48 83 c7 01          	add    $0x1,%rdi
  802786:	48 83 c6 01          	add    $0x1,%rsi
  80278a:	48 83 ea 01          	sub    $0x1,%rdx
  80278e:	75 e7                	jne    802777 <strncmp+0x9>

    if (!n) return 0;
  802790:	b8 00 00 00 00       	mov    $0x0,%eax
  802795:	c3                   	ret
  802796:	b8 00 00 00 00       	mov    $0x0,%eax
  80279b:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  80279c:	0f b6 07             	movzbl (%rdi),%eax
  80279f:	0f b6 16             	movzbl (%rsi),%edx
  8027a2:	29 d0                	sub    %edx,%eax
}
  8027a4:	c3                   	ret

00000000008027a5 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  8027a5:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  8027a9:	0f b6 17             	movzbl (%rdi),%edx
  8027ac:	84 d2                	test   %dl,%dl
  8027ae:	74 18                	je     8027c8 <strchr+0x23>
        if (*str == c) {
  8027b0:	0f be d2             	movsbl %dl,%edx
  8027b3:	39 f2                	cmp    %esi,%edx
  8027b5:	74 17                	je     8027ce <strchr+0x29>
    for (; *str; str++) {
  8027b7:	48 83 c7 01          	add    $0x1,%rdi
  8027bb:	0f b6 17             	movzbl (%rdi),%edx
  8027be:	84 d2                	test   %dl,%dl
  8027c0:	75 ee                	jne    8027b0 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  8027c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c7:	c3                   	ret
  8027c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cd:	c3                   	ret
            return (char *)str;
  8027ce:	48 89 f8             	mov    %rdi,%rax
}
  8027d1:	c3                   	ret

00000000008027d2 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  8027d2:	f3 0f 1e fa          	endbr64
  8027d6:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  8027d9:	0f b6 17             	movzbl (%rdi),%edx
  8027dc:	84 d2                	test   %dl,%dl
  8027de:	74 13                	je     8027f3 <strfind+0x21>
  8027e0:	0f be d2             	movsbl %dl,%edx
  8027e3:	39 f2                	cmp    %esi,%edx
  8027e5:	74 0b                	je     8027f2 <strfind+0x20>
  8027e7:	48 83 c0 01          	add    $0x1,%rax
  8027eb:	0f b6 10             	movzbl (%rax),%edx
  8027ee:	84 d2                	test   %dl,%dl
  8027f0:	75 ee                	jne    8027e0 <strfind+0xe>
        ;
    return (char *)str;
}
  8027f2:	c3                   	ret
  8027f3:	c3                   	ret

00000000008027f4 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8027f4:	f3 0f 1e fa          	endbr64
  8027f8:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  8027fb:	48 89 f8             	mov    %rdi,%rax
  8027fe:	48 f7 d8             	neg    %rax
  802801:	83 e0 07             	and    $0x7,%eax
  802804:	49 89 d1             	mov    %rdx,%r9
  802807:	49 29 c1             	sub    %rax,%r9
  80280a:	78 36                	js     802842 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  80280c:	40 0f b6 c6          	movzbl %sil,%eax
  802810:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  802817:	01 01 01 
  80281a:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80281e:	40 f6 c7 07          	test   $0x7,%dil
  802822:	75 38                	jne    80285c <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  802824:	4c 89 c9             	mov    %r9,%rcx
  802827:	48 c1 f9 03          	sar    $0x3,%rcx
  80282b:	74 0c                	je     802839 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80282d:	fc                   	cld
  80282e:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802831:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  802835:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  802839:	4d 85 c9             	test   %r9,%r9
  80283c:	75 45                	jne    802883 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  80283e:	4c 89 c0             	mov    %r8,%rax
  802841:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  802842:	48 85 d2             	test   %rdx,%rdx
  802845:	74 f7                	je     80283e <memset+0x4a>
  802847:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  80284a:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  80284d:	48 83 c0 01          	add    $0x1,%rax
  802851:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  802855:	48 39 c2             	cmp    %rax,%rdx
  802858:	75 f3                	jne    80284d <memset+0x59>
  80285a:	eb e2                	jmp    80283e <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  80285c:	40 f6 c7 01          	test   $0x1,%dil
  802860:	74 06                	je     802868 <memset+0x74>
  802862:	88 07                	mov    %al,(%rdi)
  802864:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  802868:	40 f6 c7 02          	test   $0x2,%dil
  80286c:	74 07                	je     802875 <memset+0x81>
  80286e:	66 89 07             	mov    %ax,(%rdi)
  802871:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  802875:	40 f6 c7 04          	test   $0x4,%dil
  802879:	74 a9                	je     802824 <memset+0x30>
  80287b:	89 07                	mov    %eax,(%rdi)
  80287d:	48 83 c7 04          	add    $0x4,%rdi
  802881:	eb a1                	jmp    802824 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  802883:	41 f6 c1 04          	test   $0x4,%r9b
  802887:	74 1b                	je     8028a4 <memset+0xb0>
  802889:	89 07                	mov    %eax,(%rdi)
  80288b:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80288f:	41 f6 c1 02          	test   $0x2,%r9b
  802893:	74 07                	je     80289c <memset+0xa8>
  802895:	66 89 07             	mov    %ax,(%rdi)
  802898:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80289c:	41 f6 c1 01          	test   $0x1,%r9b
  8028a0:	74 9c                	je     80283e <memset+0x4a>
  8028a2:	eb 06                	jmp    8028aa <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8028a4:	41 f6 c1 02          	test   $0x2,%r9b
  8028a8:	75 eb                	jne    802895 <memset+0xa1>
        if (ni & 1) *ptr = k;
  8028aa:	88 07                	mov    %al,(%rdi)
  8028ac:	eb 90                	jmp    80283e <memset+0x4a>

00000000008028ae <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8028ae:	f3 0f 1e fa          	endbr64
  8028b2:	48 89 f8             	mov    %rdi,%rax
  8028b5:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8028b8:	48 39 fe             	cmp    %rdi,%rsi
  8028bb:	73 3b                	jae    8028f8 <memmove+0x4a>
  8028bd:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8028c1:	48 39 d7             	cmp    %rdx,%rdi
  8028c4:	73 32                	jae    8028f8 <memmove+0x4a>
        s += n;
        d += n;
  8028c6:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028ca:	48 89 d6             	mov    %rdx,%rsi
  8028cd:	48 09 fe             	or     %rdi,%rsi
  8028d0:	48 09 ce             	or     %rcx,%rsi
  8028d3:	40 f6 c6 07          	test   $0x7,%sil
  8028d7:	75 12                	jne    8028eb <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8028d9:	48 83 ef 08          	sub    $0x8,%rdi
  8028dd:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8028e1:	48 c1 e9 03          	shr    $0x3,%rcx
  8028e5:	fd                   	std
  8028e6:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8028e9:	fc                   	cld
  8028ea:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8028eb:	48 83 ef 01          	sub    $0x1,%rdi
  8028ef:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8028f3:	fd                   	std
  8028f4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8028f6:	eb f1                	jmp    8028e9 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028f8:	48 89 f2             	mov    %rsi,%rdx
  8028fb:	48 09 c2             	or     %rax,%rdx
  8028fe:	48 09 ca             	or     %rcx,%rdx
  802901:	f6 c2 07             	test   $0x7,%dl
  802904:	75 0c                	jne    802912 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  802906:	48 c1 e9 03          	shr    $0x3,%rcx
  80290a:	48 89 c7             	mov    %rax,%rdi
  80290d:	fc                   	cld
  80290e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  802911:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  802912:	48 89 c7             	mov    %rax,%rdi
  802915:	fc                   	cld
  802916:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  802918:	c3                   	ret

0000000000802919 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  802919:	f3 0f 1e fa          	endbr64
  80291d:	55                   	push   %rbp
  80291e:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802921:	48 b8 ae 28 80 00 00 	movabs $0x8028ae,%rax
  802928:	00 00 00 
  80292b:	ff d0                	call   *%rax
}
  80292d:	5d                   	pop    %rbp
  80292e:	c3                   	ret

000000000080292f <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80292f:	f3 0f 1e fa          	endbr64
  802933:	55                   	push   %rbp
  802934:	48 89 e5             	mov    %rsp,%rbp
  802937:	41 57                	push   %r15
  802939:	41 56                	push   %r14
  80293b:	41 55                	push   %r13
  80293d:	41 54                	push   %r12
  80293f:	53                   	push   %rbx
  802940:	48 83 ec 08          	sub    $0x8,%rsp
  802944:	49 89 fe             	mov    %rdi,%r14
  802947:	49 89 f7             	mov    %rsi,%r15
  80294a:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  80294d:	48 89 f7             	mov    %rsi,%rdi
  802950:	48 b8 4e 26 80 00 00 	movabs $0x80264e,%rax
  802957:	00 00 00 
  80295a:	ff d0                	call   *%rax
  80295c:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80295f:	48 89 de             	mov    %rbx,%rsi
  802962:	4c 89 f7             	mov    %r14,%rdi
  802965:	48 b8 6d 26 80 00 00 	movabs $0x80266d,%rax
  80296c:	00 00 00 
  80296f:	ff d0                	call   *%rax
  802971:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  802974:	48 39 c3             	cmp    %rax,%rbx
  802977:	74 36                	je     8029af <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  802979:	48 89 d8             	mov    %rbx,%rax
  80297c:	4c 29 e8             	sub    %r13,%rax
  80297f:	49 39 c4             	cmp    %rax,%r12
  802982:	73 31                	jae    8029b5 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  802984:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  802989:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80298d:	4c 89 fe             	mov    %r15,%rsi
  802990:	48 b8 19 29 80 00 00 	movabs $0x802919,%rax
  802997:	00 00 00 
  80299a:	ff d0                	call   *%rax
    return dstlen + srclen;
  80299c:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8029a0:	48 83 c4 08          	add    $0x8,%rsp
  8029a4:	5b                   	pop    %rbx
  8029a5:	41 5c                	pop    %r12
  8029a7:	41 5d                	pop    %r13
  8029a9:	41 5e                	pop    %r14
  8029ab:	41 5f                	pop    %r15
  8029ad:	5d                   	pop    %rbp
  8029ae:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  8029af:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  8029b3:	eb eb                	jmp    8029a0 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  8029b5:	48 83 eb 01          	sub    $0x1,%rbx
  8029b9:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8029bd:	48 89 da             	mov    %rbx,%rdx
  8029c0:	4c 89 fe             	mov    %r15,%rsi
  8029c3:	48 b8 19 29 80 00 00 	movabs $0x802919,%rax
  8029ca:	00 00 00 
  8029cd:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8029cf:	49 01 de             	add    %rbx,%r14
  8029d2:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8029d7:	eb c3                	jmp    80299c <strlcat+0x6d>

00000000008029d9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8029d9:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8029dd:	48 85 d2             	test   %rdx,%rdx
  8029e0:	74 2d                	je     802a0f <memcmp+0x36>
  8029e2:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8029e7:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8029eb:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8029f0:	44 38 c1             	cmp    %r8b,%cl
  8029f3:	75 0f                	jne    802a04 <memcmp+0x2b>
    while (n-- > 0) {
  8029f5:	48 83 c0 01          	add    $0x1,%rax
  8029f9:	48 39 c2             	cmp    %rax,%rdx
  8029fc:	75 e9                	jne    8029e7 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8029fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802a03:	c3                   	ret
            return (int)*s1 - (int)*s2;
  802a04:	0f b6 c1             	movzbl %cl,%eax
  802a07:	45 0f b6 c0          	movzbl %r8b,%r8d
  802a0b:	44 29 c0             	sub    %r8d,%eax
  802a0e:	c3                   	ret
    return 0;
  802a0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a14:	c3                   	ret

0000000000802a15 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  802a15:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  802a19:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802a1d:	48 39 c7             	cmp    %rax,%rdi
  802a20:	73 0f                	jae    802a31 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802a22:	40 38 37             	cmp    %sil,(%rdi)
  802a25:	74 0e                	je     802a35 <memfind+0x20>
    for (; src < end; src++) {
  802a27:	48 83 c7 01          	add    $0x1,%rdi
  802a2b:	48 39 f8             	cmp    %rdi,%rax
  802a2e:	75 f2                	jne    802a22 <memfind+0xd>
  802a30:	c3                   	ret
  802a31:	48 89 f8             	mov    %rdi,%rax
  802a34:	c3                   	ret
  802a35:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802a38:	c3                   	ret

0000000000802a39 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802a39:	f3 0f 1e fa          	endbr64
  802a3d:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802a40:	0f b6 37             	movzbl (%rdi),%esi
  802a43:	40 80 fe 20          	cmp    $0x20,%sil
  802a47:	74 06                	je     802a4f <strtol+0x16>
  802a49:	40 80 fe 09          	cmp    $0x9,%sil
  802a4d:	75 13                	jne    802a62 <strtol+0x29>
  802a4f:	48 83 c7 01          	add    $0x1,%rdi
  802a53:	0f b6 37             	movzbl (%rdi),%esi
  802a56:	40 80 fe 20          	cmp    $0x20,%sil
  802a5a:	74 f3                	je     802a4f <strtol+0x16>
  802a5c:	40 80 fe 09          	cmp    $0x9,%sil
  802a60:	74 ed                	je     802a4f <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802a62:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802a65:	83 e0 fd             	and    $0xfffffffd,%eax
  802a68:	3c 01                	cmp    $0x1,%al
  802a6a:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a6e:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  802a74:	75 0f                	jne    802a85 <strtol+0x4c>
  802a76:	80 3f 30             	cmpb   $0x30,(%rdi)
  802a79:	74 14                	je     802a8f <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802a7b:	85 d2                	test   %edx,%edx
  802a7d:	b8 0a 00 00 00       	mov    $0xa,%eax
  802a82:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  802a85:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  802a8a:	4c 63 ca             	movslq %edx,%r9
  802a8d:	eb 36                	jmp    802ac5 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a8f:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  802a93:	74 0f                	je     802aa4 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  802a95:	85 d2                	test   %edx,%edx
  802a97:	75 ec                	jne    802a85 <strtol+0x4c>
        s++;
  802a99:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  802a9d:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  802aa2:	eb e1                	jmp    802a85 <strtol+0x4c>
        s += 2;
  802aa4:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  802aa8:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  802aad:	eb d6                	jmp    802a85 <strtol+0x4c>
            dig -= '0';
  802aaf:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  802ab2:	44 0f b6 c1          	movzbl %cl,%r8d
  802ab6:	41 39 d0             	cmp    %edx,%r8d
  802ab9:	7d 21                	jge    802adc <strtol+0xa3>
        val = val * base + dig;
  802abb:	49 0f af c1          	imul   %r9,%rax
  802abf:	0f b6 c9             	movzbl %cl,%ecx
  802ac2:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  802ac5:	48 83 c7 01          	add    $0x1,%rdi
  802ac9:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  802acd:	80 f9 39             	cmp    $0x39,%cl
  802ad0:	76 dd                	jbe    802aaf <strtol+0x76>
        else if (dig - 'a' < 27)
  802ad2:	80 f9 7b             	cmp    $0x7b,%cl
  802ad5:	77 05                	ja     802adc <strtol+0xa3>
            dig -= 'a' - 10;
  802ad7:	83 e9 57             	sub    $0x57,%ecx
  802ada:	eb d6                	jmp    802ab2 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  802adc:	4d 85 d2             	test   %r10,%r10
  802adf:	74 03                	je     802ae4 <strtol+0xab>
  802ae1:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802ae4:	48 89 c2             	mov    %rax,%rdx
  802ae7:	48 f7 da             	neg    %rdx
  802aea:	40 80 fe 2d          	cmp    $0x2d,%sil
  802aee:	48 0f 44 c2          	cmove  %rdx,%rax
}
  802af2:	c3                   	ret

0000000000802af3 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802af3:	f3 0f 1e fa          	endbr64
  802af7:	55                   	push   %rbp
  802af8:	48 89 e5             	mov    %rsp,%rbp
  802afb:	41 54                	push   %r12
  802afd:	53                   	push   %rbx
  802afe:	48 89 fb             	mov    %rdi,%rbx
  802b01:	48 89 f7             	mov    %rsi,%rdi
  802b04:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b07:	48 85 f6             	test   %rsi,%rsi
  802b0a:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b11:	00 00 00 
  802b14:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b18:	be 00 10 00 00       	mov    $0x1000,%esi
  802b1d:	48 b8 e5 05 80 00 00 	movabs $0x8005e5,%rax
  802b24:	00 00 00 
  802b27:	ff d0                	call   *%rax
    if (res < 0) {
  802b29:	85 c0                	test   %eax,%eax
  802b2b:	78 45                	js     802b72 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b2d:	48 85 db             	test   %rbx,%rbx
  802b30:	74 12                	je     802b44 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b32:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b39:	00 00 00 
  802b3c:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b42:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b44:	4d 85 e4             	test   %r12,%r12
  802b47:	74 14                	je     802b5d <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b49:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b50:	00 00 00 
  802b53:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b59:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b5d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b64:	00 00 00 
  802b67:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b6d:	5b                   	pop    %rbx
  802b6e:	41 5c                	pop    %r12
  802b70:	5d                   	pop    %rbp
  802b71:	c3                   	ret
        if (from_env_store != NULL) {
  802b72:	48 85 db             	test   %rbx,%rbx
  802b75:	74 06                	je     802b7d <ipc_recv+0x8a>
            *from_env_store = 0;
  802b77:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b7d:	4d 85 e4             	test   %r12,%r12
  802b80:	74 eb                	je     802b6d <ipc_recv+0x7a>
            *perm_store = 0;
  802b82:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b89:	00 
  802b8a:	eb e1                	jmp    802b6d <ipc_recv+0x7a>

0000000000802b8c <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b8c:	f3 0f 1e fa          	endbr64
  802b90:	55                   	push   %rbp
  802b91:	48 89 e5             	mov    %rsp,%rbp
  802b94:	41 57                	push   %r15
  802b96:	41 56                	push   %r14
  802b98:	41 55                	push   %r13
  802b9a:	41 54                	push   %r12
  802b9c:	53                   	push   %rbx
  802b9d:	48 83 ec 18          	sub    $0x18,%rsp
  802ba1:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802ba4:	48 89 d3             	mov    %rdx,%rbx
  802ba7:	49 89 cc             	mov    %rcx,%r12
  802baa:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802bad:	48 85 d2             	test   %rdx,%rdx
  802bb0:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bb7:	00 00 00 
  802bba:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bbe:	89 f0                	mov    %esi,%eax
  802bc0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802bc4:	48 89 da             	mov    %rbx,%rdx
  802bc7:	48 89 c6             	mov    %rax,%rsi
  802bca:	48 b8 b5 05 80 00 00 	movabs $0x8005b5,%rax
  802bd1:	00 00 00 
  802bd4:	ff d0                	call   *%rax
    while (res < 0) {
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	79 65                	jns    802c3f <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bda:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bdd:	75 33                	jne    802c12 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802bdf:	49 bf 28 02 80 00 00 	movabs $0x800228,%r15
  802be6:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802be9:	49 be b5 05 80 00 00 	movabs $0x8005b5,%r14
  802bf0:	00 00 00 
        sys_yield();
  802bf3:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bf6:	45 89 e8             	mov    %r13d,%r8d
  802bf9:	4c 89 e1             	mov    %r12,%rcx
  802bfc:	48 89 da             	mov    %rbx,%rdx
  802bff:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802c03:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802c06:	41 ff d6             	call   *%r14
    while (res < 0) {
  802c09:	85 c0                	test   %eax,%eax
  802c0b:	79 32                	jns    802c3f <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c0d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c10:	74 e1                	je     802bf3 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c12:	89 c1                	mov    %eax,%ecx
  802c14:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  802c1b:	00 00 00 
  802c1e:	be 42 00 00 00       	mov    $0x42,%esi
  802c23:	48 bf 4b 32 80 00 00 	movabs $0x80324b,%rdi
  802c2a:	00 00 00 
  802c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c32:	49 b8 ee 1b 80 00 00 	movabs $0x801bee,%r8
  802c39:	00 00 00 
  802c3c:	41 ff d0             	call   *%r8
    }
}
  802c3f:	48 83 c4 18          	add    $0x18,%rsp
  802c43:	5b                   	pop    %rbx
  802c44:	41 5c                	pop    %r12
  802c46:	41 5d                	pop    %r13
  802c48:	41 5e                	pop    %r14
  802c4a:	41 5f                	pop    %r15
  802c4c:	5d                   	pop    %rbp
  802c4d:	c3                   	ret

0000000000802c4e <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c4e:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c52:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c57:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c5e:	00 00 00 
  802c61:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c65:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c69:	48 c1 e2 04          	shl    $0x4,%rdx
  802c6d:	48 01 ca             	add    %rcx,%rdx
  802c70:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c76:	39 fa                	cmp    %edi,%edx
  802c78:	74 12                	je     802c8c <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c7a:	48 83 c0 01          	add    $0x1,%rax
  802c7e:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c84:	75 db                	jne    802c61 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802c86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c8b:	c3                   	ret
            return envs[i].env_id;
  802c8c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c90:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c94:	48 c1 e2 04          	shl    $0x4,%rdx
  802c98:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802c9f:	00 00 00 
  802ca2:	48 01 d0             	add    %rdx,%rax
  802ca5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cab:	c3                   	ret

0000000000802cac <__text_end>:
  802cac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cb3:	00 00 00 
  802cb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cbd:	00 00 00 
  802cc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cc7:	00 00 00 
  802cca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cd1:	00 00 00 
  802cd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cdb:	00 00 00 
  802cde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ce5:	00 00 00 
  802ce8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cef:	00 00 00 
  802cf2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cf9:	00 00 00 
  802cfc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d03:	00 00 00 
  802d06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d0d:	00 00 00 
  802d10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d17:	00 00 00 
  802d1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d21:	00 00 00 
  802d24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d2b:	00 00 00 
  802d2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d35:	00 00 00 
  802d38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d3f:	00 00 00 
  802d42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d49:	00 00 00 
  802d4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d53:	00 00 00 
  802d56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d5d:	00 00 00 
  802d60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d67:	00 00 00 
  802d6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d71:	00 00 00 
  802d74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d7b:	00 00 00 
  802d7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d85:	00 00 00 
  802d88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d8f:	00 00 00 
  802d92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d99:	00 00 00 
  802d9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802da3:	00 00 00 
  802da6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dad:	00 00 00 
  802db0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802db7:	00 00 00 
  802dba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dc1:	00 00 00 
  802dc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dcb:	00 00 00 
  802dce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd5:	00 00 00 
  802dd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ddf:	00 00 00 
  802de2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de9:	00 00 00 
  802dec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df3:	00 00 00 
  802df6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dfd:	00 00 00 
  802e00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e07:	00 00 00 
  802e0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e11:	00 00 00 
  802e14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e1b:	00 00 00 
  802e1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e25:	00 00 00 
  802e28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e2f:	00 00 00 
  802e32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e39:	00 00 00 
  802e3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e43:	00 00 00 
  802e46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e4d:	00 00 00 
  802e50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e57:	00 00 00 
  802e5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e61:	00 00 00 
  802e64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e6b:	00 00 00 
  802e6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e75:	00 00 00 
  802e78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e7f:	00 00 00 
  802e82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e89:	00 00 00 
  802e8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e93:	00 00 00 
  802e96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e9d:	00 00 00 
  802ea0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea7:	00 00 00 
  802eaa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb1:	00 00 00 
  802eb4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ebb:	00 00 00 
  802ebe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec5:	00 00 00 
  802ec8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ecf:	00 00 00 
  802ed2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed9:	00 00 00 
  802edc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee3:	00 00 00 
  802ee6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eed:	00 00 00 
  802ef0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef7:	00 00 00 
  802efa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f01:	00 00 00 
  802f04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f0b:	00 00 00 
  802f0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f15:	00 00 00 
  802f18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f1f:	00 00 00 
  802f22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f29:	00 00 00 
  802f2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f33:	00 00 00 
  802f36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f3d:	00 00 00 
  802f40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f47:	00 00 00 
  802f4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f51:	00 00 00 
  802f54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f5b:	00 00 00 
  802f5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f65:	00 00 00 
  802f68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f6f:	00 00 00 
  802f72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f79:	00 00 00 
  802f7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f83:	00 00 00 
  802f86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f8d:	00 00 00 
  802f90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f97:	00 00 00 
  802f9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa1:	00 00 00 
  802fa4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fab:	00 00 00 
  802fae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb5:	00 00 00 
  802fb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fbf:	00 00 00 
  802fc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc9:	00 00 00 
  802fcc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd3:	00 00 00 
  802fd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fdd:	00 00 00 
  802fe0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe7:	00 00 00 
  802fea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff1:	00 00 00 
  802ff4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ffb:	00 00 00 
  802ffe:	66 90                	xchg   %ax,%ax
