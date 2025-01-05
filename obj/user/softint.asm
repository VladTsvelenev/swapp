
obj/user/softint:     file format elf64-x86-64


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
  80001e:	e8 09 00 00 00       	call   80002c <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* buggy program - causes an illegal software interrupt */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
    asm volatile("int $14"); /* page fault */
  800029:	cd 0e                	int    $0xe
}
  80002b:	c3                   	ret

000000000080002c <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80002c:	f3 0f 1e fa          	endbr64
  800030:	55                   	push   %rbp
  800031:	48 89 e5             	mov    %rsp,%rbp
  800034:	41 56                	push   %r14
  800036:	41 55                	push   %r13
  800038:	41 54                	push   %r12
  80003a:	53                   	push   %rbx
  80003b:	41 89 fd             	mov    %edi,%r13d
  80003e:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800041:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800048:	00 00 00 
  80004b:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800052:	00 00 00 
  800055:	48 39 c2             	cmp    %rax,%rdx
  800058:	73 17                	jae    800071 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80005a:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80005d:	49 89 c4             	mov    %rax,%r12
  800060:	48 83 c3 08          	add    $0x8,%rbx
  800064:	b8 00 00 00 00       	mov    $0x0,%eax
  800069:	ff 53 f8             	call   *-0x8(%rbx)
  80006c:	4c 39 e3             	cmp    %r12,%rbx
  80006f:	72 ef                	jb     800060 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800071:	48 b8 da 01 80 00 00 	movabs $0x8001da,%rax
  800078:	00 00 00 
  80007b:	ff d0                	call   *%rax
  80007d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800082:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800086:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80008a:	48 c1 e0 04          	shl    $0x4,%rax
  80008e:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800095:	00 00 00 
  800098:	48 01 d0             	add    %rdx,%rax
  80009b:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000a2:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000a5:	45 85 ed             	test   %r13d,%r13d
  8000a8:	7e 0d                	jle    8000b7 <libmain+0x8b>
  8000aa:	49 8b 06             	mov    (%r14),%rax
  8000ad:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000b4:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000b7:	4c 89 f6             	mov    %r14,%rsi
  8000ba:	44 89 ef             	mov    %r13d,%edi
  8000bd:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000c4:	00 00 00 
  8000c7:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000c9:	48 b8 de 00 80 00 00 	movabs $0x8000de,%rax
  8000d0:	00 00 00 
  8000d3:	ff d0                	call   *%rax
#endif
}
  8000d5:	5b                   	pop    %rbx
  8000d6:	41 5c                	pop    %r12
  8000d8:	41 5d                	pop    %r13
  8000da:	41 5e                	pop    %r14
  8000dc:	5d                   	pop    %rbp
  8000dd:	c3                   	ret

00000000008000de <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000de:	f3 0f 1e fa          	endbr64
  8000e2:	55                   	push   %rbp
  8000e3:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000e6:	48 b8 b0 08 80 00 00 	movabs $0x8008b0,%rax
  8000ed:	00 00 00 
  8000f0:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8000f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8000f7:	48 b8 6b 01 80 00 00 	movabs $0x80016b,%rax
  8000fe:	00 00 00 
  800101:	ff d0                	call   *%rax
}
  800103:	5d                   	pop    %rbp
  800104:	c3                   	ret

0000000000800105 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800105:	f3 0f 1e fa          	endbr64
  800109:	55                   	push   %rbp
  80010a:	48 89 e5             	mov    %rsp,%rbp
  80010d:	53                   	push   %rbx
  80010e:	48 89 fa             	mov    %rdi,%rdx
  800111:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800114:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800119:	bb 00 00 00 00       	mov    $0x0,%ebx
  80011e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800123:	be 00 00 00 00       	mov    $0x0,%esi
  800128:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80012e:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800130:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800134:	c9                   	leave
  800135:	c3                   	ret

0000000000800136 <sys_cgetc>:

int
sys_cgetc(void) {
  800136:	f3 0f 1e fa          	endbr64
  80013a:	55                   	push   %rbp
  80013b:	48 89 e5             	mov    %rsp,%rbp
  80013e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80013f:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800144:	ba 00 00 00 00       	mov    $0x0,%edx
  800149:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80014e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800153:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800158:	be 00 00 00 00       	mov    $0x0,%esi
  80015d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800163:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800165:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800169:	c9                   	leave
  80016a:	c3                   	ret

000000000080016b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80016b:	f3 0f 1e fa          	endbr64
  80016f:	55                   	push   %rbp
  800170:	48 89 e5             	mov    %rsp,%rbp
  800173:	53                   	push   %rbx
  800174:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800178:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80017b:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800180:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800185:	bb 00 00 00 00       	mov    $0x0,%ebx
  80018a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80018f:	be 00 00 00 00       	mov    $0x0,%esi
  800194:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80019a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80019c:	48 85 c0             	test   %rax,%rax
  80019f:	7f 06                	jg     8001a7 <sys_env_destroy+0x3c>
}
  8001a1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001a5:	c9                   	leave
  8001a6:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001a7:	49 89 c0             	mov    %rax,%r8
  8001aa:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001af:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8001b6:	00 00 00 
  8001b9:	be 26 00 00 00       	mov    $0x26,%esi
  8001be:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8001c5:	00 00 00 
  8001c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cd:	49 b9 d5 1b 80 00 00 	movabs $0x801bd5,%r9
  8001d4:	00 00 00 
  8001d7:	41 ff d1             	call   *%r9

00000000008001da <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001da:	f3 0f 1e fa          	endbr64
  8001de:	55                   	push   %rbp
  8001df:	48 89 e5             	mov    %rsp,%rbp
  8001e2:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8001e3:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8001e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ed:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001fc:	be 00 00 00 00       	mov    $0x0,%esi
  800201:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800207:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800209:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80020d:	c9                   	leave
  80020e:	c3                   	ret

000000000080020f <sys_yield>:

void
sys_yield(void) {
  80020f:	f3 0f 1e fa          	endbr64
  800213:	55                   	push   %rbp
  800214:	48 89 e5             	mov    %rsp,%rbp
  800217:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800218:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80021d:	ba 00 00 00 00       	mov    $0x0,%edx
  800222:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800227:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800231:	be 00 00 00 00       	mov    $0x0,%esi
  800236:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80023c:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80023e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800242:	c9                   	leave
  800243:	c3                   	ret

0000000000800244 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  800244:	f3 0f 1e fa          	endbr64
  800248:	55                   	push   %rbp
  800249:	48 89 e5             	mov    %rsp,%rbp
  80024c:	53                   	push   %rbx
  80024d:	48 89 fa             	mov    %rdi,%rdx
  800250:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800253:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800258:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80025f:	00 00 00 
  800262:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800267:	be 00 00 00 00       	mov    $0x0,%esi
  80026c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800272:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800274:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800278:	c9                   	leave
  800279:	c3                   	ret

000000000080027a <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80027a:	f3 0f 1e fa          	endbr64
  80027e:	55                   	push   %rbp
  80027f:	48 89 e5             	mov    %rsp,%rbp
  800282:	53                   	push   %rbx
  800283:	49 89 f8             	mov    %rdi,%r8
  800286:	48 89 d3             	mov    %rdx,%rbx
  800289:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80028c:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800291:	4c 89 c2             	mov    %r8,%rdx
  800294:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800297:	be 00 00 00 00       	mov    $0x0,%esi
  80029c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002a2:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002a4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002a8:	c9                   	leave
  8002a9:	c3                   	ret

00000000008002aa <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002aa:	f3 0f 1e fa          	endbr64
  8002ae:	55                   	push   %rbp
  8002af:	48 89 e5             	mov    %rsp,%rbp
  8002b2:	53                   	push   %rbx
  8002b3:	48 83 ec 08          	sub    $0x8,%rsp
  8002b7:	89 f8                	mov    %edi,%eax
  8002b9:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002bc:	48 63 f9             	movslq %ecx,%rdi
  8002bf:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002c2:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002c7:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002ca:	be 00 00 00 00       	mov    $0x0,%esi
  8002cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002d5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002d7:	48 85 c0             	test   %rax,%rax
  8002da:	7f 06                	jg     8002e2 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002dc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002e0:	c9                   	leave
  8002e1:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8002e2:	49 89 c0             	mov    %rax,%r8
  8002e5:	b9 04 00 00 00       	mov    $0x4,%ecx
  8002ea:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8002f1:	00 00 00 
  8002f4:	be 26 00 00 00       	mov    $0x26,%esi
  8002f9:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800300:	00 00 00 
  800303:	b8 00 00 00 00       	mov    $0x0,%eax
  800308:	49 b9 d5 1b 80 00 00 	movabs $0x801bd5,%r9
  80030f:	00 00 00 
  800312:	41 ff d1             	call   *%r9

0000000000800315 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  800315:	f3 0f 1e fa          	endbr64
  800319:	55                   	push   %rbp
  80031a:	48 89 e5             	mov    %rsp,%rbp
  80031d:	53                   	push   %rbx
  80031e:	48 83 ec 08          	sub    $0x8,%rsp
  800322:	89 f8                	mov    %edi,%eax
  800324:	49 89 f2             	mov    %rsi,%r10
  800327:	48 89 cf             	mov    %rcx,%rdi
  80032a:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80032d:	48 63 da             	movslq %edx,%rbx
  800330:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800333:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800338:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80033b:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80033e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800340:	48 85 c0             	test   %rax,%rax
  800343:	7f 06                	jg     80034b <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  800345:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800349:	c9                   	leave
  80034a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80034b:	49 89 c0             	mov    %rax,%r8
  80034e:	b9 05 00 00 00       	mov    $0x5,%ecx
  800353:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80035a:	00 00 00 
  80035d:	be 26 00 00 00       	mov    $0x26,%esi
  800362:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800369:	00 00 00 
  80036c:	b8 00 00 00 00       	mov    $0x0,%eax
  800371:	49 b9 d5 1b 80 00 00 	movabs $0x801bd5,%r9
  800378:	00 00 00 
  80037b:	41 ff d1             	call   *%r9

000000000080037e <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80037e:	f3 0f 1e fa          	endbr64
  800382:	55                   	push   %rbp
  800383:	48 89 e5             	mov    %rsp,%rbp
  800386:	53                   	push   %rbx
  800387:	48 83 ec 08          	sub    $0x8,%rsp
  80038b:	49 89 f9             	mov    %rdi,%r9
  80038e:	89 f0                	mov    %esi,%eax
  800390:	48 89 d3             	mov    %rdx,%rbx
  800393:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  800396:	49 63 f0             	movslq %r8d,%rsi
  800399:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80039c:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8003a1:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003aa:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003ac:	48 85 c0             	test   %rax,%rax
  8003af:	7f 06                	jg     8003b7 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8003b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003b5:	c9                   	leave
  8003b6:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003b7:	49 89 c0             	mov    %rax,%r8
  8003ba:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003bf:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8003c6:	00 00 00 
  8003c9:	be 26 00 00 00       	mov    $0x26,%esi
  8003ce:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8003d5:	00 00 00 
  8003d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003dd:	49 b9 d5 1b 80 00 00 	movabs $0x801bd5,%r9
  8003e4:	00 00 00 
  8003e7:	41 ff d1             	call   *%r9

00000000008003ea <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8003ea:	f3 0f 1e fa          	endbr64
  8003ee:	55                   	push   %rbp
  8003ef:	48 89 e5             	mov    %rsp,%rbp
  8003f2:	53                   	push   %rbx
  8003f3:	48 83 ec 08          	sub    $0x8,%rsp
  8003f7:	48 89 f1             	mov    %rsi,%rcx
  8003fa:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8003fd:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800400:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800405:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80040a:	be 00 00 00 00       	mov    $0x0,%esi
  80040f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800415:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800417:	48 85 c0             	test   %rax,%rax
  80041a:	7f 06                	jg     800422 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80041c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800420:	c9                   	leave
  800421:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800422:	49 89 c0             	mov    %rax,%r8
  800425:	b9 07 00 00 00       	mov    $0x7,%ecx
  80042a:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800431:	00 00 00 
  800434:	be 26 00 00 00       	mov    $0x26,%esi
  800439:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800440:	00 00 00 
  800443:	b8 00 00 00 00       	mov    $0x0,%eax
  800448:	49 b9 d5 1b 80 00 00 	movabs $0x801bd5,%r9
  80044f:	00 00 00 
  800452:	41 ff d1             	call   *%r9

0000000000800455 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  800455:	f3 0f 1e fa          	endbr64
  800459:	55                   	push   %rbp
  80045a:	48 89 e5             	mov    %rsp,%rbp
  80045d:	53                   	push   %rbx
  80045e:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  800462:	48 63 ce             	movslq %esi,%rcx
  800465:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800468:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80046d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800472:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800477:	be 00 00 00 00       	mov    $0x0,%esi
  80047c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800482:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800484:	48 85 c0             	test   %rax,%rax
  800487:	7f 06                	jg     80048f <sys_env_set_status+0x3a>
}
  800489:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80048d:	c9                   	leave
  80048e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80048f:	49 89 c0             	mov    %rax,%r8
  800492:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800497:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80049e:	00 00 00 
  8004a1:	be 26 00 00 00       	mov    $0x26,%esi
  8004a6:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8004ad:	00 00 00 
  8004b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b5:	49 b9 d5 1b 80 00 00 	movabs $0x801bd5,%r9
  8004bc:	00 00 00 
  8004bf:	41 ff d1             	call   *%r9

00000000008004c2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8004c2:	f3 0f 1e fa          	endbr64
  8004c6:	55                   	push   %rbp
  8004c7:	48 89 e5             	mov    %rsp,%rbp
  8004ca:	53                   	push   %rbx
  8004cb:	48 83 ec 08          	sub    $0x8,%rsp
  8004cf:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8004d2:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004d5:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004df:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8004e4:	be 00 00 00 00       	mov    $0x0,%esi
  8004e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004ef:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004f1:	48 85 c0             	test   %rax,%rax
  8004f4:	7f 06                	jg     8004fc <sys_env_set_trapframe+0x3a>
}
  8004f6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004fa:	c9                   	leave
  8004fb:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004fc:	49 89 c0             	mov    %rax,%r8
  8004ff:	b9 0b 00 00 00       	mov    $0xb,%ecx
  800504:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80050b:	00 00 00 
  80050e:	be 26 00 00 00       	mov    $0x26,%esi
  800513:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80051a:	00 00 00 
  80051d:	b8 00 00 00 00       	mov    $0x0,%eax
  800522:	49 b9 d5 1b 80 00 00 	movabs $0x801bd5,%r9
  800529:	00 00 00 
  80052c:	41 ff d1             	call   *%r9

000000000080052f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80052f:	f3 0f 1e fa          	endbr64
  800533:	55                   	push   %rbp
  800534:	48 89 e5             	mov    %rsp,%rbp
  800537:	53                   	push   %rbx
  800538:	48 83 ec 08          	sub    $0x8,%rsp
  80053c:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80053f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800542:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800547:	bb 00 00 00 00       	mov    $0x0,%ebx
  80054c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800551:	be 00 00 00 00       	mov    $0x0,%esi
  800556:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80055c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80055e:	48 85 c0             	test   %rax,%rax
  800561:	7f 06                	jg     800569 <sys_env_set_pgfault_upcall+0x3a>
}
  800563:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800567:	c9                   	leave
  800568:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800569:	49 89 c0             	mov    %rax,%r8
  80056c:	b9 0c 00 00 00       	mov    $0xc,%ecx
  800571:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800578:	00 00 00 
  80057b:	be 26 00 00 00       	mov    $0x26,%esi
  800580:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800587:	00 00 00 
  80058a:	b8 00 00 00 00       	mov    $0x0,%eax
  80058f:	49 b9 d5 1b 80 00 00 	movabs $0x801bd5,%r9
  800596:	00 00 00 
  800599:	41 ff d1             	call   *%r9

000000000080059c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80059c:	f3 0f 1e fa          	endbr64
  8005a0:	55                   	push   %rbp
  8005a1:	48 89 e5             	mov    %rsp,%rbp
  8005a4:	53                   	push   %rbx
  8005a5:	89 f8                	mov    %edi,%eax
  8005a7:	49 89 f1             	mov    %rsi,%r9
  8005aa:	48 89 d3             	mov    %rdx,%rbx
  8005ad:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8005b0:	49 63 f0             	movslq %r8d,%rsi
  8005b3:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8005b6:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005bb:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005c4:	cd 30                	int    $0x30
}
  8005c6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005ca:	c9                   	leave
  8005cb:	c3                   	ret

00000000008005cc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8005cc:	f3 0f 1e fa          	endbr64
  8005d0:	55                   	push   %rbp
  8005d1:	48 89 e5             	mov    %rsp,%rbp
  8005d4:	53                   	push   %rbx
  8005d5:	48 83 ec 08          	sub    $0x8,%rsp
  8005d9:	48 89 fa             	mov    %rdi,%rdx
  8005dc:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8005df:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8005e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005e9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005ee:	be 00 00 00 00       	mov    $0x0,%esi
  8005f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005f9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8005fb:	48 85 c0             	test   %rax,%rax
  8005fe:	7f 06                	jg     800606 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800600:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800604:	c9                   	leave
  800605:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800606:	49 89 c0             	mov    %rax,%r8
  800609:	b9 0f 00 00 00       	mov    $0xf,%ecx
  80060e:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800615:	00 00 00 
  800618:	be 26 00 00 00       	mov    $0x26,%esi
  80061d:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800624:	00 00 00 
  800627:	b8 00 00 00 00       	mov    $0x0,%eax
  80062c:	49 b9 d5 1b 80 00 00 	movabs $0x801bd5,%r9
  800633:	00 00 00 
  800636:	41 ff d1             	call   *%r9

0000000000800639 <sys_gettime>:

int
sys_gettime(void) {
  800639:	f3 0f 1e fa          	endbr64
  80063d:	55                   	push   %rbp
  80063e:	48 89 e5             	mov    %rsp,%rbp
  800641:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800642:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800647:	ba 00 00 00 00       	mov    $0x0,%edx
  80064c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800651:	bb 00 00 00 00       	mov    $0x0,%ebx
  800656:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80065b:	be 00 00 00 00       	mov    $0x0,%esi
  800660:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800666:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  800668:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80066c:	c9                   	leave
  80066d:	c3                   	ret

000000000080066e <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  80066e:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800672:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800679:	ff ff ff 
  80067c:	48 01 f8             	add    %rdi,%rax
  80067f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800683:	c3                   	ret

0000000000800684 <fd2data>:

char *
fd2data(struct Fd *fd) {
  800684:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800688:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80068f:	ff ff ff 
  800692:	48 01 f8             	add    %rdi,%rax
  800695:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  800699:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80069f:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006a3:	c3                   	ret

00000000008006a4 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8006a4:	f3 0f 1e fa          	endbr64
  8006a8:	55                   	push   %rbp
  8006a9:	48 89 e5             	mov    %rsp,%rbp
  8006ac:	41 57                	push   %r15
  8006ae:	41 56                	push   %r14
  8006b0:	41 55                	push   %r13
  8006b2:	41 54                	push   %r12
  8006b4:	53                   	push   %rbx
  8006b5:	48 83 ec 08          	sub    $0x8,%rsp
  8006b9:	49 89 ff             	mov    %rdi,%r15
  8006bc:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8006c1:	49 bd 03 18 80 00 00 	movabs $0x801803,%r13
  8006c8:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8006cb:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8006d1:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8006d4:	48 89 df             	mov    %rbx,%rdi
  8006d7:	41 ff d5             	call   *%r13
  8006da:	83 e0 04             	and    $0x4,%eax
  8006dd:	74 17                	je     8006f6 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8006df:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8006e6:	4c 39 f3             	cmp    %r14,%rbx
  8006e9:	75 e6                	jne    8006d1 <fd_alloc+0x2d>
  8006eb:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8006f1:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8006f6:	4d 89 27             	mov    %r12,(%r15)
}
  8006f9:	48 83 c4 08          	add    $0x8,%rsp
  8006fd:	5b                   	pop    %rbx
  8006fe:	41 5c                	pop    %r12
  800700:	41 5d                	pop    %r13
  800702:	41 5e                	pop    %r14
  800704:	41 5f                	pop    %r15
  800706:	5d                   	pop    %rbp
  800707:	c3                   	ret

0000000000800708 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  800708:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  80070c:	83 ff 1f             	cmp    $0x1f,%edi
  80070f:	77 39                	ja     80074a <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  800711:	55                   	push   %rbp
  800712:	48 89 e5             	mov    %rsp,%rbp
  800715:	41 54                	push   %r12
  800717:	53                   	push   %rbx
  800718:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80071b:	48 63 df             	movslq %edi,%rbx
  80071e:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  800725:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800729:	48 89 df             	mov    %rbx,%rdi
  80072c:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  800733:	00 00 00 
  800736:	ff d0                	call   *%rax
  800738:	a8 04                	test   $0x4,%al
  80073a:	74 14                	je     800750 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80073c:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  800740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800745:	5b                   	pop    %rbx
  800746:	41 5c                	pop    %r12
  800748:	5d                   	pop    %rbp
  800749:	c3                   	ret
        return -E_INVAL;
  80074a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80074f:	c3                   	ret
        return -E_INVAL;
  800750:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800755:	eb ee                	jmp    800745 <fd_lookup+0x3d>

0000000000800757 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  800757:	f3 0f 1e fa          	endbr64
  80075b:	55                   	push   %rbp
  80075c:	48 89 e5             	mov    %rsp,%rbp
  80075f:	41 54                	push   %r12
  800761:	53                   	push   %rbx
  800762:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  800765:	48 b8 40 33 80 00 00 	movabs $0x803340,%rax
  80076c:	00 00 00 
  80076f:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  800776:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  800779:	39 3b                	cmp    %edi,(%rbx)
  80077b:	74 47                	je     8007c4 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  80077d:	48 83 c0 08          	add    $0x8,%rax
  800781:	48 8b 18             	mov    (%rax),%rbx
  800784:	48 85 db             	test   %rbx,%rbx
  800787:	75 f0                	jne    800779 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800789:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800790:	00 00 00 
  800793:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800799:	89 fa                	mov    %edi,%edx
  80079b:	48 bf 78 32 80 00 00 	movabs $0x803278,%rdi
  8007a2:	00 00 00 
  8007a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007aa:	48 b9 31 1d 80 00 00 	movabs $0x801d31,%rcx
  8007b1:	00 00 00 
  8007b4:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8007b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8007bb:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8007bf:	5b                   	pop    %rbx
  8007c0:	41 5c                	pop    %r12
  8007c2:	5d                   	pop    %rbp
  8007c3:	c3                   	ret
            return 0;
  8007c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c9:	eb f0                	jmp    8007bb <dev_lookup+0x64>

00000000008007cb <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8007cb:	f3 0f 1e fa          	endbr64
  8007cf:	55                   	push   %rbp
  8007d0:	48 89 e5             	mov    %rsp,%rbp
  8007d3:	41 55                	push   %r13
  8007d5:	41 54                	push   %r12
  8007d7:	53                   	push   %rbx
  8007d8:	48 83 ec 18          	sub    $0x18,%rsp
  8007dc:	48 89 fb             	mov    %rdi,%rbx
  8007df:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8007e2:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8007e9:	ff ff ff 
  8007ec:	48 01 df             	add    %rbx,%rdi
  8007ef:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8007f3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8007f7:	48 b8 08 07 80 00 00 	movabs $0x800708,%rax
  8007fe:	00 00 00 
  800801:	ff d0                	call   *%rax
  800803:	41 89 c5             	mov    %eax,%r13d
  800806:	85 c0                	test   %eax,%eax
  800808:	78 06                	js     800810 <fd_close+0x45>
  80080a:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  80080e:	74 1a                	je     80082a <fd_close+0x5f>
        return (must_exist ? res : 0);
  800810:	45 84 e4             	test   %r12b,%r12b
  800813:	b8 00 00 00 00       	mov    $0x0,%eax
  800818:	44 0f 44 e8          	cmove  %eax,%r13d
}
  80081c:	44 89 e8             	mov    %r13d,%eax
  80081f:	48 83 c4 18          	add    $0x18,%rsp
  800823:	5b                   	pop    %rbx
  800824:	41 5c                	pop    %r12
  800826:	41 5d                	pop    %r13
  800828:	5d                   	pop    %rbp
  800829:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80082a:	8b 3b                	mov    (%rbx),%edi
  80082c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800830:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  800837:	00 00 00 
  80083a:	ff d0                	call   *%rax
  80083c:	41 89 c5             	mov    %eax,%r13d
  80083f:	85 c0                	test   %eax,%eax
  800841:	78 1b                	js     80085e <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  800843:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800847:	48 8b 40 20          	mov    0x20(%rax),%rax
  80084b:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  800851:	48 85 c0             	test   %rax,%rax
  800854:	74 08                	je     80085e <fd_close+0x93>
  800856:	48 89 df             	mov    %rbx,%rdi
  800859:	ff d0                	call   *%rax
  80085b:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80085e:	ba 00 10 00 00       	mov    $0x1000,%edx
  800863:	48 89 de             	mov    %rbx,%rsi
  800866:	bf 00 00 00 00       	mov    $0x0,%edi
  80086b:	48 b8 ea 03 80 00 00 	movabs $0x8003ea,%rax
  800872:	00 00 00 
  800875:	ff d0                	call   *%rax
    return res;
  800877:	eb a3                	jmp    80081c <fd_close+0x51>

0000000000800879 <close>:

int
close(int fdnum) {
  800879:	f3 0f 1e fa          	endbr64
  80087d:	55                   	push   %rbp
  80087e:	48 89 e5             	mov    %rsp,%rbp
  800881:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  800885:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800889:	48 b8 08 07 80 00 00 	movabs $0x800708,%rax
  800890:	00 00 00 
  800893:	ff d0                	call   *%rax
    if (res < 0) return res;
  800895:	85 c0                	test   %eax,%eax
  800897:	78 15                	js     8008ae <close+0x35>

    return fd_close(fd, 1);
  800899:	be 01 00 00 00       	mov    $0x1,%esi
  80089e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8008a2:	48 b8 cb 07 80 00 00 	movabs $0x8007cb,%rax
  8008a9:	00 00 00 
  8008ac:	ff d0                	call   *%rax
}
  8008ae:	c9                   	leave
  8008af:	c3                   	ret

00000000008008b0 <close_all>:

void
close_all(void) {
  8008b0:	f3 0f 1e fa          	endbr64
  8008b4:	55                   	push   %rbp
  8008b5:	48 89 e5             	mov    %rsp,%rbp
  8008b8:	41 54                	push   %r12
  8008ba:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8008bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008c0:	49 bc 79 08 80 00 00 	movabs $0x800879,%r12
  8008c7:	00 00 00 
  8008ca:	89 df                	mov    %ebx,%edi
  8008cc:	41 ff d4             	call   *%r12
  8008cf:	83 c3 01             	add    $0x1,%ebx
  8008d2:	83 fb 20             	cmp    $0x20,%ebx
  8008d5:	75 f3                	jne    8008ca <close_all+0x1a>
}
  8008d7:	5b                   	pop    %rbx
  8008d8:	41 5c                	pop    %r12
  8008da:	5d                   	pop    %rbp
  8008db:	c3                   	ret

00000000008008dc <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8008dc:	f3 0f 1e fa          	endbr64
  8008e0:	55                   	push   %rbp
  8008e1:	48 89 e5             	mov    %rsp,%rbp
  8008e4:	41 57                	push   %r15
  8008e6:	41 56                	push   %r14
  8008e8:	41 55                	push   %r13
  8008ea:	41 54                	push   %r12
  8008ec:	53                   	push   %rbx
  8008ed:	48 83 ec 18          	sub    $0x18,%rsp
  8008f1:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8008f4:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8008f8:	48 b8 08 07 80 00 00 	movabs $0x800708,%rax
  8008ff:	00 00 00 
  800902:	ff d0                	call   *%rax
  800904:	89 c3                	mov    %eax,%ebx
  800906:	85 c0                	test   %eax,%eax
  800908:	0f 88 b8 00 00 00    	js     8009c6 <dup+0xea>
    close(newfdnum);
  80090e:	44 89 e7             	mov    %r12d,%edi
  800911:	48 b8 79 08 80 00 00 	movabs $0x800879,%rax
  800918:	00 00 00 
  80091b:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  80091d:	4d 63 ec             	movslq %r12d,%r13
  800920:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  800927:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  80092b:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  80092f:	4c 89 ff             	mov    %r15,%rdi
  800932:	49 be 84 06 80 00 00 	movabs $0x800684,%r14
  800939:	00 00 00 
  80093c:	41 ff d6             	call   *%r14
  80093f:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  800942:	4c 89 ef             	mov    %r13,%rdi
  800945:	41 ff d6             	call   *%r14
  800948:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  80094b:	48 89 df             	mov    %rbx,%rdi
  80094e:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  800955:	00 00 00 
  800958:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  80095a:	a8 04                	test   $0x4,%al
  80095c:	74 2b                	je     800989 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  80095e:	41 89 c1             	mov    %eax,%r9d
  800961:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800967:	4c 89 f1             	mov    %r14,%rcx
  80096a:	ba 00 00 00 00       	mov    $0x0,%edx
  80096f:	48 89 de             	mov    %rbx,%rsi
  800972:	bf 00 00 00 00       	mov    $0x0,%edi
  800977:	48 b8 15 03 80 00 00 	movabs $0x800315,%rax
  80097e:	00 00 00 
  800981:	ff d0                	call   *%rax
  800983:	89 c3                	mov    %eax,%ebx
  800985:	85 c0                	test   %eax,%eax
  800987:	78 4e                	js     8009d7 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  800989:	4c 89 ff             	mov    %r15,%rdi
  80098c:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  800993:	00 00 00 
  800996:	ff d0                	call   *%rax
  800998:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  80099b:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8009a1:	4c 89 e9             	mov    %r13,%rcx
  8009a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a9:	4c 89 fe             	mov    %r15,%rsi
  8009ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8009b1:	48 b8 15 03 80 00 00 	movabs $0x800315,%rax
  8009b8:	00 00 00 
  8009bb:	ff d0                	call   *%rax
  8009bd:	89 c3                	mov    %eax,%ebx
  8009bf:	85 c0                	test   %eax,%eax
  8009c1:	78 14                	js     8009d7 <dup+0xfb>

    return newfdnum;
  8009c3:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8009c6:	89 d8                	mov    %ebx,%eax
  8009c8:	48 83 c4 18          	add    $0x18,%rsp
  8009cc:	5b                   	pop    %rbx
  8009cd:	41 5c                	pop    %r12
  8009cf:	41 5d                	pop    %r13
  8009d1:	41 5e                	pop    %r14
  8009d3:	41 5f                	pop    %r15
  8009d5:	5d                   	pop    %rbp
  8009d6:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8009d7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009dc:	4c 89 ee             	mov    %r13,%rsi
  8009df:	bf 00 00 00 00       	mov    $0x0,%edi
  8009e4:	49 bc ea 03 80 00 00 	movabs $0x8003ea,%r12
  8009eb:	00 00 00 
  8009ee:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8009f1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009f6:	4c 89 f6             	mov    %r14,%rsi
  8009f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8009fe:	41 ff d4             	call   *%r12
    return res;
  800a01:	eb c3                	jmp    8009c6 <dup+0xea>

0000000000800a03 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800a03:	f3 0f 1e fa          	endbr64
  800a07:	55                   	push   %rbp
  800a08:	48 89 e5             	mov    %rsp,%rbp
  800a0b:	41 56                	push   %r14
  800a0d:	41 55                	push   %r13
  800a0f:	41 54                	push   %r12
  800a11:	53                   	push   %rbx
  800a12:	48 83 ec 10          	sub    $0x10,%rsp
  800a16:	89 fb                	mov    %edi,%ebx
  800a18:	49 89 f4             	mov    %rsi,%r12
  800a1b:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a1e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800a22:	48 b8 08 07 80 00 00 	movabs $0x800708,%rax
  800a29:	00 00 00 
  800a2c:	ff d0                	call   *%rax
  800a2e:	85 c0                	test   %eax,%eax
  800a30:	78 4c                	js     800a7e <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a32:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800a36:	41 8b 3e             	mov    (%r14),%edi
  800a39:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800a3d:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  800a44:	00 00 00 
  800a47:	ff d0                	call   *%rax
  800a49:	85 c0                	test   %eax,%eax
  800a4b:	78 35                	js     800a82 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a4d:	41 8b 46 08          	mov    0x8(%r14),%eax
  800a51:	83 e0 03             	and    $0x3,%eax
  800a54:	83 f8 01             	cmp    $0x1,%eax
  800a57:	74 2d                	je     800a86 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800a59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a5d:	48 8b 40 10          	mov    0x10(%rax),%rax
  800a61:	48 85 c0             	test   %rax,%rax
  800a64:	74 56                	je     800abc <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  800a66:	4c 89 ea             	mov    %r13,%rdx
  800a69:	4c 89 e6             	mov    %r12,%rsi
  800a6c:	4c 89 f7             	mov    %r14,%rdi
  800a6f:	ff d0                	call   *%rax
}
  800a71:	48 83 c4 10          	add    $0x10,%rsp
  800a75:	5b                   	pop    %rbx
  800a76:	41 5c                	pop    %r12
  800a78:	41 5d                	pop    %r13
  800a7a:	41 5e                	pop    %r14
  800a7c:	5d                   	pop    %rbp
  800a7d:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a7e:	48 98                	cltq
  800a80:	eb ef                	jmp    800a71 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a82:	48 98                	cltq
  800a84:	eb eb                	jmp    800a71 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800a86:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800a8d:	00 00 00 
  800a90:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800a96:	89 da                	mov    %ebx,%edx
  800a98:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  800a9f:	00 00 00 
  800aa2:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa7:	48 b9 31 1d 80 00 00 	movabs $0x801d31,%rcx
  800aae:	00 00 00 
  800ab1:	ff d1                	call   *%rcx
        return -E_INVAL;
  800ab3:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800aba:	eb b5                	jmp    800a71 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800abc:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800ac3:	eb ac                	jmp    800a71 <read+0x6e>

0000000000800ac5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800ac5:	f3 0f 1e fa          	endbr64
  800ac9:	55                   	push   %rbp
  800aca:	48 89 e5             	mov    %rsp,%rbp
  800acd:	41 57                	push   %r15
  800acf:	41 56                	push   %r14
  800ad1:	41 55                	push   %r13
  800ad3:	41 54                	push   %r12
  800ad5:	53                   	push   %rbx
  800ad6:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800ada:	48 85 d2             	test   %rdx,%rdx
  800add:	74 54                	je     800b33 <readn+0x6e>
  800adf:	41 89 fd             	mov    %edi,%r13d
  800ae2:	49 89 f6             	mov    %rsi,%r14
  800ae5:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800ae8:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800aed:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800af2:	49 bf 03 0a 80 00 00 	movabs $0x800a03,%r15
  800af9:	00 00 00 
  800afc:	4c 89 e2             	mov    %r12,%rdx
  800aff:	48 29 f2             	sub    %rsi,%rdx
  800b02:	4c 01 f6             	add    %r14,%rsi
  800b05:	44 89 ef             	mov    %r13d,%edi
  800b08:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800b0b:	85 c0                	test   %eax,%eax
  800b0d:	78 20                	js     800b2f <readn+0x6a>
    for (; inc && res < n; res += inc) {
  800b0f:	01 c3                	add    %eax,%ebx
  800b11:	85 c0                	test   %eax,%eax
  800b13:	74 08                	je     800b1d <readn+0x58>
  800b15:	48 63 f3             	movslq %ebx,%rsi
  800b18:	4c 39 e6             	cmp    %r12,%rsi
  800b1b:	72 df                	jb     800afc <readn+0x37>
    }
    return res;
  800b1d:	48 63 c3             	movslq %ebx,%rax
}
  800b20:	48 83 c4 08          	add    $0x8,%rsp
  800b24:	5b                   	pop    %rbx
  800b25:	41 5c                	pop    %r12
  800b27:	41 5d                	pop    %r13
  800b29:	41 5e                	pop    %r14
  800b2b:	41 5f                	pop    %r15
  800b2d:	5d                   	pop    %rbp
  800b2e:	c3                   	ret
        if (inc < 0) return inc;
  800b2f:	48 98                	cltq
  800b31:	eb ed                	jmp    800b20 <readn+0x5b>
    int inc = 1, res = 0;
  800b33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b38:	eb e3                	jmp    800b1d <readn+0x58>

0000000000800b3a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800b3a:	f3 0f 1e fa          	endbr64
  800b3e:	55                   	push   %rbp
  800b3f:	48 89 e5             	mov    %rsp,%rbp
  800b42:	41 56                	push   %r14
  800b44:	41 55                	push   %r13
  800b46:	41 54                	push   %r12
  800b48:	53                   	push   %rbx
  800b49:	48 83 ec 10          	sub    $0x10,%rsp
  800b4d:	89 fb                	mov    %edi,%ebx
  800b4f:	49 89 f4             	mov    %rsi,%r12
  800b52:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b55:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800b59:	48 b8 08 07 80 00 00 	movabs $0x800708,%rax
  800b60:	00 00 00 
  800b63:	ff d0                	call   *%rax
  800b65:	85 c0                	test   %eax,%eax
  800b67:	78 47                	js     800bb0 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b69:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800b6d:	41 8b 3e             	mov    (%r14),%edi
  800b70:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800b74:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  800b7b:	00 00 00 
  800b7e:	ff d0                	call   *%rax
  800b80:	85 c0                	test   %eax,%eax
  800b82:	78 30                	js     800bb4 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b84:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  800b89:	74 2d                	je     800bb8 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800b8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b8f:	48 8b 40 18          	mov    0x18(%rax),%rax
  800b93:	48 85 c0             	test   %rax,%rax
  800b96:	74 56                	je     800bee <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  800b98:	4c 89 ea             	mov    %r13,%rdx
  800b9b:	4c 89 e6             	mov    %r12,%rsi
  800b9e:	4c 89 f7             	mov    %r14,%rdi
  800ba1:	ff d0                	call   *%rax
}
  800ba3:	48 83 c4 10          	add    $0x10,%rsp
  800ba7:	5b                   	pop    %rbx
  800ba8:	41 5c                	pop    %r12
  800baa:	41 5d                	pop    %r13
  800bac:	41 5e                	pop    %r14
  800bae:	5d                   	pop    %rbp
  800baf:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800bb0:	48 98                	cltq
  800bb2:	eb ef                	jmp    800ba3 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bb4:	48 98                	cltq
  800bb6:	eb eb                	jmp    800ba3 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800bb8:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bbf:	00 00 00 
  800bc2:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800bc8:	89 da                	mov    %ebx,%edx
  800bca:	48 bf 34 30 80 00 00 	movabs $0x803034,%rdi
  800bd1:	00 00 00 
  800bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd9:	48 b9 31 1d 80 00 00 	movabs $0x801d31,%rcx
  800be0:	00 00 00 
  800be3:	ff d1                	call   *%rcx
        return -E_INVAL;
  800be5:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800bec:	eb b5                	jmp    800ba3 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800bee:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800bf5:	eb ac                	jmp    800ba3 <write+0x69>

