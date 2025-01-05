
obj/user/memlayout:     file format elf64-x86-64


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
  80001e:	e8 5a 03 00 00       	call   80037d <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <memlayout>:
#ifndef PROT_SHARE
#define PROT_SHARE 0x400
#endif

void
memlayout(void) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 57                	push   %r15
  80002f:	41 56                	push   %r14
  800031:	41 55                	push   %r13
  800033:	41 54                	push   %r12
  800035:	53                   	push   %rbx
  800036:	48 83 ec 48          	sub    $0x48,%rsp
    size_t total_p = 0;
    size_t total_u = 0;
    size_t total_w = 0;
    size_t total_cow = 0;

    cprintf("EID: %d, PEID: %d\n", thisenv->env_id, thisenv->env_parent_id);
  80003a:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  800041:	00 00 00 
  800044:	49 8b 04 24          	mov    (%r12),%rax
  800048:	8b 90 cc 00 00 00    	mov    0xcc(%rax),%edx
  80004e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800054:	48 bf 0c 40 80 00 00 	movabs $0x80400c,%rdi
  80005b:	00 00 00 
  80005e:	b8 00 00 00 00       	mov    $0x0,%eax
  800063:	48 bb b2 05 80 00 00 	movabs $0x8005b2,%rbx
  80006a:	00 00 00 
  80006d:	ff d3                	call   *%rbx
    cprintf("pml4=%p uvpml4=%p uvpdp=%p uvpd=%p uvpt=%p\n", thisenv->address_space.pml4,
  80006f:	49 8b 04 24          	mov    (%r12),%rax
  800073:	48 8b b0 e8 00 00 00 	mov    0xe8(%rax),%rsi
  80007a:	49 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%r9
  800081:	7f 00 00 
  800084:	49 b8 00 00 00 00 80 	movabs $0x7f8000000000,%r8
  80008b:	7f 00 00 
  80008e:	48 b9 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rcx
  800095:	7f 00 00 
  800098:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80009f:	7f 00 00 
  8000a2:	48 bf 78 43 80 00 00 	movabs $0x804378,%rdi
  8000a9:	00 00 00 
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	ff d3                	call   *%rbx
    size_t total_cow = 0;
  8000b3:	48 c7 45 90 00 00 00 	movq   $0x0,-0x70(%rbp)
  8000ba:	00 
    size_t total_w = 0;
  8000bb:	48 c7 45 98 00 00 00 	movq   $0x0,-0x68(%rbp)
  8000c2:	00 
    size_t total_u = 0;
  8000c3:	48 c7 45 a0 00 00 00 	movq   $0x0,-0x60(%rbp)
  8000ca:	00 
    size_t total_p = 0;
  8000cb:	48 c7 45 a8 00 00 00 	movq   $0x0,-0x58(%rbp)
  8000d2:	00 
            (void *)UVPML4, (void *)UVPDP, (void *)UVPT, (void *)UVPD);

    for (addr = 0; addr < KERN_BASE_ADDR; addr += PAGE_SIZE) {
  8000d3:	41 be 00 00 00 00    	mov    $0x0,%r14d
        pte_t ent = get_uvpt_entry((void *)addr);
  8000d9:	49 bd d4 29 80 00 00 	movabs $0x8029d4,%r13
  8000e0:	00 00 00 
        if (ent) {
            cprintf("[%p] %lx -> %08lx: %c %c %c |%s%s\n",
  8000e3:	49 bc 35 40 80 00 00 	movabs $0x804035,%r12
  8000ea:	00 00 00 
  8000ed:	eb 5f                	jmp    80014e <memlayout+0x129>
                    (void *)get_uvpt_entry((void *)addr), (unsigned long)addr, (unsigned long)ent,
  8000ef:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8000f3:	41 ff d5             	call   *%r13
  8000f6:	48 89 c6             	mov    %rax,%rsi
            cprintf("[%p] %lx -> %08lx: %c %c %c |%s%s\n",
  8000f9:	48 83 ec 08          	sub    $0x8,%rsp
  8000fd:	41 57                	push   %r15
  8000ff:	ff 75 c0             	push   -0x40(%rbp)
  800102:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800105:	50                   	push   %rax
  800106:	44 8b 4d b8          	mov    -0x48(%rbp),%r9d
  80010a:	44 8b 45 b4          	mov    -0x4c(%rbp),%r8d
  80010e:	48 89 d9             	mov    %rbx,%rcx
  800111:	4c 89 f2             	mov    %r14,%rdx
  800114:	48 bf a8 43 80 00 00 	movabs $0x8043a8,%rdi
  80011b:	00 00 00 
  80011e:	b8 00 00 00 00       	mov    $0x0,%eax
  800123:	49 ba b2 05 80 00 00 	movabs $0x8005b2,%r10
  80012a:	00 00 00 
  80012d:	41 ff d2             	call   *%r10
  800130:	48 83 c4 20          	add    $0x20,%rsp
    for (addr = 0; addr < KERN_BASE_ADDR; addr += PAGE_SIZE) {
  800134:	49 81 c6 00 10 00 00 	add    $0x1000,%r14
  80013b:	48 b8 00 00 00 40 80 	movabs $0x8040000000,%rax
  800142:	00 00 00 
  800145:	49 39 c6             	cmp    %rax,%r14
  800148:	0f 84 8f 00 00 00    	je     8001dd <memlayout+0x1b8>
        pte_t ent = get_uvpt_entry((void *)addr);
  80014e:	4c 89 75 c8          	mov    %r14,-0x38(%rbp)
  800152:	4c 89 f7             	mov    %r14,%rdi
  800155:	41 ff d5             	call   *%r13
  800158:	48 89 c3             	mov    %rax,%rbx
        if (ent) {
  80015b:	48 85 c0             	test   %rax,%rax
  80015e:	74 d4                	je     800134 <memlayout+0x10f>
            cprintf("[%p] %lx -> %08lx: %c %c %c |%s%s\n",
  800160:	a8 40                	test   $0x40,%al
  800162:	49 bf 00 40 80 00 00 	movabs $0x804000,%r15
  800169:	00 00 00 
  80016c:	4d 0f 44 fc          	cmove  %r12,%r15
  800170:	4c 89 65 c0          	mov    %r12,-0x40(%rbp)
  800174:	f6 c4 08             	test   $0x8,%ah
  800177:	74 13                	je     80018c <memlayout+0x167>
                    (ent & PTE_P)    ? total_p++, 'P' : '-',
                    (ent & PTE_U)    ? total_u++, 'U' : '-',
                    (ent & PTE_W)    ? total_w++, 'W' : '-',
                    (ent & PROT_COW) ? total_cow++, " COW" : "",
  800179:	48 83 45 90 01       	addq   $0x1,-0x70(%rbp)
            cprintf("[%p] %lx -> %08lx: %c %c %c |%s%s\n",
  80017e:	48 b8 07 40 80 00 00 	movabs $0x804007,%rax
  800185:	00 00 00 
  800188:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80018c:	c7 45 bc 2d 00 00 00 	movl   $0x2d,-0x44(%rbp)
  800193:	f6 c3 02             	test   $0x2,%bl
  800196:	74 0c                	je     8001a4 <memlayout+0x17f>
                    (ent & PTE_W)    ? total_w++, 'W' : '-',
  800198:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
            cprintf("[%p] %lx -> %08lx: %c %c %c |%s%s\n",
  80019d:	c7 45 bc 57 00 00 00 	movl   $0x57,-0x44(%rbp)
  8001a4:	c7 45 b8 2d 00 00 00 	movl   $0x2d,-0x48(%rbp)
  8001ab:	f6 c3 04             	test   $0x4,%bl
  8001ae:	74 0c                	je     8001bc <memlayout+0x197>
                    (ent & PTE_U)    ? total_u++, 'U' : '-',
  8001b0:	48 83 45 a0 01       	addq   $0x1,-0x60(%rbp)
            cprintf("[%p] %lx -> %08lx: %c %c %c |%s%s\n",
  8001b5:	c7 45 b8 55 00 00 00 	movl   $0x55,-0x48(%rbp)
  8001bc:	c7 45 b4 2d 00 00 00 	movl   $0x2d,-0x4c(%rbp)
  8001c3:	f6 c3 01             	test   $0x1,%bl
  8001c6:	0f 84 23 ff ff ff    	je     8000ef <memlayout+0xca>
                    (ent & PTE_P)    ? total_p++, 'P' : '-',
  8001cc:	48 83 45 a8 01       	addq   $0x1,-0x58(%rbp)
            cprintf("[%p] %lx -> %08lx: %c %c %c |%s%s\n",
  8001d1:	c7 45 b4 50 00 00 00 	movl   $0x50,-0x4c(%rbp)
  8001d8:	e9 12 ff ff ff       	jmp    8000ef <memlayout+0xca>
                    (ent & PROT_SHARE) ? " SHARE" : "");
        }
    }

    cprintf("Memory usage summary:\n");
  8001dd:	48 bf 1f 40 80 00 00 	movabs $0x80401f,%rdi
  8001e4:	00 00 00 
  8001e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ec:	48 bb b2 05 80 00 00 	movabs $0x8005b2,%rbx
  8001f3:	00 00 00 
  8001f6:	ff d3                	call   *%rbx
    cprintf("  PTE_P: %lu\n", (unsigned long)total_p);
  8001f8:	48 8b 75 a8          	mov    -0x58(%rbp),%rsi
  8001fc:	48 bf 36 40 80 00 00 	movabs $0x804036,%rdi
  800203:	00 00 00 
  800206:	b8 00 00 00 00       	mov    $0x0,%eax
  80020b:	ff d3                	call   *%rbx
    cprintf("  PTE_U: %lu\n", (unsigned long)total_u);
  80020d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800211:	48 bf 44 40 80 00 00 	movabs $0x804044,%rdi
  800218:	00 00 00 
  80021b:	b8 00 00 00 00       	mov    $0x0,%eax
  800220:	ff d3                	call   *%rbx
    cprintf("  PTE_W: %lu\n", (unsigned long)total_w);
  800222:	48 8b 75 98          	mov    -0x68(%rbp),%rsi
  800226:	48 bf 52 40 80 00 00 	movabs $0x804052,%rdi
  80022d:	00 00 00 
  800230:	b8 00 00 00 00       	mov    $0x0,%eax
  800235:	ff d3                	call   *%rbx
    cprintf("  PTE_COW: %lu\n", (unsigned long)total_cow);
  800237:	48 8b 75 90          	mov    -0x70(%rbp),%rsi
  80023b:	48 bf 60 40 80 00 00 	movabs $0x804060,%rdi
  800242:	00 00 00 
  800245:	b8 00 00 00 00       	mov    $0x0,%eax
  80024a:	ff d3                	call   *%rbx
}
  80024c:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800250:	5b                   	pop    %rbx
  800251:	41 5c                	pop    %r12
  800253:	41 5d                	pop    %r13
  800255:	41 5e                	pop    %r14
  800257:	41 5f                	pop    %r15
  800259:	5d                   	pop    %rbp
  80025a:	c3                   	ret

000000000080025b <umain>:

void
umain(int argc, char *argv[]) {
  80025b:	f3 0f 1e fa          	endbr64
  80025f:	55                   	push   %rbp
  800260:	48 89 e5             	mov    %rsp,%rbp
  800263:	41 54                	push   %r12
  800265:	53                   	push   %rbx
  800266:	48 83 ec 10          	sub    $0x10,%rsp
    envid_t ceid;
    int pipefd[2];
    int res;

    memlayout();
  80026a:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800271:	00 00 00 
  800274:	ff d0                	call   *%rax

    res = pipe(pipefd);
  800276:	48 8d 7d e8          	lea    -0x18(%rbp),%rdi
  80027a:	48 b8 6d 27 80 00 00 	movabs $0x80276d,%rax
  800281:	00 00 00 
  800284:	ff d0                	call   *%rax
    if (res < 0) panic("pipe() failed\n");
  800286:	85 c0                	test   %eax,%eax
  800288:	78 46                	js     8002d0 <umain+0x75>
    ceid = fork();
  80028a:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  800291:	00 00 00 
  800294:	ff d0                	call   *%rax
    if (ceid < 0) panic("fork() failed\n");
  800296:	85 c0                	test   %eax,%eax
  800298:	78 60                	js     8002fa <umain+0x9f>

    if (!ceid) {
  80029a:	0f 84 84 00 00 00    	je     800324 <umain+0xc9>
        cprintf("==== Child\n");
        memlayout();
        return;
    }

    cprintf("==== Parent\n");
  8002a0:	48 bf ab 40 80 00 00 	movabs $0x8040ab,%rdi
  8002a7:	00 00 00 
  8002aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8002af:	48 ba b2 05 80 00 00 	movabs $0x8005b2,%rdx
  8002b6:	00 00 00 
  8002b9:	ff d2                	call   *%rdx
    memlayout();
  8002bb:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8002c2:	00 00 00 
  8002c5:	ff d0                	call   *%rax
}
  8002c7:	48 83 c4 10          	add    $0x10,%rsp
  8002cb:	5b                   	pop    %rbx
  8002cc:	41 5c                	pop    %r12
  8002ce:	5d                   	pop    %rbp
  8002cf:	c3                   	ret
    if (res < 0) panic("pipe() failed\n");
  8002d0:	48 ba 70 40 80 00 00 	movabs $0x804070,%rdx
  8002d7:	00 00 00 
  8002da:	be 33 00 00 00       	mov    $0x33,%esi
  8002df:	48 bf 7f 40 80 00 00 	movabs $0x80407f,%rdi
  8002e6:	00 00 00 
  8002e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ee:	48 b9 56 04 80 00 00 	movabs $0x800456,%rcx
  8002f5:	00 00 00 
  8002f8:	ff d1                	call   *%rcx
    if (ceid < 0) panic("fork() failed\n");
  8002fa:	48 ba 90 40 80 00 00 	movabs $0x804090,%rdx
  800301:	00 00 00 
  800304:	be 35 00 00 00       	mov    $0x35,%esi
  800309:	48 bf 7f 40 80 00 00 	movabs $0x80407f,%rdi
  800310:	00 00 00 
  800313:	b8 00 00 00 00       	mov    $0x0,%eax
  800318:	48 b9 56 04 80 00 00 	movabs $0x800456,%rcx
  80031f:	00 00 00 
  800322:	ff d1                	call   *%rcx
        cprintf("\n");
  800324:	48 bf 34 40 80 00 00 	movabs $0x804034,%rdi
  80032b:	00 00 00 
  80032e:	48 ba b2 05 80 00 00 	movabs $0x8005b2,%rdx
  800335:	00 00 00 
  800338:	ff d2                	call   *%rdx
  80033a:	bb 00 90 01 00       	mov    $0x19000,%ebx
            sys_yield();
  80033f:	49 bc 65 14 80 00 00 	movabs $0x801465,%r12
  800346:	00 00 00 
  800349:	41 ff d4             	call   *%r12
        for (i = 0; i < 102400; i++)
  80034c:	83 eb 01             	sub    $0x1,%ebx
  80034f:	75 f8                	jne    800349 <umain+0xee>
        cprintf("==== Child\n");
  800351:	48 bf 9f 40 80 00 00 	movabs $0x80409f,%rdi
  800358:	00 00 00 
  80035b:	b8 00 00 00 00       	mov    $0x0,%eax
  800360:	48 ba b2 05 80 00 00 	movabs $0x8005b2,%rdx
  800367:	00 00 00 
  80036a:	ff d2                	call   *%rdx
        memlayout();
  80036c:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800373:	00 00 00 
  800376:	ff d0                	call   *%rax
        return;
  800378:	e9 4a ff ff ff       	jmp    8002c7 <umain+0x6c>

000000000080037d <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80037d:	f3 0f 1e fa          	endbr64
  800381:	55                   	push   %rbp
  800382:	48 89 e5             	mov    %rsp,%rbp
  800385:	41 56                	push   %r14
  800387:	41 55                	push   %r13
  800389:	41 54                	push   %r12
  80038b:	53                   	push   %rbx
  80038c:	41 89 fd             	mov    %edi,%r13d
  80038f:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800392:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  800399:	00 00 00 
  80039c:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  8003a3:	00 00 00 
  8003a6:	48 39 c2             	cmp    %rax,%rdx
  8003a9:	73 17                	jae    8003c2 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8003ab:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8003ae:	49 89 c4             	mov    %rax,%r12
  8003b1:	48 83 c3 08          	add    $0x8,%rbx
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ba:	ff 53 f8             	call   *-0x8(%rbx)
  8003bd:	4c 39 e3             	cmp    %r12,%rbx
  8003c0:	72 ef                	jb     8003b1 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8003c2:	48 b8 30 14 80 00 00 	movabs $0x801430,%rax
  8003c9:	00 00 00 
  8003cc:	ff d0                	call   *%rax
  8003ce:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003d3:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8003d7:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8003db:	48 c1 e0 04          	shl    $0x4,%rax
  8003df:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8003e6:	00 00 00 
  8003e9:	48 01 d0             	add    %rdx,%rax
  8003ec:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8003f3:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8003f6:	45 85 ed             	test   %r13d,%r13d
  8003f9:	7e 0d                	jle    800408 <libmain+0x8b>
  8003fb:	49 8b 06             	mov    (%r14),%rax
  8003fe:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800405:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800408:	4c 89 f6             	mov    %r14,%rsi
  80040b:	44 89 ef             	mov    %r13d,%edi
  80040e:	48 b8 5b 02 80 00 00 	movabs $0x80025b,%rax
  800415:	00 00 00 
  800418:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80041a:	48 b8 2f 04 80 00 00 	movabs $0x80042f,%rax
  800421:	00 00 00 
  800424:	ff d0                	call   *%rax
#endif
}
  800426:	5b                   	pop    %rbx
  800427:	41 5c                	pop    %r12
  800429:	41 5d                	pop    %r13
  80042b:	41 5e                	pop    %r14
  80042d:	5d                   	pop    %rbp
  80042e:	c3                   	ret

000000000080042f <exit>:

#include <inc/lib.h>

void
exit(void) {
  80042f:	f3 0f 1e fa          	endbr64
  800433:	55                   	push   %rbp
  800434:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800437:	48 b8 62 1c 80 00 00 	movabs $0x801c62,%rax
  80043e:	00 00 00 
  800441:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800443:	bf 00 00 00 00       	mov    $0x0,%edi
  800448:	48 b8 c1 13 80 00 00 	movabs $0x8013c1,%rax
  80044f:	00 00 00 
  800452:	ff d0                	call   *%rax
}
  800454:	5d                   	pop    %rbp
  800455:	c3                   	ret

0000000000800456 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800456:	f3 0f 1e fa          	endbr64
  80045a:	55                   	push   %rbp
  80045b:	48 89 e5             	mov    %rsp,%rbp
  80045e:	41 56                	push   %r14
  800460:	41 55                	push   %r13
  800462:	41 54                	push   %r12
  800464:	53                   	push   %rbx
  800465:	48 83 ec 50          	sub    $0x50,%rsp
  800469:	49 89 fc             	mov    %rdi,%r12
  80046c:	41 89 f5             	mov    %esi,%r13d
  80046f:	48 89 d3             	mov    %rdx,%rbx
  800472:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800476:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80047a:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80047e:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800485:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800489:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80048d:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800491:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800495:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80049c:	00 00 00 
  80049f:	4c 8b 30             	mov    (%rax),%r14
  8004a2:	48 b8 30 14 80 00 00 	movabs $0x801430,%rax
  8004a9:	00 00 00 
  8004ac:	ff d0                	call   *%rax
  8004ae:	89 c6                	mov    %eax,%esi
  8004b0:	45 89 e8             	mov    %r13d,%r8d
  8004b3:	4c 89 e1             	mov    %r12,%rcx
  8004b6:	4c 89 f2             	mov    %r14,%rdx
  8004b9:	48 bf d0 43 80 00 00 	movabs $0x8043d0,%rdi
  8004c0:	00 00 00 
  8004c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c8:	49 bc b2 05 80 00 00 	movabs $0x8005b2,%r12
  8004cf:	00 00 00 
  8004d2:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8004d5:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8004d9:	48 89 df             	mov    %rbx,%rdi
  8004dc:	48 b8 4a 05 80 00 00 	movabs $0x80054a,%rax
  8004e3:	00 00 00 
  8004e6:	ff d0                	call   *%rax
    cprintf("\n");
  8004e8:	48 bf 34 40 80 00 00 	movabs $0x804034,%rdi
  8004ef:	00 00 00 
  8004f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f7:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8004fa:	cc                   	int3
  8004fb:	eb fd                	jmp    8004fa <_panic+0xa4>

00000000008004fd <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8004fd:	f3 0f 1e fa          	endbr64
  800501:	55                   	push   %rbp
  800502:	48 89 e5             	mov    %rsp,%rbp
  800505:	53                   	push   %rbx
  800506:	48 83 ec 08          	sub    $0x8,%rsp
  80050a:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80050d:	8b 06                	mov    (%rsi),%eax
  80050f:	8d 50 01             	lea    0x1(%rax),%edx
  800512:	89 16                	mov    %edx,(%rsi)
  800514:	48 98                	cltq
  800516:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80051b:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800521:	74 0a                	je     80052d <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800523:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800527:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80052b:	c9                   	leave
  80052c:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80052d:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800531:	be ff 00 00 00       	mov    $0xff,%esi
  800536:	48 b8 5b 13 80 00 00 	movabs $0x80135b,%rax
  80053d:	00 00 00 
  800540:	ff d0                	call   *%rax
        state->offset = 0;
  800542:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800548:	eb d9                	jmp    800523 <putch+0x26>

000000000080054a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80054a:	f3 0f 1e fa          	endbr64
  80054e:	55                   	push   %rbp
  80054f:	48 89 e5             	mov    %rsp,%rbp
  800552:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800559:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80055c:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800563:	b9 21 00 00 00       	mov    $0x21,%ecx
  800568:	b8 00 00 00 00       	mov    $0x0,%eax
  80056d:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800570:	48 89 f1             	mov    %rsi,%rcx
  800573:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80057a:	48 bf fd 04 80 00 00 	movabs $0x8004fd,%rdi
  800581:	00 00 00 
  800584:	48 b8 12 07 80 00 00 	movabs $0x800712,%rax
  80058b:	00 00 00 
  80058e:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800590:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800597:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  80059e:	48 b8 5b 13 80 00 00 	movabs $0x80135b,%rax
  8005a5:	00 00 00 
  8005a8:	ff d0                	call   *%rax

    return state.count;
}
  8005aa:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8005b0:	c9                   	leave
  8005b1:	c3                   	ret

00000000008005b2 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8005b2:	f3 0f 1e fa          	endbr64
  8005b6:	55                   	push   %rbp
  8005b7:	48 89 e5             	mov    %rsp,%rbp
  8005ba:	48 83 ec 50          	sub    $0x50,%rsp
  8005be:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8005c2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8005c6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8005ca:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8005ce:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8005d2:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8005d9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005dd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005e1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8005e5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8005e9:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8005ed:	48 b8 4a 05 80 00 00 	movabs $0x80054a,%rax
  8005f4:	00 00 00 
  8005f7:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8005f9:	c9                   	leave
  8005fa:	c3                   	ret

00000000008005fb <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8005fb:	f3 0f 1e fa          	endbr64
  8005ff:	55                   	push   %rbp
  800600:	48 89 e5             	mov    %rsp,%rbp
  800603:	41 57                	push   %r15
  800605:	41 56                	push   %r14
  800607:	41 55                	push   %r13
  800609:	41 54                	push   %r12
  80060b:	53                   	push   %rbx
  80060c:	48 83 ec 18          	sub    $0x18,%rsp
  800610:	49 89 fc             	mov    %rdi,%r12
  800613:	49 89 f5             	mov    %rsi,%r13
  800616:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80061a:	8b 45 10             	mov    0x10(%rbp),%eax
  80061d:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800620:	41 89 cf             	mov    %ecx,%r15d
  800623:	4c 39 fa             	cmp    %r15,%rdx
  800626:	73 5b                	jae    800683 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800628:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80062c:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800630:	85 db                	test   %ebx,%ebx
  800632:	7e 0e                	jle    800642 <print_num+0x47>
            putch(padc, put_arg);
  800634:	4c 89 ee             	mov    %r13,%rsi
  800637:	44 89 f7             	mov    %r14d,%edi
  80063a:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80063d:	83 eb 01             	sub    $0x1,%ebx
  800640:	75 f2                	jne    800634 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800642:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800646:	48 b9 d3 40 80 00 00 	movabs $0x8040d3,%rcx
  80064d:	00 00 00 
  800650:	48 b8 c2 40 80 00 00 	movabs $0x8040c2,%rax
  800657:	00 00 00 
  80065a:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80065e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800662:	ba 00 00 00 00       	mov    $0x0,%edx
  800667:	49 f7 f7             	div    %r15
  80066a:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80066e:	4c 89 ee             	mov    %r13,%rsi
  800671:	41 ff d4             	call   *%r12
}
  800674:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800678:	5b                   	pop    %rbx
  800679:	41 5c                	pop    %r12
  80067b:	41 5d                	pop    %r13
  80067d:	41 5e                	pop    %r14
  80067f:	41 5f                	pop    %r15
  800681:	5d                   	pop    %rbp
  800682:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800683:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800687:	ba 00 00 00 00       	mov    $0x0,%edx
  80068c:	49 f7 f7             	div    %r15
  80068f:	48 83 ec 08          	sub    $0x8,%rsp
  800693:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800697:	52                   	push   %rdx
  800698:	45 0f be c9          	movsbl %r9b,%r9d
  80069c:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8006a0:	48 89 c2             	mov    %rax,%rdx
  8006a3:	48 b8 fb 05 80 00 00 	movabs $0x8005fb,%rax
  8006aa:	00 00 00 
  8006ad:	ff d0                	call   *%rax
  8006af:	48 83 c4 10          	add    $0x10,%rsp
  8006b3:	eb 8d                	jmp    800642 <print_num+0x47>

00000000008006b5 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8006b5:	f3 0f 1e fa          	endbr64
    state->count++;
  8006b9:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8006bd:	48 8b 06             	mov    (%rsi),%rax
  8006c0:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8006c4:	73 0a                	jae    8006d0 <sprintputch+0x1b>
        *state->start++ = ch;
  8006c6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006ca:	48 89 16             	mov    %rdx,(%rsi)
  8006cd:	40 88 38             	mov    %dil,(%rax)
    }
}
  8006d0:	c3                   	ret

00000000008006d1 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8006d1:	f3 0f 1e fa          	endbr64
  8006d5:	55                   	push   %rbp
  8006d6:	48 89 e5             	mov    %rsp,%rbp
  8006d9:	48 83 ec 50          	sub    $0x50,%rsp
  8006dd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8006e1:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8006e5:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8006e9:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8006f0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006f4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006f8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8006fc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800700:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800704:	48 b8 12 07 80 00 00 	movabs $0x800712,%rax
  80070b:	00 00 00 
  80070e:	ff d0                	call   *%rax
}
  800710:	c9                   	leave
  800711:	c3                   	ret

0000000000800712 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800712:	f3 0f 1e fa          	endbr64
  800716:	55                   	push   %rbp
  800717:	48 89 e5             	mov    %rsp,%rbp
  80071a:	41 57                	push   %r15
  80071c:	41 56                	push   %r14
  80071e:	41 55                	push   %r13
  800720:	41 54                	push   %r12
  800722:	53                   	push   %rbx
  800723:	48 83 ec 38          	sub    $0x38,%rsp
  800727:	49 89 fe             	mov    %rdi,%r14
  80072a:	49 89 f5             	mov    %rsi,%r13
  80072d:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800730:	48 8b 01             	mov    (%rcx),%rax
  800733:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800737:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80073b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80073f:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800743:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800747:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80074b:	0f b6 3b             	movzbl (%rbx),%edi
  80074e:	40 80 ff 25          	cmp    $0x25,%dil
  800752:	74 18                	je     80076c <vprintfmt+0x5a>
            if (!ch) return;
  800754:	40 84 ff             	test   %dil,%dil
  800757:	0f 84 b2 06 00 00    	je     800e0f <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80075d:	40 0f b6 ff          	movzbl %dil,%edi
  800761:	4c 89 ee             	mov    %r13,%rsi
  800764:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800767:	4c 89 e3             	mov    %r12,%rbx
  80076a:	eb db                	jmp    800747 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  80076c:	be 00 00 00 00       	mov    $0x0,%esi
  800771:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  800775:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  80077a:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800780:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800787:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80078b:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800790:	41 0f b6 04 24       	movzbl (%r12),%eax
  800795:	88 45 a0             	mov    %al,-0x60(%rbp)
  800798:	83 e8 23             	sub    $0x23,%eax
  80079b:	3c 57                	cmp    $0x57,%al
  80079d:	0f 87 52 06 00 00    	ja     800df5 <vprintfmt+0x6e3>
  8007a3:	0f b6 c0             	movzbl %al,%eax
  8007a6:	48 b9 e0 44 80 00 00 	movabs $0x8044e0,%rcx
  8007ad:	00 00 00 
  8007b0:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8007b4:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8007b7:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8007bb:	eb ce                	jmp    80078b <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8007bd:	49 89 dc             	mov    %rbx,%r12
  8007c0:	be 01 00 00 00       	mov    $0x1,%esi
  8007c5:	eb c4                	jmp    80078b <vprintfmt+0x79>
            padc = ch;
  8007c7:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8007cb:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8007ce:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8007d1:	eb b8                	jmp    80078b <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8007d3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d6:	83 f8 2f             	cmp    $0x2f,%eax
  8007d9:	77 24                	ja     8007ff <vprintfmt+0xed>
  8007db:	89 c1                	mov    %eax,%ecx
  8007dd:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8007e1:	83 c0 08             	add    $0x8,%eax
  8007e4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007e7:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8007ea:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8007ed:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8007f1:	79 98                	jns    80078b <vprintfmt+0x79>
                width = precision;
  8007f3:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  8007f7:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8007fd:	eb 8c                	jmp    80078b <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8007ff:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800803:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800807:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80080b:	eb da                	jmp    8007e7 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80080d:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800812:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800816:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80081c:	3c 39                	cmp    $0x39,%al
  80081e:	77 1c                	ja     80083c <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800820:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800824:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800828:	0f b6 c0             	movzbl %al,%eax
  80082b:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800830:	0f b6 03             	movzbl (%rbx),%eax
  800833:	3c 39                	cmp    $0x39,%al
  800835:	76 e9                	jbe    800820 <vprintfmt+0x10e>
        process_precision:
  800837:	49 89 dc             	mov    %rbx,%r12
  80083a:	eb b1                	jmp    8007ed <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80083c:	49 89 dc             	mov    %rbx,%r12
  80083f:	eb ac                	jmp    8007ed <vprintfmt+0xdb>
            width = MAX(0, width);
  800841:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800844:	85 c9                	test   %ecx,%ecx
  800846:	b8 00 00 00 00       	mov    $0x0,%eax
  80084b:	0f 49 c1             	cmovns %ecx,%eax
  80084e:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800851:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800854:	e9 32 ff ff ff       	jmp    80078b <vprintfmt+0x79>
            lflag++;
  800859:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80085c:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80085f:	e9 27 ff ff ff       	jmp    80078b <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800864:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800867:	83 f8 2f             	cmp    $0x2f,%eax
  80086a:	77 19                	ja     800885 <vprintfmt+0x173>
  80086c:	89 c2                	mov    %eax,%edx
  80086e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800872:	83 c0 08             	add    $0x8,%eax
  800875:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800878:	8b 3a                	mov    (%rdx),%edi
  80087a:	4c 89 ee             	mov    %r13,%rsi
  80087d:	41 ff d6             	call   *%r14
            break;
  800880:	e9 c2 fe ff ff       	jmp    800747 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  800885:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800889:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80088d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800891:	eb e5                	jmp    800878 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800893:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800896:	83 f8 2f             	cmp    $0x2f,%eax
  800899:	77 5a                	ja     8008f5 <vprintfmt+0x1e3>
  80089b:	89 c2                	mov    %eax,%edx
  80089d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008a1:	83 c0 08             	add    $0x8,%eax
  8008a4:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8008a7:	8b 02                	mov    (%rdx),%eax
  8008a9:	89 c1                	mov    %eax,%ecx
  8008ab:	f7 d9                	neg    %ecx
  8008ad:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8008b0:	83 f9 13             	cmp    $0x13,%ecx
  8008b3:	7f 4e                	jg     800903 <vprintfmt+0x1f1>
  8008b5:	48 63 c1             	movslq %ecx,%rax
  8008b8:	48 ba a0 47 80 00 00 	movabs $0x8047a0,%rdx
  8008bf:	00 00 00 
  8008c2:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8008c6:	48 85 c0             	test   %rax,%rax
  8008c9:	74 38                	je     800903 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8008cb:	48 89 c1             	mov    %rax,%rcx
  8008ce:	48 ba ed 42 80 00 00 	movabs $0x8042ed,%rdx
  8008d5:	00 00 00 
  8008d8:	4c 89 ee             	mov    %r13,%rsi
  8008db:	4c 89 f7             	mov    %r14,%rdi
  8008de:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e3:	49 b8 d1 06 80 00 00 	movabs $0x8006d1,%r8
  8008ea:	00 00 00 
  8008ed:	41 ff d0             	call   *%r8
  8008f0:	e9 52 fe ff ff       	jmp    800747 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8008f5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008f9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008fd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800901:	eb a4                	jmp    8008a7 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800903:	48 ba eb 40 80 00 00 	movabs $0x8040eb,%rdx
  80090a:	00 00 00 
  80090d:	4c 89 ee             	mov    %r13,%rsi
  800910:	4c 89 f7             	mov    %r14,%rdi
  800913:	b8 00 00 00 00       	mov    $0x0,%eax
  800918:	49 b8 d1 06 80 00 00 	movabs $0x8006d1,%r8
  80091f:	00 00 00 
  800922:	41 ff d0             	call   *%r8
  800925:	e9 1d fe ff ff       	jmp    800747 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80092a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80092d:	83 f8 2f             	cmp    $0x2f,%eax
  800930:	77 6c                	ja     80099e <vprintfmt+0x28c>
  800932:	89 c2                	mov    %eax,%edx
  800934:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800938:	83 c0 08             	add    $0x8,%eax
  80093b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80093e:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800941:	48 85 d2             	test   %rdx,%rdx
  800944:	48 b8 e4 40 80 00 00 	movabs $0x8040e4,%rax
  80094b:	00 00 00 
  80094e:	48 0f 45 c2          	cmovne %rdx,%rax
  800952:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800956:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80095a:	7e 06                	jle    800962 <vprintfmt+0x250>
  80095c:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800960:	75 4a                	jne    8009ac <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800962:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800966:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80096a:	0f b6 00             	movzbl (%rax),%eax
  80096d:	84 c0                	test   %al,%al
  80096f:	0f 85 9a 00 00 00    	jne    800a0f <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  800975:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800978:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  80097c:	85 c0                	test   %eax,%eax
  80097e:	0f 8e c3 fd ff ff    	jle    800747 <vprintfmt+0x35>
  800984:	4c 89 ee             	mov    %r13,%rsi
  800987:	bf 20 00 00 00       	mov    $0x20,%edi
  80098c:	41 ff d6             	call   *%r14
  80098f:	41 83 ec 01          	sub    $0x1,%r12d
  800993:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800997:	75 eb                	jne    800984 <vprintfmt+0x272>
  800999:	e9 a9 fd ff ff       	jmp    800747 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80099e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009a2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009a6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009aa:	eb 92                	jmp    80093e <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8009ac:	49 63 f7             	movslq %r15d,%rsi
  8009af:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8009b3:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  8009ba:	00 00 00 
  8009bd:	ff d0                	call   *%rax
  8009bf:	48 89 c2             	mov    %rax,%rdx
  8009c2:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8009c5:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8009c7:	8d 70 ff             	lea    -0x1(%rax),%esi
  8009ca:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8009cd:	85 c0                	test   %eax,%eax
  8009cf:	7e 91                	jle    800962 <vprintfmt+0x250>
  8009d1:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  8009d6:	4c 89 ee             	mov    %r13,%rsi
  8009d9:	44 89 e7             	mov    %r12d,%edi
  8009dc:	41 ff d6             	call   *%r14
  8009df:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8009e3:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8009e6:	83 f8 ff             	cmp    $0xffffffff,%eax
  8009e9:	75 eb                	jne    8009d6 <vprintfmt+0x2c4>
  8009eb:	e9 72 ff ff ff       	jmp    800962 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8009f0:	0f b6 f8             	movzbl %al,%edi
  8009f3:	4c 89 ee             	mov    %r13,%rsi
  8009f6:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8009f9:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8009fd:	49 83 c4 01          	add    $0x1,%r12
  800a01:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800a07:	84 c0                	test   %al,%al
  800a09:	0f 84 66 ff ff ff    	je     800975 <vprintfmt+0x263>
  800a0f:	45 85 ff             	test   %r15d,%r15d
  800a12:	78 0a                	js     800a1e <vprintfmt+0x30c>
  800a14:	41 83 ef 01          	sub    $0x1,%r15d
  800a18:	0f 88 57 ff ff ff    	js     800975 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800a1e:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800a22:	74 cc                	je     8009f0 <vprintfmt+0x2de>
  800a24:	8d 50 e0             	lea    -0x20(%rax),%edx
  800a27:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a2c:	80 fa 5e             	cmp    $0x5e,%dl
  800a2f:	77 c2                	ja     8009f3 <vprintfmt+0x2e1>
  800a31:	eb bd                	jmp    8009f0 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800a33:	40 84 f6             	test   %sil,%sil
  800a36:	75 26                	jne    800a5e <vprintfmt+0x34c>
    switch (lflag) {
  800a38:	85 d2                	test   %edx,%edx
  800a3a:	74 59                	je     800a95 <vprintfmt+0x383>
  800a3c:	83 fa 01             	cmp    $0x1,%edx
  800a3f:	74 7b                	je     800abc <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800a41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a44:	83 f8 2f             	cmp    $0x2f,%eax
  800a47:	0f 87 96 00 00 00    	ja     800ae3 <vprintfmt+0x3d1>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a53:	83 c0 08             	add    $0x8,%eax
  800a56:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a59:	4c 8b 22             	mov    (%rdx),%r12
  800a5c:	eb 17                	jmp    800a75 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800a5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a61:	83 f8 2f             	cmp    $0x2f,%eax
  800a64:	77 21                	ja     800a87 <vprintfmt+0x375>
  800a66:	89 c2                	mov    %eax,%edx
  800a68:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a6c:	83 c0 08             	add    $0x8,%eax
  800a6f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a72:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800a75:	4d 85 e4             	test   %r12,%r12
  800a78:	78 7a                	js     800af4 <vprintfmt+0x3e2>
            num = i;
  800a7a:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800a7d:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800a82:	e9 50 02 00 00       	jmp    800cd7 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a87:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a8b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a8f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a93:	eb dd                	jmp    800a72 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800a95:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a98:	83 f8 2f             	cmp    $0x2f,%eax
  800a9b:	77 11                	ja     800aae <vprintfmt+0x39c>
  800a9d:	89 c2                	mov    %eax,%edx
  800a9f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aa3:	83 c0 08             	add    $0x8,%eax
  800aa6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aa9:	4c 63 22             	movslq (%rdx),%r12
  800aac:	eb c7                	jmp    800a75 <vprintfmt+0x363>
  800aae:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ab2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ab6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aba:	eb ed                	jmp    800aa9 <vprintfmt+0x397>
        return va_arg(*ap, long);
  800abc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800abf:	83 f8 2f             	cmp    $0x2f,%eax
  800ac2:	77 11                	ja     800ad5 <vprintfmt+0x3c3>
  800ac4:	89 c2                	mov    %eax,%edx
  800ac6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aca:	83 c0 08             	add    $0x8,%eax
  800acd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ad0:	4c 8b 22             	mov    (%rdx),%r12
  800ad3:	eb a0                	jmp    800a75 <vprintfmt+0x363>
  800ad5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800add:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ae1:	eb ed                	jmp    800ad0 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800ae3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800aeb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aef:	e9 65 ff ff ff       	jmp    800a59 <vprintfmt+0x347>
                putch('-', put_arg);
  800af4:	4c 89 ee             	mov    %r13,%rsi
  800af7:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800afc:	41 ff d6             	call   *%r14
                i = -i;
  800aff:	49 f7 dc             	neg    %r12
  800b02:	e9 73 ff ff ff       	jmp    800a7a <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800b07:	40 84 f6             	test   %sil,%sil
  800b0a:	75 32                	jne    800b3e <vprintfmt+0x42c>
    switch (lflag) {
  800b0c:	85 d2                	test   %edx,%edx
  800b0e:	74 5d                	je     800b6d <vprintfmt+0x45b>
  800b10:	83 fa 01             	cmp    $0x1,%edx
  800b13:	0f 84 82 00 00 00    	je     800b9b <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800b19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1c:	83 f8 2f             	cmp    $0x2f,%eax
  800b1f:	0f 87 a5 00 00 00    	ja     800bca <vprintfmt+0x4b8>
  800b25:	89 c2                	mov    %eax,%edx
  800b27:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b2b:	83 c0 08             	add    $0x8,%eax
  800b2e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b31:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b34:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800b39:	e9 99 01 00 00       	jmp    800cd7 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b3e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b41:	83 f8 2f             	cmp    $0x2f,%eax
  800b44:	77 19                	ja     800b5f <vprintfmt+0x44d>
  800b46:	89 c2                	mov    %eax,%edx
  800b48:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b4c:	83 c0 08             	add    $0x8,%eax
  800b4f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b52:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b55:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b5a:	e9 78 01 00 00       	jmp    800cd7 <vprintfmt+0x5c5>
  800b5f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b63:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b67:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b6b:	eb e5                	jmp    800b52 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800b6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b70:	83 f8 2f             	cmp    $0x2f,%eax
  800b73:	77 18                	ja     800b8d <vprintfmt+0x47b>
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b7b:	83 c0 08             	add    $0x8,%eax
  800b7e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b81:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800b83:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800b88:	e9 4a 01 00 00       	jmp    800cd7 <vprintfmt+0x5c5>
  800b8d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b91:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b95:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b99:	eb e6                	jmp    800b81 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800b9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9e:	83 f8 2f             	cmp    $0x2f,%eax
  800ba1:	77 19                	ja     800bbc <vprintfmt+0x4aa>
  800ba3:	89 c2                	mov    %eax,%edx
  800ba5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ba9:	83 c0 08             	add    $0x8,%eax
  800bac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800baf:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800bb2:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800bb7:	e9 1b 01 00 00       	jmp    800cd7 <vprintfmt+0x5c5>
  800bbc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bc0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bc4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bc8:	eb e5                	jmp    800baf <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800bca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bce:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bd2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bd6:	e9 56 ff ff ff       	jmp    800b31 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800bdb:	40 84 f6             	test   %sil,%sil
  800bde:	75 2e                	jne    800c0e <vprintfmt+0x4fc>
    switch (lflag) {
  800be0:	85 d2                	test   %edx,%edx
  800be2:	74 59                	je     800c3d <vprintfmt+0x52b>
  800be4:	83 fa 01             	cmp    $0x1,%edx
  800be7:	74 7f                	je     800c68 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800be9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bec:	83 f8 2f             	cmp    $0x2f,%eax
  800bef:	0f 87 9f 00 00 00    	ja     800c94 <vprintfmt+0x582>
  800bf5:	89 c2                	mov    %eax,%edx
  800bf7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bfb:	83 c0 08             	add    $0x8,%eax
  800bfe:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c01:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800c04:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800c09:	e9 c9 00 00 00       	jmp    800cd7 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800c0e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c11:	83 f8 2f             	cmp    $0x2f,%eax
  800c14:	77 19                	ja     800c2f <vprintfmt+0x51d>
  800c16:	89 c2                	mov    %eax,%edx
  800c18:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c1c:	83 c0 08             	add    $0x8,%eax
  800c1f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c22:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800c25:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c2a:	e9 a8 00 00 00       	jmp    800cd7 <vprintfmt+0x5c5>
  800c2f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c33:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c37:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c3b:	eb e5                	jmp    800c22 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800c3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c40:	83 f8 2f             	cmp    $0x2f,%eax
  800c43:	77 15                	ja     800c5a <vprintfmt+0x548>
  800c45:	89 c2                	mov    %eax,%edx
  800c47:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c4b:	83 c0 08             	add    $0x8,%eax
  800c4e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c51:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800c53:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800c58:	eb 7d                	jmp    800cd7 <vprintfmt+0x5c5>
  800c5a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c5e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c62:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c66:	eb e9                	jmp    800c51 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800c68:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6b:	83 f8 2f             	cmp    $0x2f,%eax
  800c6e:	77 16                	ja     800c86 <vprintfmt+0x574>
  800c70:	89 c2                	mov    %eax,%edx
  800c72:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c76:	83 c0 08             	add    $0x8,%eax
  800c79:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c7c:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800c7f:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800c84:	eb 51                	jmp    800cd7 <vprintfmt+0x5c5>
  800c86:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c8a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c8e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c92:	eb e8                	jmp    800c7c <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800c94:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c98:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c9c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ca0:	e9 5c ff ff ff       	jmp    800c01 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800ca5:	4c 89 ee             	mov    %r13,%rsi
  800ca8:	bf 30 00 00 00       	mov    $0x30,%edi
  800cad:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800cb0:	4c 89 ee             	mov    %r13,%rsi
  800cb3:	bf 78 00 00 00       	mov    $0x78,%edi
  800cb8:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800cbb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbe:	83 f8 2f             	cmp    $0x2f,%eax
  800cc1:	77 47                	ja     800d0a <vprintfmt+0x5f8>
  800cc3:	89 c2                	mov    %eax,%edx
  800cc5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cc9:	83 c0 08             	add    $0x8,%eax
  800ccc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ccf:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800cd2:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800cd7:	48 83 ec 08          	sub    $0x8,%rsp
  800cdb:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800cdf:	0f 94 c0             	sete   %al
  800ce2:	0f b6 c0             	movzbl %al,%eax
  800ce5:	50                   	push   %rax
  800ce6:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800ceb:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800cef:	4c 89 ee             	mov    %r13,%rsi
  800cf2:	4c 89 f7             	mov    %r14,%rdi
  800cf5:	48 b8 fb 05 80 00 00 	movabs $0x8005fb,%rax
  800cfc:	00 00 00 
  800cff:	ff d0                	call   *%rax
            break;
  800d01:	48 83 c4 10          	add    $0x10,%rsp
  800d05:	e9 3d fa ff ff       	jmp    800747 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800d0a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d0e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d12:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d16:	eb b7                	jmp    800ccf <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800d18:	40 84 f6             	test   %sil,%sil
  800d1b:	75 2b                	jne    800d48 <vprintfmt+0x636>
    switch (lflag) {
  800d1d:	85 d2                	test   %edx,%edx
  800d1f:	74 56                	je     800d77 <vprintfmt+0x665>
  800d21:	83 fa 01             	cmp    $0x1,%edx
  800d24:	74 7f                	je     800da5 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800d26:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d29:	83 f8 2f             	cmp    $0x2f,%eax
  800d2c:	0f 87 a2 00 00 00    	ja     800dd4 <vprintfmt+0x6c2>
  800d32:	89 c2                	mov    %eax,%edx
  800d34:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d38:	83 c0 08             	add    $0x8,%eax
  800d3b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d3e:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d41:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800d46:	eb 8f                	jmp    800cd7 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800d48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d4b:	83 f8 2f             	cmp    $0x2f,%eax
  800d4e:	77 19                	ja     800d69 <vprintfmt+0x657>
  800d50:	89 c2                	mov    %eax,%edx
  800d52:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d56:	83 c0 08             	add    $0x8,%eax
  800d59:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d5c:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d5f:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800d64:	e9 6e ff ff ff       	jmp    800cd7 <vprintfmt+0x5c5>
  800d69:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d6d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d71:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d75:	eb e5                	jmp    800d5c <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800d77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d7a:	83 f8 2f             	cmp    $0x2f,%eax
  800d7d:	77 18                	ja     800d97 <vprintfmt+0x685>
  800d7f:	89 c2                	mov    %eax,%edx
  800d81:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d85:	83 c0 08             	add    $0x8,%eax
  800d88:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d8b:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800d8d:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800d92:	e9 40 ff ff ff       	jmp    800cd7 <vprintfmt+0x5c5>
  800d97:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d9b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d9f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800da3:	eb e6                	jmp    800d8b <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800da5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da8:	83 f8 2f             	cmp    $0x2f,%eax
  800dab:	77 19                	ja     800dc6 <vprintfmt+0x6b4>
  800dad:	89 c2                	mov    %eax,%edx
  800daf:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800db3:	83 c0 08             	add    $0x8,%eax
  800db6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800db9:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800dbc:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800dc1:	e9 11 ff ff ff       	jmp    800cd7 <vprintfmt+0x5c5>
  800dc6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dca:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800dce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dd2:	eb e5                	jmp    800db9 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800dd4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dd8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ddc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800de0:	e9 59 ff ff ff       	jmp    800d3e <vprintfmt+0x62c>
            putch(ch, put_arg);
  800de5:	4c 89 ee             	mov    %r13,%rsi
  800de8:	bf 25 00 00 00       	mov    $0x25,%edi
  800ded:	41 ff d6             	call   *%r14
            break;
  800df0:	e9 52 f9 ff ff       	jmp    800747 <vprintfmt+0x35>
            putch('%', put_arg);
  800df5:	4c 89 ee             	mov    %r13,%rsi
  800df8:	bf 25 00 00 00       	mov    $0x25,%edi
  800dfd:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800e00:	48 83 eb 01          	sub    $0x1,%rbx
  800e04:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800e08:	75 f6                	jne    800e00 <vprintfmt+0x6ee>
  800e0a:	e9 38 f9 ff ff       	jmp    800747 <vprintfmt+0x35>
}
  800e0f:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800e13:	5b                   	pop    %rbx
  800e14:	41 5c                	pop    %r12
  800e16:	41 5d                	pop    %r13
  800e18:	41 5e                	pop    %r14
  800e1a:	41 5f                	pop    %r15
  800e1c:	5d                   	pop    %rbp
  800e1d:	c3                   	ret

0000000000800e1e <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800e1e:	f3 0f 1e fa          	endbr64
  800e22:	55                   	push   %rbp
  800e23:	48 89 e5             	mov    %rsp,%rbp
  800e26:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800e2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e2e:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800e33:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800e37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800e3e:	48 85 ff             	test   %rdi,%rdi
  800e41:	74 2b                	je     800e6e <vsnprintf+0x50>
  800e43:	48 85 f6             	test   %rsi,%rsi
  800e46:	74 26                	je     800e6e <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800e48:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800e4c:	48 bf b5 06 80 00 00 	movabs $0x8006b5,%rdi
  800e53:	00 00 00 
  800e56:	48 b8 12 07 80 00 00 	movabs $0x800712,%rax
  800e5d:	00 00 00 
  800e60:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800e62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e66:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800e69:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800e6c:	c9                   	leave
  800e6d:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800e6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e73:	eb f7                	jmp    800e6c <vsnprintf+0x4e>

0000000000800e75 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800e75:	f3 0f 1e fa          	endbr64
  800e79:	55                   	push   %rbp
  800e7a:	48 89 e5             	mov    %rsp,%rbp
  800e7d:	48 83 ec 50          	sub    $0x50,%rsp
  800e81:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800e85:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800e89:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800e8d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800e94:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e98:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e9c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ea0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800ea4:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ea8:	48 b8 1e 0e 80 00 00 	movabs $0x800e1e,%rax
  800eaf:	00 00 00 
  800eb2:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800eb4:	c9                   	leave
  800eb5:	c3                   	ret

0000000000800eb6 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800eb6:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800eba:	80 3f 00             	cmpb   $0x0,(%rdi)
  800ebd:	74 10                	je     800ecf <strlen+0x19>
    size_t n = 0;
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800ec4:	48 83 c0 01          	add    $0x1,%rax
  800ec8:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800ecc:	75 f6                	jne    800ec4 <strlen+0xe>
  800ece:	c3                   	ret
    size_t n = 0;
  800ecf:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800ed4:	c3                   	ret

0000000000800ed5 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800ed5:	f3 0f 1e fa          	endbr64
  800ed9:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800edc:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800ee1:	48 85 f6             	test   %rsi,%rsi
  800ee4:	74 10                	je     800ef6 <strnlen+0x21>
  800ee6:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800eea:	74 0b                	je     800ef7 <strnlen+0x22>
  800eec:	48 83 c2 01          	add    $0x1,%rdx
  800ef0:	48 39 d0             	cmp    %rdx,%rax
  800ef3:	75 f1                	jne    800ee6 <strnlen+0x11>
  800ef5:	c3                   	ret
  800ef6:	c3                   	ret
  800ef7:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800efa:	c3                   	ret

0000000000800efb <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800efb:	f3 0f 1e fa          	endbr64
  800eff:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800f02:	ba 00 00 00 00       	mov    $0x0,%edx
  800f07:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800f0b:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800f0e:	48 83 c2 01          	add    $0x1,%rdx
  800f12:	84 c9                	test   %cl,%cl
  800f14:	75 f1                	jne    800f07 <strcpy+0xc>
        ;
    return res;
}
  800f16:	c3                   	ret

0000000000800f17 <strcat>:

char *
strcat(char *dst, const char *src) {
  800f17:	f3 0f 1e fa          	endbr64
  800f1b:	55                   	push   %rbp
  800f1c:	48 89 e5             	mov    %rsp,%rbp
  800f1f:	41 54                	push   %r12
  800f21:	53                   	push   %rbx
  800f22:	48 89 fb             	mov    %rdi,%rbx
  800f25:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800f28:	48 b8 b6 0e 80 00 00 	movabs $0x800eb6,%rax
  800f2f:	00 00 00 
  800f32:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800f34:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800f38:	4c 89 e6             	mov    %r12,%rsi
  800f3b:	48 b8 fb 0e 80 00 00 	movabs $0x800efb,%rax
  800f42:	00 00 00 
  800f45:	ff d0                	call   *%rax
    return dst;
}
  800f47:	48 89 d8             	mov    %rbx,%rax
  800f4a:	5b                   	pop    %rbx
  800f4b:	41 5c                	pop    %r12
  800f4d:	5d                   	pop    %rbp
  800f4e:	c3                   	ret

0000000000800f4f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f4f:	f3 0f 1e fa          	endbr64
  800f53:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800f56:	48 85 d2             	test   %rdx,%rdx
  800f59:	74 1f                	je     800f7a <strncpy+0x2b>
  800f5b:	48 01 fa             	add    %rdi,%rdx
  800f5e:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800f61:	48 83 c1 01          	add    $0x1,%rcx
  800f65:	44 0f b6 06          	movzbl (%rsi),%r8d
  800f69:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800f6d:	41 80 f8 01          	cmp    $0x1,%r8b
  800f71:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800f75:	48 39 ca             	cmp    %rcx,%rdx
  800f78:	75 e7                	jne    800f61 <strncpy+0x12>
    }
    return ret;
}
  800f7a:	c3                   	ret

0000000000800f7b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800f7b:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800f7f:	48 89 f8             	mov    %rdi,%rax
  800f82:	48 85 d2             	test   %rdx,%rdx
  800f85:	74 24                	je     800fab <strlcpy+0x30>
        while (--size > 0 && *src)
  800f87:	48 83 ea 01          	sub    $0x1,%rdx
  800f8b:	74 1b                	je     800fa8 <strlcpy+0x2d>
  800f8d:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800f91:	0f b6 16             	movzbl (%rsi),%edx
  800f94:	84 d2                	test   %dl,%dl
  800f96:	74 10                	je     800fa8 <strlcpy+0x2d>
            *dst++ = *src++;
  800f98:	48 83 c6 01          	add    $0x1,%rsi
  800f9c:	48 83 c0 01          	add    $0x1,%rax
  800fa0:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800fa3:	48 39 c8             	cmp    %rcx,%rax
  800fa6:	75 e9                	jne    800f91 <strlcpy+0x16>
        *dst = '\0';
  800fa8:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800fab:	48 29 f8             	sub    %rdi,%rax
}
  800fae:	c3                   	ret

