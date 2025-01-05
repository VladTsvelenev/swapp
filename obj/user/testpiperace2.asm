
obj/user/testpiperace2:     file format elf64-x86-64


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
  80001e:	e8 be 02 00 00       	call   8002e1 <libmain>
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
    int p[2], r, i;
    struct Fd *fd;
    const volatile struct Env *kid;

    cprintf("testing for pipeisclosed race...\n");
  80003a:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  800041:	00 00 00 
  800044:	b8 00 00 00 00       	mov    $0x0,%eax
  800049:	48 ba 16 05 80 00 00 	movabs $0x800516,%rdx
  800050:	00 00 00 
  800053:	ff d2                	call   *%rdx
    if ((r = pipe(p)) < 0)
  800055:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  800059:	48 b8 d1 26 80 00 00 	movabs $0x8026d1,%rax
  800060:	00 00 00 
  800063:	ff d0                	call   *%rax
  800065:	85 c0                	test   %eax,%eax
  800067:	0f 88 9d 00 00 00    	js     80010a <umain+0xe5>
        panic("pipe: %i", r);
    if ((r = fork()) < 0)
  80006d:	48 b8 28 18 80 00 00 	movabs $0x801828,%rax
  800074:	00 00 00 
  800077:	ff d0                	call   *%rax
  800079:	89 45 bc             	mov    %eax,-0x44(%rbp)
  80007c:	85 c0                	test   %eax,%eax
  80007e:	0f 88 b3 00 00 00    	js     800137 <umain+0x112>
        panic("fork: %i", r);
    if (r == 0) {
  800084:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  800088:	0f 84 d6 00 00 00    	je     800164 <umain+0x13f>
     * it shouldn't.
     *
     * So either way, pipeisclosed is going give a wrong answer. */

    kid = &envs[ENVX(r)];
    while (kid->env_status == ENV_RUNNABLE) {
  80008e:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800091:	25 ff 03 00 00       	and    $0x3ff,%eax
  800096:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80009a:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80009e:	48 c1 e0 04          	shl    $0x4,%rax
  8000a2:	48 bb 00 00 a0 1f 80 	movabs $0x801fa00000,%rbx
  8000a9:	00 00 00 
  8000ac:	48 01 c3             	add    %rax,%rbx
        if (pipeisclosed(p[0]) != 0) {
  8000af:	49 bc e1 28 80 00 00 	movabs $0x8028e1,%r12
  8000b6:	00 00 00 
    while (kid->env_status == ENV_RUNNABLE) {
  8000b9:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
  8000bf:	83 f8 02             	cmp    $0x2,%eax
  8000c2:	0f 85 43 01 00 00    	jne    80020b <umain+0x1e6>
        if (pipeisclosed(p[0]) != 0) {
  8000c8:	8b 7d c8             	mov    -0x38(%rbp),%edi
  8000cb:	41 ff d4             	call   *%r12
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	74 e7                	je     8000b9 <umain+0x94>
            cprintf("\nRACE: pipe appears closed\n");
  8000d2:	48 bf 8b 41 80 00 00 	movabs $0x80418b,%rdi
  8000d9:	00 00 00 
  8000dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e1:	48 ba 16 05 80 00 00 	movabs $0x800516,%rdx
  8000e8:	00 00 00 
  8000eb:	ff d2                	call   *%rdx
            sys_env_destroy(r);
  8000ed:	8b 7d bc             	mov    -0x44(%rbp),%edi
  8000f0:	48 b8 25 13 80 00 00 	movabs $0x801325,%rax
  8000f7:	00 00 00 
  8000fa:	ff d0                	call   *%rax
            exit();
  8000fc:	48 b8 93 03 80 00 00 	movabs $0x800393,%rax
  800103:	00 00 00 
  800106:	ff d0                	call   *%rax
  800108:	eb af                	jmp    8000b9 <umain+0x94>
        panic("pipe: %i", r);
  80010a:	89 c1                	mov    %eax,%ecx
  80010c:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  800113:	00 00 00 
  800116:	be 0c 00 00 00       	mov    $0xc,%esi
  80011b:	48 bf 69 41 80 00 00 	movabs $0x804169,%rdi
  800122:	00 00 00 
  800125:	b8 00 00 00 00       	mov    $0x0,%eax
  80012a:	49 b8 ba 03 80 00 00 	movabs $0x8003ba,%r8
  800131:	00 00 00 
  800134:	41 ff d0             	call   *%r8
        panic("fork: %i", r);
  800137:	89 c1                	mov    %eax,%ecx
  800139:	48 ba 7e 41 80 00 00 	movabs $0x80417e,%rdx
  800140:	00 00 00 
  800143:	be 0e 00 00 00       	mov    $0xe,%esi
  800148:	48 bf 69 41 80 00 00 	movabs $0x804169,%rdi
  80014f:	00 00 00 
  800152:	b8 00 00 00 00       	mov    $0x0,%eax
  800157:	49 b8 ba 03 80 00 00 	movabs $0x8003ba,%r8
  80015e:	00 00 00 
  800161:	41 ff d0             	call   *%r8
        close(p[1]);
  800164:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800167:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  80016e:	00 00 00 
  800171:	ff d0                	call   *%rax
        for (i = 0; i < 200; i++) {
  800173:	8b 5d bc             	mov    -0x44(%rbp),%ebx
                cprintf("%d.", i);
  800176:	49 bf 87 41 80 00 00 	movabs $0x804187,%r15
  80017d:	00 00 00 
  800180:	49 be 16 05 80 00 00 	movabs $0x800516,%r14
  800187:	00 00 00 
            dup(p[0], 10);
  80018a:	49 bd f2 1b 80 00 00 	movabs $0x801bf2,%r13
  800191:	00 00 00 
            sys_yield();
  800194:	49 bc c9 13 80 00 00 	movabs $0x8013c9,%r12
  80019b:	00 00 00 
  80019e:	eb 2d                	jmp    8001cd <umain+0x1a8>
            dup(p[0], 10);
  8001a0:	be 0a 00 00 00       	mov    $0xa,%esi
  8001a5:	8b 7d c8             	mov    -0x38(%rbp),%edi
  8001a8:	41 ff d5             	call   *%r13
            sys_yield();
  8001ab:	41 ff d4             	call   *%r12
            close(10);
  8001ae:	bf 0a 00 00 00       	mov    $0xa,%edi
  8001b3:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  8001ba:	00 00 00 
  8001bd:	ff d0                	call   *%rax
            sys_yield();
  8001bf:	41 ff d4             	call   *%r12
        for (i = 0; i < 200; i++) {
  8001c2:	83 c3 01             	add    $0x1,%ebx
  8001c5:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  8001cb:	74 2d                	je     8001fa <umain+0x1d5>
            if (i % 10 == 0)
  8001cd:	48 63 c3             	movslq %ebx,%rax
  8001d0:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
  8001d7:	48 c1 f8 22          	sar    $0x22,%rax
  8001db:	89 da                	mov    %ebx,%edx
  8001dd:	c1 fa 1f             	sar    $0x1f,%edx
  8001e0:	29 d0                	sub    %edx,%eax
  8001e2:	8d 04 80             	lea    (%rax,%rax,4),%eax
  8001e5:	01 c0                	add    %eax,%eax
  8001e7:	39 c3                	cmp    %eax,%ebx
  8001e9:	75 b5                	jne    8001a0 <umain+0x17b>
                cprintf("%d.", i);
  8001eb:	89 de                	mov    %ebx,%esi
  8001ed:	4c 89 ff             	mov    %r15,%rdi
  8001f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f5:	41 ff d6             	call   *%r14
  8001f8:	eb a6                	jmp    8001a0 <umain+0x17b>
        exit();
  8001fa:	48 b8 93 03 80 00 00 	movabs $0x800393,%rax
  800201:	00 00 00 
  800204:	ff d0                	call   *%rax
  800206:	e9 83 fe ff ff       	jmp    80008e <umain+0x69>
        }
    }
    cprintf("child done with loop\n");
  80020b:	48 bf a7 41 80 00 00 	movabs $0x8041a7,%rdi
  800212:	00 00 00 
  800215:	b8 00 00 00 00       	mov    $0x0,%eax
  80021a:	48 ba 16 05 80 00 00 	movabs $0x800516,%rdx
  800221:	00 00 00 
  800224:	ff d2                	call   *%rdx
    if (pipeisclosed(p[0]))
  800226:	8b 7d c8             	mov    -0x38(%rbp),%edi
  800229:	48 b8 e1 28 80 00 00 	movabs $0x8028e1,%rax
  800230:	00 00 00 
  800233:	ff d0                	call   *%rax
  800235:	85 c0                	test   %eax,%eax
  800237:	75 51                	jne    80028a <umain+0x265>
        panic("somehow the other end of p[0] got closed!");
    if ((r = fd_lookup(p[0], &fd)) < 0)
  800239:	48 8d 75 c0          	lea    -0x40(%rbp),%rsi
  80023d:	8b 7d c8             	mov    -0x38(%rbp),%edi
  800240:	48 b8 1e 1a 80 00 00 	movabs $0x801a1e,%rax
  800247:	00 00 00 
  80024a:	ff d0                	call   *%rax
  80024c:	85 c0                	test   %eax,%eax
  80024e:	78 64                	js     8002b4 <umain+0x28f>
        panic("cannot look up p[0]: %i", r);
    USED(fd2data(fd));
  800250:	48 8b 7d c0          	mov    -0x40(%rbp),%rdi
  800254:	48 b8 9a 19 80 00 00 	movabs $0x80199a,%rax
  80025b:	00 00 00 
  80025e:	ff d0                	call   *%rax
    cprintf("race didn't happen\n");
  800260:	48 bf d5 41 80 00 00 	movabs $0x8041d5,%rdi
  800267:	00 00 00 
  80026a:	b8 00 00 00 00       	mov    $0x0,%eax
  80026f:	48 ba 16 05 80 00 00 	movabs $0x800516,%rdx
  800276:	00 00 00 
  800279:	ff d2                	call   *%rdx
}
  80027b:	48 83 c4 28          	add    $0x28,%rsp
  80027f:	5b                   	pop    %rbx
  800280:	41 5c                	pop    %r12
  800282:	41 5d                	pop    %r13
  800284:	41 5e                	pop    %r14
  800286:	41 5f                	pop    %r15
  800288:	5d                   	pop    %rbp
  800289:	c3                   	ret
        panic("somehow the other end of p[0] got closed!");
  80028a:	48 ba 28 40 80 00 00 	movabs $0x804028,%rdx
  800291:	00 00 00 
  800294:	be 40 00 00 00       	mov    $0x40,%esi
  800299:	48 bf 69 41 80 00 00 	movabs $0x804169,%rdi
  8002a0:	00 00 00 
  8002a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a8:	48 b9 ba 03 80 00 00 	movabs $0x8003ba,%rcx
  8002af:	00 00 00 
  8002b2:	ff d1                	call   *%rcx
        panic("cannot look up p[0]: %i", r);
  8002b4:	89 c1                	mov    %eax,%ecx
  8002b6:	48 ba bd 41 80 00 00 	movabs $0x8041bd,%rdx
  8002bd:	00 00 00 
  8002c0:	be 42 00 00 00       	mov    $0x42,%esi
  8002c5:	48 bf 69 41 80 00 00 	movabs $0x804169,%rdi
  8002cc:	00 00 00 
  8002cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d4:	49 b8 ba 03 80 00 00 	movabs $0x8003ba,%r8
  8002db:	00 00 00 
  8002de:	41 ff d0             	call   *%r8

00000000008002e1 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8002e1:	f3 0f 1e fa          	endbr64
  8002e5:	55                   	push   %rbp
  8002e6:	48 89 e5             	mov    %rsp,%rbp
  8002e9:	41 56                	push   %r14
  8002eb:	41 55                	push   %r13
  8002ed:	41 54                	push   %r12
  8002ef:	53                   	push   %rbx
  8002f0:	41 89 fd             	mov    %edi,%r13d
  8002f3:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8002f6:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  8002fd:	00 00 00 
  800300:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  800307:	00 00 00 
  80030a:	48 39 c2             	cmp    %rax,%rdx
  80030d:	73 17                	jae    800326 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80030f:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800312:	49 89 c4             	mov    %rax,%r12
  800315:	48 83 c3 08          	add    $0x8,%rbx
  800319:	b8 00 00 00 00       	mov    $0x0,%eax
  80031e:	ff 53 f8             	call   *-0x8(%rbx)
  800321:	4c 39 e3             	cmp    %r12,%rbx
  800324:	72 ef                	jb     800315 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800326:	48 b8 94 13 80 00 00 	movabs $0x801394,%rax
  80032d:	00 00 00 
  800330:	ff d0                	call   *%rax
  800332:	25 ff 03 00 00       	and    $0x3ff,%eax
  800337:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80033b:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80033f:	48 c1 e0 04          	shl    $0x4,%rax
  800343:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  80034a:	00 00 00 
  80034d:	48 01 d0             	add    %rdx,%rax
  800350:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  800357:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80035a:	45 85 ed             	test   %r13d,%r13d
  80035d:	7e 0d                	jle    80036c <libmain+0x8b>
  80035f:	49 8b 06             	mov    (%r14),%rax
  800362:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800369:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80036c:	4c 89 f6             	mov    %r14,%rsi
  80036f:	44 89 ef             	mov    %r13d,%edi
  800372:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800379:	00 00 00 
  80037c:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80037e:	48 b8 93 03 80 00 00 	movabs $0x800393,%rax
  800385:	00 00 00 
  800388:	ff d0                	call   *%rax
#endif
}
  80038a:	5b                   	pop    %rbx
  80038b:	41 5c                	pop    %r12
  80038d:	41 5d                	pop    %r13
  80038f:	41 5e                	pop    %r14
  800391:	5d                   	pop    %rbp
  800392:	c3                   	ret

0000000000800393 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800393:	f3 0f 1e fa          	endbr64
  800397:	55                   	push   %rbp
  800398:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80039b:	48 b8 c6 1b 80 00 00 	movabs $0x801bc6,%rax
  8003a2:	00 00 00 
  8003a5:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8003a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8003ac:	48 b8 25 13 80 00 00 	movabs $0x801325,%rax
  8003b3:	00 00 00 
  8003b6:	ff d0                	call   *%rax
}
  8003b8:	5d                   	pop    %rbp
  8003b9:	c3                   	ret

00000000008003ba <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8003ba:	f3 0f 1e fa          	endbr64
  8003be:	55                   	push   %rbp
  8003bf:	48 89 e5             	mov    %rsp,%rbp
  8003c2:	41 56                	push   %r14
  8003c4:	41 55                	push   %r13
  8003c6:	41 54                	push   %r12
  8003c8:	53                   	push   %rbx
  8003c9:	48 83 ec 50          	sub    $0x50,%rsp
  8003cd:	49 89 fc             	mov    %rdi,%r12
  8003d0:	41 89 f5             	mov    %esi,%r13d
  8003d3:	48 89 d3             	mov    %rdx,%rbx
  8003d6:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8003da:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8003de:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8003e2:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8003e9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003ed:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8003f1:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8003f5:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8003f9:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800400:	00 00 00 
  800403:	4c 8b 30             	mov    (%rax),%r14
  800406:	48 b8 94 13 80 00 00 	movabs $0x801394,%rax
  80040d:	00 00 00 
  800410:	ff d0                	call   *%rax
  800412:	89 c6                	mov    %eax,%esi
  800414:	45 89 e8             	mov    %r13d,%r8d
  800417:	4c 89 e1             	mov    %r12,%rcx
  80041a:	4c 89 f2             	mov    %r14,%rdx
  80041d:	48 bf 58 40 80 00 00 	movabs $0x804058,%rdi
  800424:	00 00 00 
  800427:	b8 00 00 00 00       	mov    $0x0,%eax
  80042c:	49 bc 16 05 80 00 00 	movabs $0x800516,%r12
  800433:	00 00 00 
  800436:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800439:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  80043d:	48 89 df             	mov    %rbx,%rdi
  800440:	48 b8 ae 04 80 00 00 	movabs $0x8004ae,%rax
  800447:	00 00 00 
  80044a:	ff d0                	call   *%rax
    cprintf("\n");
  80044c:	48 bf a5 41 80 00 00 	movabs $0x8041a5,%rdi
  800453:	00 00 00 
  800456:	b8 00 00 00 00       	mov    $0x0,%eax
  80045b:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80045e:	cc                   	int3
  80045f:	eb fd                	jmp    80045e <_panic+0xa4>

0000000000800461 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800461:	f3 0f 1e fa          	endbr64
  800465:	55                   	push   %rbp
  800466:	48 89 e5             	mov    %rsp,%rbp
  800469:	53                   	push   %rbx
  80046a:	48 83 ec 08          	sub    $0x8,%rsp
  80046e:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800471:	8b 06                	mov    (%rsi),%eax
  800473:	8d 50 01             	lea    0x1(%rax),%edx
  800476:	89 16                	mov    %edx,(%rsi)
  800478:	48 98                	cltq
  80047a:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80047f:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800485:	74 0a                	je     800491 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800487:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80048b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80048f:	c9                   	leave
  800490:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800491:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800495:	be ff 00 00 00       	mov    $0xff,%esi
  80049a:	48 b8 bf 12 80 00 00 	movabs $0x8012bf,%rax
  8004a1:	00 00 00 
  8004a4:	ff d0                	call   *%rax
        state->offset = 0;
  8004a6:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8004ac:	eb d9                	jmp    800487 <putch+0x26>

00000000008004ae <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8004ae:	f3 0f 1e fa          	endbr64
  8004b2:	55                   	push   %rbp
  8004b3:	48 89 e5             	mov    %rsp,%rbp
  8004b6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8004bd:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8004c0:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8004c7:	b9 21 00 00 00       	mov    $0x21,%ecx
  8004cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d1:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8004d4:	48 89 f1             	mov    %rsi,%rcx
  8004d7:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8004de:	48 bf 61 04 80 00 00 	movabs $0x800461,%rdi
  8004e5:	00 00 00 
  8004e8:	48 b8 76 06 80 00 00 	movabs $0x800676,%rax
  8004ef:	00 00 00 
  8004f2:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8004f4:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8004fb:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800502:	48 b8 bf 12 80 00 00 	movabs $0x8012bf,%rax
  800509:	00 00 00 
  80050c:	ff d0                	call   *%rax

    return state.count;
}
  80050e:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800514:	c9                   	leave
  800515:	c3                   	ret

0000000000800516 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800516:	f3 0f 1e fa          	endbr64
  80051a:	55                   	push   %rbp
  80051b:	48 89 e5             	mov    %rsp,%rbp
  80051e:	48 83 ec 50          	sub    $0x50,%rsp
  800522:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800526:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80052a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80052e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800532:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800536:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80053d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800541:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800545:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800549:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80054d:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800551:	48 b8 ae 04 80 00 00 	movabs $0x8004ae,%rax
  800558:	00 00 00 
  80055b:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80055d:	c9                   	leave
  80055e:	c3                   	ret

000000000080055f <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80055f:	f3 0f 1e fa          	endbr64
  800563:	55                   	push   %rbp
  800564:	48 89 e5             	mov    %rsp,%rbp
  800567:	41 57                	push   %r15
  800569:	41 56                	push   %r14
  80056b:	41 55                	push   %r13
  80056d:	41 54                	push   %r12
  80056f:	53                   	push   %rbx
  800570:	48 83 ec 18          	sub    $0x18,%rsp
  800574:	49 89 fc             	mov    %rdi,%r12
  800577:	49 89 f5             	mov    %rsi,%r13
  80057a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80057e:	8b 45 10             	mov    0x10(%rbp),%eax
  800581:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800584:	41 89 cf             	mov    %ecx,%r15d
  800587:	4c 39 fa             	cmp    %r15,%rdx
  80058a:	73 5b                	jae    8005e7 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80058c:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800590:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800594:	85 db                	test   %ebx,%ebx
  800596:	7e 0e                	jle    8005a6 <print_num+0x47>
            putch(padc, put_arg);
  800598:	4c 89 ee             	mov    %r13,%rsi
  80059b:	44 89 f7             	mov    %r14d,%edi
  80059e:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8005a1:	83 eb 01             	sub    $0x1,%ebx
  8005a4:	75 f2                	jne    800598 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8005a6:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8005aa:	48 b9 04 42 80 00 00 	movabs $0x804204,%rcx
  8005b1:	00 00 00 
  8005b4:	48 b8 f3 41 80 00 00 	movabs $0x8041f3,%rax
  8005bb:	00 00 00 
  8005be:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8005c2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	49 f7 f7             	div    %r15
  8005ce:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8005d2:	4c 89 ee             	mov    %r13,%rsi
  8005d5:	41 ff d4             	call   *%r12
}
  8005d8:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8005dc:	5b                   	pop    %rbx
  8005dd:	41 5c                	pop    %r12
  8005df:	41 5d                	pop    %r13
  8005e1:	41 5e                	pop    %r14
  8005e3:	41 5f                	pop    %r15
  8005e5:	5d                   	pop    %rbp
  8005e6:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8005e7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8005eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f0:	49 f7 f7             	div    %r15
  8005f3:	48 83 ec 08          	sub    $0x8,%rsp
  8005f7:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8005fb:	52                   	push   %rdx
  8005fc:	45 0f be c9          	movsbl %r9b,%r9d
  800600:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800604:	48 89 c2             	mov    %rax,%rdx
  800607:	48 b8 5f 05 80 00 00 	movabs $0x80055f,%rax
  80060e:	00 00 00 
  800611:	ff d0                	call   *%rax
  800613:	48 83 c4 10          	add    $0x10,%rsp
  800617:	eb 8d                	jmp    8005a6 <print_num+0x47>

0000000000800619 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800619:	f3 0f 1e fa          	endbr64
    state->count++;
  80061d:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800621:	48 8b 06             	mov    (%rsi),%rax
  800624:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800628:	73 0a                	jae    800634 <sprintputch+0x1b>
        *state->start++ = ch;
  80062a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80062e:	48 89 16             	mov    %rdx,(%rsi)
  800631:	40 88 38             	mov    %dil,(%rax)
    }
}
  800634:	c3                   	ret

0000000000800635 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800635:	f3 0f 1e fa          	endbr64
  800639:	55                   	push   %rbp
  80063a:	48 89 e5             	mov    %rsp,%rbp
  80063d:	48 83 ec 50          	sub    $0x50,%rsp
  800641:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800645:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800649:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80064d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800654:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800658:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80065c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800660:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800664:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800668:	48 b8 76 06 80 00 00 	movabs $0x800676,%rax
  80066f:	00 00 00 
  800672:	ff d0                	call   *%rax
}
  800674:	c9                   	leave
  800675:	c3                   	ret

