
obj/user/evilhello:     file format elf64-x86-64


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
  80001e:	e8 27 00 00 00       	call   80004a <libmain>
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
    /* try to print the kernel entry point as a string!  mua ha ha! */
    sys_cputs((char *)0x804020000c, 100);
  80002d:	be 64 00 00 00       	mov    $0x64,%esi
  800032:	48 bf 0c 00 20 40 80 	movabs $0x804020000c,%rdi
  800039:	00 00 00 
  80003c:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  800043:	00 00 00 
  800046:	ff d0                	call   *%rax
}
  800048:	5d                   	pop    %rbp
  800049:	c3                   	ret

000000000080004a <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80004a:	f3 0f 1e fa          	endbr64
  80004e:	55                   	push   %rbp
  80004f:	48 89 e5             	mov    %rsp,%rbp
  800052:	41 56                	push   %r14
  800054:	41 55                	push   %r13
  800056:	41 54                	push   %r12
  800058:	53                   	push   %rbx
  800059:	41 89 fd             	mov    %edi,%r13d
  80005c:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80005f:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800066:	00 00 00 
  800069:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800070:	00 00 00 
  800073:	48 39 c2             	cmp    %rax,%rdx
  800076:	73 17                	jae    80008f <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800078:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80007b:	49 89 c4             	mov    %rax,%r12
  80007e:	48 83 c3 08          	add    $0x8,%rbx
  800082:	b8 00 00 00 00       	mov    $0x0,%eax
  800087:	ff 53 f8             	call   *-0x8(%rbx)
  80008a:	4c 39 e3             	cmp    %r12,%rbx
  80008d:	72 ef                	jb     80007e <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  80008f:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  800096:	00 00 00 
  800099:	ff d0                	call   *%rax
  80009b:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a0:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000a4:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000a8:	48 c1 e0 04          	shl    $0x4,%rax
  8000ac:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000b3:	00 00 00 
  8000b6:	48 01 d0             	add    %rdx,%rax
  8000b9:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000c0:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000c3:	45 85 ed             	test   %r13d,%r13d
  8000c6:	7e 0d                	jle    8000d5 <libmain+0x8b>
  8000c8:	49 8b 06             	mov    (%r14),%rax
  8000cb:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000d2:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000d5:	4c 89 f6             	mov    %r14,%rsi
  8000d8:	44 89 ef             	mov    %r13d,%edi
  8000db:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000e2:	00 00 00 
  8000e5:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000e7:	48 b8 fc 00 80 00 00 	movabs $0x8000fc,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	call   *%rax
#endif
}
  8000f3:	5b                   	pop    %rbx
  8000f4:	41 5c                	pop    %r12
  8000f6:	41 5d                	pop    %r13
  8000f8:	41 5e                	pop    %r14
  8000fa:	5d                   	pop    %rbp
  8000fb:	c3                   	ret

00000000008000fc <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000fc:	f3 0f 1e fa          	endbr64
  800100:	55                   	push   %rbp
  800101:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800104:	48 b8 ce 08 80 00 00 	movabs $0x8008ce,%rax
  80010b:	00 00 00 
  80010e:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800110:	bf 00 00 00 00       	mov    $0x0,%edi
  800115:	48 b8 89 01 80 00 00 	movabs $0x800189,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	call   *%rax
}
  800121:	5d                   	pop    %rbp
  800122:	c3                   	ret

0000000000800123 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800123:	f3 0f 1e fa          	endbr64
  800127:	55                   	push   %rbp
  800128:	48 89 e5             	mov    %rsp,%rbp
  80012b:	53                   	push   %rbx
  80012c:	48 89 fa             	mov    %rdi,%rdx
  80012f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800132:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800137:	bb 00 00 00 00       	mov    $0x0,%ebx
  80013c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800141:	be 00 00 00 00       	mov    $0x0,%esi
  800146:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80014c:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80014e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800152:	c9                   	leave
  800153:	c3                   	ret

0000000000800154 <sys_cgetc>:

int
sys_cgetc(void) {
  800154:	f3 0f 1e fa          	endbr64
  800158:	55                   	push   %rbp
  800159:	48 89 e5             	mov    %rsp,%rbp
  80015c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80015d:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800162:	ba 00 00 00 00       	mov    $0x0,%edx
  800167:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80016c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800171:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800176:	be 00 00 00 00       	mov    $0x0,%esi
  80017b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800181:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800183:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800187:	c9                   	leave
  800188:	c3                   	ret

0000000000800189 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800189:	f3 0f 1e fa          	endbr64
  80018d:	55                   	push   %rbp
  80018e:	48 89 e5             	mov    %rsp,%rbp
  800191:	53                   	push   %rbx
  800192:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800196:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800199:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80019e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8001a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001a8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8001ad:	be 00 00 00 00       	mov    $0x0,%esi
  8001b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8001b8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8001ba:	48 85 c0             	test   %rax,%rax
  8001bd:	7f 06                	jg     8001c5 <sys_env_destroy+0x3c>
}
  8001bf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001c3:	c9                   	leave
  8001c4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8001c5:	49 89 c0             	mov    %rax,%r8
  8001c8:	b9 03 00 00 00       	mov    $0x3,%ecx
  8001cd:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8001d4:	00 00 00 
  8001d7:	be 26 00 00 00       	mov    $0x26,%esi
  8001dc:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8001e3:	00 00 00 
  8001e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001eb:	49 b9 f3 1b 80 00 00 	movabs $0x801bf3,%r9
  8001f2:	00 00 00 
  8001f5:	41 ff d1             	call   *%r9

00000000008001f8 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8001f8:	f3 0f 1e fa          	endbr64
  8001fc:	55                   	push   %rbp
  8001fd:	48 89 e5             	mov    %rsp,%rbp
  800200:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800201:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800206:	ba 00 00 00 00       	mov    $0x0,%edx
  80020b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800210:	bb 00 00 00 00       	mov    $0x0,%ebx
  800215:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80021a:	be 00 00 00 00       	mov    $0x0,%esi
  80021f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800225:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800227:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80022b:	c9                   	leave
  80022c:	c3                   	ret

000000000080022d <sys_yield>:

void
sys_yield(void) {
  80022d:	f3 0f 1e fa          	endbr64
  800231:	55                   	push   %rbp
  800232:	48 89 e5             	mov    %rsp,%rbp
  800235:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800236:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80023b:	ba 00 00 00 00       	mov    $0x0,%edx
  800240:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800245:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80024f:	be 00 00 00 00       	mov    $0x0,%esi
  800254:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80025a:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80025c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800260:	c9                   	leave
  800261:	c3                   	ret

0000000000800262 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  800262:	f3 0f 1e fa          	endbr64
  800266:	55                   	push   %rbp
  800267:	48 89 e5             	mov    %rsp,%rbp
  80026a:	53                   	push   %rbx
  80026b:	48 89 fa             	mov    %rdi,%rdx
  80026e:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800271:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800276:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80027d:	00 00 00 
  800280:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800285:	be 00 00 00 00       	mov    $0x0,%esi
  80028a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800290:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800292:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800296:	c9                   	leave
  800297:	c3                   	ret

0000000000800298 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  800298:	f3 0f 1e fa          	endbr64
  80029c:	55                   	push   %rbp
  80029d:	48 89 e5             	mov    %rsp,%rbp
  8002a0:	53                   	push   %rbx
  8002a1:	49 89 f8             	mov    %rdi,%r8
  8002a4:	48 89 d3             	mov    %rdx,%rbx
  8002a7:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8002aa:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002af:	4c 89 c2             	mov    %r8,%rdx
  8002b2:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002b5:	be 00 00 00 00       	mov    $0x0,%esi
  8002ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002c0:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8002c2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002c6:	c9                   	leave
  8002c7:	c3                   	ret

00000000008002c8 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8002c8:	f3 0f 1e fa          	endbr64
  8002cc:	55                   	push   %rbp
  8002cd:	48 89 e5             	mov    %rsp,%rbp
  8002d0:	53                   	push   %rbx
  8002d1:	48 83 ec 08          	sub    $0x8,%rsp
  8002d5:	89 f8                	mov    %edi,%eax
  8002d7:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8002da:	48 63 f9             	movslq %ecx,%rdi
  8002dd:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8002e0:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8002e5:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8002e8:	be 00 00 00 00       	mov    $0x0,%esi
  8002ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8002f3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8002f5:	48 85 c0             	test   %rax,%rax
  8002f8:	7f 06                	jg     800300 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8002fa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002fe:	c9                   	leave
  8002ff:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800300:	49 89 c0             	mov    %rax,%r8
  800303:	b9 04 00 00 00       	mov    $0x4,%ecx
  800308:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80030f:	00 00 00 
  800312:	be 26 00 00 00       	mov    $0x26,%esi
  800317:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80031e:	00 00 00 
  800321:	b8 00 00 00 00       	mov    $0x0,%eax
  800326:	49 b9 f3 1b 80 00 00 	movabs $0x801bf3,%r9
  80032d:	00 00 00 
  800330:	41 ff d1             	call   *%r9

0000000000800333 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  800333:	f3 0f 1e fa          	endbr64
  800337:	55                   	push   %rbp
  800338:	48 89 e5             	mov    %rsp,%rbp
  80033b:	53                   	push   %rbx
  80033c:	48 83 ec 08          	sub    $0x8,%rsp
  800340:	89 f8                	mov    %edi,%eax
  800342:	49 89 f2             	mov    %rsi,%r10
  800345:	48 89 cf             	mov    %rcx,%rdi
  800348:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80034b:	48 63 da             	movslq %edx,%rbx
  80034e:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800351:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800356:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800359:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80035c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80035e:	48 85 c0             	test   %rax,%rax
  800361:	7f 06                	jg     800369 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  800363:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800367:	c9                   	leave
  800368:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800369:	49 89 c0             	mov    %rax,%r8
  80036c:	b9 05 00 00 00       	mov    $0x5,%ecx
  800371:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800378:	00 00 00 
  80037b:	be 26 00 00 00       	mov    $0x26,%esi
  800380:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800387:	00 00 00 
  80038a:	b8 00 00 00 00       	mov    $0x0,%eax
  80038f:	49 b9 f3 1b 80 00 00 	movabs $0x801bf3,%r9
  800396:	00 00 00 
  800399:	41 ff d1             	call   *%r9

000000000080039c <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80039c:	f3 0f 1e fa          	endbr64
  8003a0:	55                   	push   %rbp
  8003a1:	48 89 e5             	mov    %rsp,%rbp
  8003a4:	53                   	push   %rbx
  8003a5:	48 83 ec 08          	sub    $0x8,%rsp
  8003a9:	49 89 f9             	mov    %rdi,%r9
  8003ac:	89 f0                	mov    %esi,%eax
  8003ae:	48 89 d3             	mov    %rdx,%rbx
  8003b1:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8003b4:	49 63 f0             	movslq %r8d,%rsi
  8003b7:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8003ba:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8003bf:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8003c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8003c8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8003ca:	48 85 c0             	test   %rax,%rax
  8003cd:	7f 06                	jg     8003d5 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8003cf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003d3:	c9                   	leave
  8003d4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8003d5:	49 89 c0             	mov    %rax,%r8
  8003d8:	b9 06 00 00 00       	mov    $0x6,%ecx
  8003dd:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8003e4:	00 00 00 
  8003e7:	be 26 00 00 00       	mov    $0x26,%esi
  8003ec:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8003f3:	00 00 00 
  8003f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fb:	49 b9 f3 1b 80 00 00 	movabs $0x801bf3,%r9
  800402:	00 00 00 
  800405:	41 ff d1             	call   *%r9

0000000000800408 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  800408:	f3 0f 1e fa          	endbr64
  80040c:	55                   	push   %rbp
  80040d:	48 89 e5             	mov    %rsp,%rbp
  800410:	53                   	push   %rbx
  800411:	48 83 ec 08          	sub    $0x8,%rsp
  800415:	48 89 f1             	mov    %rsi,%rcx
  800418:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80041b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80041e:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800423:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800428:	be 00 00 00 00       	mov    $0x0,%esi
  80042d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800433:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800435:	48 85 c0             	test   %rax,%rax
  800438:	7f 06                	jg     800440 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80043a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80043e:	c9                   	leave
  80043f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800440:	49 89 c0             	mov    %rax,%r8
  800443:	b9 07 00 00 00       	mov    $0x7,%ecx
  800448:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  80044f:	00 00 00 
  800452:	be 26 00 00 00       	mov    $0x26,%esi
  800457:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  80045e:	00 00 00 
  800461:	b8 00 00 00 00       	mov    $0x0,%eax
  800466:	49 b9 f3 1b 80 00 00 	movabs $0x801bf3,%r9
  80046d:	00 00 00 
  800470:	41 ff d1             	call   *%r9

0000000000800473 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  800473:	f3 0f 1e fa          	endbr64
  800477:	55                   	push   %rbp
  800478:	48 89 e5             	mov    %rsp,%rbp
  80047b:	53                   	push   %rbx
  80047c:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  800480:	48 63 ce             	movslq %esi,%rcx
  800483:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800486:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80048b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800490:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800495:	be 00 00 00 00       	mov    $0x0,%esi
  80049a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8004a0:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8004a2:	48 85 c0             	test   %rax,%rax
  8004a5:	7f 06                	jg     8004ad <sys_env_set_status+0x3a>
}
  8004a7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004ab:	c9                   	leave
  8004ac:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8004ad:	49 89 c0             	mov    %rax,%r8
  8004b0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8004b5:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  8004bc:	00 00 00 
  8004bf:	be 26 00 00 00       	mov    $0x26,%esi
  8004c4:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8004cb:	00 00 00 
  8004ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d3:	49 b9 f3 1b 80 00 00 	movabs $0x801bf3,%r9
  8004da:	00 00 00 
  8004dd:	41 ff d1             	call   *%r9

00000000008004e0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8004e0:	f3 0f 1e fa          	endbr64
  8004e4:	55                   	push   %rbp
  8004e5:	48 89 e5             	mov    %rsp,%rbp
  8004e8:	53                   	push   %rbx
  8004e9:	48 83 ec 08          	sub    $0x8,%rsp
  8004ed:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8004f0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8004f3:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8004f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004fd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800502:	be 00 00 00 00       	mov    $0x0,%esi
  800507:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80050d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80050f:	48 85 c0             	test   %rax,%rax
  800512:	7f 06                	jg     80051a <sys_env_set_trapframe+0x3a>
}
  800514:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800518:	c9                   	leave
  800519:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80051a:	49 89 c0             	mov    %rax,%r8
  80051d:	b9 0b 00 00 00       	mov    $0xb,%ecx
  800522:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800529:	00 00 00 
  80052c:	be 26 00 00 00       	mov    $0x26,%esi
  800531:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800538:	00 00 00 
  80053b:	b8 00 00 00 00       	mov    $0x0,%eax
  800540:	49 b9 f3 1b 80 00 00 	movabs $0x801bf3,%r9
  800547:	00 00 00 
  80054a:	41 ff d1             	call   *%r9

000000000080054d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80054d:	f3 0f 1e fa          	endbr64
  800551:	55                   	push   %rbp
  800552:	48 89 e5             	mov    %rsp,%rbp
  800555:	53                   	push   %rbx
  800556:	48 83 ec 08          	sub    $0x8,%rsp
  80055a:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80055d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800560:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800565:	bb 00 00 00 00       	mov    $0x0,%ebx
  80056a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80056f:	be 00 00 00 00       	mov    $0x0,%esi
  800574:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80057a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80057c:	48 85 c0             	test   %rax,%rax
  80057f:	7f 06                	jg     800587 <sys_env_set_pgfault_upcall+0x3a>
}
  800581:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800585:	c9                   	leave
  800586:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800587:	49 89 c0             	mov    %rax,%r8
  80058a:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80058f:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800596:	00 00 00 
  800599:	be 26 00 00 00       	mov    $0x26,%esi
  80059e:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  8005a5:	00 00 00 
  8005a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ad:	49 b9 f3 1b 80 00 00 	movabs $0x801bf3,%r9
  8005b4:	00 00 00 
  8005b7:	41 ff d1             	call   *%r9

00000000008005ba <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8005ba:	f3 0f 1e fa          	endbr64
  8005be:	55                   	push   %rbp
  8005bf:	48 89 e5             	mov    %rsp,%rbp
  8005c2:	53                   	push   %rbx
  8005c3:	89 f8                	mov    %edi,%eax
  8005c5:	49 89 f1             	mov    %rsi,%r9
  8005c8:	48 89 d3             	mov    %rdx,%rbx
  8005cb:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8005ce:	49 63 f0             	movslq %r8d,%rsi
  8005d1:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8005d4:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8005d9:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8005dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8005e2:	cd 30                	int    $0x30
}
  8005e4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005e8:	c9                   	leave
  8005e9:	c3                   	ret

00000000008005ea <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8005ea:	f3 0f 1e fa          	endbr64
  8005ee:	55                   	push   %rbp
  8005ef:	48 89 e5             	mov    %rsp,%rbp
  8005f2:	53                   	push   %rbx
  8005f3:	48 83 ec 08          	sub    $0x8,%rsp
  8005f7:	48 89 fa             	mov    %rdi,%rdx
  8005fa:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8005fd:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800602:	bb 00 00 00 00       	mov    $0x0,%ebx
  800607:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80060c:	be 00 00 00 00       	mov    $0x0,%esi
  800611:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800617:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800619:	48 85 c0             	test   %rax,%rax
  80061c:	7f 06                	jg     800624 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80061e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800622:	c9                   	leave
  800623:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800624:	49 89 c0             	mov    %rax,%r8
  800627:	b9 0f 00 00 00       	mov    $0xf,%ecx
  80062c:	48 ba 58 32 80 00 00 	movabs $0x803258,%rdx
  800633:	00 00 00 
  800636:	be 26 00 00 00       	mov    $0x26,%esi
  80063b:	48 bf 0a 30 80 00 00 	movabs $0x80300a,%rdi
  800642:	00 00 00 
  800645:	b8 00 00 00 00       	mov    $0x0,%eax
  80064a:	49 b9 f3 1b 80 00 00 	movabs $0x801bf3,%r9
  800651:	00 00 00 
  800654:	41 ff d1             	call   *%r9

0000000000800657 <sys_gettime>:

int
sys_gettime(void) {
  800657:	f3 0f 1e fa          	endbr64
  80065b:	55                   	push   %rbp
  80065c:	48 89 e5             	mov    %rsp,%rbp
  80065f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800660:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80066f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800674:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800679:	be 00 00 00 00       	mov    $0x0,%esi
  80067e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800684:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  800686:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80068a:	c9                   	leave
  80068b:	c3                   	ret

000000000080068c <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  80068c:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800690:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800697:	ff ff ff 
  80069a:	48 01 f8             	add    %rdi,%rax
  80069d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8006a1:	c3                   	ret

00000000008006a2 <fd2data>:

char *
fd2data(struct Fd *fd) {
  8006a2:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8006a6:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8006ad:	ff ff ff 
  8006b0:	48 01 f8             	add    %rdi,%rax
  8006b3:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8006b7:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8006bd:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8006c1:	c3                   	ret

00000000008006c2 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8006c2:	f3 0f 1e fa          	endbr64
  8006c6:	55                   	push   %rbp
  8006c7:	48 89 e5             	mov    %rsp,%rbp
  8006ca:	41 57                	push   %r15
  8006cc:	41 56                	push   %r14
  8006ce:	41 55                	push   %r13
  8006d0:	41 54                	push   %r12
  8006d2:	53                   	push   %rbx
  8006d3:	48 83 ec 08          	sub    $0x8,%rsp
  8006d7:	49 89 ff             	mov    %rdi,%r15
  8006da:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8006df:	49 bd 21 18 80 00 00 	movabs $0x801821,%r13
  8006e6:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8006e9:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8006ef:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8006f2:	48 89 df             	mov    %rbx,%rdi
  8006f5:	41 ff d5             	call   *%r13
  8006f8:	83 e0 04             	and    $0x4,%eax
  8006fb:	74 17                	je     800714 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8006fd:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  800704:	4c 39 f3             	cmp    %r14,%rbx
  800707:	75 e6                	jne    8006ef <fd_alloc+0x2d>
  800709:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  80070f:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  800714:	4d 89 27             	mov    %r12,(%r15)
}
  800717:	48 83 c4 08          	add    $0x8,%rsp
  80071b:	5b                   	pop    %rbx
  80071c:	41 5c                	pop    %r12
  80071e:	41 5d                	pop    %r13
  800720:	41 5e                	pop    %r14
  800722:	41 5f                	pop    %r15
  800724:	5d                   	pop    %rbp
  800725:	c3                   	ret

0000000000800726 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  800726:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  80072a:	83 ff 1f             	cmp    $0x1f,%edi
  80072d:	77 39                	ja     800768 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80072f:	55                   	push   %rbp
  800730:	48 89 e5             	mov    %rsp,%rbp
  800733:	41 54                	push   %r12
  800735:	53                   	push   %rbx
  800736:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  800739:	48 63 df             	movslq %edi,%rbx
  80073c:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  800743:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800747:	48 89 df             	mov    %rbx,%rdi
  80074a:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  800751:	00 00 00 
  800754:	ff d0                	call   *%rax
  800756:	a8 04                	test   $0x4,%al
  800758:	74 14                	je     80076e <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80075a:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80075e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800763:	5b                   	pop    %rbx
  800764:	41 5c                	pop    %r12
  800766:	5d                   	pop    %rbp
  800767:	c3                   	ret
        return -E_INVAL;
  800768:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80076d:	c3                   	ret
        return -E_INVAL;
  80076e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800773:	eb ee                	jmp    800763 <fd_lookup+0x3d>

0000000000800775 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  800775:	f3 0f 1e fa          	endbr64
  800779:	55                   	push   %rbp
  80077a:	48 89 e5             	mov    %rsp,%rbp
  80077d:	41 54                	push   %r12
  80077f:	53                   	push   %rbx
  800780:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  800783:	48 b8 40 33 80 00 00 	movabs $0x803340,%rax
  80078a:	00 00 00 
  80078d:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  800794:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  800797:	39 3b                	cmp    %edi,(%rbx)
  800799:	74 47                	je     8007e2 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  80079b:	48 83 c0 08          	add    $0x8,%rax
  80079f:	48 8b 18             	mov    (%rax),%rbx
  8007a2:	48 85 db             	test   %rbx,%rbx
  8007a5:	75 f0                	jne    800797 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8007a7:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8007ae:	00 00 00 
  8007b1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8007b7:	89 fa                	mov    %edi,%edx
  8007b9:	48 bf 78 32 80 00 00 	movabs $0x803278,%rdi
  8007c0:	00 00 00 
  8007c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c8:	48 b9 4f 1d 80 00 00 	movabs $0x801d4f,%rcx
  8007cf:	00 00 00 
  8007d2:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8007d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8007d9:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8007dd:	5b                   	pop    %rbx
  8007de:	41 5c                	pop    %r12
  8007e0:	5d                   	pop    %rbp
  8007e1:	c3                   	ret
            return 0;
  8007e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e7:	eb f0                	jmp    8007d9 <dev_lookup+0x64>

00000000008007e9 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8007e9:	f3 0f 1e fa          	endbr64
  8007ed:	55                   	push   %rbp
  8007ee:	48 89 e5             	mov    %rsp,%rbp
  8007f1:	41 55                	push   %r13
  8007f3:	41 54                	push   %r12
  8007f5:	53                   	push   %rbx
  8007f6:	48 83 ec 18          	sub    $0x18,%rsp
  8007fa:	48 89 fb             	mov    %rdi,%rbx
  8007fd:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800800:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  800807:	ff ff ff 
  80080a:	48 01 df             	add    %rbx,%rdi
  80080d:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  800811:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800815:	48 b8 26 07 80 00 00 	movabs $0x800726,%rax
  80081c:	00 00 00 
  80081f:	ff d0                	call   *%rax
  800821:	41 89 c5             	mov    %eax,%r13d
  800824:	85 c0                	test   %eax,%eax
  800826:	78 06                	js     80082e <fd_close+0x45>
  800828:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  80082c:	74 1a                	je     800848 <fd_close+0x5f>
        return (must_exist ? res : 0);
  80082e:	45 84 e4             	test   %r12b,%r12b
  800831:	b8 00 00 00 00       	mov    $0x0,%eax
  800836:	44 0f 44 e8          	cmove  %eax,%r13d
}
  80083a:	44 89 e8             	mov    %r13d,%eax
  80083d:	48 83 c4 18          	add    $0x18,%rsp
  800841:	5b                   	pop    %rbx
  800842:	41 5c                	pop    %r12
  800844:	41 5d                	pop    %r13
  800846:	5d                   	pop    %rbp
  800847:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800848:	8b 3b                	mov    (%rbx),%edi
  80084a:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80084e:	48 b8 75 07 80 00 00 	movabs $0x800775,%rax
  800855:	00 00 00 
  800858:	ff d0                	call   *%rax
  80085a:	41 89 c5             	mov    %eax,%r13d
  80085d:	85 c0                	test   %eax,%eax
  80085f:	78 1b                	js     80087c <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  800861:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800865:	48 8b 40 20          	mov    0x20(%rax),%rax
  800869:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80086f:	48 85 c0             	test   %rax,%rax
  800872:	74 08                	je     80087c <fd_close+0x93>
  800874:	48 89 df             	mov    %rbx,%rdi
  800877:	ff d0                	call   *%rax
  800879:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80087c:	ba 00 10 00 00       	mov    $0x1000,%edx
  800881:	48 89 de             	mov    %rbx,%rsi
  800884:	bf 00 00 00 00       	mov    $0x0,%edi
  800889:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800890:	00 00 00 
  800893:	ff d0                	call   *%rax
    return res;
  800895:	eb a3                	jmp    80083a <fd_close+0x51>

0000000000800897 <close>:

int
close(int fdnum) {
  800897:	f3 0f 1e fa          	endbr64
  80089b:	55                   	push   %rbp
  80089c:	48 89 e5             	mov    %rsp,%rbp
  80089f:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8008a3:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8008a7:	48 b8 26 07 80 00 00 	movabs $0x800726,%rax
  8008ae:	00 00 00 
  8008b1:	ff d0                	call   *%rax
    if (res < 0) return res;
  8008b3:	85 c0                	test   %eax,%eax
  8008b5:	78 15                	js     8008cc <close+0x35>

    return fd_close(fd, 1);
  8008b7:	be 01 00 00 00       	mov    $0x1,%esi
  8008bc:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8008c0:	48 b8 e9 07 80 00 00 	movabs $0x8007e9,%rax
  8008c7:	00 00 00 
  8008ca:	ff d0                	call   *%rax
}
  8008cc:	c9                   	leave
  8008cd:	c3                   	ret

00000000008008ce <close_all>:

void
close_all(void) {
  8008ce:	f3 0f 1e fa          	endbr64
  8008d2:	55                   	push   %rbp
  8008d3:	48 89 e5             	mov    %rsp,%rbp
  8008d6:	41 54                	push   %r12
  8008d8:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8008d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008de:	49 bc 97 08 80 00 00 	movabs $0x800897,%r12
  8008e5:	00 00 00 
  8008e8:	89 df                	mov    %ebx,%edi
  8008ea:	41 ff d4             	call   *%r12
  8008ed:	83 c3 01             	add    $0x1,%ebx
  8008f0:	83 fb 20             	cmp    $0x20,%ebx
  8008f3:	75 f3                	jne    8008e8 <close_all+0x1a>
}
  8008f5:	5b                   	pop    %rbx
  8008f6:	41 5c                	pop    %r12
  8008f8:	5d                   	pop    %rbp
  8008f9:	c3                   	ret

00000000008008fa <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8008fa:	f3 0f 1e fa          	endbr64
  8008fe:	55                   	push   %rbp
  8008ff:	48 89 e5             	mov    %rsp,%rbp
  800902:	41 57                	push   %r15
  800904:	41 56                	push   %r14
  800906:	41 55                	push   %r13
  800908:	41 54                	push   %r12
  80090a:	53                   	push   %rbx
  80090b:	48 83 ec 18          	sub    $0x18,%rsp
  80090f:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  800912:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  800916:	48 b8 26 07 80 00 00 	movabs $0x800726,%rax
  80091d:	00 00 00 
  800920:	ff d0                	call   *%rax
  800922:	89 c3                	mov    %eax,%ebx
  800924:	85 c0                	test   %eax,%eax
  800926:	0f 88 b8 00 00 00    	js     8009e4 <dup+0xea>
    close(newfdnum);
  80092c:	44 89 e7             	mov    %r12d,%edi
  80092f:	48 b8 97 08 80 00 00 	movabs $0x800897,%rax
  800936:	00 00 00 
  800939:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  80093b:	4d 63 ec             	movslq %r12d,%r13
  80093e:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  800945:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  800949:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  80094d:	4c 89 ff             	mov    %r15,%rdi
  800950:	49 be a2 06 80 00 00 	movabs $0x8006a2,%r14
  800957:	00 00 00 
  80095a:	41 ff d6             	call   *%r14
  80095d:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  800960:	4c 89 ef             	mov    %r13,%rdi
  800963:	41 ff d6             	call   *%r14
  800966:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  800969:	48 89 df             	mov    %rbx,%rdi
  80096c:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  800973:	00 00 00 
  800976:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  800978:	a8 04                	test   $0x4,%al
  80097a:	74 2b                	je     8009a7 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  80097c:	41 89 c1             	mov    %eax,%r9d
  80097f:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800985:	4c 89 f1             	mov    %r14,%rcx
  800988:	ba 00 00 00 00       	mov    $0x0,%edx
  80098d:	48 89 de             	mov    %rbx,%rsi
  800990:	bf 00 00 00 00       	mov    $0x0,%edi
  800995:	48 b8 33 03 80 00 00 	movabs $0x800333,%rax
  80099c:	00 00 00 
  80099f:	ff d0                	call   *%rax
  8009a1:	89 c3                	mov    %eax,%ebx
  8009a3:	85 c0                	test   %eax,%eax
  8009a5:	78 4e                	js     8009f5 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  8009a7:	4c 89 ff             	mov    %r15,%rdi
  8009aa:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  8009b1:	00 00 00 
  8009b4:	ff d0                	call   *%rax
  8009b6:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8009b9:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8009bf:	4c 89 e9             	mov    %r13,%rcx
  8009c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c7:	4c 89 fe             	mov    %r15,%rsi
  8009ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8009cf:	48 b8 33 03 80 00 00 	movabs $0x800333,%rax
  8009d6:	00 00 00 
  8009d9:	ff d0                	call   *%rax
  8009db:	89 c3                	mov    %eax,%ebx
  8009dd:	85 c0                	test   %eax,%eax
  8009df:	78 14                	js     8009f5 <dup+0xfb>

    return newfdnum;
  8009e1:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8009e4:	89 d8                	mov    %ebx,%eax
  8009e6:	48 83 c4 18          	add    $0x18,%rsp
  8009ea:	5b                   	pop    %rbx
  8009eb:	41 5c                	pop    %r12
  8009ed:	41 5d                	pop    %r13
  8009ef:	41 5e                	pop    %r14
  8009f1:	41 5f                	pop    %r15
  8009f3:	5d                   	pop    %rbp
  8009f4:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8009f5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8009fa:	4c 89 ee             	mov    %r13,%rsi
  8009fd:	bf 00 00 00 00       	mov    $0x0,%edi
  800a02:	49 bc 08 04 80 00 00 	movabs $0x800408,%r12
  800a09:	00 00 00 
  800a0c:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  800a0f:	ba 00 10 00 00       	mov    $0x1000,%edx
  800a14:	4c 89 f6             	mov    %r14,%rsi
  800a17:	bf 00 00 00 00       	mov    $0x0,%edi
  800a1c:	41 ff d4             	call   *%r12
    return res;
  800a1f:	eb c3                	jmp    8009e4 <dup+0xea>

0000000000800a21 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800a21:	f3 0f 1e fa          	endbr64
  800a25:	55                   	push   %rbp
  800a26:	48 89 e5             	mov    %rsp,%rbp
  800a29:	41 56                	push   %r14
  800a2b:	41 55                	push   %r13
  800a2d:	41 54                	push   %r12
  800a2f:	53                   	push   %rbx
  800a30:	48 83 ec 10          	sub    $0x10,%rsp
  800a34:	89 fb                	mov    %edi,%ebx
  800a36:	49 89 f4             	mov    %rsi,%r12
  800a39:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a3c:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800a40:	48 b8 26 07 80 00 00 	movabs $0x800726,%rax
  800a47:	00 00 00 
  800a4a:	ff d0                	call   *%rax
  800a4c:	85 c0                	test   %eax,%eax
  800a4e:	78 4c                	js     800a9c <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800a50:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800a54:	41 8b 3e             	mov    (%r14),%edi
  800a57:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800a5b:	48 b8 75 07 80 00 00 	movabs $0x800775,%rax
  800a62:	00 00 00 
  800a65:	ff d0                	call   *%rax
  800a67:	85 c0                	test   %eax,%eax
  800a69:	78 35                	js     800aa0 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a6b:	41 8b 46 08          	mov    0x8(%r14),%eax
  800a6f:	83 e0 03             	and    $0x3,%eax
  800a72:	83 f8 01             	cmp    $0x1,%eax
  800a75:	74 2d                	je     800aa4 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800a77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a7b:	48 8b 40 10          	mov    0x10(%rax),%rax
  800a7f:	48 85 c0             	test   %rax,%rax
  800a82:	74 56                	je     800ada <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  800a84:	4c 89 ea             	mov    %r13,%rdx
  800a87:	4c 89 e6             	mov    %r12,%rsi
  800a8a:	4c 89 f7             	mov    %r14,%rdi
  800a8d:	ff d0                	call   *%rax
}
  800a8f:	48 83 c4 10          	add    $0x10,%rsp
  800a93:	5b                   	pop    %rbx
  800a94:	41 5c                	pop    %r12
  800a96:	41 5d                	pop    %r13
  800a98:	41 5e                	pop    %r14
  800a9a:	5d                   	pop    %rbp
  800a9b:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800a9c:	48 98                	cltq
  800a9e:	eb ef                	jmp    800a8f <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800aa0:	48 98                	cltq
  800aa2:	eb eb                	jmp    800a8f <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800aa4:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800aab:	00 00 00 
  800aae:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800ab4:	89 da                	mov    %ebx,%edx
  800ab6:	48 bf 18 30 80 00 00 	movabs $0x803018,%rdi
  800abd:	00 00 00 
  800ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac5:	48 b9 4f 1d 80 00 00 	movabs $0x801d4f,%rcx
  800acc:	00 00 00 
  800acf:	ff d1                	call   *%rcx
        return -E_INVAL;
  800ad1:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800ad8:	eb b5                	jmp    800a8f <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800ada:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800ae1:	eb ac                	jmp    800a8f <read+0x6e>

0000000000800ae3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800ae3:	f3 0f 1e fa          	endbr64
  800ae7:	55                   	push   %rbp
  800ae8:	48 89 e5             	mov    %rsp,%rbp
  800aeb:	41 57                	push   %r15
  800aed:	41 56                	push   %r14
  800aef:	41 55                	push   %r13
  800af1:	41 54                	push   %r12
  800af3:	53                   	push   %rbx
  800af4:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800af8:	48 85 d2             	test   %rdx,%rdx
  800afb:	74 54                	je     800b51 <readn+0x6e>
  800afd:	41 89 fd             	mov    %edi,%r13d
  800b00:	49 89 f6             	mov    %rsi,%r14
  800b03:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800b06:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800b0b:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800b10:	49 bf 21 0a 80 00 00 	movabs $0x800a21,%r15
  800b17:	00 00 00 
  800b1a:	4c 89 e2             	mov    %r12,%rdx
  800b1d:	48 29 f2             	sub    %rsi,%rdx
  800b20:	4c 01 f6             	add    %r14,%rsi
  800b23:	44 89 ef             	mov    %r13d,%edi
  800b26:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800b29:	85 c0                	test   %eax,%eax
  800b2b:	78 20                	js     800b4d <readn+0x6a>
    for (; inc && res < n; res += inc) {
  800b2d:	01 c3                	add    %eax,%ebx
  800b2f:	85 c0                	test   %eax,%eax
  800b31:	74 08                	je     800b3b <readn+0x58>
  800b33:	48 63 f3             	movslq %ebx,%rsi
  800b36:	4c 39 e6             	cmp    %r12,%rsi
  800b39:	72 df                	jb     800b1a <readn+0x37>
    }
    return res;
  800b3b:	48 63 c3             	movslq %ebx,%rax
}
  800b3e:	48 83 c4 08          	add    $0x8,%rsp
  800b42:	5b                   	pop    %rbx
  800b43:	41 5c                	pop    %r12
  800b45:	41 5d                	pop    %r13
  800b47:	41 5e                	pop    %r14
  800b49:	41 5f                	pop    %r15
  800b4b:	5d                   	pop    %rbp
  800b4c:	c3                   	ret
        if (inc < 0) return inc;
  800b4d:	48 98                	cltq
  800b4f:	eb ed                	jmp    800b3e <readn+0x5b>
    int inc = 1, res = 0;
  800b51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b56:	eb e3                	jmp    800b3b <readn+0x58>

