
obj/user/faultnostack:     file format elf64-x86-64


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
  80001e:	e8 32 00 00 00       	call   800055 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

void _pgfault_upcall();

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
#ifndef __clang_analyzer__
    sys_env_set_pgfault_upcall(0, (void *)_pgfault_upcall);
  80002d:	48 be 97 06 80 00 00 	movabs $0x800697,%rsi
  800034:	00 00 00 
  800037:	bf 00 00 00 00       	mov    $0x0,%edi
  80003c:	48 b8 58 05 80 00 00 	movabs $0x800558,%rax
  800043:	00 00 00 
  800046:	ff d0                	call   *%rax
    *(volatile int *)0 = 0;
  800048:	c7 04 25 00 00 00 00 	movl   $0x0,0x0
  80004f:	00 00 00 00 
#endif
}
  800053:	5d                   	pop    %rbp
  800054:	c3                   	ret

0000000000800055 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800055:	f3 0f 1e fa          	endbr64
  800059:	55                   	push   %rbp
  80005a:	48 89 e5             	mov    %rsp,%rbp
  80005d:	41 56                	push   %r14
  80005f:	41 55                	push   %r13
  800061:	41 54                	push   %r12
  800063:	53                   	push   %rbx
  800064:	41 89 fd             	mov    %edi,%r13d
  800067:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80006a:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800071:	00 00 00 
  800074:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80007b:	00 00 00 
  80007e:	48 39 c2             	cmp    %rax,%rdx
  800081:	73 17                	jae    80009a <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800083:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800086:	49 89 c4             	mov    %rax,%r12
  800089:	48 83 c3 08          	add    $0x8,%rbx
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	ff 53 f8             	call   *-0x8(%rbx)
  800095:	4c 39 e3             	cmp    %r12,%rbx
  800098:	72 ef                	jb     800089 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  80009a:	48 b8 03 02 80 00 00 	movabs $0x800203,%rax
  8000a1:	00 00 00 
  8000a4:	ff d0                	call   *%rax
  8000a6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ab:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000af:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000b3:	48 c1 e0 04          	shl    $0x4,%rax
  8000b7:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000be:	00 00 00 
  8000c1:	48 01 d0             	add    %rdx,%rax
  8000c4:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000cb:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000ce:	45 85 ed             	test   %r13d,%r13d
  8000d1:	7e 0d                	jle    8000e0 <libmain+0x8b>
  8000d3:	49 8b 06             	mov    (%r14),%rax
  8000d6:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000dd:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000e0:	4c 89 f6             	mov    %r14,%rsi
  8000e3:	44 89 ef             	mov    %r13d,%edi
  8000e6:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000ed:	00 00 00 
  8000f0:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000f2:	48 b8 07 01 80 00 00 	movabs $0x800107,%rax
  8000f9:	00 00 00 
  8000fc:	ff d0                	call   *%rax
#endif
}
  8000fe:	5b                   	pop    %rbx
  8000ff:	41 5c                	pop    %r12
  800101:	41 5d                	pop    %r13
  800103:	41 5e                	pop    %r14
  800105:	5d                   	pop    %rbp
  800106:	c3                   	ret

0000000000800107 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800107:	f3 0f 1e fa          	endbr64
  80010b:	55                   	push   %rbp
  80010c:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80010f:	48 b8 5f 09 80 00 00 	movabs $0x80095f,%rax
  800116:	00 00 00 
  800119:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80011b:	bf 00 00 00 00       	mov    $0x0,%edi
  800120:	48 b8 94 01 80 00 00 	movabs $0x800194,%rax
  800127:	00 00 00 
  80012a:	ff d0                	call   *%rax
}
  80012c:	5d                   	pop    %rbp
  80012d:	c3                   	ret

000000000080012e <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80012e:	f3 0f 1e fa          	endbr64
  800132:	55                   	push   %rbp
  800133:	48 89 e5             	mov    %rsp,%rbp
  800136:	53                   	push   %rbx
  800137:	48 89 fa             	mov    %rdi,%rdx
  80013a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80013d:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800142:	bb 00 00 00 00       	mov    $0x0,%ebx
  800147:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80014c:	be 00 00 00 00       	mov    $0x0,%esi
  800151:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800157:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800159:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80015d:	c9                   	leave
  80015e:	c3                   	ret

000000000080015f <sys_cgetc>:

int
sys_cgetc(void) {
  80015f:	f3 0f 1e fa          	endbr64
  800163:	55                   	push   %rbp
  800164:	48 89 e5             	mov    %rsp,%rbp
  800167:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800168:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80016d:	ba 00 00 00 00       	mov    $0x0,%edx
  800172:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800177:	bb 00 00 00 00       	mov    $0x0,%ebx
  80017c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800181:	be 00 00 00 00       	mov    $0x0,%esi
  800186:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80018c:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80018e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800192:	c9                   	leave
  800193:	c3                   	ret

0000000000800194 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800194:	f3 0f 1e fa          	endbr64
  800198:	55                   	push   %rbp
  800199:	48 89 e5             	mov    %rsp,%rbp
  80019c:	53                   	push   %rbx
  80019d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8001a1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8001a4:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001a9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001b3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001b8:	be 00 00 00 00       	mov    $0x0,%esi
  8001bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001c3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001c5:	48 85 c0             	test   %rax,%rax
  8001c8:	7f 06                	jg     8001d0 <sys_env_destroy+0x3c>
}
  8001ca:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001ce:	c9                   	leave
  8001cf:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001d0:	49 89 c0             	mov    %rax,%r8
  8001d3:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001d8:	48 ba 98 32 80 00 00 	movabs $0x803298,%rdx
  8001df:	00 00 00 
  8001e2:	be 26 00 00 00       	mov    $0x26,%esi
  8001e7:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8001ee:	00 00 00 
  8001f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f6:	49 b9 84 1c 80 00 00 	movabs $0x801c84,%r9
  8001fd:	00 00 00 
  800200:	41 ff d1             	call   *%r9

0000000000800203 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800203:	f3 0f 1e fa          	endbr64
  800207:	55                   	push   %rbp
  800208:	48 89 e5             	mov    %rsp,%rbp
  80020b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80020c:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800211:	ba 00 00 00 00       	mov    $0x0,%edx
  800216:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80021b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800220:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800225:	be 00 00 00 00       	mov    $0x0,%esi
  80022a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800230:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800232:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800236:	c9                   	leave
  800237:	c3                   	ret

0000000000800238 <sys_yield>:

void
sys_yield(void) {
  800238:	f3 0f 1e fa          	endbr64
  80023c:	55                   	push   %rbp
  80023d:	48 89 e5             	mov    %rsp,%rbp
  800240:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800241:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800246:	ba 00 00 00 00       	mov    $0x0,%edx
  80024b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800250:	bb 00 00 00 00       	mov    $0x0,%ebx
  800255:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80025a:	be 00 00 00 00       	mov    $0x0,%esi
  80025f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800265:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  800267:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80026b:	c9                   	leave
  80026c:	c3                   	ret

000000000080026d <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80026d:	f3 0f 1e fa          	endbr64
  800271:	55                   	push   %rbp
  800272:	48 89 e5             	mov    %rsp,%rbp
  800275:	53                   	push   %rbx
  800276:	48 89 fa             	mov    %rdi,%rdx
  800279:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80027c:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800281:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800288:	00 00 00 
  80028b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800290:	be 00 00 00 00       	mov    $0x0,%esi
  800295:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80029b:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80029d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002a1:	c9                   	leave
  8002a2:	c3                   	ret

00000000008002a3 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8002a3:	f3 0f 1e fa          	endbr64
  8002a7:	55                   	push   %rbp
  8002a8:	48 89 e5             	mov    %rsp,%rbp
  8002ab:	53                   	push   %rbx
  8002ac:	49 89 f8             	mov    %rdi,%r8
  8002af:	48 89 d3             	mov    %rdx,%rbx
  8002b2:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8002b5:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002ba:	4c 89 c2             	mov    %r8,%rdx
  8002bd:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002c0:	be 00 00 00 00       	mov    $0x0,%esi
  8002c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002cb:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002cd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002d1:	c9                   	leave
  8002d2:	c3                   	ret

00000000008002d3 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002d3:	f3 0f 1e fa          	endbr64
  8002d7:	55                   	push   %rbp
  8002d8:	48 89 e5             	mov    %rsp,%rbp
  8002db:	53                   	push   %rbx
  8002dc:	48 83 ec 08          	sub    $0x8,%rsp
  8002e0:	89 f8                	mov    %edi,%eax
  8002e2:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002e5:	48 63 f9             	movslq %ecx,%rdi
  8002e8:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002eb:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002f0:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002f3:	be 00 00 00 00       	mov    $0x0,%esi
  8002f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002fe:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800300:	48 85 c0             	test   %rax,%rax
  800303:	7f 06                	jg     80030b <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  800305:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800309:	c9                   	leave
  80030a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80030b:	49 89 c0             	mov    %rax,%r8
  80030e:	b9 04 00 00 00       	mov    $0x4,%ecx
  800313:	48 ba 98 32 80 00 00 	movabs $0x803298,%rdx
  80031a:	00 00 00 
  80031d:	be 26 00 00 00       	mov    $0x26,%esi
  800322:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800329:	00 00 00 
  80032c:	b8 00 00 00 00       	mov    $0x0,%eax
  800331:	49 b9 84 1c 80 00 00 	movabs $0x801c84,%r9
  800338:	00 00 00 
  80033b:	41 ff d1             	call   *%r9

000000000080033e <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80033e:	f3 0f 1e fa          	endbr64
  800342:	55                   	push   %rbp
  800343:	48 89 e5             	mov    %rsp,%rbp
  800346:	53                   	push   %rbx
  800347:	48 83 ec 08          	sub    $0x8,%rsp
  80034b:	89 f8                	mov    %edi,%eax
  80034d:	49 89 f2             	mov    %rsi,%r10
  800350:	48 89 cf             	mov    %rcx,%rdi
  800353:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  800356:	48 63 da             	movslq %edx,%rbx
  800359:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80035c:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800361:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800364:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  800367:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800369:	48 85 c0             	test   %rax,%rax
  80036c:	7f 06                	jg     800374 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80036e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800372:	c9                   	leave
  800373:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800374:	49 89 c0             	mov    %rax,%r8
  800377:	b9 05 00 00 00       	mov    $0x5,%ecx
  80037c:	48 ba 98 32 80 00 00 	movabs $0x803298,%rdx
  800383:	00 00 00 
  800386:	be 26 00 00 00       	mov    $0x26,%esi
  80038b:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800392:	00 00 00 
  800395:	b8 00 00 00 00       	mov    $0x0,%eax
  80039a:	49 b9 84 1c 80 00 00 	movabs $0x801c84,%r9
  8003a1:	00 00 00 
  8003a4:	41 ff d1             	call   *%r9

00000000008003a7 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8003a7:	f3 0f 1e fa          	endbr64
  8003ab:	55                   	push   %rbp
  8003ac:	48 89 e5             	mov    %rsp,%rbp
  8003af:	53                   	push   %rbx
  8003b0:	48 83 ec 08          	sub    $0x8,%rsp
  8003b4:	49 89 f9             	mov    %rdi,%r9
  8003b7:	89 f0                	mov    %esi,%eax
  8003b9:	48 89 d3             	mov    %rdx,%rbx
  8003bc:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8003bf:	49 63 f0             	movslq %r8d,%rsi
  8003c2:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8003c5:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8003ca:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003cd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003d3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003d5:	48 85 c0             	test   %rax,%rax
  8003d8:	7f 06                	jg     8003e0 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8003da:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003de:	c9                   	leave
  8003df:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003e0:	49 89 c0             	mov    %rax,%r8
  8003e3:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003e8:	48 ba 98 32 80 00 00 	movabs $0x803298,%rdx
  8003ef:	00 00 00 
  8003f2:	be 26 00 00 00       	mov    $0x26,%esi
  8003f7:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8003fe:	00 00 00 
  800401:	b8 00 00 00 00       	mov    $0x0,%eax
  800406:	49 b9 84 1c 80 00 00 	movabs $0x801c84,%r9
  80040d:	00 00 00 
  800410:	41 ff d1             	call   *%r9

0000000000800413 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  800413:	f3 0f 1e fa          	endbr64
  800417:	55                   	push   %rbp
  800418:	48 89 e5             	mov    %rsp,%rbp
  80041b:	53                   	push   %rbx
  80041c:	48 83 ec 08          	sub    $0x8,%rsp
  800420:	48 89 f1             	mov    %rsi,%rcx
  800423:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  800426:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800429:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80042e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800433:	be 00 00 00 00       	mov    $0x0,%esi
  800438:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80043e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800440:	48 85 c0             	test   %rax,%rax
  800443:	7f 06                	jg     80044b <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  800445:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800449:	c9                   	leave
  80044a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80044b:	49 89 c0             	mov    %rax,%r8
  80044e:	b9 07 00 00 00       	mov    $0x7,%ecx
  800453:	48 ba 98 32 80 00 00 	movabs $0x803298,%rdx
  80045a:	00 00 00 
  80045d:	be 26 00 00 00       	mov    $0x26,%esi
  800462:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800469:	00 00 00 
  80046c:	b8 00 00 00 00       	mov    $0x0,%eax
  800471:	49 b9 84 1c 80 00 00 	movabs $0x801c84,%r9
  800478:	00 00 00 
  80047b:	41 ff d1             	call   *%r9

000000000080047e <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80047e:	f3 0f 1e fa          	endbr64
  800482:	55                   	push   %rbp
  800483:	48 89 e5             	mov    %rsp,%rbp
  800486:	53                   	push   %rbx
  800487:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80048b:	48 63 ce             	movslq %esi,%rcx
  80048e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800491:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800496:	bb 00 00 00 00       	mov    $0x0,%ebx
  80049b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004a0:	be 00 00 00 00       	mov    $0x0,%esi
  8004a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004ab:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004ad:	48 85 c0             	test   %rax,%rax
  8004b0:	7f 06                	jg     8004b8 <sys_env_set_status+0x3a>
}
  8004b2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004b6:	c9                   	leave
  8004b7:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004b8:	49 89 c0             	mov    %rax,%r8
  8004bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8004c0:	48 ba 98 32 80 00 00 	movabs $0x803298,%rdx
  8004c7:	00 00 00 
  8004ca:	be 26 00 00 00       	mov    $0x26,%esi
  8004cf:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8004d6:	00 00 00 
  8004d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004de:	49 b9 84 1c 80 00 00 	movabs $0x801c84,%r9
  8004e5:	00 00 00 
  8004e8:	41 ff d1             	call   *%r9

00000000008004eb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8004eb:	f3 0f 1e fa          	endbr64
  8004ef:	55                   	push   %rbp
  8004f0:	48 89 e5             	mov    %rsp,%rbp
  8004f3:	53                   	push   %rbx
  8004f4:	48 83 ec 08          	sub    $0x8,%rsp
  8004f8:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8004fb:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004fe:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800503:	bb 00 00 00 00       	mov    $0x0,%ebx
  800508:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80050d:	be 00 00 00 00       	mov    $0x0,%esi
  800512:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800518:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80051a:	48 85 c0             	test   %rax,%rax
  80051d:	7f 06                	jg     800525 <sys_env_set_trapframe+0x3a>
}
  80051f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800523:	c9                   	leave
  800524:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800525:	49 89 c0             	mov    %rax,%r8
  800528:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80052d:	48 ba 98 32 80 00 00 	movabs $0x803298,%rdx
  800534:	00 00 00 
  800537:	be 26 00 00 00       	mov    $0x26,%esi
  80053c:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800543:	00 00 00 
  800546:	b8 00 00 00 00       	mov    $0x0,%eax
  80054b:	49 b9 84 1c 80 00 00 	movabs $0x801c84,%r9
  800552:	00 00 00 
  800555:	41 ff d1             	call   *%r9

0000000000800558 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  800558:	f3 0f 1e fa          	endbr64
  80055c:	55                   	push   %rbp
  80055d:	48 89 e5             	mov    %rsp,%rbp
  800560:	53                   	push   %rbx
  800561:	48 83 ec 08          	sub    $0x8,%rsp
  800565:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  800568:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80056b:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800570:	bb 00 00 00 00       	mov    $0x0,%ebx
  800575:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80057a:	be 00 00 00 00       	mov    $0x0,%esi
  80057f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800585:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800587:	48 85 c0             	test   %rax,%rax
  80058a:	7f 06                	jg     800592 <sys_env_set_pgfault_upcall+0x3a>
}
  80058c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800590:	c9                   	leave
  800591:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800592:	49 89 c0             	mov    %rax,%r8
  800595:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80059a:	48 ba 98 32 80 00 00 	movabs $0x803298,%rdx
  8005a1:	00 00 00 
  8005a4:	be 26 00 00 00       	mov    $0x26,%esi
  8005a9:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8005b0:	00 00 00 
  8005b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b8:	49 b9 84 1c 80 00 00 	movabs $0x801c84,%r9
  8005bf:	00 00 00 
  8005c2:	41 ff d1             	call   *%r9

00000000008005c5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8005c5:	f3 0f 1e fa          	endbr64
  8005c9:	55                   	push   %rbp
  8005ca:	48 89 e5             	mov    %rsp,%rbp
  8005cd:	53                   	push   %rbx
  8005ce:	89 f8                	mov    %edi,%eax
  8005d0:	49 89 f1             	mov    %rsi,%r9
  8005d3:	48 89 d3             	mov    %rdx,%rbx
  8005d6:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8005d9:	49 63 f0             	movslq %r8d,%rsi
  8005dc:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8005df:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005e4:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005ed:	cd 30                	int    $0x30
}
  8005ef:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005f3:	c9                   	leave
  8005f4:	c3                   	ret

00000000008005f5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8005f5:	f3 0f 1e fa          	endbr64
  8005f9:	55                   	push   %rbp
  8005fa:	48 89 e5             	mov    %rsp,%rbp
  8005fd:	53                   	push   %rbx
  8005fe:	48 83 ec 08          	sub    $0x8,%rsp
  800602:	48 89 fa             	mov    %rdi,%rdx
  800605:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800608:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80060d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800612:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800617:	be 00 00 00 00       	mov    $0x0,%esi
  80061c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800622:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800624:	48 85 c0             	test   %rax,%rax
  800627:	7f 06                	jg     80062f <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800629:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80062d:	c9                   	leave
  80062e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80062f:	49 89 c0             	mov    %rax,%r8
  800632:	b9 0f 00 00 00       	mov    $0xf,%ecx
  800637:	48 ba 98 32 80 00 00 	movabs $0x803298,%rdx
  80063e:	00 00 00 
  800641:	be 26 00 00 00       	mov    $0x26,%esi
  800646:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80064d:	00 00 00 
  800650:	b8 00 00 00 00       	mov    $0x0,%eax
  800655:	49 b9 84 1c 80 00 00 	movabs $0x801c84,%r9
  80065c:	00 00 00 
  80065f:	41 ff d1             	call   *%r9

0000000000800662 <sys_gettime>:

