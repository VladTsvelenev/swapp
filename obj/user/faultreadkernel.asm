
obj/user/faultreadkernel:     file format elf64-x86-64


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
  80001e:	e8 33 00 00 00       	call   800056 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* Buggy program - faults with a read from kernel space */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
    cprintf("I read %08x from location 0x8040000000!\n", *(unsigned *)0x8040000000);
  80002d:	48 b8 00 00 00 40 80 	movabs $0x8040000000,%rax
  800034:	00 00 00 
  800037:	8b 30                	mov    (%rax),%esi
  800039:	48 bf 00 30 80 00 00 	movabs $0x803000,%rdi
  800040:	00 00 00 
  800043:	b8 00 00 00 00       	mov    $0x0,%eax
  800048:	48 ba e4 01 80 00 00 	movabs $0x8001e4,%rdx
  80004f:	00 00 00 
  800052:	ff d2                	call   *%rdx
}
  800054:	5d                   	pop    %rbp
  800055:	c3                   	ret

0000000000800056 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800056:	f3 0f 1e fa          	endbr64
  80005a:	55                   	push   %rbp
  80005b:	48 89 e5             	mov    %rsp,%rbp
  80005e:	41 56                	push   %r14
  800060:	41 55                	push   %r13
  800062:	41 54                	push   %r12
  800064:	53                   	push   %rbx
  800065:	41 89 fd             	mov    %edi,%r13d
  800068:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80006b:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800072:	00 00 00 
  800075:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80007c:	00 00 00 
  80007f:	48 39 c2             	cmp    %rax,%rdx
  800082:	73 17                	jae    80009b <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800084:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800087:	49 89 c4             	mov    %rax,%r12
  80008a:	48 83 c3 08          	add    $0x8,%rbx
  80008e:	b8 00 00 00 00       	mov    $0x0,%eax
  800093:	ff 53 f8             	call   *-0x8(%rbx)
  800096:	4c 39 e3             	cmp    %r12,%rbx
  800099:	72 ef                	jb     80008a <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  80009b:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	call   *%rax
  8000a7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ac:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000b0:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000b4:	48 c1 e0 04          	shl    $0x4,%rax
  8000b8:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000bf:	00 00 00 
  8000c2:	48 01 d0             	add    %rdx,%rax
  8000c5:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000cc:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000cf:	45 85 ed             	test   %r13d,%r13d
  8000d2:	7e 0d                	jle    8000e1 <libmain+0x8b>
  8000d4:	49 8b 06             	mov    (%r14),%rax
  8000d7:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000de:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000e1:	4c 89 f6             	mov    %r14,%rsi
  8000e4:	44 89 ef             	mov    %r13d,%edi
  8000e7:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000f3:	48 b8 08 01 80 00 00 	movabs $0x800108,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	call   *%rax
#endif
}
  8000ff:	5b                   	pop    %rbx
  800100:	41 5c                	pop    %r12
  800102:	41 5d                	pop    %r13
  800104:	41 5e                	pop    %r14
  800106:	5d                   	pop    %rbp
  800107:	c3                   	ret

0000000000800108 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800108:	f3 0f 1e fa          	endbr64
  80010c:	55                   	push   %rbp
  80010d:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800110:	48 b8 38 17 80 00 00 	movabs $0x801738,%rax
  800117:	00 00 00 
  80011a:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80011c:	bf 00 00 00 00       	mov    $0x0,%edi
  800121:	48 b8 f3 0f 80 00 00 	movabs $0x800ff3,%rax
  800128:	00 00 00 
  80012b:	ff d0                	call   *%rax
}
  80012d:	5d                   	pop    %rbp
  80012e:	c3                   	ret

000000000080012f <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80012f:	f3 0f 1e fa          	endbr64
  800133:	55                   	push   %rbp
  800134:	48 89 e5             	mov    %rsp,%rbp
  800137:	53                   	push   %rbx
  800138:	48 83 ec 08          	sub    $0x8,%rsp
  80013c:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80013f:	8b 06                	mov    (%rsi),%eax
  800141:	8d 50 01             	lea    0x1(%rax),%edx
  800144:	89 16                	mov    %edx,(%rsi)
  800146:	48 98                	cltq
  800148:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80014d:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800153:	74 0a                	je     80015f <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800155:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800159:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80015d:	c9                   	leave
  80015e:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80015f:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800163:	be ff 00 00 00       	mov    $0xff,%esi
  800168:	48 b8 8d 0f 80 00 00 	movabs $0x800f8d,%rax
  80016f:	00 00 00 
  800172:	ff d0                	call   *%rax
        state->offset = 0;
  800174:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80017a:	eb d9                	jmp    800155 <putch+0x26>

000000000080017c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80017c:	f3 0f 1e fa          	endbr64
  800180:	55                   	push   %rbp
  800181:	48 89 e5             	mov    %rsp,%rbp
  800184:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80018b:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80018e:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800195:	b9 21 00 00 00       	mov    $0x21,%ecx
  80019a:	b8 00 00 00 00       	mov    $0x0,%eax
  80019f:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8001a2:	48 89 f1             	mov    %rsi,%rcx
  8001a5:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8001ac:	48 bf 2f 01 80 00 00 	movabs $0x80012f,%rdi
  8001b3:	00 00 00 
  8001b6:	48 b8 44 03 80 00 00 	movabs $0x800344,%rax
  8001bd:	00 00 00 
  8001c0:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8001c2:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8001c9:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8001d0:	48 b8 8d 0f 80 00 00 	movabs $0x800f8d,%rax
  8001d7:	00 00 00 
  8001da:	ff d0                	call   *%rax

    return state.count;
}
  8001dc:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8001e2:	c9                   	leave
  8001e3:	c3                   	ret

00000000008001e4 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8001e4:	f3 0f 1e fa          	endbr64
  8001e8:	55                   	push   %rbp
  8001e9:	48 89 e5             	mov    %rsp,%rbp
  8001ec:	48 83 ec 50          	sub    $0x50,%rsp
  8001f0:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8001f4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8001f8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8001fc:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800200:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800204:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80020b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80020f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800213:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800217:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80021b:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80021f:	48 b8 7c 01 80 00 00 	movabs $0x80017c,%rax
  800226:	00 00 00 
  800229:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80022b:	c9                   	leave
  80022c:	c3                   	ret

000000000080022d <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80022d:	f3 0f 1e fa          	endbr64
  800231:	55                   	push   %rbp
  800232:	48 89 e5             	mov    %rsp,%rbp
  800235:	41 57                	push   %r15
  800237:	41 56                	push   %r14
  800239:	41 55                	push   %r13
  80023b:	41 54                	push   %r12
  80023d:	53                   	push   %rbx
  80023e:	48 83 ec 18          	sub    $0x18,%rsp
  800242:	49 89 fc             	mov    %rdi,%r12
  800245:	49 89 f5             	mov    %rsi,%r13
  800248:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80024c:	8b 45 10             	mov    0x10(%rbp),%eax
  80024f:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800252:	41 89 cf             	mov    %ecx,%r15d
  800255:	4c 39 fa             	cmp    %r15,%rdx
  800258:	73 5b                	jae    8002b5 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80025a:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80025e:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800262:	85 db                	test   %ebx,%ebx
  800264:	7e 0e                	jle    800274 <print_num+0x47>
            putch(padc, put_arg);
  800266:	4c 89 ee             	mov    %r13,%rsi
  800269:	44 89 f7             	mov    %r14d,%edi
  80026c:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80026f:	83 eb 01             	sub    $0x1,%ebx
  800272:	75 f2                	jne    800266 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800274:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800278:	48 b9 1e 31 80 00 00 	movabs $0x80311e,%rcx
  80027f:	00 00 00 
  800282:	48 b8 0d 31 80 00 00 	movabs $0x80310d,%rax
  800289:	00 00 00 
  80028c:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800290:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800294:	ba 00 00 00 00       	mov    $0x0,%edx
  800299:	49 f7 f7             	div    %r15
  80029c:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8002a0:	4c 89 ee             	mov    %r13,%rsi
  8002a3:	41 ff d4             	call   *%r12
}
  8002a6:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8002aa:	5b                   	pop    %rbx
  8002ab:	41 5c                	pop    %r12
  8002ad:	41 5d                	pop    %r13
  8002af:	41 5e                	pop    %r14
  8002b1:	41 5f                	pop    %r15
  8002b3:	5d                   	pop    %rbp
  8002b4:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8002b5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002be:	49 f7 f7             	div    %r15
  8002c1:	48 83 ec 08          	sub    $0x8,%rsp
  8002c5:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8002c9:	52                   	push   %rdx
  8002ca:	45 0f be c9          	movsbl %r9b,%r9d
  8002ce:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8002d2:	48 89 c2             	mov    %rax,%rdx
  8002d5:	48 b8 2d 02 80 00 00 	movabs $0x80022d,%rax
  8002dc:	00 00 00 
  8002df:	ff d0                	call   *%rax
  8002e1:	48 83 c4 10          	add    $0x10,%rsp
  8002e5:	eb 8d                	jmp    800274 <print_num+0x47>

00000000008002e7 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8002e7:	f3 0f 1e fa          	endbr64
    state->count++;
  8002eb:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8002ef:	48 8b 06             	mov    (%rsi),%rax
  8002f2:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8002f6:	73 0a                	jae    800302 <sprintputch+0x1b>
        *state->start++ = ch;
  8002f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8002fc:	48 89 16             	mov    %rdx,(%rsi)
  8002ff:	40 88 38             	mov    %dil,(%rax)
    }
}
  800302:	c3                   	ret

0000000000800303 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800303:	f3 0f 1e fa          	endbr64
  800307:	55                   	push   %rbp
  800308:	48 89 e5             	mov    %rsp,%rbp
  80030b:	48 83 ec 50          	sub    $0x50,%rsp
  80030f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800313:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800317:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80031b:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800322:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800326:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80032a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80032e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800332:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800336:	48 b8 44 03 80 00 00 	movabs $0x800344,%rax
  80033d:	00 00 00 
  800340:	ff d0                	call   *%rax
}
  800342:	c9                   	leave
  800343:	c3                   	ret