0000000000800b58 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800b58:	f3 0f 1e fa          	endbr64
  800b5c:	55                   	push   %rbp
  800b5d:	48 89 e5             	mov    %rsp,%rbp
  800b60:	41 56                	push   %r14
  800b62:	41 55                	push   %r13
  800b64:	41 54                	push   %r12
  800b66:	53                   	push   %rbx
  800b67:	48 83 ec 10          	sub    $0x10,%rsp
  800b6b:	89 fb                	mov    %edi,%ebx
  800b6d:	49 89 f4             	mov    %rsi,%r12
  800b70:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800b73:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800b77:	48 b8 26 07 80 00 00 	movabs $0x800726,%rax
  800b7e:	00 00 00 
  800b81:	ff d0                	call   *%rax
  800b83:	85 c0                	test   %eax,%eax
  800b85:	78 47                	js     800bce <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800b87:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800b8b:	41 8b 3e             	mov    (%r14),%edi
  800b8e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800b92:	48 b8 75 07 80 00 00 	movabs $0x800775,%rax
  800b99:	00 00 00 
  800b9c:	ff d0                	call   *%rax
  800b9e:	85 c0                	test   %eax,%eax
  800ba0:	78 30                	js     800bd2 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ba2:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  800ba7:	74 2d                	je     800bd6 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  800ba9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800bad:	48 8b 40 18          	mov    0x18(%rax),%rax
  800bb1:	48 85 c0             	test   %rax,%rax
  800bb4:	74 56                	je     800c0c <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  800bb6:	4c 89 ea             	mov    %r13,%rdx
  800bb9:	4c 89 e6             	mov    %r12,%rsi
  800bbc:	4c 89 f7             	mov    %r14,%rdi
  800bbf:	ff d0                	call   *%rax
}
  800bc1:	48 83 c4 10          	add    $0x10,%rsp
  800bc5:	5b                   	pop    %rbx
  800bc6:	41 5c                	pop    %r12
  800bc8:	41 5d                	pop    %r13
  800bca:	41 5e                	pop    %r14
  800bcc:	5d                   	pop    %rbp
  800bcd:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800bce:	48 98                	cltq
  800bd0:	eb ef                	jmp    800bc1 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800bd2:	48 98                	cltq
  800bd4:	eb eb                	jmp    800bc1 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800bd6:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800bdd:	00 00 00 
  800be0:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800be6:	89 da                	mov    %ebx,%edx
  800be8:	48 bf 34 30 80 00 00 	movabs $0x803034,%rdi
  800bef:	00 00 00 
  800bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf7:	48 b9 4f 1d 80 00 00 	movabs $0x801d4f,%rcx
  800bfe:	00 00 00 
  800c01:	ff d1                	call   *%rcx
        return -E_INVAL;
  800c03:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800c0a:	eb b5                	jmp    800bc1 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  800c0c:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800c13:	eb ac                	jmp    800bc1 <write+0x69>

0000000000800c15 <seek>:

int
seek(int fdnum, off_t offset) {
  800c15:	f3 0f 1e fa          	endbr64
  800c19:	55                   	push   %rbp
  800c1a:	48 89 e5             	mov    %rsp,%rbp
  800c1d:	53                   	push   %rbx
  800c1e:	48 83 ec 18          	sub    $0x18,%rsp
  800c22:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c24:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c28:	48 b8 26 07 80 00 00 	movabs $0x800726,%rax
  800c2f:	00 00 00 
  800c32:	ff d0                	call   *%rax
  800c34:	85 c0                	test   %eax,%eax
  800c36:	78 0c                	js     800c44 <seek+0x2f>

    fd->fd_offset = offset;
  800c38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c3c:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  800c3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c44:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c48:	c9                   	leave
  800c49:	c3                   	ret

0000000000800c4a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  800c4a:	f3 0f 1e fa          	endbr64
  800c4e:	55                   	push   %rbp
  800c4f:	48 89 e5             	mov    %rsp,%rbp
  800c52:	41 55                	push   %r13
  800c54:	41 54                	push   %r12
  800c56:	53                   	push   %rbx
  800c57:	48 83 ec 18          	sub    $0x18,%rsp
  800c5b:	89 fb                	mov    %edi,%ebx
  800c5d:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800c60:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800c64:	48 b8 26 07 80 00 00 	movabs $0x800726,%rax
  800c6b:	00 00 00 
  800c6e:	ff d0                	call   *%rax
  800c70:	85 c0                	test   %eax,%eax
  800c72:	78 38                	js     800cac <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800c74:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  800c78:	41 8b 7d 00          	mov    0x0(%r13),%edi
  800c7c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800c80:	48 b8 75 07 80 00 00 	movabs $0x800775,%rax
  800c87:	00 00 00 
  800c8a:	ff d0                	call   *%rax
  800c8c:	85 c0                	test   %eax,%eax
  800c8e:	78 1c                	js     800cac <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c90:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  800c95:	74 20                	je     800cb7 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800c97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c9b:	48 8b 40 30          	mov    0x30(%rax),%rax
  800c9f:	48 85 c0             	test   %rax,%rax
  800ca2:	74 47                	je     800ceb <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  800ca4:	44 89 e6             	mov    %r12d,%esi
  800ca7:	4c 89 ef             	mov    %r13,%rdi
  800caa:	ff d0                	call   *%rax
}
  800cac:	48 83 c4 18          	add    $0x18,%rsp
  800cb0:	5b                   	pop    %rbx
  800cb1:	41 5c                	pop    %r12
  800cb3:	41 5d                	pop    %r13
  800cb5:	5d                   	pop    %rbp
  800cb6:	c3                   	ret
                thisenv->env_id, fdnum);
  800cb7:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800cbe:	00 00 00 
  800cc1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  800cc7:	89 da                	mov    %ebx,%edx
  800cc9:	48 bf 98 32 80 00 00 	movabs $0x803298,%rdi
  800cd0:	00 00 00 
  800cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd8:	48 b9 4f 1d 80 00 00 	movabs $0x801d4f,%rcx
  800cdf:	00 00 00 
  800ce2:	ff d1                	call   *%rcx
        return -E_INVAL;
  800ce4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ce9:	eb c1                	jmp    800cac <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  800ceb:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800cf0:	eb ba                	jmp    800cac <ftruncate+0x62>

0000000000800cf2 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  800cf2:	f3 0f 1e fa          	endbr64
  800cf6:	55                   	push   %rbp
  800cf7:	48 89 e5             	mov    %rsp,%rbp
  800cfa:	41 54                	push   %r12
  800cfc:	53                   	push   %rbx
  800cfd:	48 83 ec 10          	sub    $0x10,%rsp
  800d01:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800d04:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800d08:	48 b8 26 07 80 00 00 	movabs $0x800726,%rax
  800d0f:	00 00 00 
  800d12:	ff d0                	call   *%rax
  800d14:	85 c0                	test   %eax,%eax
  800d16:	78 4e                	js     800d66 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800d18:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  800d1c:	41 8b 3c 24          	mov    (%r12),%edi
  800d20:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800d24:	48 b8 75 07 80 00 00 	movabs $0x800775,%rax
  800d2b:	00 00 00 
  800d2e:	ff d0                	call   *%rax
  800d30:	85 c0                	test   %eax,%eax
  800d32:	78 32                	js     800d66 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800d38:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  800d3d:	74 30                	je     800d6f <fstat+0x7d>

    stat->st_name[0] = 0;
  800d3f:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  800d42:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  800d49:	00 00 00 
    stat->st_isdir = 0;
  800d4c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  800d53:	00 00 00 
    stat->st_dev = dev;
  800d56:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  800d5d:	48 89 de             	mov    %rbx,%rsi
  800d60:	4c 89 e7             	mov    %r12,%rdi
  800d63:	ff 50 28             	call   *0x28(%rax)
}
  800d66:	48 83 c4 10          	add    $0x10,%rsp
  800d6a:	5b                   	pop    %rbx
  800d6b:	41 5c                	pop    %r12
  800d6d:	5d                   	pop    %rbp
  800d6e:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  800d6f:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  800d74:	eb f0                	jmp    800d66 <fstat+0x74>

0000000000800d76 <stat>:

int
stat(const char *path, struct Stat *stat) {
  800d76:	f3 0f 1e fa          	endbr64
  800d7a:	55                   	push   %rbp
  800d7b:	48 89 e5             	mov    %rsp,%rbp
  800d7e:	41 54                	push   %r12
  800d80:	53                   	push   %rbx
  800d81:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  800d84:	be 00 00 00 00       	mov    $0x0,%esi
  800d89:	48 b8 57 10 80 00 00 	movabs $0x801057,%rax
  800d90:	00 00 00 
  800d93:	ff d0                	call   *%rax
  800d95:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  800d97:	85 c0                	test   %eax,%eax
  800d99:	78 25                	js     800dc0 <stat+0x4a>

    int res = fstat(fd, stat);
  800d9b:	4c 89 e6             	mov    %r12,%rsi
  800d9e:	89 c7                	mov    %eax,%edi
  800da0:	48 b8 f2 0c 80 00 00 	movabs $0x800cf2,%rax
  800da7:	00 00 00 
  800daa:	ff d0                	call   *%rax
  800dac:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  800daf:	89 df                	mov    %ebx,%edi
  800db1:	48 b8 97 08 80 00 00 	movabs $0x800897,%rax
  800db8:	00 00 00 
  800dbb:	ff d0                	call   *%rax

    return res;
  800dbd:	44 89 e3             	mov    %r12d,%ebx
}
  800dc0:	89 d8                	mov    %ebx,%eax
  800dc2:	5b                   	pop    %rbx
  800dc3:	41 5c                	pop    %r12
  800dc5:	5d                   	pop    %rbp
  800dc6:	c3                   	ret

0000000000800dc7 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  800dc7:	f3 0f 1e fa          	endbr64
  800dcb:	55                   	push   %rbp
  800dcc:	48 89 e5             	mov    %rsp,%rbp
  800dcf:	41 54                	push   %r12
  800dd1:	53                   	push   %rbx
  800dd2:	48 83 ec 10          	sub    $0x10,%rsp
  800dd6:	41 89 fc             	mov    %edi,%r12d
  800dd9:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800ddc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800de3:	00 00 00 
  800de6:	83 38 00             	cmpl   $0x0,(%rax)
  800de9:	74 6e                	je     800e59 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  800deb:	bf 03 00 00 00       	mov    $0x3,%edi
  800df0:	48 b8 53 2c 80 00 00 	movabs $0x802c53,%rax
  800df7:	00 00 00 
  800dfa:	ff d0                	call   *%rax
  800dfc:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e03:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  800e05:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800e0b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800e10:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800e17:	00 00 00 
  800e1a:	44 89 e6             	mov    %r12d,%esi
  800e1d:	89 c7                	mov    %eax,%edi
  800e1f:	48 b8 91 2b 80 00 00 	movabs $0x802b91,%rax
  800e26:	00 00 00 
  800e29:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  800e2b:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800e32:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  800e33:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e38:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e3c:	48 89 de             	mov    %rbx,%rsi
  800e3f:	bf 00 00 00 00       	mov    $0x0,%edi
  800e44:	48 b8 f8 2a 80 00 00 	movabs $0x802af8,%rax
  800e4b:	00 00 00 
  800e4e:	ff d0                	call   *%rax
}
  800e50:	48 83 c4 10          	add    $0x10,%rsp
  800e54:	5b                   	pop    %rbx
  800e55:	41 5c                	pop    %r12
  800e57:	5d                   	pop    %rbp
  800e58:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  800e59:	bf 03 00 00 00       	mov    $0x3,%edi
  800e5e:	48 b8 53 2c 80 00 00 	movabs $0x802c53,%rax
  800e65:	00 00 00 
  800e68:	ff d0                	call   *%rax
  800e6a:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  800e71:	00 00 
  800e73:	e9 73 ff ff ff       	jmp    800deb <fsipc+0x24>

0000000000800e78 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  800e78:	f3 0f 1e fa          	endbr64
  800e7c:	55                   	push   %rbp
  800e7d:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800e80:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800e87:	00 00 00 
  800e8a:	8b 57 0c             	mov    0xc(%rdi),%edx
  800e8d:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  800e8f:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  800e92:	be 00 00 00 00       	mov    $0x0,%esi
  800e97:	bf 02 00 00 00       	mov    $0x2,%edi
  800e9c:	48 b8 c7 0d 80 00 00 	movabs $0x800dc7,%rax
  800ea3:	00 00 00 
  800ea6:	ff d0                	call   *%rax
}
  800ea8:	5d                   	pop    %rbp
  800ea9:	c3                   	ret

0000000000800eaa <devfile_flush>:
devfile_flush(struct Fd *fd) {
  800eaa:	f3 0f 1e fa          	endbr64
  800eae:	55                   	push   %rbp
  800eaf:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800eb2:	8b 47 0c             	mov    0xc(%rdi),%eax
  800eb5:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800ebc:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  800ebe:	be 00 00 00 00       	mov    $0x0,%esi
  800ec3:	bf 06 00 00 00       	mov    $0x6,%edi
  800ec8:	48 b8 c7 0d 80 00 00 	movabs $0x800dc7,%rax
  800ecf:	00 00 00 
  800ed2:	ff d0                	call   *%rax
}
  800ed4:	5d                   	pop    %rbp
  800ed5:	c3                   	ret

0000000000800ed6 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  800ed6:	f3 0f 1e fa          	endbr64
  800eda:	55                   	push   %rbp
  800edb:	48 89 e5             	mov    %rsp,%rbp
  800ede:	41 54                	push   %r12
  800ee0:	53                   	push   %rbx
  800ee1:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ee4:	8b 47 0c             	mov    0xc(%rdi),%eax
  800ee7:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  800eee:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  800ef0:	be 00 00 00 00       	mov    $0x0,%esi
  800ef5:	bf 05 00 00 00       	mov    $0x5,%edi
  800efa:	48 b8 c7 0d 80 00 00 	movabs $0x800dc7,%rax
  800f01:	00 00 00 
  800f04:	ff d0                	call   *%rax
    if (res < 0) return res;
  800f06:	85 c0                	test   %eax,%eax
  800f08:	78 3d                	js     800f47 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800f0a:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  800f11:	00 00 00 
  800f14:	4c 89 e6             	mov    %r12,%rsi
  800f17:	48 89 df             	mov    %rbx,%rdi
  800f1a:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  800f21:	00 00 00 
  800f24:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  800f26:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  800f2d:	00 
  800f2e:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800f34:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  800f3b:	00 
  800f3c:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  800f42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f47:	5b                   	pop    %rbx
  800f48:	41 5c                	pop    %r12
  800f4a:	5d                   	pop    %rbp
  800f4b:	c3                   	ret

0000000000800f4c <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f4c:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  800f50:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  800f57:	77 41                	ja     800f9a <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  800f59:	55                   	push   %rbp
  800f5a:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  800f5d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f64:	00 00 00 
  800f67:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  800f6a:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  800f6c:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  800f70:	48 8d 78 10          	lea    0x10(%rax),%rdi
  800f74:	48 b8 b3 28 80 00 00 	movabs $0x8028b3,%rax
  800f7b:	00 00 00 
  800f7e:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  800f80:	be 00 00 00 00       	mov    $0x0,%esi
  800f85:	bf 04 00 00 00       	mov    $0x4,%edi
  800f8a:	48 b8 c7 0d 80 00 00 	movabs $0x800dc7,%rax
  800f91:	00 00 00 
  800f94:	ff d0                	call   *%rax
  800f96:	48 98                	cltq
}
  800f98:	5d                   	pop    %rbp
  800f99:	c3                   	ret
        return -E_INVAL;
  800f9a:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  800fa1:	c3                   	ret

0000000000800fa2 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  800fa2:	f3 0f 1e fa          	endbr64
  800fa6:	55                   	push   %rbp
  800fa7:	48 89 e5             	mov    %rsp,%rbp
  800faa:	41 55                	push   %r13
  800fac:	41 54                	push   %r12
  800fae:	53                   	push   %rbx
  800faf:	48 83 ec 08          	sub    $0x8,%rsp
  800fb3:	49 89 f4             	mov    %rsi,%r12
  800fb6:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  800fb9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800fc0:	00 00 00 
  800fc3:	8b 57 0c             	mov    0xc(%rdi),%edx
  800fc6:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  800fc8:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  800fcc:	be 00 00 00 00       	mov    $0x0,%esi
  800fd1:	bf 03 00 00 00       	mov    $0x3,%edi
  800fd6:	48 b8 c7 0d 80 00 00 	movabs $0x800dc7,%rax
  800fdd:	00 00 00 
  800fe0:	ff d0                	call   *%rax
  800fe2:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  800fe5:	4d 85 ed             	test   %r13,%r13
  800fe8:	78 2a                	js     801014 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  800fea:	4c 89 ea             	mov    %r13,%rdx
  800fed:	4c 39 eb             	cmp    %r13,%rbx
  800ff0:	72 30                	jb     801022 <devfile_read+0x80>
  800ff2:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  800ff9:	7f 27                	jg     801022 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  800ffb:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801002:	00 00 00 
  801005:	4c 89 e7             	mov    %r12,%rdi
  801008:	48 b8 b3 28 80 00 00 	movabs $0x8028b3,%rax
  80100f:	00 00 00 
  801012:	ff d0                	call   *%rax
}
  801014:	4c 89 e8             	mov    %r13,%rax
  801017:	48 83 c4 08          	add    $0x8,%rsp
  80101b:	5b                   	pop    %rbx
  80101c:	41 5c                	pop    %r12
  80101e:	41 5d                	pop    %r13
  801020:	5d                   	pop    %rbp
  801021:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801022:	48 b9 51 30 80 00 00 	movabs $0x803051,%rcx
  801029:	00 00 00 
  80102c:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  801033:	00 00 00 
  801036:	be 7b 00 00 00       	mov    $0x7b,%esi
  80103b:	48 bf 83 30 80 00 00 	movabs $0x803083,%rdi
  801042:	00 00 00 
  801045:	b8 00 00 00 00       	mov    $0x0,%eax
  80104a:	49 b8 f3 1b 80 00 00 	movabs $0x801bf3,%r8
  801051:	00 00 00 
  801054:	41 ff d0             	call   *%r8

0000000000801057 <open>:
open(const char *path, int mode) {
  801057:	f3 0f 1e fa          	endbr64
  80105b:	55                   	push   %rbp
  80105c:	48 89 e5             	mov    %rsp,%rbp
  80105f:	41 55                	push   %r13
  801061:	41 54                	push   %r12
  801063:	53                   	push   %rbx
  801064:	48 83 ec 18          	sub    $0x18,%rsp
  801068:	49 89 fc             	mov    %rdi,%r12
  80106b:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  80106e:	48 b8 53 26 80 00 00 	movabs $0x802653,%rax
  801075:	00 00 00 
  801078:	ff d0                	call   *%rax
  80107a:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801080:	0f 87 8a 00 00 00    	ja     801110 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801086:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80108a:	48 b8 c2 06 80 00 00 	movabs $0x8006c2,%rax
  801091:	00 00 00 
  801094:	ff d0                	call   *%rax
  801096:	89 c3                	mov    %eax,%ebx
  801098:	85 c0                	test   %eax,%eax
  80109a:	78 50                	js     8010ec <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80109c:	4c 89 e6             	mov    %r12,%rsi
  80109f:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  8010a6:	00 00 00 
  8010a9:	48 89 df             	mov    %rbx,%rdi
  8010ac:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  8010b3:	00 00 00 
  8010b6:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8010b8:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8010bf:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8010c3:	bf 01 00 00 00       	mov    $0x1,%edi
  8010c8:	48 b8 c7 0d 80 00 00 	movabs $0x800dc7,%rax
  8010cf:	00 00 00 
  8010d2:	ff d0                	call   *%rax
  8010d4:	89 c3                	mov    %eax,%ebx
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	78 1f                	js     8010f9 <open+0xa2>
    return fd2num(fd);
  8010da:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8010de:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  8010e5:	00 00 00 
  8010e8:	ff d0                	call   *%rax
  8010ea:	89 c3                	mov    %eax,%ebx
}
  8010ec:	89 d8                	mov    %ebx,%eax
  8010ee:	48 83 c4 18          	add    $0x18,%rsp
  8010f2:	5b                   	pop    %rbx
  8010f3:	41 5c                	pop    %r12
  8010f5:	41 5d                	pop    %r13
  8010f7:	5d                   	pop    %rbp
  8010f8:	c3                   	ret
        fd_close(fd, 0);
  8010f9:	be 00 00 00 00       	mov    $0x0,%esi
  8010fe:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801102:	48 b8 e9 07 80 00 00 	movabs $0x8007e9,%rax
  801109:	00 00 00 
  80110c:	ff d0                	call   *%rax
        return res;
  80110e:	eb dc                	jmp    8010ec <open+0x95>
        return -E_BAD_PATH;
  801110:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801115:	eb d5                	jmp    8010ec <open+0x95>