0000000000800faf <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800faf:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800fb3:	0f b6 07             	movzbl (%rdi),%eax
  800fb6:	84 c0                	test   %al,%al
  800fb8:	74 13                	je     800fcd <strcmp+0x1e>
  800fba:	38 06                	cmp    %al,(%rsi)
  800fbc:	75 0f                	jne    800fcd <strcmp+0x1e>
  800fbe:	48 83 c7 01          	add    $0x1,%rdi
  800fc2:	48 83 c6 01          	add    $0x1,%rsi
  800fc6:	0f b6 07             	movzbl (%rdi),%eax
  800fc9:	84 c0                	test   %al,%al
  800fcb:	75 ed                	jne    800fba <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800fcd:	0f b6 c0             	movzbl %al,%eax
  800fd0:	0f b6 16             	movzbl (%rsi),%edx
  800fd3:	29 d0                	sub    %edx,%eax
}
  800fd5:	c3                   	ret

0000000000800fd6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800fd6:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800fda:	48 85 d2             	test   %rdx,%rdx
  800fdd:	74 1f                	je     800ffe <strncmp+0x28>
  800fdf:	0f b6 07             	movzbl (%rdi),%eax
  800fe2:	84 c0                	test   %al,%al
  800fe4:	74 1e                	je     801004 <strncmp+0x2e>
  800fe6:	3a 06                	cmp    (%rsi),%al
  800fe8:	75 1a                	jne    801004 <strncmp+0x2e>
  800fea:	48 83 c7 01          	add    $0x1,%rdi
  800fee:	48 83 c6 01          	add    $0x1,%rsi
  800ff2:	48 83 ea 01          	sub    $0x1,%rdx
  800ff6:	75 e7                	jne    800fdf <strncmp+0x9>

    if (!n) return 0;
  800ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffd:	c3                   	ret
  800ffe:	b8 00 00 00 00       	mov    $0x0,%eax
  801003:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  801004:	0f b6 07             	movzbl (%rdi),%eax
  801007:	0f b6 16             	movzbl (%rsi),%edx
  80100a:	29 d0                	sub    %edx,%eax
}
  80100c:	c3                   	ret