0000000000800344 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800344:	f3 0f 1e fa          	endbr64
  800348:	55                   	push   %rbp
  800349:	48 89 e5             	mov    %rsp,%rbp
  80034c:	41 57                	push   %r15
  80034e:	41 56                	push   %r14
  800350:	41 55                	push   %r13
  800352:	41 54                	push   %r12
  800354:	53                   	push   %rbx
  800355:	48 83 ec 38          	sub    $0x38,%rsp
  800359:	49 89 fe             	mov    %rdi,%r14
  80035c:	49 89 f5             	mov    %rsi,%r13
  80035f:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800362:	48 8b 01             	mov    (%rcx),%rax
  800365:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800369:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80036d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800371:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800375:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800379:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80037d:	0f b6 3b             	movzbl (%rbx),%edi
  800380:	40 80 ff 25          	cmp    $0x25,%dil
  800384:	74 18                	je     80039e <vprintfmt+0x5a>
            if (!ch) return;
  800386:	40 84 ff             	test   %dil,%dil
  800389:	0f 84 b2 06 00 00    	je     800a41 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80038f:	40 0f b6 ff          	movzbl %dil,%edi
  800393:	4c 89 ee             	mov    %r13,%rsi
  800396:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800399:	4c 89 e3             	mov    %r12,%rbx
  80039c:	eb db                	jmp    800379 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  80039e:	be 00 00 00 00       	mov    $0x0,%esi
  8003a3:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8003a7:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8003ac:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8003b2:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8003b9:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8003bd:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8003c2:	41 0f b6 04 24       	movzbl (%r12),%eax
  8003c7:	88 45 a0             	mov    %al,-0x60(%rbp)
  8003ca:	83 e8 23             	sub    $0x23,%eax
  8003cd:	3c 57                	cmp    $0x57,%al
  8003cf:	0f 87 52 06 00 00    	ja     800a27 <vprintfmt+0x6e3>
  8003d5:	0f b6 c0             	movzbl %al,%eax
  8003d8:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  8003df:	00 00 00 
  8003e2:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8003e6:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8003e9:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8003ed:	eb ce                	jmp    8003bd <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8003ef:	49 89 dc             	mov    %rbx,%r12
  8003f2:	be 01 00 00 00       	mov    $0x1,%esi
  8003f7:	eb c4                	jmp    8003bd <vprintfmt+0x79>
            padc = ch;
  8003f9:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8003fd:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800400:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800403:	eb b8                	jmp    8003bd <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800405:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800408:	83 f8 2f             	cmp    $0x2f,%eax
  80040b:	77 24                	ja     800431 <vprintfmt+0xed>
  80040d:	89 c1                	mov    %eax,%ecx
  80040f:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800413:	83 c0 08             	add    $0x8,%eax
  800416:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800419:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  80041c:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  80041f:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800423:	79 98                	jns    8003bd <vprintfmt+0x79>
                width = precision;
  800425:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800429:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80042f:	eb 8c                	jmp    8003bd <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800431:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800435:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800439:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80043d:	eb da                	jmp    800419 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80043f:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800444:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800448:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80044e:	3c 39                	cmp    $0x39,%al
  800450:	77 1c                	ja     80046e <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800452:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800456:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80045a:	0f b6 c0             	movzbl %al,%eax
  80045d:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800462:	0f b6 03             	movzbl (%rbx),%eax
  800465:	3c 39                	cmp    $0x39,%al
  800467:	76 e9                	jbe    800452 <vprintfmt+0x10e>
        process_precision:
  800469:	49 89 dc             	mov    %rbx,%r12
  80046c:	eb b1                	jmp    80041f <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80046e:	49 89 dc             	mov    %rbx,%r12
  800471:	eb ac                	jmp    80041f <vprintfmt+0xdb>
            width = MAX(0, width);
  800473:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800476:	85 c9                	test   %ecx,%ecx
  800478:	b8 00 00 00 00       	mov    $0x0,%eax
  80047d:	0f 49 c1             	cmovns %ecx,%eax
  800480:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800483:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800486:	e9 32 ff ff ff       	jmp    8003bd <vprintfmt+0x79>
            lflag++;
  80048b:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80048e:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800491:	e9 27 ff ff ff       	jmp    8003bd <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800496:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800499:	83 f8 2f             	cmp    $0x2f,%eax
  80049c:	77 19                	ja     8004b7 <vprintfmt+0x173>
  80049e:	89 c2                	mov    %eax,%edx
  8004a0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8004a4:	83 c0 08             	add    $0x8,%eax
  8004a7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004aa:	8b 3a                	mov    (%rdx),%edi
  8004ac:	4c 89 ee             	mov    %r13,%rsi
  8004af:	41 ff d6             	call   *%r14
            break;
  8004b2:	e9 c2 fe ff ff       	jmp    800379 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8004b7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004bb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8004bf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004c3:	eb e5                	jmp    8004aa <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8004c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004c8:	83 f8 2f             	cmp    $0x2f,%eax
  8004cb:	77 5a                	ja     800527 <vprintfmt+0x1e3>
  8004cd:	89 c2                	mov    %eax,%edx
  8004cf:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8004d3:	83 c0 08             	add    $0x8,%eax
  8004d6:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8004d9:	8b 02                	mov    (%rdx),%eax
  8004db:	89 c1                	mov    %eax,%ecx
  8004dd:	f7 d9                	neg    %ecx
  8004df:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8004e2:	83 f9 13             	cmp    $0x13,%ecx
  8004e5:	7f 4e                	jg     800535 <vprintfmt+0x1f1>
  8004e7:	48 63 c1             	movslq %ecx,%rax
  8004ea:	48 ba 20 36 80 00 00 	movabs $0x803620,%rdx
  8004f1:	00 00 00 
  8004f4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8004f8:	48 85 c0             	test   %rax,%rax
  8004fb:	74 38                	je     800535 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8004fd:	48 89 c1             	mov    %rax,%rcx
  800500:	48 ba 12 33 80 00 00 	movabs $0x803312,%rdx
  800507:	00 00 00 
  80050a:	4c 89 ee             	mov    %r13,%rsi
  80050d:	4c 89 f7             	mov    %r14,%rdi
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	49 b8 03 03 80 00 00 	movabs $0x800303,%r8
  80051c:	00 00 00 
  80051f:	41 ff d0             	call   *%r8
  800522:	e9 52 fe ff ff       	jmp    800379 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800527:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80052b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80052f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800533:	eb a4                	jmp    8004d9 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800535:	48 ba 36 31 80 00 00 	movabs $0x803136,%rdx
  80053c:	00 00 00 
  80053f:	4c 89 ee             	mov    %r13,%rsi
  800542:	4c 89 f7             	mov    %r14,%rdi
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	49 b8 03 03 80 00 00 	movabs $0x800303,%r8
  800551:	00 00 00 
  800554:	41 ff d0             	call   *%r8
  800557:	e9 1d fe ff ff       	jmp    800379 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80055c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80055f:	83 f8 2f             	cmp    $0x2f,%eax
  800562:	77 6c                	ja     8005d0 <vprintfmt+0x28c>
  800564:	89 c2                	mov    %eax,%edx
  800566:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80056a:	83 c0 08             	add    $0x8,%eax
  80056d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800570:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800573:	48 85 d2             	test   %rdx,%rdx
  800576:	48 b8 2f 31 80 00 00 	movabs $0x80312f,%rax
  80057d:	00 00 00 
  800580:	48 0f 45 c2          	cmovne %rdx,%rax
  800584:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800588:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80058c:	7e 06                	jle    800594 <vprintfmt+0x250>
  80058e:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800592:	75 4a                	jne    8005de <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800594:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800598:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80059c:	0f b6 00             	movzbl (%rax),%eax
  80059f:	84 c0                	test   %al,%al
  8005a1:	0f 85 9a 00 00 00    	jne    800641 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8005a7:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005aa:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8005ae:	85 c0                	test   %eax,%eax
  8005b0:	0f 8e c3 fd ff ff    	jle    800379 <vprintfmt+0x35>
  8005b6:	4c 89 ee             	mov    %r13,%rsi
  8005b9:	bf 20 00 00 00       	mov    $0x20,%edi
  8005be:	41 ff d6             	call   *%r14
  8005c1:	41 83 ec 01          	sub    $0x1,%r12d
  8005c5:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8005c9:	75 eb                	jne    8005b6 <vprintfmt+0x272>
  8005cb:	e9 a9 fd ff ff       	jmp    800379 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8005d0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005d4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005d8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005dc:	eb 92                	jmp    800570 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8005de:	49 63 f7             	movslq %r15d,%rsi
  8005e1:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8005e5:	48 b8 07 0b 80 00 00 	movabs $0x800b07,%rax
  8005ec:	00 00 00 
  8005ef:	ff d0                	call   *%rax
  8005f1:	48 89 c2             	mov    %rax,%rdx
  8005f4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005f7:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8005f9:	8d 70 ff             	lea    -0x1(%rax),%esi
  8005fc:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8005ff:	85 c0                	test   %eax,%eax
  800601:	7e 91                	jle    800594 <vprintfmt+0x250>
  800603:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800608:	4c 89 ee             	mov    %r13,%rsi
  80060b:	44 89 e7             	mov    %r12d,%edi
  80060e:	41 ff d6             	call   *%r14
  800611:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800615:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800618:	83 f8 ff             	cmp    $0xffffffff,%eax
  80061b:	75 eb                	jne    800608 <vprintfmt+0x2c4>
  80061d:	e9 72 ff ff ff       	jmp    800594 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800622:	0f b6 f8             	movzbl %al,%edi
  800625:	4c 89 ee             	mov    %r13,%rsi
  800628:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80062b:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80062f:	49 83 c4 01          	add    $0x1,%r12
  800633:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800639:	84 c0                	test   %al,%al
  80063b:	0f 84 66 ff ff ff    	je     8005a7 <vprintfmt+0x263>
  800641:	45 85 ff             	test   %r15d,%r15d
  800644:	78 0a                	js     800650 <vprintfmt+0x30c>
  800646:	41 83 ef 01          	sub    $0x1,%r15d
  80064a:	0f 88 57 ff ff ff    	js     8005a7 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800650:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800654:	74 cc                	je     800622 <vprintfmt+0x2de>
  800656:	8d 50 e0             	lea    -0x20(%rax),%edx
  800659:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80065e:	80 fa 5e             	cmp    $0x5e,%dl
  800661:	77 c2                	ja     800625 <vprintfmt+0x2e1>
  800663:	eb bd                	jmp    800622 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800665:	40 84 f6             	test   %sil,%sil
  800668:	75 26                	jne    800690 <vprintfmt+0x34c>
    switch (lflag) {
  80066a:	85 d2                	test   %edx,%edx
  80066c:	74 59                	je     8006c7 <vprintfmt+0x383>
  80066e:	83 fa 01             	cmp    $0x1,%edx
  800671:	74 7b                	je     8006ee <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800673:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800676:	83 f8 2f             	cmp    $0x2f,%eax
  800679:	0f 87 96 00 00 00    	ja     800715 <vprintfmt+0x3d1>
  80067f:	89 c2                	mov    %eax,%edx
  800681:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800685:	83 c0 08             	add    $0x8,%eax
  800688:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80068b:	4c 8b 22             	mov    (%rdx),%r12
  80068e:	eb 17                	jmp    8006a7 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800690:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800693:	83 f8 2f             	cmp    $0x2f,%eax
  800696:	77 21                	ja     8006b9 <vprintfmt+0x375>
  800698:	89 c2                	mov    %eax,%edx
  80069a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80069e:	83 c0 08             	add    $0x8,%eax
  8006a1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006a4:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8006a7:	4d 85 e4             	test   %r12,%r12
  8006aa:	78 7a                	js     800726 <vprintfmt+0x3e2>
            num = i;
  8006ac:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8006af:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006b4:	e9 50 02 00 00       	jmp    800909 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8006b9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006bd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006c1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006c5:	eb dd                	jmp    8006a4 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8006c7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006ca:	83 f8 2f             	cmp    $0x2f,%eax
  8006cd:	77 11                	ja     8006e0 <vprintfmt+0x39c>
  8006cf:	89 c2                	mov    %eax,%edx
  8006d1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006d5:	83 c0 08             	add    $0x8,%eax
  8006d8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006db:	4c 63 22             	movslq (%rdx),%r12
  8006de:	eb c7                	jmp    8006a7 <vprintfmt+0x363>
  8006e0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006e4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006e8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006ec:	eb ed                	jmp    8006db <vprintfmt+0x397>
        return va_arg(*ap, long);
  8006ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006f1:	83 f8 2f             	cmp    $0x2f,%eax
  8006f4:	77 11                	ja     800707 <vprintfmt+0x3c3>
  8006f6:	89 c2                	mov    %eax,%edx
  8006f8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006fc:	83 c0 08             	add    $0x8,%eax
  8006ff:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800702:	4c 8b 22             	mov    (%rdx),%r12
  800705:	eb a0                	jmp    8006a7 <vprintfmt+0x363>
  800707:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80070b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80070f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800713:	eb ed                	jmp    800702 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800715:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800719:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80071d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800721:	e9 65 ff ff ff       	jmp    80068b <vprintfmt+0x347>
                putch('-', put_arg);
  800726:	4c 89 ee             	mov    %r13,%rsi
  800729:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80072e:	41 ff d6             	call   *%r14
                i = -i;
  800731:	49 f7 dc             	neg    %r12
  800734:	e9 73 ff ff ff       	jmp    8006ac <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800739:	40 84 f6             	test   %sil,%sil
  80073c:	75 32                	jne    800770 <vprintfmt+0x42c>
    switch (lflag) {
  80073e:	85 d2                	test   %edx,%edx
  800740:	74 5d                	je     80079f <vprintfmt+0x45b>
  800742:	83 fa 01             	cmp    $0x1,%edx
  800745:	0f 84 82 00 00 00    	je     8007cd <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  80074b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80074e:	83 f8 2f             	cmp    $0x2f,%eax
  800751:	0f 87 a5 00 00 00    	ja     8007fc <vprintfmt+0x4b8>
  800757:	89 c2                	mov    %eax,%edx
  800759:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80075d:	83 c0 08             	add    $0x8,%eax
  800760:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800763:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800766:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80076b:	e9 99 01 00 00       	jmp    800909 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800770:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800773:	83 f8 2f             	cmp    $0x2f,%eax
  800776:	77 19                	ja     800791 <vprintfmt+0x44d>
  800778:	89 c2                	mov    %eax,%edx
  80077a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80077e:	83 c0 08             	add    $0x8,%eax
  800781:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800784:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800787:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80078c:	e9 78 01 00 00       	jmp    800909 <vprintfmt+0x5c5>
  800791:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800795:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800799:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80079d:	eb e5                	jmp    800784 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  80079f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a2:	83 f8 2f             	cmp    $0x2f,%eax
  8007a5:	77 18                	ja     8007bf <vprintfmt+0x47b>
  8007a7:	89 c2                	mov    %eax,%edx
  8007a9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007ad:	83 c0 08             	add    $0x8,%eax
  8007b0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007b3:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8007b5:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8007ba:	e9 4a 01 00 00       	jmp    800909 <vprintfmt+0x5c5>
  8007bf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007c3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007c7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007cb:	eb e6                	jmp    8007b3 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8007cd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d0:	83 f8 2f             	cmp    $0x2f,%eax
  8007d3:	77 19                	ja     8007ee <vprintfmt+0x4aa>
  8007d5:	89 c2                	mov    %eax,%edx
  8007d7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007db:	83 c0 08             	add    $0x8,%eax
  8007de:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007e1:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8007e4:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8007e9:	e9 1b 01 00 00       	jmp    800909 <vprintfmt+0x5c5>
  8007ee:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007f2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007f6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007fa:	eb e5                	jmp    8007e1 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  8007fc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800800:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800804:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800808:	e9 56 ff ff ff       	jmp    800763 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  80080d:	40 84 f6             	test   %sil,%sil
  800810:	75 2e                	jne    800840 <vprintfmt+0x4fc>
    switch (lflag) {
  800812:	85 d2                	test   %edx,%edx
  800814:	74 59                	je     80086f <vprintfmt+0x52b>
  800816:	83 fa 01             	cmp    $0x1,%edx
  800819:	74 7f                	je     80089a <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  80081b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80081e:	83 f8 2f             	cmp    $0x2f,%eax
  800821:	0f 87 9f 00 00 00    	ja     8008c6 <vprintfmt+0x582>
  800827:	89 c2                	mov    %eax,%edx
  800829:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80082d:	83 c0 08             	add    $0x8,%eax
  800830:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800833:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800836:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80083b:	e9 c9 00 00 00       	jmp    800909 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800840:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800843:	83 f8 2f             	cmp    $0x2f,%eax
  800846:	77 19                	ja     800861 <vprintfmt+0x51d>
  800848:	89 c2                	mov    %eax,%edx
  80084a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80084e:	83 c0 08             	add    $0x8,%eax
  800851:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800854:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800857:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80085c:	e9 a8 00 00 00       	jmp    800909 <vprintfmt+0x5c5>
  800861:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800865:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800869:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80086d:	eb e5                	jmp    800854 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  80086f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800872:	83 f8 2f             	cmp    $0x2f,%eax
  800875:	77 15                	ja     80088c <vprintfmt+0x548>
  800877:	89 c2                	mov    %eax,%edx
  800879:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80087d:	83 c0 08             	add    $0x8,%eax
  800880:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800883:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800885:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80088a:	eb 7d                	jmp    800909 <vprintfmt+0x5c5>
  80088c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800890:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800894:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800898:	eb e9                	jmp    800883 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  80089a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089d:	83 f8 2f             	cmp    $0x2f,%eax
  8008a0:	77 16                	ja     8008b8 <vprintfmt+0x574>
  8008a2:	89 c2                	mov    %eax,%edx
  8008a4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008a8:	83 c0 08             	add    $0x8,%eax
  8008ab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008ae:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8008b1:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008b6:	eb 51                	jmp    800909 <vprintfmt+0x5c5>
  8008b8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008bc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008c0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008c4:	eb e8                	jmp    8008ae <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8008c6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008ca:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008ce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008d2:	e9 5c ff ff ff       	jmp    800833 <vprintfmt+0x4ef>
            putch('0', put_arg);
  8008d7:	4c 89 ee             	mov    %r13,%rsi
  8008da:	bf 30 00 00 00       	mov    $0x30,%edi
  8008df:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  8008e2:	4c 89 ee             	mov    %r13,%rsi
  8008e5:	bf 78 00 00 00       	mov    $0x78,%edi
  8008ea:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  8008ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f0:	83 f8 2f             	cmp    $0x2f,%eax
  8008f3:	77 47                	ja     80093c <vprintfmt+0x5f8>
  8008f5:	89 c2                	mov    %eax,%edx
  8008f7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008fb:	83 c0 08             	add    $0x8,%eax
  8008fe:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800901:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800904:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800909:	48 83 ec 08          	sub    $0x8,%rsp
  80090d:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800911:	0f 94 c0             	sete   %al
  800914:	0f b6 c0             	movzbl %al,%eax
  800917:	50                   	push   %rax
  800918:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  80091d:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800921:	4c 89 ee             	mov    %r13,%rsi
  800924:	4c 89 f7             	mov    %r14,%rdi
  800927:	48 b8 2d 02 80 00 00 	movabs $0x80022d,%rax
  80092e:	00 00 00 
  800931:	ff d0                	call   *%rax
            break;
  800933:	48 83 c4 10          	add    $0x10,%rsp
  800937:	e9 3d fa ff ff       	jmp    800379 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  80093c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800940:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800944:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800948:	eb b7                	jmp    800901 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  80094a:	40 84 f6             	test   %sil,%sil
  80094d:	75 2b                	jne    80097a <vprintfmt+0x636>
    switch (lflag) {
  80094f:	85 d2                	test   %edx,%edx
  800951:	74 56                	je     8009a9 <vprintfmt+0x665>
  800953:	83 fa 01             	cmp    $0x1,%edx
  800956:	74 7f                	je     8009d7 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800958:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095b:	83 f8 2f             	cmp    $0x2f,%eax
  80095e:	0f 87 a2 00 00 00    	ja     800a06 <vprintfmt+0x6c2>
  800964:	89 c2                	mov    %eax,%edx
  800966:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80096a:	83 c0 08             	add    $0x8,%eax
  80096d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800970:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800973:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800978:	eb 8f                	jmp    800909 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80097a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097d:	83 f8 2f             	cmp    $0x2f,%eax
  800980:	77 19                	ja     80099b <vprintfmt+0x657>
  800982:	89 c2                	mov    %eax,%edx
  800984:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800988:	83 c0 08             	add    $0x8,%eax
  80098b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80098e:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800991:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800996:	e9 6e ff ff ff       	jmp    800909 <vprintfmt+0x5c5>
  80099b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80099f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009a3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009a7:	eb e5                	jmp    80098e <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8009a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ac:	83 f8 2f             	cmp    $0x2f,%eax
  8009af:	77 18                	ja     8009c9 <vprintfmt+0x685>
  8009b1:	89 c2                	mov    %eax,%edx
  8009b3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009b7:	83 c0 08             	add    $0x8,%eax
  8009ba:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009bd:	8b 12                	mov    (%rdx),%edx
            base = 16;
  8009bf:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8009c4:	e9 40 ff ff ff       	jmp    800909 <vprintfmt+0x5c5>
  8009c9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009cd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009d1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009d5:	eb e6                	jmp    8009bd <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  8009d7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009da:	83 f8 2f             	cmp    $0x2f,%eax
  8009dd:	77 19                	ja     8009f8 <vprintfmt+0x6b4>
  8009df:	89 c2                	mov    %eax,%edx
  8009e1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009e5:	83 c0 08             	add    $0x8,%eax
  8009e8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009eb:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009ee:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8009f3:	e9 11 ff ff ff       	jmp    800909 <vprintfmt+0x5c5>
  8009f8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009fc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a00:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a04:	eb e5                	jmp    8009eb <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800a06:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a0a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a0e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a12:	e9 59 ff ff ff       	jmp    800970 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800a17:	4c 89 ee             	mov    %r13,%rsi
  800a1a:	bf 25 00 00 00       	mov    $0x25,%edi
  800a1f:	41 ff d6             	call   *%r14
            break;
  800a22:	e9 52 f9 ff ff       	jmp    800379 <vprintfmt+0x35>
            putch('%', put_arg);
  800a27:	4c 89 ee             	mov    %r13,%rsi
  800a2a:	bf 25 00 00 00       	mov    $0x25,%edi
  800a2f:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800a32:	48 83 eb 01          	sub    $0x1,%rbx
  800a36:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800a3a:	75 f6                	jne    800a32 <vprintfmt+0x6ee>
  800a3c:	e9 38 f9 ff ff       	jmp    800379 <vprintfmt+0x35>
}
  800a41:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a45:	5b                   	pop    %rbx
  800a46:	41 5c                	pop    %r12
  800a48:	41 5d                	pop    %r13
  800a4a:	41 5e                	pop    %r14
  800a4c:	41 5f                	pop    %r15
  800a4e:	5d                   	pop    %rbp
  800a4f:	c3                   	ret

0000000000800a50 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a50:	f3 0f 1e fa          	endbr64
  800a54:	55                   	push   %rbp
  800a55:	48 89 e5             	mov    %rsp,%rbp
  800a58:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800a5c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a60:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800a65:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800a69:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800a70:	48 85 ff             	test   %rdi,%rdi
  800a73:	74 2b                	je     800aa0 <vsnprintf+0x50>
  800a75:	48 85 f6             	test   %rsi,%rsi
  800a78:	74 26                	je     800aa0 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800a7a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800a7e:	48 bf e7 02 80 00 00 	movabs $0x8002e7,%rdi
  800a85:	00 00 00 
  800a88:	48 b8 44 03 80 00 00 	movabs $0x800344,%rax
  800a8f:	00 00 00 
  800a92:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a98:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800a9b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800a9e:	c9                   	leave
  800a9f:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800aa0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aa5:	eb f7                	jmp    800a9e <vsnprintf+0x4e>

0000000000800aa7 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800aa7:	f3 0f 1e fa          	endbr64
  800aab:	55                   	push   %rbp
  800aac:	48 89 e5             	mov    %rsp,%rbp
  800aaf:	48 83 ec 50          	sub    $0x50,%rsp
  800ab3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800ab7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800abb:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800abf:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800ac6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800aca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ace:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ad2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800ad6:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ada:	48 b8 50 0a 80 00 00 	movabs $0x800a50,%rax
  800ae1:	00 00 00 
  800ae4:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800ae6:	c9                   	leave
  800ae7:	c3                   	ret

0000000000800ae8 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800ae8:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800aec:	80 3f 00             	cmpb   $0x0,(%rdi)
  800aef:	74 10                	je     800b01 <strlen+0x19>
    size_t n = 0;
  800af1:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800af6:	48 83 c0 01          	add    $0x1,%rax
  800afa:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800afe:	75 f6                	jne    800af6 <strlen+0xe>
  800b00:	c3                   	ret
    size_t n = 0;
  800b01:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800b06:	c3                   	ret

0000000000800b07 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800b07:	f3 0f 1e fa          	endbr64
  800b0b:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800b0e:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800b13:	48 85 f6             	test   %rsi,%rsi
  800b16:	74 10                	je     800b28 <strnlen+0x21>
  800b18:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800b1c:	74 0b                	je     800b29 <strnlen+0x22>
  800b1e:	48 83 c2 01          	add    $0x1,%rdx
  800b22:	48 39 d0             	cmp    %rdx,%rax
  800b25:	75 f1                	jne    800b18 <strnlen+0x11>
  800b27:	c3                   	ret
  800b28:	c3                   	ret
  800b29:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800b2c:	c3                   	ret

0000000000800b2d <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800b2d:	f3 0f 1e fa          	endbr64
  800b31:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b34:	ba 00 00 00 00       	mov    $0x0,%edx
  800b39:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800b3d:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800b40:	48 83 c2 01          	add    $0x1,%rdx
  800b44:	84 c9                	test   %cl,%cl
  800b46:	75 f1                	jne    800b39 <strcpy+0xc>
        ;
    return res;
}
  800b48:	c3                   	ret

0000000000800b49 <strcat>:

char *
strcat(char *dst, const char *src) {
  800b49:	f3 0f 1e fa          	endbr64
  800b4d:	55                   	push   %rbp
  800b4e:	48 89 e5             	mov    %rsp,%rbp
  800b51:	41 54                	push   %r12
  800b53:	53                   	push   %rbx
  800b54:	48 89 fb             	mov    %rdi,%rbx
  800b57:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800b5a:	48 b8 e8 0a 80 00 00 	movabs $0x800ae8,%rax
  800b61:	00 00 00 
  800b64:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800b66:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800b6a:	4c 89 e6             	mov    %r12,%rsi
  800b6d:	48 b8 2d 0b 80 00 00 	movabs $0x800b2d,%rax
  800b74:	00 00 00 
  800b77:	ff d0                	call   *%rax
    return dst;
}
  800b79:	48 89 d8             	mov    %rbx,%rax
  800b7c:	5b                   	pop    %rbx
  800b7d:	41 5c                	pop    %r12
  800b7f:	5d                   	pop    %rbp
  800b80:	c3                   	ret

0000000000800b81 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b81:	f3 0f 1e fa          	endbr64
  800b85:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800b88:	48 85 d2             	test   %rdx,%rdx
  800b8b:	74 1f                	je     800bac <strncpy+0x2b>
  800b8d:	48 01 fa             	add    %rdi,%rdx
  800b90:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800b93:	48 83 c1 01          	add    $0x1,%rcx
  800b97:	44 0f b6 06          	movzbl (%rsi),%r8d
  800b9b:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800b9f:	41 80 f8 01          	cmp    $0x1,%r8b
  800ba3:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800ba7:	48 39 ca             	cmp    %rcx,%rdx
  800baa:	75 e7                	jne    800b93 <strncpy+0x12>
    }
    return ret;
}
  800bac:	c3                   	ret

