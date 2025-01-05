
obj/user/bounds:     file format elf64-x86-64


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
  80001e:	e8 3e 00 00 00       	call   800061 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* Test for UBSAN support - accessing array element with an out-of-borders index */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	48 83 ec 10          	sub    $0x10,%rsp
    int a[4] = {0};
    /* Trying to print the value of the fifth element of the array (which causes undefined behavior).
     * The "cprintf" function is sanitized by UBSAN because lib/Makefrag accesses the USER_SAN_CFLAGS variable.
     * The access operator ([]) is not used because it will trigger -Warray-bounds option of Clang,
     * which will make this test unrunnable because of -Werror flag which is specified in GNUmakefile. */
    cprintf("%d\n", *(a + 5));
  800031:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  800038:	00 
  800039:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800040:	00 
  800041:	8b 75 04             	mov    0x4(%rbp),%esi
  800044:	48 bf 00 30 80 00 00 	movabs $0x803000,%rdi
  80004b:	00 00 00 
  80004e:	b8 00 00 00 00       	mov    $0x0,%eax
  800053:	48 ba ef 01 80 00 00 	movabs $0x8001ef,%rdx
  80005a:	00 00 00 
  80005d:	ff d2                	call   *%rdx
}
  80005f:	c9                   	leave
  800060:	c3                   	ret

0000000000800061 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800061:	f3 0f 1e fa          	endbr64
  800065:	55                   	push   %rbp
  800066:	48 89 e5             	mov    %rsp,%rbp
  800069:	41 56                	push   %r14
  80006b:	41 55                	push   %r13
  80006d:	41 54                	push   %r12
  80006f:	53                   	push   %rbx
  800070:	41 89 fd             	mov    %edi,%r13d
  800073:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800076:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80007d:	00 00 00 
  800080:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800087:	00 00 00 
  80008a:	48 39 c2             	cmp    %rax,%rdx
  80008d:	73 17                	jae    8000a6 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80008f:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800092:	49 89 c4             	mov    %rax,%r12
  800095:	48 83 c3 08          	add    $0x8,%rbx
  800099:	b8 00 00 00 00       	mov    $0x0,%eax
  80009e:	ff 53 f8             	call   *-0x8(%rbx)
  8000a1:	4c 39 e3             	cmp    %r12,%rbx
  8000a4:	72 ef                	jb     800095 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8000a6:	48 b8 6d 10 80 00 00 	movabs $0x80106d,%rax
  8000ad:	00 00 00 
  8000b0:	ff d0                	call   *%rax
  8000b2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b7:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000bb:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000bf:	48 c1 e0 04          	shl    $0x4,%rax
  8000c3:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000ca:	00 00 00 
  8000cd:	48 01 d0             	add    %rdx,%rax
  8000d0:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000d7:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000da:	45 85 ed             	test   %r13d,%r13d
  8000dd:	7e 0d                	jle    8000ec <libmain+0x8b>
  8000df:	49 8b 06             	mov    (%r14),%rax
  8000e2:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000e9:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000ec:	4c 89 f6             	mov    %r14,%rsi
  8000ef:	44 89 ef             	mov    %r13d,%edi
  8000f2:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000f9:	00 00 00 
  8000fc:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000fe:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  800105:	00 00 00 
  800108:	ff d0                	call   *%rax
#endif
}
  80010a:	5b                   	pop    %rbx
  80010b:	41 5c                	pop    %r12
  80010d:	41 5d                	pop    %r13
  80010f:	41 5e                	pop    %r14
  800111:	5d                   	pop    %rbp
  800112:	c3                   	ret

0000000000800113 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800113:	f3 0f 1e fa          	endbr64
  800117:	55                   	push   %rbp
  800118:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80011b:	48 b8 43 17 80 00 00 	movabs $0x801743,%rax
  800122:	00 00 00 
  800125:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800127:	bf 00 00 00 00       	mov    $0x0,%edi
  80012c:	48 b8 fe 0f 80 00 00 	movabs $0x800ffe,%rax
  800133:	00 00 00 
  800136:	ff d0                	call   *%rax
}
  800138:	5d                   	pop    %rbp
  800139:	c3                   	ret

000000000080013a <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80013a:	f3 0f 1e fa          	endbr64
  80013e:	55                   	push   %rbp
  80013f:	48 89 e5             	mov    %rsp,%rbp
  800142:	53                   	push   %rbx
  800143:	48 83 ec 08          	sub    $0x8,%rsp
  800147:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80014a:	8b 06                	mov    (%rsi),%eax
  80014c:	8d 50 01             	lea    0x1(%rax),%edx
  80014f:	89 16                	mov    %edx,(%rsi)
  800151:	48 98                	cltq
  800153:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800158:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80015e:	74 0a                	je     80016a <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800160:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800164:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800168:	c9                   	leave
  800169:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80016a:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80016e:	be ff 00 00 00       	mov    $0xff,%esi
  800173:	48 b8 98 0f 80 00 00 	movabs $0x800f98,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	call   *%rax
        state->offset = 0;
  80017f:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800185:	eb d9                	jmp    800160 <putch+0x26>

0000000000800187 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800187:	f3 0f 1e fa          	endbr64
  80018b:	55                   	push   %rbp
  80018c:	48 89 e5             	mov    %rsp,%rbp
  80018f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800196:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800199:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8001a0:	b9 21 00 00 00       	mov    $0x21,%ecx
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001aa:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8001ad:	48 89 f1             	mov    %rsi,%rcx
  8001b0:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8001b7:	48 bf 3a 01 80 00 00 	movabs $0x80013a,%rdi
  8001be:	00 00 00 
  8001c1:	48 b8 4f 03 80 00 00 	movabs $0x80034f,%rax
  8001c8:	00 00 00 
  8001cb:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8001cd:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8001d4:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8001db:	48 b8 98 0f 80 00 00 	movabs $0x800f98,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	call   *%rax

    return state.count;
}
  8001e7:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8001ed:	c9                   	leave
  8001ee:	c3                   	ret

00000000008001ef <cprintf>:

int
cprintf(const char *fmt, ...) {
  8001ef:	f3 0f 1e fa          	endbr64
  8001f3:	55                   	push   %rbp
  8001f4:	48 89 e5             	mov    %rsp,%rbp
  8001f7:	48 83 ec 50          	sub    $0x50,%rsp
  8001fb:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8001ff:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800203:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800207:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80020b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  80020f:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800216:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80021a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80021e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800222:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800226:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80022a:	48 b8 87 01 80 00 00 	movabs $0x800187,%rax
  800231:	00 00 00 
  800234:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800236:	c9                   	leave
  800237:	c3                   	ret

0000000000800238 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800238:	f3 0f 1e fa          	endbr64
  80023c:	55                   	push   %rbp
  80023d:	48 89 e5             	mov    %rsp,%rbp
  800240:	41 57                	push   %r15
  800242:	41 56                	push   %r14
  800244:	41 55                	push   %r13
  800246:	41 54                	push   %r12
  800248:	53                   	push   %rbx
  800249:	48 83 ec 18          	sub    $0x18,%rsp
  80024d:	49 89 fc             	mov    %rdi,%r12
  800250:	49 89 f5             	mov    %rsi,%r13
  800253:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800257:	8b 45 10             	mov    0x10(%rbp),%eax
  80025a:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80025d:	41 89 cf             	mov    %ecx,%r15d
  800260:	4c 39 fa             	cmp    %r15,%rdx
  800263:	73 5b                	jae    8002c0 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800265:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800269:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80026d:	85 db                	test   %ebx,%ebx
  80026f:	7e 0e                	jle    80027f <print_num+0x47>
            putch(padc, put_arg);
  800271:	4c 89 ee             	mov    %r13,%rsi
  800274:	44 89 f7             	mov    %r14d,%edi
  800277:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80027a:	83 eb 01             	sub    $0x1,%ebx
  80027d:	75 f2                	jne    800271 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  80027f:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800283:	48 b9 1f 30 80 00 00 	movabs $0x80301f,%rcx
  80028a:	00 00 00 
  80028d:	48 b8 0e 30 80 00 00 	movabs $0x80300e,%rax
  800294:	00 00 00 
  800297:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80029b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80029f:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a4:	49 f7 f7             	div    %r15
  8002a7:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8002ab:	4c 89 ee             	mov    %r13,%rsi
  8002ae:	41 ff d4             	call   *%r12
}
  8002b1:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8002b5:	5b                   	pop    %rbx
  8002b6:	41 5c                	pop    %r12
  8002b8:	41 5d                	pop    %r13
  8002ba:	41 5e                	pop    %r14
  8002bc:	41 5f                	pop    %r15
  8002be:	5d                   	pop    %rbp
  8002bf:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8002c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c9:	49 f7 f7             	div    %r15
  8002cc:	48 83 ec 08          	sub    $0x8,%rsp
  8002d0:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8002d4:	52                   	push   %rdx
  8002d5:	45 0f be c9          	movsbl %r9b,%r9d
  8002d9:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8002dd:	48 89 c2             	mov    %rax,%rdx
  8002e0:	48 b8 38 02 80 00 00 	movabs $0x800238,%rax
  8002e7:	00 00 00 
  8002ea:	ff d0                	call   *%rax
  8002ec:	48 83 c4 10          	add    $0x10,%rsp
  8002f0:	eb 8d                	jmp    80027f <print_num+0x47>

00000000008002f2 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8002f2:	f3 0f 1e fa          	endbr64
    state->count++;
  8002f6:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8002fa:	48 8b 06             	mov    (%rsi),%rax
  8002fd:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800301:	73 0a                	jae    80030d <sprintputch+0x1b>
        *state->start++ = ch;
  800303:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800307:	48 89 16             	mov    %rdx,(%rsi)
  80030a:	40 88 38             	mov    %dil,(%rax)
    }
}
  80030d:	c3                   	ret

000000000080030e <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80030e:	f3 0f 1e fa          	endbr64
  800312:	55                   	push   %rbp
  800313:	48 89 e5             	mov    %rsp,%rbp
  800316:	48 83 ec 50          	sub    $0x50,%rsp
  80031a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80031e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800322:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800326:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80032d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800331:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800335:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800339:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80033d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800341:	48 b8 4f 03 80 00 00 	movabs $0x80034f,%rax
  800348:	00 00 00 
  80034b:	ff d0                	call   *%rax
}
  80034d:	c9                   	leave
  80034e:	c3                   	ret

