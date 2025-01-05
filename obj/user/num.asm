
obj/user/num:     file format elf64-x86-64


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
  80001e:	e8 21 02 00 00       	call   800244 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <num>:

int bol = 1;
int line = 0;

void
num(int f, const char *s) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 57                	push   %r15
  80002f:	41 56                	push   %r14
  800031:	41 55                	push   %r13
  800033:	41 54                	push   %r12
  800035:	53                   	push   %rbx
  800036:	48 83 ec 28          	sub    $0x28,%rsp
  80003a:	41 89 fc             	mov    %edi,%r12d
  80003d:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    long n;
    int r;
    char c;

    while ((n = read(f, &c, 1)) > 0) {
  800041:	49 bd 20 1b 80 00 00 	movabs $0x801b20,%r13
  800048:	00 00 00 
        if (bol) {
  80004b:	48 bb 00 50 80 00 00 	movabs $0x805000,%rbx
  800052:	00 00 00 
            printf("%5d ", ++line);
  800055:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  80005c:	00 00 00 
  80005f:	49 bf 00 40 80 00 00 	movabs $0x804000,%r15
  800066:	00 00 00 
  800069:	eb 25                	jmp    800090 <num+0x6b>
            bol = 0;
        }
        if ((r = write(1, &c, 1)) != 1)
  80006b:	ba 01 00 00 00       	mov    $0x1,%edx
  800070:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
  800074:	bf 01 00 00 00       	mov    $0x1,%edi
  800079:	48 b8 57 1c 80 00 00 	movabs $0x801c57,%rax
  800080:	00 00 00 
  800083:	ff d0                	call   *%rax
  800085:	83 f8 01             	cmp    $0x1,%eax
  800088:	75 44                	jne    8000ce <num+0xa9>
            panic("write error copying %s: %i", s, r);
        if (c == '\n')
  80008a:	80 7d cf 0a          	cmpb   $0xa,-0x31(%rbp)
  80008e:	74 70                	je     800100 <num+0xdb>
    while ((n = read(f, &c, 1)) > 0) {
  800090:	ba 01 00 00 00       	mov    $0x1,%edx
  800095:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
  800099:	44 89 e7             	mov    %r12d,%edi
  80009c:	41 ff d5             	call   *%r13
  80009f:	48 85 c0             	test   %rax,%rax
  8000a2:	7e 71                	jle    800115 <num+0xf0>
        if (bol) {
  8000a4:	83 3b 00             	cmpl   $0x0,(%rbx)
  8000a7:	74 c2                	je     80006b <num+0x46>
            printf("%5d ", ++line);
  8000a9:	41 8b 06             	mov    (%r14),%eax
  8000ac:	8d 70 01             	lea    0x1(%rax),%esi
  8000af:	41 89 36             	mov    %esi,(%r14)
  8000b2:	4c 89 ff             	mov    %r15,%rdi
  8000b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ba:	48 ba 9d 23 80 00 00 	movabs $0x80239d,%rdx
  8000c1:	00 00 00 
  8000c4:	ff d2                	call   *%rdx
            bol = 0;
  8000c6:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8000cc:	eb 9d                	jmp    80006b <num+0x46>
            panic("write error copying %s: %i", s, r);
  8000ce:	41 89 c0             	mov    %eax,%r8d
  8000d1:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  8000d5:	48 ba 05 40 80 00 00 	movabs $0x804005,%rdx
  8000dc:	00 00 00 
  8000df:	be 12 00 00 00       	mov    $0x12,%esi
  8000e4:	48 bf 20 40 80 00 00 	movabs $0x804020,%rdi
  8000eb:	00 00 00 
  8000ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f3:	49 b9 1d 03 80 00 00 	movabs $0x80031d,%r9
  8000fa:	00 00 00 
  8000fd:	41 ff d1             	call   *%r9
            bol = 1;
  800100:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800107:	00 00 00 
  80010a:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  800110:	e9 4a ff ff ff       	jmp    80005f <num+0x3a>
    }
    if (n < 0) panic("error reading %s: %i", s, (int)n);
  800115:	78 0f                	js     800126 <num+0x101>
}
  800117:	48 83 c4 28          	add    $0x28,%rsp
  80011b:	5b                   	pop    %rbx
  80011c:	41 5c                	pop    %r12
  80011e:	41 5d                	pop    %r13
  800120:	41 5e                	pop    %r14
  800122:	41 5f                	pop    %r15
  800124:	5d                   	pop    %rbp
  800125:	c3                   	ret
    if (n < 0) panic("error reading %s: %i", s, (int)n);
  800126:	41 89 c0             	mov    %eax,%r8d
  800129:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  80012d:	48 ba 2b 40 80 00 00 	movabs $0x80402b,%rdx
  800134:	00 00 00 
  800137:	be 16 00 00 00       	mov    $0x16,%esi
  80013c:	48 bf 20 40 80 00 00 	movabs $0x804020,%rdi
  800143:	00 00 00 
  800146:	b8 00 00 00 00       	mov    $0x0,%eax
  80014b:	49 b9 1d 03 80 00 00 	movabs $0x80031d,%r9
  800152:	00 00 00 
  800155:	41 ff d1             	call   *%r9

0000000000800158 <umain>:

void
umain(int argc, char **argv) {
  800158:	f3 0f 1e fa          	endbr64
  80015c:	55                   	push   %rbp
  80015d:	48 89 e5             	mov    %rsp,%rbp
  800160:	41 57                	push   %r15
  800162:	41 56                	push   %r14
  800164:	41 55                	push   %r13
  800166:	41 54                	push   %r12
  800168:	53                   	push   %rbx
  800169:	48 83 ec 08          	sub    $0x8,%rsp
    binaryname = "num";
  80016d:	48 b8 40 40 80 00 00 	movabs $0x804040,%rax
  800174:	00 00 00 
  800177:	48 a3 08 50 80 00 00 	movabs %rax,0x805008
  80017e:	00 00 00 
    if (argc == 1)
  800181:	83 ff 01             	cmp    $0x1,%edi
  800184:	74 6f                	je     8001f5 <umain+0x9d>
        num(0, "<stdin>");
    else {
        for (int i = 1; i < argc; i++) {
  800186:	7e 52                	jle    8001da <umain+0x82>
  800188:	4c 8d 66 08          	lea    0x8(%rsi),%r12
  80018c:	8d 47 fe             	lea    -0x2(%rdi),%eax
  80018f:	4c 8d 7c c6 10       	lea    0x10(%rsi,%rax,8),%r15
            int f = open(argv[i], O_RDONLY);
  800194:	49 bd 56 21 80 00 00 	movabs $0x802156,%r13
  80019b:	00 00 00 
            if (f < 0)
                panic("can't open %s: %i", argv[i], f);
            else {
                num(f, argv[i]);
  80019e:	49 be 25 00 80 00 00 	movabs $0x800025,%r14
  8001a5:	00 00 00 
            int f = open(argv[i], O_RDONLY);
  8001a8:	49 8b 3c 24          	mov    (%r12),%rdi
  8001ac:	be 00 00 00 00       	mov    $0x0,%esi
  8001b1:	41 ff d5             	call   *%r13
  8001b4:	89 c3                	mov    %eax,%ebx
            if (f < 0)
  8001b6:	85 c0                	test   %eax,%eax
  8001b8:	78 58                	js     800212 <umain+0xba>
                num(f, argv[i]);
  8001ba:	49 8b 34 24          	mov    (%r12),%rsi
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	41 ff d6             	call   *%r14
                close(f);
  8001c3:	89 df                	mov    %ebx,%edi
  8001c5:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  8001cc:	00 00 00 
  8001cf:	ff d0                	call   *%rax
        for (int i = 1; i < argc; i++) {
  8001d1:	49 83 c4 08          	add    $0x8,%r12
  8001d5:	4d 39 fc             	cmp    %r15,%r12
  8001d8:	75 ce                	jne    8001a8 <umain+0x50>
            }
        }
    }
    exit();
  8001da:	48 b8 f6 02 80 00 00 	movabs $0x8002f6,%rax
  8001e1:	00 00 00 
  8001e4:	ff d0                	call   *%rax
}
  8001e6:	48 83 c4 08          	add    $0x8,%rsp
  8001ea:	5b                   	pop    %rbx
  8001eb:	41 5c                	pop    %r12
  8001ed:	41 5d                	pop    %r13
  8001ef:	41 5e                	pop    %r14
  8001f1:	41 5f                	pop    %r15
  8001f3:	5d                   	pop    %rbp
  8001f4:	c3                   	ret
        num(0, "<stdin>");
  8001f5:	48 be 44 40 80 00 00 	movabs $0x804044,%rsi
  8001fc:	00 00 00 
  8001ff:	bf 00 00 00 00       	mov    $0x0,%edi
  800204:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80020b:	00 00 00 
  80020e:	ff d0                	call   *%rax
  800210:	eb c8                	jmp    8001da <umain+0x82>
                panic("can't open %s: %i", argv[i], f);
  800212:	49 8b 0c 24          	mov    (%r12),%rcx
  800216:	41 89 c0             	mov    %eax,%r8d
  800219:	48 ba 4c 40 80 00 00 	movabs $0x80404c,%rdx
  800220:	00 00 00 
  800223:	be 22 00 00 00       	mov    $0x22,%esi
  800228:	48 bf 20 40 80 00 00 	movabs $0x804020,%rdi
  80022f:	00 00 00 
  800232:	b8 00 00 00 00       	mov    $0x0,%eax
  800237:	49 b9 1d 03 80 00 00 	movabs $0x80031d,%r9
  80023e:	00 00 00 
  800241:	41 ff d1             	call   *%r9

0000000000800244 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800244:	f3 0f 1e fa          	endbr64
  800248:	55                   	push   %rbp
  800249:	48 89 e5             	mov    %rsp,%rbp
  80024c:	41 56                	push   %r14
  80024e:	41 55                	push   %r13
  800250:	41 54                	push   %r12
  800252:	53                   	push   %rbx
  800253:	41 89 fd             	mov    %edi,%r13d
  800256:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800259:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  800260:	00 00 00 
  800263:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  80026a:	00 00 00 
  80026d:	48 39 c2             	cmp    %rax,%rdx
  800270:	73 17                	jae    800289 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800272:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800275:	49 89 c4             	mov    %rax,%r12
  800278:	48 83 c3 08          	add    $0x8,%rbx
  80027c:	b8 00 00 00 00       	mov    $0x0,%eax
  800281:	ff 53 f8             	call   *-0x8(%rbx)
  800284:	4c 39 e3             	cmp    %r12,%rbx
  800287:	72 ef                	jb     800278 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800289:	48 b8 f7 12 80 00 00 	movabs $0x8012f7,%rax
  800290:	00 00 00 
  800293:	ff d0                	call   *%rax
  800295:	25 ff 03 00 00       	and    $0x3ff,%eax
  80029a:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80029e:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8002a2:	48 c1 e0 04          	shl    $0x4,%rax
  8002a6:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8002ad:	00 00 00 
  8002b0:	48 01 d0             	add    %rdx,%rax
  8002b3:	48 a3 08 60 80 00 00 	movabs %rax,0x806008
  8002ba:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8002bd:	45 85 ed             	test   %r13d,%r13d
  8002c0:	7e 0d                	jle    8002cf <libmain+0x8b>
  8002c2:	49 8b 06             	mov    (%r14),%rax
  8002c5:	48 a3 08 50 80 00 00 	movabs %rax,0x805008
  8002cc:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8002cf:	4c 89 f6             	mov    %r14,%rsi
  8002d2:	44 89 ef             	mov    %r13d,%edi
  8002d5:	48 b8 58 01 80 00 00 	movabs $0x800158,%rax
  8002dc:	00 00 00 
  8002df:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8002e1:	48 b8 f6 02 80 00 00 	movabs $0x8002f6,%rax
  8002e8:	00 00 00 
  8002eb:	ff d0                	call   *%rax
#endif
}
  8002ed:	5b                   	pop    %rbx
  8002ee:	41 5c                	pop    %r12
  8002f0:	41 5d                	pop    %r13
  8002f2:	41 5e                	pop    %r14
  8002f4:	5d                   	pop    %rbp
  8002f5:	c3                   	ret

00000000008002f6 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8002f6:	f3 0f 1e fa          	endbr64
  8002fa:	55                   	push   %rbp
  8002fb:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8002fe:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  800305:	00 00 00 
  800308:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80030a:	bf 00 00 00 00       	mov    $0x0,%edi
  80030f:	48 b8 88 12 80 00 00 	movabs $0x801288,%rax
  800316:	00 00 00 
  800319:	ff d0                	call   *%rax
}
  80031b:	5d                   	pop    %rbp
  80031c:	c3                   	ret

000000000080031d <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80031d:	f3 0f 1e fa          	endbr64
  800321:	55                   	push   %rbp
  800322:	48 89 e5             	mov    %rsp,%rbp
  800325:	41 56                	push   %r14
  800327:	41 55                	push   %r13
  800329:	41 54                	push   %r12
  80032b:	53                   	push   %rbx
  80032c:	48 83 ec 50          	sub    $0x50,%rsp
  800330:	49 89 fc             	mov    %rdi,%r12
  800333:	41 89 f5             	mov    %esi,%r13d
  800336:	48 89 d3             	mov    %rdx,%rbx
  800339:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80033d:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800341:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800345:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  80034c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800350:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800354:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800358:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  80035c:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800363:	00 00 00 
  800366:	4c 8b 30             	mov    (%rax),%r14
  800369:	48 b8 f7 12 80 00 00 	movabs $0x8012f7,%rax
  800370:	00 00 00 
  800373:	ff d0                	call   *%rax
  800375:	89 c6                	mov    %eax,%esi
  800377:	45 89 e8             	mov    %r13d,%r8d
  80037a:	4c 89 e1             	mov    %r12,%rcx
  80037d:	4c 89 f2             	mov    %r14,%rdx
  800380:	48 bf b8 42 80 00 00 	movabs $0x8042b8,%rdi
  800387:	00 00 00 
  80038a:	b8 00 00 00 00       	mov    $0x0,%eax
  80038f:	49 bc 79 04 80 00 00 	movabs $0x800479,%r12
  800396:	00 00 00 
  800399:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  80039c:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8003a0:	48 89 df             	mov    %rbx,%rdi
  8003a3:	48 b8 11 04 80 00 00 	movabs $0x800411,%rax
  8003aa:	00 00 00 
  8003ad:	ff d0                	call   *%rax
    cprintf("\n");
  8003af:	48 bf 1f 42 80 00 00 	movabs $0x80421f,%rdi
  8003b6:	00 00 00 
  8003b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003be:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8003c1:	cc                   	int3
  8003c2:	eb fd                	jmp    8003c1 <_panic+0xa4>

00000000008003c4 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8003c4:	f3 0f 1e fa          	endbr64
  8003c8:	55                   	push   %rbp
  8003c9:	48 89 e5             	mov    %rsp,%rbp
  8003cc:	53                   	push   %rbx
  8003cd:	48 83 ec 08          	sub    $0x8,%rsp
  8003d1:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8003d4:	8b 06                	mov    (%rsi),%eax
  8003d6:	8d 50 01             	lea    0x1(%rax),%edx
  8003d9:	89 16                	mov    %edx,(%rsi)
  8003db:	48 98                	cltq
  8003dd:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8003e2:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8003e8:	74 0a                	je     8003f4 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8003ea:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8003ee:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003f2:	c9                   	leave
  8003f3:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  8003f4:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8003f8:	be ff 00 00 00       	mov    $0xff,%esi
  8003fd:	48 b8 22 12 80 00 00 	movabs $0x801222,%rax
  800404:	00 00 00 
  800407:	ff d0                	call   *%rax
        state->offset = 0;
  800409:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80040f:	eb d9                	jmp    8003ea <putch+0x26>

0000000000800411 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800411:	f3 0f 1e fa          	endbr64
  800415:	55                   	push   %rbp
  800416:	48 89 e5             	mov    %rsp,%rbp
  800419:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800420:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800423:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80042a:	b9 21 00 00 00       	mov    $0x21,%ecx
  80042f:	b8 00 00 00 00       	mov    $0x0,%eax
  800434:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800437:	48 89 f1             	mov    %rsi,%rcx
  80043a:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800441:	48 bf c4 03 80 00 00 	movabs $0x8003c4,%rdi
  800448:	00 00 00 
  80044b:	48 b8 d9 05 80 00 00 	movabs $0x8005d9,%rax
  800452:	00 00 00 
  800455:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800457:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80045e:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800465:	48 b8 22 12 80 00 00 	movabs $0x801222,%rax
  80046c:	00 00 00 
  80046f:	ff d0                	call   *%rax

    return state.count;
}
  800471:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800477:	c9                   	leave
  800478:	c3                   	ret

0000000000800479 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800479:	f3 0f 1e fa          	endbr64
  80047d:	55                   	push   %rbp
  80047e:	48 89 e5             	mov    %rsp,%rbp
  800481:	48 83 ec 50          	sub    $0x50,%rsp
  800485:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800489:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80048d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800491:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800495:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800499:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8004a0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004a8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8004ac:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8004b0:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8004b4:	48 b8 11 04 80 00 00 	movabs $0x800411,%rax
  8004bb:	00 00 00 
  8004be:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8004c0:	c9                   	leave
  8004c1:	c3                   	ret

00000000008004c2 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8004c2:	f3 0f 1e fa          	endbr64
  8004c6:	55                   	push   %rbp
  8004c7:	48 89 e5             	mov    %rsp,%rbp
  8004ca:	41 57                	push   %r15
  8004cc:	41 56                	push   %r14
  8004ce:	41 55                	push   %r13
  8004d0:	41 54                	push   %r12
  8004d2:	53                   	push   %rbx
  8004d3:	48 83 ec 18          	sub    $0x18,%rsp
  8004d7:	49 89 fc             	mov    %rdi,%r12
  8004da:	49 89 f5             	mov    %rsi,%r13
  8004dd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8004e1:	8b 45 10             	mov    0x10(%rbp),%eax
  8004e4:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8004e7:	41 89 cf             	mov    %ecx,%r15d
  8004ea:	4c 39 fa             	cmp    %r15,%rdx
  8004ed:	73 5b                	jae    80054a <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8004ef:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8004f3:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8004f7:	85 db                	test   %ebx,%ebx
  8004f9:	7e 0e                	jle    800509 <print_num+0x47>
            putch(padc, put_arg);
  8004fb:	4c 89 ee             	mov    %r13,%rsi
  8004fe:	44 89 f7             	mov    %r14d,%edi
  800501:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800504:	83 eb 01             	sub    $0x1,%ebx
  800507:	75 f2                	jne    8004fb <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800509:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80050d:	48 b9 79 40 80 00 00 	movabs $0x804079,%rcx
  800514:	00 00 00 
  800517:	48 b8 68 40 80 00 00 	movabs $0x804068,%rax
  80051e:	00 00 00 
  800521:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800525:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800529:	ba 00 00 00 00       	mov    $0x0,%edx
  80052e:	49 f7 f7             	div    %r15
  800531:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800535:	4c 89 ee             	mov    %r13,%rsi
  800538:	41 ff d4             	call   *%r12
}
  80053b:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80053f:	5b                   	pop    %rbx
  800540:	41 5c                	pop    %r12
  800542:	41 5d                	pop    %r13
  800544:	41 5e                	pop    %r14
  800546:	41 5f                	pop    %r15
  800548:	5d                   	pop    %rbp
  800549:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  80054a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80054e:	ba 00 00 00 00       	mov    $0x0,%edx
  800553:	49 f7 f7             	div    %r15
  800556:	48 83 ec 08          	sub    $0x8,%rsp
  80055a:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  80055e:	52                   	push   %rdx
  80055f:	45 0f be c9          	movsbl %r9b,%r9d
  800563:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800567:	48 89 c2             	mov    %rax,%rdx
  80056a:	48 b8 c2 04 80 00 00 	movabs $0x8004c2,%rax
  800571:	00 00 00 
  800574:	ff d0                	call   *%rax
  800576:	48 83 c4 10          	add    $0x10,%rsp
  80057a:	eb 8d                	jmp    800509 <print_num+0x47>

000000000080057c <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  80057c:	f3 0f 1e fa          	endbr64
    state->count++;
  800580:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800584:	48 8b 06             	mov    (%rsi),%rax
  800587:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80058b:	73 0a                	jae    800597 <sprintputch+0x1b>
        *state->start++ = ch;
  80058d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800591:	48 89 16             	mov    %rdx,(%rsi)
  800594:	40 88 38             	mov    %dil,(%rax)
    }
}
  800597:	c3                   	ret

0000000000800598 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800598:	f3 0f 1e fa          	endbr64
  80059c:	55                   	push   %rbp
  80059d:	48 89 e5             	mov    %rsp,%rbp
  8005a0:	48 83 ec 50          	sub    $0x50,%rsp
  8005a4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8005a8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8005ac:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8005b0:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8005b7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005bb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005bf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8005c3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8005c7:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8005cb:	48 b8 d9 05 80 00 00 	movabs $0x8005d9,%rax
  8005d2:	00 00 00 
  8005d5:	ff d0                	call   *%rax
}
  8005d7:	c9                   	leave
  8005d8:	c3                   	ret

