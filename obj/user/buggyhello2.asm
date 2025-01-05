
obj/user/buggyhello2:     file format elf64-x86-64


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
  80001e:	e8 2a 00 00 00       	call   80004d <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

const char *hello = "hello, world\n";

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
    sys_cputs(hello, 1024 * 1024);
  80002d:	be 00 00 10 00       	mov    $0x100000,%esi
  800032:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800039:	00 00 00 
  80003c:	48 8b 38             	mov    (%rax),%rdi
  80003f:	48 b8 26 01 80 00 00 	movabs $0x800126,%rax
  800046:	00 00 00 
  800049:	ff d0                	call   *%rax
}
  80004b:	5d                   	pop    %rbp
  80004c:	c3                   	ret

000000000080004d <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80004d:	f3 0f 1e fa          	endbr64
  800051:	55                   	push   %rbp
  800052:	48 89 e5             	mov    %rsp,%rbp
  800055:	41 56                	push   %r14
  800057:	41 55                	push   %r13
  800059:	41 54                	push   %r12
  80005b:	53                   	push   %rbx
  80005c:	41 89 fd             	mov    %edi,%r13d
  80005f:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800062:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800069:	00 00 00 
  80006c:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800073:	00 00 00 
  800076:	48 39 c2             	cmp    %rax,%rdx
  800079:	73 17                	jae    800092 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80007b:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80007e:	49 89 c4             	mov    %rax,%r12
  800081:	48 83 c3 08          	add    $0x8,%rbx
  800085:	b8 00 00 00 00       	mov    $0x0,%eax
  80008a:	ff 53 f8             	call   *-0x8(%rbx)
  80008d:	4c 39 e3             	cmp    %r12,%rbx
  800090:	72 ef                	jb     800081 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800092:	48 b8 fb 01 80 00 00 	movabs $0x8001fb,%rax
  800099:	00 00 00 
  80009c:	ff d0                	call   *%rax
  80009e:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a3:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000a7:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000ab:	48 c1 e0 04          	shl    $0x4,%rax
  8000af:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000b6:	00 00 00 
  8000b9:	48 01 d0             	add    %rdx,%rax
  8000bc:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000c3:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000c6:	45 85 ed             	test   %r13d,%r13d
  8000c9:	7e 0d                	jle    8000d8 <libmain+0x8b>
  8000cb:	49 8b 06             	mov    (%r14),%rax
  8000ce:	48 a3 08 40 80 00 00 	movabs %rax,0x804008
  8000d5:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000d8:	4c 89 f6             	mov    %r14,%rsi
  8000db:	44 89 ef             	mov    %r13d,%edi
  8000de:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000ea:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  8000f1:	00 00 00 
  8000f4:	ff d0                	call   *%rax
#endif
}
  8000f6:	5b                   	pop    %rbx
  8000f7:	41 5c                	pop    %r12
  8000f9:	41 5d                	pop    %r13
  8000fb:	41 5e                	pop    %r14
  8000fd:	5d                   	pop    %rbp
  8000fe:	c3                   	ret

00000000008000ff <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000ff:	f3 0f 1e fa          	endbr64
  800103:	55                   	push   %rbp
  800104:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800107:	48 b8 d1 08 80 00 00 	movabs $0x8008d1,%rax
  80010e:	00 00 00 
  800111:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800113:	bf 00 00 00 00       	mov    $0x0,%edi
  800118:	48 b8 8c 01 80 00 00 	movabs $0x80018c,%rax
  80011f:	00 00 00 
  800122:	ff d0                	call   *%rax
}
  800124:	5d                   	pop    %rbp
  800125:	c3                   	ret

0000000000800126 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800126:	f3 0f 1e fa          	endbr64
  80012a:	55                   	push   %rbp
  80012b:	48 89 e5             	mov    %rsp,%rbp
  80012e:	53                   	push   %rbx
  80012f:	48 89 fa             	mov    %rdi,%rdx
  800132:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800135:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80013a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80013f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800144:	be 00 00 00 00       	mov    $0x0,%esi
  800149:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80014f:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800151:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800155:	c9                   	leave
  800156:	c3                   	ret

0000000000800157 <sys_cgetc>:

int
sys_cgetc(void) {
  800157:	f3 0f 1e fa          	endbr64
  80015b:	55                   	push   %rbp
  80015c:	48 89 e5             	mov    %rsp,%rbp
  80015f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800160:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800165:	ba 00 00 00 00       	mov    $0x0,%edx
  80016a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80016f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800174:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800179:	be 00 00 00 00       	mov    $0x0,%esi
  80017e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800184:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800186:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80018a:	c9                   	leave
  80018b:	c3                   	ret

000000000080018c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80018c:	f3 0f 1e fa          	endbr64
  800190:	55                   	push   %rbp
  800191:	48 89 e5             	mov    %rsp,%rbp
  800194:	53                   	push   %rbx
  800195:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800199:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80019c:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001a1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ab:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001b0:	be 00 00 00 00       	mov    $0x0,%esi
  8001b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001bb:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001bd:	48 85 c0             	test   %rax,%rax
  8001c0:	7f 06                	jg     8001c8 <sys_env_destroy+0x3c>
}
  8001c2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001c6:	c9                   	leave
  8001c7:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001c8:	49 89 c0             	mov    %rax,%r8
  8001cb:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001d0:	48 ba 68 32 80 00 00 	movabs $0x803268,%rdx
  8001d7:	00 00 00 
  8001da:	be 26 00 00 00       	mov    $0x26,%esi
  8001df:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  8001e6:	00 00 00 
  8001e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ee:	49 b9 f6 1b 80 00 00 	movabs $0x801bf6,%r9
  8001f5:	00 00 00 
  8001f8:	41 ff d1             	call   *%r9

00000000008001fb <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001fb:	f3 0f 1e fa          	endbr64
  8001ff:	55                   	push   %rbp
  800200:	48 89 e5             	mov    %rsp,%rbp
  800203:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800204:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800209:	ba 00 00 00 00       	mov    $0x0,%edx
  80020e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800213:	bb 00 00 00 00       	mov    $0x0,%ebx
  800218:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80021d:	be 00 00 00 00       	mov    $0x0,%esi
  800222:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800228:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80022a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80022e:	c9                   	leave
  80022f:	c3                   	ret

0000000000800230 <sys_yield>:

void
sys_yield(void) {
  800230:	f3 0f 1e fa          	endbr64
  800234:	55                   	push   %rbp
  800235:	48 89 e5             	mov    %rsp,%rbp
  800238:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800239:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80023e:	ba 00 00 00 00       	mov    $0x0,%edx
  800243:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800248:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800252:	be 00 00 00 00       	mov    $0x0,%esi
  800257:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80025d:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80025f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800263:	c9                   	leave
  800264:	c3                   	ret

0000000000800265 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  800265:	f3 0f 1e fa          	endbr64
  800269:	55                   	push   %rbp
  80026a:	48 89 e5             	mov    %rsp,%rbp
  80026d:	53                   	push   %rbx
  80026e:	48 89 fa             	mov    %rdi,%rdx
  800271:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800274:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800279:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800280:	00 00 00 
  800283:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800288:	be 00 00 00 00       	mov    $0x0,%esi
  80028d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800293:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800295:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800299:	c9                   	leave
  80029a:	c3                   	ret

000000000080029b <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80029b:	f3 0f 1e fa          	endbr64
  80029f:	55                   	push   %rbp
  8002a0:	48 89 e5             	mov    %rsp,%rbp
  8002a3:	53                   	push   %rbx
  8002a4:	49 89 f8             	mov    %rdi,%r8
  8002a7:	48 89 d3             	mov    %rdx,%rbx
  8002aa:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8002ad:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002b2:	4c 89 c2             	mov    %r8,%rdx
  8002b5:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002b8:	be 00 00 00 00       	mov    $0x0,%esi
  8002bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002c3:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002c9:	c9                   	leave
  8002ca:	c3                   	ret

00000000008002cb <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002cb:	f3 0f 1e fa          	endbr64
  8002cf:	55                   	push   %rbp
  8002d0:	48 89 e5             	mov    %rsp,%rbp
  8002d3:	53                   	push   %rbx
  8002d4:	48 83 ec 08          	sub    $0x8,%rsp
  8002d8:	89 f8                	mov    %edi,%eax
  8002da:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002dd:	48 63 f9             	movslq %ecx,%rdi
  8002e0:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002e3:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002e8:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002eb:	be 00 00 00 00       	mov    $0x0,%esi
  8002f0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002f6:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002f8:	48 85 c0             	test   %rax,%rax
  8002fb:	7f 06                	jg     800303 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002fd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800301:	c9                   	leave
  800302:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800303:	49 89 c0             	mov    %rax,%r8
  800306:	b9 04 00 00 00       	mov    $0x4,%ecx
  80030b:	48 ba 68 32 80 00 00 	movabs $0x803268,%rdx
  800312:	00 00 00 
  800315:	be 26 00 00 00       	mov    $0x26,%esi
  80031a:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  800321:	00 00 00 
  800324:	b8 00 00 00 00       	mov    $0x0,%eax
  800329:	49 b9 f6 1b 80 00 00 	movabs $0x801bf6,%r9
  800330:	00 00 00 
  800333:	41 ff d1             	call   *%r9

0000000000800336 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  800336:	f3 0f 1e fa          	endbr64
  80033a:	55                   	push   %rbp
  80033b:	48 89 e5             	mov    %rsp,%rbp
  80033e:	53                   	push   %rbx
  80033f:	48 83 ec 08          	sub    $0x8,%rsp
  800343:	89 f8                	mov    %edi,%eax
  800345:	49 89 f2             	mov    %rsi,%r10
  800348:	48 89 cf             	mov    %rcx,%rdi
  80034b:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80034e:	48 63 da             	movslq %edx,%rbx
  800351:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800354:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800359:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80035c:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80035f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800361:	48 85 c0             	test   %rax,%rax
  800364:	7f 06                	jg     80036c <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  800366:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80036a:	c9                   	leave
  80036b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80036c:	49 89 c0             	mov    %rax,%r8
  80036f:	b9 05 00 00 00       	mov    $0x5,%ecx
  800374:	48 ba 68 32 80 00 00 	movabs $0x803268,%rdx
  80037b:	00 00 00 
  80037e:	be 26 00 00 00       	mov    $0x26,%esi
  800383:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  80038a:	00 00 00 
  80038d:	b8 00 00 00 00       	mov    $0x0,%eax
  800392:	49 b9 f6 1b 80 00 00 	movabs $0x801bf6,%r9
  800399:	00 00 00 
  80039c:	41 ff d1             	call   *%r9

000000000080039f <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80039f:	f3 0f 1e fa          	endbr64
  8003a3:	55                   	push   %rbp
  8003a4:	48 89 e5             	mov    %rsp,%rbp
  8003a7:	53                   	push   %rbx
  8003a8:	48 83 ec 08          	sub    $0x8,%rsp
  8003ac:	49 89 f9             	mov    %rdi,%r9
  8003af:	89 f0                	mov    %esi,%eax
  8003b1:	48 89 d3             	mov    %rdx,%rbx
  8003b4:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8003b7:	49 63 f0             	movslq %r8d,%rsi
  8003ba:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8003bd:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8003c2:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003cb:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003cd:	48 85 c0             	test   %rax,%rax
  8003d0:	7f 06                	jg     8003d8 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8003d2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003d6:	c9                   	leave
  8003d7:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003d8:	49 89 c0             	mov    %rax,%r8
  8003db:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003e0:	48 ba 68 32 80 00 00 	movabs $0x803268,%rdx
  8003e7:	00 00 00 
  8003ea:	be 26 00 00 00       	mov    $0x26,%esi
  8003ef:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  8003f6:	00 00 00 
  8003f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fe:	49 b9 f6 1b 80 00 00 	movabs $0x801bf6,%r9
  800405:	00 00 00 
  800408:	41 ff d1             	call   *%r9

000000000080040b <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80040b:	f3 0f 1e fa          	endbr64
  80040f:	55                   	push   %rbp
  800410:	48 89 e5             	mov    %rsp,%rbp
  800413:	53                   	push   %rbx
  800414:	48 83 ec 08          	sub    $0x8,%rsp
  800418:	48 89 f1             	mov    %rsi,%rcx
  80041b:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80041e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800421:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800426:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80042b:	be 00 00 00 00       	mov    $0x0,%esi
  800430:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800436:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800438:	48 85 c0             	test   %rax,%rax
  80043b:	7f 06                	jg     800443 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80043d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800441:	c9                   	leave
  800442:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800443:	49 89 c0             	mov    %rax,%r8
  800446:	b9 07 00 00 00       	mov    $0x7,%ecx
  80044b:	48 ba 68 32 80 00 00 	movabs $0x803268,%rdx
  800452:	00 00 00 
  800455:	be 26 00 00 00       	mov    $0x26,%esi
  80045a:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  800461:	00 00 00 
  800464:	b8 00 00 00 00       	mov    $0x0,%eax
  800469:	49 b9 f6 1b 80 00 00 	movabs $0x801bf6,%r9
  800470:	00 00 00 
  800473:	41 ff d1             	call   *%r9

0000000000800476 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  800476:	f3 0f 1e fa          	endbr64
  80047a:	55                   	push   %rbp
  80047b:	48 89 e5             	mov    %rsp,%rbp
  80047e:	53                   	push   %rbx
  80047f:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  800483:	48 63 ce             	movslq %esi,%rcx
  800486:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800489:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80048e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800493:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800498:	be 00 00 00 00       	mov    $0x0,%esi
  80049d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004a3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004a5:	48 85 c0             	test   %rax,%rax
  8004a8:	7f 06                	jg     8004b0 <sys_env_set_status+0x3a>
}
  8004aa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004ae:	c9                   	leave
  8004af:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004b0:	49 89 c0             	mov    %rax,%r8
  8004b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8004b8:	48 ba 68 32 80 00 00 	movabs $0x803268,%rdx
  8004bf:	00 00 00 
  8004c2:	be 26 00 00 00       	mov    $0x26,%esi
  8004c7:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  8004ce:	00 00 00 
  8004d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d6:	49 b9 f6 1b 80 00 00 	movabs $0x801bf6,%r9
  8004dd:	00 00 00 
  8004e0:	41 ff d1             	call   *%r9

00000000008004e3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8004e3:	f3 0f 1e fa          	endbr64
  8004e7:	55                   	push   %rbp
  8004e8:	48 89 e5             	mov    %rsp,%rbp
  8004eb:	53                   	push   %rbx
  8004ec:	48 83 ec 08          	sub    $0x8,%rsp
  8004f0:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8004f3:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004f6:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800500:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800505:	be 00 00 00 00       	mov    $0x0,%esi
  80050a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800510:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800512:	48 85 c0             	test   %rax,%rax
  800515:	7f 06                	jg     80051d <sys_env_set_trapframe+0x3a>
}
  800517:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80051b:	c9                   	leave
  80051c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80051d:	49 89 c0             	mov    %rax,%r8
  800520:	b9 0b 00 00 00       	mov    $0xb,%ecx
  800525:	48 ba 68 32 80 00 00 	movabs $0x803268,%rdx
  80052c:	00 00 00 
  80052f:	be 26 00 00 00       	mov    $0x26,%esi
  800534:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  80053b:	00 00 00 
  80053e:	b8 00 00 00 00       	mov    $0x0,%eax
  800543:	49 b9 f6 1b 80 00 00 	movabs $0x801bf6,%r9
  80054a:	00 00 00 
  80054d:	41 ff d1             	call   *%r9

0000000000800550 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  800550:	f3 0f 1e fa          	endbr64
  800554:	55                   	push   %rbp
  800555:	48 89 e5             	mov    %rsp,%rbp
  800558:	53                   	push   %rbx
  800559:	48 83 ec 08          	sub    $0x8,%rsp
  80055d:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  800560:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800563:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800568:	bb 00 00 00 00       	mov    $0x0,%ebx
  80056d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800572:	be 00 00 00 00       	mov    $0x0,%esi
  800577:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80057d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80057f:	48 85 c0             	test   %rax,%rax
  800582:	7f 06                	jg     80058a <sys_env_set_pgfault_upcall+0x3a>
}
  800584:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800588:	c9                   	leave
  800589:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80058a:	49 89 c0             	mov    %rax,%r8
  80058d:	b9 0c 00 00 00       	mov    $0xc,%ecx
  800592:	48 ba 68 32 80 00 00 	movabs $0x803268,%rdx
  800599:	00 00 00 
  80059c:	be 26 00 00 00       	mov    $0x26,%esi
  8005a1:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  8005a8:	00 00 00 
  8005ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b0:	49 b9 f6 1b 80 00 00 	movabs $0x801bf6,%r9
  8005b7:	00 00 00 
  8005ba:	41 ff d1             	call   *%r9

00000000008005bd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8005bd:	f3 0f 1e fa          	endbr64
  8005c1:	55                   	push   %rbp
  8005c2:	48 89 e5             	mov    %rsp,%rbp
  8005c5:	53                   	push   %rbx
  8005c6:	89 f8                	mov    %edi,%eax
  8005c8:	49 89 f1             	mov    %rsi,%r9
  8005cb:	48 89 d3             	mov    %rdx,%rbx
  8005ce:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8005d1:	49 63 f0             	movslq %r8d,%rsi
  8005d4:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8005d7:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005dc:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005e5:	cd 30                	int    $0x30
}
  8005e7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005eb:	c9                   	leave
  8005ec:	c3                   	ret

00000000008005ed <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8005ed:	f3 0f 1e fa          	endbr64
  8005f1:	55                   	push   %rbp
  8005f2:	48 89 e5             	mov    %rsp,%rbp
  8005f5:	53                   	push   %rbx
  8005f6:	48 83 ec 08          	sub    $0x8,%rsp
  8005fa:	48 89 fa             	mov    %rdi,%rdx
  8005fd:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800600:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800605:	bb 00 00 00 00       	mov    $0x0,%ebx
  80060a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80060f:	be 00 00 00 00       	mov    $0x0,%esi
  800614:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80061a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80061c:	48 85 c0             	test   %rax,%rax
  80061f:	7f 06                	jg     800627 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800621:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800625:	c9                   	leave
  800626:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800627:	49 89 c0             	mov    %rax,%r8
  80062a:	b9 0f 00 00 00       	mov    $0xf,%ecx
  80062f:	48 ba 68 32 80 00 00 	movabs $0x803268,%rdx
  800636:	00 00 00 
  800639:	be 26 00 00 00       	mov    $0x26,%esi
  80063e:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  800645:	00 00 00 
  800648:	b8 00 00 00 00       	mov    $0x0,%eax
  80064d:	49 b9 f6 1b 80 00 00 	movabs $0x801bf6,%r9
  800654:	00 00 00 
  800657:	41 ff d1             	call   *%r9

000000000080065a <sys_gettime>:

