
obj/user/divzero:     file format elf64-x86-64


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
  80001e:	e8 41 00 00 00       	call   800064 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

volatile int zero;

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
    cprintf("1337/0 is %08x!\n", 1337 / zero);
  80002d:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800034:	00 00 00 
  800037:	8b 08                	mov    (%rax),%ecx
  800039:	b8 39 05 00 00       	mov    $0x539,%eax
  80003e:	ba 00 00 00 00       	mov    $0x0,%edx
  800043:	f7 f9                	idiv   %ecx
  800045:	89 c6                	mov    %eax,%esi
  800047:	48 bf 00 30 80 00 00 	movabs $0x803000,%rdi
  80004e:	00 00 00 
  800051:	b8 00 00 00 00       	mov    $0x0,%eax
  800056:	48 ba f2 01 80 00 00 	movabs $0x8001f2,%rdx
  80005d:	00 00 00 
  800060:	ff d2                	call   *%rdx
}
  800062:	5d                   	pop    %rbp
  800063:	c3                   	ret

0000000000800064 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800064:	f3 0f 1e fa          	endbr64
  800068:	55                   	push   %rbp
  800069:	48 89 e5             	mov    %rsp,%rbp
  80006c:	41 56                	push   %r14
  80006e:	41 55                	push   %r13
  800070:	41 54                	push   %r12
  800072:	53                   	push   %rbx
  800073:	41 89 fd             	mov    %edi,%r13d
  800076:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800079:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800080:	00 00 00 
  800083:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80008a:	00 00 00 
  80008d:	48 39 c2             	cmp    %rax,%rdx
  800090:	73 17                	jae    8000a9 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800092:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800095:	49 89 c4             	mov    %rax,%r12
  800098:	48 83 c3 08          	add    $0x8,%rbx
  80009c:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a1:	ff 53 f8             	call   *-0x8(%rbx)
  8000a4:	4c 39 e3             	cmp    %r12,%rbx
  8000a7:	72 ef                	jb     800098 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8000a9:	48 b8 70 10 80 00 00 	movabs $0x801070,%rax
  8000b0:	00 00 00 
  8000b3:	ff d0                	call   *%rax
  8000b5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ba:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000be:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000c2:	48 c1 e0 04          	shl    $0x4,%rax
  8000c6:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000cd:	00 00 00 
  8000d0:	48 01 d0             	add    %rdx,%rax
  8000d3:	48 a3 08 50 80 00 00 	movabs %rax,0x805008
  8000da:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000dd:	45 85 ed             	test   %r13d,%r13d
  8000e0:	7e 0d                	jle    8000ef <libmain+0x8b>
  8000e2:	49 8b 06             	mov    (%r14),%rax
  8000e5:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000ec:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000ef:	4c 89 f6             	mov    %r14,%rsi
  8000f2:	44 89 ef             	mov    %r13d,%edi
  8000f5:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000fc:	00 00 00 
  8000ff:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800101:	48 b8 16 01 80 00 00 	movabs $0x800116,%rax
  800108:	00 00 00 
  80010b:	ff d0                	call   *%rax
#endif
}
  80010d:	5b                   	pop    %rbx
  80010e:	41 5c                	pop    %r12
  800110:	41 5d                	pop    %r13
  800112:	41 5e                	pop    %r14
  800114:	5d                   	pop    %rbp
  800115:	c3                   	ret

0000000000800116 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800116:	f3 0f 1e fa          	endbr64
  80011a:	55                   	push   %rbp
  80011b:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80011e:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  800125:	00 00 00 
  800128:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80012a:	bf 00 00 00 00       	mov    $0x0,%edi
  80012f:	48 b8 01 10 80 00 00 	movabs $0x801001,%rax
  800136:	00 00 00 
  800139:	ff d0                	call   *%rax
}
  80013b:	5d                   	pop    %rbp
  80013c:	c3                   	ret

000000000080013d <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80013d:	f3 0f 1e fa          	endbr64
  800141:	55                   	push   %rbp
  800142:	48 89 e5             	mov    %rsp,%rbp
  800145:	53                   	push   %rbx
  800146:	48 83 ec 08          	sub    $0x8,%rsp
  80014a:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80014d:	8b 06                	mov    (%rsi),%eax
  80014f:	8d 50 01             	lea    0x1(%rax),%edx
  800152:	89 16                	mov    %edx,(%rsi)
  800154:	48 98                	cltq
  800156:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80015b:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800161:	74 0a                	je     80016d <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800163:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800167:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80016b:	c9                   	leave
  80016c:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80016d:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800171:	be ff 00 00 00       	mov    $0xff,%esi
  800176:	48 b8 9b 0f 80 00 00 	movabs $0x800f9b,%rax
  80017d:	00 00 00 
  800180:	ff d0                	call   *%rax
        state->offset = 0;
  800182:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800188:	eb d9                	jmp    800163 <putch+0x26>

000000000080018a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80018a:	f3 0f 1e fa          	endbr64
  80018e:	55                   	push   %rbp
  80018f:	48 89 e5             	mov    %rsp,%rbp
  800192:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800199:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80019c:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8001a3:	b9 21 00 00 00       	mov    $0x21,%ecx
  8001a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ad:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8001b0:	48 89 f1             	mov    %rsi,%rcx
  8001b3:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8001ba:	48 bf 3d 01 80 00 00 	movabs $0x80013d,%rdi
  8001c1:	00 00 00 
  8001c4:	48 b8 52 03 80 00 00 	movabs $0x800352,%rax
  8001cb:	00 00 00 
  8001ce:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8001d0:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8001d7:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8001de:	48 b8 9b 0f 80 00 00 	movabs $0x800f9b,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	call   *%rax

    return state.count;
}
  8001ea:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8001f0:	c9                   	leave
  8001f1:	c3                   	ret

00000000008001f2 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8001f2:	f3 0f 1e fa          	endbr64
  8001f6:	55                   	push   %rbp
  8001f7:	48 89 e5             	mov    %rsp,%rbp
  8001fa:	48 83 ec 50          	sub    $0x50,%rsp
  8001fe:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800202:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800206:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80020a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80020e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800212:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800219:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80021d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800221:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800225:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800229:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80022d:	48 b8 8a 01 80 00 00 	movabs $0x80018a,%rax
  800234:	00 00 00 
  800237:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800239:	c9                   	leave
  80023a:	c3                   	ret

000000000080023b <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80023b:	f3 0f 1e fa          	endbr64
  80023f:	55                   	push   %rbp
  800240:	48 89 e5             	mov    %rsp,%rbp
  800243:	41 57                	push   %r15
  800245:	41 56                	push   %r14
  800247:	41 55                	push   %r13
  800249:	41 54                	push   %r12
  80024b:	53                   	push   %rbx
  80024c:	48 83 ec 18          	sub    $0x18,%rsp
  800250:	49 89 fc             	mov    %rdi,%r12
  800253:	49 89 f5             	mov    %rsi,%r13
  800256:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80025a:	8b 45 10             	mov    0x10(%rbp),%eax
  80025d:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800260:	41 89 cf             	mov    %ecx,%r15d
  800263:	4c 39 fa             	cmp    %r15,%rdx
  800266:	73 5b                	jae    8002c3 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800268:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80026c:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800270:	85 db                	test   %ebx,%ebx
  800272:	7e 0e                	jle    800282 <print_num+0x47>
            putch(padc, put_arg);
  800274:	4c 89 ee             	mov    %r13,%rsi
  800277:	44 89 f7             	mov    %r14d,%edi
  80027a:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80027d:	83 eb 01             	sub    $0x1,%ebx
  800280:	75 f2                	jne    800274 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800282:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800286:	48 b9 2c 30 80 00 00 	movabs $0x80302c,%rcx
  80028d:	00 00 00 
  800290:	48 b8 1b 30 80 00 00 	movabs $0x80301b,%rax
  800297:	00 00 00 
  80029a:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80029e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a7:	49 f7 f7             	div    %r15
  8002aa:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8002ae:	4c 89 ee             	mov    %r13,%rsi
  8002b1:	41 ff d4             	call   *%r12
}
  8002b4:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8002b8:	5b                   	pop    %rbx
  8002b9:	41 5c                	pop    %r12
  8002bb:	41 5d                	pop    %r13
  8002bd:	41 5e                	pop    %r14
  8002bf:	41 5f                	pop    %r15
  8002c1:	5d                   	pop    %rbp
  8002c2:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8002c3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002cc:	49 f7 f7             	div    %r15
  8002cf:	48 83 ec 08          	sub    $0x8,%rsp
  8002d3:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8002d7:	52                   	push   %rdx
  8002d8:	45 0f be c9          	movsbl %r9b,%r9d
  8002dc:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8002e0:	48 89 c2             	mov    %rax,%rdx
  8002e3:	48 b8 3b 02 80 00 00 	movabs $0x80023b,%rax
  8002ea:	00 00 00 
  8002ed:	ff d0                	call   *%rax
  8002ef:	48 83 c4 10          	add    $0x10,%rsp
  8002f3:	eb 8d                	jmp    800282 <print_num+0x47>

00000000008002f5 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8002f5:	f3 0f 1e fa          	endbr64
    state->count++;
  8002f9:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8002fd:	48 8b 06             	mov    (%rsi),%rax
  800300:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800304:	73 0a                	jae    800310 <sprintputch+0x1b>
        *state->start++ = ch;
  800306:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80030a:	48 89 16             	mov    %rdx,(%rsi)
  80030d:	40 88 38             	mov    %dil,(%rax)
    }
}
  800310:	c3                   	ret

0000000000800311 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800311:	f3 0f 1e fa          	endbr64
  800315:	55                   	push   %rbp
  800316:	48 89 e5             	mov    %rsp,%rbp
  800319:	48 83 ec 50          	sub    $0x50,%rsp
  80031d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800321:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800325:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800329:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800330:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800334:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800338:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80033c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800340:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800344:	48 b8 52 03 80 00 00 	movabs $0x800352,%rax
  80034b:	00 00 00 
  80034e:	ff d0                	call   *%rax
}
  800350:	c9                   	leave
  800351:	c3                   	ret

