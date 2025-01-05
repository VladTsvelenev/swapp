
obj/user/breakpoint:     file format elf64-x86-64


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
  80001e:	e8 08 00 00 00       	call   80002b <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* program to cause a breakpoint trap */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
    asm volatile("int $3");
  800029:	cc                   	int3
}
  80002a:	c3                   	ret

000000000080002b <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80002b:	f3 0f 1e fa          	endbr64
  80002f:	55                   	push   %rbp
  800030:	48 89 e5             	mov    %rsp,%rbp
  800033:	41 56                	push   %r14
  800035:	41 55                	push   %r13
  800037:	41 54                	push   %r12
  800039:	53                   	push   %rbx
  80003a:	41 89 fd             	mov    %edi,%r13d
  80003d:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800040:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800047:	00 00 00 
  80004a:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800051:	00 00 00 
  800054:	48 39 c2             	cmp    %rax,%rdx
  800057:	73 17                	jae    800070 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800059:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80005c:	49 89 c4             	mov    %rax,%r12
  80005f:	48 83 c3 08          	add    $0x8,%rbx
  800063:	b8 00 00 00 00       	mov    $0x0,%eax
  800068:	ff 53 f8             	call   *-0x8(%rbx)
  80006b:	4c 39 e3             	cmp    %r12,%rbx
  80006e:	72 ef                	jb     80005f <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800070:	48 b8 d9 01 80 00 00 	movabs $0x8001d9,%rax
  800077:	00 00 00 
  80007a:	ff d0                	call   *%rax
  80007c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800081:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800085:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800089:	48 c1 e0 04          	shl    $0x4,%rax
  80008d:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800094:	00 00 00 
  800097:	48 01 d0             	add    %rdx,%rax
  80009a:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000a1:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000a4:	45 85 ed             	test   %r13d,%r13d
  8000a7:	7e 0d                	jle    8000b6 <libmain+0x8b>
  8000a9:	49 8b 06             	mov    (%r14),%rax
  8000ac:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000b3:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000b6:	4c 89 f6             	mov    %r14,%rsi
  8000b9:	44 89 ef             	mov    %r13d,%edi
  8000bc:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000c3:	00 00 00 
  8000c6:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000c8:	48 b8 dd 00 80 00 00 	movabs $0x8000dd,%rax
  8000cf:	00 00 00 
  8000d2:	ff d0                	call   *%rax
#endif
}
  8000d4:	5b                   	pop    %rbx
  8000d5:	41 5c                	pop    %r12
  8000d7:	41 5d                	pop    %r13
  8000d9:	41 5e                	pop    %r14
  8000db:	5d                   	pop    %rbp
  8000dc:	c3                   	ret

00000000008000dd <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000dd:	f3 0f 1e fa          	endbr64
  8000e1:	55                   	push   %rbp
  8000e2:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000e5:	48 b8 af 08 80 00 00 	movabs $0x8008af,%rax
  8000ec:	00 00 00 
  8000ef:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8000f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8000f6:	48 b8 6a 01 80 00 00 	movabs $0x80016a,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	call   *%rax
}
  800102:	5d                   	pop    %rbp
  800103:	c3                   	ret

0000000000800104 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800104:	f3 0f 1e fa          	endbr64
  800108:	55                   	push   %rbp
  800109:	48 89 e5             	mov    %rsp,%rbp
  80010c:	53                   	push   %rbx
  80010d:	48 89 fa             	mov    %rdi,%rdx
  800110:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800113:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800118:	bb 00 00 00 00       	mov    $0x0,%ebx
  80011d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800122:	be 00 00 00 00       	mov    $0x0,%esi
  800127:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80012d:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80012f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800133:	c9                   	leave
  800134:	c3                   	ret

0000000000800135 <sys_cgetc>:

int
sys_cgetc(void) {
  800135:	f3 0f 1e fa          	endbr64
  800139:	55                   	push   %rbp
  80013a:	48 89 e5             	mov    %rsp,%rbp
  80013d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80013e:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800143:	ba 00 00 00 00       	mov    $0x0,%edx
  800148:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80014d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800152:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800157:	be 00 00 00 00       	mov    $0x0,%esi
  80015c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800162:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800164:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800168:	c9                   	leave
  800169:	c3                   	ret

000000000080016a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80016a:	f3 0f 1e fa          	endbr64
  80016e:	55                   	push   %rbp
  80016f:	48 89 e5             	mov    %rsp,%rbp
  800172:	53                   	push   %rbx
  800173:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800177:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80017a:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80017f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800184:	bb 00 00 00 00       	mov    $0x0,%ebx
  800189:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80018e:	be 00 00 00 00       	mov    $0x0,%esi
  800193:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800199:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80019b:	48 85 c0             	test   %rax,%rax
  80019e:	7f 06                	jg     8001a6 <sys_env_destroy+0x3c>
}
  8001a0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001a4:	c9                   	leave
  8001a5:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001a6:	49 89 c0             	mov    %rax,%r8
  8001a9:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001ae:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8001b5:	00 00 00 
  8001b8:	be 26 00 00 00       	mov    $0x26,%esi
  8001bd:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8001c4:	00 00 00 
  8001c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cc:	49 b9 d4 1b 80 00 00 	movabs $0x801bd4,%r9
  8001d3:	00 00 00 
  8001d6:	41 ff d1             	call   *%r9

00000000008001d9 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001d9:	f3 0f 1e fa          	endbr64
  8001dd:	55                   	push   %rbp
  8001de:	48 89 e5             	mov    %rsp,%rbp
  8001e1:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001e2:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ec:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001fb:	be 00 00 00 00       	mov    $0x0,%esi
  800200:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800206:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800208:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80020c:	c9                   	leave
  80020d:	c3                   	ret

000000000080020e <sys_yield>:

void
sys_yield(void) {
  80020e:	f3 0f 1e fa          	endbr64
  800212:	55                   	push   %rbp
  800213:	48 89 e5             	mov    %rsp,%rbp
  800216:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800217:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80021c:	ba 00 00 00 00       	mov    $0x0,%edx
  800221:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800226:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800230:	be 00 00 00 00       	mov    $0x0,%esi
  800235:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80023b:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80023d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800241:	c9                   	leave
  800242:	c3                   	ret

0000000000800243 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  800243:	f3 0f 1e fa          	endbr64
  800247:	55                   	push   %rbp
  800248:	48 89 e5             	mov    %rsp,%rbp
  80024b:	53                   	push   %rbx
  80024c:	48 89 fa             	mov    %rdi,%rdx
  80024f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800252:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800257:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80025e:	00 00 00 
  800261:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800266:	be 00 00 00 00       	mov    $0x0,%esi
  80026b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800271:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800273:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800277:	c9                   	leave
  800278:	c3                   	ret

0000000000800279 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  800279:	f3 0f 1e fa          	endbr64
  80027d:	55                   	push   %rbp
  80027e:	48 89 e5             	mov    %rsp,%rbp
  800281:	53                   	push   %rbx
  800282:	49 89 f8             	mov    %rdi,%r8
  800285:	48 89 d3             	mov    %rdx,%rbx
  800288:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80028b:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800290:	4c 89 c2             	mov    %r8,%rdx
  800293:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800296:	be 00 00 00 00       	mov    $0x0,%esi
  80029b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002a1:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002a3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002a7:	c9                   	leave
  8002a8:	c3                   	ret

00000000008002a9 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002a9:	f3 0f 1e fa          	endbr64
  8002ad:	55                   	push   %rbp
  8002ae:	48 89 e5             	mov    %rsp,%rbp
  8002b1:	53                   	push   %rbx
  8002b2:	48 83 ec 08          	sub    $0x8,%rsp
  8002b6:	89 f8                	mov    %edi,%eax
  8002b8:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002bb:	48 63 f9             	movslq %ecx,%rdi
  8002be:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002c1:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002c6:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002c9:	be 00 00 00 00       	mov    $0x0,%esi
  8002ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002d4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002d6:	48 85 c0             	test   %rax,%rax
  8002d9:	7f 06                	jg     8002e1 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002db:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002df:	c9                   	leave
  8002e0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002e1:	49 89 c0             	mov    %rax,%r8
  8002e4:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002e9:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8002f0:	00 00 00 
  8002f3:	be 26 00 00 00       	mov    $0x26,%esi
  8002f8:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8002ff:	00 00 00 
  800302:	b8 00 00 00 00       	mov    $0x0,%eax
  800307:	49 b9 d4 1b 80 00 00 	movabs $0x801bd4,%r9
  80030e:	00 00 00 
  800311:	41 ff d1             	call   *%r9

0000000000800314 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  800314:	f3 0f 1e fa          	endbr64
  800318:	55                   	push   %rbp
  800319:	48 89 e5             	mov    %rsp,%rbp
  80031c:	53                   	push   %rbx
  80031d:	48 83 ec 08          	sub    $0x8,%rsp
  800321:	89 f8                	mov    %edi,%eax
  800323:	49 89 f2             	mov    %rsi,%r10
  800326:	48 89 cf             	mov    %rcx,%rdi
  800329:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80032c:	48 63 da             	movslq %edx,%rbx
  80032f:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800332:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800337:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80033a:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80033d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80033f:	48 85 c0             	test   %rax,%rax
  800342:	7f 06                	jg     80034a <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  800344:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800348:	c9                   	leave
  800349:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80034a:	49 89 c0             	mov    %rax,%r8
  80034d:	b9 05 00 00 00       	mov    $0x5,%ecx
  800352:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800359:	00 00 00 
  80035c:	be 26 00 00 00       	mov    $0x26,%esi
  800361:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800368:	00 00 00 
  80036b:	b8 00 00 00 00       	mov    $0x0,%eax
  800370:	49 b9 d4 1b 80 00 00 	movabs $0x801bd4,%r9
  800377:	00 00 00 
  80037a:	41 ff d1             	call   *%r9

000000000080037d <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80037d:	f3 0f 1e fa          	endbr64
  800381:	55                   	push   %rbp
  800382:	48 89 e5             	mov    %rsp,%rbp
  800385:	53                   	push   %rbx
  800386:	48 83 ec 08          	sub    $0x8,%rsp
  80038a:	49 89 f9             	mov    %rdi,%r9
  80038d:	89 f0                	mov    %esi,%eax
  80038f:	48 89 d3             	mov    %rdx,%rbx
  800392:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  800395:	49 63 f0             	movslq %r8d,%rsi
  800398:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80039b:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8003a0:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003a9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003ab:	48 85 c0             	test   %rax,%rax
  8003ae:	7f 06                	jg     8003b6 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8003b0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003b4:	c9                   	leave
  8003b5:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003b6:	49 89 c0             	mov    %rax,%r8
  8003b9:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003be:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8003c5:	00 00 00 
  8003c8:	be 26 00 00 00       	mov    $0x26,%esi
  8003cd:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8003d4:	00 00 00 
  8003d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003dc:	49 b9 d4 1b 80 00 00 	movabs $0x801bd4,%r9
  8003e3:	00 00 00 
  8003e6:	41 ff d1             	call   *%r9

00000000008003e9 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8003e9:	f3 0f 1e fa          	endbr64
  8003ed:	55                   	push   %rbp
  8003ee:	48 89 e5             	mov    %rsp,%rbp
  8003f1:	53                   	push   %rbx
  8003f2:	48 83 ec 08          	sub    $0x8,%rsp
  8003f6:	48 89 f1             	mov    %rsi,%rcx
  8003f9:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8003fc:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8003ff:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800404:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800409:	be 00 00 00 00       	mov    $0x0,%esi
  80040e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800414:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800416:	48 85 c0             	test   %rax,%rax
  800419:	7f 06                	jg     800421 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80041b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80041f:	c9                   	leave
  800420:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800421:	49 89 c0             	mov    %rax,%r8
  800424:	b9 07 00 00 00       	mov    $0x7,%ecx
  800429:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800430:	00 00 00 
  800433:	be 26 00 00 00       	mov    $0x26,%esi
  800438:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80043f:	00 00 00 
  800442:	b8 00 00 00 00       	mov    $0x0,%eax
  800447:	49 b9 d4 1b 80 00 00 	movabs $0x801bd4,%r9
  80044e:	00 00 00 
  800451:	41 ff d1             	call   *%r9

0000000000800454 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  800454:	f3 0f 1e fa          	endbr64
  800458:	55                   	push   %rbp
  800459:	48 89 e5             	mov    %rsp,%rbp
  80045c:	53                   	push   %rbx
  80045d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  800461:	48 63 ce             	movslq %esi,%rcx
  800464:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800467:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80046c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800471:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800476:	be 00 00 00 00       	mov    $0x0,%esi
  80047b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800481:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800483:	48 85 c0             	test   %rax,%rax
  800486:	7f 06                	jg     80048e <sys_env_set_status+0x3a>
}
  800488:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80048c:	c9                   	leave
  80048d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80048e:	49 89 c0             	mov    %rax,%r8
  800491:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800496:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80049d:	00 00 00 
  8004a0:	be 26 00 00 00       	mov    $0x26,%esi
  8004a5:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8004ac:	00 00 00 
  8004af:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b4:	49 b9 d4 1b 80 00 00 	movabs $0x801bd4,%r9
  8004bb:	00 00 00 
  8004be:	41 ff d1             	call   *%r9

00000000008004c1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8004c1:	f3 0f 1e fa          	endbr64
  8004c5:	55                   	push   %rbp
  8004c6:	48 89 e5             	mov    %rsp,%rbp
  8004c9:	53                   	push   %rbx
  8004ca:	48 83 ec 08          	sub    $0x8,%rsp
  8004ce:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8004d1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004d4:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004de:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004e3:	be 00 00 00 00       	mov    $0x0,%esi
  8004e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004ee:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004f0:	48 85 c0             	test   %rax,%rax
  8004f3:	7f 06                	jg     8004fb <sys_env_set_trapframe+0x3a>
}
  8004f5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004f9:	c9                   	leave
  8004fa:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004fb:	49 89 c0             	mov    %rax,%r8
  8004fe:	b9 0b 00 00 00       	mov    $0xb,%ecx
  800503:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80050a:	00 00 00 
  80050d:	be 26 00 00 00       	mov    $0x26,%esi
  800512:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800519:	00 00 00 
  80051c:	b8 00 00 00 00       	mov    $0x0,%eax
  800521:	49 b9 d4 1b 80 00 00 	movabs $0x801bd4,%r9
  800528:	00 00 00 
  80052b:	41 ff d1             	call   *%r9

000000000080052e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80052e:	f3 0f 1e fa          	endbr64
  800532:	55                   	push   %rbp
  800533:	48 89 e5             	mov    %rsp,%rbp
  800536:	53                   	push   %rbx
  800537:	48 83 ec 08          	sub    $0x8,%rsp
  80053b:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80053e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800541:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800546:	bb 00 00 00 00       	mov    $0x0,%ebx
  80054b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800550:	be 00 00 00 00       	mov    $0x0,%esi
  800555:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80055b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80055d:	48 85 c0             	test   %rax,%rax
  800560:	7f 06                	jg     800568 <sys_env_set_pgfault_upcall+0x3a>
}
  800562:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800566:	c9                   	leave
  800567:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800568:	49 89 c0             	mov    %rax,%r8
  80056b:	b9 0c 00 00 00       	mov    $0xc,%ecx
  800570:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800577:	00 00 00 
  80057a:	be 26 00 00 00       	mov    $0x26,%esi
  80057f:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800586:	00 00 00 
  800589:	b8 00 00 00 00       	mov    $0x0,%eax
  80058e:	49 b9 d4 1b 80 00 00 	movabs $0x801bd4,%r9
  800595:	00 00 00 
  800598:	41 ff d1             	call   *%r9

000000000080059b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80059b:	f3 0f 1e fa          	endbr64
  80059f:	55                   	push   %rbp
  8005a0:	48 89 e5             	mov    %rsp,%rbp
  8005a3:	53                   	push   %rbx
  8005a4:	89 f8                	mov    %edi,%eax
  8005a6:	49 89 f1             	mov    %rsi,%r9
  8005a9:	48 89 d3             	mov    %rdx,%rbx
  8005ac:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8005af:	49 63 f0             	movslq %r8d,%rsi
  8005b2:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8005b5:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005ba:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005c3:	cd 30                	int    $0x30
}
  8005c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005c9:	c9                   	leave
  8005ca:	c3                   	ret

00000000008005cb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8005cb:	f3 0f 1e fa          	endbr64
  8005cf:	55                   	push   %rbp
  8005d0:	48 89 e5             	mov    %rsp,%rbp
  8005d3:	53                   	push   %rbx
  8005d4:	48 83 ec 08          	sub    $0x8,%rsp
  8005d8:	48 89 fa             	mov    %rdi,%rdx
  8005db:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8005de:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005e8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005ed:	be 00 00 00 00       	mov    $0x0,%esi
  8005f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005f8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8005fa:	48 85 c0             	test   %rax,%rax
  8005fd:	7f 06                	jg     800605 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8005ff:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800603:	c9                   	leave
  800604:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800605:	49 89 c0             	mov    %rax,%r8
  800608:	b9 0f 00 00 00       	mov    $0xf,%ecx
  80060d:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800614:	00 00 00 
  800617:	be 26 00 00 00       	mov    $0x26,%esi
  80061c:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800623:	00 00 00 
  800626:	b8 00 00 00 00       	mov    $0x0,%eax
  80062b:	49 b9 d4 1b 80 00 00 	movabs $0x801bd4,%r9
  800632:	00 00 00 
  800635:	41 ff d1             	call   *%r9

0000000000800638 <sys_gettime>:

int
sys_gettime(void) {
  800638:	f3 0f 1e fa          	endbr64
  80063c:	55                   	push   %rbp
  80063d:	48 89 e5             	mov    %rsp,%rbp
  800640:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800641:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800646:	ba 00 00 00 00       	mov    $0x0,%edx
  80064b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800650:	bb 00 00 00 00       	mov    $0x0,%ebx
  800655:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80065a:	be 00 00 00 00       	mov    $0x0,%esi
  80065f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800665:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  800667:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80066b:	c9                   	leave
  80066c:	c3                   	ret

000000000080066d <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  80066d:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800671:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800678:	ff ff ff 
  80067b:	48 01 f8             	add    %rdi,%rax
  80067e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800682:	c3                   	ret

0000000000800683 <fd2data>:

char *
fd2data(struct Fd *fd) {
  800683:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800687:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80068e:	ff ff ff 
  800691:	48 01 f8             	add    %rdi,%rax
  800694:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  800698:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80069e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006a2:	c3                   	ret

00000000008006a3 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8006a3:	f3 0f 1e fa          	endbr64
  8006a7:	55                   	push   %rbp
  8006a8:	48 89 e5             	mov    %rsp,%rbp
  8006ab:	41 57                	push   %r15
  8006ad:	41 56                	push   %r14
  8006af:	41 55                	push   %r13
  8006b1:	41 54                	push   %r12
  8006b3:	53                   	push   %rbx
  8006b4:	48 83 ec 08          	sub    $0x8,%rsp
  8006b8:	49 89 ff             	mov    %rdi,%r15
  8006bb:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8006c0:	49 bd 02 18 80 00 00 	movabs $0x801802,%r13
  8006c7:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8006ca:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8006d0:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8006d3:	48 89 df             	mov    %rbx,%rdi
  8006d6:	41 ff d5             	call   *%r13
  8006d9:	83 e0 04             	and    $0x4,%eax
  8006dc:	74 17                	je     8006f5 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8006de:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8006e5:	4c 39 f3             	cmp    %r14,%rbx
  8006e8:	75 e6                	jne    8006d0 <fd_alloc+0x2d>
  8006ea:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8006f0:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8006f5:	4d 89 27             	mov    %r12,(%r15)
}
  8006f8:	48 83 c4 08          	add    $0x8,%rsp
  8006fc:	5b                   	pop    %rbx
  8006fd:	41 5c                	pop    %r12
  8006ff:	41 5d                	pop    %r13
  800701:	41 5e                	pop    %r14
  800703:	41 5f                	pop    %r15
  800705:	5d                   	pop    %rbp
  800706:	c3                   	ret

0000000000800707 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  800707:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  80070b:	83 ff 1f             	cmp    $0x1f,%edi
  80070e:	77 39                	ja     800749 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  800710:	55                   	push   %rbp
  800711:	48 89 e5             	mov    %rsp,%rbp
  800714:	41 54                	push   %r12
  800716:	53                   	push   %rbx
  800717:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80071a:	48 63 df             	movslq %edi,%rbx
  80071d:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  800724:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800728:	48 89 df             	mov    %rbx,%rdi
  80072b:	48 b8 02 18 80 00 00 	movabs $0x801802,%rax
  800732:	00 00 00 
  800735:	ff d0                	call   *%rax
  800737:	a8 04                	test   $0x4,%al
  800739:	74 14                	je     80074f <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80073b:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80073f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800744:	5b                   	pop    %rbx
  800745:	41 5c                	pop    %r12
  800747:	5d                   	pop    %rbp
  800748:	c3                   	ret
        return -E_INVAL;
  800749:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80074e:	c3                   	ret
        return -E_INVAL;
  80074f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800754:	eb ee                	jmp    800744 <fd_lookup+0x3d>

0000000000800756 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  800756:	f3 0f 1e fa          	endbr64
  80075a:	55                   	push   %rbp
  80075b:	48 89 e5             	mov    %rsp,%rbp
  80075e:	41 54                	push   %r12
  800760:	53                   	push   %rbx
  800761:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  800764:	48 b8 40 33 80 00 00 	movabs $0x803340,%rax
  80076b:	00 00 00 
  80076e:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  800775:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  800778:	39 3b                	cmp    %edi,(%rbx)
  80077a:	74 47                	je     8007c3 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  80077c:	48 83 c0 08          	add    $0x8,%rax
  800780:	48 8b 18             	mov    (%rax),%rbx
  800783:	48 85 db             	test   %rbx,%rbx
  800786:	75 f0                	jne    800778 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800788:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80078f:	00 00 00 
  800792:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800798:	89 fa                	mov    %edi,%edx
  80079a:	48 bf 78 32 80 00 00 	movabs $0x803278,%rdi
  8007a1:	00 00 00 
  8007a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a9:	48 b9 30 1d 80 00 00 	movabs $0x801d30,%rcx
  8007b0:	00 00 00 
  8007b3:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8007b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8007ba:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8007be:	5b                   	pop    %rbx
  8007bf:	41 5c                	pop    %r12
  8007c1:	5d                   	pop    %rbp
  8007c2:	c3                   	ret
            return 0;
  8007c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c8:	eb f0                	jmp    8007ba <dev_lookup+0x64>

00000000008007ca <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8007ca:	f3 0f 1e fa          	endbr64
  8007ce:	55                   	push   %rbp
  8007cf:	48 89 e5             	mov    %rsp,%rbp
  8007d2:	41 55                	push   %r13
  8007d4:	41 54                	push   %r12
  8007d6:	53                   	push   %rbx
  8007d7:	48 83 ec 18          	sub    $0x18,%rsp
  8007db:	48 89 fb             	mov    %rdi,%rbx
  8007de:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8007e1:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8007e8:	ff ff ff 
  8007eb:	48 01 df             	add    %rbx,%rdi
  8007ee:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8007f2:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8007f6:	48 b8 07 07 80 00 00 	movabs $0x800707,%rax
  8007fd:	00 00 00 
  800800:	ff d0                	call   *%rax
  800802:	41 89 c5             	mov    %eax,%r13d
  800805:	85 c0                	test   %eax,%eax
  800807:	78 06                	js     80080f <fd_close+0x45>
  800809:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  80080d:	74 1a                	je     800829 <fd_close+0x5f>
        return (must_exist ? res : 0);
  80080f:	45 84 e4             	test   %r12b,%r12b
  800812:	b8 00 00 00 00       	mov    $0x0,%eax
  800817:	44 0f 44 e8          	cmove  %eax,%r13d
}
  80081b:	44 89 e8             	mov    %r13d,%eax
  80081e:	48 83 c4 18          	add    $0x18,%rsp
  800822:	5b                   	pop    %rbx
  800823:	41 5c                	pop    %r12
  800825:	41 5d                	pop    %r13
  800827:	5d                   	pop    %rbp
  800828:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800829:	8b 3b                	mov    (%rbx),%edi
  80082b:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80082f:	48 b8 56 07 80 00 00 	movabs $0x800756,%rax
  800836:	00 00 00 
  800839:	ff d0                	call   *%rax
  80083b:	41 89 c5             	mov    %eax,%r13d
  80083e:	85 c0                	test   %eax,%eax
  800840:	78 1b                	js     80085d <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  800842:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800846:	48 8b 40 20          	mov    0x20(%rax),%rax
  80084a:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  800850:	48 85 c0             	test   %rax,%rax
  800853:	74 08                	je     80085d <fd_close+0x93>
  800855:	48 89 df             	mov    %rbx,%rdi
  800858:	ff d0                	call   *%rax
  80085a:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80085d:	ba 00 10 00 00       	mov    $0x1000,%edx
  800862:	48 89 de             	mov    %rbx,%rsi
  800865:	bf 00 00 00 00       	mov    $0x0,%edi
  80086a:	48 b8 e9 03 80 00 00 	movabs $0x8003e9,%rax
  800871:	00 00 00 
  800874:	ff d0                	call   *%rax
    return res;
  800876:	eb a3                	jmp    80081b <fd_close+0x51>

0000000000800878 <close>:

int
close(int fdnum) {
  800878:	f3 0f 1e fa          	endbr64
  80087c:	55                   	push   %rbp
  80087d:	48 89 e5             	mov    %rsp,%rbp
  800880:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  800884:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800888:	48 b8 07 07 80 00 00 	movabs $0x800707,%rax
  80088f:	00 00 00 
  800892:	ff d0                	call   *%rax
    if (res < 0) return res;
  800894:	85 c0                	test   %eax,%eax
  800896:	78 15                	js     8008ad <close+0x35>

    return fd_close(fd, 1);
  800898:	be 01 00 00 00       	mov    $0x1,%esi
  80089d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8008a1:	48 b8 ca 07 80 00 00 	movabs $0x8007ca,%rax
  8008a8:	00 00 00 
  8008ab:	ff d0                	call   *%rax
}
  8008ad:	c9                   	leave
  8008ae:	c3                   	ret

00000000008008af <close_all>:

void
close_all(void) {
  8008af:	f3 0f 1e fa          	endbr64
  8008b3:	55                   	push   %rbp
  8008b4:	48 89 e5             	mov    %rsp,%rbp
  8008b7:	41 54                	push   %r12
  8008b9:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8008ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008bf:	49 bc 78 08 80 00 00 	movabs $0x800878,%r12
  8008c6:	00 00 00 
  8008c9:	89 df                	mov    %ebx,%edi
  8008cb:	41 ff d4             	call   *%r12
  8008ce:	83 c3 01             	add    $0x1,%ebx
  8008d1:	83 fb 20             	cmp    $0x20,%ebx
  8008d4:	75 f3                	jne    8008c9 <close_all+0x1a>
}
  8008d6:	5b                   	pop    %rbx
  8008d7:	41 5c                	pop    %r12
  8008d9:	5d                   	pop    %rbp
  8008da:	c3                   	ret

00000000008008db <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8008db:	f3 0f 1e fa          	endbr64
  8008df:	55                   	push   %rbp
  8008e0:	48 89 e5             	mov    %rsp,%rbp
  8008e3:	41 57                	push   %r15
  8008e5:	41 56                	push   %r14
  8008e7:	41 55                	push   %r13
  8008e9:	41 54                	push   %r12
  8008eb:	53                   	push   %rbx
  8008ec:	48 83 ec 18          	sub    $0x18,%rsp
  8008f0:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8008f3:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8008f7:	48 b8 07 07 80 00 00 	movabs $0x800707,%rax
  8008fe:	00 00 00 
  800901:	ff d0                	call   *%rax
  800903:	89 c3                	mov    %eax,%ebx
  800905:	85 c0                	test   %eax,%eax
  800907:	0f 88 b8 00 00 00    	js     8009c5 <dup+0xea>
    close(newfdnum);
  80090d:	44 89 e7             	mov    %r12d,%edi
  800910:	48 b8 78 08 80 00 00 	movabs $0x800878,%rax
  800917:	00 00 00 
  80091a:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  80091c:	4d 63 ec             	movslq %r12d,%r13
  80091f:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  800926:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  80092a:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  80092e:	4c 89 ff             	mov    %r15,%rdi
  800931:	49 be 83 06 80 00 00 	movabs $0x800683,%r14
  800938:	00 00 00 
  80093b:	41 ff d6             	call   *%r14
  80093e:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  800941:	4c 89 ef             	mov    %r13,%rdi
  800944:	41 ff d6             	call   *%r14
  800947:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  80094a:	48 89 df             	mov    %rbx,%rdi
  80094d:	48 b8 02 18 80 00 00 	movabs $0x801802,%rax
  800954:	00 00 00 
  800957:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  800959:	a8 04                	test   $0x4,%al
  80095b:	74 2b                	je     800988 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  80095d:	41 89 c1             	mov    %eax,%r9d
  800960:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800966:	4c 89 f1             	mov    %r14,%rcx
  800969:	ba 00 00 00 00       	mov    $0x0,%edx
  80096e:	48 89 de             	mov    %rbx,%rsi
  800971:	bf 00 00 00 00       	mov    $0x0,%edi
  800976:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  80097d:	00 00 00 
  800980:	ff d0                	call   *%rax
  800982:	89 c3                	mov    %eax,%ebx
  800984:	85 c0                	test   %eax,%eax
  800986:	78 4e                	js     8009d6 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  800988:	4c 89 ff             	mov    %r15,%rdi
  80098b:	48 b8 02 18 80 00 00 	movabs $0x801802,%rax
  800992:	00 00 00 
  800995:	ff d0                	call   *%rax
  800997:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  80099a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8009a0:	4c 89 e9             	mov    %r13,%rcx
  8009a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a8:	4c 89 fe             	mov    %r15,%rsi
  8009ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8009b0:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  8009b7:	00 00 00 
  8009ba:	ff d0                	call   *%rax
  8009bc:	89 c3                	mov    %eax,%ebx
  8009be:	85 c0                	test   %eax,%eax
  8009c0:	78 14                	js     8009d6 <dup+0xfb>

    return newfdnum;
  8009c2:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8009c5:	89 d8                	mov    %ebx,%eax
  8009c7:	48 83 c4 18          	add    $0x18,%rsp
  8009cb:	5b                   	pop    %rbx
  8009cc:	41 5c                	pop    %r12
  8009ce:	41 5d                	pop    %r13
  8009d0:	41 5e                	pop    %r14
  8009d2:	41 5f                	pop    %r15
  8009d4:	5d                   	pop    %rbp
  8009d5:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8009d6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009db:	4c 89 ee             	mov    %r13,%rsi
  8009de:	bf 00 00 00 00       	mov    $0x0,%edi
  8009e3:	49 bc e9 03 80 00 00 	movabs $0x8003e9,%r12
  8009ea:	00 00 00 
  8009ed:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8009f0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009f5:	4c 89 f6             	mov    %r14,%rsi
  8009f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8009fd:	41 ff d4             	call   *%r12
    return res;
  800a00:	eb c3                	jmp    8009c5 <dup+0xea>

0000000000800a02 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800a02:	f3 0f 1e fa          	endbr64
  800a06:	55                   	push   %rbp
  800a07:	48 89 e5             	mov    %rsp,%rbp
  800a0a:	41 56                	push   %r14
  800a0c:	41 55                	push   %r13
  800a0e:	41 54                	push   %r12
  800a10:	53                   	push   %rbx
  800a11:	48 83 ec 10          	sub    $0x10,%rsp
  800a15:	89 fb                	mov    %edi,%ebx
  800a17:	49 89 f4             	mov    %rsi,%r12
  800a1a:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a1d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800a21:	48 b8 07 07 80 00 00 	movabs $0x800707,%rax
  800a28:	00 00 00 
  800a2b:	ff d0                	call   *%rax
  800a2d:	85 c0                	test   %eax,%eax
  800a2f:	78 4c                	js     800a7d <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a31:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800a35:	41 8b 3e             	mov    (%r14),%edi
  800a38:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800a3c:	48 b8 56 07 80 00 00 	movabs $0x800756,%rax
  800a43:	00 00 00 
  800a46:	ff d0                	call   *%rax
  800a48:	85 c0                	test   %eax,%eax
  800a4a:	78 35                	js     800a81 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a4c:	41 8b 46 08          	mov    0x8(%r14),%eax
  800a50:	83 e0 03             	and    $0x3,%eax
  800a53:	83 f8 01             	cmp    $0x1,%eax
  800a56:	74 2d                	je     800a85 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800a58:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a5c:	48 8b 40 10          	mov    0x10(%rax),%rax
  800a60:	48 85 c0             	test   %rax,%rax
  800a63:	74 56                	je     800abb <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  800a65:	4c 89 ea             	mov    %r13,%rdx
  800a68:	4c 89 e6             	mov    %r12,%rsi
  800a6b:	4c 89 f7             	mov    %r14,%rdi
  800a6e:	ff d0                	call   *%rax
}
  800a70:	48 83 c4 10          	add    $0x10,%rsp
  800a74:	5b                   	pop    %rbx
  800a75:	41 5c                	pop    %r12
  800a77:	41 5d                	pop    %r13
  800a79:	41 5e                	pop    %r14
  800a7b:	5d                   	pop    %rbp
  800a7c:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a7d:	48 98                	cltq
  800a7f:	eb ef                	jmp    800a70 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a81:	48 98                	cltq
  800a83:	eb eb                	jmp    800a70 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800a85:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800a8c:	00 00 00 
  800a8f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800a95:	89 da                	mov    %ebx,%edx
  800a97:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  800a9e:	00 00 00 
  800aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa6:	48 b9 30 1d 80 00 00 	movabs $0x801d30,%rcx
  800aad:	00 00 00 
  800ab0:	ff d1                	call   *%rcx
        return -E_INVAL;
  800ab2:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800ab9:	eb b5                	jmp    800a70 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800abb:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800ac2:	eb ac                	jmp    800a70 <read+0x6e>

0000000000800ac4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800ac4:	f3 0f 1e fa          	endbr64
  800ac8:	55                   	push   %rbp
  800ac9:	48 89 e5             	mov    %rsp,%rbp
  800acc:	41 57                	push   %r15
  800ace:	41 56                	push   %r14
  800ad0:	41 55                	push   %r13
  800ad2:	41 54                	push   %r12
  800ad4:	53                   	push   %rbx
  800ad5:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800ad9:	48 85 d2             	test   %rdx,%rdx
  800adc:	74 54                	je     800b32 <readn+0x6e>
  800ade:	41 89 fd             	mov    %edi,%r13d
  800ae1:	49 89 f6             	mov    %rsi,%r14
  800ae4:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800ae7:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800aec:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800af1:	49 bf 02 0a 80 00 00 	movabs $0x800a02,%r15
  800af8:	00 00 00 
  800afb:	4c 89 e2             	mov    %r12,%rdx
  800afe:	48 29 f2             	sub    %rsi,%rdx
  800b01:	4c 01 f6             	add    %r14,%rsi
  800b04:	44 89 ef             	mov    %r13d,%edi
  800b07:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800b0a:	85 c0                	test   %eax,%eax
  800b0c:	78 20                	js     800b2e <readn+0x6a>
    for (; inc && res < n; res += inc) {
  800b0e:	01 c3                	add    %eax,%ebx
  800b10:	85 c0                	test   %eax,%eax
  800b12:	74 08                	je     800b1c <readn+0x58>
  800b14:	48 63 f3             	movslq %ebx,%rsi
  800b17:	4c 39 e6             	cmp    %r12,%rsi
  800b1a:	72 df                	jb     800afb <readn+0x37>
    }
    return res;
  800b1c:	48 63 c3             	movslq %ebx,%rax
}
  800b1f:	48 83 c4 08          	add    $0x8,%rsp
  800b23:	5b                   	pop    %rbx
  800b24:	41 5c                	pop    %r12
  800b26:	41 5d                	pop    %r13
  800b28:	41 5e                	pop    %r14
  800b2a:	41 5f                	pop    %r15
  800b2c:	5d                   	pop    %rbp
  800b2d:	c3                   	ret
        if (inc < 0) return inc;
  800b2e:	48 98                	cltq
  800b30:	eb ed                	jmp    800b1f <readn+0x5b>
    int inc = 1, res = 0;
  800b32:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b37:	eb e3                	jmp    800b1c <readn+0x58>

0000000000800b39 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800b39:	f3 0f 1e fa          	endbr64
  800b3d:	55                   	push   %rbp
  800b3e:	48 89 e5             	mov    %rsp,%rbp
  800b41:	41 56                	push   %r14
  800b43:	41 55                	push   %r13
  800b45:	41 54                	push   %r12
  800b47:	53                   	push   %rbx
  800b48:	48 83 ec 10          	sub    $0x10,%rsp
  800b4c:	89 fb                	mov    %edi,%ebx
  800b4e:	49 89 f4             	mov    %rsi,%r12
  800b51:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b54:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800b58:	48 b8 07 07 80 00 00 	movabs $0x800707,%rax
  800b5f:	00 00 00 
  800b62:	ff d0                	call   *%rax
  800b64:	85 c0                	test   %eax,%eax
  800b66:	78 47                	js     800baf <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b68:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800b6c:	41 8b 3e             	mov    (%r14),%edi
  800b6f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800b73:	48 b8 56 07 80 00 00 	movabs $0x800756,%rax
  800b7a:	00 00 00 
  800b7d:	ff d0                	call   *%rax
  800b7f:	85 c0                	test   %eax,%eax
  800b81:	78 30                	js     800bb3 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b83:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  800b88:	74 2d                	je     800bb7 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800b8a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b8e:	48 8b 40 18          	mov    0x18(%rax),%rax
  800b92:	48 85 c0             	test   %rax,%rax
  800b95:	74 56                	je     800bed <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  800b97:	4c 89 ea             	mov    %r13,%rdx
  800b9a:	4c 89 e6             	mov    %r12,%rsi
  800b9d:	4c 89 f7             	mov    %r14,%rdi
  800ba0:	ff d0                	call   *%rax
}
  800ba2:	48 83 c4 10          	add    $0x10,%rsp
  800ba6:	5b                   	pop    %rbx
  800ba7:	41 5c                	pop    %r12
  800ba9:	41 5d                	pop    %r13
  800bab:	41 5e                	pop    %r14
  800bad:	5d                   	pop    %rbp
  800bae:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800baf:	48 98                	cltq
  800bb1:	eb ef                	jmp    800ba2 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bb3:	48 98                	cltq
  800bb5:	eb eb                	jmp    800ba2 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800bb7:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bbe:	00 00 00 
  800bc1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800bc7:	89 da                	mov    %ebx,%edx
  800bc9:	48 bf 34 30 80 00 00 	movabs $0x803034,%rdi
  800bd0:	00 00 00 
  800bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd8:	48 b9 30 1d 80 00 00 	movabs $0x801d30,%rcx
  800bdf:	00 00 00 
  800be2:	ff d1                	call   *%rcx
        return -E_INVAL;
  800be4:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800beb:	eb b5                	jmp    800ba2 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800bed:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800bf4:	eb ac                	jmp    800ba2 <write+0x69>

