
obj/user/hello:     file format elf64-x86-64


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
  80001e:	e8 51 00 00 00       	call   800074 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* hello, world */
#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	53                   	push   %rbx
  80002e:	48 83 ec 08          	sub    $0x8,%rsp
    cprintf("hello, world\n");
  800032:	48 bf 00 30 80 00 00 	movabs $0x803000,%rdi
  800039:	00 00 00 
  80003c:	b8 00 00 00 00       	mov    $0x0,%eax
  800041:	48 bb 02 02 80 00 00 	movabs $0x800202,%rbx
  800048:	00 00 00 
  80004b:	ff d3                	call   *%rbx
    cprintf("i am environment %08x\n", thisenv->env_id);
  80004d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800054:	00 00 00 
  800057:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80005d:	48 bf 0e 30 80 00 00 	movabs $0x80300e,%rdi
  800064:	00 00 00 
  800067:	b8 00 00 00 00       	mov    $0x0,%eax
  80006c:	ff d3                	call   *%rbx
}
  80006e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800072:	c9                   	leave
  800073:	c3                   	ret

0000000000800074 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800074:	f3 0f 1e fa          	endbr64
  800078:	55                   	push   %rbp
  800079:	48 89 e5             	mov    %rsp,%rbp
  80007c:	41 56                	push   %r14
  80007e:	41 55                	push   %r13
  800080:	41 54                	push   %r12
  800082:	53                   	push   %rbx
  800083:	41 89 fd             	mov    %edi,%r13d
  800086:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800089:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800090:	00 00 00 
  800093:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80009a:	00 00 00 
  80009d:	48 39 c2             	cmp    %rax,%rdx
  8000a0:	73 17                	jae    8000b9 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8000a2:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8000a5:	49 89 c4             	mov    %rax,%r12
  8000a8:	48 83 c3 08          	add    $0x8,%rbx
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	ff 53 f8             	call   *-0x8(%rbx)
  8000b4:	4c 39 e3             	cmp    %r12,%rbx
  8000b7:	72 ef                	jb     8000a8 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8000b9:	48 b8 80 10 80 00 00 	movabs $0x801080,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	call   *%rax
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000ce:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000d2:	48 c1 e0 04          	shl    $0x4,%rax
  8000d6:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000dd:	00 00 00 
  8000e0:	48 01 d0             	add    %rdx,%rax
  8000e3:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000ea:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000ed:	45 85 ed             	test   %r13d,%r13d
  8000f0:	7e 0d                	jle    8000ff <libmain+0x8b>
  8000f2:	49 8b 06             	mov    (%r14),%rax
  8000f5:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000fc:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000ff:	4c 89 f6             	mov    %r14,%rsi
  800102:	44 89 ef             	mov    %r13d,%edi
  800105:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80010c:	00 00 00 
  80010f:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800111:	48 b8 26 01 80 00 00 	movabs $0x800126,%rax
  800118:	00 00 00 
  80011b:	ff d0                	call   *%rax
#endif
}
  80011d:	5b                   	pop    %rbx
  80011e:	41 5c                	pop    %r12
  800120:	41 5d                	pop    %r13
  800122:	41 5e                	pop    %r14
  800124:	5d                   	pop    %rbp
  800125:	c3                   	ret

0000000000800126 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800126:	f3 0f 1e fa          	endbr64
  80012a:	55                   	push   %rbp
  80012b:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80012e:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  800135:	00 00 00 
  800138:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80013a:	bf 00 00 00 00       	mov    $0x0,%edi
  80013f:	48 b8 11 10 80 00 00 	movabs $0x801011,%rax
  800146:	00 00 00 
  800149:	ff d0                	call   *%rax
}
  80014b:	5d                   	pop    %rbp
  80014c:	c3                   	ret

000000000080014d <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80014d:	f3 0f 1e fa          	endbr64
  800151:	55                   	push   %rbp
  800152:	48 89 e5             	mov    %rsp,%rbp
  800155:	53                   	push   %rbx
  800156:	48 83 ec 08          	sub    $0x8,%rsp
  80015a:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80015d:	8b 06                	mov    (%rsi),%eax
  80015f:	8d 50 01             	lea    0x1(%rax),%edx
  800162:	89 16                	mov    %edx,(%rsi)
  800164:	48 98                	cltq
  800166:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80016b:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800171:	74 0a                	je     80017d <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800173:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800177:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80017b:	c9                   	leave
  80017c:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80017d:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800181:	be ff 00 00 00       	mov    $0xff,%esi
  800186:	48 b8 ab 0f 80 00 00 	movabs $0x800fab,%rax
  80018d:	00 00 00 
  800190:	ff d0                	call   *%rax
        state->offset = 0;
  800192:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800198:	eb d9                	jmp    800173 <putch+0x26>

000000000080019a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80019a:	f3 0f 1e fa          	endbr64
  80019e:	55                   	push   %rbp
  80019f:	48 89 e5             	mov    %rsp,%rbp
  8001a2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8001a9:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8001ac:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8001b3:	b9 21 00 00 00       	mov    $0x21,%ecx
  8001b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001bd:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8001c0:	48 89 f1             	mov    %rsi,%rcx
  8001c3:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8001ca:	48 bf 4d 01 80 00 00 	movabs $0x80014d,%rdi
  8001d1:	00 00 00 
  8001d4:	48 b8 62 03 80 00 00 	movabs $0x800362,%rax
  8001db:	00 00 00 
  8001de:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8001e0:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8001e7:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8001ee:	48 b8 ab 0f 80 00 00 	movabs $0x800fab,%rax
  8001f5:	00 00 00 
  8001f8:	ff d0                	call   *%rax

    return state.count;
}
  8001fa:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800200:	c9                   	leave
  800201:	c3                   	ret

0000000000800202 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800202:	f3 0f 1e fa          	endbr64
  800206:	55                   	push   %rbp
  800207:	48 89 e5             	mov    %rsp,%rbp
  80020a:	48 83 ec 50          	sub    $0x50,%rsp
  80020e:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800212:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800216:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80021a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80021e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800222:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800229:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80022d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800231:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800235:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800239:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80023d:	48 b8 9a 01 80 00 00 	movabs $0x80019a,%rax
  800244:	00 00 00 
  800247:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800249:	c9                   	leave
  80024a:	c3                   	ret

000000000080024b <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80024b:	f3 0f 1e fa          	endbr64
  80024f:	55                   	push   %rbp
  800250:	48 89 e5             	mov    %rsp,%rbp
  800253:	41 57                	push   %r15
  800255:	41 56                	push   %r14
  800257:	41 55                	push   %r13
  800259:	41 54                	push   %r12
  80025b:	53                   	push   %rbx
  80025c:	48 83 ec 18          	sub    $0x18,%rsp
  800260:	49 89 fc             	mov    %rdi,%r12
  800263:	49 89 f5             	mov    %rsi,%r13
  800266:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80026a:	8b 45 10             	mov    0x10(%rbp),%eax
  80026d:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800270:	41 89 cf             	mov    %ecx,%r15d
  800273:	4c 39 fa             	cmp    %r15,%rdx
  800276:	73 5b                	jae    8002d3 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800278:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80027c:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800280:	85 db                	test   %ebx,%ebx
  800282:	7e 0e                	jle    800292 <print_num+0x47>
            putch(padc, put_arg);
  800284:	4c 89 ee             	mov    %r13,%rsi
  800287:	44 89 f7             	mov    %r14d,%edi
  80028a:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80028d:	83 eb 01             	sub    $0x1,%ebx
  800290:	75 f2                	jne    800284 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800292:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800296:	48 b9 40 30 80 00 00 	movabs $0x803040,%rcx
  80029d:	00 00 00 
  8002a0:	48 b8 2f 30 80 00 00 	movabs $0x80302f,%rax
  8002a7:	00 00 00 
  8002aa:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8002ae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b7:	49 f7 f7             	div    %r15
  8002ba:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8002be:	4c 89 ee             	mov    %r13,%rsi
  8002c1:	41 ff d4             	call   *%r12
}
  8002c4:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8002c8:	5b                   	pop    %rbx
  8002c9:	41 5c                	pop    %r12
  8002cb:	41 5d                	pop    %r13
  8002cd:	41 5e                	pop    %r14
  8002cf:	41 5f                	pop    %r15
  8002d1:	5d                   	pop    %rbp
  8002d2:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8002d3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002dc:	49 f7 f7             	div    %r15
  8002df:	48 83 ec 08          	sub    $0x8,%rsp
  8002e3:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8002e7:	52                   	push   %rdx
  8002e8:	45 0f be c9          	movsbl %r9b,%r9d
  8002ec:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8002f0:	48 89 c2             	mov    %rax,%rdx
  8002f3:	48 b8 4b 02 80 00 00 	movabs $0x80024b,%rax
  8002fa:	00 00 00 
  8002fd:	ff d0                	call   *%rax
  8002ff:	48 83 c4 10          	add    $0x10,%rsp
  800303:	eb 8d                	jmp    800292 <print_num+0x47>

0000000000800305 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800305:	f3 0f 1e fa          	endbr64
    state->count++;
  800309:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80030d:	48 8b 06             	mov    (%rsi),%rax
  800310:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800314:	73 0a                	jae    800320 <sprintputch+0x1b>
        *state->start++ = ch;
  800316:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80031a:	48 89 16             	mov    %rdx,(%rsi)
  80031d:	40 88 38             	mov    %dil,(%rax)
    }
}
  800320:	c3                   	ret

0000000000800321 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800321:	f3 0f 1e fa          	endbr64
  800325:	55                   	push   %rbp
  800326:	48 89 e5             	mov    %rsp,%rbp
  800329:	48 83 ec 50          	sub    $0x50,%rsp
  80032d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800331:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800335:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800339:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800340:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800344:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800348:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80034c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800350:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800354:	48 b8 62 03 80 00 00 	movabs $0x800362,%rax
  80035b:	00 00 00 
  80035e:	ff d0                	call   *%rax
}
  800360:	c9                   	leave
  800361:	c3                   	ret

