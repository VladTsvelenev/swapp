
obj/user/implicitconv:     file format elf64-x86-64


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
  80001e:	e8 11 00 00 00       	call   800034 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <signed_impl_conv>:
/* Test for UBSAN support - implicit conversion */

#include <inc/lib.h>

void
signed_impl_conv() {
  800025:	f3 0f 1e fa          	endbr64
    a = 257;
    char c = a;

    (void)b;
    (void)c;
}
  800029:	c3                   	ret

000000000080002a <unsigned_impl_conv>:

void
unsigned_impl_conv() {
  80002a:	f3 0f 1e fa          	endbr64
    unsigned long long a = 400000000000;
    unsigned int b = a;

    (void)b;
}
  80002e:	c3                   	ret

000000000080002f <umain>:

void
umain(int argc, char **argv) {
  80002f:	f3 0f 1e fa          	endbr64
    signed_impl_conv();
    unsigned_impl_conv();
}
  800033:	c3                   	ret

0000000000800034 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800034:	f3 0f 1e fa          	endbr64
  800038:	55                   	push   %rbp
  800039:	48 89 e5             	mov    %rsp,%rbp
  80003c:	41 56                	push   %r14
  80003e:	41 55                	push   %r13
  800040:	41 54                	push   %r12
  800042:	53                   	push   %rbx
  800043:	41 89 fd             	mov    %edi,%r13d
  800046:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800049:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800050:	00 00 00 
  800053:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80005a:	00 00 00 
  80005d:	48 39 c2             	cmp    %rax,%rdx
  800060:	73 17                	jae    800079 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800062:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800065:	49 89 c4             	mov    %rax,%r12
  800068:	48 83 c3 08          	add    $0x8,%rbx
  80006c:	b8 00 00 00 00       	mov    $0x0,%eax
  800071:	ff 53 f8             	call   *-0x8(%rbx)
  800074:	4c 39 e3             	cmp    %r12,%rbx
  800077:	72 ef                	jb     800068 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800079:	48 b8 e2 01 80 00 00 	movabs $0x8001e2,%rax
  800080:	00 00 00 
  800083:	ff d0                	call   *%rax
  800085:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008a:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80008e:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800092:	48 c1 e0 04          	shl    $0x4,%rax
  800096:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  80009d:	00 00 00 
  8000a0:	48 01 d0             	add    %rdx,%rax
  8000a3:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000aa:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000ad:	45 85 ed             	test   %r13d,%r13d
  8000b0:	7e 0d                	jle    8000bf <libmain+0x8b>
  8000b2:	49 8b 06             	mov    (%r14),%rax
  8000b5:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000bc:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000bf:	4c 89 f6             	mov    %r14,%rsi
  8000c2:	44 89 ef             	mov    %r13d,%edi
  8000c5:	48 b8 2f 00 80 00 00 	movabs $0x80002f,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000d1:	48 b8 e6 00 80 00 00 	movabs $0x8000e6,%rax
  8000d8:	00 00 00 
  8000db:	ff d0                	call   *%rax
#endif
}
  8000dd:	5b                   	pop    %rbx
  8000de:	41 5c                	pop    %r12
  8000e0:	41 5d                	pop    %r13
  8000e2:	41 5e                	pop    %r14
  8000e4:	5d                   	pop    %rbp
  8000e5:	c3                   	ret

00000000008000e6 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000e6:	f3 0f 1e fa          	endbr64
  8000ea:	55                   	push   %rbp
  8000eb:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000ee:	48 b8 b8 08 80 00 00 	movabs $0x8008b8,%rax
  8000f5:	00 00 00 
  8000f8:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8000fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ff:	48 b8 73 01 80 00 00 	movabs $0x800173,%rax
  800106:	00 00 00 
  800109:	ff d0                	call   *%rax
}
  80010b:	5d                   	pop    %rbp
  80010c:	c3                   	ret

000000000080010d <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80010d:	f3 0f 1e fa          	endbr64
  800111:	55                   	push   %rbp
  800112:	48 89 e5             	mov    %rsp,%rbp
  800115:	53                   	push   %rbx
  800116:	48 89 fa             	mov    %rdi,%rdx
  800119:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80011c:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800121:	bb 00 00 00 00       	mov    $0x0,%ebx
  800126:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80012b:	be 00 00 00 00       	mov    $0x0,%esi
  800130:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800136:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800138:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80013c:	c9                   	leave
  80013d:	c3                   	ret

000000000080013e <sys_cgetc>:

int
sys_cgetc(void) {
  80013e:	f3 0f 1e fa          	endbr64
  800142:	55                   	push   %rbp
  800143:	48 89 e5             	mov    %rsp,%rbp
  800146:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800147:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80014c:	ba 00 00 00 00       	mov    $0x0,%edx
  800151:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800156:	bb 00 00 00 00       	mov    $0x0,%ebx
  80015b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800160:	be 00 00 00 00       	mov    $0x0,%esi
  800165:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80016b:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80016d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800171:	c9                   	leave
  800172:	c3                   	ret

0000000000800173 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800173:	f3 0f 1e fa          	endbr64
  800177:	55                   	push   %rbp
  800178:	48 89 e5             	mov    %rsp,%rbp
  80017b:	53                   	push   %rbx
  80017c:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800180:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800183:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800188:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80018d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800192:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800197:	be 00 00 00 00       	mov    $0x0,%esi
  80019c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001a2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001a4:	48 85 c0             	test   %rax,%rax
  8001a7:	7f 06                	jg     8001af <sys_env_destroy+0x3c>
}
  8001a9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001ad:	c9                   	leave
  8001ae:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001af:	49 89 c0             	mov    %rax,%r8
  8001b2:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001b7:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8001be:	00 00 00 
  8001c1:	be 26 00 00 00       	mov    $0x26,%esi
  8001c6:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8001cd:	00 00 00 
  8001d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d5:	49 b9 dd 1b 80 00 00 	movabs $0x801bdd,%r9
  8001dc:	00 00 00 
  8001df:	41 ff d1             	call   *%r9

00000000008001e2 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001e2:	f3 0f 1e fa          	endbr64
  8001e6:	55                   	push   %rbp
  8001e7:	48 89 e5             	mov    %rsp,%rbp
  8001ea:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001eb:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8001f5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ff:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800204:	be 00 00 00 00       	mov    $0x0,%esi
  800209:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80020f:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800211:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800215:	c9                   	leave
  800216:	c3                   	ret

0000000000800217 <sys_yield>:

void
sys_yield(void) {
  800217:	f3 0f 1e fa          	endbr64
  80021b:	55                   	push   %rbp
  80021c:	48 89 e5             	mov    %rsp,%rbp
  80021f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800220:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800225:	ba 00 00 00 00       	mov    $0x0,%edx
  80022a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80022f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800234:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800239:	be 00 00 00 00       	mov    $0x0,%esi
  80023e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800244:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  800246:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80024a:	c9                   	leave
  80024b:	c3                   	ret

000000000080024c <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80024c:	f3 0f 1e fa          	endbr64
  800250:	55                   	push   %rbp
  800251:	48 89 e5             	mov    %rsp,%rbp
  800254:	53                   	push   %rbx
  800255:	48 89 fa             	mov    %rdi,%rdx
  800258:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80025b:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800260:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800267:	00 00 00 
  80026a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80026f:	be 00 00 00 00       	mov    $0x0,%esi
  800274:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80027a:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80027c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800280:	c9                   	leave
  800281:	c3                   	ret

0000000000800282 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  800282:	f3 0f 1e fa          	endbr64
  800286:	55                   	push   %rbp
  800287:	48 89 e5             	mov    %rsp,%rbp
  80028a:	53                   	push   %rbx
  80028b:	49 89 f8             	mov    %rdi,%r8
  80028e:	48 89 d3             	mov    %rdx,%rbx
  800291:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  800294:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800299:	4c 89 c2             	mov    %r8,%rdx
  80029c:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80029f:	be 00 00 00 00       	mov    $0x0,%esi
  8002a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002aa:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002ac:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002b0:	c9                   	leave
  8002b1:	c3                   	ret

00000000008002b2 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002b2:	f3 0f 1e fa          	endbr64
  8002b6:	55                   	push   %rbp
  8002b7:	48 89 e5             	mov    %rsp,%rbp
  8002ba:	53                   	push   %rbx
  8002bb:	48 83 ec 08          	sub    $0x8,%rsp
  8002bf:	89 f8                	mov    %edi,%eax
  8002c1:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002c4:	48 63 f9             	movslq %ecx,%rdi
  8002c7:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002ca:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002cf:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002d2:	be 00 00 00 00       	mov    $0x0,%esi
  8002d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002dd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002df:	48 85 c0             	test   %rax,%rax
  8002e2:	7f 06                	jg     8002ea <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002e4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002e8:	c9                   	leave
  8002e9:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002ea:	49 89 c0             	mov    %rax,%r8
  8002ed:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002f2:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8002f9:	00 00 00 
  8002fc:	be 26 00 00 00       	mov    $0x26,%esi
  800301:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800308:	00 00 00 
  80030b:	b8 00 00 00 00       	mov    $0x0,%eax
  800310:	49 b9 dd 1b 80 00 00 	movabs $0x801bdd,%r9
  800317:	00 00 00 
  80031a:	41 ff d1             	call   *%r9

000000000080031d <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80031d:	f3 0f 1e fa          	endbr64
  800321:	55                   	push   %rbp
  800322:	48 89 e5             	mov    %rsp,%rbp
  800325:	53                   	push   %rbx
  800326:	48 83 ec 08          	sub    $0x8,%rsp
  80032a:	89 f8                	mov    %edi,%eax
  80032c:	49 89 f2             	mov    %rsi,%r10
  80032f:	48 89 cf             	mov    %rcx,%rdi
  800332:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  800335:	48 63 da             	movslq %edx,%rbx
  800338:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80033b:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800340:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800343:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  800346:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800348:	48 85 c0             	test   %rax,%rax
  80034b:	7f 06                	jg     800353 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80034d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800351:	c9                   	leave
  800352:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800353:	49 89 c0             	mov    %rax,%r8
  800356:	b9 05 00 00 00       	mov    $0x5,%ecx
  80035b:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800362:	00 00 00 
  800365:	be 26 00 00 00       	mov    $0x26,%esi
  80036a:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800371:	00 00 00 
  800374:	b8 00 00 00 00       	mov    $0x0,%eax
  800379:	49 b9 dd 1b 80 00 00 	movabs $0x801bdd,%r9
  800380:	00 00 00 
  800383:	41 ff d1             	call   *%r9

0000000000800386 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  800386:	f3 0f 1e fa          	endbr64
  80038a:	55                   	push   %rbp
  80038b:	48 89 e5             	mov    %rsp,%rbp
  80038e:	53                   	push   %rbx
  80038f:	48 83 ec 08          	sub    $0x8,%rsp
  800393:	49 89 f9             	mov    %rdi,%r9
  800396:	89 f0                	mov    %esi,%eax
  800398:	48 89 d3             	mov    %rdx,%rbx
  80039b:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80039e:	49 63 f0             	movslq %r8d,%rsi
  8003a1:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8003a4:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8003a9:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003b2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003b4:	48 85 c0             	test   %rax,%rax
  8003b7:	7f 06                	jg     8003bf <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8003b9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003bd:	c9                   	leave
  8003be:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003bf:	49 89 c0             	mov    %rax,%r8
  8003c2:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003c7:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8003ce:	00 00 00 
  8003d1:	be 26 00 00 00       	mov    $0x26,%esi
  8003d6:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8003dd:	00 00 00 
  8003e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e5:	49 b9 dd 1b 80 00 00 	movabs $0x801bdd,%r9
  8003ec:	00 00 00 
  8003ef:	41 ff d1             	call   *%r9

00000000008003f2 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8003f2:	f3 0f 1e fa          	endbr64
  8003f6:	55                   	push   %rbp
  8003f7:	48 89 e5             	mov    %rsp,%rbp
  8003fa:	53                   	push   %rbx
  8003fb:	48 83 ec 08          	sub    $0x8,%rsp
  8003ff:	48 89 f1             	mov    %rsi,%rcx
  800402:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  800405:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800408:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80040d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800412:	be 00 00 00 00       	mov    $0x0,%esi
  800417:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80041d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80041f:	48 85 c0             	test   %rax,%rax
  800422:	7f 06                	jg     80042a <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  800424:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800428:	c9                   	leave
  800429:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80042a:	49 89 c0             	mov    %rax,%r8
  80042d:	b9 07 00 00 00       	mov    $0x7,%ecx
  800432:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800439:	00 00 00 
  80043c:	be 26 00 00 00       	mov    $0x26,%esi
  800441:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800448:	00 00 00 
  80044b:	b8 00 00 00 00       	mov    $0x0,%eax
  800450:	49 b9 dd 1b 80 00 00 	movabs $0x801bdd,%r9
  800457:	00 00 00 
  80045a:	41 ff d1             	call   *%r9

000000000080045d <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80045d:	f3 0f 1e fa          	endbr64
  800461:	55                   	push   %rbp
  800462:	48 89 e5             	mov    %rsp,%rbp
  800465:	53                   	push   %rbx
  800466:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80046a:	48 63 ce             	movslq %esi,%rcx
  80046d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800470:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800475:	bb 00 00 00 00       	mov    $0x0,%ebx
  80047a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80047f:	be 00 00 00 00       	mov    $0x0,%esi
  800484:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80048a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80048c:	48 85 c0             	test   %rax,%rax
  80048f:	7f 06                	jg     800497 <sys_env_set_status+0x3a>
}
  800491:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800495:	c9                   	leave
  800496:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800497:	49 89 c0             	mov    %rax,%r8
  80049a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80049f:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8004a6:	00 00 00 
  8004a9:	be 26 00 00 00       	mov    $0x26,%esi
  8004ae:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8004b5:	00 00 00 
  8004b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bd:	49 b9 dd 1b 80 00 00 	movabs $0x801bdd,%r9
  8004c4:	00 00 00 
  8004c7:	41 ff d1             	call   *%r9

00000000008004ca <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8004ca:	f3 0f 1e fa          	endbr64
  8004ce:	55                   	push   %rbp
  8004cf:	48 89 e5             	mov    %rsp,%rbp
  8004d2:	53                   	push   %rbx
  8004d3:	48 83 ec 08          	sub    $0x8,%rsp
  8004d7:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8004da:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004dd:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004e7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004ec:	be 00 00 00 00       	mov    $0x0,%esi
  8004f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004f7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004f9:	48 85 c0             	test   %rax,%rax
  8004fc:	7f 06                	jg     800504 <sys_env_set_trapframe+0x3a>
}
  8004fe:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800502:	c9                   	leave
  800503:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800504:	49 89 c0             	mov    %rax,%r8
  800507:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80050c:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800513:	00 00 00 
  800516:	be 26 00 00 00       	mov    $0x26,%esi
  80051b:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800522:	00 00 00 
  800525:	b8 00 00 00 00       	mov    $0x0,%eax
  80052a:	49 b9 dd 1b 80 00 00 	movabs $0x801bdd,%r9
  800531:	00 00 00 
  800534:	41 ff d1             	call   *%r9

0000000000800537 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  800537:	f3 0f 1e fa          	endbr64
  80053b:	55                   	push   %rbp
  80053c:	48 89 e5             	mov    %rsp,%rbp
  80053f:	53                   	push   %rbx
  800540:	48 83 ec 08          	sub    $0x8,%rsp
  800544:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  800547:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80054a:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80054f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800554:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800559:	be 00 00 00 00       	mov    $0x0,%esi
  80055e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800564:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800566:	48 85 c0             	test   %rax,%rax
  800569:	7f 06                	jg     800571 <sys_env_set_pgfault_upcall+0x3a>
}
  80056b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80056f:	c9                   	leave
  800570:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800571:	49 89 c0             	mov    %rax,%r8
  800574:	b9 0c 00 00 00       	mov    $0xc,%ecx
  800579:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800580:	00 00 00 
  800583:	be 26 00 00 00       	mov    $0x26,%esi
  800588:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80058f:	00 00 00 
  800592:	b8 00 00 00 00       	mov    $0x0,%eax
  800597:	49 b9 dd 1b 80 00 00 	movabs $0x801bdd,%r9
  80059e:	00 00 00 
  8005a1:	41 ff d1             	call   *%r9

00000000008005a4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8005a4:	f3 0f 1e fa          	endbr64
  8005a8:	55                   	push   %rbp
  8005a9:	48 89 e5             	mov    %rsp,%rbp
  8005ac:	53                   	push   %rbx
  8005ad:	89 f8                	mov    %edi,%eax
  8005af:	49 89 f1             	mov    %rsi,%r9
  8005b2:	48 89 d3             	mov    %rdx,%rbx
  8005b5:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8005b8:	49 63 f0             	movslq %r8d,%rsi
  8005bb:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8005be:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005c3:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005cc:	cd 30                	int    $0x30
}
  8005ce:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005d2:	c9                   	leave
  8005d3:	c3                   	ret

00000000008005d4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8005d4:	f3 0f 1e fa          	endbr64
  8005d8:	55                   	push   %rbp
  8005d9:	48 89 e5             	mov    %rsp,%rbp
  8005dc:	53                   	push   %rbx
  8005dd:	48 83 ec 08          	sub    $0x8,%rsp
  8005e1:	48 89 fa             	mov    %rdi,%rdx
  8005e4:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8005e7:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005f6:	be 00 00 00 00       	mov    $0x0,%esi
  8005fb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800601:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800603:	48 85 c0             	test   %rax,%rax
  800606:	7f 06                	jg     80060e <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800608:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80060c:	c9                   	leave
  80060d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80060e:	49 89 c0             	mov    %rax,%r8
  800611:	b9 0f 00 00 00       	mov    $0xf,%ecx
  800616:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80061d:	00 00 00 
  800620:	be 26 00 00 00       	mov    $0x26,%esi
  800625:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80062c:	00 00 00 
  80062f:	b8 00 00 00 00       	mov    $0x0,%eax
  800634:	49 b9 dd 1b 80 00 00 	movabs $0x801bdd,%r9
  80063b:	00 00 00 
  80063e:	41 ff d1             	call   *%r9

0000000000800641 <sys_gettime>:

int
sys_gettime(void) {
  800641:	f3 0f 1e fa          	endbr64
  800645:	55                   	push   %rbp
  800646:	48 89 e5             	mov    %rsp,%rbp
  800649:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80064a:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80064f:	ba 00 00 00 00       	mov    $0x0,%edx
  800654:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800659:	bb 00 00 00 00       	mov    $0x0,%ebx
  80065e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800663:	be 00 00 00 00       	mov    $0x0,%esi
  800668:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80066e:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  800670:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800674:	c9                   	leave
  800675:	c3                   	ret

0000000000800676 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  800676:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80067a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800681:	ff ff ff 
  800684:	48 01 f8             	add    %rdi,%rax
  800687:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80068b:	c3                   	ret

000000000080068c <fd2data>:

char *
fd2data(struct Fd *fd) {
  80068c:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800690:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800697:	ff ff ff 
  80069a:	48 01 f8             	add    %rdi,%rax
  80069d:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8006a1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8006a7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006ab:	c3                   	ret

00000000008006ac <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8006ac:	f3 0f 1e fa          	endbr64
  8006b0:	55                   	push   %rbp
  8006b1:	48 89 e5             	mov    %rsp,%rbp
  8006b4:	41 57                	push   %r15
  8006b6:	41 56                	push   %r14
  8006b8:	41 55                	push   %r13
  8006ba:	41 54                	push   %r12
  8006bc:	53                   	push   %rbx
  8006bd:	48 83 ec 08          	sub    $0x8,%rsp
  8006c1:	49 89 ff             	mov    %rdi,%r15
  8006c4:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8006c9:	49 bd 0b 18 80 00 00 	movabs $0x80180b,%r13
  8006d0:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8006d3:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8006d9:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8006dc:	48 89 df             	mov    %rbx,%rdi
  8006df:	41 ff d5             	call   *%r13
  8006e2:	83 e0 04             	and    $0x4,%eax
  8006e5:	74 17                	je     8006fe <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8006e7:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8006ee:	4c 39 f3             	cmp    %r14,%rbx
  8006f1:	75 e6                	jne    8006d9 <fd_alloc+0x2d>
  8006f3:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8006f9:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8006fe:	4d 89 27             	mov    %r12,(%r15)
}
  800701:	48 83 c4 08          	add    $0x8,%rsp
  800705:	5b                   	pop    %rbx
  800706:	41 5c                	pop    %r12
  800708:	41 5d                	pop    %r13
  80070a:	41 5e                	pop    %r14
  80070c:	41 5f                	pop    %r15
  80070e:	5d                   	pop    %rbp
  80070f:	c3                   	ret

0000000000800710 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  800710:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  800714:	83 ff 1f             	cmp    $0x1f,%edi
  800717:	77 39                	ja     800752 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  800719:	55                   	push   %rbp
  80071a:	48 89 e5             	mov    %rsp,%rbp
  80071d:	41 54                	push   %r12
  80071f:	53                   	push   %rbx
  800720:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  800723:	48 63 df             	movslq %edi,%rbx
  800726:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80072d:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800731:	48 89 df             	mov    %rbx,%rdi
  800734:	48 b8 0b 18 80 00 00 	movabs $0x80180b,%rax
  80073b:	00 00 00 
  80073e:	ff d0                	call   *%rax
  800740:	a8 04                	test   $0x4,%al
  800742:	74 14                	je     800758 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  800744:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  800748:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80074d:	5b                   	pop    %rbx
  80074e:	41 5c                	pop    %r12
  800750:	5d                   	pop    %rbp
  800751:	c3                   	ret
        return -E_INVAL;
  800752:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800757:	c3                   	ret
        return -E_INVAL;
  800758:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80075d:	eb ee                	jmp    80074d <fd_lookup+0x3d>

000000000080075f <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  80075f:	f3 0f 1e fa          	endbr64
  800763:	55                   	push   %rbp
  800764:	48 89 e5             	mov    %rsp,%rbp
  800767:	41 54                	push   %r12
  800769:	53                   	push   %rbx
  80076a:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  80076d:	48 b8 40 33 80 00 00 	movabs $0x803340,%rax
  800774:	00 00 00 
  800777:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  80077e:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  800781:	39 3b                	cmp    %edi,(%rbx)
  800783:	74 47                	je     8007cc <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  800785:	48 83 c0 08          	add    $0x8,%rax
  800789:	48 8b 18             	mov    (%rax),%rbx
  80078c:	48 85 db             	test   %rbx,%rbx
  80078f:	75 f0                	jne    800781 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800791:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800798:	00 00 00 
  80079b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8007a1:	89 fa                	mov    %edi,%edx
  8007a3:	48 bf 78 32 80 00 00 	movabs $0x803278,%rdi
  8007aa:	00 00 00 
  8007ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b2:	48 b9 39 1d 80 00 00 	movabs $0x801d39,%rcx
  8007b9:	00 00 00 
  8007bc:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8007be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8007c3:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8007c7:	5b                   	pop    %rbx
  8007c8:	41 5c                	pop    %r12
  8007ca:	5d                   	pop    %rbp
  8007cb:	c3                   	ret
            return 0;
  8007cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d1:	eb f0                	jmp    8007c3 <dev_lookup+0x64>

00000000008007d3 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8007d3:	f3 0f 1e fa          	endbr64
  8007d7:	55                   	push   %rbp
  8007d8:	48 89 e5             	mov    %rsp,%rbp
  8007db:	41 55                	push   %r13
  8007dd:	41 54                	push   %r12
  8007df:	53                   	push   %rbx
  8007e0:	48 83 ec 18          	sub    $0x18,%rsp
  8007e4:	48 89 fb             	mov    %rdi,%rbx
  8007e7:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8007ea:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8007f1:	ff ff ff 
  8007f4:	48 01 df             	add    %rbx,%rdi
  8007f7:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8007fb:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8007ff:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  800806:	00 00 00 
  800809:	ff d0                	call   *%rax
  80080b:	41 89 c5             	mov    %eax,%r13d
  80080e:	85 c0                	test   %eax,%eax
  800810:	78 06                	js     800818 <fd_close+0x45>
  800812:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  800816:	74 1a                	je     800832 <fd_close+0x5f>
        return (must_exist ? res : 0);
  800818:	45 84 e4             	test   %r12b,%r12b
  80081b:	b8 00 00 00 00       	mov    $0x0,%eax
  800820:	44 0f 44 e8          	cmove  %eax,%r13d
}
  800824:	44 89 e8             	mov    %r13d,%eax
  800827:	48 83 c4 18          	add    $0x18,%rsp
  80082b:	5b                   	pop    %rbx
  80082c:	41 5c                	pop    %r12
  80082e:	41 5d                	pop    %r13
  800830:	5d                   	pop    %rbp
  800831:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800832:	8b 3b                	mov    (%rbx),%edi
  800834:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800838:	48 b8 5f 07 80 00 00 	movabs $0x80075f,%rax
  80083f:	00 00 00 
  800842:	ff d0                	call   *%rax
  800844:	41 89 c5             	mov    %eax,%r13d
  800847:	85 c0                	test   %eax,%eax
  800849:	78 1b                	js     800866 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80084b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80084f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800853:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  800859:	48 85 c0             	test   %rax,%rax
  80085c:	74 08                	je     800866 <fd_close+0x93>
  80085e:	48 89 df             	mov    %rbx,%rdi
  800861:	ff d0                	call   *%rax
  800863:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  800866:	ba 00 10 00 00       	mov    $0x1000,%edx
  80086b:	48 89 de             	mov    %rbx,%rsi
  80086e:	bf 00 00 00 00       	mov    $0x0,%edi
  800873:	48 b8 f2 03 80 00 00 	movabs $0x8003f2,%rax
  80087a:	00 00 00 
  80087d:	ff d0                	call   *%rax
    return res;
  80087f:	eb a3                	jmp    800824 <fd_close+0x51>

0000000000800881 <close>:

int
close(int fdnum) {
  800881:	f3 0f 1e fa          	endbr64
  800885:	55                   	push   %rbp
  800886:	48 89 e5             	mov    %rsp,%rbp
  800889:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80088d:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800891:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  800898:	00 00 00 
  80089b:	ff d0                	call   *%rax
    if (res < 0) return res;
  80089d:	85 c0                	test   %eax,%eax
  80089f:	78 15                	js     8008b6 <close+0x35>

    return fd_close(fd, 1);
  8008a1:	be 01 00 00 00       	mov    $0x1,%esi
  8008a6:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8008aa:	48 b8 d3 07 80 00 00 	movabs $0x8007d3,%rax
  8008b1:	00 00 00 
  8008b4:	ff d0                	call   *%rax
}
  8008b6:	c9                   	leave
  8008b7:	c3                   	ret

00000000008008b8 <close_all>:

void
close_all(void) {
  8008b8:	f3 0f 1e fa          	endbr64
  8008bc:	55                   	push   %rbp
  8008bd:	48 89 e5             	mov    %rsp,%rbp
  8008c0:	41 54                	push   %r12
  8008c2:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8008c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008c8:	49 bc 81 08 80 00 00 	movabs $0x800881,%r12
  8008cf:	00 00 00 
  8008d2:	89 df                	mov    %ebx,%edi
  8008d4:	41 ff d4             	call   *%r12
  8008d7:	83 c3 01             	add    $0x1,%ebx
  8008da:	83 fb 20             	cmp    $0x20,%ebx
  8008dd:	75 f3                	jne    8008d2 <close_all+0x1a>
}
  8008df:	5b                   	pop    %rbx
  8008e0:	41 5c                	pop    %r12
  8008e2:	5d                   	pop    %rbp
  8008e3:	c3                   	ret

00000000008008e4 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8008e4:	f3 0f 1e fa          	endbr64
  8008e8:	55                   	push   %rbp
  8008e9:	48 89 e5             	mov    %rsp,%rbp
  8008ec:	41 57                	push   %r15
  8008ee:	41 56                	push   %r14
  8008f0:	41 55                	push   %r13
  8008f2:	41 54                	push   %r12
  8008f4:	53                   	push   %rbx
  8008f5:	48 83 ec 18          	sub    $0x18,%rsp
  8008f9:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8008fc:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  800900:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  800907:	00 00 00 
  80090a:	ff d0                	call   *%rax
  80090c:	89 c3                	mov    %eax,%ebx
  80090e:	85 c0                	test   %eax,%eax
  800910:	0f 88 b8 00 00 00    	js     8009ce <dup+0xea>
    close(newfdnum);
  800916:	44 89 e7             	mov    %r12d,%edi
  800919:	48 b8 81 08 80 00 00 	movabs $0x800881,%rax
  800920:	00 00 00 
  800923:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  800925:	4d 63 ec             	movslq %r12d,%r13
  800928:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  80092f:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  800933:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  800937:	4c 89 ff             	mov    %r15,%rdi
  80093a:	49 be 8c 06 80 00 00 	movabs $0x80068c,%r14
  800941:	00 00 00 
  800944:	41 ff d6             	call   *%r14
  800947:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  80094a:	4c 89 ef             	mov    %r13,%rdi
  80094d:	41 ff d6             	call   *%r14
  800950:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  800953:	48 89 df             	mov    %rbx,%rdi
  800956:	48 b8 0b 18 80 00 00 	movabs $0x80180b,%rax
  80095d:	00 00 00 
  800960:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  800962:	a8 04                	test   $0x4,%al
  800964:	74 2b                	je     800991 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  800966:	41 89 c1             	mov    %eax,%r9d
  800969:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80096f:	4c 89 f1             	mov    %r14,%rcx
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
  800977:	48 89 de             	mov    %rbx,%rsi
  80097a:	bf 00 00 00 00       	mov    $0x0,%edi
  80097f:	48 b8 1d 03 80 00 00 	movabs $0x80031d,%rax
  800986:	00 00 00 
  800989:	ff d0                	call   *%rax
  80098b:	89 c3                	mov    %eax,%ebx
  80098d:	85 c0                	test   %eax,%eax
  80098f:	78 4e                	js     8009df <dup+0xfb>
    }
    prot = get_prot(oldfd);
  800991:	4c 89 ff             	mov    %r15,%rdi
  800994:	48 b8 0b 18 80 00 00 	movabs $0x80180b,%rax
  80099b:	00 00 00 
  80099e:	ff d0                	call   *%rax
  8009a0:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8009a3:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8009a9:	4c 89 e9             	mov    %r13,%rcx
  8009ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b1:	4c 89 fe             	mov    %r15,%rsi
  8009b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8009b9:	48 b8 1d 03 80 00 00 	movabs $0x80031d,%rax
  8009c0:	00 00 00 
  8009c3:	ff d0                	call   *%rax
  8009c5:	89 c3                	mov    %eax,%ebx
  8009c7:	85 c0                	test   %eax,%eax
  8009c9:	78 14                	js     8009df <dup+0xfb>

    return newfdnum;
  8009cb:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8009ce:	89 d8                	mov    %ebx,%eax
  8009d0:	48 83 c4 18          	add    $0x18,%rsp
  8009d4:	5b                   	pop    %rbx
  8009d5:	41 5c                	pop    %r12
  8009d7:	41 5d                	pop    %r13
  8009d9:	41 5e                	pop    %r14
  8009db:	41 5f                	pop    %r15
  8009dd:	5d                   	pop    %rbp
  8009de:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8009df:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009e4:	4c 89 ee             	mov    %r13,%rsi
  8009e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8009ec:	49 bc f2 03 80 00 00 	movabs $0x8003f2,%r12
  8009f3:	00 00 00 
  8009f6:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8009f9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009fe:	4c 89 f6             	mov    %r14,%rsi
  800a01:	bf 00 00 00 00       	mov    $0x0,%edi
  800a06:	41 ff d4             	call   *%r12
    return res;
  800a09:	eb c3                	jmp    8009ce <dup+0xea>

0000000000800a0b <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800a0b:	f3 0f 1e fa          	endbr64
  800a0f:	55                   	push   %rbp
  800a10:	48 89 e5             	mov    %rsp,%rbp
  800a13:	41 56                	push   %r14
  800a15:	41 55                	push   %r13
  800a17:	41 54                	push   %r12
  800a19:	53                   	push   %rbx
  800a1a:	48 83 ec 10          	sub    $0x10,%rsp
  800a1e:	89 fb                	mov    %edi,%ebx
  800a20:	49 89 f4             	mov    %rsi,%r12
  800a23:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a26:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800a2a:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  800a31:	00 00 00 
  800a34:	ff d0                	call   *%rax
  800a36:	85 c0                	test   %eax,%eax
  800a38:	78 4c                	js     800a86 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a3a:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800a3e:	41 8b 3e             	mov    (%r14),%edi
  800a41:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800a45:	48 b8 5f 07 80 00 00 	movabs $0x80075f,%rax
  800a4c:	00 00 00 
  800a4f:	ff d0                	call   *%rax
  800a51:	85 c0                	test   %eax,%eax
  800a53:	78 35                	js     800a8a <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a55:	41 8b 46 08          	mov    0x8(%r14),%eax
  800a59:	83 e0 03             	and    $0x3,%eax
  800a5c:	83 f8 01             	cmp    $0x1,%eax
  800a5f:	74 2d                	je     800a8e <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800a61:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a65:	48 8b 40 10          	mov    0x10(%rax),%rax
  800a69:	48 85 c0             	test   %rax,%rax
  800a6c:	74 56                	je     800ac4 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  800a6e:	4c 89 ea             	mov    %r13,%rdx
  800a71:	4c 89 e6             	mov    %r12,%rsi
  800a74:	4c 89 f7             	mov    %r14,%rdi
  800a77:	ff d0                	call   *%rax
}
  800a79:	48 83 c4 10          	add    $0x10,%rsp
  800a7d:	5b                   	pop    %rbx
  800a7e:	41 5c                	pop    %r12
  800a80:	41 5d                	pop    %r13
  800a82:	41 5e                	pop    %r14
  800a84:	5d                   	pop    %rbp
  800a85:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a86:	48 98                	cltq
  800a88:	eb ef                	jmp    800a79 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a8a:	48 98                	cltq
  800a8c:	eb eb                	jmp    800a79 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800a8e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800a95:	00 00 00 
  800a98:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800a9e:	89 da                	mov    %ebx,%edx
  800aa0:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  800aa7:	00 00 00 
  800aaa:	b8 00 00 00 00       	mov    $0x0,%eax
  800aaf:	48 b9 39 1d 80 00 00 	movabs $0x801d39,%rcx
  800ab6:	00 00 00 
  800ab9:	ff d1                	call   *%rcx
        return -E_INVAL;
  800abb:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800ac2:	eb b5                	jmp    800a79 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800ac4:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800acb:	eb ac                	jmp    800a79 <read+0x6e>

0000000000800acd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800acd:	f3 0f 1e fa          	endbr64
  800ad1:	55                   	push   %rbp
  800ad2:	48 89 e5             	mov    %rsp,%rbp
  800ad5:	41 57                	push   %r15
  800ad7:	41 56                	push   %r14
  800ad9:	41 55                	push   %r13
  800adb:	41 54                	push   %r12
  800add:	53                   	push   %rbx
  800ade:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800ae2:	48 85 d2             	test   %rdx,%rdx
  800ae5:	74 54                	je     800b3b <readn+0x6e>
  800ae7:	41 89 fd             	mov    %edi,%r13d
  800aea:	49 89 f6             	mov    %rsi,%r14
  800aed:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800af0:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800af5:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800afa:	49 bf 0b 0a 80 00 00 	movabs $0x800a0b,%r15
  800b01:	00 00 00 
  800b04:	4c 89 e2             	mov    %r12,%rdx
  800b07:	48 29 f2             	sub    %rsi,%rdx
  800b0a:	4c 01 f6             	add    %r14,%rsi
  800b0d:	44 89 ef             	mov    %r13d,%edi
  800b10:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800b13:	85 c0                	test   %eax,%eax
  800b15:	78 20                	js     800b37 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  800b17:	01 c3                	add    %eax,%ebx
  800b19:	85 c0                	test   %eax,%eax
  800b1b:	74 08                	je     800b25 <readn+0x58>
  800b1d:	48 63 f3             	movslq %ebx,%rsi
  800b20:	4c 39 e6             	cmp    %r12,%rsi
  800b23:	72 df                	jb     800b04 <readn+0x37>
    }
    return res;
  800b25:	48 63 c3             	movslq %ebx,%rax
}
  800b28:	48 83 c4 08          	add    $0x8,%rsp
  800b2c:	5b                   	pop    %rbx
  800b2d:	41 5c                	pop    %r12
  800b2f:	41 5d                	pop    %r13
  800b31:	41 5e                	pop    %r14
  800b33:	41 5f                	pop    %r15
  800b35:	5d                   	pop    %rbp
  800b36:	c3                   	ret
        if (inc < 0) return inc;
  800b37:	48 98                	cltq
  800b39:	eb ed                	jmp    800b28 <readn+0x5b>
    int inc = 1, res = 0;
  800b3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b40:	eb e3                	jmp    800b25 <readn+0x58>

0000000000800b42 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800b42:	f3 0f 1e fa          	endbr64
  800b46:	55                   	push   %rbp
  800b47:	48 89 e5             	mov    %rsp,%rbp
  800b4a:	41 56                	push   %r14
  800b4c:	41 55                	push   %r13
  800b4e:	41 54                	push   %r12
  800b50:	53                   	push   %rbx
  800b51:	48 83 ec 10          	sub    $0x10,%rsp
  800b55:	89 fb                	mov    %edi,%ebx
  800b57:	49 89 f4             	mov    %rsi,%r12
  800b5a:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b5d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800b61:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  800b68:	00 00 00 
  800b6b:	ff d0                	call   *%rax
  800b6d:	85 c0                	test   %eax,%eax
  800b6f:	78 47                	js     800bb8 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b71:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800b75:	41 8b 3e             	mov    (%r14),%edi
  800b78:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800b7c:	48 b8 5f 07 80 00 00 	movabs $0x80075f,%rax
  800b83:	00 00 00 
  800b86:	ff d0                	call   *%rax
  800b88:	85 c0                	test   %eax,%eax
  800b8a:	78 30                	js     800bbc <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b8c:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  800b91:	74 2d                	je     800bc0 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800b93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b97:	48 8b 40 18          	mov    0x18(%rax),%rax
  800b9b:	48 85 c0             	test   %rax,%rax
  800b9e:	74 56                	je     800bf6 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  800ba0:	4c 89 ea             	mov    %r13,%rdx
  800ba3:	4c 89 e6             	mov    %r12,%rsi
  800ba6:	4c 89 f7             	mov    %r14,%rdi
  800ba9:	ff d0                	call   *%rax
}
  800bab:	48 83 c4 10          	add    $0x10,%rsp
  800baf:	5b                   	pop    %rbx
  800bb0:	41 5c                	pop    %r12
  800bb2:	41 5d                	pop    %r13
  800bb4:	41 5e                	pop    %r14
  800bb6:	5d                   	pop    %rbp
  800bb7:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800bb8:	48 98                	cltq
  800bba:	eb ef                	jmp    800bab <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bbc:	48 98                	cltq
  800bbe:	eb eb                	jmp    800bab <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800bc0:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bc7:	00 00 00 
  800bca:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800bd0:	89 da                	mov    %ebx,%edx
  800bd2:	48 bf 34 30 80 00 00 	movabs $0x803034,%rdi
  800bd9:	00 00 00 
  800bdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800be1:	48 b9 39 1d 80 00 00 	movabs $0x801d39,%rcx
  800be8:	00 00 00 
  800beb:	ff d1                	call   *%rcx
        return -E_INVAL;
  800bed:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800bf4:	eb b5                	jmp    800bab <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800bf6:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800bfd:	eb ac                	jmp    800bab <write+0x69>