000000000080100d <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  80100d:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  801011:	0f b6 17             	movzbl (%rdi),%edx
  801014:	84 d2                	test   %dl,%dl
  801016:	74 18                	je     801030 <strchr+0x23>
        if (*str == c) {
  801018:	0f be d2             	movsbl %dl,%edx
  80101b:	39 f2                	cmp    %esi,%edx
  80101d:	74 17                	je     801036 <strchr+0x29>
    for (; *str; str++) {
  80101f:	48 83 c7 01          	add    $0x1,%rdi
  801023:	0f b6 17             	movzbl (%rdi),%edx
  801026:	84 d2                	test   %dl,%dl
  801028:	75 ee                	jne    801018 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  80102a:	b8 00 00 00 00       	mov    $0x0,%eax
  80102f:	c3                   	ret
  801030:	b8 00 00 00 00       	mov    $0x0,%eax
  801035:	c3                   	ret
            return (char *)str;
  801036:	48 89 f8             	mov    %rdi,%rax
}
  801039:	c3                   	ret

000000000080103a <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  80103a:	f3 0f 1e fa          	endbr64
  80103e:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  801041:	0f b6 17             	movzbl (%rdi),%edx
  801044:	84 d2                	test   %dl,%dl
  801046:	74 13                	je     80105b <strfind+0x21>
  801048:	0f be d2             	movsbl %dl,%edx
  80104b:	39 f2                	cmp    %esi,%edx
  80104d:	74 0b                	je     80105a <strfind+0x20>
  80104f:	48 83 c0 01          	add    $0x1,%rax
  801053:	0f b6 10             	movzbl (%rax),%edx
  801056:	84 d2                	test   %dl,%dl
  801058:	75 ee                	jne    801048 <strfind+0xe>
        ;
    return (char *)str;
}
  80105a:	c3                   	ret
  80105b:	c3                   	ret

000000000080105c <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80105c:	f3 0f 1e fa          	endbr64
  801060:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  801063:	48 89 f8             	mov    %rdi,%rax
  801066:	48 f7 d8             	neg    %rax
  801069:	83 e0 07             	and    $0x7,%eax
  80106c:	49 89 d1             	mov    %rdx,%r9
  80106f:	49 29 c1             	sub    %rax,%r9
  801072:	78 36                	js     8010aa <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  801074:	40 0f b6 c6          	movzbl %sil,%eax
  801078:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  80107f:	01 01 01 
  801082:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  801086:	40 f6 c7 07          	test   $0x7,%dil
  80108a:	75 38                	jne    8010c4 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80108c:	4c 89 c9             	mov    %r9,%rcx
  80108f:	48 c1 f9 03          	sar    $0x3,%rcx
  801093:	74 0c                	je     8010a1 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  801095:	fc                   	cld
  801096:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  801099:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  80109d:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8010a1:	4d 85 c9             	test   %r9,%r9
  8010a4:	75 45                	jne    8010eb <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8010a6:	4c 89 c0             	mov    %r8,%rax
  8010a9:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  8010aa:	48 85 d2             	test   %rdx,%rdx
  8010ad:	74 f7                	je     8010a6 <memset+0x4a>
  8010af:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  8010b2:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  8010b5:	48 83 c0 01          	add    $0x1,%rax
  8010b9:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8010bd:	48 39 c2             	cmp    %rax,%rdx
  8010c0:	75 f3                	jne    8010b5 <memset+0x59>
  8010c2:	eb e2                	jmp    8010a6 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8010c4:	40 f6 c7 01          	test   $0x1,%dil
  8010c8:	74 06                	je     8010d0 <memset+0x74>
  8010ca:	88 07                	mov    %al,(%rdi)
  8010cc:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8010d0:	40 f6 c7 02          	test   $0x2,%dil
  8010d4:	74 07                	je     8010dd <memset+0x81>
  8010d6:	66 89 07             	mov    %ax,(%rdi)
  8010d9:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8010dd:	40 f6 c7 04          	test   $0x4,%dil
  8010e1:	74 a9                	je     80108c <memset+0x30>
  8010e3:	89 07                	mov    %eax,(%rdi)
  8010e5:	48 83 c7 04          	add    $0x4,%rdi
  8010e9:	eb a1                	jmp    80108c <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8010eb:	41 f6 c1 04          	test   $0x4,%r9b
  8010ef:	74 1b                	je     80110c <memset+0xb0>
  8010f1:	89 07                	mov    %eax,(%rdi)
  8010f3:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8010f7:	41 f6 c1 02          	test   $0x2,%r9b
  8010fb:	74 07                	je     801104 <memset+0xa8>
  8010fd:	66 89 07             	mov    %ax,(%rdi)
  801100:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  801104:	41 f6 c1 01          	test   $0x1,%r9b
  801108:	74 9c                	je     8010a6 <memset+0x4a>
  80110a:	eb 06                	jmp    801112 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80110c:	41 f6 c1 02          	test   $0x2,%r9b
  801110:	75 eb                	jne    8010fd <memset+0xa1>
        if (ni & 1) *ptr = k;
  801112:	88 07                	mov    %al,(%rdi)
  801114:	eb 90                	jmp    8010a6 <memset+0x4a>

0000000000801116 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  801116:	f3 0f 1e fa          	endbr64
  80111a:	48 89 f8             	mov    %rdi,%rax
  80111d:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801120:	48 39 fe             	cmp    %rdi,%rsi
  801123:	73 3b                	jae    801160 <memmove+0x4a>
  801125:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  801129:	48 39 d7             	cmp    %rdx,%rdi
  80112c:	73 32                	jae    801160 <memmove+0x4a>
        s += n;
        d += n;
  80112e:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801132:	48 89 d6             	mov    %rdx,%rsi
  801135:	48 09 fe             	or     %rdi,%rsi
  801138:	48 09 ce             	or     %rcx,%rsi
  80113b:	40 f6 c6 07          	test   $0x7,%sil
  80113f:	75 12                	jne    801153 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801141:	48 83 ef 08          	sub    $0x8,%rdi
  801145:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801149:	48 c1 e9 03          	shr    $0x3,%rcx
  80114d:	fd                   	std
  80114e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801151:	fc                   	cld
  801152:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  801153:	48 83 ef 01          	sub    $0x1,%rdi
  801157:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  80115b:	fd                   	std
  80115c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  80115e:	eb f1                	jmp    801151 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801160:	48 89 f2             	mov    %rsi,%rdx
  801163:	48 09 c2             	or     %rax,%rdx
  801166:	48 09 ca             	or     %rcx,%rdx
  801169:	f6 c2 07             	test   $0x7,%dl
  80116c:	75 0c                	jne    80117a <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80116e:	48 c1 e9 03          	shr    $0x3,%rcx
  801172:	48 89 c7             	mov    %rax,%rdi
  801175:	fc                   	cld
  801176:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  801179:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80117a:	48 89 c7             	mov    %rax,%rdi
  80117d:	fc                   	cld
  80117e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801180:	c3                   	ret

0000000000801181 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801181:	f3 0f 1e fa          	endbr64
  801185:	55                   	push   %rbp
  801186:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  801189:	48 b8 16 11 80 00 00 	movabs $0x801116,%rax
  801190:	00 00 00 
  801193:	ff d0                	call   *%rax
}
  801195:	5d                   	pop    %rbp
  801196:	c3                   	ret

0000000000801197 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  801197:	f3 0f 1e fa          	endbr64
  80119b:	55                   	push   %rbp
  80119c:	48 89 e5             	mov    %rsp,%rbp
  80119f:	41 57                	push   %r15
  8011a1:	41 56                	push   %r14
  8011a3:	41 55                	push   %r13
  8011a5:	41 54                	push   %r12
  8011a7:	53                   	push   %rbx
  8011a8:	48 83 ec 08          	sub    $0x8,%rsp
  8011ac:	49 89 fe             	mov    %rdi,%r14
  8011af:	49 89 f7             	mov    %rsi,%r15
  8011b2:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8011b5:	48 89 f7             	mov    %rsi,%rdi
  8011b8:	48 b8 b6 0e 80 00 00 	movabs $0x800eb6,%rax
  8011bf:	00 00 00 
  8011c2:	ff d0                	call   *%rax
  8011c4:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8011c7:	48 89 de             	mov    %rbx,%rsi
  8011ca:	4c 89 f7             	mov    %r14,%rdi
  8011cd:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  8011d4:	00 00 00 
  8011d7:	ff d0                	call   *%rax
  8011d9:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8011dc:	48 39 c3             	cmp    %rax,%rbx
  8011df:	74 36                	je     801217 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  8011e1:	48 89 d8             	mov    %rbx,%rax
  8011e4:	4c 29 e8             	sub    %r13,%rax
  8011e7:	49 39 c4             	cmp    %rax,%r12
  8011ea:	73 31                	jae    80121d <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  8011ec:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8011f1:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8011f5:	4c 89 fe             	mov    %r15,%rsi
  8011f8:	48 b8 81 11 80 00 00 	movabs $0x801181,%rax
  8011ff:	00 00 00 
  801202:	ff d0                	call   *%rax
    return dstlen + srclen;
  801204:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801208:	48 83 c4 08          	add    $0x8,%rsp
  80120c:	5b                   	pop    %rbx
  80120d:	41 5c                	pop    %r12
  80120f:	41 5d                	pop    %r13
  801211:	41 5e                	pop    %r14
  801213:	41 5f                	pop    %r15
  801215:	5d                   	pop    %rbp
  801216:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  801217:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  80121b:	eb eb                	jmp    801208 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  80121d:	48 83 eb 01          	sub    $0x1,%rbx
  801221:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801225:	48 89 da             	mov    %rbx,%rdx
  801228:	4c 89 fe             	mov    %r15,%rsi
  80122b:	48 b8 81 11 80 00 00 	movabs $0x801181,%rax
  801232:	00 00 00 
  801235:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801237:	49 01 de             	add    %rbx,%r14
  80123a:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  80123f:	eb c3                	jmp    801204 <strlcat+0x6d>