int
sys_gettime(void) {
  800662:	f3 0f 1e fa          	endbr64
  800666:	55                   	push   %rbp
  800667:	48 89 e5             	mov    %rsp,%rbp
  80066a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80066b:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800670:	ba 00 00 00 00       	mov    $0x0,%edx
  800675:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80067a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80067f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800684:	be 00 00 00 00       	mov    $0x0,%esi
  800689:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80068f:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  800691:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800695:	c9                   	leave
  800696:	c3                   	ret

0000000000800697 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  800697:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  80069a:	48 b8 89 2b 80 00 00 	movabs $0x802b89,%rax
  8006a1:	00 00 00 
    call *%rax
  8006a4:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  8006a6:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  8006a9:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8006b0:	00 
    movq UTRAP_RSP(%rsp), %rsp
  8006b1:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  8006b8:	00 
    pushq %rbx
  8006b9:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  8006ba:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  8006c1:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  8006c4:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  8006c8:	4c 8b 3c 24          	mov    (%rsp),%r15
  8006cc:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8006d1:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8006d6:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8006db:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8006e0:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8006e5:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8006ea:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8006ef:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8006f4:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8006f9:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8006fe:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  800703:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  800708:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80070d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  800712:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  800716:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  80071a:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  80071b:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  80071c:	c3                   	ret

000000000080071d <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  80071d:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800721:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800728:	ff ff ff 
  80072b:	48 01 f8             	add    %rdi,%rax
  80072e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800732:	c3                   	ret

0000000000800733 <fd2data>:

char *
fd2data(struct Fd *fd) {
  800733:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800737:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80073e:	ff ff ff 
  800741:	48 01 f8             	add    %rdi,%rax
  800744:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  800748:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80074e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800752:	c3                   	ret

0000000000800753 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  800753:	f3 0f 1e fa          	endbr64
  800757:	55                   	push   %rbp
  800758:	48 89 e5             	mov    %rsp,%rbp
  80075b:	41 57                	push   %r15
  80075d:	41 56                	push   %r14
  80075f:	41 55                	push   %r13
  800761:	41 54                	push   %r12
  800763:	53                   	push   %rbx
  800764:	48 83 ec 08          	sub    $0x8,%rsp
  800768:	49 89 ff             	mov    %rdi,%r15
  80076b:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  800770:	49 bd b2 18 80 00 00 	movabs $0x8018b2,%r13
  800777:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80077a:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  800780:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  800783:	48 89 df             	mov    %rbx,%rdi
  800786:	41 ff d5             	call   *%r13
  800789:	83 e0 04             	and    $0x4,%eax
  80078c:	74 17                	je     8007a5 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  80078e:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  800795:	4c 39 f3             	cmp    %r14,%rbx
  800798:	75 e6                	jne    800780 <fd_alloc+0x2d>
  80079a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8007a0:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8007a5:	4d 89 27             	mov    %r12,(%r15)
}
  8007a8:	48 83 c4 08          	add    $0x8,%rsp
  8007ac:	5b                   	pop    %rbx
  8007ad:	41 5c                	pop    %r12
  8007af:	41 5d                	pop    %r13
  8007b1:	41 5e                	pop    %r14
  8007b3:	41 5f                	pop    %r15
  8007b5:	5d                   	pop    %rbp
  8007b6:	c3                   	ret

00000000008007b7 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8007b7:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8007bb:	83 ff 1f             	cmp    $0x1f,%edi
  8007be:	77 39                	ja     8007f9 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8007c0:	55                   	push   %rbp
  8007c1:	48 89 e5             	mov    %rsp,%rbp
  8007c4:	41 54                	push   %r12
  8007c6:	53                   	push   %rbx
  8007c7:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8007ca:	48 63 df             	movslq %edi,%rbx
  8007cd:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8007d4:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8007d8:	48 89 df             	mov    %rbx,%rdi
  8007db:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  8007e2:	00 00 00 
  8007e5:	ff d0                	call   *%rax
  8007e7:	a8 04                	test   $0x4,%al
  8007e9:	74 14                	je     8007ff <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8007eb:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8007ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007f4:	5b                   	pop    %rbx
  8007f5:	41 5c                	pop    %r12
  8007f7:	5d                   	pop    %rbp
  8007f8:	c3                   	ret
        return -E_INVAL;
  8007f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8007fe:	c3                   	ret
        return -E_INVAL;
  8007ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800804:	eb ee                	jmp    8007f4 <fd_lookup+0x3d>

0000000000800806 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  800806:	f3 0f 1e fa          	endbr64
  80080a:	55                   	push   %rbp
  80080b:	48 89 e5             	mov    %rsp,%rbp
  80080e:	41 54                	push   %r12
  800810:	53                   	push   %rbx
  800811:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  800814:	48 b8 a0 33 80 00 00 	movabs $0x8033a0,%rax
  80081b:	00 00 00 
  80081e:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  800825:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  800828:	39 3b                	cmp    %edi,(%rbx)
  80082a:	74 47                	je     800873 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  80082c:	48 83 c0 08          	add    $0x8,%rax
  800830:	48 8b 18             	mov    (%rax),%rbx
  800833:	48 85 db             	test   %rbx,%rbx
  800836:	75 f0                	jne    800828 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800838:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80083f:	00 00 00 
  800842:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800848:	89 fa                	mov    %edi,%edx
  80084a:	48 bf b8 32 80 00 00 	movabs $0x8032b8,%rdi
  800851:	00 00 00 
  800854:	b8 00 00 00 00       	mov    $0x0,%eax
  800859:	48 b9 e0 1d 80 00 00 	movabs $0x801de0,%rcx
  800860:	00 00 00 
  800863:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  800865:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  80086a:	49 89 1c 24          	mov    %rbx,(%r12)
}
  80086e:	5b                   	pop    %rbx
  80086f:	41 5c                	pop    %r12
  800871:	5d                   	pop    %rbp
  800872:	c3                   	ret
            return 0;
  800873:	b8 00 00 00 00       	mov    $0x0,%eax
  800878:	eb f0                	jmp    80086a <dev_lookup+0x64>

000000000080087a <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80087a:	f3 0f 1e fa          	endbr64
  80087e:	55                   	push   %rbp
  80087f:	48 89 e5             	mov    %rsp,%rbp
  800882:	41 55                	push   %r13
  800884:	41 54                	push   %r12
  800886:	53                   	push   %rbx
  800887:	48 83 ec 18          	sub    $0x18,%rsp
  80088b:	48 89 fb             	mov    %rdi,%rbx
  80088e:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800891:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  800898:	ff ff ff 
  80089b:	48 01 df             	add    %rbx,%rdi
  80089e:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8008a2:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8008a6:	48 b8 b7 07 80 00 00 	movabs $0x8007b7,%rax
  8008ad:	00 00 00 
  8008b0:	ff d0                	call   *%rax
  8008b2:	41 89 c5             	mov    %eax,%r13d
  8008b5:	85 c0                	test   %eax,%eax
  8008b7:	78 06                	js     8008bf <fd_close+0x45>
  8008b9:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  8008bd:	74 1a                	je     8008d9 <fd_close+0x5f>
        return (must_exist ? res : 0);
  8008bf:	45 84 e4             	test   %r12b,%r12b
  8008c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c7:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8008cb:	44 89 e8             	mov    %r13d,%eax
  8008ce:	48 83 c4 18          	add    $0x18,%rsp
  8008d2:	5b                   	pop    %rbx
  8008d3:	41 5c                	pop    %r12
  8008d5:	41 5d                	pop    %r13
  8008d7:	5d                   	pop    %rbp
  8008d8:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8008d9:	8b 3b                	mov    (%rbx),%edi
  8008db:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8008df:	48 b8 06 08 80 00 00 	movabs $0x800806,%rax
  8008e6:	00 00 00 
  8008e9:	ff d0                	call   *%rax
  8008eb:	41 89 c5             	mov    %eax,%r13d
  8008ee:	85 c0                	test   %eax,%eax
  8008f0:	78 1b                	js     80090d <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8008f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8008f6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8008fa:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  800900:	48 85 c0             	test   %rax,%rax
  800903:	74 08                	je     80090d <fd_close+0x93>
  800905:	48 89 df             	mov    %rbx,%rdi
  800908:	ff d0                	call   *%rax
  80090a:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80090d:	ba 00 10 00 00       	mov    $0x1000,%edx
  800912:	48 89 de             	mov    %rbx,%rsi
  800915:	bf 00 00 00 00       	mov    $0x0,%edi
  80091a:	48 b8 13 04 80 00 00 	movabs $0x800413,%rax
  800921:	00 00 00 
  800924:	ff d0                	call   *%rax
    return res;
  800926:	eb a3                	jmp    8008cb <fd_close+0x51>

0000000000800928 <close>:

int
close(int fdnum) {
  800928:	f3 0f 1e fa          	endbr64
  80092c:	55                   	push   %rbp
  80092d:	48 89 e5             	mov    %rsp,%rbp
  800930:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  800934:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800938:	48 b8 b7 07 80 00 00 	movabs $0x8007b7,%rax
  80093f:	00 00 00 
  800942:	ff d0                	call   *%rax
    if (res < 0) return res;
  800944:	85 c0                	test   %eax,%eax
  800946:	78 15                	js     80095d <close+0x35>

    return fd_close(fd, 1);
  800948:	be 01 00 00 00       	mov    $0x1,%esi
  80094d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  800951:	48 b8 7a 08 80 00 00 	movabs $0x80087a,%rax
  800958:	00 00 00 
  80095b:	ff d0                	call   *%rax
}
  80095d:	c9                   	leave
  80095e:	c3                   	ret

000000000080095f <close_all>:

void
close_all(void) {
  80095f:	f3 0f 1e fa          	endbr64
  800963:	55                   	push   %rbp
  800964:	48 89 e5             	mov    %rsp,%rbp
  800967:	41 54                	push   %r12
  800969:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80096a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80096f:	49 bc 28 09 80 00 00 	movabs $0x800928,%r12
  800976:	00 00 00 
  800979:	89 df                	mov    %ebx,%edi
  80097b:	41 ff d4             	call   *%r12
  80097e:	83 c3 01             	add    $0x1,%ebx
  800981:	83 fb 20             	cmp    $0x20,%ebx
  800984:	75 f3                	jne    800979 <close_all+0x1a>
}
  800986:	5b                   	pop    %rbx
  800987:	41 5c                	pop    %r12
  800989:	5d                   	pop    %rbp
  80098a:	c3                   	ret

000000000080098b <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80098b:	f3 0f 1e fa          	endbr64
  80098f:	55                   	push   %rbp
  800990:	48 89 e5             	mov    %rsp,%rbp
  800993:	41 57                	push   %r15
  800995:	41 56                	push   %r14
  800997:	41 55                	push   %r13
  800999:	41 54                	push   %r12
  80099b:	53                   	push   %rbx
  80099c:	48 83 ec 18          	sub    $0x18,%rsp
  8009a0:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8009a3:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8009a7:	48 b8 b7 07 80 00 00 	movabs $0x8007b7,%rax
  8009ae:	00 00 00 
  8009b1:	ff d0                	call   *%rax
  8009b3:	89 c3                	mov    %eax,%ebx
  8009b5:	85 c0                	test   %eax,%eax
  8009b7:	0f 88 b8 00 00 00    	js     800a75 <dup+0xea>
    close(newfdnum);
  8009bd:	44 89 e7             	mov    %r12d,%edi
  8009c0:	48 b8 28 09 80 00 00 	movabs $0x800928,%rax
  8009c7:	00 00 00 
  8009ca:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8009cc:	4d 63 ec             	movslq %r12d,%r13
  8009cf:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8009d6:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8009da:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8009de:	4c 89 ff             	mov    %r15,%rdi
  8009e1:	49 be 33 07 80 00 00 	movabs $0x800733,%r14
  8009e8:	00 00 00 
  8009eb:	41 ff d6             	call   *%r14
  8009ee:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8009f1:	4c 89 ef             	mov    %r13,%rdi
  8009f4:	41 ff d6             	call   *%r14
  8009f7:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8009fa:	48 89 df             	mov    %rbx,%rdi
  8009fd:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  800a04:	00 00 00 
  800a07:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  800a09:	a8 04                	test   $0x4,%al
  800a0b:	74 2b                	je     800a38 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  800a0d:	41 89 c1             	mov    %eax,%r9d
  800a10:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800a16:	4c 89 f1             	mov    %r14,%rcx
  800a19:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1e:	48 89 de             	mov    %rbx,%rsi
  800a21:	bf 00 00 00 00       	mov    $0x0,%edi
  800a26:	48 b8 3e 03 80 00 00 	movabs $0x80033e,%rax
  800a2d:	00 00 00 
  800a30:	ff d0                	call   *%rax
  800a32:	89 c3                	mov    %eax,%ebx
  800a34:	85 c0                	test   %eax,%eax
  800a36:	78 4e                	js     800a86 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  800a38:	4c 89 ff             	mov    %r15,%rdi
  800a3b:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  800a42:	00 00 00 
  800a45:	ff d0                	call   *%rax
  800a47:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  800a4a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800a50:	4c 89 e9             	mov    %r13,%rcx
  800a53:	ba 00 00 00 00       	mov    $0x0,%edx
  800a58:	4c 89 fe             	mov    %r15,%rsi
  800a5b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a60:	48 b8 3e 03 80 00 00 	movabs $0x80033e,%rax
  800a67:	00 00 00 
  800a6a:	ff d0                	call   *%rax
  800a6c:	89 c3                	mov    %eax,%ebx
  800a6e:	85 c0                	test   %eax,%eax
  800a70:	78 14                	js     800a86 <dup+0xfb>

    return newfdnum;
  800a72:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  800a75:	89 d8                	mov    %ebx,%eax
  800a77:	48 83 c4 18          	add    $0x18,%rsp
  800a7b:	5b                   	pop    %rbx
  800a7c:	41 5c                	pop    %r12
  800a7e:	41 5d                	pop    %r13
  800a80:	41 5e                	pop    %r14
  800a82:	41 5f                	pop    %r15
  800a84:	5d                   	pop    %rbp
  800a85:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  800a86:	ba 00 10 00 00       	mov    $0x1000,%edx
  800a8b:	4c 89 ee             	mov    %r13,%rsi
  800a8e:	bf 00 00 00 00       	mov    $0x0,%edi
  800a93:	49 bc 13 04 80 00 00 	movabs $0x800413,%r12
  800a9a:	00 00 00 
  800a9d:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  800aa0:	ba 00 10 00 00       	mov    $0x1000,%edx
  800aa5:	4c 89 f6             	mov    %r14,%rsi
  800aa8:	bf 00 00 00 00       	mov    $0x0,%edi
  800aad:	41 ff d4             	call   *%r12
    return res;
  800ab0:	eb c3                	jmp    800a75 <dup+0xea>

0000000000800ab2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800ab2:	f3 0f 1e fa          	endbr64
  800ab6:	55                   	push   %rbp
  800ab7:	48 89 e5             	mov    %rsp,%rbp
  800aba:	41 56                	push   %r14
  800abc:	41 55                	push   %r13
  800abe:	41 54                	push   %r12
  800ac0:	53                   	push   %rbx
  800ac1:	48 83 ec 10          	sub    $0x10,%rsp
  800ac5:	89 fb                	mov    %edi,%ebx
  800ac7:	49 89 f4             	mov    %rsi,%r12
  800aca:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800acd:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800ad1:	48 b8 b7 07 80 00 00 	movabs $0x8007b7,%rax
  800ad8:	00 00 00 
  800adb:	ff d0                	call   *%rax
  800add:	85 c0                	test   %eax,%eax
  800adf:	78 4c                	js     800b2d <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800ae1:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800ae5:	41 8b 3e             	mov    (%r14),%edi
  800ae8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800aec:	48 b8 06 08 80 00 00 	movabs $0x800806,%rax
  800af3:	00 00 00 
  800af6:	ff d0                	call   *%rax
  800af8:	85 c0                	test   %eax,%eax
  800afa:	78 35                	js     800b31 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800afc:	41 8b 46 08          	mov    0x8(%r14),%eax
  800b00:	83 e0 03             	and    $0x3,%eax
  800b03:	83 f8 01             	cmp    $0x1,%eax
  800b06:	74 2d                	je     800b35 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800b08:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b0c:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b10:	48 85 c0             	test   %rax,%rax
  800b13:	74 56                	je     800b6b <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  800b15:	4c 89 ea             	mov    %r13,%rdx
  800b18:	4c 89 e6             	mov    %r12,%rsi
  800b1b:	4c 89 f7             	mov    %r14,%rdi
  800b1e:	ff d0                	call   *%rax
}
  800b20:	48 83 c4 10          	add    $0x10,%rsp
  800b24:	5b                   	pop    %rbx
  800b25:	41 5c                	pop    %r12
  800b27:	41 5d                	pop    %r13
  800b29:	41 5e                	pop    %r14
  800b2b:	5d                   	pop    %rbp
  800b2c:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b2d:	48 98                	cltq
  800b2f:	eb ef                	jmp    800b20 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b31:	48 98                	cltq
  800b33:	eb eb                	jmp    800b20 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800b35:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800b3c:	00 00 00 
  800b3f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800b45:	89 da                	mov    %ebx,%edx
  800b47:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  800b4e:	00 00 00 
  800b51:	b8 00 00 00 00       	mov    $0x0,%eax
  800b56:	48 b9 e0 1d 80 00 00 	movabs $0x801de0,%rcx
  800b5d:	00 00 00 
  800b60:	ff d1                	call   *%rcx
        return -E_INVAL;
  800b62:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800b69:	eb b5                	jmp    800b20 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800b6b:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800b72:	eb ac                	jmp    800b20 <read+0x6e>

0000000000800b74 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800b74:	f3 0f 1e fa          	endbr64
  800b78:	55                   	push   %rbp
  800b79:	48 89 e5             	mov    %rsp,%rbp
  800b7c:	41 57                	push   %r15
  800b7e:	41 56                	push   %r14
  800b80:	41 55                	push   %r13
  800b82:	41 54                	push   %r12
  800b84:	53                   	push   %rbx
  800b85:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800b89:	48 85 d2             	test   %rdx,%rdx
  800b8c:	74 54                	je     800be2 <readn+0x6e>
  800b8e:	41 89 fd             	mov    %edi,%r13d
  800b91:	49 89 f6             	mov    %rsi,%r14
  800b94:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800b97:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800b9c:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800ba1:	49 bf b2 0a 80 00 00 	movabs $0x800ab2,%r15
  800ba8:	00 00 00 
  800bab:	4c 89 e2             	mov    %r12,%rdx
  800bae:	48 29 f2             	sub    %rsi,%rdx
  800bb1:	4c 01 f6             	add    %r14,%rsi
  800bb4:	44 89 ef             	mov    %r13d,%edi
  800bb7:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800bba:	85 c0                	test   %eax,%eax
  800bbc:	78 20                	js     800bde <readn+0x6a>
    for (; inc && res < n; res += inc) {
  800bbe:	01 c3                	add    %eax,%ebx
  800bc0:	85 c0                	test   %eax,%eax
  800bc2:	74 08                	je     800bcc <readn+0x58>
  800bc4:	48 63 f3             	movslq %ebx,%rsi
  800bc7:	4c 39 e6             	cmp    %r12,%rsi
  800bca:	72 df                	jb     800bab <readn+0x37>
    }
    return res;
  800bcc:	48 63 c3             	movslq %ebx,%rax
}
  800bcf:	48 83 c4 08          	add    $0x8,%rsp
  800bd3:	5b                   	pop    %rbx
  800bd4:	41 5c                	pop    %r12
  800bd6:	41 5d                	pop    %r13
  800bd8:	41 5e                	pop    %r14
  800bda:	41 5f                	pop    %r15
  800bdc:	5d                   	pop    %rbp
  800bdd:	c3                   	ret
        if (inc < 0) return inc;
  800bde:	48 98                	cltq
  800be0:	eb ed                	jmp    800bcf <readn+0x5b>
    int inc = 1, res = 0;
  800be2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800be7:	eb e3                	jmp    800bcc <readn+0x58>

0000000000800be9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800be9:	f3 0f 1e fa          	endbr64
  800bed:	55                   	push   %rbp
  800bee:	48 89 e5             	mov    %rsp,%rbp
  800bf1:	41 56                	push   %r14
  800bf3:	41 55                	push   %r13
  800bf5:	41 54                	push   %r12
  800bf7:	53                   	push   %rbx
  800bf8:	48 83 ec 10          	sub    $0x10,%rsp
  800bfc:	89 fb                	mov    %edi,%ebx
  800bfe:	49 89 f4             	mov    %rsi,%r12
  800c01:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c04:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800c08:	48 b8 b7 07 80 00 00 	movabs $0x8007b7,%rax
  800c0f:	00 00 00 
  800c12:	ff d0                	call   *%rax
  800c14:	85 c0                	test   %eax,%eax
  800c16:	78 47                	js     800c5f <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c18:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800c1c:	41 8b 3e             	mov    (%r14),%edi
  800c1f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800c23:	48 b8 06 08 80 00 00 	movabs $0x800806,%rax
  800c2a:	00 00 00 
  800c2d:	ff d0                	call   *%rax
  800c2f:	85 c0                	test   %eax,%eax
  800c31:	78 30                	js     800c63 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c33:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  800c38:	74 2d                	je     800c67 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800c3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c3e:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c42:	48 85 c0             	test   %rax,%rax
  800c45:	74 56                	je     800c9d <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  800c47:	4c 89 ea             	mov    %r13,%rdx
  800c4a:	4c 89 e6             	mov    %r12,%rsi
  800c4d:	4c 89 f7             	mov    %r14,%rdi
  800c50:	ff d0                	call   *%rax
}
  800c52:	48 83 c4 10          	add    $0x10,%rsp
  800c56:	5b                   	pop    %rbx
  800c57:	41 5c                	pop    %r12
  800c59:	41 5d                	pop    %r13
  800c5b:	41 5e                	pop    %r14
  800c5d:	5d                   	pop    %rbp
  800c5e:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c5f:	48 98                	cltq
  800c61:	eb ef                	jmp    800c52 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c63:	48 98                	cltq
  800c65:	eb eb                	jmp    800c52 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c67:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800c6e:	00 00 00 
  800c71:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800c77:	89 da                	mov    %ebx,%edx
  800c79:	48 bf 34 30 80 00 00 	movabs $0x803034,%rdi
  800c80:	00 00 00 
  800c83:	b8 00 00 00 00       	mov    $0x0,%eax
  800c88:	48 b9 e0 1d 80 00 00 	movabs $0x801de0,%rcx
  800c8f:	00 00 00 
  800c92:	ff d1                	call   *%rcx
        return -E_INVAL;
  800c94:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800c9b:	eb b5                	jmp    800c52 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800c9d:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800ca4:	eb ac                	jmp    800c52 <write+0x69>