0000000000800362 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800362:	f3 0f 1e fa          	endbr64
  800366:	55                   	push   %rbp
  800367:	48 89 e5             	mov    %rsp,%rbp
  80036a:	41 57                	push   %r15
  80036c:	41 56                	push   %r14
  80036e:	41 55                	push   %r13
  800370:	41 54                	push   %r12
  800372:	53                   	push   %rbx
  800373:	48 83 ec 38          	sub    $0x38,%rsp
  800377:	49 89 fe             	mov    %rdi,%r14
  80037a:	49 89 f5             	mov    %rsi,%r13
  80037d:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800380:	48 8b 01             	mov    (%rcx),%rax
  800383:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800387:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80038b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80038f:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800393:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800397:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80039b:	0f b6 3b             	movzbl (%rbx),%edi
  80039e:	40 80 ff 25          	cmp    $0x25,%dil
  8003a2:	74 18                	je     8003bc <vprintfmt+0x5a>
            if (!ch) return;
  8003a4:	40 84 ff             	test   %dil,%dil
  8003a7:	0f 84 b2 06 00 00    	je     800a5f <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8003ad:	40 0f b6 ff          	movzbl %dil,%edi
  8003b1:	4c 89 ee             	mov    %r13,%rsi
  8003b4:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8003b7:	4c 89 e3             	mov    %r12,%rbx
  8003ba:	eb db                	jmp    800397 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8003bc:	be 00 00 00 00       	mov    $0x0,%esi
  8003c1:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8003c5:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8003ca:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8003d0:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8003d7:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8003db:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8003e0:	41 0f b6 04 24       	movzbl (%r12),%eax
  8003e5:	88 45 a0             	mov    %al,-0x60(%rbp)
  8003e8:	83 e8 23             	sub    $0x23,%eax
  8003eb:	3c 57                	cmp    $0x57,%al
  8003ed:	0f 87 52 06 00 00    	ja     800a45 <vprintfmt+0x6e3>
  8003f3:	0f b6 c0             	movzbl %al,%eax
  8003f6:	48 b9 80 32 80 00 00 	movabs $0x803280,%rcx
  8003fd:	00 00 00 
  800400:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800404:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800407:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  80040b:	eb ce                	jmp    8003db <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  80040d:	49 89 dc             	mov    %rbx,%r12
  800410:	be 01 00 00 00       	mov    $0x1,%esi
  800415:	eb c4                	jmp    8003db <vprintfmt+0x79>
            padc = ch;
  800417:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  80041b:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80041e:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800421:	eb b8                	jmp    8003db <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800423:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800426:	83 f8 2f             	cmp    $0x2f,%eax
  800429:	77 24                	ja     80044f <vprintfmt+0xed>
  80042b:	89 c1                	mov    %eax,%ecx
  80042d:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800431:	83 c0 08             	add    $0x8,%eax
  800434:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800437:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  80043a:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  80043d:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800441:	79 98                	jns    8003db <vprintfmt+0x79>
                width = precision;
  800443:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800447:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80044d:	eb 8c                	jmp    8003db <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80044f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800453:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800457:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80045b:	eb da                	jmp    800437 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80045d:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800462:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800466:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80046c:	3c 39                	cmp    $0x39,%al
  80046e:	77 1c                	ja     80048c <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800470:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800474:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800478:	0f b6 c0             	movzbl %al,%eax
  80047b:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800480:	0f b6 03             	movzbl (%rbx),%eax
  800483:	3c 39                	cmp    $0x39,%al
  800485:	76 e9                	jbe    800470 <vprintfmt+0x10e>
        process_precision:
  800487:	49 89 dc             	mov    %rbx,%r12
  80048a:	eb b1                	jmp    80043d <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80048c:	49 89 dc             	mov    %rbx,%r12
  80048f:	eb ac                	jmp    80043d <vprintfmt+0xdb>
            width = MAX(0, width);
  800491:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800494:	85 c9                	test   %ecx,%ecx
  800496:	b8 00 00 00 00       	mov    $0x0,%eax
  80049b:	0f 49 c1             	cmovns %ecx,%eax
  80049e:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8004a1:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8004a4:	e9 32 ff ff ff       	jmp    8003db <vprintfmt+0x79>
            lflag++;
  8004a9:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8004ac:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8004af:	e9 27 ff ff ff       	jmp    8003db <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8004b4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004b7:	83 f8 2f             	cmp    $0x2f,%eax
  8004ba:	77 19                	ja     8004d5 <vprintfmt+0x173>
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8004c2:	83 c0 08             	add    $0x8,%eax
  8004c5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004c8:	8b 3a                	mov    (%rdx),%edi
  8004ca:	4c 89 ee             	mov    %r13,%rsi
  8004cd:	41 ff d6             	call   *%r14
            break;
  8004d0:	e9 c2 fe ff ff       	jmp    800397 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8004d5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004d9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8004dd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004e1:	eb e5                	jmp    8004c8 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8004e3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004e6:	83 f8 2f             	cmp    $0x2f,%eax
  8004e9:	77 5a                	ja     800545 <vprintfmt+0x1e3>
  8004eb:	89 c2                	mov    %eax,%edx
  8004ed:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8004f1:	83 c0 08             	add    $0x8,%eax
  8004f4:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8004f7:	8b 02                	mov    (%rdx),%eax
  8004f9:	89 c1                	mov    %eax,%ecx
  8004fb:	f7 d9                	neg    %ecx
  8004fd:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800500:	83 f9 13             	cmp    $0x13,%ecx
  800503:	7f 4e                	jg     800553 <vprintfmt+0x1f1>
  800505:	48 63 c1             	movslq %ecx,%rax
  800508:	48 ba 40 35 80 00 00 	movabs $0x803540,%rdx
  80050f:	00 00 00 
  800512:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800516:	48 85 c0             	test   %rax,%rax
  800519:	74 38                	je     800553 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  80051b:	48 89 c1             	mov    %rax,%rcx
  80051e:	48 ba 34 32 80 00 00 	movabs $0x803234,%rdx
  800525:	00 00 00 
  800528:	4c 89 ee             	mov    %r13,%rsi
  80052b:	4c 89 f7             	mov    %r14,%rdi
  80052e:	b8 00 00 00 00       	mov    $0x0,%eax
  800533:	49 b8 21 03 80 00 00 	movabs $0x800321,%r8
  80053a:	00 00 00 
  80053d:	41 ff d0             	call   *%r8
  800540:	e9 52 fe ff ff       	jmp    800397 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800545:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800549:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80054d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800551:	eb a4                	jmp    8004f7 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800553:	48 ba 58 30 80 00 00 	movabs $0x803058,%rdx
  80055a:	00 00 00 
  80055d:	4c 89 ee             	mov    %r13,%rsi
  800560:	4c 89 f7             	mov    %r14,%rdi
  800563:	b8 00 00 00 00       	mov    $0x0,%eax
  800568:	49 b8 21 03 80 00 00 	movabs $0x800321,%r8
  80056f:	00 00 00 
  800572:	41 ff d0             	call   *%r8
  800575:	e9 1d fe ff ff       	jmp    800397 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80057a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80057d:	83 f8 2f             	cmp    $0x2f,%eax
  800580:	77 6c                	ja     8005ee <vprintfmt+0x28c>
  800582:	89 c2                	mov    %eax,%edx
  800584:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800588:	83 c0 08             	add    $0x8,%eax
  80058b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80058e:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800591:	48 85 d2             	test   %rdx,%rdx
  800594:	48 b8 51 30 80 00 00 	movabs $0x803051,%rax
  80059b:	00 00 00 
  80059e:	48 0f 45 c2          	cmovne %rdx,%rax
  8005a2:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8005a6:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8005aa:	7e 06                	jle    8005b2 <vprintfmt+0x250>
  8005ac:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8005b0:	75 4a                	jne    8005fc <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8005b2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8005b6:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8005ba:	0f b6 00             	movzbl (%rax),%eax
  8005bd:	84 c0                	test   %al,%al
  8005bf:	0f 85 9a 00 00 00    	jne    80065f <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8005c5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005c8:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8005cc:	85 c0                	test   %eax,%eax
  8005ce:	0f 8e c3 fd ff ff    	jle    800397 <vprintfmt+0x35>
  8005d4:	4c 89 ee             	mov    %r13,%rsi
  8005d7:	bf 20 00 00 00       	mov    $0x20,%edi
  8005dc:	41 ff d6             	call   *%r14
  8005df:	41 83 ec 01          	sub    $0x1,%r12d
  8005e3:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8005e7:	75 eb                	jne    8005d4 <vprintfmt+0x272>
  8005e9:	e9 a9 fd ff ff       	jmp    800397 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8005ee:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005f2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005f6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005fa:	eb 92                	jmp    80058e <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8005fc:	49 63 f7             	movslq %r15d,%rsi
  8005ff:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800603:	48 b8 25 0b 80 00 00 	movabs $0x800b25,%rax
  80060a:	00 00 00 
  80060d:	ff d0                	call   *%rax
  80060f:	48 89 c2             	mov    %rax,%rdx
  800612:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800615:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800617:	8d 70 ff             	lea    -0x1(%rax),%esi
  80061a:	89 75 ac             	mov    %esi,-0x54(%rbp)
  80061d:	85 c0                	test   %eax,%eax
  80061f:	7e 91                	jle    8005b2 <vprintfmt+0x250>
  800621:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800626:	4c 89 ee             	mov    %r13,%rsi
  800629:	44 89 e7             	mov    %r12d,%edi
  80062c:	41 ff d6             	call   *%r14
  80062f:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800633:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800636:	83 f8 ff             	cmp    $0xffffffff,%eax
  800639:	75 eb                	jne    800626 <vprintfmt+0x2c4>
  80063b:	e9 72 ff ff ff       	jmp    8005b2 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800640:	0f b6 f8             	movzbl %al,%edi
  800643:	4c 89 ee             	mov    %r13,%rsi
  800646:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800649:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80064d:	49 83 c4 01          	add    $0x1,%r12
  800651:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800657:	84 c0                	test   %al,%al
  800659:	0f 84 66 ff ff ff    	je     8005c5 <vprintfmt+0x263>
  80065f:	45 85 ff             	test   %r15d,%r15d
  800662:	78 0a                	js     80066e <vprintfmt+0x30c>
  800664:	41 83 ef 01          	sub    $0x1,%r15d
  800668:	0f 88 57 ff ff ff    	js     8005c5 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80066e:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800672:	74 cc                	je     800640 <vprintfmt+0x2de>
  800674:	8d 50 e0             	lea    -0x20(%rax),%edx
  800677:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80067c:	80 fa 5e             	cmp    $0x5e,%dl
  80067f:	77 c2                	ja     800643 <vprintfmt+0x2e1>
  800681:	eb bd                	jmp    800640 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800683:	40 84 f6             	test   %sil,%sil
  800686:	75 26                	jne    8006ae <vprintfmt+0x34c>
    switch (lflag) {
  800688:	85 d2                	test   %edx,%edx
  80068a:	74 59                	je     8006e5 <vprintfmt+0x383>
  80068c:	83 fa 01             	cmp    $0x1,%edx
  80068f:	74 7b                	je     80070c <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800691:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800694:	83 f8 2f             	cmp    $0x2f,%eax
  800697:	0f 87 96 00 00 00    	ja     800733 <vprintfmt+0x3d1>
  80069d:	89 c2                	mov    %eax,%edx
  80069f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006a3:	83 c0 08             	add    $0x8,%eax
  8006a6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006a9:	4c 8b 22             	mov    (%rdx),%r12
  8006ac:	eb 17                	jmp    8006c5 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8006ae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006b1:	83 f8 2f             	cmp    $0x2f,%eax
  8006b4:	77 21                	ja     8006d7 <vprintfmt+0x375>
  8006b6:	89 c2                	mov    %eax,%edx
  8006b8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006bc:	83 c0 08             	add    $0x8,%eax
  8006bf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006c2:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8006c5:	4d 85 e4             	test   %r12,%r12
  8006c8:	78 7a                	js     800744 <vprintfmt+0x3e2>
            num = i;
  8006ca:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8006cd:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006d2:	e9 50 02 00 00       	jmp    800927 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8006d7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006db:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006df:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006e3:	eb dd                	jmp    8006c2 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8006e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006e8:	83 f8 2f             	cmp    $0x2f,%eax
  8006eb:	77 11                	ja     8006fe <vprintfmt+0x39c>
  8006ed:	89 c2                	mov    %eax,%edx
  8006ef:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006f3:	83 c0 08             	add    $0x8,%eax
  8006f6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006f9:	4c 63 22             	movslq (%rdx),%r12
  8006fc:	eb c7                	jmp    8006c5 <vprintfmt+0x363>
  8006fe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800702:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800706:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80070a:	eb ed                	jmp    8006f9 <vprintfmt+0x397>
        return va_arg(*ap, long);
  80070c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80070f:	83 f8 2f             	cmp    $0x2f,%eax
  800712:	77 11                	ja     800725 <vprintfmt+0x3c3>
  800714:	89 c2                	mov    %eax,%edx
  800716:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80071a:	83 c0 08             	add    $0x8,%eax
  80071d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800720:	4c 8b 22             	mov    (%rdx),%r12
  800723:	eb a0                	jmp    8006c5 <vprintfmt+0x363>
  800725:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800729:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80072d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800731:	eb ed                	jmp    800720 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800733:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800737:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80073b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80073f:	e9 65 ff ff ff       	jmp    8006a9 <vprintfmt+0x347>
                putch('-', put_arg);
  800744:	4c 89 ee             	mov    %r13,%rsi
  800747:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80074c:	41 ff d6             	call   *%r14
                i = -i;
  80074f:	49 f7 dc             	neg    %r12
  800752:	e9 73 ff ff ff       	jmp    8006ca <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800757:	40 84 f6             	test   %sil,%sil
  80075a:	75 32                	jne    80078e <vprintfmt+0x42c>
    switch (lflag) {
  80075c:	85 d2                	test   %edx,%edx
  80075e:	74 5d                	je     8007bd <vprintfmt+0x45b>
  800760:	83 fa 01             	cmp    $0x1,%edx
  800763:	0f 84 82 00 00 00    	je     8007eb <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800769:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80076c:	83 f8 2f             	cmp    $0x2f,%eax
  80076f:	0f 87 a5 00 00 00    	ja     80081a <vprintfmt+0x4b8>
  800775:	89 c2                	mov    %eax,%edx
  800777:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80077b:	83 c0 08             	add    $0x8,%eax
  80077e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800781:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800784:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800789:	e9 99 01 00 00       	jmp    800927 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80078e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800791:	83 f8 2f             	cmp    $0x2f,%eax
  800794:	77 19                	ja     8007af <vprintfmt+0x44d>
  800796:	89 c2                	mov    %eax,%edx
  800798:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80079c:	83 c0 08             	add    $0x8,%eax
  80079f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007a2:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8007a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8007aa:	e9 78 01 00 00       	jmp    800927 <vprintfmt+0x5c5>
  8007af:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007b3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007b7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007bb:	eb e5                	jmp    8007a2 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8007bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c0:	83 f8 2f             	cmp    $0x2f,%eax
  8007c3:	77 18                	ja     8007dd <vprintfmt+0x47b>
  8007c5:	89 c2                	mov    %eax,%edx
  8007c7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007cb:	83 c0 08             	add    $0x8,%eax
  8007ce:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007d1:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8007d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8007d8:	e9 4a 01 00 00       	jmp    800927 <vprintfmt+0x5c5>
  8007dd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007e1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007e5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007e9:	eb e6                	jmp    8007d1 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8007eb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ee:	83 f8 2f             	cmp    $0x2f,%eax
  8007f1:	77 19                	ja     80080c <vprintfmt+0x4aa>
  8007f3:	89 c2                	mov    %eax,%edx
  8007f5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007f9:	83 c0 08             	add    $0x8,%eax
  8007fc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007ff:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800802:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800807:	e9 1b 01 00 00       	jmp    800927 <vprintfmt+0x5c5>
  80080c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800810:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800814:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800818:	eb e5                	jmp    8007ff <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  80081a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80081e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800822:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800826:	e9 56 ff ff ff       	jmp    800781 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  80082b:	40 84 f6             	test   %sil,%sil
  80082e:	75 2e                	jne    80085e <vprintfmt+0x4fc>
    switch (lflag) {
  800830:	85 d2                	test   %edx,%edx
  800832:	74 59                	je     80088d <vprintfmt+0x52b>
  800834:	83 fa 01             	cmp    $0x1,%edx
  800837:	74 7f                	je     8008b8 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800839:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80083c:	83 f8 2f             	cmp    $0x2f,%eax
  80083f:	0f 87 9f 00 00 00    	ja     8008e4 <vprintfmt+0x582>
  800845:	89 c2                	mov    %eax,%edx
  800847:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80084b:	83 c0 08             	add    $0x8,%eax
  80084e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800851:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800854:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800859:	e9 c9 00 00 00       	jmp    800927 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80085e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800861:	83 f8 2f             	cmp    $0x2f,%eax
  800864:	77 19                	ja     80087f <vprintfmt+0x51d>
  800866:	89 c2                	mov    %eax,%edx
  800868:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80086c:	83 c0 08             	add    $0x8,%eax
  80086f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800872:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800875:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80087a:	e9 a8 00 00 00       	jmp    800927 <vprintfmt+0x5c5>
  80087f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800883:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800887:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80088b:	eb e5                	jmp    800872 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  80088d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800890:	83 f8 2f             	cmp    $0x2f,%eax
  800893:	77 15                	ja     8008aa <vprintfmt+0x548>
  800895:	89 c2                	mov    %eax,%edx
  800897:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80089b:	83 c0 08             	add    $0x8,%eax
  80089e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008a1:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8008a3:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8008a8:	eb 7d                	jmp    800927 <vprintfmt+0x5c5>
  8008aa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008ae:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008b2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008b6:	eb e9                	jmp    8008a1 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8008b8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008bb:	83 f8 2f             	cmp    $0x2f,%eax
  8008be:	77 16                	ja     8008d6 <vprintfmt+0x574>
  8008c0:	89 c2                	mov    %eax,%edx
  8008c2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008c6:	83 c0 08             	add    $0x8,%eax
  8008c9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008cc:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8008cf:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008d4:	eb 51                	jmp    800927 <vprintfmt+0x5c5>
  8008d6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008da:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008de:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008e2:	eb e8                	jmp    8008cc <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8008e4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008e8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008ec:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008f0:	e9 5c ff ff ff       	jmp    800851 <vprintfmt+0x4ef>
            putch('0', put_arg);
  8008f5:	4c 89 ee             	mov    %r13,%rsi
  8008f8:	bf 30 00 00 00       	mov    $0x30,%edi
  8008fd:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800900:	4c 89 ee             	mov    %r13,%rsi
  800903:	bf 78 00 00 00       	mov    $0x78,%edi
  800908:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  80090b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090e:	83 f8 2f             	cmp    $0x2f,%eax
  800911:	77 47                	ja     80095a <vprintfmt+0x5f8>
  800913:	89 c2                	mov    %eax,%edx
  800915:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800919:	83 c0 08             	add    $0x8,%eax
  80091c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80091f:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800922:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800927:	48 83 ec 08          	sub    $0x8,%rsp
  80092b:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  80092f:	0f 94 c0             	sete   %al
  800932:	0f b6 c0             	movzbl %al,%eax
  800935:	50                   	push   %rax
  800936:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  80093b:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80093f:	4c 89 ee             	mov    %r13,%rsi
  800942:	4c 89 f7             	mov    %r14,%rdi
  800945:	48 b8 4b 02 80 00 00 	movabs $0x80024b,%rax
  80094c:	00 00 00 
  80094f:	ff d0                	call   *%rax
            break;
  800951:	48 83 c4 10          	add    $0x10,%rsp
  800955:	e9 3d fa ff ff       	jmp    800397 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  80095a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80095e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800962:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800966:	eb b7                	jmp    80091f <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800968:	40 84 f6             	test   %sil,%sil
  80096b:	75 2b                	jne    800998 <vprintfmt+0x636>
    switch (lflag) {
  80096d:	85 d2                	test   %edx,%edx
  80096f:	74 56                	je     8009c7 <vprintfmt+0x665>
  800971:	83 fa 01             	cmp    $0x1,%edx
  800974:	74 7f                	je     8009f5 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800976:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800979:	83 f8 2f             	cmp    $0x2f,%eax
  80097c:	0f 87 a2 00 00 00    	ja     800a24 <vprintfmt+0x6c2>
  800982:	89 c2                	mov    %eax,%edx
  800984:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800988:	83 c0 08             	add    $0x8,%eax
  80098b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80098e:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800991:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800996:	eb 8f                	jmp    800927 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800998:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099b:	83 f8 2f             	cmp    $0x2f,%eax
  80099e:	77 19                	ja     8009b9 <vprintfmt+0x657>
  8009a0:	89 c2                	mov    %eax,%edx
  8009a2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009a6:	83 c0 08             	add    $0x8,%eax
  8009a9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ac:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009af:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009b4:	e9 6e ff ff ff       	jmp    800927 <vprintfmt+0x5c5>
  8009b9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009bd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009c1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009c5:	eb e5                	jmp    8009ac <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8009c7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ca:	83 f8 2f             	cmp    $0x2f,%eax
  8009cd:	77 18                	ja     8009e7 <vprintfmt+0x685>
  8009cf:	89 c2                	mov    %eax,%edx
  8009d1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009d5:	83 c0 08             	add    $0x8,%eax
  8009d8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009db:	8b 12                	mov    (%rdx),%edx
            base = 16;
  8009dd:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8009e2:	e9 40 ff ff ff       	jmp    800927 <vprintfmt+0x5c5>
  8009e7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009eb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009ef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009f3:	eb e6                	jmp    8009db <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  8009f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f8:	83 f8 2f             	cmp    $0x2f,%eax
  8009fb:	77 19                	ja     800a16 <vprintfmt+0x6b4>
  8009fd:	89 c2                	mov    %eax,%edx
  8009ff:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a03:	83 c0 08             	add    $0x8,%eax
  800a06:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a09:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a0c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800a11:	e9 11 ff ff ff       	jmp    800927 <vprintfmt+0x5c5>
  800a16:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a1a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a1e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a22:	eb e5                	jmp    800a09 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800a24:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a28:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a2c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a30:	e9 59 ff ff ff       	jmp    80098e <vprintfmt+0x62c>
            putch(ch, put_arg);
  800a35:	4c 89 ee             	mov    %r13,%rsi
  800a38:	bf 25 00 00 00       	mov    $0x25,%edi
  800a3d:	41 ff d6             	call   *%r14
            break;
  800a40:	e9 52 f9 ff ff       	jmp    800397 <vprintfmt+0x35>
            putch('%', put_arg);
  800a45:	4c 89 ee             	mov    %r13,%rsi
  800a48:	bf 25 00 00 00       	mov    $0x25,%edi
  800a4d:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800a50:	48 83 eb 01          	sub    $0x1,%rbx
  800a54:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800a58:	75 f6                	jne    800a50 <vprintfmt+0x6ee>
  800a5a:	e9 38 f9 ff ff       	jmp    800397 <vprintfmt+0x35>
}
  800a5f:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a63:	5b                   	pop    %rbx
  800a64:	41 5c                	pop    %r12
  800a66:	41 5d                	pop    %r13
  800a68:	41 5e                	pop    %r14
  800a6a:	41 5f                	pop    %r15
  800a6c:	5d                   	pop    %rbp
  800a6d:	c3                   	ret

0000000000800a6e <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a6e:	f3 0f 1e fa          	endbr64
  800a72:	55                   	push   %rbp
  800a73:	48 89 e5             	mov    %rsp,%rbp
  800a76:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800a7a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a7e:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800a83:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800a87:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800a8e:	48 85 ff             	test   %rdi,%rdi
  800a91:	74 2b                	je     800abe <vsnprintf+0x50>
  800a93:	48 85 f6             	test   %rsi,%rsi
  800a96:	74 26                	je     800abe <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800a98:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800a9c:	48 bf 05 03 80 00 00 	movabs $0x800305,%rdi
  800aa3:	00 00 00 
  800aa6:	48 b8 62 03 80 00 00 	movabs $0x800362,%rax
  800aad:	00 00 00 
  800ab0:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800ab2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab6:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800ab9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800abc:	c9                   	leave
  800abd:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800abe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ac3:	eb f7                	jmp    800abc <vsnprintf+0x4e>

0000000000800ac5 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800ac5:	f3 0f 1e fa          	endbr64
  800ac9:	55                   	push   %rbp
  800aca:	48 89 e5             	mov    %rsp,%rbp
  800acd:	48 83 ec 50          	sub    $0x50,%rsp
  800ad1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800ad5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800ad9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800add:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800ae4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ae8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aec:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800af0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800af4:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800af8:	48 b8 6e 0a 80 00 00 	movabs $0x800a6e,%rax
  800aff:	00 00 00 
  800b02:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800b04:	c9                   	leave
  800b05:	c3                   	ret

0000000000800b06 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800b06:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800b0a:	80 3f 00             	cmpb   $0x0,(%rdi)
  800b0d:	74 10                	je     800b1f <strlen+0x19>
    size_t n = 0;
  800b0f:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800b14:	48 83 c0 01          	add    $0x1,%rax
  800b18:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b1c:	75 f6                	jne    800b14 <strlen+0xe>
  800b1e:	c3                   	ret
    size_t n = 0;
  800b1f:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800b24:	c3                   	ret

0000000000800b25 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800b25:	f3 0f 1e fa          	endbr64
  800b29:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800b2c:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800b31:	48 85 f6             	test   %rsi,%rsi
  800b34:	74 10                	je     800b46 <strnlen+0x21>
  800b36:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800b3a:	74 0b                	je     800b47 <strnlen+0x22>
  800b3c:	48 83 c2 01          	add    $0x1,%rdx
  800b40:	48 39 d0             	cmp    %rdx,%rax
  800b43:	75 f1                	jne    800b36 <strnlen+0x11>
  800b45:	c3                   	ret
  800b46:	c3                   	ret
  800b47:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800b4a:	c3                   	ret

0000000000800b4b <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800b4b:	f3 0f 1e fa          	endbr64
  800b4f:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b52:	ba 00 00 00 00       	mov    $0x0,%edx
  800b57:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800b5b:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800b5e:	48 83 c2 01          	add    $0x1,%rdx
  800b62:	84 c9                	test   %cl,%cl
  800b64:	75 f1                	jne    800b57 <strcpy+0xc>
        ;
    return res;
}
  800b66:	c3                   	ret

0000000000800b67 <strcat>:

char *
strcat(char *dst, const char *src) {
  800b67:	f3 0f 1e fa          	endbr64
  800b6b:	55                   	push   %rbp
  800b6c:	48 89 e5             	mov    %rsp,%rbp
  800b6f:	41 54                	push   %r12
  800b71:	53                   	push   %rbx
  800b72:	48 89 fb             	mov    %rdi,%rbx
  800b75:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800b78:	48 b8 06 0b 80 00 00 	movabs $0x800b06,%rax
  800b7f:	00 00 00 
  800b82:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800b84:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800b88:	4c 89 e6             	mov    %r12,%rsi
  800b8b:	48 b8 4b 0b 80 00 00 	movabs $0x800b4b,%rax
  800b92:	00 00 00 
  800b95:	ff d0                	call   *%rax
    return dst;
}
  800b97:	48 89 d8             	mov    %rbx,%rax
  800b9a:	5b                   	pop    %rbx
  800b9b:	41 5c                	pop    %r12
  800b9d:	5d                   	pop    %rbp
  800b9e:	c3                   	ret

0000000000800b9f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b9f:	f3 0f 1e fa          	endbr64
  800ba3:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800ba6:	48 85 d2             	test   %rdx,%rdx
  800ba9:	74 1f                	je     800bca <strncpy+0x2b>
  800bab:	48 01 fa             	add    %rdi,%rdx
  800bae:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800bb1:	48 83 c1 01          	add    $0x1,%rcx
  800bb5:	44 0f b6 06          	movzbl (%rsi),%r8d
  800bb9:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800bbd:	41 80 f8 01          	cmp    $0x1,%r8b
  800bc1:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800bc5:	48 39 ca             	cmp    %rcx,%rdx
  800bc8:	75 e7                	jne    800bb1 <strncpy+0x12>
    }
    return ret;
}
  800bca:	c3                   	ret

0000000000800bcb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800bcb:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800bcf:	48 89 f8             	mov    %rdi,%rax
  800bd2:	48 85 d2             	test   %rdx,%rdx
  800bd5:	74 24                	je     800bfb <strlcpy+0x30>
        while (--size > 0 && *src)
  800bd7:	48 83 ea 01          	sub    $0x1,%rdx
  800bdb:	74 1b                	je     800bf8 <strlcpy+0x2d>
  800bdd:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800be1:	0f b6 16             	movzbl (%rsi),%edx
  800be4:	84 d2                	test   %dl,%dl
  800be6:	74 10                	je     800bf8 <strlcpy+0x2d>
            *dst++ = *src++;
  800be8:	48 83 c6 01          	add    $0x1,%rsi
  800bec:	48 83 c0 01          	add    $0x1,%rax
  800bf0:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800bf3:	48 39 c8             	cmp    %rcx,%rax
  800bf6:	75 e9                	jne    800be1 <strlcpy+0x16>
        *dst = '\0';
  800bf8:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800bfb:	48 29 f8             	sub    %rdi,%rax
}
  800bfe:	c3                   	ret

