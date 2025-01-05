
obj/user/faultread:     file format elf64-x86-64


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
  80001e:	e8 2e 00 00 00       	call   800051 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* Buggy program - faults with a read from location zero */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
#ifndef __clang_analyzer__
    cprintf("I read %08x from location 0!\n", *(volatile unsigned *)0);
  80002d:	8b 34 25 00 00 00 00 	mov    0x0,%esi
  800034:	48 bf 00 30 80 00 00 	movabs $0x803000,%rdi
  80003b:	00 00 00 
  80003e:	b8 00 00 00 00       	mov    $0x0,%eax
  800043:	48 ba df 01 80 00 00 	movabs $0x8001df,%rdx
  80004a:	00 00 00 
  80004d:	ff d2                	call   *%rdx
#endif
}
  80004f:	5d                   	pop    %rbp
  800050:	c3                   	ret

0000000000800051 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800051:	f3 0f 1e fa          	endbr64
  800055:	55                   	push   %rbp
  800056:	48 89 e5             	mov    %rsp,%rbp
  800059:	41 56                	push   %r14
  80005b:	41 55                	push   %r13
  80005d:	41 54                	push   %r12
  80005f:	53                   	push   %rbx
  800060:	41 89 fd             	mov    %edi,%r13d
  800063:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800066:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80006d:	00 00 00 
  800070:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800077:	00 00 00 
  80007a:	48 39 c2             	cmp    %rax,%rdx
  80007d:	73 17                	jae    800096 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80007f:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800082:	49 89 c4             	mov    %rax,%r12
  800085:	48 83 c3 08          	add    $0x8,%rbx
  800089:	b8 00 00 00 00       	mov    $0x0,%eax
  80008e:	ff 53 f8             	call   *-0x8(%rbx)
  800091:	4c 39 e3             	cmp    %r12,%rbx
  800094:	72 ef                	jb     800085 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800096:	48 b8 5d 10 80 00 00 	movabs $0x80105d,%rax
  80009d:	00 00 00 
  8000a0:	ff d0                	call   *%rax
  8000a2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a7:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000ab:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000af:	48 c1 e0 04          	shl    $0x4,%rax
  8000b3:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000ba:	00 00 00 
  8000bd:	48 01 d0             	add    %rdx,%rax
  8000c0:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000c7:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000ca:	45 85 ed             	test   %r13d,%r13d
  8000cd:	7e 0d                	jle    8000dc <libmain+0x8b>
  8000cf:	49 8b 06             	mov    (%r14),%rax
  8000d2:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000d9:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000dc:	4c 89 f6             	mov    %r14,%rsi
  8000df:	44 89 ef             	mov    %r13d,%edi
  8000e2:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000ee:	48 b8 03 01 80 00 00 	movabs $0x800103,%rax
  8000f5:	00 00 00 
  8000f8:	ff d0                	call   *%rax
#endif
}
  8000fa:	5b                   	pop    %rbx
  8000fb:	41 5c                	pop    %r12
  8000fd:	41 5d                	pop    %r13
  8000ff:	41 5e                	pop    %r14
  800101:	5d                   	pop    %rbp
  800102:	c3                   	ret

0000000000800103 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800103:	f3 0f 1e fa          	endbr64
  800107:	55                   	push   %rbp
  800108:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80010b:	48 b8 33 17 80 00 00 	movabs $0x801733,%rax
  800112:	00 00 00 
  800115:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800117:	bf 00 00 00 00       	mov    $0x0,%edi
  80011c:	48 b8 ee 0f 80 00 00 	movabs $0x800fee,%rax
  800123:	00 00 00 
  800126:	ff d0                	call   *%rax
}
  800128:	5d                   	pop    %rbp
  800129:	c3                   	ret

000000000080012a <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80012a:	f3 0f 1e fa          	endbr64
  80012e:	55                   	push   %rbp
  80012f:	48 89 e5             	mov    %rsp,%rbp
  800132:	53                   	push   %rbx
  800133:	48 83 ec 08          	sub    $0x8,%rsp
  800137:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80013a:	8b 06                	mov    (%rsi),%eax
  80013c:	8d 50 01             	lea    0x1(%rax),%edx
  80013f:	89 16                	mov    %edx,(%rsi)
  800141:	48 98                	cltq
  800143:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800148:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80014e:	74 0a                	je     80015a <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800150:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800154:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800158:	c9                   	leave
  800159:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80015a:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80015e:	be ff 00 00 00       	mov    $0xff,%esi
  800163:	48 b8 88 0f 80 00 00 	movabs $0x800f88,%rax
  80016a:	00 00 00 
  80016d:	ff d0                	call   *%rax
        state->offset = 0;
  80016f:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800175:	eb d9                	jmp    800150 <putch+0x26>

0000000000800177 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800177:	f3 0f 1e fa          	endbr64
  80017b:	55                   	push   %rbp
  80017c:	48 89 e5             	mov    %rsp,%rbp
  80017f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800186:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800189:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800190:	b9 21 00 00 00       	mov    $0x21,%ecx
  800195:	b8 00 00 00 00       	mov    $0x0,%eax
  80019a:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80019d:	48 89 f1             	mov    %rsi,%rcx
  8001a0:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8001a7:	48 bf 2a 01 80 00 00 	movabs $0x80012a,%rdi
  8001ae:	00 00 00 
  8001b1:	48 b8 3f 03 80 00 00 	movabs $0x80033f,%rax
  8001b8:	00 00 00 
  8001bb:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8001bd:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8001c4:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8001cb:	48 b8 88 0f 80 00 00 	movabs $0x800f88,%rax
  8001d2:	00 00 00 
  8001d5:	ff d0                	call   *%rax

    return state.count;
}
  8001d7:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8001dd:	c9                   	leave
  8001de:	c3                   	ret

00000000008001df <cprintf>:

int
cprintf(const char *fmt, ...) {
  8001df:	f3 0f 1e fa          	endbr64
  8001e3:	55                   	push   %rbp
  8001e4:	48 89 e5             	mov    %rsp,%rbp
  8001e7:	48 83 ec 50          	sub    $0x50,%rsp
  8001eb:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8001ef:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8001f3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8001f7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8001fb:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8001ff:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800206:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80020a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80020e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800212:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800216:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80021a:	48 b8 77 01 80 00 00 	movabs $0x800177,%rax
  800221:	00 00 00 
  800224:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800226:	c9                   	leave
  800227:	c3                   	ret

0000000000800228 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800228:	f3 0f 1e fa          	endbr64
  80022c:	55                   	push   %rbp
  80022d:	48 89 e5             	mov    %rsp,%rbp
  800230:	41 57                	push   %r15
  800232:	41 56                	push   %r14
  800234:	41 55                	push   %r13
  800236:	41 54                	push   %r12
  800238:	53                   	push   %rbx
  800239:	48 83 ec 18          	sub    $0x18,%rsp
  80023d:	49 89 fc             	mov    %rdi,%r12
  800240:	49 89 f5             	mov    %rsi,%r13
  800243:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800247:	8b 45 10             	mov    0x10(%rbp),%eax
  80024a:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80024d:	41 89 cf             	mov    %ecx,%r15d
  800250:	4c 39 fa             	cmp    %r15,%rdx
  800253:	73 5b                	jae    8002b0 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800255:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800259:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80025d:	85 db                	test   %ebx,%ebx
  80025f:	7e 0e                	jle    80026f <print_num+0x47>
            putch(padc, put_arg);
  800261:	4c 89 ee             	mov    %r13,%rsi
  800264:	44 89 f7             	mov    %r14d,%edi
  800267:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80026a:	83 eb 01             	sub    $0x1,%ebx
  80026d:	75 f2                	jne    800261 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  80026f:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800273:	48 b9 39 30 80 00 00 	movabs $0x803039,%rcx
  80027a:	00 00 00 
  80027d:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  800284:	00 00 00 
  800287:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80028b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80028f:	ba 00 00 00 00       	mov    $0x0,%edx
  800294:	49 f7 f7             	div    %r15
  800297:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80029b:	4c 89 ee             	mov    %r13,%rsi
  80029e:	41 ff d4             	call   *%r12
}
  8002a1:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8002a5:	5b                   	pop    %rbx
  8002a6:	41 5c                	pop    %r12
  8002a8:	41 5d                	pop    %r13
  8002aa:	41 5e                	pop    %r14
  8002ac:	41 5f                	pop    %r15
  8002ae:	5d                   	pop    %rbp
  8002af:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8002b0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b9:	49 f7 f7             	div    %r15
  8002bc:	48 83 ec 08          	sub    $0x8,%rsp
  8002c0:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8002c4:	52                   	push   %rdx
  8002c5:	45 0f be c9          	movsbl %r9b,%r9d
  8002c9:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8002cd:	48 89 c2             	mov    %rax,%rdx
  8002d0:	48 b8 28 02 80 00 00 	movabs $0x800228,%rax
  8002d7:	00 00 00 
  8002da:	ff d0                	call   *%rax
  8002dc:	48 83 c4 10          	add    $0x10,%rsp
  8002e0:	eb 8d                	jmp    80026f <print_num+0x47>

00000000008002e2 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8002e2:	f3 0f 1e fa          	endbr64
    state->count++;
  8002e6:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8002ea:	48 8b 06             	mov    (%rsi),%rax
  8002ed:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8002f1:	73 0a                	jae    8002fd <sprintputch+0x1b>
        *state->start++ = ch;
  8002f3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8002f7:	48 89 16             	mov    %rdx,(%rsi)
  8002fa:	40 88 38             	mov    %dil,(%rax)
    }
}
  8002fd:	c3                   	ret

00000000008002fe <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8002fe:	f3 0f 1e fa          	endbr64
  800302:	55                   	push   %rbp
  800303:	48 89 e5             	mov    %rsp,%rbp
  800306:	48 83 ec 50          	sub    $0x50,%rsp
  80030a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80030e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800312:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800316:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80031d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800321:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800325:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800329:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80032d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800331:	48 b8 3f 03 80 00 00 	movabs $0x80033f,%rax
  800338:	00 00 00 
  80033b:	ff d0                	call   *%rax
}
  80033d:	c9                   	leave
  80033e:	c3                   	ret

