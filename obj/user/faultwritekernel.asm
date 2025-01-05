
obj/user/faultwritekernel:     file format elf64-x86-64


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
  80001e:	e8 17 00 00 00       	call   80003a <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* Buggy program - faults with a write to a kernel location */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
    *(volatile unsigned *)0x8040000000 = 0;
  800029:	48 b8 00 00 00 40 80 	movabs $0x8040000000,%rax
  800030:	00 00 00 
  800033:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  800039:	c3                   	ret

000000000080003a <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80003a:	f3 0f 1e fa          	endbr64
  80003e:	55                   	push   %rbp
  80003f:	48 89 e5             	mov    %rsp,%rbp
  800042:	41 56                	push   %r14
  800044:	41 55                	push   %r13
  800046:	41 54                	push   %r12
  800048:	53                   	push   %rbx
  800049:	41 89 fd             	mov    %edi,%r13d
  80004c:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80004f:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800056:	00 00 00 
  800059:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800060:	00 00 00 
  800063:	48 39 c2             	cmp    %rax,%rdx
  800066:	73 17                	jae    80007f <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800068:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80006b:	49 89 c4             	mov    %rax,%r12
  80006e:	48 83 c3 08          	add    $0x8,%rbx
  800072:	b8 00 00 00 00       	mov    $0x0,%eax
  800077:	ff 53 f8             	call   *-0x8(%rbx)
  80007a:	4c 39 e3             	cmp    %r12,%rbx
  80007d:	72 ef                	jb     80006e <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  80007f:	48 b8 e8 01 80 00 00 	movabs $0x8001e8,%rax
  800086:	00 00 00 
  800089:	ff d0                	call   *%rax
  80008b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800090:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800094:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800098:	48 c1 e0 04          	shl    $0x4,%rax
  80009c:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000a3:	00 00 00 
  8000a6:	48 01 d0             	add    %rdx,%rax
  8000a9:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000b0:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000b3:	45 85 ed             	test   %r13d,%r13d
  8000b6:	7e 0d                	jle    8000c5 <libmain+0x8b>
  8000b8:	49 8b 06             	mov    (%r14),%rax
  8000bb:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000c2:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000c5:	4c 89 f6             	mov    %r14,%rsi
  8000c8:	44 89 ef             	mov    %r13d,%edi
  8000cb:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000d2:	00 00 00 
  8000d5:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000d7:	48 b8 ec 00 80 00 00 	movabs $0x8000ec,%rax
  8000de:	00 00 00 
  8000e1:	ff d0                	call   *%rax
#endif
}
  8000e3:	5b                   	pop    %rbx
  8000e4:	41 5c                	pop    %r12
  8000e6:	41 5d                	pop    %r13
  8000e8:	41 5e                	pop    %r14
  8000ea:	5d                   	pop    %rbp
  8000eb:	c3                   	ret

00000000008000ec <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000ec:	f3 0f 1e fa          	endbr64
  8000f0:	55                   	push   %rbp
  8000f1:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000f4:	48 b8 be 08 80 00 00 	movabs $0x8008be,%rax
  8000fb:	00 00 00 
  8000fe:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800100:	bf 00 00 00 00       	mov    $0x0,%edi
  800105:	48 b8 79 01 80 00 00 	movabs $0x800179,%rax
  80010c:	00 00 00 
  80010f:	ff d0                	call   *%rax
}
  800111:	5d                   	pop    %rbp
  800112:	c3                   	ret

0000000000800113 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800113:	f3 0f 1e fa          	endbr64
  800117:	55                   	push   %rbp
  800118:	48 89 e5             	mov    %rsp,%rbp
  80011b:	53                   	push   %rbx
  80011c:	48 89 fa             	mov    %rdi,%rdx
  80011f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800122:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800127:	bb 00 00 00 00       	mov    $0x0,%ebx
  80012c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800131:	be 00 00 00 00       	mov    $0x0,%esi
  800136:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80013c:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80013e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800142:	c9                   	leave
  800143:	c3                   	ret

0000000000800144 <sys_cgetc>:

int
sys_cgetc(void) {
  800144:	f3 0f 1e fa          	endbr64
  800148:	55                   	push   %rbp
  800149:	48 89 e5             	mov    %rsp,%rbp
  80014c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80014d:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800152:	ba 00 00 00 00       	mov    $0x0,%edx
  800157:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80015c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800161:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800166:	be 00 00 00 00       	mov    $0x0,%esi
  80016b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800171:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800173:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800177:	c9                   	leave
  800178:	c3                   	ret

0000000000800179 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800179:	f3 0f 1e fa          	endbr64
  80017d:	55                   	push   %rbp
  80017e:	48 89 e5             	mov    %rsp,%rbp
  800181:	53                   	push   %rbx
  800182:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800186:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800189:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80018e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800193:	bb 00 00 00 00       	mov    $0x0,%ebx
  800198:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80019d:	be 00 00 00 00       	mov    $0x0,%esi
  8001a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001a8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001aa:	48 85 c0             	test   %rax,%rax
  8001ad:	7f 06                	jg     8001b5 <sys_env_destroy+0x3c>
}
  8001af:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001b3:	c9                   	leave
  8001b4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001b5:	49 89 c0             	mov    %rax,%r8
  8001b8:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001bd:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8001c4:	00 00 00 
  8001c7:	be 26 00 00 00       	mov    $0x26,%esi
  8001cc:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8001d3:	00 00 00 
  8001d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001db:	49 b9 e3 1b 80 00 00 	movabs $0x801be3,%r9
  8001e2:	00 00 00 
  8001e5:	41 ff d1             	call   *%r9

00000000008001e8 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001e8:	f3 0f 1e fa          	endbr64
  8001ec:	55                   	push   %rbp
  8001ed:	48 89 e5             	mov    %rsp,%rbp
  8001f0:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001f1:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8001fb:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800200:	bb 00 00 00 00       	mov    $0x0,%ebx
  800205:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80020a:	be 00 00 00 00       	mov    $0x0,%esi
  80020f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800215:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800217:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80021b:	c9                   	leave
  80021c:	c3                   	ret

000000000080021d <sys_yield>:

void
sys_yield(void) {
  80021d:	f3 0f 1e fa          	endbr64
  800221:	55                   	push   %rbp
  800222:	48 89 e5             	mov    %rsp,%rbp
  800225:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800226:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80022b:	ba 00 00 00 00       	mov    $0x0,%edx
  800230:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800235:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80023f:	be 00 00 00 00       	mov    $0x0,%esi
  800244:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80024a:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80024c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800250:	c9                   	leave
  800251:	c3                   	ret

0000000000800252 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  800252:	f3 0f 1e fa          	endbr64
  800256:	55                   	push   %rbp
  800257:	48 89 e5             	mov    %rsp,%rbp
  80025a:	53                   	push   %rbx
  80025b:	48 89 fa             	mov    %rdi,%rdx
  80025e:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800261:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800266:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80026d:	00 00 00 
  800270:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800275:	be 00 00 00 00       	mov    $0x0,%esi
  80027a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800280:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800282:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800286:	c9                   	leave
  800287:	c3                   	ret

0000000000800288 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  800288:	f3 0f 1e fa          	endbr64
  80028c:	55                   	push   %rbp
  80028d:	48 89 e5             	mov    %rsp,%rbp
  800290:	53                   	push   %rbx
  800291:	49 89 f8             	mov    %rdi,%r8
  800294:	48 89 d3             	mov    %rdx,%rbx
  800297:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80029a:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80029f:	4c 89 c2             	mov    %r8,%rdx
  8002a2:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002a5:	be 00 00 00 00       	mov    $0x0,%esi
  8002aa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002b0:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002b2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002b6:	c9                   	leave
  8002b7:	c3                   	ret

00000000008002b8 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002b8:	f3 0f 1e fa          	endbr64
  8002bc:	55                   	push   %rbp
  8002bd:	48 89 e5             	mov    %rsp,%rbp
  8002c0:	53                   	push   %rbx
  8002c1:	48 83 ec 08          	sub    $0x8,%rsp
  8002c5:	89 f8                	mov    %edi,%eax
  8002c7:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002ca:	48 63 f9             	movslq %ecx,%rdi
  8002cd:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002d0:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002d5:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002d8:	be 00 00 00 00       	mov    $0x0,%esi
  8002dd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002e3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002e5:	48 85 c0             	test   %rax,%rax
  8002e8:	7f 06                	jg     8002f0 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002ea:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002ee:	c9                   	leave
  8002ef:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002f0:	49 89 c0             	mov    %rax,%r8
  8002f3:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002f8:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8002ff:	00 00 00 
  800302:	be 26 00 00 00       	mov    $0x26,%esi
  800307:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80030e:	00 00 00 
  800311:	b8 00 00 00 00       	mov    $0x0,%eax
  800316:	49 b9 e3 1b 80 00 00 	movabs $0x801be3,%r9
  80031d:	00 00 00 
  800320:	41 ff d1             	call   *%r9

0000000000800323 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  800323:	f3 0f 1e fa          	endbr64
  800327:	55                   	push   %rbp
  800328:	48 89 e5             	mov    %rsp,%rbp
  80032b:	53                   	push   %rbx
  80032c:	48 83 ec 08          	sub    $0x8,%rsp
  800330:	89 f8                	mov    %edi,%eax
  800332:	49 89 f2             	mov    %rsi,%r10
  800335:	48 89 cf             	mov    %rcx,%rdi
  800338:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80033b:	48 63 da             	movslq %edx,%rbx
  80033e:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800341:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800346:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800349:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80034c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80034e:	48 85 c0             	test   %rax,%rax
  800351:	7f 06                	jg     800359 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  800353:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800357:	c9                   	leave
  800358:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800359:	49 89 c0             	mov    %rax,%r8
  80035c:	b9 05 00 00 00       	mov    $0x5,%ecx
  800361:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800368:	00 00 00 
  80036b:	be 26 00 00 00       	mov    $0x26,%esi
  800370:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800377:	00 00 00 
  80037a:	b8 00 00 00 00       	mov    $0x0,%eax
  80037f:	49 b9 e3 1b 80 00 00 	movabs $0x801be3,%r9
  800386:	00 00 00 
  800389:	41 ff d1             	call   *%r9

000000000080038c <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80038c:	f3 0f 1e fa          	endbr64
  800390:	55                   	push   %rbp
  800391:	48 89 e5             	mov    %rsp,%rbp
  800394:	53                   	push   %rbx
  800395:	48 83 ec 08          	sub    $0x8,%rsp
  800399:	49 89 f9             	mov    %rdi,%r9
  80039c:	89 f0                	mov    %esi,%eax
  80039e:	48 89 d3             	mov    %rdx,%rbx
  8003a1:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8003a4:	49 63 f0             	movslq %r8d,%rsi
  8003a7:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8003aa:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8003af:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003b8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003ba:	48 85 c0             	test   %rax,%rax
  8003bd:	7f 06                	jg     8003c5 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8003bf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003c3:	c9                   	leave
  8003c4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003c5:	49 89 c0             	mov    %rax,%r8
  8003c8:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003cd:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8003d4:	00 00 00 
  8003d7:	be 26 00 00 00       	mov    $0x26,%esi
  8003dc:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8003e3:	00 00 00 
  8003e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003eb:	49 b9 e3 1b 80 00 00 	movabs $0x801be3,%r9
  8003f2:	00 00 00 
  8003f5:	41 ff d1             	call   *%r9

00000000008003f8 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8003f8:	f3 0f 1e fa          	endbr64
  8003fc:	55                   	push   %rbp
  8003fd:	48 89 e5             	mov    %rsp,%rbp
  800400:	53                   	push   %rbx
  800401:	48 83 ec 08          	sub    $0x8,%rsp
  800405:	48 89 f1             	mov    %rsi,%rcx
  800408:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80040b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80040e:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800413:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800418:	be 00 00 00 00       	mov    $0x0,%esi
  80041d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800423:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800425:	48 85 c0             	test   %rax,%rax
  800428:	7f 06                	jg     800430 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80042a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80042e:	c9                   	leave
  80042f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800430:	49 89 c0             	mov    %rax,%r8
  800433:	b9 07 00 00 00       	mov    $0x7,%ecx
  800438:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80043f:	00 00 00 
  800442:	be 26 00 00 00       	mov    $0x26,%esi
  800447:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80044e:	00 00 00 
  800451:	b8 00 00 00 00       	mov    $0x0,%eax
  800456:	49 b9 e3 1b 80 00 00 	movabs $0x801be3,%r9
  80045d:	00 00 00 
  800460:	41 ff d1             	call   *%r9

0000000000800463 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  800463:	f3 0f 1e fa          	endbr64
  800467:	55                   	push   %rbp
  800468:	48 89 e5             	mov    %rsp,%rbp
  80046b:	53                   	push   %rbx
  80046c:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  800470:	48 63 ce             	movslq %esi,%rcx
  800473:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800476:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80047b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800480:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800485:	be 00 00 00 00       	mov    $0x0,%esi
  80048a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800490:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800492:	48 85 c0             	test   %rax,%rax
  800495:	7f 06                	jg     80049d <sys_env_set_status+0x3a>
}
  800497:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80049b:	c9                   	leave
  80049c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80049d:	49 89 c0             	mov    %rax,%r8
  8004a0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8004a5:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8004ac:	00 00 00 
  8004af:	be 26 00 00 00       	mov    $0x26,%esi
  8004b4:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8004bb:	00 00 00 
  8004be:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c3:	49 b9 e3 1b 80 00 00 	movabs $0x801be3,%r9
  8004ca:	00 00 00 
  8004cd:	41 ff d1             	call   *%r9

00000000008004d0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8004d0:	f3 0f 1e fa          	endbr64
  8004d4:	55                   	push   %rbp
  8004d5:	48 89 e5             	mov    %rsp,%rbp
  8004d8:	53                   	push   %rbx
  8004d9:	48 83 ec 08          	sub    $0x8,%rsp
  8004dd:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8004e0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004e3:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004ed:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004f2:	be 00 00 00 00       	mov    $0x0,%esi
  8004f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004fd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004ff:	48 85 c0             	test   %rax,%rax
  800502:	7f 06                	jg     80050a <sys_env_set_trapframe+0x3a>
}
  800504:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800508:	c9                   	leave
  800509:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80050a:	49 89 c0             	mov    %rax,%r8
  80050d:	b9 0b 00 00 00       	mov    $0xb,%ecx
  800512:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800519:	00 00 00 
  80051c:	be 26 00 00 00       	mov    $0x26,%esi
  800521:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800528:	00 00 00 
  80052b:	b8 00 00 00 00       	mov    $0x0,%eax
  800530:	49 b9 e3 1b 80 00 00 	movabs $0x801be3,%r9
  800537:	00 00 00 
  80053a:	41 ff d1             	call   *%r9

000000000080053d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80053d:	f3 0f 1e fa          	endbr64
  800541:	55                   	push   %rbp
  800542:	48 89 e5             	mov    %rsp,%rbp
  800545:	53                   	push   %rbx
  800546:	48 83 ec 08          	sub    $0x8,%rsp
  80054a:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80054d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800550:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800555:	bb 00 00 00 00       	mov    $0x0,%ebx
  80055a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80055f:	be 00 00 00 00       	mov    $0x0,%esi
  800564:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80056a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80056c:	48 85 c0             	test   %rax,%rax
  80056f:	7f 06                	jg     800577 <sys_env_set_pgfault_upcall+0x3a>
}
  800571:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800575:	c9                   	leave
  800576:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800577:	49 89 c0             	mov    %rax,%r8
  80057a:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80057f:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800586:	00 00 00 
  800589:	be 26 00 00 00       	mov    $0x26,%esi
  80058e:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800595:	00 00 00 
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
  80059d:	49 b9 e3 1b 80 00 00 	movabs $0x801be3,%r9
  8005a4:	00 00 00 
  8005a7:	41 ff d1             	call   *%r9

00000000008005aa <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8005aa:	f3 0f 1e fa          	endbr64
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	53                   	push   %rbx
  8005b3:	89 f8                	mov    %edi,%eax
  8005b5:	49 89 f1             	mov    %rsi,%r9
  8005b8:	48 89 d3             	mov    %rdx,%rbx
  8005bb:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8005be:	49 63 f0             	movslq %r8d,%rsi
  8005c1:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8005c4:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005c9:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005d2:	cd 30                	int    $0x30
}
  8005d4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005d8:	c9                   	leave
  8005d9:	c3                   	ret

00000000008005da <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8005da:	f3 0f 1e fa          	endbr64
  8005de:	55                   	push   %rbp
  8005df:	48 89 e5             	mov    %rsp,%rbp
  8005e2:	53                   	push   %rbx
  8005e3:	48 83 ec 08          	sub    $0x8,%rsp
  8005e7:	48 89 fa             	mov    %rdi,%rdx
  8005ea:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8005ed:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005fc:	be 00 00 00 00       	mov    $0x0,%esi
  800601:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800607:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800609:	48 85 c0             	test   %rax,%rax
  80060c:	7f 06                	jg     800614 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80060e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800612:	c9                   	leave
  800613:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800614:	49 89 c0             	mov    %rax,%r8
  800617:	b9 0f 00 00 00       	mov    $0xf,%ecx
  80061c:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800623:	00 00 00 
  800626:	be 26 00 00 00       	mov    $0x26,%esi
  80062b:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800632:	00 00 00 
  800635:	b8 00 00 00 00       	mov    $0x0,%eax
  80063a:	49 b9 e3 1b 80 00 00 	movabs $0x801be3,%r9
  800641:	00 00 00 
  800644:	41 ff d1             	call   *%r9

0000000000800647 <sys_gettime>:

int
sys_gettime(void) {
  800647:	f3 0f 1e fa          	endbr64
  80064b:	55                   	push   %rbp
  80064c:	48 89 e5             	mov    %rsp,%rbp
  80064f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800650:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800655:	ba 00 00 00 00       	mov    $0x0,%edx
  80065a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80065f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800664:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800669:	be 00 00 00 00       	mov    $0x0,%esi
  80066e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800674:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  800676:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80067a:	c9                   	leave
  80067b:	c3                   	ret

000000000080067c <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  80067c:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800680:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800687:	ff ff ff 
  80068a:	48 01 f8             	add    %rdi,%rax
  80068d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800691:	c3                   	ret

0000000000800692 <fd2data>:

char *
fd2data(struct Fd *fd) {
  800692:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800696:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80069d:	ff ff ff 
  8006a0:	48 01 f8             	add    %rdi,%rax
  8006a3:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8006a7:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8006ad:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006b1:	c3                   	ret

00000000008006b2 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8006b2:	f3 0f 1e fa          	endbr64
  8006b6:	55                   	push   %rbp
  8006b7:	48 89 e5             	mov    %rsp,%rbp
  8006ba:	41 57                	push   %r15
  8006bc:	41 56                	push   %r14
  8006be:	41 55                	push   %r13
  8006c0:	41 54                	push   %r12
  8006c2:	53                   	push   %rbx
  8006c3:	48 83 ec 08          	sub    $0x8,%rsp
  8006c7:	49 89 ff             	mov    %rdi,%r15
  8006ca:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8006cf:	49 bd 11 18 80 00 00 	movabs $0x801811,%r13
  8006d6:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8006d9:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8006df:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8006e2:	48 89 df             	mov    %rbx,%rdi
  8006e5:	41 ff d5             	call   *%r13
  8006e8:	83 e0 04             	and    $0x4,%eax
  8006eb:	74 17                	je     800704 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8006ed:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8006f4:	4c 39 f3             	cmp    %r14,%rbx
  8006f7:	75 e6                	jne    8006df <fd_alloc+0x2d>
  8006f9:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8006ff:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  800704:	4d 89 27             	mov    %r12,(%r15)
}
  800707:	48 83 c4 08          	add    $0x8,%rsp
  80070b:	5b                   	pop    %rbx
  80070c:	41 5c                	pop    %r12
  80070e:	41 5d                	pop    %r13
  800710:	41 5e                	pop    %r14
  800712:	41 5f                	pop    %r15
  800714:	5d                   	pop    %rbp
  800715:	c3                   	ret

0000000000800716 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  800716:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  80071a:	83 ff 1f             	cmp    $0x1f,%edi
  80071d:	77 39                	ja     800758 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80071f:	55                   	push   %rbp
  800720:	48 89 e5             	mov    %rsp,%rbp
  800723:	41 54                	push   %r12
  800725:	53                   	push   %rbx
  800726:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  800729:	48 63 df             	movslq %edi,%rbx
  80072c:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  800733:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800737:	48 89 df             	mov    %rbx,%rdi
  80073a:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  800741:	00 00 00 
  800744:	ff d0                	call   *%rax
  800746:	a8 04                	test   $0x4,%al
  800748:	74 14                	je     80075e <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80074a:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80074e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800753:	5b                   	pop    %rbx
  800754:	41 5c                	pop    %r12
  800756:	5d                   	pop    %rbp
  800757:	c3                   	ret
        return -E_INVAL;
  800758:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80075d:	c3                   	ret
        return -E_INVAL;
  80075e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800763:	eb ee                	jmp    800753 <fd_lookup+0x3d>

0000000000800765 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  800765:	f3 0f 1e fa          	endbr64
  800769:	55                   	push   %rbp
  80076a:	48 89 e5             	mov    %rsp,%rbp
  80076d:	41 54                	push   %r12
  80076f:	53                   	push   %rbx
  800770:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  800773:	48 b8 40 33 80 00 00 	movabs $0x803340,%rax
  80077a:	00 00 00 
  80077d:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  800784:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  800787:	39 3b                	cmp    %edi,(%rbx)
  800789:	74 47                	je     8007d2 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  80078b:	48 83 c0 08          	add    $0x8,%rax
  80078f:	48 8b 18             	mov    (%rax),%rbx
  800792:	48 85 db             	test   %rbx,%rbx
  800795:	75 f0                	jne    800787 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800797:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80079e:	00 00 00 
  8007a1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8007a7:	89 fa                	mov    %edi,%edx
  8007a9:	48 bf 78 32 80 00 00 	movabs $0x803278,%rdi
  8007b0:	00 00 00 
  8007b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b8:	48 b9 3f 1d 80 00 00 	movabs $0x801d3f,%rcx
  8007bf:	00 00 00 
  8007c2:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8007c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8007c9:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8007cd:	5b                   	pop    %rbx
  8007ce:	41 5c                	pop    %r12
  8007d0:	5d                   	pop    %rbp
  8007d1:	c3                   	ret
            return 0;
  8007d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d7:	eb f0                	jmp    8007c9 <dev_lookup+0x64>

00000000008007d9 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8007d9:	f3 0f 1e fa          	endbr64
  8007dd:	55                   	push   %rbp
  8007de:	48 89 e5             	mov    %rsp,%rbp
  8007e1:	41 55                	push   %r13
  8007e3:	41 54                	push   %r12
  8007e5:	53                   	push   %rbx
  8007e6:	48 83 ec 18          	sub    $0x18,%rsp
  8007ea:	48 89 fb             	mov    %rdi,%rbx
  8007ed:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8007f0:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8007f7:	ff ff ff 
  8007fa:	48 01 df             	add    %rbx,%rdi
  8007fd:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  800801:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800805:	48 b8 16 07 80 00 00 	movabs $0x800716,%rax
  80080c:	00 00 00 
  80080f:	ff d0                	call   *%rax
  800811:	41 89 c5             	mov    %eax,%r13d
  800814:	85 c0                	test   %eax,%eax
  800816:	78 06                	js     80081e <fd_close+0x45>
  800818:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  80081c:	74 1a                	je     800838 <fd_close+0x5f>
        return (must_exist ? res : 0);
  80081e:	45 84 e4             	test   %r12b,%r12b
  800821:	b8 00 00 00 00       	mov    $0x0,%eax
  800826:	44 0f 44 e8          	cmove  %eax,%r13d
}
  80082a:	44 89 e8             	mov    %r13d,%eax
  80082d:	48 83 c4 18          	add    $0x18,%rsp
  800831:	5b                   	pop    %rbx
  800832:	41 5c                	pop    %r12
  800834:	41 5d                	pop    %r13
  800836:	5d                   	pop    %rbp
  800837:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800838:	8b 3b                	mov    (%rbx),%edi
  80083a:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80083e:	48 b8 65 07 80 00 00 	movabs $0x800765,%rax
  800845:	00 00 00 
  800848:	ff d0                	call   *%rax
  80084a:	41 89 c5             	mov    %eax,%r13d
  80084d:	85 c0                	test   %eax,%eax
  80084f:	78 1b                	js     80086c <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  800851:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800855:	48 8b 40 20          	mov    0x20(%rax),%rax
  800859:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80085f:	48 85 c0             	test   %rax,%rax
  800862:	74 08                	je     80086c <fd_close+0x93>
  800864:	48 89 df             	mov    %rbx,%rdi
  800867:	ff d0                	call   *%rax
  800869:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80086c:	ba 00 10 00 00       	mov    $0x1000,%edx
  800871:	48 89 de             	mov    %rbx,%rsi
  800874:	bf 00 00 00 00       	mov    $0x0,%edi
  800879:	48 b8 f8 03 80 00 00 	movabs $0x8003f8,%rax
  800880:	00 00 00 
  800883:	ff d0                	call   *%rax
    return res;
  800885:	eb a3                	jmp    80082a <fd_close+0x51>

0000000000800887 <close>:

int
close(int fdnum) {
  800887:	f3 0f 1e fa          	endbr64
  80088b:	55                   	push   %rbp
  80088c:	48 89 e5             	mov    %rsp,%rbp
  80088f:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  800893:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800897:	48 b8 16 07 80 00 00 	movabs $0x800716,%rax
  80089e:	00 00 00 
  8008a1:	ff d0                	call   *%rax
    if (res < 0) return res;
  8008a3:	85 c0                	test   %eax,%eax
  8008a5:	78 15                	js     8008bc <close+0x35>

    return fd_close(fd, 1);
  8008a7:	be 01 00 00 00       	mov    $0x1,%esi
  8008ac:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8008b0:	48 b8 d9 07 80 00 00 	movabs $0x8007d9,%rax
  8008b7:	00 00 00 
  8008ba:	ff d0                	call   *%rax
}
  8008bc:	c9                   	leave
  8008bd:	c3                   	ret

00000000008008be <close_all>:

void
close_all(void) {
  8008be:	f3 0f 1e fa          	endbr64
  8008c2:	55                   	push   %rbp
  8008c3:	48 89 e5             	mov    %rsp,%rbp
  8008c6:	41 54                	push   %r12
  8008c8:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8008c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008ce:	49 bc 87 08 80 00 00 	movabs $0x800887,%r12
  8008d5:	00 00 00 
  8008d8:	89 df                	mov    %ebx,%edi
  8008da:	41 ff d4             	call   *%r12
  8008dd:	83 c3 01             	add    $0x1,%ebx
  8008e0:	83 fb 20             	cmp    $0x20,%ebx
  8008e3:	75 f3                	jne    8008d8 <close_all+0x1a>
}
  8008e5:	5b                   	pop    %rbx
  8008e6:	41 5c                	pop    %r12
  8008e8:	5d                   	pop    %rbp
  8008e9:	c3                   	ret

00000000008008ea <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8008ea:	f3 0f 1e fa          	endbr64
  8008ee:	55                   	push   %rbp
  8008ef:	48 89 e5             	mov    %rsp,%rbp
  8008f2:	41 57                	push   %r15
  8008f4:	41 56                	push   %r14
  8008f6:	41 55                	push   %r13
  8008f8:	41 54                	push   %r12
  8008fa:	53                   	push   %rbx
  8008fb:	48 83 ec 18          	sub    $0x18,%rsp
  8008ff:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  800902:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  800906:	48 b8 16 07 80 00 00 	movabs $0x800716,%rax
  80090d:	00 00 00 
  800910:	ff d0                	call   *%rax
  800912:	89 c3                	mov    %eax,%ebx
  800914:	85 c0                	test   %eax,%eax
  800916:	0f 88 b8 00 00 00    	js     8009d4 <dup+0xea>
    close(newfdnum);
  80091c:	44 89 e7             	mov    %r12d,%edi
  80091f:	48 b8 87 08 80 00 00 	movabs $0x800887,%rax
  800926:	00 00 00 
  800929:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  80092b:	4d 63 ec             	movslq %r12d,%r13
  80092e:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  800935:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  800939:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  80093d:	4c 89 ff             	mov    %r15,%rdi
  800940:	49 be 92 06 80 00 00 	movabs $0x800692,%r14
  800947:	00 00 00 
  80094a:	41 ff d6             	call   *%r14
  80094d:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  800950:	4c 89 ef             	mov    %r13,%rdi
  800953:	41 ff d6             	call   *%r14
  800956:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  800959:	48 89 df             	mov    %rbx,%rdi
  80095c:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  800963:	00 00 00 
  800966:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  800968:	a8 04                	test   $0x4,%al
  80096a:	74 2b                	je     800997 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  80096c:	41 89 c1             	mov    %eax,%r9d
  80096f:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800975:	4c 89 f1             	mov    %r14,%rcx
  800978:	ba 00 00 00 00       	mov    $0x0,%edx
  80097d:	48 89 de             	mov    %rbx,%rsi
  800980:	bf 00 00 00 00       	mov    $0x0,%edi
  800985:	48 b8 23 03 80 00 00 	movabs $0x800323,%rax
  80098c:	00 00 00 
  80098f:	ff d0                	call   *%rax
  800991:	89 c3                	mov    %eax,%ebx
  800993:	85 c0                	test   %eax,%eax
  800995:	78 4e                	js     8009e5 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  800997:	4c 89 ff             	mov    %r15,%rdi
  80099a:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  8009a1:	00 00 00 
  8009a4:	ff d0                	call   *%rax
  8009a6:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8009a9:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8009af:	4c 89 e9             	mov    %r13,%rcx
  8009b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b7:	4c 89 fe             	mov    %r15,%rsi
  8009ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8009bf:	48 b8 23 03 80 00 00 	movabs $0x800323,%rax
  8009c6:	00 00 00 
  8009c9:	ff d0                	call   *%rax
  8009cb:	89 c3                	mov    %eax,%ebx
  8009cd:	85 c0                	test   %eax,%eax
  8009cf:	78 14                	js     8009e5 <dup+0xfb>

    return newfdnum;
  8009d1:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8009d4:	89 d8                	mov    %ebx,%eax
  8009d6:	48 83 c4 18          	add    $0x18,%rsp
  8009da:	5b                   	pop    %rbx
  8009db:	41 5c                	pop    %r12
  8009dd:	41 5d                	pop    %r13
  8009df:	41 5e                	pop    %r14
  8009e1:	41 5f                	pop    %r15
  8009e3:	5d                   	pop    %rbp
  8009e4:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8009e5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009ea:	4c 89 ee             	mov    %r13,%rsi
  8009ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8009f2:	49 bc f8 03 80 00 00 	movabs $0x8003f8,%r12
  8009f9:	00 00 00 
  8009fc:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8009ff:	ba 00 10 00 00       	mov    $0x1000,%edx
  800a04:	4c 89 f6             	mov    %r14,%rsi
  800a07:	bf 00 00 00 00       	mov    $0x0,%edi
  800a0c:	41 ff d4             	call   *%r12
    return res;
  800a0f:	eb c3                	jmp    8009d4 <dup+0xea>

0000000000800a11 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800a11:	f3 0f 1e fa          	endbr64
  800a15:	55                   	push   %rbp
  800a16:	48 89 e5             	mov    %rsp,%rbp
  800a19:	41 56                	push   %r14
  800a1b:	41 55                	push   %r13
  800a1d:	41 54                	push   %r12
  800a1f:	53                   	push   %rbx
  800a20:	48 83 ec 10          	sub    $0x10,%rsp
  800a24:	89 fb                	mov    %edi,%ebx
  800a26:	49 89 f4             	mov    %rsi,%r12
  800a29:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a2c:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800a30:	48 b8 16 07 80 00 00 	movabs $0x800716,%rax
  800a37:	00 00 00 
  800a3a:	ff d0                	call   *%rax
  800a3c:	85 c0                	test   %eax,%eax
  800a3e:	78 4c                	js     800a8c <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a40:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800a44:	41 8b 3e             	mov    (%r14),%edi
  800a47:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800a4b:	48 b8 65 07 80 00 00 	movabs $0x800765,%rax
  800a52:	00 00 00 
  800a55:	ff d0                	call   *%rax
  800a57:	85 c0                	test   %eax,%eax
  800a59:	78 35                	js     800a90 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a5b:	41 8b 46 08          	mov    0x8(%r14),%eax
  800a5f:	83 e0 03             	and    $0x3,%eax
  800a62:	83 f8 01             	cmp    $0x1,%eax
  800a65:	74 2d                	je     800a94 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800a67:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a6b:	48 8b 40 10          	mov    0x10(%rax),%rax
  800a6f:	48 85 c0             	test   %rax,%rax
  800a72:	74 56                	je     800aca <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  800a74:	4c 89 ea             	mov    %r13,%rdx
  800a77:	4c 89 e6             	mov    %r12,%rsi
  800a7a:	4c 89 f7             	mov    %r14,%rdi
  800a7d:	ff d0                	call   *%rax
}
  800a7f:	48 83 c4 10          	add    $0x10,%rsp
  800a83:	5b                   	pop    %rbx
  800a84:	41 5c                	pop    %r12
  800a86:	41 5d                	pop    %r13
  800a88:	41 5e                	pop    %r14
  800a8a:	5d                   	pop    %rbp
  800a8b:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a8c:	48 98                	cltq
  800a8e:	eb ef                	jmp    800a7f <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a90:	48 98                	cltq
  800a92:	eb eb                	jmp    800a7f <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800a94:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800a9b:	00 00 00 
  800a9e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800aa4:	89 da                	mov    %ebx,%edx
  800aa6:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  800aad:	00 00 00 
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	48 b9 3f 1d 80 00 00 	movabs $0x801d3f,%rcx
  800abc:	00 00 00 
  800abf:	ff d1                	call   *%rcx
        return -E_INVAL;
  800ac1:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800ac8:	eb b5                	jmp    800a7f <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800aca:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800ad1:	eb ac                	jmp    800a7f <read+0x6e>

0000000000800ad3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800ad3:	f3 0f 1e fa          	endbr64
  800ad7:	55                   	push   %rbp
  800ad8:	48 89 e5             	mov    %rsp,%rbp
  800adb:	41 57                	push   %r15
  800add:	41 56                	push   %r14
  800adf:	41 55                	push   %r13
  800ae1:	41 54                	push   %r12
  800ae3:	53                   	push   %rbx
  800ae4:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800ae8:	48 85 d2             	test   %rdx,%rdx
  800aeb:	74 54                	je     800b41 <readn+0x6e>
  800aed:	41 89 fd             	mov    %edi,%r13d
  800af0:	49 89 f6             	mov    %rsi,%r14
  800af3:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800af6:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800afb:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800b00:	49 bf 11 0a 80 00 00 	movabs $0x800a11,%r15
  800b07:	00 00 00 
  800b0a:	4c 89 e2             	mov    %r12,%rdx
  800b0d:	48 29 f2             	sub    %rsi,%rdx
  800b10:	4c 01 f6             	add    %r14,%rsi
  800b13:	44 89 ef             	mov    %r13d,%edi
  800b16:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800b19:	85 c0                	test   %eax,%eax
  800b1b:	78 20                	js     800b3d <readn+0x6a>
    for (; inc && res < n; res += inc) {
  800b1d:	01 c3                	add    %eax,%ebx
  800b1f:	85 c0                	test   %eax,%eax
  800b21:	74 08                	je     800b2b <readn+0x58>
  800b23:	48 63 f3             	movslq %ebx,%rsi
  800b26:	4c 39 e6             	cmp    %r12,%rsi
  800b29:	72 df                	jb     800b0a <readn+0x37>
    }
    return res;
  800b2b:	48 63 c3             	movslq %ebx,%rax
}
  800b2e:	48 83 c4 08          	add    $0x8,%rsp
  800b32:	5b                   	pop    %rbx
  800b33:	41 5c                	pop    %r12
  800b35:	41 5d                	pop    %r13
  800b37:	41 5e                	pop    %r14
  800b39:	41 5f                	pop    %r15
  800b3b:	5d                   	pop    %rbp
  800b3c:	c3                   	ret
        if (inc < 0) return inc;
  800b3d:	48 98                	cltq
  800b3f:	eb ed                	jmp    800b2e <readn+0x5b>
    int inc = 1, res = 0;
  800b41:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b46:	eb e3                	jmp    800b2b <readn+0x58>

0000000000800b48 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800b48:	f3 0f 1e fa          	endbr64
  800b4c:	55                   	push   %rbp
  800b4d:	48 89 e5             	mov    %rsp,%rbp
  800b50:	41 56                	push   %r14
  800b52:	41 55                	push   %r13
  800b54:	41 54                	push   %r12
  800b56:	53                   	push   %rbx
  800b57:	48 83 ec 10          	sub    $0x10,%rsp
  800b5b:	89 fb                	mov    %edi,%ebx
  800b5d:	49 89 f4             	mov    %rsi,%r12
  800b60:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b63:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800b67:	48 b8 16 07 80 00 00 	movabs $0x800716,%rax
  800b6e:	00 00 00 
  800b71:	ff d0                	call   *%rax
  800b73:	85 c0                	test   %eax,%eax
  800b75:	78 47                	js     800bbe <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b77:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800b7b:	41 8b 3e             	mov    (%r14),%edi
  800b7e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800b82:	48 b8 65 07 80 00 00 	movabs $0x800765,%rax
  800b89:	00 00 00 
  800b8c:	ff d0                	call   *%rax
  800b8e:	85 c0                	test   %eax,%eax
  800b90:	78 30                	js     800bc2 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b92:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  800b97:	74 2d                	je     800bc6 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800b99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b9d:	48 8b 40 18          	mov    0x18(%rax),%rax
  800ba1:	48 85 c0             	test   %rax,%rax
  800ba4:	74 56                	je     800bfc <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  800ba6:	4c 89 ea             	mov    %r13,%rdx
  800ba9:	4c 89 e6             	mov    %r12,%rsi
  800bac:	4c 89 f7             	mov    %r14,%rdi
  800baf:	ff d0                	call   *%rax
}
  800bb1:	48 83 c4 10          	add    $0x10,%rsp
  800bb5:	5b                   	pop    %rbx
  800bb6:	41 5c                	pop    %r12
  800bb8:	41 5d                	pop    %r13
  800bba:	41 5e                	pop    %r14
  800bbc:	5d                   	pop    %rbp
  800bbd:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800bbe:	48 98                	cltq
  800bc0:	eb ef                	jmp    800bb1 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bc2:	48 98                	cltq
  800bc4:	eb eb                	jmp    800bb1 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800bc6:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bcd:	00 00 00 
  800bd0:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800bd6:	89 da                	mov    %ebx,%edx
  800bd8:	48 bf 34 30 80 00 00 	movabs $0x803034,%rdi
  800bdf:	00 00 00 
  800be2:	b8 00 00 00 00       	mov    $0x0,%eax
  800be7:	48 b9 3f 1d 80 00 00 	movabs $0x801d3f,%rcx
  800bee:	00 00 00 
  800bf1:	ff d1                	call   *%rcx
        return -E_INVAL;
  800bf3:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800bfa:	eb b5                	jmp    800bb1 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800bfc:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800c03:	eb ac                	jmp    800bb1 <write+0x69>