00000000008005d9 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8005d9:	f3 0f 1e fa          	endbr64
  8005dd:	55                   	push   %rbp
  8005de:	48 89 e5             	mov    %rsp,%rbp
  8005e1:	41 57                	push   %r15
  8005e3:	41 56                	push   %r14
  8005e5:	41 55                	push   %r13
  8005e7:	41 54                	push   %r12
  8005e9:	53                   	push   %rbx
  8005ea:	48 83 ec 38          	sub    $0x38,%rsp
  8005ee:	49 89 fe             	mov    %rdi,%r14
  8005f1:	49 89 f5             	mov    %rsi,%r13
  8005f4:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  8005f7:	48 8b 01             	mov    (%rcx),%rax
  8005fa:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8005fe:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800602:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800606:	48 8b 41 10          	mov    0x10(%rcx),%rax
  80060a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80060e:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800612:	0f b6 3b             	movzbl (%rbx),%edi
  800615:	40 80 ff 25          	cmp    $0x25,%dil
  800619:	74 18                	je     800633 <vprintfmt+0x5a>
            if (!ch) return;
  80061b:	40 84 ff             	test   %dil,%dil
  80061e:	0f 84 b2 06 00 00    	je     800cd6 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800624:	40 0f b6 ff          	movzbl %dil,%edi
  800628:	4c 89 ee             	mov    %r13,%rsi
  80062b:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  80062e:	4c 89 e3             	mov    %r12,%rbx
  800631:	eb db                	jmp    80060e <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800633:	be 00 00 00 00       	mov    $0x0,%esi
  800638:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  80063c:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800641:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800647:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80064e:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800652:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800657:	41 0f b6 04 24       	movzbl (%r12),%eax
  80065c:	88 45 a0             	mov    %al,-0x60(%rbp)
  80065f:	83 e8 23             	sub    $0x23,%eax
  800662:	3c 57                	cmp    $0x57,%al
  800664:	0f 87 52 06 00 00    	ja     800cbc <vprintfmt+0x6e3>
  80066a:	0f b6 c0             	movzbl %al,%eax
  80066d:	48 b9 a0 43 80 00 00 	movabs $0x8043a0,%rcx
  800674:	00 00 00 
  800677:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  80067b:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  80067e:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  800682:	eb ce                	jmp    800652 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800684:	49 89 dc             	mov    %rbx,%r12
  800687:	be 01 00 00 00       	mov    $0x1,%esi
  80068c:	eb c4                	jmp    800652 <vprintfmt+0x79>
            padc = ch;
  80068e:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800692:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800695:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800698:	eb b8                	jmp    800652 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80069a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80069d:	83 f8 2f             	cmp    $0x2f,%eax
  8006a0:	77 24                	ja     8006c6 <vprintfmt+0xed>
  8006a2:	89 c1                	mov    %eax,%ecx
  8006a4:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8006a8:	83 c0 08             	add    $0x8,%eax
  8006ab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006ae:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8006b1:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8006b4:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8006b8:	79 98                	jns    800652 <vprintfmt+0x79>
                width = precision;
  8006ba:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  8006be:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8006c4:	eb 8c                	jmp    800652 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8006c6:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8006ca:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8006ce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006d2:	eb da                	jmp    8006ae <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  8006d4:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  8006d9:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8006dd:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  8006e3:	3c 39                	cmp    $0x39,%al
  8006e5:	77 1c                	ja     800703 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  8006e7:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  8006eb:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  8006ef:	0f b6 c0             	movzbl %al,%eax
  8006f2:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8006f7:	0f b6 03             	movzbl (%rbx),%eax
  8006fa:	3c 39                	cmp    $0x39,%al
  8006fc:	76 e9                	jbe    8006e7 <vprintfmt+0x10e>
        process_precision:
  8006fe:	49 89 dc             	mov    %rbx,%r12
  800701:	eb b1                	jmp    8006b4 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800703:	49 89 dc             	mov    %rbx,%r12
  800706:	eb ac                	jmp    8006b4 <vprintfmt+0xdb>
            width = MAX(0, width);
  800708:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  80070b:	85 c9                	test   %ecx,%ecx
  80070d:	b8 00 00 00 00       	mov    $0x0,%eax
  800712:	0f 49 c1             	cmovns %ecx,%eax
  800715:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800718:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80071b:	e9 32 ff ff ff       	jmp    800652 <vprintfmt+0x79>
            lflag++;
  800720:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800723:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800726:	e9 27 ff ff ff       	jmp    800652 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  80072b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80072e:	83 f8 2f             	cmp    $0x2f,%eax
  800731:	77 19                	ja     80074c <vprintfmt+0x173>
  800733:	89 c2                	mov    %eax,%edx
  800735:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800739:	83 c0 08             	add    $0x8,%eax
  80073c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80073f:	8b 3a                	mov    (%rdx),%edi
  800741:	4c 89 ee             	mov    %r13,%rsi
  800744:	41 ff d6             	call   *%r14
            break;
  800747:	e9 c2 fe ff ff       	jmp    80060e <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  80074c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800750:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800754:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800758:	eb e5                	jmp    80073f <vprintfmt+0x166>
            int err = va_arg(aq, int);
  80075a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80075d:	83 f8 2f             	cmp    $0x2f,%eax
  800760:	77 5a                	ja     8007bc <vprintfmt+0x1e3>
  800762:	89 c2                	mov    %eax,%edx
  800764:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800768:	83 c0 08             	add    $0x8,%eax
  80076b:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  80076e:	8b 02                	mov    (%rdx),%eax
  800770:	89 c1                	mov    %eax,%ecx
  800772:	f7 d9                	neg    %ecx
  800774:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800777:	83 f9 13             	cmp    $0x13,%ecx
  80077a:	7f 4e                	jg     8007ca <vprintfmt+0x1f1>
  80077c:	48 63 c1             	movslq %ecx,%rax
  80077f:	48 ba 60 46 80 00 00 	movabs $0x804660,%rdx
  800786:	00 00 00 
  800789:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80078d:	48 85 c0             	test   %rax,%rax
  800790:	74 38                	je     8007ca <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  800792:	48 89 c1             	mov    %rax,%rcx
  800795:	48 ba 6d 42 80 00 00 	movabs $0x80426d,%rdx
  80079c:	00 00 00 
  80079f:	4c 89 ee             	mov    %r13,%rsi
  8007a2:	4c 89 f7             	mov    %r14,%rdi
  8007a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007aa:	49 b8 98 05 80 00 00 	movabs $0x800598,%r8
  8007b1:	00 00 00 
  8007b4:	41 ff d0             	call   *%r8
  8007b7:	e9 52 fe ff ff       	jmp    80060e <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8007bc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007c0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007c4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007c8:	eb a4                	jmp    80076e <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8007ca:	48 ba 91 40 80 00 00 	movabs $0x804091,%rdx
  8007d1:	00 00 00 
  8007d4:	4c 89 ee             	mov    %r13,%rsi
  8007d7:	4c 89 f7             	mov    %r14,%rdi
  8007da:	b8 00 00 00 00       	mov    $0x0,%eax
  8007df:	49 b8 98 05 80 00 00 	movabs $0x800598,%r8
  8007e6:	00 00 00 
  8007e9:	41 ff d0             	call   *%r8
  8007ec:	e9 1d fe ff ff       	jmp    80060e <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8007f1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f4:	83 f8 2f             	cmp    $0x2f,%eax
  8007f7:	77 6c                	ja     800865 <vprintfmt+0x28c>
  8007f9:	89 c2                	mov    %eax,%edx
  8007fb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007ff:	83 c0 08             	add    $0x8,%eax
  800802:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800805:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800808:	48 85 d2             	test   %rdx,%rdx
  80080b:	48 b8 8a 40 80 00 00 	movabs $0x80408a,%rax
  800812:	00 00 00 
  800815:	48 0f 45 c2          	cmovne %rdx,%rax
  800819:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  80081d:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800821:	7e 06                	jle    800829 <vprintfmt+0x250>
  800823:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800827:	75 4a                	jne    800873 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800829:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80082d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800831:	0f b6 00             	movzbl (%rax),%eax
  800834:	84 c0                	test   %al,%al
  800836:	0f 85 9a 00 00 00    	jne    8008d6 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  80083c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80083f:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  800843:	85 c0                	test   %eax,%eax
  800845:	0f 8e c3 fd ff ff    	jle    80060e <vprintfmt+0x35>
  80084b:	4c 89 ee             	mov    %r13,%rsi
  80084e:	bf 20 00 00 00       	mov    $0x20,%edi
  800853:	41 ff d6             	call   *%r14
  800856:	41 83 ec 01          	sub    $0x1,%r12d
  80085a:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  80085e:	75 eb                	jne    80084b <vprintfmt+0x272>
  800860:	e9 a9 fd ff ff       	jmp    80060e <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800865:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800869:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80086d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800871:	eb 92                	jmp    800805 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800873:	49 63 f7             	movslq %r15d,%rsi
  800876:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80087a:	48 b8 9c 0d 80 00 00 	movabs $0x800d9c,%rax
  800881:	00 00 00 
  800884:	ff d0                	call   *%rax
  800886:	48 89 c2             	mov    %rax,%rdx
  800889:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80088c:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80088e:	8d 70 ff             	lea    -0x1(%rax),%esi
  800891:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800894:	85 c0                	test   %eax,%eax
  800896:	7e 91                	jle    800829 <vprintfmt+0x250>
  800898:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80089d:	4c 89 ee             	mov    %r13,%rsi
  8008a0:	44 89 e7             	mov    %r12d,%edi
  8008a3:	41 ff d6             	call   *%r14
  8008a6:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8008aa:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8008ad:	83 f8 ff             	cmp    $0xffffffff,%eax
  8008b0:	75 eb                	jne    80089d <vprintfmt+0x2c4>
  8008b2:	e9 72 ff ff ff       	jmp    800829 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8008b7:	0f b6 f8             	movzbl %al,%edi
  8008ba:	4c 89 ee             	mov    %r13,%rsi
  8008bd:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8008c0:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8008c4:	49 83 c4 01          	add    $0x1,%r12
  8008c8:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  8008ce:	84 c0                	test   %al,%al
  8008d0:	0f 84 66 ff ff ff    	je     80083c <vprintfmt+0x263>
  8008d6:	45 85 ff             	test   %r15d,%r15d
  8008d9:	78 0a                	js     8008e5 <vprintfmt+0x30c>
  8008db:	41 83 ef 01          	sub    $0x1,%r15d
  8008df:	0f 88 57 ff ff ff    	js     80083c <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8008e5:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8008e9:	74 cc                	je     8008b7 <vprintfmt+0x2de>
  8008eb:	8d 50 e0             	lea    -0x20(%rax),%edx
  8008ee:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8008f3:	80 fa 5e             	cmp    $0x5e,%dl
  8008f6:	77 c2                	ja     8008ba <vprintfmt+0x2e1>
  8008f8:	eb bd                	jmp    8008b7 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8008fa:	40 84 f6             	test   %sil,%sil
  8008fd:	75 26                	jne    800925 <vprintfmt+0x34c>
    switch (lflag) {
  8008ff:	85 d2                	test   %edx,%edx
  800901:	74 59                	je     80095c <vprintfmt+0x383>
  800903:	83 fa 01             	cmp    $0x1,%edx
  800906:	74 7b                	je     800983 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800908:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090b:	83 f8 2f             	cmp    $0x2f,%eax
  80090e:	0f 87 96 00 00 00    	ja     8009aa <vprintfmt+0x3d1>
  800914:	89 c2                	mov    %eax,%edx
  800916:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80091a:	83 c0 08             	add    $0x8,%eax
  80091d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800920:	4c 8b 22             	mov    (%rdx),%r12
  800923:	eb 17                	jmp    80093c <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800925:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800928:	83 f8 2f             	cmp    $0x2f,%eax
  80092b:	77 21                	ja     80094e <vprintfmt+0x375>
  80092d:	89 c2                	mov    %eax,%edx
  80092f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800933:	83 c0 08             	add    $0x8,%eax
  800936:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800939:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  80093c:	4d 85 e4             	test   %r12,%r12
  80093f:	78 7a                	js     8009bb <vprintfmt+0x3e2>
            num = i;
  800941:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800944:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800949:	e9 50 02 00 00       	jmp    800b9e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80094e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800952:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800956:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80095a:	eb dd                	jmp    800939 <vprintfmt+0x360>
        return va_arg(*ap, int);
  80095c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095f:	83 f8 2f             	cmp    $0x2f,%eax
  800962:	77 11                	ja     800975 <vprintfmt+0x39c>
  800964:	89 c2                	mov    %eax,%edx
  800966:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80096a:	83 c0 08             	add    $0x8,%eax
  80096d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800970:	4c 63 22             	movslq (%rdx),%r12
  800973:	eb c7                	jmp    80093c <vprintfmt+0x363>
  800975:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800979:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80097d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800981:	eb ed                	jmp    800970 <vprintfmt+0x397>
        return va_arg(*ap, long);
  800983:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800986:	83 f8 2f             	cmp    $0x2f,%eax
  800989:	77 11                	ja     80099c <vprintfmt+0x3c3>
  80098b:	89 c2                	mov    %eax,%edx
  80098d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800991:	83 c0 08             	add    $0x8,%eax
  800994:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800997:	4c 8b 22             	mov    (%rdx),%r12
  80099a:	eb a0                	jmp    80093c <vprintfmt+0x363>
  80099c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009a0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009a8:	eb ed                	jmp    800997 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  8009aa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ae:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009b2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009b6:	e9 65 ff ff ff       	jmp    800920 <vprintfmt+0x347>
                putch('-', put_arg);
  8009bb:	4c 89 ee             	mov    %r13,%rsi
  8009be:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009c3:	41 ff d6             	call   *%r14
                i = -i;
  8009c6:	49 f7 dc             	neg    %r12
  8009c9:	e9 73 ff ff ff       	jmp    800941 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  8009ce:	40 84 f6             	test   %sil,%sil
  8009d1:	75 32                	jne    800a05 <vprintfmt+0x42c>
    switch (lflag) {
  8009d3:	85 d2                	test   %edx,%edx
  8009d5:	74 5d                	je     800a34 <vprintfmt+0x45b>
  8009d7:	83 fa 01             	cmp    $0x1,%edx
  8009da:	0f 84 82 00 00 00    	je     800a62 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8009e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e3:	83 f8 2f             	cmp    $0x2f,%eax
  8009e6:	0f 87 a5 00 00 00    	ja     800a91 <vprintfmt+0x4b8>
  8009ec:	89 c2                	mov    %eax,%edx
  8009ee:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009f2:	83 c0 08             	add    $0x8,%eax
  8009f5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009f8:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8009fb:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800a00:	e9 99 01 00 00       	jmp    800b9e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a05:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a08:	83 f8 2f             	cmp    $0x2f,%eax
  800a0b:	77 19                	ja     800a26 <vprintfmt+0x44d>
  800a0d:	89 c2                	mov    %eax,%edx
  800a0f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a13:	83 c0 08             	add    $0x8,%eax
  800a16:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a19:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800a1c:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a21:	e9 78 01 00 00       	jmp    800b9e <vprintfmt+0x5c5>
  800a26:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a2a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a2e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a32:	eb e5                	jmp    800a19 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800a34:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a37:	83 f8 2f             	cmp    $0x2f,%eax
  800a3a:	77 18                	ja     800a54 <vprintfmt+0x47b>
  800a3c:	89 c2                	mov    %eax,%edx
  800a3e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a42:	83 c0 08             	add    $0x8,%eax
  800a45:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a48:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800a4a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800a4f:	e9 4a 01 00 00       	jmp    800b9e <vprintfmt+0x5c5>
  800a54:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a58:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a5c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a60:	eb e6                	jmp    800a48 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800a62:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a65:	83 f8 2f             	cmp    $0x2f,%eax
  800a68:	77 19                	ja     800a83 <vprintfmt+0x4aa>
  800a6a:	89 c2                	mov    %eax,%edx
  800a6c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a70:	83 c0 08             	add    $0x8,%eax
  800a73:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a76:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800a79:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800a7e:	e9 1b 01 00 00       	jmp    800b9e <vprintfmt+0x5c5>
  800a83:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a87:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a8b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a8f:	eb e5                	jmp    800a76 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800a91:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a95:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a99:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a9d:	e9 56 ff ff ff       	jmp    8009f8 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800aa2:	40 84 f6             	test   %sil,%sil
  800aa5:	75 2e                	jne    800ad5 <vprintfmt+0x4fc>
    switch (lflag) {
  800aa7:	85 d2                	test   %edx,%edx
  800aa9:	74 59                	je     800b04 <vprintfmt+0x52b>
  800aab:	83 fa 01             	cmp    $0x1,%edx
  800aae:	74 7f                	je     800b2f <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800ab0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab3:	83 f8 2f             	cmp    $0x2f,%eax
  800ab6:	0f 87 9f 00 00 00    	ja     800b5b <vprintfmt+0x582>
  800abc:	89 c2                	mov    %eax,%edx
  800abe:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ac2:	83 c0 08             	add    $0x8,%eax
  800ac5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ac8:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800acb:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800ad0:	e9 c9 00 00 00       	jmp    800b9e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800ad5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad8:	83 f8 2f             	cmp    $0x2f,%eax
  800adb:	77 19                	ja     800af6 <vprintfmt+0x51d>
  800add:	89 c2                	mov    %eax,%edx
  800adf:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ae3:	83 c0 08             	add    $0x8,%eax
  800ae6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ae9:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800aec:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800af1:	e9 a8 00 00 00       	jmp    800b9e <vprintfmt+0x5c5>
  800af6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800afa:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800afe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b02:	eb e5                	jmp    800ae9 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800b04:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b07:	83 f8 2f             	cmp    $0x2f,%eax
  800b0a:	77 15                	ja     800b21 <vprintfmt+0x548>
  800b0c:	89 c2                	mov    %eax,%edx
  800b0e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b12:	83 c0 08             	add    $0x8,%eax
  800b15:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b18:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800b1a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800b1f:	eb 7d                	jmp    800b9e <vprintfmt+0x5c5>
  800b21:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b25:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b29:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b2d:	eb e9                	jmp    800b18 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800b2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b32:	83 f8 2f             	cmp    $0x2f,%eax
  800b35:	77 16                	ja     800b4d <vprintfmt+0x574>
  800b37:	89 c2                	mov    %eax,%edx
  800b39:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b3d:	83 c0 08             	add    $0x8,%eax
  800b40:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b43:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800b46:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800b4b:	eb 51                	jmp    800b9e <vprintfmt+0x5c5>
  800b4d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b51:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b55:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b59:	eb e8                	jmp    800b43 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800b5b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b5f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b63:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b67:	e9 5c ff ff ff       	jmp    800ac8 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800b6c:	4c 89 ee             	mov    %r13,%rsi
  800b6f:	bf 30 00 00 00       	mov    $0x30,%edi
  800b74:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800b77:	4c 89 ee             	mov    %r13,%rsi
  800b7a:	bf 78 00 00 00       	mov    $0x78,%edi
  800b7f:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800b82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b85:	83 f8 2f             	cmp    $0x2f,%eax
  800b88:	77 47                	ja     800bd1 <vprintfmt+0x5f8>
  800b8a:	89 c2                	mov    %eax,%edx
  800b8c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b90:	83 c0 08             	add    $0x8,%eax
  800b93:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b96:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b99:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800b9e:	48 83 ec 08          	sub    $0x8,%rsp
  800ba2:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800ba6:	0f 94 c0             	sete   %al
  800ba9:	0f b6 c0             	movzbl %al,%eax
  800bac:	50                   	push   %rax
  800bad:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800bb2:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800bb6:	4c 89 ee             	mov    %r13,%rsi
  800bb9:	4c 89 f7             	mov    %r14,%rdi
  800bbc:	48 b8 c2 04 80 00 00 	movabs $0x8004c2,%rax
  800bc3:	00 00 00 
  800bc6:	ff d0                	call   *%rax
            break;
  800bc8:	48 83 c4 10          	add    $0x10,%rsp
  800bcc:	e9 3d fa ff ff       	jmp    80060e <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800bd1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bd9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bdd:	eb b7                	jmp    800b96 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800bdf:	40 84 f6             	test   %sil,%sil
  800be2:	75 2b                	jne    800c0f <vprintfmt+0x636>
    switch (lflag) {
  800be4:	85 d2                	test   %edx,%edx
  800be6:	74 56                	je     800c3e <vprintfmt+0x665>
  800be8:	83 fa 01             	cmp    $0x1,%edx
  800beb:	74 7f                	je     800c6c <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800bed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf0:	83 f8 2f             	cmp    $0x2f,%eax
  800bf3:	0f 87 a2 00 00 00    	ja     800c9b <vprintfmt+0x6c2>
  800bf9:	89 c2                	mov    %eax,%edx
  800bfb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bff:	83 c0 08             	add    $0x8,%eax
  800c02:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c05:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c08:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800c0d:	eb 8f                	jmp    800b9e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800c0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c12:	83 f8 2f             	cmp    $0x2f,%eax
  800c15:	77 19                	ja     800c30 <vprintfmt+0x657>
  800c17:	89 c2                	mov    %eax,%edx
  800c19:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c1d:	83 c0 08             	add    $0x8,%eax
  800c20:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c23:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c26:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c2b:	e9 6e ff ff ff       	jmp    800b9e <vprintfmt+0x5c5>
  800c30:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c34:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c38:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c3c:	eb e5                	jmp    800c23 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800c3e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c41:	83 f8 2f             	cmp    $0x2f,%eax
  800c44:	77 18                	ja     800c5e <vprintfmt+0x685>
  800c46:	89 c2                	mov    %eax,%edx
  800c48:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c4c:	83 c0 08             	add    $0x8,%eax
  800c4f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c52:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800c54:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800c59:	e9 40 ff ff ff       	jmp    800b9e <vprintfmt+0x5c5>
  800c5e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c62:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c66:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c6a:	eb e6                	jmp    800c52 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800c6c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6f:	83 f8 2f             	cmp    $0x2f,%eax
  800c72:	77 19                	ja     800c8d <vprintfmt+0x6b4>
  800c74:	89 c2                	mov    %eax,%edx
  800c76:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c7a:	83 c0 08             	add    $0x8,%eax
  800c7d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c80:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c83:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800c88:	e9 11 ff ff ff       	jmp    800b9e <vprintfmt+0x5c5>
  800c8d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c91:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c95:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c99:	eb e5                	jmp    800c80 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800c9b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c9f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ca3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ca7:	e9 59 ff ff ff       	jmp    800c05 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800cac:	4c 89 ee             	mov    %r13,%rsi
  800caf:	bf 25 00 00 00       	mov    $0x25,%edi
  800cb4:	41 ff d6             	call   *%r14
            break;
  800cb7:	e9 52 f9 ff ff       	jmp    80060e <vprintfmt+0x35>
            putch('%', put_arg);
  800cbc:	4c 89 ee             	mov    %r13,%rsi
  800cbf:	bf 25 00 00 00       	mov    $0x25,%edi
  800cc4:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800cc7:	48 83 eb 01          	sub    $0x1,%rbx
  800ccb:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800ccf:	75 f6                	jne    800cc7 <vprintfmt+0x6ee>
  800cd1:	e9 38 f9 ff ff       	jmp    80060e <vprintfmt+0x35>
}
  800cd6:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800cda:	5b                   	pop    %rbx
  800cdb:	41 5c                	pop    %r12
  800cdd:	41 5d                	pop    %r13
  800cdf:	41 5e                	pop    %r14
  800ce1:	41 5f                	pop    %r15
  800ce3:	5d                   	pop    %rbp
  800ce4:	c3                   	ret

0000000000800ce5 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800ce5:	f3 0f 1e fa          	endbr64
  800ce9:	55                   	push   %rbp
  800cea:	48 89 e5             	mov    %rsp,%rbp
  800ced:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800cf1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800cf5:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800cfa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800cfe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800d05:	48 85 ff             	test   %rdi,%rdi
  800d08:	74 2b                	je     800d35 <vsnprintf+0x50>
  800d0a:	48 85 f6             	test   %rsi,%rsi
  800d0d:	74 26                	je     800d35 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800d0f:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800d13:	48 bf 7c 05 80 00 00 	movabs $0x80057c,%rdi
  800d1a:	00 00 00 
  800d1d:	48 b8 d9 05 80 00 00 	movabs $0x8005d9,%rax
  800d24:	00 00 00 
  800d27:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800d29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2d:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800d30:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800d33:	c9                   	leave
  800d34:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800d35:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d3a:	eb f7                	jmp    800d33 <vsnprintf+0x4e>

0000000000800d3c <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800d3c:	f3 0f 1e fa          	endbr64
  800d40:	55                   	push   %rbp
  800d41:	48 89 e5             	mov    %rsp,%rbp
  800d44:	48 83 ec 50          	sub    $0x50,%rsp
  800d48:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800d4c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800d50:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800d54:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800d5b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d5f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d63:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d67:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800d6b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800d6f:	48 b8 e5 0c 80 00 00 	movabs $0x800ce5,%rax
  800d76:	00 00 00 
  800d79:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800d7b:	c9                   	leave
  800d7c:	c3                   	ret

0000000000800d7d <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800d7d:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800d81:	80 3f 00             	cmpb   $0x0,(%rdi)
  800d84:	74 10                	je     800d96 <strlen+0x19>
    size_t n = 0;
  800d86:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800d8b:	48 83 c0 01          	add    $0x1,%rax
  800d8f:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800d93:	75 f6                	jne    800d8b <strlen+0xe>
  800d95:	c3                   	ret
    size_t n = 0;
  800d96:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800d9b:	c3                   	ret

0000000000800d9c <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800d9c:	f3 0f 1e fa          	endbr64
  800da0:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800da3:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800da8:	48 85 f6             	test   %rsi,%rsi
  800dab:	74 10                	je     800dbd <strnlen+0x21>
  800dad:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800db1:	74 0b                	je     800dbe <strnlen+0x22>
  800db3:	48 83 c2 01          	add    $0x1,%rdx
  800db7:	48 39 d0             	cmp    %rdx,%rax
  800dba:	75 f1                	jne    800dad <strnlen+0x11>
  800dbc:	c3                   	ret
  800dbd:	c3                   	ret
  800dbe:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800dc1:	c3                   	ret

0000000000800dc2 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800dc2:	f3 0f 1e fa          	endbr64
  800dc6:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800dc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dce:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800dd2:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800dd5:	48 83 c2 01          	add    $0x1,%rdx
  800dd9:	84 c9                	test   %cl,%cl
  800ddb:	75 f1                	jne    800dce <strcpy+0xc>
        ;
    return res;
}
  800ddd:	c3                   	ret

0000000000800dde <strcat>:

char *
strcat(char *dst, const char *src) {
  800dde:	f3 0f 1e fa          	endbr64
  800de2:	55                   	push   %rbp
  800de3:	48 89 e5             	mov    %rsp,%rbp
  800de6:	41 54                	push   %r12
  800de8:	53                   	push   %rbx
  800de9:	48 89 fb             	mov    %rdi,%rbx
  800dec:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800def:	48 b8 7d 0d 80 00 00 	movabs $0x800d7d,%rax
  800df6:	00 00 00 
  800df9:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800dfb:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800dff:	4c 89 e6             	mov    %r12,%rsi
  800e02:	48 b8 c2 0d 80 00 00 	movabs $0x800dc2,%rax
  800e09:	00 00 00 
  800e0c:	ff d0                	call   *%rax
    return dst;
}
  800e0e:	48 89 d8             	mov    %rbx,%rax
  800e11:	5b                   	pop    %rbx
  800e12:	41 5c                	pop    %r12
  800e14:	5d                   	pop    %rbp
  800e15:	c3                   	ret

0000000000800e16 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e16:	f3 0f 1e fa          	endbr64
  800e1a:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800e1d:	48 85 d2             	test   %rdx,%rdx
  800e20:	74 1f                	je     800e41 <strncpy+0x2b>
  800e22:	48 01 fa             	add    %rdi,%rdx
  800e25:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800e28:	48 83 c1 01          	add    $0x1,%rcx
  800e2c:	44 0f b6 06          	movzbl (%rsi),%r8d
  800e30:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800e34:	41 80 f8 01          	cmp    $0x1,%r8b
  800e38:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800e3c:	48 39 ca             	cmp    %rcx,%rdx
  800e3f:	75 e7                	jne    800e28 <strncpy+0x12>
    }
    return ret;
}
  800e41:	c3                   	ret