int
sys_gettime(void) {
  80065a:	f3 0f 1e fa          	endbr64
  80065e:	55                   	push   %rbp
  80065f:	48 89 e5             	mov    %rsp,%rbp
  800662:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800663:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800668:	ba 00 00 00 00       	mov    $0x0,%edx
  80066d:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800672:	bb 00 00 00 00       	mov    $0x0,%ebx
  800677:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80067c:	be 00 00 00 00       	mov    $0x0,%esi
  800681:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800687:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  800689:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80068d:	c9                   	leave
  80068e:	c3                   	ret

000000000080068f <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  80068f:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800693:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80069a:	ff ff ff 
  80069d:	48 01 f8             	add    %rdi,%rax
  8006a0:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8006a4:	c3                   	ret

00000000008006a5 <fd2data>:

char *
fd2data(struct Fd *fd) {
  8006a5:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8006a9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8006b0:	ff ff ff 
  8006b3:	48 01 f8             	add    %rdi,%rax
  8006b6:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8006ba:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8006c0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006c4:	c3                   	ret

00000000008006c5 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8006c5:	f3 0f 1e fa          	endbr64
  8006c9:	55                   	push   %rbp
  8006ca:	48 89 e5             	mov    %rsp,%rbp
  8006cd:	41 57                	push   %r15
  8006cf:	41 56                	push   %r14
  8006d1:	41 55                	push   %r13
  8006d3:	41 54                	push   %r12
  8006d5:	53                   	push   %rbx
  8006d6:	48 83 ec 08          	sub    $0x8,%rsp
  8006da:	49 89 ff             	mov    %rdi,%r15
  8006dd:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8006e2:	49 bd 24 18 80 00 00 	movabs $0x801824,%r13
  8006e9:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8006ec:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8006f2:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8006f5:	48 89 df             	mov    %rbx,%rdi
  8006f8:	41 ff d5             	call   *%r13
  8006fb:	83 e0 04             	and    $0x4,%eax
  8006fe:	74 17                	je     800717 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  800700:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  800707:	4c 39 f3             	cmp    %r14,%rbx
  80070a:	75 e6                	jne    8006f2 <fd_alloc+0x2d>
  80070c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  800712:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  800717:	4d 89 27             	mov    %r12,(%r15)
}
  80071a:	48 83 c4 08          	add    $0x8,%rsp
  80071e:	5b                   	pop    %rbx
  80071f:	41 5c                	pop    %r12
  800721:	41 5d                	pop    %r13
  800723:	41 5e                	pop    %r14
  800725:	41 5f                	pop    %r15
  800727:	5d                   	pop    %rbp
  800728:	c3                   	ret

0000000000800729 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  800729:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  80072d:	83 ff 1f             	cmp    $0x1f,%edi
  800730:	77 39                	ja     80076b <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  800732:	55                   	push   %rbp
  800733:	48 89 e5             	mov    %rsp,%rbp
  800736:	41 54                	push   %r12
  800738:	53                   	push   %rbx
  800739:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80073c:	48 63 df             	movslq %edi,%rbx
  80073f:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  800746:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  80074a:	48 89 df             	mov    %rbx,%rdi
  80074d:	48 b8 24 18 80 00 00 	movabs $0x801824,%rax
  800754:	00 00 00 
  800757:	ff d0                	call   *%rax
  800759:	a8 04                	test   $0x4,%al
  80075b:	74 14                	je     800771 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80075d:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  800761:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800766:	5b                   	pop    %rbx
  800767:	41 5c                	pop    %r12
  800769:	5d                   	pop    %rbp
  80076a:	c3                   	ret
        return -E_INVAL;
  80076b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800770:	c3                   	ret
        return -E_INVAL;
  800771:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800776:	eb ee                	jmp    800766 <fd_lookup+0x3d>

0000000000800778 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  800778:	f3 0f 1e fa          	endbr64
  80077c:	55                   	push   %rbp
  80077d:	48 89 e5             	mov    %rsp,%rbp
  800780:	41 54                	push   %r12
  800782:	53                   	push   %rbx
  800783:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  800786:	48 b8 40 33 80 00 00 	movabs $0x803340,%rax
  80078d:	00 00 00 
  800790:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  800797:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  80079a:	39 3b                	cmp    %edi,(%rbx)
  80079c:	74 47                	je     8007e5 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  80079e:	48 83 c0 08          	add    $0x8,%rax
  8007a2:	48 8b 18             	mov    (%rax),%rbx
  8007a5:	48 85 db             	test   %rbx,%rbx
  8007a8:	75 f0                	jne    80079a <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8007aa:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8007b1:	00 00 00 
  8007b4:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8007ba:	89 fa                	mov    %edi,%edx
  8007bc:	48 bf 88 32 80 00 00 	movabs $0x803288,%rdi
  8007c3:	00 00 00 
  8007c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cb:	48 b9 52 1d 80 00 00 	movabs $0x801d52,%rcx
  8007d2:	00 00 00 
  8007d5:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8007d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8007dc:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8007e0:	5b                   	pop    %rbx
  8007e1:	41 5c                	pop    %r12
  8007e3:	5d                   	pop    %rbp
  8007e4:	c3                   	ret
            return 0;
  8007e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ea:	eb f0                	jmp    8007dc <dev_lookup+0x64>

00000000008007ec <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8007ec:	f3 0f 1e fa          	endbr64
  8007f0:	55                   	push   %rbp
  8007f1:	48 89 e5             	mov    %rsp,%rbp
  8007f4:	41 55                	push   %r13
  8007f6:	41 54                	push   %r12
  8007f8:	53                   	push   %rbx
  8007f9:	48 83 ec 18          	sub    $0x18,%rsp
  8007fd:	48 89 fb             	mov    %rdi,%rbx
  800800:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800803:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80080a:	ff ff ff 
  80080d:	48 01 df             	add    %rbx,%rdi
  800810:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  800814:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800818:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  80081f:	00 00 00 
  800822:	ff d0                	call   *%rax
  800824:	41 89 c5             	mov    %eax,%r13d
  800827:	85 c0                	test   %eax,%eax
  800829:	78 06                	js     800831 <fd_close+0x45>
  80082b:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  80082f:	74 1a                	je     80084b <fd_close+0x5f>
        return (must_exist ? res : 0);
  800831:	45 84 e4             	test   %r12b,%r12b
  800834:	b8 00 00 00 00       	mov    $0x0,%eax
  800839:	44 0f 44 e8          	cmove  %eax,%r13d
}
  80083d:	44 89 e8             	mov    %r13d,%eax
  800840:	48 83 c4 18          	add    $0x18,%rsp
  800844:	5b                   	pop    %rbx
  800845:	41 5c                	pop    %r12
  800847:	41 5d                	pop    %r13
  800849:	5d                   	pop    %rbp
  80084a:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80084b:	8b 3b                	mov    (%rbx),%edi
  80084d:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800851:	48 b8 78 07 80 00 00 	movabs $0x800778,%rax
  800858:	00 00 00 
  80085b:	ff d0                	call   *%rax
  80085d:	41 89 c5             	mov    %eax,%r13d
  800860:	85 c0                	test   %eax,%eax
  800862:	78 1b                	js     80087f <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  800864:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800868:	48 8b 40 20          	mov    0x20(%rax),%rax
  80086c:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  800872:	48 85 c0             	test   %rax,%rax
  800875:	74 08                	je     80087f <fd_close+0x93>
  800877:	48 89 df             	mov    %rbx,%rdi
  80087a:	ff d0                	call   *%rax
  80087c:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80087f:	ba 00 10 00 00       	mov    $0x1000,%edx
  800884:	48 89 de             	mov    %rbx,%rsi
  800887:	bf 00 00 00 00       	mov    $0x0,%edi
  80088c:	48 b8 0b 04 80 00 00 	movabs $0x80040b,%rax
  800893:	00 00 00 
  800896:	ff d0                	call   *%rax
    return res;
  800898:	eb a3                	jmp    80083d <fd_close+0x51>

000000000080089a <close>:

int
close(int fdnum) {
  80089a:	f3 0f 1e fa          	endbr64
  80089e:	55                   	push   %rbp
  80089f:	48 89 e5             	mov    %rsp,%rbp
  8008a2:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8008a6:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8008aa:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  8008b1:	00 00 00 
  8008b4:	ff d0                	call   *%rax
    if (res < 0) return res;
  8008b6:	85 c0                	test   %eax,%eax
  8008b8:	78 15                	js     8008cf <close+0x35>

    return fd_close(fd, 1);
  8008ba:	be 01 00 00 00       	mov    $0x1,%esi
  8008bf:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8008c3:	48 b8 ec 07 80 00 00 	movabs $0x8007ec,%rax
  8008ca:	00 00 00 
  8008cd:	ff d0                	call   *%rax
}
  8008cf:	c9                   	leave
  8008d0:	c3                   	ret

00000000008008d1 <close_all>:

void
close_all(void) {
  8008d1:	f3 0f 1e fa          	endbr64
  8008d5:	55                   	push   %rbp
  8008d6:	48 89 e5             	mov    %rsp,%rbp
  8008d9:	41 54                	push   %r12
  8008db:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8008dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008e1:	49 bc 9a 08 80 00 00 	movabs $0x80089a,%r12
  8008e8:	00 00 00 
  8008eb:	89 df                	mov    %ebx,%edi
  8008ed:	41 ff d4             	call   *%r12
  8008f0:	83 c3 01             	add    $0x1,%ebx
  8008f3:	83 fb 20             	cmp    $0x20,%ebx
  8008f6:	75 f3                	jne    8008eb <close_all+0x1a>
}
  8008f8:	5b                   	pop    %rbx
  8008f9:	41 5c                	pop    %r12
  8008fb:	5d                   	pop    %rbp
  8008fc:	c3                   	ret

00000000008008fd <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8008fd:	f3 0f 1e fa          	endbr64
  800901:	55                   	push   %rbp
  800902:	48 89 e5             	mov    %rsp,%rbp
  800905:	41 57                	push   %r15
  800907:	41 56                	push   %r14
  800909:	41 55                	push   %r13
  80090b:	41 54                	push   %r12
  80090d:	53                   	push   %rbx
  80090e:	48 83 ec 18          	sub    $0x18,%rsp
  800912:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  800915:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  800919:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  800920:	00 00 00 
  800923:	ff d0                	call   *%rax
  800925:	89 c3                	mov    %eax,%ebx
  800927:	85 c0                	test   %eax,%eax
  800929:	0f 88 b8 00 00 00    	js     8009e7 <dup+0xea>
    close(newfdnum);
  80092f:	44 89 e7             	mov    %r12d,%edi
  800932:	48 b8 9a 08 80 00 00 	movabs $0x80089a,%rax
  800939:	00 00 00 
  80093c:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  80093e:	4d 63 ec             	movslq %r12d,%r13
  800941:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  800948:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  80094c:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  800950:	4c 89 ff             	mov    %r15,%rdi
  800953:	49 be a5 06 80 00 00 	movabs $0x8006a5,%r14
  80095a:	00 00 00 
  80095d:	41 ff d6             	call   *%r14
  800960:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  800963:	4c 89 ef             	mov    %r13,%rdi
  800966:	41 ff d6             	call   *%r14
  800969:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  80096c:	48 89 df             	mov    %rbx,%rdi
  80096f:	48 b8 24 18 80 00 00 	movabs $0x801824,%rax
  800976:	00 00 00 
  800979:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  80097b:	a8 04                	test   $0x4,%al
  80097d:	74 2b                	je     8009aa <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  80097f:	41 89 c1             	mov    %eax,%r9d
  800982:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800988:	4c 89 f1             	mov    %r14,%rcx
  80098b:	ba 00 00 00 00       	mov    $0x0,%edx
  800990:	48 89 de             	mov    %rbx,%rsi
  800993:	bf 00 00 00 00       	mov    $0x0,%edi
  800998:	48 b8 36 03 80 00 00 	movabs $0x800336,%rax
  80099f:	00 00 00 
  8009a2:	ff d0                	call   *%rax
  8009a4:	89 c3                	mov    %eax,%ebx
  8009a6:	85 c0                	test   %eax,%eax
  8009a8:	78 4e                	js     8009f8 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  8009aa:	4c 89 ff             	mov    %r15,%rdi
  8009ad:	48 b8 24 18 80 00 00 	movabs $0x801824,%rax
  8009b4:	00 00 00 
  8009b7:	ff d0                	call   *%rax
  8009b9:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8009bc:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8009c2:	4c 89 e9             	mov    %r13,%rcx
  8009c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ca:	4c 89 fe             	mov    %r15,%rsi
  8009cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8009d2:	48 b8 36 03 80 00 00 	movabs $0x800336,%rax
  8009d9:	00 00 00 
  8009dc:	ff d0                	call   *%rax
  8009de:	89 c3                	mov    %eax,%ebx
  8009e0:	85 c0                	test   %eax,%eax
  8009e2:	78 14                	js     8009f8 <dup+0xfb>

    return newfdnum;
  8009e4:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8009e7:	89 d8                	mov    %ebx,%eax
  8009e9:	48 83 c4 18          	add    $0x18,%rsp
  8009ed:	5b                   	pop    %rbx
  8009ee:	41 5c                	pop    %r12
  8009f0:	41 5d                	pop    %r13
  8009f2:	41 5e                	pop    %r14
  8009f4:	41 5f                	pop    %r15
  8009f6:	5d                   	pop    %rbp
  8009f7:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8009f8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009fd:	4c 89 ee             	mov    %r13,%rsi
  800a00:	bf 00 00 00 00       	mov    $0x0,%edi
  800a05:	49 bc 0b 04 80 00 00 	movabs $0x80040b,%r12
  800a0c:	00 00 00 
  800a0f:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  800a12:	ba 00 10 00 00       	mov    $0x1000,%edx
  800a17:	4c 89 f6             	mov    %r14,%rsi
  800a1a:	bf 00 00 00 00       	mov    $0x0,%edi
  800a1f:	41 ff d4             	call   *%r12
    return res;
  800a22:	eb c3                	jmp    8009e7 <dup+0xea>

0000000000800a24 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800a24:	f3 0f 1e fa          	endbr64
  800a28:	55                   	push   %rbp
  800a29:	48 89 e5             	mov    %rsp,%rbp
  800a2c:	41 56                	push   %r14
  800a2e:	41 55                	push   %r13
  800a30:	41 54                	push   %r12
  800a32:	53                   	push   %rbx
  800a33:	48 83 ec 10          	sub    $0x10,%rsp
  800a37:	89 fb                	mov    %edi,%ebx
  800a39:	49 89 f4             	mov    %rsi,%r12
  800a3c:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a3f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800a43:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  800a4a:	00 00 00 
  800a4d:	ff d0                	call   *%rax
  800a4f:	85 c0                	test   %eax,%eax
  800a51:	78 4c                	js     800a9f <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a53:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800a57:	41 8b 3e             	mov    (%r14),%edi
  800a5a:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800a5e:	48 b8 78 07 80 00 00 	movabs $0x800778,%rax
  800a65:	00 00 00 
  800a68:	ff d0                	call   *%rax
  800a6a:	85 c0                	test   %eax,%eax
  800a6c:	78 35                	js     800aa3 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a6e:	41 8b 46 08          	mov    0x8(%r14),%eax
  800a72:	83 e0 03             	and    $0x3,%eax
  800a75:	83 f8 01             	cmp    $0x1,%eax
  800a78:	74 2d                	je     800aa7 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800a7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a7e:	48 8b 40 10          	mov    0x10(%rax),%rax
  800a82:	48 85 c0             	test   %rax,%rax
  800a85:	74 56                	je     800add <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  800a87:	4c 89 ea             	mov    %r13,%rdx
  800a8a:	4c 89 e6             	mov    %r12,%rsi
  800a8d:	4c 89 f7             	mov    %r14,%rdi
  800a90:	ff d0                	call   *%rax
}
  800a92:	48 83 c4 10          	add    $0x10,%rsp
  800a96:	5b                   	pop    %rbx
  800a97:	41 5c                	pop    %r12
  800a99:	41 5d                	pop    %r13
  800a9b:	41 5e                	pop    %r14
  800a9d:	5d                   	pop    %rbp
  800a9e:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a9f:	48 98                	cltq
  800aa1:	eb ef                	jmp    800a92 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800aa3:	48 98                	cltq
  800aa5:	eb eb                	jmp    800a92 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800aa7:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800aae:	00 00 00 
  800ab1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800ab7:	89 da                	mov    %ebx,%edx
  800ab9:	48 bf 26 30 80 00 00 	movabs $0x803026,%rdi
  800ac0:	00 00 00 
  800ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac8:	48 b9 52 1d 80 00 00 	movabs $0x801d52,%rcx
  800acf:	00 00 00 
  800ad2:	ff d1                	call   *%rcx
        return -E_INVAL;
  800ad4:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800adb:	eb b5                	jmp    800a92 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800add:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800ae4:	eb ac                	jmp    800a92 <read+0x6e>

0000000000800ae6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800ae6:	f3 0f 1e fa          	endbr64
  800aea:	55                   	push   %rbp
  800aeb:	48 89 e5             	mov    %rsp,%rbp
  800aee:	41 57                	push   %r15
  800af0:	41 56                	push   %r14
  800af2:	41 55                	push   %r13
  800af4:	41 54                	push   %r12
  800af6:	53                   	push   %rbx
  800af7:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800afb:	48 85 d2             	test   %rdx,%rdx
  800afe:	74 54                	je     800b54 <readn+0x6e>
  800b00:	41 89 fd             	mov    %edi,%r13d
  800b03:	49 89 f6             	mov    %rsi,%r14
  800b06:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800b09:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800b0e:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800b13:	49 bf 24 0a 80 00 00 	movabs $0x800a24,%r15
  800b1a:	00 00 00 
  800b1d:	4c 89 e2             	mov    %r12,%rdx
  800b20:	48 29 f2             	sub    %rsi,%rdx
  800b23:	4c 01 f6             	add    %r14,%rsi
  800b26:	44 89 ef             	mov    %r13d,%edi
  800b29:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800b2c:	85 c0                	test   %eax,%eax
  800b2e:	78 20                	js     800b50 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  800b30:	01 c3                	add    %eax,%ebx
  800b32:	85 c0                	test   %eax,%eax
  800b34:	74 08                	je     800b3e <readn+0x58>
  800b36:	48 63 f3             	movslq %ebx,%rsi
  800b39:	4c 39 e6             	cmp    %r12,%rsi
  800b3c:	72 df                	jb     800b1d <readn+0x37>
    }
    return res;
  800b3e:	48 63 c3             	movslq %ebx,%rax
}
  800b41:	48 83 c4 08          	add    $0x8,%rsp
  800b45:	5b                   	pop    %rbx
  800b46:	41 5c                	pop    %r12
  800b48:	41 5d                	pop    %r13
  800b4a:	41 5e                	pop    %r14
  800b4c:	41 5f                	pop    %r15
  800b4e:	5d                   	pop    %rbp
  800b4f:	c3                   	ret
        if (inc < 0) return inc;
  800b50:	48 98                	cltq
  800b52:	eb ed                	jmp    800b41 <readn+0x5b>
    int inc = 1, res = 0;
  800b54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b59:	eb e3                	jmp    800b3e <readn+0x58>