0000000000800bf7 <seek>:

int
seek(int fdnum, off_t offset) {
  800bf7:	f3 0f 1e fa          	endbr64
  800bfb:	55                   	push   %rbp
  800bfc:	48 89 e5             	mov    %rsp,%rbp
  800bff:	53                   	push   %rbx
  800c00:	48 83 ec 18          	sub    $0x18,%rsp
  800c04:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c06:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c0a:	48 b8 08 07 80 00 00 	movabs $0x800708,%rax
  800c11:	00 00 00 
  800c14:	ff d0                	call   *%rax
  800c16:	85 c0                	test   %eax,%eax
  800c18:	78 0c                	js     800c26 <seek+0x2f>

    fd->fd_offset = offset;
  800c1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c1e:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800c21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c26:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c2a:	c9                   	leave
  800c2b:	c3                   	ret

0000000000800c2c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800c2c:	f3 0f 1e fa          	endbr64
  800c30:	55                   	push   %rbp
  800c31:	48 89 e5             	mov    %rsp,%rbp
  800c34:	41 55                	push   %r13
  800c36:	41 54                	push   %r12
  800c38:	53                   	push   %rbx
  800c39:	48 83 ec 18          	sub    $0x18,%rsp
  800c3d:	89 fb                	mov    %edi,%ebx
  800c3f:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c42:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800c46:	48 b8 08 07 80 00 00 	movabs $0x800708,%rax
  800c4d:	00 00 00 
  800c50:	ff d0                	call   *%rax
  800c52:	85 c0                	test   %eax,%eax
  800c54:	78 38                	js     800c8e <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c56:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  800c5a:	41 8b 7d 00          	mov    0x0(%r13),%edi
  800c5e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800c62:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  800c69:	00 00 00 
  800c6c:	ff d0                	call   *%rax
  800c6e:	85 c0                	test   %eax,%eax
  800c70:	78 1c                	js     800c8e <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c72:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  800c77:	74 20                	je     800c99 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c7d:	48 8b 40 30          	mov    0x30(%rax),%rax
  800c81:	48 85 c0             	test   %rax,%rax
  800c84:	74 47                	je     800ccd <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  800c86:	44 89 e6             	mov    %r12d,%esi
  800c89:	4c 89 ef             	mov    %r13,%rdi
  800c8c:	ff d0                	call   *%rax
}
  800c8e:	48 83 c4 18          	add    $0x18,%rsp
  800c92:	5b                   	pop    %rbx
  800c93:	41 5c                	pop    %r12
  800c95:	41 5d                	pop    %r13
  800c97:	5d                   	pop    %rbp
  800c98:	c3                   	ret
                thisenv->env_id, fdnum);
  800c99:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800ca0:	00 00 00 
  800ca3:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800ca9:	89 da                	mov    %ebx,%edx
  800cab:	48 bf 98 32 80 00 00 	movabs $0x803298,%rdi
  800cb2:	00 00 00 
  800cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cba:	48 b9 31 1d 80 00 00 	movabs $0x801d31,%rcx
  800cc1:	00 00 00 
  800cc4:	ff d1                	call   *%rcx
        return -E_INVAL;
  800cc6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ccb:	eb c1                	jmp    800c8e <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800ccd:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800cd2:	eb ba                	jmp    800c8e <ftruncate+0x62>

0000000000800cd4 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800cd4:	f3 0f 1e fa          	endbr64
  800cd8:	55                   	push   %rbp
  800cd9:	48 89 e5             	mov    %rsp,%rbp
  800cdc:	41 54                	push   %r12
  800cde:	53                   	push   %rbx
  800cdf:	48 83 ec 10          	sub    $0x10,%rsp
  800ce3:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800ce6:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800cea:	48 b8 08 07 80 00 00 	movabs $0x800708,%rax
  800cf1:	00 00 00 
  800cf4:	ff d0                	call   *%rax
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	78 4e                	js     800d48 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800cfa:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  800cfe:	41 8b 3c 24          	mov    (%r12),%edi
  800d02:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800d06:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  800d0d:	00 00 00 
  800d10:	ff d0                	call   *%rax
  800d12:	85 c0                	test   %eax,%eax
  800d14:	78 32                	js     800d48 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800d1a:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800d1f:	74 30                	je     800d51 <fstat+0x7d>

    stat->st_name[0] = 0;
  800d21:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800d24:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800d2b:	00 00 00 
    stat->st_isdir = 0;
  800d2e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800d35:	00 00 00 
    stat->st_dev = dev;
  800d38:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800d3f:	48 89 de             	mov    %rbx,%rsi
  800d42:	4c 89 e7             	mov    %r12,%rdi
  800d45:	ff 50 28             	call   *0x28(%rax)
}
  800d48:	48 83 c4 10          	add    $0x10,%rsp
  800d4c:	5b                   	pop    %rbx
  800d4d:	41 5c                	pop    %r12
  800d4f:	5d                   	pop    %rbp
  800d50:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d51:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800d56:	eb f0                	jmp    800d48 <fstat+0x74>

0000000000800d58 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800d58:	f3 0f 1e fa          	endbr64
  800d5c:	55                   	push   %rbp
  800d5d:	48 89 e5             	mov    %rsp,%rbp
  800d60:	41 54                	push   %r12
  800d62:	53                   	push   %rbx
  800d63:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800d66:	be 00 00 00 00       	mov    $0x0,%esi
  800d6b:	48 b8 39 10 80 00 00 	movabs $0x801039,%rax
  800d72:	00 00 00 
  800d75:	ff d0                	call   *%rax
  800d77:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800d79:	85 c0                	test   %eax,%eax
  800d7b:	78 25                	js     800da2 <stat+0x4a>

    int res = fstat(fd, stat);
  800d7d:	4c 89 e6             	mov    %r12,%rsi
  800d80:	89 c7                	mov    %eax,%edi
  800d82:	48 b8 d4 0c 80 00 00 	movabs $0x800cd4,%rax
  800d89:	00 00 00 
  800d8c:	ff d0                	call   *%rax
  800d8e:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800d91:	89 df                	mov    %ebx,%edi
  800d93:	48 b8 79 08 80 00 00 	movabs $0x800879,%rax
  800d9a:	00 00 00 
  800d9d:	ff d0                	call   *%rax

    return res;
  800d9f:	44 89 e3             	mov    %r12d,%ebx
}
  800da2:	89 d8                	mov    %ebx,%eax
  800da4:	5b                   	pop    %rbx
  800da5:	41 5c                	pop    %r12
  800da7:	5d                   	pop    %rbp
  800da8:	c3                   	ret

0000000000800da9 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800da9:	f3 0f 1e fa          	endbr64
  800dad:	55                   	push   %rbp
  800dae:	48 89 e5             	mov    %rsp,%rbp
  800db1:	41 54                	push   %r12
  800db3:	53                   	push   %rbx
  800db4:	48 83 ec 10          	sub    $0x10,%rsp
  800db8:	41 89 fc             	mov    %edi,%r12d
  800dbb:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800dbe:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800dc5:	00 00 00 
  800dc8:	83 38 00             	cmpl   $0x0,(%rax)
  800dcb:	74 6e                	je     800e3b <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  800dcd:	bf 03 00 00 00       	mov    $0x3,%edi
  800dd2:	48 b8 35 2c 80 00 00 	movabs $0x802c35,%rax
  800dd9:	00 00 00 
  800ddc:	ff d0                	call   *%rax
  800dde:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800de5:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800de7:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800ded:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800df2:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800df9:	00 00 00 
  800dfc:	44 89 e6             	mov    %r12d,%esi
  800dff:	89 c7                	mov    %eax,%edi
  800e01:	48 b8 73 2b 80 00 00 	movabs $0x802b73,%rax
  800e08:	00 00 00 
  800e0b:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800e0d:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800e14:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800e15:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e1a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e1e:	48 89 de             	mov    %rbx,%rsi
  800e21:	bf 00 00 00 00       	mov    $0x0,%edi
  800e26:	48 b8 da 2a 80 00 00 	movabs $0x802ada,%rax
  800e2d:	00 00 00 
  800e30:	ff d0                	call   *%rax
}
  800e32:	48 83 c4 10          	add    $0x10,%rsp
  800e36:	5b                   	pop    %rbx
  800e37:	41 5c                	pop    %r12
  800e39:	5d                   	pop    %rbp
  800e3a:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800e3b:	bf 03 00 00 00       	mov    $0x3,%edi
  800e40:	48 b8 35 2c 80 00 00 	movabs $0x802c35,%rax
  800e47:	00 00 00 
  800e4a:	ff d0                	call   *%rax
  800e4c:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e53:	00 00 
  800e55:	e9 73 ff ff ff       	jmp    800dcd <fsipc+0x24>

0000000000800e5a <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800e5a:	f3 0f 1e fa          	endbr64
  800e5e:	55                   	push   %rbp
  800e5f:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800e62:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e69:	00 00 00 
  800e6c:	8b 57 0c             	mov    0xc(%rdi),%edx
  800e6f:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800e71:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800e74:	be 00 00 00 00       	mov    $0x0,%esi
  800e79:	bf 02 00 00 00       	mov    $0x2,%edi
  800e7e:	48 b8 a9 0d 80 00 00 	movabs $0x800da9,%rax
  800e85:	00 00 00 
  800e88:	ff d0                	call   *%rax
}
  800e8a:	5d                   	pop    %rbp
  800e8b:	c3                   	ret

0000000000800e8c <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800e8c:	f3 0f 1e fa          	endbr64
  800e90:	55                   	push   %rbp
  800e91:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800e94:	8b 47 0c             	mov    0xc(%rdi),%eax
  800e97:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800e9e:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800ea0:	be 00 00 00 00       	mov    $0x0,%esi
  800ea5:	bf 06 00 00 00       	mov    $0x6,%edi
  800eaa:	48 b8 a9 0d 80 00 00 	movabs $0x800da9,%rax
  800eb1:	00 00 00 
  800eb4:	ff d0                	call   *%rax
}
  800eb6:	5d                   	pop    %rbp
  800eb7:	c3                   	ret

0000000000800eb8 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800eb8:	f3 0f 1e fa          	endbr64
  800ebc:	55                   	push   %rbp
  800ebd:	48 89 e5             	mov    %rsp,%rbp
  800ec0:	41 54                	push   %r12
  800ec2:	53                   	push   %rbx
  800ec3:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ec6:	8b 47 0c             	mov    0xc(%rdi),%eax
  800ec9:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ed0:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800ed2:	be 00 00 00 00       	mov    $0x0,%esi
  800ed7:	bf 05 00 00 00       	mov    $0x5,%edi
  800edc:	48 b8 a9 0d 80 00 00 	movabs $0x800da9,%rax
  800ee3:	00 00 00 
  800ee6:	ff d0                	call   *%rax
    if (res < 0) return res;
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	78 3d                	js     800f29 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800eec:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  800ef3:	00 00 00 
  800ef6:	4c 89 e6             	mov    %r12,%rsi
  800ef9:	48 89 df             	mov    %rbx,%rdi
  800efc:	48 b8 7a 26 80 00 00 	movabs $0x80267a,%rax
  800f03:	00 00 00 
  800f06:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800f08:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  800f0f:	00 
  800f10:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800f16:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  800f1d:	00 
  800f1e:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800f24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f29:	5b                   	pop    %rbx
  800f2a:	41 5c                	pop    %r12
  800f2c:	5d                   	pop    %rbp
  800f2d:	c3                   	ret

0000000000800f2e <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f2e:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  800f32:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  800f39:	77 41                	ja     800f7c <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f3b:	55                   	push   %rbp
  800f3c:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  800f3f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f46:	00 00 00 
  800f49:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f4c:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  800f4e:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  800f52:	48 8d 78 10          	lea    0x10(%rax),%rdi
  800f56:	48 b8 95 28 80 00 00 	movabs $0x802895,%rax
  800f5d:	00 00 00 
  800f60:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  800f62:	be 00 00 00 00       	mov    $0x0,%esi
  800f67:	bf 04 00 00 00       	mov    $0x4,%edi
  800f6c:	48 b8 a9 0d 80 00 00 	movabs $0x800da9,%rax
  800f73:	00 00 00 
  800f76:	ff d0                	call   *%rax
  800f78:	48 98                	cltq
}
  800f7a:	5d                   	pop    %rbp
  800f7b:	c3                   	ret
        return -E_INVAL;
  800f7c:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  800f83:	c3                   	ret

0000000000800f84 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800f84:	f3 0f 1e fa          	endbr64
  800f88:	55                   	push   %rbp
  800f89:	48 89 e5             	mov    %rsp,%rbp
  800f8c:	41 55                	push   %r13
  800f8e:	41 54                	push   %r12
  800f90:	53                   	push   %rbx
  800f91:	48 83 ec 08          	sub    $0x8,%rsp
  800f95:	49 89 f4             	mov    %rsi,%r12
  800f98:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800f9b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800fa2:	00 00 00 
  800fa5:	8b 57 0c             	mov    0xc(%rdi),%edx
  800fa8:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  800faa:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  800fae:	be 00 00 00 00       	mov    $0x0,%esi
  800fb3:	bf 03 00 00 00       	mov    $0x3,%edi
  800fb8:	48 b8 a9 0d 80 00 00 	movabs $0x800da9,%rax
  800fbf:	00 00 00 
  800fc2:	ff d0                	call   *%rax
  800fc4:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  800fc7:	4d 85 ed             	test   %r13,%r13
  800fca:	78 2a                	js     800ff6 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  800fcc:	4c 89 ea             	mov    %r13,%rdx
  800fcf:	4c 39 eb             	cmp    %r13,%rbx
  800fd2:	72 30                	jb     801004 <devfile_read+0x80>
  800fd4:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  800fdb:	7f 27                	jg     801004 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  800fdd:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800fe4:	00 00 00 
  800fe7:	4c 89 e7             	mov    %r12,%rdi
  800fea:	48 b8 95 28 80 00 00 	movabs $0x802895,%rax
  800ff1:	00 00 00 
  800ff4:	ff d0                	call   *%rax
}
  800ff6:	4c 89 e8             	mov    %r13,%rax
  800ff9:	48 83 c4 08          	add    $0x8,%rsp
  800ffd:	5b                   	pop    %rbx
  800ffe:	41 5c                	pop    %r12
  801000:	41 5d                	pop    %r13
  801002:	5d                   	pop    %rbp
  801003:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801004:	48 b9 51 30 80 00 00 	movabs $0x803051,%rcx
  80100b:	00 00 00 
  80100e:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  801015:	00 00 00 
  801018:	be 7b 00 00 00       	mov    $0x7b,%esi
  80101d:	48 bf 83 30 80 00 00 	movabs $0x803083,%rdi
  801024:	00 00 00 
  801027:	b8 00 00 00 00       	mov    $0x0,%eax
  80102c:	49 b8 d5 1b 80 00 00 	movabs $0x801bd5,%r8
  801033:	00 00 00 
  801036:	41 ff d0             	call   *%r8

0000000000801039 <open>:
open(const char *path, int mode) {
  801039:	f3 0f 1e fa          	endbr64
  80103d:	55                   	push   %rbp
  80103e:	48 89 e5             	mov    %rsp,%rbp
  801041:	41 55                	push   %r13
  801043:	41 54                	push   %r12
  801045:	53                   	push   %rbx
  801046:	48 83 ec 18          	sub    $0x18,%rsp
  80104a:	49 89 fc             	mov    %rdi,%r12
  80104d:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801050:	48 b8 35 26 80 00 00 	movabs $0x802635,%rax
  801057:	00 00 00 
  80105a:	ff d0                	call   *%rax
  80105c:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801062:	0f 87 8a 00 00 00    	ja     8010f2 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801068:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80106c:	48 b8 a4 06 80 00 00 	movabs $0x8006a4,%rax
  801073:	00 00 00 
  801076:	ff d0                	call   *%rax
  801078:	89 c3                	mov    %eax,%ebx
  80107a:	85 c0                	test   %eax,%eax
  80107c:	78 50                	js     8010ce <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80107e:	4c 89 e6             	mov    %r12,%rsi
  801081:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801088:	00 00 00 
  80108b:	48 89 df             	mov    %rbx,%rdi
  80108e:	48 b8 7a 26 80 00 00 	movabs $0x80267a,%rax
  801095:	00 00 00 
  801098:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80109a:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8010a1:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8010a5:	bf 01 00 00 00       	mov    $0x1,%edi
  8010aa:	48 b8 a9 0d 80 00 00 	movabs $0x800da9,%rax
  8010b1:	00 00 00 
  8010b4:	ff d0                	call   *%rax
  8010b6:	89 c3                	mov    %eax,%ebx
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	78 1f                	js     8010db <open+0xa2>
    return fd2num(fd);
  8010bc:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010c0:	48 b8 6e 06 80 00 00 	movabs $0x80066e,%rax
  8010c7:	00 00 00 
  8010ca:	ff d0                	call   *%rax
  8010cc:	89 c3                	mov    %eax,%ebx
}
  8010ce:	89 d8                	mov    %ebx,%eax
  8010d0:	48 83 c4 18          	add    $0x18,%rsp
  8010d4:	5b                   	pop    %rbx
  8010d5:	41 5c                	pop    %r12
  8010d7:	41 5d                	pop    %r13
  8010d9:	5d                   	pop    %rbp
  8010da:	c3                   	ret
        fd_close(fd, 0);
  8010db:	be 00 00 00 00       	mov    $0x0,%esi
  8010e0:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010e4:	48 b8 cb 07 80 00 00 	movabs $0x8007cb,%rax
  8010eb:	00 00 00 
  8010ee:	ff d0                	call   *%rax
        return res;
  8010f0:	eb dc                	jmp    8010ce <open+0x95>
        return -E_BAD_PATH;
  8010f2:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8010f7:	eb d5                	jmp    8010ce <open+0x95>

00000000008010f9 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8010f9:	f3 0f 1e fa          	endbr64
  8010fd:	55                   	push   %rbp
  8010fe:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801101:	be 00 00 00 00       	mov    $0x0,%esi
  801106:	bf 08 00 00 00       	mov    $0x8,%edi
  80110b:	48 b8 a9 0d 80 00 00 	movabs $0x800da9,%rax
  801112:	00 00 00 
  801115:	ff d0                	call   *%rax
}
  801117:	5d                   	pop    %rbp
  801118:	c3                   	ret

