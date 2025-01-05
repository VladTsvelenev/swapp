
obj/user/cat:     file format elf64-x86-64


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
  80001e:	e8 ae 01 00 00       	call   8001d1 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <cat>:
#include <inc/lib.h>

char buf[8192];

void
cat(int f, char *s) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 57                	push   %r15
  80002f:	41 56                	push   %r14
  800031:	41 55                	push   %r13
  800033:	41 54                	push   %r12
  800035:	53                   	push   %rbx
  800036:	48 83 ec 18          	sub    $0x18,%rsp
  80003a:	41 89 fd             	mov    %edi,%r13d
  80003d:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
    long n;
    int r;

    while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800041:	49 bc 00 50 80 00 00 	movabs $0x805000,%r12
  800048:	00 00 00 
  80004b:	49 be ad 1a 80 00 00 	movabs $0x801aad,%r14
  800052:	00 00 00 
        if ((r = write(1, buf, n)) != n)
  800055:	49 bf e4 1b 80 00 00 	movabs $0x801be4,%r15
  80005c:	00 00 00 
    while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80005f:	ba 00 20 00 00       	mov    $0x2000,%edx
  800064:	4c 89 e6             	mov    %r12,%rsi
  800067:	44 89 ef             	mov    %r13d,%edi
  80006a:	41 ff d6             	call   *%r14
  80006d:	48 89 c3             	mov    %rax,%rbx
  800070:	48 85 c0             	test   %rax,%rax
  800073:	7e 48                	jle    8000bd <cat+0x98>
        if ((r = write(1, buf, n)) != n)
  800075:	48 89 da             	mov    %rbx,%rdx
  800078:	4c 89 e6             	mov    %r12,%rsi
  80007b:	bf 01 00 00 00       	mov    $0x1,%edi
  800080:	41 ff d7             	call   *%r15
  800083:	48 63 d0             	movslq %eax,%rdx
  800086:	48 39 da             	cmp    %rbx,%rdx
  800089:	74 d4                	je     80005f <cat+0x3a>
            panic("write error copying %s: %i", s, r);
  80008b:	41 89 c0             	mov    %eax,%r8d
  80008e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800092:	48 ba 00 30 80 00 00 	movabs $0x803000,%rdx
  800099:	00 00 00 
  80009c:	be 0c 00 00 00       	mov    $0xc,%esi
  8000a1:	48 bf 1b 30 80 00 00 	movabs $0x80301b,%rdi
  8000a8:	00 00 00 
  8000ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b0:	49 b9 aa 02 80 00 00 	movabs $0x8002aa,%r9
  8000b7:	00 00 00 
  8000ba:	41 ff d1             	call   *%r9
    if (n < 0)
  8000bd:	78 0f                	js     8000ce <cat+0xa9>
        panic("error reading %s: %i", s, (int)n);
}
  8000bf:	48 83 c4 18          	add    $0x18,%rsp
  8000c3:	5b                   	pop    %rbx
  8000c4:	41 5c                	pop    %r12
  8000c6:	41 5d                	pop    %r13
  8000c8:	41 5e                	pop    %r14
  8000ca:	41 5f                	pop    %r15
  8000cc:	5d                   	pop    %rbp
  8000cd:	c3                   	ret
        panic("error reading %s: %i", s, (int)n);
  8000ce:	41 89 c0             	mov    %eax,%r8d
  8000d1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8000d5:	48 ba 26 30 80 00 00 	movabs $0x803026,%rdx
  8000dc:	00 00 00 
  8000df:	be 0e 00 00 00       	mov    $0xe,%esi
  8000e4:	48 bf 1b 30 80 00 00 	movabs $0x80301b,%rdi
  8000eb:	00 00 00 
  8000ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f3:	49 b9 aa 02 80 00 00 	movabs $0x8002aa,%r9
  8000fa:	00 00 00 
  8000fd:	41 ff d1             	call   *%r9

0000000000800100 <umain>:

void
umain(int argc, char **argv) {
  800100:	f3 0f 1e fa          	endbr64
  800104:	55                   	push   %rbp
  800105:	48 89 e5             	mov    %rsp,%rbp
  800108:	41 57                	push   %r15
  80010a:	41 56                	push   %r14
  80010c:	41 55                	push   %r13
  80010e:	41 54                	push   %r12
  800110:	53                   	push   %rbx
  800111:	48 83 ec 08          	sub    $0x8,%rsp
    int f, i;

    binaryname = "cat";
  800115:	48 b8 3b 30 80 00 00 	movabs $0x80303b,%rax
  80011c:	00 00 00 
  80011f:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800126:	00 00 00 
    if (argc == 1)
  800129:	83 ff 01             	cmp    $0x1,%edi
  80012c:	74 24                	je     800152 <umain+0x52>
        cat(0, "<stdin>");
    else
        for (i = 1; i < argc; i++) {
  80012e:	7e 3d                	jle    80016d <umain+0x6d>
  800130:	4c 8d 66 08          	lea    0x8(%rsi),%r12
  800134:	8d 47 fe             	lea    -0x2(%rdi),%eax
  800137:	4c 8d 74 c6 10       	lea    0x10(%rsi,%rax,8),%r14
            f = open(argv[i], O_RDONLY);
  80013c:	49 bd e3 20 80 00 00 	movabs $0x8020e3,%r13
  800143:	00 00 00 
            if (f < 0)
                printf("can't open %s: %i\n", argv[i], f);
            else {
                cat(f, argv[i]);
  800146:	49 bf 25 00 80 00 00 	movabs $0x800025,%r15
  80014d:	00 00 00 
  800150:	eb 54                	jmp    8001a6 <umain+0xa6>
        cat(0, "<stdin>");
  800152:	48 be 3f 30 80 00 00 	movabs $0x80303f,%rsi
  800159:	00 00 00 
  80015c:	bf 00 00 00 00       	mov    $0x0,%edi
  800161:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800168:	00 00 00 
  80016b:	ff d0                	call   *%rax
                close(f);
            }
        }
}
  80016d:	48 83 c4 08          	add    $0x8,%rsp
  800171:	5b                   	pop    %rbx
  800172:	41 5c                	pop    %r12
  800174:	41 5d                	pop    %r13
  800176:	41 5e                	pop    %r14
  800178:	41 5f                	pop    %r15
  80017a:	5d                   	pop    %rbp
  80017b:	c3                   	ret
                printf("can't open %s: %i\n", argv[i], f);
  80017c:	49 8b 34 24          	mov    (%r12),%rsi
  800180:	89 c2                	mov    %eax,%edx
  800182:	48 bf 47 30 80 00 00 	movabs $0x803047,%rdi
  800189:	00 00 00 
  80018c:	b8 00 00 00 00       	mov    $0x0,%eax
  800191:	48 b9 2a 23 80 00 00 	movabs $0x80232a,%rcx
  800198:	00 00 00 
  80019b:	ff d1                	call   *%rcx
        for (i = 1; i < argc; i++) {
  80019d:	49 83 c4 08          	add    $0x8,%r12
  8001a1:	4d 39 f4             	cmp    %r14,%r12
  8001a4:	74 c7                	je     80016d <umain+0x6d>
            f = open(argv[i], O_RDONLY);
  8001a6:	49 8b 3c 24          	mov    (%r12),%rdi
  8001aa:	be 00 00 00 00       	mov    $0x0,%esi
  8001af:	41 ff d5             	call   *%r13
  8001b2:	89 c3                	mov    %eax,%ebx
            if (f < 0)
  8001b4:	85 c0                	test   %eax,%eax
  8001b6:	78 c4                	js     80017c <umain+0x7c>
                cat(f, argv[i]);
  8001b8:	49 8b 34 24          	mov    (%r12),%rsi
  8001bc:	89 c7                	mov    %eax,%edi
  8001be:	41 ff d7             	call   *%r15
                close(f);
  8001c1:	89 df                	mov    %ebx,%edi
  8001c3:	48 b8 23 19 80 00 00 	movabs $0x801923,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	call   *%rax
  8001cf:	eb cc                	jmp    80019d <umain+0x9d>

00000000008001d1 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8001d1:	f3 0f 1e fa          	endbr64
  8001d5:	55                   	push   %rbp
  8001d6:	48 89 e5             	mov    %rsp,%rbp
  8001d9:	41 56                	push   %r14
  8001db:	41 55                	push   %r13
  8001dd:	41 54                	push   %r12
  8001df:	53                   	push   %rbx
  8001e0:	41 89 fd             	mov    %edi,%r13d
  8001e3:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8001e6:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8001ed:	00 00 00 
  8001f0:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  8001f7:	00 00 00 
  8001fa:	48 39 c2             	cmp    %rax,%rdx
  8001fd:	73 17                	jae    800216 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8001ff:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800202:	49 89 c4             	mov    %rax,%r12
  800205:	48 83 c3 08          	add    $0x8,%rbx
  800209:	b8 00 00 00 00       	mov    $0x0,%eax
  80020e:	ff 53 f8             	call   *-0x8(%rbx)
  800211:	4c 39 e3             	cmp    %r12,%rbx
  800214:	72 ef                	jb     800205 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800216:	48 b8 84 12 80 00 00 	movabs $0x801284,%rax
  80021d:	00 00 00 
  800220:	ff d0                	call   *%rax
  800222:	25 ff 03 00 00       	and    $0x3ff,%eax
  800227:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80022b:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80022f:	48 c1 e0 04          	shl    $0x4,%rax
  800233:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  80023a:	00 00 00 
  80023d:	48 01 d0             	add    %rdx,%rax
  800240:	48 a3 00 70 80 00 00 	movabs %rax,0x807000
  800247:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80024a:	45 85 ed             	test   %r13d,%r13d
  80024d:	7e 0d                	jle    80025c <libmain+0x8b>
  80024f:	49 8b 06             	mov    (%r14),%rax
  800252:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800259:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80025c:	4c 89 f6             	mov    %r14,%rsi
  80025f:	44 89 ef             	mov    %r13d,%edi
  800262:	48 b8 00 01 80 00 00 	movabs $0x800100,%rax
  800269:	00 00 00 
  80026c:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80026e:	48 b8 83 02 80 00 00 	movabs $0x800283,%rax
  800275:	00 00 00 
  800278:	ff d0                	call   *%rax
#endif
}
  80027a:	5b                   	pop    %rbx
  80027b:	41 5c                	pop    %r12
  80027d:	41 5d                	pop    %r13
  80027f:	41 5e                	pop    %r14
  800281:	5d                   	pop    %rbp
  800282:	c3                   	ret

0000000000800283 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800283:	f3 0f 1e fa          	endbr64
  800287:	55                   	push   %rbp
  800288:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80028b:	48 b8 5a 19 80 00 00 	movabs $0x80195a,%rax
  800292:	00 00 00 
  800295:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800297:	bf 00 00 00 00       	mov    $0x0,%edi
  80029c:	48 b8 15 12 80 00 00 	movabs $0x801215,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	call   *%rax
}
  8002a8:	5d                   	pop    %rbp
  8002a9:	c3                   	ret

00000000008002aa <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8002aa:	f3 0f 1e fa          	endbr64
  8002ae:	55                   	push   %rbp
  8002af:	48 89 e5             	mov    %rsp,%rbp
  8002b2:	41 56                	push   %r14
  8002b4:	41 55                	push   %r13
  8002b6:	41 54                	push   %r12
  8002b8:	53                   	push   %rbx
  8002b9:	48 83 ec 50          	sub    $0x50,%rsp
  8002bd:	49 89 fc             	mov    %rdi,%r12
  8002c0:	41 89 f5             	mov    %esi,%r13d
  8002c3:	48 89 d3             	mov    %rdx,%rbx
  8002c6:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8002ca:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8002ce:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8002d2:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8002d9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002dd:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8002e1:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8002e5:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8002e9:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8002f0:	00 00 00 
  8002f3:	4c 8b 30             	mov    (%rax),%r14
  8002f6:	48 b8 84 12 80 00 00 	movabs $0x801284,%rax
  8002fd:	00 00 00 
  800300:	ff d0                	call   *%rax
  800302:	89 c6                	mov    %eax,%esi
  800304:	45 89 e8             	mov    %r13d,%r8d
  800307:	4c 89 e1             	mov    %r12,%rcx
  80030a:	4c 89 f2             	mov    %r14,%rdx
  80030d:	48 bf b0 32 80 00 00 	movabs $0x8032b0,%rdi
  800314:	00 00 00 
  800317:	b8 00 00 00 00       	mov    $0x0,%eax
  80031c:	49 bc 06 04 80 00 00 	movabs $0x800406,%r12
  800323:	00 00 00 
  800326:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800329:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  80032d:	48 89 df             	mov    %rbx,%rdi
  800330:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  800337:	00 00 00 
  80033a:	ff d0                	call   *%rax
    cprintf("\n");
  80033c:	48 bf 1b 32 80 00 00 	movabs $0x80321b,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80034e:	cc                   	int3
  80034f:	eb fd                	jmp    80034e <_panic+0xa4>

0000000000800351 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800351:	f3 0f 1e fa          	endbr64
  800355:	55                   	push   %rbp
  800356:	48 89 e5             	mov    %rsp,%rbp
  800359:	53                   	push   %rbx
  80035a:	48 83 ec 08          	sub    $0x8,%rsp
  80035e:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800361:	8b 06                	mov    (%rsi),%eax
  800363:	8d 50 01             	lea    0x1(%rax),%edx
  800366:	89 16                	mov    %edx,(%rsi)
  800368:	48 98                	cltq
  80036a:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80036f:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800375:	74 0a                	je     800381 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800377:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80037b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80037f:	c9                   	leave
  800380:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800381:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800385:	be ff 00 00 00       	mov    $0xff,%esi
  80038a:	48 b8 af 11 80 00 00 	movabs $0x8011af,%rax
  800391:	00 00 00 
  800394:	ff d0                	call   *%rax
        state->offset = 0;
  800396:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80039c:	eb d9                	jmp    800377 <putch+0x26>

000000000080039e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80039e:	f3 0f 1e fa          	endbr64
  8003a2:	55                   	push   %rbp
  8003a3:	48 89 e5             	mov    %rsp,%rbp
  8003a6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8003ad:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8003b0:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8003b7:	b9 21 00 00 00       	mov    $0x21,%ecx
  8003bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c1:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8003c4:	48 89 f1             	mov    %rsi,%rcx
  8003c7:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8003ce:	48 bf 51 03 80 00 00 	movabs $0x800351,%rdi
  8003d5:	00 00 00 
  8003d8:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  8003df:	00 00 00 
  8003e2:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8003e4:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8003eb:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8003f2:	48 b8 af 11 80 00 00 	movabs $0x8011af,%rax
  8003f9:	00 00 00 
  8003fc:	ff d0                	call   *%rax

    return state.count;
}
  8003fe:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800404:	c9                   	leave
  800405:	c3                   	ret

0000000000800406 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800406:	f3 0f 1e fa          	endbr64
  80040a:	55                   	push   %rbp
  80040b:	48 89 e5             	mov    %rsp,%rbp
  80040e:	48 83 ec 50          	sub    $0x50,%rsp
  800412:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800416:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80041a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80041e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800422:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800426:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80042d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800431:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800435:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800439:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80043d:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800441:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  800448:	00 00 00 
  80044b:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80044d:	c9                   	leave
  80044e:	c3                   	ret

000000000080044f <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80044f:	f3 0f 1e fa          	endbr64
  800453:	55                   	push   %rbp
  800454:	48 89 e5             	mov    %rsp,%rbp
  800457:	41 57                	push   %r15
  800459:	41 56                	push   %r14
  80045b:	41 55                	push   %r13
  80045d:	41 54                	push   %r12
  80045f:	53                   	push   %rbx
  800460:	48 83 ec 18          	sub    $0x18,%rsp
  800464:	49 89 fc             	mov    %rdi,%r12
  800467:	49 89 f5             	mov    %rsi,%r13
  80046a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80046e:	8b 45 10             	mov    0x10(%rbp),%eax
  800471:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800474:	41 89 cf             	mov    %ecx,%r15d
  800477:	4c 39 fa             	cmp    %r15,%rdx
  80047a:	73 5b                	jae    8004d7 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80047c:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800480:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800484:	85 db                	test   %ebx,%ebx
  800486:	7e 0e                	jle    800496 <print_num+0x47>
            putch(padc, put_arg);
  800488:	4c 89 ee             	mov    %r13,%rsi
  80048b:	44 89 f7             	mov    %r14d,%edi
  80048e:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800491:	83 eb 01             	sub    $0x1,%ebx
  800494:	75 f2                	jne    800488 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800496:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80049a:	48 b9 75 30 80 00 00 	movabs $0x803075,%rcx
  8004a1:	00 00 00 
  8004a4:	48 b8 64 30 80 00 00 	movabs $0x803064,%rax
  8004ab:	00 00 00 
  8004ae:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8004b2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004bb:	49 f7 f7             	div    %r15
  8004be:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8004c2:	4c 89 ee             	mov    %r13,%rsi
  8004c5:	41 ff d4             	call   *%r12
}
  8004c8:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8004cc:	5b                   	pop    %rbx
  8004cd:	41 5c                	pop    %r12
  8004cf:	41 5d                	pop    %r13
  8004d1:	41 5e                	pop    %r14
  8004d3:	41 5f                	pop    %r15
  8004d5:	5d                   	pop    %rbp
  8004d6:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8004d7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004db:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e0:	49 f7 f7             	div    %r15
  8004e3:	48 83 ec 08          	sub    $0x8,%rsp
  8004e7:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8004eb:	52                   	push   %rdx
  8004ec:	45 0f be c9          	movsbl %r9b,%r9d
  8004f0:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8004f4:	48 89 c2             	mov    %rax,%rdx
  8004f7:	48 b8 4f 04 80 00 00 	movabs $0x80044f,%rax
  8004fe:	00 00 00 
  800501:	ff d0                	call   *%rax
  800503:	48 83 c4 10          	add    $0x10,%rsp
  800507:	eb 8d                	jmp    800496 <print_num+0x47>

0000000000800509 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800509:	f3 0f 1e fa          	endbr64
    state->count++;
  80050d:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800511:	48 8b 06             	mov    (%rsi),%rax
  800514:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800518:	73 0a                	jae    800524 <sprintputch+0x1b>
        *state->start++ = ch;
  80051a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80051e:	48 89 16             	mov    %rdx,(%rsi)
  800521:	40 88 38             	mov    %dil,(%rax)
    }
}
  800524:	c3                   	ret

0000000000800525 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800525:	f3 0f 1e fa          	endbr64
  800529:	55                   	push   %rbp
  80052a:	48 89 e5             	mov    %rsp,%rbp
  80052d:	48 83 ec 50          	sub    $0x50,%rsp
  800531:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800535:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800539:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80053d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800544:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800548:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80054c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800550:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800554:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800558:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  80055f:	00 00 00 
  800562:	ff d0                	call   *%rax
}
  800564:	c9                   	leave
  800565:	c3                   	ret