0000000000800bff <seek>:

int
seek(int fdnum, off_t offset) {
  800bff:	f3 0f 1e fa          	endbr64
  800c03:	55                   	push   %rbp
  800c04:	48 89 e5             	mov    %rsp,%rbp
  800c07:	53                   	push   %rbx
  800c08:	48 83 ec 18          	sub    $0x18,%rsp
  800c0c:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c0e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c12:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  800c19:	00 00 00 
  800c1c:	ff d0                	call   *%rax
  800c1e:	85 c0                	test   %eax,%eax
  800c20:	78 0c                	js     800c2e <seek+0x2f>

    fd->fd_offset = offset;
  800c22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c26:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800c29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c2e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c32:	c9                   	leave
  800c33:	c3                   	ret

0000000000800c34 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800c34:	f3 0f 1e fa          	endbr64
  800c38:	55                   	push   %rbp
  800c39:	48 89 e5             	mov    %rsp,%rbp
  800c3c:	41 55                	push   %r13
  800c3e:	41 54                	push   %r12
  800c40:	53                   	push   %rbx
  800c41:	48 83 ec 18          	sub    $0x18,%rsp
  800c45:	89 fb                	mov    %edi,%ebx
  800c47:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c4a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800c4e:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  800c55:	00 00 00 
  800c58:	ff d0                	call   *%rax
  800c5a:	85 c0                	test   %eax,%eax
  800c5c:	78 38                	js     800c96 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c5e:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  800c62:	41 8b 7d 00          	mov    0x0(%r13),%edi
  800c66:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800c6a:	48 b8 5f 07 80 00 00 	movabs $0x80075f,%rax
  800c71:	00 00 00 
  800c74:	ff d0                	call   *%rax
  800c76:	85 c0                	test   %eax,%eax
  800c78:	78 1c                	js     800c96 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c7a:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  800c7f:	74 20                	je     800ca1 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c81:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c85:	48 8b 40 30          	mov    0x30(%rax),%rax
  800c89:	48 85 c0             	test   %rax,%rax
  800c8c:	74 47                	je     800cd5 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  800c8e:	44 89 e6             	mov    %r12d,%esi
  800c91:	4c 89 ef             	mov    %r13,%rdi
  800c94:	ff d0                	call   *%rax
}
  800c96:	48 83 c4 18          	add    $0x18,%rsp
  800c9a:	5b                   	pop    %rbx
  800c9b:	41 5c                	pop    %r12
  800c9d:	41 5d                	pop    %r13
  800c9f:	5d                   	pop    %rbp
  800ca0:	c3                   	ret
                thisenv->env_id, fdnum);
  800ca1:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800ca8:	00 00 00 
  800cab:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800cb1:	89 da                	mov    %ebx,%edx
  800cb3:	48 bf 98 32 80 00 00 	movabs $0x803298,%rdi
  800cba:	00 00 00 
  800cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc2:	48 b9 39 1d 80 00 00 	movabs $0x801d39,%rcx
  800cc9:	00 00 00 
  800ccc:	ff d1                	call   *%rcx
        return -E_INVAL;
  800cce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cd3:	eb c1                	jmp    800c96 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800cd5:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800cda:	eb ba                	jmp    800c96 <ftruncate+0x62>

0000000000800cdc <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800cdc:	f3 0f 1e fa          	endbr64
  800ce0:	55                   	push   %rbp
  800ce1:	48 89 e5             	mov    %rsp,%rbp
  800ce4:	41 54                	push   %r12
  800ce6:	53                   	push   %rbx
  800ce7:	48 83 ec 10          	sub    $0x10,%rsp
  800ceb:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800cee:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800cf2:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  800cf9:	00 00 00 
  800cfc:	ff d0                	call   *%rax
  800cfe:	85 c0                	test   %eax,%eax
  800d00:	78 4e                	js     800d50 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800d02:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  800d06:	41 8b 3c 24          	mov    (%r12),%edi
  800d0a:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800d0e:	48 b8 5f 07 80 00 00 	movabs $0x80075f,%rax
  800d15:	00 00 00 
  800d18:	ff d0                	call   *%rax
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	78 32                	js     800d50 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800d22:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800d27:	74 30                	je     800d59 <fstat+0x7d>

    stat->st_name[0] = 0;
  800d29:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800d2c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800d33:	00 00 00 
    stat->st_isdir = 0;
  800d36:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800d3d:	00 00 00 
    stat->st_dev = dev;
  800d40:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800d47:	48 89 de             	mov    %rbx,%rsi
  800d4a:	4c 89 e7             	mov    %r12,%rdi
  800d4d:	ff 50 28             	call   *0x28(%rax)
}
  800d50:	48 83 c4 10          	add    $0x10,%rsp
  800d54:	5b                   	pop    %rbx
  800d55:	41 5c                	pop    %r12
  800d57:	5d                   	pop    %rbp
  800d58:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d59:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800d5e:	eb f0                	jmp    800d50 <fstat+0x74>

0000000000800d60 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800d60:	f3 0f 1e fa          	endbr64
  800d64:	55                   	push   %rbp
  800d65:	48 89 e5             	mov    %rsp,%rbp
  800d68:	41 54                	push   %r12
  800d6a:	53                   	push   %rbx
  800d6b:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800d6e:	be 00 00 00 00       	mov    $0x0,%esi
  800d73:	48 b8 41 10 80 00 00 	movabs $0x801041,%rax
  800d7a:	00 00 00 
  800d7d:	ff d0                	call   *%rax
  800d7f:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800d81:	85 c0                	test   %eax,%eax
  800d83:	78 25                	js     800daa <stat+0x4a>

    int res = fstat(fd, stat);
  800d85:	4c 89 e6             	mov    %r12,%rsi
  800d88:	89 c7                	mov    %eax,%edi
  800d8a:	48 b8 dc 0c 80 00 00 	movabs $0x800cdc,%rax
  800d91:	00 00 00 
  800d94:	ff d0                	call   *%rax
  800d96:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800d99:	89 df                	mov    %ebx,%edi
  800d9b:	48 b8 81 08 80 00 00 	movabs $0x800881,%rax
  800da2:	00 00 00 
  800da5:	ff d0                	call   *%rax

    return res;
  800da7:	44 89 e3             	mov    %r12d,%ebx
}
  800daa:	89 d8                	mov    %ebx,%eax
  800dac:	5b                   	pop    %rbx
  800dad:	41 5c                	pop    %r12
  800daf:	5d                   	pop    %rbp
  800db0:	c3                   	ret

0000000000800db1 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800db1:	f3 0f 1e fa          	endbr64
  800db5:	55                   	push   %rbp
  800db6:	48 89 e5             	mov    %rsp,%rbp
  800db9:	41 54                	push   %r12
  800dbb:	53                   	push   %rbx
  800dbc:	48 83 ec 10          	sub    $0x10,%rsp
  800dc0:	41 89 fc             	mov    %edi,%r12d
  800dc3:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800dc6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800dcd:	00 00 00 
  800dd0:	83 38 00             	cmpl   $0x0,(%rax)
  800dd3:	74 6e                	je     800e43 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  800dd5:	bf 03 00 00 00       	mov    $0x3,%edi
  800dda:	48 b8 3d 2c 80 00 00 	movabs $0x802c3d,%rax
  800de1:	00 00 00 
  800de4:	ff d0                	call   *%rax
  800de6:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800ded:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800def:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800df5:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800dfa:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800e01:	00 00 00 
  800e04:	44 89 e6             	mov    %r12d,%esi
  800e07:	89 c7                	mov    %eax,%edi
  800e09:	48 b8 7b 2b 80 00 00 	movabs $0x802b7b,%rax
  800e10:	00 00 00 
  800e13:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800e15:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800e1c:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800e1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e22:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e26:	48 89 de             	mov    %rbx,%rsi
  800e29:	bf 00 00 00 00       	mov    $0x0,%edi
  800e2e:	48 b8 e2 2a 80 00 00 	movabs $0x802ae2,%rax
  800e35:	00 00 00 
  800e38:	ff d0                	call   *%rax
}
  800e3a:	48 83 c4 10          	add    $0x10,%rsp
  800e3e:	5b                   	pop    %rbx
  800e3f:	41 5c                	pop    %r12
  800e41:	5d                   	pop    %rbp
  800e42:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800e43:	bf 03 00 00 00       	mov    $0x3,%edi
  800e48:	48 b8 3d 2c 80 00 00 	movabs $0x802c3d,%rax
  800e4f:	00 00 00 
  800e52:	ff d0                	call   *%rax
  800e54:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e5b:	00 00 
  800e5d:	e9 73 ff ff ff       	jmp    800dd5 <fsipc+0x24>

0000000000800e62 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800e62:	f3 0f 1e fa          	endbr64
  800e66:	55                   	push   %rbp
  800e67:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800e6a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e71:	00 00 00 
  800e74:	8b 57 0c             	mov    0xc(%rdi),%edx
  800e77:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800e79:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800e7c:	be 00 00 00 00       	mov    $0x0,%esi
  800e81:	bf 02 00 00 00       	mov    $0x2,%edi
  800e86:	48 b8 b1 0d 80 00 00 	movabs $0x800db1,%rax
  800e8d:	00 00 00 
  800e90:	ff d0                	call   *%rax
}
  800e92:	5d                   	pop    %rbp
  800e93:	c3                   	ret

0000000000800e94 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800e94:	f3 0f 1e fa          	endbr64
  800e98:	55                   	push   %rbp
  800e99:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800e9c:	8b 47 0c             	mov    0xc(%rdi),%eax
  800e9f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ea6:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800ea8:	be 00 00 00 00       	mov    $0x0,%esi
  800ead:	bf 06 00 00 00       	mov    $0x6,%edi
  800eb2:	48 b8 b1 0d 80 00 00 	movabs $0x800db1,%rax
  800eb9:	00 00 00 
  800ebc:	ff d0                	call   *%rax
}
  800ebe:	5d                   	pop    %rbp
  800ebf:	c3                   	ret

0000000000800ec0 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800ec0:	f3 0f 1e fa          	endbr64
  800ec4:	55                   	push   %rbp
  800ec5:	48 89 e5             	mov    %rsp,%rbp
  800ec8:	41 54                	push   %r12
  800eca:	53                   	push   %rbx
  800ecb:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ece:	8b 47 0c             	mov    0xc(%rdi),%eax
  800ed1:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ed8:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800eda:	be 00 00 00 00       	mov    $0x0,%esi
  800edf:	bf 05 00 00 00       	mov    $0x5,%edi
  800ee4:	48 b8 b1 0d 80 00 00 	movabs $0x800db1,%rax
  800eeb:	00 00 00 
  800eee:	ff d0                	call   *%rax
    if (res < 0) return res;
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	78 3d                	js     800f31 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800ef4:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  800efb:	00 00 00 
  800efe:	4c 89 e6             	mov    %r12,%rsi
  800f01:	48 89 df             	mov    %rbx,%rdi
  800f04:	48 b8 82 26 80 00 00 	movabs $0x802682,%rax
  800f0b:	00 00 00 
  800f0e:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800f10:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  800f17:	00 
  800f18:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800f1e:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  800f25:	00 
  800f26:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800f2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f31:	5b                   	pop    %rbx
  800f32:	41 5c                	pop    %r12
  800f34:	5d                   	pop    %rbp
  800f35:	c3                   	ret

0000000000800f36 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f36:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  800f3a:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  800f41:	77 41                	ja     800f84 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f43:	55                   	push   %rbp
  800f44:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  800f47:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f4e:	00 00 00 
  800f51:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f54:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  800f56:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  800f5a:	48 8d 78 10          	lea    0x10(%rax),%rdi
  800f5e:	48 b8 9d 28 80 00 00 	movabs $0x80289d,%rax
  800f65:	00 00 00 
  800f68:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  800f6a:	be 00 00 00 00       	mov    $0x0,%esi
  800f6f:	bf 04 00 00 00       	mov    $0x4,%edi
  800f74:	48 b8 b1 0d 80 00 00 	movabs $0x800db1,%rax
  800f7b:	00 00 00 
  800f7e:	ff d0                	call   *%rax
  800f80:	48 98                	cltq
}
  800f82:	5d                   	pop    %rbp
  800f83:	c3                   	ret
        return -E_INVAL;
  800f84:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  800f8b:	c3                   	ret

0000000000800f8c <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800f8c:	f3 0f 1e fa          	endbr64
  800f90:	55                   	push   %rbp
  800f91:	48 89 e5             	mov    %rsp,%rbp
  800f94:	41 55                	push   %r13
  800f96:	41 54                	push   %r12
  800f98:	53                   	push   %rbx
  800f99:	48 83 ec 08          	sub    $0x8,%rsp
  800f9d:	49 89 f4             	mov    %rsi,%r12
  800fa0:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800fa3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800faa:	00 00 00 
  800fad:	8b 57 0c             	mov    0xc(%rdi),%edx
  800fb0:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  800fb2:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  800fb6:	be 00 00 00 00       	mov    $0x0,%esi
  800fbb:	bf 03 00 00 00       	mov    $0x3,%edi
  800fc0:	48 b8 b1 0d 80 00 00 	movabs $0x800db1,%rax
  800fc7:	00 00 00 
  800fca:	ff d0                	call   *%rax
  800fcc:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  800fcf:	4d 85 ed             	test   %r13,%r13
  800fd2:	78 2a                	js     800ffe <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  800fd4:	4c 89 ea             	mov    %r13,%rdx
  800fd7:	4c 39 eb             	cmp    %r13,%rbx
  800fda:	72 30                	jb     80100c <devfile_read+0x80>
  800fdc:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  800fe3:	7f 27                	jg     80100c <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  800fe5:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800fec:	00 00 00 
  800fef:	4c 89 e7             	mov    %r12,%rdi
  800ff2:	48 b8 9d 28 80 00 00 	movabs $0x80289d,%rax
  800ff9:	00 00 00 
  800ffc:	ff d0                	call   *%rax
}
  800ffe:	4c 89 e8             	mov    %r13,%rax
  801001:	48 83 c4 08          	add    $0x8,%rsp
  801005:	5b                   	pop    %rbx
  801006:	41 5c                	pop    %r12
  801008:	41 5d                	pop    %r13
  80100a:	5d                   	pop    %rbp
  80100b:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  80100c:	48 b9 51 30 80 00 00 	movabs $0x803051,%rcx
  801013:	00 00 00 
  801016:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  80101d:	00 00 00 
  801020:	be 7b 00 00 00       	mov    $0x7b,%esi
  801025:	48 bf 83 30 80 00 00 	movabs $0x803083,%rdi
  80102c:	00 00 00 
  80102f:	b8 00 00 00 00       	mov    $0x0,%eax
  801034:	49 b8 dd 1b 80 00 00 	movabs $0x801bdd,%r8
  80103b:	00 00 00 
  80103e:	41 ff d0             	call   *%r8

0000000000801041 <open>:
open(const char *path, int mode) {
  801041:	f3 0f 1e fa          	endbr64
  801045:	55                   	push   %rbp
  801046:	48 89 e5             	mov    %rsp,%rbp
  801049:	41 55                	push   %r13
  80104b:	41 54                	push   %r12
  80104d:	53                   	push   %rbx
  80104e:	48 83 ec 18          	sub    $0x18,%rsp
  801052:	49 89 fc             	mov    %rdi,%r12
  801055:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801058:	48 b8 3d 26 80 00 00 	movabs $0x80263d,%rax
  80105f:	00 00 00 
  801062:	ff d0                	call   *%rax
  801064:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80106a:	0f 87 8a 00 00 00    	ja     8010fa <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801070:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801074:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  80107b:	00 00 00 
  80107e:	ff d0                	call   *%rax
  801080:	89 c3                	mov    %eax,%ebx
  801082:	85 c0                	test   %eax,%eax
  801084:	78 50                	js     8010d6 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  801086:	4c 89 e6             	mov    %r12,%rsi
  801089:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801090:	00 00 00 
  801093:	48 89 df             	mov    %rbx,%rdi
  801096:	48 b8 82 26 80 00 00 	movabs $0x802682,%rax
  80109d:	00 00 00 
  8010a0:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8010a2:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8010a9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8010ad:	bf 01 00 00 00       	mov    $0x1,%edi
  8010b2:	48 b8 b1 0d 80 00 00 	movabs $0x800db1,%rax
  8010b9:	00 00 00 
  8010bc:	ff d0                	call   *%rax
  8010be:	89 c3                	mov    %eax,%ebx
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	78 1f                	js     8010e3 <open+0xa2>
    return fd2num(fd);
  8010c4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010c8:	48 b8 76 06 80 00 00 	movabs $0x800676,%rax
  8010cf:	00 00 00 
  8010d2:	ff d0                	call   *%rax
  8010d4:	89 c3                	mov    %eax,%ebx
}
  8010d6:	89 d8                	mov    %ebx,%eax
  8010d8:	48 83 c4 18          	add    $0x18,%rsp
  8010dc:	5b                   	pop    %rbx
  8010dd:	41 5c                	pop    %r12
  8010df:	41 5d                	pop    %r13
  8010e1:	5d                   	pop    %rbp
  8010e2:	c3                   	ret
        fd_close(fd, 0);
  8010e3:	be 00 00 00 00       	mov    $0x0,%esi
  8010e8:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010ec:	48 b8 d3 07 80 00 00 	movabs $0x8007d3,%rax
  8010f3:	00 00 00 
  8010f6:	ff d0                	call   *%rax
        return res;
  8010f8:	eb dc                	jmp    8010d6 <open+0x95>
        return -E_BAD_PATH;
  8010fa:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8010ff:	eb d5                	jmp    8010d6 <open+0x95>

0000000000801101 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801101:	f3 0f 1e fa          	endbr64
  801105:	55                   	push   %rbp
  801106:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801109:	be 00 00 00 00       	mov    $0x0,%esi
  80110e:	bf 08 00 00 00       	mov    $0x8,%edi
  801113:	48 b8 b1 0d 80 00 00 	movabs $0x800db1,%rax
  80111a:	00 00 00 
  80111d:	ff d0                	call   *%rax
}
  80111f:	5d                   	pop    %rbp
  801120:	c3                   	ret

0000000000801121 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801121:	f3 0f 1e fa          	endbr64
  801125:	55                   	push   %rbp
  801126:	48 89 e5             	mov    %rsp,%rbp
  801129:	41 54                	push   %r12
  80112b:	53                   	push   %rbx
  80112c:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80112f:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  801136:	00 00 00 
  801139:	ff d0                	call   *%rax
  80113b:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80113e:	48 be 8e 30 80 00 00 	movabs $0x80308e,%rsi
  801145:	00 00 00 
  801148:	48 89 df             	mov    %rbx,%rdi
  80114b:	48 b8 82 26 80 00 00 	movabs $0x802682,%rax
  801152:	00 00 00 
  801155:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801157:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80115c:	41 2b 04 24          	sub    (%r12),%eax
  801160:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801166:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80116d:	00 00 00 
    stat->st_dev = &devpipe;
  801170:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801177:	00 00 00 
  80117a:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801181:	b8 00 00 00 00       	mov    $0x0,%eax
  801186:	5b                   	pop    %rbx
  801187:	41 5c                	pop    %r12
  801189:	5d                   	pop    %rbp
  80118a:	c3                   	ret