0000000000800bf6 <seek>:

int
seek(int fdnum, off_t offset) {
  800bf6:	f3 0f 1e fa          	endbr64
  800bfa:	55                   	push   %rbp
  800bfb:	48 89 e5             	mov    %rsp,%rbp
  800bfe:	53                   	push   %rbx
  800bff:	48 83 ec 18          	sub    $0x18,%rsp
  800c03:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c05:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c09:	48 b8 07 07 80 00 00 	movabs $0x800707,%rax
  800c10:	00 00 00 
  800c13:	ff d0                	call   *%rax
  800c15:	85 c0                	test   %eax,%eax
  800c17:	78 0c                	js     800c25 <seek+0x2f>

    fd->fd_offset = offset;
  800c19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c1d:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800c20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c25:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c29:	c9                   	leave
  800c2a:	c3                   	ret

0000000000800c2b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800c2b:	f3 0f 1e fa          	endbr64
  800c2f:	55                   	push   %rbp
  800c30:	48 89 e5             	mov    %rsp,%rbp
  800c33:	41 55                	push   %r13
  800c35:	41 54                	push   %r12
  800c37:	53                   	push   %rbx
  800c38:	48 83 ec 18          	sub    $0x18,%rsp
  800c3c:	89 fb                	mov    %edi,%ebx
  800c3e:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c41:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800c45:	48 b8 07 07 80 00 00 	movabs $0x800707,%rax
  800c4c:	00 00 00 
  800c4f:	ff d0                	call   *%rax
  800c51:	85 c0                	test   %eax,%eax
  800c53:	78 38                	js     800c8d <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c55:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  800c59:	41 8b 7d 00          	mov    0x0(%r13),%edi
  800c5d:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800c61:	48 b8 56 07 80 00 00 	movabs $0x800756,%rax
  800c68:	00 00 00 
  800c6b:	ff d0                	call   *%rax
  800c6d:	85 c0                	test   %eax,%eax
  800c6f:	78 1c                	js     800c8d <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c71:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  800c76:	74 20                	je     800c98 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c78:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c7c:	48 8b 40 30          	mov    0x30(%rax),%rax
  800c80:	48 85 c0             	test   %rax,%rax
  800c83:	74 47                	je     800ccc <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  800c85:	44 89 e6             	mov    %r12d,%esi
  800c88:	4c 89 ef             	mov    %r13,%rdi
  800c8b:	ff d0                	call   *%rax
}
  800c8d:	48 83 c4 18          	add    $0x18,%rsp
  800c91:	5b                   	pop    %rbx
  800c92:	41 5c                	pop    %r12
  800c94:	41 5d                	pop    %r13
  800c96:	5d                   	pop    %rbp
  800c97:	c3                   	ret
                thisenv->env_id, fdnum);
  800c98:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800c9f:	00 00 00 
  800ca2:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800ca8:	89 da                	mov    %ebx,%edx
  800caa:	48 bf 98 32 80 00 00 	movabs $0x803298,%rdi
  800cb1:	00 00 00 
  800cb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb9:	48 b9 30 1d 80 00 00 	movabs $0x801d30,%rcx
  800cc0:	00 00 00 
  800cc3:	ff d1                	call   *%rcx
        return -E_INVAL;
  800cc5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cca:	eb c1                	jmp    800c8d <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800ccc:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800cd1:	eb ba                	jmp    800c8d <ftruncate+0x62>

0000000000800cd3 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800cd3:	f3 0f 1e fa          	endbr64
  800cd7:	55                   	push   %rbp
  800cd8:	48 89 e5             	mov    %rsp,%rbp
  800cdb:	41 54                	push   %r12
  800cdd:	53                   	push   %rbx
  800cde:	48 83 ec 10          	sub    $0x10,%rsp
  800ce2:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800ce5:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800ce9:	48 b8 07 07 80 00 00 	movabs $0x800707,%rax
  800cf0:	00 00 00 
  800cf3:	ff d0                	call   *%rax
  800cf5:	85 c0                	test   %eax,%eax
  800cf7:	78 4e                	js     800d47 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800cf9:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  800cfd:	41 8b 3c 24          	mov    (%r12),%edi
  800d01:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800d05:	48 b8 56 07 80 00 00 	movabs $0x800756,%rax
  800d0c:	00 00 00 
  800d0f:	ff d0                	call   *%rax
  800d11:	85 c0                	test   %eax,%eax
  800d13:	78 32                	js     800d47 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800d19:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800d1e:	74 30                	je     800d50 <fstat+0x7d>

    stat->st_name[0] = 0;
  800d20:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800d23:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800d2a:	00 00 00 
    stat->st_isdir = 0;
  800d2d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800d34:	00 00 00 
    stat->st_dev = dev;
  800d37:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800d3e:	48 89 de             	mov    %rbx,%rsi
  800d41:	4c 89 e7             	mov    %r12,%rdi
  800d44:	ff 50 28             	call   *0x28(%rax)
}
  800d47:	48 83 c4 10          	add    $0x10,%rsp
  800d4b:	5b                   	pop    %rbx
  800d4c:	41 5c                	pop    %r12
  800d4e:	5d                   	pop    %rbp
  800d4f:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d50:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800d55:	eb f0                	jmp    800d47 <fstat+0x74>

0000000000800d57 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800d57:	f3 0f 1e fa          	endbr64
  800d5b:	55                   	push   %rbp
  800d5c:	48 89 e5             	mov    %rsp,%rbp
  800d5f:	41 54                	push   %r12
  800d61:	53                   	push   %rbx
  800d62:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800d65:	be 00 00 00 00       	mov    $0x0,%esi
  800d6a:	48 b8 38 10 80 00 00 	movabs $0x801038,%rax
  800d71:	00 00 00 
  800d74:	ff d0                	call   *%rax
  800d76:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	78 25                	js     800da1 <stat+0x4a>

    int res = fstat(fd, stat);
  800d7c:	4c 89 e6             	mov    %r12,%rsi
  800d7f:	89 c7                	mov    %eax,%edi
  800d81:	48 b8 d3 0c 80 00 00 	movabs $0x800cd3,%rax
  800d88:	00 00 00 
  800d8b:	ff d0                	call   *%rax
  800d8d:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800d90:	89 df                	mov    %ebx,%edi
  800d92:	48 b8 78 08 80 00 00 	movabs $0x800878,%rax
  800d99:	00 00 00 
  800d9c:	ff d0                	call   *%rax

    return res;
  800d9e:	44 89 e3             	mov    %r12d,%ebx
}
  800da1:	89 d8                	mov    %ebx,%eax
  800da3:	5b                   	pop    %rbx
  800da4:	41 5c                	pop    %r12
  800da6:	5d                   	pop    %rbp
  800da7:	c3                   	ret

0000000000800da8 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800da8:	f3 0f 1e fa          	endbr64
  800dac:	55                   	push   %rbp
  800dad:	48 89 e5             	mov    %rsp,%rbp
  800db0:	41 54                	push   %r12
  800db2:	53                   	push   %rbx
  800db3:	48 83 ec 10          	sub    $0x10,%rsp
  800db7:	41 89 fc             	mov    %edi,%r12d
  800dba:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800dbd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800dc4:	00 00 00 
  800dc7:	83 38 00             	cmpl   $0x0,(%rax)
  800dca:	74 6e                	je     800e3a <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  800dcc:	bf 03 00 00 00       	mov    $0x3,%edi
  800dd1:	48 b8 34 2c 80 00 00 	movabs $0x802c34,%rax
  800dd8:	00 00 00 
  800ddb:	ff d0                	call   *%rax
  800ddd:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800de4:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800de6:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800dec:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800df1:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800df8:	00 00 00 
  800dfb:	44 89 e6             	mov    %r12d,%esi
  800dfe:	89 c7                	mov    %eax,%edi
  800e00:	48 b8 72 2b 80 00 00 	movabs $0x802b72,%rax
  800e07:	00 00 00 
  800e0a:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800e0c:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800e13:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800e14:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e19:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e1d:	48 89 de             	mov    %rbx,%rsi
  800e20:	bf 00 00 00 00       	mov    $0x0,%edi
  800e25:	48 b8 d9 2a 80 00 00 	movabs $0x802ad9,%rax
  800e2c:	00 00 00 
  800e2f:	ff d0                	call   *%rax
}
  800e31:	48 83 c4 10          	add    $0x10,%rsp
  800e35:	5b                   	pop    %rbx
  800e36:	41 5c                	pop    %r12
  800e38:	5d                   	pop    %rbp
  800e39:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800e3a:	bf 03 00 00 00       	mov    $0x3,%edi
  800e3f:	48 b8 34 2c 80 00 00 	movabs $0x802c34,%rax
  800e46:	00 00 00 
  800e49:	ff d0                	call   *%rax
  800e4b:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e52:	00 00 
  800e54:	e9 73 ff ff ff       	jmp    800dcc <fsipc+0x24>

0000000000800e59 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800e59:	f3 0f 1e fa          	endbr64
  800e5d:	55                   	push   %rbp
  800e5e:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800e61:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e68:	00 00 00 
  800e6b:	8b 57 0c             	mov    0xc(%rdi),%edx
  800e6e:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800e70:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800e73:	be 00 00 00 00       	mov    $0x0,%esi
  800e78:	bf 02 00 00 00       	mov    $0x2,%edi
  800e7d:	48 b8 a8 0d 80 00 00 	movabs $0x800da8,%rax
  800e84:	00 00 00 
  800e87:	ff d0                	call   *%rax
}
  800e89:	5d                   	pop    %rbp
  800e8a:	c3                   	ret

0000000000800e8b <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800e8b:	f3 0f 1e fa          	endbr64
  800e8f:	55                   	push   %rbp
  800e90:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800e93:	8b 47 0c             	mov    0xc(%rdi),%eax
  800e96:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800e9d:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800e9f:	be 00 00 00 00       	mov    $0x0,%esi
  800ea4:	bf 06 00 00 00       	mov    $0x6,%edi
  800ea9:	48 b8 a8 0d 80 00 00 	movabs $0x800da8,%rax
  800eb0:	00 00 00 
  800eb3:	ff d0                	call   *%rax
}
  800eb5:	5d                   	pop    %rbp
  800eb6:	c3                   	ret

0000000000800eb7 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800eb7:	f3 0f 1e fa          	endbr64
  800ebb:	55                   	push   %rbp
  800ebc:	48 89 e5             	mov    %rsp,%rbp
  800ebf:	41 54                	push   %r12
  800ec1:	53                   	push   %rbx
  800ec2:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ec5:	8b 47 0c             	mov    0xc(%rdi),%eax
  800ec8:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ecf:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800ed1:	be 00 00 00 00       	mov    $0x0,%esi
  800ed6:	bf 05 00 00 00       	mov    $0x5,%edi
  800edb:	48 b8 a8 0d 80 00 00 	movabs $0x800da8,%rax
  800ee2:	00 00 00 
  800ee5:	ff d0                	call   *%rax
    if (res < 0) return res;
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	78 3d                	js     800f28 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800eeb:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  800ef2:	00 00 00 
  800ef5:	4c 89 e6             	mov    %r12,%rsi
  800ef8:	48 89 df             	mov    %rbx,%rdi
  800efb:	48 b8 79 26 80 00 00 	movabs $0x802679,%rax
  800f02:	00 00 00 
  800f05:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800f07:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  800f0e:	00 
  800f0f:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800f15:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  800f1c:	00 
  800f1d:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800f23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f28:	5b                   	pop    %rbx
  800f29:	41 5c                	pop    %r12
  800f2b:	5d                   	pop    %rbp
  800f2c:	c3                   	ret

0000000000800f2d <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f2d:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  800f31:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  800f38:	77 41                	ja     800f7b <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f3a:	55                   	push   %rbp
  800f3b:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  800f3e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f45:	00 00 00 
  800f48:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f4b:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  800f4d:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  800f51:	48 8d 78 10          	lea    0x10(%rax),%rdi
  800f55:	48 b8 94 28 80 00 00 	movabs $0x802894,%rax
  800f5c:	00 00 00 
  800f5f:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  800f61:	be 00 00 00 00       	mov    $0x0,%esi
  800f66:	bf 04 00 00 00       	mov    $0x4,%edi
  800f6b:	48 b8 a8 0d 80 00 00 	movabs $0x800da8,%rax
  800f72:	00 00 00 
  800f75:	ff d0                	call   *%rax
  800f77:	48 98                	cltq
}
  800f79:	5d                   	pop    %rbp
  800f7a:	c3                   	ret
        return -E_INVAL;
  800f7b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  800f82:	c3                   	ret

0000000000800f83 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800f83:	f3 0f 1e fa          	endbr64
  800f87:	55                   	push   %rbp
  800f88:	48 89 e5             	mov    %rsp,%rbp
  800f8b:	41 55                	push   %r13
  800f8d:	41 54                	push   %r12
  800f8f:	53                   	push   %rbx
  800f90:	48 83 ec 08          	sub    $0x8,%rsp
  800f94:	49 89 f4             	mov    %rsi,%r12
  800f97:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800f9a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800fa1:	00 00 00 
  800fa4:	8b 57 0c             	mov    0xc(%rdi),%edx
  800fa7:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  800fa9:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  800fad:	be 00 00 00 00       	mov    $0x0,%esi
  800fb2:	bf 03 00 00 00       	mov    $0x3,%edi
  800fb7:	48 b8 a8 0d 80 00 00 	movabs $0x800da8,%rax
  800fbe:	00 00 00 
  800fc1:	ff d0                	call   *%rax
  800fc3:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  800fc6:	4d 85 ed             	test   %r13,%r13
  800fc9:	78 2a                	js     800ff5 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  800fcb:	4c 89 ea             	mov    %r13,%rdx
  800fce:	4c 39 eb             	cmp    %r13,%rbx
  800fd1:	72 30                	jb     801003 <devfile_read+0x80>
  800fd3:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  800fda:	7f 27                	jg     801003 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  800fdc:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800fe3:	00 00 00 
  800fe6:	4c 89 e7             	mov    %r12,%rdi
  800fe9:	48 b8 94 28 80 00 00 	movabs $0x802894,%rax
  800ff0:	00 00 00 
  800ff3:	ff d0                	call   *%rax
}
  800ff5:	4c 89 e8             	mov    %r13,%rax
  800ff8:	48 83 c4 08          	add    $0x8,%rsp
  800ffc:	5b                   	pop    %rbx
  800ffd:	41 5c                	pop    %r12
  800fff:	41 5d                	pop    %r13
  801001:	5d                   	pop    %rbp
  801002:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801003:	48 b9 51 30 80 00 00 	movabs $0x803051,%rcx
  80100a:	00 00 00 
  80100d:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  801014:	00 00 00 
  801017:	be 7b 00 00 00       	mov    $0x7b,%esi
  80101c:	48 bf 83 30 80 00 00 	movabs $0x803083,%rdi
  801023:	00 00 00 
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
  80102b:	49 b8 d4 1b 80 00 00 	movabs $0x801bd4,%r8
  801032:	00 00 00 
  801035:	41 ff d0             	call   *%r8

0000000000801038 <open>:
open(const char *path, int mode) {
  801038:	f3 0f 1e fa          	endbr64
  80103c:	55                   	push   %rbp
  80103d:	48 89 e5             	mov    %rsp,%rbp
  801040:	41 55                	push   %r13
  801042:	41 54                	push   %r12
  801044:	53                   	push   %rbx
  801045:	48 83 ec 18          	sub    $0x18,%rsp
  801049:	49 89 fc             	mov    %rdi,%r12
  80104c:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  80104f:	48 b8 34 26 80 00 00 	movabs $0x802634,%rax
  801056:	00 00 00 
  801059:	ff d0                	call   *%rax
  80105b:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801061:	0f 87 8a 00 00 00    	ja     8010f1 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801067:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80106b:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  801072:	00 00 00 
  801075:	ff d0                	call   *%rax
  801077:	89 c3                	mov    %eax,%ebx
  801079:	85 c0                	test   %eax,%eax
  80107b:	78 50                	js     8010cd <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80107d:	4c 89 e6             	mov    %r12,%rsi
  801080:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801087:	00 00 00 
  80108a:	48 89 df             	mov    %rbx,%rdi
  80108d:	48 b8 79 26 80 00 00 	movabs $0x802679,%rax
  801094:	00 00 00 
  801097:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801099:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8010a0:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8010a4:	bf 01 00 00 00       	mov    $0x1,%edi
  8010a9:	48 b8 a8 0d 80 00 00 	movabs $0x800da8,%rax
  8010b0:	00 00 00 
  8010b3:	ff d0                	call   *%rax
  8010b5:	89 c3                	mov    %eax,%ebx
  8010b7:	85 c0                	test   %eax,%eax
  8010b9:	78 1f                	js     8010da <open+0xa2>
    return fd2num(fd);
  8010bb:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010bf:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  8010c6:	00 00 00 
  8010c9:	ff d0                	call   *%rax
  8010cb:	89 c3                	mov    %eax,%ebx
}
  8010cd:	89 d8                	mov    %ebx,%eax
  8010cf:	48 83 c4 18          	add    $0x18,%rsp
  8010d3:	5b                   	pop    %rbx
  8010d4:	41 5c                	pop    %r12
  8010d6:	41 5d                	pop    %r13
  8010d8:	5d                   	pop    %rbp
  8010d9:	c3                   	ret
        fd_close(fd, 0);
  8010da:	be 00 00 00 00       	mov    $0x0,%esi
  8010df:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010e3:	48 b8 ca 07 80 00 00 	movabs $0x8007ca,%rax
  8010ea:	00 00 00 
  8010ed:	ff d0                	call   *%rax
        return res;
  8010ef:	eb dc                	jmp    8010cd <open+0x95>
        return -E_BAD_PATH;
  8010f1:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8010f6:	eb d5                	jmp    8010cd <open+0x95>

