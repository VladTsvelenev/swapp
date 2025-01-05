
obj/user/signedoverflow:     file format elf64-x86-64


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
  80001e:	e8 2c 00 00 00       	call   80004f <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* Test for UBSAN support - signed integer overflow */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
    /* Creating a 32-bit integer variable with the maximum integer value it can contain */
    int a = 2147483647;
    /* Trying to add 1 to the "a" variable and print its contents (which causes undefined behavior). */
    /* The "cprintf" function is sanitized by UBSAN because lib/Makefrag accesses the USER_SAN_CFLAGS variable. */
    cprintf("%d\n", a + 1);
  80002d:	be 00 00 00 80       	mov    $0x80000000,%esi
  800032:	48 bf 00 30 80 00 00 	movabs $0x803000,%rdi
  800039:	00 00 00 
  80003c:	b8 00 00 00 00       	mov    $0x0,%eax
  800041:	48 ba dd 01 80 00 00 	movabs $0x8001dd,%rdx
  800048:	00 00 00 
  80004b:	ff d2                	call   *%rdx
}
  80004d:	5d                   	pop    %rbp
  80004e:	c3                   	ret

000000000080004f <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80004f:	f3 0f 1e fa          	endbr64
  800053:	55                   	push   %rbp
  800054:	48 89 e5             	mov    %rsp,%rbp
  800057:	41 56                	push   %r14
  800059:	41 55                	push   %r13
  80005b:	41 54                	push   %r12
  80005d:	53                   	push   %rbx
  80005e:	41 89 fd             	mov    %edi,%r13d
  800061:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800064:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80006b:	00 00 00 
  80006e:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800075:	00 00 00 
  800078:	48 39 c2             	cmp    %rax,%rdx
  80007b:	73 17                	jae    800094 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80007d:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800080:	49 89 c4             	mov    %rax,%r12
  800083:	48 83 c3 08          	add    $0x8,%rbx
  800087:	b8 00 00 00 00       	mov    $0x0,%eax
  80008c:	ff 53 f8             	call   *-0x8(%rbx)
  80008f:	4c 39 e3             	cmp    %r12,%rbx
  800092:	72 ef                	jb     800083 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800094:	48 b8 5b 10 80 00 00 	movabs $0x80105b,%rax
  80009b:	00 00 00 
  80009e:	ff d0                	call   *%rax
  8000a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a5:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000a9:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000ad:	48 c1 e0 04          	shl    $0x4,%rax
  8000b1:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000b8:	00 00 00 
  8000bb:	48 01 d0             	add    %rdx,%rax
  8000be:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000c5:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000c8:	45 85 ed             	test   %r13d,%r13d
  8000cb:	7e 0d                	jle    8000da <libmain+0x8b>
  8000cd:	49 8b 06             	mov    (%r14),%rax
  8000d0:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000d7:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000da:	4c 89 f6             	mov    %r14,%rsi
  8000dd:	44 89 ef             	mov    %r13d,%edi
  8000e0:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000ec:	48 b8 01 01 80 00 00 	movabs $0x800101,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	call   *%rax
#endif
}
  8000f8:	5b                   	pop    %rbx
  8000f9:	41 5c                	pop    %r12
  8000fb:	41 5d                	pop    %r13
  8000fd:	41 5e                	pop    %r14
  8000ff:	5d                   	pop    %rbp
  800100:	c3                   	ret

0000000000800101 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800101:	f3 0f 1e fa          	endbr64
  800105:	55                   	push   %rbp
  800106:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800109:	48 b8 31 17 80 00 00 	movabs $0x801731,%rax
  800110:	00 00 00 
  800113:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800115:	bf 00 00 00 00       	mov    $0x0,%edi
  80011a:	48 b8 ec 0f 80 00 00 	movabs $0x800fec,%rax
  800121:	00 00 00 
  800124:	ff d0                	call   *%rax
}
  800126:	5d                   	pop    %rbp
  800127:	c3                   	ret

0000000000800128 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800128:	f3 0f 1e fa          	endbr64
  80012c:	55                   	push   %rbp
  80012d:	48 89 e5             	mov    %rsp,%rbp
  800130:	53                   	push   %rbx
  800131:	48 83 ec 08          	sub    $0x8,%rsp
  800135:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800138:	8b 06                	mov    (%rsi),%eax
  80013a:	8d 50 01             	lea    0x1(%rax),%edx
  80013d:	89 16                	mov    %edx,(%rsi)
  80013f:	48 98                	cltq
  800141:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800146:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80014c:	74 0a                	je     800158 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80014e:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800152:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800156:	c9                   	leave
  800157:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800158:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80015c:	be ff 00 00 00       	mov    $0xff,%esi
  800161:	48 b8 86 0f 80 00 00 	movabs $0x800f86,%rax
  800168:	00 00 00 
  80016b:	ff d0                	call   *%rax
        state->offset = 0;
  80016d:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800173:	eb d9                	jmp    80014e <putch+0x26>

0000000000800175 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800175:	f3 0f 1e fa          	endbr64
  800179:	55                   	push   %rbp
  80017a:	48 89 e5             	mov    %rsp,%rbp
  80017d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800184:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800187:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80018e:	b9 21 00 00 00       	mov    $0x21,%ecx
  800193:	b8 00 00 00 00       	mov    $0x0,%eax
  800198:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80019b:	48 89 f1             	mov    %rsi,%rcx
  80019e:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8001a5:	48 bf 28 01 80 00 00 	movabs $0x800128,%rdi
  8001ac:	00 00 00 
  8001af:	48 b8 3d 03 80 00 00 	movabs $0x80033d,%rax
  8001b6:	00 00 00 
  8001b9:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8001bb:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8001c2:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8001c9:	48 b8 86 0f 80 00 00 	movabs $0x800f86,%rax
  8001d0:	00 00 00 
  8001d3:	ff d0                	call   *%rax

    return state.count;
}
  8001d5:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8001db:	c9                   	leave
  8001dc:	c3                   	ret

00000000008001dd <cprintf>:

int
cprintf(const char *fmt, ...) {
  8001dd:	f3 0f 1e fa          	endbr64
  8001e1:	55                   	push   %rbp
  8001e2:	48 89 e5             	mov    %rsp,%rbp
  8001e5:	48 83 ec 50          	sub    $0x50,%rsp
  8001e9:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8001ed:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8001f1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8001f5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8001f9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8001fd:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800204:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800208:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80020c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800210:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800214:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800218:	48 b8 75 01 80 00 00 	movabs $0x800175,%rax
  80021f:	00 00 00 
  800222:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800224:	c9                   	leave
  800225:	c3                   	ret

0000000000800226 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800226:	f3 0f 1e fa          	endbr64
  80022a:	55                   	push   %rbp
  80022b:	48 89 e5             	mov    %rsp,%rbp
  80022e:	41 57                	push   %r15
  800230:	41 56                	push   %r14
  800232:	41 55                	push   %r13
  800234:	41 54                	push   %r12
  800236:	53                   	push   %rbx
  800237:	48 83 ec 18          	sub    $0x18,%rsp
  80023b:	49 89 fc             	mov    %rdi,%r12
  80023e:	49 89 f5             	mov    %rsi,%r13
  800241:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800245:	8b 45 10             	mov    0x10(%rbp),%eax
  800248:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80024b:	41 89 cf             	mov    %ecx,%r15d
  80024e:	4c 39 fa             	cmp    %r15,%rdx
  800251:	73 5b                	jae    8002ae <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800253:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800257:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80025b:	85 db                	test   %ebx,%ebx
  80025d:	7e 0e                	jle    80026d <print_num+0x47>
            putch(padc, put_arg);
  80025f:	4c 89 ee             	mov    %r13,%rsi
  800262:	44 89 f7             	mov    %r14d,%edi
  800265:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800268:	83 eb 01             	sub    $0x1,%ebx
  80026b:	75 f2                	jne    80025f <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  80026d:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800271:	48 b9 1f 30 80 00 00 	movabs $0x80301f,%rcx
  800278:	00 00 00 
  80027b:	48 b8 0e 30 80 00 00 	movabs $0x80300e,%rax
  800282:	00 00 00 
  800285:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800289:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80028d:	ba 00 00 00 00       	mov    $0x0,%edx
  800292:	49 f7 f7             	div    %r15
  800295:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800299:	4c 89 ee             	mov    %r13,%rsi
  80029c:	41 ff d4             	call   *%r12
}
  80029f:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8002a3:	5b                   	pop    %rbx
  8002a4:	41 5c                	pop    %r12
  8002a6:	41 5d                	pop    %r13
  8002a8:	41 5e                	pop    %r14
  8002aa:	41 5f                	pop    %r15
  8002ac:	5d                   	pop    %rbp
  8002ad:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8002ae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b7:	49 f7 f7             	div    %r15
  8002ba:	48 83 ec 08          	sub    $0x8,%rsp
  8002be:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8002c2:	52                   	push   %rdx
  8002c3:	45 0f be c9          	movsbl %r9b,%r9d
  8002c7:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8002cb:	48 89 c2             	mov    %rax,%rdx
  8002ce:	48 b8 26 02 80 00 00 	movabs $0x800226,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	call   *%rax
  8002da:	48 83 c4 10          	add    $0x10,%rsp
  8002de:	eb 8d                	jmp    80026d <print_num+0x47>

00000000008002e0 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8002e0:	f3 0f 1e fa          	endbr64
    state->count++;
  8002e4:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8002e8:	48 8b 06             	mov    (%rsi),%rax
  8002eb:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8002ef:	73 0a                	jae    8002fb <sprintputch+0x1b>
        *state->start++ = ch;
  8002f1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8002f5:	48 89 16             	mov    %rdx,(%rsi)
  8002f8:	40 88 38             	mov    %dil,(%rax)
    }
}
  8002fb:	c3                   	ret

00000000008002fc <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8002fc:	f3 0f 1e fa          	endbr64
  800300:	55                   	push   %rbp
  800301:	48 89 e5             	mov    %rsp,%rbp
  800304:	48 83 ec 50          	sub    $0x50,%rsp
  800308:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80030c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800310:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800314:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80031b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80031f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800323:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800327:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80032b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80032f:	48 b8 3d 03 80 00 00 	movabs $0x80033d,%rax
  800336:	00 00 00 
  800339:	ff d0                	call   *%rax
}
  80033b:	c9                   	leave
  80033c:	c3                   	ret