0000000000801241 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801241:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801245:	48 85 d2             	test   %rdx,%rdx
  801248:	74 2d                	je     801277 <memcmp+0x36>
  80124a:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  80124f:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801253:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  801258:	44 38 c1             	cmp    %r8b,%cl
  80125b:	75 0f                	jne    80126c <memcmp+0x2b>
    while (n-- > 0) {
  80125d:	48 83 c0 01          	add    $0x1,%rax
  801261:	48 39 c2             	cmp    %rax,%rdx
  801264:	75 e9                	jne    80124f <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801266:	b8 00 00 00 00       	mov    $0x0,%eax
  80126b:	c3                   	ret
            return (int)*s1 - (int)*s2;
  80126c:	0f b6 c1             	movzbl %cl,%eax
  80126f:	45 0f b6 c0          	movzbl %r8b,%r8d
  801273:	44 29 c0             	sub    %r8d,%eax
  801276:	c3                   	ret
    return 0;
  801277:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127c:	c3                   	ret

000000000080127d <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  80127d:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  801281:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801285:	48 39 c7             	cmp    %rax,%rdi
  801288:	73 0f                	jae    801299 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  80128a:	40 38 37             	cmp    %sil,(%rdi)
  80128d:	74 0e                	je     80129d <memfind+0x20>
    for (; src < end; src++) {
  80128f:	48 83 c7 01          	add    $0x1,%rdi
  801293:	48 39 f8             	cmp    %rdi,%rax
  801296:	75 f2                	jne    80128a <memfind+0xd>
  801298:	c3                   	ret
  801299:	48 89 f8             	mov    %rdi,%rax
  80129c:	c3                   	ret
  80129d:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8012a0:	c3                   	ret

00000000008012a1 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8012a1:	f3 0f 1e fa          	endbr64
  8012a5:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8012a8:	0f b6 37             	movzbl (%rdi),%esi
  8012ab:	40 80 fe 20          	cmp    $0x20,%sil
  8012af:	74 06                	je     8012b7 <strtol+0x16>
  8012b1:	40 80 fe 09          	cmp    $0x9,%sil
  8012b5:	75 13                	jne    8012ca <strtol+0x29>
  8012b7:	48 83 c7 01          	add    $0x1,%rdi
  8012bb:	0f b6 37             	movzbl (%rdi),%esi
  8012be:	40 80 fe 20          	cmp    $0x20,%sil
  8012c2:	74 f3                	je     8012b7 <strtol+0x16>
  8012c4:	40 80 fe 09          	cmp    $0x9,%sil
  8012c8:	74 ed                	je     8012b7 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8012ca:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8012cd:	83 e0 fd             	and    $0xfffffffd,%eax
  8012d0:	3c 01                	cmp    $0x1,%al
  8012d2:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8012d6:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  8012dc:	75 0f                	jne    8012ed <strtol+0x4c>
  8012de:	80 3f 30             	cmpb   $0x30,(%rdi)
  8012e1:	74 14                	je     8012f7 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8012e3:	85 d2                	test   %edx,%edx
  8012e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012ea:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  8012ed:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8012f2:	4c 63 ca             	movslq %edx,%r9
  8012f5:	eb 36                	jmp    80132d <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8012f7:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8012fb:	74 0f                	je     80130c <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  8012fd:	85 d2                	test   %edx,%edx
  8012ff:	75 ec                	jne    8012ed <strtol+0x4c>
        s++;
  801301:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801305:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  80130a:	eb e1                	jmp    8012ed <strtol+0x4c>
        s += 2;
  80130c:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801310:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801315:	eb d6                	jmp    8012ed <strtol+0x4c>
            dig -= '0';
  801317:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  80131a:	44 0f b6 c1          	movzbl %cl,%r8d
  80131e:	41 39 d0             	cmp    %edx,%r8d
  801321:	7d 21                	jge    801344 <strtol+0xa3>
        val = val * base + dig;
  801323:	49 0f af c1          	imul   %r9,%rax
  801327:	0f b6 c9             	movzbl %cl,%ecx
  80132a:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  80132d:	48 83 c7 01          	add    $0x1,%rdi
  801331:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801335:	80 f9 39             	cmp    $0x39,%cl
  801338:	76 dd                	jbe    801317 <strtol+0x76>
        else if (dig - 'a' < 27)
  80133a:	80 f9 7b             	cmp    $0x7b,%cl
  80133d:	77 05                	ja     801344 <strtol+0xa3>
            dig -= 'a' - 10;
  80133f:	83 e9 57             	sub    $0x57,%ecx
  801342:	eb d6                	jmp    80131a <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801344:	4d 85 d2             	test   %r10,%r10
  801347:	74 03                	je     80134c <strtol+0xab>
  801349:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80134c:	48 89 c2             	mov    %rax,%rdx
  80134f:	48 f7 da             	neg    %rdx
  801352:	40 80 fe 2d          	cmp    $0x2d,%sil
  801356:	48 0f 44 c2          	cmove  %rdx,%rax
}
  80135a:	c3                   	ret

000000000080135b <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80135b:	f3 0f 1e fa          	endbr64
  80135f:	55                   	push   %rbp
  801360:	48 89 e5             	mov    %rsp,%rbp
  801363:	53                   	push   %rbx
  801364:	48 89 fa             	mov    %rdi,%rdx
  801367:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80136a:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80136f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801374:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801379:	be 00 00 00 00       	mov    $0x0,%esi
  80137e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801384:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801386:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80138a:	c9                   	leave
  80138b:	c3                   	ret

000000000080138c <sys_cgetc>:

int
sys_cgetc(void) {
  80138c:	f3 0f 1e fa          	endbr64
  801390:	55                   	push   %rbp
  801391:	48 89 e5             	mov    %rsp,%rbp
  801394:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801395:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80139a:	ba 00 00 00 00       	mov    $0x0,%edx
  80139f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013ae:	be 00 00 00 00       	mov    $0x0,%esi
  8013b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013b9:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8013bb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013bf:	c9                   	leave
  8013c0:	c3                   	ret

00000000008013c1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8013c1:	f3 0f 1e fa          	endbr64
  8013c5:	55                   	push   %rbp
  8013c6:	48 89 e5             	mov    %rsp,%rbp
  8013c9:	53                   	push   %rbx
  8013ca:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8013ce:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013d1:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013d6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e5:	be 00 00 00 00       	mov    $0x0,%esi
  8013ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013f0:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013f2:	48 85 c0             	test   %rax,%rax
  8013f5:	7f 06                	jg     8013fd <sys_env_destroy+0x3c>
}
  8013f7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013fb:	c9                   	leave
  8013fc:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013fd:	49 89 c0             	mov    %rax,%r8
  801400:	b9 03 00 00 00       	mov    $0x3,%ecx
  801405:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  80140c:	00 00 00 
  80140f:	be 26 00 00 00       	mov    $0x26,%esi
  801414:	48 bf 51 42 80 00 00 	movabs $0x804251,%rdi
  80141b:	00 00 00 
  80141e:	b8 00 00 00 00       	mov    $0x0,%eax
  801423:	49 b9 56 04 80 00 00 	movabs $0x800456,%r9
  80142a:	00 00 00 
  80142d:	41 ff d1             	call   *%r9

0000000000801430 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801430:	f3 0f 1e fa          	endbr64
  801434:	55                   	push   %rbp
  801435:	48 89 e5             	mov    %rsp,%rbp
  801438:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801439:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80143e:	ba 00 00 00 00       	mov    $0x0,%edx
  801443:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801448:	bb 00 00 00 00       	mov    $0x0,%ebx
  80144d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801452:	be 00 00 00 00       	mov    $0x0,%esi
  801457:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80145d:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80145f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801463:	c9                   	leave
  801464:	c3                   	ret

0000000000801465 <sys_yield>:

void
sys_yield(void) {
  801465:	f3 0f 1e fa          	endbr64
  801469:	55                   	push   %rbp
  80146a:	48 89 e5             	mov    %rsp,%rbp
  80146d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80146e:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801473:	ba 00 00 00 00       	mov    $0x0,%edx
  801478:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80147d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801482:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801487:	be 00 00 00 00       	mov    $0x0,%esi
  80148c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801492:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801494:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801498:	c9                   	leave
  801499:	c3                   	ret

000000000080149a <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80149a:	f3 0f 1e fa          	endbr64
  80149e:	55                   	push   %rbp
  80149f:	48 89 e5             	mov    %rsp,%rbp
  8014a2:	53                   	push   %rbx
  8014a3:	48 89 fa             	mov    %rdi,%rdx
  8014a6:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8014a9:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014ae:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8014b5:	00 00 00 
  8014b8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014bd:	be 00 00 00 00       	mov    $0x0,%esi
  8014c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014c8:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8014ca:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014ce:	c9                   	leave
  8014cf:	c3                   	ret

00000000008014d0 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8014d0:	f3 0f 1e fa          	endbr64
  8014d4:	55                   	push   %rbp
  8014d5:	48 89 e5             	mov    %rsp,%rbp
  8014d8:	53                   	push   %rbx
  8014d9:	49 89 f8             	mov    %rdi,%r8
  8014dc:	48 89 d3             	mov    %rdx,%rbx
  8014df:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8014e2:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014e7:	4c 89 c2             	mov    %r8,%rdx
  8014ea:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014ed:	be 00 00 00 00       	mov    $0x0,%esi
  8014f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014f8:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8014fa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014fe:	c9                   	leave
  8014ff:	c3                   	ret

0000000000801500 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801500:	f3 0f 1e fa          	endbr64
  801504:	55                   	push   %rbp
  801505:	48 89 e5             	mov    %rsp,%rbp
  801508:	53                   	push   %rbx
  801509:	48 83 ec 08          	sub    $0x8,%rsp
  80150d:	89 f8                	mov    %edi,%eax
  80150f:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801512:	48 63 f9             	movslq %ecx,%rdi
  801515:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801518:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80151d:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801520:	be 00 00 00 00       	mov    $0x0,%esi
  801525:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80152b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80152d:	48 85 c0             	test   %rax,%rax
  801530:	7f 06                	jg     801538 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801532:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801536:	c9                   	leave
  801537:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801538:	49 89 c0             	mov    %rax,%r8
  80153b:	b9 04 00 00 00       	mov    $0x4,%ecx
  801540:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  801547:	00 00 00 
  80154a:	be 26 00 00 00       	mov    $0x26,%esi
  80154f:	48 bf 51 42 80 00 00 	movabs $0x804251,%rdi
  801556:	00 00 00 
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
  80155e:	49 b9 56 04 80 00 00 	movabs $0x800456,%r9
  801565:	00 00 00 
  801568:	41 ff d1             	call   *%r9

000000000080156b <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80156b:	f3 0f 1e fa          	endbr64
  80156f:	55                   	push   %rbp
  801570:	48 89 e5             	mov    %rsp,%rbp
  801573:	53                   	push   %rbx
  801574:	48 83 ec 08          	sub    $0x8,%rsp
  801578:	89 f8                	mov    %edi,%eax
  80157a:	49 89 f2             	mov    %rsi,%r10
  80157d:	48 89 cf             	mov    %rcx,%rdi
  801580:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801583:	48 63 da             	movslq %edx,%rbx
  801586:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801589:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80158e:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801591:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801594:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801596:	48 85 c0             	test   %rax,%rax
  801599:	7f 06                	jg     8015a1 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80159b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80159f:	c9                   	leave
  8015a0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015a1:	49 89 c0             	mov    %rax,%r8
  8015a4:	b9 05 00 00 00       	mov    $0x5,%ecx
  8015a9:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  8015b0:	00 00 00 
  8015b3:	be 26 00 00 00       	mov    $0x26,%esi
  8015b8:	48 bf 51 42 80 00 00 	movabs $0x804251,%rdi
  8015bf:	00 00 00 
  8015c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c7:	49 b9 56 04 80 00 00 	movabs $0x800456,%r9
  8015ce:	00 00 00 
  8015d1:	41 ff d1             	call   *%r9

00000000008015d4 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8015d4:	f3 0f 1e fa          	endbr64
  8015d8:	55                   	push   %rbp
  8015d9:	48 89 e5             	mov    %rsp,%rbp
  8015dc:	53                   	push   %rbx
  8015dd:	48 83 ec 08          	sub    $0x8,%rsp
  8015e1:	49 89 f9             	mov    %rdi,%r9
  8015e4:	89 f0                	mov    %esi,%eax
  8015e6:	48 89 d3             	mov    %rdx,%rbx
  8015e9:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8015ec:	49 63 f0             	movslq %r8d,%rsi
  8015ef:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8015f2:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015f7:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801600:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801602:	48 85 c0             	test   %rax,%rax
  801605:	7f 06                	jg     80160d <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801607:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80160b:	c9                   	leave
  80160c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80160d:	49 89 c0             	mov    %rax,%r8
  801610:	b9 06 00 00 00       	mov    $0x6,%ecx
  801615:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  80161c:	00 00 00 
  80161f:	be 26 00 00 00       	mov    $0x26,%esi
  801624:	48 bf 51 42 80 00 00 	movabs $0x804251,%rdi
  80162b:	00 00 00 
  80162e:	b8 00 00 00 00       	mov    $0x0,%eax
  801633:	49 b9 56 04 80 00 00 	movabs $0x800456,%r9
  80163a:	00 00 00 
  80163d:	41 ff d1             	call   *%r9

0000000000801640 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801640:	f3 0f 1e fa          	endbr64
  801644:	55                   	push   %rbp
  801645:	48 89 e5             	mov    %rsp,%rbp
  801648:	53                   	push   %rbx
  801649:	48 83 ec 08          	sub    $0x8,%rsp
  80164d:	48 89 f1             	mov    %rsi,%rcx
  801650:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801653:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801656:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80165b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801660:	be 00 00 00 00       	mov    $0x0,%esi
  801665:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80166b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80166d:	48 85 c0             	test   %rax,%rax
  801670:	7f 06                	jg     801678 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801672:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801676:	c9                   	leave
  801677:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801678:	49 89 c0             	mov    %rax,%r8
  80167b:	b9 07 00 00 00       	mov    $0x7,%ecx
  801680:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  801687:	00 00 00 
  80168a:	be 26 00 00 00       	mov    $0x26,%esi
  80168f:	48 bf 51 42 80 00 00 	movabs $0x804251,%rdi
  801696:	00 00 00 
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
  80169e:	49 b9 56 04 80 00 00 	movabs $0x800456,%r9
  8016a5:	00 00 00 
  8016a8:	41 ff d1             	call   *%r9

00000000008016ab <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8016ab:	f3 0f 1e fa          	endbr64
  8016af:	55                   	push   %rbp
  8016b0:	48 89 e5             	mov    %rsp,%rbp
  8016b3:	53                   	push   %rbx
  8016b4:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8016b8:	48 63 ce             	movslq %esi,%rcx
  8016bb:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016be:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016c8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016cd:	be 00 00 00 00       	mov    $0x0,%esi
  8016d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016d8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016da:	48 85 c0             	test   %rax,%rax
  8016dd:	7f 06                	jg     8016e5 <sys_env_set_status+0x3a>
}
  8016df:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016e3:	c9                   	leave
  8016e4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016e5:	49 89 c0             	mov    %rax,%r8
  8016e8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016ed:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  8016f4:	00 00 00 
  8016f7:	be 26 00 00 00       	mov    $0x26,%esi
  8016fc:	48 bf 51 42 80 00 00 	movabs $0x804251,%rdi
  801703:	00 00 00 
  801706:	b8 00 00 00 00       	mov    $0x0,%eax
  80170b:	49 b9 56 04 80 00 00 	movabs $0x800456,%r9
  801712:	00 00 00 
  801715:	41 ff d1             	call   *%r9

0000000000801718 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801718:	f3 0f 1e fa          	endbr64
  80171c:	55                   	push   %rbp
  80171d:	48 89 e5             	mov    %rsp,%rbp
  801720:	53                   	push   %rbx
  801721:	48 83 ec 08          	sub    $0x8,%rsp
  801725:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801728:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80172b:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801730:	bb 00 00 00 00       	mov    $0x0,%ebx
  801735:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80173a:	be 00 00 00 00       	mov    $0x0,%esi
  80173f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801745:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801747:	48 85 c0             	test   %rax,%rax
  80174a:	7f 06                	jg     801752 <sys_env_set_trapframe+0x3a>
}
  80174c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801750:	c9                   	leave
  801751:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801752:	49 89 c0             	mov    %rax,%r8
  801755:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80175a:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  801761:	00 00 00 
  801764:	be 26 00 00 00       	mov    $0x26,%esi
  801769:	48 bf 51 42 80 00 00 	movabs $0x804251,%rdi
  801770:	00 00 00 
  801773:	b8 00 00 00 00       	mov    $0x0,%eax
  801778:	49 b9 56 04 80 00 00 	movabs $0x800456,%r9
  80177f:	00 00 00 
  801782:	41 ff d1             	call   *%r9

0000000000801785 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801785:	f3 0f 1e fa          	endbr64
  801789:	55                   	push   %rbp
  80178a:	48 89 e5             	mov    %rsp,%rbp
  80178d:	53                   	push   %rbx
  80178e:	48 83 ec 08          	sub    $0x8,%rsp
  801792:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801795:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801798:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80179d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017a2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017a7:	be 00 00 00 00       	mov    $0x0,%esi
  8017ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017b2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8017b4:	48 85 c0             	test   %rax,%rax
  8017b7:	7f 06                	jg     8017bf <sys_env_set_pgfault_upcall+0x3a>
}
  8017b9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017bd:	c9                   	leave
  8017be:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017bf:	49 89 c0             	mov    %rax,%r8
  8017c2:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8017c7:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  8017ce:	00 00 00 
  8017d1:	be 26 00 00 00       	mov    $0x26,%esi
  8017d6:	48 bf 51 42 80 00 00 	movabs $0x804251,%rdi
  8017dd:	00 00 00 
  8017e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e5:	49 b9 56 04 80 00 00 	movabs $0x800456,%r9
  8017ec:	00 00 00 
  8017ef:	41 ff d1             	call   *%r9

00000000008017f2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8017f2:	f3 0f 1e fa          	endbr64
  8017f6:	55                   	push   %rbp
  8017f7:	48 89 e5             	mov    %rsp,%rbp
  8017fa:	53                   	push   %rbx
  8017fb:	89 f8                	mov    %edi,%eax
  8017fd:	49 89 f1             	mov    %rsi,%r9
  801800:	48 89 d3             	mov    %rdx,%rbx
  801803:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801806:	49 63 f0             	movslq %r8d,%rsi
  801809:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80180c:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801811:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801814:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80181a:	cd 30                	int    $0x30
}
  80181c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801820:	c9                   	leave
  801821:	c3                   	ret

0000000000801822 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801822:	f3 0f 1e fa          	endbr64
  801826:	55                   	push   %rbp
  801827:	48 89 e5             	mov    %rsp,%rbp
  80182a:	53                   	push   %rbx
  80182b:	48 83 ec 08          	sub    $0x8,%rsp
  80182f:	48 89 fa             	mov    %rdi,%rdx
  801832:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801835:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80183a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80183f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801844:	be 00 00 00 00       	mov    $0x0,%esi
  801849:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80184f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801851:	48 85 c0             	test   %rax,%rax
  801854:	7f 06                	jg     80185c <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801856:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80185a:	c9                   	leave
  80185b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80185c:	49 89 c0             	mov    %rax,%r8
  80185f:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801864:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  80186b:	00 00 00 
  80186e:	be 26 00 00 00       	mov    $0x26,%esi
  801873:	48 bf 51 42 80 00 00 	movabs $0x804251,%rdi
  80187a:	00 00 00 
  80187d:	b8 00 00 00 00       	mov    $0x0,%eax
  801882:	49 b9 56 04 80 00 00 	movabs $0x800456,%r9
  801889:	00 00 00 
  80188c:	41 ff d1             	call   *%r9

000000000080188f <sys_gettime>:

int
sys_gettime(void) {
  80188f:	f3 0f 1e fa          	endbr64
  801893:	55                   	push   %rbp
  801894:	48 89 e5             	mov    %rsp,%rbp
  801897:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801898:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80189d:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8018a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018ac:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8018b1:	be 00 00 00 00       	mov    $0x0,%esi
  8018b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8018bc:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8018be:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018c2:	c9                   	leave
  8018c3:	c3                   	ret

00000000008018c4 <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8018c4:	f3 0f 1e fa          	endbr64
  8018c8:	55                   	push   %rbp
  8018c9:	48 89 e5             	mov    %rsp,%rbp
  8018cc:	41 56                	push   %r14
  8018ce:	41 55                	push   %r13
  8018d0:	41 54                	push   %r12
  8018d2:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  8018d3:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8018da:	00 00 00 
  8018dd:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8018e4:	b8 09 00 00 00       	mov    $0x9,%eax
  8018e9:	cd 30                	int    $0x30
  8018eb:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  8018ee:	85 c0                	test   %eax,%eax
  8018f0:	78 7f                	js     801971 <fork+0xad>
  8018f2:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  8018f4:	0f 84 83 00 00 00    	je     80197d <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  8018fa:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  801900:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801907:	00 00 00 
  80190a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80190f:	89 c2                	mov    %eax,%edx
  801911:	be 00 00 00 00       	mov    $0x0,%esi
  801916:	bf 00 00 00 00       	mov    $0x0,%edi
  80191b:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  801922:	00 00 00 
  801925:	ff d0                	call   *%rax
  801927:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  80192a:	85 c0                	test   %eax,%eax
  80192c:	0f 88 81 00 00 00    	js     8019b3 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  801932:	4d 85 f6             	test   %r14,%r14
  801935:	74 20                	je     801957 <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801937:	48 be 87 2f 80 00 00 	movabs $0x802f87,%rsi
  80193e:	00 00 00 
  801941:	44 89 e7             	mov    %r12d,%edi
  801944:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  80194b:	00 00 00 
  80194e:	ff d0                	call   *%rax
  801950:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  801953:	85 c0                	test   %eax,%eax
  801955:	78 70                	js     8019c7 <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801957:	be 02 00 00 00       	mov    $0x2,%esi
  80195c:	89 df                	mov    %ebx,%edi
  80195e:	48 b8 ab 16 80 00 00 	movabs $0x8016ab,%rax
  801965:	00 00 00 
  801968:	ff d0                	call   *%rax
  80196a:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  80196d:	85 c0                	test   %eax,%eax
  80196f:	78 6a                	js     8019db <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  801971:	44 89 e0             	mov    %r12d,%eax
  801974:	5b                   	pop    %rbx
  801975:	41 5c                	pop    %r12
  801977:	41 5d                	pop    %r13
  801979:	41 5e                	pop    %r14
  80197b:	5d                   	pop    %rbp
  80197c:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  80197d:	48 b8 30 14 80 00 00 	movabs $0x801430,%rax
  801984:	00 00 00 
  801987:	ff d0                	call   *%rax
  801989:	25 ff 03 00 00       	and    $0x3ff,%eax
  80198e:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801992:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801996:	48 c1 e0 04          	shl    $0x4,%rax
  80199a:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8019a1:	00 00 00 
  8019a4:	48 01 d0             	add    %rdx,%rax
  8019a7:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8019ae:	00 00 00 
        return 0;
  8019b1:	eb be                	jmp    801971 <fork+0xad>
        sys_env_destroy(envid);
  8019b3:	44 89 e7             	mov    %r12d,%edi
  8019b6:	48 b8 c1 13 80 00 00 	movabs $0x8013c1,%rax
  8019bd:	00 00 00 
  8019c0:	ff d0                	call   *%rax
        return res;
  8019c2:	45 89 ec             	mov    %r13d,%r12d
  8019c5:	eb aa                	jmp    801971 <fork+0xad>
            sys_env_destroy(envid);
  8019c7:	44 89 e7             	mov    %r12d,%edi
  8019ca:	48 b8 c1 13 80 00 00 	movabs $0x8013c1,%rax
  8019d1:	00 00 00 
  8019d4:	ff d0                	call   *%rax
            return res;
  8019d6:	45 89 ec             	mov    %r13d,%r12d
  8019d9:	eb 96                	jmp    801971 <fork+0xad>
        sys_env_destroy(envid);
  8019db:	89 df                	mov    %ebx,%edi
  8019dd:	48 b8 c1 13 80 00 00 	movabs $0x8013c1,%rax
  8019e4:	00 00 00 
  8019e7:	ff d0                	call   *%rax
        return res;
  8019e9:	45 89 ec             	mov    %r13d,%r12d
  8019ec:	eb 83                	jmp    801971 <fork+0xad>

00000000008019ee <sfork>:

envid_t
sfork() {
  8019ee:	f3 0f 1e fa          	endbr64
  8019f2:	55                   	push   %rbp
  8019f3:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  8019f6:	48 ba 5f 42 80 00 00 	movabs $0x80425f,%rdx
  8019fd:	00 00 00 
  801a00:	be 37 00 00 00       	mov    $0x37,%esi
  801a05:	48 bf 7a 42 80 00 00 	movabs $0x80427a,%rdi
  801a0c:	00 00 00 
  801a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a14:	48 b9 56 04 80 00 00 	movabs $0x800456,%rcx
  801a1b:	00 00 00 
  801a1e:	ff d1                	call   *%rcx

0000000000801a20 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801a20:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a24:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a2b:	ff ff ff 
  801a2e:	48 01 f8             	add    %rdi,%rax
  801a31:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801a35:	c3                   	ret

0000000000801a36 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801a36:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a3a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a41:	ff ff ff 
  801a44:	48 01 f8             	add    %rdi,%rax
  801a47:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801a4b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801a51:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a55:	c3                   	ret

0000000000801a56 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801a56:	f3 0f 1e fa          	endbr64
  801a5a:	55                   	push   %rbp
  801a5b:	48 89 e5             	mov    %rsp,%rbp
  801a5e:	41 57                	push   %r15
  801a60:	41 56                	push   %r14
  801a62:	41 55                	push   %r13
  801a64:	41 54                	push   %r12
  801a66:	53                   	push   %rbx
  801a67:	48 83 ec 08          	sub    $0x8,%rsp
  801a6b:	49 89 ff             	mov    %rdi,%r15
  801a6e:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801a73:	49 bd b5 2b 80 00 00 	movabs $0x802bb5,%r13
  801a7a:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801a7d:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801a83:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801a86:	48 89 df             	mov    %rbx,%rdi
  801a89:	41 ff d5             	call   *%r13
  801a8c:	83 e0 04             	and    $0x4,%eax
  801a8f:	74 17                	je     801aa8 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801a91:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801a98:	4c 39 f3             	cmp    %r14,%rbx
  801a9b:	75 e6                	jne    801a83 <fd_alloc+0x2d>
  801a9d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801aa3:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801aa8:	4d 89 27             	mov    %r12,(%r15)
}
  801aab:	48 83 c4 08          	add    $0x8,%rsp
  801aaf:	5b                   	pop    %rbx
  801ab0:	41 5c                	pop    %r12
  801ab2:	41 5d                	pop    %r13
  801ab4:	41 5e                	pop    %r14
  801ab6:	41 5f                	pop    %r15
  801ab8:	5d                   	pop    %rbp
  801ab9:	c3                   	ret

0000000000801aba <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801aba:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801abe:	83 ff 1f             	cmp    $0x1f,%edi
  801ac1:	77 39                	ja     801afc <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801ac3:	55                   	push   %rbp
  801ac4:	48 89 e5             	mov    %rsp,%rbp
  801ac7:	41 54                	push   %r12
  801ac9:	53                   	push   %rbx
  801aca:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801acd:	48 63 df             	movslq %edi,%rbx
  801ad0:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801ad7:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801adb:	48 89 df             	mov    %rbx,%rdi
  801ade:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  801ae5:	00 00 00 
  801ae8:	ff d0                	call   *%rax
  801aea:	a8 04                	test   $0x4,%al
  801aec:	74 14                	je     801b02 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801aee:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801af2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af7:	5b                   	pop    %rbx
  801af8:	41 5c                	pop    %r12
  801afa:	5d                   	pop    %rbp
  801afb:	c3                   	ret
        return -E_INVAL;
  801afc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801b01:	c3                   	ret
        return -E_INVAL;
  801b02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b07:	eb ee                	jmp    801af7 <fd_lookup+0x3d>

0000000000801b09 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801b09:	f3 0f 1e fa          	endbr64
  801b0d:	55                   	push   %rbp
  801b0e:	48 89 e5             	mov    %rsp,%rbp
  801b11:	41 54                	push   %r12
  801b13:	53                   	push   %rbx
  801b14:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801b17:	48 b8 40 48 80 00 00 	movabs $0x804840,%rax
  801b1e:	00 00 00 
  801b21:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801b28:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801b2b:	39 3b                	cmp    %edi,(%rbx)
  801b2d:	74 47                	je     801b76 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801b2f:	48 83 c0 08          	add    $0x8,%rax
  801b33:	48 8b 18             	mov    (%rax),%rbx
  801b36:	48 85 db             	test   %rbx,%rbx
  801b39:	75 f0                	jne    801b2b <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801b3b:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801b42:	00 00 00 
  801b45:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b4b:	89 fa                	mov    %edi,%edx
  801b4d:	48 bf 38 44 80 00 00 	movabs $0x804438,%rdi
  801b54:	00 00 00 
  801b57:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5c:	48 b9 b2 05 80 00 00 	movabs $0x8005b2,%rcx
  801b63:	00 00 00 
  801b66:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801b68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801b6d:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801b71:	5b                   	pop    %rbx
  801b72:	41 5c                	pop    %r12
  801b74:	5d                   	pop    %rbp
  801b75:	c3                   	ret
            return 0;
  801b76:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7b:	eb f0                	jmp    801b6d <dev_lookup+0x64>

0000000000801b7d <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801b7d:	f3 0f 1e fa          	endbr64
  801b81:	55                   	push   %rbp
  801b82:	48 89 e5             	mov    %rsp,%rbp
  801b85:	41 55                	push   %r13
  801b87:	41 54                	push   %r12
  801b89:	53                   	push   %rbx
  801b8a:	48 83 ec 18          	sub    $0x18,%rsp
  801b8e:	48 89 fb             	mov    %rdi,%rbx
  801b91:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801b94:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801b9b:	ff ff ff 
  801b9e:	48 01 df             	add    %rbx,%rdi
  801ba1:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801ba5:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ba9:	48 b8 ba 1a 80 00 00 	movabs $0x801aba,%rax
  801bb0:	00 00 00 
  801bb3:	ff d0                	call   *%rax
  801bb5:	41 89 c5             	mov    %eax,%r13d
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	78 06                	js     801bc2 <fd_close+0x45>
  801bbc:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801bc0:	74 1a                	je     801bdc <fd_close+0x5f>
        return (must_exist ? res : 0);
  801bc2:	45 84 e4             	test   %r12b,%r12b
  801bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bca:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801bce:	44 89 e8             	mov    %r13d,%eax
  801bd1:	48 83 c4 18          	add    $0x18,%rsp
  801bd5:	5b                   	pop    %rbx
  801bd6:	41 5c                	pop    %r12
  801bd8:	41 5d                	pop    %r13
  801bda:	5d                   	pop    %rbp
  801bdb:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801bdc:	8b 3b                	mov    (%rbx),%edi
  801bde:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801be2:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  801be9:	00 00 00 
  801bec:	ff d0                	call   *%rax
  801bee:	41 89 c5             	mov    %eax,%r13d
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	78 1b                	js     801c10 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801bf5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bf9:	48 8b 40 20          	mov    0x20(%rax),%rax
  801bfd:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801c03:	48 85 c0             	test   %rax,%rax
  801c06:	74 08                	je     801c10 <fd_close+0x93>
  801c08:	48 89 df             	mov    %rbx,%rdi
  801c0b:	ff d0                	call   *%rax
  801c0d:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801c10:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c15:	48 89 de             	mov    %rbx,%rsi
  801c18:	bf 00 00 00 00       	mov    $0x0,%edi
  801c1d:	48 b8 40 16 80 00 00 	movabs $0x801640,%rax
  801c24:	00 00 00 
  801c27:	ff d0                	call   *%rax
    return res;
  801c29:	eb a3                	jmp    801bce <fd_close+0x51>

0000000000801c2b <close>:

int
close(int fdnum) {
  801c2b:	f3 0f 1e fa          	endbr64
  801c2f:	55                   	push   %rbp
  801c30:	48 89 e5             	mov    %rsp,%rbp
  801c33:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801c37:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801c3b:	48 b8 ba 1a 80 00 00 	movabs $0x801aba,%rax
  801c42:	00 00 00 
  801c45:	ff d0                	call   *%rax
    if (res < 0) return res;
  801c47:	85 c0                	test   %eax,%eax
  801c49:	78 15                	js     801c60 <close+0x35>

    return fd_close(fd, 1);
  801c4b:	be 01 00 00 00       	mov    $0x1,%esi
  801c50:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801c54:	48 b8 7d 1b 80 00 00 	movabs $0x801b7d,%rax
  801c5b:	00 00 00 
  801c5e:	ff d0                	call   *%rax
}
  801c60:	c9                   	leave
  801c61:	c3                   	ret

0000000000801c62 <close_all>:

void
close_all(void) {
  801c62:	f3 0f 1e fa          	endbr64
  801c66:	55                   	push   %rbp
  801c67:	48 89 e5             	mov    %rsp,%rbp
  801c6a:	41 54                	push   %r12
  801c6c:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801c6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c72:	49 bc 2b 1c 80 00 00 	movabs $0x801c2b,%r12
  801c79:	00 00 00 
  801c7c:	89 df                	mov    %ebx,%edi
  801c7e:	41 ff d4             	call   *%r12
  801c81:	83 c3 01             	add    $0x1,%ebx
  801c84:	83 fb 20             	cmp    $0x20,%ebx
  801c87:	75 f3                	jne    801c7c <close_all+0x1a>
}
  801c89:	5b                   	pop    %rbx
  801c8a:	41 5c                	pop    %r12
  801c8c:	5d                   	pop    %rbp
  801c8d:	c3                   	ret

0000000000801c8e <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801c8e:	f3 0f 1e fa          	endbr64
  801c92:	55                   	push   %rbp
  801c93:	48 89 e5             	mov    %rsp,%rbp
  801c96:	41 57                	push   %r15
  801c98:	41 56                	push   %r14
  801c9a:	41 55                	push   %r13
  801c9c:	41 54                	push   %r12
  801c9e:	53                   	push   %rbx
  801c9f:	48 83 ec 18          	sub    $0x18,%rsp
  801ca3:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801ca6:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801caa:	48 b8 ba 1a 80 00 00 	movabs $0x801aba,%rax
  801cb1:	00 00 00 
  801cb4:	ff d0                	call   *%rax
  801cb6:	89 c3                	mov    %eax,%ebx
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	0f 88 b8 00 00 00    	js     801d78 <dup+0xea>
    close(newfdnum);
  801cc0:	44 89 e7             	mov    %r12d,%edi
  801cc3:	48 b8 2b 1c 80 00 00 	movabs $0x801c2b,%rax
  801cca:	00 00 00 
  801ccd:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801ccf:	4d 63 ec             	movslq %r12d,%r13
  801cd2:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801cd9:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801cdd:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801ce1:	4c 89 ff             	mov    %r15,%rdi
  801ce4:	49 be 36 1a 80 00 00 	movabs $0x801a36,%r14
  801ceb:	00 00 00 
  801cee:	41 ff d6             	call   *%r14
  801cf1:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801cf4:	4c 89 ef             	mov    %r13,%rdi
  801cf7:	41 ff d6             	call   *%r14
  801cfa:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801cfd:	48 89 df             	mov    %rbx,%rdi
  801d00:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  801d07:	00 00 00 
  801d0a:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801d0c:	a8 04                	test   $0x4,%al
  801d0e:	74 2b                	je     801d3b <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801d10:	41 89 c1             	mov    %eax,%r9d
  801d13:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801d19:	4c 89 f1             	mov    %r14,%rcx
  801d1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d21:	48 89 de             	mov    %rbx,%rsi
  801d24:	bf 00 00 00 00       	mov    $0x0,%edi
  801d29:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  801d30:	00 00 00 
  801d33:	ff d0                	call   *%rax
  801d35:	89 c3                	mov    %eax,%ebx
  801d37:	85 c0                	test   %eax,%eax
  801d39:	78 4e                	js     801d89 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801d3b:	4c 89 ff             	mov    %r15,%rdi
  801d3e:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  801d45:	00 00 00 
  801d48:	ff d0                	call   *%rax
  801d4a:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801d4d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801d53:	4c 89 e9             	mov    %r13,%rcx
  801d56:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5b:	4c 89 fe             	mov    %r15,%rsi
  801d5e:	bf 00 00 00 00       	mov    $0x0,%edi
  801d63:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  801d6a:	00 00 00 
  801d6d:	ff d0                	call   *%rax
  801d6f:	89 c3                	mov    %eax,%ebx
  801d71:	85 c0                	test   %eax,%eax
  801d73:	78 14                	js     801d89 <dup+0xfb>

    return newfdnum;
  801d75:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801d78:	89 d8                	mov    %ebx,%eax
  801d7a:	48 83 c4 18          	add    $0x18,%rsp
  801d7e:	5b                   	pop    %rbx
  801d7f:	41 5c                	pop    %r12
  801d81:	41 5d                	pop    %r13
  801d83:	41 5e                	pop    %r14
  801d85:	41 5f                	pop    %r15
  801d87:	5d                   	pop    %rbp
  801d88:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801d89:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d8e:	4c 89 ee             	mov    %r13,%rsi
  801d91:	bf 00 00 00 00       	mov    $0x0,%edi
  801d96:	49 bc 40 16 80 00 00 	movabs $0x801640,%r12
  801d9d:	00 00 00 
  801da0:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801da3:	ba 00 10 00 00       	mov    $0x1000,%edx
  801da8:	4c 89 f6             	mov    %r14,%rsi
  801dab:	bf 00 00 00 00       	mov    $0x0,%edi
  801db0:	41 ff d4             	call   *%r12
    return res;
  801db3:	eb c3                	jmp    801d78 <dup+0xea>

0000000000801db5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801db5:	f3 0f 1e fa          	endbr64
  801db9:	55                   	push   %rbp
  801dba:	48 89 e5             	mov    %rsp,%rbp
  801dbd:	41 56                	push   %r14
  801dbf:	41 55                	push   %r13
  801dc1:	41 54                	push   %r12
  801dc3:	53                   	push   %rbx
  801dc4:	48 83 ec 10          	sub    $0x10,%rsp
  801dc8:	89 fb                	mov    %edi,%ebx
  801dca:	49 89 f4             	mov    %rsi,%r12
  801dcd:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dd0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801dd4:	48 b8 ba 1a 80 00 00 	movabs $0x801aba,%rax
  801ddb:	00 00 00 
  801dde:	ff d0                	call   *%rax
  801de0:	85 c0                	test   %eax,%eax
  801de2:	78 4c                	js     801e30 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801de4:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801de8:	41 8b 3e             	mov    (%r14),%edi
  801deb:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801def:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  801df6:	00 00 00 
  801df9:	ff d0                	call   *%rax
  801dfb:	85 c0                	test   %eax,%eax
  801dfd:	78 35                	js     801e34 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801dff:	41 8b 46 08          	mov    0x8(%r14),%eax
  801e03:	83 e0 03             	and    $0x3,%eax
  801e06:	83 f8 01             	cmp    $0x1,%eax
  801e09:	74 2d                	je     801e38 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801e0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e0f:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e13:	48 85 c0             	test   %rax,%rax
  801e16:	74 56                	je     801e6e <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801e18:	4c 89 ea             	mov    %r13,%rdx
  801e1b:	4c 89 e6             	mov    %r12,%rsi
  801e1e:	4c 89 f7             	mov    %r14,%rdi
  801e21:	ff d0                	call   *%rax
}
  801e23:	48 83 c4 10          	add    $0x10,%rsp
  801e27:	5b                   	pop    %rbx
  801e28:	41 5c                	pop    %r12
  801e2a:	41 5d                	pop    %r13
  801e2c:	41 5e                	pop    %r14
  801e2e:	5d                   	pop    %rbp
  801e2f:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e30:	48 98                	cltq
  801e32:	eb ef                	jmp    801e23 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e34:	48 98                	cltq
  801e36:	eb eb                	jmp    801e23 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801e38:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801e3f:	00 00 00 
  801e42:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e48:	89 da                	mov    %ebx,%edx
  801e4a:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  801e51:	00 00 00 
  801e54:	b8 00 00 00 00       	mov    $0x0,%eax
  801e59:	48 b9 b2 05 80 00 00 	movabs $0x8005b2,%rcx
  801e60:	00 00 00 
  801e63:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e65:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801e6c:	eb b5                	jmp    801e23 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801e6e:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801e75:	eb ac                	jmp    801e23 <read+0x6e>

0000000000801e77 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801e77:	f3 0f 1e fa          	endbr64
  801e7b:	55                   	push   %rbp
  801e7c:	48 89 e5             	mov    %rsp,%rbp
  801e7f:	41 57                	push   %r15
  801e81:	41 56                	push   %r14
  801e83:	41 55                	push   %r13
  801e85:	41 54                	push   %r12
  801e87:	53                   	push   %rbx
  801e88:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801e8c:	48 85 d2             	test   %rdx,%rdx
  801e8f:	74 54                	je     801ee5 <readn+0x6e>
  801e91:	41 89 fd             	mov    %edi,%r13d
  801e94:	49 89 f6             	mov    %rsi,%r14
  801e97:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801e9a:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801e9f:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801ea4:	49 bf b5 1d 80 00 00 	movabs $0x801db5,%r15
  801eab:	00 00 00 
  801eae:	4c 89 e2             	mov    %r12,%rdx
  801eb1:	48 29 f2             	sub    %rsi,%rdx
  801eb4:	4c 01 f6             	add    %r14,%rsi
  801eb7:	44 89 ef             	mov    %r13d,%edi
  801eba:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801ebd:	85 c0                	test   %eax,%eax
  801ebf:	78 20                	js     801ee1 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801ec1:	01 c3                	add    %eax,%ebx
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	74 08                	je     801ecf <readn+0x58>
  801ec7:	48 63 f3             	movslq %ebx,%rsi
  801eca:	4c 39 e6             	cmp    %r12,%rsi
  801ecd:	72 df                	jb     801eae <readn+0x37>
    }
    return res;
  801ecf:	48 63 c3             	movslq %ebx,%rax
}
  801ed2:	48 83 c4 08          	add    $0x8,%rsp
  801ed6:	5b                   	pop    %rbx
  801ed7:	41 5c                	pop    %r12
  801ed9:	41 5d                	pop    %r13
  801edb:	41 5e                	pop    %r14
  801edd:	41 5f                	pop    %r15
  801edf:	5d                   	pop    %rbp
  801ee0:	c3                   	ret
        if (inc < 0) return inc;
  801ee1:	48 98                	cltq
  801ee3:	eb ed                	jmp    801ed2 <readn+0x5b>
    int inc = 1, res = 0;
  801ee5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801eea:	eb e3                	jmp    801ecf <readn+0x58>

0000000000801eec <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801eec:	f3 0f 1e fa          	endbr64
  801ef0:	55                   	push   %rbp
  801ef1:	48 89 e5             	mov    %rsp,%rbp
  801ef4:	41 56                	push   %r14
  801ef6:	41 55                	push   %r13
  801ef8:	41 54                	push   %r12
  801efa:	53                   	push   %rbx
  801efb:	48 83 ec 10          	sub    $0x10,%rsp
  801eff:	89 fb                	mov    %edi,%ebx
  801f01:	49 89 f4             	mov    %rsi,%r12
  801f04:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f07:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801f0b:	48 b8 ba 1a 80 00 00 	movabs $0x801aba,%rax
  801f12:	00 00 00 
  801f15:	ff d0                	call   *%rax
  801f17:	85 c0                	test   %eax,%eax
  801f19:	78 47                	js     801f62 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f1b:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801f1f:	41 8b 3e             	mov    (%r14),%edi
  801f22:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f26:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  801f2d:	00 00 00 
  801f30:	ff d0                	call   *%rax
  801f32:	85 c0                	test   %eax,%eax
  801f34:	78 30                	js     801f66 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f36:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801f3b:	74 2d                	je     801f6a <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801f3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f41:	48 8b 40 18          	mov    0x18(%rax),%rax
  801f45:	48 85 c0             	test   %rax,%rax
  801f48:	74 56                	je     801fa0 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801f4a:	4c 89 ea             	mov    %r13,%rdx
  801f4d:	4c 89 e6             	mov    %r12,%rsi
  801f50:	4c 89 f7             	mov    %r14,%rdi
  801f53:	ff d0                	call   *%rax
}
  801f55:	48 83 c4 10          	add    $0x10,%rsp
  801f59:	5b                   	pop    %rbx
  801f5a:	41 5c                	pop    %r12
  801f5c:	41 5d                	pop    %r13
  801f5e:	41 5e                	pop    %r14
  801f60:	5d                   	pop    %rbp
  801f61:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f62:	48 98                	cltq
  801f64:	eb ef                	jmp    801f55 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f66:	48 98                	cltq
  801f68:	eb eb                	jmp    801f55 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801f6a:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801f71:	00 00 00 
  801f74:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801f7a:	89 da                	mov    %ebx,%edx
  801f7c:	48 bf a1 42 80 00 00 	movabs $0x8042a1,%rdi
  801f83:	00 00 00 
  801f86:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8b:	48 b9 b2 05 80 00 00 	movabs $0x8005b2,%rcx
  801f92:	00 00 00 
  801f95:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f97:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801f9e:	eb b5                	jmp    801f55 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801fa0:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801fa7:	eb ac                	jmp    801f55 <write+0x69>

0000000000801fa9 <seek>:

int
seek(int fdnum, off_t offset) {
  801fa9:	f3 0f 1e fa          	endbr64
  801fad:	55                   	push   %rbp
  801fae:	48 89 e5             	mov    %rsp,%rbp
  801fb1:	53                   	push   %rbx
  801fb2:	48 83 ec 18          	sub    $0x18,%rsp
  801fb6:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801fb8:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801fbc:	48 b8 ba 1a 80 00 00 	movabs $0x801aba,%rax
  801fc3:	00 00 00 
  801fc6:	ff d0                	call   *%rax
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	78 0c                	js     801fd8 <seek+0x2f>

    fd->fd_offset = offset;
  801fcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd0:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801fdc:	c9                   	leave
  801fdd:	c3                   	ret

0000000000801fde <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801fde:	f3 0f 1e fa          	endbr64
  801fe2:	55                   	push   %rbp
  801fe3:	48 89 e5             	mov    %rsp,%rbp
  801fe6:	41 55                	push   %r13
  801fe8:	41 54                	push   %r12
  801fea:	53                   	push   %rbx
  801feb:	48 83 ec 18          	sub    $0x18,%rsp
  801fef:	89 fb                	mov    %edi,%ebx
  801ff1:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ff4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ff8:	48 b8 ba 1a 80 00 00 	movabs $0x801aba,%rax
  801fff:	00 00 00 
  802002:	ff d0                	call   *%rax
  802004:	85 c0                	test   %eax,%eax
  802006:	78 38                	js     802040 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802008:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  80200c:	41 8b 7d 00          	mov    0x0(%r13),%edi
  802010:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802014:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  80201b:	00 00 00 
  80201e:	ff d0                	call   *%rax
  802020:	85 c0                	test   %eax,%eax
  802022:	78 1c                	js     802040 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802024:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  802029:	74 20                	je     80204b <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  80202b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80202f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802033:	48 85 c0             	test   %rax,%rax
  802036:	74 47                	je     80207f <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  802038:	44 89 e6             	mov    %r12d,%esi
  80203b:	4c 89 ef             	mov    %r13,%rdi
  80203e:	ff d0                	call   *%rax
}
  802040:	48 83 c4 18          	add    $0x18,%rsp
  802044:	5b                   	pop    %rbx
  802045:	41 5c                	pop    %r12
  802047:	41 5d                	pop    %r13
  802049:	5d                   	pop    %rbp
  80204a:	c3                   	ret
                thisenv->env_id, fdnum);
  80204b:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802052:	00 00 00 
  802055:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  80205b:	89 da                	mov    %ebx,%edx
  80205d:	48 bf 58 44 80 00 00 	movabs $0x804458,%rdi
  802064:	00 00 00 
  802067:	b8 00 00 00 00       	mov    $0x0,%eax
  80206c:	48 b9 b2 05 80 00 00 	movabs $0x8005b2,%rcx
  802073:	00 00 00 
  802076:	ff d1                	call   *%rcx
        return -E_INVAL;
  802078:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80207d:	eb c1                	jmp    802040 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  80207f:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802084:	eb ba                	jmp    802040 <ftruncate+0x62>

0000000000802086 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  802086:	f3 0f 1e fa          	endbr64
  80208a:	55                   	push   %rbp
  80208b:	48 89 e5             	mov    %rsp,%rbp
  80208e:	41 54                	push   %r12
  802090:	53                   	push   %rbx
  802091:	48 83 ec 10          	sub    $0x10,%rsp
  802095:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802098:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80209c:	48 b8 ba 1a 80 00 00 	movabs $0x801aba,%rax
  8020a3:	00 00 00 
  8020a6:	ff d0                	call   *%rax
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	78 4e                	js     8020fa <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8020ac:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  8020b0:	41 8b 3c 24          	mov    (%r12),%edi
  8020b4:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8020b8:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  8020bf:	00 00 00 
  8020c2:	ff d0                	call   *%rax
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	78 32                	js     8020fa <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  8020c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020cc:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  8020d1:	74 30                	je     802103 <fstat+0x7d>

    stat->st_name[0] = 0;
  8020d3:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  8020d6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  8020dd:	00 00 00 
    stat->st_isdir = 0;
  8020e0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8020e7:	00 00 00 
    stat->st_dev = dev;
  8020ea:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  8020f1:	48 89 de             	mov    %rbx,%rsi
  8020f4:	4c 89 e7             	mov    %r12,%rdi
  8020f7:	ff 50 28             	call   *0x28(%rax)
}
  8020fa:	48 83 c4 10          	add    $0x10,%rsp
  8020fe:	5b                   	pop    %rbx
  8020ff:	41 5c                	pop    %r12
  802101:	5d                   	pop    %rbp
  802102:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802103:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802108:	eb f0                	jmp    8020fa <fstat+0x74>

000000000080210a <stat>:

int
stat(const char *path, struct Stat *stat) {
  80210a:	f3 0f 1e fa          	endbr64
  80210e:	55                   	push   %rbp
  80210f:	48 89 e5             	mov    %rsp,%rbp
  802112:	41 54                	push   %r12
  802114:	53                   	push   %rbx
  802115:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802118:	be 00 00 00 00       	mov    $0x0,%esi
  80211d:	48 b8 eb 23 80 00 00 	movabs $0x8023eb,%rax
  802124:	00 00 00 
  802127:	ff d0                	call   *%rax
  802129:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  80212b:	85 c0                	test   %eax,%eax
  80212d:	78 25                	js     802154 <stat+0x4a>

    int res = fstat(fd, stat);
  80212f:	4c 89 e6             	mov    %r12,%rsi
  802132:	89 c7                	mov    %eax,%edi
  802134:	48 b8 86 20 80 00 00 	movabs $0x802086,%rax
  80213b:	00 00 00 
  80213e:	ff d0                	call   *%rax
  802140:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802143:	89 df                	mov    %ebx,%edi
  802145:	48 b8 2b 1c 80 00 00 	movabs $0x801c2b,%rax
  80214c:	00 00 00 
  80214f:	ff d0                	call   *%rax

    return res;
  802151:	44 89 e3             	mov    %r12d,%ebx
}
  802154:	89 d8                	mov    %ebx,%eax
  802156:	5b                   	pop    %rbx
  802157:	41 5c                	pop    %r12
  802159:	5d                   	pop    %rbp
  80215a:	c3                   	ret