00000000008010f8 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8010f8:	f3 0f 1e fa          	endbr64
  8010fc:	55                   	push   %rbp
  8010fd:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801100:	be 00 00 00 00       	mov    $0x0,%esi
  801105:	bf 08 00 00 00       	mov    $0x8,%edi
  80110a:	48 b8 a8 0d 80 00 00 	movabs $0x800da8,%rax
  801111:	00 00 00 
  801114:	ff d0                	call   *%rax
}
  801116:	5d                   	pop    %rbp
  801117:	c3                   	ret

0000000000801118 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801118:	f3 0f 1e fa          	endbr64
  80111c:	55                   	push   %rbp
  80111d:	48 89 e5             	mov    %rsp,%rbp
  801120:	41 54                	push   %r12
  801122:	53                   	push   %rbx
  801123:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801126:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  80112d:	00 00 00 
  801130:	ff d0                	call   *%rax
  801132:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801135:	48 be 8e 30 80 00 00 	movabs $0x80308e,%rsi
  80113c:	00 00 00 
  80113f:	48 89 df             	mov    %rbx,%rdi
  801142:	48 b8 79 26 80 00 00 	movabs $0x802679,%rax
  801149:	00 00 00 
  80114c:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80114e:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801153:	41 2b 04 24          	sub    (%r12),%eax
  801157:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80115d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801164:	00 00 00 
    stat->st_dev = &devpipe;
  801167:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80116e:	00 00 00 
  801171:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801178:	b8 00 00 00 00       	mov    $0x0,%eax
  80117d:	5b                   	pop    %rbx
  80117e:	41 5c                	pop    %r12
  801180:	5d                   	pop    %rbp
  801181:	c3                   	ret

0000000000801182 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801182:	f3 0f 1e fa          	endbr64
  801186:	55                   	push   %rbp
  801187:	48 89 e5             	mov    %rsp,%rbp
  80118a:	41 54                	push   %r12
  80118c:	53                   	push   %rbx
  80118d:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801190:	ba 00 10 00 00       	mov    $0x1000,%edx
  801195:	48 89 fe             	mov    %rdi,%rsi
  801198:	bf 00 00 00 00       	mov    $0x0,%edi
  80119d:	49 bc e9 03 80 00 00 	movabs $0x8003e9,%r12
  8011a4:	00 00 00 
  8011a7:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8011aa:	48 89 df             	mov    %rbx,%rdi
  8011ad:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  8011b4:	00 00 00 
  8011b7:	ff d0                	call   *%rax
  8011b9:	48 89 c6             	mov    %rax,%rsi
  8011bc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8011c6:	41 ff d4             	call   *%r12
}
  8011c9:	5b                   	pop    %rbx
  8011ca:	41 5c                	pop    %r12
  8011cc:	5d                   	pop    %rbp
  8011cd:	c3                   	ret

00000000008011ce <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8011ce:	f3 0f 1e fa          	endbr64
  8011d2:	55                   	push   %rbp
  8011d3:	48 89 e5             	mov    %rsp,%rbp
  8011d6:	41 57                	push   %r15
  8011d8:	41 56                	push   %r14
  8011da:	41 55                	push   %r13
  8011dc:	41 54                	push   %r12
  8011de:	53                   	push   %rbx
  8011df:	48 83 ec 18          	sub    $0x18,%rsp
  8011e3:	49 89 fc             	mov    %rdi,%r12
  8011e6:	49 89 f5             	mov    %rsi,%r13
  8011e9:	49 89 d7             	mov    %rdx,%r15
  8011ec:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8011f0:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  8011f7:	00 00 00 
  8011fa:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8011fc:	4d 85 ff             	test   %r15,%r15
  8011ff:	0f 84 af 00 00 00    	je     8012b4 <devpipe_write+0xe6>
  801205:	48 89 c3             	mov    %rax,%rbx
  801208:	4c 89 f8             	mov    %r15,%rax
  80120b:	4d 89 ef             	mov    %r13,%r15
  80120e:	4c 01 e8             	add    %r13,%rax
  801211:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801215:	49 bd 79 02 80 00 00 	movabs $0x800279,%r13
  80121c:	00 00 00 
            sys_yield();
  80121f:	49 be 0e 02 80 00 00 	movabs $0x80020e,%r14
  801226:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801229:	8b 73 04             	mov    0x4(%rbx),%esi
  80122c:	48 63 ce             	movslq %esi,%rcx
  80122f:	48 63 03             	movslq (%rbx),%rax
  801232:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801238:	48 39 c1             	cmp    %rax,%rcx
  80123b:	72 2e                	jb     80126b <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80123d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801242:	48 89 da             	mov    %rbx,%rdx
  801245:	be 00 10 00 00       	mov    $0x1000,%esi
  80124a:	4c 89 e7             	mov    %r12,%rdi
  80124d:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801250:	85 c0                	test   %eax,%eax
  801252:	74 66                	je     8012ba <devpipe_write+0xec>
            sys_yield();
  801254:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801257:	8b 73 04             	mov    0x4(%rbx),%esi
  80125a:	48 63 ce             	movslq %esi,%rcx
  80125d:	48 63 03             	movslq (%rbx),%rax
  801260:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801266:	48 39 c1             	cmp    %rax,%rcx
  801269:	73 d2                	jae    80123d <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80126b:	41 0f b6 3f          	movzbl (%r15),%edi
  80126f:	48 89 ca             	mov    %rcx,%rdx
  801272:	48 c1 ea 03          	shr    $0x3,%rdx
  801276:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80127d:	08 10 20 
  801280:	48 f7 e2             	mul    %rdx
  801283:	48 c1 ea 06          	shr    $0x6,%rdx
  801287:	48 89 d0             	mov    %rdx,%rax
  80128a:	48 c1 e0 09          	shl    $0x9,%rax
  80128e:	48 29 d0             	sub    %rdx,%rax
  801291:	48 c1 e0 03          	shl    $0x3,%rax
  801295:	48 29 c1             	sub    %rax,%rcx
  801298:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80129d:	83 c6 01             	add    $0x1,%esi
  8012a0:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012a3:	49 83 c7 01          	add    $0x1,%r15
  8012a7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012ab:	49 39 c7             	cmp    %rax,%r15
  8012ae:	0f 85 75 ff ff ff    	jne    801229 <devpipe_write+0x5b>
    return n;
  8012b4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8012b8:	eb 05                	jmp    8012bf <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8012ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012bf:	48 83 c4 18          	add    $0x18,%rsp
  8012c3:	5b                   	pop    %rbx
  8012c4:	41 5c                	pop    %r12
  8012c6:	41 5d                	pop    %r13
  8012c8:	41 5e                	pop    %r14
  8012ca:	41 5f                	pop    %r15
  8012cc:	5d                   	pop    %rbp
  8012cd:	c3                   	ret

00000000008012ce <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8012ce:	f3 0f 1e fa          	endbr64
  8012d2:	55                   	push   %rbp
  8012d3:	48 89 e5             	mov    %rsp,%rbp
  8012d6:	41 57                	push   %r15
  8012d8:	41 56                	push   %r14
  8012da:	41 55                	push   %r13
  8012dc:	41 54                	push   %r12
  8012de:	53                   	push   %rbx
  8012df:	48 83 ec 18          	sub    $0x18,%rsp
  8012e3:	49 89 fc             	mov    %rdi,%r12
  8012e6:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8012ea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8012ee:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  8012f5:	00 00 00 
  8012f8:	ff d0                	call   *%rax
  8012fa:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8012fd:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801303:	49 bd 79 02 80 00 00 	movabs $0x800279,%r13
  80130a:	00 00 00 
            sys_yield();
  80130d:	49 be 0e 02 80 00 00 	movabs $0x80020e,%r14
  801314:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801317:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80131c:	74 7d                	je     80139b <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80131e:	8b 03                	mov    (%rbx),%eax
  801320:	3b 43 04             	cmp    0x4(%rbx),%eax
  801323:	75 26                	jne    80134b <devpipe_read+0x7d>
            if (i > 0) return i;
  801325:	4d 85 ff             	test   %r15,%r15
  801328:	75 77                	jne    8013a1 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80132a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80132f:	48 89 da             	mov    %rbx,%rdx
  801332:	be 00 10 00 00       	mov    $0x1000,%esi
  801337:	4c 89 e7             	mov    %r12,%rdi
  80133a:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80133d:	85 c0                	test   %eax,%eax
  80133f:	74 72                	je     8013b3 <devpipe_read+0xe5>
            sys_yield();
  801341:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801344:	8b 03                	mov    (%rbx),%eax
  801346:	3b 43 04             	cmp    0x4(%rbx),%eax
  801349:	74 df                	je     80132a <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80134b:	48 63 c8             	movslq %eax,%rcx
  80134e:	48 89 ca             	mov    %rcx,%rdx
  801351:	48 c1 ea 03          	shr    $0x3,%rdx
  801355:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  80135c:	08 10 20 
  80135f:	48 89 d0             	mov    %rdx,%rax
  801362:	48 f7 e6             	mul    %rsi
  801365:	48 c1 ea 06          	shr    $0x6,%rdx
  801369:	48 89 d0             	mov    %rdx,%rax
  80136c:	48 c1 e0 09          	shl    $0x9,%rax
  801370:	48 29 d0             	sub    %rdx,%rax
  801373:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80137a:	00 
  80137b:	48 89 c8             	mov    %rcx,%rax
  80137e:	48 29 d0             	sub    %rdx,%rax
  801381:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  801386:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80138a:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80138e:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  801391:	49 83 c7 01          	add    $0x1,%r15
  801395:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  801399:	75 83                	jne    80131e <devpipe_read+0x50>
    return n;
  80139b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80139f:	eb 03                	jmp    8013a4 <devpipe_read+0xd6>
            if (i > 0) return i;
  8013a1:	4c 89 f8             	mov    %r15,%rax
}
  8013a4:	48 83 c4 18          	add    $0x18,%rsp
  8013a8:	5b                   	pop    %rbx
  8013a9:	41 5c                	pop    %r12
  8013ab:	41 5d                	pop    %r13
  8013ad:	41 5e                	pop    %r14
  8013af:	41 5f                	pop    %r15
  8013b1:	5d                   	pop    %rbp
  8013b2:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8013b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b8:	eb ea                	jmp    8013a4 <devpipe_read+0xd6>

00000000008013ba <pipe>:
pipe(int pfd[2]) {
  8013ba:	f3 0f 1e fa          	endbr64
  8013be:	55                   	push   %rbp
  8013bf:	48 89 e5             	mov    %rsp,%rbp
  8013c2:	41 55                	push   %r13
  8013c4:	41 54                	push   %r12
  8013c6:	53                   	push   %rbx
  8013c7:	48 83 ec 18          	sub    $0x18,%rsp
  8013cb:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8013ce:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8013d2:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  8013d9:	00 00 00 
  8013dc:	ff d0                	call   *%rax
  8013de:	89 c3                	mov    %eax,%ebx
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	0f 88 a0 01 00 00    	js     801588 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8013e8:	b9 46 00 00 00       	mov    $0x46,%ecx
  8013ed:	ba 00 10 00 00       	mov    $0x1000,%edx
  8013f2:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8013f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8013fb:	48 b8 a9 02 80 00 00 	movabs $0x8002a9,%rax
  801402:	00 00 00 
  801405:	ff d0                	call   *%rax
  801407:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801409:	85 c0                	test   %eax,%eax
  80140b:	0f 88 77 01 00 00    	js     801588 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  801411:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  801415:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  80141c:	00 00 00 
  80141f:	ff d0                	call   *%rax
  801421:	89 c3                	mov    %eax,%ebx
  801423:	85 c0                	test   %eax,%eax
  801425:	0f 88 43 01 00 00    	js     80156e <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80142b:	b9 46 00 00 00       	mov    $0x46,%ecx
  801430:	ba 00 10 00 00       	mov    $0x1000,%edx
  801435:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801439:	bf 00 00 00 00       	mov    $0x0,%edi
  80143e:	48 b8 a9 02 80 00 00 	movabs $0x8002a9,%rax
  801445:	00 00 00 
  801448:	ff d0                	call   *%rax
  80144a:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80144c:	85 c0                	test   %eax,%eax
  80144e:	0f 88 1a 01 00 00    	js     80156e <pipe+0x1b4>
    va = fd2data(fd0);
  801454:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801458:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  80145f:	00 00 00 
  801462:	ff d0                	call   *%rax
  801464:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801467:	b9 46 00 00 00       	mov    $0x46,%ecx
  80146c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801471:	48 89 c6             	mov    %rax,%rsi
  801474:	bf 00 00 00 00       	mov    $0x0,%edi
  801479:	48 b8 a9 02 80 00 00 	movabs $0x8002a9,%rax
  801480:	00 00 00 
  801483:	ff d0                	call   *%rax
  801485:	89 c3                	mov    %eax,%ebx
  801487:	85 c0                	test   %eax,%eax
  801489:	0f 88 c5 00 00 00    	js     801554 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80148f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801493:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  80149a:	00 00 00 
  80149d:	ff d0                	call   *%rax
  80149f:	48 89 c1             	mov    %rax,%rcx
  8014a2:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8014a8:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8014ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b3:	4c 89 ee             	mov    %r13,%rsi
  8014b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8014bb:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  8014c2:	00 00 00 
  8014c5:	ff d0                	call   *%rax
  8014c7:	89 c3                	mov    %eax,%ebx
  8014c9:	85 c0                	test   %eax,%eax
  8014cb:	78 6e                	js     80153b <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014cd:	be 00 10 00 00       	mov    $0x1000,%esi
  8014d2:	4c 89 ef             	mov    %r13,%rdi
  8014d5:	48 b8 43 02 80 00 00 	movabs $0x800243,%rax
  8014dc:	00 00 00 
  8014df:	ff d0                	call   *%rax
  8014e1:	83 f8 02             	cmp    $0x2,%eax
  8014e4:	0f 85 ab 00 00 00    	jne    801595 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8014ea:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8014f1:	00 00 
  8014f3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014f7:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8014f9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014fd:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  801504:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801508:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80150a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80150e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  801515:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801519:	48 bb 6d 06 80 00 00 	movabs $0x80066d,%rbx
  801520:	00 00 00 
  801523:	ff d3                	call   *%rbx
  801525:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801529:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80152d:	ff d3                	call   *%rbx
  80152f:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  801534:	bb 00 00 00 00       	mov    $0x0,%ebx
  801539:	eb 4d                	jmp    801588 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  80153b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801540:	4c 89 ee             	mov    %r13,%rsi
  801543:	bf 00 00 00 00       	mov    $0x0,%edi
  801548:	48 b8 e9 03 80 00 00 	movabs $0x8003e9,%rax
  80154f:	00 00 00 
  801552:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  801554:	ba 00 10 00 00       	mov    $0x1000,%edx
  801559:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80155d:	bf 00 00 00 00       	mov    $0x0,%edi
  801562:	48 b8 e9 03 80 00 00 	movabs $0x8003e9,%rax
  801569:	00 00 00 
  80156c:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80156e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801573:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801577:	bf 00 00 00 00       	mov    $0x0,%edi
  80157c:	48 b8 e9 03 80 00 00 	movabs $0x8003e9,%rax
  801583:	00 00 00 
  801586:	ff d0                	call   *%rax
}
  801588:	89 d8                	mov    %ebx,%eax
  80158a:	48 83 c4 18          	add    $0x18,%rsp
  80158e:	5b                   	pop    %rbx
  80158f:	41 5c                	pop    %r12
  801591:	41 5d                	pop    %r13
  801593:	5d                   	pop    %rbp
  801594:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  801595:	48 b9 c0 32 80 00 00 	movabs $0x8032c0,%rcx
  80159c:	00 00 00 
  80159f:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  8015a6:	00 00 00 
  8015a9:	be 2e 00 00 00       	mov    $0x2e,%esi
  8015ae:	48 bf 95 30 80 00 00 	movabs $0x803095,%rdi
  8015b5:	00 00 00 
  8015b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bd:	49 b8 d4 1b 80 00 00 	movabs $0x801bd4,%r8
  8015c4:	00 00 00 
  8015c7:	41 ff d0             	call   *%r8

00000000008015ca <pipeisclosed>:
pipeisclosed(int fdnum) {
  8015ca:	f3 0f 1e fa          	endbr64
  8015ce:	55                   	push   %rbp
  8015cf:	48 89 e5             	mov    %rsp,%rbp
  8015d2:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8015d6:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8015da:	48 b8 07 07 80 00 00 	movabs $0x800707,%rax
  8015e1:	00 00 00 
  8015e4:	ff d0                	call   *%rax
    if (res < 0) return res;
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	78 35                	js     80161f <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8015ea:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8015ee:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  8015f5:	00 00 00 
  8015f8:	ff d0                	call   *%rax
  8015fa:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8015fd:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801602:	be 00 10 00 00       	mov    $0x1000,%esi
  801607:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80160b:	48 b8 79 02 80 00 00 	movabs $0x800279,%rax
  801612:	00 00 00 
  801615:	ff d0                	call   *%rax
  801617:	85 c0                	test   %eax,%eax
  801619:	0f 94 c0             	sete   %al
  80161c:	0f b6 c0             	movzbl %al,%eax
}
  80161f:	c9                   	leave
  801620:	c3                   	ret

0000000000801621 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  801621:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801625:	48 89 f8             	mov    %rdi,%rax
  801628:	48 c1 e8 27          	shr    $0x27,%rax
  80162c:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  801633:	7f 00 00 
  801636:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80163a:	f6 c2 01             	test   $0x1,%dl
  80163d:	74 6d                	je     8016ac <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80163f:	48 89 f8             	mov    %rdi,%rax
  801642:	48 c1 e8 1e          	shr    $0x1e,%rax
  801646:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80164d:	7f 00 00 
  801650:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801654:	f6 c2 01             	test   $0x1,%dl
  801657:	74 62                	je     8016bb <get_uvpt_entry+0x9a>
  801659:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801660:	7f 00 00 
  801663:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801667:	f6 c2 80             	test   $0x80,%dl
  80166a:	75 4f                	jne    8016bb <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80166c:	48 89 f8             	mov    %rdi,%rax
  80166f:	48 c1 e8 15          	shr    $0x15,%rax
  801673:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80167a:	7f 00 00 
  80167d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801681:	f6 c2 01             	test   $0x1,%dl
  801684:	74 44                	je     8016ca <get_uvpt_entry+0xa9>
  801686:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80168d:	7f 00 00 
  801690:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801694:	f6 c2 80             	test   $0x80,%dl
  801697:	75 31                	jne    8016ca <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  801699:	48 c1 ef 0c          	shr    $0xc,%rdi
  80169d:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8016a4:	7f 00 00 
  8016a7:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8016ab:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8016ac:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8016b3:	7f 00 00 
  8016b6:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016ba:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8016bb:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8016c2:	7f 00 00 
  8016c5:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016c9:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8016ca:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016d1:	7f 00 00 
  8016d4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016d8:	c3                   	ret