000000000080033d <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80033d:	f3 0f 1e fa          	endbr64
  800341:	55                   	push   %rbp
  800342:	48 89 e5             	mov    %rsp,%rbp
  800345:	41 57                	push   %r15
  800347:	41 56                	push   %r14
  800349:	41 55                	push   %r13
  80034b:	41 54                	push   %r12
  80034d:	53                   	push   %rbx
  80034e:	48 83 ec 38          	sub    $0x38,%rsp
  800352:	49 89 fe             	mov    %rdi,%r14
  800355:	49 89 f5             	mov    %rsi,%r13
  800358:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  80035b:	48 8b 01             	mov    (%rcx),%rax
  80035e:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800362:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800366:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80036a:	48 8b 41 10          	mov    0x10(%rcx),%rax
  80036e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800372:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800376:	0f b6 3b             	movzbl (%rbx),%edi
  800379:	40 80 ff 25          	cmp    $0x25,%dil
  80037d:	74 18                	je     800397 <vprintfmt+0x5a>
            if (!ch) return;
  80037f:	40 84 ff             	test   %dil,%dil
  800382:	0f 84 b2 06 00 00    	je     800a3a <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800388:	40 0f b6 ff          	movzbl %dil,%edi
  80038c:	4c 89 ee             	mov    %r13,%rsi
  80038f:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800392:	4c 89 e3             	mov    %r12,%rbx
  800395:	eb db                	jmp    800372 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800397:	be 00 00 00 00       	mov    $0x0,%esi
  80039c:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8003a0:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8003a5:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8003ab:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8003b2:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8003b6:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8003bb:	41 0f b6 04 24       	movzbl (%r12),%eax
  8003c0:	88 45 a0             	mov    %al,-0x60(%rbp)
  8003c3:	83 e8 23             	sub    $0x23,%eax
  8003c6:	3c 57                	cmp    $0x57,%al
  8003c8:	0f 87 52 06 00 00    	ja     800a20 <vprintfmt+0x6e3>
  8003ce:	0f b6 c0             	movzbl %al,%eax
  8003d1:	48 b9 60 32 80 00 00 	movabs $0x803260,%rcx
  8003d8:	00 00 00 
  8003db:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8003df:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8003e2:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8003e6:	eb ce                	jmp    8003b6 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8003e8:	49 89 dc             	mov    %rbx,%r12
  8003eb:	be 01 00 00 00       	mov    $0x1,%esi
  8003f0:	eb c4                	jmp    8003b6 <vprintfmt+0x79>
            padc = ch;
  8003f2:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8003f6:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8003f9:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8003fc:	eb b8                	jmp    8003b6 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8003fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800401:	83 f8 2f             	cmp    $0x2f,%eax
  800404:	77 24                	ja     80042a <vprintfmt+0xed>
  800406:	89 c1                	mov    %eax,%ecx
  800408:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  80040c:	83 c0 08             	add    $0x8,%eax
  80040f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800412:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800415:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800418:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80041c:	79 98                	jns    8003b6 <vprintfmt+0x79>
                width = precision;
  80041e:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800422:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800428:	eb 8c                	jmp    8003b6 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80042a:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80042e:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800432:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800436:	eb da                	jmp    800412 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800438:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  80043d:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800441:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800447:	3c 39                	cmp    $0x39,%al
  800449:	77 1c                	ja     800467 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  80044b:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  80044f:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800453:	0f b6 c0             	movzbl %al,%eax
  800456:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80045b:	0f b6 03             	movzbl (%rbx),%eax
  80045e:	3c 39                	cmp    $0x39,%al
  800460:	76 e9                	jbe    80044b <vprintfmt+0x10e>
        process_precision:
  800462:	49 89 dc             	mov    %rbx,%r12
  800465:	eb b1                	jmp    800418 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800467:	49 89 dc             	mov    %rbx,%r12
  80046a:	eb ac                	jmp    800418 <vprintfmt+0xdb>
            width = MAX(0, width);
  80046c:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  80046f:	85 c9                	test   %ecx,%ecx
  800471:	b8 00 00 00 00       	mov    $0x0,%eax
  800476:	0f 49 c1             	cmovns %ecx,%eax
  800479:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  80047c:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80047f:	e9 32 ff ff ff       	jmp    8003b6 <vprintfmt+0x79>
            lflag++;
  800484:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800487:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80048a:	e9 27 ff ff ff       	jmp    8003b6 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  80048f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800492:	83 f8 2f             	cmp    $0x2f,%eax
  800495:	77 19                	ja     8004b0 <vprintfmt+0x173>
  800497:	89 c2                	mov    %eax,%edx
  800499:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80049d:	83 c0 08             	add    $0x8,%eax
  8004a0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004a3:	8b 3a                	mov    (%rdx),%edi
  8004a5:	4c 89 ee             	mov    %r13,%rsi
  8004a8:	41 ff d6             	call   *%r14
            break;
  8004ab:	e9 c2 fe ff ff       	jmp    800372 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8004b0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004b4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8004b8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004bc:	eb e5                	jmp    8004a3 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8004be:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004c1:	83 f8 2f             	cmp    $0x2f,%eax
  8004c4:	77 5a                	ja     800520 <vprintfmt+0x1e3>
  8004c6:	89 c2                	mov    %eax,%edx
  8004c8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8004cc:	83 c0 08             	add    $0x8,%eax
  8004cf:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8004d2:	8b 02                	mov    (%rdx),%eax
  8004d4:	89 c1                	mov    %eax,%ecx
  8004d6:	f7 d9                	neg    %ecx
  8004d8:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8004db:	83 f9 13             	cmp    $0x13,%ecx
  8004de:	7f 4e                	jg     80052e <vprintfmt+0x1f1>
  8004e0:	48 63 c1             	movslq %ecx,%rax
  8004e3:	48 ba 20 35 80 00 00 	movabs $0x803520,%rdx
  8004ea:	00 00 00 
  8004ed:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8004f1:	48 85 c0             	test   %rax,%rax
  8004f4:	74 38                	je     80052e <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8004f6:	48 89 c1             	mov    %rax,%rcx
  8004f9:	48 ba 13 32 80 00 00 	movabs $0x803213,%rdx
  800500:	00 00 00 
  800503:	4c 89 ee             	mov    %r13,%rsi
  800506:	4c 89 f7             	mov    %r14,%rdi
  800509:	b8 00 00 00 00       	mov    $0x0,%eax
  80050e:	49 b8 fc 02 80 00 00 	movabs $0x8002fc,%r8
  800515:	00 00 00 
  800518:	41 ff d0             	call   *%r8
  80051b:	e9 52 fe ff ff       	jmp    800372 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800520:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800524:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800528:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80052c:	eb a4                	jmp    8004d2 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  80052e:	48 ba 37 30 80 00 00 	movabs $0x803037,%rdx
  800535:	00 00 00 
  800538:	4c 89 ee             	mov    %r13,%rsi
  80053b:	4c 89 f7             	mov    %r14,%rdi
  80053e:	b8 00 00 00 00       	mov    $0x0,%eax
  800543:	49 b8 fc 02 80 00 00 	movabs $0x8002fc,%r8
  80054a:	00 00 00 
  80054d:	41 ff d0             	call   *%r8
  800550:	e9 1d fe ff ff       	jmp    800372 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800555:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800558:	83 f8 2f             	cmp    $0x2f,%eax
  80055b:	77 6c                	ja     8005c9 <vprintfmt+0x28c>
  80055d:	89 c2                	mov    %eax,%edx
  80055f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800563:	83 c0 08             	add    $0x8,%eax
  800566:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800569:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  80056c:	48 85 d2             	test   %rdx,%rdx
  80056f:	48 b8 30 30 80 00 00 	movabs $0x803030,%rax
  800576:	00 00 00 
  800579:	48 0f 45 c2          	cmovne %rdx,%rax
  80057d:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800581:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800585:	7e 06                	jle    80058d <vprintfmt+0x250>
  800587:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  80058b:	75 4a                	jne    8005d7 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80058d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800591:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800595:	0f b6 00             	movzbl (%rax),%eax
  800598:	84 c0                	test   %al,%al
  80059a:	0f 85 9a 00 00 00    	jne    80063a <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8005a0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005a3:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8005a7:	85 c0                	test   %eax,%eax
  8005a9:	0f 8e c3 fd ff ff    	jle    800372 <vprintfmt+0x35>
  8005af:	4c 89 ee             	mov    %r13,%rsi
  8005b2:	bf 20 00 00 00       	mov    $0x20,%edi
  8005b7:	41 ff d6             	call   *%r14
  8005ba:	41 83 ec 01          	sub    $0x1,%r12d
  8005be:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8005c2:	75 eb                	jne    8005af <vprintfmt+0x272>
  8005c4:	e9 a9 fd ff ff       	jmp    800372 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8005c9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005cd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005d1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005d5:	eb 92                	jmp    800569 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8005d7:	49 63 f7             	movslq %r15d,%rsi
  8005da:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8005de:	48 b8 00 0b 80 00 00 	movabs $0x800b00,%rax
  8005e5:	00 00 00 
  8005e8:	ff d0                	call   *%rax
  8005ea:	48 89 c2             	mov    %rax,%rdx
  8005ed:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005f0:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8005f2:	8d 70 ff             	lea    -0x1(%rax),%esi
  8005f5:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8005f8:	85 c0                	test   %eax,%eax
  8005fa:	7e 91                	jle    80058d <vprintfmt+0x250>
  8005fc:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800601:	4c 89 ee             	mov    %r13,%rsi
  800604:	44 89 e7             	mov    %r12d,%edi
  800607:	41 ff d6             	call   *%r14
  80060a:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80060e:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800611:	83 f8 ff             	cmp    $0xffffffff,%eax
  800614:	75 eb                	jne    800601 <vprintfmt+0x2c4>
  800616:	e9 72 ff ff ff       	jmp    80058d <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80061b:	0f b6 f8             	movzbl %al,%edi
  80061e:	4c 89 ee             	mov    %r13,%rsi
  800621:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800624:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800628:	49 83 c4 01          	add    $0x1,%r12
  80062c:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800632:	84 c0                	test   %al,%al
  800634:	0f 84 66 ff ff ff    	je     8005a0 <vprintfmt+0x263>
  80063a:	45 85 ff             	test   %r15d,%r15d
  80063d:	78 0a                	js     800649 <vprintfmt+0x30c>
  80063f:	41 83 ef 01          	sub    $0x1,%r15d
  800643:	0f 88 57 ff ff ff    	js     8005a0 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800649:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  80064d:	74 cc                	je     80061b <vprintfmt+0x2de>
  80064f:	8d 50 e0             	lea    -0x20(%rax),%edx
  800652:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800657:	80 fa 5e             	cmp    $0x5e,%dl
  80065a:	77 c2                	ja     80061e <vprintfmt+0x2e1>
  80065c:	eb bd                	jmp    80061b <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  80065e:	40 84 f6             	test   %sil,%sil
  800661:	75 26                	jne    800689 <vprintfmt+0x34c>
    switch (lflag) {
  800663:	85 d2                	test   %edx,%edx
  800665:	74 59                	je     8006c0 <vprintfmt+0x383>
  800667:	83 fa 01             	cmp    $0x1,%edx
  80066a:	74 7b                	je     8006e7 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  80066c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80066f:	83 f8 2f             	cmp    $0x2f,%eax
  800672:	0f 87 96 00 00 00    	ja     80070e <vprintfmt+0x3d1>
  800678:	89 c2                	mov    %eax,%edx
  80067a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80067e:	83 c0 08             	add    $0x8,%eax
  800681:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800684:	4c 8b 22             	mov    (%rdx),%r12
  800687:	eb 17                	jmp    8006a0 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800689:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80068c:	83 f8 2f             	cmp    $0x2f,%eax
  80068f:	77 21                	ja     8006b2 <vprintfmt+0x375>
  800691:	89 c2                	mov    %eax,%edx
  800693:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800697:	83 c0 08             	add    $0x8,%eax
  80069a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80069d:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8006a0:	4d 85 e4             	test   %r12,%r12
  8006a3:	78 7a                	js     80071f <vprintfmt+0x3e2>
            num = i;
  8006a5:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8006a8:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006ad:	e9 50 02 00 00       	jmp    800902 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8006b2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006b6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006ba:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006be:	eb dd                	jmp    80069d <vprintfmt+0x360>
        return va_arg(*ap, int);
  8006c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006c3:	83 f8 2f             	cmp    $0x2f,%eax
  8006c6:	77 11                	ja     8006d9 <vprintfmt+0x39c>
  8006c8:	89 c2                	mov    %eax,%edx
  8006ca:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006ce:	83 c0 08             	add    $0x8,%eax
  8006d1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006d4:	4c 63 22             	movslq (%rdx),%r12
  8006d7:	eb c7                	jmp    8006a0 <vprintfmt+0x363>
  8006d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006dd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006e1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006e5:	eb ed                	jmp    8006d4 <vprintfmt+0x397>
        return va_arg(*ap, long);
  8006e7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006ea:	83 f8 2f             	cmp    $0x2f,%eax
  8006ed:	77 11                	ja     800700 <vprintfmt+0x3c3>
  8006ef:	89 c2                	mov    %eax,%edx
  8006f1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006f5:	83 c0 08             	add    $0x8,%eax
  8006f8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006fb:	4c 8b 22             	mov    (%rdx),%r12
  8006fe:	eb a0                	jmp    8006a0 <vprintfmt+0x363>
  800700:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800704:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800708:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80070c:	eb ed                	jmp    8006fb <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  80070e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800712:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800716:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80071a:	e9 65 ff ff ff       	jmp    800684 <vprintfmt+0x347>
                putch('-', put_arg);
  80071f:	4c 89 ee             	mov    %r13,%rsi
  800722:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800727:	41 ff d6             	call   *%r14
                i = -i;
  80072a:	49 f7 dc             	neg    %r12
  80072d:	e9 73 ff ff ff       	jmp    8006a5 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800732:	40 84 f6             	test   %sil,%sil
  800735:	75 32                	jne    800769 <vprintfmt+0x42c>
    switch (lflag) {
  800737:	85 d2                	test   %edx,%edx
  800739:	74 5d                	je     800798 <vprintfmt+0x45b>
  80073b:	83 fa 01             	cmp    $0x1,%edx
  80073e:	0f 84 82 00 00 00    	je     8007c6 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800744:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800747:	83 f8 2f             	cmp    $0x2f,%eax
  80074a:	0f 87 a5 00 00 00    	ja     8007f5 <vprintfmt+0x4b8>
  800750:	89 c2                	mov    %eax,%edx
  800752:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800756:	83 c0 08             	add    $0x8,%eax
  800759:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80075c:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80075f:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800764:	e9 99 01 00 00       	jmp    800902 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800769:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80076c:	83 f8 2f             	cmp    $0x2f,%eax
  80076f:	77 19                	ja     80078a <vprintfmt+0x44d>
  800771:	89 c2                	mov    %eax,%edx
  800773:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800777:	83 c0 08             	add    $0x8,%eax
  80077a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80077d:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800780:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800785:	e9 78 01 00 00       	jmp    800902 <vprintfmt+0x5c5>
  80078a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80078e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800792:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800796:	eb e5                	jmp    80077d <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800798:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079b:	83 f8 2f             	cmp    $0x2f,%eax
  80079e:	77 18                	ja     8007b8 <vprintfmt+0x47b>
  8007a0:	89 c2                	mov    %eax,%edx
  8007a2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007a6:	83 c0 08             	add    $0x8,%eax
  8007a9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007ac:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8007ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8007b3:	e9 4a 01 00 00       	jmp    800902 <vprintfmt+0x5c5>
  8007b8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007bc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007c0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007c4:	eb e6                	jmp    8007ac <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8007c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c9:	83 f8 2f             	cmp    $0x2f,%eax
  8007cc:	77 19                	ja     8007e7 <vprintfmt+0x4aa>
  8007ce:	89 c2                	mov    %eax,%edx
  8007d0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007d4:	83 c0 08             	add    $0x8,%eax
  8007d7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007da:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8007dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8007e2:	e9 1b 01 00 00       	jmp    800902 <vprintfmt+0x5c5>
  8007e7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007eb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007ef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007f3:	eb e5                	jmp    8007da <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  8007f5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007f9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007fd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800801:	e9 56 ff ff ff       	jmp    80075c <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800806:	40 84 f6             	test   %sil,%sil
  800809:	75 2e                	jne    800839 <vprintfmt+0x4fc>
    switch (lflag) {
  80080b:	85 d2                	test   %edx,%edx
  80080d:	74 59                	je     800868 <vprintfmt+0x52b>
  80080f:	83 fa 01             	cmp    $0x1,%edx
  800812:	74 7f                	je     800893 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800814:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800817:	83 f8 2f             	cmp    $0x2f,%eax
  80081a:	0f 87 9f 00 00 00    	ja     8008bf <vprintfmt+0x582>
  800820:	89 c2                	mov    %eax,%edx
  800822:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800826:	83 c0 08             	add    $0x8,%eax
  800829:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80082c:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80082f:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800834:	e9 c9 00 00 00       	jmp    800902 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800839:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80083c:	83 f8 2f             	cmp    $0x2f,%eax
  80083f:	77 19                	ja     80085a <vprintfmt+0x51d>
  800841:	89 c2                	mov    %eax,%edx
  800843:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800847:	83 c0 08             	add    $0x8,%eax
  80084a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80084d:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800850:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800855:	e9 a8 00 00 00       	jmp    800902 <vprintfmt+0x5c5>
  80085a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80085e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800862:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800866:	eb e5                	jmp    80084d <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800868:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086b:	83 f8 2f             	cmp    $0x2f,%eax
  80086e:	77 15                	ja     800885 <vprintfmt+0x548>
  800870:	89 c2                	mov    %eax,%edx
  800872:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800876:	83 c0 08             	add    $0x8,%eax
  800879:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80087c:	8b 12                	mov    (%rdx),%edx
            base = 8;
  80087e:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800883:	eb 7d                	jmp    800902 <vprintfmt+0x5c5>
  800885:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800889:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80088d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800891:	eb e9                	jmp    80087c <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800893:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800896:	83 f8 2f             	cmp    $0x2f,%eax
  800899:	77 16                	ja     8008b1 <vprintfmt+0x574>
  80089b:	89 c2                	mov    %eax,%edx
  80089d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008a1:	83 c0 08             	add    $0x8,%eax
  8008a4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008a7:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8008aa:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008af:	eb 51                	jmp    800902 <vprintfmt+0x5c5>
  8008b1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008b9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008bd:	eb e8                	jmp    8008a7 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8008bf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008c7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008cb:	e9 5c ff ff ff       	jmp    80082c <vprintfmt+0x4ef>
            putch('0', put_arg);
  8008d0:	4c 89 ee             	mov    %r13,%rsi
  8008d3:	bf 30 00 00 00       	mov    $0x30,%edi
  8008d8:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  8008db:	4c 89 ee             	mov    %r13,%rsi
  8008de:	bf 78 00 00 00       	mov    $0x78,%edi
  8008e3:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  8008e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e9:	83 f8 2f             	cmp    $0x2f,%eax
  8008ec:	77 47                	ja     800935 <vprintfmt+0x5f8>
  8008ee:	89 c2                	mov    %eax,%edx
  8008f0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008f4:	83 c0 08             	add    $0x8,%eax
  8008f7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008fa:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8008fd:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800902:	48 83 ec 08          	sub    $0x8,%rsp
  800906:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  80090a:	0f 94 c0             	sete   %al
  80090d:	0f b6 c0             	movzbl %al,%eax
  800910:	50                   	push   %rax
  800911:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800916:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80091a:	4c 89 ee             	mov    %r13,%rsi
  80091d:	4c 89 f7             	mov    %r14,%rdi
  800920:	48 b8 26 02 80 00 00 	movabs $0x800226,%rax
  800927:	00 00 00 
  80092a:	ff d0                	call   *%rax
            break;
  80092c:	48 83 c4 10          	add    $0x10,%rsp
  800930:	e9 3d fa ff ff       	jmp    800372 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800935:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800939:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80093d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800941:	eb b7                	jmp    8008fa <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800943:	40 84 f6             	test   %sil,%sil
  800946:	75 2b                	jne    800973 <vprintfmt+0x636>
    switch (lflag) {
  800948:	85 d2                	test   %edx,%edx
  80094a:	74 56                	je     8009a2 <vprintfmt+0x665>
  80094c:	83 fa 01             	cmp    $0x1,%edx
  80094f:	74 7f                	je     8009d0 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800951:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800954:	83 f8 2f             	cmp    $0x2f,%eax
  800957:	0f 87 a2 00 00 00    	ja     8009ff <vprintfmt+0x6c2>
  80095d:	89 c2                	mov    %eax,%edx
  80095f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800963:	83 c0 08             	add    $0x8,%eax
  800966:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800969:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80096c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800971:	eb 8f                	jmp    800902 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800973:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800976:	83 f8 2f             	cmp    $0x2f,%eax
  800979:	77 19                	ja     800994 <vprintfmt+0x657>
  80097b:	89 c2                	mov    %eax,%edx
  80097d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800981:	83 c0 08             	add    $0x8,%eax
  800984:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800987:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80098a:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80098f:	e9 6e ff ff ff       	jmp    800902 <vprintfmt+0x5c5>
  800994:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800998:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80099c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009a0:	eb e5                	jmp    800987 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8009a2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a5:	83 f8 2f             	cmp    $0x2f,%eax
  8009a8:	77 18                	ja     8009c2 <vprintfmt+0x685>
  8009aa:	89 c2                	mov    %eax,%edx
  8009ac:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009b0:	83 c0 08             	add    $0x8,%eax
  8009b3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009b6:	8b 12                	mov    (%rdx),%edx
            base = 16;
  8009b8:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8009bd:	e9 40 ff ff ff       	jmp    800902 <vprintfmt+0x5c5>
  8009c2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009c6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009ca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ce:	eb e6                	jmp    8009b6 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  8009d0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d3:	83 f8 2f             	cmp    $0x2f,%eax
  8009d6:	77 19                	ja     8009f1 <vprintfmt+0x6b4>
  8009d8:	89 c2                	mov    %eax,%edx
  8009da:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009de:	83 c0 08             	add    $0x8,%eax
  8009e1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009e4:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009e7:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8009ec:	e9 11 ff ff ff       	jmp    800902 <vprintfmt+0x5c5>
  8009f1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009f5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009f9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009fd:	eb e5                	jmp    8009e4 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  8009ff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a03:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a07:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a0b:	e9 59 ff ff ff       	jmp    800969 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800a10:	4c 89 ee             	mov    %r13,%rsi
  800a13:	bf 25 00 00 00       	mov    $0x25,%edi
  800a18:	41 ff d6             	call   *%r14
            break;
  800a1b:	e9 52 f9 ff ff       	jmp    800372 <vprintfmt+0x35>
            putch('%', put_arg);
  800a20:	4c 89 ee             	mov    %r13,%rsi
  800a23:	bf 25 00 00 00       	mov    $0x25,%edi
  800a28:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800a2b:	48 83 eb 01          	sub    $0x1,%rbx
  800a2f:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800a33:	75 f6                	jne    800a2b <vprintfmt+0x6ee>
  800a35:	e9 38 f9 ff ff       	jmp    800372 <vprintfmt+0x35>
}
  800a3a:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a3e:	5b                   	pop    %rbx
  800a3f:	41 5c                	pop    %r12
  800a41:	41 5d                	pop    %r13
  800a43:	41 5e                	pop    %r14
  800a45:	41 5f                	pop    %r15
  800a47:	5d                   	pop    %rbp
  800a48:	c3                   	ret

0000000000800a49 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a49:	f3 0f 1e fa          	endbr64
  800a4d:	55                   	push   %rbp
  800a4e:	48 89 e5             	mov    %rsp,%rbp
  800a51:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800a55:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a59:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800a5e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800a62:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800a69:	48 85 ff             	test   %rdi,%rdi
  800a6c:	74 2b                	je     800a99 <vsnprintf+0x50>
  800a6e:	48 85 f6             	test   %rsi,%rsi
  800a71:	74 26                	je     800a99 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800a73:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800a77:	48 bf e0 02 80 00 00 	movabs $0x8002e0,%rdi
  800a7e:	00 00 00 
  800a81:	48 b8 3d 03 80 00 00 	movabs $0x80033d,%rax
  800a88:	00 00 00 
  800a8b:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800a8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a91:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800a94:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800a97:	c9                   	leave
  800a98:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800a99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a9e:	eb f7                	jmp    800a97 <vsnprintf+0x4e>

0000000000800aa0 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800aa0:	f3 0f 1e fa          	endbr64
  800aa4:	55                   	push   %rbp
  800aa5:	48 89 e5             	mov    %rsp,%rbp
  800aa8:	48 83 ec 50          	sub    $0x50,%rsp
  800aac:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800ab0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800ab4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800ab8:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800abf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ac3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800acb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800acf:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ad3:	48 b8 49 0a 80 00 00 	movabs $0x800a49,%rax
  800ada:	00 00 00 
  800add:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800adf:	c9                   	leave
  800ae0:	c3                   	ret

0000000000800ae1 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800ae1:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800ae5:	80 3f 00             	cmpb   $0x0,(%rdi)
  800ae8:	74 10                	je     800afa <strlen+0x19>
    size_t n = 0;
  800aea:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800aef:	48 83 c0 01          	add    $0x1,%rax
  800af3:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800af7:	75 f6                	jne    800aef <strlen+0xe>
  800af9:	c3                   	ret
    size_t n = 0;
  800afa:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800aff:	c3                   	ret

0000000000800b00 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800b00:	f3 0f 1e fa          	endbr64
  800b04:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800b07:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800b0c:	48 85 f6             	test   %rsi,%rsi
  800b0f:	74 10                	je     800b21 <strnlen+0x21>
  800b11:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800b15:	74 0b                	je     800b22 <strnlen+0x22>
  800b17:	48 83 c2 01          	add    $0x1,%rdx
  800b1b:	48 39 d0             	cmp    %rdx,%rax
  800b1e:	75 f1                	jne    800b11 <strnlen+0x11>
  800b20:	c3                   	ret
  800b21:	c3                   	ret
  800b22:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800b25:	c3                   	ret

0000000000800b26 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800b26:	f3 0f 1e fa          	endbr64
  800b2a:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b32:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800b36:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800b39:	48 83 c2 01          	add    $0x1,%rdx
  800b3d:	84 c9                	test   %cl,%cl
  800b3f:	75 f1                	jne    800b32 <strcpy+0xc>
        ;
    return res;
}
  800b41:	c3                   	ret

0000000000800b42 <strcat>:

char *
strcat(char *dst, const char *src) {
  800b42:	f3 0f 1e fa          	endbr64
  800b46:	55                   	push   %rbp
  800b47:	48 89 e5             	mov    %rsp,%rbp
  800b4a:	41 54                	push   %r12
  800b4c:	53                   	push   %rbx
  800b4d:	48 89 fb             	mov    %rdi,%rbx
  800b50:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800b53:	48 b8 e1 0a 80 00 00 	movabs $0x800ae1,%rax
  800b5a:	00 00 00 
  800b5d:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800b5f:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800b63:	4c 89 e6             	mov    %r12,%rsi
  800b66:	48 b8 26 0b 80 00 00 	movabs $0x800b26,%rax
  800b6d:	00 00 00 
  800b70:	ff d0                	call   *%rax
    return dst;
}
  800b72:	48 89 d8             	mov    %rbx,%rax
  800b75:	5b                   	pop    %rbx
  800b76:	41 5c                	pop    %r12
  800b78:	5d                   	pop    %rbp
  800b79:	c3                   	ret

0000000000800b7a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b7a:	f3 0f 1e fa          	endbr64
  800b7e:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800b81:	48 85 d2             	test   %rdx,%rdx
  800b84:	74 1f                	je     800ba5 <strncpy+0x2b>
  800b86:	48 01 fa             	add    %rdi,%rdx
  800b89:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800b8c:	48 83 c1 01          	add    $0x1,%rcx
  800b90:	44 0f b6 06          	movzbl (%rsi),%r8d
  800b94:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800b98:	41 80 f8 01          	cmp    $0x1,%r8b
  800b9c:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800ba0:	48 39 ca             	cmp    %rcx,%rdx
  800ba3:	75 e7                	jne    800b8c <strncpy+0x12>
    }
    return ret;
}
  800ba5:	c3                   	ret