000000000080033f <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80033f:	f3 0f 1e fa          	endbr64
  800343:	55                   	push   %rbp
  800344:	48 89 e5             	mov    %rsp,%rbp
  800347:	41 57                	push   %r15
  800349:	41 56                	push   %r14
  80034b:	41 55                	push   %r13
  80034d:	41 54                	push   %r12
  80034f:	53                   	push   %rbx
  800350:	48 83 ec 38          	sub    $0x38,%rsp
  800354:	49 89 fe             	mov    %rdi,%r14
  800357:	49 89 f5             	mov    %rsi,%r13
  80035a:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  80035d:	48 8b 01             	mov    (%rcx),%rax
  800360:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800364:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800368:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80036c:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800370:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800374:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800378:	0f b6 3b             	movzbl (%rbx),%edi
  80037b:	40 80 ff 25          	cmp    $0x25,%dil
  80037f:	74 18                	je     800399 <vprintfmt+0x5a>
            if (!ch) return;
  800381:	40 84 ff             	test   %dil,%dil
  800384:	0f 84 b2 06 00 00    	je     800a3c <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80038a:	40 0f b6 ff          	movzbl %dil,%edi
  80038e:	4c 89 ee             	mov    %r13,%rsi
  800391:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800394:	4c 89 e3             	mov    %r12,%rbx
  800397:	eb db                	jmp    800374 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800399:	be 00 00 00 00       	mov    $0x0,%esi
  80039e:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8003a2:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8003a7:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8003ad:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8003b4:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8003b8:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8003bd:	41 0f b6 04 24       	movzbl (%r12),%eax
  8003c2:	88 45 a0             	mov    %al,-0x60(%rbp)
  8003c5:	83 e8 23             	sub    $0x23,%eax
  8003c8:	3c 57                	cmp    $0x57,%al
  8003ca:	0f 87 52 06 00 00    	ja     800a22 <vprintfmt+0x6e3>
  8003d0:	0f b6 c0             	movzbl %al,%eax
  8003d3:	48 b9 80 32 80 00 00 	movabs $0x803280,%rcx
  8003da:	00 00 00 
  8003dd:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8003e1:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8003e4:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8003e8:	eb ce                	jmp    8003b8 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8003ea:	49 89 dc             	mov    %rbx,%r12
  8003ed:	be 01 00 00 00       	mov    $0x1,%esi
  8003f2:	eb c4                	jmp    8003b8 <vprintfmt+0x79>
            padc = ch;
  8003f4:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8003f8:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8003fb:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8003fe:	eb b8                	jmp    8003b8 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800400:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800403:	83 f8 2f             	cmp    $0x2f,%eax
  800406:	77 24                	ja     80042c <vprintfmt+0xed>
  800408:	89 c1                	mov    %eax,%ecx
  80040a:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  80040e:	83 c0 08             	add    $0x8,%eax
  800411:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800414:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800417:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  80041a:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80041e:	79 98                	jns    8003b8 <vprintfmt+0x79>
                width = precision;
  800420:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800424:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80042a:	eb 8c                	jmp    8003b8 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80042c:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800430:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800434:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800438:	eb da                	jmp    800414 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80043a:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  80043f:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800443:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800449:	3c 39                	cmp    $0x39,%al
  80044b:	77 1c                	ja     800469 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  80044d:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800451:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800455:	0f b6 c0             	movzbl %al,%eax
  800458:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80045d:	0f b6 03             	movzbl (%rbx),%eax
  800460:	3c 39                	cmp    $0x39,%al
  800462:	76 e9                	jbe    80044d <vprintfmt+0x10e>
        process_precision:
  800464:	49 89 dc             	mov    %rbx,%r12
  800467:	eb b1                	jmp    80041a <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800469:	49 89 dc             	mov    %rbx,%r12
  80046c:	eb ac                	jmp    80041a <vprintfmt+0xdb>
            width = MAX(0, width);
  80046e:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800471:	85 c9                	test   %ecx,%ecx
  800473:	b8 00 00 00 00       	mov    $0x0,%eax
  800478:	0f 49 c1             	cmovns %ecx,%eax
  80047b:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  80047e:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800481:	e9 32 ff ff ff       	jmp    8003b8 <vprintfmt+0x79>
            lflag++;
  800486:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800489:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80048c:	e9 27 ff ff ff       	jmp    8003b8 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800491:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800494:	83 f8 2f             	cmp    $0x2f,%eax
  800497:	77 19                	ja     8004b2 <vprintfmt+0x173>
  800499:	89 c2                	mov    %eax,%edx
  80049b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80049f:	83 c0 08             	add    $0x8,%eax
  8004a2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004a5:	8b 3a                	mov    (%rdx),%edi
  8004a7:	4c 89 ee             	mov    %r13,%rsi
  8004aa:	41 ff d6             	call   *%r14
            break;
  8004ad:	e9 c2 fe ff ff       	jmp    800374 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8004b2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004b6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8004ba:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004be:	eb e5                	jmp    8004a5 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8004c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004c3:	83 f8 2f             	cmp    $0x2f,%eax
  8004c6:	77 5a                	ja     800522 <vprintfmt+0x1e3>
  8004c8:	89 c2                	mov    %eax,%edx
  8004ca:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8004ce:	83 c0 08             	add    $0x8,%eax
  8004d1:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8004d4:	8b 02                	mov    (%rdx),%eax
  8004d6:	89 c1                	mov    %eax,%ecx
  8004d8:	f7 d9                	neg    %ecx
  8004da:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8004dd:	83 f9 13             	cmp    $0x13,%ecx
  8004e0:	7f 4e                	jg     800530 <vprintfmt+0x1f1>
  8004e2:	48 63 c1             	movslq %ecx,%rax
  8004e5:	48 ba 40 35 80 00 00 	movabs $0x803540,%rdx
  8004ec:	00 00 00 
  8004ef:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8004f3:	48 85 c0             	test   %rax,%rax
  8004f6:	74 38                	je     800530 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8004f8:	48 89 c1             	mov    %rax,%rcx
  8004fb:	48 ba 2d 32 80 00 00 	movabs $0x80322d,%rdx
  800502:	00 00 00 
  800505:	4c 89 ee             	mov    %r13,%rsi
  800508:	4c 89 f7             	mov    %r14,%rdi
  80050b:	b8 00 00 00 00       	mov    $0x0,%eax
  800510:	49 b8 fe 02 80 00 00 	movabs $0x8002fe,%r8
  800517:	00 00 00 
  80051a:	41 ff d0             	call   *%r8
  80051d:	e9 52 fe ff ff       	jmp    800374 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800522:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800526:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80052a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80052e:	eb a4                	jmp    8004d4 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800530:	48 ba 51 30 80 00 00 	movabs $0x803051,%rdx
  800537:	00 00 00 
  80053a:	4c 89 ee             	mov    %r13,%rsi
  80053d:	4c 89 f7             	mov    %r14,%rdi
  800540:	b8 00 00 00 00       	mov    $0x0,%eax
  800545:	49 b8 fe 02 80 00 00 	movabs $0x8002fe,%r8
  80054c:	00 00 00 
  80054f:	41 ff d0             	call   *%r8
  800552:	e9 1d fe ff ff       	jmp    800374 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800557:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80055a:	83 f8 2f             	cmp    $0x2f,%eax
  80055d:	77 6c                	ja     8005cb <vprintfmt+0x28c>
  80055f:	89 c2                	mov    %eax,%edx
  800561:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800565:	83 c0 08             	add    $0x8,%eax
  800568:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80056b:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  80056e:	48 85 d2             	test   %rdx,%rdx
  800571:	48 b8 4a 30 80 00 00 	movabs $0x80304a,%rax
  800578:	00 00 00 
  80057b:	48 0f 45 c2          	cmovne %rdx,%rax
  80057f:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800583:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800587:	7e 06                	jle    80058f <vprintfmt+0x250>
  800589:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  80058d:	75 4a                	jne    8005d9 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80058f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800593:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800597:	0f b6 00             	movzbl (%rax),%eax
  80059a:	84 c0                	test   %al,%al
  80059c:	0f 85 9a 00 00 00    	jne    80063c <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8005a2:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005a5:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8005a9:	85 c0                	test   %eax,%eax
  8005ab:	0f 8e c3 fd ff ff    	jle    800374 <vprintfmt+0x35>
  8005b1:	4c 89 ee             	mov    %r13,%rsi
  8005b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8005b9:	41 ff d6             	call   *%r14
  8005bc:	41 83 ec 01          	sub    $0x1,%r12d
  8005c0:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8005c4:	75 eb                	jne    8005b1 <vprintfmt+0x272>
  8005c6:	e9 a9 fd ff ff       	jmp    800374 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8005cb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005cf:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005d3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005d7:	eb 92                	jmp    80056b <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8005d9:	49 63 f7             	movslq %r15d,%rsi
  8005dc:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8005e0:	48 b8 02 0b 80 00 00 	movabs $0x800b02,%rax
  8005e7:	00 00 00 
  8005ea:	ff d0                	call   *%rax
  8005ec:	48 89 c2             	mov    %rax,%rdx
  8005ef:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005f2:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8005f4:	8d 70 ff             	lea    -0x1(%rax),%esi
  8005f7:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8005fa:	85 c0                	test   %eax,%eax
  8005fc:	7e 91                	jle    80058f <vprintfmt+0x250>
  8005fe:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800603:	4c 89 ee             	mov    %r13,%rsi
  800606:	44 89 e7             	mov    %r12d,%edi
  800609:	41 ff d6             	call   *%r14
  80060c:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800610:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800613:	83 f8 ff             	cmp    $0xffffffff,%eax
  800616:	75 eb                	jne    800603 <vprintfmt+0x2c4>
  800618:	e9 72 ff ff ff       	jmp    80058f <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80061d:	0f b6 f8             	movzbl %al,%edi
  800620:	4c 89 ee             	mov    %r13,%rsi
  800623:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800626:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80062a:	49 83 c4 01          	add    $0x1,%r12
  80062e:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800634:	84 c0                	test   %al,%al
  800636:	0f 84 66 ff ff ff    	je     8005a2 <vprintfmt+0x263>
  80063c:	45 85 ff             	test   %r15d,%r15d
  80063f:	78 0a                	js     80064b <vprintfmt+0x30c>
  800641:	41 83 ef 01          	sub    $0x1,%r15d
  800645:	0f 88 57 ff ff ff    	js     8005a2 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80064b:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  80064f:	74 cc                	je     80061d <vprintfmt+0x2de>
  800651:	8d 50 e0             	lea    -0x20(%rax),%edx
  800654:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800659:	80 fa 5e             	cmp    $0x5e,%dl
  80065c:	77 c2                	ja     800620 <vprintfmt+0x2e1>
  80065e:	eb bd                	jmp    80061d <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800660:	40 84 f6             	test   %sil,%sil
  800663:	75 26                	jne    80068b <vprintfmt+0x34c>
    switch (lflag) {
  800665:	85 d2                	test   %edx,%edx
  800667:	74 59                	je     8006c2 <vprintfmt+0x383>
  800669:	83 fa 01             	cmp    $0x1,%edx
  80066c:	74 7b                	je     8006e9 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  80066e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800671:	83 f8 2f             	cmp    $0x2f,%eax
  800674:	0f 87 96 00 00 00    	ja     800710 <vprintfmt+0x3d1>
  80067a:	89 c2                	mov    %eax,%edx
  80067c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800680:	83 c0 08             	add    $0x8,%eax
  800683:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800686:	4c 8b 22             	mov    (%rdx),%r12
  800689:	eb 17                	jmp    8006a2 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  80068b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80068e:	83 f8 2f             	cmp    $0x2f,%eax
  800691:	77 21                	ja     8006b4 <vprintfmt+0x375>
  800693:	89 c2                	mov    %eax,%edx
  800695:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800699:	83 c0 08             	add    $0x8,%eax
  80069c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80069f:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8006a2:	4d 85 e4             	test   %r12,%r12
  8006a5:	78 7a                	js     800721 <vprintfmt+0x3e2>
            num = i;
  8006a7:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8006aa:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006af:	e9 50 02 00 00       	jmp    800904 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8006b4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006b8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006c0:	eb dd                	jmp    80069f <vprintfmt+0x360>
        return va_arg(*ap, int);
  8006c2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006c5:	83 f8 2f             	cmp    $0x2f,%eax
  8006c8:	77 11                	ja     8006db <vprintfmt+0x39c>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006d0:	83 c0 08             	add    $0x8,%eax
  8006d3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006d6:	4c 63 22             	movslq (%rdx),%r12
  8006d9:	eb c7                	jmp    8006a2 <vprintfmt+0x363>
  8006db:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006df:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006e3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006e7:	eb ed                	jmp    8006d6 <vprintfmt+0x397>
        return va_arg(*ap, long);
  8006e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006ec:	83 f8 2f             	cmp    $0x2f,%eax
  8006ef:	77 11                	ja     800702 <vprintfmt+0x3c3>
  8006f1:	89 c2                	mov    %eax,%edx
  8006f3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006f7:	83 c0 08             	add    $0x8,%eax
  8006fa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006fd:	4c 8b 22             	mov    (%rdx),%r12
  800700:	eb a0                	jmp    8006a2 <vprintfmt+0x363>
  800702:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800706:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80070a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80070e:	eb ed                	jmp    8006fd <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800710:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800714:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800718:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80071c:	e9 65 ff ff ff       	jmp    800686 <vprintfmt+0x347>
                putch('-', put_arg);
  800721:	4c 89 ee             	mov    %r13,%rsi
  800724:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800729:	41 ff d6             	call   *%r14
                i = -i;
  80072c:	49 f7 dc             	neg    %r12
  80072f:	e9 73 ff ff ff       	jmp    8006a7 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800734:	40 84 f6             	test   %sil,%sil
  800737:	75 32                	jne    80076b <vprintfmt+0x42c>
    switch (lflag) {
  800739:	85 d2                	test   %edx,%edx
  80073b:	74 5d                	je     80079a <vprintfmt+0x45b>
  80073d:	83 fa 01             	cmp    $0x1,%edx
  800740:	0f 84 82 00 00 00    	je     8007c8 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800746:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800749:	83 f8 2f             	cmp    $0x2f,%eax
  80074c:	0f 87 a5 00 00 00    	ja     8007f7 <vprintfmt+0x4b8>
  800752:	89 c2                	mov    %eax,%edx
  800754:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800758:	83 c0 08             	add    $0x8,%eax
  80075b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80075e:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800761:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800766:	e9 99 01 00 00       	jmp    800904 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80076b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80076e:	83 f8 2f             	cmp    $0x2f,%eax
  800771:	77 19                	ja     80078c <vprintfmt+0x44d>
  800773:	89 c2                	mov    %eax,%edx
  800775:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800779:	83 c0 08             	add    $0x8,%eax
  80077c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80077f:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800782:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800787:	e9 78 01 00 00       	jmp    800904 <vprintfmt+0x5c5>
  80078c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800790:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800794:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800798:	eb e5                	jmp    80077f <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  80079a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079d:	83 f8 2f             	cmp    $0x2f,%eax
  8007a0:	77 18                	ja     8007ba <vprintfmt+0x47b>
  8007a2:	89 c2                	mov    %eax,%edx
  8007a4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007a8:	83 c0 08             	add    $0x8,%eax
  8007ab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007ae:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8007b0:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8007b5:	e9 4a 01 00 00       	jmp    800904 <vprintfmt+0x5c5>
  8007ba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007be:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007c2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007c6:	eb e6                	jmp    8007ae <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8007c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007cb:	83 f8 2f             	cmp    $0x2f,%eax
  8007ce:	77 19                	ja     8007e9 <vprintfmt+0x4aa>
  8007d0:	89 c2                	mov    %eax,%edx
  8007d2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007d6:	83 c0 08             	add    $0x8,%eax
  8007d9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007dc:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8007df:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8007e4:	e9 1b 01 00 00       	jmp    800904 <vprintfmt+0x5c5>
  8007e9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007ed:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007f1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007f5:	eb e5                	jmp    8007dc <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  8007f7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007fb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007ff:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800803:	e9 56 ff ff ff       	jmp    80075e <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800808:	40 84 f6             	test   %sil,%sil
  80080b:	75 2e                	jne    80083b <vprintfmt+0x4fc>
    switch (lflag) {
  80080d:	85 d2                	test   %edx,%edx
  80080f:	74 59                	je     80086a <vprintfmt+0x52b>
  800811:	83 fa 01             	cmp    $0x1,%edx
  800814:	74 7f                	je     800895 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800816:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800819:	83 f8 2f             	cmp    $0x2f,%eax
  80081c:	0f 87 9f 00 00 00    	ja     8008c1 <vprintfmt+0x582>
  800822:	89 c2                	mov    %eax,%edx
  800824:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800828:	83 c0 08             	add    $0x8,%eax
  80082b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80082e:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800831:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800836:	e9 c9 00 00 00       	jmp    800904 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80083b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80083e:	83 f8 2f             	cmp    $0x2f,%eax
  800841:	77 19                	ja     80085c <vprintfmt+0x51d>
  800843:	89 c2                	mov    %eax,%edx
  800845:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800849:	83 c0 08             	add    $0x8,%eax
  80084c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80084f:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800852:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800857:	e9 a8 00 00 00       	jmp    800904 <vprintfmt+0x5c5>
  80085c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800860:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800864:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800868:	eb e5                	jmp    80084f <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  80086a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086d:	83 f8 2f             	cmp    $0x2f,%eax
  800870:	77 15                	ja     800887 <vprintfmt+0x548>
  800872:	89 c2                	mov    %eax,%edx
  800874:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800878:	83 c0 08             	add    $0x8,%eax
  80087b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80087e:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800880:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800885:	eb 7d                	jmp    800904 <vprintfmt+0x5c5>
  800887:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80088b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80088f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800893:	eb e9                	jmp    80087e <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800895:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800898:	83 f8 2f             	cmp    $0x2f,%eax
  80089b:	77 16                	ja     8008b3 <vprintfmt+0x574>
  80089d:	89 c2                	mov    %eax,%edx
  80089f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008a3:	83 c0 08             	add    $0x8,%eax
  8008a6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008a9:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8008ac:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008b1:	eb 51                	jmp    800904 <vprintfmt+0x5c5>
  8008b3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008bb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008bf:	eb e8                	jmp    8008a9 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8008c1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008c9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008cd:	e9 5c ff ff ff       	jmp    80082e <vprintfmt+0x4ef>
            putch('0', put_arg);
  8008d2:	4c 89 ee             	mov    %r13,%rsi
  8008d5:	bf 30 00 00 00       	mov    $0x30,%edi
  8008da:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  8008dd:	4c 89 ee             	mov    %r13,%rsi
  8008e0:	bf 78 00 00 00       	mov    $0x78,%edi
  8008e5:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  8008e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008eb:	83 f8 2f             	cmp    $0x2f,%eax
  8008ee:	77 47                	ja     800937 <vprintfmt+0x5f8>
  8008f0:	89 c2                	mov    %eax,%edx
  8008f2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008f6:	83 c0 08             	add    $0x8,%eax
  8008f9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008fc:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8008ff:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800904:	48 83 ec 08          	sub    $0x8,%rsp
  800908:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  80090c:	0f 94 c0             	sete   %al
  80090f:	0f b6 c0             	movzbl %al,%eax
  800912:	50                   	push   %rax
  800913:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800918:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80091c:	4c 89 ee             	mov    %r13,%rsi
  80091f:	4c 89 f7             	mov    %r14,%rdi
  800922:	48 b8 28 02 80 00 00 	movabs $0x800228,%rax
  800929:	00 00 00 
  80092c:	ff d0                	call   *%rax
            break;
  80092e:	48 83 c4 10          	add    $0x10,%rsp
  800932:	e9 3d fa ff ff       	jmp    800374 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800937:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80093b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80093f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800943:	eb b7                	jmp    8008fc <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800945:	40 84 f6             	test   %sil,%sil
  800948:	75 2b                	jne    800975 <vprintfmt+0x636>
    switch (lflag) {
  80094a:	85 d2                	test   %edx,%edx
  80094c:	74 56                	je     8009a4 <vprintfmt+0x665>
  80094e:	83 fa 01             	cmp    $0x1,%edx
  800951:	74 7f                	je     8009d2 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800953:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800956:	83 f8 2f             	cmp    $0x2f,%eax
  800959:	0f 87 a2 00 00 00    	ja     800a01 <vprintfmt+0x6c2>
  80095f:	89 c2                	mov    %eax,%edx
  800961:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800965:	83 c0 08             	add    $0x8,%eax
  800968:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80096b:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80096e:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800973:	eb 8f                	jmp    800904 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800975:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800978:	83 f8 2f             	cmp    $0x2f,%eax
  80097b:	77 19                	ja     800996 <vprintfmt+0x657>
  80097d:	89 c2                	mov    %eax,%edx
  80097f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800983:	83 c0 08             	add    $0x8,%eax
  800986:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800989:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80098c:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800991:	e9 6e ff ff ff       	jmp    800904 <vprintfmt+0x5c5>
  800996:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80099a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80099e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009a2:	eb e5                	jmp    800989 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8009a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a7:	83 f8 2f             	cmp    $0x2f,%eax
  8009aa:	77 18                	ja     8009c4 <vprintfmt+0x685>
  8009ac:	89 c2                	mov    %eax,%edx
  8009ae:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009b2:	83 c0 08             	add    $0x8,%eax
  8009b5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009b8:	8b 12                	mov    (%rdx),%edx
            base = 16;
  8009ba:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8009bf:	e9 40 ff ff ff       	jmp    800904 <vprintfmt+0x5c5>
  8009c4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009c8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009cc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009d0:	eb e6                	jmp    8009b8 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  8009d2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d5:	83 f8 2f             	cmp    $0x2f,%eax
  8009d8:	77 19                	ja     8009f3 <vprintfmt+0x6b4>
  8009da:	89 c2                	mov    %eax,%edx
  8009dc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009e0:	83 c0 08             	add    $0x8,%eax
  8009e3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009e6:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009e9:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8009ee:	e9 11 ff ff ff       	jmp    800904 <vprintfmt+0x5c5>
  8009f3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009f7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009fb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ff:	eb e5                	jmp    8009e6 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800a01:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a05:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a09:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a0d:	e9 59 ff ff ff       	jmp    80096b <vprintfmt+0x62c>
            putch(ch, put_arg);
  800a12:	4c 89 ee             	mov    %r13,%rsi
  800a15:	bf 25 00 00 00       	mov    $0x25,%edi
  800a1a:	41 ff d6             	call   *%r14
            break;
  800a1d:	e9 52 f9 ff ff       	jmp    800374 <vprintfmt+0x35>
            putch('%', put_arg);
  800a22:	4c 89 ee             	mov    %r13,%rsi
  800a25:	bf 25 00 00 00       	mov    $0x25,%edi
  800a2a:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800a2d:	48 83 eb 01          	sub    $0x1,%rbx
  800a31:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800a35:	75 f6                	jne    800a2d <vprintfmt+0x6ee>
  800a37:	e9 38 f9 ff ff       	jmp    800374 <vprintfmt+0x35>
}
  800a3c:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a40:	5b                   	pop    %rbx
  800a41:	41 5c                	pop    %r12
  800a43:	41 5d                	pop    %r13
  800a45:	41 5e                	pop    %r14
  800a47:	41 5f                	pop    %r15
  800a49:	5d                   	pop    %rbp
  800a4a:	c3                   	ret

0000000000800a4b <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a4b:	f3 0f 1e fa          	endbr64
  800a4f:	55                   	push   %rbp
  800a50:	48 89 e5             	mov    %rsp,%rbp
  800a53:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800a57:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a5b:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800a60:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800a64:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800a6b:	48 85 ff             	test   %rdi,%rdi
  800a6e:	74 2b                	je     800a9b <vsnprintf+0x50>
  800a70:	48 85 f6             	test   %rsi,%rsi
  800a73:	74 26                	je     800a9b <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800a75:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800a79:	48 bf e2 02 80 00 00 	movabs $0x8002e2,%rdi
  800a80:	00 00 00 
  800a83:	48 b8 3f 03 80 00 00 	movabs $0x80033f,%rax
  800a8a:	00 00 00 
  800a8d:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a93:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800a96:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800a99:	c9                   	leave
  800a9a:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800a9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aa0:	eb f7                	jmp    800a99 <vsnprintf+0x4e>

0000000000800aa2 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800aa2:	f3 0f 1e fa          	endbr64
  800aa6:	55                   	push   %rbp
  800aa7:	48 89 e5             	mov    %rsp,%rbp
  800aaa:	48 83 ec 50          	sub    $0x50,%rsp
  800aae:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800ab2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800ab6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800aba:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800ac1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ac5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800acd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800ad1:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ad5:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  800adc:	00 00 00 
  800adf:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800ae1:	c9                   	leave
  800ae2:	c3                   	ret

0000000000800ae3 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800ae3:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800ae7:	80 3f 00             	cmpb   $0x0,(%rdi)
  800aea:	74 10                	je     800afc <strlen+0x19>
    size_t n = 0;
  800aec:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800af1:	48 83 c0 01          	add    $0x1,%rax
  800af5:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800af9:	75 f6                	jne    800af1 <strlen+0xe>
  800afb:	c3                   	ret
    size_t n = 0;
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800b01:	c3                   	ret

0000000000800b02 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800b02:	f3 0f 1e fa          	endbr64
  800b06:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800b09:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800b0e:	48 85 f6             	test   %rsi,%rsi
  800b11:	74 10                	je     800b23 <strnlen+0x21>
  800b13:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800b17:	74 0b                	je     800b24 <strnlen+0x22>
  800b19:	48 83 c2 01          	add    $0x1,%rdx
  800b1d:	48 39 d0             	cmp    %rdx,%rax
  800b20:	75 f1                	jne    800b13 <strnlen+0x11>
  800b22:	c3                   	ret
  800b23:	c3                   	ret
  800b24:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800b27:	c3                   	ret

0000000000800b28 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800b28:	f3 0f 1e fa          	endbr64
  800b2c:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b34:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800b38:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800b3b:	48 83 c2 01          	add    $0x1,%rdx
  800b3f:	84 c9                	test   %cl,%cl
  800b41:	75 f1                	jne    800b34 <strcpy+0xc>
        ;
    return res;
}
  800b43:	c3                   	ret

0000000000800b44 <strcat>:

char *
strcat(char *dst, const char *src) {
  800b44:	f3 0f 1e fa          	endbr64
  800b48:	55                   	push   %rbp
  800b49:	48 89 e5             	mov    %rsp,%rbp
  800b4c:	41 54                	push   %r12
  800b4e:	53                   	push   %rbx
  800b4f:	48 89 fb             	mov    %rdi,%rbx
  800b52:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800b55:	48 b8 e3 0a 80 00 00 	movabs $0x800ae3,%rax
  800b5c:	00 00 00 
  800b5f:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800b61:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800b65:	4c 89 e6             	mov    %r12,%rsi
  800b68:	48 b8 28 0b 80 00 00 	movabs $0x800b28,%rax
  800b6f:	00 00 00 
  800b72:	ff d0                	call   *%rax
    return dst;
}
  800b74:	48 89 d8             	mov    %rbx,%rax
  800b77:	5b                   	pop    %rbx
  800b78:	41 5c                	pop    %r12
  800b7a:	5d                   	pop    %rbp
  800b7b:	c3                   	ret

0000000000800b7c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b7c:	f3 0f 1e fa          	endbr64
  800b80:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800b83:	48 85 d2             	test   %rdx,%rdx
  800b86:	74 1f                	je     800ba7 <strncpy+0x2b>
  800b88:	48 01 fa             	add    %rdi,%rdx
  800b8b:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800b8e:	48 83 c1 01          	add    $0x1,%rcx
  800b92:	44 0f b6 06          	movzbl (%rsi),%r8d
  800b96:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800b9a:	41 80 f8 01          	cmp    $0x1,%r8b
  800b9e:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800ba2:	48 39 ca             	cmp    %rcx,%rdx
  800ba5:	75 e7                	jne    800b8e <strncpy+0x12>
    }
    return ret;
}
  800ba7:	c3                   	ret

0000000000800ba8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800ba8:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800bac:	48 89 f8             	mov    %rdi,%rax
  800baf:	48 85 d2             	test   %rdx,%rdx
  800bb2:	74 24                	je     800bd8 <strlcpy+0x30>
        while (--size > 0 && *src)
  800bb4:	48 83 ea 01          	sub    $0x1,%rdx
  800bb8:	74 1b                	je     800bd5 <strlcpy+0x2d>
  800bba:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800bbe:	0f b6 16             	movzbl (%rsi),%edx
  800bc1:	84 d2                	test   %dl,%dl
  800bc3:	74 10                	je     800bd5 <strlcpy+0x2d>
            *dst++ = *src++;
  800bc5:	48 83 c6 01          	add    $0x1,%rsi
  800bc9:	48 83 c0 01          	add    $0x1,%rax
  800bcd:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800bd0:	48 39 c8             	cmp    %rcx,%rax
  800bd3:	75 e9                	jne    800bbe <strlcpy+0x16>
        *dst = '\0';
  800bd5:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800bd8:	48 29 f8             	sub    %rdi,%rax
}
  800bdb:	c3                   	ret