0000000000800bad <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800bad:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800bb1:	48 89 f8             	mov    %rdi,%rax
  800bb4:	48 85 d2             	test   %rdx,%rdx
  800bb7:	74 24                	je     800bdd <strlcpy+0x30>
        while (--size > 0 && *src)
  800bb9:	48 83 ea 01          	sub    $0x1,%rdx
  800bbd:	74 1b                	je     800bda <strlcpy+0x2d>
  800bbf:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800bc3:	0f b6 16             	movzbl (%rsi),%edx
  800bc6:	84 d2                	test   %dl,%dl
  800bc8:	74 10                	je     800bda <strlcpy+0x2d>
            *dst++ = *src++;
  800bca:	48 83 c6 01          	add    $0x1,%rsi
  800bce:	48 83 c0 01          	add    $0x1,%rax
  800bd2:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800bd5:	48 39 c8             	cmp    %rcx,%rax
  800bd8:	75 e9                	jne    800bc3 <strlcpy+0x16>
        *dst = '\0';
  800bda:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800bdd:	48 29 f8             	sub    %rdi,%rax
}
  800be0:	c3                   	ret

0000000000800be1 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800be1:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800be5:	0f b6 07             	movzbl (%rdi),%eax
  800be8:	84 c0                	test   %al,%al
  800bea:	74 13                	je     800bff <strcmp+0x1e>
  800bec:	38 06                	cmp    %al,(%rsi)
  800bee:	75 0f                	jne    800bff <strcmp+0x1e>
  800bf0:	48 83 c7 01          	add    $0x1,%rdi
  800bf4:	48 83 c6 01          	add    $0x1,%rsi
  800bf8:	0f b6 07             	movzbl (%rdi),%eax
  800bfb:	84 c0                	test   %al,%al
  800bfd:	75 ed                	jne    800bec <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800bff:	0f b6 c0             	movzbl %al,%eax
  800c02:	0f b6 16             	movzbl (%rsi),%edx
  800c05:	29 d0                	sub    %edx,%eax
}
  800c07:	c3                   	ret

0000000000800c08 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800c08:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800c0c:	48 85 d2             	test   %rdx,%rdx
  800c0f:	74 1f                	je     800c30 <strncmp+0x28>
  800c11:	0f b6 07             	movzbl (%rdi),%eax
  800c14:	84 c0                	test   %al,%al
  800c16:	74 1e                	je     800c36 <strncmp+0x2e>
  800c18:	3a 06                	cmp    (%rsi),%al
  800c1a:	75 1a                	jne    800c36 <strncmp+0x2e>
  800c1c:	48 83 c7 01          	add    $0x1,%rdi
  800c20:	48 83 c6 01          	add    $0x1,%rsi
  800c24:	48 83 ea 01          	sub    $0x1,%rdx
  800c28:	75 e7                	jne    800c11 <strncmp+0x9>

    if (!n) return 0;
  800c2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2f:	c3                   	ret
  800c30:	b8 00 00 00 00       	mov    $0x0,%eax
  800c35:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c36:	0f b6 07             	movzbl (%rdi),%eax
  800c39:	0f b6 16             	movzbl (%rsi),%edx
  800c3c:	29 d0                	sub    %edx,%eax
}
  800c3e:	c3                   	ret

0000000000800c3f <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800c3f:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800c43:	0f b6 17             	movzbl (%rdi),%edx
  800c46:	84 d2                	test   %dl,%dl
  800c48:	74 18                	je     800c62 <strchr+0x23>
        if (*str == c) {
  800c4a:	0f be d2             	movsbl %dl,%edx
  800c4d:	39 f2                	cmp    %esi,%edx
  800c4f:	74 17                	je     800c68 <strchr+0x29>
    for (; *str; str++) {
  800c51:	48 83 c7 01          	add    $0x1,%rdi
  800c55:	0f b6 17             	movzbl (%rdi),%edx
  800c58:	84 d2                	test   %dl,%dl
  800c5a:	75 ee                	jne    800c4a <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c61:	c3                   	ret
  800c62:	b8 00 00 00 00       	mov    $0x0,%eax
  800c67:	c3                   	ret
            return (char *)str;
  800c68:	48 89 f8             	mov    %rdi,%rax
}
  800c6b:	c3                   	ret

0000000000800c6c <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800c6c:	f3 0f 1e fa          	endbr64
  800c70:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800c73:	0f b6 17             	movzbl (%rdi),%edx
  800c76:	84 d2                	test   %dl,%dl
  800c78:	74 13                	je     800c8d <strfind+0x21>
  800c7a:	0f be d2             	movsbl %dl,%edx
  800c7d:	39 f2                	cmp    %esi,%edx
  800c7f:	74 0b                	je     800c8c <strfind+0x20>
  800c81:	48 83 c0 01          	add    $0x1,%rax
  800c85:	0f b6 10             	movzbl (%rax),%edx
  800c88:	84 d2                	test   %dl,%dl
  800c8a:	75 ee                	jne    800c7a <strfind+0xe>
        ;
    return (char *)str;
}
  800c8c:	c3                   	ret
  800c8d:	c3                   	ret

0000000000800c8e <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800c8e:	f3 0f 1e fa          	endbr64
  800c92:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800c95:	48 89 f8             	mov    %rdi,%rax
  800c98:	48 f7 d8             	neg    %rax
  800c9b:	83 e0 07             	and    $0x7,%eax
  800c9e:	49 89 d1             	mov    %rdx,%r9
  800ca1:	49 29 c1             	sub    %rax,%r9
  800ca4:	78 36                	js     800cdc <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800ca6:	40 0f b6 c6          	movzbl %sil,%eax
  800caa:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800cb1:	01 01 01 
  800cb4:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800cb8:	40 f6 c7 07          	test   $0x7,%dil
  800cbc:	75 38                	jne    800cf6 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800cbe:	4c 89 c9             	mov    %r9,%rcx
  800cc1:	48 c1 f9 03          	sar    $0x3,%rcx
  800cc5:	74 0c                	je     800cd3 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800cc7:	fc                   	cld
  800cc8:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800ccb:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800ccf:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800cd3:	4d 85 c9             	test   %r9,%r9
  800cd6:	75 45                	jne    800d1d <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800cd8:	4c 89 c0             	mov    %r8,%rax
  800cdb:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800cdc:	48 85 d2             	test   %rdx,%rdx
  800cdf:	74 f7                	je     800cd8 <memset+0x4a>
  800ce1:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800ce4:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800ce7:	48 83 c0 01          	add    $0x1,%rax
  800ceb:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800cef:	48 39 c2             	cmp    %rax,%rdx
  800cf2:	75 f3                	jne    800ce7 <memset+0x59>
  800cf4:	eb e2                	jmp    800cd8 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800cf6:	40 f6 c7 01          	test   $0x1,%dil
  800cfa:	74 06                	je     800d02 <memset+0x74>
  800cfc:	88 07                	mov    %al,(%rdi)
  800cfe:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d02:	40 f6 c7 02          	test   $0x2,%dil
  800d06:	74 07                	je     800d0f <memset+0x81>
  800d08:	66 89 07             	mov    %ax,(%rdi)
  800d0b:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d0f:	40 f6 c7 04          	test   $0x4,%dil
  800d13:	74 a9                	je     800cbe <memset+0x30>
  800d15:	89 07                	mov    %eax,(%rdi)
  800d17:	48 83 c7 04          	add    $0x4,%rdi
  800d1b:	eb a1                	jmp    800cbe <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d1d:	41 f6 c1 04          	test   $0x4,%r9b
  800d21:	74 1b                	je     800d3e <memset+0xb0>
  800d23:	89 07                	mov    %eax,(%rdi)
  800d25:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d29:	41 f6 c1 02          	test   $0x2,%r9b
  800d2d:	74 07                	je     800d36 <memset+0xa8>
  800d2f:	66 89 07             	mov    %ax,(%rdi)
  800d32:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d36:	41 f6 c1 01          	test   $0x1,%r9b
  800d3a:	74 9c                	je     800cd8 <memset+0x4a>
  800d3c:	eb 06                	jmp    800d44 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d3e:	41 f6 c1 02          	test   $0x2,%r9b
  800d42:	75 eb                	jne    800d2f <memset+0xa1>
        if (ni & 1) *ptr = k;
  800d44:	88 07                	mov    %al,(%rdi)
  800d46:	eb 90                	jmp    800cd8 <memset+0x4a>

0000000000800d48 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d48:	f3 0f 1e fa          	endbr64
  800d4c:	48 89 f8             	mov    %rdi,%rax
  800d4f:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d52:	48 39 fe             	cmp    %rdi,%rsi
  800d55:	73 3b                	jae    800d92 <memmove+0x4a>
  800d57:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800d5b:	48 39 d7             	cmp    %rdx,%rdi
  800d5e:	73 32                	jae    800d92 <memmove+0x4a>
        s += n;
        d += n;
  800d60:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d64:	48 89 d6             	mov    %rdx,%rsi
  800d67:	48 09 fe             	or     %rdi,%rsi
  800d6a:	48 09 ce             	or     %rcx,%rsi
  800d6d:	40 f6 c6 07          	test   $0x7,%sil
  800d71:	75 12                	jne    800d85 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800d73:	48 83 ef 08          	sub    $0x8,%rdi
  800d77:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800d7b:	48 c1 e9 03          	shr    $0x3,%rcx
  800d7f:	fd                   	std
  800d80:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800d83:	fc                   	cld
  800d84:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800d85:	48 83 ef 01          	sub    $0x1,%rdi
  800d89:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800d8d:	fd                   	std
  800d8e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800d90:	eb f1                	jmp    800d83 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d92:	48 89 f2             	mov    %rsi,%rdx
  800d95:	48 09 c2             	or     %rax,%rdx
  800d98:	48 09 ca             	or     %rcx,%rdx
  800d9b:	f6 c2 07             	test   $0x7,%dl
  800d9e:	75 0c                	jne    800dac <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800da0:	48 c1 e9 03          	shr    $0x3,%rcx
  800da4:	48 89 c7             	mov    %rax,%rdi
  800da7:	fc                   	cld
  800da8:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800dab:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800dac:	48 89 c7             	mov    %rax,%rdi
  800daf:	fc                   	cld
  800db0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800db2:	c3                   	ret

0000000000800db3 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800db3:	f3 0f 1e fa          	endbr64
  800db7:	55                   	push   %rbp
  800db8:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800dbb:	48 b8 48 0d 80 00 00 	movabs $0x800d48,%rax
  800dc2:	00 00 00 
  800dc5:	ff d0                	call   *%rax
}
  800dc7:	5d                   	pop    %rbp
  800dc8:	c3                   	ret

0000000000800dc9 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800dc9:	f3 0f 1e fa          	endbr64
  800dcd:	55                   	push   %rbp
  800dce:	48 89 e5             	mov    %rsp,%rbp
  800dd1:	41 57                	push   %r15
  800dd3:	41 56                	push   %r14
  800dd5:	41 55                	push   %r13
  800dd7:	41 54                	push   %r12
  800dd9:	53                   	push   %rbx
  800dda:	48 83 ec 08          	sub    $0x8,%rsp
  800dde:	49 89 fe             	mov    %rdi,%r14
  800de1:	49 89 f7             	mov    %rsi,%r15
  800de4:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800de7:	48 89 f7             	mov    %rsi,%rdi
  800dea:	48 b8 e8 0a 80 00 00 	movabs $0x800ae8,%rax
  800df1:	00 00 00 
  800df4:	ff d0                	call   *%rax
  800df6:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800df9:	48 89 de             	mov    %rbx,%rsi
  800dfc:	4c 89 f7             	mov    %r14,%rdi
  800dff:	48 b8 07 0b 80 00 00 	movabs $0x800b07,%rax
  800e06:	00 00 00 
  800e09:	ff d0                	call   *%rax
  800e0b:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800e0e:	48 39 c3             	cmp    %rax,%rbx
  800e11:	74 36                	je     800e49 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800e13:	48 89 d8             	mov    %rbx,%rax
  800e16:	4c 29 e8             	sub    %r13,%rax
  800e19:	49 39 c4             	cmp    %rax,%r12
  800e1c:	73 31                	jae    800e4f <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800e1e:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800e23:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e27:	4c 89 fe             	mov    %r15,%rsi
  800e2a:	48 b8 b3 0d 80 00 00 	movabs $0x800db3,%rax
  800e31:	00 00 00 
  800e34:	ff d0                	call   *%rax
    return dstlen + srclen;
  800e36:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800e3a:	48 83 c4 08          	add    $0x8,%rsp
  800e3e:	5b                   	pop    %rbx
  800e3f:	41 5c                	pop    %r12
  800e41:	41 5d                	pop    %r13
  800e43:	41 5e                	pop    %r14
  800e45:	41 5f                	pop    %r15
  800e47:	5d                   	pop    %rbp
  800e48:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800e49:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800e4d:	eb eb                	jmp    800e3a <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e4f:	48 83 eb 01          	sub    $0x1,%rbx
  800e53:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e57:	48 89 da             	mov    %rbx,%rdx
  800e5a:	4c 89 fe             	mov    %r15,%rsi
  800e5d:	48 b8 b3 0d 80 00 00 	movabs $0x800db3,%rax
  800e64:	00 00 00 
  800e67:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800e69:	49 01 de             	add    %rbx,%r14
  800e6c:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800e71:	eb c3                	jmp    800e36 <strlcat+0x6d>