0000000000800ca6 <seek>:

int
seek(int fdnum, off_t offset) {
  800ca6:	f3 0f 1e fa          	endbr64
  800caa:	55                   	push   %rbp
  800cab:	48 89 e5             	mov    %rsp,%rbp
  800cae:	53                   	push   %rbx
  800caf:	48 83 ec 18          	sub    $0x18,%rsp
  800cb3:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800cb5:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800cb9:	48 b8 b7 07 80 00 00 	movabs $0x8007b7,%rax
  800cc0:	00 00 00 
  800cc3:	ff d0                	call   *%rax
  800cc5:	85 c0                	test   %eax,%eax
  800cc7:	78 0c                	js     800cd5 <seek+0x2f>

    fd->fd_offset = offset;
  800cc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccd:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800cd9:	c9                   	leave
  800cda:	c3                   	ret

0000000000800cdb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800cdb:	f3 0f 1e fa          	endbr64
  800cdf:	55                   	push   %rbp
  800ce0:	48 89 e5             	mov    %rsp,%rbp
  800ce3:	41 55                	push   %r13
  800ce5:	41 54                	push   %r12
  800ce7:	53                   	push   %rbx
  800ce8:	48 83 ec 18          	sub    $0x18,%rsp
  800cec:	89 fb                	mov    %edi,%ebx
  800cee:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800cf1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800cf5:	48 b8 b7 07 80 00 00 	movabs $0x8007b7,%rax
  800cfc:	00 00 00 
  800cff:	ff d0                	call   *%rax
  800d01:	85 c0                	test   %eax,%eax
  800d03:	78 38                	js     800d3d <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800d05:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  800d09:	41 8b 7d 00          	mov    0x0(%r13),%edi
  800d0d:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800d11:	48 b8 06 08 80 00 00 	movabs $0x800806,%rax
  800d18:	00 00 00 
  800d1b:	ff d0                	call   *%rax
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	78 1c                	js     800d3d <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d21:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  800d26:	74 20                	je     800d48 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800d28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d2c:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d30:	48 85 c0             	test   %rax,%rax
  800d33:	74 47                	je     800d7c <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  800d35:	44 89 e6             	mov    %r12d,%esi
  800d38:	4c 89 ef             	mov    %r13,%rdi
  800d3b:	ff d0                	call   *%rax
}
  800d3d:	48 83 c4 18          	add    $0x18,%rsp
  800d41:	5b                   	pop    %rbx
  800d42:	41 5c                	pop    %r12
  800d44:	41 5d                	pop    %r13
  800d46:	5d                   	pop    %rbp
  800d47:	c3                   	ret
                thisenv->env_id, fdnum);
  800d48:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800d4f:	00 00 00 
  800d52:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d58:	89 da                	mov    %ebx,%edx
  800d5a:	48 bf d8 32 80 00 00 	movabs $0x8032d8,%rdi
  800d61:	00 00 00 
  800d64:	b8 00 00 00 00       	mov    $0x0,%eax
  800d69:	48 b9 e0 1d 80 00 00 	movabs $0x801de0,%rcx
  800d70:	00 00 00 
  800d73:	ff d1                	call   *%rcx
        return -E_INVAL;
  800d75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d7a:	eb c1                	jmp    800d3d <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800d7c:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800d81:	eb ba                	jmp    800d3d <ftruncate+0x62>

0000000000800d83 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800d83:	f3 0f 1e fa          	endbr64
  800d87:	55                   	push   %rbp
  800d88:	48 89 e5             	mov    %rsp,%rbp
  800d8b:	41 54                	push   %r12
  800d8d:	53                   	push   %rbx
  800d8e:	48 83 ec 10          	sub    $0x10,%rsp
  800d92:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800d95:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800d99:	48 b8 b7 07 80 00 00 	movabs $0x8007b7,%rax
  800da0:	00 00 00 
  800da3:	ff d0                	call   *%rax
  800da5:	85 c0                	test   %eax,%eax
  800da7:	78 4e                	js     800df7 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800da9:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  800dad:	41 8b 3c 24          	mov    (%r12),%edi
  800db1:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800db5:	48 b8 06 08 80 00 00 	movabs $0x800806,%rax
  800dbc:	00 00 00 
  800dbf:	ff d0                	call   *%rax
  800dc1:	85 c0                	test   %eax,%eax
  800dc3:	78 32                	js     800df7 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800dc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800dc9:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800dce:	74 30                	je     800e00 <fstat+0x7d>

    stat->st_name[0] = 0;
  800dd0:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800dd3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800dda:	00 00 00 
    stat->st_isdir = 0;
  800ddd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800de4:	00 00 00 
    stat->st_dev = dev;
  800de7:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800dee:	48 89 de             	mov    %rbx,%rsi
  800df1:	4c 89 e7             	mov    %r12,%rdi
  800df4:	ff 50 28             	call   *0x28(%rax)
}
  800df7:	48 83 c4 10          	add    $0x10,%rsp
  800dfb:	5b                   	pop    %rbx
  800dfc:	41 5c                	pop    %r12
  800dfe:	5d                   	pop    %rbp
  800dff:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800e00:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800e05:	eb f0                	jmp    800df7 <fstat+0x74>

0000000000800e07 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800e07:	f3 0f 1e fa          	endbr64
  800e0b:	55                   	push   %rbp
  800e0c:	48 89 e5             	mov    %rsp,%rbp
  800e0f:	41 54                	push   %r12
  800e11:	53                   	push   %rbx
  800e12:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800e15:	be 00 00 00 00       	mov    $0x0,%esi
  800e1a:	48 b8 e8 10 80 00 00 	movabs $0x8010e8,%rax
  800e21:	00 00 00 
  800e24:	ff d0                	call   *%rax
  800e26:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	78 25                	js     800e51 <stat+0x4a>

    int res = fstat(fd, stat);
  800e2c:	4c 89 e6             	mov    %r12,%rsi
  800e2f:	89 c7                	mov    %eax,%edi
  800e31:	48 b8 83 0d 80 00 00 	movabs $0x800d83,%rax
  800e38:	00 00 00 
  800e3b:	ff d0                	call   *%rax
  800e3d:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800e40:	89 df                	mov    %ebx,%edi
  800e42:	48 b8 28 09 80 00 00 	movabs $0x800928,%rax
  800e49:	00 00 00 
  800e4c:	ff d0                	call   *%rax

    return res;
  800e4e:	44 89 e3             	mov    %r12d,%ebx
}
  800e51:	89 d8                	mov    %ebx,%eax
  800e53:	5b                   	pop    %rbx
  800e54:	41 5c                	pop    %r12
  800e56:	5d                   	pop    %rbp
  800e57:	c3                   	ret

0000000000800e58 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800e58:	f3 0f 1e fa          	endbr64
  800e5c:	55                   	push   %rbp
  800e5d:	48 89 e5             	mov    %rsp,%rbp
  800e60:	41 54                	push   %r12
  800e62:	53                   	push   %rbx
  800e63:	48 83 ec 10          	sub    $0x10,%rsp
  800e67:	41 89 fc             	mov    %edi,%r12d
  800e6a:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800e6d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800e74:	00 00 00 
  800e77:	83 38 00             	cmpl   $0x0,(%rax)
  800e7a:	74 6e                	je     800eea <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  800e7c:	bf 03 00 00 00       	mov    $0x3,%edi
  800e81:	48 b8 72 2f 80 00 00 	movabs $0x802f72,%rax
  800e88:	00 00 00 
  800e8b:	ff d0                	call   *%rax
  800e8d:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e94:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800e96:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800e9c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800ea1:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800ea8:	00 00 00 
  800eab:	44 89 e6             	mov    %r12d,%esi
  800eae:	89 c7                	mov    %eax,%edi
  800eb0:	48 b8 b0 2e 80 00 00 	movabs $0x802eb0,%rax
  800eb7:	00 00 00 
  800eba:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800ebc:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800ec3:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800ec4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ecd:	48 89 de             	mov    %rbx,%rsi
  800ed0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ed5:	48 b8 17 2e 80 00 00 	movabs $0x802e17,%rax
  800edc:	00 00 00 
  800edf:	ff d0                	call   *%rax
}
  800ee1:	48 83 c4 10          	add    $0x10,%rsp
  800ee5:	5b                   	pop    %rbx
  800ee6:	41 5c                	pop    %r12
  800ee8:	5d                   	pop    %rbp
  800ee9:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800eea:	bf 03 00 00 00       	mov    $0x3,%edi
  800eef:	48 b8 72 2f 80 00 00 	movabs $0x802f72,%rax
  800ef6:	00 00 00 
  800ef9:	ff d0                	call   *%rax
  800efb:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800f02:	00 00 
  800f04:	e9 73 ff ff ff       	jmp    800e7c <fsipc+0x24>

0000000000800f09 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800f09:	f3 0f 1e fa          	endbr64
  800f0d:	55                   	push   %rbp
  800f0e:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800f11:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f18:	00 00 00 
  800f1b:	8b 57 0c             	mov    0xc(%rdi),%edx
  800f1e:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800f20:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800f23:	be 00 00 00 00       	mov    $0x0,%esi
  800f28:	bf 02 00 00 00       	mov    $0x2,%edi
  800f2d:	48 b8 58 0e 80 00 00 	movabs $0x800e58,%rax
  800f34:	00 00 00 
  800f37:	ff d0                	call   *%rax
}
  800f39:	5d                   	pop    %rbp
  800f3a:	c3                   	ret

0000000000800f3b <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800f3b:	f3 0f 1e fa          	endbr64
  800f3f:	55                   	push   %rbp
  800f40:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800f43:	8b 47 0c             	mov    0xc(%rdi),%eax
  800f46:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800f4d:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800f4f:	be 00 00 00 00       	mov    $0x0,%esi
  800f54:	bf 06 00 00 00       	mov    $0x6,%edi
  800f59:	48 b8 58 0e 80 00 00 	movabs $0x800e58,%rax
  800f60:	00 00 00 
  800f63:	ff d0                	call   *%rax
}
  800f65:	5d                   	pop    %rbp
  800f66:	c3                   	ret

0000000000800f67 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800f67:	f3 0f 1e fa          	endbr64
  800f6b:	55                   	push   %rbp
  800f6c:	48 89 e5             	mov    %rsp,%rbp
  800f6f:	41 54                	push   %r12
  800f71:	53                   	push   %rbx
  800f72:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800f75:	8b 47 0c             	mov    0xc(%rdi),%eax
  800f78:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800f7f:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800f81:	be 00 00 00 00       	mov    $0x0,%esi
  800f86:	bf 05 00 00 00       	mov    $0x5,%edi
  800f8b:	48 b8 58 0e 80 00 00 	movabs $0x800e58,%rax
  800f92:	00 00 00 
  800f95:	ff d0                	call   *%rax
    if (res < 0) return res;
  800f97:	85 c0                	test   %eax,%eax
  800f99:	78 3d                	js     800fd8 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800f9b:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  800fa2:	00 00 00 
  800fa5:	4c 89 e6             	mov    %r12,%rsi
  800fa8:	48 89 df             	mov    %rbx,%rdi
  800fab:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  800fb2:	00 00 00 
  800fb5:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800fb7:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  800fbe:	00 
  800fbf:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800fc5:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  800fcc:	00 
  800fcd:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800fd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd8:	5b                   	pop    %rbx
  800fd9:	41 5c                	pop    %r12
  800fdb:	5d                   	pop    %rbp
  800fdc:	c3                   	ret

0000000000800fdd <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800fdd:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  800fe1:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  800fe8:	77 41                	ja     80102b <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800fea:	55                   	push   %rbp
  800feb:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  800fee:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ff5:	00 00 00 
  800ff8:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800ffb:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  800ffd:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801001:	48 8d 78 10          	lea    0x10(%rax),%rdi
  801005:	48 b8 44 29 80 00 00 	movabs $0x802944,%rax
  80100c:	00 00 00 
  80100f:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  801011:	be 00 00 00 00       	mov    $0x0,%esi
  801016:	bf 04 00 00 00       	mov    $0x4,%edi
  80101b:	48 b8 58 0e 80 00 00 	movabs $0x800e58,%rax
  801022:	00 00 00 
  801025:	ff d0                	call   *%rax
  801027:	48 98                	cltq
}
  801029:	5d                   	pop    %rbp
  80102a:	c3                   	ret
        return -E_INVAL;
  80102b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  801032:	c3                   	ret

0000000000801033 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801033:	f3 0f 1e fa          	endbr64
  801037:	55                   	push   %rbp
  801038:	48 89 e5             	mov    %rsp,%rbp
  80103b:	41 55                	push   %r13
  80103d:	41 54                	push   %r12
  80103f:	53                   	push   %rbx
  801040:	48 83 ec 08          	sub    $0x8,%rsp
  801044:	49 89 f4             	mov    %rsi,%r12
  801047:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80104a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801051:	00 00 00 
  801054:	8b 57 0c             	mov    0xc(%rdi),%edx
  801057:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  801059:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  80105d:	be 00 00 00 00       	mov    $0x0,%esi
  801062:	bf 03 00 00 00       	mov    $0x3,%edi
  801067:	48 b8 58 0e 80 00 00 	movabs $0x800e58,%rax
  80106e:	00 00 00 
  801071:	ff d0                	call   *%rax
  801073:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  801076:	4d 85 ed             	test   %r13,%r13
  801079:	78 2a                	js     8010a5 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  80107b:	4c 89 ea             	mov    %r13,%rdx
  80107e:	4c 39 eb             	cmp    %r13,%rbx
  801081:	72 30                	jb     8010b3 <devfile_read+0x80>
  801083:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  80108a:	7f 27                	jg     8010b3 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  80108c:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801093:	00 00 00 
  801096:	4c 89 e7             	mov    %r12,%rdi
  801099:	48 b8 44 29 80 00 00 	movabs $0x802944,%rax
  8010a0:	00 00 00 
  8010a3:	ff d0                	call   *%rax
}
  8010a5:	4c 89 e8             	mov    %r13,%rax
  8010a8:	48 83 c4 08          	add    $0x8,%rsp
  8010ac:	5b                   	pop    %rbx
  8010ad:	41 5c                	pop    %r12
  8010af:	41 5d                	pop    %r13
  8010b1:	5d                   	pop    %rbp
  8010b2:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8010b3:	48 b9 51 30 80 00 00 	movabs $0x803051,%rcx
  8010ba:	00 00 00 
  8010bd:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  8010c4:	00 00 00 
  8010c7:	be 7b 00 00 00       	mov    $0x7b,%esi
  8010cc:	48 bf 83 30 80 00 00 	movabs $0x803083,%rdi
  8010d3:	00 00 00 
  8010d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010db:	49 b8 84 1c 80 00 00 	movabs $0x801c84,%r8
  8010e2:	00 00 00 
  8010e5:	41 ff d0             	call   *%r8

00000000008010e8 <open>:
open(const char *path, int mode) {
  8010e8:	f3 0f 1e fa          	endbr64
  8010ec:	55                   	push   %rbp
  8010ed:	48 89 e5             	mov    %rsp,%rbp
  8010f0:	41 55                	push   %r13
  8010f2:	41 54                	push   %r12
  8010f4:	53                   	push   %rbx
  8010f5:	48 83 ec 18          	sub    $0x18,%rsp
  8010f9:	49 89 fc             	mov    %rdi,%r12
  8010fc:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8010ff:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  801106:	00 00 00 
  801109:	ff d0                	call   *%rax
  80110b:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801111:	0f 87 8a 00 00 00    	ja     8011a1 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801117:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80111b:	48 b8 53 07 80 00 00 	movabs $0x800753,%rax
  801122:	00 00 00 
  801125:	ff d0                	call   *%rax
  801127:	89 c3                	mov    %eax,%ebx
  801129:	85 c0                	test   %eax,%eax
  80112b:	78 50                	js     80117d <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80112d:	4c 89 e6             	mov    %r12,%rsi
  801130:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801137:	00 00 00 
  80113a:	48 89 df             	mov    %rbx,%rdi
  80113d:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  801144:	00 00 00 
  801147:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801149:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801150:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801154:	bf 01 00 00 00       	mov    $0x1,%edi
  801159:	48 b8 58 0e 80 00 00 	movabs $0x800e58,%rax
  801160:	00 00 00 
  801163:	ff d0                	call   *%rax
  801165:	89 c3                	mov    %eax,%ebx
  801167:	85 c0                	test   %eax,%eax
  801169:	78 1f                	js     80118a <open+0xa2>
    return fd2num(fd);
  80116b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80116f:	48 b8 1d 07 80 00 00 	movabs $0x80071d,%rax
  801176:	00 00 00 
  801179:	ff d0                	call   *%rax
  80117b:	89 c3                	mov    %eax,%ebx
}
  80117d:	89 d8                	mov    %ebx,%eax
  80117f:	48 83 c4 18          	add    $0x18,%rsp
  801183:	5b                   	pop    %rbx
  801184:	41 5c                	pop    %r12
  801186:	41 5d                	pop    %r13
  801188:	5d                   	pop    %rbp
  801189:	c3                   	ret
        fd_close(fd, 0);
  80118a:	be 00 00 00 00       	mov    $0x0,%esi
  80118f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801193:	48 b8 7a 08 80 00 00 	movabs $0x80087a,%rax
  80119a:	00 00 00 
  80119d:	ff d0                	call   *%rax
        return res;
  80119f:	eb dc                	jmp    80117d <open+0x95>
        return -E_BAD_PATH;
  8011a1:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8011a6:	eb d5                	jmp    80117d <open+0x95>

00000000008011a8 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8011a8:	f3 0f 1e fa          	endbr64
  8011ac:	55                   	push   %rbp
  8011ad:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8011b0:	be 00 00 00 00       	mov    $0x0,%esi
  8011b5:	bf 08 00 00 00       	mov    $0x8,%edi
  8011ba:	48 b8 58 0e 80 00 00 	movabs $0x800e58,%rax
  8011c1:	00 00 00 
  8011c4:	ff d0                	call   *%rax
}
  8011c6:	5d                   	pop    %rbp
  8011c7:	c3                   	ret

00000000008011c8 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8011c8:	f3 0f 1e fa          	endbr64
  8011cc:	55                   	push   %rbp
  8011cd:	48 89 e5             	mov    %rsp,%rbp
  8011d0:	41 54                	push   %r12
  8011d2:	53                   	push   %rbx
  8011d3:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8011d6:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  8011dd:	00 00 00 
  8011e0:	ff d0                	call   *%rax
  8011e2:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8011e5:	48 be 8e 30 80 00 00 	movabs $0x80308e,%rsi
  8011ec:	00 00 00 
  8011ef:	48 89 df             	mov    %rbx,%rdi
  8011f2:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  8011f9:	00 00 00 
  8011fc:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8011fe:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801203:	41 2b 04 24          	sub    (%r12),%eax
  801207:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80120d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801214:	00 00 00 
    stat->st_dev = &devpipe;
  801217:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80121e:	00 00 00 
  801221:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801228:	b8 00 00 00 00       	mov    $0x0,%eax
  80122d:	5b                   	pop    %rbx
  80122e:	41 5c                	pop    %r12
  801230:	5d                   	pop    %rbp
  801231:	c3                   	ret