0000000000800e42 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800e42:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800e46:	48 89 f8             	mov    %rdi,%rax
  800e49:	48 85 d2             	test   %rdx,%rdx
  800e4c:	74 24                	je     800e72 <strlcpy+0x30>
        while (--size > 0 && *src)
  800e4e:	48 83 ea 01          	sub    $0x1,%rdx
  800e52:	74 1b                	je     800e6f <strlcpy+0x2d>
  800e54:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800e58:	0f b6 16             	movzbl (%rsi),%edx
  800e5b:	84 d2                	test   %dl,%dl
  800e5d:	74 10                	je     800e6f <strlcpy+0x2d>
            *dst++ = *src++;
  800e5f:	48 83 c6 01          	add    $0x1,%rsi
  800e63:	48 83 c0 01          	add    $0x1,%rax
  800e67:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800e6a:	48 39 c8             	cmp    %rcx,%rax
  800e6d:	75 e9                	jne    800e58 <strlcpy+0x16>
        *dst = '\0';
  800e6f:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800e72:	48 29 f8             	sub    %rdi,%rax
}
  800e75:	c3                   	ret

0000000000800e76 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800e76:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800e7a:	0f b6 07             	movzbl (%rdi),%eax
  800e7d:	84 c0                	test   %al,%al
  800e7f:	74 13                	je     800e94 <strcmp+0x1e>
  800e81:	38 06                	cmp    %al,(%rsi)
  800e83:	75 0f                	jne    800e94 <strcmp+0x1e>
  800e85:	48 83 c7 01          	add    $0x1,%rdi
  800e89:	48 83 c6 01          	add    $0x1,%rsi
  800e8d:	0f b6 07             	movzbl (%rdi),%eax
  800e90:	84 c0                	test   %al,%al
  800e92:	75 ed                	jne    800e81 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800e94:	0f b6 c0             	movzbl %al,%eax
  800e97:	0f b6 16             	movzbl (%rsi),%edx
  800e9a:	29 d0                	sub    %edx,%eax
}
  800e9c:	c3                   	ret

0000000000800e9d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800e9d:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800ea1:	48 85 d2             	test   %rdx,%rdx
  800ea4:	74 1f                	je     800ec5 <strncmp+0x28>
  800ea6:	0f b6 07             	movzbl (%rdi),%eax
  800ea9:	84 c0                	test   %al,%al
  800eab:	74 1e                	je     800ecb <strncmp+0x2e>
  800ead:	3a 06                	cmp    (%rsi),%al
  800eaf:	75 1a                	jne    800ecb <strncmp+0x2e>
  800eb1:	48 83 c7 01          	add    $0x1,%rdi
  800eb5:	48 83 c6 01          	add    $0x1,%rsi
  800eb9:	48 83 ea 01          	sub    $0x1,%rdx
  800ebd:	75 e7                	jne    800ea6 <strncmp+0x9>

    if (!n) return 0;
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec4:	c3                   	ret
  800ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eca:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800ecb:	0f b6 07             	movzbl (%rdi),%eax
  800ece:	0f b6 16             	movzbl (%rsi),%edx
  800ed1:	29 d0                	sub    %edx,%eax
}
  800ed3:	c3                   	ret

0000000000800ed4 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800ed4:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800ed8:	0f b6 17             	movzbl (%rdi),%edx
  800edb:	84 d2                	test   %dl,%dl
  800edd:	74 18                	je     800ef7 <strchr+0x23>
        if (*str == c) {
  800edf:	0f be d2             	movsbl %dl,%edx
  800ee2:	39 f2                	cmp    %esi,%edx
  800ee4:	74 17                	je     800efd <strchr+0x29>
    for (; *str; str++) {
  800ee6:	48 83 c7 01          	add    $0x1,%rdi
  800eea:	0f b6 17             	movzbl (%rdi),%edx
  800eed:	84 d2                	test   %dl,%dl
  800eef:	75 ee                	jne    800edf <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef6:	c3                   	ret
  800ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  800efc:	c3                   	ret
            return (char *)str;
  800efd:	48 89 f8             	mov    %rdi,%rax
}
  800f00:	c3                   	ret

0000000000800f01 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800f01:	f3 0f 1e fa          	endbr64
  800f05:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800f08:	0f b6 17             	movzbl (%rdi),%edx
  800f0b:	84 d2                	test   %dl,%dl
  800f0d:	74 13                	je     800f22 <strfind+0x21>
  800f0f:	0f be d2             	movsbl %dl,%edx
  800f12:	39 f2                	cmp    %esi,%edx
  800f14:	74 0b                	je     800f21 <strfind+0x20>
  800f16:	48 83 c0 01          	add    $0x1,%rax
  800f1a:	0f b6 10             	movzbl (%rax),%edx
  800f1d:	84 d2                	test   %dl,%dl
  800f1f:	75 ee                	jne    800f0f <strfind+0xe>
        ;
    return (char *)str;
}
  800f21:	c3                   	ret
  800f22:	c3                   	ret

0000000000800f23 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800f23:	f3 0f 1e fa          	endbr64
  800f27:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800f2a:	48 89 f8             	mov    %rdi,%rax
  800f2d:	48 f7 d8             	neg    %rax
  800f30:	83 e0 07             	and    $0x7,%eax
  800f33:	49 89 d1             	mov    %rdx,%r9
  800f36:	49 29 c1             	sub    %rax,%r9
  800f39:	78 36                	js     800f71 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800f3b:	40 0f b6 c6          	movzbl %sil,%eax
  800f3f:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800f46:	01 01 01 
  800f49:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800f4d:	40 f6 c7 07          	test   $0x7,%dil
  800f51:	75 38                	jne    800f8b <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800f53:	4c 89 c9             	mov    %r9,%rcx
  800f56:	48 c1 f9 03          	sar    $0x3,%rcx
  800f5a:	74 0c                	je     800f68 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800f5c:	fc                   	cld
  800f5d:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800f60:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800f64:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800f68:	4d 85 c9             	test   %r9,%r9
  800f6b:	75 45                	jne    800fb2 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800f6d:	4c 89 c0             	mov    %r8,%rax
  800f70:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800f71:	48 85 d2             	test   %rdx,%rdx
  800f74:	74 f7                	je     800f6d <memset+0x4a>
  800f76:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800f79:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800f7c:	48 83 c0 01          	add    $0x1,%rax
  800f80:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800f84:	48 39 c2             	cmp    %rax,%rdx
  800f87:	75 f3                	jne    800f7c <memset+0x59>
  800f89:	eb e2                	jmp    800f6d <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800f8b:	40 f6 c7 01          	test   $0x1,%dil
  800f8f:	74 06                	je     800f97 <memset+0x74>
  800f91:	88 07                	mov    %al,(%rdi)
  800f93:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f97:	40 f6 c7 02          	test   $0x2,%dil
  800f9b:	74 07                	je     800fa4 <memset+0x81>
  800f9d:	66 89 07             	mov    %ax,(%rdi)
  800fa0:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800fa4:	40 f6 c7 04          	test   $0x4,%dil
  800fa8:	74 a9                	je     800f53 <memset+0x30>
  800faa:	89 07                	mov    %eax,(%rdi)
  800fac:	48 83 c7 04          	add    $0x4,%rdi
  800fb0:	eb a1                	jmp    800f53 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800fb2:	41 f6 c1 04          	test   $0x4,%r9b
  800fb6:	74 1b                	je     800fd3 <memset+0xb0>
  800fb8:	89 07                	mov    %eax,(%rdi)
  800fba:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800fbe:	41 f6 c1 02          	test   $0x2,%r9b
  800fc2:	74 07                	je     800fcb <memset+0xa8>
  800fc4:	66 89 07             	mov    %ax,(%rdi)
  800fc7:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800fcb:	41 f6 c1 01          	test   $0x1,%r9b
  800fcf:	74 9c                	je     800f6d <memset+0x4a>
  800fd1:	eb 06                	jmp    800fd9 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800fd3:	41 f6 c1 02          	test   $0x2,%r9b
  800fd7:	75 eb                	jne    800fc4 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800fd9:	88 07                	mov    %al,(%rdi)
  800fdb:	eb 90                	jmp    800f6d <memset+0x4a>

0000000000800fdd <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800fdd:	f3 0f 1e fa          	endbr64
  800fe1:	48 89 f8             	mov    %rdi,%rax
  800fe4:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800fe7:	48 39 fe             	cmp    %rdi,%rsi
  800fea:	73 3b                	jae    801027 <memmove+0x4a>
  800fec:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800ff0:	48 39 d7             	cmp    %rdx,%rdi
  800ff3:	73 32                	jae    801027 <memmove+0x4a>
        s += n;
        d += n;
  800ff5:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800ff9:	48 89 d6             	mov    %rdx,%rsi
  800ffc:	48 09 fe             	or     %rdi,%rsi
  800fff:	48 09 ce             	or     %rcx,%rsi
  801002:	40 f6 c6 07          	test   $0x7,%sil
  801006:	75 12                	jne    80101a <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801008:	48 83 ef 08          	sub    $0x8,%rdi
  80100c:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801010:	48 c1 e9 03          	shr    $0x3,%rcx
  801014:	fd                   	std
  801015:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801018:	fc                   	cld
  801019:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80101a:	48 83 ef 01          	sub    $0x1,%rdi
  80101e:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  801022:	fd                   	std
  801023:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801025:	eb f1                	jmp    801018 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801027:	48 89 f2             	mov    %rsi,%rdx
  80102a:	48 09 c2             	or     %rax,%rdx
  80102d:	48 09 ca             	or     %rcx,%rdx
  801030:	f6 c2 07             	test   $0x7,%dl
  801033:	75 0c                	jne    801041 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801035:	48 c1 e9 03          	shr    $0x3,%rcx
  801039:	48 89 c7             	mov    %rax,%rdi
  80103c:	fc                   	cld
  80103d:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  801040:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  801041:	48 89 c7             	mov    %rax,%rdi
  801044:	fc                   	cld
  801045:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801047:	c3                   	ret

0000000000801048 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801048:	f3 0f 1e fa          	endbr64
  80104c:	55                   	push   %rbp
  80104d:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  801050:	48 b8 dd 0f 80 00 00 	movabs $0x800fdd,%rax
  801057:	00 00 00 
  80105a:	ff d0                	call   *%rax
}
  80105c:	5d                   	pop    %rbp
  80105d:	c3                   	ret

000000000080105e <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80105e:	f3 0f 1e fa          	endbr64
  801062:	55                   	push   %rbp
  801063:	48 89 e5             	mov    %rsp,%rbp
  801066:	41 57                	push   %r15
  801068:	41 56                	push   %r14
  80106a:	41 55                	push   %r13
  80106c:	41 54                	push   %r12
  80106e:	53                   	push   %rbx
  80106f:	48 83 ec 08          	sub    $0x8,%rsp
  801073:	49 89 fe             	mov    %rdi,%r14
  801076:	49 89 f7             	mov    %rsi,%r15
  801079:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  80107c:	48 89 f7             	mov    %rsi,%rdi
  80107f:	48 b8 7d 0d 80 00 00 	movabs $0x800d7d,%rax
  801086:	00 00 00 
  801089:	ff d0                	call   *%rax
  80108b:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80108e:	48 89 de             	mov    %rbx,%rsi
  801091:	4c 89 f7             	mov    %r14,%rdi
  801094:	48 b8 9c 0d 80 00 00 	movabs $0x800d9c,%rax
  80109b:	00 00 00 
  80109e:	ff d0                	call   *%rax
  8010a0:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8010a3:	48 39 c3             	cmp    %rax,%rbx
  8010a6:	74 36                	je     8010de <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  8010a8:	48 89 d8             	mov    %rbx,%rax
  8010ab:	4c 29 e8             	sub    %r13,%rax
  8010ae:	49 39 c4             	cmp    %rax,%r12
  8010b1:	73 31                	jae    8010e4 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  8010b3:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8010b8:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8010bc:	4c 89 fe             	mov    %r15,%rsi
  8010bf:	48 b8 48 10 80 00 00 	movabs $0x801048,%rax
  8010c6:	00 00 00 
  8010c9:	ff d0                	call   *%rax
    return dstlen + srclen;
  8010cb:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8010cf:	48 83 c4 08          	add    $0x8,%rsp
  8010d3:	5b                   	pop    %rbx
  8010d4:	41 5c                	pop    %r12
  8010d6:	41 5d                	pop    %r13
  8010d8:	41 5e                	pop    %r14
  8010da:	41 5f                	pop    %r15
  8010dc:	5d                   	pop    %rbp
  8010dd:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  8010de:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  8010e2:	eb eb                	jmp    8010cf <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  8010e4:	48 83 eb 01          	sub    $0x1,%rbx
  8010e8:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8010ec:	48 89 da             	mov    %rbx,%rdx
  8010ef:	4c 89 fe             	mov    %r15,%rsi
  8010f2:	48 b8 48 10 80 00 00 	movabs $0x801048,%rax
  8010f9:	00 00 00 
  8010fc:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8010fe:	49 01 de             	add    %rbx,%r14
  801101:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801106:	eb c3                	jmp    8010cb <strlcat+0x6d>