000000000080118b <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80118b:	f3 0f 1e fa          	endbr64
  80118f:	55                   	push   %rbp
  801190:	48 89 e5             	mov    %rsp,%rbp
  801193:	41 54                	push   %r12
  801195:	53                   	push   %rbx
  801196:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801199:	ba 00 10 00 00       	mov    $0x1000,%edx
  80119e:	48 89 fe             	mov    %rdi,%rsi
  8011a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8011a6:	49 bc f2 03 80 00 00 	movabs $0x8003f2,%r12
  8011ad:	00 00 00 
  8011b0:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8011b3:	48 89 df             	mov    %rbx,%rdi
  8011b6:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  8011bd:	00 00 00 
  8011c0:	ff d0                	call   *%rax
  8011c2:	48 89 c6             	mov    %rax,%rsi
  8011c5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8011cf:	41 ff d4             	call   *%r12
}
  8011d2:	5b                   	pop    %rbx
  8011d3:	41 5c                	pop    %r12
  8011d5:	5d                   	pop    %rbp
  8011d6:	c3                   	ret

00000000008011d7 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8011d7:	f3 0f 1e fa          	endbr64
  8011db:	55                   	push   %rbp
  8011dc:	48 89 e5             	mov    %rsp,%rbp
  8011df:	41 57                	push   %r15
  8011e1:	41 56                	push   %r14
  8011e3:	41 55                	push   %r13
  8011e5:	41 54                	push   %r12
  8011e7:	53                   	push   %rbx
  8011e8:	48 83 ec 18          	sub    $0x18,%rsp
  8011ec:	49 89 fc             	mov    %rdi,%r12
  8011ef:	49 89 f5             	mov    %rsi,%r13
  8011f2:	49 89 d7             	mov    %rdx,%r15
  8011f5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8011f9:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  801200:	00 00 00 
  801203:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801205:	4d 85 ff             	test   %r15,%r15
  801208:	0f 84 af 00 00 00    	je     8012bd <devpipe_write+0xe6>
  80120e:	48 89 c3             	mov    %rax,%rbx
  801211:	4c 89 f8             	mov    %r15,%rax
  801214:	4d 89 ef             	mov    %r13,%r15
  801217:	4c 01 e8             	add    %r13,%rax
  80121a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80121e:	49 bd 82 02 80 00 00 	movabs $0x800282,%r13
  801225:	00 00 00 
            sys_yield();
  801228:	49 be 17 02 80 00 00 	movabs $0x800217,%r14
  80122f:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801232:	8b 73 04             	mov    0x4(%rbx),%esi
  801235:	48 63 ce             	movslq %esi,%rcx
  801238:	48 63 03             	movslq (%rbx),%rax
  80123b:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801241:	48 39 c1             	cmp    %rax,%rcx
  801244:	72 2e                	jb     801274 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801246:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80124b:	48 89 da             	mov    %rbx,%rdx
  80124e:	be 00 10 00 00       	mov    $0x1000,%esi
  801253:	4c 89 e7             	mov    %r12,%rdi
  801256:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801259:	85 c0                	test   %eax,%eax
  80125b:	74 66                	je     8012c3 <devpipe_write+0xec>
            sys_yield();
  80125d:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801260:	8b 73 04             	mov    0x4(%rbx),%esi
  801263:	48 63 ce             	movslq %esi,%rcx
  801266:	48 63 03             	movslq (%rbx),%rax
  801269:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80126f:	48 39 c1             	cmp    %rax,%rcx
  801272:	73 d2                	jae    801246 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801274:	41 0f b6 3f          	movzbl (%r15),%edi
  801278:	48 89 ca             	mov    %rcx,%rdx
  80127b:	48 c1 ea 03          	shr    $0x3,%rdx
  80127f:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801286:	08 10 20 
  801289:	48 f7 e2             	mul    %rdx
  80128c:	48 c1 ea 06          	shr    $0x6,%rdx
  801290:	48 89 d0             	mov    %rdx,%rax
  801293:	48 c1 e0 09          	shl    $0x9,%rax
  801297:	48 29 d0             	sub    %rdx,%rax
  80129a:	48 c1 e0 03          	shl    $0x3,%rax
  80129e:	48 29 c1             	sub    %rax,%rcx
  8012a1:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8012a6:	83 c6 01             	add    $0x1,%esi
  8012a9:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012ac:	49 83 c7 01          	add    $0x1,%r15
  8012b0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012b4:	49 39 c7             	cmp    %rax,%r15
  8012b7:	0f 85 75 ff ff ff    	jne    801232 <devpipe_write+0x5b>
    return n;
  8012bd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8012c1:	eb 05                	jmp    8012c8 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8012c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c8:	48 83 c4 18          	add    $0x18,%rsp
  8012cc:	5b                   	pop    %rbx
  8012cd:	41 5c                	pop    %r12
  8012cf:	41 5d                	pop    %r13
  8012d1:	41 5e                	pop    %r14
  8012d3:	41 5f                	pop    %r15
  8012d5:	5d                   	pop    %rbp
  8012d6:	c3                   	ret

00000000008012d7 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8012d7:	f3 0f 1e fa          	endbr64
  8012db:	55                   	push   %rbp
  8012dc:	48 89 e5             	mov    %rsp,%rbp
  8012df:	41 57                	push   %r15
  8012e1:	41 56                	push   %r14
  8012e3:	41 55                	push   %r13
  8012e5:	41 54                	push   %r12
  8012e7:	53                   	push   %rbx
  8012e8:	48 83 ec 18          	sub    $0x18,%rsp
  8012ec:	49 89 fc             	mov    %rdi,%r12
  8012ef:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8012f3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8012f7:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  8012fe:	00 00 00 
  801301:	ff d0                	call   *%rax
  801303:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  801306:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80130c:	49 bd 82 02 80 00 00 	movabs $0x800282,%r13
  801313:	00 00 00 
            sys_yield();
  801316:	49 be 17 02 80 00 00 	movabs $0x800217,%r14
  80131d:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801320:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801325:	74 7d                	je     8013a4 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801327:	8b 03                	mov    (%rbx),%eax
  801329:	3b 43 04             	cmp    0x4(%rbx),%eax
  80132c:	75 26                	jne    801354 <devpipe_read+0x7d>
            if (i > 0) return i;
  80132e:	4d 85 ff             	test   %r15,%r15
  801331:	75 77                	jne    8013aa <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801333:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801338:	48 89 da             	mov    %rbx,%rdx
  80133b:	be 00 10 00 00       	mov    $0x1000,%esi
  801340:	4c 89 e7             	mov    %r12,%rdi
  801343:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801346:	85 c0                	test   %eax,%eax
  801348:	74 72                	je     8013bc <devpipe_read+0xe5>
            sys_yield();
  80134a:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80134d:	8b 03                	mov    (%rbx),%eax
  80134f:	3b 43 04             	cmp    0x4(%rbx),%eax
  801352:	74 df                	je     801333 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801354:	48 63 c8             	movslq %eax,%rcx
  801357:	48 89 ca             	mov    %rcx,%rdx
  80135a:	48 c1 ea 03          	shr    $0x3,%rdx
  80135e:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  801365:	08 10 20 
  801368:	48 89 d0             	mov    %rdx,%rax
  80136b:	48 f7 e6             	mul    %rsi
  80136e:	48 c1 ea 06          	shr    $0x6,%rdx
  801372:	48 89 d0             	mov    %rdx,%rax
  801375:	48 c1 e0 09          	shl    $0x9,%rax
  801379:	48 29 d0             	sub    %rdx,%rax
  80137c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801383:	00 
  801384:	48 89 c8             	mov    %rcx,%rax
  801387:	48 29 d0             	sub    %rdx,%rax
  80138a:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80138f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801393:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  801397:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80139a:	49 83 c7 01          	add    $0x1,%r15
  80139e:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8013a2:	75 83                	jne    801327 <devpipe_read+0x50>
    return n;
  8013a4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013a8:	eb 03                	jmp    8013ad <devpipe_read+0xd6>
            if (i > 0) return i;
  8013aa:	4c 89 f8             	mov    %r15,%rax
}
  8013ad:	48 83 c4 18          	add    $0x18,%rsp
  8013b1:	5b                   	pop    %rbx
  8013b2:	41 5c                	pop    %r12
  8013b4:	41 5d                	pop    %r13
  8013b6:	41 5e                	pop    %r14
  8013b8:	41 5f                	pop    %r15
  8013ba:	5d                   	pop    %rbp
  8013bb:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8013bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c1:	eb ea                	jmp    8013ad <devpipe_read+0xd6>

00000000008013c3 <pipe>:
pipe(int pfd[2]) {
  8013c3:	f3 0f 1e fa          	endbr64
  8013c7:	55                   	push   %rbp
  8013c8:	48 89 e5             	mov    %rsp,%rbp
  8013cb:	41 55                	push   %r13
  8013cd:	41 54                	push   %r12
  8013cf:	53                   	push   %rbx
  8013d0:	48 83 ec 18          	sub    $0x18,%rsp
  8013d4:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8013d7:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8013db:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  8013e2:	00 00 00 
  8013e5:	ff d0                	call   *%rax
  8013e7:	89 c3                	mov    %eax,%ebx
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	0f 88 a0 01 00 00    	js     801591 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8013f1:	b9 46 00 00 00       	mov    $0x46,%ecx
  8013f6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8013fb:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8013ff:	bf 00 00 00 00       	mov    $0x0,%edi
  801404:	48 b8 b2 02 80 00 00 	movabs $0x8002b2,%rax
  80140b:	00 00 00 
  80140e:	ff d0                	call   *%rax
  801410:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801412:	85 c0                	test   %eax,%eax
  801414:	0f 88 77 01 00 00    	js     801591 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80141a:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80141e:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  801425:	00 00 00 
  801428:	ff d0                	call   *%rax
  80142a:	89 c3                	mov    %eax,%ebx
  80142c:	85 c0                	test   %eax,%eax
  80142e:	0f 88 43 01 00 00    	js     801577 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  801434:	b9 46 00 00 00       	mov    $0x46,%ecx
  801439:	ba 00 10 00 00       	mov    $0x1000,%edx
  80143e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801442:	bf 00 00 00 00       	mov    $0x0,%edi
  801447:	48 b8 b2 02 80 00 00 	movabs $0x8002b2,%rax
  80144e:	00 00 00 
  801451:	ff d0                	call   *%rax
  801453:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  801455:	85 c0                	test   %eax,%eax
  801457:	0f 88 1a 01 00 00    	js     801577 <pipe+0x1b4>
    va = fd2data(fd0);
  80145d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801461:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  801468:	00 00 00 
  80146b:	ff d0                	call   *%rax
  80146d:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801470:	b9 46 00 00 00       	mov    $0x46,%ecx
  801475:	ba 00 10 00 00       	mov    $0x1000,%edx
  80147a:	48 89 c6             	mov    %rax,%rsi
  80147d:	bf 00 00 00 00       	mov    $0x0,%edi
  801482:	48 b8 b2 02 80 00 00 	movabs $0x8002b2,%rax
  801489:	00 00 00 
  80148c:	ff d0                	call   *%rax
  80148e:	89 c3                	mov    %eax,%ebx
  801490:	85 c0                	test   %eax,%eax
  801492:	0f 88 c5 00 00 00    	js     80155d <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  801498:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80149c:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  8014a3:	00 00 00 
  8014a6:	ff d0                	call   *%rax
  8014a8:	48 89 c1             	mov    %rax,%rcx
  8014ab:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8014b1:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8014b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014bc:	4c 89 ee             	mov    %r13,%rsi
  8014bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8014c4:	48 b8 1d 03 80 00 00 	movabs $0x80031d,%rax
  8014cb:	00 00 00 
  8014ce:	ff d0                	call   *%rax
  8014d0:	89 c3                	mov    %eax,%ebx
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	78 6e                	js     801544 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014d6:	be 00 10 00 00       	mov    $0x1000,%esi
  8014db:	4c 89 ef             	mov    %r13,%rdi
  8014de:	48 b8 4c 02 80 00 00 	movabs $0x80024c,%rax
  8014e5:	00 00 00 
  8014e8:	ff d0                	call   *%rax
  8014ea:	83 f8 02             	cmp    $0x2,%eax
  8014ed:	0f 85 ab 00 00 00    	jne    80159e <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8014f3:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8014fa:	00 00 
  8014fc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801500:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  801502:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801506:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80150d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801511:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801513:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801517:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80151e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801522:	48 bb 76 06 80 00 00 	movabs $0x800676,%rbx
  801529:	00 00 00 
  80152c:	ff d3                	call   *%rbx
  80152e:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801532:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801536:	ff d3                	call   *%rbx
  801538:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80153d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801542:	eb 4d                	jmp    801591 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  801544:	ba 00 10 00 00       	mov    $0x1000,%edx
  801549:	4c 89 ee             	mov    %r13,%rsi
  80154c:	bf 00 00 00 00       	mov    $0x0,%edi
  801551:	48 b8 f2 03 80 00 00 	movabs $0x8003f2,%rax
  801558:	00 00 00 
  80155b:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80155d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801562:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801566:	bf 00 00 00 00       	mov    $0x0,%edi
  80156b:	48 b8 f2 03 80 00 00 	movabs $0x8003f2,%rax
  801572:	00 00 00 
  801575:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  801577:	ba 00 10 00 00       	mov    $0x1000,%edx
  80157c:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801580:	bf 00 00 00 00       	mov    $0x0,%edi
  801585:	48 b8 f2 03 80 00 00 	movabs $0x8003f2,%rax
  80158c:	00 00 00 
  80158f:	ff d0                	call   *%rax
}
  801591:	89 d8                	mov    %ebx,%eax
  801593:	48 83 c4 18          	add    $0x18,%rsp
  801597:	5b                   	pop    %rbx
  801598:	41 5c                	pop    %r12
  80159a:	41 5d                	pop    %r13
  80159c:	5d                   	pop    %rbp
  80159d:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80159e:	48 b9 c0 32 80 00 00 	movabs $0x8032c0,%rcx
  8015a5:	00 00 00 
  8015a8:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  8015af:	00 00 00 
  8015b2:	be 2e 00 00 00       	mov    $0x2e,%esi
  8015b7:	48 bf 95 30 80 00 00 	movabs $0x803095,%rdi
  8015be:	00 00 00 
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c6:	49 b8 dd 1b 80 00 00 	movabs $0x801bdd,%r8
  8015cd:	00 00 00 
  8015d0:	41 ff d0             	call   *%r8

00000000008015d3 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8015d3:	f3 0f 1e fa          	endbr64
  8015d7:	55                   	push   %rbp
  8015d8:	48 89 e5             	mov    %rsp,%rbp
  8015db:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8015df:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8015e3:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  8015ea:	00 00 00 
  8015ed:	ff d0                	call   *%rax
    if (res < 0) return res;
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	78 35                	js     801628 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8015f3:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8015f7:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  8015fe:	00 00 00 
  801601:	ff d0                	call   *%rax
  801603:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801606:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80160b:	be 00 10 00 00       	mov    $0x1000,%esi
  801610:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801614:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  80161b:	00 00 00 
  80161e:	ff d0                	call   *%rax
  801620:	85 c0                	test   %eax,%eax
  801622:	0f 94 c0             	sete   %al
  801625:	0f b6 c0             	movzbl %al,%eax
}
  801628:	c9                   	leave
  801629:	c3                   	ret

000000000080162a <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  80162a:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80162e:	48 89 f8             	mov    %rdi,%rax
  801631:	48 c1 e8 27          	shr    $0x27,%rax
  801635:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80163c:	7f 00 00 
  80163f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801643:	f6 c2 01             	test   $0x1,%dl
  801646:	74 6d                	je     8016b5 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801648:	48 89 f8             	mov    %rdi,%rax
  80164b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80164f:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801656:	7f 00 00 
  801659:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80165d:	f6 c2 01             	test   $0x1,%dl
  801660:	74 62                	je     8016c4 <get_uvpt_entry+0x9a>
  801662:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801669:	7f 00 00 
  80166c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801670:	f6 c2 80             	test   $0x80,%dl
  801673:	75 4f                	jne    8016c4 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801675:	48 89 f8             	mov    %rdi,%rax
  801678:	48 c1 e8 15          	shr    $0x15,%rax
  80167c:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  801683:	7f 00 00 
  801686:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80168a:	f6 c2 01             	test   $0x1,%dl
  80168d:	74 44                	je     8016d3 <get_uvpt_entry+0xa9>
  80168f:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  801696:	7f 00 00 
  801699:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80169d:	f6 c2 80             	test   $0x80,%dl
  8016a0:	75 31                	jne    8016d3 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  8016a2:	48 c1 ef 0c          	shr    $0xc,%rdi
  8016a6:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8016ad:	7f 00 00 
  8016b0:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8016b4:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8016b5:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8016bc:	7f 00 00 
  8016bf:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016c3:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8016c4:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8016cb:	7f 00 00 
  8016ce:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016d2:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8016d3:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016da:	7f 00 00 
  8016dd:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016e1:	c3                   	ret

00000000008016e2 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8016e2:	f3 0f 1e fa          	endbr64
  8016e6:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8016e9:	48 89 f9             	mov    %rdi,%rcx
  8016ec:	48 c1 e9 27          	shr    $0x27,%rcx
  8016f0:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8016f7:	7f 00 00 
  8016fa:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8016fe:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  801705:	f6 c1 01             	test   $0x1,%cl
  801708:	0f 84 b2 00 00 00    	je     8017c0 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80170e:	48 89 f9             	mov    %rdi,%rcx
  801711:	48 c1 e9 1e          	shr    $0x1e,%rcx
  801715:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80171c:	7f 00 00 
  80171f:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801723:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80172a:	40 f6 c6 01          	test   $0x1,%sil
  80172e:	0f 84 8c 00 00 00    	je     8017c0 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  801734:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80173b:	7f 00 00 
  80173e:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801742:	a8 80                	test   $0x80,%al
  801744:	75 7b                	jne    8017c1 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  801746:	48 89 f9             	mov    %rdi,%rcx
  801749:	48 c1 e9 15          	shr    $0x15,%rcx
  80174d:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801754:	7f 00 00 
  801757:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80175b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  801762:	40 f6 c6 01          	test   $0x1,%sil
  801766:	74 58                	je     8017c0 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  801768:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80176f:	7f 00 00 
  801772:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801776:	a8 80                	test   $0x80,%al
  801778:	75 6c                	jne    8017e6 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  80177a:	48 89 f9             	mov    %rdi,%rcx
  80177d:	48 c1 e9 0c          	shr    $0xc,%rcx
  801781:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801788:	7f 00 00 
  80178b:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80178f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  801796:	40 f6 c6 01          	test   $0x1,%sil
  80179a:	74 24                	je     8017c0 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  80179c:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8017a3:	7f 00 00 
  8017a6:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017aa:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017b1:	ff ff 7f 
  8017b4:	48 21 c8             	and    %rcx,%rax
  8017b7:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8017bd:	48 09 d0             	or     %rdx,%rax
}
  8017c0:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8017c1:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8017c8:	7f 00 00 
  8017cb:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017cf:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017d6:	ff ff 7f 
  8017d9:	48 21 c8             	and    %rcx,%rax
  8017dc:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8017e2:	48 01 d0             	add    %rdx,%rax
  8017e5:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8017e6:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8017ed:	7f 00 00 
  8017f0:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017f4:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017fb:	ff ff 7f 
  8017fe:	48 21 c8             	and    %rcx,%rax
  801801:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  801807:	48 01 d0             	add    %rdx,%rax
  80180a:	c3                   	ret