000000000080034f <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80034f:	f3 0f 1e fa          	endbr64
  800353:	55                   	push   %rbp
  800354:	48 89 e5             	mov    %rsp,%rbp
  800357:	41 57                	push   %r15
  800359:	41 56                	push   %r14
  80035b:	41 55                	push   %r13
  80035d:	41 54                	push   %r12
  80035f:	53                   	push   %rbx
  800360:	48 83 ec 38          	sub    $0x38,%rsp
  800364:	49 89 fe             	mov    %rdi,%r14
  800367:	49 89 f5             	mov    %rsi,%r13
  80036a:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  80036d:	48 8b 01             	mov    (%rcx),%rax
  800370:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800374:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800378:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80037c:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800380:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800384:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800388:	0f b6 3b             	movzbl (%rbx),%edi
  80038b:	40 80 ff 25          	cmp    $0x25,%dil
  80038f:	74 18                	je     8003a9 <vprintfmt+0x5a>
            if (!ch) return;
  800391:	40 84 ff             	test   %dil,%dil
  800394:	0f 84 b2 06 00 00    	je     800a4c <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80039a:	40 0f b6 ff          	movzbl %dil,%edi
  80039e:	4c 89 ee             	mov    %r13,%rsi
  8003a1:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8003a4:	4c 89 e3             	mov    %r12,%rbx
  8003a7:	eb db                	jmp    800384 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8003a9:	be 00 00 00 00       	mov    $0x0,%esi
  8003ae:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8003b2:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8003b7:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8003bd:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8003c4:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8003c8:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8003cd:	41 0f b6 04 24       	movzbl (%r12),%eax
  8003d2:	88 45 a0             	mov    %al,-0x60(%rbp)
  8003d5:	83 e8 23             	sub    $0x23,%eax
  8003d8:	3c 57                	cmp    $0x57,%al
  8003da:	0f 87 52 06 00 00    	ja     800a32 <vprintfmt+0x6e3>
  8003e0:	0f b6 c0             	movzbl %al,%eax
  8003e3:	48 b9 60 32 80 00 00 	movabs $0x803260,%rcx
  8003ea:	00 00 00 
  8003ed:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8003f1:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8003f4:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8003f8:	eb ce                	jmp    8003c8 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8003fa:	49 89 dc             	mov    %rbx,%r12
  8003fd:	be 01 00 00 00       	mov    $0x1,%esi
  800402:	eb c4                	jmp    8003c8 <vprintfmt+0x79>
            padc = ch;
  800404:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800408:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80040b:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80040e:	eb b8                	jmp    8003c8 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800410:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800413:	83 f8 2f             	cmp    $0x2f,%eax
  800416:	77 24                	ja     80043c <vprintfmt+0xed>
  800418:	89 c1                	mov    %eax,%ecx
  80041a:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  80041e:	83 c0 08             	add    $0x8,%eax
  800421:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800424:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800427:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  80042a:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80042e:	79 98                	jns    8003c8 <vprintfmt+0x79>
                width = precision;
  800430:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800434:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80043a:	eb 8c                	jmp    8003c8 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80043c:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800440:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800444:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800448:	eb da                	jmp    800424 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80044a:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  80044f:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800453:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800459:	3c 39                	cmp    $0x39,%al
  80045b:	77 1c                	ja     800479 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  80045d:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800461:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800465:	0f b6 c0             	movzbl %al,%eax
  800468:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80046d:	0f b6 03             	movzbl (%rbx),%eax
  800470:	3c 39                	cmp    $0x39,%al
  800472:	76 e9                	jbe    80045d <vprintfmt+0x10e>
        process_precision:
  800474:	49 89 dc             	mov    %rbx,%r12
  800477:	eb b1                	jmp    80042a <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800479:	49 89 dc             	mov    %rbx,%r12
  80047c:	eb ac                	jmp    80042a <vprintfmt+0xdb>
            width = MAX(0, width);
  80047e:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800481:	85 c9                	test   %ecx,%ecx
  800483:	b8 00 00 00 00       	mov    $0x0,%eax
  800488:	0f 49 c1             	cmovns %ecx,%eax
  80048b:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  80048e:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800491:	e9 32 ff ff ff       	jmp    8003c8 <vprintfmt+0x79>
            lflag++;
  800496:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800499:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80049c:	e9 27 ff ff ff       	jmp    8003c8 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8004a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004a4:	83 f8 2f             	cmp    $0x2f,%eax
  8004a7:	77 19                	ja     8004c2 <vprintfmt+0x173>
  8004a9:	89 c2                	mov    %eax,%edx
  8004ab:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8004af:	83 c0 08             	add    $0x8,%eax
  8004b2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004b5:	8b 3a                	mov    (%rdx),%edi
  8004b7:	4c 89 ee             	mov    %r13,%rsi
  8004ba:	41 ff d6             	call   *%r14
            break;
  8004bd:	e9 c2 fe ff ff       	jmp    800384 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8004c2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004c6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8004ca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004ce:	eb e5                	jmp    8004b5 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8004d0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004d3:	83 f8 2f             	cmp    $0x2f,%eax
  8004d6:	77 5a                	ja     800532 <vprintfmt+0x1e3>
  8004d8:	89 c2                	mov    %eax,%edx
  8004da:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8004de:	83 c0 08             	add    $0x8,%eax
  8004e1:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8004e4:	8b 02                	mov    (%rdx),%eax
  8004e6:	89 c1                	mov    %eax,%ecx
  8004e8:	f7 d9                	neg    %ecx
  8004ea:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8004ed:	83 f9 13             	cmp    $0x13,%ecx
  8004f0:	7f 4e                	jg     800540 <vprintfmt+0x1f1>
  8004f2:	48 63 c1             	movslq %ecx,%rax
  8004f5:	48 ba 20 35 80 00 00 	movabs $0x803520,%rdx
  8004fc:	00 00 00 
  8004ff:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800503:	48 85 c0             	test   %rax,%rax
  800506:	74 38                	je     800540 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  800508:	48 89 c1             	mov    %rax,%rcx
  80050b:	48 ba 13 32 80 00 00 	movabs $0x803213,%rdx
  800512:	00 00 00 
  800515:	4c 89 ee             	mov    %r13,%rsi
  800518:	4c 89 f7             	mov    %r14,%rdi
  80051b:	b8 00 00 00 00       	mov    $0x0,%eax
  800520:	49 b8 0e 03 80 00 00 	movabs $0x80030e,%r8
  800527:	00 00 00 
  80052a:	41 ff d0             	call   *%r8
  80052d:	e9 52 fe ff ff       	jmp    800384 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800532:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800536:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80053a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80053e:	eb a4                	jmp    8004e4 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800540:	48 ba 37 30 80 00 00 	movabs $0x803037,%rdx
  800547:	00 00 00 
  80054a:	4c 89 ee             	mov    %r13,%rsi
  80054d:	4c 89 f7             	mov    %r14,%rdi
  800550:	b8 00 00 00 00       	mov    $0x0,%eax
  800555:	49 b8 0e 03 80 00 00 	movabs $0x80030e,%r8
  80055c:	00 00 00 
  80055f:	41 ff d0             	call   *%r8
  800562:	e9 1d fe ff ff       	jmp    800384 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800567:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80056a:	83 f8 2f             	cmp    $0x2f,%eax
  80056d:	77 6c                	ja     8005db <vprintfmt+0x28c>
  80056f:	89 c2                	mov    %eax,%edx
  800571:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800575:	83 c0 08             	add    $0x8,%eax
  800578:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80057b:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  80057e:	48 85 d2             	test   %rdx,%rdx
  800581:	48 b8 30 30 80 00 00 	movabs $0x803030,%rax
  800588:	00 00 00 
  80058b:	48 0f 45 c2          	cmovne %rdx,%rax
  80058f:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800593:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800597:	7e 06                	jle    80059f <vprintfmt+0x250>
  800599:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  80059d:	75 4a                	jne    8005e9 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80059f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8005a3:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8005a7:	0f b6 00             	movzbl (%rax),%eax
  8005aa:	84 c0                	test   %al,%al
  8005ac:	0f 85 9a 00 00 00    	jne    80064c <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8005b2:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005b5:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8005b9:	85 c0                	test   %eax,%eax
  8005bb:	0f 8e c3 fd ff ff    	jle    800384 <vprintfmt+0x35>
  8005c1:	4c 89 ee             	mov    %r13,%rsi
  8005c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8005c9:	41 ff d6             	call   *%r14
  8005cc:	41 83 ec 01          	sub    $0x1,%r12d
  8005d0:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8005d4:	75 eb                	jne    8005c1 <vprintfmt+0x272>
  8005d6:	e9 a9 fd ff ff       	jmp    800384 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8005db:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005df:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005e3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005e7:	eb 92                	jmp    80057b <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8005e9:	49 63 f7             	movslq %r15d,%rsi
  8005ec:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8005f0:	48 b8 12 0b 80 00 00 	movabs $0x800b12,%rax
  8005f7:	00 00 00 
  8005fa:	ff d0                	call   *%rax
  8005fc:	48 89 c2             	mov    %rax,%rdx
  8005ff:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800602:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800604:	8d 70 ff             	lea    -0x1(%rax),%esi
  800607:	89 75 ac             	mov    %esi,-0x54(%rbp)
  80060a:	85 c0                	test   %eax,%eax
  80060c:	7e 91                	jle    80059f <vprintfmt+0x250>
  80060e:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800613:	4c 89 ee             	mov    %r13,%rsi
  800616:	44 89 e7             	mov    %r12d,%edi
  800619:	41 ff d6             	call   *%r14
  80061c:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800620:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800623:	83 f8 ff             	cmp    $0xffffffff,%eax
  800626:	75 eb                	jne    800613 <vprintfmt+0x2c4>
  800628:	e9 72 ff ff ff       	jmp    80059f <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80062d:	0f b6 f8             	movzbl %al,%edi
  800630:	4c 89 ee             	mov    %r13,%rsi
  800633:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800636:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80063a:	49 83 c4 01          	add    $0x1,%r12
  80063e:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800644:	84 c0                	test   %al,%al
  800646:	0f 84 66 ff ff ff    	je     8005b2 <vprintfmt+0x263>
  80064c:	45 85 ff             	test   %r15d,%r15d
  80064f:	78 0a                	js     80065b <vprintfmt+0x30c>
  800651:	41 83 ef 01          	sub    $0x1,%r15d
  800655:	0f 88 57 ff ff ff    	js     8005b2 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80065b:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  80065f:	74 cc                	je     80062d <vprintfmt+0x2de>
  800661:	8d 50 e0             	lea    -0x20(%rax),%edx
  800664:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800669:	80 fa 5e             	cmp    $0x5e,%dl
  80066c:	77 c2                	ja     800630 <vprintfmt+0x2e1>
  80066e:	eb bd                	jmp    80062d <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800670:	40 84 f6             	test   %sil,%sil
  800673:	75 26                	jne    80069b <vprintfmt+0x34c>
    switch (lflag) {
  800675:	85 d2                	test   %edx,%edx
  800677:	74 59                	je     8006d2 <vprintfmt+0x383>
  800679:	83 fa 01             	cmp    $0x1,%edx
  80067c:	74 7b                	je     8006f9 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  80067e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800681:	83 f8 2f             	cmp    $0x2f,%eax
  800684:	0f 87 96 00 00 00    	ja     800720 <vprintfmt+0x3d1>
  80068a:	89 c2                	mov    %eax,%edx
  80068c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800690:	83 c0 08             	add    $0x8,%eax
  800693:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800696:	4c 8b 22             	mov    (%rdx),%r12
  800699:	eb 17                	jmp    8006b2 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  80069b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80069e:	83 f8 2f             	cmp    $0x2f,%eax
  8006a1:	77 21                	ja     8006c4 <vprintfmt+0x375>
  8006a3:	89 c2                	mov    %eax,%edx
  8006a5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006a9:	83 c0 08             	add    $0x8,%eax
  8006ac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006af:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8006b2:	4d 85 e4             	test   %r12,%r12
  8006b5:	78 7a                	js     800731 <vprintfmt+0x3e2>
            num = i;
  8006b7:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8006ba:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006bf:	e9 50 02 00 00       	jmp    800914 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8006c4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006c8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006cc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006d0:	eb dd                	jmp    8006af <vprintfmt+0x360>
        return va_arg(*ap, int);
  8006d2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006d5:	83 f8 2f             	cmp    $0x2f,%eax
  8006d8:	77 11                	ja     8006eb <vprintfmt+0x39c>
  8006da:	89 c2                	mov    %eax,%edx
  8006dc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006e0:	83 c0 08             	add    $0x8,%eax
  8006e3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006e6:	4c 63 22             	movslq (%rdx),%r12
  8006e9:	eb c7                	jmp    8006b2 <vprintfmt+0x363>
  8006eb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006ef:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006f3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006f7:	eb ed                	jmp    8006e6 <vprintfmt+0x397>
        return va_arg(*ap, long);
  8006f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006fc:	83 f8 2f             	cmp    $0x2f,%eax
  8006ff:	77 11                	ja     800712 <vprintfmt+0x3c3>
  800701:	89 c2                	mov    %eax,%edx
  800703:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800707:	83 c0 08             	add    $0x8,%eax
  80070a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80070d:	4c 8b 22             	mov    (%rdx),%r12
  800710:	eb a0                	jmp    8006b2 <vprintfmt+0x363>
  800712:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800716:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80071a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80071e:	eb ed                	jmp    80070d <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800720:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800724:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800728:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80072c:	e9 65 ff ff ff       	jmp    800696 <vprintfmt+0x347>
                putch('-', put_arg);
  800731:	4c 89 ee             	mov    %r13,%rsi
  800734:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800739:	41 ff d6             	call   *%r14
                i = -i;
  80073c:	49 f7 dc             	neg    %r12
  80073f:	e9 73 ff ff ff       	jmp    8006b7 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800744:	40 84 f6             	test   %sil,%sil
  800747:	75 32                	jne    80077b <vprintfmt+0x42c>
    switch (lflag) {
  800749:	85 d2                	test   %edx,%edx
  80074b:	74 5d                	je     8007aa <vprintfmt+0x45b>
  80074d:	83 fa 01             	cmp    $0x1,%edx
  800750:	0f 84 82 00 00 00    	je     8007d8 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800756:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800759:	83 f8 2f             	cmp    $0x2f,%eax
  80075c:	0f 87 a5 00 00 00    	ja     800807 <vprintfmt+0x4b8>
  800762:	89 c2                	mov    %eax,%edx
  800764:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800768:	83 c0 08             	add    $0x8,%eax
  80076b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80076e:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800771:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800776:	e9 99 01 00 00       	jmp    800914 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80077b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80077e:	83 f8 2f             	cmp    $0x2f,%eax
  800781:	77 19                	ja     80079c <vprintfmt+0x44d>
  800783:	89 c2                	mov    %eax,%edx
  800785:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800789:	83 c0 08             	add    $0x8,%eax
  80078c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80078f:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800792:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800797:	e9 78 01 00 00       	jmp    800914 <vprintfmt+0x5c5>
  80079c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007a0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007a8:	eb e5                	jmp    80078f <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8007aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ad:	83 f8 2f             	cmp    $0x2f,%eax
  8007b0:	77 18                	ja     8007ca <vprintfmt+0x47b>
  8007b2:	89 c2                	mov    %eax,%edx
  8007b4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007b8:	83 c0 08             	add    $0x8,%eax
  8007bb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007be:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8007c0:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8007c5:	e9 4a 01 00 00       	jmp    800914 <vprintfmt+0x5c5>
  8007ca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007ce:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007d2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007d6:	eb e6                	jmp    8007be <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8007d8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007db:	83 f8 2f             	cmp    $0x2f,%eax
  8007de:	77 19                	ja     8007f9 <vprintfmt+0x4aa>
  8007e0:	89 c2                	mov    %eax,%edx
  8007e2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007e6:	83 c0 08             	add    $0x8,%eax
  8007e9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007ec:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8007ef:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8007f4:	e9 1b 01 00 00       	jmp    800914 <vprintfmt+0x5c5>
  8007f9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007fd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800801:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800805:	eb e5                	jmp    8007ec <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800807:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80080b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80080f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800813:	e9 56 ff ff ff       	jmp    80076e <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800818:	40 84 f6             	test   %sil,%sil
  80081b:	75 2e                	jne    80084b <vprintfmt+0x4fc>
    switch (lflag) {
  80081d:	85 d2                	test   %edx,%edx
  80081f:	74 59                	je     80087a <vprintfmt+0x52b>
  800821:	83 fa 01             	cmp    $0x1,%edx
  800824:	74 7f                	je     8008a5 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800826:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800829:	83 f8 2f             	cmp    $0x2f,%eax
  80082c:	0f 87 9f 00 00 00    	ja     8008d1 <vprintfmt+0x582>
  800832:	89 c2                	mov    %eax,%edx
  800834:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800838:	83 c0 08             	add    $0x8,%eax
  80083b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80083e:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800841:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800846:	e9 c9 00 00 00       	jmp    800914 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80084b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80084e:	83 f8 2f             	cmp    $0x2f,%eax
  800851:	77 19                	ja     80086c <vprintfmt+0x51d>
  800853:	89 c2                	mov    %eax,%edx
  800855:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800859:	83 c0 08             	add    $0x8,%eax
  80085c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80085f:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800862:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800867:	e9 a8 00 00 00       	jmp    800914 <vprintfmt+0x5c5>
  80086c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800870:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800874:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800878:	eb e5                	jmp    80085f <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  80087a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087d:	83 f8 2f             	cmp    $0x2f,%eax
  800880:	77 15                	ja     800897 <vprintfmt+0x548>
  800882:	89 c2                	mov    %eax,%edx
  800884:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800888:	83 c0 08             	add    $0x8,%eax
  80088b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80088e:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800890:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800895:	eb 7d                	jmp    800914 <vprintfmt+0x5c5>
  800897:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80089b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80089f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008a3:	eb e9                	jmp    80088e <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8008a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a8:	83 f8 2f             	cmp    $0x2f,%eax
  8008ab:	77 16                	ja     8008c3 <vprintfmt+0x574>
  8008ad:	89 c2                	mov    %eax,%edx
  8008af:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008b3:	83 c0 08             	add    $0x8,%eax
  8008b6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008b9:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8008bc:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008c1:	eb 51                	jmp    800914 <vprintfmt+0x5c5>
  8008c3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008cb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008cf:	eb e8                	jmp    8008b9 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8008d1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008d5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008d9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008dd:	e9 5c ff ff ff       	jmp    80083e <vprintfmt+0x4ef>
            putch('0', put_arg);
  8008e2:	4c 89 ee             	mov    %r13,%rsi
  8008e5:	bf 30 00 00 00       	mov    $0x30,%edi
  8008ea:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  8008ed:	4c 89 ee             	mov    %r13,%rsi
  8008f0:	bf 78 00 00 00       	mov    $0x78,%edi
  8008f5:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  8008f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008fb:	83 f8 2f             	cmp    $0x2f,%eax
  8008fe:	77 47                	ja     800947 <vprintfmt+0x5f8>
  800900:	89 c2                	mov    %eax,%edx
  800902:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800906:	83 c0 08             	add    $0x8,%eax
  800909:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80090c:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80090f:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800914:	48 83 ec 08          	sub    $0x8,%rsp
  800918:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  80091c:	0f 94 c0             	sete   %al
  80091f:	0f b6 c0             	movzbl %al,%eax
  800922:	50                   	push   %rax
  800923:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800928:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80092c:	4c 89 ee             	mov    %r13,%rsi
  80092f:	4c 89 f7             	mov    %r14,%rdi
  800932:	48 b8 38 02 80 00 00 	movabs $0x800238,%rax
  800939:	00 00 00 
  80093c:	ff d0                	call   *%rax
            break;
  80093e:	48 83 c4 10          	add    $0x10,%rsp
  800942:	e9 3d fa ff ff       	jmp    800384 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800947:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80094b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80094f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800953:	eb b7                	jmp    80090c <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800955:	40 84 f6             	test   %sil,%sil
  800958:	75 2b                	jne    800985 <vprintfmt+0x636>
    switch (lflag) {
  80095a:	85 d2                	test   %edx,%edx
  80095c:	74 56                	je     8009b4 <vprintfmt+0x665>
  80095e:	83 fa 01             	cmp    $0x1,%edx
  800961:	74 7f                	je     8009e2 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800963:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800966:	83 f8 2f             	cmp    $0x2f,%eax
  800969:	0f 87 a2 00 00 00    	ja     800a11 <vprintfmt+0x6c2>
  80096f:	89 c2                	mov    %eax,%edx
  800971:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800975:	83 c0 08             	add    $0x8,%eax
  800978:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80097b:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80097e:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800983:	eb 8f                	jmp    800914 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800985:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800988:	83 f8 2f             	cmp    $0x2f,%eax
  80098b:	77 19                	ja     8009a6 <vprintfmt+0x657>
  80098d:	89 c2                	mov    %eax,%edx
  80098f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800993:	83 c0 08             	add    $0x8,%eax
  800996:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800999:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80099c:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009a1:	e9 6e ff ff ff       	jmp    800914 <vprintfmt+0x5c5>
  8009a6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009aa:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009ae:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009b2:	eb e5                	jmp    800999 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8009b4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b7:	83 f8 2f             	cmp    $0x2f,%eax
  8009ba:	77 18                	ja     8009d4 <vprintfmt+0x685>
  8009bc:	89 c2                	mov    %eax,%edx
  8009be:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009c2:	83 c0 08             	add    $0x8,%eax
  8009c5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009c8:	8b 12                	mov    (%rdx),%edx
            base = 16;
  8009ca:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8009cf:	e9 40 ff ff ff       	jmp    800914 <vprintfmt+0x5c5>
  8009d4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009d8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009dc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009e0:	eb e6                	jmp    8009c8 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  8009e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e5:	83 f8 2f             	cmp    $0x2f,%eax
  8009e8:	77 19                	ja     800a03 <vprintfmt+0x6b4>
  8009ea:	89 c2                	mov    %eax,%edx
  8009ec:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009f0:	83 c0 08             	add    $0x8,%eax
  8009f3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009f6:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009f9:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8009fe:	e9 11 ff ff ff       	jmp    800914 <vprintfmt+0x5c5>
  800a03:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a07:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a0b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a0f:	eb e5                	jmp    8009f6 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800a11:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a15:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a19:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a1d:	e9 59 ff ff ff       	jmp    80097b <vprintfmt+0x62c>
            putch(ch, put_arg);
  800a22:	4c 89 ee             	mov    %r13,%rsi
  800a25:	bf 25 00 00 00       	mov    $0x25,%edi
  800a2a:	41 ff d6             	call   *%r14
            break;
  800a2d:	e9 52 f9 ff ff       	jmp    800384 <vprintfmt+0x35>
            putch('%', put_arg);
  800a32:	4c 89 ee             	mov    %r13,%rsi
  800a35:	bf 25 00 00 00       	mov    $0x25,%edi
  800a3a:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800a3d:	48 83 eb 01          	sub    $0x1,%rbx
  800a41:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800a45:	75 f6                	jne    800a3d <vprintfmt+0x6ee>
  800a47:	e9 38 f9 ff ff       	jmp    800384 <vprintfmt+0x35>
}
  800a4c:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a50:	5b                   	pop    %rbx
  800a51:	41 5c                	pop    %r12
  800a53:	41 5d                	pop    %r13
  800a55:	41 5e                	pop    %r14
  800a57:	41 5f                	pop    %r15
  800a59:	5d                   	pop    %rbp
  800a5a:	c3                   	ret

0000000000800a5b <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a5b:	f3 0f 1e fa          	endbr64
  800a5f:	55                   	push   %rbp
  800a60:	48 89 e5             	mov    %rsp,%rbp
  800a63:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800a67:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a6b:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800a70:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800a74:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800a7b:	48 85 ff             	test   %rdi,%rdi
  800a7e:	74 2b                	je     800aab <vsnprintf+0x50>
  800a80:	48 85 f6             	test   %rsi,%rsi
  800a83:	74 26                	je     800aab <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800a85:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800a89:	48 bf f2 02 80 00 00 	movabs $0x8002f2,%rdi
  800a90:	00 00 00 
  800a93:	48 b8 4f 03 80 00 00 	movabs $0x80034f,%rax
  800a9a:	00 00 00 
  800a9d:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800a9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa3:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800aa6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800aa9:	c9                   	leave
  800aaa:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800aab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ab0:	eb f7                	jmp    800aa9 <vsnprintf+0x4e>

0000000000800ab2 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800ab2:	f3 0f 1e fa          	endbr64
  800ab6:	55                   	push   %rbp
  800ab7:	48 89 e5             	mov    %rsp,%rbp
  800aba:	48 83 ec 50          	sub    $0x50,%rsp
  800abe:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800ac2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800ac6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800aca:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800ad1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ad5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800add:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800ae1:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ae5:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800aec:	00 00 00 
  800aef:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800af1:	c9                   	leave
  800af2:	c3                   	ret

0000000000800af3 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800af3:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800af7:	80 3f 00             	cmpb   $0x0,(%rdi)
  800afa:	74 10                	je     800b0c <strlen+0x19>
    size_t n = 0;
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800b01:	48 83 c0 01          	add    $0x1,%rax
  800b05:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b09:	75 f6                	jne    800b01 <strlen+0xe>
  800b0b:	c3                   	ret
    size_t n = 0;
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800b11:	c3                   	ret

0000000000800b12 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800b12:	f3 0f 1e fa          	endbr64
  800b16:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800b19:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800b1e:	48 85 f6             	test   %rsi,%rsi
  800b21:	74 10                	je     800b33 <strnlen+0x21>
  800b23:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800b27:	74 0b                	je     800b34 <strnlen+0x22>
  800b29:	48 83 c2 01          	add    $0x1,%rdx
  800b2d:	48 39 d0             	cmp    %rdx,%rax
  800b30:	75 f1                	jne    800b23 <strnlen+0x11>
  800b32:	c3                   	ret
  800b33:	c3                   	ret
  800b34:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800b37:	c3                   	ret

0000000000800b38 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800b38:	f3 0f 1e fa          	endbr64
  800b3c:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b44:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800b48:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800b4b:	48 83 c2 01          	add    $0x1,%rdx
  800b4f:	84 c9                	test   %cl,%cl
  800b51:	75 f1                	jne    800b44 <strcpy+0xc>
        ;
    return res;
}
  800b53:	c3                   	ret

0000000000800b54 <strcat>:

char *
strcat(char *dst, const char *src) {
  800b54:	f3 0f 1e fa          	endbr64
  800b58:	55                   	push   %rbp
  800b59:	48 89 e5             	mov    %rsp,%rbp
  800b5c:	41 54                	push   %r12
  800b5e:	53                   	push   %rbx
  800b5f:	48 89 fb             	mov    %rdi,%rbx
  800b62:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800b65:	48 b8 f3 0a 80 00 00 	movabs $0x800af3,%rax
  800b6c:	00 00 00 
  800b6f:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800b71:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800b75:	4c 89 e6             	mov    %r12,%rsi
  800b78:	48 b8 38 0b 80 00 00 	movabs $0x800b38,%rax
  800b7f:	00 00 00 
  800b82:	ff d0                	call   *%rax
    return dst;
}
  800b84:	48 89 d8             	mov    %rbx,%rax
  800b87:	5b                   	pop    %rbx
  800b88:	41 5c                	pop    %r12
  800b8a:	5d                   	pop    %rbp
  800b8b:	c3                   	ret

0000000000800b8c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b8c:	f3 0f 1e fa          	endbr64
  800b90:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800b93:	48 85 d2             	test   %rdx,%rdx
  800b96:	74 1f                	je     800bb7 <strncpy+0x2b>
  800b98:	48 01 fa             	add    %rdi,%rdx
  800b9b:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800b9e:	48 83 c1 01          	add    $0x1,%rcx
  800ba2:	44 0f b6 06          	movzbl (%rsi),%r8d
  800ba6:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800baa:	41 80 f8 01          	cmp    $0x1,%r8b
  800bae:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800bb2:	48 39 ca             	cmp    %rcx,%rdx
  800bb5:	75 e7                	jne    800b9e <strncpy+0x12>
    }
    return ret;
}
  800bb7:	c3                   	ret

