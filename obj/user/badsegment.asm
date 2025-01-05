
obj/user/badsegment:     file format elf64-x86-64


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
  80001e:	e8 0d 00 00 00       	call   800030 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* Program to cause a general protection exception */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
    /* Try to load the kernel's TSS selector into the DS register. */
    asm volatile("movw $0x38,%ax; movw %ax,%ds");
  800029:	66 b8 38 00          	mov    $0x38,%ax
  80002d:	8e d8                	mov    %eax,%ds
}
  80002f:	c3                   	ret

0000000000800030 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800030:	f3 0f 1e fa          	endbr64
  800034:	55                   	push   %rbp
  800035:	48 89 e5             	mov    %rsp,%rbp
  800038:	41 56                	push   %r14
  80003a:	41 55                	push   %r13
  80003c:	41 54                	push   %r12
  80003e:	53                   	push   %rbx
  80003f:	41 89 fd             	mov    %edi,%r13d
  800042:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800045:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80004c:	00 00 00 
  80004f:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800056:	00 00 00 
  800059:	48 39 c2             	cmp    %rax,%rdx
  80005c:	73 17                	jae    800075 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80005e:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800061:	49 89 c4             	mov    %rax,%r12
  800064:	48 83 c3 08          	add    $0x8,%rbx
  800068:	b8 00 00 00 00       	mov    $0x0,%eax
  80006d:	ff 53 f8             	call   *-0x8(%rbx)
  800070:	4c 39 e3             	cmp    %r12,%rbx
  800073:	72 ef                	jb     800064 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800075:	48 b8 de 01 80 00 00 	movabs $0x8001de,%rax
  80007c:	00 00 00 
  80007f:	ff d0                	call   *%rax
  800081:	25 ff 03 00 00       	and    $0x3ff,%eax
  800086:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80008a:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80008e:	48 c1 e0 04          	shl    $0x4,%rax
  800092:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800099:	00 00 00 
  80009c:	48 01 d0             	add    %rdx,%rax
  80009f:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000a6:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000a9:	45 85 ed             	test   %r13d,%r13d
  8000ac:	7e 0d                	jle    8000bb <libmain+0x8b>
  8000ae:	49 8b 06             	mov    (%r14),%rax
  8000b1:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000b8:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000bb:	4c 89 f6             	mov    %r14,%rsi
  8000be:	44 89 ef             	mov    %r13d,%edi
  8000c1:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000c8:	00 00 00 
  8000cb:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000cd:	48 b8 e2 00 80 00 00 	movabs $0x8000e2,%rax
  8000d4:	00 00 00 
  8000d7:	ff d0                	call   *%rax
#endif
}
  8000d9:	5b                   	pop    %rbx
  8000da:	41 5c                	pop    %r12
  8000dc:	41 5d                	pop    %r13
  8000de:	41 5e                	pop    %r14
  8000e0:	5d                   	pop    %rbp
  8000e1:	c3                   	ret

00000000008000e2 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000e2:	f3 0f 1e fa          	endbr64
  8000e6:	55                   	push   %rbp
  8000e7:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000ea:	48 b8 b4 08 80 00 00 	movabs $0x8008b4,%rax
  8000f1:	00 00 00 
  8000f4:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8000f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8000fb:	48 b8 6f 01 80 00 00 	movabs $0x80016f,%rax
  800102:	00 00 00 
  800105:	ff d0                	call   *%rax
}
  800107:	5d                   	pop    %rbp
  800108:	c3                   	ret

0000000000800109 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800109:	f3 0f 1e fa          	endbr64
  80010d:	55                   	push   %rbp
  80010e:	48 89 e5             	mov    %rsp,%rbp
  800111:	53                   	push   %rbx
  800112:	48 89 fa             	mov    %rdi,%rdx
  800115:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800118:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80011d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800122:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800127:	be 00 00 00 00       	mov    $0x0,%esi
  80012c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800132:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800134:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800138:	c9                   	leave
  800139:	c3                   	ret

000000000080013a <sys_cgetc>:

int
sys_cgetc(void) {
  80013a:	f3 0f 1e fa          	endbr64
  80013e:	55                   	push   %rbp
  80013f:	48 89 e5             	mov    %rsp,%rbp
  800142:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800143:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800148:	ba 00 00 00 00       	mov    $0x0,%edx
  80014d:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800152:	bb 00 00 00 00       	mov    $0x0,%ebx
  800157:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80015c:	be 00 00 00 00       	mov    $0x0,%esi
  800161:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800167:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800169:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80016d:	c9                   	leave
  80016e:	c3                   	ret

000000000080016f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80016f:	f3 0f 1e fa          	endbr64
  800173:	55                   	push   %rbp
  800174:	48 89 e5             	mov    %rsp,%rbp
  800177:	53                   	push   %rbx
  800178:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80017c:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80017f:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800184:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800189:	bb 00 00 00 00       	mov    $0x0,%ebx
  80018e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800193:	be 00 00 00 00       	mov    $0x0,%esi
  800198:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80019e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001a0:	48 85 c0             	test   %rax,%rax
  8001a3:	7f 06                	jg     8001ab <sys_env_destroy+0x3c>
}
  8001a5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001a9:	c9                   	leave
  8001aa:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001ab:	49 89 c0             	mov    %rax,%r8
  8001ae:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001b3:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8001ba:	00 00 00 
  8001bd:	be 26 00 00 00       	mov    $0x26,%esi
  8001c2:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8001c9:	00 00 00 
  8001cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d1:	49 b9 d9 1b 80 00 00 	movabs $0x801bd9,%r9
  8001d8:	00 00 00 
  8001db:	41 ff d1             	call   *%r9

00000000008001de <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001de:	f3 0f 1e fa          	endbr64
  8001e2:	55                   	push   %rbp
  8001e3:	48 89 e5             	mov    %rsp,%rbp
  8001e6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001e7:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8001f1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001fb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800200:	be 00 00 00 00       	mov    $0x0,%esi
  800205:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80020b:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80020d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800211:	c9                   	leave
  800212:	c3                   	ret

0000000000800213 <sys_yield>:

void
sys_yield(void) {
  800213:	f3 0f 1e fa          	endbr64
  800217:	55                   	push   %rbp
  800218:	48 89 e5             	mov    %rsp,%rbp
  80021b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80021c:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800221:	ba 00 00 00 00       	mov    $0x0,%edx
  800226:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80022b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800230:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800235:	be 00 00 00 00       	mov    $0x0,%esi
  80023a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800240:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  800242:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800246:	c9                   	leave
  800247:	c3                   	ret

0000000000800248 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  800248:	f3 0f 1e fa          	endbr64
  80024c:	55                   	push   %rbp
  80024d:	48 89 e5             	mov    %rsp,%rbp
  800250:	53                   	push   %rbx
  800251:	48 89 fa             	mov    %rdi,%rdx
  800254:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800257:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80025c:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800263:	00 00 00 
  800266:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80026b:	be 00 00 00 00       	mov    $0x0,%esi
  800270:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800276:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800278:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80027c:	c9                   	leave
  80027d:	c3                   	ret

000000000080027e <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80027e:	f3 0f 1e fa          	endbr64
  800282:	55                   	push   %rbp
  800283:	48 89 e5             	mov    %rsp,%rbp
  800286:	53                   	push   %rbx
  800287:	49 89 f8             	mov    %rdi,%r8
  80028a:	48 89 d3             	mov    %rdx,%rbx
  80028d:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  800290:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800295:	4c 89 c2             	mov    %r8,%rdx
  800298:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80029b:	be 00 00 00 00       	mov    $0x0,%esi
  8002a0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002a6:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002a8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002ac:	c9                   	leave
  8002ad:	c3                   	ret

00000000008002ae <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002ae:	f3 0f 1e fa          	endbr64
  8002b2:	55                   	push   %rbp
  8002b3:	48 89 e5             	mov    %rsp,%rbp
  8002b6:	53                   	push   %rbx
  8002b7:	48 83 ec 08          	sub    $0x8,%rsp
  8002bb:	89 f8                	mov    %edi,%eax
  8002bd:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002c0:	48 63 f9             	movslq %ecx,%rdi
  8002c3:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002c6:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002cb:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002ce:	be 00 00 00 00       	mov    $0x0,%esi
  8002d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002d9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002db:	48 85 c0             	test   %rax,%rax
  8002de:	7f 06                	jg     8002e6 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002e0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002e4:	c9                   	leave
  8002e5:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002e6:	49 89 c0             	mov    %rax,%r8
  8002e9:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002ee:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8002f5:	00 00 00 
  8002f8:	be 26 00 00 00       	mov    $0x26,%esi
  8002fd:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800304:	00 00 00 
  800307:	b8 00 00 00 00       	mov    $0x0,%eax
  80030c:	49 b9 d9 1b 80 00 00 	movabs $0x801bd9,%r9
  800313:	00 00 00 
  800316:	41 ff d1             	call   *%r9

0000000000800319 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  800319:	f3 0f 1e fa          	endbr64
  80031d:	55                   	push   %rbp
  80031e:	48 89 e5             	mov    %rsp,%rbp
  800321:	53                   	push   %rbx
  800322:	48 83 ec 08          	sub    $0x8,%rsp
  800326:	89 f8                	mov    %edi,%eax
  800328:	49 89 f2             	mov    %rsi,%r10
  80032b:	48 89 cf             	mov    %rcx,%rdi
  80032e:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  800331:	48 63 da             	movslq %edx,%rbx
  800334:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800337:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80033c:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80033f:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  800342:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800344:	48 85 c0             	test   %rax,%rax
  800347:	7f 06                	jg     80034f <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  800349:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80034d:	c9                   	leave
  80034e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80034f:	49 89 c0             	mov    %rax,%r8
  800352:	b9 05 00 00 00       	mov    $0x5,%ecx
  800357:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80035e:	00 00 00 
  800361:	be 26 00 00 00       	mov    $0x26,%esi
  800366:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80036d:	00 00 00 
  800370:	b8 00 00 00 00       	mov    $0x0,%eax
  800375:	49 b9 d9 1b 80 00 00 	movabs $0x801bd9,%r9
  80037c:	00 00 00 
  80037f:	41 ff d1             	call   *%r9

0000000000800382 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  800382:	f3 0f 1e fa          	endbr64
  800386:	55                   	push   %rbp
  800387:	48 89 e5             	mov    %rsp,%rbp
  80038a:	53                   	push   %rbx
  80038b:	48 83 ec 08          	sub    $0x8,%rsp
  80038f:	49 89 f9             	mov    %rdi,%r9
  800392:	89 f0                	mov    %esi,%eax
  800394:	48 89 d3             	mov    %rdx,%rbx
  800397:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80039a:	49 63 f0             	movslq %r8d,%rsi
  80039d:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8003a0:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8003a5:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003ae:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003b0:	48 85 c0             	test   %rax,%rax
  8003b3:	7f 06                	jg     8003bb <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8003b5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003b9:	c9                   	leave
  8003ba:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003bb:	49 89 c0             	mov    %rax,%r8
  8003be:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003c3:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8003ca:	00 00 00 
  8003cd:	be 26 00 00 00       	mov    $0x26,%esi
  8003d2:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8003d9:	00 00 00 
  8003dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e1:	49 b9 d9 1b 80 00 00 	movabs $0x801bd9,%r9
  8003e8:	00 00 00 
  8003eb:	41 ff d1             	call   *%r9

00000000008003ee <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8003ee:	f3 0f 1e fa          	endbr64
  8003f2:	55                   	push   %rbp
  8003f3:	48 89 e5             	mov    %rsp,%rbp
  8003f6:	53                   	push   %rbx
  8003f7:	48 83 ec 08          	sub    $0x8,%rsp
  8003fb:	48 89 f1             	mov    %rsi,%rcx
  8003fe:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  800401:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800404:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800409:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80040e:	be 00 00 00 00       	mov    $0x0,%esi
  800413:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800419:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80041b:	48 85 c0             	test   %rax,%rax
  80041e:	7f 06                	jg     800426 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  800420:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800424:	c9                   	leave
  800425:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800426:	49 89 c0             	mov    %rax,%r8
  800429:	b9 07 00 00 00       	mov    $0x7,%ecx
  80042e:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800435:	00 00 00 
  800438:	be 26 00 00 00       	mov    $0x26,%esi
  80043d:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800444:	00 00 00 
  800447:	b8 00 00 00 00       	mov    $0x0,%eax
  80044c:	49 b9 d9 1b 80 00 00 	movabs $0x801bd9,%r9
  800453:	00 00 00 
  800456:	41 ff d1             	call   *%r9

0000000000800459 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  800459:	f3 0f 1e fa          	endbr64
  80045d:	55                   	push   %rbp
  80045e:	48 89 e5             	mov    %rsp,%rbp
  800461:	53                   	push   %rbx
  800462:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  800466:	48 63 ce             	movslq %esi,%rcx
  800469:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80046c:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800471:	bb 00 00 00 00       	mov    $0x0,%ebx
  800476:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80047b:	be 00 00 00 00       	mov    $0x0,%esi
  800480:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800486:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800488:	48 85 c0             	test   %rax,%rax
  80048b:	7f 06                	jg     800493 <sys_env_set_status+0x3a>
}
  80048d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800491:	c9                   	leave
  800492:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800493:	49 89 c0             	mov    %rax,%r8
  800496:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80049b:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8004a2:	00 00 00 
  8004a5:	be 26 00 00 00       	mov    $0x26,%esi
  8004aa:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8004b1:	00 00 00 
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	49 b9 d9 1b 80 00 00 	movabs $0x801bd9,%r9
  8004c0:	00 00 00 
  8004c3:	41 ff d1             	call   *%r9

00000000008004c6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8004c6:	f3 0f 1e fa          	endbr64
  8004ca:	55                   	push   %rbp
  8004cb:	48 89 e5             	mov    %rsp,%rbp
  8004ce:	53                   	push   %rbx
  8004cf:	48 83 ec 08          	sub    $0x8,%rsp
  8004d3:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8004d6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004d9:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004e3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004e8:	be 00 00 00 00       	mov    $0x0,%esi
  8004ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004f3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004f5:	48 85 c0             	test   %rax,%rax
  8004f8:	7f 06                	jg     800500 <sys_env_set_trapframe+0x3a>
}
  8004fa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004fe:	c9                   	leave
  8004ff:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800500:	49 89 c0             	mov    %rax,%r8
  800503:	b9 0b 00 00 00       	mov    $0xb,%ecx
  800508:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80050f:	00 00 00 
  800512:	be 26 00 00 00       	mov    $0x26,%esi
  800517:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80051e:	00 00 00 
  800521:	b8 00 00 00 00       	mov    $0x0,%eax
  800526:	49 b9 d9 1b 80 00 00 	movabs $0x801bd9,%r9
  80052d:	00 00 00 
  800530:	41 ff d1             	call   *%r9

0000000000800533 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  800533:	f3 0f 1e fa          	endbr64
  800537:	55                   	push   %rbp
  800538:	48 89 e5             	mov    %rsp,%rbp
  80053b:	53                   	push   %rbx
  80053c:	48 83 ec 08          	sub    $0x8,%rsp
  800540:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  800543:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800546:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80054b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800550:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800555:	be 00 00 00 00       	mov    $0x0,%esi
  80055a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800560:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800562:	48 85 c0             	test   %rax,%rax
  800565:	7f 06                	jg     80056d <sys_env_set_pgfault_upcall+0x3a>
}
  800567:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80056b:	c9                   	leave
  80056c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80056d:	49 89 c0             	mov    %rax,%r8
  800570:	b9 0c 00 00 00       	mov    $0xc,%ecx
  800575:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80057c:	00 00 00 
  80057f:	be 26 00 00 00       	mov    $0x26,%esi
  800584:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80058b:	00 00 00 
  80058e:	b8 00 00 00 00       	mov    $0x0,%eax
  800593:	49 b9 d9 1b 80 00 00 	movabs $0x801bd9,%r9
  80059a:	00 00 00 
  80059d:	41 ff d1             	call   *%r9

00000000008005a0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8005a0:	f3 0f 1e fa          	endbr64
  8005a4:	55                   	push   %rbp
  8005a5:	48 89 e5             	mov    %rsp,%rbp
  8005a8:	53                   	push   %rbx
  8005a9:	89 f8                	mov    %edi,%eax
  8005ab:	49 89 f1             	mov    %rsi,%r9
  8005ae:	48 89 d3             	mov    %rdx,%rbx
  8005b1:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8005b4:	49 63 f0             	movslq %r8d,%rsi
  8005b7:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8005ba:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005bf:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005c8:	cd 30                	int    $0x30
}
  8005ca:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005ce:	c9                   	leave
  8005cf:	c3                   	ret

00000000008005d0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8005d0:	f3 0f 1e fa          	endbr64
  8005d4:	55                   	push   %rbp
  8005d5:	48 89 e5             	mov    %rsp,%rbp
  8005d8:	53                   	push   %rbx
  8005d9:	48 83 ec 08          	sub    $0x8,%rsp
  8005dd:	48 89 fa             	mov    %rdi,%rdx
  8005e0:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8005e3:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005ed:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005f2:	be 00 00 00 00       	mov    $0x0,%esi
  8005f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005fd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8005ff:	48 85 c0             	test   %rax,%rax
  800602:	7f 06                	jg     80060a <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800604:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800608:	c9                   	leave
  800609:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80060a:	49 89 c0             	mov    %rax,%r8
  80060d:	b9 0f 00 00 00       	mov    $0xf,%ecx
  800612:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800619:	00 00 00 
  80061c:	be 26 00 00 00       	mov    $0x26,%esi
  800621:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800628:	00 00 00 
  80062b:	b8 00 00 00 00       	mov    $0x0,%eax
  800630:	49 b9 d9 1b 80 00 00 	movabs $0x801bd9,%r9
  800637:	00 00 00 
  80063a:	41 ff d1             	call   *%r9

000000000080063d <sys_gettime>:

int
sys_gettime(void) {
  80063d:	f3 0f 1e fa          	endbr64
  800641:	55                   	push   %rbp
  800642:	48 89 e5             	mov    %rsp,%rbp
  800645:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800646:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80064b:	ba 00 00 00 00       	mov    $0x0,%edx
  800650:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800655:	bb 00 00 00 00       	mov    $0x0,%ebx
  80065a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80065f:	be 00 00 00 00       	mov    $0x0,%esi
  800664:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80066a:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80066c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800670:	c9                   	leave
  800671:	c3                   	ret

0000000000800672 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  800672:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800676:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80067d:	ff ff ff 
  800680:	48 01 f8             	add    %rdi,%rax
  800683:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800687:	c3                   	ret

0000000000800688 <fd2data>:

char *
fd2data(struct Fd *fd) {
  800688:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80068c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800693:	ff ff ff 
  800696:	48 01 f8             	add    %rdi,%rax
  800699:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80069d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8006a3:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006a7:	c3                   	ret

00000000008006a8 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8006a8:	f3 0f 1e fa          	endbr64
  8006ac:	55                   	push   %rbp
  8006ad:	48 89 e5             	mov    %rsp,%rbp
  8006b0:	41 57                	push   %r15
  8006b2:	41 56                	push   %r14
  8006b4:	41 55                	push   %r13
  8006b6:	41 54                	push   %r12
  8006b8:	53                   	push   %rbx
  8006b9:	48 83 ec 08          	sub    $0x8,%rsp
  8006bd:	49 89 ff             	mov    %rdi,%r15
  8006c0:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8006c5:	49 bd 07 18 80 00 00 	movabs $0x801807,%r13
  8006cc:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8006cf:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8006d5:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8006d8:	48 89 df             	mov    %rbx,%rdi
  8006db:	41 ff d5             	call   *%r13
  8006de:	83 e0 04             	and    $0x4,%eax
  8006e1:	74 17                	je     8006fa <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8006e3:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8006ea:	4c 39 f3             	cmp    %r14,%rbx
  8006ed:	75 e6                	jne    8006d5 <fd_alloc+0x2d>
  8006ef:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8006f5:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8006fa:	4d 89 27             	mov    %r12,(%r15)
}
  8006fd:	48 83 c4 08          	add    $0x8,%rsp
  800701:	5b                   	pop    %rbx
  800702:	41 5c                	pop    %r12
  800704:	41 5d                	pop    %r13
  800706:	41 5e                	pop    %r14
  800708:	41 5f                	pop    %r15
  80070a:	5d                   	pop    %rbp
  80070b:	c3                   	ret

000000000080070c <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  80070c:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  800710:	83 ff 1f             	cmp    $0x1f,%edi
  800713:	77 39                	ja     80074e <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  800715:	55                   	push   %rbp
  800716:	48 89 e5             	mov    %rsp,%rbp
  800719:	41 54                	push   %r12
  80071b:	53                   	push   %rbx
  80071c:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80071f:	48 63 df             	movslq %edi,%rbx
  800722:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  800729:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  80072d:	48 89 df             	mov    %rbx,%rdi
  800730:	48 b8 07 18 80 00 00 	movabs $0x801807,%rax
  800737:	00 00 00 
  80073a:	ff d0                	call   *%rax
  80073c:	a8 04                	test   $0x4,%al
  80073e:	74 14                	je     800754 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  800740:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  800744:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800749:	5b                   	pop    %rbx
  80074a:	41 5c                	pop    %r12
  80074c:	5d                   	pop    %rbp
  80074d:	c3                   	ret
        return -E_INVAL;
  80074e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800753:	c3                   	ret
        return -E_INVAL;
  800754:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800759:	eb ee                	jmp    800749 <fd_lookup+0x3d>

000000000080075b <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  80075b:	f3 0f 1e fa          	endbr64
  80075f:	55                   	push   %rbp
  800760:	48 89 e5             	mov    %rsp,%rbp
  800763:	41 54                	push   %r12
  800765:	53                   	push   %rbx
  800766:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  800769:	48 b8 40 33 80 00 00 	movabs $0x803340,%rax
  800770:	00 00 00 
  800773:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  80077a:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  80077d:	39 3b                	cmp    %edi,(%rbx)
  80077f:	74 47                	je     8007c8 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  800781:	48 83 c0 08          	add    $0x8,%rax
  800785:	48 8b 18             	mov    (%rax),%rbx
  800788:	48 85 db             	test   %rbx,%rbx
  80078b:	75 f0                	jne    80077d <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80078d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800794:	00 00 00 
  800797:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80079d:	89 fa                	mov    %edi,%edx
  80079f:	48 bf 78 32 80 00 00 	movabs $0x803278,%rdi
  8007a6:	00 00 00 
  8007a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ae:	48 b9 35 1d 80 00 00 	movabs $0x801d35,%rcx
  8007b5:	00 00 00 
  8007b8:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8007ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8007bf:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8007c3:	5b                   	pop    %rbx
  8007c4:	41 5c                	pop    %r12
  8007c6:	5d                   	pop    %rbp
  8007c7:	c3                   	ret
            return 0;
  8007c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cd:	eb f0                	jmp    8007bf <dev_lookup+0x64>

00000000008007cf <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8007cf:	f3 0f 1e fa          	endbr64
  8007d3:	55                   	push   %rbp
  8007d4:	48 89 e5             	mov    %rsp,%rbp
  8007d7:	41 55                	push   %r13
  8007d9:	41 54                	push   %r12
  8007db:	53                   	push   %rbx
  8007dc:	48 83 ec 18          	sub    $0x18,%rsp
  8007e0:	48 89 fb             	mov    %rdi,%rbx
  8007e3:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8007e6:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8007ed:	ff ff ff 
  8007f0:	48 01 df             	add    %rbx,%rdi
  8007f3:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8007f7:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8007fb:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  800802:	00 00 00 
  800805:	ff d0                	call   *%rax
  800807:	41 89 c5             	mov    %eax,%r13d
  80080a:	85 c0                	test   %eax,%eax
  80080c:	78 06                	js     800814 <fd_close+0x45>
  80080e:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  800812:	74 1a                	je     80082e <fd_close+0x5f>
        return (must_exist ? res : 0);
  800814:	45 84 e4             	test   %r12b,%r12b
  800817:	b8 00 00 00 00       	mov    $0x0,%eax
  80081c:	44 0f 44 e8          	cmove  %eax,%r13d
}
  800820:	44 89 e8             	mov    %r13d,%eax
  800823:	48 83 c4 18          	add    $0x18,%rsp
  800827:	5b                   	pop    %rbx
  800828:	41 5c                	pop    %r12
  80082a:	41 5d                	pop    %r13
  80082c:	5d                   	pop    %rbp
  80082d:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80082e:	8b 3b                	mov    (%rbx),%edi
  800830:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800834:	48 b8 5b 07 80 00 00 	movabs $0x80075b,%rax
  80083b:	00 00 00 
  80083e:	ff d0                	call   *%rax
  800840:	41 89 c5             	mov    %eax,%r13d
  800843:	85 c0                	test   %eax,%eax
  800845:	78 1b                	js     800862 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  800847:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80084b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80084f:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  800855:	48 85 c0             	test   %rax,%rax
  800858:	74 08                	je     800862 <fd_close+0x93>
  80085a:	48 89 df             	mov    %rbx,%rdi
  80085d:	ff d0                	call   *%rax
  80085f:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  800862:	ba 00 10 00 00       	mov    $0x1000,%edx
  800867:	48 89 de             	mov    %rbx,%rsi
  80086a:	bf 00 00 00 00       	mov    $0x0,%edi
  80086f:	48 b8 ee 03 80 00 00 	movabs $0x8003ee,%rax
  800876:	00 00 00 
  800879:	ff d0                	call   *%rax
    return res;
  80087b:	eb a3                	jmp    800820 <fd_close+0x51>

000000000080087d <close>:

int
close(int fdnum) {
  80087d:	f3 0f 1e fa          	endbr64
  800881:	55                   	push   %rbp
  800882:	48 89 e5             	mov    %rsp,%rbp
  800885:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  800889:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80088d:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  800894:	00 00 00 
  800897:	ff d0                	call   *%rax
    if (res < 0) return res;
  800899:	85 c0                	test   %eax,%eax
  80089b:	78 15                	js     8008b2 <close+0x35>

    return fd_close(fd, 1);
  80089d:	be 01 00 00 00       	mov    $0x1,%esi
  8008a2:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8008a6:	48 b8 cf 07 80 00 00 	movabs $0x8007cf,%rax
  8008ad:	00 00 00 
  8008b0:	ff d0                	call   *%rax
}
  8008b2:	c9                   	leave
  8008b3:	c3                   	ret

00000000008008b4 <close_all>:

void
close_all(void) {
  8008b4:	f3 0f 1e fa          	endbr64
  8008b8:	55                   	push   %rbp
  8008b9:	48 89 e5             	mov    %rsp,%rbp
  8008bc:	41 54                	push   %r12
  8008be:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8008bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008c4:	49 bc 7d 08 80 00 00 	movabs $0x80087d,%r12
  8008cb:	00 00 00 
  8008ce:	89 df                	mov    %ebx,%edi
  8008d0:	41 ff d4             	call   *%r12
  8008d3:	83 c3 01             	add    $0x1,%ebx
  8008d6:	83 fb 20             	cmp    $0x20,%ebx
  8008d9:	75 f3                	jne    8008ce <close_all+0x1a>
}
  8008db:	5b                   	pop    %rbx
  8008dc:	41 5c                	pop    %r12
  8008de:	5d                   	pop    %rbp
  8008df:	c3                   	ret

00000000008008e0 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8008e0:	f3 0f 1e fa          	endbr64
  8008e4:	55                   	push   %rbp
  8008e5:	48 89 e5             	mov    %rsp,%rbp
  8008e8:	41 57                	push   %r15
  8008ea:	41 56                	push   %r14
  8008ec:	41 55                	push   %r13
  8008ee:	41 54                	push   %r12
  8008f0:	53                   	push   %rbx
  8008f1:	48 83 ec 18          	sub    $0x18,%rsp
  8008f5:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8008f8:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8008fc:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  800903:	00 00 00 
  800906:	ff d0                	call   *%rax
  800908:	89 c3                	mov    %eax,%ebx
  80090a:	85 c0                	test   %eax,%eax
  80090c:	0f 88 b8 00 00 00    	js     8009ca <dup+0xea>
    close(newfdnum);
  800912:	44 89 e7             	mov    %r12d,%edi
  800915:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  80091c:	00 00 00 
  80091f:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  800921:	4d 63 ec             	movslq %r12d,%r13
  800924:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  80092b:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  80092f:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  800933:	4c 89 ff             	mov    %r15,%rdi
  800936:	49 be 88 06 80 00 00 	movabs $0x800688,%r14
  80093d:	00 00 00 
  800940:	41 ff d6             	call   *%r14
  800943:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  800946:	4c 89 ef             	mov    %r13,%rdi
  800949:	41 ff d6             	call   *%r14
  80094c:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  80094f:	48 89 df             	mov    %rbx,%rdi
  800952:	48 b8 07 18 80 00 00 	movabs $0x801807,%rax
  800959:	00 00 00 
  80095c:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  80095e:	a8 04                	test   $0x4,%al
  800960:	74 2b                	je     80098d <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  800962:	41 89 c1             	mov    %eax,%r9d
  800965:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80096b:	4c 89 f1             	mov    %r14,%rcx
  80096e:	ba 00 00 00 00       	mov    $0x0,%edx
  800973:	48 89 de             	mov    %rbx,%rsi
  800976:	bf 00 00 00 00       	mov    $0x0,%edi
  80097b:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  800982:	00 00 00 
  800985:	ff d0                	call   *%rax
  800987:	89 c3                	mov    %eax,%ebx
  800989:	85 c0                	test   %eax,%eax
  80098b:	78 4e                	js     8009db <dup+0xfb>
    }
    prot = get_prot(oldfd);
  80098d:	4c 89 ff             	mov    %r15,%rdi
  800990:	48 b8 07 18 80 00 00 	movabs $0x801807,%rax
  800997:	00 00 00 
  80099a:	ff d0                	call   *%rax
  80099c:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  80099f:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8009a5:	4c 89 e9             	mov    %r13,%rcx
  8009a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ad:	4c 89 fe             	mov    %r15,%rsi
  8009b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8009b5:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  8009bc:	00 00 00 
  8009bf:	ff d0                	call   *%rax
  8009c1:	89 c3                	mov    %eax,%ebx
  8009c3:	85 c0                	test   %eax,%eax
  8009c5:	78 14                	js     8009db <dup+0xfb>

    return newfdnum;
  8009c7:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8009ca:	89 d8                	mov    %ebx,%eax
  8009cc:	48 83 c4 18          	add    $0x18,%rsp
  8009d0:	5b                   	pop    %rbx
  8009d1:	41 5c                	pop    %r12
  8009d3:	41 5d                	pop    %r13
  8009d5:	41 5e                	pop    %r14
  8009d7:	41 5f                	pop    %r15
  8009d9:	5d                   	pop    %rbp
  8009da:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8009db:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009e0:	4c 89 ee             	mov    %r13,%rsi
  8009e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8009e8:	49 bc ee 03 80 00 00 	movabs $0x8003ee,%r12
  8009ef:	00 00 00 
  8009f2:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8009f5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009fa:	4c 89 f6             	mov    %r14,%rsi
  8009fd:	bf 00 00 00 00       	mov    $0x0,%edi
  800a02:	41 ff d4             	call   *%r12
    return res;
  800a05:	eb c3                	jmp    8009ca <dup+0xea>

0000000000800a07 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800a07:	f3 0f 1e fa          	endbr64
  800a0b:	55                   	push   %rbp
  800a0c:	48 89 e5             	mov    %rsp,%rbp
  800a0f:	41 56                	push   %r14
  800a11:	41 55                	push   %r13
  800a13:	41 54                	push   %r12
  800a15:	53                   	push   %rbx
  800a16:	48 83 ec 10          	sub    $0x10,%rsp
  800a1a:	89 fb                	mov    %edi,%ebx
  800a1c:	49 89 f4             	mov    %rsi,%r12
  800a1f:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a22:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800a26:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  800a2d:	00 00 00 
  800a30:	ff d0                	call   *%rax
  800a32:	85 c0                	test   %eax,%eax
  800a34:	78 4c                	js     800a82 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a36:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800a3a:	41 8b 3e             	mov    (%r14),%edi
  800a3d:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800a41:	48 b8 5b 07 80 00 00 	movabs $0x80075b,%rax
  800a48:	00 00 00 
  800a4b:	ff d0                	call   *%rax
  800a4d:	85 c0                	test   %eax,%eax
  800a4f:	78 35                	js     800a86 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a51:	41 8b 46 08          	mov    0x8(%r14),%eax
  800a55:	83 e0 03             	and    $0x3,%eax
  800a58:	83 f8 01             	cmp    $0x1,%eax
  800a5b:	74 2d                	je     800a8a <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800a5d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a61:	48 8b 40 10          	mov    0x10(%rax),%rax
  800a65:	48 85 c0             	test   %rax,%rax
  800a68:	74 56                	je     800ac0 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  800a6a:	4c 89 ea             	mov    %r13,%rdx
  800a6d:	4c 89 e6             	mov    %r12,%rsi
  800a70:	4c 89 f7             	mov    %r14,%rdi
  800a73:	ff d0                	call   *%rax
}
  800a75:	48 83 c4 10          	add    $0x10,%rsp
  800a79:	5b                   	pop    %rbx
  800a7a:	41 5c                	pop    %r12
  800a7c:	41 5d                	pop    %r13
  800a7e:	41 5e                	pop    %r14
  800a80:	5d                   	pop    %rbp
  800a81:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a82:	48 98                	cltq
  800a84:	eb ef                	jmp    800a75 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a86:	48 98                	cltq
  800a88:	eb eb                	jmp    800a75 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800a8a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800a91:	00 00 00 
  800a94:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800a9a:	89 da                	mov    %ebx,%edx
  800a9c:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  800aa3:	00 00 00 
  800aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  800aab:	48 b9 35 1d 80 00 00 	movabs $0x801d35,%rcx
  800ab2:	00 00 00 
  800ab5:	ff d1                	call   *%rcx
        return -E_INVAL;
  800ab7:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800abe:	eb b5                	jmp    800a75 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800ac0:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800ac7:	eb ac                	jmp    800a75 <read+0x6e>

0000000000800ac9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800ac9:	f3 0f 1e fa          	endbr64
  800acd:	55                   	push   %rbp
  800ace:	48 89 e5             	mov    %rsp,%rbp
  800ad1:	41 57                	push   %r15
  800ad3:	41 56                	push   %r14
  800ad5:	41 55                	push   %r13
  800ad7:	41 54                	push   %r12
  800ad9:	53                   	push   %rbx
  800ada:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800ade:	48 85 d2             	test   %rdx,%rdx
  800ae1:	74 54                	je     800b37 <readn+0x6e>
  800ae3:	41 89 fd             	mov    %edi,%r13d
  800ae6:	49 89 f6             	mov    %rsi,%r14
  800ae9:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800aec:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800af1:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800af6:	49 bf 07 0a 80 00 00 	movabs $0x800a07,%r15
  800afd:	00 00 00 
  800b00:	4c 89 e2             	mov    %r12,%rdx
  800b03:	48 29 f2             	sub    %rsi,%rdx
  800b06:	4c 01 f6             	add    %r14,%rsi
  800b09:	44 89 ef             	mov    %r13d,%edi
  800b0c:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800b0f:	85 c0                	test   %eax,%eax
  800b11:	78 20                	js     800b33 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  800b13:	01 c3                	add    %eax,%ebx
  800b15:	85 c0                	test   %eax,%eax
  800b17:	74 08                	je     800b21 <readn+0x58>
  800b19:	48 63 f3             	movslq %ebx,%rsi
  800b1c:	4c 39 e6             	cmp    %r12,%rsi
  800b1f:	72 df                	jb     800b00 <readn+0x37>
    }
    return res;
  800b21:	48 63 c3             	movslq %ebx,%rax
}
  800b24:	48 83 c4 08          	add    $0x8,%rsp
  800b28:	5b                   	pop    %rbx
  800b29:	41 5c                	pop    %r12
  800b2b:	41 5d                	pop    %r13
  800b2d:	41 5e                	pop    %r14
  800b2f:	41 5f                	pop    %r15
  800b31:	5d                   	pop    %rbp
  800b32:	c3                   	ret
        if (inc < 0) return inc;
  800b33:	48 98                	cltq
  800b35:	eb ed                	jmp    800b24 <readn+0x5b>
    int inc = 1, res = 0;
  800b37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b3c:	eb e3                	jmp    800b21 <readn+0x58>

0000000000800b3e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800b3e:	f3 0f 1e fa          	endbr64
  800b42:	55                   	push   %rbp
  800b43:	48 89 e5             	mov    %rsp,%rbp
  800b46:	41 56                	push   %r14
  800b48:	41 55                	push   %r13
  800b4a:	41 54                	push   %r12
  800b4c:	53                   	push   %rbx
  800b4d:	48 83 ec 10          	sub    $0x10,%rsp
  800b51:	89 fb                	mov    %edi,%ebx
  800b53:	49 89 f4             	mov    %rsi,%r12
  800b56:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b59:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800b5d:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  800b64:	00 00 00 
  800b67:	ff d0                	call   *%rax
  800b69:	85 c0                	test   %eax,%eax
  800b6b:	78 47                	js     800bb4 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b6d:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800b71:	41 8b 3e             	mov    (%r14),%edi
  800b74:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800b78:	48 b8 5b 07 80 00 00 	movabs $0x80075b,%rax
  800b7f:	00 00 00 
  800b82:	ff d0                	call   *%rax
  800b84:	85 c0                	test   %eax,%eax
  800b86:	78 30                	js     800bb8 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b88:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  800b8d:	74 2d                	je     800bbc <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800b8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b93:	48 8b 40 18          	mov    0x18(%rax),%rax
  800b97:	48 85 c0             	test   %rax,%rax
  800b9a:	74 56                	je     800bf2 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  800b9c:	4c 89 ea             	mov    %r13,%rdx
  800b9f:	4c 89 e6             	mov    %r12,%rsi
  800ba2:	4c 89 f7             	mov    %r14,%rdi
  800ba5:	ff d0                	call   *%rax
}
  800ba7:	48 83 c4 10          	add    $0x10,%rsp
  800bab:	5b                   	pop    %rbx
  800bac:	41 5c                	pop    %r12
  800bae:	41 5d                	pop    %r13
  800bb0:	41 5e                	pop    %r14
  800bb2:	5d                   	pop    %rbp
  800bb3:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800bb4:	48 98                	cltq
  800bb6:	eb ef                	jmp    800ba7 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bb8:	48 98                	cltq
  800bba:	eb eb                	jmp    800ba7 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800bbc:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bc3:	00 00 00 
  800bc6:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800bcc:	89 da                	mov    %ebx,%edx
  800bce:	48 bf 34 30 80 00 00 	movabs $0x803034,%rdi
  800bd5:	00 00 00 
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdd:	48 b9 35 1d 80 00 00 	movabs $0x801d35,%rcx
  800be4:	00 00 00 
  800be7:	ff d1                	call   *%rcx
        return -E_INVAL;
  800be9:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800bf0:	eb b5                	jmp    800ba7 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800bf2:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800bf9:	eb ac                	jmp    800ba7 <write+0x69>