0000000000800bff <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800bff:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800c03:	0f b6 07             	movzbl (%rdi),%eax
  800c06:	84 c0                	test   %al,%al
  800c08:	74 13                	je     800c1d <strcmp+0x1e>
  800c0a:	38 06                	cmp    %al,(%rsi)
  800c0c:	75 0f                	jne    800c1d <strcmp+0x1e>
  800c0e:	48 83 c7 01          	add    $0x1,%rdi
  800c12:	48 83 c6 01          	add    $0x1,%rsi
  800c16:	0f b6 07             	movzbl (%rdi),%eax
  800c19:	84 c0                	test   %al,%al
  800c1b:	75 ed                	jne    800c0a <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800c1d:	0f b6 c0             	movzbl %al,%eax
  800c20:	0f b6 16             	movzbl (%rsi),%edx
  800c23:	29 d0                	sub    %edx,%eax
}
  800c25:	c3                   	ret

0000000000800c26 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800c26:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800c2a:	48 85 d2             	test   %rdx,%rdx
  800c2d:	74 1f                	je     800c4e <strncmp+0x28>
  800c2f:	0f b6 07             	movzbl (%rdi),%eax
  800c32:	84 c0                	test   %al,%al
  800c34:	74 1e                	je     800c54 <strncmp+0x2e>
  800c36:	3a 06                	cmp    (%rsi),%al
  800c38:	75 1a                	jne    800c54 <strncmp+0x2e>
  800c3a:	48 83 c7 01          	add    $0x1,%rdi
  800c3e:	48 83 c6 01          	add    $0x1,%rsi
  800c42:	48 83 ea 01          	sub    $0x1,%rdx
  800c46:	75 e7                	jne    800c2f <strncmp+0x9>

    if (!n) return 0;
  800c48:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4d:	c3                   	ret
  800c4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c53:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c54:	0f b6 07             	movzbl (%rdi),%eax
  800c57:	0f b6 16             	movzbl (%rsi),%edx
  800c5a:	29 d0                	sub    %edx,%eax
}
  800c5c:	c3                   	ret

0000000000800c5d <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800c5d:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800c61:	0f b6 17             	movzbl (%rdi),%edx
  800c64:	84 d2                	test   %dl,%dl
  800c66:	74 18                	je     800c80 <strchr+0x23>
        if (*str == c) {
  800c68:	0f be d2             	movsbl %dl,%edx
  800c6b:	39 f2                	cmp    %esi,%edx
  800c6d:	74 17                	je     800c86 <strchr+0x29>
    for (; *str; str++) {
  800c6f:	48 83 c7 01          	add    $0x1,%rdi
  800c73:	0f b6 17             	movzbl (%rdi),%edx
  800c76:	84 d2                	test   %dl,%dl
  800c78:	75 ee                	jne    800c68 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7f:	c3                   	ret
  800c80:	b8 00 00 00 00       	mov    $0x0,%eax
  800c85:	c3                   	ret
            return (char *)str;
  800c86:	48 89 f8             	mov    %rdi,%rax
}
  800c89:	c3                   	ret

0000000000800c8a <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800c8a:	f3 0f 1e fa          	endbr64
  800c8e:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800c91:	0f b6 17             	movzbl (%rdi),%edx
  800c94:	84 d2                	test   %dl,%dl
  800c96:	74 13                	je     800cab <strfind+0x21>
  800c98:	0f be d2             	movsbl %dl,%edx
  800c9b:	39 f2                	cmp    %esi,%edx
  800c9d:	74 0b                	je     800caa <strfind+0x20>
  800c9f:	48 83 c0 01          	add    $0x1,%rax
  800ca3:	0f b6 10             	movzbl (%rax),%edx
  800ca6:	84 d2                	test   %dl,%dl
  800ca8:	75 ee                	jne    800c98 <strfind+0xe>
        ;
    return (char *)str;
}
  800caa:	c3                   	ret
  800cab:	c3                   	ret

0000000000800cac <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800cac:	f3 0f 1e fa          	endbr64
  800cb0:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800cb3:	48 89 f8             	mov    %rdi,%rax
  800cb6:	48 f7 d8             	neg    %rax
  800cb9:	83 e0 07             	and    $0x7,%eax
  800cbc:	49 89 d1             	mov    %rdx,%r9
  800cbf:	49 29 c1             	sub    %rax,%r9
  800cc2:	78 36                	js     800cfa <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800cc4:	40 0f b6 c6          	movzbl %sil,%eax
  800cc8:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800ccf:	01 01 01 
  800cd2:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800cd6:	40 f6 c7 07          	test   $0x7,%dil
  800cda:	75 38                	jne    800d14 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800cdc:	4c 89 c9             	mov    %r9,%rcx
  800cdf:	48 c1 f9 03          	sar    $0x3,%rcx
  800ce3:	74 0c                	je     800cf1 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800ce5:	fc                   	cld
  800ce6:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800ce9:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800ced:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800cf1:	4d 85 c9             	test   %r9,%r9
  800cf4:	75 45                	jne    800d3b <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800cf6:	4c 89 c0             	mov    %r8,%rax
  800cf9:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800cfa:	48 85 d2             	test   %rdx,%rdx
  800cfd:	74 f7                	je     800cf6 <memset+0x4a>
  800cff:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800d02:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800d05:	48 83 c0 01          	add    $0x1,%rax
  800d09:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800d0d:	48 39 c2             	cmp    %rax,%rdx
  800d10:	75 f3                	jne    800d05 <memset+0x59>
  800d12:	eb e2                	jmp    800cf6 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800d14:	40 f6 c7 01          	test   $0x1,%dil
  800d18:	74 06                	je     800d20 <memset+0x74>
  800d1a:	88 07                	mov    %al,(%rdi)
  800d1c:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d20:	40 f6 c7 02          	test   $0x2,%dil
  800d24:	74 07                	je     800d2d <memset+0x81>
  800d26:	66 89 07             	mov    %ax,(%rdi)
  800d29:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d2d:	40 f6 c7 04          	test   $0x4,%dil
  800d31:	74 a9                	je     800cdc <memset+0x30>
  800d33:	89 07                	mov    %eax,(%rdi)
  800d35:	48 83 c7 04          	add    $0x4,%rdi
  800d39:	eb a1                	jmp    800cdc <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d3b:	41 f6 c1 04          	test   $0x4,%r9b
  800d3f:	74 1b                	je     800d5c <memset+0xb0>
  800d41:	89 07                	mov    %eax,(%rdi)
  800d43:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d47:	41 f6 c1 02          	test   $0x2,%r9b
  800d4b:	74 07                	je     800d54 <memset+0xa8>
  800d4d:	66 89 07             	mov    %ax,(%rdi)
  800d50:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d54:	41 f6 c1 01          	test   $0x1,%r9b
  800d58:	74 9c                	je     800cf6 <memset+0x4a>
  800d5a:	eb 06                	jmp    800d62 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d5c:	41 f6 c1 02          	test   $0x2,%r9b
  800d60:	75 eb                	jne    800d4d <memset+0xa1>
        if (ni & 1) *ptr = k;
  800d62:	88 07                	mov    %al,(%rdi)
  800d64:	eb 90                	jmp    800cf6 <memset+0x4a>

0000000000800d66 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d66:	f3 0f 1e fa          	endbr64
  800d6a:	48 89 f8             	mov    %rdi,%rax
  800d6d:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d70:	48 39 fe             	cmp    %rdi,%rsi
  800d73:	73 3b                	jae    800db0 <memmove+0x4a>
  800d75:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800d79:	48 39 d7             	cmp    %rdx,%rdi
  800d7c:	73 32                	jae    800db0 <memmove+0x4a>
        s += n;
        d += n;
  800d7e:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d82:	48 89 d6             	mov    %rdx,%rsi
  800d85:	48 09 fe             	or     %rdi,%rsi
  800d88:	48 09 ce             	or     %rcx,%rsi
  800d8b:	40 f6 c6 07          	test   $0x7,%sil
  800d8f:	75 12                	jne    800da3 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800d91:	48 83 ef 08          	sub    $0x8,%rdi
  800d95:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800d99:	48 c1 e9 03          	shr    $0x3,%rcx
  800d9d:	fd                   	std
  800d9e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800da1:	fc                   	cld
  800da2:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800da3:	48 83 ef 01          	sub    $0x1,%rdi
  800da7:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800dab:	fd                   	std
  800dac:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800dae:	eb f1                	jmp    800da1 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800db0:	48 89 f2             	mov    %rsi,%rdx
  800db3:	48 09 c2             	or     %rax,%rdx
  800db6:	48 09 ca             	or     %rcx,%rdx
  800db9:	f6 c2 07             	test   $0x7,%dl
  800dbc:	75 0c                	jne    800dca <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800dbe:	48 c1 e9 03          	shr    $0x3,%rcx
  800dc2:	48 89 c7             	mov    %rax,%rdi
  800dc5:	fc                   	cld
  800dc6:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800dc9:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800dca:	48 89 c7             	mov    %rax,%rdi
  800dcd:	fc                   	cld
  800dce:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800dd0:	c3                   	ret

0000000000800dd1 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800dd1:	f3 0f 1e fa          	endbr64
  800dd5:	55                   	push   %rbp
  800dd6:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800dd9:	48 b8 66 0d 80 00 00 	movabs $0x800d66,%rax
  800de0:	00 00 00 
  800de3:	ff d0                	call   *%rax
}
  800de5:	5d                   	pop    %rbp
  800de6:	c3                   	ret

0000000000800de7 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800de7:	f3 0f 1e fa          	endbr64
  800deb:	55                   	push   %rbp
  800dec:	48 89 e5             	mov    %rsp,%rbp
  800def:	41 57                	push   %r15
  800df1:	41 56                	push   %r14
  800df3:	41 55                	push   %r13
  800df5:	41 54                	push   %r12
  800df7:	53                   	push   %rbx
  800df8:	48 83 ec 08          	sub    $0x8,%rsp
  800dfc:	49 89 fe             	mov    %rdi,%r14
  800dff:	49 89 f7             	mov    %rsi,%r15
  800e02:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800e05:	48 89 f7             	mov    %rsi,%rdi
  800e08:	48 b8 06 0b 80 00 00 	movabs $0x800b06,%rax
  800e0f:	00 00 00 
  800e12:	ff d0                	call   *%rax
  800e14:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800e17:	48 89 de             	mov    %rbx,%rsi
  800e1a:	4c 89 f7             	mov    %r14,%rdi
  800e1d:	48 b8 25 0b 80 00 00 	movabs $0x800b25,%rax
  800e24:	00 00 00 
  800e27:	ff d0                	call   *%rax
  800e29:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800e2c:	48 39 c3             	cmp    %rax,%rbx
  800e2f:	74 36                	je     800e67 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800e31:	48 89 d8             	mov    %rbx,%rax
  800e34:	4c 29 e8             	sub    %r13,%rax
  800e37:	49 39 c4             	cmp    %rax,%r12
  800e3a:	73 31                	jae    800e6d <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800e3c:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800e41:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e45:	4c 89 fe             	mov    %r15,%rsi
  800e48:	48 b8 d1 0d 80 00 00 	movabs $0x800dd1,%rax
  800e4f:	00 00 00 
  800e52:	ff d0                	call   *%rax
    return dstlen + srclen;
  800e54:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800e58:	48 83 c4 08          	add    $0x8,%rsp
  800e5c:	5b                   	pop    %rbx
  800e5d:	41 5c                	pop    %r12
  800e5f:	41 5d                	pop    %r13
  800e61:	41 5e                	pop    %r14
  800e63:	41 5f                	pop    %r15
  800e65:	5d                   	pop    %rbp
  800e66:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800e67:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800e6b:	eb eb                	jmp    800e58 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e6d:	48 83 eb 01          	sub    $0x1,%rbx
  800e71:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e75:	48 89 da             	mov    %rbx,%rdx
  800e78:	4c 89 fe             	mov    %r15,%rsi
  800e7b:	48 b8 d1 0d 80 00 00 	movabs $0x800dd1,%rax
  800e82:	00 00 00 
  800e85:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800e87:	49 01 de             	add    %rbx,%r14
  800e8a:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800e8f:	eb c3                	jmp    800e54 <strlcat+0x6d>