0000000000801232 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801232:	f3 0f 1e fa          	endbr64
  801236:	55                   	push   %rbp
  801237:	48 89 e5             	mov    %rsp,%rbp
  80123a:	41 54                	push   %r12
  80123c:	53                   	push   %rbx
  80123d:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801240:	ba 00 10 00 00       	mov    $0x1000,%edx
  801245:	48 89 fe             	mov    %rdi,%rsi
  801248:	bf 00 00 00 00       	mov    $0x0,%edi
  80124d:	49 bc 13 04 80 00 00 	movabs $0x800413,%r12
  801254:	00 00 00 
  801257:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80125a:	48 89 df             	mov    %rbx,%rdi
  80125d:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  801264:	00 00 00 
  801267:	ff d0                	call   *%rax
  801269:	48 89 c6             	mov    %rax,%rsi
  80126c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801271:	bf 00 00 00 00       	mov    $0x0,%edi
  801276:	41 ff d4             	call   *%r12
}
  801279:	5b                   	pop    %rbx
  80127a:	41 5c                	pop    %r12
  80127c:	5d                   	pop    %rbp
  80127d:	c3                   	ret

000000000080127e <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  80127e:	f3 0f 1e fa          	endbr64
  801282:	55                   	push   %rbp
  801283:	48 89 e5             	mov    %rsp,%rbp
  801286:	41 57                	push   %r15
  801288:	41 56                	push   %r14
  80128a:	41 55                	push   %r13
  80128c:	41 54                	push   %r12
  80128e:	53                   	push   %rbx
  80128f:	48 83 ec 18          	sub    $0x18,%rsp
  801293:	49 89 fc             	mov    %rdi,%r12
  801296:	49 89 f5             	mov    %rsi,%r13
  801299:	49 89 d7             	mov    %rdx,%r15
  80129c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8012a0:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  8012a7:	00 00 00 
  8012aa:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8012ac:	4d 85 ff             	test   %r15,%r15
  8012af:	0f 84 af 00 00 00    	je     801364 <devpipe_write+0xe6>
  8012b5:	48 89 c3             	mov    %rax,%rbx
  8012b8:	4c 89 f8             	mov    %r15,%rax
  8012bb:	4d 89 ef             	mov    %r13,%r15
  8012be:	4c 01 e8             	add    %r13,%rax
  8012c1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8012c5:	49 bd a3 02 80 00 00 	movabs $0x8002a3,%r13
  8012cc:	00 00 00 
            sys_yield();
  8012cf:	49 be 38 02 80 00 00 	movabs $0x800238,%r14
  8012d6:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8012d9:	8b 73 04             	mov    0x4(%rbx),%esi
  8012dc:	48 63 ce             	movslq %esi,%rcx
  8012df:	48 63 03             	movslq (%rbx),%rax
  8012e2:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8012e8:	48 39 c1             	cmp    %rax,%rcx
  8012eb:	72 2e                	jb     80131b <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8012ed:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8012f2:	48 89 da             	mov    %rbx,%rdx
  8012f5:	be 00 10 00 00       	mov    $0x1000,%esi
  8012fa:	4c 89 e7             	mov    %r12,%rdi
  8012fd:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801300:	85 c0                	test   %eax,%eax
  801302:	74 66                	je     80136a <devpipe_write+0xec>
            sys_yield();
  801304:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801307:	8b 73 04             	mov    0x4(%rbx),%esi
  80130a:	48 63 ce             	movslq %esi,%rcx
  80130d:	48 63 03             	movslq (%rbx),%rax
  801310:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801316:	48 39 c1             	cmp    %rax,%rcx
  801319:	73 d2                	jae    8012ed <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80131b:	41 0f b6 3f          	movzbl (%r15),%edi
  80131f:	48 89 ca             	mov    %rcx,%rdx
  801322:	48 c1 ea 03          	shr    $0x3,%rdx
  801326:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80132d:	08 10 20 
  801330:	48 f7 e2             	mul    %rdx
  801333:	48 c1 ea 06          	shr    $0x6,%rdx
  801337:	48 89 d0             	mov    %rdx,%rax
  80133a:	48 c1 e0 09          	shl    $0x9,%rax
  80133e:	48 29 d0             	sub    %rdx,%rax
  801341:	48 c1 e0 03          	shl    $0x3,%rax
  801345:	48 29 c1             	sub    %rax,%rcx
  801348:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80134d:	83 c6 01             	add    $0x1,%esi
  801350:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  801353:	49 83 c7 01          	add    $0x1,%r15
  801357:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80135b:	49 39 c7             	cmp    %rax,%r15
  80135e:	0f 85 75 ff ff ff    	jne    8012d9 <devpipe_write+0x5b>
    return n;
  801364:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801368:	eb 05                	jmp    80136f <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  80136a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80136f:	48 83 c4 18          	add    $0x18,%rsp
  801373:	5b                   	pop    %rbx
  801374:	41 5c                	pop    %r12
  801376:	41 5d                	pop    %r13
  801378:	41 5e                	pop    %r14
  80137a:	41 5f                	pop    %r15
  80137c:	5d                   	pop    %rbp
  80137d:	c3                   	ret

000000000080137e <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80137e:	f3 0f 1e fa          	endbr64
  801382:	55                   	push   %rbp
  801383:	48 89 e5             	mov    %rsp,%rbp
  801386:	41 57                	push   %r15
  801388:	41 56                	push   %r14
  80138a:	41 55                	push   %r13
  80138c:	41 54                	push   %r12
  80138e:	53                   	push   %rbx
  80138f:	48 83 ec 18          	sub    $0x18,%rsp
  801393:	49 89 fc             	mov    %rdi,%r12
  801396:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80139a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80139e:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  8013a5:	00 00 00 
  8013a8:	ff d0                	call   *%rax
  8013aa:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8013ad:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8013b3:	49 bd a3 02 80 00 00 	movabs $0x8002a3,%r13
  8013ba:	00 00 00 
            sys_yield();
  8013bd:	49 be 38 02 80 00 00 	movabs $0x800238,%r14
  8013c4:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8013c7:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8013cc:	74 7d                	je     80144b <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8013ce:	8b 03                	mov    (%rbx),%eax
  8013d0:	3b 43 04             	cmp    0x4(%rbx),%eax
  8013d3:	75 26                	jne    8013fb <devpipe_read+0x7d>
            if (i > 0) return i;
  8013d5:	4d 85 ff             	test   %r15,%r15
  8013d8:	75 77                	jne    801451 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8013da:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8013df:	48 89 da             	mov    %rbx,%rdx
  8013e2:	be 00 10 00 00       	mov    $0x1000,%esi
  8013e7:	4c 89 e7             	mov    %r12,%rdi
  8013ea:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	74 72                	je     801463 <devpipe_read+0xe5>
            sys_yield();
  8013f1:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8013f4:	8b 03                	mov    (%rbx),%eax
  8013f6:	3b 43 04             	cmp    0x4(%rbx),%eax
  8013f9:	74 df                	je     8013da <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8013fb:	48 63 c8             	movslq %eax,%rcx
  8013fe:	48 89 ca             	mov    %rcx,%rdx
  801401:	48 c1 ea 03          	shr    $0x3,%rdx
  801405:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  80140c:	08 10 20 
  80140f:	48 89 d0             	mov    %rdx,%rax
  801412:	48 f7 e6             	mul    %rsi
  801415:	48 c1 ea 06          	shr    $0x6,%rdx
  801419:	48 89 d0             	mov    %rdx,%rax
  80141c:	48 c1 e0 09          	shl    $0x9,%rax
  801420:	48 29 d0             	sub    %rdx,%rax
  801423:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80142a:	00 
  80142b:	48 89 c8             	mov    %rcx,%rax
  80142e:	48 29 d0             	sub    %rdx,%rax
  801431:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  801436:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80143a:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80143e:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  801441:	49 83 c7 01          	add    $0x1,%r15
  801445:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  801449:	75 83                	jne    8013ce <devpipe_read+0x50>
    return n;
  80144b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80144f:	eb 03                	jmp    801454 <devpipe_read+0xd6>
            if (i > 0) return i;
  801451:	4c 89 f8             	mov    %r15,%rax
}
  801454:	48 83 c4 18          	add    $0x18,%rsp
  801458:	5b                   	pop    %rbx
  801459:	41 5c                	pop    %r12
  80145b:	41 5d                	pop    %r13
  80145d:	41 5e                	pop    %r14
  80145f:	41 5f                	pop    %r15
  801461:	5d                   	pop    %rbp
  801462:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  801463:	b8 00 00 00 00       	mov    $0x0,%eax
  801468:	eb ea                	jmp    801454 <devpipe_read+0xd6>

000000000080146a <pipe>:
pipe(int pfd[2]) {
  80146a:	f3 0f 1e fa          	endbr64
  80146e:	55                   	push   %rbp
  80146f:	48 89 e5             	mov    %rsp,%rbp
  801472:	41 55                	push   %r13
  801474:	41 54                	push   %r12
  801476:	53                   	push   %rbx
  801477:	48 83 ec 18          	sub    $0x18,%rsp
  80147b:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  80147e:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801482:	48 b8 53 07 80 00 00 	movabs $0x800753,%rax
  801489:	00 00 00 
  80148c:	ff d0                	call   *%rax
  80148e:	89 c3                	mov    %eax,%ebx
  801490:	85 c0                	test   %eax,%eax
  801492:	0f 88 a0 01 00 00    	js     801638 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  801498:	b9 46 00 00 00       	mov    $0x46,%ecx
  80149d:	ba 00 10 00 00       	mov    $0x1000,%edx
  8014a2:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8014a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8014ab:	48 b8 d3 02 80 00 00 	movabs $0x8002d3,%rax
  8014b2:	00 00 00 
  8014b5:	ff d0                	call   *%rax
  8014b7:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	0f 88 77 01 00 00    	js     801638 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8014c1:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8014c5:	48 b8 53 07 80 00 00 	movabs $0x800753,%rax
  8014cc:	00 00 00 
  8014cf:	ff d0                	call   *%rax
  8014d1:	89 c3                	mov    %eax,%ebx
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	0f 88 43 01 00 00    	js     80161e <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8014db:	b9 46 00 00 00       	mov    $0x46,%ecx
  8014e0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8014e5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8014e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8014ee:	48 b8 d3 02 80 00 00 	movabs $0x8002d3,%rax
  8014f5:	00 00 00 
  8014f8:	ff d0                	call   *%rax
  8014fa:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	0f 88 1a 01 00 00    	js     80161e <pipe+0x1b4>
    va = fd2data(fd0);
  801504:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801508:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  80150f:	00 00 00 
  801512:	ff d0                	call   *%rax
  801514:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801517:	b9 46 00 00 00       	mov    $0x46,%ecx
  80151c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801521:	48 89 c6             	mov    %rax,%rsi
  801524:	bf 00 00 00 00       	mov    $0x0,%edi
  801529:	48 b8 d3 02 80 00 00 	movabs $0x8002d3,%rax
  801530:	00 00 00 
  801533:	ff d0                	call   *%rax
  801535:	89 c3                	mov    %eax,%ebx
  801537:	85 c0                	test   %eax,%eax
  801539:	0f 88 c5 00 00 00    	js     801604 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80153f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801543:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  80154a:	00 00 00 
  80154d:	ff d0                	call   *%rax
  80154f:	48 89 c1             	mov    %rax,%rcx
  801552:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  801558:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80155e:	ba 00 00 00 00       	mov    $0x0,%edx
  801563:	4c 89 ee             	mov    %r13,%rsi
  801566:	bf 00 00 00 00       	mov    $0x0,%edi
  80156b:	48 b8 3e 03 80 00 00 	movabs $0x80033e,%rax
  801572:	00 00 00 
  801575:	ff d0                	call   *%rax
  801577:	89 c3                	mov    %eax,%ebx
  801579:	85 c0                	test   %eax,%eax
  80157b:	78 6e                	js     8015eb <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80157d:	be 00 10 00 00       	mov    $0x1000,%esi
  801582:	4c 89 ef             	mov    %r13,%rdi
  801585:	48 b8 6d 02 80 00 00 	movabs $0x80026d,%rax
  80158c:	00 00 00 
  80158f:	ff d0                	call   *%rax
  801591:	83 f8 02             	cmp    $0x2,%eax
  801594:	0f 85 ab 00 00 00    	jne    801645 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  80159a:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8015a1:	00 00 
  8015a3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015a7:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8015a9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015ad:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8015b4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015b8:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8015ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015be:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8015c5:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8015c9:	48 bb 1d 07 80 00 00 	movabs $0x80071d,%rbx
  8015d0:	00 00 00 
  8015d3:	ff d3                	call   *%rbx
  8015d5:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8015d9:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8015dd:	ff d3                	call   *%rbx
  8015df:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8015e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e9:	eb 4d                	jmp    801638 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8015eb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8015f0:	4c 89 ee             	mov    %r13,%rsi
  8015f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8015f8:	48 b8 13 04 80 00 00 	movabs $0x800413,%rax
  8015ff:	00 00 00 
  801602:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  801604:	ba 00 10 00 00       	mov    $0x1000,%edx
  801609:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80160d:	bf 00 00 00 00       	mov    $0x0,%edi
  801612:	48 b8 13 04 80 00 00 	movabs $0x800413,%rax
  801619:	00 00 00 
  80161c:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80161e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801623:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801627:	bf 00 00 00 00       	mov    $0x0,%edi
  80162c:	48 b8 13 04 80 00 00 	movabs $0x800413,%rax
  801633:	00 00 00 
  801636:	ff d0                	call   *%rax
}
  801638:	89 d8                	mov    %ebx,%eax
  80163a:	48 83 c4 18          	add    $0x18,%rsp
  80163e:	5b                   	pop    %rbx
  80163f:	41 5c                	pop    %r12
  801641:	41 5d                	pop    %r13
  801643:	5d                   	pop    %rbp
  801644:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  801645:	48 b9 00 33 80 00 00 	movabs $0x803300,%rcx
  80164c:	00 00 00 
  80164f:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  801656:	00 00 00 
  801659:	be 2e 00 00 00       	mov    $0x2e,%esi
  80165e:	48 bf 95 30 80 00 00 	movabs $0x803095,%rdi
  801665:	00 00 00 
  801668:	b8 00 00 00 00       	mov    $0x0,%eax
  80166d:	49 b8 84 1c 80 00 00 	movabs $0x801c84,%r8
  801674:	00 00 00 
  801677:	41 ff d0             	call   *%r8

000000000080167a <pipeisclosed>:
pipeisclosed(int fdnum) {
  80167a:	f3 0f 1e fa          	endbr64
  80167e:	55                   	push   %rbp
  80167f:	48 89 e5             	mov    %rsp,%rbp
  801682:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801686:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80168a:	48 b8 b7 07 80 00 00 	movabs $0x8007b7,%rax
  801691:	00 00 00 
  801694:	ff d0                	call   *%rax
    if (res < 0) return res;
  801696:	85 c0                	test   %eax,%eax
  801698:	78 35                	js     8016cf <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80169a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80169e:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  8016a5:	00 00 00 
  8016a8:	ff d0                	call   *%rax
  8016aa:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8016ad:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8016b2:	be 00 10 00 00       	mov    $0x1000,%esi
  8016b7:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8016bb:	48 b8 a3 02 80 00 00 	movabs $0x8002a3,%rax
  8016c2:	00 00 00 
  8016c5:	ff d0                	call   *%rax
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	0f 94 c0             	sete   %al
  8016cc:	0f b6 c0             	movzbl %al,%eax
}
  8016cf:	c9                   	leave
  8016d0:	c3                   	ret

00000000008016d1 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8016d1:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8016d5:	48 89 f8             	mov    %rdi,%rax
  8016d8:	48 c1 e8 27          	shr    $0x27,%rax
  8016dc:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8016e3:	7f 00 00 
  8016e6:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8016ea:	f6 c2 01             	test   $0x1,%dl
  8016ed:	74 6d                	je     80175c <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8016ef:	48 89 f8             	mov    %rdi,%rax
  8016f2:	48 c1 e8 1e          	shr    $0x1e,%rax
  8016f6:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8016fd:	7f 00 00 
  801700:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801704:	f6 c2 01             	test   $0x1,%dl
  801707:	74 62                	je     80176b <get_uvpt_entry+0x9a>
  801709:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801710:	7f 00 00 
  801713:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801717:	f6 c2 80             	test   $0x80,%dl
  80171a:	75 4f                	jne    80176b <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80171c:	48 89 f8             	mov    %rdi,%rax
  80171f:	48 c1 e8 15          	shr    $0x15,%rax
  801723:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80172a:	7f 00 00 
  80172d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801731:	f6 c2 01             	test   $0x1,%dl
  801734:	74 44                	je     80177a <get_uvpt_entry+0xa9>
  801736:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80173d:	7f 00 00 
  801740:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801744:	f6 c2 80             	test   $0x80,%dl
  801747:	75 31                	jne    80177a <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  801749:	48 c1 ef 0c          	shr    $0xc,%rdi
  80174d:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801754:	7f 00 00 
  801757:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80175b:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80175c:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  801763:	7f 00 00 
  801766:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80176a:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80176b:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801772:	7f 00 00 
  801775:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801779:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80177a:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  801781:	7f 00 00 
  801784:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801788:	c3                   	ret

0000000000801789 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  801789:	f3 0f 1e fa          	endbr64
  80178d:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  801790:	48 89 f9             	mov    %rdi,%rcx
  801793:	48 c1 e9 27          	shr    $0x27,%rcx
  801797:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  80179e:	7f 00 00 
  8017a1:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8017a5:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8017ac:	f6 c1 01             	test   $0x1,%cl
  8017af:	0f 84 b2 00 00 00    	je     801867 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8017b5:	48 89 f9             	mov    %rdi,%rcx
  8017b8:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8017bc:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8017c3:	7f 00 00 
  8017c6:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8017ca:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8017d1:	40 f6 c6 01          	test   $0x1,%sil
  8017d5:	0f 84 8c 00 00 00    	je     801867 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8017db:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8017e2:	7f 00 00 
  8017e5:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017e9:	a8 80                	test   $0x80,%al
  8017eb:	75 7b                	jne    801868 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8017ed:	48 89 f9             	mov    %rdi,%rcx
  8017f0:	48 c1 e9 15          	shr    $0x15,%rcx
  8017f4:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8017fb:	7f 00 00 
  8017fe:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801802:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  801809:	40 f6 c6 01          	test   $0x1,%sil
  80180d:	74 58                	je     801867 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  80180f:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801816:	7f 00 00 
  801819:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80181d:	a8 80                	test   $0x80,%al
  80181f:	75 6c                	jne    80188d <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  801821:	48 89 f9             	mov    %rdi,%rcx
  801824:	48 c1 e9 0c          	shr    $0xc,%rcx
  801828:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80182f:	7f 00 00 
  801832:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801836:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  80183d:	40 f6 c6 01          	test   $0x1,%sil
  801841:	74 24                	je     801867 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  801843:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80184a:	7f 00 00 
  80184d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801851:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  801858:	ff ff 7f 
  80185b:	48 21 c8             	and    %rcx,%rax
  80185e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801864:	48 09 d0             	or     %rdx,%rax
}
  801867:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  801868:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80186f:	7f 00 00 
  801872:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801876:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80187d:	ff ff 7f 
  801880:	48 21 c8             	and    %rcx,%rax
  801883:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  801889:	48 01 d0             	add    %rdx,%rax
  80188c:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  80188d:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801894:	7f 00 00 
  801897:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80189b:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8018a2:	ff ff 7f 
  8018a5:	48 21 c8             	and    %rcx,%rax
  8018a8:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8018ae:	48 01 d0             	add    %rdx,%rax
  8018b1:	c3                   	ret

00000000008018b2 <get_prot>:

int
get_prot(void *va) {
  8018b2:	f3 0f 1e fa          	endbr64
  8018b6:	55                   	push   %rbp
  8018b7:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8018ba:	48 b8 d1 16 80 00 00 	movabs $0x8016d1,%rax
  8018c1:	00 00 00 
  8018c4:	ff d0                	call   *%rax
  8018c6:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8018c9:	83 e0 01             	and    $0x1,%eax
  8018cc:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8018cf:	89 d1                	mov    %edx,%ecx
  8018d1:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8018d7:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8018d9:	89 c1                	mov    %eax,%ecx
  8018db:	83 c9 02             	or     $0x2,%ecx
  8018de:	f6 c2 02             	test   $0x2,%dl
  8018e1:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8018e4:	89 c1                	mov    %eax,%ecx
  8018e6:	83 c9 01             	or     $0x1,%ecx
  8018e9:	48 85 d2             	test   %rdx,%rdx
  8018ec:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8018ef:	89 c1                	mov    %eax,%ecx
  8018f1:	83 c9 40             	or     $0x40,%ecx
  8018f4:	f6 c6 04             	test   $0x4,%dh
  8018f7:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8018fa:	5d                   	pop    %rbp
  8018fb:	c3                   	ret

00000000008018fc <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8018fc:	f3 0f 1e fa          	endbr64
  801900:	55                   	push   %rbp
  801901:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801904:	48 b8 d1 16 80 00 00 	movabs $0x8016d1,%rax
  80190b:	00 00 00 
  80190e:	ff d0                	call   *%rax
    return pte & PTE_D;
  801910:	48 c1 e8 06          	shr    $0x6,%rax
  801914:	83 e0 01             	and    $0x1,%eax
}
  801917:	5d                   	pop    %rbp
  801918:	c3                   	ret