0000000000800bfb <seek>:

int
seek(int fdnum, off_t offset) {
  800bfb:	f3 0f 1e fa          	endbr64
  800bff:	55                   	push   %rbp
  800c00:	48 89 e5             	mov    %rsp,%rbp
  800c03:	53                   	push   %rbx
  800c04:	48 83 ec 18          	sub    $0x18,%rsp
  800c08:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c0a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c0e:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  800c15:	00 00 00 
  800c18:	ff d0                	call   *%rax
  800c1a:	85 c0                	test   %eax,%eax
  800c1c:	78 0c                	js     800c2a <seek+0x2f>

    fd->fd_offset = offset;
  800c1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c22:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800c25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c2a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c2e:	c9                   	leave
  800c2f:	c3                   	ret

0000000000800c30 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800c30:	f3 0f 1e fa          	endbr64
  800c34:	55                   	push   %rbp
  800c35:	48 89 e5             	mov    %rsp,%rbp
  800c38:	41 55                	push   %r13
  800c3a:	41 54                	push   %r12
  800c3c:	53                   	push   %rbx
  800c3d:	48 83 ec 18          	sub    $0x18,%rsp
  800c41:	89 fb                	mov    %edi,%ebx
  800c43:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c46:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800c4a:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  800c51:	00 00 00 
  800c54:	ff d0                	call   *%rax
  800c56:	85 c0                	test   %eax,%eax
  800c58:	78 38                	js     800c92 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c5a:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  800c5e:	41 8b 7d 00          	mov    0x0(%r13),%edi
  800c62:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800c66:	48 b8 5b 07 80 00 00 	movabs $0x80075b,%rax
  800c6d:	00 00 00 
  800c70:	ff d0                	call   *%rax
  800c72:	85 c0                	test   %eax,%eax
  800c74:	78 1c                	js     800c92 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c76:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  800c7b:	74 20                	je     800c9d <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c81:	48 8b 40 30          	mov    0x30(%rax),%rax
  800c85:	48 85 c0             	test   %rax,%rax
  800c88:	74 47                	je     800cd1 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  800c8a:	44 89 e6             	mov    %r12d,%esi
  800c8d:	4c 89 ef             	mov    %r13,%rdi
  800c90:	ff d0                	call   *%rax
}
  800c92:	48 83 c4 18          	add    $0x18,%rsp
  800c96:	5b                   	pop    %rbx
  800c97:	41 5c                	pop    %r12
  800c99:	41 5d                	pop    %r13
  800c9b:	5d                   	pop    %rbp
  800c9c:	c3                   	ret
                thisenv->env_id, fdnum);
  800c9d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800ca4:	00 00 00 
  800ca7:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800cad:	89 da                	mov    %ebx,%edx
  800caf:	48 bf 98 32 80 00 00 	movabs $0x803298,%rdi
  800cb6:	00 00 00 
  800cb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbe:	48 b9 35 1d 80 00 00 	movabs $0x801d35,%rcx
  800cc5:	00 00 00 
  800cc8:	ff d1                	call   *%rcx
        return -E_INVAL;
  800cca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ccf:	eb c1                	jmp    800c92 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800cd1:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800cd6:	eb ba                	jmp    800c92 <ftruncate+0x62>

0000000000800cd8 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800cd8:	f3 0f 1e fa          	endbr64
  800cdc:	55                   	push   %rbp
  800cdd:	48 89 e5             	mov    %rsp,%rbp
  800ce0:	41 54                	push   %r12
  800ce2:	53                   	push   %rbx
  800ce3:	48 83 ec 10          	sub    $0x10,%rsp
  800ce7:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800cea:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800cee:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  800cf5:	00 00 00 
  800cf8:	ff d0                	call   *%rax
  800cfa:	85 c0                	test   %eax,%eax
  800cfc:	78 4e                	js     800d4c <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800cfe:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  800d02:	41 8b 3c 24          	mov    (%r12),%edi
  800d06:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800d0a:	48 b8 5b 07 80 00 00 	movabs $0x80075b,%rax
  800d11:	00 00 00 
  800d14:	ff d0                	call   *%rax
  800d16:	85 c0                	test   %eax,%eax
  800d18:	78 32                	js     800d4c <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800d1e:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800d23:	74 30                	je     800d55 <fstat+0x7d>

    stat->st_name[0] = 0;
  800d25:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800d28:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800d2f:	00 00 00 
    stat->st_isdir = 0;
  800d32:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800d39:	00 00 00 
    stat->st_dev = dev;
  800d3c:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800d43:	48 89 de             	mov    %rbx,%rsi
  800d46:	4c 89 e7             	mov    %r12,%rdi
  800d49:	ff 50 28             	call   *0x28(%rax)
}
  800d4c:	48 83 c4 10          	add    $0x10,%rsp
  800d50:	5b                   	pop    %rbx
  800d51:	41 5c                	pop    %r12
  800d53:	5d                   	pop    %rbp
  800d54:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d55:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800d5a:	eb f0                	jmp    800d4c <fstat+0x74>

0000000000800d5c <stat>:

int
stat(const char *path, struct Stat *stat) {
  800d5c:	f3 0f 1e fa          	endbr64
  800d60:	55                   	push   %rbp
  800d61:	48 89 e5             	mov    %rsp,%rbp
  800d64:	41 54                	push   %r12
  800d66:	53                   	push   %rbx
  800d67:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800d6a:	be 00 00 00 00       	mov    $0x0,%esi
  800d6f:	48 b8 3d 10 80 00 00 	movabs $0x80103d,%rax
  800d76:	00 00 00 
  800d79:	ff d0                	call   *%rax
  800d7b:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800d7d:	85 c0                	test   %eax,%eax
  800d7f:	78 25                	js     800da6 <stat+0x4a>

    int res = fstat(fd, stat);
  800d81:	4c 89 e6             	mov    %r12,%rsi
  800d84:	89 c7                	mov    %eax,%edi
  800d86:	48 b8 d8 0c 80 00 00 	movabs $0x800cd8,%rax
  800d8d:	00 00 00 
  800d90:	ff d0                	call   *%rax
  800d92:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800d95:	89 df                	mov    %ebx,%edi
  800d97:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  800d9e:	00 00 00 
  800da1:	ff d0                	call   *%rax

    return res;
  800da3:	44 89 e3             	mov    %r12d,%ebx
}
  800da6:	89 d8                	mov    %ebx,%eax
  800da8:	5b                   	pop    %rbx
  800da9:	41 5c                	pop    %r12
  800dab:	5d                   	pop    %rbp
  800dac:	c3                   	ret

0000000000800dad <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800dad:	f3 0f 1e fa          	endbr64
  800db1:	55                   	push   %rbp
  800db2:	48 89 e5             	mov    %rsp,%rbp
  800db5:	41 54                	push   %r12
  800db7:	53                   	push   %rbx
  800db8:	48 83 ec 10          	sub    $0x10,%rsp
  800dbc:	41 89 fc             	mov    %edi,%r12d
  800dbf:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800dc2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800dc9:	00 00 00 
  800dcc:	83 38 00             	cmpl   $0x0,(%rax)
  800dcf:	74 6e                	je     800e3f <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  800dd1:	bf 03 00 00 00       	mov    $0x3,%edi
  800dd6:	48 b8 39 2c 80 00 00 	movabs $0x802c39,%rax
  800ddd:	00 00 00 
  800de0:	ff d0                	call   *%rax
  800de2:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800de9:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800deb:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800df1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800df6:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800dfd:	00 00 00 
  800e00:	44 89 e6             	mov    %r12d,%esi
  800e03:	89 c7                	mov    %eax,%edi
  800e05:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  800e0c:	00 00 00 
  800e0f:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800e11:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800e18:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800e19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e1e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e22:	48 89 de             	mov    %rbx,%rsi
  800e25:	bf 00 00 00 00       	mov    $0x0,%edi
  800e2a:	48 b8 de 2a 80 00 00 	movabs $0x802ade,%rax
  800e31:	00 00 00 
  800e34:	ff d0                	call   *%rax
}
  800e36:	48 83 c4 10          	add    $0x10,%rsp
  800e3a:	5b                   	pop    %rbx
  800e3b:	41 5c                	pop    %r12
  800e3d:	5d                   	pop    %rbp
  800e3e:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800e3f:	bf 03 00 00 00       	mov    $0x3,%edi
  800e44:	48 b8 39 2c 80 00 00 	movabs $0x802c39,%rax
  800e4b:	00 00 00 
  800e4e:	ff d0                	call   *%rax
  800e50:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e57:	00 00 
  800e59:	e9 73 ff ff ff       	jmp    800dd1 <fsipc+0x24>

0000000000800e5e <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800e5e:	f3 0f 1e fa          	endbr64
  800e62:	55                   	push   %rbp
  800e63:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800e66:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e6d:	00 00 00 
  800e70:	8b 57 0c             	mov    0xc(%rdi),%edx
  800e73:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800e75:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800e78:	be 00 00 00 00       	mov    $0x0,%esi
  800e7d:	bf 02 00 00 00       	mov    $0x2,%edi
  800e82:	48 b8 ad 0d 80 00 00 	movabs $0x800dad,%rax
  800e89:	00 00 00 
  800e8c:	ff d0                	call   *%rax
}
  800e8e:	5d                   	pop    %rbp
  800e8f:	c3                   	ret

0000000000800e90 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800e90:	f3 0f 1e fa          	endbr64
  800e94:	55                   	push   %rbp
  800e95:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800e98:	8b 47 0c             	mov    0xc(%rdi),%eax
  800e9b:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ea2:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800ea4:	be 00 00 00 00       	mov    $0x0,%esi
  800ea9:	bf 06 00 00 00       	mov    $0x6,%edi
  800eae:	48 b8 ad 0d 80 00 00 	movabs $0x800dad,%rax
  800eb5:	00 00 00 
  800eb8:	ff d0                	call   *%rax
}
  800eba:	5d                   	pop    %rbp
  800ebb:	c3                   	ret

0000000000800ebc <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800ebc:	f3 0f 1e fa          	endbr64
  800ec0:	55                   	push   %rbp
  800ec1:	48 89 e5             	mov    %rsp,%rbp
  800ec4:	41 54                	push   %r12
  800ec6:	53                   	push   %rbx
  800ec7:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800eca:	8b 47 0c             	mov    0xc(%rdi),%eax
  800ecd:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ed4:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800ed6:	be 00 00 00 00       	mov    $0x0,%esi
  800edb:	bf 05 00 00 00       	mov    $0x5,%edi
  800ee0:	48 b8 ad 0d 80 00 00 	movabs $0x800dad,%rax
  800ee7:	00 00 00 
  800eea:	ff d0                	call   *%rax
    if (res < 0) return res;
  800eec:	85 c0                	test   %eax,%eax
  800eee:	78 3d                	js     800f2d <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800ef0:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  800ef7:	00 00 00 
  800efa:	4c 89 e6             	mov    %r12,%rsi
  800efd:	48 89 df             	mov    %rbx,%rdi
  800f00:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  800f07:	00 00 00 
  800f0a:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800f0c:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  800f13:	00 
  800f14:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800f1a:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  800f21:	00 
  800f22:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800f28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2d:	5b                   	pop    %rbx
  800f2e:	41 5c                	pop    %r12
  800f30:	5d                   	pop    %rbp
  800f31:	c3                   	ret

0000000000800f32 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f32:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  800f36:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  800f3d:	77 41                	ja     800f80 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f3f:	55                   	push   %rbp
  800f40:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  800f43:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f4a:	00 00 00 
  800f4d:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f50:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  800f52:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  800f56:	48 8d 78 10          	lea    0x10(%rax),%rdi
  800f5a:	48 b8 99 28 80 00 00 	movabs $0x802899,%rax
  800f61:	00 00 00 
  800f64:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  800f66:	be 00 00 00 00       	mov    $0x0,%esi
  800f6b:	bf 04 00 00 00       	mov    $0x4,%edi
  800f70:	48 b8 ad 0d 80 00 00 	movabs $0x800dad,%rax
  800f77:	00 00 00 
  800f7a:	ff d0                	call   *%rax
  800f7c:	48 98                	cltq
}
  800f7e:	5d                   	pop    %rbp
  800f7f:	c3                   	ret
        return -E_INVAL;
  800f80:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  800f87:	c3                   	ret

0000000000800f88 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800f88:	f3 0f 1e fa          	endbr64
  800f8c:	55                   	push   %rbp
  800f8d:	48 89 e5             	mov    %rsp,%rbp
  800f90:	41 55                	push   %r13
  800f92:	41 54                	push   %r12
  800f94:	53                   	push   %rbx
  800f95:	48 83 ec 08          	sub    $0x8,%rsp
  800f99:	49 89 f4             	mov    %rsi,%r12
  800f9c:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800f9f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800fa6:	00 00 00 
  800fa9:	8b 57 0c             	mov    0xc(%rdi),%edx
  800fac:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  800fae:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  800fb2:	be 00 00 00 00       	mov    $0x0,%esi
  800fb7:	bf 03 00 00 00       	mov    $0x3,%edi
  800fbc:	48 b8 ad 0d 80 00 00 	movabs $0x800dad,%rax
  800fc3:	00 00 00 
  800fc6:	ff d0                	call   *%rax
  800fc8:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  800fcb:	4d 85 ed             	test   %r13,%r13
  800fce:	78 2a                	js     800ffa <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  800fd0:	4c 89 ea             	mov    %r13,%rdx
  800fd3:	4c 39 eb             	cmp    %r13,%rbx
  800fd6:	72 30                	jb     801008 <devfile_read+0x80>
  800fd8:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  800fdf:	7f 27                	jg     801008 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  800fe1:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800fe8:	00 00 00 
  800feb:	4c 89 e7             	mov    %r12,%rdi
  800fee:	48 b8 99 28 80 00 00 	movabs $0x802899,%rax
  800ff5:	00 00 00 
  800ff8:	ff d0                	call   *%rax
}
  800ffa:	4c 89 e8             	mov    %r13,%rax
  800ffd:	48 83 c4 08          	add    $0x8,%rsp
  801001:	5b                   	pop    %rbx
  801002:	41 5c                	pop    %r12
  801004:	41 5d                	pop    %r13
  801006:	5d                   	pop    %rbp
  801007:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801008:	48 b9 51 30 80 00 00 	movabs $0x803051,%rcx
  80100f:	00 00 00 
  801012:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  801019:	00 00 00 
  80101c:	be 7b 00 00 00       	mov    $0x7b,%esi
  801021:	48 bf 83 30 80 00 00 	movabs $0x803083,%rdi
  801028:	00 00 00 
  80102b:	b8 00 00 00 00       	mov    $0x0,%eax
  801030:	49 b8 d9 1b 80 00 00 	movabs $0x801bd9,%r8
  801037:	00 00 00 
  80103a:	41 ff d0             	call   *%r8

000000000080103d <open>:
open(const char *path, int mode) {
  80103d:	f3 0f 1e fa          	endbr64
  801041:	55                   	push   %rbp
  801042:	48 89 e5             	mov    %rsp,%rbp
  801045:	41 55                	push   %r13
  801047:	41 54                	push   %r12
  801049:	53                   	push   %rbx
  80104a:	48 83 ec 18          	sub    $0x18,%rsp
  80104e:	49 89 fc             	mov    %rdi,%r12
  801051:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801054:	48 b8 39 26 80 00 00 	movabs $0x802639,%rax
  80105b:	00 00 00 
  80105e:	ff d0                	call   *%rax
  801060:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801066:	0f 87 8a 00 00 00    	ja     8010f6 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80106c:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801070:	48 b8 a8 06 80 00 00 	movabs $0x8006a8,%rax
  801077:	00 00 00 
  80107a:	ff d0                	call   *%rax
  80107c:	89 c3                	mov    %eax,%ebx
  80107e:	85 c0                	test   %eax,%eax
  801080:	78 50                	js     8010d2 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  801082:	4c 89 e6             	mov    %r12,%rsi
  801085:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  80108c:	00 00 00 
  80108f:	48 89 df             	mov    %rbx,%rdi
  801092:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  801099:	00 00 00 
  80109c:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80109e:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8010a5:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8010a9:	bf 01 00 00 00       	mov    $0x1,%edi
  8010ae:	48 b8 ad 0d 80 00 00 	movabs $0x800dad,%rax
  8010b5:	00 00 00 
  8010b8:	ff d0                	call   *%rax
  8010ba:	89 c3                	mov    %eax,%ebx
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	78 1f                	js     8010df <open+0xa2>
    return fd2num(fd);
  8010c0:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010c4:	48 b8 72 06 80 00 00 	movabs $0x800672,%rax
  8010cb:	00 00 00 
  8010ce:	ff d0                	call   *%rax
  8010d0:	89 c3                	mov    %eax,%ebx
}
  8010d2:	89 d8                	mov    %ebx,%eax
  8010d4:	48 83 c4 18          	add    $0x18,%rsp
  8010d8:	5b                   	pop    %rbx
  8010d9:	41 5c                	pop    %r12
  8010db:	41 5d                	pop    %r13
  8010dd:	5d                   	pop    %rbp
  8010de:	c3                   	ret
        fd_close(fd, 0);
  8010df:	be 00 00 00 00       	mov    $0x0,%esi
  8010e4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010e8:	48 b8 cf 07 80 00 00 	movabs $0x8007cf,%rax
  8010ef:	00 00 00 
  8010f2:	ff d0                	call   *%rax
        return res;
  8010f4:	eb dc                	jmp    8010d2 <open+0x95>
        return -E_BAD_PATH;
  8010f6:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8010fb:	eb d5                	jmp    8010d2 <open+0x95>

00000000008010fd <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8010fd:	f3 0f 1e fa          	endbr64
  801101:	55                   	push   %rbp
  801102:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801105:	be 00 00 00 00       	mov    $0x0,%esi
  80110a:	bf 08 00 00 00       	mov    $0x8,%edi
  80110f:	48 b8 ad 0d 80 00 00 	movabs $0x800dad,%rax
  801116:	00 00 00 
  801119:	ff d0                	call   *%rax
}
  80111b:	5d                   	pop    %rbp
  80111c:	c3                   	ret