0000000000801108 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801108:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  80110c:	48 85 d2             	test   %rdx,%rdx
  80110f:	74 2d                	je     80113e <memcmp+0x36>
  801111:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801116:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  80111a:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  80111f:	44 38 c1             	cmp    %r8b,%cl
  801122:	75 0f                	jne    801133 <memcmp+0x2b>
    while (n-- > 0) {
  801124:	48 83 c0 01          	add    $0x1,%rax
  801128:	48 39 c2             	cmp    %rax,%rdx
  80112b:	75 e9                	jne    801116 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  80112d:	b8 00 00 00 00       	mov    $0x0,%eax
  801132:	c3                   	ret
            return (int)*s1 - (int)*s2;
  801133:	0f b6 c1             	movzbl %cl,%eax
  801136:	45 0f b6 c0          	movzbl %r8b,%r8d
  80113a:	44 29 c0             	sub    %r8d,%eax
  80113d:	c3                   	ret
    return 0;
  80113e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801143:	c3                   	ret

0000000000801144 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  801144:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  801148:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80114c:	48 39 c7             	cmp    %rax,%rdi
  80114f:	73 0f                	jae    801160 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801151:	40 38 37             	cmp    %sil,(%rdi)
  801154:	74 0e                	je     801164 <memfind+0x20>
    for (; src < end; src++) {
  801156:	48 83 c7 01          	add    $0x1,%rdi
  80115a:	48 39 f8             	cmp    %rdi,%rax
  80115d:	75 f2                	jne    801151 <memfind+0xd>
  80115f:	c3                   	ret
  801160:	48 89 f8             	mov    %rdi,%rax
  801163:	c3                   	ret
  801164:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801167:	c3                   	ret

0000000000801168 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801168:	f3 0f 1e fa          	endbr64
  80116c:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80116f:	0f b6 37             	movzbl (%rdi),%esi
  801172:	40 80 fe 20          	cmp    $0x20,%sil
  801176:	74 06                	je     80117e <strtol+0x16>
  801178:	40 80 fe 09          	cmp    $0x9,%sil
  80117c:	75 13                	jne    801191 <strtol+0x29>
  80117e:	48 83 c7 01          	add    $0x1,%rdi
  801182:	0f b6 37             	movzbl (%rdi),%esi
  801185:	40 80 fe 20          	cmp    $0x20,%sil
  801189:	74 f3                	je     80117e <strtol+0x16>
  80118b:	40 80 fe 09          	cmp    $0x9,%sil
  80118f:	74 ed                	je     80117e <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801191:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801194:	83 e0 fd             	and    $0xfffffffd,%eax
  801197:	3c 01                	cmp    $0x1,%al
  801199:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80119d:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  8011a3:	75 0f                	jne    8011b4 <strtol+0x4c>
  8011a5:	80 3f 30             	cmpb   $0x30,(%rdi)
  8011a8:	74 14                	je     8011be <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8011aa:	85 d2                	test   %edx,%edx
  8011ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011b1:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  8011b4:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8011b9:	4c 63 ca             	movslq %edx,%r9
  8011bc:	eb 36                	jmp    8011f4 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8011be:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8011c2:	74 0f                	je     8011d3 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  8011c4:	85 d2                	test   %edx,%edx
  8011c6:	75 ec                	jne    8011b4 <strtol+0x4c>
        s++;
  8011c8:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8011cc:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  8011d1:	eb e1                	jmp    8011b4 <strtol+0x4c>
        s += 2;
  8011d3:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8011d7:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  8011dc:	eb d6                	jmp    8011b4 <strtol+0x4c>
            dig -= '0';
  8011de:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  8011e1:	44 0f b6 c1          	movzbl %cl,%r8d
  8011e5:	41 39 d0             	cmp    %edx,%r8d
  8011e8:	7d 21                	jge    80120b <strtol+0xa3>
        val = val * base + dig;
  8011ea:	49 0f af c1          	imul   %r9,%rax
  8011ee:	0f b6 c9             	movzbl %cl,%ecx
  8011f1:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  8011f4:	48 83 c7 01          	add    $0x1,%rdi
  8011f8:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  8011fc:	80 f9 39             	cmp    $0x39,%cl
  8011ff:	76 dd                	jbe    8011de <strtol+0x76>
        else if (dig - 'a' < 27)
  801201:	80 f9 7b             	cmp    $0x7b,%cl
  801204:	77 05                	ja     80120b <strtol+0xa3>
            dig -= 'a' - 10;
  801206:	83 e9 57             	sub    $0x57,%ecx
  801209:	eb d6                	jmp    8011e1 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  80120b:	4d 85 d2             	test   %r10,%r10
  80120e:	74 03                	je     801213 <strtol+0xab>
  801210:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801213:	48 89 c2             	mov    %rax,%rdx
  801216:	48 f7 da             	neg    %rdx
  801219:	40 80 fe 2d          	cmp    $0x2d,%sil
  80121d:	48 0f 44 c2          	cmove  %rdx,%rax
}
  801221:	c3                   	ret

0000000000801222 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801222:	f3 0f 1e fa          	endbr64
  801226:	55                   	push   %rbp
  801227:	48 89 e5             	mov    %rsp,%rbp
  80122a:	53                   	push   %rbx
  80122b:	48 89 fa             	mov    %rdi,%rdx
  80122e:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801231:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801236:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801240:	be 00 00 00 00       	mov    $0x0,%esi
  801245:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80124b:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80124d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801251:	c9                   	leave
  801252:	c3                   	ret

0000000000801253 <sys_cgetc>:

int
sys_cgetc(void) {
  801253:	f3 0f 1e fa          	endbr64
  801257:	55                   	push   %rbp
  801258:	48 89 e5             	mov    %rsp,%rbp
  80125b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80125c:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801261:	ba 00 00 00 00       	mov    $0x0,%edx
  801266:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80126b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801270:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801275:	be 00 00 00 00       	mov    $0x0,%esi
  80127a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801280:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801282:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801286:	c9                   	leave
  801287:	c3                   	ret

0000000000801288 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801288:	f3 0f 1e fa          	endbr64
  80128c:	55                   	push   %rbp
  80128d:	48 89 e5             	mov    %rsp,%rbp
  801290:	53                   	push   %rbx
  801291:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801295:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801298:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80129d:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012ac:	be 00 00 00 00       	mov    $0x0,%esi
  8012b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012b7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012b9:	48 85 c0             	test   %rax,%rax
  8012bc:	7f 06                	jg     8012c4 <sys_env_destroy+0x3c>
}
  8012be:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012c2:	c9                   	leave
  8012c3:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012c4:	49 89 c0             	mov    %rax,%r8
  8012c7:	b9 03 00 00 00       	mov    $0x3,%ecx
  8012cc:	48 ba 00 43 80 00 00 	movabs $0x804300,%rdx
  8012d3:	00 00 00 
  8012d6:	be 26 00 00 00       	mov    $0x26,%esi
  8012db:	48 bf f7 41 80 00 00 	movabs $0x8041f7,%rdi
  8012e2:	00 00 00 
  8012e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ea:	49 b9 1d 03 80 00 00 	movabs $0x80031d,%r9
  8012f1:	00 00 00 
  8012f4:	41 ff d1             	call   *%r9

00000000008012f7 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8012f7:	f3 0f 1e fa          	endbr64
  8012fb:	55                   	push   %rbp
  8012fc:	48 89 e5             	mov    %rsp,%rbp
  8012ff:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801300:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801305:	ba 00 00 00 00       	mov    $0x0,%edx
  80130a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80130f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801314:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801319:	be 00 00 00 00       	mov    $0x0,%esi
  80131e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801324:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801326:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80132a:	c9                   	leave
  80132b:	c3                   	ret

000000000080132c <sys_yield>:

void
sys_yield(void) {
  80132c:	f3 0f 1e fa          	endbr64
  801330:	55                   	push   %rbp
  801331:	48 89 e5             	mov    %rsp,%rbp
  801334:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801335:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80133a:	ba 00 00 00 00       	mov    $0x0,%edx
  80133f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801344:	bb 00 00 00 00       	mov    $0x0,%ebx
  801349:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80134e:	be 00 00 00 00       	mov    $0x0,%esi
  801353:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801359:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80135b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80135f:	c9                   	leave
  801360:	c3                   	ret

0000000000801361 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801361:	f3 0f 1e fa          	endbr64
  801365:	55                   	push   %rbp
  801366:	48 89 e5             	mov    %rsp,%rbp
  801369:	53                   	push   %rbx
  80136a:	48 89 fa             	mov    %rdi,%rdx
  80136d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801370:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801375:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80137c:	00 00 00 
  80137f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801384:	be 00 00 00 00       	mov    $0x0,%esi
  801389:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80138f:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801391:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801395:	c9                   	leave
  801396:	c3                   	ret

0000000000801397 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801397:	f3 0f 1e fa          	endbr64
  80139b:	55                   	push   %rbp
  80139c:	48 89 e5             	mov    %rsp,%rbp
  80139f:	53                   	push   %rbx
  8013a0:	49 89 f8             	mov    %rdi,%r8
  8013a3:	48 89 d3             	mov    %rdx,%rbx
  8013a6:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8013a9:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013ae:	4c 89 c2             	mov    %r8,%rdx
  8013b1:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013b4:	be 00 00 00 00       	mov    $0x0,%esi
  8013b9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013bf:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8013c1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013c5:	c9                   	leave
  8013c6:	c3                   	ret

00000000008013c7 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8013c7:	f3 0f 1e fa          	endbr64
  8013cb:	55                   	push   %rbp
  8013cc:	48 89 e5             	mov    %rsp,%rbp
  8013cf:	53                   	push   %rbx
  8013d0:	48 83 ec 08          	sub    $0x8,%rsp
  8013d4:	89 f8                	mov    %edi,%eax
  8013d6:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8013d9:	48 63 f9             	movslq %ecx,%rdi
  8013dc:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013df:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013e4:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e7:	be 00 00 00 00       	mov    $0x0,%esi
  8013ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013f2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013f4:	48 85 c0             	test   %rax,%rax
  8013f7:	7f 06                	jg     8013ff <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8013f9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013fd:	c9                   	leave
  8013fe:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013ff:	49 89 c0             	mov    %rax,%r8
  801402:	b9 04 00 00 00       	mov    $0x4,%ecx
  801407:	48 ba 00 43 80 00 00 	movabs $0x804300,%rdx
  80140e:	00 00 00 
  801411:	be 26 00 00 00       	mov    $0x26,%esi
  801416:	48 bf f7 41 80 00 00 	movabs $0x8041f7,%rdi
  80141d:	00 00 00 
  801420:	b8 00 00 00 00       	mov    $0x0,%eax
  801425:	49 b9 1d 03 80 00 00 	movabs $0x80031d,%r9
  80142c:	00 00 00 
  80142f:	41 ff d1             	call   *%r9

0000000000801432 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801432:	f3 0f 1e fa          	endbr64
  801436:	55                   	push   %rbp
  801437:	48 89 e5             	mov    %rsp,%rbp
  80143a:	53                   	push   %rbx
  80143b:	48 83 ec 08          	sub    $0x8,%rsp
  80143f:	89 f8                	mov    %edi,%eax
  801441:	49 89 f2             	mov    %rsi,%r10
  801444:	48 89 cf             	mov    %rcx,%rdi
  801447:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80144a:	48 63 da             	movslq %edx,%rbx
  80144d:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801450:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801455:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801458:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80145b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80145d:	48 85 c0             	test   %rax,%rax
  801460:	7f 06                	jg     801468 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801462:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801466:	c9                   	leave
  801467:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801468:	49 89 c0             	mov    %rax,%r8
  80146b:	b9 05 00 00 00       	mov    $0x5,%ecx
  801470:	48 ba 00 43 80 00 00 	movabs $0x804300,%rdx
  801477:	00 00 00 
  80147a:	be 26 00 00 00       	mov    $0x26,%esi
  80147f:	48 bf f7 41 80 00 00 	movabs $0x8041f7,%rdi
  801486:	00 00 00 
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
  80148e:	49 b9 1d 03 80 00 00 	movabs $0x80031d,%r9
  801495:	00 00 00 
  801498:	41 ff d1             	call   *%r9

000000000080149b <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80149b:	f3 0f 1e fa          	endbr64
  80149f:	55                   	push   %rbp
  8014a0:	48 89 e5             	mov    %rsp,%rbp
  8014a3:	53                   	push   %rbx
  8014a4:	48 83 ec 08          	sub    $0x8,%rsp
  8014a8:	49 89 f9             	mov    %rdi,%r9
  8014ab:	89 f0                	mov    %esi,%eax
  8014ad:	48 89 d3             	mov    %rdx,%rbx
  8014b0:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8014b3:	49 63 f0             	movslq %r8d,%rsi
  8014b6:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8014b9:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014be:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014c1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014c7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014c9:	48 85 c0             	test   %rax,%rax
  8014cc:	7f 06                	jg     8014d4 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8014ce:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014d2:	c9                   	leave
  8014d3:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014d4:	49 89 c0             	mov    %rax,%r8
  8014d7:	b9 06 00 00 00       	mov    $0x6,%ecx
  8014dc:	48 ba 00 43 80 00 00 	movabs $0x804300,%rdx
  8014e3:	00 00 00 
  8014e6:	be 26 00 00 00       	mov    $0x26,%esi
  8014eb:	48 bf f7 41 80 00 00 	movabs $0x8041f7,%rdi
  8014f2:	00 00 00 
  8014f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fa:	49 b9 1d 03 80 00 00 	movabs $0x80031d,%r9
  801501:	00 00 00 
  801504:	41 ff d1             	call   *%r9

0000000000801507 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801507:	f3 0f 1e fa          	endbr64
  80150b:	55                   	push   %rbp
  80150c:	48 89 e5             	mov    %rsp,%rbp
  80150f:	53                   	push   %rbx
  801510:	48 83 ec 08          	sub    $0x8,%rsp
  801514:	48 89 f1             	mov    %rsi,%rcx
  801517:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80151a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80151d:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801522:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801527:	be 00 00 00 00       	mov    $0x0,%esi
  80152c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801532:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801534:	48 85 c0             	test   %rax,%rax
  801537:	7f 06                	jg     80153f <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801539:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80153d:	c9                   	leave
  80153e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80153f:	49 89 c0             	mov    %rax,%r8
  801542:	b9 07 00 00 00       	mov    $0x7,%ecx
  801547:	48 ba 00 43 80 00 00 	movabs $0x804300,%rdx
  80154e:	00 00 00 
  801551:	be 26 00 00 00       	mov    $0x26,%esi
  801556:	48 bf f7 41 80 00 00 	movabs $0x8041f7,%rdi
  80155d:	00 00 00 
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	49 b9 1d 03 80 00 00 	movabs $0x80031d,%r9
  80156c:	00 00 00 
  80156f:	41 ff d1             	call   *%r9

0000000000801572 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801572:	f3 0f 1e fa          	endbr64
  801576:	55                   	push   %rbp
  801577:	48 89 e5             	mov    %rsp,%rbp
  80157a:	53                   	push   %rbx
  80157b:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80157f:	48 63 ce             	movslq %esi,%rcx
  801582:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801585:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80158a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80158f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801594:	be 00 00 00 00       	mov    $0x0,%esi
  801599:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80159f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015a1:	48 85 c0             	test   %rax,%rax
  8015a4:	7f 06                	jg     8015ac <sys_env_set_status+0x3a>
}
  8015a6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015aa:	c9                   	leave
  8015ab:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015ac:	49 89 c0             	mov    %rax,%r8
  8015af:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015b4:	48 ba 00 43 80 00 00 	movabs $0x804300,%rdx
  8015bb:	00 00 00 
  8015be:	be 26 00 00 00       	mov    $0x26,%esi
  8015c3:	48 bf f7 41 80 00 00 	movabs $0x8041f7,%rdi
  8015ca:	00 00 00 
  8015cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d2:	49 b9 1d 03 80 00 00 	movabs $0x80031d,%r9
  8015d9:	00 00 00 
  8015dc:	41 ff d1             	call   *%r9

00000000008015df <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8015df:	f3 0f 1e fa          	endbr64
  8015e3:	55                   	push   %rbp
  8015e4:	48 89 e5             	mov    %rsp,%rbp
  8015e7:	53                   	push   %rbx
  8015e8:	48 83 ec 08          	sub    $0x8,%rsp
  8015ec:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8015ef:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015f2:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015fc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801601:	be 00 00 00 00       	mov    $0x0,%esi
  801606:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80160c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80160e:	48 85 c0             	test   %rax,%rax
  801611:	7f 06                	jg     801619 <sys_env_set_trapframe+0x3a>
}
  801613:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801617:	c9                   	leave
  801618:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801619:	49 89 c0             	mov    %rax,%r8
  80161c:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801621:	48 ba 00 43 80 00 00 	movabs $0x804300,%rdx
  801628:	00 00 00 
  80162b:	be 26 00 00 00       	mov    $0x26,%esi
  801630:	48 bf f7 41 80 00 00 	movabs $0x8041f7,%rdi
  801637:	00 00 00 
  80163a:	b8 00 00 00 00       	mov    $0x0,%eax
  80163f:	49 b9 1d 03 80 00 00 	movabs $0x80031d,%r9
  801646:	00 00 00 
  801649:	41 ff d1             	call   *%r9

000000000080164c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80164c:	f3 0f 1e fa          	endbr64
  801650:	55                   	push   %rbp
  801651:	48 89 e5             	mov    %rsp,%rbp
  801654:	53                   	push   %rbx
  801655:	48 83 ec 08          	sub    $0x8,%rsp
  801659:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80165c:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80165f:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801664:	bb 00 00 00 00       	mov    $0x0,%ebx
  801669:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80166e:	be 00 00 00 00       	mov    $0x0,%esi
  801673:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801679:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80167b:	48 85 c0             	test   %rax,%rax
  80167e:	7f 06                	jg     801686 <sys_env_set_pgfault_upcall+0x3a>
}
  801680:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801684:	c9                   	leave
  801685:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801686:	49 89 c0             	mov    %rax,%r8
  801689:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80168e:	48 ba 00 43 80 00 00 	movabs $0x804300,%rdx
  801695:	00 00 00 
  801698:	be 26 00 00 00       	mov    $0x26,%esi
  80169d:	48 bf f7 41 80 00 00 	movabs $0x8041f7,%rdi
  8016a4:	00 00 00 
  8016a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ac:	49 b9 1d 03 80 00 00 	movabs $0x80031d,%r9
  8016b3:	00 00 00 
  8016b6:	41 ff d1             	call   *%r9

00000000008016b9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8016b9:	f3 0f 1e fa          	endbr64
  8016bd:	55                   	push   %rbp
  8016be:	48 89 e5             	mov    %rsp,%rbp
  8016c1:	53                   	push   %rbx
  8016c2:	89 f8                	mov    %edi,%eax
  8016c4:	49 89 f1             	mov    %rsi,%r9
  8016c7:	48 89 d3             	mov    %rdx,%rbx
  8016ca:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8016cd:	49 63 f0             	movslq %r8d,%rsi
  8016d0:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016d3:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8016d8:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016e1:	cd 30                	int    $0x30
}
  8016e3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016e7:	c9                   	leave
  8016e8:	c3                   	ret

00000000008016e9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8016e9:	f3 0f 1e fa          	endbr64
  8016ed:	55                   	push   %rbp
  8016ee:	48 89 e5             	mov    %rsp,%rbp
  8016f1:	53                   	push   %rbx
  8016f2:	48 83 ec 08          	sub    $0x8,%rsp
  8016f6:	48 89 fa             	mov    %rdi,%rdx
  8016f9:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8016fc:	b8 0f 00 00 00       	mov    $0xf,%eax
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
  80171b:	7f 06                	jg     801723 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80171d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801721:	c9                   	leave
  801722:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801723:	49 89 c0             	mov    %rax,%r8
  801726:	b9 0f 00 00 00       	mov    $0xf,%ecx
  80172b:	48 ba 00 43 80 00 00 	movabs $0x804300,%rdx
  801732:	00 00 00 
  801735:	be 26 00 00 00       	mov    $0x26,%esi
  80173a:	48 bf f7 41 80 00 00 	movabs $0x8041f7,%rdi
  801741:	00 00 00 
  801744:	b8 00 00 00 00       	mov    $0x0,%eax
  801749:	49 b9 1d 03 80 00 00 	movabs $0x80031d,%r9
  801750:	00 00 00 
  801753:	41 ff d1             	call   *%r9

0000000000801756 <sys_gettime>:

int
sys_gettime(void) {
  801756:	f3 0f 1e fa          	endbr64
  80175a:	55                   	push   %rbp
  80175b:	48 89 e5             	mov    %rsp,%rbp
  80175e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80175f:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801764:	ba 00 00 00 00       	mov    $0x0,%edx
  801769:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80176e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801773:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801778:	be 00 00 00 00       	mov    $0x0,%esi
  80177d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801783:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801785:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801789:	c9                   	leave
  80178a:	c3                   	ret

000000000080178b <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  80178b:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80178f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801796:	ff ff ff 
  801799:	48 01 f8             	add    %rdi,%rax
  80179c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8017a0:	c3                   	ret

00000000008017a1 <fd2data>:

char *
fd2data(struct Fd *fd) {
  8017a1:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8017a5:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8017ac:	ff ff ff 
  8017af:	48 01 f8             	add    %rdi,%rax
  8017b2:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8017b6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8017bc:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8017c0:	c3                   	ret

00000000008017c1 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8017c1:	f3 0f 1e fa          	endbr64
  8017c5:	55                   	push   %rbp
  8017c6:	48 89 e5             	mov    %rsp,%rbp
  8017c9:	41 57                	push   %r15
  8017cb:	41 56                	push   %r14
  8017cd:	41 55                	push   %r13
  8017cf:	41 54                	push   %r12
  8017d1:	53                   	push   %rbx
  8017d2:	48 83 ec 08          	sub    $0x8,%rsp
  8017d6:	49 89 ff             	mov    %rdi,%r15
  8017d9:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8017de:	49 bd d8 2a 80 00 00 	movabs $0x802ad8,%r13
  8017e5:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8017e8:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8017ee:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8017f1:	48 89 df             	mov    %rbx,%rdi
  8017f4:	41 ff d5             	call   *%r13
  8017f7:	83 e0 04             	and    $0x4,%eax
  8017fa:	74 17                	je     801813 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8017fc:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801803:	4c 39 f3             	cmp    %r14,%rbx
  801806:	75 e6                	jne    8017ee <fd_alloc+0x2d>
  801808:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  80180e:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801813:	4d 89 27             	mov    %r12,(%r15)
}
  801816:	48 83 c4 08          	add    $0x8,%rsp
  80181a:	5b                   	pop    %rbx
  80181b:	41 5c                	pop    %r12
  80181d:	41 5d                	pop    %r13
  80181f:	41 5e                	pop    %r14
  801821:	41 5f                	pop    %r15
  801823:	5d                   	pop    %rbp
  801824:	c3                   	ret

0000000000801825 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801825:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801829:	83 ff 1f             	cmp    $0x1f,%edi
  80182c:	77 39                	ja     801867 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80182e:	55                   	push   %rbp
  80182f:	48 89 e5             	mov    %rsp,%rbp
  801832:	41 54                	push   %r12
  801834:	53                   	push   %rbx
  801835:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801838:	48 63 df             	movslq %edi,%rbx
  80183b:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801842:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801846:	48 89 df             	mov    %rbx,%rdi
  801849:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  801850:	00 00 00 
  801853:	ff d0                	call   *%rax
  801855:	a8 04                	test   $0x4,%al
  801857:	74 14                	je     80186d <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801859:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80185d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801862:	5b                   	pop    %rbx
  801863:	41 5c                	pop    %r12
  801865:	5d                   	pop    %rbp
  801866:	c3                   	ret
        return -E_INVAL;
  801867:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80186c:	c3                   	ret
        return -E_INVAL;
  80186d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801872:	eb ee                	jmp    801862 <fd_lookup+0x3d>

0000000000801874 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801874:	f3 0f 1e fa          	endbr64
  801878:	55                   	push   %rbp
  801879:	48 89 e5             	mov    %rsp,%rbp
  80187c:	41 54                	push   %r12
  80187e:	53                   	push   %rbx
  80187f:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801882:	48 b8 00 47 80 00 00 	movabs $0x804700,%rax
  801889:	00 00 00 
  80188c:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801893:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801896:	39 3b                	cmp    %edi,(%rbx)
  801898:	74 47                	je     8018e1 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  80189a:	48 83 c0 08          	add    $0x8,%rax
  80189e:	48 8b 18             	mov    (%rax),%rbx
  8018a1:	48 85 db             	test   %rbx,%rbx
  8018a4:	75 f0                	jne    801896 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018a6:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  8018ad:	00 00 00 
  8018b0:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8018b6:	89 fa                	mov    %edi,%edx
  8018b8:	48 bf 20 43 80 00 00 	movabs $0x804320,%rdi
  8018bf:	00 00 00 
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c7:	48 b9 79 04 80 00 00 	movabs $0x800479,%rcx
  8018ce:	00 00 00 
  8018d1:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8018d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8018d8:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8018dc:	5b                   	pop    %rbx
  8018dd:	41 5c                	pop    %r12
  8018df:	5d                   	pop    %rbp
  8018e0:	c3                   	ret
            return 0;
  8018e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e6:	eb f0                	jmp    8018d8 <dev_lookup+0x64>

00000000008018e8 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8018e8:	f3 0f 1e fa          	endbr64
  8018ec:	55                   	push   %rbp
  8018ed:	48 89 e5             	mov    %rsp,%rbp
  8018f0:	41 55                	push   %r13
  8018f2:	41 54                	push   %r12
  8018f4:	53                   	push   %rbx
  8018f5:	48 83 ec 18          	sub    $0x18,%rsp
  8018f9:	48 89 fb             	mov    %rdi,%rbx
  8018fc:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8018ff:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801906:	ff ff ff 
  801909:	48 01 df             	add    %rbx,%rdi
  80190c:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801910:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801914:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  80191b:	00 00 00 
  80191e:	ff d0                	call   *%rax
  801920:	41 89 c5             	mov    %eax,%r13d
  801923:	85 c0                	test   %eax,%eax
  801925:	78 06                	js     80192d <fd_close+0x45>
  801927:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  80192b:	74 1a                	je     801947 <fd_close+0x5f>
        return (must_exist ? res : 0);
  80192d:	45 84 e4             	test   %r12b,%r12b
  801930:	b8 00 00 00 00       	mov    $0x0,%eax
  801935:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801939:	44 89 e8             	mov    %r13d,%eax
  80193c:	48 83 c4 18          	add    $0x18,%rsp
  801940:	5b                   	pop    %rbx
  801941:	41 5c                	pop    %r12
  801943:	41 5d                	pop    %r13
  801945:	5d                   	pop    %rbp
  801946:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801947:	8b 3b                	mov    (%rbx),%edi
  801949:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80194d:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  801954:	00 00 00 
  801957:	ff d0                	call   *%rax
  801959:	41 89 c5             	mov    %eax,%r13d
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 1b                	js     80197b <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801960:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801964:	48 8b 40 20          	mov    0x20(%rax),%rax
  801968:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80196e:	48 85 c0             	test   %rax,%rax
  801971:	74 08                	je     80197b <fd_close+0x93>
  801973:	48 89 df             	mov    %rbx,%rdi
  801976:	ff d0                	call   *%rax
  801978:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80197b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801980:	48 89 de             	mov    %rbx,%rsi
  801983:	bf 00 00 00 00       	mov    $0x0,%edi
  801988:	48 b8 07 15 80 00 00 	movabs $0x801507,%rax
  80198f:	00 00 00 
  801992:	ff d0                	call   *%rax
    return res;
  801994:	eb a3                	jmp    801939 <fd_close+0x51>

0000000000801996 <close>:

int
close(int fdnum) {
  801996:	f3 0f 1e fa          	endbr64
  80199a:	55                   	push   %rbp
  80199b:	48 89 e5             	mov    %rsp,%rbp
  80199e:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8019a2:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8019a6:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  8019ad:	00 00 00 
  8019b0:	ff d0                	call   *%rax
    if (res < 0) return res;
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	78 15                	js     8019cb <close+0x35>

    return fd_close(fd, 1);
  8019b6:	be 01 00 00 00       	mov    $0x1,%esi
  8019bb:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8019bf:	48 b8 e8 18 80 00 00 	movabs $0x8018e8,%rax
  8019c6:	00 00 00 
  8019c9:	ff d0                	call   *%rax
}
  8019cb:	c9                   	leave
  8019cc:	c3                   	ret

00000000008019cd <close_all>:

void
close_all(void) {
  8019cd:	f3 0f 1e fa          	endbr64
  8019d1:	55                   	push   %rbp
  8019d2:	48 89 e5             	mov    %rsp,%rbp
  8019d5:	41 54                	push   %r12
  8019d7:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8019d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019dd:	49 bc 96 19 80 00 00 	movabs $0x801996,%r12
  8019e4:	00 00 00 
  8019e7:	89 df                	mov    %ebx,%edi
  8019e9:	41 ff d4             	call   *%r12
  8019ec:	83 c3 01             	add    $0x1,%ebx
  8019ef:	83 fb 20             	cmp    $0x20,%ebx
  8019f2:	75 f3                	jne    8019e7 <close_all+0x1a>
}
  8019f4:	5b                   	pop    %rbx
  8019f5:	41 5c                	pop    %r12
  8019f7:	5d                   	pop    %rbp
  8019f8:	c3                   	ret

00000000008019f9 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8019f9:	f3 0f 1e fa          	endbr64
  8019fd:	55                   	push   %rbp
  8019fe:	48 89 e5             	mov    %rsp,%rbp
  801a01:	41 57                	push   %r15
  801a03:	41 56                	push   %r14
  801a05:	41 55                	push   %r13
  801a07:	41 54                	push   %r12
  801a09:	53                   	push   %rbx
  801a0a:	48 83 ec 18          	sub    $0x18,%rsp
  801a0e:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801a11:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801a15:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  801a1c:	00 00 00 
  801a1f:	ff d0                	call   *%rax
  801a21:	89 c3                	mov    %eax,%ebx
  801a23:	85 c0                	test   %eax,%eax
  801a25:	0f 88 b8 00 00 00    	js     801ae3 <dup+0xea>
    close(newfdnum);
  801a2b:	44 89 e7             	mov    %r12d,%edi
  801a2e:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  801a35:	00 00 00 
  801a38:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801a3a:	4d 63 ec             	movslq %r12d,%r13
  801a3d:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801a44:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801a48:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801a4c:	4c 89 ff             	mov    %r15,%rdi
  801a4f:	49 be a1 17 80 00 00 	movabs $0x8017a1,%r14
  801a56:	00 00 00 
  801a59:	41 ff d6             	call   *%r14
  801a5c:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801a5f:	4c 89 ef             	mov    %r13,%rdi
  801a62:	41 ff d6             	call   *%r14
  801a65:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801a68:	48 89 df             	mov    %rbx,%rdi
  801a6b:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  801a72:	00 00 00 
  801a75:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801a77:	a8 04                	test   $0x4,%al
  801a79:	74 2b                	je     801aa6 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801a7b:	41 89 c1             	mov    %eax,%r9d
  801a7e:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a84:	4c 89 f1             	mov    %r14,%rcx
  801a87:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8c:	48 89 de             	mov    %rbx,%rsi
  801a8f:	bf 00 00 00 00       	mov    $0x0,%edi
  801a94:	48 b8 32 14 80 00 00 	movabs $0x801432,%rax
  801a9b:	00 00 00 
  801a9e:	ff d0                	call   *%rax
  801aa0:	89 c3                	mov    %eax,%ebx
  801aa2:	85 c0                	test   %eax,%eax
  801aa4:	78 4e                	js     801af4 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801aa6:	4c 89 ff             	mov    %r15,%rdi
  801aa9:	48 b8 d8 2a 80 00 00 	movabs $0x802ad8,%rax
  801ab0:	00 00 00 
  801ab3:	ff d0                	call   *%rax
  801ab5:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801ab8:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801abe:	4c 89 e9             	mov    %r13,%rcx
  801ac1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac6:	4c 89 fe             	mov    %r15,%rsi
  801ac9:	bf 00 00 00 00       	mov    $0x0,%edi
  801ace:	48 b8 32 14 80 00 00 	movabs $0x801432,%rax
  801ad5:	00 00 00 
  801ad8:	ff d0                	call   *%rax
  801ada:	89 c3                	mov    %eax,%ebx
  801adc:	85 c0                	test   %eax,%eax
  801ade:	78 14                	js     801af4 <dup+0xfb>

    return newfdnum;
  801ae0:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801ae3:	89 d8                	mov    %ebx,%eax
  801ae5:	48 83 c4 18          	add    $0x18,%rsp
  801ae9:	5b                   	pop    %rbx
  801aea:	41 5c                	pop    %r12
  801aec:	41 5d                	pop    %r13
  801aee:	41 5e                	pop    %r14
  801af0:	41 5f                	pop    %r15
  801af2:	5d                   	pop    %rbp
  801af3:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801af4:	ba 00 10 00 00       	mov    $0x1000,%edx
  801af9:	4c 89 ee             	mov    %r13,%rsi
  801afc:	bf 00 00 00 00       	mov    $0x0,%edi
  801b01:	49 bc 07 15 80 00 00 	movabs $0x801507,%r12
  801b08:	00 00 00 
  801b0b:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801b0e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b13:	4c 89 f6             	mov    %r14,%rsi
  801b16:	bf 00 00 00 00       	mov    $0x0,%edi
  801b1b:	41 ff d4             	call   *%r12
    return res;
  801b1e:	eb c3                	jmp    801ae3 <dup+0xea>

0000000000801b20 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801b20:	f3 0f 1e fa          	endbr64
  801b24:	55                   	push   %rbp
  801b25:	48 89 e5             	mov    %rsp,%rbp
  801b28:	41 56                	push   %r14
  801b2a:	41 55                	push   %r13
  801b2c:	41 54                	push   %r12
  801b2e:	53                   	push   %rbx
  801b2f:	48 83 ec 10          	sub    $0x10,%rsp
  801b33:	89 fb                	mov    %edi,%ebx
  801b35:	49 89 f4             	mov    %rsi,%r12
  801b38:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b3b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b3f:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  801b46:	00 00 00 
  801b49:	ff d0                	call   *%rax
  801b4b:	85 c0                	test   %eax,%eax
  801b4d:	78 4c                	js     801b9b <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b4f:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801b53:	41 8b 3e             	mov    (%r14),%edi
  801b56:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b5a:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  801b61:	00 00 00 
  801b64:	ff d0                	call   *%rax
  801b66:	85 c0                	test   %eax,%eax
  801b68:	78 35                	js     801b9f <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b6a:	41 8b 46 08          	mov    0x8(%r14),%eax
  801b6e:	83 e0 03             	and    $0x3,%eax
  801b71:	83 f8 01             	cmp    $0x1,%eax
  801b74:	74 2d                	je     801ba3 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801b76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b7a:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b7e:	48 85 c0             	test   %rax,%rax
  801b81:	74 56                	je     801bd9 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801b83:	4c 89 ea             	mov    %r13,%rdx
  801b86:	4c 89 e6             	mov    %r12,%rsi
  801b89:	4c 89 f7             	mov    %r14,%rdi
  801b8c:	ff d0                	call   *%rax
}
  801b8e:	48 83 c4 10          	add    $0x10,%rsp
  801b92:	5b                   	pop    %rbx
  801b93:	41 5c                	pop    %r12
  801b95:	41 5d                	pop    %r13
  801b97:	41 5e                	pop    %r14
  801b99:	5d                   	pop    %rbp
  801b9a:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b9b:	48 98                	cltq
  801b9d:	eb ef                	jmp    801b8e <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b9f:	48 98                	cltq
  801ba1:	eb eb                	jmp    801b8e <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ba3:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  801baa:	00 00 00 
  801bad:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801bb3:	89 da                	mov    %ebx,%edx
  801bb5:	48 bf 05 42 80 00 00 	movabs $0x804205,%rdi
  801bbc:	00 00 00 
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc4:	48 b9 79 04 80 00 00 	movabs $0x800479,%rcx
  801bcb:	00 00 00 
  801bce:	ff d1                	call   *%rcx
        return -E_INVAL;
  801bd0:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801bd7:	eb b5                	jmp    801b8e <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801bd9:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801be0:	eb ac                	jmp    801b8e <read+0x6e>