0000000000800566 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800566:	f3 0f 1e fa          	endbr64
  80056a:	55                   	push   %rbp
  80056b:	48 89 e5             	mov    %rsp,%rbp
  80056e:	41 57                	push   %r15
  800570:	41 56                	push   %r14
  800572:	41 55                	push   %r13
  800574:	41 54                	push   %r12
  800576:	53                   	push   %rbx
  800577:	48 83 ec 38          	sub    $0x38,%rsp
  80057b:	49 89 fe             	mov    %rdi,%r14
  80057e:	49 89 f5             	mov    %rsi,%r13
  800581:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800584:	48 8b 01             	mov    (%rcx),%rax
  800587:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80058b:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80058f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800593:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800597:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80059b:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80059f:	0f b6 3b             	movzbl (%rbx),%edi
  8005a2:	40 80 ff 25          	cmp    $0x25,%dil
  8005a6:	74 18                	je     8005c0 <vprintfmt+0x5a>
            if (!ch) return;
  8005a8:	40 84 ff             	test   %dil,%dil
  8005ab:	0f 84 b2 06 00 00    	je     800c63 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8005b1:	40 0f b6 ff          	movzbl %dil,%edi
  8005b5:	4c 89 ee             	mov    %r13,%rsi
  8005b8:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8005bb:	4c 89 e3             	mov    %r12,%rbx
  8005be:	eb db                	jmp    80059b <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8005c0:	be 00 00 00 00       	mov    $0x0,%esi
  8005c5:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8005c9:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8005ce:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8005d4:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8005db:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8005df:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8005e4:	41 0f b6 04 24       	movzbl (%r12),%eax
  8005e9:	88 45 a0             	mov    %al,-0x60(%rbp)
  8005ec:	83 e8 23             	sub    $0x23,%eax
  8005ef:	3c 57                	cmp    $0x57,%al
  8005f1:	0f 87 52 06 00 00    	ja     800c49 <vprintfmt+0x6e3>
  8005f7:	0f b6 c0             	movzbl %al,%eax
  8005fa:	48 b9 a0 33 80 00 00 	movabs $0x8033a0,%rcx
  800601:	00 00 00 
  800604:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800608:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  80060b:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  80060f:	eb ce                	jmp    8005df <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800611:	49 89 dc             	mov    %rbx,%r12
  800614:	be 01 00 00 00       	mov    $0x1,%esi
  800619:	eb c4                	jmp    8005df <vprintfmt+0x79>
            padc = ch;
  80061b:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  80061f:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800622:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800625:	eb b8                	jmp    8005df <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800627:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80062a:	83 f8 2f             	cmp    $0x2f,%eax
  80062d:	77 24                	ja     800653 <vprintfmt+0xed>
  80062f:	89 c1                	mov    %eax,%ecx
  800631:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800635:	83 c0 08             	add    $0x8,%eax
  800638:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80063b:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  80063e:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800641:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800645:	79 98                	jns    8005df <vprintfmt+0x79>
                width = precision;
  800647:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  80064b:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800651:	eb 8c                	jmp    8005df <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800653:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800657:	48 8d 41 08          	lea    0x8(%rcx),%rax
  80065b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80065f:	eb da                	jmp    80063b <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800661:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800666:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80066a:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800670:	3c 39                	cmp    $0x39,%al
  800672:	77 1c                	ja     800690 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800674:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800678:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80067c:	0f b6 c0             	movzbl %al,%eax
  80067f:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800684:	0f b6 03             	movzbl (%rbx),%eax
  800687:	3c 39                	cmp    $0x39,%al
  800689:	76 e9                	jbe    800674 <vprintfmt+0x10e>
        process_precision:
  80068b:	49 89 dc             	mov    %rbx,%r12
  80068e:	eb b1                	jmp    800641 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800690:	49 89 dc             	mov    %rbx,%r12
  800693:	eb ac                	jmp    800641 <vprintfmt+0xdb>
            width = MAX(0, width);
  800695:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800698:	85 c9                	test   %ecx,%ecx
  80069a:	b8 00 00 00 00       	mov    $0x0,%eax
  80069f:	0f 49 c1             	cmovns %ecx,%eax
  8006a2:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8006a5:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8006a8:	e9 32 ff ff ff       	jmp    8005df <vprintfmt+0x79>
            lflag++;
  8006ad:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8006b0:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8006b3:	e9 27 ff ff ff       	jmp    8005df <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8006b8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006bb:	83 f8 2f             	cmp    $0x2f,%eax
  8006be:	77 19                	ja     8006d9 <vprintfmt+0x173>
  8006c0:	89 c2                	mov    %eax,%edx
  8006c2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006c6:	83 c0 08             	add    $0x8,%eax
  8006c9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006cc:	8b 3a                	mov    (%rdx),%edi
  8006ce:	4c 89 ee             	mov    %r13,%rsi
  8006d1:	41 ff d6             	call   *%r14
            break;
  8006d4:	e9 c2 fe ff ff       	jmp    80059b <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8006d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006dd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006e1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006e5:	eb e5                	jmp    8006cc <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8006e7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006ea:	83 f8 2f             	cmp    $0x2f,%eax
  8006ed:	77 5a                	ja     800749 <vprintfmt+0x1e3>
  8006ef:	89 c2                	mov    %eax,%edx
  8006f1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006f5:	83 c0 08             	add    $0x8,%eax
  8006f8:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8006fb:	8b 02                	mov    (%rdx),%eax
  8006fd:	89 c1                	mov    %eax,%ecx
  8006ff:	f7 d9                	neg    %ecx
  800701:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800704:	83 f9 13             	cmp    $0x13,%ecx
  800707:	7f 4e                	jg     800757 <vprintfmt+0x1f1>
  800709:	48 63 c1             	movslq %ecx,%rax
  80070c:	48 ba 60 36 80 00 00 	movabs $0x803660,%rdx
  800713:	00 00 00 
  800716:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80071a:	48 85 c0             	test   %rax,%rax
  80071d:	74 38                	je     800757 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  80071f:	48 89 c1             	mov    %rax,%rcx
  800722:	48 ba 69 32 80 00 00 	movabs $0x803269,%rdx
  800729:	00 00 00 
  80072c:	4c 89 ee             	mov    %r13,%rsi
  80072f:	4c 89 f7             	mov    %r14,%rdi
  800732:	b8 00 00 00 00       	mov    $0x0,%eax
  800737:	49 b8 25 05 80 00 00 	movabs $0x800525,%r8
  80073e:	00 00 00 
  800741:	41 ff d0             	call   *%r8
  800744:	e9 52 fe ff ff       	jmp    80059b <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800749:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80074d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800751:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800755:	eb a4                	jmp    8006fb <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800757:	48 ba 8d 30 80 00 00 	movabs $0x80308d,%rdx
  80075e:	00 00 00 
  800761:	4c 89 ee             	mov    %r13,%rsi
  800764:	4c 89 f7             	mov    %r14,%rdi
  800767:	b8 00 00 00 00       	mov    $0x0,%eax
  80076c:	49 b8 25 05 80 00 00 	movabs $0x800525,%r8
  800773:	00 00 00 
  800776:	41 ff d0             	call   *%r8
  800779:	e9 1d fe ff ff       	jmp    80059b <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80077e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800781:	83 f8 2f             	cmp    $0x2f,%eax
  800784:	77 6c                	ja     8007f2 <vprintfmt+0x28c>
  800786:	89 c2                	mov    %eax,%edx
  800788:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80078c:	83 c0 08             	add    $0x8,%eax
  80078f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800792:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800795:	48 85 d2             	test   %rdx,%rdx
  800798:	48 b8 86 30 80 00 00 	movabs $0x803086,%rax
  80079f:	00 00 00 
  8007a2:	48 0f 45 c2          	cmovne %rdx,%rax
  8007a6:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8007aa:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8007ae:	7e 06                	jle    8007b6 <vprintfmt+0x250>
  8007b0:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8007b4:	75 4a                	jne    800800 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8007b6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8007ba:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8007be:	0f b6 00             	movzbl (%rax),%eax
  8007c1:	84 c0                	test   %al,%al
  8007c3:	0f 85 9a 00 00 00    	jne    800863 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8007c9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007cc:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	0f 8e c3 fd ff ff    	jle    80059b <vprintfmt+0x35>
  8007d8:	4c 89 ee             	mov    %r13,%rsi
  8007db:	bf 20 00 00 00       	mov    $0x20,%edi
  8007e0:	41 ff d6             	call   *%r14
  8007e3:	41 83 ec 01          	sub    $0x1,%r12d
  8007e7:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8007eb:	75 eb                	jne    8007d8 <vprintfmt+0x272>
  8007ed:	e9 a9 fd ff ff       	jmp    80059b <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8007f2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007f6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007fa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007fe:	eb 92                	jmp    800792 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800800:	49 63 f7             	movslq %r15d,%rsi
  800803:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800807:	48 b8 29 0d 80 00 00 	movabs $0x800d29,%rax
  80080e:	00 00 00 
  800811:	ff d0                	call   *%rax
  800813:	48 89 c2             	mov    %rax,%rdx
  800816:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800819:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80081b:	8d 70 ff             	lea    -0x1(%rax),%esi
  80081e:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800821:	85 c0                	test   %eax,%eax
  800823:	7e 91                	jle    8007b6 <vprintfmt+0x250>
  800825:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80082a:	4c 89 ee             	mov    %r13,%rsi
  80082d:	44 89 e7             	mov    %r12d,%edi
  800830:	41 ff d6             	call   *%r14
  800833:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800837:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80083a:	83 f8 ff             	cmp    $0xffffffff,%eax
  80083d:	75 eb                	jne    80082a <vprintfmt+0x2c4>
  80083f:	e9 72 ff ff ff       	jmp    8007b6 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800844:	0f b6 f8             	movzbl %al,%edi
  800847:	4c 89 ee             	mov    %r13,%rsi
  80084a:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80084d:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800851:	49 83 c4 01          	add    $0x1,%r12
  800855:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  80085b:	84 c0                	test   %al,%al
  80085d:	0f 84 66 ff ff ff    	je     8007c9 <vprintfmt+0x263>
  800863:	45 85 ff             	test   %r15d,%r15d
  800866:	78 0a                	js     800872 <vprintfmt+0x30c>
  800868:	41 83 ef 01          	sub    $0x1,%r15d
  80086c:	0f 88 57 ff ff ff    	js     8007c9 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800872:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800876:	74 cc                	je     800844 <vprintfmt+0x2de>
  800878:	8d 50 e0             	lea    -0x20(%rax),%edx
  80087b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800880:	80 fa 5e             	cmp    $0x5e,%dl
  800883:	77 c2                	ja     800847 <vprintfmt+0x2e1>
  800885:	eb bd                	jmp    800844 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800887:	40 84 f6             	test   %sil,%sil
  80088a:	75 26                	jne    8008b2 <vprintfmt+0x34c>
    switch (lflag) {
  80088c:	85 d2                	test   %edx,%edx
  80088e:	74 59                	je     8008e9 <vprintfmt+0x383>
  800890:	83 fa 01             	cmp    $0x1,%edx
  800893:	74 7b                	je     800910 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800895:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800898:	83 f8 2f             	cmp    $0x2f,%eax
  80089b:	0f 87 96 00 00 00    	ja     800937 <vprintfmt+0x3d1>
  8008a1:	89 c2                	mov    %eax,%edx
  8008a3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008a7:	83 c0 08             	add    $0x8,%eax
  8008aa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008ad:	4c 8b 22             	mov    (%rdx),%r12
  8008b0:	eb 17                	jmp    8008c9 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8008b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b5:	83 f8 2f             	cmp    $0x2f,%eax
  8008b8:	77 21                	ja     8008db <vprintfmt+0x375>
  8008ba:	89 c2                	mov    %eax,%edx
  8008bc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008c0:	83 c0 08             	add    $0x8,%eax
  8008c3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008c6:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8008c9:	4d 85 e4             	test   %r12,%r12
  8008cc:	78 7a                	js     800948 <vprintfmt+0x3e2>
            num = i;
  8008ce:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8008d1:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8008d6:	e9 50 02 00 00       	jmp    800b2b <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8008db:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008df:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008e3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008e7:	eb dd                	jmp    8008c6 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8008e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ec:	83 f8 2f             	cmp    $0x2f,%eax
  8008ef:	77 11                	ja     800902 <vprintfmt+0x39c>
  8008f1:	89 c2                	mov    %eax,%edx
  8008f3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008f7:	83 c0 08             	add    $0x8,%eax
  8008fa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008fd:	4c 63 22             	movslq (%rdx),%r12
  800900:	eb c7                	jmp    8008c9 <vprintfmt+0x363>
  800902:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800906:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80090a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80090e:	eb ed                	jmp    8008fd <vprintfmt+0x397>
        return va_arg(*ap, long);
  800910:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800913:	83 f8 2f             	cmp    $0x2f,%eax
  800916:	77 11                	ja     800929 <vprintfmt+0x3c3>
  800918:	89 c2                	mov    %eax,%edx
  80091a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80091e:	83 c0 08             	add    $0x8,%eax
  800921:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800924:	4c 8b 22             	mov    (%rdx),%r12
  800927:	eb a0                	jmp    8008c9 <vprintfmt+0x363>
  800929:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80092d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800931:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800935:	eb ed                	jmp    800924 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800937:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80093b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80093f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800943:	e9 65 ff ff ff       	jmp    8008ad <vprintfmt+0x347>
                putch('-', put_arg);
  800948:	4c 89 ee             	mov    %r13,%rsi
  80094b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800950:	41 ff d6             	call   *%r14
                i = -i;
  800953:	49 f7 dc             	neg    %r12
  800956:	e9 73 ff ff ff       	jmp    8008ce <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  80095b:	40 84 f6             	test   %sil,%sil
  80095e:	75 32                	jne    800992 <vprintfmt+0x42c>
    switch (lflag) {
  800960:	85 d2                	test   %edx,%edx
  800962:	74 5d                	je     8009c1 <vprintfmt+0x45b>
  800964:	83 fa 01             	cmp    $0x1,%edx
  800967:	0f 84 82 00 00 00    	je     8009ef <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  80096d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800970:	83 f8 2f             	cmp    $0x2f,%eax
  800973:	0f 87 a5 00 00 00    	ja     800a1e <vprintfmt+0x4b8>
  800979:	89 c2                	mov    %eax,%edx
  80097b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80097f:	83 c0 08             	add    $0x8,%eax
  800982:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800985:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800988:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80098d:	e9 99 01 00 00       	jmp    800b2b <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800992:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800995:	83 f8 2f             	cmp    $0x2f,%eax
  800998:	77 19                	ja     8009b3 <vprintfmt+0x44d>
  80099a:	89 c2                	mov    %eax,%edx
  80099c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009a0:	83 c0 08             	add    $0x8,%eax
  8009a3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009a6:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8009a9:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009ae:	e9 78 01 00 00       	jmp    800b2b <vprintfmt+0x5c5>
  8009b3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009b7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009bb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009bf:	eb e5                	jmp    8009a6 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8009c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c4:	83 f8 2f             	cmp    $0x2f,%eax
  8009c7:	77 18                	ja     8009e1 <vprintfmt+0x47b>
  8009c9:	89 c2                	mov    %eax,%edx
  8009cb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009cf:	83 c0 08             	add    $0x8,%eax
  8009d2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d5:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8009d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8009dc:	e9 4a 01 00 00       	jmp    800b2b <vprintfmt+0x5c5>
  8009e1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009e9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ed:	eb e6                	jmp    8009d5 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8009ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f2:	83 f8 2f             	cmp    $0x2f,%eax
  8009f5:	77 19                	ja     800a10 <vprintfmt+0x4aa>
  8009f7:	89 c2                	mov    %eax,%edx
  8009f9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009fd:	83 c0 08             	add    $0x8,%eax
  800a00:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a03:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800a06:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800a0b:	e9 1b 01 00 00       	jmp    800b2b <vprintfmt+0x5c5>
  800a10:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a14:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a18:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a1c:	eb e5                	jmp    800a03 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800a1e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a22:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a26:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a2a:	e9 56 ff ff ff       	jmp    800985 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800a2f:	40 84 f6             	test   %sil,%sil
  800a32:	75 2e                	jne    800a62 <vprintfmt+0x4fc>
    switch (lflag) {
  800a34:	85 d2                	test   %edx,%edx
  800a36:	74 59                	je     800a91 <vprintfmt+0x52b>
  800a38:	83 fa 01             	cmp    $0x1,%edx
  800a3b:	74 7f                	je     800abc <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800a3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a40:	83 f8 2f             	cmp    $0x2f,%eax
  800a43:	0f 87 9f 00 00 00    	ja     800ae8 <vprintfmt+0x582>
  800a49:	89 c2                	mov    %eax,%edx
  800a4b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a4f:	83 c0 08             	add    $0x8,%eax
  800a52:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a55:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a58:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800a5d:	e9 c9 00 00 00       	jmp    800b2b <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a62:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a65:	83 f8 2f             	cmp    $0x2f,%eax
  800a68:	77 19                	ja     800a83 <vprintfmt+0x51d>
  800a6a:	89 c2                	mov    %eax,%edx
  800a6c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a70:	83 c0 08             	add    $0x8,%eax
  800a73:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a76:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a79:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a7e:	e9 a8 00 00 00       	jmp    800b2b <vprintfmt+0x5c5>
  800a83:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a87:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a8b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a8f:	eb e5                	jmp    800a76 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800a91:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a94:	83 f8 2f             	cmp    $0x2f,%eax
  800a97:	77 15                	ja     800aae <vprintfmt+0x548>
  800a99:	89 c2                	mov    %eax,%edx
  800a9b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a9f:	83 c0 08             	add    $0x8,%eax
  800aa2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aa5:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800aa7:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800aac:	eb 7d                	jmp    800b2b <vprintfmt+0x5c5>
  800aae:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ab2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ab6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aba:	eb e9                	jmp    800aa5 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800abc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800abf:	83 f8 2f             	cmp    $0x2f,%eax
  800ac2:	77 16                	ja     800ada <vprintfmt+0x574>
  800ac4:	89 c2                	mov    %eax,%edx
  800ac6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aca:	83 c0 08             	add    $0x8,%eax
  800acd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ad0:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800ad3:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800ad8:	eb 51                	jmp    800b2b <vprintfmt+0x5c5>
  800ada:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ade:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ae2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ae6:	eb e8                	jmp    800ad0 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800ae8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aec:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800af0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800af4:	e9 5c ff ff ff       	jmp    800a55 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800af9:	4c 89 ee             	mov    %r13,%rsi
  800afc:	bf 30 00 00 00       	mov    $0x30,%edi
  800b01:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800b04:	4c 89 ee             	mov    %r13,%rsi
  800b07:	bf 78 00 00 00       	mov    $0x78,%edi
  800b0c:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800b0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b12:	83 f8 2f             	cmp    $0x2f,%eax
  800b15:	77 47                	ja     800b5e <vprintfmt+0x5f8>
  800b17:	89 c2                	mov    %eax,%edx
  800b19:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b1d:	83 c0 08             	add    $0x8,%eax
  800b20:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b23:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b26:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800b2b:	48 83 ec 08          	sub    $0x8,%rsp
  800b2f:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800b33:	0f 94 c0             	sete   %al
  800b36:	0f b6 c0             	movzbl %al,%eax
  800b39:	50                   	push   %rax
  800b3a:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800b3f:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800b43:	4c 89 ee             	mov    %r13,%rsi
  800b46:	4c 89 f7             	mov    %r14,%rdi
  800b49:	48 b8 4f 04 80 00 00 	movabs $0x80044f,%rax
  800b50:	00 00 00 
  800b53:	ff d0                	call   *%rax
            break;
  800b55:	48 83 c4 10          	add    $0x10,%rsp
  800b59:	e9 3d fa ff ff       	jmp    80059b <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800b5e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b62:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b66:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b6a:	eb b7                	jmp    800b23 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800b6c:	40 84 f6             	test   %sil,%sil
  800b6f:	75 2b                	jne    800b9c <vprintfmt+0x636>
    switch (lflag) {
  800b71:	85 d2                	test   %edx,%edx
  800b73:	74 56                	je     800bcb <vprintfmt+0x665>
  800b75:	83 fa 01             	cmp    $0x1,%edx
  800b78:	74 7f                	je     800bf9 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800b7a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7d:	83 f8 2f             	cmp    $0x2f,%eax
  800b80:	0f 87 a2 00 00 00    	ja     800c28 <vprintfmt+0x6c2>
  800b86:	89 c2                	mov    %eax,%edx
  800b88:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b8c:	83 c0 08             	add    $0x8,%eax
  800b8f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b92:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b95:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800b9a:	eb 8f                	jmp    800b2b <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9f:	83 f8 2f             	cmp    $0x2f,%eax
  800ba2:	77 19                	ja     800bbd <vprintfmt+0x657>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800baa:	83 c0 08             	add    $0x8,%eax
  800bad:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bb0:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800bb3:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800bb8:	e9 6e ff ff ff       	jmp    800b2b <vprintfmt+0x5c5>
  800bbd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bc1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bc5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bc9:	eb e5                	jmp    800bb0 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800bcb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bce:	83 f8 2f             	cmp    $0x2f,%eax
  800bd1:	77 18                	ja     800beb <vprintfmt+0x685>
  800bd3:	89 c2                	mov    %eax,%edx
  800bd5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bd9:	83 c0 08             	add    $0x8,%eax
  800bdc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bdf:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800be1:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800be6:	e9 40 ff ff ff       	jmp    800b2b <vprintfmt+0x5c5>
  800beb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bef:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bf3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bf7:	eb e6                	jmp    800bdf <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800bf9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bfc:	83 f8 2f             	cmp    $0x2f,%eax
  800bff:	77 19                	ja     800c1a <vprintfmt+0x6b4>
  800c01:	89 c2                	mov    %eax,%edx
  800c03:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c07:	83 c0 08             	add    $0x8,%eax
  800c0a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c0d:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c10:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800c15:	e9 11 ff ff ff       	jmp    800b2b <vprintfmt+0x5c5>
  800c1a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c1e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c22:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c26:	eb e5                	jmp    800c0d <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800c28:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c2c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c30:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c34:	e9 59 ff ff ff       	jmp    800b92 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800c39:	4c 89 ee             	mov    %r13,%rsi
  800c3c:	bf 25 00 00 00       	mov    $0x25,%edi
  800c41:	41 ff d6             	call   *%r14
            break;
  800c44:	e9 52 f9 ff ff       	jmp    80059b <vprintfmt+0x35>
            putch('%', put_arg);
  800c49:	4c 89 ee             	mov    %r13,%rsi
  800c4c:	bf 25 00 00 00       	mov    $0x25,%edi
  800c51:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800c54:	48 83 eb 01          	sub    $0x1,%rbx
  800c58:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800c5c:	75 f6                	jne    800c54 <vprintfmt+0x6ee>
  800c5e:	e9 38 f9 ff ff       	jmp    80059b <vprintfmt+0x35>
}
  800c63:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800c67:	5b                   	pop    %rbx
  800c68:	41 5c                	pop    %r12
  800c6a:	41 5d                	pop    %r13
  800c6c:	41 5e                	pop    %r14
  800c6e:	41 5f                	pop    %r15
  800c70:	5d                   	pop    %rbp
  800c71:	c3                   	ret

0000000000800c72 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800c72:	f3 0f 1e fa          	endbr64
  800c76:	55                   	push   %rbp
  800c77:	48 89 e5             	mov    %rsp,%rbp
  800c7a:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800c7e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c82:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800c87:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800c8b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800c92:	48 85 ff             	test   %rdi,%rdi
  800c95:	74 2b                	je     800cc2 <vsnprintf+0x50>
  800c97:	48 85 f6             	test   %rsi,%rsi
  800c9a:	74 26                	je     800cc2 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800c9c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800ca0:	48 bf 09 05 80 00 00 	movabs $0x800509,%rdi
  800ca7:	00 00 00 
  800caa:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  800cb1:	00 00 00 
  800cb4:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800cb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cba:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800cbd:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800cc0:	c9                   	leave
  800cc1:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800cc2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cc7:	eb f7                	jmp    800cc0 <vsnprintf+0x4e>

0000000000800cc9 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800cc9:	f3 0f 1e fa          	endbr64
  800ccd:	55                   	push   %rbp
  800cce:	48 89 e5             	mov    %rsp,%rbp
  800cd1:	48 83 ec 50          	sub    $0x50,%rsp
  800cd5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800cd9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800cdd:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800ce1:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800ce8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cec:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cf0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cf4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800cf8:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800cfc:	48 b8 72 0c 80 00 00 	movabs $0x800c72,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800d08:	c9                   	leave
  800d09:	c3                   	ret

0000000000800d0a <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800d0a:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800d0e:	80 3f 00             	cmpb   $0x0,(%rdi)
  800d11:	74 10                	je     800d23 <strlen+0x19>
    size_t n = 0;
  800d13:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800d18:	48 83 c0 01          	add    $0x1,%rax
  800d1c:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800d20:	75 f6                	jne    800d18 <strlen+0xe>
  800d22:	c3                   	ret
    size_t n = 0;
  800d23:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800d28:	c3                   	ret

0000000000800d29 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800d29:	f3 0f 1e fa          	endbr64
  800d2d:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800d30:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800d35:	48 85 f6             	test   %rsi,%rsi
  800d38:	74 10                	je     800d4a <strnlen+0x21>
  800d3a:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800d3e:	74 0b                	je     800d4b <strnlen+0x22>
  800d40:	48 83 c2 01          	add    $0x1,%rdx
  800d44:	48 39 d0             	cmp    %rdx,%rax
  800d47:	75 f1                	jne    800d3a <strnlen+0x11>
  800d49:	c3                   	ret
  800d4a:	c3                   	ret
  800d4b:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800d4e:	c3                   	ret

0000000000800d4f <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800d4f:	f3 0f 1e fa          	endbr64
  800d53:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800d56:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5b:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800d5f:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800d62:	48 83 c2 01          	add    $0x1,%rdx
  800d66:	84 c9                	test   %cl,%cl
  800d68:	75 f1                	jne    800d5b <strcpy+0xc>
        ;
    return res;
}
  800d6a:	c3                   	ret

0000000000800d6b <strcat>:

char *
strcat(char *dst, const char *src) {
  800d6b:	f3 0f 1e fa          	endbr64
  800d6f:	55                   	push   %rbp
  800d70:	48 89 e5             	mov    %rsp,%rbp
  800d73:	41 54                	push   %r12
  800d75:	53                   	push   %rbx
  800d76:	48 89 fb             	mov    %rdi,%rbx
  800d79:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800d7c:	48 b8 0a 0d 80 00 00 	movabs $0x800d0a,%rax
  800d83:	00 00 00 
  800d86:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800d88:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800d8c:	4c 89 e6             	mov    %r12,%rsi
  800d8f:	48 b8 4f 0d 80 00 00 	movabs $0x800d4f,%rax
  800d96:	00 00 00 
  800d99:	ff d0                	call   *%rax
    return dst;
}
  800d9b:	48 89 d8             	mov    %rbx,%rax
  800d9e:	5b                   	pop    %rbx
  800d9f:	41 5c                	pop    %r12
  800da1:	5d                   	pop    %rbp
  800da2:	c3                   	ret

0000000000800da3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800da3:	f3 0f 1e fa          	endbr64
  800da7:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800daa:	48 85 d2             	test   %rdx,%rdx
  800dad:	74 1f                	je     800dce <strncpy+0x2b>
  800daf:	48 01 fa             	add    %rdi,%rdx
  800db2:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800db5:	48 83 c1 01          	add    $0x1,%rcx
  800db9:	44 0f b6 06          	movzbl (%rsi),%r8d
  800dbd:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800dc1:	41 80 f8 01          	cmp    $0x1,%r8b
  800dc5:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800dc9:	48 39 ca             	cmp    %rcx,%rdx
  800dcc:	75 e7                	jne    800db5 <strncpy+0x12>
    }
    return ret;
}
  800dce:	c3                   	ret

