
obj/user/idle:     file format elf64-x86-64


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
  80001e:	e8 31 00 00 00       	call   800054 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:

#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	53                   	push   %rbx
  80002e:	48 83 ec 08          	sub    $0x8,%rsp
    binaryname = "idle";
  800032:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800039:	00 00 00 
  80003c:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800043:	00 00 00 
     * Instead of busy-waiting like this,
     * a better way would be to use the processor's HLT instruction
     * to cause the processor to stop executing until the next interrupt -
     * doing so allows the processor to conserve power more effectively. */
    while (1) {
        sys_yield();
  800046:	48 bb 37 02 80 00 00 	movabs $0x800237,%rbx
  80004d:	00 00 00 
  800050:	ff d3                	call   *%rbx
    while (1) {
  800052:	eb fc                	jmp    800050 <umain+0x2b>

0000000000800054 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800054:	f3 0f 1e fa          	endbr64
  800058:	55                   	push   %rbp
  800059:	48 89 e5             	mov    %rsp,%rbp
  80005c:	41 56                	push   %r14
  80005e:	41 55                	push   %r13
  800060:	41 54                	push   %r12
  800062:	53                   	push   %rbx
  800063:	41 89 fd             	mov    %edi,%r13d
  800066:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800069:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800070:	00 00 00 
  800073:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80007a:	00 00 00 
  80007d:	48 39 c2             	cmp    %rax,%rdx
  800080:	73 17                	jae    800099 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800082:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800085:	49 89 c4             	mov    %rax,%r12
  800088:	48 83 c3 08          	add    $0x8,%rbx
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	ff 53 f8             	call   *-0x8(%rbx)
  800094:	4c 39 e3             	cmp    %r12,%rbx
  800097:	72 ef                	jb     800088 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800099:	48 b8 02 02 80 00 00 	movabs $0x800202,%rax
  8000a0:	00 00 00 
  8000a3:	ff d0                	call   *%rax
  8000a5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000aa:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000ae:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000b2:	48 c1 e0 04          	shl    $0x4,%rax
  8000b6:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000bd:	00 00 00 
  8000c0:	48 01 d0             	add    %rdx,%rax
  8000c3:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000ca:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000cd:	45 85 ed             	test   %r13d,%r13d
  8000d0:	7e 0d                	jle    8000df <libmain+0x8b>
  8000d2:	49 8b 06             	mov    (%r14),%rax
  8000d5:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000dc:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000df:	4c 89 f6             	mov    %r14,%rsi
  8000e2:	44 89 ef             	mov    %r13d,%edi
  8000e5:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000ec:	00 00 00 
  8000ef:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000f1:	48 b8 06 01 80 00 00 	movabs $0x800106,%rax
  8000f8:	00 00 00 
  8000fb:	ff d0                	call   *%rax
#endif
}
  8000fd:	5b                   	pop    %rbx
  8000fe:	41 5c                	pop    %r12
  800100:	41 5d                	pop    %r13
  800102:	41 5e                	pop    %r14
  800104:	5d                   	pop    %rbp
  800105:	c3                   	ret

0000000000800106 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800106:	f3 0f 1e fa          	endbr64
  80010a:	55                   	push   %rbp
  80010b:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80010e:	48 b8 d8 08 80 00 00 	movabs $0x8008d8,%rax
  800115:	00 00 00 
  800118:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80011a:	bf 00 00 00 00       	mov    $0x0,%edi
  80011f:	48 b8 93 01 80 00 00 	movabs $0x800193,%rax
  800126:	00 00 00 
  800129:	ff d0                	call   *%rax
}
  80012b:	5d                   	pop    %rbp
  80012c:	c3                   	ret

000000000080012d <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80012d:	f3 0f 1e fa          	endbr64
  800131:	55                   	push   %rbp
  800132:	48 89 e5             	mov    %rsp,%rbp
  800135:	53                   	push   %rbx
  800136:	48 89 fa             	mov    %rdi,%rdx
  800139:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800141:	bb 00 00 00 00       	mov    $0x0,%ebx
  800146:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80014b:	be 00 00 00 00       	mov    $0x0,%esi
  800150:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800156:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800158:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80015c:	c9                   	leave
  80015d:	c3                   	ret

000000000080015e <sys_cgetc>:

int
sys_cgetc(void) {
  80015e:	f3 0f 1e fa          	endbr64
  800162:	55                   	push   %rbp
  800163:	48 89 e5             	mov    %rsp,%rbp
  800166:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800167:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80016c:	ba 00 00 00 00       	mov    $0x0,%edx
  800171:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800176:	bb 00 00 00 00       	mov    $0x0,%ebx
  80017b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800180:	be 00 00 00 00       	mov    $0x0,%esi
  800185:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80018b:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80018d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800191:	c9                   	leave
  800192:	c3                   	ret

0000000000800193 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800193:	f3 0f 1e fa          	endbr64
  800197:	55                   	push   %rbp
  800198:	48 89 e5             	mov    %rsp,%rbp
  80019b:	53                   	push   %rbx
  80019c:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8001a0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8001a3:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001a8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001b2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001b7:	be 00 00 00 00       	mov    $0x0,%esi
  8001bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001c2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001c4:	48 85 c0             	test   %rax,%rax
  8001c7:	7f 06                	jg     8001cf <sys_env_destroy+0x3c>
}
  8001c9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001cd:	c9                   	leave
  8001ce:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001cf:	49 89 c0             	mov    %rax,%r8
  8001d2:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001d7:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  8001de:	00 00 00 
  8001e1:	be 26 00 00 00       	mov    $0x26,%esi
  8001e6:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  8001ed:	00 00 00 
  8001f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f5:	49 b9 fd 1b 80 00 00 	movabs $0x801bfd,%r9
  8001fc:	00 00 00 
  8001ff:	41 ff d1             	call   *%r9

0000000000800202 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800202:	f3 0f 1e fa          	endbr64
  800206:	55                   	push   %rbp
  800207:	48 89 e5             	mov    %rsp,%rbp
  80020a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80020b:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800210:	ba 00 00 00 00       	mov    $0x0,%edx
  800215:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80021a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80021f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800224:	be 00 00 00 00       	mov    $0x0,%esi
  800229:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80022f:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800231:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800235:	c9                   	leave
  800236:	c3                   	ret

0000000000800237 <sys_yield>:

void
sys_yield(void) {
  800237:	f3 0f 1e fa          	endbr64
  80023b:	55                   	push   %rbp
  80023c:	48 89 e5             	mov    %rsp,%rbp
  80023f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800240:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800245:	ba 00 00 00 00       	mov    $0x0,%edx
  80024a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80024f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800254:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800259:	be 00 00 00 00       	mov    $0x0,%esi
  80025e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800264:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  800266:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80026a:	c9                   	leave
  80026b:	c3                   	ret

000000000080026c <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80026c:	f3 0f 1e fa          	endbr64
  800270:	55                   	push   %rbp
  800271:	48 89 e5             	mov    %rsp,%rbp
  800274:	53                   	push   %rbx
  800275:	48 89 fa             	mov    %rdi,%rdx
  800278:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80027b:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800280:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800287:	00 00 00 
  80028a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80028f:	be 00 00 00 00       	mov    $0x0,%esi
  800294:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80029a:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80029c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002a0:	c9                   	leave
  8002a1:	c3                   	ret

00000000008002a2 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8002a2:	f3 0f 1e fa          	endbr64
  8002a6:	55                   	push   %rbp
  8002a7:	48 89 e5             	mov    %rsp,%rbp
  8002aa:	53                   	push   %rbx
  8002ab:	49 89 f8             	mov    %rdi,%r8
  8002ae:	48 89 d3             	mov    %rdx,%rbx
  8002b1:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8002b4:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002b9:	4c 89 c2             	mov    %r8,%rdx
  8002bc:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002ca:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002cc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002d0:	c9                   	leave
  8002d1:	c3                   	ret

00000000008002d2 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002d2:	f3 0f 1e fa          	endbr64
  8002d6:	55                   	push   %rbp
  8002d7:	48 89 e5             	mov    %rsp,%rbp
  8002da:	53                   	push   %rbx
  8002db:	48 83 ec 08          	sub    $0x8,%rsp
  8002df:	89 f8                	mov    %edi,%eax
  8002e1:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002e4:	48 63 f9             	movslq %ecx,%rdi
  8002e7:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002ea:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002ef:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002f2:	be 00 00 00 00       	mov    $0x0,%esi
  8002f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002fd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002ff:	48 85 c0             	test   %rax,%rax
  800302:	7f 06                	jg     80030a <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  800304:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800308:	c9                   	leave
  800309:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80030a:	49 89 c0             	mov    %rax,%r8
  80030d:	b9 04 00 00 00       	mov    $0x4,%ecx
  800312:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  800319:	00 00 00 
  80031c:	be 26 00 00 00       	mov    $0x26,%esi
  800321:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  800328:	00 00 00 
  80032b:	b8 00 00 00 00       	mov    $0x0,%eax
  800330:	49 b9 fd 1b 80 00 00 	movabs $0x801bfd,%r9
  800337:	00 00 00 
  80033a:	41 ff d1             	call   *%r9

000000000080033d <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80033d:	f3 0f 1e fa          	endbr64
  800341:	55                   	push   %rbp
  800342:	48 89 e5             	mov    %rsp,%rbp
  800345:	53                   	push   %rbx
  800346:	48 83 ec 08          	sub    $0x8,%rsp
  80034a:	89 f8                	mov    %edi,%eax
  80034c:	49 89 f2             	mov    %rsi,%r10
  80034f:	48 89 cf             	mov    %rcx,%rdi
  800352:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  800355:	48 63 da             	movslq %edx,%rbx
  800358:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80035b:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800360:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800363:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  800366:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800368:	48 85 c0             	test   %rax,%rax
  80036b:	7f 06                	jg     800373 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80036d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800371:	c9                   	leave
  800372:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800373:	49 89 c0             	mov    %rax,%r8
  800376:	b9 05 00 00 00       	mov    $0x5,%ecx
  80037b:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  800382:	00 00 00 
  800385:	be 26 00 00 00       	mov    $0x26,%esi
  80038a:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  800391:	00 00 00 
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	49 b9 fd 1b 80 00 00 	movabs $0x801bfd,%r9
  8003a0:	00 00 00 
  8003a3:	41 ff d1             	call   *%r9

00000000008003a6 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8003a6:	f3 0f 1e fa          	endbr64
  8003aa:	55                   	push   %rbp
  8003ab:	48 89 e5             	mov    %rsp,%rbp
  8003ae:	53                   	push   %rbx
  8003af:	48 83 ec 08          	sub    $0x8,%rsp
  8003b3:	49 89 f9             	mov    %rdi,%r9
  8003b6:	89 f0                	mov    %esi,%eax
  8003b8:	48 89 d3             	mov    %rdx,%rbx
  8003bb:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8003be:	49 63 f0             	movslq %r8d,%rsi
  8003c1:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8003c4:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8003c9:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003d2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003d4:	48 85 c0             	test   %rax,%rax
  8003d7:	7f 06                	jg     8003df <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8003d9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003dd:	c9                   	leave
  8003de:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003df:	49 89 c0             	mov    %rax,%r8
  8003e2:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003e7:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  8003ee:	00 00 00 
  8003f1:	be 26 00 00 00       	mov    $0x26,%esi
  8003f6:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  8003fd:	00 00 00 
  800400:	b8 00 00 00 00       	mov    $0x0,%eax
  800405:	49 b9 fd 1b 80 00 00 	movabs $0x801bfd,%r9
  80040c:	00 00 00 
  80040f:	41 ff d1             	call   *%r9

0000000000800412 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  800412:	f3 0f 1e fa          	endbr64
  800416:	55                   	push   %rbp
  800417:	48 89 e5             	mov    %rsp,%rbp
  80041a:	53                   	push   %rbx
  80041b:	48 83 ec 08          	sub    $0x8,%rsp
  80041f:	48 89 f1             	mov    %rsi,%rcx
  800422:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  800425:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800428:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80042d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800432:	be 00 00 00 00       	mov    $0x0,%esi
  800437:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80043d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80043f:	48 85 c0             	test   %rax,%rax
  800442:	7f 06                	jg     80044a <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  800444:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800448:	c9                   	leave
  800449:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80044a:	49 89 c0             	mov    %rax,%r8
  80044d:	b9 07 00 00 00       	mov    $0x7,%ecx
  800452:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  800459:	00 00 00 
  80045c:	be 26 00 00 00       	mov    $0x26,%esi
  800461:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  800468:	00 00 00 
  80046b:	b8 00 00 00 00       	mov    $0x0,%eax
  800470:	49 b9 fd 1b 80 00 00 	movabs $0x801bfd,%r9
  800477:	00 00 00 
  80047a:	41 ff d1             	call   *%r9

000000000080047d <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80047d:	f3 0f 1e fa          	endbr64
  800481:	55                   	push   %rbp
  800482:	48 89 e5             	mov    %rsp,%rbp
  800485:	53                   	push   %rbx
  800486:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80048a:	48 63 ce             	movslq %esi,%rcx
  80048d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800490:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800495:	bb 00 00 00 00       	mov    $0x0,%ebx
  80049a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80049f:	be 00 00 00 00       	mov    $0x0,%esi
  8004a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004aa:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004ac:	48 85 c0             	test   %rax,%rax
  8004af:	7f 06                	jg     8004b7 <sys_env_set_status+0x3a>
}
  8004b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004b5:	c9                   	leave
  8004b6:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004b7:	49 89 c0             	mov    %rax,%r8
  8004ba:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8004bf:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  8004c6:	00 00 00 
  8004c9:	be 26 00 00 00       	mov    $0x26,%esi
  8004ce:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  8004d5:	00 00 00 
  8004d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dd:	49 b9 fd 1b 80 00 00 	movabs $0x801bfd,%r9
  8004e4:	00 00 00 
  8004e7:	41 ff d1             	call   *%r9

00000000008004ea <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8004ea:	f3 0f 1e fa          	endbr64
  8004ee:	55                   	push   %rbp
  8004ef:	48 89 e5             	mov    %rsp,%rbp
  8004f2:	53                   	push   %rbx
  8004f3:	48 83 ec 08          	sub    $0x8,%rsp
  8004f7:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8004fa:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004fd:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800502:	bb 00 00 00 00       	mov    $0x0,%ebx
  800507:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80050c:	be 00 00 00 00       	mov    $0x0,%esi
  800511:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800517:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800519:	48 85 c0             	test   %rax,%rax
  80051c:	7f 06                	jg     800524 <sys_env_set_trapframe+0x3a>
}
  80051e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800522:	c9                   	leave
  800523:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800524:	49 89 c0             	mov    %rax,%r8
  800527:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80052c:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  800533:	00 00 00 
  800536:	be 26 00 00 00       	mov    $0x26,%esi
  80053b:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  800542:	00 00 00 
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	49 b9 fd 1b 80 00 00 	movabs $0x801bfd,%r9
  800551:	00 00 00 
  800554:	41 ff d1             	call   *%r9

0000000000800557 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  800557:	f3 0f 1e fa          	endbr64
  80055b:	55                   	push   %rbp
  80055c:	48 89 e5             	mov    %rsp,%rbp
  80055f:	53                   	push   %rbx
  800560:	48 83 ec 08          	sub    $0x8,%rsp
  800564:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  800567:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80056a:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80056f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800574:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800579:	be 00 00 00 00       	mov    $0x0,%esi
  80057e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800584:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800586:	48 85 c0             	test   %rax,%rax
  800589:	7f 06                	jg     800591 <sys_env_set_pgfault_upcall+0x3a>
}
  80058b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80058f:	c9                   	leave
  800590:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800591:	49 89 c0             	mov    %rax,%r8
  800594:	b9 0c 00 00 00       	mov    $0xc,%ecx
  800599:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  8005a0:	00 00 00 
  8005a3:	be 26 00 00 00       	mov    $0x26,%esi
  8005a8:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  8005af:	00 00 00 
  8005b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b7:	49 b9 fd 1b 80 00 00 	movabs $0x801bfd,%r9
  8005be:	00 00 00 
  8005c1:	41 ff d1             	call   *%r9

00000000008005c4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8005c4:	f3 0f 1e fa          	endbr64
  8005c8:	55                   	push   %rbp
  8005c9:	48 89 e5             	mov    %rsp,%rbp
  8005cc:	53                   	push   %rbx
  8005cd:	89 f8                	mov    %edi,%eax
  8005cf:	49 89 f1             	mov    %rsi,%r9
  8005d2:	48 89 d3             	mov    %rdx,%rbx
  8005d5:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8005d8:	49 63 f0             	movslq %r8d,%rsi
  8005db:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8005de:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005e3:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005ec:	cd 30                	int    $0x30
}
  8005ee:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005f2:	c9                   	leave
  8005f3:	c3                   	ret

00000000008005f4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8005f4:	f3 0f 1e fa          	endbr64
  8005f8:	55                   	push   %rbp
  8005f9:	48 89 e5             	mov    %rsp,%rbp
  8005fc:	53                   	push   %rbx
  8005fd:	48 83 ec 08          	sub    $0x8,%rsp
  800601:	48 89 fa             	mov    %rdi,%rdx
  800604:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800607:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80060c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800611:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800616:	be 00 00 00 00       	mov    $0x0,%esi
  80061b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800621:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800623:	48 85 c0             	test   %rax,%rax
  800626:	7f 06                	jg     80062e <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800628:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80062c:	c9                   	leave
  80062d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80062e:	49 89 c0             	mov    %rax,%r8
  800631:	b9 0f 00 00 00       	mov    $0xf,%ecx
  800636:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  80063d:	00 00 00 
  800640:	be 26 00 00 00       	mov    $0x26,%esi
  800645:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  80064c:	00 00 00 
  80064f:	b8 00 00 00 00       	mov    $0x0,%eax
  800654:	49 b9 fd 1b 80 00 00 	movabs $0x801bfd,%r9
  80065b:	00 00 00 
  80065e:	41 ff d1             	call   *%r9

0000000000800661 <sys_gettime>:

int
sys_gettime(void) {
  800661:	f3 0f 1e fa          	endbr64
  800665:	55                   	push   %rbp
  800666:	48 89 e5             	mov    %rsp,%rbp
  800669:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80066a:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80066f:	ba 00 00 00 00       	mov    $0x0,%edx
  800674:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800679:	bb 00 00 00 00       	mov    $0x0,%ebx
  80067e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800683:	be 00 00 00 00       	mov    $0x0,%esi
  800688:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80068e:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  800690:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800694:	c9                   	leave
  800695:	c3                   	ret

0000000000800696 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  800696:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80069a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8006a1:	ff ff ff 
  8006a4:	48 01 f8             	add    %rdi,%rax
  8006a7:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8006ab:	c3                   	ret

00000000008006ac <fd2data>:

char *
fd2data(struct Fd *fd) {
  8006ac:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8006b0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8006b7:	ff ff ff 
  8006ba:	48 01 f8             	add    %rdi,%rax
  8006bd:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8006c1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8006c7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006cb:	c3                   	ret

00000000008006cc <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8006cc:	f3 0f 1e fa          	endbr64
  8006d0:	55                   	push   %rbp
  8006d1:	48 89 e5             	mov    %rsp,%rbp
  8006d4:	41 57                	push   %r15
  8006d6:	41 56                	push   %r14
  8006d8:	41 55                	push   %r13
  8006da:	41 54                	push   %r12
  8006dc:	53                   	push   %rbx
  8006dd:	48 83 ec 08          	sub    $0x8,%rsp
  8006e1:	49 89 ff             	mov    %rdi,%r15
  8006e4:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8006e9:	49 bd 2b 18 80 00 00 	movabs $0x80182b,%r13
  8006f0:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8006f3:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8006f9:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8006fc:	48 89 df             	mov    %rbx,%rdi
  8006ff:	41 ff d5             	call   *%r13
  800702:	83 e0 04             	and    $0x4,%eax
  800705:	74 17                	je     80071e <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  800707:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80070e:	4c 39 f3             	cmp    %r14,%rbx
  800711:	75 e6                	jne    8006f9 <fd_alloc+0x2d>
  800713:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  800719:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  80071e:	4d 89 27             	mov    %r12,(%r15)
}
  800721:	48 83 c4 08          	add    $0x8,%rsp
  800725:	5b                   	pop    %rbx
  800726:	41 5c                	pop    %r12
  800728:	41 5d                	pop    %r13
  80072a:	41 5e                	pop    %r14
  80072c:	41 5f                	pop    %r15
  80072e:	5d                   	pop    %rbp
  80072f:	c3                   	ret

0000000000800730 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  800730:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  800734:	83 ff 1f             	cmp    $0x1f,%edi
  800737:	77 39                	ja     800772 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  800739:	55                   	push   %rbp
  80073a:	48 89 e5             	mov    %rsp,%rbp
  80073d:	41 54                	push   %r12
  80073f:	53                   	push   %rbx
  800740:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  800743:	48 63 df             	movslq %edi,%rbx
  800746:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80074d:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800751:	48 89 df             	mov    %rbx,%rdi
  800754:	48 b8 2b 18 80 00 00 	movabs $0x80182b,%rax
  80075b:	00 00 00 
  80075e:	ff d0                	call   *%rax
  800760:	a8 04                	test   $0x4,%al
  800762:	74 14                	je     800778 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  800764:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  800768:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80076d:	5b                   	pop    %rbx
  80076e:	41 5c                	pop    %r12
  800770:	5d                   	pop    %rbp
  800771:	c3                   	ret
        return -E_INVAL;
  800772:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800777:	c3                   	ret
        return -E_INVAL;
  800778:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80077d:	eb ee                	jmp    80076d <fd_lookup+0x3d>

000000000080077f <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  80077f:	f3 0f 1e fa          	endbr64
  800783:	55                   	push   %rbp
  800784:	48 89 e5             	mov    %rsp,%rbp
  800787:	41 54                	push   %r12
  800789:	53                   	push   %rbx
  80078a:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  80078d:	48 b8 40 33 80 00 00 	movabs $0x803340,%rax
  800794:	00 00 00 
  800797:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  80079e:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8007a1:	39 3b                	cmp    %edi,(%rbx)
  8007a3:	74 47                	je     8007ec <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  8007a5:	48 83 c0 08          	add    $0x8,%rax
  8007a9:	48 8b 18             	mov    (%rax),%rbx
  8007ac:	48 85 db             	test   %rbx,%rbx
  8007af:	75 f0                	jne    8007a1 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8007b1:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8007b8:	00 00 00 
  8007bb:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8007c1:	89 fa                	mov    %edi,%edx
  8007c3:	48 bf 80 32 80 00 00 	movabs $0x803280,%rdi
  8007ca:	00 00 00 
  8007cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d2:	48 b9 59 1d 80 00 00 	movabs $0x801d59,%rcx
  8007d9:	00 00 00 
  8007dc:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8007de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8007e3:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8007e7:	5b                   	pop    %rbx
  8007e8:	41 5c                	pop    %r12
  8007ea:	5d                   	pop    %rbp
  8007eb:	c3                   	ret
            return 0;
  8007ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f1:	eb f0                	jmp    8007e3 <dev_lookup+0x64>

00000000008007f3 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8007f3:	f3 0f 1e fa          	endbr64
  8007f7:	55                   	push   %rbp
  8007f8:	48 89 e5             	mov    %rsp,%rbp
  8007fb:	41 55                	push   %r13
  8007fd:	41 54                	push   %r12
  8007ff:	53                   	push   %rbx
  800800:	48 83 ec 18          	sub    $0x18,%rsp
  800804:	48 89 fb             	mov    %rdi,%rbx
  800807:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80080a:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  800811:	ff ff ff 
  800814:	48 01 df             	add    %rbx,%rdi
  800817:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80081b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80081f:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  800826:	00 00 00 
  800829:	ff d0                	call   *%rax
  80082b:	41 89 c5             	mov    %eax,%r13d
  80082e:	85 c0                	test   %eax,%eax
  800830:	78 06                	js     800838 <fd_close+0x45>
  800832:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  800836:	74 1a                	je     800852 <fd_close+0x5f>
        return (must_exist ? res : 0);
  800838:	45 84 e4             	test   %r12b,%r12b
  80083b:	b8 00 00 00 00       	mov    $0x0,%eax
  800840:	44 0f 44 e8          	cmove  %eax,%r13d
}
  800844:	44 89 e8             	mov    %r13d,%eax
  800847:	48 83 c4 18          	add    $0x18,%rsp
  80084b:	5b                   	pop    %rbx
  80084c:	41 5c                	pop    %r12
  80084e:	41 5d                	pop    %r13
  800850:	5d                   	pop    %rbp
  800851:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800852:	8b 3b                	mov    (%rbx),%edi
  800854:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800858:	48 b8 7f 07 80 00 00 	movabs $0x80077f,%rax
  80085f:	00 00 00 
  800862:	ff d0                	call   *%rax
  800864:	41 89 c5             	mov    %eax,%r13d
  800867:	85 c0                	test   %eax,%eax
  800869:	78 1b                	js     800886 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80086b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80086f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800873:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  800879:	48 85 c0             	test   %rax,%rax
  80087c:	74 08                	je     800886 <fd_close+0x93>
  80087e:	48 89 df             	mov    %rbx,%rdi
  800881:	ff d0                	call   *%rax
  800883:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  800886:	ba 00 10 00 00       	mov    $0x1000,%edx
  80088b:	48 89 de             	mov    %rbx,%rsi
  80088e:	bf 00 00 00 00       	mov    $0x0,%edi
  800893:	48 b8 12 04 80 00 00 	movabs $0x800412,%rax
  80089a:	00 00 00 
  80089d:	ff d0                	call   *%rax
    return res;
  80089f:	eb a3                	jmp    800844 <fd_close+0x51>

00000000008008a1 <close>:

int
close(int fdnum) {
  8008a1:	f3 0f 1e fa          	endbr64
  8008a5:	55                   	push   %rbp
  8008a6:	48 89 e5             	mov    %rsp,%rbp
  8008a9:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8008ad:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8008b1:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  8008b8:	00 00 00 
  8008bb:	ff d0                	call   *%rax
    if (res < 0) return res;
  8008bd:	85 c0                	test   %eax,%eax
  8008bf:	78 15                	js     8008d6 <close+0x35>

    return fd_close(fd, 1);
  8008c1:	be 01 00 00 00       	mov    $0x1,%esi
  8008c6:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8008ca:	48 b8 f3 07 80 00 00 	movabs $0x8007f3,%rax
  8008d1:	00 00 00 
  8008d4:	ff d0                	call   *%rax
}
  8008d6:	c9                   	leave
  8008d7:	c3                   	ret

00000000008008d8 <close_all>:

void
close_all(void) {
  8008d8:	f3 0f 1e fa          	endbr64
  8008dc:	55                   	push   %rbp
  8008dd:	48 89 e5             	mov    %rsp,%rbp
  8008e0:	41 54                	push   %r12
  8008e2:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8008e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008e8:	49 bc a1 08 80 00 00 	movabs $0x8008a1,%r12
  8008ef:	00 00 00 
  8008f2:	89 df                	mov    %ebx,%edi
  8008f4:	41 ff d4             	call   *%r12
  8008f7:	83 c3 01             	add    $0x1,%ebx
  8008fa:	83 fb 20             	cmp    $0x20,%ebx
  8008fd:	75 f3                	jne    8008f2 <close_all+0x1a>
}
  8008ff:	5b                   	pop    %rbx
  800900:	41 5c                	pop    %r12
  800902:	5d                   	pop    %rbp
  800903:	c3                   	ret

0000000000800904 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  800904:	f3 0f 1e fa          	endbr64
  800908:	55                   	push   %rbp
  800909:	48 89 e5             	mov    %rsp,%rbp
  80090c:	41 57                	push   %r15
  80090e:	41 56                	push   %r14
  800910:	41 55                	push   %r13
  800912:	41 54                	push   %r12
  800914:	53                   	push   %rbx
  800915:	48 83 ec 18          	sub    $0x18,%rsp
  800919:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80091c:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  800920:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  800927:	00 00 00 
  80092a:	ff d0                	call   *%rax
  80092c:	89 c3                	mov    %eax,%ebx
  80092e:	85 c0                	test   %eax,%eax
  800930:	0f 88 b8 00 00 00    	js     8009ee <dup+0xea>
    close(newfdnum);
  800936:	44 89 e7             	mov    %r12d,%edi
  800939:	48 b8 a1 08 80 00 00 	movabs $0x8008a1,%rax
  800940:	00 00 00 
  800943:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  800945:	4d 63 ec             	movslq %r12d,%r13
  800948:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  80094f:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  800953:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  800957:	4c 89 ff             	mov    %r15,%rdi
  80095a:	49 be ac 06 80 00 00 	movabs $0x8006ac,%r14
  800961:	00 00 00 
  800964:	41 ff d6             	call   *%r14
  800967:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  80096a:	4c 89 ef             	mov    %r13,%rdi
  80096d:	41 ff d6             	call   *%r14
  800970:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  800973:	48 89 df             	mov    %rbx,%rdi
  800976:	48 b8 2b 18 80 00 00 	movabs $0x80182b,%rax
  80097d:	00 00 00 
  800980:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  800982:	a8 04                	test   $0x4,%al
  800984:	74 2b                	je     8009b1 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  800986:	41 89 c1             	mov    %eax,%r9d
  800989:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80098f:	4c 89 f1             	mov    %r14,%rcx
  800992:	ba 00 00 00 00       	mov    $0x0,%edx
  800997:	48 89 de             	mov    %rbx,%rsi
  80099a:	bf 00 00 00 00       	mov    $0x0,%edi
  80099f:	48 b8 3d 03 80 00 00 	movabs $0x80033d,%rax
  8009a6:	00 00 00 
  8009a9:	ff d0                	call   *%rax
  8009ab:	89 c3                	mov    %eax,%ebx
  8009ad:	85 c0                	test   %eax,%eax
  8009af:	78 4e                	js     8009ff <dup+0xfb>
    }
    prot = get_prot(oldfd);
  8009b1:	4c 89 ff             	mov    %r15,%rdi
  8009b4:	48 b8 2b 18 80 00 00 	movabs $0x80182b,%rax
  8009bb:	00 00 00 
  8009be:	ff d0                	call   *%rax
  8009c0:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8009c3:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8009c9:	4c 89 e9             	mov    %r13,%rcx
  8009cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d1:	4c 89 fe             	mov    %r15,%rsi
  8009d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8009d9:	48 b8 3d 03 80 00 00 	movabs $0x80033d,%rax
  8009e0:	00 00 00 
  8009e3:	ff d0                	call   *%rax
  8009e5:	89 c3                	mov    %eax,%ebx
  8009e7:	85 c0                	test   %eax,%eax
  8009e9:	78 14                	js     8009ff <dup+0xfb>

    return newfdnum;
  8009eb:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8009ee:	89 d8                	mov    %ebx,%eax
  8009f0:	48 83 c4 18          	add    $0x18,%rsp
  8009f4:	5b                   	pop    %rbx
  8009f5:	41 5c                	pop    %r12
  8009f7:	41 5d                	pop    %r13
  8009f9:	41 5e                	pop    %r14
  8009fb:	41 5f                	pop    %r15
  8009fd:	5d                   	pop    %rbp
  8009fe:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8009ff:	ba 00 10 00 00       	mov    $0x1000,%edx
  800a04:	4c 89 ee             	mov    %r13,%rsi
  800a07:	bf 00 00 00 00       	mov    $0x0,%edi
  800a0c:	49 bc 12 04 80 00 00 	movabs $0x800412,%r12
  800a13:	00 00 00 
  800a16:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  800a19:	ba 00 10 00 00       	mov    $0x1000,%edx
  800a1e:	4c 89 f6             	mov    %r14,%rsi
  800a21:	bf 00 00 00 00       	mov    $0x0,%edi
  800a26:	41 ff d4             	call   *%r12
    return res;
  800a29:	eb c3                	jmp    8009ee <dup+0xea>

0000000000800a2b <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800a2b:	f3 0f 1e fa          	endbr64
  800a2f:	55                   	push   %rbp
  800a30:	48 89 e5             	mov    %rsp,%rbp
  800a33:	41 56                	push   %r14
  800a35:	41 55                	push   %r13
  800a37:	41 54                	push   %r12
  800a39:	53                   	push   %rbx
  800a3a:	48 83 ec 10          	sub    $0x10,%rsp
  800a3e:	89 fb                	mov    %edi,%ebx
  800a40:	49 89 f4             	mov    %rsi,%r12
  800a43:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a46:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800a4a:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  800a51:	00 00 00 
  800a54:	ff d0                	call   *%rax
  800a56:	85 c0                	test   %eax,%eax
  800a58:	78 4c                	js     800aa6 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a5a:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800a5e:	41 8b 3e             	mov    (%r14),%edi
  800a61:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800a65:	48 b8 7f 07 80 00 00 	movabs $0x80077f,%rax
  800a6c:	00 00 00 
  800a6f:	ff d0                	call   *%rax
  800a71:	85 c0                	test   %eax,%eax
  800a73:	78 35                	js     800aaa <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a75:	41 8b 46 08          	mov    0x8(%r14),%eax
  800a79:	83 e0 03             	and    $0x3,%eax
  800a7c:	83 f8 01             	cmp    $0x1,%eax
  800a7f:	74 2d                	je     800aae <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800a81:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a85:	48 8b 40 10          	mov    0x10(%rax),%rax
  800a89:	48 85 c0             	test   %rax,%rax
  800a8c:	74 56                	je     800ae4 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  800a8e:	4c 89 ea             	mov    %r13,%rdx
  800a91:	4c 89 e6             	mov    %r12,%rsi
  800a94:	4c 89 f7             	mov    %r14,%rdi
  800a97:	ff d0                	call   *%rax
}
  800a99:	48 83 c4 10          	add    $0x10,%rsp
  800a9d:	5b                   	pop    %rbx
  800a9e:	41 5c                	pop    %r12
  800aa0:	41 5d                	pop    %r13
  800aa2:	41 5e                	pop    %r14
  800aa4:	5d                   	pop    %rbp
  800aa5:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800aa6:	48 98                	cltq
  800aa8:	eb ef                	jmp    800a99 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800aaa:	48 98                	cltq
  800aac:	eb eb                	jmp    800a99 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800aae:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800ab5:	00 00 00 
  800ab8:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800abe:	89 da                	mov    %ebx,%edx
  800ac0:	48 bf 1d 30 80 00 00 	movabs $0x80301d,%rdi
  800ac7:	00 00 00 
  800aca:	b8 00 00 00 00       	mov    $0x0,%eax
  800acf:	48 b9 59 1d 80 00 00 	movabs $0x801d59,%rcx
  800ad6:	00 00 00 
  800ad9:	ff d1                	call   *%rcx
        return -E_INVAL;
  800adb:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800ae2:	eb b5                	jmp    800a99 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800ae4:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800aeb:	eb ac                	jmp    800a99 <read+0x6e>

0000000000800aed <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800aed:	f3 0f 1e fa          	endbr64
  800af1:	55                   	push   %rbp
  800af2:	48 89 e5             	mov    %rsp,%rbp
  800af5:	41 57                	push   %r15
  800af7:	41 56                	push   %r14
  800af9:	41 55                	push   %r13
  800afb:	41 54                	push   %r12
  800afd:	53                   	push   %rbx
  800afe:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800b02:	48 85 d2             	test   %rdx,%rdx
  800b05:	74 54                	je     800b5b <readn+0x6e>
  800b07:	41 89 fd             	mov    %edi,%r13d
  800b0a:	49 89 f6             	mov    %rsi,%r14
  800b0d:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800b10:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800b15:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800b1a:	49 bf 2b 0a 80 00 00 	movabs $0x800a2b,%r15
  800b21:	00 00 00 
  800b24:	4c 89 e2             	mov    %r12,%rdx
  800b27:	48 29 f2             	sub    %rsi,%rdx
  800b2a:	4c 01 f6             	add    %r14,%rsi
  800b2d:	44 89 ef             	mov    %r13d,%edi
  800b30:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800b33:	85 c0                	test   %eax,%eax
  800b35:	78 20                	js     800b57 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  800b37:	01 c3                	add    %eax,%ebx
  800b39:	85 c0                	test   %eax,%eax
  800b3b:	74 08                	je     800b45 <readn+0x58>
  800b3d:	48 63 f3             	movslq %ebx,%rsi
  800b40:	4c 39 e6             	cmp    %r12,%rsi
  800b43:	72 df                	jb     800b24 <readn+0x37>
    }
    return res;
  800b45:	48 63 c3             	movslq %ebx,%rax
}
  800b48:	48 83 c4 08          	add    $0x8,%rsp
  800b4c:	5b                   	pop    %rbx
  800b4d:	41 5c                	pop    %r12
  800b4f:	41 5d                	pop    %r13
  800b51:	41 5e                	pop    %r14
  800b53:	41 5f                	pop    %r15
  800b55:	5d                   	pop    %rbp
  800b56:	c3                   	ret
        if (inc < 0) return inc;
  800b57:	48 98                	cltq
  800b59:	eb ed                	jmp    800b48 <readn+0x5b>
    int inc = 1, res = 0;
  800b5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b60:	eb e3                	jmp    800b45 <readn+0x58>

0000000000800b62 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800b62:	f3 0f 1e fa          	endbr64
  800b66:	55                   	push   %rbp
  800b67:	48 89 e5             	mov    %rsp,%rbp
  800b6a:	41 56                	push   %r14
  800b6c:	41 55                	push   %r13
  800b6e:	41 54                	push   %r12
  800b70:	53                   	push   %rbx
  800b71:	48 83 ec 10          	sub    $0x10,%rsp
  800b75:	89 fb                	mov    %edi,%ebx
  800b77:	49 89 f4             	mov    %rsi,%r12
  800b7a:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b7d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800b81:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  800b88:	00 00 00 
  800b8b:	ff d0                	call   *%rax
  800b8d:	85 c0                	test   %eax,%eax
  800b8f:	78 47                	js     800bd8 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b91:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800b95:	41 8b 3e             	mov    (%r14),%edi
  800b98:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800b9c:	48 b8 7f 07 80 00 00 	movabs $0x80077f,%rax
  800ba3:	00 00 00 
  800ba6:	ff d0                	call   *%rax
  800ba8:	85 c0                	test   %eax,%eax
  800baa:	78 30                	js     800bdc <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bac:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  800bb1:	74 2d                	je     800be0 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800bb3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800bb7:	48 8b 40 18          	mov    0x18(%rax),%rax
  800bbb:	48 85 c0             	test   %rax,%rax
  800bbe:	74 56                	je     800c16 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  800bc0:	4c 89 ea             	mov    %r13,%rdx
  800bc3:	4c 89 e6             	mov    %r12,%rsi
  800bc6:	4c 89 f7             	mov    %r14,%rdi
  800bc9:	ff d0                	call   *%rax
}
  800bcb:	48 83 c4 10          	add    $0x10,%rsp
  800bcf:	5b                   	pop    %rbx
  800bd0:	41 5c                	pop    %r12
  800bd2:	41 5d                	pop    %r13
  800bd4:	41 5e                	pop    %r14
  800bd6:	5d                   	pop    %rbp
  800bd7:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800bd8:	48 98                	cltq
  800bda:	eb ef                	jmp    800bcb <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bdc:	48 98                	cltq
  800bde:	eb eb                	jmp    800bcb <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800be0:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800be7:	00 00 00 
  800bea:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800bf0:	89 da                	mov    %ebx,%edx
  800bf2:	48 bf 39 30 80 00 00 	movabs $0x803039,%rdi
  800bf9:	00 00 00 
  800bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800c01:	48 b9 59 1d 80 00 00 	movabs $0x801d59,%rcx
  800c08:	00 00 00 
  800c0b:	ff d1                	call   *%rcx
        return -E_INVAL;
  800c0d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800c14:	eb b5                	jmp    800bcb <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800c16:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800c1d:	eb ac                	jmp    800bcb <write+0x69>