0000000000801119 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801119:	f3 0f 1e fa          	endbr64
  80111d:	55                   	push   %rbp
  80111e:	48 89 e5             	mov    %rsp,%rbp
  801121:	41 54                	push   %r12
  801123:	53                   	push   %rbx
  801124:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801127:	48 b8 84 06 80 00 00 	movabs $0x800684,%rax
  80112e:	00 00 00 
  801131:	ff d0                	call   *%rax
  801133:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801136:	48 be 8e 30 80 00 00 	movabs $0x80308e,%rsi
  80113d:	00 00 00 
  801140:	48 89 df             	mov    %rbx,%rdi
  801143:	48 b8 7a 26 80 00 00 	movabs $0x80267a,%rax
  80114a:	00 00 00 
  80114d:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80114f:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801154:	41 2b 04 24          	sub    (%r12),%eax
  801158:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80115e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801165:	00 00 00 
    stat->st_dev = &devpipe;
  801168:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80116f:	00 00 00 
  801172:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801179:	b8 00 00 00 00       	mov    $0x0,%eax
  80117e:	5b                   	pop    %rbx
  80117f:	41 5c                	pop    %r12
  801181:	5d                   	pop    %rbp
  801182:	c3                   	ret

0000000000801183 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801183:	f3 0f 1e fa          	endbr64
  801187:	55                   	push   %rbp
  801188:	48 89 e5             	mov    %rsp,%rbp
  80118b:	41 54                	push   %r12
  80118d:	53                   	push   %rbx
  80118e:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801191:	ba 00 10 00 00       	mov    $0x1000,%edx
  801196:	48 89 fe             	mov    %rdi,%rsi
  801199:	bf 00 00 00 00       	mov    $0x0,%edi
  80119e:	49 bc ea 03 80 00 00 	movabs $0x8003ea,%r12
  8011a5:	00 00 00 
  8011a8:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8011ab:	48 89 df             	mov    %rbx,%rdi
  8011ae:	48 b8 84 06 80 00 00 	movabs $0x800684,%rax
  8011b5:	00 00 00 
  8011b8:	ff d0                	call   *%rax
  8011ba:	48 89 c6             	mov    %rax,%rsi
  8011bd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8011c7:	41 ff d4             	call   *%r12
}
  8011ca:	5b                   	pop    %rbx
  8011cb:	41 5c                	pop    %r12
  8011cd:	5d                   	pop    %rbp
  8011ce:	c3                   	ret

00000000008011cf <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8011cf:	f3 0f 1e fa          	endbr64
  8011d3:	55                   	push   %rbp
  8011d4:	48 89 e5             	mov    %rsp,%rbp
  8011d7:	41 57                	push   %r15
  8011d9:	41 56                	push   %r14
  8011db:	41 55                	push   %r13
  8011dd:	41 54                	push   %r12
  8011df:	53                   	push   %rbx
  8011e0:	48 83 ec 18          	sub    $0x18,%rsp
  8011e4:	49 89 fc             	mov    %rdi,%r12
  8011e7:	49 89 f5             	mov    %rsi,%r13
  8011ea:	49 89 d7             	mov    %rdx,%r15
  8011ed:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8011f1:	48 b8 84 06 80 00 00 	movabs $0x800684,%rax
  8011f8:	00 00 00 
  8011fb:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8011fd:	4d 85 ff             	test   %r15,%r15
  801200:	0f 84 af 00 00 00    	je     8012b5 <devpipe_write+0xe6>
  801206:	48 89 c3             	mov    %rax,%rbx
  801209:	4c 89 f8             	mov    %r15,%rax
  80120c:	4d 89 ef             	mov    %r13,%r15
  80120f:	4c 01 e8             	add    %r13,%rax
  801212:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801216:	49 bd 7a 02 80 00 00 	movabs $0x80027a,%r13
  80121d:	00 00 00 
            sys_yield();
  801220:	49 be 0f 02 80 00 00 	movabs $0x80020f,%r14
  801227:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80122a:	8b 73 04             	mov    0x4(%rbx),%esi
  80122d:	48 63 ce             	movslq %esi,%rcx
  801230:	48 63 03             	movslq (%rbx),%rax
  801233:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801239:	48 39 c1             	cmp    %rax,%rcx
  80123c:	72 2e                	jb     80126c <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80123e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801243:	48 89 da             	mov    %rbx,%rdx
  801246:	be 00 10 00 00       	mov    $0x1000,%esi
  80124b:	4c 89 e7             	mov    %r12,%rdi
  80124e:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801251:	85 c0                	test   %eax,%eax
  801253:	74 66                	je     8012bb <devpipe_write+0xec>
            sys_yield();
  801255:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801258:	8b 73 04             	mov    0x4(%rbx),%esi
  80125b:	48 63 ce             	movslq %esi,%rcx
  80125e:	48 63 03             	movslq (%rbx),%rax
  801261:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801267:	48 39 c1             	cmp    %rax,%rcx
  80126a:	73 d2                	jae    80123e <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80126c:	41 0f b6 3f          	movzbl (%r15),%edi
  801270:	48 89 ca             	mov    %rcx,%rdx
  801273:	48 c1 ea 03          	shr    $0x3,%rdx
  801277:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80127e:	08 10 20 
  801281:	48 f7 e2             	mul    %rdx
  801284:	48 c1 ea 06          	shr    $0x6,%rdx
  801288:	48 89 d0             	mov    %rdx,%rax
  80128b:	48 c1 e0 09          	shl    $0x9,%rax
  80128f:	48 29 d0             	sub    %rdx,%rax
  801292:	48 c1 e0 03          	shl    $0x3,%rax
  801296:	48 29 c1             	sub    %rax,%rcx
  801299:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80129e:	83 c6 01             	add    $0x1,%esi
  8012a1:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012a4:	49 83 c7 01          	add    $0x1,%r15
  8012a8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012ac:	49 39 c7             	cmp    %rax,%r15
  8012af:	0f 85 75 ff ff ff    	jne    80122a <devpipe_write+0x5b>
    return n;
  8012b5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8012b9:	eb 05                	jmp    8012c0 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8012bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c0:	48 83 c4 18          	add    $0x18,%rsp
  8012c4:	5b                   	pop    %rbx
  8012c5:	41 5c                	pop    %r12
  8012c7:	41 5d                	pop    %r13
  8012c9:	41 5e                	pop    %r14
  8012cb:	41 5f                	pop    %r15
  8012cd:	5d                   	pop    %rbp
  8012ce:	c3                   	ret

00000000008012cf <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8012cf:	f3 0f 1e fa          	endbr64
  8012d3:	55                   	push   %rbp
  8012d4:	48 89 e5             	mov    %rsp,%rbp
  8012d7:	41 57                	push   %r15
  8012d9:	41 56                	push   %r14
  8012db:	41 55                	push   %r13
  8012dd:	41 54                	push   %r12
  8012df:	53                   	push   %rbx
  8012e0:	48 83 ec 18          	sub    $0x18,%rsp
  8012e4:	49 89 fc             	mov    %rdi,%r12
  8012e7:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8012eb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8012ef:	48 b8 84 06 80 00 00 	movabs $0x800684,%rax
  8012f6:	00 00 00 
  8012f9:	ff d0                	call   *%rax
  8012fb:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8012fe:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801304:	49 bd 7a 02 80 00 00 	movabs $0x80027a,%r13
  80130b:	00 00 00 
            sys_yield();
  80130e:	49 be 0f 02 80 00 00 	movabs $0x80020f,%r14
  801315:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801318:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80131d:	74 7d                	je     80139c <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80131f:	8b 03                	mov    (%rbx),%eax
  801321:	3b 43 04             	cmp    0x4(%rbx),%eax
  801324:	75 26                	jne    80134c <devpipe_read+0x7d>
            if (i > 0) return i;
  801326:	4d 85 ff             	test   %r15,%r15
  801329:	75 77                	jne    8013a2 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80132b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801330:	48 89 da             	mov    %rbx,%rdx
  801333:	be 00 10 00 00       	mov    $0x1000,%esi
  801338:	4c 89 e7             	mov    %r12,%rdi
  80133b:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80133e:	85 c0                	test   %eax,%eax
  801340:	74 72                	je     8013b4 <devpipe_read+0xe5>
            sys_yield();
  801342:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801345:	8b 03                	mov    (%rbx),%eax
  801347:	3b 43 04             	cmp    0x4(%rbx),%eax
  80134a:	74 df                	je     80132b <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80134c:	48 63 c8             	movslq %eax,%rcx
  80134f:	48 89 ca             	mov    %rcx,%rdx
  801352:	48 c1 ea 03          	shr    $0x3,%rdx
  801356:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  80135d:	08 10 20 
  801360:	48 89 d0             	mov    %rdx,%rax
  801363:	48 f7 e6             	mul    %rsi
  801366:	48 c1 ea 06          	shr    $0x6,%rdx
  80136a:	48 89 d0             	mov    %rdx,%rax
  80136d:	48 c1 e0 09          	shl    $0x9,%rax
  801371:	48 29 d0             	sub    %rdx,%rax
  801374:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80137b:	00 
  80137c:	48 89 c8             	mov    %rcx,%rax
  80137f:	48 29 d0             	sub    %rdx,%rax
  801382:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  801387:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80138b:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80138f:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  801392:	49 83 c7 01          	add    $0x1,%r15
  801396:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80139a:	75 83                	jne    80131f <devpipe_read+0x50>
    return n;
  80139c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013a0:	eb 03                	jmp    8013a5 <devpipe_read+0xd6>
            if (i > 0) return i;
  8013a2:	4c 89 f8             	mov    %r15,%rax
}
  8013a5:	48 83 c4 18          	add    $0x18,%rsp
  8013a9:	5b                   	pop    %rbx
  8013aa:	41 5c                	pop    %r12
  8013ac:	41 5d                	pop    %r13
  8013ae:	41 5e                	pop    %r14
  8013b0:	41 5f                	pop    %r15
  8013b2:	5d                   	pop    %rbp
  8013b3:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8013b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b9:	eb ea                	jmp    8013a5 <devpipe_read+0xd6>

00000000008013bb <pipe>:
pipe(int pfd[2]) {
  8013bb:	f3 0f 1e fa          	endbr64
  8013bf:	55                   	push   %rbp
  8013c0:	48 89 e5             	mov    %rsp,%rbp
  8013c3:	41 55                	push   %r13
  8013c5:	41 54                	push   %r12
  8013c7:	53                   	push   %rbx
  8013c8:	48 83 ec 18          	sub    $0x18,%rsp
  8013cc:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8013cf:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8013d3:	48 b8 a4 06 80 00 00 	movabs $0x8006a4,%rax
  8013da:	00 00 00 
  8013dd:	ff d0                	call   *%rax
  8013df:	89 c3                	mov    %eax,%ebx
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	0f 88 a0 01 00 00    	js     801589 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8013e9:	b9 46 00 00 00       	mov    $0x46,%ecx
  8013ee:	ba 00 10 00 00       	mov    $0x1000,%edx
  8013f3:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8013f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8013fc:	48 b8 aa 02 80 00 00 	movabs $0x8002aa,%rax
  801403:	00 00 00 
  801406:	ff d0                	call   *%rax
  801408:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80140a:	85 c0                	test   %eax,%eax
  80140c:	0f 88 77 01 00 00    	js     801589 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  801412:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  801416:	48 b8 a4 06 80 00 00 	movabs $0x8006a4,%rax
  80141d:	00 00 00 
  801420:	ff d0                	call   *%rax
  801422:	89 c3                	mov    %eax,%ebx
  801424:	85 c0                	test   %eax,%eax
  801426:	0f 88 43 01 00 00    	js     80156f <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80142c:	b9 46 00 00 00       	mov    $0x46,%ecx
  801431:	ba 00 10 00 00       	mov    $0x1000,%edx
  801436:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80143a:	bf 00 00 00 00       	mov    $0x0,%edi
  80143f:	48 b8 aa 02 80 00 00 	movabs $0x8002aa,%rax
  801446:	00 00 00 
  801449:	ff d0                	call   *%rax
  80144b:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80144d:	85 c0                	test   %eax,%eax
  80144f:	0f 88 1a 01 00 00    	js     80156f <pipe+0x1b4>
    va = fd2data(fd0);
  801455:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801459:	48 b8 84 06 80 00 00 	movabs $0x800684,%rax
  801460:	00 00 00 
  801463:	ff d0                	call   *%rax
  801465:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801468:	b9 46 00 00 00       	mov    $0x46,%ecx
  80146d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801472:	48 89 c6             	mov    %rax,%rsi
  801475:	bf 00 00 00 00       	mov    $0x0,%edi
  80147a:	48 b8 aa 02 80 00 00 	movabs $0x8002aa,%rax
  801481:	00 00 00 
  801484:	ff d0                	call   *%rax
  801486:	89 c3                	mov    %eax,%ebx
  801488:	85 c0                	test   %eax,%eax
  80148a:	0f 88 c5 00 00 00    	js     801555 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  801490:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801494:	48 b8 84 06 80 00 00 	movabs $0x800684,%rax
  80149b:	00 00 00 
  80149e:	ff d0                	call   *%rax
  8014a0:	48 89 c1             	mov    %rax,%rcx
  8014a3:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8014a9:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8014af:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b4:	4c 89 ee             	mov    %r13,%rsi
  8014b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8014bc:	48 b8 15 03 80 00 00 	movabs $0x800315,%rax
  8014c3:	00 00 00 
  8014c6:	ff d0                	call   *%rax
  8014c8:	89 c3                	mov    %eax,%ebx
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	78 6e                	js     80153c <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014ce:	be 00 10 00 00       	mov    $0x1000,%esi
  8014d3:	4c 89 ef             	mov    %r13,%rdi
  8014d6:	48 b8 44 02 80 00 00 	movabs $0x800244,%rax
  8014dd:	00 00 00 
  8014e0:	ff d0                	call   *%rax
  8014e2:	83 f8 02             	cmp    $0x2,%eax
  8014e5:	0f 85 ab 00 00 00    	jne    801596 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8014eb:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8014f2:	00 00 
  8014f4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014f8:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8014fa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014fe:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  801505:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801509:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80150b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80150f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  801516:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80151a:	48 bb 6e 06 80 00 00 	movabs $0x80066e,%rbx
  801521:	00 00 00 
  801524:	ff d3                	call   *%rbx
  801526:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80152a:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80152e:	ff d3                	call   *%rbx
  801530:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  801535:	bb 00 00 00 00       	mov    $0x0,%ebx
  80153a:	eb 4d                	jmp    801589 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  80153c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801541:	4c 89 ee             	mov    %r13,%rsi
  801544:	bf 00 00 00 00       	mov    $0x0,%edi
  801549:	48 b8 ea 03 80 00 00 	movabs $0x8003ea,%rax
  801550:	00 00 00 
  801553:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  801555:	ba 00 10 00 00       	mov    $0x1000,%edx
  80155a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80155e:	bf 00 00 00 00       	mov    $0x0,%edi
  801563:	48 b8 ea 03 80 00 00 	movabs $0x8003ea,%rax
  80156a:	00 00 00 
  80156d:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80156f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801574:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801578:	bf 00 00 00 00       	mov    $0x0,%edi
  80157d:	48 b8 ea 03 80 00 00 	movabs $0x8003ea,%rax
  801584:	00 00 00 
  801587:	ff d0                	call   *%rax
}
  801589:	89 d8                	mov    %ebx,%eax
  80158b:	48 83 c4 18          	add    $0x18,%rsp
  80158f:	5b                   	pop    %rbx
  801590:	41 5c                	pop    %r12
  801592:	41 5d                	pop    %r13
  801594:	5d                   	pop    %rbp
  801595:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  801596:	48 b9 c0 32 80 00 00 	movabs $0x8032c0,%rcx
  80159d:	00 00 00 
  8015a0:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  8015a7:	00 00 00 
  8015aa:	be 2e 00 00 00       	mov    $0x2e,%esi
  8015af:	48 bf 95 30 80 00 00 	movabs $0x803095,%rdi
  8015b6:	00 00 00 
  8015b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015be:	49 b8 d5 1b 80 00 00 	movabs $0x801bd5,%r8
  8015c5:	00 00 00 
  8015c8:	41 ff d0             	call   *%r8

00000000008015cb <pipeisclosed>:
pipeisclosed(int fdnum) {
  8015cb:	f3 0f 1e fa          	endbr64
  8015cf:	55                   	push   %rbp
  8015d0:	48 89 e5             	mov    %rsp,%rbp
  8015d3:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8015d7:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8015db:	48 b8 08 07 80 00 00 	movabs $0x800708,%rax
  8015e2:	00 00 00 
  8015e5:	ff d0                	call   *%rax
    if (res < 0) return res;
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	78 35                	js     801620 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8015eb:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8015ef:	48 b8 84 06 80 00 00 	movabs $0x800684,%rax
  8015f6:	00 00 00 
  8015f9:	ff d0                	call   *%rax
  8015fb:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8015fe:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801603:	be 00 10 00 00       	mov    $0x1000,%esi
  801608:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80160c:	48 b8 7a 02 80 00 00 	movabs $0x80027a,%rax
  801613:	00 00 00 
  801616:	ff d0                	call   *%rax
  801618:	85 c0                	test   %eax,%eax
  80161a:	0f 94 c0             	sete   %al
  80161d:	0f b6 c0             	movzbl %al,%eax
}
  801620:	c9                   	leave
  801621:	c3                   	ret

0000000000801622 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  801622:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801626:	48 89 f8             	mov    %rdi,%rax
  801629:	48 c1 e8 27          	shr    $0x27,%rax
  80162d:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  801634:	7f 00 00 
  801637:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80163b:	f6 c2 01             	test   $0x1,%dl
  80163e:	74 6d                	je     8016ad <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801640:	48 89 f8             	mov    %rdi,%rax
  801643:	48 c1 e8 1e          	shr    $0x1e,%rax
  801647:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80164e:	7f 00 00 
  801651:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801655:	f6 c2 01             	test   $0x1,%dl
  801658:	74 62                	je     8016bc <get_uvpt_entry+0x9a>
  80165a:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801661:	7f 00 00 
  801664:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801668:	f6 c2 80             	test   $0x80,%dl
  80166b:	75 4f                	jne    8016bc <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80166d:	48 89 f8             	mov    %rdi,%rax
  801670:	48 c1 e8 15          	shr    $0x15,%rax
  801674:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80167b:	7f 00 00 
  80167e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801682:	f6 c2 01             	test   $0x1,%dl
  801685:	74 44                	je     8016cb <get_uvpt_entry+0xa9>
  801687:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80168e:	7f 00 00 
  801691:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801695:	f6 c2 80             	test   $0x80,%dl
  801698:	75 31                	jne    8016cb <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80169a:	48 c1 ef 0c          	shr    $0xc,%rdi
  80169e:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8016a5:	7f 00 00 
  8016a8:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8016ac:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8016ad:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8016b4:	7f 00 00 
  8016b7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016bb:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8016bc:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8016c3:	7f 00 00 
  8016c6:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016ca:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8016cb:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016d2:	7f 00 00 
  8016d5:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016d9:	c3                   	ret