0000000000800bdc <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800bdc:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800be0:	0f b6 07             	movzbl (%rdi),%eax
  800be3:	84 c0                	test   %al,%al
  800be5:	74 13                	je     800bfa <strcmp+0x1e>
  800be7:	38 06                	cmp    %al,(%rsi)
  800be9:	75 0f                	jne    800bfa <strcmp+0x1e>
  800beb:	48 83 c7 01          	add    $0x1,%rdi
  800bef:	48 83 c6 01          	add    $0x1,%rsi
  800bf3:	0f b6 07             	movzbl (%rdi),%eax
  800bf6:	84 c0                	test   %al,%al
  800bf8:	75 ed                	jne    800be7 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800bfa:	0f b6 c0             	movzbl %al,%eax
  800bfd:	0f b6 16             	movzbl (%rsi),%edx
  800c00:	29 d0                	sub    %edx,%eax
}
  800c02:	c3                   	ret

0000000000800c03 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800c03:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800c07:	48 85 d2             	test   %rdx,%rdx
  800c0a:	74 1f                	je     800c2b <strncmp+0x28>
  800c0c:	0f b6 07             	movzbl (%rdi),%eax
  800c0f:	84 c0                	test   %al,%al
  800c11:	74 1e                	je     800c31 <strncmp+0x2e>
  800c13:	3a 06                	cmp    (%rsi),%al
  800c15:	75 1a                	jne    800c31 <strncmp+0x2e>
  800c17:	48 83 c7 01          	add    $0x1,%rdi
  800c1b:	48 83 c6 01          	add    $0x1,%rsi
  800c1f:	48 83 ea 01          	sub    $0x1,%rdx
  800c23:	75 e7                	jne    800c0c <strncmp+0x9>

    if (!n) return 0;
  800c25:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2a:	c3                   	ret
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c30:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c31:	0f b6 07             	movzbl (%rdi),%eax
  800c34:	0f b6 16             	movzbl (%rsi),%edx
  800c37:	29 d0                	sub    %edx,%eax
}
  800c39:	c3                   	ret

0000000000800c3a <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800c3a:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800c3e:	0f b6 17             	movzbl (%rdi),%edx
  800c41:	84 d2                	test   %dl,%dl
  800c43:	74 18                	je     800c5d <strchr+0x23>
        if (*str == c) {
  800c45:	0f be d2             	movsbl %dl,%edx
  800c48:	39 f2                	cmp    %esi,%edx
  800c4a:	74 17                	je     800c63 <strchr+0x29>
    for (; *str; str++) {
  800c4c:	48 83 c7 01          	add    $0x1,%rdi
  800c50:	0f b6 17             	movzbl (%rdi),%edx
  800c53:	84 d2                	test   %dl,%dl
  800c55:	75 ee                	jne    800c45 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800c57:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5c:	c3                   	ret
  800c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c62:	c3                   	ret
            return (char *)str;
  800c63:	48 89 f8             	mov    %rdi,%rax
}
  800c66:	c3                   	ret

0000000000800c67 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800c67:	f3 0f 1e fa          	endbr64
  800c6b:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800c6e:	0f b6 17             	movzbl (%rdi),%edx
  800c71:	84 d2                	test   %dl,%dl
  800c73:	74 13                	je     800c88 <strfind+0x21>
  800c75:	0f be d2             	movsbl %dl,%edx
  800c78:	39 f2                	cmp    %esi,%edx
  800c7a:	74 0b                	je     800c87 <strfind+0x20>
  800c7c:	48 83 c0 01          	add    $0x1,%rax
  800c80:	0f b6 10             	movzbl (%rax),%edx
  800c83:	84 d2                	test   %dl,%dl
  800c85:	75 ee                	jne    800c75 <strfind+0xe>
        ;
    return (char *)str;
}
  800c87:	c3                   	ret
  800c88:	c3                   	ret

0000000000800c89 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800c89:	f3 0f 1e fa          	endbr64
  800c8d:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800c90:	48 89 f8             	mov    %rdi,%rax
  800c93:	48 f7 d8             	neg    %rax
  800c96:	83 e0 07             	and    $0x7,%eax
  800c99:	49 89 d1             	mov    %rdx,%r9
  800c9c:	49 29 c1             	sub    %rax,%r9
  800c9f:	78 36                	js     800cd7 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800ca1:	40 0f b6 c6          	movzbl %sil,%eax
  800ca5:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800cac:	01 01 01 
  800caf:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800cb3:	40 f6 c7 07          	test   $0x7,%dil
  800cb7:	75 38                	jne    800cf1 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800cb9:	4c 89 c9             	mov    %r9,%rcx
  800cbc:	48 c1 f9 03          	sar    $0x3,%rcx
  800cc0:	74 0c                	je     800cce <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800cc2:	fc                   	cld
  800cc3:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800cc6:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800cca:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800cce:	4d 85 c9             	test   %r9,%r9
  800cd1:	75 45                	jne    800d18 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800cd3:	4c 89 c0             	mov    %r8,%rax
  800cd6:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800cd7:	48 85 d2             	test   %rdx,%rdx
  800cda:	74 f7                	je     800cd3 <memset+0x4a>
  800cdc:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800cdf:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800ce2:	48 83 c0 01          	add    $0x1,%rax
  800ce6:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800cea:	48 39 c2             	cmp    %rax,%rdx
  800ced:	75 f3                	jne    800ce2 <memset+0x59>
  800cef:	eb e2                	jmp    800cd3 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800cf1:	40 f6 c7 01          	test   $0x1,%dil
  800cf5:	74 06                	je     800cfd <memset+0x74>
  800cf7:	88 07                	mov    %al,(%rdi)
  800cf9:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800cfd:	40 f6 c7 02          	test   $0x2,%dil
  800d01:	74 07                	je     800d0a <memset+0x81>
  800d03:	66 89 07             	mov    %ax,(%rdi)
  800d06:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d0a:	40 f6 c7 04          	test   $0x4,%dil
  800d0e:	74 a9                	je     800cb9 <memset+0x30>
  800d10:	89 07                	mov    %eax,(%rdi)
  800d12:	48 83 c7 04          	add    $0x4,%rdi
  800d16:	eb a1                	jmp    800cb9 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d18:	41 f6 c1 04          	test   $0x4,%r9b
  800d1c:	74 1b                	je     800d39 <memset+0xb0>
  800d1e:	89 07                	mov    %eax,(%rdi)
  800d20:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d24:	41 f6 c1 02          	test   $0x2,%r9b
  800d28:	74 07                	je     800d31 <memset+0xa8>
  800d2a:	66 89 07             	mov    %ax,(%rdi)
  800d2d:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d31:	41 f6 c1 01          	test   $0x1,%r9b
  800d35:	74 9c                	je     800cd3 <memset+0x4a>
  800d37:	eb 06                	jmp    800d3f <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d39:	41 f6 c1 02          	test   $0x2,%r9b
  800d3d:	75 eb                	jne    800d2a <memset+0xa1>
        if (ni & 1) *ptr = k;
  800d3f:	88 07                	mov    %al,(%rdi)
  800d41:	eb 90                	jmp    800cd3 <memset+0x4a>

0000000000800d43 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d43:	f3 0f 1e fa          	endbr64
  800d47:	48 89 f8             	mov    %rdi,%rax
  800d4a:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d4d:	48 39 fe             	cmp    %rdi,%rsi
  800d50:	73 3b                	jae    800d8d <memmove+0x4a>
  800d52:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800d56:	48 39 d7             	cmp    %rdx,%rdi
  800d59:	73 32                	jae    800d8d <memmove+0x4a>
        s += n;
        d += n;
  800d5b:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d5f:	48 89 d6             	mov    %rdx,%rsi
  800d62:	48 09 fe             	or     %rdi,%rsi
  800d65:	48 09 ce             	or     %rcx,%rsi
  800d68:	40 f6 c6 07          	test   $0x7,%sil
  800d6c:	75 12                	jne    800d80 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800d6e:	48 83 ef 08          	sub    $0x8,%rdi
  800d72:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800d76:	48 c1 e9 03          	shr    $0x3,%rcx
  800d7a:	fd                   	std
  800d7b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800d7e:	fc                   	cld
  800d7f:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800d80:	48 83 ef 01          	sub    $0x1,%rdi
  800d84:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800d88:	fd                   	std
  800d89:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800d8b:	eb f1                	jmp    800d7e <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d8d:	48 89 f2             	mov    %rsi,%rdx
  800d90:	48 09 c2             	or     %rax,%rdx
  800d93:	48 09 ca             	or     %rcx,%rdx
  800d96:	f6 c2 07             	test   $0x7,%dl
  800d99:	75 0c                	jne    800da7 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800d9b:	48 c1 e9 03          	shr    $0x3,%rcx
  800d9f:	48 89 c7             	mov    %rax,%rdi
  800da2:	fc                   	cld
  800da3:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800da6:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800da7:	48 89 c7             	mov    %rax,%rdi
  800daa:	fc                   	cld
  800dab:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800dad:	c3                   	ret

0000000000800dae <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800dae:	f3 0f 1e fa          	endbr64
  800db2:	55                   	push   %rbp
  800db3:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800db6:	48 b8 43 0d 80 00 00 	movabs $0x800d43,%rax
  800dbd:	00 00 00 
  800dc0:	ff d0                	call   *%rax
}
  800dc2:	5d                   	pop    %rbp
  800dc3:	c3                   	ret

0000000000800dc4 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800dc4:	f3 0f 1e fa          	endbr64
  800dc8:	55                   	push   %rbp
  800dc9:	48 89 e5             	mov    %rsp,%rbp
  800dcc:	41 57                	push   %r15
  800dce:	41 56                	push   %r14
  800dd0:	41 55                	push   %r13
  800dd2:	41 54                	push   %r12
  800dd4:	53                   	push   %rbx
  800dd5:	48 83 ec 08          	sub    $0x8,%rsp
  800dd9:	49 89 fe             	mov    %rdi,%r14
  800ddc:	49 89 f7             	mov    %rsi,%r15
  800ddf:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800de2:	48 89 f7             	mov    %rsi,%rdi
  800de5:	48 b8 e3 0a 80 00 00 	movabs $0x800ae3,%rax
  800dec:	00 00 00 
  800def:	ff d0                	call   *%rax
  800df1:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800df4:	48 89 de             	mov    %rbx,%rsi
  800df7:	4c 89 f7             	mov    %r14,%rdi
  800dfa:	48 b8 02 0b 80 00 00 	movabs $0x800b02,%rax
  800e01:	00 00 00 
  800e04:	ff d0                	call   *%rax
  800e06:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800e09:	48 39 c3             	cmp    %rax,%rbx
  800e0c:	74 36                	je     800e44 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800e0e:	48 89 d8             	mov    %rbx,%rax
  800e11:	4c 29 e8             	sub    %r13,%rax
  800e14:	49 39 c4             	cmp    %rax,%r12
  800e17:	73 31                	jae    800e4a <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800e19:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800e1e:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e22:	4c 89 fe             	mov    %r15,%rsi
  800e25:	48 b8 ae 0d 80 00 00 	movabs $0x800dae,%rax
  800e2c:	00 00 00 
  800e2f:	ff d0                	call   *%rax
    return dstlen + srclen;
  800e31:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800e35:	48 83 c4 08          	add    $0x8,%rsp
  800e39:	5b                   	pop    %rbx
  800e3a:	41 5c                	pop    %r12
  800e3c:	41 5d                	pop    %r13
  800e3e:	41 5e                	pop    %r14
  800e40:	41 5f                	pop    %r15
  800e42:	5d                   	pop    %rbp
  800e43:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800e44:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800e48:	eb eb                	jmp    800e35 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e4a:	48 83 eb 01          	sub    $0x1,%rbx
  800e4e:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e52:	48 89 da             	mov    %rbx,%rdx
  800e55:	4c 89 fe             	mov    %r15,%rsi
  800e58:	48 b8 ae 0d 80 00 00 	movabs $0x800dae,%rax
  800e5f:	00 00 00 
  800e62:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800e64:	49 01 de             	add    %rbx,%r14
  800e67:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800e6c:	eb c3                	jmp    800e31 <strlcat+0x6d>