0000000000800c05 <seek>:

int
seek(int fdnum, off_t offset) {
  800c05:	f3 0f 1e fa          	endbr64
  800c09:	55                   	push   %rbp
  800c0a:	48 89 e5             	mov    %rsp,%rbp
  800c0d:	53                   	push   %rbx
  800c0e:	48 83 ec 18          	sub    $0x18,%rsp
  800c12:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c14:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c18:	48 b8 16 07 80 00 00 	movabs $0x800716,%rax
  800c1f:	00 00 00 
  800c22:	ff d0                	call   *%rax
  800c24:	85 c0                	test   %eax,%eax
  800c26:	78 0c                	js     800c34 <seek+0x2f>

    fd->fd_offset = offset;
  800c28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2c:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800c2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c34:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c38:	c9                   	leave
  800c39:	c3                   	ret

0000000000800c3a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800c3a:	f3 0f 1e fa          	endbr64
  800c3e:	55                   	push   %rbp
  800c3f:	48 89 e5             	mov    %rsp,%rbp
  800c42:	41 55                	push   %r13
  800c44:	41 54                	push   %r12
  800c46:	53                   	push   %rbx
  800c47:	48 83 ec 18          	sub    $0x18,%rsp
  800c4b:	89 fb                	mov    %edi,%ebx
  800c4d:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c50:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800c54:	48 b8 16 07 80 00 00 	movabs $0x800716,%rax
  800c5b:	00 00 00 
  800c5e:	ff d0                	call   *%rax
  800c60:	85 c0                	test   %eax,%eax
  800c62:	78 38                	js     800c9c <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c64:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  800c68:	41 8b 7d 00          	mov    0x0(%r13),%edi
  800c6c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800c70:	48 b8 65 07 80 00 00 	movabs $0x800765,%rax
  800c77:	00 00 00 
  800c7a:	ff d0                	call   *%rax
  800c7c:	85 c0                	test   %eax,%eax
  800c7e:	78 1c                	js     800c9c <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c80:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  800c85:	74 20                	je     800ca7 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c87:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c8b:	48 8b 40 30          	mov    0x30(%rax),%rax
  800c8f:	48 85 c0             	test   %rax,%rax
  800c92:	74 47                	je     800cdb <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  800c94:	44 89 e6             	mov    %r12d,%esi
  800c97:	4c 89 ef             	mov    %r13,%rdi
  800c9a:	ff d0                	call   *%rax
}
  800c9c:	48 83 c4 18          	add    $0x18,%rsp
  800ca0:	5b                   	pop    %rbx
  800ca1:	41 5c                	pop    %r12
  800ca3:	41 5d                	pop    %r13
  800ca5:	5d                   	pop    %rbp
  800ca6:	c3                   	ret
                thisenv->env_id, fdnum);
  800ca7:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800cae:	00 00 00 
  800cb1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800cb7:	89 da                	mov    %ebx,%edx
  800cb9:	48 bf 98 32 80 00 00 	movabs $0x803298,%rdi
  800cc0:	00 00 00 
  800cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc8:	48 b9 3f 1d 80 00 00 	movabs $0x801d3f,%rcx
  800ccf:	00 00 00 
  800cd2:	ff d1                	call   *%rcx
        return -E_INVAL;
  800cd4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cd9:	eb c1                	jmp    800c9c <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800cdb:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800ce0:	eb ba                	jmp    800c9c <ftruncate+0x62>

0000000000800ce2 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800ce2:	f3 0f 1e fa          	endbr64
  800ce6:	55                   	push   %rbp
  800ce7:	48 89 e5             	mov    %rsp,%rbp
  800cea:	41 54                	push   %r12
  800cec:	53                   	push   %rbx
  800ced:	48 83 ec 10          	sub    $0x10,%rsp
  800cf1:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800cf4:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800cf8:	48 b8 16 07 80 00 00 	movabs $0x800716,%rax
  800cff:	00 00 00 
  800d02:	ff d0                	call   *%rax
  800d04:	85 c0                	test   %eax,%eax
  800d06:	78 4e                	js     800d56 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800d08:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  800d0c:	41 8b 3c 24          	mov    (%r12),%edi
  800d10:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800d14:	48 b8 65 07 80 00 00 	movabs $0x800765,%rax
  800d1b:	00 00 00 
  800d1e:	ff d0                	call   *%rax
  800d20:	85 c0                	test   %eax,%eax
  800d22:	78 32                	js     800d56 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800d28:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800d2d:	74 30                	je     800d5f <fstat+0x7d>

    stat->st_name[0] = 0;
  800d2f:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800d32:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800d39:	00 00 00 
    stat->st_isdir = 0;
  800d3c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800d43:	00 00 00 
    stat->st_dev = dev;
  800d46:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800d4d:	48 89 de             	mov    %rbx,%rsi
  800d50:	4c 89 e7             	mov    %r12,%rdi
  800d53:	ff 50 28             	call   *0x28(%rax)
}
  800d56:	48 83 c4 10          	add    $0x10,%rsp
  800d5a:	5b                   	pop    %rbx
  800d5b:	41 5c                	pop    %r12
  800d5d:	5d                   	pop    %rbp
  800d5e:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d5f:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800d64:	eb f0                	jmp    800d56 <fstat+0x74>

0000000000800d66 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800d66:	f3 0f 1e fa          	endbr64
  800d6a:	55                   	push   %rbp
  800d6b:	48 89 e5             	mov    %rsp,%rbp
  800d6e:	41 54                	push   %r12
  800d70:	53                   	push   %rbx
  800d71:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800d74:	be 00 00 00 00       	mov    $0x0,%esi
  800d79:	48 b8 47 10 80 00 00 	movabs $0x801047,%rax
  800d80:	00 00 00 
  800d83:	ff d0                	call   *%rax
  800d85:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800d87:	85 c0                	test   %eax,%eax
  800d89:	78 25                	js     800db0 <stat+0x4a>

    int res = fstat(fd, stat);
  800d8b:	4c 89 e6             	mov    %r12,%rsi
  800d8e:	89 c7                	mov    %eax,%edi
  800d90:	48 b8 e2 0c 80 00 00 	movabs $0x800ce2,%rax
  800d97:	00 00 00 
  800d9a:	ff d0                	call   *%rax
  800d9c:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800d9f:	89 df                	mov    %ebx,%edi
  800da1:	48 b8 87 08 80 00 00 	movabs $0x800887,%rax
  800da8:	00 00 00 
  800dab:	ff d0                	call   *%rax

    return res;
  800dad:	44 89 e3             	mov    %r12d,%ebx
}
  800db0:	89 d8                	mov    %ebx,%eax
  800db2:	5b                   	pop    %rbx
  800db3:	41 5c                	pop    %r12
  800db5:	5d                   	pop    %rbp
  800db6:	c3                   	ret

0000000000800db7 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800db7:	f3 0f 1e fa          	endbr64
  800dbb:	55                   	push   %rbp
  800dbc:	48 89 e5             	mov    %rsp,%rbp
  800dbf:	41 54                	push   %r12
  800dc1:	53                   	push   %rbx
  800dc2:	48 83 ec 10          	sub    $0x10,%rsp
  800dc6:	41 89 fc             	mov    %edi,%r12d
  800dc9:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800dcc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800dd3:	00 00 00 
  800dd6:	83 38 00             	cmpl   $0x0,(%rax)
  800dd9:	74 6e                	je     800e49 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  800ddb:	bf 03 00 00 00       	mov    $0x3,%edi
  800de0:	48 b8 43 2c 80 00 00 	movabs $0x802c43,%rax
  800de7:	00 00 00 
  800dea:	ff d0                	call   *%rax
  800dec:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800df3:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800df5:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800dfb:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800e00:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800e07:	00 00 00 
  800e0a:	44 89 e6             	mov    %r12d,%esi
  800e0d:	89 c7                	mov    %eax,%edi
  800e0f:	48 b8 81 2b 80 00 00 	movabs $0x802b81,%rax
  800e16:	00 00 00 
  800e19:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800e1b:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800e22:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800e23:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e28:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e2c:	48 89 de             	mov    %rbx,%rsi
  800e2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800e34:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  800e3b:	00 00 00 
  800e3e:	ff d0                	call   *%rax
}
  800e40:	48 83 c4 10          	add    $0x10,%rsp
  800e44:	5b                   	pop    %rbx
  800e45:	41 5c                	pop    %r12
  800e47:	5d                   	pop    %rbp
  800e48:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800e49:	bf 03 00 00 00       	mov    $0x3,%edi
  800e4e:	48 b8 43 2c 80 00 00 	movabs $0x802c43,%rax
  800e55:	00 00 00 
  800e58:	ff d0                	call   *%rax
  800e5a:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e61:	00 00 
  800e63:	e9 73 ff ff ff       	jmp    800ddb <fsipc+0x24>

0000000000800e68 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800e68:	f3 0f 1e fa          	endbr64
  800e6c:	55                   	push   %rbp
  800e6d:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800e70:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e77:	00 00 00 
  800e7a:	8b 57 0c             	mov    0xc(%rdi),%edx
  800e7d:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800e7f:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800e82:	be 00 00 00 00       	mov    $0x0,%esi
  800e87:	bf 02 00 00 00       	mov    $0x2,%edi
  800e8c:	48 b8 b7 0d 80 00 00 	movabs $0x800db7,%rax
  800e93:	00 00 00 
  800e96:	ff d0                	call   *%rax
}
  800e98:	5d                   	pop    %rbp
  800e99:	c3                   	ret

0000000000800e9a <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800e9a:	f3 0f 1e fa          	endbr64
  800e9e:	55                   	push   %rbp
  800e9f:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800ea2:	8b 47 0c             	mov    0xc(%rdi),%eax
  800ea5:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800eac:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800eae:	be 00 00 00 00       	mov    $0x0,%esi
  800eb3:	bf 06 00 00 00       	mov    $0x6,%edi
  800eb8:	48 b8 b7 0d 80 00 00 	movabs $0x800db7,%rax
  800ebf:	00 00 00 
  800ec2:	ff d0                	call   *%rax
}
  800ec4:	5d                   	pop    %rbp
  800ec5:	c3                   	ret

0000000000800ec6 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800ec6:	f3 0f 1e fa          	endbr64
  800eca:	55                   	push   %rbp
  800ecb:	48 89 e5             	mov    %rsp,%rbp
  800ece:	41 54                	push   %r12
  800ed0:	53                   	push   %rbx
  800ed1:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ed4:	8b 47 0c             	mov    0xc(%rdi),%eax
  800ed7:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ede:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800ee0:	be 00 00 00 00       	mov    $0x0,%esi
  800ee5:	bf 05 00 00 00       	mov    $0x5,%edi
  800eea:	48 b8 b7 0d 80 00 00 	movabs $0x800db7,%rax
  800ef1:	00 00 00 
  800ef4:	ff d0                	call   *%rax
    if (res < 0) return res;
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	78 3d                	js     800f37 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800efa:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  800f01:	00 00 00 
  800f04:	4c 89 e6             	mov    %r12,%rsi
  800f07:	48 89 df             	mov    %rbx,%rdi
  800f0a:	48 b8 88 26 80 00 00 	movabs $0x802688,%rax
  800f11:	00 00 00 
  800f14:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800f16:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  800f1d:	00 
  800f1e:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800f24:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  800f2b:	00 
  800f2c:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800f32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f37:	5b                   	pop    %rbx
  800f38:	41 5c                	pop    %r12
  800f3a:	5d                   	pop    %rbp
  800f3b:	c3                   	ret

0000000000800f3c <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f3c:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  800f40:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  800f47:	77 41                	ja     800f8a <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f49:	55                   	push   %rbp
  800f4a:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  800f4d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f54:	00 00 00 
  800f57:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f5a:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  800f5c:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  800f60:	48 8d 78 10          	lea    0x10(%rax),%rdi
  800f64:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  800f6b:	00 00 00 
  800f6e:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  800f70:	be 00 00 00 00       	mov    $0x0,%esi
  800f75:	bf 04 00 00 00       	mov    $0x4,%edi
  800f7a:	48 b8 b7 0d 80 00 00 	movabs $0x800db7,%rax
  800f81:	00 00 00 
  800f84:	ff d0                	call   *%rax
  800f86:	48 98                	cltq
}
  800f88:	5d                   	pop    %rbp
  800f89:	c3                   	ret
        return -E_INVAL;
  800f8a:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  800f91:	c3                   	ret

0000000000800f92 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800f92:	f3 0f 1e fa          	endbr64
  800f96:	55                   	push   %rbp
  800f97:	48 89 e5             	mov    %rsp,%rbp
  800f9a:	41 55                	push   %r13
  800f9c:	41 54                	push   %r12
  800f9e:	53                   	push   %rbx
  800f9f:	48 83 ec 08          	sub    $0x8,%rsp
  800fa3:	49 89 f4             	mov    %rsi,%r12
  800fa6:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800fa9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800fb0:	00 00 00 
  800fb3:	8b 57 0c             	mov    0xc(%rdi),%edx
  800fb6:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  800fb8:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  800fbc:	be 00 00 00 00       	mov    $0x0,%esi
  800fc1:	bf 03 00 00 00       	mov    $0x3,%edi
  800fc6:	48 b8 b7 0d 80 00 00 	movabs $0x800db7,%rax
  800fcd:	00 00 00 
  800fd0:	ff d0                	call   *%rax
  800fd2:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  800fd5:	4d 85 ed             	test   %r13,%r13
  800fd8:	78 2a                	js     801004 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  800fda:	4c 89 ea             	mov    %r13,%rdx
  800fdd:	4c 39 eb             	cmp    %r13,%rbx
  800fe0:	72 30                	jb     801012 <devfile_read+0x80>
  800fe2:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  800fe9:	7f 27                	jg     801012 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  800feb:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800ff2:	00 00 00 
  800ff5:	4c 89 e7             	mov    %r12,%rdi
  800ff8:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  800fff:	00 00 00 
  801002:	ff d0                	call   *%rax
}
  801004:	4c 89 e8             	mov    %r13,%rax
  801007:	48 83 c4 08          	add    $0x8,%rsp
  80100b:	5b                   	pop    %rbx
  80100c:	41 5c                	pop    %r12
  80100e:	41 5d                	pop    %r13
  801010:	5d                   	pop    %rbp
  801011:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801012:	48 b9 51 30 80 00 00 	movabs $0x803051,%rcx
  801019:	00 00 00 
  80101c:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  801023:	00 00 00 
  801026:	be 7b 00 00 00       	mov    $0x7b,%esi
  80102b:	48 bf 83 30 80 00 00 	movabs $0x803083,%rdi
  801032:	00 00 00 
  801035:	b8 00 00 00 00       	mov    $0x0,%eax
  80103a:	49 b8 e3 1b 80 00 00 	movabs $0x801be3,%r8
  801041:	00 00 00 
  801044:	41 ff d0             	call   *%r8

0000000000801047 <open>:
open(const char *path, int mode) {
  801047:	f3 0f 1e fa          	endbr64
  80104b:	55                   	push   %rbp
  80104c:	48 89 e5             	mov    %rsp,%rbp
  80104f:	41 55                	push   %r13
  801051:	41 54                	push   %r12
  801053:	53                   	push   %rbx
  801054:	48 83 ec 18          	sub    $0x18,%rsp
  801058:	49 89 fc             	mov    %rdi,%r12
  80105b:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  80105e:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  801065:	00 00 00 
  801068:	ff d0                	call   *%rax
  80106a:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801070:	0f 87 8a 00 00 00    	ja     801100 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801076:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80107a:	48 b8 b2 06 80 00 00 	movabs $0x8006b2,%rax
  801081:	00 00 00 
  801084:	ff d0                	call   *%rax
  801086:	89 c3                	mov    %eax,%ebx
  801088:	85 c0                	test   %eax,%eax
  80108a:	78 50                	js     8010dc <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80108c:	4c 89 e6             	mov    %r12,%rsi
  80108f:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801096:	00 00 00 
  801099:	48 89 df             	mov    %rbx,%rdi
  80109c:	48 b8 88 26 80 00 00 	movabs $0x802688,%rax
  8010a3:	00 00 00 
  8010a6:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8010a8:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8010af:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8010b3:	bf 01 00 00 00       	mov    $0x1,%edi
  8010b8:	48 b8 b7 0d 80 00 00 	movabs $0x800db7,%rax
  8010bf:	00 00 00 
  8010c2:	ff d0                	call   *%rax
  8010c4:	89 c3                	mov    %eax,%ebx
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	78 1f                	js     8010e9 <open+0xa2>
    return fd2num(fd);
  8010ca:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010ce:	48 b8 7c 06 80 00 00 	movabs $0x80067c,%rax
  8010d5:	00 00 00 
  8010d8:	ff d0                	call   *%rax
  8010da:	89 c3                	mov    %eax,%ebx
}
  8010dc:	89 d8                	mov    %ebx,%eax
  8010de:	48 83 c4 18          	add    $0x18,%rsp
  8010e2:	5b                   	pop    %rbx
  8010e3:	41 5c                	pop    %r12
  8010e5:	41 5d                	pop    %r13
  8010e7:	5d                   	pop    %rbp
  8010e8:	c3                   	ret
        fd_close(fd, 0);
  8010e9:	be 00 00 00 00       	mov    $0x0,%esi
  8010ee:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010f2:	48 b8 d9 07 80 00 00 	movabs $0x8007d9,%rax
  8010f9:	00 00 00 
  8010fc:	ff d0                	call   *%rax
        return res;
  8010fe:	eb dc                	jmp    8010dc <open+0x95>
        return -E_BAD_PATH;
  801100:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801105:	eb d5                	jmp    8010dc <open+0x95>

0000000000801107 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801107:	f3 0f 1e fa          	endbr64
  80110b:	55                   	push   %rbp
  80110c:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80110f:	be 00 00 00 00       	mov    $0x0,%esi
  801114:	bf 08 00 00 00       	mov    $0x8,%edi
  801119:	48 b8 b7 0d 80 00 00 	movabs $0x800db7,%rax
  801120:	00 00 00 
  801123:	ff d0                	call   *%rax
}
  801125:	5d                   	pop    %rbp
  801126:	c3                   	ret

0000000000801127 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801127:	f3 0f 1e fa          	endbr64
  80112b:	55                   	push   %rbp
  80112c:	48 89 e5             	mov    %rsp,%rbp
  80112f:	41 54                	push   %r12
  801131:	53                   	push   %rbx
  801132:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801135:	48 b8 92 06 80 00 00 	movabs $0x800692,%rax
  80113c:	00 00 00 
  80113f:	ff d0                	call   *%rax
  801141:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801144:	48 be 8e 30 80 00 00 	movabs $0x80308e,%rsi
  80114b:	00 00 00 
  80114e:	48 89 df             	mov    %rbx,%rdi
  801151:	48 b8 88 26 80 00 00 	movabs $0x802688,%rax
  801158:	00 00 00 
  80115b:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80115d:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801162:	41 2b 04 24          	sub    (%r12),%eax
  801166:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80116c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801173:	00 00 00 
    stat->st_dev = &devpipe;
  801176:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80117d:	00 00 00 
  801180:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801187:	b8 00 00 00 00       	mov    $0x0,%eax
  80118c:	5b                   	pop    %rbx
  80118d:	41 5c                	pop    %r12
  80118f:	5d                   	pop    %rbp
  801190:	c3                   	ret