0000000000800dcf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800dcf:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800dd3:	48 89 f8             	mov    %rdi,%rax
  800dd6:	48 85 d2             	test   %rdx,%rdx
  800dd9:	74 24                	je     800dff <strlcpy+0x30>
        while (--size > 0 && *src)
  800ddb:	48 83 ea 01          	sub    $0x1,%rdx
  800ddf:	74 1b                	je     800dfc <strlcpy+0x2d>
  800de1:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800de5:	0f b6 16             	movzbl (%rsi),%edx
  800de8:	84 d2                	test   %dl,%dl
  800dea:	74 10                	je     800dfc <strlcpy+0x2d>
            *dst++ = *src++;
  800dec:	48 83 c6 01          	add    $0x1,%rsi
  800df0:	48 83 c0 01          	add    $0x1,%rax
  800df4:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800df7:	48 39 c8             	cmp    %rcx,%rax
  800dfa:	75 e9                	jne    800de5 <strlcpy+0x16>
        *dst = '\0';
  800dfc:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800dff:	48 29 f8             	sub    %rdi,%rax
}
  800e02:	c3                   	ret

0000000000800e03 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800e03:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800e07:	0f b6 07             	movzbl (%rdi),%eax
  800e0a:	84 c0                	test   %al,%al
  800e0c:	74 13                	je     800e21 <strcmp+0x1e>
  800e0e:	38 06                	cmp    %al,(%rsi)
  800e10:	75 0f                	jne    800e21 <strcmp+0x1e>
  800e12:	48 83 c7 01          	add    $0x1,%rdi
  800e16:	48 83 c6 01          	add    $0x1,%rsi
  800e1a:	0f b6 07             	movzbl (%rdi),%eax
  800e1d:	84 c0                	test   %al,%al
  800e1f:	75 ed                	jne    800e0e <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800e21:	0f b6 c0             	movzbl %al,%eax
  800e24:	0f b6 16             	movzbl (%rsi),%edx
  800e27:	29 d0                	sub    %edx,%eax
}
  800e29:	c3                   	ret

0000000000800e2a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800e2a:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800e2e:	48 85 d2             	test   %rdx,%rdx
  800e31:	74 1f                	je     800e52 <strncmp+0x28>
  800e33:	0f b6 07             	movzbl (%rdi),%eax
  800e36:	84 c0                	test   %al,%al
  800e38:	74 1e                	je     800e58 <strncmp+0x2e>
  800e3a:	3a 06                	cmp    (%rsi),%al
  800e3c:	75 1a                	jne    800e58 <strncmp+0x2e>
  800e3e:	48 83 c7 01          	add    $0x1,%rdi
  800e42:	48 83 c6 01          	add    $0x1,%rsi
  800e46:	48 83 ea 01          	sub    $0x1,%rdx
  800e4a:	75 e7                	jne    800e33 <strncmp+0x9>

    if (!n) return 0;
  800e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e51:	c3                   	ret
  800e52:	b8 00 00 00 00       	mov    $0x0,%eax
  800e57:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800e58:	0f b6 07             	movzbl (%rdi),%eax
  800e5b:	0f b6 16             	movzbl (%rsi),%edx
  800e5e:	29 d0                	sub    %edx,%eax
}
  800e60:	c3                   	ret

0000000000800e61 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800e61:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800e65:	0f b6 17             	movzbl (%rdi),%edx
  800e68:	84 d2                	test   %dl,%dl
  800e6a:	74 18                	je     800e84 <strchr+0x23>
        if (*str == c) {
  800e6c:	0f be d2             	movsbl %dl,%edx
  800e6f:	39 f2                	cmp    %esi,%edx
  800e71:	74 17                	je     800e8a <strchr+0x29>
    for (; *str; str++) {
  800e73:	48 83 c7 01          	add    $0x1,%rdi
  800e77:	0f b6 17             	movzbl (%rdi),%edx
  800e7a:	84 d2                	test   %dl,%dl
  800e7c:	75 ee                	jne    800e6c <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e83:	c3                   	ret
  800e84:	b8 00 00 00 00       	mov    $0x0,%eax
  800e89:	c3                   	ret
            return (char *)str;
  800e8a:	48 89 f8             	mov    %rdi,%rax
}
  800e8d:	c3                   	ret

0000000000800e8e <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800e8e:	f3 0f 1e fa          	endbr64
  800e92:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800e95:	0f b6 17             	movzbl (%rdi),%edx
  800e98:	84 d2                	test   %dl,%dl
  800e9a:	74 13                	je     800eaf <strfind+0x21>
  800e9c:	0f be d2             	movsbl %dl,%edx
  800e9f:	39 f2                	cmp    %esi,%edx
  800ea1:	74 0b                	je     800eae <strfind+0x20>
  800ea3:	48 83 c0 01          	add    $0x1,%rax
  800ea7:	0f b6 10             	movzbl (%rax),%edx
  800eaa:	84 d2                	test   %dl,%dl
  800eac:	75 ee                	jne    800e9c <strfind+0xe>
        ;
    return (char *)str;
}
  800eae:	c3                   	ret
  800eaf:	c3                   	ret

0000000000800eb0 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800eb0:	f3 0f 1e fa          	endbr64
  800eb4:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800eb7:	48 89 f8             	mov    %rdi,%rax
  800eba:	48 f7 d8             	neg    %rax
  800ebd:	83 e0 07             	and    $0x7,%eax
  800ec0:	49 89 d1             	mov    %rdx,%r9
  800ec3:	49 29 c1             	sub    %rax,%r9
  800ec6:	78 36                	js     800efe <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800ec8:	40 0f b6 c6          	movzbl %sil,%eax
  800ecc:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800ed3:	01 01 01 
  800ed6:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800eda:	40 f6 c7 07          	test   $0x7,%dil
  800ede:	75 38                	jne    800f18 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800ee0:	4c 89 c9             	mov    %r9,%rcx
  800ee3:	48 c1 f9 03          	sar    $0x3,%rcx
  800ee7:	74 0c                	je     800ef5 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800ee9:	fc                   	cld
  800eea:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800eed:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800ef1:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800ef5:	4d 85 c9             	test   %r9,%r9
  800ef8:	75 45                	jne    800f3f <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800efa:	4c 89 c0             	mov    %r8,%rax
  800efd:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800efe:	48 85 d2             	test   %rdx,%rdx
  800f01:	74 f7                	je     800efa <memset+0x4a>
  800f03:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800f06:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800f09:	48 83 c0 01          	add    $0x1,%rax
  800f0d:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800f11:	48 39 c2             	cmp    %rax,%rdx
  800f14:	75 f3                	jne    800f09 <memset+0x59>
  800f16:	eb e2                	jmp    800efa <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800f18:	40 f6 c7 01          	test   $0x1,%dil
  800f1c:	74 06                	je     800f24 <memset+0x74>
  800f1e:	88 07                	mov    %al,(%rdi)
  800f20:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f24:	40 f6 c7 02          	test   $0x2,%dil
  800f28:	74 07                	je     800f31 <memset+0x81>
  800f2a:	66 89 07             	mov    %ax,(%rdi)
  800f2d:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800f31:	40 f6 c7 04          	test   $0x4,%dil
  800f35:	74 a9                	je     800ee0 <memset+0x30>
  800f37:	89 07                	mov    %eax,(%rdi)
  800f39:	48 83 c7 04          	add    $0x4,%rdi
  800f3d:	eb a1                	jmp    800ee0 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800f3f:	41 f6 c1 04          	test   $0x4,%r9b
  800f43:	74 1b                	je     800f60 <memset+0xb0>
  800f45:	89 07                	mov    %eax,(%rdi)
  800f47:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f4b:	41 f6 c1 02          	test   $0x2,%r9b
  800f4f:	74 07                	je     800f58 <memset+0xa8>
  800f51:	66 89 07             	mov    %ax,(%rdi)
  800f54:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800f58:	41 f6 c1 01          	test   $0x1,%r9b
  800f5c:	74 9c                	je     800efa <memset+0x4a>
  800f5e:	eb 06                	jmp    800f66 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f60:	41 f6 c1 02          	test   $0x2,%r9b
  800f64:	75 eb                	jne    800f51 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800f66:	88 07                	mov    %al,(%rdi)
  800f68:	eb 90                	jmp    800efa <memset+0x4a>

0000000000800f6a <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800f6a:	f3 0f 1e fa          	endbr64
  800f6e:	48 89 f8             	mov    %rdi,%rax
  800f71:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800f74:	48 39 fe             	cmp    %rdi,%rsi
  800f77:	73 3b                	jae    800fb4 <memmove+0x4a>
  800f79:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800f7d:	48 39 d7             	cmp    %rdx,%rdi
  800f80:	73 32                	jae    800fb4 <memmove+0x4a>
        s += n;
        d += n;
  800f82:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f86:	48 89 d6             	mov    %rdx,%rsi
  800f89:	48 09 fe             	or     %rdi,%rsi
  800f8c:	48 09 ce             	or     %rcx,%rsi
  800f8f:	40 f6 c6 07          	test   $0x7,%sil
  800f93:	75 12                	jne    800fa7 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800f95:	48 83 ef 08          	sub    $0x8,%rdi
  800f99:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800f9d:	48 c1 e9 03          	shr    $0x3,%rcx
  800fa1:	fd                   	std
  800fa2:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800fa5:	fc                   	cld
  800fa6:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800fa7:	48 83 ef 01          	sub    $0x1,%rdi
  800fab:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800faf:	fd                   	std
  800fb0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800fb2:	eb f1                	jmp    800fa5 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800fb4:	48 89 f2             	mov    %rsi,%rdx
  800fb7:	48 09 c2             	or     %rax,%rdx
  800fba:	48 09 ca             	or     %rcx,%rdx
  800fbd:	f6 c2 07             	test   $0x7,%dl
  800fc0:	75 0c                	jne    800fce <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800fc2:	48 c1 e9 03          	shr    $0x3,%rcx
  800fc6:	48 89 c7             	mov    %rax,%rdi
  800fc9:	fc                   	cld
  800fca:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800fcd:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800fce:	48 89 c7             	mov    %rax,%rdi
  800fd1:	fc                   	cld
  800fd2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800fd4:	c3                   	ret

0000000000800fd5 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800fd5:	f3 0f 1e fa          	endbr64
  800fd9:	55                   	push   %rbp
  800fda:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800fdd:	48 b8 6a 0f 80 00 00 	movabs $0x800f6a,%rax
  800fe4:	00 00 00 
  800fe7:	ff d0                	call   *%rax
}
  800fe9:	5d                   	pop    %rbp
  800fea:	c3                   	ret

0000000000800feb <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800feb:	f3 0f 1e fa          	endbr64
  800fef:	55                   	push   %rbp
  800ff0:	48 89 e5             	mov    %rsp,%rbp
  800ff3:	41 57                	push   %r15
  800ff5:	41 56                	push   %r14
  800ff7:	41 55                	push   %r13
  800ff9:	41 54                	push   %r12
  800ffb:	53                   	push   %rbx
  800ffc:	48 83 ec 08          	sub    $0x8,%rsp
  801000:	49 89 fe             	mov    %rdi,%r14
  801003:	49 89 f7             	mov    %rsi,%r15
  801006:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801009:	48 89 f7             	mov    %rsi,%rdi
  80100c:	48 b8 0a 0d 80 00 00 	movabs $0x800d0a,%rax
  801013:	00 00 00 
  801016:	ff d0                	call   *%rax
  801018:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80101b:	48 89 de             	mov    %rbx,%rsi
  80101e:	4c 89 f7             	mov    %r14,%rdi
  801021:	48 b8 29 0d 80 00 00 	movabs $0x800d29,%rax
  801028:	00 00 00 
  80102b:	ff d0                	call   *%rax
  80102d:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801030:	48 39 c3             	cmp    %rax,%rbx
  801033:	74 36                	je     80106b <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  801035:	48 89 d8             	mov    %rbx,%rax
  801038:	4c 29 e8             	sub    %r13,%rax
  80103b:	49 39 c4             	cmp    %rax,%r12
  80103e:	73 31                	jae    801071 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  801040:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801045:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801049:	4c 89 fe             	mov    %r15,%rsi
  80104c:	48 b8 d5 0f 80 00 00 	movabs $0x800fd5,%rax
  801053:	00 00 00 
  801056:	ff d0                	call   *%rax
    return dstlen + srclen;
  801058:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80105c:	48 83 c4 08          	add    $0x8,%rsp
  801060:	5b                   	pop    %rbx
  801061:	41 5c                	pop    %r12
  801063:	41 5d                	pop    %r13
  801065:	41 5e                	pop    %r14
  801067:	41 5f                	pop    %r15
  801069:	5d                   	pop    %rbp
  80106a:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  80106b:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  80106f:	eb eb                	jmp    80105c <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  801071:	48 83 eb 01          	sub    $0x1,%rbx
  801075:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801079:	48 89 da             	mov    %rbx,%rdx
  80107c:	4c 89 fe             	mov    %r15,%rsi
  80107f:	48 b8 d5 0f 80 00 00 	movabs $0x800fd5,%rax
  801086:	00 00 00 
  801089:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  80108b:	49 01 de             	add    %rbx,%r14
  80108e:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801093:	eb c3                	jmp    801058 <strlcat+0x6d>