0000000000800676 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800676:	f3 0f 1e fa          	endbr64
  80067a:	55                   	push   %rbp
  80067b:	48 89 e5             	mov    %rsp,%rbp
  80067e:	41 57                	push   %r15
  800680:	41 56                	push   %r14
  800682:	41 55                	push   %r13
  800684:	41 54                	push   %r12
  800686:	53                   	push   %rbx
  800687:	48 83 ec 38          	sub    $0x38,%rsp
  80068b:	49 89 fe             	mov    %rdi,%r14
  80068e:	49 89 f5             	mov    %rsi,%r13
  800691:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800694:	48 8b 01             	mov    (%rcx),%rax
  800697:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80069b:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80069f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006a3:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8006a7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8006ab:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  8006af:	0f b6 3b             	movzbl (%rbx),%edi
  8006b2:	40 80 ff 25          	cmp    $0x25,%dil
  8006b6:	74 18                	je     8006d0 <vprintfmt+0x5a>
            if (!ch) return;
  8006b8:	40 84 ff             	test   %dil,%dil
  8006bb:	0f 84 b2 06 00 00    	je     800d73 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8006c1:	40 0f b6 ff          	movzbl %dil,%edi
  8006c5:	4c 89 ee             	mov    %r13,%rsi
  8006c8:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8006cb:	4c 89 e3             	mov    %r12,%rbx
  8006ce:	eb db                	jmp    8006ab <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8006d0:	be 00 00 00 00       	mov    $0x0,%esi
  8006d5:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8006d9:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8006de:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8006e4:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8006eb:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8006ef:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8006f4:	41 0f b6 04 24       	movzbl (%r12),%eax
  8006f9:	88 45 a0             	mov    %al,-0x60(%rbp)
  8006fc:	83 e8 23             	sub    $0x23,%eax
  8006ff:	3c 57                	cmp    $0x57,%al
  800701:	0f 87 52 06 00 00    	ja     800d59 <vprintfmt+0x6e3>
  800707:	0f b6 c0             	movzbl %al,%eax
  80070a:	48 b9 c0 44 80 00 00 	movabs $0x8044c0,%rcx
  800711:	00 00 00 
  800714:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800718:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  80071b:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  80071f:	eb ce                	jmp    8006ef <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800721:	49 89 dc             	mov    %rbx,%r12
  800724:	be 01 00 00 00       	mov    $0x1,%esi
  800729:	eb c4                	jmp    8006ef <vprintfmt+0x79>
            padc = ch;
  80072b:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  80072f:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800732:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800735:	eb b8                	jmp    8006ef <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800737:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80073a:	83 f8 2f             	cmp    $0x2f,%eax
  80073d:	77 24                	ja     800763 <vprintfmt+0xed>
  80073f:	89 c1                	mov    %eax,%ecx
  800741:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800745:	83 c0 08             	add    $0x8,%eax
  800748:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80074b:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  80074e:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800751:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800755:	79 98                	jns    8006ef <vprintfmt+0x79>
                width = precision;
  800757:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  80075b:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800761:	eb 8c                	jmp    8006ef <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800763:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800767:	48 8d 41 08          	lea    0x8(%rcx),%rax
  80076b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80076f:	eb da                	jmp    80074b <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800771:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800776:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80077a:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800780:	3c 39                	cmp    $0x39,%al
  800782:	77 1c                	ja     8007a0 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800784:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800788:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80078c:	0f b6 c0             	movzbl %al,%eax
  80078f:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800794:	0f b6 03             	movzbl (%rbx),%eax
  800797:	3c 39                	cmp    $0x39,%al
  800799:	76 e9                	jbe    800784 <vprintfmt+0x10e>
        process_precision:
  80079b:	49 89 dc             	mov    %rbx,%r12
  80079e:	eb b1                	jmp    800751 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  8007a0:	49 89 dc             	mov    %rbx,%r12
  8007a3:	eb ac                	jmp    800751 <vprintfmt+0xdb>
            width = MAX(0, width);
  8007a5:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  8007a8:	85 c9                	test   %ecx,%ecx
  8007aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8007af:	0f 49 c1             	cmovns %ecx,%eax
  8007b2:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8007b5:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8007b8:	e9 32 ff ff ff       	jmp    8006ef <vprintfmt+0x79>
            lflag++;
  8007bd:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8007c0:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8007c3:	e9 27 ff ff ff       	jmp    8006ef <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8007c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007cb:	83 f8 2f             	cmp    $0x2f,%eax
  8007ce:	77 19                	ja     8007e9 <vprintfmt+0x173>
  8007d0:	89 c2                	mov    %eax,%edx
  8007d2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007d6:	83 c0 08             	add    $0x8,%eax
  8007d9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007dc:	8b 3a                	mov    (%rdx),%edi
  8007de:	4c 89 ee             	mov    %r13,%rsi
  8007e1:	41 ff d6             	call   *%r14
            break;
  8007e4:	e9 c2 fe ff ff       	jmp    8006ab <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8007e9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007ed:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007f1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007f5:	eb e5                	jmp    8007dc <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8007f7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007fa:	83 f8 2f             	cmp    $0x2f,%eax
  8007fd:	77 5a                	ja     800859 <vprintfmt+0x1e3>
  8007ff:	89 c2                	mov    %eax,%edx
  800801:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800805:	83 c0 08             	add    $0x8,%eax
  800808:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  80080b:	8b 02                	mov    (%rdx),%eax
  80080d:	89 c1                	mov    %eax,%ecx
  80080f:	f7 d9                	neg    %ecx
  800811:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800814:	83 f9 13             	cmp    $0x13,%ecx
  800817:	7f 4e                	jg     800867 <vprintfmt+0x1f1>
  800819:	48 63 c1             	movslq %ecx,%rax
  80081c:	48 ba 80 47 80 00 00 	movabs $0x804780,%rdx
  800823:	00 00 00 
  800826:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80082a:	48 85 c0             	test   %rax,%rax
  80082d:	74 38                	je     800867 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  80082f:	48 89 c1             	mov    %rax,%rcx
  800832:	48 ba 1e 44 80 00 00 	movabs $0x80441e,%rdx
  800839:	00 00 00 
  80083c:	4c 89 ee             	mov    %r13,%rsi
  80083f:	4c 89 f7             	mov    %r14,%rdi
  800842:	b8 00 00 00 00       	mov    $0x0,%eax
  800847:	49 b8 35 06 80 00 00 	movabs $0x800635,%r8
  80084e:	00 00 00 
  800851:	41 ff d0             	call   *%r8
  800854:	e9 52 fe ff ff       	jmp    8006ab <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800859:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80085d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800861:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800865:	eb a4                	jmp    80080b <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800867:	48 ba 1c 42 80 00 00 	movabs $0x80421c,%rdx
  80086e:	00 00 00 
  800871:	4c 89 ee             	mov    %r13,%rsi
  800874:	4c 89 f7             	mov    %r14,%rdi
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	49 b8 35 06 80 00 00 	movabs $0x800635,%r8
  800883:	00 00 00 
  800886:	41 ff d0             	call   *%r8
  800889:	e9 1d fe ff ff       	jmp    8006ab <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80088e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800891:	83 f8 2f             	cmp    $0x2f,%eax
  800894:	77 6c                	ja     800902 <vprintfmt+0x28c>
  800896:	89 c2                	mov    %eax,%edx
  800898:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80089c:	83 c0 08             	add    $0x8,%eax
  80089f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008a2:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8008a5:	48 85 d2             	test   %rdx,%rdx
  8008a8:	48 b8 15 42 80 00 00 	movabs $0x804215,%rax
  8008af:	00 00 00 
  8008b2:	48 0f 45 c2          	cmovne %rdx,%rax
  8008b6:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8008ba:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8008be:	7e 06                	jle    8008c6 <vprintfmt+0x250>
  8008c0:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8008c4:	75 4a                	jne    800910 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8008c6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8008ca:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8008ce:	0f b6 00             	movzbl (%rax),%eax
  8008d1:	84 c0                	test   %al,%al
  8008d3:	0f 85 9a 00 00 00    	jne    800973 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8008d9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8008dc:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8008e0:	85 c0                	test   %eax,%eax
  8008e2:	0f 8e c3 fd ff ff    	jle    8006ab <vprintfmt+0x35>
  8008e8:	4c 89 ee             	mov    %r13,%rsi
  8008eb:	bf 20 00 00 00       	mov    $0x20,%edi
  8008f0:	41 ff d6             	call   *%r14
  8008f3:	41 83 ec 01          	sub    $0x1,%r12d
  8008f7:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8008fb:	75 eb                	jne    8008e8 <vprintfmt+0x272>
  8008fd:	e9 a9 fd ff ff       	jmp    8006ab <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800902:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800906:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80090a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80090e:	eb 92                	jmp    8008a2 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800910:	49 63 f7             	movslq %r15d,%rsi
  800913:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800917:	48 b8 39 0e 80 00 00 	movabs $0x800e39,%rax
  80091e:	00 00 00 
  800921:	ff d0                	call   *%rax
  800923:	48 89 c2             	mov    %rax,%rdx
  800926:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800929:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80092b:	8d 70 ff             	lea    -0x1(%rax),%esi
  80092e:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800931:	85 c0                	test   %eax,%eax
  800933:	7e 91                	jle    8008c6 <vprintfmt+0x250>
  800935:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80093a:	4c 89 ee             	mov    %r13,%rsi
  80093d:	44 89 e7             	mov    %r12d,%edi
  800940:	41 ff d6             	call   *%r14
  800943:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800947:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80094a:	83 f8 ff             	cmp    $0xffffffff,%eax
  80094d:	75 eb                	jne    80093a <vprintfmt+0x2c4>
  80094f:	e9 72 ff ff ff       	jmp    8008c6 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800954:	0f b6 f8             	movzbl %al,%edi
  800957:	4c 89 ee             	mov    %r13,%rsi
  80095a:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80095d:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800961:	49 83 c4 01          	add    $0x1,%r12
  800965:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  80096b:	84 c0                	test   %al,%al
  80096d:	0f 84 66 ff ff ff    	je     8008d9 <vprintfmt+0x263>
  800973:	45 85 ff             	test   %r15d,%r15d
  800976:	78 0a                	js     800982 <vprintfmt+0x30c>
  800978:	41 83 ef 01          	sub    $0x1,%r15d
  80097c:	0f 88 57 ff ff ff    	js     8008d9 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800982:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800986:	74 cc                	je     800954 <vprintfmt+0x2de>
  800988:	8d 50 e0             	lea    -0x20(%rax),%edx
  80098b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800990:	80 fa 5e             	cmp    $0x5e,%dl
  800993:	77 c2                	ja     800957 <vprintfmt+0x2e1>
  800995:	eb bd                	jmp    800954 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800997:	40 84 f6             	test   %sil,%sil
  80099a:	75 26                	jne    8009c2 <vprintfmt+0x34c>
    switch (lflag) {
  80099c:	85 d2                	test   %edx,%edx
  80099e:	74 59                	je     8009f9 <vprintfmt+0x383>
  8009a0:	83 fa 01             	cmp    $0x1,%edx
  8009a3:	74 7b                	je     800a20 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8009a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a8:	83 f8 2f             	cmp    $0x2f,%eax
  8009ab:	0f 87 96 00 00 00    	ja     800a47 <vprintfmt+0x3d1>
  8009b1:	89 c2                	mov    %eax,%edx
  8009b3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009b7:	83 c0 08             	add    $0x8,%eax
  8009ba:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009bd:	4c 8b 22             	mov    (%rdx),%r12
  8009c0:	eb 17                	jmp    8009d9 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8009c2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c5:	83 f8 2f             	cmp    $0x2f,%eax
  8009c8:	77 21                	ja     8009eb <vprintfmt+0x375>
  8009ca:	89 c2                	mov    %eax,%edx
  8009cc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009d0:	83 c0 08             	add    $0x8,%eax
  8009d3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d6:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8009d9:	4d 85 e4             	test   %r12,%r12
  8009dc:	78 7a                	js     800a58 <vprintfmt+0x3e2>
            num = i;
  8009de:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8009e1:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8009e6:	e9 50 02 00 00       	jmp    800c3b <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8009eb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ef:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009f3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009f7:	eb dd                	jmp    8009d6 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8009f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fc:	83 f8 2f             	cmp    $0x2f,%eax
  8009ff:	77 11                	ja     800a12 <vprintfmt+0x39c>
  800a01:	89 c2                	mov    %eax,%edx
  800a03:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a07:	83 c0 08             	add    $0x8,%eax
  800a0a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a0d:	4c 63 22             	movslq (%rdx),%r12
  800a10:	eb c7                	jmp    8009d9 <vprintfmt+0x363>
  800a12:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a16:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a1a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a1e:	eb ed                	jmp    800a0d <vprintfmt+0x397>
        return va_arg(*ap, long);
  800a20:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a23:	83 f8 2f             	cmp    $0x2f,%eax
  800a26:	77 11                	ja     800a39 <vprintfmt+0x3c3>
  800a28:	89 c2                	mov    %eax,%edx
  800a2a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a2e:	83 c0 08             	add    $0x8,%eax
  800a31:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a34:	4c 8b 22             	mov    (%rdx),%r12
  800a37:	eb a0                	jmp    8009d9 <vprintfmt+0x363>
  800a39:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a41:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a45:	eb ed                	jmp    800a34 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800a47:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a4b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a4f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a53:	e9 65 ff ff ff       	jmp    8009bd <vprintfmt+0x347>
                putch('-', put_arg);
  800a58:	4c 89 ee             	mov    %r13,%rsi
  800a5b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a60:	41 ff d6             	call   *%r14
                i = -i;
  800a63:	49 f7 dc             	neg    %r12
  800a66:	e9 73 ff ff ff       	jmp    8009de <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800a6b:	40 84 f6             	test   %sil,%sil
  800a6e:	75 32                	jne    800aa2 <vprintfmt+0x42c>
    switch (lflag) {
  800a70:	85 d2                	test   %edx,%edx
  800a72:	74 5d                	je     800ad1 <vprintfmt+0x45b>
  800a74:	83 fa 01             	cmp    $0x1,%edx
  800a77:	0f 84 82 00 00 00    	je     800aff <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800a7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a80:	83 f8 2f             	cmp    $0x2f,%eax
  800a83:	0f 87 a5 00 00 00    	ja     800b2e <vprintfmt+0x4b8>
  800a89:	89 c2                	mov    %eax,%edx
  800a8b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a8f:	83 c0 08             	add    $0x8,%eax
  800a92:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a95:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800a98:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800a9d:	e9 99 01 00 00       	jmp    800c3b <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800aa2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa5:	83 f8 2f             	cmp    $0x2f,%eax
  800aa8:	77 19                	ja     800ac3 <vprintfmt+0x44d>
  800aaa:	89 c2                	mov    %eax,%edx
  800aac:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ab0:	83 c0 08             	add    $0x8,%eax
  800ab3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ab6:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800ab9:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800abe:	e9 78 01 00 00       	jmp    800c3b <vprintfmt+0x5c5>
  800ac3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800acb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800acf:	eb e5                	jmp    800ab6 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800ad1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad4:	83 f8 2f             	cmp    $0x2f,%eax
  800ad7:	77 18                	ja     800af1 <vprintfmt+0x47b>
  800ad9:	89 c2                	mov    %eax,%edx
  800adb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800adf:	83 c0 08             	add    $0x8,%eax
  800ae2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ae5:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800ae7:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800aec:	e9 4a 01 00 00       	jmp    800c3b <vprintfmt+0x5c5>
  800af1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800af5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800af9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800afd:	eb e6                	jmp    800ae5 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800aff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b02:	83 f8 2f             	cmp    $0x2f,%eax
  800b05:	77 19                	ja     800b20 <vprintfmt+0x4aa>
  800b07:	89 c2                	mov    %eax,%edx
  800b09:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b0d:	83 c0 08             	add    $0x8,%eax
  800b10:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b13:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b16:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800b1b:	e9 1b 01 00 00       	jmp    800c3b <vprintfmt+0x5c5>
  800b20:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b24:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b28:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b2c:	eb e5                	jmp    800b13 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800b2e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b32:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b36:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b3a:	e9 56 ff ff ff       	jmp    800a95 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800b3f:	40 84 f6             	test   %sil,%sil
  800b42:	75 2e                	jne    800b72 <vprintfmt+0x4fc>
    switch (lflag) {
  800b44:	85 d2                	test   %edx,%edx
  800b46:	74 59                	je     800ba1 <vprintfmt+0x52b>
  800b48:	83 fa 01             	cmp    $0x1,%edx
  800b4b:	74 7f                	je     800bcc <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800b4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b50:	83 f8 2f             	cmp    $0x2f,%eax
  800b53:	0f 87 9f 00 00 00    	ja     800bf8 <vprintfmt+0x582>
  800b59:	89 c2                	mov    %eax,%edx
  800b5b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b5f:	83 c0 08             	add    $0x8,%eax
  800b62:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b65:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800b68:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800b6d:	e9 c9 00 00 00       	jmp    800c3b <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b72:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b75:	83 f8 2f             	cmp    $0x2f,%eax
  800b78:	77 19                	ja     800b93 <vprintfmt+0x51d>
  800b7a:	89 c2                	mov    %eax,%edx
  800b7c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b80:	83 c0 08             	add    $0x8,%eax
  800b83:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b86:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800b89:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b8e:	e9 a8 00 00 00       	jmp    800c3b <vprintfmt+0x5c5>
  800b93:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b97:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b9b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b9f:	eb e5                	jmp    800b86 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800ba1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba4:	83 f8 2f             	cmp    $0x2f,%eax
  800ba7:	77 15                	ja     800bbe <vprintfmt+0x548>
  800ba9:	89 c2                	mov    %eax,%edx
  800bab:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800baf:	83 c0 08             	add    $0x8,%eax
  800bb2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bb5:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800bb7:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800bbc:	eb 7d                	jmp    800c3b <vprintfmt+0x5c5>
  800bbe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bc2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bc6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bca:	eb e9                	jmp    800bb5 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800bcc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcf:	83 f8 2f             	cmp    $0x2f,%eax
  800bd2:	77 16                	ja     800bea <vprintfmt+0x574>
  800bd4:	89 c2                	mov    %eax,%edx
  800bd6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bda:	83 c0 08             	add    $0x8,%eax
  800bdd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800be0:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800be3:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800be8:	eb 51                	jmp    800c3b <vprintfmt+0x5c5>
  800bea:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bee:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bf2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bf6:	eb e8                	jmp    800be0 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800bf8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bfc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c00:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c04:	e9 5c ff ff ff       	jmp    800b65 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800c09:	4c 89 ee             	mov    %r13,%rsi
  800c0c:	bf 30 00 00 00       	mov    $0x30,%edi
  800c11:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800c14:	4c 89 ee             	mov    %r13,%rsi
  800c17:	bf 78 00 00 00       	mov    $0x78,%edi
  800c1c:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800c1f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c22:	83 f8 2f             	cmp    $0x2f,%eax
  800c25:	77 47                	ja     800c6e <vprintfmt+0x5f8>
  800c27:	89 c2                	mov    %eax,%edx
  800c29:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c2d:	83 c0 08             	add    $0x8,%eax
  800c30:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c33:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c36:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800c3b:	48 83 ec 08          	sub    $0x8,%rsp
  800c3f:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800c43:	0f 94 c0             	sete   %al
  800c46:	0f b6 c0             	movzbl %al,%eax
  800c49:	50                   	push   %rax
  800c4a:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800c4f:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800c53:	4c 89 ee             	mov    %r13,%rsi
  800c56:	4c 89 f7             	mov    %r14,%rdi
  800c59:	48 b8 5f 05 80 00 00 	movabs $0x80055f,%rax
  800c60:	00 00 00 
  800c63:	ff d0                	call   *%rax
            break;
  800c65:	48 83 c4 10          	add    $0x10,%rsp
  800c69:	e9 3d fa ff ff       	jmp    8006ab <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800c6e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c72:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c76:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c7a:	eb b7                	jmp    800c33 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800c7c:	40 84 f6             	test   %sil,%sil
  800c7f:	75 2b                	jne    800cac <vprintfmt+0x636>
    switch (lflag) {
  800c81:	85 d2                	test   %edx,%edx
  800c83:	74 56                	je     800cdb <vprintfmt+0x665>
  800c85:	83 fa 01             	cmp    $0x1,%edx
  800c88:	74 7f                	je     800d09 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800c8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8d:	83 f8 2f             	cmp    $0x2f,%eax
  800c90:	0f 87 a2 00 00 00    	ja     800d38 <vprintfmt+0x6c2>
  800c96:	89 c2                	mov    %eax,%edx
  800c98:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c9c:	83 c0 08             	add    $0x8,%eax
  800c9f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ca2:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800ca5:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800caa:	eb 8f                	jmp    800c3b <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800cac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800caf:	83 f8 2f             	cmp    $0x2f,%eax
  800cb2:	77 19                	ja     800ccd <vprintfmt+0x657>
  800cb4:	89 c2                	mov    %eax,%edx
  800cb6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cba:	83 c0 08             	add    $0x8,%eax
  800cbd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cc0:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800cc3:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800cc8:	e9 6e ff ff ff       	jmp    800c3b <vprintfmt+0x5c5>
  800ccd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cd1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cd5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cd9:	eb e5                	jmp    800cc0 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800cdb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cde:	83 f8 2f             	cmp    $0x2f,%eax
  800ce1:	77 18                	ja     800cfb <vprintfmt+0x685>
  800ce3:	89 c2                	mov    %eax,%edx
  800ce5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ce9:	83 c0 08             	add    $0x8,%eax
  800cec:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cef:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800cf1:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800cf6:	e9 40 ff ff ff       	jmp    800c3b <vprintfmt+0x5c5>
  800cfb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cff:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d03:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d07:	eb e6                	jmp    800cef <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800d09:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d0c:	83 f8 2f             	cmp    $0x2f,%eax
  800d0f:	77 19                	ja     800d2a <vprintfmt+0x6b4>
  800d11:	89 c2                	mov    %eax,%edx
  800d13:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d17:	83 c0 08             	add    $0x8,%eax
  800d1a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d1d:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d20:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800d25:	e9 11 ff ff ff       	jmp    800c3b <vprintfmt+0x5c5>
  800d2a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d2e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d32:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d36:	eb e5                	jmp    800d1d <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800d38:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d3c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d40:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d44:	e9 59 ff ff ff       	jmp    800ca2 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800d49:	4c 89 ee             	mov    %r13,%rsi
  800d4c:	bf 25 00 00 00       	mov    $0x25,%edi
  800d51:	41 ff d6             	call   *%r14
            break;
  800d54:	e9 52 f9 ff ff       	jmp    8006ab <vprintfmt+0x35>
            putch('%', put_arg);
  800d59:	4c 89 ee             	mov    %r13,%rsi
  800d5c:	bf 25 00 00 00       	mov    $0x25,%edi
  800d61:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800d64:	48 83 eb 01          	sub    $0x1,%rbx
  800d68:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800d6c:	75 f6                	jne    800d64 <vprintfmt+0x6ee>
  800d6e:	e9 38 f9 ff ff       	jmp    8006ab <vprintfmt+0x35>
}
  800d73:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800d77:	5b                   	pop    %rbx
  800d78:	41 5c                	pop    %r12
  800d7a:	41 5d                	pop    %r13
  800d7c:	41 5e                	pop    %r14
  800d7e:	41 5f                	pop    %r15
  800d80:	5d                   	pop    %rbp
  800d81:	c3                   	ret

0000000000800d82 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800d82:	f3 0f 1e fa          	endbr64
  800d86:	55                   	push   %rbp
  800d87:	48 89 e5             	mov    %rsp,%rbp
  800d8a:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800d8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800d92:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800d97:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800d9b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800da2:	48 85 ff             	test   %rdi,%rdi
  800da5:	74 2b                	je     800dd2 <vsnprintf+0x50>
  800da7:	48 85 f6             	test   %rsi,%rsi
  800daa:	74 26                	je     800dd2 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800dac:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800db0:	48 bf 19 06 80 00 00 	movabs $0x800619,%rdi
  800db7:	00 00 00 
  800dba:	48 b8 76 06 80 00 00 	movabs $0x800676,%rax
  800dc1:	00 00 00 
  800dc4:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800dc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dca:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800dcd:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800dd0:	c9                   	leave
  800dd1:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800dd2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dd7:	eb f7                	jmp    800dd0 <vsnprintf+0x4e>

0000000000800dd9 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800dd9:	f3 0f 1e fa          	endbr64
  800ddd:	55                   	push   %rbp
  800dde:	48 89 e5             	mov    %rsp,%rbp
  800de1:	48 83 ec 50          	sub    $0x50,%rsp
  800de5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800de9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800ded:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800df1:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800df8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dfc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e00:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e04:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800e08:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800e0c:	48 b8 82 0d 80 00 00 	movabs $0x800d82,%rax
  800e13:	00 00 00 
  800e16:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800e18:	c9                   	leave
  800e19:	c3                   	ret

0000000000800e1a <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800e1a:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800e1e:	80 3f 00             	cmpb   $0x0,(%rdi)
  800e21:	74 10                	je     800e33 <strlen+0x19>
    size_t n = 0;
  800e23:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800e28:	48 83 c0 01          	add    $0x1,%rax
  800e2c:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800e30:	75 f6                	jne    800e28 <strlen+0xe>
  800e32:	c3                   	ret
    size_t n = 0;
  800e33:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800e38:	c3                   	ret

0000000000800e39 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800e39:	f3 0f 1e fa          	endbr64
  800e3d:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800e40:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800e45:	48 85 f6             	test   %rsi,%rsi
  800e48:	74 10                	je     800e5a <strnlen+0x21>
  800e4a:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800e4e:	74 0b                	je     800e5b <strnlen+0x22>
  800e50:	48 83 c2 01          	add    $0x1,%rdx
  800e54:	48 39 d0             	cmp    %rdx,%rax
  800e57:	75 f1                	jne    800e4a <strnlen+0x11>
  800e59:	c3                   	ret
  800e5a:	c3                   	ret
  800e5b:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800e5e:	c3                   	ret

0000000000800e5f <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800e5f:	f3 0f 1e fa          	endbr64
  800e63:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800e66:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6b:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800e6f:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800e72:	48 83 c2 01          	add    $0x1,%rdx
  800e76:	84 c9                	test   %cl,%cl
  800e78:	75 f1                	jne    800e6b <strcpy+0xc>
        ;
    return res;
}
  800e7a:	c3                   	ret

0000000000800e7b <strcat>:

char *
strcat(char *dst, const char *src) {
  800e7b:	f3 0f 1e fa          	endbr64
  800e7f:	55                   	push   %rbp
  800e80:	48 89 e5             	mov    %rsp,%rbp
  800e83:	41 54                	push   %r12
  800e85:	53                   	push   %rbx
  800e86:	48 89 fb             	mov    %rdi,%rbx
  800e89:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800e8c:	48 b8 1a 0e 80 00 00 	movabs $0x800e1a,%rax
  800e93:	00 00 00 
  800e96:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800e98:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800e9c:	4c 89 e6             	mov    %r12,%rsi
  800e9f:	48 b8 5f 0e 80 00 00 	movabs $0x800e5f,%rax
  800ea6:	00 00 00 
  800ea9:	ff d0                	call   *%rax
    return dst;
}
  800eab:	48 89 d8             	mov    %rbx,%rax
  800eae:	5b                   	pop    %rbx
  800eaf:	41 5c                	pop    %r12
  800eb1:	5d                   	pop    %rbp
  800eb2:	c3                   	ret

0000000000800eb3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800eb3:	f3 0f 1e fa          	endbr64
  800eb7:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800eba:	48 85 d2             	test   %rdx,%rdx
  800ebd:	74 1f                	je     800ede <strncpy+0x2b>
  800ebf:	48 01 fa             	add    %rdi,%rdx
  800ec2:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800ec5:	48 83 c1 01          	add    $0x1,%rcx
  800ec9:	44 0f b6 06          	movzbl (%rsi),%r8d
  800ecd:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800ed1:	41 80 f8 01          	cmp    $0x1,%r8b
  800ed5:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800ed9:	48 39 ca             	cmp    %rcx,%rdx
  800edc:	75 e7                	jne    800ec5 <strncpy+0x12>
    }
    return ret;
}
  800ede:	c3                   	ret