0000000000800b5b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800b5b:	f3 0f 1e fa          	endbr64
  800b5f:	55                   	push   %rbp
  800b60:	48 89 e5             	mov    %rsp,%rbp
  800b63:	41 56                	push   %r14
  800b65:	41 55                	push   %r13
  800b67:	41 54                	push   %r12
  800b69:	53                   	push   %rbx
  800b6a:	48 83 ec 10          	sub    $0x10,%rsp
  800b6e:	89 fb                	mov    %edi,%ebx
  800b70:	49 89 f4             	mov    %rsi,%r12
  800b73:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b76:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800b7a:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  800b81:	00 00 00 
  800b84:	ff d0                	call   *%rax
  800b86:	85 c0                	test   %eax,%eax
  800b88:	78 47                	js     800bd1 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b8a:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800b8e:	41 8b 3e             	mov    (%r14),%edi
  800b91:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800b95:	48 b8 78 07 80 00 00 	movabs $0x800778,%rax
  800b9c:	00 00 00 
  800b9f:	ff d0                	call   *%rax
  800ba1:	85 c0                	test   %eax,%eax
  800ba3:	78 30                	js     800bd5 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ba5:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  800baa:	74 2d                	je     800bd9 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800bac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800bb0:	48 8b 40 18          	mov    0x18(%rax),%rax
  800bb4:	48 85 c0             	test   %rax,%rax
  800bb7:	74 56                	je     800c0f <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  800bb9:	4c 89 ea             	mov    %r13,%rdx
  800bbc:	4c 89 e6             	mov    %r12,%rsi
  800bbf:	4c 89 f7             	mov    %r14,%rdi
  800bc2:	ff d0                	call   *%rax
}
  800bc4:	48 83 c4 10          	add    $0x10,%rsp
  800bc8:	5b                   	pop    %rbx
  800bc9:	41 5c                	pop    %r12
  800bcb:	41 5d                	pop    %r13
  800bcd:	41 5e                	pop    %r14
  800bcf:	5d                   	pop    %rbp
  800bd0:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800bd1:	48 98                	cltq
  800bd3:	eb ef                	jmp    800bc4 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bd5:	48 98                	cltq
  800bd7:	eb eb                	jmp    800bc4 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800bd9:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800be0:	00 00 00 
  800be3:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800be9:	89 da                	mov    %ebx,%edx
  800beb:	48 bf 42 30 80 00 00 	movabs $0x803042,%rdi
  800bf2:	00 00 00 
  800bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfa:	48 b9 52 1d 80 00 00 	movabs $0x801d52,%rcx
  800c01:	00 00 00 
  800c04:	ff d1                	call   *%rcx
        return -E_INVAL;
  800c06:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800c0d:	eb b5                	jmp    800bc4 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800c0f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800c16:	eb ac                	jmp    800bc4 <write+0x69>

0000000000800c18 <seek>:

int
seek(int fdnum, off_t offset) {
  800c18:	f3 0f 1e fa          	endbr64
  800c1c:	55                   	push   %rbp
  800c1d:	48 89 e5             	mov    %rsp,%rbp
  800c20:	53                   	push   %rbx
  800c21:	48 83 ec 18          	sub    $0x18,%rsp
  800c25:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c27:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c2b:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  800c32:	00 00 00 
  800c35:	ff d0                	call   *%rax
  800c37:	85 c0                	test   %eax,%eax
  800c39:	78 0c                	js     800c47 <seek+0x2f>

    fd->fd_offset = offset;
  800c3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c3f:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800c42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c47:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c4b:	c9                   	leave
  800c4c:	c3                   	ret

0000000000800c4d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800c4d:	f3 0f 1e fa          	endbr64
  800c51:	55                   	push   %rbp
  800c52:	48 89 e5             	mov    %rsp,%rbp
  800c55:	41 55                	push   %r13
  800c57:	41 54                	push   %r12
  800c59:	53                   	push   %rbx
  800c5a:	48 83 ec 18          	sub    $0x18,%rsp
  800c5e:	89 fb                	mov    %edi,%ebx
  800c60:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c63:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800c67:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  800c6e:	00 00 00 
  800c71:	ff d0                	call   *%rax
  800c73:	85 c0                	test   %eax,%eax
  800c75:	78 38                	js     800caf <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c77:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  800c7b:	41 8b 7d 00          	mov    0x0(%r13),%edi
  800c7f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800c83:	48 b8 78 07 80 00 00 	movabs $0x800778,%rax
  800c8a:	00 00 00 
  800c8d:	ff d0                	call   *%rax
  800c8f:	85 c0                	test   %eax,%eax
  800c91:	78 1c                	js     800caf <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c93:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  800c98:	74 20                	je     800cba <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c9a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c9e:	48 8b 40 30          	mov    0x30(%rax),%rax
  800ca2:	48 85 c0             	test   %rax,%rax
  800ca5:	74 47                	je     800cee <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  800ca7:	44 89 e6             	mov    %r12d,%esi
  800caa:	4c 89 ef             	mov    %r13,%rdi
  800cad:	ff d0                	call   *%rax
}
  800caf:	48 83 c4 18          	add    $0x18,%rsp
  800cb3:	5b                   	pop    %rbx
  800cb4:	41 5c                	pop    %r12
  800cb6:	41 5d                	pop    %r13
  800cb8:	5d                   	pop    %rbp
  800cb9:	c3                   	ret
                thisenv->env_id, fdnum);
  800cba:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800cc1:	00 00 00 
  800cc4:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800cca:	89 da                	mov    %ebx,%edx
  800ccc:	48 bf a8 32 80 00 00 	movabs $0x8032a8,%rdi
  800cd3:	00 00 00 
  800cd6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdb:	48 b9 52 1d 80 00 00 	movabs $0x801d52,%rcx
  800ce2:	00 00 00 
  800ce5:	ff d1                	call   *%rcx
        return -E_INVAL;
  800ce7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cec:	eb c1                	jmp    800caf <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800cee:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800cf3:	eb ba                	jmp    800caf <ftruncate+0x62>

0000000000800cf5 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800cf5:	f3 0f 1e fa          	endbr64
  800cf9:	55                   	push   %rbp
  800cfa:	48 89 e5             	mov    %rsp,%rbp
  800cfd:	41 54                	push   %r12
  800cff:	53                   	push   %rbx
  800d00:	48 83 ec 10          	sub    $0x10,%rsp
  800d04:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800d07:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800d0b:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  800d12:	00 00 00 
  800d15:	ff d0                	call   *%rax
  800d17:	85 c0                	test   %eax,%eax
  800d19:	78 4e                	js     800d69 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800d1b:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  800d1f:	41 8b 3c 24          	mov    (%r12),%edi
  800d23:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800d27:	48 b8 78 07 80 00 00 	movabs $0x800778,%rax
  800d2e:	00 00 00 
  800d31:	ff d0                	call   *%rax
  800d33:	85 c0                	test   %eax,%eax
  800d35:	78 32                	js     800d69 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800d3b:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800d40:	74 30                	je     800d72 <fstat+0x7d>

    stat->st_name[0] = 0;
  800d42:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800d45:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800d4c:	00 00 00 
    stat->st_isdir = 0;
  800d4f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800d56:	00 00 00 
    stat->st_dev = dev;
  800d59:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800d60:	48 89 de             	mov    %rbx,%rsi
  800d63:	4c 89 e7             	mov    %r12,%rdi
  800d66:	ff 50 28             	call   *0x28(%rax)
}
  800d69:	48 83 c4 10          	add    $0x10,%rsp
  800d6d:	5b                   	pop    %rbx
  800d6e:	41 5c                	pop    %r12
  800d70:	5d                   	pop    %rbp
  800d71:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d72:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800d77:	eb f0                	jmp    800d69 <fstat+0x74>

0000000000800d79 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800d79:	f3 0f 1e fa          	endbr64
  800d7d:	55                   	push   %rbp
  800d7e:	48 89 e5             	mov    %rsp,%rbp
  800d81:	41 54                	push   %r12
  800d83:	53                   	push   %rbx
  800d84:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800d87:	be 00 00 00 00       	mov    $0x0,%esi
  800d8c:	48 b8 5a 10 80 00 00 	movabs $0x80105a,%rax
  800d93:	00 00 00 
  800d96:	ff d0                	call   *%rax
  800d98:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800d9a:	85 c0                	test   %eax,%eax
  800d9c:	78 25                	js     800dc3 <stat+0x4a>

    int res = fstat(fd, stat);
  800d9e:	4c 89 e6             	mov    %r12,%rsi
  800da1:	89 c7                	mov    %eax,%edi
  800da3:	48 b8 f5 0c 80 00 00 	movabs $0x800cf5,%rax
  800daa:	00 00 00 
  800dad:	ff d0                	call   *%rax
  800daf:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800db2:	89 df                	mov    %ebx,%edi
  800db4:	48 b8 9a 08 80 00 00 	movabs $0x80089a,%rax
  800dbb:	00 00 00 
  800dbe:	ff d0                	call   *%rax

    return res;
  800dc0:	44 89 e3             	mov    %r12d,%ebx
}
  800dc3:	89 d8                	mov    %ebx,%eax
  800dc5:	5b                   	pop    %rbx
  800dc6:	41 5c                	pop    %r12
  800dc8:	5d                   	pop    %rbp
  800dc9:	c3                   	ret

0000000000800dca <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800dca:	f3 0f 1e fa          	endbr64
  800dce:	55                   	push   %rbp
  800dcf:	48 89 e5             	mov    %rsp,%rbp
  800dd2:	41 54                	push   %r12
  800dd4:	53                   	push   %rbx
  800dd5:	48 83 ec 10          	sub    $0x10,%rsp
  800dd9:	41 89 fc             	mov    %edi,%r12d
  800ddc:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800ddf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800de6:	00 00 00 
  800de9:	83 38 00             	cmpl   $0x0,(%rax)
  800dec:	74 6e                	je     800e5c <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  800dee:	bf 03 00 00 00       	mov    $0x3,%edi
  800df3:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  800dfa:	00 00 00 
  800dfd:	ff d0                	call   *%rax
  800dff:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e06:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800e08:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800e0e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800e13:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800e1a:	00 00 00 
  800e1d:	44 89 e6             	mov    %r12d,%esi
  800e20:	89 c7                	mov    %eax,%edi
  800e22:	48 b8 94 2b 80 00 00 	movabs $0x802b94,%rax
  800e29:	00 00 00 
  800e2c:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800e2e:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800e35:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800e36:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e3b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e3f:	48 89 de             	mov    %rbx,%rsi
  800e42:	bf 00 00 00 00       	mov    $0x0,%edi
  800e47:	48 b8 fb 2a 80 00 00 	movabs $0x802afb,%rax
  800e4e:	00 00 00 
  800e51:	ff d0                	call   *%rax
}
  800e53:	48 83 c4 10          	add    $0x10,%rsp
  800e57:	5b                   	pop    %rbx
  800e58:	41 5c                	pop    %r12
  800e5a:	5d                   	pop    %rbp
  800e5b:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800e5c:	bf 03 00 00 00       	mov    $0x3,%edi
  800e61:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  800e68:	00 00 00 
  800e6b:	ff d0                	call   *%rax
  800e6d:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e74:	00 00 
  800e76:	e9 73 ff ff ff       	jmp    800dee <fsipc+0x24>

0000000000800e7b <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800e7b:	f3 0f 1e fa          	endbr64
  800e7f:	55                   	push   %rbp
  800e80:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800e83:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e8a:	00 00 00 
  800e8d:	8b 57 0c             	mov    0xc(%rdi),%edx
  800e90:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800e92:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800e95:	be 00 00 00 00       	mov    $0x0,%esi
  800e9a:	bf 02 00 00 00       	mov    $0x2,%edi
  800e9f:	48 b8 ca 0d 80 00 00 	movabs $0x800dca,%rax
  800ea6:	00 00 00 
  800ea9:	ff d0                	call   *%rax
}
  800eab:	5d                   	pop    %rbp
  800eac:	c3                   	ret

0000000000800ead <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800ead:	f3 0f 1e fa          	endbr64
  800eb1:	55                   	push   %rbp
  800eb2:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800eb5:	8b 47 0c             	mov    0xc(%rdi),%eax
  800eb8:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ebf:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800ec1:	be 00 00 00 00       	mov    $0x0,%esi
  800ec6:	bf 06 00 00 00       	mov    $0x6,%edi
  800ecb:	48 b8 ca 0d 80 00 00 	movabs $0x800dca,%rax
  800ed2:	00 00 00 
  800ed5:	ff d0                	call   *%rax
}
  800ed7:	5d                   	pop    %rbp
  800ed8:	c3                   	ret

0000000000800ed9 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800ed9:	f3 0f 1e fa          	endbr64
  800edd:	55                   	push   %rbp
  800ede:	48 89 e5             	mov    %rsp,%rbp
  800ee1:	41 54                	push   %r12
  800ee3:	53                   	push   %rbx
  800ee4:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ee7:	8b 47 0c             	mov    0xc(%rdi),%eax
  800eea:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ef1:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800ef3:	be 00 00 00 00       	mov    $0x0,%esi
  800ef8:	bf 05 00 00 00       	mov    $0x5,%edi
  800efd:	48 b8 ca 0d 80 00 00 	movabs $0x800dca,%rax
  800f04:	00 00 00 
  800f07:	ff d0                	call   *%rax
    if (res < 0) return res;
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	78 3d                	js     800f4a <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800f0d:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  800f14:	00 00 00 
  800f17:	4c 89 e6             	mov    %r12,%rsi
  800f1a:	48 89 df             	mov    %rbx,%rdi
  800f1d:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  800f24:	00 00 00 
  800f27:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800f29:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  800f30:	00 
  800f31:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800f37:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  800f3e:	00 
  800f3f:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800f45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f4a:	5b                   	pop    %rbx
  800f4b:	41 5c                	pop    %r12
  800f4d:	5d                   	pop    %rbp
  800f4e:	c3                   	ret

0000000000800f4f <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f4f:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  800f53:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  800f5a:	77 41                	ja     800f9d <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f5c:	55                   	push   %rbp
  800f5d:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  800f60:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f67:	00 00 00 
  800f6a:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f6d:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  800f6f:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  800f73:	48 8d 78 10          	lea    0x10(%rax),%rdi
  800f77:	48 b8 b6 28 80 00 00 	movabs $0x8028b6,%rax
  800f7e:	00 00 00 
  800f81:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  800f83:	be 00 00 00 00       	mov    $0x0,%esi
  800f88:	bf 04 00 00 00       	mov    $0x4,%edi
  800f8d:	48 b8 ca 0d 80 00 00 	movabs $0x800dca,%rax
  800f94:	00 00 00 
  800f97:	ff d0                	call   *%rax
  800f99:	48 98                	cltq
}
  800f9b:	5d                   	pop    %rbp
  800f9c:	c3                   	ret
        return -E_INVAL;
  800f9d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  800fa4:	c3                   	ret

0000000000800fa5 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800fa5:	f3 0f 1e fa          	endbr64
  800fa9:	55                   	push   %rbp
  800faa:	48 89 e5             	mov    %rsp,%rbp
  800fad:	41 55                	push   %r13
  800faf:	41 54                	push   %r12
  800fb1:	53                   	push   %rbx
  800fb2:	48 83 ec 08          	sub    $0x8,%rsp
  800fb6:	49 89 f4             	mov    %rsi,%r12
  800fb9:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800fbc:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800fc3:	00 00 00 
  800fc6:	8b 57 0c             	mov    0xc(%rdi),%edx
  800fc9:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  800fcb:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  800fcf:	be 00 00 00 00       	mov    $0x0,%esi
  800fd4:	bf 03 00 00 00       	mov    $0x3,%edi
  800fd9:	48 b8 ca 0d 80 00 00 	movabs $0x800dca,%rax
  800fe0:	00 00 00 
  800fe3:	ff d0                	call   *%rax
  800fe5:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  800fe8:	4d 85 ed             	test   %r13,%r13
  800feb:	78 2a                	js     801017 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  800fed:	4c 89 ea             	mov    %r13,%rdx
  800ff0:	4c 39 eb             	cmp    %r13,%rbx
  800ff3:	72 30                	jb     801025 <devfile_read+0x80>
  800ff5:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  800ffc:	7f 27                	jg     801025 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  800ffe:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801005:	00 00 00 
  801008:	4c 89 e7             	mov    %r12,%rdi
  80100b:	48 b8 b6 28 80 00 00 	movabs $0x8028b6,%rax
  801012:	00 00 00 
  801015:	ff d0                	call   *%rax
}
  801017:	4c 89 e8             	mov    %r13,%rax
  80101a:	48 83 c4 08          	add    $0x8,%rsp
  80101e:	5b                   	pop    %rbx
  80101f:	41 5c                	pop    %r12
  801021:	41 5d                	pop    %r13
  801023:	5d                   	pop    %rbp
  801024:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801025:	48 b9 5f 30 80 00 00 	movabs $0x80305f,%rcx
  80102c:	00 00 00 
  80102f:	48 ba 7c 30 80 00 00 	movabs $0x80307c,%rdx
  801036:	00 00 00 
  801039:	be 7b 00 00 00       	mov    $0x7b,%esi
  80103e:	48 bf 91 30 80 00 00 	movabs $0x803091,%rdi
  801045:	00 00 00 
  801048:	b8 00 00 00 00       	mov    $0x0,%eax
  80104d:	49 b8 f6 1b 80 00 00 	movabs $0x801bf6,%r8
  801054:	00 00 00 
  801057:	41 ff d0             	call   *%r8

000000000080105a <open>:
open(const char *path, int mode) {
  80105a:	f3 0f 1e fa          	endbr64
  80105e:	55                   	push   %rbp
  80105f:	48 89 e5             	mov    %rsp,%rbp
  801062:	41 55                	push   %r13
  801064:	41 54                	push   %r12
  801066:	53                   	push   %rbx
  801067:	48 83 ec 18          	sub    $0x18,%rsp
  80106b:	49 89 fc             	mov    %rdi,%r12
  80106e:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801071:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  801078:	00 00 00 
  80107b:	ff d0                	call   *%rax
  80107d:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801083:	0f 87 8a 00 00 00    	ja     801113 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801089:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80108d:	48 b8 c5 06 80 00 00 	movabs $0x8006c5,%rax
  801094:	00 00 00 
  801097:	ff d0                	call   *%rax
  801099:	89 c3                	mov    %eax,%ebx
  80109b:	85 c0                	test   %eax,%eax
  80109d:	78 50                	js     8010ef <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80109f:	4c 89 e6             	mov    %r12,%rsi
  8010a2:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  8010a9:	00 00 00 
  8010ac:	48 89 df             	mov    %rbx,%rdi
  8010af:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  8010b6:	00 00 00 
  8010b9:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8010bb:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8010c2:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8010c6:	bf 01 00 00 00       	mov    $0x1,%edi
  8010cb:	48 b8 ca 0d 80 00 00 	movabs $0x800dca,%rax
  8010d2:	00 00 00 
  8010d5:	ff d0                	call   *%rax
  8010d7:	89 c3                	mov    %eax,%ebx
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	78 1f                	js     8010fc <open+0xa2>
    return fd2num(fd);
  8010dd:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010e1:	48 b8 8f 06 80 00 00 	movabs $0x80068f,%rax
  8010e8:	00 00 00 
  8010eb:	ff d0                	call   *%rax
  8010ed:	89 c3                	mov    %eax,%ebx
}
  8010ef:	89 d8                	mov    %ebx,%eax
  8010f1:	48 83 c4 18          	add    $0x18,%rsp
  8010f5:	5b                   	pop    %rbx
  8010f6:	41 5c                	pop    %r12
  8010f8:	41 5d                	pop    %r13
  8010fa:	5d                   	pop    %rbp
  8010fb:	c3                   	ret
        fd_close(fd, 0);
  8010fc:	be 00 00 00 00       	mov    $0x0,%esi
  801101:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801105:	48 b8 ec 07 80 00 00 	movabs $0x8007ec,%rax
  80110c:	00 00 00 
  80110f:	ff d0                	call   *%rax
        return res;
  801111:	eb dc                	jmp    8010ef <open+0x95>
        return -E_BAD_PATH;
  801113:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801118:	eb d5                	jmp    8010ef <open+0x95>