0000000000800bb8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800bb8:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800bbc:	48 89 f8             	mov    %rdi,%rax
  800bbf:	48 85 d2             	test   %rdx,%rdx
  800bc2:	74 24                	je     800be8 <strlcpy+0x30>
        while (--size > 0 && *src)
  800bc4:	48 83 ea 01          	sub    $0x1,%rdx
  800bc8:	74 1b                	je     800be5 <strlcpy+0x2d>
  800bca:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800bce:	0f b6 16             	movzbl (%rsi),%edx
  800bd1:	84 d2                	test   %dl,%dl
  800bd3:	74 10                	je     800be5 <strlcpy+0x2d>
            *dst++ = *src++;
  800bd5:	48 83 c6 01          	add    $0x1,%rsi
  800bd9:	48 83 c0 01          	add    $0x1,%rax
  800bdd:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800be0:	48 39 c8             	cmp    %rcx,%rax
  800be3:	75 e9                	jne    800bce <strlcpy+0x16>
        *dst = '\0';
  800be5:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800be8:	48 29 f8             	sub    %rdi,%rax
}
  800beb:	c3                   	ret

0000000000800bec <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800bec:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800bf0:	0f b6 07             	movzbl (%rdi),%eax
  800bf3:	84 c0                	test   %al,%al
  800bf5:	74 13                	je     800c0a <strcmp+0x1e>
  800bf7:	38 06                	cmp    %al,(%rsi)
  800bf9:	75 0f                	jne    800c0a <strcmp+0x1e>
  800bfb:	48 83 c7 01          	add    $0x1,%rdi
  800bff:	48 83 c6 01          	add    $0x1,%rsi
  800c03:	0f b6 07             	movzbl (%rdi),%eax
  800c06:	84 c0                	test   %al,%al
  800c08:	75 ed                	jne    800bf7 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800c0a:	0f b6 c0             	movzbl %al,%eax
  800c0d:	0f b6 16             	movzbl (%rsi),%edx
  800c10:	29 d0                	sub    %edx,%eax
}
  800c12:	c3                   	ret

0000000000800c13 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800c13:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800c17:	48 85 d2             	test   %rdx,%rdx
  800c1a:	74 1f                	je     800c3b <strncmp+0x28>
  800c1c:	0f b6 07             	movzbl (%rdi),%eax
  800c1f:	84 c0                	test   %al,%al
  800c21:	74 1e                	je     800c41 <strncmp+0x2e>
  800c23:	3a 06                	cmp    (%rsi),%al
  800c25:	75 1a                	jne    800c41 <strncmp+0x2e>
  800c27:	48 83 c7 01          	add    $0x1,%rdi
  800c2b:	48 83 c6 01          	add    $0x1,%rsi
  800c2f:	48 83 ea 01          	sub    $0x1,%rdx
  800c33:	75 e7                	jne    800c1c <strncmp+0x9>

    if (!n) return 0;
  800c35:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3a:	c3                   	ret
  800c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c40:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c41:	0f b6 07             	movzbl (%rdi),%eax
  800c44:	0f b6 16             	movzbl (%rsi),%edx
  800c47:	29 d0                	sub    %edx,%eax
}
  800c49:	c3                   	ret

0000000000800c4a <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800c4a:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800c4e:	0f b6 17             	movzbl (%rdi),%edx
  800c51:	84 d2                	test   %dl,%dl
  800c53:	74 18                	je     800c6d <strchr+0x23>
        if (*str == c) {
  800c55:	0f be d2             	movsbl %dl,%edx
  800c58:	39 f2                	cmp    %esi,%edx
  800c5a:	74 17                	je     800c73 <strchr+0x29>
    for (; *str; str++) {
  800c5c:	48 83 c7 01          	add    $0x1,%rdi
  800c60:	0f b6 17             	movzbl (%rdi),%edx
  800c63:	84 d2                	test   %dl,%dl
  800c65:	75 ee                	jne    800c55 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800c67:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6c:	c3                   	ret
  800c6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c72:	c3                   	ret
            return (char *)str;
  800c73:	48 89 f8             	mov    %rdi,%rax
}
  800c76:	c3                   	ret

0000000000800c77 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800c77:	f3 0f 1e fa          	endbr64
  800c7b:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800c7e:	0f b6 17             	movzbl (%rdi),%edx
  800c81:	84 d2                	test   %dl,%dl
  800c83:	74 13                	je     800c98 <strfind+0x21>
  800c85:	0f be d2             	movsbl %dl,%edx
  800c88:	39 f2                	cmp    %esi,%edx
  800c8a:	74 0b                	je     800c97 <strfind+0x20>
  800c8c:	48 83 c0 01          	add    $0x1,%rax
  800c90:	0f b6 10             	movzbl (%rax),%edx
  800c93:	84 d2                	test   %dl,%dl
  800c95:	75 ee                	jne    800c85 <strfind+0xe>
        ;
    return (char *)str;
}
  800c97:	c3                   	ret
  800c98:	c3                   	ret

0000000000800c99 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800c99:	f3 0f 1e fa          	endbr64
  800c9d:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800ca0:	48 89 f8             	mov    %rdi,%rax
  800ca3:	48 f7 d8             	neg    %rax
  800ca6:	83 e0 07             	and    $0x7,%eax
  800ca9:	49 89 d1             	mov    %rdx,%r9
  800cac:	49 29 c1             	sub    %rax,%r9
  800caf:	78 36                	js     800ce7 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800cb1:	40 0f b6 c6          	movzbl %sil,%eax
  800cb5:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800cbc:	01 01 01 
  800cbf:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800cc3:	40 f6 c7 07          	test   $0x7,%dil
  800cc7:	75 38                	jne    800d01 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800cc9:	4c 89 c9             	mov    %r9,%rcx
  800ccc:	48 c1 f9 03          	sar    $0x3,%rcx
  800cd0:	74 0c                	je     800cde <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800cd2:	fc                   	cld
  800cd3:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800cd6:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800cda:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800cde:	4d 85 c9             	test   %r9,%r9
  800ce1:	75 45                	jne    800d28 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800ce3:	4c 89 c0             	mov    %r8,%rax
  800ce6:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800ce7:	48 85 d2             	test   %rdx,%rdx
  800cea:	74 f7                	je     800ce3 <memset+0x4a>
  800cec:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800cef:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800cf2:	48 83 c0 01          	add    $0x1,%rax
  800cf6:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800cfa:	48 39 c2             	cmp    %rax,%rdx
  800cfd:	75 f3                	jne    800cf2 <memset+0x59>
  800cff:	eb e2                	jmp    800ce3 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800d01:	40 f6 c7 01          	test   $0x1,%dil
  800d05:	74 06                	je     800d0d <memset+0x74>
  800d07:	88 07                	mov    %al,(%rdi)
  800d09:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d0d:	40 f6 c7 02          	test   $0x2,%dil
  800d11:	74 07                	je     800d1a <memset+0x81>
  800d13:	66 89 07             	mov    %ax,(%rdi)
  800d16:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d1a:	40 f6 c7 04          	test   $0x4,%dil
  800d1e:	74 a9                	je     800cc9 <memset+0x30>
  800d20:	89 07                	mov    %eax,(%rdi)
  800d22:	48 83 c7 04          	add    $0x4,%rdi
  800d26:	eb a1                	jmp    800cc9 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d28:	41 f6 c1 04          	test   $0x4,%r9b
  800d2c:	74 1b                	je     800d49 <memset+0xb0>
  800d2e:	89 07                	mov    %eax,(%rdi)
  800d30:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d34:	41 f6 c1 02          	test   $0x2,%r9b
  800d38:	74 07                	je     800d41 <memset+0xa8>
  800d3a:	66 89 07             	mov    %ax,(%rdi)
  800d3d:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d41:	41 f6 c1 01          	test   $0x1,%r9b
  800d45:	74 9c                	je     800ce3 <memset+0x4a>
  800d47:	eb 06                	jmp    800d4f <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d49:	41 f6 c1 02          	test   $0x2,%r9b
  800d4d:	75 eb                	jne    800d3a <memset+0xa1>
        if (ni & 1) *ptr = k;
  800d4f:	88 07                	mov    %al,(%rdi)
  800d51:	eb 90                	jmp    800ce3 <memset+0x4a>

0000000000800d53 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d53:	f3 0f 1e fa          	endbr64
  800d57:	48 89 f8             	mov    %rdi,%rax
  800d5a:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d5d:	48 39 fe             	cmp    %rdi,%rsi
  800d60:	73 3b                	jae    800d9d <memmove+0x4a>
  800d62:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800d66:	48 39 d7             	cmp    %rdx,%rdi
  800d69:	73 32                	jae    800d9d <memmove+0x4a>
        s += n;
        d += n;
  800d6b:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d6f:	48 89 d6             	mov    %rdx,%rsi
  800d72:	48 09 fe             	or     %rdi,%rsi
  800d75:	48 09 ce             	or     %rcx,%rsi
  800d78:	40 f6 c6 07          	test   $0x7,%sil
  800d7c:	75 12                	jne    800d90 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800d7e:	48 83 ef 08          	sub    $0x8,%rdi
  800d82:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800d86:	48 c1 e9 03          	shr    $0x3,%rcx
  800d8a:	fd                   	std
  800d8b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800d8e:	fc                   	cld
  800d8f:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800d90:	48 83 ef 01          	sub    $0x1,%rdi
  800d94:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800d98:	fd                   	std
  800d99:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800d9b:	eb f1                	jmp    800d8e <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d9d:	48 89 f2             	mov    %rsi,%rdx
  800da0:	48 09 c2             	or     %rax,%rdx
  800da3:	48 09 ca             	or     %rcx,%rdx
  800da6:	f6 c2 07             	test   $0x7,%dl
  800da9:	75 0c                	jne    800db7 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800dab:	48 c1 e9 03          	shr    $0x3,%rcx
  800daf:	48 89 c7             	mov    %rax,%rdi
  800db2:	fc                   	cld
  800db3:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800db6:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800db7:	48 89 c7             	mov    %rax,%rdi
  800dba:	fc                   	cld
  800dbb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800dbd:	c3                   	ret

0000000000800dbe <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800dbe:	f3 0f 1e fa          	endbr64
  800dc2:	55                   	push   %rbp
  800dc3:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800dc6:	48 b8 53 0d 80 00 00 	movabs $0x800d53,%rax
  800dcd:	00 00 00 
  800dd0:	ff d0                	call   *%rax
}
  800dd2:	5d                   	pop    %rbp
  800dd3:	c3                   	ret

0000000000800dd4 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800dd4:	f3 0f 1e fa          	endbr64
  800dd8:	55                   	push   %rbp
  800dd9:	48 89 e5             	mov    %rsp,%rbp
  800ddc:	41 57                	push   %r15
  800dde:	41 56                	push   %r14
  800de0:	41 55                	push   %r13
  800de2:	41 54                	push   %r12
  800de4:	53                   	push   %rbx
  800de5:	48 83 ec 08          	sub    $0x8,%rsp
  800de9:	49 89 fe             	mov    %rdi,%r14
  800dec:	49 89 f7             	mov    %rsi,%r15
  800def:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800df2:	48 89 f7             	mov    %rsi,%rdi
  800df5:	48 b8 f3 0a 80 00 00 	movabs $0x800af3,%rax
  800dfc:	00 00 00 
  800dff:	ff d0                	call   *%rax
  800e01:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800e04:	48 89 de             	mov    %rbx,%rsi
  800e07:	4c 89 f7             	mov    %r14,%rdi
  800e0a:	48 b8 12 0b 80 00 00 	movabs $0x800b12,%rax
  800e11:	00 00 00 
  800e14:	ff d0                	call   *%rax
  800e16:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800e19:	48 39 c3             	cmp    %rax,%rbx
  800e1c:	74 36                	je     800e54 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800e1e:	48 89 d8             	mov    %rbx,%rax
  800e21:	4c 29 e8             	sub    %r13,%rax
  800e24:	49 39 c4             	cmp    %rax,%r12
  800e27:	73 31                	jae    800e5a <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800e29:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800e2e:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e32:	4c 89 fe             	mov    %r15,%rsi
  800e35:	48 b8 be 0d 80 00 00 	movabs $0x800dbe,%rax
  800e3c:	00 00 00 
  800e3f:	ff d0                	call   *%rax
    return dstlen + srclen;
  800e41:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800e45:	48 83 c4 08          	add    $0x8,%rsp
  800e49:	5b                   	pop    %rbx
  800e4a:	41 5c                	pop    %r12
  800e4c:	41 5d                	pop    %r13
  800e4e:	41 5e                	pop    %r14
  800e50:	41 5f                	pop    %r15
  800e52:	5d                   	pop    %rbp
  800e53:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800e54:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800e58:	eb eb                	jmp    800e45 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e5a:	48 83 eb 01          	sub    $0x1,%rbx
  800e5e:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e62:	48 89 da             	mov    %rbx,%rdx
  800e65:	4c 89 fe             	mov    %r15,%rsi
  800e68:	48 b8 be 0d 80 00 00 	movabs $0x800dbe,%rax
  800e6f:	00 00 00 
  800e72:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800e74:	49 01 de             	add    %rbx,%r14
  800e77:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800e7c:	eb c3                	jmp    800e41 <strlcat+0x6d>