0000000000801be2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801be2:	f3 0f 1e fa          	endbr64
  801be6:	55                   	push   %rbp
  801be7:	48 89 e5             	mov    %rsp,%rbp
  801bea:	41 57                	push   %r15
  801bec:	41 56                	push   %r14
  801bee:	41 55                	push   %r13
  801bf0:	41 54                	push   %r12
  801bf2:	53                   	push   %rbx
  801bf3:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801bf7:	48 85 d2             	test   %rdx,%rdx
  801bfa:	74 54                	je     801c50 <readn+0x6e>
  801bfc:	41 89 fd             	mov    %edi,%r13d
  801bff:	49 89 f6             	mov    %rsi,%r14
  801c02:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801c05:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801c0a:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801c0f:	49 bf 20 1b 80 00 00 	movabs $0x801b20,%r15
  801c16:	00 00 00 
  801c19:	4c 89 e2             	mov    %r12,%rdx
  801c1c:	48 29 f2             	sub    %rsi,%rdx
  801c1f:	4c 01 f6             	add    %r14,%rsi
  801c22:	44 89 ef             	mov    %r13d,%edi
  801c25:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801c28:	85 c0                	test   %eax,%eax
  801c2a:	78 20                	js     801c4c <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801c2c:	01 c3                	add    %eax,%ebx
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	74 08                	je     801c3a <readn+0x58>
  801c32:	48 63 f3             	movslq %ebx,%rsi
  801c35:	4c 39 e6             	cmp    %r12,%rsi
  801c38:	72 df                	jb     801c19 <readn+0x37>
    }
    return res;
  801c3a:	48 63 c3             	movslq %ebx,%rax
}
  801c3d:	48 83 c4 08          	add    $0x8,%rsp
  801c41:	5b                   	pop    %rbx
  801c42:	41 5c                	pop    %r12
  801c44:	41 5d                	pop    %r13
  801c46:	41 5e                	pop    %r14
  801c48:	41 5f                	pop    %r15
  801c4a:	5d                   	pop    %rbp
  801c4b:	c3                   	ret
        if (inc < 0) return inc;
  801c4c:	48 98                	cltq
  801c4e:	eb ed                	jmp    801c3d <readn+0x5b>
    int inc = 1, res = 0;
  801c50:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c55:	eb e3                	jmp    801c3a <readn+0x58>

0000000000801c57 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801c57:	f3 0f 1e fa          	endbr64
  801c5b:	55                   	push   %rbp
  801c5c:	48 89 e5             	mov    %rsp,%rbp
  801c5f:	41 56                	push   %r14
  801c61:	41 55                	push   %r13
  801c63:	41 54                	push   %r12
  801c65:	53                   	push   %rbx
  801c66:	48 83 ec 10          	sub    $0x10,%rsp
  801c6a:	89 fb                	mov    %edi,%ebx
  801c6c:	49 89 f4             	mov    %rsi,%r12
  801c6f:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c72:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c76:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  801c7d:	00 00 00 
  801c80:	ff d0                	call   *%rax
  801c82:	85 c0                	test   %eax,%eax
  801c84:	78 47                	js     801ccd <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c86:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801c8a:	41 8b 3e             	mov    (%r14),%edi
  801c8d:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c91:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  801c98:	00 00 00 
  801c9b:	ff d0                	call   *%rax
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	78 30                	js     801cd1 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ca1:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801ca6:	74 2d                	je     801cd5 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801ca8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cac:	48 8b 40 18          	mov    0x18(%rax),%rax
  801cb0:	48 85 c0             	test   %rax,%rax
  801cb3:	74 56                	je     801d0b <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801cb5:	4c 89 ea             	mov    %r13,%rdx
  801cb8:	4c 89 e6             	mov    %r12,%rsi
  801cbb:	4c 89 f7             	mov    %r14,%rdi
  801cbe:	ff d0                	call   *%rax
}
  801cc0:	48 83 c4 10          	add    $0x10,%rsp
  801cc4:	5b                   	pop    %rbx
  801cc5:	41 5c                	pop    %r12
  801cc7:	41 5d                	pop    %r13
  801cc9:	41 5e                	pop    %r14
  801ccb:	5d                   	pop    %rbp
  801ccc:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ccd:	48 98                	cltq
  801ccf:	eb ef                	jmp    801cc0 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cd1:	48 98                	cltq
  801cd3:	eb eb                	jmp    801cc0 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801cd5:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  801cdc:	00 00 00 
  801cdf:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ce5:	89 da                	mov    %ebx,%edx
  801ce7:	48 bf 21 42 80 00 00 	movabs $0x804221,%rdi
  801cee:	00 00 00 
  801cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf6:	48 b9 79 04 80 00 00 	movabs $0x800479,%rcx
  801cfd:	00 00 00 
  801d00:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d02:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801d09:	eb b5                	jmp    801cc0 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801d0b:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801d12:	eb ac                	jmp    801cc0 <write+0x69>

0000000000801d14 <seek>:

int
seek(int fdnum, off_t offset) {
  801d14:	f3 0f 1e fa          	endbr64
  801d18:	55                   	push   %rbp
  801d19:	48 89 e5             	mov    %rsp,%rbp
  801d1c:	53                   	push   %rbx
  801d1d:	48 83 ec 18          	sub    $0x18,%rsp
  801d21:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d23:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801d27:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  801d2e:	00 00 00 
  801d31:	ff d0                	call   *%rax
  801d33:	85 c0                	test   %eax,%eax
  801d35:	78 0c                	js     801d43 <seek+0x2f>

    fd->fd_offset = offset;
  801d37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3b:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d43:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d47:	c9                   	leave
  801d48:	c3                   	ret

0000000000801d49 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801d49:	f3 0f 1e fa          	endbr64
  801d4d:	55                   	push   %rbp
  801d4e:	48 89 e5             	mov    %rsp,%rbp
  801d51:	41 55                	push   %r13
  801d53:	41 54                	push   %r12
  801d55:	53                   	push   %rbx
  801d56:	48 83 ec 18          	sub    $0x18,%rsp
  801d5a:	89 fb                	mov    %edi,%ebx
  801d5c:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d5f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d63:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  801d6a:	00 00 00 
  801d6d:	ff d0                	call   *%rax
  801d6f:	85 c0                	test   %eax,%eax
  801d71:	78 38                	js     801dab <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d73:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801d77:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801d7b:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d7f:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  801d86:	00 00 00 
  801d89:	ff d0                	call   *%rax
  801d8b:	85 c0                	test   %eax,%eax
  801d8d:	78 1c                	js     801dab <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d8f:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801d94:	74 20                	je     801db6 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d9a:	48 8b 40 30          	mov    0x30(%rax),%rax
  801d9e:	48 85 c0             	test   %rax,%rax
  801da1:	74 47                	je     801dea <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801da3:	44 89 e6             	mov    %r12d,%esi
  801da6:	4c 89 ef             	mov    %r13,%rdi
  801da9:	ff d0                	call   *%rax
}
  801dab:	48 83 c4 18          	add    $0x18,%rsp
  801daf:	5b                   	pop    %rbx
  801db0:	41 5c                	pop    %r12
  801db2:	41 5d                	pop    %r13
  801db4:	5d                   	pop    %rbp
  801db5:	c3                   	ret
                thisenv->env_id, fdnum);
  801db6:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  801dbd:	00 00 00 
  801dc0:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801dc6:	89 da                	mov    %ebx,%edx
  801dc8:	48 bf 40 43 80 00 00 	movabs $0x804340,%rdi
  801dcf:	00 00 00 
  801dd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd7:	48 b9 79 04 80 00 00 	movabs $0x800479,%rcx
  801dde:	00 00 00 
  801de1:	ff d1                	call   *%rcx
        return -E_INVAL;
  801de3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801de8:	eb c1                	jmp    801dab <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801dea:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801def:	eb ba                	jmp    801dab <ftruncate+0x62>

0000000000801df1 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801df1:	f3 0f 1e fa          	endbr64
  801df5:	55                   	push   %rbp
  801df6:	48 89 e5             	mov    %rsp,%rbp
  801df9:	41 54                	push   %r12
  801dfb:	53                   	push   %rbx
  801dfc:	48 83 ec 10          	sub    $0x10,%rsp
  801e00:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e03:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801e07:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  801e0e:	00 00 00 
  801e11:	ff d0                	call   *%rax
  801e13:	85 c0                	test   %eax,%eax
  801e15:	78 4e                	js     801e65 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e17:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801e1b:	41 8b 3c 24          	mov    (%r12),%edi
  801e1f:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801e23:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  801e2a:	00 00 00 
  801e2d:	ff d0                	call   *%rax
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	78 32                	js     801e65 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801e33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e37:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801e3c:	74 30                	je     801e6e <fstat+0x7d>

    stat->st_name[0] = 0;
  801e3e:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801e41:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801e48:	00 00 00 
    stat->st_isdir = 0;
  801e4b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801e52:	00 00 00 
    stat->st_dev = dev;
  801e55:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801e5c:	48 89 de             	mov    %rbx,%rsi
  801e5f:	4c 89 e7             	mov    %r12,%rdi
  801e62:	ff 50 28             	call   *0x28(%rax)
}
  801e65:	48 83 c4 10          	add    $0x10,%rsp
  801e69:	5b                   	pop    %rbx
  801e6a:	41 5c                	pop    %r12
  801e6c:	5d                   	pop    %rbp
  801e6d:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801e6e:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801e73:	eb f0                	jmp    801e65 <fstat+0x74>

0000000000801e75 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801e75:	f3 0f 1e fa          	endbr64
  801e79:	55                   	push   %rbp
  801e7a:	48 89 e5             	mov    %rsp,%rbp
  801e7d:	41 54                	push   %r12
  801e7f:	53                   	push   %rbx
  801e80:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801e83:	be 00 00 00 00       	mov    $0x0,%esi
  801e88:	48 b8 56 21 80 00 00 	movabs $0x802156,%rax
  801e8f:	00 00 00 
  801e92:	ff d0                	call   *%rax
  801e94:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801e96:	85 c0                	test   %eax,%eax
  801e98:	78 25                	js     801ebf <stat+0x4a>

    int res = fstat(fd, stat);
  801e9a:	4c 89 e6             	mov    %r12,%rsi
  801e9d:	89 c7                	mov    %eax,%edi
  801e9f:	48 b8 f1 1d 80 00 00 	movabs $0x801df1,%rax
  801ea6:	00 00 00 
  801ea9:	ff d0                	call   *%rax
  801eab:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801eae:	89 df                	mov    %ebx,%edi
  801eb0:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  801eb7:	00 00 00 
  801eba:	ff d0                	call   *%rax

    return res;
  801ebc:	44 89 e3             	mov    %r12d,%ebx
}
  801ebf:	89 d8                	mov    %ebx,%eax
  801ec1:	5b                   	pop    %rbx
  801ec2:	41 5c                	pop    %r12
  801ec4:	5d                   	pop    %rbp
  801ec5:	c3                   	ret

0000000000801ec6 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801ec6:	f3 0f 1e fa          	endbr64
  801eca:	55                   	push   %rbp
  801ecb:	48 89 e5             	mov    %rsp,%rbp
  801ece:	41 54                	push   %r12
  801ed0:	53                   	push   %rbx
  801ed1:	48 83 ec 10          	sub    $0x10,%rsp
  801ed5:	41 89 fc             	mov    %edi,%r12d
  801ed8:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801edb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801ee2:	00 00 00 
  801ee5:	83 38 00             	cmpl   $0x0,(%rax)
  801ee8:	74 6e                	je     801f58 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801eea:	bf 03 00 00 00       	mov    $0x3,%edi
  801eef:	48 b8 05 30 80 00 00 	movabs $0x803005,%rax
  801ef6:	00 00 00 
  801ef9:	ff d0                	call   *%rax
  801efb:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801f02:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801f04:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801f0a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801f0f:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  801f16:	00 00 00 
  801f19:	44 89 e6             	mov    %r12d,%esi
  801f1c:	89 c7                	mov    %eax,%edi
  801f1e:	48 b8 43 2f 80 00 00 	movabs $0x802f43,%rax
  801f25:	00 00 00 
  801f28:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801f2a:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801f31:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801f32:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f37:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f3b:	48 89 de             	mov    %rbx,%rsi
  801f3e:	bf 00 00 00 00       	mov    $0x0,%edi
  801f43:	48 b8 aa 2e 80 00 00 	movabs $0x802eaa,%rax
  801f4a:	00 00 00 
  801f4d:	ff d0                	call   *%rax
}
  801f4f:	48 83 c4 10          	add    $0x10,%rsp
  801f53:	5b                   	pop    %rbx
  801f54:	41 5c                	pop    %r12
  801f56:	5d                   	pop    %rbp
  801f57:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801f58:	bf 03 00 00 00       	mov    $0x3,%edi
  801f5d:	48 b8 05 30 80 00 00 	movabs $0x803005,%rax
  801f64:	00 00 00 
  801f67:	ff d0                	call   *%rax
  801f69:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801f70:	00 00 
  801f72:	e9 73 ff ff ff       	jmp    801eea <fsipc+0x24>

0000000000801f77 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801f77:	f3 0f 1e fa          	endbr64
  801f7b:	55                   	push   %rbp
  801f7c:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f7f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801f86:	00 00 00 
  801f89:	8b 57 0c             	mov    0xc(%rdi),%edx
  801f8c:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801f8e:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801f91:	be 00 00 00 00       	mov    $0x0,%esi
  801f96:	bf 02 00 00 00       	mov    $0x2,%edi
  801f9b:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  801fa2:	00 00 00 
  801fa5:	ff d0                	call   *%rax
}
  801fa7:	5d                   	pop    %rbp
  801fa8:	c3                   	ret

0000000000801fa9 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801fa9:	f3 0f 1e fa          	endbr64
  801fad:	55                   	push   %rbp
  801fae:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801fb1:	8b 47 0c             	mov    0xc(%rdi),%eax
  801fb4:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801fbb:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801fbd:	be 00 00 00 00       	mov    $0x0,%esi
  801fc2:	bf 06 00 00 00       	mov    $0x6,%edi
  801fc7:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  801fce:	00 00 00 
  801fd1:	ff d0                	call   *%rax
}
  801fd3:	5d                   	pop    %rbp
  801fd4:	c3                   	ret

0000000000801fd5 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801fd5:	f3 0f 1e fa          	endbr64
  801fd9:	55                   	push   %rbp
  801fda:	48 89 e5             	mov    %rsp,%rbp
  801fdd:	41 54                	push   %r12
  801fdf:	53                   	push   %rbx
  801fe0:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801fe3:	8b 47 0c             	mov    0xc(%rdi),%eax
  801fe6:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801fed:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801fef:	be 00 00 00 00       	mov    $0x0,%esi
  801ff4:	bf 05 00 00 00       	mov    $0x5,%edi
  801ff9:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  802000:	00 00 00 
  802003:	ff d0                	call   *%rax
    if (res < 0) return res;
  802005:	85 c0                	test   %eax,%eax
  802007:	78 3d                	js     802046 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802009:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  802010:	00 00 00 
  802013:	4c 89 e6             	mov    %r12,%rsi
  802016:	48 89 df             	mov    %rbx,%rdi
  802019:	48 b8 c2 0d 80 00 00 	movabs $0x800dc2,%rax
  802020:	00 00 00 
  802023:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  802025:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  80202c:	00 
  80202d:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802033:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  80203a:	00 
  80203b:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802046:	5b                   	pop    %rbx
  802047:	41 5c                	pop    %r12
  802049:	5d                   	pop    %rbp
  80204a:	c3                   	ret

000000000080204b <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  80204b:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  80204f:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  802056:	77 41                	ja     802099 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802058:	55                   	push   %rbp
  802059:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80205c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802063:	00 00 00 
  802066:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802069:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  80206b:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  80206f:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802073:	48 b8 dd 0f 80 00 00 	movabs $0x800fdd,%rax
  80207a:	00 00 00 
  80207d:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  80207f:	be 00 00 00 00       	mov    $0x0,%esi
  802084:	bf 04 00 00 00       	mov    $0x4,%edi
  802089:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  802090:	00 00 00 
  802093:	ff d0                	call   *%rax
  802095:	48 98                	cltq
}
  802097:	5d                   	pop    %rbp
  802098:	c3                   	ret
        return -E_INVAL;
  802099:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  8020a0:	c3                   	ret