00000000008016da <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8016da:	f3 0f 1e fa          	endbr64
  8016de:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8016e1:	48 89 f9             	mov    %rdi,%rcx
  8016e4:	48 c1 e9 27          	shr    $0x27,%rcx
  8016e8:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8016ef:	7f 00 00 
  8016f2:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8016f6:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8016fd:	f6 c1 01             	test   $0x1,%cl
  801700:	0f 84 b2 00 00 00    	je     8017b8 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  801706:	48 89 f9             	mov    %rdi,%rcx
  801709:	48 c1 e9 1e          	shr    $0x1e,%rcx
  80170d:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801714:	7f 00 00 
  801717:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80171b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  801722:	40 f6 c6 01          	test   $0x1,%sil
  801726:	0f 84 8c 00 00 00    	je     8017b8 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  80172c:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801733:	7f 00 00 
  801736:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80173a:	a8 80                	test   $0x80,%al
  80173c:	75 7b                	jne    8017b9 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  80173e:	48 89 f9             	mov    %rdi,%rcx
  801741:	48 c1 e9 15          	shr    $0x15,%rcx
  801745:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80174c:	7f 00 00 
  80174f:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801753:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  80175a:	40 f6 c6 01          	test   $0x1,%sil
  80175e:	74 58                	je     8017b8 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  801760:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801767:	7f 00 00 
  80176a:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80176e:	a8 80                	test   $0x80,%al
  801770:	75 6c                	jne    8017de <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  801772:	48 89 f9             	mov    %rdi,%rcx
  801775:	48 c1 e9 0c          	shr    $0xc,%rcx
  801779:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801780:	7f 00 00 
  801783:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801787:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  80178e:	40 f6 c6 01          	test   $0x1,%sil
  801792:	74 24                	je     8017b8 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  801794:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80179b:	7f 00 00 
  80179e:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017a2:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017a9:	ff ff 7f 
  8017ac:	48 21 c8             	and    %rcx,%rax
  8017af:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8017b5:	48 09 d0             	or     %rdx,%rax
}
  8017b8:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8017b9:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8017c0:	7f 00 00 
  8017c3:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017c7:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017ce:	ff ff 7f 
  8017d1:	48 21 c8             	and    %rcx,%rax
  8017d4:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8017da:	48 01 d0             	add    %rdx,%rax
  8017dd:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8017de:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8017e5:	7f 00 00 
  8017e8:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017ec:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017f3:	ff ff 7f 
  8017f6:	48 21 c8             	and    %rcx,%rax
  8017f9:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8017ff:	48 01 d0             	add    %rdx,%rax
  801802:	c3                   	ret

0000000000801803 <get_prot>:

int
get_prot(void *va) {
  801803:	f3 0f 1e fa          	endbr64
  801807:	55                   	push   %rbp
  801808:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80180b:	48 b8 22 16 80 00 00 	movabs $0x801622,%rax
  801812:	00 00 00 
  801815:	ff d0                	call   *%rax
  801817:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  80181a:	83 e0 01             	and    $0x1,%eax
  80181d:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  801820:	89 d1                	mov    %edx,%ecx
  801822:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  801828:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80182a:	89 c1                	mov    %eax,%ecx
  80182c:	83 c9 02             	or     $0x2,%ecx
  80182f:	f6 c2 02             	test   $0x2,%dl
  801832:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  801835:	89 c1                	mov    %eax,%ecx
  801837:	83 c9 01             	or     $0x1,%ecx
  80183a:	48 85 d2             	test   %rdx,%rdx
  80183d:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801840:	89 c1                	mov    %eax,%ecx
  801842:	83 c9 40             	or     $0x40,%ecx
  801845:	f6 c6 04             	test   $0x4,%dh
  801848:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80184b:	5d                   	pop    %rbp
  80184c:	c3                   	ret

000000000080184d <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80184d:	f3 0f 1e fa          	endbr64
  801851:	55                   	push   %rbp
  801852:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801855:	48 b8 22 16 80 00 00 	movabs $0x801622,%rax
  80185c:	00 00 00 
  80185f:	ff d0                	call   *%rax
    return pte & PTE_D;
  801861:	48 c1 e8 06          	shr    $0x6,%rax
  801865:	83 e0 01             	and    $0x1,%eax
}
  801868:	5d                   	pop    %rbp
  801869:	c3                   	ret

000000000080186a <is_page_present>:

bool
is_page_present(void *va) {
  80186a:	f3 0f 1e fa          	endbr64
  80186e:	55                   	push   %rbp
  80186f:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  801872:	48 b8 22 16 80 00 00 	movabs $0x801622,%rax
  801879:	00 00 00 
  80187c:	ff d0                	call   *%rax
  80187e:	83 e0 01             	and    $0x1,%eax
}
  801881:	5d                   	pop    %rbp
  801882:	c3                   	ret

0000000000801883 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801883:	f3 0f 1e fa          	endbr64
  801887:	55                   	push   %rbp
  801888:	48 89 e5             	mov    %rsp,%rbp
  80188b:	41 57                	push   %r15
  80188d:	41 56                	push   %r14
  80188f:	41 55                	push   %r13
  801891:	41 54                	push   %r12
  801893:	53                   	push   %rbx
  801894:	48 83 ec 18          	sub    $0x18,%rsp
  801898:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80189c:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8018a0:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8018a5:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8018ac:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8018af:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8018b6:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8018b9:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8018c0:	00 00 00 
  8018c3:	eb 73                	jmp    801938 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018c5:	48 89 d8             	mov    %rbx,%rax
  8018c8:	48 c1 e8 15          	shr    $0x15,%rax
  8018cc:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8018d3:	7f 00 00 
  8018d6:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8018da:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018e0:	f6 c2 01             	test   $0x1,%dl
  8018e3:	74 4b                	je     801930 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8018e5:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8018e9:	f6 c2 80             	test   $0x80,%dl
  8018ec:	74 11                	je     8018ff <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8018ee:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8018f2:	f6 c4 04             	test   $0x4,%ah
  8018f5:	74 39                	je     801930 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8018f7:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  8018fd:	eb 20                	jmp    80191f <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8018ff:	48 89 da             	mov    %rbx,%rdx
  801902:	48 c1 ea 0c          	shr    $0xc,%rdx
  801906:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80190d:	7f 00 00 
  801910:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  801914:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80191a:	f6 c4 04             	test   $0x4,%ah
  80191d:	74 11                	je     801930 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  80191f:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  801923:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801927:	48 89 df             	mov    %rbx,%rdi
  80192a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80192e:	ff d0                	call   *%rax
    next:
        va += size;
  801930:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  801933:	49 39 df             	cmp    %rbx,%r15
  801936:	72 3e                	jb     801976 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  801938:	49 8b 06             	mov    (%r14),%rax
  80193b:	a8 01                	test   $0x1,%al
  80193d:	74 37                	je     801976 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80193f:	48 89 d8             	mov    %rbx,%rax
  801942:	48 c1 e8 1e          	shr    $0x1e,%rax
  801946:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  80194b:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801951:	f6 c2 01             	test   $0x1,%dl
  801954:	74 da                	je     801930 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  801956:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  80195b:	f6 c2 80             	test   $0x80,%dl
  80195e:	0f 84 61 ff ff ff    	je     8018c5 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  801964:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  801969:	f6 c4 04             	test   $0x4,%ah
  80196c:	74 c2                	je     801930 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  80196e:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  801974:	eb a9                	jmp    80191f <foreach_shared_region+0x9c>
    }
    return res;
}
  801976:	b8 00 00 00 00       	mov    $0x0,%eax
  80197b:	48 83 c4 18          	add    $0x18,%rsp
  80197f:	5b                   	pop    %rbx
  801980:	41 5c                	pop    %r12
  801982:	41 5d                	pop    %r13
  801984:	41 5e                	pop    %r14
  801986:	41 5f                	pop    %r15
  801988:	5d                   	pop    %rbp
  801989:	c3                   	ret

000000000080198a <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  80198a:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  80198e:	b8 00 00 00 00       	mov    $0x0,%eax
  801993:	c3                   	ret

0000000000801994 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  801994:	f3 0f 1e fa          	endbr64
  801998:	55                   	push   %rbp
  801999:	48 89 e5             	mov    %rsp,%rbp
  80199c:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80199f:	48 be a5 30 80 00 00 	movabs $0x8030a5,%rsi
  8019a6:	00 00 00 
  8019a9:	48 b8 7a 26 80 00 00 	movabs $0x80267a,%rax
  8019b0:	00 00 00 
  8019b3:	ff d0                	call   *%rax
    return 0;
}
  8019b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ba:	5d                   	pop    %rbp
  8019bb:	c3                   	ret

00000000008019bc <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8019bc:	f3 0f 1e fa          	endbr64
  8019c0:	55                   	push   %rbp
  8019c1:	48 89 e5             	mov    %rsp,%rbp
  8019c4:	41 57                	push   %r15
  8019c6:	41 56                	push   %r14
  8019c8:	41 55                	push   %r13
  8019ca:	41 54                	push   %r12
  8019cc:	53                   	push   %rbx
  8019cd:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8019d4:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8019db:	48 85 d2             	test   %rdx,%rdx
  8019de:	74 7a                	je     801a5a <devcons_write+0x9e>
  8019e0:	49 89 d6             	mov    %rdx,%r14
  8019e3:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8019e9:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8019ee:	49 bf 95 28 80 00 00 	movabs $0x802895,%r15
  8019f5:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8019f8:	4c 89 f3             	mov    %r14,%rbx
  8019fb:	48 29 f3             	sub    %rsi,%rbx
  8019fe:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a03:	48 39 c3             	cmp    %rax,%rbx
  801a06:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801a0a:	4c 63 eb             	movslq %ebx,%r13
  801a0d:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801a14:	48 01 c6             	add    %rax,%rsi
  801a17:	4c 89 ea             	mov    %r13,%rdx
  801a1a:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a21:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  801a24:	4c 89 ee             	mov    %r13,%rsi
  801a27:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a2e:	48 b8 05 01 80 00 00 	movabs $0x800105,%rax
  801a35:	00 00 00 
  801a38:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801a3a:	41 01 dc             	add    %ebx,%r12d
  801a3d:	49 63 f4             	movslq %r12d,%rsi
  801a40:	4c 39 f6             	cmp    %r14,%rsi
  801a43:	72 b3                	jb     8019f8 <devcons_write+0x3c>
    return res;
  801a45:	49 63 c4             	movslq %r12d,%rax
}
  801a48:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801a4f:	5b                   	pop    %rbx
  801a50:	41 5c                	pop    %r12
  801a52:	41 5d                	pop    %r13
  801a54:	41 5e                	pop    %r14
  801a56:	41 5f                	pop    %r15
  801a58:	5d                   	pop    %rbp
  801a59:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  801a5a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a60:	eb e3                	jmp    801a45 <devcons_write+0x89>

0000000000801a62 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a62:	f3 0f 1e fa          	endbr64
  801a66:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801a69:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6e:	48 85 c0             	test   %rax,%rax
  801a71:	74 55                	je     801ac8 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a73:	55                   	push   %rbp
  801a74:	48 89 e5             	mov    %rsp,%rbp
  801a77:	41 55                	push   %r13
  801a79:	41 54                	push   %r12
  801a7b:	53                   	push   %rbx
  801a7c:	48 83 ec 08          	sub    $0x8,%rsp
  801a80:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801a83:	48 bb 36 01 80 00 00 	movabs $0x800136,%rbx
  801a8a:	00 00 00 
  801a8d:	49 bc 0f 02 80 00 00 	movabs $0x80020f,%r12
  801a94:	00 00 00 
  801a97:	eb 03                	jmp    801a9c <devcons_read+0x3a>
  801a99:	41 ff d4             	call   *%r12
  801a9c:	ff d3                	call   *%rbx
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	74 f7                	je     801a99 <devcons_read+0x37>
    if (c < 0) return c;
  801aa2:	48 63 d0             	movslq %eax,%rdx
  801aa5:	78 13                	js     801aba <devcons_read+0x58>
    if (c == 0x04) return 0;
  801aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  801aac:	83 f8 04             	cmp    $0x4,%eax
  801aaf:	74 09                	je     801aba <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  801ab1:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801ab5:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801aba:	48 89 d0             	mov    %rdx,%rax
  801abd:	48 83 c4 08          	add    $0x8,%rsp
  801ac1:	5b                   	pop    %rbx
  801ac2:	41 5c                	pop    %r12
  801ac4:	41 5d                	pop    %r13
  801ac6:	5d                   	pop    %rbp
  801ac7:	c3                   	ret
  801ac8:	48 89 d0             	mov    %rdx,%rax
  801acb:	c3                   	ret

0000000000801acc <cputchar>:
cputchar(int ch) {
  801acc:	f3 0f 1e fa          	endbr64
  801ad0:	55                   	push   %rbp
  801ad1:	48 89 e5             	mov    %rsp,%rbp
  801ad4:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801ad8:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801adc:	be 01 00 00 00       	mov    $0x1,%esi
  801ae1:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801ae5:	48 b8 05 01 80 00 00 	movabs $0x800105,%rax
  801aec:	00 00 00 
  801aef:	ff d0                	call   *%rax
}
  801af1:	c9                   	leave
  801af2:	c3                   	ret

0000000000801af3 <getchar>:
getchar(void) {
  801af3:	f3 0f 1e fa          	endbr64
  801af7:	55                   	push   %rbp
  801af8:	48 89 e5             	mov    %rsp,%rbp
  801afb:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801aff:	ba 01 00 00 00       	mov    $0x1,%edx
  801b04:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801b08:	bf 00 00 00 00       	mov    $0x0,%edi
  801b0d:	48 b8 03 0a 80 00 00 	movabs $0x800a03,%rax
  801b14:	00 00 00 
  801b17:	ff d0                	call   *%rax
  801b19:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	78 06                	js     801b25 <getchar+0x32>
  801b1f:	74 08                	je     801b29 <getchar+0x36>
  801b21:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  801b25:	89 d0                	mov    %edx,%eax
  801b27:	c9                   	leave
  801b28:	c3                   	ret
    return res < 0 ? res : res ? c :
  801b29:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801b2e:	eb f5                	jmp    801b25 <getchar+0x32>

0000000000801b30 <iscons>:
iscons(int fdnum) {
  801b30:	f3 0f 1e fa          	endbr64
  801b34:	55                   	push   %rbp
  801b35:	48 89 e5             	mov    %rsp,%rbp
  801b38:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801b3c:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b40:	48 b8 08 07 80 00 00 	movabs $0x800708,%rax
  801b47:	00 00 00 
  801b4a:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	78 18                	js     801b68 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  801b50:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b54:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801b5b:	00 00 00 
  801b5e:	8b 00                	mov    (%rax),%eax
  801b60:	39 02                	cmp    %eax,(%rdx)
  801b62:	0f 94 c0             	sete   %al
  801b65:	0f b6 c0             	movzbl %al,%eax
}
  801b68:	c9                   	leave
  801b69:	c3                   	ret

0000000000801b6a <opencons>:
opencons(void) {
  801b6a:	f3 0f 1e fa          	endbr64
  801b6e:	55                   	push   %rbp
  801b6f:	48 89 e5             	mov    %rsp,%rbp
  801b72:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801b76:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801b7a:	48 b8 a4 06 80 00 00 	movabs $0x8006a4,%rax
  801b81:	00 00 00 
  801b84:	ff d0                	call   *%rax
  801b86:	85 c0                	test   %eax,%eax
  801b88:	78 49                	js     801bd3 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801b8a:	b9 46 00 00 00       	mov    $0x46,%ecx
  801b8f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b94:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801b98:	bf 00 00 00 00       	mov    $0x0,%edi
  801b9d:	48 b8 aa 02 80 00 00 	movabs $0x8002aa,%rax
  801ba4:	00 00 00 
  801ba7:	ff d0                	call   *%rax
  801ba9:	85 c0                	test   %eax,%eax
  801bab:	78 26                	js     801bd3 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  801bad:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bb1:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801bb8:	00 00 
  801bba:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801bbc:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801bc0:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801bc7:	48 b8 6e 06 80 00 00 	movabs $0x80066e,%rax
  801bce:	00 00 00 
  801bd1:	ff d0                	call   *%rax
}
  801bd3:	c9                   	leave
  801bd4:	c3                   	ret

0000000000801bd5 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801bd5:	f3 0f 1e fa          	endbr64
  801bd9:	55                   	push   %rbp
  801bda:	48 89 e5             	mov    %rsp,%rbp
  801bdd:	41 56                	push   %r14
  801bdf:	41 55                	push   %r13
  801be1:	41 54                	push   %r12
  801be3:	53                   	push   %rbx
  801be4:	48 83 ec 50          	sub    $0x50,%rsp
  801be8:	49 89 fc             	mov    %rdi,%r12
  801beb:	41 89 f5             	mov    %esi,%r13d
  801bee:	48 89 d3             	mov    %rdx,%rbx
  801bf1:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801bf5:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801bf9:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801bfd:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801c04:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c08:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801c0c:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801c10:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801c14:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801c1b:	00 00 00 
  801c1e:	4c 8b 30             	mov    (%rax),%r14
  801c21:	48 b8 da 01 80 00 00 	movabs $0x8001da,%rax
  801c28:	00 00 00 
  801c2b:	ff d0                	call   *%rax
  801c2d:	89 c6                	mov    %eax,%esi
  801c2f:	45 89 e8             	mov    %r13d,%r8d
  801c32:	4c 89 e1             	mov    %r12,%rcx
  801c35:	4c 89 f2             	mov    %r14,%rdx
  801c38:	48 bf e8 32 80 00 00 	movabs $0x8032e8,%rdi
  801c3f:	00 00 00 
  801c42:	b8 00 00 00 00       	mov    $0x0,%eax
  801c47:	49 bc 31 1d 80 00 00 	movabs $0x801d31,%r12
  801c4e:	00 00 00 
  801c51:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801c54:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801c58:	48 89 df             	mov    %rbx,%rdi
  801c5b:	48 b8 c9 1c 80 00 00 	movabs $0x801cc9,%rax
  801c62:	00 00 00 
  801c65:	ff d0                	call   *%rax
    cprintf("\n");
  801c67:	48 bf 32 30 80 00 00 	movabs $0x803032,%rdi
  801c6e:	00 00 00 
  801c71:	b8 00 00 00 00       	mov    $0x0,%eax
  801c76:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801c79:	cc                   	int3
  801c7a:	eb fd                	jmp    801c79 <_panic+0xa4>

0000000000801c7c <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801c7c:	f3 0f 1e fa          	endbr64
  801c80:	55                   	push   %rbp
  801c81:	48 89 e5             	mov    %rsp,%rbp
  801c84:	53                   	push   %rbx
  801c85:	48 83 ec 08          	sub    $0x8,%rsp
  801c89:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801c8c:	8b 06                	mov    (%rsi),%eax
  801c8e:	8d 50 01             	lea    0x1(%rax),%edx
  801c91:	89 16                	mov    %edx,(%rsi)
  801c93:	48 98                	cltq
  801c95:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801c9a:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801ca0:	74 0a                	je     801cac <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801ca2:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801ca6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801caa:	c9                   	leave
  801cab:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  801cac:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801cb0:	be ff 00 00 00       	mov    $0xff,%esi
  801cb5:	48 b8 05 01 80 00 00 	movabs $0x800105,%rax
  801cbc:	00 00 00 
  801cbf:	ff d0                	call   *%rax
        state->offset = 0;
  801cc1:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801cc7:	eb d9                	jmp    801ca2 <putch+0x26>

0000000000801cc9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801cc9:	f3 0f 1e fa          	endbr64
  801ccd:	55                   	push   %rbp
  801cce:	48 89 e5             	mov    %rsp,%rbp
  801cd1:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801cd8:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801cdb:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801ce2:	b9 21 00 00 00       	mov    $0x21,%ecx
  801ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cec:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801cef:	48 89 f1             	mov    %rsi,%rcx
  801cf2:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801cf9:	48 bf 7c 1c 80 00 00 	movabs $0x801c7c,%rdi
  801d00:	00 00 00 
  801d03:	48 b8 91 1e 80 00 00 	movabs $0x801e91,%rax
  801d0a:	00 00 00 
  801d0d:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801d0f:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801d16:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801d1d:	48 b8 05 01 80 00 00 	movabs $0x800105,%rax
  801d24:	00 00 00 
  801d27:	ff d0                	call   *%rax

    return state.count;
}
  801d29:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801d2f:	c9                   	leave
  801d30:	c3                   	ret