000000000080111a <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80111a:	f3 0f 1e fa          	endbr64
  80111e:	55                   	push   %rbp
  80111f:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801122:	be 00 00 00 00       	mov    $0x0,%esi
  801127:	bf 08 00 00 00       	mov    $0x8,%edi
  80112c:	48 b8 ca 0d 80 00 00 	movabs $0x800dca,%rax
  801133:	00 00 00 
  801136:	ff d0                	call   *%rax
}
  801138:	5d                   	pop    %rbp
  801139:	c3                   	ret

000000000080113a <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80113a:	f3 0f 1e fa          	endbr64
  80113e:	55                   	push   %rbp
  80113f:	48 89 e5             	mov    %rsp,%rbp
  801142:	41 54                	push   %r12
  801144:	53                   	push   %rbx
  801145:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801148:	48 b8 a5 06 80 00 00 	movabs $0x8006a5,%rax
  80114f:	00 00 00 
  801152:	ff d0                	call   *%rax
  801154:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801157:	48 be 9c 30 80 00 00 	movabs $0x80309c,%rsi
  80115e:	00 00 00 
  801161:	48 89 df             	mov    %rbx,%rdi
  801164:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  80116b:	00 00 00 
  80116e:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801170:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801175:	41 2b 04 24          	sub    (%r12),%eax
  801179:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80117f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801186:	00 00 00 
    stat->st_dev = &devpipe;
  801189:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801190:	00 00 00 
  801193:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80119a:	b8 00 00 00 00       	mov    $0x0,%eax
  80119f:	5b                   	pop    %rbx
  8011a0:	41 5c                	pop    %r12
  8011a2:	5d                   	pop    %rbp
  8011a3:	c3                   	ret

00000000008011a4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8011a4:	f3 0f 1e fa          	endbr64
  8011a8:	55                   	push   %rbp
  8011a9:	48 89 e5             	mov    %rsp,%rbp
  8011ac:	41 54                	push   %r12
  8011ae:	53                   	push   %rbx
  8011af:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8011b2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011b7:	48 89 fe             	mov    %rdi,%rsi
  8011ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8011bf:	49 bc 0b 04 80 00 00 	movabs $0x80040b,%r12
  8011c6:	00 00 00 
  8011c9:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8011cc:	48 89 df             	mov    %rbx,%rdi
  8011cf:	48 b8 a5 06 80 00 00 	movabs $0x8006a5,%rax
  8011d6:	00 00 00 
  8011d9:	ff d0                	call   *%rax
  8011db:	48 89 c6             	mov    %rax,%rsi
  8011de:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8011e8:	41 ff d4             	call   *%r12
}
  8011eb:	5b                   	pop    %rbx
  8011ec:	41 5c                	pop    %r12
  8011ee:	5d                   	pop    %rbp
  8011ef:	c3                   	ret

00000000008011f0 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8011f0:	f3 0f 1e fa          	endbr64
  8011f4:	55                   	push   %rbp
  8011f5:	48 89 e5             	mov    %rsp,%rbp
  8011f8:	41 57                	push   %r15
  8011fa:	41 56                	push   %r14
  8011fc:	41 55                	push   %r13
  8011fe:	41 54                	push   %r12
  801200:	53                   	push   %rbx
  801201:	48 83 ec 18          	sub    $0x18,%rsp
  801205:	49 89 fc             	mov    %rdi,%r12
  801208:	49 89 f5             	mov    %rsi,%r13
  80120b:	49 89 d7             	mov    %rdx,%r15
  80120e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801212:	48 b8 a5 06 80 00 00 	movabs $0x8006a5,%rax
  801219:	00 00 00 
  80121c:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80121e:	4d 85 ff             	test   %r15,%r15
  801221:	0f 84 af 00 00 00    	je     8012d6 <devpipe_write+0xe6>
  801227:	48 89 c3             	mov    %rax,%rbx
  80122a:	4c 89 f8             	mov    %r15,%rax
  80122d:	4d 89 ef             	mov    %r13,%r15
  801230:	4c 01 e8             	add    %r13,%rax
  801233:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801237:	49 bd 9b 02 80 00 00 	movabs $0x80029b,%r13
  80123e:	00 00 00 
            sys_yield();
  801241:	49 be 30 02 80 00 00 	movabs $0x800230,%r14
  801248:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80124b:	8b 73 04             	mov    0x4(%rbx),%esi
  80124e:	48 63 ce             	movslq %esi,%rcx
  801251:	48 63 03             	movslq (%rbx),%rax
  801254:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80125a:	48 39 c1             	cmp    %rax,%rcx
  80125d:	72 2e                	jb     80128d <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80125f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801264:	48 89 da             	mov    %rbx,%rdx
  801267:	be 00 10 00 00       	mov    $0x1000,%esi
  80126c:	4c 89 e7             	mov    %r12,%rdi
  80126f:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801272:	85 c0                	test   %eax,%eax
  801274:	74 66                	je     8012dc <devpipe_write+0xec>
            sys_yield();
  801276:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801279:	8b 73 04             	mov    0x4(%rbx),%esi
  80127c:	48 63 ce             	movslq %esi,%rcx
  80127f:	48 63 03             	movslq (%rbx),%rax
  801282:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801288:	48 39 c1             	cmp    %rax,%rcx
  80128b:	73 d2                	jae    80125f <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80128d:	41 0f b6 3f          	movzbl (%r15),%edi
  801291:	48 89 ca             	mov    %rcx,%rdx
  801294:	48 c1 ea 03          	shr    $0x3,%rdx
  801298:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80129f:	08 10 20 
  8012a2:	48 f7 e2             	mul    %rdx
  8012a5:	48 c1 ea 06          	shr    $0x6,%rdx
  8012a9:	48 89 d0             	mov    %rdx,%rax
  8012ac:	48 c1 e0 09          	shl    $0x9,%rax
  8012b0:	48 29 d0             	sub    %rdx,%rax
  8012b3:	48 c1 e0 03          	shl    $0x3,%rax
  8012b7:	48 29 c1             	sub    %rax,%rcx
  8012ba:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8012bf:	83 c6 01             	add    $0x1,%esi
  8012c2:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012c5:	49 83 c7 01          	add    $0x1,%r15
  8012c9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012cd:	49 39 c7             	cmp    %rax,%r15
  8012d0:	0f 85 75 ff ff ff    	jne    80124b <devpipe_write+0x5b>
    return n;
  8012d6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8012da:	eb 05                	jmp    8012e1 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8012dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e1:	48 83 c4 18          	add    $0x18,%rsp
  8012e5:	5b                   	pop    %rbx
  8012e6:	41 5c                	pop    %r12
  8012e8:	41 5d                	pop    %r13
  8012ea:	41 5e                	pop    %r14
  8012ec:	41 5f                	pop    %r15
  8012ee:	5d                   	pop    %rbp
  8012ef:	c3                   	ret

00000000008012f0 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8012f0:	f3 0f 1e fa          	endbr64
  8012f4:	55                   	push   %rbp
  8012f5:	48 89 e5             	mov    %rsp,%rbp
  8012f8:	41 57                	push   %r15
  8012fa:	41 56                	push   %r14
  8012fc:	41 55                	push   %r13
  8012fe:	41 54                	push   %r12
  801300:	53                   	push   %rbx
  801301:	48 83 ec 18          	sub    $0x18,%rsp
  801305:	49 89 fc             	mov    %rdi,%r12
  801308:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80130c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801310:	48 b8 a5 06 80 00 00 	movabs $0x8006a5,%rax
  801317:	00 00 00 
  80131a:	ff d0                	call   *%rax
  80131c:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80131f:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801325:	49 bd 9b 02 80 00 00 	movabs $0x80029b,%r13
  80132c:	00 00 00 
            sys_yield();
  80132f:	49 be 30 02 80 00 00 	movabs $0x800230,%r14
  801336:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801339:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80133e:	74 7d                	je     8013bd <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801340:	8b 03                	mov    (%rbx),%eax
  801342:	3b 43 04             	cmp    0x4(%rbx),%eax
  801345:	75 26                	jne    80136d <devpipe_read+0x7d>
            if (i > 0) return i;
  801347:	4d 85 ff             	test   %r15,%r15
  80134a:	75 77                	jne    8013c3 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80134c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801351:	48 89 da             	mov    %rbx,%rdx
  801354:	be 00 10 00 00       	mov    $0x1000,%esi
  801359:	4c 89 e7             	mov    %r12,%rdi
  80135c:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80135f:	85 c0                	test   %eax,%eax
  801361:	74 72                	je     8013d5 <devpipe_read+0xe5>
            sys_yield();
  801363:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801366:	8b 03                	mov    (%rbx),%eax
  801368:	3b 43 04             	cmp    0x4(%rbx),%eax
  80136b:	74 df                	je     80134c <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80136d:	48 63 c8             	movslq %eax,%rcx
  801370:	48 89 ca             	mov    %rcx,%rdx
  801373:	48 c1 ea 03          	shr    $0x3,%rdx
  801377:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  80137e:	08 10 20 
  801381:	48 89 d0             	mov    %rdx,%rax
  801384:	48 f7 e6             	mul    %rsi
  801387:	48 c1 ea 06          	shr    $0x6,%rdx
  80138b:	48 89 d0             	mov    %rdx,%rax
  80138e:	48 c1 e0 09          	shl    $0x9,%rax
  801392:	48 29 d0             	sub    %rdx,%rax
  801395:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80139c:	00 
  80139d:	48 89 c8             	mov    %rcx,%rax
  8013a0:	48 29 d0             	sub    %rdx,%rax
  8013a3:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8013a8:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8013ac:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8013b0:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8013b3:	49 83 c7 01          	add    $0x1,%r15
  8013b7:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8013bb:	75 83                	jne    801340 <devpipe_read+0x50>
    return n;
  8013bd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013c1:	eb 03                	jmp    8013c6 <devpipe_read+0xd6>
            if (i > 0) return i;
  8013c3:	4c 89 f8             	mov    %r15,%rax
}
  8013c6:	48 83 c4 18          	add    $0x18,%rsp
  8013ca:	5b                   	pop    %rbx
  8013cb:	41 5c                	pop    %r12
  8013cd:	41 5d                	pop    %r13
  8013cf:	41 5e                	pop    %r14
  8013d1:	41 5f                	pop    %r15
  8013d3:	5d                   	pop    %rbp
  8013d4:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8013d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013da:	eb ea                	jmp    8013c6 <devpipe_read+0xd6>

00000000008013dc <pipe>:
pipe(int pfd[2]) {
  8013dc:	f3 0f 1e fa          	endbr64
  8013e0:	55                   	push   %rbp
  8013e1:	48 89 e5             	mov    %rsp,%rbp
  8013e4:	41 55                	push   %r13
  8013e6:	41 54                	push   %r12
  8013e8:	53                   	push   %rbx
  8013e9:	48 83 ec 18          	sub    $0x18,%rsp
  8013ed:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8013f0:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8013f4:	48 b8 c5 06 80 00 00 	movabs $0x8006c5,%rax
  8013fb:	00 00 00 
  8013fe:	ff d0                	call   *%rax
  801400:	89 c3                	mov    %eax,%ebx
  801402:	85 c0                	test   %eax,%eax
  801404:	0f 88 a0 01 00 00    	js     8015aa <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80140a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80140f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801414:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801418:	bf 00 00 00 00       	mov    $0x0,%edi
  80141d:	48 b8 cb 02 80 00 00 	movabs $0x8002cb,%rax
  801424:	00 00 00 
  801427:	ff d0                	call   *%rax
  801429:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80142b:	85 c0                	test   %eax,%eax
  80142d:	0f 88 77 01 00 00    	js     8015aa <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  801433:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  801437:	48 b8 c5 06 80 00 00 	movabs $0x8006c5,%rax
  80143e:	00 00 00 
  801441:	ff d0                	call   *%rax
  801443:	89 c3                	mov    %eax,%ebx
  801445:	85 c0                	test   %eax,%eax
  801447:	0f 88 43 01 00 00    	js     801590 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80144d:	b9 46 00 00 00       	mov    $0x46,%ecx
  801452:	ba 00 10 00 00       	mov    $0x1000,%edx
  801457:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80145b:	bf 00 00 00 00       	mov    $0x0,%edi
  801460:	48 b8 cb 02 80 00 00 	movabs $0x8002cb,%rax
  801467:	00 00 00 
  80146a:	ff d0                	call   *%rax
  80146c:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80146e:	85 c0                	test   %eax,%eax
  801470:	0f 88 1a 01 00 00    	js     801590 <pipe+0x1b4>
    va = fd2data(fd0);
  801476:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80147a:	48 b8 a5 06 80 00 00 	movabs $0x8006a5,%rax
  801481:	00 00 00 
  801484:	ff d0                	call   *%rax
  801486:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801489:	b9 46 00 00 00       	mov    $0x46,%ecx
  80148e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801493:	48 89 c6             	mov    %rax,%rsi
  801496:	bf 00 00 00 00       	mov    $0x0,%edi
  80149b:	48 b8 cb 02 80 00 00 	movabs $0x8002cb,%rax
  8014a2:	00 00 00 
  8014a5:	ff d0                	call   *%rax
  8014a7:	89 c3                	mov    %eax,%ebx
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	0f 88 c5 00 00 00    	js     801576 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8014b1:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8014b5:	48 b8 a5 06 80 00 00 	movabs $0x8006a5,%rax
  8014bc:	00 00 00 
  8014bf:	ff d0                	call   *%rax
  8014c1:	48 89 c1             	mov    %rax,%rcx
  8014c4:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8014ca:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8014d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d5:	4c 89 ee             	mov    %r13,%rsi
  8014d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8014dd:	48 b8 36 03 80 00 00 	movabs $0x800336,%rax
  8014e4:	00 00 00 
  8014e7:	ff d0                	call   *%rax
  8014e9:	89 c3                	mov    %eax,%ebx
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 6e                	js     80155d <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014ef:	be 00 10 00 00       	mov    $0x1000,%esi
  8014f4:	4c 89 ef             	mov    %r13,%rdi
  8014f7:	48 b8 65 02 80 00 00 	movabs $0x800265,%rax
  8014fe:	00 00 00 
  801501:	ff d0                	call   *%rax
  801503:	83 f8 02             	cmp    $0x2,%eax
  801506:	0f 85 ab 00 00 00    	jne    8015b7 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  80150c:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  801513:	00 00 
  801515:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801519:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80151b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80151f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  801526:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80152a:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80152c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801530:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  801537:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80153b:	48 bb 8f 06 80 00 00 	movabs $0x80068f,%rbx
  801542:	00 00 00 
  801545:	ff d3                	call   *%rbx
  801547:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80154b:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80154f:	ff d3                	call   *%rbx
  801551:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  801556:	bb 00 00 00 00       	mov    $0x0,%ebx
  80155b:	eb 4d                	jmp    8015aa <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  80155d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801562:	4c 89 ee             	mov    %r13,%rsi
  801565:	bf 00 00 00 00       	mov    $0x0,%edi
  80156a:	48 b8 0b 04 80 00 00 	movabs $0x80040b,%rax
  801571:	00 00 00 
  801574:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  801576:	ba 00 10 00 00       	mov    $0x1000,%edx
  80157b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80157f:	bf 00 00 00 00       	mov    $0x0,%edi
  801584:	48 b8 0b 04 80 00 00 	movabs $0x80040b,%rax
  80158b:	00 00 00 
  80158e:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  801590:	ba 00 10 00 00       	mov    $0x1000,%edx
  801595:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801599:	bf 00 00 00 00       	mov    $0x0,%edi
  80159e:	48 b8 0b 04 80 00 00 	movabs $0x80040b,%rax
  8015a5:	00 00 00 
  8015a8:	ff d0                	call   *%rax
}
  8015aa:	89 d8                	mov    %ebx,%eax
  8015ac:	48 83 c4 18          	add    $0x18,%rsp
  8015b0:	5b                   	pop    %rbx
  8015b1:	41 5c                	pop    %r12
  8015b3:	41 5d                	pop    %r13
  8015b5:	5d                   	pop    %rbp
  8015b6:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8015b7:	48 b9 d0 32 80 00 00 	movabs $0x8032d0,%rcx
  8015be:	00 00 00 
  8015c1:	48 ba 7c 30 80 00 00 	movabs $0x80307c,%rdx
  8015c8:	00 00 00 
  8015cb:	be 2e 00 00 00       	mov    $0x2e,%esi
  8015d0:	48 bf a3 30 80 00 00 	movabs $0x8030a3,%rdi
  8015d7:	00 00 00 
  8015da:	b8 00 00 00 00       	mov    $0x0,%eax
  8015df:	49 b8 f6 1b 80 00 00 	movabs $0x801bf6,%r8
  8015e6:	00 00 00 
  8015e9:	41 ff d0             	call   *%r8

00000000008015ec <pipeisclosed>:
pipeisclosed(int fdnum) {
  8015ec:	f3 0f 1e fa          	endbr64
  8015f0:	55                   	push   %rbp
  8015f1:	48 89 e5             	mov    %rsp,%rbp
  8015f4:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8015f8:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8015fc:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  801603:	00 00 00 
  801606:	ff d0                	call   *%rax
    if (res < 0) return res;
  801608:	85 c0                	test   %eax,%eax
  80160a:	78 35                	js     801641 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80160c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801610:	48 b8 a5 06 80 00 00 	movabs $0x8006a5,%rax
  801617:	00 00 00 
  80161a:	ff d0                	call   *%rax
  80161c:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80161f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801624:	be 00 10 00 00       	mov    $0x1000,%esi
  801629:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80162d:	48 b8 9b 02 80 00 00 	movabs $0x80029b,%rax
  801634:	00 00 00 
  801637:	ff d0                	call   *%rax
  801639:	85 c0                	test   %eax,%eax
  80163b:	0f 94 c0             	sete   %al
  80163e:	0f b6 c0             	movzbl %al,%eax
}
  801641:	c9                   	leave
  801642:	c3                   	ret

0000000000801643 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  801643:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801647:	48 89 f8             	mov    %rdi,%rax
  80164a:	48 c1 e8 27          	shr    $0x27,%rax
  80164e:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  801655:	7f 00 00 
  801658:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80165c:	f6 c2 01             	test   $0x1,%dl
  80165f:	74 6d                	je     8016ce <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801661:	48 89 f8             	mov    %rdi,%rax
  801664:	48 c1 e8 1e          	shr    $0x1e,%rax
  801668:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80166f:	7f 00 00 
  801672:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801676:	f6 c2 01             	test   $0x1,%dl
  801679:	74 62                	je     8016dd <get_uvpt_entry+0x9a>
  80167b:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801682:	7f 00 00 
  801685:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801689:	f6 c2 80             	test   $0x80,%dl
  80168c:	75 4f                	jne    8016dd <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80168e:	48 89 f8             	mov    %rdi,%rax
  801691:	48 c1 e8 15          	shr    $0x15,%rax
  801695:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80169c:	7f 00 00 
  80169f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8016a3:	f6 c2 01             	test   $0x1,%dl
  8016a6:	74 44                	je     8016ec <get_uvpt_entry+0xa9>
  8016a8:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016af:	7f 00 00 
  8016b2:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8016b6:	f6 c2 80             	test   $0x80,%dl
  8016b9:	75 31                	jne    8016ec <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  8016bb:	48 c1 ef 0c          	shr    $0xc,%rdi
  8016bf:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8016c6:	7f 00 00 
  8016c9:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8016cd:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8016ce:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8016d5:	7f 00 00 
  8016d8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016dc:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8016dd:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8016e4:	7f 00 00 
  8016e7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016eb:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8016ec:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016f3:	7f 00 00 
  8016f6:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016fa:	c3                   	ret