00000000008020a1 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  8020a1:	f3 0f 1e fa          	endbr64
  8020a5:	55                   	push   %rbp
  8020a6:	48 89 e5             	mov    %rsp,%rbp
  8020a9:	41 55                	push   %r13
  8020ab:	41 54                	push   %r12
  8020ad:	53                   	push   %rbx
  8020ae:	48 83 ec 08          	sub    $0x8,%rsp
  8020b2:	49 89 f4             	mov    %rsi,%r12
  8020b5:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  8020b8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8020bf:	00 00 00 
  8020c2:	8b 57 0c             	mov    0xc(%rdi),%edx
  8020c5:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  8020c7:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  8020cb:	be 00 00 00 00       	mov    $0x0,%esi
  8020d0:	bf 03 00 00 00       	mov    $0x3,%edi
  8020d5:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  8020dc:	00 00 00 
  8020df:	ff d0                	call   *%rax
  8020e1:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  8020e4:	4d 85 ed             	test   %r13,%r13
  8020e7:	78 2a                	js     802113 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  8020e9:	4c 89 ea             	mov    %r13,%rdx
  8020ec:	4c 39 eb             	cmp    %r13,%rbx
  8020ef:	72 30                	jb     802121 <devfile_read+0x80>
  8020f1:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  8020f8:	7f 27                	jg     802121 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  8020fa:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802101:	00 00 00 
  802104:	4c 89 e7             	mov    %r12,%rdi
  802107:	48 b8 dd 0f 80 00 00 	movabs $0x800fdd,%rax
  80210e:	00 00 00 
  802111:	ff d0                	call   *%rax
}
  802113:	4c 89 e8             	mov    %r13,%rax
  802116:	48 83 c4 08          	add    $0x8,%rsp
  80211a:	5b                   	pop    %rbx
  80211b:	41 5c                	pop    %r12
  80211d:	41 5d                	pop    %r13
  80211f:	5d                   	pop    %rbp
  802120:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  802121:	48 b9 3e 42 80 00 00 	movabs $0x80423e,%rcx
  802128:	00 00 00 
  80212b:	48 ba 5b 42 80 00 00 	movabs $0x80425b,%rdx
  802132:	00 00 00 
  802135:	be 7b 00 00 00       	mov    $0x7b,%esi
  80213a:	48 bf 70 42 80 00 00 	movabs $0x804270,%rdi
  802141:	00 00 00 
  802144:	b8 00 00 00 00       	mov    $0x0,%eax
  802149:	49 b8 1d 03 80 00 00 	movabs $0x80031d,%r8
  802150:	00 00 00 
  802153:	41 ff d0             	call   *%r8

0000000000802156 <open>:
open(const char *path, int mode) {
  802156:	f3 0f 1e fa          	endbr64
  80215a:	55                   	push   %rbp
  80215b:	48 89 e5             	mov    %rsp,%rbp
  80215e:	41 55                	push   %r13
  802160:	41 54                	push   %r12
  802162:	53                   	push   %rbx
  802163:	48 83 ec 18          	sub    $0x18,%rsp
  802167:	49 89 fc             	mov    %rdi,%r12
  80216a:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  80216d:	48 b8 7d 0d 80 00 00 	movabs $0x800d7d,%rax
  802174:	00 00 00 
  802177:	ff d0                	call   *%rax
  802179:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80217f:	0f 87 8a 00 00 00    	ja     80220f <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802185:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802189:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  802190:	00 00 00 
  802193:	ff d0                	call   *%rax
  802195:	89 c3                	mov    %eax,%ebx
  802197:	85 c0                	test   %eax,%eax
  802199:	78 50                	js     8021eb <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80219b:	4c 89 e6             	mov    %r12,%rsi
  80219e:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  8021a5:	00 00 00 
  8021a8:	48 89 df             	mov    %rbx,%rdi
  8021ab:	48 b8 c2 0d 80 00 00 	movabs $0x800dc2,%rax
  8021b2:	00 00 00 
  8021b5:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8021b7:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8021be:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8021c2:	bf 01 00 00 00       	mov    $0x1,%edi
  8021c7:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  8021ce:	00 00 00 
  8021d1:	ff d0                	call   *%rax
  8021d3:	89 c3                	mov    %eax,%ebx
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	78 1f                	js     8021f8 <open+0xa2>
    return fd2num(fd);
  8021d9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8021dd:	48 b8 8b 17 80 00 00 	movabs $0x80178b,%rax
  8021e4:	00 00 00 
  8021e7:	ff d0                	call   *%rax
  8021e9:	89 c3                	mov    %eax,%ebx
}
  8021eb:	89 d8                	mov    %ebx,%eax
  8021ed:	48 83 c4 18          	add    $0x18,%rsp
  8021f1:	5b                   	pop    %rbx
  8021f2:	41 5c                	pop    %r12
  8021f4:	41 5d                	pop    %r13
  8021f6:	5d                   	pop    %rbp
  8021f7:	c3                   	ret
        fd_close(fd, 0);
  8021f8:	be 00 00 00 00       	mov    $0x0,%esi
  8021fd:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802201:	48 b8 e8 18 80 00 00 	movabs $0x8018e8,%rax
  802208:	00 00 00 
  80220b:	ff d0                	call   *%rax
        return res;
  80220d:	eb dc                	jmp    8021eb <open+0x95>
        return -E_BAD_PATH;
  80220f:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802214:	eb d5                	jmp    8021eb <open+0x95>

0000000000802216 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802216:	f3 0f 1e fa          	endbr64
  80221a:	55                   	push   %rbp
  80221b:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80221e:	be 00 00 00 00       	mov    $0x0,%esi
  802223:	bf 08 00 00 00       	mov    $0x8,%edi
  802228:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  80222f:	00 00 00 
  802232:	ff d0                	call   *%rax
}
  802234:	5d                   	pop    %rbp
  802235:	c3                   	ret

0000000000802236 <writebuf>:
    int error;      /* First error that occurred */
    char buf[PRINTBUFSZ];
};

static void
writebuf(struct printbuf *state) {
  802236:	f3 0f 1e fa          	endbr64
    if (state->error > 0) {
  80223a:	83 7f 10 00          	cmpl   $0x0,0x10(%rdi)
  80223e:	7f 01                	jg     802241 <writebuf+0xb>
  802240:	c3                   	ret
writebuf(struct printbuf *state) {
  802241:	55                   	push   %rbp
  802242:	48 89 e5             	mov    %rsp,%rbp
  802245:	53                   	push   %rbx
  802246:	48 83 ec 08          	sub    $0x8,%rsp
  80224a:	48 89 fb             	mov    %rdi,%rbx
        ssize_t result = write(state->fd, state->buf, state->offset);
  80224d:	48 63 57 04          	movslq 0x4(%rdi),%rdx
  802251:	48 8d 77 14          	lea    0x14(%rdi),%rsi
  802255:	8b 3f                	mov    (%rdi),%edi
  802257:	48 b8 57 1c 80 00 00 	movabs $0x801c57,%rax
  80225e:	00 00 00 
  802261:	ff d0                	call   *%rax
        if (result > 0) state->result += result;
  802263:	48 85 c0             	test   %rax,%rax
  802266:	7e 04                	jle    80226c <writebuf+0x36>
  802268:	48 01 43 08          	add    %rax,0x8(%rbx)

        /* Error, or wrote less than supplied */
        if (result != state->offset)
  80226c:	48 63 53 04          	movslq 0x4(%rbx),%rdx
  802270:	48 39 c2             	cmp    %rax,%rdx
  802273:	74 0f                	je     802284 <writebuf+0x4e>
            state->error = MIN(0, result);
  802275:	48 85 c0             	test   %rax,%rax
  802278:	ba 00 00 00 00       	mov    $0x0,%edx
  80227d:	48 0f 4f c2          	cmovg  %rdx,%rax
  802281:	89 43 10             	mov    %eax,0x10(%rbx)
    }
}
  802284:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802288:	c9                   	leave
  802289:	c3                   	ret

000000000080228a <putch>:

static void
putch(int ch, void *arg) {
  80228a:	f3 0f 1e fa          	endbr64
    struct printbuf *state = (struct printbuf *)arg;
    state->buf[state->offset++] = ch;
  80228e:	8b 46 04             	mov    0x4(%rsi),%eax
  802291:	8d 50 01             	lea    0x1(%rax),%edx
  802294:	89 56 04             	mov    %edx,0x4(%rsi)
  802297:	48 98                	cltq
  802299:	40 88 7c 06 14       	mov    %dil,0x14(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ) {
  80229e:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  8022a4:	74 01                	je     8022a7 <putch+0x1d>
  8022a6:	c3                   	ret
putch(int ch, void *arg) {
  8022a7:	55                   	push   %rbp
  8022a8:	48 89 e5             	mov    %rsp,%rbp
  8022ab:	53                   	push   %rbx
  8022ac:	48 83 ec 08          	sub    $0x8,%rsp
  8022b0:	48 89 f3             	mov    %rsi,%rbx
        writebuf(state);
  8022b3:	48 89 f7             	mov    %rsi,%rdi
  8022b6:	48 b8 36 22 80 00 00 	movabs $0x802236,%rax
  8022bd:	00 00 00 
  8022c0:	ff d0                	call   *%rax
        state->offset = 0;
  8022c2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
    }
}
  8022c9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8022cd:	c9                   	leave
  8022ce:	c3                   	ret

00000000008022cf <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  8022cf:	f3 0f 1e fa          	endbr64
  8022d3:	55                   	push   %rbp
  8022d4:	48 89 e5             	mov    %rsp,%rbp
  8022d7:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  8022de:	48 89 d1             	mov    %rdx,%rcx
    struct printbuf state;
    state.fd = fd;
  8022e1:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%rbp)
    state.offset = 0;
  8022e7:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%rbp)
  8022ee:	00 00 00 
    state.result = 0;
  8022f1:	48 c7 85 f0 fe ff ff 	movq   $0x0,-0x110(%rbp)
  8022f8:	00 00 00 00 
    state.error = 1;
  8022fc:	c7 85 f8 fe ff ff 01 	movl   $0x1,-0x108(%rbp)
  802303:	00 00 00 

    vprintfmt(putch, &state, fmt, ap);
  802306:	48 89 f2             	mov    %rsi,%rdx
  802309:	48 8d b5 e8 fe ff ff 	lea    -0x118(%rbp),%rsi
  802310:	48 bf 8a 22 80 00 00 	movabs $0x80228a,%rdi
  802317:	00 00 00 
  80231a:	48 b8 d9 05 80 00 00 	movabs $0x8005d9,%rax
  802321:	00 00 00 
  802324:	ff d0                	call   *%rax
    if (state.offset > 0) writebuf(&state);
  802326:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%rbp)
  80232d:	7f 14                	jg     802343 <vfprintf+0x74>

    return (state.result ? state.result : state.error);
  80232f:	48 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%rax
  802336:	48 85 c0             	test   %rax,%rax
  802339:	75 06                	jne    802341 <vfprintf+0x72>
  80233b:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
}
  802341:	c9                   	leave
  802342:	c3                   	ret
    if (state.offset > 0) writebuf(&state);
  802343:	48 8d bd e8 fe ff ff 	lea    -0x118(%rbp),%rdi
  80234a:	48 b8 36 22 80 00 00 	movabs $0x802236,%rax
  802351:	00 00 00 
  802354:	ff d0                	call   *%rax
  802356:	eb d7                	jmp    80232f <vfprintf+0x60>

0000000000802358 <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  802358:	f3 0f 1e fa          	endbr64
  80235c:	55                   	push   %rbp
  80235d:	48 89 e5             	mov    %rsp,%rbp
  802360:	48 83 ec 50          	sub    $0x50,%rsp
  802364:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802368:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80236c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802370:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  802374:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  80237b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80237f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802383:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802387:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(fd, fmt, ap);
  80238b:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  80238f:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  802396:	00 00 00 
  802399:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  80239b:	c9                   	leave
  80239c:	c3                   	ret

000000000080239d <printf>:

int
printf(const char *fmt, ...) {
  80239d:	f3 0f 1e fa          	endbr64
  8023a1:	55                   	push   %rbp
  8023a2:	48 89 e5             	mov    %rsp,%rbp
  8023a5:	48 83 ec 50          	sub    $0x50,%rsp
  8023a9:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8023ad:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8023b1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8023b5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8023b9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  8023bd:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8023c4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8023c8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023cc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8023d0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(1, fmt, ap);
  8023d4:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  8023d8:	48 89 fe             	mov    %rdi,%rsi
  8023db:	bf 01 00 00 00       	mov    $0x1,%edi
  8023e0:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  8023e7:	00 00 00 
  8023ea:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  8023ec:	c9                   	leave
  8023ed:	c3                   	ret

00000000008023ee <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8023ee:	f3 0f 1e fa          	endbr64
  8023f2:	55                   	push   %rbp
  8023f3:	48 89 e5             	mov    %rsp,%rbp
  8023f6:	41 54                	push   %r12
  8023f8:	53                   	push   %rbx
  8023f9:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8023fc:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  802403:	00 00 00 
  802406:	ff d0                	call   *%rax
  802408:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80240b:	48 be 7b 42 80 00 00 	movabs $0x80427b,%rsi
  802412:	00 00 00 
  802415:	48 89 df             	mov    %rbx,%rdi
  802418:	48 b8 c2 0d 80 00 00 	movabs $0x800dc2,%rax
  80241f:	00 00 00 
  802422:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802424:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802429:	41 2b 04 24          	sub    (%r12),%eax
  80242d:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802433:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80243a:	00 00 00 
    stat->st_dev = &devpipe;
  80243d:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802444:	00 00 00 
  802447:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80244e:	b8 00 00 00 00       	mov    $0x0,%eax
  802453:	5b                   	pop    %rbx
  802454:	41 5c                	pop    %r12
  802456:	5d                   	pop    %rbp
  802457:	c3                   	ret

0000000000802458 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802458:	f3 0f 1e fa          	endbr64
  80245c:	55                   	push   %rbp
  80245d:	48 89 e5             	mov    %rsp,%rbp
  802460:	41 54                	push   %r12
  802462:	53                   	push   %rbx
  802463:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802466:	ba 00 10 00 00       	mov    $0x1000,%edx
  80246b:	48 89 fe             	mov    %rdi,%rsi
  80246e:	bf 00 00 00 00       	mov    $0x0,%edi
  802473:	49 bc 07 15 80 00 00 	movabs $0x801507,%r12
  80247a:	00 00 00 
  80247d:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802480:	48 89 df             	mov    %rbx,%rdi
  802483:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  80248a:	00 00 00 
  80248d:	ff d0                	call   *%rax
  80248f:	48 89 c6             	mov    %rax,%rsi
  802492:	ba 00 10 00 00       	mov    $0x1000,%edx
  802497:	bf 00 00 00 00       	mov    $0x0,%edi
  80249c:	41 ff d4             	call   *%r12
}
  80249f:	5b                   	pop    %rbx
  8024a0:	41 5c                	pop    %r12
  8024a2:	5d                   	pop    %rbp
  8024a3:	c3                   	ret

00000000008024a4 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8024a4:	f3 0f 1e fa          	endbr64
  8024a8:	55                   	push   %rbp
  8024a9:	48 89 e5             	mov    %rsp,%rbp
  8024ac:	41 57                	push   %r15
  8024ae:	41 56                	push   %r14
  8024b0:	41 55                	push   %r13
  8024b2:	41 54                	push   %r12
  8024b4:	53                   	push   %rbx
  8024b5:	48 83 ec 18          	sub    $0x18,%rsp
  8024b9:	49 89 fc             	mov    %rdi,%r12
  8024bc:	49 89 f5             	mov    %rsi,%r13
  8024bf:	49 89 d7             	mov    %rdx,%r15
  8024c2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8024c6:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  8024cd:	00 00 00 
  8024d0:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8024d2:	4d 85 ff             	test   %r15,%r15
  8024d5:	0f 84 af 00 00 00    	je     80258a <devpipe_write+0xe6>
  8024db:	48 89 c3             	mov    %rax,%rbx
  8024de:	4c 89 f8             	mov    %r15,%rax
  8024e1:	4d 89 ef             	mov    %r13,%r15
  8024e4:	4c 01 e8             	add    %r13,%rax
  8024e7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024eb:	49 bd 97 13 80 00 00 	movabs $0x801397,%r13
  8024f2:	00 00 00 
            sys_yield();
  8024f5:	49 be 2c 13 80 00 00 	movabs $0x80132c,%r14
  8024fc:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8024ff:	8b 73 04             	mov    0x4(%rbx),%esi
  802502:	48 63 ce             	movslq %esi,%rcx
  802505:	48 63 03             	movslq (%rbx),%rax
  802508:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80250e:	48 39 c1             	cmp    %rax,%rcx
  802511:	72 2e                	jb     802541 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802513:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802518:	48 89 da             	mov    %rbx,%rdx
  80251b:	be 00 10 00 00       	mov    $0x1000,%esi
  802520:	4c 89 e7             	mov    %r12,%rdi
  802523:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802526:	85 c0                	test   %eax,%eax
  802528:	74 66                	je     802590 <devpipe_write+0xec>
            sys_yield();
  80252a:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80252d:	8b 73 04             	mov    0x4(%rbx),%esi
  802530:	48 63 ce             	movslq %esi,%rcx
  802533:	48 63 03             	movslq (%rbx),%rax
  802536:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80253c:	48 39 c1             	cmp    %rax,%rcx
  80253f:	73 d2                	jae    802513 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802541:	41 0f b6 3f          	movzbl (%r15),%edi
  802545:	48 89 ca             	mov    %rcx,%rdx
  802548:	48 c1 ea 03          	shr    $0x3,%rdx
  80254c:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802553:	08 10 20 
  802556:	48 f7 e2             	mul    %rdx
  802559:	48 c1 ea 06          	shr    $0x6,%rdx
  80255d:	48 89 d0             	mov    %rdx,%rax
  802560:	48 c1 e0 09          	shl    $0x9,%rax
  802564:	48 29 d0             	sub    %rdx,%rax
  802567:	48 c1 e0 03          	shl    $0x3,%rax
  80256b:	48 29 c1             	sub    %rax,%rcx
  80256e:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802573:	83 c6 01             	add    $0x1,%esi
  802576:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802579:	49 83 c7 01          	add    $0x1,%r15
  80257d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802581:	49 39 c7             	cmp    %rax,%r15
  802584:	0f 85 75 ff ff ff    	jne    8024ff <devpipe_write+0x5b>
    return n;
  80258a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80258e:	eb 05                	jmp    802595 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802590:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802595:	48 83 c4 18          	add    $0x18,%rsp
  802599:	5b                   	pop    %rbx
  80259a:	41 5c                	pop    %r12
  80259c:	41 5d                	pop    %r13
  80259e:	41 5e                	pop    %r14
  8025a0:	41 5f                	pop    %r15
  8025a2:	5d                   	pop    %rbp
  8025a3:	c3                   	ret

00000000008025a4 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8025a4:	f3 0f 1e fa          	endbr64
  8025a8:	55                   	push   %rbp
  8025a9:	48 89 e5             	mov    %rsp,%rbp
  8025ac:	41 57                	push   %r15
  8025ae:	41 56                	push   %r14
  8025b0:	41 55                	push   %r13
  8025b2:	41 54                	push   %r12
  8025b4:	53                   	push   %rbx
  8025b5:	48 83 ec 18          	sub    $0x18,%rsp
  8025b9:	49 89 fc             	mov    %rdi,%r12
  8025bc:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8025c0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8025c4:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  8025cb:	00 00 00 
  8025ce:	ff d0                	call   *%rax
  8025d0:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8025d3:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025d9:	49 bd 97 13 80 00 00 	movabs $0x801397,%r13
  8025e0:	00 00 00 
            sys_yield();
  8025e3:	49 be 2c 13 80 00 00 	movabs $0x80132c,%r14
  8025ea:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8025ed:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8025f2:	74 7d                	je     802671 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8025f4:	8b 03                	mov    (%rbx),%eax
  8025f6:	3b 43 04             	cmp    0x4(%rbx),%eax
  8025f9:	75 26                	jne    802621 <devpipe_read+0x7d>
            if (i > 0) return i;
  8025fb:	4d 85 ff             	test   %r15,%r15
  8025fe:	75 77                	jne    802677 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802600:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802605:	48 89 da             	mov    %rbx,%rdx
  802608:	be 00 10 00 00       	mov    $0x1000,%esi
  80260d:	4c 89 e7             	mov    %r12,%rdi
  802610:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802613:	85 c0                	test   %eax,%eax
  802615:	74 72                	je     802689 <devpipe_read+0xe5>
            sys_yield();
  802617:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80261a:	8b 03                	mov    (%rbx),%eax
  80261c:	3b 43 04             	cmp    0x4(%rbx),%eax
  80261f:	74 df                	je     802600 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802621:	48 63 c8             	movslq %eax,%rcx
  802624:	48 89 ca             	mov    %rcx,%rdx
  802627:	48 c1 ea 03          	shr    $0x3,%rdx
  80262b:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802632:	08 10 20 
  802635:	48 89 d0             	mov    %rdx,%rax
  802638:	48 f7 e6             	mul    %rsi
  80263b:	48 c1 ea 06          	shr    $0x6,%rdx
  80263f:	48 89 d0             	mov    %rdx,%rax
  802642:	48 c1 e0 09          	shl    $0x9,%rax
  802646:	48 29 d0             	sub    %rdx,%rax
  802649:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802650:	00 
  802651:	48 89 c8             	mov    %rcx,%rax
  802654:	48 29 d0             	sub    %rdx,%rax
  802657:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80265c:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802660:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802664:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802667:	49 83 c7 01          	add    $0x1,%r15
  80266b:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80266f:	75 83                	jne    8025f4 <devpipe_read+0x50>
    return n;
  802671:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802675:	eb 03                	jmp    80267a <devpipe_read+0xd6>
            if (i > 0) return i;
  802677:	4c 89 f8             	mov    %r15,%rax
}
  80267a:	48 83 c4 18          	add    $0x18,%rsp
  80267e:	5b                   	pop    %rbx
  80267f:	41 5c                	pop    %r12
  802681:	41 5d                	pop    %r13
  802683:	41 5e                	pop    %r14
  802685:	41 5f                	pop    %r15
  802687:	5d                   	pop    %rbp
  802688:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802689:	b8 00 00 00 00       	mov    $0x0,%eax
  80268e:	eb ea                	jmp    80267a <devpipe_read+0xd6>