0000000000801d31 <cprintf>:

int
cprintf(const char *fmt, ...) {
  801d31:	f3 0f 1e fa          	endbr64
  801d35:	55                   	push   %rbp
  801d36:	48 89 e5             	mov    %rsp,%rbp
  801d39:	48 83 ec 50          	sub    $0x50,%rsp
  801d3d:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801d41:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801d45:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d49:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801d4d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801d51:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801d58:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d5c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d60:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801d64:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801d68:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801d6c:	48 b8 c9 1c 80 00 00 	movabs $0x801cc9,%rax
  801d73:	00 00 00 
  801d76:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801d78:	c9                   	leave
  801d79:	c3                   	ret

0000000000801d7a <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801d7a:	f3 0f 1e fa          	endbr64
  801d7e:	55                   	push   %rbp
  801d7f:	48 89 e5             	mov    %rsp,%rbp
  801d82:	41 57                	push   %r15
  801d84:	41 56                	push   %r14
  801d86:	41 55                	push   %r13
  801d88:	41 54                	push   %r12
  801d8a:	53                   	push   %rbx
  801d8b:	48 83 ec 18          	sub    $0x18,%rsp
  801d8f:	49 89 fc             	mov    %rdi,%r12
  801d92:	49 89 f5             	mov    %rsi,%r13
  801d95:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801d99:	8b 45 10             	mov    0x10(%rbp),%eax
  801d9c:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801d9f:	41 89 cf             	mov    %ecx,%r15d
  801da2:	4c 39 fa             	cmp    %r15,%rdx
  801da5:	73 5b                	jae    801e02 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801da7:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801dab:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801daf:	85 db                	test   %ebx,%ebx
  801db1:	7e 0e                	jle    801dc1 <print_num+0x47>
            putch(padc, put_arg);
  801db3:	4c 89 ee             	mov    %r13,%rsi
  801db6:	44 89 f7             	mov    %r14d,%edi
  801db9:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801dbc:	83 eb 01             	sub    $0x1,%ebx
  801dbf:	75 f2                	jne    801db3 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801dc1:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801dc5:	48 b9 c2 30 80 00 00 	movabs $0x8030c2,%rcx
  801dcc:	00 00 00 
  801dcf:	48 b8 b1 30 80 00 00 	movabs $0x8030b1,%rax
  801dd6:	00 00 00 
  801dd9:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801ddd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801de1:	ba 00 00 00 00       	mov    $0x0,%edx
  801de6:	49 f7 f7             	div    %r15
  801de9:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801ded:	4c 89 ee             	mov    %r13,%rsi
  801df0:	41 ff d4             	call   *%r12
}
  801df3:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801df7:	5b                   	pop    %rbx
  801df8:	41 5c                	pop    %r12
  801dfa:	41 5d                	pop    %r13
  801dfc:	41 5e                	pop    %r14
  801dfe:	41 5f                	pop    %r15
  801e00:	5d                   	pop    %rbp
  801e01:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801e02:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e06:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0b:	49 f7 f7             	div    %r15
  801e0e:	48 83 ec 08          	sub    $0x8,%rsp
  801e12:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801e16:	52                   	push   %rdx
  801e17:	45 0f be c9          	movsbl %r9b,%r9d
  801e1b:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801e1f:	48 89 c2             	mov    %rax,%rdx
  801e22:	48 b8 7a 1d 80 00 00 	movabs $0x801d7a,%rax
  801e29:	00 00 00 
  801e2c:	ff d0                	call   *%rax
  801e2e:	48 83 c4 10          	add    $0x10,%rsp
  801e32:	eb 8d                	jmp    801dc1 <print_num+0x47>

0000000000801e34 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  801e34:	f3 0f 1e fa          	endbr64
    state->count++;
  801e38:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801e3c:	48 8b 06             	mov    (%rsi),%rax
  801e3f:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801e43:	73 0a                	jae    801e4f <sprintputch+0x1b>
        *state->start++ = ch;
  801e45:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e49:	48 89 16             	mov    %rdx,(%rsi)
  801e4c:	40 88 38             	mov    %dil,(%rax)
    }
}
  801e4f:	c3                   	ret

0000000000801e50 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801e50:	f3 0f 1e fa          	endbr64
  801e54:	55                   	push   %rbp
  801e55:	48 89 e5             	mov    %rsp,%rbp
  801e58:	48 83 ec 50          	sub    $0x50,%rsp
  801e5c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e60:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801e64:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801e68:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801e6f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e73:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e77:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801e7b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801e7f:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801e83:	48 b8 91 1e 80 00 00 	movabs $0x801e91,%rax
  801e8a:	00 00 00 
  801e8d:	ff d0                	call   *%rax
}
  801e8f:	c9                   	leave
  801e90:	c3                   	ret