0000000000800352 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800352:	f3 0f 1e fa          	endbr64
  800356:	55                   	push   %rbp
  800357:	48 89 e5             	mov    %rsp,%rbp
  80035a:	41 57                	push   %r15
  80035c:	41 56                	push   %r14
  80035e:	41 55                	push   %r13
  800360:	41 54                	push   %r12
  800362:	53                   	push   %rbx
  800363:	48 83 ec 38          	sub    $0x38,%rsp
  800367:	49 89 fe             	mov    %rdi,%r14
  80036a:	49 89 f5             	mov    %rsi,%r13
  80036d:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800370:	48 8b 01             	mov    (%rcx),%rax
  800373:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800377:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80037b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80037f:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800383:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800387:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80038b:	0f b6 3b             	movzbl (%rbx),%edi
  80038e:	40 80 ff 25          	cmp    $0x25,%dil
  800392:	74 18                	je     8003ac <vprintfmt+0x5a>
            if (!ch) return;
  800394:	40 84 ff             	test   %dil,%dil
  800397:	0f 84 b2 06 00 00    	je     800a4f <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80039d:	40 0f b6 ff          	movzbl %dil,%edi
  8003a1:	4c 89 ee             	mov    %r13,%rsi
  8003a4:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8003a7:	4c 89 e3             	mov    %r12,%rbx
  8003aa:	eb db                	jmp    800387 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8003ac:	be 00 00 00 00       	mov    $0x0,%esi
  8003b1:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8003b5:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8003ba:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8003c0:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8003c7:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8003cb:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8003d0:	41 0f b6 04 24       	movzbl (%r12),%eax
  8003d5:	88 45 a0             	mov    %al,-0x60(%rbp)
  8003d8:	83 e8 23             	sub    $0x23,%eax
  8003db:	3c 57                	cmp    $0x57,%al
  8003dd:	0f 87 52 06 00 00    	ja     800a35 <vprintfmt+0x6e3>
  8003e3:	0f b6 c0             	movzbl %al,%eax
  8003e6:	48 b9 80 32 80 00 00 	movabs $0x803280,%rcx
  8003ed:	00 00 00 
  8003f0:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8003f4:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8003f7:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8003fb:	eb ce                	jmp    8003cb <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8003fd:	49 89 dc             	mov    %rbx,%r12
  800400:	be 01 00 00 00       	mov    $0x1,%esi
  800405:	eb c4                	jmp    8003cb <vprintfmt+0x79>
            padc = ch;
  800407:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  80040b:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80040e:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800411:	eb b8                	jmp    8003cb <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800413:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800416:	83 f8 2f             	cmp    $0x2f,%eax
  800419:	77 24                	ja     80043f <vprintfmt+0xed>
  80041b:	89 c1                	mov    %eax,%ecx
  80041d:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800421:	83 c0 08             	add    $0x8,%eax
  800424:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800427:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  80042a:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  80042d:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800431:	79 98                	jns    8003cb <vprintfmt+0x79>
                width = precision;
  800433:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800437:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80043d:	eb 8c                	jmp    8003cb <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80043f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800443:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800447:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80044b:	eb da                	jmp    800427 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80044d:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800452:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800456:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80045c:	3c 39                	cmp    $0x39,%al
  80045e:	77 1c                	ja     80047c <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800460:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800464:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800468:	0f b6 c0             	movzbl %al,%eax
  80046b:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800470:	0f b6 03             	movzbl (%rbx),%eax
  800473:	3c 39                	cmp    $0x39,%al
  800475:	76 e9                	jbe    800460 <vprintfmt+0x10e>
        process_precision:
  800477:	49 89 dc             	mov    %rbx,%r12
  80047a:	eb b1                	jmp    80042d <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80047c:	49 89 dc             	mov    %rbx,%r12
  80047f:	eb ac                	jmp    80042d <vprintfmt+0xdb>
            width = MAX(0, width);
  800481:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800484:	85 c9                	test   %ecx,%ecx
  800486:	b8 00 00 00 00       	mov    $0x0,%eax
  80048b:	0f 49 c1             	cmovns %ecx,%eax
  80048e:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800491:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800494:	e9 32 ff ff ff       	jmp    8003cb <vprintfmt+0x79>
            lflag++;
  800499:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80049c:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80049f:	e9 27 ff ff ff       	jmp    8003cb <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8004a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004a7:	83 f8 2f             	cmp    $0x2f,%eax
  8004aa:	77 19                	ja     8004c5 <vprintfmt+0x173>
  8004ac:	89 c2                	mov    %eax,%edx
  8004ae:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8004b2:	83 c0 08             	add    $0x8,%eax
  8004b5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004b8:	8b 3a                	mov    (%rdx),%edi
  8004ba:	4c 89 ee             	mov    %r13,%rsi
  8004bd:	41 ff d6             	call   *%r14
            break;
  8004c0:	e9 c2 fe ff ff       	jmp    800387 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8004c5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004c9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8004cd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004d1:	eb e5                	jmp    8004b8 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8004d3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004d6:	83 f8 2f             	cmp    $0x2f,%eax
  8004d9:	77 5a                	ja     800535 <vprintfmt+0x1e3>
  8004db:	89 c2                	mov    %eax,%edx
  8004dd:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8004e1:	83 c0 08             	add    $0x8,%eax
  8004e4:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8004e7:	8b 02                	mov    (%rdx),%eax
  8004e9:	89 c1                	mov    %eax,%ecx
  8004eb:	f7 d9                	neg    %ecx
  8004ed:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8004f0:	83 f9 13             	cmp    $0x13,%ecx
  8004f3:	7f 4e                	jg     800543 <vprintfmt+0x1f1>
  8004f5:	48 63 c1             	movslq %ecx,%rax
  8004f8:	48 ba 40 35 80 00 00 	movabs $0x803540,%rdx
  8004ff:	00 00 00 
  800502:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800506:	48 85 c0             	test   %rax,%rax
  800509:	74 38                	je     800543 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  80050b:	48 89 c1             	mov    %rax,%rcx
  80050e:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  800515:	00 00 00 
  800518:	4c 89 ee             	mov    %r13,%rsi
  80051b:	4c 89 f7             	mov    %r14,%rdi
  80051e:	b8 00 00 00 00       	mov    $0x0,%eax
  800523:	49 b8 11 03 80 00 00 	movabs $0x800311,%r8
  80052a:	00 00 00 
  80052d:	41 ff d0             	call   *%r8
  800530:	e9 52 fe ff ff       	jmp    800387 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800535:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800539:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80053d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800541:	eb a4                	jmp    8004e7 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800543:	48 ba 44 30 80 00 00 	movabs $0x803044,%rdx
  80054a:	00 00 00 
  80054d:	4c 89 ee             	mov    %r13,%rsi
  800550:	4c 89 f7             	mov    %r14,%rdi
  800553:	b8 00 00 00 00       	mov    $0x0,%eax
  800558:	49 b8 11 03 80 00 00 	movabs $0x800311,%r8
  80055f:	00 00 00 
  800562:	41 ff d0             	call   *%r8
  800565:	e9 1d fe ff ff       	jmp    800387 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80056a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80056d:	83 f8 2f             	cmp    $0x2f,%eax
  800570:	77 6c                	ja     8005de <vprintfmt+0x28c>
  800572:	89 c2                	mov    %eax,%edx
  800574:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800578:	83 c0 08             	add    $0x8,%eax
  80057b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80057e:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800581:	48 85 d2             	test   %rdx,%rdx
  800584:	48 b8 3d 30 80 00 00 	movabs $0x80303d,%rax
  80058b:	00 00 00 
  80058e:	48 0f 45 c2          	cmovne %rdx,%rax
  800592:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800596:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80059a:	7e 06                	jle    8005a2 <vprintfmt+0x250>
  80059c:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8005a0:	75 4a                	jne    8005ec <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8005a2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8005a6:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8005aa:	0f b6 00             	movzbl (%rax),%eax
  8005ad:	84 c0                	test   %al,%al
  8005af:	0f 85 9a 00 00 00    	jne    80064f <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8005b5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005b8:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8005bc:	85 c0                	test   %eax,%eax
  8005be:	0f 8e c3 fd ff ff    	jle    800387 <vprintfmt+0x35>
  8005c4:	4c 89 ee             	mov    %r13,%rsi
  8005c7:	bf 20 00 00 00       	mov    $0x20,%edi
  8005cc:	41 ff d6             	call   *%r14
  8005cf:	41 83 ec 01          	sub    $0x1,%r12d
  8005d3:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8005d7:	75 eb                	jne    8005c4 <vprintfmt+0x272>
  8005d9:	e9 a9 fd ff ff       	jmp    800387 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8005de:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005e2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005e6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005ea:	eb 92                	jmp    80057e <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8005ec:	49 63 f7             	movslq %r15d,%rsi
  8005ef:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8005f3:	48 b8 15 0b 80 00 00 	movabs $0x800b15,%rax
  8005fa:	00 00 00 
  8005fd:	ff d0                	call   *%rax
  8005ff:	48 89 c2             	mov    %rax,%rdx
  800602:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800605:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800607:	8d 70 ff             	lea    -0x1(%rax),%esi
  80060a:	89 75 ac             	mov    %esi,-0x54(%rbp)
  80060d:	85 c0                	test   %eax,%eax
  80060f:	7e 91                	jle    8005a2 <vprintfmt+0x250>
  800611:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800616:	4c 89 ee             	mov    %r13,%rsi
  800619:	44 89 e7             	mov    %r12d,%edi
  80061c:	41 ff d6             	call   *%r14
  80061f:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800623:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800626:	83 f8 ff             	cmp    $0xffffffff,%eax
  800629:	75 eb                	jne    800616 <vprintfmt+0x2c4>
  80062b:	e9 72 ff ff ff       	jmp    8005a2 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800630:	0f b6 f8             	movzbl %al,%edi
  800633:	4c 89 ee             	mov    %r13,%rsi
  800636:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800639:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80063d:	49 83 c4 01          	add    $0x1,%r12
  800641:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800647:	84 c0                	test   %al,%al
  800649:	0f 84 66 ff ff ff    	je     8005b5 <vprintfmt+0x263>
  80064f:	45 85 ff             	test   %r15d,%r15d
  800652:	78 0a                	js     80065e <vprintfmt+0x30c>
  800654:	41 83 ef 01          	sub    $0x1,%r15d
  800658:	0f 88 57 ff ff ff    	js     8005b5 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80065e:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800662:	74 cc                	je     800630 <vprintfmt+0x2de>
  800664:	8d 50 e0             	lea    -0x20(%rax),%edx
  800667:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80066c:	80 fa 5e             	cmp    $0x5e,%dl
  80066f:	77 c2                	ja     800633 <vprintfmt+0x2e1>
  800671:	eb bd                	jmp    800630 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800673:	40 84 f6             	test   %sil,%sil
  800676:	75 26                	jne    80069e <vprintfmt+0x34c>
    switch (lflag) {
  800678:	85 d2                	test   %edx,%edx
  80067a:	74 59                	je     8006d5 <vprintfmt+0x383>
  80067c:	83 fa 01             	cmp    $0x1,%edx
  80067f:	74 7b                	je     8006fc <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800681:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800684:	83 f8 2f             	cmp    $0x2f,%eax
  800687:	0f 87 96 00 00 00    	ja     800723 <vprintfmt+0x3d1>
  80068d:	89 c2                	mov    %eax,%edx
  80068f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800693:	83 c0 08             	add    $0x8,%eax
  800696:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800699:	4c 8b 22             	mov    (%rdx),%r12
  80069c:	eb 17                	jmp    8006b5 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  80069e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006a1:	83 f8 2f             	cmp    $0x2f,%eax
  8006a4:	77 21                	ja     8006c7 <vprintfmt+0x375>
  8006a6:	89 c2                	mov    %eax,%edx
  8006a8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006ac:	83 c0 08             	add    $0x8,%eax
  8006af:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006b2:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8006b5:	4d 85 e4             	test   %r12,%r12
  8006b8:	78 7a                	js     800734 <vprintfmt+0x3e2>
            num = i;
  8006ba:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8006bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006c2:	e9 50 02 00 00       	jmp    800917 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8006c7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006cb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006cf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006d3:	eb dd                	jmp    8006b2 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8006d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006d8:	83 f8 2f             	cmp    $0x2f,%eax
  8006db:	77 11                	ja     8006ee <vprintfmt+0x39c>
  8006dd:	89 c2                	mov    %eax,%edx
  8006df:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006e3:	83 c0 08             	add    $0x8,%eax
  8006e6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006e9:	4c 63 22             	movslq (%rdx),%r12
  8006ec:	eb c7                	jmp    8006b5 <vprintfmt+0x363>
  8006ee:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006f2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006f6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006fa:	eb ed                	jmp    8006e9 <vprintfmt+0x397>
        return va_arg(*ap, long);
  8006fc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006ff:	83 f8 2f             	cmp    $0x2f,%eax
  800702:	77 11                	ja     800715 <vprintfmt+0x3c3>
  800704:	89 c2                	mov    %eax,%edx
  800706:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80070a:	83 c0 08             	add    $0x8,%eax
  80070d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800710:	4c 8b 22             	mov    (%rdx),%r12
  800713:	eb a0                	jmp    8006b5 <vprintfmt+0x363>
  800715:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800719:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80071d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800721:	eb ed                	jmp    800710 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800723:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800727:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80072b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80072f:	e9 65 ff ff ff       	jmp    800699 <vprintfmt+0x347>
                putch('-', put_arg);
  800734:	4c 89 ee             	mov    %r13,%rsi
  800737:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80073c:	41 ff d6             	call   *%r14
                i = -i;
  80073f:	49 f7 dc             	neg    %r12
  800742:	e9 73 ff ff ff       	jmp    8006ba <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800747:	40 84 f6             	test   %sil,%sil
  80074a:	75 32                	jne    80077e <vprintfmt+0x42c>
    switch (lflag) {
  80074c:	85 d2                	test   %edx,%edx
  80074e:	74 5d                	je     8007ad <vprintfmt+0x45b>
  800750:	83 fa 01             	cmp    $0x1,%edx
  800753:	0f 84 82 00 00 00    	je     8007db <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800759:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80075c:	83 f8 2f             	cmp    $0x2f,%eax
  80075f:	0f 87 a5 00 00 00    	ja     80080a <vprintfmt+0x4b8>
  800765:	89 c2                	mov    %eax,%edx
  800767:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80076b:	83 c0 08             	add    $0x8,%eax
  80076e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800771:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800774:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800779:	e9 99 01 00 00       	jmp    800917 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80077e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800781:	83 f8 2f             	cmp    $0x2f,%eax
  800784:	77 19                	ja     80079f <vprintfmt+0x44d>
  800786:	89 c2                	mov    %eax,%edx
  800788:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80078c:	83 c0 08             	add    $0x8,%eax
  80078f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800792:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800795:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80079a:	e9 78 01 00 00       	jmp    800917 <vprintfmt+0x5c5>
  80079f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007a3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007a7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007ab:	eb e5                	jmp    800792 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8007ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b0:	83 f8 2f             	cmp    $0x2f,%eax
  8007b3:	77 18                	ja     8007cd <vprintfmt+0x47b>
  8007b5:	89 c2                	mov    %eax,%edx
  8007b7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007bb:	83 c0 08             	add    $0x8,%eax
  8007be:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007c1:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8007c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8007c8:	e9 4a 01 00 00       	jmp    800917 <vprintfmt+0x5c5>
  8007cd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007d1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007d5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007d9:	eb e6                	jmp    8007c1 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8007db:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007de:	83 f8 2f             	cmp    $0x2f,%eax
  8007e1:	77 19                	ja     8007fc <vprintfmt+0x4aa>
  8007e3:	89 c2                	mov    %eax,%edx
  8007e5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007e9:	83 c0 08             	add    $0x8,%eax
  8007ec:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007ef:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8007f2:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8007f7:	e9 1b 01 00 00       	jmp    800917 <vprintfmt+0x5c5>
  8007fc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800800:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800804:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800808:	eb e5                	jmp    8007ef <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  80080a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80080e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800812:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800816:	e9 56 ff ff ff       	jmp    800771 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  80081b:	40 84 f6             	test   %sil,%sil
  80081e:	75 2e                	jne    80084e <vprintfmt+0x4fc>
    switch (lflag) {
  800820:	85 d2                	test   %edx,%edx
  800822:	74 59                	je     80087d <vprintfmt+0x52b>
  800824:	83 fa 01             	cmp    $0x1,%edx
  800827:	74 7f                	je     8008a8 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800829:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082c:	83 f8 2f             	cmp    $0x2f,%eax
  80082f:	0f 87 9f 00 00 00    	ja     8008d4 <vprintfmt+0x582>
  800835:	89 c2                	mov    %eax,%edx
  800837:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80083b:	83 c0 08             	add    $0x8,%eax
  80083e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800841:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800844:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800849:	e9 c9 00 00 00       	jmp    800917 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80084e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800851:	83 f8 2f             	cmp    $0x2f,%eax
  800854:	77 19                	ja     80086f <vprintfmt+0x51d>
  800856:	89 c2                	mov    %eax,%edx
  800858:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80085c:	83 c0 08             	add    $0x8,%eax
  80085f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800862:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800865:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80086a:	e9 a8 00 00 00       	jmp    800917 <vprintfmt+0x5c5>
  80086f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800873:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800877:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80087b:	eb e5                	jmp    800862 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  80087d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800880:	83 f8 2f             	cmp    $0x2f,%eax
  800883:	77 15                	ja     80089a <vprintfmt+0x548>
  800885:	89 c2                	mov    %eax,%edx
  800887:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80088b:	83 c0 08             	add    $0x8,%eax
  80088e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800891:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800893:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800898:	eb 7d                	jmp    800917 <vprintfmt+0x5c5>
  80089a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80089e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008a2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008a6:	eb e9                	jmp    800891 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8008a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ab:	83 f8 2f             	cmp    $0x2f,%eax
  8008ae:	77 16                	ja     8008c6 <vprintfmt+0x574>
  8008b0:	89 c2                	mov    %eax,%edx
  8008b2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008b6:	83 c0 08             	add    $0x8,%eax
  8008b9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008bc:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8008bf:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008c4:	eb 51                	jmp    800917 <vprintfmt+0x5c5>
  8008c6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008ca:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008ce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008d2:	eb e8                	jmp    8008bc <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8008d4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008d8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008dc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008e0:	e9 5c ff ff ff       	jmp    800841 <vprintfmt+0x4ef>
            putch('0', put_arg);
  8008e5:	4c 89 ee             	mov    %r13,%rsi
  8008e8:	bf 30 00 00 00       	mov    $0x30,%edi
  8008ed:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  8008f0:	4c 89 ee             	mov    %r13,%rsi
  8008f3:	bf 78 00 00 00       	mov    $0x78,%edi
  8008f8:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  8008fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008fe:	83 f8 2f             	cmp    $0x2f,%eax
  800901:	77 47                	ja     80094a <vprintfmt+0x5f8>
  800903:	89 c2                	mov    %eax,%edx
  800905:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800909:	83 c0 08             	add    $0x8,%eax
  80090c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80090f:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800912:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800917:	48 83 ec 08          	sub    $0x8,%rsp
  80091b:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  80091f:	0f 94 c0             	sete   %al
  800922:	0f b6 c0             	movzbl %al,%eax
  800925:	50                   	push   %rax
  800926:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  80092b:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80092f:	4c 89 ee             	mov    %r13,%rsi
  800932:	4c 89 f7             	mov    %r14,%rdi
  800935:	48 b8 3b 02 80 00 00 	movabs $0x80023b,%rax
  80093c:	00 00 00 
  80093f:	ff d0                	call   *%rax
            break;
  800941:	48 83 c4 10          	add    $0x10,%rsp
  800945:	e9 3d fa ff ff       	jmp    800387 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  80094a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80094e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800952:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800956:	eb b7                	jmp    80090f <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800958:	40 84 f6             	test   %sil,%sil
  80095b:	75 2b                	jne    800988 <vprintfmt+0x636>
    switch (lflag) {
  80095d:	85 d2                	test   %edx,%edx
  80095f:	74 56                	je     8009b7 <vprintfmt+0x665>
  800961:	83 fa 01             	cmp    $0x1,%edx
  800964:	74 7f                	je     8009e5 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800966:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800969:	83 f8 2f             	cmp    $0x2f,%eax
  80096c:	0f 87 a2 00 00 00    	ja     800a14 <vprintfmt+0x6c2>
  800972:	89 c2                	mov    %eax,%edx
  800974:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800978:	83 c0 08             	add    $0x8,%eax
  80097b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80097e:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800981:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800986:	eb 8f                	jmp    800917 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800988:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80098b:	83 f8 2f             	cmp    $0x2f,%eax
  80098e:	77 19                	ja     8009a9 <vprintfmt+0x657>
  800990:	89 c2                	mov    %eax,%edx
  800992:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800996:	83 c0 08             	add    $0x8,%eax
  800999:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80099c:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80099f:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009a4:	e9 6e ff ff ff       	jmp    800917 <vprintfmt+0x5c5>
  8009a9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ad:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009b1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009b5:	eb e5                	jmp    80099c <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8009b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ba:	83 f8 2f             	cmp    $0x2f,%eax
  8009bd:	77 18                	ja     8009d7 <vprintfmt+0x685>
  8009bf:	89 c2                	mov    %eax,%edx
  8009c1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009c5:	83 c0 08             	add    $0x8,%eax
  8009c8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009cb:	8b 12                	mov    (%rdx),%edx
            base = 16;
  8009cd:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8009d2:	e9 40 ff ff ff       	jmp    800917 <vprintfmt+0x5c5>
  8009d7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009db:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009df:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009e3:	eb e6                	jmp    8009cb <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  8009e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e8:	83 f8 2f             	cmp    $0x2f,%eax
  8009eb:	77 19                	ja     800a06 <vprintfmt+0x6b4>
  8009ed:	89 c2                	mov    %eax,%edx
  8009ef:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009f3:	83 c0 08             	add    $0x8,%eax
  8009f6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009f9:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009fc:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800a01:	e9 11 ff ff ff       	jmp    800917 <vprintfmt+0x5c5>
  800a06:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a0a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a0e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a12:	eb e5                	jmp    8009f9 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800a14:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a18:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a1c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a20:	e9 59 ff ff ff       	jmp    80097e <vprintfmt+0x62c>
            putch(ch, put_arg);
  800a25:	4c 89 ee             	mov    %r13,%rsi
  800a28:	bf 25 00 00 00       	mov    $0x25,%edi
  800a2d:	41 ff d6             	call   *%r14
            break;
  800a30:	e9 52 f9 ff ff       	jmp    800387 <vprintfmt+0x35>
            putch('%', put_arg);
  800a35:	4c 89 ee             	mov    %r13,%rsi
  800a38:	bf 25 00 00 00       	mov    $0x25,%edi
  800a3d:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800a40:	48 83 eb 01          	sub    $0x1,%rbx
  800a44:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800a48:	75 f6                	jne    800a40 <vprintfmt+0x6ee>
  800a4a:	e9 38 f9 ff ff       	jmp    800387 <vprintfmt+0x35>
}
  800a4f:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a53:	5b                   	pop    %rbx
  800a54:	41 5c                	pop    %r12
  800a56:	41 5d                	pop    %r13
  800a58:	41 5e                	pop    %r14
  800a5a:	41 5f                	pop    %r15
  800a5c:	5d                   	pop    %rbp
  800a5d:	c3                   	ret

0000000000800a5e <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a5e:	f3 0f 1e fa          	endbr64
  800a62:	55                   	push   %rbp
  800a63:	48 89 e5             	mov    %rsp,%rbp
  800a66:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800a6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a6e:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800a73:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800a77:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800a7e:	48 85 ff             	test   %rdi,%rdi
  800a81:	74 2b                	je     800aae <vsnprintf+0x50>
  800a83:	48 85 f6             	test   %rsi,%rsi
  800a86:	74 26                	je     800aae <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800a88:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800a8c:	48 bf f5 02 80 00 00 	movabs $0x8002f5,%rdi
  800a93:	00 00 00 
  800a96:	48 b8 52 03 80 00 00 	movabs $0x800352,%rax
  800a9d:	00 00 00 
  800aa0:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800aa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa6:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800aa9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800aac:	c9                   	leave
  800aad:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800aae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ab3:	eb f7                	jmp    800aac <vsnprintf+0x4e>

0000000000800ab5 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800ab5:	f3 0f 1e fa          	endbr64
  800ab9:	55                   	push   %rbp
  800aba:	48 89 e5             	mov    %rsp,%rbp
  800abd:	48 83 ec 50          	sub    $0x50,%rsp
  800ac1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800ac5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800ac9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800acd:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800ad4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ad8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800adc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ae0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800ae4:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ae8:	48 b8 5e 0a 80 00 00 	movabs $0x800a5e,%rax
  800aef:	00 00 00 
  800af2:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800af4:	c9                   	leave
  800af5:	c3                   	ret

0000000000800af6 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800af6:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800afa:	80 3f 00             	cmpb   $0x0,(%rdi)
  800afd:	74 10                	je     800b0f <strlen+0x19>
    size_t n = 0;
  800aff:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800b04:	48 83 c0 01          	add    $0x1,%rax
  800b08:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b0c:	75 f6                	jne    800b04 <strlen+0xe>
  800b0e:	c3                   	ret
    size_t n = 0;
  800b0f:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800b14:	c3                   	ret

0000000000800b15 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800b15:	f3 0f 1e fa          	endbr64
  800b19:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800b1c:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800b21:	48 85 f6             	test   %rsi,%rsi
  800b24:	74 10                	je     800b36 <strnlen+0x21>
  800b26:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800b2a:	74 0b                	je     800b37 <strnlen+0x22>
  800b2c:	48 83 c2 01          	add    $0x1,%rdx
  800b30:	48 39 d0             	cmp    %rdx,%rax
  800b33:	75 f1                	jne    800b26 <strnlen+0x11>
  800b35:	c3                   	ret
  800b36:	c3                   	ret
  800b37:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800b3a:	c3                   	ret

0000000000800b3b <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800b3b:	f3 0f 1e fa          	endbr64
  800b3f:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b42:	ba 00 00 00 00       	mov    $0x0,%edx
  800b47:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800b4b:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800b4e:	48 83 c2 01          	add    $0x1,%rdx
  800b52:	84 c9                	test   %cl,%cl
  800b54:	75 f1                	jne    800b47 <strcpy+0xc>
        ;
    return res;
}
  800b56:	c3                   	ret

0000000000800b57 <strcat>:

char *
strcat(char *dst, const char *src) {
  800b57:	f3 0f 1e fa          	endbr64
  800b5b:	55                   	push   %rbp
  800b5c:	48 89 e5             	mov    %rsp,%rbp
  800b5f:	41 54                	push   %r12
  800b61:	53                   	push   %rbx
  800b62:	48 89 fb             	mov    %rdi,%rbx
  800b65:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800b68:	48 b8 f6 0a 80 00 00 	movabs $0x800af6,%rax
  800b6f:	00 00 00 
  800b72:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800b74:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800b78:	4c 89 e6             	mov    %r12,%rsi
  800b7b:	48 b8 3b 0b 80 00 00 	movabs $0x800b3b,%rax
  800b82:	00 00 00 
  800b85:	ff d0                	call   *%rax
    return dst;
}
  800b87:	48 89 d8             	mov    %rbx,%rax
  800b8a:	5b                   	pop    %rbx
  800b8b:	41 5c                	pop    %r12
  800b8d:	5d                   	pop    %rbp
  800b8e:	c3                   	ret

0000000000800b8f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b8f:	f3 0f 1e fa          	endbr64
  800b93:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800b96:	48 85 d2             	test   %rdx,%rdx
  800b99:	74 1f                	je     800bba <strncpy+0x2b>
  800b9b:	48 01 fa             	add    %rdi,%rdx
  800b9e:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800ba1:	48 83 c1 01          	add    $0x1,%rcx
  800ba5:	44 0f b6 06          	movzbl (%rsi),%r8d
  800ba9:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800bad:	41 80 f8 01          	cmp    $0x1,%r8b
  800bb1:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800bb5:	48 39 ca             	cmp    %rcx,%rdx
  800bb8:	75 e7                	jne    800ba1 <strncpy+0x12>
    }
    return ret;
}
  800bba:	c3                   	ret

0000000000800bbb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800bbb:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800bbf:	48 89 f8             	mov    %rdi,%rax
  800bc2:	48 85 d2             	test   %rdx,%rdx
  800bc5:	74 24                	je     800beb <strlcpy+0x30>
        while (--size > 0 && *src)
  800bc7:	48 83 ea 01          	sub    $0x1,%rdx
  800bcb:	74 1b                	je     800be8 <strlcpy+0x2d>
  800bcd:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800bd1:	0f b6 16             	movzbl (%rsi),%edx
  800bd4:	84 d2                	test   %dl,%dl
  800bd6:	74 10                	je     800be8 <strlcpy+0x2d>
            *dst++ = *src++;
  800bd8:	48 83 c6 01          	add    $0x1,%rsi
  800bdc:	48 83 c0 01          	add    $0x1,%rax
  800be0:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800be3:	48 39 c8             	cmp    %rcx,%rax
  800be6:	75 e9                	jne    800bd1 <strlcpy+0x16>
        *dst = '\0';
  800be8:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800beb:	48 29 f8             	sub    %rdi,%rax
}
  800bee:	c3                   	ret