0000000000800e73 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800e73:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800e77:	48 85 d2             	test   %rdx,%rdx
  800e7a:	74 2d                	je     800ea9 <memcmp+0x36>
  800e7c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800e81:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800e85:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800e8a:	44 38 c1             	cmp    %r8b,%cl
  800e8d:	75 0f                	jne    800e9e <memcmp+0x2b>
    while (n-- > 0) {
  800e8f:	48 83 c0 01          	add    $0x1,%rax
  800e93:	48 39 c2             	cmp    %rax,%rdx
  800e96:	75 e9                	jne    800e81 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800e98:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9d:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800e9e:	0f b6 c1             	movzbl %cl,%eax
  800ea1:	45 0f b6 c0          	movzbl %r8b,%r8d
  800ea5:	44 29 c0             	sub    %r8d,%eax
  800ea8:	c3                   	ret
    return 0;
  800ea9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eae:	c3                   	ret

0000000000800eaf <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800eaf:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800eb3:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800eb7:	48 39 c7             	cmp    %rax,%rdi
  800eba:	73 0f                	jae    800ecb <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800ebc:	40 38 37             	cmp    %sil,(%rdi)
  800ebf:	74 0e                	je     800ecf <memfind+0x20>
    for (; src < end; src++) {
  800ec1:	48 83 c7 01          	add    $0x1,%rdi
  800ec5:	48 39 f8             	cmp    %rdi,%rax
  800ec8:	75 f2                	jne    800ebc <memfind+0xd>
  800eca:	c3                   	ret
  800ecb:	48 89 f8             	mov    %rdi,%rax
  800ece:	c3                   	ret
  800ecf:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800ed2:	c3                   	ret

0000000000800ed3 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800ed3:	f3 0f 1e fa          	endbr64
  800ed7:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800eda:	0f b6 37             	movzbl (%rdi),%esi
  800edd:	40 80 fe 20          	cmp    $0x20,%sil
  800ee1:	74 06                	je     800ee9 <strtol+0x16>
  800ee3:	40 80 fe 09          	cmp    $0x9,%sil
  800ee7:	75 13                	jne    800efc <strtol+0x29>
  800ee9:	48 83 c7 01          	add    $0x1,%rdi
  800eed:	0f b6 37             	movzbl (%rdi),%esi
  800ef0:	40 80 fe 20          	cmp    $0x20,%sil
  800ef4:	74 f3                	je     800ee9 <strtol+0x16>
  800ef6:	40 80 fe 09          	cmp    $0x9,%sil
  800efa:	74 ed                	je     800ee9 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800efc:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800eff:	83 e0 fd             	and    $0xfffffffd,%eax
  800f02:	3c 01                	cmp    $0x1,%al
  800f04:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f08:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  800f0e:	75 0f                	jne    800f1f <strtol+0x4c>
  800f10:	80 3f 30             	cmpb   $0x30,(%rdi)
  800f13:	74 14                	je     800f29 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800f15:	85 d2                	test   %edx,%edx
  800f17:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f1c:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  800f1f:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800f24:	4c 63 ca             	movslq %edx,%r9
  800f27:	eb 36                	jmp    800f5f <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f29:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800f2d:	74 0f                	je     800f3e <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  800f2f:	85 d2                	test   %edx,%edx
  800f31:	75 ec                	jne    800f1f <strtol+0x4c>
        s++;
  800f33:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800f37:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  800f3c:	eb e1                	jmp    800f1f <strtol+0x4c>
        s += 2;
  800f3e:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f42:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  800f47:	eb d6                	jmp    800f1f <strtol+0x4c>
            dig -= '0';
  800f49:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  800f4c:	44 0f b6 c1          	movzbl %cl,%r8d
  800f50:	41 39 d0             	cmp    %edx,%r8d
  800f53:	7d 21                	jge    800f76 <strtol+0xa3>
        val = val * base + dig;
  800f55:	49 0f af c1          	imul   %r9,%rax
  800f59:	0f b6 c9             	movzbl %cl,%ecx
  800f5c:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  800f5f:	48 83 c7 01          	add    $0x1,%rdi
  800f63:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  800f67:	80 f9 39             	cmp    $0x39,%cl
  800f6a:	76 dd                	jbe    800f49 <strtol+0x76>
        else if (dig - 'a' < 27)
  800f6c:	80 f9 7b             	cmp    $0x7b,%cl
  800f6f:	77 05                	ja     800f76 <strtol+0xa3>
            dig -= 'a' - 10;
  800f71:	83 e9 57             	sub    $0x57,%ecx
  800f74:	eb d6                	jmp    800f4c <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  800f76:	4d 85 d2             	test   %r10,%r10
  800f79:	74 03                	je     800f7e <strtol+0xab>
  800f7b:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800f7e:	48 89 c2             	mov    %rax,%rdx
  800f81:	48 f7 da             	neg    %rdx
  800f84:	40 80 fe 2d          	cmp    $0x2d,%sil
  800f88:	48 0f 44 c2          	cmove  %rdx,%rax
}
  800f8c:	c3                   	ret

0000000000800f8d <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800f8d:	f3 0f 1e fa          	endbr64
  800f91:	55                   	push   %rbp
  800f92:	48 89 e5             	mov    %rsp,%rbp
  800f95:	53                   	push   %rbx
  800f96:	48 89 fa             	mov    %rdi,%rdx
  800f99:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800f9c:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fa1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fab:	be 00 00 00 00       	mov    $0x0,%esi
  800fb0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fb6:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800fb8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fbc:	c9                   	leave
  800fbd:	c3                   	ret

0000000000800fbe <sys_cgetc>:

int
sys_cgetc(void) {
  800fbe:	f3 0f 1e fa          	endbr64
  800fc2:	55                   	push   %rbp
  800fc3:	48 89 e5             	mov    %rsp,%rbp
  800fc6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800fc7:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800fcc:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fe0:	be 00 00 00 00       	mov    $0x0,%esi
  800fe5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800feb:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800fed:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800ff1:	c9                   	leave
  800ff2:	c3                   	ret

0000000000800ff3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800ff3:	f3 0f 1e fa          	endbr64
  800ff7:	55                   	push   %rbp
  800ff8:	48 89 e5             	mov    %rsp,%rbp
  800ffb:	53                   	push   %rbx
  800ffc:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801000:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801003:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801008:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80100d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801012:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801017:	be 00 00 00 00       	mov    $0x0,%esi
  80101c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801022:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801024:	48 85 c0             	test   %rax,%rax
  801027:	7f 06                	jg     80102f <sys_env_destroy+0x3c>
}
  801029:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80102d:	c9                   	leave
  80102e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80102f:	49 89 c0             	mov    %rax,%r8
  801032:	b9 03 00 00 00       	mov    $0x3,%ecx
  801037:	48 ba 50 30 80 00 00 	movabs $0x803050,%rdx
  80103e:	00 00 00 
  801041:	be 26 00 00 00       	mov    $0x26,%esi
  801046:	48 bf 9c 32 80 00 00 	movabs $0x80329c,%rdi
  80104d:	00 00 00 
  801050:	b8 00 00 00 00       	mov    $0x0,%eax
  801055:	49 b9 5d 2a 80 00 00 	movabs $0x802a5d,%r9
  80105c:	00 00 00 
  80105f:	41 ff d1             	call   *%r9

0000000000801062 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801062:	f3 0f 1e fa          	endbr64
  801066:	55                   	push   %rbp
  801067:	48 89 e5             	mov    %rsp,%rbp
  80106a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80106b:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801070:	ba 00 00 00 00       	mov    $0x0,%edx
  801075:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80107a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801084:	be 00 00 00 00       	mov    $0x0,%esi
  801089:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80108f:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801091:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801095:	c9                   	leave
  801096:	c3                   	ret

0000000000801097 <sys_yield>:

void
sys_yield(void) {
  801097:	f3 0f 1e fa          	endbr64
  80109b:	55                   	push   %rbp
  80109c:	48 89 e5             	mov    %rsp,%rbp
  80109f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010a0:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010aa:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010b9:	be 00 00 00 00       	mov    $0x0,%esi
  8010be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010c4:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8010c6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010ca:	c9                   	leave
  8010cb:	c3                   	ret

00000000008010cc <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8010cc:	f3 0f 1e fa          	endbr64
  8010d0:	55                   	push   %rbp
  8010d1:	48 89 e5             	mov    %rsp,%rbp
  8010d4:	53                   	push   %rbx
  8010d5:	48 89 fa             	mov    %rdi,%rdx
  8010d8:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8010db:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010e0:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8010e7:	00 00 00 
  8010ea:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010ef:	be 00 00 00 00       	mov    $0x0,%esi
  8010f4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010fa:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8010fc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801100:	c9                   	leave
  801101:	c3                   	ret

0000000000801102 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801102:	f3 0f 1e fa          	endbr64
  801106:	55                   	push   %rbp
  801107:	48 89 e5             	mov    %rsp,%rbp
  80110a:	53                   	push   %rbx
  80110b:	49 89 f8             	mov    %rdi,%r8
  80110e:	48 89 d3             	mov    %rdx,%rbx
  801111:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801114:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801119:	4c 89 c2             	mov    %r8,%rdx
  80111c:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80111f:	be 00 00 00 00       	mov    $0x0,%esi
  801124:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80112a:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80112c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801130:	c9                   	leave
  801131:	c3                   	ret

0000000000801132 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801132:	f3 0f 1e fa          	endbr64
  801136:	55                   	push   %rbp
  801137:	48 89 e5             	mov    %rsp,%rbp
  80113a:	53                   	push   %rbx
  80113b:	48 83 ec 08          	sub    $0x8,%rsp
  80113f:	89 f8                	mov    %edi,%eax
  801141:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801144:	48 63 f9             	movslq %ecx,%rdi
  801147:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80114a:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80114f:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801152:	be 00 00 00 00       	mov    $0x0,%esi
  801157:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80115d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80115f:	48 85 c0             	test   %rax,%rax
  801162:	7f 06                	jg     80116a <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801164:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801168:	c9                   	leave
  801169:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80116a:	49 89 c0             	mov    %rax,%r8
  80116d:	b9 04 00 00 00       	mov    $0x4,%ecx
  801172:	48 ba 50 30 80 00 00 	movabs $0x803050,%rdx
  801179:	00 00 00 
  80117c:	be 26 00 00 00       	mov    $0x26,%esi
  801181:	48 bf 9c 32 80 00 00 	movabs $0x80329c,%rdi
  801188:	00 00 00 
  80118b:	b8 00 00 00 00       	mov    $0x0,%eax
  801190:	49 b9 5d 2a 80 00 00 	movabs $0x802a5d,%r9
  801197:	00 00 00 
  80119a:	41 ff d1             	call   *%r9

000000000080119d <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80119d:	f3 0f 1e fa          	endbr64
  8011a1:	55                   	push   %rbp
  8011a2:	48 89 e5             	mov    %rsp,%rbp
  8011a5:	53                   	push   %rbx
  8011a6:	48 83 ec 08          	sub    $0x8,%rsp
  8011aa:	89 f8                	mov    %edi,%eax
  8011ac:	49 89 f2             	mov    %rsi,%r10
  8011af:	48 89 cf             	mov    %rcx,%rdi
  8011b2:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8011b5:	48 63 da             	movslq %edx,%rbx
  8011b8:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011bb:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011c0:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011c3:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8011c6:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011c8:	48 85 c0             	test   %rax,%rax
  8011cb:	7f 06                	jg     8011d3 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8011cd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011d1:	c9                   	leave
  8011d2:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011d3:	49 89 c0             	mov    %rax,%r8
  8011d6:	b9 05 00 00 00       	mov    $0x5,%ecx
  8011db:	48 ba 50 30 80 00 00 	movabs $0x803050,%rdx
  8011e2:	00 00 00 
  8011e5:	be 26 00 00 00       	mov    $0x26,%esi
  8011ea:	48 bf 9c 32 80 00 00 	movabs $0x80329c,%rdi
  8011f1:	00 00 00 
  8011f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f9:	49 b9 5d 2a 80 00 00 	movabs $0x802a5d,%r9
  801200:	00 00 00 
  801203:	41 ff d1             	call   *%r9

0000000000801206 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801206:	f3 0f 1e fa          	endbr64
  80120a:	55                   	push   %rbp
  80120b:	48 89 e5             	mov    %rsp,%rbp
  80120e:	53                   	push   %rbx
  80120f:	48 83 ec 08          	sub    $0x8,%rsp
  801213:	49 89 f9             	mov    %rdi,%r9
  801216:	89 f0                	mov    %esi,%eax
  801218:	48 89 d3             	mov    %rdx,%rbx
  80121b:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80121e:	49 63 f0             	movslq %r8d,%rsi
  801221:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801224:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801229:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80122c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801232:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801234:	48 85 c0             	test   %rax,%rax
  801237:	7f 06                	jg     80123f <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801239:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80123d:	c9                   	leave
  80123e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80123f:	49 89 c0             	mov    %rax,%r8
  801242:	b9 06 00 00 00       	mov    $0x6,%ecx
  801247:	48 ba 50 30 80 00 00 	movabs $0x803050,%rdx
  80124e:	00 00 00 
  801251:	be 26 00 00 00       	mov    $0x26,%esi
  801256:	48 bf 9c 32 80 00 00 	movabs $0x80329c,%rdi
  80125d:	00 00 00 
  801260:	b8 00 00 00 00       	mov    $0x0,%eax
  801265:	49 b9 5d 2a 80 00 00 	movabs $0x802a5d,%r9
  80126c:	00 00 00 
  80126f:	41 ff d1             	call   *%r9

0000000000801272 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801272:	f3 0f 1e fa          	endbr64
  801276:	55                   	push   %rbp
  801277:	48 89 e5             	mov    %rsp,%rbp
  80127a:	53                   	push   %rbx
  80127b:	48 83 ec 08          	sub    $0x8,%rsp
  80127f:	48 89 f1             	mov    %rsi,%rcx
  801282:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801285:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801288:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80128d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801292:	be 00 00 00 00       	mov    $0x0,%esi
  801297:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80129d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80129f:	48 85 c0             	test   %rax,%rax
  8012a2:	7f 06                	jg     8012aa <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8012a4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012a8:	c9                   	leave
  8012a9:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012aa:	49 89 c0             	mov    %rax,%r8
  8012ad:	b9 07 00 00 00       	mov    $0x7,%ecx
  8012b2:	48 ba 50 30 80 00 00 	movabs $0x803050,%rdx
  8012b9:	00 00 00 
  8012bc:	be 26 00 00 00       	mov    $0x26,%esi
  8012c1:	48 bf 9c 32 80 00 00 	movabs $0x80329c,%rdi
  8012c8:	00 00 00 
  8012cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d0:	49 b9 5d 2a 80 00 00 	movabs $0x802a5d,%r9
  8012d7:	00 00 00 
  8012da:	41 ff d1             	call   *%r9

00000000008012dd <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8012dd:	f3 0f 1e fa          	endbr64
  8012e1:	55                   	push   %rbp
  8012e2:	48 89 e5             	mov    %rsp,%rbp
  8012e5:	53                   	push   %rbx
  8012e6:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8012ea:	48 63 ce             	movslq %esi,%rcx
  8012ed:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012f0:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012fa:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012ff:	be 00 00 00 00       	mov    $0x0,%esi
  801304:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80130a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80130c:	48 85 c0             	test   %rax,%rax
  80130f:	7f 06                	jg     801317 <sys_env_set_status+0x3a>
}
  801311:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801315:	c9                   	leave
  801316:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801317:	49 89 c0             	mov    %rax,%r8
  80131a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80131f:	48 ba 50 30 80 00 00 	movabs $0x803050,%rdx
  801326:	00 00 00 
  801329:	be 26 00 00 00       	mov    $0x26,%esi
  80132e:	48 bf 9c 32 80 00 00 	movabs $0x80329c,%rdi
  801335:	00 00 00 
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
  80133d:	49 b9 5d 2a 80 00 00 	movabs $0x802a5d,%r9
  801344:	00 00 00 
  801347:	41 ff d1             	call   *%r9

000000000080134a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80134a:	f3 0f 1e fa          	endbr64
  80134e:	55                   	push   %rbp
  80134f:	48 89 e5             	mov    %rsp,%rbp
  801352:	53                   	push   %rbx
  801353:	48 83 ec 08          	sub    $0x8,%rsp
  801357:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80135a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80135d:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801362:	bb 00 00 00 00       	mov    $0x0,%ebx
  801367:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80136c:	be 00 00 00 00       	mov    $0x0,%esi
  801371:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801377:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801379:	48 85 c0             	test   %rax,%rax
  80137c:	7f 06                	jg     801384 <sys_env_set_trapframe+0x3a>
}
  80137e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801382:	c9                   	leave
  801383:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801384:	49 89 c0             	mov    %rax,%r8
  801387:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80138c:	48 ba 50 30 80 00 00 	movabs $0x803050,%rdx
  801393:	00 00 00 
  801396:	be 26 00 00 00       	mov    $0x26,%esi
  80139b:	48 bf 9c 32 80 00 00 	movabs $0x80329c,%rdi
  8013a2:	00 00 00 
  8013a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013aa:	49 b9 5d 2a 80 00 00 	movabs $0x802a5d,%r9
  8013b1:	00 00 00 
  8013b4:	41 ff d1             	call   *%r9

00000000008013b7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8013b7:	f3 0f 1e fa          	endbr64
  8013bb:	55                   	push   %rbp
  8013bc:	48 89 e5             	mov    %rsp,%rbp
  8013bf:	53                   	push   %rbx
  8013c0:	48 83 ec 08          	sub    $0x8,%rsp
  8013c4:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8013c7:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013ca:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013d9:	be 00 00 00 00       	mov    $0x0,%esi
  8013de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013e4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013e6:	48 85 c0             	test   %rax,%rax
  8013e9:	7f 06                	jg     8013f1 <sys_env_set_pgfault_upcall+0x3a>
}
  8013eb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013ef:	c9                   	leave
  8013f0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013f1:	49 89 c0             	mov    %rax,%r8
  8013f4:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8013f9:	48 ba 50 30 80 00 00 	movabs $0x803050,%rdx
  801400:	00 00 00 
  801403:	be 26 00 00 00       	mov    $0x26,%esi
  801408:	48 bf 9c 32 80 00 00 	movabs $0x80329c,%rdi
  80140f:	00 00 00 
  801412:	b8 00 00 00 00       	mov    $0x0,%eax
  801417:	49 b9 5d 2a 80 00 00 	movabs $0x802a5d,%r9
  80141e:	00 00 00 
  801421:	41 ff d1             	call   *%r9

0000000000801424 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801424:	f3 0f 1e fa          	endbr64
  801428:	55                   	push   %rbp
  801429:	48 89 e5             	mov    %rsp,%rbp
  80142c:	53                   	push   %rbx
  80142d:	89 f8                	mov    %edi,%eax
  80142f:	49 89 f1             	mov    %rsi,%r9
  801432:	48 89 d3             	mov    %rdx,%rbx
  801435:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801438:	49 63 f0             	movslq %r8d,%rsi
  80143b:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80143e:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801443:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801446:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80144c:	cd 30                	int    $0x30
}
  80144e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801452:	c9                   	leave
  801453:	c3                   	ret

0000000000801454 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801454:	f3 0f 1e fa          	endbr64
  801458:	55                   	push   %rbp
  801459:	48 89 e5             	mov    %rsp,%rbp
  80145c:	53                   	push   %rbx
  80145d:	48 83 ec 08          	sub    $0x8,%rsp
  801461:	48 89 fa             	mov    %rdi,%rdx
  801464:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801467:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80146c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801471:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801476:	be 00 00 00 00       	mov    $0x0,%esi
  80147b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801481:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801483:	48 85 c0             	test   %rax,%rax
  801486:	7f 06                	jg     80148e <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801488:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80148c:	c9                   	leave
  80148d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80148e:	49 89 c0             	mov    %rax,%r8
  801491:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801496:	48 ba 50 30 80 00 00 	movabs $0x803050,%rdx
  80149d:	00 00 00 
  8014a0:	be 26 00 00 00       	mov    $0x26,%esi
  8014a5:	48 bf 9c 32 80 00 00 	movabs $0x80329c,%rdi
  8014ac:	00 00 00 
  8014af:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b4:	49 b9 5d 2a 80 00 00 	movabs $0x802a5d,%r9
  8014bb:	00 00 00 
  8014be:	41 ff d1             	call   *%r9

00000000008014c1 <sys_gettime>:

int
sys_gettime(void) {
  8014c1:	f3 0f 1e fa          	endbr64
  8014c5:	55                   	push   %rbp
  8014c6:	48 89 e5             	mov    %rsp,%rbp
  8014c9:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014ca:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d4:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014de:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014e3:	be 00 00 00 00       	mov    $0x0,%esi
  8014e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014ee:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8014f0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014f4:	c9                   	leave
  8014f5:	c3                   	ret

00000000008014f6 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  8014f6:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8014fa:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801501:	ff ff ff 
  801504:	48 01 f8             	add    %rdi,%rax
  801507:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80150b:	c3                   	ret

000000000080150c <fd2data>:

char *
fd2data(struct Fd *fd) {
  80150c:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801510:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801517:	ff ff ff 
  80151a:	48 01 f8             	add    %rdi,%rax
  80151d:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801521:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801527:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80152b:	c3                   	ret

000000000080152c <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80152c:	f3 0f 1e fa          	endbr64
  801530:	55                   	push   %rbp
  801531:	48 89 e5             	mov    %rsp,%rbp
  801534:	41 57                	push   %r15
  801536:	41 56                	push   %r14
  801538:	41 55                	push   %r13
  80153a:	41 54                	push   %r12
  80153c:	53                   	push   %rbx
  80153d:	48 83 ec 08          	sub    $0x8,%rsp
  801541:	49 89 ff             	mov    %rdi,%r15
  801544:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801549:	49 bd 8b 26 80 00 00 	movabs $0x80268b,%r13
  801550:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801553:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801559:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  80155c:	48 89 df             	mov    %rbx,%rdi
  80155f:	41 ff d5             	call   *%r13
  801562:	83 e0 04             	and    $0x4,%eax
  801565:	74 17                	je     80157e <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801567:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80156e:	4c 39 f3             	cmp    %r14,%rbx
  801571:	75 e6                	jne    801559 <fd_alloc+0x2d>
  801573:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801579:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  80157e:	4d 89 27             	mov    %r12,(%r15)
}
  801581:	48 83 c4 08          	add    $0x8,%rsp
  801585:	5b                   	pop    %rbx
  801586:	41 5c                	pop    %r12
  801588:	41 5d                	pop    %r13
  80158a:	41 5e                	pop    %r14
  80158c:	41 5f                	pop    %r15
  80158e:	5d                   	pop    %rbp
  80158f:	c3                   	ret

0000000000801590 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801590:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801594:	83 ff 1f             	cmp    $0x1f,%edi
  801597:	77 39                	ja     8015d2 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801599:	55                   	push   %rbp
  80159a:	48 89 e5             	mov    %rsp,%rbp
  80159d:	41 54                	push   %r12
  80159f:	53                   	push   %rbx
  8015a0:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8015a3:	48 63 df             	movslq %edi,%rbx
  8015a6:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8015ad:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8015b1:	48 89 df             	mov    %rbx,%rdi
  8015b4:	48 b8 8b 26 80 00 00 	movabs $0x80268b,%rax
  8015bb:	00 00 00 
  8015be:	ff d0                	call   *%rax
  8015c0:	a8 04                	test   $0x4,%al
  8015c2:	74 14                	je     8015d8 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8015c4:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8015c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cd:	5b                   	pop    %rbx
  8015ce:	41 5c                	pop    %r12
  8015d0:	5d                   	pop    %rbp
  8015d1:	c3                   	ret
        return -E_INVAL;
  8015d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015d7:	c3                   	ret
        return -E_INVAL;
  8015d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015dd:	eb ee                	jmp    8015cd <fd_lookup+0x3d>

00000000008015df <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8015df:	f3 0f 1e fa          	endbr64
  8015e3:	55                   	push   %rbp
  8015e4:	48 89 e5             	mov    %rsp,%rbp
  8015e7:	41 54                	push   %r12
  8015e9:	53                   	push   %rbx
  8015ea:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  8015ed:	48 b8 c0 36 80 00 00 	movabs $0x8036c0,%rax
  8015f4:	00 00 00 
  8015f7:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  8015fe:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801601:	39 3b                	cmp    %edi,(%rbx)
  801603:	74 47                	je     80164c <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801605:	48 83 c0 08          	add    $0x8,%rax
  801609:	48 8b 18             	mov    (%rax),%rbx
  80160c:	48 85 db             	test   %rbx,%rbx
  80160f:	75 f0                	jne    801601 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801611:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801618:	00 00 00 
  80161b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801621:	89 fa                	mov    %edi,%edx
  801623:	48 bf 70 30 80 00 00 	movabs $0x803070,%rdi
  80162a:	00 00 00 
  80162d:	b8 00 00 00 00       	mov    $0x0,%eax
  801632:	48 b9 e4 01 80 00 00 	movabs $0x8001e4,%rcx
  801639:	00 00 00 
  80163c:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  80163e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801643:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801647:	5b                   	pop    %rbx
  801648:	41 5c                	pop    %r12
  80164a:	5d                   	pop    %rbp
  80164b:	c3                   	ret
            return 0;
  80164c:	b8 00 00 00 00       	mov    $0x0,%eax
  801651:	eb f0                	jmp    801643 <dev_lookup+0x64>

0000000000801653 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801653:	f3 0f 1e fa          	endbr64
  801657:	55                   	push   %rbp
  801658:	48 89 e5             	mov    %rsp,%rbp
  80165b:	41 55                	push   %r13
  80165d:	41 54                	push   %r12
  80165f:	53                   	push   %rbx
  801660:	48 83 ec 18          	sub    $0x18,%rsp
  801664:	48 89 fb             	mov    %rdi,%rbx
  801667:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80166a:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801671:	ff ff ff 
  801674:	48 01 df             	add    %rbx,%rdi
  801677:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80167b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80167f:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  801686:	00 00 00 
  801689:	ff d0                	call   *%rax
  80168b:	41 89 c5             	mov    %eax,%r13d
  80168e:	85 c0                	test   %eax,%eax
  801690:	78 06                	js     801698 <fd_close+0x45>
  801692:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801696:	74 1a                	je     8016b2 <fd_close+0x5f>
        return (must_exist ? res : 0);
  801698:	45 84 e4             	test   %r12b,%r12b
  80169b:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a0:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8016a4:	44 89 e8             	mov    %r13d,%eax
  8016a7:	48 83 c4 18          	add    $0x18,%rsp
  8016ab:	5b                   	pop    %rbx
  8016ac:	41 5c                	pop    %r12
  8016ae:	41 5d                	pop    %r13
  8016b0:	5d                   	pop    %rbp
  8016b1:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016b2:	8b 3b                	mov    (%rbx),%edi
  8016b4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8016b8:	48 b8 df 15 80 00 00 	movabs $0x8015df,%rax
  8016bf:	00 00 00 
  8016c2:	ff d0                	call   *%rax
  8016c4:	41 89 c5             	mov    %eax,%r13d
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	78 1b                	js     8016e6 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8016cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016cf:	48 8b 40 20          	mov    0x20(%rax),%rax
  8016d3:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8016d9:	48 85 c0             	test   %rax,%rax
  8016dc:	74 08                	je     8016e6 <fd_close+0x93>
  8016de:	48 89 df             	mov    %rbx,%rdi
  8016e1:	ff d0                	call   *%rax
  8016e3:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8016e6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8016eb:	48 89 de             	mov    %rbx,%rsi
  8016ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f3:	48 b8 72 12 80 00 00 	movabs $0x801272,%rax
  8016fa:	00 00 00 
  8016fd:	ff d0                	call   *%rax
    return res;
  8016ff:	eb a3                	jmp    8016a4 <fd_close+0x51>

0000000000801701 <close>:

int
close(int fdnum) {
  801701:	f3 0f 1e fa          	endbr64
  801705:	55                   	push   %rbp
  801706:	48 89 e5             	mov    %rsp,%rbp
  801709:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80170d:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801711:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  801718:	00 00 00 
  80171b:	ff d0                	call   *%rax
    if (res < 0) return res;
  80171d:	85 c0                	test   %eax,%eax
  80171f:	78 15                	js     801736 <close+0x35>

    return fd_close(fd, 1);
  801721:	be 01 00 00 00       	mov    $0x1,%esi
  801726:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80172a:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  801731:	00 00 00 
  801734:	ff d0                	call   *%rax
}
  801736:	c9                   	leave
  801737:	c3                   	ret

0000000000801738 <close_all>:

void
close_all(void) {
  801738:	f3 0f 1e fa          	endbr64
  80173c:	55                   	push   %rbp
  80173d:	48 89 e5             	mov    %rsp,%rbp
  801740:	41 54                	push   %r12
  801742:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801743:	bb 00 00 00 00       	mov    $0x0,%ebx
  801748:	49 bc 01 17 80 00 00 	movabs $0x801701,%r12
  80174f:	00 00 00 
  801752:	89 df                	mov    %ebx,%edi
  801754:	41 ff d4             	call   *%r12
  801757:	83 c3 01             	add    $0x1,%ebx
  80175a:	83 fb 20             	cmp    $0x20,%ebx
  80175d:	75 f3                	jne    801752 <close_all+0x1a>
}
  80175f:	5b                   	pop    %rbx
  801760:	41 5c                	pop    %r12
  801762:	5d                   	pop    %rbp
  801763:	c3                   	ret

0000000000801764 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801764:	f3 0f 1e fa          	endbr64
  801768:	55                   	push   %rbp
  801769:	48 89 e5             	mov    %rsp,%rbp
  80176c:	41 57                	push   %r15
  80176e:	41 56                	push   %r14
  801770:	41 55                	push   %r13
  801772:	41 54                	push   %r12
  801774:	53                   	push   %rbx
  801775:	48 83 ec 18          	sub    $0x18,%rsp
  801779:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80177c:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801780:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  801787:	00 00 00 
  80178a:	ff d0                	call   *%rax
  80178c:	89 c3                	mov    %eax,%ebx
  80178e:	85 c0                	test   %eax,%eax
  801790:	0f 88 b8 00 00 00    	js     80184e <dup+0xea>
    close(newfdnum);
  801796:	44 89 e7             	mov    %r12d,%edi
  801799:	48 b8 01 17 80 00 00 	movabs $0x801701,%rax
  8017a0:	00 00 00 
  8017a3:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8017a5:	4d 63 ec             	movslq %r12d,%r13
  8017a8:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8017af:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8017b3:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8017b7:	4c 89 ff             	mov    %r15,%rdi
  8017ba:	49 be 0c 15 80 00 00 	movabs $0x80150c,%r14
  8017c1:	00 00 00 
  8017c4:	41 ff d6             	call   *%r14
  8017c7:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8017ca:	4c 89 ef             	mov    %r13,%rdi
  8017cd:	41 ff d6             	call   *%r14
  8017d0:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8017d3:	48 89 df             	mov    %rbx,%rdi
  8017d6:	48 b8 8b 26 80 00 00 	movabs $0x80268b,%rax
  8017dd:	00 00 00 
  8017e0:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8017e2:	a8 04                	test   $0x4,%al
  8017e4:	74 2b                	je     801811 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8017e6:	41 89 c1             	mov    %eax,%r9d
  8017e9:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8017ef:	4c 89 f1             	mov    %r14,%rcx
  8017f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f7:	48 89 de             	mov    %rbx,%rsi
  8017fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8017ff:	48 b8 9d 11 80 00 00 	movabs $0x80119d,%rax
  801806:	00 00 00 
  801809:	ff d0                	call   *%rax
  80180b:	89 c3                	mov    %eax,%ebx
  80180d:	85 c0                	test   %eax,%eax
  80180f:	78 4e                	js     80185f <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801811:	4c 89 ff             	mov    %r15,%rdi
  801814:	48 b8 8b 26 80 00 00 	movabs $0x80268b,%rax
  80181b:	00 00 00 
  80181e:	ff d0                	call   *%rax
  801820:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801823:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801829:	4c 89 e9             	mov    %r13,%rcx
  80182c:	ba 00 00 00 00       	mov    $0x0,%edx
  801831:	4c 89 fe             	mov    %r15,%rsi
  801834:	bf 00 00 00 00       	mov    $0x0,%edi
  801839:	48 b8 9d 11 80 00 00 	movabs $0x80119d,%rax
  801840:	00 00 00 
  801843:	ff d0                	call   *%rax
  801845:	89 c3                	mov    %eax,%ebx
  801847:	85 c0                	test   %eax,%eax
  801849:	78 14                	js     80185f <dup+0xfb>

    return newfdnum;
  80184b:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  80184e:	89 d8                	mov    %ebx,%eax
  801850:	48 83 c4 18          	add    $0x18,%rsp
  801854:	5b                   	pop    %rbx
  801855:	41 5c                	pop    %r12
  801857:	41 5d                	pop    %r13
  801859:	41 5e                	pop    %r14
  80185b:	41 5f                	pop    %r15
  80185d:	5d                   	pop    %rbp
  80185e:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80185f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801864:	4c 89 ee             	mov    %r13,%rsi
  801867:	bf 00 00 00 00       	mov    $0x0,%edi
  80186c:	49 bc 72 12 80 00 00 	movabs $0x801272,%r12
  801873:	00 00 00 
  801876:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801879:	ba 00 10 00 00       	mov    $0x1000,%edx
  80187e:	4c 89 f6             	mov    %r14,%rsi
  801881:	bf 00 00 00 00       	mov    $0x0,%edi
  801886:	41 ff d4             	call   *%r12
    return res;
  801889:	eb c3                	jmp    80184e <dup+0xea>

000000000080188b <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  80188b:	f3 0f 1e fa          	endbr64
  80188f:	55                   	push   %rbp
  801890:	48 89 e5             	mov    %rsp,%rbp
  801893:	41 56                	push   %r14
  801895:	41 55                	push   %r13
  801897:	41 54                	push   %r12
  801899:	53                   	push   %rbx
  80189a:	48 83 ec 10          	sub    $0x10,%rsp
  80189e:	89 fb                	mov    %edi,%ebx
  8018a0:	49 89 f4             	mov    %rsi,%r12
  8018a3:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8018a6:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018aa:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  8018b1:	00 00 00 
  8018b4:	ff d0                	call   *%rax
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	78 4c                	js     801906 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8018ba:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8018be:	41 8b 3e             	mov    (%r14),%edi
  8018c1:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018c5:	48 b8 df 15 80 00 00 	movabs $0x8015df,%rax
  8018cc:	00 00 00 
  8018cf:	ff d0                	call   *%rax
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	78 35                	js     80190a <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018d5:	41 8b 46 08          	mov    0x8(%r14),%eax
  8018d9:	83 e0 03             	and    $0x3,%eax
  8018dc:	83 f8 01             	cmp    $0x1,%eax
  8018df:	74 2d                	je     80190e <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8018e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8018e9:	48 85 c0             	test   %rax,%rax
  8018ec:	74 56                	je     801944 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  8018ee:	4c 89 ea             	mov    %r13,%rdx
  8018f1:	4c 89 e6             	mov    %r12,%rsi
  8018f4:	4c 89 f7             	mov    %r14,%rdi
  8018f7:	ff d0                	call   *%rax
}
  8018f9:	48 83 c4 10          	add    $0x10,%rsp
  8018fd:	5b                   	pop    %rbx
  8018fe:	41 5c                	pop    %r12
  801900:	41 5d                	pop    %r13
  801902:	41 5e                	pop    %r14
  801904:	5d                   	pop    %rbp
  801905:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801906:	48 98                	cltq
  801908:	eb ef                	jmp    8018f9 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80190a:	48 98                	cltq
  80190c:	eb eb                	jmp    8018f9 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80190e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801915:	00 00 00 
  801918:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80191e:	89 da                	mov    %ebx,%edx
  801920:	48 bf aa 32 80 00 00 	movabs $0x8032aa,%rdi
  801927:	00 00 00 
  80192a:	b8 00 00 00 00       	mov    $0x0,%eax
  80192f:	48 b9 e4 01 80 00 00 	movabs $0x8001e4,%rcx
  801936:	00 00 00 
  801939:	ff d1                	call   *%rcx
        return -E_INVAL;
  80193b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801942:	eb b5                	jmp    8018f9 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801944:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  80194b:	eb ac                	jmp    8018f9 <read+0x6e>

000000000080194d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  80194d:	f3 0f 1e fa          	endbr64
  801951:	55                   	push   %rbp
  801952:	48 89 e5             	mov    %rsp,%rbp
  801955:	41 57                	push   %r15
  801957:	41 56                	push   %r14
  801959:	41 55                	push   %r13
  80195b:	41 54                	push   %r12
  80195d:	53                   	push   %rbx
  80195e:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801962:	48 85 d2             	test   %rdx,%rdx
  801965:	74 54                	je     8019bb <readn+0x6e>
  801967:	41 89 fd             	mov    %edi,%r13d
  80196a:	49 89 f6             	mov    %rsi,%r14
  80196d:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801970:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801975:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  80197a:	49 bf 8b 18 80 00 00 	movabs $0x80188b,%r15
  801981:	00 00 00 
  801984:	4c 89 e2             	mov    %r12,%rdx
  801987:	48 29 f2             	sub    %rsi,%rdx
  80198a:	4c 01 f6             	add    %r14,%rsi
  80198d:	44 89 ef             	mov    %r13d,%edi
  801990:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801993:	85 c0                	test   %eax,%eax
  801995:	78 20                	js     8019b7 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801997:	01 c3                	add    %eax,%ebx
  801999:	85 c0                	test   %eax,%eax
  80199b:	74 08                	je     8019a5 <readn+0x58>
  80199d:	48 63 f3             	movslq %ebx,%rsi
  8019a0:	4c 39 e6             	cmp    %r12,%rsi
  8019a3:	72 df                	jb     801984 <readn+0x37>
    }
    return res;
  8019a5:	48 63 c3             	movslq %ebx,%rax
}
  8019a8:	48 83 c4 08          	add    $0x8,%rsp
  8019ac:	5b                   	pop    %rbx
  8019ad:	41 5c                	pop    %r12
  8019af:	41 5d                	pop    %r13
  8019b1:	41 5e                	pop    %r14
  8019b3:	41 5f                	pop    %r15
  8019b5:	5d                   	pop    %rbp
  8019b6:	c3                   	ret
        if (inc < 0) return inc;
  8019b7:	48 98                	cltq
  8019b9:	eb ed                	jmp    8019a8 <readn+0x5b>
    int inc = 1, res = 0;
  8019bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019c0:	eb e3                	jmp    8019a5 <readn+0x58>

00000000008019c2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8019c2:	f3 0f 1e fa          	endbr64
  8019c6:	55                   	push   %rbp
  8019c7:	48 89 e5             	mov    %rsp,%rbp
  8019ca:	41 56                	push   %r14
  8019cc:	41 55                	push   %r13
  8019ce:	41 54                	push   %r12
  8019d0:	53                   	push   %rbx
  8019d1:	48 83 ec 10          	sub    $0x10,%rsp
  8019d5:	89 fb                	mov    %edi,%ebx
  8019d7:	49 89 f4             	mov    %rsi,%r12
  8019da:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019dd:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019e1:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  8019e8:	00 00 00 
  8019eb:	ff d0                	call   *%rax
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	78 47                	js     801a38 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019f1:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8019f5:	41 8b 3e             	mov    (%r14),%edi
  8019f8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8019fc:	48 b8 df 15 80 00 00 	movabs $0x8015df,%rax
  801a03:	00 00 00 
  801a06:	ff d0                	call   *%rax
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	78 30                	js     801a3c <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a0c:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801a11:	74 2d                	je     801a40 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801a13:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a17:	48 8b 40 18          	mov    0x18(%rax),%rax
  801a1b:	48 85 c0             	test   %rax,%rax
  801a1e:	74 56                	je     801a76 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801a20:	4c 89 ea             	mov    %r13,%rdx
  801a23:	4c 89 e6             	mov    %r12,%rsi
  801a26:	4c 89 f7             	mov    %r14,%rdi
  801a29:	ff d0                	call   *%rax
}
  801a2b:	48 83 c4 10          	add    $0x10,%rsp
  801a2f:	5b                   	pop    %rbx
  801a30:	41 5c                	pop    %r12
  801a32:	41 5d                	pop    %r13
  801a34:	41 5e                	pop    %r14
  801a36:	5d                   	pop    %rbp
  801a37:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a38:	48 98                	cltq
  801a3a:	eb ef                	jmp    801a2b <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a3c:	48 98                	cltq
  801a3e:	eb eb                	jmp    801a2b <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a40:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a47:	00 00 00 
  801a4a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a50:	89 da                	mov    %ebx,%edx
  801a52:	48 bf c6 32 80 00 00 	movabs $0x8032c6,%rdi
  801a59:	00 00 00 
  801a5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a61:	48 b9 e4 01 80 00 00 	movabs $0x8001e4,%rcx
  801a68:	00 00 00 
  801a6b:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a6d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801a74:	eb b5                	jmp    801a2b <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801a76:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a7d:	eb ac                	jmp    801a2b <write+0x69>

0000000000801a7f <seek>:

int
seek(int fdnum, off_t offset) {
  801a7f:	f3 0f 1e fa          	endbr64
  801a83:	55                   	push   %rbp
  801a84:	48 89 e5             	mov    %rsp,%rbp
  801a87:	53                   	push   %rbx
  801a88:	48 83 ec 18          	sub    $0x18,%rsp
  801a8c:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a8e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801a92:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  801a99:	00 00 00 
  801a9c:	ff d0                	call   *%rax
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	78 0c                	js     801aae <seek+0x2f>

    fd->fd_offset = offset;
  801aa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aa6:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aae:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ab2:	c9                   	leave
  801ab3:	c3                   	ret

0000000000801ab4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801ab4:	f3 0f 1e fa          	endbr64
  801ab8:	55                   	push   %rbp
  801ab9:	48 89 e5             	mov    %rsp,%rbp
  801abc:	41 55                	push   %r13
  801abe:	41 54                	push   %r12
  801ac0:	53                   	push   %rbx
  801ac1:	48 83 ec 18          	sub    $0x18,%rsp
  801ac5:	89 fb                	mov    %edi,%ebx
  801ac7:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801aca:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ace:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  801ad5:	00 00 00 
  801ad8:	ff d0                	call   *%rax
  801ada:	85 c0                	test   %eax,%eax
  801adc:	78 38                	js     801b16 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ade:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801ae2:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801ae6:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801aea:	48 b8 df 15 80 00 00 	movabs $0x8015df,%rax
  801af1:	00 00 00 
  801af4:	ff d0                	call   *%rax
  801af6:	85 c0                	test   %eax,%eax
  801af8:	78 1c                	js     801b16 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801afa:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801aff:	74 20                	je     801b21 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801b01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b05:	48 8b 40 30          	mov    0x30(%rax),%rax
  801b09:	48 85 c0             	test   %rax,%rax
  801b0c:	74 47                	je     801b55 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801b0e:	44 89 e6             	mov    %r12d,%esi
  801b11:	4c 89 ef             	mov    %r13,%rdi
  801b14:	ff d0                	call   *%rax
}
  801b16:	48 83 c4 18          	add    $0x18,%rsp
  801b1a:	5b                   	pop    %rbx
  801b1b:	41 5c                	pop    %r12
  801b1d:	41 5d                	pop    %r13
  801b1f:	5d                   	pop    %rbp
  801b20:	c3                   	ret
                thisenv->env_id, fdnum);
  801b21:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b28:	00 00 00 
  801b2b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b31:	89 da                	mov    %ebx,%edx
  801b33:	48 bf 90 30 80 00 00 	movabs $0x803090,%rdi
  801b3a:	00 00 00 
  801b3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b42:	48 b9 e4 01 80 00 00 	movabs $0x8001e4,%rcx
  801b49:	00 00 00 
  801b4c:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b53:	eb c1                	jmp    801b16 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801b55:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801b5a:	eb ba                	jmp    801b16 <ftruncate+0x62>