0000000000800c1f <seek>:

int
seek(int fdnum, off_t offset) {
  800c1f:	f3 0f 1e fa          	endbr64
  800c23:	55                   	push   %rbp
  800c24:	48 89 e5             	mov    %rsp,%rbp
  800c27:	53                   	push   %rbx
  800c28:	48 83 ec 18          	sub    $0x18,%rsp
  800c2c:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c2e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c32:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  800c39:	00 00 00 
  800c3c:	ff d0                	call   *%rax
  800c3e:	85 c0                	test   %eax,%eax
  800c40:	78 0c                	js     800c4e <seek+0x2f>

    fd->fd_offset = offset;
  800c42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c46:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800c49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c4e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c52:	c9                   	leave
  800c53:	c3                   	ret

0000000000800c54 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800c54:	f3 0f 1e fa          	endbr64
  800c58:	55                   	push   %rbp
  800c59:	48 89 e5             	mov    %rsp,%rbp
  800c5c:	41 55                	push   %r13
  800c5e:	41 54                	push   %r12
  800c60:	53                   	push   %rbx
  800c61:	48 83 ec 18          	sub    $0x18,%rsp
  800c65:	89 fb                	mov    %edi,%ebx
  800c67:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c6a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800c6e:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  800c75:	00 00 00 
  800c78:	ff d0                	call   *%rax
  800c7a:	85 c0                	test   %eax,%eax
  800c7c:	78 38                	js     800cb6 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c7e:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  800c82:	41 8b 7d 00          	mov    0x0(%r13),%edi
  800c86:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800c8a:	48 b8 7f 07 80 00 00 	movabs $0x80077f,%rax
  800c91:	00 00 00 
  800c94:	ff d0                	call   *%rax
  800c96:	85 c0                	test   %eax,%eax
  800c98:	78 1c                	js     800cb6 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c9a:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  800c9f:	74 20                	je     800cc1 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800ca1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ca5:	48 8b 40 30          	mov    0x30(%rax),%rax
  800ca9:	48 85 c0             	test   %rax,%rax
  800cac:	74 47                	je     800cf5 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  800cae:	44 89 e6             	mov    %r12d,%esi
  800cb1:	4c 89 ef             	mov    %r13,%rdi
  800cb4:	ff d0                	call   *%rax
}
  800cb6:	48 83 c4 18          	add    $0x18,%rsp
  800cba:	5b                   	pop    %rbx
  800cbb:	41 5c                	pop    %r12
  800cbd:	41 5d                	pop    %r13
  800cbf:	5d                   	pop    %rbp
  800cc0:	c3                   	ret
                thisenv->env_id, fdnum);
  800cc1:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800cc8:	00 00 00 
  800ccb:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800cd1:	89 da                	mov    %ebx,%edx
  800cd3:	48 bf a0 32 80 00 00 	movabs $0x8032a0,%rdi
  800cda:	00 00 00 
  800cdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce2:	48 b9 59 1d 80 00 00 	movabs $0x801d59,%rcx
  800ce9:	00 00 00 
  800cec:	ff d1                	call   *%rcx
        return -E_INVAL;
  800cee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cf3:	eb c1                	jmp    800cb6 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800cf5:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800cfa:	eb ba                	jmp    800cb6 <ftruncate+0x62>

0000000000800cfc <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800cfc:	f3 0f 1e fa          	endbr64
  800d00:	55                   	push   %rbp
  800d01:	48 89 e5             	mov    %rsp,%rbp
  800d04:	41 54                	push   %r12
  800d06:	53                   	push   %rbx
  800d07:	48 83 ec 10          	sub    $0x10,%rsp
  800d0b:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800d0e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800d12:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  800d19:	00 00 00 
  800d1c:	ff d0                	call   *%rax
  800d1e:	85 c0                	test   %eax,%eax
  800d20:	78 4e                	js     800d70 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800d22:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  800d26:	41 8b 3c 24          	mov    (%r12),%edi
  800d2a:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800d2e:	48 b8 7f 07 80 00 00 	movabs $0x80077f,%rax
  800d35:	00 00 00 
  800d38:	ff d0                	call   *%rax
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	78 32                	js     800d70 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800d42:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800d47:	74 30                	je     800d79 <fstat+0x7d>

    stat->st_name[0] = 0;
  800d49:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800d4c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800d53:	00 00 00 
    stat->st_isdir = 0;
  800d56:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800d5d:	00 00 00 
    stat->st_dev = dev;
  800d60:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800d67:	48 89 de             	mov    %rbx,%rsi
  800d6a:	4c 89 e7             	mov    %r12,%rdi
  800d6d:	ff 50 28             	call   *0x28(%rax)
}
  800d70:	48 83 c4 10          	add    $0x10,%rsp
  800d74:	5b                   	pop    %rbx
  800d75:	41 5c                	pop    %r12
  800d77:	5d                   	pop    %rbp
  800d78:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d79:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800d7e:	eb f0                	jmp    800d70 <fstat+0x74>

0000000000800d80 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800d80:	f3 0f 1e fa          	endbr64
  800d84:	55                   	push   %rbp
  800d85:	48 89 e5             	mov    %rsp,%rbp
  800d88:	41 54                	push   %r12
  800d8a:	53                   	push   %rbx
  800d8b:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800d8e:	be 00 00 00 00       	mov    $0x0,%esi
  800d93:	48 b8 61 10 80 00 00 	movabs $0x801061,%rax
  800d9a:	00 00 00 
  800d9d:	ff d0                	call   *%rax
  800d9f:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800da1:	85 c0                	test   %eax,%eax
  800da3:	78 25                	js     800dca <stat+0x4a>

    int res = fstat(fd, stat);
  800da5:	4c 89 e6             	mov    %r12,%rsi
  800da8:	89 c7                	mov    %eax,%edi
  800daa:	48 b8 fc 0c 80 00 00 	movabs $0x800cfc,%rax
  800db1:	00 00 00 
  800db4:	ff d0                	call   *%rax
  800db6:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800db9:	89 df                	mov    %ebx,%edi
  800dbb:	48 b8 a1 08 80 00 00 	movabs $0x8008a1,%rax
  800dc2:	00 00 00 
  800dc5:	ff d0                	call   *%rax

    return res;
  800dc7:	44 89 e3             	mov    %r12d,%ebx
}
  800dca:	89 d8                	mov    %ebx,%eax
  800dcc:	5b                   	pop    %rbx
  800dcd:	41 5c                	pop    %r12
  800dcf:	5d                   	pop    %rbp
  800dd0:	c3                   	ret

0000000000800dd1 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800dd1:	f3 0f 1e fa          	endbr64
  800dd5:	55                   	push   %rbp
  800dd6:	48 89 e5             	mov    %rsp,%rbp
  800dd9:	41 54                	push   %r12
  800ddb:	53                   	push   %rbx
  800ddc:	48 83 ec 10          	sub    $0x10,%rsp
  800de0:	41 89 fc             	mov    %edi,%r12d
  800de3:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800de6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800ded:	00 00 00 
  800df0:	83 38 00             	cmpl   $0x0,(%rax)
  800df3:	74 6e                	je     800e63 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  800df5:	bf 03 00 00 00       	mov    $0x3,%edi
  800dfa:	48 b8 5d 2c 80 00 00 	movabs $0x802c5d,%rax
  800e01:	00 00 00 
  800e04:	ff d0                	call   *%rax
  800e06:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e0d:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800e0f:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800e15:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800e1a:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800e21:	00 00 00 
  800e24:	44 89 e6             	mov    %r12d,%esi
  800e27:	89 c7                	mov    %eax,%edi
  800e29:	48 b8 9b 2b 80 00 00 	movabs $0x802b9b,%rax
  800e30:	00 00 00 
  800e33:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800e35:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800e3c:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800e3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e42:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e46:	48 89 de             	mov    %rbx,%rsi
  800e49:	bf 00 00 00 00       	mov    $0x0,%edi
  800e4e:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  800e55:	00 00 00 
  800e58:	ff d0                	call   *%rax
}
  800e5a:	48 83 c4 10          	add    $0x10,%rsp
  800e5e:	5b                   	pop    %rbx
  800e5f:	41 5c                	pop    %r12
  800e61:	5d                   	pop    %rbp
  800e62:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800e63:	bf 03 00 00 00       	mov    $0x3,%edi
  800e68:	48 b8 5d 2c 80 00 00 	movabs $0x802c5d,%rax
  800e6f:	00 00 00 
  800e72:	ff d0                	call   *%rax
  800e74:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e7b:	00 00 
  800e7d:	e9 73 ff ff ff       	jmp    800df5 <fsipc+0x24>

0000000000800e82 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800e82:	f3 0f 1e fa          	endbr64
  800e86:	55                   	push   %rbp
  800e87:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800e8a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e91:	00 00 00 
  800e94:	8b 57 0c             	mov    0xc(%rdi),%edx
  800e97:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800e99:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800e9c:	be 00 00 00 00       	mov    $0x0,%esi
  800ea1:	bf 02 00 00 00       	mov    $0x2,%edi
  800ea6:	48 b8 d1 0d 80 00 00 	movabs $0x800dd1,%rax
  800ead:	00 00 00 
  800eb0:	ff d0                	call   *%rax
}
  800eb2:	5d                   	pop    %rbp
  800eb3:	c3                   	ret

0000000000800eb4 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800eb4:	f3 0f 1e fa          	endbr64
  800eb8:	55                   	push   %rbp
  800eb9:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800ebc:	8b 47 0c             	mov    0xc(%rdi),%eax
  800ebf:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ec6:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800ec8:	be 00 00 00 00       	mov    $0x0,%esi
  800ecd:	bf 06 00 00 00       	mov    $0x6,%edi
  800ed2:	48 b8 d1 0d 80 00 00 	movabs $0x800dd1,%rax
  800ed9:	00 00 00 
  800edc:	ff d0                	call   *%rax
}
  800ede:	5d                   	pop    %rbp
  800edf:	c3                   	ret

0000000000800ee0 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800ee0:	f3 0f 1e fa          	endbr64
  800ee4:	55                   	push   %rbp
  800ee5:	48 89 e5             	mov    %rsp,%rbp
  800ee8:	41 54                	push   %r12
  800eea:	53                   	push   %rbx
  800eeb:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800eee:	8b 47 0c             	mov    0xc(%rdi),%eax
  800ef1:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ef8:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800efa:	be 00 00 00 00       	mov    $0x0,%esi
  800eff:	bf 05 00 00 00       	mov    $0x5,%edi
  800f04:	48 b8 d1 0d 80 00 00 	movabs $0x800dd1,%rax
  800f0b:	00 00 00 
  800f0e:	ff d0                	call   *%rax
    if (res < 0) return res;
  800f10:	85 c0                	test   %eax,%eax
  800f12:	78 3d                	js     800f51 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800f14:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  800f1b:	00 00 00 
  800f1e:	4c 89 e6             	mov    %r12,%rsi
  800f21:	48 89 df             	mov    %rbx,%rdi
  800f24:	48 b8 a2 26 80 00 00 	movabs $0x8026a2,%rax
  800f2b:	00 00 00 
  800f2e:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800f30:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  800f37:	00 
  800f38:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800f3e:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  800f45:	00 
  800f46:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800f4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f51:	5b                   	pop    %rbx
  800f52:	41 5c                	pop    %r12
  800f54:	5d                   	pop    %rbp
  800f55:	c3                   	ret

0000000000800f56 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f56:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  800f5a:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  800f61:	77 41                	ja     800fa4 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f63:	55                   	push   %rbp
  800f64:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  800f67:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f6e:	00 00 00 
  800f71:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f74:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  800f76:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  800f7a:	48 8d 78 10          	lea    0x10(%rax),%rdi
  800f7e:	48 b8 bd 28 80 00 00 	movabs $0x8028bd,%rax
  800f85:	00 00 00 
  800f88:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  800f8a:	be 00 00 00 00       	mov    $0x0,%esi
  800f8f:	bf 04 00 00 00       	mov    $0x4,%edi
  800f94:	48 b8 d1 0d 80 00 00 	movabs $0x800dd1,%rax
  800f9b:	00 00 00 
  800f9e:	ff d0                	call   *%rax
  800fa0:	48 98                	cltq
}
  800fa2:	5d                   	pop    %rbp
  800fa3:	c3                   	ret
        return -E_INVAL;
  800fa4:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  800fab:	c3                   	ret

0000000000800fac <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800fac:	f3 0f 1e fa          	endbr64
  800fb0:	55                   	push   %rbp
  800fb1:	48 89 e5             	mov    %rsp,%rbp
  800fb4:	41 55                	push   %r13
  800fb6:	41 54                	push   %r12
  800fb8:	53                   	push   %rbx
  800fb9:	48 83 ec 08          	sub    $0x8,%rsp
  800fbd:	49 89 f4             	mov    %rsi,%r12
  800fc0:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800fc3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800fca:	00 00 00 
  800fcd:	8b 57 0c             	mov    0xc(%rdi),%edx
  800fd0:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  800fd2:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  800fd6:	be 00 00 00 00       	mov    $0x0,%esi
  800fdb:	bf 03 00 00 00       	mov    $0x3,%edi
  800fe0:	48 b8 d1 0d 80 00 00 	movabs $0x800dd1,%rax
  800fe7:	00 00 00 
  800fea:	ff d0                	call   *%rax
  800fec:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  800fef:	4d 85 ed             	test   %r13,%r13
  800ff2:	78 2a                	js     80101e <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  800ff4:	4c 89 ea             	mov    %r13,%rdx
  800ff7:	4c 39 eb             	cmp    %r13,%rbx
  800ffa:	72 30                	jb     80102c <devfile_read+0x80>
  800ffc:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  801003:	7f 27                	jg     80102c <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  801005:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  80100c:	00 00 00 
  80100f:	4c 89 e7             	mov    %r12,%rdi
  801012:	48 b8 bd 28 80 00 00 	movabs $0x8028bd,%rax
  801019:	00 00 00 
  80101c:	ff d0                	call   *%rax
}
  80101e:	4c 89 e8             	mov    %r13,%rax
  801021:	48 83 c4 08          	add    $0x8,%rsp
  801025:	5b                   	pop    %rbx
  801026:	41 5c                	pop    %r12
  801028:	41 5d                	pop    %r13
  80102a:	5d                   	pop    %rbp
  80102b:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  80102c:	48 b9 56 30 80 00 00 	movabs $0x803056,%rcx
  801033:	00 00 00 
  801036:	48 ba 73 30 80 00 00 	movabs $0x803073,%rdx
  80103d:	00 00 00 
  801040:	be 7b 00 00 00       	mov    $0x7b,%esi
  801045:	48 bf 88 30 80 00 00 	movabs $0x803088,%rdi
  80104c:	00 00 00 
  80104f:	b8 00 00 00 00       	mov    $0x0,%eax
  801054:	49 b8 fd 1b 80 00 00 	movabs $0x801bfd,%r8
  80105b:	00 00 00 
  80105e:	41 ff d0             	call   *%r8

0000000000801061 <open>:
open(const char *path, int mode) {
  801061:	f3 0f 1e fa          	endbr64
  801065:	55                   	push   %rbp
  801066:	48 89 e5             	mov    %rsp,%rbp
  801069:	41 55                	push   %r13
  80106b:	41 54                	push   %r12
  80106d:	53                   	push   %rbx
  80106e:	48 83 ec 18          	sub    $0x18,%rsp
  801072:	49 89 fc             	mov    %rdi,%r12
  801075:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801078:	48 b8 5d 26 80 00 00 	movabs $0x80265d,%rax
  80107f:	00 00 00 
  801082:	ff d0                	call   *%rax
  801084:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80108a:	0f 87 8a 00 00 00    	ja     80111a <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801090:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801094:	48 b8 cc 06 80 00 00 	movabs $0x8006cc,%rax
  80109b:	00 00 00 
  80109e:	ff d0                	call   *%rax
  8010a0:	89 c3                	mov    %eax,%ebx
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	78 50                	js     8010f6 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  8010a6:	4c 89 e6             	mov    %r12,%rsi
  8010a9:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  8010b0:	00 00 00 
  8010b3:	48 89 df             	mov    %rbx,%rdi
  8010b6:	48 b8 a2 26 80 00 00 	movabs $0x8026a2,%rax
  8010bd:	00 00 00 
  8010c0:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8010c2:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8010c9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8010cd:	bf 01 00 00 00       	mov    $0x1,%edi
  8010d2:	48 b8 d1 0d 80 00 00 	movabs $0x800dd1,%rax
  8010d9:	00 00 00 
  8010dc:	ff d0                	call   *%rax
  8010de:	89 c3                	mov    %eax,%ebx
  8010e0:	85 c0                	test   %eax,%eax
  8010e2:	78 1f                	js     801103 <open+0xa2>
    return fd2num(fd);
  8010e4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010e8:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  8010ef:	00 00 00 
  8010f2:	ff d0                	call   *%rax
  8010f4:	89 c3                	mov    %eax,%ebx
}
  8010f6:	89 d8                	mov    %ebx,%eax
  8010f8:	48 83 c4 18          	add    $0x18,%rsp
  8010fc:	5b                   	pop    %rbx
  8010fd:	41 5c                	pop    %r12
  8010ff:	41 5d                	pop    %r13
  801101:	5d                   	pop    %rbp
  801102:	c3                   	ret
        fd_close(fd, 0);
  801103:	be 00 00 00 00       	mov    $0x0,%esi
  801108:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80110c:	48 b8 f3 07 80 00 00 	movabs $0x8007f3,%rax
  801113:	00 00 00 
  801116:	ff d0                	call   *%rax
        return res;
  801118:	eb dc                	jmp    8010f6 <open+0x95>
        return -E_BAD_PATH;
  80111a:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80111f:	eb d5                	jmp    8010f6 <open+0x95>

0000000000801121 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801121:	f3 0f 1e fa          	endbr64
  801125:	55                   	push   %rbp
  801126:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801129:	be 00 00 00 00       	mov    $0x0,%esi
  80112e:	bf 08 00 00 00       	mov    $0x8,%edi
  801133:	48 b8 d1 0d 80 00 00 	movabs $0x800dd1,%rax
  80113a:	00 00 00 
  80113d:	ff d0                	call   *%rax
}
  80113f:	5d                   	pop    %rbp
  801140:	c3                   	ret