0000000000801191 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801191:	f3 0f 1e fa          	endbr64
  801195:	55                   	push   %rbp
  801196:	48 89 e5             	mov    %rsp,%rbp
  801199:	41 54                	push   %r12
  80119b:	53                   	push   %rbx
  80119c:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80119f:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011a4:	48 89 fe             	mov    %rdi,%rsi
  8011a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8011ac:	49 bc f8 03 80 00 00 	movabs $0x8003f8,%r12
  8011b3:	00 00 00 
  8011b6:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8011b9:	48 89 df             	mov    %rbx,%rdi
  8011bc:	48 b8 92 06 80 00 00 	movabs $0x800692,%rax
  8011c3:	00 00 00 
  8011c6:	ff d0                	call   *%rax
  8011c8:	48 89 c6             	mov    %rax,%rsi
  8011cb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8011d5:	41 ff d4             	call   *%r12
}
  8011d8:	5b                   	pop    %rbx
  8011d9:	41 5c                	pop    %r12
  8011db:	5d                   	pop    %rbp
  8011dc:	c3                   	ret

00000000008011dd <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8011dd:	f3 0f 1e fa          	endbr64
  8011e1:	55                   	push   %rbp
  8011e2:	48 89 e5             	mov    %rsp,%rbp
  8011e5:	41 57                	push   %r15
  8011e7:	41 56                	push   %r14
  8011e9:	41 55                	push   %r13
  8011eb:	41 54                	push   %r12
  8011ed:	53                   	push   %rbx
  8011ee:	48 83 ec 18          	sub    $0x18,%rsp
  8011f2:	49 89 fc             	mov    %rdi,%r12
  8011f5:	49 89 f5             	mov    %rsi,%r13
  8011f8:	49 89 d7             	mov    %rdx,%r15
  8011fb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8011ff:	48 b8 92 06 80 00 00 	movabs $0x800692,%rax
  801206:	00 00 00 
  801209:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80120b:	4d 85 ff             	test   %r15,%r15
  80120e:	0f 84 af 00 00 00    	je     8012c3 <devpipe_write+0xe6>
  801214:	48 89 c3             	mov    %rax,%rbx
  801217:	4c 89 f8             	mov    %r15,%rax
  80121a:	4d 89 ef             	mov    %r13,%r15
  80121d:	4c 01 e8             	add    %r13,%rax
  801220:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801224:	49 bd 88 02 80 00 00 	movabs $0x800288,%r13
  80122b:	00 00 00 
            sys_yield();
  80122e:	49 be 1d 02 80 00 00 	movabs $0x80021d,%r14
  801235:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801238:	8b 73 04             	mov    0x4(%rbx),%esi
  80123b:	48 63 ce             	movslq %esi,%rcx
  80123e:	48 63 03             	movslq (%rbx),%rax
  801241:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801247:	48 39 c1             	cmp    %rax,%rcx
  80124a:	72 2e                	jb     80127a <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80124c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801251:	48 89 da             	mov    %rbx,%rdx
  801254:	be 00 10 00 00       	mov    $0x1000,%esi
  801259:	4c 89 e7             	mov    %r12,%rdi
  80125c:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80125f:	85 c0                	test   %eax,%eax
  801261:	74 66                	je     8012c9 <devpipe_write+0xec>
            sys_yield();
  801263:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801266:	8b 73 04             	mov    0x4(%rbx),%esi
  801269:	48 63 ce             	movslq %esi,%rcx
  80126c:	48 63 03             	movslq (%rbx),%rax
  80126f:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801275:	48 39 c1             	cmp    %rax,%rcx
  801278:	73 d2                	jae    80124c <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80127a:	41 0f b6 3f          	movzbl (%r15),%edi
  80127e:	48 89 ca             	mov    %rcx,%rdx
  801281:	48 c1 ea 03          	shr    $0x3,%rdx
  801285:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80128c:	08 10 20 
  80128f:	48 f7 e2             	mul    %rdx
  801292:	48 c1 ea 06          	shr    $0x6,%rdx
  801296:	48 89 d0             	mov    %rdx,%rax
  801299:	48 c1 e0 09          	shl    $0x9,%rax
  80129d:	48 29 d0             	sub    %rdx,%rax
  8012a0:	48 c1 e0 03          	shl    $0x3,%rax
  8012a4:	48 29 c1             	sub    %rax,%rcx
  8012a7:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8012ac:	83 c6 01             	add    $0x1,%esi
  8012af:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012b2:	49 83 c7 01          	add    $0x1,%r15
  8012b6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012ba:	49 39 c7             	cmp    %rax,%r15
  8012bd:	0f 85 75 ff ff ff    	jne    801238 <devpipe_write+0x5b>
    return n;
  8012c3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8012c7:	eb 05                	jmp    8012ce <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8012c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ce:	48 83 c4 18          	add    $0x18,%rsp
  8012d2:	5b                   	pop    %rbx
  8012d3:	41 5c                	pop    %r12
  8012d5:	41 5d                	pop    %r13
  8012d7:	41 5e                	pop    %r14
  8012d9:	41 5f                	pop    %r15
  8012db:	5d                   	pop    %rbp
  8012dc:	c3                   	ret

00000000008012dd <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8012dd:	f3 0f 1e fa          	endbr64
  8012e1:	55                   	push   %rbp
  8012e2:	48 89 e5             	mov    %rsp,%rbp
  8012e5:	41 57                	push   %r15
  8012e7:	41 56                	push   %r14
  8012e9:	41 55                	push   %r13
  8012eb:	41 54                	push   %r12
  8012ed:	53                   	push   %rbx
  8012ee:	48 83 ec 18          	sub    $0x18,%rsp
  8012f2:	49 89 fc             	mov    %rdi,%r12
  8012f5:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8012f9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8012fd:	48 b8 92 06 80 00 00 	movabs $0x800692,%rax
  801304:	00 00 00 
  801307:	ff d0                	call   *%rax
  801309:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80130c:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801312:	49 bd 88 02 80 00 00 	movabs $0x800288,%r13
  801319:	00 00 00 
            sys_yield();
  80131c:	49 be 1d 02 80 00 00 	movabs $0x80021d,%r14
  801323:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801326:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80132b:	74 7d                	je     8013aa <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80132d:	8b 03                	mov    (%rbx),%eax
  80132f:	3b 43 04             	cmp    0x4(%rbx),%eax
  801332:	75 26                	jne    80135a <devpipe_read+0x7d>
            if (i > 0) return i;
  801334:	4d 85 ff             	test   %r15,%r15
  801337:	75 77                	jne    8013b0 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801339:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80133e:	48 89 da             	mov    %rbx,%rdx
  801341:	be 00 10 00 00       	mov    $0x1000,%esi
  801346:	4c 89 e7             	mov    %r12,%rdi
  801349:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80134c:	85 c0                	test   %eax,%eax
  80134e:	74 72                	je     8013c2 <devpipe_read+0xe5>
            sys_yield();
  801350:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801353:	8b 03                	mov    (%rbx),%eax
  801355:	3b 43 04             	cmp    0x4(%rbx),%eax
  801358:	74 df                	je     801339 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80135a:	48 63 c8             	movslq %eax,%rcx
  80135d:	48 89 ca             	mov    %rcx,%rdx
  801360:	48 c1 ea 03          	shr    $0x3,%rdx
  801364:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  80136b:	08 10 20 
  80136e:	48 89 d0             	mov    %rdx,%rax
  801371:	48 f7 e6             	mul    %rsi
  801374:	48 c1 ea 06          	shr    $0x6,%rdx
  801378:	48 89 d0             	mov    %rdx,%rax
  80137b:	48 c1 e0 09          	shl    $0x9,%rax
  80137f:	48 29 d0             	sub    %rdx,%rax
  801382:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801389:	00 
  80138a:	48 89 c8             	mov    %rcx,%rax
  80138d:	48 29 d0             	sub    %rdx,%rax
  801390:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  801395:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801399:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80139d:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8013a0:	49 83 c7 01          	add    $0x1,%r15
  8013a4:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8013a8:	75 83                	jne    80132d <devpipe_read+0x50>
    return n;
  8013aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013ae:	eb 03                	jmp    8013b3 <devpipe_read+0xd6>
            if (i > 0) return i;
  8013b0:	4c 89 f8             	mov    %r15,%rax
}
  8013b3:	48 83 c4 18          	add    $0x18,%rsp
  8013b7:	5b                   	pop    %rbx
  8013b8:	41 5c                	pop    %r12
  8013ba:	41 5d                	pop    %r13
  8013bc:	41 5e                	pop    %r14
  8013be:	41 5f                	pop    %r15
  8013c0:	5d                   	pop    %rbp
  8013c1:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8013c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c7:	eb ea                	jmp    8013b3 <devpipe_read+0xd6>

00000000008013c9 <pipe>:
pipe(int pfd[2]) {
  8013c9:	f3 0f 1e fa          	endbr64
  8013cd:	55                   	push   %rbp
  8013ce:	48 89 e5             	mov    %rsp,%rbp
  8013d1:	41 55                	push   %r13
  8013d3:	41 54                	push   %r12
  8013d5:	53                   	push   %rbx
  8013d6:	48 83 ec 18          	sub    $0x18,%rsp
  8013da:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8013dd:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8013e1:	48 b8 b2 06 80 00 00 	movabs $0x8006b2,%rax
  8013e8:	00 00 00 
  8013eb:	ff d0                	call   *%rax
  8013ed:	89 c3                	mov    %eax,%ebx
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	0f 88 a0 01 00 00    	js     801597 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8013f7:	b9 46 00 00 00       	mov    $0x46,%ecx
  8013fc:	ba 00 10 00 00       	mov    $0x1000,%edx
  801401:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801405:	bf 00 00 00 00       	mov    $0x0,%edi
  80140a:	48 b8 b8 02 80 00 00 	movabs $0x8002b8,%rax
  801411:	00 00 00 
  801414:	ff d0                	call   *%rax
  801416:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801418:	85 c0                	test   %eax,%eax
  80141a:	0f 88 77 01 00 00    	js     801597 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  801420:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  801424:	48 b8 b2 06 80 00 00 	movabs $0x8006b2,%rax
  80142b:	00 00 00 
  80142e:	ff d0                	call   *%rax
  801430:	89 c3                	mov    %eax,%ebx
  801432:	85 c0                	test   %eax,%eax
  801434:	0f 88 43 01 00 00    	js     80157d <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80143a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80143f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801444:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801448:	bf 00 00 00 00       	mov    $0x0,%edi
  80144d:	48 b8 b8 02 80 00 00 	movabs $0x8002b8,%rax
  801454:	00 00 00 
  801457:	ff d0                	call   *%rax
  801459:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80145b:	85 c0                	test   %eax,%eax
  80145d:	0f 88 1a 01 00 00    	js     80157d <pipe+0x1b4>
    va = fd2data(fd0);
  801463:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801467:	48 b8 92 06 80 00 00 	movabs $0x800692,%rax
  80146e:	00 00 00 
  801471:	ff d0                	call   *%rax
  801473:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801476:	b9 46 00 00 00       	mov    $0x46,%ecx
  80147b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801480:	48 89 c6             	mov    %rax,%rsi
  801483:	bf 00 00 00 00       	mov    $0x0,%edi
  801488:	48 b8 b8 02 80 00 00 	movabs $0x8002b8,%rax
  80148f:	00 00 00 
  801492:	ff d0                	call   *%rax
  801494:	89 c3                	mov    %eax,%ebx
  801496:	85 c0                	test   %eax,%eax
  801498:	0f 88 c5 00 00 00    	js     801563 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80149e:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8014a2:	48 b8 92 06 80 00 00 	movabs $0x800692,%rax
  8014a9:	00 00 00 
  8014ac:	ff d0                	call   *%rax
  8014ae:	48 89 c1             	mov    %rax,%rcx
  8014b1:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8014b7:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8014bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c2:	4c 89 ee             	mov    %r13,%rsi
  8014c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8014ca:	48 b8 23 03 80 00 00 	movabs $0x800323,%rax
  8014d1:	00 00 00 
  8014d4:	ff d0                	call   *%rax
  8014d6:	89 c3                	mov    %eax,%ebx
  8014d8:	85 c0                	test   %eax,%eax
  8014da:	78 6e                	js     80154a <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014dc:	be 00 10 00 00       	mov    $0x1000,%esi
  8014e1:	4c 89 ef             	mov    %r13,%rdi
  8014e4:	48 b8 52 02 80 00 00 	movabs $0x800252,%rax
  8014eb:	00 00 00 
  8014ee:	ff d0                	call   *%rax
  8014f0:	83 f8 02             	cmp    $0x2,%eax
  8014f3:	0f 85 ab 00 00 00    	jne    8015a4 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8014f9:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  801500:	00 00 
  801502:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801506:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  801508:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80150c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  801513:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801517:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801519:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80151d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  801524:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801528:	48 bb 7c 06 80 00 00 	movabs $0x80067c,%rbx
  80152f:	00 00 00 
  801532:	ff d3                	call   *%rbx
  801534:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801538:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80153c:	ff d3                	call   *%rbx
  80153e:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  801543:	bb 00 00 00 00       	mov    $0x0,%ebx
  801548:	eb 4d                	jmp    801597 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  80154a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80154f:	4c 89 ee             	mov    %r13,%rsi
  801552:	bf 00 00 00 00       	mov    $0x0,%edi
  801557:	48 b8 f8 03 80 00 00 	movabs $0x8003f8,%rax
  80155e:	00 00 00 
  801561:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  801563:	ba 00 10 00 00       	mov    $0x1000,%edx
  801568:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80156c:	bf 00 00 00 00       	mov    $0x0,%edi
  801571:	48 b8 f8 03 80 00 00 	movabs $0x8003f8,%rax
  801578:	00 00 00 
  80157b:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80157d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801582:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801586:	bf 00 00 00 00       	mov    $0x0,%edi
  80158b:	48 b8 f8 03 80 00 00 	movabs $0x8003f8,%rax
  801592:	00 00 00 
  801595:	ff d0                	call   *%rax
}
  801597:	89 d8                	mov    %ebx,%eax
  801599:	48 83 c4 18          	add    $0x18,%rsp
  80159d:	5b                   	pop    %rbx
  80159e:	41 5c                	pop    %r12
  8015a0:	41 5d                	pop    %r13
  8015a2:	5d                   	pop    %rbp
  8015a3:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8015a4:	48 b9 c0 32 80 00 00 	movabs $0x8032c0,%rcx
  8015ab:	00 00 00 
  8015ae:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  8015b5:	00 00 00 
  8015b8:	be 2e 00 00 00       	mov    $0x2e,%esi
  8015bd:	48 bf 95 30 80 00 00 	movabs $0x803095,%rdi
  8015c4:	00 00 00 
  8015c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015cc:	49 b8 e3 1b 80 00 00 	movabs $0x801be3,%r8
  8015d3:	00 00 00 
  8015d6:	41 ff d0             	call   *%r8

00000000008015d9 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8015d9:	f3 0f 1e fa          	endbr64
  8015dd:	55                   	push   %rbp
  8015de:	48 89 e5             	mov    %rsp,%rbp
  8015e1:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8015e5:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8015e9:	48 b8 16 07 80 00 00 	movabs $0x800716,%rax
  8015f0:	00 00 00 
  8015f3:	ff d0                	call   *%rax
    if (res < 0) return res;
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	78 35                	js     80162e <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8015f9:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8015fd:	48 b8 92 06 80 00 00 	movabs $0x800692,%rax
  801604:	00 00 00 
  801607:	ff d0                	call   *%rax
  801609:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80160c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801611:	be 00 10 00 00       	mov    $0x1000,%esi
  801616:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80161a:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  801621:	00 00 00 
  801624:	ff d0                	call   *%rax
  801626:	85 c0                	test   %eax,%eax
  801628:	0f 94 c0             	sete   %al
  80162b:	0f b6 c0             	movzbl %al,%eax
}
  80162e:	c9                   	leave
  80162f:	c3                   	ret

0000000000801630 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  801630:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801634:	48 89 f8             	mov    %rdi,%rax
  801637:	48 c1 e8 27          	shr    $0x27,%rax
  80163b:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  801642:	7f 00 00 
  801645:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801649:	f6 c2 01             	test   $0x1,%dl
  80164c:	74 6d                	je     8016bb <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80164e:	48 89 f8             	mov    %rdi,%rax
  801651:	48 c1 e8 1e          	shr    $0x1e,%rax
  801655:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80165c:	7f 00 00 
  80165f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801663:	f6 c2 01             	test   $0x1,%dl
  801666:	74 62                	je     8016ca <get_uvpt_entry+0x9a>
  801668:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80166f:	7f 00 00 
  801672:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801676:	f6 c2 80             	test   $0x80,%dl
  801679:	75 4f                	jne    8016ca <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80167b:	48 89 f8             	mov    %rdi,%rax
  80167e:	48 c1 e8 15          	shr    $0x15,%rax
  801682:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  801689:	7f 00 00 
  80168c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801690:	f6 c2 01             	test   $0x1,%dl
  801693:	74 44                	je     8016d9 <get_uvpt_entry+0xa9>
  801695:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80169c:	7f 00 00 
  80169f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8016a3:	f6 c2 80             	test   $0x80,%dl
  8016a6:	75 31                	jne    8016d9 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  8016a8:	48 c1 ef 0c          	shr    $0xc,%rdi
  8016ac:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8016b3:	7f 00 00 
  8016b6:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8016ba:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8016bb:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8016c2:	7f 00 00 
  8016c5:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016c9:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8016ca:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8016d1:	7f 00 00 
  8016d4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016d8:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8016d9:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016e0:	7f 00 00 
  8016e3:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016e7:	c3                   	ret

00000000008016e8 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8016e8:	f3 0f 1e fa          	endbr64
  8016ec:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8016ef:	48 89 f9             	mov    %rdi,%rcx
  8016f2:	48 c1 e9 27          	shr    $0x27,%rcx
  8016f6:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8016fd:	7f 00 00 
  801700:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  801704:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  80170b:	f6 c1 01             	test   $0x1,%cl
  80170e:	0f 84 b2 00 00 00    	je     8017c6 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  801714:	48 89 f9             	mov    %rdi,%rcx
  801717:	48 c1 e9 1e          	shr    $0x1e,%rcx
  80171b:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801722:	7f 00 00 
  801725:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801729:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  801730:	40 f6 c6 01          	test   $0x1,%sil
  801734:	0f 84 8c 00 00 00    	je     8017c6 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  80173a:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801741:	7f 00 00 
  801744:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801748:	a8 80                	test   $0x80,%al
  80174a:	75 7b                	jne    8017c7 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  80174c:	48 89 f9             	mov    %rdi,%rcx
  80174f:	48 c1 e9 15          	shr    $0x15,%rcx
  801753:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80175a:	7f 00 00 
  80175d:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801761:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  801768:	40 f6 c6 01          	test   $0x1,%sil
  80176c:	74 58                	je     8017c6 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  80176e:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801775:	7f 00 00 
  801778:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80177c:	a8 80                	test   $0x80,%al
  80177e:	75 6c                	jne    8017ec <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  801780:	48 89 f9             	mov    %rdi,%rcx
  801783:	48 c1 e9 0c          	shr    $0xc,%rcx
  801787:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80178e:	7f 00 00 
  801791:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801795:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  80179c:	40 f6 c6 01          	test   $0x1,%sil
  8017a0:	74 24                	je     8017c6 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  8017a2:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8017a9:	7f 00 00 
  8017ac:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017b0:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017b7:	ff ff 7f 
  8017ba:	48 21 c8             	and    %rcx,%rax
  8017bd:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8017c3:	48 09 d0             	or     %rdx,%rax
}
  8017c6:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8017c7:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8017ce:	7f 00 00 
  8017d1:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017d5:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017dc:	ff ff 7f 
  8017df:	48 21 c8             	and    %rcx,%rax
  8017e2:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8017e8:	48 01 d0             	add    %rdx,%rax
  8017eb:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8017ec:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8017f3:	7f 00 00 
  8017f6:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017fa:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  801801:	ff ff 7f 
  801804:	48 21 c8             	and    %rcx,%rax
  801807:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  80180d:	48 01 d0             	add    %rdx,%rax
  801810:	c3                   	ret