0000000000800edf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800edf:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800ee3:	48 89 f8             	mov    %rdi,%rax
  800ee6:	48 85 d2             	test   %rdx,%rdx
  800ee9:	74 24                	je     800f0f <strlcpy+0x30>
        while (--size > 0 && *src)
  800eeb:	48 83 ea 01          	sub    $0x1,%rdx
  800eef:	74 1b                	je     800f0c <strlcpy+0x2d>
  800ef1:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800ef5:	0f b6 16             	movzbl (%rsi),%edx
  800ef8:	84 d2                	test   %dl,%dl
  800efa:	74 10                	je     800f0c <strlcpy+0x2d>
            *dst++ = *src++;
  800efc:	48 83 c6 01          	add    $0x1,%rsi
  800f00:	48 83 c0 01          	add    $0x1,%rax
  800f04:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800f07:	48 39 c8             	cmp    %rcx,%rax
  800f0a:	75 e9                	jne    800ef5 <strlcpy+0x16>
        *dst = '\0';
  800f0c:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800f0f:	48 29 f8             	sub    %rdi,%rax
}
  800f12:	c3                   	ret

0000000000800f13 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800f13:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800f17:	0f b6 07             	movzbl (%rdi),%eax
  800f1a:	84 c0                	test   %al,%al
  800f1c:	74 13                	je     800f31 <strcmp+0x1e>
  800f1e:	38 06                	cmp    %al,(%rsi)
  800f20:	75 0f                	jne    800f31 <strcmp+0x1e>
  800f22:	48 83 c7 01          	add    $0x1,%rdi
  800f26:	48 83 c6 01          	add    $0x1,%rsi
  800f2a:	0f b6 07             	movzbl (%rdi),%eax
  800f2d:	84 c0                	test   %al,%al
  800f2f:	75 ed                	jne    800f1e <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800f31:	0f b6 c0             	movzbl %al,%eax
  800f34:	0f b6 16             	movzbl (%rsi),%edx
  800f37:	29 d0                	sub    %edx,%eax
}
  800f39:	c3                   	ret

0000000000800f3a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800f3a:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800f3e:	48 85 d2             	test   %rdx,%rdx
  800f41:	74 1f                	je     800f62 <strncmp+0x28>
  800f43:	0f b6 07             	movzbl (%rdi),%eax
  800f46:	84 c0                	test   %al,%al
  800f48:	74 1e                	je     800f68 <strncmp+0x2e>
  800f4a:	3a 06                	cmp    (%rsi),%al
  800f4c:	75 1a                	jne    800f68 <strncmp+0x2e>
  800f4e:	48 83 c7 01          	add    $0x1,%rdi
  800f52:	48 83 c6 01          	add    $0x1,%rsi
  800f56:	48 83 ea 01          	sub    $0x1,%rdx
  800f5a:	75 e7                	jne    800f43 <strncmp+0x9>

    if (!n) return 0;
  800f5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f61:	c3                   	ret
  800f62:	b8 00 00 00 00       	mov    $0x0,%eax
  800f67:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800f68:	0f b6 07             	movzbl (%rdi),%eax
  800f6b:	0f b6 16             	movzbl (%rsi),%edx
  800f6e:	29 d0                	sub    %edx,%eax
}
  800f70:	c3                   	ret

0000000000800f71 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800f71:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800f75:	0f b6 17             	movzbl (%rdi),%edx
  800f78:	84 d2                	test   %dl,%dl
  800f7a:	74 18                	je     800f94 <strchr+0x23>
        if (*str == c) {
  800f7c:	0f be d2             	movsbl %dl,%edx
  800f7f:	39 f2                	cmp    %esi,%edx
  800f81:	74 17                	je     800f9a <strchr+0x29>
    for (; *str; str++) {
  800f83:	48 83 c7 01          	add    $0x1,%rdi
  800f87:	0f b6 17             	movzbl (%rdi),%edx
  800f8a:	84 d2                	test   %dl,%dl
  800f8c:	75 ee                	jne    800f7c <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f93:	c3                   	ret
  800f94:	b8 00 00 00 00       	mov    $0x0,%eax
  800f99:	c3                   	ret
            return (char *)str;
  800f9a:	48 89 f8             	mov    %rdi,%rax
}
  800f9d:	c3                   	ret

0000000000800f9e <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800f9e:	f3 0f 1e fa          	endbr64
  800fa2:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800fa5:	0f b6 17             	movzbl (%rdi),%edx
  800fa8:	84 d2                	test   %dl,%dl
  800faa:	74 13                	je     800fbf <strfind+0x21>
  800fac:	0f be d2             	movsbl %dl,%edx
  800faf:	39 f2                	cmp    %esi,%edx
  800fb1:	74 0b                	je     800fbe <strfind+0x20>
  800fb3:	48 83 c0 01          	add    $0x1,%rax
  800fb7:	0f b6 10             	movzbl (%rax),%edx
  800fba:	84 d2                	test   %dl,%dl
  800fbc:	75 ee                	jne    800fac <strfind+0xe>
        ;
    return (char *)str;
}
  800fbe:	c3                   	ret
  800fbf:	c3                   	ret

0000000000800fc0 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800fc0:	f3 0f 1e fa          	endbr64
  800fc4:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800fc7:	48 89 f8             	mov    %rdi,%rax
  800fca:	48 f7 d8             	neg    %rax
  800fcd:	83 e0 07             	and    $0x7,%eax
  800fd0:	49 89 d1             	mov    %rdx,%r9
  800fd3:	49 29 c1             	sub    %rax,%r9
  800fd6:	78 36                	js     80100e <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800fd8:	40 0f b6 c6          	movzbl %sil,%eax
  800fdc:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800fe3:	01 01 01 
  800fe6:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800fea:	40 f6 c7 07          	test   $0x7,%dil
  800fee:	75 38                	jne    801028 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800ff0:	4c 89 c9             	mov    %r9,%rcx
  800ff3:	48 c1 f9 03          	sar    $0x3,%rcx
  800ff7:	74 0c                	je     801005 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800ff9:	fc                   	cld
  800ffa:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800ffd:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  801001:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801005:	4d 85 c9             	test   %r9,%r9
  801008:	75 45                	jne    80104f <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  80100a:	4c 89 c0             	mov    %r8,%rax
  80100d:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  80100e:	48 85 d2             	test   %rdx,%rdx
  801011:	74 f7                	je     80100a <memset+0x4a>
  801013:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801016:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  801019:	48 83 c0 01          	add    $0x1,%rax
  80101d:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  801021:	48 39 c2             	cmp    %rax,%rdx
  801024:	75 f3                	jne    801019 <memset+0x59>
  801026:	eb e2                	jmp    80100a <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  801028:	40 f6 c7 01          	test   $0x1,%dil
  80102c:	74 06                	je     801034 <memset+0x74>
  80102e:	88 07                	mov    %al,(%rdi)
  801030:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801034:	40 f6 c7 02          	test   $0x2,%dil
  801038:	74 07                	je     801041 <memset+0x81>
  80103a:	66 89 07             	mov    %ax,(%rdi)
  80103d:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801041:	40 f6 c7 04          	test   $0x4,%dil
  801045:	74 a9                	je     800ff0 <memset+0x30>
  801047:	89 07                	mov    %eax,(%rdi)
  801049:	48 83 c7 04          	add    $0x4,%rdi
  80104d:	eb a1                	jmp    800ff0 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  80104f:	41 f6 c1 04          	test   $0x4,%r9b
  801053:	74 1b                	je     801070 <memset+0xb0>
  801055:	89 07                	mov    %eax,(%rdi)
  801057:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80105b:	41 f6 c1 02          	test   $0x2,%r9b
  80105f:	74 07                	je     801068 <memset+0xa8>
  801061:	66 89 07             	mov    %ax,(%rdi)
  801064:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  801068:	41 f6 c1 01          	test   $0x1,%r9b
  80106c:	74 9c                	je     80100a <memset+0x4a>
  80106e:	eb 06                	jmp    801076 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801070:	41 f6 c1 02          	test   $0x2,%r9b
  801074:	75 eb                	jne    801061 <memset+0xa1>
        if (ni & 1) *ptr = k;
  801076:	88 07                	mov    %al,(%rdi)
  801078:	eb 90                	jmp    80100a <memset+0x4a>

000000000080107a <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  80107a:	f3 0f 1e fa          	endbr64
  80107e:	48 89 f8             	mov    %rdi,%rax
  801081:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801084:	48 39 fe             	cmp    %rdi,%rsi
  801087:	73 3b                	jae    8010c4 <memmove+0x4a>
  801089:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  80108d:	48 39 d7             	cmp    %rdx,%rdi
  801090:	73 32                	jae    8010c4 <memmove+0x4a>
        s += n;
        d += n;
  801092:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801096:	48 89 d6             	mov    %rdx,%rsi
  801099:	48 09 fe             	or     %rdi,%rsi
  80109c:	48 09 ce             	or     %rcx,%rsi
  80109f:	40 f6 c6 07          	test   $0x7,%sil
  8010a3:	75 12                	jne    8010b7 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8010a5:	48 83 ef 08          	sub    $0x8,%rdi
  8010a9:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8010ad:	48 c1 e9 03          	shr    $0x3,%rcx
  8010b1:	fd                   	std
  8010b2:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8010b5:	fc                   	cld
  8010b6:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8010b7:	48 83 ef 01          	sub    $0x1,%rdi
  8010bb:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8010bf:	fd                   	std
  8010c0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8010c2:	eb f1                	jmp    8010b5 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8010c4:	48 89 f2             	mov    %rsi,%rdx
  8010c7:	48 09 c2             	or     %rax,%rdx
  8010ca:	48 09 ca             	or     %rcx,%rdx
  8010cd:	f6 c2 07             	test   $0x7,%dl
  8010d0:	75 0c                	jne    8010de <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8010d2:	48 c1 e9 03          	shr    $0x3,%rcx
  8010d6:	48 89 c7             	mov    %rax,%rdi
  8010d9:	fc                   	cld
  8010da:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8010dd:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8010de:	48 89 c7             	mov    %rax,%rdi
  8010e1:	fc                   	cld
  8010e2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8010e4:	c3                   	ret

00000000008010e5 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8010e5:	f3 0f 1e fa          	endbr64
  8010e9:	55                   	push   %rbp
  8010ea:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8010ed:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  8010f4:	00 00 00 
  8010f7:	ff d0                	call   *%rax
}
  8010f9:	5d                   	pop    %rbp
  8010fa:	c3                   	ret

00000000008010fb <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8010fb:	f3 0f 1e fa          	endbr64
  8010ff:	55                   	push   %rbp
  801100:	48 89 e5             	mov    %rsp,%rbp
  801103:	41 57                	push   %r15
  801105:	41 56                	push   %r14
  801107:	41 55                	push   %r13
  801109:	41 54                	push   %r12
  80110b:	53                   	push   %rbx
  80110c:	48 83 ec 08          	sub    $0x8,%rsp
  801110:	49 89 fe             	mov    %rdi,%r14
  801113:	49 89 f7             	mov    %rsi,%r15
  801116:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801119:	48 89 f7             	mov    %rsi,%rdi
  80111c:	48 b8 1a 0e 80 00 00 	movabs $0x800e1a,%rax
  801123:	00 00 00 
  801126:	ff d0                	call   *%rax
  801128:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80112b:	48 89 de             	mov    %rbx,%rsi
  80112e:	4c 89 f7             	mov    %r14,%rdi
  801131:	48 b8 39 0e 80 00 00 	movabs $0x800e39,%rax
  801138:	00 00 00 
  80113b:	ff d0                	call   *%rax
  80113d:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801140:	48 39 c3             	cmp    %rax,%rbx
  801143:	74 36                	je     80117b <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  801145:	48 89 d8             	mov    %rbx,%rax
  801148:	4c 29 e8             	sub    %r13,%rax
  80114b:	49 39 c4             	cmp    %rax,%r12
  80114e:	73 31                	jae    801181 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  801150:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801155:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801159:	4c 89 fe             	mov    %r15,%rsi
  80115c:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  801163:	00 00 00 
  801166:	ff d0                	call   *%rax
    return dstlen + srclen;
  801168:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80116c:	48 83 c4 08          	add    $0x8,%rsp
  801170:	5b                   	pop    %rbx
  801171:	41 5c                	pop    %r12
  801173:	41 5d                	pop    %r13
  801175:	41 5e                	pop    %r14
  801177:	41 5f                	pop    %r15
  801179:	5d                   	pop    %rbp
  80117a:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  80117b:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  80117f:	eb eb                	jmp    80116c <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  801181:	48 83 eb 01          	sub    $0x1,%rbx
  801185:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801189:	48 89 da             	mov    %rbx,%rdx
  80118c:	4c 89 fe             	mov    %r15,%rsi
  80118f:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  801196:	00 00 00 
  801199:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  80119b:	49 01 de             	add    %rbx,%r14
  80119e:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8011a3:	eb c3                	jmp    801168 <strlcat+0x6d>

