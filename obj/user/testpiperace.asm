
obj/user/testpiperace:     file format elf64-x86-64


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
  80001e:	e8 3c 03 00 00       	call   80035f <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 57                	push   %r15
  80002f:	41 56                	push   %r14
  800031:	41 55                	push   %r13
  800033:	41 54                	push   %r12
  800035:	53                   	push   %rbx
  800036:	48 83 ec 28          	sub    $0x28,%rsp
    int p[2], r, pid, i, max;
    void *va;
    struct Fd *fd;
    const volatile struct Env *kid;

    cprintf("testing for dup race...\n");
  80003a:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  800041:	00 00 00 
  800044:	b8 00 00 00 00       	mov    $0x0,%eax
  800049:	48 ba 94 05 80 00 00 	movabs $0x800594,%rdx
  800050:	00 00 00 
  800053:	ff d2                	call   *%rdx
    if ((r = pipe(p)) < 0)
  800055:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  800059:	48 b8 08 29 80 00 00 	movabs $0x802908,%rax
  800060:	00 00 00 
  800063:	ff d0                	call   *%rax
  800065:	85 c0                	test   %eax,%eax
  800067:	0f 88 8e 01 00 00    	js     8001fb <umain+0x1d6>
        panic("pipe: %i", r);
    max = 200;
    if ((r = fork()) < 0)
  80006d:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  800074:	00 00 00 
  800077:	ff d0                	call   *%rax
  800079:	89 45 bc             	mov    %eax,-0x44(%rbp)
  80007c:	85 c0                	test   %eax,%eax
  80007e:	0f 88 a4 01 00 00    	js     800228 <umain+0x203>
        panic("fork: %i", r);
    if (r == 0) {
  800084:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  800088:	0f 84 c7 01 00 00    	je     800255 <umain+0x230>
        }
        /* do something to be not runnable besides exiting */
        ipc_recv(0, 0, 0, 0);
    }
    pid = r;
    cprintf("pid is %d\n", pid);
  80008e:	8b 5d bc             	mov    -0x44(%rbp),%ebx
  800091:	89 de                	mov    %ebx,%esi
  800093:	48 bf 5a 40 80 00 00 	movabs $0x80405a,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 be 94 05 80 00 00 	movabs $0x800594,%r14
  8000a9:	00 00 00 
  8000ac:	41 ff d6             	call   *%r14
    va = 0;
    kid = &envs[ENVX(pid)];
  8000af:	41 89 dd             	mov    %ebx,%r13d
  8000b2:	41 81 e5 ff 03 00 00 	and    $0x3ff,%r13d
    cprintf("kid is %d\n", (int32_t)(kid - envs));
  8000b9:	41 89 dc             	mov    %ebx,%r12d
  8000bc:	41 81 e4 ff 03 00 00 	and    $0x3ff,%r12d
  8000c3:	4b 8d 1c e4          	lea    (%r12,%r12,8),%rbx
  8000c7:	48 01 db             	add    %rbx,%rbx
  8000ca:	4a 8d 34 23          	lea    (%rbx,%r12,1),%rsi
  8000ce:	69 f6 1b ca 6b 28    	imul   $0x286bca1b,%esi,%esi
  8000d4:	48 bf 65 40 80 00 00 	movabs $0x804065,%rdi
  8000db:	00 00 00 
  8000de:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e3:	41 ff d6             	call   *%r14
    dup(p[0], 10);
  8000e6:	be 0a 00 00 00       	mov    $0xa,%esi
  8000eb:	8b 7d c8             	mov    -0x38(%rbp),%edi
  8000ee:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  8000f5:	00 00 00 
  8000f8:	ff d0                	call   *%rax
    while (kid->env_status == ENV_RUNNABLE)
  8000fa:	4c 01 e3             	add    %r12,%rbx
  8000fd:	48 c1 e3 04          	shl    $0x4,%rbx
  800101:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  800108:	00 00 00 
  80010b:	48 01 d8             	add    %rbx,%rax
  80010e:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  800114:	83 f8 02             	cmp    $0x2,%eax
  800117:	75 3e                	jne    800157 <umain+0x132>
        dup(p[0], 10);
  800119:	49 bc 29 1e 80 00 00 	movabs $0x801e29,%r12
  800120:	00 00 00 
    while (kid->env_status == ENV_RUNNABLE)
  800123:	4d 63 ed             	movslq %r13d,%r13
  800126:	4b 8d 44 ed 00       	lea    0x0(%r13,%r13,8),%rax
  80012b:	49 8d 44 45 00       	lea    0x0(%r13,%rax,2),%rax
  800130:	48 c1 e0 04          	shl    $0x4,%rax
  800134:	48 bb 00 00 a0 1f 80 	movabs $0x801fa00000,%rbx
  80013b:	00 00 00 
  80013e:	48 01 c3             	add    %rax,%rbx
        dup(p[0], 10);
  800141:	be 0a 00 00 00       	mov    $0xa,%esi
  800146:	8b 7d c8             	mov    -0x38(%rbp),%edi
  800149:	41 ff d4             	call   *%r12
    while (kid->env_status == ENV_RUNNABLE)
  80014c:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
  800152:	83 f8 02             	cmp    $0x2,%eax
  800155:	74 ea                	je     800141 <umain+0x11c>

    cprintf("child done with loop\n");
  800157:	48 bf 70 40 80 00 00 	movabs $0x804070,%rdi
  80015e:	00 00 00 
  800161:	b8 00 00 00 00       	mov    $0x0,%eax
  800166:	48 ba 94 05 80 00 00 	movabs $0x800594,%rdx
  80016d:	00 00 00 
  800170:	ff d2                	call   *%rdx
    if (pipeisclosed(p[0]))
  800172:	8b 7d c8             	mov    -0x38(%rbp),%edi
  800175:	48 b8 18 2b 80 00 00 	movabs $0x802b18,%rax
  80017c:	00 00 00 
  80017f:	ff d0                	call   *%rax
  800181:	85 c0                	test   %eax,%eax
  800183:	0f 85 5a 01 00 00    	jne    8002e3 <umain+0x2be>
        panic("somehow the other end of p[0] got closed!");
    if ((r = fd_lookup(p[0], &fd)) < 0)
  800189:	48 8d 75 c0          	lea    -0x40(%rbp),%rsi
  80018d:	8b 7d c8             	mov    -0x38(%rbp),%edi
  800190:	48 b8 55 1c 80 00 00 	movabs $0x801c55,%rax
  800197:	00 00 00 
  80019a:	ff d0                	call   *%rax
  80019c:	85 c0                	test   %eax,%eax
  80019e:	0f 88 69 01 00 00    	js     80030d <umain+0x2e8>
        panic("cannot look up p[0]: %i", r);
    va = fd2data(fd);
  8001a4:	48 8b 7d c0          	mov    -0x40(%rbp),%rdi
  8001a8:	48 b8 d1 1b 80 00 00 	movabs $0x801bd1,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	call   *%rax
  8001b4:	48 89 c7             	mov    %rax,%rdi
    if (sys_region_refs(va, PAGE_SIZE) != 3 + 1)
  8001b7:	be 00 10 00 00       	mov    $0x1000,%esi
  8001bc:	48 b8 7c 14 80 00 00 	movabs $0x80147c,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	call   *%rax
  8001c8:	83 f8 04             	cmp    $0x4,%eax
  8001cb:	0f 84 69 01 00 00    	je     80033a <umain+0x315>
        cprintf("\nchild detected race\n");
  8001d1:	48 bf 9e 40 80 00 00 	movabs $0x80409e,%rdi
  8001d8:	00 00 00 
  8001db:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e0:	48 ba 94 05 80 00 00 	movabs $0x800594,%rdx
  8001e7:	00 00 00 
  8001ea:	ff d2                	call   *%rdx
    else
        cprintf("\nrace didn't happen (number of tests: %d)\n", max);
}
  8001ec:	48 83 c4 28          	add    $0x28,%rsp
  8001f0:	5b                   	pop    %rbx
  8001f1:	41 5c                	pop    %r12
  8001f3:	41 5d                	pop    %r13
  8001f5:	41 5e                	pop    %r14
  8001f7:	41 5f                	pop    %r15
  8001f9:	5d                   	pop    %rbp
  8001fa:	c3                   	ret
        panic("pipe: %i", r);
  8001fb:	89 c1                	mov    %eax,%ecx
  8001fd:	48 ba 19 40 80 00 00 	movabs $0x804019,%rdx
  800204:	00 00 00 
  800207:	be 0c 00 00 00       	mov    $0xc,%esi
  80020c:	48 bf 22 40 80 00 00 	movabs $0x804022,%rdi
  800213:	00 00 00 
  800216:	b8 00 00 00 00       	mov    $0x0,%eax
  80021b:	49 b8 38 04 80 00 00 	movabs $0x800438,%r8
  800222:	00 00 00 
  800225:	41 ff d0             	call   *%r8
        panic("fork: %i", r);
  800228:	89 c1                	mov    %eax,%ecx
  80022a:	48 ba 36 40 80 00 00 	movabs $0x804036,%rdx
  800231:	00 00 00 
  800234:	be 0f 00 00 00       	mov    $0xf,%esi
  800239:	48 bf 22 40 80 00 00 	movabs $0x804022,%rdi
  800240:	00 00 00 
  800243:	b8 00 00 00 00       	mov    $0x0,%eax
  800248:	49 b8 38 04 80 00 00 	movabs $0x800438,%r8
  80024f:	00 00 00 
  800252:	41 ff d0             	call   *%r8
        close(p[1]);
  800255:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800258:	48 b8 c6 1d 80 00 00 	movabs $0x801dc6,%rax
  80025f:	00 00 00 
  800262:	ff d0                	call   *%rax
  800264:	bb c8 00 00 00       	mov    $0xc8,%ebx
            if (pipeisclosed(p[0])) {
  800269:	49 bc 18 2b 80 00 00 	movabs $0x802b18,%r12
  800270:	00 00 00 
                cprintf("RACE: pipe appears closed\n");
  800273:	49 bf 3f 40 80 00 00 	movabs $0x80403f,%r15
  80027a:	00 00 00 
  80027d:	49 be 94 05 80 00 00 	movabs $0x800594,%r14
  800284:	00 00 00 
                exit();
  800287:	49 bd 11 04 80 00 00 	movabs $0x800411,%r13
  80028e:	00 00 00 
  800291:	eb 11                	jmp    8002a4 <umain+0x27f>
            sys_yield();
  800293:	48 b8 47 14 80 00 00 	movabs $0x801447,%rax
  80029a:	00 00 00 
  80029d:	ff d0                	call   *%rax
        for (i = 0; i < max; i++) {
  80029f:	83 eb 01             	sub    $0x1,%ebx
  8002a2:	74 1a                	je     8002be <umain+0x299>
            if (pipeisclosed(p[0])) {
  8002a4:	8b 7d c8             	mov    -0x38(%rbp),%edi
  8002a7:	41 ff d4             	call   *%r12
  8002aa:	85 c0                	test   %eax,%eax
  8002ac:	74 e5                	je     800293 <umain+0x26e>
                cprintf("RACE: pipe appears closed\n");
  8002ae:	4c 89 ff             	mov    %r15,%rdi
  8002b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b6:	41 ff d6             	call   *%r14
                exit();
  8002b9:	41 ff d5             	call   *%r13
  8002bc:	eb d5                	jmp    800293 <umain+0x26e>
        ipc_recv(0, 0, 0, 0);
  8002be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c8:	be 00 00 00 00       	mov    $0x0,%esi
  8002cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8002d2:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  8002d9:	00 00 00 
  8002dc:	ff d0                	call   *%rax
  8002de:	e9 ab fd ff ff       	jmp    80008e <umain+0x69>
        panic("somehow the other end of p[0] got closed!");
  8002e3:	48 ba 70 43 80 00 00 	movabs $0x804370,%rdx
  8002ea:	00 00 00 
  8002ed:	be 38 00 00 00       	mov    $0x38,%esi
  8002f2:	48 bf 22 40 80 00 00 	movabs $0x804022,%rdi
  8002f9:	00 00 00 
  8002fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800301:	48 b9 38 04 80 00 00 	movabs $0x800438,%rcx
  800308:	00 00 00 
  80030b:	ff d1                	call   *%rcx
        panic("cannot look up p[0]: %i", r);
  80030d:	89 c1                	mov    %eax,%ecx
  80030f:	48 ba 86 40 80 00 00 	movabs $0x804086,%rdx
  800316:	00 00 00 
  800319:	be 3a 00 00 00       	mov    $0x3a,%esi
  80031e:	48 bf 22 40 80 00 00 	movabs $0x804022,%rdi
  800325:	00 00 00 
  800328:	b8 00 00 00 00       	mov    $0x0,%eax
  80032d:	49 b8 38 04 80 00 00 	movabs $0x800438,%r8
  800334:	00 00 00 
  800337:	41 ff d0             	call   *%r8
        cprintf("\nrace didn't happen (number of tests: %d)\n", max);
  80033a:	be c8 00 00 00       	mov    $0xc8,%esi
  80033f:	48 bf a0 43 80 00 00 	movabs $0x8043a0,%rdi
  800346:	00 00 00 
  800349:	b8 00 00 00 00       	mov    $0x0,%eax
  80034e:	48 ba 94 05 80 00 00 	movabs $0x800594,%rdx
  800355:	00 00 00 
  800358:	ff d2                	call   *%rdx
}
  80035a:	e9 8d fe ff ff       	jmp    8001ec <umain+0x1c7>

000000000080035f <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80035f:	f3 0f 1e fa          	endbr64
  800363:	55                   	push   %rbp
  800364:	48 89 e5             	mov    %rsp,%rbp
  800367:	41 56                	push   %r14
  800369:	41 55                	push   %r13
  80036b:	41 54                	push   %r12
  80036d:	53                   	push   %rbx
  80036e:	41 89 fd             	mov    %edi,%r13d
  800371:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800374:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  80037b:	00 00 00 
  80037e:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  800385:	00 00 00 
  800388:	48 39 c2             	cmp    %rax,%rdx
  80038b:	73 17                	jae    8003a4 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80038d:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800390:	49 89 c4             	mov    %rax,%r12
  800393:	48 83 c3 08          	add    $0x8,%rbx
  800397:	b8 00 00 00 00       	mov    $0x0,%eax
  80039c:	ff 53 f8             	call   *-0x8(%rbx)
  80039f:	4c 39 e3             	cmp    %r12,%rbx
  8003a2:	72 ef                	jb     800393 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8003a4:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  8003ab:	00 00 00 
  8003ae:	ff d0                	call   *%rax
  8003b0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003b5:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8003b9:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8003bd:	48 c1 e0 04          	shl    $0x4,%rax
  8003c1:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8003c8:	00 00 00 
  8003cb:	48 01 d0             	add    %rdx,%rax
  8003ce:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8003d5:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8003d8:	45 85 ed             	test   %r13d,%r13d
  8003db:	7e 0d                	jle    8003ea <libmain+0x8b>
  8003dd:	49 8b 06             	mov    (%r14),%rax
  8003e0:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8003e7:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8003ea:	4c 89 f6             	mov    %r14,%rsi
  8003ed:	44 89 ef             	mov    %r13d,%edi
  8003f0:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8003f7:	00 00 00 
  8003fa:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8003fc:	48 b8 11 04 80 00 00 	movabs $0x800411,%rax
  800403:	00 00 00 
  800406:	ff d0                	call   *%rax
#endif
}
  800408:	5b                   	pop    %rbx
  800409:	41 5c                	pop    %r12
  80040b:	41 5d                	pop    %r13
  80040d:	41 5e                	pop    %r14
  80040f:	5d                   	pop    %rbp
  800410:	c3                   	ret

0000000000800411 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800411:	f3 0f 1e fa          	endbr64
  800415:	55                   	push   %rbp
  800416:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800419:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  800420:	00 00 00 
  800423:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800425:	bf 00 00 00 00       	mov    $0x0,%edi
  80042a:	48 b8 a3 13 80 00 00 	movabs $0x8013a3,%rax
  800431:	00 00 00 
  800434:	ff d0                	call   *%rax
}
  800436:	5d                   	pop    %rbp
  800437:	c3                   	ret

0000000000800438 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800438:	f3 0f 1e fa          	endbr64
  80043c:	55                   	push   %rbp
  80043d:	48 89 e5             	mov    %rsp,%rbp
  800440:	41 56                	push   %r14
  800442:	41 55                	push   %r13
  800444:	41 54                	push   %r12
  800446:	53                   	push   %rbx
  800447:	48 83 ec 50          	sub    $0x50,%rsp
  80044b:	49 89 fc             	mov    %rdi,%r12
  80044e:	41 89 f5             	mov    %esi,%r13d
  800451:	48 89 d3             	mov    %rdx,%rbx
  800454:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800458:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80045c:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800460:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800467:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80046b:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80046f:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800473:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800477:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80047e:	00 00 00 
  800481:	4c 8b 30             	mov    (%rax),%r14
  800484:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  80048b:	00 00 00 
  80048e:	ff d0                	call   *%rax
  800490:	89 c6                	mov    %eax,%esi
  800492:	45 89 e8             	mov    %r13d,%r8d
  800495:	4c 89 e1             	mov    %r12,%rcx
  800498:	4c 89 f2             	mov    %r14,%rdx
  80049b:	48 bf d0 43 80 00 00 	movabs $0x8043d0,%rdi
  8004a2:	00 00 00 
  8004a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004aa:	49 bc 94 05 80 00 00 	movabs $0x800594,%r12
  8004b1:	00 00 00 
  8004b4:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8004b7:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8004bb:	48 89 df             	mov    %rbx,%rdi
  8004be:	48 b8 2c 05 80 00 00 	movabs $0x80052c,%rax
  8004c5:	00 00 00 
  8004c8:	ff d0                	call   *%rax
    cprintf("\n");
  8004ca:	48 bf 17 40 80 00 00 	movabs $0x804017,%rdi
  8004d1:	00 00 00 
  8004d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d9:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8004dc:	cc                   	int3
  8004dd:	eb fd                	jmp    8004dc <_panic+0xa4>

00000000008004df <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8004df:	f3 0f 1e fa          	endbr64
  8004e3:	55                   	push   %rbp
  8004e4:	48 89 e5             	mov    %rsp,%rbp
  8004e7:	53                   	push   %rbx
  8004e8:	48 83 ec 08          	sub    $0x8,%rsp
  8004ec:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8004ef:	8b 06                	mov    (%rsi),%eax
  8004f1:	8d 50 01             	lea    0x1(%rax),%edx
  8004f4:	89 16                	mov    %edx,(%rsi)
  8004f6:	48 98                	cltq
  8004f8:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8004fd:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800503:	74 0a                	je     80050f <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800505:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800509:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80050d:	c9                   	leave
  80050e:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80050f:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800513:	be ff 00 00 00       	mov    $0xff,%esi
  800518:	48 b8 3d 13 80 00 00 	movabs $0x80133d,%rax
  80051f:	00 00 00 
  800522:	ff d0                	call   *%rax
        state->offset = 0;
  800524:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80052a:	eb d9                	jmp    800505 <putch+0x26>

000000000080052c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80052c:	f3 0f 1e fa          	endbr64
  800530:	55                   	push   %rbp
  800531:	48 89 e5             	mov    %rsp,%rbp
  800534:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80053b:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80053e:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800545:	b9 21 00 00 00       	mov    $0x21,%ecx
  80054a:	b8 00 00 00 00       	mov    $0x0,%eax
  80054f:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800552:	48 89 f1             	mov    %rsi,%rcx
  800555:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80055c:	48 bf df 04 80 00 00 	movabs $0x8004df,%rdi
  800563:	00 00 00 
  800566:	48 b8 f4 06 80 00 00 	movabs $0x8006f4,%rax
  80056d:	00 00 00 
  800570:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800572:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800579:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800580:	48 b8 3d 13 80 00 00 	movabs $0x80133d,%rax
  800587:	00 00 00 
  80058a:	ff d0                	call   *%rax

    return state.count;
}
  80058c:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800592:	c9                   	leave
  800593:	c3                   	ret

0000000000800594 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800594:	f3 0f 1e fa          	endbr64
  800598:	55                   	push   %rbp
  800599:	48 89 e5             	mov    %rsp,%rbp
  80059c:	48 83 ec 50          	sub    $0x50,%rsp
  8005a0:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8005a4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8005a8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8005ac:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8005b0:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8005b4:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8005bb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005bf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005c3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8005c7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8005cb:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8005cf:	48 b8 2c 05 80 00 00 	movabs $0x80052c,%rax
  8005d6:	00 00 00 
  8005d9:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8005db:	c9                   	leave
  8005dc:	c3                   	ret

00000000008005dd <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8005dd:	f3 0f 1e fa          	endbr64
  8005e1:	55                   	push   %rbp
  8005e2:	48 89 e5             	mov    %rsp,%rbp
  8005e5:	41 57                	push   %r15
  8005e7:	41 56                	push   %r14
  8005e9:	41 55                	push   %r13
  8005eb:	41 54                	push   %r12
  8005ed:	53                   	push   %rbx
  8005ee:	48 83 ec 18          	sub    $0x18,%rsp
  8005f2:	49 89 fc             	mov    %rdi,%r12
  8005f5:	49 89 f5             	mov    %rsi,%r13
  8005f8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8005fc:	8b 45 10             	mov    0x10(%rbp),%eax
  8005ff:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800602:	41 89 cf             	mov    %ecx,%r15d
  800605:	4c 39 fa             	cmp    %r15,%rdx
  800608:	73 5b                	jae    800665 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80060a:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80060e:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800612:	85 db                	test   %ebx,%ebx
  800614:	7e 0e                	jle    800624 <print_num+0x47>
            putch(padc, put_arg);
  800616:	4c 89 ee             	mov    %r13,%rsi
  800619:	44 89 f7             	mov    %r14d,%edi
  80061c:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80061f:	83 eb 01             	sub    $0x1,%ebx
  800622:	75 f2                	jne    800616 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800624:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800628:	48 b9 cf 40 80 00 00 	movabs $0x8040cf,%rcx
  80062f:	00 00 00 
  800632:	48 b8 be 40 80 00 00 	movabs $0x8040be,%rax
  800639:	00 00 00 
  80063c:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800640:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800644:	ba 00 00 00 00       	mov    $0x0,%edx
  800649:	49 f7 f7             	div    %r15
  80064c:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800650:	4c 89 ee             	mov    %r13,%rsi
  800653:	41 ff d4             	call   *%r12
}
  800656:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80065a:	5b                   	pop    %rbx
  80065b:	41 5c                	pop    %r12
  80065d:	41 5d                	pop    %r13
  80065f:	41 5e                	pop    %r14
  800661:	41 5f                	pop    %r15
  800663:	5d                   	pop    %rbp
  800664:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800665:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800669:	ba 00 00 00 00       	mov    $0x0,%edx
  80066e:	49 f7 f7             	div    %r15
  800671:	48 83 ec 08          	sub    $0x8,%rsp
  800675:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800679:	52                   	push   %rdx
  80067a:	45 0f be c9          	movsbl %r9b,%r9d
  80067e:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800682:	48 89 c2             	mov    %rax,%rdx
  800685:	48 b8 dd 05 80 00 00 	movabs $0x8005dd,%rax
  80068c:	00 00 00 
  80068f:	ff d0                	call   *%rax
  800691:	48 83 c4 10          	add    $0x10,%rsp
  800695:	eb 8d                	jmp    800624 <print_num+0x47>