0000000000801811 <get_prot>:

int
get_prot(void *va) {
  801811:	f3 0f 1e fa          	endbr64
  801815:	55                   	push   %rbp
  801816:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801819:	48 b8 30 16 80 00 00 	movabs $0x801630,%rax
  801820:	00 00 00 
  801823:	ff d0                	call   *%rax
  801825:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  801828:	83 e0 01             	and    $0x1,%eax
  80182b:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80182e:	89 d1                	mov    %edx,%ecx
  801830:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  801836:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  801838:	89 c1                	mov    %eax,%ecx
  80183a:	83 c9 02             	or     $0x2,%ecx
  80183d:	f6 c2 02             	test   $0x2,%dl
  801840:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  801843:	89 c1                	mov    %eax,%ecx
  801845:	83 c9 01             	or     $0x1,%ecx
  801848:	48 85 d2             	test   %rdx,%rdx
  80184b:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80184e:	89 c1                	mov    %eax,%ecx
  801850:	83 c9 40             	or     $0x40,%ecx
  801853:	f6 c6 04             	test   $0x4,%dh
  801856:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801859:	5d                   	pop    %rbp
  80185a:	c3                   	ret

000000000080185b <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80185b:	f3 0f 1e fa          	endbr64
  80185f:	55                   	push   %rbp
  801860:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801863:	48 b8 30 16 80 00 00 	movabs $0x801630,%rax
  80186a:	00 00 00 
  80186d:	ff d0                	call   *%rax
    return pte & PTE_D;
  80186f:	48 c1 e8 06          	shr    $0x6,%rax
  801873:	83 e0 01             	and    $0x1,%eax
}
  801876:	5d                   	pop    %rbp
  801877:	c3                   	ret

0000000000801878 <is_page_present>:

bool
is_page_present(void *va) {
  801878:	f3 0f 1e fa          	endbr64
  80187c:	55                   	push   %rbp
  80187d:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  801880:	48 b8 30 16 80 00 00 	movabs $0x801630,%rax
  801887:	00 00 00 
  80188a:	ff d0                	call   *%rax
  80188c:	83 e0 01             	and    $0x1,%eax
}
  80188f:	5d                   	pop    %rbp
  801890:	c3                   	ret

0000000000801891 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801891:	f3 0f 1e fa          	endbr64
  801895:	55                   	push   %rbp
  801896:	48 89 e5             	mov    %rsp,%rbp
  801899:	41 57                	push   %r15
  80189b:	41 56                	push   %r14
  80189d:	41 55                	push   %r13
  80189f:	41 54                	push   %r12
  8018a1:	53                   	push   %rbx
  8018a2:	48 83 ec 18          	sub    $0x18,%rsp
  8018a6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8018aa:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8018ae:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8018b3:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8018ba:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8018bd:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8018c4:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8018c7:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8018ce:	00 00 00 
  8018d1:	eb 73                	jmp    801946 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018d3:	48 89 d8             	mov    %rbx,%rax
  8018d6:	48 c1 e8 15          	shr    $0x15,%rax
  8018da:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8018e1:	7f 00 00 
  8018e4:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8018e8:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018ee:	f6 c2 01             	test   $0x1,%dl
  8018f1:	74 4b                	je     80193e <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8018f3:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8018f7:	f6 c2 80             	test   $0x80,%dl
  8018fa:	74 11                	je     80190d <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8018fc:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  801900:	f6 c4 04             	test   $0x4,%ah
  801903:	74 39                	je     80193e <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  801905:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  80190b:	eb 20                	jmp    80192d <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80190d:	48 89 da             	mov    %rbx,%rdx
  801910:	48 c1 ea 0c          	shr    $0xc,%rdx
  801914:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80191b:	7f 00 00 
  80191e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  801922:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801928:	f6 c4 04             	test   $0x4,%ah
  80192b:	74 11                	je     80193e <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  80192d:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  801931:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801935:	48 89 df             	mov    %rbx,%rdi
  801938:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80193c:	ff d0                	call   *%rax
    next:
        va += size;
  80193e:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  801941:	49 39 df             	cmp    %rbx,%r15
  801944:	72 3e                	jb     801984 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  801946:	49 8b 06             	mov    (%r14),%rax
  801949:	a8 01                	test   $0x1,%al
  80194b:	74 37                	je     801984 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80194d:	48 89 d8             	mov    %rbx,%rax
  801950:	48 c1 e8 1e          	shr    $0x1e,%rax
  801954:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  801959:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80195f:	f6 c2 01             	test   $0x1,%dl
  801962:	74 da                	je     80193e <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  801964:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  801969:	f6 c2 80             	test   $0x80,%dl
  80196c:	0f 84 61 ff ff ff    	je     8018d3 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  801972:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  801977:	f6 c4 04             	test   $0x4,%ah
  80197a:	74 c2                	je     80193e <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  80197c:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  801982:	eb a9                	jmp    80192d <foreach_shared_region+0x9c>
    }
    return res;
}
  801984:	b8 00 00 00 00       	mov    $0x0,%eax
  801989:	48 83 c4 18          	add    $0x18,%rsp
  80198d:	5b                   	pop    %rbx
  80198e:	41 5c                	pop    %r12
  801990:	41 5d                	pop    %r13
  801992:	41 5e                	pop    %r14
  801994:	41 5f                	pop    %r15
  801996:	5d                   	pop    %rbp
  801997:	c3                   	ret

0000000000801998 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  801998:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  80199c:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a1:	c3                   	ret

00000000008019a2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8019a2:	f3 0f 1e fa          	endbr64
  8019a6:	55                   	push   %rbp
  8019a7:	48 89 e5             	mov    %rsp,%rbp
  8019aa:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8019ad:	48 be a5 30 80 00 00 	movabs $0x8030a5,%rsi
  8019b4:	00 00 00 
  8019b7:	48 b8 88 26 80 00 00 	movabs $0x802688,%rax
  8019be:	00 00 00 
  8019c1:	ff d0                	call   *%rax
    return 0;
}
  8019c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c8:	5d                   	pop    %rbp
  8019c9:	c3                   	ret

00000000008019ca <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8019ca:	f3 0f 1e fa          	endbr64
  8019ce:	55                   	push   %rbp
  8019cf:	48 89 e5             	mov    %rsp,%rbp
  8019d2:	41 57                	push   %r15
  8019d4:	41 56                	push   %r14
  8019d6:	41 55                	push   %r13
  8019d8:	41 54                	push   %r12
  8019da:	53                   	push   %rbx
  8019db:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8019e2:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8019e9:	48 85 d2             	test   %rdx,%rdx
  8019ec:	74 7a                	je     801a68 <devcons_write+0x9e>
  8019ee:	49 89 d6             	mov    %rdx,%r14
  8019f1:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8019f7:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8019fc:	49 bf a3 28 80 00 00 	movabs $0x8028a3,%r15
  801a03:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  801a06:	4c 89 f3             	mov    %r14,%rbx
  801a09:	48 29 f3             	sub    %rsi,%rbx
  801a0c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a11:	48 39 c3             	cmp    %rax,%rbx
  801a14:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801a18:	4c 63 eb             	movslq %ebx,%r13
  801a1b:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801a22:	48 01 c6             	add    %rax,%rsi
  801a25:	4c 89 ea             	mov    %r13,%rdx
  801a28:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a2f:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  801a32:	4c 89 ee             	mov    %r13,%rsi
  801a35:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a3c:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  801a43:	00 00 00 
  801a46:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801a48:	41 01 dc             	add    %ebx,%r12d
  801a4b:	49 63 f4             	movslq %r12d,%rsi
  801a4e:	4c 39 f6             	cmp    %r14,%rsi
  801a51:	72 b3                	jb     801a06 <devcons_write+0x3c>
    return res;
  801a53:	49 63 c4             	movslq %r12d,%rax
}
  801a56:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801a5d:	5b                   	pop    %rbx
  801a5e:	41 5c                	pop    %r12
  801a60:	41 5d                	pop    %r13
  801a62:	41 5e                	pop    %r14
  801a64:	41 5f                	pop    %r15
  801a66:	5d                   	pop    %rbp
  801a67:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  801a68:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a6e:	eb e3                	jmp    801a53 <devcons_write+0x89>

0000000000801a70 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a70:	f3 0f 1e fa          	endbr64
  801a74:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801a77:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7c:	48 85 c0             	test   %rax,%rax
  801a7f:	74 55                	je     801ad6 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a81:	55                   	push   %rbp
  801a82:	48 89 e5             	mov    %rsp,%rbp
  801a85:	41 55                	push   %r13
  801a87:	41 54                	push   %r12
  801a89:	53                   	push   %rbx
  801a8a:	48 83 ec 08          	sub    $0x8,%rsp
  801a8e:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801a91:	48 bb 44 01 80 00 00 	movabs $0x800144,%rbx
  801a98:	00 00 00 
  801a9b:	49 bc 1d 02 80 00 00 	movabs $0x80021d,%r12
  801aa2:	00 00 00 
  801aa5:	eb 03                	jmp    801aaa <devcons_read+0x3a>
  801aa7:	41 ff d4             	call   *%r12
  801aaa:	ff d3                	call   *%rbx
  801aac:	85 c0                	test   %eax,%eax
  801aae:	74 f7                	je     801aa7 <devcons_read+0x37>
    if (c < 0) return c;
  801ab0:	48 63 d0             	movslq %eax,%rdx
  801ab3:	78 13                	js     801ac8 <devcons_read+0x58>
    if (c == 0x04) return 0;
  801ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aba:	83 f8 04             	cmp    $0x4,%eax
  801abd:	74 09                	je     801ac8 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  801abf:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801ac3:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801ac8:	48 89 d0             	mov    %rdx,%rax
  801acb:	48 83 c4 08          	add    $0x8,%rsp
  801acf:	5b                   	pop    %rbx
  801ad0:	41 5c                	pop    %r12
  801ad2:	41 5d                	pop    %r13
  801ad4:	5d                   	pop    %rbp
  801ad5:	c3                   	ret
  801ad6:	48 89 d0             	mov    %rdx,%rax
  801ad9:	c3                   	ret

0000000000801ada <cputchar>:
cputchar(int ch) {
  801ada:	f3 0f 1e fa          	endbr64
  801ade:	55                   	push   %rbp
  801adf:	48 89 e5             	mov    %rsp,%rbp
  801ae2:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801ae6:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801aea:	be 01 00 00 00       	mov    $0x1,%esi
  801aef:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801af3:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  801afa:	00 00 00 
  801afd:	ff d0                	call   *%rax
}
  801aff:	c9                   	leave
  801b00:	c3                   	ret

0000000000801b01 <getchar>:
getchar(void) {
  801b01:	f3 0f 1e fa          	endbr64
  801b05:	55                   	push   %rbp
  801b06:	48 89 e5             	mov    %rsp,%rbp
  801b09:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801b0d:	ba 01 00 00 00       	mov    $0x1,%edx
  801b12:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801b16:	bf 00 00 00 00       	mov    $0x0,%edi
  801b1b:	48 b8 11 0a 80 00 00 	movabs $0x800a11,%rax
  801b22:	00 00 00 
  801b25:	ff d0                	call   *%rax
  801b27:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	78 06                	js     801b33 <getchar+0x32>
  801b2d:	74 08                	je     801b37 <getchar+0x36>
  801b2f:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  801b33:	89 d0                	mov    %edx,%eax
  801b35:	c9                   	leave
  801b36:	c3                   	ret
    return res < 0 ? res : res ? c :
  801b37:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801b3c:	eb f5                	jmp    801b33 <getchar+0x32>

0000000000801b3e <iscons>:
iscons(int fdnum) {
  801b3e:	f3 0f 1e fa          	endbr64
  801b42:	55                   	push   %rbp
  801b43:	48 89 e5             	mov    %rsp,%rbp
  801b46:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801b4a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b4e:	48 b8 16 07 80 00 00 	movabs $0x800716,%rax
  801b55:	00 00 00 
  801b58:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b5a:	85 c0                	test   %eax,%eax
  801b5c:	78 18                	js     801b76 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  801b5e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b62:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801b69:	00 00 00 
  801b6c:	8b 00                	mov    (%rax),%eax
  801b6e:	39 02                	cmp    %eax,(%rdx)
  801b70:	0f 94 c0             	sete   %al
  801b73:	0f b6 c0             	movzbl %al,%eax
}
  801b76:	c9                   	leave
  801b77:	c3                   	ret

0000000000801b78 <opencons>:
opencons(void) {
  801b78:	f3 0f 1e fa          	endbr64
  801b7c:	55                   	push   %rbp
  801b7d:	48 89 e5             	mov    %rsp,%rbp
  801b80:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801b84:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801b88:	48 b8 b2 06 80 00 00 	movabs $0x8006b2,%rax
  801b8f:	00 00 00 
  801b92:	ff d0                	call   *%rax
  801b94:	85 c0                	test   %eax,%eax
  801b96:	78 49                	js     801be1 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801b98:	b9 46 00 00 00       	mov    $0x46,%ecx
  801b9d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ba2:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801ba6:	bf 00 00 00 00       	mov    $0x0,%edi
  801bab:	48 b8 b8 02 80 00 00 	movabs $0x8002b8,%rax
  801bb2:	00 00 00 
  801bb5:	ff d0                	call   *%rax
  801bb7:	85 c0                	test   %eax,%eax
  801bb9:	78 26                	js     801be1 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  801bbb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bbf:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801bc6:	00 00 
  801bc8:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801bca:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801bce:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801bd5:	48 b8 7c 06 80 00 00 	movabs $0x80067c,%rax
  801bdc:	00 00 00 
  801bdf:	ff d0                	call   *%rax
}
  801be1:	c9                   	leave
  801be2:	c3                   	ret

0000000000801be3 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801be3:	f3 0f 1e fa          	endbr64
  801be7:	55                   	push   %rbp
  801be8:	48 89 e5             	mov    %rsp,%rbp
  801beb:	41 56                	push   %r14
  801bed:	41 55                	push   %r13
  801bef:	41 54                	push   %r12
  801bf1:	53                   	push   %rbx
  801bf2:	48 83 ec 50          	sub    $0x50,%rsp
  801bf6:	49 89 fc             	mov    %rdi,%r12
  801bf9:	41 89 f5             	mov    %esi,%r13d
  801bfc:	48 89 d3             	mov    %rdx,%rbx
  801bff:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c03:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801c07:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801c0b:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801c12:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c16:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801c1a:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801c1e:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801c22:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801c29:	00 00 00 
  801c2c:	4c 8b 30             	mov    (%rax),%r14
  801c2f:	48 b8 e8 01 80 00 00 	movabs $0x8001e8,%rax
  801c36:	00 00 00 
  801c39:	ff d0                	call   *%rax
  801c3b:	89 c6                	mov    %eax,%esi
  801c3d:	45 89 e8             	mov    %r13d,%r8d
  801c40:	4c 89 e1             	mov    %r12,%rcx
  801c43:	4c 89 f2             	mov    %r14,%rdx
  801c46:	48 bf e8 32 80 00 00 	movabs $0x8032e8,%rdi
  801c4d:	00 00 00 
  801c50:	b8 00 00 00 00       	mov    $0x0,%eax
  801c55:	49 bc 3f 1d 80 00 00 	movabs $0x801d3f,%r12
  801c5c:	00 00 00 
  801c5f:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801c62:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801c66:	48 89 df             	mov    %rbx,%rdi
  801c69:	48 b8 d7 1c 80 00 00 	movabs $0x801cd7,%rax
  801c70:	00 00 00 
  801c73:	ff d0                	call   *%rax
    cprintf("\n");
  801c75:	48 bf 32 30 80 00 00 	movabs $0x803032,%rdi
  801c7c:	00 00 00 
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c84:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801c87:	cc                   	int3
  801c88:	eb fd                	jmp    801c87 <_panic+0xa4>

0000000000801c8a <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801c8a:	f3 0f 1e fa          	endbr64
  801c8e:	55                   	push   %rbp
  801c8f:	48 89 e5             	mov    %rsp,%rbp
  801c92:	53                   	push   %rbx
  801c93:	48 83 ec 08          	sub    $0x8,%rsp
  801c97:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801c9a:	8b 06                	mov    (%rsi),%eax
  801c9c:	8d 50 01             	lea    0x1(%rax),%edx
  801c9f:	89 16                	mov    %edx,(%rsi)
  801ca1:	48 98                	cltq
  801ca3:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801ca8:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801cae:	74 0a                	je     801cba <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801cb0:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801cb4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cb8:	c9                   	leave
  801cb9:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  801cba:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801cbe:	be ff 00 00 00       	mov    $0xff,%esi
  801cc3:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  801cca:	00 00 00 
  801ccd:	ff d0                	call   *%rax
        state->offset = 0;
  801ccf:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801cd5:	eb d9                	jmp    801cb0 <putch+0x26>

0000000000801cd7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801cd7:	f3 0f 1e fa          	endbr64
  801cdb:	55                   	push   %rbp
  801cdc:	48 89 e5             	mov    %rsp,%rbp
  801cdf:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801ce6:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801ce9:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801cf0:	b9 21 00 00 00       	mov    $0x21,%ecx
  801cf5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfa:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801cfd:	48 89 f1             	mov    %rsi,%rcx
  801d00:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801d07:	48 bf 8a 1c 80 00 00 	movabs $0x801c8a,%rdi
  801d0e:	00 00 00 
  801d11:	48 b8 9f 1e 80 00 00 	movabs $0x801e9f,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801d1d:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801d24:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801d2b:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  801d32:	00 00 00 
  801d35:	ff d0                	call   *%rax

    return state.count;
}
  801d37:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801d3d:	c9                   	leave
  801d3e:	c3                   	ret

0000000000801d3f <cprintf>:

int
cprintf(const char *fmt, ...) {
  801d3f:	f3 0f 1e fa          	endbr64
  801d43:	55                   	push   %rbp
  801d44:	48 89 e5             	mov    %rsp,%rbp
  801d47:	48 83 ec 50          	sub    $0x50,%rsp
  801d4b:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801d4f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801d53:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d57:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801d5b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801d5f:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801d66:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d6a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d6e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801d72:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801d76:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801d7a:	48 b8 d7 1c 80 00 00 	movabs $0x801cd7,%rax
  801d81:	00 00 00 
  801d84:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801d86:	c9                   	leave
  801d87:	c3                   	ret

0000000000801d88 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801d88:	f3 0f 1e fa          	endbr64
  801d8c:	55                   	push   %rbp
  801d8d:	48 89 e5             	mov    %rsp,%rbp
  801d90:	41 57                	push   %r15
  801d92:	41 56                	push   %r14
  801d94:	41 55                	push   %r13
  801d96:	41 54                	push   %r12
  801d98:	53                   	push   %rbx
  801d99:	48 83 ec 18          	sub    $0x18,%rsp
  801d9d:	49 89 fc             	mov    %rdi,%r12
  801da0:	49 89 f5             	mov    %rsi,%r13
  801da3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801da7:	8b 45 10             	mov    0x10(%rbp),%eax
  801daa:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801dad:	41 89 cf             	mov    %ecx,%r15d
  801db0:	4c 39 fa             	cmp    %r15,%rdx
  801db3:	73 5b                	jae    801e10 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801db5:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801db9:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801dbd:	85 db                	test   %ebx,%ebx
  801dbf:	7e 0e                	jle    801dcf <print_num+0x47>
            putch(padc, put_arg);
  801dc1:	4c 89 ee             	mov    %r13,%rsi
  801dc4:	44 89 f7             	mov    %r14d,%edi
  801dc7:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801dca:	83 eb 01             	sub    $0x1,%ebx
  801dcd:	75 f2                	jne    801dc1 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801dcf:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801dd3:	48 b9 c2 30 80 00 00 	movabs $0x8030c2,%rcx
  801dda:	00 00 00 
  801ddd:	48 b8 b1 30 80 00 00 	movabs $0x8030b1,%rax
  801de4:	00 00 00 
  801de7:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801deb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801def:	ba 00 00 00 00       	mov    $0x0,%edx
  801df4:	49 f7 f7             	div    %r15
  801df7:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801dfb:	4c 89 ee             	mov    %r13,%rsi
  801dfe:	41 ff d4             	call   *%r12
}
  801e01:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801e05:	5b                   	pop    %rbx
  801e06:	41 5c                	pop    %r12
  801e08:	41 5d                	pop    %r13
  801e0a:	41 5e                	pop    %r14
  801e0c:	41 5f                	pop    %r15
  801e0e:	5d                   	pop    %rbp
  801e0f:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801e10:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e14:	ba 00 00 00 00       	mov    $0x0,%edx
  801e19:	49 f7 f7             	div    %r15
  801e1c:	48 83 ec 08          	sub    $0x8,%rsp
  801e20:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801e24:	52                   	push   %rdx
  801e25:	45 0f be c9          	movsbl %r9b,%r9d
  801e29:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801e2d:	48 89 c2             	mov    %rax,%rdx
  801e30:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  801e37:	00 00 00 
  801e3a:	ff d0                	call   *%rax
  801e3c:	48 83 c4 10          	add    $0x10,%rsp
  801e40:	eb 8d                	jmp    801dcf <print_num+0x47>

0000000000801e42 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  801e42:	f3 0f 1e fa          	endbr64
    state->count++;
  801e46:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801e4a:	48 8b 06             	mov    (%rsi),%rax
  801e4d:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801e51:	73 0a                	jae    801e5d <sprintputch+0x1b>
        *state->start++ = ch;
  801e53:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e57:	48 89 16             	mov    %rdx,(%rsi)
  801e5a:	40 88 38             	mov    %dil,(%rax)
    }
}
  801e5d:	c3                   	ret

0000000000801e5e <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801e5e:	f3 0f 1e fa          	endbr64
  801e62:	55                   	push   %rbp
  801e63:	48 89 e5             	mov    %rsp,%rbp
  801e66:	48 83 ec 50          	sub    $0x50,%rsp
  801e6a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e6e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801e72:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801e76:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801e7d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e81:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e85:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801e89:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801e8d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801e91:	48 b8 9f 1e 80 00 00 	movabs $0x801e9f,%rax
  801e98:	00 00 00 
  801e9b:	ff d0                	call   *%rax
}
  801e9d:	c9                   	leave
  801e9e:	c3                   	ret

0000000000801e9f <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801e9f:	f3 0f 1e fa          	endbr64
  801ea3:	55                   	push   %rbp
  801ea4:	48 89 e5             	mov    %rsp,%rbp
  801ea7:	41 57                	push   %r15
  801ea9:	41 56                	push   %r14
  801eab:	41 55                	push   %r13
  801ead:	41 54                	push   %r12
  801eaf:	53                   	push   %rbx
  801eb0:	48 83 ec 38          	sub    $0x38,%rsp
  801eb4:	49 89 fe             	mov    %rdi,%r14
  801eb7:	49 89 f5             	mov    %rsi,%r13
  801eba:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  801ebd:	48 8b 01             	mov    (%rcx),%rax
  801ec0:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801ec4:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801ec8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ecc:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801ed0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801ed4:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  801ed8:	0f b6 3b             	movzbl (%rbx),%edi
  801edb:	40 80 ff 25          	cmp    $0x25,%dil
  801edf:	74 18                	je     801ef9 <vprintfmt+0x5a>
            if (!ch) return;
  801ee1:	40 84 ff             	test   %dil,%dil
  801ee4:	0f 84 b2 06 00 00    	je     80259c <vprintfmt+0x6fd>
            putch(ch, put_arg);
  801eea:	40 0f b6 ff          	movzbl %dil,%edi
  801eee:	4c 89 ee             	mov    %r13,%rsi
  801ef1:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  801ef4:	4c 89 e3             	mov    %r12,%rbx
  801ef7:	eb db                	jmp    801ed4 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  801ef9:	be 00 00 00 00       	mov    $0x0,%esi
  801efe:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  801f02:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801f07:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f0d:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801f14:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f18:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  801f1d:	41 0f b6 04 24       	movzbl (%r12),%eax
  801f22:	88 45 a0             	mov    %al,-0x60(%rbp)
  801f25:	83 e8 23             	sub    $0x23,%eax
  801f28:	3c 57                	cmp    $0x57,%al
  801f2a:	0f 87 52 06 00 00    	ja     802582 <vprintfmt+0x6e3>
  801f30:	0f b6 c0             	movzbl %al,%eax
  801f33:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  801f3a:	00 00 00 
  801f3d:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  801f41:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  801f44:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  801f48:	eb ce                	jmp    801f18 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  801f4a:	49 89 dc             	mov    %rbx,%r12
  801f4d:	be 01 00 00 00       	mov    $0x1,%esi
  801f52:	eb c4                	jmp    801f18 <vprintfmt+0x79>
            padc = ch;
  801f54:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  801f58:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f5b:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801f5e:	eb b8                	jmp    801f18 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f60:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f63:	83 f8 2f             	cmp    $0x2f,%eax
  801f66:	77 24                	ja     801f8c <vprintfmt+0xed>
  801f68:	89 c1                	mov    %eax,%ecx
  801f6a:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  801f6e:	83 c0 08             	add    $0x8,%eax
  801f71:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f74:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  801f77:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  801f7a:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801f7e:	79 98                	jns    801f18 <vprintfmt+0x79>
                width = precision;
  801f80:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  801f84:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f8a:	eb 8c                	jmp    801f18 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f8c:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801f90:	48 8d 41 08          	lea    0x8(%rcx),%rax
  801f94:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801f98:	eb da                	jmp    801f74 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  801f9a:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  801f9f:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fa3:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  801fa9:	3c 39                	cmp    $0x39,%al
  801fab:	77 1c                	ja     801fc9 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  801fad:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  801fb1:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  801fb5:	0f b6 c0             	movzbl %al,%eax
  801fb8:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fbd:	0f b6 03             	movzbl (%rbx),%eax
  801fc0:	3c 39                	cmp    $0x39,%al
  801fc2:	76 e9                	jbe    801fad <vprintfmt+0x10e>
        process_precision:
  801fc4:	49 89 dc             	mov    %rbx,%r12
  801fc7:	eb b1                	jmp    801f7a <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  801fc9:	49 89 dc             	mov    %rbx,%r12
  801fcc:	eb ac                	jmp    801f7a <vprintfmt+0xdb>
            width = MAX(0, width);
  801fce:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  801fd1:	85 c9                	test   %ecx,%ecx
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd8:	0f 49 c1             	cmovns %ecx,%eax
  801fdb:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801fde:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fe1:	e9 32 ff ff ff       	jmp    801f18 <vprintfmt+0x79>
            lflag++;
  801fe6:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801fe9:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fec:	e9 27 ff ff ff       	jmp    801f18 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  801ff1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801ff4:	83 f8 2f             	cmp    $0x2f,%eax
  801ff7:	77 19                	ja     802012 <vprintfmt+0x173>
  801ff9:	89 c2                	mov    %eax,%edx
  801ffb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801fff:	83 c0 08             	add    $0x8,%eax
  802002:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802005:	8b 3a                	mov    (%rdx),%edi
  802007:	4c 89 ee             	mov    %r13,%rsi
  80200a:	41 ff d6             	call   *%r14
            break;
  80200d:	e9 c2 fe ff ff       	jmp    801ed4 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  802012:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802016:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80201a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80201e:	eb e5                	jmp    802005 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  802020:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802023:	83 f8 2f             	cmp    $0x2f,%eax
  802026:	77 5a                	ja     802082 <vprintfmt+0x1e3>
  802028:	89 c2                	mov    %eax,%edx
  80202a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80202e:	83 c0 08             	add    $0x8,%eax
  802031:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  802034:	8b 02                	mov    (%rdx),%eax
  802036:	89 c1                	mov    %eax,%ecx
  802038:	f7 d9                	neg    %ecx
  80203a:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80203d:	83 f9 13             	cmp    $0x13,%ecx
  802040:	7f 4e                	jg     802090 <vprintfmt+0x1f1>
  802042:	48 63 c1             	movslq %ecx,%rax
  802045:	48 ba 20 36 80 00 00 	movabs $0x803620,%rdx
  80204c:	00 00 00 
  80204f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802053:	48 85 c0             	test   %rax,%rax
  802056:	74 38                	je     802090 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  802058:	48 89 c1             	mov    %rax,%rcx
  80205b:	48 ba 80 30 80 00 00 	movabs $0x803080,%rdx
  802062:	00 00 00 
  802065:	4c 89 ee             	mov    %r13,%rsi
  802068:	4c 89 f7             	mov    %r14,%rdi
  80206b:	b8 00 00 00 00       	mov    $0x0,%eax
  802070:	49 b8 5e 1e 80 00 00 	movabs $0x801e5e,%r8
  802077:	00 00 00 
  80207a:	41 ff d0             	call   *%r8
  80207d:	e9 52 fe ff ff       	jmp    801ed4 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  802082:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802086:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80208a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80208e:	eb a4                	jmp    802034 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  802090:	48 ba da 30 80 00 00 	movabs $0x8030da,%rdx
  802097:	00 00 00 
  80209a:	4c 89 ee             	mov    %r13,%rsi
  80209d:	4c 89 f7             	mov    %r14,%rdi
  8020a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a5:	49 b8 5e 1e 80 00 00 	movabs $0x801e5e,%r8
  8020ac:	00 00 00 
  8020af:	41 ff d0             	call   *%r8
  8020b2:	e9 1d fe ff ff       	jmp    801ed4 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8020b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020ba:	83 f8 2f             	cmp    $0x2f,%eax
  8020bd:	77 6c                	ja     80212b <vprintfmt+0x28c>
  8020bf:	89 c2                	mov    %eax,%edx
  8020c1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8020c5:	83 c0 08             	add    $0x8,%eax
  8020c8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020cb:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8020ce:	48 85 d2             	test   %rdx,%rdx
  8020d1:	48 b8 d3 30 80 00 00 	movabs $0x8030d3,%rax
  8020d8:	00 00 00 
  8020db:	48 0f 45 c2          	cmovne %rdx,%rax
  8020df:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8020e3:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8020e7:	7e 06                	jle    8020ef <vprintfmt+0x250>
  8020e9:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8020ed:	75 4a                	jne    802139 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8020ef:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8020f3:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8020f7:	0f b6 00             	movzbl (%rax),%eax
  8020fa:	84 c0                	test   %al,%al
  8020fc:	0f 85 9a 00 00 00    	jne    80219c <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  802102:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802105:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  802109:	85 c0                	test   %eax,%eax
  80210b:	0f 8e c3 fd ff ff    	jle    801ed4 <vprintfmt+0x35>
  802111:	4c 89 ee             	mov    %r13,%rsi
  802114:	bf 20 00 00 00       	mov    $0x20,%edi
  802119:	41 ff d6             	call   *%r14
  80211c:	41 83 ec 01          	sub    $0x1,%r12d
  802120:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  802124:	75 eb                	jne    802111 <vprintfmt+0x272>
  802126:	e9 a9 fd ff ff       	jmp    801ed4 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80212b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80212f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802133:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802137:	eb 92                	jmp    8020cb <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  802139:	49 63 f7             	movslq %r15d,%rsi
  80213c:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  802140:	48 b8 62 26 80 00 00 	movabs $0x802662,%rax
  802147:	00 00 00 
  80214a:	ff d0                	call   *%rax
  80214c:	48 89 c2             	mov    %rax,%rdx
  80214f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802152:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  802154:	8d 70 ff             	lea    -0x1(%rax),%esi
  802157:	89 75 ac             	mov    %esi,-0x54(%rbp)
  80215a:	85 c0                	test   %eax,%eax
  80215c:	7e 91                	jle    8020ef <vprintfmt+0x250>
  80215e:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  802163:	4c 89 ee             	mov    %r13,%rsi
  802166:	44 89 e7             	mov    %r12d,%edi
  802169:	41 ff d6             	call   *%r14
  80216c:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  802170:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802173:	83 f8 ff             	cmp    $0xffffffff,%eax
  802176:	75 eb                	jne    802163 <vprintfmt+0x2c4>
  802178:	e9 72 ff ff ff       	jmp    8020ef <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80217d:	0f b6 f8             	movzbl %al,%edi
  802180:	4c 89 ee             	mov    %r13,%rsi
  802183:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802186:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80218a:	49 83 c4 01          	add    $0x1,%r12
  80218e:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  802194:	84 c0                	test   %al,%al
  802196:	0f 84 66 ff ff ff    	je     802102 <vprintfmt+0x263>
  80219c:	45 85 ff             	test   %r15d,%r15d
  80219f:	78 0a                	js     8021ab <vprintfmt+0x30c>
  8021a1:	41 83 ef 01          	sub    $0x1,%r15d
  8021a5:	0f 88 57 ff ff ff    	js     802102 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8021ab:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8021af:	74 cc                	je     80217d <vprintfmt+0x2de>
  8021b1:	8d 50 e0             	lea    -0x20(%rax),%edx
  8021b4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8021b9:	80 fa 5e             	cmp    $0x5e,%dl
  8021bc:	77 c2                	ja     802180 <vprintfmt+0x2e1>
  8021be:	eb bd                	jmp    80217d <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8021c0:	40 84 f6             	test   %sil,%sil
  8021c3:	75 26                	jne    8021eb <vprintfmt+0x34c>
    switch (lflag) {
  8021c5:	85 d2                	test   %edx,%edx
  8021c7:	74 59                	je     802222 <vprintfmt+0x383>
  8021c9:	83 fa 01             	cmp    $0x1,%edx
  8021cc:	74 7b                	je     802249 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8021ce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021d1:	83 f8 2f             	cmp    $0x2f,%eax
  8021d4:	0f 87 96 00 00 00    	ja     802270 <vprintfmt+0x3d1>
  8021da:	89 c2                	mov    %eax,%edx
  8021dc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021e0:	83 c0 08             	add    $0x8,%eax
  8021e3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021e6:	4c 8b 22             	mov    (%rdx),%r12
  8021e9:	eb 17                	jmp    802202 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8021eb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021ee:	83 f8 2f             	cmp    $0x2f,%eax
  8021f1:	77 21                	ja     802214 <vprintfmt+0x375>
  8021f3:	89 c2                	mov    %eax,%edx
  8021f5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021f9:	83 c0 08             	add    $0x8,%eax
  8021fc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021ff:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  802202:	4d 85 e4             	test   %r12,%r12
  802205:	78 7a                	js     802281 <vprintfmt+0x3e2>
            num = i;
  802207:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  80220a:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80220f:	e9 50 02 00 00       	jmp    802464 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  802214:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802218:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80221c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802220:	eb dd                	jmp    8021ff <vprintfmt+0x360>
        return va_arg(*ap, int);
  802222:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802225:	83 f8 2f             	cmp    $0x2f,%eax
  802228:	77 11                	ja     80223b <vprintfmt+0x39c>
  80222a:	89 c2                	mov    %eax,%edx
  80222c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802230:	83 c0 08             	add    $0x8,%eax
  802233:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802236:	4c 63 22             	movslq (%rdx),%r12
  802239:	eb c7                	jmp    802202 <vprintfmt+0x363>
  80223b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80223f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802243:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802247:	eb ed                	jmp    802236 <vprintfmt+0x397>
        return va_arg(*ap, long);
  802249:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80224c:	83 f8 2f             	cmp    $0x2f,%eax
  80224f:	77 11                	ja     802262 <vprintfmt+0x3c3>
  802251:	89 c2                	mov    %eax,%edx
  802253:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802257:	83 c0 08             	add    $0x8,%eax
  80225a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80225d:	4c 8b 22             	mov    (%rdx),%r12
  802260:	eb a0                	jmp    802202 <vprintfmt+0x363>
  802262:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802266:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80226a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80226e:	eb ed                	jmp    80225d <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  802270:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802274:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802278:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80227c:	e9 65 ff ff ff       	jmp    8021e6 <vprintfmt+0x347>
                putch('-', put_arg);
  802281:	4c 89 ee             	mov    %r13,%rsi
  802284:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802289:	41 ff d6             	call   *%r14
                i = -i;
  80228c:	49 f7 dc             	neg    %r12
  80228f:	e9 73 ff ff ff       	jmp    802207 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  802294:	40 84 f6             	test   %sil,%sil
  802297:	75 32                	jne    8022cb <vprintfmt+0x42c>
    switch (lflag) {
  802299:	85 d2                	test   %edx,%edx
  80229b:	74 5d                	je     8022fa <vprintfmt+0x45b>
  80229d:	83 fa 01             	cmp    $0x1,%edx
  8022a0:	0f 84 82 00 00 00    	je     802328 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8022a6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022a9:	83 f8 2f             	cmp    $0x2f,%eax
  8022ac:	0f 87 a5 00 00 00    	ja     802357 <vprintfmt+0x4b8>
  8022b2:	89 c2                	mov    %eax,%edx
  8022b4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022b8:	83 c0 08             	add    $0x8,%eax
  8022bb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022be:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022c1:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8022c6:	e9 99 01 00 00       	jmp    802464 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8022cb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022ce:	83 f8 2f             	cmp    $0x2f,%eax
  8022d1:	77 19                	ja     8022ec <vprintfmt+0x44d>
  8022d3:	89 c2                	mov    %eax,%edx
  8022d5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022d9:	83 c0 08             	add    $0x8,%eax
  8022dc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022df:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8022e7:	e9 78 01 00 00       	jmp    802464 <vprintfmt+0x5c5>
  8022ec:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8022f0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8022f4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022f8:	eb e5                	jmp    8022df <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8022fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022fd:	83 f8 2f             	cmp    $0x2f,%eax
  802300:	77 18                	ja     80231a <vprintfmt+0x47b>
  802302:	89 c2                	mov    %eax,%edx
  802304:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802308:	83 c0 08             	add    $0x8,%eax
  80230b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80230e:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  802310:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802315:	e9 4a 01 00 00       	jmp    802464 <vprintfmt+0x5c5>
  80231a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80231e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802322:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802326:	eb e6                	jmp    80230e <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  802328:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80232b:	83 f8 2f             	cmp    $0x2f,%eax
  80232e:	77 19                	ja     802349 <vprintfmt+0x4aa>
  802330:	89 c2                	mov    %eax,%edx
  802332:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802336:	83 c0 08             	add    $0x8,%eax
  802339:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80233c:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80233f:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  802344:	e9 1b 01 00 00       	jmp    802464 <vprintfmt+0x5c5>
  802349:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80234d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802351:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802355:	eb e5                	jmp    80233c <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  802357:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80235b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80235f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802363:	e9 56 ff ff ff       	jmp    8022be <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  802368:	40 84 f6             	test   %sil,%sil
  80236b:	75 2e                	jne    80239b <vprintfmt+0x4fc>
    switch (lflag) {
  80236d:	85 d2                	test   %edx,%edx
  80236f:	74 59                	je     8023ca <vprintfmt+0x52b>
  802371:	83 fa 01             	cmp    $0x1,%edx
  802374:	74 7f                	je     8023f5 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  802376:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802379:	83 f8 2f             	cmp    $0x2f,%eax
  80237c:	0f 87 9f 00 00 00    	ja     802421 <vprintfmt+0x582>
  802382:	89 c2                	mov    %eax,%edx
  802384:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802388:	83 c0 08             	add    $0x8,%eax
  80238b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80238e:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  802391:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  802396:	e9 c9 00 00 00       	jmp    802464 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80239b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80239e:	83 f8 2f             	cmp    $0x2f,%eax
  8023a1:	77 19                	ja     8023bc <vprintfmt+0x51d>
  8023a3:	89 c2                	mov    %eax,%edx
  8023a5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023a9:	83 c0 08             	add    $0x8,%eax
  8023ac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023af:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023b2:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8023b7:	e9 a8 00 00 00       	jmp    802464 <vprintfmt+0x5c5>
  8023bc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023c0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023c4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023c8:	eb e5                	jmp    8023af <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8023ca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023cd:	83 f8 2f             	cmp    $0x2f,%eax
  8023d0:	77 15                	ja     8023e7 <vprintfmt+0x548>
  8023d2:	89 c2                	mov    %eax,%edx
  8023d4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023d8:	83 c0 08             	add    $0x8,%eax
  8023db:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023de:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8023e0:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8023e5:	eb 7d                	jmp    802464 <vprintfmt+0x5c5>
  8023e7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023eb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023ef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023f3:	eb e9                	jmp    8023de <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8023f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023f8:	83 f8 2f             	cmp    $0x2f,%eax
  8023fb:	77 16                	ja     802413 <vprintfmt+0x574>
  8023fd:	89 c2                	mov    %eax,%edx
  8023ff:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802403:	83 c0 08             	add    $0x8,%eax
  802406:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802409:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80240c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  802411:	eb 51                	jmp    802464 <vprintfmt+0x5c5>
  802413:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802417:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80241b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80241f:	eb e8                	jmp    802409 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  802421:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802425:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802429:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80242d:	e9 5c ff ff ff       	jmp    80238e <vprintfmt+0x4ef>
            putch('0', put_arg);
  802432:	4c 89 ee             	mov    %r13,%rsi
  802435:	bf 30 00 00 00       	mov    $0x30,%edi
  80243a:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  80243d:	4c 89 ee             	mov    %r13,%rsi
  802440:	bf 78 00 00 00       	mov    $0x78,%edi
  802445:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  802448:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80244b:	83 f8 2f             	cmp    $0x2f,%eax
  80244e:	77 47                	ja     802497 <vprintfmt+0x5f8>
  802450:	89 c2                	mov    %eax,%edx
  802452:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802456:	83 c0 08             	add    $0x8,%eax
  802459:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80245c:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80245f:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  802464:	48 83 ec 08          	sub    $0x8,%rsp
  802468:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  80246c:	0f 94 c0             	sete   %al
  80246f:	0f b6 c0             	movzbl %al,%eax
  802472:	50                   	push   %rax
  802473:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  802478:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80247c:	4c 89 ee             	mov    %r13,%rsi
  80247f:	4c 89 f7             	mov    %r14,%rdi
  802482:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  802489:	00 00 00 
  80248c:	ff d0                	call   *%rax
            break;
  80248e:	48 83 c4 10          	add    $0x10,%rsp
  802492:	e9 3d fa ff ff       	jmp    801ed4 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  802497:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80249b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80249f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024a3:	eb b7                	jmp    80245c <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  8024a5:	40 84 f6             	test   %sil,%sil
  8024a8:	75 2b                	jne    8024d5 <vprintfmt+0x636>
    switch (lflag) {
  8024aa:	85 d2                	test   %edx,%edx
  8024ac:	74 56                	je     802504 <vprintfmt+0x665>
  8024ae:	83 fa 01             	cmp    $0x1,%edx
  8024b1:	74 7f                	je     802532 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  8024b3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024b6:	83 f8 2f             	cmp    $0x2f,%eax
  8024b9:	0f 87 a2 00 00 00    	ja     802561 <vprintfmt+0x6c2>
  8024bf:	89 c2                	mov    %eax,%edx
  8024c1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024c5:	83 c0 08             	add    $0x8,%eax
  8024c8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024cb:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024ce:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8024d3:	eb 8f                	jmp    802464 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8024d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024d8:	83 f8 2f             	cmp    $0x2f,%eax
  8024db:	77 19                	ja     8024f6 <vprintfmt+0x657>
  8024dd:	89 c2                	mov    %eax,%edx
  8024df:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024e3:	83 c0 08             	add    $0x8,%eax
  8024e6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024e9:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024ec:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8024f1:	e9 6e ff ff ff       	jmp    802464 <vprintfmt+0x5c5>
  8024f6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024fa:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8024fe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802502:	eb e5                	jmp    8024e9 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  802504:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802507:	83 f8 2f             	cmp    $0x2f,%eax
  80250a:	77 18                	ja     802524 <vprintfmt+0x685>
  80250c:	89 c2                	mov    %eax,%edx
  80250e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802512:	83 c0 08             	add    $0x8,%eax
  802515:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802518:	8b 12                	mov    (%rdx),%edx
            base = 16;
  80251a:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  80251f:	e9 40 ff ff ff       	jmp    802464 <vprintfmt+0x5c5>
  802524:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802528:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80252c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802530:	eb e6                	jmp    802518 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  802532:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802535:	83 f8 2f             	cmp    $0x2f,%eax
  802538:	77 19                	ja     802553 <vprintfmt+0x6b4>
  80253a:	89 c2                	mov    %eax,%edx
  80253c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802540:	83 c0 08             	add    $0x8,%eax
  802543:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802546:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802549:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  80254e:	e9 11 ff ff ff       	jmp    802464 <vprintfmt+0x5c5>
  802553:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802557:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80255b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80255f:	eb e5                	jmp    802546 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  802561:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802565:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802569:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80256d:	e9 59 ff ff ff       	jmp    8024cb <vprintfmt+0x62c>
            putch(ch, put_arg);
  802572:	4c 89 ee             	mov    %r13,%rsi
  802575:	bf 25 00 00 00       	mov    $0x25,%edi
  80257a:	41 ff d6             	call   *%r14
            break;
  80257d:	e9 52 f9 ff ff       	jmp    801ed4 <vprintfmt+0x35>
            putch('%', put_arg);
  802582:	4c 89 ee             	mov    %r13,%rsi
  802585:	bf 25 00 00 00       	mov    $0x25,%edi
  80258a:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  80258d:	48 83 eb 01          	sub    $0x1,%rbx
  802591:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  802595:	75 f6                	jne    80258d <vprintfmt+0x6ee>
  802597:	e9 38 f9 ff ff       	jmp    801ed4 <vprintfmt+0x35>
}
  80259c:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8025a0:	5b                   	pop    %rbx
  8025a1:	41 5c                	pop    %r12
  8025a3:	41 5d                	pop    %r13
  8025a5:	41 5e                	pop    %r14
  8025a7:	41 5f                	pop    %r15
  8025a9:	5d                   	pop    %rbp
  8025aa:	c3                   	ret

00000000008025ab <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  8025ab:	f3 0f 1e fa          	endbr64
  8025af:	55                   	push   %rbp
  8025b0:	48 89 e5             	mov    %rsp,%rbp
  8025b3:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  8025b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025bb:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  8025c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8025c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8025cb:	48 85 ff             	test   %rdi,%rdi
  8025ce:	74 2b                	je     8025fb <vsnprintf+0x50>
  8025d0:	48 85 f6             	test   %rsi,%rsi
  8025d3:	74 26                	je     8025fb <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8025d5:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8025d9:	48 bf 42 1e 80 00 00 	movabs $0x801e42,%rdi
  8025e0:	00 00 00 
  8025e3:	48 b8 9f 1e 80 00 00 	movabs $0x801e9f,%rax
  8025ea:	00 00 00 
  8025ed:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8025ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f3:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8025f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025f9:	c9                   	leave
  8025fa:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  8025fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802600:	eb f7                	jmp    8025f9 <vsnprintf+0x4e>

0000000000802602 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  802602:	f3 0f 1e fa          	endbr64
  802606:	55                   	push   %rbp
  802607:	48 89 e5             	mov    %rsp,%rbp
  80260a:	48 83 ec 50          	sub    $0x50,%rsp
  80260e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802612:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802616:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80261a:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  802621:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802625:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802629:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80262d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  802631:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  802635:	48 b8 ab 25 80 00 00 	movabs $0x8025ab,%rax
  80263c:	00 00 00 
  80263f:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  802641:	c9                   	leave
  802642:	c3                   	ret

0000000000802643 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  802643:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  802647:	80 3f 00             	cmpb   $0x0,(%rdi)
  80264a:	74 10                	je     80265c <strlen+0x19>
    size_t n = 0;
  80264c:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  802651:	48 83 c0 01          	add    $0x1,%rax
  802655:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  802659:	75 f6                	jne    802651 <strlen+0xe>
  80265b:	c3                   	ret
    size_t n = 0;
  80265c:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  802661:	c3                   	ret

0000000000802662 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  802662:	f3 0f 1e fa          	endbr64
  802666:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  802669:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  80266e:	48 85 f6             	test   %rsi,%rsi
  802671:	74 10                	je     802683 <strnlen+0x21>
  802673:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  802677:	74 0b                	je     802684 <strnlen+0x22>
  802679:	48 83 c2 01          	add    $0x1,%rdx
  80267d:	48 39 d0             	cmp    %rdx,%rax
  802680:	75 f1                	jne    802673 <strnlen+0x11>
  802682:	c3                   	ret
  802683:	c3                   	ret
  802684:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  802687:	c3                   	ret

0000000000802688 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  802688:	f3 0f 1e fa          	endbr64
  80268c:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80268f:	ba 00 00 00 00       	mov    $0x0,%edx
  802694:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  802698:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  80269b:	48 83 c2 01          	add    $0x1,%rdx
  80269f:	84 c9                	test   %cl,%cl
  8026a1:	75 f1                	jne    802694 <strcpy+0xc>
        ;
    return res;
}
  8026a3:	c3                   	ret

00000000008026a4 <strcat>:

char *
strcat(char *dst, const char *src) {
  8026a4:	f3 0f 1e fa          	endbr64
  8026a8:	55                   	push   %rbp
  8026a9:	48 89 e5             	mov    %rsp,%rbp
  8026ac:	41 54                	push   %r12
  8026ae:	53                   	push   %rbx
  8026af:	48 89 fb             	mov    %rdi,%rbx
  8026b2:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8026b5:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  8026bc:	00 00 00 
  8026bf:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  8026c1:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8026c5:	4c 89 e6             	mov    %r12,%rsi
  8026c8:	48 b8 88 26 80 00 00 	movabs $0x802688,%rax
  8026cf:	00 00 00 
  8026d2:	ff d0                	call   *%rax
    return dst;
}
  8026d4:	48 89 d8             	mov    %rbx,%rax
  8026d7:	5b                   	pop    %rbx
  8026d8:	41 5c                	pop    %r12
  8026da:	5d                   	pop    %rbp
  8026db:	c3                   	ret

00000000008026dc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8026dc:	f3 0f 1e fa          	endbr64
  8026e0:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  8026e3:	48 85 d2             	test   %rdx,%rdx
  8026e6:	74 1f                	je     802707 <strncpy+0x2b>
  8026e8:	48 01 fa             	add    %rdi,%rdx
  8026eb:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  8026ee:	48 83 c1 01          	add    $0x1,%rcx
  8026f2:	44 0f b6 06          	movzbl (%rsi),%r8d
  8026f6:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  8026fa:	41 80 f8 01          	cmp    $0x1,%r8b
  8026fe:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  802702:	48 39 ca             	cmp    %rcx,%rdx
  802705:	75 e7                	jne    8026ee <strncpy+0x12>
    }
    return ret;
}
  802707:	c3                   	ret