00000000008016fb <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8016fb:	f3 0f 1e fa          	endbr64
  8016ff:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  801702:	48 89 f9             	mov    %rdi,%rcx
  801705:	48 c1 e9 27          	shr    $0x27,%rcx
  801709:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  801710:	7f 00 00 
  801713:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  801717:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  80171e:	f6 c1 01             	test   $0x1,%cl
  801721:	0f 84 b2 00 00 00    	je     8017d9 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  801727:	48 89 f9             	mov    %rdi,%rcx
  80172a:	48 c1 e9 1e          	shr    $0x1e,%rcx
  80172e:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801735:	7f 00 00 
  801738:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80173c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  801743:	40 f6 c6 01          	test   $0x1,%sil
  801747:	0f 84 8c 00 00 00    	je     8017d9 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  80174d:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801754:	7f 00 00 
  801757:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80175b:	a8 80                	test   $0x80,%al
  80175d:	75 7b                	jne    8017da <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  80175f:	48 89 f9             	mov    %rdi,%rcx
  801762:	48 c1 e9 15          	shr    $0x15,%rcx
  801766:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80176d:	7f 00 00 
  801770:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801774:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  80177b:	40 f6 c6 01          	test   $0x1,%sil
  80177f:	74 58                	je     8017d9 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  801781:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801788:	7f 00 00 
  80178b:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80178f:	a8 80                	test   $0x80,%al
  801791:	75 6c                	jne    8017ff <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  801793:	48 89 f9             	mov    %rdi,%rcx
  801796:	48 c1 e9 0c          	shr    $0xc,%rcx
  80179a:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8017a1:	7f 00 00 
  8017a4:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8017a8:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  8017af:	40 f6 c6 01          	test   $0x1,%sil
  8017b3:	74 24                	je     8017d9 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  8017b5:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8017bc:	7f 00 00 
  8017bf:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017c3:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017ca:	ff ff 7f 
  8017cd:	48 21 c8             	and    %rcx,%rax
  8017d0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8017d6:	48 09 d0             	or     %rdx,%rax
}
  8017d9:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8017da:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8017e1:	7f 00 00 
  8017e4:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017e8:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017ef:	ff ff 7f 
  8017f2:	48 21 c8             	and    %rcx,%rax
  8017f5:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8017fb:	48 01 d0             	add    %rdx,%rax
  8017fe:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8017ff:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801806:	7f 00 00 
  801809:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80180d:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  801814:	ff ff 7f 
  801817:	48 21 c8             	and    %rcx,%rax
  80181a:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  801820:	48 01 d0             	add    %rdx,%rax
  801823:	c3                   	ret

0000000000801824 <get_prot>:

int
get_prot(void *va) {
  801824:	f3 0f 1e fa          	endbr64
  801828:	55                   	push   %rbp
  801829:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80182c:	48 b8 43 16 80 00 00 	movabs $0x801643,%rax
  801833:	00 00 00 
  801836:	ff d0                	call   *%rax
  801838:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  80183b:	83 e0 01             	and    $0x1,%eax
  80183e:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  801841:	89 d1                	mov    %edx,%ecx
  801843:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  801849:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80184b:	89 c1                	mov    %eax,%ecx
  80184d:	83 c9 02             	or     $0x2,%ecx
  801850:	f6 c2 02             	test   $0x2,%dl
  801853:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  801856:	89 c1                	mov    %eax,%ecx
  801858:	83 c9 01             	or     $0x1,%ecx
  80185b:	48 85 d2             	test   %rdx,%rdx
  80185e:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801861:	89 c1                	mov    %eax,%ecx
  801863:	83 c9 40             	or     $0x40,%ecx
  801866:	f6 c6 04             	test   $0x4,%dh
  801869:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80186c:	5d                   	pop    %rbp
  80186d:	c3                   	ret

000000000080186e <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80186e:	f3 0f 1e fa          	endbr64
  801872:	55                   	push   %rbp
  801873:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801876:	48 b8 43 16 80 00 00 	movabs $0x801643,%rax
  80187d:	00 00 00 
  801880:	ff d0                	call   *%rax
    return pte & PTE_D;
  801882:	48 c1 e8 06          	shr    $0x6,%rax
  801886:	83 e0 01             	and    $0x1,%eax
}
  801889:	5d                   	pop    %rbp
  80188a:	c3                   	ret

000000000080188b <is_page_present>:

bool
is_page_present(void *va) {
  80188b:	f3 0f 1e fa          	endbr64
  80188f:	55                   	push   %rbp
  801890:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  801893:	48 b8 43 16 80 00 00 	movabs $0x801643,%rax
  80189a:	00 00 00 
  80189d:	ff d0                	call   *%rax
  80189f:	83 e0 01             	and    $0x1,%eax
}
  8018a2:	5d                   	pop    %rbp
  8018a3:	c3                   	ret

00000000008018a4 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8018a4:	f3 0f 1e fa          	endbr64
  8018a8:	55                   	push   %rbp
  8018a9:	48 89 e5             	mov    %rsp,%rbp
  8018ac:	41 57                	push   %r15
  8018ae:	41 56                	push   %r14
  8018b0:	41 55                	push   %r13
  8018b2:	41 54                	push   %r12
  8018b4:	53                   	push   %rbx
  8018b5:	48 83 ec 18          	sub    $0x18,%rsp
  8018b9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8018bd:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8018c1:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8018c6:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8018cd:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8018d0:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8018d7:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8018da:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8018e1:	00 00 00 
  8018e4:	eb 73                	jmp    801959 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018e6:	48 89 d8             	mov    %rbx,%rax
  8018e9:	48 c1 e8 15          	shr    $0x15,%rax
  8018ed:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8018f4:	7f 00 00 
  8018f7:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8018fb:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  801901:	f6 c2 01             	test   $0x1,%dl
  801904:	74 4b                	je     801951 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  801906:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  80190a:	f6 c2 80             	test   $0x80,%dl
  80190d:	74 11                	je     801920 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  80190f:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  801913:	f6 c4 04             	test   $0x4,%ah
  801916:	74 39                	je     801951 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  801918:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  80191e:	eb 20                	jmp    801940 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801920:	48 89 da             	mov    %rbx,%rdx
  801923:	48 c1 ea 0c          	shr    $0xc,%rdx
  801927:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80192e:	7f 00 00 
  801931:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  801935:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80193b:	f6 c4 04             	test   $0x4,%ah
  80193e:	74 11                	je     801951 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  801940:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  801944:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801948:	48 89 df             	mov    %rbx,%rdi
  80194b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80194f:	ff d0                	call   *%rax
    next:
        va += size;
  801951:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  801954:	49 39 df             	cmp    %rbx,%r15
  801957:	72 3e                	jb     801997 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  801959:	49 8b 06             	mov    (%r14),%rax
  80195c:	a8 01                	test   $0x1,%al
  80195e:	74 37                	je     801997 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801960:	48 89 d8             	mov    %rbx,%rax
  801963:	48 c1 e8 1e          	shr    $0x1e,%rax
  801967:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  80196c:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801972:	f6 c2 01             	test   $0x1,%dl
  801975:	74 da                	je     801951 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  801977:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  80197c:	f6 c2 80             	test   $0x80,%dl
  80197f:	0f 84 61 ff ff ff    	je     8018e6 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  801985:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80198a:	f6 c4 04             	test   $0x4,%ah
  80198d:	74 c2                	je     801951 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  80198f:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  801995:	eb a9                	jmp    801940 <foreach_shared_region+0x9c>
    }
    return res;
}
  801997:	b8 00 00 00 00       	mov    $0x0,%eax
  80199c:	48 83 c4 18          	add    $0x18,%rsp
  8019a0:	5b                   	pop    %rbx
  8019a1:	41 5c                	pop    %r12
  8019a3:	41 5d                	pop    %r13
  8019a5:	41 5e                	pop    %r14
  8019a7:	41 5f                	pop    %r15
  8019a9:	5d                   	pop    %rbp
  8019aa:	c3                   	ret

00000000008019ab <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  8019ab:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  8019af:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b4:	c3                   	ret

00000000008019b5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8019b5:	f3 0f 1e fa          	endbr64
  8019b9:	55                   	push   %rbp
  8019ba:	48 89 e5             	mov    %rsp,%rbp
  8019bd:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8019c0:	48 be b3 30 80 00 00 	movabs $0x8030b3,%rsi
  8019c7:	00 00 00 
  8019ca:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  8019d1:	00 00 00 
  8019d4:	ff d0                	call   *%rax
    return 0;
}
  8019d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019db:	5d                   	pop    %rbp
  8019dc:	c3                   	ret

00000000008019dd <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8019dd:	f3 0f 1e fa          	endbr64
  8019e1:	55                   	push   %rbp
  8019e2:	48 89 e5             	mov    %rsp,%rbp
  8019e5:	41 57                	push   %r15
  8019e7:	41 56                	push   %r14
  8019e9:	41 55                	push   %r13
  8019eb:	41 54                	push   %r12
  8019ed:	53                   	push   %rbx
  8019ee:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8019f5:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8019fc:	48 85 d2             	test   %rdx,%rdx
  8019ff:	74 7a                	je     801a7b <devcons_write+0x9e>
  801a01:	49 89 d6             	mov    %rdx,%r14
  801a04:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a0a:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  801a0f:	49 bf b6 28 80 00 00 	movabs $0x8028b6,%r15
  801a16:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  801a19:	4c 89 f3             	mov    %r14,%rbx
  801a1c:	48 29 f3             	sub    %rsi,%rbx
  801a1f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a24:	48 39 c3             	cmp    %rax,%rbx
  801a27:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801a2b:	4c 63 eb             	movslq %ebx,%r13
  801a2e:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801a35:	48 01 c6             	add    %rax,%rsi
  801a38:	4c 89 ea             	mov    %r13,%rdx
  801a3b:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a42:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  801a45:	4c 89 ee             	mov    %r13,%rsi
  801a48:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a4f:	48 b8 26 01 80 00 00 	movabs $0x800126,%rax
  801a56:	00 00 00 
  801a59:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801a5b:	41 01 dc             	add    %ebx,%r12d
  801a5e:	49 63 f4             	movslq %r12d,%rsi
  801a61:	4c 39 f6             	cmp    %r14,%rsi
  801a64:	72 b3                	jb     801a19 <devcons_write+0x3c>
    return res;
  801a66:	49 63 c4             	movslq %r12d,%rax
}
  801a69:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801a70:	5b                   	pop    %rbx
  801a71:	41 5c                	pop    %r12
  801a73:	41 5d                	pop    %r13
  801a75:	41 5e                	pop    %r14
  801a77:	41 5f                	pop    %r15
  801a79:	5d                   	pop    %rbp
  801a7a:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  801a7b:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a81:	eb e3                	jmp    801a66 <devcons_write+0x89>

0000000000801a83 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a83:	f3 0f 1e fa          	endbr64
  801a87:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801a8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8f:	48 85 c0             	test   %rax,%rax
  801a92:	74 55                	je     801ae9 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a94:	55                   	push   %rbp
  801a95:	48 89 e5             	mov    %rsp,%rbp
  801a98:	41 55                	push   %r13
  801a9a:	41 54                	push   %r12
  801a9c:	53                   	push   %rbx
  801a9d:	48 83 ec 08          	sub    $0x8,%rsp
  801aa1:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801aa4:	48 bb 57 01 80 00 00 	movabs $0x800157,%rbx
  801aab:	00 00 00 
  801aae:	49 bc 30 02 80 00 00 	movabs $0x800230,%r12
  801ab5:	00 00 00 
  801ab8:	eb 03                	jmp    801abd <devcons_read+0x3a>
  801aba:	41 ff d4             	call   *%r12
  801abd:	ff d3                	call   *%rbx
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	74 f7                	je     801aba <devcons_read+0x37>
    if (c < 0) return c;
  801ac3:	48 63 d0             	movslq %eax,%rdx
  801ac6:	78 13                	js     801adb <devcons_read+0x58>
    if (c == 0x04) return 0;
  801ac8:	ba 00 00 00 00       	mov    $0x0,%edx
  801acd:	83 f8 04             	cmp    $0x4,%eax
  801ad0:	74 09                	je     801adb <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  801ad2:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801ad6:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801adb:	48 89 d0             	mov    %rdx,%rax
  801ade:	48 83 c4 08          	add    $0x8,%rsp
  801ae2:	5b                   	pop    %rbx
  801ae3:	41 5c                	pop    %r12
  801ae5:	41 5d                	pop    %r13
  801ae7:	5d                   	pop    %rbp
  801ae8:	c3                   	ret
  801ae9:	48 89 d0             	mov    %rdx,%rax
  801aec:	c3                   	ret

0000000000801aed <cputchar>:
cputchar(int ch) {
  801aed:	f3 0f 1e fa          	endbr64
  801af1:	55                   	push   %rbp
  801af2:	48 89 e5             	mov    %rsp,%rbp
  801af5:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801af9:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801afd:	be 01 00 00 00       	mov    $0x1,%esi
  801b02:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801b06:	48 b8 26 01 80 00 00 	movabs $0x800126,%rax
  801b0d:	00 00 00 
  801b10:	ff d0                	call   *%rax
}
  801b12:	c9                   	leave
  801b13:	c3                   	ret

0000000000801b14 <getchar>:
getchar(void) {
  801b14:	f3 0f 1e fa          	endbr64
  801b18:	55                   	push   %rbp
  801b19:	48 89 e5             	mov    %rsp,%rbp
  801b1c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801b20:	ba 01 00 00 00       	mov    $0x1,%edx
  801b25:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801b29:	bf 00 00 00 00       	mov    $0x0,%edi
  801b2e:	48 b8 24 0a 80 00 00 	movabs $0x800a24,%rax
  801b35:	00 00 00 
  801b38:	ff d0                	call   *%rax
  801b3a:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	78 06                	js     801b46 <getchar+0x32>
  801b40:	74 08                	je     801b4a <getchar+0x36>
  801b42:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  801b46:	89 d0                	mov    %edx,%eax
  801b48:	c9                   	leave
  801b49:	c3                   	ret
    return res < 0 ? res : res ? c :
  801b4a:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801b4f:	eb f5                	jmp    801b46 <getchar+0x32>

0000000000801b51 <iscons>:
iscons(int fdnum) {
  801b51:	f3 0f 1e fa          	endbr64
  801b55:	55                   	push   %rbp
  801b56:	48 89 e5             	mov    %rsp,%rbp
  801b59:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801b5d:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b61:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  801b68:	00 00 00 
  801b6b:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	78 18                	js     801b89 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  801b71:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b75:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801b7c:	00 00 00 
  801b7f:	8b 00                	mov    (%rax),%eax
  801b81:	39 02                	cmp    %eax,(%rdx)
  801b83:	0f 94 c0             	sete   %al
  801b86:	0f b6 c0             	movzbl %al,%eax
}
  801b89:	c9                   	leave
  801b8a:	c3                   	ret

0000000000801b8b <opencons>:
opencons(void) {
  801b8b:	f3 0f 1e fa          	endbr64
  801b8f:	55                   	push   %rbp
  801b90:	48 89 e5             	mov    %rsp,%rbp
  801b93:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801b97:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801b9b:	48 b8 c5 06 80 00 00 	movabs $0x8006c5,%rax
  801ba2:	00 00 00 
  801ba5:	ff d0                	call   *%rax
  801ba7:	85 c0                	test   %eax,%eax
  801ba9:	78 49                	js     801bf4 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801bab:	b9 46 00 00 00       	mov    $0x46,%ecx
  801bb0:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bb5:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801bb9:	bf 00 00 00 00       	mov    $0x0,%edi
  801bbe:	48 b8 cb 02 80 00 00 	movabs $0x8002cb,%rax
  801bc5:	00 00 00 
  801bc8:	ff d0                	call   *%rax
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	78 26                	js     801bf4 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  801bce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bd2:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801bd9:	00 00 
  801bdb:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801bdd:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801be1:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801be8:	48 b8 8f 06 80 00 00 	movabs $0x80068f,%rax
  801bef:	00 00 00 
  801bf2:	ff d0                	call   *%rax
}
  801bf4:	c9                   	leave
  801bf5:	c3                   	ret

0000000000801bf6 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801bf6:	f3 0f 1e fa          	endbr64
  801bfa:	55                   	push   %rbp
  801bfb:	48 89 e5             	mov    %rsp,%rbp
  801bfe:	41 56                	push   %r14
  801c00:	41 55                	push   %r13
  801c02:	41 54                	push   %r12
  801c04:	53                   	push   %rbx
  801c05:	48 83 ec 50          	sub    $0x50,%rsp
  801c09:	49 89 fc             	mov    %rdi,%r12
  801c0c:	41 89 f5             	mov    %esi,%r13d
  801c0f:	48 89 d3             	mov    %rdx,%rbx
  801c12:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c16:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801c1a:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801c1e:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801c25:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c29:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801c2d:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801c31:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801c35:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  801c3c:	00 00 00 
  801c3f:	4c 8b 30             	mov    (%rax),%r14
  801c42:	48 b8 fb 01 80 00 00 	movabs $0x8001fb,%rax
  801c49:	00 00 00 
  801c4c:	ff d0                	call   *%rax
  801c4e:	89 c6                	mov    %eax,%esi
  801c50:	45 89 e8             	mov    %r13d,%r8d
  801c53:	4c 89 e1             	mov    %r12,%rcx
  801c56:	4c 89 f2             	mov    %r14,%rdx
  801c59:	48 bf f8 32 80 00 00 	movabs $0x8032f8,%rdi
  801c60:	00 00 00 
  801c63:	b8 00 00 00 00       	mov    $0x0,%eax
  801c68:	49 bc 52 1d 80 00 00 	movabs $0x801d52,%r12
  801c6f:	00 00 00 
  801c72:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801c75:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801c79:	48 89 df             	mov    %rbx,%rdi
  801c7c:	48 b8 ea 1c 80 00 00 	movabs $0x801cea,%rax
  801c83:	00 00 00 
  801c86:	ff d0                	call   *%rax
    cprintf("\n");
  801c88:	48 bf 0c 30 80 00 00 	movabs $0x80300c,%rdi
  801c8f:	00 00 00 
  801c92:	b8 00 00 00 00       	mov    $0x0,%eax
  801c97:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801c9a:	cc                   	int3
  801c9b:	eb fd                	jmp    801c9a <_panic+0xa4>

0000000000801c9d <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801c9d:	f3 0f 1e fa          	endbr64
  801ca1:	55                   	push   %rbp
  801ca2:	48 89 e5             	mov    %rsp,%rbp
  801ca5:	53                   	push   %rbx
  801ca6:	48 83 ec 08          	sub    $0x8,%rsp
  801caa:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801cad:	8b 06                	mov    (%rsi),%eax
  801caf:	8d 50 01             	lea    0x1(%rax),%edx
  801cb2:	89 16                	mov    %edx,(%rsi)
  801cb4:	48 98                	cltq
  801cb6:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801cbb:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801cc1:	74 0a                	je     801ccd <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801cc3:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801cc7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ccb:	c9                   	leave
  801ccc:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  801ccd:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801cd1:	be ff 00 00 00       	mov    $0xff,%esi
  801cd6:	48 b8 26 01 80 00 00 	movabs $0x800126,%rax
  801cdd:	00 00 00 
  801ce0:	ff d0                	call   *%rax
        state->offset = 0;
  801ce2:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801ce8:	eb d9                	jmp    801cc3 <putch+0x26>

0000000000801cea <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801cea:	f3 0f 1e fa          	endbr64
  801cee:	55                   	push   %rbp
  801cef:	48 89 e5             	mov    %rsp,%rbp
  801cf2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801cf9:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801cfc:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801d03:	b9 21 00 00 00       	mov    $0x21,%ecx
  801d08:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0d:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801d10:	48 89 f1             	mov    %rsi,%rcx
  801d13:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801d1a:	48 bf 9d 1c 80 00 00 	movabs $0x801c9d,%rdi
  801d21:	00 00 00 
  801d24:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  801d2b:	00 00 00 
  801d2e:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801d30:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801d37:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801d3e:	48 b8 26 01 80 00 00 	movabs $0x800126,%rax
  801d45:	00 00 00 
  801d48:	ff d0                	call   *%rax

    return state.count;
}
  801d4a:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801d50:	c9                   	leave
  801d51:	c3                   	ret