0000000000800697 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800697:	f3 0f 1e fa          	endbr64
    state->count++;
  80069b:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80069f:	48 8b 06             	mov    (%rsi),%rax
  8006a2:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8006a6:	73 0a                	jae    8006b2 <sprintputch+0x1b>
        *state->start++ = ch;
  8006a8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006ac:	48 89 16             	mov    %rdx,(%rsi)
  8006af:	40 88 38             	mov    %dil,(%rax)
    }
}
  8006b2:	c3                   	ret

00000000008006b3 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8006b3:	f3 0f 1e fa          	endbr64
  8006b7:	55                   	push   %rbp
  8006b8:	48 89 e5             	mov    %rsp,%rbp
  8006bb:	48 83 ec 50          	sub    $0x50,%rsp
  8006bf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8006c3:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8006c7:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8006cb:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8006d2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006d6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006da:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8006de:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8006e2:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8006e6:	48 b8 f4 06 80 00 00 	movabs $0x8006f4,%rax
  8006ed:	00 00 00 
  8006f0:	ff d0                	call   *%rax
}
  8006f2:	c9                   	leave
  8006f3:	c3                   	ret

00000000008006f4 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8006f4:	f3 0f 1e fa          	endbr64
  8006f8:	55                   	push   %rbp
  8006f9:	48 89 e5             	mov    %rsp,%rbp
  8006fc:	41 57                	push   %r15
  8006fe:	41 56                	push   %r14
  800700:	41 55                	push   %r13
  800702:	41 54                	push   %r12
  800704:	53                   	push   %rbx
  800705:	48 83 ec 38          	sub    $0x38,%rsp
  800709:	49 89 fe             	mov    %rdi,%r14
  80070c:	49 89 f5             	mov    %rsi,%r13
  80070f:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800712:	48 8b 01             	mov    (%rcx),%rax
  800715:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800719:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80071d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800721:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800725:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800729:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80072d:	0f b6 3b             	movzbl (%rbx),%edi
  800730:	40 80 ff 25          	cmp    $0x25,%dil
  800734:	74 18                	je     80074e <vprintfmt+0x5a>
            if (!ch) return;
  800736:	40 84 ff             	test   %dil,%dil
  800739:	0f 84 b2 06 00 00    	je     800df1 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80073f:	40 0f b6 ff          	movzbl %dil,%edi
  800743:	4c 89 ee             	mov    %r13,%rsi
  800746:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800749:	4c 89 e3             	mov    %r12,%rbx
  80074c:	eb db                	jmp    800729 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  80074e:	be 00 00 00 00       	mov    $0x0,%esi
  800753:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  800757:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  80075c:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800762:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800769:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80076d:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800772:	41 0f b6 04 24       	movzbl (%r12),%eax
  800777:	88 45 a0             	mov    %al,-0x60(%rbp)
  80077a:	83 e8 23             	sub    $0x23,%eax
  80077d:	3c 57                	cmp    $0x57,%al
  80077f:	0f 87 52 06 00 00    	ja     800dd7 <vprintfmt+0x6e3>
  800785:	0f b6 c0             	movzbl %al,%eax
  800788:	48 b9 e0 44 80 00 00 	movabs $0x8044e0,%rcx
  80078f:	00 00 00 
  800792:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800796:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800799:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  80079d:	eb ce                	jmp    80076d <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  80079f:	49 89 dc             	mov    %rbx,%r12
  8007a2:	be 01 00 00 00       	mov    $0x1,%esi
  8007a7:	eb c4                	jmp    80076d <vprintfmt+0x79>
            padc = ch;
  8007a9:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8007ad:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8007b0:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8007b3:	eb b8                	jmp    80076d <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8007b5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b8:	83 f8 2f             	cmp    $0x2f,%eax
  8007bb:	77 24                	ja     8007e1 <vprintfmt+0xed>
  8007bd:	89 c1                	mov    %eax,%ecx
  8007bf:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8007c3:	83 c0 08             	add    $0x8,%eax
  8007c6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007c9:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8007cc:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8007cf:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8007d3:	79 98                	jns    80076d <vprintfmt+0x79>
                width = precision;
  8007d5:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  8007d9:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8007df:	eb 8c                	jmp    80076d <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8007e1:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8007e5:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8007e9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007ed:	eb da                	jmp    8007c9 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  8007ef:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  8007f4:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8007f8:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  8007fe:	3c 39                	cmp    $0x39,%al
  800800:	77 1c                	ja     80081e <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800802:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800806:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80080a:	0f b6 c0             	movzbl %al,%eax
  80080d:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800812:	0f b6 03             	movzbl (%rbx),%eax
  800815:	3c 39                	cmp    $0x39,%al
  800817:	76 e9                	jbe    800802 <vprintfmt+0x10e>
        process_precision:
  800819:	49 89 dc             	mov    %rbx,%r12
  80081c:	eb b1                	jmp    8007cf <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80081e:	49 89 dc             	mov    %rbx,%r12
  800821:	eb ac                	jmp    8007cf <vprintfmt+0xdb>
            width = MAX(0, width);
  800823:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800826:	85 c9                	test   %ecx,%ecx
  800828:	b8 00 00 00 00       	mov    $0x0,%eax
  80082d:	0f 49 c1             	cmovns %ecx,%eax
  800830:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800833:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800836:	e9 32 ff ff ff       	jmp    80076d <vprintfmt+0x79>
            lflag++;
  80083b:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80083e:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800841:	e9 27 ff ff ff       	jmp    80076d <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800846:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800849:	83 f8 2f             	cmp    $0x2f,%eax
  80084c:	77 19                	ja     800867 <vprintfmt+0x173>
  80084e:	89 c2                	mov    %eax,%edx
  800850:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800854:	83 c0 08             	add    $0x8,%eax
  800857:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80085a:	8b 3a                	mov    (%rdx),%edi
  80085c:	4c 89 ee             	mov    %r13,%rsi
  80085f:	41 ff d6             	call   *%r14
            break;
  800862:	e9 c2 fe ff ff       	jmp    800729 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  800867:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80086b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80086f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800873:	eb e5                	jmp    80085a <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800875:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800878:	83 f8 2f             	cmp    $0x2f,%eax
  80087b:	77 5a                	ja     8008d7 <vprintfmt+0x1e3>
  80087d:	89 c2                	mov    %eax,%edx
  80087f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800883:	83 c0 08             	add    $0x8,%eax
  800886:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800889:	8b 02                	mov    (%rdx),%eax
  80088b:	89 c1                	mov    %eax,%ecx
  80088d:	f7 d9                	neg    %ecx
  80088f:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800892:	83 f9 13             	cmp    $0x13,%ecx
  800895:	7f 4e                	jg     8008e5 <vprintfmt+0x1f1>
  800897:	48 63 c1             	movslq %ecx,%rax
  80089a:	48 ba a0 47 80 00 00 	movabs $0x8047a0,%rdx
  8008a1:	00 00 00 
  8008a4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8008a8:	48 85 c0             	test   %rax,%rax
  8008ab:	74 38                	je     8008e5 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8008ad:	48 89 c1             	mov    %rax,%rcx
  8008b0:	48 ba fe 42 80 00 00 	movabs $0x8042fe,%rdx
  8008b7:	00 00 00 
  8008ba:	4c 89 ee             	mov    %r13,%rsi
  8008bd:	4c 89 f7             	mov    %r14,%rdi
  8008c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c5:	49 b8 b3 06 80 00 00 	movabs $0x8006b3,%r8
  8008cc:	00 00 00 
  8008cf:	41 ff d0             	call   *%r8
  8008d2:	e9 52 fe ff ff       	jmp    800729 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8008d7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008db:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008df:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008e3:	eb a4                	jmp    800889 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8008e5:	48 ba e7 40 80 00 00 	movabs $0x8040e7,%rdx
  8008ec:	00 00 00 
  8008ef:	4c 89 ee             	mov    %r13,%rsi
  8008f2:	4c 89 f7             	mov    %r14,%rdi
  8008f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fa:	49 b8 b3 06 80 00 00 	movabs $0x8006b3,%r8
  800901:	00 00 00 
  800904:	41 ff d0             	call   *%r8
  800907:	e9 1d fe ff ff       	jmp    800729 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80090c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090f:	83 f8 2f             	cmp    $0x2f,%eax
  800912:	77 6c                	ja     800980 <vprintfmt+0x28c>
  800914:	89 c2                	mov    %eax,%edx
  800916:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80091a:	83 c0 08             	add    $0x8,%eax
  80091d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800920:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800923:	48 85 d2             	test   %rdx,%rdx
  800926:	48 b8 e0 40 80 00 00 	movabs $0x8040e0,%rax
  80092d:	00 00 00 
  800930:	48 0f 45 c2          	cmovne %rdx,%rax
  800934:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800938:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80093c:	7e 06                	jle    800944 <vprintfmt+0x250>
  80093e:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800942:	75 4a                	jne    80098e <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800944:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800948:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80094c:	0f b6 00             	movzbl (%rax),%eax
  80094f:	84 c0                	test   %al,%al
  800951:	0f 85 9a 00 00 00    	jne    8009f1 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  800957:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80095a:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  80095e:	85 c0                	test   %eax,%eax
  800960:	0f 8e c3 fd ff ff    	jle    800729 <vprintfmt+0x35>
  800966:	4c 89 ee             	mov    %r13,%rsi
  800969:	bf 20 00 00 00       	mov    $0x20,%edi
  80096e:	41 ff d6             	call   *%r14
  800971:	41 83 ec 01          	sub    $0x1,%r12d
  800975:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800979:	75 eb                	jne    800966 <vprintfmt+0x272>
  80097b:	e9 a9 fd ff ff       	jmp    800729 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800980:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800984:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800988:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80098c:	eb 92                	jmp    800920 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  80098e:	49 63 f7             	movslq %r15d,%rsi
  800991:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800995:	48 b8 b7 0e 80 00 00 	movabs $0x800eb7,%rax
  80099c:	00 00 00 
  80099f:	ff d0                	call   *%rax
  8009a1:	48 89 c2             	mov    %rax,%rdx
  8009a4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8009a7:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8009a9:	8d 70 ff             	lea    -0x1(%rax),%esi
  8009ac:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8009af:	85 c0                	test   %eax,%eax
  8009b1:	7e 91                	jle    800944 <vprintfmt+0x250>
  8009b3:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  8009b8:	4c 89 ee             	mov    %r13,%rsi
  8009bb:	44 89 e7             	mov    %r12d,%edi
  8009be:	41 ff d6             	call   *%r14
  8009c1:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8009c5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8009c8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8009cb:	75 eb                	jne    8009b8 <vprintfmt+0x2c4>
  8009cd:	e9 72 ff ff ff       	jmp    800944 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8009d2:	0f b6 f8             	movzbl %al,%edi
  8009d5:	4c 89 ee             	mov    %r13,%rsi
  8009d8:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8009db:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8009df:	49 83 c4 01          	add    $0x1,%r12
  8009e3:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  8009e9:	84 c0                	test   %al,%al
  8009eb:	0f 84 66 ff ff ff    	je     800957 <vprintfmt+0x263>
  8009f1:	45 85 ff             	test   %r15d,%r15d
  8009f4:	78 0a                	js     800a00 <vprintfmt+0x30c>
  8009f6:	41 83 ef 01          	sub    $0x1,%r15d
  8009fa:	0f 88 57 ff ff ff    	js     800957 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800a00:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800a04:	74 cc                	je     8009d2 <vprintfmt+0x2de>
  800a06:	8d 50 e0             	lea    -0x20(%rax),%edx
  800a09:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a0e:	80 fa 5e             	cmp    $0x5e,%dl
  800a11:	77 c2                	ja     8009d5 <vprintfmt+0x2e1>
  800a13:	eb bd                	jmp    8009d2 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800a15:	40 84 f6             	test   %sil,%sil
  800a18:	75 26                	jne    800a40 <vprintfmt+0x34c>
    switch (lflag) {
  800a1a:	85 d2                	test   %edx,%edx
  800a1c:	74 59                	je     800a77 <vprintfmt+0x383>
  800a1e:	83 fa 01             	cmp    $0x1,%edx
  800a21:	74 7b                	je     800a9e <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800a23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a26:	83 f8 2f             	cmp    $0x2f,%eax
  800a29:	0f 87 96 00 00 00    	ja     800ac5 <vprintfmt+0x3d1>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a35:	83 c0 08             	add    $0x8,%eax
  800a38:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a3b:	4c 8b 22             	mov    (%rdx),%r12
  800a3e:	eb 17                	jmp    800a57 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800a40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a43:	83 f8 2f             	cmp    $0x2f,%eax
  800a46:	77 21                	ja     800a69 <vprintfmt+0x375>
  800a48:	89 c2                	mov    %eax,%edx
  800a4a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a4e:	83 c0 08             	add    $0x8,%eax
  800a51:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a54:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800a57:	4d 85 e4             	test   %r12,%r12
  800a5a:	78 7a                	js     800ad6 <vprintfmt+0x3e2>
            num = i;
  800a5c:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800a5f:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800a64:	e9 50 02 00 00       	jmp    800cb9 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a69:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a6d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a71:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a75:	eb dd                	jmp    800a54 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800a77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7a:	83 f8 2f             	cmp    $0x2f,%eax
  800a7d:	77 11                	ja     800a90 <vprintfmt+0x39c>
  800a7f:	89 c2                	mov    %eax,%edx
  800a81:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a85:	83 c0 08             	add    $0x8,%eax
  800a88:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a8b:	4c 63 22             	movslq (%rdx),%r12
  800a8e:	eb c7                	jmp    800a57 <vprintfmt+0x363>
  800a90:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a94:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a98:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a9c:	eb ed                	jmp    800a8b <vprintfmt+0x397>
        return va_arg(*ap, long);
  800a9e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa1:	83 f8 2f             	cmp    $0x2f,%eax
  800aa4:	77 11                	ja     800ab7 <vprintfmt+0x3c3>
  800aa6:	89 c2                	mov    %eax,%edx
  800aa8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aac:	83 c0 08             	add    $0x8,%eax
  800aaf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ab2:	4c 8b 22             	mov    (%rdx),%r12
  800ab5:	eb a0                	jmp    800a57 <vprintfmt+0x363>
  800ab7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800abb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800abf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac3:	eb ed                	jmp    800ab2 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800ac5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800acd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad1:	e9 65 ff ff ff       	jmp    800a3b <vprintfmt+0x347>
                putch('-', put_arg);
  800ad6:	4c 89 ee             	mov    %r13,%rsi
  800ad9:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ade:	41 ff d6             	call   *%r14
                i = -i;
  800ae1:	49 f7 dc             	neg    %r12
  800ae4:	e9 73 ff ff ff       	jmp    800a5c <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800ae9:	40 84 f6             	test   %sil,%sil
  800aec:	75 32                	jne    800b20 <vprintfmt+0x42c>
    switch (lflag) {
  800aee:	85 d2                	test   %edx,%edx
  800af0:	74 5d                	je     800b4f <vprintfmt+0x45b>
  800af2:	83 fa 01             	cmp    $0x1,%edx
  800af5:	0f 84 82 00 00 00    	je     800b7d <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800afb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afe:	83 f8 2f             	cmp    $0x2f,%eax
  800b01:	0f 87 a5 00 00 00    	ja     800bac <vprintfmt+0x4b8>
  800b07:	89 c2                	mov    %eax,%edx
  800b09:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b0d:	83 c0 08             	add    $0x8,%eax
  800b10:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b13:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b16:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800b1b:	e9 99 01 00 00       	jmp    800cb9 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b20:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b23:	83 f8 2f             	cmp    $0x2f,%eax
  800b26:	77 19                	ja     800b41 <vprintfmt+0x44d>
  800b28:	89 c2                	mov    %eax,%edx
  800b2a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b2e:	83 c0 08             	add    $0x8,%eax
  800b31:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b34:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b37:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b3c:	e9 78 01 00 00       	jmp    800cb9 <vprintfmt+0x5c5>
  800b41:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b45:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b49:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b4d:	eb e5                	jmp    800b34 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800b4f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b52:	83 f8 2f             	cmp    $0x2f,%eax
  800b55:	77 18                	ja     800b6f <vprintfmt+0x47b>
  800b57:	89 c2                	mov    %eax,%edx
  800b59:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b5d:	83 c0 08             	add    $0x8,%eax
  800b60:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b63:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800b65:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800b6a:	e9 4a 01 00 00       	jmp    800cb9 <vprintfmt+0x5c5>
  800b6f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b73:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b77:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b7b:	eb e6                	jmp    800b63 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800b7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b80:	83 f8 2f             	cmp    $0x2f,%eax
  800b83:	77 19                	ja     800b9e <vprintfmt+0x4aa>
  800b85:	89 c2                	mov    %eax,%edx
  800b87:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b8b:	83 c0 08             	add    $0x8,%eax
  800b8e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b91:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b94:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800b99:	e9 1b 01 00 00       	jmp    800cb9 <vprintfmt+0x5c5>
  800b9e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ba2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ba6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800baa:	eb e5                	jmp    800b91 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800bac:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bb4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bb8:	e9 56 ff ff ff       	jmp    800b13 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800bbd:	40 84 f6             	test   %sil,%sil
  800bc0:	75 2e                	jne    800bf0 <vprintfmt+0x4fc>
    switch (lflag) {
  800bc2:	85 d2                	test   %edx,%edx
  800bc4:	74 59                	je     800c1f <vprintfmt+0x52b>
  800bc6:	83 fa 01             	cmp    $0x1,%edx
  800bc9:	74 7f                	je     800c4a <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800bcb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bce:	83 f8 2f             	cmp    $0x2f,%eax
  800bd1:	0f 87 9f 00 00 00    	ja     800c76 <vprintfmt+0x582>
  800bd7:	89 c2                	mov    %eax,%edx
  800bd9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bdd:	83 c0 08             	add    $0x8,%eax
  800be0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800be3:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800be6:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800beb:	e9 c9 00 00 00       	jmp    800cb9 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800bf0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf3:	83 f8 2f             	cmp    $0x2f,%eax
  800bf6:	77 19                	ja     800c11 <vprintfmt+0x51d>
  800bf8:	89 c2                	mov    %eax,%edx
  800bfa:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bfe:	83 c0 08             	add    $0x8,%eax
  800c01:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c04:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800c07:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c0c:	e9 a8 00 00 00       	jmp    800cb9 <vprintfmt+0x5c5>
  800c11:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c15:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c19:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c1d:	eb e5                	jmp    800c04 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800c1f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c22:	83 f8 2f             	cmp    $0x2f,%eax
  800c25:	77 15                	ja     800c3c <vprintfmt+0x548>
  800c27:	89 c2                	mov    %eax,%edx
  800c29:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c2d:	83 c0 08             	add    $0x8,%eax
  800c30:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c33:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800c35:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800c3a:	eb 7d                	jmp    800cb9 <vprintfmt+0x5c5>
  800c3c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c40:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c44:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c48:	eb e9                	jmp    800c33 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800c4a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4d:	83 f8 2f             	cmp    $0x2f,%eax
  800c50:	77 16                	ja     800c68 <vprintfmt+0x574>
  800c52:	89 c2                	mov    %eax,%edx
  800c54:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c58:	83 c0 08             	add    $0x8,%eax
  800c5b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c5e:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800c61:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800c66:	eb 51                	jmp    800cb9 <vprintfmt+0x5c5>
  800c68:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c6c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c70:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c74:	eb e8                	jmp    800c5e <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800c76:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c7a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c7e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c82:	e9 5c ff ff ff       	jmp    800be3 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800c87:	4c 89 ee             	mov    %r13,%rsi
  800c8a:	bf 30 00 00 00       	mov    $0x30,%edi
  800c8f:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800c92:	4c 89 ee             	mov    %r13,%rsi
  800c95:	bf 78 00 00 00       	mov    $0x78,%edi
  800c9a:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800c9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca0:	83 f8 2f             	cmp    $0x2f,%eax
  800ca3:	77 47                	ja     800cec <vprintfmt+0x5f8>
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cab:	83 c0 08             	add    $0x8,%eax
  800cae:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cb1:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800cb4:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800cb9:	48 83 ec 08          	sub    $0x8,%rsp
  800cbd:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800cc1:	0f 94 c0             	sete   %al
  800cc4:	0f b6 c0             	movzbl %al,%eax
  800cc7:	50                   	push   %rax
  800cc8:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800ccd:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800cd1:	4c 89 ee             	mov    %r13,%rsi
  800cd4:	4c 89 f7             	mov    %r14,%rdi
  800cd7:	48 b8 dd 05 80 00 00 	movabs $0x8005dd,%rax
  800cde:	00 00 00 
  800ce1:	ff d0                	call   *%rax
            break;
  800ce3:	48 83 c4 10          	add    $0x10,%rsp
  800ce7:	e9 3d fa ff ff       	jmp    800729 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800cec:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cf0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cf4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cf8:	eb b7                	jmp    800cb1 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800cfa:	40 84 f6             	test   %sil,%sil
  800cfd:	75 2b                	jne    800d2a <vprintfmt+0x636>
    switch (lflag) {
  800cff:	85 d2                	test   %edx,%edx
  800d01:	74 56                	je     800d59 <vprintfmt+0x665>
  800d03:	83 fa 01             	cmp    $0x1,%edx
  800d06:	74 7f                	je     800d87 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800d08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d0b:	83 f8 2f             	cmp    $0x2f,%eax
  800d0e:	0f 87 a2 00 00 00    	ja     800db6 <vprintfmt+0x6c2>
  800d14:	89 c2                	mov    %eax,%edx
  800d16:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d1a:	83 c0 08             	add    $0x8,%eax
  800d1d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d20:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d23:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800d28:	eb 8f                	jmp    800cb9 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800d2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2d:	83 f8 2f             	cmp    $0x2f,%eax
  800d30:	77 19                	ja     800d4b <vprintfmt+0x657>
  800d32:	89 c2                	mov    %eax,%edx
  800d34:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d38:	83 c0 08             	add    $0x8,%eax
  800d3b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d3e:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d41:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800d46:	e9 6e ff ff ff       	jmp    800cb9 <vprintfmt+0x5c5>
  800d4b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d4f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d53:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d57:	eb e5                	jmp    800d3e <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800d59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d5c:	83 f8 2f             	cmp    $0x2f,%eax
  800d5f:	77 18                	ja     800d79 <vprintfmt+0x685>
  800d61:	89 c2                	mov    %eax,%edx
  800d63:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d67:	83 c0 08             	add    $0x8,%eax
  800d6a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d6d:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800d6f:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800d74:	e9 40 ff ff ff       	jmp    800cb9 <vprintfmt+0x5c5>
  800d79:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d7d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d81:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d85:	eb e6                	jmp    800d6d <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800d87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8a:	83 f8 2f             	cmp    $0x2f,%eax
  800d8d:	77 19                	ja     800da8 <vprintfmt+0x6b4>
  800d8f:	89 c2                	mov    %eax,%edx
  800d91:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d95:	83 c0 08             	add    $0x8,%eax
  800d98:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d9b:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d9e:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800da3:	e9 11 ff ff ff       	jmp    800cb9 <vprintfmt+0x5c5>
  800da8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dac:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800db0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800db4:	eb e5                	jmp    800d9b <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800db6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dba:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800dbe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dc2:	e9 59 ff ff ff       	jmp    800d20 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800dc7:	4c 89 ee             	mov    %r13,%rsi
  800dca:	bf 25 00 00 00       	mov    $0x25,%edi
  800dcf:	41 ff d6             	call   *%r14
            break;
  800dd2:	e9 52 f9 ff ff       	jmp    800729 <vprintfmt+0x35>
            putch('%', put_arg);
  800dd7:	4c 89 ee             	mov    %r13,%rsi
  800dda:	bf 25 00 00 00       	mov    $0x25,%edi
  800ddf:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800de2:	48 83 eb 01          	sub    $0x1,%rbx
  800de6:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800dea:	75 f6                	jne    800de2 <vprintfmt+0x6ee>
  800dec:	e9 38 f9 ff ff       	jmp    800729 <vprintfmt+0x35>
}
  800df1:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800df5:	5b                   	pop    %rbx
  800df6:	41 5c                	pop    %r12
  800df8:	41 5d                	pop    %r13
  800dfa:	41 5e                	pop    %r14
  800dfc:	41 5f                	pop    %r15
  800dfe:	5d                   	pop    %rbp
  800dff:	c3                   	ret

0000000000800e00 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800e00:	f3 0f 1e fa          	endbr64
  800e04:	55                   	push   %rbp
  800e05:	48 89 e5             	mov    %rsp,%rbp
  800e08:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800e0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e10:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800e15:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800e19:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800e20:	48 85 ff             	test   %rdi,%rdi
  800e23:	74 2b                	je     800e50 <vsnprintf+0x50>
  800e25:	48 85 f6             	test   %rsi,%rsi
  800e28:	74 26                	je     800e50 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800e2a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800e2e:	48 bf 97 06 80 00 00 	movabs $0x800697,%rdi
  800e35:	00 00 00 
  800e38:	48 b8 f4 06 80 00 00 	movabs $0x8006f4,%rax
  800e3f:	00 00 00 
  800e42:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800e44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e48:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800e4b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800e4e:	c9                   	leave
  800e4f:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800e50:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e55:	eb f7                	jmp    800e4e <vsnprintf+0x4e>

0000000000800e57 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800e57:	f3 0f 1e fa          	endbr64
  800e5b:	55                   	push   %rbp
  800e5c:	48 89 e5             	mov    %rsp,%rbp
  800e5f:	48 83 ec 50          	sub    $0x50,%rsp
  800e63:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800e67:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800e6b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800e6f:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800e76:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e7a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e7e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e82:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800e86:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800e8a:	48 b8 00 0e 80 00 00 	movabs $0x800e00,%rax
  800e91:	00 00 00 
  800e94:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800e96:	c9                   	leave
  800e97:	c3                   	ret

0000000000800e98 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800e98:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800e9c:	80 3f 00             	cmpb   $0x0,(%rdi)
  800e9f:	74 10                	je     800eb1 <strlen+0x19>
    size_t n = 0;
  800ea1:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800ea6:	48 83 c0 01          	add    $0x1,%rax
  800eaa:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800eae:	75 f6                	jne    800ea6 <strlen+0xe>
  800eb0:	c3                   	ret
    size_t n = 0;
  800eb1:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800eb6:	c3                   	ret

0000000000800eb7 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800eb7:	f3 0f 1e fa          	endbr64
  800ebb:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800ebe:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800ec3:	48 85 f6             	test   %rsi,%rsi
  800ec6:	74 10                	je     800ed8 <strnlen+0x21>
  800ec8:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800ecc:	74 0b                	je     800ed9 <strnlen+0x22>
  800ece:	48 83 c2 01          	add    $0x1,%rdx
  800ed2:	48 39 d0             	cmp    %rdx,%rax
  800ed5:	75 f1                	jne    800ec8 <strnlen+0x11>
  800ed7:	c3                   	ret
  800ed8:	c3                   	ret
  800ed9:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800edc:	c3                   	ret

0000000000800edd <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800edd:	f3 0f 1e fa          	endbr64
  800ee1:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800ee4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee9:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800eed:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800ef0:	48 83 c2 01          	add    $0x1,%rdx
  800ef4:	84 c9                	test   %cl,%cl
  800ef6:	75 f1                	jne    800ee9 <strcpy+0xc>
        ;
    return res;
}
  800ef8:	c3                   	ret

0000000000800ef9 <strcat>:

char *
strcat(char *dst, const char *src) {
  800ef9:	f3 0f 1e fa          	endbr64
  800efd:	55                   	push   %rbp
  800efe:	48 89 e5             	mov    %rsp,%rbp
  800f01:	41 54                	push   %r12
  800f03:	53                   	push   %rbx
  800f04:	48 89 fb             	mov    %rdi,%rbx
  800f07:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800f0a:	48 b8 98 0e 80 00 00 	movabs $0x800e98,%rax
  800f11:	00 00 00 
  800f14:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800f16:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800f1a:	4c 89 e6             	mov    %r12,%rsi
  800f1d:	48 b8 dd 0e 80 00 00 	movabs $0x800edd,%rax
  800f24:	00 00 00 
  800f27:	ff d0                	call   *%rax
    return dst;
}
  800f29:	48 89 d8             	mov    %rbx,%rax
  800f2c:	5b                   	pop    %rbx
  800f2d:	41 5c                	pop    %r12
  800f2f:	5d                   	pop    %rbp
  800f30:	c3                   	ret

0000000000800f31 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f31:	f3 0f 1e fa          	endbr64
  800f35:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800f38:	48 85 d2             	test   %rdx,%rdx
  800f3b:	74 1f                	je     800f5c <strncpy+0x2b>
  800f3d:	48 01 fa             	add    %rdi,%rdx
  800f40:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800f43:	48 83 c1 01          	add    $0x1,%rcx
  800f47:	44 0f b6 06          	movzbl (%rsi),%r8d
  800f4b:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800f4f:	41 80 f8 01          	cmp    $0x1,%r8b
  800f53:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800f57:	48 39 ca             	cmp    %rcx,%rdx
  800f5a:	75 e7                	jne    800f43 <strncpy+0x12>
    }
    return ret;
}
  800f5c:	c3                   	ret