0000000000802708 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  802708:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  80270c:	48 89 f8             	mov    %rdi,%rax
  80270f:	48 85 d2             	test   %rdx,%rdx
  802712:	74 24                	je     802738 <strlcpy+0x30>
        while (--size > 0 && *src)
  802714:	48 83 ea 01          	sub    $0x1,%rdx
  802718:	74 1b                	je     802735 <strlcpy+0x2d>
  80271a:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80271e:	0f b6 16             	movzbl (%rsi),%edx
  802721:	84 d2                	test   %dl,%dl
  802723:	74 10                	je     802735 <strlcpy+0x2d>
            *dst++ = *src++;
  802725:	48 83 c6 01          	add    $0x1,%rsi
  802729:	48 83 c0 01          	add    $0x1,%rax
  80272d:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  802730:	48 39 c8             	cmp    %rcx,%rax
  802733:	75 e9                	jne    80271e <strlcpy+0x16>
        *dst = '\0';
  802735:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  802738:	48 29 f8             	sub    %rdi,%rax
}
  80273b:	c3                   	ret

000000000080273c <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  80273c:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  802740:	0f b6 07             	movzbl (%rdi),%eax
  802743:	84 c0                	test   %al,%al
  802745:	74 13                	je     80275a <strcmp+0x1e>
  802747:	38 06                	cmp    %al,(%rsi)
  802749:	75 0f                	jne    80275a <strcmp+0x1e>
  80274b:	48 83 c7 01          	add    $0x1,%rdi
  80274f:	48 83 c6 01          	add    $0x1,%rsi
  802753:	0f b6 07             	movzbl (%rdi),%eax
  802756:	84 c0                	test   %al,%al
  802758:	75 ed                	jne    802747 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  80275a:	0f b6 c0             	movzbl %al,%eax
  80275d:	0f b6 16             	movzbl (%rsi),%edx
  802760:	29 d0                	sub    %edx,%eax
}
  802762:	c3                   	ret

0000000000802763 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  802763:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  802767:	48 85 d2             	test   %rdx,%rdx
  80276a:	74 1f                	je     80278b <strncmp+0x28>
  80276c:	0f b6 07             	movzbl (%rdi),%eax
  80276f:	84 c0                	test   %al,%al
  802771:	74 1e                	je     802791 <strncmp+0x2e>
  802773:	3a 06                	cmp    (%rsi),%al
  802775:	75 1a                	jne    802791 <strncmp+0x2e>
  802777:	48 83 c7 01          	add    $0x1,%rdi
  80277b:	48 83 c6 01          	add    $0x1,%rsi
  80277f:	48 83 ea 01          	sub    $0x1,%rdx
  802783:	75 e7                	jne    80276c <strncmp+0x9>

    if (!n) return 0;
  802785:	b8 00 00 00 00       	mov    $0x0,%eax
  80278a:	c3                   	ret
  80278b:	b8 00 00 00 00       	mov    $0x0,%eax
  802790:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  802791:	0f b6 07             	movzbl (%rdi),%eax
  802794:	0f b6 16             	movzbl (%rsi),%edx
  802797:	29 d0                	sub    %edx,%eax
}
  802799:	c3                   	ret

000000000080279a <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  80279a:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  80279e:	0f b6 17             	movzbl (%rdi),%edx
  8027a1:	84 d2                	test   %dl,%dl
  8027a3:	74 18                	je     8027bd <strchr+0x23>
        if (*str == c) {
  8027a5:	0f be d2             	movsbl %dl,%edx
  8027a8:	39 f2                	cmp    %esi,%edx
  8027aa:	74 17                	je     8027c3 <strchr+0x29>
    for (; *str; str++) {
  8027ac:	48 83 c7 01          	add    $0x1,%rdi
  8027b0:	0f b6 17             	movzbl (%rdi),%edx
  8027b3:	84 d2                	test   %dl,%dl
  8027b5:	75 ee                	jne    8027a5 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  8027b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bc:	c3                   	ret
  8027bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c2:	c3                   	ret
            return (char *)str;
  8027c3:	48 89 f8             	mov    %rdi,%rax
}
  8027c6:	c3                   	ret

00000000008027c7 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  8027c7:	f3 0f 1e fa          	endbr64
  8027cb:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  8027ce:	0f b6 17             	movzbl (%rdi),%edx
  8027d1:	84 d2                	test   %dl,%dl
  8027d3:	74 13                	je     8027e8 <strfind+0x21>
  8027d5:	0f be d2             	movsbl %dl,%edx
  8027d8:	39 f2                	cmp    %esi,%edx
  8027da:	74 0b                	je     8027e7 <strfind+0x20>
  8027dc:	48 83 c0 01          	add    $0x1,%rax
  8027e0:	0f b6 10             	movzbl (%rax),%edx
  8027e3:	84 d2                	test   %dl,%dl
  8027e5:	75 ee                	jne    8027d5 <strfind+0xe>
        ;
    return (char *)str;
}
  8027e7:	c3                   	ret
  8027e8:	c3                   	ret

00000000008027e9 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8027e9:	f3 0f 1e fa          	endbr64
  8027ed:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  8027f0:	48 89 f8             	mov    %rdi,%rax
  8027f3:	48 f7 d8             	neg    %rax
  8027f6:	83 e0 07             	and    $0x7,%eax
  8027f9:	49 89 d1             	mov    %rdx,%r9
  8027fc:	49 29 c1             	sub    %rax,%r9
  8027ff:	78 36                	js     802837 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  802801:	40 0f b6 c6          	movzbl %sil,%eax
  802805:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  80280c:	01 01 01 
  80280f:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  802813:	40 f6 c7 07          	test   $0x7,%dil
  802817:	75 38                	jne    802851 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  802819:	4c 89 c9             	mov    %r9,%rcx
  80281c:	48 c1 f9 03          	sar    $0x3,%rcx
  802820:	74 0c                	je     80282e <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  802822:	fc                   	cld
  802823:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802826:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  80282a:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  80282e:	4d 85 c9             	test   %r9,%r9
  802831:	75 45                	jne    802878 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  802833:	4c 89 c0             	mov    %r8,%rax
  802836:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  802837:	48 85 d2             	test   %rdx,%rdx
  80283a:	74 f7                	je     802833 <memset+0x4a>
  80283c:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  80283f:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  802842:	48 83 c0 01          	add    $0x1,%rax
  802846:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  80284a:	48 39 c2             	cmp    %rax,%rdx
  80284d:	75 f3                	jne    802842 <memset+0x59>
  80284f:	eb e2                	jmp    802833 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  802851:	40 f6 c7 01          	test   $0x1,%dil
  802855:	74 06                	je     80285d <memset+0x74>
  802857:	88 07                	mov    %al,(%rdi)
  802859:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  80285d:	40 f6 c7 02          	test   $0x2,%dil
  802861:	74 07                	je     80286a <memset+0x81>
  802863:	66 89 07             	mov    %ax,(%rdi)
  802866:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  80286a:	40 f6 c7 04          	test   $0x4,%dil
  80286e:	74 a9                	je     802819 <memset+0x30>
  802870:	89 07                	mov    %eax,(%rdi)
  802872:	48 83 c7 04          	add    $0x4,%rdi
  802876:	eb a1                	jmp    802819 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  802878:	41 f6 c1 04          	test   $0x4,%r9b
  80287c:	74 1b                	je     802899 <memset+0xb0>
  80287e:	89 07                	mov    %eax,(%rdi)
  802880:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  802884:	41 f6 c1 02          	test   $0x2,%r9b
  802888:	74 07                	je     802891 <memset+0xa8>
  80288a:	66 89 07             	mov    %ax,(%rdi)
  80288d:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  802891:	41 f6 c1 01          	test   $0x1,%r9b
  802895:	74 9c                	je     802833 <memset+0x4a>
  802897:	eb 06                	jmp    80289f <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  802899:	41 f6 c1 02          	test   $0x2,%r9b
  80289d:	75 eb                	jne    80288a <memset+0xa1>
        if (ni & 1) *ptr = k;
  80289f:	88 07                	mov    %al,(%rdi)
  8028a1:	eb 90                	jmp    802833 <memset+0x4a>