000000000080111d <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80111d:	f3 0f 1e fa          	endbr64
  801121:	55                   	push   %rbp
  801122:	48 89 e5             	mov    %rsp,%rbp
  801125:	41 54                	push   %r12
  801127:	53                   	push   %rbx
  801128:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80112b:	48 b8 88 06 80 00 00 	movabs $0x800688,%rax
  801132:	00 00 00 
  801135:	ff d0                	call   *%rax
  801137:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80113a:	48 be 8e 30 80 00 00 	movabs $0x80308e,%rsi
  801141:	00 00 00 
  801144:	48 89 df             	mov    %rbx,%rdi
  801147:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  80114e:	00 00 00 
  801151:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801153:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801158:	41 2b 04 24          	sub    (%r12),%eax
  80115c:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801162:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801169:	00 00 00 
    stat->st_dev = &devpipe;
  80116c:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801173:	00 00 00 
  801176:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80117d:	b8 00 00 00 00       	mov    $0x0,%eax
  801182:	5b                   	pop    %rbx
  801183:	41 5c                	pop    %r12
  801185:	5d                   	pop    %rbp
  801186:	c3                   	ret

0000000000801187 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801187:	f3 0f 1e fa          	endbr64
  80118b:	55                   	push   %rbp
  80118c:	48 89 e5             	mov    %rsp,%rbp
  80118f:	41 54                	push   %r12
  801191:	53                   	push   %rbx
  801192:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801195:	ba 00 10 00 00       	mov    $0x1000,%edx
  80119a:	48 89 fe             	mov    %rdi,%rsi
  80119d:	bf 00 00 00 00       	mov    $0x0,%edi
  8011a2:	49 bc ee 03 80 00 00 	movabs $0x8003ee,%r12
  8011a9:	00 00 00 
  8011ac:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8011af:	48 89 df             	mov    %rbx,%rdi
  8011b2:	48 b8 88 06 80 00 00 	movabs $0x800688,%rax
  8011b9:	00 00 00 
  8011bc:	ff d0                	call   *%rax
  8011be:	48 89 c6             	mov    %rax,%rsi
  8011c1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8011cb:	41 ff d4             	call   *%r12
}
  8011ce:	5b                   	pop    %rbx
  8011cf:	41 5c                	pop    %r12
  8011d1:	5d                   	pop    %rbp
  8011d2:	c3                   	ret

00000000008011d3 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8011d3:	f3 0f 1e fa          	endbr64
  8011d7:	55                   	push   %rbp
  8011d8:	48 89 e5             	mov    %rsp,%rbp
  8011db:	41 57                	push   %r15
  8011dd:	41 56                	push   %r14
  8011df:	41 55                	push   %r13
  8011e1:	41 54                	push   %r12
  8011e3:	53                   	push   %rbx
  8011e4:	48 83 ec 18          	sub    $0x18,%rsp
  8011e8:	49 89 fc             	mov    %rdi,%r12
  8011eb:	49 89 f5             	mov    %rsi,%r13
  8011ee:	49 89 d7             	mov    %rdx,%r15
  8011f1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8011f5:	48 b8 88 06 80 00 00 	movabs $0x800688,%rax
  8011fc:	00 00 00 
  8011ff:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801201:	4d 85 ff             	test   %r15,%r15
  801204:	0f 84 af 00 00 00    	je     8012b9 <devpipe_write+0xe6>
  80120a:	48 89 c3             	mov    %rax,%rbx
  80120d:	4c 89 f8             	mov    %r15,%rax
  801210:	4d 89 ef             	mov    %r13,%r15
  801213:	4c 01 e8             	add    %r13,%rax
  801216:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80121a:	49 bd 7e 02 80 00 00 	movabs $0x80027e,%r13
  801221:	00 00 00 
            sys_yield();
  801224:	49 be 13 02 80 00 00 	movabs $0x800213,%r14
  80122b:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80122e:	8b 73 04             	mov    0x4(%rbx),%esi
  801231:	48 63 ce             	movslq %esi,%rcx
  801234:	48 63 03             	movslq (%rbx),%rax
  801237:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80123d:	48 39 c1             	cmp    %rax,%rcx
  801240:	72 2e                	jb     801270 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801242:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801247:	48 89 da             	mov    %rbx,%rdx
  80124a:	be 00 10 00 00       	mov    $0x1000,%esi
  80124f:	4c 89 e7             	mov    %r12,%rdi
  801252:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801255:	85 c0                	test   %eax,%eax
  801257:	74 66                	je     8012bf <devpipe_write+0xec>
            sys_yield();
  801259:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80125c:	8b 73 04             	mov    0x4(%rbx),%esi
  80125f:	48 63 ce             	movslq %esi,%rcx
  801262:	48 63 03             	movslq (%rbx),%rax
  801265:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80126b:	48 39 c1             	cmp    %rax,%rcx
  80126e:	73 d2                	jae    801242 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801270:	41 0f b6 3f          	movzbl (%r15),%edi
  801274:	48 89 ca             	mov    %rcx,%rdx
  801277:	48 c1 ea 03          	shr    $0x3,%rdx
  80127b:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801282:	08 10 20 
  801285:	48 f7 e2             	mul    %rdx
  801288:	48 c1 ea 06          	shr    $0x6,%rdx
  80128c:	48 89 d0             	mov    %rdx,%rax
  80128f:	48 c1 e0 09          	shl    $0x9,%rax
  801293:	48 29 d0             	sub    %rdx,%rax
  801296:	48 c1 e0 03          	shl    $0x3,%rax
  80129a:	48 29 c1             	sub    %rax,%rcx
  80129d:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8012a2:	83 c6 01             	add    $0x1,%esi
  8012a5:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012a8:	49 83 c7 01          	add    $0x1,%r15
  8012ac:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012b0:	49 39 c7             	cmp    %rax,%r15
  8012b3:	0f 85 75 ff ff ff    	jne    80122e <devpipe_write+0x5b>
    return n;
  8012b9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8012bd:	eb 05                	jmp    8012c4 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8012bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c4:	48 83 c4 18          	add    $0x18,%rsp
  8012c8:	5b                   	pop    %rbx
  8012c9:	41 5c                	pop    %r12
  8012cb:	41 5d                	pop    %r13
  8012cd:	41 5e                	pop    %r14
  8012cf:	41 5f                	pop    %r15
  8012d1:	5d                   	pop    %rbp
  8012d2:	c3                   	ret

00000000008012d3 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8012d3:	f3 0f 1e fa          	endbr64
  8012d7:	55                   	push   %rbp
  8012d8:	48 89 e5             	mov    %rsp,%rbp
  8012db:	41 57                	push   %r15
  8012dd:	41 56                	push   %r14
  8012df:	41 55                	push   %r13
  8012e1:	41 54                	push   %r12
  8012e3:	53                   	push   %rbx
  8012e4:	48 83 ec 18          	sub    $0x18,%rsp
  8012e8:	49 89 fc             	mov    %rdi,%r12
  8012eb:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8012ef:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8012f3:	48 b8 88 06 80 00 00 	movabs $0x800688,%rax
  8012fa:	00 00 00 
  8012fd:	ff d0                	call   *%rax
  8012ff:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  801302:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801308:	49 bd 7e 02 80 00 00 	movabs $0x80027e,%r13
  80130f:	00 00 00 
            sys_yield();
  801312:	49 be 13 02 80 00 00 	movabs $0x800213,%r14
  801319:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80131c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801321:	74 7d                	je     8013a0 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801323:	8b 03                	mov    (%rbx),%eax
  801325:	3b 43 04             	cmp    0x4(%rbx),%eax
  801328:	75 26                	jne    801350 <devpipe_read+0x7d>
            if (i > 0) return i;
  80132a:	4d 85 ff             	test   %r15,%r15
  80132d:	75 77                	jne    8013a6 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80132f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801334:	48 89 da             	mov    %rbx,%rdx
  801337:	be 00 10 00 00       	mov    $0x1000,%esi
  80133c:	4c 89 e7             	mov    %r12,%rdi
  80133f:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801342:	85 c0                	test   %eax,%eax
  801344:	74 72                	je     8013b8 <devpipe_read+0xe5>
            sys_yield();
  801346:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801349:	8b 03                	mov    (%rbx),%eax
  80134b:	3b 43 04             	cmp    0x4(%rbx),%eax
  80134e:	74 df                	je     80132f <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801350:	48 63 c8             	movslq %eax,%rcx
  801353:	48 89 ca             	mov    %rcx,%rdx
  801356:	48 c1 ea 03          	shr    $0x3,%rdx
  80135a:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  801361:	08 10 20 
  801364:	48 89 d0             	mov    %rdx,%rax
  801367:	48 f7 e6             	mul    %rsi
  80136a:	48 c1 ea 06          	shr    $0x6,%rdx
  80136e:	48 89 d0             	mov    %rdx,%rax
  801371:	48 c1 e0 09          	shl    $0x9,%rax
  801375:	48 29 d0             	sub    %rdx,%rax
  801378:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80137f:	00 
  801380:	48 89 c8             	mov    %rcx,%rax
  801383:	48 29 d0             	sub    %rdx,%rax
  801386:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80138b:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80138f:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  801393:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  801396:	49 83 c7 01          	add    $0x1,%r15
  80139a:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80139e:	75 83                	jne    801323 <devpipe_read+0x50>
    return n;
  8013a0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013a4:	eb 03                	jmp    8013a9 <devpipe_read+0xd6>
            if (i > 0) return i;
  8013a6:	4c 89 f8             	mov    %r15,%rax
}
  8013a9:	48 83 c4 18          	add    $0x18,%rsp
  8013ad:	5b                   	pop    %rbx
  8013ae:	41 5c                	pop    %r12
  8013b0:	41 5d                	pop    %r13
  8013b2:	41 5e                	pop    %r14
  8013b4:	41 5f                	pop    %r15
  8013b6:	5d                   	pop    %rbp
  8013b7:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8013b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bd:	eb ea                	jmp    8013a9 <devpipe_read+0xd6>

00000000008013bf <pipe>:
pipe(int pfd[2]) {
  8013bf:	f3 0f 1e fa          	endbr64
  8013c3:	55                   	push   %rbp
  8013c4:	48 89 e5             	mov    %rsp,%rbp
  8013c7:	41 55                	push   %r13
  8013c9:	41 54                	push   %r12
  8013cb:	53                   	push   %rbx
  8013cc:	48 83 ec 18          	sub    $0x18,%rsp
  8013d0:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8013d3:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8013d7:	48 b8 a8 06 80 00 00 	movabs $0x8006a8,%rax
  8013de:	00 00 00 
  8013e1:	ff d0                	call   *%rax
  8013e3:	89 c3                	mov    %eax,%ebx
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	0f 88 a0 01 00 00    	js     80158d <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8013ed:	b9 46 00 00 00       	mov    $0x46,%ecx
  8013f2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8013f7:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8013fb:	bf 00 00 00 00       	mov    $0x0,%edi
  801400:	48 b8 ae 02 80 00 00 	movabs $0x8002ae,%rax
  801407:	00 00 00 
  80140a:	ff d0                	call   *%rax
  80140c:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80140e:	85 c0                	test   %eax,%eax
  801410:	0f 88 77 01 00 00    	js     80158d <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  801416:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80141a:	48 b8 a8 06 80 00 00 	movabs $0x8006a8,%rax
  801421:	00 00 00 
  801424:	ff d0                	call   *%rax
  801426:	89 c3                	mov    %eax,%ebx
  801428:	85 c0                	test   %eax,%eax
  80142a:	0f 88 43 01 00 00    	js     801573 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  801430:	b9 46 00 00 00       	mov    $0x46,%ecx
  801435:	ba 00 10 00 00       	mov    $0x1000,%edx
  80143a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80143e:	bf 00 00 00 00       	mov    $0x0,%edi
  801443:	48 b8 ae 02 80 00 00 	movabs $0x8002ae,%rax
  80144a:	00 00 00 
  80144d:	ff d0                	call   *%rax
  80144f:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  801451:	85 c0                	test   %eax,%eax
  801453:	0f 88 1a 01 00 00    	js     801573 <pipe+0x1b4>
    va = fd2data(fd0);
  801459:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80145d:	48 b8 88 06 80 00 00 	movabs $0x800688,%rax
  801464:	00 00 00 
  801467:	ff d0                	call   *%rax
  801469:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80146c:	b9 46 00 00 00       	mov    $0x46,%ecx
  801471:	ba 00 10 00 00       	mov    $0x1000,%edx
  801476:	48 89 c6             	mov    %rax,%rsi
  801479:	bf 00 00 00 00       	mov    $0x0,%edi
  80147e:	48 b8 ae 02 80 00 00 	movabs $0x8002ae,%rax
  801485:	00 00 00 
  801488:	ff d0                	call   *%rax
  80148a:	89 c3                	mov    %eax,%ebx
  80148c:	85 c0                	test   %eax,%eax
  80148e:	0f 88 c5 00 00 00    	js     801559 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  801494:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801498:	48 b8 88 06 80 00 00 	movabs $0x800688,%rax
  80149f:	00 00 00 
  8014a2:	ff d0                	call   *%rax
  8014a4:	48 89 c1             	mov    %rax,%rcx
  8014a7:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8014ad:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8014b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b8:	4c 89 ee             	mov    %r13,%rsi
  8014bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8014c0:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  8014c7:	00 00 00 
  8014ca:	ff d0                	call   *%rax
  8014cc:	89 c3                	mov    %eax,%ebx
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	78 6e                	js     801540 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014d2:	be 00 10 00 00       	mov    $0x1000,%esi
  8014d7:	4c 89 ef             	mov    %r13,%rdi
  8014da:	48 b8 48 02 80 00 00 	movabs $0x800248,%rax
  8014e1:	00 00 00 
  8014e4:	ff d0                	call   *%rax
  8014e6:	83 f8 02             	cmp    $0x2,%eax
  8014e9:	0f 85 ab 00 00 00    	jne    80159a <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8014ef:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8014f6:	00 00 
  8014f8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014fc:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8014fe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801502:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  801509:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80150d:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80150f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801513:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80151a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80151e:	48 bb 72 06 80 00 00 	movabs $0x800672,%rbx
  801525:	00 00 00 
  801528:	ff d3                	call   *%rbx
  80152a:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80152e:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801532:	ff d3                	call   *%rbx
  801534:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  801539:	bb 00 00 00 00       	mov    $0x0,%ebx
  80153e:	eb 4d                	jmp    80158d <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  801540:	ba 00 10 00 00       	mov    $0x1000,%edx
  801545:	4c 89 ee             	mov    %r13,%rsi
  801548:	bf 00 00 00 00       	mov    $0x0,%edi
  80154d:	48 b8 ee 03 80 00 00 	movabs $0x8003ee,%rax
  801554:	00 00 00 
  801557:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  801559:	ba 00 10 00 00       	mov    $0x1000,%edx
  80155e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801562:	bf 00 00 00 00       	mov    $0x0,%edi
  801567:	48 b8 ee 03 80 00 00 	movabs $0x8003ee,%rax
  80156e:	00 00 00 
  801571:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  801573:	ba 00 10 00 00       	mov    $0x1000,%edx
  801578:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80157c:	bf 00 00 00 00       	mov    $0x0,%edi
  801581:	48 b8 ee 03 80 00 00 	movabs $0x8003ee,%rax
  801588:	00 00 00 
  80158b:	ff d0                	call   *%rax
}
  80158d:	89 d8                	mov    %ebx,%eax
  80158f:	48 83 c4 18          	add    $0x18,%rsp
  801593:	5b                   	pop    %rbx
  801594:	41 5c                	pop    %r12
  801596:	41 5d                	pop    %r13
  801598:	5d                   	pop    %rbp
  801599:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80159a:	48 b9 c0 32 80 00 00 	movabs $0x8032c0,%rcx
  8015a1:	00 00 00 
  8015a4:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  8015ab:	00 00 00 
  8015ae:	be 2e 00 00 00       	mov    $0x2e,%esi
  8015b3:	48 bf 95 30 80 00 00 	movabs $0x803095,%rdi
  8015ba:	00 00 00 
  8015bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c2:	49 b8 d9 1b 80 00 00 	movabs $0x801bd9,%r8
  8015c9:	00 00 00 
  8015cc:	41 ff d0             	call   *%r8

00000000008015cf <pipeisclosed>:
pipeisclosed(int fdnum) {
  8015cf:	f3 0f 1e fa          	endbr64
  8015d3:	55                   	push   %rbp
  8015d4:	48 89 e5             	mov    %rsp,%rbp
  8015d7:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8015db:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8015df:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  8015e6:	00 00 00 
  8015e9:	ff d0                	call   *%rax
    if (res < 0) return res;
  8015eb:	85 c0                	test   %eax,%eax
  8015ed:	78 35                	js     801624 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8015ef:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8015f3:	48 b8 88 06 80 00 00 	movabs $0x800688,%rax
  8015fa:	00 00 00 
  8015fd:	ff d0                	call   *%rax
  8015ff:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801602:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801607:	be 00 10 00 00       	mov    $0x1000,%esi
  80160c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801610:	48 b8 7e 02 80 00 00 	movabs $0x80027e,%rax
  801617:	00 00 00 
  80161a:	ff d0                	call   *%rax
  80161c:	85 c0                	test   %eax,%eax
  80161e:	0f 94 c0             	sete   %al
  801621:	0f b6 c0             	movzbl %al,%eax
}
  801624:	c9                   	leave
  801625:	c3                   	ret

0000000000801626 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  801626:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80162a:	48 89 f8             	mov    %rdi,%rax
  80162d:	48 c1 e8 27          	shr    $0x27,%rax
  801631:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  801638:	7f 00 00 
  80163b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80163f:	f6 c2 01             	test   $0x1,%dl
  801642:	74 6d                	je     8016b1 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801644:	48 89 f8             	mov    %rdi,%rax
  801647:	48 c1 e8 1e          	shr    $0x1e,%rax
  80164b:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801652:	7f 00 00 
  801655:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801659:	f6 c2 01             	test   $0x1,%dl
  80165c:	74 62                	je     8016c0 <get_uvpt_entry+0x9a>
  80165e:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801665:	7f 00 00 
  801668:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80166c:	f6 c2 80             	test   $0x80,%dl
  80166f:	75 4f                	jne    8016c0 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801671:	48 89 f8             	mov    %rdi,%rax
  801674:	48 c1 e8 15          	shr    $0x15,%rax
  801678:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80167f:	7f 00 00 
  801682:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801686:	f6 c2 01             	test   $0x1,%dl
  801689:	74 44                	je     8016cf <get_uvpt_entry+0xa9>
  80168b:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  801692:	7f 00 00 
  801695:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801699:	f6 c2 80             	test   $0x80,%dl
  80169c:	75 31                	jne    8016cf <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80169e:	48 c1 ef 0c          	shr    $0xc,%rdi
  8016a2:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8016a9:	7f 00 00 
  8016ac:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8016b0:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8016b1:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8016b8:	7f 00 00 
  8016bb:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016bf:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8016c0:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8016c7:	7f 00 00 
  8016ca:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016ce:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8016cf:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016d6:	7f 00 00 
  8016d9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016dd:	c3                   	ret