0000000000801141 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801141:	f3 0f 1e fa          	endbr64
  801145:	55                   	push   %rbp
  801146:	48 89 e5             	mov    %rsp,%rbp
  801149:	41 54                	push   %r12
  80114b:	53                   	push   %rbx
  80114c:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80114f:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  801156:	00 00 00 
  801159:	ff d0                	call   *%rax
  80115b:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80115e:	48 be 93 30 80 00 00 	movabs $0x803093,%rsi
  801165:	00 00 00 
  801168:	48 89 df             	mov    %rbx,%rdi
  80116b:	48 b8 a2 26 80 00 00 	movabs $0x8026a2,%rax
  801172:	00 00 00 
  801175:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801177:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80117c:	41 2b 04 24          	sub    (%r12),%eax
  801180:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801186:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80118d:	00 00 00 
    stat->st_dev = &devpipe;
  801190:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801197:	00 00 00 
  80119a:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a6:	5b                   	pop    %rbx
  8011a7:	41 5c                	pop    %r12
  8011a9:	5d                   	pop    %rbp
  8011aa:	c3                   	ret

00000000008011ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8011ab:	f3 0f 1e fa          	endbr64
  8011af:	55                   	push   %rbp
  8011b0:	48 89 e5             	mov    %rsp,%rbp
  8011b3:	41 54                	push   %r12
  8011b5:	53                   	push   %rbx
  8011b6:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8011b9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011be:	48 89 fe             	mov    %rdi,%rsi
  8011c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8011c6:	49 bc 12 04 80 00 00 	movabs $0x800412,%r12
  8011cd:	00 00 00 
  8011d0:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8011d3:	48 89 df             	mov    %rbx,%rdi
  8011d6:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  8011dd:	00 00 00 
  8011e0:	ff d0                	call   *%rax
  8011e2:	48 89 c6             	mov    %rax,%rsi
  8011e5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8011ef:	41 ff d4             	call   *%r12
}
  8011f2:	5b                   	pop    %rbx
  8011f3:	41 5c                	pop    %r12
  8011f5:	5d                   	pop    %rbp
  8011f6:	c3                   	ret

00000000008011f7 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8011f7:	f3 0f 1e fa          	endbr64
  8011fb:	55                   	push   %rbp
  8011fc:	48 89 e5             	mov    %rsp,%rbp
  8011ff:	41 57                	push   %r15
  801201:	41 56                	push   %r14
  801203:	41 55                	push   %r13
  801205:	41 54                	push   %r12
  801207:	53                   	push   %rbx
  801208:	48 83 ec 18          	sub    $0x18,%rsp
  80120c:	49 89 fc             	mov    %rdi,%r12
  80120f:	49 89 f5             	mov    %rsi,%r13
  801212:	49 89 d7             	mov    %rdx,%r15
  801215:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801219:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  801220:	00 00 00 
  801223:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801225:	4d 85 ff             	test   %r15,%r15
  801228:	0f 84 af 00 00 00    	je     8012dd <devpipe_write+0xe6>
  80122e:	48 89 c3             	mov    %rax,%rbx
  801231:	4c 89 f8             	mov    %r15,%rax
  801234:	4d 89 ef             	mov    %r13,%r15
  801237:	4c 01 e8             	add    %r13,%rax
  80123a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80123e:	49 bd a2 02 80 00 00 	movabs $0x8002a2,%r13
  801245:	00 00 00 
            sys_yield();
  801248:	49 be 37 02 80 00 00 	movabs $0x800237,%r14
  80124f:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801252:	8b 73 04             	mov    0x4(%rbx),%esi
  801255:	48 63 ce             	movslq %esi,%rcx
  801258:	48 63 03             	movslq (%rbx),%rax
  80125b:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801261:	48 39 c1             	cmp    %rax,%rcx
  801264:	72 2e                	jb     801294 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801266:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80126b:	48 89 da             	mov    %rbx,%rdx
  80126e:	be 00 10 00 00       	mov    $0x1000,%esi
  801273:	4c 89 e7             	mov    %r12,%rdi
  801276:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801279:	85 c0                	test   %eax,%eax
  80127b:	74 66                	je     8012e3 <devpipe_write+0xec>
            sys_yield();
  80127d:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801280:	8b 73 04             	mov    0x4(%rbx),%esi
  801283:	48 63 ce             	movslq %esi,%rcx
  801286:	48 63 03             	movslq (%rbx),%rax
  801289:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80128f:	48 39 c1             	cmp    %rax,%rcx
  801292:	73 d2                	jae    801266 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801294:	41 0f b6 3f          	movzbl (%r15),%edi
  801298:	48 89 ca             	mov    %rcx,%rdx
  80129b:	48 c1 ea 03          	shr    $0x3,%rdx
  80129f:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8012a6:	08 10 20 
  8012a9:	48 f7 e2             	mul    %rdx
  8012ac:	48 c1 ea 06          	shr    $0x6,%rdx
  8012b0:	48 89 d0             	mov    %rdx,%rax
  8012b3:	48 c1 e0 09          	shl    $0x9,%rax
  8012b7:	48 29 d0             	sub    %rdx,%rax
  8012ba:	48 c1 e0 03          	shl    $0x3,%rax
  8012be:	48 29 c1             	sub    %rax,%rcx
  8012c1:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8012c6:	83 c6 01             	add    $0x1,%esi
  8012c9:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012cc:	49 83 c7 01          	add    $0x1,%r15
  8012d0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012d4:	49 39 c7             	cmp    %rax,%r15
  8012d7:	0f 85 75 ff ff ff    	jne    801252 <devpipe_write+0x5b>
    return n;
  8012dd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8012e1:	eb 05                	jmp    8012e8 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8012e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e8:	48 83 c4 18          	add    $0x18,%rsp
  8012ec:	5b                   	pop    %rbx
  8012ed:	41 5c                	pop    %r12
  8012ef:	41 5d                	pop    %r13
  8012f1:	41 5e                	pop    %r14
  8012f3:	41 5f                	pop    %r15
  8012f5:	5d                   	pop    %rbp
  8012f6:	c3                   	ret

00000000008012f7 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8012f7:	f3 0f 1e fa          	endbr64
  8012fb:	55                   	push   %rbp
  8012fc:	48 89 e5             	mov    %rsp,%rbp
  8012ff:	41 57                	push   %r15
  801301:	41 56                	push   %r14
  801303:	41 55                	push   %r13
  801305:	41 54                	push   %r12
  801307:	53                   	push   %rbx
  801308:	48 83 ec 18          	sub    $0x18,%rsp
  80130c:	49 89 fc             	mov    %rdi,%r12
  80130f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801313:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801317:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  80131e:	00 00 00 
  801321:	ff d0                	call   *%rax
  801323:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  801326:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80132c:	49 bd a2 02 80 00 00 	movabs $0x8002a2,%r13
  801333:	00 00 00 
            sys_yield();
  801336:	49 be 37 02 80 00 00 	movabs $0x800237,%r14
  80133d:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801340:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801345:	74 7d                	je     8013c4 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801347:	8b 03                	mov    (%rbx),%eax
  801349:	3b 43 04             	cmp    0x4(%rbx),%eax
  80134c:	75 26                	jne    801374 <devpipe_read+0x7d>
            if (i > 0) return i;
  80134e:	4d 85 ff             	test   %r15,%r15
  801351:	75 77                	jne    8013ca <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801353:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801358:	48 89 da             	mov    %rbx,%rdx
  80135b:	be 00 10 00 00       	mov    $0x1000,%esi
  801360:	4c 89 e7             	mov    %r12,%rdi
  801363:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801366:	85 c0                	test   %eax,%eax
  801368:	74 72                	je     8013dc <devpipe_read+0xe5>
            sys_yield();
  80136a:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80136d:	8b 03                	mov    (%rbx),%eax
  80136f:	3b 43 04             	cmp    0x4(%rbx),%eax
  801372:	74 df                	je     801353 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801374:	48 63 c8             	movslq %eax,%rcx
  801377:	48 89 ca             	mov    %rcx,%rdx
  80137a:	48 c1 ea 03          	shr    $0x3,%rdx
  80137e:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  801385:	08 10 20 
  801388:	48 89 d0             	mov    %rdx,%rax
  80138b:	48 f7 e6             	mul    %rsi
  80138e:	48 c1 ea 06          	shr    $0x6,%rdx
  801392:	48 89 d0             	mov    %rdx,%rax
  801395:	48 c1 e0 09          	shl    $0x9,%rax
  801399:	48 29 d0             	sub    %rdx,%rax
  80139c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8013a3:	00 
  8013a4:	48 89 c8             	mov    %rcx,%rax
  8013a7:	48 29 d0             	sub    %rdx,%rax
  8013aa:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8013af:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8013b3:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8013b7:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8013ba:	49 83 c7 01          	add    $0x1,%r15
  8013be:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8013c2:	75 83                	jne    801347 <devpipe_read+0x50>
    return n;
  8013c4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013c8:	eb 03                	jmp    8013cd <devpipe_read+0xd6>
            if (i > 0) return i;
  8013ca:	4c 89 f8             	mov    %r15,%rax
}
  8013cd:	48 83 c4 18          	add    $0x18,%rsp
  8013d1:	5b                   	pop    %rbx
  8013d2:	41 5c                	pop    %r12
  8013d4:	41 5d                	pop    %r13
  8013d6:	41 5e                	pop    %r14
  8013d8:	41 5f                	pop    %r15
  8013da:	5d                   	pop    %rbp
  8013db:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8013dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e1:	eb ea                	jmp    8013cd <devpipe_read+0xd6>

00000000008013e3 <pipe>:
pipe(int pfd[2]) {
  8013e3:	f3 0f 1e fa          	endbr64
  8013e7:	55                   	push   %rbp
  8013e8:	48 89 e5             	mov    %rsp,%rbp
  8013eb:	41 55                	push   %r13
  8013ed:	41 54                	push   %r12
  8013ef:	53                   	push   %rbx
  8013f0:	48 83 ec 18          	sub    $0x18,%rsp
  8013f4:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8013f7:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8013fb:	48 b8 cc 06 80 00 00 	movabs $0x8006cc,%rax
  801402:	00 00 00 
  801405:	ff d0                	call   *%rax
  801407:	89 c3                	mov    %eax,%ebx
  801409:	85 c0                	test   %eax,%eax
  80140b:	0f 88 a0 01 00 00    	js     8015b1 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  801411:	b9 46 00 00 00       	mov    $0x46,%ecx
  801416:	ba 00 10 00 00       	mov    $0x1000,%edx
  80141b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80141f:	bf 00 00 00 00       	mov    $0x0,%edi
  801424:	48 b8 d2 02 80 00 00 	movabs $0x8002d2,%rax
  80142b:	00 00 00 
  80142e:	ff d0                	call   *%rax
  801430:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801432:	85 c0                	test   %eax,%eax
  801434:	0f 88 77 01 00 00    	js     8015b1 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80143a:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80143e:	48 b8 cc 06 80 00 00 	movabs $0x8006cc,%rax
  801445:	00 00 00 
  801448:	ff d0                	call   *%rax
  80144a:	89 c3                	mov    %eax,%ebx
  80144c:	85 c0                	test   %eax,%eax
  80144e:	0f 88 43 01 00 00    	js     801597 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  801454:	b9 46 00 00 00       	mov    $0x46,%ecx
  801459:	ba 00 10 00 00       	mov    $0x1000,%edx
  80145e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801462:	bf 00 00 00 00       	mov    $0x0,%edi
  801467:	48 b8 d2 02 80 00 00 	movabs $0x8002d2,%rax
  80146e:	00 00 00 
  801471:	ff d0                	call   *%rax
  801473:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  801475:	85 c0                	test   %eax,%eax
  801477:	0f 88 1a 01 00 00    	js     801597 <pipe+0x1b4>
    va = fd2data(fd0);
  80147d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801481:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  801488:	00 00 00 
  80148b:	ff d0                	call   *%rax
  80148d:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801490:	b9 46 00 00 00       	mov    $0x46,%ecx
  801495:	ba 00 10 00 00       	mov    $0x1000,%edx
  80149a:	48 89 c6             	mov    %rax,%rsi
  80149d:	bf 00 00 00 00       	mov    $0x0,%edi
  8014a2:	48 b8 d2 02 80 00 00 	movabs $0x8002d2,%rax
  8014a9:	00 00 00 
  8014ac:	ff d0                	call   *%rax
  8014ae:	89 c3                	mov    %eax,%ebx
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	0f 88 c5 00 00 00    	js     80157d <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8014b8:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8014bc:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  8014c3:	00 00 00 
  8014c6:	ff d0                	call   *%rax
  8014c8:	48 89 c1             	mov    %rax,%rcx
  8014cb:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8014d1:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8014d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014dc:	4c 89 ee             	mov    %r13,%rsi
  8014df:	bf 00 00 00 00       	mov    $0x0,%edi
  8014e4:	48 b8 3d 03 80 00 00 	movabs $0x80033d,%rax
  8014eb:	00 00 00 
  8014ee:	ff d0                	call   *%rax
  8014f0:	89 c3                	mov    %eax,%ebx
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	78 6e                	js     801564 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014f6:	be 00 10 00 00       	mov    $0x1000,%esi
  8014fb:	4c 89 ef             	mov    %r13,%rdi
  8014fe:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  801505:	00 00 00 
  801508:	ff d0                	call   *%rax
  80150a:	83 f8 02             	cmp    $0x2,%eax
  80150d:	0f 85 ab 00 00 00    	jne    8015be <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  801513:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80151a:	00 00 
  80151c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801520:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  801522:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801526:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80152d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801531:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801533:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801537:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80153e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801542:	48 bb 96 06 80 00 00 	movabs $0x800696,%rbx
  801549:	00 00 00 
  80154c:	ff d3                	call   *%rbx
  80154e:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801552:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801556:	ff d3                	call   *%rbx
  801558:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80155d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801562:	eb 4d                	jmp    8015b1 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  801564:	ba 00 10 00 00       	mov    $0x1000,%edx
  801569:	4c 89 ee             	mov    %r13,%rsi
  80156c:	bf 00 00 00 00       	mov    $0x0,%edi
  801571:	48 b8 12 04 80 00 00 	movabs $0x800412,%rax
  801578:	00 00 00 
  80157b:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80157d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801582:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801586:	bf 00 00 00 00       	mov    $0x0,%edi
  80158b:	48 b8 12 04 80 00 00 	movabs $0x800412,%rax
  801592:	00 00 00 
  801595:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  801597:	ba 00 10 00 00       	mov    $0x1000,%edx
  80159c:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8015a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8015a5:	48 b8 12 04 80 00 00 	movabs $0x800412,%rax
  8015ac:	00 00 00 
  8015af:	ff d0                	call   *%rax
}
  8015b1:	89 d8                	mov    %ebx,%eax
  8015b3:	48 83 c4 18          	add    $0x18,%rsp
  8015b7:	5b                   	pop    %rbx
  8015b8:	41 5c                	pop    %r12
  8015ba:	41 5d                	pop    %r13
  8015bc:	5d                   	pop    %rbp
  8015bd:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8015be:	48 b9 c8 32 80 00 00 	movabs $0x8032c8,%rcx
  8015c5:	00 00 00 
  8015c8:	48 ba 73 30 80 00 00 	movabs $0x803073,%rdx
  8015cf:	00 00 00 
  8015d2:	be 2e 00 00 00       	mov    $0x2e,%esi
  8015d7:	48 bf 9a 30 80 00 00 	movabs $0x80309a,%rdi
  8015de:	00 00 00 
  8015e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e6:	49 b8 fd 1b 80 00 00 	movabs $0x801bfd,%r8
  8015ed:	00 00 00 
  8015f0:	41 ff d0             	call   *%r8

00000000008015f3 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8015f3:	f3 0f 1e fa          	endbr64
  8015f7:	55                   	push   %rbp
  8015f8:	48 89 e5             	mov    %rsp,%rbp
  8015fb:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8015ff:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801603:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  80160a:	00 00 00 
  80160d:	ff d0                	call   *%rax
    if (res < 0) return res;
  80160f:	85 c0                	test   %eax,%eax
  801611:	78 35                	js     801648 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  801613:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801617:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  80161e:	00 00 00 
  801621:	ff d0                	call   *%rax
  801623:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801626:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80162b:	be 00 10 00 00       	mov    $0x1000,%esi
  801630:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801634:	48 b8 a2 02 80 00 00 	movabs $0x8002a2,%rax
  80163b:	00 00 00 
  80163e:	ff d0                	call   *%rax
  801640:	85 c0                	test   %eax,%eax
  801642:	0f 94 c0             	sete   %al
  801645:	0f b6 c0             	movzbl %al,%eax
}
  801648:	c9                   	leave
  801649:	c3                   	ret

000000000080164a <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  80164a:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80164e:	48 89 f8             	mov    %rdi,%rax
  801651:	48 c1 e8 27          	shr    $0x27,%rax
  801655:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80165c:	7f 00 00 
  80165f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801663:	f6 c2 01             	test   $0x1,%dl
  801666:	74 6d                	je     8016d5 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801668:	48 89 f8             	mov    %rdi,%rax
  80166b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80166f:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801676:	7f 00 00 
  801679:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80167d:	f6 c2 01             	test   $0x1,%dl
  801680:	74 62                	je     8016e4 <get_uvpt_entry+0x9a>
  801682:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801689:	7f 00 00 
  80168c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801690:	f6 c2 80             	test   $0x80,%dl
  801693:	75 4f                	jne    8016e4 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801695:	48 89 f8             	mov    %rdi,%rax
  801698:	48 c1 e8 15          	shr    $0x15,%rax
  80169c:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016a3:	7f 00 00 
  8016a6:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8016aa:	f6 c2 01             	test   $0x1,%dl
  8016ad:	74 44                	je     8016f3 <get_uvpt_entry+0xa9>
  8016af:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016b6:	7f 00 00 
  8016b9:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8016bd:	f6 c2 80             	test   $0x80,%dl
  8016c0:	75 31                	jne    8016f3 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  8016c2:	48 c1 ef 0c          	shr    $0xc,%rdi
  8016c6:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8016cd:	7f 00 00 
  8016d0:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8016d4:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8016d5:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8016dc:	7f 00 00 
  8016df:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016e3:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8016e4:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8016eb:	7f 00 00 
  8016ee:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016f2:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8016f3:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016fa:	7f 00 00 
  8016fd:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801701:	c3                   	ret

0000000000801702 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  801702:	f3 0f 1e fa          	endbr64
  801706:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  801709:	48 89 f9             	mov    %rdi,%rcx
  80170c:	48 c1 e9 27          	shr    $0x27,%rcx
  801710:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  801717:	7f 00 00 
  80171a:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  80171e:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  801725:	f6 c1 01             	test   $0x1,%cl
  801728:	0f 84 b2 00 00 00    	je     8017e0 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80172e:	48 89 f9             	mov    %rdi,%rcx
  801731:	48 c1 e9 1e          	shr    $0x1e,%rcx
  801735:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80173c:	7f 00 00 
  80173f:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801743:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80174a:	40 f6 c6 01          	test   $0x1,%sil
  80174e:	0f 84 8c 00 00 00    	je     8017e0 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  801754:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80175b:	7f 00 00 
  80175e:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801762:	a8 80                	test   $0x80,%al
  801764:	75 7b                	jne    8017e1 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  801766:	48 89 f9             	mov    %rdi,%rcx
  801769:	48 c1 e9 15          	shr    $0x15,%rcx
  80176d:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801774:	7f 00 00 
  801777:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80177b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  801782:	40 f6 c6 01          	test   $0x1,%sil
  801786:	74 58                	je     8017e0 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  801788:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80178f:	7f 00 00 
  801792:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801796:	a8 80                	test   $0x80,%al
  801798:	75 6c                	jne    801806 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  80179a:	48 89 f9             	mov    %rdi,%rcx
  80179d:	48 c1 e9 0c          	shr    $0xc,%rcx
  8017a1:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8017a8:	7f 00 00 
  8017ab:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8017af:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  8017b6:	40 f6 c6 01          	test   $0x1,%sil
  8017ba:	74 24                	je     8017e0 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  8017bc:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8017c3:	7f 00 00 
  8017c6:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017ca:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017d1:	ff ff 7f 
  8017d4:	48 21 c8             	and    %rcx,%rax
  8017d7:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8017dd:	48 09 d0             	or     %rdx,%rax
}
  8017e0:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8017e1:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8017e8:	7f 00 00 
  8017eb:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017ef:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017f6:	ff ff 7f 
  8017f9:	48 21 c8             	and    %rcx,%rax
  8017fc:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  801802:	48 01 d0             	add    %rdx,%rax
  801805:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  801806:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80180d:	7f 00 00 
  801810:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801814:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80181b:	ff ff 7f 
  80181e:	48 21 c8             	and    %rcx,%rax
  801821:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  801827:	48 01 d0             	add    %rdx,%rax
  80182a:	c3                   	ret