0000000000801095 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801095:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801099:	48 85 d2             	test   %rdx,%rdx
  80109c:	74 2d                	je     8010cb <memcmp+0x36>
  80109e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8010a3:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8010a7:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8010ac:	44 38 c1             	cmp    %r8b,%cl
  8010af:	75 0f                	jne    8010c0 <memcmp+0x2b>
    while (n-- > 0) {
  8010b1:	48 83 c0 01          	add    $0x1,%rax
  8010b5:	48 39 c2             	cmp    %rax,%rdx
  8010b8:	75 e9                	jne    8010a3 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8010ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8010bf:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8010c0:	0f b6 c1             	movzbl %cl,%eax
  8010c3:	45 0f b6 c0          	movzbl %r8b,%r8d
  8010c7:	44 29 c0             	sub    %r8d,%eax
  8010ca:	c3                   	ret
    return 0;
  8010cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d0:	c3                   	ret

00000000008010d1 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8010d1:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  8010d5:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8010d9:	48 39 c7             	cmp    %rax,%rdi
  8010dc:	73 0f                	jae    8010ed <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8010de:	40 38 37             	cmp    %sil,(%rdi)
  8010e1:	74 0e                	je     8010f1 <memfind+0x20>
    for (; src < end; src++) {
  8010e3:	48 83 c7 01          	add    $0x1,%rdi
  8010e7:	48 39 f8             	cmp    %rdi,%rax
  8010ea:	75 f2                	jne    8010de <memfind+0xd>
  8010ec:	c3                   	ret
  8010ed:	48 89 f8             	mov    %rdi,%rax
  8010f0:	c3                   	ret
  8010f1:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8010f4:	c3                   	ret

00000000008010f5 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8010f5:	f3 0f 1e fa          	endbr64
  8010f9:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8010fc:	0f b6 37             	movzbl (%rdi),%esi
  8010ff:	40 80 fe 20          	cmp    $0x20,%sil
  801103:	74 06                	je     80110b <strtol+0x16>
  801105:	40 80 fe 09          	cmp    $0x9,%sil
  801109:	75 13                	jne    80111e <strtol+0x29>
  80110b:	48 83 c7 01          	add    $0x1,%rdi
  80110f:	0f b6 37             	movzbl (%rdi),%esi
  801112:	40 80 fe 20          	cmp    $0x20,%sil
  801116:	74 f3                	je     80110b <strtol+0x16>
  801118:	40 80 fe 09          	cmp    $0x9,%sil
  80111c:	74 ed                	je     80110b <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  80111e:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801121:	83 e0 fd             	and    $0xfffffffd,%eax
  801124:	3c 01                	cmp    $0x1,%al
  801126:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80112a:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  801130:	75 0f                	jne    801141 <strtol+0x4c>
  801132:	80 3f 30             	cmpb   $0x30,(%rdi)
  801135:	74 14                	je     80114b <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801137:	85 d2                	test   %edx,%edx
  801139:	b8 0a 00 00 00       	mov    $0xa,%eax
  80113e:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801141:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801146:	4c 63 ca             	movslq %edx,%r9
  801149:	eb 36                	jmp    801181 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80114b:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80114f:	74 0f                	je     801160 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801151:	85 d2                	test   %edx,%edx
  801153:	75 ec                	jne    801141 <strtol+0x4c>
        s++;
  801155:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801159:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  80115e:	eb e1                	jmp    801141 <strtol+0x4c>
        s += 2;
  801160:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801164:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801169:	eb d6                	jmp    801141 <strtol+0x4c>
            dig -= '0';
  80116b:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  80116e:	44 0f b6 c1          	movzbl %cl,%r8d
  801172:	41 39 d0             	cmp    %edx,%r8d
  801175:	7d 21                	jge    801198 <strtol+0xa3>
        val = val * base + dig;
  801177:	49 0f af c1          	imul   %r9,%rax
  80117b:	0f b6 c9             	movzbl %cl,%ecx
  80117e:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  801181:	48 83 c7 01          	add    $0x1,%rdi
  801185:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801189:	80 f9 39             	cmp    $0x39,%cl
  80118c:	76 dd                	jbe    80116b <strtol+0x76>
        else if (dig - 'a' < 27)
  80118e:	80 f9 7b             	cmp    $0x7b,%cl
  801191:	77 05                	ja     801198 <strtol+0xa3>
            dig -= 'a' - 10;
  801193:	83 e9 57             	sub    $0x57,%ecx
  801196:	eb d6                	jmp    80116e <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801198:	4d 85 d2             	test   %r10,%r10
  80119b:	74 03                	je     8011a0 <strtol+0xab>
  80119d:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8011a0:	48 89 c2             	mov    %rax,%rdx
  8011a3:	48 f7 da             	neg    %rdx
  8011a6:	40 80 fe 2d          	cmp    $0x2d,%sil
  8011aa:	48 0f 44 c2          	cmove  %rdx,%rax
}
  8011ae:	c3                   	ret

00000000008011af <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8011af:	f3 0f 1e fa          	endbr64
  8011b3:	55                   	push   %rbp
  8011b4:	48 89 e5             	mov    %rsp,%rbp
  8011b7:	53                   	push   %rbx
  8011b8:	48 89 fa             	mov    %rdi,%rdx
  8011bb:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8011be:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011cd:	be 00 00 00 00       	mov    $0x0,%esi
  8011d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011d8:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8011da:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011de:	c9                   	leave
  8011df:	c3                   	ret

00000000008011e0 <sys_cgetc>:

int
sys_cgetc(void) {
  8011e0:	f3 0f 1e fa          	endbr64
  8011e4:	55                   	push   %rbp
  8011e5:	48 89 e5             	mov    %rsp,%rbp
  8011e8:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011e9:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8011f3:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011fd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801202:	be 00 00 00 00       	mov    $0x0,%esi
  801207:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80120d:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80120f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801213:	c9                   	leave
  801214:	c3                   	ret

0000000000801215 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801215:	f3 0f 1e fa          	endbr64
  801219:	55                   	push   %rbp
  80121a:	48 89 e5             	mov    %rsp,%rbp
  80121d:	53                   	push   %rbx
  80121e:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801222:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801225:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80122a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80122f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801234:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801239:	be 00 00 00 00       	mov    $0x0,%esi
  80123e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801244:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801246:	48 85 c0             	test   %rax,%rax
  801249:	7f 06                	jg     801251 <sys_env_destroy+0x3c>
}
  80124b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80124f:	c9                   	leave
  801250:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801251:	49 89 c0             	mov    %rax,%r8
  801254:	b9 03 00 00 00       	mov    $0x3,%ecx
  801259:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  801260:	00 00 00 
  801263:	be 26 00 00 00       	mov    $0x26,%esi
  801268:	48 bf f3 31 80 00 00 	movabs $0x8031f3,%rdi
  80126f:	00 00 00 
  801272:	b8 00 00 00 00       	mov    $0x0,%eax
  801277:	49 b9 aa 02 80 00 00 	movabs $0x8002aa,%r9
  80127e:	00 00 00 
  801281:	41 ff d1             	call   *%r9

0000000000801284 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801284:	f3 0f 1e fa          	endbr64
  801288:	55                   	push   %rbp
  801289:	48 89 e5             	mov    %rsp,%rbp
  80128c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80128d:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801292:	ba 00 00 00 00       	mov    $0x0,%edx
  801297:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80129c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012a6:	be 00 00 00 00       	mov    $0x0,%esi
  8012ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012b1:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8012b3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012b7:	c9                   	leave
  8012b8:	c3                   	ret

00000000008012b9 <sys_yield>:

void
sys_yield(void) {
  8012b9:	f3 0f 1e fa          	endbr64
  8012bd:	55                   	push   %rbp
  8012be:	48 89 e5             	mov    %rsp,%rbp
  8012c1:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8012c2:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8012cc:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012d6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012db:	be 00 00 00 00       	mov    $0x0,%esi
  8012e0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012e6:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8012e8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012ec:	c9                   	leave
  8012ed:	c3                   	ret

00000000008012ee <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8012ee:	f3 0f 1e fa          	endbr64
  8012f2:	55                   	push   %rbp
  8012f3:	48 89 e5             	mov    %rsp,%rbp
  8012f6:	53                   	push   %rbx
  8012f7:	48 89 fa             	mov    %rdi,%rdx
  8012fa:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8012fd:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801302:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801309:	00 00 00 
  80130c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801311:	be 00 00 00 00       	mov    $0x0,%esi
  801316:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80131c:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80131e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801322:	c9                   	leave
  801323:	c3                   	ret

0000000000801324 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801324:	f3 0f 1e fa          	endbr64
  801328:	55                   	push   %rbp
  801329:	48 89 e5             	mov    %rsp,%rbp
  80132c:	53                   	push   %rbx
  80132d:	49 89 f8             	mov    %rdi,%r8
  801330:	48 89 d3             	mov    %rdx,%rbx
  801333:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801336:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80133b:	4c 89 c2             	mov    %r8,%rdx
  80133e:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801341:	be 00 00 00 00       	mov    $0x0,%esi
  801346:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80134c:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80134e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801352:	c9                   	leave
  801353:	c3                   	ret

0000000000801354 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801354:	f3 0f 1e fa          	endbr64
  801358:	55                   	push   %rbp
  801359:	48 89 e5             	mov    %rsp,%rbp
  80135c:	53                   	push   %rbx
  80135d:	48 83 ec 08          	sub    $0x8,%rsp
  801361:	89 f8                	mov    %edi,%eax
  801363:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801366:	48 63 f9             	movslq %ecx,%rdi
  801369:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80136c:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801371:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801374:	be 00 00 00 00       	mov    $0x0,%esi
  801379:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80137f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801381:	48 85 c0             	test   %rax,%rax
  801384:	7f 06                	jg     80138c <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801386:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80138a:	c9                   	leave
  80138b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80138c:	49 89 c0             	mov    %rax,%r8
  80138f:	b9 04 00 00 00       	mov    $0x4,%ecx
  801394:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  80139b:	00 00 00 
  80139e:	be 26 00 00 00       	mov    $0x26,%esi
  8013a3:	48 bf f3 31 80 00 00 	movabs $0x8031f3,%rdi
  8013aa:	00 00 00 
  8013ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b2:	49 b9 aa 02 80 00 00 	movabs $0x8002aa,%r9
  8013b9:	00 00 00 
  8013bc:	41 ff d1             	call   *%r9

00000000008013bf <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8013bf:	f3 0f 1e fa          	endbr64
  8013c3:	55                   	push   %rbp
  8013c4:	48 89 e5             	mov    %rsp,%rbp
  8013c7:	53                   	push   %rbx
  8013c8:	48 83 ec 08          	sub    $0x8,%rsp
  8013cc:	89 f8                	mov    %edi,%eax
  8013ce:	49 89 f2             	mov    %rsi,%r10
  8013d1:	48 89 cf             	mov    %rcx,%rdi
  8013d4:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8013d7:	48 63 da             	movslq %edx,%rbx
  8013da:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013dd:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013e2:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e5:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8013e8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013ea:	48 85 c0             	test   %rax,%rax
  8013ed:	7f 06                	jg     8013f5 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8013ef:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013f3:	c9                   	leave
  8013f4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013f5:	49 89 c0             	mov    %rax,%r8
  8013f8:	b9 05 00 00 00       	mov    $0x5,%ecx
  8013fd:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  801404:	00 00 00 
  801407:	be 26 00 00 00       	mov    $0x26,%esi
  80140c:	48 bf f3 31 80 00 00 	movabs $0x8031f3,%rdi
  801413:	00 00 00 
  801416:	b8 00 00 00 00       	mov    $0x0,%eax
  80141b:	49 b9 aa 02 80 00 00 	movabs $0x8002aa,%r9
  801422:	00 00 00 
  801425:	41 ff d1             	call   *%r9

0000000000801428 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801428:	f3 0f 1e fa          	endbr64
  80142c:	55                   	push   %rbp
  80142d:	48 89 e5             	mov    %rsp,%rbp
  801430:	53                   	push   %rbx
  801431:	48 83 ec 08          	sub    $0x8,%rsp
  801435:	49 89 f9             	mov    %rdi,%r9
  801438:	89 f0                	mov    %esi,%eax
  80143a:	48 89 d3             	mov    %rdx,%rbx
  80143d:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801440:	49 63 f0             	movslq %r8d,%rsi
  801443:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801446:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80144b:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80144e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801454:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801456:	48 85 c0             	test   %rax,%rax
  801459:	7f 06                	jg     801461 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80145b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80145f:	c9                   	leave
  801460:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801461:	49 89 c0             	mov    %rax,%r8
  801464:	b9 06 00 00 00       	mov    $0x6,%ecx
  801469:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  801470:	00 00 00 
  801473:	be 26 00 00 00       	mov    $0x26,%esi
  801478:	48 bf f3 31 80 00 00 	movabs $0x8031f3,%rdi
  80147f:	00 00 00 
  801482:	b8 00 00 00 00       	mov    $0x0,%eax
  801487:	49 b9 aa 02 80 00 00 	movabs $0x8002aa,%r9
  80148e:	00 00 00 
  801491:	41 ff d1             	call   *%r9

0000000000801494 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801494:	f3 0f 1e fa          	endbr64
  801498:	55                   	push   %rbp
  801499:	48 89 e5             	mov    %rsp,%rbp
  80149c:	53                   	push   %rbx
  80149d:	48 83 ec 08          	sub    $0x8,%rsp
  8014a1:	48 89 f1             	mov    %rsi,%rcx
  8014a4:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8014a7:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014aa:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014af:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014b4:	be 00 00 00 00       	mov    $0x0,%esi
  8014b9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014bf:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014c1:	48 85 c0             	test   %rax,%rax
  8014c4:	7f 06                	jg     8014cc <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8014c6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014ca:	c9                   	leave
  8014cb:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014cc:	49 89 c0             	mov    %rax,%r8
  8014cf:	b9 07 00 00 00       	mov    $0x7,%ecx
  8014d4:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  8014db:	00 00 00 
  8014de:	be 26 00 00 00       	mov    $0x26,%esi
  8014e3:	48 bf f3 31 80 00 00 	movabs $0x8031f3,%rdi
  8014ea:	00 00 00 
  8014ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f2:	49 b9 aa 02 80 00 00 	movabs $0x8002aa,%r9
  8014f9:	00 00 00 
  8014fc:	41 ff d1             	call   *%r9

00000000008014ff <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8014ff:	f3 0f 1e fa          	endbr64
  801503:	55                   	push   %rbp
  801504:	48 89 e5             	mov    %rsp,%rbp
  801507:	53                   	push   %rbx
  801508:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80150c:	48 63 ce             	movslq %esi,%rcx
  80150f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801512:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801517:	bb 00 00 00 00       	mov    $0x0,%ebx
  80151c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801521:	be 00 00 00 00       	mov    $0x0,%esi
  801526:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80152c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80152e:	48 85 c0             	test   %rax,%rax
  801531:	7f 06                	jg     801539 <sys_env_set_status+0x3a>
}
  801533:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801537:	c9                   	leave
  801538:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801539:	49 89 c0             	mov    %rax,%r8
  80153c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801541:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  801548:	00 00 00 
  80154b:	be 26 00 00 00       	mov    $0x26,%esi
  801550:	48 bf f3 31 80 00 00 	movabs $0x8031f3,%rdi
  801557:	00 00 00 
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
  80155f:	49 b9 aa 02 80 00 00 	movabs $0x8002aa,%r9
  801566:	00 00 00 
  801569:	41 ff d1             	call   *%r9

000000000080156c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80156c:	f3 0f 1e fa          	endbr64
  801570:	55                   	push   %rbp
  801571:	48 89 e5             	mov    %rsp,%rbp
  801574:	53                   	push   %rbx
  801575:	48 83 ec 08          	sub    $0x8,%rsp
  801579:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80157c:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80157f:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801584:	bb 00 00 00 00       	mov    $0x0,%ebx
  801589:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80158e:	be 00 00 00 00       	mov    $0x0,%esi
  801593:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801599:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80159b:	48 85 c0             	test   %rax,%rax
  80159e:	7f 06                	jg     8015a6 <sys_env_set_trapframe+0x3a>
}
  8015a0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015a4:	c9                   	leave
  8015a5:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015a6:	49 89 c0             	mov    %rax,%r8
  8015a9:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8015ae:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  8015b5:	00 00 00 
  8015b8:	be 26 00 00 00       	mov    $0x26,%esi
  8015bd:	48 bf f3 31 80 00 00 	movabs $0x8031f3,%rdi
  8015c4:	00 00 00 
  8015c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015cc:	49 b9 aa 02 80 00 00 	movabs $0x8002aa,%r9
  8015d3:	00 00 00 
  8015d6:	41 ff d1             	call   *%r9

00000000008015d9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8015d9:	f3 0f 1e fa          	endbr64
  8015dd:	55                   	push   %rbp
  8015de:	48 89 e5             	mov    %rsp,%rbp
  8015e1:	53                   	push   %rbx
  8015e2:	48 83 ec 08          	sub    $0x8,%rsp
  8015e6:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8015e9:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015ec:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015f6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015fb:	be 00 00 00 00       	mov    $0x0,%esi
  801600:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801606:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801608:	48 85 c0             	test   %rax,%rax
  80160b:	7f 06                	jg     801613 <sys_env_set_pgfault_upcall+0x3a>
}
  80160d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801611:	c9                   	leave
  801612:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801613:	49 89 c0             	mov    %rax,%r8
  801616:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80161b:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  801622:	00 00 00 
  801625:	be 26 00 00 00       	mov    $0x26,%esi
  80162a:	48 bf f3 31 80 00 00 	movabs $0x8031f3,%rdi
  801631:	00 00 00 
  801634:	b8 00 00 00 00       	mov    $0x0,%eax
  801639:	49 b9 aa 02 80 00 00 	movabs $0x8002aa,%r9
  801640:	00 00 00 
  801643:	41 ff d1             	call   *%r9

0000000000801646 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801646:	f3 0f 1e fa          	endbr64
  80164a:	55                   	push   %rbp
  80164b:	48 89 e5             	mov    %rsp,%rbp
  80164e:	53                   	push   %rbx
  80164f:	89 f8                	mov    %edi,%eax
  801651:	49 89 f1             	mov    %rsi,%r9
  801654:	48 89 d3             	mov    %rdx,%rbx
  801657:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80165a:	49 63 f0             	movslq %r8d,%rsi
  80165d:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801660:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801665:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801668:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80166e:	cd 30                	int    $0x30
}
  801670:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801674:	c9                   	leave
  801675:	c3                   	ret

0000000000801676 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801676:	f3 0f 1e fa          	endbr64
  80167a:	55                   	push   %rbp
  80167b:	48 89 e5             	mov    %rsp,%rbp
  80167e:	53                   	push   %rbx
  80167f:	48 83 ec 08          	sub    $0x8,%rsp
  801683:	48 89 fa             	mov    %rdi,%rdx
  801686:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801689:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80168e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801693:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801698:	be 00 00 00 00       	mov    $0x0,%esi
  80169d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016a3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016a5:	48 85 c0             	test   %rax,%rax
  8016a8:	7f 06                	jg     8016b0 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8016aa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016ae:	c9                   	leave
  8016af:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016b0:	49 89 c0             	mov    %rax,%r8
  8016b3:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8016b8:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  8016bf:	00 00 00 
  8016c2:	be 26 00 00 00       	mov    $0x26,%esi
  8016c7:	48 bf f3 31 80 00 00 	movabs $0x8031f3,%rdi
  8016ce:	00 00 00 
  8016d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d6:	49 b9 aa 02 80 00 00 	movabs $0x8002aa,%r9
  8016dd:	00 00 00 
  8016e0:	41 ff d1             	call   *%r9

00000000008016e3 <sys_gettime>:

int
sys_gettime(void) {
  8016e3:	f3 0f 1e fa          	endbr64
  8016e7:	55                   	push   %rbp
  8016e8:	48 89 e5             	mov    %rsp,%rbp
  8016eb:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8016ec:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8016f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801700:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801705:	be 00 00 00 00       	mov    $0x0,%esi
  80170a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801710:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801712:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801716:	c9                   	leave
  801717:	c3                   	ret

0000000000801718 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801718:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80171c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801723:	ff ff ff 
  801726:	48 01 f8             	add    %rdi,%rax
  801729:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80172d:	c3                   	ret

000000000080172e <fd2data>:

char *
fd2data(struct Fd *fd) {
  80172e:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801732:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801739:	ff ff ff 
  80173c:	48 01 f8             	add    %rdi,%rax
  80173f:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801743:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801749:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80174d:	c3                   	ret

000000000080174e <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80174e:	f3 0f 1e fa          	endbr64
  801752:	55                   	push   %rbp
  801753:	48 89 e5             	mov    %rsp,%rbp
  801756:	41 57                	push   %r15
  801758:	41 56                	push   %r14
  80175a:	41 55                	push   %r13
  80175c:	41 54                	push   %r12
  80175e:	53                   	push   %rbx
  80175f:	48 83 ec 08          	sub    $0x8,%rsp
  801763:	49 89 ff             	mov    %rdi,%r15
  801766:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80176b:	49 bd 65 2a 80 00 00 	movabs $0x802a65,%r13
  801772:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801775:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  80177b:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  80177e:	48 89 df             	mov    %rbx,%rdi
  801781:	41 ff d5             	call   *%r13
  801784:	83 e0 04             	and    $0x4,%eax
  801787:	74 17                	je     8017a0 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801789:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801790:	4c 39 f3             	cmp    %r14,%rbx
  801793:	75 e6                	jne    80177b <fd_alloc+0x2d>
  801795:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  80179b:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8017a0:	4d 89 27             	mov    %r12,(%r15)
}
  8017a3:	48 83 c4 08          	add    $0x8,%rsp
  8017a7:	5b                   	pop    %rbx
  8017a8:	41 5c                	pop    %r12
  8017aa:	41 5d                	pop    %r13
  8017ac:	41 5e                	pop    %r14
  8017ae:	41 5f                	pop    %r15
  8017b0:	5d                   	pop    %rbp
  8017b1:	c3                   	ret

00000000008017b2 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8017b2:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8017b6:	83 ff 1f             	cmp    $0x1f,%edi
  8017b9:	77 39                	ja     8017f4 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8017bb:	55                   	push   %rbp
  8017bc:	48 89 e5             	mov    %rsp,%rbp
  8017bf:	41 54                	push   %r12
  8017c1:	53                   	push   %rbx
  8017c2:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8017c5:	48 63 df             	movslq %edi,%rbx
  8017c8:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8017cf:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8017d3:	48 89 df             	mov    %rbx,%rdi
  8017d6:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  8017dd:	00 00 00 
  8017e0:	ff d0                	call   *%rax
  8017e2:	a8 04                	test   $0x4,%al
  8017e4:	74 14                	je     8017fa <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8017e6:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ef:	5b                   	pop    %rbx
  8017f0:	41 5c                	pop    %r12
  8017f2:	5d                   	pop    %rbp
  8017f3:	c3                   	ret
        return -E_INVAL;
  8017f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017f9:	c3                   	ret
        return -E_INVAL;
  8017fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ff:	eb ee                	jmp    8017ef <fd_lookup+0x3d>

0000000000801801 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801801:	f3 0f 1e fa          	endbr64
  801805:	55                   	push   %rbp
  801806:	48 89 e5             	mov    %rsp,%rbp
  801809:	41 54                	push   %r12
  80180b:	53                   	push   %rbx
  80180c:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  80180f:	48 b8 00 37 80 00 00 	movabs $0x803700,%rax
  801816:	00 00 00 
  801819:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  801820:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801823:	39 3b                	cmp    %edi,(%rbx)
  801825:	74 47                	je     80186e <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801827:	48 83 c0 08          	add    $0x8,%rax
  80182b:	48 8b 18             	mov    (%rax),%rbx
  80182e:	48 85 db             	test   %rbx,%rbx
  801831:	75 f0                	jne    801823 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801833:	48 a1 00 70 80 00 00 	movabs 0x807000,%rax
  80183a:	00 00 00 
  80183d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801843:	89 fa                	mov    %edi,%edx
  801845:	48 bf 18 33 80 00 00 	movabs $0x803318,%rdi
  80184c:	00 00 00 
  80184f:	b8 00 00 00 00       	mov    $0x0,%eax
  801854:	48 b9 06 04 80 00 00 	movabs $0x800406,%rcx
  80185b:	00 00 00 
  80185e:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801860:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801865:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801869:	5b                   	pop    %rbx
  80186a:	41 5c                	pop    %r12
  80186c:	5d                   	pop    %rbp
  80186d:	c3                   	ret
            return 0;
  80186e:	b8 00 00 00 00       	mov    $0x0,%eax
  801873:	eb f0                	jmp    801865 <dev_lookup+0x64>

0000000000801875 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801875:	f3 0f 1e fa          	endbr64
  801879:	55                   	push   %rbp
  80187a:	48 89 e5             	mov    %rsp,%rbp
  80187d:	41 55                	push   %r13
  80187f:	41 54                	push   %r12
  801881:	53                   	push   %rbx
  801882:	48 83 ec 18          	sub    $0x18,%rsp
  801886:	48 89 fb             	mov    %rdi,%rbx
  801889:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80188c:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801893:	ff ff ff 
  801896:	48 01 df             	add    %rbx,%rdi
  801899:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80189d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018a1:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  8018a8:	00 00 00 
  8018ab:	ff d0                	call   *%rax
  8018ad:	41 89 c5             	mov    %eax,%r13d
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	78 06                	js     8018ba <fd_close+0x45>
  8018b4:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  8018b8:	74 1a                	je     8018d4 <fd_close+0x5f>
        return (must_exist ? res : 0);
  8018ba:	45 84 e4             	test   %r12b,%r12b
  8018bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c2:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8018c6:	44 89 e8             	mov    %r13d,%eax
  8018c9:	48 83 c4 18          	add    $0x18,%rsp
  8018cd:	5b                   	pop    %rbx
  8018ce:	41 5c                	pop    %r12
  8018d0:	41 5d                	pop    %r13
  8018d2:	5d                   	pop    %rbp
  8018d3:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018d4:	8b 3b                	mov    (%rbx),%edi
  8018d6:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018da:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  8018e1:	00 00 00 
  8018e4:	ff d0                	call   *%rax
  8018e6:	41 89 c5             	mov    %eax,%r13d
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	78 1b                	js     801908 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8018ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018f1:	48 8b 40 20          	mov    0x20(%rax),%rax
  8018f5:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8018fb:	48 85 c0             	test   %rax,%rax
  8018fe:	74 08                	je     801908 <fd_close+0x93>
  801900:	48 89 df             	mov    %rbx,%rdi
  801903:	ff d0                	call   *%rax
  801905:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801908:	ba 00 10 00 00       	mov    $0x1000,%edx
  80190d:	48 89 de             	mov    %rbx,%rsi
  801910:	bf 00 00 00 00       	mov    $0x0,%edi
  801915:	48 b8 94 14 80 00 00 	movabs $0x801494,%rax
  80191c:	00 00 00 
  80191f:	ff d0                	call   *%rax
    return res;
  801921:	eb a3                	jmp    8018c6 <fd_close+0x51>

0000000000801923 <close>:

int
close(int fdnum) {
  801923:	f3 0f 1e fa          	endbr64
  801927:	55                   	push   %rbp
  801928:	48 89 e5             	mov    %rsp,%rbp
  80192b:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80192f:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801933:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  80193a:	00 00 00 
  80193d:	ff d0                	call   *%rax
    if (res < 0) return res;
  80193f:	85 c0                	test   %eax,%eax
  801941:	78 15                	js     801958 <close+0x35>

    return fd_close(fd, 1);
  801943:	be 01 00 00 00       	mov    $0x1,%esi
  801948:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80194c:	48 b8 75 18 80 00 00 	movabs $0x801875,%rax
  801953:	00 00 00 
  801956:	ff d0                	call   *%rax
}
  801958:	c9                   	leave
  801959:	c3                   	ret

000000000080195a <close_all>:

void
close_all(void) {
  80195a:	f3 0f 1e fa          	endbr64
  80195e:	55                   	push   %rbp
  80195f:	48 89 e5             	mov    %rsp,%rbp
  801962:	41 54                	push   %r12
  801964:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801965:	bb 00 00 00 00       	mov    $0x0,%ebx
  80196a:	49 bc 23 19 80 00 00 	movabs $0x801923,%r12
  801971:	00 00 00 
  801974:	89 df                	mov    %ebx,%edi
  801976:	41 ff d4             	call   *%r12
  801979:	83 c3 01             	add    $0x1,%ebx
  80197c:	83 fb 20             	cmp    $0x20,%ebx
  80197f:	75 f3                	jne    801974 <close_all+0x1a>
}
  801981:	5b                   	pop    %rbx
  801982:	41 5c                	pop    %r12
  801984:	5d                   	pop    %rbp
  801985:	c3                   	ret

0000000000801986 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801986:	f3 0f 1e fa          	endbr64
  80198a:	55                   	push   %rbp
  80198b:	48 89 e5             	mov    %rsp,%rbp
  80198e:	41 57                	push   %r15
  801990:	41 56                	push   %r14
  801992:	41 55                	push   %r13
  801994:	41 54                	push   %r12
  801996:	53                   	push   %rbx
  801997:	48 83 ec 18          	sub    $0x18,%rsp
  80199b:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80199e:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8019a2:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  8019a9:	00 00 00 
  8019ac:	ff d0                	call   *%rax
  8019ae:	89 c3                	mov    %eax,%ebx
  8019b0:	85 c0                	test   %eax,%eax
  8019b2:	0f 88 b8 00 00 00    	js     801a70 <dup+0xea>
    close(newfdnum);
  8019b8:	44 89 e7             	mov    %r12d,%edi
  8019bb:	48 b8 23 19 80 00 00 	movabs $0x801923,%rax
  8019c2:	00 00 00 
  8019c5:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8019c7:	4d 63 ec             	movslq %r12d,%r13
  8019ca:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8019d1:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8019d5:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8019d9:	4c 89 ff             	mov    %r15,%rdi
  8019dc:	49 be 2e 17 80 00 00 	movabs $0x80172e,%r14
  8019e3:	00 00 00 
  8019e6:	41 ff d6             	call   *%r14
  8019e9:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8019ec:	4c 89 ef             	mov    %r13,%rdi
  8019ef:	41 ff d6             	call   *%r14
  8019f2:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8019f5:	48 89 df             	mov    %rbx,%rdi
  8019f8:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  8019ff:	00 00 00 
  801a02:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801a04:	a8 04                	test   $0x4,%al
  801a06:	74 2b                	je     801a33 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801a08:	41 89 c1             	mov    %eax,%r9d
  801a0b:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a11:	4c 89 f1             	mov    %r14,%rcx
  801a14:	ba 00 00 00 00       	mov    $0x0,%edx
  801a19:	48 89 de             	mov    %rbx,%rsi
  801a1c:	bf 00 00 00 00       	mov    $0x0,%edi
  801a21:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  801a28:	00 00 00 
  801a2b:	ff d0                	call   *%rax
  801a2d:	89 c3                	mov    %eax,%ebx
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	78 4e                	js     801a81 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801a33:	4c 89 ff             	mov    %r15,%rdi
  801a36:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  801a3d:	00 00 00 
  801a40:	ff d0                	call   *%rax
  801a42:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801a45:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a4b:	4c 89 e9             	mov    %r13,%rcx
  801a4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a53:	4c 89 fe             	mov    %r15,%rsi
  801a56:	bf 00 00 00 00       	mov    $0x0,%edi
  801a5b:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  801a62:	00 00 00 
  801a65:	ff d0                	call   *%rax
  801a67:	89 c3                	mov    %eax,%ebx
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	78 14                	js     801a81 <dup+0xfb>

    return newfdnum;
  801a6d:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801a70:	89 d8                	mov    %ebx,%eax
  801a72:	48 83 c4 18          	add    $0x18,%rsp
  801a76:	5b                   	pop    %rbx
  801a77:	41 5c                	pop    %r12
  801a79:	41 5d                	pop    %r13
  801a7b:	41 5e                	pop    %r14
  801a7d:	41 5f                	pop    %r15
  801a7f:	5d                   	pop    %rbp
  801a80:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801a81:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a86:	4c 89 ee             	mov    %r13,%rsi
  801a89:	bf 00 00 00 00       	mov    $0x0,%edi
  801a8e:	49 bc 94 14 80 00 00 	movabs $0x801494,%r12
  801a95:	00 00 00 
  801a98:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801a9b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801aa0:	4c 89 f6             	mov    %r14,%rsi
  801aa3:	bf 00 00 00 00       	mov    $0x0,%edi
  801aa8:	41 ff d4             	call   *%r12
    return res;
  801aab:	eb c3                	jmp    801a70 <dup+0xea>

0000000000801aad <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801aad:	f3 0f 1e fa          	endbr64
  801ab1:	55                   	push   %rbp
  801ab2:	48 89 e5             	mov    %rsp,%rbp
  801ab5:	41 56                	push   %r14
  801ab7:	41 55                	push   %r13
  801ab9:	41 54                	push   %r12
  801abb:	53                   	push   %rbx
  801abc:	48 83 ec 10          	sub    $0x10,%rsp
  801ac0:	89 fb                	mov    %edi,%ebx
  801ac2:	49 89 f4             	mov    %rsi,%r12
  801ac5:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ac8:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801acc:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  801ad3:	00 00 00 
  801ad6:	ff d0                	call   *%rax
  801ad8:	85 c0                	test   %eax,%eax
  801ada:	78 4c                	js     801b28 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801adc:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801ae0:	41 8b 3e             	mov    (%r14),%edi
  801ae3:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ae7:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  801aee:	00 00 00 
  801af1:	ff d0                	call   *%rax
  801af3:	85 c0                	test   %eax,%eax
  801af5:	78 35                	js     801b2c <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801af7:	41 8b 46 08          	mov    0x8(%r14),%eax
  801afb:	83 e0 03             	and    $0x3,%eax
  801afe:	83 f8 01             	cmp    $0x1,%eax
  801b01:	74 2d                	je     801b30 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801b03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b07:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b0b:	48 85 c0             	test   %rax,%rax
  801b0e:	74 56                	je     801b66 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801b10:	4c 89 ea             	mov    %r13,%rdx
  801b13:	4c 89 e6             	mov    %r12,%rsi
  801b16:	4c 89 f7             	mov    %r14,%rdi
  801b19:	ff d0                	call   *%rax
}
  801b1b:	48 83 c4 10          	add    $0x10,%rsp
  801b1f:	5b                   	pop    %rbx
  801b20:	41 5c                	pop    %r12
  801b22:	41 5d                	pop    %r13
  801b24:	41 5e                	pop    %r14
  801b26:	5d                   	pop    %rbp
  801b27:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b28:	48 98                	cltq
  801b2a:	eb ef                	jmp    801b1b <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b2c:	48 98                	cltq
  801b2e:	eb eb                	jmp    801b1b <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b30:	48 a1 00 70 80 00 00 	movabs 0x807000,%rax
  801b37:	00 00 00 
  801b3a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b40:	89 da                	mov    %ebx,%edx
  801b42:	48 bf 01 32 80 00 00 	movabs $0x803201,%rdi
  801b49:	00 00 00 
  801b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b51:	48 b9 06 04 80 00 00 	movabs $0x800406,%rcx
  801b58:	00 00 00 
  801b5b:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b5d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801b64:	eb b5                	jmp    801b1b <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801b66:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801b6d:	eb ac                	jmp    801b1b <read+0x6e>

0000000000801b6f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801b6f:	f3 0f 1e fa          	endbr64
  801b73:	55                   	push   %rbp
  801b74:	48 89 e5             	mov    %rsp,%rbp
  801b77:	41 57                	push   %r15
  801b79:	41 56                	push   %r14
  801b7b:	41 55                	push   %r13
  801b7d:	41 54                	push   %r12
  801b7f:	53                   	push   %rbx
  801b80:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801b84:	48 85 d2             	test   %rdx,%rdx
  801b87:	74 54                	je     801bdd <readn+0x6e>
  801b89:	41 89 fd             	mov    %edi,%r13d
  801b8c:	49 89 f6             	mov    %rsi,%r14
  801b8f:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801b92:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801b97:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801b9c:	49 bf ad 1a 80 00 00 	movabs $0x801aad,%r15
  801ba3:	00 00 00 
  801ba6:	4c 89 e2             	mov    %r12,%rdx
  801ba9:	48 29 f2             	sub    %rsi,%rdx
  801bac:	4c 01 f6             	add    %r14,%rsi
  801baf:	44 89 ef             	mov    %r13d,%edi
  801bb2:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	78 20                	js     801bd9 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801bb9:	01 c3                	add    %eax,%ebx
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	74 08                	je     801bc7 <readn+0x58>
  801bbf:	48 63 f3             	movslq %ebx,%rsi
  801bc2:	4c 39 e6             	cmp    %r12,%rsi
  801bc5:	72 df                	jb     801ba6 <readn+0x37>
    }
    return res;
  801bc7:	48 63 c3             	movslq %ebx,%rax
}
  801bca:	48 83 c4 08          	add    $0x8,%rsp
  801bce:	5b                   	pop    %rbx
  801bcf:	41 5c                	pop    %r12
  801bd1:	41 5d                	pop    %r13
  801bd3:	41 5e                	pop    %r14
  801bd5:	41 5f                	pop    %r15
  801bd7:	5d                   	pop    %rbp
  801bd8:	c3                   	ret
        if (inc < 0) return inc;
  801bd9:	48 98                	cltq
  801bdb:	eb ed                	jmp    801bca <readn+0x5b>
    int inc = 1, res = 0;
  801bdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801be2:	eb e3                	jmp    801bc7 <readn+0x58>

0000000000801be4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801be4:	f3 0f 1e fa          	endbr64
  801be8:	55                   	push   %rbp
  801be9:	48 89 e5             	mov    %rsp,%rbp
  801bec:	41 56                	push   %r14
  801bee:	41 55                	push   %r13
  801bf0:	41 54                	push   %r12
  801bf2:	53                   	push   %rbx
  801bf3:	48 83 ec 10          	sub    $0x10,%rsp
  801bf7:	89 fb                	mov    %edi,%ebx
  801bf9:	49 89 f4             	mov    %rsi,%r12
  801bfc:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bff:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c03:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  801c0a:	00 00 00 
  801c0d:	ff d0                	call   *%rax
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	78 47                	js     801c5a <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c13:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801c17:	41 8b 3e             	mov    (%r14),%edi
  801c1a:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c1e:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  801c25:	00 00 00 
  801c28:	ff d0                	call   *%rax
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	78 30                	js     801c5e <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c2e:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801c33:	74 2d                	je     801c62 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801c35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c39:	48 8b 40 18          	mov    0x18(%rax),%rax
  801c3d:	48 85 c0             	test   %rax,%rax
  801c40:	74 56                	je     801c98 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801c42:	4c 89 ea             	mov    %r13,%rdx
  801c45:	4c 89 e6             	mov    %r12,%rsi
  801c48:	4c 89 f7             	mov    %r14,%rdi
  801c4b:	ff d0                	call   *%rax
}
  801c4d:	48 83 c4 10          	add    $0x10,%rsp
  801c51:	5b                   	pop    %rbx
  801c52:	41 5c                	pop    %r12
  801c54:	41 5d                	pop    %r13
  801c56:	41 5e                	pop    %r14
  801c58:	5d                   	pop    %rbp
  801c59:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c5a:	48 98                	cltq
  801c5c:	eb ef                	jmp    801c4d <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c5e:	48 98                	cltq
  801c60:	eb eb                	jmp    801c4d <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c62:	48 a1 00 70 80 00 00 	movabs 0x807000,%rax
  801c69:	00 00 00 
  801c6c:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c72:	89 da                	mov    %ebx,%edx
  801c74:	48 bf 1d 32 80 00 00 	movabs $0x80321d,%rdi
  801c7b:	00 00 00 
  801c7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c83:	48 b9 06 04 80 00 00 	movabs $0x800406,%rcx
  801c8a:	00 00 00 
  801c8d:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c8f:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801c96:	eb b5                	jmp    801c4d <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801c98:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801c9f:	eb ac                	jmp    801c4d <write+0x69>

0000000000801ca1 <seek>:

int
seek(int fdnum, off_t offset) {
  801ca1:	f3 0f 1e fa          	endbr64
  801ca5:	55                   	push   %rbp
  801ca6:	48 89 e5             	mov    %rsp,%rbp
  801ca9:	53                   	push   %rbx
  801caa:	48 83 ec 18          	sub    $0x18,%rsp
  801cae:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cb0:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801cb4:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  801cbb:	00 00 00 
  801cbe:	ff d0                	call   *%rax
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	78 0c                	js     801cd0 <seek+0x2f>

    fd->fd_offset = offset;
  801cc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc8:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ccb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cd4:	c9                   	leave
  801cd5:	c3                   	ret

0000000000801cd6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801cd6:	f3 0f 1e fa          	endbr64
  801cda:	55                   	push   %rbp
  801cdb:	48 89 e5             	mov    %rsp,%rbp
  801cde:	41 55                	push   %r13
  801ce0:	41 54                	push   %r12
  801ce2:	53                   	push   %rbx
  801ce3:	48 83 ec 18          	sub    $0x18,%rsp
  801ce7:	89 fb                	mov    %edi,%ebx
  801ce9:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cec:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801cf0:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  801cf7:	00 00 00 
  801cfa:	ff d0                	call   *%rax
  801cfc:	85 c0                	test   %eax,%eax
  801cfe:	78 38                	js     801d38 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d00:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801d04:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801d08:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d0c:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  801d13:	00 00 00 
  801d16:	ff d0                	call   *%rax
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	78 1c                	js     801d38 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d1c:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801d21:	74 20                	je     801d43 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d27:	48 8b 40 30          	mov    0x30(%rax),%rax
  801d2b:	48 85 c0             	test   %rax,%rax
  801d2e:	74 47                	je     801d77 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801d30:	44 89 e6             	mov    %r12d,%esi
  801d33:	4c 89 ef             	mov    %r13,%rdi
  801d36:	ff d0                	call   *%rax
}
  801d38:	48 83 c4 18          	add    $0x18,%rsp
  801d3c:	5b                   	pop    %rbx
  801d3d:	41 5c                	pop    %r12
  801d3f:	41 5d                	pop    %r13
  801d41:	5d                   	pop    %rbp
  801d42:	c3                   	ret
                thisenv->env_id, fdnum);
  801d43:	48 a1 00 70 80 00 00 	movabs 0x807000,%rax
  801d4a:	00 00 00 
  801d4d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d53:	89 da                	mov    %ebx,%edx
  801d55:	48 bf 38 33 80 00 00 	movabs $0x803338,%rdi
  801d5c:	00 00 00 
  801d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d64:	48 b9 06 04 80 00 00 	movabs $0x800406,%rcx
  801d6b:	00 00 00 
  801d6e:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d75:	eb c1                	jmp    801d38 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d77:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d7c:	eb ba                	jmp    801d38 <ftruncate+0x62>