0000000000802690 <pipe>:
pipe(int pfd[2]) {
  802690:	f3 0f 1e fa          	endbr64
  802694:	55                   	push   %rbp
  802695:	48 89 e5             	mov    %rsp,%rbp
  802698:	41 55                	push   %r13
  80269a:	41 54                	push   %r12
  80269c:	53                   	push   %rbx
  80269d:	48 83 ec 18          	sub    $0x18,%rsp
  8026a1:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8026a4:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8026a8:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8026af:	00 00 00 
  8026b2:	ff d0                	call   *%rax
  8026b4:	89 c3                	mov    %eax,%ebx
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	0f 88 a0 01 00 00    	js     80285e <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8026be:	b9 46 00 00 00       	mov    $0x46,%ecx
  8026c3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026c8:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8026cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d1:	48 b8 c7 13 80 00 00 	movabs $0x8013c7,%rax
  8026d8:	00 00 00 
  8026db:	ff d0                	call   *%rax
  8026dd:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8026df:	85 c0                	test   %eax,%eax
  8026e1:	0f 88 77 01 00 00    	js     80285e <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8026e7:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8026eb:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8026f2:	00 00 00 
  8026f5:	ff d0                	call   *%rax
  8026f7:	89 c3                	mov    %eax,%ebx
  8026f9:	85 c0                	test   %eax,%eax
  8026fb:	0f 88 43 01 00 00    	js     802844 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802701:	b9 46 00 00 00       	mov    $0x46,%ecx
  802706:	ba 00 10 00 00       	mov    $0x1000,%edx
  80270b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80270f:	bf 00 00 00 00       	mov    $0x0,%edi
  802714:	48 b8 c7 13 80 00 00 	movabs $0x8013c7,%rax
  80271b:	00 00 00 
  80271e:	ff d0                	call   *%rax
  802720:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802722:	85 c0                	test   %eax,%eax
  802724:	0f 88 1a 01 00 00    	js     802844 <pipe+0x1b4>
    va = fd2data(fd0);
  80272a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80272e:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  802735:	00 00 00 
  802738:	ff d0                	call   *%rax
  80273a:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80273d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802742:	ba 00 10 00 00       	mov    $0x1000,%edx
  802747:	48 89 c6             	mov    %rax,%rsi
  80274a:	bf 00 00 00 00       	mov    $0x0,%edi
  80274f:	48 b8 c7 13 80 00 00 	movabs $0x8013c7,%rax
  802756:	00 00 00 
  802759:	ff d0                	call   *%rax
  80275b:	89 c3                	mov    %eax,%ebx
  80275d:	85 c0                	test   %eax,%eax
  80275f:	0f 88 c5 00 00 00    	js     80282a <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802765:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802769:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  802770:	00 00 00 
  802773:	ff d0                	call   *%rax
  802775:	48 89 c1             	mov    %rax,%rcx
  802778:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80277e:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802784:	ba 00 00 00 00       	mov    $0x0,%edx
  802789:	4c 89 ee             	mov    %r13,%rsi
  80278c:	bf 00 00 00 00       	mov    $0x0,%edi
  802791:	48 b8 32 14 80 00 00 	movabs $0x801432,%rax
  802798:	00 00 00 
  80279b:	ff d0                	call   *%rax
  80279d:	89 c3                	mov    %eax,%ebx
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	78 6e                	js     802811 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8027a3:	be 00 10 00 00       	mov    $0x1000,%esi
  8027a8:	4c 89 ef             	mov    %r13,%rdi
  8027ab:	48 b8 61 13 80 00 00 	movabs $0x801361,%rax
  8027b2:	00 00 00 
  8027b5:	ff d0                	call   *%rax
  8027b7:	83 f8 02             	cmp    $0x2,%eax
  8027ba:	0f 85 ab 00 00 00    	jne    80286b <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8027c0:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  8027c7:	00 00 
  8027c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027cd:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8027cf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027d3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8027da:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8027de:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8027e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027e4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8027eb:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8027ef:	48 bb 8b 17 80 00 00 	movabs $0x80178b,%rbx
  8027f6:	00 00 00 
  8027f9:	ff d3                	call   *%rbx
  8027fb:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8027ff:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802803:	ff d3                	call   *%rbx
  802805:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80280a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80280f:	eb 4d                	jmp    80285e <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802811:	ba 00 10 00 00       	mov    $0x1000,%edx
  802816:	4c 89 ee             	mov    %r13,%rsi
  802819:	bf 00 00 00 00       	mov    $0x0,%edi
  80281e:	48 b8 07 15 80 00 00 	movabs $0x801507,%rax
  802825:	00 00 00 
  802828:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80282a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80282f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802833:	bf 00 00 00 00       	mov    $0x0,%edi
  802838:	48 b8 07 15 80 00 00 	movabs $0x801507,%rax
  80283f:	00 00 00 
  802842:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802844:	ba 00 10 00 00       	mov    $0x1000,%edx
  802849:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80284d:	bf 00 00 00 00       	mov    $0x0,%edi
  802852:	48 b8 07 15 80 00 00 	movabs $0x801507,%rax
  802859:	00 00 00 
  80285c:	ff d0                	call   *%rax
}
  80285e:	89 d8                	mov    %ebx,%eax
  802860:	48 83 c4 18          	add    $0x18,%rsp
  802864:	5b                   	pop    %rbx
  802865:	41 5c                	pop    %r12
  802867:	41 5d                	pop    %r13
  802869:	5d                   	pop    %rbp
  80286a:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80286b:	48 b9 68 43 80 00 00 	movabs $0x804368,%rcx
  802872:	00 00 00 
  802875:	48 ba 5b 42 80 00 00 	movabs $0x80425b,%rdx
  80287c:	00 00 00 
  80287f:	be 2e 00 00 00       	mov    $0x2e,%esi
  802884:	48 bf 82 42 80 00 00 	movabs $0x804282,%rdi
  80288b:	00 00 00 
  80288e:	b8 00 00 00 00       	mov    $0x0,%eax
  802893:	49 b8 1d 03 80 00 00 	movabs $0x80031d,%r8
  80289a:	00 00 00 
  80289d:	41 ff d0             	call   *%r8

00000000008028a0 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8028a0:	f3 0f 1e fa          	endbr64
  8028a4:	55                   	push   %rbp
  8028a5:	48 89 e5             	mov    %rsp,%rbp
  8028a8:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8028ac:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8028b0:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  8028b7:	00 00 00 
  8028ba:	ff d0                	call   *%rax
    if (res < 0) return res;
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	78 35                	js     8028f5 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8028c0:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8028c4:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  8028cb:	00 00 00 
  8028ce:	ff d0                	call   *%rax
  8028d0:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8028d3:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8028d8:	be 00 10 00 00       	mov    $0x1000,%esi
  8028dd:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8028e1:	48 b8 97 13 80 00 00 	movabs $0x801397,%rax
  8028e8:	00 00 00 
  8028eb:	ff d0                	call   *%rax
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	0f 94 c0             	sete   %al
  8028f2:	0f b6 c0             	movzbl %al,%eax
}
  8028f5:	c9                   	leave
  8028f6:	c3                   	ret

00000000008028f7 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8028f7:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8028fb:	48 89 f8             	mov    %rdi,%rax
  8028fe:	48 c1 e8 27          	shr    $0x27,%rax
  802902:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802909:	7f 00 00 
  80290c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802910:	f6 c2 01             	test   $0x1,%dl
  802913:	74 6d                	je     802982 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802915:	48 89 f8             	mov    %rdi,%rax
  802918:	48 c1 e8 1e          	shr    $0x1e,%rax
  80291c:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802923:	7f 00 00 
  802926:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80292a:	f6 c2 01             	test   $0x1,%dl
  80292d:	74 62                	je     802991 <get_uvpt_entry+0x9a>
  80292f:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802936:	7f 00 00 
  802939:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80293d:	f6 c2 80             	test   $0x80,%dl
  802940:	75 4f                	jne    802991 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802942:	48 89 f8             	mov    %rdi,%rax
  802945:	48 c1 e8 15          	shr    $0x15,%rax
  802949:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802950:	7f 00 00 
  802953:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802957:	f6 c2 01             	test   $0x1,%dl
  80295a:	74 44                	je     8029a0 <get_uvpt_entry+0xa9>
  80295c:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802963:	7f 00 00 
  802966:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80296a:	f6 c2 80             	test   $0x80,%dl
  80296d:	75 31                	jne    8029a0 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80296f:	48 c1 ef 0c          	shr    $0xc,%rdi
  802973:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80297a:	7f 00 00 
  80297d:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802981:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802982:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802989:	7f 00 00 
  80298c:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802990:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802991:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802998:	7f 00 00 
  80299b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80299f:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8029a0:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8029a7:	7f 00 00 
  8029aa:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029ae:	c3                   	ret

00000000008029af <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8029af:	f3 0f 1e fa          	endbr64
  8029b3:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8029b6:	48 89 f9             	mov    %rdi,%rcx
  8029b9:	48 c1 e9 27          	shr    $0x27,%rcx
  8029bd:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8029c4:	7f 00 00 
  8029c7:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8029cb:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8029d2:	f6 c1 01             	test   $0x1,%cl
  8029d5:	0f 84 b2 00 00 00    	je     802a8d <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8029db:	48 89 f9             	mov    %rdi,%rcx
  8029de:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8029e2:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8029e9:	7f 00 00 
  8029ec:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8029f0:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8029f7:	40 f6 c6 01          	test   $0x1,%sil
  8029fb:	0f 84 8c 00 00 00    	je     802a8d <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802a01:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802a08:	7f 00 00 
  802a0b:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a0f:	a8 80                	test   $0x80,%al
  802a11:	75 7b                	jne    802a8e <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802a13:	48 89 f9             	mov    %rdi,%rcx
  802a16:	48 c1 e9 15          	shr    $0x15,%rcx
  802a1a:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802a21:	7f 00 00 
  802a24:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a28:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802a2f:	40 f6 c6 01          	test   $0x1,%sil
  802a33:	74 58                	je     802a8d <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802a35:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802a3c:	7f 00 00 
  802a3f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a43:	a8 80                	test   $0x80,%al
  802a45:	75 6c                	jne    802ab3 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802a47:	48 89 f9             	mov    %rdi,%rcx
  802a4a:	48 c1 e9 0c          	shr    $0xc,%rcx
  802a4e:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a55:	7f 00 00 
  802a58:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a5c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802a63:	40 f6 c6 01          	test   $0x1,%sil
  802a67:	74 24                	je     802a8d <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802a69:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a70:	7f 00 00 
  802a73:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a77:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802a7e:	ff ff 7f 
  802a81:	48 21 c8             	and    %rcx,%rax
  802a84:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802a8a:	48 09 d0             	or     %rdx,%rax
}
  802a8d:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802a8e:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802a95:	7f 00 00 
  802a98:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a9c:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802aa3:	ff ff 7f 
  802aa6:	48 21 c8             	and    %rcx,%rax
  802aa9:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802aaf:	48 01 d0             	add    %rdx,%rax
  802ab2:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802ab3:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802aba:	7f 00 00 
  802abd:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802ac1:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802ac8:	ff ff 7f 
  802acb:	48 21 c8             	and    %rcx,%rax
  802ace:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802ad4:	48 01 d0             	add    %rdx,%rax
  802ad7:	c3                   	ret

0000000000802ad8 <get_prot>:

int
get_prot(void *va) {
  802ad8:	f3 0f 1e fa          	endbr64
  802adc:	55                   	push   %rbp
  802add:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802ae0:	48 b8 f7 28 80 00 00 	movabs $0x8028f7,%rax
  802ae7:	00 00 00 
  802aea:	ff d0                	call   *%rax
  802aec:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802aef:	83 e0 01             	and    $0x1,%eax
  802af2:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802af5:	89 d1                	mov    %edx,%ecx
  802af7:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802afd:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802aff:	89 c1                	mov    %eax,%ecx
  802b01:	83 c9 02             	or     $0x2,%ecx
  802b04:	f6 c2 02             	test   $0x2,%dl
  802b07:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802b0a:	89 c1                	mov    %eax,%ecx
  802b0c:	83 c9 01             	or     $0x1,%ecx
  802b0f:	48 85 d2             	test   %rdx,%rdx
  802b12:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802b15:	89 c1                	mov    %eax,%ecx
  802b17:	83 c9 40             	or     $0x40,%ecx
  802b1a:	f6 c6 04             	test   $0x4,%dh
  802b1d:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802b20:	5d                   	pop    %rbp
  802b21:	c3                   	ret

0000000000802b22 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802b22:	f3 0f 1e fa          	endbr64
  802b26:	55                   	push   %rbp
  802b27:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802b2a:	48 b8 f7 28 80 00 00 	movabs $0x8028f7,%rax
  802b31:	00 00 00 
  802b34:	ff d0                	call   *%rax
    return pte & PTE_D;
  802b36:	48 c1 e8 06          	shr    $0x6,%rax
  802b3a:	83 e0 01             	and    $0x1,%eax
}
  802b3d:	5d                   	pop    %rbp
  802b3e:	c3                   	ret

0000000000802b3f <is_page_present>:

bool
is_page_present(void *va) {
  802b3f:	f3 0f 1e fa          	endbr64
  802b43:	55                   	push   %rbp
  802b44:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802b47:	48 b8 f7 28 80 00 00 	movabs $0x8028f7,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	call   *%rax
  802b53:	83 e0 01             	and    $0x1,%eax
}
  802b56:	5d                   	pop    %rbp
  802b57:	c3                   	ret

0000000000802b58 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802b58:	f3 0f 1e fa          	endbr64
  802b5c:	55                   	push   %rbp
  802b5d:	48 89 e5             	mov    %rsp,%rbp
  802b60:	41 57                	push   %r15
  802b62:	41 56                	push   %r14
  802b64:	41 55                	push   %r13
  802b66:	41 54                	push   %r12
  802b68:	53                   	push   %rbx
  802b69:	48 83 ec 18          	sub    $0x18,%rsp
  802b6d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802b71:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802b75:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802b7a:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802b81:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802b84:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802b8b:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802b8e:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802b95:	00 00 00 
  802b98:	eb 73                	jmp    802c0d <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802b9a:	48 89 d8             	mov    %rbx,%rax
  802b9d:	48 c1 e8 15          	shr    $0x15,%rax
  802ba1:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802ba8:	7f 00 00 
  802bab:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802baf:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802bb5:	f6 c2 01             	test   $0x1,%dl
  802bb8:	74 4b                	je     802c05 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802bba:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802bbe:	f6 c2 80             	test   $0x80,%dl
  802bc1:	74 11                	je     802bd4 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802bc3:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802bc7:	f6 c4 04             	test   $0x4,%ah
  802bca:	74 39                	je     802c05 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802bcc:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802bd2:	eb 20                	jmp    802bf4 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802bd4:	48 89 da             	mov    %rbx,%rdx
  802bd7:	48 c1 ea 0c          	shr    $0xc,%rdx
  802bdb:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802be2:	7f 00 00 
  802be5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802be9:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802bef:	f6 c4 04             	test   $0x4,%ah
  802bf2:	74 11                	je     802c05 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802bf4:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802bf8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802bfc:	48 89 df             	mov    %rbx,%rdi
  802bff:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c03:	ff d0                	call   *%rax
    next:
        va += size;
  802c05:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802c08:	49 39 df             	cmp    %rbx,%r15
  802c0b:	72 3e                	jb     802c4b <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802c0d:	49 8b 06             	mov    (%r14),%rax
  802c10:	a8 01                	test   $0x1,%al
  802c12:	74 37                	je     802c4b <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c14:	48 89 d8             	mov    %rbx,%rax
  802c17:	48 c1 e8 1e          	shr    $0x1e,%rax
  802c1b:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802c20:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c26:	f6 c2 01             	test   $0x1,%dl
  802c29:	74 da                	je     802c05 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802c2b:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802c30:	f6 c2 80             	test   $0x80,%dl
  802c33:	0f 84 61 ff ff ff    	je     802b9a <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802c39:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802c3e:	f6 c4 04             	test   $0x4,%ah
  802c41:	74 c2                	je     802c05 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802c43:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802c49:	eb a9                	jmp    802bf4 <foreach_shared_region+0x9c>
    }
    return res;
}
  802c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c50:	48 83 c4 18          	add    $0x18,%rsp
  802c54:	5b                   	pop    %rbx
  802c55:	41 5c                	pop    %r12
  802c57:	41 5d                	pop    %r13
  802c59:	41 5e                	pop    %r14
  802c5b:	41 5f                	pop    %r15
  802c5d:	5d                   	pop    %rbp
  802c5e:	c3                   	ret

0000000000802c5f <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802c5f:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802c63:	b8 00 00 00 00       	mov    $0x0,%eax
  802c68:	c3                   	ret

0000000000802c69 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802c69:	f3 0f 1e fa          	endbr64
  802c6d:	55                   	push   %rbp
  802c6e:	48 89 e5             	mov    %rsp,%rbp
  802c71:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802c74:	48 be 92 42 80 00 00 	movabs $0x804292,%rsi
  802c7b:	00 00 00 
  802c7e:	48 b8 c2 0d 80 00 00 	movabs $0x800dc2,%rax
  802c85:	00 00 00 
  802c88:	ff d0                	call   *%rax
    return 0;
}
  802c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8f:	5d                   	pop    %rbp
  802c90:	c3                   	ret

0000000000802c91 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802c91:	f3 0f 1e fa          	endbr64
  802c95:	55                   	push   %rbp
  802c96:	48 89 e5             	mov    %rsp,%rbp
  802c99:	41 57                	push   %r15
  802c9b:	41 56                	push   %r14
  802c9d:	41 55                	push   %r13
  802c9f:	41 54                	push   %r12
  802ca1:	53                   	push   %rbx
  802ca2:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802ca9:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802cb0:	48 85 d2             	test   %rdx,%rdx
  802cb3:	74 7a                	je     802d2f <devcons_write+0x9e>
  802cb5:	49 89 d6             	mov    %rdx,%r14
  802cb8:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802cbe:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802cc3:	49 bf dd 0f 80 00 00 	movabs $0x800fdd,%r15
  802cca:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802ccd:	4c 89 f3             	mov    %r14,%rbx
  802cd0:	48 29 f3             	sub    %rsi,%rbx
  802cd3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802cd8:	48 39 c3             	cmp    %rax,%rbx
  802cdb:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802cdf:	4c 63 eb             	movslq %ebx,%r13
  802ce2:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802ce9:	48 01 c6             	add    %rax,%rsi
  802cec:	4c 89 ea             	mov    %r13,%rdx
  802cef:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802cf6:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802cf9:	4c 89 ee             	mov    %r13,%rsi
  802cfc:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802d03:	48 b8 22 12 80 00 00 	movabs $0x801222,%rax
  802d0a:	00 00 00 
  802d0d:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802d0f:	41 01 dc             	add    %ebx,%r12d
  802d12:	49 63 f4             	movslq %r12d,%rsi
  802d15:	4c 39 f6             	cmp    %r14,%rsi
  802d18:	72 b3                	jb     802ccd <devcons_write+0x3c>
    return res;
  802d1a:	49 63 c4             	movslq %r12d,%rax
}
  802d1d:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802d24:	5b                   	pop    %rbx
  802d25:	41 5c                	pop    %r12
  802d27:	41 5d                	pop    %r13
  802d29:	41 5e                	pop    %r14
  802d2b:	41 5f                	pop    %r15
  802d2d:	5d                   	pop    %rbp
  802d2e:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802d2f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d35:	eb e3                	jmp    802d1a <devcons_write+0x89>

0000000000802d37 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d37:	f3 0f 1e fa          	endbr64
  802d3b:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802d3e:	ba 00 00 00 00       	mov    $0x0,%edx
  802d43:	48 85 c0             	test   %rax,%rax
  802d46:	74 55                	je     802d9d <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d48:	55                   	push   %rbp
  802d49:	48 89 e5             	mov    %rsp,%rbp
  802d4c:	41 55                	push   %r13
  802d4e:	41 54                	push   %r12
  802d50:	53                   	push   %rbx
  802d51:	48 83 ec 08          	sub    $0x8,%rsp
  802d55:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802d58:	48 bb 53 12 80 00 00 	movabs $0x801253,%rbx
  802d5f:	00 00 00 
  802d62:	49 bc 2c 13 80 00 00 	movabs $0x80132c,%r12
  802d69:	00 00 00 
  802d6c:	eb 03                	jmp    802d71 <devcons_read+0x3a>
  802d6e:	41 ff d4             	call   *%r12
  802d71:	ff d3                	call   *%rbx
  802d73:	85 c0                	test   %eax,%eax
  802d75:	74 f7                	je     802d6e <devcons_read+0x37>
    if (c < 0) return c;
  802d77:	48 63 d0             	movslq %eax,%rdx
  802d7a:	78 13                	js     802d8f <devcons_read+0x58>
    if (c == 0x04) return 0;
  802d7c:	ba 00 00 00 00       	mov    $0x0,%edx
  802d81:	83 f8 04             	cmp    $0x4,%eax
  802d84:	74 09                	je     802d8f <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802d86:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802d8a:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802d8f:	48 89 d0             	mov    %rdx,%rax
  802d92:	48 83 c4 08          	add    $0x8,%rsp
  802d96:	5b                   	pop    %rbx
  802d97:	41 5c                	pop    %r12
  802d99:	41 5d                	pop    %r13
  802d9b:	5d                   	pop    %rbp
  802d9c:	c3                   	ret
  802d9d:	48 89 d0             	mov    %rdx,%rax
  802da0:	c3                   	ret

0000000000802da1 <cputchar>:
cputchar(int ch) {
  802da1:	f3 0f 1e fa          	endbr64
  802da5:	55                   	push   %rbp
  802da6:	48 89 e5             	mov    %rsp,%rbp
  802da9:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802dad:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802db1:	be 01 00 00 00       	mov    $0x1,%esi
  802db6:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802dba:	48 b8 22 12 80 00 00 	movabs $0x801222,%rax
  802dc1:	00 00 00 
  802dc4:	ff d0                	call   *%rax
}
  802dc6:	c9                   	leave
  802dc7:	c3                   	ret