0000000000800e91 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800e91:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800e95:	48 85 d2             	test   %rdx,%rdx
  800e98:	74 2d                	je     800ec7 <memcmp+0x36>
  800e9a:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800e9f:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800ea3:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800ea8:	44 38 c1             	cmp    %r8b,%cl
  800eab:	75 0f                	jne    800ebc <memcmp+0x2b>
    while (n-- > 0) {
  800ead:	48 83 c0 01          	add    $0x1,%rax
  800eb1:	48 39 c2             	cmp    %rax,%rdx
  800eb4:	75 e9                	jne    800e9f <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800eb6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ebb:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800ebc:	0f b6 c1             	movzbl %cl,%eax
  800ebf:	45 0f b6 c0          	movzbl %r8b,%r8d
  800ec3:	44 29 c0             	sub    %r8d,%eax
  800ec6:	c3                   	ret
    return 0;
  800ec7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecc:	c3                   	ret

0000000000800ecd <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800ecd:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800ed1:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800ed5:	48 39 c7             	cmp    %rax,%rdi
  800ed8:	73 0f                	jae    800ee9 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800eda:	40 38 37             	cmp    %sil,(%rdi)
  800edd:	74 0e                	je     800eed <memfind+0x20>
    for (; src < end; src++) {
  800edf:	48 83 c7 01          	add    $0x1,%rdi
  800ee3:	48 39 f8             	cmp    %rdi,%rax
  800ee6:	75 f2                	jne    800eda <memfind+0xd>
  800ee8:	c3                   	ret
  800ee9:	48 89 f8             	mov    %rdi,%rax
  800eec:	c3                   	ret
  800eed:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800ef0:	c3                   	ret

0000000000800ef1 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800ef1:	f3 0f 1e fa          	endbr64
  800ef5:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800ef8:	0f b6 37             	movzbl (%rdi),%esi
  800efb:	40 80 fe 20          	cmp    $0x20,%sil
  800eff:	74 06                	je     800f07 <strtol+0x16>
  800f01:	40 80 fe 09          	cmp    $0x9,%sil
  800f05:	75 13                	jne    800f1a <strtol+0x29>
  800f07:	48 83 c7 01          	add    $0x1,%rdi
  800f0b:	0f b6 37             	movzbl (%rdi),%esi
  800f0e:	40 80 fe 20          	cmp    $0x20,%sil
  800f12:	74 f3                	je     800f07 <strtol+0x16>
  800f14:	40 80 fe 09          	cmp    $0x9,%sil
  800f18:	74 ed                	je     800f07 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800f1a:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800f1d:	83 e0 fd             	and    $0xfffffffd,%eax
  800f20:	3c 01                	cmp    $0x1,%al
  800f22:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f26:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  800f2c:	75 0f                	jne    800f3d <strtol+0x4c>
  800f2e:	80 3f 30             	cmpb   $0x30,(%rdi)
  800f31:	74 14                	je     800f47 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800f33:	85 d2                	test   %edx,%edx
  800f35:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f3a:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  800f3d:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800f42:	4c 63 ca             	movslq %edx,%r9
  800f45:	eb 36                	jmp    800f7d <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f47:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800f4b:	74 0f                	je     800f5c <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  800f4d:	85 d2                	test   %edx,%edx
  800f4f:	75 ec                	jne    800f3d <strtol+0x4c>
        s++;
  800f51:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800f55:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  800f5a:	eb e1                	jmp    800f3d <strtol+0x4c>
        s += 2;
  800f5c:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f60:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  800f65:	eb d6                	jmp    800f3d <strtol+0x4c>
            dig -= '0';
  800f67:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  800f6a:	44 0f b6 c1          	movzbl %cl,%r8d
  800f6e:	41 39 d0             	cmp    %edx,%r8d
  800f71:	7d 21                	jge    800f94 <strtol+0xa3>
        val = val * base + dig;
  800f73:	49 0f af c1          	imul   %r9,%rax
  800f77:	0f b6 c9             	movzbl %cl,%ecx
  800f7a:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  800f7d:	48 83 c7 01          	add    $0x1,%rdi
  800f81:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  800f85:	80 f9 39             	cmp    $0x39,%cl
  800f88:	76 dd                	jbe    800f67 <strtol+0x76>
        else if (dig - 'a' < 27)
  800f8a:	80 f9 7b             	cmp    $0x7b,%cl
  800f8d:	77 05                	ja     800f94 <strtol+0xa3>
            dig -= 'a' - 10;
  800f8f:	83 e9 57             	sub    $0x57,%ecx
  800f92:	eb d6                	jmp    800f6a <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  800f94:	4d 85 d2             	test   %r10,%r10
  800f97:	74 03                	je     800f9c <strtol+0xab>
  800f99:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800f9c:	48 89 c2             	mov    %rax,%rdx
  800f9f:	48 f7 da             	neg    %rdx
  800fa2:	40 80 fe 2d          	cmp    $0x2d,%sil
  800fa6:	48 0f 44 c2          	cmove  %rdx,%rax
}
  800faa:	c3                   	ret

0000000000800fab <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800fab:	f3 0f 1e fa          	endbr64
  800faf:	55                   	push   %rbp
  800fb0:	48 89 e5             	mov    %rsp,%rbp
  800fb3:	53                   	push   %rbx
  800fb4:	48 89 fa             	mov    %rdi,%rdx
  800fb7:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800fba:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fc9:	be 00 00 00 00       	mov    $0x0,%esi
  800fce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fd4:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800fd6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fda:	c9                   	leave
  800fdb:	c3                   	ret

0000000000800fdc <sys_cgetc>:

int
sys_cgetc(void) {
  800fdc:	f3 0f 1e fa          	endbr64
  800fe0:	55                   	push   %rbp
  800fe1:	48 89 e5             	mov    %rsp,%rbp
  800fe4:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800fe5:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800fea:	ba 00 00 00 00       	mov    $0x0,%edx
  800fef:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800ff4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800ffe:	be 00 00 00 00       	mov    $0x0,%esi
  801003:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801009:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80100b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80100f:	c9                   	leave
  801010:	c3                   	ret

0000000000801011 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801011:	f3 0f 1e fa          	endbr64
  801015:	55                   	push   %rbp
  801016:	48 89 e5             	mov    %rsp,%rbp
  801019:	53                   	push   %rbx
  80101a:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80101e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801021:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801026:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80102b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801030:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801035:	be 00 00 00 00       	mov    $0x0,%esi
  80103a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801040:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801042:	48 85 c0             	test   %rax,%rax
  801045:	7f 06                	jg     80104d <sys_env_destroy+0x3c>
}
  801047:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80104b:	c9                   	leave
  80104c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80104d:	49 89 c0             	mov    %rax,%r8
  801050:	b9 03 00 00 00       	mov    $0x3,%ecx
  801055:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  80105c:	00 00 00 
  80105f:	be 26 00 00 00       	mov    $0x26,%esi
  801064:	48 bf be 31 80 00 00 	movabs $0x8031be,%rdi
  80106b:	00 00 00 
  80106e:	b8 00 00 00 00       	mov    $0x0,%eax
  801073:	49 b9 7b 2a 80 00 00 	movabs $0x802a7b,%r9
  80107a:	00 00 00 
  80107d:	41 ff d1             	call   *%r9

0000000000801080 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801080:	f3 0f 1e fa          	endbr64
  801084:	55                   	push   %rbp
  801085:	48 89 e5             	mov    %rsp,%rbp
  801088:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801089:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80108e:	ba 00 00 00 00       	mov    $0x0,%edx
  801093:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801098:	bb 00 00 00 00       	mov    $0x0,%ebx
  80109d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010a2:	be 00 00 00 00       	mov    $0x0,%esi
  8010a7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010ad:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8010af:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010b3:	c9                   	leave
  8010b4:	c3                   	ret

00000000008010b5 <sys_yield>:

void
sys_yield(void) {
  8010b5:	f3 0f 1e fa          	endbr64
  8010b9:	55                   	push   %rbp
  8010ba:	48 89 e5             	mov    %rsp,%rbp
  8010bd:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010be:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010d7:	be 00 00 00 00       	mov    $0x0,%esi
  8010dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010e2:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8010e4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010e8:	c9                   	leave
  8010e9:	c3                   	ret

00000000008010ea <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8010ea:	f3 0f 1e fa          	endbr64
  8010ee:	55                   	push   %rbp
  8010ef:	48 89 e5             	mov    %rsp,%rbp
  8010f2:	53                   	push   %rbx
  8010f3:	48 89 fa             	mov    %rdi,%rdx
  8010f6:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8010f9:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010fe:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801105:	00 00 00 
  801108:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80110d:	be 00 00 00 00       	mov    $0x0,%esi
  801112:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801118:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80111a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80111e:	c9                   	leave
  80111f:	c3                   	ret

0000000000801120 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801120:	f3 0f 1e fa          	endbr64
  801124:	55                   	push   %rbp
  801125:	48 89 e5             	mov    %rsp,%rbp
  801128:	53                   	push   %rbx
  801129:	49 89 f8             	mov    %rdi,%r8
  80112c:	48 89 d3             	mov    %rdx,%rbx
  80112f:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801132:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801137:	4c 89 c2             	mov    %r8,%rdx
  80113a:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80113d:	be 00 00 00 00       	mov    $0x0,%esi
  801142:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801148:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80114a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80114e:	c9                   	leave
  80114f:	c3                   	ret

0000000000801150 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801150:	f3 0f 1e fa          	endbr64
  801154:	55                   	push   %rbp
  801155:	48 89 e5             	mov    %rsp,%rbp
  801158:	53                   	push   %rbx
  801159:	48 83 ec 08          	sub    $0x8,%rsp
  80115d:	89 f8                	mov    %edi,%eax
  80115f:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801162:	48 63 f9             	movslq %ecx,%rdi
  801165:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801168:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80116d:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801170:	be 00 00 00 00       	mov    $0x0,%esi
  801175:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80117b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80117d:	48 85 c0             	test   %rax,%rax
  801180:	7f 06                	jg     801188 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801182:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801186:	c9                   	leave
  801187:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801188:	49 89 c0             	mov    %rax,%r8
  80118b:	b9 04 00 00 00       	mov    $0x4,%ecx
  801190:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801197:	00 00 00 
  80119a:	be 26 00 00 00       	mov    $0x26,%esi
  80119f:	48 bf be 31 80 00 00 	movabs $0x8031be,%rdi
  8011a6:	00 00 00 
  8011a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ae:	49 b9 7b 2a 80 00 00 	movabs $0x802a7b,%r9
  8011b5:	00 00 00 
  8011b8:	41 ff d1             	call   *%r9

00000000008011bb <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8011bb:	f3 0f 1e fa          	endbr64
  8011bf:	55                   	push   %rbp
  8011c0:	48 89 e5             	mov    %rsp,%rbp
  8011c3:	53                   	push   %rbx
  8011c4:	48 83 ec 08          	sub    $0x8,%rsp
  8011c8:	89 f8                	mov    %edi,%eax
  8011ca:	49 89 f2             	mov    %rsi,%r10
  8011cd:	48 89 cf             	mov    %rcx,%rdi
  8011d0:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8011d3:	48 63 da             	movslq %edx,%rbx
  8011d6:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011d9:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011de:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011e1:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8011e4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011e6:	48 85 c0             	test   %rax,%rax
  8011e9:	7f 06                	jg     8011f1 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8011eb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011ef:	c9                   	leave
  8011f0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011f1:	49 89 c0             	mov    %rax,%r8
  8011f4:	b9 05 00 00 00       	mov    $0x5,%ecx
  8011f9:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801200:	00 00 00 
  801203:	be 26 00 00 00       	mov    $0x26,%esi
  801208:	48 bf be 31 80 00 00 	movabs $0x8031be,%rdi
  80120f:	00 00 00 
  801212:	b8 00 00 00 00       	mov    $0x0,%eax
  801217:	49 b9 7b 2a 80 00 00 	movabs $0x802a7b,%r9
  80121e:	00 00 00 
  801221:	41 ff d1             	call   *%r9

0000000000801224 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801224:	f3 0f 1e fa          	endbr64
  801228:	55                   	push   %rbp
  801229:	48 89 e5             	mov    %rsp,%rbp
  80122c:	53                   	push   %rbx
  80122d:	48 83 ec 08          	sub    $0x8,%rsp
  801231:	49 89 f9             	mov    %rdi,%r9
  801234:	89 f0                	mov    %esi,%eax
  801236:	48 89 d3             	mov    %rdx,%rbx
  801239:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80123c:	49 63 f0             	movslq %r8d,%rsi
  80123f:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801242:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801247:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80124a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801250:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801252:	48 85 c0             	test   %rax,%rax
  801255:	7f 06                	jg     80125d <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801257:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80125b:	c9                   	leave
  80125c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80125d:	49 89 c0             	mov    %rax,%r8
  801260:	b9 06 00 00 00       	mov    $0x6,%ecx
  801265:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  80126c:	00 00 00 
  80126f:	be 26 00 00 00       	mov    $0x26,%esi
  801274:	48 bf be 31 80 00 00 	movabs $0x8031be,%rdi
  80127b:	00 00 00 
  80127e:	b8 00 00 00 00       	mov    $0x0,%eax
  801283:	49 b9 7b 2a 80 00 00 	movabs $0x802a7b,%r9
  80128a:	00 00 00 
  80128d:	41 ff d1             	call   *%r9

0000000000801290 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801290:	f3 0f 1e fa          	endbr64
  801294:	55                   	push   %rbp
  801295:	48 89 e5             	mov    %rsp,%rbp
  801298:	53                   	push   %rbx
  801299:	48 83 ec 08          	sub    $0x8,%rsp
  80129d:	48 89 f1             	mov    %rsi,%rcx
  8012a0:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8012a3:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012a6:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012ab:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012b0:	be 00 00 00 00       	mov    $0x0,%esi
  8012b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012bb:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012bd:	48 85 c0             	test   %rax,%rax
  8012c0:	7f 06                	jg     8012c8 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8012c2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012c6:	c9                   	leave
  8012c7:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012c8:	49 89 c0             	mov    %rax,%r8
  8012cb:	b9 07 00 00 00       	mov    $0x7,%ecx
  8012d0:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8012d7:	00 00 00 
  8012da:	be 26 00 00 00       	mov    $0x26,%esi
  8012df:	48 bf be 31 80 00 00 	movabs $0x8031be,%rdi
  8012e6:	00 00 00 
  8012e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ee:	49 b9 7b 2a 80 00 00 	movabs $0x802a7b,%r9
  8012f5:	00 00 00 
  8012f8:	41 ff d1             	call   *%r9

00000000008012fb <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8012fb:	f3 0f 1e fa          	endbr64
  8012ff:	55                   	push   %rbp
  801300:	48 89 e5             	mov    %rsp,%rbp
  801303:	53                   	push   %rbx
  801304:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801308:	48 63 ce             	movslq %esi,%rcx
  80130b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80130e:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801313:	bb 00 00 00 00       	mov    $0x0,%ebx
  801318:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80131d:	be 00 00 00 00       	mov    $0x0,%esi
  801322:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801328:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80132a:	48 85 c0             	test   %rax,%rax
  80132d:	7f 06                	jg     801335 <sys_env_set_status+0x3a>
}
  80132f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801333:	c9                   	leave
  801334:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801335:	49 89 c0             	mov    %rax,%r8
  801338:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80133d:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801344:	00 00 00 
  801347:	be 26 00 00 00       	mov    $0x26,%esi
  80134c:	48 bf be 31 80 00 00 	movabs $0x8031be,%rdi
  801353:	00 00 00 
  801356:	b8 00 00 00 00       	mov    $0x0,%eax
  80135b:	49 b9 7b 2a 80 00 00 	movabs $0x802a7b,%r9
  801362:	00 00 00 
  801365:	41 ff d1             	call   *%r9

0000000000801368 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801368:	f3 0f 1e fa          	endbr64
  80136c:	55                   	push   %rbp
  80136d:	48 89 e5             	mov    %rsp,%rbp
  801370:	53                   	push   %rbx
  801371:	48 83 ec 08          	sub    $0x8,%rsp
  801375:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801378:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80137b:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801380:	bb 00 00 00 00       	mov    $0x0,%ebx
  801385:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80138a:	be 00 00 00 00       	mov    $0x0,%esi
  80138f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801395:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801397:	48 85 c0             	test   %rax,%rax
  80139a:	7f 06                	jg     8013a2 <sys_env_set_trapframe+0x3a>
}
  80139c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013a0:	c9                   	leave
  8013a1:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013a2:	49 89 c0             	mov    %rax,%r8
  8013a5:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8013aa:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8013b1:	00 00 00 
  8013b4:	be 26 00 00 00       	mov    $0x26,%esi
  8013b9:	48 bf be 31 80 00 00 	movabs $0x8031be,%rdi
  8013c0:	00 00 00 
  8013c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c8:	49 b9 7b 2a 80 00 00 	movabs $0x802a7b,%r9
  8013cf:	00 00 00 
  8013d2:	41 ff d1             	call   *%r9

00000000008013d5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8013d5:	f3 0f 1e fa          	endbr64
  8013d9:	55                   	push   %rbp
  8013da:	48 89 e5             	mov    %rsp,%rbp
  8013dd:	53                   	push   %rbx
  8013de:	48 83 ec 08          	sub    $0x8,%rsp
  8013e2:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8013e5:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013e8:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013f7:	be 00 00 00 00       	mov    $0x0,%esi
  8013fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801402:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801404:	48 85 c0             	test   %rax,%rax
  801407:	7f 06                	jg     80140f <sys_env_set_pgfault_upcall+0x3a>
}
  801409:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80140d:	c9                   	leave
  80140e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80140f:	49 89 c0             	mov    %rax,%r8
  801412:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801417:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  80141e:	00 00 00 
  801421:	be 26 00 00 00       	mov    $0x26,%esi
  801426:	48 bf be 31 80 00 00 	movabs $0x8031be,%rdi
  80142d:	00 00 00 
  801430:	b8 00 00 00 00       	mov    $0x0,%eax
  801435:	49 b9 7b 2a 80 00 00 	movabs $0x802a7b,%r9
  80143c:	00 00 00 
  80143f:	41 ff d1             	call   *%r9

0000000000801442 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801442:	f3 0f 1e fa          	endbr64
  801446:	55                   	push   %rbp
  801447:	48 89 e5             	mov    %rsp,%rbp
  80144a:	53                   	push   %rbx
  80144b:	89 f8                	mov    %edi,%eax
  80144d:	49 89 f1             	mov    %rsi,%r9
  801450:	48 89 d3             	mov    %rdx,%rbx
  801453:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801456:	49 63 f0             	movslq %r8d,%rsi
  801459:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80145c:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801461:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801464:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80146a:	cd 30                	int    $0x30
}
  80146c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801470:	c9                   	leave
  801471:	c3                   	ret

0000000000801472 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801472:	f3 0f 1e fa          	endbr64
  801476:	55                   	push   %rbp
  801477:	48 89 e5             	mov    %rsp,%rbp
  80147a:	53                   	push   %rbx
  80147b:	48 83 ec 08          	sub    $0x8,%rsp
  80147f:	48 89 fa             	mov    %rdi,%rdx
  801482:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801485:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80148a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80148f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801494:	be 00 00 00 00       	mov    $0x0,%esi
  801499:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80149f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014a1:	48 85 c0             	test   %rax,%rax
  8014a4:	7f 06                	jg     8014ac <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8014a6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014aa:	c9                   	leave
  8014ab:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014ac:	49 89 c0             	mov    %rax,%r8
  8014af:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8014b4:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8014bb:	00 00 00 
  8014be:	be 26 00 00 00       	mov    $0x26,%esi
  8014c3:	48 bf be 31 80 00 00 	movabs $0x8031be,%rdi
  8014ca:	00 00 00 
  8014cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d2:	49 b9 7b 2a 80 00 00 	movabs $0x802a7b,%r9
  8014d9:	00 00 00 
  8014dc:	41 ff d1             	call   *%r9

00000000008014df <sys_gettime>:

int
sys_gettime(void) {
  8014df:	f3 0f 1e fa          	endbr64
  8014e3:	55                   	push   %rbp
  8014e4:	48 89 e5             	mov    %rsp,%rbp
  8014e7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014e8:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014fc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801501:	be 00 00 00 00       	mov    $0x0,%esi
  801506:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80150c:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80150e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801512:	c9                   	leave
  801513:	c3                   	ret

0000000000801514 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801514:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801518:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80151f:	ff ff ff 
  801522:	48 01 f8             	add    %rdi,%rax
  801525:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801529:	c3                   	ret

000000000080152a <fd2data>:

char *
fd2data(struct Fd *fd) {
  80152a:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80152e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801535:	ff ff ff 
  801538:	48 01 f8             	add    %rdi,%rax
  80153b:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80153f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801545:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801549:	c3                   	ret

000000000080154a <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80154a:	f3 0f 1e fa          	endbr64
  80154e:	55                   	push   %rbp
  80154f:	48 89 e5             	mov    %rsp,%rbp
  801552:	41 57                	push   %r15
  801554:	41 56                	push   %r14
  801556:	41 55                	push   %r13
  801558:	41 54                	push   %r12
  80155a:	53                   	push   %rbx
  80155b:	48 83 ec 08          	sub    $0x8,%rsp
  80155f:	49 89 ff             	mov    %rdi,%r15
  801562:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801567:	49 bd a9 26 80 00 00 	movabs $0x8026a9,%r13
  80156e:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801571:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801577:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  80157a:	48 89 df             	mov    %rbx,%rdi
  80157d:	41 ff d5             	call   *%r13
  801580:	83 e0 04             	and    $0x4,%eax
  801583:	74 17                	je     80159c <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801585:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80158c:	4c 39 f3             	cmp    %r14,%rbx
  80158f:	75 e6                	jne    801577 <fd_alloc+0x2d>
  801591:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801597:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  80159c:	4d 89 27             	mov    %r12,(%r15)
}
  80159f:	48 83 c4 08          	add    $0x8,%rsp
  8015a3:	5b                   	pop    %rbx
  8015a4:	41 5c                	pop    %r12
  8015a6:	41 5d                	pop    %r13
  8015a8:	41 5e                	pop    %r14
  8015aa:	41 5f                	pop    %r15
  8015ac:	5d                   	pop    %rbp
  8015ad:	c3                   	ret

00000000008015ae <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8015ae:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8015b2:	83 ff 1f             	cmp    $0x1f,%edi
  8015b5:	77 39                	ja     8015f0 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8015b7:	55                   	push   %rbp
  8015b8:	48 89 e5             	mov    %rsp,%rbp
  8015bb:	41 54                	push   %r12
  8015bd:	53                   	push   %rbx
  8015be:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8015c1:	48 63 df             	movslq %edi,%rbx
  8015c4:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8015cb:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8015cf:	48 89 df             	mov    %rbx,%rdi
  8015d2:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  8015d9:	00 00 00 
  8015dc:	ff d0                	call   *%rax
  8015de:	a8 04                	test   $0x4,%al
  8015e0:	74 14                	je     8015f6 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8015e2:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8015e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015eb:	5b                   	pop    %rbx
  8015ec:	41 5c                	pop    %r12
  8015ee:	5d                   	pop    %rbp
  8015ef:	c3                   	ret
        return -E_INVAL;
  8015f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015f5:	c3                   	ret
        return -E_INVAL;
  8015f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015fb:	eb ee                	jmp    8015eb <fd_lookup+0x3d>

00000000008015fd <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8015fd:	f3 0f 1e fa          	endbr64
  801601:	55                   	push   %rbp
  801602:	48 89 e5             	mov    %rsp,%rbp
  801605:	41 54                	push   %r12
  801607:	53                   	push   %rbx
  801608:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  80160b:	48 b8 c0 36 80 00 00 	movabs $0x8036c0,%rax
  801612:	00 00 00 
  801615:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  80161c:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  80161f:	39 3b                	cmp    %edi,(%rbx)
  801621:	74 47                	je     80166a <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801623:	48 83 c0 08          	add    $0x8,%rax
  801627:	48 8b 18             	mov    (%rax),%rbx
  80162a:	48 85 db             	test   %rbx,%rbx
  80162d:	75 f0                	jne    80161f <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80162f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801636:	00 00 00 
  801639:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80163f:	89 fa                	mov    %edi,%edx
  801641:	48 bf 20 36 80 00 00 	movabs $0x803620,%rdi
  801648:	00 00 00 
  80164b:	b8 00 00 00 00       	mov    $0x0,%eax
  801650:	48 b9 02 02 80 00 00 	movabs $0x800202,%rcx
  801657:	00 00 00 
  80165a:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  80165c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801661:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801665:	5b                   	pop    %rbx
  801666:	41 5c                	pop    %r12
  801668:	5d                   	pop    %rbp
  801669:	c3                   	ret
            return 0;
  80166a:	b8 00 00 00 00       	mov    $0x0,%eax
  80166f:	eb f0                	jmp    801661 <dev_lookup+0x64>

0000000000801671 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801671:	f3 0f 1e fa          	endbr64
  801675:	55                   	push   %rbp
  801676:	48 89 e5             	mov    %rsp,%rbp
  801679:	41 55                	push   %r13
  80167b:	41 54                	push   %r12
  80167d:	53                   	push   %rbx
  80167e:	48 83 ec 18          	sub    $0x18,%rsp
  801682:	48 89 fb             	mov    %rdi,%rbx
  801685:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801688:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80168f:	ff ff ff 
  801692:	48 01 df             	add    %rbx,%rdi
  801695:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801699:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80169d:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  8016a4:	00 00 00 
  8016a7:	ff d0                	call   *%rax
  8016a9:	41 89 c5             	mov    %eax,%r13d
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	78 06                	js     8016b6 <fd_close+0x45>
  8016b0:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  8016b4:	74 1a                	je     8016d0 <fd_close+0x5f>
        return (must_exist ? res : 0);
  8016b6:	45 84 e4             	test   %r12b,%r12b
  8016b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016be:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8016c2:	44 89 e8             	mov    %r13d,%eax
  8016c5:	48 83 c4 18          	add    $0x18,%rsp
  8016c9:	5b                   	pop    %rbx
  8016ca:	41 5c                	pop    %r12
  8016cc:	41 5d                	pop    %r13
  8016ce:	5d                   	pop    %rbp
  8016cf:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016d0:	8b 3b                	mov    (%rbx),%edi
  8016d2:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8016d6:	48 b8 fd 15 80 00 00 	movabs $0x8015fd,%rax
  8016dd:	00 00 00 
  8016e0:	ff d0                	call   *%rax
  8016e2:	41 89 c5             	mov    %eax,%r13d
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	78 1b                	js     801704 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8016e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ed:	48 8b 40 20          	mov    0x20(%rax),%rax
  8016f1:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8016f7:	48 85 c0             	test   %rax,%rax
  8016fa:	74 08                	je     801704 <fd_close+0x93>
  8016fc:	48 89 df             	mov    %rbx,%rdi
  8016ff:	ff d0                	call   *%rax
  801701:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801704:	ba 00 10 00 00       	mov    $0x1000,%edx
  801709:	48 89 de             	mov    %rbx,%rsi
  80170c:	bf 00 00 00 00       	mov    $0x0,%edi
  801711:	48 b8 90 12 80 00 00 	movabs $0x801290,%rax
  801718:	00 00 00 
  80171b:	ff d0                	call   *%rax
    return res;
  80171d:	eb a3                	jmp    8016c2 <fd_close+0x51>

000000000080171f <close>:

int
close(int fdnum) {
  80171f:	f3 0f 1e fa          	endbr64
  801723:	55                   	push   %rbp
  801724:	48 89 e5             	mov    %rsp,%rbp
  801727:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80172b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80172f:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  801736:	00 00 00 
  801739:	ff d0                	call   *%rax
    if (res < 0) return res;
  80173b:	85 c0                	test   %eax,%eax
  80173d:	78 15                	js     801754 <close+0x35>

    return fd_close(fd, 1);
  80173f:	be 01 00 00 00       	mov    $0x1,%esi
  801744:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801748:	48 b8 71 16 80 00 00 	movabs $0x801671,%rax
  80174f:	00 00 00 
  801752:	ff d0                	call   *%rax
}
  801754:	c9                   	leave
  801755:	c3                   	ret

0000000000801756 <close_all>:

void
close_all(void) {
  801756:	f3 0f 1e fa          	endbr64
  80175a:	55                   	push   %rbp
  80175b:	48 89 e5             	mov    %rsp,%rbp
  80175e:	41 54                	push   %r12
  801760:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801761:	bb 00 00 00 00       	mov    $0x0,%ebx
  801766:	49 bc 1f 17 80 00 00 	movabs $0x80171f,%r12
  80176d:	00 00 00 
  801770:	89 df                	mov    %ebx,%edi
  801772:	41 ff d4             	call   *%r12
  801775:	83 c3 01             	add    $0x1,%ebx
  801778:	83 fb 20             	cmp    $0x20,%ebx
  80177b:	75 f3                	jne    801770 <close_all+0x1a>
}
  80177d:	5b                   	pop    %rbx
  80177e:	41 5c                	pop    %r12
  801780:	5d                   	pop    %rbp
  801781:	c3                   	ret

0000000000801782 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801782:	f3 0f 1e fa          	endbr64
  801786:	55                   	push   %rbp
  801787:	48 89 e5             	mov    %rsp,%rbp
  80178a:	41 57                	push   %r15
  80178c:	41 56                	push   %r14
  80178e:	41 55                	push   %r13
  801790:	41 54                	push   %r12
  801792:	53                   	push   %rbx
  801793:	48 83 ec 18          	sub    $0x18,%rsp
  801797:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80179a:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  80179e:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  8017a5:	00 00 00 
  8017a8:	ff d0                	call   *%rax
  8017aa:	89 c3                	mov    %eax,%ebx
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	0f 88 b8 00 00 00    	js     80186c <dup+0xea>
    close(newfdnum);
  8017b4:	44 89 e7             	mov    %r12d,%edi
  8017b7:	48 b8 1f 17 80 00 00 	movabs $0x80171f,%rax
  8017be:	00 00 00 
  8017c1:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8017c3:	4d 63 ec             	movslq %r12d,%r13
  8017c6:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8017cd:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8017d1:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8017d5:	4c 89 ff             	mov    %r15,%rdi
  8017d8:	49 be 2a 15 80 00 00 	movabs $0x80152a,%r14
  8017df:	00 00 00 
  8017e2:	41 ff d6             	call   *%r14
  8017e5:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8017e8:	4c 89 ef             	mov    %r13,%rdi
  8017eb:	41 ff d6             	call   *%r14
  8017ee:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8017f1:	48 89 df             	mov    %rbx,%rdi
  8017f4:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  8017fb:	00 00 00 
  8017fe:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801800:	a8 04                	test   $0x4,%al
  801802:	74 2b                	je     80182f <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801804:	41 89 c1             	mov    %eax,%r9d
  801807:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80180d:	4c 89 f1             	mov    %r14,%rcx
  801810:	ba 00 00 00 00       	mov    $0x0,%edx
  801815:	48 89 de             	mov    %rbx,%rsi
  801818:	bf 00 00 00 00       	mov    $0x0,%edi
  80181d:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  801824:	00 00 00 
  801827:	ff d0                	call   *%rax
  801829:	89 c3                	mov    %eax,%ebx
  80182b:	85 c0                	test   %eax,%eax
  80182d:	78 4e                	js     80187d <dup+0xfb>
    }
    prot = get_prot(oldfd);
  80182f:	4c 89 ff             	mov    %r15,%rdi
  801832:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  801839:	00 00 00 
  80183c:	ff d0                	call   *%rax
  80183e:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801841:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801847:	4c 89 e9             	mov    %r13,%rcx
  80184a:	ba 00 00 00 00       	mov    $0x0,%edx
  80184f:	4c 89 fe             	mov    %r15,%rsi
  801852:	bf 00 00 00 00       	mov    $0x0,%edi
  801857:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  80185e:	00 00 00 
  801861:	ff d0                	call   *%rax
  801863:	89 c3                	mov    %eax,%ebx
  801865:	85 c0                	test   %eax,%eax
  801867:	78 14                	js     80187d <dup+0xfb>

    return newfdnum;
  801869:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  80186c:	89 d8                	mov    %ebx,%eax
  80186e:	48 83 c4 18          	add    $0x18,%rsp
  801872:	5b                   	pop    %rbx
  801873:	41 5c                	pop    %r12
  801875:	41 5d                	pop    %r13
  801877:	41 5e                	pop    %r14
  801879:	41 5f                	pop    %r15
  80187b:	5d                   	pop    %rbp
  80187c:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80187d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801882:	4c 89 ee             	mov    %r13,%rsi
  801885:	bf 00 00 00 00       	mov    $0x0,%edi
  80188a:	49 bc 90 12 80 00 00 	movabs $0x801290,%r12
  801891:	00 00 00 
  801894:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801897:	ba 00 10 00 00       	mov    $0x1000,%edx
  80189c:	4c 89 f6             	mov    %r14,%rsi
  80189f:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a4:	41 ff d4             	call   *%r12
    return res;
  8018a7:	eb c3                	jmp    80186c <dup+0xea>

00000000008018a9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8018a9:	f3 0f 1e fa          	endbr64
  8018ad:	55                   	push   %rbp
  8018ae:	48 89 e5             	mov    %rsp,%rbp
  8018b1:	41 56                	push   %r14
  8018b3:	41 55                	push   %r13
  8018b5:	41 54                	push   %r12
  8018b7:	53                   	push   %rbx
  8018b8:	48 83 ec 10          	sub    $0x10,%rsp
  8018bc:	89 fb                	mov    %edi,%ebx
  8018be:	49 89 f4             	mov    %rsi,%r12
  8018c1:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8018c4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018c8:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  8018cf:	00 00 00 
  8018d2:	ff d0                	call   *%rax
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	78 4c                	js     801924 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8018d8:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8018dc:	41 8b 3e             	mov    (%r14),%edi
  8018df:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018e3:	48 b8 fd 15 80 00 00 	movabs $0x8015fd,%rax
  8018ea:	00 00 00 
  8018ed:	ff d0                	call   *%rax
  8018ef:	85 c0                	test   %eax,%eax
  8018f1:	78 35                	js     801928 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018f3:	41 8b 46 08          	mov    0x8(%r14),%eax
  8018f7:	83 e0 03             	and    $0x3,%eax
  8018fa:	83 f8 01             	cmp    $0x1,%eax
  8018fd:	74 2d                	je     80192c <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8018ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801903:	48 8b 40 10          	mov    0x10(%rax),%rax
  801907:	48 85 c0             	test   %rax,%rax
  80190a:	74 56                	je     801962 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  80190c:	4c 89 ea             	mov    %r13,%rdx
  80190f:	4c 89 e6             	mov    %r12,%rsi
  801912:	4c 89 f7             	mov    %r14,%rdi
  801915:	ff d0                	call   *%rax
}
  801917:	48 83 c4 10          	add    $0x10,%rsp
  80191b:	5b                   	pop    %rbx
  80191c:	41 5c                	pop    %r12
  80191e:	41 5d                	pop    %r13
  801920:	41 5e                	pop    %r14
  801922:	5d                   	pop    %rbp
  801923:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801924:	48 98                	cltq
  801926:	eb ef                	jmp    801917 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801928:	48 98                	cltq
  80192a:	eb eb                	jmp    801917 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80192c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801933:	00 00 00 
  801936:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80193c:	89 da                	mov    %ebx,%edx
  80193e:	48 bf cc 31 80 00 00 	movabs $0x8031cc,%rdi
  801945:	00 00 00 
  801948:	b8 00 00 00 00       	mov    $0x0,%eax
  80194d:	48 b9 02 02 80 00 00 	movabs $0x800202,%rcx
  801954:	00 00 00 
  801957:	ff d1                	call   *%rcx
        return -E_INVAL;
  801959:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801960:	eb b5                	jmp    801917 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801962:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801969:	eb ac                	jmp    801917 <read+0x6e>

000000000080196b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  80196b:	f3 0f 1e fa          	endbr64
  80196f:	55                   	push   %rbp
  801970:	48 89 e5             	mov    %rsp,%rbp
  801973:	41 57                	push   %r15
  801975:	41 56                	push   %r14
  801977:	41 55                	push   %r13
  801979:	41 54                	push   %r12
  80197b:	53                   	push   %rbx
  80197c:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801980:	48 85 d2             	test   %rdx,%rdx
  801983:	74 54                	je     8019d9 <readn+0x6e>
  801985:	41 89 fd             	mov    %edi,%r13d
  801988:	49 89 f6             	mov    %rsi,%r14
  80198b:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  80198e:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801993:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801998:	49 bf a9 18 80 00 00 	movabs $0x8018a9,%r15
  80199f:	00 00 00 
  8019a2:	4c 89 e2             	mov    %r12,%rdx
  8019a5:	48 29 f2             	sub    %rsi,%rdx
  8019a8:	4c 01 f6             	add    %r14,%rsi
  8019ab:	44 89 ef             	mov    %r13d,%edi
  8019ae:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	78 20                	js     8019d5 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  8019b5:	01 c3                	add    %eax,%ebx
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	74 08                	je     8019c3 <readn+0x58>
  8019bb:	48 63 f3             	movslq %ebx,%rsi
  8019be:	4c 39 e6             	cmp    %r12,%rsi
  8019c1:	72 df                	jb     8019a2 <readn+0x37>
    }
    return res;
  8019c3:	48 63 c3             	movslq %ebx,%rax
}
  8019c6:	48 83 c4 08          	add    $0x8,%rsp
  8019ca:	5b                   	pop    %rbx
  8019cb:	41 5c                	pop    %r12
  8019cd:	41 5d                	pop    %r13
  8019cf:	41 5e                	pop    %r14
  8019d1:	41 5f                	pop    %r15
  8019d3:	5d                   	pop    %rbp
  8019d4:	c3                   	ret
        if (inc < 0) return inc;
  8019d5:	48 98                	cltq
  8019d7:	eb ed                	jmp    8019c6 <readn+0x5b>
    int inc = 1, res = 0;
  8019d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019de:	eb e3                	jmp    8019c3 <readn+0x58>

00000000008019e0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8019e0:	f3 0f 1e fa          	endbr64
  8019e4:	55                   	push   %rbp
  8019e5:	48 89 e5             	mov    %rsp,%rbp
  8019e8:	41 56                	push   %r14
  8019ea:	41 55                	push   %r13
  8019ec:	41 54                	push   %r12
  8019ee:	53                   	push   %rbx
  8019ef:	48 83 ec 10          	sub    $0x10,%rsp
  8019f3:	89 fb                	mov    %edi,%ebx
  8019f5:	49 89 f4             	mov    %rsi,%r12
  8019f8:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019fb:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019ff:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  801a06:	00 00 00 
  801a09:	ff d0                	call   *%rax
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	78 47                	js     801a56 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a0f:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801a13:	41 8b 3e             	mov    (%r14),%edi
  801a16:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a1a:	48 b8 fd 15 80 00 00 	movabs $0x8015fd,%rax
  801a21:	00 00 00 
  801a24:	ff d0                	call   *%rax
  801a26:	85 c0                	test   %eax,%eax
  801a28:	78 30                	js     801a5a <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a2a:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801a2f:	74 2d                	je     801a5e <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801a31:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a35:	48 8b 40 18          	mov    0x18(%rax),%rax
  801a39:	48 85 c0             	test   %rax,%rax
  801a3c:	74 56                	je     801a94 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801a3e:	4c 89 ea             	mov    %r13,%rdx
  801a41:	4c 89 e6             	mov    %r12,%rsi
  801a44:	4c 89 f7             	mov    %r14,%rdi
  801a47:	ff d0                	call   *%rax
}
  801a49:	48 83 c4 10          	add    $0x10,%rsp
  801a4d:	5b                   	pop    %rbx
  801a4e:	41 5c                	pop    %r12
  801a50:	41 5d                	pop    %r13
  801a52:	41 5e                	pop    %r14
  801a54:	5d                   	pop    %rbp
  801a55:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a56:	48 98                	cltq
  801a58:	eb ef                	jmp    801a49 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a5a:	48 98                	cltq
  801a5c:	eb eb                	jmp    801a49 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a5e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a65:	00 00 00 
  801a68:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a6e:	89 da                	mov    %ebx,%edx
  801a70:	48 bf e8 31 80 00 00 	movabs $0x8031e8,%rdi
  801a77:	00 00 00 
  801a7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7f:	48 b9 02 02 80 00 00 	movabs $0x800202,%rcx
  801a86:	00 00 00 
  801a89:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a8b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801a92:	eb b5                	jmp    801a49 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801a94:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a9b:	eb ac                	jmp    801a49 <write+0x69>

0000000000801a9d <seek>:

int
seek(int fdnum, off_t offset) {
  801a9d:	f3 0f 1e fa          	endbr64
  801aa1:	55                   	push   %rbp
  801aa2:	48 89 e5             	mov    %rsp,%rbp
  801aa5:	53                   	push   %rbx
  801aa6:	48 83 ec 18          	sub    $0x18,%rsp
  801aaa:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801aac:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ab0:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  801ab7:	00 00 00 
  801aba:	ff d0                	call   *%rax
  801abc:	85 c0                	test   %eax,%eax
  801abe:	78 0c                	js     801acc <seek+0x2f>

    fd->fd_offset = offset;
  801ac0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ac4:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801acc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ad0:	c9                   	leave
  801ad1:	c3                   	ret

0000000000801ad2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801ad2:	f3 0f 1e fa          	endbr64
  801ad6:	55                   	push   %rbp
  801ad7:	48 89 e5             	mov    %rsp,%rbp
  801ada:	41 55                	push   %r13
  801adc:	41 54                	push   %r12
  801ade:	53                   	push   %rbx
  801adf:	48 83 ec 18          	sub    $0x18,%rsp
  801ae3:	89 fb                	mov    %edi,%ebx
  801ae5:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ae8:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801aec:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  801af3:	00 00 00 
  801af6:	ff d0                	call   *%rax
  801af8:	85 c0                	test   %eax,%eax
  801afa:	78 38                	js     801b34 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801afc:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801b00:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801b04:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b08:	48 b8 fd 15 80 00 00 	movabs $0x8015fd,%rax
  801b0f:	00 00 00 
  801b12:	ff d0                	call   *%rax
  801b14:	85 c0                	test   %eax,%eax
  801b16:	78 1c                	js     801b34 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b18:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801b1d:	74 20                	je     801b3f <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801b1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b23:	48 8b 40 30          	mov    0x30(%rax),%rax
  801b27:	48 85 c0             	test   %rax,%rax
  801b2a:	74 47                	je     801b73 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801b2c:	44 89 e6             	mov    %r12d,%esi
  801b2f:	4c 89 ef             	mov    %r13,%rdi
  801b32:	ff d0                	call   *%rax
}
  801b34:	48 83 c4 18          	add    $0x18,%rsp
  801b38:	5b                   	pop    %rbx
  801b39:	41 5c                	pop    %r12
  801b3b:	41 5d                	pop    %r13
  801b3d:	5d                   	pop    %rbp
  801b3e:	c3                   	ret
                thisenv->env_id, fdnum);
  801b3f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b46:	00 00 00 
  801b49:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b4f:	89 da                	mov    %ebx,%edx
  801b51:	48 bf 40 36 80 00 00 	movabs $0x803640,%rdi
  801b58:	00 00 00 
  801b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b60:	48 b9 02 02 80 00 00 	movabs $0x800202,%rcx
  801b67:	00 00 00 
  801b6a:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b6c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b71:	eb c1                	jmp    801b34 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801b73:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801b78:	eb ba                	jmp    801b34 <ftruncate+0x62>

0000000000801b7a <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801b7a:	f3 0f 1e fa          	endbr64
  801b7e:	55                   	push   %rbp
  801b7f:	48 89 e5             	mov    %rsp,%rbp
  801b82:	41 54                	push   %r12
  801b84:	53                   	push   %rbx
  801b85:	48 83 ec 10          	sub    $0x10,%rsp
  801b89:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b8c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801b90:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  801b97:	00 00 00 
  801b9a:	ff d0                	call   *%rax
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	78 4e                	js     801bee <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ba0:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801ba4:	41 8b 3c 24          	mov    (%r12),%edi
  801ba8:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801bac:	48 b8 fd 15 80 00 00 	movabs $0x8015fd,%rax
  801bb3:	00 00 00 
  801bb6:	ff d0                	call   *%rax
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	78 32                	js     801bee <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801bbc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bc0:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801bc5:	74 30                	je     801bf7 <fstat+0x7d>

    stat->st_name[0] = 0;
  801bc7:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801bca:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801bd1:	00 00 00 
    stat->st_isdir = 0;
  801bd4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801bdb:	00 00 00 
    stat->st_dev = dev;
  801bde:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801be5:	48 89 de             	mov    %rbx,%rsi
  801be8:	4c 89 e7             	mov    %r12,%rdi
  801beb:	ff 50 28             	call   *0x28(%rax)
}
  801bee:	48 83 c4 10          	add    $0x10,%rsp
  801bf2:	5b                   	pop    %rbx
  801bf3:	41 5c                	pop    %r12
  801bf5:	5d                   	pop    %rbp
  801bf6:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801bf7:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801bfc:	eb f0                	jmp    801bee <fstat+0x74>

0000000000801bfe <stat>:

int
stat(const char *path, struct Stat *stat) {
  801bfe:	f3 0f 1e fa          	endbr64
  801c02:	55                   	push   %rbp
  801c03:	48 89 e5             	mov    %rsp,%rbp
  801c06:	41 54                	push   %r12
  801c08:	53                   	push   %rbx
  801c09:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801c0c:	be 00 00 00 00       	mov    $0x0,%esi
  801c11:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  801c18:	00 00 00 
  801c1b:	ff d0                	call   *%rax
  801c1d:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	78 25                	js     801c48 <stat+0x4a>

    int res = fstat(fd, stat);
  801c23:	4c 89 e6             	mov    %r12,%rsi
  801c26:	89 c7                	mov    %eax,%edi
  801c28:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  801c2f:	00 00 00 
  801c32:	ff d0                	call   *%rax
  801c34:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801c37:	89 df                	mov    %ebx,%edi
  801c39:	48 b8 1f 17 80 00 00 	movabs $0x80171f,%rax
  801c40:	00 00 00 
  801c43:	ff d0                	call   *%rax

    return res;
  801c45:	44 89 e3             	mov    %r12d,%ebx
}
  801c48:	89 d8                	mov    %ebx,%eax
  801c4a:	5b                   	pop    %rbx
  801c4b:	41 5c                	pop    %r12
  801c4d:	5d                   	pop    %rbp
  801c4e:	c3                   	ret

0000000000801c4f <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801c4f:	f3 0f 1e fa          	endbr64
  801c53:	55                   	push   %rbp
  801c54:	48 89 e5             	mov    %rsp,%rbp
  801c57:	41 54                	push   %r12
  801c59:	53                   	push   %rbx
  801c5a:	48 83 ec 10          	sub    $0x10,%rsp
  801c5e:	41 89 fc             	mov    %edi,%r12d
  801c61:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801c64:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c6b:	00 00 00 
  801c6e:	83 38 00             	cmpl   $0x0,(%rax)
  801c71:	74 6e                	je     801ce1 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801c73:	bf 03 00 00 00       	mov    $0x3,%edi
  801c78:	48 b8 7d 2c 80 00 00 	movabs $0x802c7d,%rax
  801c7f:	00 00 00 
  801c82:	ff d0                	call   *%rax
  801c84:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801c8b:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801c8d:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801c93:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c98:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801c9f:	00 00 00 
  801ca2:	44 89 e6             	mov    %r12d,%esi
  801ca5:	89 c7                	mov    %eax,%edi
  801ca7:	48 b8 bb 2b 80 00 00 	movabs $0x802bbb,%rax
  801cae:	00 00 00 
  801cb1:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801cb3:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801cba:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801cbb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801cc4:	48 89 de             	mov    %rbx,%rsi
  801cc7:	bf 00 00 00 00       	mov    $0x0,%edi
  801ccc:	48 b8 22 2b 80 00 00 	movabs $0x802b22,%rax
  801cd3:	00 00 00 
  801cd6:	ff d0                	call   *%rax
}
  801cd8:	48 83 c4 10          	add    $0x10,%rsp
  801cdc:	5b                   	pop    %rbx
  801cdd:	41 5c                	pop    %r12
  801cdf:	5d                   	pop    %rbp
  801ce0:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801ce1:	bf 03 00 00 00       	mov    $0x3,%edi
  801ce6:	48 b8 7d 2c 80 00 00 	movabs $0x802c7d,%rax
  801ced:	00 00 00 
  801cf0:	ff d0                	call   *%rax
  801cf2:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801cf9:	00 00 
  801cfb:	e9 73 ff ff ff       	jmp    801c73 <fsipc+0x24>

0000000000801d00 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801d00:	f3 0f 1e fa          	endbr64
  801d04:	55                   	push   %rbp
  801d05:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d08:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801d0f:	00 00 00 
  801d12:	8b 57 0c             	mov    0xc(%rdi),%edx
  801d15:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801d17:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801d1a:	be 00 00 00 00       	mov    $0x0,%esi
  801d1f:	bf 02 00 00 00       	mov    $0x2,%edi
  801d24:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  801d2b:	00 00 00 
  801d2e:	ff d0                	call   *%rax
}
  801d30:	5d                   	pop    %rbp
  801d31:	c3                   	ret

0000000000801d32 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801d32:	f3 0f 1e fa          	endbr64
  801d36:	55                   	push   %rbp
  801d37:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d3a:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d3d:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d44:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801d46:	be 00 00 00 00       	mov    $0x0,%esi
  801d4b:	bf 06 00 00 00       	mov    $0x6,%edi
  801d50:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  801d57:	00 00 00 
  801d5a:	ff d0                	call   *%rax
}
  801d5c:	5d                   	pop    %rbp
  801d5d:	c3                   	ret

0000000000801d5e <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801d5e:	f3 0f 1e fa          	endbr64
  801d62:	55                   	push   %rbp
  801d63:	48 89 e5             	mov    %rsp,%rbp
  801d66:	41 54                	push   %r12
  801d68:	53                   	push   %rbx
  801d69:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d6c:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d6f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d76:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801d78:	be 00 00 00 00       	mov    $0x0,%esi
  801d7d:	bf 05 00 00 00       	mov    $0x5,%edi
  801d82:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  801d89:	00 00 00 
  801d8c:	ff d0                	call   *%rax
    if (res < 0) return res;
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	78 3d                	js     801dcf <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d92:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  801d99:	00 00 00 
  801d9c:	4c 89 e6             	mov    %r12,%rsi
  801d9f:	48 89 df             	mov    %rbx,%rdi
  801da2:	48 b8 4b 0b 80 00 00 	movabs $0x800b4b,%rax
  801da9:	00 00 00 
  801dac:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801dae:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801db5:	00 
  801db6:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dbc:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801dc3:	00 
  801dc4:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801dca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcf:	5b                   	pop    %rbx
  801dd0:	41 5c                	pop    %r12
  801dd2:	5d                   	pop    %rbp
  801dd3:	c3                   	ret

0000000000801dd4 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801dd4:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801dd8:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801ddf:	77 41                	ja     801e22 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801de1:	55                   	push   %rbp
  801de2:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801de5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801dec:	00 00 00 
  801def:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801df2:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  801df4:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801df8:	48 8d 78 10          	lea    0x10(%rax),%rdi
  801dfc:	48 b8 66 0d 80 00 00 	movabs $0x800d66,%rax
  801e03:	00 00 00 
  801e06:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  801e08:	be 00 00 00 00       	mov    $0x0,%esi
  801e0d:	bf 04 00 00 00       	mov    $0x4,%edi
  801e12:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  801e19:	00 00 00 
  801e1c:	ff d0                	call   *%rax
  801e1e:	48 98                	cltq
}
  801e20:	5d                   	pop    %rbp
  801e21:	c3                   	ret
        return -E_INVAL;
  801e22:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  801e29:	c3                   	ret

0000000000801e2a <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801e2a:	f3 0f 1e fa          	endbr64
  801e2e:	55                   	push   %rbp
  801e2f:	48 89 e5             	mov    %rsp,%rbp
  801e32:	41 55                	push   %r13
  801e34:	41 54                	push   %r12
  801e36:	53                   	push   %rbx
  801e37:	48 83 ec 08          	sub    $0x8,%rsp
  801e3b:	49 89 f4             	mov    %rsi,%r12
  801e3e:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e41:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e48:	00 00 00 
  801e4b:	8b 57 0c             	mov    0xc(%rdi),%edx
  801e4e:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  801e50:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  801e54:	be 00 00 00 00       	mov    $0x0,%esi
  801e59:	bf 03 00 00 00       	mov    $0x3,%edi
  801e5e:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  801e65:	00 00 00 
  801e68:	ff d0                	call   *%rax
  801e6a:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  801e6d:	4d 85 ed             	test   %r13,%r13
  801e70:	78 2a                	js     801e9c <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  801e72:	4c 89 ea             	mov    %r13,%rdx
  801e75:	4c 39 eb             	cmp    %r13,%rbx
  801e78:	72 30                	jb     801eaa <devfile_read+0x80>
  801e7a:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  801e81:	7f 27                	jg     801eaa <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  801e83:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801e8a:	00 00 00 
  801e8d:	4c 89 e7             	mov    %r12,%rdi
  801e90:	48 b8 66 0d 80 00 00 	movabs $0x800d66,%rax
  801e97:	00 00 00 
  801e9a:	ff d0                	call   *%rax
}
  801e9c:	4c 89 e8             	mov    %r13,%rax
  801e9f:	48 83 c4 08          	add    $0x8,%rsp
  801ea3:	5b                   	pop    %rbx
  801ea4:	41 5c                	pop    %r12
  801ea6:	41 5d                	pop    %r13
  801ea8:	5d                   	pop    %rbp
  801ea9:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801eaa:	48 b9 05 32 80 00 00 	movabs $0x803205,%rcx
  801eb1:	00 00 00 
  801eb4:	48 ba 22 32 80 00 00 	movabs $0x803222,%rdx
  801ebb:	00 00 00 
  801ebe:	be 7b 00 00 00       	mov    $0x7b,%esi
  801ec3:	48 bf 37 32 80 00 00 	movabs $0x803237,%rdi
  801eca:	00 00 00 
  801ecd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed2:	49 b8 7b 2a 80 00 00 	movabs $0x802a7b,%r8
  801ed9:	00 00 00 
  801edc:	41 ff d0             	call   *%r8

0000000000801edf <open>:
open(const char *path, int mode) {
  801edf:	f3 0f 1e fa          	endbr64
  801ee3:	55                   	push   %rbp
  801ee4:	48 89 e5             	mov    %rsp,%rbp
  801ee7:	41 55                	push   %r13
  801ee9:	41 54                	push   %r12
  801eeb:	53                   	push   %rbx
  801eec:	48 83 ec 18          	sub    $0x18,%rsp
  801ef0:	49 89 fc             	mov    %rdi,%r12
  801ef3:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801ef6:	48 b8 06 0b 80 00 00 	movabs $0x800b06,%rax
  801efd:	00 00 00 
  801f00:	ff d0                	call   *%rax
  801f02:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801f08:	0f 87 8a 00 00 00    	ja     801f98 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801f0e:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801f12:	48 b8 4a 15 80 00 00 	movabs $0x80154a,%rax
  801f19:	00 00 00 
  801f1c:	ff d0                	call   *%rax
  801f1e:	89 c3                	mov    %eax,%ebx
  801f20:	85 c0                	test   %eax,%eax
  801f22:	78 50                	js     801f74 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  801f24:	4c 89 e6             	mov    %r12,%rsi
  801f27:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801f2e:	00 00 00 
  801f31:	48 89 df             	mov    %rbx,%rdi
  801f34:	48 b8 4b 0b 80 00 00 	movabs $0x800b4b,%rax
  801f3b:	00 00 00 
  801f3e:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801f40:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f47:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801f4b:	bf 01 00 00 00       	mov    $0x1,%edi
  801f50:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  801f57:	00 00 00 
  801f5a:	ff d0                	call   *%rax
  801f5c:	89 c3                	mov    %eax,%ebx
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	78 1f                	js     801f81 <open+0xa2>
    return fd2num(fd);
  801f62:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f66:	48 b8 14 15 80 00 00 	movabs $0x801514,%rax
  801f6d:	00 00 00 
  801f70:	ff d0                	call   *%rax
  801f72:	89 c3                	mov    %eax,%ebx
}
  801f74:	89 d8                	mov    %ebx,%eax
  801f76:	48 83 c4 18          	add    $0x18,%rsp
  801f7a:	5b                   	pop    %rbx
  801f7b:	41 5c                	pop    %r12
  801f7d:	41 5d                	pop    %r13
  801f7f:	5d                   	pop    %rbp
  801f80:	c3                   	ret
        fd_close(fd, 0);
  801f81:	be 00 00 00 00       	mov    $0x0,%esi
  801f86:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f8a:	48 b8 71 16 80 00 00 	movabs $0x801671,%rax
  801f91:	00 00 00 
  801f94:	ff d0                	call   *%rax
        return res;
  801f96:	eb dc                	jmp    801f74 <open+0x95>
        return -E_BAD_PATH;
  801f98:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801f9d:	eb d5                	jmp    801f74 <open+0x95>

0000000000801f9f <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801f9f:	f3 0f 1e fa          	endbr64
  801fa3:	55                   	push   %rbp
  801fa4:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801fa7:	be 00 00 00 00       	mov    $0x0,%esi
  801fac:	bf 08 00 00 00       	mov    $0x8,%edi
  801fb1:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  801fb8:	00 00 00 
  801fbb:	ff d0                	call   *%rax
}
  801fbd:	5d                   	pop    %rbp
  801fbe:	c3                   	ret

0000000000801fbf <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801fbf:	f3 0f 1e fa          	endbr64
  801fc3:	55                   	push   %rbp
  801fc4:	48 89 e5             	mov    %rsp,%rbp
  801fc7:	41 54                	push   %r12
  801fc9:	53                   	push   %rbx
  801fca:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801fcd:	48 b8 2a 15 80 00 00 	movabs $0x80152a,%rax
  801fd4:	00 00 00 
  801fd7:	ff d0                	call   *%rax
  801fd9:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801fdc:	48 be 42 32 80 00 00 	movabs $0x803242,%rsi
  801fe3:	00 00 00 
  801fe6:	48 89 df             	mov    %rbx,%rdi
  801fe9:	48 b8 4b 0b 80 00 00 	movabs $0x800b4b,%rax
  801ff0:	00 00 00 
  801ff3:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801ff5:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801ffa:	41 2b 04 24          	sub    (%r12),%eax
  801ffe:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802004:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80200b:	00 00 00 
    stat->st_dev = &devpipe;
  80200e:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802015:	00 00 00 
  802018:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80201f:	b8 00 00 00 00       	mov    $0x0,%eax
  802024:	5b                   	pop    %rbx
  802025:	41 5c                	pop    %r12
  802027:	5d                   	pop    %rbp
  802028:	c3                   	ret

0000000000802029 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802029:	f3 0f 1e fa          	endbr64
  80202d:	55                   	push   %rbp
  80202e:	48 89 e5             	mov    %rsp,%rbp
  802031:	41 54                	push   %r12
  802033:	53                   	push   %rbx
  802034:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802037:	ba 00 10 00 00       	mov    $0x1000,%edx
  80203c:	48 89 fe             	mov    %rdi,%rsi
  80203f:	bf 00 00 00 00       	mov    $0x0,%edi
  802044:	49 bc 90 12 80 00 00 	movabs $0x801290,%r12
  80204b:	00 00 00 
  80204e:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802051:	48 89 df             	mov    %rbx,%rdi
  802054:	48 b8 2a 15 80 00 00 	movabs $0x80152a,%rax
  80205b:	00 00 00 
  80205e:	ff d0                	call   *%rax
  802060:	48 89 c6             	mov    %rax,%rsi
  802063:	ba 00 10 00 00       	mov    $0x1000,%edx
  802068:	bf 00 00 00 00       	mov    $0x0,%edi
  80206d:	41 ff d4             	call   *%r12
}
  802070:	5b                   	pop    %rbx
  802071:	41 5c                	pop    %r12
  802073:	5d                   	pop    %rbp
  802074:	c3                   	ret

0000000000802075 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802075:	f3 0f 1e fa          	endbr64
  802079:	55                   	push   %rbp
  80207a:	48 89 e5             	mov    %rsp,%rbp
  80207d:	41 57                	push   %r15
  80207f:	41 56                	push   %r14
  802081:	41 55                	push   %r13
  802083:	41 54                	push   %r12
  802085:	53                   	push   %rbx
  802086:	48 83 ec 18          	sub    $0x18,%rsp
  80208a:	49 89 fc             	mov    %rdi,%r12
  80208d:	49 89 f5             	mov    %rsi,%r13
  802090:	49 89 d7             	mov    %rdx,%r15
  802093:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802097:	48 b8 2a 15 80 00 00 	movabs $0x80152a,%rax
  80209e:	00 00 00 
  8020a1:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8020a3:	4d 85 ff             	test   %r15,%r15
  8020a6:	0f 84 af 00 00 00    	je     80215b <devpipe_write+0xe6>
  8020ac:	48 89 c3             	mov    %rax,%rbx
  8020af:	4c 89 f8             	mov    %r15,%rax
  8020b2:	4d 89 ef             	mov    %r13,%r15
  8020b5:	4c 01 e8             	add    %r13,%rax
  8020b8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8020bc:	49 bd 20 11 80 00 00 	movabs $0x801120,%r13
  8020c3:	00 00 00 
            sys_yield();
  8020c6:	49 be b5 10 80 00 00 	movabs $0x8010b5,%r14
  8020cd:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8020d0:	8b 73 04             	mov    0x4(%rbx),%esi
  8020d3:	48 63 ce             	movslq %esi,%rcx
  8020d6:	48 63 03             	movslq (%rbx),%rax
  8020d9:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8020df:	48 39 c1             	cmp    %rax,%rcx
  8020e2:	72 2e                	jb     802112 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8020e4:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020e9:	48 89 da             	mov    %rbx,%rdx
  8020ec:	be 00 10 00 00       	mov    $0x1000,%esi
  8020f1:	4c 89 e7             	mov    %r12,%rdi
  8020f4:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	74 66                	je     802161 <devpipe_write+0xec>
            sys_yield();
  8020fb:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8020fe:	8b 73 04             	mov    0x4(%rbx),%esi
  802101:	48 63 ce             	movslq %esi,%rcx
  802104:	48 63 03             	movslq (%rbx),%rax
  802107:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80210d:	48 39 c1             	cmp    %rax,%rcx
  802110:	73 d2                	jae    8020e4 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802112:	41 0f b6 3f          	movzbl (%r15),%edi
  802116:	48 89 ca             	mov    %rcx,%rdx
  802119:	48 c1 ea 03          	shr    $0x3,%rdx
  80211d:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802124:	08 10 20 
  802127:	48 f7 e2             	mul    %rdx
  80212a:	48 c1 ea 06          	shr    $0x6,%rdx
  80212e:	48 89 d0             	mov    %rdx,%rax
  802131:	48 c1 e0 09          	shl    $0x9,%rax
  802135:	48 29 d0             	sub    %rdx,%rax
  802138:	48 c1 e0 03          	shl    $0x3,%rax
  80213c:	48 29 c1             	sub    %rax,%rcx
  80213f:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802144:	83 c6 01             	add    $0x1,%esi
  802147:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80214a:	49 83 c7 01          	add    $0x1,%r15
  80214e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802152:	49 39 c7             	cmp    %rax,%r15
  802155:	0f 85 75 ff ff ff    	jne    8020d0 <devpipe_write+0x5b>
    return n;
  80215b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80215f:	eb 05                	jmp    802166 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802161:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802166:	48 83 c4 18          	add    $0x18,%rsp
  80216a:	5b                   	pop    %rbx
  80216b:	41 5c                	pop    %r12
  80216d:	41 5d                	pop    %r13
  80216f:	41 5e                	pop    %r14
  802171:	41 5f                	pop    %r15
  802173:	5d                   	pop    %rbp
  802174:	c3                   	ret