0000000000800ba6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800ba6:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800baa:	48 89 f8             	mov    %rdi,%rax
  800bad:	48 85 d2             	test   %rdx,%rdx
  800bb0:	74 24                	je     800bd6 <strlcpy+0x30>
        while (--size > 0 && *src)
  800bb2:	48 83 ea 01          	sub    $0x1,%rdx
  800bb6:	74 1b                	je     800bd3 <strlcpy+0x2d>
  800bb8:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800bbc:	0f b6 16             	movzbl (%rsi),%edx
  800bbf:	84 d2                	test   %dl,%dl
  800bc1:	74 10                	je     800bd3 <strlcpy+0x2d>
            *dst++ = *src++;
  800bc3:	48 83 c6 01          	add    $0x1,%rsi
  800bc7:	48 83 c0 01          	add    $0x1,%rax
  800bcb:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800bce:	48 39 c8             	cmp    %rcx,%rax
  800bd1:	75 e9                	jne    800bbc <strlcpy+0x16>
        *dst = '\0';
  800bd3:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800bd6:	48 29 f8             	sub    %rdi,%rax
}
  800bd9:	c3                   	ret

0000000000800bda <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800bda:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800bde:	0f b6 07             	movzbl (%rdi),%eax
  800be1:	84 c0                	test   %al,%al
  800be3:	74 13                	je     800bf8 <strcmp+0x1e>
  800be5:	38 06                	cmp    %al,(%rsi)
  800be7:	75 0f                	jne    800bf8 <strcmp+0x1e>
  800be9:	48 83 c7 01          	add    $0x1,%rdi
  800bed:	48 83 c6 01          	add    $0x1,%rsi
  800bf1:	0f b6 07             	movzbl (%rdi),%eax
  800bf4:	84 c0                	test   %al,%al
  800bf6:	75 ed                	jne    800be5 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800bf8:	0f b6 c0             	movzbl %al,%eax
  800bfb:	0f b6 16             	movzbl (%rsi),%edx
  800bfe:	29 d0                	sub    %edx,%eax
}
  800c00:	c3                   	ret

0000000000800c01 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800c01:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800c05:	48 85 d2             	test   %rdx,%rdx
  800c08:	74 1f                	je     800c29 <strncmp+0x28>
  800c0a:	0f b6 07             	movzbl (%rdi),%eax
  800c0d:	84 c0                	test   %al,%al
  800c0f:	74 1e                	je     800c2f <strncmp+0x2e>
  800c11:	3a 06                	cmp    (%rsi),%al
  800c13:	75 1a                	jne    800c2f <strncmp+0x2e>
  800c15:	48 83 c7 01          	add    $0x1,%rdi
  800c19:	48 83 c6 01          	add    $0x1,%rsi
  800c1d:	48 83 ea 01          	sub    $0x1,%rdx
  800c21:	75 e7                	jne    800c0a <strncmp+0x9>

    if (!n) return 0;
  800c23:	b8 00 00 00 00       	mov    $0x0,%eax
  800c28:	c3                   	ret
  800c29:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2e:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c2f:	0f b6 07             	movzbl (%rdi),%eax
  800c32:	0f b6 16             	movzbl (%rsi),%edx
  800c35:	29 d0                	sub    %edx,%eax
}
  800c37:	c3                   	ret

0000000000800c38 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800c38:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800c3c:	0f b6 17             	movzbl (%rdi),%edx
  800c3f:	84 d2                	test   %dl,%dl
  800c41:	74 18                	je     800c5b <strchr+0x23>
        if (*str == c) {
  800c43:	0f be d2             	movsbl %dl,%edx
  800c46:	39 f2                	cmp    %esi,%edx
  800c48:	74 17                	je     800c61 <strchr+0x29>
    for (; *str; str++) {
  800c4a:	48 83 c7 01          	add    $0x1,%rdi
  800c4e:	0f b6 17             	movzbl (%rdi),%edx
  800c51:	84 d2                	test   %dl,%dl
  800c53:	75 ee                	jne    800c43 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800c55:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5a:	c3                   	ret
  800c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c60:	c3                   	ret
            return (char *)str;
  800c61:	48 89 f8             	mov    %rdi,%rax
}
  800c64:	c3                   	ret

0000000000800c65 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800c65:	f3 0f 1e fa          	endbr64
  800c69:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800c6c:	0f b6 17             	movzbl (%rdi),%edx
  800c6f:	84 d2                	test   %dl,%dl
  800c71:	74 13                	je     800c86 <strfind+0x21>
  800c73:	0f be d2             	movsbl %dl,%edx
  800c76:	39 f2                	cmp    %esi,%edx
  800c78:	74 0b                	je     800c85 <strfind+0x20>
  800c7a:	48 83 c0 01          	add    $0x1,%rax
  800c7e:	0f b6 10             	movzbl (%rax),%edx
  800c81:	84 d2                	test   %dl,%dl
  800c83:	75 ee                	jne    800c73 <strfind+0xe>
        ;
    return (char *)str;
}
  800c85:	c3                   	ret
  800c86:	c3                   	ret

0000000000800c87 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800c87:	f3 0f 1e fa          	endbr64
  800c8b:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800c8e:	48 89 f8             	mov    %rdi,%rax
  800c91:	48 f7 d8             	neg    %rax
  800c94:	83 e0 07             	and    $0x7,%eax
  800c97:	49 89 d1             	mov    %rdx,%r9
  800c9a:	49 29 c1             	sub    %rax,%r9
  800c9d:	78 36                	js     800cd5 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800c9f:	40 0f b6 c6          	movzbl %sil,%eax
  800ca3:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800caa:	01 01 01 
  800cad:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800cb1:	40 f6 c7 07          	test   $0x7,%dil
  800cb5:	75 38                	jne    800cef <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800cb7:	4c 89 c9             	mov    %r9,%rcx
  800cba:	48 c1 f9 03          	sar    $0x3,%rcx
  800cbe:	74 0c                	je     800ccc <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800cc0:	fc                   	cld
  800cc1:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800cc4:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800cc8:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800ccc:	4d 85 c9             	test   %r9,%r9
  800ccf:	75 45                	jne    800d16 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800cd1:	4c 89 c0             	mov    %r8,%rax
  800cd4:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800cd5:	48 85 d2             	test   %rdx,%rdx
  800cd8:	74 f7                	je     800cd1 <memset+0x4a>
  800cda:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800cdd:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800ce0:	48 83 c0 01          	add    $0x1,%rax
  800ce4:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800ce8:	48 39 c2             	cmp    %rax,%rdx
  800ceb:	75 f3                	jne    800ce0 <memset+0x59>
  800ced:	eb e2                	jmp    800cd1 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800cef:	40 f6 c7 01          	test   $0x1,%dil
  800cf3:	74 06                	je     800cfb <memset+0x74>
  800cf5:	88 07                	mov    %al,(%rdi)
  800cf7:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800cfb:	40 f6 c7 02          	test   $0x2,%dil
  800cff:	74 07                	je     800d08 <memset+0x81>
  800d01:	66 89 07             	mov    %ax,(%rdi)
  800d04:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d08:	40 f6 c7 04          	test   $0x4,%dil
  800d0c:	74 a9                	je     800cb7 <memset+0x30>
  800d0e:	89 07                	mov    %eax,(%rdi)
  800d10:	48 83 c7 04          	add    $0x4,%rdi
  800d14:	eb a1                	jmp    800cb7 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d16:	41 f6 c1 04          	test   $0x4,%r9b
  800d1a:	74 1b                	je     800d37 <memset+0xb0>
  800d1c:	89 07                	mov    %eax,(%rdi)
  800d1e:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d22:	41 f6 c1 02          	test   $0x2,%r9b
  800d26:	74 07                	je     800d2f <memset+0xa8>
  800d28:	66 89 07             	mov    %ax,(%rdi)
  800d2b:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d2f:	41 f6 c1 01          	test   $0x1,%r9b
  800d33:	74 9c                	je     800cd1 <memset+0x4a>
  800d35:	eb 06                	jmp    800d3d <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d37:	41 f6 c1 02          	test   $0x2,%r9b
  800d3b:	75 eb                	jne    800d28 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800d3d:	88 07                	mov    %al,(%rdi)
  800d3f:	eb 90                	jmp    800cd1 <memset+0x4a>

0000000000800d41 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d41:	f3 0f 1e fa          	endbr64
  800d45:	48 89 f8             	mov    %rdi,%rax
  800d48:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d4b:	48 39 fe             	cmp    %rdi,%rsi
  800d4e:	73 3b                	jae    800d8b <memmove+0x4a>
  800d50:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800d54:	48 39 d7             	cmp    %rdx,%rdi
  800d57:	73 32                	jae    800d8b <memmove+0x4a>
        s += n;
        d += n;
  800d59:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d5d:	48 89 d6             	mov    %rdx,%rsi
  800d60:	48 09 fe             	or     %rdi,%rsi
  800d63:	48 09 ce             	or     %rcx,%rsi
  800d66:	40 f6 c6 07          	test   $0x7,%sil
  800d6a:	75 12                	jne    800d7e <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800d6c:	48 83 ef 08          	sub    $0x8,%rdi
  800d70:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800d74:	48 c1 e9 03          	shr    $0x3,%rcx
  800d78:	fd                   	std
  800d79:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800d7c:	fc                   	cld
  800d7d:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800d7e:	48 83 ef 01          	sub    $0x1,%rdi
  800d82:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800d86:	fd                   	std
  800d87:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800d89:	eb f1                	jmp    800d7c <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d8b:	48 89 f2             	mov    %rsi,%rdx
  800d8e:	48 09 c2             	or     %rax,%rdx
  800d91:	48 09 ca             	or     %rcx,%rdx
  800d94:	f6 c2 07             	test   $0x7,%dl
  800d97:	75 0c                	jne    800da5 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800d99:	48 c1 e9 03          	shr    $0x3,%rcx
  800d9d:	48 89 c7             	mov    %rax,%rdi
  800da0:	fc                   	cld
  800da1:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800da4:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800da5:	48 89 c7             	mov    %rax,%rdi
  800da8:	fc                   	cld
  800da9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800dab:	c3                   	ret

0000000000800dac <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800dac:	f3 0f 1e fa          	endbr64
  800db0:	55                   	push   %rbp
  800db1:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800db4:	48 b8 41 0d 80 00 00 	movabs $0x800d41,%rax
  800dbb:	00 00 00 
  800dbe:	ff d0                	call   *%rax
}
  800dc0:	5d                   	pop    %rbp
  800dc1:	c3                   	ret

0000000000800dc2 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800dc2:	f3 0f 1e fa          	endbr64
  800dc6:	55                   	push   %rbp
  800dc7:	48 89 e5             	mov    %rsp,%rbp
  800dca:	41 57                	push   %r15
  800dcc:	41 56                	push   %r14
  800dce:	41 55                	push   %r13
  800dd0:	41 54                	push   %r12
  800dd2:	53                   	push   %rbx
  800dd3:	48 83 ec 08          	sub    $0x8,%rsp
  800dd7:	49 89 fe             	mov    %rdi,%r14
  800dda:	49 89 f7             	mov    %rsi,%r15
  800ddd:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800de0:	48 89 f7             	mov    %rsi,%rdi
  800de3:	48 b8 e1 0a 80 00 00 	movabs $0x800ae1,%rax
  800dea:	00 00 00 
  800ded:	ff d0                	call   *%rax
  800def:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800df2:	48 89 de             	mov    %rbx,%rsi
  800df5:	4c 89 f7             	mov    %r14,%rdi
  800df8:	48 b8 00 0b 80 00 00 	movabs $0x800b00,%rax
  800dff:	00 00 00 
  800e02:	ff d0                	call   *%rax
  800e04:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800e07:	48 39 c3             	cmp    %rax,%rbx
  800e0a:	74 36                	je     800e42 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800e0c:	48 89 d8             	mov    %rbx,%rax
  800e0f:	4c 29 e8             	sub    %r13,%rax
  800e12:	49 39 c4             	cmp    %rax,%r12
  800e15:	73 31                	jae    800e48 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800e17:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800e1c:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e20:	4c 89 fe             	mov    %r15,%rsi
  800e23:	48 b8 ac 0d 80 00 00 	movabs $0x800dac,%rax
  800e2a:	00 00 00 
  800e2d:	ff d0                	call   *%rax
    return dstlen + srclen;
  800e2f:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800e33:	48 83 c4 08          	add    $0x8,%rsp
  800e37:	5b                   	pop    %rbx
  800e38:	41 5c                	pop    %r12
  800e3a:	41 5d                	pop    %r13
  800e3c:	41 5e                	pop    %r14
  800e3e:	41 5f                	pop    %r15
  800e40:	5d                   	pop    %rbp
  800e41:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800e42:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800e46:	eb eb                	jmp    800e33 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e48:	48 83 eb 01          	sub    $0x1,%rbx
  800e4c:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e50:	48 89 da             	mov    %rbx,%rdx
  800e53:	4c 89 fe             	mov    %r15,%rsi
  800e56:	48 b8 ac 0d 80 00 00 	movabs $0x800dac,%rax
  800e5d:	00 00 00 
  800e60:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800e62:	49 01 de             	add    %rbx,%r14
  800e65:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800e6a:	eb c3                	jmp    800e2f <strlcat+0x6d>