0000000000802dc8 <getchar>:
getchar(void) {
  802dc8:	f3 0f 1e fa          	endbr64
  802dcc:	55                   	push   %rbp
  802dcd:	48 89 e5             	mov    %rsp,%rbp
  802dd0:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802dd4:	ba 01 00 00 00       	mov    $0x1,%edx
  802dd9:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802ddd:	bf 00 00 00 00       	mov    $0x0,%edi
  802de2:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  802de9:	00 00 00 
  802dec:	ff d0                	call   *%rax
  802dee:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802df0:	85 c0                	test   %eax,%eax
  802df2:	78 06                	js     802dfa <getchar+0x32>
  802df4:	74 08                	je     802dfe <getchar+0x36>
  802df6:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802dfa:	89 d0                	mov    %edx,%eax
  802dfc:	c9                   	leave
  802dfd:	c3                   	ret
    return res < 0 ? res : res ? c :
  802dfe:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802e03:	eb f5                	jmp    802dfa <getchar+0x32>

0000000000802e05 <iscons>:
iscons(int fdnum) {
  802e05:	f3 0f 1e fa          	endbr64
  802e09:	55                   	push   %rbp
  802e0a:	48 89 e5             	mov    %rsp,%rbp
  802e0d:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802e11:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802e15:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  802e1c:	00 00 00 
  802e1f:	ff d0                	call   *%rax
    if (res < 0) return res;
  802e21:	85 c0                	test   %eax,%eax
  802e23:	78 18                	js     802e3d <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802e25:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e29:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802e30:	00 00 00 
  802e33:	8b 00                	mov    (%rax),%eax
  802e35:	39 02                	cmp    %eax,(%rdx)
  802e37:	0f 94 c0             	sete   %al
  802e3a:	0f b6 c0             	movzbl %al,%eax
}
  802e3d:	c9                   	leave
  802e3e:	c3                   	ret

0000000000802e3f <opencons>:
opencons(void) {
  802e3f:	f3 0f 1e fa          	endbr64
  802e43:	55                   	push   %rbp
  802e44:	48 89 e5             	mov    %rsp,%rbp
  802e47:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802e4b:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802e4f:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  802e56:	00 00 00 
  802e59:	ff d0                	call   *%rax
  802e5b:	85 c0                	test   %eax,%eax
  802e5d:	78 49                	js     802ea8 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802e5f:	b9 46 00 00 00       	mov    $0x46,%ecx
  802e64:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e69:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802e6d:	bf 00 00 00 00       	mov    $0x0,%edi
  802e72:	48 b8 c7 13 80 00 00 	movabs $0x8013c7,%rax
  802e79:	00 00 00 
  802e7c:	ff d0                	call   *%rax
  802e7e:	85 c0                	test   %eax,%eax
  802e80:	78 26                	js     802ea8 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802e82:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e86:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802e8d:	00 00 
  802e8f:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802e91:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802e95:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802e9c:	48 b8 8b 17 80 00 00 	movabs $0x80178b,%rax
  802ea3:	00 00 00 
  802ea6:	ff d0                	call   *%rax
}
  802ea8:	c9                   	leave
  802ea9:	c3                   	ret

0000000000802eaa <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802eaa:	f3 0f 1e fa          	endbr64
  802eae:	55                   	push   %rbp
  802eaf:	48 89 e5             	mov    %rsp,%rbp
  802eb2:	41 54                	push   %r12
  802eb4:	53                   	push   %rbx
  802eb5:	48 89 fb             	mov    %rdi,%rbx
  802eb8:	48 89 f7             	mov    %rsi,%rdi
  802ebb:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802ebe:	48 85 f6             	test   %rsi,%rsi
  802ec1:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802ec8:	00 00 00 
  802ecb:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802ecf:	be 00 10 00 00       	mov    $0x1000,%esi
  802ed4:	48 b8 e9 16 80 00 00 	movabs $0x8016e9,%rax
  802edb:	00 00 00 
  802ede:	ff d0                	call   *%rax
    if (res < 0) {
  802ee0:	85 c0                	test   %eax,%eax
  802ee2:	78 45                	js     802f29 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802ee4:	48 85 db             	test   %rbx,%rbx
  802ee7:	74 12                	je     802efb <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802ee9:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  802ef0:	00 00 00 
  802ef3:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802ef9:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802efb:	4d 85 e4             	test   %r12,%r12
  802efe:	74 14                	je     802f14 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802f00:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  802f07:	00 00 00 
  802f0a:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802f10:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802f14:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  802f1b:	00 00 00 
  802f1e:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802f24:	5b                   	pop    %rbx
  802f25:	41 5c                	pop    %r12
  802f27:	5d                   	pop    %rbp
  802f28:	c3                   	ret
        if (from_env_store != NULL) {
  802f29:	48 85 db             	test   %rbx,%rbx
  802f2c:	74 06                	je     802f34 <ipc_recv+0x8a>
            *from_env_store = 0;
  802f2e:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802f34:	4d 85 e4             	test   %r12,%r12
  802f37:	74 eb                	je     802f24 <ipc_recv+0x7a>
            *perm_store = 0;
  802f39:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802f40:	00 
  802f41:	eb e1                	jmp    802f24 <ipc_recv+0x7a>

0000000000802f43 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802f43:	f3 0f 1e fa          	endbr64
  802f47:	55                   	push   %rbp
  802f48:	48 89 e5             	mov    %rsp,%rbp
  802f4b:	41 57                	push   %r15
  802f4d:	41 56                	push   %r14
  802f4f:	41 55                	push   %r13
  802f51:	41 54                	push   %r12
  802f53:	53                   	push   %rbx
  802f54:	48 83 ec 18          	sub    $0x18,%rsp
  802f58:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802f5b:	48 89 d3             	mov    %rdx,%rbx
  802f5e:	49 89 cc             	mov    %rcx,%r12
  802f61:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802f64:	48 85 d2             	test   %rdx,%rdx
  802f67:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802f6e:	00 00 00 
  802f71:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802f75:	89 f0                	mov    %esi,%eax
  802f77:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802f7b:	48 89 da             	mov    %rbx,%rdx
  802f7e:	48 89 c6             	mov    %rax,%rsi
  802f81:	48 b8 b9 16 80 00 00 	movabs $0x8016b9,%rax
  802f88:	00 00 00 
  802f8b:	ff d0                	call   *%rax
    while (res < 0) {
  802f8d:	85 c0                	test   %eax,%eax
  802f8f:	79 65                	jns    802ff6 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802f91:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802f94:	75 33                	jne    802fc9 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802f96:	49 bf 2c 13 80 00 00 	movabs $0x80132c,%r15
  802f9d:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802fa0:	49 be b9 16 80 00 00 	movabs $0x8016b9,%r14
  802fa7:	00 00 00 
        sys_yield();
  802faa:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802fad:	45 89 e8             	mov    %r13d,%r8d
  802fb0:	4c 89 e1             	mov    %r12,%rcx
  802fb3:	48 89 da             	mov    %rbx,%rdx
  802fb6:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802fba:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802fbd:	41 ff d6             	call   *%r14
    while (res < 0) {
  802fc0:	85 c0                	test   %eax,%eax
  802fc2:	79 32                	jns    802ff6 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802fc4:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802fc7:	74 e1                	je     802faa <ipc_send+0x67>
            panic("Error: %i\n", res);
  802fc9:	89 c1                	mov    %eax,%ecx
  802fcb:	48 ba 9e 42 80 00 00 	movabs $0x80429e,%rdx
  802fd2:	00 00 00 
  802fd5:	be 42 00 00 00       	mov    $0x42,%esi
  802fda:	48 bf a9 42 80 00 00 	movabs $0x8042a9,%rdi
  802fe1:	00 00 00 
  802fe4:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe9:	49 b8 1d 03 80 00 00 	movabs $0x80031d,%r8
  802ff0:	00 00 00 
  802ff3:	41 ff d0             	call   *%r8
    }
}
  802ff6:	48 83 c4 18          	add    $0x18,%rsp
  802ffa:	5b                   	pop    %rbx
  802ffb:	41 5c                	pop    %r12
  802ffd:	41 5d                	pop    %r13
  802fff:	41 5e                	pop    %r14
  803001:	41 5f                	pop    %r15
  803003:	5d                   	pop    %rbp
  803004:	c3                   	ret

0000000000803005 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  803005:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  803009:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80300e:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  803015:	00 00 00 
  803018:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80301c:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803020:	48 c1 e2 04          	shl    $0x4,%rdx
  803024:	48 01 ca             	add    %rcx,%rdx
  803027:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  80302d:	39 fa                	cmp    %edi,%edx
  80302f:	74 12                	je     803043 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  803031:	48 83 c0 01          	add    $0x1,%rax
  803035:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  80303b:	75 db                	jne    803018 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  80303d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803042:	c3                   	ret
            return envs[i].env_id;
  803043:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803047:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80304b:	48 c1 e2 04          	shl    $0x4,%rdx
  80304f:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  803056:	00 00 00 
  803059:	48 01 d0             	add    %rdx,%rax
  80305c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803062:	c3                   	ret

0000000000803063 <__text_end>:
  803063:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80306a:	00 00 00 
  80306d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803074:	00 00 00 
  803077:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80307e:	00 00 00 
  803081:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803088:	00 00 00 
  80308b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803092:	00 00 00 
  803095:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80309c:	00 00 00 
  80309f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030a6:	00 00 00 
  8030a9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030b0:	00 00 00 
  8030b3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030ba:	00 00 00 
  8030bd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030c4:	00 00 00 
  8030c7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030ce:	00 00 00 
  8030d1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030d8:	00 00 00 
  8030db:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030e2:	00 00 00 
  8030e5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030ec:	00 00 00 
  8030ef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030f6:	00 00 00 
  8030f9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803100:	00 00 00 
  803103:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80310a:	00 00 00 
  80310d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803114:	00 00 00 
  803117:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80311e:	00 00 00 
  803121:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803128:	00 00 00 
  80312b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803132:	00 00 00 
  803135:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80313c:	00 00 00 
  80313f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803146:	00 00 00 
  803149:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803150:	00 00 00 
  803153:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80315a:	00 00 00 
  80315d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803164:	00 00 00 
  803167:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80316e:	00 00 00 
  803171:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803178:	00 00 00 
  80317b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803182:	00 00 00 
  803185:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80318c:	00 00 00 
  80318f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803196:	00 00 00 
  803199:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031a0:	00 00 00 
  8031a3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031aa:	00 00 00 
  8031ad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031b4:	00 00 00 
  8031b7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031be:	00 00 00 
  8031c1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031c8:	00 00 00 
  8031cb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031d2:	00 00 00 
  8031d5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031dc:	00 00 00 
  8031df:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031e6:	00 00 00 
  8031e9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031f0:	00 00 00 
  8031f3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031fa:	00 00 00 
  8031fd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803204:	00 00 00 
  803207:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80320e:	00 00 00 
  803211:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803218:	00 00 00 
  80321b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803222:	00 00 00 
  803225:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80322c:	00 00 00 
  80322f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803236:	00 00 00 
  803239:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803240:	00 00 00 
  803243:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80324a:	00 00 00 
  80324d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803254:	00 00 00 
  803257:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80325e:	00 00 00 
  803261:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803268:	00 00 00 
  80326b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803272:	00 00 00 
  803275:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80327c:	00 00 00 
  80327f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803286:	00 00 00 
  803289:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803290:	00 00 00 
  803293:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80329a:	00 00 00 
  80329d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032a4:	00 00 00 
  8032a7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032ae:	00 00 00 
  8032b1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032b8:	00 00 00 
  8032bb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032c2:	00 00 00 
  8032c5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032cc:	00 00 00 
  8032cf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032d6:	00 00 00 
  8032d9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032e0:	00 00 00 
  8032e3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032ea:	00 00 00 
  8032ed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032f4:	00 00 00 
  8032f7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032fe:	00 00 00 
  803301:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803308:	00 00 00 
  80330b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803312:	00 00 00 
  803315:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80331c:	00 00 00 
  80331f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803326:	00 00 00 
  803329:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803330:	00 00 00 
  803333:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80333a:	00 00 00 
  80333d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803344:	00 00 00 
  803347:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80334e:	00 00 00 
  803351:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803358:	00 00 00 
  80335b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803362:	00 00 00 
  803365:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80336c:	00 00 00 
  80336f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803376:	00 00 00 
  803379:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803380:	00 00 00 
  803383:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80338a:	00 00 00 
  80338d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803394:	00 00 00 
  803397:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80339e:	00 00 00 
  8033a1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033a8:	00 00 00 
  8033ab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033b2:	00 00 00 
  8033b5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033bc:	00 00 00 
  8033bf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033c6:	00 00 00 
  8033c9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033d0:	00 00 00 
  8033d3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033da:	00 00 00 
  8033dd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033e4:	00 00 00 
  8033e7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033ee:	00 00 00 
  8033f1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033f8:	00 00 00 
  8033fb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803402:	00 00 00 
  803405:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80340c:	00 00 00 
  80340f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803416:	00 00 00 
  803419:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803420:	00 00 00 
  803423:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80342a:	00 00 00 
  80342d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803434:	00 00 00 
  803437:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80343e:	00 00 00 
  803441:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803448:	00 00 00 
  80344b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803452:	00 00 00 
  803455:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80345c:	00 00 00 
  80345f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803466:	00 00 00 
  803469:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803470:	00 00 00 
  803473:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80347a:	00 00 00 
  80347d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803484:	00 00 00 
  803487:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80348e:	00 00 00 
  803491:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803498:	00 00 00 
  80349b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034a2:	00 00 00 
  8034a5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ac:	00 00 00 
  8034af:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034b6:	00 00 00 
  8034b9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034c0:	00 00 00 
  8034c3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ca:	00 00 00 
  8034cd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034d4:	00 00 00 
  8034d7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034de:	00 00 00 
  8034e1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034e8:	00 00 00 
  8034eb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034f2:	00 00 00 
  8034f5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034fc:	00 00 00 
  8034ff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803506:	00 00 00 
  803509:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803510:	00 00 00 
  803513:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80351a:	00 00 00 
  80351d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803524:	00 00 00 
  803527:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80352e:	00 00 00 
  803531:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803538:	00 00 00 
  80353b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803542:	00 00 00 
  803545:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80354c:	00 00 00 
  80354f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803556:	00 00 00 
  803559:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803560:	00 00 00 
  803563:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80356a:	00 00 00 
  80356d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803574:	00 00 00 
  803577:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80357e:	00 00 00 
  803581:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803588:	00 00 00 
  80358b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803592:	00 00 00 
  803595:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80359c:	00 00 00 
  80359f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a6:	00 00 00 
  8035a9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b0:	00 00 00 
  8035b3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ba:	00 00 00 
  8035bd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035c4:	00 00 00 
  8035c7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ce:	00 00 00 
  8035d1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035d8:	00 00 00 
  8035db:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035e2:	00 00 00 
  8035e5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ec:	00 00 00 
  8035ef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035f6:	00 00 00 
  8035f9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803600:	00 00 00 
  803603:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80360a:	00 00 00 
  80360d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803614:	00 00 00 
  803617:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80361e:	00 00 00 
  803621:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803628:	00 00 00 
  80362b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803632:	00 00 00 
  803635:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80363c:	00 00 00 
  80363f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803646:	00 00 00 
  803649:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803650:	00 00 00 
  803653:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80365a:	00 00 00 
  80365d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803664:	00 00 00 
  803667:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80366e:	00 00 00 
  803671:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803678:	00 00 00 
  80367b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803682:	00 00 00 
  803685:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80368c:	00 00 00 
  80368f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803696:	00 00 00 
  803699:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036a0:	00 00 00 
  8036a3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036aa:	00 00 00 
  8036ad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036b4:	00 00 00 
  8036b7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036be:	00 00 00 
  8036c1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036c8:	00 00 00 
  8036cb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036d2:	00 00 00 
  8036d5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036dc:	00 00 00 
  8036df:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036e6:	00 00 00 
  8036e9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036f0:	00 00 00 
  8036f3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036fa:	00 00 00 
  8036fd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803704:	00 00 00 
  803707:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80370e:	00 00 00 
  803711:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803718:	00 00 00 
  80371b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803722:	00 00 00 
  803725:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80372c:	00 00 00 
  80372f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803736:	00 00 00 
  803739:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803740:	00 00 00 
  803743:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80374a:	00 00 00 
  80374d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803754:	00 00 00 
  803757:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80375e:	00 00 00 
  803761:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803768:	00 00 00 
  80376b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803772:	00 00 00 
  803775:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80377c:	00 00 00 
  80377f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803786:	00 00 00 
  803789:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803790:	00 00 00 
  803793:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80379a:	00 00 00 
  80379d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a4:	00 00 00 
  8037a7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ae:	00 00 00 
  8037b1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b8:	00 00 00 
  8037bb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c2:	00 00 00 
  8037c5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037cc:	00 00 00 
  8037cf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d6:	00 00 00 
  8037d9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e0:	00 00 00 
  8037e3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ea:	00 00 00 
  8037ed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f4:	00 00 00 
  8037f7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037fe:	00 00 00 
  803801:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803808:	00 00 00 
  80380b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803812:	00 00 00 
  803815:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80381c:	00 00 00 
  80381f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803826:	00 00 00 
  803829:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803830:	00 00 00 
  803833:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80383a:	00 00 00 
  80383d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803844:	00 00 00 
  803847:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80384e:	00 00 00 
  803851:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803858:	00 00 00 
  80385b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803862:	00 00 00 
  803865:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80386c:	00 00 00 
  80386f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803876:	00 00 00 
  803879:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803880:	00 00 00 
  803883:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80388a:	00 00 00 
  80388d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803894:	00 00 00 
  803897:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80389e:	00 00 00 
  8038a1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a8:	00 00 00 
  8038ab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b2:	00 00 00 
  8038b5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038bc:	00 00 00 
  8038bf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c6:	00 00 00 
  8038c9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d0:	00 00 00 
  8038d3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038da:	00 00 00 
  8038dd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e4:	00 00 00 
  8038e7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ee:	00 00 00 
  8038f1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f8:	00 00 00 
  8038fb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803902:	00 00 00 
  803905:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80390c:	00 00 00 
  80390f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803916:	00 00 00 
  803919:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803920:	00 00 00 
  803923:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80392a:	00 00 00 
  80392d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803934:	00 00 00 
  803937:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80393e:	00 00 00 
  803941:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803948:	00 00 00 
  80394b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803952:	00 00 00 
  803955:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80395c:	00 00 00 
  80395f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803966:	00 00 00 
  803969:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803970:	00 00 00 
  803973:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80397a:	00 00 00 
  80397d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803984:	00 00 00 
  803987:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80398e:	00 00 00 
  803991:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803998:	00 00 00 
  80399b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a2:	00 00 00 
  8039a5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ac:	00 00 00 
  8039af:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b6:	00 00 00 
  8039b9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c0:	00 00 00 
  8039c3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ca:	00 00 00 
  8039cd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d4:	00 00 00 
  8039d7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039de:	00 00 00 
  8039e1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e8:	00 00 00 
  8039eb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f2:	00 00 00 
  8039f5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039fc:	00 00 00 
  8039ff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a06:	00 00 00 
  803a09:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a10:	00 00 00 
  803a13:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a1a:	00 00 00 
  803a1d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a24:	00 00 00 
  803a27:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a2e:	00 00 00 
  803a31:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a38:	00 00 00 
  803a3b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a42:	00 00 00 
  803a45:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a4c:	00 00 00 
  803a4f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a56:	00 00 00 
  803a59:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a60:	00 00 00 
  803a63:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a6a:	00 00 00 
  803a6d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a74:	00 00 00 
  803a77:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a7e:	00 00 00 
  803a81:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a88:	00 00 00 
  803a8b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a92:	00 00 00 
  803a95:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a9c:	00 00 00 
  803a9f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa6:	00 00 00 
  803aa9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab0:	00 00 00 
  803ab3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aba:	00 00 00 
  803abd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac4:	00 00 00 
  803ac7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ace:	00 00 00 
  803ad1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad8:	00 00 00 
  803adb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae2:	00 00 00 
  803ae5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aec:	00 00 00 
  803aef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af6:	00 00 00 
  803af9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b00:	00 00 00 
  803b03:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b0a:	00 00 00 
  803b0d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b14:	00 00 00 
  803b17:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b1e:	00 00 00 
  803b21:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b28:	00 00 00 
  803b2b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b32:	00 00 00 
  803b35:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b3c:	00 00 00 
  803b3f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b46:	00 00 00 
  803b49:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b50:	00 00 00 
  803b53:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b5a:	00 00 00 
  803b5d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b64:	00 00 00 
  803b67:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b6e:	00 00 00 
  803b71:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b78:	00 00 00 
  803b7b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b82:	00 00 00 
  803b85:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b8c:	00 00 00 
  803b8f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b96:	00 00 00 
  803b99:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba0:	00 00 00 
  803ba3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803baa:	00 00 00 
  803bad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb4:	00 00 00 
  803bb7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bbe:	00 00 00 
  803bc1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc8:	00 00 00 
  803bcb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd2:	00 00 00 
  803bd5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bdc:	00 00 00 
  803bdf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be6:	00 00 00 
  803be9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf0:	00 00 00 
  803bf3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bfa:	00 00 00 
  803bfd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c04:	00 00 00 
  803c07:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c0e:	00 00 00 
  803c11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c18:	00 00 00 
  803c1b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c22:	00 00 00 
  803c25:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c2c:	00 00 00 
  803c2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c36:	00 00 00 
  803c39:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c40:	00 00 00 
  803c43:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c4a:	00 00 00 
  803c4d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c54:	00 00 00 
  803c57:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c5e:	00 00 00 
  803c61:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c68:	00 00 00 
  803c6b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c72:	00 00 00 
  803c75:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c7c:	00 00 00 
  803c7f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c86:	00 00 00 
  803c89:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c90:	00 00 00 
  803c93:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c9a:	00 00 00 
  803c9d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca4:	00 00 00 
  803ca7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cae:	00 00 00 
  803cb1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb8:	00 00 00 
  803cbb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc2:	00 00 00 
  803cc5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ccc:	00 00 00 
  803ccf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd6:	00 00 00 
  803cd9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce0:	00 00 00 
  803ce3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cea:	00 00 00 
  803ced:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf4:	00 00 00 
  803cf7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cfe:	00 00 00 
  803d01:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d08:	00 00 00 
  803d0b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d12:	00 00 00 
  803d15:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d1c:	00 00 00 
  803d1f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d26:	00 00 00 
  803d29:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d30:	00 00 00 
  803d33:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d3a:	00 00 00 
  803d3d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d44:	00 00 00 
  803d47:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d4e:	00 00 00 
  803d51:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d58:	00 00 00 
  803d5b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d62:	00 00 00 
  803d65:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d6c:	00 00 00 
  803d6f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d76:	00 00 00 
  803d79:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d80:	00 00 00 
  803d83:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d8a:	00 00 00 
  803d8d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d94:	00 00 00 
  803d97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d9e:	00 00 00 
  803da1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da8:	00 00 00 
  803dab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db2:	00 00 00 
  803db5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dbc:	00 00 00 
  803dbf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc6:	00 00 00 
  803dc9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd0:	00 00 00 
  803dd3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dda:	00 00 00 
  803ddd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de4:	00 00 00 
  803de7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dee:	00 00 00 
  803df1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df8:	00 00 00 
  803dfb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e02:	00 00 00 
  803e05:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e0c:	00 00 00 
  803e0f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e16:	00 00 00 
  803e19:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e20:	00 00 00 
  803e23:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e2a:	00 00 00 
  803e2d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e34:	00 00 00 
  803e37:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e3e:	00 00 00 
  803e41:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e48:	00 00 00 
  803e4b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e52:	00 00 00 
  803e55:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e5c:	00 00 00 
  803e5f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e66:	00 00 00 
  803e69:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e70:	00 00 00 
  803e73:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e7a:	00 00 00 
  803e7d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e84:	00 00 00 
  803e87:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e8e:	00 00 00 
  803e91:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e98:	00 00 00 
  803e9b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea2:	00 00 00 
  803ea5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eac:	00 00 00 
  803eaf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb6:	00 00 00 
  803eb9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec0:	00 00 00 
  803ec3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eca:	00 00 00 
  803ecd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed4:	00 00 00 
  803ed7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ede:	00 00 00 
  803ee1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee8:	00 00 00 
  803eeb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef2:	00 00 00 
  803ef5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803efc:	00 00 00 
  803eff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f06:	00 00 00 
  803f09:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f10:	00 00 00 
  803f13:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f1a:	00 00 00 
  803f1d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f24:	00 00 00 
  803f27:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f2e:	00 00 00 
  803f31:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f38:	00 00 00 
  803f3b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f42:	00 00 00 
  803f45:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f4c:	00 00 00 
  803f4f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f56:	00 00 00 
  803f59:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f60:	00 00 00 
  803f63:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f6a:	00 00 00 
  803f6d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f74:	00 00 00 
  803f77:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f7e:	00 00 00 
  803f81:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f88:	00 00 00 
  803f8b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f92:	00 00 00 
  803f95:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f9c:	00 00 00 
  803f9f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa6:	00 00 00 
  803fa9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb0:	00 00 00 
  803fb3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fba:	00 00 00 
  803fbd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc4:	00 00 00 
  803fc7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fce:	00 00 00 
  803fd1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd8:	00 00 00 
  803fdb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe2:	00 00 00 
  803fe5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fec:	00 00 00 
  803fef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff6:	00 00 00 
  803ff9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