00000000008011a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8011a5:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8011a9:	48 85 d2             	test   %rdx,%rdx
  8011ac:	74 2d                	je     8011db <memcmp+0x36>
  8011ae:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8011b3:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8011b7:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8011bc:	44 38 c1             	cmp    %r8b,%cl
  8011bf:	75 0f                	jne    8011d0 <memcmp+0x2b>
    while (n-- > 0) {
  8011c1:	48 83 c0 01          	add    $0x1,%rax
  8011c5:	48 39 c2             	cmp    %rax,%rdx
  8011c8:	75 e9                	jne    8011b3 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8011ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cf:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8011d0:	0f b6 c1             	movzbl %cl,%eax
  8011d3:	45 0f b6 c0          	movzbl %r8b,%r8d
  8011d7:	44 29 c0             	sub    %r8d,%eax
  8011da:	c3                   	ret
    return 0;
  8011db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e0:	c3                   	ret

00000000008011e1 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8011e1:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  8011e5:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8011e9:	48 39 c7             	cmp    %rax,%rdi
  8011ec:	73 0f                	jae    8011fd <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8011ee:	40 38 37             	cmp    %sil,(%rdi)
  8011f1:	74 0e                	je     801201 <memfind+0x20>
    for (; src < end; src++) {
  8011f3:	48 83 c7 01          	add    $0x1,%rdi
  8011f7:	48 39 f8             	cmp    %rdi,%rax
  8011fa:	75 f2                	jne    8011ee <memfind+0xd>
  8011fc:	c3                   	ret
  8011fd:	48 89 f8             	mov    %rdi,%rax
  801200:	c3                   	ret
  801201:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801204:	c3                   	ret

0000000000801205 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801205:	f3 0f 1e fa          	endbr64
  801209:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80120c:	0f b6 37             	movzbl (%rdi),%esi
  80120f:	40 80 fe 20          	cmp    $0x20,%sil
  801213:	74 06                	je     80121b <strtol+0x16>
  801215:	40 80 fe 09          	cmp    $0x9,%sil
  801219:	75 13                	jne    80122e <strtol+0x29>
  80121b:	48 83 c7 01          	add    $0x1,%rdi
  80121f:	0f b6 37             	movzbl (%rdi),%esi
  801222:	40 80 fe 20          	cmp    $0x20,%sil
  801226:	74 f3                	je     80121b <strtol+0x16>
  801228:	40 80 fe 09          	cmp    $0x9,%sil
  80122c:	74 ed                	je     80121b <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  80122e:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801231:	83 e0 fd             	and    $0xfffffffd,%eax
  801234:	3c 01                	cmp    $0x1,%al
  801236:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80123a:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  801240:	75 0f                	jne    801251 <strtol+0x4c>
  801242:	80 3f 30             	cmpb   $0x30,(%rdi)
  801245:	74 14                	je     80125b <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801247:	85 d2                	test   %edx,%edx
  801249:	b8 0a 00 00 00       	mov    $0xa,%eax
  80124e:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801256:	4c 63 ca             	movslq %edx,%r9
  801259:	eb 36                	jmp    801291 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80125b:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80125f:	74 0f                	je     801270 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801261:	85 d2                	test   %edx,%edx
  801263:	75 ec                	jne    801251 <strtol+0x4c>
        s++;
  801265:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801269:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  80126e:	eb e1                	jmp    801251 <strtol+0x4c>
        s += 2;
  801270:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801274:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801279:	eb d6                	jmp    801251 <strtol+0x4c>
            dig -= '0';
  80127b:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  80127e:	44 0f b6 c1          	movzbl %cl,%r8d
  801282:	41 39 d0             	cmp    %edx,%r8d
  801285:	7d 21                	jge    8012a8 <strtol+0xa3>
        val = val * base + dig;
  801287:	49 0f af c1          	imul   %r9,%rax
  80128b:	0f b6 c9             	movzbl %cl,%ecx
  80128e:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  801291:	48 83 c7 01          	add    $0x1,%rdi
  801295:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801299:	80 f9 39             	cmp    $0x39,%cl
  80129c:	76 dd                	jbe    80127b <strtol+0x76>
        else if (dig - 'a' < 27)
  80129e:	80 f9 7b             	cmp    $0x7b,%cl
  8012a1:	77 05                	ja     8012a8 <strtol+0xa3>
            dig -= 'a' - 10;
  8012a3:	83 e9 57             	sub    $0x57,%ecx
  8012a6:	eb d6                	jmp    80127e <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  8012a8:	4d 85 d2             	test   %r10,%r10
  8012ab:	74 03                	je     8012b0 <strtol+0xab>
  8012ad:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8012b0:	48 89 c2             	mov    %rax,%rdx
  8012b3:	48 f7 da             	neg    %rdx
  8012b6:	40 80 fe 2d          	cmp    $0x2d,%sil
  8012ba:	48 0f 44 c2          	cmove  %rdx,%rax
}
  8012be:	c3                   	ret

00000000008012bf <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8012bf:	f3 0f 1e fa          	endbr64
  8012c3:	55                   	push   %rbp
  8012c4:	48 89 e5             	mov    %rsp,%rbp
  8012c7:	53                   	push   %rbx
  8012c8:	48 89 fa             	mov    %rdi,%rdx
  8012cb:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8012ce:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012d8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012dd:	be 00 00 00 00       	mov    $0x0,%esi
  8012e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012e8:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8012ea:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012ee:	c9                   	leave
  8012ef:	c3                   	ret

00000000008012f0 <sys_cgetc>:

int
sys_cgetc(void) {
  8012f0:	f3 0f 1e fa          	endbr64
  8012f4:	55                   	push   %rbp
  8012f5:	48 89 e5             	mov    %rsp,%rbp
  8012f8:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8012f9:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801303:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801308:	bb 00 00 00 00       	mov    $0x0,%ebx
  80130d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801312:	be 00 00 00 00       	mov    $0x0,%esi
  801317:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80131d:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80131f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801323:	c9                   	leave
  801324:	c3                   	ret

0000000000801325 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801325:	f3 0f 1e fa          	endbr64
  801329:	55                   	push   %rbp
  80132a:	48 89 e5             	mov    %rsp,%rbp
  80132d:	53                   	push   %rbx
  80132e:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801332:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801335:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80133a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80133f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801344:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801349:	be 00 00 00 00       	mov    $0x0,%esi
  80134e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801354:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801356:	48 85 c0             	test   %rax,%rax
  801359:	7f 06                	jg     801361 <sys_env_destroy+0x3c>
}
  80135b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80135f:	c9                   	leave
  801360:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801361:	49 89 c0             	mov    %rax,%r8
  801364:	b9 03 00 00 00       	mov    $0x3,%ecx
  801369:	48 ba a0 40 80 00 00 	movabs $0x8040a0,%rdx
  801370:	00 00 00 
  801373:	be 26 00 00 00       	mov    $0x26,%esi
  801378:	48 bf 82 43 80 00 00 	movabs $0x804382,%rdi
  80137f:	00 00 00 
  801382:	b8 00 00 00 00       	mov    $0x0,%eax
  801387:	49 b9 ba 03 80 00 00 	movabs $0x8003ba,%r9
  80138e:	00 00 00 
  801391:	41 ff d1             	call   *%r9

0000000000801394 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801394:	f3 0f 1e fa          	endbr64
  801398:	55                   	push   %rbp
  801399:	48 89 e5             	mov    %rsp,%rbp
  80139c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80139d:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a7:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013b6:	be 00 00 00 00       	mov    $0x0,%esi
  8013bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013c1:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8013c3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013c7:	c9                   	leave
  8013c8:	c3                   	ret

00000000008013c9 <sys_yield>:

void
sys_yield(void) {
  8013c9:	f3 0f 1e fa          	endbr64
  8013cd:	55                   	push   %rbp
  8013ce:	48 89 e5             	mov    %rsp,%rbp
  8013d1:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013d2:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013dc:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013eb:	be 00 00 00 00       	mov    $0x0,%esi
  8013f0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013f6:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8013f8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013fc:	c9                   	leave
  8013fd:	c3                   	ret

00000000008013fe <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8013fe:	f3 0f 1e fa          	endbr64
  801402:	55                   	push   %rbp
  801403:	48 89 e5             	mov    %rsp,%rbp
  801406:	53                   	push   %rbx
  801407:	48 89 fa             	mov    %rdi,%rdx
  80140a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80140d:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801412:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801419:	00 00 00 
  80141c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801421:	be 00 00 00 00       	mov    $0x0,%esi
  801426:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80142c:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80142e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801432:	c9                   	leave
  801433:	c3                   	ret

0000000000801434 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801434:	f3 0f 1e fa          	endbr64
  801438:	55                   	push   %rbp
  801439:	48 89 e5             	mov    %rsp,%rbp
  80143c:	53                   	push   %rbx
  80143d:	49 89 f8             	mov    %rdi,%r8
  801440:	48 89 d3             	mov    %rdx,%rbx
  801443:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801446:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80144b:	4c 89 c2             	mov    %r8,%rdx
  80144e:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801451:	be 00 00 00 00       	mov    $0x0,%esi
  801456:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80145c:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80145e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801462:	c9                   	leave
  801463:	c3                   	ret

0000000000801464 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801464:	f3 0f 1e fa          	endbr64
  801468:	55                   	push   %rbp
  801469:	48 89 e5             	mov    %rsp,%rbp
  80146c:	53                   	push   %rbx
  80146d:	48 83 ec 08          	sub    $0x8,%rsp
  801471:	89 f8                	mov    %edi,%eax
  801473:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801476:	48 63 f9             	movslq %ecx,%rdi
  801479:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80147c:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801481:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801484:	be 00 00 00 00       	mov    $0x0,%esi
  801489:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80148f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801491:	48 85 c0             	test   %rax,%rax
  801494:	7f 06                	jg     80149c <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801496:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80149a:	c9                   	leave
  80149b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80149c:	49 89 c0             	mov    %rax,%r8
  80149f:	b9 04 00 00 00       	mov    $0x4,%ecx
  8014a4:	48 ba a0 40 80 00 00 	movabs $0x8040a0,%rdx
  8014ab:	00 00 00 
  8014ae:	be 26 00 00 00       	mov    $0x26,%esi
  8014b3:	48 bf 82 43 80 00 00 	movabs $0x804382,%rdi
  8014ba:	00 00 00 
  8014bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c2:	49 b9 ba 03 80 00 00 	movabs $0x8003ba,%r9
  8014c9:	00 00 00 
  8014cc:	41 ff d1             	call   *%r9

00000000008014cf <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8014cf:	f3 0f 1e fa          	endbr64
  8014d3:	55                   	push   %rbp
  8014d4:	48 89 e5             	mov    %rsp,%rbp
  8014d7:	53                   	push   %rbx
  8014d8:	48 83 ec 08          	sub    $0x8,%rsp
  8014dc:	89 f8                	mov    %edi,%eax
  8014de:	49 89 f2             	mov    %rsi,%r10
  8014e1:	48 89 cf             	mov    %rcx,%rdi
  8014e4:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8014e7:	48 63 da             	movslq %edx,%rbx
  8014ea:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014ed:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014f2:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014f5:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8014f8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014fa:	48 85 c0             	test   %rax,%rax
  8014fd:	7f 06                	jg     801505 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8014ff:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801503:	c9                   	leave
  801504:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801505:	49 89 c0             	mov    %rax,%r8
  801508:	b9 05 00 00 00       	mov    $0x5,%ecx
  80150d:	48 ba a0 40 80 00 00 	movabs $0x8040a0,%rdx
  801514:	00 00 00 
  801517:	be 26 00 00 00       	mov    $0x26,%esi
  80151c:	48 bf 82 43 80 00 00 	movabs $0x804382,%rdi
  801523:	00 00 00 
  801526:	b8 00 00 00 00       	mov    $0x0,%eax
  80152b:	49 b9 ba 03 80 00 00 	movabs $0x8003ba,%r9
  801532:	00 00 00 
  801535:	41 ff d1             	call   *%r9

0000000000801538 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801538:	f3 0f 1e fa          	endbr64
  80153c:	55                   	push   %rbp
  80153d:	48 89 e5             	mov    %rsp,%rbp
  801540:	53                   	push   %rbx
  801541:	48 83 ec 08          	sub    $0x8,%rsp
  801545:	49 89 f9             	mov    %rdi,%r9
  801548:	89 f0                	mov    %esi,%eax
  80154a:	48 89 d3             	mov    %rdx,%rbx
  80154d:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801550:	49 63 f0             	movslq %r8d,%rsi
  801553:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801556:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80155b:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80155e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801564:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801566:	48 85 c0             	test   %rax,%rax
  801569:	7f 06                	jg     801571 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80156b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80156f:	c9                   	leave
  801570:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801571:	49 89 c0             	mov    %rax,%r8
  801574:	b9 06 00 00 00       	mov    $0x6,%ecx
  801579:	48 ba a0 40 80 00 00 	movabs $0x8040a0,%rdx
  801580:	00 00 00 
  801583:	be 26 00 00 00       	mov    $0x26,%esi
  801588:	48 bf 82 43 80 00 00 	movabs $0x804382,%rdi
  80158f:	00 00 00 
  801592:	b8 00 00 00 00       	mov    $0x0,%eax
  801597:	49 b9 ba 03 80 00 00 	movabs $0x8003ba,%r9
  80159e:	00 00 00 
  8015a1:	41 ff d1             	call   *%r9

00000000008015a4 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8015a4:	f3 0f 1e fa          	endbr64
  8015a8:	55                   	push   %rbp
  8015a9:	48 89 e5             	mov    %rsp,%rbp
  8015ac:	53                   	push   %rbx
  8015ad:	48 83 ec 08          	sub    $0x8,%rsp
  8015b1:	48 89 f1             	mov    %rsi,%rcx
  8015b4:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8015b7:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015ba:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015bf:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015c4:	be 00 00 00 00       	mov    $0x0,%esi
  8015c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015cf:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015d1:	48 85 c0             	test   %rax,%rax
  8015d4:	7f 06                	jg     8015dc <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8015d6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015da:	c9                   	leave
  8015db:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015dc:	49 89 c0             	mov    %rax,%r8
  8015df:	b9 07 00 00 00       	mov    $0x7,%ecx
  8015e4:	48 ba a0 40 80 00 00 	movabs $0x8040a0,%rdx
  8015eb:	00 00 00 
  8015ee:	be 26 00 00 00       	mov    $0x26,%esi
  8015f3:	48 bf 82 43 80 00 00 	movabs $0x804382,%rdi
  8015fa:	00 00 00 
  8015fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801602:	49 b9 ba 03 80 00 00 	movabs $0x8003ba,%r9
  801609:	00 00 00 
  80160c:	41 ff d1             	call   *%r9

000000000080160f <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80160f:	f3 0f 1e fa          	endbr64
  801613:	55                   	push   %rbp
  801614:	48 89 e5             	mov    %rsp,%rbp
  801617:	53                   	push   %rbx
  801618:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80161c:	48 63 ce             	movslq %esi,%rcx
  80161f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801622:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801627:	bb 00 00 00 00       	mov    $0x0,%ebx
  80162c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801631:	be 00 00 00 00       	mov    $0x0,%esi
  801636:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80163c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80163e:	48 85 c0             	test   %rax,%rax
  801641:	7f 06                	jg     801649 <sys_env_set_status+0x3a>
}
  801643:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801647:	c9                   	leave
  801648:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801649:	49 89 c0             	mov    %rax,%r8
  80164c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801651:	48 ba a0 40 80 00 00 	movabs $0x8040a0,%rdx
  801658:	00 00 00 
  80165b:	be 26 00 00 00       	mov    $0x26,%esi
  801660:	48 bf 82 43 80 00 00 	movabs $0x804382,%rdi
  801667:	00 00 00 
  80166a:	b8 00 00 00 00       	mov    $0x0,%eax
  80166f:	49 b9 ba 03 80 00 00 	movabs $0x8003ba,%r9
  801676:	00 00 00 
  801679:	41 ff d1             	call   *%r9

000000000080167c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80167c:	f3 0f 1e fa          	endbr64
  801680:	55                   	push   %rbp
  801681:	48 89 e5             	mov    %rsp,%rbp
  801684:	53                   	push   %rbx
  801685:	48 83 ec 08          	sub    $0x8,%rsp
  801689:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80168c:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80168f:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801694:	bb 00 00 00 00       	mov    $0x0,%ebx
  801699:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80169e:	be 00 00 00 00       	mov    $0x0,%esi
  8016a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016a9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016ab:	48 85 c0             	test   %rax,%rax
  8016ae:	7f 06                	jg     8016b6 <sys_env_set_trapframe+0x3a>
}
  8016b0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016b4:	c9                   	leave
  8016b5:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016b6:	49 89 c0             	mov    %rax,%r8
  8016b9:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8016be:	48 ba a0 40 80 00 00 	movabs $0x8040a0,%rdx
  8016c5:	00 00 00 
  8016c8:	be 26 00 00 00       	mov    $0x26,%esi
  8016cd:	48 bf 82 43 80 00 00 	movabs $0x804382,%rdi
  8016d4:	00 00 00 
  8016d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016dc:	49 b9 ba 03 80 00 00 	movabs $0x8003ba,%r9
  8016e3:	00 00 00 
  8016e6:	41 ff d1             	call   *%r9

00000000008016e9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8016e9:	f3 0f 1e fa          	endbr64
  8016ed:	55                   	push   %rbp
  8016ee:	48 89 e5             	mov    %rsp,%rbp
  8016f1:	53                   	push   %rbx
  8016f2:	48 83 ec 08          	sub    $0x8,%rsp
  8016f6:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8016f9:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016fc:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801701:	bb 00 00 00 00       	mov    $0x0,%ebx
  801706:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80170b:	be 00 00 00 00       	mov    $0x0,%esi
  801710:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801716:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801718:	48 85 c0             	test   %rax,%rax
  80171b:	7f 06                	jg     801723 <sys_env_set_pgfault_upcall+0x3a>
}
  80171d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801721:	c9                   	leave
  801722:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801723:	49 89 c0             	mov    %rax,%r8
  801726:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80172b:	48 ba a0 40 80 00 00 	movabs $0x8040a0,%rdx
  801732:	00 00 00 
  801735:	be 26 00 00 00       	mov    $0x26,%esi
  80173a:	48 bf 82 43 80 00 00 	movabs $0x804382,%rdi
  801741:	00 00 00 
  801744:	b8 00 00 00 00       	mov    $0x0,%eax
  801749:	49 b9 ba 03 80 00 00 	movabs $0x8003ba,%r9
  801750:	00 00 00 
  801753:	41 ff d1             	call   *%r9

0000000000801756 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801756:	f3 0f 1e fa          	endbr64
  80175a:	55                   	push   %rbp
  80175b:	48 89 e5             	mov    %rsp,%rbp
  80175e:	53                   	push   %rbx
  80175f:	89 f8                	mov    %edi,%eax
  801761:	49 89 f1             	mov    %rsi,%r9
  801764:	48 89 d3             	mov    %rdx,%rbx
  801767:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80176a:	49 63 f0             	movslq %r8d,%rsi
  80176d:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801770:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801775:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801778:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80177e:	cd 30                	int    $0x30
}
  801780:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801784:	c9                   	leave
  801785:	c3                   	ret

0000000000801786 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801786:	f3 0f 1e fa          	endbr64
  80178a:	55                   	push   %rbp
  80178b:	48 89 e5             	mov    %rsp,%rbp
  80178e:	53                   	push   %rbx
  80178f:	48 83 ec 08          	sub    $0x8,%rsp
  801793:	48 89 fa             	mov    %rdi,%rdx
  801796:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801799:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80179e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017a3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017a8:	be 00 00 00 00       	mov    $0x0,%esi
  8017ad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017b3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8017b5:	48 85 c0             	test   %rax,%rax
  8017b8:	7f 06                	jg     8017c0 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8017ba:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017be:	c9                   	leave
  8017bf:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017c0:	49 89 c0             	mov    %rax,%r8
  8017c3:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8017c8:	48 ba a0 40 80 00 00 	movabs $0x8040a0,%rdx
  8017cf:	00 00 00 
  8017d2:	be 26 00 00 00       	mov    $0x26,%esi
  8017d7:	48 bf 82 43 80 00 00 	movabs $0x804382,%rdi
  8017de:	00 00 00 
  8017e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e6:	49 b9 ba 03 80 00 00 	movabs $0x8003ba,%r9
  8017ed:	00 00 00 
  8017f0:	41 ff d1             	call   *%r9

00000000008017f3 <sys_gettime>:

int
sys_gettime(void) {
  8017f3:	f3 0f 1e fa          	endbr64
  8017f7:	55                   	push   %rbp
  8017f8:	48 89 e5             	mov    %rsp,%rbp
  8017fb:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8017fc:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801801:	ba 00 00 00 00       	mov    $0x0,%edx
  801806:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80180b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801810:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801815:	be 00 00 00 00       	mov    $0x0,%esi
  80181a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801820:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801822:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801826:	c9                   	leave
  801827:	c3                   	ret

0000000000801828 <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  801828:	f3 0f 1e fa          	endbr64
  80182c:	55                   	push   %rbp
  80182d:	48 89 e5             	mov    %rsp,%rbp
  801830:	41 56                	push   %r14
  801832:	41 55                	push   %r13
  801834:	41 54                	push   %r12
  801836:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  801837:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80183e:	00 00 00 
  801841:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  801848:	b8 09 00 00 00       	mov    $0x9,%eax
  80184d:	cd 30                	int    $0x30
  80184f:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  801852:	85 c0                	test   %eax,%eax
  801854:	78 7f                	js     8018d5 <fork+0xad>
  801856:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  801858:	0f 84 83 00 00 00    	je     8018e1 <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  80185e:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  801864:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  80186b:	00 00 00 
  80186e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801873:	89 c2                	mov    %eax,%edx
  801875:	be 00 00 00 00       	mov    $0x0,%esi
  80187a:	bf 00 00 00 00       	mov    $0x0,%edi
  80187f:	48 b8 cf 14 80 00 00 	movabs $0x8014cf,%rax
  801886:	00 00 00 
  801889:	ff d0                	call   *%rax
  80188b:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  80188e:	85 c0                	test   %eax,%eax
  801890:	0f 88 81 00 00 00    	js     801917 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  801896:	4d 85 f6             	test   %r14,%r14
  801899:	74 20                	je     8018bb <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80189b:	48 be eb 2e 80 00 00 	movabs $0x802eeb,%rsi
  8018a2:	00 00 00 
  8018a5:	44 89 e7             	mov    %r12d,%edi
  8018a8:	48 b8 e9 16 80 00 00 	movabs $0x8016e9,%rax
  8018af:	00 00 00 
  8018b2:	ff d0                	call   *%rax
  8018b4:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	78 70                	js     80192b <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  8018bb:	be 02 00 00 00       	mov    $0x2,%esi
  8018c0:	89 df                	mov    %ebx,%edi
  8018c2:	48 b8 0f 16 80 00 00 	movabs $0x80160f,%rax
  8018c9:	00 00 00 
  8018cc:	ff d0                	call   *%rax
  8018ce:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	78 6a                	js     80193f <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  8018d5:	44 89 e0             	mov    %r12d,%eax
  8018d8:	5b                   	pop    %rbx
  8018d9:	41 5c                	pop    %r12
  8018db:	41 5d                	pop    %r13
  8018dd:	41 5e                	pop    %r14
  8018df:	5d                   	pop    %rbp
  8018e0:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  8018e1:	48 b8 94 13 80 00 00 	movabs $0x801394,%rax
  8018e8:	00 00 00 
  8018eb:	ff d0                	call   *%rax
  8018ed:	25 ff 03 00 00       	and    $0x3ff,%eax
  8018f2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8018f6:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8018fa:	48 c1 e0 04          	shl    $0x4,%rax
  8018fe:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  801905:	00 00 00 
  801908:	48 01 d0             	add    %rdx,%rax
  80190b:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  801912:	00 00 00 
        return 0;
  801915:	eb be                	jmp    8018d5 <fork+0xad>
        sys_env_destroy(envid);
  801917:	44 89 e7             	mov    %r12d,%edi
  80191a:	48 b8 25 13 80 00 00 	movabs $0x801325,%rax
  801921:	00 00 00 
  801924:	ff d0                	call   *%rax
        return res;
  801926:	45 89 ec             	mov    %r13d,%r12d
  801929:	eb aa                	jmp    8018d5 <fork+0xad>
            sys_env_destroy(envid);
  80192b:	44 89 e7             	mov    %r12d,%edi
  80192e:	48 b8 25 13 80 00 00 	movabs $0x801325,%rax
  801935:	00 00 00 
  801938:	ff d0                	call   *%rax
            return res;
  80193a:	45 89 ec             	mov    %r13d,%r12d
  80193d:	eb 96                	jmp    8018d5 <fork+0xad>
        sys_env_destroy(envid);
  80193f:	89 df                	mov    %ebx,%edi
  801941:	48 b8 25 13 80 00 00 	movabs $0x801325,%rax
  801948:	00 00 00 
  80194b:	ff d0                	call   *%rax
        return res;
  80194d:	45 89 ec             	mov    %r13d,%r12d
  801950:	eb 83                	jmp    8018d5 <fork+0xad>

0000000000801952 <sfork>:

envid_t
sfork() {
  801952:	f3 0f 1e fa          	endbr64
  801956:	55                   	push   %rbp
  801957:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  80195a:	48 ba 90 43 80 00 00 	movabs $0x804390,%rdx
  801961:	00 00 00 
  801964:	be 37 00 00 00       	mov    $0x37,%esi
  801969:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  801970:	00 00 00 
  801973:	b8 00 00 00 00       	mov    $0x0,%eax
  801978:	48 b9 ba 03 80 00 00 	movabs $0x8003ba,%rcx
  80197f:	00 00 00 
  801982:	ff d1                	call   *%rcx

0000000000801984 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801984:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801988:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80198f:	ff ff ff 
  801992:	48 01 f8             	add    %rdi,%rax
  801995:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801999:	c3                   	ret

000000000080199a <fd2data>:

char *
fd2data(struct Fd *fd) {
  80199a:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80199e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019a5:	ff ff ff 
  8019a8:	48 01 f8             	add    %rdi,%rax
  8019ab:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8019af:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8019b5:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8019b9:	c3                   	ret

00000000008019ba <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8019ba:	f3 0f 1e fa          	endbr64
  8019be:	55                   	push   %rbp
  8019bf:	48 89 e5             	mov    %rsp,%rbp
  8019c2:	41 57                	push   %r15
  8019c4:	41 56                	push   %r14
  8019c6:	41 55                	push   %r13
  8019c8:	41 54                	push   %r12
  8019ca:	53                   	push   %rbx
  8019cb:	48 83 ec 08          	sub    $0x8,%rsp
  8019cf:	49 89 ff             	mov    %rdi,%r15
  8019d2:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8019d7:	49 bd 19 2b 80 00 00 	movabs $0x802b19,%r13
  8019de:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8019e1:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8019e7:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8019ea:	48 89 df             	mov    %rbx,%rdi
  8019ed:	41 ff d5             	call   *%r13
  8019f0:	83 e0 04             	and    $0x4,%eax
  8019f3:	74 17                	je     801a0c <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8019f5:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8019fc:	4c 39 f3             	cmp    %r14,%rbx
  8019ff:	75 e6                	jne    8019e7 <fd_alloc+0x2d>
  801a01:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801a07:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801a0c:	4d 89 27             	mov    %r12,(%r15)
}
  801a0f:	48 83 c4 08          	add    $0x8,%rsp
  801a13:	5b                   	pop    %rbx
  801a14:	41 5c                	pop    %r12
  801a16:	41 5d                	pop    %r13
  801a18:	41 5e                	pop    %r14
  801a1a:	41 5f                	pop    %r15
  801a1c:	5d                   	pop    %rbp
  801a1d:	c3                   	ret

0000000000801a1e <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801a1e:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801a22:	83 ff 1f             	cmp    $0x1f,%edi
  801a25:	77 39                	ja     801a60 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801a27:	55                   	push   %rbp
  801a28:	48 89 e5             	mov    %rsp,%rbp
  801a2b:	41 54                	push   %r12
  801a2d:	53                   	push   %rbx
  801a2e:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801a31:	48 63 df             	movslq %edi,%rbx
  801a34:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801a3b:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801a3f:	48 89 df             	mov    %rbx,%rdi
  801a42:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  801a49:	00 00 00 
  801a4c:	ff d0                	call   *%rax
  801a4e:	a8 04                	test   $0x4,%al
  801a50:	74 14                	je     801a66 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801a52:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801a56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5b:	5b                   	pop    %rbx
  801a5c:	41 5c                	pop    %r12
  801a5e:	5d                   	pop    %rbp
  801a5f:	c3                   	ret
        return -E_INVAL;
  801a60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a65:	c3                   	ret
        return -E_INVAL;
  801a66:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a6b:	eb ee                	jmp    801a5b <fd_lookup+0x3d>

0000000000801a6d <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801a6d:	f3 0f 1e fa          	endbr64
  801a71:	55                   	push   %rbp
  801a72:	48 89 e5             	mov    %rsp,%rbp
  801a75:	41 54                	push   %r12
  801a77:	53                   	push   %rbx
  801a78:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801a7b:	48 b8 20 48 80 00 00 	movabs $0x804820,%rax
  801a82:	00 00 00 
  801a85:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801a8c:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801a8f:	39 3b                	cmp    %edi,(%rbx)
  801a91:	74 47                	je     801ada <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801a93:	48 83 c0 08          	add    $0x8,%rax
  801a97:	48 8b 18             	mov    (%rax),%rbx
  801a9a:	48 85 db             	test   %rbx,%rbx
  801a9d:	75 f0                	jne    801a8f <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a9f:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801aa6:	00 00 00 
  801aa9:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801aaf:	89 fa                	mov    %edi,%edx
  801ab1:	48 bf c0 40 80 00 00 	movabs $0x8040c0,%rdi
  801ab8:	00 00 00 
  801abb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac0:	48 b9 16 05 80 00 00 	movabs $0x800516,%rcx
  801ac7:	00 00 00 
  801aca:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801acc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801ad1:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801ad5:	5b                   	pop    %rbx
  801ad6:	41 5c                	pop    %r12
  801ad8:	5d                   	pop    %rbp
  801ad9:	c3                   	ret
            return 0;
  801ada:	b8 00 00 00 00       	mov    $0x0,%eax
  801adf:	eb f0                	jmp    801ad1 <dev_lookup+0x64>

0000000000801ae1 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801ae1:	f3 0f 1e fa          	endbr64
  801ae5:	55                   	push   %rbp
  801ae6:	48 89 e5             	mov    %rsp,%rbp
  801ae9:	41 55                	push   %r13
  801aeb:	41 54                	push   %r12
  801aed:	53                   	push   %rbx
  801aee:	48 83 ec 18          	sub    $0x18,%rsp
  801af2:	48 89 fb             	mov    %rdi,%rbx
  801af5:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801af8:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801aff:	ff ff ff 
  801b02:	48 01 df             	add    %rbx,%rdi
  801b05:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801b09:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b0d:	48 b8 1e 1a 80 00 00 	movabs $0x801a1e,%rax
  801b14:	00 00 00 
  801b17:	ff d0                	call   *%rax
  801b19:	41 89 c5             	mov    %eax,%r13d
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	78 06                	js     801b26 <fd_close+0x45>
  801b20:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801b24:	74 1a                	je     801b40 <fd_close+0x5f>
        return (must_exist ? res : 0);
  801b26:	45 84 e4             	test   %r12b,%r12b
  801b29:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2e:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801b32:	44 89 e8             	mov    %r13d,%eax
  801b35:	48 83 c4 18          	add    $0x18,%rsp
  801b39:	5b                   	pop    %rbx
  801b3a:	41 5c                	pop    %r12
  801b3c:	41 5d                	pop    %r13
  801b3e:	5d                   	pop    %rbp
  801b3f:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b40:	8b 3b                	mov    (%rbx),%edi
  801b42:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b46:	48 b8 6d 1a 80 00 00 	movabs $0x801a6d,%rax
  801b4d:	00 00 00 
  801b50:	ff d0                	call   *%rax
  801b52:	41 89 c5             	mov    %eax,%r13d
  801b55:	85 c0                	test   %eax,%eax
  801b57:	78 1b                	js     801b74 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801b59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b5d:	48 8b 40 20          	mov    0x20(%rax),%rax
  801b61:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801b67:	48 85 c0             	test   %rax,%rax
  801b6a:	74 08                	je     801b74 <fd_close+0x93>
  801b6c:	48 89 df             	mov    %rbx,%rdi
  801b6f:	ff d0                	call   *%rax
  801b71:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801b74:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b79:	48 89 de             	mov    %rbx,%rsi
  801b7c:	bf 00 00 00 00       	mov    $0x0,%edi
  801b81:	48 b8 a4 15 80 00 00 	movabs $0x8015a4,%rax
  801b88:	00 00 00 
  801b8b:	ff d0                	call   *%rax
    return res;
  801b8d:	eb a3                	jmp    801b32 <fd_close+0x51>

0000000000801b8f <close>:

int
close(int fdnum) {
  801b8f:	f3 0f 1e fa          	endbr64
  801b93:	55                   	push   %rbp
  801b94:	48 89 e5             	mov    %rsp,%rbp
  801b97:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801b9b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b9f:	48 b8 1e 1a 80 00 00 	movabs $0x801a1e,%rax
  801ba6:	00 00 00 
  801ba9:	ff d0                	call   *%rax
    if (res < 0) return res;
  801bab:	85 c0                	test   %eax,%eax
  801bad:	78 15                	js     801bc4 <close+0x35>

    return fd_close(fd, 1);
  801baf:	be 01 00 00 00       	mov    $0x1,%esi
  801bb4:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801bb8:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
  801bbf:	00 00 00 
  801bc2:	ff d0                	call   *%rax
}
  801bc4:	c9                   	leave
  801bc5:	c3                   	ret

0000000000801bc6 <close_all>:

void
close_all(void) {
  801bc6:	f3 0f 1e fa          	endbr64
  801bca:	55                   	push   %rbp
  801bcb:	48 89 e5             	mov    %rsp,%rbp
  801bce:	41 54                	push   %r12
  801bd0:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801bd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bd6:	49 bc 8f 1b 80 00 00 	movabs $0x801b8f,%r12
  801bdd:	00 00 00 
  801be0:	89 df                	mov    %ebx,%edi
  801be2:	41 ff d4             	call   *%r12
  801be5:	83 c3 01             	add    $0x1,%ebx
  801be8:	83 fb 20             	cmp    $0x20,%ebx
  801beb:	75 f3                	jne    801be0 <close_all+0x1a>
}
  801bed:	5b                   	pop    %rbx
  801bee:	41 5c                	pop    %r12
  801bf0:	5d                   	pop    %rbp
  801bf1:	c3                   	ret

0000000000801bf2 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801bf2:	f3 0f 1e fa          	endbr64
  801bf6:	55                   	push   %rbp
  801bf7:	48 89 e5             	mov    %rsp,%rbp
  801bfa:	41 57                	push   %r15
  801bfc:	41 56                	push   %r14
  801bfe:	41 55                	push   %r13
  801c00:	41 54                	push   %r12
  801c02:	53                   	push   %rbx
  801c03:	48 83 ec 18          	sub    $0x18,%rsp
  801c07:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801c0a:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801c0e:	48 b8 1e 1a 80 00 00 	movabs $0x801a1e,%rax
  801c15:	00 00 00 
  801c18:	ff d0                	call   *%rax
  801c1a:	89 c3                	mov    %eax,%ebx
  801c1c:	85 c0                	test   %eax,%eax
  801c1e:	0f 88 b8 00 00 00    	js     801cdc <dup+0xea>
    close(newfdnum);
  801c24:	44 89 e7             	mov    %r12d,%edi
  801c27:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  801c2e:	00 00 00 
  801c31:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801c33:	4d 63 ec             	movslq %r12d,%r13
  801c36:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801c3d:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801c41:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801c45:	4c 89 ff             	mov    %r15,%rdi
  801c48:	49 be 9a 19 80 00 00 	movabs $0x80199a,%r14
  801c4f:	00 00 00 
  801c52:	41 ff d6             	call   *%r14
  801c55:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801c58:	4c 89 ef             	mov    %r13,%rdi
  801c5b:	41 ff d6             	call   *%r14
  801c5e:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801c61:	48 89 df             	mov    %rbx,%rdi
  801c64:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  801c6b:	00 00 00 
  801c6e:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801c70:	a8 04                	test   $0x4,%al
  801c72:	74 2b                	je     801c9f <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801c74:	41 89 c1             	mov    %eax,%r9d
  801c77:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c7d:	4c 89 f1             	mov    %r14,%rcx
  801c80:	ba 00 00 00 00       	mov    $0x0,%edx
  801c85:	48 89 de             	mov    %rbx,%rsi
  801c88:	bf 00 00 00 00       	mov    $0x0,%edi
  801c8d:	48 b8 cf 14 80 00 00 	movabs $0x8014cf,%rax
  801c94:	00 00 00 
  801c97:	ff d0                	call   *%rax
  801c99:	89 c3                	mov    %eax,%ebx
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	78 4e                	js     801ced <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801c9f:	4c 89 ff             	mov    %r15,%rdi
  801ca2:	48 b8 19 2b 80 00 00 	movabs $0x802b19,%rax
  801ca9:	00 00 00 
  801cac:	ff d0                	call   *%rax
  801cae:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801cb1:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801cb7:	4c 89 e9             	mov    %r13,%rcx
  801cba:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbf:	4c 89 fe             	mov    %r15,%rsi
  801cc2:	bf 00 00 00 00       	mov    $0x0,%edi
  801cc7:	48 b8 cf 14 80 00 00 	movabs $0x8014cf,%rax
  801cce:	00 00 00 
  801cd1:	ff d0                	call   *%rax
  801cd3:	89 c3                	mov    %eax,%ebx
  801cd5:	85 c0                	test   %eax,%eax
  801cd7:	78 14                	js     801ced <dup+0xfb>

    return newfdnum;
  801cd9:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801cdc:	89 d8                	mov    %ebx,%eax
  801cde:	48 83 c4 18          	add    $0x18,%rsp
  801ce2:	5b                   	pop    %rbx
  801ce3:	41 5c                	pop    %r12
  801ce5:	41 5d                	pop    %r13
  801ce7:	41 5e                	pop    %r14
  801ce9:	41 5f                	pop    %r15
  801ceb:	5d                   	pop    %rbp
  801cec:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801ced:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cf2:	4c 89 ee             	mov    %r13,%rsi
  801cf5:	bf 00 00 00 00       	mov    $0x0,%edi
  801cfa:	49 bc a4 15 80 00 00 	movabs $0x8015a4,%r12
  801d01:	00 00 00 
  801d04:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801d07:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d0c:	4c 89 f6             	mov    %r14,%rsi
  801d0f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d14:	41 ff d4             	call   *%r12
    return res;
  801d17:	eb c3                	jmp    801cdc <dup+0xea>

0000000000801d19 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801d19:	f3 0f 1e fa          	endbr64
  801d1d:	55                   	push   %rbp
  801d1e:	48 89 e5             	mov    %rsp,%rbp
  801d21:	41 56                	push   %r14
  801d23:	41 55                	push   %r13
  801d25:	41 54                	push   %r12
  801d27:	53                   	push   %rbx
  801d28:	48 83 ec 10          	sub    $0x10,%rsp
  801d2c:	89 fb                	mov    %edi,%ebx
  801d2e:	49 89 f4             	mov    %rsi,%r12
  801d31:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d34:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d38:	48 b8 1e 1a 80 00 00 	movabs $0x801a1e,%rax
  801d3f:	00 00 00 
  801d42:	ff d0                	call   *%rax
  801d44:	85 c0                	test   %eax,%eax
  801d46:	78 4c                	js     801d94 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d48:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801d4c:	41 8b 3e             	mov    (%r14),%edi
  801d4f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d53:	48 b8 6d 1a 80 00 00 	movabs $0x801a6d,%rax
  801d5a:	00 00 00 
  801d5d:	ff d0                	call   *%rax
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	78 35                	js     801d98 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d63:	41 8b 46 08          	mov    0x8(%r14),%eax
  801d67:	83 e0 03             	and    $0x3,%eax
  801d6a:	83 f8 01             	cmp    $0x1,%eax
  801d6d:	74 2d                	je     801d9c <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801d6f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d73:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d77:	48 85 c0             	test   %rax,%rax
  801d7a:	74 56                	je     801dd2 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801d7c:	4c 89 ea             	mov    %r13,%rdx
  801d7f:	4c 89 e6             	mov    %r12,%rsi
  801d82:	4c 89 f7             	mov    %r14,%rdi
  801d85:	ff d0                	call   *%rax
}
  801d87:	48 83 c4 10          	add    $0x10,%rsp
  801d8b:	5b                   	pop    %rbx
  801d8c:	41 5c                	pop    %r12
  801d8e:	41 5d                	pop    %r13
  801d90:	41 5e                	pop    %r14
  801d92:	5d                   	pop    %rbp
  801d93:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d94:	48 98                	cltq
  801d96:	eb ef                	jmp    801d87 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d98:	48 98                	cltq
  801d9a:	eb eb                	jmp    801d87 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d9c:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801da3:	00 00 00 
  801da6:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801dac:	89 da                	mov    %ebx,%edx
  801dae:	48 bf b6 43 80 00 00 	movabs $0x8043b6,%rdi
  801db5:	00 00 00 
  801db8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbd:	48 b9 16 05 80 00 00 	movabs $0x800516,%rcx
  801dc4:	00 00 00 
  801dc7:	ff d1                	call   *%rcx
        return -E_INVAL;
  801dc9:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801dd0:	eb b5                	jmp    801d87 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801dd2:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801dd9:	eb ac                	jmp    801d87 <read+0x6e>

0000000000801ddb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801ddb:	f3 0f 1e fa          	endbr64
  801ddf:	55                   	push   %rbp
  801de0:	48 89 e5             	mov    %rsp,%rbp
  801de3:	41 57                	push   %r15
  801de5:	41 56                	push   %r14
  801de7:	41 55                	push   %r13
  801de9:	41 54                	push   %r12
  801deb:	53                   	push   %rbx
  801dec:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801df0:	48 85 d2             	test   %rdx,%rdx
  801df3:	74 54                	je     801e49 <readn+0x6e>
  801df5:	41 89 fd             	mov    %edi,%r13d
  801df8:	49 89 f6             	mov    %rsi,%r14
  801dfb:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801dfe:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801e03:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801e08:	49 bf 19 1d 80 00 00 	movabs $0x801d19,%r15
  801e0f:	00 00 00 
  801e12:	4c 89 e2             	mov    %r12,%rdx
  801e15:	48 29 f2             	sub    %rsi,%rdx
  801e18:	4c 01 f6             	add    %r14,%rsi
  801e1b:	44 89 ef             	mov    %r13d,%edi
  801e1e:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801e21:	85 c0                	test   %eax,%eax
  801e23:	78 20                	js     801e45 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801e25:	01 c3                	add    %eax,%ebx
  801e27:	85 c0                	test   %eax,%eax
  801e29:	74 08                	je     801e33 <readn+0x58>
  801e2b:	48 63 f3             	movslq %ebx,%rsi
  801e2e:	4c 39 e6             	cmp    %r12,%rsi
  801e31:	72 df                	jb     801e12 <readn+0x37>
    }
    return res;
  801e33:	48 63 c3             	movslq %ebx,%rax
}
  801e36:	48 83 c4 08          	add    $0x8,%rsp
  801e3a:	5b                   	pop    %rbx
  801e3b:	41 5c                	pop    %r12
  801e3d:	41 5d                	pop    %r13
  801e3f:	41 5e                	pop    %r14
  801e41:	41 5f                	pop    %r15
  801e43:	5d                   	pop    %rbp
  801e44:	c3                   	ret
        if (inc < 0) return inc;
  801e45:	48 98                	cltq
  801e47:	eb ed                	jmp    801e36 <readn+0x5b>
    int inc = 1, res = 0;
  801e49:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e4e:	eb e3                	jmp    801e33 <readn+0x58>

0000000000801e50 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801e50:	f3 0f 1e fa          	endbr64
  801e54:	55                   	push   %rbp
  801e55:	48 89 e5             	mov    %rsp,%rbp
  801e58:	41 56                	push   %r14
  801e5a:	41 55                	push   %r13
  801e5c:	41 54                	push   %r12
  801e5e:	53                   	push   %rbx
  801e5f:	48 83 ec 10          	sub    $0x10,%rsp
  801e63:	89 fb                	mov    %edi,%ebx
  801e65:	49 89 f4             	mov    %rsi,%r12
  801e68:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e6b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e6f:	48 b8 1e 1a 80 00 00 	movabs $0x801a1e,%rax
  801e76:	00 00 00 
  801e79:	ff d0                	call   *%rax
  801e7b:	85 c0                	test   %eax,%eax
  801e7d:	78 47                	js     801ec6 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e7f:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801e83:	41 8b 3e             	mov    (%r14),%edi
  801e86:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e8a:	48 b8 6d 1a 80 00 00 	movabs $0x801a6d,%rax
  801e91:	00 00 00 
  801e94:	ff d0                	call   *%rax
  801e96:	85 c0                	test   %eax,%eax
  801e98:	78 30                	js     801eca <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e9a:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801e9f:	74 2d                	je     801ece <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801ea1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ea5:	48 8b 40 18          	mov    0x18(%rax),%rax
  801ea9:	48 85 c0             	test   %rax,%rax
  801eac:	74 56                	je     801f04 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801eae:	4c 89 ea             	mov    %r13,%rdx
  801eb1:	4c 89 e6             	mov    %r12,%rsi
  801eb4:	4c 89 f7             	mov    %r14,%rdi
  801eb7:	ff d0                	call   *%rax
}
  801eb9:	48 83 c4 10          	add    $0x10,%rsp
  801ebd:	5b                   	pop    %rbx
  801ebe:	41 5c                	pop    %r12
  801ec0:	41 5d                	pop    %r13
  801ec2:	41 5e                	pop    %r14
  801ec4:	5d                   	pop    %rbp
  801ec5:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ec6:	48 98                	cltq
  801ec8:	eb ef                	jmp    801eb9 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801eca:	48 98                	cltq
  801ecc:	eb eb                	jmp    801eb9 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ece:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801ed5:	00 00 00 
  801ed8:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ede:	89 da                	mov    %ebx,%edx
  801ee0:	48 bf d2 43 80 00 00 	movabs $0x8043d2,%rdi
  801ee7:	00 00 00 
  801eea:	b8 00 00 00 00       	mov    $0x0,%eax
  801eef:	48 b9 16 05 80 00 00 	movabs $0x800516,%rcx
  801ef6:	00 00 00 
  801ef9:	ff d1                	call   *%rcx
        return -E_INVAL;
  801efb:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801f02:	eb b5                	jmp    801eb9 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801f04:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801f0b:	eb ac                	jmp    801eb9 <write+0x69>

0000000000801f0d <seek>:

int
seek(int fdnum, off_t offset) {
  801f0d:	f3 0f 1e fa          	endbr64
  801f11:	55                   	push   %rbp
  801f12:	48 89 e5             	mov    %rsp,%rbp
  801f15:	53                   	push   %rbx
  801f16:	48 83 ec 18          	sub    $0x18,%rsp
  801f1a:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f1c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f20:	48 b8 1e 1a 80 00 00 	movabs $0x801a1e,%rax
  801f27:	00 00 00 
  801f2a:	ff d0                	call   *%rax
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	78 0c                	js     801f3c <seek+0x2f>

    fd->fd_offset = offset;
  801f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f34:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f40:	c9                   	leave
  801f41:	c3                   	ret

0000000000801f42 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801f42:	f3 0f 1e fa          	endbr64
  801f46:	55                   	push   %rbp
  801f47:	48 89 e5             	mov    %rsp,%rbp
  801f4a:	41 55                	push   %r13
  801f4c:	41 54                	push   %r12
  801f4e:	53                   	push   %rbx
  801f4f:	48 83 ec 18          	sub    $0x18,%rsp
  801f53:	89 fb                	mov    %edi,%ebx
  801f55:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f58:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801f5c:	48 b8 1e 1a 80 00 00 	movabs $0x801a1e,%rax
  801f63:	00 00 00 
  801f66:	ff d0                	call   *%rax
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	78 38                	js     801fa4 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f6c:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801f70:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801f74:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f78:	48 b8 6d 1a 80 00 00 	movabs $0x801a6d,%rax
  801f7f:	00 00 00 
  801f82:	ff d0                	call   *%rax
  801f84:	85 c0                	test   %eax,%eax
  801f86:	78 1c                	js     801fa4 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f88:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801f8d:	74 20                	je     801faf <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f93:	48 8b 40 30          	mov    0x30(%rax),%rax
  801f97:	48 85 c0             	test   %rax,%rax
  801f9a:	74 47                	je     801fe3 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801f9c:	44 89 e6             	mov    %r12d,%esi
  801f9f:	4c 89 ef             	mov    %r13,%rdi
  801fa2:	ff d0                	call   *%rax
}
  801fa4:	48 83 c4 18          	add    $0x18,%rsp
  801fa8:	5b                   	pop    %rbx
  801fa9:	41 5c                	pop    %r12
  801fab:	41 5d                	pop    %r13
  801fad:	5d                   	pop    %rbp
  801fae:	c3                   	ret
                thisenv->env_id, fdnum);
  801faf:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801fb6:	00 00 00 
  801fb9:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801fbf:	89 da                	mov    %ebx,%edx
  801fc1:	48 bf e0 40 80 00 00 	movabs $0x8040e0,%rdi
  801fc8:	00 00 00 
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd0:	48 b9 16 05 80 00 00 	movabs $0x800516,%rcx
  801fd7:	00 00 00 
  801fda:	ff d1                	call   *%rcx
        return -E_INVAL;
  801fdc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fe1:	eb c1                	jmp    801fa4 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801fe3:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801fe8:	eb ba                	jmp    801fa4 <ftruncate+0x62>

0000000000801fea <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801fea:	f3 0f 1e fa          	endbr64
  801fee:	55                   	push   %rbp
  801fef:	48 89 e5             	mov    %rsp,%rbp
  801ff2:	41 54                	push   %r12
  801ff4:	53                   	push   %rbx
  801ff5:	48 83 ec 10          	sub    $0x10,%rsp
  801ff9:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ffc:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802000:	48 b8 1e 1a 80 00 00 	movabs $0x801a1e,%rax
  802007:	00 00 00 
  80200a:	ff d0                	call   *%rax
  80200c:	85 c0                	test   %eax,%eax
  80200e:	78 4e                	js     80205e <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802010:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  802014:	41 8b 3c 24          	mov    (%r12),%edi
  802018:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  80201c:	48 b8 6d 1a 80 00 00 	movabs $0x801a6d,%rax
  802023:	00 00 00 
  802026:	ff d0                	call   *%rax
  802028:	85 c0                	test   %eax,%eax
  80202a:	78 32                	js     80205e <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  80202c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802030:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  802035:	74 30                	je     802067 <fstat+0x7d>

    stat->st_name[0] = 0;
  802037:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  80203a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  802041:	00 00 00 
    stat->st_isdir = 0;
  802044:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80204b:	00 00 00 
    stat->st_dev = dev;
  80204e:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  802055:	48 89 de             	mov    %rbx,%rsi
  802058:	4c 89 e7             	mov    %r12,%rdi
  80205b:	ff 50 28             	call   *0x28(%rax)
}
  80205e:	48 83 c4 10          	add    $0x10,%rsp
  802062:	5b                   	pop    %rbx
  802063:	41 5c                	pop    %r12
  802065:	5d                   	pop    %rbp
  802066:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802067:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  80206c:	eb f0                	jmp    80205e <fstat+0x74>

000000000080206e <stat>:

int
stat(const char *path, struct Stat *stat) {
  80206e:	f3 0f 1e fa          	endbr64
  802072:	55                   	push   %rbp
  802073:	48 89 e5             	mov    %rsp,%rbp
  802076:	41 54                	push   %r12
  802078:	53                   	push   %rbx
  802079:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  80207c:	be 00 00 00 00       	mov    $0x0,%esi
  802081:	48 b8 4f 23 80 00 00 	movabs $0x80234f,%rax
  802088:	00 00 00 
  80208b:	ff d0                	call   *%rax
  80208d:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  80208f:	85 c0                	test   %eax,%eax
  802091:	78 25                	js     8020b8 <stat+0x4a>

    int res = fstat(fd, stat);
  802093:	4c 89 e6             	mov    %r12,%rsi
  802096:	89 c7                	mov    %eax,%edi
  802098:	48 b8 ea 1f 80 00 00 	movabs $0x801fea,%rax
  80209f:	00 00 00 
  8020a2:	ff d0                	call   *%rax
  8020a4:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  8020a7:	89 df                	mov    %ebx,%edi
  8020a9:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  8020b0:	00 00 00 
  8020b3:	ff d0                	call   *%rax

    return res;
  8020b5:	44 89 e3             	mov    %r12d,%ebx
}
  8020b8:	89 d8                	mov    %ebx,%eax
  8020ba:	5b                   	pop    %rbx
  8020bb:	41 5c                	pop    %r12
  8020bd:	5d                   	pop    %rbp
  8020be:	c3                   	ret

00000000008020bf <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  8020bf:	f3 0f 1e fa          	endbr64
  8020c3:	55                   	push   %rbp
  8020c4:	48 89 e5             	mov    %rsp,%rbp
  8020c7:	41 54                	push   %r12
  8020c9:	53                   	push   %rbx
  8020ca:	48 83 ec 10          	sub    $0x10,%rsp
  8020ce:	41 89 fc             	mov    %edi,%r12d
  8020d1:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8020d4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8020db:	00 00 00 
  8020de:	83 38 00             	cmpl   $0x0,(%rax)
  8020e1:	74 6e                	je     802151 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  8020e3:	bf 03 00 00 00       	mov    $0x3,%edi
  8020e8:	48 b8 cc 30 80 00 00 	movabs $0x8030cc,%rax
  8020ef:	00 00 00 
  8020f2:	ff d0                	call   *%rax
  8020f4:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  8020fb:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  8020fd:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802103:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802108:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80210f:	00 00 00 
  802112:	44 89 e6             	mov    %r12d,%esi
  802115:	89 c7                	mov    %eax,%edi
  802117:	48 b8 0a 30 80 00 00 	movabs $0x80300a,%rax
  80211e:	00 00 00 
  802121:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802123:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  80212a:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  80212b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802130:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802134:	48 89 de             	mov    %rbx,%rsi
  802137:	bf 00 00 00 00       	mov    $0x0,%edi
  80213c:	48 b8 71 2f 80 00 00 	movabs $0x802f71,%rax
  802143:	00 00 00 
  802146:	ff d0                	call   *%rax
}
  802148:	48 83 c4 10          	add    $0x10,%rsp
  80214c:	5b                   	pop    %rbx
  80214d:	41 5c                	pop    %r12
  80214f:	5d                   	pop    %rbp
  802150:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802151:	bf 03 00 00 00       	mov    $0x3,%edi
  802156:	48 b8 cc 30 80 00 00 	movabs $0x8030cc,%rax
  80215d:	00 00 00 
  802160:	ff d0                	call   *%rax
  802162:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802169:	00 00 
  80216b:	e9 73 ff ff ff       	jmp    8020e3 <fsipc+0x24>