0000000000800e6c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800e6c:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800e70:	48 85 d2             	test   %rdx,%rdx
  800e73:	74 2d                	je     800ea2 <memcmp+0x36>
  800e75:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800e7a:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800e7e:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800e83:	44 38 c1             	cmp    %r8b,%cl
  800e86:	75 0f                	jne    800e97 <memcmp+0x2b>
    while (n-- > 0) {
  800e88:	48 83 c0 01          	add    $0x1,%rax
  800e8c:	48 39 c2             	cmp    %rax,%rdx
  800e8f:	75 e9                	jne    800e7a <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800e91:	b8 00 00 00 00       	mov    $0x0,%eax
  800e96:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800e97:	0f b6 c1             	movzbl %cl,%eax
  800e9a:	45 0f b6 c0          	movzbl %r8b,%r8d
  800e9e:	44 29 c0             	sub    %r8d,%eax
  800ea1:	c3                   	ret
    return 0;
  800ea2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea7:	c3                   	ret

0000000000800ea8 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800ea8:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800eac:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800eb0:	48 39 c7             	cmp    %rax,%rdi
  800eb3:	73 0f                	jae    800ec4 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800eb5:	40 38 37             	cmp    %sil,(%rdi)
  800eb8:	74 0e                	je     800ec8 <memfind+0x20>
    for (; src < end; src++) {
  800eba:	48 83 c7 01          	add    $0x1,%rdi
  800ebe:	48 39 f8             	cmp    %rdi,%rax
  800ec1:	75 f2                	jne    800eb5 <memfind+0xd>
  800ec3:	c3                   	ret
  800ec4:	48 89 f8             	mov    %rdi,%rax
  800ec7:	c3                   	ret
  800ec8:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800ecb:	c3                   	ret

0000000000800ecc <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800ecc:	f3 0f 1e fa          	endbr64
  800ed0:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800ed3:	0f b6 37             	movzbl (%rdi),%esi
  800ed6:	40 80 fe 20          	cmp    $0x20,%sil
  800eda:	74 06                	je     800ee2 <strtol+0x16>
  800edc:	40 80 fe 09          	cmp    $0x9,%sil
  800ee0:	75 13                	jne    800ef5 <strtol+0x29>
  800ee2:	48 83 c7 01          	add    $0x1,%rdi
  800ee6:	0f b6 37             	movzbl (%rdi),%esi
  800ee9:	40 80 fe 20          	cmp    $0x20,%sil
  800eed:	74 f3                	je     800ee2 <strtol+0x16>
  800eef:	40 80 fe 09          	cmp    $0x9,%sil
  800ef3:	74 ed                	je     800ee2 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800ef5:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800ef8:	83 e0 fd             	and    $0xfffffffd,%eax
  800efb:	3c 01                	cmp    $0x1,%al
  800efd:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f01:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  800f07:	75 0f                	jne    800f18 <strtol+0x4c>
  800f09:	80 3f 30             	cmpb   $0x30,(%rdi)
  800f0c:	74 14                	je     800f22 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800f0e:	85 d2                	test   %edx,%edx
  800f10:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f15:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  800f18:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800f1d:	4c 63 ca             	movslq %edx,%r9
  800f20:	eb 36                	jmp    800f58 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f22:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800f26:	74 0f                	je     800f37 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  800f28:	85 d2                	test   %edx,%edx
  800f2a:	75 ec                	jne    800f18 <strtol+0x4c>
        s++;
  800f2c:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800f30:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  800f35:	eb e1                	jmp    800f18 <strtol+0x4c>
        s += 2;
  800f37:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f3b:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  800f40:	eb d6                	jmp    800f18 <strtol+0x4c>
            dig -= '0';
  800f42:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  800f45:	44 0f b6 c1          	movzbl %cl,%r8d
  800f49:	41 39 d0             	cmp    %edx,%r8d
  800f4c:	7d 21                	jge    800f6f <strtol+0xa3>
        val = val * base + dig;
  800f4e:	49 0f af c1          	imul   %r9,%rax
  800f52:	0f b6 c9             	movzbl %cl,%ecx
  800f55:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  800f58:	48 83 c7 01          	add    $0x1,%rdi
  800f5c:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  800f60:	80 f9 39             	cmp    $0x39,%cl
  800f63:	76 dd                	jbe    800f42 <strtol+0x76>
        else if (dig - 'a' < 27)
  800f65:	80 f9 7b             	cmp    $0x7b,%cl
  800f68:	77 05                	ja     800f6f <strtol+0xa3>
            dig -= 'a' - 10;
  800f6a:	83 e9 57             	sub    $0x57,%ecx
  800f6d:	eb d6                	jmp    800f45 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  800f6f:	4d 85 d2             	test   %r10,%r10
  800f72:	74 03                	je     800f77 <strtol+0xab>
  800f74:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800f77:	48 89 c2             	mov    %rax,%rdx
  800f7a:	48 f7 da             	neg    %rdx
  800f7d:	40 80 fe 2d          	cmp    $0x2d,%sil
  800f81:	48 0f 44 c2          	cmove  %rdx,%rax
}
  800f85:	c3                   	ret

0000000000800f86 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800f86:	f3 0f 1e fa          	endbr64
  800f8a:	55                   	push   %rbp
  800f8b:	48 89 e5             	mov    %rsp,%rbp
  800f8e:	53                   	push   %rbx
  800f8f:	48 89 fa             	mov    %rdi,%rdx
  800f92:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800f95:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800f9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fa4:	be 00 00 00 00       	mov    $0x0,%esi
  800fa9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800faf:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800fb1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fb5:	c9                   	leave
  800fb6:	c3                   	ret

0000000000800fb7 <sys_cgetc>:

int
sys_cgetc(void) {
  800fb7:	f3 0f 1e fa          	endbr64
  800fbb:	55                   	push   %rbp
  800fbc:	48 89 e5             	mov    %rsp,%rbp
  800fbf:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800fc0:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800fc5:	ba 00 00 00 00       	mov    $0x0,%edx
  800fca:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fcf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fd9:	be 00 00 00 00       	mov    $0x0,%esi
  800fde:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fe4:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800fe6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fea:	c9                   	leave
  800feb:	c3                   	ret

0000000000800fec <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800fec:	f3 0f 1e fa          	endbr64
  800ff0:	55                   	push   %rbp
  800ff1:	48 89 e5             	mov    %rsp,%rbp
  800ff4:	53                   	push   %rbx
  800ff5:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800ff9:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800ffc:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801001:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801006:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801010:	be 00 00 00 00       	mov    $0x0,%esi
  801015:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80101b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80101d:	48 85 c0             	test   %rax,%rax
  801020:	7f 06                	jg     801028 <sys_env_destroy+0x3c>
}
  801022:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801026:	c9                   	leave
  801027:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801028:	49 89 c0             	mov    %rax,%r8
  80102b:	b9 03 00 00 00       	mov    $0x3,%ecx
  801030:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  801037:	00 00 00 
  80103a:	be 26 00 00 00       	mov    $0x26,%esi
  80103f:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  801046:	00 00 00 
  801049:	b8 00 00 00 00       	mov    $0x0,%eax
  80104e:	49 b9 56 2a 80 00 00 	movabs $0x802a56,%r9
  801055:	00 00 00 
  801058:	41 ff d1             	call   *%r9

000000000080105b <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80105b:	f3 0f 1e fa          	endbr64
  80105f:	55                   	push   %rbp
  801060:	48 89 e5             	mov    %rsp,%rbp
  801063:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801064:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801069:	ba 00 00 00 00       	mov    $0x0,%edx
  80106e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801073:	bb 00 00 00 00       	mov    $0x0,%ebx
  801078:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80107d:	be 00 00 00 00       	mov    $0x0,%esi
  801082:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801088:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80108a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80108e:	c9                   	leave
  80108f:	c3                   	ret

0000000000801090 <sys_yield>:

void
sys_yield(void) {
  801090:	f3 0f 1e fa          	endbr64
  801094:	55                   	push   %rbp
  801095:	48 89 e5             	mov    %rsp,%rbp
  801098:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801099:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80109e:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a3:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ad:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010b2:	be 00 00 00 00       	mov    $0x0,%esi
  8010b7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010bd:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8010bf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010c3:	c9                   	leave
  8010c4:	c3                   	ret

00000000008010c5 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8010c5:	f3 0f 1e fa          	endbr64
  8010c9:	55                   	push   %rbp
  8010ca:	48 89 e5             	mov    %rsp,%rbp
  8010cd:	53                   	push   %rbx
  8010ce:	48 89 fa             	mov    %rdi,%rdx
  8010d1:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8010d4:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010d9:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8010e0:	00 00 00 
  8010e3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010e8:	be 00 00 00 00       	mov    $0x0,%esi
  8010ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010f3:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8010f5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010f9:	c9                   	leave
  8010fa:	c3                   	ret

00000000008010fb <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8010fb:	f3 0f 1e fa          	endbr64
  8010ff:	55                   	push   %rbp
  801100:	48 89 e5             	mov    %rsp,%rbp
  801103:	53                   	push   %rbx
  801104:	49 89 f8             	mov    %rdi,%r8
  801107:	48 89 d3             	mov    %rdx,%rbx
  80110a:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80110d:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801112:	4c 89 c2             	mov    %r8,%rdx
  801115:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801118:	be 00 00 00 00       	mov    $0x0,%esi
  80111d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801123:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801125:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801129:	c9                   	leave
  80112a:	c3                   	ret

000000000080112b <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80112b:	f3 0f 1e fa          	endbr64
  80112f:	55                   	push   %rbp
  801130:	48 89 e5             	mov    %rsp,%rbp
  801133:	53                   	push   %rbx
  801134:	48 83 ec 08          	sub    $0x8,%rsp
  801138:	89 f8                	mov    %edi,%eax
  80113a:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80113d:	48 63 f9             	movslq %ecx,%rdi
  801140:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801143:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801148:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80114b:	be 00 00 00 00       	mov    $0x0,%esi
  801150:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801156:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801158:	48 85 c0             	test   %rax,%rax
  80115b:	7f 06                	jg     801163 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  80115d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801161:	c9                   	leave
  801162:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801163:	49 89 c0             	mov    %rax,%r8
  801166:	b9 04 00 00 00       	mov    $0x4,%ecx
  80116b:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  801172:	00 00 00 
  801175:	be 26 00 00 00       	mov    $0x26,%esi
  80117a:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  801181:	00 00 00 
  801184:	b8 00 00 00 00       	mov    $0x0,%eax
  801189:	49 b9 56 2a 80 00 00 	movabs $0x802a56,%r9
  801190:	00 00 00 
  801193:	41 ff d1             	call   *%r9

0000000000801196 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801196:	f3 0f 1e fa          	endbr64
  80119a:	55                   	push   %rbp
  80119b:	48 89 e5             	mov    %rsp,%rbp
  80119e:	53                   	push   %rbx
  80119f:	48 83 ec 08          	sub    $0x8,%rsp
  8011a3:	89 f8                	mov    %edi,%eax
  8011a5:	49 89 f2             	mov    %rsi,%r10
  8011a8:	48 89 cf             	mov    %rcx,%rdi
  8011ab:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8011ae:	48 63 da             	movslq %edx,%rbx
  8011b1:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011b4:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011b9:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011bc:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8011bf:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011c1:	48 85 c0             	test   %rax,%rax
  8011c4:	7f 06                	jg     8011cc <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8011c6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011ca:	c9                   	leave
  8011cb:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011cc:	49 89 c0             	mov    %rax,%r8
  8011cf:	b9 05 00 00 00       	mov    $0x5,%ecx
  8011d4:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  8011db:	00 00 00 
  8011de:	be 26 00 00 00       	mov    $0x26,%esi
  8011e3:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  8011ea:	00 00 00 
  8011ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f2:	49 b9 56 2a 80 00 00 	movabs $0x802a56,%r9
  8011f9:	00 00 00 
  8011fc:	41 ff d1             	call   *%r9

00000000008011ff <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8011ff:	f3 0f 1e fa          	endbr64
  801203:	55                   	push   %rbp
  801204:	48 89 e5             	mov    %rsp,%rbp
  801207:	53                   	push   %rbx
  801208:	48 83 ec 08          	sub    $0x8,%rsp
  80120c:	49 89 f9             	mov    %rdi,%r9
  80120f:	89 f0                	mov    %esi,%eax
  801211:	48 89 d3             	mov    %rdx,%rbx
  801214:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801217:	49 63 f0             	movslq %r8d,%rsi
  80121a:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80121d:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801222:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801225:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80122b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80122d:	48 85 c0             	test   %rax,%rax
  801230:	7f 06                	jg     801238 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801232:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801236:	c9                   	leave
  801237:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801238:	49 89 c0             	mov    %rax,%r8
  80123b:	b9 06 00 00 00       	mov    $0x6,%ecx
  801240:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  801247:	00 00 00 
  80124a:	be 26 00 00 00       	mov    $0x26,%esi
  80124f:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  801256:	00 00 00 
  801259:	b8 00 00 00 00       	mov    $0x0,%eax
  80125e:	49 b9 56 2a 80 00 00 	movabs $0x802a56,%r9
  801265:	00 00 00 
  801268:	41 ff d1             	call   *%r9

000000000080126b <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80126b:	f3 0f 1e fa          	endbr64
  80126f:	55                   	push   %rbp
  801270:	48 89 e5             	mov    %rsp,%rbp
  801273:	53                   	push   %rbx
  801274:	48 83 ec 08          	sub    $0x8,%rsp
  801278:	48 89 f1             	mov    %rsi,%rcx
  80127b:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80127e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801281:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801286:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80128b:	be 00 00 00 00       	mov    $0x0,%esi
  801290:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801296:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801298:	48 85 c0             	test   %rax,%rax
  80129b:	7f 06                	jg     8012a3 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80129d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012a1:	c9                   	leave
  8012a2:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012a3:	49 89 c0             	mov    %rax,%r8
  8012a6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8012ab:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  8012b2:	00 00 00 
  8012b5:	be 26 00 00 00       	mov    $0x26,%esi
  8012ba:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  8012c1:	00 00 00 
  8012c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c9:	49 b9 56 2a 80 00 00 	movabs $0x802a56,%r9
  8012d0:	00 00 00 
  8012d3:	41 ff d1             	call   *%r9

00000000008012d6 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8012d6:	f3 0f 1e fa          	endbr64
  8012da:	55                   	push   %rbp
  8012db:	48 89 e5             	mov    %rsp,%rbp
  8012de:	53                   	push   %rbx
  8012df:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8012e3:	48 63 ce             	movslq %esi,%rcx
  8012e6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012e9:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012f8:	be 00 00 00 00       	mov    $0x0,%esi
  8012fd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801303:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801305:	48 85 c0             	test   %rax,%rax
  801308:	7f 06                	jg     801310 <sys_env_set_status+0x3a>
}
  80130a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80130e:	c9                   	leave
  80130f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801310:	49 89 c0             	mov    %rax,%r8
  801313:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801318:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  80131f:	00 00 00 
  801322:	be 26 00 00 00       	mov    $0x26,%esi
  801327:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  80132e:	00 00 00 
  801331:	b8 00 00 00 00       	mov    $0x0,%eax
  801336:	49 b9 56 2a 80 00 00 	movabs $0x802a56,%r9
  80133d:	00 00 00 
  801340:	41 ff d1             	call   *%r9

0000000000801343 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801343:	f3 0f 1e fa          	endbr64
  801347:	55                   	push   %rbp
  801348:	48 89 e5             	mov    %rsp,%rbp
  80134b:	53                   	push   %rbx
  80134c:	48 83 ec 08          	sub    $0x8,%rsp
  801350:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801353:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801356:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80135b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801360:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801365:	be 00 00 00 00       	mov    $0x0,%esi
  80136a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801370:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801372:	48 85 c0             	test   %rax,%rax
  801375:	7f 06                	jg     80137d <sys_env_set_trapframe+0x3a>
}
  801377:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80137b:	c9                   	leave
  80137c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80137d:	49 89 c0             	mov    %rax,%r8
  801380:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801385:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  80138c:	00 00 00 
  80138f:	be 26 00 00 00       	mov    $0x26,%esi
  801394:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  80139b:	00 00 00 
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	49 b9 56 2a 80 00 00 	movabs $0x802a56,%r9
  8013aa:	00 00 00 
  8013ad:	41 ff d1             	call   *%r9

00000000008013b0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8013b0:	f3 0f 1e fa          	endbr64
  8013b4:	55                   	push   %rbp
  8013b5:	48 89 e5             	mov    %rsp,%rbp
  8013b8:	53                   	push   %rbx
  8013b9:	48 83 ec 08          	sub    $0x8,%rsp
  8013bd:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8013c0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013c3:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013cd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013d2:	be 00 00 00 00       	mov    $0x0,%esi
  8013d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013dd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013df:	48 85 c0             	test   %rax,%rax
  8013e2:	7f 06                	jg     8013ea <sys_env_set_pgfault_upcall+0x3a>
}
  8013e4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013e8:	c9                   	leave
  8013e9:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013ea:	49 89 c0             	mov    %rax,%r8
  8013ed:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8013f2:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  8013f9:	00 00 00 
  8013fc:	be 26 00 00 00       	mov    $0x26,%esi
  801401:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  801408:	00 00 00 
  80140b:	b8 00 00 00 00       	mov    $0x0,%eax
  801410:	49 b9 56 2a 80 00 00 	movabs $0x802a56,%r9
  801417:	00 00 00 
  80141a:	41 ff d1             	call   *%r9

000000000080141d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80141d:	f3 0f 1e fa          	endbr64
  801421:	55                   	push   %rbp
  801422:	48 89 e5             	mov    %rsp,%rbp
  801425:	53                   	push   %rbx
  801426:	89 f8                	mov    %edi,%eax
  801428:	49 89 f1             	mov    %rsi,%r9
  80142b:	48 89 d3             	mov    %rdx,%rbx
  80142e:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801431:	49 63 f0             	movslq %r8d,%rsi
  801434:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801437:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80143c:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80143f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801445:	cd 30                	int    $0x30
}
  801447:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80144b:	c9                   	leave
  80144c:	c3                   	ret

000000000080144d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80144d:	f3 0f 1e fa          	endbr64
  801451:	55                   	push   %rbp
  801452:	48 89 e5             	mov    %rsp,%rbp
  801455:	53                   	push   %rbx
  801456:	48 83 ec 08          	sub    $0x8,%rsp
  80145a:	48 89 fa             	mov    %rdi,%rdx
  80145d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801460:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801465:	bb 00 00 00 00       	mov    $0x0,%ebx
  80146a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80146f:	be 00 00 00 00       	mov    $0x0,%esi
  801474:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80147a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80147c:	48 85 c0             	test   %rax,%rax
  80147f:	7f 06                	jg     801487 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801481:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801485:	c9                   	leave
  801486:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801487:	49 89 c0             	mov    %rax,%r8
  80148a:	b9 0f 00 00 00       	mov    $0xf,%ecx
  80148f:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  801496:	00 00 00 
  801499:	be 26 00 00 00       	mov    $0x26,%esi
  80149e:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  8014a5:	00 00 00 
  8014a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ad:	49 b9 56 2a 80 00 00 	movabs $0x802a56,%r9
  8014b4:	00 00 00 
  8014b7:	41 ff d1             	call   *%r9

00000000008014ba <sys_gettime>:

int
sys_gettime(void) {
  8014ba:	f3 0f 1e fa          	endbr64
  8014be:	55                   	push   %rbp
  8014bf:	48 89 e5             	mov    %rsp,%rbp
  8014c2:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014c3:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8014cd:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014d7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014dc:	be 00 00 00 00       	mov    $0x0,%esi
  8014e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014e7:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8014e9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014ed:	c9                   	leave
  8014ee:	c3                   	ret

00000000008014ef <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  8014ef:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8014f3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8014fa:	ff ff ff 
  8014fd:	48 01 f8             	add    %rdi,%rax
  801500:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801504:	c3                   	ret

0000000000801505 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801505:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801509:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801510:	ff ff ff 
  801513:	48 01 f8             	add    %rdi,%rax
  801516:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80151a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801520:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801524:	c3                   	ret

0000000000801525 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801525:	f3 0f 1e fa          	endbr64
  801529:	55                   	push   %rbp
  80152a:	48 89 e5             	mov    %rsp,%rbp
  80152d:	41 57                	push   %r15
  80152f:	41 56                	push   %r14
  801531:	41 55                	push   %r13
  801533:	41 54                	push   %r12
  801535:	53                   	push   %rbx
  801536:	48 83 ec 08          	sub    $0x8,%rsp
  80153a:	49 89 ff             	mov    %rdi,%r15
  80153d:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801542:	49 bd 84 26 80 00 00 	movabs $0x802684,%r13
  801549:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80154c:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801552:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801555:	48 89 df             	mov    %rbx,%rdi
  801558:	41 ff d5             	call   *%r13
  80155b:	83 e0 04             	and    $0x4,%eax
  80155e:	74 17                	je     801577 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801560:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801567:	4c 39 f3             	cmp    %r14,%rbx
  80156a:	75 e6                	jne    801552 <fd_alloc+0x2d>
  80156c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801572:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801577:	4d 89 27             	mov    %r12,(%r15)
}
  80157a:	48 83 c4 08          	add    $0x8,%rsp
  80157e:	5b                   	pop    %rbx
  80157f:	41 5c                	pop    %r12
  801581:	41 5d                	pop    %r13
  801583:	41 5e                	pop    %r14
  801585:	41 5f                	pop    %r15
  801587:	5d                   	pop    %rbp
  801588:	c3                   	ret

0000000000801589 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801589:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  80158d:	83 ff 1f             	cmp    $0x1f,%edi
  801590:	77 39                	ja     8015cb <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801592:	55                   	push   %rbp
  801593:	48 89 e5             	mov    %rsp,%rbp
  801596:	41 54                	push   %r12
  801598:	53                   	push   %rbx
  801599:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80159c:	48 63 df             	movslq %edi,%rbx
  80159f:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8015a6:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8015aa:	48 89 df             	mov    %rbx,%rdi
  8015ad:	48 b8 84 26 80 00 00 	movabs $0x802684,%rax
  8015b4:	00 00 00 
  8015b7:	ff d0                	call   *%rax
  8015b9:	a8 04                	test   $0x4,%al
  8015bb:	74 14                	je     8015d1 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8015bd:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c6:	5b                   	pop    %rbx
  8015c7:	41 5c                	pop    %r12
  8015c9:	5d                   	pop    %rbp
  8015ca:	c3                   	ret
        return -E_INVAL;
  8015cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015d0:	c3                   	ret
        return -E_INVAL;
  8015d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d6:	eb ee                	jmp    8015c6 <fd_lookup+0x3d>

00000000008015d8 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8015d8:	f3 0f 1e fa          	endbr64
  8015dc:	55                   	push   %rbp
  8015dd:	48 89 e5             	mov    %rsp,%rbp
  8015e0:	41 54                	push   %r12
  8015e2:	53                   	push   %rbx
  8015e3:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  8015e6:	48 b8 a0 36 80 00 00 	movabs $0x8036a0,%rax
  8015ed:	00 00 00 
  8015f0:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  8015f7:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8015fa:	39 3b                	cmp    %edi,(%rbx)
  8015fc:	74 47                	je     801645 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  8015fe:	48 83 c0 08          	add    $0x8,%rax
  801602:	48 8b 18             	mov    (%rax),%rbx
  801605:	48 85 db             	test   %rbx,%rbx
  801608:	75 f0                	jne    8015fa <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80160a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801611:	00 00 00 
  801614:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80161a:	89 fa                	mov    %edi,%edx
  80161c:	48 bf 00 36 80 00 00 	movabs $0x803600,%rdi
  801623:	00 00 00 
  801626:	b8 00 00 00 00       	mov    $0x0,%eax
  80162b:	48 b9 dd 01 80 00 00 	movabs $0x8001dd,%rcx
  801632:	00 00 00 
  801635:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801637:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  80163c:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801640:	5b                   	pop    %rbx
  801641:	41 5c                	pop    %r12
  801643:	5d                   	pop    %rbp
  801644:	c3                   	ret
            return 0;
  801645:	b8 00 00 00 00       	mov    $0x0,%eax
  80164a:	eb f0                	jmp    80163c <dev_lookup+0x64>

000000000080164c <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80164c:	f3 0f 1e fa          	endbr64
  801650:	55                   	push   %rbp
  801651:	48 89 e5             	mov    %rsp,%rbp
  801654:	41 55                	push   %r13
  801656:	41 54                	push   %r12
  801658:	53                   	push   %rbx
  801659:	48 83 ec 18          	sub    $0x18,%rsp
  80165d:	48 89 fb             	mov    %rdi,%rbx
  801660:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801663:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80166a:	ff ff ff 
  80166d:	48 01 df             	add    %rbx,%rdi
  801670:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801674:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801678:	48 b8 89 15 80 00 00 	movabs $0x801589,%rax
  80167f:	00 00 00 
  801682:	ff d0                	call   *%rax
  801684:	41 89 c5             	mov    %eax,%r13d
  801687:	85 c0                	test   %eax,%eax
  801689:	78 06                	js     801691 <fd_close+0x45>
  80168b:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  80168f:	74 1a                	je     8016ab <fd_close+0x5f>
        return (must_exist ? res : 0);
  801691:	45 84 e4             	test   %r12b,%r12b
  801694:	b8 00 00 00 00       	mov    $0x0,%eax
  801699:	44 0f 44 e8          	cmove  %eax,%r13d
}
  80169d:	44 89 e8             	mov    %r13d,%eax
  8016a0:	48 83 c4 18          	add    $0x18,%rsp
  8016a4:	5b                   	pop    %rbx
  8016a5:	41 5c                	pop    %r12
  8016a7:	41 5d                	pop    %r13
  8016a9:	5d                   	pop    %rbp
  8016aa:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016ab:	8b 3b                	mov    (%rbx),%edi
  8016ad:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8016b1:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  8016b8:	00 00 00 
  8016bb:	ff d0                	call   *%rax
  8016bd:	41 89 c5             	mov    %eax,%r13d
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	78 1b                	js     8016df <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8016c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8016cc:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8016d2:	48 85 c0             	test   %rax,%rax
  8016d5:	74 08                	je     8016df <fd_close+0x93>
  8016d7:	48 89 df             	mov    %rbx,%rdi
  8016da:	ff d0                	call   *%rax
  8016dc:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8016df:	ba 00 10 00 00       	mov    $0x1000,%edx
  8016e4:	48 89 de             	mov    %rbx,%rsi
  8016e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8016ec:	48 b8 6b 12 80 00 00 	movabs $0x80126b,%rax
  8016f3:	00 00 00 
  8016f6:	ff d0                	call   *%rax
    return res;
  8016f8:	eb a3                	jmp    80169d <fd_close+0x51>