00000000008016d9 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8016d9:	f3 0f 1e fa          	endbr64
  8016dd:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8016e0:	48 89 f9             	mov    %rdi,%rcx
  8016e3:	48 c1 e9 27          	shr    $0x27,%rcx
  8016e7:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8016ee:	7f 00 00 
  8016f1:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8016f5:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8016fc:	f6 c1 01             	test   $0x1,%cl
  8016ff:	0f 84 b2 00 00 00    	je     8017b7 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  801705:	48 89 f9             	mov    %rdi,%rcx
  801708:	48 c1 e9 1e          	shr    $0x1e,%rcx
  80170c:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801713:	7f 00 00 
  801716:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80171a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  801721:	40 f6 c6 01          	test   $0x1,%sil
  801725:	0f 84 8c 00 00 00    	je     8017b7 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  80172b:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801732:	7f 00 00 
  801735:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801739:	a8 80                	test   $0x80,%al
  80173b:	75 7b                	jne    8017b8 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  80173d:	48 89 f9             	mov    %rdi,%rcx
  801740:	48 c1 e9 15          	shr    $0x15,%rcx
  801744:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80174b:	7f 00 00 
  80174e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801752:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  801759:	40 f6 c6 01          	test   $0x1,%sil
  80175d:	74 58                	je     8017b7 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  80175f:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801766:	7f 00 00 
  801769:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80176d:	a8 80                	test   $0x80,%al
  80176f:	75 6c                	jne    8017dd <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  801771:	48 89 f9             	mov    %rdi,%rcx
  801774:	48 c1 e9 0c          	shr    $0xc,%rcx
  801778:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80177f:	7f 00 00 
  801782:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801786:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  80178d:	40 f6 c6 01          	test   $0x1,%sil
  801791:	74 24                	je     8017b7 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  801793:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80179a:	7f 00 00 
  80179d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017a1:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017a8:	ff ff 7f 
  8017ab:	48 21 c8             	and    %rcx,%rax
  8017ae:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8017b4:	48 09 d0             	or     %rdx,%rax
}
  8017b7:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8017b8:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8017bf:	7f 00 00 
  8017c2:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017c6:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017cd:	ff ff 7f 
  8017d0:	48 21 c8             	and    %rcx,%rax
  8017d3:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8017d9:	48 01 d0             	add    %rdx,%rax
  8017dc:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8017dd:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8017e4:	7f 00 00 
  8017e7:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017eb:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017f2:	ff ff 7f 
  8017f5:	48 21 c8             	and    %rcx,%rax
  8017f8:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8017fe:	48 01 d0             	add    %rdx,%rax
  801801:	c3                   	ret

0000000000801802 <get_prot>:

int
get_prot(void *va) {
  801802:	f3 0f 1e fa          	endbr64
  801806:	55                   	push   %rbp
  801807:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80180a:	48 b8 21 16 80 00 00 	movabs $0x801621,%rax
  801811:	00 00 00 
  801814:	ff d0                	call   *%rax
  801816:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  801819:	83 e0 01             	and    $0x1,%eax
  80181c:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80181f:	89 d1                	mov    %edx,%ecx
  801821:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  801827:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  801829:	89 c1                	mov    %eax,%ecx
  80182b:	83 c9 02             	or     $0x2,%ecx
  80182e:	f6 c2 02             	test   $0x2,%dl
  801831:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  801834:	89 c1                	mov    %eax,%ecx
  801836:	83 c9 01             	or     $0x1,%ecx
  801839:	48 85 d2             	test   %rdx,%rdx
  80183c:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80183f:	89 c1                	mov    %eax,%ecx
  801841:	83 c9 40             	or     $0x40,%ecx
  801844:	f6 c6 04             	test   $0x4,%dh
  801847:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80184a:	5d                   	pop    %rbp
  80184b:	c3                   	ret

000000000080184c <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80184c:	f3 0f 1e fa          	endbr64
  801850:	55                   	push   %rbp
  801851:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801854:	48 b8 21 16 80 00 00 	movabs $0x801621,%rax
  80185b:	00 00 00 
  80185e:	ff d0                	call   *%rax
    return pte & PTE_D;
  801860:	48 c1 e8 06          	shr    $0x6,%rax
  801864:	83 e0 01             	and    $0x1,%eax
}
  801867:	5d                   	pop    %rbp
  801868:	c3                   	ret

0000000000801869 <is_page_present>:

bool
is_page_present(void *va) {
  801869:	f3 0f 1e fa          	endbr64
  80186d:	55                   	push   %rbp
  80186e:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  801871:	48 b8 21 16 80 00 00 	movabs $0x801621,%rax
  801878:	00 00 00 
  80187b:	ff d0                	call   *%rax
  80187d:	83 e0 01             	and    $0x1,%eax
}
  801880:	5d                   	pop    %rbp
  801881:	c3                   	ret

0000000000801882 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801882:	f3 0f 1e fa          	endbr64
  801886:	55                   	push   %rbp
  801887:	48 89 e5             	mov    %rsp,%rbp
  80188a:	41 57                	push   %r15
  80188c:	41 56                	push   %r14
  80188e:	41 55                	push   %r13
  801890:	41 54                	push   %r12
  801892:	53                   	push   %rbx
  801893:	48 83 ec 18          	sub    $0x18,%rsp
  801897:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80189b:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  80189f:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8018a4:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8018ab:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8018ae:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8018b5:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8018b8:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8018bf:	00 00 00 
  8018c2:	eb 73                	jmp    801937 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018c4:	48 89 d8             	mov    %rbx,%rax
  8018c7:	48 c1 e8 15          	shr    $0x15,%rax
  8018cb:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8018d2:	7f 00 00 
  8018d5:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8018d9:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018df:	f6 c2 01             	test   $0x1,%dl
  8018e2:	74 4b                	je     80192f <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8018e4:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8018e8:	f6 c2 80             	test   $0x80,%dl
  8018eb:	74 11                	je     8018fe <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8018ed:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8018f1:	f6 c4 04             	test   $0x4,%ah
  8018f4:	74 39                	je     80192f <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8018f6:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  8018fc:	eb 20                	jmp    80191e <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8018fe:	48 89 da             	mov    %rbx,%rdx
  801901:	48 c1 ea 0c          	shr    $0xc,%rdx
  801905:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80190c:	7f 00 00 
  80190f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  801913:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801919:	f6 c4 04             	test   $0x4,%ah
  80191c:	74 11                	je     80192f <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  80191e:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  801922:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801926:	48 89 df             	mov    %rbx,%rdi
  801929:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80192d:	ff d0                	call   *%rax
    next:
        va += size;
  80192f:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  801932:	49 39 df             	cmp    %rbx,%r15
  801935:	72 3e                	jb     801975 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  801937:	49 8b 06             	mov    (%r14),%rax
  80193a:	a8 01                	test   $0x1,%al
  80193c:	74 37                	je     801975 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80193e:	48 89 d8             	mov    %rbx,%rax
  801941:	48 c1 e8 1e          	shr    $0x1e,%rax
  801945:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  80194a:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801950:	f6 c2 01             	test   $0x1,%dl
  801953:	74 da                	je     80192f <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  801955:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  80195a:	f6 c2 80             	test   $0x80,%dl
  80195d:	0f 84 61 ff ff ff    	je     8018c4 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  801963:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  801968:	f6 c4 04             	test   $0x4,%ah
  80196b:	74 c2                	je     80192f <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  80196d:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  801973:	eb a9                	jmp    80191e <foreach_shared_region+0x9c>
    }
    return res;
}
  801975:	b8 00 00 00 00       	mov    $0x0,%eax
  80197a:	48 83 c4 18          	add    $0x18,%rsp
  80197e:	5b                   	pop    %rbx
  80197f:	41 5c                	pop    %r12
  801981:	41 5d                	pop    %r13
  801983:	41 5e                	pop    %r14
  801985:	41 5f                	pop    %r15
  801987:	5d                   	pop    %rbp
  801988:	c3                   	ret

0000000000801989 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  801989:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  80198d:	b8 00 00 00 00       	mov    $0x0,%eax
  801992:	c3                   	ret

0000000000801993 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  801993:	f3 0f 1e fa          	endbr64
  801997:	55                   	push   %rbp
  801998:	48 89 e5             	mov    %rsp,%rbp
  80199b:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80199e:	48 be a5 30 80 00 00 	movabs $0x8030a5,%rsi
  8019a5:	00 00 00 
  8019a8:	48 b8 79 26 80 00 00 	movabs $0x802679,%rax
  8019af:	00 00 00 
  8019b2:	ff d0                	call   *%rax
    return 0;
}
  8019b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b9:	5d                   	pop    %rbp
  8019ba:	c3                   	ret

00000000008019bb <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8019bb:	f3 0f 1e fa          	endbr64
  8019bf:	55                   	push   %rbp
  8019c0:	48 89 e5             	mov    %rsp,%rbp
  8019c3:	41 57                	push   %r15
  8019c5:	41 56                	push   %r14
  8019c7:	41 55                	push   %r13
  8019c9:	41 54                	push   %r12
  8019cb:	53                   	push   %rbx
  8019cc:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8019d3:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8019da:	48 85 d2             	test   %rdx,%rdx
  8019dd:	74 7a                	je     801a59 <devcons_write+0x9e>
  8019df:	49 89 d6             	mov    %rdx,%r14
  8019e2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8019e8:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8019ed:	49 bf 94 28 80 00 00 	movabs $0x802894,%r15
  8019f4:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8019f7:	4c 89 f3             	mov    %r14,%rbx
  8019fa:	48 29 f3             	sub    %rsi,%rbx
  8019fd:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a02:	48 39 c3             	cmp    %rax,%rbx
  801a05:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801a09:	4c 63 eb             	movslq %ebx,%r13
  801a0c:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801a13:	48 01 c6             	add    %rax,%rsi
  801a16:	4c 89 ea             	mov    %r13,%rdx
  801a19:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a20:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  801a23:	4c 89 ee             	mov    %r13,%rsi
  801a26:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a2d:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  801a34:	00 00 00 
  801a37:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801a39:	41 01 dc             	add    %ebx,%r12d
  801a3c:	49 63 f4             	movslq %r12d,%rsi
  801a3f:	4c 39 f6             	cmp    %r14,%rsi
  801a42:	72 b3                	jb     8019f7 <devcons_write+0x3c>
    return res;
  801a44:	49 63 c4             	movslq %r12d,%rax
}
  801a47:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801a4e:	5b                   	pop    %rbx
  801a4f:	41 5c                	pop    %r12
  801a51:	41 5d                	pop    %r13
  801a53:	41 5e                	pop    %r14
  801a55:	41 5f                	pop    %r15
  801a57:	5d                   	pop    %rbp
  801a58:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  801a59:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a5f:	eb e3                	jmp    801a44 <devcons_write+0x89>

0000000000801a61 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a61:	f3 0f 1e fa          	endbr64
  801a65:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801a68:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6d:	48 85 c0             	test   %rax,%rax
  801a70:	74 55                	je     801ac7 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a72:	55                   	push   %rbp
  801a73:	48 89 e5             	mov    %rsp,%rbp
  801a76:	41 55                	push   %r13
  801a78:	41 54                	push   %r12
  801a7a:	53                   	push   %rbx
  801a7b:	48 83 ec 08          	sub    $0x8,%rsp
  801a7f:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801a82:	48 bb 35 01 80 00 00 	movabs $0x800135,%rbx
  801a89:	00 00 00 
  801a8c:	49 bc 0e 02 80 00 00 	movabs $0x80020e,%r12
  801a93:	00 00 00 
  801a96:	eb 03                	jmp    801a9b <devcons_read+0x3a>
  801a98:	41 ff d4             	call   *%r12
  801a9b:	ff d3                	call   *%rbx
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	74 f7                	je     801a98 <devcons_read+0x37>
    if (c < 0) return c;
  801aa1:	48 63 d0             	movslq %eax,%rdx
  801aa4:	78 13                	js     801ab9 <devcons_read+0x58>
    if (c == 0x04) return 0;
  801aa6:	ba 00 00 00 00       	mov    $0x0,%edx
  801aab:	83 f8 04             	cmp    $0x4,%eax
  801aae:	74 09                	je     801ab9 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  801ab0:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801ab4:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801ab9:	48 89 d0             	mov    %rdx,%rax
  801abc:	48 83 c4 08          	add    $0x8,%rsp
  801ac0:	5b                   	pop    %rbx
  801ac1:	41 5c                	pop    %r12
  801ac3:	41 5d                	pop    %r13
  801ac5:	5d                   	pop    %rbp
  801ac6:	c3                   	ret
  801ac7:	48 89 d0             	mov    %rdx,%rax
  801aca:	c3                   	ret

0000000000801acb <cputchar>:
cputchar(int ch) {
  801acb:	f3 0f 1e fa          	endbr64
  801acf:	55                   	push   %rbp
  801ad0:	48 89 e5             	mov    %rsp,%rbp
  801ad3:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801ad7:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801adb:	be 01 00 00 00       	mov    $0x1,%esi
  801ae0:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801ae4:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  801aeb:	00 00 00 
  801aee:	ff d0                	call   *%rax
}
  801af0:	c9                   	leave
  801af1:	c3                   	ret

0000000000801af2 <getchar>:
getchar(void) {
  801af2:	f3 0f 1e fa          	endbr64
  801af6:	55                   	push   %rbp
  801af7:	48 89 e5             	mov    %rsp,%rbp
  801afa:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801afe:	ba 01 00 00 00       	mov    $0x1,%edx
  801b03:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801b07:	bf 00 00 00 00       	mov    $0x0,%edi
  801b0c:	48 b8 02 0a 80 00 00 	movabs $0x800a02,%rax
  801b13:	00 00 00 
  801b16:	ff d0                	call   *%rax
  801b18:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 06                	js     801b24 <getchar+0x32>
  801b1e:	74 08                	je     801b28 <getchar+0x36>
  801b20:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  801b24:	89 d0                	mov    %edx,%eax
  801b26:	c9                   	leave
  801b27:	c3                   	ret
    return res < 0 ? res : res ? c :
  801b28:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801b2d:	eb f5                	jmp    801b24 <getchar+0x32>

0000000000801b2f <iscons>:
iscons(int fdnum) {
  801b2f:	f3 0f 1e fa          	endbr64
  801b33:	55                   	push   %rbp
  801b34:	48 89 e5             	mov    %rsp,%rbp
  801b37:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801b3b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b3f:	48 b8 07 07 80 00 00 	movabs $0x800707,%rax
  801b46:	00 00 00 
  801b49:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b4b:	85 c0                	test   %eax,%eax
  801b4d:	78 18                	js     801b67 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  801b4f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b53:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801b5a:	00 00 00 
  801b5d:	8b 00                	mov    (%rax),%eax
  801b5f:	39 02                	cmp    %eax,(%rdx)
  801b61:	0f 94 c0             	sete   %al
  801b64:	0f b6 c0             	movzbl %al,%eax
}
  801b67:	c9                   	leave
  801b68:	c3                   	ret

0000000000801b69 <opencons>:
opencons(void) {
  801b69:	f3 0f 1e fa          	endbr64
  801b6d:	55                   	push   %rbp
  801b6e:	48 89 e5             	mov    %rsp,%rbp
  801b71:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801b75:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801b79:	48 b8 a3 06 80 00 00 	movabs $0x8006a3,%rax
  801b80:	00 00 00 
  801b83:	ff d0                	call   *%rax
  801b85:	85 c0                	test   %eax,%eax
  801b87:	78 49                	js     801bd2 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801b89:	b9 46 00 00 00       	mov    $0x46,%ecx
  801b8e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b93:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801b97:	bf 00 00 00 00       	mov    $0x0,%edi
  801b9c:	48 b8 a9 02 80 00 00 	movabs $0x8002a9,%rax
  801ba3:	00 00 00 
  801ba6:	ff d0                	call   *%rax
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	78 26                	js     801bd2 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  801bac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bb0:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801bb7:	00 00 
  801bb9:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801bbb:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801bbf:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801bc6:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  801bcd:	00 00 00 
  801bd0:	ff d0                	call   *%rax
}
  801bd2:	c9                   	leave
  801bd3:	c3                   	ret

0000000000801bd4 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801bd4:	f3 0f 1e fa          	endbr64
  801bd8:	55                   	push   %rbp
  801bd9:	48 89 e5             	mov    %rsp,%rbp
  801bdc:	41 56                	push   %r14
  801bde:	41 55                	push   %r13
  801be0:	41 54                	push   %r12
  801be2:	53                   	push   %rbx
  801be3:	48 83 ec 50          	sub    $0x50,%rsp
  801be7:	49 89 fc             	mov    %rdi,%r12
  801bea:	41 89 f5             	mov    %esi,%r13d
  801bed:	48 89 d3             	mov    %rdx,%rbx
  801bf0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801bf4:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801bf8:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801bfc:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801c03:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c07:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801c0b:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801c0f:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801c13:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801c1a:	00 00 00 
  801c1d:	4c 8b 30             	mov    (%rax),%r14
  801c20:	48 b8 d9 01 80 00 00 	movabs $0x8001d9,%rax
  801c27:	00 00 00 
  801c2a:	ff d0                	call   *%rax
  801c2c:	89 c6                	mov    %eax,%esi
  801c2e:	45 89 e8             	mov    %r13d,%r8d
  801c31:	4c 89 e1             	mov    %r12,%rcx
  801c34:	4c 89 f2             	mov    %r14,%rdx
  801c37:	48 bf e8 32 80 00 00 	movabs $0x8032e8,%rdi
  801c3e:	00 00 00 
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax
  801c46:	49 bc 30 1d 80 00 00 	movabs $0x801d30,%r12
  801c4d:	00 00 00 
  801c50:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801c53:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801c57:	48 89 df             	mov    %rbx,%rdi
  801c5a:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  801c61:	00 00 00 
  801c64:	ff d0                	call   *%rax
    cprintf("\n");
  801c66:	48 bf 32 30 80 00 00 	movabs $0x803032,%rdi
  801c6d:	00 00 00 
  801c70:	b8 00 00 00 00       	mov    $0x0,%eax
  801c75:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801c78:	cc                   	int3
  801c79:	eb fd                	jmp    801c78 <_panic+0xa4>

0000000000801c7b <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801c7b:	f3 0f 1e fa          	endbr64
  801c7f:	55                   	push   %rbp
  801c80:	48 89 e5             	mov    %rsp,%rbp
  801c83:	53                   	push   %rbx
  801c84:	48 83 ec 08          	sub    $0x8,%rsp
  801c88:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801c8b:	8b 06                	mov    (%rsi),%eax
  801c8d:	8d 50 01             	lea    0x1(%rax),%edx
  801c90:	89 16                	mov    %edx,(%rsi)
  801c92:	48 98                	cltq
  801c94:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801c99:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801c9f:	74 0a                	je     801cab <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801ca1:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801ca5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ca9:	c9                   	leave
  801caa:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  801cab:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801caf:	be ff 00 00 00       	mov    $0xff,%esi
  801cb4:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  801cbb:	00 00 00 
  801cbe:	ff d0                	call   *%rax
        state->offset = 0;
  801cc0:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801cc6:	eb d9                	jmp    801ca1 <putch+0x26>

0000000000801cc8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801cc8:	f3 0f 1e fa          	endbr64
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801cd7:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801cda:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801ce1:	b9 21 00 00 00       	mov    $0x21,%ecx
  801ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ceb:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801cee:	48 89 f1             	mov    %rsi,%rcx
  801cf1:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801cf8:	48 bf 7b 1c 80 00 00 	movabs $0x801c7b,%rdi
  801cff:	00 00 00 
  801d02:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  801d09:	00 00 00 
  801d0c:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801d0e:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801d15:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801d1c:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  801d23:	00 00 00 
  801d26:	ff d0                	call   *%rax

    return state.count;
}
  801d28:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801d2e:	c9                   	leave
  801d2f:	c3                   	ret