0000000000800e6e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800e6e:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800e72:	48 85 d2             	test   %rdx,%rdx
  800e75:	74 2d                	je     800ea4 <memcmp+0x36>
  800e77:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800e7c:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800e80:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800e85:	44 38 c1             	cmp    %r8b,%cl
  800e88:	75 0f                	jne    800e99 <memcmp+0x2b>
    while (n-- > 0) {
  800e8a:	48 83 c0 01          	add    $0x1,%rax
  800e8e:	48 39 c2             	cmp    %rax,%rdx
  800e91:	75 e9                	jne    800e7c <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800e93:	b8 00 00 00 00       	mov    $0x0,%eax
  800e98:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800e99:	0f b6 c1             	movzbl %cl,%eax
  800e9c:	45 0f b6 c0          	movzbl %r8b,%r8d
  800ea0:	44 29 c0             	sub    %r8d,%eax
  800ea3:	c3                   	ret
    return 0;
  800ea4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea9:	c3                   	ret

0000000000800eaa <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800eaa:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800eae:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800eb2:	48 39 c7             	cmp    %rax,%rdi
  800eb5:	73 0f                	jae    800ec6 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800eb7:	40 38 37             	cmp    %sil,(%rdi)
  800eba:	74 0e                	je     800eca <memfind+0x20>
    for (; src < end; src++) {
  800ebc:	48 83 c7 01          	add    $0x1,%rdi
  800ec0:	48 39 f8             	cmp    %rdi,%rax
  800ec3:	75 f2                	jne    800eb7 <memfind+0xd>
  800ec5:	c3                   	ret
  800ec6:	48 89 f8             	mov    %rdi,%rax
  800ec9:	c3                   	ret
  800eca:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800ecd:	c3                   	ret

0000000000800ece <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800ece:	f3 0f 1e fa          	endbr64
  800ed2:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800ed5:	0f b6 37             	movzbl (%rdi),%esi
  800ed8:	40 80 fe 20          	cmp    $0x20,%sil
  800edc:	74 06                	je     800ee4 <strtol+0x16>
  800ede:	40 80 fe 09          	cmp    $0x9,%sil
  800ee2:	75 13                	jne    800ef7 <strtol+0x29>
  800ee4:	48 83 c7 01          	add    $0x1,%rdi
  800ee8:	0f b6 37             	movzbl (%rdi),%esi
  800eeb:	40 80 fe 20          	cmp    $0x20,%sil
  800eef:	74 f3                	je     800ee4 <strtol+0x16>
  800ef1:	40 80 fe 09          	cmp    $0x9,%sil
  800ef5:	74 ed                	je     800ee4 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800ef7:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800efa:	83 e0 fd             	and    $0xfffffffd,%eax
  800efd:	3c 01                	cmp    $0x1,%al
  800eff:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f03:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  800f09:	75 0f                	jne    800f1a <strtol+0x4c>
  800f0b:	80 3f 30             	cmpb   $0x30,(%rdi)
  800f0e:	74 14                	je     800f24 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800f10:	85 d2                	test   %edx,%edx
  800f12:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f17:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  800f1a:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800f1f:	4c 63 ca             	movslq %edx,%r9
  800f22:	eb 36                	jmp    800f5a <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f24:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800f28:	74 0f                	je     800f39 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  800f2a:	85 d2                	test   %edx,%edx
  800f2c:	75 ec                	jne    800f1a <strtol+0x4c>
        s++;
  800f2e:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800f32:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  800f37:	eb e1                	jmp    800f1a <strtol+0x4c>
        s += 2;
  800f39:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f3d:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  800f42:	eb d6                	jmp    800f1a <strtol+0x4c>
            dig -= '0';
  800f44:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  800f47:	44 0f b6 c1          	movzbl %cl,%r8d
  800f4b:	41 39 d0             	cmp    %edx,%r8d
  800f4e:	7d 21                	jge    800f71 <strtol+0xa3>
        val = val * base + dig;
  800f50:	49 0f af c1          	imul   %r9,%rax
  800f54:	0f b6 c9             	movzbl %cl,%ecx
  800f57:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  800f5a:	48 83 c7 01          	add    $0x1,%rdi
  800f5e:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  800f62:	80 f9 39             	cmp    $0x39,%cl
  800f65:	76 dd                	jbe    800f44 <strtol+0x76>
        else if (dig - 'a' < 27)
  800f67:	80 f9 7b             	cmp    $0x7b,%cl
  800f6a:	77 05                	ja     800f71 <strtol+0xa3>
            dig -= 'a' - 10;
  800f6c:	83 e9 57             	sub    $0x57,%ecx
  800f6f:	eb d6                	jmp    800f47 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  800f71:	4d 85 d2             	test   %r10,%r10
  800f74:	74 03                	je     800f79 <strtol+0xab>
  800f76:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800f79:	48 89 c2             	mov    %rax,%rdx
  800f7c:	48 f7 da             	neg    %rdx
  800f7f:	40 80 fe 2d          	cmp    $0x2d,%sil
  800f83:	48 0f 44 c2          	cmove  %rdx,%rax
}
  800f87:	c3                   	ret

0000000000800f88 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800f88:	f3 0f 1e fa          	endbr64
  800f8c:	55                   	push   %rbp
  800f8d:	48 89 e5             	mov    %rsp,%rbp
  800f90:	53                   	push   %rbx
  800f91:	48 89 fa             	mov    %rdi,%rdx
  800f94:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800f97:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800f9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fa6:	be 00 00 00 00       	mov    $0x0,%esi
  800fab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fb1:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800fb3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fb7:	c9                   	leave
  800fb8:	c3                   	ret

0000000000800fb9 <sys_cgetc>:

int
sys_cgetc(void) {
  800fb9:	f3 0f 1e fa          	endbr64
  800fbd:	55                   	push   %rbp
  800fbe:	48 89 e5             	mov    %rsp,%rbp
  800fc1:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800fc2:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800fc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800fcc:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fdb:	be 00 00 00 00       	mov    $0x0,%esi
  800fe0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fe6:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800fe8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fec:	c9                   	leave
  800fed:	c3                   	ret

0000000000800fee <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800fee:	f3 0f 1e fa          	endbr64
  800ff2:	55                   	push   %rbp
  800ff3:	48 89 e5             	mov    %rsp,%rbp
  800ff6:	53                   	push   %rbx
  800ff7:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800ffb:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800ffe:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801003:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801008:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801012:	be 00 00 00 00       	mov    $0x0,%esi
  801017:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80101d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80101f:	48 85 c0             	test   %rax,%rax
  801022:	7f 06                	jg     80102a <sys_env_destroy+0x3c>
}
  801024:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801028:	c9                   	leave
  801029:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80102a:	49 89 c0             	mov    %rax,%r8
  80102d:	b9 03 00 00 00       	mov    $0x3,%ecx
  801032:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801039:	00 00 00 
  80103c:	be 26 00 00 00       	mov    $0x26,%esi
  801041:	48 bf b7 31 80 00 00 	movabs $0x8031b7,%rdi
  801048:	00 00 00 
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
  801050:	49 b9 58 2a 80 00 00 	movabs $0x802a58,%r9
  801057:	00 00 00 
  80105a:	41 ff d1             	call   *%r9

000000000080105d <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80105d:	f3 0f 1e fa          	endbr64
  801061:	55                   	push   %rbp
  801062:	48 89 e5             	mov    %rsp,%rbp
  801065:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801066:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80106b:	ba 00 00 00 00       	mov    $0x0,%edx
  801070:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801075:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80107f:	be 00 00 00 00       	mov    $0x0,%esi
  801084:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80108a:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80108c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801090:	c9                   	leave
  801091:	c3                   	ret

0000000000801092 <sys_yield>:

void
sys_yield(void) {
  801092:	f3 0f 1e fa          	endbr64
  801096:	55                   	push   %rbp
  801097:	48 89 e5             	mov    %rsp,%rbp
  80109a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80109b:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010af:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010b4:	be 00 00 00 00       	mov    $0x0,%esi
  8010b9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010bf:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8010c1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010c5:	c9                   	leave
  8010c6:	c3                   	ret

00000000008010c7 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8010c7:	f3 0f 1e fa          	endbr64
  8010cb:	55                   	push   %rbp
  8010cc:	48 89 e5             	mov    %rsp,%rbp
  8010cf:	53                   	push   %rbx
  8010d0:	48 89 fa             	mov    %rdi,%rdx
  8010d3:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8010d6:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010db:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8010e2:	00 00 00 
  8010e5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010ea:	be 00 00 00 00       	mov    $0x0,%esi
  8010ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010f5:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8010f7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010fb:	c9                   	leave
  8010fc:	c3                   	ret

00000000008010fd <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8010fd:	f3 0f 1e fa          	endbr64
  801101:	55                   	push   %rbp
  801102:	48 89 e5             	mov    %rsp,%rbp
  801105:	53                   	push   %rbx
  801106:	49 89 f8             	mov    %rdi,%r8
  801109:	48 89 d3             	mov    %rdx,%rbx
  80110c:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80110f:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801114:	4c 89 c2             	mov    %r8,%rdx
  801117:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80111a:	be 00 00 00 00       	mov    $0x0,%esi
  80111f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801125:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801127:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80112b:	c9                   	leave
  80112c:	c3                   	ret

000000000080112d <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80112d:	f3 0f 1e fa          	endbr64
  801131:	55                   	push   %rbp
  801132:	48 89 e5             	mov    %rsp,%rbp
  801135:	53                   	push   %rbx
  801136:	48 83 ec 08          	sub    $0x8,%rsp
  80113a:	89 f8                	mov    %edi,%eax
  80113c:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80113f:	48 63 f9             	movslq %ecx,%rdi
  801142:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801145:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80114a:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80114d:	be 00 00 00 00       	mov    $0x0,%esi
  801152:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801158:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80115a:	48 85 c0             	test   %rax,%rax
  80115d:	7f 06                	jg     801165 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  80115f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801163:	c9                   	leave
  801164:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801165:	49 89 c0             	mov    %rax,%r8
  801168:	b9 04 00 00 00       	mov    $0x4,%ecx
  80116d:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801174:	00 00 00 
  801177:	be 26 00 00 00       	mov    $0x26,%esi
  80117c:	48 bf b7 31 80 00 00 	movabs $0x8031b7,%rdi
  801183:	00 00 00 
  801186:	b8 00 00 00 00       	mov    $0x0,%eax
  80118b:	49 b9 58 2a 80 00 00 	movabs $0x802a58,%r9
  801192:	00 00 00 
  801195:	41 ff d1             	call   *%r9

0000000000801198 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801198:	f3 0f 1e fa          	endbr64
  80119c:	55                   	push   %rbp
  80119d:	48 89 e5             	mov    %rsp,%rbp
  8011a0:	53                   	push   %rbx
  8011a1:	48 83 ec 08          	sub    $0x8,%rsp
  8011a5:	89 f8                	mov    %edi,%eax
  8011a7:	49 89 f2             	mov    %rsi,%r10
  8011aa:	48 89 cf             	mov    %rcx,%rdi
  8011ad:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8011b0:	48 63 da             	movslq %edx,%rbx
  8011b3:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011b6:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011bb:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011be:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8011c1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011c3:	48 85 c0             	test   %rax,%rax
  8011c6:	7f 06                	jg     8011ce <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8011c8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011cc:	c9                   	leave
  8011cd:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011ce:	49 89 c0             	mov    %rax,%r8
  8011d1:	b9 05 00 00 00       	mov    $0x5,%ecx
  8011d6:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8011dd:	00 00 00 
  8011e0:	be 26 00 00 00       	mov    $0x26,%esi
  8011e5:	48 bf b7 31 80 00 00 	movabs $0x8031b7,%rdi
  8011ec:	00 00 00 
  8011ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f4:	49 b9 58 2a 80 00 00 	movabs $0x802a58,%r9
  8011fb:	00 00 00 
  8011fe:	41 ff d1             	call   *%r9

0000000000801201 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801201:	f3 0f 1e fa          	endbr64
  801205:	55                   	push   %rbp
  801206:	48 89 e5             	mov    %rsp,%rbp
  801209:	53                   	push   %rbx
  80120a:	48 83 ec 08          	sub    $0x8,%rsp
  80120e:	49 89 f9             	mov    %rdi,%r9
  801211:	89 f0                	mov    %esi,%eax
  801213:	48 89 d3             	mov    %rdx,%rbx
  801216:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801219:	49 63 f0             	movslq %r8d,%rsi
  80121c:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80121f:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801224:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801227:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80122d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80122f:	48 85 c0             	test   %rax,%rax
  801232:	7f 06                	jg     80123a <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801234:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801238:	c9                   	leave
  801239:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80123a:	49 89 c0             	mov    %rax,%r8
  80123d:	b9 06 00 00 00       	mov    $0x6,%ecx
  801242:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801249:	00 00 00 
  80124c:	be 26 00 00 00       	mov    $0x26,%esi
  801251:	48 bf b7 31 80 00 00 	movabs $0x8031b7,%rdi
  801258:	00 00 00 
  80125b:	b8 00 00 00 00       	mov    $0x0,%eax
  801260:	49 b9 58 2a 80 00 00 	movabs $0x802a58,%r9
  801267:	00 00 00 
  80126a:	41 ff d1             	call   *%r9

000000000080126d <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80126d:	f3 0f 1e fa          	endbr64
  801271:	55                   	push   %rbp
  801272:	48 89 e5             	mov    %rsp,%rbp
  801275:	53                   	push   %rbx
  801276:	48 83 ec 08          	sub    $0x8,%rsp
  80127a:	48 89 f1             	mov    %rsi,%rcx
  80127d:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801280:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801283:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801288:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80128d:	be 00 00 00 00       	mov    $0x0,%esi
  801292:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801298:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80129a:	48 85 c0             	test   %rax,%rax
  80129d:	7f 06                	jg     8012a5 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80129f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012a3:	c9                   	leave
  8012a4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012a5:	49 89 c0             	mov    %rax,%r8
  8012a8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8012ad:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8012b4:	00 00 00 
  8012b7:	be 26 00 00 00       	mov    $0x26,%esi
  8012bc:	48 bf b7 31 80 00 00 	movabs $0x8031b7,%rdi
  8012c3:	00 00 00 
  8012c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cb:	49 b9 58 2a 80 00 00 	movabs $0x802a58,%r9
  8012d2:	00 00 00 
  8012d5:	41 ff d1             	call   *%r9

00000000008012d8 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8012d8:	f3 0f 1e fa          	endbr64
  8012dc:	55                   	push   %rbp
  8012dd:	48 89 e5             	mov    %rsp,%rbp
  8012e0:	53                   	push   %rbx
  8012e1:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8012e5:	48 63 ce             	movslq %esi,%rcx
  8012e8:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012eb:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012fa:	be 00 00 00 00       	mov    $0x0,%esi
  8012ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801305:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801307:	48 85 c0             	test   %rax,%rax
  80130a:	7f 06                	jg     801312 <sys_env_set_status+0x3a>
}
  80130c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801310:	c9                   	leave
  801311:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801312:	49 89 c0             	mov    %rax,%r8
  801315:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80131a:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801321:	00 00 00 
  801324:	be 26 00 00 00       	mov    $0x26,%esi
  801329:	48 bf b7 31 80 00 00 	movabs $0x8031b7,%rdi
  801330:	00 00 00 
  801333:	b8 00 00 00 00       	mov    $0x0,%eax
  801338:	49 b9 58 2a 80 00 00 	movabs $0x802a58,%r9
  80133f:	00 00 00 
  801342:	41 ff d1             	call   *%r9

0000000000801345 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801345:	f3 0f 1e fa          	endbr64
  801349:	55                   	push   %rbp
  80134a:	48 89 e5             	mov    %rsp,%rbp
  80134d:	53                   	push   %rbx
  80134e:	48 83 ec 08          	sub    $0x8,%rsp
  801352:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801355:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801358:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80135d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801362:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801367:	be 00 00 00 00       	mov    $0x0,%esi
  80136c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801372:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801374:	48 85 c0             	test   %rax,%rax
  801377:	7f 06                	jg     80137f <sys_env_set_trapframe+0x3a>
}
  801379:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80137d:	c9                   	leave
  80137e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80137f:	49 89 c0             	mov    %rax,%r8
  801382:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801387:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  80138e:	00 00 00 
  801391:	be 26 00 00 00       	mov    $0x26,%esi
  801396:	48 bf b7 31 80 00 00 	movabs $0x8031b7,%rdi
  80139d:	00 00 00 
  8013a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a5:	49 b9 58 2a 80 00 00 	movabs $0x802a58,%r9
  8013ac:	00 00 00 
  8013af:	41 ff d1             	call   *%r9

00000000008013b2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8013b2:	f3 0f 1e fa          	endbr64
  8013b6:	55                   	push   %rbp
  8013b7:	48 89 e5             	mov    %rsp,%rbp
  8013ba:	53                   	push   %rbx
  8013bb:	48 83 ec 08          	sub    $0x8,%rsp
  8013bf:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8013c2:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013c5:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013cf:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013d4:	be 00 00 00 00       	mov    $0x0,%esi
  8013d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013df:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013e1:	48 85 c0             	test   %rax,%rax
  8013e4:	7f 06                	jg     8013ec <sys_env_set_pgfault_upcall+0x3a>
}
  8013e6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013ea:	c9                   	leave
  8013eb:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013ec:	49 89 c0             	mov    %rax,%r8
  8013ef:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8013f4:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8013fb:	00 00 00 
  8013fe:	be 26 00 00 00       	mov    $0x26,%esi
  801403:	48 bf b7 31 80 00 00 	movabs $0x8031b7,%rdi
  80140a:	00 00 00 
  80140d:	b8 00 00 00 00       	mov    $0x0,%eax
  801412:	49 b9 58 2a 80 00 00 	movabs $0x802a58,%r9
  801419:	00 00 00 
  80141c:	41 ff d1             	call   *%r9

000000000080141f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80141f:	f3 0f 1e fa          	endbr64
  801423:	55                   	push   %rbp
  801424:	48 89 e5             	mov    %rsp,%rbp
  801427:	53                   	push   %rbx
  801428:	89 f8                	mov    %edi,%eax
  80142a:	49 89 f1             	mov    %rsi,%r9
  80142d:	48 89 d3             	mov    %rdx,%rbx
  801430:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801433:	49 63 f0             	movslq %r8d,%rsi
  801436:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801439:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80143e:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801441:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801447:	cd 30                	int    $0x30
}
  801449:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80144d:	c9                   	leave
  80144e:	c3                   	ret

000000000080144f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80144f:	f3 0f 1e fa          	endbr64
  801453:	55                   	push   %rbp
  801454:	48 89 e5             	mov    %rsp,%rbp
  801457:	53                   	push   %rbx
  801458:	48 83 ec 08          	sub    $0x8,%rsp
  80145c:	48 89 fa             	mov    %rdi,%rdx
  80145f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801462:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801467:	bb 00 00 00 00       	mov    $0x0,%ebx
  80146c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801471:	be 00 00 00 00       	mov    $0x0,%esi
  801476:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80147c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80147e:	48 85 c0             	test   %rax,%rax
  801481:	7f 06                	jg     801489 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801483:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801487:	c9                   	leave
  801488:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801489:	49 89 c0             	mov    %rax,%r8
  80148c:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801491:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801498:	00 00 00 
  80149b:	be 26 00 00 00       	mov    $0x26,%esi
  8014a0:	48 bf b7 31 80 00 00 	movabs $0x8031b7,%rdi
  8014a7:	00 00 00 
  8014aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8014af:	49 b9 58 2a 80 00 00 	movabs $0x802a58,%r9
  8014b6:	00 00 00 
  8014b9:	41 ff d1             	call   *%r9

00000000008014bc <sys_gettime>:

int
sys_gettime(void) {
  8014bc:	f3 0f 1e fa          	endbr64
  8014c0:	55                   	push   %rbp
  8014c1:	48 89 e5             	mov    %rsp,%rbp
  8014c4:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014c5:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8014cf:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014d9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014de:	be 00 00 00 00       	mov    $0x0,%esi
  8014e3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014e9:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8014eb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014ef:	c9                   	leave
  8014f0:	c3                   	ret

00000000008014f1 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  8014f1:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8014f5:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8014fc:	ff ff ff 
  8014ff:	48 01 f8             	add    %rdi,%rax
  801502:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801506:	c3                   	ret

0000000000801507 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801507:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80150b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801512:	ff ff ff 
  801515:	48 01 f8             	add    %rdi,%rax
  801518:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80151c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801522:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801526:	c3                   	ret

0000000000801527 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801527:	f3 0f 1e fa          	endbr64
  80152b:	55                   	push   %rbp
  80152c:	48 89 e5             	mov    %rsp,%rbp
  80152f:	41 57                	push   %r15
  801531:	41 56                	push   %r14
  801533:	41 55                	push   %r13
  801535:	41 54                	push   %r12
  801537:	53                   	push   %rbx
  801538:	48 83 ec 08          	sub    $0x8,%rsp
  80153c:	49 89 ff             	mov    %rdi,%r15
  80153f:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801544:	49 bd 86 26 80 00 00 	movabs $0x802686,%r13
  80154b:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80154e:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801554:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801557:	48 89 df             	mov    %rbx,%rdi
  80155a:	41 ff d5             	call   *%r13
  80155d:	83 e0 04             	and    $0x4,%eax
  801560:	74 17                	je     801579 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801562:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801569:	4c 39 f3             	cmp    %r14,%rbx
  80156c:	75 e6                	jne    801554 <fd_alloc+0x2d>
  80156e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801574:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801579:	4d 89 27             	mov    %r12,(%r15)
}
  80157c:	48 83 c4 08          	add    $0x8,%rsp
  801580:	5b                   	pop    %rbx
  801581:	41 5c                	pop    %r12
  801583:	41 5d                	pop    %r13
  801585:	41 5e                	pop    %r14
  801587:	41 5f                	pop    %r15
  801589:	5d                   	pop    %rbp
  80158a:	c3                   	ret

000000000080158b <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  80158b:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  80158f:	83 ff 1f             	cmp    $0x1f,%edi
  801592:	77 39                	ja     8015cd <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801594:	55                   	push   %rbp
  801595:	48 89 e5             	mov    %rsp,%rbp
  801598:	41 54                	push   %r12
  80159a:	53                   	push   %rbx
  80159b:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80159e:	48 63 df             	movslq %edi,%rbx
  8015a1:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8015a8:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8015ac:	48 89 df             	mov    %rbx,%rdi
  8015af:	48 b8 86 26 80 00 00 	movabs $0x802686,%rax
  8015b6:	00 00 00 
  8015b9:	ff d0                	call   *%rax
  8015bb:	a8 04                	test   $0x4,%al
  8015bd:	74 14                	je     8015d3 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8015bf:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8015c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c8:	5b                   	pop    %rbx
  8015c9:	41 5c                	pop    %r12
  8015cb:	5d                   	pop    %rbp
  8015cc:	c3                   	ret
        return -E_INVAL;
  8015cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015d2:	c3                   	ret
        return -E_INVAL;
  8015d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d8:	eb ee                	jmp    8015c8 <fd_lookup+0x3d>

00000000008015da <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8015da:	f3 0f 1e fa          	endbr64
  8015de:	55                   	push   %rbp
  8015df:	48 89 e5             	mov    %rsp,%rbp
  8015e2:	41 54                	push   %r12
  8015e4:	53                   	push   %rbx
  8015e5:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  8015e8:	48 b8 c0 36 80 00 00 	movabs $0x8036c0,%rax
  8015ef:	00 00 00 
  8015f2:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  8015f9:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8015fc:	39 3b                	cmp    %edi,(%rbx)
  8015fe:	74 47                	je     801647 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801600:	48 83 c0 08          	add    $0x8,%rax
  801604:	48 8b 18             	mov    (%rax),%rbx
  801607:	48 85 db             	test   %rbx,%rbx
  80160a:	75 f0                	jne    8015fc <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80160c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801613:	00 00 00 
  801616:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80161c:	89 fa                	mov    %edi,%edx
  80161e:	48 bf 20 36 80 00 00 	movabs $0x803620,%rdi
  801625:	00 00 00 
  801628:	b8 00 00 00 00       	mov    $0x0,%eax
  80162d:	48 b9 df 01 80 00 00 	movabs $0x8001df,%rcx
  801634:	00 00 00 
  801637:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801639:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  80163e:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801642:	5b                   	pop    %rbx
  801643:	41 5c                	pop    %r12
  801645:	5d                   	pop    %rbp
  801646:	c3                   	ret
            return 0;
  801647:	b8 00 00 00 00       	mov    $0x0,%eax
  80164c:	eb f0                	jmp    80163e <dev_lookup+0x64>

000000000080164e <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80164e:	f3 0f 1e fa          	endbr64
  801652:	55                   	push   %rbp
  801653:	48 89 e5             	mov    %rsp,%rbp
  801656:	41 55                	push   %r13
  801658:	41 54                	push   %r12
  80165a:	53                   	push   %rbx
  80165b:	48 83 ec 18          	sub    $0x18,%rsp
  80165f:	48 89 fb             	mov    %rdi,%rbx
  801662:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801665:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80166c:	ff ff ff 
  80166f:	48 01 df             	add    %rbx,%rdi
  801672:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801676:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80167a:	48 b8 8b 15 80 00 00 	movabs $0x80158b,%rax
  801681:	00 00 00 
  801684:	ff d0                	call   *%rax
  801686:	41 89 c5             	mov    %eax,%r13d
  801689:	85 c0                	test   %eax,%eax
  80168b:	78 06                	js     801693 <fd_close+0x45>
  80168d:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801691:	74 1a                	je     8016ad <fd_close+0x5f>
        return (must_exist ? res : 0);
  801693:	45 84 e4             	test   %r12b,%r12b
  801696:	b8 00 00 00 00       	mov    $0x0,%eax
  80169b:	44 0f 44 e8          	cmove  %eax,%r13d
}
  80169f:	44 89 e8             	mov    %r13d,%eax
  8016a2:	48 83 c4 18          	add    $0x18,%rsp
  8016a6:	5b                   	pop    %rbx
  8016a7:	41 5c                	pop    %r12
  8016a9:	41 5d                	pop    %r13
  8016ab:	5d                   	pop    %rbp
  8016ac:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016ad:	8b 3b                	mov    (%rbx),%edi
  8016af:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8016b3:	48 b8 da 15 80 00 00 	movabs $0x8015da,%rax
  8016ba:	00 00 00 
  8016bd:	ff d0                	call   *%rax
  8016bf:	41 89 c5             	mov    %eax,%r13d
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	78 1b                	js     8016e1 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8016c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ca:	48 8b 40 20          	mov    0x20(%rax),%rax
  8016ce:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8016d4:	48 85 c0             	test   %rax,%rax
  8016d7:	74 08                	je     8016e1 <fd_close+0x93>
  8016d9:	48 89 df             	mov    %rbx,%rdi
  8016dc:	ff d0                	call   *%rax
  8016de:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8016e1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8016e6:	48 89 de             	mov    %rbx,%rsi
  8016e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8016ee:	48 b8 6d 12 80 00 00 	movabs $0x80126d,%rax
  8016f5:	00 00 00 
  8016f8:	ff d0                	call   *%rax
    return res;
  8016fa:	eb a3                	jmp    80169f <fd_close+0x51>