0000000000802170 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802170:	f3 0f 1e fa          	endbr64
  802174:	55                   	push   %rbp
  802175:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802178:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80217f:	00 00 00 
  802182:	8b 57 0c             	mov    0xc(%rdi),%edx
  802185:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802187:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  80218a:	be 00 00 00 00       	mov    $0x0,%esi
  80218f:	bf 02 00 00 00       	mov    $0x2,%edi
  802194:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  80219b:	00 00 00 
  80219e:	ff d0                	call   *%rax
}
  8021a0:	5d                   	pop    %rbp
  8021a1:	c3                   	ret

00000000008021a2 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8021a2:	f3 0f 1e fa          	endbr64
  8021a6:	55                   	push   %rbp
  8021a7:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8021aa:	8b 47 0c             	mov    0xc(%rdi),%eax
  8021ad:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8021b4:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  8021b6:	be 00 00 00 00       	mov    $0x0,%esi
  8021bb:	bf 06 00 00 00       	mov    $0x6,%edi
  8021c0:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  8021c7:	00 00 00 
  8021ca:	ff d0                	call   *%rax
}
  8021cc:	5d                   	pop    %rbp
  8021cd:	c3                   	ret

00000000008021ce <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  8021ce:	f3 0f 1e fa          	endbr64
  8021d2:	55                   	push   %rbp
  8021d3:	48 89 e5             	mov    %rsp,%rbp
  8021d6:	41 54                	push   %r12
  8021d8:	53                   	push   %rbx
  8021d9:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8021dc:	8b 47 0c             	mov    0xc(%rdi),%eax
  8021df:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8021e6:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  8021e8:	be 00 00 00 00       	mov    $0x0,%esi
  8021ed:	bf 05 00 00 00       	mov    $0x5,%edi
  8021f2:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  8021f9:	00 00 00 
  8021fc:	ff d0                	call   *%rax
    if (res < 0) return res;
  8021fe:	85 c0                	test   %eax,%eax
  802200:	78 3d                	js     80223f <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802202:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  802209:	00 00 00 
  80220c:	4c 89 e6             	mov    %r12,%rsi
  80220f:	48 89 df             	mov    %rbx,%rdi
  802212:	48 b8 5f 0e 80 00 00 	movabs $0x800e5f,%rax
  802219:	00 00 00 
  80221c:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  80221e:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  802225:	00 
  802226:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80222c:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  802233:	00 
  802234:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  80223a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223f:	5b                   	pop    %rbx
  802240:	41 5c                	pop    %r12
  802242:	5d                   	pop    %rbp
  802243:	c3                   	ret

0000000000802244 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802244:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  802248:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  80224f:	77 41                	ja     802292 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802251:	55                   	push   %rbp
  802252:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  802255:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80225c:	00 00 00 
  80225f:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802262:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802264:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802268:	48 8d 78 10          	lea    0x10(%rax),%rdi
  80226c:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  802273:	00 00 00 
  802276:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802278:	be 00 00 00 00       	mov    $0x0,%esi
  80227d:	bf 04 00 00 00       	mov    $0x4,%edi
  802282:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  802289:	00 00 00 
  80228c:	ff d0                	call   *%rax
  80228e:	48 98                	cltq
}
  802290:	5d                   	pop    %rbp
  802291:	c3                   	ret
        return -E_INVAL;
  802292:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802299:	c3                   	ret

000000000080229a <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80229a:	f3 0f 1e fa          	endbr64
  80229e:	55                   	push   %rbp
  80229f:	48 89 e5             	mov    %rsp,%rbp
  8022a2:	41 55                	push   %r13
  8022a4:	41 54                	push   %r12
  8022a6:	53                   	push   %rbx
  8022a7:	48 83 ec 08          	sub    $0x8,%rsp
  8022ab:	49 89 f4             	mov    %rsi,%r12
  8022ae:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  8022b1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8022b8:	00 00 00 
  8022bb:	8b 57 0c             	mov    0xc(%rdi),%edx
  8022be:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  8022c0:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  8022c4:	be 00 00 00 00       	mov    $0x0,%esi
  8022c9:	bf 03 00 00 00       	mov    $0x3,%edi
  8022ce:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  8022d5:	00 00 00 
  8022d8:	ff d0                	call   *%rax
  8022da:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  8022dd:	4d 85 ed             	test   %r13,%r13
  8022e0:	78 2a                	js     80230c <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  8022e2:	4c 89 ea             	mov    %r13,%rdx
  8022e5:	4c 39 eb             	cmp    %r13,%rbx
  8022e8:	72 30                	jb     80231a <devfile_read+0x80>
  8022ea:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  8022f1:	7f 27                	jg     80231a <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  8022f3:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8022fa:	00 00 00 
  8022fd:	4c 89 e7             	mov    %r12,%rdi
  802300:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  802307:	00 00 00 
  80230a:	ff d0                	call   *%rax
}
  80230c:	4c 89 e8             	mov    %r13,%rax
  80230f:	48 83 c4 08          	add    $0x8,%rsp
  802313:	5b                   	pop    %rbx
  802314:	41 5c                	pop    %r12
  802316:	41 5d                	pop    %r13
  802318:	5d                   	pop    %rbp
  802319:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  80231a:	48 b9 ef 43 80 00 00 	movabs $0x8043ef,%rcx
  802321:	00 00 00 
  802324:	48 ba 0c 44 80 00 00 	movabs $0x80440c,%rdx
  80232b:	00 00 00 
  80232e:	be 7b 00 00 00       	mov    $0x7b,%esi
  802333:	48 bf 21 44 80 00 00 	movabs $0x804421,%rdi
  80233a:	00 00 00 
  80233d:	b8 00 00 00 00       	mov    $0x0,%eax
  802342:	49 b8 ba 03 80 00 00 	movabs $0x8003ba,%r8
  802349:	00 00 00 
  80234c:	41 ff d0             	call   *%r8

000000000080234f <open>:
open(const char *path, int mode) {
  80234f:	f3 0f 1e fa          	endbr64
  802353:	55                   	push   %rbp
  802354:	48 89 e5             	mov    %rsp,%rbp
  802357:	41 55                	push   %r13
  802359:	41 54                	push   %r12
  80235b:	53                   	push   %rbx
  80235c:	48 83 ec 18          	sub    $0x18,%rsp
  802360:	49 89 fc             	mov    %rdi,%r12
  802363:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802366:	48 b8 1a 0e 80 00 00 	movabs $0x800e1a,%rax
  80236d:	00 00 00 
  802370:	ff d0                	call   *%rax
  802372:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802378:	0f 87 8a 00 00 00    	ja     802408 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80237e:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802382:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  802389:	00 00 00 
  80238c:	ff d0                	call   *%rax
  80238e:	89 c3                	mov    %eax,%ebx
  802390:	85 c0                	test   %eax,%eax
  802392:	78 50                	js     8023e4 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802394:	4c 89 e6             	mov    %r12,%rsi
  802397:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  80239e:	00 00 00 
  8023a1:	48 89 df             	mov    %rbx,%rdi
  8023a4:	48 b8 5f 0e 80 00 00 	movabs $0x800e5f,%rax
  8023ab:	00 00 00 
  8023ae:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8023b0:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8023b7:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8023bb:	bf 01 00 00 00       	mov    $0x1,%edi
  8023c0:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  8023c7:	00 00 00 
  8023ca:	ff d0                	call   *%rax
  8023cc:	89 c3                	mov    %eax,%ebx
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	78 1f                	js     8023f1 <open+0xa2>
    return fd2num(fd);
  8023d2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023d6:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  8023dd:	00 00 00 
  8023e0:	ff d0                	call   *%rax
  8023e2:	89 c3                	mov    %eax,%ebx
}
  8023e4:	89 d8                	mov    %ebx,%eax
  8023e6:	48 83 c4 18          	add    $0x18,%rsp
  8023ea:	5b                   	pop    %rbx
  8023eb:	41 5c                	pop    %r12
  8023ed:	41 5d                	pop    %r13
  8023ef:	5d                   	pop    %rbp
  8023f0:	c3                   	ret
        fd_close(fd, 0);
  8023f1:	be 00 00 00 00       	mov    $0x0,%esi
  8023f6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023fa:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
  802401:	00 00 00 
  802404:	ff d0                	call   *%rax
        return res;
  802406:	eb dc                	jmp    8023e4 <open+0x95>
        return -E_BAD_PATH;
  802408:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80240d:	eb d5                	jmp    8023e4 <open+0x95>

000000000080240f <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80240f:	f3 0f 1e fa          	endbr64
  802413:	55                   	push   %rbp
  802414:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802417:	be 00 00 00 00       	mov    $0x0,%esi
  80241c:	bf 08 00 00 00       	mov    $0x8,%edi
  802421:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  802428:	00 00 00 
  80242b:	ff d0                	call   *%rax
}
  80242d:	5d                   	pop    %rbp
  80242e:	c3                   	ret

000000000080242f <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80242f:	f3 0f 1e fa          	endbr64
  802433:	55                   	push   %rbp
  802434:	48 89 e5             	mov    %rsp,%rbp
  802437:	41 54                	push   %r12
  802439:	53                   	push   %rbx
  80243a:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80243d:	48 b8 9a 19 80 00 00 	movabs $0x80199a,%rax
  802444:	00 00 00 
  802447:	ff d0                	call   *%rax
  802449:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80244c:	48 be 2c 44 80 00 00 	movabs $0x80442c,%rsi
  802453:	00 00 00 
  802456:	48 89 df             	mov    %rbx,%rdi
  802459:	48 b8 5f 0e 80 00 00 	movabs $0x800e5f,%rax
  802460:	00 00 00 
  802463:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802465:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80246a:	41 2b 04 24          	sub    (%r12),%eax
  80246e:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802474:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80247b:	00 00 00 
    stat->st_dev = &devpipe;
  80247e:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802485:	00 00 00 
  802488:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80248f:	b8 00 00 00 00       	mov    $0x0,%eax
  802494:	5b                   	pop    %rbx
  802495:	41 5c                	pop    %r12
  802497:	5d                   	pop    %rbp
  802498:	c3                   	ret

0000000000802499 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802499:	f3 0f 1e fa          	endbr64
  80249d:	55                   	push   %rbp
  80249e:	48 89 e5             	mov    %rsp,%rbp
  8024a1:	41 54                	push   %r12
  8024a3:	53                   	push   %rbx
  8024a4:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8024a7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024ac:	48 89 fe             	mov    %rdi,%rsi
  8024af:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b4:	49 bc a4 15 80 00 00 	movabs $0x8015a4,%r12
  8024bb:	00 00 00 
  8024be:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8024c1:	48 89 df             	mov    %rbx,%rdi
  8024c4:	48 b8 9a 19 80 00 00 	movabs $0x80199a,%rax
  8024cb:	00 00 00 
  8024ce:	ff d0                	call   *%rax
  8024d0:	48 89 c6             	mov    %rax,%rsi
  8024d3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8024dd:	41 ff d4             	call   *%r12
}
  8024e0:	5b                   	pop    %rbx
  8024e1:	41 5c                	pop    %r12
  8024e3:	5d                   	pop    %rbp
  8024e4:	c3                   	ret

00000000008024e5 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8024e5:	f3 0f 1e fa          	endbr64
  8024e9:	55                   	push   %rbp
  8024ea:	48 89 e5             	mov    %rsp,%rbp
  8024ed:	41 57                	push   %r15
  8024ef:	41 56                	push   %r14
  8024f1:	41 55                	push   %r13
  8024f3:	41 54                	push   %r12
  8024f5:	53                   	push   %rbx
  8024f6:	48 83 ec 18          	sub    $0x18,%rsp
  8024fa:	49 89 fc             	mov    %rdi,%r12
  8024fd:	49 89 f5             	mov    %rsi,%r13
  802500:	49 89 d7             	mov    %rdx,%r15
  802503:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802507:	48 b8 9a 19 80 00 00 	movabs $0x80199a,%rax
  80250e:	00 00 00 
  802511:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802513:	4d 85 ff             	test   %r15,%r15
  802516:	0f 84 af 00 00 00    	je     8025cb <devpipe_write+0xe6>
  80251c:	48 89 c3             	mov    %rax,%rbx
  80251f:	4c 89 f8             	mov    %r15,%rax
  802522:	4d 89 ef             	mov    %r13,%r15
  802525:	4c 01 e8             	add    %r13,%rax
  802528:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80252c:	49 bd 34 14 80 00 00 	movabs $0x801434,%r13
  802533:	00 00 00 
            sys_yield();
  802536:	49 be c9 13 80 00 00 	movabs $0x8013c9,%r14
  80253d:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802540:	8b 73 04             	mov    0x4(%rbx),%esi
  802543:	48 63 ce             	movslq %esi,%rcx
  802546:	48 63 03             	movslq (%rbx),%rax
  802549:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80254f:	48 39 c1             	cmp    %rax,%rcx
  802552:	72 2e                	jb     802582 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802554:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802559:	48 89 da             	mov    %rbx,%rdx
  80255c:	be 00 10 00 00       	mov    $0x1000,%esi
  802561:	4c 89 e7             	mov    %r12,%rdi
  802564:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802567:	85 c0                	test   %eax,%eax
  802569:	74 66                	je     8025d1 <devpipe_write+0xec>
            sys_yield();
  80256b:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80256e:	8b 73 04             	mov    0x4(%rbx),%esi
  802571:	48 63 ce             	movslq %esi,%rcx
  802574:	48 63 03             	movslq (%rbx),%rax
  802577:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80257d:	48 39 c1             	cmp    %rax,%rcx
  802580:	73 d2                	jae    802554 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802582:	41 0f b6 3f          	movzbl (%r15),%edi
  802586:	48 89 ca             	mov    %rcx,%rdx
  802589:	48 c1 ea 03          	shr    $0x3,%rdx
  80258d:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802594:	08 10 20 
  802597:	48 f7 e2             	mul    %rdx
  80259a:	48 c1 ea 06          	shr    $0x6,%rdx
  80259e:	48 89 d0             	mov    %rdx,%rax
  8025a1:	48 c1 e0 09          	shl    $0x9,%rax
  8025a5:	48 29 d0             	sub    %rdx,%rax
  8025a8:	48 c1 e0 03          	shl    $0x3,%rax
  8025ac:	48 29 c1             	sub    %rax,%rcx
  8025af:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8025b4:	83 c6 01             	add    $0x1,%esi
  8025b7:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8025ba:	49 83 c7 01          	add    $0x1,%r15
  8025be:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8025c2:	49 39 c7             	cmp    %rax,%r15
  8025c5:	0f 85 75 ff ff ff    	jne    802540 <devpipe_write+0x5b>
    return n;
  8025cb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8025cf:	eb 05                	jmp    8025d6 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8025d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d6:	48 83 c4 18          	add    $0x18,%rsp
  8025da:	5b                   	pop    %rbx
  8025db:	41 5c                	pop    %r12
  8025dd:	41 5d                	pop    %r13
  8025df:	41 5e                	pop    %r14
  8025e1:	41 5f                	pop    %r15
  8025e3:	5d                   	pop    %rbp
  8025e4:	c3                   	ret

00000000008025e5 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8025e5:	f3 0f 1e fa          	endbr64
  8025e9:	55                   	push   %rbp
  8025ea:	48 89 e5             	mov    %rsp,%rbp
  8025ed:	41 57                	push   %r15
  8025ef:	41 56                	push   %r14
  8025f1:	41 55                	push   %r13
  8025f3:	41 54                	push   %r12
  8025f5:	53                   	push   %rbx
  8025f6:	48 83 ec 18          	sub    $0x18,%rsp
  8025fa:	49 89 fc             	mov    %rdi,%r12
  8025fd:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802601:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802605:	48 b8 9a 19 80 00 00 	movabs $0x80199a,%rax
  80260c:	00 00 00 
  80260f:	ff d0                	call   *%rax
  802611:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802614:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80261a:	49 bd 34 14 80 00 00 	movabs $0x801434,%r13
  802621:	00 00 00 
            sys_yield();
  802624:	49 be c9 13 80 00 00 	movabs $0x8013c9,%r14
  80262b:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80262e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802633:	74 7d                	je     8026b2 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802635:	8b 03                	mov    (%rbx),%eax
  802637:	3b 43 04             	cmp    0x4(%rbx),%eax
  80263a:	75 26                	jne    802662 <devpipe_read+0x7d>
            if (i > 0) return i;
  80263c:	4d 85 ff             	test   %r15,%r15
  80263f:	75 77                	jne    8026b8 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802641:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802646:	48 89 da             	mov    %rbx,%rdx
  802649:	be 00 10 00 00       	mov    $0x1000,%esi
  80264e:	4c 89 e7             	mov    %r12,%rdi
  802651:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802654:	85 c0                	test   %eax,%eax
  802656:	74 72                	je     8026ca <devpipe_read+0xe5>
            sys_yield();
  802658:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80265b:	8b 03                	mov    (%rbx),%eax
  80265d:	3b 43 04             	cmp    0x4(%rbx),%eax
  802660:	74 df                	je     802641 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802662:	48 63 c8             	movslq %eax,%rcx
  802665:	48 89 ca             	mov    %rcx,%rdx
  802668:	48 c1 ea 03          	shr    $0x3,%rdx
  80266c:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802673:	08 10 20 
  802676:	48 89 d0             	mov    %rdx,%rax
  802679:	48 f7 e6             	mul    %rsi
  80267c:	48 c1 ea 06          	shr    $0x6,%rdx
  802680:	48 89 d0             	mov    %rdx,%rax
  802683:	48 c1 e0 09          	shl    $0x9,%rax
  802687:	48 29 d0             	sub    %rdx,%rax
  80268a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802691:	00 
  802692:	48 89 c8             	mov    %rcx,%rax
  802695:	48 29 d0             	sub    %rdx,%rax
  802698:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80269d:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8026a1:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8026a5:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8026a8:	49 83 c7 01          	add    $0x1,%r15
  8026ac:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8026b0:	75 83                	jne    802635 <devpipe_read+0x50>
    return n;
  8026b2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8026b6:	eb 03                	jmp    8026bb <devpipe_read+0xd6>
            if (i > 0) return i;
  8026b8:	4c 89 f8             	mov    %r15,%rax
}
  8026bb:	48 83 c4 18          	add    $0x18,%rsp
  8026bf:	5b                   	pop    %rbx
  8026c0:	41 5c                	pop    %r12
  8026c2:	41 5d                	pop    %r13
  8026c4:	41 5e                	pop    %r14
  8026c6:	41 5f                	pop    %r15
  8026c8:	5d                   	pop    %rbp
  8026c9:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8026ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cf:	eb ea                	jmp    8026bb <devpipe_read+0xd6>

00000000008026d1 <pipe>:
pipe(int pfd[2]) {
  8026d1:	f3 0f 1e fa          	endbr64
  8026d5:	55                   	push   %rbp
  8026d6:	48 89 e5             	mov    %rsp,%rbp
  8026d9:	41 55                	push   %r13
  8026db:	41 54                	push   %r12
  8026dd:	53                   	push   %rbx
  8026de:	48 83 ec 18          	sub    $0x18,%rsp
  8026e2:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8026e5:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8026e9:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  8026f0:	00 00 00 
  8026f3:	ff d0                	call   *%rax
  8026f5:	89 c3                	mov    %eax,%ebx
  8026f7:	85 c0                	test   %eax,%eax
  8026f9:	0f 88 a0 01 00 00    	js     80289f <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8026ff:	b9 46 00 00 00       	mov    $0x46,%ecx
  802704:	ba 00 10 00 00       	mov    $0x1000,%edx
  802709:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80270d:	bf 00 00 00 00       	mov    $0x0,%edi
  802712:	48 b8 64 14 80 00 00 	movabs $0x801464,%rax
  802719:	00 00 00 
  80271c:	ff d0                	call   *%rax
  80271e:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802720:	85 c0                	test   %eax,%eax
  802722:	0f 88 77 01 00 00    	js     80289f <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802728:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80272c:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  802733:	00 00 00 
  802736:	ff d0                	call   *%rax
  802738:	89 c3                	mov    %eax,%ebx
  80273a:	85 c0                	test   %eax,%eax
  80273c:	0f 88 43 01 00 00    	js     802885 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802742:	b9 46 00 00 00       	mov    $0x46,%ecx
  802747:	ba 00 10 00 00       	mov    $0x1000,%edx
  80274c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802750:	bf 00 00 00 00       	mov    $0x0,%edi
  802755:	48 b8 64 14 80 00 00 	movabs $0x801464,%rax
  80275c:	00 00 00 
  80275f:	ff d0                	call   *%rax
  802761:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802763:	85 c0                	test   %eax,%eax
  802765:	0f 88 1a 01 00 00    	js     802885 <pipe+0x1b4>
    va = fd2data(fd0);
  80276b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80276f:	48 b8 9a 19 80 00 00 	movabs $0x80199a,%rax
  802776:	00 00 00 
  802779:	ff d0                	call   *%rax
  80277b:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80277e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802783:	ba 00 10 00 00       	mov    $0x1000,%edx
  802788:	48 89 c6             	mov    %rax,%rsi
  80278b:	bf 00 00 00 00       	mov    $0x0,%edi
  802790:	48 b8 64 14 80 00 00 	movabs $0x801464,%rax
  802797:	00 00 00 
  80279a:	ff d0                	call   *%rax
  80279c:	89 c3                	mov    %eax,%ebx
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	0f 88 c5 00 00 00    	js     80286b <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8027a6:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8027aa:	48 b8 9a 19 80 00 00 	movabs $0x80199a,%rax
  8027b1:	00 00 00 
  8027b4:	ff d0                	call   *%rax
  8027b6:	48 89 c1             	mov    %rax,%rcx
  8027b9:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8027bf:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8027c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ca:	4c 89 ee             	mov    %r13,%rsi
  8027cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8027d2:	48 b8 cf 14 80 00 00 	movabs $0x8014cf,%rax
  8027d9:	00 00 00 
  8027dc:	ff d0                	call   *%rax
  8027de:	89 c3                	mov    %eax,%ebx
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	78 6e                	js     802852 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8027e4:	be 00 10 00 00       	mov    $0x1000,%esi
  8027e9:	4c 89 ef             	mov    %r13,%rdi
  8027ec:	48 b8 fe 13 80 00 00 	movabs $0x8013fe,%rax
  8027f3:	00 00 00 
  8027f6:	ff d0                	call   *%rax
  8027f8:	83 f8 02             	cmp    $0x2,%eax
  8027fb:	0f 85 ab 00 00 00    	jne    8028ac <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802801:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  802808:	00 00 
  80280a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80280e:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802810:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802814:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80281b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80281f:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802821:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802825:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80282c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802830:	48 bb 84 19 80 00 00 	movabs $0x801984,%rbx
  802837:	00 00 00 
  80283a:	ff d3                	call   *%rbx
  80283c:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802840:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802844:	ff d3                	call   *%rbx
  802846:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80284b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802850:	eb 4d                	jmp    80289f <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802852:	ba 00 10 00 00       	mov    $0x1000,%edx
  802857:	4c 89 ee             	mov    %r13,%rsi
  80285a:	bf 00 00 00 00       	mov    $0x0,%edi
  80285f:	48 b8 a4 15 80 00 00 	movabs $0x8015a4,%rax
  802866:	00 00 00 
  802869:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80286b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802870:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802874:	bf 00 00 00 00       	mov    $0x0,%edi
  802879:	48 b8 a4 15 80 00 00 	movabs $0x8015a4,%rax
  802880:	00 00 00 
  802883:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802885:	ba 00 10 00 00       	mov    $0x1000,%edx
  80288a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80288e:	bf 00 00 00 00       	mov    $0x0,%edi
  802893:	48 b8 a4 15 80 00 00 	movabs $0x8015a4,%rax
  80289a:	00 00 00 
  80289d:	ff d0                	call   *%rax
}
  80289f:	89 d8                	mov    %ebx,%eax
  8028a1:	48 83 c4 18          	add    $0x18,%rsp
  8028a5:	5b                   	pop    %rbx
  8028a6:	41 5c                	pop    %r12
  8028a8:	41 5d                	pop    %r13
  8028aa:	5d                   	pop    %rbp
  8028ab:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8028ac:	48 b9 08 41 80 00 00 	movabs $0x804108,%rcx
  8028b3:	00 00 00 
  8028b6:	48 ba 0c 44 80 00 00 	movabs $0x80440c,%rdx
  8028bd:	00 00 00 
  8028c0:	be 2e 00 00 00       	mov    $0x2e,%esi
  8028c5:	48 bf 33 44 80 00 00 	movabs $0x804433,%rdi
  8028cc:	00 00 00 
  8028cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d4:	49 b8 ba 03 80 00 00 	movabs $0x8003ba,%r8
  8028db:	00 00 00 
  8028de:	41 ff d0             	call   *%r8