0000000000801b5c <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801b5c:	f3 0f 1e fa          	endbr64
  801b60:	55                   	push   %rbp
  801b61:	48 89 e5             	mov    %rsp,%rbp
  801b64:	41 54                	push   %r12
  801b66:	53                   	push   %rbx
  801b67:	48 83 ec 10          	sub    $0x10,%rsp
  801b6b:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b6e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801b72:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  801b79:	00 00 00 
  801b7c:	ff d0                	call   *%rax
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	78 4e                	js     801bd0 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b82:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801b86:	41 8b 3c 24          	mov    (%r12),%edi
  801b8a:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801b8e:	48 b8 df 15 80 00 00 	movabs $0x8015df,%rax
  801b95:	00 00 00 
  801b98:	ff d0                	call   *%rax
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	78 32                	js     801bd0 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801b9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ba2:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801ba7:	74 30                	je     801bd9 <fstat+0x7d>

    stat->st_name[0] = 0;
  801ba9:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801bac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801bb3:	00 00 00 
    stat->st_isdir = 0;
  801bb6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801bbd:	00 00 00 
    stat->st_dev = dev;
  801bc0:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801bc7:	48 89 de             	mov    %rbx,%rsi
  801bca:	4c 89 e7             	mov    %r12,%rdi
  801bcd:	ff 50 28             	call   *0x28(%rax)
}
  801bd0:	48 83 c4 10          	add    $0x10,%rsp
  801bd4:	5b                   	pop    %rbx
  801bd5:	41 5c                	pop    %r12
  801bd7:	5d                   	pop    %rbp
  801bd8:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801bd9:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801bde:	eb f0                	jmp    801bd0 <fstat+0x74>

0000000000801be0 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801be0:	f3 0f 1e fa          	endbr64
  801be4:	55                   	push   %rbp
  801be5:	48 89 e5             	mov    %rsp,%rbp
  801be8:	41 54                	push   %r12
  801bea:	53                   	push   %rbx
  801beb:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801bee:	be 00 00 00 00       	mov    $0x0,%esi
  801bf3:	48 b8 c1 1e 80 00 00 	movabs $0x801ec1,%rax
  801bfa:	00 00 00 
  801bfd:	ff d0                	call   *%rax
  801bff:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801c01:	85 c0                	test   %eax,%eax
  801c03:	78 25                	js     801c2a <stat+0x4a>

    int res = fstat(fd, stat);
  801c05:	4c 89 e6             	mov    %r12,%rsi
  801c08:	89 c7                	mov    %eax,%edi
  801c0a:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  801c11:	00 00 00 
  801c14:	ff d0                	call   *%rax
  801c16:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801c19:	89 df                	mov    %ebx,%edi
  801c1b:	48 b8 01 17 80 00 00 	movabs $0x801701,%rax
  801c22:	00 00 00 
  801c25:	ff d0                	call   *%rax

    return res;
  801c27:	44 89 e3             	mov    %r12d,%ebx
}
  801c2a:	89 d8                	mov    %ebx,%eax
  801c2c:	5b                   	pop    %rbx
  801c2d:	41 5c                	pop    %r12
  801c2f:	5d                   	pop    %rbp
  801c30:	c3                   	ret

0000000000801c31 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801c31:	f3 0f 1e fa          	endbr64
  801c35:	55                   	push   %rbp
  801c36:	48 89 e5             	mov    %rsp,%rbp
  801c39:	41 54                	push   %r12
  801c3b:	53                   	push   %rbx
  801c3c:	48 83 ec 10          	sub    $0x10,%rsp
  801c40:	41 89 fc             	mov    %edi,%r12d
  801c43:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801c46:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c4d:	00 00 00 
  801c50:	83 38 00             	cmpl   $0x0,(%rax)
  801c53:	74 6e                	je     801cc3 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801c55:	bf 03 00 00 00       	mov    $0x3,%edi
  801c5a:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  801c61:	00 00 00 
  801c64:	ff d0                	call   *%rax
  801c66:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801c6d:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801c6f:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801c75:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c7a:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801c81:	00 00 00 
  801c84:	44 89 e6             	mov    %r12d,%esi
  801c87:	89 c7                	mov    %eax,%edi
  801c89:	48 b8 9d 2b 80 00 00 	movabs $0x802b9d,%rax
  801c90:	00 00 00 
  801c93:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801c95:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801c9c:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801c9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ca2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ca6:	48 89 de             	mov    %rbx,%rsi
  801ca9:	bf 00 00 00 00       	mov    $0x0,%edi
  801cae:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  801cb5:	00 00 00 
  801cb8:	ff d0                	call   *%rax
}
  801cba:	48 83 c4 10          	add    $0x10,%rsp
  801cbe:	5b                   	pop    %rbx
  801cbf:	41 5c                	pop    %r12
  801cc1:	5d                   	pop    %rbp
  801cc2:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801cc3:	bf 03 00 00 00       	mov    $0x3,%edi
  801cc8:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  801ccf:	00 00 00 
  801cd2:	ff d0                	call   *%rax
  801cd4:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801cdb:	00 00 
  801cdd:	e9 73 ff ff ff       	jmp    801c55 <fsipc+0x24>

0000000000801ce2 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801ce2:	f3 0f 1e fa          	endbr64
  801ce6:	55                   	push   %rbp
  801ce7:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cea:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801cf1:	00 00 00 
  801cf4:	8b 57 0c             	mov    0xc(%rdi),%edx
  801cf7:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801cf9:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801cfc:	be 00 00 00 00       	mov    $0x0,%esi
  801d01:	bf 02 00 00 00       	mov    $0x2,%edi
  801d06:	48 b8 31 1c 80 00 00 	movabs $0x801c31,%rax
  801d0d:	00 00 00 
  801d10:	ff d0                	call   *%rax
}
  801d12:	5d                   	pop    %rbp
  801d13:	c3                   	ret

0000000000801d14 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801d14:	f3 0f 1e fa          	endbr64
  801d18:	55                   	push   %rbp
  801d19:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d1c:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d1f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d26:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801d28:	be 00 00 00 00       	mov    $0x0,%esi
  801d2d:	bf 06 00 00 00       	mov    $0x6,%edi
  801d32:	48 b8 31 1c 80 00 00 	movabs $0x801c31,%rax
  801d39:	00 00 00 
  801d3c:	ff d0                	call   *%rax
}
  801d3e:	5d                   	pop    %rbp
  801d3f:	c3                   	ret

0000000000801d40 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801d40:	f3 0f 1e fa          	endbr64
  801d44:	55                   	push   %rbp
  801d45:	48 89 e5             	mov    %rsp,%rbp
  801d48:	41 54                	push   %r12
  801d4a:	53                   	push   %rbx
  801d4b:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d4e:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d51:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d58:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801d5a:	be 00 00 00 00       	mov    $0x0,%esi
  801d5f:	bf 05 00 00 00       	mov    $0x5,%edi
  801d64:	48 b8 31 1c 80 00 00 	movabs $0x801c31,%rax
  801d6b:	00 00 00 
  801d6e:	ff d0                	call   *%rax
    if (res < 0) return res;
  801d70:	85 c0                	test   %eax,%eax
  801d72:	78 3d                	js     801db1 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d74:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  801d7b:	00 00 00 
  801d7e:	4c 89 e6             	mov    %r12,%rsi
  801d81:	48 89 df             	mov    %rbx,%rdi
  801d84:	48 b8 2d 0b 80 00 00 	movabs $0x800b2d,%rax
  801d8b:	00 00 00 
  801d8e:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801d90:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801d97:	00 
  801d98:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d9e:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801da5:	00 
  801da6:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801dac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db1:	5b                   	pop    %rbx
  801db2:	41 5c                	pop    %r12
  801db4:	5d                   	pop    %rbp
  801db5:	c3                   	ret

0000000000801db6 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801db6:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801dba:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801dc1:	77 41                	ja     801e04 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801dc3:	55                   	push   %rbp
  801dc4:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801dc7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801dce:	00 00 00 
  801dd1:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801dd4:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  801dd6:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801dda:	48 8d 78 10          	lea    0x10(%rax),%rdi
  801dde:	48 b8 48 0d 80 00 00 	movabs $0x800d48,%rax
  801de5:	00 00 00 
  801de8:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  801dea:	be 00 00 00 00       	mov    $0x0,%esi
  801def:	bf 04 00 00 00       	mov    $0x4,%edi
  801df4:	48 b8 31 1c 80 00 00 	movabs $0x801c31,%rax
  801dfb:	00 00 00 
  801dfe:	ff d0                	call   *%rax
  801e00:	48 98                	cltq
}
  801e02:	5d                   	pop    %rbp
  801e03:	c3                   	ret
        return -E_INVAL;
  801e04:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  801e0b:	c3                   	ret

0000000000801e0c <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801e0c:	f3 0f 1e fa          	endbr64
  801e10:	55                   	push   %rbp
  801e11:	48 89 e5             	mov    %rsp,%rbp
  801e14:	41 55                	push   %r13
  801e16:	41 54                	push   %r12
  801e18:	53                   	push   %rbx
  801e19:	48 83 ec 08          	sub    $0x8,%rsp
  801e1d:	49 89 f4             	mov    %rsi,%r12
  801e20:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e23:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e2a:	00 00 00 
  801e2d:	8b 57 0c             	mov    0xc(%rdi),%edx
  801e30:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  801e32:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  801e36:	be 00 00 00 00       	mov    $0x0,%esi
  801e3b:	bf 03 00 00 00       	mov    $0x3,%edi
  801e40:	48 b8 31 1c 80 00 00 	movabs $0x801c31,%rax
  801e47:	00 00 00 
  801e4a:	ff d0                	call   *%rax
  801e4c:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  801e4f:	4d 85 ed             	test   %r13,%r13
  801e52:	78 2a                	js     801e7e <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  801e54:	4c 89 ea             	mov    %r13,%rdx
  801e57:	4c 39 eb             	cmp    %r13,%rbx
  801e5a:	72 30                	jb     801e8c <devfile_read+0x80>
  801e5c:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  801e63:	7f 27                	jg     801e8c <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  801e65:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801e6c:	00 00 00 
  801e6f:	4c 89 e7             	mov    %r12,%rdi
  801e72:	48 b8 48 0d 80 00 00 	movabs $0x800d48,%rax
  801e79:	00 00 00 
  801e7c:	ff d0                	call   *%rax
}
  801e7e:	4c 89 e8             	mov    %r13,%rax
  801e81:	48 83 c4 08          	add    $0x8,%rsp
  801e85:	5b                   	pop    %rbx
  801e86:	41 5c                	pop    %r12
  801e88:	41 5d                	pop    %r13
  801e8a:	5d                   	pop    %rbp
  801e8b:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801e8c:	48 b9 e3 32 80 00 00 	movabs $0x8032e3,%rcx
  801e93:	00 00 00 
  801e96:	48 ba 00 33 80 00 00 	movabs $0x803300,%rdx
  801e9d:	00 00 00 
  801ea0:	be 7b 00 00 00       	mov    $0x7b,%esi
  801ea5:	48 bf 15 33 80 00 00 	movabs $0x803315,%rdi
  801eac:	00 00 00 
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb4:	49 b8 5d 2a 80 00 00 	movabs $0x802a5d,%r8
  801ebb:	00 00 00 
  801ebe:	41 ff d0             	call   *%r8

0000000000801ec1 <open>:
open(const char *path, int mode) {
  801ec1:	f3 0f 1e fa          	endbr64
  801ec5:	55                   	push   %rbp
  801ec6:	48 89 e5             	mov    %rsp,%rbp
  801ec9:	41 55                	push   %r13
  801ecb:	41 54                	push   %r12
  801ecd:	53                   	push   %rbx
  801ece:	48 83 ec 18          	sub    $0x18,%rsp
  801ed2:	49 89 fc             	mov    %rdi,%r12
  801ed5:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801ed8:	48 b8 e8 0a 80 00 00 	movabs $0x800ae8,%rax
  801edf:	00 00 00 
  801ee2:	ff d0                	call   *%rax
  801ee4:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801eea:	0f 87 8a 00 00 00    	ja     801f7a <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801ef0:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801ef4:	48 b8 2c 15 80 00 00 	movabs $0x80152c,%rax
  801efb:	00 00 00 
  801efe:	ff d0                	call   *%rax
  801f00:	89 c3                	mov    %eax,%ebx
  801f02:	85 c0                	test   %eax,%eax
  801f04:	78 50                	js     801f56 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  801f06:	4c 89 e6             	mov    %r12,%rsi
  801f09:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801f10:	00 00 00 
  801f13:	48 89 df             	mov    %rbx,%rdi
  801f16:	48 b8 2d 0b 80 00 00 	movabs $0x800b2d,%rax
  801f1d:	00 00 00 
  801f20:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801f22:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f29:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801f2d:	bf 01 00 00 00       	mov    $0x1,%edi
  801f32:	48 b8 31 1c 80 00 00 	movabs $0x801c31,%rax
  801f39:	00 00 00 
  801f3c:	ff d0                	call   *%rax
  801f3e:	89 c3                	mov    %eax,%ebx
  801f40:	85 c0                	test   %eax,%eax
  801f42:	78 1f                	js     801f63 <open+0xa2>
    return fd2num(fd);
  801f44:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f48:	48 b8 f6 14 80 00 00 	movabs $0x8014f6,%rax
  801f4f:	00 00 00 
  801f52:	ff d0                	call   *%rax
  801f54:	89 c3                	mov    %eax,%ebx
}
  801f56:	89 d8                	mov    %ebx,%eax
  801f58:	48 83 c4 18          	add    $0x18,%rsp
  801f5c:	5b                   	pop    %rbx
  801f5d:	41 5c                	pop    %r12
  801f5f:	41 5d                	pop    %r13
  801f61:	5d                   	pop    %rbp
  801f62:	c3                   	ret
        fd_close(fd, 0);
  801f63:	be 00 00 00 00       	mov    $0x0,%esi
  801f68:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f6c:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  801f73:	00 00 00 
  801f76:	ff d0                	call   *%rax
        return res;
  801f78:	eb dc                	jmp    801f56 <open+0x95>
        return -E_BAD_PATH;
  801f7a:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801f7f:	eb d5                	jmp    801f56 <open+0x95>

0000000000801f81 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801f81:	f3 0f 1e fa          	endbr64
  801f85:	55                   	push   %rbp
  801f86:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801f89:	be 00 00 00 00       	mov    $0x0,%esi
  801f8e:	bf 08 00 00 00       	mov    $0x8,%edi
  801f93:	48 b8 31 1c 80 00 00 	movabs $0x801c31,%rax
  801f9a:	00 00 00 
  801f9d:	ff d0                	call   *%rax
}
  801f9f:	5d                   	pop    %rbp
  801fa0:	c3                   	ret

0000000000801fa1 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801fa1:	f3 0f 1e fa          	endbr64
  801fa5:	55                   	push   %rbp
  801fa6:	48 89 e5             	mov    %rsp,%rbp
  801fa9:	41 54                	push   %r12
  801fab:	53                   	push   %rbx
  801fac:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801faf:	48 b8 0c 15 80 00 00 	movabs $0x80150c,%rax
  801fb6:	00 00 00 
  801fb9:	ff d0                	call   *%rax
  801fbb:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801fbe:	48 be 20 33 80 00 00 	movabs $0x803320,%rsi
  801fc5:	00 00 00 
  801fc8:	48 89 df             	mov    %rbx,%rdi
  801fcb:	48 b8 2d 0b 80 00 00 	movabs $0x800b2d,%rax
  801fd2:	00 00 00 
  801fd5:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801fd7:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801fdc:	41 2b 04 24          	sub    (%r12),%eax
  801fe0:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801fe6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801fed:	00 00 00 
    stat->st_dev = &devpipe;
  801ff0:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801ff7:	00 00 00 
  801ffa:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802001:	b8 00 00 00 00       	mov    $0x0,%eax
  802006:	5b                   	pop    %rbx
  802007:	41 5c                	pop    %r12
  802009:	5d                   	pop    %rbp
  80200a:	c3                   	ret

000000000080200b <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80200b:	f3 0f 1e fa          	endbr64
  80200f:	55                   	push   %rbp
  802010:	48 89 e5             	mov    %rsp,%rbp
  802013:	41 54                	push   %r12
  802015:	53                   	push   %rbx
  802016:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802019:	ba 00 10 00 00       	mov    $0x1000,%edx
  80201e:	48 89 fe             	mov    %rdi,%rsi
  802021:	bf 00 00 00 00       	mov    $0x0,%edi
  802026:	49 bc 72 12 80 00 00 	movabs $0x801272,%r12
  80202d:	00 00 00 
  802030:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802033:	48 89 df             	mov    %rbx,%rdi
  802036:	48 b8 0c 15 80 00 00 	movabs $0x80150c,%rax
  80203d:	00 00 00 
  802040:	ff d0                	call   *%rax
  802042:	48 89 c6             	mov    %rax,%rsi
  802045:	ba 00 10 00 00       	mov    $0x1000,%edx
  80204a:	bf 00 00 00 00       	mov    $0x0,%edi
  80204f:	41 ff d4             	call   *%r12
}
  802052:	5b                   	pop    %rbx
  802053:	41 5c                	pop    %r12
  802055:	5d                   	pop    %rbp
  802056:	c3                   	ret

0000000000802057 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802057:	f3 0f 1e fa          	endbr64
  80205b:	55                   	push   %rbp
  80205c:	48 89 e5             	mov    %rsp,%rbp
  80205f:	41 57                	push   %r15
  802061:	41 56                	push   %r14
  802063:	41 55                	push   %r13
  802065:	41 54                	push   %r12
  802067:	53                   	push   %rbx
  802068:	48 83 ec 18          	sub    $0x18,%rsp
  80206c:	49 89 fc             	mov    %rdi,%r12
  80206f:	49 89 f5             	mov    %rsi,%r13
  802072:	49 89 d7             	mov    %rdx,%r15
  802075:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802079:	48 b8 0c 15 80 00 00 	movabs $0x80150c,%rax
  802080:	00 00 00 
  802083:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802085:	4d 85 ff             	test   %r15,%r15
  802088:	0f 84 af 00 00 00    	je     80213d <devpipe_write+0xe6>
  80208e:	48 89 c3             	mov    %rax,%rbx
  802091:	4c 89 f8             	mov    %r15,%rax
  802094:	4d 89 ef             	mov    %r13,%r15
  802097:	4c 01 e8             	add    %r13,%rax
  80209a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80209e:	49 bd 02 11 80 00 00 	movabs $0x801102,%r13
  8020a5:	00 00 00 
            sys_yield();
  8020a8:	49 be 97 10 80 00 00 	movabs $0x801097,%r14
  8020af:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8020b2:	8b 73 04             	mov    0x4(%rbx),%esi
  8020b5:	48 63 ce             	movslq %esi,%rcx
  8020b8:	48 63 03             	movslq (%rbx),%rax
  8020bb:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8020c1:	48 39 c1             	cmp    %rax,%rcx
  8020c4:	72 2e                	jb     8020f4 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8020c6:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020cb:	48 89 da             	mov    %rbx,%rdx
  8020ce:	be 00 10 00 00       	mov    $0x1000,%esi
  8020d3:	4c 89 e7             	mov    %r12,%rdi
  8020d6:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8020d9:	85 c0                	test   %eax,%eax
  8020db:	74 66                	je     802143 <devpipe_write+0xec>
            sys_yield();
  8020dd:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8020e0:	8b 73 04             	mov    0x4(%rbx),%esi
  8020e3:	48 63 ce             	movslq %esi,%rcx
  8020e6:	48 63 03             	movslq (%rbx),%rax
  8020e9:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8020ef:	48 39 c1             	cmp    %rax,%rcx
  8020f2:	73 d2                	jae    8020c6 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020f4:	41 0f b6 3f          	movzbl (%r15),%edi
  8020f8:	48 89 ca             	mov    %rcx,%rdx
  8020fb:	48 c1 ea 03          	shr    $0x3,%rdx
  8020ff:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802106:	08 10 20 
  802109:	48 f7 e2             	mul    %rdx
  80210c:	48 c1 ea 06          	shr    $0x6,%rdx
  802110:	48 89 d0             	mov    %rdx,%rax
  802113:	48 c1 e0 09          	shl    $0x9,%rax
  802117:	48 29 d0             	sub    %rdx,%rax
  80211a:	48 c1 e0 03          	shl    $0x3,%rax
  80211e:	48 29 c1             	sub    %rax,%rcx
  802121:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802126:	83 c6 01             	add    $0x1,%esi
  802129:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80212c:	49 83 c7 01          	add    $0x1,%r15
  802130:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802134:	49 39 c7             	cmp    %rax,%r15
  802137:	0f 85 75 ff ff ff    	jne    8020b2 <devpipe_write+0x5b>
    return n;
  80213d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802141:	eb 05                	jmp    802148 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802143:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802148:	48 83 c4 18          	add    $0x18,%rsp
  80214c:	5b                   	pop    %rbx
  80214d:	41 5c                	pop    %r12
  80214f:	41 5d                	pop    %r13
  802151:	41 5e                	pop    %r14
  802153:	41 5f                	pop    %r15
  802155:	5d                   	pop    %rbp
  802156:	c3                   	ret