0000000000801919 <is_page_present>:

bool
is_page_present(void *va) {
  801919:	f3 0f 1e fa          	endbr64
  80191d:	55                   	push   %rbp
  80191e:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  801921:	48 b8 d1 16 80 00 00 	movabs $0x8016d1,%rax
  801928:	00 00 00 
  80192b:	ff d0                	call   *%rax
  80192d:	83 e0 01             	and    $0x1,%eax
}
  801930:	5d                   	pop    %rbp
  801931:	c3                   	ret

0000000000801932 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801932:	f3 0f 1e fa          	endbr64
  801936:	55                   	push   %rbp
  801937:	48 89 e5             	mov    %rsp,%rbp
  80193a:	41 57                	push   %r15
  80193c:	41 56                	push   %r14
  80193e:	41 55                	push   %r13
  801940:	41 54                	push   %r12
  801942:	53                   	push   %rbx
  801943:	48 83 ec 18          	sub    $0x18,%rsp
  801947:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80194b:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  80194f:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  801954:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  80195b:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80195e:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  801965:	7f 00 00 
    while (va < USER_STACK_TOP) {
  801968:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  80196f:	00 00 00 
  801972:	eb 73                	jmp    8019e7 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  801974:	48 89 d8             	mov    %rbx,%rax
  801977:	48 c1 e8 15          	shr    $0x15,%rax
  80197b:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  801982:	7f 00 00 
  801985:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  801989:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  80198f:	f6 c2 01             	test   $0x1,%dl
  801992:	74 4b                	je     8019df <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  801994:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  801998:	f6 c2 80             	test   $0x80,%dl
  80199b:	74 11                	je     8019ae <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  80199d:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8019a1:	f6 c4 04             	test   $0x4,%ah
  8019a4:	74 39                	je     8019df <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8019a6:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  8019ac:	eb 20                	jmp    8019ce <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8019ae:	48 89 da             	mov    %rbx,%rdx
  8019b1:	48 c1 ea 0c          	shr    $0xc,%rdx
  8019b5:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8019bc:	7f 00 00 
  8019bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  8019c3:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8019c9:	f6 c4 04             	test   $0x4,%ah
  8019cc:	74 11                	je     8019df <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  8019ce:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  8019d2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8019d6:	48 89 df             	mov    %rbx,%rdi
  8019d9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8019dd:	ff d0                	call   *%rax
    next:
        va += size;
  8019df:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  8019e2:	49 39 df             	cmp    %rbx,%r15
  8019e5:	72 3e                	jb     801a25 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8019e7:	49 8b 06             	mov    (%r14),%rax
  8019ea:	a8 01                	test   $0x1,%al
  8019ec:	74 37                	je     801a25 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8019ee:	48 89 d8             	mov    %rbx,%rax
  8019f1:	48 c1 e8 1e          	shr    $0x1e,%rax
  8019f5:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  8019fa:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801a00:	f6 c2 01             	test   $0x1,%dl
  801a03:	74 da                	je     8019df <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  801a05:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  801a0a:	f6 c2 80             	test   $0x80,%dl
  801a0d:	0f 84 61 ff ff ff    	je     801974 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  801a13:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  801a18:	f6 c4 04             	test   $0x4,%ah
  801a1b:	74 c2                	je     8019df <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  801a1d:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  801a23:	eb a9                	jmp    8019ce <foreach_shared_region+0x9c>
    }
    return res;
}
  801a25:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2a:	48 83 c4 18          	add    $0x18,%rsp
  801a2e:	5b                   	pop    %rbx
  801a2f:	41 5c                	pop    %r12
  801a31:	41 5d                	pop    %r13
  801a33:	41 5e                	pop    %r14
  801a35:	41 5f                	pop    %r15
  801a37:	5d                   	pop    %rbp
  801a38:	c3                   	ret

0000000000801a39 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  801a39:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  801a3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a42:	c3                   	ret

0000000000801a43 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  801a43:	f3 0f 1e fa          	endbr64
  801a47:	55                   	push   %rbp
  801a48:	48 89 e5             	mov    %rsp,%rbp
  801a4b:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  801a4e:	48 be a5 30 80 00 00 	movabs $0x8030a5,%rsi
  801a55:	00 00 00 
  801a58:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  801a5f:	00 00 00 
  801a62:	ff d0                	call   *%rax
    return 0;
}
  801a64:	b8 00 00 00 00       	mov    $0x0,%eax
  801a69:	5d                   	pop    %rbp
  801a6a:	c3                   	ret

0000000000801a6b <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  801a6b:	f3 0f 1e fa          	endbr64
  801a6f:	55                   	push   %rbp
  801a70:	48 89 e5             	mov    %rsp,%rbp
  801a73:	41 57                	push   %r15
  801a75:	41 56                	push   %r14
  801a77:	41 55                	push   %r13
  801a79:	41 54                	push   %r12
  801a7b:	53                   	push   %rbx
  801a7c:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  801a83:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  801a8a:	48 85 d2             	test   %rdx,%rdx
  801a8d:	74 7a                	je     801b09 <devcons_write+0x9e>
  801a8f:	49 89 d6             	mov    %rdx,%r14
  801a92:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a98:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  801a9d:	49 bf 44 29 80 00 00 	movabs $0x802944,%r15
  801aa4:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  801aa7:	4c 89 f3             	mov    %r14,%rbx
  801aaa:	48 29 f3             	sub    %rsi,%rbx
  801aad:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ab2:	48 39 c3             	cmp    %rax,%rbx
  801ab5:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801ab9:	4c 63 eb             	movslq %ebx,%r13
  801abc:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801ac3:	48 01 c6             	add    %rax,%rsi
  801ac6:	4c 89 ea             	mov    %r13,%rdx
  801ac9:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801ad0:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  801ad3:	4c 89 ee             	mov    %r13,%rsi
  801ad6:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801add:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  801ae4:	00 00 00 
  801ae7:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801ae9:	41 01 dc             	add    %ebx,%r12d
  801aec:	49 63 f4             	movslq %r12d,%rsi
  801aef:	4c 39 f6             	cmp    %r14,%rsi
  801af2:	72 b3                	jb     801aa7 <devcons_write+0x3c>
    return res;
  801af4:	49 63 c4             	movslq %r12d,%rax
}
  801af7:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801afe:	5b                   	pop    %rbx
  801aff:	41 5c                	pop    %r12
  801b01:	41 5d                	pop    %r13
  801b03:	41 5e                	pop    %r14
  801b05:	41 5f                	pop    %r15
  801b07:	5d                   	pop    %rbp
  801b08:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  801b09:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801b0f:	eb e3                	jmp    801af4 <devcons_write+0x89>

0000000000801b11 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801b11:	f3 0f 1e fa          	endbr64
  801b15:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801b18:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1d:	48 85 c0             	test   %rax,%rax
  801b20:	74 55                	je     801b77 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801b22:	55                   	push   %rbp
  801b23:	48 89 e5             	mov    %rsp,%rbp
  801b26:	41 55                	push   %r13
  801b28:	41 54                	push   %r12
  801b2a:	53                   	push   %rbx
  801b2b:	48 83 ec 08          	sub    $0x8,%rsp
  801b2f:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801b32:	48 bb 5f 01 80 00 00 	movabs $0x80015f,%rbx
  801b39:	00 00 00 
  801b3c:	49 bc 38 02 80 00 00 	movabs $0x800238,%r12
  801b43:	00 00 00 
  801b46:	eb 03                	jmp    801b4b <devcons_read+0x3a>
  801b48:	41 ff d4             	call   *%r12
  801b4b:	ff d3                	call   *%rbx
  801b4d:	85 c0                	test   %eax,%eax
  801b4f:	74 f7                	je     801b48 <devcons_read+0x37>
    if (c < 0) return c;
  801b51:	48 63 d0             	movslq %eax,%rdx
  801b54:	78 13                	js     801b69 <devcons_read+0x58>
    if (c == 0x04) return 0;
  801b56:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5b:	83 f8 04             	cmp    $0x4,%eax
  801b5e:	74 09                	je     801b69 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  801b60:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801b64:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801b69:	48 89 d0             	mov    %rdx,%rax
  801b6c:	48 83 c4 08          	add    $0x8,%rsp
  801b70:	5b                   	pop    %rbx
  801b71:	41 5c                	pop    %r12
  801b73:	41 5d                	pop    %r13
  801b75:	5d                   	pop    %rbp
  801b76:	c3                   	ret
  801b77:	48 89 d0             	mov    %rdx,%rax
  801b7a:	c3                   	ret

0000000000801b7b <cputchar>:
cputchar(int ch) {
  801b7b:	f3 0f 1e fa          	endbr64
  801b7f:	55                   	push   %rbp
  801b80:	48 89 e5             	mov    %rsp,%rbp
  801b83:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801b87:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801b8b:	be 01 00 00 00       	mov    $0x1,%esi
  801b90:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801b94:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  801b9b:	00 00 00 
  801b9e:	ff d0                	call   *%rax
}
  801ba0:	c9                   	leave
  801ba1:	c3                   	ret

0000000000801ba2 <getchar>:
getchar(void) {
  801ba2:	f3 0f 1e fa          	endbr64
  801ba6:	55                   	push   %rbp
  801ba7:	48 89 e5             	mov    %rsp,%rbp
  801baa:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801bae:	ba 01 00 00 00       	mov    $0x1,%edx
  801bb3:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  801bbc:	48 b8 b2 0a 80 00 00 	movabs $0x800ab2,%rax
  801bc3:	00 00 00 
  801bc6:	ff d0                	call   *%rax
  801bc8:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	78 06                	js     801bd4 <getchar+0x32>
  801bce:	74 08                	je     801bd8 <getchar+0x36>
  801bd0:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  801bd4:	89 d0                	mov    %edx,%eax
  801bd6:	c9                   	leave
  801bd7:	c3                   	ret
    return res < 0 ? res : res ? c :
  801bd8:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801bdd:	eb f5                	jmp    801bd4 <getchar+0x32>

0000000000801bdf <iscons>:
iscons(int fdnum) {
  801bdf:	f3 0f 1e fa          	endbr64
  801be3:	55                   	push   %rbp
  801be4:	48 89 e5             	mov    %rsp,%rbp
  801be7:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801beb:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801bef:	48 b8 b7 07 80 00 00 	movabs $0x8007b7,%rax
  801bf6:	00 00 00 
  801bf9:	ff d0                	call   *%rax
    if (res < 0) return res;
  801bfb:	85 c0                	test   %eax,%eax
  801bfd:	78 18                	js     801c17 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  801bff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c03:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801c0a:	00 00 00 
  801c0d:	8b 00                	mov    (%rax),%eax
  801c0f:	39 02                	cmp    %eax,(%rdx)
  801c11:	0f 94 c0             	sete   %al
  801c14:	0f b6 c0             	movzbl %al,%eax
}
  801c17:	c9                   	leave
  801c18:	c3                   	ret

0000000000801c19 <opencons>:
opencons(void) {
  801c19:	f3 0f 1e fa          	endbr64
  801c1d:	55                   	push   %rbp
  801c1e:	48 89 e5             	mov    %rsp,%rbp
  801c21:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801c25:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801c29:	48 b8 53 07 80 00 00 	movabs $0x800753,%rax
  801c30:	00 00 00 
  801c33:	ff d0                	call   *%rax
  801c35:	85 c0                	test   %eax,%eax
  801c37:	78 49                	js     801c82 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801c39:	b9 46 00 00 00       	mov    $0x46,%ecx
  801c3e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c43:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801c47:	bf 00 00 00 00       	mov    $0x0,%edi
  801c4c:	48 b8 d3 02 80 00 00 	movabs $0x8002d3,%rax
  801c53:	00 00 00 
  801c56:	ff d0                	call   *%rax
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	78 26                	js     801c82 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  801c5c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c60:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801c67:	00 00 
  801c69:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801c6b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801c6f:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801c76:	48 b8 1d 07 80 00 00 	movabs $0x80071d,%rax
  801c7d:	00 00 00 
  801c80:	ff d0                	call   *%rax
}
  801c82:	c9                   	leave
  801c83:	c3                   	ret

0000000000801c84 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801c84:	f3 0f 1e fa          	endbr64
  801c88:	55                   	push   %rbp
  801c89:	48 89 e5             	mov    %rsp,%rbp
  801c8c:	41 56                	push   %r14
  801c8e:	41 55                	push   %r13
  801c90:	41 54                	push   %r12
  801c92:	53                   	push   %rbx
  801c93:	48 83 ec 50          	sub    $0x50,%rsp
  801c97:	49 89 fc             	mov    %rdi,%r12
  801c9a:	41 89 f5             	mov    %esi,%r13d
  801c9d:	48 89 d3             	mov    %rdx,%rbx
  801ca0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801ca4:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801ca8:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801cac:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801cb3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801cb7:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801cbb:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801cbf:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801cc3:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801cca:	00 00 00 
  801ccd:	4c 8b 30             	mov    (%rax),%r14
  801cd0:	48 b8 03 02 80 00 00 	movabs $0x800203,%rax
  801cd7:	00 00 00 
  801cda:	ff d0                	call   *%rax
  801cdc:	89 c6                	mov    %eax,%esi
  801cde:	45 89 e8             	mov    %r13d,%r8d
  801ce1:	4c 89 e1             	mov    %r12,%rcx
  801ce4:	4c 89 f2             	mov    %r14,%rdx
  801ce7:	48 bf 28 33 80 00 00 	movabs $0x803328,%rdi
  801cee:	00 00 00 
  801cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf6:	49 bc e0 1d 80 00 00 	movabs $0x801de0,%r12
  801cfd:	00 00 00 
  801d00:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801d03:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801d07:	48 89 df             	mov    %rbx,%rdi
  801d0a:	48 b8 78 1d 80 00 00 	movabs $0x801d78,%rax
  801d11:	00 00 00 
  801d14:	ff d0                	call   *%rax
    cprintf("\n");
  801d16:	48 bf 32 30 80 00 00 	movabs $0x803032,%rdi
  801d1d:	00 00 00 
  801d20:	b8 00 00 00 00       	mov    $0x0,%eax
  801d25:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801d28:	cc                   	int3
  801d29:	eb fd                	jmp    801d28 <_panic+0xa4>

0000000000801d2b <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801d2b:	f3 0f 1e fa          	endbr64
  801d2f:	55                   	push   %rbp
  801d30:	48 89 e5             	mov    %rsp,%rbp
  801d33:	53                   	push   %rbx
  801d34:	48 83 ec 08          	sub    $0x8,%rsp
  801d38:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801d3b:	8b 06                	mov    (%rsi),%eax
  801d3d:	8d 50 01             	lea    0x1(%rax),%edx
  801d40:	89 16                	mov    %edx,(%rsi)
  801d42:	48 98                	cltq
  801d44:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801d49:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801d4f:	74 0a                	je     801d5b <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801d51:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801d55:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d59:	c9                   	leave
  801d5a:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  801d5b:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801d5f:	be ff 00 00 00       	mov    $0xff,%esi
  801d64:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  801d6b:	00 00 00 
  801d6e:	ff d0                	call   *%rax
        state->offset = 0;
  801d70:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801d76:	eb d9                	jmp    801d51 <putch+0x26>

0000000000801d78 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801d78:	f3 0f 1e fa          	endbr64
  801d7c:	55                   	push   %rbp
  801d7d:	48 89 e5             	mov    %rsp,%rbp
  801d80:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801d87:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801d8a:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801d91:	b9 21 00 00 00       	mov    $0x21,%ecx
  801d96:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9b:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801d9e:	48 89 f1             	mov    %rsi,%rcx
  801da1:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801da8:	48 bf 2b 1d 80 00 00 	movabs $0x801d2b,%rdi
  801daf:	00 00 00 
  801db2:	48 b8 40 1f 80 00 00 	movabs $0x801f40,%rax
  801db9:	00 00 00 
  801dbc:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801dbe:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801dc5:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801dcc:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  801dd3:	00 00 00 
  801dd6:	ff d0                	call   *%rax

    return state.count;
}
  801dd8:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801dde:	c9                   	leave
  801ddf:	c3                   	ret

0000000000801de0 <cprintf>:

int
cprintf(const char *fmt, ...) {
  801de0:	f3 0f 1e fa          	endbr64
  801de4:	55                   	push   %rbp
  801de5:	48 89 e5             	mov    %rsp,%rbp
  801de8:	48 83 ec 50          	sub    $0x50,%rsp
  801dec:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801df0:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801df4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801df8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801dfc:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801e00:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801e07:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e0b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e0f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801e13:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801e17:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801e1b:	48 b8 78 1d 80 00 00 	movabs $0x801d78,%rax
  801e22:	00 00 00 
  801e25:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801e27:	c9                   	leave
  801e28:	c3                   	ret

0000000000801e29 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801e29:	f3 0f 1e fa          	endbr64
  801e2d:	55                   	push   %rbp
  801e2e:	48 89 e5             	mov    %rsp,%rbp
  801e31:	41 57                	push   %r15
  801e33:	41 56                	push   %r14
  801e35:	41 55                	push   %r13
  801e37:	41 54                	push   %r12
  801e39:	53                   	push   %rbx
  801e3a:	48 83 ec 18          	sub    $0x18,%rsp
  801e3e:	49 89 fc             	mov    %rdi,%r12
  801e41:	49 89 f5             	mov    %rsi,%r13
  801e44:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801e48:	8b 45 10             	mov    0x10(%rbp),%eax
  801e4b:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801e4e:	41 89 cf             	mov    %ecx,%r15d
  801e51:	4c 39 fa             	cmp    %r15,%rdx
  801e54:	73 5b                	jae    801eb1 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801e56:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801e5a:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801e5e:	85 db                	test   %ebx,%ebx
  801e60:	7e 0e                	jle    801e70 <print_num+0x47>
            putch(padc, put_arg);
  801e62:	4c 89 ee             	mov    %r13,%rsi
  801e65:	44 89 f7             	mov    %r14d,%edi
  801e68:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801e6b:	83 eb 01             	sub    $0x1,%ebx
  801e6e:	75 f2                	jne    801e62 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801e70:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801e74:	48 b9 c2 30 80 00 00 	movabs $0x8030c2,%rcx
  801e7b:	00 00 00 
  801e7e:	48 b8 b1 30 80 00 00 	movabs $0x8030b1,%rax
  801e85:	00 00 00 
  801e88:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801e8c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e90:	ba 00 00 00 00       	mov    $0x0,%edx
  801e95:	49 f7 f7             	div    %r15
  801e98:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801e9c:	4c 89 ee             	mov    %r13,%rsi
  801e9f:	41 ff d4             	call   *%r12
}
  801ea2:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801ea6:	5b                   	pop    %rbx
  801ea7:	41 5c                	pop    %r12
  801ea9:	41 5d                	pop    %r13
  801eab:	41 5e                	pop    %r14
  801ead:	41 5f                	pop    %r15
  801eaf:	5d                   	pop    %rbp
  801eb0:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801eb1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801eb5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eba:	49 f7 f7             	div    %r15
  801ebd:	48 83 ec 08          	sub    $0x8,%rsp
  801ec1:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801ec5:	52                   	push   %rdx
  801ec6:	45 0f be c9          	movsbl %r9b,%r9d
  801eca:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801ece:	48 89 c2             	mov    %rax,%rdx
  801ed1:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  801ed8:	00 00 00 
  801edb:	ff d0                	call   *%rax
  801edd:	48 83 c4 10          	add    $0x10,%rsp
  801ee1:	eb 8d                	jmp    801e70 <print_num+0x47>

0000000000801ee3 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  801ee3:	f3 0f 1e fa          	endbr64
    state->count++;
  801ee7:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801eeb:	48 8b 06             	mov    (%rsi),%rax
  801eee:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801ef2:	73 0a                	jae    801efe <sprintputch+0x1b>
        *state->start++ = ch;
  801ef4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ef8:	48 89 16             	mov    %rdx,(%rsi)
  801efb:	40 88 38             	mov    %dil,(%rax)
    }
}
  801efe:	c3                   	ret