0000000000801d52 <cprintf>:

int
cprintf(const char *fmt, ...) {
  801d52:	f3 0f 1e fa          	endbr64
  801d56:	55                   	push   %rbp
  801d57:	48 89 e5             	mov    %rsp,%rbp
  801d5a:	48 83 ec 50          	sub    $0x50,%rsp
  801d5e:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801d62:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801d66:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d6a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801d6e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801d72:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801d79:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d7d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d81:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801d85:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801d89:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801d8d:	48 b8 ea 1c 80 00 00 	movabs $0x801cea,%rax
  801d94:	00 00 00 
  801d97:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801d99:	c9                   	leave
  801d9a:	c3                   	ret

0000000000801d9b <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801d9b:	f3 0f 1e fa          	endbr64
  801d9f:	55                   	push   %rbp
  801da0:	48 89 e5             	mov    %rsp,%rbp
  801da3:	41 57                	push   %r15
  801da5:	41 56                	push   %r14
  801da7:	41 55                	push   %r13
  801da9:	41 54                	push   %r12
  801dab:	53                   	push   %rbx
  801dac:	48 83 ec 18          	sub    $0x18,%rsp
  801db0:	49 89 fc             	mov    %rdi,%r12
  801db3:	49 89 f5             	mov    %rsi,%r13
  801db6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801dba:	8b 45 10             	mov    0x10(%rbp),%eax
  801dbd:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801dc0:	41 89 cf             	mov    %ecx,%r15d
  801dc3:	4c 39 fa             	cmp    %r15,%rdx
  801dc6:	73 5b                	jae    801e23 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801dc8:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801dcc:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801dd0:	85 db                	test   %ebx,%ebx
  801dd2:	7e 0e                	jle    801de2 <print_num+0x47>
            putch(padc, put_arg);
  801dd4:	4c 89 ee             	mov    %r13,%rsi
  801dd7:	44 89 f7             	mov    %r14d,%edi
  801dda:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801ddd:	83 eb 01             	sub    $0x1,%ebx
  801de0:	75 f2                	jne    801dd4 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801de2:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801de6:	48 b9 d0 30 80 00 00 	movabs $0x8030d0,%rcx
  801ded:	00 00 00 
  801df0:	48 b8 bf 30 80 00 00 	movabs $0x8030bf,%rax
  801df7:	00 00 00 
  801dfa:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801dfe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e02:	ba 00 00 00 00       	mov    $0x0,%edx
  801e07:	49 f7 f7             	div    %r15
  801e0a:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801e0e:	4c 89 ee             	mov    %r13,%rsi
  801e11:	41 ff d4             	call   *%r12
}
  801e14:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801e18:	5b                   	pop    %rbx
  801e19:	41 5c                	pop    %r12
  801e1b:	41 5d                	pop    %r13
  801e1d:	41 5e                	pop    %r14
  801e1f:	41 5f                	pop    %r15
  801e21:	5d                   	pop    %rbp
  801e22:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801e23:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e27:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2c:	49 f7 f7             	div    %r15
  801e2f:	48 83 ec 08          	sub    $0x8,%rsp
  801e33:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801e37:	52                   	push   %rdx
  801e38:	45 0f be c9          	movsbl %r9b,%r9d
  801e3c:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801e40:	48 89 c2             	mov    %rax,%rdx
  801e43:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  801e4a:	00 00 00 
  801e4d:	ff d0                	call   *%rax
  801e4f:	48 83 c4 10          	add    $0x10,%rsp
  801e53:	eb 8d                	jmp    801de2 <print_num+0x47>

0000000000801e55 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  801e55:	f3 0f 1e fa          	endbr64
    state->count++;
  801e59:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801e5d:	48 8b 06             	mov    (%rsi),%rax
  801e60:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801e64:	73 0a                	jae    801e70 <sprintputch+0x1b>
        *state->start++ = ch;
  801e66:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e6a:	48 89 16             	mov    %rdx,(%rsi)
  801e6d:	40 88 38             	mov    %dil,(%rax)
    }
}
  801e70:	c3                   	ret

0000000000801e71 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801e71:	f3 0f 1e fa          	endbr64
  801e75:	55                   	push   %rbp
  801e76:	48 89 e5             	mov    %rsp,%rbp
  801e79:	48 83 ec 50          	sub    $0x50,%rsp
  801e7d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e81:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801e85:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801e89:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801e90:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e94:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e98:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801e9c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801ea0:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801ea4:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  801eab:	00 00 00 
  801eae:	ff d0                	call   *%rax
}
  801eb0:	c9                   	leave
  801eb1:	c3                   	ret