00000000008016de <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8016de:	f3 0f 1e fa          	endbr64
  8016e2:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8016e5:	48 89 f9             	mov    %rdi,%rcx
  8016e8:	48 c1 e9 27          	shr    $0x27,%rcx
  8016ec:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8016f3:	7f 00 00 
  8016f6:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8016fa:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  801701:	f6 c1 01             	test   $0x1,%cl
  801704:	0f 84 b2 00 00 00    	je     8017bc <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80170a:	48 89 f9             	mov    %rdi,%rcx
  80170d:	48 c1 e9 1e          	shr    $0x1e,%rcx
  801711:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801718:	7f 00 00 
  80171b:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80171f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  801726:	40 f6 c6 01          	test   $0x1,%sil
  80172a:	0f 84 8c 00 00 00    	je     8017bc <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  801730:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801737:	7f 00 00 
  80173a:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80173e:	a8 80                	test   $0x80,%al
  801740:	75 7b                	jne    8017bd <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  801742:	48 89 f9             	mov    %rdi,%rcx
  801745:	48 c1 e9 15          	shr    $0x15,%rcx
  801749:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801750:	7f 00 00 
  801753:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801757:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  80175e:	40 f6 c6 01          	test   $0x1,%sil
  801762:	74 58                	je     8017bc <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  801764:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80176b:	7f 00 00 
  80176e:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801772:	a8 80                	test   $0x80,%al
  801774:	75 6c                	jne    8017e2 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  801776:	48 89 f9             	mov    %rdi,%rcx
  801779:	48 c1 e9 0c          	shr    $0xc,%rcx
  80177d:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801784:	7f 00 00 
  801787:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80178b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  801792:	40 f6 c6 01          	test   $0x1,%sil
  801796:	74 24                	je     8017bc <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  801798:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80179f:	7f 00 00 
  8017a2:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017a6:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017ad:	ff ff 7f 
  8017b0:	48 21 c8             	and    %rcx,%rax
  8017b3:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8017b9:	48 09 d0             	or     %rdx,%rax
}
  8017bc:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8017bd:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8017c4:	7f 00 00 
  8017c7:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017cb:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017d2:	ff ff 7f 
  8017d5:	48 21 c8             	and    %rcx,%rax
  8017d8:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8017de:	48 01 d0             	add    %rdx,%rax
  8017e1:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8017e2:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8017e9:	7f 00 00 
  8017ec:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017f0:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017f7:	ff ff 7f 
  8017fa:	48 21 c8             	and    %rcx,%rax
  8017fd:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  801803:	48 01 d0             	add    %rdx,%rax
  801806:	c3                   	ret

0000000000801807 <get_prot>:

int
get_prot(void *va) {
  801807:	f3 0f 1e fa          	endbr64
  80180b:	55                   	push   %rbp
  80180c:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80180f:	48 b8 26 16 80 00 00 	movabs $0x801626,%rax
  801816:	00 00 00 
  801819:	ff d0                	call   *%rax
  80181b:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  80181e:	83 e0 01             	and    $0x1,%eax
  801821:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  801824:	89 d1                	mov    %edx,%ecx
  801826:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  80182c:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80182e:	89 c1                	mov    %eax,%ecx
  801830:	83 c9 02             	or     $0x2,%ecx
  801833:	f6 c2 02             	test   $0x2,%dl
  801836:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  801839:	89 c1                	mov    %eax,%ecx
  80183b:	83 c9 01             	or     $0x1,%ecx
  80183e:	48 85 d2             	test   %rdx,%rdx
  801841:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801844:	89 c1                	mov    %eax,%ecx
  801846:	83 c9 40             	or     $0x40,%ecx
  801849:	f6 c6 04             	test   $0x4,%dh
  80184c:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80184f:	5d                   	pop    %rbp
  801850:	c3                   	ret

0000000000801851 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801851:	f3 0f 1e fa          	endbr64
  801855:	55                   	push   %rbp
  801856:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801859:	48 b8 26 16 80 00 00 	movabs $0x801626,%rax
  801860:	00 00 00 
  801863:	ff d0                	call   *%rax
    return pte & PTE_D;
  801865:	48 c1 e8 06          	shr    $0x6,%rax
  801869:	83 e0 01             	and    $0x1,%eax
}
  80186c:	5d                   	pop    %rbp
  80186d:	c3                   	ret

000000000080186e <is_page_present>:

bool
is_page_present(void *va) {
  80186e:	f3 0f 1e fa          	endbr64
  801872:	55                   	push   %rbp
  801873:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  801876:	48 b8 26 16 80 00 00 	movabs $0x801626,%rax
  80187d:	00 00 00 
  801880:	ff d0                	call   *%rax
  801882:	83 e0 01             	and    $0x1,%eax
}
  801885:	5d                   	pop    %rbp
  801886:	c3                   	ret

0000000000801887 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801887:	f3 0f 1e fa          	endbr64
  80188b:	55                   	push   %rbp
  80188c:	48 89 e5             	mov    %rsp,%rbp
  80188f:	41 57                	push   %r15
  801891:	41 56                	push   %r14
  801893:	41 55                	push   %r13
  801895:	41 54                	push   %r12
  801897:	53                   	push   %rbx
  801898:	48 83 ec 18          	sub    $0x18,%rsp
  80189c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8018a0:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8018a4:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8018a9:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8018b0:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8018b3:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8018ba:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8018bd:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8018c4:	00 00 00 
  8018c7:	eb 73                	jmp    80193c <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018c9:	48 89 d8             	mov    %rbx,%rax
  8018cc:	48 c1 e8 15          	shr    $0x15,%rax
  8018d0:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8018d7:	7f 00 00 
  8018da:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8018de:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018e4:	f6 c2 01             	test   $0x1,%dl
  8018e7:	74 4b                	je     801934 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8018e9:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8018ed:	f6 c2 80             	test   $0x80,%dl
  8018f0:	74 11                	je     801903 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8018f2:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8018f6:	f6 c4 04             	test   $0x4,%ah
  8018f9:	74 39                	je     801934 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8018fb:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  801901:	eb 20                	jmp    801923 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801903:	48 89 da             	mov    %rbx,%rdx
  801906:	48 c1 ea 0c          	shr    $0xc,%rdx
  80190a:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801911:	7f 00 00 
  801914:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  801918:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80191e:	f6 c4 04             	test   $0x4,%ah
  801921:	74 11                	je     801934 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  801923:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  801927:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80192b:	48 89 df             	mov    %rbx,%rdi
  80192e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801932:	ff d0                	call   *%rax
    next:
        va += size;
  801934:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  801937:	49 39 df             	cmp    %rbx,%r15
  80193a:	72 3e                	jb     80197a <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  80193c:	49 8b 06             	mov    (%r14),%rax
  80193f:	a8 01                	test   $0x1,%al
  801941:	74 37                	je     80197a <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801943:	48 89 d8             	mov    %rbx,%rax
  801946:	48 c1 e8 1e          	shr    $0x1e,%rax
  80194a:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  80194f:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801955:	f6 c2 01             	test   $0x1,%dl
  801958:	74 da                	je     801934 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  80195a:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  80195f:	f6 c2 80             	test   $0x80,%dl
  801962:	0f 84 61 ff ff ff    	je     8018c9 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  801968:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80196d:	f6 c4 04             	test   $0x4,%ah
  801970:	74 c2                	je     801934 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  801972:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  801978:	eb a9                	jmp    801923 <foreach_shared_region+0x9c>
    }
    return res;
}
  80197a:	b8 00 00 00 00       	mov    $0x0,%eax
  80197f:	48 83 c4 18          	add    $0x18,%rsp
  801983:	5b                   	pop    %rbx
  801984:	41 5c                	pop    %r12
  801986:	41 5d                	pop    %r13
  801988:	41 5e                	pop    %r14
  80198a:	41 5f                	pop    %r15
  80198c:	5d                   	pop    %rbp
  80198d:	c3                   	ret

000000000080198e <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  80198e:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  801992:	b8 00 00 00 00       	mov    $0x0,%eax
  801997:	c3                   	ret

0000000000801998 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  801998:	f3 0f 1e fa          	endbr64
  80199c:	55                   	push   %rbp
  80199d:	48 89 e5             	mov    %rsp,%rbp
  8019a0:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8019a3:	48 be a5 30 80 00 00 	movabs $0x8030a5,%rsi
  8019aa:	00 00 00 
  8019ad:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  8019b4:	00 00 00 
  8019b7:	ff d0                	call   *%rax
    return 0;
}
  8019b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019be:	5d                   	pop    %rbp
  8019bf:	c3                   	ret

00000000008019c0 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8019c0:	f3 0f 1e fa          	endbr64
  8019c4:	55                   	push   %rbp
  8019c5:	48 89 e5             	mov    %rsp,%rbp
  8019c8:	41 57                	push   %r15
  8019ca:	41 56                	push   %r14
  8019cc:	41 55                	push   %r13
  8019ce:	41 54                	push   %r12
  8019d0:	53                   	push   %rbx
  8019d1:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8019d8:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8019df:	48 85 d2             	test   %rdx,%rdx
  8019e2:	74 7a                	je     801a5e <devcons_write+0x9e>
  8019e4:	49 89 d6             	mov    %rdx,%r14
  8019e7:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8019ed:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8019f2:	49 bf 99 28 80 00 00 	movabs $0x802899,%r15
  8019f9:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8019fc:	4c 89 f3             	mov    %r14,%rbx
  8019ff:	48 29 f3             	sub    %rsi,%rbx
  801a02:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a07:	48 39 c3             	cmp    %rax,%rbx
  801a0a:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801a0e:	4c 63 eb             	movslq %ebx,%r13
  801a11:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801a18:	48 01 c6             	add    %rax,%rsi
  801a1b:	4c 89 ea             	mov    %r13,%rdx
  801a1e:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a25:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  801a28:	4c 89 ee             	mov    %r13,%rsi
  801a2b:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a32:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  801a39:	00 00 00 
  801a3c:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801a3e:	41 01 dc             	add    %ebx,%r12d
  801a41:	49 63 f4             	movslq %r12d,%rsi
  801a44:	4c 39 f6             	cmp    %r14,%rsi
  801a47:	72 b3                	jb     8019fc <devcons_write+0x3c>
    return res;
  801a49:	49 63 c4             	movslq %r12d,%rax
}
  801a4c:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801a53:	5b                   	pop    %rbx
  801a54:	41 5c                	pop    %r12
  801a56:	41 5d                	pop    %r13
  801a58:	41 5e                	pop    %r14
  801a5a:	41 5f                	pop    %r15
  801a5c:	5d                   	pop    %rbp
  801a5d:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  801a5e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a64:	eb e3                	jmp    801a49 <devcons_write+0x89>

0000000000801a66 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a66:	f3 0f 1e fa          	endbr64
  801a6a:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801a6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a72:	48 85 c0             	test   %rax,%rax
  801a75:	74 55                	je     801acc <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a77:	55                   	push   %rbp
  801a78:	48 89 e5             	mov    %rsp,%rbp
  801a7b:	41 55                	push   %r13
  801a7d:	41 54                	push   %r12
  801a7f:	53                   	push   %rbx
  801a80:	48 83 ec 08          	sub    $0x8,%rsp
  801a84:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801a87:	48 bb 3a 01 80 00 00 	movabs $0x80013a,%rbx
  801a8e:	00 00 00 
  801a91:	49 bc 13 02 80 00 00 	movabs $0x800213,%r12
  801a98:	00 00 00 
  801a9b:	eb 03                	jmp    801aa0 <devcons_read+0x3a>
  801a9d:	41 ff d4             	call   *%r12
  801aa0:	ff d3                	call   *%rbx
  801aa2:	85 c0                	test   %eax,%eax
  801aa4:	74 f7                	je     801a9d <devcons_read+0x37>
    if (c < 0) return c;
  801aa6:	48 63 d0             	movslq %eax,%rdx
  801aa9:	78 13                	js     801abe <devcons_read+0x58>
    if (c == 0x04) return 0;
  801aab:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab0:	83 f8 04             	cmp    $0x4,%eax
  801ab3:	74 09                	je     801abe <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  801ab5:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801ab9:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801abe:	48 89 d0             	mov    %rdx,%rax
  801ac1:	48 83 c4 08          	add    $0x8,%rsp
  801ac5:	5b                   	pop    %rbx
  801ac6:	41 5c                	pop    %r12
  801ac8:	41 5d                	pop    %r13
  801aca:	5d                   	pop    %rbp
  801acb:	c3                   	ret
  801acc:	48 89 d0             	mov    %rdx,%rax
  801acf:	c3                   	ret

0000000000801ad0 <cputchar>:
cputchar(int ch) {
  801ad0:	f3 0f 1e fa          	endbr64
  801ad4:	55                   	push   %rbp
  801ad5:	48 89 e5             	mov    %rsp,%rbp
  801ad8:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801adc:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801ae0:	be 01 00 00 00       	mov    $0x1,%esi
  801ae5:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801ae9:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  801af0:	00 00 00 
  801af3:	ff d0                	call   *%rax
}
  801af5:	c9                   	leave
  801af6:	c3                   	ret

0000000000801af7 <getchar>:
getchar(void) {
  801af7:	f3 0f 1e fa          	endbr64
  801afb:	55                   	push   %rbp
  801afc:	48 89 e5             	mov    %rsp,%rbp
  801aff:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801b03:	ba 01 00 00 00       	mov    $0x1,%edx
  801b08:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801b0c:	bf 00 00 00 00       	mov    $0x0,%edi
  801b11:	48 b8 07 0a 80 00 00 	movabs $0x800a07,%rax
  801b18:	00 00 00 
  801b1b:	ff d0                	call   *%rax
  801b1d:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	78 06                	js     801b29 <getchar+0x32>
  801b23:	74 08                	je     801b2d <getchar+0x36>
  801b25:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  801b29:	89 d0                	mov    %edx,%eax
  801b2b:	c9                   	leave
  801b2c:	c3                   	ret
    return res < 0 ? res : res ? c :
  801b2d:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801b32:	eb f5                	jmp    801b29 <getchar+0x32>

0000000000801b34 <iscons>:
iscons(int fdnum) {
  801b34:	f3 0f 1e fa          	endbr64
  801b38:	55                   	push   %rbp
  801b39:	48 89 e5             	mov    %rsp,%rbp
  801b3c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801b40:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b44:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  801b4b:	00 00 00 
  801b4e:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b50:	85 c0                	test   %eax,%eax
  801b52:	78 18                	js     801b6c <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  801b54:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b58:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801b5f:	00 00 00 
  801b62:	8b 00                	mov    (%rax),%eax
  801b64:	39 02                	cmp    %eax,(%rdx)
  801b66:	0f 94 c0             	sete   %al
  801b69:	0f b6 c0             	movzbl %al,%eax
}
  801b6c:	c9                   	leave
  801b6d:	c3                   	ret

0000000000801b6e <opencons>:
opencons(void) {
  801b6e:	f3 0f 1e fa          	endbr64
  801b72:	55                   	push   %rbp
  801b73:	48 89 e5             	mov    %rsp,%rbp
  801b76:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801b7a:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801b7e:	48 b8 a8 06 80 00 00 	movabs $0x8006a8,%rax
  801b85:	00 00 00 
  801b88:	ff d0                	call   *%rax
  801b8a:	85 c0                	test   %eax,%eax
  801b8c:	78 49                	js     801bd7 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801b8e:	b9 46 00 00 00       	mov    $0x46,%ecx
  801b93:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b98:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801b9c:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba1:	48 b8 ae 02 80 00 00 	movabs $0x8002ae,%rax
  801ba8:	00 00 00 
  801bab:	ff d0                	call   *%rax
  801bad:	85 c0                	test   %eax,%eax
  801baf:	78 26                	js     801bd7 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  801bb1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bb5:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801bbc:	00 00 
  801bbe:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801bc0:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801bc4:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801bcb:	48 b8 72 06 80 00 00 	movabs $0x800672,%rax
  801bd2:	00 00 00 
  801bd5:	ff d0                	call   *%rax
}
  801bd7:	c9                   	leave
  801bd8:	c3                   	ret

0000000000801bd9 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801bd9:	f3 0f 1e fa          	endbr64
  801bdd:	55                   	push   %rbp
  801bde:	48 89 e5             	mov    %rsp,%rbp
  801be1:	41 56                	push   %r14
  801be3:	41 55                	push   %r13
  801be5:	41 54                	push   %r12
  801be7:	53                   	push   %rbx
  801be8:	48 83 ec 50          	sub    $0x50,%rsp
  801bec:	49 89 fc             	mov    %rdi,%r12
  801bef:	41 89 f5             	mov    %esi,%r13d
  801bf2:	48 89 d3             	mov    %rdx,%rbx
  801bf5:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801bf9:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801bfd:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801c01:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801c08:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c0c:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801c10:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801c14:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801c18:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801c1f:	00 00 00 
  801c22:	4c 8b 30             	mov    (%rax),%r14
  801c25:	48 b8 de 01 80 00 00 	movabs $0x8001de,%rax
  801c2c:	00 00 00 
  801c2f:	ff d0                	call   *%rax
  801c31:	89 c6                	mov    %eax,%esi
  801c33:	45 89 e8             	mov    %r13d,%r8d
  801c36:	4c 89 e1             	mov    %r12,%rcx
  801c39:	4c 89 f2             	mov    %r14,%rdx
  801c3c:	48 bf e8 32 80 00 00 	movabs $0x8032e8,%rdi
  801c43:	00 00 00 
  801c46:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4b:	49 bc 35 1d 80 00 00 	movabs $0x801d35,%r12
  801c52:	00 00 00 
  801c55:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801c58:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801c5c:	48 89 df             	mov    %rbx,%rdi
  801c5f:	48 b8 cd 1c 80 00 00 	movabs $0x801ccd,%rax
  801c66:	00 00 00 
  801c69:	ff d0                	call   *%rax
    cprintf("\n");
  801c6b:	48 bf 32 30 80 00 00 	movabs $0x803032,%rdi
  801c72:	00 00 00 
  801c75:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7a:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801c7d:	cc                   	int3
  801c7e:	eb fd                	jmp    801c7d <_panic+0xa4>

0000000000801c80 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801c80:	f3 0f 1e fa          	endbr64
  801c84:	55                   	push   %rbp
  801c85:	48 89 e5             	mov    %rsp,%rbp
  801c88:	53                   	push   %rbx
  801c89:	48 83 ec 08          	sub    $0x8,%rsp
  801c8d:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801c90:	8b 06                	mov    (%rsi),%eax
  801c92:	8d 50 01             	lea    0x1(%rax),%edx
  801c95:	89 16                	mov    %edx,(%rsi)
  801c97:	48 98                	cltq
  801c99:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801c9e:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801ca4:	74 0a                	je     801cb0 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801ca6:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801caa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cae:	c9                   	leave
  801caf:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  801cb0:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801cb4:	be ff 00 00 00       	mov    $0xff,%esi
  801cb9:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  801cc0:	00 00 00 
  801cc3:	ff d0                	call   *%rax
        state->offset = 0;
  801cc5:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801ccb:	eb d9                	jmp    801ca6 <putch+0x26>

0000000000801ccd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801ccd:	f3 0f 1e fa          	endbr64
  801cd1:	55                   	push   %rbp
  801cd2:	48 89 e5             	mov    %rsp,%rbp
  801cd5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801cdc:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801cdf:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801ce6:	b9 21 00 00 00       	mov    $0x21,%ecx
  801ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf0:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801cf3:	48 89 f1             	mov    %rsi,%rcx
  801cf6:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801cfd:	48 bf 80 1c 80 00 00 	movabs $0x801c80,%rdi
  801d04:	00 00 00 
  801d07:	48 b8 95 1e 80 00 00 	movabs $0x801e95,%rax
  801d0e:	00 00 00 
  801d11:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801d13:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801d1a:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801d21:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  801d28:	00 00 00 
  801d2b:	ff d0                	call   *%rax

    return state.count;
}
  801d2d:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801d33:	c9                   	leave
  801d34:	c3                   	ret