0000000000801d7e <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801d7e:	f3 0f 1e fa          	endbr64
  801d82:	55                   	push   %rbp
  801d83:	48 89 e5             	mov    %rsp,%rbp
  801d86:	41 54                	push   %r12
  801d88:	53                   	push   %rbx
  801d89:	48 83 ec 10          	sub    $0x10,%rsp
  801d8d:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d90:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801d94:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  801d9b:	00 00 00 
  801d9e:	ff d0                	call   *%rax
  801da0:	85 c0                	test   %eax,%eax
  801da2:	78 4e                	js     801df2 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801da4:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801da8:	41 8b 3c 24          	mov    (%r12),%edi
  801dac:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801db0:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  801db7:	00 00 00 
  801dba:	ff d0                	call   *%rax
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	78 32                	js     801df2 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801dc0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dc4:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801dc9:	74 30                	je     801dfb <fstat+0x7d>

    stat->st_name[0] = 0;
  801dcb:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801dce:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801dd5:	00 00 00 
    stat->st_isdir = 0;
  801dd8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ddf:	00 00 00 
    stat->st_dev = dev;
  801de2:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801de9:	48 89 de             	mov    %rbx,%rsi
  801dec:	4c 89 e7             	mov    %r12,%rdi
  801def:	ff 50 28             	call   *0x28(%rax)
}
  801df2:	48 83 c4 10          	add    $0x10,%rsp
  801df6:	5b                   	pop    %rbx
  801df7:	41 5c                	pop    %r12
  801df9:	5d                   	pop    %rbp
  801dfa:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801dfb:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801e00:	eb f0                	jmp    801df2 <fstat+0x74>

0000000000801e02 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801e02:	f3 0f 1e fa          	endbr64
  801e06:	55                   	push   %rbp
  801e07:	48 89 e5             	mov    %rsp,%rbp
  801e0a:	41 54                	push   %r12
  801e0c:	53                   	push   %rbx
  801e0d:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801e10:	be 00 00 00 00       	mov    $0x0,%esi
  801e15:	48 b8 e3 20 80 00 00 	movabs $0x8020e3,%rax
  801e1c:	00 00 00 
  801e1f:	ff d0                	call   *%rax
  801e21:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801e23:	85 c0                	test   %eax,%eax
  801e25:	78 25                	js     801e4c <stat+0x4a>

    int res = fstat(fd, stat);
  801e27:	4c 89 e6             	mov    %r12,%rsi
  801e2a:	89 c7                	mov    %eax,%edi
  801e2c:	48 b8 7e 1d 80 00 00 	movabs $0x801d7e,%rax
  801e33:	00 00 00 
  801e36:	ff d0                	call   *%rax
  801e38:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801e3b:	89 df                	mov    %ebx,%edi
  801e3d:	48 b8 23 19 80 00 00 	movabs $0x801923,%rax
  801e44:	00 00 00 
  801e47:	ff d0                	call   *%rax

    return res;
  801e49:	44 89 e3             	mov    %r12d,%ebx
}
  801e4c:	89 d8                	mov    %ebx,%eax
  801e4e:	5b                   	pop    %rbx
  801e4f:	41 5c                	pop    %r12
  801e51:	5d                   	pop    %rbp
  801e52:	c3                   	ret

0000000000801e53 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801e53:	f3 0f 1e fa          	endbr64
  801e57:	55                   	push   %rbp
  801e58:	48 89 e5             	mov    %rsp,%rbp
  801e5b:	41 54                	push   %r12
  801e5d:	53                   	push   %rbx
  801e5e:	48 83 ec 10          	sub    $0x10,%rsp
  801e62:	41 89 fc             	mov    %edi,%r12d
  801e65:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801e68:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  801e6f:	00 00 00 
  801e72:	83 38 00             	cmpl   $0x0,(%rax)
  801e75:	74 6e                	je     801ee5 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801e77:	bf 03 00 00 00       	mov    $0x3,%edi
  801e7c:	48 b8 92 2f 80 00 00 	movabs $0x802f92,%rax
  801e83:	00 00 00 
  801e86:	ff d0                	call   *%rax
  801e88:	a3 00 90 80 00 00 00 	movabs %eax,0x809000
  801e8f:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801e91:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801e97:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801e9c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  801ea3:	00 00 00 
  801ea6:	44 89 e6             	mov    %r12d,%esi
  801ea9:	89 c7                	mov    %eax,%edi
  801eab:	48 b8 d0 2e 80 00 00 	movabs $0x802ed0,%rax
  801eb2:	00 00 00 
  801eb5:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801eb7:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801ebe:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801ebf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ec4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ec8:	48 89 de             	mov    %rbx,%rsi
  801ecb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ed0:	48 b8 37 2e 80 00 00 	movabs $0x802e37,%rax
  801ed7:	00 00 00 
  801eda:	ff d0                	call   *%rax
}
  801edc:	48 83 c4 10          	add    $0x10,%rsp
  801ee0:	5b                   	pop    %rbx
  801ee1:	41 5c                	pop    %r12
  801ee3:	5d                   	pop    %rbp
  801ee4:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801ee5:	bf 03 00 00 00       	mov    $0x3,%edi
  801eea:	48 b8 92 2f 80 00 00 	movabs $0x802f92,%rax
  801ef1:	00 00 00 
  801ef4:	ff d0                	call   *%rax
  801ef6:	a3 00 90 80 00 00 00 	movabs %eax,0x809000
  801efd:	00 00 
  801eff:	e9 73 ff ff ff       	jmp    801e77 <fsipc+0x24>

0000000000801f04 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801f04:	f3 0f 1e fa          	endbr64
  801f08:	55                   	push   %rbp
  801f09:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f0c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801f13:	00 00 00 
  801f16:	8b 57 0c             	mov    0xc(%rdi),%edx
  801f19:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801f1b:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801f1e:	be 00 00 00 00       	mov    $0x0,%esi
  801f23:	bf 02 00 00 00       	mov    $0x2,%edi
  801f28:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  801f2f:	00 00 00 
  801f32:	ff d0                	call   *%rax
}
  801f34:	5d                   	pop    %rbp
  801f35:	c3                   	ret

0000000000801f36 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801f36:	f3 0f 1e fa          	endbr64
  801f3a:	55                   	push   %rbp
  801f3b:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f3e:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f41:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801f48:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801f4a:	be 00 00 00 00       	mov    $0x0,%esi
  801f4f:	bf 06 00 00 00       	mov    $0x6,%edi
  801f54:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  801f5b:	00 00 00 
  801f5e:	ff d0                	call   *%rax
}
  801f60:	5d                   	pop    %rbp
  801f61:	c3                   	ret

0000000000801f62 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801f62:	f3 0f 1e fa          	endbr64
  801f66:	55                   	push   %rbp
  801f67:	48 89 e5             	mov    %rsp,%rbp
  801f6a:	41 54                	push   %r12
  801f6c:	53                   	push   %rbx
  801f6d:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f70:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f73:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801f7a:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801f7c:	be 00 00 00 00       	mov    $0x0,%esi
  801f81:	bf 05 00 00 00       	mov    $0x5,%edi
  801f86:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  801f8d:	00 00 00 
  801f90:	ff d0                	call   *%rax
    if (res < 0) return res;
  801f92:	85 c0                	test   %eax,%eax
  801f94:	78 3d                	js     801fd3 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f96:	49 bc 00 80 80 00 00 	movabs $0x808000,%r12
  801f9d:	00 00 00 
  801fa0:	4c 89 e6             	mov    %r12,%rsi
  801fa3:	48 89 df             	mov    %rbx,%rdi
  801fa6:	48 b8 4f 0d 80 00 00 	movabs $0x800d4f,%rax
  801fad:	00 00 00 
  801fb0:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801fb2:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801fb9:	00 
  801fba:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801fc0:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801fc7:	00 
  801fc8:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd3:	5b                   	pop    %rbx
  801fd4:	41 5c                	pop    %r12
  801fd6:	5d                   	pop    %rbp
  801fd7:	c3                   	ret

0000000000801fd8 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801fd8:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801fdc:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801fe3:	77 41                	ja     802026 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801fe5:	55                   	push   %rbp
  801fe6:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801fe9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801ff0:	00 00 00 
  801ff3:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801ff6:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  801ff8:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801ffc:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802000:	48 b8 6a 0f 80 00 00 	movabs $0x800f6a,%rax
  802007:	00 00 00 
  80200a:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  80200c:	be 00 00 00 00       	mov    $0x0,%esi
  802011:	bf 04 00 00 00       	mov    $0x4,%edi
  802016:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  80201d:	00 00 00 
  802020:	ff d0                	call   *%rax
  802022:	48 98                	cltq
}
  802024:	5d                   	pop    %rbp
  802025:	c3                   	ret
        return -E_INVAL;
  802026:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  80202d:	c3                   	ret

000000000080202e <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80202e:	f3 0f 1e fa          	endbr64
  802032:	55                   	push   %rbp
  802033:	48 89 e5             	mov    %rsp,%rbp
  802036:	41 55                	push   %r13
  802038:	41 54                	push   %r12
  80203a:	53                   	push   %rbx
  80203b:	48 83 ec 08          	sub    $0x8,%rsp
  80203f:	49 89 f4             	mov    %rsi,%r12
  802042:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802045:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80204c:	00 00 00 
  80204f:	8b 57 0c             	mov    0xc(%rdi),%edx
  802052:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802054:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802058:	be 00 00 00 00       	mov    $0x0,%esi
  80205d:	bf 03 00 00 00       	mov    $0x3,%edi
  802062:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  802069:	00 00 00 
  80206c:	ff d0                	call   *%rax
  80206e:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802071:	4d 85 ed             	test   %r13,%r13
  802074:	78 2a                	js     8020a0 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802076:	4c 89 ea             	mov    %r13,%rdx
  802079:	4c 39 eb             	cmp    %r13,%rbx
  80207c:	72 30                	jb     8020ae <devfile_read+0x80>
  80207e:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802085:	7f 27                	jg     8020ae <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802087:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80208e:	00 00 00 
  802091:	4c 89 e7             	mov    %r12,%rdi
  802094:	48 b8 6a 0f 80 00 00 	movabs $0x800f6a,%rax
  80209b:	00 00 00 
  80209e:	ff d0                	call   *%rax
}
  8020a0:	4c 89 e8             	mov    %r13,%rax
  8020a3:	48 83 c4 08          	add    $0x8,%rsp
  8020a7:	5b                   	pop    %rbx
  8020a8:	41 5c                	pop    %r12
  8020aa:	41 5d                	pop    %r13
  8020ac:	5d                   	pop    %rbp
  8020ad:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8020ae:	48 b9 3a 32 80 00 00 	movabs $0x80323a,%rcx
  8020b5:	00 00 00 
  8020b8:	48 ba 57 32 80 00 00 	movabs $0x803257,%rdx
  8020bf:	00 00 00 
  8020c2:	be 7b 00 00 00       	mov    $0x7b,%esi
  8020c7:	48 bf 6c 32 80 00 00 	movabs $0x80326c,%rdi
  8020ce:	00 00 00 
  8020d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d6:	49 b8 aa 02 80 00 00 	movabs $0x8002aa,%r8
  8020dd:	00 00 00 
  8020e0:	41 ff d0             	call   *%r8

00000000008020e3 <open>:
open(const char *path, int mode) {
  8020e3:	f3 0f 1e fa          	endbr64
  8020e7:	55                   	push   %rbp
  8020e8:	48 89 e5             	mov    %rsp,%rbp
  8020eb:	41 55                	push   %r13
  8020ed:	41 54                	push   %r12
  8020ef:	53                   	push   %rbx
  8020f0:	48 83 ec 18          	sub    $0x18,%rsp
  8020f4:	49 89 fc             	mov    %rdi,%r12
  8020f7:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8020fa:	48 b8 0a 0d 80 00 00 	movabs $0x800d0a,%rax
  802101:	00 00 00 
  802104:	ff d0                	call   *%rax
  802106:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80210c:	0f 87 8a 00 00 00    	ja     80219c <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802112:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802116:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  80211d:	00 00 00 
  802120:	ff d0                	call   *%rax
  802122:	89 c3                	mov    %eax,%ebx
  802124:	85 c0                	test   %eax,%eax
  802126:	78 50                	js     802178 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802128:	4c 89 e6             	mov    %r12,%rsi
  80212b:	48 bb 00 80 80 00 00 	movabs $0x808000,%rbx
  802132:	00 00 00 
  802135:	48 89 df             	mov    %rbx,%rdi
  802138:	48 b8 4f 0d 80 00 00 	movabs $0x800d4f,%rax
  80213f:	00 00 00 
  802142:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802144:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80214b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80214f:	bf 01 00 00 00       	mov    $0x1,%edi
  802154:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  80215b:	00 00 00 
  80215e:	ff d0                	call   *%rax
  802160:	89 c3                	mov    %eax,%ebx
  802162:	85 c0                	test   %eax,%eax
  802164:	78 1f                	js     802185 <open+0xa2>
    return fd2num(fd);
  802166:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80216a:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  802171:	00 00 00 
  802174:	ff d0                	call   *%rax
  802176:	89 c3                	mov    %eax,%ebx
}
  802178:	89 d8                	mov    %ebx,%eax
  80217a:	48 83 c4 18          	add    $0x18,%rsp
  80217e:	5b                   	pop    %rbx
  80217f:	41 5c                	pop    %r12
  802181:	41 5d                	pop    %r13
  802183:	5d                   	pop    %rbp
  802184:	c3                   	ret
        fd_close(fd, 0);
  802185:	be 00 00 00 00       	mov    $0x0,%esi
  80218a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80218e:	48 b8 75 18 80 00 00 	movabs $0x801875,%rax
  802195:	00 00 00 
  802198:	ff d0                	call   *%rax
        return res;
  80219a:	eb dc                	jmp    802178 <open+0x95>
        return -E_BAD_PATH;
  80219c:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8021a1:	eb d5                	jmp    802178 <open+0x95>

00000000008021a3 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8021a3:	f3 0f 1e fa          	endbr64
  8021a7:	55                   	push   %rbp
  8021a8:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8021ab:	be 00 00 00 00       	mov    $0x0,%esi
  8021b0:	bf 08 00 00 00       	mov    $0x8,%edi
  8021b5:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  8021bc:	00 00 00 
  8021bf:	ff d0                	call   *%rax
}
  8021c1:	5d                   	pop    %rbp
  8021c2:	c3                   	ret

00000000008021c3 <writebuf>:
    int error;      /* First error that occurred */
    char buf[PRINTBUFSZ];
};

static void
writebuf(struct printbuf *state) {
  8021c3:	f3 0f 1e fa          	endbr64
    if (state->error > 0) {
  8021c7:	83 7f 10 00          	cmpl   $0x0,0x10(%rdi)
  8021cb:	7f 01                	jg     8021ce <writebuf+0xb>
  8021cd:	c3                   	ret
writebuf(struct printbuf *state) {
  8021ce:	55                   	push   %rbp
  8021cf:	48 89 e5             	mov    %rsp,%rbp
  8021d2:	53                   	push   %rbx
  8021d3:	48 83 ec 08          	sub    $0x8,%rsp
  8021d7:	48 89 fb             	mov    %rdi,%rbx
        ssize_t result = write(state->fd, state->buf, state->offset);
  8021da:	48 63 57 04          	movslq 0x4(%rdi),%rdx
  8021de:	48 8d 77 14          	lea    0x14(%rdi),%rsi
  8021e2:	8b 3f                	mov    (%rdi),%edi
  8021e4:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  8021eb:	00 00 00 
  8021ee:	ff d0                	call   *%rax
        if (result > 0) state->result += result;
  8021f0:	48 85 c0             	test   %rax,%rax
  8021f3:	7e 04                	jle    8021f9 <writebuf+0x36>
  8021f5:	48 01 43 08          	add    %rax,0x8(%rbx)

        /* Error, or wrote less than supplied */
        if (result != state->offset)
  8021f9:	48 63 53 04          	movslq 0x4(%rbx),%rdx
  8021fd:	48 39 c2             	cmp    %rax,%rdx
  802200:	74 0f                	je     802211 <writebuf+0x4e>
            state->error = MIN(0, result);
  802202:	48 85 c0             	test   %rax,%rax
  802205:	ba 00 00 00 00       	mov    $0x0,%edx
  80220a:	48 0f 4f c2          	cmovg  %rdx,%rax
  80220e:	89 43 10             	mov    %eax,0x10(%rbx)
    }
}
  802211:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802215:	c9                   	leave
  802216:	c3                   	ret

0000000000802217 <putch>:

static void
putch(int ch, void *arg) {
  802217:	f3 0f 1e fa          	endbr64
    struct printbuf *state = (struct printbuf *)arg;
    state->buf[state->offset++] = ch;
  80221b:	8b 46 04             	mov    0x4(%rsi),%eax
  80221e:	8d 50 01             	lea    0x1(%rax),%edx
  802221:	89 56 04             	mov    %edx,0x4(%rsi)
  802224:	48 98                	cltq
  802226:	40 88 7c 06 14       	mov    %dil,0x14(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ) {
  80222b:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  802231:	74 01                	je     802234 <putch+0x1d>
  802233:	c3                   	ret
putch(int ch, void *arg) {
  802234:	55                   	push   %rbp
  802235:	48 89 e5             	mov    %rsp,%rbp
  802238:	53                   	push   %rbx
  802239:	48 83 ec 08          	sub    $0x8,%rsp
  80223d:	48 89 f3             	mov    %rsi,%rbx
        writebuf(state);
  802240:	48 89 f7             	mov    %rsi,%rdi
  802243:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  80224a:	00 00 00 
  80224d:	ff d0                	call   *%rax
        state->offset = 0;
  80224f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
    }
}
  802256:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80225a:	c9                   	leave
  80225b:	c3                   	ret

000000000080225c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  80225c:	f3 0f 1e fa          	endbr64
  802260:	55                   	push   %rbp
  802261:	48 89 e5             	mov    %rsp,%rbp
  802264:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  80226b:	48 89 d1             	mov    %rdx,%rcx
    struct printbuf state;
    state.fd = fd;
  80226e:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%rbp)
    state.offset = 0;
  802274:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%rbp)
  80227b:	00 00 00 
    state.result = 0;
  80227e:	48 c7 85 f0 fe ff ff 	movq   $0x0,-0x110(%rbp)
  802285:	00 00 00 00 
    state.error = 1;
  802289:	c7 85 f8 fe ff ff 01 	movl   $0x1,-0x108(%rbp)
  802290:	00 00 00 

    vprintfmt(putch, &state, fmt, ap);
  802293:	48 89 f2             	mov    %rsi,%rdx
  802296:	48 8d b5 e8 fe ff ff 	lea    -0x118(%rbp),%rsi
  80229d:	48 bf 17 22 80 00 00 	movabs $0x802217,%rdi
  8022a4:	00 00 00 
  8022a7:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  8022ae:	00 00 00 
  8022b1:	ff d0                	call   *%rax
    if (state.offset > 0) writebuf(&state);
  8022b3:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%rbp)
  8022ba:	7f 14                	jg     8022d0 <vfprintf+0x74>

    return (state.result ? state.result : state.error);
  8022bc:	48 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%rax
  8022c3:	48 85 c0             	test   %rax,%rax
  8022c6:	75 06                	jne    8022ce <vfprintf+0x72>
  8022c8:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
}
  8022ce:	c9                   	leave
  8022cf:	c3                   	ret
    if (state.offset > 0) writebuf(&state);
  8022d0:	48 8d bd e8 fe ff ff 	lea    -0x118(%rbp),%rdi
  8022d7:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  8022de:	00 00 00 
  8022e1:	ff d0                	call   *%rax
  8022e3:	eb d7                	jmp    8022bc <vfprintf+0x60>

00000000008022e5 <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  8022e5:	f3 0f 1e fa          	endbr64
  8022e9:	55                   	push   %rbp
  8022ea:	48 89 e5             	mov    %rsp,%rbp
  8022ed:	48 83 ec 50          	sub    $0x50,%rsp
  8022f1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8022f5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8022f9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8022fd:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  802301:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802308:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80230c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802310:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802314:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(fd, fmt, ap);
  802318:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  80231c:	48 b8 5c 22 80 00 00 	movabs $0x80225c,%rax
  802323:	00 00 00 
  802326:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  802328:	c9                   	leave
  802329:	c3                   	ret

000000000080232a <printf>:

int
printf(const char *fmt, ...) {
  80232a:	f3 0f 1e fa          	endbr64
  80232e:	55                   	push   %rbp
  80232f:	48 89 e5             	mov    %rsp,%rbp
  802332:	48 83 ec 50          	sub    $0x50,%rsp
  802336:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80233a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80233e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802342:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802346:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  80234a:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  802351:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802355:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802359:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80235d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(1, fmt, ap);
  802361:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  802365:	48 89 fe             	mov    %rdi,%rsi
  802368:	bf 01 00 00 00       	mov    $0x1,%edi
  80236d:	48 b8 5c 22 80 00 00 	movabs $0x80225c,%rax
  802374:	00 00 00 
  802377:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  802379:	c9                   	leave
  80237a:	c3                   	ret

000000000080237b <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80237b:	f3 0f 1e fa          	endbr64
  80237f:	55                   	push   %rbp
  802380:	48 89 e5             	mov    %rsp,%rbp
  802383:	41 54                	push   %r12
  802385:	53                   	push   %rbx
  802386:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802389:	48 b8 2e 17 80 00 00 	movabs $0x80172e,%rax
  802390:	00 00 00 
  802393:	ff d0                	call   *%rax
  802395:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802398:	48 be 77 32 80 00 00 	movabs $0x803277,%rsi
  80239f:	00 00 00 
  8023a2:	48 89 df             	mov    %rbx,%rdi
  8023a5:	48 b8 4f 0d 80 00 00 	movabs $0x800d4f,%rax
  8023ac:	00 00 00 
  8023af:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8023b1:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8023b6:	41 2b 04 24          	sub    (%r12),%eax
  8023ba:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8023c0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8023c7:	00 00 00 
    stat->st_dev = &devpipe;
  8023ca:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8023d1:	00 00 00 
  8023d4:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8023db:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e0:	5b                   	pop    %rbx
  8023e1:	41 5c                	pop    %r12
  8023e3:	5d                   	pop    %rbp
  8023e4:	c3                   	ret

00000000008023e5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8023e5:	f3 0f 1e fa          	endbr64
  8023e9:	55                   	push   %rbp
  8023ea:	48 89 e5             	mov    %rsp,%rbp
  8023ed:	41 54                	push   %r12
  8023ef:	53                   	push   %rbx
  8023f0:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8023f3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023f8:	48 89 fe             	mov    %rdi,%rsi
  8023fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802400:	49 bc 94 14 80 00 00 	movabs $0x801494,%r12
  802407:	00 00 00 
  80240a:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80240d:	48 89 df             	mov    %rbx,%rdi
  802410:	48 b8 2e 17 80 00 00 	movabs $0x80172e,%rax
  802417:	00 00 00 
  80241a:	ff d0                	call   *%rax
  80241c:	48 89 c6             	mov    %rax,%rsi
  80241f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802424:	bf 00 00 00 00       	mov    $0x0,%edi
  802429:	41 ff d4             	call   *%r12
}
  80242c:	5b                   	pop    %rbx
  80242d:	41 5c                	pop    %r12
  80242f:	5d                   	pop    %rbp
  802430:	c3                   	ret

0000000000802431 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802431:	f3 0f 1e fa          	endbr64
  802435:	55                   	push   %rbp
  802436:	48 89 e5             	mov    %rsp,%rbp
  802439:	41 57                	push   %r15
  80243b:	41 56                	push   %r14
  80243d:	41 55                	push   %r13
  80243f:	41 54                	push   %r12
  802441:	53                   	push   %rbx
  802442:	48 83 ec 18          	sub    $0x18,%rsp
  802446:	49 89 fc             	mov    %rdi,%r12
  802449:	49 89 f5             	mov    %rsi,%r13
  80244c:	49 89 d7             	mov    %rdx,%r15
  80244f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802453:	48 b8 2e 17 80 00 00 	movabs $0x80172e,%rax
  80245a:	00 00 00 
  80245d:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80245f:	4d 85 ff             	test   %r15,%r15
  802462:	0f 84 af 00 00 00    	je     802517 <devpipe_write+0xe6>
  802468:	48 89 c3             	mov    %rax,%rbx
  80246b:	4c 89 f8             	mov    %r15,%rax
  80246e:	4d 89 ef             	mov    %r13,%r15
  802471:	4c 01 e8             	add    %r13,%rax
  802474:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802478:	49 bd 24 13 80 00 00 	movabs $0x801324,%r13
  80247f:	00 00 00 
            sys_yield();
  802482:	49 be b9 12 80 00 00 	movabs $0x8012b9,%r14
  802489:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80248c:	8b 73 04             	mov    0x4(%rbx),%esi
  80248f:	48 63 ce             	movslq %esi,%rcx
  802492:	48 63 03             	movslq (%rbx),%rax
  802495:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80249b:	48 39 c1             	cmp    %rax,%rcx
  80249e:	72 2e                	jb     8024ce <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024a0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024a5:	48 89 da             	mov    %rbx,%rdx
  8024a8:	be 00 10 00 00       	mov    $0x1000,%esi
  8024ad:	4c 89 e7             	mov    %r12,%rdi
  8024b0:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8024b3:	85 c0                	test   %eax,%eax
  8024b5:	74 66                	je     80251d <devpipe_write+0xec>
            sys_yield();
  8024b7:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8024ba:	8b 73 04             	mov    0x4(%rbx),%esi
  8024bd:	48 63 ce             	movslq %esi,%rcx
  8024c0:	48 63 03             	movslq (%rbx),%rax
  8024c3:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8024c9:	48 39 c1             	cmp    %rax,%rcx
  8024cc:	73 d2                	jae    8024a0 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024ce:	41 0f b6 3f          	movzbl (%r15),%edi
  8024d2:	48 89 ca             	mov    %rcx,%rdx
  8024d5:	48 c1 ea 03          	shr    $0x3,%rdx
  8024d9:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8024e0:	08 10 20 
  8024e3:	48 f7 e2             	mul    %rdx
  8024e6:	48 c1 ea 06          	shr    $0x6,%rdx
  8024ea:	48 89 d0             	mov    %rdx,%rax
  8024ed:	48 c1 e0 09          	shl    $0x9,%rax
  8024f1:	48 29 d0             	sub    %rdx,%rax
  8024f4:	48 c1 e0 03          	shl    $0x3,%rax
  8024f8:	48 29 c1             	sub    %rax,%rcx
  8024fb:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802500:	83 c6 01             	add    $0x1,%esi
  802503:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802506:	49 83 c7 01          	add    $0x1,%r15
  80250a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80250e:	49 39 c7             	cmp    %rax,%r15
  802511:	0f 85 75 ff ff ff    	jne    80248c <devpipe_write+0x5b>
    return n;
  802517:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80251b:	eb 05                	jmp    802522 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  80251d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802522:	48 83 c4 18          	add    $0x18,%rsp
  802526:	5b                   	pop    %rbx
  802527:	41 5c                	pop    %r12
  802529:	41 5d                	pop    %r13
  80252b:	41 5e                	pop    %r14
  80252d:	41 5f                	pop    %r15
  80252f:	5d                   	pop    %rbp
  802530:	c3                   	ret

0000000000802531 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802531:	f3 0f 1e fa          	endbr64
  802535:	55                   	push   %rbp
  802536:	48 89 e5             	mov    %rsp,%rbp
  802539:	41 57                	push   %r15
  80253b:	41 56                	push   %r14
  80253d:	41 55                	push   %r13
  80253f:	41 54                	push   %r12
  802541:	53                   	push   %rbx
  802542:	48 83 ec 18          	sub    $0x18,%rsp
  802546:	49 89 fc             	mov    %rdi,%r12
  802549:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80254d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802551:	48 b8 2e 17 80 00 00 	movabs $0x80172e,%rax
  802558:	00 00 00 
  80255b:	ff d0                	call   *%rax
  80255d:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802560:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802566:	49 bd 24 13 80 00 00 	movabs $0x801324,%r13
  80256d:	00 00 00 
            sys_yield();
  802570:	49 be b9 12 80 00 00 	movabs $0x8012b9,%r14
  802577:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80257a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80257f:	74 7d                	je     8025fe <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802581:	8b 03                	mov    (%rbx),%eax
  802583:	3b 43 04             	cmp    0x4(%rbx),%eax
  802586:	75 26                	jne    8025ae <devpipe_read+0x7d>
            if (i > 0) return i;
  802588:	4d 85 ff             	test   %r15,%r15
  80258b:	75 77                	jne    802604 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80258d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802592:	48 89 da             	mov    %rbx,%rdx
  802595:	be 00 10 00 00       	mov    $0x1000,%esi
  80259a:	4c 89 e7             	mov    %r12,%rdi
  80259d:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8025a0:	85 c0                	test   %eax,%eax
  8025a2:	74 72                	je     802616 <devpipe_read+0xe5>
            sys_yield();
  8025a4:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8025a7:	8b 03                	mov    (%rbx),%eax
  8025a9:	3b 43 04             	cmp    0x4(%rbx),%eax
  8025ac:	74 df                	je     80258d <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025ae:	48 63 c8             	movslq %eax,%rcx
  8025b1:	48 89 ca             	mov    %rcx,%rdx
  8025b4:	48 c1 ea 03          	shr    $0x3,%rdx
  8025b8:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8025bf:	08 10 20 
  8025c2:	48 89 d0             	mov    %rdx,%rax
  8025c5:	48 f7 e6             	mul    %rsi
  8025c8:	48 c1 ea 06          	shr    $0x6,%rdx
  8025cc:	48 89 d0             	mov    %rdx,%rax
  8025cf:	48 c1 e0 09          	shl    $0x9,%rax
  8025d3:	48 29 d0             	sub    %rdx,%rax
  8025d6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8025dd:	00 
  8025de:	48 89 c8             	mov    %rcx,%rax
  8025e1:	48 29 d0             	sub    %rdx,%rax
  8025e4:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8025e9:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8025ed:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8025f1:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8025f4:	49 83 c7 01          	add    $0x1,%r15
  8025f8:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8025fc:	75 83                	jne    802581 <devpipe_read+0x50>
    return n;
  8025fe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802602:	eb 03                	jmp    802607 <devpipe_read+0xd6>
            if (i > 0) return i;
  802604:	4c 89 f8             	mov    %r15,%rax
}
  802607:	48 83 c4 18          	add    $0x18,%rsp
  80260b:	5b                   	pop    %rbx
  80260c:	41 5c                	pop    %r12
  80260e:	41 5d                	pop    %r13
  802610:	41 5e                	pop    %r14
  802612:	41 5f                	pop    %r15
  802614:	5d                   	pop    %rbp
  802615:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802616:	b8 00 00 00 00       	mov    $0x0,%eax
  80261b:	eb ea                	jmp    802607 <devpipe_read+0xd6>

000000000080261d <pipe>:
pipe(int pfd[2]) {
  80261d:	f3 0f 1e fa          	endbr64
  802621:	55                   	push   %rbp
  802622:	48 89 e5             	mov    %rsp,%rbp
  802625:	41 55                	push   %r13
  802627:	41 54                	push   %r12
  802629:	53                   	push   %rbx
  80262a:	48 83 ec 18          	sub    $0x18,%rsp
  80262e:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802631:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802635:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  80263c:	00 00 00 
  80263f:	ff d0                	call   *%rax
  802641:	89 c3                	mov    %eax,%ebx
  802643:	85 c0                	test   %eax,%eax
  802645:	0f 88 a0 01 00 00    	js     8027eb <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80264b:	b9 46 00 00 00       	mov    $0x46,%ecx
  802650:	ba 00 10 00 00       	mov    $0x1000,%edx
  802655:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802659:	bf 00 00 00 00       	mov    $0x0,%edi
  80265e:	48 b8 54 13 80 00 00 	movabs $0x801354,%rax
  802665:	00 00 00 
  802668:	ff d0                	call   *%rax
  80266a:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80266c:	85 c0                	test   %eax,%eax
  80266e:	0f 88 77 01 00 00    	js     8027eb <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802674:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802678:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  80267f:	00 00 00 
  802682:	ff d0                	call   *%rax
  802684:	89 c3                	mov    %eax,%ebx
  802686:	85 c0                	test   %eax,%eax
  802688:	0f 88 43 01 00 00    	js     8027d1 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80268e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802693:	ba 00 10 00 00       	mov    $0x1000,%edx
  802698:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80269c:	bf 00 00 00 00       	mov    $0x0,%edi
  8026a1:	48 b8 54 13 80 00 00 	movabs $0x801354,%rax
  8026a8:	00 00 00 
  8026ab:	ff d0                	call   *%rax
  8026ad:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	0f 88 1a 01 00 00    	js     8027d1 <pipe+0x1b4>
    va = fd2data(fd0);
  8026b7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8026bb:	48 b8 2e 17 80 00 00 	movabs $0x80172e,%rax
  8026c2:	00 00 00 
  8026c5:	ff d0                	call   *%rax
  8026c7:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8026ca:	b9 46 00 00 00       	mov    $0x46,%ecx
  8026cf:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026d4:	48 89 c6             	mov    %rax,%rsi
  8026d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8026dc:	48 b8 54 13 80 00 00 	movabs $0x801354,%rax
  8026e3:	00 00 00 
  8026e6:	ff d0                	call   *%rax
  8026e8:	89 c3                	mov    %eax,%ebx
  8026ea:	85 c0                	test   %eax,%eax
  8026ec:	0f 88 c5 00 00 00    	js     8027b7 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8026f2:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8026f6:	48 b8 2e 17 80 00 00 	movabs $0x80172e,%rax
  8026fd:	00 00 00 
  802700:	ff d0                	call   *%rax
  802702:	48 89 c1             	mov    %rax,%rcx
  802705:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80270b:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802711:	ba 00 00 00 00       	mov    $0x0,%edx
  802716:	4c 89 ee             	mov    %r13,%rsi
  802719:	bf 00 00 00 00       	mov    $0x0,%edi
  80271e:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  802725:	00 00 00 
  802728:	ff d0                	call   *%rax
  80272a:	89 c3                	mov    %eax,%ebx
  80272c:	85 c0                	test   %eax,%eax
  80272e:	78 6e                	js     80279e <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802730:	be 00 10 00 00       	mov    $0x1000,%esi
  802735:	4c 89 ef             	mov    %r13,%rdi
  802738:	48 b8 ee 12 80 00 00 	movabs $0x8012ee,%rax
  80273f:	00 00 00 
  802742:	ff d0                	call   *%rax
  802744:	83 f8 02             	cmp    $0x2,%eax
  802747:	0f 85 ab 00 00 00    	jne    8027f8 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  80274d:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802754:	00 00 
  802756:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80275a:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80275c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802760:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802767:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80276b:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80276d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802771:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802778:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80277c:	48 bb 18 17 80 00 00 	movabs $0x801718,%rbx
  802783:	00 00 00 
  802786:	ff d3                	call   *%rbx
  802788:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80278c:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802790:	ff d3                	call   *%rbx
  802792:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802797:	bb 00 00 00 00       	mov    $0x0,%ebx
  80279c:	eb 4d                	jmp    8027eb <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  80279e:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027a3:	4c 89 ee             	mov    %r13,%rsi
  8027a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ab:	48 b8 94 14 80 00 00 	movabs $0x801494,%rax
  8027b2:	00 00 00 
  8027b5:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8027b7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027bc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c5:	48 b8 94 14 80 00 00 	movabs $0x801494,%rax
  8027cc:	00 00 00 
  8027cf:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8027d1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027d6:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8027da:	bf 00 00 00 00       	mov    $0x0,%edi
  8027df:	48 b8 94 14 80 00 00 	movabs $0x801494,%rax
  8027e6:	00 00 00 
  8027e9:	ff d0                	call   *%rax
}
  8027eb:	89 d8                	mov    %ebx,%eax
  8027ed:	48 83 c4 18          	add    $0x18,%rsp
  8027f1:	5b                   	pop    %rbx
  8027f2:	41 5c                	pop    %r12
  8027f4:	41 5d                	pop    %r13
  8027f6:	5d                   	pop    %rbp
  8027f7:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8027f8:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  8027ff:	00 00 00 
  802802:	48 ba 57 32 80 00 00 	movabs $0x803257,%rdx
  802809:	00 00 00 
  80280c:	be 2e 00 00 00       	mov    $0x2e,%esi
  802811:	48 bf 7e 32 80 00 00 	movabs $0x80327e,%rdi
  802818:	00 00 00 
  80281b:	b8 00 00 00 00       	mov    $0x0,%eax
  802820:	49 b8 aa 02 80 00 00 	movabs $0x8002aa,%r8
  802827:	00 00 00 
  80282a:	41 ff d0             	call   *%r8

000000000080282d <pipeisclosed>:
pipeisclosed(int fdnum) {
  80282d:	f3 0f 1e fa          	endbr64
  802831:	55                   	push   %rbp
  802832:	48 89 e5             	mov    %rsp,%rbp
  802835:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802839:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80283d:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  802844:	00 00 00 
  802847:	ff d0                	call   *%rax
    if (res < 0) return res;
  802849:	85 c0                	test   %eax,%eax
  80284b:	78 35                	js     802882 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80284d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802851:	48 b8 2e 17 80 00 00 	movabs $0x80172e,%rax
  802858:	00 00 00 
  80285b:	ff d0                	call   *%rax
  80285d:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802860:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802865:	be 00 10 00 00       	mov    $0x1000,%esi
  80286a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80286e:	48 b8 24 13 80 00 00 	movabs $0x801324,%rax
  802875:	00 00 00 
  802878:	ff d0                	call   *%rax
  80287a:	85 c0                	test   %eax,%eax
  80287c:	0f 94 c0             	sete   %al
  80287f:	0f b6 c0             	movzbl %al,%eax
}
  802882:	c9                   	leave
  802883:	c3                   	ret

0000000000802884 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802884:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802888:	48 89 f8             	mov    %rdi,%rax
  80288b:	48 c1 e8 27          	shr    $0x27,%rax
  80288f:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802896:	7f 00 00 
  802899:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80289d:	f6 c2 01             	test   $0x1,%dl
  8028a0:	74 6d                	je     80290f <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8028a2:	48 89 f8             	mov    %rdi,%rax
  8028a5:	48 c1 e8 1e          	shr    $0x1e,%rax
  8028a9:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8028b0:	7f 00 00 
  8028b3:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028b7:	f6 c2 01             	test   $0x1,%dl
  8028ba:	74 62                	je     80291e <get_uvpt_entry+0x9a>
  8028bc:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8028c3:	7f 00 00 
  8028c6:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028ca:	f6 c2 80             	test   $0x80,%dl
  8028cd:	75 4f                	jne    80291e <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8028cf:	48 89 f8             	mov    %rdi,%rax
  8028d2:	48 c1 e8 15          	shr    $0x15,%rax
  8028d6:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8028dd:	7f 00 00 
  8028e0:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028e4:	f6 c2 01             	test   $0x1,%dl
  8028e7:	74 44                	je     80292d <get_uvpt_entry+0xa9>
  8028e9:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8028f0:	7f 00 00 
  8028f3:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028f7:	f6 c2 80             	test   $0x80,%dl
  8028fa:	75 31                	jne    80292d <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  8028fc:	48 c1 ef 0c          	shr    $0xc,%rdi
  802900:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802907:	7f 00 00 
  80290a:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80290e:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80290f:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802916:	7f 00 00 
  802919:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80291d:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80291e:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802925:	7f 00 00 
  802928:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80292c:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80292d:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802934:	7f 00 00 
  802937:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80293b:	c3                   	ret

000000000080293c <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  80293c:	f3 0f 1e fa          	endbr64
  802940:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802943:	48 89 f9             	mov    %rdi,%rcx
  802946:	48 c1 e9 27          	shr    $0x27,%rcx
  80294a:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802951:	7f 00 00 
  802954:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802958:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  80295f:	f6 c1 01             	test   $0x1,%cl
  802962:	0f 84 b2 00 00 00    	je     802a1a <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802968:	48 89 f9             	mov    %rdi,%rcx
  80296b:	48 c1 e9 1e          	shr    $0x1e,%rcx
  80296f:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802976:	7f 00 00 
  802979:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80297d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802984:	40 f6 c6 01          	test   $0x1,%sil
  802988:	0f 84 8c 00 00 00    	je     802a1a <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  80298e:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802995:	7f 00 00 
  802998:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80299c:	a8 80                	test   $0x80,%al
  80299e:	75 7b                	jne    802a1b <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8029a0:	48 89 f9             	mov    %rdi,%rcx
  8029a3:	48 c1 e9 15          	shr    $0x15,%rcx
  8029a7:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8029ae:	7f 00 00 
  8029b1:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8029b5:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  8029bc:	40 f6 c6 01          	test   $0x1,%sil
  8029c0:	74 58                	je     802a1a <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  8029c2:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8029c9:	7f 00 00 
  8029cc:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8029d0:	a8 80                	test   $0x80,%al
  8029d2:	75 6c                	jne    802a40 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  8029d4:	48 89 f9             	mov    %rdi,%rcx
  8029d7:	48 c1 e9 0c          	shr    $0xc,%rcx
  8029db:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8029e2:	7f 00 00 
  8029e5:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8029e9:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  8029f0:	40 f6 c6 01          	test   $0x1,%sil
  8029f4:	74 24                	je     802a1a <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  8029f6:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8029fd:	7f 00 00 
  802a00:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a04:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802a0b:	ff ff 7f 
  802a0e:	48 21 c8             	and    %rcx,%rax
  802a11:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802a17:	48 09 d0             	or     %rdx,%rax
}
  802a1a:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802a1b:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802a22:	7f 00 00 
  802a25:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a29:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802a30:	ff ff 7f 
  802a33:	48 21 c8             	and    %rcx,%rax
  802a36:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802a3c:	48 01 d0             	add    %rdx,%rax
  802a3f:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802a40:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802a47:	7f 00 00 
  802a4a:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a4e:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802a55:	ff ff 7f 
  802a58:	48 21 c8             	and    %rcx,%rax
  802a5b:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802a61:	48 01 d0             	add    %rdx,%rax
  802a64:	c3                   	ret