0000000000801eff <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801eff:	f3 0f 1e fa          	endbr64
  801f03:	55                   	push   %rbp
  801f04:	48 89 e5             	mov    %rsp,%rbp
  801f07:	48 83 ec 50          	sub    $0x50,%rsp
  801f0b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801f0f:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801f13:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801f17:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801f1e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801f22:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801f26:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801f2a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801f2e:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801f32:	48 b8 40 1f 80 00 00 	movabs $0x801f40,%rax
  801f39:	00 00 00 
  801f3c:	ff d0                	call   *%rax
}
  801f3e:	c9                   	leave
  801f3f:	c3                   	ret

0000000000801f40 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801f40:	f3 0f 1e fa          	endbr64
  801f44:	55                   	push   %rbp
  801f45:	48 89 e5             	mov    %rsp,%rbp
  801f48:	41 57                	push   %r15
  801f4a:	41 56                	push   %r14
  801f4c:	41 55                	push   %r13
  801f4e:	41 54                	push   %r12
  801f50:	53                   	push   %rbx
  801f51:	48 83 ec 38          	sub    $0x38,%rsp
  801f55:	49 89 fe             	mov    %rdi,%r14
  801f58:	49 89 f5             	mov    %rsi,%r13
  801f5b:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  801f5e:	48 8b 01             	mov    (%rcx),%rax
  801f61:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801f65:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801f69:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801f6d:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801f71:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801f75:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  801f79:	0f b6 3b             	movzbl (%rbx),%edi
  801f7c:	40 80 ff 25          	cmp    $0x25,%dil
  801f80:	74 18                	je     801f9a <vprintfmt+0x5a>
            if (!ch) return;
  801f82:	40 84 ff             	test   %dil,%dil
  801f85:	0f 84 b2 06 00 00    	je     80263d <vprintfmt+0x6fd>
            putch(ch, put_arg);
  801f8b:	40 0f b6 ff          	movzbl %dil,%edi
  801f8f:	4c 89 ee             	mov    %r13,%rsi
  801f92:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  801f95:	4c 89 e3             	mov    %r12,%rbx
  801f98:	eb db                	jmp    801f75 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  801f9a:	be 00 00 00 00       	mov    $0x0,%esi
  801f9f:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  801fa3:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801fa8:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801fae:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801fb5:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801fb9:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  801fbe:	41 0f b6 04 24       	movzbl (%r12),%eax
  801fc3:	88 45 a0             	mov    %al,-0x60(%rbp)
  801fc6:	83 e8 23             	sub    $0x23,%eax
  801fc9:	3c 57                	cmp    $0x57,%al
  801fcb:	0f 87 52 06 00 00    	ja     802623 <vprintfmt+0x6e3>
  801fd1:	0f b6 c0             	movzbl %al,%eax
  801fd4:	48 b9 c0 33 80 00 00 	movabs $0x8033c0,%rcx
  801fdb:	00 00 00 
  801fde:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  801fe2:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  801fe5:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  801fe9:	eb ce                	jmp    801fb9 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  801feb:	49 89 dc             	mov    %rbx,%r12
  801fee:	be 01 00 00 00       	mov    $0x1,%esi
  801ff3:	eb c4                	jmp    801fb9 <vprintfmt+0x79>
            padc = ch;
  801ff5:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  801ff9:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801ffc:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fff:	eb b8                	jmp    801fb9 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  802001:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802004:	83 f8 2f             	cmp    $0x2f,%eax
  802007:	77 24                	ja     80202d <vprintfmt+0xed>
  802009:	89 c1                	mov    %eax,%ecx
  80200b:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  80200f:	83 c0 08             	add    $0x8,%eax
  802012:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802015:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  802018:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  80201b:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80201f:	79 98                	jns    801fb9 <vprintfmt+0x79>
                width = precision;
  802021:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  802025:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80202b:	eb 8c                	jmp    801fb9 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80202d:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802031:	48 8d 41 08          	lea    0x8(%rcx),%rax
  802035:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802039:	eb da                	jmp    802015 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80203b:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  802040:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  802044:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80204a:	3c 39                	cmp    $0x39,%al
  80204c:	77 1c                	ja     80206a <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  80204e:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  802052:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  802056:	0f b6 c0             	movzbl %al,%eax
  802059:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80205e:	0f b6 03             	movzbl (%rbx),%eax
  802061:	3c 39                	cmp    $0x39,%al
  802063:	76 e9                	jbe    80204e <vprintfmt+0x10e>
        process_precision:
  802065:	49 89 dc             	mov    %rbx,%r12
  802068:	eb b1                	jmp    80201b <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80206a:	49 89 dc             	mov    %rbx,%r12
  80206d:	eb ac                	jmp    80201b <vprintfmt+0xdb>
            width = MAX(0, width);
  80206f:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  802072:	85 c9                	test   %ecx,%ecx
  802074:	b8 00 00 00 00       	mov    $0x0,%eax
  802079:	0f 49 c1             	cmovns %ecx,%eax
  80207c:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  80207f:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  802082:	e9 32 ff ff ff       	jmp    801fb9 <vprintfmt+0x79>
            lflag++;
  802087:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80208a:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80208d:	e9 27 ff ff ff       	jmp    801fb9 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  802092:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802095:	83 f8 2f             	cmp    $0x2f,%eax
  802098:	77 19                	ja     8020b3 <vprintfmt+0x173>
  80209a:	89 c2                	mov    %eax,%edx
  80209c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8020a0:	83 c0 08             	add    $0x8,%eax
  8020a3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020a6:	8b 3a                	mov    (%rdx),%edi
  8020a8:	4c 89 ee             	mov    %r13,%rsi
  8020ab:	41 ff d6             	call   *%r14
            break;
  8020ae:	e9 c2 fe ff ff       	jmp    801f75 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8020b3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8020b7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8020bb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020bf:	eb e5                	jmp    8020a6 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8020c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020c4:	83 f8 2f             	cmp    $0x2f,%eax
  8020c7:	77 5a                	ja     802123 <vprintfmt+0x1e3>
  8020c9:	89 c2                	mov    %eax,%edx
  8020cb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8020cf:	83 c0 08             	add    $0x8,%eax
  8020d2:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8020d5:	8b 02                	mov    (%rdx),%eax
  8020d7:	89 c1                	mov    %eax,%ecx
  8020d9:	f7 d9                	neg    %ecx
  8020db:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8020de:	83 f9 13             	cmp    $0x13,%ecx
  8020e1:	7f 4e                	jg     802131 <vprintfmt+0x1f1>
  8020e3:	48 63 c1             	movslq %ecx,%rax
  8020e6:	48 ba 80 36 80 00 00 	movabs $0x803680,%rdx
  8020ed:	00 00 00 
  8020f0:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8020f4:	48 85 c0             	test   %rax,%rax
  8020f7:	74 38                	je     802131 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8020f9:	48 89 c1             	mov    %rax,%rcx
  8020fc:	48 ba 80 30 80 00 00 	movabs $0x803080,%rdx
  802103:	00 00 00 
  802106:	4c 89 ee             	mov    %r13,%rsi
  802109:	4c 89 f7             	mov    %r14,%rdi
  80210c:	b8 00 00 00 00       	mov    $0x0,%eax
  802111:	49 b8 ff 1e 80 00 00 	movabs $0x801eff,%r8
  802118:	00 00 00 
  80211b:	41 ff d0             	call   *%r8
  80211e:	e9 52 fe ff ff       	jmp    801f75 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  802123:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802127:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80212b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80212f:	eb a4                	jmp    8020d5 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  802131:	48 ba da 30 80 00 00 	movabs $0x8030da,%rdx
  802138:	00 00 00 
  80213b:	4c 89 ee             	mov    %r13,%rsi
  80213e:	4c 89 f7             	mov    %r14,%rdi
  802141:	b8 00 00 00 00       	mov    $0x0,%eax
  802146:	49 b8 ff 1e 80 00 00 	movabs $0x801eff,%r8
  80214d:	00 00 00 
  802150:	41 ff d0             	call   *%r8
  802153:	e9 1d fe ff ff       	jmp    801f75 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  802158:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80215b:	83 f8 2f             	cmp    $0x2f,%eax
  80215e:	77 6c                	ja     8021cc <vprintfmt+0x28c>
  802160:	89 c2                	mov    %eax,%edx
  802162:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802166:	83 c0 08             	add    $0x8,%eax
  802169:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80216c:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  80216f:	48 85 d2             	test   %rdx,%rdx
  802172:	48 b8 d3 30 80 00 00 	movabs $0x8030d3,%rax
  802179:	00 00 00 
  80217c:	48 0f 45 c2          	cmovne %rdx,%rax
  802180:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  802184:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  802188:	7e 06                	jle    802190 <vprintfmt+0x250>
  80218a:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  80218e:	75 4a                	jne    8021da <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802190:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802194:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802198:	0f b6 00             	movzbl (%rax),%eax
  80219b:	84 c0                	test   %al,%al
  80219d:	0f 85 9a 00 00 00    	jne    80223d <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8021a3:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8021a6:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	0f 8e c3 fd ff ff    	jle    801f75 <vprintfmt+0x35>
  8021b2:	4c 89 ee             	mov    %r13,%rsi
  8021b5:	bf 20 00 00 00       	mov    $0x20,%edi
  8021ba:	41 ff d6             	call   *%r14
  8021bd:	41 83 ec 01          	sub    $0x1,%r12d
  8021c1:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8021c5:	75 eb                	jne    8021b2 <vprintfmt+0x272>
  8021c7:	e9 a9 fd ff ff       	jmp    801f75 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8021cc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8021d0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8021d4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8021d8:	eb 92                	jmp    80216c <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8021da:	49 63 f7             	movslq %r15d,%rsi
  8021dd:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8021e1:	48 b8 03 27 80 00 00 	movabs $0x802703,%rax
  8021e8:	00 00 00 
  8021eb:	ff d0                	call   *%rax
  8021ed:	48 89 c2             	mov    %rax,%rdx
  8021f0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8021f3:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8021f5:	8d 70 ff             	lea    -0x1(%rax),%esi
  8021f8:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	7e 91                	jle    802190 <vprintfmt+0x250>
  8021ff:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  802204:	4c 89 ee             	mov    %r13,%rsi
  802207:	44 89 e7             	mov    %r12d,%edi
  80220a:	41 ff d6             	call   *%r14
  80220d:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  802211:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802214:	83 f8 ff             	cmp    $0xffffffff,%eax
  802217:	75 eb                	jne    802204 <vprintfmt+0x2c4>
  802219:	e9 72 ff ff ff       	jmp    802190 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80221e:	0f b6 f8             	movzbl %al,%edi
  802221:	4c 89 ee             	mov    %r13,%rsi
  802224:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802227:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80222b:	49 83 c4 01          	add    $0x1,%r12
  80222f:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  802235:	84 c0                	test   %al,%al
  802237:	0f 84 66 ff ff ff    	je     8021a3 <vprintfmt+0x263>
  80223d:	45 85 ff             	test   %r15d,%r15d
  802240:	78 0a                	js     80224c <vprintfmt+0x30c>
  802242:	41 83 ef 01          	sub    $0x1,%r15d
  802246:	0f 88 57 ff ff ff    	js     8021a3 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80224c:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  802250:	74 cc                	je     80221e <vprintfmt+0x2de>
  802252:	8d 50 e0             	lea    -0x20(%rax),%edx
  802255:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80225a:	80 fa 5e             	cmp    $0x5e,%dl
  80225d:	77 c2                	ja     802221 <vprintfmt+0x2e1>
  80225f:	eb bd                	jmp    80221e <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  802261:	40 84 f6             	test   %sil,%sil
  802264:	75 26                	jne    80228c <vprintfmt+0x34c>
    switch (lflag) {
  802266:	85 d2                	test   %edx,%edx
  802268:	74 59                	je     8022c3 <vprintfmt+0x383>
  80226a:	83 fa 01             	cmp    $0x1,%edx
  80226d:	74 7b                	je     8022ea <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  80226f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802272:	83 f8 2f             	cmp    $0x2f,%eax
  802275:	0f 87 96 00 00 00    	ja     802311 <vprintfmt+0x3d1>
  80227b:	89 c2                	mov    %eax,%edx
  80227d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802281:	83 c0 08             	add    $0x8,%eax
  802284:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802287:	4c 8b 22             	mov    (%rdx),%r12
  80228a:	eb 17                	jmp    8022a3 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  80228c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80228f:	83 f8 2f             	cmp    $0x2f,%eax
  802292:	77 21                	ja     8022b5 <vprintfmt+0x375>
  802294:	89 c2                	mov    %eax,%edx
  802296:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80229a:	83 c0 08             	add    $0x8,%eax
  80229d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022a0:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8022a3:	4d 85 e4             	test   %r12,%r12
  8022a6:	78 7a                	js     802322 <vprintfmt+0x3e2>
            num = i;
  8022a8:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8022ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8022b0:	e9 50 02 00 00       	jmp    802505 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8022b5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8022b9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8022bd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022c1:	eb dd                	jmp    8022a0 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8022c3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022c6:	83 f8 2f             	cmp    $0x2f,%eax
  8022c9:	77 11                	ja     8022dc <vprintfmt+0x39c>
  8022cb:	89 c2                	mov    %eax,%edx
  8022cd:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022d1:	83 c0 08             	add    $0x8,%eax
  8022d4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022d7:	4c 63 22             	movslq (%rdx),%r12
  8022da:	eb c7                	jmp    8022a3 <vprintfmt+0x363>
  8022dc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8022e0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8022e4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022e8:	eb ed                	jmp    8022d7 <vprintfmt+0x397>
        return va_arg(*ap, long);
  8022ea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022ed:	83 f8 2f             	cmp    $0x2f,%eax
  8022f0:	77 11                	ja     802303 <vprintfmt+0x3c3>
  8022f2:	89 c2                	mov    %eax,%edx
  8022f4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022f8:	83 c0 08             	add    $0x8,%eax
  8022fb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022fe:	4c 8b 22             	mov    (%rdx),%r12
  802301:	eb a0                	jmp    8022a3 <vprintfmt+0x363>
  802303:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802307:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80230b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80230f:	eb ed                	jmp    8022fe <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  802311:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802315:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802319:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80231d:	e9 65 ff ff ff       	jmp    802287 <vprintfmt+0x347>
                putch('-', put_arg);
  802322:	4c 89 ee             	mov    %r13,%rsi
  802325:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80232a:	41 ff d6             	call   *%r14
                i = -i;
  80232d:	49 f7 dc             	neg    %r12
  802330:	e9 73 ff ff ff       	jmp    8022a8 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  802335:	40 84 f6             	test   %sil,%sil
  802338:	75 32                	jne    80236c <vprintfmt+0x42c>
    switch (lflag) {
  80233a:	85 d2                	test   %edx,%edx
  80233c:	74 5d                	je     80239b <vprintfmt+0x45b>
  80233e:	83 fa 01             	cmp    $0x1,%edx
  802341:	0f 84 82 00 00 00    	je     8023c9 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  802347:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80234a:	83 f8 2f             	cmp    $0x2f,%eax
  80234d:	0f 87 a5 00 00 00    	ja     8023f8 <vprintfmt+0x4b8>
  802353:	89 c2                	mov    %eax,%edx
  802355:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802359:	83 c0 08             	add    $0x8,%eax
  80235c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80235f:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  802362:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  802367:	e9 99 01 00 00       	jmp    802505 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80236c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80236f:	83 f8 2f             	cmp    $0x2f,%eax
  802372:	77 19                	ja     80238d <vprintfmt+0x44d>
  802374:	89 c2                	mov    %eax,%edx
  802376:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80237a:	83 c0 08             	add    $0x8,%eax
  80237d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802380:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  802383:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802388:	e9 78 01 00 00       	jmp    802505 <vprintfmt+0x5c5>
  80238d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802391:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802395:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802399:	eb e5                	jmp    802380 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  80239b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80239e:	83 f8 2f             	cmp    $0x2f,%eax
  8023a1:	77 18                	ja     8023bb <vprintfmt+0x47b>
  8023a3:	89 c2                	mov    %eax,%edx
  8023a5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023a9:	83 c0 08             	add    $0x8,%eax
  8023ac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023af:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8023b1:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8023b6:	e9 4a 01 00 00       	jmp    802505 <vprintfmt+0x5c5>
  8023bb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023bf:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023c3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023c7:	eb e6                	jmp    8023af <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8023c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023cc:	83 f8 2f             	cmp    $0x2f,%eax
  8023cf:	77 19                	ja     8023ea <vprintfmt+0x4aa>
  8023d1:	89 c2                	mov    %eax,%edx
  8023d3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023d7:	83 c0 08             	add    $0x8,%eax
  8023da:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023dd:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8023e0:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8023e5:	e9 1b 01 00 00       	jmp    802505 <vprintfmt+0x5c5>
  8023ea:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023ee:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023f2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023f6:	eb e5                	jmp    8023dd <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  8023f8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023fc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802400:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802404:	e9 56 ff ff ff       	jmp    80235f <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  802409:	40 84 f6             	test   %sil,%sil
  80240c:	75 2e                	jne    80243c <vprintfmt+0x4fc>
    switch (lflag) {
  80240e:	85 d2                	test   %edx,%edx
  802410:	74 59                	je     80246b <vprintfmt+0x52b>
  802412:	83 fa 01             	cmp    $0x1,%edx
  802415:	74 7f                	je     802496 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  802417:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80241a:	83 f8 2f             	cmp    $0x2f,%eax
  80241d:	0f 87 9f 00 00 00    	ja     8024c2 <vprintfmt+0x582>
  802423:	89 c2                	mov    %eax,%edx
  802425:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802429:	83 c0 08             	add    $0x8,%eax
  80242c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80242f:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  802432:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  802437:	e9 c9 00 00 00       	jmp    802505 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80243c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80243f:	83 f8 2f             	cmp    $0x2f,%eax
  802442:	77 19                	ja     80245d <vprintfmt+0x51d>
  802444:	89 c2                	mov    %eax,%edx
  802446:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80244a:	83 c0 08             	add    $0x8,%eax
  80244d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802450:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  802453:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802458:	e9 a8 00 00 00       	jmp    802505 <vprintfmt+0x5c5>
  80245d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802461:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802465:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802469:	eb e5                	jmp    802450 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  80246b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80246e:	83 f8 2f             	cmp    $0x2f,%eax
  802471:	77 15                	ja     802488 <vprintfmt+0x548>
  802473:	89 c2                	mov    %eax,%edx
  802475:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802479:	83 c0 08             	add    $0x8,%eax
  80247c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80247f:	8b 12                	mov    (%rdx),%edx
            base = 8;
  802481:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  802486:	eb 7d                	jmp    802505 <vprintfmt+0x5c5>
  802488:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80248c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802490:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802494:	eb e9                	jmp    80247f <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  802496:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802499:	83 f8 2f             	cmp    $0x2f,%eax
  80249c:	77 16                	ja     8024b4 <vprintfmt+0x574>
  80249e:	89 c2                	mov    %eax,%edx
  8024a0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024a4:	83 c0 08             	add    $0x8,%eax
  8024a7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024aa:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8024ad:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8024b2:	eb 51                	jmp    802505 <vprintfmt+0x5c5>
  8024b4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024b8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8024bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024c0:	eb e8                	jmp    8024aa <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8024c2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024c6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8024ca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024ce:	e9 5c ff ff ff       	jmp    80242f <vprintfmt+0x4ef>
            putch('0', put_arg);
  8024d3:	4c 89 ee             	mov    %r13,%rsi
  8024d6:	bf 30 00 00 00       	mov    $0x30,%edi
  8024db:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  8024de:	4c 89 ee             	mov    %r13,%rsi
  8024e1:	bf 78 00 00 00       	mov    $0x78,%edi
  8024e6:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  8024e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024ec:	83 f8 2f             	cmp    $0x2f,%eax
  8024ef:	77 47                	ja     802538 <vprintfmt+0x5f8>
  8024f1:	89 c2                	mov    %eax,%edx
  8024f3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024f7:	83 c0 08             	add    $0x8,%eax
  8024fa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024fd:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802500:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  802505:	48 83 ec 08          	sub    $0x8,%rsp
  802509:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  80250d:	0f 94 c0             	sete   %al
  802510:	0f b6 c0             	movzbl %al,%eax
  802513:	50                   	push   %rax
  802514:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  802519:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80251d:	4c 89 ee             	mov    %r13,%rsi
  802520:	4c 89 f7             	mov    %r14,%rdi
  802523:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  80252a:	00 00 00 
  80252d:	ff d0                	call   *%rax
            break;
  80252f:	48 83 c4 10          	add    $0x10,%rsp
  802533:	e9 3d fa ff ff       	jmp    801f75 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  802538:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80253c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802540:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802544:	eb b7                	jmp    8024fd <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  802546:	40 84 f6             	test   %sil,%sil
  802549:	75 2b                	jne    802576 <vprintfmt+0x636>
    switch (lflag) {
  80254b:	85 d2                	test   %edx,%edx
  80254d:	74 56                	je     8025a5 <vprintfmt+0x665>
  80254f:	83 fa 01             	cmp    $0x1,%edx
  802552:	74 7f                	je     8025d3 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  802554:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802557:	83 f8 2f             	cmp    $0x2f,%eax
  80255a:	0f 87 a2 00 00 00    	ja     802602 <vprintfmt+0x6c2>
  802560:	89 c2                	mov    %eax,%edx
  802562:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802566:	83 c0 08             	add    $0x8,%eax
  802569:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80256c:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80256f:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  802574:	eb 8f                	jmp    802505 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  802576:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802579:	83 f8 2f             	cmp    $0x2f,%eax
  80257c:	77 19                	ja     802597 <vprintfmt+0x657>
  80257e:	89 c2                	mov    %eax,%edx
  802580:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802584:	83 c0 08             	add    $0x8,%eax
  802587:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80258a:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80258d:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802592:	e9 6e ff ff ff       	jmp    802505 <vprintfmt+0x5c5>
  802597:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80259b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80259f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8025a3:	eb e5                	jmp    80258a <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8025a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025a8:	83 f8 2f             	cmp    $0x2f,%eax
  8025ab:	77 18                	ja     8025c5 <vprintfmt+0x685>
  8025ad:	89 c2                	mov    %eax,%edx
  8025af:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8025b3:	83 c0 08             	add    $0x8,%eax
  8025b6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8025b9:	8b 12                	mov    (%rdx),%edx
            base = 16;
  8025bb:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8025c0:	e9 40 ff ff ff       	jmp    802505 <vprintfmt+0x5c5>
  8025c5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025c9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8025cd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8025d1:	eb e6                	jmp    8025b9 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  8025d3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025d6:	83 f8 2f             	cmp    $0x2f,%eax
  8025d9:	77 19                	ja     8025f4 <vprintfmt+0x6b4>
  8025db:	89 c2                	mov    %eax,%edx
  8025dd:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8025e1:	83 c0 08             	add    $0x8,%eax
  8025e4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8025e7:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8025ea:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8025ef:	e9 11 ff ff ff       	jmp    802505 <vprintfmt+0x5c5>
  8025f4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025f8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8025fc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802600:	eb e5                	jmp    8025e7 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  802602:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802606:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80260a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80260e:	e9 59 ff ff ff       	jmp    80256c <vprintfmt+0x62c>
            putch(ch, put_arg);
  802613:	4c 89 ee             	mov    %r13,%rsi
  802616:	bf 25 00 00 00       	mov    $0x25,%edi
  80261b:	41 ff d6             	call   *%r14
            break;
  80261e:	e9 52 f9 ff ff       	jmp    801f75 <vprintfmt+0x35>
            putch('%', put_arg);
  802623:	4c 89 ee             	mov    %r13,%rsi
  802626:	bf 25 00 00 00       	mov    $0x25,%edi
  80262b:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  80262e:	48 83 eb 01          	sub    $0x1,%rbx
  802632:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  802636:	75 f6                	jne    80262e <vprintfmt+0x6ee>
  802638:	e9 38 f9 ff ff       	jmp    801f75 <vprintfmt+0x35>
}
  80263d:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  802641:	5b                   	pop    %rbx
  802642:	41 5c                	pop    %r12
  802644:	41 5d                	pop    %r13
  802646:	41 5e                	pop    %r14
  802648:	41 5f                	pop    %r15
  80264a:	5d                   	pop    %rbp
  80264b:	c3                   	ret

000000000080264c <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  80264c:	f3 0f 1e fa          	endbr64
  802650:	55                   	push   %rbp
  802651:	48 89 e5             	mov    %rsp,%rbp
  802654:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  802658:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80265c:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  802661:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802665:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  80266c:	48 85 ff             	test   %rdi,%rdi
  80266f:	74 2b                	je     80269c <vsnprintf+0x50>
  802671:	48 85 f6             	test   %rsi,%rsi
  802674:	74 26                	je     80269c <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  802676:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80267a:	48 bf e3 1e 80 00 00 	movabs $0x801ee3,%rdi
  802681:	00 00 00 
  802684:	48 b8 40 1f 80 00 00 	movabs $0x801f40,%rax
  80268b:	00 00 00 
  80268e:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  802690:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802694:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  802697:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80269a:	c9                   	leave
  80269b:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  80269c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026a1:	eb f7                	jmp    80269a <vsnprintf+0x4e>

00000000008026a3 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8026a3:	f3 0f 1e fa          	endbr64
  8026a7:	55                   	push   %rbp
  8026a8:	48 89 e5             	mov    %rsp,%rbp
  8026ab:	48 83 ec 50          	sub    $0x50,%rsp
  8026af:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8026b3:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8026b7:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8026bb:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8026c2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8026c6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8026ca:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8026ce:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  8026d2:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8026d6:	48 b8 4c 26 80 00 00 	movabs $0x80264c,%rax
  8026dd:	00 00 00 
  8026e0:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  8026e2:	c9                   	leave
  8026e3:	c3                   	ret

00000000008026e4 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  8026e4:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  8026e8:	80 3f 00             	cmpb   $0x0,(%rdi)
  8026eb:	74 10                	je     8026fd <strlen+0x19>
    size_t n = 0;
  8026ed:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8026f2:	48 83 c0 01          	add    $0x1,%rax
  8026f6:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8026fa:	75 f6                	jne    8026f2 <strlen+0xe>
  8026fc:	c3                   	ret
    size_t n = 0;
  8026fd:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  802702:	c3                   	ret

0000000000802703 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  802703:	f3 0f 1e fa          	endbr64
  802707:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  80270a:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  80270f:	48 85 f6             	test   %rsi,%rsi
  802712:	74 10                	je     802724 <strnlen+0x21>
  802714:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  802718:	74 0b                	je     802725 <strnlen+0x22>
  80271a:	48 83 c2 01          	add    $0x1,%rdx
  80271e:	48 39 d0             	cmp    %rdx,%rax
  802721:	75 f1                	jne    802714 <strnlen+0x11>
  802723:	c3                   	ret
  802724:	c3                   	ret
  802725:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  802728:	c3                   	ret

0000000000802729 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  802729:	f3 0f 1e fa          	endbr64
  80272d:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  802730:	ba 00 00 00 00       	mov    $0x0,%edx
  802735:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  802739:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  80273c:	48 83 c2 01          	add    $0x1,%rdx
  802740:	84 c9                	test   %cl,%cl
  802742:	75 f1                	jne    802735 <strcpy+0xc>
        ;
    return res;
}
  802744:	c3                   	ret

0000000000802745 <strcat>:

char *
strcat(char *dst, const char *src) {
  802745:	f3 0f 1e fa          	endbr64
  802749:	55                   	push   %rbp
  80274a:	48 89 e5             	mov    %rsp,%rbp
  80274d:	41 54                	push   %r12
  80274f:	53                   	push   %rbx
  802750:	48 89 fb             	mov    %rdi,%rbx
  802753:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  802756:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  80275d:	00 00 00 
  802760:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  802762:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  802766:	4c 89 e6             	mov    %r12,%rsi
  802769:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  802770:	00 00 00 
  802773:	ff d0                	call   *%rax
    return dst;
}
  802775:	48 89 d8             	mov    %rbx,%rax
  802778:	5b                   	pop    %rbx
  802779:	41 5c                	pop    %r12
  80277b:	5d                   	pop    %rbp
  80277c:	c3                   	ret

000000000080277d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80277d:	f3 0f 1e fa          	endbr64
  802781:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  802784:	48 85 d2             	test   %rdx,%rdx
  802787:	74 1f                	je     8027a8 <strncpy+0x2b>
  802789:	48 01 fa             	add    %rdi,%rdx
  80278c:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  80278f:	48 83 c1 01          	add    $0x1,%rcx
  802793:	44 0f b6 06          	movzbl (%rsi),%r8d
  802797:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  80279b:	41 80 f8 01          	cmp    $0x1,%r8b
  80279f:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8027a3:	48 39 ca             	cmp    %rcx,%rdx
  8027a6:	75 e7                	jne    80278f <strncpy+0x12>
    }
    return ret;
}
  8027a8:	c3                   	ret