0000000000801d30 <cprintf>:

int
cprintf(const char *fmt, ...) {
  801d30:	f3 0f 1e fa          	endbr64
  801d34:	55                   	push   %rbp
  801d35:	48 89 e5             	mov    %rsp,%rbp
  801d38:	48 83 ec 50          	sub    $0x50,%rsp
  801d3c:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801d40:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801d44:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d48:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801d4c:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801d50:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801d57:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d5b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d5f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801d63:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801d67:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801d6b:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  801d72:	00 00 00 
  801d75:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801d77:	c9                   	leave
  801d78:	c3                   	ret

0000000000801d79 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801d79:	f3 0f 1e fa          	endbr64
  801d7d:	55                   	push   %rbp
  801d7e:	48 89 e5             	mov    %rsp,%rbp
  801d81:	41 57                	push   %r15
  801d83:	41 56                	push   %r14
  801d85:	41 55                	push   %r13
  801d87:	41 54                	push   %r12
  801d89:	53                   	push   %rbx
  801d8a:	48 83 ec 18          	sub    $0x18,%rsp
  801d8e:	49 89 fc             	mov    %rdi,%r12
  801d91:	49 89 f5             	mov    %rsi,%r13
  801d94:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801d98:	8b 45 10             	mov    0x10(%rbp),%eax
  801d9b:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801d9e:	41 89 cf             	mov    %ecx,%r15d
  801da1:	4c 39 fa             	cmp    %r15,%rdx
  801da4:	73 5b                	jae    801e01 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801da6:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801daa:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801dae:	85 db                	test   %ebx,%ebx
  801db0:	7e 0e                	jle    801dc0 <print_num+0x47>
            putch(padc, put_arg);
  801db2:	4c 89 ee             	mov    %r13,%rsi
  801db5:	44 89 f7             	mov    %r14d,%edi
  801db8:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801dbb:	83 eb 01             	sub    $0x1,%ebx
  801dbe:	75 f2                	jne    801db2 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801dc0:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801dc4:	48 b9 c2 30 80 00 00 	movabs $0x8030c2,%rcx
  801dcb:	00 00 00 
  801dce:	48 b8 b1 30 80 00 00 	movabs $0x8030b1,%rax
  801dd5:	00 00 00 
  801dd8:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801ddc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801de0:	ba 00 00 00 00       	mov    $0x0,%edx
  801de5:	49 f7 f7             	div    %r15
  801de8:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801dec:	4c 89 ee             	mov    %r13,%rsi
  801def:	41 ff d4             	call   *%r12
}
  801df2:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801df6:	5b                   	pop    %rbx
  801df7:	41 5c                	pop    %r12
  801df9:	41 5d                	pop    %r13
  801dfb:	41 5e                	pop    %r14
  801dfd:	41 5f                	pop    %r15
  801dff:	5d                   	pop    %rbp
  801e00:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801e01:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e05:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0a:	49 f7 f7             	div    %r15
  801e0d:	48 83 ec 08          	sub    $0x8,%rsp
  801e11:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801e15:	52                   	push   %rdx
  801e16:	45 0f be c9          	movsbl %r9b,%r9d
  801e1a:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801e1e:	48 89 c2             	mov    %rax,%rdx
  801e21:	48 b8 79 1d 80 00 00 	movabs $0x801d79,%rax
  801e28:	00 00 00 
  801e2b:	ff d0                	call   *%rax
  801e2d:	48 83 c4 10          	add    $0x10,%rsp
  801e31:	eb 8d                	jmp    801dc0 <print_num+0x47>

0000000000801e33 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  801e33:	f3 0f 1e fa          	endbr64
    state->count++;
  801e37:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801e3b:	48 8b 06             	mov    (%rsi),%rax
  801e3e:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801e42:	73 0a                	jae    801e4e <sprintputch+0x1b>
        *state->start++ = ch;
  801e44:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e48:	48 89 16             	mov    %rdx,(%rsi)
  801e4b:	40 88 38             	mov    %dil,(%rax)
    }
}
  801e4e:	c3                   	ret

0000000000801e4f <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801e4f:	f3 0f 1e fa          	endbr64
  801e53:	55                   	push   %rbp
  801e54:	48 89 e5             	mov    %rsp,%rbp
  801e57:	48 83 ec 50          	sub    $0x50,%rsp
  801e5b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e5f:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801e63:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801e67:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801e6e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e72:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e76:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801e7a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801e7e:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801e82:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  801e89:	00 00 00 
  801e8c:	ff d0                	call   *%rax
}
  801e8e:	c9                   	leave
  801e8f:	c3                   	ret