0000000000801eb2 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801eb2:	f3 0f 1e fa          	endbr64
  801eb6:	55                   	push   %rbp
  801eb7:	48 89 e5             	mov    %rsp,%rbp
  801eba:	41 57                	push   %r15
  801ebc:	41 56                	push   %r14
  801ebe:	41 55                	push   %r13
  801ec0:	41 54                	push   %r12
  801ec2:	53                   	push   %rbx
  801ec3:	48 83 ec 38          	sub    $0x38,%rsp
  801ec7:	49 89 fe             	mov    %rdi,%r14
  801eca:	49 89 f5             	mov    %rsi,%r13
  801ecd:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  801ed0:	48 8b 01             	mov    (%rcx),%rax
  801ed3:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801ed7:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801edb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801edf:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801ee3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801ee7:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  801eeb:	0f b6 3b             	movzbl (%rbx),%edi
  801eee:	40 80 ff 25          	cmp    $0x25,%dil
  801ef2:	74 18                	je     801f0c <vprintfmt+0x5a>
            if (!ch) return;
  801ef4:	40 84 ff             	test   %dil,%dil
  801ef7:	0f 84 b2 06 00 00    	je     8025af <vprintfmt+0x6fd>
            putch(ch, put_arg);
  801efd:	40 0f b6 ff          	movzbl %dil,%edi
  801f01:	4c 89 ee             	mov    %r13,%rsi
  801f04:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  801f07:	4c 89 e3             	mov    %r12,%rbx
  801f0a:	eb db                	jmp    801ee7 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  801f0c:	be 00 00 00 00       	mov    $0x0,%esi
  801f11:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  801f15:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801f1a:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f20:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801f27:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f2b:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  801f30:	41 0f b6 04 24       	movzbl (%r12),%eax
  801f35:	88 45 a0             	mov    %al,-0x60(%rbp)
  801f38:	83 e8 23             	sub    $0x23,%eax
  801f3b:	3c 57                	cmp    $0x57,%al
  801f3d:	0f 87 52 06 00 00    	ja     802595 <vprintfmt+0x6e3>
  801f43:	0f b6 c0             	movzbl %al,%eax
  801f46:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  801f4d:	00 00 00 
  801f50:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  801f54:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  801f57:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  801f5b:	eb ce                	jmp    801f2b <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  801f5d:	49 89 dc             	mov    %rbx,%r12
  801f60:	be 01 00 00 00       	mov    $0x1,%esi
  801f65:	eb c4                	jmp    801f2b <vprintfmt+0x79>
            padc = ch;
  801f67:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  801f6b:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f6e:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801f71:	eb b8                	jmp    801f2b <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f73:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f76:	83 f8 2f             	cmp    $0x2f,%eax
  801f79:	77 24                	ja     801f9f <vprintfmt+0xed>
  801f7b:	89 c1                	mov    %eax,%ecx
  801f7d:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  801f81:	83 c0 08             	add    $0x8,%eax
  801f84:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f87:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  801f8a:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  801f8d:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801f91:	79 98                	jns    801f2b <vprintfmt+0x79>
                width = precision;
  801f93:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  801f97:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f9d:	eb 8c                	jmp    801f2b <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f9f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801fa3:	48 8d 41 08          	lea    0x8(%rcx),%rax
  801fa7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fab:	eb da                	jmp    801f87 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  801fad:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  801fb2:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fb6:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  801fbc:	3c 39                	cmp    $0x39,%al
  801fbe:	77 1c                	ja     801fdc <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  801fc0:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  801fc4:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  801fc8:	0f b6 c0             	movzbl %al,%eax
  801fcb:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fd0:	0f b6 03             	movzbl (%rbx),%eax
  801fd3:	3c 39                	cmp    $0x39,%al
  801fd5:	76 e9                	jbe    801fc0 <vprintfmt+0x10e>
        process_precision:
  801fd7:	49 89 dc             	mov    %rbx,%r12
  801fda:	eb b1                	jmp    801f8d <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  801fdc:	49 89 dc             	mov    %rbx,%r12
  801fdf:	eb ac                	jmp    801f8d <vprintfmt+0xdb>
            width = MAX(0, width);
  801fe1:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  801fe4:	85 c9                	test   %ecx,%ecx
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  801feb:	0f 49 c1             	cmovns %ecx,%eax
  801fee:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801ff1:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801ff4:	e9 32 ff ff ff       	jmp    801f2b <vprintfmt+0x79>
            lflag++;
  801ff9:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801ffc:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fff:	e9 27 ff ff ff       	jmp    801f2b <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  802004:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802007:	83 f8 2f             	cmp    $0x2f,%eax
  80200a:	77 19                	ja     802025 <vprintfmt+0x173>
  80200c:	89 c2                	mov    %eax,%edx
  80200e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802012:	83 c0 08             	add    $0x8,%eax
  802015:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802018:	8b 3a                	mov    (%rdx),%edi
  80201a:	4c 89 ee             	mov    %r13,%rsi
  80201d:	41 ff d6             	call   *%r14
            break;
  802020:	e9 c2 fe ff ff       	jmp    801ee7 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  802025:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802029:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80202d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802031:	eb e5                	jmp    802018 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  802033:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802036:	83 f8 2f             	cmp    $0x2f,%eax
  802039:	77 5a                	ja     802095 <vprintfmt+0x1e3>
  80203b:	89 c2                	mov    %eax,%edx
  80203d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802041:	83 c0 08             	add    $0x8,%eax
  802044:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  802047:	8b 02                	mov    (%rdx),%eax
  802049:	89 c1                	mov    %eax,%ecx
  80204b:	f7 d9                	neg    %ecx
  80204d:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  802050:	83 f9 13             	cmp    $0x13,%ecx
  802053:	7f 4e                	jg     8020a3 <vprintfmt+0x1f1>
  802055:	48 63 c1             	movslq %ecx,%rax
  802058:	48 ba 20 36 80 00 00 	movabs $0x803620,%rdx
  80205f:	00 00 00 
  802062:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802066:	48 85 c0             	test   %rax,%rax
  802069:	74 38                	je     8020a3 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  80206b:	48 89 c1             	mov    %rax,%rcx
  80206e:	48 ba 8e 30 80 00 00 	movabs $0x80308e,%rdx
  802075:	00 00 00 
  802078:	4c 89 ee             	mov    %r13,%rsi
  80207b:	4c 89 f7             	mov    %r14,%rdi
  80207e:	b8 00 00 00 00       	mov    $0x0,%eax
  802083:	49 b8 71 1e 80 00 00 	movabs $0x801e71,%r8
  80208a:	00 00 00 
  80208d:	41 ff d0             	call   *%r8
  802090:	e9 52 fe ff ff       	jmp    801ee7 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  802095:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802099:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80209d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020a1:	eb a4                	jmp    802047 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8020a3:	48 ba e8 30 80 00 00 	movabs $0x8030e8,%rdx
  8020aa:	00 00 00 
  8020ad:	4c 89 ee             	mov    %r13,%rsi
  8020b0:	4c 89 f7             	mov    %r14,%rdi
  8020b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b8:	49 b8 71 1e 80 00 00 	movabs $0x801e71,%r8
  8020bf:	00 00 00 
  8020c2:	41 ff d0             	call   *%r8
  8020c5:	e9 1d fe ff ff       	jmp    801ee7 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8020ca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020cd:	83 f8 2f             	cmp    $0x2f,%eax
  8020d0:	77 6c                	ja     80213e <vprintfmt+0x28c>
  8020d2:	89 c2                	mov    %eax,%edx
  8020d4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8020d8:	83 c0 08             	add    $0x8,%eax
  8020db:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020de:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8020e1:	48 85 d2             	test   %rdx,%rdx
  8020e4:	48 b8 e1 30 80 00 00 	movabs $0x8030e1,%rax
  8020eb:	00 00 00 
  8020ee:	48 0f 45 c2          	cmovne %rdx,%rax
  8020f2:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8020f6:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8020fa:	7e 06                	jle    802102 <vprintfmt+0x250>
  8020fc:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  802100:	75 4a                	jne    80214c <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802102:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802106:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80210a:	0f b6 00             	movzbl (%rax),%eax
  80210d:	84 c0                	test   %al,%al
  80210f:	0f 85 9a 00 00 00    	jne    8021af <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  802115:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802118:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  80211c:	85 c0                	test   %eax,%eax
  80211e:	0f 8e c3 fd ff ff    	jle    801ee7 <vprintfmt+0x35>
  802124:	4c 89 ee             	mov    %r13,%rsi
  802127:	bf 20 00 00 00       	mov    $0x20,%edi
  80212c:	41 ff d6             	call   *%r14
  80212f:	41 83 ec 01          	sub    $0x1,%r12d
  802133:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  802137:	75 eb                	jne    802124 <vprintfmt+0x272>
  802139:	e9 a9 fd ff ff       	jmp    801ee7 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80213e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802142:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802146:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80214a:	eb 92                	jmp    8020de <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  80214c:	49 63 f7             	movslq %r15d,%rsi
  80214f:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  802153:	48 b8 75 26 80 00 00 	movabs $0x802675,%rax
  80215a:	00 00 00 
  80215d:	ff d0                	call   *%rax
  80215f:	48 89 c2             	mov    %rax,%rdx
  802162:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802165:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  802167:	8d 70 ff             	lea    -0x1(%rax),%esi
  80216a:	89 75 ac             	mov    %esi,-0x54(%rbp)
  80216d:	85 c0                	test   %eax,%eax
  80216f:	7e 91                	jle    802102 <vprintfmt+0x250>
  802171:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  802176:	4c 89 ee             	mov    %r13,%rsi
  802179:	44 89 e7             	mov    %r12d,%edi
  80217c:	41 ff d6             	call   *%r14
  80217f:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  802183:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802186:	83 f8 ff             	cmp    $0xffffffff,%eax
  802189:	75 eb                	jne    802176 <vprintfmt+0x2c4>
  80218b:	e9 72 ff ff ff       	jmp    802102 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  802190:	0f b6 f8             	movzbl %al,%edi
  802193:	4c 89 ee             	mov    %r13,%rsi
  802196:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802199:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80219d:	49 83 c4 01          	add    $0x1,%r12
  8021a1:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  8021a7:	84 c0                	test   %al,%al
  8021a9:	0f 84 66 ff ff ff    	je     802115 <vprintfmt+0x263>
  8021af:	45 85 ff             	test   %r15d,%r15d
  8021b2:	78 0a                	js     8021be <vprintfmt+0x30c>
  8021b4:	41 83 ef 01          	sub    $0x1,%r15d
  8021b8:	0f 88 57 ff ff ff    	js     802115 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8021be:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8021c2:	74 cc                	je     802190 <vprintfmt+0x2de>
  8021c4:	8d 50 e0             	lea    -0x20(%rax),%edx
  8021c7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8021cc:	80 fa 5e             	cmp    $0x5e,%dl
  8021cf:	77 c2                	ja     802193 <vprintfmt+0x2e1>
  8021d1:	eb bd                	jmp    802190 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8021d3:	40 84 f6             	test   %sil,%sil
  8021d6:	75 26                	jne    8021fe <vprintfmt+0x34c>
    switch (lflag) {
  8021d8:	85 d2                	test   %edx,%edx
  8021da:	74 59                	je     802235 <vprintfmt+0x383>
  8021dc:	83 fa 01             	cmp    $0x1,%edx
  8021df:	74 7b                	je     80225c <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8021e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021e4:	83 f8 2f             	cmp    $0x2f,%eax
  8021e7:	0f 87 96 00 00 00    	ja     802283 <vprintfmt+0x3d1>
  8021ed:	89 c2                	mov    %eax,%edx
  8021ef:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021f3:	83 c0 08             	add    $0x8,%eax
  8021f6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021f9:	4c 8b 22             	mov    (%rdx),%r12
  8021fc:	eb 17                	jmp    802215 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8021fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802201:	83 f8 2f             	cmp    $0x2f,%eax
  802204:	77 21                	ja     802227 <vprintfmt+0x375>
  802206:	89 c2                	mov    %eax,%edx
  802208:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80220c:	83 c0 08             	add    $0x8,%eax
  80220f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802212:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  802215:	4d 85 e4             	test   %r12,%r12
  802218:	78 7a                	js     802294 <vprintfmt+0x3e2>
            num = i;
  80221a:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  80221d:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  802222:	e9 50 02 00 00       	jmp    802477 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  802227:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80222b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80222f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802233:	eb dd                	jmp    802212 <vprintfmt+0x360>
        return va_arg(*ap, int);
  802235:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802238:	83 f8 2f             	cmp    $0x2f,%eax
  80223b:	77 11                	ja     80224e <vprintfmt+0x39c>
  80223d:	89 c2                	mov    %eax,%edx
  80223f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802243:	83 c0 08             	add    $0x8,%eax
  802246:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802249:	4c 63 22             	movslq (%rdx),%r12
  80224c:	eb c7                	jmp    802215 <vprintfmt+0x363>
  80224e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802252:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802256:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80225a:	eb ed                	jmp    802249 <vprintfmt+0x397>
        return va_arg(*ap, long);
  80225c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80225f:	83 f8 2f             	cmp    $0x2f,%eax
  802262:	77 11                	ja     802275 <vprintfmt+0x3c3>
  802264:	89 c2                	mov    %eax,%edx
  802266:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80226a:	83 c0 08             	add    $0x8,%eax
  80226d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802270:	4c 8b 22             	mov    (%rdx),%r12
  802273:	eb a0                	jmp    802215 <vprintfmt+0x363>
  802275:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802279:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80227d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802281:	eb ed                	jmp    802270 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  802283:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802287:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80228b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80228f:	e9 65 ff ff ff       	jmp    8021f9 <vprintfmt+0x347>
                putch('-', put_arg);
  802294:	4c 89 ee             	mov    %r13,%rsi
  802297:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80229c:	41 ff d6             	call   *%r14
                i = -i;
  80229f:	49 f7 dc             	neg    %r12
  8022a2:	e9 73 ff ff ff       	jmp    80221a <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  8022a7:	40 84 f6             	test   %sil,%sil
  8022aa:	75 32                	jne    8022de <vprintfmt+0x42c>
    switch (lflag) {
  8022ac:	85 d2                	test   %edx,%edx
  8022ae:	74 5d                	je     80230d <vprintfmt+0x45b>
  8022b0:	83 fa 01             	cmp    $0x1,%edx
  8022b3:	0f 84 82 00 00 00    	je     80233b <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8022b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022bc:	83 f8 2f             	cmp    $0x2f,%eax
  8022bf:	0f 87 a5 00 00 00    	ja     80236a <vprintfmt+0x4b8>
  8022c5:	89 c2                	mov    %eax,%edx
  8022c7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022cb:	83 c0 08             	add    $0x8,%eax
  8022ce:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022d1:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022d4:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8022d9:	e9 99 01 00 00       	jmp    802477 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8022de:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022e1:	83 f8 2f             	cmp    $0x2f,%eax
  8022e4:	77 19                	ja     8022ff <vprintfmt+0x44d>
  8022e6:	89 c2                	mov    %eax,%edx
  8022e8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022ec:	83 c0 08             	add    $0x8,%eax
  8022ef:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022f2:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8022fa:	e9 78 01 00 00       	jmp    802477 <vprintfmt+0x5c5>
  8022ff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802303:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802307:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80230b:	eb e5                	jmp    8022f2 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  80230d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802310:	83 f8 2f             	cmp    $0x2f,%eax
  802313:	77 18                	ja     80232d <vprintfmt+0x47b>
  802315:	89 c2                	mov    %eax,%edx
  802317:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80231b:	83 c0 08             	add    $0x8,%eax
  80231e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802321:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  802323:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802328:	e9 4a 01 00 00       	jmp    802477 <vprintfmt+0x5c5>
  80232d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802331:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802335:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802339:	eb e6                	jmp    802321 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  80233b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80233e:	83 f8 2f             	cmp    $0x2f,%eax
  802341:	77 19                	ja     80235c <vprintfmt+0x4aa>
  802343:	89 c2                	mov    %eax,%edx
  802345:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802349:	83 c0 08             	add    $0x8,%eax
  80234c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80234f:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  802352:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  802357:	e9 1b 01 00 00       	jmp    802477 <vprintfmt+0x5c5>
  80235c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802360:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802364:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802368:	eb e5                	jmp    80234f <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  80236a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80236e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802372:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802376:	e9 56 ff ff ff       	jmp    8022d1 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  80237b:	40 84 f6             	test   %sil,%sil
  80237e:	75 2e                	jne    8023ae <vprintfmt+0x4fc>
    switch (lflag) {
  802380:	85 d2                	test   %edx,%edx
  802382:	74 59                	je     8023dd <vprintfmt+0x52b>
  802384:	83 fa 01             	cmp    $0x1,%edx
  802387:	74 7f                	je     802408 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  802389:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80238c:	83 f8 2f             	cmp    $0x2f,%eax
  80238f:	0f 87 9f 00 00 00    	ja     802434 <vprintfmt+0x582>
  802395:	89 c2                	mov    %eax,%edx
  802397:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80239b:	83 c0 08             	add    $0x8,%eax
  80239e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023a1:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023a4:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8023a9:	e9 c9 00 00 00       	jmp    802477 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8023ae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023b1:	83 f8 2f             	cmp    $0x2f,%eax
  8023b4:	77 19                	ja     8023cf <vprintfmt+0x51d>
  8023b6:	89 c2                	mov    %eax,%edx
  8023b8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023bc:	83 c0 08             	add    $0x8,%eax
  8023bf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023c2:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023c5:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8023ca:	e9 a8 00 00 00       	jmp    802477 <vprintfmt+0x5c5>
  8023cf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023d3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023d7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023db:	eb e5                	jmp    8023c2 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8023dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023e0:	83 f8 2f             	cmp    $0x2f,%eax
  8023e3:	77 15                	ja     8023fa <vprintfmt+0x548>
  8023e5:	89 c2                	mov    %eax,%edx
  8023e7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023eb:	83 c0 08             	add    $0x8,%eax
  8023ee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023f1:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8023f3:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8023f8:	eb 7d                	jmp    802477 <vprintfmt+0x5c5>
  8023fa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023fe:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802402:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802406:	eb e9                	jmp    8023f1 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  802408:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80240b:	83 f8 2f             	cmp    $0x2f,%eax
  80240e:	77 16                	ja     802426 <vprintfmt+0x574>
  802410:	89 c2                	mov    %eax,%edx
  802412:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802416:	83 c0 08             	add    $0x8,%eax
  802419:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80241c:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80241f:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  802424:	eb 51                	jmp    802477 <vprintfmt+0x5c5>
  802426:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80242a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80242e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802432:	eb e8                	jmp    80241c <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  802434:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802438:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80243c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802440:	e9 5c ff ff ff       	jmp    8023a1 <vprintfmt+0x4ef>
            putch('0', put_arg);
  802445:	4c 89 ee             	mov    %r13,%rsi
  802448:	bf 30 00 00 00       	mov    $0x30,%edi
  80244d:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  802450:	4c 89 ee             	mov    %r13,%rsi
  802453:	bf 78 00 00 00       	mov    $0x78,%edi
  802458:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  80245b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80245e:	83 f8 2f             	cmp    $0x2f,%eax
  802461:	77 47                	ja     8024aa <vprintfmt+0x5f8>
  802463:	89 c2                	mov    %eax,%edx
  802465:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802469:	83 c0 08             	add    $0x8,%eax
  80246c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80246f:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802472:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  802477:	48 83 ec 08          	sub    $0x8,%rsp
  80247b:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  80247f:	0f 94 c0             	sete   %al
  802482:	0f b6 c0             	movzbl %al,%eax
  802485:	50                   	push   %rax
  802486:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  80248b:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80248f:	4c 89 ee             	mov    %r13,%rsi
  802492:	4c 89 f7             	mov    %r14,%rdi
  802495:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  80249c:	00 00 00 
  80249f:	ff d0                	call   *%rax
            break;
  8024a1:	48 83 c4 10          	add    $0x10,%rsp
  8024a5:	e9 3d fa ff ff       	jmp    801ee7 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  8024aa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024ae:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8024b2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024b6:	eb b7                	jmp    80246f <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  8024b8:	40 84 f6             	test   %sil,%sil
  8024bb:	75 2b                	jne    8024e8 <vprintfmt+0x636>
    switch (lflag) {
  8024bd:	85 d2                	test   %edx,%edx
  8024bf:	74 56                	je     802517 <vprintfmt+0x665>
  8024c1:	83 fa 01             	cmp    $0x1,%edx
  8024c4:	74 7f                	je     802545 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  8024c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024c9:	83 f8 2f             	cmp    $0x2f,%eax
  8024cc:	0f 87 a2 00 00 00    	ja     802574 <vprintfmt+0x6c2>
  8024d2:	89 c2                	mov    %eax,%edx
  8024d4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024d8:	83 c0 08             	add    $0x8,%eax
  8024db:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024de:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024e1:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8024e6:	eb 8f                	jmp    802477 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8024e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024eb:	83 f8 2f             	cmp    $0x2f,%eax
  8024ee:	77 19                	ja     802509 <vprintfmt+0x657>
  8024f0:	89 c2                	mov    %eax,%edx
  8024f2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024f6:	83 c0 08             	add    $0x8,%eax
  8024f9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024fc:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024ff:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802504:	e9 6e ff ff ff       	jmp    802477 <vprintfmt+0x5c5>
  802509:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80250d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802511:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802515:	eb e5                	jmp    8024fc <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  802517:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80251a:	83 f8 2f             	cmp    $0x2f,%eax
  80251d:	77 18                	ja     802537 <vprintfmt+0x685>
  80251f:	89 c2                	mov    %eax,%edx
  802521:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802525:	83 c0 08             	add    $0x8,%eax
  802528:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80252b:	8b 12                	mov    (%rdx),%edx
            base = 16;
  80252d:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  802532:	e9 40 ff ff ff       	jmp    802477 <vprintfmt+0x5c5>
  802537:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80253b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80253f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802543:	eb e6                	jmp    80252b <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  802545:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802548:	83 f8 2f             	cmp    $0x2f,%eax
  80254b:	77 19                	ja     802566 <vprintfmt+0x6b4>
  80254d:	89 c2                	mov    %eax,%edx
  80254f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802553:	83 c0 08             	add    $0x8,%eax
  802556:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802559:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80255c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  802561:	e9 11 ff ff ff       	jmp    802477 <vprintfmt+0x5c5>
  802566:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80256a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80256e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802572:	eb e5                	jmp    802559 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  802574:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802578:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80257c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802580:	e9 59 ff ff ff       	jmp    8024de <vprintfmt+0x62c>
            putch(ch, put_arg);
  802585:	4c 89 ee             	mov    %r13,%rsi
  802588:	bf 25 00 00 00       	mov    $0x25,%edi
  80258d:	41 ff d6             	call   *%r14
            break;
  802590:	e9 52 f9 ff ff       	jmp    801ee7 <vprintfmt+0x35>
            putch('%', put_arg);
  802595:	4c 89 ee             	mov    %r13,%rsi
  802598:	bf 25 00 00 00       	mov    $0x25,%edi
  80259d:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  8025a0:	48 83 eb 01          	sub    $0x1,%rbx
  8025a4:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  8025a8:	75 f6                	jne    8025a0 <vprintfmt+0x6ee>
  8025aa:	e9 38 f9 ff ff       	jmp    801ee7 <vprintfmt+0x35>
}
  8025af:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8025b3:	5b                   	pop    %rbx
  8025b4:	41 5c                	pop    %r12
  8025b6:	41 5d                	pop    %r13
  8025b8:	41 5e                	pop    %r14
  8025ba:	41 5f                	pop    %r15
  8025bc:	5d                   	pop    %rbp
  8025bd:	c3                   	ret

00000000008025be <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  8025be:	f3 0f 1e fa          	endbr64
  8025c2:	55                   	push   %rbp
  8025c3:	48 89 e5             	mov    %rsp,%rbp
  8025c6:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  8025ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025ce:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  8025d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8025d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8025de:	48 85 ff             	test   %rdi,%rdi
  8025e1:	74 2b                	je     80260e <vsnprintf+0x50>
  8025e3:	48 85 f6             	test   %rsi,%rsi
  8025e6:	74 26                	je     80260e <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8025e8:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8025ec:	48 bf 55 1e 80 00 00 	movabs $0x801e55,%rdi
  8025f3:	00 00 00 
  8025f6:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  8025fd:	00 00 00 
  802600:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  802602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802606:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  802609:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80260c:	c9                   	leave
  80260d:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  80260e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802613:	eb f7                	jmp    80260c <vsnprintf+0x4e>

0000000000802615 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  802615:	f3 0f 1e fa          	endbr64
  802619:	55                   	push   %rbp
  80261a:	48 89 e5             	mov    %rsp,%rbp
  80261d:	48 83 ec 50          	sub    $0x50,%rsp
  802621:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802625:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802629:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80262d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  802634:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802638:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80263c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802640:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  802644:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  802648:	48 b8 be 25 80 00 00 	movabs $0x8025be,%rax
  80264f:	00 00 00 
  802652:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  802654:	c9                   	leave
  802655:	c3                   	ret

0000000000802656 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  802656:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  80265a:	80 3f 00             	cmpb   $0x0,(%rdi)
  80265d:	74 10                	je     80266f <strlen+0x19>
    size_t n = 0;
  80265f:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  802664:	48 83 c0 01          	add    $0x1,%rax
  802668:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  80266c:	75 f6                	jne    802664 <strlen+0xe>
  80266e:	c3                   	ret
    size_t n = 0;
  80266f:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  802674:	c3                   	ret

0000000000802675 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  802675:	f3 0f 1e fa          	endbr64
  802679:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  80267c:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  802681:	48 85 f6             	test   %rsi,%rsi
  802684:	74 10                	je     802696 <strnlen+0x21>
  802686:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  80268a:	74 0b                	je     802697 <strnlen+0x22>
  80268c:	48 83 c2 01          	add    $0x1,%rdx
  802690:	48 39 d0             	cmp    %rdx,%rax
  802693:	75 f1                	jne    802686 <strnlen+0x11>
  802695:	c3                   	ret
  802696:	c3                   	ret
  802697:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  80269a:	c3                   	ret

000000000080269b <strcpy>:

char *
strcpy(char *dst, const char *src) {
  80269b:	f3 0f 1e fa          	endbr64
  80269f:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8026a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a7:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  8026ab:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  8026ae:	48 83 c2 01          	add    $0x1,%rdx
  8026b2:	84 c9                	test   %cl,%cl
  8026b4:	75 f1                	jne    8026a7 <strcpy+0xc>
        ;
    return res;
}
  8026b6:	c3                   	ret

00000000008026b7 <strcat>:

char *
strcat(char *dst, const char *src) {
  8026b7:	f3 0f 1e fa          	endbr64
  8026bb:	55                   	push   %rbp
  8026bc:	48 89 e5             	mov    %rsp,%rbp
  8026bf:	41 54                	push   %r12
  8026c1:	53                   	push   %rbx
  8026c2:	48 89 fb             	mov    %rdi,%rbx
  8026c5:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8026c8:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  8026cf:	00 00 00 
  8026d2:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  8026d4:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8026d8:	4c 89 e6             	mov    %r12,%rsi
  8026db:	48 b8 9b 26 80 00 00 	movabs $0x80269b,%rax
  8026e2:	00 00 00 
  8026e5:	ff d0                	call   *%rax
    return dst;
}
  8026e7:	48 89 d8             	mov    %rbx,%rax
  8026ea:	5b                   	pop    %rbx
  8026eb:	41 5c                	pop    %r12
  8026ed:	5d                   	pop    %rbp
  8026ee:	c3                   	ret

00000000008026ef <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8026ef:	f3 0f 1e fa          	endbr64
  8026f3:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  8026f6:	48 85 d2             	test   %rdx,%rdx
  8026f9:	74 1f                	je     80271a <strncpy+0x2b>
  8026fb:	48 01 fa             	add    %rdi,%rdx
  8026fe:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  802701:	48 83 c1 01          	add    $0x1,%rcx
  802705:	44 0f b6 06          	movzbl (%rsi),%r8d
  802709:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  80270d:	41 80 f8 01          	cmp    $0x1,%r8b
  802711:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  802715:	48 39 ca             	cmp    %rcx,%rdx
  802718:	75 e7                	jne    802701 <strncpy+0x12>
    }
    return ret;
}
  80271a:	c3                   	ret

000000000080271b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  80271b:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  80271f:	48 89 f8             	mov    %rdi,%rax
  802722:	48 85 d2             	test   %rdx,%rdx
  802725:	74 24                	je     80274b <strlcpy+0x30>
        while (--size > 0 && *src)
  802727:	48 83 ea 01          	sub    $0x1,%rdx
  80272b:	74 1b                	je     802748 <strlcpy+0x2d>
  80272d:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802731:	0f b6 16             	movzbl (%rsi),%edx
  802734:	84 d2                	test   %dl,%dl
  802736:	74 10                	je     802748 <strlcpy+0x2d>
            *dst++ = *src++;
  802738:	48 83 c6 01          	add    $0x1,%rsi
  80273c:	48 83 c0 01          	add    $0x1,%rax
  802740:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  802743:	48 39 c8             	cmp    %rcx,%rax
  802746:	75 e9                	jne    802731 <strlcpy+0x16>
        *dst = '\0';
  802748:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  80274b:	48 29 f8             	sub    %rdi,%rax
}
  80274e:	c3                   	ret

000000000080274f <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  80274f:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  802753:	0f b6 07             	movzbl (%rdi),%eax
  802756:	84 c0                	test   %al,%al
  802758:	74 13                	je     80276d <strcmp+0x1e>
  80275a:	38 06                	cmp    %al,(%rsi)
  80275c:	75 0f                	jne    80276d <strcmp+0x1e>
  80275e:	48 83 c7 01          	add    $0x1,%rdi
  802762:	48 83 c6 01          	add    $0x1,%rsi
  802766:	0f b6 07             	movzbl (%rdi),%eax
  802769:	84 c0                	test   %al,%al
  80276b:	75 ed                	jne    80275a <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  80276d:	0f b6 c0             	movzbl %al,%eax
  802770:	0f b6 16             	movzbl (%rsi),%edx
  802773:	29 d0                	sub    %edx,%eax
}
  802775:	c3                   	ret

0000000000802776 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  802776:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  80277a:	48 85 d2             	test   %rdx,%rdx
  80277d:	74 1f                	je     80279e <strncmp+0x28>
  80277f:	0f b6 07             	movzbl (%rdi),%eax
  802782:	84 c0                	test   %al,%al
  802784:	74 1e                	je     8027a4 <strncmp+0x2e>
  802786:	3a 06                	cmp    (%rsi),%al
  802788:	75 1a                	jne    8027a4 <strncmp+0x2e>
  80278a:	48 83 c7 01          	add    $0x1,%rdi
  80278e:	48 83 c6 01          	add    $0x1,%rsi
  802792:	48 83 ea 01          	sub    $0x1,%rdx
  802796:	75 e7                	jne    80277f <strncmp+0x9>

    if (!n) return 0;
  802798:	b8 00 00 00 00       	mov    $0x0,%eax
  80279d:	c3                   	ret
  80279e:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a3:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  8027a4:	0f b6 07             	movzbl (%rdi),%eax
  8027a7:	0f b6 16             	movzbl (%rsi),%edx
  8027aa:	29 d0                	sub    %edx,%eax
}
  8027ac:	c3                   	ret

00000000008027ad <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  8027ad:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  8027b1:	0f b6 17             	movzbl (%rdi),%edx
  8027b4:	84 d2                	test   %dl,%dl
  8027b6:	74 18                	je     8027d0 <strchr+0x23>
        if (*str == c) {
  8027b8:	0f be d2             	movsbl %dl,%edx
  8027bb:	39 f2                	cmp    %esi,%edx
  8027bd:	74 17                	je     8027d6 <strchr+0x29>
    for (; *str; str++) {
  8027bf:	48 83 c7 01          	add    $0x1,%rdi
  8027c3:	0f b6 17             	movzbl (%rdi),%edx
  8027c6:	84 d2                	test   %dl,%dl
  8027c8:	75 ee                	jne    8027b8 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  8027ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cf:	c3                   	ret
  8027d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d5:	c3                   	ret
            return (char *)str;
  8027d6:	48 89 f8             	mov    %rdi,%rax
}
  8027d9:	c3                   	ret

00000000008027da <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  8027da:	f3 0f 1e fa          	endbr64
  8027de:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  8027e1:	0f b6 17             	movzbl (%rdi),%edx
  8027e4:	84 d2                	test   %dl,%dl
  8027e6:	74 13                	je     8027fb <strfind+0x21>
  8027e8:	0f be d2             	movsbl %dl,%edx
  8027eb:	39 f2                	cmp    %esi,%edx
  8027ed:	74 0b                	je     8027fa <strfind+0x20>
  8027ef:	48 83 c0 01          	add    $0x1,%rax
  8027f3:	0f b6 10             	movzbl (%rax),%edx
  8027f6:	84 d2                	test   %dl,%dl
  8027f8:	75 ee                	jne    8027e8 <strfind+0xe>
        ;
    return (char *)str;
}
  8027fa:	c3                   	ret
  8027fb:	c3                   	ret