00000000008016fa <close>:

int
close(int fdnum) {
  8016fa:	f3 0f 1e fa          	endbr64
  8016fe:	55                   	push   %rbp
  8016ff:	48 89 e5             	mov    %rsp,%rbp
  801702:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801706:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80170a:	48 b8 89 15 80 00 00 	movabs $0x801589,%rax
  801711:	00 00 00 
  801714:	ff d0                	call   *%rax
    if (res < 0) return res;
  801716:	85 c0                	test   %eax,%eax
  801718:	78 15                	js     80172f <close+0x35>

    return fd_close(fd, 1);
  80171a:	be 01 00 00 00       	mov    $0x1,%esi
  80171f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801723:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  80172a:	00 00 00 
  80172d:	ff d0                	call   *%rax
}
  80172f:	c9                   	leave
  801730:	c3                   	ret

0000000000801731 <close_all>:

void
close_all(void) {
  801731:	f3 0f 1e fa          	endbr64
  801735:	55                   	push   %rbp
  801736:	48 89 e5             	mov    %rsp,%rbp
  801739:	41 54                	push   %r12
  80173b:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80173c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801741:	49 bc fa 16 80 00 00 	movabs $0x8016fa,%r12
  801748:	00 00 00 
  80174b:	89 df                	mov    %ebx,%edi
  80174d:	41 ff d4             	call   *%r12
  801750:	83 c3 01             	add    $0x1,%ebx
  801753:	83 fb 20             	cmp    $0x20,%ebx
  801756:	75 f3                	jne    80174b <close_all+0x1a>
}
  801758:	5b                   	pop    %rbx
  801759:	41 5c                	pop    %r12
  80175b:	5d                   	pop    %rbp
  80175c:	c3                   	ret

000000000080175d <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80175d:	f3 0f 1e fa          	endbr64
  801761:	55                   	push   %rbp
  801762:	48 89 e5             	mov    %rsp,%rbp
  801765:	41 57                	push   %r15
  801767:	41 56                	push   %r14
  801769:	41 55                	push   %r13
  80176b:	41 54                	push   %r12
  80176d:	53                   	push   %rbx
  80176e:	48 83 ec 18          	sub    $0x18,%rsp
  801772:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801775:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801779:	48 b8 89 15 80 00 00 	movabs $0x801589,%rax
  801780:	00 00 00 
  801783:	ff d0                	call   *%rax
  801785:	89 c3                	mov    %eax,%ebx
  801787:	85 c0                	test   %eax,%eax
  801789:	0f 88 b8 00 00 00    	js     801847 <dup+0xea>
    close(newfdnum);
  80178f:	44 89 e7             	mov    %r12d,%edi
  801792:	48 b8 fa 16 80 00 00 	movabs $0x8016fa,%rax
  801799:	00 00 00 
  80179c:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  80179e:	4d 63 ec             	movslq %r12d,%r13
  8017a1:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8017a8:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8017ac:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8017b0:	4c 89 ff             	mov    %r15,%rdi
  8017b3:	49 be 05 15 80 00 00 	movabs $0x801505,%r14
  8017ba:	00 00 00 
  8017bd:	41 ff d6             	call   *%r14
  8017c0:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8017c3:	4c 89 ef             	mov    %r13,%rdi
  8017c6:	41 ff d6             	call   *%r14
  8017c9:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8017cc:	48 89 df             	mov    %rbx,%rdi
  8017cf:	48 b8 84 26 80 00 00 	movabs $0x802684,%rax
  8017d6:	00 00 00 
  8017d9:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8017db:	a8 04                	test   $0x4,%al
  8017dd:	74 2b                	je     80180a <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8017df:	41 89 c1             	mov    %eax,%r9d
  8017e2:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8017e8:	4c 89 f1             	mov    %r14,%rcx
  8017eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f0:	48 89 de             	mov    %rbx,%rsi
  8017f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8017f8:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  8017ff:	00 00 00 
  801802:	ff d0                	call   *%rax
  801804:	89 c3                	mov    %eax,%ebx
  801806:	85 c0                	test   %eax,%eax
  801808:	78 4e                	js     801858 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  80180a:	4c 89 ff             	mov    %r15,%rdi
  80180d:	48 b8 84 26 80 00 00 	movabs $0x802684,%rax
  801814:	00 00 00 
  801817:	ff d0                	call   *%rax
  801819:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  80181c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801822:	4c 89 e9             	mov    %r13,%rcx
  801825:	ba 00 00 00 00       	mov    $0x0,%edx
  80182a:	4c 89 fe             	mov    %r15,%rsi
  80182d:	bf 00 00 00 00       	mov    $0x0,%edi
  801832:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  801839:	00 00 00 
  80183c:	ff d0                	call   *%rax
  80183e:	89 c3                	mov    %eax,%ebx
  801840:	85 c0                	test   %eax,%eax
  801842:	78 14                	js     801858 <dup+0xfb>

    return newfdnum;
  801844:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801847:	89 d8                	mov    %ebx,%eax
  801849:	48 83 c4 18          	add    $0x18,%rsp
  80184d:	5b                   	pop    %rbx
  80184e:	41 5c                	pop    %r12
  801850:	41 5d                	pop    %r13
  801852:	41 5e                	pop    %r14
  801854:	41 5f                	pop    %r15
  801856:	5d                   	pop    %rbp
  801857:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801858:	ba 00 10 00 00       	mov    $0x1000,%edx
  80185d:	4c 89 ee             	mov    %r13,%rsi
  801860:	bf 00 00 00 00       	mov    $0x0,%edi
  801865:	49 bc 6b 12 80 00 00 	movabs $0x80126b,%r12
  80186c:	00 00 00 
  80186f:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801872:	ba 00 10 00 00       	mov    $0x1000,%edx
  801877:	4c 89 f6             	mov    %r14,%rsi
  80187a:	bf 00 00 00 00       	mov    $0x0,%edi
  80187f:	41 ff d4             	call   *%r12
    return res;
  801882:	eb c3                	jmp    801847 <dup+0xea>

0000000000801884 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801884:	f3 0f 1e fa          	endbr64
  801888:	55                   	push   %rbp
  801889:	48 89 e5             	mov    %rsp,%rbp
  80188c:	41 56                	push   %r14
  80188e:	41 55                	push   %r13
  801890:	41 54                	push   %r12
  801892:	53                   	push   %rbx
  801893:	48 83 ec 10          	sub    $0x10,%rsp
  801897:	89 fb                	mov    %edi,%ebx
  801899:	49 89 f4             	mov    %rsi,%r12
  80189c:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80189f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018a3:	48 b8 89 15 80 00 00 	movabs $0x801589,%rax
  8018aa:	00 00 00 
  8018ad:	ff d0                	call   *%rax
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	78 4c                	js     8018ff <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8018b3:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8018b7:	41 8b 3e             	mov    (%r14),%edi
  8018ba:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018be:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  8018c5:	00 00 00 
  8018c8:	ff d0                	call   *%rax
  8018ca:	85 c0                	test   %eax,%eax
  8018cc:	78 35                	js     801903 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018ce:	41 8b 46 08          	mov    0x8(%r14),%eax
  8018d2:	83 e0 03             	and    $0x3,%eax
  8018d5:	83 f8 01             	cmp    $0x1,%eax
  8018d8:	74 2d                	je     801907 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8018da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018de:	48 8b 40 10          	mov    0x10(%rax),%rax
  8018e2:	48 85 c0             	test   %rax,%rax
  8018e5:	74 56                	je     80193d <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  8018e7:	4c 89 ea             	mov    %r13,%rdx
  8018ea:	4c 89 e6             	mov    %r12,%rsi
  8018ed:	4c 89 f7             	mov    %r14,%rdi
  8018f0:	ff d0                	call   *%rax
}
  8018f2:	48 83 c4 10          	add    $0x10,%rsp
  8018f6:	5b                   	pop    %rbx
  8018f7:	41 5c                	pop    %r12
  8018f9:	41 5d                	pop    %r13
  8018fb:	41 5e                	pop    %r14
  8018fd:	5d                   	pop    %rbp
  8018fe:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8018ff:	48 98                	cltq
  801901:	eb ef                	jmp    8018f2 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801903:	48 98                	cltq
  801905:	eb eb                	jmp    8018f2 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801907:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80190e:	00 00 00 
  801911:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801917:	89 da                	mov    %ebx,%edx
  801919:	48 bf ab 31 80 00 00 	movabs $0x8031ab,%rdi
  801920:	00 00 00 
  801923:	b8 00 00 00 00       	mov    $0x0,%eax
  801928:	48 b9 dd 01 80 00 00 	movabs $0x8001dd,%rcx
  80192f:	00 00 00 
  801932:	ff d1                	call   *%rcx
        return -E_INVAL;
  801934:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80193b:	eb b5                	jmp    8018f2 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  80193d:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801944:	eb ac                	jmp    8018f2 <read+0x6e>

0000000000801946 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801946:	f3 0f 1e fa          	endbr64
  80194a:	55                   	push   %rbp
  80194b:	48 89 e5             	mov    %rsp,%rbp
  80194e:	41 57                	push   %r15
  801950:	41 56                	push   %r14
  801952:	41 55                	push   %r13
  801954:	41 54                	push   %r12
  801956:	53                   	push   %rbx
  801957:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  80195b:	48 85 d2             	test   %rdx,%rdx
  80195e:	74 54                	je     8019b4 <readn+0x6e>
  801960:	41 89 fd             	mov    %edi,%r13d
  801963:	49 89 f6             	mov    %rsi,%r14
  801966:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801969:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  80196e:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801973:	49 bf 84 18 80 00 00 	movabs $0x801884,%r15
  80197a:	00 00 00 
  80197d:	4c 89 e2             	mov    %r12,%rdx
  801980:	48 29 f2             	sub    %rsi,%rdx
  801983:	4c 01 f6             	add    %r14,%rsi
  801986:	44 89 ef             	mov    %r13d,%edi
  801989:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  80198c:	85 c0                	test   %eax,%eax
  80198e:	78 20                	js     8019b0 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801990:	01 c3                	add    %eax,%ebx
  801992:	85 c0                	test   %eax,%eax
  801994:	74 08                	je     80199e <readn+0x58>
  801996:	48 63 f3             	movslq %ebx,%rsi
  801999:	4c 39 e6             	cmp    %r12,%rsi
  80199c:	72 df                	jb     80197d <readn+0x37>
    }
    return res;
  80199e:	48 63 c3             	movslq %ebx,%rax
}
  8019a1:	48 83 c4 08          	add    $0x8,%rsp
  8019a5:	5b                   	pop    %rbx
  8019a6:	41 5c                	pop    %r12
  8019a8:	41 5d                	pop    %r13
  8019aa:	41 5e                	pop    %r14
  8019ac:	41 5f                	pop    %r15
  8019ae:	5d                   	pop    %rbp
  8019af:	c3                   	ret
        if (inc < 0) return inc;
  8019b0:	48 98                	cltq
  8019b2:	eb ed                	jmp    8019a1 <readn+0x5b>
    int inc = 1, res = 0;
  8019b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019b9:	eb e3                	jmp    80199e <readn+0x58>

00000000008019bb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8019bb:	f3 0f 1e fa          	endbr64
  8019bf:	55                   	push   %rbp
  8019c0:	48 89 e5             	mov    %rsp,%rbp
  8019c3:	41 56                	push   %r14
  8019c5:	41 55                	push   %r13
  8019c7:	41 54                	push   %r12
  8019c9:	53                   	push   %rbx
  8019ca:	48 83 ec 10          	sub    $0x10,%rsp
  8019ce:	89 fb                	mov    %edi,%ebx
  8019d0:	49 89 f4             	mov    %rsi,%r12
  8019d3:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019d6:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019da:	48 b8 89 15 80 00 00 	movabs $0x801589,%rax
  8019e1:	00 00 00 
  8019e4:	ff d0                	call   *%rax
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	78 47                	js     801a31 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019ea:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8019ee:	41 8b 3e             	mov    (%r14),%edi
  8019f1:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8019f5:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  8019fc:	00 00 00 
  8019ff:	ff d0                	call   *%rax
  801a01:	85 c0                	test   %eax,%eax
  801a03:	78 30                	js     801a35 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a05:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801a0a:	74 2d                	je     801a39 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801a0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a10:	48 8b 40 18          	mov    0x18(%rax),%rax
  801a14:	48 85 c0             	test   %rax,%rax
  801a17:	74 56                	je     801a6f <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801a19:	4c 89 ea             	mov    %r13,%rdx
  801a1c:	4c 89 e6             	mov    %r12,%rsi
  801a1f:	4c 89 f7             	mov    %r14,%rdi
  801a22:	ff d0                	call   *%rax
}
  801a24:	48 83 c4 10          	add    $0x10,%rsp
  801a28:	5b                   	pop    %rbx
  801a29:	41 5c                	pop    %r12
  801a2b:	41 5d                	pop    %r13
  801a2d:	41 5e                	pop    %r14
  801a2f:	5d                   	pop    %rbp
  801a30:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a31:	48 98                	cltq
  801a33:	eb ef                	jmp    801a24 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a35:	48 98                	cltq
  801a37:	eb eb                	jmp    801a24 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a39:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a40:	00 00 00 
  801a43:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a49:	89 da                	mov    %ebx,%edx
  801a4b:	48 bf c7 31 80 00 00 	movabs $0x8031c7,%rdi
  801a52:	00 00 00 
  801a55:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5a:	48 b9 dd 01 80 00 00 	movabs $0x8001dd,%rcx
  801a61:	00 00 00 
  801a64:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a66:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801a6d:	eb b5                	jmp    801a24 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801a6f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a76:	eb ac                	jmp    801a24 <write+0x69>

0000000000801a78 <seek>:

int
seek(int fdnum, off_t offset) {
  801a78:	f3 0f 1e fa          	endbr64
  801a7c:	55                   	push   %rbp
  801a7d:	48 89 e5             	mov    %rsp,%rbp
  801a80:	53                   	push   %rbx
  801a81:	48 83 ec 18          	sub    $0x18,%rsp
  801a85:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a87:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801a8b:	48 b8 89 15 80 00 00 	movabs $0x801589,%rax
  801a92:	00 00 00 
  801a95:	ff d0                	call   *%rax
  801a97:	85 c0                	test   %eax,%eax
  801a99:	78 0c                	js     801aa7 <seek+0x2f>

    fd->fd_offset = offset;
  801a9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a9f:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801aa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801aab:	c9                   	leave
  801aac:	c3                   	ret

0000000000801aad <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801aad:	f3 0f 1e fa          	endbr64
  801ab1:	55                   	push   %rbp
  801ab2:	48 89 e5             	mov    %rsp,%rbp
  801ab5:	41 55                	push   %r13
  801ab7:	41 54                	push   %r12
  801ab9:	53                   	push   %rbx
  801aba:	48 83 ec 18          	sub    $0x18,%rsp
  801abe:	89 fb                	mov    %edi,%ebx
  801ac0:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ac3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ac7:	48 b8 89 15 80 00 00 	movabs $0x801589,%rax
  801ace:	00 00 00 
  801ad1:	ff d0                	call   *%rax
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	78 38                	js     801b0f <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ad7:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801adb:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801adf:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ae3:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  801aea:	00 00 00 
  801aed:	ff d0                	call   *%rax
  801aef:	85 c0                	test   %eax,%eax
  801af1:	78 1c                	js     801b0f <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801af3:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801af8:	74 20                	je     801b1a <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801afa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801afe:	48 8b 40 30          	mov    0x30(%rax),%rax
  801b02:	48 85 c0             	test   %rax,%rax
  801b05:	74 47                	je     801b4e <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801b07:	44 89 e6             	mov    %r12d,%esi
  801b0a:	4c 89 ef             	mov    %r13,%rdi
  801b0d:	ff d0                	call   *%rax
}
  801b0f:	48 83 c4 18          	add    $0x18,%rsp
  801b13:	5b                   	pop    %rbx
  801b14:	41 5c                	pop    %r12
  801b16:	41 5d                	pop    %r13
  801b18:	5d                   	pop    %rbp
  801b19:	c3                   	ret
                thisenv->env_id, fdnum);
  801b1a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b21:	00 00 00 
  801b24:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b2a:	89 da                	mov    %ebx,%edx
  801b2c:	48 bf 20 36 80 00 00 	movabs $0x803620,%rdi
  801b33:	00 00 00 
  801b36:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3b:	48 b9 dd 01 80 00 00 	movabs $0x8001dd,%rcx
  801b42:	00 00 00 
  801b45:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b4c:	eb c1                	jmp    801b0f <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801b4e:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801b53:	eb ba                	jmp    801b0f <ftruncate+0x62>

0000000000801b55 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801b55:	f3 0f 1e fa          	endbr64
  801b59:	55                   	push   %rbp
  801b5a:	48 89 e5             	mov    %rsp,%rbp
  801b5d:	41 54                	push   %r12
  801b5f:	53                   	push   %rbx
  801b60:	48 83 ec 10          	sub    $0x10,%rsp
  801b64:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b67:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801b6b:	48 b8 89 15 80 00 00 	movabs $0x801589,%rax
  801b72:	00 00 00 
  801b75:	ff d0                	call   *%rax
  801b77:	85 c0                	test   %eax,%eax
  801b79:	78 4e                	js     801bc9 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b7b:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801b7f:	41 8b 3c 24          	mov    (%r12),%edi
  801b83:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801b87:	48 b8 d8 15 80 00 00 	movabs $0x8015d8,%rax
  801b8e:	00 00 00 
  801b91:	ff d0                	call   *%rax
  801b93:	85 c0                	test   %eax,%eax
  801b95:	78 32                	js     801bc9 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801b97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b9b:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801ba0:	74 30                	je     801bd2 <fstat+0x7d>

    stat->st_name[0] = 0;
  801ba2:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801ba5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801bac:	00 00 00 
    stat->st_isdir = 0;
  801baf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801bb6:	00 00 00 
    stat->st_dev = dev;
  801bb9:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801bc0:	48 89 de             	mov    %rbx,%rsi
  801bc3:	4c 89 e7             	mov    %r12,%rdi
  801bc6:	ff 50 28             	call   *0x28(%rax)
}
  801bc9:	48 83 c4 10          	add    $0x10,%rsp
  801bcd:	5b                   	pop    %rbx
  801bce:	41 5c                	pop    %r12
  801bd0:	5d                   	pop    %rbp
  801bd1:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801bd2:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801bd7:	eb f0                	jmp    801bc9 <fstat+0x74>

0000000000801bd9 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801bd9:	f3 0f 1e fa          	endbr64
  801bdd:	55                   	push   %rbp
  801bde:	48 89 e5             	mov    %rsp,%rbp
  801be1:	41 54                	push   %r12
  801be3:	53                   	push   %rbx
  801be4:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801be7:	be 00 00 00 00       	mov    $0x0,%esi
  801bec:	48 b8 ba 1e 80 00 00 	movabs $0x801eba,%rax
  801bf3:	00 00 00 
  801bf6:	ff d0                	call   *%rax
  801bf8:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	78 25                	js     801c23 <stat+0x4a>

    int res = fstat(fd, stat);
  801bfe:	4c 89 e6             	mov    %r12,%rsi
  801c01:	89 c7                	mov    %eax,%edi
  801c03:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  801c0a:	00 00 00 
  801c0d:	ff d0                	call   *%rax
  801c0f:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801c12:	89 df                	mov    %ebx,%edi
  801c14:	48 b8 fa 16 80 00 00 	movabs $0x8016fa,%rax
  801c1b:	00 00 00 
  801c1e:	ff d0                	call   *%rax

    return res;
  801c20:	44 89 e3             	mov    %r12d,%ebx
}
  801c23:	89 d8                	mov    %ebx,%eax
  801c25:	5b                   	pop    %rbx
  801c26:	41 5c                	pop    %r12
  801c28:	5d                   	pop    %rbp
  801c29:	c3                   	ret