0000000000800f5d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800f5d:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800f61:	48 89 f8             	mov    %rdi,%rax
  800f64:	48 85 d2             	test   %rdx,%rdx
  800f67:	74 24                	je     800f8d <strlcpy+0x30>
        while (--size > 0 && *src)
  800f69:	48 83 ea 01          	sub    $0x1,%rdx
  800f6d:	74 1b                	je     800f8a <strlcpy+0x2d>
  800f6f:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800f73:	0f b6 16             	movzbl (%rsi),%edx
  800f76:	84 d2                	test   %dl,%dl
  800f78:	74 10                	je     800f8a <strlcpy+0x2d>
            *dst++ = *src++;
  800f7a:	48 83 c6 01          	add    $0x1,%rsi
  800f7e:	48 83 c0 01          	add    $0x1,%rax
  800f82:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800f85:	48 39 c8             	cmp    %rcx,%rax
  800f88:	75 e9                	jne    800f73 <strlcpy+0x16>
        *dst = '\0';
  800f8a:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800f8d:	48 29 f8             	sub    %rdi,%rax
}
  800f90:	c3                   	ret

0000000000800f91 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800f91:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800f95:	0f b6 07             	movzbl (%rdi),%eax
  800f98:	84 c0                	test   %al,%al
  800f9a:	74 13                	je     800faf <strcmp+0x1e>
  800f9c:	38 06                	cmp    %al,(%rsi)
  800f9e:	75 0f                	jne    800faf <strcmp+0x1e>
  800fa0:	48 83 c7 01          	add    $0x1,%rdi
  800fa4:	48 83 c6 01          	add    $0x1,%rsi
  800fa8:	0f b6 07             	movzbl (%rdi),%eax
  800fab:	84 c0                	test   %al,%al
  800fad:	75 ed                	jne    800f9c <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800faf:	0f b6 c0             	movzbl %al,%eax
  800fb2:	0f b6 16             	movzbl (%rsi),%edx
  800fb5:	29 d0                	sub    %edx,%eax
}
  800fb7:	c3                   	ret

0000000000800fb8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800fb8:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800fbc:	48 85 d2             	test   %rdx,%rdx
  800fbf:	74 1f                	je     800fe0 <strncmp+0x28>
  800fc1:	0f b6 07             	movzbl (%rdi),%eax
  800fc4:	84 c0                	test   %al,%al
  800fc6:	74 1e                	je     800fe6 <strncmp+0x2e>
  800fc8:	3a 06                	cmp    (%rsi),%al
  800fca:	75 1a                	jne    800fe6 <strncmp+0x2e>
  800fcc:	48 83 c7 01          	add    $0x1,%rdi
  800fd0:	48 83 c6 01          	add    $0x1,%rsi
  800fd4:	48 83 ea 01          	sub    $0x1,%rdx
  800fd8:	75 e7                	jne    800fc1 <strncmp+0x9>

    if (!n) return 0;
  800fda:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdf:	c3                   	ret
  800fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe5:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800fe6:	0f b6 07             	movzbl (%rdi),%eax
  800fe9:	0f b6 16             	movzbl (%rsi),%edx
  800fec:	29 d0                	sub    %edx,%eax
}
  800fee:	c3                   	ret

0000000000800fef <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800fef:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800ff3:	0f b6 17             	movzbl (%rdi),%edx
  800ff6:	84 d2                	test   %dl,%dl
  800ff8:	74 18                	je     801012 <strchr+0x23>
        if (*str == c) {
  800ffa:	0f be d2             	movsbl %dl,%edx
  800ffd:	39 f2                	cmp    %esi,%edx
  800fff:	74 17                	je     801018 <strchr+0x29>
    for (; *str; str++) {
  801001:	48 83 c7 01          	add    $0x1,%rdi
  801005:	0f b6 17             	movzbl (%rdi),%edx
  801008:	84 d2                	test   %dl,%dl
  80100a:	75 ee                	jne    800ffa <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  80100c:	b8 00 00 00 00       	mov    $0x0,%eax
  801011:	c3                   	ret
  801012:	b8 00 00 00 00       	mov    $0x0,%eax
  801017:	c3                   	ret
            return (char *)str;
  801018:	48 89 f8             	mov    %rdi,%rax
}
  80101b:	c3                   	ret

000000000080101c <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  80101c:	f3 0f 1e fa          	endbr64
  801020:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  801023:	0f b6 17             	movzbl (%rdi),%edx
  801026:	84 d2                	test   %dl,%dl
  801028:	74 13                	je     80103d <strfind+0x21>
  80102a:	0f be d2             	movsbl %dl,%edx
  80102d:	39 f2                	cmp    %esi,%edx
  80102f:	74 0b                	je     80103c <strfind+0x20>
  801031:	48 83 c0 01          	add    $0x1,%rax
  801035:	0f b6 10             	movzbl (%rax),%edx
  801038:	84 d2                	test   %dl,%dl
  80103a:	75 ee                	jne    80102a <strfind+0xe>
        ;
    return (char *)str;
}
  80103c:	c3                   	ret
  80103d:	c3                   	ret

000000000080103e <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80103e:	f3 0f 1e fa          	endbr64
  801042:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  801045:	48 89 f8             	mov    %rdi,%rax
  801048:	48 f7 d8             	neg    %rax
  80104b:	83 e0 07             	and    $0x7,%eax
  80104e:	49 89 d1             	mov    %rdx,%r9
  801051:	49 29 c1             	sub    %rax,%r9
  801054:	78 36                	js     80108c <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  801056:	40 0f b6 c6          	movzbl %sil,%eax
  80105a:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  801061:	01 01 01 
  801064:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  801068:	40 f6 c7 07          	test   $0x7,%dil
  80106c:	75 38                	jne    8010a6 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80106e:	4c 89 c9             	mov    %r9,%rcx
  801071:	48 c1 f9 03          	sar    $0x3,%rcx
  801075:	74 0c                	je     801083 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  801077:	fc                   	cld
  801078:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  80107b:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  80107f:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801083:	4d 85 c9             	test   %r9,%r9
  801086:	75 45                	jne    8010cd <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  801088:	4c 89 c0             	mov    %r8,%rax
  80108b:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  80108c:	48 85 d2             	test   %rdx,%rdx
  80108f:	74 f7                	je     801088 <memset+0x4a>
  801091:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801094:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  801097:	48 83 c0 01          	add    $0x1,%rax
  80109b:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  80109f:	48 39 c2             	cmp    %rax,%rdx
  8010a2:	75 f3                	jne    801097 <memset+0x59>
  8010a4:	eb e2                	jmp    801088 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8010a6:	40 f6 c7 01          	test   $0x1,%dil
  8010aa:	74 06                	je     8010b2 <memset+0x74>
  8010ac:	88 07                	mov    %al,(%rdi)
  8010ae:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8010b2:	40 f6 c7 02          	test   $0x2,%dil
  8010b6:	74 07                	je     8010bf <memset+0x81>
  8010b8:	66 89 07             	mov    %ax,(%rdi)
  8010bb:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8010bf:	40 f6 c7 04          	test   $0x4,%dil
  8010c3:	74 a9                	je     80106e <memset+0x30>
  8010c5:	89 07                	mov    %eax,(%rdi)
  8010c7:	48 83 c7 04          	add    $0x4,%rdi
  8010cb:	eb a1                	jmp    80106e <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8010cd:	41 f6 c1 04          	test   $0x4,%r9b
  8010d1:	74 1b                	je     8010ee <memset+0xb0>
  8010d3:	89 07                	mov    %eax,(%rdi)
  8010d5:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8010d9:	41 f6 c1 02          	test   $0x2,%r9b
  8010dd:	74 07                	je     8010e6 <memset+0xa8>
  8010df:	66 89 07             	mov    %ax,(%rdi)
  8010e2:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8010e6:	41 f6 c1 01          	test   $0x1,%r9b
  8010ea:	74 9c                	je     801088 <memset+0x4a>
  8010ec:	eb 06                	jmp    8010f4 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8010ee:	41 f6 c1 02          	test   $0x2,%r9b
  8010f2:	75 eb                	jne    8010df <memset+0xa1>
        if (ni & 1) *ptr = k;
  8010f4:	88 07                	mov    %al,(%rdi)
  8010f6:	eb 90                	jmp    801088 <memset+0x4a>

00000000008010f8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8010f8:	f3 0f 1e fa          	endbr64
  8010fc:	48 89 f8             	mov    %rdi,%rax
  8010ff:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801102:	48 39 fe             	cmp    %rdi,%rsi
  801105:	73 3b                	jae    801142 <memmove+0x4a>
  801107:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  80110b:	48 39 d7             	cmp    %rdx,%rdi
  80110e:	73 32                	jae    801142 <memmove+0x4a>
        s += n;
        d += n;
  801110:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801114:	48 89 d6             	mov    %rdx,%rsi
  801117:	48 09 fe             	or     %rdi,%rsi
  80111a:	48 09 ce             	or     %rcx,%rsi
  80111d:	40 f6 c6 07          	test   $0x7,%sil
  801121:	75 12                	jne    801135 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801123:	48 83 ef 08          	sub    $0x8,%rdi
  801127:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  80112b:	48 c1 e9 03          	shr    $0x3,%rcx
  80112f:	fd                   	std
  801130:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801133:	fc                   	cld
  801134:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  801135:	48 83 ef 01          	sub    $0x1,%rdi
  801139:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  80113d:	fd                   	std
  80113e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801140:	eb f1                	jmp    801133 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801142:	48 89 f2             	mov    %rsi,%rdx
  801145:	48 09 c2             	or     %rax,%rdx
  801148:	48 09 ca             	or     %rcx,%rdx
  80114b:	f6 c2 07             	test   $0x7,%dl
  80114e:	75 0c                	jne    80115c <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801150:	48 c1 e9 03          	shr    $0x3,%rcx
  801154:	48 89 c7             	mov    %rax,%rdi
  801157:	fc                   	cld
  801158:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80115b:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80115c:	48 89 c7             	mov    %rax,%rdi
  80115f:	fc                   	cld
  801160:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801162:	c3                   	ret

0000000000801163 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801163:	f3 0f 1e fa          	endbr64
  801167:	55                   	push   %rbp
  801168:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80116b:	48 b8 f8 10 80 00 00 	movabs $0x8010f8,%rax
  801172:	00 00 00 
  801175:	ff d0                	call   *%rax
}
  801177:	5d                   	pop    %rbp
  801178:	c3                   	ret

0000000000801179 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  801179:	f3 0f 1e fa          	endbr64
  80117d:	55                   	push   %rbp
  80117e:	48 89 e5             	mov    %rsp,%rbp
  801181:	41 57                	push   %r15
  801183:	41 56                	push   %r14
  801185:	41 55                	push   %r13
  801187:	41 54                	push   %r12
  801189:	53                   	push   %rbx
  80118a:	48 83 ec 08          	sub    $0x8,%rsp
  80118e:	49 89 fe             	mov    %rdi,%r14
  801191:	49 89 f7             	mov    %rsi,%r15
  801194:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801197:	48 89 f7             	mov    %rsi,%rdi
  80119a:	48 b8 98 0e 80 00 00 	movabs $0x800e98,%rax
  8011a1:	00 00 00 
  8011a4:	ff d0                	call   *%rax
  8011a6:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8011a9:	48 89 de             	mov    %rbx,%rsi
  8011ac:	4c 89 f7             	mov    %r14,%rdi
  8011af:	48 b8 b7 0e 80 00 00 	movabs $0x800eb7,%rax
  8011b6:	00 00 00 
  8011b9:	ff d0                	call   *%rax
  8011bb:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8011be:	48 39 c3             	cmp    %rax,%rbx
  8011c1:	74 36                	je     8011f9 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  8011c3:	48 89 d8             	mov    %rbx,%rax
  8011c6:	4c 29 e8             	sub    %r13,%rax
  8011c9:	49 39 c4             	cmp    %rax,%r12
  8011cc:	73 31                	jae    8011ff <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  8011ce:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8011d3:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8011d7:	4c 89 fe             	mov    %r15,%rsi
  8011da:	48 b8 63 11 80 00 00 	movabs $0x801163,%rax
  8011e1:	00 00 00 
  8011e4:	ff d0                	call   *%rax
    return dstlen + srclen;
  8011e6:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8011ea:	48 83 c4 08          	add    $0x8,%rsp
  8011ee:	5b                   	pop    %rbx
  8011ef:	41 5c                	pop    %r12
  8011f1:	41 5d                	pop    %r13
  8011f3:	41 5e                	pop    %r14
  8011f5:	41 5f                	pop    %r15
  8011f7:	5d                   	pop    %rbp
  8011f8:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  8011f9:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  8011fd:	eb eb                	jmp    8011ea <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  8011ff:	48 83 eb 01          	sub    $0x1,%rbx
  801203:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801207:	48 89 da             	mov    %rbx,%rdx
  80120a:	4c 89 fe             	mov    %r15,%rsi
  80120d:	48 b8 63 11 80 00 00 	movabs $0x801163,%rax
  801214:	00 00 00 
  801217:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801219:	49 01 de             	add    %rbx,%r14
  80121c:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801221:	eb c3                	jmp    8011e6 <strlcat+0x6d>