00000000008028a3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8028a3:	f3 0f 1e fa          	endbr64
  8028a7:	48 89 f8             	mov    %rdi,%rax
  8028aa:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8028ad:	48 39 fe             	cmp    %rdi,%rsi
  8028b0:	73 3b                	jae    8028ed <memmove+0x4a>
  8028b2:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8028b6:	48 39 d7             	cmp    %rdx,%rdi
  8028b9:	73 32                	jae    8028ed <memmove+0x4a>
        s += n;
        d += n;
  8028bb:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028bf:	48 89 d6             	mov    %rdx,%rsi
  8028c2:	48 09 fe             	or     %rdi,%rsi
  8028c5:	48 09 ce             	or     %rcx,%rsi
  8028c8:	40 f6 c6 07          	test   $0x7,%sil
  8028cc:	75 12                	jne    8028e0 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8028ce:	48 83 ef 08          	sub    $0x8,%rdi
  8028d2:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8028d6:	48 c1 e9 03          	shr    $0x3,%rcx
  8028da:	fd                   	std
  8028db:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8028de:	fc                   	cld
  8028df:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8028e0:	48 83 ef 01          	sub    $0x1,%rdi
  8028e4:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8028e8:	fd                   	std
  8028e9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8028eb:	eb f1                	jmp    8028de <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028ed:	48 89 f2             	mov    %rsi,%rdx
  8028f0:	48 09 c2             	or     %rax,%rdx
  8028f3:	48 09 ca             	or     %rcx,%rdx
  8028f6:	f6 c2 07             	test   $0x7,%dl
  8028f9:	75 0c                	jne    802907 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8028fb:	48 c1 e9 03          	shr    $0x3,%rcx
  8028ff:	48 89 c7             	mov    %rax,%rdi
  802902:	fc                   	cld
  802903:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  802906:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  802907:	48 89 c7             	mov    %rax,%rdi
  80290a:	fc                   	cld
  80290b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  80290d:	c3                   	ret

000000000080290e <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  80290e:	f3 0f 1e fa          	endbr64
  802912:	55                   	push   %rbp
  802913:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802916:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  80291d:	00 00 00 
  802920:	ff d0                	call   *%rax
}
  802922:	5d                   	pop    %rbp
  802923:	c3                   	ret

0000000000802924 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  802924:	f3 0f 1e fa          	endbr64
  802928:	55                   	push   %rbp
  802929:	48 89 e5             	mov    %rsp,%rbp
  80292c:	41 57                	push   %r15
  80292e:	41 56                	push   %r14
  802930:	41 55                	push   %r13
  802932:	41 54                	push   %r12
  802934:	53                   	push   %rbx
  802935:	48 83 ec 08          	sub    $0x8,%rsp
  802939:	49 89 fe             	mov    %rdi,%r14
  80293c:	49 89 f7             	mov    %rsi,%r15
  80293f:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  802942:	48 89 f7             	mov    %rsi,%rdi
  802945:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  80294c:	00 00 00 
  80294f:	ff d0                	call   *%rax
  802951:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  802954:	48 89 de             	mov    %rbx,%rsi
  802957:	4c 89 f7             	mov    %r14,%rdi
  80295a:	48 b8 62 26 80 00 00 	movabs $0x802662,%rax
  802961:	00 00 00 
  802964:	ff d0                	call   *%rax
  802966:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  802969:	48 39 c3             	cmp    %rax,%rbx
  80296c:	74 36                	je     8029a4 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  80296e:	48 89 d8             	mov    %rbx,%rax
  802971:	4c 29 e8             	sub    %r13,%rax
  802974:	49 39 c4             	cmp    %rax,%r12
  802977:	73 31                	jae    8029aa <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  802979:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  80297e:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  802982:	4c 89 fe             	mov    %r15,%rsi
  802985:	48 b8 0e 29 80 00 00 	movabs $0x80290e,%rax
  80298c:	00 00 00 
  80298f:	ff d0                	call   *%rax
    return dstlen + srclen;
  802991:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  802995:	48 83 c4 08          	add    $0x8,%rsp
  802999:	5b                   	pop    %rbx
  80299a:	41 5c                	pop    %r12
  80299c:	41 5d                	pop    %r13
  80299e:	41 5e                	pop    %r14
  8029a0:	41 5f                	pop    %r15
  8029a2:	5d                   	pop    %rbp
  8029a3:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  8029a4:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  8029a8:	eb eb                	jmp    802995 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  8029aa:	48 83 eb 01          	sub    $0x1,%rbx
  8029ae:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8029b2:	48 89 da             	mov    %rbx,%rdx
  8029b5:	4c 89 fe             	mov    %r15,%rsi
  8029b8:	48 b8 0e 29 80 00 00 	movabs $0x80290e,%rax
  8029bf:	00 00 00 
  8029c2:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8029c4:	49 01 de             	add    %rbx,%r14
  8029c7:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8029cc:	eb c3                	jmp    802991 <strlcat+0x6d>

00000000008029ce <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8029ce:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8029d2:	48 85 d2             	test   %rdx,%rdx
  8029d5:	74 2d                	je     802a04 <memcmp+0x36>
  8029d7:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8029dc:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8029e0:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8029e5:	44 38 c1             	cmp    %r8b,%cl
  8029e8:	75 0f                	jne    8029f9 <memcmp+0x2b>
    while (n-- > 0) {
  8029ea:	48 83 c0 01          	add    $0x1,%rax
  8029ee:	48 39 c2             	cmp    %rax,%rdx
  8029f1:	75 e9                	jne    8029dc <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8029f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f8:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8029f9:	0f b6 c1             	movzbl %cl,%eax
  8029fc:	45 0f b6 c0          	movzbl %r8b,%r8d
  802a00:	44 29 c0             	sub    %r8d,%eax
  802a03:	c3                   	ret
    return 0;
  802a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a09:	c3                   	ret

0000000000802a0a <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  802a0a:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  802a0e:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802a12:	48 39 c7             	cmp    %rax,%rdi
  802a15:	73 0f                	jae    802a26 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802a17:	40 38 37             	cmp    %sil,(%rdi)
  802a1a:	74 0e                	je     802a2a <memfind+0x20>
    for (; src < end; src++) {
  802a1c:	48 83 c7 01          	add    $0x1,%rdi
  802a20:	48 39 f8             	cmp    %rdi,%rax
  802a23:	75 f2                	jne    802a17 <memfind+0xd>
  802a25:	c3                   	ret
  802a26:	48 89 f8             	mov    %rdi,%rax
  802a29:	c3                   	ret
  802a2a:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802a2d:	c3                   	ret

0000000000802a2e <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802a2e:	f3 0f 1e fa          	endbr64
  802a32:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802a35:	0f b6 37             	movzbl (%rdi),%esi
  802a38:	40 80 fe 20          	cmp    $0x20,%sil
  802a3c:	74 06                	je     802a44 <strtol+0x16>
  802a3e:	40 80 fe 09          	cmp    $0x9,%sil
  802a42:	75 13                	jne    802a57 <strtol+0x29>
  802a44:	48 83 c7 01          	add    $0x1,%rdi
  802a48:	0f b6 37             	movzbl (%rdi),%esi
  802a4b:	40 80 fe 20          	cmp    $0x20,%sil
  802a4f:	74 f3                	je     802a44 <strtol+0x16>
  802a51:	40 80 fe 09          	cmp    $0x9,%sil
  802a55:	74 ed                	je     802a44 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802a57:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802a5a:	83 e0 fd             	and    $0xfffffffd,%eax
  802a5d:	3c 01                	cmp    $0x1,%al
  802a5f:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a63:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  802a69:	75 0f                	jne    802a7a <strtol+0x4c>
  802a6b:	80 3f 30             	cmpb   $0x30,(%rdi)
  802a6e:	74 14                	je     802a84 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802a70:	85 d2                	test   %edx,%edx
  802a72:	b8 0a 00 00 00       	mov    $0xa,%eax
  802a77:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  802a7a:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  802a7f:	4c 63 ca             	movslq %edx,%r9
  802a82:	eb 36                	jmp    802aba <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a84:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  802a88:	74 0f                	je     802a99 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  802a8a:	85 d2                	test   %edx,%edx
  802a8c:	75 ec                	jne    802a7a <strtol+0x4c>
        s++;
  802a8e:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  802a92:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  802a97:	eb e1                	jmp    802a7a <strtol+0x4c>
        s += 2;
  802a99:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  802a9d:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  802aa2:	eb d6                	jmp    802a7a <strtol+0x4c>
            dig -= '0';
  802aa4:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  802aa7:	44 0f b6 c1          	movzbl %cl,%r8d
  802aab:	41 39 d0             	cmp    %edx,%r8d
  802aae:	7d 21                	jge    802ad1 <strtol+0xa3>
        val = val * base + dig;
  802ab0:	49 0f af c1          	imul   %r9,%rax
  802ab4:	0f b6 c9             	movzbl %cl,%ecx
  802ab7:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  802aba:	48 83 c7 01          	add    $0x1,%rdi
  802abe:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  802ac2:	80 f9 39             	cmp    $0x39,%cl
  802ac5:	76 dd                	jbe    802aa4 <strtol+0x76>
        else if (dig - 'a' < 27)
  802ac7:	80 f9 7b             	cmp    $0x7b,%cl
  802aca:	77 05                	ja     802ad1 <strtol+0xa3>
            dig -= 'a' - 10;
  802acc:	83 e9 57             	sub    $0x57,%ecx
  802acf:	eb d6                	jmp    802aa7 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  802ad1:	4d 85 d2             	test   %r10,%r10
  802ad4:	74 03                	je     802ad9 <strtol+0xab>
  802ad6:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802ad9:	48 89 c2             	mov    %rax,%rdx
  802adc:	48 f7 da             	neg    %rdx
  802adf:	40 80 fe 2d          	cmp    $0x2d,%sil
  802ae3:	48 0f 44 c2          	cmove  %rdx,%rax
}
  802ae7:	c3                   	ret

0000000000802ae8 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802ae8:	f3 0f 1e fa          	endbr64
  802aec:	55                   	push   %rbp
  802aed:	48 89 e5             	mov    %rsp,%rbp
  802af0:	41 54                	push   %r12
  802af2:	53                   	push   %rbx
  802af3:	48 89 fb             	mov    %rdi,%rbx
  802af6:	48 89 f7             	mov    %rsi,%rdi
  802af9:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802afc:	48 85 f6             	test   %rsi,%rsi
  802aff:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b06:	00 00 00 
  802b09:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b0d:	be 00 10 00 00       	mov    $0x1000,%esi
  802b12:	48 b8 da 05 80 00 00 	movabs $0x8005da,%rax
  802b19:	00 00 00 
  802b1c:	ff d0                	call   *%rax
    if (res < 0) {
  802b1e:	85 c0                	test   %eax,%eax
  802b20:	78 45                	js     802b67 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b22:	48 85 db             	test   %rbx,%rbx
  802b25:	74 12                	je     802b39 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b27:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b2e:	00 00 00 
  802b31:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b37:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b39:	4d 85 e4             	test   %r12,%r12
  802b3c:	74 14                	je     802b52 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b3e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b45:	00 00 00 
  802b48:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b4e:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b52:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b59:	00 00 00 
  802b5c:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b62:	5b                   	pop    %rbx
  802b63:	41 5c                	pop    %r12
  802b65:	5d                   	pop    %rbp
  802b66:	c3                   	ret
        if (from_env_store != NULL) {
  802b67:	48 85 db             	test   %rbx,%rbx
  802b6a:	74 06                	je     802b72 <ipc_recv+0x8a>
            *from_env_store = 0;
  802b6c:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b72:	4d 85 e4             	test   %r12,%r12
  802b75:	74 eb                	je     802b62 <ipc_recv+0x7a>
            *perm_store = 0;
  802b77:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b7e:	00 
  802b7f:	eb e1                	jmp    802b62 <ipc_recv+0x7a>

0000000000802b81 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b81:	f3 0f 1e fa          	endbr64
  802b85:	55                   	push   %rbp
  802b86:	48 89 e5             	mov    %rsp,%rbp
  802b89:	41 57                	push   %r15
  802b8b:	41 56                	push   %r14
  802b8d:	41 55                	push   %r13
  802b8f:	41 54                	push   %r12
  802b91:	53                   	push   %rbx
  802b92:	48 83 ec 18          	sub    $0x18,%rsp
  802b96:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802b99:	48 89 d3             	mov    %rdx,%rbx
  802b9c:	49 89 cc             	mov    %rcx,%r12
  802b9f:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802ba2:	48 85 d2             	test   %rdx,%rdx
  802ba5:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bac:	00 00 00 
  802baf:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bb3:	89 f0                	mov    %esi,%eax
  802bb5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802bb9:	48 89 da             	mov    %rbx,%rdx
  802bbc:	48 89 c6             	mov    %rax,%rsi
  802bbf:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  802bc6:	00 00 00 
  802bc9:	ff d0                	call   *%rax
    while (res < 0) {
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	79 65                	jns    802c34 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bcf:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bd2:	75 33                	jne    802c07 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802bd4:	49 bf 1d 02 80 00 00 	movabs $0x80021d,%r15
  802bdb:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bde:	49 be aa 05 80 00 00 	movabs $0x8005aa,%r14
  802be5:	00 00 00 
        sys_yield();
  802be8:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802beb:	45 89 e8             	mov    %r13d,%r8d
  802bee:	4c 89 e1             	mov    %r12,%rcx
  802bf1:	48 89 da             	mov    %rbx,%rdx
  802bf4:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802bf8:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802bfb:	41 ff d6             	call   *%r14
    while (res < 0) {
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	79 32                	jns    802c34 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c02:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c05:	74 e1                	je     802be8 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c07:	89 c1                	mov    %eax,%ecx
  802c09:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  802c10:	00 00 00 
  802c13:	be 42 00 00 00       	mov    $0x42,%esi
  802c18:	48 bf 4b 32 80 00 00 	movabs $0x80324b,%rdi
  802c1f:	00 00 00 
  802c22:	b8 00 00 00 00       	mov    $0x0,%eax
  802c27:	49 b8 e3 1b 80 00 00 	movabs $0x801be3,%r8
  802c2e:	00 00 00 
  802c31:	41 ff d0             	call   *%r8
    }
}
  802c34:	48 83 c4 18          	add    $0x18,%rsp
  802c38:	5b                   	pop    %rbx
  802c39:	41 5c                	pop    %r12
  802c3b:	41 5d                	pop    %r13
  802c3d:	41 5e                	pop    %r14
  802c3f:	41 5f                	pop    %r15
  802c41:	5d                   	pop    %rbp
  802c42:	c3                   	ret

0000000000802c43 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c43:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c47:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c4c:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c53:	00 00 00 
  802c56:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c5a:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c5e:	48 c1 e2 04          	shl    $0x4,%rdx
  802c62:	48 01 ca             	add    %rcx,%rdx
  802c65:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c6b:	39 fa                	cmp    %edi,%edx
  802c6d:	74 12                	je     802c81 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c6f:	48 83 c0 01          	add    $0x1,%rax
  802c73:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c79:	75 db                	jne    802c56 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802c7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c80:	c3                   	ret
            return envs[i].env_id;
  802c81:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c85:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c89:	48 c1 e2 04          	shl    $0x4,%rdx
  802c8d:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802c94:	00 00 00 
  802c97:	48 01 d0             	add    %rdx,%rax
  802c9a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ca0:	c3                   	ret

0000000000802ca1 <__text_end>:
  802ca1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ca8:	00 00 00 
  802cab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cb2:	00 00 00 
  802cb5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cbc:	00 00 00 
  802cbf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cc6:	00 00 00 
  802cc9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cd0:	00 00 00 
  802cd3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cda:	00 00 00 
  802cdd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ce4:	00 00 00 
  802ce7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cee:	00 00 00 
  802cf1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cf8:	00 00 00 
  802cfb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d02:	00 00 00 
  802d05:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d0c:	00 00 00 
  802d0f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d16:	00 00 00 
  802d19:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d20:	00 00 00 
  802d23:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d2a:	00 00 00 
  802d2d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d34:	00 00 00 
  802d37:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d3e:	00 00 00 
  802d41:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d48:	00 00 00 
  802d4b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d52:	00 00 00 
  802d55:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d5c:	00 00 00 
  802d5f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d66:	00 00 00 
  802d69:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d70:	00 00 00 
  802d73:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d7a:	00 00 00 
  802d7d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d84:	00 00 00 
  802d87:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d8e:	00 00 00 
  802d91:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d98:	00 00 00 
  802d9b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802da2:	00 00 00 
  802da5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dac:	00 00 00 
  802daf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802db6:	00 00 00 
  802db9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dc0:	00 00 00 
  802dc3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dca:	00 00 00 
  802dcd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd4:	00 00 00 
  802dd7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dde:	00 00 00 
  802de1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de8:	00 00 00 
  802deb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df2:	00 00 00 
  802df5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dfc:	00 00 00 
  802dff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e06:	00 00 00 
  802e09:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e10:	00 00 00 
  802e13:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e1a:	00 00 00 
  802e1d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e24:	00 00 00 
  802e27:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e2e:	00 00 00 
  802e31:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e38:	00 00 00 
  802e3b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e42:	00 00 00 
  802e45:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e4c:	00 00 00 
  802e4f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e56:	00 00 00 
  802e59:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e60:	00 00 00 
  802e63:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e6a:	00 00 00 
  802e6d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e74:	00 00 00 
  802e77:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e7e:	00 00 00 
  802e81:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e88:	00 00 00 
  802e8b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e92:	00 00 00 
  802e95:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e9c:	00 00 00 
  802e9f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea6:	00 00 00 
  802ea9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb0:	00 00 00 
  802eb3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eba:	00 00 00 
  802ebd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec4:	00 00 00 
  802ec7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ece:	00 00 00 
  802ed1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed8:	00 00 00 
  802edb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee2:	00 00 00 
  802ee5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eec:	00 00 00 
  802eef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef6:	00 00 00 
  802ef9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f00:	00 00 00 
  802f03:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f0a:	00 00 00 
  802f0d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f14:	00 00 00 
  802f17:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f1e:	00 00 00 
  802f21:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f28:	00 00 00 
  802f2b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f32:	00 00 00 
  802f35:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f3c:	00 00 00 
  802f3f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f46:	00 00 00 
  802f49:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f50:	00 00 00 
  802f53:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f5a:	00 00 00 
  802f5d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f64:	00 00 00 
  802f67:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f6e:	00 00 00 
  802f71:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f78:	00 00 00 
  802f7b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f82:	00 00 00 
  802f85:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f8c:	00 00 00 
  802f8f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f96:	00 00 00 
  802f99:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa0:	00 00 00 
  802fa3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802faa:	00 00 00 
  802fad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb4:	00 00 00 
  802fb7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fbe:	00 00 00 
  802fc1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc8:	00 00 00 
  802fcb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd2:	00 00 00 
  802fd5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fdc:	00 00 00 
  802fdf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe6:	00 00 00 
  802fe9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff0:	00 00 00 
  802ff3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ffa:	00 00 00 
  802ffd:	0f 1f 00             	nopl   (%rax)