000000000080215b <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  80215b:	f3 0f 1e fa          	endbr64
  80215f:	55                   	push   %rbp
  802160:	48 89 e5             	mov    %rsp,%rbp
  802163:	41 54                	push   %r12
  802165:	53                   	push   %rbx
  802166:	48 83 ec 10          	sub    $0x10,%rsp
  80216a:	41 89 fc             	mov    %edi,%r12d
  80216d:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802170:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802177:	00 00 00 
  80217a:	83 38 00             	cmpl   $0x0,(%rax)
  80217d:	74 6e                	je     8021ed <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  80217f:	bf 03 00 00 00       	mov    $0x3,%edi
  802184:	48 b8 68 31 80 00 00 	movabs $0x803168,%rax
  80218b:	00 00 00 
  80218e:	ff d0                	call   *%rax
  802190:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802197:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802199:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  80219f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021a4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8021ab:	00 00 00 
  8021ae:	44 89 e6             	mov    %r12d,%esi
  8021b1:	89 c7                	mov    %eax,%edi
  8021b3:	48 b8 a6 30 80 00 00 	movabs $0x8030a6,%rax
  8021ba:	00 00 00 
  8021bd:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  8021bf:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  8021c6:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  8021c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021cc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021d0:	48 89 de             	mov    %rbx,%rsi
  8021d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d8:	48 b8 0d 30 80 00 00 	movabs $0x80300d,%rax
  8021df:	00 00 00 
  8021e2:	ff d0                	call   *%rax
}
  8021e4:	48 83 c4 10          	add    $0x10,%rsp
  8021e8:	5b                   	pop    %rbx
  8021e9:	41 5c                	pop    %r12
  8021eb:	5d                   	pop    %rbp
  8021ec:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8021ed:	bf 03 00 00 00       	mov    $0x3,%edi
  8021f2:	48 b8 68 31 80 00 00 	movabs $0x803168,%rax
  8021f9:	00 00 00 
  8021fc:	ff d0                	call   *%rax
  8021fe:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802205:	00 00 
  802207:	e9 73 ff ff ff       	jmp    80217f <fsipc+0x24>

000000000080220c <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  80220c:	f3 0f 1e fa          	endbr64
  802210:	55                   	push   %rbp
  802211:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802214:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80221b:	00 00 00 
  80221e:	8b 57 0c             	mov    0xc(%rdi),%edx
  802221:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802223:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802226:	be 00 00 00 00       	mov    $0x0,%esi
  80222b:	bf 02 00 00 00       	mov    $0x2,%edi
  802230:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  802237:	00 00 00 
  80223a:	ff d0                	call   *%rax
}
  80223c:	5d                   	pop    %rbp
  80223d:	c3                   	ret

000000000080223e <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80223e:	f3 0f 1e fa          	endbr64
  802242:	55                   	push   %rbp
  802243:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802246:	8b 47 0c             	mov    0xc(%rdi),%eax
  802249:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802250:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802252:	be 00 00 00 00       	mov    $0x0,%esi
  802257:	bf 06 00 00 00       	mov    $0x6,%edi
  80225c:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  802263:	00 00 00 
  802266:	ff d0                	call   *%rax
}
  802268:	5d                   	pop    %rbp
  802269:	c3                   	ret

000000000080226a <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  80226a:	f3 0f 1e fa          	endbr64
  80226e:	55                   	push   %rbp
  80226f:	48 89 e5             	mov    %rsp,%rbp
  802272:	41 54                	push   %r12
  802274:	53                   	push   %rbx
  802275:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802278:	8b 47 0c             	mov    0xc(%rdi),%eax
  80227b:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802282:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802284:	be 00 00 00 00       	mov    $0x0,%esi
  802289:	bf 05 00 00 00       	mov    $0x5,%edi
  80228e:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  802295:	00 00 00 
  802298:	ff d0                	call   *%rax
    if (res < 0) return res;
  80229a:	85 c0                	test   %eax,%eax
  80229c:	78 3d                	js     8022db <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80229e:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  8022a5:	00 00 00 
  8022a8:	4c 89 e6             	mov    %r12,%rsi
  8022ab:	48 89 df             	mov    %rbx,%rdi
  8022ae:	48 b8 fb 0e 80 00 00 	movabs $0x800efb,%rax
  8022b5:	00 00 00 
  8022b8:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8022ba:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  8022c1:	00 
  8022c2:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8022c8:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  8022cf:	00 
  8022d0:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8022d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022db:	5b                   	pop    %rbx
  8022dc:	41 5c                	pop    %r12
  8022de:	5d                   	pop    %rbp
  8022df:	c3                   	ret

00000000008022e0 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8022e0:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  8022e4:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  8022eb:	77 41                	ja     80232e <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8022ed:	55                   	push   %rbp
  8022ee:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8022f1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8022f8:	00 00 00 
  8022fb:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8022fe:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802300:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802304:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802308:	48 b8 16 11 80 00 00 	movabs $0x801116,%rax
  80230f:	00 00 00 
  802312:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802314:	be 00 00 00 00       	mov    $0x0,%esi
  802319:	bf 04 00 00 00       	mov    $0x4,%edi
  80231e:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  802325:	00 00 00 
  802328:	ff d0                	call   *%rax
  80232a:	48 98                	cltq
}
  80232c:	5d                   	pop    %rbp
  80232d:	c3                   	ret
        return -E_INVAL;
  80232e:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802335:	c3                   	ret

0000000000802336 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802336:	f3 0f 1e fa          	endbr64
  80233a:	55                   	push   %rbp
  80233b:	48 89 e5             	mov    %rsp,%rbp
  80233e:	41 55                	push   %r13
  802340:	41 54                	push   %r12
  802342:	53                   	push   %rbx
  802343:	48 83 ec 08          	sub    $0x8,%rsp
  802347:	49 89 f4             	mov    %rsi,%r12
  80234a:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80234d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802354:	00 00 00 
  802357:	8b 57 0c             	mov    0xc(%rdi),%edx
  80235a:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  80235c:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802360:	be 00 00 00 00       	mov    $0x0,%esi
  802365:	bf 03 00 00 00       	mov    $0x3,%edi
  80236a:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  802371:	00 00 00 
  802374:	ff d0                	call   *%rax
  802376:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802379:	4d 85 ed             	test   %r13,%r13
  80237c:	78 2a                	js     8023a8 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  80237e:	4c 89 ea             	mov    %r13,%rdx
  802381:	4c 39 eb             	cmp    %r13,%rbx
  802384:	72 30                	jb     8023b6 <devfile_read+0x80>
  802386:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  80238d:	7f 27                	jg     8023b6 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  80238f:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802396:	00 00 00 
  802399:	4c 89 e7             	mov    %r12,%rdi
  80239c:	48 b8 16 11 80 00 00 	movabs $0x801116,%rax
  8023a3:	00 00 00 
  8023a6:	ff d0                	call   *%rax
}
  8023a8:	4c 89 e8             	mov    %r13,%rax
  8023ab:	48 83 c4 08          	add    $0x8,%rsp
  8023af:	5b                   	pop    %rbx
  8023b0:	41 5c                	pop    %r12
  8023b2:	41 5d                	pop    %r13
  8023b4:	5d                   	pop    %rbp
  8023b5:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8023b6:	48 b9 be 42 80 00 00 	movabs $0x8042be,%rcx
  8023bd:	00 00 00 
  8023c0:	48 ba db 42 80 00 00 	movabs $0x8042db,%rdx
  8023c7:	00 00 00 
  8023ca:	be 7b 00 00 00       	mov    $0x7b,%esi
  8023cf:	48 bf f0 42 80 00 00 	movabs $0x8042f0,%rdi
  8023d6:	00 00 00 
  8023d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023de:	49 b8 56 04 80 00 00 	movabs $0x800456,%r8
  8023e5:	00 00 00 
  8023e8:	41 ff d0             	call   *%r8

00000000008023eb <open>:
open(const char *path, int mode) {
  8023eb:	f3 0f 1e fa          	endbr64
  8023ef:	55                   	push   %rbp
  8023f0:	48 89 e5             	mov    %rsp,%rbp
  8023f3:	41 55                	push   %r13
  8023f5:	41 54                	push   %r12
  8023f7:	53                   	push   %rbx
  8023f8:	48 83 ec 18          	sub    $0x18,%rsp
  8023fc:	49 89 fc             	mov    %rdi,%r12
  8023ff:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802402:	48 b8 b6 0e 80 00 00 	movabs $0x800eb6,%rax
  802409:	00 00 00 
  80240c:	ff d0                	call   *%rax
  80240e:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802414:	0f 87 8a 00 00 00    	ja     8024a4 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80241a:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80241e:	48 b8 56 1a 80 00 00 	movabs $0x801a56,%rax
  802425:	00 00 00 
  802428:	ff d0                	call   *%rax
  80242a:	89 c3                	mov    %eax,%ebx
  80242c:	85 c0                	test   %eax,%eax
  80242e:	78 50                	js     802480 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802430:	4c 89 e6             	mov    %r12,%rsi
  802433:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  80243a:	00 00 00 
  80243d:	48 89 df             	mov    %rbx,%rdi
  802440:	48 b8 fb 0e 80 00 00 	movabs $0x800efb,%rax
  802447:	00 00 00 
  80244a:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80244c:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802453:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802457:	bf 01 00 00 00       	mov    $0x1,%edi
  80245c:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  802463:	00 00 00 
  802466:	ff d0                	call   *%rax
  802468:	89 c3                	mov    %eax,%ebx
  80246a:	85 c0                	test   %eax,%eax
  80246c:	78 1f                	js     80248d <open+0xa2>
    return fd2num(fd);
  80246e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802472:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  802479:	00 00 00 
  80247c:	ff d0                	call   *%rax
  80247e:	89 c3                	mov    %eax,%ebx
}
  802480:	89 d8                	mov    %ebx,%eax
  802482:	48 83 c4 18          	add    $0x18,%rsp
  802486:	5b                   	pop    %rbx
  802487:	41 5c                	pop    %r12
  802489:	41 5d                	pop    %r13
  80248b:	5d                   	pop    %rbp
  80248c:	c3                   	ret
        fd_close(fd, 0);
  80248d:	be 00 00 00 00       	mov    $0x0,%esi
  802492:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802496:	48 b8 7d 1b 80 00 00 	movabs $0x801b7d,%rax
  80249d:	00 00 00 
  8024a0:	ff d0                	call   *%rax
        return res;
  8024a2:	eb dc                	jmp    802480 <open+0x95>
        return -E_BAD_PATH;
  8024a4:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8024a9:	eb d5                	jmp    802480 <open+0x95>

00000000008024ab <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8024ab:	f3 0f 1e fa          	endbr64
  8024af:	55                   	push   %rbp
  8024b0:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8024b3:	be 00 00 00 00       	mov    $0x0,%esi
  8024b8:	bf 08 00 00 00       	mov    $0x8,%edi
  8024bd:	48 b8 5b 21 80 00 00 	movabs $0x80215b,%rax
  8024c4:	00 00 00 
  8024c7:	ff d0                	call   *%rax
}
  8024c9:	5d                   	pop    %rbp
  8024ca:	c3                   	ret

00000000008024cb <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8024cb:	f3 0f 1e fa          	endbr64
  8024cf:	55                   	push   %rbp
  8024d0:	48 89 e5             	mov    %rsp,%rbp
  8024d3:	41 54                	push   %r12
  8024d5:	53                   	push   %rbx
  8024d6:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8024d9:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  8024e0:	00 00 00 
  8024e3:	ff d0                	call   *%rax
  8024e5:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8024e8:	48 be fb 42 80 00 00 	movabs $0x8042fb,%rsi
  8024ef:	00 00 00 
  8024f2:	48 89 df             	mov    %rbx,%rdi
  8024f5:	48 b8 fb 0e 80 00 00 	movabs $0x800efb,%rax
  8024fc:	00 00 00 
  8024ff:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802501:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802506:	41 2b 04 24          	sub    (%r12),%eax
  80250a:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802510:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802517:	00 00 00 
    stat->st_dev = &devpipe;
  80251a:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802521:	00 00 00 
  802524:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80252b:	b8 00 00 00 00       	mov    $0x0,%eax
  802530:	5b                   	pop    %rbx
  802531:	41 5c                	pop    %r12
  802533:	5d                   	pop    %rbp
  802534:	c3                   	ret

0000000000802535 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802535:	f3 0f 1e fa          	endbr64
  802539:	55                   	push   %rbp
  80253a:	48 89 e5             	mov    %rsp,%rbp
  80253d:	41 54                	push   %r12
  80253f:	53                   	push   %rbx
  802540:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802543:	ba 00 10 00 00       	mov    $0x1000,%edx
  802548:	48 89 fe             	mov    %rdi,%rsi
  80254b:	bf 00 00 00 00       	mov    $0x0,%edi
  802550:	49 bc 40 16 80 00 00 	movabs $0x801640,%r12
  802557:	00 00 00 
  80255a:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80255d:	48 89 df             	mov    %rbx,%rdi
  802560:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  802567:	00 00 00 
  80256a:	ff d0                	call   *%rax
  80256c:	48 89 c6             	mov    %rax,%rsi
  80256f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802574:	bf 00 00 00 00       	mov    $0x0,%edi
  802579:	41 ff d4             	call   *%r12
}
  80257c:	5b                   	pop    %rbx
  80257d:	41 5c                	pop    %r12
  80257f:	5d                   	pop    %rbp
  802580:	c3                   	ret

0000000000802581 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802581:	f3 0f 1e fa          	endbr64
  802585:	55                   	push   %rbp
  802586:	48 89 e5             	mov    %rsp,%rbp
  802589:	41 57                	push   %r15
  80258b:	41 56                	push   %r14
  80258d:	41 55                	push   %r13
  80258f:	41 54                	push   %r12
  802591:	53                   	push   %rbx
  802592:	48 83 ec 18          	sub    $0x18,%rsp
  802596:	49 89 fc             	mov    %rdi,%r12
  802599:	49 89 f5             	mov    %rsi,%r13
  80259c:	49 89 d7             	mov    %rdx,%r15
  80259f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8025a3:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  8025aa:	00 00 00 
  8025ad:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8025af:	4d 85 ff             	test   %r15,%r15
  8025b2:	0f 84 af 00 00 00    	je     802667 <devpipe_write+0xe6>
  8025b8:	48 89 c3             	mov    %rax,%rbx
  8025bb:	4c 89 f8             	mov    %r15,%rax
  8025be:	4d 89 ef             	mov    %r13,%r15
  8025c1:	4c 01 e8             	add    %r13,%rax
  8025c4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025c8:	49 bd d0 14 80 00 00 	movabs $0x8014d0,%r13
  8025cf:	00 00 00 
            sys_yield();
  8025d2:	49 be 65 14 80 00 00 	movabs $0x801465,%r14
  8025d9:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8025dc:	8b 73 04             	mov    0x4(%rbx),%esi
  8025df:	48 63 ce             	movslq %esi,%rcx
  8025e2:	48 63 03             	movslq (%rbx),%rax
  8025e5:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8025eb:	48 39 c1             	cmp    %rax,%rcx
  8025ee:	72 2e                	jb     80261e <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025f0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8025f5:	48 89 da             	mov    %rbx,%rdx
  8025f8:	be 00 10 00 00       	mov    $0x1000,%esi
  8025fd:	4c 89 e7             	mov    %r12,%rdi
  802600:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802603:	85 c0                	test   %eax,%eax
  802605:	74 66                	je     80266d <devpipe_write+0xec>
            sys_yield();
  802607:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80260a:	8b 73 04             	mov    0x4(%rbx),%esi
  80260d:	48 63 ce             	movslq %esi,%rcx
  802610:	48 63 03             	movslq (%rbx),%rax
  802613:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802619:	48 39 c1             	cmp    %rax,%rcx
  80261c:	73 d2                	jae    8025f0 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80261e:	41 0f b6 3f          	movzbl (%r15),%edi
  802622:	48 89 ca             	mov    %rcx,%rdx
  802625:	48 c1 ea 03          	shr    $0x3,%rdx
  802629:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802630:	08 10 20 
  802633:	48 f7 e2             	mul    %rdx
  802636:	48 c1 ea 06          	shr    $0x6,%rdx
  80263a:	48 89 d0             	mov    %rdx,%rax
  80263d:	48 c1 e0 09          	shl    $0x9,%rax
  802641:	48 29 d0             	sub    %rdx,%rax
  802644:	48 c1 e0 03          	shl    $0x3,%rax
  802648:	48 29 c1             	sub    %rax,%rcx
  80264b:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802650:	83 c6 01             	add    $0x1,%esi
  802653:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802656:	49 83 c7 01          	add    $0x1,%r15
  80265a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80265e:	49 39 c7             	cmp    %rax,%r15
  802661:	0f 85 75 ff ff ff    	jne    8025dc <devpipe_write+0x5b>
    return n;
  802667:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80266b:	eb 05                	jmp    802672 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  80266d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802672:	48 83 c4 18          	add    $0x18,%rsp
  802676:	5b                   	pop    %rbx
  802677:	41 5c                	pop    %r12
  802679:	41 5d                	pop    %r13
  80267b:	41 5e                	pop    %r14
  80267d:	41 5f                	pop    %r15
  80267f:	5d                   	pop    %rbp
  802680:	c3                   	ret

0000000000802681 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802681:	f3 0f 1e fa          	endbr64
  802685:	55                   	push   %rbp
  802686:	48 89 e5             	mov    %rsp,%rbp
  802689:	41 57                	push   %r15
  80268b:	41 56                	push   %r14
  80268d:	41 55                	push   %r13
  80268f:	41 54                	push   %r12
  802691:	53                   	push   %rbx
  802692:	48 83 ec 18          	sub    $0x18,%rsp
  802696:	49 89 fc             	mov    %rdi,%r12
  802699:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80269d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8026a1:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  8026a8:	00 00 00 
  8026ab:	ff d0                	call   *%rax
  8026ad:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8026b0:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8026b6:	49 bd d0 14 80 00 00 	movabs $0x8014d0,%r13
  8026bd:	00 00 00 
            sys_yield();
  8026c0:	49 be 65 14 80 00 00 	movabs $0x801465,%r14
  8026c7:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8026ca:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8026cf:	74 7d                	je     80274e <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8026d1:	8b 03                	mov    (%rbx),%eax
  8026d3:	3b 43 04             	cmp    0x4(%rbx),%eax
  8026d6:	75 26                	jne    8026fe <devpipe_read+0x7d>
            if (i > 0) return i;
  8026d8:	4d 85 ff             	test   %r15,%r15
  8026db:	75 77                	jne    802754 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8026dd:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8026e2:	48 89 da             	mov    %rbx,%rdx
  8026e5:	be 00 10 00 00       	mov    $0x1000,%esi
  8026ea:	4c 89 e7             	mov    %r12,%rdi
  8026ed:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8026f0:	85 c0                	test   %eax,%eax
  8026f2:	74 72                	je     802766 <devpipe_read+0xe5>
            sys_yield();
  8026f4:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8026f7:	8b 03                	mov    (%rbx),%eax
  8026f9:	3b 43 04             	cmp    0x4(%rbx),%eax
  8026fc:	74 df                	je     8026dd <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026fe:	48 63 c8             	movslq %eax,%rcx
  802701:	48 89 ca             	mov    %rcx,%rdx
  802704:	48 c1 ea 03          	shr    $0x3,%rdx
  802708:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  80270f:	08 10 20 
  802712:	48 89 d0             	mov    %rdx,%rax
  802715:	48 f7 e6             	mul    %rsi
  802718:	48 c1 ea 06          	shr    $0x6,%rdx
  80271c:	48 89 d0             	mov    %rdx,%rax
  80271f:	48 c1 e0 09          	shl    $0x9,%rax
  802723:	48 29 d0             	sub    %rdx,%rax
  802726:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80272d:	00 
  80272e:	48 89 c8             	mov    %rcx,%rax
  802731:	48 29 d0             	sub    %rdx,%rax
  802734:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802739:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80273d:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802741:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802744:	49 83 c7 01          	add    $0x1,%r15
  802748:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80274c:	75 83                	jne    8026d1 <devpipe_read+0x50>
    return n;
  80274e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802752:	eb 03                	jmp    802757 <devpipe_read+0xd6>
            if (i > 0) return i;
  802754:	4c 89 f8             	mov    %r15,%rax
}
  802757:	48 83 c4 18          	add    $0x18,%rsp
  80275b:	5b                   	pop    %rbx
  80275c:	41 5c                	pop    %r12
  80275e:	41 5d                	pop    %r13
  802760:	41 5e                	pop    %r14
  802762:	41 5f                	pop    %r15
  802764:	5d                   	pop    %rbp
  802765:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802766:	b8 00 00 00 00       	mov    $0x0,%eax
  80276b:	eb ea                	jmp    802757 <devpipe_read+0xd6>

000000000080276d <pipe>:
pipe(int pfd[2]) {
  80276d:	f3 0f 1e fa          	endbr64
  802771:	55                   	push   %rbp
  802772:	48 89 e5             	mov    %rsp,%rbp
  802775:	41 55                	push   %r13
  802777:	41 54                	push   %r12
  802779:	53                   	push   %rbx
  80277a:	48 83 ec 18          	sub    $0x18,%rsp
  80277e:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802781:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802785:	48 b8 56 1a 80 00 00 	movabs $0x801a56,%rax
  80278c:	00 00 00 
  80278f:	ff d0                	call   *%rax
  802791:	89 c3                	mov    %eax,%ebx
  802793:	85 c0                	test   %eax,%eax
  802795:	0f 88 a0 01 00 00    	js     80293b <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80279b:	b9 46 00 00 00       	mov    $0x46,%ecx
  8027a0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027a5:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8027a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ae:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  8027b5:	00 00 00 
  8027b8:	ff d0                	call   *%rax
  8027ba:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8027bc:	85 c0                	test   %eax,%eax
  8027be:	0f 88 77 01 00 00    	js     80293b <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8027c4:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8027c8:	48 b8 56 1a 80 00 00 	movabs $0x801a56,%rax
  8027cf:	00 00 00 
  8027d2:	ff d0                	call   *%rax
  8027d4:	89 c3                	mov    %eax,%ebx
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	0f 88 43 01 00 00    	js     802921 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8027de:	b9 46 00 00 00       	mov    $0x46,%ecx
  8027e3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027e8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f1:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  8027f8:	00 00 00 
  8027fb:	ff d0                	call   *%rax
  8027fd:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8027ff:	85 c0                	test   %eax,%eax
  802801:	0f 88 1a 01 00 00    	js     802921 <pipe+0x1b4>
    va = fd2data(fd0);
  802807:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80280b:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  802812:	00 00 00 
  802815:	ff d0                	call   *%rax
  802817:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80281a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80281f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802824:	48 89 c6             	mov    %rax,%rsi
  802827:	bf 00 00 00 00       	mov    $0x0,%edi
  80282c:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  802833:	00 00 00 
  802836:	ff d0                	call   *%rax
  802838:	89 c3                	mov    %eax,%ebx
  80283a:	85 c0                	test   %eax,%eax
  80283c:	0f 88 c5 00 00 00    	js     802907 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802842:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802846:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  80284d:	00 00 00 
  802850:	ff d0                	call   *%rax
  802852:	48 89 c1             	mov    %rax,%rcx
  802855:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80285b:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802861:	ba 00 00 00 00       	mov    $0x0,%edx
  802866:	4c 89 ee             	mov    %r13,%rsi
  802869:	bf 00 00 00 00       	mov    $0x0,%edi
  80286e:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  802875:	00 00 00 
  802878:	ff d0                	call   *%rax
  80287a:	89 c3                	mov    %eax,%ebx
  80287c:	85 c0                	test   %eax,%eax
  80287e:	78 6e                	js     8028ee <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802880:	be 00 10 00 00       	mov    $0x1000,%esi
  802885:	4c 89 ef             	mov    %r13,%rdi
  802888:	48 b8 9a 14 80 00 00 	movabs $0x80149a,%rax
  80288f:	00 00 00 
  802892:	ff d0                	call   *%rax
  802894:	83 f8 02             	cmp    $0x2,%eax
  802897:	0f 85 ab 00 00 00    	jne    802948 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  80289d:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  8028a4:	00 00 
  8028a6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028aa:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8028ac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028b0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8028b7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8028bb:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8028bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028c1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8028c8:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8028cc:	48 bb 20 1a 80 00 00 	movabs $0x801a20,%rbx
  8028d3:	00 00 00 
  8028d6:	ff d3                	call   *%rbx
  8028d8:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8028dc:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8028e0:	ff d3                	call   *%rbx
  8028e2:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8028e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028ec:	eb 4d                	jmp    80293b <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8028ee:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028f3:	4c 89 ee             	mov    %r13,%rsi
  8028f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8028fb:	48 b8 40 16 80 00 00 	movabs $0x801640,%rax
  802902:	00 00 00 
  802905:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802907:	ba 00 10 00 00       	mov    $0x1000,%edx
  80290c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802910:	bf 00 00 00 00       	mov    $0x0,%edi
  802915:	48 b8 40 16 80 00 00 	movabs $0x801640,%rax
  80291c:	00 00 00 
  80291f:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802921:	ba 00 10 00 00       	mov    $0x1000,%edx
  802926:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80292a:	bf 00 00 00 00       	mov    $0x0,%edi
  80292f:	48 b8 40 16 80 00 00 	movabs $0x801640,%rax
  802936:	00 00 00 
  802939:	ff d0                	call   *%rax
}
  80293b:	89 d8                	mov    %ebx,%eax
  80293d:	48 83 c4 18          	add    $0x18,%rsp
  802941:	5b                   	pop    %rbx
  802942:	41 5c                	pop    %r12
  802944:	41 5d                	pop    %r13
  802946:	5d                   	pop    %rbp
  802947:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802948:	48 b9 80 44 80 00 00 	movabs $0x804480,%rcx
  80294f:	00 00 00 
  802952:	48 ba db 42 80 00 00 	movabs $0x8042db,%rdx
  802959:	00 00 00 
  80295c:	be 2e 00 00 00       	mov    $0x2e,%esi
  802961:	48 bf 02 43 80 00 00 	movabs $0x804302,%rdi
  802968:	00 00 00 
  80296b:	b8 00 00 00 00       	mov    $0x0,%eax
  802970:	49 b8 56 04 80 00 00 	movabs $0x800456,%r8
  802977:	00 00 00 
  80297a:	41 ff d0             	call   *%r8