0000000000801223 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801223:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801227:	48 85 d2             	test   %rdx,%rdx
  80122a:	74 2d                	je     801259 <memcmp+0x36>
  80122c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801231:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801235:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  80123a:	44 38 c1             	cmp    %r8b,%cl
  80123d:	75 0f                	jne    80124e <memcmp+0x2b>
    while (n-- > 0) {
  80123f:	48 83 c0 01          	add    $0x1,%rax
  801243:	48 39 c2             	cmp    %rax,%rdx
  801246:	75 e9                	jne    801231 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801248:	b8 00 00 00 00       	mov    $0x0,%eax
  80124d:	c3                   	ret
            return (int)*s1 - (int)*s2;
  80124e:	0f b6 c1             	movzbl %cl,%eax
  801251:	45 0f b6 c0          	movzbl %r8b,%r8d
  801255:	44 29 c0             	sub    %r8d,%eax
  801258:	c3                   	ret
    return 0;
  801259:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80125e:	c3                   	ret

000000000080125f <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  80125f:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  801263:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801267:	48 39 c7             	cmp    %rax,%rdi
  80126a:	73 0f                	jae    80127b <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  80126c:	40 38 37             	cmp    %sil,(%rdi)
  80126f:	74 0e                	je     80127f <memfind+0x20>
    for (; src < end; src++) {
  801271:	48 83 c7 01          	add    $0x1,%rdi
  801275:	48 39 f8             	cmp    %rdi,%rax
  801278:	75 f2                	jne    80126c <memfind+0xd>
  80127a:	c3                   	ret
  80127b:	48 89 f8             	mov    %rdi,%rax
  80127e:	c3                   	ret
  80127f:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801282:	c3                   	ret

0000000000801283 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801283:	f3 0f 1e fa          	endbr64
  801287:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80128a:	0f b6 37             	movzbl (%rdi),%esi
  80128d:	40 80 fe 20          	cmp    $0x20,%sil
  801291:	74 06                	je     801299 <strtol+0x16>
  801293:	40 80 fe 09          	cmp    $0x9,%sil
  801297:	75 13                	jne    8012ac <strtol+0x29>
  801299:	48 83 c7 01          	add    $0x1,%rdi
  80129d:	0f b6 37             	movzbl (%rdi),%esi
  8012a0:	40 80 fe 20          	cmp    $0x20,%sil
  8012a4:	74 f3                	je     801299 <strtol+0x16>
  8012a6:	40 80 fe 09          	cmp    $0x9,%sil
  8012aa:	74 ed                	je     801299 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8012ac:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8012af:	83 e0 fd             	and    $0xfffffffd,%eax
  8012b2:	3c 01                	cmp    $0x1,%al
  8012b4:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8012b8:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  8012be:	75 0f                	jne    8012cf <strtol+0x4c>
  8012c0:	80 3f 30             	cmpb   $0x30,(%rdi)
  8012c3:	74 14                	je     8012d9 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8012c5:	85 d2                	test   %edx,%edx
  8012c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012cc:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  8012cf:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8012d4:	4c 63 ca             	movslq %edx,%r9
  8012d7:	eb 36                	jmp    80130f <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8012d9:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8012dd:	74 0f                	je     8012ee <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  8012df:	85 d2                	test   %edx,%edx
  8012e1:	75 ec                	jne    8012cf <strtol+0x4c>
        s++;
  8012e3:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8012e7:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  8012ec:	eb e1                	jmp    8012cf <strtol+0x4c>
        s += 2;
  8012ee:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8012f2:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  8012f7:	eb d6                	jmp    8012cf <strtol+0x4c>
            dig -= '0';
  8012f9:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  8012fc:	44 0f b6 c1          	movzbl %cl,%r8d
  801300:	41 39 d0             	cmp    %edx,%r8d
  801303:	7d 21                	jge    801326 <strtol+0xa3>
        val = val * base + dig;
  801305:	49 0f af c1          	imul   %r9,%rax
  801309:	0f b6 c9             	movzbl %cl,%ecx
  80130c:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  80130f:	48 83 c7 01          	add    $0x1,%rdi
  801313:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801317:	80 f9 39             	cmp    $0x39,%cl
  80131a:	76 dd                	jbe    8012f9 <strtol+0x76>
        else if (dig - 'a' < 27)
  80131c:	80 f9 7b             	cmp    $0x7b,%cl
  80131f:	77 05                	ja     801326 <strtol+0xa3>
            dig -= 'a' - 10;
  801321:	83 e9 57             	sub    $0x57,%ecx
  801324:	eb d6                	jmp    8012fc <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801326:	4d 85 d2             	test   %r10,%r10
  801329:	74 03                	je     80132e <strtol+0xab>
  80132b:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80132e:	48 89 c2             	mov    %rax,%rdx
  801331:	48 f7 da             	neg    %rdx
  801334:	40 80 fe 2d          	cmp    $0x2d,%sil
  801338:	48 0f 44 c2          	cmove  %rdx,%rax
}
  80133c:	c3                   	ret

000000000080133d <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80133d:	f3 0f 1e fa          	endbr64
  801341:	55                   	push   %rbp
  801342:	48 89 e5             	mov    %rsp,%rbp
  801345:	53                   	push   %rbx
  801346:	48 89 fa             	mov    %rdi,%rdx
  801349:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80134c:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801351:	bb 00 00 00 00       	mov    $0x0,%ebx
  801356:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80135b:	be 00 00 00 00       	mov    $0x0,%esi
  801360:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801366:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801368:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80136c:	c9                   	leave
  80136d:	c3                   	ret

000000000080136e <sys_cgetc>:

int
sys_cgetc(void) {
  80136e:	f3 0f 1e fa          	endbr64
  801372:	55                   	push   %rbp
  801373:	48 89 e5             	mov    %rsp,%rbp
  801376:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801377:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80137c:	ba 00 00 00 00       	mov    $0x0,%edx
  801381:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801386:	bb 00 00 00 00       	mov    $0x0,%ebx
  80138b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801390:	be 00 00 00 00       	mov    $0x0,%esi
  801395:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80139b:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80139d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013a1:	c9                   	leave
  8013a2:	c3                   	ret

00000000008013a3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8013a3:	f3 0f 1e fa          	endbr64
  8013a7:	55                   	push   %rbp
  8013a8:	48 89 e5             	mov    %rsp,%rbp
  8013ab:	53                   	push   %rbx
  8013ac:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8013b0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013b3:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013b8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013c7:	be 00 00 00 00       	mov    $0x0,%esi
  8013cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013d2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013d4:	48 85 c0             	test   %rax,%rax
  8013d7:	7f 06                	jg     8013df <sys_env_destroy+0x3c>
}
  8013d9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013dd:	c9                   	leave
  8013de:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013df:	49 89 c0             	mov    %rax,%r8
  8013e2:	b9 03 00 00 00       	mov    $0x3,%ecx
  8013e7:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  8013ee:	00 00 00 
  8013f1:	be 26 00 00 00       	mov    $0x26,%esi
  8013f6:	48 bf 4d 42 80 00 00 	movabs $0x80424d,%rdi
  8013fd:	00 00 00 
  801400:	b8 00 00 00 00       	mov    $0x0,%eax
  801405:	49 b9 38 04 80 00 00 	movabs $0x800438,%r9
  80140c:	00 00 00 
  80140f:	41 ff d1             	call   *%r9

0000000000801412 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801412:	f3 0f 1e fa          	endbr64
  801416:	55                   	push   %rbp
  801417:	48 89 e5             	mov    %rsp,%rbp
  80141a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80141b:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801420:	ba 00 00 00 00       	mov    $0x0,%edx
  801425:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80142a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801434:	be 00 00 00 00       	mov    $0x0,%esi
  801439:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80143f:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801441:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801445:	c9                   	leave
  801446:	c3                   	ret

0000000000801447 <sys_yield>:

void
sys_yield(void) {
  801447:	f3 0f 1e fa          	endbr64
  80144b:	55                   	push   %rbp
  80144c:	48 89 e5             	mov    %rsp,%rbp
  80144f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801450:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801455:	ba 00 00 00 00       	mov    $0x0,%edx
  80145a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80145f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801464:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801469:	be 00 00 00 00       	mov    $0x0,%esi
  80146e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801474:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801476:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80147a:	c9                   	leave
  80147b:	c3                   	ret

000000000080147c <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80147c:	f3 0f 1e fa          	endbr64
  801480:	55                   	push   %rbp
  801481:	48 89 e5             	mov    %rsp,%rbp
  801484:	53                   	push   %rbx
  801485:	48 89 fa             	mov    %rdi,%rdx
  801488:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80148b:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801490:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801497:	00 00 00 
  80149a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80149f:	be 00 00 00 00       	mov    $0x0,%esi
  8014a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014aa:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8014ac:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014b0:	c9                   	leave
  8014b1:	c3                   	ret

00000000008014b2 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8014b2:	f3 0f 1e fa          	endbr64
  8014b6:	55                   	push   %rbp
  8014b7:	48 89 e5             	mov    %rsp,%rbp
  8014ba:	53                   	push   %rbx
  8014bb:	49 89 f8             	mov    %rdi,%r8
  8014be:	48 89 d3             	mov    %rdx,%rbx
  8014c1:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8014c4:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014c9:	4c 89 c2             	mov    %r8,%rdx
  8014cc:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014cf:	be 00 00 00 00       	mov    $0x0,%esi
  8014d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014da:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8014dc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014e0:	c9                   	leave
  8014e1:	c3                   	ret

00000000008014e2 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8014e2:	f3 0f 1e fa          	endbr64
  8014e6:	55                   	push   %rbp
  8014e7:	48 89 e5             	mov    %rsp,%rbp
  8014ea:	53                   	push   %rbx
  8014eb:	48 83 ec 08          	sub    $0x8,%rsp
  8014ef:	89 f8                	mov    %edi,%eax
  8014f1:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8014f4:	48 63 f9             	movslq %ecx,%rdi
  8014f7:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014fa:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014ff:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801502:	be 00 00 00 00       	mov    $0x0,%esi
  801507:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80150d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80150f:	48 85 c0             	test   %rax,%rax
  801512:	7f 06                	jg     80151a <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801514:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801518:	c9                   	leave
  801519:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80151a:	49 89 c0             	mov    %rax,%r8
  80151d:	b9 04 00 00 00       	mov    $0x4,%ecx
  801522:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  801529:	00 00 00 
  80152c:	be 26 00 00 00       	mov    $0x26,%esi
  801531:	48 bf 4d 42 80 00 00 	movabs $0x80424d,%rdi
  801538:	00 00 00 
  80153b:	b8 00 00 00 00       	mov    $0x0,%eax
  801540:	49 b9 38 04 80 00 00 	movabs $0x800438,%r9
  801547:	00 00 00 
  80154a:	41 ff d1             	call   *%r9

000000000080154d <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80154d:	f3 0f 1e fa          	endbr64
  801551:	55                   	push   %rbp
  801552:	48 89 e5             	mov    %rsp,%rbp
  801555:	53                   	push   %rbx
  801556:	48 83 ec 08          	sub    $0x8,%rsp
  80155a:	89 f8                	mov    %edi,%eax
  80155c:	49 89 f2             	mov    %rsi,%r10
  80155f:	48 89 cf             	mov    %rcx,%rdi
  801562:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801565:	48 63 da             	movslq %edx,%rbx
  801568:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80156b:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801570:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801573:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801576:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801578:	48 85 c0             	test   %rax,%rax
  80157b:	7f 06                	jg     801583 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80157d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801581:	c9                   	leave
  801582:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801583:	49 89 c0             	mov    %rax,%r8
  801586:	b9 05 00 00 00       	mov    $0x5,%ecx
  80158b:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  801592:	00 00 00 
  801595:	be 26 00 00 00       	mov    $0x26,%esi
  80159a:	48 bf 4d 42 80 00 00 	movabs $0x80424d,%rdi
  8015a1:	00 00 00 
  8015a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a9:	49 b9 38 04 80 00 00 	movabs $0x800438,%r9
  8015b0:	00 00 00 
  8015b3:	41 ff d1             	call   *%r9

00000000008015b6 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8015b6:	f3 0f 1e fa          	endbr64
  8015ba:	55                   	push   %rbp
  8015bb:	48 89 e5             	mov    %rsp,%rbp
  8015be:	53                   	push   %rbx
  8015bf:	48 83 ec 08          	sub    $0x8,%rsp
  8015c3:	49 89 f9             	mov    %rdi,%r9
  8015c6:	89 f0                	mov    %esi,%eax
  8015c8:	48 89 d3             	mov    %rdx,%rbx
  8015cb:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8015ce:	49 63 f0             	movslq %r8d,%rsi
  8015d1:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8015d4:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015d9:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015e2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015e4:	48 85 c0             	test   %rax,%rax
  8015e7:	7f 06                	jg     8015ef <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8015e9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015ed:	c9                   	leave
  8015ee:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015ef:	49 89 c0             	mov    %rax,%r8
  8015f2:	b9 06 00 00 00       	mov    $0x6,%ecx
  8015f7:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  8015fe:	00 00 00 
  801601:	be 26 00 00 00       	mov    $0x26,%esi
  801606:	48 bf 4d 42 80 00 00 	movabs $0x80424d,%rdi
  80160d:	00 00 00 
  801610:	b8 00 00 00 00       	mov    $0x0,%eax
  801615:	49 b9 38 04 80 00 00 	movabs $0x800438,%r9
  80161c:	00 00 00 
  80161f:	41 ff d1             	call   *%r9

0000000000801622 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801622:	f3 0f 1e fa          	endbr64
  801626:	55                   	push   %rbp
  801627:	48 89 e5             	mov    %rsp,%rbp
  80162a:	53                   	push   %rbx
  80162b:	48 83 ec 08          	sub    $0x8,%rsp
  80162f:	48 89 f1             	mov    %rsi,%rcx
  801632:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801635:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801638:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80163d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801642:	be 00 00 00 00       	mov    $0x0,%esi
  801647:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80164d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80164f:	48 85 c0             	test   %rax,%rax
  801652:	7f 06                	jg     80165a <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801654:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801658:	c9                   	leave
  801659:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80165a:	49 89 c0             	mov    %rax,%r8
  80165d:	b9 07 00 00 00       	mov    $0x7,%ecx
  801662:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  801669:	00 00 00 
  80166c:	be 26 00 00 00       	mov    $0x26,%esi
  801671:	48 bf 4d 42 80 00 00 	movabs $0x80424d,%rdi
  801678:	00 00 00 
  80167b:	b8 00 00 00 00       	mov    $0x0,%eax
  801680:	49 b9 38 04 80 00 00 	movabs $0x800438,%r9
  801687:	00 00 00 
  80168a:	41 ff d1             	call   *%r9

000000000080168d <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80168d:	f3 0f 1e fa          	endbr64
  801691:	55                   	push   %rbp
  801692:	48 89 e5             	mov    %rsp,%rbp
  801695:	53                   	push   %rbx
  801696:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80169a:	48 63 ce             	movslq %esi,%rcx
  80169d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016a0:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016aa:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016af:	be 00 00 00 00       	mov    $0x0,%esi
  8016b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016ba:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016bc:	48 85 c0             	test   %rax,%rax
  8016bf:	7f 06                	jg     8016c7 <sys_env_set_status+0x3a>
}
  8016c1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016c5:	c9                   	leave
  8016c6:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016c7:	49 89 c0             	mov    %rax,%r8
  8016ca:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016cf:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  8016d6:	00 00 00 
  8016d9:	be 26 00 00 00       	mov    $0x26,%esi
  8016de:	48 bf 4d 42 80 00 00 	movabs $0x80424d,%rdi
  8016e5:	00 00 00 
  8016e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ed:	49 b9 38 04 80 00 00 	movabs $0x800438,%r9
  8016f4:	00 00 00 
  8016f7:	41 ff d1             	call   *%r9

00000000008016fa <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8016fa:	f3 0f 1e fa          	endbr64
  8016fe:	55                   	push   %rbp
  8016ff:	48 89 e5             	mov    %rsp,%rbp
  801702:	53                   	push   %rbx
  801703:	48 83 ec 08          	sub    $0x8,%rsp
  801707:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80170a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80170d:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801712:	bb 00 00 00 00       	mov    $0x0,%ebx
  801717:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80171c:	be 00 00 00 00       	mov    $0x0,%esi
  801721:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801727:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801729:	48 85 c0             	test   %rax,%rax
  80172c:	7f 06                	jg     801734 <sys_env_set_trapframe+0x3a>
}
  80172e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801732:	c9                   	leave
  801733:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801734:	49 89 c0             	mov    %rax,%r8
  801737:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80173c:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  801743:	00 00 00 
  801746:	be 26 00 00 00       	mov    $0x26,%esi
  80174b:	48 bf 4d 42 80 00 00 	movabs $0x80424d,%rdi
  801752:	00 00 00 
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	49 b9 38 04 80 00 00 	movabs $0x800438,%r9
  801761:	00 00 00 
  801764:	41 ff d1             	call   *%r9

0000000000801767 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801767:	f3 0f 1e fa          	endbr64
  80176b:	55                   	push   %rbp
  80176c:	48 89 e5             	mov    %rsp,%rbp
  80176f:	53                   	push   %rbx
  801770:	48 83 ec 08          	sub    $0x8,%rsp
  801774:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801777:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80177a:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80177f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801784:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801789:	be 00 00 00 00       	mov    $0x0,%esi
  80178e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801794:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801796:	48 85 c0             	test   %rax,%rax
  801799:	7f 06                	jg     8017a1 <sys_env_set_pgfault_upcall+0x3a>
}
  80179b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80179f:	c9                   	leave
  8017a0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017a1:	49 89 c0             	mov    %rax,%r8
  8017a4:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8017a9:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  8017b0:	00 00 00 
  8017b3:	be 26 00 00 00       	mov    $0x26,%esi
  8017b8:	48 bf 4d 42 80 00 00 	movabs $0x80424d,%rdi
  8017bf:	00 00 00 
  8017c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c7:	49 b9 38 04 80 00 00 	movabs $0x800438,%r9
  8017ce:	00 00 00 
  8017d1:	41 ff d1             	call   *%r9

00000000008017d4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8017d4:	f3 0f 1e fa          	endbr64
  8017d8:	55                   	push   %rbp
  8017d9:	48 89 e5             	mov    %rsp,%rbp
  8017dc:	53                   	push   %rbx
  8017dd:	89 f8                	mov    %edi,%eax
  8017df:	49 89 f1             	mov    %rsi,%r9
  8017e2:	48 89 d3             	mov    %rdx,%rbx
  8017e5:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8017e8:	49 63 f0             	movslq %r8d,%rsi
  8017eb:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8017ee:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8017f3:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017fc:	cd 30                	int    $0x30
}
  8017fe:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801802:	c9                   	leave
  801803:	c3                   	ret

0000000000801804 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801804:	f3 0f 1e fa          	endbr64
  801808:	55                   	push   %rbp
  801809:	48 89 e5             	mov    %rsp,%rbp
  80180c:	53                   	push   %rbx
  80180d:	48 83 ec 08          	sub    $0x8,%rsp
  801811:	48 89 fa             	mov    %rdi,%rdx
  801814:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801817:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80181c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801821:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801826:	be 00 00 00 00       	mov    $0x0,%esi
  80182b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801831:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801833:	48 85 c0             	test   %rax,%rax
  801836:	7f 06                	jg     80183e <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801838:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80183c:	c9                   	leave
  80183d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80183e:	49 89 c0             	mov    %rax,%r8
  801841:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801846:	48 ba 18 44 80 00 00 	movabs $0x804418,%rdx
  80184d:	00 00 00 
  801850:	be 26 00 00 00       	mov    $0x26,%esi
  801855:	48 bf 4d 42 80 00 00 	movabs $0x80424d,%rdi
  80185c:	00 00 00 
  80185f:	b8 00 00 00 00       	mov    $0x0,%eax
  801864:	49 b9 38 04 80 00 00 	movabs $0x800438,%r9
  80186b:	00 00 00 
  80186e:	41 ff d1             	call   *%r9

0000000000801871 <sys_gettime>:

int
sys_gettime(void) {
  801871:	f3 0f 1e fa          	endbr64
  801875:	55                   	push   %rbp
  801876:	48 89 e5             	mov    %rsp,%rbp
  801879:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80187a:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80187f:	ba 00 00 00 00       	mov    $0x0,%edx
  801884:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801889:	bb 00 00 00 00       	mov    $0x0,%ebx
  80188e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801893:	be 00 00 00 00       	mov    $0x0,%esi
  801898:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80189e:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8018a0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018a4:	c9                   	leave
  8018a5:	c3                   	ret

00000000008018a6 <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8018a6:	f3 0f 1e fa          	endbr64
  8018aa:	55                   	push   %rbp
  8018ab:	48 89 e5             	mov    %rsp,%rbp
  8018ae:	41 56                	push   %r14
  8018b0:	41 55                	push   %r13
  8018b2:	41 54                	push   %r12
  8018b4:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  8018b5:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8018bc:	00 00 00 
  8018bf:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8018c6:	b8 09 00 00 00       	mov    $0x9,%eax
  8018cb:	cd 30                	int    $0x30
  8018cd:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  8018d0:	85 c0                	test   %eax,%eax
  8018d2:	78 7f                	js     801953 <fork+0xad>
  8018d4:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  8018d6:	0f 84 83 00 00 00    	je     80195f <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  8018dc:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  8018e2:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  8018e9:	00 00 00 
  8018ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f1:	89 c2                	mov    %eax,%edx
  8018f3:	be 00 00 00 00       	mov    $0x0,%esi
  8018f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8018fd:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  801904:	00 00 00 
  801907:	ff d0                	call   *%rax
  801909:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  80190c:	85 c0                	test   %eax,%eax
  80190e:	0f 88 81 00 00 00    	js     801995 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  801914:	4d 85 f6             	test   %r14,%r14
  801917:	74 20                	je     801939 <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801919:	48 be 22 31 80 00 00 	movabs $0x803122,%rsi
  801920:	00 00 00 
  801923:	44 89 e7             	mov    %r12d,%edi
  801926:	48 b8 67 17 80 00 00 	movabs $0x801767,%rax
  80192d:	00 00 00 
  801930:	ff d0                	call   *%rax
  801932:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  801935:	85 c0                	test   %eax,%eax
  801937:	78 70                	js     8019a9 <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801939:	be 02 00 00 00       	mov    $0x2,%esi
  80193e:	89 df                	mov    %ebx,%edi
  801940:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  801947:	00 00 00 
  80194a:	ff d0                	call   *%rax
  80194c:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  80194f:	85 c0                	test   %eax,%eax
  801951:	78 6a                	js     8019bd <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  801953:	44 89 e0             	mov    %r12d,%eax
  801956:	5b                   	pop    %rbx
  801957:	41 5c                	pop    %r12
  801959:	41 5d                	pop    %r13
  80195b:	41 5e                	pop    %r14
  80195d:	5d                   	pop    %rbp
  80195e:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  80195f:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  801966:	00 00 00 
  801969:	ff d0                	call   *%rax
  80196b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801970:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801974:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801978:	48 c1 e0 04          	shl    $0x4,%rax
  80197c:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  801983:	00 00 00 
  801986:	48 01 d0             	add    %rdx,%rax
  801989:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  801990:	00 00 00 
        return 0;
  801993:	eb be                	jmp    801953 <fork+0xad>
        sys_env_destroy(envid);
  801995:	44 89 e7             	mov    %r12d,%edi
  801998:	48 b8 a3 13 80 00 00 	movabs $0x8013a3,%rax
  80199f:	00 00 00 
  8019a2:	ff d0                	call   *%rax
        return res;
  8019a4:	45 89 ec             	mov    %r13d,%r12d
  8019a7:	eb aa                	jmp    801953 <fork+0xad>
            sys_env_destroy(envid);
  8019a9:	44 89 e7             	mov    %r12d,%edi
  8019ac:	48 b8 a3 13 80 00 00 	movabs $0x8013a3,%rax
  8019b3:	00 00 00 
  8019b6:	ff d0                	call   *%rax
            return res;
  8019b8:	45 89 ec             	mov    %r13d,%r12d
  8019bb:	eb 96                	jmp    801953 <fork+0xad>
        sys_env_destroy(envid);
  8019bd:	89 df                	mov    %ebx,%edi
  8019bf:	48 b8 a3 13 80 00 00 	movabs $0x8013a3,%rax
  8019c6:	00 00 00 
  8019c9:	ff d0                	call   *%rax
        return res;
  8019cb:	45 89 ec             	mov    %r13d,%r12d
  8019ce:	eb 83                	jmp    801953 <fork+0xad>

00000000008019d0 <sfork>:

envid_t
sfork() {
  8019d0:	f3 0f 1e fa          	endbr64
  8019d4:	55                   	push   %rbp
  8019d5:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  8019d8:	48 ba 5b 42 80 00 00 	movabs $0x80425b,%rdx
  8019df:	00 00 00 
  8019e2:	be 37 00 00 00       	mov    $0x37,%esi
  8019e7:	48 bf 76 42 80 00 00 	movabs $0x804276,%rdi
  8019ee:	00 00 00 
  8019f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f6:	48 b9 38 04 80 00 00 	movabs $0x800438,%rcx
  8019fd:	00 00 00 
  801a00:	ff d1                	call   *%rcx

0000000000801a02 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  801a02:	f3 0f 1e fa          	endbr64
  801a06:	55                   	push   %rbp
  801a07:	48 89 e5             	mov    %rsp,%rbp
  801a0a:	41 54                	push   %r12
  801a0c:	53                   	push   %rbx
  801a0d:	48 89 fb             	mov    %rdi,%rbx
  801a10:	48 89 f7             	mov    %rsi,%rdi
  801a13:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  801a16:	48 85 f6             	test   %rsi,%rsi
  801a19:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  801a20:	00 00 00 
  801a23:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  801a27:	be 00 10 00 00       	mov    $0x1000,%esi
  801a2c:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801a33:	00 00 00 
  801a36:	ff d0                	call   *%rax
    if (res < 0) {
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	78 45                	js     801a81 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  801a3c:	48 85 db             	test   %rbx,%rbx
  801a3f:	74 12                	je     801a53 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  801a41:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801a48:	00 00 00 
  801a4b:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  801a51:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  801a53:	4d 85 e4             	test   %r12,%r12
  801a56:	74 14                	je     801a6c <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  801a58:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801a5f:	00 00 00 
  801a62:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  801a68:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  801a6c:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801a73:	00 00 00 
  801a76:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  801a7c:	5b                   	pop    %rbx
  801a7d:	41 5c                	pop    %r12
  801a7f:	5d                   	pop    %rbp
  801a80:	c3                   	ret
        if (from_env_store != NULL) {
  801a81:	48 85 db             	test   %rbx,%rbx
  801a84:	74 06                	je     801a8c <ipc_recv+0x8a>
            *from_env_store = 0;
  801a86:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  801a8c:	4d 85 e4             	test   %r12,%r12
  801a8f:	74 eb                	je     801a7c <ipc_recv+0x7a>
            *perm_store = 0;
  801a91:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  801a98:	00 
  801a99:	eb e1                	jmp    801a7c <ipc_recv+0x7a>

0000000000801a9b <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  801a9b:	f3 0f 1e fa          	endbr64
  801a9f:	55                   	push   %rbp
  801aa0:	48 89 e5             	mov    %rsp,%rbp
  801aa3:	41 57                	push   %r15
  801aa5:	41 56                	push   %r14
  801aa7:	41 55                	push   %r13
  801aa9:	41 54                	push   %r12
  801aab:	53                   	push   %rbx
  801aac:	48 83 ec 18          	sub    $0x18,%rsp
  801ab0:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  801ab3:	48 89 d3             	mov    %rdx,%rbx
  801ab6:	49 89 cc             	mov    %rcx,%r12
  801ab9:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  801abc:	48 85 d2             	test   %rdx,%rdx
  801abf:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  801ac6:	00 00 00 
  801ac9:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  801acd:	89 f0                	mov    %esi,%eax
  801acf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801ad3:	48 89 da             	mov    %rbx,%rdx
  801ad6:	48 89 c6             	mov    %rax,%rsi
  801ad9:	48 b8 d4 17 80 00 00 	movabs $0x8017d4,%rax
  801ae0:	00 00 00 
  801ae3:	ff d0                	call   *%rax
    while (res < 0) {
  801ae5:	85 c0                	test   %eax,%eax
  801ae7:	79 65                	jns    801b4e <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  801ae9:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801aec:	75 33                	jne    801b21 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  801aee:	49 bf 47 14 80 00 00 	movabs $0x801447,%r15
  801af5:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  801af8:	49 be d4 17 80 00 00 	movabs $0x8017d4,%r14
  801aff:	00 00 00 
        sys_yield();
  801b02:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  801b05:	45 89 e8             	mov    %r13d,%r8d
  801b08:	4c 89 e1             	mov    %r12,%rcx
  801b0b:	48 89 da             	mov    %rbx,%rdx
  801b0e:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  801b12:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  801b15:	41 ff d6             	call   *%r14
    while (res < 0) {
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	79 32                	jns    801b4e <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  801b1c:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801b1f:	74 e1                	je     801b02 <ipc_send+0x67>
            panic("Error: %i\n", res);
  801b21:	89 c1                	mov    %eax,%ecx
  801b23:	48 ba 81 42 80 00 00 	movabs $0x804281,%rdx
  801b2a:	00 00 00 
  801b2d:	be 42 00 00 00       	mov    $0x42,%esi
  801b32:	48 bf 8c 42 80 00 00 	movabs $0x80428c,%rdi
  801b39:	00 00 00 
  801b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b41:	49 b8 38 04 80 00 00 	movabs $0x800438,%r8
  801b48:	00 00 00 
  801b4b:	41 ff d0             	call   *%r8
    }
}
  801b4e:	48 83 c4 18          	add    $0x18,%rsp
  801b52:	5b                   	pop    %rbx
  801b53:	41 5c                	pop    %r12
  801b55:	41 5d                	pop    %r13
  801b57:	41 5e                	pop    %r14
  801b59:	41 5f                	pop    %r15
  801b5b:	5d                   	pop    %rbp
  801b5c:	c3                   	ret

0000000000801b5d <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  801b5d:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  801b61:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  801b66:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  801b6d:	00 00 00 
  801b70:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801b74:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  801b78:	48 c1 e2 04          	shl    $0x4,%rdx
  801b7c:	48 01 ca             	add    %rcx,%rdx
  801b7f:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  801b85:	39 fa                	cmp    %edi,%edx
  801b87:	74 12                	je     801b9b <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  801b89:	48 83 c0 01          	add    $0x1,%rax
  801b8d:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  801b93:	75 db                	jne    801b70 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  801b95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9a:	c3                   	ret
            return envs[i].env_id;
  801b9b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801b9f:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  801ba3:	48 c1 e2 04          	shl    $0x4,%rdx
  801ba7:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  801bae:	00 00 00 
  801bb1:	48 01 d0             	add    %rdx,%rax
  801bb4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801bba:	c3                   	ret

0000000000801bbb <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801bbb:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801bbf:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801bc6:	ff ff ff 
  801bc9:	48 01 f8             	add    %rdi,%rax
  801bcc:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801bd0:	c3                   	ret

0000000000801bd1 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801bd1:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801bd5:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801bdc:	ff ff ff 
  801bdf:	48 01 f8             	add    %rdi,%rax
  801be2:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801be6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801bec:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801bf0:	c3                   	ret

0000000000801bf1 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801bf1:	f3 0f 1e fa          	endbr64
  801bf5:	55                   	push   %rbp
  801bf6:	48 89 e5             	mov    %rsp,%rbp
  801bf9:	41 57                	push   %r15
  801bfb:	41 56                	push   %r14
  801bfd:	41 55                	push   %r13
  801bff:	41 54                	push   %r12
  801c01:	53                   	push   %rbx
  801c02:	48 83 ec 08          	sub    $0x8,%rsp
  801c06:	49 89 ff             	mov    %rdi,%r15
  801c09:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801c0e:	49 bd 50 2d 80 00 00 	movabs $0x802d50,%r13
  801c15:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801c18:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801c1e:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801c21:	48 89 df             	mov    %rbx,%rdi
  801c24:	41 ff d5             	call   *%r13
  801c27:	83 e0 04             	and    $0x4,%eax
  801c2a:	74 17                	je     801c43 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801c2c:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801c33:	4c 39 f3             	cmp    %r14,%rbx
  801c36:	75 e6                	jne    801c1e <fd_alloc+0x2d>
  801c38:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801c3e:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801c43:	4d 89 27             	mov    %r12,(%r15)
}
  801c46:	48 83 c4 08          	add    $0x8,%rsp
  801c4a:	5b                   	pop    %rbx
  801c4b:	41 5c                	pop    %r12
  801c4d:	41 5d                	pop    %r13
  801c4f:	41 5e                	pop    %r14
  801c51:	41 5f                	pop    %r15
  801c53:	5d                   	pop    %rbp
  801c54:	c3                   	ret

0000000000801c55 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801c55:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801c59:	83 ff 1f             	cmp    $0x1f,%edi
  801c5c:	77 39                	ja     801c97 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801c5e:	55                   	push   %rbp
  801c5f:	48 89 e5             	mov    %rsp,%rbp
  801c62:	41 54                	push   %r12
  801c64:	53                   	push   %rbx
  801c65:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801c68:	48 63 df             	movslq %edi,%rbx
  801c6b:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801c72:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801c76:	48 89 df             	mov    %rbx,%rdi
  801c79:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  801c80:	00 00 00 
  801c83:	ff d0                	call   *%rax
  801c85:	a8 04                	test   $0x4,%al
  801c87:	74 14                	je     801c9d <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801c89:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801c8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c92:	5b                   	pop    %rbx
  801c93:	41 5c                	pop    %r12
  801c95:	5d                   	pop    %rbp
  801c96:	c3                   	ret
        return -E_INVAL;
  801c97:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801c9c:	c3                   	ret
        return -E_INVAL;
  801c9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ca2:	eb ee                	jmp    801c92 <fd_lookup+0x3d>

0000000000801ca4 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801ca4:	f3 0f 1e fa          	endbr64
  801ca8:	55                   	push   %rbp
  801ca9:	48 89 e5             	mov    %rsp,%rbp
  801cac:	41 54                	push   %r12
  801cae:	53                   	push   %rbx
  801caf:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801cb2:	48 b8 40 48 80 00 00 	movabs $0x804840,%rax
  801cb9:	00 00 00 
  801cbc:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801cc3:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801cc6:	39 3b                	cmp    %edi,(%rbx)
  801cc8:	74 47                	je     801d11 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801cca:	48 83 c0 08          	add    $0x8,%rax
  801cce:	48 8b 18             	mov    (%rax),%rbx
  801cd1:	48 85 db             	test   %rbx,%rbx
  801cd4:	75 f0                	jne    801cc6 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801cd6:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801cdd:	00 00 00 
  801ce0:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ce6:	89 fa                	mov    %edi,%edx
  801ce8:	48 bf 38 44 80 00 00 	movabs $0x804438,%rdi
  801cef:	00 00 00 
  801cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf7:	48 b9 94 05 80 00 00 	movabs $0x800594,%rcx
  801cfe:	00 00 00 
  801d01:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801d03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801d08:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801d0c:	5b                   	pop    %rbx
  801d0d:	41 5c                	pop    %r12
  801d0f:	5d                   	pop    %rbp
  801d10:	c3                   	ret
            return 0;
  801d11:	b8 00 00 00 00       	mov    $0x0,%eax
  801d16:	eb f0                	jmp    801d08 <dev_lookup+0x64>

0000000000801d18 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801d18:	f3 0f 1e fa          	endbr64
  801d1c:	55                   	push   %rbp
  801d1d:	48 89 e5             	mov    %rsp,%rbp
  801d20:	41 55                	push   %r13
  801d22:	41 54                	push   %r12
  801d24:	53                   	push   %rbx
  801d25:	48 83 ec 18          	sub    $0x18,%rsp
  801d29:	48 89 fb             	mov    %rdi,%rbx
  801d2c:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801d2f:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801d36:	ff ff ff 
  801d39:	48 01 df             	add    %rbx,%rdi
  801d3c:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801d40:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d44:	48 b8 55 1c 80 00 00 	movabs $0x801c55,%rax
  801d4b:	00 00 00 
  801d4e:	ff d0                	call   *%rax
  801d50:	41 89 c5             	mov    %eax,%r13d
  801d53:	85 c0                	test   %eax,%eax
  801d55:	78 06                	js     801d5d <fd_close+0x45>
  801d57:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801d5b:	74 1a                	je     801d77 <fd_close+0x5f>
        return (must_exist ? res : 0);
  801d5d:	45 84 e4             	test   %r12b,%r12b
  801d60:	b8 00 00 00 00       	mov    $0x0,%eax
  801d65:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801d69:	44 89 e8             	mov    %r13d,%eax
  801d6c:	48 83 c4 18          	add    $0x18,%rsp
  801d70:	5b                   	pop    %rbx
  801d71:	41 5c                	pop    %r12
  801d73:	41 5d                	pop    %r13
  801d75:	5d                   	pop    %rbp
  801d76:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801d77:	8b 3b                	mov    (%rbx),%edi
  801d79:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d7d:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  801d84:	00 00 00 
  801d87:	ff d0                	call   *%rax
  801d89:	41 89 c5             	mov    %eax,%r13d
  801d8c:	85 c0                	test   %eax,%eax
  801d8e:	78 1b                	js     801dab <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801d90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d94:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d98:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801d9e:	48 85 c0             	test   %rax,%rax
  801da1:	74 08                	je     801dab <fd_close+0x93>
  801da3:	48 89 df             	mov    %rbx,%rdi
  801da6:	ff d0                	call   *%rax
  801da8:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801dab:	ba 00 10 00 00       	mov    $0x1000,%edx
  801db0:	48 89 de             	mov    %rbx,%rsi
  801db3:	bf 00 00 00 00       	mov    $0x0,%edi
  801db8:	48 b8 22 16 80 00 00 	movabs $0x801622,%rax
  801dbf:	00 00 00 
  801dc2:	ff d0                	call   *%rax
    return res;
  801dc4:	eb a3                	jmp    801d69 <fd_close+0x51>

0000000000801dc6 <close>:

int
close(int fdnum) {
  801dc6:	f3 0f 1e fa          	endbr64
  801dca:	55                   	push   %rbp
  801dcb:	48 89 e5             	mov    %rsp,%rbp
  801dce:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801dd2:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801dd6:	48 b8 55 1c 80 00 00 	movabs $0x801c55,%rax
  801ddd:	00 00 00 
  801de0:	ff d0                	call   *%rax
    if (res < 0) return res;
  801de2:	85 c0                	test   %eax,%eax
  801de4:	78 15                	js     801dfb <close+0x35>

    return fd_close(fd, 1);
  801de6:	be 01 00 00 00       	mov    $0x1,%esi
  801deb:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801def:	48 b8 18 1d 80 00 00 	movabs $0x801d18,%rax
  801df6:	00 00 00 
  801df9:	ff d0                	call   *%rax
}
  801dfb:	c9                   	leave
  801dfc:	c3                   	ret

0000000000801dfd <close_all>:

void
close_all(void) {
  801dfd:	f3 0f 1e fa          	endbr64
  801e01:	55                   	push   %rbp
  801e02:	48 89 e5             	mov    %rsp,%rbp
  801e05:	41 54                	push   %r12
  801e07:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801e08:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e0d:	49 bc c6 1d 80 00 00 	movabs $0x801dc6,%r12
  801e14:	00 00 00 
  801e17:	89 df                	mov    %ebx,%edi
  801e19:	41 ff d4             	call   *%r12
  801e1c:	83 c3 01             	add    $0x1,%ebx
  801e1f:	83 fb 20             	cmp    $0x20,%ebx
  801e22:	75 f3                	jne    801e17 <close_all+0x1a>
}
  801e24:	5b                   	pop    %rbx
  801e25:	41 5c                	pop    %r12
  801e27:	5d                   	pop    %rbp
  801e28:	c3                   	ret

0000000000801e29 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801e29:	f3 0f 1e fa          	endbr64
  801e2d:	55                   	push   %rbp
  801e2e:	48 89 e5             	mov    %rsp,%rbp
  801e31:	41 57                	push   %r15
  801e33:	41 56                	push   %r14
  801e35:	41 55                	push   %r13
  801e37:	41 54                	push   %r12
  801e39:	53                   	push   %rbx
  801e3a:	48 83 ec 18          	sub    $0x18,%rsp
  801e3e:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801e41:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801e45:	48 b8 55 1c 80 00 00 	movabs $0x801c55,%rax
  801e4c:	00 00 00 
  801e4f:	ff d0                	call   *%rax
  801e51:	89 c3                	mov    %eax,%ebx
  801e53:	85 c0                	test   %eax,%eax
  801e55:	0f 88 b8 00 00 00    	js     801f13 <dup+0xea>
    close(newfdnum);
  801e5b:	44 89 e7             	mov    %r12d,%edi
  801e5e:	48 b8 c6 1d 80 00 00 	movabs $0x801dc6,%rax
  801e65:	00 00 00 
  801e68:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801e6a:	4d 63 ec             	movslq %r12d,%r13
  801e6d:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801e74:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801e78:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801e7c:	4c 89 ff             	mov    %r15,%rdi
  801e7f:	49 be d1 1b 80 00 00 	movabs $0x801bd1,%r14
  801e86:	00 00 00 
  801e89:	41 ff d6             	call   *%r14
  801e8c:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801e8f:	4c 89 ef             	mov    %r13,%rdi
  801e92:	41 ff d6             	call   *%r14
  801e95:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801e98:	48 89 df             	mov    %rbx,%rdi
  801e9b:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  801ea2:	00 00 00 
  801ea5:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801ea7:	a8 04                	test   $0x4,%al
  801ea9:	74 2b                	je     801ed6 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801eab:	41 89 c1             	mov    %eax,%r9d
  801eae:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801eb4:	4c 89 f1             	mov    %r14,%rcx
  801eb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebc:	48 89 de             	mov    %rbx,%rsi
  801ebf:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec4:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  801ecb:	00 00 00 
  801ece:	ff d0                	call   *%rax
  801ed0:	89 c3                	mov    %eax,%ebx
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	78 4e                	js     801f24 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801ed6:	4c 89 ff             	mov    %r15,%rdi
  801ed9:	48 b8 50 2d 80 00 00 	movabs $0x802d50,%rax
  801ee0:	00 00 00 
  801ee3:	ff d0                	call   *%rax
  801ee5:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801ee8:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801eee:	4c 89 e9             	mov    %r13,%rcx
  801ef1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef6:	4c 89 fe             	mov    %r15,%rsi
  801ef9:	bf 00 00 00 00       	mov    $0x0,%edi
  801efe:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  801f05:	00 00 00 
  801f08:	ff d0                	call   *%rax
  801f0a:	89 c3                	mov    %eax,%ebx
  801f0c:	85 c0                	test   %eax,%eax
  801f0e:	78 14                	js     801f24 <dup+0xfb>

    return newfdnum;
  801f10:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801f13:	89 d8                	mov    %ebx,%eax
  801f15:	48 83 c4 18          	add    $0x18,%rsp
  801f19:	5b                   	pop    %rbx
  801f1a:	41 5c                	pop    %r12
  801f1c:	41 5d                	pop    %r13
  801f1e:	41 5e                	pop    %r14
  801f20:	41 5f                	pop    %r15
  801f22:	5d                   	pop    %rbp
  801f23:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801f24:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f29:	4c 89 ee             	mov    %r13,%rsi
  801f2c:	bf 00 00 00 00       	mov    $0x0,%edi
  801f31:	49 bc 22 16 80 00 00 	movabs $0x801622,%r12
  801f38:	00 00 00 
  801f3b:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801f3e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f43:	4c 89 f6             	mov    %r14,%rsi
  801f46:	bf 00 00 00 00       	mov    $0x0,%edi
  801f4b:	41 ff d4             	call   *%r12
    return res;
  801f4e:	eb c3                	jmp    801f13 <dup+0xea>

0000000000801f50 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801f50:	f3 0f 1e fa          	endbr64
  801f54:	55                   	push   %rbp
  801f55:	48 89 e5             	mov    %rsp,%rbp
  801f58:	41 56                	push   %r14
  801f5a:	41 55                	push   %r13
  801f5c:	41 54                	push   %r12
  801f5e:	53                   	push   %rbx
  801f5f:	48 83 ec 10          	sub    $0x10,%rsp
  801f63:	89 fb                	mov    %edi,%ebx
  801f65:	49 89 f4             	mov    %rsi,%r12
  801f68:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f6b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801f6f:	48 b8 55 1c 80 00 00 	movabs $0x801c55,%rax
  801f76:	00 00 00 
  801f79:	ff d0                	call   *%rax
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	78 4c                	js     801fcb <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f7f:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801f83:	41 8b 3e             	mov    (%r14),%edi
  801f86:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f8a:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  801f91:	00 00 00 
  801f94:	ff d0                	call   *%rax
  801f96:	85 c0                	test   %eax,%eax
  801f98:	78 35                	js     801fcf <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801f9a:	41 8b 46 08          	mov    0x8(%r14),%eax
  801f9e:	83 e0 03             	and    $0x3,%eax
  801fa1:	83 f8 01             	cmp    $0x1,%eax
  801fa4:	74 2d                	je     801fd3 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801fa6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801faa:	48 8b 40 10          	mov    0x10(%rax),%rax
  801fae:	48 85 c0             	test   %rax,%rax
  801fb1:	74 56                	je     802009 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801fb3:	4c 89 ea             	mov    %r13,%rdx
  801fb6:	4c 89 e6             	mov    %r12,%rsi
  801fb9:	4c 89 f7             	mov    %r14,%rdi
  801fbc:	ff d0                	call   *%rax
}
  801fbe:	48 83 c4 10          	add    $0x10,%rsp
  801fc2:	5b                   	pop    %rbx
  801fc3:	41 5c                	pop    %r12
  801fc5:	41 5d                	pop    %r13
  801fc7:	41 5e                	pop    %r14
  801fc9:	5d                   	pop    %rbp
  801fca:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801fcb:	48 98                	cltq
  801fcd:	eb ef                	jmp    801fbe <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801fcf:	48 98                	cltq
  801fd1:	eb eb                	jmp    801fbe <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801fd3:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801fda:	00 00 00 
  801fdd:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801fe3:	89 da                	mov    %ebx,%edx
  801fe5:	48 bf 96 42 80 00 00 	movabs $0x804296,%rdi
  801fec:	00 00 00 
  801fef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff4:	48 b9 94 05 80 00 00 	movabs $0x800594,%rcx
  801ffb:	00 00 00 
  801ffe:	ff d1                	call   *%rcx
        return -E_INVAL;
  802000:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  802007:	eb b5                	jmp    801fbe <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  802009:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  802010:	eb ac                	jmp    801fbe <read+0x6e>

0000000000802012 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  802012:	f3 0f 1e fa          	endbr64
  802016:	55                   	push   %rbp
  802017:	48 89 e5             	mov    %rsp,%rbp
  80201a:	41 57                	push   %r15
  80201c:	41 56                	push   %r14
  80201e:	41 55                	push   %r13
  802020:	41 54                	push   %r12
  802022:	53                   	push   %rbx
  802023:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  802027:	48 85 d2             	test   %rdx,%rdx
  80202a:	74 54                	je     802080 <readn+0x6e>
  80202c:	41 89 fd             	mov    %edi,%r13d
  80202f:	49 89 f6             	mov    %rsi,%r14
  802032:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  802035:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  80203a:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  80203f:	49 bf 50 1f 80 00 00 	movabs $0x801f50,%r15
  802046:	00 00 00 
  802049:	4c 89 e2             	mov    %r12,%rdx
  80204c:	48 29 f2             	sub    %rsi,%rdx
  80204f:	4c 01 f6             	add    %r14,%rsi
  802052:	44 89 ef             	mov    %r13d,%edi
  802055:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  802058:	85 c0                	test   %eax,%eax
  80205a:	78 20                	js     80207c <readn+0x6a>
    for (; inc && res < n; res += inc) {
  80205c:	01 c3                	add    %eax,%ebx
  80205e:	85 c0                	test   %eax,%eax
  802060:	74 08                	je     80206a <readn+0x58>
  802062:	48 63 f3             	movslq %ebx,%rsi
  802065:	4c 39 e6             	cmp    %r12,%rsi
  802068:	72 df                	jb     802049 <readn+0x37>
    }
    return res;
  80206a:	48 63 c3             	movslq %ebx,%rax
}
  80206d:	48 83 c4 08          	add    $0x8,%rsp
  802071:	5b                   	pop    %rbx
  802072:	41 5c                	pop    %r12
  802074:	41 5d                	pop    %r13
  802076:	41 5e                	pop    %r14
  802078:	41 5f                	pop    %r15
  80207a:	5d                   	pop    %rbp
  80207b:	c3                   	ret
        if (inc < 0) return inc;
  80207c:	48 98                	cltq
  80207e:	eb ed                	jmp    80206d <readn+0x5b>
    int inc = 1, res = 0;
  802080:	bb 00 00 00 00       	mov    $0x0,%ebx
  802085:	eb e3                	jmp    80206a <readn+0x58>

0000000000802087 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  802087:	f3 0f 1e fa          	endbr64
  80208b:	55                   	push   %rbp
  80208c:	48 89 e5             	mov    %rsp,%rbp
  80208f:	41 56                	push   %r14
  802091:	41 55                	push   %r13
  802093:	41 54                	push   %r12
  802095:	53                   	push   %rbx
  802096:	48 83 ec 10          	sub    $0x10,%rsp
  80209a:	89 fb                	mov    %edi,%ebx
  80209c:	49 89 f4             	mov    %rsi,%r12
  80209f:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8020a2:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8020a6:	48 b8 55 1c 80 00 00 	movabs $0x801c55,%rax
  8020ad:	00 00 00 
  8020b0:	ff d0                	call   *%rax
  8020b2:	85 c0                	test   %eax,%eax
  8020b4:	78 47                	js     8020fd <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8020b6:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8020ba:	41 8b 3e             	mov    (%r14),%edi
  8020bd:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8020c1:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  8020c8:	00 00 00 
  8020cb:	ff d0                	call   *%rax
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	78 30                	js     802101 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020d1:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  8020d6:	74 2d                	je     802105 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  8020d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8020dc:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020e0:	48 85 c0             	test   %rax,%rax
  8020e3:	74 56                	je     80213b <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  8020e5:	4c 89 ea             	mov    %r13,%rdx
  8020e8:	4c 89 e6             	mov    %r12,%rsi
  8020eb:	4c 89 f7             	mov    %r14,%rdi
  8020ee:	ff d0                	call   *%rax
}
  8020f0:	48 83 c4 10          	add    $0x10,%rsp
  8020f4:	5b                   	pop    %rbx
  8020f5:	41 5c                	pop    %r12
  8020f7:	41 5d                	pop    %r13
  8020f9:	41 5e                	pop    %r14
  8020fb:	5d                   	pop    %rbp
  8020fc:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8020fd:	48 98                	cltq
  8020ff:	eb ef                	jmp    8020f0 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802101:	48 98                	cltq
  802103:	eb eb                	jmp    8020f0 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802105:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80210c:	00 00 00 
  80210f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  802115:	89 da                	mov    %ebx,%edx
  802117:	48 bf b2 42 80 00 00 	movabs $0x8042b2,%rdi
  80211e:	00 00 00 
  802121:	b8 00 00 00 00       	mov    $0x0,%eax
  802126:	48 b9 94 05 80 00 00 	movabs $0x800594,%rcx
  80212d:	00 00 00 
  802130:	ff d1                	call   *%rcx
        return -E_INVAL;
  802132:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  802139:	eb b5                	jmp    8020f0 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  80213b:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  802142:	eb ac                	jmp    8020f0 <write+0x69>