0000000000800e7e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800e7e:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800e82:	48 85 d2             	test   %rdx,%rdx
  800e85:	74 2d                	je     800eb4 <memcmp+0x36>
  800e87:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800e8c:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800e90:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800e95:	44 38 c1             	cmp    %r8b,%cl
  800e98:	75 0f                	jne    800ea9 <memcmp+0x2b>
    while (n-- > 0) {
  800e9a:	48 83 c0 01          	add    $0x1,%rax
  800e9e:	48 39 c2             	cmp    %rax,%rdx
  800ea1:	75 e9                	jne    800e8c <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800ea3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea8:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800ea9:	0f b6 c1             	movzbl %cl,%eax
  800eac:	45 0f b6 c0          	movzbl %r8b,%r8d
  800eb0:	44 29 c0             	sub    %r8d,%eax
  800eb3:	c3                   	ret
    return 0;
  800eb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb9:	c3                   	ret

0000000000800eba <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800eba:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800ebe:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800ec2:	48 39 c7             	cmp    %rax,%rdi
  800ec5:	73 0f                	jae    800ed6 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800ec7:	40 38 37             	cmp    %sil,(%rdi)
  800eca:	74 0e                	je     800eda <memfind+0x20>
    for (; src < end; src++) {
  800ecc:	48 83 c7 01          	add    $0x1,%rdi
  800ed0:	48 39 f8             	cmp    %rdi,%rax
  800ed3:	75 f2                	jne    800ec7 <memfind+0xd>
  800ed5:	c3                   	ret
  800ed6:	48 89 f8             	mov    %rdi,%rax
  800ed9:	c3                   	ret
  800eda:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800edd:	c3                   	ret

0000000000800ede <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800ede:	f3 0f 1e fa          	endbr64
  800ee2:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800ee5:	0f b6 37             	movzbl (%rdi),%esi
  800ee8:	40 80 fe 20          	cmp    $0x20,%sil
  800eec:	74 06                	je     800ef4 <strtol+0x16>
  800eee:	40 80 fe 09          	cmp    $0x9,%sil
  800ef2:	75 13                	jne    800f07 <strtol+0x29>
  800ef4:	48 83 c7 01          	add    $0x1,%rdi
  800ef8:	0f b6 37             	movzbl (%rdi),%esi
  800efb:	40 80 fe 20          	cmp    $0x20,%sil
  800eff:	74 f3                	je     800ef4 <strtol+0x16>
  800f01:	40 80 fe 09          	cmp    $0x9,%sil
  800f05:	74 ed                	je     800ef4 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800f07:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800f0a:	83 e0 fd             	and    $0xfffffffd,%eax
  800f0d:	3c 01                	cmp    $0x1,%al
  800f0f:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f13:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  800f19:	75 0f                	jne    800f2a <strtol+0x4c>
  800f1b:	80 3f 30             	cmpb   $0x30,(%rdi)
  800f1e:	74 14                	je     800f34 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800f20:	85 d2                	test   %edx,%edx
  800f22:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f27:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  800f2a:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800f2f:	4c 63 ca             	movslq %edx,%r9
  800f32:	eb 36                	jmp    800f6a <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f34:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800f38:	74 0f                	je     800f49 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  800f3a:	85 d2                	test   %edx,%edx
  800f3c:	75 ec                	jne    800f2a <strtol+0x4c>
        s++;
  800f3e:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800f42:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  800f47:	eb e1                	jmp    800f2a <strtol+0x4c>
        s += 2;
  800f49:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f4d:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  800f52:	eb d6                	jmp    800f2a <strtol+0x4c>
            dig -= '0';
  800f54:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  800f57:	44 0f b6 c1          	movzbl %cl,%r8d
  800f5b:	41 39 d0             	cmp    %edx,%r8d
  800f5e:	7d 21                	jge    800f81 <strtol+0xa3>
        val = val * base + dig;
  800f60:	49 0f af c1          	imul   %r9,%rax
  800f64:	0f b6 c9             	movzbl %cl,%ecx
  800f67:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  800f6a:	48 83 c7 01          	add    $0x1,%rdi
  800f6e:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  800f72:	80 f9 39             	cmp    $0x39,%cl
  800f75:	76 dd                	jbe    800f54 <strtol+0x76>
        else if (dig - 'a' < 27)
  800f77:	80 f9 7b             	cmp    $0x7b,%cl
  800f7a:	77 05                	ja     800f81 <strtol+0xa3>
            dig -= 'a' - 10;
  800f7c:	83 e9 57             	sub    $0x57,%ecx
  800f7f:	eb d6                	jmp    800f57 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  800f81:	4d 85 d2             	test   %r10,%r10
  800f84:	74 03                	je     800f89 <strtol+0xab>
  800f86:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800f89:	48 89 c2             	mov    %rax,%rdx
  800f8c:	48 f7 da             	neg    %rdx
  800f8f:	40 80 fe 2d          	cmp    $0x2d,%sil
  800f93:	48 0f 44 c2          	cmove  %rdx,%rax
}
  800f97:	c3                   	ret

0000000000800f98 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800f98:	f3 0f 1e fa          	endbr64
  800f9c:	55                   	push   %rbp
  800f9d:	48 89 e5             	mov    %rsp,%rbp
  800fa0:	53                   	push   %rbx
  800fa1:	48 89 fa             	mov    %rdi,%rdx
  800fa4:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800fa7:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fb6:	be 00 00 00 00       	mov    $0x0,%esi
  800fbb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fc1:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800fc3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fc7:	c9                   	leave
  800fc8:	c3                   	ret

0000000000800fc9 <sys_cgetc>:

int
sys_cgetc(void) {
  800fc9:	f3 0f 1e fa          	endbr64
  800fcd:	55                   	push   %rbp
  800fce:	48 89 e5             	mov    %rsp,%rbp
  800fd1:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800fd2:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800fd7:	ba 00 00 00 00       	mov    $0x0,%edx
  800fdc:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fe1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800feb:	be 00 00 00 00       	mov    $0x0,%esi
  800ff0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800ff6:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800ff8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800ffc:	c9                   	leave
  800ffd:	c3                   	ret

0000000000800ffe <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800ffe:	f3 0f 1e fa          	endbr64
  801002:	55                   	push   %rbp
  801003:	48 89 e5             	mov    %rsp,%rbp
  801006:	53                   	push   %rbx
  801007:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80100b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80100e:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801013:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801018:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801022:	be 00 00 00 00       	mov    $0x0,%esi
  801027:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80102d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80102f:	48 85 c0             	test   %rax,%rax
  801032:	7f 06                	jg     80103a <sys_env_destroy+0x3c>
}
  801034:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801038:	c9                   	leave
  801039:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80103a:	49 89 c0             	mov    %rax,%r8
  80103d:	b9 03 00 00 00       	mov    $0x3,%ecx
  801042:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  801049:	00 00 00 
  80104c:	be 26 00 00 00       	mov    $0x26,%esi
  801051:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  801058:	00 00 00 
  80105b:	b8 00 00 00 00       	mov    $0x0,%eax
  801060:	49 b9 68 2a 80 00 00 	movabs $0x802a68,%r9
  801067:	00 00 00 
  80106a:	41 ff d1             	call   *%r9

000000000080106d <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80106d:	f3 0f 1e fa          	endbr64
  801071:	55                   	push   %rbp
  801072:	48 89 e5             	mov    %rsp,%rbp
  801075:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801076:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80107b:	ba 00 00 00 00       	mov    $0x0,%edx
  801080:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801085:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80108f:	be 00 00 00 00       	mov    $0x0,%esi
  801094:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80109a:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80109c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010a0:	c9                   	leave
  8010a1:	c3                   	ret

00000000008010a2 <sys_yield>:

void
sys_yield(void) {
  8010a2:	f3 0f 1e fa          	endbr64
  8010a6:	55                   	push   %rbp
  8010a7:	48 89 e5             	mov    %rsp,%rbp
  8010aa:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010ab:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bf:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010c4:	be 00 00 00 00       	mov    $0x0,%esi
  8010c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010cf:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8010d1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010d5:	c9                   	leave
  8010d6:	c3                   	ret

00000000008010d7 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8010d7:	f3 0f 1e fa          	endbr64
  8010db:	55                   	push   %rbp
  8010dc:	48 89 e5             	mov    %rsp,%rbp
  8010df:	53                   	push   %rbx
  8010e0:	48 89 fa             	mov    %rdi,%rdx
  8010e3:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8010e6:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010eb:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8010f2:	00 00 00 
  8010f5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010fa:	be 00 00 00 00       	mov    $0x0,%esi
  8010ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801105:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801107:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80110b:	c9                   	leave
  80110c:	c3                   	ret

000000000080110d <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80110d:	f3 0f 1e fa          	endbr64
  801111:	55                   	push   %rbp
  801112:	48 89 e5             	mov    %rsp,%rbp
  801115:	53                   	push   %rbx
  801116:	49 89 f8             	mov    %rdi,%r8
  801119:	48 89 d3             	mov    %rdx,%rbx
  80111c:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80111f:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801124:	4c 89 c2             	mov    %r8,%rdx
  801127:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80112a:	be 00 00 00 00       	mov    $0x0,%esi
  80112f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801135:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801137:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80113b:	c9                   	leave
  80113c:	c3                   	ret

000000000080113d <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80113d:	f3 0f 1e fa          	endbr64
  801141:	55                   	push   %rbp
  801142:	48 89 e5             	mov    %rsp,%rbp
  801145:	53                   	push   %rbx
  801146:	48 83 ec 08          	sub    $0x8,%rsp
  80114a:	89 f8                	mov    %edi,%eax
  80114c:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80114f:	48 63 f9             	movslq %ecx,%rdi
  801152:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801155:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80115a:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80115d:	be 00 00 00 00       	mov    $0x0,%esi
  801162:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801168:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80116a:	48 85 c0             	test   %rax,%rax
  80116d:	7f 06                	jg     801175 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  80116f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801173:	c9                   	leave
  801174:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801175:	49 89 c0             	mov    %rax,%r8
  801178:	b9 04 00 00 00       	mov    $0x4,%ecx
  80117d:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  801184:	00 00 00 
  801187:	be 26 00 00 00       	mov    $0x26,%esi
  80118c:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  801193:	00 00 00 
  801196:	b8 00 00 00 00       	mov    $0x0,%eax
  80119b:	49 b9 68 2a 80 00 00 	movabs $0x802a68,%r9
  8011a2:	00 00 00 
  8011a5:	41 ff d1             	call   *%r9

00000000008011a8 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8011a8:	f3 0f 1e fa          	endbr64
  8011ac:	55                   	push   %rbp
  8011ad:	48 89 e5             	mov    %rsp,%rbp
  8011b0:	53                   	push   %rbx
  8011b1:	48 83 ec 08          	sub    $0x8,%rsp
  8011b5:	89 f8                	mov    %edi,%eax
  8011b7:	49 89 f2             	mov    %rsi,%r10
  8011ba:	48 89 cf             	mov    %rcx,%rdi
  8011bd:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8011c0:	48 63 da             	movslq %edx,%rbx
  8011c3:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011c6:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011cb:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ce:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8011d1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011d3:	48 85 c0             	test   %rax,%rax
  8011d6:	7f 06                	jg     8011de <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8011d8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011dc:	c9                   	leave
  8011dd:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011de:	49 89 c0             	mov    %rax,%r8
  8011e1:	b9 05 00 00 00       	mov    $0x5,%ecx
  8011e6:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  8011ed:	00 00 00 
  8011f0:	be 26 00 00 00       	mov    $0x26,%esi
  8011f5:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  8011fc:	00 00 00 
  8011ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801204:	49 b9 68 2a 80 00 00 	movabs $0x802a68,%r9
  80120b:	00 00 00 
  80120e:	41 ff d1             	call   *%r9

0000000000801211 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801211:	f3 0f 1e fa          	endbr64
  801215:	55                   	push   %rbp
  801216:	48 89 e5             	mov    %rsp,%rbp
  801219:	53                   	push   %rbx
  80121a:	48 83 ec 08          	sub    $0x8,%rsp
  80121e:	49 89 f9             	mov    %rdi,%r9
  801221:	89 f0                	mov    %esi,%eax
  801223:	48 89 d3             	mov    %rdx,%rbx
  801226:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801229:	49 63 f0             	movslq %r8d,%rsi
  80122c:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80122f:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801234:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801237:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80123d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80123f:	48 85 c0             	test   %rax,%rax
  801242:	7f 06                	jg     80124a <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801244:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801248:	c9                   	leave
  801249:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80124a:	49 89 c0             	mov    %rax,%r8
  80124d:	b9 06 00 00 00       	mov    $0x6,%ecx
  801252:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  801259:	00 00 00 
  80125c:	be 26 00 00 00       	mov    $0x26,%esi
  801261:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  801268:	00 00 00 
  80126b:	b8 00 00 00 00       	mov    $0x0,%eax
  801270:	49 b9 68 2a 80 00 00 	movabs $0x802a68,%r9
  801277:	00 00 00 
  80127a:	41 ff d1             	call   *%r9

000000000080127d <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80127d:	f3 0f 1e fa          	endbr64
  801281:	55                   	push   %rbp
  801282:	48 89 e5             	mov    %rsp,%rbp
  801285:	53                   	push   %rbx
  801286:	48 83 ec 08          	sub    $0x8,%rsp
  80128a:	48 89 f1             	mov    %rsi,%rcx
  80128d:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801290:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801293:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801298:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80129d:	be 00 00 00 00       	mov    $0x0,%esi
  8012a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012a8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012aa:	48 85 c0             	test   %rax,%rax
  8012ad:	7f 06                	jg     8012b5 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8012af:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012b3:	c9                   	leave
  8012b4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012b5:	49 89 c0             	mov    %rax,%r8
  8012b8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8012bd:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  8012c4:	00 00 00 
  8012c7:	be 26 00 00 00       	mov    $0x26,%esi
  8012cc:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  8012d3:	00 00 00 
  8012d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012db:	49 b9 68 2a 80 00 00 	movabs $0x802a68,%r9
  8012e2:	00 00 00 
  8012e5:	41 ff d1             	call   *%r9

00000000008012e8 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8012e8:	f3 0f 1e fa          	endbr64
  8012ec:	55                   	push   %rbp
  8012ed:	48 89 e5             	mov    %rsp,%rbp
  8012f0:	53                   	push   %rbx
  8012f1:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8012f5:	48 63 ce             	movslq %esi,%rcx
  8012f8:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012fb:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801300:	bb 00 00 00 00       	mov    $0x0,%ebx
  801305:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80130a:	be 00 00 00 00       	mov    $0x0,%esi
  80130f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801315:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801317:	48 85 c0             	test   %rax,%rax
  80131a:	7f 06                	jg     801322 <sys_env_set_status+0x3a>
}
  80131c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801320:	c9                   	leave
  801321:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801322:	49 89 c0             	mov    %rax,%r8
  801325:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80132a:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  801331:	00 00 00 
  801334:	be 26 00 00 00       	mov    $0x26,%esi
  801339:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  801340:	00 00 00 
  801343:	b8 00 00 00 00       	mov    $0x0,%eax
  801348:	49 b9 68 2a 80 00 00 	movabs $0x802a68,%r9
  80134f:	00 00 00 
  801352:	41 ff d1             	call   *%r9

0000000000801355 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801355:	f3 0f 1e fa          	endbr64
  801359:	55                   	push   %rbp
  80135a:	48 89 e5             	mov    %rsp,%rbp
  80135d:	53                   	push   %rbx
  80135e:	48 83 ec 08          	sub    $0x8,%rsp
  801362:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801365:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801368:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80136d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801372:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801377:	be 00 00 00 00       	mov    $0x0,%esi
  80137c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801382:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801384:	48 85 c0             	test   %rax,%rax
  801387:	7f 06                	jg     80138f <sys_env_set_trapframe+0x3a>
}
  801389:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80138d:	c9                   	leave
  80138e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80138f:	49 89 c0             	mov    %rax,%r8
  801392:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801397:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  80139e:	00 00 00 
  8013a1:	be 26 00 00 00       	mov    $0x26,%esi
  8013a6:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  8013ad:	00 00 00 
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b5:	49 b9 68 2a 80 00 00 	movabs $0x802a68,%r9
  8013bc:	00 00 00 
  8013bf:	41 ff d1             	call   *%r9

00000000008013c2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8013c2:	f3 0f 1e fa          	endbr64
  8013c6:	55                   	push   %rbp
  8013c7:	48 89 e5             	mov    %rsp,%rbp
  8013ca:	53                   	push   %rbx
  8013cb:	48 83 ec 08          	sub    $0x8,%rsp
  8013cf:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8013d2:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013d5:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013df:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e4:	be 00 00 00 00       	mov    $0x0,%esi
  8013e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013ef:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013f1:	48 85 c0             	test   %rax,%rax
  8013f4:	7f 06                	jg     8013fc <sys_env_set_pgfault_upcall+0x3a>
}
  8013f6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013fa:	c9                   	leave
  8013fb:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013fc:	49 89 c0             	mov    %rax,%r8
  8013ff:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801404:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  80140b:	00 00 00 
  80140e:	be 26 00 00 00       	mov    $0x26,%esi
  801413:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  80141a:	00 00 00 
  80141d:	b8 00 00 00 00       	mov    $0x0,%eax
  801422:	49 b9 68 2a 80 00 00 	movabs $0x802a68,%r9
  801429:	00 00 00 
  80142c:	41 ff d1             	call   *%r9

000000000080142f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80142f:	f3 0f 1e fa          	endbr64
  801433:	55                   	push   %rbp
  801434:	48 89 e5             	mov    %rsp,%rbp
  801437:	53                   	push   %rbx
  801438:	89 f8                	mov    %edi,%eax
  80143a:	49 89 f1             	mov    %rsi,%r9
  80143d:	48 89 d3             	mov    %rdx,%rbx
  801440:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801443:	49 63 f0             	movslq %r8d,%rsi
  801446:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801449:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80144e:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801451:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801457:	cd 30                	int    $0x30
}
  801459:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80145d:	c9                   	leave
  80145e:	c3                   	ret

000000000080145f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80145f:	f3 0f 1e fa          	endbr64
  801463:	55                   	push   %rbp
  801464:	48 89 e5             	mov    %rsp,%rbp
  801467:	53                   	push   %rbx
  801468:	48 83 ec 08          	sub    $0x8,%rsp
  80146c:	48 89 fa             	mov    %rdi,%rdx
  80146f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801472:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801477:	bb 00 00 00 00       	mov    $0x0,%ebx
  80147c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801481:	be 00 00 00 00       	mov    $0x0,%esi
  801486:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80148c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80148e:	48 85 c0             	test   %rax,%rax
  801491:	7f 06                	jg     801499 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801493:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801497:	c9                   	leave
  801498:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801499:	49 89 c0             	mov    %rax,%r8
  80149c:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8014a1:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  8014a8:	00 00 00 
  8014ab:	be 26 00 00 00       	mov    $0x26,%esi
  8014b0:	48 bf 9d 31 80 00 00 	movabs $0x80319d,%rdi
  8014b7:	00 00 00 
  8014ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bf:	49 b9 68 2a 80 00 00 	movabs $0x802a68,%r9
  8014c6:	00 00 00 
  8014c9:	41 ff d1             	call   *%r9

00000000008014cc <sys_gettime>:

int
sys_gettime(void) {
  8014cc:	f3 0f 1e fa          	endbr64
  8014d0:	55                   	push   %rbp
  8014d1:	48 89 e5             	mov    %rsp,%rbp
  8014d4:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014d5:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014da:	ba 00 00 00 00       	mov    $0x0,%edx
  8014df:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014ee:	be 00 00 00 00       	mov    $0x0,%esi
  8014f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014f9:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8014fb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014ff:	c9                   	leave
  801500:	c3                   	ret

0000000000801501 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801501:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801505:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80150c:	ff ff ff 
  80150f:	48 01 f8             	add    %rdi,%rax
  801512:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801516:	c3                   	ret

0000000000801517 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801517:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80151b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801522:	ff ff ff 
  801525:	48 01 f8             	add    %rdi,%rax
  801528:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80152c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801532:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801536:	c3                   	ret

0000000000801537 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801537:	f3 0f 1e fa          	endbr64
  80153b:	55                   	push   %rbp
  80153c:	48 89 e5             	mov    %rsp,%rbp
  80153f:	41 57                	push   %r15
  801541:	41 56                	push   %r14
  801543:	41 55                	push   %r13
  801545:	41 54                	push   %r12
  801547:	53                   	push   %rbx
  801548:	48 83 ec 08          	sub    $0x8,%rsp
  80154c:	49 89 ff             	mov    %rdi,%r15
  80154f:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801554:	49 bd 96 26 80 00 00 	movabs $0x802696,%r13
  80155b:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80155e:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801564:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801567:	48 89 df             	mov    %rbx,%rdi
  80156a:	41 ff d5             	call   *%r13
  80156d:	83 e0 04             	and    $0x4,%eax
  801570:	74 17                	je     801589 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801572:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801579:	4c 39 f3             	cmp    %r14,%rbx
  80157c:	75 e6                	jne    801564 <fd_alloc+0x2d>
  80157e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801584:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801589:	4d 89 27             	mov    %r12,(%r15)
}
  80158c:	48 83 c4 08          	add    $0x8,%rsp
  801590:	5b                   	pop    %rbx
  801591:	41 5c                	pop    %r12
  801593:	41 5d                	pop    %r13
  801595:	41 5e                	pop    %r14
  801597:	41 5f                	pop    %r15
  801599:	5d                   	pop    %rbp
  80159a:	c3                   	ret

000000000080159b <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  80159b:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  80159f:	83 ff 1f             	cmp    $0x1f,%edi
  8015a2:	77 39                	ja     8015dd <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8015a4:	55                   	push   %rbp
  8015a5:	48 89 e5             	mov    %rsp,%rbp
  8015a8:	41 54                	push   %r12
  8015aa:	53                   	push   %rbx
  8015ab:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8015ae:	48 63 df             	movslq %edi,%rbx
  8015b1:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8015b8:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8015bc:	48 89 df             	mov    %rbx,%rdi
  8015bf:	48 b8 96 26 80 00 00 	movabs $0x802696,%rax
  8015c6:	00 00 00 
  8015c9:	ff d0                	call   *%rax
  8015cb:	a8 04                	test   $0x4,%al
  8015cd:	74 14                	je     8015e3 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8015cf:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8015d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d8:	5b                   	pop    %rbx
  8015d9:	41 5c                	pop    %r12
  8015db:	5d                   	pop    %rbp
  8015dc:	c3                   	ret
        return -E_INVAL;
  8015dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015e2:	c3                   	ret
        return -E_INVAL;
  8015e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015e8:	eb ee                	jmp    8015d8 <fd_lookup+0x3d>

00000000008015ea <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8015ea:	f3 0f 1e fa          	endbr64
  8015ee:	55                   	push   %rbp
  8015ef:	48 89 e5             	mov    %rsp,%rbp
  8015f2:	41 54                	push   %r12
  8015f4:	53                   	push   %rbx
  8015f5:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  8015f8:	48 b8 a0 36 80 00 00 	movabs $0x8036a0,%rax
  8015ff:	00 00 00 
  801602:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  801609:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  80160c:	39 3b                	cmp    %edi,(%rbx)
  80160e:	74 47                	je     801657 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801610:	48 83 c0 08          	add    $0x8,%rax
  801614:	48 8b 18             	mov    (%rax),%rbx
  801617:	48 85 db             	test   %rbx,%rbx
  80161a:	75 f0                	jne    80160c <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80161c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801623:	00 00 00 
  801626:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80162c:	89 fa                	mov    %edi,%edx
  80162e:	48 bf 00 36 80 00 00 	movabs $0x803600,%rdi
  801635:	00 00 00 
  801638:	b8 00 00 00 00       	mov    $0x0,%eax
  80163d:	48 b9 ef 01 80 00 00 	movabs $0x8001ef,%rcx
  801644:	00 00 00 
  801647:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801649:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  80164e:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801652:	5b                   	pop    %rbx
  801653:	41 5c                	pop    %r12
  801655:	5d                   	pop    %rbp
  801656:	c3                   	ret
            return 0;
  801657:	b8 00 00 00 00       	mov    $0x0,%eax
  80165c:	eb f0                	jmp    80164e <dev_lookup+0x64>

000000000080165e <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80165e:	f3 0f 1e fa          	endbr64
  801662:	55                   	push   %rbp
  801663:	48 89 e5             	mov    %rsp,%rbp
  801666:	41 55                	push   %r13
  801668:	41 54                	push   %r12
  80166a:	53                   	push   %rbx
  80166b:	48 83 ec 18          	sub    $0x18,%rsp
  80166f:	48 89 fb             	mov    %rdi,%rbx
  801672:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801675:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80167c:	ff ff ff 
  80167f:	48 01 df             	add    %rbx,%rdi
  801682:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801686:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80168a:	48 b8 9b 15 80 00 00 	movabs $0x80159b,%rax
  801691:	00 00 00 
  801694:	ff d0                	call   *%rax
  801696:	41 89 c5             	mov    %eax,%r13d
  801699:	85 c0                	test   %eax,%eax
  80169b:	78 06                	js     8016a3 <fd_close+0x45>
  80169d:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  8016a1:	74 1a                	je     8016bd <fd_close+0x5f>
        return (must_exist ? res : 0);
  8016a3:	45 84 e4             	test   %r12b,%r12b
  8016a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ab:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8016af:	44 89 e8             	mov    %r13d,%eax
  8016b2:	48 83 c4 18          	add    $0x18,%rsp
  8016b6:	5b                   	pop    %rbx
  8016b7:	41 5c                	pop    %r12
  8016b9:	41 5d                	pop    %r13
  8016bb:	5d                   	pop    %rbp
  8016bc:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016bd:	8b 3b                	mov    (%rbx),%edi
  8016bf:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8016c3:	48 b8 ea 15 80 00 00 	movabs $0x8015ea,%rax
  8016ca:	00 00 00 
  8016cd:	ff d0                	call   *%rax
  8016cf:	41 89 c5             	mov    %eax,%r13d
  8016d2:	85 c0                	test   %eax,%eax
  8016d4:	78 1b                	js     8016f1 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8016d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016da:	48 8b 40 20          	mov    0x20(%rax),%rax
  8016de:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8016e4:	48 85 c0             	test   %rax,%rax
  8016e7:	74 08                	je     8016f1 <fd_close+0x93>
  8016e9:	48 89 df             	mov    %rbx,%rdi
  8016ec:	ff d0                	call   *%rax
  8016ee:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8016f1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8016f6:	48 89 de             	mov    %rbx,%rsi
  8016f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8016fe:	48 b8 7d 12 80 00 00 	movabs $0x80127d,%rax
  801705:	00 00 00 
  801708:	ff d0                	call   *%rax
    return res;
  80170a:	eb a3                	jmp    8016af <fd_close+0x51>