00000000008016fc <close>:

int
close(int fdnum) {
  8016fc:	f3 0f 1e fa          	endbr64
  801700:	55                   	push   %rbp
  801701:	48 89 e5             	mov    %rsp,%rbp
  801704:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801708:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80170c:	48 b8 8b 15 80 00 00 	movabs $0x80158b,%rax
  801713:	00 00 00 
  801716:	ff d0                	call   *%rax
    if (res < 0) return res;
  801718:	85 c0                	test   %eax,%eax
  80171a:	78 15                	js     801731 <close+0x35>

    return fd_close(fd, 1);
  80171c:	be 01 00 00 00       	mov    $0x1,%esi
  801721:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801725:	48 b8 4e 16 80 00 00 	movabs $0x80164e,%rax
  80172c:	00 00 00 
  80172f:	ff d0                	call   *%rax
}
  801731:	c9                   	leave
  801732:	c3                   	ret

0000000000801733 <close_all>:

void
close_all(void) {
  801733:	f3 0f 1e fa          	endbr64
  801737:	55                   	push   %rbp
  801738:	48 89 e5             	mov    %rsp,%rbp
  80173b:	41 54                	push   %r12
  80173d:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80173e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801743:	49 bc fc 16 80 00 00 	movabs $0x8016fc,%r12
  80174a:	00 00 00 
  80174d:	89 df                	mov    %ebx,%edi
  80174f:	41 ff d4             	call   *%r12
  801752:	83 c3 01             	add    $0x1,%ebx
  801755:	83 fb 20             	cmp    $0x20,%ebx
  801758:	75 f3                	jne    80174d <close_all+0x1a>
}
  80175a:	5b                   	pop    %rbx
  80175b:	41 5c                	pop    %r12
  80175d:	5d                   	pop    %rbp
  80175e:	c3                   	ret

000000000080175f <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80175f:	f3 0f 1e fa          	endbr64
  801763:	55                   	push   %rbp
  801764:	48 89 e5             	mov    %rsp,%rbp
  801767:	41 57                	push   %r15
  801769:	41 56                	push   %r14
  80176b:	41 55                	push   %r13
  80176d:	41 54                	push   %r12
  80176f:	53                   	push   %rbx
  801770:	48 83 ec 18          	sub    $0x18,%rsp
  801774:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801777:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  80177b:	48 b8 8b 15 80 00 00 	movabs $0x80158b,%rax
  801782:	00 00 00 
  801785:	ff d0                	call   *%rax
  801787:	89 c3                	mov    %eax,%ebx
  801789:	85 c0                	test   %eax,%eax
  80178b:	0f 88 b8 00 00 00    	js     801849 <dup+0xea>
    close(newfdnum);
  801791:	44 89 e7             	mov    %r12d,%edi
  801794:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  80179b:	00 00 00 
  80179e:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8017a0:	4d 63 ec             	movslq %r12d,%r13
  8017a3:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8017aa:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8017ae:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8017b2:	4c 89 ff             	mov    %r15,%rdi
  8017b5:	49 be 07 15 80 00 00 	movabs $0x801507,%r14
  8017bc:	00 00 00 
  8017bf:	41 ff d6             	call   *%r14
  8017c2:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8017c5:	4c 89 ef             	mov    %r13,%rdi
  8017c8:	41 ff d6             	call   *%r14
  8017cb:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8017ce:	48 89 df             	mov    %rbx,%rdi
  8017d1:	48 b8 86 26 80 00 00 	movabs $0x802686,%rax
  8017d8:	00 00 00 
  8017db:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8017dd:	a8 04                	test   $0x4,%al
  8017df:	74 2b                	je     80180c <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8017e1:	41 89 c1             	mov    %eax,%r9d
  8017e4:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8017ea:	4c 89 f1             	mov    %r14,%rcx
  8017ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f2:	48 89 de             	mov    %rbx,%rsi
  8017f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8017fa:	48 b8 98 11 80 00 00 	movabs $0x801198,%rax
  801801:	00 00 00 
  801804:	ff d0                	call   *%rax
  801806:	89 c3                	mov    %eax,%ebx
  801808:	85 c0                	test   %eax,%eax
  80180a:	78 4e                	js     80185a <dup+0xfb>
    }
    prot = get_prot(oldfd);
  80180c:	4c 89 ff             	mov    %r15,%rdi
  80180f:	48 b8 86 26 80 00 00 	movabs $0x802686,%rax
  801816:	00 00 00 
  801819:	ff d0                	call   *%rax
  80181b:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  80181e:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801824:	4c 89 e9             	mov    %r13,%rcx
  801827:	ba 00 00 00 00       	mov    $0x0,%edx
  80182c:	4c 89 fe             	mov    %r15,%rsi
  80182f:	bf 00 00 00 00       	mov    $0x0,%edi
  801834:	48 b8 98 11 80 00 00 	movabs $0x801198,%rax
  80183b:	00 00 00 
  80183e:	ff d0                	call   *%rax
  801840:	89 c3                	mov    %eax,%ebx
  801842:	85 c0                	test   %eax,%eax
  801844:	78 14                	js     80185a <dup+0xfb>

    return newfdnum;
  801846:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801849:	89 d8                	mov    %ebx,%eax
  80184b:	48 83 c4 18          	add    $0x18,%rsp
  80184f:	5b                   	pop    %rbx
  801850:	41 5c                	pop    %r12
  801852:	41 5d                	pop    %r13
  801854:	41 5e                	pop    %r14
  801856:	41 5f                	pop    %r15
  801858:	5d                   	pop    %rbp
  801859:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80185a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80185f:	4c 89 ee             	mov    %r13,%rsi
  801862:	bf 00 00 00 00       	mov    $0x0,%edi
  801867:	49 bc 6d 12 80 00 00 	movabs $0x80126d,%r12
  80186e:	00 00 00 
  801871:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801874:	ba 00 10 00 00       	mov    $0x1000,%edx
  801879:	4c 89 f6             	mov    %r14,%rsi
  80187c:	bf 00 00 00 00       	mov    $0x0,%edi
  801881:	41 ff d4             	call   *%r12
    return res;
  801884:	eb c3                	jmp    801849 <dup+0xea>

0000000000801886 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801886:	f3 0f 1e fa          	endbr64
  80188a:	55                   	push   %rbp
  80188b:	48 89 e5             	mov    %rsp,%rbp
  80188e:	41 56                	push   %r14
  801890:	41 55                	push   %r13
  801892:	41 54                	push   %r12
  801894:	53                   	push   %rbx
  801895:	48 83 ec 10          	sub    $0x10,%rsp
  801899:	89 fb                	mov    %edi,%ebx
  80189b:	49 89 f4             	mov    %rsi,%r12
  80189e:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8018a1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018a5:	48 b8 8b 15 80 00 00 	movabs $0x80158b,%rax
  8018ac:	00 00 00 
  8018af:	ff d0                	call   *%rax
  8018b1:	85 c0                	test   %eax,%eax
  8018b3:	78 4c                	js     801901 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8018b5:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8018b9:	41 8b 3e             	mov    (%r14),%edi
  8018bc:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018c0:	48 b8 da 15 80 00 00 	movabs $0x8015da,%rax
  8018c7:	00 00 00 
  8018ca:	ff d0                	call   *%rax
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	78 35                	js     801905 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018d0:	41 8b 46 08          	mov    0x8(%r14),%eax
  8018d4:	83 e0 03             	and    $0x3,%eax
  8018d7:	83 f8 01             	cmp    $0x1,%eax
  8018da:	74 2d                	je     801909 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8018dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8018e4:	48 85 c0             	test   %rax,%rax
  8018e7:	74 56                	je     80193f <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  8018e9:	4c 89 ea             	mov    %r13,%rdx
  8018ec:	4c 89 e6             	mov    %r12,%rsi
  8018ef:	4c 89 f7             	mov    %r14,%rdi
  8018f2:	ff d0                	call   *%rax
}
  8018f4:	48 83 c4 10          	add    $0x10,%rsp
  8018f8:	5b                   	pop    %rbx
  8018f9:	41 5c                	pop    %r12
  8018fb:	41 5d                	pop    %r13
  8018fd:	41 5e                	pop    %r14
  8018ff:	5d                   	pop    %rbp
  801900:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801901:	48 98                	cltq
  801903:	eb ef                	jmp    8018f4 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801905:	48 98                	cltq
  801907:	eb eb                	jmp    8018f4 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801909:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801910:	00 00 00 
  801913:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801919:	89 da                	mov    %ebx,%edx
  80191b:	48 bf c5 31 80 00 00 	movabs $0x8031c5,%rdi
  801922:	00 00 00 
  801925:	b8 00 00 00 00       	mov    $0x0,%eax
  80192a:	48 b9 df 01 80 00 00 	movabs $0x8001df,%rcx
  801931:	00 00 00 
  801934:	ff d1                	call   *%rcx
        return -E_INVAL;
  801936:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80193d:	eb b5                	jmp    8018f4 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  80193f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801946:	eb ac                	jmp    8018f4 <read+0x6e>

0000000000801948 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801948:	f3 0f 1e fa          	endbr64
  80194c:	55                   	push   %rbp
  80194d:	48 89 e5             	mov    %rsp,%rbp
  801950:	41 57                	push   %r15
  801952:	41 56                	push   %r14
  801954:	41 55                	push   %r13
  801956:	41 54                	push   %r12
  801958:	53                   	push   %rbx
  801959:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  80195d:	48 85 d2             	test   %rdx,%rdx
  801960:	74 54                	je     8019b6 <readn+0x6e>
  801962:	41 89 fd             	mov    %edi,%r13d
  801965:	49 89 f6             	mov    %rsi,%r14
  801968:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  80196b:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801970:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801975:	49 bf 86 18 80 00 00 	movabs $0x801886,%r15
  80197c:	00 00 00 
  80197f:	4c 89 e2             	mov    %r12,%rdx
  801982:	48 29 f2             	sub    %rsi,%rdx
  801985:	4c 01 f6             	add    %r14,%rsi
  801988:	44 89 ef             	mov    %r13d,%edi
  80198b:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  80198e:	85 c0                	test   %eax,%eax
  801990:	78 20                	js     8019b2 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801992:	01 c3                	add    %eax,%ebx
  801994:	85 c0                	test   %eax,%eax
  801996:	74 08                	je     8019a0 <readn+0x58>
  801998:	48 63 f3             	movslq %ebx,%rsi
  80199b:	4c 39 e6             	cmp    %r12,%rsi
  80199e:	72 df                	jb     80197f <readn+0x37>
    }
    return res;
  8019a0:	48 63 c3             	movslq %ebx,%rax
}
  8019a3:	48 83 c4 08          	add    $0x8,%rsp
  8019a7:	5b                   	pop    %rbx
  8019a8:	41 5c                	pop    %r12
  8019aa:	41 5d                	pop    %r13
  8019ac:	41 5e                	pop    %r14
  8019ae:	41 5f                	pop    %r15
  8019b0:	5d                   	pop    %rbp
  8019b1:	c3                   	ret
        if (inc < 0) return inc;
  8019b2:	48 98                	cltq
  8019b4:	eb ed                	jmp    8019a3 <readn+0x5b>
    int inc = 1, res = 0;
  8019b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019bb:	eb e3                	jmp    8019a0 <readn+0x58>

00000000008019bd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8019bd:	f3 0f 1e fa          	endbr64
  8019c1:	55                   	push   %rbp
  8019c2:	48 89 e5             	mov    %rsp,%rbp
  8019c5:	41 56                	push   %r14
  8019c7:	41 55                	push   %r13
  8019c9:	41 54                	push   %r12
  8019cb:	53                   	push   %rbx
  8019cc:	48 83 ec 10          	sub    $0x10,%rsp
  8019d0:	89 fb                	mov    %edi,%ebx
  8019d2:	49 89 f4             	mov    %rsi,%r12
  8019d5:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019d8:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019dc:	48 b8 8b 15 80 00 00 	movabs $0x80158b,%rax
  8019e3:	00 00 00 
  8019e6:	ff d0                	call   *%rax
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	78 47                	js     801a33 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019ec:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8019f0:	41 8b 3e             	mov    (%r14),%edi
  8019f3:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8019f7:	48 b8 da 15 80 00 00 	movabs $0x8015da,%rax
  8019fe:	00 00 00 
  801a01:	ff d0                	call   *%rax
  801a03:	85 c0                	test   %eax,%eax
  801a05:	78 30                	js     801a37 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a07:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801a0c:	74 2d                	je     801a3b <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801a0e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a12:	48 8b 40 18          	mov    0x18(%rax),%rax
  801a16:	48 85 c0             	test   %rax,%rax
  801a19:	74 56                	je     801a71 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801a1b:	4c 89 ea             	mov    %r13,%rdx
  801a1e:	4c 89 e6             	mov    %r12,%rsi
  801a21:	4c 89 f7             	mov    %r14,%rdi
  801a24:	ff d0                	call   *%rax
}
  801a26:	48 83 c4 10          	add    $0x10,%rsp
  801a2a:	5b                   	pop    %rbx
  801a2b:	41 5c                	pop    %r12
  801a2d:	41 5d                	pop    %r13
  801a2f:	41 5e                	pop    %r14
  801a31:	5d                   	pop    %rbp
  801a32:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a33:	48 98                	cltq
  801a35:	eb ef                	jmp    801a26 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a37:	48 98                	cltq
  801a39:	eb eb                	jmp    801a26 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a3b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a42:	00 00 00 
  801a45:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a4b:	89 da                	mov    %ebx,%edx
  801a4d:	48 bf e1 31 80 00 00 	movabs $0x8031e1,%rdi
  801a54:	00 00 00 
  801a57:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5c:	48 b9 df 01 80 00 00 	movabs $0x8001df,%rcx
  801a63:	00 00 00 
  801a66:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a68:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801a6f:	eb b5                	jmp    801a26 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801a71:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a78:	eb ac                	jmp    801a26 <write+0x69>

0000000000801a7a <seek>:

int
seek(int fdnum, off_t offset) {
  801a7a:	f3 0f 1e fa          	endbr64
  801a7e:	55                   	push   %rbp
  801a7f:	48 89 e5             	mov    %rsp,%rbp
  801a82:	53                   	push   %rbx
  801a83:	48 83 ec 18          	sub    $0x18,%rsp
  801a87:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a89:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801a8d:	48 b8 8b 15 80 00 00 	movabs $0x80158b,%rax
  801a94:	00 00 00 
  801a97:	ff d0                	call   *%rax
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	78 0c                	js     801aa9 <seek+0x2f>

    fd->fd_offset = offset;
  801a9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aa1:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801aa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801aad:	c9                   	leave
  801aae:	c3                   	ret

0000000000801aaf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801aaf:	f3 0f 1e fa          	endbr64
  801ab3:	55                   	push   %rbp
  801ab4:	48 89 e5             	mov    %rsp,%rbp
  801ab7:	41 55                	push   %r13
  801ab9:	41 54                	push   %r12
  801abb:	53                   	push   %rbx
  801abc:	48 83 ec 18          	sub    $0x18,%rsp
  801ac0:	89 fb                	mov    %edi,%ebx
  801ac2:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ac5:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ac9:	48 b8 8b 15 80 00 00 	movabs $0x80158b,%rax
  801ad0:	00 00 00 
  801ad3:	ff d0                	call   *%rax
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	78 38                	js     801b11 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ad9:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801add:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801ae1:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ae5:	48 b8 da 15 80 00 00 	movabs $0x8015da,%rax
  801aec:	00 00 00 
  801aef:	ff d0                	call   *%rax
  801af1:	85 c0                	test   %eax,%eax
  801af3:	78 1c                	js     801b11 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801af5:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801afa:	74 20                	je     801b1c <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801afc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b00:	48 8b 40 30          	mov    0x30(%rax),%rax
  801b04:	48 85 c0             	test   %rax,%rax
  801b07:	74 47                	je     801b50 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801b09:	44 89 e6             	mov    %r12d,%esi
  801b0c:	4c 89 ef             	mov    %r13,%rdi
  801b0f:	ff d0                	call   *%rax
}
  801b11:	48 83 c4 18          	add    $0x18,%rsp
  801b15:	5b                   	pop    %rbx
  801b16:	41 5c                	pop    %r12
  801b18:	41 5d                	pop    %r13
  801b1a:	5d                   	pop    %rbp
  801b1b:	c3                   	ret
                thisenv->env_id, fdnum);
  801b1c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b23:	00 00 00 
  801b26:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b2c:	89 da                	mov    %ebx,%edx
  801b2e:	48 bf 40 36 80 00 00 	movabs $0x803640,%rdi
  801b35:	00 00 00 
  801b38:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3d:	48 b9 df 01 80 00 00 	movabs $0x8001df,%rcx
  801b44:	00 00 00 
  801b47:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b4e:	eb c1                	jmp    801b11 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801b50:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801b55:	eb ba                	jmp    801b11 <ftruncate+0x62>

0000000000801b57 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801b57:	f3 0f 1e fa          	endbr64
  801b5b:	55                   	push   %rbp
  801b5c:	48 89 e5             	mov    %rsp,%rbp
  801b5f:	41 54                	push   %r12
  801b61:	53                   	push   %rbx
  801b62:	48 83 ec 10          	sub    $0x10,%rsp
  801b66:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b69:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801b6d:	48 b8 8b 15 80 00 00 	movabs $0x80158b,%rax
  801b74:	00 00 00 
  801b77:	ff d0                	call   *%rax
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	78 4e                	js     801bcb <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b7d:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801b81:	41 8b 3c 24          	mov    (%r12),%edi
  801b85:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801b89:	48 b8 da 15 80 00 00 	movabs $0x8015da,%rax
  801b90:	00 00 00 
  801b93:	ff d0                	call   *%rax
  801b95:	85 c0                	test   %eax,%eax
  801b97:	78 32                	js     801bcb <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801b99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b9d:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801ba2:	74 30                	je     801bd4 <fstat+0x7d>

    stat->st_name[0] = 0;
  801ba4:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801ba7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801bae:	00 00 00 
    stat->st_isdir = 0;
  801bb1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801bb8:	00 00 00 
    stat->st_dev = dev;
  801bbb:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801bc2:	48 89 de             	mov    %rbx,%rsi
  801bc5:	4c 89 e7             	mov    %r12,%rdi
  801bc8:	ff 50 28             	call   *0x28(%rax)
}
  801bcb:	48 83 c4 10          	add    $0x10,%rsp
  801bcf:	5b                   	pop    %rbx
  801bd0:	41 5c                	pop    %r12
  801bd2:	5d                   	pop    %rbp
  801bd3:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801bd4:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801bd9:	eb f0                	jmp    801bcb <fstat+0x74>

0000000000801bdb <stat>:

int
stat(const char *path, struct Stat *stat) {
  801bdb:	f3 0f 1e fa          	endbr64
  801bdf:	55                   	push   %rbp
  801be0:	48 89 e5             	mov    %rsp,%rbp
  801be3:	41 54                	push   %r12
  801be5:	53                   	push   %rbx
  801be6:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801be9:	be 00 00 00 00       	mov    $0x0,%esi
  801bee:	48 b8 bc 1e 80 00 00 	movabs $0x801ebc,%rax
  801bf5:	00 00 00 
  801bf8:	ff d0                	call   *%rax
  801bfa:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	78 25                	js     801c25 <stat+0x4a>

    int res = fstat(fd, stat);
  801c00:	4c 89 e6             	mov    %r12,%rsi
  801c03:	89 c7                	mov    %eax,%edi
  801c05:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  801c0c:	00 00 00 
  801c0f:	ff d0                	call   *%rax
  801c11:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801c14:	89 df                	mov    %ebx,%edi
  801c16:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801c1d:	00 00 00 
  801c20:	ff d0                	call   *%rax

    return res;
  801c22:	44 89 e3             	mov    %r12d,%ebx
}
  801c25:	89 d8                	mov    %ebx,%eax
  801c27:	5b                   	pop    %rbx
  801c28:	41 5c                	pop    %r12
  801c2a:	5d                   	pop    %rbp
  801c2b:	c3                   	ret

0000000000801c2c <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801c2c:	f3 0f 1e fa          	endbr64
  801c30:	55                   	push   %rbp
  801c31:	48 89 e5             	mov    %rsp,%rbp
  801c34:	41 54                	push   %r12
  801c36:	53                   	push   %rbx
  801c37:	48 83 ec 10          	sub    $0x10,%rsp
  801c3b:	41 89 fc             	mov    %edi,%r12d
  801c3e:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801c41:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c48:	00 00 00 
  801c4b:	83 38 00             	cmpl   $0x0,(%rax)
  801c4e:	74 6e                	je     801cbe <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801c50:	bf 03 00 00 00       	mov    $0x3,%edi
  801c55:	48 b8 5a 2c 80 00 00 	movabs $0x802c5a,%rax
  801c5c:	00 00 00 
  801c5f:	ff d0                	call   *%rax
  801c61:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801c68:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801c6a:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801c70:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c75:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801c7c:	00 00 00 
  801c7f:	44 89 e6             	mov    %r12d,%esi
  801c82:	89 c7                	mov    %eax,%edi
  801c84:	48 b8 98 2b 80 00 00 	movabs $0x802b98,%rax
  801c8b:	00 00 00 
  801c8e:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801c90:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801c97:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801c98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c9d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ca1:	48 89 de             	mov    %rbx,%rsi
  801ca4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ca9:	48 b8 ff 2a 80 00 00 	movabs $0x802aff,%rax
  801cb0:	00 00 00 
  801cb3:	ff d0                	call   *%rax
}
  801cb5:	48 83 c4 10          	add    $0x10,%rsp
  801cb9:	5b                   	pop    %rbx
  801cba:	41 5c                	pop    %r12
  801cbc:	5d                   	pop    %rbp
  801cbd:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801cbe:	bf 03 00 00 00       	mov    $0x3,%edi
  801cc3:	48 b8 5a 2c 80 00 00 	movabs $0x802c5a,%rax
  801cca:	00 00 00 
  801ccd:	ff d0                	call   *%rax
  801ccf:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801cd6:	00 00 
  801cd8:	e9 73 ff ff ff       	jmp    801c50 <fsipc+0x24>

0000000000801cdd <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801cdd:	f3 0f 1e fa          	endbr64
  801ce1:	55                   	push   %rbp
  801ce2:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ce5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801cec:	00 00 00 
  801cef:	8b 57 0c             	mov    0xc(%rdi),%edx
  801cf2:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801cf4:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801cf7:	be 00 00 00 00       	mov    $0x0,%esi
  801cfc:	bf 02 00 00 00       	mov    $0x2,%edi
  801d01:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  801d08:	00 00 00 
  801d0b:	ff d0                	call   *%rax
}
  801d0d:	5d                   	pop    %rbp
  801d0e:	c3                   	ret

0000000000801d0f <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801d0f:	f3 0f 1e fa          	endbr64
  801d13:	55                   	push   %rbp
  801d14:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d17:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d1a:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d21:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801d23:	be 00 00 00 00       	mov    $0x0,%esi
  801d28:	bf 06 00 00 00       	mov    $0x6,%edi
  801d2d:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  801d34:	00 00 00 
  801d37:	ff d0                	call   *%rax
}
  801d39:	5d                   	pop    %rbp
  801d3a:	c3                   	ret

0000000000801d3b <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801d3b:	f3 0f 1e fa          	endbr64
  801d3f:	55                   	push   %rbp
  801d40:	48 89 e5             	mov    %rsp,%rbp
  801d43:	41 54                	push   %r12
  801d45:	53                   	push   %rbx
  801d46:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d49:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d4c:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d53:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801d55:	be 00 00 00 00       	mov    $0x0,%esi
  801d5a:	bf 05 00 00 00       	mov    $0x5,%edi
  801d5f:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  801d66:	00 00 00 
  801d69:	ff d0                	call   *%rax
    if (res < 0) return res;
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	78 3d                	js     801dac <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d6f:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  801d76:	00 00 00 
  801d79:	4c 89 e6             	mov    %r12,%rsi
  801d7c:	48 89 df             	mov    %rbx,%rdi
  801d7f:	48 b8 28 0b 80 00 00 	movabs $0x800b28,%rax
  801d86:	00 00 00 
  801d89:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801d8b:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801d92:	00 
  801d93:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d99:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801da0:	00 
  801da1:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dac:	5b                   	pop    %rbx
  801dad:	41 5c                	pop    %r12
  801daf:	5d                   	pop    %rbp
  801db0:	c3                   	ret

0000000000801db1 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801db1:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801db5:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801dbc:	77 41                	ja     801dff <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801dbe:	55                   	push   %rbp
  801dbf:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801dc2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801dc9:	00 00 00 
  801dcc:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801dcf:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  801dd1:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801dd5:	48 8d 78 10          	lea    0x10(%rax),%rdi
  801dd9:	48 b8 43 0d 80 00 00 	movabs $0x800d43,%rax
  801de0:	00 00 00 
  801de3:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  801de5:	be 00 00 00 00       	mov    $0x0,%esi
  801dea:	bf 04 00 00 00       	mov    $0x4,%edi
  801def:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  801df6:	00 00 00 
  801df9:	ff d0                	call   *%rax
  801dfb:	48 98                	cltq
}
  801dfd:	5d                   	pop    %rbp
  801dfe:	c3                   	ret
        return -E_INVAL;
  801dff:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  801e06:	c3                   	ret

0000000000801e07 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801e07:	f3 0f 1e fa          	endbr64
  801e0b:	55                   	push   %rbp
  801e0c:	48 89 e5             	mov    %rsp,%rbp
  801e0f:	41 55                	push   %r13
  801e11:	41 54                	push   %r12
  801e13:	53                   	push   %rbx
  801e14:	48 83 ec 08          	sub    $0x8,%rsp
  801e18:	49 89 f4             	mov    %rsi,%r12
  801e1b:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e1e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e25:	00 00 00 
  801e28:	8b 57 0c             	mov    0xc(%rdi),%edx
  801e2b:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  801e2d:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  801e31:	be 00 00 00 00       	mov    $0x0,%esi
  801e36:	bf 03 00 00 00       	mov    $0x3,%edi
  801e3b:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  801e42:	00 00 00 
  801e45:	ff d0                	call   *%rax
  801e47:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  801e4a:	4d 85 ed             	test   %r13,%r13
  801e4d:	78 2a                	js     801e79 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  801e4f:	4c 89 ea             	mov    %r13,%rdx
  801e52:	4c 39 eb             	cmp    %r13,%rbx
  801e55:	72 30                	jb     801e87 <devfile_read+0x80>
  801e57:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  801e5e:	7f 27                	jg     801e87 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  801e60:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801e67:	00 00 00 
  801e6a:	4c 89 e7             	mov    %r12,%rdi
  801e6d:	48 b8 43 0d 80 00 00 	movabs $0x800d43,%rax
  801e74:	00 00 00 
  801e77:	ff d0                	call   *%rax
}
  801e79:	4c 89 e8             	mov    %r13,%rax
  801e7c:	48 83 c4 08          	add    $0x8,%rsp
  801e80:	5b                   	pop    %rbx
  801e81:	41 5c                	pop    %r12
  801e83:	41 5d                	pop    %r13
  801e85:	5d                   	pop    %rbp
  801e86:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801e87:	48 b9 fe 31 80 00 00 	movabs $0x8031fe,%rcx
  801e8e:	00 00 00 
  801e91:	48 ba 1b 32 80 00 00 	movabs $0x80321b,%rdx
  801e98:	00 00 00 
  801e9b:	be 7b 00 00 00       	mov    $0x7b,%esi
  801ea0:	48 bf 30 32 80 00 00 	movabs $0x803230,%rdi
  801ea7:	00 00 00 
  801eaa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eaf:	49 b8 58 2a 80 00 00 	movabs $0x802a58,%r8
  801eb6:	00 00 00 
  801eb9:	41 ff d0             	call   *%r8

0000000000801ebc <open>:
open(const char *path, int mode) {
  801ebc:	f3 0f 1e fa          	endbr64
  801ec0:	55                   	push   %rbp
  801ec1:	48 89 e5             	mov    %rsp,%rbp
  801ec4:	41 55                	push   %r13
  801ec6:	41 54                	push   %r12
  801ec8:	53                   	push   %rbx
  801ec9:	48 83 ec 18          	sub    $0x18,%rsp
  801ecd:	49 89 fc             	mov    %rdi,%r12
  801ed0:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801ed3:	48 b8 e3 0a 80 00 00 	movabs $0x800ae3,%rax
  801eda:	00 00 00 
  801edd:	ff d0                	call   *%rax
  801edf:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801ee5:	0f 87 8a 00 00 00    	ja     801f75 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801eeb:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801eef:	48 b8 27 15 80 00 00 	movabs $0x801527,%rax
  801ef6:	00 00 00 
  801ef9:	ff d0                	call   *%rax
  801efb:	89 c3                	mov    %eax,%ebx
  801efd:	85 c0                	test   %eax,%eax
  801eff:	78 50                	js     801f51 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  801f01:	4c 89 e6             	mov    %r12,%rsi
  801f04:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801f0b:	00 00 00 
  801f0e:	48 89 df             	mov    %rbx,%rdi
  801f11:	48 b8 28 0b 80 00 00 	movabs $0x800b28,%rax
  801f18:	00 00 00 
  801f1b:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801f1d:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f24:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801f28:	bf 01 00 00 00       	mov    $0x1,%edi
  801f2d:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  801f34:	00 00 00 
  801f37:	ff d0                	call   *%rax
  801f39:	89 c3                	mov    %eax,%ebx
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	78 1f                	js     801f5e <open+0xa2>
    return fd2num(fd);
  801f3f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f43:	48 b8 f1 14 80 00 00 	movabs $0x8014f1,%rax
  801f4a:	00 00 00 
  801f4d:	ff d0                	call   *%rax
  801f4f:	89 c3                	mov    %eax,%ebx
}
  801f51:	89 d8                	mov    %ebx,%eax
  801f53:	48 83 c4 18          	add    $0x18,%rsp
  801f57:	5b                   	pop    %rbx
  801f58:	41 5c                	pop    %r12
  801f5a:	41 5d                	pop    %r13
  801f5c:	5d                   	pop    %rbp
  801f5d:	c3                   	ret
        fd_close(fd, 0);
  801f5e:	be 00 00 00 00       	mov    $0x0,%esi
  801f63:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f67:	48 b8 4e 16 80 00 00 	movabs $0x80164e,%rax
  801f6e:	00 00 00 
  801f71:	ff d0                	call   *%rax
        return res;
  801f73:	eb dc                	jmp    801f51 <open+0x95>
        return -E_BAD_PATH;
  801f75:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801f7a:	eb d5                	jmp    801f51 <open+0x95>

0000000000801f7c <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801f7c:	f3 0f 1e fa          	endbr64
  801f80:	55                   	push   %rbp
  801f81:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801f84:	be 00 00 00 00       	mov    $0x0,%esi
  801f89:	bf 08 00 00 00       	mov    $0x8,%edi
  801f8e:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  801f95:	00 00 00 
  801f98:	ff d0                	call   *%rax
}
  801f9a:	5d                   	pop    %rbp
  801f9b:	c3                   	ret

0000000000801f9c <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801f9c:	f3 0f 1e fa          	endbr64
  801fa0:	55                   	push   %rbp
  801fa1:	48 89 e5             	mov    %rsp,%rbp
  801fa4:	41 54                	push   %r12
  801fa6:	53                   	push   %rbx
  801fa7:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801faa:	48 b8 07 15 80 00 00 	movabs $0x801507,%rax
  801fb1:	00 00 00 
  801fb4:	ff d0                	call   *%rax
  801fb6:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801fb9:	48 be 3b 32 80 00 00 	movabs $0x80323b,%rsi
  801fc0:	00 00 00 
  801fc3:	48 89 df             	mov    %rbx,%rdi
  801fc6:	48 b8 28 0b 80 00 00 	movabs $0x800b28,%rax
  801fcd:	00 00 00 
  801fd0:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801fd2:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801fd7:	41 2b 04 24          	sub    (%r12),%eax
  801fdb:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801fe1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801fe8:	00 00 00 
    stat->st_dev = &devpipe;
  801feb:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801ff2:	00 00 00 
  801ff5:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  802001:	5b                   	pop    %rbx
  802002:	41 5c                	pop    %r12
  802004:	5d                   	pop    %rbp
  802005:	c3                   	ret

0000000000802006 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802006:	f3 0f 1e fa          	endbr64
  80200a:	55                   	push   %rbp
  80200b:	48 89 e5             	mov    %rsp,%rbp
  80200e:	41 54                	push   %r12
  802010:	53                   	push   %rbx
  802011:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802014:	ba 00 10 00 00       	mov    $0x1000,%edx
  802019:	48 89 fe             	mov    %rdi,%rsi
  80201c:	bf 00 00 00 00       	mov    $0x0,%edi
  802021:	49 bc 6d 12 80 00 00 	movabs $0x80126d,%r12
  802028:	00 00 00 
  80202b:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80202e:	48 89 df             	mov    %rbx,%rdi
  802031:	48 b8 07 15 80 00 00 	movabs $0x801507,%rax
  802038:	00 00 00 
  80203b:	ff d0                	call   *%rax
  80203d:	48 89 c6             	mov    %rax,%rsi
  802040:	ba 00 10 00 00       	mov    $0x1000,%edx
  802045:	bf 00 00 00 00       	mov    $0x0,%edi
  80204a:	41 ff d4             	call   *%r12
}
  80204d:	5b                   	pop    %rbx
  80204e:	41 5c                	pop    %r12
  802050:	5d                   	pop    %rbp
  802051:	c3                   	ret

0000000000802052 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802052:	f3 0f 1e fa          	endbr64
  802056:	55                   	push   %rbp
  802057:	48 89 e5             	mov    %rsp,%rbp
  80205a:	41 57                	push   %r15
  80205c:	41 56                	push   %r14
  80205e:	41 55                	push   %r13
  802060:	41 54                	push   %r12
  802062:	53                   	push   %rbx
  802063:	48 83 ec 18          	sub    $0x18,%rsp
  802067:	49 89 fc             	mov    %rdi,%r12
  80206a:	49 89 f5             	mov    %rsi,%r13
  80206d:	49 89 d7             	mov    %rdx,%r15
  802070:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802074:	48 b8 07 15 80 00 00 	movabs $0x801507,%rax
  80207b:	00 00 00 
  80207e:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802080:	4d 85 ff             	test   %r15,%r15
  802083:	0f 84 af 00 00 00    	je     802138 <devpipe_write+0xe6>
  802089:	48 89 c3             	mov    %rax,%rbx
  80208c:	4c 89 f8             	mov    %r15,%rax
  80208f:	4d 89 ef             	mov    %r13,%r15
  802092:	4c 01 e8             	add    %r13,%rax
  802095:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802099:	49 bd fd 10 80 00 00 	movabs $0x8010fd,%r13
  8020a0:	00 00 00 
            sys_yield();
  8020a3:	49 be 92 10 80 00 00 	movabs $0x801092,%r14
  8020aa:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8020ad:	8b 73 04             	mov    0x4(%rbx),%esi
  8020b0:	48 63 ce             	movslq %esi,%rcx
  8020b3:	48 63 03             	movslq (%rbx),%rax
  8020b6:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8020bc:	48 39 c1             	cmp    %rax,%rcx
  8020bf:	72 2e                	jb     8020ef <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8020c1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020c6:	48 89 da             	mov    %rbx,%rdx
  8020c9:	be 00 10 00 00       	mov    $0x1000,%esi
  8020ce:	4c 89 e7             	mov    %r12,%rdi
  8020d1:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	74 66                	je     80213e <devpipe_write+0xec>
            sys_yield();
  8020d8:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8020db:	8b 73 04             	mov    0x4(%rbx),%esi
  8020de:	48 63 ce             	movslq %esi,%rcx
  8020e1:	48 63 03             	movslq (%rbx),%rax
  8020e4:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8020ea:	48 39 c1             	cmp    %rax,%rcx
  8020ed:	73 d2                	jae    8020c1 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020ef:	41 0f b6 3f          	movzbl (%r15),%edi
  8020f3:	48 89 ca             	mov    %rcx,%rdx
  8020f6:	48 c1 ea 03          	shr    $0x3,%rdx
  8020fa:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802101:	08 10 20 
  802104:	48 f7 e2             	mul    %rdx
  802107:	48 c1 ea 06          	shr    $0x6,%rdx
  80210b:	48 89 d0             	mov    %rdx,%rax
  80210e:	48 c1 e0 09          	shl    $0x9,%rax
  802112:	48 29 d0             	sub    %rdx,%rax
  802115:	48 c1 e0 03          	shl    $0x3,%rax
  802119:	48 29 c1             	sub    %rax,%rcx
  80211c:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802121:	83 c6 01             	add    $0x1,%esi
  802124:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802127:	49 83 c7 01          	add    $0x1,%r15
  80212b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80212f:	49 39 c7             	cmp    %rax,%r15
  802132:	0f 85 75 ff ff ff    	jne    8020ad <devpipe_write+0x5b>
    return n;
  802138:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80213c:	eb 05                	jmp    802143 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  80213e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802143:	48 83 c4 18          	add    $0x18,%rsp
  802147:	5b                   	pop    %rbx
  802148:	41 5c                	pop    %r12
  80214a:	41 5d                	pop    %r13
  80214c:	41 5e                	pop    %r14
  80214e:	41 5f                	pop    %r15
  802150:	5d                   	pop    %rbp
  802151:	c3                   	ret