0000000000800bef <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800bef:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800bf3:	0f b6 07             	movzbl (%rdi),%eax
  800bf6:	84 c0                	test   %al,%al
  800bf8:	74 13                	je     800c0d <strcmp+0x1e>
  800bfa:	38 06                	cmp    %al,(%rsi)
  800bfc:	75 0f                	jne    800c0d <strcmp+0x1e>
  800bfe:	48 83 c7 01          	add    $0x1,%rdi
  800c02:	48 83 c6 01          	add    $0x1,%rsi
  800c06:	0f b6 07             	movzbl (%rdi),%eax
  800c09:	84 c0                	test   %al,%al
  800c0b:	75 ed                	jne    800bfa <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800c0d:	0f b6 c0             	movzbl %al,%eax
  800c10:	0f b6 16             	movzbl (%rsi),%edx
  800c13:	29 d0                	sub    %edx,%eax
}
  800c15:	c3                   	ret

0000000000800c16 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800c16:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800c1a:	48 85 d2             	test   %rdx,%rdx
  800c1d:	74 1f                	je     800c3e <strncmp+0x28>
  800c1f:	0f b6 07             	movzbl (%rdi),%eax
  800c22:	84 c0                	test   %al,%al
  800c24:	74 1e                	je     800c44 <strncmp+0x2e>
  800c26:	3a 06                	cmp    (%rsi),%al
  800c28:	75 1a                	jne    800c44 <strncmp+0x2e>
  800c2a:	48 83 c7 01          	add    $0x1,%rdi
  800c2e:	48 83 c6 01          	add    $0x1,%rsi
  800c32:	48 83 ea 01          	sub    $0x1,%rdx
  800c36:	75 e7                	jne    800c1f <strncmp+0x9>

    if (!n) return 0;
  800c38:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3d:	c3                   	ret
  800c3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c43:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c44:	0f b6 07             	movzbl (%rdi),%eax
  800c47:	0f b6 16             	movzbl (%rsi),%edx
  800c4a:	29 d0                	sub    %edx,%eax
}
  800c4c:	c3                   	ret

0000000000800c4d <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800c4d:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800c51:	0f b6 17             	movzbl (%rdi),%edx
  800c54:	84 d2                	test   %dl,%dl
  800c56:	74 18                	je     800c70 <strchr+0x23>
        if (*str == c) {
  800c58:	0f be d2             	movsbl %dl,%edx
  800c5b:	39 f2                	cmp    %esi,%edx
  800c5d:	74 17                	je     800c76 <strchr+0x29>
    for (; *str; str++) {
  800c5f:	48 83 c7 01          	add    $0x1,%rdi
  800c63:	0f b6 17             	movzbl (%rdi),%edx
  800c66:	84 d2                	test   %dl,%dl
  800c68:	75 ee                	jne    800c58 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800c6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6f:	c3                   	ret
  800c70:	b8 00 00 00 00       	mov    $0x0,%eax
  800c75:	c3                   	ret
            return (char *)str;
  800c76:	48 89 f8             	mov    %rdi,%rax
}
  800c79:	c3                   	ret

0000000000800c7a <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800c7a:	f3 0f 1e fa          	endbr64
  800c7e:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800c81:	0f b6 17             	movzbl (%rdi),%edx
  800c84:	84 d2                	test   %dl,%dl
  800c86:	74 13                	je     800c9b <strfind+0x21>
  800c88:	0f be d2             	movsbl %dl,%edx
  800c8b:	39 f2                	cmp    %esi,%edx
  800c8d:	74 0b                	je     800c9a <strfind+0x20>
  800c8f:	48 83 c0 01          	add    $0x1,%rax
  800c93:	0f b6 10             	movzbl (%rax),%edx
  800c96:	84 d2                	test   %dl,%dl
  800c98:	75 ee                	jne    800c88 <strfind+0xe>
        ;
    return (char *)str;
}
  800c9a:	c3                   	ret
  800c9b:	c3                   	ret

0000000000800c9c <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800c9c:	f3 0f 1e fa          	endbr64
  800ca0:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800ca3:	48 89 f8             	mov    %rdi,%rax
  800ca6:	48 f7 d8             	neg    %rax
  800ca9:	83 e0 07             	and    $0x7,%eax
  800cac:	49 89 d1             	mov    %rdx,%r9
  800caf:	49 29 c1             	sub    %rax,%r9
  800cb2:	78 36                	js     800cea <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800cb4:	40 0f b6 c6          	movzbl %sil,%eax
  800cb8:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800cbf:	01 01 01 
  800cc2:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800cc6:	40 f6 c7 07          	test   $0x7,%dil
  800cca:	75 38                	jne    800d04 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800ccc:	4c 89 c9             	mov    %r9,%rcx
  800ccf:	48 c1 f9 03          	sar    $0x3,%rcx
  800cd3:	74 0c                	je     800ce1 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800cd5:	fc                   	cld
  800cd6:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800cd9:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800cdd:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800ce1:	4d 85 c9             	test   %r9,%r9
  800ce4:	75 45                	jne    800d2b <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800ce6:	4c 89 c0             	mov    %r8,%rax
  800ce9:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800cea:	48 85 d2             	test   %rdx,%rdx
  800ced:	74 f7                	je     800ce6 <memset+0x4a>
  800cef:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800cf2:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800cf5:	48 83 c0 01          	add    $0x1,%rax
  800cf9:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800cfd:	48 39 c2             	cmp    %rax,%rdx
  800d00:	75 f3                	jne    800cf5 <memset+0x59>
  800d02:	eb e2                	jmp    800ce6 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800d04:	40 f6 c7 01          	test   $0x1,%dil
  800d08:	74 06                	je     800d10 <memset+0x74>
  800d0a:	88 07                	mov    %al,(%rdi)
  800d0c:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d10:	40 f6 c7 02          	test   $0x2,%dil
  800d14:	74 07                	je     800d1d <memset+0x81>
  800d16:	66 89 07             	mov    %ax,(%rdi)
  800d19:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d1d:	40 f6 c7 04          	test   $0x4,%dil
  800d21:	74 a9                	je     800ccc <memset+0x30>
  800d23:	89 07                	mov    %eax,(%rdi)
  800d25:	48 83 c7 04          	add    $0x4,%rdi
  800d29:	eb a1                	jmp    800ccc <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d2b:	41 f6 c1 04          	test   $0x4,%r9b
  800d2f:	74 1b                	je     800d4c <memset+0xb0>
  800d31:	89 07                	mov    %eax,(%rdi)
  800d33:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d37:	41 f6 c1 02          	test   $0x2,%r9b
  800d3b:	74 07                	je     800d44 <memset+0xa8>
  800d3d:	66 89 07             	mov    %ax,(%rdi)
  800d40:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d44:	41 f6 c1 01          	test   $0x1,%r9b
  800d48:	74 9c                	je     800ce6 <memset+0x4a>
  800d4a:	eb 06                	jmp    800d52 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d4c:	41 f6 c1 02          	test   $0x2,%r9b
  800d50:	75 eb                	jne    800d3d <memset+0xa1>
        if (ni & 1) *ptr = k;
  800d52:	88 07                	mov    %al,(%rdi)
  800d54:	eb 90                	jmp    800ce6 <memset+0x4a>

0000000000800d56 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d56:	f3 0f 1e fa          	endbr64
  800d5a:	48 89 f8             	mov    %rdi,%rax
  800d5d:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d60:	48 39 fe             	cmp    %rdi,%rsi
  800d63:	73 3b                	jae    800da0 <memmove+0x4a>
  800d65:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800d69:	48 39 d7             	cmp    %rdx,%rdi
  800d6c:	73 32                	jae    800da0 <memmove+0x4a>
        s += n;
        d += n;
  800d6e:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d72:	48 89 d6             	mov    %rdx,%rsi
  800d75:	48 09 fe             	or     %rdi,%rsi
  800d78:	48 09 ce             	or     %rcx,%rsi
  800d7b:	40 f6 c6 07          	test   $0x7,%sil
  800d7f:	75 12                	jne    800d93 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800d81:	48 83 ef 08          	sub    $0x8,%rdi
  800d85:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800d89:	48 c1 e9 03          	shr    $0x3,%rcx
  800d8d:	fd                   	std
  800d8e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800d91:	fc                   	cld
  800d92:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800d93:	48 83 ef 01          	sub    $0x1,%rdi
  800d97:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800d9b:	fd                   	std
  800d9c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800d9e:	eb f1                	jmp    800d91 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800da0:	48 89 f2             	mov    %rsi,%rdx
  800da3:	48 09 c2             	or     %rax,%rdx
  800da6:	48 09 ca             	or     %rcx,%rdx
  800da9:	f6 c2 07             	test   $0x7,%dl
  800dac:	75 0c                	jne    800dba <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800dae:	48 c1 e9 03          	shr    $0x3,%rcx
  800db2:	48 89 c7             	mov    %rax,%rdi
  800db5:	fc                   	cld
  800db6:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800db9:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800dba:	48 89 c7             	mov    %rax,%rdi
  800dbd:	fc                   	cld
  800dbe:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800dc0:	c3                   	ret

0000000000800dc1 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800dc1:	f3 0f 1e fa          	endbr64
  800dc5:	55                   	push   %rbp
  800dc6:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800dc9:	48 b8 56 0d 80 00 00 	movabs $0x800d56,%rax
  800dd0:	00 00 00 
  800dd3:	ff d0                	call   *%rax
}
  800dd5:	5d                   	pop    %rbp
  800dd6:	c3                   	ret

0000000000800dd7 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800dd7:	f3 0f 1e fa          	endbr64
  800ddb:	55                   	push   %rbp
  800ddc:	48 89 e5             	mov    %rsp,%rbp
  800ddf:	41 57                	push   %r15
  800de1:	41 56                	push   %r14
  800de3:	41 55                	push   %r13
  800de5:	41 54                	push   %r12
  800de7:	53                   	push   %rbx
  800de8:	48 83 ec 08          	sub    $0x8,%rsp
  800dec:	49 89 fe             	mov    %rdi,%r14
  800def:	49 89 f7             	mov    %rsi,%r15
  800df2:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800df5:	48 89 f7             	mov    %rsi,%rdi
  800df8:	48 b8 f6 0a 80 00 00 	movabs $0x800af6,%rax
  800dff:	00 00 00 
  800e02:	ff d0                	call   *%rax
  800e04:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800e07:	48 89 de             	mov    %rbx,%rsi
  800e0a:	4c 89 f7             	mov    %r14,%rdi
  800e0d:	48 b8 15 0b 80 00 00 	movabs $0x800b15,%rax
  800e14:	00 00 00 
  800e17:	ff d0                	call   *%rax
  800e19:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800e1c:	48 39 c3             	cmp    %rax,%rbx
  800e1f:	74 36                	je     800e57 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800e21:	48 89 d8             	mov    %rbx,%rax
  800e24:	4c 29 e8             	sub    %r13,%rax
  800e27:	49 39 c4             	cmp    %rax,%r12
  800e2a:	73 31                	jae    800e5d <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800e2c:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800e31:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e35:	4c 89 fe             	mov    %r15,%rsi
  800e38:	48 b8 c1 0d 80 00 00 	movabs $0x800dc1,%rax
  800e3f:	00 00 00 
  800e42:	ff d0                	call   *%rax
    return dstlen + srclen;
  800e44:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800e48:	48 83 c4 08          	add    $0x8,%rsp
  800e4c:	5b                   	pop    %rbx
  800e4d:	41 5c                	pop    %r12
  800e4f:	41 5d                	pop    %r13
  800e51:	41 5e                	pop    %r14
  800e53:	41 5f                	pop    %r15
  800e55:	5d                   	pop    %rbp
  800e56:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800e57:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800e5b:	eb eb                	jmp    800e48 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e5d:	48 83 eb 01          	sub    $0x1,%rbx
  800e61:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e65:	48 89 da             	mov    %rbx,%rdx
  800e68:	4c 89 fe             	mov    %r15,%rsi
  800e6b:	48 b8 c1 0d 80 00 00 	movabs $0x800dc1,%rax
  800e72:	00 00 00 
  800e75:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800e77:	49 01 de             	add    %rbx,%r14
  800e7a:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800e7f:	eb c3                	jmp    800e44 <strlcat+0x6d>