0000000000801e90 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801e90:	f3 0f 1e fa          	endbr64
  801e94:	55                   	push   %rbp
  801e95:	48 89 e5             	mov    %rsp,%rbp
  801e98:	41 57                	push   %r15
  801e9a:	41 56                	push   %r14
  801e9c:	41 55                	push   %r13
  801e9e:	41 54                	push   %r12
  801ea0:	53                   	push   %rbx
  801ea1:	48 83 ec 38          	sub    $0x38,%rsp
  801ea5:	49 89 fe             	mov    %rdi,%r14
  801ea8:	49 89 f5             	mov    %rsi,%r13
  801eab:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  801eae:	48 8b 01             	mov    (%rcx),%rax
  801eb1:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801eb5:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801eb9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ebd:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801ec1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801ec5:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  801ec9:	0f b6 3b             	movzbl (%rbx),%edi
  801ecc:	40 80 ff 25          	cmp    $0x25,%dil
  801ed0:	74 18                	je     801eea <vprintfmt+0x5a>
            if (!ch) return;
  801ed2:	40 84 ff             	test   %dil,%dil
  801ed5:	0f 84 b2 06 00 00    	je     80258d <vprintfmt+0x6fd>
            putch(ch, put_arg);
  801edb:	40 0f b6 ff          	movzbl %dil,%edi
  801edf:	4c 89 ee             	mov    %r13,%rsi
  801ee2:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  801ee5:	4c 89 e3             	mov    %r12,%rbx
  801ee8:	eb db                	jmp    801ec5 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  801eea:	be 00 00 00 00       	mov    $0x0,%esi
  801eef:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  801ef3:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801ef8:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801efe:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801f05:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f09:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  801f0e:	41 0f b6 04 24       	movzbl (%r12),%eax
  801f13:	88 45 a0             	mov    %al,-0x60(%rbp)
  801f16:	83 e8 23             	sub    $0x23,%eax
  801f19:	3c 57                	cmp    $0x57,%al
  801f1b:	0f 87 52 06 00 00    	ja     802573 <vprintfmt+0x6e3>
  801f21:	0f b6 c0             	movzbl %al,%eax
  801f24:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  801f2b:	00 00 00 
  801f2e:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  801f32:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  801f35:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  801f39:	eb ce                	jmp    801f09 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  801f3b:	49 89 dc             	mov    %rbx,%r12
  801f3e:	be 01 00 00 00       	mov    $0x1,%esi
  801f43:	eb c4                	jmp    801f09 <vprintfmt+0x79>
            padc = ch;
  801f45:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  801f49:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f4c:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801f4f:	eb b8                	jmp    801f09 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f51:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f54:	83 f8 2f             	cmp    $0x2f,%eax
  801f57:	77 24                	ja     801f7d <vprintfmt+0xed>
  801f59:	89 c1                	mov    %eax,%ecx
  801f5b:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  801f5f:	83 c0 08             	add    $0x8,%eax
  801f62:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f65:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  801f68:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  801f6b:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801f6f:	79 98                	jns    801f09 <vprintfmt+0x79>
                width = precision;
  801f71:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  801f75:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f7b:	eb 8c                	jmp    801f09 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f7d:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801f81:	48 8d 41 08          	lea    0x8(%rcx),%rax
  801f85:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801f89:	eb da                	jmp    801f65 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  801f8b:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  801f90:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801f94:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  801f9a:	3c 39                	cmp    $0x39,%al
  801f9c:	77 1c                	ja     801fba <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  801f9e:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  801fa2:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  801fa6:	0f b6 c0             	movzbl %al,%eax
  801fa9:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fae:	0f b6 03             	movzbl (%rbx),%eax
  801fb1:	3c 39                	cmp    $0x39,%al
  801fb3:	76 e9                	jbe    801f9e <vprintfmt+0x10e>
        process_precision:
  801fb5:	49 89 dc             	mov    %rbx,%r12
  801fb8:	eb b1                	jmp    801f6b <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  801fba:	49 89 dc             	mov    %rbx,%r12
  801fbd:	eb ac                	jmp    801f6b <vprintfmt+0xdb>
            width = MAX(0, width);
  801fbf:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  801fc2:	85 c9                	test   %ecx,%ecx
  801fc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc9:	0f 49 c1             	cmovns %ecx,%eax
  801fcc:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801fcf:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fd2:	e9 32 ff ff ff       	jmp    801f09 <vprintfmt+0x79>
            lflag++;
  801fd7:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801fda:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fdd:	e9 27 ff ff ff       	jmp    801f09 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  801fe2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fe5:	83 f8 2f             	cmp    $0x2f,%eax
  801fe8:	77 19                	ja     802003 <vprintfmt+0x173>
  801fea:	89 c2                	mov    %eax,%edx
  801fec:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801ff0:	83 c0 08             	add    $0x8,%eax
  801ff3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801ff6:	8b 3a                	mov    (%rdx),%edi
  801ff8:	4c 89 ee             	mov    %r13,%rsi
  801ffb:	41 ff d6             	call   *%r14
            break;
  801ffe:	e9 c2 fe ff ff       	jmp    801ec5 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  802003:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802007:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80200b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80200f:	eb e5                	jmp    801ff6 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  802011:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802014:	83 f8 2f             	cmp    $0x2f,%eax
  802017:	77 5a                	ja     802073 <vprintfmt+0x1e3>
  802019:	89 c2                	mov    %eax,%edx
  80201b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80201f:	83 c0 08             	add    $0x8,%eax
  802022:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  802025:	8b 02                	mov    (%rdx),%eax
  802027:	89 c1                	mov    %eax,%ecx
  802029:	f7 d9                	neg    %ecx
  80202b:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80202e:	83 f9 13             	cmp    $0x13,%ecx
  802031:	7f 4e                	jg     802081 <vprintfmt+0x1f1>
  802033:	48 63 c1             	movslq %ecx,%rax
  802036:	48 ba 20 36 80 00 00 	movabs $0x803620,%rdx
  80203d:	00 00 00 
  802040:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802044:	48 85 c0             	test   %rax,%rax
  802047:	74 38                	je     802081 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  802049:	48 89 c1             	mov    %rax,%rcx
  80204c:	48 ba 80 30 80 00 00 	movabs $0x803080,%rdx
  802053:	00 00 00 
  802056:	4c 89 ee             	mov    %r13,%rsi
  802059:	4c 89 f7             	mov    %r14,%rdi
  80205c:	b8 00 00 00 00       	mov    $0x0,%eax
  802061:	49 b8 4f 1e 80 00 00 	movabs $0x801e4f,%r8
  802068:	00 00 00 
  80206b:	41 ff d0             	call   *%r8
  80206e:	e9 52 fe ff ff       	jmp    801ec5 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  802073:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802077:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80207b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80207f:	eb a4                	jmp    802025 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  802081:	48 ba da 30 80 00 00 	movabs $0x8030da,%rdx
  802088:	00 00 00 
  80208b:	4c 89 ee             	mov    %r13,%rsi
  80208e:	4c 89 f7             	mov    %r14,%rdi
  802091:	b8 00 00 00 00       	mov    $0x0,%eax
  802096:	49 b8 4f 1e 80 00 00 	movabs $0x801e4f,%r8
  80209d:	00 00 00 
  8020a0:	41 ff d0             	call   *%r8
  8020a3:	e9 1d fe ff ff       	jmp    801ec5 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8020a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020ab:	83 f8 2f             	cmp    $0x2f,%eax
  8020ae:	77 6c                	ja     80211c <vprintfmt+0x28c>
  8020b0:	89 c2                	mov    %eax,%edx
  8020b2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8020b6:	83 c0 08             	add    $0x8,%eax
  8020b9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020bc:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8020bf:	48 85 d2             	test   %rdx,%rdx
  8020c2:	48 b8 d3 30 80 00 00 	movabs $0x8030d3,%rax
  8020c9:	00 00 00 
  8020cc:	48 0f 45 c2          	cmovne %rdx,%rax
  8020d0:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8020d4:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8020d8:	7e 06                	jle    8020e0 <vprintfmt+0x250>
  8020da:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8020de:	75 4a                	jne    80212a <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8020e0:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8020e4:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8020e8:	0f b6 00             	movzbl (%rax),%eax
  8020eb:	84 c0                	test   %al,%al
  8020ed:	0f 85 9a 00 00 00    	jne    80218d <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8020f3:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8020f6:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	0f 8e c3 fd ff ff    	jle    801ec5 <vprintfmt+0x35>
  802102:	4c 89 ee             	mov    %r13,%rsi
  802105:	bf 20 00 00 00       	mov    $0x20,%edi
  80210a:	41 ff d6             	call   *%r14
  80210d:	41 83 ec 01          	sub    $0x1,%r12d
  802111:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  802115:	75 eb                	jne    802102 <vprintfmt+0x272>
  802117:	e9 a9 fd ff ff       	jmp    801ec5 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80211c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802120:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802124:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802128:	eb 92                	jmp    8020bc <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  80212a:	49 63 f7             	movslq %r15d,%rsi
  80212d:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  802131:	48 b8 53 26 80 00 00 	movabs $0x802653,%rax
  802138:	00 00 00 
  80213b:	ff d0                	call   *%rax
  80213d:	48 89 c2             	mov    %rax,%rdx
  802140:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802143:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  802145:	8d 70 ff             	lea    -0x1(%rax),%esi
  802148:	89 75 ac             	mov    %esi,-0x54(%rbp)
  80214b:	85 c0                	test   %eax,%eax
  80214d:	7e 91                	jle    8020e0 <vprintfmt+0x250>
  80214f:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  802154:	4c 89 ee             	mov    %r13,%rsi
  802157:	44 89 e7             	mov    %r12d,%edi
  80215a:	41 ff d6             	call   *%r14
  80215d:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  802161:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802164:	83 f8 ff             	cmp    $0xffffffff,%eax
  802167:	75 eb                	jne    802154 <vprintfmt+0x2c4>
  802169:	e9 72 ff ff ff       	jmp    8020e0 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80216e:	0f b6 f8             	movzbl %al,%edi
  802171:	4c 89 ee             	mov    %r13,%rsi
  802174:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802177:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80217b:	49 83 c4 01          	add    $0x1,%r12
  80217f:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  802185:	84 c0                	test   %al,%al
  802187:	0f 84 66 ff ff ff    	je     8020f3 <vprintfmt+0x263>
  80218d:	45 85 ff             	test   %r15d,%r15d
  802190:	78 0a                	js     80219c <vprintfmt+0x30c>
  802192:	41 83 ef 01          	sub    $0x1,%r15d
  802196:	0f 88 57 ff ff ff    	js     8020f3 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80219c:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8021a0:	74 cc                	je     80216e <vprintfmt+0x2de>
  8021a2:	8d 50 e0             	lea    -0x20(%rax),%edx
  8021a5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8021aa:	80 fa 5e             	cmp    $0x5e,%dl
  8021ad:	77 c2                	ja     802171 <vprintfmt+0x2e1>
  8021af:	eb bd                	jmp    80216e <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8021b1:	40 84 f6             	test   %sil,%sil
  8021b4:	75 26                	jne    8021dc <vprintfmt+0x34c>
    switch (lflag) {
  8021b6:	85 d2                	test   %edx,%edx
  8021b8:	74 59                	je     802213 <vprintfmt+0x383>
  8021ba:	83 fa 01             	cmp    $0x1,%edx
  8021bd:	74 7b                	je     80223a <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8021bf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021c2:	83 f8 2f             	cmp    $0x2f,%eax
  8021c5:	0f 87 96 00 00 00    	ja     802261 <vprintfmt+0x3d1>
  8021cb:	89 c2                	mov    %eax,%edx
  8021cd:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021d1:	83 c0 08             	add    $0x8,%eax
  8021d4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021d7:	4c 8b 22             	mov    (%rdx),%r12
  8021da:	eb 17                	jmp    8021f3 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8021dc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021df:	83 f8 2f             	cmp    $0x2f,%eax
  8021e2:	77 21                	ja     802205 <vprintfmt+0x375>
  8021e4:	89 c2                	mov    %eax,%edx
  8021e6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021ea:	83 c0 08             	add    $0x8,%eax
  8021ed:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021f0:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8021f3:	4d 85 e4             	test   %r12,%r12
  8021f6:	78 7a                	js     802272 <vprintfmt+0x3e2>
            num = i;
  8021f8:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8021fb:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  802200:	e9 50 02 00 00       	jmp    802455 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  802205:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802209:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80220d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802211:	eb dd                	jmp    8021f0 <vprintfmt+0x360>
        return va_arg(*ap, int);
  802213:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802216:	83 f8 2f             	cmp    $0x2f,%eax
  802219:	77 11                	ja     80222c <vprintfmt+0x39c>
  80221b:	89 c2                	mov    %eax,%edx
  80221d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802221:	83 c0 08             	add    $0x8,%eax
  802224:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802227:	4c 63 22             	movslq (%rdx),%r12
  80222a:	eb c7                	jmp    8021f3 <vprintfmt+0x363>
  80222c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802230:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802234:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802238:	eb ed                	jmp    802227 <vprintfmt+0x397>
        return va_arg(*ap, long);
  80223a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80223d:	83 f8 2f             	cmp    $0x2f,%eax
  802240:	77 11                	ja     802253 <vprintfmt+0x3c3>
  802242:	89 c2                	mov    %eax,%edx
  802244:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802248:	83 c0 08             	add    $0x8,%eax
  80224b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80224e:	4c 8b 22             	mov    (%rdx),%r12
  802251:	eb a0                	jmp    8021f3 <vprintfmt+0x363>
  802253:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802257:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80225b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80225f:	eb ed                	jmp    80224e <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  802261:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802265:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802269:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80226d:	e9 65 ff ff ff       	jmp    8021d7 <vprintfmt+0x347>
                putch('-', put_arg);
  802272:	4c 89 ee             	mov    %r13,%rsi
  802275:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80227a:	41 ff d6             	call   *%r14
                i = -i;
  80227d:	49 f7 dc             	neg    %r12
  802280:	e9 73 ff ff ff       	jmp    8021f8 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  802285:	40 84 f6             	test   %sil,%sil
  802288:	75 32                	jne    8022bc <vprintfmt+0x42c>
    switch (lflag) {
  80228a:	85 d2                	test   %edx,%edx
  80228c:	74 5d                	je     8022eb <vprintfmt+0x45b>
  80228e:	83 fa 01             	cmp    $0x1,%edx
  802291:	0f 84 82 00 00 00    	je     802319 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  802297:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80229a:	83 f8 2f             	cmp    $0x2f,%eax
  80229d:	0f 87 a5 00 00 00    	ja     802348 <vprintfmt+0x4b8>
  8022a3:	89 c2                	mov    %eax,%edx
  8022a5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022a9:	83 c0 08             	add    $0x8,%eax
  8022ac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022af:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022b2:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8022b7:	e9 99 01 00 00       	jmp    802455 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8022bc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022bf:	83 f8 2f             	cmp    $0x2f,%eax
  8022c2:	77 19                	ja     8022dd <vprintfmt+0x44d>
  8022c4:	89 c2                	mov    %eax,%edx
  8022c6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022ca:	83 c0 08             	add    $0x8,%eax
  8022cd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022d0:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8022d8:	e9 78 01 00 00       	jmp    802455 <vprintfmt+0x5c5>
  8022dd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8022e1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8022e5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022e9:	eb e5                	jmp    8022d0 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8022eb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022ee:	83 f8 2f             	cmp    $0x2f,%eax
  8022f1:	77 18                	ja     80230b <vprintfmt+0x47b>
  8022f3:	89 c2                	mov    %eax,%edx
  8022f5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022f9:	83 c0 08             	add    $0x8,%eax
  8022fc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022ff:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  802301:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802306:	e9 4a 01 00 00       	jmp    802455 <vprintfmt+0x5c5>
  80230b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80230f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802313:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802317:	eb e6                	jmp    8022ff <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  802319:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80231c:	83 f8 2f             	cmp    $0x2f,%eax
  80231f:	77 19                	ja     80233a <vprintfmt+0x4aa>
  802321:	89 c2                	mov    %eax,%edx
  802323:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802327:	83 c0 08             	add    $0x8,%eax
  80232a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80232d:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  802330:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  802335:	e9 1b 01 00 00       	jmp    802455 <vprintfmt+0x5c5>
  80233a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80233e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802342:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802346:	eb e5                	jmp    80232d <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  802348:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80234c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802350:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802354:	e9 56 ff ff ff       	jmp    8022af <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  802359:	40 84 f6             	test   %sil,%sil
  80235c:	75 2e                	jne    80238c <vprintfmt+0x4fc>
    switch (lflag) {
  80235e:	85 d2                	test   %edx,%edx
  802360:	74 59                	je     8023bb <vprintfmt+0x52b>
  802362:	83 fa 01             	cmp    $0x1,%edx
  802365:	74 7f                	je     8023e6 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  802367:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80236a:	83 f8 2f             	cmp    $0x2f,%eax
  80236d:	0f 87 9f 00 00 00    	ja     802412 <vprintfmt+0x582>
  802373:	89 c2                	mov    %eax,%edx
  802375:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802379:	83 c0 08             	add    $0x8,%eax
  80237c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80237f:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  802382:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  802387:	e9 c9 00 00 00       	jmp    802455 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80238c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80238f:	83 f8 2f             	cmp    $0x2f,%eax
  802392:	77 19                	ja     8023ad <vprintfmt+0x51d>
  802394:	89 c2                	mov    %eax,%edx
  802396:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80239a:	83 c0 08             	add    $0x8,%eax
  80239d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023a0:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023a3:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8023a8:	e9 a8 00 00 00       	jmp    802455 <vprintfmt+0x5c5>
  8023ad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023b1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023b5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023b9:	eb e5                	jmp    8023a0 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8023bb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023be:	83 f8 2f             	cmp    $0x2f,%eax
  8023c1:	77 15                	ja     8023d8 <vprintfmt+0x548>
  8023c3:	89 c2                	mov    %eax,%edx
  8023c5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023c9:	83 c0 08             	add    $0x8,%eax
  8023cc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023cf:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8023d1:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8023d6:	eb 7d                	jmp    802455 <vprintfmt+0x5c5>
  8023d8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023dc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023e0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023e4:	eb e9                	jmp    8023cf <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8023e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023e9:	83 f8 2f             	cmp    $0x2f,%eax
  8023ec:	77 16                	ja     802404 <vprintfmt+0x574>
  8023ee:	89 c2                	mov    %eax,%edx
  8023f0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023f4:	83 c0 08             	add    $0x8,%eax
  8023f7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023fa:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023fd:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  802402:	eb 51                	jmp    802455 <vprintfmt+0x5c5>
  802404:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802408:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80240c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802410:	eb e8                	jmp    8023fa <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  802412:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802416:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80241a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80241e:	e9 5c ff ff ff       	jmp    80237f <vprintfmt+0x4ef>
            putch('0', put_arg);
  802423:	4c 89 ee             	mov    %r13,%rsi
  802426:	bf 30 00 00 00       	mov    $0x30,%edi
  80242b:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  80242e:	4c 89 ee             	mov    %r13,%rsi
  802431:	bf 78 00 00 00       	mov    $0x78,%edi
  802436:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  802439:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80243c:	83 f8 2f             	cmp    $0x2f,%eax
  80243f:	77 47                	ja     802488 <vprintfmt+0x5f8>
  802441:	89 c2                	mov    %eax,%edx
  802443:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802447:	83 c0 08             	add    $0x8,%eax
  80244a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80244d:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802450:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  802455:	48 83 ec 08          	sub    $0x8,%rsp
  802459:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  80245d:	0f 94 c0             	sete   %al
  802460:	0f b6 c0             	movzbl %al,%eax
  802463:	50                   	push   %rax
  802464:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  802469:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80246d:	4c 89 ee             	mov    %r13,%rsi
  802470:	4c 89 f7             	mov    %r14,%rdi
  802473:	48 b8 79 1d 80 00 00 	movabs $0x801d79,%rax
  80247a:	00 00 00 
  80247d:	ff d0                	call   *%rax
            break;
  80247f:	48 83 c4 10          	add    $0x10,%rsp
  802483:	e9 3d fa ff ff       	jmp    801ec5 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  802488:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80248c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802490:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802494:	eb b7                	jmp    80244d <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  802496:	40 84 f6             	test   %sil,%sil
  802499:	75 2b                	jne    8024c6 <vprintfmt+0x636>
    switch (lflag) {
  80249b:	85 d2                	test   %edx,%edx
  80249d:	74 56                	je     8024f5 <vprintfmt+0x665>
  80249f:	83 fa 01             	cmp    $0x1,%edx
  8024a2:	74 7f                	je     802523 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  8024a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024a7:	83 f8 2f             	cmp    $0x2f,%eax
  8024aa:	0f 87 a2 00 00 00    	ja     802552 <vprintfmt+0x6c2>
  8024b0:	89 c2                	mov    %eax,%edx
  8024b2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024b6:	83 c0 08             	add    $0x8,%eax
  8024b9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024bc:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024bf:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8024c4:	eb 8f                	jmp    802455 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8024c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024c9:	83 f8 2f             	cmp    $0x2f,%eax
  8024cc:	77 19                	ja     8024e7 <vprintfmt+0x657>
  8024ce:	89 c2                	mov    %eax,%edx
  8024d0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024d4:	83 c0 08             	add    $0x8,%eax
  8024d7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024da:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024dd:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8024e2:	e9 6e ff ff ff       	jmp    802455 <vprintfmt+0x5c5>
  8024e7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024eb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8024ef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024f3:	eb e5                	jmp    8024da <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8024f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024f8:	83 f8 2f             	cmp    $0x2f,%eax
  8024fb:	77 18                	ja     802515 <vprintfmt+0x685>
  8024fd:	89 c2                	mov    %eax,%edx
  8024ff:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802503:	83 c0 08             	add    $0x8,%eax
  802506:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802509:	8b 12                	mov    (%rdx),%edx
            base = 16;
  80250b:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  802510:	e9 40 ff ff ff       	jmp    802455 <vprintfmt+0x5c5>
  802515:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802519:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80251d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802521:	eb e6                	jmp    802509 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  802523:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802526:	83 f8 2f             	cmp    $0x2f,%eax
  802529:	77 19                	ja     802544 <vprintfmt+0x6b4>
  80252b:	89 c2                	mov    %eax,%edx
  80252d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802531:	83 c0 08             	add    $0x8,%eax
  802534:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802537:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80253a:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  80253f:	e9 11 ff ff ff       	jmp    802455 <vprintfmt+0x5c5>
  802544:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802548:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80254c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802550:	eb e5                	jmp    802537 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  802552:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802556:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80255a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80255e:	e9 59 ff ff ff       	jmp    8024bc <vprintfmt+0x62c>
            putch(ch, put_arg);
  802563:	4c 89 ee             	mov    %r13,%rsi
  802566:	bf 25 00 00 00       	mov    $0x25,%edi
  80256b:	41 ff d6             	call   *%r14
            break;
  80256e:	e9 52 f9 ff ff       	jmp    801ec5 <vprintfmt+0x35>
            putch('%', put_arg);
  802573:	4c 89 ee             	mov    %r13,%rsi
  802576:	bf 25 00 00 00       	mov    $0x25,%edi
  80257b:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  80257e:	48 83 eb 01          	sub    $0x1,%rbx
  802582:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  802586:	75 f6                	jne    80257e <vprintfmt+0x6ee>
  802588:	e9 38 f9 ff ff       	jmp    801ec5 <vprintfmt+0x35>
}
  80258d:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  802591:	5b                   	pop    %rbx
  802592:	41 5c                	pop    %r12
  802594:	41 5d                	pop    %r13
  802596:	41 5e                	pop    %r14
  802598:	41 5f                	pop    %r15
  80259a:	5d                   	pop    %rbp
  80259b:	c3                   	ret

000000000080259c <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  80259c:	f3 0f 1e fa          	endbr64
  8025a0:	55                   	push   %rbp
  8025a1:	48 89 e5             	mov    %rsp,%rbp
  8025a4:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  8025a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025ac:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  8025b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8025b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8025bc:	48 85 ff             	test   %rdi,%rdi
  8025bf:	74 2b                	je     8025ec <vsnprintf+0x50>
  8025c1:	48 85 f6             	test   %rsi,%rsi
  8025c4:	74 26                	je     8025ec <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8025c6:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8025ca:	48 bf 33 1e 80 00 00 	movabs $0x801e33,%rdi
  8025d1:	00 00 00 
  8025d4:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  8025db:	00 00 00 
  8025de:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8025e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025e4:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8025e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025ea:	c9                   	leave
  8025eb:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  8025ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025f1:	eb f7                	jmp    8025ea <vsnprintf+0x4e>

00000000008025f3 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8025f3:	f3 0f 1e fa          	endbr64
  8025f7:	55                   	push   %rbp
  8025f8:	48 89 e5             	mov    %rsp,%rbp
  8025fb:	48 83 ec 50          	sub    $0x50,%rsp
  8025ff:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802603:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802607:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80260b:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  802612:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802616:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80261a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80261e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  802622:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  802626:	48 b8 9c 25 80 00 00 	movabs $0x80259c,%rax
  80262d:	00 00 00 
  802630:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  802632:	c9                   	leave
  802633:	c3                   	ret

0000000000802634 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  802634:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  802638:	80 3f 00             	cmpb   $0x0,(%rdi)
  80263b:	74 10                	je     80264d <strlen+0x19>
    size_t n = 0;
  80263d:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  802642:	48 83 c0 01          	add    $0x1,%rax
  802646:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  80264a:	75 f6                	jne    802642 <strlen+0xe>
  80264c:	c3                   	ret
    size_t n = 0;
  80264d:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  802652:	c3                   	ret

0000000000802653 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  802653:	f3 0f 1e fa          	endbr64
  802657:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  80265a:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  80265f:	48 85 f6             	test   %rsi,%rsi
  802662:	74 10                	je     802674 <strnlen+0x21>
  802664:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  802668:	74 0b                	je     802675 <strnlen+0x22>
  80266a:	48 83 c2 01          	add    $0x1,%rdx
  80266e:	48 39 d0             	cmp    %rdx,%rax
  802671:	75 f1                	jne    802664 <strnlen+0x11>
  802673:	c3                   	ret
  802674:	c3                   	ret
  802675:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  802678:	c3                   	ret

0000000000802679 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  802679:	f3 0f 1e fa          	endbr64
  80267d:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  802680:	ba 00 00 00 00       	mov    $0x0,%edx
  802685:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  802689:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  80268c:	48 83 c2 01          	add    $0x1,%rdx
  802690:	84 c9                	test   %cl,%cl
  802692:	75 f1                	jne    802685 <strcpy+0xc>
        ;
    return res;
}
  802694:	c3                   	ret

0000000000802695 <strcat>:

char *
strcat(char *dst, const char *src) {
  802695:	f3 0f 1e fa          	endbr64
  802699:	55                   	push   %rbp
  80269a:	48 89 e5             	mov    %rsp,%rbp
  80269d:	41 54                	push   %r12
  80269f:	53                   	push   %rbx
  8026a0:	48 89 fb             	mov    %rdi,%rbx
  8026a3:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8026a6:	48 b8 34 26 80 00 00 	movabs $0x802634,%rax
  8026ad:	00 00 00 
  8026b0:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  8026b2:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8026b6:	4c 89 e6             	mov    %r12,%rsi
  8026b9:	48 b8 79 26 80 00 00 	movabs $0x802679,%rax
  8026c0:	00 00 00 
  8026c3:	ff d0                	call   *%rax
    return dst;
}
  8026c5:	48 89 d8             	mov    %rbx,%rax
  8026c8:	5b                   	pop    %rbx
  8026c9:	41 5c                	pop    %r12
  8026cb:	5d                   	pop    %rbp
  8026cc:	c3                   	ret

00000000008026cd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8026cd:	f3 0f 1e fa          	endbr64
  8026d1:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  8026d4:	48 85 d2             	test   %rdx,%rdx
  8026d7:	74 1f                	je     8026f8 <strncpy+0x2b>
  8026d9:	48 01 fa             	add    %rdi,%rdx
  8026dc:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  8026df:	48 83 c1 01          	add    $0x1,%rcx
  8026e3:	44 0f b6 06          	movzbl (%rsi),%r8d
  8026e7:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  8026eb:	41 80 f8 01          	cmp    $0x1,%r8b
  8026ef:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8026f3:	48 39 ca             	cmp    %rcx,%rdx
  8026f6:	75 e7                	jne    8026df <strncpy+0x12>
    }
    return ret;
}
  8026f8:	c3                   	ret

00000000008026f9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  8026f9:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  8026fd:	48 89 f8             	mov    %rdi,%rax
  802700:	48 85 d2             	test   %rdx,%rdx
  802703:	74 24                	je     802729 <strlcpy+0x30>
        while (--size > 0 && *src)
  802705:	48 83 ea 01          	sub    $0x1,%rdx
  802709:	74 1b                	je     802726 <strlcpy+0x2d>
  80270b:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80270f:	0f b6 16             	movzbl (%rsi),%edx
  802712:	84 d2                	test   %dl,%dl
  802714:	74 10                	je     802726 <strlcpy+0x2d>
            *dst++ = *src++;
  802716:	48 83 c6 01          	add    $0x1,%rsi
  80271a:	48 83 c0 01          	add    $0x1,%rax
  80271e:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  802721:	48 39 c8             	cmp    %rcx,%rax
  802724:	75 e9                	jne    80270f <strlcpy+0x16>
        *dst = '\0';
  802726:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  802729:	48 29 f8             	sub    %rdi,%rax
}
  80272c:	c3                   	ret

000000000080272d <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  80272d:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  802731:	0f b6 07             	movzbl (%rdi),%eax
  802734:	84 c0                	test   %al,%al
  802736:	74 13                	je     80274b <strcmp+0x1e>
  802738:	38 06                	cmp    %al,(%rsi)
  80273a:	75 0f                	jne    80274b <strcmp+0x1e>
  80273c:	48 83 c7 01          	add    $0x1,%rdi
  802740:	48 83 c6 01          	add    $0x1,%rsi
  802744:	0f b6 07             	movzbl (%rdi),%eax
  802747:	84 c0                	test   %al,%al
  802749:	75 ed                	jne    802738 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  80274b:	0f b6 c0             	movzbl %al,%eax
  80274e:	0f b6 16             	movzbl (%rsi),%edx
  802751:	29 d0                	sub    %edx,%eax
}
  802753:	c3                   	ret

0000000000802754 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  802754:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  802758:	48 85 d2             	test   %rdx,%rdx
  80275b:	74 1f                	je     80277c <strncmp+0x28>
  80275d:	0f b6 07             	movzbl (%rdi),%eax
  802760:	84 c0                	test   %al,%al
  802762:	74 1e                	je     802782 <strncmp+0x2e>
  802764:	3a 06                	cmp    (%rsi),%al
  802766:	75 1a                	jne    802782 <strncmp+0x2e>
  802768:	48 83 c7 01          	add    $0x1,%rdi
  80276c:	48 83 c6 01          	add    $0x1,%rsi
  802770:	48 83 ea 01          	sub    $0x1,%rdx
  802774:	75 e7                	jne    80275d <strncmp+0x9>

    if (!n) return 0;
  802776:	b8 00 00 00 00       	mov    $0x0,%eax
  80277b:	c3                   	ret
  80277c:	b8 00 00 00 00       	mov    $0x0,%eax
  802781:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  802782:	0f b6 07             	movzbl (%rdi),%eax
  802785:	0f b6 16             	movzbl (%rsi),%edx
  802788:	29 d0                	sub    %edx,%eax
}
  80278a:	c3                   	ret

000000000080278b <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  80278b:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  80278f:	0f b6 17             	movzbl (%rdi),%edx
  802792:	84 d2                	test   %dl,%dl
  802794:	74 18                	je     8027ae <strchr+0x23>
        if (*str == c) {
  802796:	0f be d2             	movsbl %dl,%edx
  802799:	39 f2                	cmp    %esi,%edx
  80279b:	74 17                	je     8027b4 <strchr+0x29>
    for (; *str; str++) {
  80279d:	48 83 c7 01          	add    $0x1,%rdi
  8027a1:	0f b6 17             	movzbl (%rdi),%edx
  8027a4:	84 d2                	test   %dl,%dl
  8027a6:	75 ee                	jne    802796 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  8027a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ad:	c3                   	ret
  8027ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b3:	c3                   	ret
            return (char *)str;
  8027b4:	48 89 f8             	mov    %rdi,%rax
}
  8027b7:	c3                   	ret

00000000008027b8 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  8027b8:	f3 0f 1e fa          	endbr64
  8027bc:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  8027bf:	0f b6 17             	movzbl (%rdi),%edx
  8027c2:	84 d2                	test   %dl,%dl
  8027c4:	74 13                	je     8027d9 <strfind+0x21>
  8027c6:	0f be d2             	movsbl %dl,%edx
  8027c9:	39 f2                	cmp    %esi,%edx
  8027cb:	74 0b                	je     8027d8 <strfind+0x20>
  8027cd:	48 83 c0 01          	add    $0x1,%rax
  8027d1:	0f b6 10             	movzbl (%rax),%edx
  8027d4:	84 d2                	test   %dl,%dl
  8027d6:	75 ee                	jne    8027c6 <strfind+0xe>
        ;
    return (char *)str;
}
  8027d8:	c3                   	ret
  8027d9:	c3                   	ret