0000000000801117 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801117:	f3 0f 1e fa          	endbr64
  80111b:	55                   	push   %rbp
  80111c:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80111f:	be 00 00 00 00       	mov    $0x0,%esi
  801124:	bf 08 00 00 00       	mov    $0x8,%edi
  801129:	48 b8 c7 0d 80 00 00 	movabs $0x800dc7,%rax
  801130:	00 00 00 
  801133:	ff d0                	call   *%rax
}
  801135:	5d                   	pop    %rbp
  801136:	c3                   	ret

0000000000801137 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801137:	f3 0f 1e fa          	endbr64
  80113b:	55                   	push   %rbp
  80113c:	48 89 e5             	mov    %rsp,%rbp
  80113f:	41 54                	push   %r12
  801141:	53                   	push   %rbx
  801142:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801145:	48 b8 a2 06 80 00 00 	movabs $0x8006a2,%rax
  80114c:	00 00 00 
  80114f:	ff d0                	call   *%rax
  801151:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801154:	48 be 8e 30 80 00 00 	movabs $0x80308e,%rsi
  80115b:	00 00 00 
  80115e:	48 89 df             	mov    %rbx,%rdi
  801161:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  801168:	00 00 00 
  80116b:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80116d:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801172:	41 2b 04 24          	sub    (%r12),%eax
  801176:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80117c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801183:	00 00 00 
    stat->st_dev = &devpipe;
  801186:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80118d:	00 00 00 
  801190:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801197:	b8 00 00 00 00       	mov    $0x0,%eax
  80119c:	5b                   	pop    %rbx
  80119d:	41 5c                	pop    %r12
  80119f:	5d                   	pop    %rbp
  8011a0:	c3                   	ret

00000000008011a1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8011a1:	f3 0f 1e fa          	endbr64
  8011a5:	55                   	push   %rbp
  8011a6:	48 89 e5             	mov    %rsp,%rbp
  8011a9:	41 54                	push   %r12
  8011ab:	53                   	push   %rbx
  8011ac:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8011af:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011b4:	48 89 fe             	mov    %rdi,%rsi
  8011b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8011bc:	49 bc 08 04 80 00 00 	movabs $0x800408,%r12
  8011c3:	00 00 00 
  8011c6:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8011c9:	48 89 df             	mov    %rbx,%rdi
  8011cc:	48 b8 a2 06 80 00 00 	movabs $0x8006a2,%rax
  8011d3:	00 00 00 
  8011d6:	ff d0                	call   *%rax
  8011d8:	48 89 c6             	mov    %rax,%rsi
  8011db:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8011e5:	41 ff d4             	call   *%r12
}
  8011e8:	5b                   	pop    %rbx
  8011e9:	41 5c                	pop    %r12
  8011eb:	5d                   	pop    %rbp
  8011ec:	c3                   	ret

00000000008011ed <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8011ed:	f3 0f 1e fa          	endbr64
  8011f1:	55                   	push   %rbp
  8011f2:	48 89 e5             	mov    %rsp,%rbp
  8011f5:	41 57                	push   %r15
  8011f7:	41 56                	push   %r14
  8011f9:	41 55                	push   %r13
  8011fb:	41 54                	push   %r12
  8011fd:	53                   	push   %rbx
  8011fe:	48 83 ec 18          	sub    $0x18,%rsp
  801202:	49 89 fc             	mov    %rdi,%r12
  801205:	49 89 f5             	mov    %rsi,%r13
  801208:	49 89 d7             	mov    %rdx,%r15
  80120b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80120f:	48 b8 a2 06 80 00 00 	movabs $0x8006a2,%rax
  801216:	00 00 00 
  801219:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80121b:	4d 85 ff             	test   %r15,%r15
  80121e:	0f 84 af 00 00 00    	je     8012d3 <devpipe_write+0xe6>
  801224:	48 89 c3             	mov    %rax,%rbx
  801227:	4c 89 f8             	mov    %r15,%rax
  80122a:	4d 89 ef             	mov    %r13,%r15
  80122d:	4c 01 e8             	add    %r13,%rax
  801230:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801234:	49 bd 98 02 80 00 00 	movabs $0x800298,%r13
  80123b:	00 00 00 
            sys_yield();
  80123e:	49 be 2d 02 80 00 00 	movabs $0x80022d,%r14
  801245:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801248:	8b 73 04             	mov    0x4(%rbx),%esi
  80124b:	48 63 ce             	movslq %esi,%rcx
  80124e:	48 63 03             	movslq (%rbx),%rax
  801251:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801257:	48 39 c1             	cmp    %rax,%rcx
  80125a:	72 2e                	jb     80128a <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80125c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801261:	48 89 da             	mov    %rbx,%rdx
  801264:	be 00 10 00 00       	mov    $0x1000,%esi
  801269:	4c 89 e7             	mov    %r12,%rdi
  80126c:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80126f:	85 c0                	test   %eax,%eax
  801271:	74 66                	je     8012d9 <devpipe_write+0xec>
            sys_yield();
  801273:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801276:	8b 73 04             	mov    0x4(%rbx),%esi
  801279:	48 63 ce             	movslq %esi,%rcx
  80127c:	48 63 03             	movslq (%rbx),%rax
  80127f:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801285:	48 39 c1             	cmp    %rax,%rcx
  801288:	73 d2                	jae    80125c <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80128a:	41 0f b6 3f          	movzbl (%r15),%edi
  80128e:	48 89 ca             	mov    %rcx,%rdx
  801291:	48 c1 ea 03          	shr    $0x3,%rdx
  801295:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80129c:	08 10 20 
  80129f:	48 f7 e2             	mul    %rdx
  8012a2:	48 c1 ea 06          	shr    $0x6,%rdx
  8012a6:	48 89 d0             	mov    %rdx,%rax
  8012a9:	48 c1 e0 09          	shl    $0x9,%rax
  8012ad:	48 29 d0             	sub    %rdx,%rax
  8012b0:	48 c1 e0 03          	shl    $0x3,%rax
  8012b4:	48 29 c1             	sub    %rax,%rcx
  8012b7:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8012bc:	83 c6 01             	add    $0x1,%esi
  8012bf:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8012c2:	49 83 c7 01          	add    $0x1,%r15
  8012c6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012ca:	49 39 c7             	cmp    %rax,%r15
  8012cd:	0f 85 75 ff ff ff    	jne    801248 <devpipe_write+0x5b>
    return n;
  8012d3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8012d7:	eb 05                	jmp    8012de <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8012d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012de:	48 83 c4 18          	add    $0x18,%rsp
  8012e2:	5b                   	pop    %rbx
  8012e3:	41 5c                	pop    %r12
  8012e5:	41 5d                	pop    %r13
  8012e7:	41 5e                	pop    %r14
  8012e9:	41 5f                	pop    %r15
  8012eb:	5d                   	pop    %rbp
  8012ec:	c3                   	ret

00000000008012ed <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8012ed:	f3 0f 1e fa          	endbr64
  8012f1:	55                   	push   %rbp
  8012f2:	48 89 e5             	mov    %rsp,%rbp
  8012f5:	41 57                	push   %r15
  8012f7:	41 56                	push   %r14
  8012f9:	41 55                	push   %r13
  8012fb:	41 54                	push   %r12
  8012fd:	53                   	push   %rbx
  8012fe:	48 83 ec 18          	sub    $0x18,%rsp
  801302:	49 89 fc             	mov    %rdi,%r12
  801305:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801309:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80130d:	48 b8 a2 06 80 00 00 	movabs $0x8006a2,%rax
  801314:	00 00 00 
  801317:	ff d0                	call   *%rax
  801319:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80131c:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801322:	49 bd 98 02 80 00 00 	movabs $0x800298,%r13
  801329:	00 00 00 
            sys_yield();
  80132c:	49 be 2d 02 80 00 00 	movabs $0x80022d,%r14
  801333:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801336:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80133b:	74 7d                	je     8013ba <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80133d:	8b 03                	mov    (%rbx),%eax
  80133f:	3b 43 04             	cmp    0x4(%rbx),%eax
  801342:	75 26                	jne    80136a <devpipe_read+0x7d>
            if (i > 0) return i;
  801344:	4d 85 ff             	test   %r15,%r15
  801347:	75 77                	jne    8013c0 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801349:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80134e:	48 89 da             	mov    %rbx,%rdx
  801351:	be 00 10 00 00       	mov    $0x1000,%esi
  801356:	4c 89 e7             	mov    %r12,%rdi
  801359:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80135c:	85 c0                	test   %eax,%eax
  80135e:	74 72                	je     8013d2 <devpipe_read+0xe5>
            sys_yield();
  801360:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801363:	8b 03                	mov    (%rbx),%eax
  801365:	3b 43 04             	cmp    0x4(%rbx),%eax
  801368:	74 df                	je     801349 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80136a:	48 63 c8             	movslq %eax,%rcx
  80136d:	48 89 ca             	mov    %rcx,%rdx
  801370:	48 c1 ea 03          	shr    $0x3,%rdx
  801374:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  80137b:	08 10 20 
  80137e:	48 89 d0             	mov    %rdx,%rax
  801381:	48 f7 e6             	mul    %rsi
  801384:	48 c1 ea 06          	shr    $0x6,%rdx
  801388:	48 89 d0             	mov    %rdx,%rax
  80138b:	48 c1 e0 09          	shl    $0x9,%rax
  80138f:	48 29 d0             	sub    %rdx,%rax
  801392:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801399:	00 
  80139a:	48 89 c8             	mov    %rcx,%rax
  80139d:	48 29 d0             	sub    %rdx,%rax
  8013a0:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8013a5:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8013a9:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8013ad:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8013b0:	49 83 c7 01          	add    $0x1,%r15
  8013b4:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8013b8:	75 83                	jne    80133d <devpipe_read+0x50>
    return n;
  8013ba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013be:	eb 03                	jmp    8013c3 <devpipe_read+0xd6>
            if (i > 0) return i;
  8013c0:	4c 89 f8             	mov    %r15,%rax
}
  8013c3:	48 83 c4 18          	add    $0x18,%rsp
  8013c7:	5b                   	pop    %rbx
  8013c8:	41 5c                	pop    %r12
  8013ca:	41 5d                	pop    %r13
  8013cc:	41 5e                	pop    %r14
  8013ce:	41 5f                	pop    %r15
  8013d0:	5d                   	pop    %rbp
  8013d1:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8013d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d7:	eb ea                	jmp    8013c3 <devpipe_read+0xd6>

00000000008013d9 <pipe>:
pipe(int pfd[2]) {
  8013d9:	f3 0f 1e fa          	endbr64
  8013dd:	55                   	push   %rbp
  8013de:	48 89 e5             	mov    %rsp,%rbp
  8013e1:	41 55                	push   %r13
  8013e3:	41 54                	push   %r12
  8013e5:	53                   	push   %rbx
  8013e6:	48 83 ec 18          	sub    $0x18,%rsp
  8013ea:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8013ed:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8013f1:	48 b8 c2 06 80 00 00 	movabs $0x8006c2,%rax
  8013f8:	00 00 00 
  8013fb:	ff d0                	call   *%rax
  8013fd:	89 c3                	mov    %eax,%ebx
  8013ff:	85 c0                	test   %eax,%eax
  801401:	0f 88 a0 01 00 00    	js     8015a7 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  801407:	b9 46 00 00 00       	mov    $0x46,%ecx
  80140c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801411:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801415:	bf 00 00 00 00       	mov    $0x0,%edi
  80141a:	48 b8 c8 02 80 00 00 	movabs $0x8002c8,%rax
  801421:	00 00 00 
  801424:	ff d0                	call   *%rax
  801426:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801428:	85 c0                	test   %eax,%eax
  80142a:	0f 88 77 01 00 00    	js     8015a7 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  801430:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  801434:	48 b8 c2 06 80 00 00 	movabs $0x8006c2,%rax
  80143b:	00 00 00 
  80143e:	ff d0                	call   *%rax
  801440:	89 c3                	mov    %eax,%ebx
  801442:	85 c0                	test   %eax,%eax
  801444:	0f 88 43 01 00 00    	js     80158d <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80144a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80144f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801454:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801458:	bf 00 00 00 00       	mov    $0x0,%edi
  80145d:	48 b8 c8 02 80 00 00 	movabs $0x8002c8,%rax
  801464:	00 00 00 
  801467:	ff d0                	call   *%rax
  801469:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80146b:	85 c0                	test   %eax,%eax
  80146d:	0f 88 1a 01 00 00    	js     80158d <pipe+0x1b4>
    va = fd2data(fd0);
  801473:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801477:	48 b8 a2 06 80 00 00 	movabs $0x8006a2,%rax
  80147e:	00 00 00 
  801481:	ff d0                	call   *%rax
  801483:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  801486:	b9 46 00 00 00       	mov    $0x46,%ecx
  80148b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801490:	48 89 c6             	mov    %rax,%rsi
  801493:	bf 00 00 00 00       	mov    $0x0,%edi
  801498:	48 b8 c8 02 80 00 00 	movabs $0x8002c8,%rax
  80149f:	00 00 00 
  8014a2:	ff d0                	call   *%rax
  8014a4:	89 c3                	mov    %eax,%ebx
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	0f 88 c5 00 00 00    	js     801573 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8014ae:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8014b2:	48 b8 a2 06 80 00 00 	movabs $0x8006a2,%rax
  8014b9:	00 00 00 
  8014bc:	ff d0                	call   *%rax
  8014be:	48 89 c1             	mov    %rax,%rcx
  8014c1:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8014c7:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8014cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d2:	4c 89 ee             	mov    %r13,%rsi
  8014d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8014da:	48 b8 33 03 80 00 00 	movabs $0x800333,%rax
  8014e1:	00 00 00 
  8014e4:	ff d0                	call   *%rax
  8014e6:	89 c3                	mov    %eax,%ebx
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	78 6e                	js     80155a <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8014ec:	be 00 10 00 00       	mov    $0x1000,%esi
  8014f1:	4c 89 ef             	mov    %r13,%rdi
  8014f4:	48 b8 62 02 80 00 00 	movabs $0x800262,%rax
  8014fb:	00 00 00 
  8014fe:	ff d0                	call   *%rax
  801500:	83 f8 02             	cmp    $0x2,%eax
  801503:	0f 85 ab 00 00 00    	jne    8015b4 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  801509:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  801510:	00 00 
  801512:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801516:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  801518:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80151c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  801523:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801527:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801529:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80152d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  801534:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801538:	48 bb 8c 06 80 00 00 	movabs $0x80068c,%rbx
  80153f:	00 00 00 
  801542:	ff d3                	call   *%rbx
  801544:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801548:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80154c:	ff d3                	call   *%rbx
  80154e:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  801553:	bb 00 00 00 00       	mov    $0x0,%ebx
  801558:	eb 4d                	jmp    8015a7 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  80155a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80155f:	4c 89 ee             	mov    %r13,%rsi
  801562:	bf 00 00 00 00       	mov    $0x0,%edi
  801567:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  80156e:	00 00 00 
  801571:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  801573:	ba 00 10 00 00       	mov    $0x1000,%edx
  801578:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80157c:	bf 00 00 00 00       	mov    $0x0,%edi
  801581:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  801588:	00 00 00 
  80158b:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80158d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801592:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801596:	bf 00 00 00 00       	mov    $0x0,%edi
  80159b:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  8015a2:	00 00 00 
  8015a5:	ff d0                	call   *%rax
}
  8015a7:	89 d8                	mov    %ebx,%eax
  8015a9:	48 83 c4 18          	add    $0x18,%rsp
  8015ad:	5b                   	pop    %rbx
  8015ae:	41 5c                	pop    %r12
  8015b0:	41 5d                	pop    %r13
  8015b2:	5d                   	pop    %rbp
  8015b3:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8015b4:	48 b9 c0 32 80 00 00 	movabs $0x8032c0,%rcx
  8015bb:	00 00 00 
  8015be:	48 ba 6e 30 80 00 00 	movabs $0x80306e,%rdx
  8015c5:	00 00 00 
  8015c8:	be 2e 00 00 00       	mov    $0x2e,%esi
  8015cd:	48 bf 95 30 80 00 00 	movabs $0x803095,%rdi
  8015d4:	00 00 00 
  8015d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015dc:	49 b8 f3 1b 80 00 00 	movabs $0x801bf3,%r8
  8015e3:	00 00 00 
  8015e6:	41 ff d0             	call   *%r8

00000000008015e9 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8015e9:	f3 0f 1e fa          	endbr64
  8015ed:	55                   	push   %rbp
  8015ee:	48 89 e5             	mov    %rsp,%rbp
  8015f1:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8015f5:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8015f9:	48 b8 26 07 80 00 00 	movabs $0x800726,%rax
  801600:	00 00 00 
  801603:	ff d0                	call   *%rax
    if (res < 0) return res;
  801605:	85 c0                	test   %eax,%eax
  801607:	78 35                	js     80163e <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  801609:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80160d:	48 b8 a2 06 80 00 00 	movabs $0x8006a2,%rax
  801614:	00 00 00 
  801617:	ff d0                	call   *%rax
  801619:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80161c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801621:	be 00 10 00 00       	mov    $0x1000,%esi
  801626:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80162a:	48 b8 98 02 80 00 00 	movabs $0x800298,%rax
  801631:	00 00 00 
  801634:	ff d0                	call   *%rax
  801636:	85 c0                	test   %eax,%eax
  801638:	0f 94 c0             	sete   %al
  80163b:	0f b6 c0             	movzbl %al,%eax
}
  80163e:	c9                   	leave
  80163f:	c3                   	ret

0000000000801640 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  801640:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801644:	48 89 f8             	mov    %rdi,%rax
  801647:	48 c1 e8 27          	shr    $0x27,%rax
  80164b:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  801652:	7f 00 00 
  801655:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801659:	f6 c2 01             	test   $0x1,%dl
  80165c:	74 6d                	je     8016cb <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80165e:	48 89 f8             	mov    %rdi,%rax
  801661:	48 c1 e8 1e          	shr    $0x1e,%rax
  801665:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80166c:	7f 00 00 
  80166f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801673:	f6 c2 01             	test   $0x1,%dl
  801676:	74 62                	je     8016da <get_uvpt_entry+0x9a>
  801678:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80167f:	7f 00 00 
  801682:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801686:	f6 c2 80             	test   $0x80,%dl
  801689:	75 4f                	jne    8016da <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80168b:	48 89 f8             	mov    %rdi,%rax
  80168e:	48 c1 e8 15          	shr    $0x15,%rax
  801692:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  801699:	7f 00 00 
  80169c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8016a0:	f6 c2 01             	test   $0x1,%dl
  8016a3:	74 44                	je     8016e9 <get_uvpt_entry+0xa9>
  8016a5:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016ac:	7f 00 00 
  8016af:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8016b3:	f6 c2 80             	test   $0x80,%dl
  8016b6:	75 31                	jne    8016e9 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  8016b8:	48 c1 ef 0c          	shr    $0xc,%rdi
  8016bc:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8016c3:	7f 00 00 
  8016c6:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8016ca:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8016cb:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8016d2:	7f 00 00 
  8016d5:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016d9:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8016da:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8016e1:	7f 00 00 
  8016e4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016e8:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8016e9:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8016f0:	7f 00 00 
  8016f3:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8016f7:	c3                   	ret