000000000080182b <get_prot>:

int
get_prot(void *va) {
  80182b:	f3 0f 1e fa          	endbr64
  80182f:	55                   	push   %rbp
  801830:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801833:	48 b8 4a 16 80 00 00 	movabs $0x80164a,%rax
  80183a:	00 00 00 
  80183d:	ff d0                	call   *%rax
  80183f:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  801842:	83 e0 01             	and    $0x1,%eax
  801845:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  801848:	89 d1                	mov    %edx,%ecx
  80184a:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  801850:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  801852:	89 c1                	mov    %eax,%ecx
  801854:	83 c9 02             	or     $0x2,%ecx
  801857:	f6 c2 02             	test   $0x2,%dl
  80185a:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80185d:	89 c1                	mov    %eax,%ecx
  80185f:	83 c9 01             	or     $0x1,%ecx
  801862:	48 85 d2             	test   %rdx,%rdx
  801865:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801868:	89 c1                	mov    %eax,%ecx
  80186a:	83 c9 40             	or     $0x40,%ecx
  80186d:	f6 c6 04             	test   $0x4,%dh
  801870:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801873:	5d                   	pop    %rbp
  801874:	c3                   	ret

0000000000801875 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801875:	f3 0f 1e fa          	endbr64
  801879:	55                   	push   %rbp
  80187a:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80187d:	48 b8 4a 16 80 00 00 	movabs $0x80164a,%rax
  801884:	00 00 00 
  801887:	ff d0                	call   *%rax
    return pte & PTE_D;
  801889:	48 c1 e8 06          	shr    $0x6,%rax
  80188d:	83 e0 01             	and    $0x1,%eax
}
  801890:	5d                   	pop    %rbp
  801891:	c3                   	ret

0000000000801892 <is_page_present>:

bool
is_page_present(void *va) {
  801892:	f3 0f 1e fa          	endbr64
  801896:	55                   	push   %rbp
  801897:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80189a:	48 b8 4a 16 80 00 00 	movabs $0x80164a,%rax
  8018a1:	00 00 00 
  8018a4:	ff d0                	call   *%rax
  8018a6:	83 e0 01             	and    $0x1,%eax
}
  8018a9:	5d                   	pop    %rbp
  8018aa:	c3                   	ret

00000000008018ab <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8018ab:	f3 0f 1e fa          	endbr64
  8018af:	55                   	push   %rbp
  8018b0:	48 89 e5             	mov    %rsp,%rbp
  8018b3:	41 57                	push   %r15
  8018b5:	41 56                	push   %r14
  8018b7:	41 55                	push   %r13
  8018b9:	41 54                	push   %r12
  8018bb:	53                   	push   %rbx
  8018bc:	48 83 ec 18          	sub    $0x18,%rsp
  8018c0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8018c4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8018c8:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8018cd:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8018d4:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8018d7:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8018de:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8018e1:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8018e8:	00 00 00 
  8018eb:	eb 73                	jmp    801960 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018ed:	48 89 d8             	mov    %rbx,%rax
  8018f0:	48 c1 e8 15          	shr    $0x15,%rax
  8018f4:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8018fb:	7f 00 00 
  8018fe:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  801902:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  801908:	f6 c2 01             	test   $0x1,%dl
  80190b:	74 4b                	je     801958 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  80190d:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  801911:	f6 c2 80             	test   $0x80,%dl
  801914:	74 11                	je     801927 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  801916:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  80191a:	f6 c4 04             	test   $0x4,%ah
  80191d:	74 39                	je     801958 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  80191f:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  801925:	eb 20                	jmp    801947 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801927:	48 89 da             	mov    %rbx,%rdx
  80192a:	48 c1 ea 0c          	shr    $0xc,%rdx
  80192e:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801935:	7f 00 00 
  801938:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  80193c:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801942:	f6 c4 04             	test   $0x4,%ah
  801945:	74 11                	je     801958 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  801947:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  80194b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80194f:	48 89 df             	mov    %rbx,%rdi
  801952:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801956:	ff d0                	call   *%rax
    next:
        va += size;
  801958:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  80195b:	49 39 df             	cmp    %rbx,%r15
  80195e:	72 3e                	jb     80199e <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  801960:	49 8b 06             	mov    (%r14),%rax
  801963:	a8 01                	test   $0x1,%al
  801965:	74 37                	je     80199e <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801967:	48 89 d8             	mov    %rbx,%rax
  80196a:	48 c1 e8 1e          	shr    $0x1e,%rax
  80196e:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  801973:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801979:	f6 c2 01             	test   $0x1,%dl
  80197c:	74 da                	je     801958 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  80197e:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  801983:	f6 c2 80             	test   $0x80,%dl
  801986:	0f 84 61 ff ff ff    	je     8018ed <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  80198c:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  801991:	f6 c4 04             	test   $0x4,%ah
  801994:	74 c2                	je     801958 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  801996:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  80199c:	eb a9                	jmp    801947 <foreach_shared_region+0x9c>
    }
    return res;
}
  80199e:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a3:	48 83 c4 18          	add    $0x18,%rsp
  8019a7:	5b                   	pop    %rbx
  8019a8:	41 5c                	pop    %r12
  8019aa:	41 5d                	pop    %r13
  8019ac:	41 5e                	pop    %r14
  8019ae:	41 5f                	pop    %r15
  8019b0:	5d                   	pop    %rbp
  8019b1:	c3                   	ret

00000000008019b2 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  8019b2:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  8019b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bb:	c3                   	ret

00000000008019bc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8019bc:	f3 0f 1e fa          	endbr64
  8019c0:	55                   	push   %rbp
  8019c1:	48 89 e5             	mov    %rsp,%rbp
  8019c4:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8019c7:	48 be aa 30 80 00 00 	movabs $0x8030aa,%rsi
  8019ce:	00 00 00 
  8019d1:	48 b8 a2 26 80 00 00 	movabs $0x8026a2,%rax
  8019d8:	00 00 00 
  8019db:	ff d0                	call   *%rax
    return 0;
}
  8019dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e2:	5d                   	pop    %rbp
  8019e3:	c3                   	ret

00000000008019e4 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8019e4:	f3 0f 1e fa          	endbr64
  8019e8:	55                   	push   %rbp
  8019e9:	48 89 e5             	mov    %rsp,%rbp
  8019ec:	41 57                	push   %r15
  8019ee:	41 56                	push   %r14
  8019f0:	41 55                	push   %r13
  8019f2:	41 54                	push   %r12
  8019f4:	53                   	push   %rbx
  8019f5:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8019fc:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  801a03:	48 85 d2             	test   %rdx,%rdx
  801a06:	74 7a                	je     801a82 <devcons_write+0x9e>
  801a08:	49 89 d6             	mov    %rdx,%r14
  801a0b:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a11:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  801a16:	49 bf bd 28 80 00 00 	movabs $0x8028bd,%r15
  801a1d:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  801a20:	4c 89 f3             	mov    %r14,%rbx
  801a23:	48 29 f3             	sub    %rsi,%rbx
  801a26:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a2b:	48 39 c3             	cmp    %rax,%rbx
  801a2e:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801a32:	4c 63 eb             	movslq %ebx,%r13
  801a35:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801a3c:	48 01 c6             	add    %rax,%rsi
  801a3f:	4c 89 ea             	mov    %r13,%rdx
  801a42:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a49:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  801a4c:	4c 89 ee             	mov    %r13,%rsi
  801a4f:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a56:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  801a5d:	00 00 00 
  801a60:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801a62:	41 01 dc             	add    %ebx,%r12d
  801a65:	49 63 f4             	movslq %r12d,%rsi
  801a68:	4c 39 f6             	cmp    %r14,%rsi
  801a6b:	72 b3                	jb     801a20 <devcons_write+0x3c>
    return res;
  801a6d:	49 63 c4             	movslq %r12d,%rax
}
  801a70:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801a77:	5b                   	pop    %rbx
  801a78:	41 5c                	pop    %r12
  801a7a:	41 5d                	pop    %r13
  801a7c:	41 5e                	pop    %r14
  801a7e:	41 5f                	pop    %r15
  801a80:	5d                   	pop    %rbp
  801a81:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  801a82:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a88:	eb e3                	jmp    801a6d <devcons_write+0x89>

0000000000801a8a <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a8a:	f3 0f 1e fa          	endbr64
  801a8e:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801a91:	ba 00 00 00 00       	mov    $0x0,%edx
  801a96:	48 85 c0             	test   %rax,%rax
  801a99:	74 55                	je     801af0 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a9b:	55                   	push   %rbp
  801a9c:	48 89 e5             	mov    %rsp,%rbp
  801a9f:	41 55                	push   %r13
  801aa1:	41 54                	push   %r12
  801aa3:	53                   	push   %rbx
  801aa4:	48 83 ec 08          	sub    $0x8,%rsp
  801aa8:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801aab:	48 bb 5e 01 80 00 00 	movabs $0x80015e,%rbx
  801ab2:	00 00 00 
  801ab5:	49 bc 37 02 80 00 00 	movabs $0x800237,%r12
  801abc:	00 00 00 
  801abf:	eb 03                	jmp    801ac4 <devcons_read+0x3a>
  801ac1:	41 ff d4             	call   *%r12
  801ac4:	ff d3                	call   *%rbx
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	74 f7                	je     801ac1 <devcons_read+0x37>
    if (c < 0) return c;
  801aca:	48 63 d0             	movslq %eax,%rdx
  801acd:	78 13                	js     801ae2 <devcons_read+0x58>
    if (c == 0x04) return 0;
  801acf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad4:	83 f8 04             	cmp    $0x4,%eax
  801ad7:	74 09                	je     801ae2 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  801ad9:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801add:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801ae2:	48 89 d0             	mov    %rdx,%rax
  801ae5:	48 83 c4 08          	add    $0x8,%rsp
  801ae9:	5b                   	pop    %rbx
  801aea:	41 5c                	pop    %r12
  801aec:	41 5d                	pop    %r13
  801aee:	5d                   	pop    %rbp
  801aef:	c3                   	ret
  801af0:	48 89 d0             	mov    %rdx,%rax
  801af3:	c3                   	ret

0000000000801af4 <cputchar>:
cputchar(int ch) {
  801af4:	f3 0f 1e fa          	endbr64
  801af8:	55                   	push   %rbp
  801af9:	48 89 e5             	mov    %rsp,%rbp
  801afc:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801b00:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801b04:	be 01 00 00 00       	mov    $0x1,%esi
  801b09:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801b0d:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  801b14:	00 00 00 
  801b17:	ff d0                	call   *%rax
}
  801b19:	c9                   	leave
  801b1a:	c3                   	ret

0000000000801b1b <getchar>:
getchar(void) {
  801b1b:	f3 0f 1e fa          	endbr64
  801b1f:	55                   	push   %rbp
  801b20:	48 89 e5             	mov    %rsp,%rbp
  801b23:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801b27:	ba 01 00 00 00       	mov    $0x1,%edx
  801b2c:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801b30:	bf 00 00 00 00       	mov    $0x0,%edi
  801b35:	48 b8 2b 0a 80 00 00 	movabs $0x800a2b,%rax
  801b3c:	00 00 00 
  801b3f:	ff d0                	call   *%rax
  801b41:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801b43:	85 c0                	test   %eax,%eax
  801b45:	78 06                	js     801b4d <getchar+0x32>
  801b47:	74 08                	je     801b51 <getchar+0x36>
  801b49:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  801b4d:	89 d0                	mov    %edx,%eax
  801b4f:	c9                   	leave
  801b50:	c3                   	ret
    return res < 0 ? res : res ? c :
  801b51:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801b56:	eb f5                	jmp    801b4d <getchar+0x32>

0000000000801b58 <iscons>:
iscons(int fdnum) {
  801b58:	f3 0f 1e fa          	endbr64
  801b5c:	55                   	push   %rbp
  801b5d:	48 89 e5             	mov    %rsp,%rbp
  801b60:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801b64:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b68:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  801b6f:	00 00 00 
  801b72:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b74:	85 c0                	test   %eax,%eax
  801b76:	78 18                	js     801b90 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  801b78:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b7c:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801b83:	00 00 00 
  801b86:	8b 00                	mov    (%rax),%eax
  801b88:	39 02                	cmp    %eax,(%rdx)
  801b8a:	0f 94 c0             	sete   %al
  801b8d:	0f b6 c0             	movzbl %al,%eax
}
  801b90:	c9                   	leave
  801b91:	c3                   	ret

0000000000801b92 <opencons>:
opencons(void) {
  801b92:	f3 0f 1e fa          	endbr64
  801b96:	55                   	push   %rbp
  801b97:	48 89 e5             	mov    %rsp,%rbp
  801b9a:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801b9e:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801ba2:	48 b8 cc 06 80 00 00 	movabs $0x8006cc,%rax
  801ba9:	00 00 00 
  801bac:	ff d0                	call   *%rax
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	78 49                	js     801bfb <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801bb2:	b9 46 00 00 00       	mov    $0x46,%ecx
  801bb7:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bbc:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801bc0:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc5:	48 b8 d2 02 80 00 00 	movabs $0x8002d2,%rax
  801bcc:	00 00 00 
  801bcf:	ff d0                	call   *%rax
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	78 26                	js     801bfb <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  801bd5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bd9:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801be0:	00 00 
  801be2:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801be4:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801be8:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801bef:	48 b8 96 06 80 00 00 	movabs $0x800696,%rax
  801bf6:	00 00 00 
  801bf9:	ff d0                	call   *%rax
}
  801bfb:	c9                   	leave
  801bfc:	c3                   	ret

0000000000801bfd <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801bfd:	f3 0f 1e fa          	endbr64
  801c01:	55                   	push   %rbp
  801c02:	48 89 e5             	mov    %rsp,%rbp
  801c05:	41 56                	push   %r14
  801c07:	41 55                	push   %r13
  801c09:	41 54                	push   %r12
  801c0b:	53                   	push   %rbx
  801c0c:	48 83 ec 50          	sub    $0x50,%rsp
  801c10:	49 89 fc             	mov    %rdi,%r12
  801c13:	41 89 f5             	mov    %esi,%r13d
  801c16:	48 89 d3             	mov    %rdx,%rbx
  801c19:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c1d:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801c21:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801c25:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801c2c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c30:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801c34:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801c38:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801c3c:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801c43:	00 00 00 
  801c46:	4c 8b 30             	mov    (%rax),%r14
  801c49:	48 b8 02 02 80 00 00 	movabs $0x800202,%rax
  801c50:	00 00 00 
  801c53:	ff d0                	call   *%rax
  801c55:	89 c6                	mov    %eax,%esi
  801c57:	45 89 e8             	mov    %r13d,%r8d
  801c5a:	4c 89 e1             	mov    %r12,%rcx
  801c5d:	4c 89 f2             	mov    %r14,%rdx
  801c60:	48 bf f0 32 80 00 00 	movabs $0x8032f0,%rdi
  801c67:	00 00 00 
  801c6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6f:	49 bc 59 1d 80 00 00 	movabs $0x801d59,%r12
  801c76:	00 00 00 
  801c79:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801c7c:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801c80:	48 89 df             	mov    %rbx,%rdi
  801c83:	48 b8 f1 1c 80 00 00 	movabs $0x801cf1,%rax
  801c8a:	00 00 00 
  801c8d:	ff d0                	call   *%rax
    cprintf("\n");
  801c8f:	48 bf 37 30 80 00 00 	movabs $0x803037,%rdi
  801c96:	00 00 00 
  801c99:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9e:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801ca1:	cc                   	int3
  801ca2:	eb fd                	jmp    801ca1 <_panic+0xa4>

0000000000801ca4 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801ca4:	f3 0f 1e fa          	endbr64
  801ca8:	55                   	push   %rbp
  801ca9:	48 89 e5             	mov    %rsp,%rbp
  801cac:	53                   	push   %rbx
  801cad:	48 83 ec 08          	sub    $0x8,%rsp
  801cb1:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801cb4:	8b 06                	mov    (%rsi),%eax
  801cb6:	8d 50 01             	lea    0x1(%rax),%edx
  801cb9:	89 16                	mov    %edx,(%rsi)
  801cbb:	48 98                	cltq
  801cbd:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801cc2:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801cc8:	74 0a                	je     801cd4 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801cca:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801cce:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cd2:	c9                   	leave
  801cd3:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  801cd4:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801cd8:	be ff 00 00 00       	mov    $0xff,%esi
  801cdd:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  801ce4:	00 00 00 
  801ce7:	ff d0                	call   *%rax
        state->offset = 0;
  801ce9:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801cef:	eb d9                	jmp    801cca <putch+0x26>

0000000000801cf1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801cf1:	f3 0f 1e fa          	endbr64
  801cf5:	55                   	push   %rbp
  801cf6:	48 89 e5             	mov    %rsp,%rbp
  801cf9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801d00:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801d03:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801d0a:	b9 21 00 00 00       	mov    $0x21,%ecx
  801d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d14:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801d17:	48 89 f1             	mov    %rsi,%rcx
  801d1a:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801d21:	48 bf a4 1c 80 00 00 	movabs $0x801ca4,%rdi
  801d28:	00 00 00 
  801d2b:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  801d32:	00 00 00 
  801d35:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801d37:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801d3e:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801d45:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  801d4c:	00 00 00 
  801d4f:	ff d0                	call   *%rax

    return state.count;
}
  801d51:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801d57:	c9                   	leave
  801d58:	c3                   	ret

0000000000801d59 <cprintf>:

int
cprintf(const char *fmt, ...) {
  801d59:	f3 0f 1e fa          	endbr64
  801d5d:	55                   	push   %rbp
  801d5e:	48 89 e5             	mov    %rsp,%rbp
  801d61:	48 83 ec 50          	sub    $0x50,%rsp
  801d65:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801d69:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801d6d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d71:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801d75:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801d79:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801d80:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d84:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d88:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801d8c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801d90:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801d94:	48 b8 f1 1c 80 00 00 	movabs $0x801cf1,%rax
  801d9b:	00 00 00 
  801d9e:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801da0:	c9                   	leave
  801da1:	c3                   	ret

0000000000801da2 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801da2:	f3 0f 1e fa          	endbr64
  801da6:	55                   	push   %rbp
  801da7:	48 89 e5             	mov    %rsp,%rbp
  801daa:	41 57                	push   %r15
  801dac:	41 56                	push   %r14
  801dae:	41 55                	push   %r13
  801db0:	41 54                	push   %r12
  801db2:	53                   	push   %rbx
  801db3:	48 83 ec 18          	sub    $0x18,%rsp
  801db7:	49 89 fc             	mov    %rdi,%r12
  801dba:	49 89 f5             	mov    %rsi,%r13
  801dbd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801dc1:	8b 45 10             	mov    0x10(%rbp),%eax
  801dc4:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801dc7:	41 89 cf             	mov    %ecx,%r15d
  801dca:	4c 39 fa             	cmp    %r15,%rdx
  801dcd:	73 5b                	jae    801e2a <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801dcf:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801dd3:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801dd7:	85 db                	test   %ebx,%ebx
  801dd9:	7e 0e                	jle    801de9 <print_num+0x47>
            putch(padc, put_arg);
  801ddb:	4c 89 ee             	mov    %r13,%rsi
  801dde:	44 89 f7             	mov    %r14d,%edi
  801de1:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801de4:	83 eb 01             	sub    $0x1,%ebx
  801de7:	75 f2                	jne    801ddb <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801de9:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801ded:	48 b9 c7 30 80 00 00 	movabs $0x8030c7,%rcx
  801df4:	00 00 00 
  801df7:	48 b8 b6 30 80 00 00 	movabs $0x8030b6,%rax
  801dfe:	00 00 00 
  801e01:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801e05:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e09:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0e:	49 f7 f7             	div    %r15
  801e11:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801e15:	4c 89 ee             	mov    %r13,%rsi
  801e18:	41 ff d4             	call   *%r12
}
  801e1b:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801e1f:	5b                   	pop    %rbx
  801e20:	41 5c                	pop    %r12
  801e22:	41 5d                	pop    %r13
  801e24:	41 5e                	pop    %r14
  801e26:	41 5f                	pop    %r15
  801e28:	5d                   	pop    %rbp
  801e29:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801e2a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e33:	49 f7 f7             	div    %r15
  801e36:	48 83 ec 08          	sub    $0x8,%rsp
  801e3a:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801e3e:	52                   	push   %rdx
  801e3f:	45 0f be c9          	movsbl %r9b,%r9d
  801e43:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801e47:	48 89 c2             	mov    %rax,%rdx
  801e4a:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  801e51:	00 00 00 
  801e54:	ff d0                	call   *%rax
  801e56:	48 83 c4 10          	add    $0x10,%rsp
  801e5a:	eb 8d                	jmp    801de9 <print_num+0x47>

0000000000801e5c <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  801e5c:	f3 0f 1e fa          	endbr64
    state->count++;
  801e60:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801e64:	48 8b 06             	mov    (%rsi),%rax
  801e67:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801e6b:	73 0a                	jae    801e77 <sprintputch+0x1b>
        *state->start++ = ch;
  801e6d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e71:	48 89 16             	mov    %rdx,(%rsi)
  801e74:	40 88 38             	mov    %dil,(%rax)
    }
}
  801e77:	c3                   	ret

0000000000801e78 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801e78:	f3 0f 1e fa          	endbr64
  801e7c:	55                   	push   %rbp
  801e7d:	48 89 e5             	mov    %rsp,%rbp
  801e80:	48 83 ec 50          	sub    $0x50,%rsp
  801e84:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e88:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801e8c:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801e90:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801e97:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e9b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e9f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801ea3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801ea7:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801eab:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  801eb2:	00 00 00 
  801eb5:	ff d0                	call   *%rax
}
  801eb7:	c9                   	leave
  801eb8:	c3                   	ret

0000000000801eb9 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801eb9:	f3 0f 1e fa          	endbr64
  801ebd:	55                   	push   %rbp
  801ebe:	48 89 e5             	mov    %rsp,%rbp
  801ec1:	41 57                	push   %r15
  801ec3:	41 56                	push   %r14
  801ec5:	41 55                	push   %r13
  801ec7:	41 54                	push   %r12
  801ec9:	53                   	push   %rbx
  801eca:	48 83 ec 38          	sub    $0x38,%rsp
  801ece:	49 89 fe             	mov    %rdi,%r14
  801ed1:	49 89 f5             	mov    %rsi,%r13
  801ed4:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  801ed7:	48 8b 01             	mov    (%rcx),%rax
  801eda:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801ede:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801ee2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ee6:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801eea:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801eee:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  801ef2:	0f b6 3b             	movzbl (%rbx),%edi
  801ef5:	40 80 ff 25          	cmp    $0x25,%dil
  801ef9:	74 18                	je     801f13 <vprintfmt+0x5a>
            if (!ch) return;
  801efb:	40 84 ff             	test   %dil,%dil
  801efe:	0f 84 b2 06 00 00    	je     8025b6 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  801f04:	40 0f b6 ff          	movzbl %dil,%edi
  801f08:	4c 89 ee             	mov    %r13,%rsi
  801f0b:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  801f0e:	4c 89 e3             	mov    %r12,%rbx
  801f11:	eb db                	jmp    801eee <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  801f13:	be 00 00 00 00       	mov    $0x0,%esi
  801f18:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  801f1c:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801f21:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f27:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801f2e:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f32:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  801f37:	41 0f b6 04 24       	movzbl (%r12),%eax
  801f3c:	88 45 a0             	mov    %al,-0x60(%rbp)
  801f3f:	83 e8 23             	sub    $0x23,%eax
  801f42:	3c 57                	cmp    $0x57,%al
  801f44:	0f 87 52 06 00 00    	ja     80259c <vprintfmt+0x6e3>
  801f4a:	0f b6 c0             	movzbl %al,%eax
  801f4d:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  801f54:	00 00 00 
  801f57:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  801f5b:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  801f5e:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  801f62:	eb ce                	jmp    801f32 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  801f64:	49 89 dc             	mov    %rbx,%r12
  801f67:	be 01 00 00 00       	mov    $0x1,%esi
  801f6c:	eb c4                	jmp    801f32 <vprintfmt+0x79>
            padc = ch;
  801f6e:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  801f72:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f75:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801f78:	eb b8                	jmp    801f32 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f7a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f7d:	83 f8 2f             	cmp    $0x2f,%eax
  801f80:	77 24                	ja     801fa6 <vprintfmt+0xed>
  801f82:	89 c1                	mov    %eax,%ecx
  801f84:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  801f88:	83 c0 08             	add    $0x8,%eax
  801f8b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f8e:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  801f91:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  801f94:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801f98:	79 98                	jns    801f32 <vprintfmt+0x79>
                width = precision;
  801f9a:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  801f9e:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801fa4:	eb 8c                	jmp    801f32 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801fa6:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801faa:	48 8d 41 08          	lea    0x8(%rcx),%rax
  801fae:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fb2:	eb da                	jmp    801f8e <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  801fb4:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  801fb9:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fbd:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  801fc3:	3c 39                	cmp    $0x39,%al
  801fc5:	77 1c                	ja     801fe3 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  801fc7:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  801fcb:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  801fcf:	0f b6 c0             	movzbl %al,%eax
  801fd2:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fd7:	0f b6 03             	movzbl (%rbx),%eax
  801fda:	3c 39                	cmp    $0x39,%al
  801fdc:	76 e9                	jbe    801fc7 <vprintfmt+0x10e>
        process_precision:
  801fde:	49 89 dc             	mov    %rbx,%r12
  801fe1:	eb b1                	jmp    801f94 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  801fe3:	49 89 dc             	mov    %rbx,%r12
  801fe6:	eb ac                	jmp    801f94 <vprintfmt+0xdb>
            width = MAX(0, width);
  801fe8:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  801feb:	85 c9                	test   %ecx,%ecx
  801fed:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff2:	0f 49 c1             	cmovns %ecx,%eax
  801ff5:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801ff8:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801ffb:	e9 32 ff ff ff       	jmp    801f32 <vprintfmt+0x79>
            lflag++;
  802000:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  802003:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  802006:	e9 27 ff ff ff       	jmp    801f32 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  80200b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80200e:	83 f8 2f             	cmp    $0x2f,%eax
  802011:	77 19                	ja     80202c <vprintfmt+0x173>
  802013:	89 c2                	mov    %eax,%edx
  802015:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802019:	83 c0 08             	add    $0x8,%eax
  80201c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80201f:	8b 3a                	mov    (%rdx),%edi
  802021:	4c 89 ee             	mov    %r13,%rsi
  802024:	41 ff d6             	call   *%r14
            break;
  802027:	e9 c2 fe ff ff       	jmp    801eee <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  80202c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802030:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802034:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802038:	eb e5                	jmp    80201f <vprintfmt+0x166>
            int err = va_arg(aq, int);
  80203a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80203d:	83 f8 2f             	cmp    $0x2f,%eax
  802040:	77 5a                	ja     80209c <vprintfmt+0x1e3>
  802042:	89 c2                	mov    %eax,%edx
  802044:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802048:	83 c0 08             	add    $0x8,%eax
  80204b:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  80204e:	8b 02                	mov    (%rdx),%eax
  802050:	89 c1                	mov    %eax,%ecx
  802052:	f7 d9                	neg    %ecx
  802054:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  802057:	83 f9 13             	cmp    $0x13,%ecx
  80205a:	7f 4e                	jg     8020aa <vprintfmt+0x1f1>
  80205c:	48 63 c1             	movslq %ecx,%rax
  80205f:	48 ba 20 36 80 00 00 	movabs $0x803620,%rdx
  802066:	00 00 00 
  802069:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80206d:	48 85 c0             	test   %rax,%rax
  802070:	74 38                	je     8020aa <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  802072:	48 89 c1             	mov    %rax,%rcx
  802075:	48 ba 85 30 80 00 00 	movabs $0x803085,%rdx
  80207c:	00 00 00 
  80207f:	4c 89 ee             	mov    %r13,%rsi
  802082:	4c 89 f7             	mov    %r14,%rdi
  802085:	b8 00 00 00 00       	mov    $0x0,%eax
  80208a:	49 b8 78 1e 80 00 00 	movabs $0x801e78,%r8
  802091:	00 00 00 
  802094:	41 ff d0             	call   *%r8
  802097:	e9 52 fe ff ff       	jmp    801eee <vprintfmt+0x35>
            int err = va_arg(aq, int);
  80209c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8020a0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8020a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8020a8:	eb a4                	jmp    80204e <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8020aa:	48 ba df 30 80 00 00 	movabs $0x8030df,%rdx
  8020b1:	00 00 00 
  8020b4:	4c 89 ee             	mov    %r13,%rsi
  8020b7:	4c 89 f7             	mov    %r14,%rdi
  8020ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bf:	49 b8 78 1e 80 00 00 	movabs $0x801e78,%r8
  8020c6:	00 00 00 
  8020c9:	41 ff d0             	call   *%r8
  8020cc:	e9 1d fe ff ff       	jmp    801eee <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8020d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020d4:	83 f8 2f             	cmp    $0x2f,%eax
  8020d7:	77 6c                	ja     802145 <vprintfmt+0x28c>
  8020d9:	89 c2                	mov    %eax,%edx
  8020db:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8020df:	83 c0 08             	add    $0x8,%eax
  8020e2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020e5:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8020e8:	48 85 d2             	test   %rdx,%rdx
  8020eb:	48 b8 d8 30 80 00 00 	movabs $0x8030d8,%rax
  8020f2:	00 00 00 
  8020f5:	48 0f 45 c2          	cmovne %rdx,%rax
  8020f9:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8020fd:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  802101:	7e 06                	jle    802109 <vprintfmt+0x250>
  802103:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  802107:	75 4a                	jne    802153 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802109:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80210d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802111:	0f b6 00             	movzbl (%rax),%eax
  802114:	84 c0                	test   %al,%al
  802116:	0f 85 9a 00 00 00    	jne    8021b6 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  80211c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80211f:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  802123:	85 c0                	test   %eax,%eax
  802125:	0f 8e c3 fd ff ff    	jle    801eee <vprintfmt+0x35>
  80212b:	4c 89 ee             	mov    %r13,%rsi
  80212e:	bf 20 00 00 00       	mov    $0x20,%edi
  802133:	41 ff d6             	call   *%r14
  802136:	41 83 ec 01          	sub    $0x1,%r12d
  80213a:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  80213e:	75 eb                	jne    80212b <vprintfmt+0x272>
  802140:	e9 a9 fd ff ff       	jmp    801eee <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  802145:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802149:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80214d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802151:	eb 92                	jmp    8020e5 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  802153:	49 63 f7             	movslq %r15d,%rsi
  802156:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80215a:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  802161:	00 00 00 
  802164:	ff d0                	call   *%rax
  802166:	48 89 c2             	mov    %rax,%rdx
  802169:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80216c:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80216e:	8d 70 ff             	lea    -0x1(%rax),%esi
  802171:	89 75 ac             	mov    %esi,-0x54(%rbp)
  802174:	85 c0                	test   %eax,%eax
  802176:	7e 91                	jle    802109 <vprintfmt+0x250>
  802178:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80217d:	4c 89 ee             	mov    %r13,%rsi
  802180:	44 89 e7             	mov    %r12d,%edi
  802183:	41 ff d6             	call   *%r14
  802186:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80218a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80218d:	83 f8 ff             	cmp    $0xffffffff,%eax
  802190:	75 eb                	jne    80217d <vprintfmt+0x2c4>
  802192:	e9 72 ff ff ff       	jmp    802109 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  802197:	0f b6 f8             	movzbl %al,%edi
  80219a:	4c 89 ee             	mov    %r13,%rsi
  80219d:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8021a0:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8021a4:	49 83 c4 01          	add    $0x1,%r12
  8021a8:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  8021ae:	84 c0                	test   %al,%al
  8021b0:	0f 84 66 ff ff ff    	je     80211c <vprintfmt+0x263>
  8021b6:	45 85 ff             	test   %r15d,%r15d
  8021b9:	78 0a                	js     8021c5 <vprintfmt+0x30c>
  8021bb:	41 83 ef 01          	sub    $0x1,%r15d
  8021bf:	0f 88 57 ff ff ff    	js     80211c <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8021c5:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8021c9:	74 cc                	je     802197 <vprintfmt+0x2de>
  8021cb:	8d 50 e0             	lea    -0x20(%rax),%edx
  8021ce:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8021d3:	80 fa 5e             	cmp    $0x5e,%dl
  8021d6:	77 c2                	ja     80219a <vprintfmt+0x2e1>
  8021d8:	eb bd                	jmp    802197 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8021da:	40 84 f6             	test   %sil,%sil
  8021dd:	75 26                	jne    802205 <vprintfmt+0x34c>
    switch (lflag) {
  8021df:	85 d2                	test   %edx,%edx
  8021e1:	74 59                	je     80223c <vprintfmt+0x383>
  8021e3:	83 fa 01             	cmp    $0x1,%edx
  8021e6:	74 7b                	je     802263 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8021e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021eb:	83 f8 2f             	cmp    $0x2f,%eax
  8021ee:	0f 87 96 00 00 00    	ja     80228a <vprintfmt+0x3d1>
  8021f4:	89 c2                	mov    %eax,%edx
  8021f6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021fa:	83 c0 08             	add    $0x8,%eax
  8021fd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802200:	4c 8b 22             	mov    (%rdx),%r12
  802203:	eb 17                	jmp    80221c <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  802205:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802208:	83 f8 2f             	cmp    $0x2f,%eax
  80220b:	77 21                	ja     80222e <vprintfmt+0x375>
  80220d:	89 c2                	mov    %eax,%edx
  80220f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802213:	83 c0 08             	add    $0x8,%eax
  802216:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802219:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  80221c:	4d 85 e4             	test   %r12,%r12
  80221f:	78 7a                	js     80229b <vprintfmt+0x3e2>
            num = i;
  802221:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  802224:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  802229:	e9 50 02 00 00       	jmp    80247e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80222e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802232:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802236:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80223a:	eb dd                	jmp    802219 <vprintfmt+0x360>
        return va_arg(*ap, int);
  80223c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80223f:	83 f8 2f             	cmp    $0x2f,%eax
  802242:	77 11                	ja     802255 <vprintfmt+0x39c>
  802244:	89 c2                	mov    %eax,%edx
  802246:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80224a:	83 c0 08             	add    $0x8,%eax
  80224d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802250:	4c 63 22             	movslq (%rdx),%r12
  802253:	eb c7                	jmp    80221c <vprintfmt+0x363>
  802255:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802259:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80225d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802261:	eb ed                	jmp    802250 <vprintfmt+0x397>
        return va_arg(*ap, long);
  802263:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802266:	83 f8 2f             	cmp    $0x2f,%eax
  802269:	77 11                	ja     80227c <vprintfmt+0x3c3>
  80226b:	89 c2                	mov    %eax,%edx
  80226d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802271:	83 c0 08             	add    $0x8,%eax
  802274:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802277:	4c 8b 22             	mov    (%rdx),%r12
  80227a:	eb a0                	jmp    80221c <vprintfmt+0x363>
  80227c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802280:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802284:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802288:	eb ed                	jmp    802277 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  80228a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80228e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802292:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802296:	e9 65 ff ff ff       	jmp    802200 <vprintfmt+0x347>
                putch('-', put_arg);
  80229b:	4c 89 ee             	mov    %r13,%rsi
  80229e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8022a3:	41 ff d6             	call   *%r14
                i = -i;
  8022a6:	49 f7 dc             	neg    %r12
  8022a9:	e9 73 ff ff ff       	jmp    802221 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  8022ae:	40 84 f6             	test   %sil,%sil
  8022b1:	75 32                	jne    8022e5 <vprintfmt+0x42c>
    switch (lflag) {
  8022b3:	85 d2                	test   %edx,%edx
  8022b5:	74 5d                	je     802314 <vprintfmt+0x45b>
  8022b7:	83 fa 01             	cmp    $0x1,%edx
  8022ba:	0f 84 82 00 00 00    	je     802342 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8022c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022c3:	83 f8 2f             	cmp    $0x2f,%eax
  8022c6:	0f 87 a5 00 00 00    	ja     802371 <vprintfmt+0x4b8>
  8022cc:	89 c2                	mov    %eax,%edx
  8022ce:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022d2:	83 c0 08             	add    $0x8,%eax
  8022d5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022d8:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022db:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8022e0:	e9 99 01 00 00       	jmp    80247e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8022e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022e8:	83 f8 2f             	cmp    $0x2f,%eax
  8022eb:	77 19                	ja     802306 <vprintfmt+0x44d>
  8022ed:	89 c2                	mov    %eax,%edx
  8022ef:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022f3:	83 c0 08             	add    $0x8,%eax
  8022f6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022f9:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802301:	e9 78 01 00 00       	jmp    80247e <vprintfmt+0x5c5>
  802306:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80230a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80230e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802312:	eb e5                	jmp    8022f9 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  802314:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802317:	83 f8 2f             	cmp    $0x2f,%eax
  80231a:	77 18                	ja     802334 <vprintfmt+0x47b>
  80231c:	89 c2                	mov    %eax,%edx
  80231e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802322:	83 c0 08             	add    $0x8,%eax
  802325:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802328:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  80232a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  80232f:	e9 4a 01 00 00       	jmp    80247e <vprintfmt+0x5c5>
  802334:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802338:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80233c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802340:	eb e6                	jmp    802328 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  802342:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802345:	83 f8 2f             	cmp    $0x2f,%eax
  802348:	77 19                	ja     802363 <vprintfmt+0x4aa>
  80234a:	89 c2                	mov    %eax,%edx
  80234c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802350:	83 c0 08             	add    $0x8,%eax
  802353:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802356:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  802359:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80235e:	e9 1b 01 00 00       	jmp    80247e <vprintfmt+0x5c5>
  802363:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802367:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80236b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80236f:	eb e5                	jmp    802356 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  802371:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802375:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802379:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80237d:	e9 56 ff ff ff       	jmp    8022d8 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  802382:	40 84 f6             	test   %sil,%sil
  802385:	75 2e                	jne    8023b5 <vprintfmt+0x4fc>
    switch (lflag) {
  802387:	85 d2                	test   %edx,%edx
  802389:	74 59                	je     8023e4 <vprintfmt+0x52b>
  80238b:	83 fa 01             	cmp    $0x1,%edx
  80238e:	74 7f                	je     80240f <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  802390:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802393:	83 f8 2f             	cmp    $0x2f,%eax
  802396:	0f 87 9f 00 00 00    	ja     80243b <vprintfmt+0x582>
  80239c:	89 c2                	mov    %eax,%edx
  80239e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023a2:	83 c0 08             	add    $0x8,%eax
  8023a5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023a8:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023ab:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8023b0:	e9 c9 00 00 00       	jmp    80247e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8023b5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023b8:	83 f8 2f             	cmp    $0x2f,%eax
  8023bb:	77 19                	ja     8023d6 <vprintfmt+0x51d>
  8023bd:	89 c2                	mov    %eax,%edx
  8023bf:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023c3:	83 c0 08             	add    $0x8,%eax
  8023c6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023c9:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023cc:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8023d1:	e9 a8 00 00 00       	jmp    80247e <vprintfmt+0x5c5>
  8023d6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023da:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023de:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023e2:	eb e5                	jmp    8023c9 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8023e4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023e7:	83 f8 2f             	cmp    $0x2f,%eax
  8023ea:	77 15                	ja     802401 <vprintfmt+0x548>
  8023ec:	89 c2                	mov    %eax,%edx
  8023ee:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023f2:	83 c0 08             	add    $0x8,%eax
  8023f5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023f8:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8023fa:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8023ff:	eb 7d                	jmp    80247e <vprintfmt+0x5c5>
  802401:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802405:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802409:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80240d:	eb e9                	jmp    8023f8 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  80240f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802412:	83 f8 2f             	cmp    $0x2f,%eax
  802415:	77 16                	ja     80242d <vprintfmt+0x574>
  802417:	89 c2                	mov    %eax,%edx
  802419:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80241d:	83 c0 08             	add    $0x8,%eax
  802420:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802423:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  802426:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  80242b:	eb 51                	jmp    80247e <vprintfmt+0x5c5>
  80242d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802431:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802435:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802439:	eb e8                	jmp    802423 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  80243b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80243f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802443:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802447:	e9 5c ff ff ff       	jmp    8023a8 <vprintfmt+0x4ef>
            putch('0', put_arg);
  80244c:	4c 89 ee             	mov    %r13,%rsi
  80244f:	bf 30 00 00 00       	mov    $0x30,%edi
  802454:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  802457:	4c 89 ee             	mov    %r13,%rsi
  80245a:	bf 78 00 00 00       	mov    $0x78,%edi
  80245f:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  802462:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802465:	83 f8 2f             	cmp    $0x2f,%eax
  802468:	77 47                	ja     8024b1 <vprintfmt+0x5f8>
  80246a:	89 c2                	mov    %eax,%edx
  80246c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802470:	83 c0 08             	add    $0x8,%eax
  802473:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802476:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802479:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80247e:	48 83 ec 08          	sub    $0x8,%rsp
  802482:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  802486:	0f 94 c0             	sete   %al
  802489:	0f b6 c0             	movzbl %al,%eax
  80248c:	50                   	push   %rax
  80248d:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  802492:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  802496:	4c 89 ee             	mov    %r13,%rsi
  802499:	4c 89 f7             	mov    %r14,%rdi
  80249c:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  8024a3:	00 00 00 
  8024a6:	ff d0                	call   *%rax
            break;
  8024a8:	48 83 c4 10          	add    $0x10,%rsp
  8024ac:	e9 3d fa ff ff       	jmp    801eee <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  8024b1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024b5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8024b9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024bd:	eb b7                	jmp    802476 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  8024bf:	40 84 f6             	test   %sil,%sil
  8024c2:	75 2b                	jne    8024ef <vprintfmt+0x636>
    switch (lflag) {
  8024c4:	85 d2                	test   %edx,%edx
  8024c6:	74 56                	je     80251e <vprintfmt+0x665>
  8024c8:	83 fa 01             	cmp    $0x1,%edx
  8024cb:	74 7f                	je     80254c <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  8024cd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024d0:	83 f8 2f             	cmp    $0x2f,%eax
  8024d3:	0f 87 a2 00 00 00    	ja     80257b <vprintfmt+0x6c2>
  8024d9:	89 c2                	mov    %eax,%edx
  8024db:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024df:	83 c0 08             	add    $0x8,%eax
  8024e2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024e5:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024e8:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8024ed:	eb 8f                	jmp    80247e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8024ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024f2:	83 f8 2f             	cmp    $0x2f,%eax
  8024f5:	77 19                	ja     802510 <vprintfmt+0x657>
  8024f7:	89 c2                	mov    %eax,%edx
  8024f9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024fd:	83 c0 08             	add    $0x8,%eax
  802500:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802503:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802506:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80250b:	e9 6e ff ff ff       	jmp    80247e <vprintfmt+0x5c5>
  802510:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802514:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802518:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80251c:	eb e5                	jmp    802503 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  80251e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802521:	83 f8 2f             	cmp    $0x2f,%eax
  802524:	77 18                	ja     80253e <vprintfmt+0x685>
  802526:	89 c2                	mov    %eax,%edx
  802528:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80252c:	83 c0 08             	add    $0x8,%eax
  80252f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802532:	8b 12                	mov    (%rdx),%edx
            base = 16;
  802534:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  802539:	e9 40 ff ff ff       	jmp    80247e <vprintfmt+0x5c5>
  80253e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802542:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802546:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80254a:	eb e6                	jmp    802532 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  80254c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80254f:	83 f8 2f             	cmp    $0x2f,%eax
  802552:	77 19                	ja     80256d <vprintfmt+0x6b4>
  802554:	89 c2                	mov    %eax,%edx
  802556:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80255a:	83 c0 08             	add    $0x8,%eax
  80255d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802560:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802563:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  802568:	e9 11 ff ff ff       	jmp    80247e <vprintfmt+0x5c5>
  80256d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802571:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802575:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802579:	eb e5                	jmp    802560 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  80257b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80257f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802583:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802587:	e9 59 ff ff ff       	jmp    8024e5 <vprintfmt+0x62c>
            putch(ch, put_arg);
  80258c:	4c 89 ee             	mov    %r13,%rsi
  80258f:	bf 25 00 00 00       	mov    $0x25,%edi
  802594:	41 ff d6             	call   *%r14
            break;
  802597:	e9 52 f9 ff ff       	jmp    801eee <vprintfmt+0x35>
            putch('%', put_arg);
  80259c:	4c 89 ee             	mov    %r13,%rsi
  80259f:	bf 25 00 00 00       	mov    $0x25,%edi
  8025a4:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  8025a7:	48 83 eb 01          	sub    $0x1,%rbx
  8025ab:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  8025af:	75 f6                	jne    8025a7 <vprintfmt+0x6ee>
  8025b1:	e9 38 f9 ff ff       	jmp    801eee <vprintfmt+0x35>
}
  8025b6:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8025ba:	5b                   	pop    %rbx
  8025bb:	41 5c                	pop    %r12
  8025bd:	41 5d                	pop    %r13
  8025bf:	41 5e                	pop    %r14
  8025c1:	41 5f                	pop    %r15
  8025c3:	5d                   	pop    %rbp
  8025c4:	c3                   	ret

00000000008025c5 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  8025c5:	f3 0f 1e fa          	endbr64
  8025c9:	55                   	push   %rbp
  8025ca:	48 89 e5             	mov    %rsp,%rbp
  8025cd:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  8025d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025d5:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  8025da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8025de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8025e5:	48 85 ff             	test   %rdi,%rdi
  8025e8:	74 2b                	je     802615 <vsnprintf+0x50>
  8025ea:	48 85 f6             	test   %rsi,%rsi
  8025ed:	74 26                	je     802615 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8025ef:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8025f3:	48 bf 5c 1e 80 00 00 	movabs $0x801e5c,%rdi
  8025fa:	00 00 00 
  8025fd:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  802604:	00 00 00 
  802607:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  802609:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260d:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  802610:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802613:	c9                   	leave
  802614:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  802615:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80261a:	eb f7                	jmp    802613 <vsnprintf+0x4e>

000000000080261c <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  80261c:	f3 0f 1e fa          	endbr64
  802620:	55                   	push   %rbp
  802621:	48 89 e5             	mov    %rsp,%rbp
  802624:	48 83 ec 50          	sub    $0x50,%rsp
  802628:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80262c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802630:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802634:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80263b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80263f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802643:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802647:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  80264b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80264f:	48 b8 c5 25 80 00 00 	movabs $0x8025c5,%rax
  802656:	00 00 00 
  802659:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  80265b:	c9                   	leave
  80265c:	c3                   	ret

000000000080265d <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  80265d:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  802661:	80 3f 00             	cmpb   $0x0,(%rdi)
  802664:	74 10                	je     802676 <strlen+0x19>
    size_t n = 0;
  802666:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  80266b:	48 83 c0 01          	add    $0x1,%rax
  80266f:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  802673:	75 f6                	jne    80266b <strlen+0xe>
  802675:	c3                   	ret
    size_t n = 0;
  802676:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  80267b:	c3                   	ret

000000000080267c <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  80267c:	f3 0f 1e fa          	endbr64
  802680:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  802683:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  802688:	48 85 f6             	test   %rsi,%rsi
  80268b:	74 10                	je     80269d <strnlen+0x21>
  80268d:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  802691:	74 0b                	je     80269e <strnlen+0x22>
  802693:	48 83 c2 01          	add    $0x1,%rdx
  802697:	48 39 d0             	cmp    %rdx,%rax
  80269a:	75 f1                	jne    80268d <strnlen+0x11>
  80269c:	c3                   	ret
  80269d:	c3                   	ret
  80269e:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  8026a1:	c3                   	ret

00000000008026a2 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  8026a2:	f3 0f 1e fa          	endbr64
  8026a6:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8026a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ae:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  8026b2:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  8026b5:	48 83 c2 01          	add    $0x1,%rdx
  8026b9:	84 c9                	test   %cl,%cl
  8026bb:	75 f1                	jne    8026ae <strcpy+0xc>
        ;
    return res;
}
  8026bd:	c3                   	ret

00000000008026be <strcat>:

char *
strcat(char *dst, const char *src) {
  8026be:	f3 0f 1e fa          	endbr64
  8026c2:	55                   	push   %rbp
  8026c3:	48 89 e5             	mov    %rsp,%rbp
  8026c6:	41 54                	push   %r12
  8026c8:	53                   	push   %rbx
  8026c9:	48 89 fb             	mov    %rdi,%rbx
  8026cc:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8026cf:	48 b8 5d 26 80 00 00 	movabs $0x80265d,%rax
  8026d6:	00 00 00 
  8026d9:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  8026db:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8026df:	4c 89 e6             	mov    %r12,%rsi
  8026e2:	48 b8 a2 26 80 00 00 	movabs $0x8026a2,%rax
  8026e9:	00 00 00 
  8026ec:	ff d0                	call   *%rax
    return dst;
}
  8026ee:	48 89 d8             	mov    %rbx,%rax
  8026f1:	5b                   	pop    %rbx
  8026f2:	41 5c                	pop    %r12
  8026f4:	5d                   	pop    %rbp
  8026f5:	c3                   	ret

00000000008026f6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8026f6:	f3 0f 1e fa          	endbr64
  8026fa:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  8026fd:	48 85 d2             	test   %rdx,%rdx
  802700:	74 1f                	je     802721 <strncpy+0x2b>
  802702:	48 01 fa             	add    %rdi,%rdx
  802705:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  802708:	48 83 c1 01          	add    $0x1,%rcx
  80270c:	44 0f b6 06          	movzbl (%rsi),%r8d
  802710:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  802714:	41 80 f8 01          	cmp    $0x1,%r8b
  802718:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  80271c:	48 39 ca             	cmp    %rcx,%rdx
  80271f:	75 e7                	jne    802708 <strncpy+0x12>
    }
    return ret;
}
  802721:	c3                   	ret