0000000000802157 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802157:	f3 0f 1e fa          	endbr64
  80215b:	55                   	push   %rbp
  80215c:	48 89 e5             	mov    %rsp,%rbp
  80215f:	41 57                	push   %r15
  802161:	41 56                	push   %r14
  802163:	41 55                	push   %r13
  802165:	41 54                	push   %r12
  802167:	53                   	push   %rbx
  802168:	48 83 ec 18          	sub    $0x18,%rsp
  80216c:	49 89 fc             	mov    %rdi,%r12
  80216f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802173:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802177:	48 b8 0c 15 80 00 00 	movabs $0x80150c,%rax
  80217e:	00 00 00 
  802181:	ff d0                	call   *%rax
  802183:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802186:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80218c:	49 bd 02 11 80 00 00 	movabs $0x801102,%r13
  802193:	00 00 00 
            sys_yield();
  802196:	49 be 97 10 80 00 00 	movabs $0x801097,%r14
  80219d:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8021a0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8021a5:	74 7d                	je     802224 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8021a7:	8b 03                	mov    (%rbx),%eax
  8021a9:	3b 43 04             	cmp    0x4(%rbx),%eax
  8021ac:	75 26                	jne    8021d4 <devpipe_read+0x7d>
            if (i > 0) return i;
  8021ae:	4d 85 ff             	test   %r15,%r15
  8021b1:	75 77                	jne    80222a <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021b3:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021b8:	48 89 da             	mov    %rbx,%rdx
  8021bb:	be 00 10 00 00       	mov    $0x1000,%esi
  8021c0:	4c 89 e7             	mov    %r12,%rdi
  8021c3:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	74 72                	je     80223c <devpipe_read+0xe5>
            sys_yield();
  8021ca:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8021cd:	8b 03                	mov    (%rbx),%eax
  8021cf:	3b 43 04             	cmp    0x4(%rbx),%eax
  8021d2:	74 df                	je     8021b3 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021d4:	48 63 c8             	movslq %eax,%rcx
  8021d7:	48 89 ca             	mov    %rcx,%rdx
  8021da:	48 c1 ea 03          	shr    $0x3,%rdx
  8021de:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8021e5:	08 10 20 
  8021e8:	48 89 d0             	mov    %rdx,%rax
  8021eb:	48 f7 e6             	mul    %rsi
  8021ee:	48 c1 ea 06          	shr    $0x6,%rdx
  8021f2:	48 89 d0             	mov    %rdx,%rax
  8021f5:	48 c1 e0 09          	shl    $0x9,%rax
  8021f9:	48 29 d0             	sub    %rdx,%rax
  8021fc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802203:	00 
  802204:	48 89 c8             	mov    %rcx,%rax
  802207:	48 29 d0             	sub    %rdx,%rax
  80220a:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80220f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802213:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802217:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80221a:	49 83 c7 01          	add    $0x1,%r15
  80221e:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802222:	75 83                	jne    8021a7 <devpipe_read+0x50>
    return n;
  802224:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802228:	eb 03                	jmp    80222d <devpipe_read+0xd6>
            if (i > 0) return i;
  80222a:	4c 89 f8             	mov    %r15,%rax
}
  80222d:	48 83 c4 18          	add    $0x18,%rsp
  802231:	5b                   	pop    %rbx
  802232:	41 5c                	pop    %r12
  802234:	41 5d                	pop    %r13
  802236:	41 5e                	pop    %r14
  802238:	41 5f                	pop    %r15
  80223a:	5d                   	pop    %rbp
  80223b:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  80223c:	b8 00 00 00 00       	mov    $0x0,%eax
  802241:	eb ea                	jmp    80222d <devpipe_read+0xd6>

0000000000802243 <pipe>:
pipe(int pfd[2]) {
  802243:	f3 0f 1e fa          	endbr64
  802247:	55                   	push   %rbp
  802248:	48 89 e5             	mov    %rsp,%rbp
  80224b:	41 55                	push   %r13
  80224d:	41 54                	push   %r12
  80224f:	53                   	push   %rbx
  802250:	48 83 ec 18          	sub    $0x18,%rsp
  802254:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802257:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80225b:	48 b8 2c 15 80 00 00 	movabs $0x80152c,%rax
  802262:	00 00 00 
  802265:	ff d0                	call   *%rax
  802267:	89 c3                	mov    %eax,%ebx
  802269:	85 c0                	test   %eax,%eax
  80226b:	0f 88 a0 01 00 00    	js     802411 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802271:	b9 46 00 00 00       	mov    $0x46,%ecx
  802276:	ba 00 10 00 00       	mov    $0x1000,%edx
  80227b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80227f:	bf 00 00 00 00       	mov    $0x0,%edi
  802284:	48 b8 32 11 80 00 00 	movabs $0x801132,%rax
  80228b:	00 00 00 
  80228e:	ff d0                	call   *%rax
  802290:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802292:	85 c0                	test   %eax,%eax
  802294:	0f 88 77 01 00 00    	js     802411 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80229a:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80229e:	48 b8 2c 15 80 00 00 	movabs $0x80152c,%rax
  8022a5:	00 00 00 
  8022a8:	ff d0                	call   *%rax
  8022aa:	89 c3                	mov    %eax,%ebx
  8022ac:	85 c0                	test   %eax,%eax
  8022ae:	0f 88 43 01 00 00    	js     8023f7 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8022b4:	b9 46 00 00 00       	mov    $0x46,%ecx
  8022b9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022be:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c7:	48 b8 32 11 80 00 00 	movabs $0x801132,%rax
  8022ce:	00 00 00 
  8022d1:	ff d0                	call   *%rax
  8022d3:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	0f 88 1a 01 00 00    	js     8023f7 <pipe+0x1b4>
    va = fd2data(fd0);
  8022dd:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022e1:	48 b8 0c 15 80 00 00 	movabs $0x80150c,%rax
  8022e8:	00 00 00 
  8022eb:	ff d0                	call   *%rax
  8022ed:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8022f0:	b9 46 00 00 00       	mov    $0x46,%ecx
  8022f5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022fa:	48 89 c6             	mov    %rax,%rsi
  8022fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802302:	48 b8 32 11 80 00 00 	movabs $0x801132,%rax
  802309:	00 00 00 
  80230c:	ff d0                	call   *%rax
  80230e:	89 c3                	mov    %eax,%ebx
  802310:	85 c0                	test   %eax,%eax
  802312:	0f 88 c5 00 00 00    	js     8023dd <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802318:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80231c:	48 b8 0c 15 80 00 00 	movabs $0x80150c,%rax
  802323:	00 00 00 
  802326:	ff d0                	call   *%rax
  802328:	48 89 c1             	mov    %rax,%rcx
  80232b:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802331:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802337:	ba 00 00 00 00       	mov    $0x0,%edx
  80233c:	4c 89 ee             	mov    %r13,%rsi
  80233f:	bf 00 00 00 00       	mov    $0x0,%edi
  802344:	48 b8 9d 11 80 00 00 	movabs $0x80119d,%rax
  80234b:	00 00 00 
  80234e:	ff d0                	call   *%rax
  802350:	89 c3                	mov    %eax,%ebx
  802352:	85 c0                	test   %eax,%eax
  802354:	78 6e                	js     8023c4 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802356:	be 00 10 00 00       	mov    $0x1000,%esi
  80235b:	4c 89 ef             	mov    %r13,%rdi
  80235e:	48 b8 cc 10 80 00 00 	movabs $0x8010cc,%rax
  802365:	00 00 00 
  802368:	ff d0                	call   *%rax
  80236a:	83 f8 02             	cmp    $0x2,%eax
  80236d:	0f 85 ab 00 00 00    	jne    80241e <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802373:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80237a:	00 00 
  80237c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802380:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802382:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802386:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80238d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802391:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802393:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802397:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80239e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023a2:	48 bb f6 14 80 00 00 	movabs $0x8014f6,%rbx
  8023a9:	00 00 00 
  8023ac:	ff d3                	call   *%rbx
  8023ae:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8023b2:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8023b6:	ff d3                	call   *%rbx
  8023b8:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8023bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023c2:	eb 4d                	jmp    802411 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8023c4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023c9:	4c 89 ee             	mov    %r13,%rsi
  8023cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8023d1:	48 b8 72 12 80 00 00 	movabs $0x801272,%rax
  8023d8:	00 00 00 
  8023db:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8023dd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023e2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8023eb:	48 b8 72 12 80 00 00 	movabs $0x801272,%rax
  8023f2:	00 00 00 
  8023f5:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8023f7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023fc:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802400:	bf 00 00 00 00       	mov    $0x0,%edi
  802405:	48 b8 72 12 80 00 00 	movabs $0x801272,%rax
  80240c:	00 00 00 
  80240f:	ff d0                	call   *%rax
}
  802411:	89 d8                	mov    %ebx,%eax
  802413:	48 83 c4 18          	add    $0x18,%rsp
  802417:	5b                   	pop    %rbx
  802418:	41 5c                	pop    %r12
  80241a:	41 5d                	pop    %r13
  80241c:	5d                   	pop    %rbp
  80241d:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80241e:	48 b9 b8 30 80 00 00 	movabs $0x8030b8,%rcx
  802425:	00 00 00 
  802428:	48 ba 00 33 80 00 00 	movabs $0x803300,%rdx
  80242f:	00 00 00 
  802432:	be 2e 00 00 00       	mov    $0x2e,%esi
  802437:	48 bf 27 33 80 00 00 	movabs $0x803327,%rdi
  80243e:	00 00 00 
  802441:	b8 00 00 00 00       	mov    $0x0,%eax
  802446:	49 b8 5d 2a 80 00 00 	movabs $0x802a5d,%r8
  80244d:	00 00 00 
  802450:	41 ff d0             	call   *%r8

0000000000802453 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802453:	f3 0f 1e fa          	endbr64
  802457:	55                   	push   %rbp
  802458:	48 89 e5             	mov    %rsp,%rbp
  80245b:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80245f:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802463:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  80246a:	00 00 00 
  80246d:	ff d0                	call   *%rax
    if (res < 0) return res;
  80246f:	85 c0                	test   %eax,%eax
  802471:	78 35                	js     8024a8 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802473:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802477:	48 b8 0c 15 80 00 00 	movabs $0x80150c,%rax
  80247e:	00 00 00 
  802481:	ff d0                	call   *%rax
  802483:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802486:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80248b:	be 00 10 00 00       	mov    $0x1000,%esi
  802490:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802494:	48 b8 02 11 80 00 00 	movabs $0x801102,%rax
  80249b:	00 00 00 
  80249e:	ff d0                	call   *%rax
  8024a0:	85 c0                	test   %eax,%eax
  8024a2:	0f 94 c0             	sete   %al
  8024a5:	0f b6 c0             	movzbl %al,%eax
}
  8024a8:	c9                   	leave
  8024a9:	c3                   	ret

00000000008024aa <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8024aa:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8024ae:	48 89 f8             	mov    %rdi,%rax
  8024b1:	48 c1 e8 27          	shr    $0x27,%rax
  8024b5:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8024bc:	7f 00 00 
  8024bf:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024c3:	f6 c2 01             	test   $0x1,%dl
  8024c6:	74 6d                	je     802535 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8024c8:	48 89 f8             	mov    %rdi,%rax
  8024cb:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024cf:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8024d6:	7f 00 00 
  8024d9:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024dd:	f6 c2 01             	test   $0x1,%dl
  8024e0:	74 62                	je     802544 <get_uvpt_entry+0x9a>
  8024e2:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8024e9:	7f 00 00 
  8024ec:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024f0:	f6 c2 80             	test   $0x80,%dl
  8024f3:	75 4f                	jne    802544 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8024f5:	48 89 f8             	mov    %rdi,%rax
  8024f8:	48 c1 e8 15          	shr    $0x15,%rax
  8024fc:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802503:	7f 00 00 
  802506:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80250a:	f6 c2 01             	test   $0x1,%dl
  80250d:	74 44                	je     802553 <get_uvpt_entry+0xa9>
  80250f:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802516:	7f 00 00 
  802519:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80251d:	f6 c2 80             	test   $0x80,%dl
  802520:	75 31                	jne    802553 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802522:	48 c1 ef 0c          	shr    $0xc,%rdi
  802526:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80252d:	7f 00 00 
  802530:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802534:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802535:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80253c:	7f 00 00 
  80253f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802543:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802544:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80254b:	7f 00 00 
  80254e:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802552:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802553:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80255a:	7f 00 00 
  80255d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802561:	c3                   	ret

0000000000802562 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802562:	f3 0f 1e fa          	endbr64
  802566:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802569:	48 89 f9             	mov    %rdi,%rcx
  80256c:	48 c1 e9 27          	shr    $0x27,%rcx
  802570:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802577:	7f 00 00 
  80257a:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  80257e:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802585:	f6 c1 01             	test   $0x1,%cl
  802588:	0f 84 b2 00 00 00    	je     802640 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80258e:	48 89 f9             	mov    %rdi,%rcx
  802591:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802595:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80259c:	7f 00 00 
  80259f:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8025a3:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8025aa:	40 f6 c6 01          	test   $0x1,%sil
  8025ae:	0f 84 8c 00 00 00    	je     802640 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8025b4:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8025bb:	7f 00 00 
  8025be:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8025c2:	a8 80                	test   $0x80,%al
  8025c4:	75 7b                	jne    802641 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8025c6:	48 89 f9             	mov    %rdi,%rcx
  8025c9:	48 c1 e9 15          	shr    $0x15,%rcx
  8025cd:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8025d4:	7f 00 00 
  8025d7:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8025db:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  8025e2:	40 f6 c6 01          	test   $0x1,%sil
  8025e6:	74 58                	je     802640 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  8025e8:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8025ef:	7f 00 00 
  8025f2:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8025f6:	a8 80                	test   $0x80,%al
  8025f8:	75 6c                	jne    802666 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  8025fa:	48 89 f9             	mov    %rdi,%rcx
  8025fd:	48 c1 e9 0c          	shr    $0xc,%rcx
  802601:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802608:	7f 00 00 
  80260b:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80260f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802616:	40 f6 c6 01          	test   $0x1,%sil
  80261a:	74 24                	je     802640 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  80261c:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802623:	7f 00 00 
  802626:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80262a:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802631:	ff ff 7f 
  802634:	48 21 c8             	and    %rcx,%rax
  802637:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80263d:	48 09 d0             	or     %rdx,%rax
}
  802640:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802641:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802648:	7f 00 00 
  80264b:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80264f:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802656:	ff ff 7f 
  802659:	48 21 c8             	and    %rcx,%rax
  80265c:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802662:	48 01 d0             	add    %rdx,%rax
  802665:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802666:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80266d:	7f 00 00 
  802670:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802674:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80267b:	ff ff 7f 
  80267e:	48 21 c8             	and    %rcx,%rax
  802681:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802687:	48 01 d0             	add    %rdx,%rax
  80268a:	c3                   	ret

000000000080268b <get_prot>:

int
get_prot(void *va) {
  80268b:	f3 0f 1e fa          	endbr64
  80268f:	55                   	push   %rbp
  802690:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802693:	48 b8 aa 24 80 00 00 	movabs $0x8024aa,%rax
  80269a:	00 00 00 
  80269d:	ff d0                	call   *%rax
  80269f:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8026a2:	83 e0 01             	and    $0x1,%eax
  8026a5:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8026a8:	89 d1                	mov    %edx,%ecx
  8026aa:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8026b0:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8026b2:	89 c1                	mov    %eax,%ecx
  8026b4:	83 c9 02             	or     $0x2,%ecx
  8026b7:	f6 c2 02             	test   $0x2,%dl
  8026ba:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8026bd:	89 c1                	mov    %eax,%ecx
  8026bf:	83 c9 01             	or     $0x1,%ecx
  8026c2:	48 85 d2             	test   %rdx,%rdx
  8026c5:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8026c8:	89 c1                	mov    %eax,%ecx
  8026ca:	83 c9 40             	or     $0x40,%ecx
  8026cd:	f6 c6 04             	test   $0x4,%dh
  8026d0:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8026d3:	5d                   	pop    %rbp
  8026d4:	c3                   	ret

00000000008026d5 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8026d5:	f3 0f 1e fa          	endbr64
  8026d9:	55                   	push   %rbp
  8026da:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8026dd:	48 b8 aa 24 80 00 00 	movabs $0x8024aa,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	call   *%rax
    return pte & PTE_D;
  8026e9:	48 c1 e8 06          	shr    $0x6,%rax
  8026ed:	83 e0 01             	and    $0x1,%eax
}
  8026f0:	5d                   	pop    %rbp
  8026f1:	c3                   	ret

00000000008026f2 <is_page_present>:

bool
is_page_present(void *va) {
  8026f2:	f3 0f 1e fa          	endbr64
  8026f6:	55                   	push   %rbp
  8026f7:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8026fa:	48 b8 aa 24 80 00 00 	movabs $0x8024aa,%rax
  802701:	00 00 00 
  802704:	ff d0                	call   *%rax
  802706:	83 e0 01             	and    $0x1,%eax
}
  802709:	5d                   	pop    %rbp
  80270a:	c3                   	ret