0000000000802144 <seek>:

int
seek(int fdnum, off_t offset) {
  802144:	f3 0f 1e fa          	endbr64
  802148:	55                   	push   %rbp
  802149:	48 89 e5             	mov    %rsp,%rbp
  80214c:	53                   	push   %rbx
  80214d:	48 83 ec 18          	sub    $0x18,%rsp
  802151:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802153:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802157:	48 b8 55 1c 80 00 00 	movabs $0x801c55,%rax
  80215e:	00 00 00 
  802161:	ff d0                	call   *%rax
  802163:	85 c0                	test   %eax,%eax
  802165:	78 0c                	js     802173 <seek+0x2f>

    fd->fd_offset = offset;
  802167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216b:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  80216e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802173:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802177:	c9                   	leave
  802178:	c3                   	ret

0000000000802179 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  802179:	f3 0f 1e fa          	endbr64
  80217d:	55                   	push   %rbp
  80217e:	48 89 e5             	mov    %rsp,%rbp
  802181:	41 55                	push   %r13
  802183:	41 54                	push   %r12
  802185:	53                   	push   %rbx
  802186:	48 83 ec 18          	sub    $0x18,%rsp
  80218a:	89 fb                	mov    %edi,%ebx
  80218c:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80218f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  802193:	48 b8 55 1c 80 00 00 	movabs $0x801c55,%rax
  80219a:	00 00 00 
  80219d:	ff d0                	call   *%rax
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	78 38                	js     8021db <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8021a3:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  8021a7:	41 8b 7d 00          	mov    0x0(%r13),%edi
  8021ab:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8021af:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  8021b6:	00 00 00 
  8021b9:	ff d0                	call   *%rax
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	78 1c                	js     8021db <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021bf:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  8021c4:	74 20                	je     8021e6 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  8021c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021ca:	48 8b 40 30          	mov    0x30(%rax),%rax
  8021ce:	48 85 c0             	test   %rax,%rax
  8021d1:	74 47                	je     80221a <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  8021d3:	44 89 e6             	mov    %r12d,%esi
  8021d6:	4c 89 ef             	mov    %r13,%rdi
  8021d9:	ff d0                	call   *%rax
}
  8021db:	48 83 c4 18          	add    $0x18,%rsp
  8021df:	5b                   	pop    %rbx
  8021e0:	41 5c                	pop    %r12
  8021e2:	41 5d                	pop    %r13
  8021e4:	5d                   	pop    %rbp
  8021e5:	c3                   	ret
                thisenv->env_id, fdnum);
  8021e6:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8021ed:	00 00 00 
  8021f0:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  8021f6:	89 da                	mov    %ebx,%edx
  8021f8:	48 bf 58 44 80 00 00 	movabs $0x804458,%rdi
  8021ff:	00 00 00 
  802202:	b8 00 00 00 00       	mov    $0x0,%eax
  802207:	48 b9 94 05 80 00 00 	movabs $0x800594,%rcx
  80220e:	00 00 00 
  802211:	ff d1                	call   *%rcx
        return -E_INVAL;
  802213:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802218:	eb c1                	jmp    8021db <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  80221a:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  80221f:	eb ba                	jmp    8021db <ftruncate+0x62>

0000000000802221 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  802221:	f3 0f 1e fa          	endbr64
  802225:	55                   	push   %rbp
  802226:	48 89 e5             	mov    %rsp,%rbp
  802229:	41 54                	push   %r12
  80222b:	53                   	push   %rbx
  80222c:	48 83 ec 10          	sub    $0x10,%rsp
  802230:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802233:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802237:	48 b8 55 1c 80 00 00 	movabs $0x801c55,%rax
  80223e:	00 00 00 
  802241:	ff d0                	call   *%rax
  802243:	85 c0                	test   %eax,%eax
  802245:	78 4e                	js     802295 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802247:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  80224b:	41 8b 3c 24          	mov    (%r12),%edi
  80224f:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  802253:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  80225a:	00 00 00 
  80225d:	ff d0                	call   *%rax
  80225f:	85 c0                	test   %eax,%eax
  802261:	78 32                	js     802295 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  802263:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802267:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  80226c:	74 30                	je     80229e <fstat+0x7d>

    stat->st_name[0] = 0;
  80226e:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  802271:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  802278:	00 00 00 
    stat->st_isdir = 0;
  80227b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802282:	00 00 00 
    stat->st_dev = dev;
  802285:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  80228c:	48 89 de             	mov    %rbx,%rsi
  80228f:	4c 89 e7             	mov    %r12,%rdi
  802292:	ff 50 28             	call   *0x28(%rax)
}
  802295:	48 83 c4 10          	add    $0x10,%rsp
  802299:	5b                   	pop    %rbx
  80229a:	41 5c                	pop    %r12
  80229c:	5d                   	pop    %rbp
  80229d:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  80229e:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8022a3:	eb f0                	jmp    802295 <fstat+0x74>

00000000008022a5 <stat>:

int
stat(const char *path, struct Stat *stat) {
  8022a5:	f3 0f 1e fa          	endbr64
  8022a9:	55                   	push   %rbp
  8022aa:	48 89 e5             	mov    %rsp,%rbp
  8022ad:	41 54                	push   %r12
  8022af:	53                   	push   %rbx
  8022b0:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  8022b3:	be 00 00 00 00       	mov    $0x0,%esi
  8022b8:	48 b8 86 25 80 00 00 	movabs $0x802586,%rax
  8022bf:	00 00 00 
  8022c2:	ff d0                	call   *%rax
  8022c4:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	78 25                	js     8022ef <stat+0x4a>

    int res = fstat(fd, stat);
  8022ca:	4c 89 e6             	mov    %r12,%rsi
  8022cd:	89 c7                	mov    %eax,%edi
  8022cf:	48 b8 21 22 80 00 00 	movabs $0x802221,%rax
  8022d6:	00 00 00 
  8022d9:	ff d0                	call   *%rax
  8022db:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  8022de:	89 df                	mov    %ebx,%edi
  8022e0:	48 b8 c6 1d 80 00 00 	movabs $0x801dc6,%rax
  8022e7:	00 00 00 
  8022ea:	ff d0                	call   *%rax

    return res;
  8022ec:	44 89 e3             	mov    %r12d,%ebx
}
  8022ef:	89 d8                	mov    %ebx,%eax
  8022f1:	5b                   	pop    %rbx
  8022f2:	41 5c                	pop    %r12
  8022f4:	5d                   	pop    %rbp
  8022f5:	c3                   	ret

00000000008022f6 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  8022f6:	f3 0f 1e fa          	endbr64
  8022fa:	55                   	push   %rbp
  8022fb:	48 89 e5             	mov    %rsp,%rbp
  8022fe:	41 54                	push   %r12
  802300:	53                   	push   %rbx
  802301:	48 83 ec 10          	sub    $0x10,%rsp
  802305:	41 89 fc             	mov    %edi,%r12d
  802308:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80230b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802312:	00 00 00 
  802315:	83 38 00             	cmpl   $0x0,(%rax)
  802318:	74 6e                	je     802388 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  80231a:	bf 03 00 00 00       	mov    $0x3,%edi
  80231f:	48 b8 5d 1b 80 00 00 	movabs $0x801b5d,%rax
  802326:	00 00 00 
  802329:	ff d0                	call   *%rax
  80232b:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802332:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802334:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  80233a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80233f:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802346:	00 00 00 
  802349:	44 89 e6             	mov    %r12d,%esi
  80234c:	89 c7                	mov    %eax,%edi
  80234e:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  802355:	00 00 00 
  802358:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  80235a:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802361:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802362:	b9 00 00 00 00       	mov    $0x0,%ecx
  802367:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80236b:	48 89 de             	mov    %rbx,%rsi
  80236e:	bf 00 00 00 00       	mov    $0x0,%edi
  802373:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  80237a:	00 00 00 
  80237d:	ff d0                	call   *%rax
}
  80237f:	48 83 c4 10          	add    $0x10,%rsp
  802383:	5b                   	pop    %rbx
  802384:	41 5c                	pop    %r12
  802386:	5d                   	pop    %rbp
  802387:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802388:	bf 03 00 00 00       	mov    $0x3,%edi
  80238d:	48 b8 5d 1b 80 00 00 	movabs $0x801b5d,%rax
  802394:	00 00 00 
  802397:	ff d0                	call   *%rax
  802399:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  8023a0:	00 00 
  8023a2:	e9 73 ff ff ff       	jmp    80231a <fsipc+0x24>

00000000008023a7 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8023a7:	f3 0f 1e fa          	endbr64
  8023ab:	55                   	push   %rbp
  8023ac:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8023af:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8023b6:	00 00 00 
  8023b9:	8b 57 0c             	mov    0xc(%rdi),%edx
  8023bc:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8023be:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8023c1:	be 00 00 00 00       	mov    $0x0,%esi
  8023c6:	bf 02 00 00 00       	mov    $0x2,%edi
  8023cb:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  8023d2:	00 00 00 
  8023d5:	ff d0                	call   *%rax
}
  8023d7:	5d                   	pop    %rbp
  8023d8:	c3                   	ret

00000000008023d9 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8023d9:	f3 0f 1e fa          	endbr64
  8023dd:	55                   	push   %rbp
  8023de:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8023e1:	8b 47 0c             	mov    0xc(%rdi),%eax
  8023e4:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8023eb:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  8023ed:	be 00 00 00 00       	mov    $0x0,%esi
  8023f2:	bf 06 00 00 00       	mov    $0x6,%edi
  8023f7:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  8023fe:	00 00 00 
  802401:	ff d0                	call   *%rax
}
  802403:	5d                   	pop    %rbp
  802404:	c3                   	ret

0000000000802405 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802405:	f3 0f 1e fa          	endbr64
  802409:	55                   	push   %rbp
  80240a:	48 89 e5             	mov    %rsp,%rbp
  80240d:	41 54                	push   %r12
  80240f:	53                   	push   %rbx
  802410:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802413:	8b 47 0c             	mov    0xc(%rdi),%eax
  802416:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80241d:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  80241f:	be 00 00 00 00       	mov    $0x0,%esi
  802424:	bf 05 00 00 00       	mov    $0x5,%edi
  802429:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  802430:	00 00 00 
  802433:	ff d0                	call   *%rax
    if (res < 0) return res;
  802435:	85 c0                	test   %eax,%eax
  802437:	78 3d                	js     802476 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802439:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  802440:	00 00 00 
  802443:	4c 89 e6             	mov    %r12,%rsi
  802446:	48 89 df             	mov    %rbx,%rdi
  802449:	48 b8 dd 0e 80 00 00 	movabs $0x800edd,%rax
  802450:	00 00 00 
  802453:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  802455:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  80245c:	00 
  80245d:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802463:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  80246a:	00 
  80246b:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802476:	5b                   	pop    %rbx
  802477:	41 5c                	pop    %r12
  802479:	5d                   	pop    %rbp
  80247a:	c3                   	ret

000000000080247b <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  80247b:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  80247f:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  802486:	77 41                	ja     8024c9 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802488:	55                   	push   %rbp
  802489:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80248c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802493:	00 00 00 
  802496:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802499:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  80249b:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  80249f:	48 8d 78 10          	lea    0x10(%rax),%rdi
  8024a3:	48 b8 f8 10 80 00 00 	movabs $0x8010f8,%rax
  8024aa:	00 00 00 
  8024ad:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  8024af:	be 00 00 00 00       	mov    $0x0,%esi
  8024b4:	bf 04 00 00 00       	mov    $0x4,%edi
  8024b9:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  8024c0:	00 00 00 
  8024c3:	ff d0                	call   *%rax
  8024c5:	48 98                	cltq
}
  8024c7:	5d                   	pop    %rbp
  8024c8:	c3                   	ret
        return -E_INVAL;
  8024c9:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  8024d0:	c3                   	ret

00000000008024d1 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  8024d1:	f3 0f 1e fa          	endbr64
  8024d5:	55                   	push   %rbp
  8024d6:	48 89 e5             	mov    %rsp,%rbp
  8024d9:	41 55                	push   %r13
  8024db:	41 54                	push   %r12
  8024dd:	53                   	push   %rbx
  8024de:	48 83 ec 08          	sub    $0x8,%rsp
  8024e2:	49 89 f4             	mov    %rsi,%r12
  8024e5:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  8024e8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024ef:	00 00 00 
  8024f2:	8b 57 0c             	mov    0xc(%rdi),%edx
  8024f5:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  8024f7:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  8024fb:	be 00 00 00 00       	mov    $0x0,%esi
  802500:	bf 03 00 00 00       	mov    $0x3,%edi
  802505:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  80250c:	00 00 00 
  80250f:	ff d0                	call   *%rax
  802511:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802514:	4d 85 ed             	test   %r13,%r13
  802517:	78 2a                	js     802543 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802519:	4c 89 ea             	mov    %r13,%rdx
  80251c:	4c 39 eb             	cmp    %r13,%rbx
  80251f:	72 30                	jb     802551 <devfile_read+0x80>
  802521:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802528:	7f 27                	jg     802551 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  80252a:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802531:	00 00 00 
  802534:	4c 89 e7             	mov    %r12,%rdi
  802537:	48 b8 f8 10 80 00 00 	movabs $0x8010f8,%rax
  80253e:	00 00 00 
  802541:	ff d0                	call   *%rax
}
  802543:	4c 89 e8             	mov    %r13,%rax
  802546:	48 83 c4 08          	add    $0x8,%rsp
  80254a:	5b                   	pop    %rbx
  80254b:	41 5c                	pop    %r12
  80254d:	41 5d                	pop    %r13
  80254f:	5d                   	pop    %rbp
  802550:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  802551:	48 b9 cf 42 80 00 00 	movabs $0x8042cf,%rcx
  802558:	00 00 00 
  80255b:	48 ba ec 42 80 00 00 	movabs $0x8042ec,%rdx
  802562:	00 00 00 
  802565:	be 7b 00 00 00       	mov    $0x7b,%esi
  80256a:	48 bf 01 43 80 00 00 	movabs $0x804301,%rdi
  802571:	00 00 00 
  802574:	b8 00 00 00 00       	mov    $0x0,%eax
  802579:	49 b8 38 04 80 00 00 	movabs $0x800438,%r8
  802580:	00 00 00 
  802583:	41 ff d0             	call   *%r8

0000000000802586 <open>:
open(const char *path, int mode) {
  802586:	f3 0f 1e fa          	endbr64
  80258a:	55                   	push   %rbp
  80258b:	48 89 e5             	mov    %rsp,%rbp
  80258e:	41 55                	push   %r13
  802590:	41 54                	push   %r12
  802592:	53                   	push   %rbx
  802593:	48 83 ec 18          	sub    $0x18,%rsp
  802597:	49 89 fc             	mov    %rdi,%r12
  80259a:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  80259d:	48 b8 98 0e 80 00 00 	movabs $0x800e98,%rax
  8025a4:	00 00 00 
  8025a7:	ff d0                	call   *%rax
  8025a9:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8025af:	0f 87 8a 00 00 00    	ja     80263f <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8025b5:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8025b9:	48 b8 f1 1b 80 00 00 	movabs $0x801bf1,%rax
  8025c0:	00 00 00 
  8025c3:	ff d0                	call   *%rax
  8025c5:	89 c3                	mov    %eax,%ebx
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	78 50                	js     80261b <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  8025cb:	4c 89 e6             	mov    %r12,%rsi
  8025ce:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  8025d5:	00 00 00 
  8025d8:	48 89 df             	mov    %rbx,%rdi
  8025db:	48 b8 dd 0e 80 00 00 	movabs $0x800edd,%rax
  8025e2:	00 00 00 
  8025e5:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8025e7:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8025ee:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8025f2:	bf 01 00 00 00       	mov    $0x1,%edi
  8025f7:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  8025fe:	00 00 00 
  802601:	ff d0                	call   *%rax
  802603:	89 c3                	mov    %eax,%ebx
  802605:	85 c0                	test   %eax,%eax
  802607:	78 1f                	js     802628 <open+0xa2>
    return fd2num(fd);
  802609:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80260d:	48 b8 bb 1b 80 00 00 	movabs $0x801bbb,%rax
  802614:	00 00 00 
  802617:	ff d0                	call   *%rax
  802619:	89 c3                	mov    %eax,%ebx
}
  80261b:	89 d8                	mov    %ebx,%eax
  80261d:	48 83 c4 18          	add    $0x18,%rsp
  802621:	5b                   	pop    %rbx
  802622:	41 5c                	pop    %r12
  802624:	41 5d                	pop    %r13
  802626:	5d                   	pop    %rbp
  802627:	c3                   	ret
        fd_close(fd, 0);
  802628:	be 00 00 00 00       	mov    $0x0,%esi
  80262d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802631:	48 b8 18 1d 80 00 00 	movabs $0x801d18,%rax
  802638:	00 00 00 
  80263b:	ff d0                	call   *%rax
        return res;
  80263d:	eb dc                	jmp    80261b <open+0x95>
        return -E_BAD_PATH;
  80263f:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802644:	eb d5                	jmp    80261b <open+0x95>