0000000000801e91 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801e91:	f3 0f 1e fa          	endbr64
  801e95:	55                   	push   %rbp
  801e96:	48 89 e5             	mov    %rsp,%rbp
  801e99:	41 57                	push   %r15
  801e9b:	41 56                	push   %r14
  801e9d:	41 55                	push   %r13
  801e9f:	41 54                	push   %r12
  801ea1:	53                   	push   %rbx
  801ea2:	48 83 ec 38          	sub    $0x38,%rsp
  801ea6:	49 89 fe             	mov    %rdi,%r14
  801ea9:	49 89 f5             	mov    %rsi,%r13
  801eac:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  801eaf:	48 8b 01             	mov    (%rcx),%rax
  801eb2:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801eb6:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801eba:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801ebe:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801ec2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801ec6:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  801eca:	0f b6 3b             	movzbl (%rbx),%edi
  801ecd:	40 80 ff 25          	cmp    $0x25,%dil
  801ed1:	74 18                	je     801eeb <vprintfmt+0x5a>
            if (!ch) return;
  801ed3:	40 84 ff             	test   %dil,%dil
  801ed6:	0f 84 b2 06 00 00    	je     80258e <vprintfmt+0x6fd>
            putch(ch, put_arg);
  801edc:	40 0f b6 ff          	movzbl %dil,%edi
  801ee0:	4c 89 ee             	mov    %r13,%rsi
  801ee3:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  801ee6:	4c 89 e3             	mov    %r12,%rbx
  801ee9:	eb db                	jmp    801ec6 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  801eeb:	be 00 00 00 00       	mov    $0x0,%esi
  801ef0:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  801ef4:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801ef9:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801eff:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801f06:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f0a:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  801f0f:	41 0f b6 04 24       	movzbl (%r12),%eax
  801f14:	88 45 a0             	mov    %al,-0x60(%rbp)
  801f17:	83 e8 23             	sub    $0x23,%eax
  801f1a:	3c 57                	cmp    $0x57,%al
  801f1c:	0f 87 52 06 00 00    	ja     802574 <vprintfmt+0x6e3>
  801f22:	0f b6 c0             	movzbl %al,%eax
  801f25:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  801f2c:	00 00 00 
  801f2f:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  801f33:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  801f36:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  801f3a:	eb ce                	jmp    801f0a <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  801f3c:	49 89 dc             	mov    %rbx,%r12
  801f3f:	be 01 00 00 00       	mov    $0x1,%esi
  801f44:	eb c4                	jmp    801f0a <vprintfmt+0x79>
            padc = ch;
  801f46:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  801f4a:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f4d:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801f50:	eb b8                	jmp    801f0a <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f55:	83 f8 2f             	cmp    $0x2f,%eax
  801f58:	77 24                	ja     801f7e <vprintfmt+0xed>
  801f5a:	89 c1                	mov    %eax,%ecx
  801f5c:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  801f60:	83 c0 08             	add    $0x8,%eax
  801f63:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f66:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  801f69:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  801f6c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801f70:	79 98                	jns    801f0a <vprintfmt+0x79>
                width = precision;
  801f72:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  801f76:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f7c:	eb 8c                	jmp    801f0a <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f7e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801f82:	48 8d 41 08          	lea    0x8(%rcx),%rax
  801f86:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801f8a:	eb da                	jmp    801f66 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  801f8c:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  801f91:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801f95:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  801f9b:	3c 39                	cmp    $0x39,%al
  801f9d:	77 1c                	ja     801fbb <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  801f9f:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  801fa3:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  801fa7:	0f b6 c0             	movzbl %al,%eax
  801faa:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801faf:	0f b6 03             	movzbl (%rbx),%eax
  801fb2:	3c 39                	cmp    $0x39,%al
  801fb4:	76 e9                	jbe    801f9f <vprintfmt+0x10e>
        process_precision:
  801fb6:	49 89 dc             	mov    %rbx,%r12
  801fb9:	eb b1                	jmp    801f6c <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  801fbb:	49 89 dc             	mov    %rbx,%r12
  801fbe:	eb ac                	jmp    801f6c <vprintfmt+0xdb>
            width = MAX(0, width);
  801fc0:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  801fc3:	85 c9                	test   %ecx,%ecx
  801fc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fca:	0f 49 c1             	cmovns %ecx,%eax
  801fcd:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801fd0:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fd3:	e9 32 ff ff ff       	jmp    801f0a <vprintfmt+0x79>
            lflag++;
  801fd8:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801fdb:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801fde:	e9 27 ff ff ff       	jmp    801f0a <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  801fe3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801fe6:	83 f8 2f             	cmp    $0x2f,%eax
  801fe9:	77 19                	ja     802004 <vprintfmt+0x173>
  801feb:	89 c2                	mov    %eax,%edx
  801fed:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801ff1:	83 c0 08             	add    $0x8,%eax
  801ff4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801ff7:	8b 3a                	mov    (%rdx),%edi
  801ff9:	4c 89 ee             	mov    %r13,%rsi
  801ffc:	41 ff d6             	call   *%r14
            break;
  801fff:	e9 c2 fe ff ff       	jmp    801ec6 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  802004:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802008:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80200c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802010:	eb e5                	jmp    801ff7 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  802012:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802015:	83 f8 2f             	cmp    $0x2f,%eax
  802018:	77 5a                	ja     802074 <vprintfmt+0x1e3>
  80201a:	89 c2                	mov    %eax,%edx
  80201c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802020:	83 c0 08             	add    $0x8,%eax
  802023:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  802026:	8b 02                	mov    (%rdx),%eax
  802028:	89 c1                	mov    %eax,%ecx
  80202a:	f7 d9                	neg    %ecx
  80202c:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80202f:	83 f9 13             	cmp    $0x13,%ecx
  802032:	7f 4e                	jg     802082 <vprintfmt+0x1f1>
  802034:	48 63 c1             	movslq %ecx,%rax
  802037:	48 ba 20 36 80 00 00 	movabs $0x803620,%rdx
  80203e:	00 00 00 
  802041:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802045:	48 85 c0             	test   %rax,%rax
  802048:	74 38                	je     802082 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  80204a:	48 89 c1             	mov    %rax,%rcx
  80204d:	48 ba 80 30 80 00 00 	movabs $0x803080,%rdx
  802054:	00 00 00 
  802057:	4c 89 ee             	mov    %r13,%rsi
  80205a:	4c 89 f7             	mov    %r14,%rdi
  80205d:	b8 00 00 00 00       	mov    $0x0,%eax
  802062:	49 b8 50 1e 80 00 00 	movabs $0x801e50,%r8
  802069:	00 00 00 
  80206c:	41 ff d0             	call   *%r8
  80206f:	e9 52 fe ff ff       	jmp    801ec6 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  802074:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802078:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80207c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802080:	eb a4                	jmp    802026 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  802082:	48 ba da 30 80 00 00 	movabs $0x8030da,%rdx
  802089:	00 00 00 
  80208c:	4c 89 ee             	mov    %r13,%rsi
  80208f:	4c 89 f7             	mov    %r14,%rdi
  802092:	b8 00 00 00 00       	mov    $0x0,%eax
  802097:	49 b8 50 1e 80 00 00 	movabs $0x801e50,%r8
  80209e:	00 00 00 
  8020a1:	41 ff d0             	call   *%r8
  8020a4:	e9 1d fe ff ff       	jmp    801ec6 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8020a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020ac:	83 f8 2f             	cmp    $0x2f,%eax
  8020af:	77 6c                	ja     80211d <vprintfmt+0x28c>
  8020b1:	89 c2                	mov    %eax,%edx
  8020b3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8020b7:	83 c0 08             	add    $0x8,%eax
  8020ba:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020bd:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8020c0:	48 85 d2             	test   %rdx,%rdx
  8020c3:	48 b8 d3 30 80 00 00 	movabs $0x8030d3,%rax
  8020ca:	00 00 00 
  8020cd:	48 0f 45 c2          	cmovne %rdx,%rax
  8020d1:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8020d5:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8020d9:	7e 06                	jle    8020e1 <vprintfmt+0x250>
  8020db:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8020df:	75 4a                	jne    80212b <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8020e1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8020e5:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8020e9:	0f b6 00             	movzbl (%rax),%eax
  8020ec:	84 c0                	test   %al,%al
  8020ee:	0f 85 9a 00 00 00    	jne    80218e <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8020f4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8020f7:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8020fb:	85 c0                	test   %eax,%eax
  8020fd:	0f 8e c3 fd ff ff    	jle    801ec6 <vprintfmt+0x35>
  802103:	4c 89 ee             	mov    %r13,%rsi
  802106:	bf 20 00 00 00       	mov    $0x20,%edi
  80210b:	41 ff d6             	call   *%r14
  80210e:	41 83 ec 01          	sub    $0x1,%r12d
  802112:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  802116:	75 eb                	jne    802103 <vprintfmt+0x272>
  802118:	e9 a9 fd ff ff       	jmp    801ec6 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80211d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802121:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802125:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802129:	eb 92                	jmp    8020bd <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  80212b:	49 63 f7             	movslq %r15d,%rsi
  80212e:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  802132:	48 b8 54 26 80 00 00 	movabs $0x802654,%rax
  802139:	00 00 00 
  80213c:	ff d0                	call   *%rax
  80213e:	48 89 c2             	mov    %rax,%rdx
  802141:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802144:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  802146:	8d 70 ff             	lea    -0x1(%rax),%esi
  802149:	89 75 ac             	mov    %esi,-0x54(%rbp)
  80214c:	85 c0                	test   %eax,%eax
  80214e:	7e 91                	jle    8020e1 <vprintfmt+0x250>
  802150:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  802155:	4c 89 ee             	mov    %r13,%rsi
  802158:	44 89 e7             	mov    %r12d,%edi
  80215b:	41 ff d6             	call   *%r14
  80215e:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  802162:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802165:	83 f8 ff             	cmp    $0xffffffff,%eax
  802168:	75 eb                	jne    802155 <vprintfmt+0x2c4>
  80216a:	e9 72 ff ff ff       	jmp    8020e1 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80216f:	0f b6 f8             	movzbl %al,%edi
  802172:	4c 89 ee             	mov    %r13,%rsi
  802175:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802178:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80217c:	49 83 c4 01          	add    $0x1,%r12
  802180:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  802186:	84 c0                	test   %al,%al
  802188:	0f 84 66 ff ff ff    	je     8020f4 <vprintfmt+0x263>
  80218e:	45 85 ff             	test   %r15d,%r15d
  802191:	78 0a                	js     80219d <vprintfmt+0x30c>
  802193:	41 83 ef 01          	sub    $0x1,%r15d
  802197:	0f 88 57 ff ff ff    	js     8020f4 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80219d:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8021a1:	74 cc                	je     80216f <vprintfmt+0x2de>
  8021a3:	8d 50 e0             	lea    -0x20(%rax),%edx
  8021a6:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8021ab:	80 fa 5e             	cmp    $0x5e,%dl
  8021ae:	77 c2                	ja     802172 <vprintfmt+0x2e1>
  8021b0:	eb bd                	jmp    80216f <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8021b2:	40 84 f6             	test   %sil,%sil
  8021b5:	75 26                	jne    8021dd <vprintfmt+0x34c>
    switch (lflag) {
  8021b7:	85 d2                	test   %edx,%edx
  8021b9:	74 59                	je     802214 <vprintfmt+0x383>
  8021bb:	83 fa 01             	cmp    $0x1,%edx
  8021be:	74 7b                	je     80223b <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8021c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021c3:	83 f8 2f             	cmp    $0x2f,%eax
  8021c6:	0f 87 96 00 00 00    	ja     802262 <vprintfmt+0x3d1>
  8021cc:	89 c2                	mov    %eax,%edx
  8021ce:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021d2:	83 c0 08             	add    $0x8,%eax
  8021d5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021d8:	4c 8b 22             	mov    (%rdx),%r12
  8021db:	eb 17                	jmp    8021f4 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8021dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021e0:	83 f8 2f             	cmp    $0x2f,%eax
  8021e3:	77 21                	ja     802206 <vprintfmt+0x375>
  8021e5:	89 c2                	mov    %eax,%edx
  8021e7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021eb:	83 c0 08             	add    $0x8,%eax
  8021ee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021f1:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8021f4:	4d 85 e4             	test   %r12,%r12
  8021f7:	78 7a                	js     802273 <vprintfmt+0x3e2>
            num = i;
  8021f9:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8021fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  802201:	e9 50 02 00 00       	jmp    802456 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  802206:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80220a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80220e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802212:	eb dd                	jmp    8021f1 <vprintfmt+0x360>
        return va_arg(*ap, int);
  802214:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802217:	83 f8 2f             	cmp    $0x2f,%eax
  80221a:	77 11                	ja     80222d <vprintfmt+0x39c>
  80221c:	89 c2                	mov    %eax,%edx
  80221e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802222:	83 c0 08             	add    $0x8,%eax
  802225:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802228:	4c 63 22             	movslq (%rdx),%r12
  80222b:	eb c7                	jmp    8021f4 <vprintfmt+0x363>
  80222d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802231:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802235:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802239:	eb ed                	jmp    802228 <vprintfmt+0x397>
        return va_arg(*ap, long);
  80223b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80223e:	83 f8 2f             	cmp    $0x2f,%eax
  802241:	77 11                	ja     802254 <vprintfmt+0x3c3>
  802243:	89 c2                	mov    %eax,%edx
  802245:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802249:	83 c0 08             	add    $0x8,%eax
  80224c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80224f:	4c 8b 22             	mov    (%rdx),%r12
  802252:	eb a0                	jmp    8021f4 <vprintfmt+0x363>
  802254:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802258:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80225c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802260:	eb ed                	jmp    80224f <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  802262:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802266:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80226a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80226e:	e9 65 ff ff ff       	jmp    8021d8 <vprintfmt+0x347>
                putch('-', put_arg);
  802273:	4c 89 ee             	mov    %r13,%rsi
  802276:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80227b:	41 ff d6             	call   *%r14
                i = -i;
  80227e:	49 f7 dc             	neg    %r12
  802281:	e9 73 ff ff ff       	jmp    8021f9 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  802286:	40 84 f6             	test   %sil,%sil
  802289:	75 32                	jne    8022bd <vprintfmt+0x42c>
    switch (lflag) {
  80228b:	85 d2                	test   %edx,%edx
  80228d:	74 5d                	je     8022ec <vprintfmt+0x45b>
  80228f:	83 fa 01             	cmp    $0x1,%edx
  802292:	0f 84 82 00 00 00    	je     80231a <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  802298:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80229b:	83 f8 2f             	cmp    $0x2f,%eax
  80229e:	0f 87 a5 00 00 00    	ja     802349 <vprintfmt+0x4b8>
  8022a4:	89 c2                	mov    %eax,%edx
  8022a6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022aa:	83 c0 08             	add    $0x8,%eax
  8022ad:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022b0:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8022b8:	e9 99 01 00 00       	jmp    802456 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8022bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022c0:	83 f8 2f             	cmp    $0x2f,%eax
  8022c3:	77 19                	ja     8022de <vprintfmt+0x44d>
  8022c5:	89 c2                	mov    %eax,%edx
  8022c7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022cb:	83 c0 08             	add    $0x8,%eax
  8022ce:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022d1:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022d4:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8022d9:	e9 78 01 00 00       	jmp    802456 <vprintfmt+0x5c5>
  8022de:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8022e2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8022e6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022ea:	eb e5                	jmp    8022d1 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8022ec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022ef:	83 f8 2f             	cmp    $0x2f,%eax
  8022f2:	77 18                	ja     80230c <vprintfmt+0x47b>
  8022f4:	89 c2                	mov    %eax,%edx
  8022f6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022fa:	83 c0 08             	add    $0x8,%eax
  8022fd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802300:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  802302:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802307:	e9 4a 01 00 00       	jmp    802456 <vprintfmt+0x5c5>
  80230c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802310:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802314:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802318:	eb e6                	jmp    802300 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  80231a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80231d:	83 f8 2f             	cmp    $0x2f,%eax
  802320:	77 19                	ja     80233b <vprintfmt+0x4aa>
  802322:	89 c2                	mov    %eax,%edx
  802324:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802328:	83 c0 08             	add    $0x8,%eax
  80232b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80232e:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  802331:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  802336:	e9 1b 01 00 00       	jmp    802456 <vprintfmt+0x5c5>
  80233b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80233f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802343:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802347:	eb e5                	jmp    80232e <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  802349:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80234d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802351:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802355:	e9 56 ff ff ff       	jmp    8022b0 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  80235a:	40 84 f6             	test   %sil,%sil
  80235d:	75 2e                	jne    80238d <vprintfmt+0x4fc>
    switch (lflag) {
  80235f:	85 d2                	test   %edx,%edx
  802361:	74 59                	je     8023bc <vprintfmt+0x52b>
  802363:	83 fa 01             	cmp    $0x1,%edx
  802366:	74 7f                	je     8023e7 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  802368:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80236b:	83 f8 2f             	cmp    $0x2f,%eax
  80236e:	0f 87 9f 00 00 00    	ja     802413 <vprintfmt+0x582>
  802374:	89 c2                	mov    %eax,%edx
  802376:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80237a:	83 c0 08             	add    $0x8,%eax
  80237d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802380:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  802383:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  802388:	e9 c9 00 00 00       	jmp    802456 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80238d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802390:	83 f8 2f             	cmp    $0x2f,%eax
  802393:	77 19                	ja     8023ae <vprintfmt+0x51d>
  802395:	89 c2                	mov    %eax,%edx
  802397:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80239b:	83 c0 08             	add    $0x8,%eax
  80239e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023a1:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023a4:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8023a9:	e9 a8 00 00 00       	jmp    802456 <vprintfmt+0x5c5>
  8023ae:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023b2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023b6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023ba:	eb e5                	jmp    8023a1 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8023bc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023bf:	83 f8 2f             	cmp    $0x2f,%eax
  8023c2:	77 15                	ja     8023d9 <vprintfmt+0x548>
  8023c4:	89 c2                	mov    %eax,%edx
  8023c6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023ca:	83 c0 08             	add    $0x8,%eax
  8023cd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023d0:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8023d2:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8023d7:	eb 7d                	jmp    802456 <vprintfmt+0x5c5>
  8023d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023dd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023e1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023e5:	eb e9                	jmp    8023d0 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8023e7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023ea:	83 f8 2f             	cmp    $0x2f,%eax
  8023ed:	77 16                	ja     802405 <vprintfmt+0x574>
  8023ef:	89 c2                	mov    %eax,%edx
  8023f1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023f5:	83 c0 08             	add    $0x8,%eax
  8023f8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023fb:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023fe:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  802403:	eb 51                	jmp    802456 <vprintfmt+0x5c5>
  802405:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802409:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80240d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802411:	eb e8                	jmp    8023fb <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  802413:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802417:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80241b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80241f:	e9 5c ff ff ff       	jmp    802380 <vprintfmt+0x4ef>
            putch('0', put_arg);
  802424:	4c 89 ee             	mov    %r13,%rsi
  802427:	bf 30 00 00 00       	mov    $0x30,%edi
  80242c:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  80242f:	4c 89 ee             	mov    %r13,%rsi
  802432:	bf 78 00 00 00       	mov    $0x78,%edi
  802437:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  80243a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80243d:	83 f8 2f             	cmp    $0x2f,%eax
  802440:	77 47                	ja     802489 <vprintfmt+0x5f8>
  802442:	89 c2                	mov    %eax,%edx
  802444:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802448:	83 c0 08             	add    $0x8,%eax
  80244b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80244e:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802451:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  802456:	48 83 ec 08          	sub    $0x8,%rsp
  80245a:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  80245e:	0f 94 c0             	sete   %al
  802461:	0f b6 c0             	movzbl %al,%eax
  802464:	50                   	push   %rax
  802465:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  80246a:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80246e:	4c 89 ee             	mov    %r13,%rsi
  802471:	4c 89 f7             	mov    %r14,%rdi
  802474:	48 b8 7a 1d 80 00 00 	movabs $0x801d7a,%rax
  80247b:	00 00 00 
  80247e:	ff d0                	call   *%rax
            break;
  802480:	48 83 c4 10          	add    $0x10,%rsp
  802484:	e9 3d fa ff ff       	jmp    801ec6 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  802489:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80248d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802491:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802495:	eb b7                	jmp    80244e <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  802497:	40 84 f6             	test   %sil,%sil
  80249a:	75 2b                	jne    8024c7 <vprintfmt+0x636>
    switch (lflag) {
  80249c:	85 d2                	test   %edx,%edx
  80249e:	74 56                	je     8024f6 <vprintfmt+0x665>
  8024a0:	83 fa 01             	cmp    $0x1,%edx
  8024a3:	74 7f                	je     802524 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  8024a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024a8:	83 f8 2f             	cmp    $0x2f,%eax
  8024ab:	0f 87 a2 00 00 00    	ja     802553 <vprintfmt+0x6c2>
  8024b1:	89 c2                	mov    %eax,%edx
  8024b3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024b7:	83 c0 08             	add    $0x8,%eax
  8024ba:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024bd:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024c0:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8024c5:	eb 8f                	jmp    802456 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8024c7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024ca:	83 f8 2f             	cmp    $0x2f,%eax
  8024cd:	77 19                	ja     8024e8 <vprintfmt+0x657>
  8024cf:	89 c2                	mov    %eax,%edx
  8024d1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024d5:	83 c0 08             	add    $0x8,%eax
  8024d8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024db:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024de:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8024e3:	e9 6e ff ff ff       	jmp    802456 <vprintfmt+0x5c5>
  8024e8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024ec:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8024f0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024f4:	eb e5                	jmp    8024db <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8024f6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024f9:	83 f8 2f             	cmp    $0x2f,%eax
  8024fc:	77 18                	ja     802516 <vprintfmt+0x685>
  8024fe:	89 c2                	mov    %eax,%edx
  802500:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802504:	83 c0 08             	add    $0x8,%eax
  802507:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80250a:	8b 12                	mov    (%rdx),%edx
            base = 16;
  80250c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  802511:	e9 40 ff ff ff       	jmp    802456 <vprintfmt+0x5c5>
  802516:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80251a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80251e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802522:	eb e6                	jmp    80250a <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  802524:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802527:	83 f8 2f             	cmp    $0x2f,%eax
  80252a:	77 19                	ja     802545 <vprintfmt+0x6b4>
  80252c:	89 c2                	mov    %eax,%edx
  80252e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802532:	83 c0 08             	add    $0x8,%eax
  802535:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802538:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80253b:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  802540:	e9 11 ff ff ff       	jmp    802456 <vprintfmt+0x5c5>
  802545:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802549:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80254d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802551:	eb e5                	jmp    802538 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  802553:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802557:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80255b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80255f:	e9 59 ff ff ff       	jmp    8024bd <vprintfmt+0x62c>
            putch(ch, put_arg);
  802564:	4c 89 ee             	mov    %r13,%rsi
  802567:	bf 25 00 00 00       	mov    $0x25,%edi
  80256c:	41 ff d6             	call   *%r14
            break;
  80256f:	e9 52 f9 ff ff       	jmp    801ec6 <vprintfmt+0x35>
            putch('%', put_arg);
  802574:	4c 89 ee             	mov    %r13,%rsi
  802577:	bf 25 00 00 00       	mov    $0x25,%edi
  80257c:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  80257f:	48 83 eb 01          	sub    $0x1,%rbx
  802583:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  802587:	75 f6                	jne    80257f <vprintfmt+0x6ee>
  802589:	e9 38 f9 ff ff       	jmp    801ec6 <vprintfmt+0x35>
}
  80258e:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  802592:	5b                   	pop    %rbx
  802593:	41 5c                	pop    %r12
  802595:	41 5d                	pop    %r13
  802597:	41 5e                	pop    %r14
  802599:	41 5f                	pop    %r15
  80259b:	5d                   	pop    %rbp
  80259c:	c3                   	ret

000000000080259d <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  80259d:	f3 0f 1e fa          	endbr64
  8025a1:	55                   	push   %rbp
  8025a2:	48 89 e5             	mov    %rsp,%rbp
  8025a5:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  8025a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025ad:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  8025b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8025b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8025bd:	48 85 ff             	test   %rdi,%rdi
  8025c0:	74 2b                	je     8025ed <vsnprintf+0x50>
  8025c2:	48 85 f6             	test   %rsi,%rsi
  8025c5:	74 26                	je     8025ed <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8025c7:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8025cb:	48 bf 34 1e 80 00 00 	movabs $0x801e34,%rdi
  8025d2:	00 00 00 
  8025d5:	48 b8 91 1e 80 00 00 	movabs $0x801e91,%rax
  8025dc:	00 00 00 
  8025df:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8025e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025e5:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8025e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025eb:	c9                   	leave
  8025ec:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  8025ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025f2:	eb f7                	jmp    8025eb <vsnprintf+0x4e>

00000000008025f4 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8025f4:	f3 0f 1e fa          	endbr64
  8025f8:	55                   	push   %rbp
  8025f9:	48 89 e5             	mov    %rsp,%rbp
  8025fc:	48 83 ec 50          	sub    $0x50,%rsp
  802600:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802604:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802608:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80260c:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  802613:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802617:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80261b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80261f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  802623:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  802627:	48 b8 9d 25 80 00 00 	movabs $0x80259d,%rax
  80262e:	00 00 00 
  802631:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  802633:	c9                   	leave
  802634:	c3                   	ret

0000000000802635 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  802635:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  802639:	80 3f 00             	cmpb   $0x0,(%rdi)
  80263c:	74 10                	je     80264e <strlen+0x19>
    size_t n = 0;
  80263e:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  802643:	48 83 c0 01          	add    $0x1,%rax
  802647:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  80264b:	75 f6                	jne    802643 <strlen+0xe>
  80264d:	c3                   	ret
    size_t n = 0;
  80264e:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  802653:	c3                   	ret

0000000000802654 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  802654:	f3 0f 1e fa          	endbr64
  802658:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  80265b:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  802660:	48 85 f6             	test   %rsi,%rsi
  802663:	74 10                	je     802675 <strnlen+0x21>
  802665:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  802669:	74 0b                	je     802676 <strnlen+0x22>
  80266b:	48 83 c2 01          	add    $0x1,%rdx
  80266f:	48 39 d0             	cmp    %rdx,%rax
  802672:	75 f1                	jne    802665 <strnlen+0x11>
  802674:	c3                   	ret
  802675:	c3                   	ret
  802676:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  802679:	c3                   	ret

000000000080267a <strcpy>:

char *
strcpy(char *dst, const char *src) {
  80267a:	f3 0f 1e fa          	endbr64
  80267e:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  802681:	ba 00 00 00 00       	mov    $0x0,%edx
  802686:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  80268a:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  80268d:	48 83 c2 01          	add    $0x1,%rdx
  802691:	84 c9                	test   %cl,%cl
  802693:	75 f1                	jne    802686 <strcpy+0xc>
        ;
    return res;
}
  802695:	c3                   	ret

0000000000802696 <strcat>:

char *
strcat(char *dst, const char *src) {
  802696:	f3 0f 1e fa          	endbr64
  80269a:	55                   	push   %rbp
  80269b:	48 89 e5             	mov    %rsp,%rbp
  80269e:	41 54                	push   %r12
  8026a0:	53                   	push   %rbx
  8026a1:	48 89 fb             	mov    %rdi,%rbx
  8026a4:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8026a7:	48 b8 35 26 80 00 00 	movabs $0x802635,%rax
  8026ae:	00 00 00 
  8026b1:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  8026b3:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8026b7:	4c 89 e6             	mov    %r12,%rsi
  8026ba:	48 b8 7a 26 80 00 00 	movabs $0x80267a,%rax
  8026c1:	00 00 00 
  8026c4:	ff d0                	call   *%rax
    return dst;
}
  8026c6:	48 89 d8             	mov    %rbx,%rax
  8026c9:	5b                   	pop    %rbx
  8026ca:	41 5c                	pop    %r12
  8026cc:	5d                   	pop    %rbp
  8026cd:	c3                   	ret

00000000008026ce <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8026ce:	f3 0f 1e fa          	endbr64
  8026d2:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  8026d5:	48 85 d2             	test   %rdx,%rdx
  8026d8:	74 1f                	je     8026f9 <strncpy+0x2b>
  8026da:	48 01 fa             	add    %rdi,%rdx
  8026dd:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  8026e0:	48 83 c1 01          	add    $0x1,%rcx
  8026e4:	44 0f b6 06          	movzbl (%rsi),%r8d
  8026e8:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  8026ec:	41 80 f8 01          	cmp    $0x1,%r8b
  8026f0:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8026f4:	48 39 ca             	cmp    %rcx,%rdx
  8026f7:	75 e7                	jne    8026e0 <strncpy+0x12>
    }
    return ret;
}
  8026f9:	c3                   	ret

00000000008026fa <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  8026fa:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  8026fe:	48 89 f8             	mov    %rdi,%rax
  802701:	48 85 d2             	test   %rdx,%rdx
  802704:	74 24                	je     80272a <strlcpy+0x30>
        while (--size > 0 && *src)
  802706:	48 83 ea 01          	sub    $0x1,%rdx
  80270a:	74 1b                	je     802727 <strlcpy+0x2d>
  80270c:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  802710:	0f b6 16             	movzbl (%rsi),%edx
  802713:	84 d2                	test   %dl,%dl
  802715:	74 10                	je     802727 <strlcpy+0x2d>
            *dst++ = *src++;
  802717:	48 83 c6 01          	add    $0x1,%rsi
  80271b:	48 83 c0 01          	add    $0x1,%rax
  80271f:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  802722:	48 39 c8             	cmp    %rcx,%rax
  802725:	75 e9                	jne    802710 <strlcpy+0x16>
        *dst = '\0';
  802727:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  80272a:	48 29 f8             	sub    %rdi,%rax
}
  80272d:	c3                   	ret

000000000080272e <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  80272e:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  802732:	0f b6 07             	movzbl (%rdi),%eax
  802735:	84 c0                	test   %al,%al
  802737:	74 13                	je     80274c <strcmp+0x1e>
  802739:	38 06                	cmp    %al,(%rsi)
  80273b:	75 0f                	jne    80274c <strcmp+0x1e>
  80273d:	48 83 c7 01          	add    $0x1,%rdi
  802741:	48 83 c6 01          	add    $0x1,%rsi
  802745:	0f b6 07             	movzbl (%rdi),%eax
  802748:	84 c0                	test   %al,%al
  80274a:	75 ed                	jne    802739 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  80274c:	0f b6 c0             	movzbl %al,%eax
  80274f:	0f b6 16             	movzbl (%rsi),%edx
  802752:	29 d0                	sub    %edx,%eax
}
  802754:	c3                   	ret

0000000000802755 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  802755:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  802759:	48 85 d2             	test   %rdx,%rdx
  80275c:	74 1f                	je     80277d <strncmp+0x28>
  80275e:	0f b6 07             	movzbl (%rdi),%eax
  802761:	84 c0                	test   %al,%al
  802763:	74 1e                	je     802783 <strncmp+0x2e>
  802765:	3a 06                	cmp    (%rsi),%al
  802767:	75 1a                	jne    802783 <strncmp+0x2e>
  802769:	48 83 c7 01          	add    $0x1,%rdi
  80276d:	48 83 c6 01          	add    $0x1,%rsi
  802771:	48 83 ea 01          	sub    $0x1,%rdx
  802775:	75 e7                	jne    80275e <strncmp+0x9>

    if (!n) return 0;
  802777:	b8 00 00 00 00       	mov    $0x0,%eax
  80277c:	c3                   	ret
  80277d:	b8 00 00 00 00       	mov    $0x0,%eax
  802782:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  802783:	0f b6 07             	movzbl (%rdi),%eax
  802786:	0f b6 16             	movzbl (%rsi),%edx
  802789:	29 d0                	sub    %edx,%eax
}
  80278b:	c3                   	ret

000000000080278c <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  80278c:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  802790:	0f b6 17             	movzbl (%rdi),%edx
  802793:	84 d2                	test   %dl,%dl
  802795:	74 18                	je     8027af <strchr+0x23>
        if (*str == c) {
  802797:	0f be d2             	movsbl %dl,%edx
  80279a:	39 f2                	cmp    %esi,%edx
  80279c:	74 17                	je     8027b5 <strchr+0x29>
    for (; *str; str++) {
  80279e:	48 83 c7 01          	add    $0x1,%rdi
  8027a2:	0f b6 17             	movzbl (%rdi),%edx
  8027a5:	84 d2                	test   %dl,%dl
  8027a7:	75 ee                	jne    802797 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  8027a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ae:	c3                   	ret
  8027af:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b4:	c3                   	ret
            return (char *)str;
  8027b5:	48 89 f8             	mov    %rdi,%rax
}
  8027b8:	c3                   	ret

00000000008027b9 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  8027b9:	f3 0f 1e fa          	endbr64
  8027bd:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  8027c0:	0f b6 17             	movzbl (%rdi),%edx
  8027c3:	84 d2                	test   %dl,%dl
  8027c5:	74 13                	je     8027da <strfind+0x21>
  8027c7:	0f be d2             	movsbl %dl,%edx
  8027ca:	39 f2                	cmp    %esi,%edx
  8027cc:	74 0b                	je     8027d9 <strfind+0x20>
  8027ce:	48 83 c0 01          	add    $0x1,%rax
  8027d2:	0f b6 10             	movzbl (%rax),%edx
  8027d5:	84 d2                	test   %dl,%dl
  8027d7:	75 ee                	jne    8027c7 <strfind+0xe>
        ;
    return (char *)str;
}
  8027d9:	c3                   	ret
  8027da:	c3                   	ret