00000000008016f8 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8016f8:	f3 0f 1e fa          	endbr64
  8016fc:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8016ff:	48 89 f9             	mov    %rdi,%rcx
  801702:	48 c1 e9 27          	shr    $0x27,%rcx
  801706:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  80170d:	7f 00 00 
  801710:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  801714:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  80171b:	f6 c1 01             	test   $0x1,%cl
  80171e:	0f 84 b2 00 00 00    	je     8017d6 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  801724:	48 89 f9             	mov    %rdi,%rcx
  801727:	48 c1 e9 1e          	shr    $0x1e,%rcx
  80172b:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801732:	7f 00 00 
  801735:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801739:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  801740:	40 f6 c6 01          	test   $0x1,%sil
  801744:	0f 84 8c 00 00 00    	je     8017d6 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  80174a:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801751:	7f 00 00 
  801754:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801758:	a8 80                	test   $0x80,%al
  80175a:	75 7b                	jne    8017d7 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  80175c:	48 89 f9             	mov    %rdi,%rcx
  80175f:	48 c1 e9 15          	shr    $0x15,%rcx
  801763:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80176a:	7f 00 00 
  80176d:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801771:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  801778:	40 f6 c6 01          	test   $0x1,%sil
  80177c:	74 58                	je     8017d6 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  80177e:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801785:	7f 00 00 
  801788:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80178c:	a8 80                	test   $0x80,%al
  80178e:	75 6c                	jne    8017fc <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  801790:	48 89 f9             	mov    %rdi,%rcx
  801793:	48 c1 e9 0c          	shr    $0xc,%rcx
  801797:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80179e:	7f 00 00 
  8017a1:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8017a5:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  8017ac:	40 f6 c6 01          	test   $0x1,%sil
  8017b0:	74 24                	je     8017d6 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  8017b2:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8017b9:	7f 00 00 
  8017bc:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017c0:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017c7:	ff ff 7f 
  8017ca:	48 21 c8             	and    %rcx,%rax
  8017cd:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8017d3:	48 09 d0             	or     %rdx,%rax
}
  8017d6:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8017d7:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8017de:	7f 00 00 
  8017e1:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8017e5:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8017ec:	ff ff 7f 
  8017ef:	48 21 c8             	and    %rcx,%rax
  8017f2:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8017f8:	48 01 d0             	add    %rdx,%rax
  8017fb:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8017fc:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801803:	7f 00 00 
  801806:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80180a:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  801811:	ff ff 7f 
  801814:	48 21 c8             	and    %rcx,%rax
  801817:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  80181d:	48 01 d0             	add    %rdx,%rax
  801820:	c3                   	ret

0000000000801821 <get_prot>:

int
get_prot(void *va) {
  801821:	f3 0f 1e fa          	endbr64
  801825:	55                   	push   %rbp
  801826:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801829:	48 b8 40 16 80 00 00 	movabs $0x801640,%rax
  801830:	00 00 00 
  801833:	ff d0                	call   *%rax
  801835:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  801838:	83 e0 01             	and    $0x1,%eax
  80183b:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80183e:	89 d1                	mov    %edx,%ecx
  801840:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  801846:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  801848:	89 c1                	mov    %eax,%ecx
  80184a:	83 c9 02             	or     $0x2,%ecx
  80184d:	f6 c2 02             	test   $0x2,%dl
  801850:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  801853:	89 c1                	mov    %eax,%ecx
  801855:	83 c9 01             	or     $0x1,%ecx
  801858:	48 85 d2             	test   %rdx,%rdx
  80185b:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80185e:	89 c1                	mov    %eax,%ecx
  801860:	83 c9 40             	or     $0x40,%ecx
  801863:	f6 c6 04             	test   $0x4,%dh
  801866:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801869:	5d                   	pop    %rbp
  80186a:	c3                   	ret

000000000080186b <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80186b:	f3 0f 1e fa          	endbr64
  80186f:	55                   	push   %rbp
  801870:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801873:	48 b8 40 16 80 00 00 	movabs $0x801640,%rax
  80187a:	00 00 00 
  80187d:	ff d0                	call   *%rax
    return pte & PTE_D;
  80187f:	48 c1 e8 06          	shr    $0x6,%rax
  801883:	83 e0 01             	and    $0x1,%eax
}
  801886:	5d                   	pop    %rbp
  801887:	c3                   	ret

0000000000801888 <is_page_present>:

bool
is_page_present(void *va) {
  801888:	f3 0f 1e fa          	endbr64
  80188c:	55                   	push   %rbp
  80188d:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  801890:	48 b8 40 16 80 00 00 	movabs $0x801640,%rax
  801897:	00 00 00 
  80189a:	ff d0                	call   *%rax
  80189c:	83 e0 01             	and    $0x1,%eax
}
  80189f:	5d                   	pop    %rbp
  8018a0:	c3                   	ret

00000000008018a1 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8018a1:	f3 0f 1e fa          	endbr64
  8018a5:	55                   	push   %rbp
  8018a6:	48 89 e5             	mov    %rsp,%rbp
  8018a9:	41 57                	push   %r15
  8018ab:	41 56                	push   %r14
  8018ad:	41 55                	push   %r13
  8018af:	41 54                	push   %r12
  8018b1:	53                   	push   %rbx
  8018b2:	48 83 ec 18          	sub    $0x18,%rsp
  8018b6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8018ba:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8018be:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8018c3:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8018ca:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8018cd:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8018d4:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8018d7:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8018de:	00 00 00 
  8018e1:	eb 73                	jmp    801956 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018e3:	48 89 d8             	mov    %rbx,%rax
  8018e6:	48 c1 e8 15          	shr    $0x15,%rax
  8018ea:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8018f1:	7f 00 00 
  8018f4:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8018f8:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8018fe:	f6 c2 01             	test   $0x1,%dl
  801901:	74 4b                	je     80194e <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  801903:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  801907:	f6 c2 80             	test   $0x80,%dl
  80190a:	74 11                	je     80191d <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  80190c:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  801910:	f6 c4 04             	test   $0x4,%ah
  801913:	74 39                	je     80194e <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  801915:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  80191b:	eb 20                	jmp    80193d <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80191d:	48 89 da             	mov    %rbx,%rdx
  801920:	48 c1 ea 0c          	shr    $0xc,%rdx
  801924:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80192b:	7f 00 00 
  80192e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  801932:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801938:	f6 c4 04             	test   $0x4,%ah
  80193b:	74 11                	je     80194e <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  80193d:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  801941:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801945:	48 89 df             	mov    %rbx,%rdi
  801948:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80194c:	ff d0                	call   *%rax
    next:
        va += size;
  80194e:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  801951:	49 39 df             	cmp    %rbx,%r15
  801954:	72 3e                	jb     801994 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  801956:	49 8b 06             	mov    (%r14),%rax
  801959:	a8 01                	test   $0x1,%al
  80195b:	74 37                	je     801994 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80195d:	48 89 d8             	mov    %rbx,%rax
  801960:	48 c1 e8 1e          	shr    $0x1e,%rax
  801964:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  801969:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80196f:	f6 c2 01             	test   $0x1,%dl
  801972:	74 da                	je     80194e <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  801974:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  801979:	f6 c2 80             	test   $0x80,%dl
  80197c:	0f 84 61 ff ff ff    	je     8018e3 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  801982:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  801987:	f6 c4 04             	test   $0x4,%ah
  80198a:	74 c2                	je     80194e <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  80198c:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  801992:	eb a9                	jmp    80193d <foreach_shared_region+0x9c>
    }
    return res;
}
  801994:	b8 00 00 00 00       	mov    $0x0,%eax
  801999:	48 83 c4 18          	add    $0x18,%rsp
  80199d:	5b                   	pop    %rbx
  80199e:	41 5c                	pop    %r12
  8019a0:	41 5d                	pop    %r13
  8019a2:	41 5e                	pop    %r14
  8019a4:	41 5f                	pop    %r15
  8019a6:	5d                   	pop    %rbp
  8019a7:	c3                   	ret

00000000008019a8 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  8019a8:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  8019ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b1:	c3                   	ret

00000000008019b2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8019b2:	f3 0f 1e fa          	endbr64
  8019b6:	55                   	push   %rbp
  8019b7:	48 89 e5             	mov    %rsp,%rbp
  8019ba:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8019bd:	48 be a5 30 80 00 00 	movabs $0x8030a5,%rsi
  8019c4:	00 00 00 
  8019c7:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  8019ce:	00 00 00 
  8019d1:	ff d0                	call   *%rax
    return 0;
}
  8019d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d8:	5d                   	pop    %rbp
  8019d9:	c3                   	ret

00000000008019da <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8019da:	f3 0f 1e fa          	endbr64
  8019de:	55                   	push   %rbp
  8019df:	48 89 e5             	mov    %rsp,%rbp
  8019e2:	41 57                	push   %r15
  8019e4:	41 56                	push   %r14
  8019e6:	41 55                	push   %r13
  8019e8:	41 54                	push   %r12
  8019ea:	53                   	push   %rbx
  8019eb:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8019f2:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8019f9:	48 85 d2             	test   %rdx,%rdx
  8019fc:	74 7a                	je     801a78 <devcons_write+0x9e>
  8019fe:	49 89 d6             	mov    %rdx,%r14
  801a01:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a07:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  801a0c:	49 bf b3 28 80 00 00 	movabs $0x8028b3,%r15
  801a13:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  801a16:	4c 89 f3             	mov    %r14,%rbx
  801a19:	48 29 f3             	sub    %rsi,%rbx
  801a1c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a21:	48 39 c3             	cmp    %rax,%rbx
  801a24:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801a28:	4c 63 eb             	movslq %ebx,%r13
  801a2b:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801a32:	48 01 c6             	add    %rax,%rsi
  801a35:	4c 89 ea             	mov    %r13,%rdx
  801a38:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a3f:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  801a42:	4c 89 ee             	mov    %r13,%rsi
  801a45:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801a4c:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  801a53:	00 00 00 
  801a56:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801a58:	41 01 dc             	add    %ebx,%r12d
  801a5b:	49 63 f4             	movslq %r12d,%rsi
  801a5e:	4c 39 f6             	cmp    %r14,%rsi
  801a61:	72 b3                	jb     801a16 <devcons_write+0x3c>
    return res;
  801a63:	49 63 c4             	movslq %r12d,%rax
}
  801a66:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801a6d:	5b                   	pop    %rbx
  801a6e:	41 5c                	pop    %r12
  801a70:	41 5d                	pop    %r13
  801a72:	41 5e                	pop    %r14
  801a74:	41 5f                	pop    %r15
  801a76:	5d                   	pop    %rbp
  801a77:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  801a78:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801a7e:	eb e3                	jmp    801a63 <devcons_write+0x89>

0000000000801a80 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a80:	f3 0f 1e fa          	endbr64
  801a84:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801a87:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8c:	48 85 c0             	test   %rax,%rax
  801a8f:	74 55                	je     801ae6 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801a91:	55                   	push   %rbp
  801a92:	48 89 e5             	mov    %rsp,%rbp
  801a95:	41 55                	push   %r13
  801a97:	41 54                	push   %r12
  801a99:	53                   	push   %rbx
  801a9a:	48 83 ec 08          	sub    $0x8,%rsp
  801a9e:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801aa1:	48 bb 54 01 80 00 00 	movabs $0x800154,%rbx
  801aa8:	00 00 00 
  801aab:	49 bc 2d 02 80 00 00 	movabs $0x80022d,%r12
  801ab2:	00 00 00 
  801ab5:	eb 03                	jmp    801aba <devcons_read+0x3a>
  801ab7:	41 ff d4             	call   *%r12
  801aba:	ff d3                	call   *%rbx
  801abc:	85 c0                	test   %eax,%eax
  801abe:	74 f7                	je     801ab7 <devcons_read+0x37>
    if (c < 0) return c;
  801ac0:	48 63 d0             	movslq %eax,%rdx
  801ac3:	78 13                	js     801ad8 <devcons_read+0x58>
    if (c == 0x04) return 0;
  801ac5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aca:	83 f8 04             	cmp    $0x4,%eax
  801acd:	74 09                	je     801ad8 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  801acf:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801ad3:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801ad8:	48 89 d0             	mov    %rdx,%rax
  801adb:	48 83 c4 08          	add    $0x8,%rsp
  801adf:	5b                   	pop    %rbx
  801ae0:	41 5c                	pop    %r12
  801ae2:	41 5d                	pop    %r13
  801ae4:	5d                   	pop    %rbp
  801ae5:	c3                   	ret
  801ae6:	48 89 d0             	mov    %rdx,%rax
  801ae9:	c3                   	ret

0000000000801aea <cputchar>:
cputchar(int ch) {
  801aea:	f3 0f 1e fa          	endbr64
  801aee:	55                   	push   %rbp
  801aef:	48 89 e5             	mov    %rsp,%rbp
  801af2:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801af6:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801afa:	be 01 00 00 00       	mov    $0x1,%esi
  801aff:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801b03:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  801b0a:	00 00 00 
  801b0d:	ff d0                	call   *%rax
}
  801b0f:	c9                   	leave
  801b10:	c3                   	ret

0000000000801b11 <getchar>:
getchar(void) {
  801b11:	f3 0f 1e fa          	endbr64
  801b15:	55                   	push   %rbp
  801b16:	48 89 e5             	mov    %rsp,%rbp
  801b19:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801b1d:	ba 01 00 00 00       	mov    $0x1,%edx
  801b22:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801b26:	bf 00 00 00 00       	mov    $0x0,%edi
  801b2b:	48 b8 21 0a 80 00 00 	movabs $0x800a21,%rax
  801b32:	00 00 00 
  801b35:	ff d0                	call   *%rax
  801b37:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	78 06                	js     801b43 <getchar+0x32>
  801b3d:	74 08                	je     801b47 <getchar+0x36>
  801b3f:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  801b43:	89 d0                	mov    %edx,%eax
  801b45:	c9                   	leave
  801b46:	c3                   	ret
    return res < 0 ? res : res ? c :
  801b47:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801b4c:	eb f5                	jmp    801b43 <getchar+0x32>

0000000000801b4e <iscons>:
iscons(int fdnum) {
  801b4e:	f3 0f 1e fa          	endbr64
  801b52:	55                   	push   %rbp
  801b53:	48 89 e5             	mov    %rsp,%rbp
  801b56:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801b5a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b5e:	48 b8 26 07 80 00 00 	movabs $0x800726,%rax
  801b65:	00 00 00 
  801b68:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 18                	js     801b86 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  801b6e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b72:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801b79:	00 00 00 
  801b7c:	8b 00                	mov    (%rax),%eax
  801b7e:	39 02                	cmp    %eax,(%rdx)
  801b80:	0f 94 c0             	sete   %al
  801b83:	0f b6 c0             	movzbl %al,%eax
}
  801b86:	c9                   	leave
  801b87:	c3                   	ret

0000000000801b88 <opencons>:
opencons(void) {
  801b88:	f3 0f 1e fa          	endbr64
  801b8c:	55                   	push   %rbp
  801b8d:	48 89 e5             	mov    %rsp,%rbp
  801b90:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801b94:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801b98:	48 b8 c2 06 80 00 00 	movabs $0x8006c2,%rax
  801b9f:	00 00 00 
  801ba2:	ff d0                	call   *%rax
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	78 49                	js     801bf1 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801ba8:	b9 46 00 00 00       	mov    $0x46,%ecx
  801bad:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bb2:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801bb6:	bf 00 00 00 00       	mov    $0x0,%edi
  801bbb:	48 b8 c8 02 80 00 00 	movabs $0x8002c8,%rax
  801bc2:	00 00 00 
  801bc5:	ff d0                	call   *%rax
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	78 26                	js     801bf1 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  801bcb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bcf:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801bd6:	00 00 
  801bd8:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801bda:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801bde:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801be5:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  801bec:	00 00 00 
  801bef:	ff d0                	call   *%rax
}
  801bf1:	c9                   	leave
  801bf2:	c3                   	ret

0000000000801bf3 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801bf3:	f3 0f 1e fa          	endbr64
  801bf7:	55                   	push   %rbp
  801bf8:	48 89 e5             	mov    %rsp,%rbp
  801bfb:	41 56                	push   %r14
  801bfd:	41 55                	push   %r13
  801bff:	41 54                	push   %r12
  801c01:	53                   	push   %rbx
  801c02:	48 83 ec 50          	sub    $0x50,%rsp
  801c06:	49 89 fc             	mov    %rdi,%r12
  801c09:	41 89 f5             	mov    %esi,%r13d
  801c0c:	48 89 d3             	mov    %rdx,%rbx
  801c0f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c13:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801c17:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801c1b:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801c22:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c26:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801c2a:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801c2e:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801c32:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801c39:	00 00 00 
  801c3c:	4c 8b 30             	mov    (%rax),%r14
  801c3f:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  801c46:	00 00 00 
  801c49:	ff d0                	call   *%rax
  801c4b:	89 c6                	mov    %eax,%esi
  801c4d:	45 89 e8             	mov    %r13d,%r8d
  801c50:	4c 89 e1             	mov    %r12,%rcx
  801c53:	4c 89 f2             	mov    %r14,%rdx
  801c56:	48 bf e8 32 80 00 00 	movabs $0x8032e8,%rdi
  801c5d:	00 00 00 
  801c60:	b8 00 00 00 00       	mov    $0x0,%eax
  801c65:	49 bc 4f 1d 80 00 00 	movabs $0x801d4f,%r12
  801c6c:	00 00 00 
  801c6f:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801c72:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801c76:	48 89 df             	mov    %rbx,%rdi
  801c79:	48 b8 e7 1c 80 00 00 	movabs $0x801ce7,%rax
  801c80:	00 00 00 
  801c83:	ff d0                	call   *%rax
    cprintf("\n");
  801c85:	48 bf 32 30 80 00 00 	movabs $0x803032,%rdi
  801c8c:	00 00 00 
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c94:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801c97:	cc                   	int3
  801c98:	eb fd                	jmp    801c97 <_panic+0xa4>

0000000000801c9a <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801c9a:	f3 0f 1e fa          	endbr64
  801c9e:	55                   	push   %rbp
  801c9f:	48 89 e5             	mov    %rsp,%rbp
  801ca2:	53                   	push   %rbx
  801ca3:	48 83 ec 08          	sub    $0x8,%rsp
  801ca7:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801caa:	8b 06                	mov    (%rsi),%eax
  801cac:	8d 50 01             	lea    0x1(%rax),%edx
  801caf:	89 16                	mov    %edx,(%rsi)
  801cb1:	48 98                	cltq
  801cb3:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801cb8:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801cbe:	74 0a                	je     801cca <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801cc0:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801cc4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cc8:	c9                   	leave
  801cc9:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  801cca:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801cce:	be ff 00 00 00       	mov    $0xff,%esi
  801cd3:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  801cda:	00 00 00 
  801cdd:	ff d0                	call   *%rax
        state->offset = 0;
  801cdf:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801ce5:	eb d9                	jmp    801cc0 <putch+0x26>

0000000000801ce7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801ce7:	f3 0f 1e fa          	endbr64
  801ceb:	55                   	push   %rbp
  801cec:	48 89 e5             	mov    %rsp,%rbp
  801cef:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801cf6:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801cf9:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801d00:	b9 21 00 00 00       	mov    $0x21,%ecx
  801d05:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0a:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801d0d:	48 89 f1             	mov    %rsi,%rcx
  801d10:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801d17:	48 bf 9a 1c 80 00 00 	movabs $0x801c9a,%rdi
  801d1e:	00 00 00 
  801d21:	48 b8 af 1e 80 00 00 	movabs $0x801eaf,%rax
  801d28:	00 00 00 
  801d2b:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801d2d:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801d34:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801d3b:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  801d42:	00 00 00 
  801d45:	ff d0                	call   *%rax

    return state.count;
}
  801d47:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801d4d:	c9                   	leave
  801d4e:	c3                   	ret