00000000008027fc <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8027fc:	f3 0f 1e fa          	endbr64
  802800:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  802803:	48 89 f8             	mov    %rdi,%rax
  802806:	48 f7 d8             	neg    %rax
  802809:	83 e0 07             	and    $0x7,%eax
  80280c:	49 89 d1             	mov    %rdx,%r9
  80280f:	49 29 c1             	sub    %rax,%r9
  802812:	78 36                	js     80284a <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  802814:	40 0f b6 c6          	movzbl %sil,%eax
  802818:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  80281f:	01 01 01 
  802822:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  802826:	40 f6 c7 07          	test   $0x7,%dil
  80282a:	75 38                	jne    802864 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80282c:	4c 89 c9             	mov    %r9,%rcx
  80282f:	48 c1 f9 03          	sar    $0x3,%rcx
  802833:	74 0c                	je     802841 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  802835:	fc                   	cld
  802836:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802839:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  80283d:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  802841:	4d 85 c9             	test   %r9,%r9
  802844:	75 45                	jne    80288b <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  802846:	4c 89 c0             	mov    %r8,%rax
  802849:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  80284a:	48 85 d2             	test   %rdx,%rdx
  80284d:	74 f7                	je     802846 <memset+0x4a>
  80284f:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  802852:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  802855:	48 83 c0 01          	add    $0x1,%rax
  802859:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  80285d:	48 39 c2             	cmp    %rax,%rdx
  802860:	75 f3                	jne    802855 <memset+0x59>
  802862:	eb e2                	jmp    802846 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  802864:	40 f6 c7 01          	test   $0x1,%dil
  802868:	74 06                	je     802870 <memset+0x74>
  80286a:	88 07                	mov    %al,(%rdi)
  80286c:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  802870:	40 f6 c7 02          	test   $0x2,%dil
  802874:	74 07                	je     80287d <memset+0x81>
  802876:	66 89 07             	mov    %ax,(%rdi)
  802879:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  80287d:	40 f6 c7 04          	test   $0x4,%dil
  802881:	74 a9                	je     80282c <memset+0x30>
  802883:	89 07                	mov    %eax,(%rdi)
  802885:	48 83 c7 04          	add    $0x4,%rdi
  802889:	eb a1                	jmp    80282c <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  80288b:	41 f6 c1 04          	test   $0x4,%r9b
  80288f:	74 1b                	je     8028ac <memset+0xb0>
  802891:	89 07                	mov    %eax,(%rdi)
  802893:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  802897:	41 f6 c1 02          	test   $0x2,%r9b
  80289b:	74 07                	je     8028a4 <memset+0xa8>
  80289d:	66 89 07             	mov    %ax,(%rdi)
  8028a0:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8028a4:	41 f6 c1 01          	test   $0x1,%r9b
  8028a8:	74 9c                	je     802846 <memset+0x4a>
  8028aa:	eb 06                	jmp    8028b2 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8028ac:	41 f6 c1 02          	test   $0x2,%r9b
  8028b0:	75 eb                	jne    80289d <memset+0xa1>
        if (ni & 1) *ptr = k;
  8028b2:	88 07                	mov    %al,(%rdi)
  8028b4:	eb 90                	jmp    802846 <memset+0x4a>

00000000008028b6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8028b6:	f3 0f 1e fa          	endbr64
  8028ba:	48 89 f8             	mov    %rdi,%rax
  8028bd:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8028c0:	48 39 fe             	cmp    %rdi,%rsi
  8028c3:	73 3b                	jae    802900 <memmove+0x4a>
  8028c5:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8028c9:	48 39 d7             	cmp    %rdx,%rdi
  8028cc:	73 32                	jae    802900 <memmove+0x4a>
        s += n;
        d += n;
  8028ce:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028d2:	48 89 d6             	mov    %rdx,%rsi
  8028d5:	48 09 fe             	or     %rdi,%rsi
  8028d8:	48 09 ce             	or     %rcx,%rsi
  8028db:	40 f6 c6 07          	test   $0x7,%sil
  8028df:	75 12                	jne    8028f3 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8028e1:	48 83 ef 08          	sub    $0x8,%rdi
  8028e5:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8028e9:	48 c1 e9 03          	shr    $0x3,%rcx
  8028ed:	fd                   	std
  8028ee:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8028f1:	fc                   	cld
  8028f2:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8028f3:	48 83 ef 01          	sub    $0x1,%rdi
  8028f7:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8028fb:	fd                   	std
  8028fc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8028fe:	eb f1                	jmp    8028f1 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802900:	48 89 f2             	mov    %rsi,%rdx
  802903:	48 09 c2             	or     %rax,%rdx
  802906:	48 09 ca             	or     %rcx,%rdx
  802909:	f6 c2 07             	test   $0x7,%dl
  80290c:	75 0c                	jne    80291a <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80290e:	48 c1 e9 03          	shr    $0x3,%rcx
  802912:	48 89 c7             	mov    %rax,%rdi
  802915:	fc                   	cld
  802916:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  802919:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80291a:	48 89 c7             	mov    %rax,%rdi
  80291d:	fc                   	cld
  80291e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  802920:	c3                   	ret

0000000000802921 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  802921:	f3 0f 1e fa          	endbr64
  802925:	55                   	push   %rbp
  802926:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802929:	48 b8 b6 28 80 00 00 	movabs $0x8028b6,%rax
  802930:	00 00 00 
  802933:	ff d0                	call   *%rax
}
  802935:	5d                   	pop    %rbp
  802936:	c3                   	ret

0000000000802937 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  802937:	f3 0f 1e fa          	endbr64
  80293b:	55                   	push   %rbp
  80293c:	48 89 e5             	mov    %rsp,%rbp
  80293f:	41 57                	push   %r15
  802941:	41 56                	push   %r14
  802943:	41 55                	push   %r13
  802945:	41 54                	push   %r12
  802947:	53                   	push   %rbx
  802948:	48 83 ec 08          	sub    $0x8,%rsp
  80294c:	49 89 fe             	mov    %rdi,%r14
  80294f:	49 89 f7             	mov    %rsi,%r15
  802952:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  802955:	48 89 f7             	mov    %rsi,%rdi
  802958:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  80295f:	00 00 00 
  802962:	ff d0                	call   *%rax
  802964:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  802967:	48 89 de             	mov    %rbx,%rsi
  80296a:	4c 89 f7             	mov    %r14,%rdi
  80296d:	48 b8 75 26 80 00 00 	movabs $0x802675,%rax
  802974:	00 00 00 
  802977:	ff d0                	call   *%rax
  802979:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80297c:	48 39 c3             	cmp    %rax,%rbx
  80297f:	74 36                	je     8029b7 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  802981:	48 89 d8             	mov    %rbx,%rax
  802984:	4c 29 e8             	sub    %r13,%rax
  802987:	49 39 c4             	cmp    %rax,%r12
  80298a:	73 31                	jae    8029bd <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  80298c:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  802991:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  802995:	4c 89 fe             	mov    %r15,%rsi
  802998:	48 b8 21 29 80 00 00 	movabs $0x802921,%rax
  80299f:	00 00 00 
  8029a2:	ff d0                	call   *%rax
    return dstlen + srclen;
  8029a4:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8029a8:	48 83 c4 08          	add    $0x8,%rsp
  8029ac:	5b                   	pop    %rbx
  8029ad:	41 5c                	pop    %r12
  8029af:	41 5d                	pop    %r13
  8029b1:	41 5e                	pop    %r14
  8029b3:	41 5f                	pop    %r15
  8029b5:	5d                   	pop    %rbp
  8029b6:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  8029b7:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  8029bb:	eb eb                	jmp    8029a8 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  8029bd:	48 83 eb 01          	sub    $0x1,%rbx
  8029c1:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8029c5:	48 89 da             	mov    %rbx,%rdx
  8029c8:	4c 89 fe             	mov    %r15,%rsi
  8029cb:	48 b8 21 29 80 00 00 	movabs $0x802921,%rax
  8029d2:	00 00 00 
  8029d5:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8029d7:	49 01 de             	add    %rbx,%r14
  8029da:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8029df:	eb c3                	jmp    8029a4 <strlcat+0x6d>

00000000008029e1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8029e1:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8029e5:	48 85 d2             	test   %rdx,%rdx
  8029e8:	74 2d                	je     802a17 <memcmp+0x36>
  8029ea:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8029ef:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8029f3:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8029f8:	44 38 c1             	cmp    %r8b,%cl
  8029fb:	75 0f                	jne    802a0c <memcmp+0x2b>
    while (n-- > 0) {
  8029fd:	48 83 c0 01          	add    $0x1,%rax
  802a01:	48 39 c2             	cmp    %rax,%rdx
  802a04:	75 e9                	jne    8029ef <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  802a06:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0b:	c3                   	ret
            return (int)*s1 - (int)*s2;
  802a0c:	0f b6 c1             	movzbl %cl,%eax
  802a0f:	45 0f b6 c0          	movzbl %r8b,%r8d
  802a13:	44 29 c0             	sub    %r8d,%eax
  802a16:	c3                   	ret
    return 0;
  802a17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a1c:	c3                   	ret

0000000000802a1d <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  802a1d:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  802a21:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802a25:	48 39 c7             	cmp    %rax,%rdi
  802a28:	73 0f                	jae    802a39 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802a2a:	40 38 37             	cmp    %sil,(%rdi)
  802a2d:	74 0e                	je     802a3d <memfind+0x20>
    for (; src < end; src++) {
  802a2f:	48 83 c7 01          	add    $0x1,%rdi
  802a33:	48 39 f8             	cmp    %rdi,%rax
  802a36:	75 f2                	jne    802a2a <memfind+0xd>
  802a38:	c3                   	ret
  802a39:	48 89 f8             	mov    %rdi,%rax
  802a3c:	c3                   	ret
  802a3d:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802a40:	c3                   	ret

0000000000802a41 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802a41:	f3 0f 1e fa          	endbr64
  802a45:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802a48:	0f b6 37             	movzbl (%rdi),%esi
  802a4b:	40 80 fe 20          	cmp    $0x20,%sil
  802a4f:	74 06                	je     802a57 <strtol+0x16>
  802a51:	40 80 fe 09          	cmp    $0x9,%sil
  802a55:	75 13                	jne    802a6a <strtol+0x29>
  802a57:	48 83 c7 01          	add    $0x1,%rdi
  802a5b:	0f b6 37             	movzbl (%rdi),%esi
  802a5e:	40 80 fe 20          	cmp    $0x20,%sil
  802a62:	74 f3                	je     802a57 <strtol+0x16>
  802a64:	40 80 fe 09          	cmp    $0x9,%sil
  802a68:	74 ed                	je     802a57 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802a6a:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802a6d:	83 e0 fd             	and    $0xfffffffd,%eax
  802a70:	3c 01                	cmp    $0x1,%al
  802a72:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a76:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  802a7c:	75 0f                	jne    802a8d <strtol+0x4c>
  802a7e:	80 3f 30             	cmpb   $0x30,(%rdi)
  802a81:	74 14                	je     802a97 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802a83:	85 d2                	test   %edx,%edx
  802a85:	b8 0a 00 00 00       	mov    $0xa,%eax
  802a8a:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  802a8d:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  802a92:	4c 63 ca             	movslq %edx,%r9
  802a95:	eb 36                	jmp    802acd <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a97:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  802a9b:	74 0f                	je     802aac <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  802a9d:	85 d2                	test   %edx,%edx
  802a9f:	75 ec                	jne    802a8d <strtol+0x4c>
        s++;
  802aa1:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  802aa5:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  802aaa:	eb e1                	jmp    802a8d <strtol+0x4c>
        s += 2;
  802aac:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  802ab0:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  802ab5:	eb d6                	jmp    802a8d <strtol+0x4c>
            dig -= '0';
  802ab7:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  802aba:	44 0f b6 c1          	movzbl %cl,%r8d
  802abe:	41 39 d0             	cmp    %edx,%r8d
  802ac1:	7d 21                	jge    802ae4 <strtol+0xa3>
        val = val * base + dig;
  802ac3:	49 0f af c1          	imul   %r9,%rax
  802ac7:	0f b6 c9             	movzbl %cl,%ecx
  802aca:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  802acd:	48 83 c7 01          	add    $0x1,%rdi
  802ad1:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  802ad5:	80 f9 39             	cmp    $0x39,%cl
  802ad8:	76 dd                	jbe    802ab7 <strtol+0x76>
        else if (dig - 'a' < 27)
  802ada:	80 f9 7b             	cmp    $0x7b,%cl
  802add:	77 05                	ja     802ae4 <strtol+0xa3>
            dig -= 'a' - 10;
  802adf:	83 e9 57             	sub    $0x57,%ecx
  802ae2:	eb d6                	jmp    802aba <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  802ae4:	4d 85 d2             	test   %r10,%r10
  802ae7:	74 03                	je     802aec <strtol+0xab>
  802ae9:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802aec:	48 89 c2             	mov    %rax,%rdx
  802aef:	48 f7 da             	neg    %rdx
  802af2:	40 80 fe 2d          	cmp    $0x2d,%sil
  802af6:	48 0f 44 c2          	cmove  %rdx,%rax
}
  802afa:	c3                   	ret

0000000000802afb <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802afb:	f3 0f 1e fa          	endbr64
  802aff:	55                   	push   %rbp
  802b00:	48 89 e5             	mov    %rsp,%rbp
  802b03:	41 54                	push   %r12
  802b05:	53                   	push   %rbx
  802b06:	48 89 fb             	mov    %rdi,%rbx
  802b09:	48 89 f7             	mov    %rsi,%rdi
  802b0c:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b0f:	48 85 f6             	test   %rsi,%rsi
  802b12:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b19:	00 00 00 
  802b1c:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b20:	be 00 10 00 00       	mov    $0x1000,%esi
  802b25:	48 b8 ed 05 80 00 00 	movabs $0x8005ed,%rax
  802b2c:	00 00 00 
  802b2f:	ff d0                	call   *%rax
    if (res < 0) {
  802b31:	85 c0                	test   %eax,%eax
  802b33:	78 45                	js     802b7a <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b35:	48 85 db             	test   %rbx,%rbx
  802b38:	74 12                	je     802b4c <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b3a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b41:	00 00 00 
  802b44:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b4a:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b4c:	4d 85 e4             	test   %r12,%r12
  802b4f:	74 14                	je     802b65 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b51:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b58:	00 00 00 
  802b5b:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b61:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b65:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b6c:	00 00 00 
  802b6f:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b75:	5b                   	pop    %rbx
  802b76:	41 5c                	pop    %r12
  802b78:	5d                   	pop    %rbp
  802b79:	c3                   	ret
        if (from_env_store != NULL) {
  802b7a:	48 85 db             	test   %rbx,%rbx
  802b7d:	74 06                	je     802b85 <ipc_recv+0x8a>
            *from_env_store = 0;
  802b7f:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b85:	4d 85 e4             	test   %r12,%r12
  802b88:	74 eb                	je     802b75 <ipc_recv+0x7a>
            *perm_store = 0;
  802b8a:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b91:	00 
  802b92:	eb e1                	jmp    802b75 <ipc_recv+0x7a>

0000000000802b94 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b94:	f3 0f 1e fa          	endbr64
  802b98:	55                   	push   %rbp
  802b99:	48 89 e5             	mov    %rsp,%rbp
  802b9c:	41 57                	push   %r15
  802b9e:	41 56                	push   %r14
  802ba0:	41 55                	push   %r13
  802ba2:	41 54                	push   %r12
  802ba4:	53                   	push   %rbx
  802ba5:	48 83 ec 18          	sub    $0x18,%rsp
  802ba9:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802bac:	48 89 d3             	mov    %rdx,%rbx
  802baf:	49 89 cc             	mov    %rcx,%r12
  802bb2:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802bb5:	48 85 d2             	test   %rdx,%rdx
  802bb8:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bbf:	00 00 00 
  802bc2:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bc6:	89 f0                	mov    %esi,%eax
  802bc8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802bcc:	48 89 da             	mov    %rbx,%rdx
  802bcf:	48 89 c6             	mov    %rax,%rsi
  802bd2:	48 b8 bd 05 80 00 00 	movabs $0x8005bd,%rax
  802bd9:	00 00 00 
  802bdc:	ff d0                	call   *%rax
    while (res < 0) {
  802bde:	85 c0                	test   %eax,%eax
  802be0:	79 65                	jns    802c47 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802be2:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802be5:	75 33                	jne    802c1a <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802be7:	49 bf 30 02 80 00 00 	movabs $0x800230,%r15
  802bee:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bf1:	49 be bd 05 80 00 00 	movabs $0x8005bd,%r14
  802bf8:	00 00 00 
        sys_yield();
  802bfb:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bfe:	45 89 e8             	mov    %r13d,%r8d
  802c01:	4c 89 e1             	mov    %r12,%rcx
  802c04:	48 89 da             	mov    %rbx,%rdx
  802c07:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802c0b:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802c0e:	41 ff d6             	call   *%r14
    while (res < 0) {
  802c11:	85 c0                	test   %eax,%eax
  802c13:	79 32                	jns    802c47 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c15:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c18:	74 e1                	je     802bfb <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c1a:	89 c1                	mov    %eax,%ecx
  802c1c:	48 ba 4e 32 80 00 00 	movabs $0x80324e,%rdx
  802c23:	00 00 00 
  802c26:	be 42 00 00 00       	mov    $0x42,%esi
  802c2b:	48 bf 59 32 80 00 00 	movabs $0x803259,%rdi
  802c32:	00 00 00 
  802c35:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3a:	49 b8 f6 1b 80 00 00 	movabs $0x801bf6,%r8
  802c41:	00 00 00 
  802c44:	41 ff d0             	call   *%r8
    }
}
  802c47:	48 83 c4 18          	add    $0x18,%rsp
  802c4b:	5b                   	pop    %rbx
  802c4c:	41 5c                	pop    %r12
  802c4e:	41 5d                	pop    %r13
  802c50:	41 5e                	pop    %r14
  802c52:	41 5f                	pop    %r15
  802c54:	5d                   	pop    %rbp
  802c55:	c3                   	ret

0000000000802c56 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c56:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c5a:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c5f:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c66:	00 00 00 
  802c69:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c6d:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c71:	48 c1 e2 04          	shl    $0x4,%rdx
  802c75:	48 01 ca             	add    %rcx,%rdx
  802c78:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c7e:	39 fa                	cmp    %edi,%edx
  802c80:	74 12                	je     802c94 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c82:	48 83 c0 01          	add    $0x1,%rax
  802c86:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c8c:	75 db                	jne    802c69 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802c8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c93:	c3                   	ret
            return envs[i].env_id;
  802c94:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c98:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c9c:	48 c1 e2 04          	shl    $0x4,%rdx
  802ca0:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802ca7:	00 00 00 
  802caa:	48 01 d0             	add    %rdx,%rax
  802cad:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cb3:	c3                   	ret

0000000000802cb4 <__text_end>:
  802cb4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cbb:	00 00 00 
  802cbe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cc5:	00 00 00 
  802cc8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ccf:	00 00 00 
  802cd2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cd9:	00 00 00 
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