0000000000802a65 <get_prot>:

int
get_prot(void *va) {
  802a65:	f3 0f 1e fa          	endbr64
  802a69:	55                   	push   %rbp
  802a6a:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802a6d:	48 b8 84 28 80 00 00 	movabs $0x802884,%rax
  802a74:	00 00 00 
  802a77:	ff d0                	call   *%rax
  802a79:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802a7c:	83 e0 01             	and    $0x1,%eax
  802a7f:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802a82:	89 d1                	mov    %edx,%ecx
  802a84:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802a8a:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802a8c:	89 c1                	mov    %eax,%ecx
  802a8e:	83 c9 02             	or     $0x2,%ecx
  802a91:	f6 c2 02             	test   $0x2,%dl
  802a94:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802a97:	89 c1                	mov    %eax,%ecx
  802a99:	83 c9 01             	or     $0x1,%ecx
  802a9c:	48 85 d2             	test   %rdx,%rdx
  802a9f:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802aa2:	89 c1                	mov    %eax,%ecx
  802aa4:	83 c9 40             	or     $0x40,%ecx
  802aa7:	f6 c6 04             	test   $0x4,%dh
  802aaa:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802aad:	5d                   	pop    %rbp
  802aae:	c3                   	ret

0000000000802aaf <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802aaf:	f3 0f 1e fa          	endbr64
  802ab3:	55                   	push   %rbp
  802ab4:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802ab7:	48 b8 84 28 80 00 00 	movabs $0x802884,%rax
  802abe:	00 00 00 
  802ac1:	ff d0                	call   *%rax
    return pte & PTE_D;
  802ac3:	48 c1 e8 06          	shr    $0x6,%rax
  802ac7:	83 e0 01             	and    $0x1,%eax
}
  802aca:	5d                   	pop    %rbp
  802acb:	c3                   	ret

0000000000802acc <is_page_present>:

bool
is_page_present(void *va) {
  802acc:	f3 0f 1e fa          	endbr64
  802ad0:	55                   	push   %rbp
  802ad1:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802ad4:	48 b8 84 28 80 00 00 	movabs $0x802884,%rax
  802adb:	00 00 00 
  802ade:	ff d0                	call   *%rax
  802ae0:	83 e0 01             	and    $0x1,%eax
}
  802ae3:	5d                   	pop    %rbp
  802ae4:	c3                   	ret

0000000000802ae5 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802ae5:	f3 0f 1e fa          	endbr64
  802ae9:	55                   	push   %rbp
  802aea:	48 89 e5             	mov    %rsp,%rbp
  802aed:	41 57                	push   %r15
  802aef:	41 56                	push   %r14
  802af1:	41 55                	push   %r13
  802af3:	41 54                	push   %r12
  802af5:	53                   	push   %rbx
  802af6:	48 83 ec 18          	sub    $0x18,%rsp
  802afa:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802afe:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802b02:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802b07:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802b0e:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802b11:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802b18:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802b1b:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802b22:	00 00 00 
  802b25:	eb 73                	jmp    802b9a <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802b27:	48 89 d8             	mov    %rbx,%rax
  802b2a:	48 c1 e8 15          	shr    $0x15,%rax
  802b2e:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802b35:	7f 00 00 
  802b38:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802b3c:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802b42:	f6 c2 01             	test   $0x1,%dl
  802b45:	74 4b                	je     802b92 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802b47:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802b4b:	f6 c2 80             	test   $0x80,%dl
  802b4e:	74 11                	je     802b61 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802b50:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802b54:	f6 c4 04             	test   $0x4,%ah
  802b57:	74 39                	je     802b92 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802b59:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802b5f:	eb 20                	jmp    802b81 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802b61:	48 89 da             	mov    %rbx,%rdx
  802b64:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b68:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802b6f:	7f 00 00 
  802b72:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802b76:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802b7c:	f6 c4 04             	test   $0x4,%ah
  802b7f:	74 11                	je     802b92 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802b81:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802b85:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802b89:	48 89 df             	mov    %rbx,%rdi
  802b8c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b90:	ff d0                	call   *%rax
    next:
        va += size;
  802b92:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802b95:	49 39 df             	cmp    %rbx,%r15
  802b98:	72 3e                	jb     802bd8 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802b9a:	49 8b 06             	mov    (%r14),%rax
  802b9d:	a8 01                	test   $0x1,%al
  802b9f:	74 37                	je     802bd8 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802ba1:	48 89 d8             	mov    %rbx,%rax
  802ba4:	48 c1 e8 1e          	shr    $0x1e,%rax
  802ba8:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802bad:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802bb3:	f6 c2 01             	test   $0x1,%dl
  802bb6:	74 da                	je     802b92 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802bb8:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802bbd:	f6 c2 80             	test   $0x80,%dl
  802bc0:	0f 84 61 ff ff ff    	je     802b27 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802bc6:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802bcb:	f6 c4 04             	test   $0x4,%ah
  802bce:	74 c2                	je     802b92 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802bd0:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802bd6:	eb a9                	jmp    802b81 <foreach_shared_region+0x9c>
    }
    return res;
}
  802bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bdd:	48 83 c4 18          	add    $0x18,%rsp
  802be1:	5b                   	pop    %rbx
  802be2:	41 5c                	pop    %r12
  802be4:	41 5d                	pop    %r13
  802be6:	41 5e                	pop    %r14
  802be8:	41 5f                	pop    %r15
  802bea:	5d                   	pop    %rbp
  802beb:	c3                   	ret

0000000000802bec <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802bec:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf5:	c3                   	ret

0000000000802bf6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802bf6:	f3 0f 1e fa          	endbr64
  802bfa:	55                   	push   %rbp
  802bfb:	48 89 e5             	mov    %rsp,%rbp
  802bfe:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802c01:	48 be 8e 32 80 00 00 	movabs $0x80328e,%rsi
  802c08:	00 00 00 
  802c0b:	48 b8 4f 0d 80 00 00 	movabs $0x800d4f,%rax
  802c12:	00 00 00 
  802c15:	ff d0                	call   *%rax
    return 0;
}
  802c17:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1c:	5d                   	pop    %rbp
  802c1d:	c3                   	ret

0000000000802c1e <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802c1e:	f3 0f 1e fa          	endbr64
  802c22:	55                   	push   %rbp
  802c23:	48 89 e5             	mov    %rsp,%rbp
  802c26:	41 57                	push   %r15
  802c28:	41 56                	push   %r14
  802c2a:	41 55                	push   %r13
  802c2c:	41 54                	push   %r12
  802c2e:	53                   	push   %rbx
  802c2f:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802c36:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802c3d:	48 85 d2             	test   %rdx,%rdx
  802c40:	74 7a                	je     802cbc <devcons_write+0x9e>
  802c42:	49 89 d6             	mov    %rdx,%r14
  802c45:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802c4b:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802c50:	49 bf 6a 0f 80 00 00 	movabs $0x800f6a,%r15
  802c57:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802c5a:	4c 89 f3             	mov    %r14,%rbx
  802c5d:	48 29 f3             	sub    %rsi,%rbx
  802c60:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802c65:	48 39 c3             	cmp    %rax,%rbx
  802c68:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802c6c:	4c 63 eb             	movslq %ebx,%r13
  802c6f:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802c76:	48 01 c6             	add    %rax,%rsi
  802c79:	4c 89 ea             	mov    %r13,%rdx
  802c7c:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802c83:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802c86:	4c 89 ee             	mov    %r13,%rsi
  802c89:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802c90:	48 b8 af 11 80 00 00 	movabs $0x8011af,%rax
  802c97:	00 00 00 
  802c9a:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802c9c:	41 01 dc             	add    %ebx,%r12d
  802c9f:	49 63 f4             	movslq %r12d,%rsi
  802ca2:	4c 39 f6             	cmp    %r14,%rsi
  802ca5:	72 b3                	jb     802c5a <devcons_write+0x3c>
    return res;
  802ca7:	49 63 c4             	movslq %r12d,%rax
}
  802caa:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802cb1:	5b                   	pop    %rbx
  802cb2:	41 5c                	pop    %r12
  802cb4:	41 5d                	pop    %r13
  802cb6:	41 5e                	pop    %r14
  802cb8:	41 5f                	pop    %r15
  802cba:	5d                   	pop    %rbp
  802cbb:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802cbc:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802cc2:	eb e3                	jmp    802ca7 <devcons_write+0x89>

0000000000802cc4 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802cc4:	f3 0f 1e fa          	endbr64
  802cc8:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  802cd0:	48 85 c0             	test   %rax,%rax
  802cd3:	74 55                	je     802d2a <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802cd5:	55                   	push   %rbp
  802cd6:	48 89 e5             	mov    %rsp,%rbp
  802cd9:	41 55                	push   %r13
  802cdb:	41 54                	push   %r12
  802cdd:	53                   	push   %rbx
  802cde:	48 83 ec 08          	sub    $0x8,%rsp
  802ce2:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802ce5:	48 bb e0 11 80 00 00 	movabs $0x8011e0,%rbx
  802cec:	00 00 00 
  802cef:	49 bc b9 12 80 00 00 	movabs $0x8012b9,%r12
  802cf6:	00 00 00 
  802cf9:	eb 03                	jmp    802cfe <devcons_read+0x3a>
  802cfb:	41 ff d4             	call   *%r12
  802cfe:	ff d3                	call   *%rbx
  802d00:	85 c0                	test   %eax,%eax
  802d02:	74 f7                	je     802cfb <devcons_read+0x37>
    if (c < 0) return c;
  802d04:	48 63 d0             	movslq %eax,%rdx
  802d07:	78 13                	js     802d1c <devcons_read+0x58>
    if (c == 0x04) return 0;
  802d09:	ba 00 00 00 00       	mov    $0x0,%edx
  802d0e:	83 f8 04             	cmp    $0x4,%eax
  802d11:	74 09                	je     802d1c <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802d13:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802d17:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802d1c:	48 89 d0             	mov    %rdx,%rax
  802d1f:	48 83 c4 08          	add    $0x8,%rsp
  802d23:	5b                   	pop    %rbx
  802d24:	41 5c                	pop    %r12
  802d26:	41 5d                	pop    %r13
  802d28:	5d                   	pop    %rbp
  802d29:	c3                   	ret
  802d2a:	48 89 d0             	mov    %rdx,%rax
  802d2d:	c3                   	ret

0000000000802d2e <cputchar>:
cputchar(int ch) {
  802d2e:	f3 0f 1e fa          	endbr64
  802d32:	55                   	push   %rbp
  802d33:	48 89 e5             	mov    %rsp,%rbp
  802d36:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802d3a:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802d3e:	be 01 00 00 00       	mov    $0x1,%esi
  802d43:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802d47:	48 b8 af 11 80 00 00 	movabs $0x8011af,%rax
  802d4e:	00 00 00 
  802d51:	ff d0                	call   *%rax
}
  802d53:	c9                   	leave
  802d54:	c3                   	ret

0000000000802d55 <getchar>:
getchar(void) {
  802d55:	f3 0f 1e fa          	endbr64
  802d59:	55                   	push   %rbp
  802d5a:	48 89 e5             	mov    %rsp,%rbp
  802d5d:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802d61:	ba 01 00 00 00       	mov    $0x1,%edx
  802d66:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802d6a:	bf 00 00 00 00       	mov    $0x0,%edi
  802d6f:	48 b8 ad 1a 80 00 00 	movabs $0x801aad,%rax
  802d76:	00 00 00 
  802d79:	ff d0                	call   *%rax
  802d7b:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	78 06                	js     802d87 <getchar+0x32>
  802d81:	74 08                	je     802d8b <getchar+0x36>
  802d83:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802d87:	89 d0                	mov    %edx,%eax
  802d89:	c9                   	leave
  802d8a:	c3                   	ret
    return res < 0 ? res : res ? c :
  802d8b:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802d90:	eb f5                	jmp    802d87 <getchar+0x32>

0000000000802d92 <iscons>:
iscons(int fdnum) {
  802d92:	f3 0f 1e fa          	endbr64
  802d96:	55                   	push   %rbp
  802d97:	48 89 e5             	mov    %rsp,%rbp
  802d9a:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802d9e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802da2:	48 b8 b2 17 80 00 00 	movabs $0x8017b2,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	call   *%rax
    if (res < 0) return res;
  802dae:	85 c0                	test   %eax,%eax
  802db0:	78 18                	js     802dca <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802db2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802db6:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802dbd:	00 00 00 
  802dc0:	8b 00                	mov    (%rax),%eax
  802dc2:	39 02                	cmp    %eax,(%rdx)
  802dc4:	0f 94 c0             	sete   %al
  802dc7:	0f b6 c0             	movzbl %al,%eax
}
  802dca:	c9                   	leave
  802dcb:	c3                   	ret

0000000000802dcc <opencons>:
opencons(void) {
  802dcc:	f3 0f 1e fa          	endbr64
  802dd0:	55                   	push   %rbp
  802dd1:	48 89 e5             	mov    %rsp,%rbp
  802dd4:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802dd8:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802ddc:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  802de3:	00 00 00 
  802de6:	ff d0                	call   *%rax
  802de8:	85 c0                	test   %eax,%eax
  802dea:	78 49                	js     802e35 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802dec:	b9 46 00 00 00       	mov    $0x46,%ecx
  802df1:	ba 00 10 00 00       	mov    $0x1000,%edx
  802df6:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802dfa:	bf 00 00 00 00       	mov    $0x0,%edi
  802dff:	48 b8 54 13 80 00 00 	movabs $0x801354,%rax
  802e06:	00 00 00 
  802e09:	ff d0                	call   *%rax
  802e0b:	85 c0                	test   %eax,%eax
  802e0d:	78 26                	js     802e35 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802e0f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e13:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802e1a:	00 00 
  802e1c:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802e1e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802e22:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802e29:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  802e30:	00 00 00 
  802e33:	ff d0                	call   *%rax
}
  802e35:	c9                   	leave
  802e36:	c3                   	ret

0000000000802e37 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802e37:	f3 0f 1e fa          	endbr64
  802e3b:	55                   	push   %rbp
  802e3c:	48 89 e5             	mov    %rsp,%rbp
  802e3f:	41 54                	push   %r12
  802e41:	53                   	push   %rbx
  802e42:	48 89 fb             	mov    %rdi,%rbx
  802e45:	48 89 f7             	mov    %rsi,%rdi
  802e48:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802e4b:	48 85 f6             	test   %rsi,%rsi
  802e4e:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802e55:	00 00 00 
  802e58:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802e5c:	be 00 10 00 00       	mov    $0x1000,%esi
  802e61:	48 b8 76 16 80 00 00 	movabs $0x801676,%rax
  802e68:	00 00 00 
  802e6b:	ff d0                	call   *%rax
    if (res < 0) {
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	78 45                	js     802eb6 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802e71:	48 85 db             	test   %rbx,%rbx
  802e74:	74 12                	je     802e88 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802e76:	48 a1 00 70 80 00 00 	movabs 0x807000,%rax
  802e7d:	00 00 00 
  802e80:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802e86:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802e88:	4d 85 e4             	test   %r12,%r12
  802e8b:	74 14                	je     802ea1 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802e8d:	48 a1 00 70 80 00 00 	movabs 0x807000,%rax
  802e94:	00 00 00 
  802e97:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802e9d:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802ea1:	48 a1 00 70 80 00 00 	movabs 0x807000,%rax
  802ea8:	00 00 00 
  802eab:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802eb1:	5b                   	pop    %rbx
  802eb2:	41 5c                	pop    %r12
  802eb4:	5d                   	pop    %rbp
  802eb5:	c3                   	ret
        if (from_env_store != NULL) {
  802eb6:	48 85 db             	test   %rbx,%rbx
  802eb9:	74 06                	je     802ec1 <ipc_recv+0x8a>
            *from_env_store = 0;
  802ebb:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802ec1:	4d 85 e4             	test   %r12,%r12
  802ec4:	74 eb                	je     802eb1 <ipc_recv+0x7a>
            *perm_store = 0;
  802ec6:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802ecd:	00 
  802ece:	eb e1                	jmp    802eb1 <ipc_recv+0x7a>

0000000000802ed0 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802ed0:	f3 0f 1e fa          	endbr64
  802ed4:	55                   	push   %rbp
  802ed5:	48 89 e5             	mov    %rsp,%rbp
  802ed8:	41 57                	push   %r15
  802eda:	41 56                	push   %r14
  802edc:	41 55                	push   %r13
  802ede:	41 54                	push   %r12
  802ee0:	53                   	push   %rbx
  802ee1:	48 83 ec 18          	sub    $0x18,%rsp
  802ee5:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802ee8:	48 89 d3             	mov    %rdx,%rbx
  802eeb:	49 89 cc             	mov    %rcx,%r12
  802eee:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802ef1:	48 85 d2             	test   %rdx,%rdx
  802ef4:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802efb:	00 00 00 
  802efe:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802f02:	89 f0                	mov    %esi,%eax
  802f04:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802f08:	48 89 da             	mov    %rbx,%rdx
  802f0b:	48 89 c6             	mov    %rax,%rsi
  802f0e:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	call   *%rax
    while (res < 0) {
  802f1a:	85 c0                	test   %eax,%eax
  802f1c:	79 65                	jns    802f83 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802f1e:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802f21:	75 33                	jne    802f56 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802f23:	49 bf b9 12 80 00 00 	movabs $0x8012b9,%r15
  802f2a:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802f2d:	49 be 46 16 80 00 00 	movabs $0x801646,%r14
  802f34:	00 00 00 
        sys_yield();
  802f37:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802f3a:	45 89 e8             	mov    %r13d,%r8d
  802f3d:	4c 89 e1             	mov    %r12,%rcx
  802f40:	48 89 da             	mov    %rbx,%rdx
  802f43:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802f47:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802f4a:	41 ff d6             	call   *%r14
    while (res < 0) {
  802f4d:	85 c0                	test   %eax,%eax
  802f4f:	79 32                	jns    802f83 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802f51:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802f54:	74 e1                	je     802f37 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802f56:	89 c1                	mov    %eax,%ecx
  802f58:	48 ba 9a 32 80 00 00 	movabs $0x80329a,%rdx
  802f5f:	00 00 00 
  802f62:	be 42 00 00 00       	mov    $0x42,%esi
  802f67:	48 bf a5 32 80 00 00 	movabs $0x8032a5,%rdi
  802f6e:	00 00 00 
  802f71:	b8 00 00 00 00       	mov    $0x0,%eax
  802f76:	49 b8 aa 02 80 00 00 	movabs $0x8002aa,%r8
  802f7d:	00 00 00 
  802f80:	41 ff d0             	call   *%r8
    }
}
  802f83:	48 83 c4 18          	add    $0x18,%rsp
  802f87:	5b                   	pop    %rbx
  802f88:	41 5c                	pop    %r12
  802f8a:	41 5d                	pop    %r13
  802f8c:	41 5e                	pop    %r14
  802f8e:	41 5f                	pop    %r15
  802f90:	5d                   	pop    %rbp
  802f91:	c3                   	ret

0000000000802f92 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802f92:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802f96:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802f9b:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802fa2:	00 00 00 
  802fa5:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802fa9:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802fad:	48 c1 e2 04          	shl    $0x4,%rdx
  802fb1:	48 01 ca             	add    %rcx,%rdx
  802fb4:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802fba:	39 fa                	cmp    %edi,%edx
  802fbc:	74 12                	je     802fd0 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802fbe:	48 83 c0 01          	add    $0x1,%rax
  802fc2:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802fc8:	75 db                	jne    802fa5 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802fca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fcf:	c3                   	ret
            return envs[i].env_id;
  802fd0:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802fd4:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802fd8:	48 c1 e2 04          	shl    $0x4,%rdx
  802fdc:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802fe3:	00 00 00 
  802fe6:	48 01 d0             	add    %rdx,%rax
  802fe9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fef:	c3                   	ret

0000000000802ff0 <__text_end>:
  802ff0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff7:	00 00 00 
  802ffa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