000000000080270b <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80270b:	f3 0f 1e fa          	endbr64
  80270f:	55                   	push   %rbp
  802710:	48 89 e5             	mov    %rsp,%rbp
  802713:	41 57                	push   %r15
  802715:	41 56                	push   %r14
  802717:	41 55                	push   %r13
  802719:	41 54                	push   %r12
  80271b:	53                   	push   %rbx
  80271c:	48 83 ec 18          	sub    $0x18,%rsp
  802720:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802724:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802728:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  80272d:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802734:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802737:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  80273e:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802741:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802748:	00 00 00 
  80274b:	eb 73                	jmp    8027c0 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  80274d:	48 89 d8             	mov    %rbx,%rax
  802750:	48 c1 e8 15          	shr    $0x15,%rax
  802754:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  80275b:	7f 00 00 
  80275e:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802762:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802768:	f6 c2 01             	test   $0x1,%dl
  80276b:	74 4b                	je     8027b8 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  80276d:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802771:	f6 c2 80             	test   $0x80,%dl
  802774:	74 11                	je     802787 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802776:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  80277a:	f6 c4 04             	test   $0x4,%ah
  80277d:	74 39                	je     8027b8 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  80277f:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802785:	eb 20                	jmp    8027a7 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802787:	48 89 da             	mov    %rbx,%rdx
  80278a:	48 c1 ea 0c          	shr    $0xc,%rdx
  80278e:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802795:	7f 00 00 
  802798:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  80279c:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8027a2:	f6 c4 04             	test   $0x4,%ah
  8027a5:	74 11                	je     8027b8 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  8027a7:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  8027ab:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8027af:	48 89 df             	mov    %rbx,%rdi
  8027b2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8027b6:	ff d0                	call   *%rax
    next:
        va += size;
  8027b8:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  8027bb:	49 39 df             	cmp    %rbx,%r15
  8027be:	72 3e                	jb     8027fe <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8027c0:	49 8b 06             	mov    (%r14),%rax
  8027c3:	a8 01                	test   $0x1,%al
  8027c5:	74 37                	je     8027fe <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8027c7:	48 89 d8             	mov    %rbx,%rax
  8027ca:	48 c1 e8 1e          	shr    $0x1e,%rax
  8027ce:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  8027d3:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8027d9:	f6 c2 01             	test   $0x1,%dl
  8027dc:	74 da                	je     8027b8 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  8027de:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  8027e3:	f6 c2 80             	test   $0x80,%dl
  8027e6:	0f 84 61 ff ff ff    	je     80274d <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  8027ec:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8027f1:	f6 c4 04             	test   $0x4,%ah
  8027f4:	74 c2                	je     8027b8 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  8027f6:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  8027fc:	eb a9                	jmp    8027a7 <foreach_shared_region+0x9c>
    }
    return res;
}
  8027fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802803:	48 83 c4 18          	add    $0x18,%rsp
  802807:	5b                   	pop    %rbx
  802808:	41 5c                	pop    %r12
  80280a:	41 5d                	pop    %r13
  80280c:	41 5e                	pop    %r14
  80280e:	41 5f                	pop    %r15
  802810:	5d                   	pop    %rbp
  802811:	c3                   	ret

0000000000802812 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802812:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802816:	b8 00 00 00 00       	mov    $0x0,%eax
  80281b:	c3                   	ret

000000000080281c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80281c:	f3 0f 1e fa          	endbr64
  802820:	55                   	push   %rbp
  802821:	48 89 e5             	mov    %rsp,%rbp
  802824:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802827:	48 be 37 33 80 00 00 	movabs $0x803337,%rsi
  80282e:	00 00 00 
  802831:	48 b8 2d 0b 80 00 00 	movabs $0x800b2d,%rax
  802838:	00 00 00 
  80283b:	ff d0                	call   *%rax
    return 0;
}
  80283d:	b8 00 00 00 00       	mov    $0x0,%eax
  802842:	5d                   	pop    %rbp
  802843:	c3                   	ret

0000000000802844 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802844:	f3 0f 1e fa          	endbr64
  802848:	55                   	push   %rbp
  802849:	48 89 e5             	mov    %rsp,%rbp
  80284c:	41 57                	push   %r15
  80284e:	41 56                	push   %r14
  802850:	41 55                	push   %r13
  802852:	41 54                	push   %r12
  802854:	53                   	push   %rbx
  802855:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80285c:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802863:	48 85 d2             	test   %rdx,%rdx
  802866:	74 7a                	je     8028e2 <devcons_write+0x9e>
  802868:	49 89 d6             	mov    %rdx,%r14
  80286b:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802871:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802876:	49 bf 48 0d 80 00 00 	movabs $0x800d48,%r15
  80287d:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802880:	4c 89 f3             	mov    %r14,%rbx
  802883:	48 29 f3             	sub    %rsi,%rbx
  802886:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80288b:	48 39 c3             	cmp    %rax,%rbx
  80288e:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802892:	4c 63 eb             	movslq %ebx,%r13
  802895:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80289c:	48 01 c6             	add    %rax,%rsi
  80289f:	4c 89 ea             	mov    %r13,%rdx
  8028a2:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8028a9:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8028ac:	4c 89 ee             	mov    %r13,%rsi
  8028af:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8028b6:	48 b8 8d 0f 80 00 00 	movabs $0x800f8d,%rax
  8028bd:	00 00 00 
  8028c0:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8028c2:	41 01 dc             	add    %ebx,%r12d
  8028c5:	49 63 f4             	movslq %r12d,%rsi
  8028c8:	4c 39 f6             	cmp    %r14,%rsi
  8028cb:	72 b3                	jb     802880 <devcons_write+0x3c>
    return res;
  8028cd:	49 63 c4             	movslq %r12d,%rax
}
  8028d0:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8028d7:	5b                   	pop    %rbx
  8028d8:	41 5c                	pop    %r12
  8028da:	41 5d                	pop    %r13
  8028dc:	41 5e                	pop    %r14
  8028de:	41 5f                	pop    %r15
  8028e0:	5d                   	pop    %rbp
  8028e1:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  8028e2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8028e8:	eb e3                	jmp    8028cd <devcons_write+0x89>

00000000008028ea <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8028ea:	f3 0f 1e fa          	endbr64
  8028ee:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8028f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8028f6:	48 85 c0             	test   %rax,%rax
  8028f9:	74 55                	je     802950 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8028fb:	55                   	push   %rbp
  8028fc:	48 89 e5             	mov    %rsp,%rbp
  8028ff:	41 55                	push   %r13
  802901:	41 54                	push   %r12
  802903:	53                   	push   %rbx
  802904:	48 83 ec 08          	sub    $0x8,%rsp
  802908:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  80290b:	48 bb be 0f 80 00 00 	movabs $0x800fbe,%rbx
  802912:	00 00 00 
  802915:	49 bc 97 10 80 00 00 	movabs $0x801097,%r12
  80291c:	00 00 00 
  80291f:	eb 03                	jmp    802924 <devcons_read+0x3a>
  802921:	41 ff d4             	call   *%r12
  802924:	ff d3                	call   *%rbx
  802926:	85 c0                	test   %eax,%eax
  802928:	74 f7                	je     802921 <devcons_read+0x37>
    if (c < 0) return c;
  80292a:	48 63 d0             	movslq %eax,%rdx
  80292d:	78 13                	js     802942 <devcons_read+0x58>
    if (c == 0x04) return 0;
  80292f:	ba 00 00 00 00       	mov    $0x0,%edx
  802934:	83 f8 04             	cmp    $0x4,%eax
  802937:	74 09                	je     802942 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802939:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80293d:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802942:	48 89 d0             	mov    %rdx,%rax
  802945:	48 83 c4 08          	add    $0x8,%rsp
  802949:	5b                   	pop    %rbx
  80294a:	41 5c                	pop    %r12
  80294c:	41 5d                	pop    %r13
  80294e:	5d                   	pop    %rbp
  80294f:	c3                   	ret
  802950:	48 89 d0             	mov    %rdx,%rax
  802953:	c3                   	ret

0000000000802954 <cputchar>:
cputchar(int ch) {
  802954:	f3 0f 1e fa          	endbr64
  802958:	55                   	push   %rbp
  802959:	48 89 e5             	mov    %rsp,%rbp
  80295c:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802960:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802964:	be 01 00 00 00       	mov    $0x1,%esi
  802969:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80296d:	48 b8 8d 0f 80 00 00 	movabs $0x800f8d,%rax
  802974:	00 00 00 
  802977:	ff d0                	call   *%rax
}
  802979:	c9                   	leave
  80297a:	c3                   	ret

000000000080297b <getchar>:
getchar(void) {
  80297b:	f3 0f 1e fa          	endbr64
  80297f:	55                   	push   %rbp
  802980:	48 89 e5             	mov    %rsp,%rbp
  802983:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802987:	ba 01 00 00 00       	mov    $0x1,%edx
  80298c:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802990:	bf 00 00 00 00       	mov    $0x0,%edi
  802995:	48 b8 8b 18 80 00 00 	movabs $0x80188b,%rax
  80299c:	00 00 00 
  80299f:	ff d0                	call   *%rax
  8029a1:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8029a3:	85 c0                	test   %eax,%eax
  8029a5:	78 06                	js     8029ad <getchar+0x32>
  8029a7:	74 08                	je     8029b1 <getchar+0x36>
  8029a9:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8029ad:	89 d0                	mov    %edx,%eax
  8029af:	c9                   	leave
  8029b0:	c3                   	ret
    return res < 0 ? res : res ? c :
  8029b1:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8029b6:	eb f5                	jmp    8029ad <getchar+0x32>

00000000008029b8 <iscons>:
iscons(int fdnum) {
  8029b8:	f3 0f 1e fa          	endbr64
  8029bc:	55                   	push   %rbp
  8029bd:	48 89 e5             	mov    %rsp,%rbp
  8029c0:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8029c4:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8029c8:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  8029cf:	00 00 00 
  8029d2:	ff d0                	call   *%rax
    if (res < 0) return res;
  8029d4:	85 c0                	test   %eax,%eax
  8029d6:	78 18                	js     8029f0 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  8029d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029dc:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8029e3:	00 00 00 
  8029e6:	8b 00                	mov    (%rax),%eax
  8029e8:	39 02                	cmp    %eax,(%rdx)
  8029ea:	0f 94 c0             	sete   %al
  8029ed:	0f b6 c0             	movzbl %al,%eax
}
  8029f0:	c9                   	leave
  8029f1:	c3                   	ret

00000000008029f2 <opencons>:
opencons(void) {
  8029f2:	f3 0f 1e fa          	endbr64
  8029f6:	55                   	push   %rbp
  8029f7:	48 89 e5             	mov    %rsp,%rbp
  8029fa:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8029fe:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802a02:	48 b8 2c 15 80 00 00 	movabs $0x80152c,%rax
  802a09:	00 00 00 
  802a0c:	ff d0                	call   *%rax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	78 49                	js     802a5b <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802a12:	b9 46 00 00 00       	mov    $0x46,%ecx
  802a17:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a1c:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802a20:	bf 00 00 00 00       	mov    $0x0,%edi
  802a25:	48 b8 32 11 80 00 00 	movabs $0x801132,%rax
  802a2c:	00 00 00 
  802a2f:	ff d0                	call   *%rax
  802a31:	85 c0                	test   %eax,%eax
  802a33:	78 26                	js     802a5b <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802a35:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a39:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802a40:	00 00 
  802a42:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802a44:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802a48:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802a4f:	48 b8 f6 14 80 00 00 	movabs $0x8014f6,%rax
  802a56:	00 00 00 
  802a59:	ff d0                	call   *%rax
}
  802a5b:	c9                   	leave
  802a5c:	c3                   	ret

0000000000802a5d <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802a5d:	f3 0f 1e fa          	endbr64
  802a61:	55                   	push   %rbp
  802a62:	48 89 e5             	mov    %rsp,%rbp
  802a65:	41 56                	push   %r14
  802a67:	41 55                	push   %r13
  802a69:	41 54                	push   %r12
  802a6b:	53                   	push   %rbx
  802a6c:	48 83 ec 50          	sub    $0x50,%rsp
  802a70:	49 89 fc             	mov    %rdi,%r12
  802a73:	41 89 f5             	mov    %esi,%r13d
  802a76:	48 89 d3             	mov    %rdx,%rbx
  802a79:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802a7d:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802a81:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802a85:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802a8c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a90:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802a94:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802a98:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802a9c:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802aa3:	00 00 00 
  802aa6:	4c 8b 30             	mov    (%rax),%r14
  802aa9:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  802ab0:	00 00 00 
  802ab3:	ff d0                	call   *%rax
  802ab5:	89 c6                	mov    %eax,%esi
  802ab7:	45 89 e8             	mov    %r13d,%r8d
  802aba:	4c 89 e1             	mov    %r12,%rcx
  802abd:	4c 89 f2             	mov    %r14,%rdx
  802ac0:	48 bf e0 30 80 00 00 	movabs $0x8030e0,%rdi
  802ac7:	00 00 00 
  802aca:	b8 00 00 00 00       	mov    $0x0,%eax
  802acf:	49 bc e4 01 80 00 00 	movabs $0x8001e4,%r12
  802ad6:	00 00 00 
  802ad9:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802adc:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802ae0:	48 89 df             	mov    %rbx,%rdi
  802ae3:	48 b8 7c 01 80 00 00 	movabs $0x80017c,%rax
  802aea:	00 00 00 
  802aed:	ff d0                	call   *%rax
    cprintf("\n");
  802aef:	48 bf c4 32 80 00 00 	movabs $0x8032c4,%rdi
  802af6:	00 00 00 
  802af9:	b8 00 00 00 00       	mov    $0x0,%eax
  802afe:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802b01:	cc                   	int3
  802b02:	eb fd                	jmp    802b01 <_panic+0xa4>

0000000000802b04 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802b04:	f3 0f 1e fa          	endbr64
  802b08:	55                   	push   %rbp
  802b09:	48 89 e5             	mov    %rsp,%rbp
  802b0c:	41 54                	push   %r12
  802b0e:	53                   	push   %rbx
  802b0f:	48 89 fb             	mov    %rdi,%rbx
  802b12:	48 89 f7             	mov    %rsi,%rdi
  802b15:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b18:	48 85 f6             	test   %rsi,%rsi
  802b1b:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b22:	00 00 00 
  802b25:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b29:	be 00 10 00 00       	mov    $0x1000,%esi
  802b2e:	48 b8 54 14 80 00 00 	movabs $0x801454,%rax
  802b35:	00 00 00 
  802b38:	ff d0                	call   *%rax
    if (res < 0) {
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	78 45                	js     802b83 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b3e:	48 85 db             	test   %rbx,%rbx
  802b41:	74 12                	je     802b55 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b43:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b4a:	00 00 00 
  802b4d:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b53:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b55:	4d 85 e4             	test   %r12,%r12
  802b58:	74 14                	je     802b6e <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b5a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b61:	00 00 00 
  802b64:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b6a:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b6e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b75:	00 00 00 
  802b78:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b7e:	5b                   	pop    %rbx
  802b7f:	41 5c                	pop    %r12
  802b81:	5d                   	pop    %rbp
  802b82:	c3                   	ret
        if (from_env_store != NULL) {
  802b83:	48 85 db             	test   %rbx,%rbx
  802b86:	74 06                	je     802b8e <ipc_recv+0x8a>
            *from_env_store = 0;
  802b88:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b8e:	4d 85 e4             	test   %r12,%r12
  802b91:	74 eb                	je     802b7e <ipc_recv+0x7a>
            *perm_store = 0;
  802b93:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b9a:	00 
  802b9b:	eb e1                	jmp    802b7e <ipc_recv+0x7a>

0000000000802b9d <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b9d:	f3 0f 1e fa          	endbr64
  802ba1:	55                   	push   %rbp
  802ba2:	48 89 e5             	mov    %rsp,%rbp
  802ba5:	41 57                	push   %r15
  802ba7:	41 56                	push   %r14
  802ba9:	41 55                	push   %r13
  802bab:	41 54                	push   %r12
  802bad:	53                   	push   %rbx
  802bae:	48 83 ec 18          	sub    $0x18,%rsp
  802bb2:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802bb5:	48 89 d3             	mov    %rdx,%rbx
  802bb8:	49 89 cc             	mov    %rcx,%r12
  802bbb:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802bbe:	48 85 d2             	test   %rdx,%rdx
  802bc1:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bc8:	00 00 00 
  802bcb:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bcf:	89 f0                	mov    %esi,%eax
  802bd1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802bd5:	48 89 da             	mov    %rbx,%rdx
  802bd8:	48 89 c6             	mov    %rax,%rsi
  802bdb:	48 b8 24 14 80 00 00 	movabs $0x801424,%rax
  802be2:	00 00 00 
  802be5:	ff d0                	call   *%rax
    while (res < 0) {
  802be7:	85 c0                	test   %eax,%eax
  802be9:	79 65                	jns    802c50 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802beb:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bee:	75 33                	jne    802c23 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802bf0:	49 bf 97 10 80 00 00 	movabs $0x801097,%r15
  802bf7:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bfa:	49 be 24 14 80 00 00 	movabs $0x801424,%r14
  802c01:	00 00 00 
        sys_yield();
  802c04:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c07:	45 89 e8             	mov    %r13d,%r8d
  802c0a:	4c 89 e1             	mov    %r12,%rcx
  802c0d:	48 89 da             	mov    %rbx,%rdx
  802c10:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802c14:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802c17:	41 ff d6             	call   *%r14
    while (res < 0) {
  802c1a:	85 c0                	test   %eax,%eax
  802c1c:	79 32                	jns    802c50 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c1e:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c21:	74 e1                	je     802c04 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c23:	89 c1                	mov    %eax,%ecx
  802c25:	48 ba 43 33 80 00 00 	movabs $0x803343,%rdx
  802c2c:	00 00 00 
  802c2f:	be 42 00 00 00       	mov    $0x42,%esi
  802c34:	48 bf 4e 33 80 00 00 	movabs $0x80334e,%rdi
  802c3b:	00 00 00 
  802c3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c43:	49 b8 5d 2a 80 00 00 	movabs $0x802a5d,%r8
  802c4a:	00 00 00 
  802c4d:	41 ff d0             	call   *%r8
    }
}
  802c50:	48 83 c4 18          	add    $0x18,%rsp
  802c54:	5b                   	pop    %rbx
  802c55:	41 5c                	pop    %r12
  802c57:	41 5d                	pop    %r13
  802c59:	41 5e                	pop    %r14
  802c5b:	41 5f                	pop    %r15
  802c5d:	5d                   	pop    %rbp
  802c5e:	c3                   	ret

0000000000802c5f <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c5f:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c63:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c68:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c6f:	00 00 00 
  802c72:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c76:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c7a:	48 c1 e2 04          	shl    $0x4,%rdx
  802c7e:	48 01 ca             	add    %rcx,%rdx
  802c81:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c87:	39 fa                	cmp    %edi,%edx
  802c89:	74 12                	je     802c9d <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c8b:	48 83 c0 01          	add    $0x1,%rax
  802c8f:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c95:	75 db                	jne    802c72 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c9c:	c3                   	ret
            return envs[i].env_id;
  802c9d:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802ca1:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802ca5:	48 c1 e2 04          	shl    $0x4,%rdx
  802ca9:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802cb0:	00 00 00 
  802cb3:	48 01 d0             	add    %rdx,%rax
  802cb6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cbc:	c3                   	ret

0000000000802cbd <__text_end>:
  802cbd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cc4:	00 00 00 
  802cc7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cce:	00 00 00 
  802cd1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cd8:	00 00 00 
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