0000000000802722 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  802722:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  802726:	48 89 f8             	mov    %rdi,%rax
  802729:	48 85 d2             	test   %rdx,%rdx
  80272c:	74 24                	je     802752 <strlcpy+0x30>
        while (--size > 0 && *src)
  80272e:	48 83 ea 01          	sub    $0x1,%rdx
  802732:	74 1b                	je     80274f <strlcpy+0x2d>
  802734:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802738:	0f b6 16             	movzbl (%rsi),%edx
  80273b:	84 d2                	test   %dl,%dl
  80273d:	74 10                	je     80274f <strlcpy+0x2d>
            *dst++ = *src++;
  80273f:	48 83 c6 01          	add    $0x1,%rsi
  802743:	48 83 c0 01          	add    $0x1,%rax
  802747:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80274a:	48 39 c8             	cmp    %rcx,%rax
  80274d:	75 e9                	jne    802738 <strlcpy+0x16>
        *dst = '\0';
  80274f:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  802752:	48 29 f8             	sub    %rdi,%rax
}
  802755:	c3                   	ret

0000000000802756 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  802756:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  80275a:	0f b6 07             	movzbl (%rdi),%eax
  80275d:	84 c0                	test   %al,%al
  80275f:	74 13                	je     802774 <strcmp+0x1e>
  802761:	38 06                	cmp    %al,(%rsi)
  802763:	75 0f                	jne    802774 <strcmp+0x1e>
  802765:	48 83 c7 01          	add    $0x1,%rdi
  802769:	48 83 c6 01          	add    $0x1,%rsi
  80276d:	0f b6 07             	movzbl (%rdi),%eax
  802770:	84 c0                	test   %al,%al
  802772:	75 ed                	jne    802761 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  802774:	0f b6 c0             	movzbl %al,%eax
  802777:	0f b6 16             	movzbl (%rsi),%edx
  80277a:	29 d0                	sub    %edx,%eax
}
  80277c:	c3                   	ret

000000000080277d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  80277d:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  802781:	48 85 d2             	test   %rdx,%rdx
  802784:	74 1f                	je     8027a5 <strncmp+0x28>
  802786:	0f b6 07             	movzbl (%rdi),%eax
  802789:	84 c0                	test   %al,%al
  80278b:	74 1e                	je     8027ab <strncmp+0x2e>
  80278d:	3a 06                	cmp    (%rsi),%al
  80278f:	75 1a                	jne    8027ab <strncmp+0x2e>
  802791:	48 83 c7 01          	add    $0x1,%rdi
  802795:	48 83 c6 01          	add    $0x1,%rsi
  802799:	48 83 ea 01          	sub    $0x1,%rdx
  80279d:	75 e7                	jne    802786 <strncmp+0x9>

    if (!n) return 0;
  80279f:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a4:	c3                   	ret
  8027a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027aa:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  8027ab:	0f b6 07             	movzbl (%rdi),%eax
  8027ae:	0f b6 16             	movzbl (%rsi),%edx
  8027b1:	29 d0                	sub    %edx,%eax
}
  8027b3:	c3                   	ret

00000000008027b4 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  8027b4:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  8027b8:	0f b6 17             	movzbl (%rdi),%edx
  8027bb:	84 d2                	test   %dl,%dl
  8027bd:	74 18                	je     8027d7 <strchr+0x23>
        if (*str == c) {
  8027bf:	0f be d2             	movsbl %dl,%edx
  8027c2:	39 f2                	cmp    %esi,%edx
  8027c4:	74 17                	je     8027dd <strchr+0x29>
    for (; *str; str++) {
  8027c6:	48 83 c7 01          	add    $0x1,%rdi
  8027ca:	0f b6 17             	movzbl (%rdi),%edx
  8027cd:	84 d2                	test   %dl,%dl
  8027cf:	75 ee                	jne    8027bf <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  8027d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d6:	c3                   	ret
  8027d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027dc:	c3                   	ret
            return (char *)str;
  8027dd:	48 89 f8             	mov    %rdi,%rax
}
  8027e0:	c3                   	ret

00000000008027e1 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  8027e1:	f3 0f 1e fa          	endbr64
  8027e5:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  8027e8:	0f b6 17             	movzbl (%rdi),%edx
  8027eb:	84 d2                	test   %dl,%dl
  8027ed:	74 13                	je     802802 <strfind+0x21>
  8027ef:	0f be d2             	movsbl %dl,%edx
  8027f2:	39 f2                	cmp    %esi,%edx
  8027f4:	74 0b                	je     802801 <strfind+0x20>
  8027f6:	48 83 c0 01          	add    $0x1,%rax
  8027fa:	0f b6 10             	movzbl (%rax),%edx
  8027fd:	84 d2                	test   %dl,%dl
  8027ff:	75 ee                	jne    8027ef <strfind+0xe>
        ;
    return (char *)str;
}
  802801:	c3                   	ret
  802802:	c3                   	ret

0000000000802803 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  802803:	f3 0f 1e fa          	endbr64
  802807:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80280a:	48 89 f8             	mov    %rdi,%rax
  80280d:	48 f7 d8             	neg    %rax
  802810:	83 e0 07             	and    $0x7,%eax
  802813:	49 89 d1             	mov    %rdx,%r9
  802816:	49 29 c1             	sub    %rax,%r9
  802819:	78 36                	js     802851 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  80281b:	40 0f b6 c6          	movzbl %sil,%eax
  80281f:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  802826:	01 01 01 
  802829:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80282d:	40 f6 c7 07          	test   $0x7,%dil
  802831:	75 38                	jne    80286b <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  802833:	4c 89 c9             	mov    %r9,%rcx
  802836:	48 c1 f9 03          	sar    $0x3,%rcx
  80283a:	74 0c                	je     802848 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80283c:	fc                   	cld
  80283d:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802840:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  802844:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  802848:	4d 85 c9             	test   %r9,%r9
  80284b:	75 45                	jne    802892 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  80284d:	4c 89 c0             	mov    %r8,%rax
  802850:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  802851:	48 85 d2             	test   %rdx,%rdx
  802854:	74 f7                	je     80284d <memset+0x4a>
  802856:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  802859:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  80285c:	48 83 c0 01          	add    $0x1,%rax
  802860:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  802864:	48 39 c2             	cmp    %rax,%rdx
  802867:	75 f3                	jne    80285c <memset+0x59>
  802869:	eb e2                	jmp    80284d <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  80286b:	40 f6 c7 01          	test   $0x1,%dil
  80286f:	74 06                	je     802877 <memset+0x74>
  802871:	88 07                	mov    %al,(%rdi)
  802873:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  802877:	40 f6 c7 02          	test   $0x2,%dil
  80287b:	74 07                	je     802884 <memset+0x81>
  80287d:	66 89 07             	mov    %ax,(%rdi)
  802880:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  802884:	40 f6 c7 04          	test   $0x4,%dil
  802888:	74 a9                	je     802833 <memset+0x30>
  80288a:	89 07                	mov    %eax,(%rdi)
  80288c:	48 83 c7 04          	add    $0x4,%rdi
  802890:	eb a1                	jmp    802833 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  802892:	41 f6 c1 04          	test   $0x4,%r9b
  802896:	74 1b                	je     8028b3 <memset+0xb0>
  802898:	89 07                	mov    %eax,(%rdi)
  80289a:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80289e:	41 f6 c1 02          	test   $0x2,%r9b
  8028a2:	74 07                	je     8028ab <memset+0xa8>
  8028a4:	66 89 07             	mov    %ax,(%rdi)
  8028a7:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8028ab:	41 f6 c1 01          	test   $0x1,%r9b
  8028af:	74 9c                	je     80284d <memset+0x4a>
  8028b1:	eb 06                	jmp    8028b9 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8028b3:	41 f6 c1 02          	test   $0x2,%r9b
  8028b7:	75 eb                	jne    8028a4 <memset+0xa1>
        if (ni & 1) *ptr = k;
  8028b9:	88 07                	mov    %al,(%rdi)
  8028bb:	eb 90                	jmp    80284d <memset+0x4a>