0000000000801d35 <cprintf>:

int
cprintf(const char *fmt, ...) {
  801d35:	f3 0f 1e fa          	endbr64
  801d39:	55                   	push   %rbp
  801d3a:	48 89 e5             	mov    %rsp,%rbp
  801d3d:	48 83 ec 50          	sub    $0x50,%rsp
  801d41:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801d45:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801d49:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d4d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801d51:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801d55:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801d5c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d60:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d64:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801d68:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801d6c:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801d70:	48 b8 cd 1c 80 00 00 	movabs $0x801ccd,%rax
  801d77:	00 00 00 
  801d7a:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801d7c:	c9                   	leave
  801d7d:	c3                   	ret

0000000000801d7e <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801d7e:	f3 0f 1e fa          	endbr64
  801d82:	55                   	push   %rbp
  801d83:	48 89 e5             	mov    %rsp,%rbp
  801d86:	41 57                	push   %r15
  801d88:	41 56                	push   %r14
  801d8a:	41 55                	push   %r13
  801d8c:	41 54                	push   %r12
  801d8e:	53                   	push   %rbx
  801d8f:	48 83 ec 18          	sub    $0x18,%rsp
  801d93:	49 89 fc             	mov    %rdi,%r12
  801d96:	49 89 f5             	mov    %rsi,%r13
  801d99:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801d9d:	8b 45 10             	mov    0x10(%rbp),%eax
  801da0:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801da3:	41 89 cf             	mov    %ecx,%r15d
  801da6:	4c 39 fa             	cmp    %r15,%rdx
  801da9:	73 5b                	jae    801e06 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801dab:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801daf:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801db3:	85 db                	test   %ebx,%ebx
  801db5:	7e 0e                	jle    801dc5 <print_num+0x47>
            putch(padc, put_arg);
  801db7:	4c 89 ee             	mov    %r13,%rsi
  801dba:	44 89 f7             	mov    %r14d,%edi
  801dbd:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801dc0:	83 eb 01             	sub    $0x1,%ebx
  801dc3:	75 f2                	jne    801db7 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801dc5:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801dc9:	48 b9 c2 30 80 00 00 	movabs $0x8030c2,%rcx
  801dd0:	00 00 00 
  801dd3:	48 b8 b1 30 80 00 00 	movabs $0x8030b1,%rax
  801dda:	00 00 00 
  801ddd:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801de1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801de5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dea:	49 f7 f7             	div    %r15
  801ded:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801df1:	4c 89 ee             	mov    %r13,%rsi
  801df4:	41 ff d4             	call   *%r12
}
  801df7:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801dfb:	5b                   	pop    %rbx
  801dfc:	41 5c                	pop    %r12
  801dfe:	41 5d                	pop    %r13
  801e00:	41 5e                	pop    %r14
  801e02:	41 5f                	pop    %r15
  801e04:	5d                   	pop    %rbp
  801e05:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801e06:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0f:	49 f7 f7             	div    %r15
  801e12:	48 83 ec 08          	sub    $0x8,%rsp
  801e16:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801e1a:	52                   	push   %rdx
  801e1b:	45 0f be c9          	movsbl %r9b,%r9d
  801e1f:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801e23:	48 89 c2             	mov    %rax,%rdx
  801e26:	48 b8 7e 1d 80 00 00 	movabs $0x801d7e,%rax
  801e2d:	00 00 00 
  801e30:	ff d0                	call   *%rax
  801e32:	48 83 c4 10          	add    $0x10,%rsp
  801e36:	eb 8d                	jmp    801dc5 <print_num+0x47>

0000000000801e38 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  801e38:	f3 0f 1e fa          	endbr64
    state->count++;
  801e3c:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801e40:	48 8b 06             	mov    (%rsi),%rax
  801e43:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801e47:	73 0a                	jae    801e53 <sprintputch+0x1b>
        *state->start++ = ch;
  801e49:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e4d:	48 89 16             	mov    %rdx,(%rsi)
  801e50:	40 88 38             	mov    %dil,(%rax)
    }
}
  801e53:	c3                   	ret

0000000000801e54 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801e54:	f3 0f 1e fa          	endbr64
  801e58:	55                   	push   %rbp
  801e59:	48 89 e5             	mov    %rsp,%rbp
  801e5c:	48 83 ec 50          	sub    $0x50,%rsp
  801e60:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e64:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801e68:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801e6c:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801e73:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e77:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e7b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801e7f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801e83:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801e87:	48 b8 95 1e 80 00 00 	movabs $0x801e95,%rax
  801e8e:	00 00 00 
  801e91:	ff d0                	call   *%rax
}
  801e93:	c9                   	leave
  801e94:	c3                   	ret