000000000080297d <pipeisclosed>:
pipeisclosed(int fdnum) {
  80297d:	f3 0f 1e fa          	endbr64
  802981:	55                   	push   %rbp
  802982:	48 89 e5             	mov    %rsp,%rbp
  802985:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802989:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80298d:	48 b8 ba 1a 80 00 00 	movabs $0x801aba,%rax
  802994:	00 00 00 
  802997:	ff d0                	call   *%rax
    if (res < 0) return res;
  802999:	85 c0                	test   %eax,%eax
  80299b:	78 35                	js     8029d2 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80299d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8029a1:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  8029a8:	00 00 00 
  8029ab:	ff d0                	call   *%rax
  8029ad:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8029b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8029b5:	be 00 10 00 00       	mov    $0x1000,%esi
  8029ba:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8029be:	48 b8 d0 14 80 00 00 	movabs $0x8014d0,%rax
  8029c5:	00 00 00 
  8029c8:	ff d0                	call   *%rax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	0f 94 c0             	sete   %al
  8029cf:	0f b6 c0             	movzbl %al,%eax
}
  8029d2:	c9                   	leave
  8029d3:	c3                   	ret

00000000008029d4 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8029d4:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8029d8:	48 89 f8             	mov    %rdi,%rax
  8029db:	48 c1 e8 27          	shr    $0x27,%rax
  8029df:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8029e6:	7f 00 00 
  8029e9:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8029ed:	f6 c2 01             	test   $0x1,%dl
  8029f0:	74 6d                	je     802a5f <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8029f2:	48 89 f8             	mov    %rdi,%rax
  8029f5:	48 c1 e8 1e          	shr    $0x1e,%rax
  8029f9:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802a00:	7f 00 00 
  802a03:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a07:	f6 c2 01             	test   $0x1,%dl
  802a0a:	74 62                	je     802a6e <get_uvpt_entry+0x9a>
  802a0c:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802a13:	7f 00 00 
  802a16:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a1a:	f6 c2 80             	test   $0x80,%dl
  802a1d:	75 4f                	jne    802a6e <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802a1f:	48 89 f8             	mov    %rdi,%rax
  802a22:	48 c1 e8 15          	shr    $0x15,%rax
  802a26:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802a2d:	7f 00 00 
  802a30:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a34:	f6 c2 01             	test   $0x1,%dl
  802a37:	74 44                	je     802a7d <get_uvpt_entry+0xa9>
  802a39:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802a40:	7f 00 00 
  802a43:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a47:	f6 c2 80             	test   $0x80,%dl
  802a4a:	75 31                	jne    802a7d <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802a4c:	48 c1 ef 0c          	shr    $0xc,%rdi
  802a50:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a57:	7f 00 00 
  802a5a:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802a5e:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802a5f:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802a66:	7f 00 00 
  802a69:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802a6d:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802a6e:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802a75:	7f 00 00 
  802a78:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802a7c:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802a7d:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802a84:	7f 00 00 
  802a87:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802a8b:	c3                   	ret

0000000000802a8c <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802a8c:	f3 0f 1e fa          	endbr64
  802a90:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802a93:	48 89 f9             	mov    %rdi,%rcx
  802a96:	48 c1 e9 27          	shr    $0x27,%rcx
  802a9a:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802aa1:	7f 00 00 
  802aa4:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802aa8:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802aaf:	f6 c1 01             	test   $0x1,%cl
  802ab2:	0f 84 b2 00 00 00    	je     802b6a <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802ab8:	48 89 f9             	mov    %rdi,%rcx
  802abb:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802abf:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802ac6:	7f 00 00 
  802ac9:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802acd:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802ad4:	40 f6 c6 01          	test   $0x1,%sil
  802ad8:	0f 84 8c 00 00 00    	je     802b6a <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802ade:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802ae5:	7f 00 00 
  802ae8:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802aec:	a8 80                	test   $0x80,%al
  802aee:	75 7b                	jne    802b6b <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802af0:	48 89 f9             	mov    %rdi,%rcx
  802af3:	48 c1 e9 15          	shr    $0x15,%rcx
  802af7:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802afe:	7f 00 00 
  802b01:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802b05:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802b0c:	40 f6 c6 01          	test   $0x1,%sil
  802b10:	74 58                	je     802b6a <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802b12:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802b19:	7f 00 00 
  802b1c:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b20:	a8 80                	test   $0x80,%al
  802b22:	75 6c                	jne    802b90 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802b24:	48 89 f9             	mov    %rdi,%rcx
  802b27:	48 c1 e9 0c          	shr    $0xc,%rcx
  802b2b:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802b32:	7f 00 00 
  802b35:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802b39:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802b40:	40 f6 c6 01          	test   $0x1,%sil
  802b44:	74 24                	je     802b6a <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802b46:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802b4d:	7f 00 00 
  802b50:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b54:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802b5b:	ff ff 7f 
  802b5e:	48 21 c8             	and    %rcx,%rax
  802b61:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802b67:	48 09 d0             	or     %rdx,%rax
}
  802b6a:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802b6b:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802b72:	7f 00 00 
  802b75:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b79:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802b80:	ff ff 7f 
  802b83:	48 21 c8             	and    %rcx,%rax
  802b86:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802b8c:	48 01 d0             	add    %rdx,%rax
  802b8f:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802b90:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802b97:	7f 00 00 
  802b9a:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b9e:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802ba5:	ff ff 7f 
  802ba8:	48 21 c8             	and    %rcx,%rax
  802bab:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802bb1:	48 01 d0             	add    %rdx,%rax
  802bb4:	c3                   	ret

0000000000802bb5 <get_prot>:

int
get_prot(void *va) {
  802bb5:	f3 0f 1e fa          	endbr64
  802bb9:	55                   	push   %rbp
  802bba:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802bbd:	48 b8 d4 29 80 00 00 	movabs $0x8029d4,%rax
  802bc4:	00 00 00 
  802bc7:	ff d0                	call   *%rax
  802bc9:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802bcc:	83 e0 01             	and    $0x1,%eax
  802bcf:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802bd2:	89 d1                	mov    %edx,%ecx
  802bd4:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802bda:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802bdc:	89 c1                	mov    %eax,%ecx
  802bde:	83 c9 02             	or     $0x2,%ecx
  802be1:	f6 c2 02             	test   $0x2,%dl
  802be4:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802be7:	89 c1                	mov    %eax,%ecx
  802be9:	83 c9 01             	or     $0x1,%ecx
  802bec:	48 85 d2             	test   %rdx,%rdx
  802bef:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802bf2:	89 c1                	mov    %eax,%ecx
  802bf4:	83 c9 40             	or     $0x40,%ecx
  802bf7:	f6 c6 04             	test   $0x4,%dh
  802bfa:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802bfd:	5d                   	pop    %rbp
  802bfe:	c3                   	ret

0000000000802bff <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802bff:	f3 0f 1e fa          	endbr64
  802c03:	55                   	push   %rbp
  802c04:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802c07:	48 b8 d4 29 80 00 00 	movabs $0x8029d4,%rax
  802c0e:	00 00 00 
  802c11:	ff d0                	call   *%rax
    return pte & PTE_D;
  802c13:	48 c1 e8 06          	shr    $0x6,%rax
  802c17:	83 e0 01             	and    $0x1,%eax
}
  802c1a:	5d                   	pop    %rbp
  802c1b:	c3                   	ret

0000000000802c1c <is_page_present>:

bool
is_page_present(void *va) {
  802c1c:	f3 0f 1e fa          	endbr64
  802c20:	55                   	push   %rbp
  802c21:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802c24:	48 b8 d4 29 80 00 00 	movabs $0x8029d4,%rax
  802c2b:	00 00 00 
  802c2e:	ff d0                	call   *%rax
  802c30:	83 e0 01             	and    $0x1,%eax
}
  802c33:	5d                   	pop    %rbp
  802c34:	c3                   	ret

0000000000802c35 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802c35:	f3 0f 1e fa          	endbr64
  802c39:	55                   	push   %rbp
  802c3a:	48 89 e5             	mov    %rsp,%rbp
  802c3d:	41 57                	push   %r15
  802c3f:	41 56                	push   %r14
  802c41:	41 55                	push   %r13
  802c43:	41 54                	push   %r12
  802c45:	53                   	push   %rbx
  802c46:	48 83 ec 18          	sub    $0x18,%rsp
  802c4a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802c4e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802c52:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802c57:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802c5e:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c61:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802c68:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802c6b:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802c72:	00 00 00 
  802c75:	eb 73                	jmp    802cea <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802c77:	48 89 d8             	mov    %rbx,%rax
  802c7a:	48 c1 e8 15          	shr    $0x15,%rax
  802c7e:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802c85:	7f 00 00 
  802c88:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802c8c:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802c92:	f6 c2 01             	test   $0x1,%dl
  802c95:	74 4b                	je     802ce2 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802c97:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802c9b:	f6 c2 80             	test   $0x80,%dl
  802c9e:	74 11                	je     802cb1 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802ca0:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802ca4:	f6 c4 04             	test   $0x4,%ah
  802ca7:	74 39                	je     802ce2 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802ca9:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802caf:	eb 20                	jmp    802cd1 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802cb1:	48 89 da             	mov    %rbx,%rdx
  802cb4:	48 c1 ea 0c          	shr    $0xc,%rdx
  802cb8:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802cbf:	7f 00 00 
  802cc2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802cc6:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802ccc:	f6 c4 04             	test   $0x4,%ah
  802ccf:	74 11                	je     802ce2 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802cd1:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802cd5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802cd9:	48 89 df             	mov    %rbx,%rdi
  802cdc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ce0:	ff d0                	call   *%rax
    next:
        va += size;
  802ce2:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802ce5:	49 39 df             	cmp    %rbx,%r15
  802ce8:	72 3e                	jb     802d28 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802cea:	49 8b 06             	mov    (%r14),%rax
  802ced:	a8 01                	test   $0x1,%al
  802cef:	74 37                	je     802d28 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802cf1:	48 89 d8             	mov    %rbx,%rax
  802cf4:	48 c1 e8 1e          	shr    $0x1e,%rax
  802cf8:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802cfd:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802d03:	f6 c2 01             	test   $0x1,%dl
  802d06:	74 da                	je     802ce2 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802d08:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802d0d:	f6 c2 80             	test   $0x80,%dl
  802d10:	0f 84 61 ff ff ff    	je     802c77 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802d16:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802d1b:	f6 c4 04             	test   $0x4,%ah
  802d1e:	74 c2                	je     802ce2 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802d20:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802d26:	eb a9                	jmp    802cd1 <foreach_shared_region+0x9c>
    }
    return res;
}
  802d28:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2d:	48 83 c4 18          	add    $0x18,%rsp
  802d31:	5b                   	pop    %rbx
  802d32:	41 5c                	pop    %r12
  802d34:	41 5d                	pop    %r13
  802d36:	41 5e                	pop    %r14
  802d38:	41 5f                	pop    %r15
  802d3a:	5d                   	pop    %rbp
  802d3b:	c3                   	ret

0000000000802d3c <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802d3c:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802d40:	b8 00 00 00 00       	mov    $0x0,%eax
  802d45:	c3                   	ret

0000000000802d46 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802d46:	f3 0f 1e fa          	endbr64
  802d4a:	55                   	push   %rbp
  802d4b:	48 89 e5             	mov    %rsp,%rbp
  802d4e:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802d51:	48 be 12 43 80 00 00 	movabs $0x804312,%rsi
  802d58:	00 00 00 
  802d5b:	48 b8 fb 0e 80 00 00 	movabs $0x800efb,%rax
  802d62:	00 00 00 
  802d65:	ff d0                	call   *%rax
    return 0;
}
  802d67:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6c:	5d                   	pop    %rbp
  802d6d:	c3                   	ret

0000000000802d6e <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802d6e:	f3 0f 1e fa          	endbr64
  802d72:	55                   	push   %rbp
  802d73:	48 89 e5             	mov    %rsp,%rbp
  802d76:	41 57                	push   %r15
  802d78:	41 56                	push   %r14
  802d7a:	41 55                	push   %r13
  802d7c:	41 54                	push   %r12
  802d7e:	53                   	push   %rbx
  802d7f:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802d86:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802d8d:	48 85 d2             	test   %rdx,%rdx
  802d90:	74 7a                	je     802e0c <devcons_write+0x9e>
  802d92:	49 89 d6             	mov    %rdx,%r14
  802d95:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d9b:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802da0:	49 bf 16 11 80 00 00 	movabs $0x801116,%r15
  802da7:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802daa:	4c 89 f3             	mov    %r14,%rbx
  802dad:	48 29 f3             	sub    %rsi,%rbx
  802db0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802db5:	48 39 c3             	cmp    %rax,%rbx
  802db8:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802dbc:	4c 63 eb             	movslq %ebx,%r13
  802dbf:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802dc6:	48 01 c6             	add    %rax,%rsi
  802dc9:	4c 89 ea             	mov    %r13,%rdx
  802dcc:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802dd3:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802dd6:	4c 89 ee             	mov    %r13,%rsi
  802dd9:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802de0:	48 b8 5b 13 80 00 00 	movabs $0x80135b,%rax
  802de7:	00 00 00 
  802dea:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802dec:	41 01 dc             	add    %ebx,%r12d
  802def:	49 63 f4             	movslq %r12d,%rsi
  802df2:	4c 39 f6             	cmp    %r14,%rsi
  802df5:	72 b3                	jb     802daa <devcons_write+0x3c>
    return res;
  802df7:	49 63 c4             	movslq %r12d,%rax
}
  802dfa:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802e01:	5b                   	pop    %rbx
  802e02:	41 5c                	pop    %r12
  802e04:	41 5d                	pop    %r13
  802e06:	41 5e                	pop    %r14
  802e08:	41 5f                	pop    %r15
  802e0a:	5d                   	pop    %rbp
  802e0b:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802e0c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802e12:	eb e3                	jmp    802df7 <devcons_write+0x89>

0000000000802e14 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802e14:	f3 0f 1e fa          	endbr64
  802e18:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802e1b:	ba 00 00 00 00       	mov    $0x0,%edx
  802e20:	48 85 c0             	test   %rax,%rax
  802e23:	74 55                	je     802e7a <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802e25:	55                   	push   %rbp
  802e26:	48 89 e5             	mov    %rsp,%rbp
  802e29:	41 55                	push   %r13
  802e2b:	41 54                	push   %r12
  802e2d:	53                   	push   %rbx
  802e2e:	48 83 ec 08          	sub    $0x8,%rsp
  802e32:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802e35:	48 bb 8c 13 80 00 00 	movabs $0x80138c,%rbx
  802e3c:	00 00 00 
  802e3f:	49 bc 65 14 80 00 00 	movabs $0x801465,%r12
  802e46:	00 00 00 
  802e49:	eb 03                	jmp    802e4e <devcons_read+0x3a>
  802e4b:	41 ff d4             	call   *%r12
  802e4e:	ff d3                	call   *%rbx
  802e50:	85 c0                	test   %eax,%eax
  802e52:	74 f7                	je     802e4b <devcons_read+0x37>
    if (c < 0) return c;
  802e54:	48 63 d0             	movslq %eax,%rdx
  802e57:	78 13                	js     802e6c <devcons_read+0x58>
    if (c == 0x04) return 0;
  802e59:	ba 00 00 00 00       	mov    $0x0,%edx
  802e5e:	83 f8 04             	cmp    $0x4,%eax
  802e61:	74 09                	je     802e6c <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802e63:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802e67:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802e6c:	48 89 d0             	mov    %rdx,%rax
  802e6f:	48 83 c4 08          	add    $0x8,%rsp
  802e73:	5b                   	pop    %rbx
  802e74:	41 5c                	pop    %r12
  802e76:	41 5d                	pop    %r13
  802e78:	5d                   	pop    %rbp
  802e79:	c3                   	ret
  802e7a:	48 89 d0             	mov    %rdx,%rax
  802e7d:	c3                   	ret

0000000000802e7e <cputchar>:
cputchar(int ch) {
  802e7e:	f3 0f 1e fa          	endbr64
  802e82:	55                   	push   %rbp
  802e83:	48 89 e5             	mov    %rsp,%rbp
  802e86:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802e8a:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802e8e:	be 01 00 00 00       	mov    $0x1,%esi
  802e93:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802e97:	48 b8 5b 13 80 00 00 	movabs $0x80135b,%rax
  802e9e:	00 00 00 
  802ea1:	ff d0                	call   *%rax
}
  802ea3:	c9                   	leave
  802ea4:	c3                   	ret