0000000000802646 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802646:	f3 0f 1e fa          	endbr64
  80264a:	55                   	push   %rbp
  80264b:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80264e:	be 00 00 00 00       	mov    $0x0,%esi
  802653:	bf 08 00 00 00       	mov    $0x8,%edi
  802658:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  80265f:	00 00 00 
  802662:	ff d0                	call   *%rax
}
  802664:	5d                   	pop    %rbp
  802665:	c3                   	ret

0000000000802666 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802666:	f3 0f 1e fa          	endbr64
  80266a:	55                   	push   %rbp
  80266b:	48 89 e5             	mov    %rsp,%rbp
  80266e:	41 54                	push   %r12
  802670:	53                   	push   %rbx
  802671:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802674:	48 b8 d1 1b 80 00 00 	movabs $0x801bd1,%rax
  80267b:	00 00 00 
  80267e:	ff d0                	call   *%rax
  802680:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802683:	48 be 0c 43 80 00 00 	movabs $0x80430c,%rsi
  80268a:	00 00 00 
  80268d:	48 89 df             	mov    %rbx,%rdi
  802690:	48 b8 dd 0e 80 00 00 	movabs $0x800edd,%rax
  802697:	00 00 00 
  80269a:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80269c:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8026a1:	41 2b 04 24          	sub    (%r12),%eax
  8026a5:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8026ab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8026b2:	00 00 00 
    stat->st_dev = &devpipe;
  8026b5:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  8026bc:	00 00 00 
  8026bf:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8026c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cb:	5b                   	pop    %rbx
  8026cc:	41 5c                	pop    %r12
  8026ce:	5d                   	pop    %rbp
  8026cf:	c3                   	ret

00000000008026d0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8026d0:	f3 0f 1e fa          	endbr64
  8026d4:	55                   	push   %rbp
  8026d5:	48 89 e5             	mov    %rsp,%rbp
  8026d8:	41 54                	push   %r12
  8026da:	53                   	push   %rbx
  8026db:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8026de:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026e3:	48 89 fe             	mov    %rdi,%rsi
  8026e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8026eb:	49 bc 22 16 80 00 00 	movabs $0x801622,%r12
  8026f2:	00 00 00 
  8026f5:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8026f8:	48 89 df             	mov    %rbx,%rdi
  8026fb:	48 b8 d1 1b 80 00 00 	movabs $0x801bd1,%rax
  802702:	00 00 00 
  802705:	ff d0                	call   *%rax
  802707:	48 89 c6             	mov    %rax,%rsi
  80270a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80270f:	bf 00 00 00 00       	mov    $0x0,%edi
  802714:	41 ff d4             	call   *%r12
}
  802717:	5b                   	pop    %rbx
  802718:	41 5c                	pop    %r12
  80271a:	5d                   	pop    %rbp
  80271b:	c3                   	ret

000000000080271c <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  80271c:	f3 0f 1e fa          	endbr64
  802720:	55                   	push   %rbp
  802721:	48 89 e5             	mov    %rsp,%rbp
  802724:	41 57                	push   %r15
  802726:	41 56                	push   %r14
  802728:	41 55                	push   %r13
  80272a:	41 54                	push   %r12
  80272c:	53                   	push   %rbx
  80272d:	48 83 ec 18          	sub    $0x18,%rsp
  802731:	49 89 fc             	mov    %rdi,%r12
  802734:	49 89 f5             	mov    %rsi,%r13
  802737:	49 89 d7             	mov    %rdx,%r15
  80273a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80273e:	48 b8 d1 1b 80 00 00 	movabs $0x801bd1,%rax
  802745:	00 00 00 
  802748:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80274a:	4d 85 ff             	test   %r15,%r15
  80274d:	0f 84 af 00 00 00    	je     802802 <devpipe_write+0xe6>
  802753:	48 89 c3             	mov    %rax,%rbx
  802756:	4c 89 f8             	mov    %r15,%rax
  802759:	4d 89 ef             	mov    %r13,%r15
  80275c:	4c 01 e8             	add    %r13,%rax
  80275f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802763:	49 bd b2 14 80 00 00 	movabs $0x8014b2,%r13
  80276a:	00 00 00 
            sys_yield();
  80276d:	49 be 47 14 80 00 00 	movabs $0x801447,%r14
  802774:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802777:	8b 73 04             	mov    0x4(%rbx),%esi
  80277a:	48 63 ce             	movslq %esi,%rcx
  80277d:	48 63 03             	movslq (%rbx),%rax
  802780:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802786:	48 39 c1             	cmp    %rax,%rcx
  802789:	72 2e                	jb     8027b9 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80278b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802790:	48 89 da             	mov    %rbx,%rdx
  802793:	be 00 10 00 00       	mov    $0x1000,%esi
  802798:	4c 89 e7             	mov    %r12,%rdi
  80279b:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	74 66                	je     802808 <devpipe_write+0xec>
            sys_yield();
  8027a2:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8027a5:	8b 73 04             	mov    0x4(%rbx),%esi
  8027a8:	48 63 ce             	movslq %esi,%rcx
  8027ab:	48 63 03             	movslq (%rbx),%rax
  8027ae:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8027b4:	48 39 c1             	cmp    %rax,%rcx
  8027b7:	73 d2                	jae    80278b <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8027b9:	41 0f b6 3f          	movzbl (%r15),%edi
  8027bd:	48 89 ca             	mov    %rcx,%rdx
  8027c0:	48 c1 ea 03          	shr    $0x3,%rdx
  8027c4:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8027cb:	08 10 20 
  8027ce:	48 f7 e2             	mul    %rdx
  8027d1:	48 c1 ea 06          	shr    $0x6,%rdx
  8027d5:	48 89 d0             	mov    %rdx,%rax
  8027d8:	48 c1 e0 09          	shl    $0x9,%rax
  8027dc:	48 29 d0             	sub    %rdx,%rax
  8027df:	48 c1 e0 03          	shl    $0x3,%rax
  8027e3:	48 29 c1             	sub    %rax,%rcx
  8027e6:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8027eb:	83 c6 01             	add    $0x1,%esi
  8027ee:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8027f1:	49 83 c7 01          	add    $0x1,%r15
  8027f5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8027f9:	49 39 c7             	cmp    %rax,%r15
  8027fc:	0f 85 75 ff ff ff    	jne    802777 <devpipe_write+0x5b>
    return n;
  802802:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802806:	eb 05                	jmp    80280d <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802808:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80280d:	48 83 c4 18          	add    $0x18,%rsp
  802811:	5b                   	pop    %rbx
  802812:	41 5c                	pop    %r12
  802814:	41 5d                	pop    %r13
  802816:	41 5e                	pop    %r14
  802818:	41 5f                	pop    %r15
  80281a:	5d                   	pop    %rbp
  80281b:	c3                   	ret

000000000080281c <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80281c:	f3 0f 1e fa          	endbr64
  802820:	55                   	push   %rbp
  802821:	48 89 e5             	mov    %rsp,%rbp
  802824:	41 57                	push   %r15
  802826:	41 56                	push   %r14
  802828:	41 55                	push   %r13
  80282a:	41 54                	push   %r12
  80282c:	53                   	push   %rbx
  80282d:	48 83 ec 18          	sub    $0x18,%rsp
  802831:	49 89 fc             	mov    %rdi,%r12
  802834:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802838:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80283c:	48 b8 d1 1b 80 00 00 	movabs $0x801bd1,%rax
  802843:	00 00 00 
  802846:	ff d0                	call   *%rax
  802848:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80284b:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802851:	49 bd b2 14 80 00 00 	movabs $0x8014b2,%r13
  802858:	00 00 00 
            sys_yield();
  80285b:	49 be 47 14 80 00 00 	movabs $0x801447,%r14
  802862:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802865:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80286a:	74 7d                	je     8028e9 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80286c:	8b 03                	mov    (%rbx),%eax
  80286e:	3b 43 04             	cmp    0x4(%rbx),%eax
  802871:	75 26                	jne    802899 <devpipe_read+0x7d>
            if (i > 0) return i;
  802873:	4d 85 ff             	test   %r15,%r15
  802876:	75 77                	jne    8028ef <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802878:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80287d:	48 89 da             	mov    %rbx,%rdx
  802880:	be 00 10 00 00       	mov    $0x1000,%esi
  802885:	4c 89 e7             	mov    %r12,%rdi
  802888:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80288b:	85 c0                	test   %eax,%eax
  80288d:	74 72                	je     802901 <devpipe_read+0xe5>
            sys_yield();
  80288f:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802892:	8b 03                	mov    (%rbx),%eax
  802894:	3b 43 04             	cmp    0x4(%rbx),%eax
  802897:	74 df                	je     802878 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802899:	48 63 c8             	movslq %eax,%rcx
  80289c:	48 89 ca             	mov    %rcx,%rdx
  80289f:	48 c1 ea 03          	shr    $0x3,%rdx
  8028a3:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8028aa:	08 10 20 
  8028ad:	48 89 d0             	mov    %rdx,%rax
  8028b0:	48 f7 e6             	mul    %rsi
  8028b3:	48 c1 ea 06          	shr    $0x6,%rdx
  8028b7:	48 89 d0             	mov    %rdx,%rax
  8028ba:	48 c1 e0 09          	shl    $0x9,%rax
  8028be:	48 29 d0             	sub    %rdx,%rax
  8028c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8028c8:	00 
  8028c9:	48 89 c8             	mov    %rcx,%rax
  8028cc:	48 29 d0             	sub    %rdx,%rax
  8028cf:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8028d4:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8028d8:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8028dc:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8028df:	49 83 c7 01          	add    $0x1,%r15
  8028e3:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8028e7:	75 83                	jne    80286c <devpipe_read+0x50>
    return n;
  8028e9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8028ed:	eb 03                	jmp    8028f2 <devpipe_read+0xd6>
            if (i > 0) return i;
  8028ef:	4c 89 f8             	mov    %r15,%rax
}
  8028f2:	48 83 c4 18          	add    $0x18,%rsp
  8028f6:	5b                   	pop    %rbx
  8028f7:	41 5c                	pop    %r12
  8028f9:	41 5d                	pop    %r13
  8028fb:	41 5e                	pop    %r14
  8028fd:	41 5f                	pop    %r15
  8028ff:	5d                   	pop    %rbp
  802900:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802901:	b8 00 00 00 00       	mov    $0x0,%eax
  802906:	eb ea                	jmp    8028f2 <devpipe_read+0xd6>

0000000000802908 <pipe>:
pipe(int pfd[2]) {
  802908:	f3 0f 1e fa          	endbr64
  80290c:	55                   	push   %rbp
  80290d:	48 89 e5             	mov    %rsp,%rbp
  802910:	41 55                	push   %r13
  802912:	41 54                	push   %r12
  802914:	53                   	push   %rbx
  802915:	48 83 ec 18          	sub    $0x18,%rsp
  802919:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  80291c:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802920:	48 b8 f1 1b 80 00 00 	movabs $0x801bf1,%rax
  802927:	00 00 00 
  80292a:	ff d0                	call   *%rax
  80292c:	89 c3                	mov    %eax,%ebx
  80292e:	85 c0                	test   %eax,%eax
  802930:	0f 88 a0 01 00 00    	js     802ad6 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802936:	b9 46 00 00 00       	mov    $0x46,%ecx
  80293b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802940:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802944:	bf 00 00 00 00       	mov    $0x0,%edi
  802949:	48 b8 e2 14 80 00 00 	movabs $0x8014e2,%rax
  802950:	00 00 00 
  802953:	ff d0                	call   *%rax
  802955:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802957:	85 c0                	test   %eax,%eax
  802959:	0f 88 77 01 00 00    	js     802ad6 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80295f:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802963:	48 b8 f1 1b 80 00 00 	movabs $0x801bf1,%rax
  80296a:	00 00 00 
  80296d:	ff d0                	call   *%rax
  80296f:	89 c3                	mov    %eax,%ebx
  802971:	85 c0                	test   %eax,%eax
  802973:	0f 88 43 01 00 00    	js     802abc <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802979:	b9 46 00 00 00       	mov    $0x46,%ecx
  80297e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802983:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802987:	bf 00 00 00 00       	mov    $0x0,%edi
  80298c:	48 b8 e2 14 80 00 00 	movabs $0x8014e2,%rax
  802993:	00 00 00 
  802996:	ff d0                	call   *%rax
  802998:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80299a:	85 c0                	test   %eax,%eax
  80299c:	0f 88 1a 01 00 00    	js     802abc <pipe+0x1b4>
    va = fd2data(fd0);
  8029a2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8029a6:	48 b8 d1 1b 80 00 00 	movabs $0x801bd1,%rax
  8029ad:	00 00 00 
  8029b0:	ff d0                	call   *%rax
  8029b2:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8029b5:	b9 46 00 00 00       	mov    $0x46,%ecx
  8029ba:	ba 00 10 00 00       	mov    $0x1000,%edx
  8029bf:	48 89 c6             	mov    %rax,%rsi
  8029c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8029c7:	48 b8 e2 14 80 00 00 	movabs $0x8014e2,%rax
  8029ce:	00 00 00 
  8029d1:	ff d0                	call   *%rax
  8029d3:	89 c3                	mov    %eax,%ebx
  8029d5:	85 c0                	test   %eax,%eax
  8029d7:	0f 88 c5 00 00 00    	js     802aa2 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8029dd:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8029e1:	48 b8 d1 1b 80 00 00 	movabs $0x801bd1,%rax
  8029e8:	00 00 00 
  8029eb:	ff d0                	call   *%rax
  8029ed:	48 89 c1             	mov    %rax,%rcx
  8029f0:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8029f6:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8029fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802a01:	4c 89 ee             	mov    %r13,%rsi
  802a04:	bf 00 00 00 00       	mov    $0x0,%edi
  802a09:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  802a10:	00 00 00 
  802a13:	ff d0                	call   *%rax
  802a15:	89 c3                	mov    %eax,%ebx
  802a17:	85 c0                	test   %eax,%eax
  802a19:	78 6e                	js     802a89 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802a1b:	be 00 10 00 00       	mov    $0x1000,%esi
  802a20:	4c 89 ef             	mov    %r13,%rdi
  802a23:	48 b8 7c 14 80 00 00 	movabs $0x80147c,%rax
  802a2a:	00 00 00 
  802a2d:	ff d0                	call   *%rax
  802a2f:	83 f8 02             	cmp    $0x2,%eax
  802a32:	0f 85 ab 00 00 00    	jne    802ae3 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802a38:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  802a3f:	00 00 
  802a41:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a45:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802a47:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a4b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802a52:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802a56:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802a58:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a5c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802a63:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802a67:	48 bb bb 1b 80 00 00 	movabs $0x801bbb,%rbx
  802a6e:	00 00 00 
  802a71:	ff d3                	call   *%rbx
  802a73:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802a77:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802a7b:	ff d3                	call   *%rbx
  802a7d:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802a82:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a87:	eb 4d                	jmp    802ad6 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802a89:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a8e:	4c 89 ee             	mov    %r13,%rsi
  802a91:	bf 00 00 00 00       	mov    $0x0,%edi
  802a96:	48 b8 22 16 80 00 00 	movabs $0x801622,%rax
  802a9d:	00 00 00 
  802aa0:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802aa2:	ba 00 10 00 00       	mov    $0x1000,%edx
  802aa7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802aab:	bf 00 00 00 00       	mov    $0x0,%edi
  802ab0:	48 b8 22 16 80 00 00 	movabs $0x801622,%rax
  802ab7:	00 00 00 
  802aba:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802abc:	ba 00 10 00 00       	mov    $0x1000,%edx
  802ac1:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802ac5:	bf 00 00 00 00       	mov    $0x0,%edi
  802aca:	48 b8 22 16 80 00 00 	movabs $0x801622,%rax
  802ad1:	00 00 00 
  802ad4:	ff d0                	call   *%rax
}
  802ad6:	89 d8                	mov    %ebx,%eax
  802ad8:	48 83 c4 18          	add    $0x18,%rsp
  802adc:	5b                   	pop    %rbx
  802add:	41 5c                	pop    %r12
  802adf:	41 5d                	pop    %r13
  802ae1:	5d                   	pop    %rbp
  802ae2:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802ae3:	48 b9 80 44 80 00 00 	movabs $0x804480,%rcx
  802aea:	00 00 00 
  802aed:	48 ba ec 42 80 00 00 	movabs $0x8042ec,%rdx
  802af4:	00 00 00 
  802af7:	be 2e 00 00 00       	mov    $0x2e,%esi
  802afc:	48 bf 13 43 80 00 00 	movabs $0x804313,%rdi
  802b03:	00 00 00 
  802b06:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0b:	49 b8 38 04 80 00 00 	movabs $0x800438,%r8
  802b12:	00 00 00 
  802b15:	41 ff d0             	call   *%r8

0000000000802b18 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802b18:	f3 0f 1e fa          	endbr64
  802b1c:	55                   	push   %rbp
  802b1d:	48 89 e5             	mov    %rsp,%rbp
  802b20:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802b24:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802b28:	48 b8 55 1c 80 00 00 	movabs $0x801c55,%rax
  802b2f:	00 00 00 
  802b32:	ff d0                	call   *%rax
    if (res < 0) return res;
  802b34:	85 c0                	test   %eax,%eax
  802b36:	78 35                	js     802b6d <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802b38:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802b3c:	48 b8 d1 1b 80 00 00 	movabs $0x801bd1,%rax
  802b43:	00 00 00 
  802b46:	ff d0                	call   *%rax
  802b48:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802b4b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802b50:	be 00 10 00 00       	mov    $0x1000,%esi
  802b55:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802b59:	48 b8 b2 14 80 00 00 	movabs $0x8014b2,%rax
  802b60:	00 00 00 
  802b63:	ff d0                	call   *%rax
  802b65:	85 c0                	test   %eax,%eax
  802b67:	0f 94 c0             	sete   %al
  802b6a:	0f b6 c0             	movzbl %al,%eax
}
  802b6d:	c9                   	leave
  802b6e:	c3                   	ret

0000000000802b6f <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802b6f:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802b73:	48 89 f8             	mov    %rdi,%rax
  802b76:	48 c1 e8 27          	shr    $0x27,%rax
  802b7a:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802b81:	7f 00 00 
  802b84:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802b88:	f6 c2 01             	test   $0x1,%dl
  802b8b:	74 6d                	je     802bfa <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802b8d:	48 89 f8             	mov    %rdi,%rax
  802b90:	48 c1 e8 1e          	shr    $0x1e,%rax
  802b94:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802b9b:	7f 00 00 
  802b9e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802ba2:	f6 c2 01             	test   $0x1,%dl
  802ba5:	74 62                	je     802c09 <get_uvpt_entry+0x9a>
  802ba7:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802bae:	7f 00 00 
  802bb1:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802bb5:	f6 c2 80             	test   $0x80,%dl
  802bb8:	75 4f                	jne    802c09 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802bba:	48 89 f8             	mov    %rdi,%rax
  802bbd:	48 c1 e8 15          	shr    $0x15,%rax
  802bc1:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802bc8:	7f 00 00 
  802bcb:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802bcf:	f6 c2 01             	test   $0x1,%dl
  802bd2:	74 44                	je     802c18 <get_uvpt_entry+0xa9>
  802bd4:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802bdb:	7f 00 00 
  802bde:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802be2:	f6 c2 80             	test   $0x80,%dl
  802be5:	75 31                	jne    802c18 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802be7:	48 c1 ef 0c          	shr    $0xc,%rdi
  802beb:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802bf2:	7f 00 00 
  802bf5:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802bf9:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802bfa:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802c01:	7f 00 00 
  802c04:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802c08:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802c09:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802c10:	7f 00 00 
  802c13:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802c17:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802c18:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802c1f:	7f 00 00 
  802c22:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802c26:	c3                   	ret

0000000000802c27 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802c27:	f3 0f 1e fa          	endbr64
  802c2b:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802c2e:	48 89 f9             	mov    %rdi,%rcx
  802c31:	48 c1 e9 27          	shr    $0x27,%rcx
  802c35:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802c3c:	7f 00 00 
  802c3f:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802c43:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802c4a:	f6 c1 01             	test   $0x1,%cl
  802c4d:	0f 84 b2 00 00 00    	je     802d05 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802c53:	48 89 f9             	mov    %rdi,%rcx
  802c56:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802c5a:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802c61:	7f 00 00 
  802c64:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802c68:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802c6f:	40 f6 c6 01          	test   $0x1,%sil
  802c73:	0f 84 8c 00 00 00    	je     802d05 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802c79:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802c80:	7f 00 00 
  802c83:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802c87:	a8 80                	test   $0x80,%al
  802c89:	75 7b                	jne    802d06 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802c8b:	48 89 f9             	mov    %rdi,%rcx
  802c8e:	48 c1 e9 15          	shr    $0x15,%rcx
  802c92:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802c99:	7f 00 00 
  802c9c:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802ca0:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802ca7:	40 f6 c6 01          	test   $0x1,%sil
  802cab:	74 58                	je     802d05 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802cad:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802cb4:	7f 00 00 
  802cb7:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802cbb:	a8 80                	test   $0x80,%al
  802cbd:	75 6c                	jne    802d2b <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802cbf:	48 89 f9             	mov    %rdi,%rcx
  802cc2:	48 c1 e9 0c          	shr    $0xc,%rcx
  802cc6:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802ccd:	7f 00 00 
  802cd0:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802cd4:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802cdb:	40 f6 c6 01          	test   $0x1,%sil
  802cdf:	74 24                	je     802d05 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802ce1:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802ce8:	7f 00 00 
  802ceb:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802cef:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802cf6:	ff ff 7f 
  802cf9:	48 21 c8             	and    %rcx,%rax
  802cfc:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802d02:	48 09 d0             	or     %rdx,%rax
}
  802d05:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802d06:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802d0d:	7f 00 00 
  802d10:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802d14:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802d1b:	ff ff 7f 
  802d1e:	48 21 c8             	and    %rcx,%rax
  802d21:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802d27:	48 01 d0             	add    %rdx,%rax
  802d2a:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802d2b:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802d32:	7f 00 00 
  802d35:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802d39:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802d40:	ff ff 7f 
  802d43:	48 21 c8             	and    %rcx,%rax
  802d46:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802d4c:	48 01 d0             	add    %rdx,%rax
  802d4f:	c3                   	ret