0000000000801e95 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801e95:	f3 0f 1e fa          	endbr64
  801e99:	55                   	push   %rbp
  801e9a:	48 89 e5             	mov    %rsp,%rbp
  801e9d:	41 57                	push   %r15
  801e9f:	41 56                	push   %r14
  801ea1:	41 55                	push   %r13
  801ea3:	41 54                	push   %r12
  801ea5:	53                   	push   %rbx
  801ea6:	48 83 ec 38          	sub    $0x38,%rsp
  801eaa:	49 89 fe             	mov    %rdi,%r14
  801ead:	49 89 f5             	mov    %rsi,%r13
  801eb0:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  801eb3:	48 8b 01             	mov    (%rcx),%rax
  801eb6:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801eba:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801ebe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ec2:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801ec6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801eca:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  801ece:	0f b6 3b             	movzbl (%rbx),%edi
  801ed1:	40 80 ff 25          	cmp    $0x25,%dil
  801ed5:	74 18                	je     801eef <vprintfmt+0x5a>
            if (!ch) return;
  801ed7:	40 84 ff             	test   %dil,%dil
  801eda:	0f 84 b2 06 00 00    	je     802592 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  801ee0:	40 0f b6 ff          	movzbl %dil,%edi
  801ee4:	4c 89 ee             	mov    %r13,%rsi
  801ee7:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  801eea:	4c 89 e3             	mov    %r12,%rbx
  801eed:	eb db                	jmp    801eca <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  801eef:	be 00 00 00 00       	mov    $0x0,%esi
  801ef4:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  801ef8:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801efd:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f03:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801f0a:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f0e:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  801f13:	41 0f b6 04 24       	movzbl (%r12),%eax
  801f18:	88 45 a0             	mov    %al,-0x60(%rbp)
  801f1b:	83 e8 23             	sub    $0x23,%eax
  801f1e:	3c 57                	cmp    $0x57,%al
  801f20:	0f 87 52 06 00 00    	ja     802578 <vprintfmt+0x6e3>
  801f26:	0f b6 c0             	movzbl %al,%eax
  801f29:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  801f30:	00 00 00 
  801f33:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  801f37:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  801f3a:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  801f3e:	eb ce                	jmp    801f0e <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  801f40:	49 89 dc             	mov    %rbx,%r12
  801f43:	be 01 00 00 00       	mov    $0x1,%esi
  801f48:	eb c4                	jmp    801f0e <vprintfmt+0x79>
            padc = ch;
  801f4a:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  801f4e:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f51:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801f54:	eb b8                	jmp    801f0e <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f59:	83 f8 2f             	cmp    $0x2f,%eax
  801f5c:	77 24                	ja     801f82 <vprintfmt+0xed>
  801f5e:	89 c1                	mov    %eax,%ecx
  801f60:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  801f64:	83 c0 08             	add    $0x8,%eax
  801f67:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f6a:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  801f6d:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  801f70:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801f74:	79 98                	jns    801f0e <vprintfmt+0x79>
                width = precision;
  801f76:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  801f7a:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f80:	eb 8c                	jmp    801f0e <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f82:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801f86:	48 8d 41 08          	lea    0x8(%rcx),%rax
  801f8a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801f8e:	eb da                	jmp    801f6a <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  801f90:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  801f95:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801f99:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  801f9f:	3c 39                	cmp    $0x39,%al
  801fa1:	77 1c                	ja     801fbf <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  801fa3:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  801fa7:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  801fab:	0f b6 c0             	movzbl %al,%eax
  801fae:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fb3:	0f b6 03             	movzbl (%rbx),%eax
  801fb6:	3c 39                	cmp    $0x39,%al
  801fb8:	76 e9                	jbe    801fa3 <vprintfmt+0x10e>
        process_precision:
  801fba:	49 89 dc             	mov    %rbx,%r12
  801fbd:	eb b1                	jmp    801f70 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  801fbf:	49 89 dc             	mov    %rbx,%r12
  801fc2:	eb ac                	jmp    801f70 <vprintfmt+0xdb>
            width = MAX(0, width);
  801fc4:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  801fc7:	85 c9                	test   %ecx,%ecx
  801fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fce:	0f 49 c1             	cmovns %ecx,%eax
  801fd1:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801fd4:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fd7:	e9 32 ff ff ff       	jmp    801f0e <vprintfmt+0x79>
            lflag++;
  801fdc:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801fdf:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fe2:	e9 27 ff ff ff       	jmp    801f0e <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  801fe7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fea:	83 f8 2f             	cmp    $0x2f,%eax
  801fed:	77 19                	ja     802008 <vprintfmt+0x173>
  801fef:	89 c2                	mov    %eax,%edx
  801ff1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801ff5:	83 c0 08             	add    $0x8,%eax
  801ff8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801ffb:	8b 3a                	mov    (%rdx),%edi
  801ffd:	4c 89 ee             	mov    %r13,%rsi
  802000:	41 ff d6             	call   *%r14
            break;
  802003:	e9 c2 fe ff ff       	jmp    801eca <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  802008:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80200c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802010:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802014:	eb e5                	jmp    801ffb <vprintfmt+0x166>
            int err = va_arg(aq, int);
  802016:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802019:	83 f8 2f             	cmp    $0x2f,%eax
  80201c:	77 5a                	ja     802078 <vprintfmt+0x1e3>
  80201e:	89 c2                	mov    %eax,%edx
  802020:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802024:	83 c0 08             	add    $0x8,%eax
  802027:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  80202a:	8b 02                	mov    (%rdx),%eax
  80202c:	89 c1                	mov    %eax,%ecx
  80202e:	f7 d9                	neg    %ecx
  802030:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  802033:	83 f9 13             	cmp    $0x13,%ecx
  802036:	7f 4e                	jg     802086 <vprintfmt+0x1f1>
  802038:	48 63 c1             	movslq %ecx,%rax
  80203b:	48 ba 20 36 80 00 00 	movabs $0x803620,%rdx
  802042:	00 00 00 
  802045:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802049:	48 85 c0             	test   %rax,%rax
  80204c:	74 38                	je     802086 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  80204e:	48 89 c1             	mov    %rax,%rcx
  802051:	48 ba 80 30 80 00 00 	movabs $0x803080,%rdx
  802058:	00 00 00 
  80205b:	4c 89 ee             	mov    %r13,%rsi
  80205e:	4c 89 f7             	mov    %r14,%rdi
  802061:	b8 00 00 00 00       	mov    $0x0,%eax
  802066:	49 b8 54 1e 80 00 00 	movabs $0x801e54,%r8
  80206d:	00 00 00 
  802070:	41 ff d0             	call   *%r8
  802073:	e9 52 fe ff ff       	jmp    801eca <vprintfmt+0x35>
            int err = va_arg(aq, int);
  802078:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80207c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802080:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802084:	eb a4                	jmp    80202a <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  802086:	48 ba da 30 80 00 00 	movabs $0x8030da,%rdx
  80208d:	00 00 00 
  802090:	4c 89 ee             	mov    %r13,%rsi
  802093:	4c 89 f7             	mov    %r14,%rdi
  802096:	b8 00 00 00 00       	mov    $0x0,%eax
  80209b:	49 b8 54 1e 80 00 00 	movabs $0x801e54,%r8
  8020a2:	00 00 00 
  8020a5:	41 ff d0             	call   *%r8
  8020a8:	e9 1d fe ff ff       	jmp    801eca <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8020ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020b0:	83 f8 2f             	cmp    $0x2f,%eax
  8020b3:	77 6c                	ja     802121 <vprintfmt+0x28c>
  8020b5:	89 c2                	mov    %eax,%edx
  8020b7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8020bb:	83 c0 08             	add    $0x8,%eax
  8020be:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020c1:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8020c4:	48 85 d2             	test   %rdx,%rdx
  8020c7:	48 b8 d3 30 80 00 00 	movabs $0x8030d3,%rax
  8020ce:	00 00 00 
  8020d1:	48 0f 45 c2          	cmovne %rdx,%rax
  8020d5:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8020d9:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8020dd:	7e 06                	jle    8020e5 <vprintfmt+0x250>
  8020df:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8020e3:	75 4a                	jne    80212f <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8020e5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8020e9:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8020ed:	0f b6 00             	movzbl (%rax),%eax
  8020f0:	84 c0                	test   %al,%al
  8020f2:	0f 85 9a 00 00 00    	jne    802192 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8020f8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8020fb:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8020ff:	85 c0                	test   %eax,%eax
  802101:	0f 8e c3 fd ff ff    	jle    801eca <vprintfmt+0x35>
  802107:	4c 89 ee             	mov    %r13,%rsi
  80210a:	bf 20 00 00 00       	mov    $0x20,%edi
  80210f:	41 ff d6             	call   *%r14
  802112:	41 83 ec 01          	sub    $0x1,%r12d
  802116:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  80211a:	75 eb                	jne    802107 <vprintfmt+0x272>
  80211c:	e9 a9 fd ff ff       	jmp    801eca <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  802121:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802125:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802129:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80212d:	eb 92                	jmp    8020c1 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  80212f:	49 63 f7             	movslq %r15d,%rsi
  802132:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  802136:	48 b8 58 26 80 00 00 	movabs $0x802658,%rax
  80213d:	00 00 00 
  802140:	ff d0                	call   *%rax
  802142:	48 89 c2             	mov    %rax,%rdx
  802145:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802148:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80214a:	8d 70 ff             	lea    -0x1(%rax),%esi
  80214d:	89 75 ac             	mov    %esi,-0x54(%rbp)
  802150:	85 c0                	test   %eax,%eax
  802152:	7e 91                	jle    8020e5 <vprintfmt+0x250>
  802154:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  802159:	4c 89 ee             	mov    %r13,%rsi
  80215c:	44 89 e7             	mov    %r12d,%edi
  80215f:	41 ff d6             	call   *%r14
  802162:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  802166:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802169:	83 f8 ff             	cmp    $0xffffffff,%eax
  80216c:	75 eb                	jne    802159 <vprintfmt+0x2c4>
  80216e:	e9 72 ff ff ff       	jmp    8020e5 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  802173:	0f b6 f8             	movzbl %al,%edi
  802176:	4c 89 ee             	mov    %r13,%rsi
  802179:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80217c:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  802180:	49 83 c4 01          	add    $0x1,%r12
  802184:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  80218a:	84 c0                	test   %al,%al
  80218c:	0f 84 66 ff ff ff    	je     8020f8 <vprintfmt+0x263>
  802192:	45 85 ff             	test   %r15d,%r15d
  802195:	78 0a                	js     8021a1 <vprintfmt+0x30c>
  802197:	41 83 ef 01          	sub    $0x1,%r15d
  80219b:	0f 88 57 ff ff ff    	js     8020f8 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8021a1:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8021a5:	74 cc                	je     802173 <vprintfmt+0x2de>
  8021a7:	8d 50 e0             	lea    -0x20(%rax),%edx
  8021aa:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8021af:	80 fa 5e             	cmp    $0x5e,%dl
  8021b2:	77 c2                	ja     802176 <vprintfmt+0x2e1>
  8021b4:	eb bd                	jmp    802173 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8021b6:	40 84 f6             	test   %sil,%sil
  8021b9:	75 26                	jne    8021e1 <vprintfmt+0x34c>
    switch (lflag) {
  8021bb:	85 d2                	test   %edx,%edx
  8021bd:	74 59                	je     802218 <vprintfmt+0x383>
  8021bf:	83 fa 01             	cmp    $0x1,%edx
  8021c2:	74 7b                	je     80223f <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8021c4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021c7:	83 f8 2f             	cmp    $0x2f,%eax
  8021ca:	0f 87 96 00 00 00    	ja     802266 <vprintfmt+0x3d1>
  8021d0:	89 c2                	mov    %eax,%edx
  8021d2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021d6:	83 c0 08             	add    $0x8,%eax
  8021d9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021dc:	4c 8b 22             	mov    (%rdx),%r12
  8021df:	eb 17                	jmp    8021f8 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8021e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021e4:	83 f8 2f             	cmp    $0x2f,%eax
  8021e7:	77 21                	ja     80220a <vprintfmt+0x375>
  8021e9:	89 c2                	mov    %eax,%edx
  8021eb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021ef:	83 c0 08             	add    $0x8,%eax
  8021f2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021f5:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8021f8:	4d 85 e4             	test   %r12,%r12
  8021fb:	78 7a                	js     802277 <vprintfmt+0x3e2>
            num = i;
  8021fd:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  802200:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  802205:	e9 50 02 00 00       	jmp    80245a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80220a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80220e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802212:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802216:	eb dd                	jmp    8021f5 <vprintfmt+0x360>
        return va_arg(*ap, int);
  802218:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80221b:	83 f8 2f             	cmp    $0x2f,%eax
  80221e:	77 11                	ja     802231 <vprintfmt+0x39c>
  802220:	89 c2                	mov    %eax,%edx
  802222:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802226:	83 c0 08             	add    $0x8,%eax
  802229:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80222c:	4c 63 22             	movslq (%rdx),%r12
  80222f:	eb c7                	jmp    8021f8 <vprintfmt+0x363>
  802231:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802235:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802239:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80223d:	eb ed                	jmp    80222c <vprintfmt+0x397>
        return va_arg(*ap, long);
  80223f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802242:	83 f8 2f             	cmp    $0x2f,%eax
  802245:	77 11                	ja     802258 <vprintfmt+0x3c3>
  802247:	89 c2                	mov    %eax,%edx
  802249:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80224d:	83 c0 08             	add    $0x8,%eax
  802250:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802253:	4c 8b 22             	mov    (%rdx),%r12
  802256:	eb a0                	jmp    8021f8 <vprintfmt+0x363>
  802258:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80225c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802260:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802264:	eb ed                	jmp    802253 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  802266:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80226a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80226e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802272:	e9 65 ff ff ff       	jmp    8021dc <vprintfmt+0x347>
                putch('-', put_arg);
  802277:	4c 89 ee             	mov    %r13,%rsi
  80227a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80227f:	41 ff d6             	call   *%r14
                i = -i;
  802282:	49 f7 dc             	neg    %r12
  802285:	e9 73 ff ff ff       	jmp    8021fd <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  80228a:	40 84 f6             	test   %sil,%sil
  80228d:	75 32                	jne    8022c1 <vprintfmt+0x42c>
    switch (lflag) {
  80228f:	85 d2                	test   %edx,%edx
  802291:	74 5d                	je     8022f0 <vprintfmt+0x45b>
  802293:	83 fa 01             	cmp    $0x1,%edx
  802296:	0f 84 82 00 00 00    	je     80231e <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  80229c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80229f:	83 f8 2f             	cmp    $0x2f,%eax
  8022a2:	0f 87 a5 00 00 00    	ja     80234d <vprintfmt+0x4b8>
  8022a8:	89 c2                	mov    %eax,%edx
  8022aa:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022ae:	83 c0 08             	add    $0x8,%eax
  8022b1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022b4:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8022bc:	e9 99 01 00 00       	jmp    80245a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8022c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022c4:	83 f8 2f             	cmp    $0x2f,%eax
  8022c7:	77 19                	ja     8022e2 <vprintfmt+0x44d>
  8022c9:	89 c2                	mov    %eax,%edx
  8022cb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022cf:	83 c0 08             	add    $0x8,%eax
  8022d2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022d5:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022d8:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8022dd:	e9 78 01 00 00       	jmp    80245a <vprintfmt+0x5c5>
  8022e2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8022e6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8022ea:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022ee:	eb e5                	jmp    8022d5 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8022f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022f3:	83 f8 2f             	cmp    $0x2f,%eax
  8022f6:	77 18                	ja     802310 <vprintfmt+0x47b>
  8022f8:	89 c2                	mov    %eax,%edx
  8022fa:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022fe:	83 c0 08             	add    $0x8,%eax
  802301:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802304:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  802306:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  80230b:	e9 4a 01 00 00       	jmp    80245a <vprintfmt+0x5c5>
  802310:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802314:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802318:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80231c:	eb e6                	jmp    802304 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  80231e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802321:	83 f8 2f             	cmp    $0x2f,%eax
  802324:	77 19                	ja     80233f <vprintfmt+0x4aa>
  802326:	89 c2                	mov    %eax,%edx
  802328:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80232c:	83 c0 08             	add    $0x8,%eax
  80232f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802332:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  802335:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80233a:	e9 1b 01 00 00       	jmp    80245a <vprintfmt+0x5c5>
  80233f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802343:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802347:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80234b:	eb e5                	jmp    802332 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  80234d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802351:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802355:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802359:	e9 56 ff ff ff       	jmp    8022b4 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  80235e:	40 84 f6             	test   %sil,%sil
  802361:	75 2e                	jne    802391 <vprintfmt+0x4fc>
    switch (lflag) {
  802363:	85 d2                	test   %edx,%edx
  802365:	74 59                	je     8023c0 <vprintfmt+0x52b>
  802367:	83 fa 01             	cmp    $0x1,%edx
  80236a:	74 7f                	je     8023eb <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  80236c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80236f:	83 f8 2f             	cmp    $0x2f,%eax
  802372:	0f 87 9f 00 00 00    	ja     802417 <vprintfmt+0x582>
  802378:	89 c2                	mov    %eax,%edx
  80237a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80237e:	83 c0 08             	add    $0x8,%eax
  802381:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802384:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  802387:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80238c:	e9 c9 00 00 00       	jmp    80245a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  802391:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802394:	83 f8 2f             	cmp    $0x2f,%eax
  802397:	77 19                	ja     8023b2 <vprintfmt+0x51d>
  802399:	89 c2                	mov    %eax,%edx
  80239b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80239f:	83 c0 08             	add    $0x8,%eax
  8023a2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023a5:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023a8:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8023ad:	e9 a8 00 00 00       	jmp    80245a <vprintfmt+0x5c5>
  8023b2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023b6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023ba:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023be:	eb e5                	jmp    8023a5 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8023c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023c3:	83 f8 2f             	cmp    $0x2f,%eax
  8023c6:	77 15                	ja     8023dd <vprintfmt+0x548>
  8023c8:	89 c2                	mov    %eax,%edx
  8023ca:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023ce:	83 c0 08             	add    $0x8,%eax
  8023d1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023d4:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8023d6:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8023db:	eb 7d                	jmp    80245a <vprintfmt+0x5c5>
  8023dd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023e1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023e5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023e9:	eb e9                	jmp    8023d4 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8023eb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023ee:	83 f8 2f             	cmp    $0x2f,%eax
  8023f1:	77 16                	ja     802409 <vprintfmt+0x574>
  8023f3:	89 c2                	mov    %eax,%edx
  8023f5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023f9:	83 c0 08             	add    $0x8,%eax
  8023fc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023ff:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  802402:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  802407:	eb 51                	jmp    80245a <vprintfmt+0x5c5>
  802409:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80240d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802411:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802415:	eb e8                	jmp    8023ff <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  802417:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80241b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80241f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802423:	e9 5c ff ff ff       	jmp    802384 <vprintfmt+0x4ef>
            putch('0', put_arg);
  802428:	4c 89 ee             	mov    %r13,%rsi
  80242b:	bf 30 00 00 00       	mov    $0x30,%edi
  802430:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  802433:	4c 89 ee             	mov    %r13,%rsi
  802436:	bf 78 00 00 00       	mov    $0x78,%edi
  80243b:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  80243e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802441:	83 f8 2f             	cmp    $0x2f,%eax
  802444:	77 47                	ja     80248d <vprintfmt+0x5f8>
  802446:	89 c2                	mov    %eax,%edx
  802448:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80244c:	83 c0 08             	add    $0x8,%eax
  80244f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802452:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802455:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80245a:	48 83 ec 08          	sub    $0x8,%rsp
  80245e:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  802462:	0f 94 c0             	sete   %al
  802465:	0f b6 c0             	movzbl %al,%eax
  802468:	50                   	push   %rax
  802469:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  80246e:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  802472:	4c 89 ee             	mov    %r13,%rsi
  802475:	4c 89 f7             	mov    %r14,%rdi
  802478:	48 b8 7e 1d 80 00 00 	movabs $0x801d7e,%rax
  80247f:	00 00 00 
  802482:	ff d0                	call   *%rax
            break;
  802484:	48 83 c4 10          	add    $0x10,%rsp
  802488:	e9 3d fa ff ff       	jmp    801eca <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  80248d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802491:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802495:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802499:	eb b7                	jmp    802452 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  80249b:	40 84 f6             	test   %sil,%sil
  80249e:	75 2b                	jne    8024cb <vprintfmt+0x636>
    switch (lflag) {
  8024a0:	85 d2                	test   %edx,%edx
  8024a2:	74 56                	je     8024fa <vprintfmt+0x665>
  8024a4:	83 fa 01             	cmp    $0x1,%edx
  8024a7:	74 7f                	je     802528 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  8024a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024ac:	83 f8 2f             	cmp    $0x2f,%eax
  8024af:	0f 87 a2 00 00 00    	ja     802557 <vprintfmt+0x6c2>
  8024b5:	89 c2                	mov    %eax,%edx
  8024b7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024bb:	83 c0 08             	add    $0x8,%eax
  8024be:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024c1:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024c4:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8024c9:	eb 8f                	jmp    80245a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8024cb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024ce:	83 f8 2f             	cmp    $0x2f,%eax
  8024d1:	77 19                	ja     8024ec <vprintfmt+0x657>
  8024d3:	89 c2                	mov    %eax,%edx
  8024d5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024d9:	83 c0 08             	add    $0x8,%eax
  8024dc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024df:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024e2:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8024e7:	e9 6e ff ff ff       	jmp    80245a <vprintfmt+0x5c5>
  8024ec:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024f0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8024f4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024f8:	eb e5                	jmp    8024df <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8024fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024fd:	83 f8 2f             	cmp    $0x2f,%eax
  802500:	77 18                	ja     80251a <vprintfmt+0x685>
  802502:	89 c2                	mov    %eax,%edx
  802504:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802508:	83 c0 08             	add    $0x8,%eax
  80250b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80250e:	8b 12                	mov    (%rdx),%edx
            base = 16;
  802510:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  802515:	e9 40 ff ff ff       	jmp    80245a <vprintfmt+0x5c5>
  80251a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80251e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802522:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802526:	eb e6                	jmp    80250e <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  802528:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80252b:	83 f8 2f             	cmp    $0x2f,%eax
  80252e:	77 19                	ja     802549 <vprintfmt+0x6b4>
  802530:	89 c2                	mov    %eax,%edx
  802532:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802536:	83 c0 08             	add    $0x8,%eax
  802539:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80253c:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80253f:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  802544:	e9 11 ff ff ff       	jmp    80245a <vprintfmt+0x5c5>
  802549:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80254d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802551:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802555:	eb e5                	jmp    80253c <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  802557:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80255b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80255f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802563:	e9 59 ff ff ff       	jmp    8024c1 <vprintfmt+0x62c>
            putch(ch, put_arg);
  802568:	4c 89 ee             	mov    %r13,%rsi
  80256b:	bf 25 00 00 00       	mov    $0x25,%edi
  802570:	41 ff d6             	call   *%r14
            break;
  802573:	e9 52 f9 ff ff       	jmp    801eca <vprintfmt+0x35>
            putch('%', put_arg);
  802578:	4c 89 ee             	mov    %r13,%rsi
  80257b:	bf 25 00 00 00       	mov    $0x25,%edi
  802580:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  802583:	48 83 eb 01          	sub    $0x1,%rbx
  802587:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  80258b:	75 f6                	jne    802583 <vprintfmt+0x6ee>
  80258d:	e9 38 f9 ff ff       	jmp    801eca <vprintfmt+0x35>
}
  802592:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  802596:	5b                   	pop    %rbx
  802597:	41 5c                	pop    %r12
  802599:	41 5d                	pop    %r13
  80259b:	41 5e                	pop    %r14
  80259d:	41 5f                	pop    %r15
  80259f:	5d                   	pop    %rbp
  8025a0:	c3                   	ret

00000000008025a1 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  8025a1:	f3 0f 1e fa          	endbr64
  8025a5:	55                   	push   %rbp
  8025a6:	48 89 e5             	mov    %rsp,%rbp
  8025a9:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  8025ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025b1:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  8025b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8025ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8025c1:	48 85 ff             	test   %rdi,%rdi
  8025c4:	74 2b                	je     8025f1 <vsnprintf+0x50>
  8025c6:	48 85 f6             	test   %rsi,%rsi
  8025c9:	74 26                	je     8025f1 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8025cb:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8025cf:	48 bf 38 1e 80 00 00 	movabs $0x801e38,%rdi
  8025d6:	00 00 00 
  8025d9:	48 b8 95 1e 80 00 00 	movabs $0x801e95,%rax
  8025e0:	00 00 00 
  8025e3:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8025e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025e9:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8025ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025ef:	c9                   	leave
  8025f0:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  8025f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025f6:	eb f7                	jmp    8025ef <vsnprintf+0x4e>

00000000008025f8 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8025f8:	f3 0f 1e fa          	endbr64
  8025fc:	55                   	push   %rbp
  8025fd:	48 89 e5             	mov    %rsp,%rbp
  802600:	48 83 ec 50          	sub    $0x50,%rsp
  802604:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802608:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80260c:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802610:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  802617:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80261b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80261f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802623:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  802627:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80262b:	48 b8 a1 25 80 00 00 	movabs $0x8025a1,%rax
  802632:	00 00 00 
  802635:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  802637:	c9                   	leave
  802638:	c3                   	ret

0000000000802639 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  802639:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  80263d:	80 3f 00             	cmpb   $0x0,(%rdi)
  802640:	74 10                	je     802652 <strlen+0x19>
    size_t n = 0;
  802642:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  802647:	48 83 c0 01          	add    $0x1,%rax
  80264b:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  80264f:	75 f6                	jne    802647 <strlen+0xe>
  802651:	c3                   	ret
    size_t n = 0;
  802652:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  802657:	c3                   	ret

0000000000802658 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  802658:	f3 0f 1e fa          	endbr64
  80265c:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  80265f:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  802664:	48 85 f6             	test   %rsi,%rsi
  802667:	74 10                	je     802679 <strnlen+0x21>
  802669:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  80266d:	74 0b                	je     80267a <strnlen+0x22>
  80266f:	48 83 c2 01          	add    $0x1,%rdx
  802673:	48 39 d0             	cmp    %rdx,%rax
  802676:	75 f1                	jne    802669 <strnlen+0x11>
  802678:	c3                   	ret
  802679:	c3                   	ret
  80267a:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  80267d:	c3                   	ret

000000000080267e <strcpy>:

char *
strcpy(char *dst, const char *src) {
  80267e:	f3 0f 1e fa          	endbr64
  802682:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  802685:	ba 00 00 00 00       	mov    $0x0,%edx
  80268a:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  80268e:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  802691:	48 83 c2 01          	add    $0x1,%rdx
  802695:	84 c9                	test   %cl,%cl
  802697:	75 f1                	jne    80268a <strcpy+0xc>
        ;
    return res;
}
  802699:	c3                   	ret

000000000080269a <strcat>:

char *
strcat(char *dst, const char *src) {
  80269a:	f3 0f 1e fa          	endbr64
  80269e:	55                   	push   %rbp
  80269f:	48 89 e5             	mov    %rsp,%rbp
  8026a2:	41 54                	push   %r12
  8026a4:	53                   	push   %rbx
  8026a5:	48 89 fb             	mov    %rdi,%rbx
  8026a8:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8026ab:	48 b8 39 26 80 00 00 	movabs $0x802639,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  8026b7:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8026bb:	4c 89 e6             	mov    %r12,%rsi
  8026be:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  8026c5:	00 00 00 
  8026c8:	ff d0                	call   *%rax
    return dst;
}
  8026ca:	48 89 d8             	mov    %rbx,%rax
  8026cd:	5b                   	pop    %rbx
  8026ce:	41 5c                	pop    %r12
  8026d0:	5d                   	pop    %rbp
  8026d1:	c3                   	ret

00000000008026d2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8026d2:	f3 0f 1e fa          	endbr64
  8026d6:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  8026d9:	48 85 d2             	test   %rdx,%rdx
  8026dc:	74 1f                	je     8026fd <strncpy+0x2b>
  8026de:	48 01 fa             	add    %rdi,%rdx
  8026e1:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  8026e4:	48 83 c1 01          	add    $0x1,%rcx
  8026e8:	44 0f b6 06          	movzbl (%rsi),%r8d
  8026ec:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  8026f0:	41 80 f8 01          	cmp    $0x1,%r8b
  8026f4:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8026f8:	48 39 ca             	cmp    %rcx,%rdx
  8026fb:	75 e7                	jne    8026e4 <strncpy+0x12>
    }
    return ret;
}
  8026fd:	c3                   	ret

00000000008026fe <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  8026fe:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  802702:	48 89 f8             	mov    %rdi,%rax
  802705:	48 85 d2             	test   %rdx,%rdx
  802708:	74 24                	je     80272e <strlcpy+0x30>
        while (--size > 0 && *src)
  80270a:	48 83 ea 01          	sub    $0x1,%rdx
  80270e:	74 1b                	je     80272b <strlcpy+0x2d>
  802710:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802714:	0f b6 16             	movzbl (%rsi),%edx
  802717:	84 d2                	test   %dl,%dl
  802719:	74 10                	je     80272b <strlcpy+0x2d>
            *dst++ = *src++;
  80271b:	48 83 c6 01          	add    $0x1,%rsi
  80271f:	48 83 c0 01          	add    $0x1,%rax
  802723:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  802726:	48 39 c8             	cmp    %rcx,%rax
  802729:	75 e9                	jne    802714 <strlcpy+0x16>
        *dst = '\0';
  80272b:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  80272e:	48 29 f8             	sub    %rdi,%rax
}
  802731:	c3                   	ret

0000000000802732 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  802732:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  802736:	0f b6 07             	movzbl (%rdi),%eax
  802739:	84 c0                	test   %al,%al
  80273b:	74 13                	je     802750 <strcmp+0x1e>
  80273d:	38 06                	cmp    %al,(%rsi)
  80273f:	75 0f                	jne    802750 <strcmp+0x1e>
  802741:	48 83 c7 01          	add    $0x1,%rdi
  802745:	48 83 c6 01          	add    $0x1,%rsi
  802749:	0f b6 07             	movzbl (%rdi),%eax
  80274c:	84 c0                	test   %al,%al
  80274e:	75 ed                	jne    80273d <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  802750:	0f b6 c0             	movzbl %al,%eax
  802753:	0f b6 16             	movzbl (%rsi),%edx
  802756:	29 d0                	sub    %edx,%eax
}
  802758:	c3                   	ret

0000000000802759 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  802759:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  80275d:	48 85 d2             	test   %rdx,%rdx
  802760:	74 1f                	je     802781 <strncmp+0x28>
  802762:	0f b6 07             	movzbl (%rdi),%eax
  802765:	84 c0                	test   %al,%al
  802767:	74 1e                	je     802787 <strncmp+0x2e>
  802769:	3a 06                	cmp    (%rsi),%al
  80276b:	75 1a                	jne    802787 <strncmp+0x2e>
  80276d:	48 83 c7 01          	add    $0x1,%rdi
  802771:	48 83 c6 01          	add    $0x1,%rsi
  802775:	48 83 ea 01          	sub    $0x1,%rdx
  802779:	75 e7                	jne    802762 <strncmp+0x9>

    if (!n) return 0;
  80277b:	b8 00 00 00 00       	mov    $0x0,%eax
  802780:	c3                   	ret
  802781:	b8 00 00 00 00       	mov    $0x0,%eax
  802786:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  802787:	0f b6 07             	movzbl (%rdi),%eax
  80278a:	0f b6 16             	movzbl (%rsi),%edx
  80278d:	29 d0                	sub    %edx,%eax
}
  80278f:	c3                   	ret

0000000000802790 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  802790:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  802794:	0f b6 17             	movzbl (%rdi),%edx
  802797:	84 d2                	test   %dl,%dl
  802799:	74 18                	je     8027b3 <strchr+0x23>
        if (*str == c) {
  80279b:	0f be d2             	movsbl %dl,%edx
  80279e:	39 f2                	cmp    %esi,%edx
  8027a0:	74 17                	je     8027b9 <strchr+0x29>
    for (; *str; str++) {
  8027a2:	48 83 c7 01          	add    $0x1,%rdi
  8027a6:	0f b6 17             	movzbl (%rdi),%edx
  8027a9:	84 d2                	test   %dl,%dl
  8027ab:	75 ee                	jne    80279b <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  8027ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b2:	c3                   	ret
  8027b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b8:	c3                   	ret
            return (char *)str;
  8027b9:	48 89 f8             	mov    %rdi,%rax
}
  8027bc:	c3                   	ret

00000000008027bd <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  8027bd:	f3 0f 1e fa          	endbr64
  8027c1:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  8027c4:	0f b6 17             	movzbl (%rdi),%edx
  8027c7:	84 d2                	test   %dl,%dl
  8027c9:	74 13                	je     8027de <strfind+0x21>
  8027cb:	0f be d2             	movsbl %dl,%edx
  8027ce:	39 f2                	cmp    %esi,%edx
  8027d0:	74 0b                	je     8027dd <strfind+0x20>
  8027d2:	48 83 c0 01          	add    $0x1,%rax
  8027d6:	0f b6 10             	movzbl (%rax),%edx
  8027d9:	84 d2                	test   %dl,%dl
  8027db:	75 ee                	jne    8027cb <strfind+0xe>
        ;
    return (char *)str;
}
  8027dd:	c3                   	ret
  8027de:	c3                   	ret