00000000008027a9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  8027a9:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  8027ad:	48 89 f8             	mov    %rdi,%rax
  8027b0:	48 85 d2             	test   %rdx,%rdx
  8027b3:	74 24                	je     8027d9 <strlcpy+0x30>
        while (--size > 0 && *src)
  8027b5:	48 83 ea 01          	sub    $0x1,%rdx
  8027b9:	74 1b                	je     8027d6 <strlcpy+0x2d>
  8027bb:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8027bf:	0f b6 16             	movzbl (%rsi),%edx
  8027c2:	84 d2                	test   %dl,%dl
  8027c4:	74 10                	je     8027d6 <strlcpy+0x2d>
            *dst++ = *src++;
  8027c6:	48 83 c6 01          	add    $0x1,%rsi
  8027ca:	48 83 c0 01          	add    $0x1,%rax
  8027ce:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  8027d1:	48 39 c8             	cmp    %rcx,%rax
  8027d4:	75 e9                	jne    8027bf <strlcpy+0x16>
        *dst = '\0';
  8027d6:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  8027d9:	48 29 f8             	sub    %rdi,%rax
}
  8027dc:	c3                   	ret

00000000008027dd <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  8027dd:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  8027e1:	0f b6 07             	movzbl (%rdi),%eax
  8027e4:	84 c0                	test   %al,%al
  8027e6:	74 13                	je     8027fb <strcmp+0x1e>
  8027e8:	38 06                	cmp    %al,(%rsi)
  8027ea:	75 0f                	jne    8027fb <strcmp+0x1e>
  8027ec:	48 83 c7 01          	add    $0x1,%rdi
  8027f0:	48 83 c6 01          	add    $0x1,%rsi
  8027f4:	0f b6 07             	movzbl (%rdi),%eax
  8027f7:	84 c0                	test   %al,%al
  8027f9:	75 ed                	jne    8027e8 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  8027fb:	0f b6 c0             	movzbl %al,%eax
  8027fe:	0f b6 16             	movzbl (%rsi),%edx
  802801:	29 d0                	sub    %edx,%eax
}
  802803:	c3                   	ret

0000000000802804 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  802804:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  802808:	48 85 d2             	test   %rdx,%rdx
  80280b:	74 1f                	je     80282c <strncmp+0x28>
  80280d:	0f b6 07             	movzbl (%rdi),%eax
  802810:	84 c0                	test   %al,%al
  802812:	74 1e                	je     802832 <strncmp+0x2e>
  802814:	3a 06                	cmp    (%rsi),%al
  802816:	75 1a                	jne    802832 <strncmp+0x2e>
  802818:	48 83 c7 01          	add    $0x1,%rdi
  80281c:	48 83 c6 01          	add    $0x1,%rsi
  802820:	48 83 ea 01          	sub    $0x1,%rdx
  802824:	75 e7                	jne    80280d <strncmp+0x9>

    if (!n) return 0;
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
  80282b:	c3                   	ret
  80282c:	b8 00 00 00 00       	mov    $0x0,%eax
  802831:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  802832:	0f b6 07             	movzbl (%rdi),%eax
  802835:	0f b6 16             	movzbl (%rsi),%edx
  802838:	29 d0                	sub    %edx,%eax
}
  80283a:	c3                   	ret

000000000080283b <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  80283b:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  80283f:	0f b6 17             	movzbl (%rdi),%edx
  802842:	84 d2                	test   %dl,%dl
  802844:	74 18                	je     80285e <strchr+0x23>
        if (*str == c) {
  802846:	0f be d2             	movsbl %dl,%edx
  802849:	39 f2                	cmp    %esi,%edx
  80284b:	74 17                	je     802864 <strchr+0x29>
    for (; *str; str++) {
  80284d:	48 83 c7 01          	add    $0x1,%rdi
  802851:	0f b6 17             	movzbl (%rdi),%edx
  802854:	84 d2                	test   %dl,%dl
  802856:	75 ee                	jne    802846 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  802858:	b8 00 00 00 00       	mov    $0x0,%eax
  80285d:	c3                   	ret
  80285e:	b8 00 00 00 00       	mov    $0x0,%eax
  802863:	c3                   	ret
            return (char *)str;
  802864:	48 89 f8             	mov    %rdi,%rax
}
  802867:	c3                   	ret

0000000000802868 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  802868:	f3 0f 1e fa          	endbr64
  80286c:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  80286f:	0f b6 17             	movzbl (%rdi),%edx
  802872:	84 d2                	test   %dl,%dl
  802874:	74 13                	je     802889 <strfind+0x21>
  802876:	0f be d2             	movsbl %dl,%edx
  802879:	39 f2                	cmp    %esi,%edx
  80287b:	74 0b                	je     802888 <strfind+0x20>
  80287d:	48 83 c0 01          	add    $0x1,%rax
  802881:	0f b6 10             	movzbl (%rax),%edx
  802884:	84 d2                	test   %dl,%dl
  802886:	75 ee                	jne    802876 <strfind+0xe>
        ;
    return (char *)str;
}
  802888:	c3                   	ret
  802889:	c3                   	ret

000000000080288a <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80288a:	f3 0f 1e fa          	endbr64
  80288e:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  802891:	48 89 f8             	mov    %rdi,%rax
  802894:	48 f7 d8             	neg    %rax
  802897:	83 e0 07             	and    $0x7,%eax
  80289a:	49 89 d1             	mov    %rdx,%r9
  80289d:	49 29 c1             	sub    %rax,%r9
  8028a0:	78 36                	js     8028d8 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8028a2:	40 0f b6 c6          	movzbl %sil,%eax
  8028a6:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  8028ad:	01 01 01 
  8028b0:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  8028b4:	40 f6 c7 07          	test   $0x7,%dil
  8028b8:	75 38                	jne    8028f2 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  8028ba:	4c 89 c9             	mov    %r9,%rcx
  8028bd:	48 c1 f9 03          	sar    $0x3,%rcx
  8028c1:	74 0c                	je     8028cf <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8028c3:	fc                   	cld
  8028c4:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  8028c7:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  8028cb:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8028cf:	4d 85 c9             	test   %r9,%r9
  8028d2:	75 45                	jne    802919 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8028d4:	4c 89 c0             	mov    %r8,%rax
  8028d7:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  8028d8:	48 85 d2             	test   %rdx,%rdx
  8028db:	74 f7                	je     8028d4 <memset+0x4a>
  8028dd:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  8028e0:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  8028e3:	48 83 c0 01          	add    $0x1,%rax
  8028e7:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8028eb:	48 39 c2             	cmp    %rax,%rdx
  8028ee:	75 f3                	jne    8028e3 <memset+0x59>
  8028f0:	eb e2                	jmp    8028d4 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8028f2:	40 f6 c7 01          	test   $0x1,%dil
  8028f6:	74 06                	je     8028fe <memset+0x74>
  8028f8:	88 07                	mov    %al,(%rdi)
  8028fa:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8028fe:	40 f6 c7 02          	test   $0x2,%dil
  802902:	74 07                	je     80290b <memset+0x81>
  802904:	66 89 07             	mov    %ax,(%rdi)
  802907:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  80290b:	40 f6 c7 04          	test   $0x4,%dil
  80290f:	74 a9                	je     8028ba <memset+0x30>
  802911:	89 07                	mov    %eax,(%rdi)
  802913:	48 83 c7 04          	add    $0x4,%rdi
  802917:	eb a1                	jmp    8028ba <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  802919:	41 f6 c1 04          	test   $0x4,%r9b
  80291d:	74 1b                	je     80293a <memset+0xb0>
  80291f:	89 07                	mov    %eax,(%rdi)
  802921:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  802925:	41 f6 c1 02          	test   $0x2,%r9b
  802929:	74 07                	je     802932 <memset+0xa8>
  80292b:	66 89 07             	mov    %ax,(%rdi)
  80292e:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  802932:	41 f6 c1 01          	test   $0x1,%r9b
  802936:	74 9c                	je     8028d4 <memset+0x4a>
  802938:	eb 06                	jmp    802940 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80293a:	41 f6 c1 02          	test   $0x2,%r9b
  80293e:	75 eb                	jne    80292b <memset+0xa1>
        if (ni & 1) *ptr = k;
  802940:	88 07                	mov    %al,(%rdi)
  802942:	eb 90                	jmp    8028d4 <memset+0x4a>

0000000000802944 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  802944:	f3 0f 1e fa          	endbr64
  802948:	48 89 f8             	mov    %rdi,%rax
  80294b:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  80294e:	48 39 fe             	cmp    %rdi,%rsi
  802951:	73 3b                	jae    80298e <memmove+0x4a>
  802953:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  802957:	48 39 d7             	cmp    %rdx,%rdi
  80295a:	73 32                	jae    80298e <memmove+0x4a>
        s += n;
        d += n;
  80295c:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802960:	48 89 d6             	mov    %rdx,%rsi
  802963:	48 09 fe             	or     %rdi,%rsi
  802966:	48 09 ce             	or     %rcx,%rsi
  802969:	40 f6 c6 07          	test   $0x7,%sil
  80296d:	75 12                	jne    802981 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  80296f:	48 83 ef 08          	sub    $0x8,%rdi
  802973:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  802977:	48 c1 e9 03          	shr    $0x3,%rcx
  80297b:	fd                   	std
  80297c:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80297f:	fc                   	cld
  802980:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  802981:	48 83 ef 01          	sub    $0x1,%rdi
  802985:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  802989:	fd                   	std
  80298a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  80298c:	eb f1                	jmp    80297f <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80298e:	48 89 f2             	mov    %rsi,%rdx
  802991:	48 09 c2             	or     %rax,%rdx
  802994:	48 09 ca             	or     %rcx,%rdx
  802997:	f6 c2 07             	test   $0x7,%dl
  80299a:	75 0c                	jne    8029a8 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80299c:	48 c1 e9 03          	shr    $0x3,%rcx
  8029a0:	48 89 c7             	mov    %rax,%rdi
  8029a3:	fc                   	cld
  8029a4:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8029a7:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8029a8:	48 89 c7             	mov    %rax,%rdi
  8029ab:	fc                   	cld
  8029ac:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8029ae:	c3                   	ret

00000000008029af <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8029af:	f3 0f 1e fa          	endbr64
  8029b3:	55                   	push   %rbp
  8029b4:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8029b7:	48 b8 44 29 80 00 00 	movabs $0x802944,%rax
  8029be:	00 00 00 
  8029c1:	ff d0                	call   *%rax
}
  8029c3:	5d                   	pop    %rbp
  8029c4:	c3                   	ret

00000000008029c5 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8029c5:	f3 0f 1e fa          	endbr64
  8029c9:	55                   	push   %rbp
  8029ca:	48 89 e5             	mov    %rsp,%rbp
  8029cd:	41 57                	push   %r15
  8029cf:	41 56                	push   %r14
  8029d1:	41 55                	push   %r13
  8029d3:	41 54                	push   %r12
  8029d5:	53                   	push   %rbx
  8029d6:	48 83 ec 08          	sub    $0x8,%rsp
  8029da:	49 89 fe             	mov    %rdi,%r14
  8029dd:	49 89 f7             	mov    %rsi,%r15
  8029e0:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8029e3:	48 89 f7             	mov    %rsi,%rdi
  8029e6:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  8029ed:	00 00 00 
  8029f0:	ff d0                	call   *%rax
  8029f2:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8029f5:	48 89 de             	mov    %rbx,%rsi
  8029f8:	4c 89 f7             	mov    %r14,%rdi
  8029fb:	48 b8 03 27 80 00 00 	movabs $0x802703,%rax
  802a02:	00 00 00 
  802a05:	ff d0                	call   *%rax
  802a07:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  802a0a:	48 39 c3             	cmp    %rax,%rbx
  802a0d:	74 36                	je     802a45 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  802a0f:	48 89 d8             	mov    %rbx,%rax
  802a12:	4c 29 e8             	sub    %r13,%rax
  802a15:	49 39 c4             	cmp    %rax,%r12
  802a18:	73 31                	jae    802a4b <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  802a1a:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  802a1f:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  802a23:	4c 89 fe             	mov    %r15,%rsi
  802a26:	48 b8 af 29 80 00 00 	movabs $0x8029af,%rax
  802a2d:	00 00 00 
  802a30:	ff d0                	call   *%rax
    return dstlen + srclen;
  802a32:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  802a36:	48 83 c4 08          	add    $0x8,%rsp
  802a3a:	5b                   	pop    %rbx
  802a3b:	41 5c                	pop    %r12
  802a3d:	41 5d                	pop    %r13
  802a3f:	41 5e                	pop    %r14
  802a41:	41 5f                	pop    %r15
  802a43:	5d                   	pop    %rbp
  802a44:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  802a45:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  802a49:	eb eb                	jmp    802a36 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  802a4b:	48 83 eb 01          	sub    $0x1,%rbx
  802a4f:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  802a53:	48 89 da             	mov    %rbx,%rdx
  802a56:	4c 89 fe             	mov    %r15,%rsi
  802a59:	48 b8 af 29 80 00 00 	movabs $0x8029af,%rax
  802a60:	00 00 00 
  802a63:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  802a65:	49 01 de             	add    %rbx,%r14
  802a68:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  802a6d:	eb c3                	jmp    802a32 <strlcat+0x6d>