0000000000802d50 <get_prot>:

int
get_prot(void *va) {
  802d50:	f3 0f 1e fa          	endbr64
  802d54:	55                   	push   %rbp
  802d55:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802d58:	48 b8 6f 2b 80 00 00 	movabs $0x802b6f,%rax
  802d5f:	00 00 00 
  802d62:	ff d0                	call   *%rax
  802d64:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802d67:	83 e0 01             	and    $0x1,%eax
  802d6a:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802d6d:	89 d1                	mov    %edx,%ecx
  802d6f:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802d75:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802d77:	89 c1                	mov    %eax,%ecx
  802d79:	83 c9 02             	or     $0x2,%ecx
  802d7c:	f6 c2 02             	test   $0x2,%dl
  802d7f:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802d82:	89 c1                	mov    %eax,%ecx
  802d84:	83 c9 01             	or     $0x1,%ecx
  802d87:	48 85 d2             	test   %rdx,%rdx
  802d8a:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802d8d:	89 c1                	mov    %eax,%ecx
  802d8f:	83 c9 40             	or     $0x40,%ecx
  802d92:	f6 c6 04             	test   $0x4,%dh
  802d95:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802d98:	5d                   	pop    %rbp
  802d99:	c3                   	ret

0000000000802d9a <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802d9a:	f3 0f 1e fa          	endbr64
  802d9e:	55                   	push   %rbp
  802d9f:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802da2:	48 b8 6f 2b 80 00 00 	movabs $0x802b6f,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	call   *%rax
    return pte & PTE_D;
  802dae:	48 c1 e8 06          	shr    $0x6,%rax
  802db2:	83 e0 01             	and    $0x1,%eax
}
  802db5:	5d                   	pop    %rbp
  802db6:	c3                   	ret

0000000000802db7 <is_page_present>:

bool
is_page_present(void *va) {
  802db7:	f3 0f 1e fa          	endbr64
  802dbb:	55                   	push   %rbp
  802dbc:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802dbf:	48 b8 6f 2b 80 00 00 	movabs $0x802b6f,%rax
  802dc6:	00 00 00 
  802dc9:	ff d0                	call   *%rax
  802dcb:	83 e0 01             	and    $0x1,%eax
}
  802dce:	5d                   	pop    %rbp
  802dcf:	c3                   	ret

0000000000802dd0 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802dd0:	f3 0f 1e fa          	endbr64
  802dd4:	55                   	push   %rbp
  802dd5:	48 89 e5             	mov    %rsp,%rbp
  802dd8:	41 57                	push   %r15
  802dda:	41 56                	push   %r14
  802ddc:	41 55                	push   %r13
  802dde:	41 54                	push   %r12
  802de0:	53                   	push   %rbx
  802de1:	48 83 ec 18          	sub    $0x18,%rsp
  802de5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802de9:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802ded:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802df2:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802df9:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802dfc:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802e03:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802e06:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802e0d:	00 00 00 
  802e10:	eb 73                	jmp    802e85 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802e12:	48 89 d8             	mov    %rbx,%rax
  802e15:	48 c1 e8 15          	shr    $0x15,%rax
  802e19:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802e20:	7f 00 00 
  802e23:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802e27:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802e2d:	f6 c2 01             	test   $0x1,%dl
  802e30:	74 4b                	je     802e7d <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802e32:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802e36:	f6 c2 80             	test   $0x80,%dl
  802e39:	74 11                	je     802e4c <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802e3b:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802e3f:	f6 c4 04             	test   $0x4,%ah
  802e42:	74 39                	je     802e7d <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802e44:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802e4a:	eb 20                	jmp    802e6c <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802e4c:	48 89 da             	mov    %rbx,%rdx
  802e4f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802e53:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802e5a:	7f 00 00 
  802e5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802e61:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802e67:	f6 c4 04             	test   $0x4,%ah
  802e6a:	74 11                	je     802e7d <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802e6c:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802e70:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e74:	48 89 df             	mov    %rbx,%rdi
  802e77:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802e7b:	ff d0                	call   *%rax
    next:
        va += size;
  802e7d:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802e80:	49 39 df             	cmp    %rbx,%r15
  802e83:	72 3e                	jb     802ec3 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802e85:	49 8b 06             	mov    (%r14),%rax
  802e88:	a8 01                	test   $0x1,%al
  802e8a:	74 37                	je     802ec3 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802e8c:	48 89 d8             	mov    %rbx,%rax
  802e8f:	48 c1 e8 1e          	shr    $0x1e,%rax
  802e93:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802e98:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802e9e:	f6 c2 01             	test   $0x1,%dl
  802ea1:	74 da                	je     802e7d <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802ea3:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802ea8:	f6 c2 80             	test   $0x80,%dl
  802eab:	0f 84 61 ff ff ff    	je     802e12 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802eb1:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802eb6:	f6 c4 04             	test   $0x4,%ah
  802eb9:	74 c2                	je     802e7d <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802ebb:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802ec1:	eb a9                	jmp    802e6c <foreach_shared_region+0x9c>
    }
    return res;
}
  802ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec8:	48 83 c4 18          	add    $0x18,%rsp
  802ecc:	5b                   	pop    %rbx
  802ecd:	41 5c                	pop    %r12
  802ecf:	41 5d                	pop    %r13
  802ed1:	41 5e                	pop    %r14
  802ed3:	41 5f                	pop    %r15
  802ed5:	5d                   	pop    %rbp
  802ed6:	c3                   	ret

0000000000802ed7 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802ed7:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802edb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee0:	c3                   	ret

0000000000802ee1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802ee1:	f3 0f 1e fa          	endbr64
  802ee5:	55                   	push   %rbp
  802ee6:	48 89 e5             	mov    %rsp,%rbp
  802ee9:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802eec:	48 be 23 43 80 00 00 	movabs $0x804323,%rsi
  802ef3:	00 00 00 
  802ef6:	48 b8 dd 0e 80 00 00 	movabs $0x800edd,%rax
  802efd:	00 00 00 
  802f00:	ff d0                	call   *%rax
    return 0;
}
  802f02:	b8 00 00 00 00       	mov    $0x0,%eax
  802f07:	5d                   	pop    %rbp
  802f08:	c3                   	ret

0000000000802f09 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802f09:	f3 0f 1e fa          	endbr64
  802f0d:	55                   	push   %rbp
  802f0e:	48 89 e5             	mov    %rsp,%rbp
  802f11:	41 57                	push   %r15
  802f13:	41 56                	push   %r14
  802f15:	41 55                	push   %r13
  802f17:	41 54                	push   %r12
  802f19:	53                   	push   %rbx
  802f1a:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802f21:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802f28:	48 85 d2             	test   %rdx,%rdx
  802f2b:	74 7a                	je     802fa7 <devcons_write+0x9e>
  802f2d:	49 89 d6             	mov    %rdx,%r14
  802f30:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802f36:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802f3b:	49 bf f8 10 80 00 00 	movabs $0x8010f8,%r15
  802f42:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802f45:	4c 89 f3             	mov    %r14,%rbx
  802f48:	48 29 f3             	sub    %rsi,%rbx
  802f4b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802f50:	48 39 c3             	cmp    %rax,%rbx
  802f53:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802f57:	4c 63 eb             	movslq %ebx,%r13
  802f5a:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802f61:	48 01 c6             	add    %rax,%rsi
  802f64:	4c 89 ea             	mov    %r13,%rdx
  802f67:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802f6e:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802f71:	4c 89 ee             	mov    %r13,%rsi
  802f74:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802f7b:	48 b8 3d 13 80 00 00 	movabs $0x80133d,%rax
  802f82:	00 00 00 
  802f85:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802f87:	41 01 dc             	add    %ebx,%r12d
  802f8a:	49 63 f4             	movslq %r12d,%rsi
  802f8d:	4c 39 f6             	cmp    %r14,%rsi
  802f90:	72 b3                	jb     802f45 <devcons_write+0x3c>
    return res;
  802f92:	49 63 c4             	movslq %r12d,%rax
}
  802f95:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802f9c:	5b                   	pop    %rbx
  802f9d:	41 5c                	pop    %r12
  802f9f:	41 5d                	pop    %r13
  802fa1:	41 5e                	pop    %r14
  802fa3:	41 5f                	pop    %r15
  802fa5:	5d                   	pop    %rbp
  802fa6:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802fa7:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802fad:	eb e3                	jmp    802f92 <devcons_write+0x89>

0000000000802faf <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802faf:	f3 0f 1e fa          	endbr64
  802fb3:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802fb6:	ba 00 00 00 00       	mov    $0x0,%edx
  802fbb:	48 85 c0             	test   %rax,%rax
  802fbe:	74 55                	je     803015 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802fc0:	55                   	push   %rbp
  802fc1:	48 89 e5             	mov    %rsp,%rbp
  802fc4:	41 55                	push   %r13
  802fc6:	41 54                	push   %r12
  802fc8:	53                   	push   %rbx
  802fc9:	48 83 ec 08          	sub    $0x8,%rsp
  802fcd:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802fd0:	48 bb 6e 13 80 00 00 	movabs $0x80136e,%rbx
  802fd7:	00 00 00 
  802fda:	49 bc 47 14 80 00 00 	movabs $0x801447,%r12
  802fe1:	00 00 00 
  802fe4:	eb 03                	jmp    802fe9 <devcons_read+0x3a>
  802fe6:	41 ff d4             	call   *%r12
  802fe9:	ff d3                	call   *%rbx
  802feb:	85 c0                	test   %eax,%eax
  802fed:	74 f7                	je     802fe6 <devcons_read+0x37>
    if (c < 0) return c;
  802fef:	48 63 d0             	movslq %eax,%rdx
  802ff2:	78 13                	js     803007 <devcons_read+0x58>
    if (c == 0x04) return 0;
  802ff4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ff9:	83 f8 04             	cmp    $0x4,%eax
  802ffc:	74 09                	je     803007 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802ffe:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  803002:	ba 01 00 00 00       	mov    $0x1,%edx
}
  803007:	48 89 d0             	mov    %rdx,%rax
  80300a:	48 83 c4 08          	add    $0x8,%rsp
  80300e:	5b                   	pop    %rbx
  80300f:	41 5c                	pop    %r12
  803011:	41 5d                	pop    %r13
  803013:	5d                   	pop    %rbp
  803014:	c3                   	ret
  803015:	48 89 d0             	mov    %rdx,%rax
  803018:	c3                   	ret

0000000000803019 <cputchar>:
cputchar(int ch) {
  803019:	f3 0f 1e fa          	endbr64
  80301d:	55                   	push   %rbp
  80301e:	48 89 e5             	mov    %rsp,%rbp
  803021:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  803025:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  803029:	be 01 00 00 00       	mov    $0x1,%esi
  80302e:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  803032:	48 b8 3d 13 80 00 00 	movabs $0x80133d,%rax
  803039:	00 00 00 
  80303c:	ff d0                	call   *%rax
}
  80303e:	c9                   	leave
  80303f:	c3                   	ret

0000000000803040 <getchar>:
getchar(void) {
  803040:	f3 0f 1e fa          	endbr64
  803044:	55                   	push   %rbp
  803045:	48 89 e5             	mov    %rsp,%rbp
  803048:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  80304c:	ba 01 00 00 00       	mov    $0x1,%edx
  803051:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  803055:	bf 00 00 00 00       	mov    $0x0,%edi
  80305a:	48 b8 50 1f 80 00 00 	movabs $0x801f50,%rax
  803061:	00 00 00 
  803064:	ff d0                	call   *%rax
  803066:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  803068:	85 c0                	test   %eax,%eax
  80306a:	78 06                	js     803072 <getchar+0x32>
  80306c:	74 08                	je     803076 <getchar+0x36>
  80306e:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  803072:	89 d0                	mov    %edx,%eax
  803074:	c9                   	leave
  803075:	c3                   	ret
    return res < 0 ? res : res ? c :
  803076:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  80307b:	eb f5                	jmp    803072 <getchar+0x32>

000000000080307d <iscons>:
iscons(int fdnum) {
  80307d:	f3 0f 1e fa          	endbr64
  803081:	55                   	push   %rbp
  803082:	48 89 e5             	mov    %rsp,%rbp
  803085:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  803089:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80308d:	48 b8 55 1c 80 00 00 	movabs $0x801c55,%rax
  803094:	00 00 00 
  803097:	ff d0                	call   *%rax
    if (res < 0) return res;
  803099:	85 c0                	test   %eax,%eax
  80309b:	78 18                	js     8030b5 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  80309d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030a1:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  8030a8:	00 00 00 
  8030ab:	8b 00                	mov    (%rax),%eax
  8030ad:	39 02                	cmp    %eax,(%rdx)
  8030af:	0f 94 c0             	sete   %al
  8030b2:	0f b6 c0             	movzbl %al,%eax
}
  8030b5:	c9                   	leave
  8030b6:	c3                   	ret

00000000008030b7 <opencons>:
opencons(void) {
  8030b7:	f3 0f 1e fa          	endbr64
  8030bb:	55                   	push   %rbp
  8030bc:	48 89 e5             	mov    %rsp,%rbp
  8030bf:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8030c3:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8030c7:	48 b8 f1 1b 80 00 00 	movabs $0x801bf1,%rax
  8030ce:	00 00 00 
  8030d1:	ff d0                	call   *%rax
  8030d3:	85 c0                	test   %eax,%eax
  8030d5:	78 49                	js     803120 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8030d7:	b9 46 00 00 00       	mov    $0x46,%ecx
  8030dc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030e1:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  8030e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8030ea:	48 b8 e2 14 80 00 00 	movabs $0x8014e2,%rax
  8030f1:	00 00 00 
  8030f4:	ff d0                	call   *%rax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	78 26                	js     803120 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  8030fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030fe:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  803105:	00 00 
  803107:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  803109:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80310d:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  803114:	48 b8 bb 1b 80 00 00 	movabs $0x801bbb,%rax
  80311b:	00 00 00 
  80311e:	ff d0                	call   *%rax
}
  803120:	c9                   	leave
  803121:	c3                   	ret

0000000000803122 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  803122:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  803125:	48 b8 a8 31 80 00 00 	movabs $0x8031a8,%rax
  80312c:	00 00 00 
    call *%rax
  80312f:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  803131:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  803134:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80313b:	00 
    movq UTRAP_RSP(%rsp), %rsp
  80313c:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  803143:	00 
    pushq %rbx
  803144:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  803145:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  80314c:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  80314f:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  803153:	4c 8b 3c 24          	mov    (%rsp),%r15
  803157:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80315c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803161:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803166:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80316b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803170:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803175:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80317a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80317f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803184:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803189:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80318e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803193:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803198:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80319d:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  8031a1:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  8031a5:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  8031a6:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  8031a7:	c3                   	ret

00000000008031a8 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  8031a8:	f3 0f 1e fa          	endbr64
  8031ac:	55                   	push   %rbp
  8031ad:	48 89 e5             	mov    %rsp,%rbp
  8031b0:	41 56                	push   %r14
  8031b2:	41 55                	push   %r13
  8031b4:	41 54                	push   %r12
  8031b6:	53                   	push   %rbx
  8031b7:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  8031ba:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  8031c1:	00 00 00 
  8031c4:	48 83 38 00          	cmpq   $0x0,(%rax)
  8031c8:	74 27                	je     8031f1 <_handle_vectored_pagefault+0x49>
  8031ca:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  8031cf:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  8031d6:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8031d9:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  8031dc:	4c 89 e7             	mov    %r12,%rdi
  8031df:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  8031e4:	84 c0                	test   %al,%al
  8031e6:	75 45                	jne    80322d <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  8031e8:	48 83 c3 01          	add    $0x1,%rbx
  8031ec:	49 3b 1e             	cmp    (%r14),%rbx
  8031ef:	72 eb                	jb     8031dc <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  8031f1:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  8031f8:	00 
  8031f9:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  8031fe:	4d 8b 04 24          	mov    (%r12),%r8
  803202:	48 ba a8 44 80 00 00 	movabs $0x8044a8,%rdx
  803209:	00 00 00 
  80320c:	be 1d 00 00 00       	mov    $0x1d,%esi
  803211:	48 bf 2f 43 80 00 00 	movabs $0x80432f,%rdi
  803218:	00 00 00 
  80321b:	b8 00 00 00 00       	mov    $0x0,%eax
  803220:	49 ba 38 04 80 00 00 	movabs $0x800438,%r10
  803227:	00 00 00 
  80322a:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  80322d:	5b                   	pop    %rbx
  80322e:	41 5c                	pop    %r12
  803230:	41 5d                	pop    %r13
  803232:	41 5e                	pop    %r14
  803234:	5d                   	pop    %rbp
  803235:	c3                   	ret

0000000000803236 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  803236:	f3 0f 1e fa          	endbr64
  80323a:	55                   	push   %rbp
  80323b:	48 89 e5             	mov    %rsp,%rbp
  80323e:	53                   	push   %rbx
  80323f:	48 83 ec 08          	sub    $0x8,%rsp
  803243:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  803246:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80324d:	00 00 00 
  803250:	80 38 00             	cmpb   $0x0,(%rax)
  803253:	0f 84 84 00 00 00    	je     8032dd <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  803259:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803260:	00 00 00 
  803263:	48 8b 10             	mov    (%rax),%rdx
  803266:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  80326b:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  803272:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803275:	48 85 d2             	test   %rdx,%rdx
  803278:	74 19                	je     803293 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  80327a:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  80327e:	0f 84 e8 00 00 00    	je     80336c <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803284:	48 83 c0 01          	add    $0x1,%rax
  803288:	48 39 d0             	cmp    %rdx,%rax
  80328b:	75 ed                	jne    80327a <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  80328d:	48 83 fa 08          	cmp    $0x8,%rdx
  803291:	74 1c                	je     8032af <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  803293:	48 8d 42 01          	lea    0x1(%rdx),%rax
  803297:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  80329e:	00 00 00 
  8032a1:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8032a8:	00 00 00 
  8032ab:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8032af:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  8032b6:	00 00 00 
  8032b9:	ff d0                	call   *%rax
  8032bb:	89 c7                	mov    %eax,%edi
  8032bd:	48 be 22 31 80 00 00 	movabs $0x803122,%rsi
  8032c4:	00 00 00 
  8032c7:	48 b8 67 17 80 00 00 	movabs $0x801767,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8032d3:	85 c0                	test   %eax,%eax
  8032d5:	78 68                	js     80333f <add_pgfault_handler+0x109>
    return res;
}
  8032d7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8032db:	c9                   	leave
  8032dc:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  8032dd:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  8032e4:	00 00 00 
  8032e7:	ff d0                	call   *%rax
  8032e9:	89 c7                	mov    %eax,%edi
  8032eb:	b9 06 00 00 00       	mov    $0x6,%ecx
  8032f0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8032f5:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  8032fc:	00 00 00 
  8032ff:	48 b8 e2 14 80 00 00 	movabs $0x8014e2,%rax
  803306:	00 00 00 
  803309:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  80330b:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  803312:	00 00 00 
  803315:	48 8b 02             	mov    (%rdx),%rax
  803318:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80331c:	48 89 0a             	mov    %rcx,(%rdx)
  80331f:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803326:	00 00 00 
  803329:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  80332d:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803334:	00 00 00 
  803337:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  80333a:	e9 70 ff ff ff       	jmp    8032af <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  80333f:	89 c1                	mov    %eax,%ecx
  803341:	48 ba 3d 43 80 00 00 	movabs $0x80433d,%rdx
  803348:	00 00 00 
  80334b:	be 3d 00 00 00       	mov    $0x3d,%esi
  803350:	48 bf 2f 43 80 00 00 	movabs $0x80432f,%rdi
  803357:	00 00 00 
  80335a:	b8 00 00 00 00       	mov    $0x0,%eax
  80335f:	49 b8 38 04 80 00 00 	movabs $0x800438,%r8
  803366:	00 00 00 
  803369:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  80336c:	b8 00 00 00 00       	mov    $0x0,%eax
  803371:	e9 61 ff ff ff       	jmp    8032d7 <add_pgfault_handler+0xa1>

0000000000803376 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  803376:	f3 0f 1e fa          	endbr64
  80337a:	55                   	push   %rbp
  80337b:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  80337e:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803385:	00 00 00 
  803388:	80 38 00             	cmpb   $0x0,(%rax)
  80338b:	74 33                	je     8033c0 <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80338d:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  803394:	00 00 00 
  803397:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  80339c:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  8033a3:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8033a6:	48 85 c0             	test   %rax,%rax
  8033a9:	0f 84 85 00 00 00    	je     803434 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  8033af:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  8033b3:	74 40                	je     8033f5 <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8033b5:	48 83 c1 01          	add    $0x1,%rcx
  8033b9:	48 39 c1             	cmp    %rax,%rcx
  8033bc:	75 f1                	jne    8033af <remove_pgfault_handler+0x39>
  8033be:	eb 74                	jmp    803434 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  8033c0:	48 b9 55 43 80 00 00 	movabs $0x804355,%rcx
  8033c7:	00 00 00 
  8033ca:	48 ba ec 42 80 00 00 	movabs $0x8042ec,%rdx
  8033d1:	00 00 00 
  8033d4:	be 43 00 00 00       	mov    $0x43,%esi
  8033d9:	48 bf 2f 43 80 00 00 	movabs $0x80432f,%rdi
  8033e0:	00 00 00 
  8033e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e8:	49 b8 38 04 80 00 00 	movabs $0x800438,%r8
  8033ef:	00 00 00 
  8033f2:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  8033f5:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  8033fc:	00 
  8033fd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803401:	48 29 ca             	sub    %rcx,%rdx
  803404:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80340b:	00 00 00 
  80340e:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  803412:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  803417:	48 89 ce             	mov    %rcx,%rsi
  80341a:	48 b8 f8 10 80 00 00 	movabs $0x8010f8,%rax
  803421:	00 00 00 
  803424:	ff d0                	call   *%rax
            _pfhandler_off--;
  803426:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  80342d:	00 00 00 
  803430:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  803434:	5d                   	pop    %rbp
  803435:	c3                   	ret

0000000000803436 <__text_end>:
  803436:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80343d:	00 00 00 
  803440:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803447:	00 00 00 
  80344a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803451:	00 00 00 
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