0000000000801c2a <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801c2a:	f3 0f 1e fa          	endbr64
  801c2e:	55                   	push   %rbp
  801c2f:	48 89 e5             	mov    %rsp,%rbp
  801c32:	41 54                	push   %r12
  801c34:	53                   	push   %rbx
  801c35:	48 83 ec 10          	sub    $0x10,%rsp
  801c39:	41 89 fc             	mov    %edi,%r12d
  801c3c:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801c3f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c46:	00 00 00 
  801c49:	83 38 00             	cmpl   $0x0,(%rax)
  801c4c:	74 6e                	je     801cbc <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801c4e:	bf 03 00 00 00       	mov    $0x3,%edi
  801c53:	48 b8 58 2c 80 00 00 	movabs $0x802c58,%rax
  801c5a:	00 00 00 
  801c5d:	ff d0                	call   *%rax
  801c5f:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801c66:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801c68:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801c6e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c73:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801c7a:	00 00 00 
  801c7d:	44 89 e6             	mov    %r12d,%esi
  801c80:	89 c7                	mov    %eax,%edi
  801c82:	48 b8 96 2b 80 00 00 	movabs $0x802b96,%rax
  801c89:	00 00 00 
  801c8c:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801c8e:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801c95:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801c96:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c9b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801c9f:	48 89 de             	mov    %rbx,%rsi
  801ca2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ca7:	48 b8 fd 2a 80 00 00 	movabs $0x802afd,%rax
  801cae:	00 00 00 
  801cb1:	ff d0                	call   *%rax
}
  801cb3:	48 83 c4 10          	add    $0x10,%rsp
  801cb7:	5b                   	pop    %rbx
  801cb8:	41 5c                	pop    %r12
  801cba:	5d                   	pop    %rbp
  801cbb:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801cbc:	bf 03 00 00 00       	mov    $0x3,%edi
  801cc1:	48 b8 58 2c 80 00 00 	movabs $0x802c58,%rax
  801cc8:	00 00 00 
  801ccb:	ff d0                	call   *%rax
  801ccd:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801cd4:	00 00 
  801cd6:	e9 73 ff ff ff       	jmp    801c4e <fsipc+0x24>

0000000000801cdb <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801cdb:	f3 0f 1e fa          	endbr64
  801cdf:	55                   	push   %rbp
  801ce0:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ce3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801cea:	00 00 00 
  801ced:	8b 57 0c             	mov    0xc(%rdi),%edx
  801cf0:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801cf2:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801cf5:	be 00 00 00 00       	mov    $0x0,%esi
  801cfa:	bf 02 00 00 00       	mov    $0x2,%edi
  801cff:	48 b8 2a 1c 80 00 00 	movabs $0x801c2a,%rax
  801d06:	00 00 00 
  801d09:	ff d0                	call   *%rax
}
  801d0b:	5d                   	pop    %rbp
  801d0c:	c3                   	ret

0000000000801d0d <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801d0d:	f3 0f 1e fa          	endbr64
  801d11:	55                   	push   %rbp
  801d12:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d15:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d18:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d1f:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801d21:	be 00 00 00 00       	mov    $0x0,%esi
  801d26:	bf 06 00 00 00       	mov    $0x6,%edi
  801d2b:	48 b8 2a 1c 80 00 00 	movabs $0x801c2a,%rax
  801d32:	00 00 00 
  801d35:	ff d0                	call   *%rax
}
  801d37:	5d                   	pop    %rbp
  801d38:	c3                   	ret

0000000000801d39 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801d39:	f3 0f 1e fa          	endbr64
  801d3d:	55                   	push   %rbp
  801d3e:	48 89 e5             	mov    %rsp,%rbp
  801d41:	41 54                	push   %r12
  801d43:	53                   	push   %rbx
  801d44:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d47:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d4a:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d51:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801d53:	be 00 00 00 00       	mov    $0x0,%esi
  801d58:	bf 05 00 00 00       	mov    $0x5,%edi
  801d5d:	48 b8 2a 1c 80 00 00 	movabs $0x801c2a,%rax
  801d64:	00 00 00 
  801d67:	ff d0                	call   *%rax
    if (res < 0) return res;
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	78 3d                	js     801daa <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d6d:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  801d74:	00 00 00 
  801d77:	4c 89 e6             	mov    %r12,%rsi
  801d7a:	48 89 df             	mov    %rbx,%rdi
  801d7d:	48 b8 26 0b 80 00 00 	movabs $0x800b26,%rax
  801d84:	00 00 00 
  801d87:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801d89:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801d90:	00 
  801d91:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d97:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801d9e:	00 
  801d9f:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801da5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801daa:	5b                   	pop    %rbx
  801dab:	41 5c                	pop    %r12
  801dad:	5d                   	pop    %rbp
  801dae:	c3                   	ret

0000000000801daf <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801daf:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801db3:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801dba:	77 41                	ja     801dfd <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801dbc:	55                   	push   %rbp
  801dbd:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801dc0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801dc7:	00 00 00 
  801dca:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801dcd:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  801dcf:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801dd3:	48 8d 78 10          	lea    0x10(%rax),%rdi
  801dd7:	48 b8 41 0d 80 00 00 	movabs $0x800d41,%rax
  801dde:	00 00 00 
  801de1:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  801de3:	be 00 00 00 00       	mov    $0x0,%esi
  801de8:	bf 04 00 00 00       	mov    $0x4,%edi
  801ded:	48 b8 2a 1c 80 00 00 	movabs $0x801c2a,%rax
  801df4:	00 00 00 
  801df7:	ff d0                	call   *%rax
  801df9:	48 98                	cltq
}
  801dfb:	5d                   	pop    %rbp
  801dfc:	c3                   	ret
        return -E_INVAL;
  801dfd:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  801e04:	c3                   	ret

0000000000801e05 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801e05:	f3 0f 1e fa          	endbr64
  801e09:	55                   	push   %rbp
  801e0a:	48 89 e5             	mov    %rsp,%rbp
  801e0d:	41 55                	push   %r13
  801e0f:	41 54                	push   %r12
  801e11:	53                   	push   %rbx
  801e12:	48 83 ec 08          	sub    $0x8,%rsp
  801e16:	49 89 f4             	mov    %rsi,%r12
  801e19:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e1c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e23:	00 00 00 
  801e26:	8b 57 0c             	mov    0xc(%rdi),%edx
  801e29:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  801e2b:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  801e2f:	be 00 00 00 00       	mov    $0x0,%esi
  801e34:	bf 03 00 00 00       	mov    $0x3,%edi
  801e39:	48 b8 2a 1c 80 00 00 	movabs $0x801c2a,%rax
  801e40:	00 00 00 
  801e43:	ff d0                	call   *%rax
  801e45:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  801e48:	4d 85 ed             	test   %r13,%r13
  801e4b:	78 2a                	js     801e77 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  801e4d:	4c 89 ea             	mov    %r13,%rdx
  801e50:	4c 39 eb             	cmp    %r13,%rbx
  801e53:	72 30                	jb     801e85 <devfile_read+0x80>
  801e55:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  801e5c:	7f 27                	jg     801e85 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  801e5e:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801e65:	00 00 00 
  801e68:	4c 89 e7             	mov    %r12,%rdi
  801e6b:	48 b8 41 0d 80 00 00 	movabs $0x800d41,%rax
  801e72:	00 00 00 
  801e75:	ff d0                	call   *%rax
}
  801e77:	4c 89 e8             	mov    %r13,%rax
  801e7a:	48 83 c4 08          	add    $0x8,%rsp
  801e7e:	5b                   	pop    %rbx
  801e7f:	41 5c                	pop    %r12
  801e81:	41 5d                	pop    %r13
  801e83:	5d                   	pop    %rbp
  801e84:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801e85:	48 b9 e4 31 80 00 00 	movabs $0x8031e4,%rcx
  801e8c:	00 00 00 
  801e8f:	48 ba 01 32 80 00 00 	movabs $0x803201,%rdx
  801e96:	00 00 00 
  801e99:	be 7b 00 00 00       	mov    $0x7b,%esi
  801e9e:	48 bf 16 32 80 00 00 	movabs $0x803216,%rdi
  801ea5:	00 00 00 
  801ea8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ead:	49 b8 56 2a 80 00 00 	movabs $0x802a56,%r8
  801eb4:	00 00 00 
  801eb7:	41 ff d0             	call   *%r8

0000000000801eba <open>:
open(const char *path, int mode) {
  801eba:	f3 0f 1e fa          	endbr64
  801ebe:	55                   	push   %rbp
  801ebf:	48 89 e5             	mov    %rsp,%rbp
  801ec2:	41 55                	push   %r13
  801ec4:	41 54                	push   %r12
  801ec6:	53                   	push   %rbx
  801ec7:	48 83 ec 18          	sub    $0x18,%rsp
  801ecb:	49 89 fc             	mov    %rdi,%r12
  801ece:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801ed1:	48 b8 e1 0a 80 00 00 	movabs $0x800ae1,%rax
  801ed8:	00 00 00 
  801edb:	ff d0                	call   *%rax
  801edd:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801ee3:	0f 87 8a 00 00 00    	ja     801f73 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801ee9:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801eed:	48 b8 25 15 80 00 00 	movabs $0x801525,%rax
  801ef4:	00 00 00 
  801ef7:	ff d0                	call   *%rax
  801ef9:	89 c3                	mov    %eax,%ebx
  801efb:	85 c0                	test   %eax,%eax
  801efd:	78 50                	js     801f4f <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  801eff:	4c 89 e6             	mov    %r12,%rsi
  801f02:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801f09:	00 00 00 
  801f0c:	48 89 df             	mov    %rbx,%rdi
  801f0f:	48 b8 26 0b 80 00 00 	movabs $0x800b26,%rax
  801f16:	00 00 00 
  801f19:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801f1b:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f22:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801f26:	bf 01 00 00 00       	mov    $0x1,%edi
  801f2b:	48 b8 2a 1c 80 00 00 	movabs $0x801c2a,%rax
  801f32:	00 00 00 
  801f35:	ff d0                	call   *%rax
  801f37:	89 c3                	mov    %eax,%ebx
  801f39:	85 c0                	test   %eax,%eax
  801f3b:	78 1f                	js     801f5c <open+0xa2>
    return fd2num(fd);
  801f3d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f41:	48 b8 ef 14 80 00 00 	movabs $0x8014ef,%rax
  801f48:	00 00 00 
  801f4b:	ff d0                	call   *%rax
  801f4d:	89 c3                	mov    %eax,%ebx
}
  801f4f:	89 d8                	mov    %ebx,%eax
  801f51:	48 83 c4 18          	add    $0x18,%rsp
  801f55:	5b                   	pop    %rbx
  801f56:	41 5c                	pop    %r12
  801f58:	41 5d                	pop    %r13
  801f5a:	5d                   	pop    %rbp
  801f5b:	c3                   	ret
        fd_close(fd, 0);
  801f5c:	be 00 00 00 00       	mov    $0x0,%esi
  801f61:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f65:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  801f6c:	00 00 00 
  801f6f:	ff d0                	call   *%rax
        return res;
  801f71:	eb dc                	jmp    801f4f <open+0x95>
        return -E_BAD_PATH;
  801f73:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801f78:	eb d5                	jmp    801f4f <open+0x95>

0000000000801f7a <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801f7a:	f3 0f 1e fa          	endbr64
  801f7e:	55                   	push   %rbp
  801f7f:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801f82:	be 00 00 00 00       	mov    $0x0,%esi
  801f87:	bf 08 00 00 00       	mov    $0x8,%edi
  801f8c:	48 b8 2a 1c 80 00 00 	movabs $0x801c2a,%rax
  801f93:	00 00 00 
  801f96:	ff d0                	call   *%rax
}
  801f98:	5d                   	pop    %rbp
  801f99:	c3                   	ret

0000000000801f9a <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801f9a:	f3 0f 1e fa          	endbr64
  801f9e:	55                   	push   %rbp
  801f9f:	48 89 e5             	mov    %rsp,%rbp
  801fa2:	41 54                	push   %r12
  801fa4:	53                   	push   %rbx
  801fa5:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801fa8:	48 b8 05 15 80 00 00 	movabs $0x801505,%rax
  801faf:	00 00 00 
  801fb2:	ff d0                	call   *%rax
  801fb4:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801fb7:	48 be 21 32 80 00 00 	movabs $0x803221,%rsi
  801fbe:	00 00 00 
  801fc1:	48 89 df             	mov    %rbx,%rdi
  801fc4:	48 b8 26 0b 80 00 00 	movabs $0x800b26,%rax
  801fcb:	00 00 00 
  801fce:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801fd0:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801fd5:	41 2b 04 24          	sub    (%r12),%eax
  801fd9:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801fdf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801fe6:	00 00 00 
    stat->st_dev = &devpipe;
  801fe9:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801ff0:	00 00 00 
  801ff3:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801ffa:	b8 00 00 00 00       	mov    $0x0,%eax
  801fff:	5b                   	pop    %rbx
  802000:	41 5c                	pop    %r12
  802002:	5d                   	pop    %rbp
  802003:	c3                   	ret

0000000000802004 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802004:	f3 0f 1e fa          	endbr64
  802008:	55                   	push   %rbp
  802009:	48 89 e5             	mov    %rsp,%rbp
  80200c:	41 54                	push   %r12
  80200e:	53                   	push   %rbx
  80200f:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802012:	ba 00 10 00 00       	mov    $0x1000,%edx
  802017:	48 89 fe             	mov    %rdi,%rsi
  80201a:	bf 00 00 00 00       	mov    $0x0,%edi
  80201f:	49 bc 6b 12 80 00 00 	movabs $0x80126b,%r12
  802026:	00 00 00 
  802029:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80202c:	48 89 df             	mov    %rbx,%rdi
  80202f:	48 b8 05 15 80 00 00 	movabs $0x801505,%rax
  802036:	00 00 00 
  802039:	ff d0                	call   *%rax
  80203b:	48 89 c6             	mov    %rax,%rsi
  80203e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802043:	bf 00 00 00 00       	mov    $0x0,%edi
  802048:	41 ff d4             	call   *%r12
}
  80204b:	5b                   	pop    %rbx
  80204c:	41 5c                	pop    %r12
  80204e:	5d                   	pop    %rbp
  80204f:	c3                   	ret

0000000000802050 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802050:	f3 0f 1e fa          	endbr64
  802054:	55                   	push   %rbp
  802055:	48 89 e5             	mov    %rsp,%rbp
  802058:	41 57                	push   %r15
  80205a:	41 56                	push   %r14
  80205c:	41 55                	push   %r13
  80205e:	41 54                	push   %r12
  802060:	53                   	push   %rbx
  802061:	48 83 ec 18          	sub    $0x18,%rsp
  802065:	49 89 fc             	mov    %rdi,%r12
  802068:	49 89 f5             	mov    %rsi,%r13
  80206b:	49 89 d7             	mov    %rdx,%r15
  80206e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802072:	48 b8 05 15 80 00 00 	movabs $0x801505,%rax
  802079:	00 00 00 
  80207c:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80207e:	4d 85 ff             	test   %r15,%r15
  802081:	0f 84 af 00 00 00    	je     802136 <devpipe_write+0xe6>
  802087:	48 89 c3             	mov    %rax,%rbx
  80208a:	4c 89 f8             	mov    %r15,%rax
  80208d:	4d 89 ef             	mov    %r13,%r15
  802090:	4c 01 e8             	add    %r13,%rax
  802093:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802097:	49 bd fb 10 80 00 00 	movabs $0x8010fb,%r13
  80209e:	00 00 00 
            sys_yield();
  8020a1:	49 be 90 10 80 00 00 	movabs $0x801090,%r14
  8020a8:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8020ab:	8b 73 04             	mov    0x4(%rbx),%esi
  8020ae:	48 63 ce             	movslq %esi,%rcx
  8020b1:	48 63 03             	movslq (%rbx),%rax
  8020b4:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8020ba:	48 39 c1             	cmp    %rax,%rcx
  8020bd:	72 2e                	jb     8020ed <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8020bf:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020c4:	48 89 da             	mov    %rbx,%rdx
  8020c7:	be 00 10 00 00       	mov    $0x1000,%esi
  8020cc:	4c 89 e7             	mov    %r12,%rdi
  8020cf:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	74 66                	je     80213c <devpipe_write+0xec>
            sys_yield();
  8020d6:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8020d9:	8b 73 04             	mov    0x4(%rbx),%esi
  8020dc:	48 63 ce             	movslq %esi,%rcx
  8020df:	48 63 03             	movslq (%rbx),%rax
  8020e2:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8020e8:	48 39 c1             	cmp    %rax,%rcx
  8020eb:	73 d2                	jae    8020bf <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020ed:	41 0f b6 3f          	movzbl (%r15),%edi
  8020f1:	48 89 ca             	mov    %rcx,%rdx
  8020f4:	48 c1 ea 03          	shr    $0x3,%rdx
  8020f8:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8020ff:	08 10 20 
  802102:	48 f7 e2             	mul    %rdx
  802105:	48 c1 ea 06          	shr    $0x6,%rdx
  802109:	48 89 d0             	mov    %rdx,%rax
  80210c:	48 c1 e0 09          	shl    $0x9,%rax
  802110:	48 29 d0             	sub    %rdx,%rax
  802113:	48 c1 e0 03          	shl    $0x3,%rax
  802117:	48 29 c1             	sub    %rax,%rcx
  80211a:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80211f:	83 c6 01             	add    $0x1,%esi
  802122:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802125:	49 83 c7 01          	add    $0x1,%r15
  802129:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80212d:	49 39 c7             	cmp    %rax,%r15
  802130:	0f 85 75 ff ff ff    	jne    8020ab <devpipe_write+0x5b>
    return n;
  802136:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80213a:	eb 05                	jmp    802141 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  80213c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802141:	48 83 c4 18          	add    $0x18,%rsp
  802145:	5b                   	pop    %rbx
  802146:	41 5c                	pop    %r12
  802148:	41 5d                	pop    %r13
  80214a:	41 5e                	pop    %r14
  80214c:	41 5f                	pop    %r15
  80214e:	5d                   	pop    %rbp
  80214f:	c3                   	ret