000000000080180b <get_prot>:

int
get_prot(void *va) {
  80180b:	f3 0f 1e fa          	endbr64
  80180f:	55                   	push   %rbp
  801810:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801813:	48 b8 2a 16 80 00 00 	movabs $0x80162a,%rax
  80181a:	00 00 00 
  80181d:	ff d0                	call   *%rax
  80181f:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  801822:	83 e0 01             	and    $0x1,%eax
  801825:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  801828:	89 d1                	mov    %edx,%ecx
  80182a:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  801830:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  801832:	89 c1                	mov    %eax,%ecx
  801834:	83 c9 02             	or     $0x2,%ecx
  801837:	f6 c2 02             	test   $0x2,%dl
  80183a:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80183d:	89 c1                	mov    %eax,%ecx
  80183f:	83 c9 01             	or     $0x1,%ecx
  801842:	48 85 d2             	test   %rdx,%rdx
  801845:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801848:	89 c1                	mov    %eax,%ecx
  80184a:	83 c9 40             	or     $0x40,%ecx
  80184d:	f6 c6 04             	test   $0x4,%dh
  801850:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801853:	5d                   	pop    %rbp
  801854:	c3                   	ret

0000000000801855 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801855:	f3 0f 1e fa          	endbr64
  801859:	55                   	push   %rbp
  80185a:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80185d:	48 b8 2a 16 80 00 00 	movabs $0x80162a,%rax
  801864:	00 00 00 
  801867:	ff d0                	call   *%rax
    return pte & PTE_D;
  801869:	48 c1 e8 06          	shr    $0x6,%rax
  80186d:	83 e0 01             	and    $0x1,%eax
}
  801870:	5d                   	pop    %rbp
  801871:	c3                   	ret

0000000000801872 <is_page_present>:

bool
is_page_present(void *va) {
  801872:	f3 0f 1e fa          	endbr64
  801876:	55                   	push   %rbp
  801877:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80187a:	48 b8 2a 16 80 00 00 	movabs $0x80162a,%rax
  801881:	00 00 00 
  801884:	ff d0                	call   *%rax
  801886:	83 e0 01             	and    $0x1,%eax
}
  801889:	5d                   	pop    %rbp
  80188a:	c3                   	ret

000000000080188b <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80188b:	f3 0f 1e fa          	endbr64
  80188f:	55                   	push   %rbp
  801890:	48 89 e5             	mov    %rsp,%rbp
  801893:	41 57                	push   %r15
  801895:	41 56                	push   %r14
  801897:	41 55                	push   %r13
  801899:	41 54                	push   %r12
  80189b:	53                   	push   %rbx
  80189c:	48 83 ec 18          	sub    $0x18,%rsp
  8018a0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8018a4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8018a8:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8018ad:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8018b4:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8018b7:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8018be:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8018c1:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8018c8:	00 00 00 
  8018cb:	eb 73                	jmp    801940 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018cd:	48 89 d8             	mov    %rbx,%rax
  8018d0:	48 c1 e8 15          	shr    $0x15,%rax
  8018d4:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8018db:	7f 00 00 
  8018de:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8018e2:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018e8:	f6 c2 01             	test   $0x1,%dl
  8018eb:	74 4b                	je     801938 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8018ed:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8018f1:	f6 c2 80             	test   $0x80,%dl
  8018f4:	74 11                	je     801907 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8018f6:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8018fa:	f6 c4 04             	test   $0x4,%ah
  8018fd:	74 39                	je     801938 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8018ff:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  801905:	eb 20                	jmp    801927 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801907:	48 89 da             	mov    %rbx,%rdx
  80190a:	48 c1 ea 0c          	shr    $0xc,%rdx
  80190e:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801915:	7f 00 00 
  801918:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  80191c:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801922:	f6 c4 04             	test   $0x4,%ah
  801925:	74 11                	je     801938 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  801927:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  80192b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80192f:	48 89 df             	mov    %rbx,%rdi
  801932:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801936:	ff d0                	call   *%rax
    next:
        va += size;
  801938:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  80193b:	49 39 df             	cmp    %rbx,%r15
  80193e:	72 3e                	jb     80197e <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  801940:	49 8b 06             	mov    (%r14),%rax
  801943:	a8 01                	test   $0x1,%al
  801945:	74 37                	je     80197e <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801947:	48 89 d8             	mov    %rbx,%rax
  80194a:	48 c1 e8 1e          	shr    $0x1e,%rax
  80194e:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  801953:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801959:	f6 c2 01             	test   $0x1,%dl
  80195c:	74 da                	je     801938 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  80195e:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  801963:	f6 c2 80             	test   $0x80,%dl
  801966:	0f 84 61 ff ff ff    	je     8018cd <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  80196c:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  801971:	f6 c4 04             	test   $0x4,%ah
  801974:	74 c2                	je     801938 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  801976:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  80197c:	eb a9                	jmp    801927 <foreach_shared_region+0x9c>
    }
    return res;
}
  80197e:	b8 00 00 00 00       	mov    $0x0,%eax
  801983:	48 83 c4 18          	add    $0x18,%rsp
  801987:	5b                   	pop    %rbx
  801988:	41 5c                	pop    %r12
  80198a:	41 5d                	pop    %r13
  80198c:	41 5e                	pop    %r14
  80198e:	41 5f                	pop    %r15
  801990:	5d                   	pop    %rbp
  801991:	c3                   	ret

0000000000801992 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  801992:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  801996:	b8 00 00 00 00       	mov    $0x0,%eax
  80199b:	c3                   	ret

000000000080199c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80199c:	f3 0f 1e fa          	endbr64
  8019a0:	55                   	push   %rbp
  8019a1:	48 89 e5             	mov    %rsp,%rbp
  8019a4:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8019a7:	48 be a5 30 80 00 00 	movabs $0x8030a5,%rsi
  8019ae:	00 00 00 
  8019b1:	48 b8 82 26 80 00 00 	movabs $0x802682,%rax
  8019b8:	00 00 00 
  8019bb:	ff d0                	call   *%rax
    return 0;
}
  8019bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c2:	5d                   	pop    %rbp
  8019c3:	c3                   	ret

00000000008019c4 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8019c4:	f3 0f 1e fa          	endbr64
  8019c8:	55                   	push   %rbp
  8019c9:	48 89 e5             	mov    %rsp,%rbp
  8019cc:	41 57                	push   %r15
  8019ce:	41 56                	push   %r14
  8019d0:	41 55                	push   %r13
  8019d2:	41 54                	push   %r12
  8019d4:	53                   	push   %rbx
  8019d5:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8019dc:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8019e3:	48 85 d2             	test   %rdx,%rdx
  8019e6:	74 7a                	je     801a62 <devcons_write+0x9e>
  8019e8:	49 89 d6             	mov    %rdx,%r14
  8019eb:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8019f1:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8019f6:	49 bf 9d 28 80 00 00 	movabs $0x80289d,%r15
  8019fd:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  801a00:	4c 89 f3             	mov    %r14,%rbx
  801a03:	48 29 f3             	sub    %rsi,%rbx
  801a06:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a0b:	48 39 c3             	cmp    %rax,%rbx
  801a0e:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801a12:	4c 63 eb             	movslq %ebx,%r13
  801a15:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801a1c:	48 01 c6             	add    %rax,%rsi
  801a1f:	4c 89 ea             	mov    %r13,%rdx
  801a22:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a29:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  801a2c:	4c 89 ee             	mov    %r13,%rsi
  801a2f:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a36:	48 b8 0d 01 80 00 00 	movabs $0x80010d,%rax
  801a3d:	00 00 00 
  801a40:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801a42:	41 01 dc             	add    %ebx,%r12d
  801a45:	49 63 f4             	movslq %r12d,%rsi
  801a48:	4c 39 f6             	cmp    %r14,%rsi
  801a4b:	72 b3                	jb     801a00 <devcons_write+0x3c>
    return res;
  801a4d:	49 63 c4             	movslq %r12d,%rax
}
  801a50:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801a57:	5b                   	pop    %rbx
  801a58:	41 5c                	pop    %r12
  801a5a:	41 5d                	pop    %r13
  801a5c:	41 5e                	pop    %r14
  801a5e:	41 5f                	pop    %r15
  801a60:	5d                   	pop    %rbp
  801a61:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  801a62:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a68:	eb e3                	jmp    801a4d <devcons_write+0x89>

0000000000801a6a <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a6a:	f3 0f 1e fa          	endbr64
  801a6e:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801a71:	ba 00 00 00 00       	mov    $0x0,%edx
  801a76:	48 85 c0             	test   %rax,%rax
  801a79:	74 55                	je     801ad0 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a7b:	55                   	push   %rbp
  801a7c:	48 89 e5             	mov    %rsp,%rbp
  801a7f:	41 55                	push   %r13
  801a81:	41 54                	push   %r12
  801a83:	53                   	push   %rbx
  801a84:	48 83 ec 08          	sub    $0x8,%rsp
  801a88:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801a8b:	48 bb 3e 01 80 00 00 	movabs $0x80013e,%rbx
  801a92:	00 00 00 
  801a95:	49 bc 17 02 80 00 00 	movabs $0x800217,%r12
  801a9c:	00 00 00 
  801a9f:	eb 03                	jmp    801aa4 <devcons_read+0x3a>
  801aa1:	41 ff d4             	call   *%r12
  801aa4:	ff d3                	call   *%rbx
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	74 f7                	je     801aa1 <devcons_read+0x37>
    if (c < 0) return c;
  801aaa:	48 63 d0             	movslq %eax,%rdx
  801aad:	78 13                	js     801ac2 <devcons_read+0x58>
    if (c == 0x04) return 0;
  801aaf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab4:	83 f8 04             	cmp    $0x4,%eax
  801ab7:	74 09                	je     801ac2 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  801ab9:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801abd:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801ac2:	48 89 d0             	mov    %rdx,%rax
  801ac5:	48 83 c4 08          	add    $0x8,%rsp
  801ac9:	5b                   	pop    %rbx
  801aca:	41 5c                	pop    %r12
  801acc:	41 5d                	pop    %r13
  801ace:	5d                   	pop    %rbp
  801acf:	c3                   	ret
  801ad0:	48 89 d0             	mov    %rdx,%rax
  801ad3:	c3                   	ret

0000000000801ad4 <cputchar>:
cputchar(int ch) {
  801ad4:	f3 0f 1e fa          	endbr64
  801ad8:	55                   	push   %rbp
  801ad9:	48 89 e5             	mov    %rsp,%rbp
  801adc:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801ae0:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801ae4:	be 01 00 00 00       	mov    $0x1,%esi
  801ae9:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801aed:	48 b8 0d 01 80 00 00 	movabs $0x80010d,%rax
  801af4:	00 00 00 
  801af7:	ff d0                	call   *%rax
}
  801af9:	c9                   	leave
  801afa:	c3                   	ret

0000000000801afb <getchar>:
getchar(void) {
  801afb:	f3 0f 1e fa          	endbr64
  801aff:	55                   	push   %rbp
  801b00:	48 89 e5             	mov    %rsp,%rbp
  801b03:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801b07:	ba 01 00 00 00       	mov    $0x1,%edx
  801b0c:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801b10:	bf 00 00 00 00       	mov    $0x0,%edi
  801b15:	48 b8 0b 0a 80 00 00 	movabs $0x800a0b,%rax
  801b1c:	00 00 00 
  801b1f:	ff d0                	call   *%rax
  801b21:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801b23:	85 c0                	test   %eax,%eax
  801b25:	78 06                	js     801b2d <getchar+0x32>
  801b27:	74 08                	je     801b31 <getchar+0x36>
  801b29:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  801b2d:	89 d0                	mov    %edx,%eax
  801b2f:	c9                   	leave
  801b30:	c3                   	ret
    return res < 0 ? res : res ? c :
  801b31:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801b36:	eb f5                	jmp    801b2d <getchar+0x32>

0000000000801b38 <iscons>:
iscons(int fdnum) {
  801b38:	f3 0f 1e fa          	endbr64
  801b3c:	55                   	push   %rbp
  801b3d:	48 89 e5             	mov    %rsp,%rbp
  801b40:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801b44:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b48:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  801b4f:	00 00 00 
  801b52:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b54:	85 c0                	test   %eax,%eax
  801b56:	78 18                	js     801b70 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  801b58:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b5c:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801b63:	00 00 00 
  801b66:	8b 00                	mov    (%rax),%eax
  801b68:	39 02                	cmp    %eax,(%rdx)
  801b6a:	0f 94 c0             	sete   %al
  801b6d:	0f b6 c0             	movzbl %al,%eax
}
  801b70:	c9                   	leave
  801b71:	c3                   	ret

0000000000801b72 <opencons>:
opencons(void) {
  801b72:	f3 0f 1e fa          	endbr64
  801b76:	55                   	push   %rbp
  801b77:	48 89 e5             	mov    %rsp,%rbp
  801b7a:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801b7e:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801b82:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  801b89:	00 00 00 
  801b8c:	ff d0                	call   *%rax
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	78 49                	js     801bdb <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801b92:	b9 46 00 00 00       	mov    $0x46,%ecx
  801b97:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b9c:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801ba0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba5:	48 b8 b2 02 80 00 00 	movabs $0x8002b2,%rax
  801bac:	00 00 00 
  801baf:	ff d0                	call   *%rax
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	78 26                	js     801bdb <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  801bb5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bb9:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801bc0:	00 00 
  801bc2:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801bc4:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801bc8:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801bcf:	48 b8 76 06 80 00 00 	movabs $0x800676,%rax
  801bd6:	00 00 00 
  801bd9:	ff d0                	call   *%rax
}
  801bdb:	c9                   	leave
  801bdc:	c3                   	ret

0000000000801bdd <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801bdd:	f3 0f 1e fa          	endbr64
  801be1:	55                   	push   %rbp
  801be2:	48 89 e5             	mov    %rsp,%rbp
  801be5:	41 56                	push   %r14
  801be7:	41 55                	push   %r13
  801be9:	41 54                	push   %r12
  801beb:	53                   	push   %rbx
  801bec:	48 83 ec 50          	sub    $0x50,%rsp
  801bf0:	49 89 fc             	mov    %rdi,%r12
  801bf3:	41 89 f5             	mov    %esi,%r13d
  801bf6:	48 89 d3             	mov    %rdx,%rbx
  801bf9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801bfd:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801c01:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801c05:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801c0c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c10:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801c14:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801c18:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801c1c:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801c23:	00 00 00 
  801c26:	4c 8b 30             	mov    (%rax),%r14
  801c29:	48 b8 e2 01 80 00 00 	movabs $0x8001e2,%rax
  801c30:	00 00 00 
  801c33:	ff d0                	call   *%rax
  801c35:	89 c6                	mov    %eax,%esi
  801c37:	45 89 e8             	mov    %r13d,%r8d
  801c3a:	4c 89 e1             	mov    %r12,%rcx
  801c3d:	4c 89 f2             	mov    %r14,%rdx
  801c40:	48 bf e8 32 80 00 00 	movabs $0x8032e8,%rdi
  801c47:	00 00 00 
  801c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4f:	49 bc 39 1d 80 00 00 	movabs $0x801d39,%r12
  801c56:	00 00 00 
  801c59:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801c5c:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801c60:	48 89 df             	mov    %rbx,%rdi
  801c63:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  801c6a:	00 00 00 
  801c6d:	ff d0                	call   *%rax
    cprintf("\n");
  801c6f:	48 bf 32 30 80 00 00 	movabs $0x803032,%rdi
  801c76:	00 00 00 
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7e:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801c81:	cc                   	int3
  801c82:	eb fd                	jmp    801c81 <_panic+0xa4>

0000000000801c84 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801c84:	f3 0f 1e fa          	endbr64
  801c88:	55                   	push   %rbp
  801c89:	48 89 e5             	mov    %rsp,%rbp
  801c8c:	53                   	push   %rbx
  801c8d:	48 83 ec 08          	sub    $0x8,%rsp
  801c91:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801c94:	8b 06                	mov    (%rsi),%eax
  801c96:	8d 50 01             	lea    0x1(%rax),%edx
  801c99:	89 16                	mov    %edx,(%rsi)
  801c9b:	48 98                	cltq
  801c9d:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801ca2:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801ca8:	74 0a                	je     801cb4 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801caa:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801cae:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cb2:	c9                   	leave
  801cb3:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  801cb4:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801cb8:	be ff 00 00 00       	mov    $0xff,%esi
  801cbd:	48 b8 0d 01 80 00 00 	movabs $0x80010d,%rax
  801cc4:	00 00 00 
  801cc7:	ff d0                	call   *%rax
        state->offset = 0;
  801cc9:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801ccf:	eb d9                	jmp    801caa <putch+0x26>

0000000000801cd1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801cd1:	f3 0f 1e fa          	endbr64
  801cd5:	55                   	push   %rbp
  801cd6:	48 89 e5             	mov    %rsp,%rbp
  801cd9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801ce0:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801ce3:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801cea:	b9 21 00 00 00       	mov    $0x21,%ecx
  801cef:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf4:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801cf7:	48 89 f1             	mov    %rsi,%rcx
  801cfa:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801d01:	48 bf 84 1c 80 00 00 	movabs $0x801c84,%rdi
  801d08:	00 00 00 
  801d0b:	48 b8 99 1e 80 00 00 	movabs $0x801e99,%rax
  801d12:	00 00 00 
  801d15:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801d17:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801d1e:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801d25:	48 b8 0d 01 80 00 00 	movabs $0x80010d,%rax
  801d2c:	00 00 00 
  801d2f:	ff d0                	call   *%rax

    return state.count;
}
  801d31:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801d37:	c9                   	leave
  801d38:	c3                   	ret

0000000000801d39 <cprintf>:

int
cprintf(const char *fmt, ...) {
  801d39:	f3 0f 1e fa          	endbr64
  801d3d:	55                   	push   %rbp
  801d3e:	48 89 e5             	mov    %rsp,%rbp
  801d41:	48 83 ec 50          	sub    $0x50,%rsp
  801d45:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801d49:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801d4d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d51:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801d55:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801d59:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801d60:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d64:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d68:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801d6c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801d70:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801d74:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  801d7b:	00 00 00 
  801d7e:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801d80:	c9                   	leave
  801d81:	c3                   	ret

0000000000801d82 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801d82:	f3 0f 1e fa          	endbr64
  801d86:	55                   	push   %rbp
  801d87:	48 89 e5             	mov    %rsp,%rbp
  801d8a:	41 57                	push   %r15
  801d8c:	41 56                	push   %r14
  801d8e:	41 55                	push   %r13
  801d90:	41 54                	push   %r12
  801d92:	53                   	push   %rbx
  801d93:	48 83 ec 18          	sub    $0x18,%rsp
  801d97:	49 89 fc             	mov    %rdi,%r12
  801d9a:	49 89 f5             	mov    %rsi,%r13
  801d9d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801da1:	8b 45 10             	mov    0x10(%rbp),%eax
  801da4:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801da7:	41 89 cf             	mov    %ecx,%r15d
  801daa:	4c 39 fa             	cmp    %r15,%rdx
  801dad:	73 5b                	jae    801e0a <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801daf:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801db3:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801db7:	85 db                	test   %ebx,%ebx
  801db9:	7e 0e                	jle    801dc9 <print_num+0x47>
            putch(padc, put_arg);
  801dbb:	4c 89 ee             	mov    %r13,%rsi
  801dbe:	44 89 f7             	mov    %r14d,%edi
  801dc1:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801dc4:	83 eb 01             	sub    $0x1,%ebx
  801dc7:	75 f2                	jne    801dbb <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801dc9:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801dcd:	48 b9 c2 30 80 00 00 	movabs $0x8030c2,%rcx
  801dd4:	00 00 00 
  801dd7:	48 b8 b1 30 80 00 00 	movabs $0x8030b1,%rax
  801dde:	00 00 00 
  801de1:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801de5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801de9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dee:	49 f7 f7             	div    %r15
  801df1:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801df5:	4c 89 ee             	mov    %r13,%rsi
  801df8:	41 ff d4             	call   *%r12
}
  801dfb:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801dff:	5b                   	pop    %rbx
  801e00:	41 5c                	pop    %r12
  801e02:	41 5d                	pop    %r13
  801e04:	41 5e                	pop    %r14
  801e06:	41 5f                	pop    %r15
  801e08:	5d                   	pop    %rbp
  801e09:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801e0a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e13:	49 f7 f7             	div    %r15
  801e16:	48 83 ec 08          	sub    $0x8,%rsp
  801e1a:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801e1e:	52                   	push   %rdx
  801e1f:	45 0f be c9          	movsbl %r9b,%r9d
  801e23:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801e27:	48 89 c2             	mov    %rax,%rdx
  801e2a:	48 b8 82 1d 80 00 00 	movabs $0x801d82,%rax
  801e31:	00 00 00 
  801e34:	ff d0                	call   *%rax
  801e36:	48 83 c4 10          	add    $0x10,%rsp
  801e3a:	eb 8d                	jmp    801dc9 <print_num+0x47>

0000000000801e3c <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  801e3c:	f3 0f 1e fa          	endbr64
    state->count++;
  801e40:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801e44:	48 8b 06             	mov    (%rsi),%rax
  801e47:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801e4b:	73 0a                	jae    801e57 <sprintputch+0x1b>
        *state->start++ = ch;
  801e4d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e51:	48 89 16             	mov    %rdx,(%rsi)
  801e54:	40 88 38             	mov    %dil,(%rax)
    }
}
  801e57:	c3                   	ret

0000000000801e58 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801e58:	f3 0f 1e fa          	endbr64
  801e5c:	55                   	push   %rbp
  801e5d:	48 89 e5             	mov    %rsp,%rbp
  801e60:	48 83 ec 50          	sub    $0x50,%rsp
  801e64:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e68:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801e6c:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801e70:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801e77:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e7b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e7f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801e83:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801e87:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801e8b:	48 b8 99 1e 80 00 00 	movabs $0x801e99,%rax
  801e92:	00 00 00 
  801e95:	ff d0                	call   *%rax
}
  801e97:	c9                   	leave
  801e98:	c3                   	ret

0000000000801e99 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801e99:	f3 0f 1e fa          	endbr64
  801e9d:	55                   	push   %rbp
  801e9e:	48 89 e5             	mov    %rsp,%rbp
  801ea1:	41 57                	push   %r15
  801ea3:	41 56                	push   %r14
  801ea5:	41 55                	push   %r13
  801ea7:	41 54                	push   %r12
  801ea9:	53                   	push   %rbx
  801eaa:	48 83 ec 38          	sub    $0x38,%rsp
  801eae:	49 89 fe             	mov    %rdi,%r14
  801eb1:	49 89 f5             	mov    %rsi,%r13
  801eb4:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  801eb7:	48 8b 01             	mov    (%rcx),%rax
  801eba:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801ebe:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801ec2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ec6:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801eca:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801ece:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  801ed2:	0f b6 3b             	movzbl (%rbx),%edi
  801ed5:	40 80 ff 25          	cmp    $0x25,%dil
  801ed9:	74 18                	je     801ef3 <vprintfmt+0x5a>
            if (!ch) return;
  801edb:	40 84 ff             	test   %dil,%dil
  801ede:	0f 84 b2 06 00 00    	je     802596 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  801ee4:	40 0f b6 ff          	movzbl %dil,%edi
  801ee8:	4c 89 ee             	mov    %r13,%rsi
  801eeb:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  801eee:	4c 89 e3             	mov    %r12,%rbx
  801ef1:	eb db                	jmp    801ece <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  801ef3:	be 00 00 00 00       	mov    $0x0,%esi
  801ef8:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  801efc:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801f01:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f07:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801f0e:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f12:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  801f17:	41 0f b6 04 24       	movzbl (%r12),%eax
  801f1c:	88 45 a0             	mov    %al,-0x60(%rbp)
  801f1f:	83 e8 23             	sub    $0x23,%eax
  801f22:	3c 57                	cmp    $0x57,%al
  801f24:	0f 87 52 06 00 00    	ja     80257c <vprintfmt+0x6e3>
  801f2a:	0f b6 c0             	movzbl %al,%eax
  801f2d:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  801f34:	00 00 00 
  801f37:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  801f3b:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  801f3e:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  801f42:	eb ce                	jmp    801f12 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  801f44:	49 89 dc             	mov    %rbx,%r12
  801f47:	be 01 00 00 00       	mov    $0x1,%esi
  801f4c:	eb c4                	jmp    801f12 <vprintfmt+0x79>
            padc = ch;
  801f4e:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  801f52:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f55:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801f58:	eb b8                	jmp    801f12 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f5d:	83 f8 2f             	cmp    $0x2f,%eax
  801f60:	77 24                	ja     801f86 <vprintfmt+0xed>
  801f62:	89 c1                	mov    %eax,%ecx
  801f64:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  801f68:	83 c0 08             	add    $0x8,%eax
  801f6b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f6e:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  801f71:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  801f74:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801f78:	79 98                	jns    801f12 <vprintfmt+0x79>
                width = precision;
  801f7a:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  801f7e:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f84:	eb 8c                	jmp    801f12 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f86:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801f8a:	48 8d 41 08          	lea    0x8(%rcx),%rax
  801f8e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801f92:	eb da                	jmp    801f6e <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  801f94:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  801f99:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801f9d:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  801fa3:	3c 39                	cmp    $0x39,%al
  801fa5:	77 1c                	ja     801fc3 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  801fa7:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  801fab:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  801faf:	0f b6 c0             	movzbl %al,%eax
  801fb2:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fb7:	0f b6 03             	movzbl (%rbx),%eax
  801fba:	3c 39                	cmp    $0x39,%al
  801fbc:	76 e9                	jbe    801fa7 <vprintfmt+0x10e>
        process_precision:
  801fbe:	49 89 dc             	mov    %rbx,%r12
  801fc1:	eb b1                	jmp    801f74 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  801fc3:	49 89 dc             	mov    %rbx,%r12
  801fc6:	eb ac                	jmp    801f74 <vprintfmt+0xdb>
            width = MAX(0, width);
  801fc8:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  801fcb:	85 c9                	test   %ecx,%ecx
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd2:	0f 49 c1             	cmovns %ecx,%eax
  801fd5:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801fd8:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fdb:	e9 32 ff ff ff       	jmp    801f12 <vprintfmt+0x79>
            lflag++;
  801fe0:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801fe3:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fe6:	e9 27 ff ff ff       	jmp    801f12 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  801feb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fee:	83 f8 2f             	cmp    $0x2f,%eax
  801ff1:	77 19                	ja     80200c <vprintfmt+0x173>
  801ff3:	89 c2                	mov    %eax,%edx
  801ff5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801ff9:	83 c0 08             	add    $0x8,%eax
  801ffc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801fff:	8b 3a                	mov    (%rdx),%edi
  802001:	4c 89 ee             	mov    %r13,%rsi
  802004:	41 ff d6             	call   *%r14
            break;
  802007:	e9 c2 fe ff ff       	jmp    801ece <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  80200c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802010:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802014:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802018:	eb e5                	jmp    801fff <vprintfmt+0x166>
            int err = va_arg(aq, int);
  80201a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80201d:	83 f8 2f             	cmp    $0x2f,%eax
  802020:	77 5a                	ja     80207c <vprintfmt+0x1e3>
  802022:	89 c2                	mov    %eax,%edx
  802024:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802028:	83 c0 08             	add    $0x8,%eax
  80202b:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  80202e:	8b 02                	mov    (%rdx),%eax
  802030:	89 c1                	mov    %eax,%ecx
  802032:	f7 d9                	neg    %ecx
  802034:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  802037:	83 f9 13             	cmp    $0x13,%ecx
  80203a:	7f 4e                	jg     80208a <vprintfmt+0x1f1>
  80203c:	48 63 c1             	movslq %ecx,%rax
  80203f:	48 ba 20 36 80 00 00 	movabs $0x803620,%rdx
  802046:	00 00 00 
  802049:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80204d:	48 85 c0             	test   %rax,%rax
  802050:	74 38                	je     80208a <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  802052:	48 89 c1             	mov    %rax,%rcx
  802055:	48 ba 80 30 80 00 00 	movabs $0x803080,%rdx
  80205c:	00 00 00 
  80205f:	4c 89 ee             	mov    %r13,%rsi
  802062:	4c 89 f7             	mov    %r14,%rdi
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	49 b8 58 1e 80 00 00 	movabs $0x801e58,%r8
  802071:	00 00 00 
  802074:	41 ff d0             	call   *%r8
  802077:	e9 52 fe ff ff       	jmp    801ece <vprintfmt+0x35>
            int err = va_arg(aq, int);
  80207c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802080:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802084:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802088:	eb a4                	jmp    80202e <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  80208a:	48 ba da 30 80 00 00 	movabs $0x8030da,%rdx
  802091:	00 00 00 
  802094:	4c 89 ee             	mov    %r13,%rsi
  802097:	4c 89 f7             	mov    %r14,%rdi
  80209a:	b8 00 00 00 00       	mov    $0x0,%eax
  80209f:	49 b8 58 1e 80 00 00 	movabs $0x801e58,%r8
  8020a6:	00 00 00 
  8020a9:	41 ff d0             	call   *%r8
  8020ac:	e9 1d fe ff ff       	jmp    801ece <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8020b1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020b4:	83 f8 2f             	cmp    $0x2f,%eax
  8020b7:	77 6c                	ja     802125 <vprintfmt+0x28c>
  8020b9:	89 c2                	mov    %eax,%edx
  8020bb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8020bf:	83 c0 08             	add    $0x8,%eax
  8020c2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020c5:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8020c8:	48 85 d2             	test   %rdx,%rdx
  8020cb:	48 b8 d3 30 80 00 00 	movabs $0x8030d3,%rax
  8020d2:	00 00 00 
  8020d5:	48 0f 45 c2          	cmovne %rdx,%rax
  8020d9:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8020dd:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8020e1:	7e 06                	jle    8020e9 <vprintfmt+0x250>
  8020e3:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8020e7:	75 4a                	jne    802133 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8020e9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8020ed:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8020f1:	0f b6 00             	movzbl (%rax),%eax
  8020f4:	84 c0                	test   %al,%al
  8020f6:	0f 85 9a 00 00 00    	jne    802196 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8020fc:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8020ff:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  802103:	85 c0                	test   %eax,%eax
  802105:	0f 8e c3 fd ff ff    	jle    801ece <vprintfmt+0x35>
  80210b:	4c 89 ee             	mov    %r13,%rsi
  80210e:	bf 20 00 00 00       	mov    $0x20,%edi
  802113:	41 ff d6             	call   *%r14
  802116:	41 83 ec 01          	sub    $0x1,%r12d
  80211a:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  80211e:	75 eb                	jne    80210b <vprintfmt+0x272>
  802120:	e9 a9 fd ff ff       	jmp    801ece <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  802125:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802129:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80212d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802131:	eb 92                	jmp    8020c5 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  802133:	49 63 f7             	movslq %r15d,%rsi
  802136:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80213a:	48 b8 5c 26 80 00 00 	movabs $0x80265c,%rax
  802141:	00 00 00 
  802144:	ff d0                	call   *%rax
  802146:	48 89 c2             	mov    %rax,%rdx
  802149:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80214c:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80214e:	8d 70 ff             	lea    -0x1(%rax),%esi
  802151:	89 75 ac             	mov    %esi,-0x54(%rbp)
  802154:	85 c0                	test   %eax,%eax
  802156:	7e 91                	jle    8020e9 <vprintfmt+0x250>
  802158:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80215d:	4c 89 ee             	mov    %r13,%rsi
  802160:	44 89 e7             	mov    %r12d,%edi
  802163:	41 ff d6             	call   *%r14
  802166:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80216a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80216d:	83 f8 ff             	cmp    $0xffffffff,%eax
  802170:	75 eb                	jne    80215d <vprintfmt+0x2c4>
  802172:	e9 72 ff ff ff       	jmp    8020e9 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  802177:	0f b6 f8             	movzbl %al,%edi
  80217a:	4c 89 ee             	mov    %r13,%rsi
  80217d:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802180:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  802184:	49 83 c4 01          	add    $0x1,%r12
  802188:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  80218e:	84 c0                	test   %al,%al
  802190:	0f 84 66 ff ff ff    	je     8020fc <vprintfmt+0x263>
  802196:	45 85 ff             	test   %r15d,%r15d
  802199:	78 0a                	js     8021a5 <vprintfmt+0x30c>
  80219b:	41 83 ef 01          	sub    $0x1,%r15d
  80219f:	0f 88 57 ff ff ff    	js     8020fc <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8021a5:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8021a9:	74 cc                	je     802177 <vprintfmt+0x2de>
  8021ab:	8d 50 e0             	lea    -0x20(%rax),%edx
  8021ae:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8021b3:	80 fa 5e             	cmp    $0x5e,%dl
  8021b6:	77 c2                	ja     80217a <vprintfmt+0x2e1>
  8021b8:	eb bd                	jmp    802177 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8021ba:	40 84 f6             	test   %sil,%sil
  8021bd:	75 26                	jne    8021e5 <vprintfmt+0x34c>
    switch (lflag) {
  8021bf:	85 d2                	test   %edx,%edx
  8021c1:	74 59                	je     80221c <vprintfmt+0x383>
  8021c3:	83 fa 01             	cmp    $0x1,%edx
  8021c6:	74 7b                	je     802243 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8021c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021cb:	83 f8 2f             	cmp    $0x2f,%eax
  8021ce:	0f 87 96 00 00 00    	ja     80226a <vprintfmt+0x3d1>
  8021d4:	89 c2                	mov    %eax,%edx
  8021d6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021da:	83 c0 08             	add    $0x8,%eax
  8021dd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021e0:	4c 8b 22             	mov    (%rdx),%r12
  8021e3:	eb 17                	jmp    8021fc <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8021e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021e8:	83 f8 2f             	cmp    $0x2f,%eax
  8021eb:	77 21                	ja     80220e <vprintfmt+0x375>
  8021ed:	89 c2                	mov    %eax,%edx
  8021ef:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021f3:	83 c0 08             	add    $0x8,%eax
  8021f6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021f9:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8021fc:	4d 85 e4             	test   %r12,%r12
  8021ff:	78 7a                	js     80227b <vprintfmt+0x3e2>
            num = i;
  802201:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  802204:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  802209:	e9 50 02 00 00       	jmp    80245e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80220e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802212:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802216:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80221a:	eb dd                	jmp    8021f9 <vprintfmt+0x360>
        return va_arg(*ap, int);
  80221c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80221f:	83 f8 2f             	cmp    $0x2f,%eax
  802222:	77 11                	ja     802235 <vprintfmt+0x39c>
  802224:	89 c2                	mov    %eax,%edx
  802226:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80222a:	83 c0 08             	add    $0x8,%eax
  80222d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802230:	4c 63 22             	movslq (%rdx),%r12
  802233:	eb c7                	jmp    8021fc <vprintfmt+0x363>
  802235:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802239:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80223d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802241:	eb ed                	jmp    802230 <vprintfmt+0x397>
        return va_arg(*ap, long);
  802243:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802246:	83 f8 2f             	cmp    $0x2f,%eax
  802249:	77 11                	ja     80225c <vprintfmt+0x3c3>
  80224b:	89 c2                	mov    %eax,%edx
  80224d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802251:	83 c0 08             	add    $0x8,%eax
  802254:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802257:	4c 8b 22             	mov    (%rdx),%r12
  80225a:	eb a0                	jmp    8021fc <vprintfmt+0x363>
  80225c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802260:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802264:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802268:	eb ed                	jmp    802257 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  80226a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80226e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802272:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802276:	e9 65 ff ff ff       	jmp    8021e0 <vprintfmt+0x347>
                putch('-', put_arg);
  80227b:	4c 89 ee             	mov    %r13,%rsi
  80227e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802283:	41 ff d6             	call   *%r14
                i = -i;
  802286:	49 f7 dc             	neg    %r12
  802289:	e9 73 ff ff ff       	jmp    802201 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  80228e:	40 84 f6             	test   %sil,%sil
  802291:	75 32                	jne    8022c5 <vprintfmt+0x42c>
    switch (lflag) {
  802293:	85 d2                	test   %edx,%edx
  802295:	74 5d                	je     8022f4 <vprintfmt+0x45b>
  802297:	83 fa 01             	cmp    $0x1,%edx
  80229a:	0f 84 82 00 00 00    	je     802322 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8022a0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022a3:	83 f8 2f             	cmp    $0x2f,%eax
  8022a6:	0f 87 a5 00 00 00    	ja     802351 <vprintfmt+0x4b8>
  8022ac:	89 c2                	mov    %eax,%edx
  8022ae:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022b2:	83 c0 08             	add    $0x8,%eax
  8022b5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022b8:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8022c0:	e9 99 01 00 00       	jmp    80245e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8022c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022c8:	83 f8 2f             	cmp    $0x2f,%eax
  8022cb:	77 19                	ja     8022e6 <vprintfmt+0x44d>
  8022cd:	89 c2                	mov    %eax,%edx
  8022cf:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022d3:	83 c0 08             	add    $0x8,%eax
  8022d6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022d9:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022dc:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8022e1:	e9 78 01 00 00       	jmp    80245e <vprintfmt+0x5c5>
  8022e6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8022ea:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8022ee:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022f2:	eb e5                	jmp    8022d9 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8022f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022f7:	83 f8 2f             	cmp    $0x2f,%eax
  8022fa:	77 18                	ja     802314 <vprintfmt+0x47b>
  8022fc:	89 c2                	mov    %eax,%edx
  8022fe:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802302:	83 c0 08             	add    $0x8,%eax
  802305:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802308:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  80230a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  80230f:	e9 4a 01 00 00       	jmp    80245e <vprintfmt+0x5c5>
  802314:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802318:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80231c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802320:	eb e6                	jmp    802308 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  802322:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802325:	83 f8 2f             	cmp    $0x2f,%eax
  802328:	77 19                	ja     802343 <vprintfmt+0x4aa>
  80232a:	89 c2                	mov    %eax,%edx
  80232c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802330:	83 c0 08             	add    $0x8,%eax
  802333:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802336:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  802339:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80233e:	e9 1b 01 00 00       	jmp    80245e <vprintfmt+0x5c5>
  802343:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802347:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80234b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80234f:	eb e5                	jmp    802336 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  802351:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802355:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802359:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80235d:	e9 56 ff ff ff       	jmp    8022b8 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  802362:	40 84 f6             	test   %sil,%sil
  802365:	75 2e                	jne    802395 <vprintfmt+0x4fc>
    switch (lflag) {
  802367:	85 d2                	test   %edx,%edx
  802369:	74 59                	je     8023c4 <vprintfmt+0x52b>
  80236b:	83 fa 01             	cmp    $0x1,%edx
  80236e:	74 7f                	je     8023ef <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  802370:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802373:	83 f8 2f             	cmp    $0x2f,%eax
  802376:	0f 87 9f 00 00 00    	ja     80241b <vprintfmt+0x582>
  80237c:	89 c2                	mov    %eax,%edx
  80237e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802382:	83 c0 08             	add    $0x8,%eax
  802385:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802388:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80238b:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  802390:	e9 c9 00 00 00       	jmp    80245e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  802395:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802398:	83 f8 2f             	cmp    $0x2f,%eax
  80239b:	77 19                	ja     8023b6 <vprintfmt+0x51d>
  80239d:	89 c2                	mov    %eax,%edx
  80239f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023a3:	83 c0 08             	add    $0x8,%eax
  8023a6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023a9:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023ac:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8023b1:	e9 a8 00 00 00       	jmp    80245e <vprintfmt+0x5c5>
  8023b6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023ba:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023be:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023c2:	eb e5                	jmp    8023a9 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8023c4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023c7:	83 f8 2f             	cmp    $0x2f,%eax
  8023ca:	77 15                	ja     8023e1 <vprintfmt+0x548>
  8023cc:	89 c2                	mov    %eax,%edx
  8023ce:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023d2:	83 c0 08             	add    $0x8,%eax
  8023d5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023d8:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8023da:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8023df:	eb 7d                	jmp    80245e <vprintfmt+0x5c5>
  8023e1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023e5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023e9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023ed:	eb e9                	jmp    8023d8 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8023ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023f2:	83 f8 2f             	cmp    $0x2f,%eax
  8023f5:	77 16                	ja     80240d <vprintfmt+0x574>
  8023f7:	89 c2                	mov    %eax,%edx
  8023f9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023fd:	83 c0 08             	add    $0x8,%eax
  802400:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802403:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  802406:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  80240b:	eb 51                	jmp    80245e <vprintfmt+0x5c5>
  80240d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802411:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802415:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802419:	eb e8                	jmp    802403 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  80241b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80241f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802423:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802427:	e9 5c ff ff ff       	jmp    802388 <vprintfmt+0x4ef>
            putch('0', put_arg);
  80242c:	4c 89 ee             	mov    %r13,%rsi
  80242f:	bf 30 00 00 00       	mov    $0x30,%edi
  802434:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  802437:	4c 89 ee             	mov    %r13,%rsi
  80243a:	bf 78 00 00 00       	mov    $0x78,%edi
  80243f:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  802442:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802445:	83 f8 2f             	cmp    $0x2f,%eax
  802448:	77 47                	ja     802491 <vprintfmt+0x5f8>
  80244a:	89 c2                	mov    %eax,%edx
  80244c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802450:	83 c0 08             	add    $0x8,%eax
  802453:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802456:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802459:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80245e:	48 83 ec 08          	sub    $0x8,%rsp
  802462:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  802466:	0f 94 c0             	sete   %al
  802469:	0f b6 c0             	movzbl %al,%eax
  80246c:	50                   	push   %rax
  80246d:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  802472:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  802476:	4c 89 ee             	mov    %r13,%rsi
  802479:	4c 89 f7             	mov    %r14,%rdi
  80247c:	48 b8 82 1d 80 00 00 	movabs $0x801d82,%rax
  802483:	00 00 00 
  802486:	ff d0                	call   *%rax
            break;
  802488:	48 83 c4 10          	add    $0x10,%rsp
  80248c:	e9 3d fa ff ff       	jmp    801ece <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  802491:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802495:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802499:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80249d:	eb b7                	jmp    802456 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  80249f:	40 84 f6             	test   %sil,%sil
  8024a2:	75 2b                	jne    8024cf <vprintfmt+0x636>
    switch (lflag) {
  8024a4:	85 d2                	test   %edx,%edx
  8024a6:	74 56                	je     8024fe <vprintfmt+0x665>
  8024a8:	83 fa 01             	cmp    $0x1,%edx
  8024ab:	74 7f                	je     80252c <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  8024ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024b0:	83 f8 2f             	cmp    $0x2f,%eax
  8024b3:	0f 87 a2 00 00 00    	ja     80255b <vprintfmt+0x6c2>
  8024b9:	89 c2                	mov    %eax,%edx
  8024bb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024bf:	83 c0 08             	add    $0x8,%eax
  8024c2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024c5:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024c8:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8024cd:	eb 8f                	jmp    80245e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8024cf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024d2:	83 f8 2f             	cmp    $0x2f,%eax
  8024d5:	77 19                	ja     8024f0 <vprintfmt+0x657>
  8024d7:	89 c2                	mov    %eax,%edx
  8024d9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024dd:	83 c0 08             	add    $0x8,%eax
  8024e0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024e3:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024e6:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8024eb:	e9 6e ff ff ff       	jmp    80245e <vprintfmt+0x5c5>
  8024f0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024f4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8024f8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024fc:	eb e5                	jmp    8024e3 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8024fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802501:	83 f8 2f             	cmp    $0x2f,%eax
  802504:	77 18                	ja     80251e <vprintfmt+0x685>
  802506:	89 c2                	mov    %eax,%edx
  802508:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80250c:	83 c0 08             	add    $0x8,%eax
  80250f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802512:	8b 12                	mov    (%rdx),%edx
            base = 16;
  802514:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  802519:	e9 40 ff ff ff       	jmp    80245e <vprintfmt+0x5c5>
  80251e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802522:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802526:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80252a:	eb e6                	jmp    802512 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  80252c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80252f:	83 f8 2f             	cmp    $0x2f,%eax
  802532:	77 19                	ja     80254d <vprintfmt+0x6b4>
  802534:	89 c2                	mov    %eax,%edx
  802536:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80253a:	83 c0 08             	add    $0x8,%eax
  80253d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802540:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802543:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  802548:	e9 11 ff ff ff       	jmp    80245e <vprintfmt+0x5c5>
  80254d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802551:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802555:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802559:	eb e5                	jmp    802540 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  80255b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80255f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802563:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802567:	e9 59 ff ff ff       	jmp    8024c5 <vprintfmt+0x62c>
            putch(ch, put_arg);
  80256c:	4c 89 ee             	mov    %r13,%rsi
  80256f:	bf 25 00 00 00       	mov    $0x25,%edi
  802574:	41 ff d6             	call   *%r14
            break;
  802577:	e9 52 f9 ff ff       	jmp    801ece <vprintfmt+0x35>
            putch('%', put_arg);
  80257c:	4c 89 ee             	mov    %r13,%rsi
  80257f:	bf 25 00 00 00       	mov    $0x25,%edi
  802584:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  802587:	48 83 eb 01          	sub    $0x1,%rbx
  80258b:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  80258f:	75 f6                	jne    802587 <vprintfmt+0x6ee>
  802591:	e9 38 f9 ff ff       	jmp    801ece <vprintfmt+0x35>
}
  802596:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80259a:	5b                   	pop    %rbx
  80259b:	41 5c                	pop    %r12
  80259d:	41 5d                	pop    %r13
  80259f:	41 5e                	pop    %r14
  8025a1:	41 5f                	pop    %r15
  8025a3:	5d                   	pop    %rbp
  8025a4:	c3                   	ret

00000000008025a5 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  8025a5:	f3 0f 1e fa          	endbr64
  8025a9:	55                   	push   %rbp
  8025aa:	48 89 e5             	mov    %rsp,%rbp
  8025ad:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  8025b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025b5:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  8025ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8025be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8025c5:	48 85 ff             	test   %rdi,%rdi
  8025c8:	74 2b                	je     8025f5 <vsnprintf+0x50>
  8025ca:	48 85 f6             	test   %rsi,%rsi
  8025cd:	74 26                	je     8025f5 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8025cf:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8025d3:	48 bf 3c 1e 80 00 00 	movabs $0x801e3c,%rdi
  8025da:	00 00 00 
  8025dd:	48 b8 99 1e 80 00 00 	movabs $0x801e99,%rax
  8025e4:	00 00 00 
  8025e7:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8025e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ed:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8025f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025f3:	c9                   	leave
  8025f4:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  8025f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025fa:	eb f7                	jmp    8025f3 <vsnprintf+0x4e>

00000000008025fc <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8025fc:	f3 0f 1e fa          	endbr64
  802600:	55                   	push   %rbp
  802601:	48 89 e5             	mov    %rsp,%rbp
  802604:	48 83 ec 50          	sub    $0x50,%rsp
  802608:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80260c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802610:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802614:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80261b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80261f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802623:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802627:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  80262b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80262f:	48 b8 a5 25 80 00 00 	movabs $0x8025a5,%rax
  802636:	00 00 00 
  802639:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  80263b:	c9                   	leave
  80263c:	c3                   	ret

000000000080263d <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  80263d:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  802641:	80 3f 00             	cmpb   $0x0,(%rdi)
  802644:	74 10                	je     802656 <strlen+0x19>
    size_t n = 0;
  802646:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  80264b:	48 83 c0 01          	add    $0x1,%rax
  80264f:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  802653:	75 f6                	jne    80264b <strlen+0xe>
  802655:	c3                   	ret
    size_t n = 0;
  802656:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  80265b:	c3                   	ret

000000000080265c <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  80265c:	f3 0f 1e fa          	endbr64
  802660:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  802663:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  802668:	48 85 f6             	test   %rsi,%rsi
  80266b:	74 10                	je     80267d <strnlen+0x21>
  80266d:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  802671:	74 0b                	je     80267e <strnlen+0x22>
  802673:	48 83 c2 01          	add    $0x1,%rdx
  802677:	48 39 d0             	cmp    %rdx,%rax
  80267a:	75 f1                	jne    80266d <strnlen+0x11>
  80267c:	c3                   	ret
  80267d:	c3                   	ret
  80267e:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  802681:	c3                   	ret

0000000000802682 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  802682:	f3 0f 1e fa          	endbr64
  802686:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  802689:	ba 00 00 00 00       	mov    $0x0,%edx
  80268e:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  802692:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  802695:	48 83 c2 01          	add    $0x1,%rdx
  802699:	84 c9                	test   %cl,%cl
  80269b:	75 f1                	jne    80268e <strcpy+0xc>
        ;
    return res;
}
  80269d:	c3                   	ret

000000000080269e <strcat>:

char *
strcat(char *dst, const char *src) {
  80269e:	f3 0f 1e fa          	endbr64
  8026a2:	55                   	push   %rbp
  8026a3:	48 89 e5             	mov    %rsp,%rbp
  8026a6:	41 54                	push   %r12
  8026a8:	53                   	push   %rbx
  8026a9:	48 89 fb             	mov    %rdi,%rbx
  8026ac:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8026af:	48 b8 3d 26 80 00 00 	movabs $0x80263d,%rax
  8026b6:	00 00 00 
  8026b9:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  8026bb:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8026bf:	4c 89 e6             	mov    %r12,%rsi
  8026c2:	48 b8 82 26 80 00 00 	movabs $0x802682,%rax
  8026c9:	00 00 00 
  8026cc:	ff d0                	call   *%rax
    return dst;
}
  8026ce:	48 89 d8             	mov    %rbx,%rax
  8026d1:	5b                   	pop    %rbx
  8026d2:	41 5c                	pop    %r12
  8026d4:	5d                   	pop    %rbp
  8026d5:	c3                   	ret

00000000008026d6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8026d6:	f3 0f 1e fa          	endbr64
  8026da:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  8026dd:	48 85 d2             	test   %rdx,%rdx
  8026e0:	74 1f                	je     802701 <strncpy+0x2b>
  8026e2:	48 01 fa             	add    %rdi,%rdx
  8026e5:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  8026e8:	48 83 c1 01          	add    $0x1,%rcx
  8026ec:	44 0f b6 06          	movzbl (%rsi),%r8d
  8026f0:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  8026f4:	41 80 f8 01          	cmp    $0x1,%r8b
  8026f8:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8026fc:	48 39 ca             	cmp    %rcx,%rdx
  8026ff:	75 e7                	jne    8026e8 <strncpy+0x12>
    }
    return ret;
}
  802701:	c3                   	ret