0000000000801d4f <cprintf>:

int
cprintf(const char *fmt, ...) {
  801d4f:	f3 0f 1e fa          	endbr64
  801d53:	55                   	push   %rbp
  801d54:	48 89 e5             	mov    %rsp,%rbp
  801d57:	48 83 ec 50          	sub    $0x50,%rsp
  801d5b:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801d5f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801d63:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d67:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801d6b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  801d6f:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  801d76:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d7a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801d7e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801d82:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  801d86:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  801d8a:	48 b8 e7 1c 80 00 00 	movabs $0x801ce7,%rax
  801d91:	00 00 00 
  801d94:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  801d96:	c9                   	leave
  801d97:	c3                   	ret

0000000000801d98 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  801d98:	f3 0f 1e fa          	endbr64
  801d9c:	55                   	push   %rbp
  801d9d:	48 89 e5             	mov    %rsp,%rbp
  801da0:	41 57                	push   %r15
  801da2:	41 56                	push   %r14
  801da4:	41 55                	push   %r13
  801da6:	41 54                	push   %r12
  801da8:	53                   	push   %rbx
  801da9:	48 83 ec 18          	sub    $0x18,%rsp
  801dad:	49 89 fc             	mov    %rdi,%r12
  801db0:	49 89 f5             	mov    %rsi,%r13
  801db3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801db7:	8b 45 10             	mov    0x10(%rbp),%eax
  801dba:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  801dbd:	41 89 cf             	mov    %ecx,%r15d
  801dc0:	4c 39 fa             	cmp    %r15,%rdx
  801dc3:	73 5b                	jae    801e20 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  801dc5:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  801dc9:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  801dcd:	85 db                	test   %ebx,%ebx
  801dcf:	7e 0e                	jle    801ddf <print_num+0x47>
            putch(padc, put_arg);
  801dd1:	4c 89 ee             	mov    %r13,%rsi
  801dd4:	44 89 f7             	mov    %r14d,%edi
  801dd7:	41 ff d4             	call   *%r12
        while (--width > 0) {
  801dda:	83 eb 01             	sub    $0x1,%ebx
  801ddd:	75 f2                	jne    801dd1 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  801ddf:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  801de3:	48 b9 c2 30 80 00 00 	movabs $0x8030c2,%rcx
  801dea:	00 00 00 
  801ded:	48 b8 b1 30 80 00 00 	movabs $0x8030b1,%rax
  801df4:	00 00 00 
  801df7:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  801dfb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801dff:	ba 00 00 00 00       	mov    $0x0,%edx
  801e04:	49 f7 f7             	div    %r15
  801e07:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  801e0b:	4c 89 ee             	mov    %r13,%rsi
  801e0e:	41 ff d4             	call   *%r12
}
  801e11:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801e15:	5b                   	pop    %rbx
  801e16:	41 5c                	pop    %r12
  801e18:	41 5d                	pop    %r13
  801e1a:	41 5e                	pop    %r14
  801e1c:	41 5f                	pop    %r15
  801e1e:	5d                   	pop    %rbp
  801e1f:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  801e20:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e24:	ba 00 00 00 00       	mov    $0x0,%edx
  801e29:	49 f7 f7             	div    %r15
  801e2c:	48 83 ec 08          	sub    $0x8,%rsp
  801e30:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801e34:	52                   	push   %rdx
  801e35:	45 0f be c9          	movsbl %r9b,%r9d
  801e39:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  801e3d:	48 89 c2             	mov    %rax,%rdx
  801e40:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  801e47:	00 00 00 
  801e4a:	ff d0                	call   *%rax
  801e4c:	48 83 c4 10          	add    $0x10,%rsp
  801e50:	eb 8d                	jmp    801ddf <print_num+0x47>

0000000000801e52 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  801e52:	f3 0f 1e fa          	endbr64
    state->count++;
  801e56:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801e5a:	48 8b 06             	mov    (%rsi),%rax
  801e5d:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801e61:	73 0a                	jae    801e6d <sprintputch+0x1b>
        *state->start++ = ch;
  801e63:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e67:	48 89 16             	mov    %rdx,(%rsi)
  801e6a:	40 88 38             	mov    %dil,(%rax)
    }
}
  801e6d:	c3                   	ret

0000000000801e6e <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  801e6e:	f3 0f 1e fa          	endbr64
  801e72:	55                   	push   %rbp
  801e73:	48 89 e5             	mov    %rsp,%rbp
  801e76:	48 83 ec 50          	sub    $0x50,%rsp
  801e7a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e7e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801e82:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801e86:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801e8d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e91:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801e95:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801e99:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801e9d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801ea1:	48 b8 af 1e 80 00 00 	movabs $0x801eaf,%rax
  801ea8:	00 00 00 
  801eab:	ff d0                	call   *%rax
}
  801ead:	c9                   	leave
  801eae:	c3                   	ret