0000000000802175 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802175:	f3 0f 1e fa          	endbr64
  802179:	55                   	push   %rbp
  80217a:	48 89 e5             	mov    %rsp,%rbp
  80217d:	41 57                	push   %r15
  80217f:	41 56                	push   %r14
  802181:	41 55                	push   %r13
  802183:	41 54                	push   %r12
  802185:	53                   	push   %rbx
  802186:	48 83 ec 18          	sub    $0x18,%rsp
  80218a:	49 89 fc             	mov    %rdi,%r12
  80218d:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802191:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802195:	48 b8 2a 15 80 00 00 	movabs $0x80152a,%rax
  80219c:	00 00 00 
  80219f:	ff d0                	call   *%rax
  8021a1:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8021a4:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021aa:	49 bd 20 11 80 00 00 	movabs $0x801120,%r13
  8021b1:	00 00 00 
            sys_yield();
  8021b4:	49 be b5 10 80 00 00 	movabs $0x8010b5,%r14
  8021bb:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8021be:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8021c3:	74 7d                	je     802242 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8021c5:	8b 03                	mov    (%rbx),%eax
  8021c7:	3b 43 04             	cmp    0x4(%rbx),%eax
  8021ca:	75 26                	jne    8021f2 <devpipe_read+0x7d>
            if (i > 0) return i;
  8021cc:	4d 85 ff             	test   %r15,%r15
  8021cf:	75 77                	jne    802248 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021d1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021d6:	48 89 da             	mov    %rbx,%rdx
  8021d9:	be 00 10 00 00       	mov    $0x1000,%esi
  8021de:	4c 89 e7             	mov    %r12,%rdi
  8021e1:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	74 72                	je     80225a <devpipe_read+0xe5>
            sys_yield();
  8021e8:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8021eb:	8b 03                	mov    (%rbx),%eax
  8021ed:	3b 43 04             	cmp    0x4(%rbx),%eax
  8021f0:	74 df                	je     8021d1 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021f2:	48 63 c8             	movslq %eax,%rcx
  8021f5:	48 89 ca             	mov    %rcx,%rdx
  8021f8:	48 c1 ea 03          	shr    $0x3,%rdx
  8021fc:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802203:	08 10 20 
  802206:	48 89 d0             	mov    %rdx,%rax
  802209:	48 f7 e6             	mul    %rsi
  80220c:	48 c1 ea 06          	shr    $0x6,%rdx
  802210:	48 89 d0             	mov    %rdx,%rax
  802213:	48 c1 e0 09          	shl    $0x9,%rax
  802217:	48 29 d0             	sub    %rdx,%rax
  80221a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802221:	00 
  802222:	48 89 c8             	mov    %rcx,%rax
  802225:	48 29 d0             	sub    %rdx,%rax
  802228:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80222d:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802231:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802235:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802238:	49 83 c7 01          	add    $0x1,%r15
  80223c:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802240:	75 83                	jne    8021c5 <devpipe_read+0x50>
    return n;
  802242:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802246:	eb 03                	jmp    80224b <devpipe_read+0xd6>
            if (i > 0) return i;
  802248:	4c 89 f8             	mov    %r15,%rax
}
  80224b:	48 83 c4 18          	add    $0x18,%rsp
  80224f:	5b                   	pop    %rbx
  802250:	41 5c                	pop    %r12
  802252:	41 5d                	pop    %r13
  802254:	41 5e                	pop    %r14
  802256:	41 5f                	pop    %r15
  802258:	5d                   	pop    %rbp
  802259:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  80225a:	b8 00 00 00 00       	mov    $0x0,%eax
  80225f:	eb ea                	jmp    80224b <devpipe_read+0xd6>

0000000000802261 <pipe>:
pipe(int pfd[2]) {
  802261:	f3 0f 1e fa          	endbr64
  802265:	55                   	push   %rbp
  802266:	48 89 e5             	mov    %rsp,%rbp
  802269:	41 55                	push   %r13
  80226b:	41 54                	push   %r12
  80226d:	53                   	push   %rbx
  80226e:	48 83 ec 18          	sub    $0x18,%rsp
  802272:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802275:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802279:	48 b8 4a 15 80 00 00 	movabs $0x80154a,%rax
  802280:	00 00 00 
  802283:	ff d0                	call   *%rax
  802285:	89 c3                	mov    %eax,%ebx
  802287:	85 c0                	test   %eax,%eax
  802289:	0f 88 a0 01 00 00    	js     80242f <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80228f:	b9 46 00 00 00       	mov    $0x46,%ecx
  802294:	ba 00 10 00 00       	mov    $0x1000,%edx
  802299:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80229d:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a2:	48 b8 50 11 80 00 00 	movabs $0x801150,%rax
  8022a9:	00 00 00 
  8022ac:	ff d0                	call   *%rax
  8022ae:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	0f 88 77 01 00 00    	js     80242f <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8022b8:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8022bc:	48 b8 4a 15 80 00 00 	movabs $0x80154a,%rax
  8022c3:	00 00 00 
  8022c6:	ff d0                	call   *%rax
  8022c8:	89 c3                	mov    %eax,%ebx
  8022ca:	85 c0                	test   %eax,%eax
  8022cc:	0f 88 43 01 00 00    	js     802415 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8022d2:	b9 46 00 00 00       	mov    $0x46,%ecx
  8022d7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022dc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e5:	48 b8 50 11 80 00 00 	movabs $0x801150,%rax
  8022ec:	00 00 00 
  8022ef:	ff d0                	call   *%rax
  8022f1:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	0f 88 1a 01 00 00    	js     802415 <pipe+0x1b4>
    va = fd2data(fd0);
  8022fb:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022ff:	48 b8 2a 15 80 00 00 	movabs $0x80152a,%rax
  802306:	00 00 00 
  802309:	ff d0                	call   *%rax
  80230b:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80230e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802313:	ba 00 10 00 00       	mov    $0x1000,%edx
  802318:	48 89 c6             	mov    %rax,%rsi
  80231b:	bf 00 00 00 00       	mov    $0x0,%edi
  802320:	48 b8 50 11 80 00 00 	movabs $0x801150,%rax
  802327:	00 00 00 
  80232a:	ff d0                	call   *%rax
  80232c:	89 c3                	mov    %eax,%ebx
  80232e:	85 c0                	test   %eax,%eax
  802330:	0f 88 c5 00 00 00    	js     8023fb <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802336:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80233a:	48 b8 2a 15 80 00 00 	movabs $0x80152a,%rax
  802341:	00 00 00 
  802344:	ff d0                	call   *%rax
  802346:	48 89 c1             	mov    %rax,%rcx
  802349:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80234f:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802355:	ba 00 00 00 00       	mov    $0x0,%edx
  80235a:	4c 89 ee             	mov    %r13,%rsi
  80235d:	bf 00 00 00 00       	mov    $0x0,%edi
  802362:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  802369:	00 00 00 
  80236c:	ff d0                	call   *%rax
  80236e:	89 c3                	mov    %eax,%ebx
  802370:	85 c0                	test   %eax,%eax
  802372:	78 6e                	js     8023e2 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802374:	be 00 10 00 00       	mov    $0x1000,%esi
  802379:	4c 89 ef             	mov    %r13,%rdi
  80237c:	48 b8 ea 10 80 00 00 	movabs $0x8010ea,%rax
  802383:	00 00 00 
  802386:	ff d0                	call   *%rax
  802388:	83 f8 02             	cmp    $0x2,%eax
  80238b:	0f 85 ab 00 00 00    	jne    80243c <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802391:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802398:	00 00 
  80239a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80239e:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8023a0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023a4:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8023ab:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8023af:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8023b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023b5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8023bc:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023c0:	48 bb 14 15 80 00 00 	movabs $0x801514,%rbx
  8023c7:	00 00 00 
  8023ca:	ff d3                	call   *%rbx
  8023cc:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8023d0:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8023d4:	ff d3                	call   *%rbx
  8023d6:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8023db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023e0:	eb 4d                	jmp    80242f <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8023e2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023e7:	4c 89 ee             	mov    %r13,%rsi
  8023ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ef:	48 b8 90 12 80 00 00 	movabs $0x801290,%rax
  8023f6:	00 00 00 
  8023f9:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8023fb:	ba 00 10 00 00       	mov    $0x1000,%edx
  802400:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802404:	bf 00 00 00 00       	mov    $0x0,%edi
  802409:	48 b8 90 12 80 00 00 	movabs $0x801290,%rax
  802410:	00 00 00 
  802413:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802415:	ba 00 10 00 00       	mov    $0x1000,%edx
  80241a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80241e:	bf 00 00 00 00       	mov    $0x0,%edi
  802423:	48 b8 90 12 80 00 00 	movabs $0x801290,%rax
  80242a:	00 00 00 
  80242d:	ff d0                	call   *%rax
}
  80242f:	89 d8                	mov    %ebx,%eax
  802431:	48 83 c4 18          	add    $0x18,%rsp
  802435:	5b                   	pop    %rbx
  802436:	41 5c                	pop    %r12
  802438:	41 5d                	pop    %r13
  80243a:	5d                   	pop    %rbp
  80243b:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80243c:	48 b9 68 36 80 00 00 	movabs $0x803668,%rcx
  802443:	00 00 00 
  802446:	48 ba 22 32 80 00 00 	movabs $0x803222,%rdx
  80244d:	00 00 00 
  802450:	be 2e 00 00 00       	mov    $0x2e,%esi
  802455:	48 bf 49 32 80 00 00 	movabs $0x803249,%rdi
  80245c:	00 00 00 
  80245f:	b8 00 00 00 00       	mov    $0x0,%eax
  802464:	49 b8 7b 2a 80 00 00 	movabs $0x802a7b,%r8
  80246b:	00 00 00 
  80246e:	41 ff d0             	call   *%r8

0000000000802471 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802471:	f3 0f 1e fa          	endbr64
  802475:	55                   	push   %rbp
  802476:	48 89 e5             	mov    %rsp,%rbp
  802479:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80247d:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802481:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  802488:	00 00 00 
  80248b:	ff d0                	call   *%rax
    if (res < 0) return res;
  80248d:	85 c0                	test   %eax,%eax
  80248f:	78 35                	js     8024c6 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802491:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802495:	48 b8 2a 15 80 00 00 	movabs $0x80152a,%rax
  80249c:	00 00 00 
  80249f:	ff d0                	call   *%rax
  8024a1:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024a4:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024a9:	be 00 10 00 00       	mov    $0x1000,%esi
  8024ae:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8024b2:	48 b8 20 11 80 00 00 	movabs $0x801120,%rax
  8024b9:	00 00 00 
  8024bc:	ff d0                	call   *%rax
  8024be:	85 c0                	test   %eax,%eax
  8024c0:	0f 94 c0             	sete   %al
  8024c3:	0f b6 c0             	movzbl %al,%eax
}
  8024c6:	c9                   	leave
  8024c7:	c3                   	ret

00000000008024c8 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8024c8:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8024cc:	48 89 f8             	mov    %rdi,%rax
  8024cf:	48 c1 e8 27          	shr    $0x27,%rax
  8024d3:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8024da:	7f 00 00 
  8024dd:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024e1:	f6 c2 01             	test   $0x1,%dl
  8024e4:	74 6d                	je     802553 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8024e6:	48 89 f8             	mov    %rdi,%rax
  8024e9:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024ed:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8024f4:	7f 00 00 
  8024f7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024fb:	f6 c2 01             	test   $0x1,%dl
  8024fe:	74 62                	je     802562 <get_uvpt_entry+0x9a>
  802500:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802507:	7f 00 00 
  80250a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80250e:	f6 c2 80             	test   $0x80,%dl
  802511:	75 4f                	jne    802562 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802513:	48 89 f8             	mov    %rdi,%rax
  802516:	48 c1 e8 15          	shr    $0x15,%rax
  80251a:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802521:	7f 00 00 
  802524:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802528:	f6 c2 01             	test   $0x1,%dl
  80252b:	74 44                	je     802571 <get_uvpt_entry+0xa9>
  80252d:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802534:	7f 00 00 
  802537:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80253b:	f6 c2 80             	test   $0x80,%dl
  80253e:	75 31                	jne    802571 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802540:	48 c1 ef 0c          	shr    $0xc,%rdi
  802544:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80254b:	7f 00 00 
  80254e:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802552:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802553:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80255a:	7f 00 00 
  80255d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802561:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802562:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802569:	7f 00 00 
  80256c:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802570:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802571:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802578:	7f 00 00 
  80257b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80257f:	c3                   	ret

0000000000802580 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802580:	f3 0f 1e fa          	endbr64
  802584:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802587:	48 89 f9             	mov    %rdi,%rcx
  80258a:	48 c1 e9 27          	shr    $0x27,%rcx
  80258e:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802595:	7f 00 00 
  802598:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  80259c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8025a3:	f6 c1 01             	test   $0x1,%cl
  8025a6:	0f 84 b2 00 00 00    	je     80265e <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8025ac:	48 89 f9             	mov    %rdi,%rcx
  8025af:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8025b3:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8025ba:	7f 00 00 
  8025bd:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8025c1:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8025c8:	40 f6 c6 01          	test   $0x1,%sil
  8025cc:	0f 84 8c 00 00 00    	je     80265e <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8025d2:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8025d9:	7f 00 00 
  8025dc:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8025e0:	a8 80                	test   $0x80,%al
  8025e2:	75 7b                	jne    80265f <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8025e4:	48 89 f9             	mov    %rdi,%rcx
  8025e7:	48 c1 e9 15          	shr    $0x15,%rcx
  8025eb:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8025f2:	7f 00 00 
  8025f5:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8025f9:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802600:	40 f6 c6 01          	test   $0x1,%sil
  802604:	74 58                	je     80265e <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802606:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80260d:	7f 00 00 
  802610:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802614:	a8 80                	test   $0x80,%al
  802616:	75 6c                	jne    802684 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802618:	48 89 f9             	mov    %rdi,%rcx
  80261b:	48 c1 e9 0c          	shr    $0xc,%rcx
  80261f:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802626:	7f 00 00 
  802629:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80262d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802634:	40 f6 c6 01          	test   $0x1,%sil
  802638:	74 24                	je     80265e <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  80263a:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802641:	7f 00 00 
  802644:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802648:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80264f:	ff ff 7f 
  802652:	48 21 c8             	and    %rcx,%rax
  802655:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80265b:	48 09 d0             	or     %rdx,%rax
}
  80265e:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  80265f:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802666:	7f 00 00 
  802669:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80266d:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802674:	ff ff 7f 
  802677:	48 21 c8             	and    %rcx,%rax
  80267a:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802680:	48 01 d0             	add    %rdx,%rax
  802683:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802684:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80268b:	7f 00 00 
  80268e:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802692:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802699:	ff ff 7f 
  80269c:	48 21 c8             	and    %rcx,%rax
  80269f:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8026a5:	48 01 d0             	add    %rdx,%rax
  8026a8:	c3                   	ret

00000000008026a9 <get_prot>:

int
get_prot(void *va) {
  8026a9:	f3 0f 1e fa          	endbr64
  8026ad:	55                   	push   %rbp
  8026ae:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8026b1:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  8026b8:	00 00 00 
  8026bb:	ff d0                	call   *%rax
  8026bd:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8026c0:	83 e0 01             	and    $0x1,%eax
  8026c3:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8026c6:	89 d1                	mov    %edx,%ecx
  8026c8:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8026ce:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8026d0:	89 c1                	mov    %eax,%ecx
  8026d2:	83 c9 02             	or     $0x2,%ecx
  8026d5:	f6 c2 02             	test   $0x2,%dl
  8026d8:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8026db:	89 c1                	mov    %eax,%ecx
  8026dd:	83 c9 01             	or     $0x1,%ecx
  8026e0:	48 85 d2             	test   %rdx,%rdx
  8026e3:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8026e6:	89 c1                	mov    %eax,%ecx
  8026e8:	83 c9 40             	or     $0x40,%ecx
  8026eb:	f6 c6 04             	test   $0x4,%dh
  8026ee:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8026f1:	5d                   	pop    %rbp
  8026f2:	c3                   	ret

00000000008026f3 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8026f3:	f3 0f 1e fa          	endbr64
  8026f7:	55                   	push   %rbp
  8026f8:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8026fb:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  802702:	00 00 00 
  802705:	ff d0                	call   *%rax
    return pte & PTE_D;
  802707:	48 c1 e8 06          	shr    $0x6,%rax
  80270b:	83 e0 01             	and    $0x1,%eax
}
  80270e:	5d                   	pop    %rbp
  80270f:	c3                   	ret

0000000000802710 <is_page_present>:

bool
is_page_present(void *va) {
  802710:	f3 0f 1e fa          	endbr64
  802714:	55                   	push   %rbp
  802715:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802718:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  80271f:	00 00 00 
  802722:	ff d0                	call   *%rax
  802724:	83 e0 01             	and    $0x1,%eax
}
  802727:	5d                   	pop    %rbp
  802728:	c3                   	ret

0000000000802729 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802729:	f3 0f 1e fa          	endbr64
  80272d:	55                   	push   %rbp
  80272e:	48 89 e5             	mov    %rsp,%rbp
  802731:	41 57                	push   %r15
  802733:	41 56                	push   %r14
  802735:	41 55                	push   %r13
  802737:	41 54                	push   %r12
  802739:	53                   	push   %rbx
  80273a:	48 83 ec 18          	sub    $0x18,%rsp
  80273e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802742:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802746:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  80274b:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802752:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802755:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  80275c:	7f 00 00 
    while (va < USER_STACK_TOP) {
  80275f:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802766:	00 00 00 
  802769:	eb 73                	jmp    8027de <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  80276b:	48 89 d8             	mov    %rbx,%rax
  80276e:	48 c1 e8 15          	shr    $0x15,%rax
  802772:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802779:	7f 00 00 
  80277c:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802780:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802786:	f6 c2 01             	test   $0x1,%dl
  802789:	74 4b                	je     8027d6 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  80278b:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  80278f:	f6 c2 80             	test   $0x80,%dl
  802792:	74 11                	je     8027a5 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802794:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802798:	f6 c4 04             	test   $0x4,%ah
  80279b:	74 39                	je     8027d6 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  80279d:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  8027a3:	eb 20                	jmp    8027c5 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8027a5:	48 89 da             	mov    %rbx,%rdx
  8027a8:	48 c1 ea 0c          	shr    $0xc,%rdx
  8027ac:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8027b3:	7f 00 00 
  8027b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  8027ba:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8027c0:	f6 c4 04             	test   $0x4,%ah
  8027c3:	74 11                	je     8027d6 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  8027c5:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  8027c9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8027cd:	48 89 df             	mov    %rbx,%rdi
  8027d0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8027d4:	ff d0                	call   *%rax
    next:
        va += size;
  8027d6:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  8027d9:	49 39 df             	cmp    %rbx,%r15
  8027dc:	72 3e                	jb     80281c <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8027de:	49 8b 06             	mov    (%r14),%rax
  8027e1:	a8 01                	test   $0x1,%al
  8027e3:	74 37                	je     80281c <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8027e5:	48 89 d8             	mov    %rbx,%rax
  8027e8:	48 c1 e8 1e          	shr    $0x1e,%rax
  8027ec:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  8027f1:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8027f7:	f6 c2 01             	test   $0x1,%dl
  8027fa:	74 da                	je     8027d6 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  8027fc:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802801:	f6 c2 80             	test   $0x80,%dl
  802804:	0f 84 61 ff ff ff    	je     80276b <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  80280a:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80280f:	f6 c4 04             	test   $0x4,%ah
  802812:	74 c2                	je     8027d6 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802814:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  80281a:	eb a9                	jmp    8027c5 <foreach_shared_region+0x9c>
    }
    return res;
}
  80281c:	b8 00 00 00 00       	mov    $0x0,%eax
  802821:	48 83 c4 18          	add    $0x18,%rsp
  802825:	5b                   	pop    %rbx
  802826:	41 5c                	pop    %r12
  802828:	41 5d                	pop    %r13
  80282a:	41 5e                	pop    %r14
  80282c:	41 5f                	pop    %r15
  80282e:	5d                   	pop    %rbp
  80282f:	c3                   	ret

0000000000802830 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802830:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802834:	b8 00 00 00 00       	mov    $0x0,%eax
  802839:	c3                   	ret