00000000008028e1 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8028e1:	f3 0f 1e fa          	endbr64
  8028e5:	55                   	push   %rbp
  8028e6:	48 89 e5             	mov    %rsp,%rbp
  8028e9:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8028ed:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8028f1:	48 b8 1e 1a 80 00 00 	movabs $0x801a1e,%rax
  8028f8:	00 00 00 
  8028fb:	ff d0                	call   *%rax
    if (res < 0) return res;
  8028fd:	85 c0                	test   %eax,%eax
  8028ff:	78 35                	js     802936 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802901:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802905:	48 b8 9a 19 80 00 00 	movabs $0x80199a,%rax
  80290c:	00 00 00 
  80290f:	ff d0                	call   *%rax
  802911:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802914:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802919:	be 00 10 00 00       	mov    $0x1000,%esi
  80291e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802922:	48 b8 34 14 80 00 00 	movabs $0x801434,%rax
  802929:	00 00 00 
  80292c:	ff d0                	call   *%rax
  80292e:	85 c0                	test   %eax,%eax
  802930:	0f 94 c0             	sete   %al
  802933:	0f b6 c0             	movzbl %al,%eax
}
  802936:	c9                   	leave
  802937:	c3                   	ret

0000000000802938 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802938:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80293c:	48 89 f8             	mov    %rdi,%rax
  80293f:	48 c1 e8 27          	shr    $0x27,%rax
  802943:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80294a:	7f 00 00 
  80294d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802951:	f6 c2 01             	test   $0x1,%dl
  802954:	74 6d                	je     8029c3 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802956:	48 89 f8             	mov    %rdi,%rax
  802959:	48 c1 e8 1e          	shr    $0x1e,%rax
  80295d:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802964:	7f 00 00 
  802967:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80296b:	f6 c2 01             	test   $0x1,%dl
  80296e:	74 62                	je     8029d2 <get_uvpt_entry+0x9a>
  802970:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802977:	7f 00 00 
  80297a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80297e:	f6 c2 80             	test   $0x80,%dl
  802981:	75 4f                	jne    8029d2 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802983:	48 89 f8             	mov    %rdi,%rax
  802986:	48 c1 e8 15          	shr    $0x15,%rax
  80298a:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802991:	7f 00 00 
  802994:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802998:	f6 c2 01             	test   $0x1,%dl
  80299b:	74 44                	je     8029e1 <get_uvpt_entry+0xa9>
  80299d:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8029a4:	7f 00 00 
  8029a7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8029ab:	f6 c2 80             	test   $0x80,%dl
  8029ae:	75 31                	jne    8029e1 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  8029b0:	48 c1 ef 0c          	shr    $0xc,%rdi
  8029b4:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8029bb:	7f 00 00 
  8029be:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8029c2:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8029c3:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8029ca:	7f 00 00 
  8029cd:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029d1:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8029d2:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8029d9:	7f 00 00 
  8029dc:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029e0:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8029e1:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8029e8:	7f 00 00 
  8029eb:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029ef:	c3                   	ret

00000000008029f0 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8029f0:	f3 0f 1e fa          	endbr64
  8029f4:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8029f7:	48 89 f9             	mov    %rdi,%rcx
  8029fa:	48 c1 e9 27          	shr    $0x27,%rcx
  8029fe:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802a05:	7f 00 00 
  802a08:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802a0c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802a13:	f6 c1 01             	test   $0x1,%cl
  802a16:	0f 84 b2 00 00 00    	je     802ace <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802a1c:	48 89 f9             	mov    %rdi,%rcx
  802a1f:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802a23:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802a2a:	7f 00 00 
  802a2d:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a31:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802a38:	40 f6 c6 01          	test   $0x1,%sil
  802a3c:	0f 84 8c 00 00 00    	je     802ace <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802a42:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802a49:	7f 00 00 
  802a4c:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a50:	a8 80                	test   $0x80,%al
  802a52:	75 7b                	jne    802acf <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802a54:	48 89 f9             	mov    %rdi,%rcx
  802a57:	48 c1 e9 15          	shr    $0x15,%rcx
  802a5b:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802a62:	7f 00 00 
  802a65:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a69:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802a70:	40 f6 c6 01          	test   $0x1,%sil
  802a74:	74 58                	je     802ace <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802a76:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802a7d:	7f 00 00 
  802a80:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a84:	a8 80                	test   $0x80,%al
  802a86:	75 6c                	jne    802af4 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802a88:	48 89 f9             	mov    %rdi,%rcx
  802a8b:	48 c1 e9 0c          	shr    $0xc,%rcx
  802a8f:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a96:	7f 00 00 
  802a99:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a9d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802aa4:	40 f6 c6 01          	test   $0x1,%sil
  802aa8:	74 24                	je     802ace <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802aaa:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802ab1:	7f 00 00 
  802ab4:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802ab8:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802abf:	ff ff 7f 
  802ac2:	48 21 c8             	and    %rcx,%rax
  802ac5:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802acb:	48 09 d0             	or     %rdx,%rax
}
  802ace:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802acf:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802ad6:	7f 00 00 
  802ad9:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802add:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802ae4:	ff ff 7f 
  802ae7:	48 21 c8             	and    %rcx,%rax
  802aea:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802af0:	48 01 d0             	add    %rdx,%rax
  802af3:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802af4:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802afb:	7f 00 00 
  802afe:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b02:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802b09:	ff ff 7f 
  802b0c:	48 21 c8             	and    %rcx,%rax
  802b0f:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802b15:	48 01 d0             	add    %rdx,%rax
  802b18:	c3                   	ret

0000000000802b19 <get_prot>:

int
get_prot(void *va) {
  802b19:	f3 0f 1e fa          	endbr64
  802b1d:	55                   	push   %rbp
  802b1e:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802b21:	48 b8 38 29 80 00 00 	movabs $0x802938,%rax
  802b28:	00 00 00 
  802b2b:	ff d0                	call   *%rax
  802b2d:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802b30:	83 e0 01             	and    $0x1,%eax
  802b33:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802b36:	89 d1                	mov    %edx,%ecx
  802b38:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802b3e:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802b40:	89 c1                	mov    %eax,%ecx
  802b42:	83 c9 02             	or     $0x2,%ecx
  802b45:	f6 c2 02             	test   $0x2,%dl
  802b48:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802b4b:	89 c1                	mov    %eax,%ecx
  802b4d:	83 c9 01             	or     $0x1,%ecx
  802b50:	48 85 d2             	test   %rdx,%rdx
  802b53:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802b56:	89 c1                	mov    %eax,%ecx
  802b58:	83 c9 40             	or     $0x40,%ecx
  802b5b:	f6 c6 04             	test   $0x4,%dh
  802b5e:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802b61:	5d                   	pop    %rbp
  802b62:	c3                   	ret

0000000000802b63 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802b63:	f3 0f 1e fa          	endbr64
  802b67:	55                   	push   %rbp
  802b68:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802b6b:	48 b8 38 29 80 00 00 	movabs $0x802938,%rax
  802b72:	00 00 00 
  802b75:	ff d0                	call   *%rax
    return pte & PTE_D;
  802b77:	48 c1 e8 06          	shr    $0x6,%rax
  802b7b:	83 e0 01             	and    $0x1,%eax
}
  802b7e:	5d                   	pop    %rbp
  802b7f:	c3                   	ret

0000000000802b80 <is_page_present>:

bool
is_page_present(void *va) {
  802b80:	f3 0f 1e fa          	endbr64
  802b84:	55                   	push   %rbp
  802b85:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802b88:	48 b8 38 29 80 00 00 	movabs $0x802938,%rax
  802b8f:	00 00 00 
  802b92:	ff d0                	call   *%rax
  802b94:	83 e0 01             	and    $0x1,%eax
}
  802b97:	5d                   	pop    %rbp
  802b98:	c3                   	ret

0000000000802b99 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802b99:	f3 0f 1e fa          	endbr64
  802b9d:	55                   	push   %rbp
  802b9e:	48 89 e5             	mov    %rsp,%rbp
  802ba1:	41 57                	push   %r15
  802ba3:	41 56                	push   %r14
  802ba5:	41 55                	push   %r13
  802ba7:	41 54                	push   %r12
  802ba9:	53                   	push   %rbx
  802baa:	48 83 ec 18          	sub    $0x18,%rsp
  802bae:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802bb2:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802bb6:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802bbb:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802bc2:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802bc5:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802bcc:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802bcf:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802bd6:	00 00 00 
  802bd9:	eb 73                	jmp    802c4e <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802bdb:	48 89 d8             	mov    %rbx,%rax
  802bde:	48 c1 e8 15          	shr    $0x15,%rax
  802be2:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802be9:	7f 00 00 
  802bec:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802bf0:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802bf6:	f6 c2 01             	test   $0x1,%dl
  802bf9:	74 4b                	je     802c46 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802bfb:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802bff:	f6 c2 80             	test   $0x80,%dl
  802c02:	74 11                	je     802c15 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802c04:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802c08:	f6 c4 04             	test   $0x4,%ah
  802c0b:	74 39                	je     802c46 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802c0d:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802c13:	eb 20                	jmp    802c35 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802c15:	48 89 da             	mov    %rbx,%rdx
  802c18:	48 c1 ea 0c          	shr    $0xc,%rdx
  802c1c:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802c23:	7f 00 00 
  802c26:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802c2a:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802c30:	f6 c4 04             	test   $0x4,%ah
  802c33:	74 11                	je     802c46 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802c35:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802c39:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802c3d:	48 89 df             	mov    %rbx,%rdi
  802c40:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c44:	ff d0                	call   *%rax
    next:
        va += size;
  802c46:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802c49:	49 39 df             	cmp    %rbx,%r15
  802c4c:	72 3e                	jb     802c8c <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802c4e:	49 8b 06             	mov    (%r14),%rax
  802c51:	a8 01                	test   $0x1,%al
  802c53:	74 37                	je     802c8c <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c55:	48 89 d8             	mov    %rbx,%rax
  802c58:	48 c1 e8 1e          	shr    $0x1e,%rax
  802c5c:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802c61:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c67:	f6 c2 01             	test   $0x1,%dl
  802c6a:	74 da                	je     802c46 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802c6c:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802c71:	f6 c2 80             	test   $0x80,%dl
  802c74:	0f 84 61 ff ff ff    	je     802bdb <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802c7a:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802c7f:	f6 c4 04             	test   $0x4,%ah
  802c82:	74 c2                	je     802c46 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802c84:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802c8a:	eb a9                	jmp    802c35 <foreach_shared_region+0x9c>
    }
    return res;
}
  802c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c91:	48 83 c4 18          	add    $0x18,%rsp
  802c95:	5b                   	pop    %rbx
  802c96:	41 5c                	pop    %r12
  802c98:	41 5d                	pop    %r13
  802c9a:	41 5e                	pop    %r14
  802c9c:	41 5f                	pop    %r15
  802c9e:	5d                   	pop    %rbp
  802c9f:	c3                   	ret

0000000000802ca0 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802ca0:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802ca4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca9:	c3                   	ret

0000000000802caa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802caa:	f3 0f 1e fa          	endbr64
  802cae:	55                   	push   %rbp
  802caf:	48 89 e5             	mov    %rsp,%rbp
  802cb2:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802cb5:	48 be 43 44 80 00 00 	movabs $0x804443,%rsi
  802cbc:	00 00 00 
  802cbf:	48 b8 5f 0e 80 00 00 	movabs $0x800e5f,%rax
  802cc6:	00 00 00 
  802cc9:	ff d0                	call   *%rax
    return 0;
}
  802ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd0:	5d                   	pop    %rbp
  802cd1:	c3                   	ret

0000000000802cd2 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802cd2:	f3 0f 1e fa          	endbr64
  802cd6:	55                   	push   %rbp
  802cd7:	48 89 e5             	mov    %rsp,%rbp
  802cda:	41 57                	push   %r15
  802cdc:	41 56                	push   %r14
  802cde:	41 55                	push   %r13
  802ce0:	41 54                	push   %r12
  802ce2:	53                   	push   %rbx
  802ce3:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802cea:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802cf1:	48 85 d2             	test   %rdx,%rdx
  802cf4:	74 7a                	je     802d70 <devcons_write+0x9e>
  802cf6:	49 89 d6             	mov    %rdx,%r14
  802cf9:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802cff:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802d04:	49 bf 7a 10 80 00 00 	movabs $0x80107a,%r15
  802d0b:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802d0e:	4c 89 f3             	mov    %r14,%rbx
  802d11:	48 29 f3             	sub    %rsi,%rbx
  802d14:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802d19:	48 39 c3             	cmp    %rax,%rbx
  802d1c:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802d20:	4c 63 eb             	movslq %ebx,%r13
  802d23:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802d2a:	48 01 c6             	add    %rax,%rsi
  802d2d:	4c 89 ea             	mov    %r13,%rdx
  802d30:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802d37:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802d3a:	4c 89 ee             	mov    %r13,%rsi
  802d3d:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802d44:	48 b8 bf 12 80 00 00 	movabs $0x8012bf,%rax
  802d4b:	00 00 00 
  802d4e:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802d50:	41 01 dc             	add    %ebx,%r12d
  802d53:	49 63 f4             	movslq %r12d,%rsi
  802d56:	4c 39 f6             	cmp    %r14,%rsi
  802d59:	72 b3                	jb     802d0e <devcons_write+0x3c>
    return res;
  802d5b:	49 63 c4             	movslq %r12d,%rax
}
  802d5e:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802d65:	5b                   	pop    %rbx
  802d66:	41 5c                	pop    %r12
  802d68:	41 5d                	pop    %r13
  802d6a:	41 5e                	pop    %r14
  802d6c:	41 5f                	pop    %r15
  802d6e:	5d                   	pop    %rbp
  802d6f:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802d70:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d76:	eb e3                	jmp    802d5b <devcons_write+0x89>

0000000000802d78 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d78:	f3 0f 1e fa          	endbr64
  802d7c:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802d7f:	ba 00 00 00 00       	mov    $0x0,%edx
  802d84:	48 85 c0             	test   %rax,%rax
  802d87:	74 55                	je     802dde <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d89:	55                   	push   %rbp
  802d8a:	48 89 e5             	mov    %rsp,%rbp
  802d8d:	41 55                	push   %r13
  802d8f:	41 54                	push   %r12
  802d91:	53                   	push   %rbx
  802d92:	48 83 ec 08          	sub    $0x8,%rsp
  802d96:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802d99:	48 bb f0 12 80 00 00 	movabs $0x8012f0,%rbx
  802da0:	00 00 00 
  802da3:	49 bc c9 13 80 00 00 	movabs $0x8013c9,%r12
  802daa:	00 00 00 
  802dad:	eb 03                	jmp    802db2 <devcons_read+0x3a>
  802daf:	41 ff d4             	call   *%r12
  802db2:	ff d3                	call   *%rbx
  802db4:	85 c0                	test   %eax,%eax
  802db6:	74 f7                	je     802daf <devcons_read+0x37>
    if (c < 0) return c;
  802db8:	48 63 d0             	movslq %eax,%rdx
  802dbb:	78 13                	js     802dd0 <devcons_read+0x58>
    if (c == 0x04) return 0;
  802dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc2:	83 f8 04             	cmp    $0x4,%eax
  802dc5:	74 09                	je     802dd0 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802dc7:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802dcb:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802dd0:	48 89 d0             	mov    %rdx,%rax
  802dd3:	48 83 c4 08          	add    $0x8,%rsp
  802dd7:	5b                   	pop    %rbx
  802dd8:	41 5c                	pop    %r12
  802dda:	41 5d                	pop    %r13
  802ddc:	5d                   	pop    %rbp
  802ddd:	c3                   	ret
  802dde:	48 89 d0             	mov    %rdx,%rax
  802de1:	c3                   	ret

0000000000802de2 <cputchar>:
cputchar(int ch) {
  802de2:	f3 0f 1e fa          	endbr64
  802de6:	55                   	push   %rbp
  802de7:	48 89 e5             	mov    %rsp,%rbp
  802dea:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802dee:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802df2:	be 01 00 00 00       	mov    $0x1,%esi
  802df7:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802dfb:	48 b8 bf 12 80 00 00 	movabs $0x8012bf,%rax
  802e02:	00 00 00 
  802e05:	ff d0                	call   *%rax
}
  802e07:	c9                   	leave
  802e08:	c3                   	ret