0000000000802702 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  802702:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  802706:	48 89 f8             	mov    %rdi,%rax
  802709:	48 85 d2             	test   %rdx,%rdx
  80270c:	74 24                	je     802732 <strlcpy+0x30>
        while (--size > 0 && *src)
  80270e:	48 83 ea 01          	sub    $0x1,%rdx
  802712:	74 1b                	je     80272f <strlcpy+0x2d>
  802714:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802718:	0f b6 16             	movzbl (%rsi),%edx
  80271b:	84 d2                	test   %dl,%dl
  80271d:	74 10                	je     80272f <strlcpy+0x2d>
            *dst++ = *src++;
  80271f:	48 83 c6 01          	add    $0x1,%rsi
  802723:	48 83 c0 01          	add    $0x1,%rax
  802727:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80272a:	48 39 c8             	cmp    %rcx,%rax
  80272d:	75 e9                	jne    802718 <strlcpy+0x16>
        *dst = '\0';
  80272f:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  802732:	48 29 f8             	sub    %rdi,%rax
}
  802735:	c3                   	ret

0000000000802736 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  802736:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  80273a:	0f b6 07             	movzbl (%rdi),%eax
  80273d:	84 c0                	test   %al,%al
  80273f:	74 13                	je     802754 <strcmp+0x1e>
  802741:	38 06                	cmp    %al,(%rsi)
  802743:	75 0f                	jne    802754 <strcmp+0x1e>
  802745:	48 83 c7 01          	add    $0x1,%rdi
  802749:	48 83 c6 01          	add    $0x1,%rsi
  80274d:	0f b6 07             	movzbl (%rdi),%eax
  802750:	84 c0                	test   %al,%al
  802752:	75 ed                	jne    802741 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  802754:	0f b6 c0             	movzbl %al,%eax
  802757:	0f b6 16             	movzbl (%rsi),%edx
  80275a:	29 d0                	sub    %edx,%eax
}
  80275c:	c3                   	ret

000000000080275d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  80275d:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  802761:	48 85 d2             	test   %rdx,%rdx
  802764:	74 1f                	je     802785 <strncmp+0x28>
  802766:	0f b6 07             	movzbl (%rdi),%eax
  802769:	84 c0                	test   %al,%al
  80276b:	74 1e                	je     80278b <strncmp+0x2e>
  80276d:	3a 06                	cmp    (%rsi),%al
  80276f:	75 1a                	jne    80278b <strncmp+0x2e>
  802771:	48 83 c7 01          	add    $0x1,%rdi
  802775:	48 83 c6 01          	add    $0x1,%rsi
  802779:	48 83 ea 01          	sub    $0x1,%rdx
  80277d:	75 e7                	jne    802766 <strncmp+0x9>

    if (!n) return 0;
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
  802784:	c3                   	ret
  802785:	b8 00 00 00 00       	mov    $0x0,%eax
  80278a:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  80278b:	0f b6 07             	movzbl (%rdi),%eax
  80278e:	0f b6 16             	movzbl (%rsi),%edx
  802791:	29 d0                	sub    %edx,%eax
}
  802793:	c3                   	ret

0000000000802794 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  802794:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  802798:	0f b6 17             	movzbl (%rdi),%edx
  80279b:	84 d2                	test   %dl,%dl
  80279d:	74 18                	je     8027b7 <strchr+0x23>
        if (*str == c) {
  80279f:	0f be d2             	movsbl %dl,%edx
  8027a2:	39 f2                	cmp    %esi,%edx
  8027a4:	74 17                	je     8027bd <strchr+0x29>
    for (; *str; str++) {
  8027a6:	48 83 c7 01          	add    $0x1,%rdi
  8027aa:	0f b6 17             	movzbl (%rdi),%edx
  8027ad:	84 d2                	test   %dl,%dl
  8027af:	75 ee                	jne    80279f <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  8027b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b6:	c3                   	ret
  8027b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bc:	c3                   	ret
            return (char *)str;
  8027bd:	48 89 f8             	mov    %rdi,%rax
}
  8027c0:	c3                   	ret

00000000008027c1 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  8027c1:	f3 0f 1e fa          	endbr64
  8027c5:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  8027c8:	0f b6 17             	movzbl (%rdi),%edx
  8027cb:	84 d2                	test   %dl,%dl
  8027cd:	74 13                	je     8027e2 <strfind+0x21>
  8027cf:	0f be d2             	movsbl %dl,%edx
  8027d2:	39 f2                	cmp    %esi,%edx
  8027d4:	74 0b                	je     8027e1 <strfind+0x20>
  8027d6:	48 83 c0 01          	add    $0x1,%rax
  8027da:	0f b6 10             	movzbl (%rax),%edx
  8027dd:	84 d2                	test   %dl,%dl
  8027df:	75 ee                	jne    8027cf <strfind+0xe>
        ;
    return (char *)str;
}
  8027e1:	c3                   	ret
  8027e2:	c3                   	ret

00000000008027e3 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8027e3:	f3 0f 1e fa          	endbr64
  8027e7:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  8027ea:	48 89 f8             	mov    %rdi,%rax
  8027ed:	48 f7 d8             	neg    %rax
  8027f0:	83 e0 07             	and    $0x7,%eax
  8027f3:	49 89 d1             	mov    %rdx,%r9
  8027f6:	49 29 c1             	sub    %rax,%r9
  8027f9:	78 36                	js     802831 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8027fb:	40 0f b6 c6          	movzbl %sil,%eax
  8027ff:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  802806:	01 01 01 
  802809:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80280d:	40 f6 c7 07          	test   $0x7,%dil
  802811:	75 38                	jne    80284b <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  802813:	4c 89 c9             	mov    %r9,%rcx
  802816:	48 c1 f9 03          	sar    $0x3,%rcx
  80281a:	74 0c                	je     802828 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80281c:	fc                   	cld
  80281d:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802820:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  802824:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  802828:	4d 85 c9             	test   %r9,%r9
  80282b:	75 45                	jne    802872 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  80282d:	4c 89 c0             	mov    %r8,%rax
  802830:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  802831:	48 85 d2             	test   %rdx,%rdx
  802834:	74 f7                	je     80282d <memset+0x4a>
  802836:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  802839:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  80283c:	48 83 c0 01          	add    $0x1,%rax
  802840:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  802844:	48 39 c2             	cmp    %rax,%rdx
  802847:	75 f3                	jne    80283c <memset+0x59>
  802849:	eb e2                	jmp    80282d <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  80284b:	40 f6 c7 01          	test   $0x1,%dil
  80284f:	74 06                	je     802857 <memset+0x74>
  802851:	88 07                	mov    %al,(%rdi)
  802853:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  802857:	40 f6 c7 02          	test   $0x2,%dil
  80285b:	74 07                	je     802864 <memset+0x81>
  80285d:	66 89 07             	mov    %ax,(%rdi)
  802860:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  802864:	40 f6 c7 04          	test   $0x4,%dil
  802868:	74 a9                	je     802813 <memset+0x30>
  80286a:	89 07                	mov    %eax,(%rdi)
  80286c:	48 83 c7 04          	add    $0x4,%rdi
  802870:	eb a1                	jmp    802813 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  802872:	41 f6 c1 04          	test   $0x4,%r9b
  802876:	74 1b                	je     802893 <memset+0xb0>
  802878:	89 07                	mov    %eax,(%rdi)
  80287a:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80287e:	41 f6 c1 02          	test   $0x2,%r9b
  802882:	74 07                	je     80288b <memset+0xa8>
  802884:	66 89 07             	mov    %ax,(%rdi)
  802887:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80288b:	41 f6 c1 01          	test   $0x1,%r9b
  80288f:	74 9c                	je     80282d <memset+0x4a>
  802891:	eb 06                	jmp    802899 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  802893:	41 f6 c1 02          	test   $0x2,%r9b
  802897:	75 eb                	jne    802884 <memset+0xa1>
        if (ni & 1) *ptr = k;
  802899:	88 07                	mov    %al,(%rdi)
  80289b:	eb 90                	jmp    80282d <memset+0x4a>