0000000000802150 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802150:	f3 0f 1e fa          	endbr64
  802154:	55                   	push   %rbp
  802155:	48 89 e5             	mov    %rsp,%rbp
  802158:	41 57                	push   %r15
  80215a:	41 56                	push   %r14
  80215c:	41 55                	push   %r13
  80215e:	41 54                	push   %r12
  802160:	53                   	push   %rbx
  802161:	48 83 ec 18          	sub    $0x18,%rsp
  802165:	49 89 fc             	mov    %rdi,%r12
  802168:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80216c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802170:	48 b8 05 15 80 00 00 	movabs $0x801505,%rax
  802177:	00 00 00 
  80217a:	ff d0                	call   *%rax
  80217c:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80217f:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802185:	49 bd fb 10 80 00 00 	movabs $0x8010fb,%r13
  80218c:	00 00 00 
            sys_yield();
  80218f:	49 be 90 10 80 00 00 	movabs $0x801090,%r14
  802196:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802199:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80219e:	74 7d                	je     80221d <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8021a0:	8b 03                	mov    (%rbx),%eax
  8021a2:	3b 43 04             	cmp    0x4(%rbx),%eax
  8021a5:	75 26                	jne    8021cd <devpipe_read+0x7d>
            if (i > 0) return i;
  8021a7:	4d 85 ff             	test   %r15,%r15
  8021aa:	75 77                	jne    802223 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021ac:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021b1:	48 89 da             	mov    %rbx,%rdx
  8021b4:	be 00 10 00 00       	mov    $0x1000,%esi
  8021b9:	4c 89 e7             	mov    %r12,%rdi
  8021bc:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	74 72                	je     802235 <devpipe_read+0xe5>
            sys_yield();
  8021c3:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8021c6:	8b 03                	mov    (%rbx),%eax
  8021c8:	3b 43 04             	cmp    0x4(%rbx),%eax
  8021cb:	74 df                	je     8021ac <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021cd:	48 63 c8             	movslq %eax,%rcx
  8021d0:	48 89 ca             	mov    %rcx,%rdx
  8021d3:	48 c1 ea 03          	shr    $0x3,%rdx
  8021d7:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8021de:	08 10 20 
  8021e1:	48 89 d0             	mov    %rdx,%rax
  8021e4:	48 f7 e6             	mul    %rsi
  8021e7:	48 c1 ea 06          	shr    $0x6,%rdx
  8021eb:	48 89 d0             	mov    %rdx,%rax
  8021ee:	48 c1 e0 09          	shl    $0x9,%rax
  8021f2:	48 29 d0             	sub    %rdx,%rax
  8021f5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8021fc:	00 
  8021fd:	48 89 c8             	mov    %rcx,%rax
  802200:	48 29 d0             	sub    %rdx,%rax
  802203:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802208:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80220c:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802210:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802213:	49 83 c7 01          	add    $0x1,%r15
  802217:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80221b:	75 83                	jne    8021a0 <devpipe_read+0x50>
    return n;
  80221d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802221:	eb 03                	jmp    802226 <devpipe_read+0xd6>
            if (i > 0) return i;
  802223:	4c 89 f8             	mov    %r15,%rax
}
  802226:	48 83 c4 18          	add    $0x18,%rsp
  80222a:	5b                   	pop    %rbx
  80222b:	41 5c                	pop    %r12
  80222d:	41 5d                	pop    %r13
  80222f:	41 5e                	pop    %r14
  802231:	41 5f                	pop    %r15
  802233:	5d                   	pop    %rbp
  802234:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802235:	b8 00 00 00 00       	mov    $0x0,%eax
  80223a:	eb ea                	jmp    802226 <devpipe_read+0xd6>

000000000080223c <pipe>:
pipe(int pfd[2]) {
  80223c:	f3 0f 1e fa          	endbr64
  802240:	55                   	push   %rbp
  802241:	48 89 e5             	mov    %rsp,%rbp
  802244:	41 55                	push   %r13
  802246:	41 54                	push   %r12
  802248:	53                   	push   %rbx
  802249:	48 83 ec 18          	sub    $0x18,%rsp
  80224d:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802250:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802254:	48 b8 25 15 80 00 00 	movabs $0x801525,%rax
  80225b:	00 00 00 
  80225e:	ff d0                	call   *%rax
  802260:	89 c3                	mov    %eax,%ebx
  802262:	85 c0                	test   %eax,%eax
  802264:	0f 88 a0 01 00 00    	js     80240a <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80226a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80226f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802274:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802278:	bf 00 00 00 00       	mov    $0x0,%edi
  80227d:	48 b8 2b 11 80 00 00 	movabs $0x80112b,%rax
  802284:	00 00 00 
  802287:	ff d0                	call   *%rax
  802289:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80228b:	85 c0                	test   %eax,%eax
  80228d:	0f 88 77 01 00 00    	js     80240a <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802293:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802297:	48 b8 25 15 80 00 00 	movabs $0x801525,%rax
  80229e:	00 00 00 
  8022a1:	ff d0                	call   *%rax
  8022a3:	89 c3                	mov    %eax,%ebx
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	0f 88 43 01 00 00    	js     8023f0 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8022ad:	b9 46 00 00 00       	mov    $0x46,%ecx
  8022b2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022b7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c0:	48 b8 2b 11 80 00 00 	movabs $0x80112b,%rax
  8022c7:	00 00 00 
  8022ca:	ff d0                	call   *%rax
  8022cc:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8022ce:	85 c0                	test   %eax,%eax
  8022d0:	0f 88 1a 01 00 00    	js     8023f0 <pipe+0x1b4>
    va = fd2data(fd0);
  8022d6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022da:	48 b8 05 15 80 00 00 	movabs $0x801505,%rax
  8022e1:	00 00 00 
  8022e4:	ff d0                	call   *%rax
  8022e6:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8022e9:	b9 46 00 00 00       	mov    $0x46,%ecx
  8022ee:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022f3:	48 89 c6             	mov    %rax,%rsi
  8022f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8022fb:	48 b8 2b 11 80 00 00 	movabs $0x80112b,%rax
  802302:	00 00 00 
  802305:	ff d0                	call   *%rax
  802307:	89 c3                	mov    %eax,%ebx
  802309:	85 c0                	test   %eax,%eax
  80230b:	0f 88 c5 00 00 00    	js     8023d6 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802311:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802315:	48 b8 05 15 80 00 00 	movabs $0x801505,%rax
  80231c:	00 00 00 
  80231f:	ff d0                	call   *%rax
  802321:	48 89 c1             	mov    %rax,%rcx
  802324:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80232a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802330:	ba 00 00 00 00       	mov    $0x0,%edx
  802335:	4c 89 ee             	mov    %r13,%rsi
  802338:	bf 00 00 00 00       	mov    $0x0,%edi
  80233d:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  802344:	00 00 00 
  802347:	ff d0                	call   *%rax
  802349:	89 c3                	mov    %eax,%ebx
  80234b:	85 c0                	test   %eax,%eax
  80234d:	78 6e                	js     8023bd <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80234f:	be 00 10 00 00       	mov    $0x1000,%esi
  802354:	4c 89 ef             	mov    %r13,%rdi
  802357:	48 b8 c5 10 80 00 00 	movabs $0x8010c5,%rax
  80235e:	00 00 00 
  802361:	ff d0                	call   *%rax
  802363:	83 f8 02             	cmp    $0x2,%eax
  802366:	0f 85 ab 00 00 00    	jne    802417 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  80236c:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802373:	00 00 
  802375:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802379:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80237b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80237f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802386:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80238a:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80238c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802390:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802397:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80239b:	48 bb ef 14 80 00 00 	movabs $0x8014ef,%rbx
  8023a2:	00 00 00 
  8023a5:	ff d3                	call   *%rbx
  8023a7:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8023ab:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8023af:	ff d3                	call   *%rbx
  8023b1:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8023b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023bb:	eb 4d                	jmp    80240a <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8023bd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023c2:	4c 89 ee             	mov    %r13,%rsi
  8023c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ca:	48 b8 6b 12 80 00 00 	movabs $0x80126b,%rax
  8023d1:	00 00 00 
  8023d4:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8023d6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023db:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023df:	bf 00 00 00 00       	mov    $0x0,%edi
  8023e4:	48 b8 6b 12 80 00 00 	movabs $0x80126b,%rax
  8023eb:	00 00 00 
  8023ee:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8023f0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023f5:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8023f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8023fe:	48 b8 6b 12 80 00 00 	movabs $0x80126b,%rax
  802405:	00 00 00 
  802408:	ff d0                	call   *%rax
}
  80240a:	89 d8                	mov    %ebx,%eax
  80240c:	48 83 c4 18          	add    $0x18,%rsp
  802410:	5b                   	pop    %rbx
  802411:	41 5c                	pop    %r12
  802413:	41 5d                	pop    %r13
  802415:	5d                   	pop    %rbp
  802416:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802417:	48 b9 48 36 80 00 00 	movabs $0x803648,%rcx
  80241e:	00 00 00 
  802421:	48 ba 01 32 80 00 00 	movabs $0x803201,%rdx
  802428:	00 00 00 
  80242b:	be 2e 00 00 00       	mov    $0x2e,%esi
  802430:	48 bf 28 32 80 00 00 	movabs $0x803228,%rdi
  802437:	00 00 00 
  80243a:	b8 00 00 00 00       	mov    $0x0,%eax
  80243f:	49 b8 56 2a 80 00 00 	movabs $0x802a56,%r8
  802446:	00 00 00 
  802449:	41 ff d0             	call   *%r8

000000000080244c <pipeisclosed>:
pipeisclosed(int fdnum) {
  80244c:	f3 0f 1e fa          	endbr64
  802450:	55                   	push   %rbp
  802451:	48 89 e5             	mov    %rsp,%rbp
  802454:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802458:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80245c:	48 b8 89 15 80 00 00 	movabs $0x801589,%rax
  802463:	00 00 00 
  802466:	ff d0                	call   *%rax
    if (res < 0) return res;
  802468:	85 c0                	test   %eax,%eax
  80246a:	78 35                	js     8024a1 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80246c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802470:	48 b8 05 15 80 00 00 	movabs $0x801505,%rax
  802477:	00 00 00 
  80247a:	ff d0                	call   *%rax
  80247c:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80247f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802484:	be 00 10 00 00       	mov    $0x1000,%esi
  802489:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80248d:	48 b8 fb 10 80 00 00 	movabs $0x8010fb,%rax
  802494:	00 00 00 
  802497:	ff d0                	call   *%rax
  802499:	85 c0                	test   %eax,%eax
  80249b:	0f 94 c0             	sete   %al
  80249e:	0f b6 c0             	movzbl %al,%eax
}
  8024a1:	c9                   	leave
  8024a2:	c3                   	ret

00000000008024a3 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8024a3:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8024a7:	48 89 f8             	mov    %rdi,%rax
  8024aa:	48 c1 e8 27          	shr    $0x27,%rax
  8024ae:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8024b5:	7f 00 00 
  8024b8:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024bc:	f6 c2 01             	test   $0x1,%dl
  8024bf:	74 6d                	je     80252e <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8024c1:	48 89 f8             	mov    %rdi,%rax
  8024c4:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024c8:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8024cf:	7f 00 00 
  8024d2:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024d6:	f6 c2 01             	test   $0x1,%dl
  8024d9:	74 62                	je     80253d <get_uvpt_entry+0x9a>
  8024db:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8024e2:	7f 00 00 
  8024e5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024e9:	f6 c2 80             	test   $0x80,%dl
  8024ec:	75 4f                	jne    80253d <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8024ee:	48 89 f8             	mov    %rdi,%rax
  8024f1:	48 c1 e8 15          	shr    $0x15,%rax
  8024f5:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8024fc:	7f 00 00 
  8024ff:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802503:	f6 c2 01             	test   $0x1,%dl
  802506:	74 44                	je     80254c <get_uvpt_entry+0xa9>
  802508:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80250f:	7f 00 00 
  802512:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802516:	f6 c2 80             	test   $0x80,%dl
  802519:	75 31                	jne    80254c <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80251b:	48 c1 ef 0c          	shr    $0xc,%rdi
  80251f:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802526:	7f 00 00 
  802529:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80252d:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80252e:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802535:	7f 00 00 
  802538:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80253c:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80253d:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802544:	7f 00 00 
  802547:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80254b:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80254c:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802553:	7f 00 00 
  802556:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80255a:	c3                   	ret

000000000080255b <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  80255b:	f3 0f 1e fa          	endbr64
  80255f:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802562:	48 89 f9             	mov    %rdi,%rcx
  802565:	48 c1 e9 27          	shr    $0x27,%rcx
  802569:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802570:	7f 00 00 
  802573:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802577:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  80257e:	f6 c1 01             	test   $0x1,%cl
  802581:	0f 84 b2 00 00 00    	je     802639 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802587:	48 89 f9             	mov    %rdi,%rcx
  80258a:	48 c1 e9 1e          	shr    $0x1e,%rcx
  80258e:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802595:	7f 00 00 
  802598:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80259c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8025a3:	40 f6 c6 01          	test   $0x1,%sil
  8025a7:	0f 84 8c 00 00 00    	je     802639 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8025ad:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8025b4:	7f 00 00 
  8025b7:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8025bb:	a8 80                	test   $0x80,%al
  8025bd:	75 7b                	jne    80263a <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8025bf:	48 89 f9             	mov    %rdi,%rcx
  8025c2:	48 c1 e9 15          	shr    $0x15,%rcx
  8025c6:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8025cd:	7f 00 00 
  8025d0:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8025d4:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  8025db:	40 f6 c6 01          	test   $0x1,%sil
  8025df:	74 58                	je     802639 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  8025e1:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8025e8:	7f 00 00 
  8025eb:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8025ef:	a8 80                	test   $0x80,%al
  8025f1:	75 6c                	jne    80265f <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  8025f3:	48 89 f9             	mov    %rdi,%rcx
  8025f6:	48 c1 e9 0c          	shr    $0xc,%rcx
  8025fa:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802601:	7f 00 00 
  802604:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802608:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  80260f:	40 f6 c6 01          	test   $0x1,%sil
  802613:	74 24                	je     802639 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802615:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80261c:	7f 00 00 
  80261f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802623:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80262a:	ff ff 7f 
  80262d:	48 21 c8             	and    %rcx,%rax
  802630:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802636:	48 09 d0             	or     %rdx,%rax
}
  802639:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  80263a:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802641:	7f 00 00 
  802644:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802648:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80264f:	ff ff 7f 
  802652:	48 21 c8             	and    %rcx,%rax
  802655:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  80265b:	48 01 d0             	add    %rdx,%rax
  80265e:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  80265f:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802666:	7f 00 00 
  802669:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80266d:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802674:	ff ff 7f 
  802677:	48 21 c8             	and    %rcx,%rax
  80267a:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802680:	48 01 d0             	add    %rdx,%rax
  802683:	c3                   	ret

0000000000802684 <get_prot>:

int
get_prot(void *va) {
  802684:	f3 0f 1e fa          	endbr64
  802688:	55                   	push   %rbp
  802689:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80268c:	48 b8 a3 24 80 00 00 	movabs $0x8024a3,%rax
  802693:	00 00 00 
  802696:	ff d0                	call   *%rax
  802698:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  80269b:	83 e0 01             	and    $0x1,%eax
  80269e:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8026a1:	89 d1                	mov    %edx,%ecx
  8026a3:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8026a9:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8026ab:	89 c1                	mov    %eax,%ecx
  8026ad:	83 c9 02             	or     $0x2,%ecx
  8026b0:	f6 c2 02             	test   $0x2,%dl
  8026b3:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8026b6:	89 c1                	mov    %eax,%ecx
  8026b8:	83 c9 01             	or     $0x1,%ecx
  8026bb:	48 85 d2             	test   %rdx,%rdx
  8026be:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8026c1:	89 c1                	mov    %eax,%ecx
  8026c3:	83 c9 40             	or     $0x40,%ecx
  8026c6:	f6 c6 04             	test   $0x4,%dh
  8026c9:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8026cc:	5d                   	pop    %rbp
  8026cd:	c3                   	ret

00000000008026ce <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8026ce:	f3 0f 1e fa          	endbr64
  8026d2:	55                   	push   %rbp
  8026d3:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8026d6:	48 b8 a3 24 80 00 00 	movabs $0x8024a3,%rax
  8026dd:	00 00 00 
  8026e0:	ff d0                	call   *%rax
    return pte & PTE_D;
  8026e2:	48 c1 e8 06          	shr    $0x6,%rax
  8026e6:	83 e0 01             	and    $0x1,%eax
}
  8026e9:	5d                   	pop    %rbp
  8026ea:	c3                   	ret

00000000008026eb <is_page_present>:

bool
is_page_present(void *va) {
  8026eb:	f3 0f 1e fa          	endbr64
  8026ef:	55                   	push   %rbp
  8026f0:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8026f3:	48 b8 a3 24 80 00 00 	movabs $0x8024a3,%rax
  8026fa:	00 00 00 
  8026fd:	ff d0                	call   *%rax
  8026ff:	83 e0 01             	and    $0x1,%eax
}
  802702:	5d                   	pop    %rbp
  802703:	c3                   	ret

0000000000802704 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802704:	f3 0f 1e fa          	endbr64
  802708:	55                   	push   %rbp
  802709:	48 89 e5             	mov    %rsp,%rbp
  80270c:	41 57                	push   %r15
  80270e:	41 56                	push   %r14
  802710:	41 55                	push   %r13
  802712:	41 54                	push   %r12
  802714:	53                   	push   %rbx
  802715:	48 83 ec 18          	sub    $0x18,%rsp
  802719:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80271d:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802721:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802726:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  80272d:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802730:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802737:	7f 00 00 
    while (va < USER_STACK_TOP) {
  80273a:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802741:	00 00 00 
  802744:	eb 73                	jmp    8027b9 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802746:	48 89 d8             	mov    %rbx,%rax
  802749:	48 c1 e8 15          	shr    $0x15,%rax
  80274d:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802754:	7f 00 00 
  802757:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  80275b:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802761:	f6 c2 01             	test   $0x1,%dl
  802764:	74 4b                	je     8027b1 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802766:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  80276a:	f6 c2 80             	test   $0x80,%dl
  80276d:	74 11                	je     802780 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  80276f:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802773:	f6 c4 04             	test   $0x4,%ah
  802776:	74 39                	je     8027b1 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802778:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  80277e:	eb 20                	jmp    8027a0 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802780:	48 89 da             	mov    %rbx,%rdx
  802783:	48 c1 ea 0c          	shr    $0xc,%rdx
  802787:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80278e:	7f 00 00 
  802791:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802795:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80279b:	f6 c4 04             	test   $0x4,%ah
  80279e:	74 11                	je     8027b1 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  8027a0:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  8027a4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8027a8:	48 89 df             	mov    %rbx,%rdi
  8027ab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8027af:	ff d0                	call   *%rax
    next:
        va += size;
  8027b1:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  8027b4:	49 39 df             	cmp    %rbx,%r15
  8027b7:	72 3e                	jb     8027f7 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8027b9:	49 8b 06             	mov    (%r14),%rax
  8027bc:	a8 01                	test   $0x1,%al
  8027be:	74 37                	je     8027f7 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8027c0:	48 89 d8             	mov    %rbx,%rax
  8027c3:	48 c1 e8 1e          	shr    $0x1e,%rax
  8027c7:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  8027cc:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8027d2:	f6 c2 01             	test   $0x1,%dl
  8027d5:	74 da                	je     8027b1 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  8027d7:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  8027dc:	f6 c2 80             	test   $0x80,%dl
  8027df:	0f 84 61 ff ff ff    	je     802746 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  8027e5:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8027ea:	f6 c4 04             	test   $0x4,%ah
  8027ed:	74 c2                	je     8027b1 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  8027ef:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  8027f5:	eb a9                	jmp    8027a0 <foreach_shared_region+0x9c>
    }
    return res;
}
  8027f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fc:	48 83 c4 18          	add    $0x18,%rsp
  802800:	5b                   	pop    %rbx
  802801:	41 5c                	pop    %r12
  802803:	41 5d                	pop    %r13
  802805:	41 5e                	pop    %r14
  802807:	41 5f                	pop    %r15
  802809:	5d                   	pop    %rbp
  80280a:	c3                   	ret

000000000080280b <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  80280b:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  80280f:	b8 00 00 00 00       	mov    $0x0,%eax
  802814:	c3                   	ret