0000000000802a6f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  802a6f:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  802a73:	48 85 d2             	test   %rdx,%rdx
  802a76:	74 2d                	je     802aa5 <memcmp+0x36>
  802a78:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  802a7d:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  802a81:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  802a86:	44 38 c1             	cmp    %r8b,%cl
  802a89:	75 0f                	jne    802a9a <memcmp+0x2b>
    while (n-- > 0) {
  802a8b:	48 83 c0 01          	add    $0x1,%rax
  802a8f:	48 39 c2             	cmp    %rax,%rdx
  802a92:	75 e9                	jne    802a7d <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  802a94:	b8 00 00 00 00       	mov    $0x0,%eax
  802a99:	c3                   	ret
            return (int)*s1 - (int)*s2;
  802a9a:	0f b6 c1             	movzbl %cl,%eax
  802a9d:	45 0f b6 c0          	movzbl %r8b,%r8d
  802aa1:	44 29 c0             	sub    %r8d,%eax
  802aa4:	c3                   	ret
    return 0;
  802aa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aaa:	c3                   	ret

0000000000802aab <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  802aab:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  802aaf:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802ab3:	48 39 c7             	cmp    %rax,%rdi
  802ab6:	73 0f                	jae    802ac7 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802ab8:	40 38 37             	cmp    %sil,(%rdi)
  802abb:	74 0e                	je     802acb <memfind+0x20>
    for (; src < end; src++) {
  802abd:	48 83 c7 01          	add    $0x1,%rdi
  802ac1:	48 39 f8             	cmp    %rdi,%rax
  802ac4:	75 f2                	jne    802ab8 <memfind+0xd>
  802ac6:	c3                   	ret
  802ac7:	48 89 f8             	mov    %rdi,%rax
  802aca:	c3                   	ret
  802acb:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802ace:	c3                   	ret

0000000000802acf <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802acf:	f3 0f 1e fa          	endbr64
  802ad3:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802ad6:	0f b6 37             	movzbl (%rdi),%esi
  802ad9:	40 80 fe 20          	cmp    $0x20,%sil
  802add:	74 06                	je     802ae5 <strtol+0x16>
  802adf:	40 80 fe 09          	cmp    $0x9,%sil
  802ae3:	75 13                	jne    802af8 <strtol+0x29>
  802ae5:	48 83 c7 01          	add    $0x1,%rdi
  802ae9:	0f b6 37             	movzbl (%rdi),%esi
  802aec:	40 80 fe 20          	cmp    $0x20,%sil
  802af0:	74 f3                	je     802ae5 <strtol+0x16>
  802af2:	40 80 fe 09          	cmp    $0x9,%sil
  802af6:	74 ed                	je     802ae5 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802af8:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802afb:	83 e0 fd             	and    $0xfffffffd,%eax
  802afe:	3c 01                	cmp    $0x1,%al
  802b00:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802b04:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  802b0a:	75 0f                	jne    802b1b <strtol+0x4c>
  802b0c:	80 3f 30             	cmpb   $0x30,(%rdi)
  802b0f:	74 14                	je     802b25 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802b11:	85 d2                	test   %edx,%edx
  802b13:	b8 0a 00 00 00       	mov    $0xa,%eax
  802b18:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  802b1b:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  802b20:	4c 63 ca             	movslq %edx,%r9
  802b23:	eb 36                	jmp    802b5b <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802b25:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  802b29:	74 0f                	je     802b3a <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  802b2b:	85 d2                	test   %edx,%edx
  802b2d:	75 ec                	jne    802b1b <strtol+0x4c>
        s++;
  802b2f:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  802b33:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  802b38:	eb e1                	jmp    802b1b <strtol+0x4c>
        s += 2;
  802b3a:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  802b3e:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  802b43:	eb d6                	jmp    802b1b <strtol+0x4c>
            dig -= '0';
  802b45:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  802b48:	44 0f b6 c1          	movzbl %cl,%r8d
  802b4c:	41 39 d0             	cmp    %edx,%r8d
  802b4f:	7d 21                	jge    802b72 <strtol+0xa3>
        val = val * base + dig;
  802b51:	49 0f af c1          	imul   %r9,%rax
  802b55:	0f b6 c9             	movzbl %cl,%ecx
  802b58:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  802b5b:	48 83 c7 01          	add    $0x1,%rdi
  802b5f:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  802b63:	80 f9 39             	cmp    $0x39,%cl
  802b66:	76 dd                	jbe    802b45 <strtol+0x76>
        else if (dig - 'a' < 27)
  802b68:	80 f9 7b             	cmp    $0x7b,%cl
  802b6b:	77 05                	ja     802b72 <strtol+0xa3>
            dig -= 'a' - 10;
  802b6d:	83 e9 57             	sub    $0x57,%ecx
  802b70:	eb d6                	jmp    802b48 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  802b72:	4d 85 d2             	test   %r10,%r10
  802b75:	74 03                	je     802b7a <strtol+0xab>
  802b77:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802b7a:	48 89 c2             	mov    %rax,%rdx
  802b7d:	48 f7 da             	neg    %rdx
  802b80:	40 80 fe 2d          	cmp    $0x2d,%sil
  802b84:	48 0f 44 c2          	cmove  %rdx,%rax
}
  802b88:	c3                   	ret

0000000000802b89 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  802b89:	f3 0f 1e fa          	endbr64
  802b8d:	55                   	push   %rbp
  802b8e:	48 89 e5             	mov    %rsp,%rbp
  802b91:	41 56                	push   %r14
  802b93:	41 55                	push   %r13
  802b95:	41 54                	push   %r12
  802b97:	53                   	push   %rbx
  802b98:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  802b9b:	48 b8 68 70 80 00 00 	movabs $0x807068,%rax
  802ba2:	00 00 00 
  802ba5:	48 83 38 00          	cmpq   $0x0,(%rax)
  802ba9:	74 27                	je     802bd2 <_handle_vectored_pagefault+0x49>
  802bab:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  802bb0:	49 bd 20 70 80 00 00 	movabs $0x807020,%r13
  802bb7:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  802bba:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  802bbd:	4c 89 e7             	mov    %r12,%rdi
  802bc0:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  802bc5:	84 c0                	test   %al,%al
  802bc7:	75 45                	jne    802c0e <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  802bc9:	48 83 c3 01          	add    $0x1,%rbx
  802bcd:	49 3b 1e             	cmp    (%r14),%rbx
  802bd0:	72 eb                	jb     802bbd <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  802bd2:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  802bd9:	00 
  802bda:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  802bdf:	4d 8b 04 24          	mov    (%r12),%r8
  802be3:	48 ba 70 33 80 00 00 	movabs $0x803370,%rdx
  802bea:	00 00 00 
  802bed:	be 1d 00 00 00       	mov    $0x1d,%esi
  802bf2:	48 bf 40 32 80 00 00 	movabs $0x803240,%rdi
  802bf9:	00 00 00 
  802bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  802c01:	49 ba 84 1c 80 00 00 	movabs $0x801c84,%r10
  802c08:	00 00 00 
  802c0b:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  802c0e:	5b                   	pop    %rbx
  802c0f:	41 5c                	pop    %r12
  802c11:	41 5d                	pop    %r13
  802c13:	41 5e                	pop    %r14
  802c15:	5d                   	pop    %rbp
  802c16:	c3                   	ret

0000000000802c17 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  802c17:	f3 0f 1e fa          	endbr64
  802c1b:	55                   	push   %rbp
  802c1c:	48 89 e5             	mov    %rsp,%rbp
  802c1f:	53                   	push   %rbx
  802c20:	48 83 ec 08          	sub    $0x8,%rsp
  802c24:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  802c27:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  802c2e:	00 00 00 
  802c31:	80 38 00             	cmpb   $0x0,(%rax)
  802c34:	0f 84 84 00 00 00    	je     802cbe <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  802c3a:	48 b8 68 70 80 00 00 	movabs $0x807068,%rax
  802c41:	00 00 00 
  802c44:	48 8b 10             	mov    (%rax),%rdx
  802c47:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  802c4c:	48 b9 20 70 80 00 00 	movabs $0x807020,%rcx
  802c53:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  802c56:	48 85 d2             	test   %rdx,%rdx
  802c59:	74 19                	je     802c74 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  802c5b:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  802c5f:	0f 84 e8 00 00 00    	je     802d4d <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  802c65:	48 83 c0 01          	add    $0x1,%rax
  802c69:	48 39 d0             	cmp    %rdx,%rax
  802c6c:	75 ed                	jne    802c5b <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  802c6e:	48 83 fa 08          	cmp    $0x8,%rdx
  802c72:	74 1c                	je     802c90 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  802c74:	48 8d 42 01          	lea    0x1(%rdx),%rax
  802c78:	48 a3 68 70 80 00 00 	movabs %rax,0x807068
  802c7f:	00 00 00 
  802c82:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802c89:	00 00 00 
  802c8c:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802c90:	48 b8 03 02 80 00 00 	movabs $0x800203,%rax
  802c97:	00 00 00 
  802c9a:	ff d0                	call   *%rax
  802c9c:	89 c7                	mov    %eax,%edi
  802c9e:	48 be 97 06 80 00 00 	movabs $0x800697,%rsi
  802ca5:	00 00 00 
  802ca8:	48 b8 58 05 80 00 00 	movabs $0x800558,%rax
  802caf:	00 00 00 
  802cb2:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  802cb4:	85 c0                	test   %eax,%eax
  802cb6:	78 68                	js     802d20 <add_pgfault_handler+0x109>
    return res;
}
  802cb8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802cbc:	c9                   	leave
  802cbd:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  802cbe:	48 b8 03 02 80 00 00 	movabs $0x800203,%rax
  802cc5:	00 00 00 
  802cc8:	ff d0                	call   *%rax
  802cca:	89 c7                	mov    %eax,%edi
  802ccc:	b9 06 00 00 00       	mov    $0x6,%ecx
  802cd1:	ba 00 10 00 00       	mov    $0x1000,%edx
  802cd6:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  802cdd:	00 00 00 
  802ce0:	48 b8 d3 02 80 00 00 	movabs $0x8002d3,%rax
  802ce7:	00 00 00 
  802cea:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  802cec:	48 ba 68 70 80 00 00 	movabs $0x807068,%rdx
  802cf3:	00 00 00 
  802cf6:	48 8b 02             	mov    (%rdx),%rax
  802cf9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802cfd:	48 89 0a             	mov    %rcx,(%rdx)
  802d00:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  802d07:	00 00 00 
  802d0a:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  802d0e:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  802d15:	00 00 00 
  802d18:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  802d1b:	e9 70 ff ff ff       	jmp    802c90 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  802d20:	89 c1                	mov    %eax,%ecx
  802d22:	48 ba 4e 32 80 00 00 	movabs $0x80324e,%rdx
  802d29:	00 00 00 
  802d2c:	be 3d 00 00 00       	mov    $0x3d,%esi
  802d31:	48 bf 40 32 80 00 00 	movabs $0x803240,%rdi
  802d38:	00 00 00 
  802d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d40:	49 b8 84 1c 80 00 00 	movabs $0x801c84,%r8
  802d47:	00 00 00 
  802d4a:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  802d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d52:	e9 61 ff ff ff       	jmp    802cb8 <add_pgfault_handler+0xa1>

0000000000802d57 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  802d57:	f3 0f 1e fa          	endbr64
  802d5b:	55                   	push   %rbp
  802d5c:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  802d5f:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  802d66:	00 00 00 
  802d69:	80 38 00             	cmpb   $0x0,(%rax)
  802d6c:	74 33                	je     802da1 <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  802d6e:	48 a1 68 70 80 00 00 	movabs 0x807068,%rax
  802d75:	00 00 00 
  802d78:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  802d7d:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  802d84:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  802d87:	48 85 c0             	test   %rax,%rax
  802d8a:	0f 84 85 00 00 00    	je     802e15 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  802d90:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  802d94:	74 40                	je     802dd6 <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  802d96:	48 83 c1 01          	add    $0x1,%rcx
  802d9a:	48 39 c1             	cmp    %rax,%rcx
  802d9d:	75 f1                	jne    802d90 <remove_pgfault_handler+0x39>
  802d9f:	eb 74                	jmp    802e15 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  802da1:	48 b9 66 32 80 00 00 	movabs $0x803266,%rcx
  802da8:	00 00 00 
  802dab:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  802db2:	00 00 00 
  802db5:	be 43 00 00 00       	mov    $0x43,%esi
  802dba:	48 bf 40 32 80 00 00 	movabs $0x803240,%rdi
  802dc1:	00 00 00 
  802dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc9:	49 b8 84 1c 80 00 00 	movabs $0x801c84,%r8
  802dd0:	00 00 00 
  802dd3:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  802dd6:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  802ddd:	00 
  802dde:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802de2:	48 29 ca             	sub    %rcx,%rdx
  802de5:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802dec:	00 00 00 
  802def:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  802df3:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  802df8:	48 89 ce             	mov    %rcx,%rsi
  802dfb:	48 b8 44 29 80 00 00 	movabs $0x802944,%rax
  802e02:	00 00 00 
  802e05:	ff d0                	call   *%rax
            _pfhandler_off--;
  802e07:	48 b8 68 70 80 00 00 	movabs $0x807068,%rax
  802e0e:	00 00 00 
  802e11:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  802e15:	5d                   	pop    %rbp
  802e16:	c3                   	ret

0000000000802e17 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802e17:	f3 0f 1e fa          	endbr64
  802e1b:	55                   	push   %rbp
  802e1c:	48 89 e5             	mov    %rsp,%rbp
  802e1f:	41 54                	push   %r12
  802e21:	53                   	push   %rbx
  802e22:	48 89 fb             	mov    %rdi,%rbx
  802e25:	48 89 f7             	mov    %rsi,%rdi
  802e28:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802e2b:	48 85 f6             	test   %rsi,%rsi
  802e2e:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802e35:	00 00 00 
  802e38:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802e3c:	be 00 10 00 00       	mov    $0x1000,%esi
  802e41:	48 b8 f5 05 80 00 00 	movabs $0x8005f5,%rax
  802e48:	00 00 00 
  802e4b:	ff d0                	call   *%rax
    if (res < 0) {
  802e4d:	85 c0                	test   %eax,%eax
  802e4f:	78 45                	js     802e96 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802e51:	48 85 db             	test   %rbx,%rbx
  802e54:	74 12                	je     802e68 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802e56:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802e5d:	00 00 00 
  802e60:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802e66:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802e68:	4d 85 e4             	test   %r12,%r12
  802e6b:	74 14                	je     802e81 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802e6d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802e74:	00 00 00 
  802e77:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802e7d:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802e81:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802e88:	00 00 00 
  802e8b:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802e91:	5b                   	pop    %rbx
  802e92:	41 5c                	pop    %r12
  802e94:	5d                   	pop    %rbp
  802e95:	c3                   	ret
        if (from_env_store != NULL) {
  802e96:	48 85 db             	test   %rbx,%rbx
  802e99:	74 06                	je     802ea1 <ipc_recv+0x8a>
            *from_env_store = 0;
  802e9b:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802ea1:	4d 85 e4             	test   %r12,%r12
  802ea4:	74 eb                	je     802e91 <ipc_recv+0x7a>
            *perm_store = 0;
  802ea6:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802ead:	00 
  802eae:	eb e1                	jmp    802e91 <ipc_recv+0x7a>

0000000000802eb0 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802eb0:	f3 0f 1e fa          	endbr64
  802eb4:	55                   	push   %rbp
  802eb5:	48 89 e5             	mov    %rsp,%rbp
  802eb8:	41 57                	push   %r15
  802eba:	41 56                	push   %r14
  802ebc:	41 55                	push   %r13
  802ebe:	41 54                	push   %r12
  802ec0:	53                   	push   %rbx
  802ec1:	48 83 ec 18          	sub    $0x18,%rsp
  802ec5:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802ec8:	48 89 d3             	mov    %rdx,%rbx
  802ecb:	49 89 cc             	mov    %rcx,%r12
  802ece:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802ed1:	48 85 d2             	test   %rdx,%rdx
  802ed4:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802edb:	00 00 00 
  802ede:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802ee2:	89 f0                	mov    %esi,%eax
  802ee4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802ee8:	48 89 da             	mov    %rbx,%rdx
  802eeb:	48 89 c6             	mov    %rax,%rsi
  802eee:	48 b8 c5 05 80 00 00 	movabs $0x8005c5,%rax
  802ef5:	00 00 00 
  802ef8:	ff d0                	call   *%rax
    while (res < 0) {
  802efa:	85 c0                	test   %eax,%eax
  802efc:	79 65                	jns    802f63 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802efe:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802f01:	75 33                	jne    802f36 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802f03:	49 bf 38 02 80 00 00 	movabs $0x800238,%r15
  802f0a:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802f0d:	49 be c5 05 80 00 00 	movabs $0x8005c5,%r14
  802f14:	00 00 00 
        sys_yield();
  802f17:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802f1a:	45 89 e8             	mov    %r13d,%r8d
  802f1d:	4c 89 e1             	mov    %r12,%rcx
  802f20:	48 89 da             	mov    %rbx,%rdx
  802f23:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802f27:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802f2a:	41 ff d6             	call   *%r14
    while (res < 0) {
  802f2d:	85 c0                	test   %eax,%eax
  802f2f:	79 32                	jns    802f63 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802f31:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802f34:	74 e1                	je     802f17 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802f36:	89 c1                	mov    %eax,%ecx
  802f38:	48 ba 80 32 80 00 00 	movabs $0x803280,%rdx
  802f3f:	00 00 00 
  802f42:	be 42 00 00 00       	mov    $0x42,%esi
  802f47:	48 bf 8b 32 80 00 00 	movabs $0x80328b,%rdi
  802f4e:	00 00 00 
  802f51:	b8 00 00 00 00       	mov    $0x0,%eax
  802f56:	49 b8 84 1c 80 00 00 	movabs $0x801c84,%r8
  802f5d:	00 00 00 
  802f60:	41 ff d0             	call   *%r8
    }
}
  802f63:	48 83 c4 18          	add    $0x18,%rsp
  802f67:	5b                   	pop    %rbx
  802f68:	41 5c                	pop    %r12
  802f6a:	41 5d                	pop    %r13
  802f6c:	41 5e                	pop    %r14
  802f6e:	41 5f                	pop    %r15
  802f70:	5d                   	pop    %rbp
  802f71:	c3                   	ret

0000000000802f72 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802f72:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802f76:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802f7b:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802f82:	00 00 00 
  802f85:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802f89:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802f8d:	48 c1 e2 04          	shl    $0x4,%rdx
  802f91:	48 01 ca             	add    %rcx,%rdx
  802f94:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802f9a:	39 fa                	cmp    %edi,%edx
  802f9c:	74 12                	je     802fb0 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802f9e:	48 83 c0 01          	add    $0x1,%rax
  802fa2:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802fa8:	75 db                	jne    802f85 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802faa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802faf:	c3                   	ret
            return envs[i].env_id;
  802fb0:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802fb4:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802fb8:	48 c1 e2 04          	shl    $0x4,%rdx
  802fbc:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802fc3:	00 00 00 
  802fc6:	48 01 d0             	add    %rdx,%rax
  802fc9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fcf:	c3                   	ret

0000000000802fd0 <__text_end>:
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