0000000000801eaf <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  801eaf:	f3 0f 1e fa          	endbr64
  801eb3:	55                   	push   %rbp
  801eb4:	48 89 e5             	mov    %rsp,%rbp
  801eb7:	41 57                	push   %r15
  801eb9:	41 56                	push   %r14
  801ebb:	41 55                	push   %r13
  801ebd:	41 54                	push   %r12
  801ebf:	53                   	push   %rbx
  801ec0:	48 83 ec 38          	sub    $0x38,%rsp
  801ec4:	49 89 fe             	mov    %rdi,%r14
  801ec7:	49 89 f5             	mov    %rsi,%r13
  801eca:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  801ecd:	48 8b 01             	mov    (%rcx),%rax
  801ed0:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  801ed4:	48 8b 41 08          	mov    0x8(%rcx),%rax
  801ed8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801edc:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801ee0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  801ee4:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  801ee8:	0f b6 3b             	movzbl (%rbx),%edi
  801eeb:	40 80 ff 25          	cmp    $0x25,%dil
  801eef:	74 18                	je     801f09 <vprintfmt+0x5a>
            if (!ch) return;
  801ef1:	40 84 ff             	test   %dil,%dil
  801ef4:	0f 84 b2 06 00 00    	je     8025ac <vprintfmt+0x6fd>
            putch(ch, put_arg);
  801efa:	40 0f b6 ff          	movzbl %dil,%edi
  801efe:	4c 89 ee             	mov    %r13,%rsi
  801f01:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  801f04:	4c 89 e3             	mov    %r12,%rbx
  801f07:	eb db                	jmp    801ee4 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  801f09:	be 00 00 00 00       	mov    $0x0,%esi
  801f0e:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  801f12:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  801f17:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f1d:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  801f24:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f28:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  801f2d:	41 0f b6 04 24       	movzbl (%r12),%eax
  801f32:	88 45 a0             	mov    %al,-0x60(%rbp)
  801f35:	83 e8 23             	sub    $0x23,%eax
  801f38:	3c 57                	cmp    $0x57,%al
  801f3a:	0f 87 52 06 00 00    	ja     802592 <vprintfmt+0x6e3>
  801f40:	0f b6 c0             	movzbl %al,%eax
  801f43:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  801f4a:	00 00 00 
  801f4d:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  801f51:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  801f54:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  801f58:	eb ce                	jmp    801f28 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  801f5a:	49 89 dc             	mov    %rbx,%r12
  801f5d:	be 01 00 00 00       	mov    $0x1,%esi
  801f62:	eb c4                	jmp    801f28 <vprintfmt+0x79>
            padc = ch;
  801f64:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  801f68:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  801f6b:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801f6e:	eb b8                	jmp    801f28 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f70:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801f73:	83 f8 2f             	cmp    $0x2f,%eax
  801f76:	77 24                	ja     801f9c <vprintfmt+0xed>
  801f78:	89 c1                	mov    %eax,%ecx
  801f7a:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  801f7e:	83 c0 08             	add    $0x8,%eax
  801f81:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801f84:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  801f87:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  801f8a:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801f8e:	79 98                	jns    801f28 <vprintfmt+0x79>
                width = precision;
  801f90:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  801f94:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801f9a:	eb 8c                	jmp    801f28 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  801f9c:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801fa0:	48 8d 41 08          	lea    0x8(%rcx),%rax
  801fa4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801fa8:	eb da                	jmp    801f84 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  801faa:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  801faf:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fb3:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  801fb9:	3c 39                	cmp    $0x39,%al
  801fbb:	77 1c                	ja     801fd9 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  801fbd:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  801fc1:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  801fc5:	0f b6 c0             	movzbl %al,%eax
  801fc8:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801fcd:	0f b6 03             	movzbl (%rbx),%eax
  801fd0:	3c 39                	cmp    $0x39,%al
  801fd2:	76 e9                	jbe    801fbd <vprintfmt+0x10e>
        process_precision:
  801fd4:	49 89 dc             	mov    %rbx,%r12
  801fd7:	eb b1                	jmp    801f8a <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  801fd9:	49 89 dc             	mov    %rbx,%r12
  801fdc:	eb ac                	jmp    801f8a <vprintfmt+0xdb>
            width = MAX(0, width);
  801fde:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  801fe1:	85 c9                	test   %ecx,%ecx
  801fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe8:	0f 49 c1             	cmovns %ecx,%eax
  801feb:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801fee:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801ff1:	e9 32 ff ff ff       	jmp    801f28 <vprintfmt+0x79>
            lflag++;
  801ff6:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801ff9:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  801ffc:	e9 27 ff ff ff       	jmp    801f28 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  802001:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802004:	83 f8 2f             	cmp    $0x2f,%eax
  802007:	77 19                	ja     802022 <vprintfmt+0x173>
  802009:	89 c2                	mov    %eax,%edx
  80200b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80200f:	83 c0 08             	add    $0x8,%eax
  802012:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802015:	8b 3a                	mov    (%rdx),%edi
  802017:	4c 89 ee             	mov    %r13,%rsi
  80201a:	41 ff d6             	call   *%r14
            break;
  80201d:	e9 c2 fe ff ff       	jmp    801ee4 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  802022:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802026:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80202a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80202e:	eb e5                	jmp    802015 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  802030:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802033:	83 f8 2f             	cmp    $0x2f,%eax
  802036:	77 5a                	ja     802092 <vprintfmt+0x1e3>
  802038:	89 c2                	mov    %eax,%edx
  80203a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80203e:	83 c0 08             	add    $0x8,%eax
  802041:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  802044:	8b 02                	mov    (%rdx),%eax
  802046:	89 c1                	mov    %eax,%ecx
  802048:	f7 d9                	neg    %ecx
  80204a:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80204d:	83 f9 13             	cmp    $0x13,%ecx
  802050:	7f 4e                	jg     8020a0 <vprintfmt+0x1f1>
  802052:	48 63 c1             	movslq %ecx,%rax
  802055:	48 ba 20 36 80 00 00 	movabs $0x803620,%rdx
  80205c:	00 00 00 
  80205f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802063:	48 85 c0             	test   %rax,%rax
  802066:	74 38                	je     8020a0 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  802068:	48 89 c1             	mov    %rax,%rcx
  80206b:	48 ba 80 30 80 00 00 	movabs $0x803080,%rdx
  802072:	00 00 00 
  802075:	4c 89 ee             	mov    %r13,%rsi
  802078:	4c 89 f7             	mov    %r14,%rdi
  80207b:	b8 00 00 00 00       	mov    $0x0,%eax
  802080:	49 b8 6e 1e 80 00 00 	movabs $0x801e6e,%r8
  802087:	00 00 00 
  80208a:	41 ff d0             	call   *%r8
  80208d:	e9 52 fe ff ff       	jmp    801ee4 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  802092:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802096:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80209a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80209e:	eb a4                	jmp    802044 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8020a0:	48 ba da 30 80 00 00 	movabs $0x8030da,%rdx
  8020a7:	00 00 00 
  8020aa:	4c 89 ee             	mov    %r13,%rsi
  8020ad:	4c 89 f7             	mov    %r14,%rdi
  8020b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b5:	49 b8 6e 1e 80 00 00 	movabs $0x801e6e,%r8
  8020bc:	00 00 00 
  8020bf:	41 ff d0             	call   *%r8
  8020c2:	e9 1d fe ff ff       	jmp    801ee4 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8020c7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8020ca:	83 f8 2f             	cmp    $0x2f,%eax
  8020cd:	77 6c                	ja     80213b <vprintfmt+0x28c>
  8020cf:	89 c2                	mov    %eax,%edx
  8020d1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8020d5:	83 c0 08             	add    $0x8,%eax
  8020d8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8020db:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8020de:	48 85 d2             	test   %rdx,%rdx
  8020e1:	48 b8 d3 30 80 00 00 	movabs $0x8030d3,%rax
  8020e8:	00 00 00 
  8020eb:	48 0f 45 c2          	cmovne %rdx,%rax
  8020ef:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8020f3:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8020f7:	7e 06                	jle    8020ff <vprintfmt+0x250>
  8020f9:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8020fd:	75 4a                	jne    802149 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8020ff:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802103:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802107:	0f b6 00             	movzbl (%rax),%eax
  80210a:	84 c0                	test   %al,%al
  80210c:	0f 85 9a 00 00 00    	jne    8021ac <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  802112:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802115:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  802119:	85 c0                	test   %eax,%eax
  80211b:	0f 8e c3 fd ff ff    	jle    801ee4 <vprintfmt+0x35>
  802121:	4c 89 ee             	mov    %r13,%rsi
  802124:	bf 20 00 00 00       	mov    $0x20,%edi
  802129:	41 ff d6             	call   *%r14
  80212c:	41 83 ec 01          	sub    $0x1,%r12d
  802130:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  802134:	75 eb                	jne    802121 <vprintfmt+0x272>
  802136:	e9 a9 fd ff ff       	jmp    801ee4 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80213b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80213f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802143:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802147:	eb 92                	jmp    8020db <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  802149:	49 63 f7             	movslq %r15d,%rsi
  80214c:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  802150:	48 b8 72 26 80 00 00 	movabs $0x802672,%rax
  802157:	00 00 00 
  80215a:	ff d0                	call   *%rax
  80215c:	48 89 c2             	mov    %rax,%rdx
  80215f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802162:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  802164:	8d 70 ff             	lea    -0x1(%rax),%esi
  802167:	89 75 ac             	mov    %esi,-0x54(%rbp)
  80216a:	85 c0                	test   %eax,%eax
  80216c:	7e 91                	jle    8020ff <vprintfmt+0x250>
  80216e:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  802173:	4c 89 ee             	mov    %r13,%rsi
  802176:	44 89 e7             	mov    %r12d,%edi
  802179:	41 ff d6             	call   *%r14
  80217c:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  802180:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802183:	83 f8 ff             	cmp    $0xffffffff,%eax
  802186:	75 eb                	jne    802173 <vprintfmt+0x2c4>
  802188:	e9 72 ff ff ff       	jmp    8020ff <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80218d:	0f b6 f8             	movzbl %al,%edi
  802190:	4c 89 ee             	mov    %r13,%rsi
  802193:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802196:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80219a:	49 83 c4 01          	add    $0x1,%r12
  80219e:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  8021a4:	84 c0                	test   %al,%al
  8021a6:	0f 84 66 ff ff ff    	je     802112 <vprintfmt+0x263>
  8021ac:	45 85 ff             	test   %r15d,%r15d
  8021af:	78 0a                	js     8021bb <vprintfmt+0x30c>
  8021b1:	41 83 ef 01          	sub    $0x1,%r15d
  8021b5:	0f 88 57 ff ff ff    	js     802112 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8021bb:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8021bf:	74 cc                	je     80218d <vprintfmt+0x2de>
  8021c1:	8d 50 e0             	lea    -0x20(%rax),%edx
  8021c4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8021c9:	80 fa 5e             	cmp    $0x5e,%dl
  8021cc:	77 c2                	ja     802190 <vprintfmt+0x2e1>
  8021ce:	eb bd                	jmp    80218d <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8021d0:	40 84 f6             	test   %sil,%sil
  8021d3:	75 26                	jne    8021fb <vprintfmt+0x34c>
    switch (lflag) {
  8021d5:	85 d2                	test   %edx,%edx
  8021d7:	74 59                	je     802232 <vprintfmt+0x383>
  8021d9:	83 fa 01             	cmp    $0x1,%edx
  8021dc:	74 7b                	je     802259 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8021de:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021e1:	83 f8 2f             	cmp    $0x2f,%eax
  8021e4:	0f 87 96 00 00 00    	ja     802280 <vprintfmt+0x3d1>
  8021ea:	89 c2                	mov    %eax,%edx
  8021ec:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8021f0:	83 c0 08             	add    $0x8,%eax
  8021f3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8021f6:	4c 8b 22             	mov    (%rdx),%r12
  8021f9:	eb 17                	jmp    802212 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8021fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8021fe:	83 f8 2f             	cmp    $0x2f,%eax
  802201:	77 21                	ja     802224 <vprintfmt+0x375>
  802203:	89 c2                	mov    %eax,%edx
  802205:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802209:	83 c0 08             	add    $0x8,%eax
  80220c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80220f:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  802212:	4d 85 e4             	test   %r12,%r12
  802215:	78 7a                	js     802291 <vprintfmt+0x3e2>
            num = i;
  802217:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  80221a:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80221f:	e9 50 02 00 00       	jmp    802474 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  802224:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802228:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80222c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802230:	eb dd                	jmp    80220f <vprintfmt+0x360>
        return va_arg(*ap, int);
  802232:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802235:	83 f8 2f             	cmp    $0x2f,%eax
  802238:	77 11                	ja     80224b <vprintfmt+0x39c>
  80223a:	89 c2                	mov    %eax,%edx
  80223c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802240:	83 c0 08             	add    $0x8,%eax
  802243:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802246:	4c 63 22             	movslq (%rdx),%r12
  802249:	eb c7                	jmp    802212 <vprintfmt+0x363>
  80224b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80224f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802253:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802257:	eb ed                	jmp    802246 <vprintfmt+0x397>
        return va_arg(*ap, long);
  802259:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80225c:	83 f8 2f             	cmp    $0x2f,%eax
  80225f:	77 11                	ja     802272 <vprintfmt+0x3c3>
  802261:	89 c2                	mov    %eax,%edx
  802263:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802267:	83 c0 08             	add    $0x8,%eax
  80226a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80226d:	4c 8b 22             	mov    (%rdx),%r12
  802270:	eb a0                	jmp    802212 <vprintfmt+0x363>
  802272:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802276:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80227a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80227e:	eb ed                	jmp    80226d <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  802280:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802284:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802288:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80228c:	e9 65 ff ff ff       	jmp    8021f6 <vprintfmt+0x347>
                putch('-', put_arg);
  802291:	4c 89 ee             	mov    %r13,%rsi
  802294:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802299:	41 ff d6             	call   *%r14
                i = -i;
  80229c:	49 f7 dc             	neg    %r12
  80229f:	e9 73 ff ff ff       	jmp    802217 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  8022a4:	40 84 f6             	test   %sil,%sil
  8022a7:	75 32                	jne    8022db <vprintfmt+0x42c>
    switch (lflag) {
  8022a9:	85 d2                	test   %edx,%edx
  8022ab:	74 5d                	je     80230a <vprintfmt+0x45b>
  8022ad:	83 fa 01             	cmp    $0x1,%edx
  8022b0:	0f 84 82 00 00 00    	je     802338 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8022b6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022b9:	83 f8 2f             	cmp    $0x2f,%eax
  8022bc:	0f 87 a5 00 00 00    	ja     802367 <vprintfmt+0x4b8>
  8022c2:	89 c2                	mov    %eax,%edx
  8022c4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022c8:	83 c0 08             	add    $0x8,%eax
  8022cb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022ce:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022d1:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8022d6:	e9 99 01 00 00       	jmp    802474 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8022db:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022de:	83 f8 2f             	cmp    $0x2f,%eax
  8022e1:	77 19                	ja     8022fc <vprintfmt+0x44d>
  8022e3:	89 c2                	mov    %eax,%edx
  8022e5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8022e9:	83 c0 08             	add    $0x8,%eax
  8022ec:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022ef:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8022f2:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8022f7:	e9 78 01 00 00       	jmp    802474 <vprintfmt+0x5c5>
  8022fc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802300:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802304:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802308:	eb e5                	jmp    8022ef <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  80230a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80230d:	83 f8 2f             	cmp    $0x2f,%eax
  802310:	77 18                	ja     80232a <vprintfmt+0x47b>
  802312:	89 c2                	mov    %eax,%edx
  802314:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802318:	83 c0 08             	add    $0x8,%eax
  80231b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80231e:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  802320:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802325:	e9 4a 01 00 00       	jmp    802474 <vprintfmt+0x5c5>
  80232a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80232e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802332:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802336:	eb e6                	jmp    80231e <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  802338:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80233b:	83 f8 2f             	cmp    $0x2f,%eax
  80233e:	77 19                	ja     802359 <vprintfmt+0x4aa>
  802340:	89 c2                	mov    %eax,%edx
  802342:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802346:	83 c0 08             	add    $0x8,%eax
  802349:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80234c:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80234f:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  802354:	e9 1b 01 00 00       	jmp    802474 <vprintfmt+0x5c5>
  802359:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80235d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802361:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802365:	eb e5                	jmp    80234c <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  802367:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80236b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80236f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802373:	e9 56 ff ff ff       	jmp    8022ce <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  802378:	40 84 f6             	test   %sil,%sil
  80237b:	75 2e                	jne    8023ab <vprintfmt+0x4fc>
    switch (lflag) {
  80237d:	85 d2                	test   %edx,%edx
  80237f:	74 59                	je     8023da <vprintfmt+0x52b>
  802381:	83 fa 01             	cmp    $0x1,%edx
  802384:	74 7f                	je     802405 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  802386:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802389:	83 f8 2f             	cmp    $0x2f,%eax
  80238c:	0f 87 9f 00 00 00    	ja     802431 <vprintfmt+0x582>
  802392:	89 c2                	mov    %eax,%edx
  802394:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802398:	83 c0 08             	add    $0x8,%eax
  80239b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80239e:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023a1:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8023a6:	e9 c9 00 00 00       	jmp    802474 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8023ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023ae:	83 f8 2f             	cmp    $0x2f,%eax
  8023b1:	77 19                	ja     8023cc <vprintfmt+0x51d>
  8023b3:	89 c2                	mov    %eax,%edx
  8023b5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023b9:	83 c0 08             	add    $0x8,%eax
  8023bc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023bf:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8023c2:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8023c7:	e9 a8 00 00 00       	jmp    802474 <vprintfmt+0x5c5>
  8023cc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023d0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023d4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023d8:	eb e5                	jmp    8023bf <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8023da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023dd:	83 f8 2f             	cmp    $0x2f,%eax
  8023e0:	77 15                	ja     8023f7 <vprintfmt+0x548>
  8023e2:	89 c2                	mov    %eax,%edx
  8023e4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8023e8:	83 c0 08             	add    $0x8,%eax
  8023eb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8023ee:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8023f0:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8023f5:	eb 7d                	jmp    802474 <vprintfmt+0x5c5>
  8023f7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023fb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8023ff:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802403:	eb e9                	jmp    8023ee <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  802405:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802408:	83 f8 2f             	cmp    $0x2f,%eax
  80240b:	77 16                	ja     802423 <vprintfmt+0x574>
  80240d:	89 c2                	mov    %eax,%edx
  80240f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802413:	83 c0 08             	add    $0x8,%eax
  802416:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802419:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80241c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  802421:	eb 51                	jmp    802474 <vprintfmt+0x5c5>
  802423:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802427:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80242b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80242f:	eb e8                	jmp    802419 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  802431:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802435:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802439:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80243d:	e9 5c ff ff ff       	jmp    80239e <vprintfmt+0x4ef>
            putch('0', put_arg);
  802442:	4c 89 ee             	mov    %r13,%rsi
  802445:	bf 30 00 00 00       	mov    $0x30,%edi
  80244a:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  80244d:	4c 89 ee             	mov    %r13,%rsi
  802450:	bf 78 00 00 00       	mov    $0x78,%edi
  802455:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  802458:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80245b:	83 f8 2f             	cmp    $0x2f,%eax
  80245e:	77 47                	ja     8024a7 <vprintfmt+0x5f8>
  802460:	89 c2                	mov    %eax,%edx
  802462:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802466:	83 c0 08             	add    $0x8,%eax
  802469:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80246c:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80246f:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  802474:	48 83 ec 08          	sub    $0x8,%rsp
  802478:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  80247c:	0f 94 c0             	sete   %al
  80247f:	0f b6 c0             	movzbl %al,%eax
  802482:	50                   	push   %rax
  802483:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  802488:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80248c:	4c 89 ee             	mov    %r13,%rsi
  80248f:	4c 89 f7             	mov    %r14,%rdi
  802492:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  802499:	00 00 00 
  80249c:	ff d0                	call   *%rax
            break;
  80249e:	48 83 c4 10          	add    $0x10,%rsp
  8024a2:	e9 3d fa ff ff       	jmp    801ee4 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  8024a7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024ab:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8024af:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024b3:	eb b7                	jmp    80246c <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  8024b5:	40 84 f6             	test   %sil,%sil
  8024b8:	75 2b                	jne    8024e5 <vprintfmt+0x636>
    switch (lflag) {
  8024ba:	85 d2                	test   %edx,%edx
  8024bc:	74 56                	je     802514 <vprintfmt+0x665>
  8024be:	83 fa 01             	cmp    $0x1,%edx
  8024c1:	74 7f                	je     802542 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  8024c3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024c6:	83 f8 2f             	cmp    $0x2f,%eax
  8024c9:	0f 87 a2 00 00 00    	ja     802571 <vprintfmt+0x6c2>
  8024cf:	89 c2                	mov    %eax,%edx
  8024d1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024d5:	83 c0 08             	add    $0x8,%eax
  8024d8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024db:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024de:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8024e3:	eb 8f                	jmp    802474 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8024e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024e8:	83 f8 2f             	cmp    $0x2f,%eax
  8024eb:	77 19                	ja     802506 <vprintfmt+0x657>
  8024ed:	89 c2                	mov    %eax,%edx
  8024ef:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8024f3:	83 c0 08             	add    $0x8,%eax
  8024f6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024f9:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8024fc:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802501:	e9 6e ff ff ff       	jmp    802474 <vprintfmt+0x5c5>
  802506:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80250a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80250e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802512:	eb e5                	jmp    8024f9 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  802514:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802517:	83 f8 2f             	cmp    $0x2f,%eax
  80251a:	77 18                	ja     802534 <vprintfmt+0x685>
  80251c:	89 c2                	mov    %eax,%edx
  80251e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802522:	83 c0 08             	add    $0x8,%eax
  802525:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802528:	8b 12                	mov    (%rdx),%edx
            base = 16;
  80252a:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  80252f:	e9 40 ff ff ff       	jmp    802474 <vprintfmt+0x5c5>
  802534:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802538:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80253c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802540:	eb e6                	jmp    802528 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  802542:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802545:	83 f8 2f             	cmp    $0x2f,%eax
  802548:	77 19                	ja     802563 <vprintfmt+0x6b4>
  80254a:	89 c2                	mov    %eax,%edx
  80254c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802550:	83 c0 08             	add    $0x8,%eax
  802553:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802556:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802559:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  80255e:	e9 11 ff ff ff       	jmp    802474 <vprintfmt+0x5c5>
  802563:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802567:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80256b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80256f:	eb e5                	jmp    802556 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  802571:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802575:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802579:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80257d:	e9 59 ff ff ff       	jmp    8024db <vprintfmt+0x62c>
            putch(ch, put_arg);
  802582:	4c 89 ee             	mov    %r13,%rsi
  802585:	bf 25 00 00 00       	mov    $0x25,%edi
  80258a:	41 ff d6             	call   *%r14
            break;
  80258d:	e9 52 f9 ff ff       	jmp    801ee4 <vprintfmt+0x35>
            putch('%', put_arg);
  802592:	4c 89 ee             	mov    %r13,%rsi
  802595:	bf 25 00 00 00       	mov    $0x25,%edi
  80259a:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  80259d:	48 83 eb 01          	sub    $0x1,%rbx
  8025a1:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  8025a5:	75 f6                	jne    80259d <vprintfmt+0x6ee>
  8025a7:	e9 38 f9 ff ff       	jmp    801ee4 <vprintfmt+0x35>
}
  8025ac:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8025b0:	5b                   	pop    %rbx
  8025b1:	41 5c                	pop    %r12
  8025b3:	41 5d                	pop    %r13
  8025b5:	41 5e                	pop    %r14
  8025b7:	41 5f                	pop    %r15
  8025b9:	5d                   	pop    %rbp
  8025ba:	c3                   	ret

00000000008025bb <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  8025bb:	f3 0f 1e fa          	endbr64
  8025bf:	55                   	push   %rbp
  8025c0:	48 89 e5             	mov    %rsp,%rbp
  8025c3:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  8025c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025cb:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  8025d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8025d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8025db:	48 85 ff             	test   %rdi,%rdi
  8025de:	74 2b                	je     80260b <vsnprintf+0x50>
  8025e0:	48 85 f6             	test   %rsi,%rsi
  8025e3:	74 26                	je     80260b <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8025e5:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8025e9:	48 bf 52 1e 80 00 00 	movabs $0x801e52,%rdi
  8025f0:	00 00 00 
  8025f3:	48 b8 af 1e 80 00 00 	movabs $0x801eaf,%rax
  8025fa:	00 00 00 
  8025fd:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8025ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802603:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  802606:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802609:	c9                   	leave
  80260a:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  80260b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802610:	eb f7                	jmp    802609 <vsnprintf+0x4e>

0000000000802612 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  802612:	f3 0f 1e fa          	endbr64
  802616:	55                   	push   %rbp
  802617:	48 89 e5             	mov    %rsp,%rbp
  80261a:	48 83 ec 50          	sub    $0x50,%rsp
  80261e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802622:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802626:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80262a:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  802631:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802635:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802639:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80263d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  802641:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  802645:	48 b8 bb 25 80 00 00 	movabs $0x8025bb,%rax
  80264c:	00 00 00 
  80264f:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  802651:	c9                   	leave
  802652:	c3                   	ret

0000000000802653 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  802653:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  802657:	80 3f 00             	cmpb   $0x0,(%rdi)
  80265a:	74 10                	je     80266c <strlen+0x19>
    size_t n = 0;
  80265c:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  802661:	48 83 c0 01          	add    $0x1,%rax
  802665:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  802669:	75 f6                	jne    802661 <strlen+0xe>
  80266b:	c3                   	ret
    size_t n = 0;
  80266c:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  802671:	c3                   	ret

0000000000802672 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  802672:	f3 0f 1e fa          	endbr64
  802676:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  802679:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  80267e:	48 85 f6             	test   %rsi,%rsi
  802681:	74 10                	je     802693 <strnlen+0x21>
  802683:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  802687:	74 0b                	je     802694 <strnlen+0x22>
  802689:	48 83 c2 01          	add    $0x1,%rdx
  80268d:	48 39 d0             	cmp    %rdx,%rax
  802690:	75 f1                	jne    802683 <strnlen+0x11>
  802692:	c3                   	ret
  802693:	c3                   	ret
  802694:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  802697:	c3                   	ret

0000000000802698 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  802698:	f3 0f 1e fa          	endbr64
  80269c:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80269f:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a4:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  8026a8:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  8026ab:	48 83 c2 01          	add    $0x1,%rdx
  8026af:	84 c9                	test   %cl,%cl
  8026b1:	75 f1                	jne    8026a4 <strcpy+0xc>
        ;
    return res;
}
  8026b3:	c3                   	ret

00000000008026b4 <strcat>:

char *
strcat(char *dst, const char *src) {
  8026b4:	f3 0f 1e fa          	endbr64
  8026b8:	55                   	push   %rbp
  8026b9:	48 89 e5             	mov    %rsp,%rbp
  8026bc:	41 54                	push   %r12
  8026be:	53                   	push   %rbx
  8026bf:	48 89 fb             	mov    %rdi,%rbx
  8026c2:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8026c5:	48 b8 53 26 80 00 00 	movabs $0x802653,%rax
  8026cc:	00 00 00 
  8026cf:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  8026d1:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8026d5:	4c 89 e6             	mov    %r12,%rsi
  8026d8:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	call   *%rax
    return dst;
}
  8026e4:	48 89 d8             	mov    %rbx,%rax
  8026e7:	5b                   	pop    %rbx
  8026e8:	41 5c                	pop    %r12
  8026ea:	5d                   	pop    %rbp
  8026eb:	c3                   	ret

00000000008026ec <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8026ec:	f3 0f 1e fa          	endbr64
  8026f0:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  8026f3:	48 85 d2             	test   %rdx,%rdx
  8026f6:	74 1f                	je     802717 <strncpy+0x2b>
  8026f8:	48 01 fa             	add    %rdi,%rdx
  8026fb:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  8026fe:	48 83 c1 01          	add    $0x1,%rcx
  802702:	44 0f b6 06          	movzbl (%rsi),%r8d
  802706:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  80270a:	41 80 f8 01          	cmp    $0x1,%r8b
  80270e:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  802712:	48 39 ca             	cmp    %rcx,%rdx
  802715:	75 e7                	jne    8026fe <strncpy+0x12>
    }
    return ret;
}
  802717:	c3                   	ret

0000000000802718 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  802718:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  80271c:	48 89 f8             	mov    %rdi,%rax
  80271f:	48 85 d2             	test   %rdx,%rdx
  802722:	74 24                	je     802748 <strlcpy+0x30>
        while (--size > 0 && *src)
  802724:	48 83 ea 01          	sub    $0x1,%rdx
  802728:	74 1b                	je     802745 <strlcpy+0x2d>
  80272a:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80272e:	0f b6 16             	movzbl (%rsi),%edx
  802731:	84 d2                	test   %dl,%dl
  802733:	74 10                	je     802745 <strlcpy+0x2d>
            *dst++ = *src++;
  802735:	48 83 c6 01          	add    $0x1,%rsi
  802739:	48 83 c0 01          	add    $0x1,%rax
  80273d:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  802740:	48 39 c8             	cmp    %rcx,%rax
  802743:	75 e9                	jne    80272e <strlcpy+0x16>
        *dst = '\0';
  802745:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  802748:	48 29 f8             	sub    %rdi,%rax
}
  80274b:	c3                   	ret

000000000080274c <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  80274c:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  802750:	0f b6 07             	movzbl (%rdi),%eax
  802753:	84 c0                	test   %al,%al
  802755:	74 13                	je     80276a <strcmp+0x1e>
  802757:	38 06                	cmp    %al,(%rsi)
  802759:	75 0f                	jne    80276a <strcmp+0x1e>
  80275b:	48 83 c7 01          	add    $0x1,%rdi
  80275f:	48 83 c6 01          	add    $0x1,%rsi
  802763:	0f b6 07             	movzbl (%rdi),%eax
  802766:	84 c0                	test   %al,%al
  802768:	75 ed                	jne    802757 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  80276a:	0f b6 c0             	movzbl %al,%eax
  80276d:	0f b6 16             	movzbl (%rsi),%edx
  802770:	29 d0                	sub    %edx,%eax
}
  802772:	c3                   	ret

0000000000802773 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  802773:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  802777:	48 85 d2             	test   %rdx,%rdx
  80277a:	74 1f                	je     80279b <strncmp+0x28>
  80277c:	0f b6 07             	movzbl (%rdi),%eax
  80277f:	84 c0                	test   %al,%al
  802781:	74 1e                	je     8027a1 <strncmp+0x2e>
  802783:	3a 06                	cmp    (%rsi),%al
  802785:	75 1a                	jne    8027a1 <strncmp+0x2e>
  802787:	48 83 c7 01          	add    $0x1,%rdi
  80278b:	48 83 c6 01          	add    $0x1,%rsi
  80278f:	48 83 ea 01          	sub    $0x1,%rdx
  802793:	75 e7                	jne    80277c <strncmp+0x9>

    if (!n) return 0;
  802795:	b8 00 00 00 00       	mov    $0x0,%eax
  80279a:	c3                   	ret
  80279b:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a0:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  8027a1:	0f b6 07             	movzbl (%rdi),%eax
  8027a4:	0f b6 16             	movzbl (%rsi),%edx
  8027a7:	29 d0                	sub    %edx,%eax
}
  8027a9:	c3                   	ret

00000000008027aa <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  8027aa:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  8027ae:	0f b6 17             	movzbl (%rdi),%edx
  8027b1:	84 d2                	test   %dl,%dl
  8027b3:	74 18                	je     8027cd <strchr+0x23>
        if (*str == c) {
  8027b5:	0f be d2             	movsbl %dl,%edx
  8027b8:	39 f2                	cmp    %esi,%edx
  8027ba:	74 17                	je     8027d3 <strchr+0x29>
    for (; *str; str++) {
  8027bc:	48 83 c7 01          	add    $0x1,%rdi
  8027c0:	0f b6 17             	movzbl (%rdi),%edx
  8027c3:	84 d2                	test   %dl,%dl
  8027c5:	75 ee                	jne    8027b5 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  8027c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cc:	c3                   	ret
  8027cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d2:	c3                   	ret
            return (char *)str;
  8027d3:	48 89 f8             	mov    %rdi,%rax
}
  8027d6:	c3                   	ret

00000000008027d7 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  8027d7:	f3 0f 1e fa          	endbr64
  8027db:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  8027de:	0f b6 17             	movzbl (%rdi),%edx
  8027e1:	84 d2                	test   %dl,%dl
  8027e3:	74 13                	je     8027f8 <strfind+0x21>
  8027e5:	0f be d2             	movsbl %dl,%edx
  8027e8:	39 f2                	cmp    %esi,%edx
  8027ea:	74 0b                	je     8027f7 <strfind+0x20>
  8027ec:	48 83 c0 01          	add    $0x1,%rax
  8027f0:	0f b6 10             	movzbl (%rax),%edx
  8027f3:	84 d2                	test   %dl,%dl
  8027f5:	75 ee                	jne    8027e5 <strfind+0xe>
        ;
    return (char *)str;
}
  8027f7:	c3                   	ret
  8027f8:	c3                   	ret