00000000008028bd <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8028bd:	f3 0f 1e fa          	endbr64
  8028c1:	48 89 f8             	mov    %rdi,%rax
  8028c4:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8028c7:	48 39 fe             	cmp    %rdi,%rsi
  8028ca:	73 3b                	jae    802907 <memmove+0x4a>
  8028cc:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8028d0:	48 39 d7             	cmp    %rdx,%rdi
  8028d3:	73 32                	jae    802907 <memmove+0x4a>
        s += n;
        d += n;
  8028d5:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028d9:	48 89 d6             	mov    %rdx,%rsi
  8028dc:	48 09 fe             	or     %rdi,%rsi
  8028df:	48 09 ce             	or     %rcx,%rsi
  8028e2:	40 f6 c6 07          	test   $0x7,%sil
  8028e6:	75 12                	jne    8028fa <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8028e8:	48 83 ef 08          	sub    $0x8,%rdi
  8028ec:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8028f0:	48 c1 e9 03          	shr    $0x3,%rcx
  8028f4:	fd                   	std
  8028f5:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8028f8:	fc                   	cld
  8028f9:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8028fa:	48 83 ef 01          	sub    $0x1,%rdi
  8028fe:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  802902:	fd                   	std
  802903:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  802905:	eb f1                	jmp    8028f8 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  802907:	48 89 f2             	mov    %rsi,%rdx
  80290a:	48 09 c2             	or     %rax,%rdx
  80290d:	48 09 ca             	or     %rcx,%rdx
  802910:	f6 c2 07             	test   $0x7,%dl
  802913:	75 0c                	jne    802921 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  802915:	48 c1 e9 03          	shr    $0x3,%rcx
  802919:	48 89 c7             	mov    %rax,%rdi
  80291c:	fc                   	cld
  80291d:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  802920:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  802921:	48 89 c7             	mov    %rax,%rdi
  802924:	fc                   	cld
  802925:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  802927:	c3                   	ret

0000000000802928 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  802928:	f3 0f 1e fa          	endbr64
  80292c:	55                   	push   %rbp
  80292d:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802930:	48 b8 bd 28 80 00 00 	movabs $0x8028bd,%rax
  802937:	00 00 00 
  80293a:	ff d0                	call   *%rax
}
  80293c:	5d                   	pop    %rbp
  80293d:	c3                   	ret

000000000080293e <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80293e:	f3 0f 1e fa          	endbr64
  802942:	55                   	push   %rbp
  802943:	48 89 e5             	mov    %rsp,%rbp
  802946:	41 57                	push   %r15
  802948:	41 56                	push   %r14
  80294a:	41 55                	push   %r13
  80294c:	41 54                	push   %r12
  80294e:	53                   	push   %rbx
  80294f:	48 83 ec 08          	sub    $0x8,%rsp
  802953:	49 89 fe             	mov    %rdi,%r14
  802956:	49 89 f7             	mov    %rsi,%r15
  802959:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  80295c:	48 89 f7             	mov    %rsi,%rdi
  80295f:	48 b8 5d 26 80 00 00 	movabs $0x80265d,%rax
  802966:	00 00 00 
  802969:	ff d0                	call   *%rax
  80296b:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80296e:	48 89 de             	mov    %rbx,%rsi
  802971:	4c 89 f7             	mov    %r14,%rdi
  802974:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  80297b:	00 00 00 
  80297e:	ff d0                	call   *%rax
  802980:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  802983:	48 39 c3             	cmp    %rax,%rbx
  802986:	74 36                	je     8029be <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  802988:	48 89 d8             	mov    %rbx,%rax
  80298b:	4c 29 e8             	sub    %r13,%rax
  80298e:	49 39 c4             	cmp    %rax,%r12
  802991:	73 31                	jae    8029c4 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  802993:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  802998:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80299c:	4c 89 fe             	mov    %r15,%rsi
  80299f:	48 b8 28 29 80 00 00 	movabs $0x802928,%rax
  8029a6:	00 00 00 
  8029a9:	ff d0                	call   *%rax
    return dstlen + srclen;
  8029ab:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8029af:	48 83 c4 08          	add    $0x8,%rsp
  8029b3:	5b                   	pop    %rbx
  8029b4:	41 5c                	pop    %r12
  8029b6:	41 5d                	pop    %r13
  8029b8:	41 5e                	pop    %r14
  8029ba:	41 5f                	pop    %r15
  8029bc:	5d                   	pop    %rbp
  8029bd:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  8029be:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  8029c2:	eb eb                	jmp    8029af <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  8029c4:	48 83 eb 01          	sub    $0x1,%rbx
  8029c8:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8029cc:	48 89 da             	mov    %rbx,%rdx
  8029cf:	4c 89 fe             	mov    %r15,%rsi
  8029d2:	48 b8 28 29 80 00 00 	movabs $0x802928,%rax
  8029d9:	00 00 00 
  8029dc:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8029de:	49 01 de             	add    %rbx,%r14
  8029e1:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8029e6:	eb c3                	jmp    8029ab <strlcat+0x6d>

00000000008029e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8029e8:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8029ec:	48 85 d2             	test   %rdx,%rdx
  8029ef:	74 2d                	je     802a1e <memcmp+0x36>
  8029f1:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8029f6:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8029fa:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8029ff:	44 38 c1             	cmp    %r8b,%cl
  802a02:	75 0f                	jne    802a13 <memcmp+0x2b>
    while (n-- > 0) {
  802a04:	48 83 c0 01          	add    $0x1,%rax
  802a08:	48 39 c2             	cmp    %rax,%rdx
  802a0b:	75 e9                	jne    8029f6 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  802a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a12:	c3                   	ret
            return (int)*s1 - (int)*s2;
  802a13:	0f b6 c1             	movzbl %cl,%eax
  802a16:	45 0f b6 c0          	movzbl %r8b,%r8d
  802a1a:	44 29 c0             	sub    %r8d,%eax
  802a1d:	c3                   	ret
    return 0;
  802a1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a23:	c3                   	ret

0000000000802a24 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  802a24:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  802a28:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802a2c:	48 39 c7             	cmp    %rax,%rdi
  802a2f:	73 0f                	jae    802a40 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802a31:	40 38 37             	cmp    %sil,(%rdi)
  802a34:	74 0e                	je     802a44 <memfind+0x20>
    for (; src < end; src++) {
  802a36:	48 83 c7 01          	add    $0x1,%rdi
  802a3a:	48 39 f8             	cmp    %rdi,%rax
  802a3d:	75 f2                	jne    802a31 <memfind+0xd>
  802a3f:	c3                   	ret
  802a40:	48 89 f8             	mov    %rdi,%rax
  802a43:	c3                   	ret
  802a44:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802a47:	c3                   	ret

0000000000802a48 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802a48:	f3 0f 1e fa          	endbr64
  802a4c:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802a4f:	0f b6 37             	movzbl (%rdi),%esi
  802a52:	40 80 fe 20          	cmp    $0x20,%sil
  802a56:	74 06                	je     802a5e <strtol+0x16>
  802a58:	40 80 fe 09          	cmp    $0x9,%sil
  802a5c:	75 13                	jne    802a71 <strtol+0x29>
  802a5e:	48 83 c7 01          	add    $0x1,%rdi
  802a62:	0f b6 37             	movzbl (%rdi),%esi
  802a65:	40 80 fe 20          	cmp    $0x20,%sil
  802a69:	74 f3                	je     802a5e <strtol+0x16>
  802a6b:	40 80 fe 09          	cmp    $0x9,%sil
  802a6f:	74 ed                	je     802a5e <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802a71:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802a74:	83 e0 fd             	and    $0xfffffffd,%eax
  802a77:	3c 01                	cmp    $0x1,%al
  802a79:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a7d:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  802a83:	75 0f                	jne    802a94 <strtol+0x4c>
  802a85:	80 3f 30             	cmpb   $0x30,(%rdi)
  802a88:	74 14                	je     802a9e <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802a8a:	85 d2                	test   %edx,%edx
  802a8c:	b8 0a 00 00 00       	mov    $0xa,%eax
  802a91:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  802a94:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  802a99:	4c 63 ca             	movslq %edx,%r9
  802a9c:	eb 36                	jmp    802ad4 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a9e:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  802aa2:	74 0f                	je     802ab3 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  802aa4:	85 d2                	test   %edx,%edx
  802aa6:	75 ec                	jne    802a94 <strtol+0x4c>
        s++;
  802aa8:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  802aac:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  802ab1:	eb e1                	jmp    802a94 <strtol+0x4c>
        s += 2;
  802ab3:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  802ab7:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  802abc:	eb d6                	jmp    802a94 <strtol+0x4c>
            dig -= '0';
  802abe:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  802ac1:	44 0f b6 c1          	movzbl %cl,%r8d
  802ac5:	41 39 d0             	cmp    %edx,%r8d
  802ac8:	7d 21                	jge    802aeb <strtol+0xa3>
        val = val * base + dig;
  802aca:	49 0f af c1          	imul   %r9,%rax
  802ace:	0f b6 c9             	movzbl %cl,%ecx
  802ad1:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  802ad4:	48 83 c7 01          	add    $0x1,%rdi
  802ad8:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  802adc:	80 f9 39             	cmp    $0x39,%cl
  802adf:	76 dd                	jbe    802abe <strtol+0x76>
        else if (dig - 'a' < 27)
  802ae1:	80 f9 7b             	cmp    $0x7b,%cl
  802ae4:	77 05                	ja     802aeb <strtol+0xa3>
            dig -= 'a' - 10;
  802ae6:	83 e9 57             	sub    $0x57,%ecx
  802ae9:	eb d6                	jmp    802ac1 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  802aeb:	4d 85 d2             	test   %r10,%r10
  802aee:	74 03                	je     802af3 <strtol+0xab>
  802af0:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802af3:	48 89 c2             	mov    %rax,%rdx
  802af6:	48 f7 da             	neg    %rdx
  802af9:	40 80 fe 2d          	cmp    $0x2d,%sil
  802afd:	48 0f 44 c2          	cmove  %rdx,%rax
}
  802b01:	c3                   	ret

0000000000802b02 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802b02:	f3 0f 1e fa          	endbr64
  802b06:	55                   	push   %rbp
  802b07:	48 89 e5             	mov    %rsp,%rbp
  802b0a:	41 54                	push   %r12
  802b0c:	53                   	push   %rbx
  802b0d:	48 89 fb             	mov    %rdi,%rbx
  802b10:	48 89 f7             	mov    %rsi,%rdi
  802b13:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b16:	48 85 f6             	test   %rsi,%rsi
  802b19:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b20:	00 00 00 
  802b23:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b27:	be 00 10 00 00       	mov    $0x1000,%esi
  802b2c:	48 b8 f4 05 80 00 00 	movabs $0x8005f4,%rax
  802b33:	00 00 00 
  802b36:	ff d0                	call   *%rax
    if (res < 0) {
  802b38:	85 c0                	test   %eax,%eax
  802b3a:	78 45                	js     802b81 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b3c:	48 85 db             	test   %rbx,%rbx
  802b3f:	74 12                	je     802b53 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b41:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b48:	00 00 00 
  802b4b:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b51:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b53:	4d 85 e4             	test   %r12,%r12
  802b56:	74 14                	je     802b6c <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b58:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b5f:	00 00 00 
  802b62:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b68:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b6c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b73:	00 00 00 
  802b76:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b7c:	5b                   	pop    %rbx
  802b7d:	41 5c                	pop    %r12
  802b7f:	5d                   	pop    %rbp
  802b80:	c3                   	ret
        if (from_env_store != NULL) {
  802b81:	48 85 db             	test   %rbx,%rbx
  802b84:	74 06                	je     802b8c <ipc_recv+0x8a>
            *from_env_store = 0;
  802b86:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b8c:	4d 85 e4             	test   %r12,%r12
  802b8f:	74 eb                	je     802b7c <ipc_recv+0x7a>
            *perm_store = 0;
  802b91:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b98:	00 
  802b99:	eb e1                	jmp    802b7c <ipc_recv+0x7a>

0000000000802b9b <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b9b:	f3 0f 1e fa          	endbr64
  802b9f:	55                   	push   %rbp
  802ba0:	48 89 e5             	mov    %rsp,%rbp
  802ba3:	41 57                	push   %r15
  802ba5:	41 56                	push   %r14
  802ba7:	41 55                	push   %r13
  802ba9:	41 54                	push   %r12
  802bab:	53                   	push   %rbx
  802bac:	48 83 ec 18          	sub    $0x18,%rsp
  802bb0:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802bb3:	48 89 d3             	mov    %rdx,%rbx
  802bb6:	49 89 cc             	mov    %rcx,%r12
  802bb9:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802bbc:	48 85 d2             	test   %rdx,%rdx
  802bbf:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bc6:	00 00 00 
  802bc9:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bcd:	89 f0                	mov    %esi,%eax
  802bcf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802bd3:	48 89 da             	mov    %rbx,%rdx
  802bd6:	48 89 c6             	mov    %rax,%rsi
  802bd9:	48 b8 c4 05 80 00 00 	movabs $0x8005c4,%rax
  802be0:	00 00 00 
  802be3:	ff d0                	call   *%rax
    while (res < 0) {
  802be5:	85 c0                	test   %eax,%eax
  802be7:	79 65                	jns    802c4e <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802be9:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bec:	75 33                	jne    802c21 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802bee:	49 bf 37 02 80 00 00 	movabs $0x800237,%r15
  802bf5:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bf8:	49 be c4 05 80 00 00 	movabs $0x8005c4,%r14
  802bff:	00 00 00 
        sys_yield();
  802c02:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c05:	45 89 e8             	mov    %r13d,%r8d
  802c08:	4c 89 e1             	mov    %r12,%rcx
  802c0b:	48 89 da             	mov    %rbx,%rdx
  802c0e:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802c12:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802c15:	41 ff d6             	call   *%r14
    while (res < 0) {
  802c18:	85 c0                	test   %eax,%eax
  802c1a:	79 32                	jns    802c4e <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c1c:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c1f:	74 e1                	je     802c02 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c21:	89 c1                	mov    %eax,%ecx
  802c23:	48 ba 45 32 80 00 00 	movabs $0x803245,%rdx
  802c2a:	00 00 00 
  802c2d:	be 42 00 00 00       	mov    $0x42,%esi
  802c32:	48 bf 50 32 80 00 00 	movabs $0x803250,%rdi
  802c39:	00 00 00 
  802c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c41:	49 b8 fd 1b 80 00 00 	movabs $0x801bfd,%r8
  802c48:	00 00 00 
  802c4b:	41 ff d0             	call   *%r8
    }
}
  802c4e:	48 83 c4 18          	add    $0x18,%rsp
  802c52:	5b                   	pop    %rbx
  802c53:	41 5c                	pop    %r12
  802c55:	41 5d                	pop    %r13
  802c57:	41 5e                	pop    %r14
  802c59:	41 5f                	pop    %r15
  802c5b:	5d                   	pop    %rbp
  802c5c:	c3                   	ret

0000000000802c5d <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c5d:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c61:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c66:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c6d:	00 00 00 
  802c70:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c74:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c78:	48 c1 e2 04          	shl    $0x4,%rdx
  802c7c:	48 01 ca             	add    %rcx,%rdx
  802c7f:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c85:	39 fa                	cmp    %edi,%edx
  802c87:	74 12                	je     802c9b <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c89:	48 83 c0 01          	add    $0x1,%rax
  802c8d:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c93:	75 db                	jne    802c70 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c9a:	c3                   	ret
            return envs[i].env_id;
  802c9b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c9f:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802ca3:	48 c1 e2 04          	shl    $0x4,%rdx
  802ca7:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802cae:	00 00 00 
  802cb1:	48 01 d0             	add    %rdx,%rax
  802cb4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cba:	c3                   	ret

0000000000802cbb <__text_end>:
  802cbb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cc2:	00 00 00 
  802cc5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ccc:	00 00 00 
  802ccf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cd6:	00 00 00 
  802cd9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ce0:	00 00 00 
  802ce3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cea:	00 00 00 
  802ced:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cf4:	00 00 00 
  802cf7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cfe:	00 00 00 
  802d01:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d08:	00 00 00 
  802d0b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d12:	00 00 00 
  802d15:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d1c:	00 00 00 
  802d1f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d26:	00 00 00 
  802d29:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d30:	00 00 00 
  802d33:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d3a:	00 00 00 
  802d3d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d44:	00 00 00 
  802d47:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d4e:	00 00 00 
  802d51:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d58:	00 00 00 
  802d5b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d62:	00 00 00 
  802d65:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d6c:	00 00 00 
  802d6f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d76:	00 00 00 
  802d79:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d80:	00 00 00 
  802d83:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d8a:	00 00 00 
  802d8d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d94:	00 00 00 
  802d97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d9e:	00 00 00 
  802da1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802da8:	00 00 00 
  802dab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802db2:	00 00 00 
  802db5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dbc:	00 00 00 
  802dbf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dc6:	00 00 00 
  802dc9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd0:	00 00 00 
  802dd3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dda:	00 00 00 
  802ddd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de4:	00 00 00 
  802de7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dee:	00 00 00 
  802df1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df8:	00 00 00 
  802dfb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e02:	00 00 00 
  802e05:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e0c:	00 00 00 
  802e0f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e16:	00 00 00 
  802e19:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e20:	00 00 00 
  802e23:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e2a:	00 00 00 
  802e2d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e34:	00 00 00 
  802e37:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e3e:	00 00 00 
  802e41:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e48:	00 00 00 
  802e4b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e52:	00 00 00 
  802e55:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e5c:	00 00 00 
  802e5f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e66:	00 00 00 
  802e69:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e70:	00 00 00 
  802e73:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e7a:	00 00 00 
  802e7d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e84:	00 00 00 
  802e87:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e8e:	00 00 00 
  802e91:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e98:	00 00 00 
  802e9b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea2:	00 00 00 
  802ea5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eac:	00 00 00 
  802eaf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb6:	00 00 00 
  802eb9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec0:	00 00 00 
  802ec3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eca:	00 00 00 
  802ecd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed4:	00 00 00 
  802ed7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ede:	00 00 00 
  802ee1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee8:	00 00 00 
  802eeb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef2:	00 00 00 
  802ef5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802efc:	00 00 00 
  802eff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f06:	00 00 00 
  802f09:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f10:	00 00 00 
  802f13:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f1a:	00 00 00 
  802f1d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f24:	00 00 00 
  802f27:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f2e:	00 00 00 
  802f31:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f38:	00 00 00 
  802f3b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f42:	00 00 00 
  802f45:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f4c:	00 00 00 
  802f4f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f56:	00 00 00 
  802f59:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f60:	00 00 00 
  802f63:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f6a:	00 00 00 
  802f6d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f74:	00 00 00 
  802f77:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f7e:	00 00 00 
  802f81:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f88:	00 00 00 
  802f8b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f92:	00 00 00 
  802f95:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f9c:	00 00 00 
  802f9f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa6:	00 00 00 
  802fa9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb0:	00 00 00 
  802fb3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fba:	00 00 00 
  802fbd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc4:	00 00 00 
  802fc7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fce:	00 00 00 
  802fd1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd8:	00 00 00 
  802fdb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe2:	00 00 00 
  802fe5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fec:	00 00 00 
  802fef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff6:	00 00 00 
  802ff9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