0000000000802ea5 <getchar>:
getchar(void) {
  802ea5:	f3 0f 1e fa          	endbr64
  802ea9:	55                   	push   %rbp
  802eaa:	48 89 e5             	mov    %rsp,%rbp
  802ead:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802eb1:	ba 01 00 00 00       	mov    $0x1,%edx
  802eb6:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802eba:	bf 00 00 00 00       	mov    $0x0,%edi
  802ebf:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  802ec6:	00 00 00 
  802ec9:	ff d0                	call   *%rax
  802ecb:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802ecd:	85 c0                	test   %eax,%eax
  802ecf:	78 06                	js     802ed7 <getchar+0x32>
  802ed1:	74 08                	je     802edb <getchar+0x36>
  802ed3:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802ed7:	89 d0                	mov    %edx,%eax
  802ed9:	c9                   	leave
  802eda:	c3                   	ret
    return res < 0 ? res : res ? c :
  802edb:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802ee0:	eb f5                	jmp    802ed7 <getchar+0x32>

0000000000802ee2 <iscons>:
iscons(int fdnum) {
  802ee2:	f3 0f 1e fa          	endbr64
  802ee6:	55                   	push   %rbp
  802ee7:	48 89 e5             	mov    %rsp,%rbp
  802eea:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802eee:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802ef2:	48 b8 ba 1a 80 00 00 	movabs $0x801aba,%rax
  802ef9:	00 00 00 
  802efc:	ff d0                	call   *%rax
    if (res < 0) return res;
  802efe:	85 c0                	test   %eax,%eax
  802f00:	78 18                	js     802f1a <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802f02:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f06:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802f0d:	00 00 00 
  802f10:	8b 00                	mov    (%rax),%eax
  802f12:	39 02                	cmp    %eax,(%rdx)
  802f14:	0f 94 c0             	sete   %al
  802f17:	0f b6 c0             	movzbl %al,%eax
}
  802f1a:	c9                   	leave
  802f1b:	c3                   	ret

0000000000802f1c <opencons>:
opencons(void) {
  802f1c:	f3 0f 1e fa          	endbr64
  802f20:	55                   	push   %rbp
  802f21:	48 89 e5             	mov    %rsp,%rbp
  802f24:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802f28:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802f2c:	48 b8 56 1a 80 00 00 	movabs $0x801a56,%rax
  802f33:	00 00 00 
  802f36:	ff d0                	call   *%rax
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	78 49                	js     802f85 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802f3c:	b9 46 00 00 00       	mov    $0x46,%ecx
  802f41:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f46:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802f4a:	bf 00 00 00 00       	mov    $0x0,%edi
  802f4f:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  802f56:	00 00 00 
  802f59:	ff d0                	call   *%rax
  802f5b:	85 c0                	test   %eax,%eax
  802f5d:	78 26                	js     802f85 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802f5f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f63:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802f6a:	00 00 
  802f6c:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802f6e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802f72:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802f79:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  802f80:	00 00 00 
  802f83:	ff d0                	call   *%rax
}
  802f85:	c9                   	leave
  802f86:	c3                   	ret

0000000000802f87 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  802f87:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  802f8a:	48 b8 c6 31 80 00 00 	movabs $0x8031c6,%rax
  802f91:	00 00 00 
    call *%rax
  802f94:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  802f96:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  802f99:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802fa0:	00 
    movq UTRAP_RSP(%rsp), %rsp
  802fa1:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  802fa8:	00 
    pushq %rbx
  802fa9:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  802faa:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  802fb1:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  802fb4:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  802fb8:	4c 8b 3c 24          	mov    (%rsp),%r15
  802fbc:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802fc1:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802fc6:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802fcb:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802fd0:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802fd5:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802fda:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802fdf:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802fe4:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802fe9:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802fee:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802ff3:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802ff8:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802ffd:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803002:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  803006:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  80300a:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  80300b:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  80300c:	c3                   	ret

000000000080300d <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80300d:	f3 0f 1e fa          	endbr64
  803011:	55                   	push   %rbp
  803012:	48 89 e5             	mov    %rsp,%rbp
  803015:	41 54                	push   %r12
  803017:	53                   	push   %rbx
  803018:	48 89 fb             	mov    %rdi,%rbx
  80301b:	48 89 f7             	mov    %rsi,%rdi
  80301e:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803021:	48 85 f6             	test   %rsi,%rsi
  803024:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80302b:	00 00 00 
  80302e:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  803032:	be 00 10 00 00       	mov    $0x1000,%esi
  803037:	48 b8 22 18 80 00 00 	movabs $0x801822,%rax
  80303e:	00 00 00 
  803041:	ff d0                	call   *%rax
    if (res < 0) {
  803043:	85 c0                	test   %eax,%eax
  803045:	78 45                	js     80308c <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  803047:	48 85 db             	test   %rbx,%rbx
  80304a:	74 12                	je     80305e <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  80304c:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803053:	00 00 00 
  803056:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80305c:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  80305e:	4d 85 e4             	test   %r12,%r12
  803061:	74 14                	je     803077 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  803063:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80306a:	00 00 00 
  80306d:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  803073:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  803077:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80307e:	00 00 00 
  803081:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  803087:	5b                   	pop    %rbx
  803088:	41 5c                	pop    %r12
  80308a:	5d                   	pop    %rbp
  80308b:	c3                   	ret
        if (from_env_store != NULL) {
  80308c:	48 85 db             	test   %rbx,%rbx
  80308f:	74 06                	je     803097 <ipc_recv+0x8a>
            *from_env_store = 0;
  803091:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  803097:	4d 85 e4             	test   %r12,%r12
  80309a:	74 eb                	je     803087 <ipc_recv+0x7a>
            *perm_store = 0;
  80309c:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8030a3:	00 
  8030a4:	eb e1                	jmp    803087 <ipc_recv+0x7a>

00000000008030a6 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8030a6:	f3 0f 1e fa          	endbr64
  8030aa:	55                   	push   %rbp
  8030ab:	48 89 e5             	mov    %rsp,%rbp
  8030ae:	41 57                	push   %r15
  8030b0:	41 56                	push   %r14
  8030b2:	41 55                	push   %r13
  8030b4:	41 54                	push   %r12
  8030b6:	53                   	push   %rbx
  8030b7:	48 83 ec 18          	sub    $0x18,%rsp
  8030bb:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  8030be:	48 89 d3             	mov    %rdx,%rbx
  8030c1:	49 89 cc             	mov    %rcx,%r12
  8030c4:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8030c7:	48 85 d2             	test   %rdx,%rdx
  8030ca:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8030d1:	00 00 00 
  8030d4:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8030d8:	89 f0                	mov    %esi,%eax
  8030da:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8030de:	48 89 da             	mov    %rbx,%rdx
  8030e1:	48 89 c6             	mov    %rax,%rsi
  8030e4:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  8030eb:	00 00 00 
  8030ee:	ff d0                	call   *%rax
    while (res < 0) {
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	79 65                	jns    803159 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  8030f4:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8030f7:	75 33                	jne    80312c <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  8030f9:	49 bf 65 14 80 00 00 	movabs $0x801465,%r15
  803100:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803103:	49 be f2 17 80 00 00 	movabs $0x8017f2,%r14
  80310a:	00 00 00 
        sys_yield();
  80310d:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803110:	45 89 e8             	mov    %r13d,%r8d
  803113:	4c 89 e1             	mov    %r12,%rcx
  803116:	48 89 da             	mov    %rbx,%rdx
  803119:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80311d:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803120:	41 ff d6             	call   *%r14
    while (res < 0) {
  803123:	85 c0                	test   %eax,%eax
  803125:	79 32                	jns    803159 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803127:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80312a:	74 e1                	je     80310d <ipc_send+0x67>
            panic("Error: %i\n", res);
  80312c:	89 c1                	mov    %eax,%ecx
  80312e:	48 ba 1e 43 80 00 00 	movabs $0x80431e,%rdx
  803135:	00 00 00 
  803138:	be 42 00 00 00       	mov    $0x42,%esi
  80313d:	48 bf 29 43 80 00 00 	movabs $0x804329,%rdi
  803144:	00 00 00 
  803147:	b8 00 00 00 00       	mov    $0x0,%eax
  80314c:	49 b8 56 04 80 00 00 	movabs $0x800456,%r8
  803153:	00 00 00 
  803156:	41 ff d0             	call   *%r8
    }
}
  803159:	48 83 c4 18          	add    $0x18,%rsp
  80315d:	5b                   	pop    %rbx
  80315e:	41 5c                	pop    %r12
  803160:	41 5d                	pop    %r13
  803162:	41 5e                	pop    %r14
  803164:	41 5f                	pop    %r15
  803166:	5d                   	pop    %rbp
  803167:	c3                   	ret

0000000000803168 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  803168:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  80316c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  803171:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  803178:	00 00 00 
  80317b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80317f:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803183:	48 c1 e2 04          	shl    $0x4,%rdx
  803187:	48 01 ca             	add    %rcx,%rdx
  80318a:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  803190:	39 fa                	cmp    %edi,%edx
  803192:	74 12                	je     8031a6 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  803194:	48 83 c0 01          	add    $0x1,%rax
  803198:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  80319e:	75 db                	jne    80317b <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  8031a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031a5:	c3                   	ret
            return envs[i].env_id;
  8031a6:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8031aa:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8031ae:	48 c1 e2 04          	shl    $0x4,%rdx
  8031b2:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8031b9:	00 00 00 
  8031bc:	48 01 d0             	add    %rdx,%rax
  8031bf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8031c5:	c3                   	ret

00000000008031c6 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  8031c6:	f3 0f 1e fa          	endbr64
  8031ca:	55                   	push   %rbp
  8031cb:	48 89 e5             	mov    %rsp,%rbp
  8031ce:	41 56                	push   %r14
  8031d0:	41 55                	push   %r13
  8031d2:	41 54                	push   %r12
  8031d4:	53                   	push   %rbx
  8031d5:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  8031d8:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  8031df:	00 00 00 
  8031e2:	48 83 38 00          	cmpq   $0x0,(%rax)
  8031e6:	74 27                	je     80320f <_handle_vectored_pagefault+0x49>
  8031e8:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  8031ed:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  8031f4:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8031f7:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  8031fa:	4c 89 e7             	mov    %r12,%rdi
  8031fd:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  803202:	84 c0                	test   %al,%al
  803204:	75 45                	jne    80324b <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803206:	48 83 c3 01          	add    $0x1,%rbx
  80320a:	49 3b 1e             	cmp    (%r14),%rbx
  80320d:	72 eb                	jb     8031fa <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  80320f:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  803216:	00 
  803217:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  80321c:	4d 8b 04 24          	mov    (%r12),%r8
  803220:	48 ba a8 44 80 00 00 	movabs $0x8044a8,%rdx
  803227:	00 00 00 
  80322a:	be 1d 00 00 00       	mov    $0x1d,%esi
  80322f:	48 bf 33 43 80 00 00 	movabs $0x804333,%rdi
  803236:	00 00 00 
  803239:	b8 00 00 00 00       	mov    $0x0,%eax
  80323e:	49 ba 56 04 80 00 00 	movabs $0x800456,%r10
  803245:	00 00 00 
  803248:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  80324b:	5b                   	pop    %rbx
  80324c:	41 5c                	pop    %r12
  80324e:	41 5d                	pop    %r13
  803250:	41 5e                	pop    %r14
  803252:	5d                   	pop    %rbp
  803253:	c3                   	ret

0000000000803254 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  803254:	f3 0f 1e fa          	endbr64
  803258:	55                   	push   %rbp
  803259:	48 89 e5             	mov    %rsp,%rbp
  80325c:	53                   	push   %rbx
  80325d:	48 83 ec 08          	sub    $0x8,%rsp
  803261:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  803264:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80326b:	00 00 00 
  80326e:	80 38 00             	cmpb   $0x0,(%rax)
  803271:	0f 84 84 00 00 00    	je     8032fb <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  803277:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  80327e:	00 00 00 
  803281:	48 8b 10             	mov    (%rax),%rdx
  803284:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  803289:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  803290:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803293:	48 85 d2             	test   %rdx,%rdx
  803296:	74 19                	je     8032b1 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  803298:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  80329c:	0f 84 e8 00 00 00    	je     80338a <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  8032a2:	48 83 c0 01          	add    $0x1,%rax
  8032a6:	48 39 d0             	cmp    %rdx,%rax
  8032a9:	75 ed                	jne    803298 <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  8032ab:	48 83 fa 08          	cmp    $0x8,%rdx
  8032af:	74 1c                	je     8032cd <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  8032b1:	48 8d 42 01          	lea    0x1(%rdx),%rax
  8032b5:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  8032bc:	00 00 00 
  8032bf:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8032c6:	00 00 00 
  8032c9:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8032cd:	48 b8 30 14 80 00 00 	movabs $0x801430,%rax
  8032d4:	00 00 00 
  8032d7:	ff d0                	call   *%rax
  8032d9:	89 c7                	mov    %eax,%edi
  8032db:	48 be 87 2f 80 00 00 	movabs $0x802f87,%rsi
  8032e2:	00 00 00 
  8032e5:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  8032ec:	00 00 00 
  8032ef:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8032f1:	85 c0                	test   %eax,%eax
  8032f3:	78 68                	js     80335d <add_pgfault_handler+0x109>
    return res;
}
  8032f5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8032f9:	c9                   	leave
  8032fa:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  8032fb:	48 b8 30 14 80 00 00 	movabs $0x801430,%rax
  803302:	00 00 00 
  803305:	ff d0                	call   *%rax
  803307:	89 c7                	mov    %eax,%edi
  803309:	b9 06 00 00 00       	mov    $0x6,%ecx
  80330e:	ba 00 10 00 00       	mov    $0x1000,%edx
  803313:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  80331a:	00 00 00 
  80331d:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  803324:	00 00 00 
  803327:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  803329:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  803330:	00 00 00 
  803333:	48 8b 02             	mov    (%rdx),%rax
  803336:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80333a:	48 89 0a             	mov    %rcx,(%rdx)
  80333d:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803344:	00 00 00 
  803347:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  80334b:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803352:	00 00 00 
  803355:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  803358:	e9 70 ff ff ff       	jmp    8032cd <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  80335d:	89 c1                	mov    %eax,%ecx
  80335f:	48 ba 41 43 80 00 00 	movabs $0x804341,%rdx
  803366:	00 00 00 
  803369:	be 3d 00 00 00       	mov    $0x3d,%esi
  80336e:	48 bf 33 43 80 00 00 	movabs $0x804333,%rdi
  803375:	00 00 00 
  803378:	b8 00 00 00 00       	mov    $0x0,%eax
  80337d:	49 b8 56 04 80 00 00 	movabs $0x800456,%r8
  803384:	00 00 00 
  803387:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  80338a:	b8 00 00 00 00       	mov    $0x0,%eax
  80338f:	e9 61 ff ff ff       	jmp    8032f5 <add_pgfault_handler+0xa1>

0000000000803394 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  803394:	f3 0f 1e fa          	endbr64
  803398:	55                   	push   %rbp
  803399:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  80339c:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8033a3:	00 00 00 
  8033a6:	80 38 00             	cmpb   $0x0,(%rax)
  8033a9:	74 33                	je     8033de <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8033ab:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  8033b2:	00 00 00 
  8033b5:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  8033ba:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  8033c1:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8033c4:	48 85 c0             	test   %rax,%rax
  8033c7:	0f 84 85 00 00 00    	je     803452 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  8033cd:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  8033d1:	74 40                	je     803413 <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8033d3:	48 83 c1 01          	add    $0x1,%rcx
  8033d7:	48 39 c1             	cmp    %rax,%rcx
  8033da:	75 f1                	jne    8033cd <remove_pgfault_handler+0x39>
  8033dc:	eb 74                	jmp    803452 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  8033de:	48 b9 59 43 80 00 00 	movabs $0x804359,%rcx
  8033e5:	00 00 00 
  8033e8:	48 ba db 42 80 00 00 	movabs $0x8042db,%rdx
  8033ef:	00 00 00 
  8033f2:	be 43 00 00 00       	mov    $0x43,%esi
  8033f7:	48 bf 33 43 80 00 00 	movabs $0x804333,%rdi
  8033fe:	00 00 00 
  803401:	b8 00 00 00 00       	mov    $0x0,%eax
  803406:	49 b8 56 04 80 00 00 	movabs $0x800456,%r8
  80340d:	00 00 00 
  803410:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  803413:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  80341a:	00 
  80341b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80341f:	48 29 ca             	sub    %rcx,%rdx
  803422:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803429:	00 00 00 
  80342c:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  803430:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  803435:	48 89 ce             	mov    %rcx,%rsi
  803438:	48 b8 16 11 80 00 00 	movabs $0x801116,%rax
  80343f:	00 00 00 
  803442:	ff d0                	call   *%rax
            _pfhandler_off--;
  803444:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  80344b:	00 00 00 
  80344e:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  803452:	5d                   	pop    %rbp
  803453:	c3                   	ret

0000000000803454 <__text_end>:
  803454:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80345b:	00 00 00 
  80345e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803465:	00 00 00 
  803468:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80346f:	00 00 00 
  803472:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803479:	00 00 00 
  80347c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803483:	00 00 00 
  803486:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80348d:	00 00 00 
  803490:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803497:	00 00 00 
  80349a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034a1:	00 00 00 
  8034a4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ab:	00 00 00 
  8034ae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034b5:	00 00 00 
  8034b8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034bf:	00 00 00 
  8034c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034c9:	00 00 00 
  8034cc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034d3:	00 00 00 
  8034d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034dd:	00 00 00 
  8034e0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034e7:	00 00 00 
  8034ea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034f1:	00 00 00 
  8034f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034fb:	00 00 00 
  8034fe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803505:	00 00 00 
  803508:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80350f:	00 00 00 
  803512:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803519:	00 00 00 
  80351c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803523:	00 00 00 
  803526:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80352d:	00 00 00 
  803530:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803537:	00 00 00 
  80353a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803541:	00 00 00 
  803544:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80354b:	00 00 00 
  80354e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803555:	00 00 00 
  803558:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80355f:	00 00 00 
  803562:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803569:	00 00 00 
  80356c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803573:	00 00 00 
  803576:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80357d:	00 00 00 
  803580:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803587:	00 00 00 
  80358a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803591:	00 00 00 
  803594:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80359b:	00 00 00 
  80359e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a5:	00 00 00 
  8035a8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035af:	00 00 00 
  8035b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b9:	00 00 00 
  8035bc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035c3:	00 00 00 
  8035c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035cd:	00 00 00 
  8035d0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035d7:	00 00 00 
  8035da:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035e1:	00 00 00 
  8035e4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035eb:	00 00 00 
  8035ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035f5:	00 00 00 
  8035f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ff:	00 00 00 
  803602:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803609:	00 00 00 
  80360c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803613:	00 00 00 
  803616:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80361d:	00 00 00 
  803620:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803627:	00 00 00 
  80362a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803631:	00 00 00 
  803634:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80363b:	00 00 00 
  80363e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803645:	00 00 00 
  803648:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80364f:	00 00 00 
  803652:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803659:	00 00 00 
  80365c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803663:	00 00 00 
  803666:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80366d:	00 00 00 
  803670:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803677:	00 00 00 
  80367a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803681:	00 00 00 
  803684:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80368b:	00 00 00 
  80368e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803695:	00 00 00 
  803698:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80369f:	00 00 00 
  8036a2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036a9:	00 00 00 
  8036ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036b3:	00 00 00 
  8036b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036bd:	00 00 00 
  8036c0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036c7:	00 00 00 
  8036ca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036d1:	00 00 00 
  8036d4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036db:	00 00 00 
  8036de:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036e5:	00 00 00 
  8036e8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ef:	00 00 00 
  8036f2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036f9:	00 00 00 
  8036fc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803703:	00 00 00 
  803706:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80370d:	00 00 00 
  803710:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803717:	00 00 00 
  80371a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803721:	00 00 00 
  803724:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80372b:	00 00 00 
  80372e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803735:	00 00 00 
  803738:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80373f:	00 00 00 
  803742:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803749:	00 00 00 
  80374c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803753:	00 00 00 
  803756:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80375d:	00 00 00 
  803760:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803767:	00 00 00 
  80376a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803771:	00 00 00 
  803774:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80377b:	00 00 00 
  80377e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803785:	00 00 00 
  803788:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80378f:	00 00 00 
  803792:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803799:	00 00 00 
  80379c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a3:	00 00 00 
  8037a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ad:	00 00 00 
  8037b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b7:	00 00 00 
  8037ba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c1:	00 00 00 
  8037c4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037cb:	00 00 00 
  8037ce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d5:	00 00 00 
  8037d8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037df:	00 00 00 
  8037e2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e9:	00 00 00 
  8037ec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f3:	00 00 00 
  8037f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037fd:	00 00 00 
  803800:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803807:	00 00 00 
  80380a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803811:	00 00 00 
  803814:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80381b:	00 00 00 
  80381e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803825:	00 00 00 
  803828:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80382f:	00 00 00 
  803832:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803839:	00 00 00 
  80383c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803843:	00 00 00 
  803846:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80384d:	00 00 00 
  803850:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803857:	00 00 00 
  80385a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803861:	00 00 00 
  803864:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80386b:	00 00 00 
  80386e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803875:	00 00 00 
  803878:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80387f:	00 00 00 
  803882:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803889:	00 00 00 
  80388c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803893:	00 00 00 
  803896:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80389d:	00 00 00 
  8038a0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a7:	00 00 00 
  8038aa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b1:	00 00 00 
  8038b4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038bb:	00 00 00 
  8038be:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c5:	00 00 00 
  8038c8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038cf:	00 00 00 
  8038d2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d9:	00 00 00 
  8038dc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e3:	00 00 00 
  8038e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ed:	00 00 00 
  8038f0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f7:	00 00 00 
  8038fa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803901:	00 00 00 
  803904:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80390b:	00 00 00 
  80390e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803915:	00 00 00 
  803918:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80391f:	00 00 00 
  803922:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803929:	00 00 00 
  80392c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803933:	00 00 00 
  803936:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80393d:	00 00 00 
  803940:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803947:	00 00 00 
  80394a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803951:	00 00 00 
  803954:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80395b:	00 00 00 
  80395e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803965:	00 00 00 
  803968:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80396f:	00 00 00 
  803972:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803979:	00 00 00 
  80397c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803983:	00 00 00 
  803986:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80398d:	00 00 00 
  803990:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803997:	00 00 00 
  80399a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a1:	00 00 00 
  8039a4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ab:	00 00 00 
  8039ae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b5:	00 00 00 
  8039b8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039bf:	00 00 00 
  8039c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c9:	00 00 00 
  8039cc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d3:	00 00 00 
  8039d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039dd:	00 00 00 
  8039e0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e7:	00 00 00 
  8039ea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f1:	00 00 00 
  8039f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039fb:	00 00 00 
  8039fe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a05:	00 00 00 
  803a08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a0f:	00 00 00 
  803a12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a19:	00 00 00 
  803a1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a23:	00 00 00 
  803a26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a2d:	00 00 00 
  803a30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a37:	00 00 00 
  803a3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a41:	00 00 00 
  803a44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a4b:	00 00 00 
  803a4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a55:	00 00 00 
  803a58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a5f:	00 00 00 
  803a62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a69:	00 00 00 
  803a6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a73:	00 00 00 
  803a76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a7d:	00 00 00 
  803a80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a87:	00 00 00 
  803a8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a91:	00 00 00 
  803a94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a9b:	00 00 00 
  803a9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa5:	00 00 00 
  803aa8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aaf:	00 00 00 
  803ab2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab9:	00 00 00 
  803abc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac3:	00 00 00 
  803ac6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803acd:	00 00 00 
  803ad0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad7:	00 00 00 
  803ada:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae1:	00 00 00 
  803ae4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aeb:	00 00 00 
  803aee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af5:	00 00 00 
  803af8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aff:	00 00 00 
  803b02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b09:	00 00 00 
  803b0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b13:	00 00 00 
  803b16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b1d:	00 00 00 
  803b20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b27:	00 00 00 
  803b2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b31:	00 00 00 
  803b34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b3b:	00 00 00 
  803b3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b45:	00 00 00 
  803b48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b4f:	00 00 00 
  803b52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b59:	00 00 00 
  803b5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b63:	00 00 00 
  803b66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b6d:	00 00 00 
  803b70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b77:	00 00 00 
  803b7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b81:	00 00 00 
  803b84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b8b:	00 00 00 
  803b8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b95:	00 00 00 
  803b98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b9f:	00 00 00 
  803ba2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba9:	00 00 00 
  803bac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb3:	00 00 00 
  803bb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bbd:	00 00 00 
  803bc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc7:	00 00 00 
  803bca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd1:	00 00 00 
  803bd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bdb:	00 00 00 
  803bde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be5:	00 00 00 
  803be8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bef:	00 00 00 
  803bf2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf9:	00 00 00 
  803bfc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c03:	00 00 00 
  803c06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c0d:	00 00 00 
  803c10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c17:	00 00 00 
  803c1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c21:	00 00 00 
  803c24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c2b:	00 00 00 
  803c2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c35:	00 00 00 
  803c38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c3f:	00 00 00 
  803c42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c49:	00 00 00 
  803c4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c53:	00 00 00 
  803c56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c5d:	00 00 00 
  803c60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c67:	00 00 00 
  803c6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c71:	00 00 00 
  803c74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c7b:	00 00 00 
  803c7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c85:	00 00 00 
  803c88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c8f:	00 00 00 
  803c92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c99:	00 00 00 
  803c9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca3:	00 00 00 
  803ca6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cad:	00 00 00 
  803cb0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb7:	00 00 00 
  803cba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc1:	00 00 00 
  803cc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ccb:	00 00 00 
  803cce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd5:	00 00 00 
  803cd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cdf:	00 00 00 
  803ce2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce9:	00 00 00 
  803cec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf3:	00 00 00 
  803cf6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cfd:	00 00 00 
  803d00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d07:	00 00 00 
  803d0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d11:	00 00 00 
  803d14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d1b:	00 00 00 
  803d1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d25:	00 00 00 
  803d28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d2f:	00 00 00 
  803d32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d39:	00 00 00 
  803d3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d43:	00 00 00 
  803d46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d4d:	00 00 00 
  803d50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d57:	00 00 00 
  803d5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d61:	00 00 00 
  803d64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d6b:	00 00 00 
  803d6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d75:	00 00 00 
  803d78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d7f:	00 00 00 
  803d82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d89:	00 00 00 
  803d8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d93:	00 00 00 
  803d96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d9d:	00 00 00 
  803da0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da7:	00 00 00 
  803daa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db1:	00 00 00 
  803db4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dbb:	00 00 00 
  803dbe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc5:	00 00 00 
  803dc8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dcf:	00 00 00 
  803dd2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd9:	00 00 00 
  803ddc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de3:	00 00 00 
  803de6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ded:	00 00 00 
  803df0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df7:	00 00 00 
  803dfa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e01:	00 00 00 
  803e04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e0b:	00 00 00 
  803e0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e15:	00 00 00 
  803e18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e1f:	00 00 00 
  803e22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e29:	00 00 00 
  803e2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e33:	00 00 00 
  803e36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e3d:	00 00 00 
  803e40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e47:	00 00 00 
  803e4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e51:	00 00 00 
  803e54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e5b:	00 00 00 
  803e5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e65:	00 00 00 
  803e68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e6f:	00 00 00 
  803e72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e79:	00 00 00 
  803e7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e83:	00 00 00 
  803e86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e8d:	00 00 00 
  803e90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e97:	00 00 00 
  803e9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea1:	00 00 00 
  803ea4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eab:	00 00 00 
  803eae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb5:	00 00 00 
  803eb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ebf:	00 00 00 
  803ec2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec9:	00 00 00 
  803ecc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed3:	00 00 00 
  803ed6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803edd:	00 00 00 
  803ee0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee7:	00 00 00 
  803eea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef1:	00 00 00 
  803ef4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803efb:	00 00 00 
  803efe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f05:	00 00 00 
  803f08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f0f:	00 00 00 
  803f12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f19:	00 00 00 
  803f1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f23:	00 00 00 
  803f26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f2d:	00 00 00 
  803f30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f37:	00 00 00 
  803f3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f41:	00 00 00 
  803f44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f4b:	00 00 00 
  803f4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f55:	00 00 00 
  803f58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f5f:	00 00 00 
  803f62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f69:	00 00 00 
  803f6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f73:	00 00 00 
  803f76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f7d:	00 00 00 
  803f80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f87:	00 00 00 
  803f8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f91:	00 00 00 
  803f94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f9b:	00 00 00 
  803f9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa5:	00 00 00 
  803fa8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803faf:	00 00 00 
  803fb2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb9:	00 00 00 
  803fbc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc3:	00 00 00 
  803fc6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fcd:	00 00 00 
  803fd0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd7:	00 00 00 
  803fda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe1:	00 00 00 
  803fe4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803feb:	00 00 00 
  803fee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff5:	00 00 00 
  803ff8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  803fff:	00 