0000000000802152 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802152:	f3 0f 1e fa          	endbr64
  802156:	55                   	push   %rbp
  802157:	48 89 e5             	mov    %rsp,%rbp
  80215a:	41 57                	push   %r15
  80215c:	41 56                	push   %r14
  80215e:	41 55                	push   %r13
  802160:	41 54                	push   %r12
  802162:	53                   	push   %rbx
  802163:	48 83 ec 18          	sub    $0x18,%rsp
  802167:	49 89 fc             	mov    %rdi,%r12
  80216a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80216e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802172:	48 b8 07 15 80 00 00 	movabs $0x801507,%rax
  802179:	00 00 00 
  80217c:	ff d0                	call   *%rax
  80217e:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802181:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802187:	49 bd fd 10 80 00 00 	movabs $0x8010fd,%r13
  80218e:	00 00 00 
            sys_yield();
  802191:	49 be 92 10 80 00 00 	movabs $0x801092,%r14
  802198:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80219b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8021a0:	74 7d                	je     80221f <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8021a2:	8b 03                	mov    (%rbx),%eax
  8021a4:	3b 43 04             	cmp    0x4(%rbx),%eax
  8021a7:	75 26                	jne    8021cf <devpipe_read+0x7d>
            if (i > 0) return i;
  8021a9:	4d 85 ff             	test   %r15,%r15
  8021ac:	75 77                	jne    802225 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021ae:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021b3:	48 89 da             	mov    %rbx,%rdx
  8021b6:	be 00 10 00 00       	mov    $0x1000,%esi
  8021bb:	4c 89 e7             	mov    %r12,%rdi
  8021be:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	74 72                	je     802237 <devpipe_read+0xe5>
            sys_yield();
  8021c5:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8021c8:	8b 03                	mov    (%rbx),%eax
  8021ca:	3b 43 04             	cmp    0x4(%rbx),%eax
  8021cd:	74 df                	je     8021ae <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021cf:	48 63 c8             	movslq %eax,%rcx
  8021d2:	48 89 ca             	mov    %rcx,%rdx
  8021d5:	48 c1 ea 03          	shr    $0x3,%rdx
  8021d9:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8021e0:	08 10 20 
  8021e3:	48 89 d0             	mov    %rdx,%rax
  8021e6:	48 f7 e6             	mul    %rsi
  8021e9:	48 c1 ea 06          	shr    $0x6,%rdx
  8021ed:	48 89 d0             	mov    %rdx,%rax
  8021f0:	48 c1 e0 09          	shl    $0x9,%rax
  8021f4:	48 29 d0             	sub    %rdx,%rax
  8021f7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8021fe:	00 
  8021ff:	48 89 c8             	mov    %rcx,%rax
  802202:	48 29 d0             	sub    %rdx,%rax
  802205:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80220a:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80220e:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802212:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802215:	49 83 c7 01          	add    $0x1,%r15
  802219:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80221d:	75 83                	jne    8021a2 <devpipe_read+0x50>
    return n;
  80221f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802223:	eb 03                	jmp    802228 <devpipe_read+0xd6>
            if (i > 0) return i;
  802225:	4c 89 f8             	mov    %r15,%rax
}
  802228:	48 83 c4 18          	add    $0x18,%rsp
  80222c:	5b                   	pop    %rbx
  80222d:	41 5c                	pop    %r12
  80222f:	41 5d                	pop    %r13
  802231:	41 5e                	pop    %r14
  802233:	41 5f                	pop    %r15
  802235:	5d                   	pop    %rbp
  802236:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802237:	b8 00 00 00 00       	mov    $0x0,%eax
  80223c:	eb ea                	jmp    802228 <devpipe_read+0xd6>

000000000080223e <pipe>:
pipe(int pfd[2]) {
  80223e:	f3 0f 1e fa          	endbr64
  802242:	55                   	push   %rbp
  802243:	48 89 e5             	mov    %rsp,%rbp
  802246:	41 55                	push   %r13
  802248:	41 54                	push   %r12
  80224a:	53                   	push   %rbx
  80224b:	48 83 ec 18          	sub    $0x18,%rsp
  80224f:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802252:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802256:	48 b8 27 15 80 00 00 	movabs $0x801527,%rax
  80225d:	00 00 00 
  802260:	ff d0                	call   *%rax
  802262:	89 c3                	mov    %eax,%ebx
  802264:	85 c0                	test   %eax,%eax
  802266:	0f 88 a0 01 00 00    	js     80240c <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80226c:	b9 46 00 00 00       	mov    $0x46,%ecx
  802271:	ba 00 10 00 00       	mov    $0x1000,%edx
  802276:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80227a:	bf 00 00 00 00       	mov    $0x0,%edi
  80227f:	48 b8 2d 11 80 00 00 	movabs $0x80112d,%rax
  802286:	00 00 00 
  802289:	ff d0                	call   *%rax
  80228b:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80228d:	85 c0                	test   %eax,%eax
  80228f:	0f 88 77 01 00 00    	js     80240c <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802295:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802299:	48 b8 27 15 80 00 00 	movabs $0x801527,%rax
  8022a0:	00 00 00 
  8022a3:	ff d0                	call   *%rax
  8022a5:	89 c3                	mov    %eax,%ebx
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	0f 88 43 01 00 00    	js     8023f2 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8022af:	b9 46 00 00 00       	mov    $0x46,%ecx
  8022b4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022b9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c2:	48 b8 2d 11 80 00 00 	movabs $0x80112d,%rax
  8022c9:	00 00 00 
  8022cc:	ff d0                	call   *%rax
  8022ce:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8022d0:	85 c0                	test   %eax,%eax
  8022d2:	0f 88 1a 01 00 00    	js     8023f2 <pipe+0x1b4>
    va = fd2data(fd0);
  8022d8:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022dc:	48 b8 07 15 80 00 00 	movabs $0x801507,%rax
  8022e3:	00 00 00 
  8022e6:	ff d0                	call   *%rax
  8022e8:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8022eb:	b9 46 00 00 00       	mov    $0x46,%ecx
  8022f0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022f5:	48 89 c6             	mov    %rax,%rsi
  8022f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8022fd:	48 b8 2d 11 80 00 00 	movabs $0x80112d,%rax
  802304:	00 00 00 
  802307:	ff d0                	call   *%rax
  802309:	89 c3                	mov    %eax,%ebx
  80230b:	85 c0                	test   %eax,%eax
  80230d:	0f 88 c5 00 00 00    	js     8023d8 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802313:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802317:	48 b8 07 15 80 00 00 	movabs $0x801507,%rax
  80231e:	00 00 00 
  802321:	ff d0                	call   *%rax
  802323:	48 89 c1             	mov    %rax,%rcx
  802326:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80232c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802332:	ba 00 00 00 00       	mov    $0x0,%edx
  802337:	4c 89 ee             	mov    %r13,%rsi
  80233a:	bf 00 00 00 00       	mov    $0x0,%edi
  80233f:	48 b8 98 11 80 00 00 	movabs $0x801198,%rax
  802346:	00 00 00 
  802349:	ff d0                	call   *%rax
  80234b:	89 c3                	mov    %eax,%ebx
  80234d:	85 c0                	test   %eax,%eax
  80234f:	78 6e                	js     8023bf <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802351:	be 00 10 00 00       	mov    $0x1000,%esi
  802356:	4c 89 ef             	mov    %r13,%rdi
  802359:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  802360:	00 00 00 
  802363:	ff d0                	call   *%rax
  802365:	83 f8 02             	cmp    $0x2,%eax
  802368:	0f 85 ab 00 00 00    	jne    802419 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  80236e:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802375:	00 00 
  802377:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80237b:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80237d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802381:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802388:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80238c:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80238e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802392:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802399:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80239d:	48 bb f1 14 80 00 00 	movabs $0x8014f1,%rbx
  8023a4:	00 00 00 
  8023a7:	ff d3                	call   *%rbx
  8023a9:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8023ad:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8023b1:	ff d3                	call   *%rbx
  8023b3:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8023b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023bd:	eb 4d                	jmp    80240c <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8023bf:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023c4:	4c 89 ee             	mov    %r13,%rsi
  8023c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8023cc:	48 b8 6d 12 80 00 00 	movabs $0x80126d,%rax
  8023d3:	00 00 00 
  8023d6:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8023d8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023dd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8023e6:	48 b8 6d 12 80 00 00 	movabs $0x80126d,%rax
  8023ed:	00 00 00 
  8023f0:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8023f2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023f7:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8023fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802400:	48 b8 6d 12 80 00 00 	movabs $0x80126d,%rax
  802407:	00 00 00 
  80240a:	ff d0                	call   *%rax
}
  80240c:	89 d8                	mov    %ebx,%eax
  80240e:	48 83 c4 18          	add    $0x18,%rsp
  802412:	5b                   	pop    %rbx
  802413:	41 5c                	pop    %r12
  802415:	41 5d                	pop    %r13
  802417:	5d                   	pop    %rbp
  802418:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802419:	48 b9 68 36 80 00 00 	movabs $0x803668,%rcx
  802420:	00 00 00 
  802423:	48 ba 1b 32 80 00 00 	movabs $0x80321b,%rdx
  80242a:	00 00 00 
  80242d:	be 2e 00 00 00       	mov    $0x2e,%esi
  802432:	48 bf 42 32 80 00 00 	movabs $0x803242,%rdi
  802439:	00 00 00 
  80243c:	b8 00 00 00 00       	mov    $0x0,%eax
  802441:	49 b8 58 2a 80 00 00 	movabs $0x802a58,%r8
  802448:	00 00 00 
  80244b:	41 ff d0             	call   *%r8

000000000080244e <pipeisclosed>:
pipeisclosed(int fdnum) {
  80244e:	f3 0f 1e fa          	endbr64
  802452:	55                   	push   %rbp
  802453:	48 89 e5             	mov    %rsp,%rbp
  802456:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80245a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80245e:	48 b8 8b 15 80 00 00 	movabs $0x80158b,%rax
  802465:	00 00 00 
  802468:	ff d0                	call   *%rax
    if (res < 0) return res;
  80246a:	85 c0                	test   %eax,%eax
  80246c:	78 35                	js     8024a3 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80246e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802472:	48 b8 07 15 80 00 00 	movabs $0x801507,%rax
  802479:	00 00 00 
  80247c:	ff d0                	call   *%rax
  80247e:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802481:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802486:	be 00 10 00 00       	mov    $0x1000,%esi
  80248b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80248f:	48 b8 fd 10 80 00 00 	movabs $0x8010fd,%rax
  802496:	00 00 00 
  802499:	ff d0                	call   *%rax
  80249b:	85 c0                	test   %eax,%eax
  80249d:	0f 94 c0             	sete   %al
  8024a0:	0f b6 c0             	movzbl %al,%eax
}
  8024a3:	c9                   	leave
  8024a4:	c3                   	ret

00000000008024a5 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8024a5:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8024a9:	48 89 f8             	mov    %rdi,%rax
  8024ac:	48 c1 e8 27          	shr    $0x27,%rax
  8024b0:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8024b7:	7f 00 00 
  8024ba:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024be:	f6 c2 01             	test   $0x1,%dl
  8024c1:	74 6d                	je     802530 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8024c3:	48 89 f8             	mov    %rdi,%rax
  8024c6:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024ca:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8024d1:	7f 00 00 
  8024d4:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024d8:	f6 c2 01             	test   $0x1,%dl
  8024db:	74 62                	je     80253f <get_uvpt_entry+0x9a>
  8024dd:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8024e4:	7f 00 00 
  8024e7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024eb:	f6 c2 80             	test   $0x80,%dl
  8024ee:	75 4f                	jne    80253f <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8024f0:	48 89 f8             	mov    %rdi,%rax
  8024f3:	48 c1 e8 15          	shr    $0x15,%rax
  8024f7:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8024fe:	7f 00 00 
  802501:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802505:	f6 c2 01             	test   $0x1,%dl
  802508:	74 44                	je     80254e <get_uvpt_entry+0xa9>
  80250a:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802511:	7f 00 00 
  802514:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802518:	f6 c2 80             	test   $0x80,%dl
  80251b:	75 31                	jne    80254e <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80251d:	48 c1 ef 0c          	shr    $0xc,%rdi
  802521:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802528:	7f 00 00 
  80252b:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80252f:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802530:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802537:	7f 00 00 
  80253a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80253e:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80253f:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802546:	7f 00 00 
  802549:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80254d:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80254e:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802555:	7f 00 00 
  802558:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80255c:	c3                   	ret

000000000080255d <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  80255d:	f3 0f 1e fa          	endbr64
  802561:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802564:	48 89 f9             	mov    %rdi,%rcx
  802567:	48 c1 e9 27          	shr    $0x27,%rcx
  80256b:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802572:	7f 00 00 
  802575:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802579:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802580:	f6 c1 01             	test   $0x1,%cl
  802583:	0f 84 b2 00 00 00    	je     80263b <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802589:	48 89 f9             	mov    %rdi,%rcx
  80258c:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802590:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802597:	7f 00 00 
  80259a:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80259e:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8025a5:	40 f6 c6 01          	test   $0x1,%sil
  8025a9:	0f 84 8c 00 00 00    	je     80263b <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8025af:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8025b6:	7f 00 00 
  8025b9:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8025bd:	a8 80                	test   $0x80,%al
  8025bf:	75 7b                	jne    80263c <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8025c1:	48 89 f9             	mov    %rdi,%rcx
  8025c4:	48 c1 e9 15          	shr    $0x15,%rcx
  8025c8:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8025cf:	7f 00 00 
  8025d2:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8025d6:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  8025dd:	40 f6 c6 01          	test   $0x1,%sil
  8025e1:	74 58                	je     80263b <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  8025e3:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8025ea:	7f 00 00 
  8025ed:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8025f1:	a8 80                	test   $0x80,%al
  8025f3:	75 6c                	jne    802661 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  8025f5:	48 89 f9             	mov    %rdi,%rcx
  8025f8:	48 c1 e9 0c          	shr    $0xc,%rcx
  8025fc:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802603:	7f 00 00 
  802606:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80260a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802611:	40 f6 c6 01          	test   $0x1,%sil
  802615:	74 24                	je     80263b <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802617:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80261e:	7f 00 00 
  802621:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802625:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80262c:	ff ff 7f 
  80262f:	48 21 c8             	and    %rcx,%rax
  802632:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802638:	48 09 d0             	or     %rdx,%rax
}
  80263b:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  80263c:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802643:	7f 00 00 
  802646:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80264a:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802651:	ff ff 7f 
  802654:	48 21 c8             	and    %rcx,%rax
  802657:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  80265d:	48 01 d0             	add    %rdx,%rax
  802660:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802661:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802668:	7f 00 00 
  80266b:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80266f:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802676:	ff ff 7f 
  802679:	48 21 c8             	and    %rcx,%rax
  80267c:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802682:	48 01 d0             	add    %rdx,%rax
  802685:	c3                   	ret

0000000000802686 <get_prot>:

int
get_prot(void *va) {
  802686:	f3 0f 1e fa          	endbr64
  80268a:	55                   	push   %rbp
  80268b:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80268e:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  802695:	00 00 00 
  802698:	ff d0                	call   *%rax
  80269a:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  80269d:	83 e0 01             	and    $0x1,%eax
  8026a0:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8026a3:	89 d1                	mov    %edx,%ecx
  8026a5:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8026ab:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8026ad:	89 c1                	mov    %eax,%ecx
  8026af:	83 c9 02             	or     $0x2,%ecx
  8026b2:	f6 c2 02             	test   $0x2,%dl
  8026b5:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8026b8:	89 c1                	mov    %eax,%ecx
  8026ba:	83 c9 01             	or     $0x1,%ecx
  8026bd:	48 85 d2             	test   %rdx,%rdx
  8026c0:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8026c3:	89 c1                	mov    %eax,%ecx
  8026c5:	83 c9 40             	or     $0x40,%ecx
  8026c8:	f6 c6 04             	test   $0x4,%dh
  8026cb:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8026ce:	5d                   	pop    %rbp
  8026cf:	c3                   	ret

00000000008026d0 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8026d0:	f3 0f 1e fa          	endbr64
  8026d4:	55                   	push   %rbp
  8026d5:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8026d8:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	call   *%rax
    return pte & PTE_D;
  8026e4:	48 c1 e8 06          	shr    $0x6,%rax
  8026e8:	83 e0 01             	and    $0x1,%eax
}
  8026eb:	5d                   	pop    %rbp
  8026ec:	c3                   	ret

00000000008026ed <is_page_present>:

bool
is_page_present(void *va) {
  8026ed:	f3 0f 1e fa          	endbr64
  8026f1:	55                   	push   %rbp
  8026f2:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8026f5:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  8026fc:	00 00 00 
  8026ff:	ff d0                	call   *%rax
  802701:	83 e0 01             	and    $0x1,%eax
}
  802704:	5d                   	pop    %rbp
  802705:	c3                   	ret

0000000000802706 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802706:	f3 0f 1e fa          	endbr64
  80270a:	55                   	push   %rbp
  80270b:	48 89 e5             	mov    %rsp,%rbp
  80270e:	41 57                	push   %r15
  802710:	41 56                	push   %r14
  802712:	41 55                	push   %r13
  802714:	41 54                	push   %r12
  802716:	53                   	push   %rbx
  802717:	48 83 ec 18          	sub    $0x18,%rsp
  80271b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80271f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802723:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802728:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  80272f:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802732:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802739:	7f 00 00 
    while (va < USER_STACK_TOP) {
  80273c:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802743:	00 00 00 
  802746:	eb 73                	jmp    8027bb <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802748:	48 89 d8             	mov    %rbx,%rax
  80274b:	48 c1 e8 15          	shr    $0x15,%rax
  80274f:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802756:	7f 00 00 
  802759:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  80275d:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802763:	f6 c2 01             	test   $0x1,%dl
  802766:	74 4b                	je     8027b3 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802768:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  80276c:	f6 c2 80             	test   $0x80,%dl
  80276f:	74 11                	je     802782 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802771:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802775:	f6 c4 04             	test   $0x4,%ah
  802778:	74 39                	je     8027b3 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  80277a:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802780:	eb 20                	jmp    8027a2 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802782:	48 89 da             	mov    %rbx,%rdx
  802785:	48 c1 ea 0c          	shr    $0xc,%rdx
  802789:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802790:	7f 00 00 
  802793:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802797:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80279d:	f6 c4 04             	test   $0x4,%ah
  8027a0:	74 11                	je     8027b3 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  8027a2:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  8027a6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8027aa:	48 89 df             	mov    %rbx,%rdi
  8027ad:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8027b1:	ff d0                	call   *%rax
    next:
        va += size;
  8027b3:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  8027b6:	49 39 df             	cmp    %rbx,%r15
  8027b9:	72 3e                	jb     8027f9 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8027bb:	49 8b 06             	mov    (%r14),%rax
  8027be:	a8 01                	test   $0x1,%al
  8027c0:	74 37                	je     8027f9 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8027c2:	48 89 d8             	mov    %rbx,%rax
  8027c5:	48 c1 e8 1e          	shr    $0x1e,%rax
  8027c9:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  8027ce:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8027d4:	f6 c2 01             	test   $0x1,%dl
  8027d7:	74 da                	je     8027b3 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  8027d9:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  8027de:	f6 c2 80             	test   $0x80,%dl
  8027e1:	0f 84 61 ff ff ff    	je     802748 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  8027e7:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8027ec:	f6 c4 04             	test   $0x4,%ah
  8027ef:	74 c2                	je     8027b3 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  8027f1:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  8027f7:	eb a9                	jmp    8027a2 <foreach_shared_region+0x9c>
    }
    return res;
}
  8027f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fe:	48 83 c4 18          	add    $0x18,%rsp
  802802:	5b                   	pop    %rbx
  802803:	41 5c                	pop    %r12
  802805:	41 5d                	pop    %r13
  802807:	41 5e                	pop    %r14
  802809:	41 5f                	pop    %r15
  80280b:	5d                   	pop    %rbp
  80280c:	c3                   	ret

000000000080280d <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  80280d:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802811:	b8 00 00 00 00       	mov    $0x0,%eax
  802816:	c3                   	ret