000000000080170c <close>:

int
close(int fdnum) {
  80170c:	f3 0f 1e fa          	endbr64
  801710:	55                   	push   %rbp
  801711:	48 89 e5             	mov    %rsp,%rbp
  801714:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801718:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80171c:	48 b8 9b 15 80 00 00 	movabs $0x80159b,%rax
  801723:	00 00 00 
  801726:	ff d0                	call   *%rax
    if (res < 0) return res;
  801728:	85 c0                	test   %eax,%eax
  80172a:	78 15                	js     801741 <close+0x35>

    return fd_close(fd, 1);
  80172c:	be 01 00 00 00       	mov    $0x1,%esi
  801731:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801735:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  80173c:	00 00 00 
  80173f:	ff d0                	call   *%rax
}
  801741:	c9                   	leave
  801742:	c3                   	ret

0000000000801743 <close_all>:

void
close_all(void) {
  801743:	f3 0f 1e fa          	endbr64
  801747:	55                   	push   %rbp
  801748:	48 89 e5             	mov    %rsp,%rbp
  80174b:	41 54                	push   %r12
  80174d:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80174e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801753:	49 bc 0c 17 80 00 00 	movabs $0x80170c,%r12
  80175a:	00 00 00 
  80175d:	89 df                	mov    %ebx,%edi
  80175f:	41 ff d4             	call   *%r12
  801762:	83 c3 01             	add    $0x1,%ebx
  801765:	83 fb 20             	cmp    $0x20,%ebx
  801768:	75 f3                	jne    80175d <close_all+0x1a>
}
  80176a:	5b                   	pop    %rbx
  80176b:	41 5c                	pop    %r12
  80176d:	5d                   	pop    %rbp
  80176e:	c3                   	ret

000000000080176f <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80176f:	f3 0f 1e fa          	endbr64
  801773:	55                   	push   %rbp
  801774:	48 89 e5             	mov    %rsp,%rbp
  801777:	41 57                	push   %r15
  801779:	41 56                	push   %r14
  80177b:	41 55                	push   %r13
  80177d:	41 54                	push   %r12
  80177f:	53                   	push   %rbx
  801780:	48 83 ec 18          	sub    $0x18,%rsp
  801784:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801787:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  80178b:	48 b8 9b 15 80 00 00 	movabs $0x80159b,%rax
  801792:	00 00 00 
  801795:	ff d0                	call   *%rax
  801797:	89 c3                	mov    %eax,%ebx
  801799:	85 c0                	test   %eax,%eax
  80179b:	0f 88 b8 00 00 00    	js     801859 <dup+0xea>
    close(newfdnum);
  8017a1:	44 89 e7             	mov    %r12d,%edi
  8017a4:	48 b8 0c 17 80 00 00 	movabs $0x80170c,%rax
  8017ab:	00 00 00 
  8017ae:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8017b0:	4d 63 ec             	movslq %r12d,%r13
  8017b3:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8017ba:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8017be:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8017c2:	4c 89 ff             	mov    %r15,%rdi
  8017c5:	49 be 17 15 80 00 00 	movabs $0x801517,%r14
  8017cc:	00 00 00 
  8017cf:	41 ff d6             	call   *%r14
  8017d2:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8017d5:	4c 89 ef             	mov    %r13,%rdi
  8017d8:	41 ff d6             	call   *%r14
  8017db:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8017de:	48 89 df             	mov    %rbx,%rdi
  8017e1:	48 b8 96 26 80 00 00 	movabs $0x802696,%rax
  8017e8:	00 00 00 
  8017eb:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8017ed:	a8 04                	test   $0x4,%al
  8017ef:	74 2b                	je     80181c <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8017f1:	41 89 c1             	mov    %eax,%r9d
  8017f4:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8017fa:	4c 89 f1             	mov    %r14,%rcx
  8017fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801802:	48 89 de             	mov    %rbx,%rsi
  801805:	bf 00 00 00 00       	mov    $0x0,%edi
  80180a:	48 b8 a8 11 80 00 00 	movabs $0x8011a8,%rax
  801811:	00 00 00 
  801814:	ff d0                	call   *%rax
  801816:	89 c3                	mov    %eax,%ebx
  801818:	85 c0                	test   %eax,%eax
  80181a:	78 4e                	js     80186a <dup+0xfb>
    }
    prot = get_prot(oldfd);
  80181c:	4c 89 ff             	mov    %r15,%rdi
  80181f:	48 b8 96 26 80 00 00 	movabs $0x802696,%rax
  801826:	00 00 00 
  801829:	ff d0                	call   *%rax
  80182b:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  80182e:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801834:	4c 89 e9             	mov    %r13,%rcx
  801837:	ba 00 00 00 00       	mov    $0x0,%edx
  80183c:	4c 89 fe             	mov    %r15,%rsi
  80183f:	bf 00 00 00 00       	mov    $0x0,%edi
  801844:	48 b8 a8 11 80 00 00 	movabs $0x8011a8,%rax
  80184b:	00 00 00 
  80184e:	ff d0                	call   *%rax
  801850:	89 c3                	mov    %eax,%ebx
  801852:	85 c0                	test   %eax,%eax
  801854:	78 14                	js     80186a <dup+0xfb>

    return newfdnum;
  801856:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801859:	89 d8                	mov    %ebx,%eax
  80185b:	48 83 c4 18          	add    $0x18,%rsp
  80185f:	5b                   	pop    %rbx
  801860:	41 5c                	pop    %r12
  801862:	41 5d                	pop    %r13
  801864:	41 5e                	pop    %r14
  801866:	41 5f                	pop    %r15
  801868:	5d                   	pop    %rbp
  801869:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80186a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80186f:	4c 89 ee             	mov    %r13,%rsi
  801872:	bf 00 00 00 00       	mov    $0x0,%edi
  801877:	49 bc 7d 12 80 00 00 	movabs $0x80127d,%r12
  80187e:	00 00 00 
  801881:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801884:	ba 00 10 00 00       	mov    $0x1000,%edx
  801889:	4c 89 f6             	mov    %r14,%rsi
  80188c:	bf 00 00 00 00       	mov    $0x0,%edi
  801891:	41 ff d4             	call   *%r12
    return res;
  801894:	eb c3                	jmp    801859 <dup+0xea>

0000000000801896 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801896:	f3 0f 1e fa          	endbr64
  80189a:	55                   	push   %rbp
  80189b:	48 89 e5             	mov    %rsp,%rbp
  80189e:	41 56                	push   %r14
  8018a0:	41 55                	push   %r13
  8018a2:	41 54                	push   %r12
  8018a4:	53                   	push   %rbx
  8018a5:	48 83 ec 10          	sub    $0x10,%rsp
  8018a9:	89 fb                	mov    %edi,%ebx
  8018ab:	49 89 f4             	mov    %rsi,%r12
  8018ae:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8018b1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018b5:	48 b8 9b 15 80 00 00 	movabs $0x80159b,%rax
  8018bc:	00 00 00 
  8018bf:	ff d0                	call   *%rax
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	78 4c                	js     801911 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8018c5:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8018c9:	41 8b 3e             	mov    (%r14),%edi
  8018cc:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018d0:	48 b8 ea 15 80 00 00 	movabs $0x8015ea,%rax
  8018d7:	00 00 00 
  8018da:	ff d0                	call   *%rax
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	78 35                	js     801915 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018e0:	41 8b 46 08          	mov    0x8(%r14),%eax
  8018e4:	83 e0 03             	and    $0x3,%eax
  8018e7:	83 f8 01             	cmp    $0x1,%eax
  8018ea:	74 2d                	je     801919 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8018ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018f0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8018f4:	48 85 c0             	test   %rax,%rax
  8018f7:	74 56                	je     80194f <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  8018f9:	4c 89 ea             	mov    %r13,%rdx
  8018fc:	4c 89 e6             	mov    %r12,%rsi
  8018ff:	4c 89 f7             	mov    %r14,%rdi
  801902:	ff d0                	call   *%rax
}
  801904:	48 83 c4 10          	add    $0x10,%rsp
  801908:	5b                   	pop    %rbx
  801909:	41 5c                	pop    %r12
  80190b:	41 5d                	pop    %r13
  80190d:	41 5e                	pop    %r14
  80190f:	5d                   	pop    %rbp
  801910:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801911:	48 98                	cltq
  801913:	eb ef                	jmp    801904 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801915:	48 98                	cltq
  801917:	eb eb                	jmp    801904 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801919:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801920:	00 00 00 
  801923:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801929:	89 da                	mov    %ebx,%edx
  80192b:	48 bf ab 31 80 00 00 	movabs $0x8031ab,%rdi
  801932:	00 00 00 
  801935:	b8 00 00 00 00       	mov    $0x0,%eax
  80193a:	48 b9 ef 01 80 00 00 	movabs $0x8001ef,%rcx
  801941:	00 00 00 
  801944:	ff d1                	call   *%rcx
        return -E_INVAL;
  801946:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80194d:	eb b5                	jmp    801904 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  80194f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801956:	eb ac                	jmp    801904 <read+0x6e>

0000000000801958 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801958:	f3 0f 1e fa          	endbr64
  80195c:	55                   	push   %rbp
  80195d:	48 89 e5             	mov    %rsp,%rbp
  801960:	41 57                	push   %r15
  801962:	41 56                	push   %r14
  801964:	41 55                	push   %r13
  801966:	41 54                	push   %r12
  801968:	53                   	push   %rbx
  801969:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  80196d:	48 85 d2             	test   %rdx,%rdx
  801970:	74 54                	je     8019c6 <readn+0x6e>
  801972:	41 89 fd             	mov    %edi,%r13d
  801975:	49 89 f6             	mov    %rsi,%r14
  801978:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  80197b:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801980:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801985:	49 bf 96 18 80 00 00 	movabs $0x801896,%r15
  80198c:	00 00 00 
  80198f:	4c 89 e2             	mov    %r12,%rdx
  801992:	48 29 f2             	sub    %rsi,%rdx
  801995:	4c 01 f6             	add    %r14,%rsi
  801998:	44 89 ef             	mov    %r13d,%edi
  80199b:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	78 20                	js     8019c2 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  8019a2:	01 c3                	add    %eax,%ebx
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	74 08                	je     8019b0 <readn+0x58>
  8019a8:	48 63 f3             	movslq %ebx,%rsi
  8019ab:	4c 39 e6             	cmp    %r12,%rsi
  8019ae:	72 df                	jb     80198f <readn+0x37>
    }
    return res;
  8019b0:	48 63 c3             	movslq %ebx,%rax
}
  8019b3:	48 83 c4 08          	add    $0x8,%rsp
  8019b7:	5b                   	pop    %rbx
  8019b8:	41 5c                	pop    %r12
  8019ba:	41 5d                	pop    %r13
  8019bc:	41 5e                	pop    %r14
  8019be:	41 5f                	pop    %r15
  8019c0:	5d                   	pop    %rbp
  8019c1:	c3                   	ret
        if (inc < 0) return inc;
  8019c2:	48 98                	cltq
  8019c4:	eb ed                	jmp    8019b3 <readn+0x5b>
    int inc = 1, res = 0;
  8019c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019cb:	eb e3                	jmp    8019b0 <readn+0x58>

00000000008019cd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8019cd:	f3 0f 1e fa          	endbr64
  8019d1:	55                   	push   %rbp
  8019d2:	48 89 e5             	mov    %rsp,%rbp
  8019d5:	41 56                	push   %r14
  8019d7:	41 55                	push   %r13
  8019d9:	41 54                	push   %r12
  8019db:	53                   	push   %rbx
  8019dc:	48 83 ec 10          	sub    $0x10,%rsp
  8019e0:	89 fb                	mov    %edi,%ebx
  8019e2:	49 89 f4             	mov    %rsi,%r12
  8019e5:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019e8:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019ec:	48 b8 9b 15 80 00 00 	movabs $0x80159b,%rax
  8019f3:	00 00 00 
  8019f6:	ff d0                	call   *%rax
  8019f8:	85 c0                	test   %eax,%eax
  8019fa:	78 47                	js     801a43 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019fc:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801a00:	41 8b 3e             	mov    (%r14),%edi
  801a03:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a07:	48 b8 ea 15 80 00 00 	movabs $0x8015ea,%rax
  801a0e:	00 00 00 
  801a11:	ff d0                	call   *%rax
  801a13:	85 c0                	test   %eax,%eax
  801a15:	78 30                	js     801a47 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a17:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801a1c:	74 2d                	je     801a4b <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801a1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a22:	48 8b 40 18          	mov    0x18(%rax),%rax
  801a26:	48 85 c0             	test   %rax,%rax
  801a29:	74 56                	je     801a81 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801a2b:	4c 89 ea             	mov    %r13,%rdx
  801a2e:	4c 89 e6             	mov    %r12,%rsi
  801a31:	4c 89 f7             	mov    %r14,%rdi
  801a34:	ff d0                	call   *%rax
}
  801a36:	48 83 c4 10          	add    $0x10,%rsp
  801a3a:	5b                   	pop    %rbx
  801a3b:	41 5c                	pop    %r12
  801a3d:	41 5d                	pop    %r13
  801a3f:	41 5e                	pop    %r14
  801a41:	5d                   	pop    %rbp
  801a42:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a43:	48 98                	cltq
  801a45:	eb ef                	jmp    801a36 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a47:	48 98                	cltq
  801a49:	eb eb                	jmp    801a36 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a4b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a52:	00 00 00 
  801a55:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a5b:	89 da                	mov    %ebx,%edx
  801a5d:	48 bf c7 31 80 00 00 	movabs $0x8031c7,%rdi
  801a64:	00 00 00 
  801a67:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6c:	48 b9 ef 01 80 00 00 	movabs $0x8001ef,%rcx
  801a73:	00 00 00 
  801a76:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a78:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801a7f:	eb b5                	jmp    801a36 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801a81:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a88:	eb ac                	jmp    801a36 <write+0x69>

0000000000801a8a <seek>:

int
seek(int fdnum, off_t offset) {
  801a8a:	f3 0f 1e fa          	endbr64
  801a8e:	55                   	push   %rbp
  801a8f:	48 89 e5             	mov    %rsp,%rbp
  801a92:	53                   	push   %rbx
  801a93:	48 83 ec 18          	sub    $0x18,%rsp
  801a97:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a99:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801a9d:	48 b8 9b 15 80 00 00 	movabs $0x80159b,%rax
  801aa4:	00 00 00 
  801aa7:	ff d0                	call   *%rax
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	78 0c                	js     801ab9 <seek+0x2f>

    fd->fd_offset = offset;
  801aad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ab1:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ab4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801abd:	c9                   	leave
  801abe:	c3                   	ret

0000000000801abf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801abf:	f3 0f 1e fa          	endbr64
  801ac3:	55                   	push   %rbp
  801ac4:	48 89 e5             	mov    %rsp,%rbp
  801ac7:	41 55                	push   %r13
  801ac9:	41 54                	push   %r12
  801acb:	53                   	push   %rbx
  801acc:	48 83 ec 18          	sub    $0x18,%rsp
  801ad0:	89 fb                	mov    %edi,%ebx
  801ad2:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ad5:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ad9:	48 b8 9b 15 80 00 00 	movabs $0x80159b,%rax
  801ae0:	00 00 00 
  801ae3:	ff d0                	call   *%rax
  801ae5:	85 c0                	test   %eax,%eax
  801ae7:	78 38                	js     801b21 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ae9:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801aed:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801af1:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801af5:	48 b8 ea 15 80 00 00 	movabs $0x8015ea,%rax
  801afc:	00 00 00 
  801aff:	ff d0                	call   *%rax
  801b01:	85 c0                	test   %eax,%eax
  801b03:	78 1c                	js     801b21 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b05:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801b0a:	74 20                	je     801b2c <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801b0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b10:	48 8b 40 30          	mov    0x30(%rax),%rax
  801b14:	48 85 c0             	test   %rax,%rax
  801b17:	74 47                	je     801b60 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801b19:	44 89 e6             	mov    %r12d,%esi
  801b1c:	4c 89 ef             	mov    %r13,%rdi
  801b1f:	ff d0                	call   *%rax
}
  801b21:	48 83 c4 18          	add    $0x18,%rsp
  801b25:	5b                   	pop    %rbx
  801b26:	41 5c                	pop    %r12
  801b28:	41 5d                	pop    %r13
  801b2a:	5d                   	pop    %rbp
  801b2b:	c3                   	ret
                thisenv->env_id, fdnum);
  801b2c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b33:	00 00 00 
  801b36:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b3c:	89 da                	mov    %ebx,%edx
  801b3e:	48 bf 20 36 80 00 00 	movabs $0x803620,%rdi
  801b45:	00 00 00 
  801b48:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4d:	48 b9 ef 01 80 00 00 	movabs $0x8001ef,%rcx
  801b54:	00 00 00 
  801b57:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b5e:	eb c1                	jmp    801b21 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801b60:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801b65:	eb ba                	jmp    801b21 <ftruncate+0x62>

0000000000801b67 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801b67:	f3 0f 1e fa          	endbr64
  801b6b:	55                   	push   %rbp
  801b6c:	48 89 e5             	mov    %rsp,%rbp
  801b6f:	41 54                	push   %r12
  801b71:	53                   	push   %rbx
  801b72:	48 83 ec 10          	sub    $0x10,%rsp
  801b76:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b79:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801b7d:	48 b8 9b 15 80 00 00 	movabs $0x80159b,%rax
  801b84:	00 00 00 
  801b87:	ff d0                	call   *%rax
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	78 4e                	js     801bdb <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b8d:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801b91:	41 8b 3c 24          	mov    (%r12),%edi
  801b95:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801b99:	48 b8 ea 15 80 00 00 	movabs $0x8015ea,%rax
  801ba0:	00 00 00 
  801ba3:	ff d0                	call   *%rax
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	78 32                	js     801bdb <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801ba9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bad:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801bb2:	74 30                	je     801be4 <fstat+0x7d>

    stat->st_name[0] = 0;
  801bb4:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801bb7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801bbe:	00 00 00 
    stat->st_isdir = 0;
  801bc1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801bc8:	00 00 00 
    stat->st_dev = dev;
  801bcb:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801bd2:	48 89 de             	mov    %rbx,%rsi
  801bd5:	4c 89 e7             	mov    %r12,%rdi
  801bd8:	ff 50 28             	call   *0x28(%rax)
}
  801bdb:	48 83 c4 10          	add    $0x10,%rsp
  801bdf:	5b                   	pop    %rbx
  801be0:	41 5c                	pop    %r12
  801be2:	5d                   	pop    %rbp
  801be3:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801be4:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801be9:	eb f0                	jmp    801bdb <fstat+0x74>

0000000000801beb <stat>:

int
stat(const char *path, struct Stat *stat) {
  801beb:	f3 0f 1e fa          	endbr64
  801bef:	55                   	push   %rbp
  801bf0:	48 89 e5             	mov    %rsp,%rbp
  801bf3:	41 54                	push   %r12
  801bf5:	53                   	push   %rbx
  801bf6:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801bf9:	be 00 00 00 00       	mov    $0x0,%esi
  801bfe:	48 b8 cc 1e 80 00 00 	movabs $0x801ecc,%rax
  801c05:	00 00 00 
  801c08:	ff d0                	call   *%rax
  801c0a:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	78 25                	js     801c35 <stat+0x4a>

    int res = fstat(fd, stat);
  801c10:	4c 89 e6             	mov    %r12,%rsi
  801c13:	89 c7                	mov    %eax,%edi
  801c15:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  801c1c:	00 00 00 
  801c1f:	ff d0                	call   *%rax
  801c21:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801c24:	89 df                	mov    %ebx,%edi
  801c26:	48 b8 0c 17 80 00 00 	movabs $0x80170c,%rax
  801c2d:	00 00 00 
  801c30:	ff d0                	call   *%rax

    return res;
  801c32:	44 89 e3             	mov    %r12d,%ebx
}
  801c35:	89 d8                	mov    %ebx,%eax
  801c37:	5b                   	pop    %rbx
  801c38:	41 5c                	pop    %r12
  801c3a:	5d                   	pop    %rbp
  801c3b:	c3                   	ret

0000000000801c3c <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801c3c:	f3 0f 1e fa          	endbr64
  801c40:	55                   	push   %rbp
  801c41:	48 89 e5             	mov    %rsp,%rbp
  801c44:	41 54                	push   %r12
  801c46:	53                   	push   %rbx
  801c47:	48 83 ec 10          	sub    $0x10,%rsp
  801c4b:	41 89 fc             	mov    %edi,%r12d
  801c4e:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801c51:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c58:	00 00 00 
  801c5b:	83 38 00             	cmpl   $0x0,(%rax)
  801c5e:	74 6e                	je     801cce <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801c60:	bf 03 00 00 00       	mov    $0x3,%edi
  801c65:	48 b8 6a 2c 80 00 00 	movabs $0x802c6a,%rax
  801c6c:	00 00 00 
  801c6f:	ff d0                	call   *%rax
  801c71:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801c78:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801c7a:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801c80:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c85:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801c8c:	00 00 00 
  801c8f:	44 89 e6             	mov    %r12d,%esi
  801c92:	89 c7                	mov    %eax,%edi
  801c94:	48 b8 a8 2b 80 00 00 	movabs $0x802ba8,%rax
  801c9b:	00 00 00 
  801c9e:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801ca0:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801ca7:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801ca8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cad:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801cb1:	48 89 de             	mov    %rbx,%rsi
  801cb4:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb9:	48 b8 0f 2b 80 00 00 	movabs $0x802b0f,%rax
  801cc0:	00 00 00 
  801cc3:	ff d0                	call   *%rax
}
  801cc5:	48 83 c4 10          	add    $0x10,%rsp
  801cc9:	5b                   	pop    %rbx
  801cca:	41 5c                	pop    %r12
  801ccc:	5d                   	pop    %rbp
  801ccd:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801cce:	bf 03 00 00 00       	mov    $0x3,%edi
  801cd3:	48 b8 6a 2c 80 00 00 	movabs $0x802c6a,%rax
  801cda:	00 00 00 
  801cdd:	ff d0                	call   *%rax
  801cdf:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801ce6:	00 00 
  801ce8:	e9 73 ff ff ff       	jmp    801c60 <fsipc+0x24>

0000000000801ced <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801ced:	f3 0f 1e fa          	endbr64
  801cf1:	55                   	push   %rbp
  801cf2:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cf5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801cfc:	00 00 00 
  801cff:	8b 57 0c             	mov    0xc(%rdi),%edx
  801d02:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801d04:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801d07:	be 00 00 00 00       	mov    $0x0,%esi
  801d0c:	bf 02 00 00 00       	mov    $0x2,%edi
  801d11:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	call   *%rax
}
  801d1d:	5d                   	pop    %rbp
  801d1e:	c3                   	ret

0000000000801d1f <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801d1f:	f3 0f 1e fa          	endbr64
  801d23:	55                   	push   %rbp
  801d24:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d27:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d2a:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d31:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801d33:	be 00 00 00 00       	mov    $0x0,%esi
  801d38:	bf 06 00 00 00       	mov    $0x6,%edi
  801d3d:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  801d44:	00 00 00 
  801d47:	ff d0                	call   *%rax
}
  801d49:	5d                   	pop    %rbp
  801d4a:	c3                   	ret

0000000000801d4b <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801d4b:	f3 0f 1e fa          	endbr64
  801d4f:	55                   	push   %rbp
  801d50:	48 89 e5             	mov    %rsp,%rbp
  801d53:	41 54                	push   %r12
  801d55:	53                   	push   %rbx
  801d56:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d59:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d5c:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d63:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801d65:	be 00 00 00 00       	mov    $0x0,%esi
  801d6a:	bf 05 00 00 00       	mov    $0x5,%edi
  801d6f:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  801d76:	00 00 00 
  801d79:	ff d0                	call   *%rax
    if (res < 0) return res;
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	78 3d                	js     801dbc <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d7f:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  801d86:	00 00 00 
  801d89:	4c 89 e6             	mov    %r12,%rsi
  801d8c:	48 89 df             	mov    %rbx,%rdi
  801d8f:	48 b8 38 0b 80 00 00 	movabs $0x800b38,%rax
  801d96:	00 00 00 
  801d99:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801d9b:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801da2:	00 
  801da3:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801da9:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801db0:	00 
  801db1:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbc:	5b                   	pop    %rbx
  801dbd:	41 5c                	pop    %r12
  801dbf:	5d                   	pop    %rbp
  801dc0:	c3                   	ret

0000000000801dc1 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801dc1:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801dc5:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801dcc:	77 41                	ja     801e0f <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801dce:	55                   	push   %rbp
  801dcf:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801dd2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801dd9:	00 00 00 
  801ddc:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801ddf:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  801de1:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801de5:	48 8d 78 10          	lea    0x10(%rax),%rdi
  801de9:	48 b8 53 0d 80 00 00 	movabs $0x800d53,%rax
  801df0:	00 00 00 
  801df3:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  801df5:	be 00 00 00 00       	mov    $0x0,%esi
  801dfa:	bf 04 00 00 00       	mov    $0x4,%edi
  801dff:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  801e06:	00 00 00 
  801e09:	ff d0                	call   *%rax
  801e0b:	48 98                	cltq
}
  801e0d:	5d                   	pop    %rbp
  801e0e:	c3                   	ret
        return -E_INVAL;
  801e0f:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  801e16:	c3                   	ret

0000000000801e17 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801e17:	f3 0f 1e fa          	endbr64
  801e1b:	55                   	push   %rbp
  801e1c:	48 89 e5             	mov    %rsp,%rbp
  801e1f:	41 55                	push   %r13
  801e21:	41 54                	push   %r12
  801e23:	53                   	push   %rbx
  801e24:	48 83 ec 08          	sub    $0x8,%rsp
  801e28:	49 89 f4             	mov    %rsi,%r12
  801e2b:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e2e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e35:	00 00 00 
  801e38:	8b 57 0c             	mov    0xc(%rdi),%edx
  801e3b:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  801e3d:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  801e41:	be 00 00 00 00       	mov    $0x0,%esi
  801e46:	bf 03 00 00 00       	mov    $0x3,%edi
  801e4b:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  801e52:	00 00 00 
  801e55:	ff d0                	call   *%rax
  801e57:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  801e5a:	4d 85 ed             	test   %r13,%r13
  801e5d:	78 2a                	js     801e89 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  801e5f:	4c 89 ea             	mov    %r13,%rdx
  801e62:	4c 39 eb             	cmp    %r13,%rbx
  801e65:	72 30                	jb     801e97 <devfile_read+0x80>
  801e67:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  801e6e:	7f 27                	jg     801e97 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  801e70:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801e77:	00 00 00 
  801e7a:	4c 89 e7             	mov    %r12,%rdi
  801e7d:	48 b8 53 0d 80 00 00 	movabs $0x800d53,%rax
  801e84:	00 00 00 
  801e87:	ff d0                	call   *%rax
}
  801e89:	4c 89 e8             	mov    %r13,%rax
  801e8c:	48 83 c4 08          	add    $0x8,%rsp
  801e90:	5b                   	pop    %rbx
  801e91:	41 5c                	pop    %r12
  801e93:	41 5d                	pop    %r13
  801e95:	5d                   	pop    %rbp
  801e96:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801e97:	48 b9 e4 31 80 00 00 	movabs $0x8031e4,%rcx
  801e9e:	00 00 00 
  801ea1:	48 ba 01 32 80 00 00 	movabs $0x803201,%rdx
  801ea8:	00 00 00 
  801eab:	be 7b 00 00 00       	mov    $0x7b,%esi
  801eb0:	48 bf 16 32 80 00 00 	movabs $0x803216,%rdi
  801eb7:	00 00 00 
  801eba:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebf:	49 b8 68 2a 80 00 00 	movabs $0x802a68,%r8
  801ec6:	00 00 00 
  801ec9:	41 ff d0             	call   *%r8

0000000000801ecc <open>:
open(const char *path, int mode) {
  801ecc:	f3 0f 1e fa          	endbr64
  801ed0:	55                   	push   %rbp
  801ed1:	48 89 e5             	mov    %rsp,%rbp
  801ed4:	41 55                	push   %r13
  801ed6:	41 54                	push   %r12
  801ed8:	53                   	push   %rbx
  801ed9:	48 83 ec 18          	sub    $0x18,%rsp
  801edd:	49 89 fc             	mov    %rdi,%r12
  801ee0:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801ee3:	48 b8 f3 0a 80 00 00 	movabs $0x800af3,%rax
  801eea:	00 00 00 
  801eed:	ff d0                	call   *%rax
  801eef:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801ef5:	0f 87 8a 00 00 00    	ja     801f85 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801efb:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801eff:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  801f06:	00 00 00 
  801f09:	ff d0                	call   *%rax
  801f0b:	89 c3                	mov    %eax,%ebx
  801f0d:	85 c0                	test   %eax,%eax
  801f0f:	78 50                	js     801f61 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  801f11:	4c 89 e6             	mov    %r12,%rsi
  801f14:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801f1b:	00 00 00 
  801f1e:	48 89 df             	mov    %rbx,%rdi
  801f21:	48 b8 38 0b 80 00 00 	movabs $0x800b38,%rax
  801f28:	00 00 00 
  801f2b:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801f2d:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f34:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801f38:	bf 01 00 00 00       	mov    $0x1,%edi
  801f3d:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  801f44:	00 00 00 
  801f47:	ff d0                	call   *%rax
  801f49:	89 c3                	mov    %eax,%ebx
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	78 1f                	js     801f6e <open+0xa2>
    return fd2num(fd);
  801f4f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f53:	48 b8 01 15 80 00 00 	movabs $0x801501,%rax
  801f5a:	00 00 00 
  801f5d:	ff d0                	call   *%rax
  801f5f:	89 c3                	mov    %eax,%ebx
}
  801f61:	89 d8                	mov    %ebx,%eax
  801f63:	48 83 c4 18          	add    $0x18,%rsp
  801f67:	5b                   	pop    %rbx
  801f68:	41 5c                	pop    %r12
  801f6a:	41 5d                	pop    %r13
  801f6c:	5d                   	pop    %rbp
  801f6d:	c3                   	ret
        fd_close(fd, 0);
  801f6e:	be 00 00 00 00       	mov    $0x0,%esi
  801f73:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f77:	48 b8 5e 16 80 00 00 	movabs $0x80165e,%rax
  801f7e:	00 00 00 
  801f81:	ff d0                	call   *%rax
        return res;
  801f83:	eb dc                	jmp    801f61 <open+0x95>
        return -E_BAD_PATH;
  801f85:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801f8a:	eb d5                	jmp    801f61 <open+0x95>

0000000000801f8c <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801f8c:	f3 0f 1e fa          	endbr64
  801f90:	55                   	push   %rbp
  801f91:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801f94:	be 00 00 00 00       	mov    $0x0,%esi
  801f99:	bf 08 00 00 00       	mov    $0x8,%edi
  801f9e:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  801fa5:	00 00 00 
  801fa8:	ff d0                	call   *%rax
}
  801faa:	5d                   	pop    %rbp
  801fab:	c3                   	ret

0000000000801fac <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801fac:	f3 0f 1e fa          	endbr64
  801fb0:	55                   	push   %rbp
  801fb1:	48 89 e5             	mov    %rsp,%rbp
  801fb4:	41 54                	push   %r12
  801fb6:	53                   	push   %rbx
  801fb7:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801fba:	48 b8 17 15 80 00 00 	movabs $0x801517,%rax
  801fc1:	00 00 00 
  801fc4:	ff d0                	call   *%rax
  801fc6:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801fc9:	48 be 21 32 80 00 00 	movabs $0x803221,%rsi
  801fd0:	00 00 00 
  801fd3:	48 89 df             	mov    %rbx,%rdi
  801fd6:	48 b8 38 0b 80 00 00 	movabs $0x800b38,%rax
  801fdd:	00 00 00 
  801fe0:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801fe2:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801fe7:	41 2b 04 24          	sub    (%r12),%eax
  801feb:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801ff1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ff8:	00 00 00 
    stat->st_dev = &devpipe;
  801ffb:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802002:	00 00 00 
  802005:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80200c:	b8 00 00 00 00       	mov    $0x0,%eax
  802011:	5b                   	pop    %rbx
  802012:	41 5c                	pop    %r12
  802014:	5d                   	pop    %rbp
  802015:	c3                   	ret

0000000000802016 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802016:	f3 0f 1e fa          	endbr64
  80201a:	55                   	push   %rbp
  80201b:	48 89 e5             	mov    %rsp,%rbp
  80201e:	41 54                	push   %r12
  802020:	53                   	push   %rbx
  802021:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802024:	ba 00 10 00 00       	mov    $0x1000,%edx
  802029:	48 89 fe             	mov    %rdi,%rsi
  80202c:	bf 00 00 00 00       	mov    $0x0,%edi
  802031:	49 bc 7d 12 80 00 00 	movabs $0x80127d,%r12
  802038:	00 00 00 
  80203b:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80203e:	48 89 df             	mov    %rbx,%rdi
  802041:	48 b8 17 15 80 00 00 	movabs $0x801517,%rax
  802048:	00 00 00 
  80204b:	ff d0                	call   *%rax
  80204d:	48 89 c6             	mov    %rax,%rsi
  802050:	ba 00 10 00 00       	mov    $0x1000,%edx
  802055:	bf 00 00 00 00       	mov    $0x0,%edi
  80205a:	41 ff d4             	call   *%r12
}
  80205d:	5b                   	pop    %rbx
  80205e:	41 5c                	pop    %r12
  802060:	5d                   	pop    %rbp
  802061:	c3                   	ret

0000000000802062 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802062:	f3 0f 1e fa          	endbr64
  802066:	55                   	push   %rbp
  802067:	48 89 e5             	mov    %rsp,%rbp
  80206a:	41 57                	push   %r15
  80206c:	41 56                	push   %r14
  80206e:	41 55                	push   %r13
  802070:	41 54                	push   %r12
  802072:	53                   	push   %rbx
  802073:	48 83 ec 18          	sub    $0x18,%rsp
  802077:	49 89 fc             	mov    %rdi,%r12
  80207a:	49 89 f5             	mov    %rsi,%r13
  80207d:	49 89 d7             	mov    %rdx,%r15
  802080:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802084:	48 b8 17 15 80 00 00 	movabs $0x801517,%rax
  80208b:	00 00 00 
  80208e:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802090:	4d 85 ff             	test   %r15,%r15
  802093:	0f 84 af 00 00 00    	je     802148 <devpipe_write+0xe6>
  802099:	48 89 c3             	mov    %rax,%rbx
  80209c:	4c 89 f8             	mov    %r15,%rax
  80209f:	4d 89 ef             	mov    %r13,%r15
  8020a2:	4c 01 e8             	add    %r13,%rax
  8020a5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8020a9:	49 bd 0d 11 80 00 00 	movabs $0x80110d,%r13
  8020b0:	00 00 00 
            sys_yield();
  8020b3:	49 be a2 10 80 00 00 	movabs $0x8010a2,%r14
  8020ba:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8020bd:	8b 73 04             	mov    0x4(%rbx),%esi
  8020c0:	48 63 ce             	movslq %esi,%rcx
  8020c3:	48 63 03             	movslq (%rbx),%rax
  8020c6:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8020cc:	48 39 c1             	cmp    %rax,%rcx
  8020cf:	72 2e                	jb     8020ff <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8020d1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020d6:	48 89 da             	mov    %rbx,%rdx
  8020d9:	be 00 10 00 00       	mov    $0x1000,%esi
  8020de:	4c 89 e7             	mov    %r12,%rdi
  8020e1:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	74 66                	je     80214e <devpipe_write+0xec>
            sys_yield();
  8020e8:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8020eb:	8b 73 04             	mov    0x4(%rbx),%esi
  8020ee:	48 63 ce             	movslq %esi,%rcx
  8020f1:	48 63 03             	movslq (%rbx),%rax
  8020f4:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8020fa:	48 39 c1             	cmp    %rax,%rcx
  8020fd:	73 d2                	jae    8020d1 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020ff:	41 0f b6 3f          	movzbl (%r15),%edi
  802103:	48 89 ca             	mov    %rcx,%rdx
  802106:	48 c1 ea 03          	shr    $0x3,%rdx
  80210a:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802111:	08 10 20 
  802114:	48 f7 e2             	mul    %rdx
  802117:	48 c1 ea 06          	shr    $0x6,%rdx
  80211b:	48 89 d0             	mov    %rdx,%rax
  80211e:	48 c1 e0 09          	shl    $0x9,%rax
  802122:	48 29 d0             	sub    %rdx,%rax
  802125:	48 c1 e0 03          	shl    $0x3,%rax
  802129:	48 29 c1             	sub    %rax,%rcx
  80212c:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802131:	83 c6 01             	add    $0x1,%esi
  802134:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802137:	49 83 c7 01          	add    $0x1,%r15
  80213b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80213f:	49 39 c7             	cmp    %rax,%r15
  802142:	0f 85 75 ff ff ff    	jne    8020bd <devpipe_write+0x5b>
    return n;
  802148:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80214c:	eb 05                	jmp    802153 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  80214e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802153:	48 83 c4 18          	add    $0x18,%rsp
  802157:	5b                   	pop    %rbx
  802158:	41 5c                	pop    %r12
  80215a:	41 5d                	pop    %r13
  80215c:	41 5e                	pop    %r14
  80215e:	41 5f                	pop    %r15
  802160:	5d                   	pop    %rbp
  802161:	c3                   	ret