00000000008027db <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8027db:	f3 0f 1e fa          	endbr64
  8027df:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  8027e2:	48 89 f8             	mov    %rdi,%rax
  8027e5:	48 f7 d8             	neg    %rax
  8027e8:	83 e0 07             	and    $0x7,%eax
  8027eb:	49 89 d1             	mov    %rdx,%r9
  8027ee:	49 29 c1             	sub    %rax,%r9
  8027f1:	78 36                	js     802829 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8027f3:	40 0f b6 c6          	movzbl %sil,%eax
  8027f7:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  8027fe:	01 01 01 
  802801:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  802805:	40 f6 c7 07          	test   $0x7,%dil
  802809:	75 38                	jne    802843 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80280b:	4c 89 c9             	mov    %r9,%rcx
  80280e:	48 c1 f9 03          	sar    $0x3,%rcx
  802812:	74 0c                	je     802820 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  802814:	fc                   	cld
  802815:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802818:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  80281c:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  802820:	4d 85 c9             	test   %r9,%r9
  802823:	75 45                	jne    80286a <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  802825:	4c 89 c0             	mov    %r8,%rax
  802828:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  802829:	48 85 d2             	test   %rdx,%rdx
  80282c:	74 f7                	je     802825 <memset+0x4a>
  80282e:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  802831:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  802834:	48 83 c0 01          	add    $0x1,%rax
  802838:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  80283c:	48 39 c2             	cmp    %rax,%rdx
  80283f:	75 f3                	jne    802834 <memset+0x59>
  802841:	eb e2                	jmp    802825 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  802843:	40 f6 c7 01          	test   $0x1,%dil
  802847:	74 06                	je     80284f <memset+0x74>
  802849:	88 07                	mov    %al,(%rdi)
  80284b:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  80284f:	40 f6 c7 02          	test   $0x2,%dil
  802853:	74 07                	je     80285c <memset+0x81>
  802855:	66 89 07             	mov    %ax,(%rdi)
  802858:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  80285c:	40 f6 c7 04          	test   $0x4,%dil
  802860:	74 a9                	je     80280b <memset+0x30>
  802862:	89 07                	mov    %eax,(%rdi)
  802864:	48 83 c7 04          	add    $0x4,%rdi
  802868:	eb a1                	jmp    80280b <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  80286a:	41 f6 c1 04          	test   $0x4,%r9b
  80286e:	74 1b                	je     80288b <memset+0xb0>
  802870:	89 07                	mov    %eax,(%rdi)
  802872:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  802876:	41 f6 c1 02          	test   $0x2,%r9b
  80287a:	74 07                	je     802883 <memset+0xa8>
  80287c:	66 89 07             	mov    %ax,(%rdi)
  80287f:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  802883:	41 f6 c1 01          	test   $0x1,%r9b
  802887:	74 9c                	je     802825 <memset+0x4a>
  802889:	eb 06                	jmp    802891 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80288b:	41 f6 c1 02          	test   $0x2,%r9b
  80288f:	75 eb                	jne    80287c <memset+0xa1>
        if (ni & 1) *ptr = k;
  802891:	88 07                	mov    %al,(%rdi)
  802893:	eb 90                	jmp    802825 <memset+0x4a>

0000000000802895 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  802895:	f3 0f 1e fa          	endbr64
  802899:	48 89 f8             	mov    %rdi,%rax
  80289c:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  80289f:	48 39 fe             	cmp    %rdi,%rsi
  8028a2:	73 3b                	jae    8028df <memmove+0x4a>
  8028a4:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8028a8:	48 39 d7             	cmp    %rdx,%rdi
  8028ab:	73 32                	jae    8028df <memmove+0x4a>
        s += n;
        d += n;
  8028ad:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028b1:	48 89 d6             	mov    %rdx,%rsi
  8028b4:	48 09 fe             	or     %rdi,%rsi
  8028b7:	48 09 ce             	or     %rcx,%rsi
  8028ba:	40 f6 c6 07          	test   $0x7,%sil
  8028be:	75 12                	jne    8028d2 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8028c0:	48 83 ef 08          	sub    $0x8,%rdi
  8028c4:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8028c8:	48 c1 e9 03          	shr    $0x3,%rcx
  8028cc:	fd                   	std
  8028cd:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8028d0:	fc                   	cld
  8028d1:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8028d2:	48 83 ef 01          	sub    $0x1,%rdi
  8028d6:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8028da:	fd                   	std
  8028db:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8028dd:	eb f1                	jmp    8028d0 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028df:	48 89 f2             	mov    %rsi,%rdx
  8028e2:	48 09 c2             	or     %rax,%rdx
  8028e5:	48 09 ca             	or     %rcx,%rdx
  8028e8:	f6 c2 07             	test   $0x7,%dl
  8028eb:	75 0c                	jne    8028f9 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8028ed:	48 c1 e9 03          	shr    $0x3,%rcx
  8028f1:	48 89 c7             	mov    %rax,%rdi
  8028f4:	fc                   	cld
  8028f5:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8028f8:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8028f9:	48 89 c7             	mov    %rax,%rdi
  8028fc:	fc                   	cld
  8028fd:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8028ff:	c3                   	ret

0000000000802900 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  802900:	f3 0f 1e fa          	endbr64
  802904:	55                   	push   %rbp
  802905:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802908:	48 b8 95 28 80 00 00 	movabs $0x802895,%rax
  80290f:	00 00 00 
  802912:	ff d0                	call   *%rax
}
  802914:	5d                   	pop    %rbp
  802915:	c3                   	ret

0000000000802916 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  802916:	f3 0f 1e fa          	endbr64
  80291a:	55                   	push   %rbp
  80291b:	48 89 e5             	mov    %rsp,%rbp
  80291e:	41 57                	push   %r15
  802920:	41 56                	push   %r14
  802922:	41 55                	push   %r13
  802924:	41 54                	push   %r12
  802926:	53                   	push   %rbx
  802927:	48 83 ec 08          	sub    $0x8,%rsp
  80292b:	49 89 fe             	mov    %rdi,%r14
  80292e:	49 89 f7             	mov    %rsi,%r15
  802931:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  802934:	48 89 f7             	mov    %rsi,%rdi
  802937:	48 b8 35 26 80 00 00 	movabs $0x802635,%rax
  80293e:	00 00 00 
  802941:	ff d0                	call   *%rax
  802943:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  802946:	48 89 de             	mov    %rbx,%rsi
  802949:	4c 89 f7             	mov    %r14,%rdi
  80294c:	48 b8 54 26 80 00 00 	movabs $0x802654,%rax
  802953:	00 00 00 
  802956:	ff d0                	call   *%rax
  802958:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80295b:	48 39 c3             	cmp    %rax,%rbx
  80295e:	74 36                	je     802996 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  802960:	48 89 d8             	mov    %rbx,%rax
  802963:	4c 29 e8             	sub    %r13,%rax
  802966:	49 39 c4             	cmp    %rax,%r12
  802969:	73 31                	jae    80299c <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  80296b:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  802970:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  802974:	4c 89 fe             	mov    %r15,%rsi
  802977:	48 b8 00 29 80 00 00 	movabs $0x802900,%rax
  80297e:	00 00 00 
  802981:	ff d0                	call   *%rax
    return dstlen + srclen;
  802983:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  802987:	48 83 c4 08          	add    $0x8,%rsp
  80298b:	5b                   	pop    %rbx
  80298c:	41 5c                	pop    %r12
  80298e:	41 5d                	pop    %r13
  802990:	41 5e                	pop    %r14
  802992:	41 5f                	pop    %r15
  802994:	5d                   	pop    %rbp
  802995:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  802996:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  80299a:	eb eb                	jmp    802987 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  80299c:	48 83 eb 01          	sub    $0x1,%rbx
  8029a0:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8029a4:	48 89 da             	mov    %rbx,%rdx
  8029a7:	4c 89 fe             	mov    %r15,%rsi
  8029aa:	48 b8 00 29 80 00 00 	movabs $0x802900,%rax
  8029b1:	00 00 00 
  8029b4:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8029b6:	49 01 de             	add    %rbx,%r14
  8029b9:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8029be:	eb c3                	jmp    802983 <strlcat+0x6d>

00000000008029c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8029c0:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8029c4:	48 85 d2             	test   %rdx,%rdx
  8029c7:	74 2d                	je     8029f6 <memcmp+0x36>
  8029c9:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8029ce:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8029d2:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8029d7:	44 38 c1             	cmp    %r8b,%cl
  8029da:	75 0f                	jne    8029eb <memcmp+0x2b>
    while (n-- > 0) {
  8029dc:	48 83 c0 01          	add    $0x1,%rax
  8029e0:	48 39 c2             	cmp    %rax,%rdx
  8029e3:	75 e9                	jne    8029ce <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8029e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ea:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8029eb:	0f b6 c1             	movzbl %cl,%eax
  8029ee:	45 0f b6 c0          	movzbl %r8b,%r8d
  8029f2:	44 29 c0             	sub    %r8d,%eax
  8029f5:	c3                   	ret
    return 0;
  8029f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029fb:	c3                   	ret

00000000008029fc <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8029fc:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  802a00:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802a04:	48 39 c7             	cmp    %rax,%rdi
  802a07:	73 0f                	jae    802a18 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802a09:	40 38 37             	cmp    %sil,(%rdi)
  802a0c:	74 0e                	je     802a1c <memfind+0x20>
    for (; src < end; src++) {
  802a0e:	48 83 c7 01          	add    $0x1,%rdi
  802a12:	48 39 f8             	cmp    %rdi,%rax
  802a15:	75 f2                	jne    802a09 <memfind+0xd>
  802a17:	c3                   	ret
  802a18:	48 89 f8             	mov    %rdi,%rax
  802a1b:	c3                   	ret
  802a1c:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802a1f:	c3                   	ret

0000000000802a20 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802a20:	f3 0f 1e fa          	endbr64
  802a24:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802a27:	0f b6 37             	movzbl (%rdi),%esi
  802a2a:	40 80 fe 20          	cmp    $0x20,%sil
  802a2e:	74 06                	je     802a36 <strtol+0x16>
  802a30:	40 80 fe 09          	cmp    $0x9,%sil
  802a34:	75 13                	jne    802a49 <strtol+0x29>
  802a36:	48 83 c7 01          	add    $0x1,%rdi
  802a3a:	0f b6 37             	movzbl (%rdi),%esi
  802a3d:	40 80 fe 20          	cmp    $0x20,%sil
  802a41:	74 f3                	je     802a36 <strtol+0x16>
  802a43:	40 80 fe 09          	cmp    $0x9,%sil
  802a47:	74 ed                	je     802a36 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802a49:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802a4c:	83 e0 fd             	and    $0xfffffffd,%eax
  802a4f:	3c 01                	cmp    $0x1,%al
  802a51:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a55:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  802a5b:	75 0f                	jne    802a6c <strtol+0x4c>
  802a5d:	80 3f 30             	cmpb   $0x30,(%rdi)
  802a60:	74 14                	je     802a76 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802a62:	85 d2                	test   %edx,%edx
  802a64:	b8 0a 00 00 00       	mov    $0xa,%eax
  802a69:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  802a6c:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  802a71:	4c 63 ca             	movslq %edx,%r9
  802a74:	eb 36                	jmp    802aac <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a76:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  802a7a:	74 0f                	je     802a8b <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  802a7c:	85 d2                	test   %edx,%edx
  802a7e:	75 ec                	jne    802a6c <strtol+0x4c>
        s++;
  802a80:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  802a84:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  802a89:	eb e1                	jmp    802a6c <strtol+0x4c>
        s += 2;
  802a8b:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  802a8f:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  802a94:	eb d6                	jmp    802a6c <strtol+0x4c>
            dig -= '0';
  802a96:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  802a99:	44 0f b6 c1          	movzbl %cl,%r8d
  802a9d:	41 39 d0             	cmp    %edx,%r8d
  802aa0:	7d 21                	jge    802ac3 <strtol+0xa3>
        val = val * base + dig;
  802aa2:	49 0f af c1          	imul   %r9,%rax
  802aa6:	0f b6 c9             	movzbl %cl,%ecx
  802aa9:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  802aac:	48 83 c7 01          	add    $0x1,%rdi
  802ab0:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  802ab4:	80 f9 39             	cmp    $0x39,%cl
  802ab7:	76 dd                	jbe    802a96 <strtol+0x76>
        else if (dig - 'a' < 27)
  802ab9:	80 f9 7b             	cmp    $0x7b,%cl
  802abc:	77 05                	ja     802ac3 <strtol+0xa3>
            dig -= 'a' - 10;
  802abe:	83 e9 57             	sub    $0x57,%ecx
  802ac1:	eb d6                	jmp    802a99 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  802ac3:	4d 85 d2             	test   %r10,%r10
  802ac6:	74 03                	je     802acb <strtol+0xab>
  802ac8:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802acb:	48 89 c2             	mov    %rax,%rdx
  802ace:	48 f7 da             	neg    %rdx
  802ad1:	40 80 fe 2d          	cmp    $0x2d,%sil
  802ad5:	48 0f 44 c2          	cmove  %rdx,%rax
}
  802ad9:	c3                   	ret

0000000000802ada <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802ada:	f3 0f 1e fa          	endbr64
  802ade:	55                   	push   %rbp
  802adf:	48 89 e5             	mov    %rsp,%rbp
  802ae2:	41 54                	push   %r12
  802ae4:	53                   	push   %rbx
  802ae5:	48 89 fb             	mov    %rdi,%rbx
  802ae8:	48 89 f7             	mov    %rsi,%rdi
  802aeb:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802aee:	48 85 f6             	test   %rsi,%rsi
  802af1:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802af8:	00 00 00 
  802afb:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802aff:	be 00 10 00 00       	mov    $0x1000,%esi
  802b04:	48 b8 cc 05 80 00 00 	movabs $0x8005cc,%rax
  802b0b:	00 00 00 
  802b0e:	ff d0                	call   *%rax
    if (res < 0) {
  802b10:	85 c0                	test   %eax,%eax
  802b12:	78 45                	js     802b59 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b14:	48 85 db             	test   %rbx,%rbx
  802b17:	74 12                	je     802b2b <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b19:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b20:	00 00 00 
  802b23:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b29:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b2b:	4d 85 e4             	test   %r12,%r12
  802b2e:	74 14                	je     802b44 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b30:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b37:	00 00 00 
  802b3a:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b40:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b44:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b4b:	00 00 00 
  802b4e:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b54:	5b                   	pop    %rbx
  802b55:	41 5c                	pop    %r12
  802b57:	5d                   	pop    %rbp
  802b58:	c3                   	ret
        if (from_env_store != NULL) {
  802b59:	48 85 db             	test   %rbx,%rbx
  802b5c:	74 06                	je     802b64 <ipc_recv+0x8a>
            *from_env_store = 0;
  802b5e:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b64:	4d 85 e4             	test   %r12,%r12
  802b67:	74 eb                	je     802b54 <ipc_recv+0x7a>
            *perm_store = 0;
  802b69:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b70:	00 
  802b71:	eb e1                	jmp    802b54 <ipc_recv+0x7a>

0000000000802b73 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b73:	f3 0f 1e fa          	endbr64
  802b77:	55                   	push   %rbp
  802b78:	48 89 e5             	mov    %rsp,%rbp
  802b7b:	41 57                	push   %r15
  802b7d:	41 56                	push   %r14
  802b7f:	41 55                	push   %r13
  802b81:	41 54                	push   %r12
  802b83:	53                   	push   %rbx
  802b84:	48 83 ec 18          	sub    $0x18,%rsp
  802b88:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802b8b:	48 89 d3             	mov    %rdx,%rbx
  802b8e:	49 89 cc             	mov    %rcx,%r12
  802b91:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b94:	48 85 d2             	test   %rdx,%rdx
  802b97:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b9e:	00 00 00 
  802ba1:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802ba5:	89 f0                	mov    %esi,%eax
  802ba7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802bab:	48 89 da             	mov    %rbx,%rdx
  802bae:	48 89 c6             	mov    %rax,%rsi
  802bb1:	48 b8 9c 05 80 00 00 	movabs $0x80059c,%rax
  802bb8:	00 00 00 
  802bbb:	ff d0                	call   *%rax
    while (res < 0) {
  802bbd:	85 c0                	test   %eax,%eax
  802bbf:	79 65                	jns    802c26 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bc1:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bc4:	75 33                	jne    802bf9 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802bc6:	49 bf 0f 02 80 00 00 	movabs $0x80020f,%r15
  802bcd:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bd0:	49 be 9c 05 80 00 00 	movabs $0x80059c,%r14
  802bd7:	00 00 00 
        sys_yield();
  802bda:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bdd:	45 89 e8             	mov    %r13d,%r8d
  802be0:	4c 89 e1             	mov    %r12,%rcx
  802be3:	48 89 da             	mov    %rbx,%rdx
  802be6:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802bea:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802bed:	41 ff d6             	call   *%r14
    while (res < 0) {
  802bf0:	85 c0                	test   %eax,%eax
  802bf2:	79 32                	jns    802c26 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bf4:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bf7:	74 e1                	je     802bda <ipc_send+0x67>
            panic("Error: %i\n", res);
  802bf9:	89 c1                	mov    %eax,%ecx
  802bfb:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  802c02:	00 00 00 
  802c05:	be 42 00 00 00       	mov    $0x42,%esi
  802c0a:	48 bf 4b 32 80 00 00 	movabs $0x80324b,%rdi
  802c11:	00 00 00 
  802c14:	b8 00 00 00 00       	mov    $0x0,%eax
  802c19:	49 b8 d5 1b 80 00 00 	movabs $0x801bd5,%r8
  802c20:	00 00 00 
  802c23:	41 ff d0             	call   *%r8
    }
}
  802c26:	48 83 c4 18          	add    $0x18,%rsp
  802c2a:	5b                   	pop    %rbx
  802c2b:	41 5c                	pop    %r12
  802c2d:	41 5d                	pop    %r13
  802c2f:	41 5e                	pop    %r14
  802c31:	41 5f                	pop    %r15
  802c33:	5d                   	pop    %rbp
  802c34:	c3                   	ret

0000000000802c35 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c35:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c39:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c3e:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c45:	00 00 00 
  802c48:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c4c:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c50:	48 c1 e2 04          	shl    $0x4,%rdx
  802c54:	48 01 ca             	add    %rcx,%rdx
  802c57:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c5d:	39 fa                	cmp    %edi,%edx
  802c5f:	74 12                	je     802c73 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c61:	48 83 c0 01          	add    $0x1,%rax
  802c65:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c6b:	75 db                	jne    802c48 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802c6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c72:	c3                   	ret
            return envs[i].env_id;
  802c73:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c77:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c7b:	48 c1 e2 04          	shl    $0x4,%rdx
  802c7f:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802c86:	00 00 00 
  802c89:	48 01 d0             	add    %rdx,%rax
  802c8c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c92:	c3                   	ret

0000000000802c93 <__text_end>:
  802c93:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802c9a:	00 00 00 
  802c9d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ca4:	00 00 00 
  802ca7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cae:	00 00 00 
  802cb1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cb8:	00 00 00 
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