000000000080283a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80283a:	f3 0f 1e fa          	endbr64
  80283e:	55                   	push   %rbp
  80283f:	48 89 e5             	mov    %rsp,%rbp
  802842:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802845:	48 be 59 32 80 00 00 	movabs $0x803259,%rsi
  80284c:	00 00 00 
  80284f:	48 b8 4b 0b 80 00 00 	movabs $0x800b4b,%rax
  802856:	00 00 00 
  802859:	ff d0                	call   *%rax
    return 0;
}
  80285b:	b8 00 00 00 00       	mov    $0x0,%eax
  802860:	5d                   	pop    %rbp
  802861:	c3                   	ret

0000000000802862 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802862:	f3 0f 1e fa          	endbr64
  802866:	55                   	push   %rbp
  802867:	48 89 e5             	mov    %rsp,%rbp
  80286a:	41 57                	push   %r15
  80286c:	41 56                	push   %r14
  80286e:	41 55                	push   %r13
  802870:	41 54                	push   %r12
  802872:	53                   	push   %rbx
  802873:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80287a:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802881:	48 85 d2             	test   %rdx,%rdx
  802884:	74 7a                	je     802900 <devcons_write+0x9e>
  802886:	49 89 d6             	mov    %rdx,%r14
  802889:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80288f:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802894:	49 bf 66 0d 80 00 00 	movabs $0x800d66,%r15
  80289b:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  80289e:	4c 89 f3             	mov    %r14,%rbx
  8028a1:	48 29 f3             	sub    %rsi,%rbx
  8028a4:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8028a9:	48 39 c3             	cmp    %rax,%rbx
  8028ac:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8028b0:	4c 63 eb             	movslq %ebx,%r13
  8028b3:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8028ba:	48 01 c6             	add    %rax,%rsi
  8028bd:	4c 89 ea             	mov    %r13,%rdx
  8028c0:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8028c7:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8028ca:	4c 89 ee             	mov    %r13,%rsi
  8028cd:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8028d4:	48 b8 ab 0f 80 00 00 	movabs $0x800fab,%rax
  8028db:	00 00 00 
  8028de:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8028e0:	41 01 dc             	add    %ebx,%r12d
  8028e3:	49 63 f4             	movslq %r12d,%rsi
  8028e6:	4c 39 f6             	cmp    %r14,%rsi
  8028e9:	72 b3                	jb     80289e <devcons_write+0x3c>
    return res;
  8028eb:	49 63 c4             	movslq %r12d,%rax
}
  8028ee:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8028f5:	5b                   	pop    %rbx
  8028f6:	41 5c                	pop    %r12
  8028f8:	41 5d                	pop    %r13
  8028fa:	41 5e                	pop    %r14
  8028fc:	41 5f                	pop    %r15
  8028fe:	5d                   	pop    %rbp
  8028ff:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802900:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802906:	eb e3                	jmp    8028eb <devcons_write+0x89>

0000000000802908 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802908:	f3 0f 1e fa          	endbr64
  80290c:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80290f:	ba 00 00 00 00       	mov    $0x0,%edx
  802914:	48 85 c0             	test   %rax,%rax
  802917:	74 55                	je     80296e <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802919:	55                   	push   %rbp
  80291a:	48 89 e5             	mov    %rsp,%rbp
  80291d:	41 55                	push   %r13
  80291f:	41 54                	push   %r12
  802921:	53                   	push   %rbx
  802922:	48 83 ec 08          	sub    $0x8,%rsp
  802926:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802929:	48 bb dc 0f 80 00 00 	movabs $0x800fdc,%rbx
  802930:	00 00 00 
  802933:	49 bc b5 10 80 00 00 	movabs $0x8010b5,%r12
  80293a:	00 00 00 
  80293d:	eb 03                	jmp    802942 <devcons_read+0x3a>
  80293f:	41 ff d4             	call   *%r12
  802942:	ff d3                	call   *%rbx
  802944:	85 c0                	test   %eax,%eax
  802946:	74 f7                	je     80293f <devcons_read+0x37>
    if (c < 0) return c;
  802948:	48 63 d0             	movslq %eax,%rdx
  80294b:	78 13                	js     802960 <devcons_read+0x58>
    if (c == 0x04) return 0;
  80294d:	ba 00 00 00 00       	mov    $0x0,%edx
  802952:	83 f8 04             	cmp    $0x4,%eax
  802955:	74 09                	je     802960 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802957:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80295b:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802960:	48 89 d0             	mov    %rdx,%rax
  802963:	48 83 c4 08          	add    $0x8,%rsp
  802967:	5b                   	pop    %rbx
  802968:	41 5c                	pop    %r12
  80296a:	41 5d                	pop    %r13
  80296c:	5d                   	pop    %rbp
  80296d:	c3                   	ret
  80296e:	48 89 d0             	mov    %rdx,%rax
  802971:	c3                   	ret

0000000000802972 <cputchar>:
cputchar(int ch) {
  802972:	f3 0f 1e fa          	endbr64
  802976:	55                   	push   %rbp
  802977:	48 89 e5             	mov    %rsp,%rbp
  80297a:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  80297e:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802982:	be 01 00 00 00       	mov    $0x1,%esi
  802987:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80298b:	48 b8 ab 0f 80 00 00 	movabs $0x800fab,%rax
  802992:	00 00 00 
  802995:	ff d0                	call   *%rax
}
  802997:	c9                   	leave
  802998:	c3                   	ret

0000000000802999 <getchar>:
getchar(void) {
  802999:	f3 0f 1e fa          	endbr64
  80299d:	55                   	push   %rbp
  80299e:	48 89 e5             	mov    %rsp,%rbp
  8029a1:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8029a5:	ba 01 00 00 00       	mov    $0x1,%edx
  8029aa:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8029ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8029b3:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  8029ba:	00 00 00 
  8029bd:	ff d0                	call   *%rax
  8029bf:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8029c1:	85 c0                	test   %eax,%eax
  8029c3:	78 06                	js     8029cb <getchar+0x32>
  8029c5:	74 08                	je     8029cf <getchar+0x36>
  8029c7:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8029cb:	89 d0                	mov    %edx,%eax
  8029cd:	c9                   	leave
  8029ce:	c3                   	ret
    return res < 0 ? res : res ? c :
  8029cf:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8029d4:	eb f5                	jmp    8029cb <getchar+0x32>

00000000008029d6 <iscons>:
iscons(int fdnum) {
  8029d6:	f3 0f 1e fa          	endbr64
  8029da:	55                   	push   %rbp
  8029db:	48 89 e5             	mov    %rsp,%rbp
  8029de:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8029e2:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8029e6:	48 b8 ae 15 80 00 00 	movabs $0x8015ae,%rax
  8029ed:	00 00 00 
  8029f0:	ff d0                	call   *%rax
    if (res < 0) return res;
  8029f2:	85 c0                	test   %eax,%eax
  8029f4:	78 18                	js     802a0e <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  8029f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029fa:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802a01:	00 00 00 
  802a04:	8b 00                	mov    (%rax),%eax
  802a06:	39 02                	cmp    %eax,(%rdx)
  802a08:	0f 94 c0             	sete   %al
  802a0b:	0f b6 c0             	movzbl %al,%eax
}
  802a0e:	c9                   	leave
  802a0f:	c3                   	ret

0000000000802a10 <opencons>:
opencons(void) {
  802a10:	f3 0f 1e fa          	endbr64
  802a14:	55                   	push   %rbp
  802a15:	48 89 e5             	mov    %rsp,%rbp
  802a18:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802a1c:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802a20:	48 b8 4a 15 80 00 00 	movabs $0x80154a,%rax
  802a27:	00 00 00 
  802a2a:	ff d0                	call   *%rax
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	78 49                	js     802a79 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802a30:	b9 46 00 00 00       	mov    $0x46,%ecx
  802a35:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a3a:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802a3e:	bf 00 00 00 00       	mov    $0x0,%edi
  802a43:	48 b8 50 11 80 00 00 	movabs $0x801150,%rax
  802a4a:	00 00 00 
  802a4d:	ff d0                	call   *%rax
  802a4f:	85 c0                	test   %eax,%eax
  802a51:	78 26                	js     802a79 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802a53:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a57:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802a5e:	00 00 
  802a60:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802a62:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802a66:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802a6d:	48 b8 14 15 80 00 00 	movabs $0x801514,%rax
  802a74:	00 00 00 
  802a77:	ff d0                	call   *%rax
}
  802a79:	c9                   	leave
  802a7a:	c3                   	ret

0000000000802a7b <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802a7b:	f3 0f 1e fa          	endbr64
  802a7f:	55                   	push   %rbp
  802a80:	48 89 e5             	mov    %rsp,%rbp
  802a83:	41 56                	push   %r14
  802a85:	41 55                	push   %r13
  802a87:	41 54                	push   %r12
  802a89:	53                   	push   %rbx
  802a8a:	48 83 ec 50          	sub    $0x50,%rsp
  802a8e:	49 89 fc             	mov    %rdi,%r12
  802a91:	41 89 f5             	mov    %esi,%r13d
  802a94:	48 89 d3             	mov    %rdx,%rbx
  802a97:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802a9b:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802a9f:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802aa3:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802aaa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802aae:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802ab2:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802ab6:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802aba:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802ac1:	00 00 00 
  802ac4:	4c 8b 30             	mov    (%rax),%r14
  802ac7:	48 b8 80 10 80 00 00 	movabs $0x801080,%rax
  802ace:	00 00 00 
  802ad1:	ff d0                	call   *%rax
  802ad3:	89 c6                	mov    %eax,%esi
  802ad5:	45 89 e8             	mov    %r13d,%r8d
  802ad8:	4c 89 e1             	mov    %r12,%rcx
  802adb:	4c 89 f2             	mov    %r14,%rdx
  802ade:	48 bf 90 36 80 00 00 	movabs $0x803690,%rdi
  802ae5:	00 00 00 
  802ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  802aed:	49 bc 02 02 80 00 00 	movabs $0x800202,%r12
  802af4:	00 00 00 
  802af7:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802afa:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802afe:	48 89 df             	mov    %rbx,%rdi
  802b01:	48 b8 9a 01 80 00 00 	movabs $0x80019a,%rax
  802b08:	00 00 00 
  802b0b:	ff d0                	call   *%rax
    cprintf("\n");
  802b0d:	48 bf 0c 30 80 00 00 	movabs $0x80300c,%rdi
  802b14:	00 00 00 
  802b17:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1c:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802b1f:	cc                   	int3
  802b20:	eb fd                	jmp    802b1f <_panic+0xa4>

0000000000802b22 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802b22:	f3 0f 1e fa          	endbr64
  802b26:	55                   	push   %rbp
  802b27:	48 89 e5             	mov    %rsp,%rbp
  802b2a:	41 54                	push   %r12
  802b2c:	53                   	push   %rbx
  802b2d:	48 89 fb             	mov    %rdi,%rbx
  802b30:	48 89 f7             	mov    %rsi,%rdi
  802b33:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b36:	48 85 f6             	test   %rsi,%rsi
  802b39:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b40:	00 00 00 
  802b43:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b47:	be 00 10 00 00       	mov    $0x1000,%esi
  802b4c:	48 b8 72 14 80 00 00 	movabs $0x801472,%rax
  802b53:	00 00 00 
  802b56:	ff d0                	call   *%rax
    if (res < 0) {
  802b58:	85 c0                	test   %eax,%eax
  802b5a:	78 45                	js     802ba1 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b5c:	48 85 db             	test   %rbx,%rbx
  802b5f:	74 12                	je     802b73 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b61:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b68:	00 00 00 
  802b6b:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b71:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b73:	4d 85 e4             	test   %r12,%r12
  802b76:	74 14                	je     802b8c <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b78:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b7f:	00 00 00 
  802b82:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b88:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b8c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b93:	00 00 00 
  802b96:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b9c:	5b                   	pop    %rbx
  802b9d:	41 5c                	pop    %r12
  802b9f:	5d                   	pop    %rbp
  802ba0:	c3                   	ret
        if (from_env_store != NULL) {
  802ba1:	48 85 db             	test   %rbx,%rbx
  802ba4:	74 06                	je     802bac <ipc_recv+0x8a>
            *from_env_store = 0;
  802ba6:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802bac:	4d 85 e4             	test   %r12,%r12
  802baf:	74 eb                	je     802b9c <ipc_recv+0x7a>
            *perm_store = 0;
  802bb1:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802bb8:	00 
  802bb9:	eb e1                	jmp    802b9c <ipc_recv+0x7a>

0000000000802bbb <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802bbb:	f3 0f 1e fa          	endbr64
  802bbf:	55                   	push   %rbp
  802bc0:	48 89 e5             	mov    %rsp,%rbp
  802bc3:	41 57                	push   %r15
  802bc5:	41 56                	push   %r14
  802bc7:	41 55                	push   %r13
  802bc9:	41 54                	push   %r12
  802bcb:	53                   	push   %rbx
  802bcc:	48 83 ec 18          	sub    $0x18,%rsp
  802bd0:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802bd3:	48 89 d3             	mov    %rdx,%rbx
  802bd6:	49 89 cc             	mov    %rcx,%r12
  802bd9:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802bdc:	48 85 d2             	test   %rdx,%rdx
  802bdf:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802be6:	00 00 00 
  802be9:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bed:	89 f0                	mov    %esi,%eax
  802bef:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802bf3:	48 89 da             	mov    %rbx,%rdx
  802bf6:	48 89 c6             	mov    %rax,%rsi
  802bf9:	48 b8 42 14 80 00 00 	movabs $0x801442,%rax
  802c00:	00 00 00 
  802c03:	ff d0                	call   *%rax
    while (res < 0) {
  802c05:	85 c0                	test   %eax,%eax
  802c07:	79 65                	jns    802c6e <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c09:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c0c:	75 33                	jne    802c41 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802c0e:	49 bf b5 10 80 00 00 	movabs $0x8010b5,%r15
  802c15:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c18:	49 be 42 14 80 00 00 	movabs $0x801442,%r14
  802c1f:	00 00 00 
        sys_yield();
  802c22:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c25:	45 89 e8             	mov    %r13d,%r8d
  802c28:	4c 89 e1             	mov    %r12,%rcx
  802c2b:	48 89 da             	mov    %rbx,%rdx
  802c2e:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802c32:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802c35:	41 ff d6             	call   *%r14
    while (res < 0) {
  802c38:	85 c0                	test   %eax,%eax
  802c3a:	79 32                	jns    802c6e <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c3c:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c3f:	74 e1                	je     802c22 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c41:	89 c1                	mov    %eax,%ecx
  802c43:	48 ba 65 32 80 00 00 	movabs $0x803265,%rdx
  802c4a:	00 00 00 
  802c4d:	be 42 00 00 00       	mov    $0x42,%esi
  802c52:	48 bf 70 32 80 00 00 	movabs $0x803270,%rdi
  802c59:	00 00 00 
  802c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c61:	49 b8 7b 2a 80 00 00 	movabs $0x802a7b,%r8
  802c68:	00 00 00 
  802c6b:	41 ff d0             	call   *%r8
    }
}
  802c6e:	48 83 c4 18          	add    $0x18,%rsp
  802c72:	5b                   	pop    %rbx
  802c73:	41 5c                	pop    %r12
  802c75:	41 5d                	pop    %r13
  802c77:	41 5e                	pop    %r14
  802c79:	41 5f                	pop    %r15
  802c7b:	5d                   	pop    %rbp
  802c7c:	c3                   	ret

0000000000802c7d <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c7d:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c81:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c86:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c8d:	00 00 00 
  802c90:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c94:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c98:	48 c1 e2 04          	shl    $0x4,%rdx
  802c9c:	48 01 ca             	add    %rcx,%rdx
  802c9f:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802ca5:	39 fa                	cmp    %edi,%edx
  802ca7:	74 12                	je     802cbb <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802ca9:	48 83 c0 01          	add    $0x1,%rax
  802cad:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802cb3:	75 db                	jne    802c90 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802cb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cba:	c3                   	ret
            return envs[i].env_id;
  802cbb:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802cbf:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802cc3:	48 c1 e2 04          	shl    $0x4,%rdx
  802cc7:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802cce:	00 00 00 
  802cd1:	48 01 d0             	add    %rdx,%rax
  802cd4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cda:	c3                   	ret

0000000000802cdb <__text_end>:
  802cdb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ce2:	00 00 00 
  802ce5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cec:	00 00 00 
  802cef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cf6:	00 00 00 
  802cf9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d00:	00 00 00 
  802d03:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d0a:	00 00 00 
  802d0d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d14:	00 00 00 
  802d17:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d1e:	00 00 00 
  802d21:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d28:	00 00 00 
  802d2b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d32:	00 00 00 
  802d35:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d3c:	00 00 00 
  802d3f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d46:	00 00 00 
  802d49:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d50:	00 00 00 
  802d53:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d5a:	00 00 00 
  802d5d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d64:	00 00 00 
  802d67:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d6e:	00 00 00 
  802d71:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d78:	00 00 00 
  802d7b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d82:	00 00 00 
  802d85:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d8c:	00 00 00 
  802d8f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d96:	00 00 00 
  802d99:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802da0:	00 00 00 
  802da3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802daa:	00 00 00 
  802dad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802db4:	00 00 00 
  802db7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dbe:	00 00 00 
  802dc1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dc8:	00 00 00 
  802dcb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd2:	00 00 00 
  802dd5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ddc:	00 00 00 
  802ddf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de6:	00 00 00 
  802de9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df0:	00 00 00 
  802df3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dfa:	00 00 00 
  802dfd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e04:	00 00 00 
  802e07:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e0e:	00 00 00 
  802e11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e18:	00 00 00 
  802e1b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e22:	00 00 00 
  802e25:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e2c:	00 00 00 
  802e2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e36:	00 00 00 
  802e39:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e40:	00 00 00 
  802e43:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e4a:	00 00 00 
  802e4d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e54:	00 00 00 
  802e57:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e5e:	00 00 00 
  802e61:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e68:	00 00 00 
  802e6b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e72:	00 00 00 
  802e75:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e7c:	00 00 00 
  802e7f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e86:	00 00 00 
  802e89:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e90:	00 00 00 
  802e93:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e9a:	00 00 00 
  802e9d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea4:	00 00 00 
  802ea7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eae:	00 00 00 
  802eb1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb8:	00 00 00 
  802ebb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec2:	00 00 00 
  802ec5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ecc:	00 00 00 
  802ecf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed6:	00 00 00 
  802ed9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee0:	00 00 00 
  802ee3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eea:	00 00 00 
  802eed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef4:	00 00 00 
  802ef7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802efe:	00 00 00 
  802f01:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f08:	00 00 00 
  802f0b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f12:	00 00 00 
  802f15:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f1c:	00 00 00 
  802f1f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f26:	00 00 00 
  802f29:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f30:	00 00 00 
  802f33:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f3a:	00 00 00 
  802f3d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f44:	00 00 00 
  802f47:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f4e:	00 00 00 
  802f51:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f58:	00 00 00 
  802f5b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f62:	00 00 00 
  802f65:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f6c:	00 00 00 
  802f6f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f76:	00 00 00 
  802f79:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f80:	00 00 00 
  802f83:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f8a:	00 00 00 
  802f8d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f94:	00 00 00 
  802f97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f9e:	00 00 00 
  802fa1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa8:	00 00 00 
  802fab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb2:	00 00 00 
  802fb5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fbc:	00 00 00 
  802fbf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc6:	00 00 00 
  802fc9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd0:	00 00 00 
  802fd3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fda:	00 00 00 
  802fdd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe4:	00 00 00 
  802fe7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fee:	00 00 00 
  802ff1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff8:	00 00 00 
  802ffb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