0000000000802162 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802162:	f3 0f 1e fa          	endbr64
  802166:	55                   	push   %rbp
  802167:	48 89 e5             	mov    %rsp,%rbp
  80216a:	41 57                	push   %r15
  80216c:	41 56                	push   %r14
  80216e:	41 55                	push   %r13
  802170:	41 54                	push   %r12
  802172:	53                   	push   %rbx
  802173:	48 83 ec 18          	sub    $0x18,%rsp
  802177:	49 89 fc             	mov    %rdi,%r12
  80217a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80217e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802182:	48 b8 17 15 80 00 00 	movabs $0x801517,%rax
  802189:	00 00 00 
  80218c:	ff d0                	call   *%rax
  80218e:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802191:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802197:	49 bd 0d 11 80 00 00 	movabs $0x80110d,%r13
  80219e:	00 00 00 
            sys_yield();
  8021a1:	49 be a2 10 80 00 00 	movabs $0x8010a2,%r14
  8021a8:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8021ab:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8021b0:	74 7d                	je     80222f <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8021b2:	8b 03                	mov    (%rbx),%eax
  8021b4:	3b 43 04             	cmp    0x4(%rbx),%eax
  8021b7:	75 26                	jne    8021df <devpipe_read+0x7d>
            if (i > 0) return i;
  8021b9:	4d 85 ff             	test   %r15,%r15
  8021bc:	75 77                	jne    802235 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021be:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021c3:	48 89 da             	mov    %rbx,%rdx
  8021c6:	be 00 10 00 00       	mov    $0x1000,%esi
  8021cb:	4c 89 e7             	mov    %r12,%rdi
  8021ce:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8021d1:	85 c0                	test   %eax,%eax
  8021d3:	74 72                	je     802247 <devpipe_read+0xe5>
            sys_yield();
  8021d5:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8021d8:	8b 03                	mov    (%rbx),%eax
  8021da:	3b 43 04             	cmp    0x4(%rbx),%eax
  8021dd:	74 df                	je     8021be <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021df:	48 63 c8             	movslq %eax,%rcx
  8021e2:	48 89 ca             	mov    %rcx,%rdx
  8021e5:	48 c1 ea 03          	shr    $0x3,%rdx
  8021e9:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8021f0:	08 10 20 
  8021f3:	48 89 d0             	mov    %rdx,%rax
  8021f6:	48 f7 e6             	mul    %rsi
  8021f9:	48 c1 ea 06          	shr    $0x6,%rdx
  8021fd:	48 89 d0             	mov    %rdx,%rax
  802200:	48 c1 e0 09          	shl    $0x9,%rax
  802204:	48 29 d0             	sub    %rdx,%rax
  802207:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80220e:	00 
  80220f:	48 89 c8             	mov    %rcx,%rax
  802212:	48 29 d0             	sub    %rdx,%rax
  802215:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80221a:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80221e:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802222:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802225:	49 83 c7 01          	add    $0x1,%r15
  802229:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80222d:	75 83                	jne    8021b2 <devpipe_read+0x50>
    return n;
  80222f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802233:	eb 03                	jmp    802238 <devpipe_read+0xd6>
            if (i > 0) return i;
  802235:	4c 89 f8             	mov    %r15,%rax
}
  802238:	48 83 c4 18          	add    $0x18,%rsp
  80223c:	5b                   	pop    %rbx
  80223d:	41 5c                	pop    %r12
  80223f:	41 5d                	pop    %r13
  802241:	41 5e                	pop    %r14
  802243:	41 5f                	pop    %r15
  802245:	5d                   	pop    %rbp
  802246:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802247:	b8 00 00 00 00       	mov    $0x0,%eax
  80224c:	eb ea                	jmp    802238 <devpipe_read+0xd6>

000000000080224e <pipe>:
pipe(int pfd[2]) {
  80224e:	f3 0f 1e fa          	endbr64
  802252:	55                   	push   %rbp
  802253:	48 89 e5             	mov    %rsp,%rbp
  802256:	41 55                	push   %r13
  802258:	41 54                	push   %r12
  80225a:	53                   	push   %rbx
  80225b:	48 83 ec 18          	sub    $0x18,%rsp
  80225f:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802262:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802266:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  80226d:	00 00 00 
  802270:	ff d0                	call   *%rax
  802272:	89 c3                	mov    %eax,%ebx
  802274:	85 c0                	test   %eax,%eax
  802276:	0f 88 a0 01 00 00    	js     80241c <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80227c:	b9 46 00 00 00       	mov    $0x46,%ecx
  802281:	ba 00 10 00 00       	mov    $0x1000,%edx
  802286:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80228a:	bf 00 00 00 00       	mov    $0x0,%edi
  80228f:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  802296:	00 00 00 
  802299:	ff d0                	call   *%rax
  80229b:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80229d:	85 c0                	test   %eax,%eax
  80229f:	0f 88 77 01 00 00    	js     80241c <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8022a5:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8022a9:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  8022b0:	00 00 00 
  8022b3:	ff d0                	call   *%rax
  8022b5:	89 c3                	mov    %eax,%ebx
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	0f 88 43 01 00 00    	js     802402 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8022bf:	b9 46 00 00 00       	mov    $0x46,%ecx
  8022c4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022c9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d2:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  8022d9:	00 00 00 
  8022dc:	ff d0                	call   *%rax
  8022de:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	0f 88 1a 01 00 00    	js     802402 <pipe+0x1b4>
    va = fd2data(fd0);
  8022e8:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022ec:	48 b8 17 15 80 00 00 	movabs $0x801517,%rax
  8022f3:	00 00 00 
  8022f6:	ff d0                	call   *%rax
  8022f8:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8022fb:	b9 46 00 00 00       	mov    $0x46,%ecx
  802300:	ba 00 10 00 00       	mov    $0x1000,%edx
  802305:	48 89 c6             	mov    %rax,%rsi
  802308:	bf 00 00 00 00       	mov    $0x0,%edi
  80230d:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  802314:	00 00 00 
  802317:	ff d0                	call   *%rax
  802319:	89 c3                	mov    %eax,%ebx
  80231b:	85 c0                	test   %eax,%eax
  80231d:	0f 88 c5 00 00 00    	js     8023e8 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802323:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802327:	48 b8 17 15 80 00 00 	movabs $0x801517,%rax
  80232e:	00 00 00 
  802331:	ff d0                	call   *%rax
  802333:	48 89 c1             	mov    %rax,%rcx
  802336:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80233c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802342:	ba 00 00 00 00       	mov    $0x0,%edx
  802347:	4c 89 ee             	mov    %r13,%rsi
  80234a:	bf 00 00 00 00       	mov    $0x0,%edi
  80234f:	48 b8 a8 11 80 00 00 	movabs $0x8011a8,%rax
  802356:	00 00 00 
  802359:	ff d0                	call   *%rax
  80235b:	89 c3                	mov    %eax,%ebx
  80235d:	85 c0                	test   %eax,%eax
  80235f:	78 6e                	js     8023cf <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802361:	be 00 10 00 00       	mov    $0x1000,%esi
  802366:	4c 89 ef             	mov    %r13,%rdi
  802369:	48 b8 d7 10 80 00 00 	movabs $0x8010d7,%rax
  802370:	00 00 00 
  802373:	ff d0                	call   *%rax
  802375:	83 f8 02             	cmp    $0x2,%eax
  802378:	0f 85 ab 00 00 00    	jne    802429 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  80237e:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802385:	00 00 
  802387:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80238b:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80238d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802391:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802398:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80239c:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80239e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023a2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8023a9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023ad:	48 bb 01 15 80 00 00 	movabs $0x801501,%rbx
  8023b4:	00 00 00 
  8023b7:	ff d3                	call   *%rbx
  8023b9:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8023bd:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8023c1:	ff d3                	call   *%rbx
  8023c3:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8023c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023cd:	eb 4d                	jmp    80241c <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8023cf:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023d4:	4c 89 ee             	mov    %r13,%rsi
  8023d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8023dc:	48 b8 7d 12 80 00 00 	movabs $0x80127d,%rax
  8023e3:	00 00 00 
  8023e6:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8023e8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023ed:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f6:	48 b8 7d 12 80 00 00 	movabs $0x80127d,%rax
  8023fd:	00 00 00 
  802400:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802402:	ba 00 10 00 00       	mov    $0x1000,%edx
  802407:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80240b:	bf 00 00 00 00       	mov    $0x0,%edi
  802410:	48 b8 7d 12 80 00 00 	movabs $0x80127d,%rax
  802417:	00 00 00 
  80241a:	ff d0                	call   *%rax
}
  80241c:	89 d8                	mov    %ebx,%eax
  80241e:	48 83 c4 18          	add    $0x18,%rsp
  802422:	5b                   	pop    %rbx
  802423:	41 5c                	pop    %r12
  802425:	41 5d                	pop    %r13
  802427:	5d                   	pop    %rbp
  802428:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802429:	48 b9 48 36 80 00 00 	movabs $0x803648,%rcx
  802430:	00 00 00 
  802433:	48 ba 01 32 80 00 00 	movabs $0x803201,%rdx
  80243a:	00 00 00 
  80243d:	be 2e 00 00 00       	mov    $0x2e,%esi
  802442:	48 bf 28 32 80 00 00 	movabs $0x803228,%rdi
  802449:	00 00 00 
  80244c:	b8 00 00 00 00       	mov    $0x0,%eax
  802451:	49 b8 68 2a 80 00 00 	movabs $0x802a68,%r8
  802458:	00 00 00 
  80245b:	41 ff d0             	call   *%r8

000000000080245e <pipeisclosed>:
pipeisclosed(int fdnum) {
  80245e:	f3 0f 1e fa          	endbr64
  802462:	55                   	push   %rbp
  802463:	48 89 e5             	mov    %rsp,%rbp
  802466:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80246a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80246e:	48 b8 9b 15 80 00 00 	movabs $0x80159b,%rax
  802475:	00 00 00 
  802478:	ff d0                	call   *%rax
    if (res < 0) return res;
  80247a:	85 c0                	test   %eax,%eax
  80247c:	78 35                	js     8024b3 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80247e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802482:	48 b8 17 15 80 00 00 	movabs $0x801517,%rax
  802489:	00 00 00 
  80248c:	ff d0                	call   *%rax
  80248e:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802491:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802496:	be 00 10 00 00       	mov    $0x1000,%esi
  80249b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80249f:	48 b8 0d 11 80 00 00 	movabs $0x80110d,%rax
  8024a6:	00 00 00 
  8024a9:	ff d0                	call   *%rax
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	0f 94 c0             	sete   %al
  8024b0:	0f b6 c0             	movzbl %al,%eax
}
  8024b3:	c9                   	leave
  8024b4:	c3                   	ret

00000000008024b5 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8024b5:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8024b9:	48 89 f8             	mov    %rdi,%rax
  8024bc:	48 c1 e8 27          	shr    $0x27,%rax
  8024c0:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8024c7:	7f 00 00 
  8024ca:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024ce:	f6 c2 01             	test   $0x1,%dl
  8024d1:	74 6d                	je     802540 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8024d3:	48 89 f8             	mov    %rdi,%rax
  8024d6:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024da:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8024e1:	7f 00 00 
  8024e4:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024e8:	f6 c2 01             	test   $0x1,%dl
  8024eb:	74 62                	je     80254f <get_uvpt_entry+0x9a>
  8024ed:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8024f4:	7f 00 00 
  8024f7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024fb:	f6 c2 80             	test   $0x80,%dl
  8024fe:	75 4f                	jne    80254f <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802500:	48 89 f8             	mov    %rdi,%rax
  802503:	48 c1 e8 15          	shr    $0x15,%rax
  802507:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80250e:	7f 00 00 
  802511:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802515:	f6 c2 01             	test   $0x1,%dl
  802518:	74 44                	je     80255e <get_uvpt_entry+0xa9>
  80251a:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802521:	7f 00 00 
  802524:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802528:	f6 c2 80             	test   $0x80,%dl
  80252b:	75 31                	jne    80255e <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80252d:	48 c1 ef 0c          	shr    $0xc,%rdi
  802531:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802538:	7f 00 00 
  80253b:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80253f:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802540:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802547:	7f 00 00 
  80254a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80254e:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80254f:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802556:	7f 00 00 
  802559:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80255d:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80255e:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802565:	7f 00 00 
  802568:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80256c:	c3                   	ret

000000000080256d <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  80256d:	f3 0f 1e fa          	endbr64
  802571:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802574:	48 89 f9             	mov    %rdi,%rcx
  802577:	48 c1 e9 27          	shr    $0x27,%rcx
  80257b:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802582:	7f 00 00 
  802585:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802589:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802590:	f6 c1 01             	test   $0x1,%cl
  802593:	0f 84 b2 00 00 00    	je     80264b <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802599:	48 89 f9             	mov    %rdi,%rcx
  80259c:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8025a0:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8025a7:	7f 00 00 
  8025aa:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8025ae:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8025b5:	40 f6 c6 01          	test   $0x1,%sil
  8025b9:	0f 84 8c 00 00 00    	je     80264b <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8025bf:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8025c6:	7f 00 00 
  8025c9:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8025cd:	a8 80                	test   $0x80,%al
  8025cf:	75 7b                	jne    80264c <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8025d1:	48 89 f9             	mov    %rdi,%rcx
  8025d4:	48 c1 e9 15          	shr    $0x15,%rcx
  8025d8:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8025df:	7f 00 00 
  8025e2:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8025e6:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  8025ed:	40 f6 c6 01          	test   $0x1,%sil
  8025f1:	74 58                	je     80264b <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  8025f3:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8025fa:	7f 00 00 
  8025fd:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802601:	a8 80                	test   $0x80,%al
  802603:	75 6c                	jne    802671 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802605:	48 89 f9             	mov    %rdi,%rcx
  802608:	48 c1 e9 0c          	shr    $0xc,%rcx
  80260c:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802613:	7f 00 00 
  802616:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80261a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802621:	40 f6 c6 01          	test   $0x1,%sil
  802625:	74 24                	je     80264b <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802627:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80262e:	7f 00 00 
  802631:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802635:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80263c:	ff ff 7f 
  80263f:	48 21 c8             	and    %rcx,%rax
  802642:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802648:	48 09 d0             	or     %rdx,%rax
}
  80264b:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  80264c:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802653:	7f 00 00 
  802656:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80265a:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802661:	ff ff 7f 
  802664:	48 21 c8             	and    %rcx,%rax
  802667:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  80266d:	48 01 d0             	add    %rdx,%rax
  802670:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802671:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802678:	7f 00 00 
  80267b:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80267f:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802686:	ff ff 7f 
  802689:	48 21 c8             	and    %rcx,%rax
  80268c:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802692:	48 01 d0             	add    %rdx,%rax
  802695:	c3                   	ret

0000000000802696 <get_prot>:

int
get_prot(void *va) {
  802696:	f3 0f 1e fa          	endbr64
  80269a:	55                   	push   %rbp
  80269b:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80269e:	48 b8 b5 24 80 00 00 	movabs $0x8024b5,%rax
  8026a5:	00 00 00 
  8026a8:	ff d0                	call   *%rax
  8026aa:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8026ad:	83 e0 01             	and    $0x1,%eax
  8026b0:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8026b3:	89 d1                	mov    %edx,%ecx
  8026b5:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8026bb:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8026bd:	89 c1                	mov    %eax,%ecx
  8026bf:	83 c9 02             	or     $0x2,%ecx
  8026c2:	f6 c2 02             	test   $0x2,%dl
  8026c5:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8026c8:	89 c1                	mov    %eax,%ecx
  8026ca:	83 c9 01             	or     $0x1,%ecx
  8026cd:	48 85 d2             	test   %rdx,%rdx
  8026d0:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8026d3:	89 c1                	mov    %eax,%ecx
  8026d5:	83 c9 40             	or     $0x40,%ecx
  8026d8:	f6 c6 04             	test   $0x4,%dh
  8026db:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8026de:	5d                   	pop    %rbp
  8026df:	c3                   	ret

00000000008026e0 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8026e0:	f3 0f 1e fa          	endbr64
  8026e4:	55                   	push   %rbp
  8026e5:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8026e8:	48 b8 b5 24 80 00 00 	movabs $0x8024b5,%rax
  8026ef:	00 00 00 
  8026f2:	ff d0                	call   *%rax
    return pte & PTE_D;
  8026f4:	48 c1 e8 06          	shr    $0x6,%rax
  8026f8:	83 e0 01             	and    $0x1,%eax
}
  8026fb:	5d                   	pop    %rbp
  8026fc:	c3                   	ret

00000000008026fd <is_page_present>:

bool
is_page_present(void *va) {
  8026fd:	f3 0f 1e fa          	endbr64
  802701:	55                   	push   %rbp
  802702:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802705:	48 b8 b5 24 80 00 00 	movabs $0x8024b5,%rax
  80270c:	00 00 00 
  80270f:	ff d0                	call   *%rax
  802711:	83 e0 01             	and    $0x1,%eax
}
  802714:	5d                   	pop    %rbp
  802715:	c3                   	ret

0000000000802716 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802716:	f3 0f 1e fa          	endbr64
  80271a:	55                   	push   %rbp
  80271b:	48 89 e5             	mov    %rsp,%rbp
  80271e:	41 57                	push   %r15
  802720:	41 56                	push   %r14
  802722:	41 55                	push   %r13
  802724:	41 54                	push   %r12
  802726:	53                   	push   %rbx
  802727:	48 83 ec 18          	sub    $0x18,%rsp
  80272b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80272f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802733:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802738:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  80273f:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802742:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802749:	7f 00 00 
    while (va < USER_STACK_TOP) {
  80274c:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802753:	00 00 00 
  802756:	eb 73                	jmp    8027cb <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802758:	48 89 d8             	mov    %rbx,%rax
  80275b:	48 c1 e8 15          	shr    $0x15,%rax
  80275f:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802766:	7f 00 00 
  802769:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  80276d:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802773:	f6 c2 01             	test   $0x1,%dl
  802776:	74 4b                	je     8027c3 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802778:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  80277c:	f6 c2 80             	test   $0x80,%dl
  80277f:	74 11                	je     802792 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802781:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802785:	f6 c4 04             	test   $0x4,%ah
  802788:	74 39                	je     8027c3 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  80278a:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802790:	eb 20                	jmp    8027b2 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802792:	48 89 da             	mov    %rbx,%rdx
  802795:	48 c1 ea 0c          	shr    $0xc,%rdx
  802799:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8027a0:	7f 00 00 
  8027a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  8027a7:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8027ad:	f6 c4 04             	test   $0x4,%ah
  8027b0:	74 11                	je     8027c3 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  8027b2:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  8027b6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8027ba:	48 89 df             	mov    %rbx,%rdi
  8027bd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8027c1:	ff d0                	call   *%rax
    next:
        va += size;
  8027c3:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  8027c6:	49 39 df             	cmp    %rbx,%r15
  8027c9:	72 3e                	jb     802809 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8027cb:	49 8b 06             	mov    (%r14),%rax
  8027ce:	a8 01                	test   $0x1,%al
  8027d0:	74 37                	je     802809 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8027d2:	48 89 d8             	mov    %rbx,%rax
  8027d5:	48 c1 e8 1e          	shr    $0x1e,%rax
  8027d9:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  8027de:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8027e4:	f6 c2 01             	test   $0x1,%dl
  8027e7:	74 da                	je     8027c3 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  8027e9:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  8027ee:	f6 c2 80             	test   $0x80,%dl
  8027f1:	0f 84 61 ff ff ff    	je     802758 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  8027f7:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8027fc:	f6 c4 04             	test   $0x4,%ah
  8027ff:	74 c2                	je     8027c3 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802801:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802807:	eb a9                	jmp    8027b2 <foreach_shared_region+0x9c>
    }
    return res;
}
  802809:	b8 00 00 00 00       	mov    $0x0,%eax
  80280e:	48 83 c4 18          	add    $0x18,%rsp
  802812:	5b                   	pop    %rbx
  802813:	41 5c                	pop    %r12
  802815:	41 5d                	pop    %r13
  802817:	41 5e                	pop    %r14
  802819:	41 5f                	pop    %r15
  80281b:	5d                   	pop    %rbp
  80281c:	c3                   	ret