0000000000802e09 <getchar>:
getchar(void) {
  802e09:	f3 0f 1e fa          	endbr64
  802e0d:	55                   	push   %rbp
  802e0e:	48 89 e5             	mov    %rsp,%rbp
  802e11:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802e15:	ba 01 00 00 00       	mov    $0x1,%edx
  802e1a:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802e1e:	bf 00 00 00 00       	mov    $0x0,%edi
  802e23:	48 b8 19 1d 80 00 00 	movabs $0x801d19,%rax
  802e2a:	00 00 00 
  802e2d:	ff d0                	call   *%rax
  802e2f:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802e31:	85 c0                	test   %eax,%eax
  802e33:	78 06                	js     802e3b <getchar+0x32>
  802e35:	74 08                	je     802e3f <getchar+0x36>
  802e37:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802e3b:	89 d0                	mov    %edx,%eax
  802e3d:	c9                   	leave
  802e3e:	c3                   	ret
    return res < 0 ? res : res ? c :
  802e3f:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802e44:	eb f5                	jmp    802e3b <getchar+0x32>

0000000000802e46 <iscons>:
iscons(int fdnum) {
  802e46:	f3 0f 1e fa          	endbr64
  802e4a:	55                   	push   %rbp
  802e4b:	48 89 e5             	mov    %rsp,%rbp
  802e4e:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802e52:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802e56:	48 b8 1e 1a 80 00 00 	movabs $0x801a1e,%rax
  802e5d:	00 00 00 
  802e60:	ff d0                	call   *%rax
    if (res < 0) return res;
  802e62:	85 c0                	test   %eax,%eax
  802e64:	78 18                	js     802e7e <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802e66:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e6a:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802e71:	00 00 00 
  802e74:	8b 00                	mov    (%rax),%eax
  802e76:	39 02                	cmp    %eax,(%rdx)
  802e78:	0f 94 c0             	sete   %al
  802e7b:	0f b6 c0             	movzbl %al,%eax
}
  802e7e:	c9                   	leave
  802e7f:	c3                   	ret

0000000000802e80 <opencons>:
opencons(void) {
  802e80:	f3 0f 1e fa          	endbr64
  802e84:	55                   	push   %rbp
  802e85:	48 89 e5             	mov    %rsp,%rbp
  802e88:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802e8c:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802e90:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  802e97:	00 00 00 
  802e9a:	ff d0                	call   *%rax
  802e9c:	85 c0                	test   %eax,%eax
  802e9e:	78 49                	js     802ee9 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802ea0:	b9 46 00 00 00       	mov    $0x46,%ecx
  802ea5:	ba 00 10 00 00       	mov    $0x1000,%edx
  802eaa:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802eae:	bf 00 00 00 00       	mov    $0x0,%edi
  802eb3:	48 b8 64 14 80 00 00 	movabs $0x801464,%rax
  802eba:	00 00 00 
  802ebd:	ff d0                	call   *%rax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	78 26                	js     802ee9 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802ec3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ec7:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802ece:	00 00 
  802ed0:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802ed2:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802ed6:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802edd:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  802ee4:	00 00 00 
  802ee7:	ff d0                	call   *%rax
}
  802ee9:	c9                   	leave
  802eea:	c3                   	ret

0000000000802eeb <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  802eeb:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  802eee:	48 b8 2a 31 80 00 00 	movabs $0x80312a,%rax
  802ef5:	00 00 00 
    call *%rax
  802ef8:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  802efa:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  802efd:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802f04:	00 
    movq UTRAP_RSP(%rsp), %rsp
  802f05:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  802f0c:	00 
    pushq %rbx
  802f0d:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  802f0e:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  802f15:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  802f18:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  802f1c:	4c 8b 3c 24          	mov    (%rsp),%r15
  802f20:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802f25:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802f2a:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802f2f:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802f34:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802f39:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802f3e:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802f43:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802f48:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802f4d:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802f52:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802f57:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802f5c:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802f61:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802f66:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  802f6a:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  802f6e:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  802f6f:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  802f70:	c3                   	ret

0000000000802f71 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802f71:	f3 0f 1e fa          	endbr64
  802f75:	55                   	push   %rbp
  802f76:	48 89 e5             	mov    %rsp,%rbp
  802f79:	41 54                	push   %r12
  802f7b:	53                   	push   %rbx
  802f7c:	48 89 fb             	mov    %rdi,%rbx
  802f7f:	48 89 f7             	mov    %rsi,%rdi
  802f82:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802f85:	48 85 f6             	test   %rsi,%rsi
  802f88:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802f8f:	00 00 00 
  802f92:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802f96:	be 00 10 00 00       	mov    $0x1000,%esi
  802f9b:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  802fa2:	00 00 00 
  802fa5:	ff d0                	call   *%rax
    if (res < 0) {
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	78 45                	js     802ff0 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802fab:	48 85 db             	test   %rbx,%rbx
  802fae:	74 12                	je     802fc2 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802fb0:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802fb7:	00 00 00 
  802fba:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802fc0:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802fc2:	4d 85 e4             	test   %r12,%r12
  802fc5:	74 14                	je     802fdb <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802fc7:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802fce:	00 00 00 
  802fd1:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802fd7:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802fdb:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802fe2:	00 00 00 
  802fe5:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802feb:	5b                   	pop    %rbx
  802fec:	41 5c                	pop    %r12
  802fee:	5d                   	pop    %rbp
  802fef:	c3                   	ret
        if (from_env_store != NULL) {
  802ff0:	48 85 db             	test   %rbx,%rbx
  802ff3:	74 06                	je     802ffb <ipc_recv+0x8a>
            *from_env_store = 0;
  802ff5:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802ffb:	4d 85 e4             	test   %r12,%r12
  802ffe:	74 eb                	je     802feb <ipc_recv+0x7a>
            *perm_store = 0;
  803000:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  803007:	00 
  803008:	eb e1                	jmp    802feb <ipc_recv+0x7a>

000000000080300a <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  80300a:	f3 0f 1e fa          	endbr64
  80300e:	55                   	push   %rbp
  80300f:	48 89 e5             	mov    %rsp,%rbp
  803012:	41 57                	push   %r15
  803014:	41 56                	push   %r14
  803016:	41 55                	push   %r13
  803018:	41 54                	push   %r12
  80301a:	53                   	push   %rbx
  80301b:	48 83 ec 18          	sub    $0x18,%rsp
  80301f:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  803022:	48 89 d3             	mov    %rdx,%rbx
  803025:	49 89 cc             	mov    %rcx,%r12
  803028:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  80302b:	48 85 d2             	test   %rdx,%rdx
  80302e:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803035:	00 00 00 
  803038:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  80303c:	89 f0                	mov    %esi,%eax
  80303e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803042:	48 89 da             	mov    %rbx,%rdx
  803045:	48 89 c6             	mov    %rax,%rsi
  803048:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  80304f:	00 00 00 
  803052:	ff d0                	call   *%rax
    while (res < 0) {
  803054:	85 c0                	test   %eax,%eax
  803056:	79 65                	jns    8030bd <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803058:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80305b:	75 33                	jne    803090 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  80305d:	49 bf c9 13 80 00 00 	movabs $0x8013c9,%r15
  803064:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803067:	49 be 56 17 80 00 00 	movabs $0x801756,%r14
  80306e:	00 00 00 
        sys_yield();
  803071:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803074:	45 89 e8             	mov    %r13d,%r8d
  803077:	4c 89 e1             	mov    %r12,%rcx
  80307a:	48 89 da             	mov    %rbx,%rdx
  80307d:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803081:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803084:	41 ff d6             	call   *%r14
    while (res < 0) {
  803087:	85 c0                	test   %eax,%eax
  803089:	79 32                	jns    8030bd <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80308b:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80308e:	74 e1                	je     803071 <ipc_send+0x67>
            panic("Error: %i\n", res);
  803090:	89 c1                	mov    %eax,%ecx
  803092:	48 ba 4f 44 80 00 00 	movabs $0x80444f,%rdx
  803099:	00 00 00 
  80309c:	be 42 00 00 00       	mov    $0x42,%esi
  8030a1:	48 bf 5a 44 80 00 00 	movabs $0x80445a,%rdi
  8030a8:	00 00 00 
  8030ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b0:	49 b8 ba 03 80 00 00 	movabs $0x8003ba,%r8
  8030b7:	00 00 00 
  8030ba:	41 ff d0             	call   *%r8
    }
}
  8030bd:	48 83 c4 18          	add    $0x18,%rsp
  8030c1:	5b                   	pop    %rbx
  8030c2:	41 5c                	pop    %r12
  8030c4:	41 5d                	pop    %r13
  8030c6:	41 5e                	pop    %r14
  8030c8:	41 5f                	pop    %r15
  8030ca:	5d                   	pop    %rbp
  8030cb:	c3                   	ret

00000000008030cc <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  8030cc:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  8030d0:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8030d5:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  8030dc:	00 00 00 
  8030df:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8030e3:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8030e7:	48 c1 e2 04          	shl    $0x4,%rdx
  8030eb:	48 01 ca             	add    %rcx,%rdx
  8030ee:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8030f4:	39 fa                	cmp    %edi,%edx
  8030f6:	74 12                	je     80310a <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  8030f8:	48 83 c0 01          	add    $0x1,%rax
  8030fc:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  803102:	75 db                	jne    8030df <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  803104:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803109:	c3                   	ret
            return envs[i].env_id;
  80310a:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80310e:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803112:	48 c1 e2 04          	shl    $0x4,%rdx
  803116:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  80311d:	00 00 00 
  803120:	48 01 d0             	add    %rdx,%rax
  803123:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803129:	c3                   	ret

000000000080312a <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  80312a:	f3 0f 1e fa          	endbr64
  80312e:	55                   	push   %rbp
  80312f:	48 89 e5             	mov    %rsp,%rbp
  803132:	41 56                	push   %r14
  803134:	41 55                	push   %r13
  803136:	41 54                	push   %r12
  803138:	53                   	push   %rbx
  803139:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  80313c:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803143:	00 00 00 
  803146:	48 83 38 00          	cmpq   $0x0,(%rax)
  80314a:	74 27                	je     803173 <_handle_vectored_pagefault+0x49>
  80314c:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  803151:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  803158:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  80315b:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  80315e:	4c 89 e7             	mov    %r12,%rdi
  803161:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  803166:	84 c0                	test   %al,%al
  803168:	75 45                	jne    8031af <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80316a:	48 83 c3 01          	add    $0x1,%rbx
  80316e:	49 3b 1e             	cmp    (%r14),%rbx
  803171:	72 eb                	jb     80315e <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  803173:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  80317a:	00 
  80317b:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  803180:	4d 8b 04 24          	mov    (%r12),%r8
  803184:	48 ba 30 41 80 00 00 	movabs $0x804130,%rdx
  80318b:	00 00 00 
  80318e:	be 1d 00 00 00       	mov    $0x1d,%esi
  803193:	48 bf 64 44 80 00 00 	movabs $0x804464,%rdi
  80319a:	00 00 00 
  80319d:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a2:	49 ba ba 03 80 00 00 	movabs $0x8003ba,%r10
  8031a9:	00 00 00 
  8031ac:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  8031af:	5b                   	pop    %rbx
  8031b0:	41 5c                	pop    %r12
  8031b2:	41 5d                	pop    %r13
  8031b4:	41 5e                	pop    %r14
  8031b6:	5d                   	pop    %rbp
  8031b7:	c3                   	ret

00000000008031b8 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  8031b8:	f3 0f 1e fa          	endbr64
  8031bc:	55                   	push   %rbp
  8031bd:	48 89 e5             	mov    %rsp,%rbp
  8031c0:	53                   	push   %rbx
  8031c1:	48 83 ec 08          	sub    $0x8,%rsp
  8031c5:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  8031c8:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8031cf:	00 00 00 
  8031d2:	80 38 00             	cmpb   $0x0,(%rax)
  8031d5:	0f 84 84 00 00 00    	je     80325f <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  8031db:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  8031e2:	00 00 00 
  8031e5:	48 8b 10             	mov    (%rax),%rdx
  8031e8:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  8031ed:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  8031f4:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8031f7:	48 85 d2             	test   %rdx,%rdx
  8031fa:	74 19                	je     803215 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  8031fc:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  803200:	0f 84 e8 00 00 00    	je     8032ee <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803206:	48 83 c0 01          	add    $0x1,%rax
  80320a:	48 39 d0             	cmp    %rdx,%rax
  80320d:	75 ed                	jne    8031fc <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  80320f:	48 83 fa 08          	cmp    $0x8,%rdx
  803213:	74 1c                	je     803231 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  803215:	48 8d 42 01          	lea    0x1(%rdx),%rax
  803219:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  803220:	00 00 00 
  803223:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80322a:	00 00 00 
  80322d:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  803231:	48 b8 94 13 80 00 00 	movabs $0x801394,%rax
  803238:	00 00 00 
  80323b:	ff d0                	call   *%rax
  80323d:	89 c7                	mov    %eax,%edi
  80323f:	48 be eb 2e 80 00 00 	movabs $0x802eeb,%rsi
  803246:	00 00 00 
  803249:	48 b8 e9 16 80 00 00 	movabs $0x8016e9,%rax
  803250:	00 00 00 
  803253:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803255:	85 c0                	test   %eax,%eax
  803257:	78 68                	js     8032c1 <add_pgfault_handler+0x109>
    return res;
}
  803259:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80325d:	c9                   	leave
  80325e:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  80325f:	48 b8 94 13 80 00 00 	movabs $0x801394,%rax
  803266:	00 00 00 
  803269:	ff d0                	call   *%rax
  80326b:	89 c7                	mov    %eax,%edi
  80326d:	b9 06 00 00 00       	mov    $0x6,%ecx
  803272:	ba 00 10 00 00       	mov    $0x1000,%edx
  803277:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  80327e:	00 00 00 
  803281:	48 b8 64 14 80 00 00 	movabs $0x801464,%rax
  803288:	00 00 00 
  80328b:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  80328d:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  803294:	00 00 00 
  803297:	48 8b 02             	mov    (%rdx),%rax
  80329a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80329e:	48 89 0a             	mov    %rcx,(%rdx)
  8032a1:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  8032a8:	00 00 00 
  8032ab:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  8032af:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8032b6:	00 00 00 
  8032b9:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  8032bc:	e9 70 ff ff ff       	jmp    803231 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8032c1:	89 c1                	mov    %eax,%ecx
  8032c3:	48 ba 72 44 80 00 00 	movabs $0x804472,%rdx
  8032ca:	00 00 00 
  8032cd:	be 3d 00 00 00       	mov    $0x3d,%esi
  8032d2:	48 bf 64 44 80 00 00 	movabs $0x804464,%rdi
  8032d9:	00 00 00 
  8032dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e1:	49 b8 ba 03 80 00 00 	movabs $0x8003ba,%r8
  8032e8:	00 00 00 
  8032eb:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  8032ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f3:	e9 61 ff ff ff       	jmp    803259 <add_pgfault_handler+0xa1>

00000000008032f8 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  8032f8:	f3 0f 1e fa          	endbr64
  8032fc:	55                   	push   %rbp
  8032fd:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  803300:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803307:	00 00 00 
  80330a:	80 38 00             	cmpb   $0x0,(%rax)
  80330d:	74 33                	je     803342 <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80330f:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  803316:	00 00 00 
  803319:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  80331e:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803325:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803328:	48 85 c0             	test   %rax,%rax
  80332b:	0f 84 85 00 00 00    	je     8033b6 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  803331:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  803335:	74 40                	je     803377 <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803337:	48 83 c1 01          	add    $0x1,%rcx
  80333b:	48 39 c1             	cmp    %rax,%rcx
  80333e:	75 f1                	jne    803331 <remove_pgfault_handler+0x39>
  803340:	eb 74                	jmp    8033b6 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  803342:	48 b9 8a 44 80 00 00 	movabs $0x80448a,%rcx
  803349:	00 00 00 
  80334c:	48 ba 0c 44 80 00 00 	movabs $0x80440c,%rdx
  803353:	00 00 00 
  803356:	be 43 00 00 00       	mov    $0x43,%esi
  80335b:	48 bf 64 44 80 00 00 	movabs $0x804464,%rdi
  803362:	00 00 00 
  803365:	b8 00 00 00 00       	mov    $0x0,%eax
  80336a:	49 b8 ba 03 80 00 00 	movabs $0x8003ba,%r8
  803371:	00 00 00 
  803374:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  803377:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  80337e:	00 
  80337f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803383:	48 29 ca             	sub    %rcx,%rdx
  803386:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80338d:	00 00 00 
  803390:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  803394:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  803399:	48 89 ce             	mov    %rcx,%rsi
  80339c:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  8033a3:	00 00 00 
  8033a6:	ff d0                	call   *%rax
            _pfhandler_off--;
  8033a8:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  8033af:	00 00 00 
  8033b2:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  8033b6:	5d                   	pop    %rbp
  8033b7:	c3                   	ret

00000000008033b8 <__text_end>:
  8033b8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033bf:	00 00 00 
  8033c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033c9:	00 00 00 
  8033cc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033d3:	00 00 00 
  8033d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033dd:	00 00 00 
  8033e0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033e7:	00 00 00 
  8033ea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033f1:	00 00 00 
  8033f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033fb:	00 00 00 
  8033fe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803405:	00 00 00 
  803408:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80340f:	00 00 00 
  803412:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803419:	00 00 00 
  80341c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803423:	00 00 00 
  803426:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80342d:	00 00 00 
  803430:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803437:	00 00 00 
  80343a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803441:	00 00 00 
  803444:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80344b:	00 00 00 
  80344e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803455:	00 00 00 
  803458:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80345f:	00 00 00 
  803462:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803469:	00 00 00 
  80346c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803473:	00 00 00 
  803476:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80347d:	00 00 00 
  803480:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803487:	00 00 00 
  80348a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803491:	00 00 00 
  803494:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80349b:	00 00 00 
  80349e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034a5:	00 00 00 
  8034a8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034af:	00 00 00 
  8034b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034b9:	00 00 00 
  8034bc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034c3:	00 00 00 
  8034c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034cd:	00 00 00 
  8034d0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034d7:	00 00 00 
  8034da:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034e1:	00 00 00 
  8034e4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034eb:	00 00 00 
  8034ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034f5:	00 00 00 
  8034f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ff:	00 00 00 
  803502:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803509:	00 00 00 
  80350c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803513:	00 00 00 
  803516:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80351d:	00 00 00 
  803520:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803527:	00 00 00 
  80352a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803531:	00 00 00 
  803534:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80353b:	00 00 00 
  80353e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803545:	00 00 00 
  803548:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80354f:	00 00 00 
  803552:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803559:	00 00 00 
  80355c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803563:	00 00 00 
  803566:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80356d:	00 00 00 
  803570:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803577:	00 00 00 
  80357a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803581:	00 00 00 
  803584:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80358b:	00 00 00 
  80358e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803595:	00 00 00 
  803598:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80359f:	00 00 00 
  8035a2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a9:	00 00 00 
  8035ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b3:	00 00 00 
  8035b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035bd:	00 00 00 
  8035c0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035c7:	00 00 00 
  8035ca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035d1:	00 00 00 
  8035d4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035db:	00 00 00 
  8035de:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035e5:	00 00 00 
  8035e8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ef:	00 00 00 
  8035f2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035f9:	00 00 00 
  8035fc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803603:	00 00 00 
  803606:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80360d:	00 00 00 
  803610:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803617:	00 00 00 
  80361a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803621:	00 00 00 
  803624:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80362b:	00 00 00 
  80362e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803635:	00 00 00 
  803638:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80363f:	00 00 00 
  803642:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803649:	00 00 00 
  80364c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803653:	00 00 00 
  803656:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80365d:	00 00 00 
  803660:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803667:	00 00 00 
  80366a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803671:	00 00 00 
  803674:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80367b:	00 00 00 
  80367e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803685:	00 00 00 
  803688:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80368f:	00 00 00 
  803692:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803699:	00 00 00 
  80369c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036a3:	00 00 00 
  8036a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ad:	00 00 00 
  8036b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036b7:	00 00 00 
  8036ba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036c1:	00 00 00 
  8036c4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036cb:	00 00 00 
  8036ce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036d5:	00 00 00 
  8036d8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036df:	00 00 00 
  8036e2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036e9:	00 00 00 
  8036ec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036f3:	00 00 00 
  8036f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036fd:	00 00 00 
  803700:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803707:	00 00 00 
  80370a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803711:	00 00 00 
  803714:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80371b:	00 00 00 
  80371e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803725:	00 00 00 
  803728:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80372f:	00 00 00 
  803732:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803739:	00 00 00 
  80373c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803743:	00 00 00 
  803746:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80374d:	00 00 00 
  803750:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803757:	00 00 00 
  80375a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803761:	00 00 00 
  803764:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80376b:	00 00 00 
  80376e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803775:	00 00 00 
  803778:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80377f:	00 00 00 
  803782:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803789:	00 00 00 
  80378c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803793:	00 00 00 
  803796:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80379d:	00 00 00 
  8037a0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a7:	00 00 00 
  8037aa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b1:	00 00 00 
  8037b4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037bb:	00 00 00 
  8037be:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c5:	00 00 00 
  8037c8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037cf:	00 00 00 
  8037d2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d9:	00 00 00 
  8037dc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e3:	00 00 00 
  8037e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ed:	00 00 00 
  8037f0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f7:	00 00 00 
  8037fa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803801:	00 00 00 
  803804:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80380b:	00 00 00 
  80380e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803815:	00 00 00 
  803818:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80381f:	00 00 00 
  803822:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803829:	00 00 00 
  80382c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803833:	00 00 00 
  803836:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80383d:	00 00 00 
  803840:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803847:	00 00 00 
  80384a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803851:	00 00 00 
  803854:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80385b:	00 00 00 
  80385e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803865:	00 00 00 
  803868:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80386f:	00 00 00 
  803872:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803879:	00 00 00 
  80387c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803883:	00 00 00 
  803886:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80388d:	00 00 00 
  803890:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803897:	00 00 00 
  80389a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a1:	00 00 00 
  8038a4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ab:	00 00 00 
  8038ae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b5:	00 00 00 
  8038b8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038bf:	00 00 00 
  8038c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c9:	00 00 00 
  8038cc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d3:	00 00 00 
  8038d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038dd:	00 00 00 
  8038e0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e7:	00 00 00 
  8038ea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f1:	00 00 00 
  8038f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038fb:	00 00 00 
  8038fe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803905:	00 00 00 
  803908:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80390f:	00 00 00 
  803912:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803919:	00 00 00 
  80391c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803923:	00 00 00 
  803926:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80392d:	00 00 00 
  803930:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803937:	00 00 00 
  80393a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803941:	00 00 00 
  803944:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80394b:	00 00 00 
  80394e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803955:	00 00 00 
  803958:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80395f:	00 00 00 
  803962:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803969:	00 00 00 
  80396c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803973:	00 00 00 
  803976:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80397d:	00 00 00 
  803980:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803987:	00 00 00 
  80398a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803991:	00 00 00 
  803994:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80399b:	00 00 00 
  80399e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a5:	00 00 00 
  8039a8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039af:	00 00 00 
  8039b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b9:	00 00 00 
  8039bc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c3:	00 00 00 
  8039c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039cd:	00 00 00 
  8039d0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d7:	00 00 00 
  8039da:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e1:	00 00 00 
  8039e4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039eb:	00 00 00 
  8039ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f5:	00 00 00 
  8039f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ff:	00 00 00 
  803a02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a09:	00 00 00 
  803a0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a13:	00 00 00 
  803a16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a1d:	00 00 00 
  803a20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a27:	00 00 00 
  803a2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a31:	00 00 00 
  803a34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a3b:	00 00 00 
  803a3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a45:	00 00 00 
  803a48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a4f:	00 00 00 
  803a52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a59:	00 00 00 
  803a5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a63:	00 00 00 
  803a66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a6d:	00 00 00 
  803a70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a77:	00 00 00 
  803a7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a81:	00 00 00 
  803a84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a8b:	00 00 00 
  803a8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a95:	00 00 00 
  803a98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a9f:	00 00 00 
  803aa2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa9:	00 00 00 
  803aac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab3:	00 00 00 
  803ab6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803abd:	00 00 00 
  803ac0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac7:	00 00 00 
  803aca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad1:	00 00 00 
  803ad4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803adb:	00 00 00 
  803ade:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae5:	00 00 00 
  803ae8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aef:	00 00 00 
  803af2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af9:	00 00 00 
  803afc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b03:	00 00 00 
  803b06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b0d:	00 00 00 
  803b10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b17:	00 00 00 
  803b1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b21:	00 00 00 
  803b24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b2b:	00 00 00 
  803b2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b35:	00 00 00 
  803b38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b3f:	00 00 00 
  803b42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b49:	00 00 00 
  803b4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b53:	00 00 00 
  803b56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b5d:	00 00 00 
  803b60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b67:	00 00 00 
  803b6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b71:	00 00 00 
  803b74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b7b:	00 00 00 
  803b7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b85:	00 00 00 
  803b88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b8f:	00 00 00 
  803b92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b99:	00 00 00 
  803b9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba3:	00 00 00 
  803ba6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bad:	00 00 00 
  803bb0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb7:	00 00 00 
  803bba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc1:	00 00 00 
  803bc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bcb:	00 00 00 
  803bce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd5:	00 00 00 
  803bd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bdf:	00 00 00 
  803be2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be9:	00 00 00 
  803bec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf3:	00 00 00 
  803bf6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bfd:	00 00 00 
  803c00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c07:	00 00 00 
  803c0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c11:	00 00 00 
  803c14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c1b:	00 00 00 
  803c1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c25:	00 00 00 
  803c28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c2f:	00 00 00 
  803c32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c39:	00 00 00 
  803c3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c43:	00 00 00 
  803c46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c4d:	00 00 00 
  803c50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c57:	00 00 00 
  803c5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c61:	00 00 00 
  803c64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c6b:	00 00 00 
  803c6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c75:	00 00 00 
  803c78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c7f:	00 00 00 
  803c82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c89:	00 00 00 
  803c8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c93:	00 00 00 
  803c96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c9d:	00 00 00 
  803ca0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca7:	00 00 00 
  803caa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb1:	00 00 00 
  803cb4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cbb:	00 00 00 
  803cbe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc5:	00 00 00 
  803cc8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ccf:	00 00 00 
  803cd2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd9:	00 00 00 
  803cdc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce3:	00 00 00 
  803ce6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ced:	00 00 00 
  803cf0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf7:	00 00 00 
  803cfa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d01:	00 00 00 
  803d04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d0b:	00 00 00 
  803d0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d15:	00 00 00 
  803d18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d1f:	00 00 00 
  803d22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d29:	00 00 00 
  803d2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d33:	00 00 00 
  803d36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d3d:	00 00 00 
  803d40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d47:	00 00 00 
  803d4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d51:	00 00 00 
  803d54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d5b:	00 00 00 
  803d5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d65:	00 00 00 
  803d68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d6f:	00 00 00 
  803d72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d79:	00 00 00 
  803d7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d83:	00 00 00 
  803d86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d8d:	00 00 00 
  803d90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d97:	00 00 00 
  803d9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da1:	00 00 00 
  803da4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dab:	00 00 00 
  803dae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db5:	00 00 00 
  803db8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dbf:	00 00 00 
  803dc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc9:	00 00 00 
  803dcc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd3:	00 00 00 
  803dd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ddd:	00 00 00 
  803de0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de7:	00 00 00 
  803dea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df1:	00 00 00 
  803df4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dfb:	00 00 00 
  803dfe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e05:	00 00 00 
  803e08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e0f:	00 00 00 
  803e12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e19:	00 00 00 
  803e1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e23:	00 00 00 
  803e26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e2d:	00 00 00 
  803e30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e37:	00 00 00 
  803e3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e41:	00 00 00 
  803e44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e4b:	00 00 00 
  803e4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e55:	00 00 00 
  803e58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e5f:	00 00 00 
  803e62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e69:	00 00 00 
  803e6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e73:	00 00 00 
  803e76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e7d:	00 00 00 
  803e80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e87:	00 00 00 
  803e8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e91:	00 00 00 
  803e94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e9b:	00 00 00 
  803e9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea5:	00 00 00 
  803ea8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eaf:	00 00 00 
  803eb2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb9:	00 00 00 
  803ebc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec3:	00 00 00 
  803ec6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ecd:	00 00 00 
  803ed0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed7:	00 00 00 
  803eda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee1:	00 00 00 
  803ee4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eeb:	00 00 00 
  803eee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef5:	00 00 00 
  803ef8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eff:	00 00 00 
  803f02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f09:	00 00 00 
  803f0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f13:	00 00 00 
  803f16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f1d:	00 00 00 
  803f20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f27:	00 00 00 
  803f2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f31:	00 00 00 
  803f34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f3b:	00 00 00 
  803f3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f45:	00 00 00 
  803f48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f4f:	00 00 00 
  803f52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f59:	00 00 00 
  803f5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f63:	00 00 00 
  803f66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f6d:	00 00 00 
  803f70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f77:	00 00 00 
  803f7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f81:	00 00 00 
  803f84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f8b:	00 00 00 
  803f8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f95:	00 00 00 
  803f98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f9f:	00 00 00 
  803fa2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa9:	00 00 00 
  803fac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb3:	00 00 00 
  803fb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fbd:	00 00 00 
  803fc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc7:	00 00 00 
  803fca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd1:	00 00 00 
  803fd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fdb:	00 00 00 
  803fde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe5:	00 00 00 
  803fe8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fef:	00 00 00 
  803ff2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff9:	00 00 00 
  803ffc:	0f 1f 40 00          	nopl   0x0(%rax)