0000000000802815 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802815:	f3 0f 1e fa          	endbr64
  802819:	55                   	push   %rbp
  80281a:	48 89 e5             	mov    %rsp,%rbp
  80281d:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802820:	48 be 38 32 80 00 00 	movabs $0x803238,%rsi
  802827:	00 00 00 
  80282a:	48 b8 26 0b 80 00 00 	movabs $0x800b26,%rax
  802831:	00 00 00 
  802834:	ff d0                	call   *%rax
    return 0;
}
  802836:	b8 00 00 00 00       	mov    $0x0,%eax
  80283b:	5d                   	pop    %rbp
  80283c:	c3                   	ret

000000000080283d <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80283d:	f3 0f 1e fa          	endbr64
  802841:	55                   	push   %rbp
  802842:	48 89 e5             	mov    %rsp,%rbp
  802845:	41 57                	push   %r15
  802847:	41 56                	push   %r14
  802849:	41 55                	push   %r13
  80284b:	41 54                	push   %r12
  80284d:	53                   	push   %rbx
  80284e:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802855:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  80285c:	48 85 d2             	test   %rdx,%rdx
  80285f:	74 7a                	je     8028db <devcons_write+0x9e>
  802861:	49 89 d6             	mov    %rdx,%r14
  802864:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80286a:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  80286f:	49 bf 41 0d 80 00 00 	movabs $0x800d41,%r15
  802876:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802879:	4c 89 f3             	mov    %r14,%rbx
  80287c:	48 29 f3             	sub    %rsi,%rbx
  80287f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802884:	48 39 c3             	cmp    %rax,%rbx
  802887:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  80288b:	4c 63 eb             	movslq %ebx,%r13
  80288e:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802895:	48 01 c6             	add    %rax,%rsi
  802898:	4c 89 ea             	mov    %r13,%rdx
  80289b:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8028a2:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8028a5:	4c 89 ee             	mov    %r13,%rsi
  8028a8:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8028af:	48 b8 86 0f 80 00 00 	movabs $0x800f86,%rax
  8028b6:	00 00 00 
  8028b9:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8028bb:	41 01 dc             	add    %ebx,%r12d
  8028be:	49 63 f4             	movslq %r12d,%rsi
  8028c1:	4c 39 f6             	cmp    %r14,%rsi
  8028c4:	72 b3                	jb     802879 <devcons_write+0x3c>
    return res;
  8028c6:	49 63 c4             	movslq %r12d,%rax
}
  8028c9:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8028d0:	5b                   	pop    %rbx
  8028d1:	41 5c                	pop    %r12
  8028d3:	41 5d                	pop    %r13
  8028d5:	41 5e                	pop    %r14
  8028d7:	41 5f                	pop    %r15
  8028d9:	5d                   	pop    %rbp
  8028da:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  8028db:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8028e1:	eb e3                	jmp    8028c6 <devcons_write+0x89>

00000000008028e3 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8028e3:	f3 0f 1e fa          	endbr64
  8028e7:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8028ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ef:	48 85 c0             	test   %rax,%rax
  8028f2:	74 55                	je     802949 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8028f4:	55                   	push   %rbp
  8028f5:	48 89 e5             	mov    %rsp,%rbp
  8028f8:	41 55                	push   %r13
  8028fa:	41 54                	push   %r12
  8028fc:	53                   	push   %rbx
  8028fd:	48 83 ec 08          	sub    $0x8,%rsp
  802901:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802904:	48 bb b7 0f 80 00 00 	movabs $0x800fb7,%rbx
  80290b:	00 00 00 
  80290e:	49 bc 90 10 80 00 00 	movabs $0x801090,%r12
  802915:	00 00 00 
  802918:	eb 03                	jmp    80291d <devcons_read+0x3a>
  80291a:	41 ff d4             	call   *%r12
  80291d:	ff d3                	call   *%rbx
  80291f:	85 c0                	test   %eax,%eax
  802921:	74 f7                	je     80291a <devcons_read+0x37>
    if (c < 0) return c;
  802923:	48 63 d0             	movslq %eax,%rdx
  802926:	78 13                	js     80293b <devcons_read+0x58>
    if (c == 0x04) return 0;
  802928:	ba 00 00 00 00       	mov    $0x0,%edx
  80292d:	83 f8 04             	cmp    $0x4,%eax
  802930:	74 09                	je     80293b <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802932:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802936:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80293b:	48 89 d0             	mov    %rdx,%rax
  80293e:	48 83 c4 08          	add    $0x8,%rsp
  802942:	5b                   	pop    %rbx
  802943:	41 5c                	pop    %r12
  802945:	41 5d                	pop    %r13
  802947:	5d                   	pop    %rbp
  802948:	c3                   	ret
  802949:	48 89 d0             	mov    %rdx,%rax
  80294c:	c3                   	ret

000000000080294d <cputchar>:
cputchar(int ch) {
  80294d:	f3 0f 1e fa          	endbr64
  802951:	55                   	push   %rbp
  802952:	48 89 e5             	mov    %rsp,%rbp
  802955:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802959:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80295d:	be 01 00 00 00       	mov    $0x1,%esi
  802962:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802966:	48 b8 86 0f 80 00 00 	movabs $0x800f86,%rax
  80296d:	00 00 00 
  802970:	ff d0                	call   *%rax
}
  802972:	c9                   	leave
  802973:	c3                   	ret

0000000000802974 <getchar>:
getchar(void) {
  802974:	f3 0f 1e fa          	endbr64
  802978:	55                   	push   %rbp
  802979:	48 89 e5             	mov    %rsp,%rbp
  80297c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802980:	ba 01 00 00 00       	mov    $0x1,%edx
  802985:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802989:	bf 00 00 00 00       	mov    $0x0,%edi
  80298e:	48 b8 84 18 80 00 00 	movabs $0x801884,%rax
  802995:	00 00 00 
  802998:	ff d0                	call   *%rax
  80299a:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  80299c:	85 c0                	test   %eax,%eax
  80299e:	78 06                	js     8029a6 <getchar+0x32>
  8029a0:	74 08                	je     8029aa <getchar+0x36>
  8029a2:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8029a6:	89 d0                	mov    %edx,%eax
  8029a8:	c9                   	leave
  8029a9:	c3                   	ret
    return res < 0 ? res : res ? c :
  8029aa:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8029af:	eb f5                	jmp    8029a6 <getchar+0x32>

00000000008029b1 <iscons>:
iscons(int fdnum) {
  8029b1:	f3 0f 1e fa          	endbr64
  8029b5:	55                   	push   %rbp
  8029b6:	48 89 e5             	mov    %rsp,%rbp
  8029b9:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8029bd:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8029c1:	48 b8 89 15 80 00 00 	movabs $0x801589,%rax
  8029c8:	00 00 00 
  8029cb:	ff d0                	call   *%rax
    if (res < 0) return res;
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	78 18                	js     8029e9 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  8029d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029d5:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8029dc:	00 00 00 
  8029df:	8b 00                	mov    (%rax),%eax
  8029e1:	39 02                	cmp    %eax,(%rdx)
  8029e3:	0f 94 c0             	sete   %al
  8029e6:	0f b6 c0             	movzbl %al,%eax
}
  8029e9:	c9                   	leave
  8029ea:	c3                   	ret

00000000008029eb <opencons>:
opencons(void) {
  8029eb:	f3 0f 1e fa          	endbr64
  8029ef:	55                   	push   %rbp
  8029f0:	48 89 e5             	mov    %rsp,%rbp
  8029f3:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8029f7:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8029fb:	48 b8 25 15 80 00 00 	movabs $0x801525,%rax
  802a02:	00 00 00 
  802a05:	ff d0                	call   *%rax
  802a07:	85 c0                	test   %eax,%eax
  802a09:	78 49                	js     802a54 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802a0b:	b9 46 00 00 00       	mov    $0x46,%ecx
  802a10:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a15:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802a19:	bf 00 00 00 00       	mov    $0x0,%edi
  802a1e:	48 b8 2b 11 80 00 00 	movabs $0x80112b,%rax
  802a25:	00 00 00 
  802a28:	ff d0                	call   *%rax
  802a2a:	85 c0                	test   %eax,%eax
  802a2c:	78 26                	js     802a54 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802a2e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a32:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802a39:	00 00 
  802a3b:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802a3d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802a41:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802a48:	48 b8 ef 14 80 00 00 	movabs $0x8014ef,%rax
  802a4f:	00 00 00 
  802a52:	ff d0                	call   *%rax
}
  802a54:	c9                   	leave
  802a55:	c3                   	ret

0000000000802a56 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802a56:	f3 0f 1e fa          	endbr64
  802a5a:	55                   	push   %rbp
  802a5b:	48 89 e5             	mov    %rsp,%rbp
  802a5e:	41 56                	push   %r14
  802a60:	41 55                	push   %r13
  802a62:	41 54                	push   %r12
  802a64:	53                   	push   %rbx
  802a65:	48 83 ec 50          	sub    $0x50,%rsp
  802a69:	49 89 fc             	mov    %rdi,%r12
  802a6c:	41 89 f5             	mov    %esi,%r13d
  802a6f:	48 89 d3             	mov    %rdx,%rbx
  802a72:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802a76:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802a7a:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802a7e:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802a85:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a89:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802a8d:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802a91:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802a95:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802a9c:	00 00 00 
  802a9f:	4c 8b 30             	mov    (%rax),%r14
  802aa2:	48 b8 5b 10 80 00 00 	movabs $0x80105b,%rax
  802aa9:	00 00 00 
  802aac:	ff d0                	call   *%rax
  802aae:	89 c6                	mov    %eax,%esi
  802ab0:	45 89 e8             	mov    %r13d,%r8d
  802ab3:	4c 89 e1             	mov    %r12,%rcx
  802ab6:	4c 89 f2             	mov    %r14,%rdx
  802ab9:	48 bf 70 36 80 00 00 	movabs $0x803670,%rdi
  802ac0:	00 00 00 
  802ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac8:	49 bc dd 01 80 00 00 	movabs $0x8001dd,%r12
  802acf:	00 00 00 
  802ad2:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802ad5:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802ad9:	48 89 df             	mov    %rbx,%rdi
  802adc:	48 b8 75 01 80 00 00 	movabs $0x800175,%rax
  802ae3:	00 00 00 
  802ae6:	ff d0                	call   *%rax
    cprintf("\n");
  802ae8:	48 bf 02 30 80 00 00 	movabs $0x803002,%rdi
  802aef:	00 00 00 
  802af2:	b8 00 00 00 00       	mov    $0x0,%eax
  802af7:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802afa:	cc                   	int3
  802afb:	eb fd                	jmp    802afa <_panic+0xa4>

0000000000802afd <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802afd:	f3 0f 1e fa          	endbr64
  802b01:	55                   	push   %rbp
  802b02:	48 89 e5             	mov    %rsp,%rbp
  802b05:	41 54                	push   %r12
  802b07:	53                   	push   %rbx
  802b08:	48 89 fb             	mov    %rdi,%rbx
  802b0b:	48 89 f7             	mov    %rsi,%rdi
  802b0e:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b11:	48 85 f6             	test   %rsi,%rsi
  802b14:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b1b:	00 00 00 
  802b1e:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b22:	be 00 10 00 00       	mov    $0x1000,%esi
  802b27:	48 b8 4d 14 80 00 00 	movabs $0x80144d,%rax
  802b2e:	00 00 00 
  802b31:	ff d0                	call   *%rax
    if (res < 0) {
  802b33:	85 c0                	test   %eax,%eax
  802b35:	78 45                	js     802b7c <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b37:	48 85 db             	test   %rbx,%rbx
  802b3a:	74 12                	je     802b4e <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b3c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b43:	00 00 00 
  802b46:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b4c:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b4e:	4d 85 e4             	test   %r12,%r12
  802b51:	74 14                	je     802b67 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b53:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b5a:	00 00 00 
  802b5d:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b63:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b67:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b6e:	00 00 00 
  802b71:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b77:	5b                   	pop    %rbx
  802b78:	41 5c                	pop    %r12
  802b7a:	5d                   	pop    %rbp
  802b7b:	c3                   	ret
        if (from_env_store != NULL) {
  802b7c:	48 85 db             	test   %rbx,%rbx
  802b7f:	74 06                	je     802b87 <ipc_recv+0x8a>
            *from_env_store = 0;
  802b81:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b87:	4d 85 e4             	test   %r12,%r12
  802b8a:	74 eb                	je     802b77 <ipc_recv+0x7a>
            *perm_store = 0;
  802b8c:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b93:	00 
  802b94:	eb e1                	jmp    802b77 <ipc_recv+0x7a>

0000000000802b96 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b96:	f3 0f 1e fa          	endbr64
  802b9a:	55                   	push   %rbp
  802b9b:	48 89 e5             	mov    %rsp,%rbp
  802b9e:	41 57                	push   %r15
  802ba0:	41 56                	push   %r14
  802ba2:	41 55                	push   %r13
  802ba4:	41 54                	push   %r12
  802ba6:	53                   	push   %rbx
  802ba7:	48 83 ec 18          	sub    $0x18,%rsp
  802bab:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802bae:	48 89 d3             	mov    %rdx,%rbx
  802bb1:	49 89 cc             	mov    %rcx,%r12
  802bb4:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802bb7:	48 85 d2             	test   %rdx,%rdx
  802bba:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bc1:	00 00 00 
  802bc4:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bc8:	89 f0                	mov    %esi,%eax
  802bca:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802bce:	48 89 da             	mov    %rbx,%rdx
  802bd1:	48 89 c6             	mov    %rax,%rsi
  802bd4:	48 b8 1d 14 80 00 00 	movabs $0x80141d,%rax
  802bdb:	00 00 00 
  802bde:	ff d0                	call   *%rax
    while (res < 0) {
  802be0:	85 c0                	test   %eax,%eax
  802be2:	79 65                	jns    802c49 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802be4:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802be7:	75 33                	jne    802c1c <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802be9:	49 bf 90 10 80 00 00 	movabs $0x801090,%r15
  802bf0:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bf3:	49 be 1d 14 80 00 00 	movabs $0x80141d,%r14
  802bfa:	00 00 00 
        sys_yield();
  802bfd:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c00:	45 89 e8             	mov    %r13d,%r8d
  802c03:	4c 89 e1             	mov    %r12,%rcx
  802c06:	48 89 da             	mov    %rbx,%rdx
  802c09:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802c0d:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802c10:	41 ff d6             	call   *%r14
    while (res < 0) {
  802c13:	85 c0                	test   %eax,%eax
  802c15:	79 32                	jns    802c49 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c17:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c1a:	74 e1                	je     802bfd <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c1c:	89 c1                	mov    %eax,%ecx
  802c1e:	48 ba 44 32 80 00 00 	movabs $0x803244,%rdx
  802c25:	00 00 00 
  802c28:	be 42 00 00 00       	mov    $0x42,%esi
  802c2d:	48 bf 4f 32 80 00 00 	movabs $0x80324f,%rdi
  802c34:	00 00 00 
  802c37:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3c:	49 b8 56 2a 80 00 00 	movabs $0x802a56,%r8
  802c43:	00 00 00 
  802c46:	41 ff d0             	call   *%r8
    }
}
  802c49:	48 83 c4 18          	add    $0x18,%rsp
  802c4d:	5b                   	pop    %rbx
  802c4e:	41 5c                	pop    %r12
  802c50:	41 5d                	pop    %r13
  802c52:	41 5e                	pop    %r14
  802c54:	41 5f                	pop    %r15
  802c56:	5d                   	pop    %rbp
  802c57:	c3                   	ret

0000000000802c58 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c58:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c5c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c61:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c68:	00 00 00 
  802c6b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c6f:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c73:	48 c1 e2 04          	shl    $0x4,%rdx
  802c77:	48 01 ca             	add    %rcx,%rdx
  802c7a:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c80:	39 fa                	cmp    %edi,%edx
  802c82:	74 12                	je     802c96 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c84:	48 83 c0 01          	add    $0x1,%rax
  802c88:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c8e:	75 db                	jne    802c6b <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c95:	c3                   	ret
            return envs[i].env_id;
  802c96:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c9a:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c9e:	48 c1 e2 04          	shl    $0x4,%rdx
  802ca2:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802ca9:	00 00 00 
  802cac:	48 01 d0             	add    %rdx,%rax
  802caf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cb5:	c3                   	ret

0000000000802cb6 <__text_end>:
  802cb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cbd:	00 00 00 
  802cc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cc7:	00 00 00 
  802cca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cd1:	00 00 00 
  802cd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cdb:	00 00 00 
  802cde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ce5:	00 00 00 
  802ce8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cef:	00 00 00 
  802cf2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cf9:	00 00 00 
  802cfc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d03:	00 00 00 
  802d06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d0d:	00 00 00 
  802d10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d17:	00 00 00 
  802d1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d21:	00 00 00 
  802d24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d2b:	00 00 00 
  802d2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d35:	00 00 00 
  802d38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d3f:	00 00 00 
  802d42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d49:	00 00 00 
  802d4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d53:	00 00 00 
  802d56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d5d:	00 00 00 
  802d60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d67:	00 00 00 
  802d6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d71:	00 00 00 
  802d74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d7b:	00 00 00 
  802d7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d85:	00 00 00 
  802d88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d8f:	00 00 00 
  802d92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d99:	00 00 00 
  802d9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802da3:	00 00 00 
  802da6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dad:	00 00 00 
  802db0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802db7:	00 00 00 
  802dba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dc1:	00 00 00 
  802dc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dcb:	00 00 00 
  802dce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd5:	00 00 00 
  802dd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ddf:	00 00 00 
  802de2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de9:	00 00 00 
  802dec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df3:	00 00 00 
  802df6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dfd:	00 00 00 
  802e00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e07:	00 00 00 
  802e0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e11:	00 00 00 
  802e14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e1b:	00 00 00 
  802e1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e25:	00 00 00 
  802e28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e2f:	00 00 00 
  802e32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e39:	00 00 00 
  802e3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e43:	00 00 00 
  802e46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e4d:	00 00 00 
  802e50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e57:	00 00 00 
  802e5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e61:	00 00 00 
  802e64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e6b:	00 00 00 
  802e6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e75:	00 00 00 
  802e78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e7f:	00 00 00 
  802e82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e89:	00 00 00 
  802e8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e93:	00 00 00 
  802e96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e9d:	00 00 00 
  802ea0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea7:	00 00 00 
  802eaa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb1:	00 00 00 
  802eb4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ebb:	00 00 00 
  802ebe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec5:	00 00 00 
  802ec8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ecf:	00 00 00 
  802ed2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed9:	00 00 00 
  802edc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee3:	00 00 00 
  802ee6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eed:	00 00 00 
  802ef0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef7:	00 00 00 
  802efa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f01:	00 00 00 
  802f04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f0b:	00 00 00 
  802f0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f15:	00 00 00 
  802f18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f1f:	00 00 00 
  802f22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f29:	00 00 00 
  802f2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f33:	00 00 00 
  802f36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f3d:	00 00 00 
  802f40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f47:	00 00 00 
  802f4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f51:	00 00 00 
  802f54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f5b:	00 00 00 
  802f5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f65:	00 00 00 
  802f68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f6f:	00 00 00 
  802f72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f79:	00 00 00 
  802f7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f83:	00 00 00 
  802f86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f8d:	00 00 00 
  802f90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f97:	00 00 00 
  802f9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa1:	00 00 00 
  802fa4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fab:	00 00 00 
  802fae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb5:	00 00 00 
  802fb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fbf:	00 00 00 
  802fc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc9:	00 00 00 
  802fcc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd3:	00 00 00 
  802fd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fdd:	00 00 00 
  802fe0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe7:	00 00 00 
  802fea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff1:	00 00 00 
  802ff4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ffb:	00 00 00 
  802ffe:	66 90                	xchg   %ax,%ax