000000000080281d <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  80281d:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802821:	b8 00 00 00 00       	mov    $0x0,%eax
  802826:	c3                   	ret

0000000000802827 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802827:	f3 0f 1e fa          	endbr64
  80282b:	55                   	push   %rbp
  80282c:	48 89 e5             	mov    %rsp,%rbp
  80282f:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802832:	48 be 38 32 80 00 00 	movabs $0x803238,%rsi
  802839:	00 00 00 
  80283c:	48 b8 38 0b 80 00 00 	movabs $0x800b38,%rax
  802843:	00 00 00 
  802846:	ff d0                	call   *%rax
    return 0;
}
  802848:	b8 00 00 00 00       	mov    $0x0,%eax
  80284d:	5d                   	pop    %rbp
  80284e:	c3                   	ret

000000000080284f <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80284f:	f3 0f 1e fa          	endbr64
  802853:	55                   	push   %rbp
  802854:	48 89 e5             	mov    %rsp,%rbp
  802857:	41 57                	push   %r15
  802859:	41 56                	push   %r14
  80285b:	41 55                	push   %r13
  80285d:	41 54                	push   %r12
  80285f:	53                   	push   %rbx
  802860:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802867:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  80286e:	48 85 d2             	test   %rdx,%rdx
  802871:	74 7a                	je     8028ed <devcons_write+0x9e>
  802873:	49 89 d6             	mov    %rdx,%r14
  802876:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80287c:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802881:	49 bf 53 0d 80 00 00 	movabs $0x800d53,%r15
  802888:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  80288b:	4c 89 f3             	mov    %r14,%rbx
  80288e:	48 29 f3             	sub    %rsi,%rbx
  802891:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802896:	48 39 c3             	cmp    %rax,%rbx
  802899:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  80289d:	4c 63 eb             	movslq %ebx,%r13
  8028a0:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8028a7:	48 01 c6             	add    %rax,%rsi
  8028aa:	4c 89 ea             	mov    %r13,%rdx
  8028ad:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8028b4:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8028b7:	4c 89 ee             	mov    %r13,%rsi
  8028ba:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8028c1:	48 b8 98 0f 80 00 00 	movabs $0x800f98,%rax
  8028c8:	00 00 00 
  8028cb:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8028cd:	41 01 dc             	add    %ebx,%r12d
  8028d0:	49 63 f4             	movslq %r12d,%rsi
  8028d3:	4c 39 f6             	cmp    %r14,%rsi
  8028d6:	72 b3                	jb     80288b <devcons_write+0x3c>
    return res;
  8028d8:	49 63 c4             	movslq %r12d,%rax
}
  8028db:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8028e2:	5b                   	pop    %rbx
  8028e3:	41 5c                	pop    %r12
  8028e5:	41 5d                	pop    %r13
  8028e7:	41 5e                	pop    %r14
  8028e9:	41 5f                	pop    %r15
  8028eb:	5d                   	pop    %rbp
  8028ec:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  8028ed:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8028f3:	eb e3                	jmp    8028d8 <devcons_write+0x89>

00000000008028f5 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8028f5:	f3 0f 1e fa          	endbr64
  8028f9:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8028fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802901:	48 85 c0             	test   %rax,%rax
  802904:	74 55                	je     80295b <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802906:	55                   	push   %rbp
  802907:	48 89 e5             	mov    %rsp,%rbp
  80290a:	41 55                	push   %r13
  80290c:	41 54                	push   %r12
  80290e:	53                   	push   %rbx
  80290f:	48 83 ec 08          	sub    $0x8,%rsp
  802913:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802916:	48 bb c9 0f 80 00 00 	movabs $0x800fc9,%rbx
  80291d:	00 00 00 
  802920:	49 bc a2 10 80 00 00 	movabs $0x8010a2,%r12
  802927:	00 00 00 
  80292a:	eb 03                	jmp    80292f <devcons_read+0x3a>
  80292c:	41 ff d4             	call   *%r12
  80292f:	ff d3                	call   *%rbx
  802931:	85 c0                	test   %eax,%eax
  802933:	74 f7                	je     80292c <devcons_read+0x37>
    if (c < 0) return c;
  802935:	48 63 d0             	movslq %eax,%rdx
  802938:	78 13                	js     80294d <devcons_read+0x58>
    if (c == 0x04) return 0;
  80293a:	ba 00 00 00 00       	mov    $0x0,%edx
  80293f:	83 f8 04             	cmp    $0x4,%eax
  802942:	74 09                	je     80294d <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802944:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802948:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80294d:	48 89 d0             	mov    %rdx,%rax
  802950:	48 83 c4 08          	add    $0x8,%rsp
  802954:	5b                   	pop    %rbx
  802955:	41 5c                	pop    %r12
  802957:	41 5d                	pop    %r13
  802959:	5d                   	pop    %rbp
  80295a:	c3                   	ret
  80295b:	48 89 d0             	mov    %rdx,%rax
  80295e:	c3                   	ret

000000000080295f <cputchar>:
cputchar(int ch) {
  80295f:	f3 0f 1e fa          	endbr64
  802963:	55                   	push   %rbp
  802964:	48 89 e5             	mov    %rsp,%rbp
  802967:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  80296b:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80296f:	be 01 00 00 00       	mov    $0x1,%esi
  802974:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802978:	48 b8 98 0f 80 00 00 	movabs $0x800f98,%rax
  80297f:	00 00 00 
  802982:	ff d0                	call   *%rax
}
  802984:	c9                   	leave
  802985:	c3                   	ret

0000000000802986 <getchar>:
getchar(void) {
  802986:	f3 0f 1e fa          	endbr64
  80298a:	55                   	push   %rbp
  80298b:	48 89 e5             	mov    %rsp,%rbp
  80298e:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802992:	ba 01 00 00 00       	mov    $0x1,%edx
  802997:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  80299b:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a0:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  8029a7:	00 00 00 
  8029aa:	ff d0                	call   *%rax
  8029ac:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	78 06                	js     8029b8 <getchar+0x32>
  8029b2:	74 08                	je     8029bc <getchar+0x36>
  8029b4:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8029b8:	89 d0                	mov    %edx,%eax
  8029ba:	c9                   	leave
  8029bb:	c3                   	ret
    return res < 0 ? res : res ? c :
  8029bc:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8029c1:	eb f5                	jmp    8029b8 <getchar+0x32>

00000000008029c3 <iscons>:
iscons(int fdnum) {
  8029c3:	f3 0f 1e fa          	endbr64
  8029c7:	55                   	push   %rbp
  8029c8:	48 89 e5             	mov    %rsp,%rbp
  8029cb:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8029cf:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8029d3:	48 b8 9b 15 80 00 00 	movabs $0x80159b,%rax
  8029da:	00 00 00 
  8029dd:	ff d0                	call   *%rax
    if (res < 0) return res;
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	78 18                	js     8029fb <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  8029e3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029e7:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8029ee:	00 00 00 
  8029f1:	8b 00                	mov    (%rax),%eax
  8029f3:	39 02                	cmp    %eax,(%rdx)
  8029f5:	0f 94 c0             	sete   %al
  8029f8:	0f b6 c0             	movzbl %al,%eax
}
  8029fb:	c9                   	leave
  8029fc:	c3                   	ret

00000000008029fd <opencons>:
opencons(void) {
  8029fd:	f3 0f 1e fa          	endbr64
  802a01:	55                   	push   %rbp
  802a02:	48 89 e5             	mov    %rsp,%rbp
  802a05:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802a09:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802a0d:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  802a14:	00 00 00 
  802a17:	ff d0                	call   *%rax
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	78 49                	js     802a66 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802a1d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802a22:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a27:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802a2b:	bf 00 00 00 00       	mov    $0x0,%edi
  802a30:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  802a37:	00 00 00 
  802a3a:	ff d0                	call   *%rax
  802a3c:	85 c0                	test   %eax,%eax
  802a3e:	78 26                	js     802a66 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802a40:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a44:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802a4b:	00 00 
  802a4d:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802a4f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802a53:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802a5a:	48 b8 01 15 80 00 00 	movabs $0x801501,%rax
  802a61:	00 00 00 
  802a64:	ff d0                	call   *%rax
}
  802a66:	c9                   	leave
  802a67:	c3                   	ret

0000000000802a68 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802a68:	f3 0f 1e fa          	endbr64
  802a6c:	55                   	push   %rbp
  802a6d:	48 89 e5             	mov    %rsp,%rbp
  802a70:	41 56                	push   %r14
  802a72:	41 55                	push   %r13
  802a74:	41 54                	push   %r12
  802a76:	53                   	push   %rbx
  802a77:	48 83 ec 50          	sub    $0x50,%rsp
  802a7b:	49 89 fc             	mov    %rdi,%r12
  802a7e:	41 89 f5             	mov    %esi,%r13d
  802a81:	48 89 d3             	mov    %rdx,%rbx
  802a84:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802a88:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802a8c:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802a90:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802a97:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a9b:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802a9f:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802aa3:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802aa7:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802aae:	00 00 00 
  802ab1:	4c 8b 30             	mov    (%rax),%r14
  802ab4:	48 b8 6d 10 80 00 00 	movabs $0x80106d,%rax
  802abb:	00 00 00 
  802abe:	ff d0                	call   *%rax
  802ac0:	89 c6                	mov    %eax,%esi
  802ac2:	45 89 e8             	mov    %r13d,%r8d
  802ac5:	4c 89 e1             	mov    %r12,%rcx
  802ac8:	4c 89 f2             	mov    %r14,%rdx
  802acb:	48 bf 70 36 80 00 00 	movabs $0x803670,%rdi
  802ad2:	00 00 00 
  802ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  802ada:	49 bc ef 01 80 00 00 	movabs $0x8001ef,%r12
  802ae1:	00 00 00 
  802ae4:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802ae7:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802aeb:	48 89 df             	mov    %rbx,%rdi
  802aee:	48 b8 87 01 80 00 00 	movabs $0x800187,%rax
  802af5:	00 00 00 
  802af8:	ff d0                	call   *%rax
    cprintf("\n");
  802afa:	48 bf 02 30 80 00 00 	movabs $0x803002,%rdi
  802b01:	00 00 00 
  802b04:	b8 00 00 00 00       	mov    $0x0,%eax
  802b09:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802b0c:	cc                   	int3
  802b0d:	eb fd                	jmp    802b0c <_panic+0xa4>

0000000000802b0f <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802b0f:	f3 0f 1e fa          	endbr64
  802b13:	55                   	push   %rbp
  802b14:	48 89 e5             	mov    %rsp,%rbp
  802b17:	41 54                	push   %r12
  802b19:	53                   	push   %rbx
  802b1a:	48 89 fb             	mov    %rdi,%rbx
  802b1d:	48 89 f7             	mov    %rsi,%rdi
  802b20:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b23:	48 85 f6             	test   %rsi,%rsi
  802b26:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b2d:	00 00 00 
  802b30:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b34:	be 00 10 00 00       	mov    $0x1000,%esi
  802b39:	48 b8 5f 14 80 00 00 	movabs $0x80145f,%rax
  802b40:	00 00 00 
  802b43:	ff d0                	call   *%rax
    if (res < 0) {
  802b45:	85 c0                	test   %eax,%eax
  802b47:	78 45                	js     802b8e <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b49:	48 85 db             	test   %rbx,%rbx
  802b4c:	74 12                	je     802b60 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b4e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b55:	00 00 00 
  802b58:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b5e:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b60:	4d 85 e4             	test   %r12,%r12
  802b63:	74 14                	je     802b79 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b65:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b6c:	00 00 00 
  802b6f:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b75:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b79:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b80:	00 00 00 
  802b83:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b89:	5b                   	pop    %rbx
  802b8a:	41 5c                	pop    %r12
  802b8c:	5d                   	pop    %rbp
  802b8d:	c3                   	ret
        if (from_env_store != NULL) {
  802b8e:	48 85 db             	test   %rbx,%rbx
  802b91:	74 06                	je     802b99 <ipc_recv+0x8a>
            *from_env_store = 0;
  802b93:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b99:	4d 85 e4             	test   %r12,%r12
  802b9c:	74 eb                	je     802b89 <ipc_recv+0x7a>
            *perm_store = 0;
  802b9e:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802ba5:	00 
  802ba6:	eb e1                	jmp    802b89 <ipc_recv+0x7a>

0000000000802ba8 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802ba8:	f3 0f 1e fa          	endbr64
  802bac:	55                   	push   %rbp
  802bad:	48 89 e5             	mov    %rsp,%rbp
  802bb0:	41 57                	push   %r15
  802bb2:	41 56                	push   %r14
  802bb4:	41 55                	push   %r13
  802bb6:	41 54                	push   %r12
  802bb8:	53                   	push   %rbx
  802bb9:	48 83 ec 18          	sub    $0x18,%rsp
  802bbd:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802bc0:	48 89 d3             	mov    %rdx,%rbx
  802bc3:	49 89 cc             	mov    %rcx,%r12
  802bc6:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802bc9:	48 85 d2             	test   %rdx,%rdx
  802bcc:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bd3:	00 00 00 
  802bd6:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bda:	89 f0                	mov    %esi,%eax
  802bdc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802be0:	48 89 da             	mov    %rbx,%rdx
  802be3:	48 89 c6             	mov    %rax,%rsi
  802be6:	48 b8 2f 14 80 00 00 	movabs $0x80142f,%rax
  802bed:	00 00 00 
  802bf0:	ff d0                	call   *%rax
    while (res < 0) {
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	79 65                	jns    802c5b <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bf6:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bf9:	75 33                	jne    802c2e <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802bfb:	49 bf a2 10 80 00 00 	movabs $0x8010a2,%r15
  802c02:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c05:	49 be 2f 14 80 00 00 	movabs $0x80142f,%r14
  802c0c:	00 00 00 
        sys_yield();
  802c0f:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c12:	45 89 e8             	mov    %r13d,%r8d
  802c15:	4c 89 e1             	mov    %r12,%rcx
  802c18:	48 89 da             	mov    %rbx,%rdx
  802c1b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802c1f:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802c22:	41 ff d6             	call   *%r14
    while (res < 0) {
  802c25:	85 c0                	test   %eax,%eax
  802c27:	79 32                	jns    802c5b <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c29:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c2c:	74 e1                	je     802c0f <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c2e:	89 c1                	mov    %eax,%ecx
  802c30:	48 ba 44 32 80 00 00 	movabs $0x803244,%rdx
  802c37:	00 00 00 
  802c3a:	be 42 00 00 00       	mov    $0x42,%esi
  802c3f:	48 bf 4f 32 80 00 00 	movabs $0x80324f,%rdi
  802c46:	00 00 00 
  802c49:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4e:	49 b8 68 2a 80 00 00 	movabs $0x802a68,%r8
  802c55:	00 00 00 
  802c58:	41 ff d0             	call   *%r8
    }
}
  802c5b:	48 83 c4 18          	add    $0x18,%rsp
  802c5f:	5b                   	pop    %rbx
  802c60:	41 5c                	pop    %r12
  802c62:	41 5d                	pop    %r13
  802c64:	41 5e                	pop    %r14
  802c66:	41 5f                	pop    %r15
  802c68:	5d                   	pop    %rbp
  802c69:	c3                   	ret

0000000000802c6a <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c6a:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c6e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c73:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c7a:	00 00 00 
  802c7d:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c81:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c85:	48 c1 e2 04          	shl    $0x4,%rdx
  802c89:	48 01 ca             	add    %rcx,%rdx
  802c8c:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c92:	39 fa                	cmp    %edi,%edx
  802c94:	74 12                	je     802ca8 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c96:	48 83 c0 01          	add    $0x1,%rax
  802c9a:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802ca0:	75 db                	jne    802c7d <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ca7:	c3                   	ret
            return envs[i].env_id;
  802ca8:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802cac:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802cb0:	48 c1 e2 04          	shl    $0x4,%rdx
  802cb4:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802cbb:	00 00 00 
  802cbe:	48 01 d0             	add    %rdx,%rax
  802cc1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cc7:	c3                   	ret

0000000000802cc8 <__text_end>:
  802cc8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ccf:	00 00 00 
  802cd2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cd9:	00 00 00 
  802cdc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ce3:	00 00 00 
  802ce6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ced:	00 00 00 
  802cf0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cf7:	00 00 00 
  802cfa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d01:	00 00 00 
  802d04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d0b:	00 00 00 
  802d0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d15:	00 00 00 
  802d18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d1f:	00 00 00 
  802d22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d29:	00 00 00 
  802d2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d33:	00 00 00 
  802d36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d3d:	00 00 00 
  802d40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d47:	00 00 00 
  802d4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d51:	00 00 00 
  802d54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d5b:	00 00 00 
  802d5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d65:	00 00 00 
  802d68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d6f:	00 00 00 
  802d72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d79:	00 00 00 
  802d7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d83:	00 00 00 
  802d86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d8d:	00 00 00 
  802d90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d97:	00 00 00 
  802d9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802da1:	00 00 00 
  802da4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dab:	00 00 00 
  802dae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802db5:	00 00 00 
  802db8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dbf:	00 00 00 
  802dc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dc9:	00 00 00 
  802dcc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd3:	00 00 00 
  802dd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ddd:	00 00 00 
  802de0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de7:	00 00 00 
  802dea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df1:	00 00 00 
  802df4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dfb:	00 00 00 
  802dfe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e05:	00 00 00 
  802e08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e0f:	00 00 00 
  802e12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e19:	00 00 00 
  802e1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e23:	00 00 00 
  802e26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e2d:	00 00 00 
  802e30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e37:	00 00 00 
  802e3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e41:	00 00 00 
  802e44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e4b:	00 00 00 
  802e4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e55:	00 00 00 
  802e58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e5f:	00 00 00 
  802e62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e69:	00 00 00 
  802e6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e73:	00 00 00 
  802e76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e7d:	00 00 00 
  802e80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e87:	00 00 00 
  802e8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e91:	00 00 00 
  802e94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e9b:	00 00 00 
  802e9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea5:	00 00 00 
  802ea8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eaf:	00 00 00 
  802eb2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb9:	00 00 00 
  802ebc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec3:	00 00 00 
  802ec6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ecd:	00 00 00 
  802ed0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed7:	00 00 00 
  802eda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee1:	00 00 00 
  802ee4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eeb:	00 00 00 
  802eee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef5:	00 00 00 
  802ef8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eff:	00 00 00 
  802f02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f09:	00 00 00 
  802f0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f13:	00 00 00 
  802f16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f1d:	00 00 00 
  802f20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f27:	00 00 00 
  802f2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f31:	00 00 00 
  802f34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f3b:	00 00 00 
  802f3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f45:	00 00 00 
  802f48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f4f:	00 00 00 
  802f52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f59:	00 00 00 
  802f5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f63:	00 00 00 
  802f66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f6d:	00 00 00 
  802f70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f77:	00 00 00 
  802f7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f81:	00 00 00 
  802f84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f8b:	00 00 00 
  802f8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f95:	00 00 00 
  802f98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f9f:	00 00 00 
  802fa2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa9:	00 00 00 
  802fac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb3:	00 00 00 
  802fb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fbd:	00 00 00 
  802fc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc7:	00 00 00 
  802fca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd1:	00 00 00 
  802fd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fdb:	00 00 00 
  802fde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe5:	00 00 00 
  802fe8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fef:	00 00 00 
  802ff2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff9:	00 00 00 
  802ffc:	0f 1f 40 00          	nopl   0x0(%rax)