0000000000800e81 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800e81:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800e85:	48 85 d2             	test   %rdx,%rdx
  800e88:	74 2d                	je     800eb7 <memcmp+0x36>
  800e8a:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800e8f:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800e93:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800e98:	44 38 c1             	cmp    %r8b,%cl
  800e9b:	75 0f                	jne    800eac <memcmp+0x2b>
    while (n-- > 0) {
  800e9d:	48 83 c0 01          	add    $0x1,%rax
  800ea1:	48 39 c2             	cmp    %rax,%rdx
  800ea4:	75 e9                	jne    800e8f <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800ea6:	b8 00 00 00 00       	mov    $0x0,%eax
  800eab:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800eac:	0f b6 c1             	movzbl %cl,%eax
  800eaf:	45 0f b6 c0          	movzbl %r8b,%r8d
  800eb3:	44 29 c0             	sub    %r8d,%eax
  800eb6:	c3                   	ret
    return 0;
  800eb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ebc:	c3                   	ret

0000000000800ebd <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800ebd:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800ec1:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800ec5:	48 39 c7             	cmp    %rax,%rdi
  800ec8:	73 0f                	jae    800ed9 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800eca:	40 38 37             	cmp    %sil,(%rdi)
  800ecd:	74 0e                	je     800edd <memfind+0x20>
    for (; src < end; src++) {
  800ecf:	48 83 c7 01          	add    $0x1,%rdi
  800ed3:	48 39 f8             	cmp    %rdi,%rax
  800ed6:	75 f2                	jne    800eca <memfind+0xd>
  800ed8:	c3                   	ret
  800ed9:	48 89 f8             	mov    %rdi,%rax
  800edc:	c3                   	ret
  800edd:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800ee0:	c3                   	ret

0000000000800ee1 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800ee1:	f3 0f 1e fa          	endbr64
  800ee5:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800ee8:	0f b6 37             	movzbl (%rdi),%esi
  800eeb:	40 80 fe 20          	cmp    $0x20,%sil
  800eef:	74 06                	je     800ef7 <strtol+0x16>
  800ef1:	40 80 fe 09          	cmp    $0x9,%sil
  800ef5:	75 13                	jne    800f0a <strtol+0x29>
  800ef7:	48 83 c7 01          	add    $0x1,%rdi
  800efb:	0f b6 37             	movzbl (%rdi),%esi
  800efe:	40 80 fe 20          	cmp    $0x20,%sil
  800f02:	74 f3                	je     800ef7 <strtol+0x16>
  800f04:	40 80 fe 09          	cmp    $0x9,%sil
  800f08:	74 ed                	je     800ef7 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800f0a:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800f0d:	83 e0 fd             	and    $0xfffffffd,%eax
  800f10:	3c 01                	cmp    $0x1,%al
  800f12:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f16:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  800f1c:	75 0f                	jne    800f2d <strtol+0x4c>
  800f1e:	80 3f 30             	cmpb   $0x30,(%rdi)
  800f21:	74 14                	je     800f37 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800f23:	85 d2                	test   %edx,%edx
  800f25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f2a:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  800f2d:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800f32:	4c 63 ca             	movslq %edx,%r9
  800f35:	eb 36                	jmp    800f6d <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f37:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800f3b:	74 0f                	je     800f4c <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  800f3d:	85 d2                	test   %edx,%edx
  800f3f:	75 ec                	jne    800f2d <strtol+0x4c>
        s++;
  800f41:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800f45:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  800f4a:	eb e1                	jmp    800f2d <strtol+0x4c>
        s += 2;
  800f4c:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f50:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  800f55:	eb d6                	jmp    800f2d <strtol+0x4c>
            dig -= '0';
  800f57:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  800f5a:	44 0f b6 c1          	movzbl %cl,%r8d
  800f5e:	41 39 d0             	cmp    %edx,%r8d
  800f61:	7d 21                	jge    800f84 <strtol+0xa3>
        val = val * base + dig;
  800f63:	49 0f af c1          	imul   %r9,%rax
  800f67:	0f b6 c9             	movzbl %cl,%ecx
  800f6a:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  800f6d:	48 83 c7 01          	add    $0x1,%rdi
  800f71:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  800f75:	80 f9 39             	cmp    $0x39,%cl
  800f78:	76 dd                	jbe    800f57 <strtol+0x76>
        else if (dig - 'a' < 27)
  800f7a:	80 f9 7b             	cmp    $0x7b,%cl
  800f7d:	77 05                	ja     800f84 <strtol+0xa3>
            dig -= 'a' - 10;
  800f7f:	83 e9 57             	sub    $0x57,%ecx
  800f82:	eb d6                	jmp    800f5a <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  800f84:	4d 85 d2             	test   %r10,%r10
  800f87:	74 03                	je     800f8c <strtol+0xab>
  800f89:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800f8c:	48 89 c2             	mov    %rax,%rdx
  800f8f:	48 f7 da             	neg    %rdx
  800f92:	40 80 fe 2d          	cmp    $0x2d,%sil
  800f96:	48 0f 44 c2          	cmove  %rdx,%rax
}
  800f9a:	c3                   	ret

0000000000800f9b <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800f9b:	f3 0f 1e fa          	endbr64
  800f9f:	55                   	push   %rbp
  800fa0:	48 89 e5             	mov    %rsp,%rbp
  800fa3:	53                   	push   %rbx
  800fa4:	48 89 fa             	mov    %rdi,%rdx
  800fa7:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800faa:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800faf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fb9:	be 00 00 00 00       	mov    $0x0,%esi
  800fbe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fc4:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800fc6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fca:	c9                   	leave
  800fcb:	c3                   	ret

0000000000800fcc <sys_cgetc>:

int
sys_cgetc(void) {
  800fcc:	f3 0f 1e fa          	endbr64
  800fd0:	55                   	push   %rbp
  800fd1:	48 89 e5             	mov    %rsp,%rbp
  800fd4:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800fd5:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800fda:	ba 00 00 00 00       	mov    $0x0,%edx
  800fdf:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fe4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fee:	be 00 00 00 00       	mov    $0x0,%esi
  800ff3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800ff9:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800ffb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fff:	c9                   	leave
  801000:	c3                   	ret

0000000000801001 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801001:	f3 0f 1e fa          	endbr64
  801005:	55                   	push   %rbp
  801006:	48 89 e5             	mov    %rsp,%rbp
  801009:	53                   	push   %rbx
  80100a:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80100e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801011:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801016:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80101b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801020:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801025:	be 00 00 00 00       	mov    $0x0,%esi
  80102a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801030:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801032:	48 85 c0             	test   %rax,%rax
  801035:	7f 06                	jg     80103d <sys_env_destroy+0x3c>
}
  801037:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80103b:	c9                   	leave
  80103c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80103d:	49 89 c0             	mov    %rax,%r8
  801040:	b9 03 00 00 00       	mov    $0x3,%ecx
  801045:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  80104c:	00 00 00 
  80104f:	be 26 00 00 00       	mov    $0x26,%esi
  801054:	48 bf aa 31 80 00 00 	movabs $0x8031aa,%rdi
  80105b:	00 00 00 
  80105e:	b8 00 00 00 00       	mov    $0x0,%eax
  801063:	49 b9 6b 2a 80 00 00 	movabs $0x802a6b,%r9
  80106a:	00 00 00 
  80106d:	41 ff d1             	call   *%r9

0000000000801070 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801070:	f3 0f 1e fa          	endbr64
  801074:	55                   	push   %rbp
  801075:	48 89 e5             	mov    %rsp,%rbp
  801078:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801079:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80107e:	ba 00 00 00 00       	mov    $0x0,%edx
  801083:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801088:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801092:	be 00 00 00 00       	mov    $0x0,%esi
  801097:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80109d:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80109f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010a3:	c9                   	leave
  8010a4:	c3                   	ret

00000000008010a5 <sys_yield>:

void
sys_yield(void) {
  8010a5:	f3 0f 1e fa          	endbr64
  8010a9:	55                   	push   %rbp
  8010aa:	48 89 e5             	mov    %rsp,%rbp
  8010ad:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010ae:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010c7:	be 00 00 00 00       	mov    $0x0,%esi
  8010cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010d2:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8010d4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010d8:	c9                   	leave
  8010d9:	c3                   	ret

00000000008010da <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8010da:	f3 0f 1e fa          	endbr64
  8010de:	55                   	push   %rbp
  8010df:	48 89 e5             	mov    %rsp,%rbp
  8010e2:	53                   	push   %rbx
  8010e3:	48 89 fa             	mov    %rdi,%rdx
  8010e6:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8010e9:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010ee:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8010f5:	00 00 00 
  8010f8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010fd:	be 00 00 00 00       	mov    $0x0,%esi
  801102:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801108:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80110a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80110e:	c9                   	leave
  80110f:	c3                   	ret

0000000000801110 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801110:	f3 0f 1e fa          	endbr64
  801114:	55                   	push   %rbp
  801115:	48 89 e5             	mov    %rsp,%rbp
  801118:	53                   	push   %rbx
  801119:	49 89 f8             	mov    %rdi,%r8
  80111c:	48 89 d3             	mov    %rdx,%rbx
  80111f:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801122:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801127:	4c 89 c2             	mov    %r8,%rdx
  80112a:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80112d:	be 00 00 00 00       	mov    $0x0,%esi
  801132:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801138:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80113a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80113e:	c9                   	leave
  80113f:	c3                   	ret

0000000000801140 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801140:	f3 0f 1e fa          	endbr64
  801144:	55                   	push   %rbp
  801145:	48 89 e5             	mov    %rsp,%rbp
  801148:	53                   	push   %rbx
  801149:	48 83 ec 08          	sub    $0x8,%rsp
  80114d:	89 f8                	mov    %edi,%eax
  80114f:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801152:	48 63 f9             	movslq %ecx,%rdi
  801155:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801158:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80115d:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801160:	be 00 00 00 00       	mov    $0x0,%esi
  801165:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80116b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80116d:	48 85 c0             	test   %rax,%rax
  801170:	7f 06                	jg     801178 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801172:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801176:	c9                   	leave
  801177:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801178:	49 89 c0             	mov    %rax,%r8
  80117b:	b9 04 00 00 00       	mov    $0x4,%ecx
  801180:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801187:	00 00 00 
  80118a:	be 26 00 00 00       	mov    $0x26,%esi
  80118f:	48 bf aa 31 80 00 00 	movabs $0x8031aa,%rdi
  801196:	00 00 00 
  801199:	b8 00 00 00 00       	mov    $0x0,%eax
  80119e:	49 b9 6b 2a 80 00 00 	movabs $0x802a6b,%r9
  8011a5:	00 00 00 
  8011a8:	41 ff d1             	call   *%r9

00000000008011ab <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8011ab:	f3 0f 1e fa          	endbr64
  8011af:	55                   	push   %rbp
  8011b0:	48 89 e5             	mov    %rsp,%rbp
  8011b3:	53                   	push   %rbx
  8011b4:	48 83 ec 08          	sub    $0x8,%rsp
  8011b8:	89 f8                	mov    %edi,%eax
  8011ba:	49 89 f2             	mov    %rsi,%r10
  8011bd:	48 89 cf             	mov    %rcx,%rdi
  8011c0:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8011c3:	48 63 da             	movslq %edx,%rbx
  8011c6:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011c9:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011ce:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011d1:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8011d4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011d6:	48 85 c0             	test   %rax,%rax
  8011d9:	7f 06                	jg     8011e1 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8011db:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011df:	c9                   	leave
  8011e0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011e1:	49 89 c0             	mov    %rax,%r8
  8011e4:	b9 05 00 00 00       	mov    $0x5,%ecx
  8011e9:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8011f0:	00 00 00 
  8011f3:	be 26 00 00 00       	mov    $0x26,%esi
  8011f8:	48 bf aa 31 80 00 00 	movabs $0x8031aa,%rdi
  8011ff:	00 00 00 
  801202:	b8 00 00 00 00       	mov    $0x0,%eax
  801207:	49 b9 6b 2a 80 00 00 	movabs $0x802a6b,%r9
  80120e:	00 00 00 
  801211:	41 ff d1             	call   *%r9

0000000000801214 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801214:	f3 0f 1e fa          	endbr64
  801218:	55                   	push   %rbp
  801219:	48 89 e5             	mov    %rsp,%rbp
  80121c:	53                   	push   %rbx
  80121d:	48 83 ec 08          	sub    $0x8,%rsp
  801221:	49 89 f9             	mov    %rdi,%r9
  801224:	89 f0                	mov    %esi,%eax
  801226:	48 89 d3             	mov    %rdx,%rbx
  801229:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80122c:	49 63 f0             	movslq %r8d,%rsi
  80122f:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801232:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801237:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80123a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801240:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801242:	48 85 c0             	test   %rax,%rax
  801245:	7f 06                	jg     80124d <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801247:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80124b:	c9                   	leave
  80124c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80124d:	49 89 c0             	mov    %rax,%r8
  801250:	b9 06 00 00 00       	mov    $0x6,%ecx
  801255:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  80125c:	00 00 00 
  80125f:	be 26 00 00 00       	mov    $0x26,%esi
  801264:	48 bf aa 31 80 00 00 	movabs $0x8031aa,%rdi
  80126b:	00 00 00 
  80126e:	b8 00 00 00 00       	mov    $0x0,%eax
  801273:	49 b9 6b 2a 80 00 00 	movabs $0x802a6b,%r9
  80127a:	00 00 00 
  80127d:	41 ff d1             	call   *%r9

0000000000801280 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801280:	f3 0f 1e fa          	endbr64
  801284:	55                   	push   %rbp
  801285:	48 89 e5             	mov    %rsp,%rbp
  801288:	53                   	push   %rbx
  801289:	48 83 ec 08          	sub    $0x8,%rsp
  80128d:	48 89 f1             	mov    %rsi,%rcx
  801290:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801293:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801296:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80129b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012a0:	be 00 00 00 00       	mov    $0x0,%esi
  8012a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012ab:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012ad:	48 85 c0             	test   %rax,%rax
  8012b0:	7f 06                	jg     8012b8 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8012b2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012b6:	c9                   	leave
  8012b7:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012b8:	49 89 c0             	mov    %rax,%r8
  8012bb:	b9 07 00 00 00       	mov    $0x7,%ecx
  8012c0:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8012c7:	00 00 00 
  8012ca:	be 26 00 00 00       	mov    $0x26,%esi
  8012cf:	48 bf aa 31 80 00 00 	movabs $0x8031aa,%rdi
  8012d6:	00 00 00 
  8012d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012de:	49 b9 6b 2a 80 00 00 	movabs $0x802a6b,%r9
  8012e5:	00 00 00 
  8012e8:	41 ff d1             	call   *%r9

00000000008012eb <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8012eb:	f3 0f 1e fa          	endbr64
  8012ef:	55                   	push   %rbp
  8012f0:	48 89 e5             	mov    %rsp,%rbp
  8012f3:	53                   	push   %rbx
  8012f4:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8012f8:	48 63 ce             	movslq %esi,%rcx
  8012fb:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012fe:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801303:	bb 00 00 00 00       	mov    $0x0,%ebx
  801308:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80130d:	be 00 00 00 00       	mov    $0x0,%esi
  801312:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801318:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80131a:	48 85 c0             	test   %rax,%rax
  80131d:	7f 06                	jg     801325 <sys_env_set_status+0x3a>
}
  80131f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801323:	c9                   	leave
  801324:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801325:	49 89 c0             	mov    %rax,%r8
  801328:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80132d:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801334:	00 00 00 
  801337:	be 26 00 00 00       	mov    $0x26,%esi
  80133c:	48 bf aa 31 80 00 00 	movabs $0x8031aa,%rdi
  801343:	00 00 00 
  801346:	b8 00 00 00 00       	mov    $0x0,%eax
  80134b:	49 b9 6b 2a 80 00 00 	movabs $0x802a6b,%r9
  801352:	00 00 00 
  801355:	41 ff d1             	call   *%r9

0000000000801358 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801358:	f3 0f 1e fa          	endbr64
  80135c:	55                   	push   %rbp
  80135d:	48 89 e5             	mov    %rsp,%rbp
  801360:	53                   	push   %rbx
  801361:	48 83 ec 08          	sub    $0x8,%rsp
  801365:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801368:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80136b:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801370:	bb 00 00 00 00       	mov    $0x0,%ebx
  801375:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80137a:	be 00 00 00 00       	mov    $0x0,%esi
  80137f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801385:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801387:	48 85 c0             	test   %rax,%rax
  80138a:	7f 06                	jg     801392 <sys_env_set_trapframe+0x3a>
}
  80138c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801390:	c9                   	leave
  801391:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801392:	49 89 c0             	mov    %rax,%r8
  801395:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80139a:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8013a1:	00 00 00 
  8013a4:	be 26 00 00 00       	mov    $0x26,%esi
  8013a9:	48 bf aa 31 80 00 00 	movabs $0x8031aa,%rdi
  8013b0:	00 00 00 
  8013b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b8:	49 b9 6b 2a 80 00 00 	movabs $0x802a6b,%r9
  8013bf:	00 00 00 
  8013c2:	41 ff d1             	call   *%r9

00000000008013c5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8013c5:	f3 0f 1e fa          	endbr64
  8013c9:	55                   	push   %rbp
  8013ca:	48 89 e5             	mov    %rsp,%rbp
  8013cd:	53                   	push   %rbx
  8013ce:	48 83 ec 08          	sub    $0x8,%rsp
  8013d2:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8013d5:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013d8:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e7:	be 00 00 00 00       	mov    $0x0,%esi
  8013ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013f2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013f4:	48 85 c0             	test   %rax,%rax
  8013f7:	7f 06                	jg     8013ff <sys_env_set_pgfault_upcall+0x3a>
}
  8013f9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013fd:	c9                   	leave
  8013fe:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013ff:	49 89 c0             	mov    %rax,%r8
  801402:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801407:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  80140e:	00 00 00 
  801411:	be 26 00 00 00       	mov    $0x26,%esi
  801416:	48 bf aa 31 80 00 00 	movabs $0x8031aa,%rdi
  80141d:	00 00 00 
  801420:	b8 00 00 00 00       	mov    $0x0,%eax
  801425:	49 b9 6b 2a 80 00 00 	movabs $0x802a6b,%r9
  80142c:	00 00 00 
  80142f:	41 ff d1             	call   *%r9

0000000000801432 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801432:	f3 0f 1e fa          	endbr64
  801436:	55                   	push   %rbp
  801437:	48 89 e5             	mov    %rsp,%rbp
  80143a:	53                   	push   %rbx
  80143b:	89 f8                	mov    %edi,%eax
  80143d:	49 89 f1             	mov    %rsi,%r9
  801440:	48 89 d3             	mov    %rdx,%rbx
  801443:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801446:	49 63 f0             	movslq %r8d,%rsi
  801449:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80144c:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801451:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801454:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80145a:	cd 30                	int    $0x30
}
  80145c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801460:	c9                   	leave
  801461:	c3                   	ret

0000000000801462 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801462:	f3 0f 1e fa          	endbr64
  801466:	55                   	push   %rbp
  801467:	48 89 e5             	mov    %rsp,%rbp
  80146a:	53                   	push   %rbx
  80146b:	48 83 ec 08          	sub    $0x8,%rsp
  80146f:	48 89 fa             	mov    %rdi,%rdx
  801472:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801475:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80147a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80147f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801484:	be 00 00 00 00       	mov    $0x0,%esi
  801489:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80148f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801491:	48 85 c0             	test   %rax,%rax
  801494:	7f 06                	jg     80149c <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801496:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80149a:	c9                   	leave
  80149b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80149c:	49 89 c0             	mov    %rax,%r8
  80149f:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8014a4:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8014ab:	00 00 00 
  8014ae:	be 26 00 00 00       	mov    $0x26,%esi
  8014b3:	48 bf aa 31 80 00 00 	movabs $0x8031aa,%rdi
  8014ba:	00 00 00 
  8014bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c2:	49 b9 6b 2a 80 00 00 	movabs $0x802a6b,%r9
  8014c9:	00 00 00 
  8014cc:	41 ff d1             	call   *%r9

00000000008014cf <sys_gettime>:

int
sys_gettime(void) {
  8014cf:	f3 0f 1e fa          	endbr64
  8014d3:	55                   	push   %rbp
  8014d4:	48 89 e5             	mov    %rsp,%rbp
  8014d7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014d8:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014ec:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014f1:	be 00 00 00 00       	mov    $0x0,%esi
  8014f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014fc:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8014fe:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801502:	c9                   	leave
  801503:	c3                   	ret

0000000000801504 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801504:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801508:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80150f:	ff ff ff 
  801512:	48 01 f8             	add    %rdi,%rax
  801515:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801519:	c3                   	ret

000000000080151a <fd2data>:

char *
fd2data(struct Fd *fd) {
  80151a:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80151e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801525:	ff ff ff 
  801528:	48 01 f8             	add    %rdi,%rax
  80152b:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80152f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801535:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801539:	c3                   	ret

000000000080153a <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80153a:	f3 0f 1e fa          	endbr64
  80153e:	55                   	push   %rbp
  80153f:	48 89 e5             	mov    %rsp,%rbp
  801542:	41 57                	push   %r15
  801544:	41 56                	push   %r14
  801546:	41 55                	push   %r13
  801548:	41 54                	push   %r12
  80154a:	53                   	push   %rbx
  80154b:	48 83 ec 08          	sub    $0x8,%rsp
  80154f:	49 89 ff             	mov    %rdi,%r15
  801552:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801557:	49 bd 99 26 80 00 00 	movabs $0x802699,%r13
  80155e:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801561:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801567:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  80156a:	48 89 df             	mov    %rbx,%rdi
  80156d:	41 ff d5             	call   *%r13
  801570:	83 e0 04             	and    $0x4,%eax
  801573:	74 17                	je     80158c <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801575:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80157c:	4c 39 f3             	cmp    %r14,%rbx
  80157f:	75 e6                	jne    801567 <fd_alloc+0x2d>
  801581:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801587:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  80158c:	4d 89 27             	mov    %r12,(%r15)
}
  80158f:	48 83 c4 08          	add    $0x8,%rsp
  801593:	5b                   	pop    %rbx
  801594:	41 5c                	pop    %r12
  801596:	41 5d                	pop    %r13
  801598:	41 5e                	pop    %r14
  80159a:	41 5f                	pop    %r15
  80159c:	5d                   	pop    %rbp
  80159d:	c3                   	ret

000000000080159e <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  80159e:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8015a2:	83 ff 1f             	cmp    $0x1f,%edi
  8015a5:	77 39                	ja     8015e0 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8015a7:	55                   	push   %rbp
  8015a8:	48 89 e5             	mov    %rsp,%rbp
  8015ab:	41 54                	push   %r12
  8015ad:	53                   	push   %rbx
  8015ae:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8015b1:	48 63 df             	movslq %edi,%rbx
  8015b4:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8015bb:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8015bf:	48 89 df             	mov    %rbx,%rdi
  8015c2:	48 b8 99 26 80 00 00 	movabs $0x802699,%rax
  8015c9:	00 00 00 
  8015cc:	ff d0                	call   *%rax
  8015ce:	a8 04                	test   $0x4,%al
  8015d0:	74 14                	je     8015e6 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8015d2:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8015d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015db:	5b                   	pop    %rbx
  8015dc:	41 5c                	pop    %r12
  8015de:	5d                   	pop    %rbp
  8015df:	c3                   	ret
        return -E_INVAL;
  8015e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015e5:	c3                   	ret
        return -E_INVAL;
  8015e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015eb:	eb ee                	jmp    8015db <fd_lookup+0x3d>

00000000008015ed <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8015ed:	f3 0f 1e fa          	endbr64
  8015f1:	55                   	push   %rbp
  8015f2:	48 89 e5             	mov    %rsp,%rbp
  8015f5:	41 54                	push   %r12
  8015f7:	53                   	push   %rbx
  8015f8:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  8015fb:	48 b8 c0 36 80 00 00 	movabs $0x8036c0,%rax
  801602:	00 00 00 
  801605:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  80160c:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  80160f:	39 3b                	cmp    %edi,(%rbx)
  801611:	74 47                	je     80165a <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801613:	48 83 c0 08          	add    $0x8,%rax
  801617:	48 8b 18             	mov    (%rax),%rbx
  80161a:	48 85 db             	test   %rbx,%rbx
  80161d:	75 f0                	jne    80160f <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80161f:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801626:	00 00 00 
  801629:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80162f:	89 fa                	mov    %edi,%edx
  801631:	48 bf 20 36 80 00 00 	movabs $0x803620,%rdi
  801638:	00 00 00 
  80163b:	b8 00 00 00 00       	mov    $0x0,%eax
  801640:	48 b9 f2 01 80 00 00 	movabs $0x8001f2,%rcx
  801647:	00 00 00 
  80164a:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  80164c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801651:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801655:	5b                   	pop    %rbx
  801656:	41 5c                	pop    %r12
  801658:	5d                   	pop    %rbp
  801659:	c3                   	ret
            return 0;
  80165a:	b8 00 00 00 00       	mov    $0x0,%eax
  80165f:	eb f0                	jmp    801651 <dev_lookup+0x64>

0000000000801661 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801661:	f3 0f 1e fa          	endbr64
  801665:	55                   	push   %rbp
  801666:	48 89 e5             	mov    %rsp,%rbp
  801669:	41 55                	push   %r13
  80166b:	41 54                	push   %r12
  80166d:	53                   	push   %rbx
  80166e:	48 83 ec 18          	sub    $0x18,%rsp
  801672:	48 89 fb             	mov    %rdi,%rbx
  801675:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801678:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80167f:	ff ff ff 
  801682:	48 01 df             	add    %rbx,%rdi
  801685:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801689:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80168d:	48 b8 9e 15 80 00 00 	movabs $0x80159e,%rax
  801694:	00 00 00 
  801697:	ff d0                	call   *%rax
  801699:	41 89 c5             	mov    %eax,%r13d
  80169c:	85 c0                	test   %eax,%eax
  80169e:	78 06                	js     8016a6 <fd_close+0x45>
  8016a0:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  8016a4:	74 1a                	je     8016c0 <fd_close+0x5f>
        return (must_exist ? res : 0);
  8016a6:	45 84 e4             	test   %r12b,%r12b
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ae:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8016b2:	44 89 e8             	mov    %r13d,%eax
  8016b5:	48 83 c4 18          	add    $0x18,%rsp
  8016b9:	5b                   	pop    %rbx
  8016ba:	41 5c                	pop    %r12
  8016bc:	41 5d                	pop    %r13
  8016be:	5d                   	pop    %rbp
  8016bf:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016c0:	8b 3b                	mov    (%rbx),%edi
  8016c2:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8016c6:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  8016cd:	00 00 00 
  8016d0:	ff d0                	call   *%rax
  8016d2:	41 89 c5             	mov    %eax,%r13d
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	78 1b                	js     8016f4 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8016d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016dd:	48 8b 40 20          	mov    0x20(%rax),%rax
  8016e1:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8016e7:	48 85 c0             	test   %rax,%rax
  8016ea:	74 08                	je     8016f4 <fd_close+0x93>
  8016ec:	48 89 df             	mov    %rbx,%rdi
  8016ef:	ff d0                	call   *%rax
  8016f1:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8016f4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8016f9:	48 89 de             	mov    %rbx,%rsi
  8016fc:	bf 00 00 00 00       	mov    $0x0,%edi
  801701:	48 b8 80 12 80 00 00 	movabs $0x801280,%rax
  801708:	00 00 00 
  80170b:	ff d0                	call   *%rax
    return res;
  80170d:	eb a3                	jmp    8016b2 <fd_close+0x51>

000000000080170f <close>:

int
close(int fdnum) {
  80170f:	f3 0f 1e fa          	endbr64
  801713:	55                   	push   %rbp
  801714:	48 89 e5             	mov    %rsp,%rbp
  801717:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80171b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80171f:	48 b8 9e 15 80 00 00 	movabs $0x80159e,%rax
  801726:	00 00 00 
  801729:	ff d0                	call   *%rax
    if (res < 0) return res;
  80172b:	85 c0                	test   %eax,%eax
  80172d:	78 15                	js     801744 <close+0x35>

    return fd_close(fd, 1);
  80172f:	be 01 00 00 00       	mov    $0x1,%esi
  801734:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801738:	48 b8 61 16 80 00 00 	movabs $0x801661,%rax
  80173f:	00 00 00 
  801742:	ff d0                	call   *%rax
}
  801744:	c9                   	leave
  801745:	c3                   	ret

0000000000801746 <close_all>:

void
close_all(void) {
  801746:	f3 0f 1e fa          	endbr64
  80174a:	55                   	push   %rbp
  80174b:	48 89 e5             	mov    %rsp,%rbp
  80174e:	41 54                	push   %r12
  801750:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801751:	bb 00 00 00 00       	mov    $0x0,%ebx
  801756:	49 bc 0f 17 80 00 00 	movabs $0x80170f,%r12
  80175d:	00 00 00 
  801760:	89 df                	mov    %ebx,%edi
  801762:	41 ff d4             	call   *%r12
  801765:	83 c3 01             	add    $0x1,%ebx
  801768:	83 fb 20             	cmp    $0x20,%ebx
  80176b:	75 f3                	jne    801760 <close_all+0x1a>
}
  80176d:	5b                   	pop    %rbx
  80176e:	41 5c                	pop    %r12
  801770:	5d                   	pop    %rbp
  801771:	c3                   	ret

0000000000801772 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801772:	f3 0f 1e fa          	endbr64
  801776:	55                   	push   %rbp
  801777:	48 89 e5             	mov    %rsp,%rbp
  80177a:	41 57                	push   %r15
  80177c:	41 56                	push   %r14
  80177e:	41 55                	push   %r13
  801780:	41 54                	push   %r12
  801782:	53                   	push   %rbx
  801783:	48 83 ec 18          	sub    $0x18,%rsp
  801787:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80178a:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  80178e:	48 b8 9e 15 80 00 00 	movabs $0x80159e,%rax
  801795:	00 00 00 
  801798:	ff d0                	call   *%rax
  80179a:	89 c3                	mov    %eax,%ebx
  80179c:	85 c0                	test   %eax,%eax
  80179e:	0f 88 b8 00 00 00    	js     80185c <dup+0xea>
    close(newfdnum);
  8017a4:	44 89 e7             	mov    %r12d,%edi
  8017a7:	48 b8 0f 17 80 00 00 	movabs $0x80170f,%rax
  8017ae:	00 00 00 
  8017b1:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8017b3:	4d 63 ec             	movslq %r12d,%r13
  8017b6:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8017bd:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8017c1:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8017c5:	4c 89 ff             	mov    %r15,%rdi
  8017c8:	49 be 1a 15 80 00 00 	movabs $0x80151a,%r14
  8017cf:	00 00 00 
  8017d2:	41 ff d6             	call   *%r14
  8017d5:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8017d8:	4c 89 ef             	mov    %r13,%rdi
  8017db:	41 ff d6             	call   *%r14
  8017de:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8017e1:	48 89 df             	mov    %rbx,%rdi
  8017e4:	48 b8 99 26 80 00 00 	movabs $0x802699,%rax
  8017eb:	00 00 00 
  8017ee:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8017f0:	a8 04                	test   $0x4,%al
  8017f2:	74 2b                	je     80181f <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8017f4:	41 89 c1             	mov    %eax,%r9d
  8017f7:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8017fd:	4c 89 f1             	mov    %r14,%rcx
  801800:	ba 00 00 00 00       	mov    $0x0,%edx
  801805:	48 89 de             	mov    %rbx,%rsi
  801808:	bf 00 00 00 00       	mov    $0x0,%edi
  80180d:	48 b8 ab 11 80 00 00 	movabs $0x8011ab,%rax
  801814:	00 00 00 
  801817:	ff d0                	call   *%rax
  801819:	89 c3                	mov    %eax,%ebx
  80181b:	85 c0                	test   %eax,%eax
  80181d:	78 4e                	js     80186d <dup+0xfb>
    }
    prot = get_prot(oldfd);
  80181f:	4c 89 ff             	mov    %r15,%rdi
  801822:	48 b8 99 26 80 00 00 	movabs $0x802699,%rax
  801829:	00 00 00 
  80182c:	ff d0                	call   *%rax
  80182e:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801831:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801837:	4c 89 e9             	mov    %r13,%rcx
  80183a:	ba 00 00 00 00       	mov    $0x0,%edx
  80183f:	4c 89 fe             	mov    %r15,%rsi
  801842:	bf 00 00 00 00       	mov    $0x0,%edi
  801847:	48 b8 ab 11 80 00 00 	movabs $0x8011ab,%rax
  80184e:	00 00 00 
  801851:	ff d0                	call   *%rax
  801853:	89 c3                	mov    %eax,%ebx
  801855:	85 c0                	test   %eax,%eax
  801857:	78 14                	js     80186d <dup+0xfb>

    return newfdnum;
  801859:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  80185c:	89 d8                	mov    %ebx,%eax
  80185e:	48 83 c4 18          	add    $0x18,%rsp
  801862:	5b                   	pop    %rbx
  801863:	41 5c                	pop    %r12
  801865:	41 5d                	pop    %r13
  801867:	41 5e                	pop    %r14
  801869:	41 5f                	pop    %r15
  80186b:	5d                   	pop    %rbp
  80186c:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80186d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801872:	4c 89 ee             	mov    %r13,%rsi
  801875:	bf 00 00 00 00       	mov    $0x0,%edi
  80187a:	49 bc 80 12 80 00 00 	movabs $0x801280,%r12
  801881:	00 00 00 
  801884:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801887:	ba 00 10 00 00       	mov    $0x1000,%edx
  80188c:	4c 89 f6             	mov    %r14,%rsi
  80188f:	bf 00 00 00 00       	mov    $0x0,%edi
  801894:	41 ff d4             	call   *%r12
    return res;
  801897:	eb c3                	jmp    80185c <dup+0xea>