00000000008027da <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8027da:	f3 0f 1e fa          	endbr64
  8027de:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  8027e1:	48 89 f8             	mov    %rdi,%rax
  8027e4:	48 f7 d8             	neg    %rax
  8027e7:	83 e0 07             	and    $0x7,%eax
  8027ea:	49 89 d1             	mov    %rdx,%r9
  8027ed:	49 29 c1             	sub    %rax,%r9
  8027f0:	78 36                	js     802828 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8027f2:	40 0f b6 c6          	movzbl %sil,%eax
  8027f6:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  8027fd:	01 01 01 
  802800:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  802804:	40 f6 c7 07          	test   $0x7,%dil
  802808:	75 38                	jne    802842 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80280a:	4c 89 c9             	mov    %r9,%rcx
  80280d:	48 c1 f9 03          	sar    $0x3,%rcx
  802811:	74 0c                	je     80281f <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  802813:	fc                   	cld
  802814:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802817:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  80281b:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  80281f:	4d 85 c9             	test   %r9,%r9
  802822:	75 45                	jne    802869 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  802824:	4c 89 c0             	mov    %r8,%rax
  802827:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  802828:	48 85 d2             	test   %rdx,%rdx
  80282b:	74 f7                	je     802824 <memset+0x4a>
  80282d:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  802830:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  802833:	48 83 c0 01          	add    $0x1,%rax
  802837:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  80283b:	48 39 c2             	cmp    %rax,%rdx
  80283e:	75 f3                	jne    802833 <memset+0x59>
  802840:	eb e2                	jmp    802824 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  802842:	40 f6 c7 01          	test   $0x1,%dil
  802846:	74 06                	je     80284e <memset+0x74>
  802848:	88 07                	mov    %al,(%rdi)
  80284a:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  80284e:	40 f6 c7 02          	test   $0x2,%dil
  802852:	74 07                	je     80285b <memset+0x81>
  802854:	66 89 07             	mov    %ax,(%rdi)
  802857:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  80285b:	40 f6 c7 04          	test   $0x4,%dil
  80285f:	74 a9                	je     80280a <memset+0x30>
  802861:	89 07                	mov    %eax,(%rdi)
  802863:	48 83 c7 04          	add    $0x4,%rdi
  802867:	eb a1                	jmp    80280a <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  802869:	41 f6 c1 04          	test   $0x4,%r9b
  80286d:	74 1b                	je     80288a <memset+0xb0>
  80286f:	89 07                	mov    %eax,(%rdi)
  802871:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  802875:	41 f6 c1 02          	test   $0x2,%r9b
  802879:	74 07                	je     802882 <memset+0xa8>
  80287b:	66 89 07             	mov    %ax,(%rdi)
  80287e:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  802882:	41 f6 c1 01          	test   $0x1,%r9b
  802886:	74 9c                	je     802824 <memset+0x4a>
  802888:	eb 06                	jmp    802890 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80288a:	41 f6 c1 02          	test   $0x2,%r9b
  80288e:	75 eb                	jne    80287b <memset+0xa1>
        if (ni & 1) *ptr = k;
  802890:	88 07                	mov    %al,(%rdi)
  802892:	eb 90                	jmp    802824 <memset+0x4a>

0000000000802894 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  802894:	f3 0f 1e fa          	endbr64
  802898:	48 89 f8             	mov    %rdi,%rax
  80289b:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  80289e:	48 39 fe             	cmp    %rdi,%rsi
  8028a1:	73 3b                	jae    8028de <memmove+0x4a>
  8028a3:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8028a7:	48 39 d7             	cmp    %rdx,%rdi
  8028aa:	73 32                	jae    8028de <memmove+0x4a>
        s += n;
        d += n;
  8028ac:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028b0:	48 89 d6             	mov    %rdx,%rsi
  8028b3:	48 09 fe             	or     %rdi,%rsi
  8028b6:	48 09 ce             	or     %rcx,%rsi
  8028b9:	40 f6 c6 07          	test   $0x7,%sil
  8028bd:	75 12                	jne    8028d1 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8028bf:	48 83 ef 08          	sub    $0x8,%rdi
  8028c3:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8028c7:	48 c1 e9 03          	shr    $0x3,%rcx
  8028cb:	fd                   	std
  8028cc:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8028cf:	fc                   	cld
  8028d0:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8028d1:	48 83 ef 01          	sub    $0x1,%rdi
  8028d5:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8028d9:	fd                   	std
  8028da:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8028dc:	eb f1                	jmp    8028cf <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028de:	48 89 f2             	mov    %rsi,%rdx
  8028e1:	48 09 c2             	or     %rax,%rdx
  8028e4:	48 09 ca             	or     %rcx,%rdx
  8028e7:	f6 c2 07             	test   $0x7,%dl
  8028ea:	75 0c                	jne    8028f8 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8028ec:	48 c1 e9 03          	shr    $0x3,%rcx
  8028f0:	48 89 c7             	mov    %rax,%rdi
  8028f3:	fc                   	cld
  8028f4:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8028f7:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8028f8:	48 89 c7             	mov    %rax,%rdi
  8028fb:	fc                   	cld
  8028fc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8028fe:	c3                   	ret

00000000008028ff <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8028ff:	f3 0f 1e fa          	endbr64
  802903:	55                   	push   %rbp
  802904:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802907:	48 b8 94 28 80 00 00 	movabs $0x802894,%rax
  80290e:	00 00 00 
  802911:	ff d0                	call   *%rax
}
  802913:	5d                   	pop    %rbp
  802914:	c3                   	ret

0000000000802915 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  802915:	f3 0f 1e fa          	endbr64
  802919:	55                   	push   %rbp
  80291a:	48 89 e5             	mov    %rsp,%rbp
  80291d:	41 57                	push   %r15
  80291f:	41 56                	push   %r14
  802921:	41 55                	push   %r13
  802923:	41 54                	push   %r12
  802925:	53                   	push   %rbx
  802926:	48 83 ec 08          	sub    $0x8,%rsp
  80292a:	49 89 fe             	mov    %rdi,%r14
  80292d:	49 89 f7             	mov    %rsi,%r15
  802930:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  802933:	48 89 f7             	mov    %rsi,%rdi
  802936:	48 b8 34 26 80 00 00 	movabs $0x802634,%rax
  80293d:	00 00 00 
  802940:	ff d0                	call   *%rax
  802942:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  802945:	48 89 de             	mov    %rbx,%rsi
  802948:	4c 89 f7             	mov    %r14,%rdi
  80294b:	48 b8 53 26 80 00 00 	movabs $0x802653,%rax
  802952:	00 00 00 
  802955:	ff d0                	call   *%rax
  802957:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80295a:	48 39 c3             	cmp    %rax,%rbx
  80295d:	74 36                	je     802995 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  80295f:	48 89 d8             	mov    %rbx,%rax
  802962:	4c 29 e8             	sub    %r13,%rax
  802965:	49 39 c4             	cmp    %rax,%r12
  802968:	73 31                	jae    80299b <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  80296a:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  80296f:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  802973:	4c 89 fe             	mov    %r15,%rsi
  802976:	48 b8 ff 28 80 00 00 	movabs $0x8028ff,%rax
  80297d:	00 00 00 
  802980:	ff d0                	call   *%rax
    return dstlen + srclen;
  802982:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  802986:	48 83 c4 08          	add    $0x8,%rsp
  80298a:	5b                   	pop    %rbx
  80298b:	41 5c                	pop    %r12
  80298d:	41 5d                	pop    %r13
  80298f:	41 5e                	pop    %r14
  802991:	41 5f                	pop    %r15
  802993:	5d                   	pop    %rbp
  802994:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  802995:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  802999:	eb eb                	jmp    802986 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  80299b:	48 83 eb 01          	sub    $0x1,%rbx
  80299f:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8029a3:	48 89 da             	mov    %rbx,%rdx
  8029a6:	4c 89 fe             	mov    %r15,%rsi
  8029a9:	48 b8 ff 28 80 00 00 	movabs $0x8028ff,%rax
  8029b0:	00 00 00 
  8029b3:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8029b5:	49 01 de             	add    %rbx,%r14
  8029b8:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8029bd:	eb c3                	jmp    802982 <strlcat+0x6d>

00000000008029bf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8029bf:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8029c3:	48 85 d2             	test   %rdx,%rdx
  8029c6:	74 2d                	je     8029f5 <memcmp+0x36>
  8029c8:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8029cd:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8029d1:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8029d6:	44 38 c1             	cmp    %r8b,%cl
  8029d9:	75 0f                	jne    8029ea <memcmp+0x2b>
    while (n-- > 0) {
  8029db:	48 83 c0 01          	add    $0x1,%rax
  8029df:	48 39 c2             	cmp    %rax,%rdx
  8029e2:	75 e9                	jne    8029cd <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8029e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e9:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8029ea:	0f b6 c1             	movzbl %cl,%eax
  8029ed:	45 0f b6 c0          	movzbl %r8b,%r8d
  8029f1:	44 29 c0             	sub    %r8d,%eax
  8029f4:	c3                   	ret
    return 0;
  8029f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029fa:	c3                   	ret

00000000008029fb <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8029fb:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  8029ff:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802a03:	48 39 c7             	cmp    %rax,%rdi
  802a06:	73 0f                	jae    802a17 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802a08:	40 38 37             	cmp    %sil,(%rdi)
  802a0b:	74 0e                	je     802a1b <memfind+0x20>
    for (; src < end; src++) {
  802a0d:	48 83 c7 01          	add    $0x1,%rdi
  802a11:	48 39 f8             	cmp    %rdi,%rax
  802a14:	75 f2                	jne    802a08 <memfind+0xd>
  802a16:	c3                   	ret
  802a17:	48 89 f8             	mov    %rdi,%rax
  802a1a:	c3                   	ret
  802a1b:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802a1e:	c3                   	ret

0000000000802a1f <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802a1f:	f3 0f 1e fa          	endbr64
  802a23:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802a26:	0f b6 37             	movzbl (%rdi),%esi
  802a29:	40 80 fe 20          	cmp    $0x20,%sil
  802a2d:	74 06                	je     802a35 <strtol+0x16>
  802a2f:	40 80 fe 09          	cmp    $0x9,%sil
  802a33:	75 13                	jne    802a48 <strtol+0x29>
  802a35:	48 83 c7 01          	add    $0x1,%rdi
  802a39:	0f b6 37             	movzbl (%rdi),%esi
  802a3c:	40 80 fe 20          	cmp    $0x20,%sil
  802a40:	74 f3                	je     802a35 <strtol+0x16>
  802a42:	40 80 fe 09          	cmp    $0x9,%sil
  802a46:	74 ed                	je     802a35 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802a48:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802a4b:	83 e0 fd             	and    $0xfffffffd,%eax
  802a4e:	3c 01                	cmp    $0x1,%al
  802a50:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a54:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  802a5a:	75 0f                	jne    802a6b <strtol+0x4c>
  802a5c:	80 3f 30             	cmpb   $0x30,(%rdi)
  802a5f:	74 14                	je     802a75 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802a61:	85 d2                	test   %edx,%edx
  802a63:	b8 0a 00 00 00       	mov    $0xa,%eax
  802a68:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  802a6b:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  802a70:	4c 63 ca             	movslq %edx,%r9
  802a73:	eb 36                	jmp    802aab <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a75:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  802a79:	74 0f                	je     802a8a <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  802a7b:	85 d2                	test   %edx,%edx
  802a7d:	75 ec                	jne    802a6b <strtol+0x4c>
        s++;
  802a7f:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  802a83:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  802a88:	eb e1                	jmp    802a6b <strtol+0x4c>
        s += 2;
  802a8a:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  802a8e:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  802a93:	eb d6                	jmp    802a6b <strtol+0x4c>
            dig -= '0';
  802a95:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  802a98:	44 0f b6 c1          	movzbl %cl,%r8d
  802a9c:	41 39 d0             	cmp    %edx,%r8d
  802a9f:	7d 21                	jge    802ac2 <strtol+0xa3>
        val = val * base + dig;
  802aa1:	49 0f af c1          	imul   %r9,%rax
  802aa5:	0f b6 c9             	movzbl %cl,%ecx
  802aa8:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  802aab:	48 83 c7 01          	add    $0x1,%rdi
  802aaf:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  802ab3:	80 f9 39             	cmp    $0x39,%cl
  802ab6:	76 dd                	jbe    802a95 <strtol+0x76>
        else if (dig - 'a' < 27)
  802ab8:	80 f9 7b             	cmp    $0x7b,%cl
  802abb:	77 05                	ja     802ac2 <strtol+0xa3>
            dig -= 'a' - 10;
  802abd:	83 e9 57             	sub    $0x57,%ecx
  802ac0:	eb d6                	jmp    802a98 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  802ac2:	4d 85 d2             	test   %r10,%r10
  802ac5:	74 03                	je     802aca <strtol+0xab>
  802ac7:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802aca:	48 89 c2             	mov    %rax,%rdx
  802acd:	48 f7 da             	neg    %rdx
  802ad0:	40 80 fe 2d          	cmp    $0x2d,%sil
  802ad4:	48 0f 44 c2          	cmove  %rdx,%rax
}
  802ad8:	c3                   	ret

0000000000802ad9 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802ad9:	f3 0f 1e fa          	endbr64
  802add:	55                   	push   %rbp
  802ade:	48 89 e5             	mov    %rsp,%rbp
  802ae1:	41 54                	push   %r12
  802ae3:	53                   	push   %rbx
  802ae4:	48 89 fb             	mov    %rdi,%rbx
  802ae7:	48 89 f7             	mov    %rsi,%rdi
  802aea:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802aed:	48 85 f6             	test   %rsi,%rsi
  802af0:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802af7:	00 00 00 
  802afa:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802afe:	be 00 10 00 00       	mov    $0x1000,%esi
  802b03:	48 b8 cb 05 80 00 00 	movabs $0x8005cb,%rax
  802b0a:	00 00 00 
  802b0d:	ff d0                	call   *%rax
    if (res < 0) {
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	78 45                	js     802b58 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b13:	48 85 db             	test   %rbx,%rbx
  802b16:	74 12                	je     802b2a <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b18:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b1f:	00 00 00 
  802b22:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b28:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b2a:	4d 85 e4             	test   %r12,%r12
  802b2d:	74 14                	je     802b43 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b2f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b36:	00 00 00 
  802b39:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b3f:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b43:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b4a:	00 00 00 
  802b4d:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b53:	5b                   	pop    %rbx
  802b54:	41 5c                	pop    %r12
  802b56:	5d                   	pop    %rbp
  802b57:	c3                   	ret
        if (from_env_store != NULL) {
  802b58:	48 85 db             	test   %rbx,%rbx
  802b5b:	74 06                	je     802b63 <ipc_recv+0x8a>
            *from_env_store = 0;
  802b5d:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b63:	4d 85 e4             	test   %r12,%r12
  802b66:	74 eb                	je     802b53 <ipc_recv+0x7a>
            *perm_store = 0;
  802b68:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b6f:	00 
  802b70:	eb e1                	jmp    802b53 <ipc_recv+0x7a>

0000000000802b72 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b72:	f3 0f 1e fa          	endbr64
  802b76:	55                   	push   %rbp
  802b77:	48 89 e5             	mov    %rsp,%rbp
  802b7a:	41 57                	push   %r15
  802b7c:	41 56                	push   %r14
  802b7e:	41 55                	push   %r13
  802b80:	41 54                	push   %r12
  802b82:	53                   	push   %rbx
  802b83:	48 83 ec 18          	sub    $0x18,%rsp
  802b87:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802b8a:	48 89 d3             	mov    %rdx,%rbx
  802b8d:	49 89 cc             	mov    %rcx,%r12
  802b90:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b93:	48 85 d2             	test   %rdx,%rdx
  802b96:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b9d:	00 00 00 
  802ba0:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802ba4:	89 f0                	mov    %esi,%eax
  802ba6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802baa:	48 89 da             	mov    %rbx,%rdx
  802bad:	48 89 c6             	mov    %rax,%rsi
  802bb0:	48 b8 9b 05 80 00 00 	movabs $0x80059b,%rax
  802bb7:	00 00 00 
  802bba:	ff d0                	call   *%rax
    while (res < 0) {
  802bbc:	85 c0                	test   %eax,%eax
  802bbe:	79 65                	jns    802c25 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bc0:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bc3:	75 33                	jne    802bf8 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802bc5:	49 bf 0e 02 80 00 00 	movabs $0x80020e,%r15
  802bcc:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bcf:	49 be 9b 05 80 00 00 	movabs $0x80059b,%r14
  802bd6:	00 00 00 
        sys_yield();
  802bd9:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bdc:	45 89 e8             	mov    %r13d,%r8d
  802bdf:	4c 89 e1             	mov    %r12,%rcx
  802be2:	48 89 da             	mov    %rbx,%rdx
  802be5:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802be9:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802bec:	41 ff d6             	call   *%r14
    while (res < 0) {
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	79 32                	jns    802c25 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bf3:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bf6:	74 e1                	je     802bd9 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802bf8:	89 c1                	mov    %eax,%ecx
  802bfa:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  802c01:	00 00 00 
  802c04:	be 42 00 00 00       	mov    $0x42,%esi
  802c09:	48 bf 4b 32 80 00 00 	movabs $0x80324b,%rdi
  802c10:	00 00 00 
  802c13:	b8 00 00 00 00       	mov    $0x0,%eax
  802c18:	49 b8 d4 1b 80 00 00 	movabs $0x801bd4,%r8
  802c1f:	00 00 00 
  802c22:	41 ff d0             	call   *%r8
    }
}
  802c25:	48 83 c4 18          	add    $0x18,%rsp
  802c29:	5b                   	pop    %rbx
  802c2a:	41 5c                	pop    %r12
  802c2c:	41 5d                	pop    %r13
  802c2e:	41 5e                	pop    %r14
  802c30:	41 5f                	pop    %r15
  802c32:	5d                   	pop    %rbp
  802c33:	c3                   	ret

0000000000802c34 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c34:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c38:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c3d:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c44:	00 00 00 
  802c47:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c4b:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c4f:	48 c1 e2 04          	shl    $0x4,%rdx
  802c53:	48 01 ca             	add    %rcx,%rdx
  802c56:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c5c:	39 fa                	cmp    %edi,%edx
  802c5e:	74 12                	je     802c72 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c60:	48 83 c0 01          	add    $0x1,%rax
  802c64:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c6a:	75 db                	jne    802c47 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802c6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c71:	c3                   	ret
            return envs[i].env_id;
  802c72:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c76:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c7a:	48 c1 e2 04          	shl    $0x4,%rdx
  802c7e:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802c85:	00 00 00 
  802c88:	48 01 d0             	add    %rdx,%rax
  802c8b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c91:	c3                   	ret

0000000000802c92 <__text_end>:
  802c92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802c99:	00 00 00 
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