00000000008027f9 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8027f9:	f3 0f 1e fa          	endbr64
  8027fd:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  802800:	48 89 f8             	mov    %rdi,%rax
  802803:	48 f7 d8             	neg    %rax
  802806:	83 e0 07             	and    $0x7,%eax
  802809:	49 89 d1             	mov    %rdx,%r9
  80280c:	49 29 c1             	sub    %rax,%r9
  80280f:	78 36                	js     802847 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  802811:	40 0f b6 c6          	movzbl %sil,%eax
  802815:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  80281c:	01 01 01 
  80281f:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  802823:	40 f6 c7 07          	test   $0x7,%dil
  802827:	75 38                	jne    802861 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  802829:	4c 89 c9             	mov    %r9,%rcx
  80282c:	48 c1 f9 03          	sar    $0x3,%rcx
  802830:	74 0c                	je     80283e <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  802832:	fc                   	cld
  802833:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  802836:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  80283a:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  80283e:	4d 85 c9             	test   %r9,%r9
  802841:	75 45                	jne    802888 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  802843:	4c 89 c0             	mov    %r8,%rax
  802846:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  802847:	48 85 d2             	test   %rdx,%rdx
  80284a:	74 f7                	je     802843 <memset+0x4a>
  80284c:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  80284f:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  802852:	48 83 c0 01          	add    $0x1,%rax
  802856:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  80285a:	48 39 c2             	cmp    %rax,%rdx
  80285d:	75 f3                	jne    802852 <memset+0x59>
  80285f:	eb e2                	jmp    802843 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  802861:	40 f6 c7 01          	test   $0x1,%dil
  802865:	74 06                	je     80286d <memset+0x74>
  802867:	88 07                	mov    %al,(%rdi)
  802869:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  80286d:	40 f6 c7 02          	test   $0x2,%dil
  802871:	74 07                	je     80287a <memset+0x81>
  802873:	66 89 07             	mov    %ax,(%rdi)
  802876:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  80287a:	40 f6 c7 04          	test   $0x4,%dil
  80287e:	74 a9                	je     802829 <memset+0x30>
  802880:	89 07                	mov    %eax,(%rdi)
  802882:	48 83 c7 04          	add    $0x4,%rdi
  802886:	eb a1                	jmp    802829 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  802888:	41 f6 c1 04          	test   $0x4,%r9b
  80288c:	74 1b                	je     8028a9 <memset+0xb0>
  80288e:	89 07                	mov    %eax,(%rdi)
  802890:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  802894:	41 f6 c1 02          	test   $0x2,%r9b
  802898:	74 07                	je     8028a1 <memset+0xa8>
  80289a:	66 89 07             	mov    %ax,(%rdi)
  80289d:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8028a1:	41 f6 c1 01          	test   $0x1,%r9b
  8028a5:	74 9c                	je     802843 <memset+0x4a>
  8028a7:	eb 06                	jmp    8028af <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8028a9:	41 f6 c1 02          	test   $0x2,%r9b
  8028ad:	75 eb                	jne    80289a <memset+0xa1>
        if (ni & 1) *ptr = k;
  8028af:	88 07                	mov    %al,(%rdi)
  8028b1:	eb 90                	jmp    802843 <memset+0x4a>

00000000008028b3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8028b3:	f3 0f 1e fa          	endbr64
  8028b7:	48 89 f8             	mov    %rdi,%rax
  8028ba:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8028bd:	48 39 fe             	cmp    %rdi,%rsi
  8028c0:	73 3b                	jae    8028fd <memmove+0x4a>
  8028c2:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8028c6:	48 39 d7             	cmp    %rdx,%rdi
  8028c9:	73 32                	jae    8028fd <memmove+0x4a>
        s += n;
        d += n;
  8028cb:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028cf:	48 89 d6             	mov    %rdx,%rsi
  8028d2:	48 09 fe             	or     %rdi,%rsi
  8028d5:	48 09 ce             	or     %rcx,%rsi
  8028d8:	40 f6 c6 07          	test   $0x7,%sil
  8028dc:	75 12                	jne    8028f0 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8028de:	48 83 ef 08          	sub    $0x8,%rdi
  8028e2:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8028e6:	48 c1 e9 03          	shr    $0x3,%rcx
  8028ea:	fd                   	std
  8028eb:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8028ee:	fc                   	cld
  8028ef:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8028f0:	48 83 ef 01          	sub    $0x1,%rdi
  8028f4:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8028f8:	fd                   	std
  8028f9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8028fb:	eb f1                	jmp    8028ee <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8028fd:	48 89 f2             	mov    %rsi,%rdx
  802900:	48 09 c2             	or     %rax,%rdx
  802903:	48 09 ca             	or     %rcx,%rdx
  802906:	f6 c2 07             	test   $0x7,%dl
  802909:	75 0c                	jne    802917 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80290b:	48 c1 e9 03          	shr    $0x3,%rcx
  80290f:	48 89 c7             	mov    %rax,%rdi
  802912:	fc                   	cld
  802913:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  802916:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  802917:	48 89 c7             	mov    %rax,%rdi
  80291a:	fc                   	cld
  80291b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  80291d:	c3                   	ret

000000000080291e <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  80291e:	f3 0f 1e fa          	endbr64
  802922:	55                   	push   %rbp
  802923:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  802926:	48 b8 b3 28 80 00 00 	movabs $0x8028b3,%rax
  80292d:	00 00 00 
  802930:	ff d0                	call   *%rax
}
  802932:	5d                   	pop    %rbp
  802933:	c3                   	ret

0000000000802934 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  802934:	f3 0f 1e fa          	endbr64
  802938:	55                   	push   %rbp
  802939:	48 89 e5             	mov    %rsp,%rbp
  80293c:	41 57                	push   %r15
  80293e:	41 56                	push   %r14
  802940:	41 55                	push   %r13
  802942:	41 54                	push   %r12
  802944:	53                   	push   %rbx
  802945:	48 83 ec 08          	sub    $0x8,%rsp
  802949:	49 89 fe             	mov    %rdi,%r14
  80294c:	49 89 f7             	mov    %rsi,%r15
  80294f:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  802952:	48 89 f7             	mov    %rsi,%rdi
  802955:	48 b8 53 26 80 00 00 	movabs $0x802653,%rax
  80295c:	00 00 00 
  80295f:	ff d0                	call   *%rax
  802961:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  802964:	48 89 de             	mov    %rbx,%rsi
  802967:	4c 89 f7             	mov    %r14,%rdi
  80296a:	48 b8 72 26 80 00 00 	movabs $0x802672,%rax
  802971:	00 00 00 
  802974:	ff d0                	call   *%rax
  802976:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  802979:	48 39 c3             	cmp    %rax,%rbx
  80297c:	74 36                	je     8029b4 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  80297e:	48 89 d8             	mov    %rbx,%rax
  802981:	4c 29 e8             	sub    %r13,%rax
  802984:	49 39 c4             	cmp    %rax,%r12
  802987:	73 31                	jae    8029ba <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  802989:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  80298e:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  802992:	4c 89 fe             	mov    %r15,%rsi
  802995:	48 b8 1e 29 80 00 00 	movabs $0x80291e,%rax
  80299c:	00 00 00 
  80299f:	ff d0                	call   *%rax
    return dstlen + srclen;
  8029a1:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8029a5:	48 83 c4 08          	add    $0x8,%rsp
  8029a9:	5b                   	pop    %rbx
  8029aa:	41 5c                	pop    %r12
  8029ac:	41 5d                	pop    %r13
  8029ae:	41 5e                	pop    %r14
  8029b0:	41 5f                	pop    %r15
  8029b2:	5d                   	pop    %rbp
  8029b3:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  8029b4:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  8029b8:	eb eb                	jmp    8029a5 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  8029ba:	48 83 eb 01          	sub    $0x1,%rbx
  8029be:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8029c2:	48 89 da             	mov    %rbx,%rdx
  8029c5:	4c 89 fe             	mov    %r15,%rsi
  8029c8:	48 b8 1e 29 80 00 00 	movabs $0x80291e,%rax
  8029cf:	00 00 00 
  8029d2:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8029d4:	49 01 de             	add    %rbx,%r14
  8029d7:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8029dc:	eb c3                	jmp    8029a1 <strlcat+0x6d>

00000000008029de <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8029de:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8029e2:	48 85 d2             	test   %rdx,%rdx
  8029e5:	74 2d                	je     802a14 <memcmp+0x36>
  8029e7:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8029ec:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8029f0:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8029f5:	44 38 c1             	cmp    %r8b,%cl
  8029f8:	75 0f                	jne    802a09 <memcmp+0x2b>
    while (n-- > 0) {
  8029fa:	48 83 c0 01          	add    $0x1,%rax
  8029fe:	48 39 c2             	cmp    %rax,%rdx
  802a01:	75 e9                	jne    8029ec <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  802a03:	b8 00 00 00 00       	mov    $0x0,%eax
  802a08:	c3                   	ret
            return (int)*s1 - (int)*s2;
  802a09:	0f b6 c1             	movzbl %cl,%eax
  802a0c:	45 0f b6 c0          	movzbl %r8b,%r8d
  802a10:	44 29 c0             	sub    %r8d,%eax
  802a13:	c3                   	ret
    return 0;
  802a14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a19:	c3                   	ret

0000000000802a1a <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  802a1a:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  802a1e:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  802a22:	48 39 c7             	cmp    %rax,%rdi
  802a25:	73 0f                	jae    802a36 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  802a27:	40 38 37             	cmp    %sil,(%rdi)
  802a2a:	74 0e                	je     802a3a <memfind+0x20>
    for (; src < end; src++) {
  802a2c:	48 83 c7 01          	add    $0x1,%rdi
  802a30:	48 39 f8             	cmp    %rdi,%rax
  802a33:	75 f2                	jne    802a27 <memfind+0xd>
  802a35:	c3                   	ret
  802a36:	48 89 f8             	mov    %rdi,%rax
  802a39:	c3                   	ret
  802a3a:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  802a3d:	c3                   	ret

0000000000802a3e <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  802a3e:	f3 0f 1e fa          	endbr64
  802a42:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  802a45:	0f b6 37             	movzbl (%rdi),%esi
  802a48:	40 80 fe 20          	cmp    $0x20,%sil
  802a4c:	74 06                	je     802a54 <strtol+0x16>
  802a4e:	40 80 fe 09          	cmp    $0x9,%sil
  802a52:	75 13                	jne    802a67 <strtol+0x29>
  802a54:	48 83 c7 01          	add    $0x1,%rdi
  802a58:	0f b6 37             	movzbl (%rdi),%esi
  802a5b:	40 80 fe 20          	cmp    $0x20,%sil
  802a5f:	74 f3                	je     802a54 <strtol+0x16>
  802a61:	40 80 fe 09          	cmp    $0x9,%sil
  802a65:	74 ed                	je     802a54 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  802a67:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  802a6a:	83 e0 fd             	and    $0xfffffffd,%eax
  802a6d:	3c 01                	cmp    $0x1,%al
  802a6f:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a73:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  802a79:	75 0f                	jne    802a8a <strtol+0x4c>
  802a7b:	80 3f 30             	cmpb   $0x30,(%rdi)
  802a7e:	74 14                	je     802a94 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  802a80:	85 d2                	test   %edx,%edx
  802a82:	b8 0a 00 00 00       	mov    $0xa,%eax
  802a87:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  802a8a:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  802a8f:	4c 63 ca             	movslq %edx,%r9
  802a92:	eb 36                	jmp    802aca <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  802a94:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  802a98:	74 0f                	je     802aa9 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  802a9a:	85 d2                	test   %edx,%edx
  802a9c:	75 ec                	jne    802a8a <strtol+0x4c>
        s++;
  802a9e:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  802aa2:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  802aa7:	eb e1                	jmp    802a8a <strtol+0x4c>
        s += 2;
  802aa9:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  802aad:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  802ab2:	eb d6                	jmp    802a8a <strtol+0x4c>
            dig -= '0';
  802ab4:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  802ab7:	44 0f b6 c1          	movzbl %cl,%r8d
  802abb:	41 39 d0             	cmp    %edx,%r8d
  802abe:	7d 21                	jge    802ae1 <strtol+0xa3>
        val = val * base + dig;
  802ac0:	49 0f af c1          	imul   %r9,%rax
  802ac4:	0f b6 c9             	movzbl %cl,%ecx
  802ac7:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  802aca:	48 83 c7 01          	add    $0x1,%rdi
  802ace:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  802ad2:	80 f9 39             	cmp    $0x39,%cl
  802ad5:	76 dd                	jbe    802ab4 <strtol+0x76>
        else if (dig - 'a' < 27)
  802ad7:	80 f9 7b             	cmp    $0x7b,%cl
  802ada:	77 05                	ja     802ae1 <strtol+0xa3>
            dig -= 'a' - 10;
  802adc:	83 e9 57             	sub    $0x57,%ecx
  802adf:	eb d6                	jmp    802ab7 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  802ae1:	4d 85 d2             	test   %r10,%r10
  802ae4:	74 03                	je     802ae9 <strtol+0xab>
  802ae6:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  802ae9:	48 89 c2             	mov    %rax,%rdx
  802aec:	48 f7 da             	neg    %rdx
  802aef:	40 80 fe 2d          	cmp    $0x2d,%sil
  802af3:	48 0f 44 c2          	cmove  %rdx,%rax
}
  802af7:	c3                   	ret

0000000000802af8 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802af8:	f3 0f 1e fa          	endbr64
  802afc:	55                   	push   %rbp
  802afd:	48 89 e5             	mov    %rsp,%rbp
  802b00:	41 54                	push   %r12
  802b02:	53                   	push   %rbx
  802b03:	48 89 fb             	mov    %rdi,%rbx
  802b06:	48 89 f7             	mov    %rsi,%rdi
  802b09:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b0c:	48 85 f6             	test   %rsi,%rsi
  802b0f:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b16:	00 00 00 
  802b19:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b1d:	be 00 10 00 00       	mov    $0x1000,%esi
  802b22:	48 b8 ea 05 80 00 00 	movabs $0x8005ea,%rax
  802b29:	00 00 00 
  802b2c:	ff d0                	call   *%rax
    if (res < 0) {
  802b2e:	85 c0                	test   %eax,%eax
  802b30:	78 45                	js     802b77 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b32:	48 85 db             	test   %rbx,%rbx
  802b35:	74 12                	je     802b49 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b37:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b3e:	00 00 00 
  802b41:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b47:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b49:	4d 85 e4             	test   %r12,%r12
  802b4c:	74 14                	je     802b62 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b4e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b55:	00 00 00 
  802b58:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b5e:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b62:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b69:	00 00 00 
  802b6c:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b72:	5b                   	pop    %rbx
  802b73:	41 5c                	pop    %r12
  802b75:	5d                   	pop    %rbp
  802b76:	c3                   	ret
        if (from_env_store != NULL) {
  802b77:	48 85 db             	test   %rbx,%rbx
  802b7a:	74 06                	je     802b82 <ipc_recv+0x8a>
            *from_env_store = 0;
  802b7c:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b82:	4d 85 e4             	test   %r12,%r12
  802b85:	74 eb                	je     802b72 <ipc_recv+0x7a>
            *perm_store = 0;
  802b87:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b8e:	00 
  802b8f:	eb e1                	jmp    802b72 <ipc_recv+0x7a>

0000000000802b91 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b91:	f3 0f 1e fa          	endbr64
  802b95:	55                   	push   %rbp
  802b96:	48 89 e5             	mov    %rsp,%rbp
  802b99:	41 57                	push   %r15
  802b9b:	41 56                	push   %r14
  802b9d:	41 55                	push   %r13
  802b9f:	41 54                	push   %r12
  802ba1:	53                   	push   %rbx
  802ba2:	48 83 ec 18          	sub    $0x18,%rsp
  802ba6:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802ba9:	48 89 d3             	mov    %rdx,%rbx
  802bac:	49 89 cc             	mov    %rcx,%r12
  802baf:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802bb2:	48 85 d2             	test   %rdx,%rdx
  802bb5:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bbc:	00 00 00 
  802bbf:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bc3:	89 f0                	mov    %esi,%eax
  802bc5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802bc9:	48 89 da             	mov    %rbx,%rdx
  802bcc:	48 89 c6             	mov    %rax,%rsi
  802bcf:	48 b8 ba 05 80 00 00 	movabs $0x8005ba,%rax
  802bd6:	00 00 00 
  802bd9:	ff d0                	call   *%rax
    while (res < 0) {
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	79 65                	jns    802c44 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bdf:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802be2:	75 33                	jne    802c17 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802be4:	49 bf 2d 02 80 00 00 	movabs $0x80022d,%r15
  802beb:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bee:	49 be ba 05 80 00 00 	movabs $0x8005ba,%r14
  802bf5:	00 00 00 
        sys_yield();
  802bf8:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bfb:	45 89 e8             	mov    %r13d,%r8d
  802bfe:	4c 89 e1             	mov    %r12,%rcx
  802c01:	48 89 da             	mov    %rbx,%rdx
  802c04:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802c08:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802c0b:	41 ff d6             	call   *%r14
    while (res < 0) {
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	79 32                	jns    802c44 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c12:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c15:	74 e1                	je     802bf8 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c17:	89 c1                	mov    %eax,%ecx
  802c19:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  802c20:	00 00 00 
  802c23:	be 42 00 00 00       	mov    $0x42,%esi
  802c28:	48 bf 4b 32 80 00 00 	movabs $0x80324b,%rdi
  802c2f:	00 00 00 
  802c32:	b8 00 00 00 00       	mov    $0x0,%eax
  802c37:	49 b8 f3 1b 80 00 00 	movabs $0x801bf3,%r8
  802c3e:	00 00 00 
  802c41:	41 ff d0             	call   *%r8
    }
}
  802c44:	48 83 c4 18          	add    $0x18,%rsp
  802c48:	5b                   	pop    %rbx
  802c49:	41 5c                	pop    %r12
  802c4b:	41 5d                	pop    %r13
  802c4d:	41 5e                	pop    %r14
  802c4f:	41 5f                	pop    %r15
  802c51:	5d                   	pop    %rbp
  802c52:	c3                   	ret

0000000000802c53 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c53:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c57:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c5c:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c63:	00 00 00 
  802c66:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c6a:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c6e:	48 c1 e2 04          	shl    $0x4,%rdx
  802c72:	48 01 ca             	add    %rcx,%rdx
  802c75:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c7b:	39 fa                	cmp    %edi,%edx
  802c7d:	74 12                	je     802c91 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c7f:	48 83 c0 01          	add    $0x1,%rax
  802c83:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c89:	75 db                	jne    802c66 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802c8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c90:	c3                   	ret
            return envs[i].env_id;
  802c91:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c95:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c99:	48 c1 e2 04          	shl    $0x4,%rdx
  802c9d:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802ca4:	00 00 00 
  802ca7:	48 01 d0             	add    %rdx,%rax
  802caa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cb0:	c3                   	ret

0000000000802cb1 <__text_end>:
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