0000000000801899 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801899:	f3 0f 1e fa          	endbr64
  80189d:	55                   	push   %rbp
  80189e:	48 89 e5             	mov    %rsp,%rbp
  8018a1:	41 56                	push   %r14
  8018a3:	41 55                	push   %r13
  8018a5:	41 54                	push   %r12
  8018a7:	53                   	push   %rbx
  8018a8:	48 83 ec 10          	sub    $0x10,%rsp
  8018ac:	89 fb                	mov    %edi,%ebx
  8018ae:	49 89 f4             	mov    %rsi,%r12
  8018b1:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8018b4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018b8:	48 b8 9e 15 80 00 00 	movabs $0x80159e,%rax
  8018bf:	00 00 00 
  8018c2:	ff d0                	call   *%rax
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	78 4c                	js     801914 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8018c8:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8018cc:	41 8b 3e             	mov    (%r14),%edi
  8018cf:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018d3:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  8018da:	00 00 00 
  8018dd:	ff d0                	call   *%rax
  8018df:	85 c0                	test   %eax,%eax
  8018e1:	78 35                	js     801918 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018e3:	41 8b 46 08          	mov    0x8(%r14),%eax
  8018e7:	83 e0 03             	and    $0x3,%eax
  8018ea:	83 f8 01             	cmp    $0x1,%eax
  8018ed:	74 2d                	je     80191c <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8018ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018f3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8018f7:	48 85 c0             	test   %rax,%rax
  8018fa:	74 56                	je     801952 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  8018fc:	4c 89 ea             	mov    %r13,%rdx
  8018ff:	4c 89 e6             	mov    %r12,%rsi
  801902:	4c 89 f7             	mov    %r14,%rdi
  801905:	ff d0                	call   *%rax
}
  801907:	48 83 c4 10          	add    $0x10,%rsp
  80190b:	5b                   	pop    %rbx
  80190c:	41 5c                	pop    %r12
  80190e:	41 5d                	pop    %r13
  801910:	41 5e                	pop    %r14
  801912:	5d                   	pop    %rbp
  801913:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801914:	48 98                	cltq
  801916:	eb ef                	jmp    801907 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801918:	48 98                	cltq
  80191a:	eb eb                	jmp    801907 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80191c:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801923:	00 00 00 
  801926:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80192c:	89 da                	mov    %ebx,%edx
  80192e:	48 bf b8 31 80 00 00 	movabs $0x8031b8,%rdi
  801935:	00 00 00 
  801938:	b8 00 00 00 00       	mov    $0x0,%eax
  80193d:	48 b9 f2 01 80 00 00 	movabs $0x8001f2,%rcx
  801944:	00 00 00 
  801947:	ff d1                	call   *%rcx
        return -E_INVAL;
  801949:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801950:	eb b5                	jmp    801907 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801952:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801959:	eb ac                	jmp    801907 <read+0x6e>

000000000080195b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  80195b:	f3 0f 1e fa          	endbr64
  80195f:	55                   	push   %rbp
  801960:	48 89 e5             	mov    %rsp,%rbp
  801963:	41 57                	push   %r15
  801965:	41 56                	push   %r14
  801967:	41 55                	push   %r13
  801969:	41 54                	push   %r12
  80196b:	53                   	push   %rbx
  80196c:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801970:	48 85 d2             	test   %rdx,%rdx
  801973:	74 54                	je     8019c9 <readn+0x6e>
  801975:	41 89 fd             	mov    %edi,%r13d
  801978:	49 89 f6             	mov    %rsi,%r14
  80197b:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  80197e:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801983:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801988:	49 bf 99 18 80 00 00 	movabs $0x801899,%r15
  80198f:	00 00 00 
  801992:	4c 89 e2             	mov    %r12,%rdx
  801995:	48 29 f2             	sub    %rsi,%rdx
  801998:	4c 01 f6             	add    %r14,%rsi
  80199b:	44 89 ef             	mov    %r13d,%edi
  80199e:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	78 20                	js     8019c5 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  8019a5:	01 c3                	add    %eax,%ebx
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	74 08                	je     8019b3 <readn+0x58>
  8019ab:	48 63 f3             	movslq %ebx,%rsi
  8019ae:	4c 39 e6             	cmp    %r12,%rsi
  8019b1:	72 df                	jb     801992 <readn+0x37>
    }
    return res;
  8019b3:	48 63 c3             	movslq %ebx,%rax
}
  8019b6:	48 83 c4 08          	add    $0x8,%rsp
  8019ba:	5b                   	pop    %rbx
  8019bb:	41 5c                	pop    %r12
  8019bd:	41 5d                	pop    %r13
  8019bf:	41 5e                	pop    %r14
  8019c1:	41 5f                	pop    %r15
  8019c3:	5d                   	pop    %rbp
  8019c4:	c3                   	ret
        if (inc < 0) return inc;
  8019c5:	48 98                	cltq
  8019c7:	eb ed                	jmp    8019b6 <readn+0x5b>
    int inc = 1, res = 0;
  8019c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019ce:	eb e3                	jmp    8019b3 <readn+0x58>

00000000008019d0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8019d0:	f3 0f 1e fa          	endbr64
  8019d4:	55                   	push   %rbp
  8019d5:	48 89 e5             	mov    %rsp,%rbp
  8019d8:	41 56                	push   %r14
  8019da:	41 55                	push   %r13
  8019dc:	41 54                	push   %r12
  8019de:	53                   	push   %rbx
  8019df:	48 83 ec 10          	sub    $0x10,%rsp
  8019e3:	89 fb                	mov    %edi,%ebx
  8019e5:	49 89 f4             	mov    %rsi,%r12
  8019e8:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019eb:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019ef:	48 b8 9e 15 80 00 00 	movabs $0x80159e,%rax
  8019f6:	00 00 00 
  8019f9:	ff d0                	call   *%rax
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	78 47                	js     801a46 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019ff:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801a03:	41 8b 3e             	mov    (%r14),%edi
  801a06:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a0a:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  801a11:	00 00 00 
  801a14:	ff d0                	call   *%rax
  801a16:	85 c0                	test   %eax,%eax
  801a18:	78 30                	js     801a4a <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a1a:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801a1f:	74 2d                	je     801a4e <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801a21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a25:	48 8b 40 18          	mov    0x18(%rax),%rax
  801a29:	48 85 c0             	test   %rax,%rax
  801a2c:	74 56                	je     801a84 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801a2e:	4c 89 ea             	mov    %r13,%rdx
  801a31:	4c 89 e6             	mov    %r12,%rsi
  801a34:	4c 89 f7             	mov    %r14,%rdi
  801a37:	ff d0                	call   *%rax
}
  801a39:	48 83 c4 10          	add    $0x10,%rsp
  801a3d:	5b                   	pop    %rbx
  801a3e:	41 5c                	pop    %r12
  801a40:	41 5d                	pop    %r13
  801a42:	41 5e                	pop    %r14
  801a44:	5d                   	pop    %rbp
  801a45:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a46:	48 98                	cltq
  801a48:	eb ef                	jmp    801a39 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a4a:	48 98                	cltq
  801a4c:	eb eb                	jmp    801a39 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a4e:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801a55:	00 00 00 
  801a58:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a5e:	89 da                	mov    %ebx,%edx
  801a60:	48 bf d4 31 80 00 00 	movabs $0x8031d4,%rdi
  801a67:	00 00 00 
  801a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6f:	48 b9 f2 01 80 00 00 	movabs $0x8001f2,%rcx
  801a76:	00 00 00 
  801a79:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a7b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801a82:	eb b5                	jmp    801a39 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801a84:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a8b:	eb ac                	jmp    801a39 <write+0x69>

0000000000801a8d <seek>:

int
seek(int fdnum, off_t offset) {
  801a8d:	f3 0f 1e fa          	endbr64
  801a91:	55                   	push   %rbp
  801a92:	48 89 e5             	mov    %rsp,%rbp
  801a95:	53                   	push   %rbx
  801a96:	48 83 ec 18          	sub    $0x18,%rsp
  801a9a:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a9c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801aa0:	48 b8 9e 15 80 00 00 	movabs $0x80159e,%rax
  801aa7:	00 00 00 
  801aaa:	ff d0                	call   *%rax
  801aac:	85 c0                	test   %eax,%eax
  801aae:	78 0c                	js     801abc <seek+0x2f>

    fd->fd_offset = offset;
  801ab0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ab4:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ab7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ac0:	c9                   	leave
  801ac1:	c3                   	ret

0000000000801ac2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801ac2:	f3 0f 1e fa          	endbr64
  801ac6:	55                   	push   %rbp
  801ac7:	48 89 e5             	mov    %rsp,%rbp
  801aca:	41 55                	push   %r13
  801acc:	41 54                	push   %r12
  801ace:	53                   	push   %rbx
  801acf:	48 83 ec 18          	sub    $0x18,%rsp
  801ad3:	89 fb                	mov    %edi,%ebx
  801ad5:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ad8:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801adc:	48 b8 9e 15 80 00 00 	movabs $0x80159e,%rax
  801ae3:	00 00 00 
  801ae6:	ff d0                	call   *%rax
  801ae8:	85 c0                	test   %eax,%eax
  801aea:	78 38                	js     801b24 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801aec:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801af0:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801af4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801af8:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  801aff:	00 00 00 
  801b02:	ff d0                	call   *%rax
  801b04:	85 c0                	test   %eax,%eax
  801b06:	78 1c                	js     801b24 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b08:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801b0d:	74 20                	je     801b2f <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801b0f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b13:	48 8b 40 30          	mov    0x30(%rax),%rax
  801b17:	48 85 c0             	test   %rax,%rax
  801b1a:	74 47                	je     801b63 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801b1c:	44 89 e6             	mov    %r12d,%esi
  801b1f:	4c 89 ef             	mov    %r13,%rdi
  801b22:	ff d0                	call   *%rax
}
  801b24:	48 83 c4 18          	add    $0x18,%rsp
  801b28:	5b                   	pop    %rbx
  801b29:	41 5c                	pop    %r12
  801b2b:	41 5d                	pop    %r13
  801b2d:	5d                   	pop    %rbp
  801b2e:	c3                   	ret
                thisenv->env_id, fdnum);
  801b2f:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801b36:	00 00 00 
  801b39:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b3f:	89 da                	mov    %ebx,%edx
  801b41:	48 bf 40 36 80 00 00 	movabs $0x803640,%rdi
  801b48:	00 00 00 
  801b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b50:	48 b9 f2 01 80 00 00 	movabs $0x8001f2,%rcx
  801b57:	00 00 00 
  801b5a:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b5c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b61:	eb c1                	jmp    801b24 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801b63:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801b68:	eb ba                	jmp    801b24 <ftruncate+0x62>

0000000000801b6a <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801b6a:	f3 0f 1e fa          	endbr64
  801b6e:	55                   	push   %rbp
  801b6f:	48 89 e5             	mov    %rsp,%rbp
  801b72:	41 54                	push   %r12
  801b74:	53                   	push   %rbx
  801b75:	48 83 ec 10          	sub    $0x10,%rsp
  801b79:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b7c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801b80:	48 b8 9e 15 80 00 00 	movabs $0x80159e,%rax
  801b87:	00 00 00 
  801b8a:	ff d0                	call   *%rax
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	78 4e                	js     801bde <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b90:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801b94:	41 8b 3c 24          	mov    (%r12),%edi
  801b98:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801b9c:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  801ba3:	00 00 00 
  801ba6:	ff d0                	call   *%rax
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	78 32                	js     801bde <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801bac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bb0:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801bb5:	74 30                	je     801be7 <fstat+0x7d>

    stat->st_name[0] = 0;
  801bb7:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801bba:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801bc1:	00 00 00 
    stat->st_isdir = 0;
  801bc4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801bcb:	00 00 00 
    stat->st_dev = dev;
  801bce:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801bd5:	48 89 de             	mov    %rbx,%rsi
  801bd8:	4c 89 e7             	mov    %r12,%rdi
  801bdb:	ff 50 28             	call   *0x28(%rax)
}
  801bde:	48 83 c4 10          	add    $0x10,%rsp
  801be2:	5b                   	pop    %rbx
  801be3:	41 5c                	pop    %r12
  801be5:	5d                   	pop    %rbp
  801be6:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801be7:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801bec:	eb f0                	jmp    801bde <fstat+0x74>

0000000000801bee <stat>:

int
stat(const char *path, struct Stat *stat) {
  801bee:	f3 0f 1e fa          	endbr64
  801bf2:	55                   	push   %rbp
  801bf3:	48 89 e5             	mov    %rsp,%rbp
  801bf6:	41 54                	push   %r12
  801bf8:	53                   	push   %rbx
  801bf9:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801bfc:	be 00 00 00 00       	mov    $0x0,%esi
  801c01:	48 b8 cf 1e 80 00 00 	movabs $0x801ecf,%rax
  801c08:	00 00 00 
  801c0b:	ff d0                	call   *%rax
  801c0d:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	78 25                	js     801c38 <stat+0x4a>

    int res = fstat(fd, stat);
  801c13:	4c 89 e6             	mov    %r12,%rsi
  801c16:	89 c7                	mov    %eax,%edi
  801c18:	48 b8 6a 1b 80 00 00 	movabs $0x801b6a,%rax
  801c1f:	00 00 00 
  801c22:	ff d0                	call   *%rax
  801c24:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801c27:	89 df                	mov    %ebx,%edi
  801c29:	48 b8 0f 17 80 00 00 	movabs $0x80170f,%rax
  801c30:	00 00 00 
  801c33:	ff d0                	call   *%rax

    return res;
  801c35:	44 89 e3             	mov    %r12d,%ebx
}
  801c38:	89 d8                	mov    %ebx,%eax
  801c3a:	5b                   	pop    %rbx
  801c3b:	41 5c                	pop    %r12
  801c3d:	5d                   	pop    %rbp
  801c3e:	c3                   	ret