00000000008027df <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8027df:	f3 0f 1e fa          	endbr64
  8027e3:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  8027e6:	48 89 f8             	mov    %rdi,%rax
  8027e9:	48 f7 d8             	neg    %rax
  8027ec:	83 e0 07             	and    $0x7,%eax
  8027ef:	49 89 d1             	mov    %rdx,%r9
  8027f2:	49 29 c1             	sub    %rax,%r9
  8027f5:	78 36                	js     80282d <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8027f7:	40 0f b6 c6          	movzbl %sil,%eax
  8027fb:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  802802:	01 01 01 
  802805:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  802809:	40 f6 c7 07          	test   $0x7,%dil
  80280d:	75 38                	jne    802847 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80280f:	4c 89 c9             	mov    %r9,%rcx
  802812:	48 c1 f9 03          	sar    $0x3,%rcx
  802816:	74 0c                	je     802824 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  802818:	fc                   	cld
  802819:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  80281c:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  802820:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  802824:	4d 85 c9             	test   %r9,%r9
  802827:	75 45                	jne    80286e <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  802829:	4c 89 c0             	mov    %r8,%rax
  80282c:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  80282d:	48 85 d2             	test   %rdx,%rdx
  802830:	74 f7                	je     802829 <memset+0x4a>
  802832:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  802835:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  802838:	48 83 c0 01          	add    $0x1,%rax
  80283c:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  802840:	48 39 c2             	cmp    %rax,%rdx
  802843:	75 f3                	jne    802838 <memset+0x59>
  802845:	eb e2                	jmp    802829 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  802847:	40 f6 c7 01          	test   $0x1,%dil
  80284b:	74 06                	je     802853 <memset+0x74>
  80284d:	88 07                	mov    %al,(%rdi)
  80284f:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  802853:	40 f6 c7 02          	test   $0x2,%dil
  802857:	74 07                	je     802860 <memset+0x81>
  802859:	66 89 07             	mov    %ax,(%rdi)
  80285c:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  802860:	40 f6 c7 04          	test   $0x4,%dil
  802864:	74 a9                	je     80280f <memset+0x30>
  802866:	89 07                	mov    %eax,(%rdi)
  802868:	48 83 c7 04          	add    $0x4,%rdi
  80286c:	eb a1                	jmp    80280f <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  80286e:	41 f6 c1 04          	test   $0x4,%r9b
  802872:	74 1b                	je     80288f <memset+0xb0>
  802874:	89 07                	mov    %eax,(%rdi)
  802876:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80287a:	41 f6 c1 02          	test   $0x2,%r9b
  80287e:	74 07                	je     802887 <memset+0xa8>
  802880:	66 89 07             	mov    %ax,(%rdi)
  802883:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  802887:	41 f6 c1 01          	test   $0x1,%r9b
  80288b:	74 9c                	je     802829 <memset+0x4a>
  80288d:	eb 06                	jmp    802895 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80288f:	41 f6 c1 02          	test   $0x2,%r9b
  802893:	75 eb                	jne    802880 <memset+0xa1>
        if (ni & 1) *ptr = k;
  802895:	88 07                	mov    %al,(%rdi)
  802897:	eb 90                	jmp    802829 <memset+0x4a>

0000000000802899 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  802899:	f3 0f 1e fa          	endbr64
  80289d:	48 89 f8             	mov    %rdi,%rax
  8028a0:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8028a3:	48 39 fe             	cmp    %rdi,%rsi
  8028a6:	73 3b                	jae    8028e3 <memmove+0x4a>
  8028a8:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8028ac:	48 39 d7             	cmp    %rdx,%rdi
  8028af:	73 32                	jae    8028e3 <memmove+0x4a>
        s += n;
        d += n;
  8028b1:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028b5:	48 89 d6             	mov    %rdx,%rsi
  8028b8:	48 09 fe             	or     %rdi,%rsi
  8028bb:	48 09 ce             	or     %rcx,%rsi
  8028be:	40 f6 c6 07          	test   $0x7,%sil
  8028c2:	75 12                	jne    8028d6 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8028c4:	48 83 ef 08          	sub    $0x8,%rdi
  8028c8:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8028cc:	48 c1 e9 03          	shr    $0x3,%rcx
  8028d0:	fd                   	std
  8028d1:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8028d4:	fc                   	cld
  8028d5:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8028d6:	48 83 ef 01          	sub    $0x1,%rdi
  8028da:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8028de:	fd                   	std
  8028df:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8028e1:	eb f1                	jmp    8028d4 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028e3:	48 89 f2             	mov    %rsi,%rdx
  8028e6:	48 09 c2             	or     %rax,%rdx
  8028e9:	48 09 ca             	or     %rcx,%rdx
  8028ec:	f6 c2 07             	test   $0x7,%dl
  8028ef:	75 0c                	jne    8028fd <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8028f1:	48 c1 e9 03          	shr    $0x3,%rcx
  8028f5:	48 89 c7             	mov    %rax,%rdi
  8028f8:	fc                   	cld
  8028f9:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8028fc:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8028fd:	48 89 c7             	mov    %rax,%rdi
  802900:	fc                   	cld
  802901:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  802903:	c3                   	ret

0000000000802904 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  802904:	f3 0f 1e fa          	endbr64
  802908:	55                   	push   %rbp
  802909:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80290c:	48 b8 99 28 80 00 00 	movabs $0x802899,%rax
  802913:	00 00 00 
  802916:	ff d0                	call   *%rax
}
  802918:	5d                   	pop    %rbp
  802919:	c3                   	ret

000000000080291a <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80291a:	f3 0f 1e fa          	endbr64
  80291e:	55                   	push   %rbp
  80291f:	48 89 e5             	mov    %rsp,%rbp
  802922:	41 57                	push   %r15
  802924:	41 56                	push   %r14
  802926:	41 55                	push   %r13
  802928:	41 54                	push   %r12
  80292a:	53                   	push   %rbx
  80292b:	48 83 ec 08          	sub    $0x8,%rsp
  80292f:	49 89 fe             	mov    %rdi,%r14
  802932:	49 89 f7             	mov    %rsi,%r15
  802935:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  802938:	48 89 f7             	mov    %rsi,%rdi
  80293b:	48 b8 39 26 80 00 00 	movabs $0x802639,%rax
  802942:	00 00 00 
  802945:	ff d0                	call   *%rax
  802947:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80294a:	48 89 de             	mov    %rbx,%rsi
  80294d:	4c 89 f7             	mov    %r14,%rdi
  802950:	48 b8 58 26 80 00 00 	movabs $0x802658,%rax
  802957:	00 00 00 
  80295a:	ff d0                	call   *%rax
  80295c:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80295f:	48 39 c3             	cmp    %rax,%rbx
  802962:	74 36                	je     80299a <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  802964:	48 89 d8             	mov    %rbx,%rax
  802967:	4c 29 e8             	sub    %r13,%rax
  80296a:	49 39 c4             	cmp    %rax,%r12
  80296d:	73 31                	jae    8029a0 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  80296f:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  802974:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  802978:	4c 89 fe             	mov    %r15,%rsi
  80297b:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  802982:	00 00 00 
  802985:	ff d0                	call   *%rax
    return dstlen + srclen;
  802987:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80298b:	48 83 c4 08          	add    $0x8,%rsp
  80298f:	5b                   	pop    %rbx
  802990:	41 5c                	pop    %r12
  802992:	41 5d                	pop    %r13
  802994:	41 5e                	pop    %r14
  802996:	41 5f                	pop    %r15
  802998:	5d                   	pop    %rbp
  802999:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  80299a:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  80299e:	eb eb                	jmp    80298b <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  8029a0:	48 83 eb 01          	sub    $0x1,%rbx
  8029a4:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8029a8:	48 89 da             	mov    %rbx,%rdx
  8029ab:	4c 89 fe             	mov    %r15,%rsi
  8029ae:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  8029b5:	00 00 00 
  8029b8:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8029ba:	49 01 de             	add    %rbx,%r14
  8029bd:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8029c2:	eb c3                	jmp    802987 <strlcat+0x6d>

00000000008029c4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8029c4:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8029c8:	48 85 d2             	test   %rdx,%rdx
  8029cb:	74 2d                	je     8029fa <memcmp+0x36>
  8029cd:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8029d2:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8029d6:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8029db:	44 38 c1             	cmp    %r8b,%cl
  8029de:	75 0f                	jne    8029ef <memcmp+0x2b>
    while (n-- > 0) {
  8029e0:	48 83 c0 01          	add    $0x1,%rax
  8029e4:	48 39 c2             	cmp    %rax,%rdx
  8029e7:	75 e9                	jne    8029d2 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8029e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ee:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8029ef:	0f b6 c1             	movzbl %cl,%eax
  8029f2:	45 0f b6 c0          	movzbl %r8b,%r8d
  8029f6:	44 29 c0             	sub    %r8d,%eax
  8029f9:	c3                   	ret
    return 0;
  8029fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ff:	c3                   	ret

0000000000802a00 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  802a00:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  802a04:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802a08:	48 39 c7             	cmp    %rax,%rdi
  802a0b:	73 0f                	jae    802a1c <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802a0d:	40 38 37             	cmp    %sil,(%rdi)
  802a10:	74 0e                	je     802a20 <memfind+0x20>
    for (; src < end; src++) {
  802a12:	48 83 c7 01          	add    $0x1,%rdi
  802a16:	48 39 f8             	cmp    %rdi,%rax
  802a19:	75 f2                	jne    802a0d <memfind+0xd>
  802a1b:	c3                   	ret
  802a1c:	48 89 f8             	mov    %rdi,%rax
  802a1f:	c3                   	ret
  802a20:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802a23:	c3                   	ret

0000000000802a24 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802a24:	f3 0f 1e fa          	endbr64
  802a28:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802a2b:	0f b6 37             	movzbl (%rdi),%esi
  802a2e:	40 80 fe 20          	cmp    $0x20,%sil
  802a32:	74 06                	je     802a3a <strtol+0x16>
  802a34:	40 80 fe 09          	cmp    $0x9,%sil
  802a38:	75 13                	jne    802a4d <strtol+0x29>
  802a3a:	48 83 c7 01          	add    $0x1,%rdi
  802a3e:	0f b6 37             	movzbl (%rdi),%esi
  802a41:	40 80 fe 20          	cmp    $0x20,%sil
  802a45:	74 f3                	je     802a3a <strtol+0x16>
  802a47:	40 80 fe 09          	cmp    $0x9,%sil
  802a4b:	74 ed                	je     802a3a <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802a4d:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802a50:	83 e0 fd             	and    $0xfffffffd,%eax
  802a53:	3c 01                	cmp    $0x1,%al
  802a55:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a59:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  802a5f:	75 0f                	jne    802a70 <strtol+0x4c>
  802a61:	80 3f 30             	cmpb   $0x30,(%rdi)
  802a64:	74 14                	je     802a7a <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802a66:	85 d2                	test   %edx,%edx
  802a68:	b8 0a 00 00 00       	mov    $0xa,%eax
  802a6d:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  802a70:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  802a75:	4c 63 ca             	movslq %edx,%r9
  802a78:	eb 36                	jmp    802ab0 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a7a:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  802a7e:	74 0f                	je     802a8f <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  802a80:	85 d2                	test   %edx,%edx
  802a82:	75 ec                	jne    802a70 <strtol+0x4c>
        s++;
  802a84:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  802a88:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  802a8d:	eb e1                	jmp    802a70 <strtol+0x4c>
        s += 2;
  802a8f:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  802a93:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  802a98:	eb d6                	jmp    802a70 <strtol+0x4c>
            dig -= '0';
  802a9a:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  802a9d:	44 0f b6 c1          	movzbl %cl,%r8d
  802aa1:	41 39 d0             	cmp    %edx,%r8d
  802aa4:	7d 21                	jge    802ac7 <strtol+0xa3>
        val = val * base + dig;
  802aa6:	49 0f af c1          	imul   %r9,%rax
  802aaa:	0f b6 c9             	movzbl %cl,%ecx
  802aad:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  802ab0:	48 83 c7 01          	add    $0x1,%rdi
  802ab4:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  802ab8:	80 f9 39             	cmp    $0x39,%cl
  802abb:	76 dd                	jbe    802a9a <strtol+0x76>
        else if (dig - 'a' < 27)
  802abd:	80 f9 7b             	cmp    $0x7b,%cl
  802ac0:	77 05                	ja     802ac7 <strtol+0xa3>
            dig -= 'a' - 10;
  802ac2:	83 e9 57             	sub    $0x57,%ecx
  802ac5:	eb d6                	jmp    802a9d <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  802ac7:	4d 85 d2             	test   %r10,%r10
  802aca:	74 03                	je     802acf <strtol+0xab>
  802acc:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802acf:	48 89 c2             	mov    %rax,%rdx
  802ad2:	48 f7 da             	neg    %rdx
  802ad5:	40 80 fe 2d          	cmp    $0x2d,%sil
  802ad9:	48 0f 44 c2          	cmove  %rdx,%rax
}
  802add:	c3                   	ret

0000000000802ade <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802ade:	f3 0f 1e fa          	endbr64
  802ae2:	55                   	push   %rbp
  802ae3:	48 89 e5             	mov    %rsp,%rbp
  802ae6:	41 54                	push   %r12
  802ae8:	53                   	push   %rbx
  802ae9:	48 89 fb             	mov    %rdi,%rbx
  802aec:	48 89 f7             	mov    %rsi,%rdi
  802aef:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802af2:	48 85 f6             	test   %rsi,%rsi
  802af5:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802afc:	00 00 00 
  802aff:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b03:	be 00 10 00 00       	mov    $0x1000,%esi
  802b08:	48 b8 d0 05 80 00 00 	movabs $0x8005d0,%rax
  802b0f:	00 00 00 
  802b12:	ff d0                	call   *%rax
    if (res < 0) {
  802b14:	85 c0                	test   %eax,%eax
  802b16:	78 45                	js     802b5d <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b18:	48 85 db             	test   %rbx,%rbx
  802b1b:	74 12                	je     802b2f <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b1d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b24:	00 00 00 
  802b27:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b2d:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b2f:	4d 85 e4             	test   %r12,%r12
  802b32:	74 14                	je     802b48 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b34:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b3b:	00 00 00 
  802b3e:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b44:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b48:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b4f:	00 00 00 
  802b52:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b58:	5b                   	pop    %rbx
  802b59:	41 5c                	pop    %r12
  802b5b:	5d                   	pop    %rbp
  802b5c:	c3                   	ret
        if (from_env_store != NULL) {
  802b5d:	48 85 db             	test   %rbx,%rbx
  802b60:	74 06                	je     802b68 <ipc_recv+0x8a>
            *from_env_store = 0;
  802b62:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b68:	4d 85 e4             	test   %r12,%r12
  802b6b:	74 eb                	je     802b58 <ipc_recv+0x7a>
            *perm_store = 0;
  802b6d:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b74:	00 
  802b75:	eb e1                	jmp    802b58 <ipc_recv+0x7a>

0000000000802b77 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b77:	f3 0f 1e fa          	endbr64
  802b7b:	55                   	push   %rbp
  802b7c:	48 89 e5             	mov    %rsp,%rbp
  802b7f:	41 57                	push   %r15
  802b81:	41 56                	push   %r14
  802b83:	41 55                	push   %r13
  802b85:	41 54                	push   %r12
  802b87:	53                   	push   %rbx
  802b88:	48 83 ec 18          	sub    $0x18,%rsp
  802b8c:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802b8f:	48 89 d3             	mov    %rdx,%rbx
  802b92:	49 89 cc             	mov    %rcx,%r12
  802b95:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b98:	48 85 d2             	test   %rdx,%rdx
  802b9b:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802ba2:	00 00 00 
  802ba5:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802ba9:	89 f0                	mov    %esi,%eax
  802bab:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802baf:	48 89 da             	mov    %rbx,%rdx
  802bb2:	48 89 c6             	mov    %rax,%rsi
  802bb5:	48 b8 a0 05 80 00 00 	movabs $0x8005a0,%rax
  802bbc:	00 00 00 
  802bbf:	ff d0                	call   *%rax
    while (res < 0) {
  802bc1:	85 c0                	test   %eax,%eax
  802bc3:	79 65                	jns    802c2a <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bc5:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bc8:	75 33                	jne    802bfd <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802bca:	49 bf 13 02 80 00 00 	movabs $0x800213,%r15
  802bd1:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bd4:	49 be a0 05 80 00 00 	movabs $0x8005a0,%r14
  802bdb:	00 00 00 
        sys_yield();
  802bde:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802be1:	45 89 e8             	mov    %r13d,%r8d
  802be4:	4c 89 e1             	mov    %r12,%rcx
  802be7:	48 89 da             	mov    %rbx,%rdx
  802bea:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802bee:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802bf1:	41 ff d6             	call   *%r14
    while (res < 0) {
  802bf4:	85 c0                	test   %eax,%eax
  802bf6:	79 32                	jns    802c2a <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bf8:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bfb:	74 e1                	je     802bde <ipc_send+0x67>
            panic("Error: %i\n", res);
  802bfd:	89 c1                	mov    %eax,%ecx
  802bff:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  802c06:	00 00 00 
  802c09:	be 42 00 00 00       	mov    $0x42,%esi
  802c0e:	48 bf 4b 32 80 00 00 	movabs $0x80324b,%rdi
  802c15:	00 00 00 
  802c18:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1d:	49 b8 d9 1b 80 00 00 	movabs $0x801bd9,%r8
  802c24:	00 00 00 
  802c27:	41 ff d0             	call   *%r8
    }
}
  802c2a:	48 83 c4 18          	add    $0x18,%rsp
  802c2e:	5b                   	pop    %rbx
  802c2f:	41 5c                	pop    %r12
  802c31:	41 5d                	pop    %r13
  802c33:	41 5e                	pop    %r14
  802c35:	41 5f                	pop    %r15
  802c37:	5d                   	pop    %rbp
  802c38:	c3                   	ret

0000000000802c39 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c39:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c3d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c42:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c49:	00 00 00 
  802c4c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c50:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c54:	48 c1 e2 04          	shl    $0x4,%rdx
  802c58:	48 01 ca             	add    %rcx,%rdx
  802c5b:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c61:	39 fa                	cmp    %edi,%edx
  802c63:	74 12                	je     802c77 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c65:	48 83 c0 01          	add    $0x1,%rax
  802c69:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c6f:	75 db                	jne    802c4c <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802c71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c76:	c3                   	ret
            return envs[i].env_id;
  802c77:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c7b:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c7f:	48 c1 e2 04          	shl    $0x4,%rdx
  802c83:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802c8a:	00 00 00 
  802c8d:	48 01 d0             	add    %rdx,%rax
  802c90:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c96:	c3                   	ret

0000000000802c97 <__text_end>:
  802c97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802c9e:	00 00 00 
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