0000000000802817 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802817:	f3 0f 1e fa          	endbr64
  80281b:	55                   	push   %rbp
  80281c:	48 89 e5             	mov    %rsp,%rbp
  80281f:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802822:	48 be 52 32 80 00 00 	movabs $0x803252,%rsi
  802829:	00 00 00 
  80282c:	48 b8 28 0b 80 00 00 	movabs $0x800b28,%rax
  802833:	00 00 00 
  802836:	ff d0                	call   *%rax
    return 0;
}
  802838:	b8 00 00 00 00       	mov    $0x0,%eax
  80283d:	5d                   	pop    %rbp
  80283e:	c3                   	ret

000000000080283f <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80283f:	f3 0f 1e fa          	endbr64
  802843:	55                   	push   %rbp
  802844:	48 89 e5             	mov    %rsp,%rbp
  802847:	41 57                	push   %r15
  802849:	41 56                	push   %r14
  80284b:	41 55                	push   %r13
  80284d:	41 54                	push   %r12
  80284f:	53                   	push   %rbx
  802850:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802857:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  80285e:	48 85 d2             	test   %rdx,%rdx
  802861:	74 7a                	je     8028dd <devcons_write+0x9e>
  802863:	49 89 d6             	mov    %rdx,%r14
  802866:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80286c:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802871:	49 bf 43 0d 80 00 00 	movabs $0x800d43,%r15
  802878:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  80287b:	4c 89 f3             	mov    %r14,%rbx
  80287e:	48 29 f3             	sub    %rsi,%rbx
  802881:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802886:	48 39 c3             	cmp    %rax,%rbx
  802889:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  80288d:	4c 63 eb             	movslq %ebx,%r13
  802890:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802897:	48 01 c6             	add    %rax,%rsi
  80289a:	4c 89 ea             	mov    %r13,%rdx
  80289d:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8028a4:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8028a7:	4c 89 ee             	mov    %r13,%rsi
  8028aa:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8028b1:	48 b8 88 0f 80 00 00 	movabs $0x800f88,%rax
  8028b8:	00 00 00 
  8028bb:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8028bd:	41 01 dc             	add    %ebx,%r12d
  8028c0:	49 63 f4             	movslq %r12d,%rsi
  8028c3:	4c 39 f6             	cmp    %r14,%rsi
  8028c6:	72 b3                	jb     80287b <devcons_write+0x3c>
    return res;
  8028c8:	49 63 c4             	movslq %r12d,%rax
}
  8028cb:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8028d2:	5b                   	pop    %rbx
  8028d3:	41 5c                	pop    %r12
  8028d5:	41 5d                	pop    %r13
  8028d7:	41 5e                	pop    %r14
  8028d9:	41 5f                	pop    %r15
  8028db:	5d                   	pop    %rbp
  8028dc:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  8028dd:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8028e3:	eb e3                	jmp    8028c8 <devcons_write+0x89>

00000000008028e5 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8028e5:	f3 0f 1e fa          	endbr64
  8028e9:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8028ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8028f1:	48 85 c0             	test   %rax,%rax
  8028f4:	74 55                	je     80294b <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8028f6:	55                   	push   %rbp
  8028f7:	48 89 e5             	mov    %rsp,%rbp
  8028fa:	41 55                	push   %r13
  8028fc:	41 54                	push   %r12
  8028fe:	53                   	push   %rbx
  8028ff:	48 83 ec 08          	sub    $0x8,%rsp
  802903:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802906:	48 bb b9 0f 80 00 00 	movabs $0x800fb9,%rbx
  80290d:	00 00 00 
  802910:	49 bc 92 10 80 00 00 	movabs $0x801092,%r12
  802917:	00 00 00 
  80291a:	eb 03                	jmp    80291f <devcons_read+0x3a>
  80291c:	41 ff d4             	call   *%r12
  80291f:	ff d3                	call   *%rbx
  802921:	85 c0                	test   %eax,%eax
  802923:	74 f7                	je     80291c <devcons_read+0x37>
    if (c < 0) return c;
  802925:	48 63 d0             	movslq %eax,%rdx
  802928:	78 13                	js     80293d <devcons_read+0x58>
    if (c == 0x04) return 0;
  80292a:	ba 00 00 00 00       	mov    $0x0,%edx
  80292f:	83 f8 04             	cmp    $0x4,%eax
  802932:	74 09                	je     80293d <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802934:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802938:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80293d:	48 89 d0             	mov    %rdx,%rax
  802940:	48 83 c4 08          	add    $0x8,%rsp
  802944:	5b                   	pop    %rbx
  802945:	41 5c                	pop    %r12
  802947:	41 5d                	pop    %r13
  802949:	5d                   	pop    %rbp
  80294a:	c3                   	ret
  80294b:	48 89 d0             	mov    %rdx,%rax
  80294e:	c3                   	ret

000000000080294f <cputchar>:
cputchar(int ch) {
  80294f:	f3 0f 1e fa          	endbr64
  802953:	55                   	push   %rbp
  802954:	48 89 e5             	mov    %rsp,%rbp
  802957:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  80295b:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80295f:	be 01 00 00 00       	mov    $0x1,%esi
  802964:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802968:	48 b8 88 0f 80 00 00 	movabs $0x800f88,%rax
  80296f:	00 00 00 
  802972:	ff d0                	call   *%rax
}
  802974:	c9                   	leave
  802975:	c3                   	ret

0000000000802976 <getchar>:
getchar(void) {
  802976:	f3 0f 1e fa          	endbr64
  80297a:	55                   	push   %rbp
  80297b:	48 89 e5             	mov    %rsp,%rbp
  80297e:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802982:	ba 01 00 00 00       	mov    $0x1,%edx
  802987:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  80298b:	bf 00 00 00 00       	mov    $0x0,%edi
  802990:	48 b8 86 18 80 00 00 	movabs $0x801886,%rax
  802997:	00 00 00 
  80299a:	ff d0                	call   *%rax
  80299c:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	78 06                	js     8029a8 <getchar+0x32>
  8029a2:	74 08                	je     8029ac <getchar+0x36>
  8029a4:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8029a8:	89 d0                	mov    %edx,%eax
  8029aa:	c9                   	leave
  8029ab:	c3                   	ret
    return res < 0 ? res : res ? c :
  8029ac:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8029b1:	eb f5                	jmp    8029a8 <getchar+0x32>

00000000008029b3 <iscons>:
iscons(int fdnum) {
  8029b3:	f3 0f 1e fa          	endbr64
  8029b7:	55                   	push   %rbp
  8029b8:	48 89 e5             	mov    %rsp,%rbp
  8029bb:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8029bf:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8029c3:	48 b8 8b 15 80 00 00 	movabs $0x80158b,%rax
  8029ca:	00 00 00 
  8029cd:	ff d0                	call   *%rax
    if (res < 0) return res;
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	78 18                	js     8029eb <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  8029d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029d7:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8029de:	00 00 00 
  8029e1:	8b 00                	mov    (%rax),%eax
  8029e3:	39 02                	cmp    %eax,(%rdx)
  8029e5:	0f 94 c0             	sete   %al
  8029e8:	0f b6 c0             	movzbl %al,%eax
}
  8029eb:	c9                   	leave
  8029ec:	c3                   	ret

00000000008029ed <opencons>:
opencons(void) {
  8029ed:	f3 0f 1e fa          	endbr64
  8029f1:	55                   	push   %rbp
  8029f2:	48 89 e5             	mov    %rsp,%rbp
  8029f5:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8029f9:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8029fd:	48 b8 27 15 80 00 00 	movabs $0x801527,%rax
  802a04:	00 00 00 
  802a07:	ff d0                	call   *%rax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	78 49                	js     802a56 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802a0d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802a12:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a17:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802a1b:	bf 00 00 00 00       	mov    $0x0,%edi
  802a20:	48 b8 2d 11 80 00 00 	movabs $0x80112d,%rax
  802a27:	00 00 00 
  802a2a:	ff d0                	call   *%rax
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	78 26                	js     802a56 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802a30:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a34:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802a3b:	00 00 
  802a3d:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802a3f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802a43:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802a4a:	48 b8 f1 14 80 00 00 	movabs $0x8014f1,%rax
  802a51:	00 00 00 
  802a54:	ff d0                	call   *%rax
}
  802a56:	c9                   	leave
  802a57:	c3                   	ret

0000000000802a58 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802a58:	f3 0f 1e fa          	endbr64
  802a5c:	55                   	push   %rbp
  802a5d:	48 89 e5             	mov    %rsp,%rbp
  802a60:	41 56                	push   %r14
  802a62:	41 55                	push   %r13
  802a64:	41 54                	push   %r12
  802a66:	53                   	push   %rbx
  802a67:	48 83 ec 50          	sub    $0x50,%rsp
  802a6b:	49 89 fc             	mov    %rdi,%r12
  802a6e:	41 89 f5             	mov    %esi,%r13d
  802a71:	48 89 d3             	mov    %rdx,%rbx
  802a74:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802a78:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802a7c:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802a80:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802a87:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a8b:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802a8f:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802a93:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802a97:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802a9e:	00 00 00 
  802aa1:	4c 8b 30             	mov    (%rax),%r14
  802aa4:	48 b8 5d 10 80 00 00 	movabs $0x80105d,%rax
  802aab:	00 00 00 
  802aae:	ff d0                	call   *%rax
  802ab0:	89 c6                	mov    %eax,%esi
  802ab2:	45 89 e8             	mov    %r13d,%r8d
  802ab5:	4c 89 e1             	mov    %r12,%rcx
  802ab8:	4c 89 f2             	mov    %r14,%rdx
  802abb:	48 bf 90 36 80 00 00 	movabs $0x803690,%rdi
  802ac2:	00 00 00 
  802ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  802aca:	49 bc df 01 80 00 00 	movabs $0x8001df,%r12
  802ad1:	00 00 00 
  802ad4:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802ad7:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802adb:	48 89 df             	mov    %rbx,%rdi
  802ade:	48 b8 77 01 80 00 00 	movabs $0x800177,%rax
  802ae5:	00 00 00 
  802ae8:	ff d0                	call   *%rax
    cprintf("\n");
  802aea:	48 bf 1c 30 80 00 00 	movabs $0x80301c,%rdi
  802af1:	00 00 00 
  802af4:	b8 00 00 00 00       	mov    $0x0,%eax
  802af9:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802afc:	cc                   	int3
  802afd:	eb fd                	jmp    802afc <_panic+0xa4>

0000000000802aff <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802aff:	f3 0f 1e fa          	endbr64
  802b03:	55                   	push   %rbp
  802b04:	48 89 e5             	mov    %rsp,%rbp
  802b07:	41 54                	push   %r12
  802b09:	53                   	push   %rbx
  802b0a:	48 89 fb             	mov    %rdi,%rbx
  802b0d:	48 89 f7             	mov    %rsi,%rdi
  802b10:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b13:	48 85 f6             	test   %rsi,%rsi
  802b16:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b1d:	00 00 00 
  802b20:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b24:	be 00 10 00 00       	mov    $0x1000,%esi
  802b29:	48 b8 4f 14 80 00 00 	movabs $0x80144f,%rax
  802b30:	00 00 00 
  802b33:	ff d0                	call   *%rax
    if (res < 0) {
  802b35:	85 c0                	test   %eax,%eax
  802b37:	78 45                	js     802b7e <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b39:	48 85 db             	test   %rbx,%rbx
  802b3c:	74 12                	je     802b50 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b3e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b45:	00 00 00 
  802b48:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b4e:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b50:	4d 85 e4             	test   %r12,%r12
  802b53:	74 14                	je     802b69 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b55:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b5c:	00 00 00 
  802b5f:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b65:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b69:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b70:	00 00 00 
  802b73:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b79:	5b                   	pop    %rbx
  802b7a:	41 5c                	pop    %r12
  802b7c:	5d                   	pop    %rbp
  802b7d:	c3                   	ret
        if (from_env_store != NULL) {
  802b7e:	48 85 db             	test   %rbx,%rbx
  802b81:	74 06                	je     802b89 <ipc_recv+0x8a>
            *from_env_store = 0;
  802b83:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b89:	4d 85 e4             	test   %r12,%r12
  802b8c:	74 eb                	je     802b79 <ipc_recv+0x7a>
            *perm_store = 0;
  802b8e:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b95:	00 
  802b96:	eb e1                	jmp    802b79 <ipc_recv+0x7a>

0000000000802b98 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b98:	f3 0f 1e fa          	endbr64
  802b9c:	55                   	push   %rbp
  802b9d:	48 89 e5             	mov    %rsp,%rbp
  802ba0:	41 57                	push   %r15
  802ba2:	41 56                	push   %r14
  802ba4:	41 55                	push   %r13
  802ba6:	41 54                	push   %r12
  802ba8:	53                   	push   %rbx
  802ba9:	48 83 ec 18          	sub    $0x18,%rsp
  802bad:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802bb0:	48 89 d3             	mov    %rdx,%rbx
  802bb3:	49 89 cc             	mov    %rcx,%r12
  802bb6:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802bb9:	48 85 d2             	test   %rdx,%rdx
  802bbc:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bc3:	00 00 00 
  802bc6:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bca:	89 f0                	mov    %esi,%eax
  802bcc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802bd0:	48 89 da             	mov    %rbx,%rdx
  802bd3:	48 89 c6             	mov    %rax,%rsi
  802bd6:	48 b8 1f 14 80 00 00 	movabs $0x80141f,%rax
  802bdd:	00 00 00 
  802be0:	ff d0                	call   *%rax
    while (res < 0) {
  802be2:	85 c0                	test   %eax,%eax
  802be4:	79 65                	jns    802c4b <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802be6:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802be9:	75 33                	jne    802c1e <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802beb:	49 bf 92 10 80 00 00 	movabs $0x801092,%r15
  802bf2:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bf5:	49 be 1f 14 80 00 00 	movabs $0x80141f,%r14
  802bfc:	00 00 00 
        sys_yield();
  802bff:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c02:	45 89 e8             	mov    %r13d,%r8d
  802c05:	4c 89 e1             	mov    %r12,%rcx
  802c08:	48 89 da             	mov    %rbx,%rdx
  802c0b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802c0f:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802c12:	41 ff d6             	call   *%r14
    while (res < 0) {
  802c15:	85 c0                	test   %eax,%eax
  802c17:	79 32                	jns    802c4b <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c19:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c1c:	74 e1                	je     802bff <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c1e:	89 c1                	mov    %eax,%ecx
  802c20:	48 ba 5e 32 80 00 00 	movabs $0x80325e,%rdx
  802c27:	00 00 00 
  802c2a:	be 42 00 00 00       	mov    $0x42,%esi
  802c2f:	48 bf 69 32 80 00 00 	movabs $0x803269,%rdi
  802c36:	00 00 00 
  802c39:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3e:	49 b8 58 2a 80 00 00 	movabs $0x802a58,%r8
  802c45:	00 00 00 
  802c48:	41 ff d0             	call   *%r8
    }
}
  802c4b:	48 83 c4 18          	add    $0x18,%rsp
  802c4f:	5b                   	pop    %rbx
  802c50:	41 5c                	pop    %r12
  802c52:	41 5d                	pop    %r13
  802c54:	41 5e                	pop    %r14
  802c56:	41 5f                	pop    %r15
  802c58:	5d                   	pop    %rbp
  802c59:	c3                   	ret

0000000000802c5a <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c5a:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c5e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c63:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c6a:	00 00 00 
  802c6d:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c71:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c75:	48 c1 e2 04          	shl    $0x4,%rdx
  802c79:	48 01 ca             	add    %rcx,%rdx
  802c7c:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c82:	39 fa                	cmp    %edi,%edx
  802c84:	74 12                	je     802c98 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c86:	48 83 c0 01          	add    $0x1,%rax
  802c8a:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c90:	75 db                	jne    802c6d <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802c92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c97:	c3                   	ret
            return envs[i].env_id;
  802c98:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c9c:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802ca0:	48 c1 e2 04          	shl    $0x4,%rdx
  802ca4:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802cab:	00 00 00 
  802cae:	48 01 d0             	add    %rdx,%rax
  802cb1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cb7:	c3                   	ret

0000000000802cb8 <__text_end>:
  802cb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cbf:	00 00 00 
  802cc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cc9:	00 00 00 
  802ccc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cd3:	00 00 00 
  802cd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cdd:	00 00 00 
  802ce0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ce7:	00 00 00 
  802cea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cf1:	00 00 00 
  802cf4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cfb:	00 00 00 
  802cfe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d05:	00 00 00 
  802d08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d0f:	00 00 00 
  802d12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d19:	00 00 00 
  802d1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d23:	00 00 00 
  802d26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d2d:	00 00 00 
  802d30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d37:	00 00 00 
  802d3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d41:	00 00 00 
  802d44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d4b:	00 00 00 
  802d4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d55:	00 00 00 
  802d58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d5f:	00 00 00 
  802d62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d69:	00 00 00 
  802d6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d73:	00 00 00 
  802d76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d7d:	00 00 00 
  802d80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d87:	00 00 00 
  802d8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d91:	00 00 00 
  802d94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d9b:	00 00 00 
  802d9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802da5:	00 00 00 
  802da8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802daf:	00 00 00 
  802db2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802db9:	00 00 00 
  802dbc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dc3:	00 00 00 
  802dc6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dcd:	00 00 00 
  802dd0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd7:	00 00 00 
  802dda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de1:	00 00 00 
  802de4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802deb:	00 00 00 
  802dee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df5:	00 00 00 
  802df8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dff:	00 00 00 
  802e02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e09:	00 00 00 
  802e0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e13:	00 00 00 
  802e16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e1d:	00 00 00 
  802e20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e27:	00 00 00 
  802e2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e31:	00 00 00 
  802e34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e3b:	00 00 00 
  802e3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e45:	00 00 00 
  802e48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e4f:	00 00 00 
  802e52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e59:	00 00 00 
  802e5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e63:	00 00 00 
  802e66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e6d:	00 00 00 
  802e70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e77:	00 00 00 
  802e7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e81:	00 00 00 
  802e84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e8b:	00 00 00 
  802e8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e95:	00 00 00 
  802e98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e9f:	00 00 00 
  802ea2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea9:	00 00 00 
  802eac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb3:	00 00 00 
  802eb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ebd:	00 00 00 
  802ec0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec7:	00 00 00 
  802eca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed1:	00 00 00 
  802ed4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802edb:	00 00 00 
  802ede:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee5:	00 00 00 
  802ee8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eef:	00 00 00 
  802ef2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef9:	00 00 00 
  802efc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f03:	00 00 00 
  802f06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f0d:	00 00 00 
  802f10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f17:	00 00 00 
  802f1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f21:	00 00 00 
  802f24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f2b:	00 00 00 
  802f2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f35:	00 00 00 
  802f38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f3f:	00 00 00 
  802f42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f49:	00 00 00 
  802f4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f53:	00 00 00 
  802f56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f5d:	00 00 00 
  802f60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f67:	00 00 00 
  802f6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f71:	00 00 00 
  802f74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f7b:	00 00 00 
  802f7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f85:	00 00 00 
  802f88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f8f:	00 00 00 
  802f92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f99:	00 00 00 
  802f9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa3:	00 00 00 
  802fa6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fad:	00 00 00 
  802fb0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb7:	00 00 00 
  802fba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc1:	00 00 00 
  802fc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fcb:	00 00 00 
  802fce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd5:	00 00 00 
  802fd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fdf:	00 00 00 
  802fe2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe9:	00 00 00 
  802fec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff3:	00 00 00 
  802ff6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ffd:	00 00 00 