0000000000801c3f <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801c3f:	f3 0f 1e fa          	endbr64
  801c43:	55                   	push   %rbp
  801c44:	48 89 e5             	mov    %rsp,%rbp
  801c47:	41 54                	push   %r12
  801c49:	53                   	push   %rbx
  801c4a:	48 83 ec 10          	sub    $0x10,%rsp
  801c4e:	41 89 fc             	mov    %edi,%r12d
  801c51:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801c54:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c5b:	00 00 00 
  801c5e:	83 38 00             	cmpl   $0x0,(%rax)
  801c61:	74 6e                	je     801cd1 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801c63:	bf 03 00 00 00       	mov    $0x3,%edi
  801c68:	48 b8 6d 2c 80 00 00 	movabs $0x802c6d,%rax
  801c6f:	00 00 00 
  801c72:	ff d0                	call   *%rax
  801c74:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801c7b:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801c7d:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801c83:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c88:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801c8f:	00 00 00 
  801c92:	44 89 e6             	mov    %r12d,%esi
  801c95:	89 c7                	mov    %eax,%edi
  801c97:	48 b8 ab 2b 80 00 00 	movabs $0x802bab,%rax
  801c9e:	00 00 00 
  801ca1:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801ca3:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801caa:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801cab:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801cb4:	48 89 de             	mov    %rbx,%rsi
  801cb7:	bf 00 00 00 00       	mov    $0x0,%edi
  801cbc:	48 b8 12 2b 80 00 00 	movabs $0x802b12,%rax
  801cc3:	00 00 00 
  801cc6:	ff d0                	call   *%rax
}
  801cc8:	48 83 c4 10          	add    $0x10,%rsp
  801ccc:	5b                   	pop    %rbx
  801ccd:	41 5c                	pop    %r12
  801ccf:	5d                   	pop    %rbp
  801cd0:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801cd1:	bf 03 00 00 00       	mov    $0x3,%edi
  801cd6:	48 b8 6d 2c 80 00 00 	movabs $0x802c6d,%rax
  801cdd:	00 00 00 
  801ce0:	ff d0                	call   *%rax
  801ce2:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801ce9:	00 00 
  801ceb:	e9 73 ff ff ff       	jmp    801c63 <fsipc+0x24>

0000000000801cf0 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801cf0:	f3 0f 1e fa          	endbr64
  801cf4:	55                   	push   %rbp
  801cf5:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cf8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801cff:	00 00 00 
  801d02:	8b 57 0c             	mov    0xc(%rdi),%edx
  801d05:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801d07:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801d0a:	be 00 00 00 00       	mov    $0x0,%esi
  801d0f:	bf 02 00 00 00       	mov    $0x2,%edi
  801d14:	48 b8 3f 1c 80 00 00 	movabs $0x801c3f,%rax
  801d1b:	00 00 00 
  801d1e:	ff d0                	call   *%rax
}
  801d20:	5d                   	pop    %rbp
  801d21:	c3                   	ret

0000000000801d22 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801d22:	f3 0f 1e fa          	endbr64
  801d26:	55                   	push   %rbp
  801d27:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d2a:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d2d:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d34:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801d36:	be 00 00 00 00       	mov    $0x0,%esi
  801d3b:	bf 06 00 00 00       	mov    $0x6,%edi
  801d40:	48 b8 3f 1c 80 00 00 	movabs $0x801c3f,%rax
  801d47:	00 00 00 
  801d4a:	ff d0                	call   *%rax
}
  801d4c:	5d                   	pop    %rbp
  801d4d:	c3                   	ret

0000000000801d4e <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801d4e:	f3 0f 1e fa          	endbr64
  801d52:	55                   	push   %rbp
  801d53:	48 89 e5             	mov    %rsp,%rbp
  801d56:	41 54                	push   %r12
  801d58:	53                   	push   %rbx
  801d59:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d5c:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d5f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d66:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801d68:	be 00 00 00 00       	mov    $0x0,%esi
  801d6d:	bf 05 00 00 00       	mov    $0x5,%edi
  801d72:	48 b8 3f 1c 80 00 00 	movabs $0x801c3f,%rax
  801d79:	00 00 00 
  801d7c:	ff d0                	call   *%rax
    if (res < 0) return res;
  801d7e:	85 c0                	test   %eax,%eax
  801d80:	78 3d                	js     801dbf <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d82:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  801d89:	00 00 00 
  801d8c:	4c 89 e6             	mov    %r12,%rsi
  801d8f:	48 89 df             	mov    %rbx,%rdi
  801d92:	48 b8 3b 0b 80 00 00 	movabs $0x800b3b,%rax
  801d99:	00 00 00 
  801d9c:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801d9e:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801da5:	00 
  801da6:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dac:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801db3:	00 
  801db4:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbf:	5b                   	pop    %rbx
  801dc0:	41 5c                	pop    %r12
  801dc2:	5d                   	pop    %rbp
  801dc3:	c3                   	ret

0000000000801dc4 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801dc4:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801dc8:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801dcf:	77 41                	ja     801e12 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801dd1:	55                   	push   %rbp
  801dd2:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801dd5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801ddc:	00 00 00 
  801ddf:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801de2:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  801de4:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801de8:	48 8d 78 10          	lea    0x10(%rax),%rdi
  801dec:	48 b8 56 0d 80 00 00 	movabs $0x800d56,%rax
  801df3:	00 00 00 
  801df6:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  801df8:	be 00 00 00 00       	mov    $0x0,%esi
  801dfd:	bf 04 00 00 00       	mov    $0x4,%edi
  801e02:	48 b8 3f 1c 80 00 00 	movabs $0x801c3f,%rax
  801e09:	00 00 00 
  801e0c:	ff d0                	call   *%rax
  801e0e:	48 98                	cltq
}
  801e10:	5d                   	pop    %rbp
  801e11:	c3                   	ret
        return -E_INVAL;
  801e12:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  801e19:	c3                   	ret

0000000000801e1a <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801e1a:	f3 0f 1e fa          	endbr64
  801e1e:	55                   	push   %rbp
  801e1f:	48 89 e5             	mov    %rsp,%rbp
  801e22:	41 55                	push   %r13
  801e24:	41 54                	push   %r12
  801e26:	53                   	push   %rbx
  801e27:	48 83 ec 08          	sub    $0x8,%rsp
  801e2b:	49 89 f4             	mov    %rsi,%r12
  801e2e:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e31:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e38:	00 00 00 
  801e3b:	8b 57 0c             	mov    0xc(%rdi),%edx
  801e3e:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  801e40:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  801e44:	be 00 00 00 00       	mov    $0x0,%esi
  801e49:	bf 03 00 00 00       	mov    $0x3,%edi
  801e4e:	48 b8 3f 1c 80 00 00 	movabs $0x801c3f,%rax
  801e55:	00 00 00 
  801e58:	ff d0                	call   *%rax
  801e5a:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  801e5d:	4d 85 ed             	test   %r13,%r13
  801e60:	78 2a                	js     801e8c <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  801e62:	4c 89 ea             	mov    %r13,%rdx
  801e65:	4c 39 eb             	cmp    %r13,%rbx
  801e68:	72 30                	jb     801e9a <devfile_read+0x80>
  801e6a:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  801e71:	7f 27                	jg     801e9a <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  801e73:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801e7a:	00 00 00 
  801e7d:	4c 89 e7             	mov    %r12,%rdi
  801e80:	48 b8 56 0d 80 00 00 	movabs $0x800d56,%rax
  801e87:	00 00 00 
  801e8a:	ff d0                	call   *%rax
}
  801e8c:	4c 89 e8             	mov    %r13,%rax
  801e8f:	48 83 c4 08          	add    $0x8,%rsp
  801e93:	5b                   	pop    %rbx
  801e94:	41 5c                	pop    %r12
  801e96:	41 5d                	pop    %r13
  801e98:	5d                   	pop    %rbp
  801e99:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801e9a:	48 b9 f1 31 80 00 00 	movabs $0x8031f1,%rcx
  801ea1:	00 00 00 
  801ea4:	48 ba 0e 32 80 00 00 	movabs $0x80320e,%rdx
  801eab:	00 00 00 
  801eae:	be 7b 00 00 00       	mov    $0x7b,%esi
  801eb3:	48 bf 23 32 80 00 00 	movabs $0x803223,%rdi
  801eba:	00 00 00 
  801ebd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec2:	49 b8 6b 2a 80 00 00 	movabs $0x802a6b,%r8
  801ec9:	00 00 00 
  801ecc:	41 ff d0             	call   *%r8

0000000000801ecf <open>:
open(const char *path, int mode) {
  801ecf:	f3 0f 1e fa          	endbr64
  801ed3:	55                   	push   %rbp
  801ed4:	48 89 e5             	mov    %rsp,%rbp
  801ed7:	41 55                	push   %r13
  801ed9:	41 54                	push   %r12
  801edb:	53                   	push   %rbx
  801edc:	48 83 ec 18          	sub    $0x18,%rsp
  801ee0:	49 89 fc             	mov    %rdi,%r12
  801ee3:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801ee6:	48 b8 f6 0a 80 00 00 	movabs $0x800af6,%rax
  801eed:	00 00 00 
  801ef0:	ff d0                	call   *%rax
  801ef2:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801ef8:	0f 87 8a 00 00 00    	ja     801f88 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801efe:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801f02:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  801f09:	00 00 00 
  801f0c:	ff d0                	call   *%rax
  801f0e:	89 c3                	mov    %eax,%ebx
  801f10:	85 c0                	test   %eax,%eax
  801f12:	78 50                	js     801f64 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  801f14:	4c 89 e6             	mov    %r12,%rsi
  801f17:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801f1e:	00 00 00 
  801f21:	48 89 df             	mov    %rbx,%rdi
  801f24:	48 b8 3b 0b 80 00 00 	movabs $0x800b3b,%rax
  801f2b:	00 00 00 
  801f2e:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801f30:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f37:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801f3b:	bf 01 00 00 00       	mov    $0x1,%edi
  801f40:	48 b8 3f 1c 80 00 00 	movabs $0x801c3f,%rax
  801f47:	00 00 00 
  801f4a:	ff d0                	call   *%rax
  801f4c:	89 c3                	mov    %eax,%ebx
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	78 1f                	js     801f71 <open+0xa2>
    return fd2num(fd);
  801f52:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f56:	48 b8 04 15 80 00 00 	movabs $0x801504,%rax
  801f5d:	00 00 00 
  801f60:	ff d0                	call   *%rax
  801f62:	89 c3                	mov    %eax,%ebx
}
  801f64:	89 d8                	mov    %ebx,%eax
  801f66:	48 83 c4 18          	add    $0x18,%rsp
  801f6a:	5b                   	pop    %rbx
  801f6b:	41 5c                	pop    %r12
  801f6d:	41 5d                	pop    %r13
  801f6f:	5d                   	pop    %rbp
  801f70:	c3                   	ret
        fd_close(fd, 0);
  801f71:	be 00 00 00 00       	mov    $0x0,%esi
  801f76:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f7a:	48 b8 61 16 80 00 00 	movabs $0x801661,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	call   *%rax
        return res;
  801f86:	eb dc                	jmp    801f64 <open+0x95>
        return -E_BAD_PATH;
  801f88:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801f8d:	eb d5                	jmp    801f64 <open+0x95>

0000000000801f8f <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801f8f:	f3 0f 1e fa          	endbr64
  801f93:	55                   	push   %rbp
  801f94:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801f97:	be 00 00 00 00       	mov    $0x0,%esi
  801f9c:	bf 08 00 00 00       	mov    $0x8,%edi
  801fa1:	48 b8 3f 1c 80 00 00 	movabs $0x801c3f,%rax
  801fa8:	00 00 00 
  801fab:	ff d0                	call   *%rax
}
  801fad:	5d                   	pop    %rbp
  801fae:	c3                   	ret

0000000000801faf <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801faf:	f3 0f 1e fa          	endbr64
  801fb3:	55                   	push   %rbp
  801fb4:	48 89 e5             	mov    %rsp,%rbp
  801fb7:	41 54                	push   %r12
  801fb9:	53                   	push   %rbx
  801fba:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801fbd:	48 b8 1a 15 80 00 00 	movabs $0x80151a,%rax
  801fc4:	00 00 00 
  801fc7:	ff d0                	call   *%rax
  801fc9:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801fcc:	48 be 2e 32 80 00 00 	movabs $0x80322e,%rsi
  801fd3:	00 00 00 
  801fd6:	48 89 df             	mov    %rbx,%rdi
  801fd9:	48 b8 3b 0b 80 00 00 	movabs $0x800b3b,%rax
  801fe0:	00 00 00 
  801fe3:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801fe5:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801fea:	41 2b 04 24          	sub    (%r12),%eax
  801fee:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801ff4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ffb:	00 00 00 
    stat->st_dev = &devpipe;
  801ffe:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802005:	00 00 00 
  802008:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80200f:	b8 00 00 00 00       	mov    $0x0,%eax
  802014:	5b                   	pop    %rbx
  802015:	41 5c                	pop    %r12
  802017:	5d                   	pop    %rbp
  802018:	c3                   	ret

0000000000802019 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802019:	f3 0f 1e fa          	endbr64
  80201d:	55                   	push   %rbp
  80201e:	48 89 e5             	mov    %rsp,%rbp
  802021:	41 54                	push   %r12
  802023:	53                   	push   %rbx
  802024:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802027:	ba 00 10 00 00       	mov    $0x1000,%edx
  80202c:	48 89 fe             	mov    %rdi,%rsi
  80202f:	bf 00 00 00 00       	mov    $0x0,%edi
  802034:	49 bc 80 12 80 00 00 	movabs $0x801280,%r12
  80203b:	00 00 00 
  80203e:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802041:	48 89 df             	mov    %rbx,%rdi
  802044:	48 b8 1a 15 80 00 00 	movabs $0x80151a,%rax
  80204b:	00 00 00 
  80204e:	ff d0                	call   *%rax
  802050:	48 89 c6             	mov    %rax,%rsi
  802053:	ba 00 10 00 00       	mov    $0x1000,%edx
  802058:	bf 00 00 00 00       	mov    $0x0,%edi
  80205d:	41 ff d4             	call   *%r12
}
  802060:	5b                   	pop    %rbx
  802061:	41 5c                	pop    %r12
  802063:	5d                   	pop    %rbp
  802064:	c3                   	ret

0000000000802065 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802065:	f3 0f 1e fa          	endbr64
  802069:	55                   	push   %rbp
  80206a:	48 89 e5             	mov    %rsp,%rbp
  80206d:	41 57                	push   %r15
  80206f:	41 56                	push   %r14
  802071:	41 55                	push   %r13
  802073:	41 54                	push   %r12
  802075:	53                   	push   %rbx
  802076:	48 83 ec 18          	sub    $0x18,%rsp
  80207a:	49 89 fc             	mov    %rdi,%r12
  80207d:	49 89 f5             	mov    %rsi,%r13
  802080:	49 89 d7             	mov    %rdx,%r15
  802083:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802087:	48 b8 1a 15 80 00 00 	movabs $0x80151a,%rax
  80208e:	00 00 00 
  802091:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802093:	4d 85 ff             	test   %r15,%r15
  802096:	0f 84 af 00 00 00    	je     80214b <devpipe_write+0xe6>
  80209c:	48 89 c3             	mov    %rax,%rbx
  80209f:	4c 89 f8             	mov    %r15,%rax
  8020a2:	4d 89 ef             	mov    %r13,%r15
  8020a5:	4c 01 e8             	add    %r13,%rax
  8020a8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8020ac:	49 bd 10 11 80 00 00 	movabs $0x801110,%r13
  8020b3:	00 00 00 
            sys_yield();
  8020b6:	49 be a5 10 80 00 00 	movabs $0x8010a5,%r14
  8020bd:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8020c0:	8b 73 04             	mov    0x4(%rbx),%esi
  8020c3:	48 63 ce             	movslq %esi,%rcx
  8020c6:	48 63 03             	movslq (%rbx),%rax
  8020c9:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8020cf:	48 39 c1             	cmp    %rax,%rcx
  8020d2:	72 2e                	jb     802102 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8020d4:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020d9:	48 89 da             	mov    %rbx,%rdx
  8020dc:	be 00 10 00 00       	mov    $0x1000,%esi
  8020e1:	4c 89 e7             	mov    %r12,%rdi
  8020e4:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	74 66                	je     802151 <devpipe_write+0xec>
            sys_yield();
  8020eb:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8020ee:	8b 73 04             	mov    0x4(%rbx),%esi
  8020f1:	48 63 ce             	movslq %esi,%rcx
  8020f4:	48 63 03             	movslq (%rbx),%rax
  8020f7:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8020fd:	48 39 c1             	cmp    %rax,%rcx
  802100:	73 d2                	jae    8020d4 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802102:	41 0f b6 3f          	movzbl (%r15),%edi
  802106:	48 89 ca             	mov    %rcx,%rdx
  802109:	48 c1 ea 03          	shr    $0x3,%rdx
  80210d:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802114:	08 10 20 
  802117:	48 f7 e2             	mul    %rdx
  80211a:	48 c1 ea 06          	shr    $0x6,%rdx
  80211e:	48 89 d0             	mov    %rdx,%rax
  802121:	48 c1 e0 09          	shl    $0x9,%rax
  802125:	48 29 d0             	sub    %rdx,%rax
  802128:	48 c1 e0 03          	shl    $0x3,%rax
  80212c:	48 29 c1             	sub    %rax,%rcx
  80212f:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802134:	83 c6 01             	add    $0x1,%esi
  802137:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80213a:	49 83 c7 01          	add    $0x1,%r15
  80213e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802142:	49 39 c7             	cmp    %rax,%r15
  802145:	0f 85 75 ff ff ff    	jne    8020c0 <devpipe_write+0x5b>
    return n;
  80214b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80214f:	eb 05                	jmp    802156 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802151:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802156:	48 83 c4 18          	add    $0x18,%rsp
  80215a:	5b                   	pop    %rbx
  80215b:	41 5c                	pop    %r12
  80215d:	41 5d                	pop    %r13
  80215f:	41 5e                	pop    %r14
  802161:	41 5f                	pop    %r15
  802163:	5d                   	pop    %rbp
  802164:	c3                   	ret