000000000080289d <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  80289d:	f3 0f 1e fa          	endbr64
  8028a1:	48 89 f8             	mov    %rdi,%rax
  8028a4:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8028a7:	48 39 fe             	cmp    %rdi,%rsi
  8028aa:	73 3b                	jae    8028e7 <memmove+0x4a>
  8028ac:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8028b0:	48 39 d7             	cmp    %rdx,%rdi
  8028b3:	73 32                	jae    8028e7 <memmove+0x4a>
        s += n;
        d += n;
  8028b5:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028b9:	48 89 d6             	mov    %rdx,%rsi
  8028bc:	48 09 fe             	or     %rdi,%rsi
  8028bf:	48 09 ce             	or     %rcx,%rsi
  8028c2:	40 f6 c6 07          	test   $0x7,%sil
  8028c6:	75 12                	jne    8028da <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8028c8:	48 83 ef 08          	sub    $0x8,%rdi
  8028cc:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8028d0:	48 c1 e9 03          	shr    $0x3,%rcx
  8028d4:	fd                   	std
  8028d5:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8028d8:	fc                   	cld
  8028d9:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8028da:	48 83 ef 01          	sub    $0x1,%rdi
  8028de:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8028e2:	fd                   	std
  8028e3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8028e5:	eb f1                	jmp    8028d8 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028e7:	48 89 f2             	mov    %rsi,%rdx
  8028ea:	48 09 c2             	or     %rax,%rdx
  8028ed:	48 09 ca             	or     %rcx,%rdx
  8028f0:	f6 c2 07             	test   $0x7,%dl
  8028f3:	75 0c                	jne    802901 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8028f5:	48 c1 e9 03          	shr    $0x3,%rcx
  8028f9:	48 89 c7             	mov    %rax,%rdi
  8028fc:	fc                   	cld
  8028fd:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  802900:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  802901:	48 89 c7             	mov    %rax,%rdi
  802904:	fc                   	cld
  802905:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  802907:	c3                   	ret

0000000000802908 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  802908:	f3 0f 1e fa          	endbr64
  80290c:	55                   	push   %rbp
  80290d:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802910:	48 b8 9d 28 80 00 00 	movabs $0x80289d,%rax
  802917:	00 00 00 
  80291a:	ff d0                	call   *%rax
}
  80291c:	5d                   	pop    %rbp
  80291d:	c3                   	ret

000000000080291e <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80291e:	f3 0f 1e fa          	endbr64
  802922:	55                   	push   %rbp
  802923:	48 89 e5             	mov    %rsp,%rbp
  802926:	41 57                	push   %r15
  802928:	41 56                	push   %r14
  80292a:	41 55                	push   %r13
  80292c:	41 54                	push   %r12
  80292e:	53                   	push   %rbx
  80292f:	48 83 ec 08          	sub    $0x8,%rsp
  802933:	49 89 fe             	mov    %rdi,%r14
  802936:	49 89 f7             	mov    %rsi,%r15
  802939:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  80293c:	48 89 f7             	mov    %rsi,%rdi
  80293f:	48 b8 3d 26 80 00 00 	movabs $0x80263d,%rax
  802946:	00 00 00 
  802949:	ff d0                	call   *%rax
  80294b:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80294e:	48 89 de             	mov    %rbx,%rsi
  802951:	4c 89 f7             	mov    %r14,%rdi
  802954:	48 b8 5c 26 80 00 00 	movabs $0x80265c,%rax
  80295b:	00 00 00 
  80295e:	ff d0                	call   *%rax
  802960:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  802963:	48 39 c3             	cmp    %rax,%rbx
  802966:	74 36                	je     80299e <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  802968:	48 89 d8             	mov    %rbx,%rax
  80296b:	4c 29 e8             	sub    %r13,%rax
  80296e:	49 39 c4             	cmp    %rax,%r12
  802971:	73 31                	jae    8029a4 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  802973:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  802978:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80297c:	4c 89 fe             	mov    %r15,%rsi
  80297f:	48 b8 08 29 80 00 00 	movabs $0x802908,%rax
  802986:	00 00 00 
  802989:	ff d0                	call   *%rax
    return dstlen + srclen;
  80298b:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80298f:	48 83 c4 08          	add    $0x8,%rsp
  802993:	5b                   	pop    %rbx
  802994:	41 5c                	pop    %r12
  802996:	41 5d                	pop    %r13
  802998:	41 5e                	pop    %r14
  80299a:	41 5f                	pop    %r15
  80299c:	5d                   	pop    %rbp
  80299d:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  80299e:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  8029a2:	eb eb                	jmp    80298f <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  8029a4:	48 83 eb 01          	sub    $0x1,%rbx
  8029a8:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8029ac:	48 89 da             	mov    %rbx,%rdx
  8029af:	4c 89 fe             	mov    %r15,%rsi
  8029b2:	48 b8 08 29 80 00 00 	movabs $0x802908,%rax
  8029b9:	00 00 00 
  8029bc:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8029be:	49 01 de             	add    %rbx,%r14
  8029c1:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8029c6:	eb c3                	jmp    80298b <strlcat+0x6d>

00000000008029c8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8029c8:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8029cc:	48 85 d2             	test   %rdx,%rdx
  8029cf:	74 2d                	je     8029fe <memcmp+0x36>
  8029d1:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8029d6:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8029da:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8029df:	44 38 c1             	cmp    %r8b,%cl
  8029e2:	75 0f                	jne    8029f3 <memcmp+0x2b>
    while (n-- > 0) {
  8029e4:	48 83 c0 01          	add    $0x1,%rax
  8029e8:	48 39 c2             	cmp    %rax,%rdx
  8029eb:	75 e9                	jne    8029d6 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8029ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f2:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8029f3:	0f b6 c1             	movzbl %cl,%eax
  8029f6:	45 0f b6 c0          	movzbl %r8b,%r8d
  8029fa:	44 29 c0             	sub    %r8d,%eax
  8029fd:	c3                   	ret
    return 0;
  8029fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a03:	c3                   	ret

0000000000802a04 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  802a04:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  802a08:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802a0c:	48 39 c7             	cmp    %rax,%rdi
  802a0f:	73 0f                	jae    802a20 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802a11:	40 38 37             	cmp    %sil,(%rdi)
  802a14:	74 0e                	je     802a24 <memfind+0x20>
    for (; src < end; src++) {
  802a16:	48 83 c7 01          	add    $0x1,%rdi
  802a1a:	48 39 f8             	cmp    %rdi,%rax
  802a1d:	75 f2                	jne    802a11 <memfind+0xd>
  802a1f:	c3                   	ret
  802a20:	48 89 f8             	mov    %rdi,%rax
  802a23:	c3                   	ret
  802a24:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802a27:	c3                   	ret

0000000000802a28 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802a28:	f3 0f 1e fa          	endbr64
  802a2c:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802a2f:	0f b6 37             	movzbl (%rdi),%esi
  802a32:	40 80 fe 20          	cmp    $0x20,%sil
  802a36:	74 06                	je     802a3e <strtol+0x16>
  802a38:	40 80 fe 09          	cmp    $0x9,%sil
  802a3c:	75 13                	jne    802a51 <strtol+0x29>
  802a3e:	48 83 c7 01          	add    $0x1,%rdi
  802a42:	0f b6 37             	movzbl (%rdi),%esi
  802a45:	40 80 fe 20          	cmp    $0x20,%sil
  802a49:	74 f3                	je     802a3e <strtol+0x16>
  802a4b:	40 80 fe 09          	cmp    $0x9,%sil
  802a4f:	74 ed                	je     802a3e <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802a51:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802a54:	83 e0 fd             	and    $0xfffffffd,%eax
  802a57:	3c 01                	cmp    $0x1,%al
  802a59:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a5d:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  802a63:	75 0f                	jne    802a74 <strtol+0x4c>
  802a65:	80 3f 30             	cmpb   $0x30,(%rdi)
  802a68:	74 14                	je     802a7e <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802a6a:	85 d2                	test   %edx,%edx
  802a6c:	b8 0a 00 00 00       	mov    $0xa,%eax
  802a71:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  802a74:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  802a79:	4c 63 ca             	movslq %edx,%r9
  802a7c:	eb 36                	jmp    802ab4 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a7e:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  802a82:	74 0f                	je     802a93 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  802a84:	85 d2                	test   %edx,%edx
  802a86:	75 ec                	jne    802a74 <strtol+0x4c>
        s++;
  802a88:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  802a8c:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  802a91:	eb e1                	jmp    802a74 <strtol+0x4c>
        s += 2;
  802a93:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  802a97:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  802a9c:	eb d6                	jmp    802a74 <strtol+0x4c>
            dig -= '0';
  802a9e:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  802aa1:	44 0f b6 c1          	movzbl %cl,%r8d
  802aa5:	41 39 d0             	cmp    %edx,%r8d
  802aa8:	7d 21                	jge    802acb <strtol+0xa3>
        val = val * base + dig;
  802aaa:	49 0f af c1          	imul   %r9,%rax
  802aae:	0f b6 c9             	movzbl %cl,%ecx
  802ab1:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  802ab4:	48 83 c7 01          	add    $0x1,%rdi
  802ab8:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  802abc:	80 f9 39             	cmp    $0x39,%cl
  802abf:	76 dd                	jbe    802a9e <strtol+0x76>
        else if (dig - 'a' < 27)
  802ac1:	80 f9 7b             	cmp    $0x7b,%cl
  802ac4:	77 05                	ja     802acb <strtol+0xa3>
            dig -= 'a' - 10;
  802ac6:	83 e9 57             	sub    $0x57,%ecx
  802ac9:	eb d6                	jmp    802aa1 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  802acb:	4d 85 d2             	test   %r10,%r10
  802ace:	74 03                	je     802ad3 <strtol+0xab>
  802ad0:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802ad3:	48 89 c2             	mov    %rax,%rdx
  802ad6:	48 f7 da             	neg    %rdx
  802ad9:	40 80 fe 2d          	cmp    $0x2d,%sil
  802add:	48 0f 44 c2          	cmove  %rdx,%rax
}
  802ae1:	c3                   	ret

0000000000802ae2 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802ae2:	f3 0f 1e fa          	endbr64
  802ae6:	55                   	push   %rbp
  802ae7:	48 89 e5             	mov    %rsp,%rbp
  802aea:	41 54                	push   %r12
  802aec:	53                   	push   %rbx
  802aed:	48 89 fb             	mov    %rdi,%rbx
  802af0:	48 89 f7             	mov    %rsi,%rdi
  802af3:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802af6:	48 85 f6             	test   %rsi,%rsi
  802af9:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b00:	00 00 00 
  802b03:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b07:	be 00 10 00 00       	mov    $0x1000,%esi
  802b0c:	48 b8 d4 05 80 00 00 	movabs $0x8005d4,%rax
  802b13:	00 00 00 
  802b16:	ff d0                	call   *%rax
    if (res < 0) {
  802b18:	85 c0                	test   %eax,%eax
  802b1a:	78 45                	js     802b61 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b1c:	48 85 db             	test   %rbx,%rbx
  802b1f:	74 12                	je     802b33 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b21:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b28:	00 00 00 
  802b2b:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b31:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b33:	4d 85 e4             	test   %r12,%r12
  802b36:	74 14                	je     802b4c <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b38:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b3f:	00 00 00 
  802b42:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b48:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b4c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b53:	00 00 00 
  802b56:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b5c:	5b                   	pop    %rbx
  802b5d:	41 5c                	pop    %r12
  802b5f:	5d                   	pop    %rbp
  802b60:	c3                   	ret
        if (from_env_store != NULL) {
  802b61:	48 85 db             	test   %rbx,%rbx
  802b64:	74 06                	je     802b6c <ipc_recv+0x8a>
            *from_env_store = 0;
  802b66:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b6c:	4d 85 e4             	test   %r12,%r12
  802b6f:	74 eb                	je     802b5c <ipc_recv+0x7a>
            *perm_store = 0;
  802b71:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b78:	00 
  802b79:	eb e1                	jmp    802b5c <ipc_recv+0x7a>

0000000000802b7b <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b7b:	f3 0f 1e fa          	endbr64
  802b7f:	55                   	push   %rbp
  802b80:	48 89 e5             	mov    %rsp,%rbp
  802b83:	41 57                	push   %r15
  802b85:	41 56                	push   %r14
  802b87:	41 55                	push   %r13
  802b89:	41 54                	push   %r12
  802b8b:	53                   	push   %rbx
  802b8c:	48 83 ec 18          	sub    $0x18,%rsp
  802b90:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802b93:	48 89 d3             	mov    %rdx,%rbx
  802b96:	49 89 cc             	mov    %rcx,%r12
  802b99:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b9c:	48 85 d2             	test   %rdx,%rdx
  802b9f:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802ba6:	00 00 00 
  802ba9:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bad:	89 f0                	mov    %esi,%eax
  802baf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802bb3:	48 89 da             	mov    %rbx,%rdx
  802bb6:	48 89 c6             	mov    %rax,%rsi
  802bb9:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  802bc0:	00 00 00 
  802bc3:	ff d0                	call   *%rax
    while (res < 0) {
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	79 65                	jns    802c2e <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bc9:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bcc:	75 33                	jne    802c01 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802bce:	49 bf 17 02 80 00 00 	movabs $0x800217,%r15
  802bd5:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bd8:	49 be a4 05 80 00 00 	movabs $0x8005a4,%r14
  802bdf:	00 00 00 
        sys_yield();
  802be2:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802be5:	45 89 e8             	mov    %r13d,%r8d
  802be8:	4c 89 e1             	mov    %r12,%rcx
  802beb:	48 89 da             	mov    %rbx,%rdx
  802bee:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802bf2:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802bf5:	41 ff d6             	call   *%r14
    while (res < 0) {
  802bf8:	85 c0                	test   %eax,%eax
  802bfa:	79 32                	jns    802c2e <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bfc:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bff:	74 e1                	je     802be2 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c01:	89 c1                	mov    %eax,%ecx
  802c03:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  802c0a:	00 00 00 
  802c0d:	be 42 00 00 00       	mov    $0x42,%esi
  802c12:	48 bf 4b 32 80 00 00 	movabs $0x80324b,%rdi
  802c19:	00 00 00 
  802c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c21:	49 b8 dd 1b 80 00 00 	movabs $0x801bdd,%r8
  802c28:	00 00 00 
  802c2b:	41 ff d0             	call   *%r8
    }
}
  802c2e:	48 83 c4 18          	add    $0x18,%rsp
  802c32:	5b                   	pop    %rbx
  802c33:	41 5c                	pop    %r12
  802c35:	41 5d                	pop    %r13
  802c37:	41 5e                	pop    %r14
  802c39:	41 5f                	pop    %r15
  802c3b:	5d                   	pop    %rbp
  802c3c:	c3                   	ret

0000000000802c3d <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c3d:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c41:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c46:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c4d:	00 00 00 
  802c50:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c54:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c58:	48 c1 e2 04          	shl    $0x4,%rdx
  802c5c:	48 01 ca             	add    %rcx,%rdx
  802c5f:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c65:	39 fa                	cmp    %edi,%edx
  802c67:	74 12                	je     802c7b <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c69:	48 83 c0 01          	add    $0x1,%rax
  802c6d:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c73:	75 db                	jne    802c50 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802c75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c7a:	c3                   	ret
            return envs[i].env_id;
  802c7b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c7f:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c83:	48 c1 e2 04          	shl    $0x4,%rdx
  802c87:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802c8e:	00 00 00 
  802c91:	48 01 d0             	add    %rdx,%rax
  802c94:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c9a:	c3                   	ret

0000000000802c9b <__text_end>:
  802c9b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ca2:	00 00 00 
  802ca5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cac:	00 00 00 
  802caf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cb6:	00 00 00 
  802cb9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cc0:	00 00 00 
  802cc3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cca:	00 00 00 
  802ccd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cd4:	00 00 00 
  802cd7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cde:	00 00 00 
  802ce1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ce8:	00 00 00 
  802ceb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cf2:	00 00 00 
  802cf5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cfc:	00 00 00 
  802cff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d06:	00 00 00 
  802d09:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d10:	00 00 00 
  802d13:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d1a:	00 00 00 
  802d1d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d24:	00 00 00 
  802d27:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d2e:	00 00 00 
  802d31:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d38:	00 00 00 
  802d3b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d42:	00 00 00 
  802d45:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d4c:	00 00 00 
  802d4f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d56:	00 00 00 
  802d59:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d60:	00 00 00 
  802d63:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d6a:	00 00 00 
  802d6d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d74:	00 00 00 
  802d77:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d7e:	00 00 00 
  802d81:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d88:	00 00 00 
  802d8b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d92:	00 00 00 
  802d95:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d9c:	00 00 00 
  802d9f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802da6:	00 00 00 
  802da9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802db0:	00 00 00 
  802db3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dba:	00 00 00 
  802dbd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dc4:	00 00 00 
  802dc7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dce:	00 00 00 
  802dd1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd8:	00 00 00 
  802ddb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de2:	00 00 00 
  802de5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dec:	00 00 00 
  802def:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df6:	00 00 00 
  802df9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e00:	00 00 00 
  802e03:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e0a:	00 00 00 
  802e0d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e14:	00 00 00 
  802e17:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e1e:	00 00 00 
  802e21:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e28:	00 00 00 
  802e2b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e32:	00 00 00 
  802e35:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e3c:	00 00 00 
  802e3f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e46:	00 00 00 
  802e49:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e50:	00 00 00 
  802e53:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e5a:	00 00 00 
  802e5d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e64:	00 00 00 
  802e67:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e6e:	00 00 00 
  802e71:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e78:	00 00 00 
  802e7b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e82:	00 00 00 
  802e85:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e8c:	00 00 00 
  802e8f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e96:	00 00 00 
  802e99:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea0:	00 00 00 
  802ea3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eaa:	00 00 00 
  802ead:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb4:	00 00 00 
  802eb7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ebe:	00 00 00 
  802ec1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec8:	00 00 00 
  802ecb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed2:	00 00 00 
  802ed5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802edc:	00 00 00 
  802edf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee6:	00 00 00 
  802ee9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef0:	00 00 00 
  802ef3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802efa:	00 00 00 
  802efd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f04:	00 00 00 
  802f07:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f0e:	00 00 00 
  802f11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f18:	00 00 00 
  802f1b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f22:	00 00 00 
  802f25:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f2c:	00 00 00 
  802f2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f36:	00 00 00 
  802f39:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f40:	00 00 00 
  802f43:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f4a:	00 00 00 
  802f4d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f54:	00 00 00 
  802f57:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f5e:	00 00 00 
  802f61:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f68:	00 00 00 
  802f6b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f72:	00 00 00 
  802f75:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f7c:	00 00 00 
  802f7f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f86:	00 00 00 
  802f89:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f90:	00 00 00 
  802f93:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f9a:	00 00 00 
  802f9d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa4:	00 00 00 
  802fa7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fae:	00 00 00 
  802fb1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb8:	00 00 00 
  802fbb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc2:	00 00 00 
  802fc5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fcc:	00 00 00 
  802fcf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd6:	00 00 00 
  802fd9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe0:	00 00 00 
  802fe3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fea:	00 00 00 
  802fed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff4:	00 00 00 
  802ff7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  802ffe:	00 00 