0000000000802165 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802165:	f3 0f 1e fa          	endbr64
  802169:	55                   	push   %rbp
  80216a:	48 89 e5             	mov    %rsp,%rbp
  80216d:	41 57                	push   %r15
  80216f:	41 56                	push   %r14
  802171:	41 55                	push   %r13
  802173:	41 54                	push   %r12
  802175:	53                   	push   %rbx
  802176:	48 83 ec 18          	sub    $0x18,%rsp
  80217a:	49 89 fc             	mov    %rdi,%r12
  80217d:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802181:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802185:	48 b8 1a 15 80 00 00 	movabs $0x80151a,%rax
  80218c:	00 00 00 
  80218f:	ff d0                	call   *%rax
  802191:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802194:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80219a:	49 bd 10 11 80 00 00 	movabs $0x801110,%r13
  8021a1:	00 00 00 
            sys_yield();
  8021a4:	49 be a5 10 80 00 00 	movabs $0x8010a5,%r14
  8021ab:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8021ae:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8021b3:	74 7d                	je     802232 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8021b5:	8b 03                	mov    (%rbx),%eax
  8021b7:	3b 43 04             	cmp    0x4(%rbx),%eax
  8021ba:	75 26                	jne    8021e2 <devpipe_read+0x7d>
            if (i > 0) return i;
  8021bc:	4d 85 ff             	test   %r15,%r15
  8021bf:	75 77                	jne    802238 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021c1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021c6:	48 89 da             	mov    %rbx,%rdx
  8021c9:	be 00 10 00 00       	mov    $0x1000,%esi
  8021ce:	4c 89 e7             	mov    %r12,%rdi
  8021d1:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8021d4:	85 c0                	test   %eax,%eax
  8021d6:	74 72                	je     80224a <devpipe_read+0xe5>
            sys_yield();
  8021d8:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8021db:	8b 03                	mov    (%rbx),%eax
  8021dd:	3b 43 04             	cmp    0x4(%rbx),%eax
  8021e0:	74 df                	je     8021c1 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021e2:	48 63 c8             	movslq %eax,%rcx
  8021e5:	48 89 ca             	mov    %rcx,%rdx
  8021e8:	48 c1 ea 03          	shr    $0x3,%rdx
  8021ec:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8021f3:	08 10 20 
  8021f6:	48 89 d0             	mov    %rdx,%rax
  8021f9:	48 f7 e6             	mul    %rsi
  8021fc:	48 c1 ea 06          	shr    $0x6,%rdx
  802200:	48 89 d0             	mov    %rdx,%rax
  802203:	48 c1 e0 09          	shl    $0x9,%rax
  802207:	48 29 d0             	sub    %rdx,%rax
  80220a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802211:	00 
  802212:	48 89 c8             	mov    %rcx,%rax
  802215:	48 29 d0             	sub    %rdx,%rax
  802218:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80221d:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802221:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802225:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802228:	49 83 c7 01          	add    $0x1,%r15
  80222c:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802230:	75 83                	jne    8021b5 <devpipe_read+0x50>
    return n;
  802232:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802236:	eb 03                	jmp    80223b <devpipe_read+0xd6>
            if (i > 0) return i;
  802238:	4c 89 f8             	mov    %r15,%rax
}
  80223b:	48 83 c4 18          	add    $0x18,%rsp
  80223f:	5b                   	pop    %rbx
  802240:	41 5c                	pop    %r12
  802242:	41 5d                	pop    %r13
  802244:	41 5e                	pop    %r14
  802246:	41 5f                	pop    %r15
  802248:	5d                   	pop    %rbp
  802249:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  80224a:	b8 00 00 00 00       	mov    $0x0,%eax
  80224f:	eb ea                	jmp    80223b <devpipe_read+0xd6>

0000000000802251 <pipe>:
pipe(int pfd[2]) {
  802251:	f3 0f 1e fa          	endbr64
  802255:	55                   	push   %rbp
  802256:	48 89 e5             	mov    %rsp,%rbp
  802259:	41 55                	push   %r13
  80225b:	41 54                	push   %r12
  80225d:	53                   	push   %rbx
  80225e:	48 83 ec 18          	sub    $0x18,%rsp
  802262:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802265:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802269:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  802270:	00 00 00 
  802273:	ff d0                	call   *%rax
  802275:	89 c3                	mov    %eax,%ebx
  802277:	85 c0                	test   %eax,%eax
  802279:	0f 88 a0 01 00 00    	js     80241f <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80227f:	b9 46 00 00 00       	mov    $0x46,%ecx
  802284:	ba 00 10 00 00       	mov    $0x1000,%edx
  802289:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80228d:	bf 00 00 00 00       	mov    $0x0,%edi
  802292:	48 b8 40 11 80 00 00 	movabs $0x801140,%rax
  802299:	00 00 00 
  80229c:	ff d0                	call   *%rax
  80229e:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	0f 88 77 01 00 00    	js     80241f <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8022a8:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8022ac:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  8022b3:	00 00 00 
  8022b6:	ff d0                	call   *%rax
  8022b8:	89 c3                	mov    %eax,%ebx
  8022ba:	85 c0                	test   %eax,%eax
  8022bc:	0f 88 43 01 00 00    	js     802405 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8022c2:	b9 46 00 00 00       	mov    $0x46,%ecx
  8022c7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022cc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d5:	48 b8 40 11 80 00 00 	movabs $0x801140,%rax
  8022dc:	00 00 00 
  8022df:	ff d0                	call   *%rax
  8022e1:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8022e3:	85 c0                	test   %eax,%eax
  8022e5:	0f 88 1a 01 00 00    	js     802405 <pipe+0x1b4>
    va = fd2data(fd0);
  8022eb:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022ef:	48 b8 1a 15 80 00 00 	movabs $0x80151a,%rax
  8022f6:	00 00 00 
  8022f9:	ff d0                	call   *%rax
  8022fb:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8022fe:	b9 46 00 00 00       	mov    $0x46,%ecx
  802303:	ba 00 10 00 00       	mov    $0x1000,%edx
  802308:	48 89 c6             	mov    %rax,%rsi
  80230b:	bf 00 00 00 00       	mov    $0x0,%edi
  802310:	48 b8 40 11 80 00 00 	movabs $0x801140,%rax
  802317:	00 00 00 
  80231a:	ff d0                	call   *%rax
  80231c:	89 c3                	mov    %eax,%ebx
  80231e:	85 c0                	test   %eax,%eax
  802320:	0f 88 c5 00 00 00    	js     8023eb <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802326:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80232a:	48 b8 1a 15 80 00 00 	movabs $0x80151a,%rax
  802331:	00 00 00 
  802334:	ff d0                	call   *%rax
  802336:	48 89 c1             	mov    %rax,%rcx
  802339:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80233f:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802345:	ba 00 00 00 00       	mov    $0x0,%edx
  80234a:	4c 89 ee             	mov    %r13,%rsi
  80234d:	bf 00 00 00 00       	mov    $0x0,%edi
  802352:	48 b8 ab 11 80 00 00 	movabs $0x8011ab,%rax
  802359:	00 00 00 
  80235c:	ff d0                	call   *%rax
  80235e:	89 c3                	mov    %eax,%ebx
  802360:	85 c0                	test   %eax,%eax
  802362:	78 6e                	js     8023d2 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802364:	be 00 10 00 00       	mov    $0x1000,%esi
  802369:	4c 89 ef             	mov    %r13,%rdi
  80236c:	48 b8 da 10 80 00 00 	movabs $0x8010da,%rax
  802373:	00 00 00 
  802376:	ff d0                	call   *%rax
  802378:	83 f8 02             	cmp    $0x2,%eax
  80237b:	0f 85 ab 00 00 00    	jne    80242c <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802381:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802388:	00 00 
  80238a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80238e:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802390:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802394:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80239b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80239f:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8023a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023a5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8023ac:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023b0:	48 bb 04 15 80 00 00 	movabs $0x801504,%rbx
  8023b7:	00 00 00 
  8023ba:	ff d3                	call   *%rbx
  8023bc:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8023c0:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8023c4:	ff d3                	call   *%rbx
  8023c6:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8023cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023d0:	eb 4d                	jmp    80241f <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8023d2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023d7:	4c 89 ee             	mov    %r13,%rsi
  8023da:	bf 00 00 00 00       	mov    $0x0,%edi
  8023df:	48 b8 80 12 80 00 00 	movabs $0x801280,%rax
  8023e6:	00 00 00 
  8023e9:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8023eb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023f0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f9:	48 b8 80 12 80 00 00 	movabs $0x801280,%rax
  802400:	00 00 00 
  802403:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802405:	ba 00 10 00 00       	mov    $0x1000,%edx
  80240a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80240e:	bf 00 00 00 00       	mov    $0x0,%edi
  802413:	48 b8 80 12 80 00 00 	movabs $0x801280,%rax
  80241a:	00 00 00 
  80241d:	ff d0                	call   *%rax
}
  80241f:	89 d8                	mov    %ebx,%eax
  802421:	48 83 c4 18          	add    $0x18,%rsp
  802425:	5b                   	pop    %rbx
  802426:	41 5c                	pop    %r12
  802428:	41 5d                	pop    %r13
  80242a:	5d                   	pop    %rbp
  80242b:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80242c:	48 b9 68 36 80 00 00 	movabs $0x803668,%rcx
  802433:	00 00 00 
  802436:	48 ba 0e 32 80 00 00 	movabs $0x80320e,%rdx
  80243d:	00 00 00 
  802440:	be 2e 00 00 00       	mov    $0x2e,%esi
  802445:	48 bf 35 32 80 00 00 	movabs $0x803235,%rdi
  80244c:	00 00 00 
  80244f:	b8 00 00 00 00       	mov    $0x0,%eax
  802454:	49 b8 6b 2a 80 00 00 	movabs $0x802a6b,%r8
  80245b:	00 00 00 
  80245e:	41 ff d0             	call   *%r8

0000000000802461 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802461:	f3 0f 1e fa          	endbr64
  802465:	55                   	push   %rbp
  802466:	48 89 e5             	mov    %rsp,%rbp
  802469:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80246d:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802471:	48 b8 9e 15 80 00 00 	movabs $0x80159e,%rax
  802478:	00 00 00 
  80247b:	ff d0                	call   *%rax
    if (res < 0) return res;
  80247d:	85 c0                	test   %eax,%eax
  80247f:	78 35                	js     8024b6 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802481:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802485:	48 b8 1a 15 80 00 00 	movabs $0x80151a,%rax
  80248c:	00 00 00 
  80248f:	ff d0                	call   *%rax
  802491:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802494:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802499:	be 00 10 00 00       	mov    $0x1000,%esi
  80249e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8024a2:	48 b8 10 11 80 00 00 	movabs $0x801110,%rax
  8024a9:	00 00 00 
  8024ac:	ff d0                	call   *%rax
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	0f 94 c0             	sete   %al
  8024b3:	0f b6 c0             	movzbl %al,%eax
}
  8024b6:	c9                   	leave
  8024b7:	c3                   	ret

00000000008024b8 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8024b8:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8024bc:	48 89 f8             	mov    %rdi,%rax
  8024bf:	48 c1 e8 27          	shr    $0x27,%rax
  8024c3:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8024ca:	7f 00 00 
  8024cd:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024d1:	f6 c2 01             	test   $0x1,%dl
  8024d4:	74 6d                	je     802543 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8024d6:	48 89 f8             	mov    %rdi,%rax
  8024d9:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024dd:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8024e4:	7f 00 00 
  8024e7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024eb:	f6 c2 01             	test   $0x1,%dl
  8024ee:	74 62                	je     802552 <get_uvpt_entry+0x9a>
  8024f0:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8024f7:	7f 00 00 
  8024fa:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024fe:	f6 c2 80             	test   $0x80,%dl
  802501:	75 4f                	jne    802552 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802503:	48 89 f8             	mov    %rdi,%rax
  802506:	48 c1 e8 15          	shr    $0x15,%rax
  80250a:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802511:	7f 00 00 
  802514:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802518:	f6 c2 01             	test   $0x1,%dl
  80251b:	74 44                	je     802561 <get_uvpt_entry+0xa9>
  80251d:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802524:	7f 00 00 
  802527:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80252b:	f6 c2 80             	test   $0x80,%dl
  80252e:	75 31                	jne    802561 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802530:	48 c1 ef 0c          	shr    $0xc,%rdi
  802534:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80253b:	7f 00 00 
  80253e:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802542:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802543:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80254a:	7f 00 00 
  80254d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802551:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802552:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802559:	7f 00 00 
  80255c:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802560:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802561:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802568:	7f 00 00 
  80256b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80256f:	c3                   	ret

0000000000802570 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802570:	f3 0f 1e fa          	endbr64
  802574:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802577:	48 89 f9             	mov    %rdi,%rcx
  80257a:	48 c1 e9 27          	shr    $0x27,%rcx
  80257e:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802585:	7f 00 00 
  802588:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  80258c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802593:	f6 c1 01             	test   $0x1,%cl
  802596:	0f 84 b2 00 00 00    	je     80264e <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80259c:	48 89 f9             	mov    %rdi,%rcx
  80259f:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8025a3:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8025aa:	7f 00 00 
  8025ad:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8025b1:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8025b8:	40 f6 c6 01          	test   $0x1,%sil
  8025bc:	0f 84 8c 00 00 00    	je     80264e <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8025c2:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8025c9:	7f 00 00 
  8025cc:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8025d0:	a8 80                	test   $0x80,%al
  8025d2:	75 7b                	jne    80264f <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8025d4:	48 89 f9             	mov    %rdi,%rcx
  8025d7:	48 c1 e9 15          	shr    $0x15,%rcx
  8025db:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8025e2:	7f 00 00 
  8025e5:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8025e9:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  8025f0:	40 f6 c6 01          	test   $0x1,%sil
  8025f4:	74 58                	je     80264e <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  8025f6:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8025fd:	7f 00 00 
  802600:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802604:	a8 80                	test   $0x80,%al
  802606:	75 6c                	jne    802674 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802608:	48 89 f9             	mov    %rdi,%rcx
  80260b:	48 c1 e9 0c          	shr    $0xc,%rcx
  80260f:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802616:	7f 00 00 
  802619:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80261d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802624:	40 f6 c6 01          	test   $0x1,%sil
  802628:	74 24                	je     80264e <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  80262a:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802631:	7f 00 00 
  802634:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802638:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80263f:	ff ff 7f 
  802642:	48 21 c8             	and    %rcx,%rax
  802645:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80264b:	48 09 d0             	or     %rdx,%rax
}
  80264e:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  80264f:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802656:	7f 00 00 
  802659:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80265d:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802664:	ff ff 7f 
  802667:	48 21 c8             	and    %rcx,%rax
  80266a:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802670:	48 01 d0             	add    %rdx,%rax
  802673:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802674:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80267b:	7f 00 00 
  80267e:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802682:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802689:	ff ff 7f 
  80268c:	48 21 c8             	and    %rcx,%rax
  80268f:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802695:	48 01 d0             	add    %rdx,%rax
  802698:	c3                   	ret

0000000000802699 <get_prot>:

int
get_prot(void *va) {
  802699:	f3 0f 1e fa          	endbr64
  80269d:	55                   	push   %rbp
  80269e:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8026a1:	48 b8 b8 24 80 00 00 	movabs $0x8024b8,%rax
  8026a8:	00 00 00 
  8026ab:	ff d0                	call   *%rax
  8026ad:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8026b0:	83 e0 01             	and    $0x1,%eax
  8026b3:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8026b6:	89 d1                	mov    %edx,%ecx
  8026b8:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8026be:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8026c0:	89 c1                	mov    %eax,%ecx
  8026c2:	83 c9 02             	or     $0x2,%ecx
  8026c5:	f6 c2 02             	test   $0x2,%dl
  8026c8:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8026cb:	89 c1                	mov    %eax,%ecx
  8026cd:	83 c9 01             	or     $0x1,%ecx
  8026d0:	48 85 d2             	test   %rdx,%rdx
  8026d3:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8026d6:	89 c1                	mov    %eax,%ecx
  8026d8:	83 c9 40             	or     $0x40,%ecx
  8026db:	f6 c6 04             	test   $0x4,%dh
  8026de:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8026e1:	5d                   	pop    %rbp
  8026e2:	c3                   	ret

00000000008026e3 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8026e3:	f3 0f 1e fa          	endbr64
  8026e7:	55                   	push   %rbp
  8026e8:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8026eb:	48 b8 b8 24 80 00 00 	movabs $0x8024b8,%rax
  8026f2:	00 00 00 
  8026f5:	ff d0                	call   *%rax
    return pte & PTE_D;
  8026f7:	48 c1 e8 06          	shr    $0x6,%rax
  8026fb:	83 e0 01             	and    $0x1,%eax
}
  8026fe:	5d                   	pop    %rbp
  8026ff:	c3                   	ret

0000000000802700 <is_page_present>:

bool
is_page_present(void *va) {
  802700:	f3 0f 1e fa          	endbr64
  802704:	55                   	push   %rbp
  802705:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802708:	48 b8 b8 24 80 00 00 	movabs $0x8024b8,%rax
  80270f:	00 00 00 
  802712:	ff d0                	call   *%rax
  802714:	83 e0 01             	and    $0x1,%eax
}
  802717:	5d                   	pop    %rbp
  802718:	c3                   	ret

0000000000802719 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802719:	f3 0f 1e fa          	endbr64
  80271d:	55                   	push   %rbp
  80271e:	48 89 e5             	mov    %rsp,%rbp
  802721:	41 57                	push   %r15
  802723:	41 56                	push   %r14
  802725:	41 55                	push   %r13
  802727:	41 54                	push   %r12
  802729:	53                   	push   %rbx
  80272a:	48 83 ec 18          	sub    $0x18,%rsp
  80272e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802732:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802736:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  80273b:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802742:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802745:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  80274c:	7f 00 00 
    while (va < USER_STACK_TOP) {
  80274f:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802756:	00 00 00 
  802759:	eb 73                	jmp    8027ce <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  80275b:	48 89 d8             	mov    %rbx,%rax
  80275e:	48 c1 e8 15          	shr    $0x15,%rax
  802762:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802769:	7f 00 00 
  80276c:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802770:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802776:	f6 c2 01             	test   $0x1,%dl
  802779:	74 4b                	je     8027c6 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  80277b:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  80277f:	f6 c2 80             	test   $0x80,%dl
  802782:	74 11                	je     802795 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802784:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802788:	f6 c4 04             	test   $0x4,%ah
  80278b:	74 39                	je     8027c6 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  80278d:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802793:	eb 20                	jmp    8027b5 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802795:	48 89 da             	mov    %rbx,%rdx
  802798:	48 c1 ea 0c          	shr    $0xc,%rdx
  80279c:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8027a3:	7f 00 00 
  8027a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  8027aa:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8027b0:	f6 c4 04             	test   $0x4,%ah
  8027b3:	74 11                	je     8027c6 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  8027b5:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  8027b9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8027bd:	48 89 df             	mov    %rbx,%rdi
  8027c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8027c4:	ff d0                	call   *%rax
    next:
        va += size;
  8027c6:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  8027c9:	49 39 df             	cmp    %rbx,%r15
  8027cc:	72 3e                	jb     80280c <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8027ce:	49 8b 06             	mov    (%r14),%rax
  8027d1:	a8 01                	test   $0x1,%al
  8027d3:	74 37                	je     80280c <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8027d5:	48 89 d8             	mov    %rbx,%rax
  8027d8:	48 c1 e8 1e          	shr    $0x1e,%rax
  8027dc:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  8027e1:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8027e7:	f6 c2 01             	test   $0x1,%dl
  8027ea:	74 da                	je     8027c6 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  8027ec:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  8027f1:	f6 c2 80             	test   $0x80,%dl
  8027f4:	0f 84 61 ff ff ff    	je     80275b <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  8027fa:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8027ff:	f6 c4 04             	test   $0x4,%ah
  802802:	74 c2                	je     8027c6 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802804:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  80280a:	eb a9                	jmp    8027b5 <foreach_shared_region+0x9c>
    }
    return res;
}
  80280c:	b8 00 00 00 00       	mov    $0x0,%eax
  802811:	48 83 c4 18          	add    $0x18,%rsp
  802815:	5b                   	pop    %rbx
  802816:	41 5c                	pop    %r12
  802818:	41 5d                	pop    %r13
  80281a:	41 5e                	pop    %r14
  80281c:	41 5f                	pop    %r15
  80281e:	5d                   	pop    %rbp
  80281f:	c3                   	ret

0000000000802820 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802820:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802824:	b8 00 00 00 00       	mov    $0x0,%eax
  802829:	c3                   	ret

000000000080282a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80282a:	f3 0f 1e fa          	endbr64
  80282e:	55                   	push   %rbp
  80282f:	48 89 e5             	mov    %rsp,%rbp
  802832:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802835:	48 be 45 32 80 00 00 	movabs $0x803245,%rsi
  80283c:	00 00 00 
  80283f:	48 b8 3b 0b 80 00 00 	movabs $0x800b3b,%rax
  802846:	00 00 00 
  802849:	ff d0                	call   *%rax
    return 0;
}
  80284b:	b8 00 00 00 00       	mov    $0x0,%eax
  802850:	5d                   	pop    %rbp
  802851:	c3                   	ret

0000000000802852 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802852:	f3 0f 1e fa          	endbr64
  802856:	55                   	push   %rbp
  802857:	48 89 e5             	mov    %rsp,%rbp
  80285a:	41 57                	push   %r15
  80285c:	41 56                	push   %r14
  80285e:	41 55                	push   %r13
  802860:	41 54                	push   %r12
  802862:	53                   	push   %rbx
  802863:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80286a:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802871:	48 85 d2             	test   %rdx,%rdx
  802874:	74 7a                	je     8028f0 <devcons_write+0x9e>
  802876:	49 89 d6             	mov    %rdx,%r14
  802879:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80287f:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802884:	49 bf 56 0d 80 00 00 	movabs $0x800d56,%r15
  80288b:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  80288e:	4c 89 f3             	mov    %r14,%rbx
  802891:	48 29 f3             	sub    %rsi,%rbx
  802894:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802899:	48 39 c3             	cmp    %rax,%rbx
  80289c:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8028a0:	4c 63 eb             	movslq %ebx,%r13
  8028a3:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8028aa:	48 01 c6             	add    %rax,%rsi
  8028ad:	4c 89 ea             	mov    %r13,%rdx
  8028b0:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8028b7:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8028ba:	4c 89 ee             	mov    %r13,%rsi
  8028bd:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8028c4:	48 b8 9b 0f 80 00 00 	movabs $0x800f9b,%rax
  8028cb:	00 00 00 
  8028ce:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8028d0:	41 01 dc             	add    %ebx,%r12d
  8028d3:	49 63 f4             	movslq %r12d,%rsi
  8028d6:	4c 39 f6             	cmp    %r14,%rsi
  8028d9:	72 b3                	jb     80288e <devcons_write+0x3c>
    return res;
  8028db:	49 63 c4             	movslq %r12d,%rax
}
  8028de:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8028e5:	5b                   	pop    %rbx
  8028e6:	41 5c                	pop    %r12
  8028e8:	41 5d                	pop    %r13
  8028ea:	41 5e                	pop    %r14
  8028ec:	41 5f                	pop    %r15
  8028ee:	5d                   	pop    %rbp
  8028ef:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  8028f0:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8028f6:	eb e3                	jmp    8028db <devcons_write+0x89>

00000000008028f8 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8028f8:	f3 0f 1e fa          	endbr64
  8028fc:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8028ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802904:	48 85 c0             	test   %rax,%rax
  802907:	74 55                	je     80295e <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802909:	55                   	push   %rbp
  80290a:	48 89 e5             	mov    %rsp,%rbp
  80290d:	41 55                	push   %r13
  80290f:	41 54                	push   %r12
  802911:	53                   	push   %rbx
  802912:	48 83 ec 08          	sub    $0x8,%rsp
  802916:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802919:	48 bb cc 0f 80 00 00 	movabs $0x800fcc,%rbx
  802920:	00 00 00 
  802923:	49 bc a5 10 80 00 00 	movabs $0x8010a5,%r12
  80292a:	00 00 00 
  80292d:	eb 03                	jmp    802932 <devcons_read+0x3a>
  80292f:	41 ff d4             	call   *%r12
  802932:	ff d3                	call   *%rbx
  802934:	85 c0                	test   %eax,%eax
  802936:	74 f7                	je     80292f <devcons_read+0x37>
    if (c < 0) return c;
  802938:	48 63 d0             	movslq %eax,%rdx
  80293b:	78 13                	js     802950 <devcons_read+0x58>
    if (c == 0x04) return 0;
  80293d:	ba 00 00 00 00       	mov    $0x0,%edx
  802942:	83 f8 04             	cmp    $0x4,%eax
  802945:	74 09                	je     802950 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802947:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80294b:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802950:	48 89 d0             	mov    %rdx,%rax
  802953:	48 83 c4 08          	add    $0x8,%rsp
  802957:	5b                   	pop    %rbx
  802958:	41 5c                	pop    %r12
  80295a:	41 5d                	pop    %r13
  80295c:	5d                   	pop    %rbp
  80295d:	c3                   	ret
  80295e:	48 89 d0             	mov    %rdx,%rax
  802961:	c3                   	ret

0000000000802962 <cputchar>:
cputchar(int ch) {
  802962:	f3 0f 1e fa          	endbr64
  802966:	55                   	push   %rbp
  802967:	48 89 e5             	mov    %rsp,%rbp
  80296a:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  80296e:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802972:	be 01 00 00 00       	mov    $0x1,%esi
  802977:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80297b:	48 b8 9b 0f 80 00 00 	movabs $0x800f9b,%rax
  802982:	00 00 00 
  802985:	ff d0                	call   *%rax
}
  802987:	c9                   	leave
  802988:	c3                   	ret

0000000000802989 <getchar>:
getchar(void) {
  802989:	f3 0f 1e fa          	endbr64
  80298d:	55                   	push   %rbp
  80298e:	48 89 e5             	mov    %rsp,%rbp
  802991:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802995:	ba 01 00 00 00       	mov    $0x1,%edx
  80299a:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  80299e:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a3:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  8029aa:	00 00 00 
  8029ad:	ff d0                	call   *%rax
  8029af:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8029b1:	85 c0                	test   %eax,%eax
  8029b3:	78 06                	js     8029bb <getchar+0x32>
  8029b5:	74 08                	je     8029bf <getchar+0x36>
  8029b7:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8029bb:	89 d0                	mov    %edx,%eax
  8029bd:	c9                   	leave
  8029be:	c3                   	ret
    return res < 0 ? res : res ? c :
  8029bf:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8029c4:	eb f5                	jmp    8029bb <getchar+0x32>

00000000008029c6 <iscons>:
iscons(int fdnum) {
  8029c6:	f3 0f 1e fa          	endbr64
  8029ca:	55                   	push   %rbp
  8029cb:	48 89 e5             	mov    %rsp,%rbp
  8029ce:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8029d2:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8029d6:	48 b8 9e 15 80 00 00 	movabs $0x80159e,%rax
  8029dd:	00 00 00 
  8029e0:	ff d0                	call   *%rax
    if (res < 0) return res;
  8029e2:	85 c0                	test   %eax,%eax
  8029e4:	78 18                	js     8029fe <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  8029e6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029ea:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8029f1:	00 00 00 
  8029f4:	8b 00                	mov    (%rax),%eax
  8029f6:	39 02                	cmp    %eax,(%rdx)
  8029f8:	0f 94 c0             	sete   %al
  8029fb:	0f b6 c0             	movzbl %al,%eax
}
  8029fe:	c9                   	leave
  8029ff:	c3                   	ret

0000000000802a00 <opencons>:
opencons(void) {
  802a00:	f3 0f 1e fa          	endbr64
  802a04:	55                   	push   %rbp
  802a05:	48 89 e5             	mov    %rsp,%rbp
  802a08:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802a0c:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802a10:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  802a17:	00 00 00 
  802a1a:	ff d0                	call   *%rax
  802a1c:	85 c0                	test   %eax,%eax
  802a1e:	78 49                	js     802a69 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802a20:	b9 46 00 00 00       	mov    $0x46,%ecx
  802a25:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a2a:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802a2e:	bf 00 00 00 00       	mov    $0x0,%edi
  802a33:	48 b8 40 11 80 00 00 	movabs $0x801140,%rax
  802a3a:	00 00 00 
  802a3d:	ff d0                	call   *%rax
  802a3f:	85 c0                	test   %eax,%eax
  802a41:	78 26                	js     802a69 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802a43:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a47:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802a4e:	00 00 
  802a50:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802a52:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802a56:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802a5d:	48 b8 04 15 80 00 00 	movabs $0x801504,%rax
  802a64:	00 00 00 
  802a67:	ff d0                	call   *%rax
}
  802a69:	c9                   	leave
  802a6a:	c3                   	ret

0000000000802a6b <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802a6b:	f3 0f 1e fa          	endbr64
  802a6f:	55                   	push   %rbp
  802a70:	48 89 e5             	mov    %rsp,%rbp
  802a73:	41 56                	push   %r14
  802a75:	41 55                	push   %r13
  802a77:	41 54                	push   %r12
  802a79:	53                   	push   %rbx
  802a7a:	48 83 ec 50          	sub    $0x50,%rsp
  802a7e:	49 89 fc             	mov    %rdi,%r12
  802a81:	41 89 f5             	mov    %esi,%r13d
  802a84:	48 89 d3             	mov    %rdx,%rbx
  802a87:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802a8b:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802a8f:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802a93:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802a9a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a9e:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802aa2:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802aa6:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802aaa:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802ab1:	00 00 00 
  802ab4:	4c 8b 30             	mov    (%rax),%r14
  802ab7:	48 b8 70 10 80 00 00 	movabs $0x801070,%rax
  802abe:	00 00 00 
  802ac1:	ff d0                	call   *%rax
  802ac3:	89 c6                	mov    %eax,%esi
  802ac5:	45 89 e8             	mov    %r13d,%r8d
  802ac8:	4c 89 e1             	mov    %r12,%rcx
  802acb:	4c 89 f2             	mov    %r14,%rdx
  802ace:	48 bf 90 36 80 00 00 	movabs $0x803690,%rdi
  802ad5:	00 00 00 
  802ad8:	b8 00 00 00 00       	mov    $0x0,%eax
  802add:	49 bc f2 01 80 00 00 	movabs $0x8001f2,%r12
  802ae4:	00 00 00 
  802ae7:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802aea:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802aee:	48 89 df             	mov    %rbx,%rdi
  802af1:	48 b8 8a 01 80 00 00 	movabs $0x80018a,%rax
  802af8:	00 00 00 
  802afb:	ff d0                	call   *%rax
    cprintf("\n");
  802afd:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  802b04:	00 00 00 
  802b07:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0c:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802b0f:	cc                   	int3
  802b10:	eb fd                	jmp    802b0f <_panic+0xa4>

0000000000802b12 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802b12:	f3 0f 1e fa          	endbr64
  802b16:	55                   	push   %rbp
  802b17:	48 89 e5             	mov    %rsp,%rbp
  802b1a:	41 54                	push   %r12
  802b1c:	53                   	push   %rbx
  802b1d:	48 89 fb             	mov    %rdi,%rbx
  802b20:	48 89 f7             	mov    %rsi,%rdi
  802b23:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b26:	48 85 f6             	test   %rsi,%rsi
  802b29:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b30:	00 00 00 
  802b33:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b37:	be 00 10 00 00       	mov    $0x1000,%esi
  802b3c:	48 b8 62 14 80 00 00 	movabs $0x801462,%rax
  802b43:	00 00 00 
  802b46:	ff d0                	call   *%rax
    if (res < 0) {
  802b48:	85 c0                	test   %eax,%eax
  802b4a:	78 45                	js     802b91 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b4c:	48 85 db             	test   %rbx,%rbx
  802b4f:	74 12                	je     802b63 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b51:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  802b58:	00 00 00 
  802b5b:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b61:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b63:	4d 85 e4             	test   %r12,%r12
  802b66:	74 14                	je     802b7c <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b68:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  802b6f:	00 00 00 
  802b72:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b78:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802b7c:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  802b83:	00 00 00 
  802b86:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802b8c:	5b                   	pop    %rbx
  802b8d:	41 5c                	pop    %r12
  802b8f:	5d                   	pop    %rbp
  802b90:	c3                   	ret
        if (from_env_store != NULL) {
  802b91:	48 85 db             	test   %rbx,%rbx
  802b94:	74 06                	je     802b9c <ipc_recv+0x8a>
            *from_env_store = 0;
  802b96:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802b9c:	4d 85 e4             	test   %r12,%r12
  802b9f:	74 eb                	je     802b8c <ipc_recv+0x7a>
            *perm_store = 0;
  802ba1:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802ba8:	00 
  802ba9:	eb e1                	jmp    802b8c <ipc_recv+0x7a>

0000000000802bab <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802bab:	f3 0f 1e fa          	endbr64
  802baf:	55                   	push   %rbp
  802bb0:	48 89 e5             	mov    %rsp,%rbp
  802bb3:	41 57                	push   %r15
  802bb5:	41 56                	push   %r14
  802bb7:	41 55                	push   %r13
  802bb9:	41 54                	push   %r12
  802bbb:	53                   	push   %rbx
  802bbc:	48 83 ec 18          	sub    $0x18,%rsp
  802bc0:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802bc3:	48 89 d3             	mov    %rdx,%rbx
  802bc6:	49 89 cc             	mov    %rcx,%r12
  802bc9:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802bcc:	48 85 d2             	test   %rdx,%rdx
  802bcf:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bd6:	00 00 00 
  802bd9:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802bdd:	89 f0                	mov    %esi,%eax
  802bdf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802be3:	48 89 da             	mov    %rbx,%rdx
  802be6:	48 89 c6             	mov    %rax,%rsi
  802be9:	48 b8 32 14 80 00 00 	movabs $0x801432,%rax
  802bf0:	00 00 00 
  802bf3:	ff d0                	call   *%rax
    while (res < 0) {
  802bf5:	85 c0                	test   %eax,%eax
  802bf7:	79 65                	jns    802c5e <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bf9:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bfc:	75 33                	jne    802c31 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802bfe:	49 bf a5 10 80 00 00 	movabs $0x8010a5,%r15
  802c05:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c08:	49 be 32 14 80 00 00 	movabs $0x801432,%r14
  802c0f:	00 00 00 
        sys_yield();
  802c12:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c15:	45 89 e8             	mov    %r13d,%r8d
  802c18:	4c 89 e1             	mov    %r12,%rcx
  802c1b:	48 89 da             	mov    %rbx,%rdx
  802c1e:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802c22:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802c25:	41 ff d6             	call   *%r14
    while (res < 0) {
  802c28:	85 c0                	test   %eax,%eax
  802c2a:	79 32                	jns    802c5e <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c2c:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c2f:	74 e1                	je     802c12 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c31:	89 c1                	mov    %eax,%ecx
  802c33:	48 ba 51 32 80 00 00 	movabs $0x803251,%rdx
  802c3a:	00 00 00 
  802c3d:	be 42 00 00 00       	mov    $0x42,%esi
  802c42:	48 bf 5c 32 80 00 00 	movabs $0x80325c,%rdi
  802c49:	00 00 00 
  802c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c51:	49 b8 6b 2a 80 00 00 	movabs $0x802a6b,%r8
  802c58:	00 00 00 
  802c5b:	41 ff d0             	call   *%r8
    }
}
  802c5e:	48 83 c4 18          	add    $0x18,%rsp
  802c62:	5b                   	pop    %rbx
  802c63:	41 5c                	pop    %r12
  802c65:	41 5d                	pop    %r13
  802c67:	41 5e                	pop    %r14
  802c69:	41 5f                	pop    %r15
  802c6b:	5d                   	pop    %rbp
  802c6c:	c3                   	ret

0000000000802c6d <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c6d:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c71:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c76:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802c7d:	00 00 00 
  802c80:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c84:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c88:	48 c1 e2 04          	shl    $0x4,%rdx
  802c8c:	48 01 ca             	add    %rcx,%rdx
  802c8f:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c95:	39 fa                	cmp    %edi,%edx
  802c97:	74 12                	je     802cab <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802c99:	48 83 c0 01          	add    $0x1,%rax
  802c9d:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802ca3:	75 db                	jne    802c80 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802ca5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802caa:	c3                   	ret
            return envs[i].env_id;
  802cab:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802caf:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802cb3:	48 c1 e2 04          	shl    $0x4,%rdx
  802cb7:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802cbe:	00 00 00 
  802cc1:	48 01 d0             	add    %rdx,%rax
  802cc4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cca:	c3                   	ret

0000000000802ccb <__text_end>:
  802ccb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cd2:	00 00 00 
  802cd5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cdc:	00 00 00 
  802cdf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ce6:	00 00 00 
  802ce9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cf0:	00 00 00 
  802cf3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cfa:	00 00 00 
  802cfd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d04:	00 00 00 
  802d07:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d0e:	00 00 00 
  802d11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d18:	00 00 00 
  802d1b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d22:	00 00 00 
  802d25:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d2c:	00 00 00 
  802d2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d36:	00 00 00 
  802d39:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d40:	00 00 00 
  802d43:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d4a:	00 00 00 
  802d4d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d54:	00 00 00 
  802d57:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d5e:	00 00 00 
  802d61:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d68:	00 00 00 
  802d6b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d72:	00 00 00 
  802d75:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d7c:	00 00 00 
  802d7f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d86:	00 00 00 
  802d89:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d90:	00 00 00 
  802d93:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d9a:	00 00 00 
  802d9d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802da4:	00 00 00 
  802da7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dae:	00 00 00 
  802db1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802db8:	00 00 00 
  802dbb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dc2:	00 00 00 
  802dc5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dcc:	00 00 00 
  802dcf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd6:	00 00 00 
  802dd9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de0:	00 00 00 
  802de3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dea:	00 00 00 
  802ded:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df4:	00 00 00 
  802df7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dfe:	00 00 00 
  802e01:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e08:	00 00 00 
  802e0b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e12:	00 00 00 
  802e15:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e1c:	00 00 00 
  802e1f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e26:	00 00 00 
  802e29:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e30:	00 00 00 
  802e33:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e3a:	00 00 00 
  802e3d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e44:	00 00 00 
  802e47:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e4e:	00 00 00 
  802e51:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e58:	00 00 00 
  802e5b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e62:	00 00 00 
  802e65:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e6c:	00 00 00 
  802e6f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e76:	00 00 00 
  802e79:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e80:	00 00 00 
  802e83:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e8a:	00 00 00 
  802e8d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e94:	00 00 00 
  802e97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e9e:	00 00 00 
  802ea1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea8:	00 00 00 
  802eab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb2:	00 00 00 
  802eb5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ebc:	00 00 00 
  802ebf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec6:	00 00 00 
  802ec9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed0:	00 00 00 
  802ed3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eda:	00 00 00 
  802edd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee4:	00 00 00 
  802ee7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eee:	00 00 00 
  802ef1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef8:	00 00 00 
  802efb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f02:	00 00 00 
  802f05:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f0c:	00 00 00 
  802f0f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f16:	00 00 00 
  802f19:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f20:	00 00 00 
  802f23:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f2a:	00 00 00 
  802f2d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f34:	00 00 00 
  802f37:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f3e:	00 00 00 
  802f41:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f48:	00 00 00 
  802f4b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f52:	00 00 00 
  802f55:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f5c:	00 00 00 
  802f5f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f66:	00 00 00 
  802f69:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f70:	00 00 00 
  802f73:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f7a:	00 00 00 
  802f7d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f84:	00 00 00 
  802f87:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f8e:	00 00 00 
  802f91:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f98:	00 00 00 
  802f9b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa2:	00 00 00 
  802fa5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fac:	00 00 00 
  802faf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb6:	00 00 00 
  802fb9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc0:	00 00 00 
  802fc3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fca:	00 00 00 
  802fcd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd4:	00 00 00 
  802fd7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fde:	00 00 00 
  802fe1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe8:	00 00 00 
  802feb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff2:	00 00 00 
  802ff5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ffc:	00 00 00 
  802fff:	90                   	nop
