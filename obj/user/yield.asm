
obj/user/yield:     file format elf64-x86-64


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
  80001e:	e8 ca 00 00 00       	call   8000ed <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* yield the processor to other environments */

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
  800036:	48 83 ec 08          	sub    $0x8,%rsp
    cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800041:	00 00 00 
  800044:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80004a:	48 bf 00 30 80 00 00 	movabs $0x803000,%rdi
  800051:	00 00 00 
  800054:	b8 00 00 00 00       	mov    $0x0,%eax
  800059:	48 ba 7b 02 80 00 00 	movabs $0x80027b,%rdx
  800060:	00 00 00 
  800063:	ff d2                	call   *%rdx
    for (int i = 0; i < 5; i++) {
  800065:	bb 00 00 00 00       	mov    $0x0,%ebx
        sys_yield();
  80006a:	49 bf 2e 11 80 00 00 	movabs $0x80112e,%r15
  800071:	00 00 00 
        cprintf("Back in environment %08x, iteration %d.\n",
                thisenv->env_id, i);
  800074:	49 be 00 50 80 00 00 	movabs $0x805000,%r14
  80007b:	00 00 00 
        cprintf("Back in environment %08x, iteration %d.\n",
  80007e:	49 bd 20 30 80 00 00 	movabs $0x803020,%r13
  800085:	00 00 00 
  800088:	49 bc 7b 02 80 00 00 	movabs $0x80027b,%r12
  80008f:	00 00 00 
        sys_yield();
  800092:	41 ff d7             	call   *%r15
                thisenv->env_id, i);
  800095:	49 8b 06             	mov    (%r14),%rax
  800098:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("Back in environment %08x, iteration %d.\n",
  80009e:	89 da                	mov    %ebx,%edx
  8000a0:	4c 89 ef             	mov    %r13,%rdi
  8000a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a8:	41 ff d4             	call   *%r12
    for (int i = 0; i < 5; i++) {
  8000ab:	83 c3 01             	add    $0x1,%ebx
  8000ae:	83 fb 05             	cmp    $0x5,%ebx
  8000b1:	75 df                	jne    800092 <umain+0x6d>
    }
    cprintf("All done in environment %08x.\n", thisenv->env_id);
  8000b3:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8000ba:	00 00 00 
  8000bd:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8000c3:	48 bf 50 30 80 00 00 	movabs $0x803050,%rdi
  8000ca:	00 00 00 
  8000cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d2:	48 ba 7b 02 80 00 00 	movabs $0x80027b,%rdx
  8000d9:	00 00 00 
  8000dc:	ff d2                	call   *%rdx
}
  8000de:	48 83 c4 08          	add    $0x8,%rsp
  8000e2:	5b                   	pop    %rbx
  8000e3:	41 5c                	pop    %r12
  8000e5:	41 5d                	pop    %r13
  8000e7:	41 5e                	pop    %r14
  8000e9:	41 5f                	pop    %r15
  8000eb:	5d                   	pop    %rbp
  8000ec:	c3                   	ret

00000000008000ed <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8000ed:	f3 0f 1e fa          	endbr64
  8000f1:	55                   	push   %rbp
  8000f2:	48 89 e5             	mov    %rsp,%rbp
  8000f5:	41 56                	push   %r14
  8000f7:	41 55                	push   %r13
  8000f9:	41 54                	push   %r12
  8000fb:	53                   	push   %rbx
  8000fc:	41 89 fd             	mov    %edi,%r13d
  8000ff:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800102:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800109:	00 00 00 
  80010c:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800113:	00 00 00 
  800116:	48 39 c2             	cmp    %rax,%rdx
  800119:	73 17                	jae    800132 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80011b:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80011e:	49 89 c4             	mov    %rax,%r12
  800121:	48 83 c3 08          	add    $0x8,%rbx
  800125:	b8 00 00 00 00       	mov    $0x0,%eax
  80012a:	ff 53 f8             	call   *-0x8(%rbx)
  80012d:	4c 39 e3             	cmp    %r12,%rbx
  800130:	72 ef                	jb     800121 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800132:	48 b8 f9 10 80 00 00 	movabs $0x8010f9,%rax
  800139:	00 00 00 
  80013c:	ff d0                	call   *%rax
  80013e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800143:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800147:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80014b:	48 c1 e0 04          	shl    $0x4,%rax
  80014f:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800156:	00 00 00 
  800159:	48 01 d0             	add    %rdx,%rax
  80015c:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800163:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800166:	45 85 ed             	test   %r13d,%r13d
  800169:	7e 0d                	jle    800178 <libmain+0x8b>
  80016b:	49 8b 06             	mov    (%r14),%rax
  80016e:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800175:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800178:	4c 89 f6             	mov    %r14,%rsi
  80017b:	44 89 ef             	mov    %r13d,%edi
  80017e:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800185:	00 00 00 
  800188:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80018a:	48 b8 9f 01 80 00 00 	movabs $0x80019f,%rax
  800191:	00 00 00 
  800194:	ff d0                	call   *%rax
#endif
}
  800196:	5b                   	pop    %rbx
  800197:	41 5c                	pop    %r12
  800199:	41 5d                	pop    %r13
  80019b:	41 5e                	pop    %r14
  80019d:	5d                   	pop    %rbp
  80019e:	c3                   	ret

000000000080019f <exit>:

#include <inc/lib.h>

void
exit(void) {
  80019f:	f3 0f 1e fa          	endbr64
  8001a3:	55                   	push   %rbp
  8001a4:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8001a7:	48 b8 cf 17 80 00 00 	movabs $0x8017cf,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8001b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8001b8:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  8001bf:	00 00 00 
  8001c2:	ff d0                	call   *%rax
}
  8001c4:	5d                   	pop    %rbp
  8001c5:	c3                   	ret

00000000008001c6 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8001c6:	f3 0f 1e fa          	endbr64
  8001ca:	55                   	push   %rbp
  8001cb:	48 89 e5             	mov    %rsp,%rbp
  8001ce:	53                   	push   %rbx
  8001cf:	48 83 ec 08          	sub    $0x8,%rsp
  8001d3:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8001d6:	8b 06                	mov    (%rsi),%eax
  8001d8:	8d 50 01             	lea    0x1(%rax),%edx
  8001db:	89 16                	mov    %edx,(%rsi)
  8001dd:	48 98                	cltq
  8001df:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8001e4:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8001ea:	74 0a                	je     8001f6 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8001ec:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8001f0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001f4:	c9                   	leave
  8001f5:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  8001f6:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8001fa:	be ff 00 00 00       	mov    $0xff,%esi
  8001ff:	48 b8 24 10 80 00 00 	movabs $0x801024,%rax
  800206:	00 00 00 
  800209:	ff d0                	call   *%rax
        state->offset = 0;
  80020b:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800211:	eb d9                	jmp    8001ec <putch+0x26>

0000000000800213 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800213:	f3 0f 1e fa          	endbr64
  800217:	55                   	push   %rbp
  800218:	48 89 e5             	mov    %rsp,%rbp
  80021b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800222:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800225:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80022c:	b9 21 00 00 00       	mov    $0x21,%ecx
  800231:	b8 00 00 00 00       	mov    $0x0,%eax
  800236:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800239:	48 89 f1             	mov    %rsi,%rcx
  80023c:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800243:	48 bf c6 01 80 00 00 	movabs $0x8001c6,%rdi
  80024a:	00 00 00 
  80024d:	48 b8 db 03 80 00 00 	movabs $0x8003db,%rax
  800254:	00 00 00 
  800257:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800259:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800260:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800267:	48 b8 24 10 80 00 00 	movabs $0x801024,%rax
  80026e:	00 00 00 
  800271:	ff d0                	call   *%rax

    return state.count;
}
  800273:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800279:	c9                   	leave
  80027a:	c3                   	ret

000000000080027b <cprintf>:

int
cprintf(const char *fmt, ...) {
  80027b:	f3 0f 1e fa          	endbr64
  80027f:	55                   	push   %rbp
  800280:	48 89 e5             	mov    %rsp,%rbp
  800283:	48 83 ec 50          	sub    $0x50,%rsp
  800287:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80028b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80028f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800293:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800297:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  80029b:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8002a2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002a6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002aa:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002ae:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8002b2:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8002b6:	48 b8 13 02 80 00 00 	movabs $0x800213,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8002c2:	c9                   	leave
  8002c3:	c3                   	ret

00000000008002c4 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8002c4:	f3 0f 1e fa          	endbr64
  8002c8:	55                   	push   %rbp
  8002c9:	48 89 e5             	mov    %rsp,%rbp
  8002cc:	41 57                	push   %r15
  8002ce:	41 56                	push   %r14
  8002d0:	41 55                	push   %r13
  8002d2:	41 54                	push   %r12
  8002d4:	53                   	push   %rbx
  8002d5:	48 83 ec 18          	sub    $0x18,%rsp
  8002d9:	49 89 fc             	mov    %rdi,%r12
  8002dc:	49 89 f5             	mov    %rsi,%r13
  8002df:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8002e3:	8b 45 10             	mov    0x10(%rbp),%eax
  8002e6:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8002e9:	41 89 cf             	mov    %ecx,%r15d
  8002ec:	4c 39 fa             	cmp    %r15,%rdx
  8002ef:	73 5b                	jae    80034c <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8002f1:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8002f5:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8002f9:	85 db                	test   %ebx,%ebx
  8002fb:	7e 0e                	jle    80030b <print_num+0x47>
            putch(padc, put_arg);
  8002fd:	4c 89 ee             	mov    %r13,%rsi
  800300:	44 89 f7             	mov    %r14d,%edi
  800303:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800306:	83 eb 01             	sub    $0x1,%ebx
  800309:	75 f2                	jne    8002fd <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  80030b:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80030f:	48 b9 5e 31 80 00 00 	movabs $0x80315e,%rcx
  800316:	00 00 00 
  800319:	48 b8 4d 31 80 00 00 	movabs $0x80314d,%rax
  800320:	00 00 00 
  800323:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800327:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80032b:	ba 00 00 00 00       	mov    $0x0,%edx
  800330:	49 f7 f7             	div    %r15
  800333:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800337:	4c 89 ee             	mov    %r13,%rsi
  80033a:	41 ff d4             	call   *%r12
}
  80033d:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800341:	5b                   	pop    %rbx
  800342:	41 5c                	pop    %r12
  800344:	41 5d                	pop    %r13
  800346:	41 5e                	pop    %r14
  800348:	41 5f                	pop    %r15
  80034a:	5d                   	pop    %rbp
  80034b:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  80034c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800350:	ba 00 00 00 00       	mov    $0x0,%edx
  800355:	49 f7 f7             	div    %r15
  800358:	48 83 ec 08          	sub    $0x8,%rsp
  80035c:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800360:	52                   	push   %rdx
  800361:	45 0f be c9          	movsbl %r9b,%r9d
  800365:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800369:	48 89 c2             	mov    %rax,%rdx
  80036c:	48 b8 c4 02 80 00 00 	movabs $0x8002c4,%rax
  800373:	00 00 00 
  800376:	ff d0                	call   *%rax
  800378:	48 83 c4 10          	add    $0x10,%rsp
  80037c:	eb 8d                	jmp    80030b <print_num+0x47>

000000000080037e <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  80037e:	f3 0f 1e fa          	endbr64
    state->count++;
  800382:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800386:	48 8b 06             	mov    (%rsi),%rax
  800389:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80038d:	73 0a                	jae    800399 <sprintputch+0x1b>
        *state->start++ = ch;
  80038f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800393:	48 89 16             	mov    %rdx,(%rsi)
  800396:	40 88 38             	mov    %dil,(%rax)
    }
}
  800399:	c3                   	ret

000000000080039a <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80039a:	f3 0f 1e fa          	endbr64
  80039e:	55                   	push   %rbp
  80039f:	48 89 e5             	mov    %rsp,%rbp
  8003a2:	48 83 ec 50          	sub    $0x50,%rsp
  8003a6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003aa:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8003ae:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8003b2:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8003b9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003bd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003c1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8003c5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8003c9:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8003cd:	48 b8 db 03 80 00 00 	movabs $0x8003db,%rax
  8003d4:	00 00 00 
  8003d7:	ff d0                	call   *%rax
}
  8003d9:	c9                   	leave
  8003da:	c3                   	ret

00000000008003db <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8003db:	f3 0f 1e fa          	endbr64
  8003df:	55                   	push   %rbp
  8003e0:	48 89 e5             	mov    %rsp,%rbp
  8003e3:	41 57                	push   %r15
  8003e5:	41 56                	push   %r14
  8003e7:	41 55                	push   %r13
  8003e9:	41 54                	push   %r12
  8003eb:	53                   	push   %rbx
  8003ec:	48 83 ec 38          	sub    $0x38,%rsp
  8003f0:	49 89 fe             	mov    %rdi,%r14
  8003f3:	49 89 f5             	mov    %rsi,%r13
  8003f6:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  8003f9:	48 8b 01             	mov    (%rcx),%rax
  8003fc:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800400:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800404:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800408:	48 8b 41 10          	mov    0x10(%rcx),%rax
  80040c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800410:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800414:	0f b6 3b             	movzbl (%rbx),%edi
  800417:	40 80 ff 25          	cmp    $0x25,%dil
  80041b:	74 18                	je     800435 <vprintfmt+0x5a>
            if (!ch) return;
  80041d:	40 84 ff             	test   %dil,%dil
  800420:	0f 84 b2 06 00 00    	je     800ad8 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800426:	40 0f b6 ff          	movzbl %dil,%edi
  80042a:	4c 89 ee             	mov    %r13,%rsi
  80042d:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800430:	4c 89 e3             	mov    %r12,%rbx
  800433:	eb db                	jmp    800410 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800435:	be 00 00 00 00       	mov    $0x0,%esi
  80043a:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  80043e:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800443:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800449:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800450:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800454:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800459:	41 0f b6 04 24       	movzbl (%r12),%eax
  80045e:	88 45 a0             	mov    %al,-0x60(%rbp)
  800461:	83 e8 23             	sub    $0x23,%eax
  800464:	3c 57                	cmp    $0x57,%al
  800466:	0f 87 52 06 00 00    	ja     800abe <vprintfmt+0x6e3>
  80046c:	0f b6 c0             	movzbl %al,%eax
  80046f:	48 b9 a0 33 80 00 00 	movabs $0x8033a0,%rcx
  800476:	00 00 00 
  800479:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  80047d:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800480:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  800484:	eb ce                	jmp    800454 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800486:	49 89 dc             	mov    %rbx,%r12
  800489:	be 01 00 00 00       	mov    $0x1,%esi
  80048e:	eb c4                	jmp    800454 <vprintfmt+0x79>
            padc = ch;
  800490:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800494:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800497:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80049a:	eb b8                	jmp    800454 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80049c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80049f:	83 f8 2f             	cmp    $0x2f,%eax
  8004a2:	77 24                	ja     8004c8 <vprintfmt+0xed>
  8004a4:	89 c1                	mov    %eax,%ecx
  8004a6:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8004aa:	83 c0 08             	add    $0x8,%eax
  8004ad:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004b0:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8004b3:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8004b6:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8004ba:	79 98                	jns    800454 <vprintfmt+0x79>
                width = precision;
  8004bc:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  8004c0:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8004c6:	eb 8c                	jmp    800454 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8004c8:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8004cc:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8004d0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004d4:	eb da                	jmp    8004b0 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  8004d6:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  8004db:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8004df:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  8004e5:	3c 39                	cmp    $0x39,%al
  8004e7:	77 1c                	ja     800505 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  8004e9:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  8004ed:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  8004f1:	0f b6 c0             	movzbl %al,%eax
  8004f4:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8004f9:	0f b6 03             	movzbl (%rbx),%eax
  8004fc:	3c 39                	cmp    $0x39,%al
  8004fe:	76 e9                	jbe    8004e9 <vprintfmt+0x10e>
        process_precision:
  800500:	49 89 dc             	mov    %rbx,%r12
  800503:	eb b1                	jmp    8004b6 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800505:	49 89 dc             	mov    %rbx,%r12
  800508:	eb ac                	jmp    8004b6 <vprintfmt+0xdb>
            width = MAX(0, width);
  80050a:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  80050d:	85 c9                	test   %ecx,%ecx
  80050f:	b8 00 00 00 00       	mov    $0x0,%eax
  800514:	0f 49 c1             	cmovns %ecx,%eax
  800517:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  80051a:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80051d:	e9 32 ff ff ff       	jmp    800454 <vprintfmt+0x79>
            lflag++;
  800522:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800525:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800528:	e9 27 ff ff ff       	jmp    800454 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  80052d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800530:	83 f8 2f             	cmp    $0x2f,%eax
  800533:	77 19                	ja     80054e <vprintfmt+0x173>
  800535:	89 c2                	mov    %eax,%edx
  800537:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80053b:	83 c0 08             	add    $0x8,%eax
  80053e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800541:	8b 3a                	mov    (%rdx),%edi
  800543:	4c 89 ee             	mov    %r13,%rsi
  800546:	41 ff d6             	call   *%r14
            break;
  800549:	e9 c2 fe ff ff       	jmp    800410 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  80054e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800552:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800556:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80055a:	eb e5                	jmp    800541 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  80055c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80055f:	83 f8 2f             	cmp    $0x2f,%eax
  800562:	77 5a                	ja     8005be <vprintfmt+0x1e3>
  800564:	89 c2                	mov    %eax,%edx
  800566:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80056a:	83 c0 08             	add    $0x8,%eax
  80056d:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800570:	8b 02                	mov    (%rdx),%eax
  800572:	89 c1                	mov    %eax,%ecx
  800574:	f7 d9                	neg    %ecx
  800576:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800579:	83 f9 13             	cmp    $0x13,%ecx
  80057c:	7f 4e                	jg     8005cc <vprintfmt+0x1f1>
  80057e:	48 63 c1             	movslq %ecx,%rax
  800581:	48 ba 60 36 80 00 00 	movabs $0x803660,%rdx
  800588:	00 00 00 
  80058b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80058f:	48 85 c0             	test   %rax,%rax
  800592:	74 38                	je     8005cc <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  800594:	48 89 c1             	mov    %rax,%rcx
  800597:	48 ba 52 33 80 00 00 	movabs $0x803352,%rdx
  80059e:	00 00 00 
  8005a1:	4c 89 ee             	mov    %r13,%rsi
  8005a4:	4c 89 f7             	mov    %r14,%rdi
  8005a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ac:	49 b8 9a 03 80 00 00 	movabs $0x80039a,%r8
  8005b3:	00 00 00 
  8005b6:	41 ff d0             	call   *%r8
  8005b9:	e9 52 fe ff ff       	jmp    800410 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8005be:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005c2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005c6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005ca:	eb a4                	jmp    800570 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8005cc:	48 ba 76 31 80 00 00 	movabs $0x803176,%rdx
  8005d3:	00 00 00 
  8005d6:	4c 89 ee             	mov    %r13,%rsi
  8005d9:	4c 89 f7             	mov    %r14,%rdi
  8005dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e1:	49 b8 9a 03 80 00 00 	movabs $0x80039a,%r8
  8005e8:	00 00 00 
  8005eb:	41 ff d0             	call   *%r8
  8005ee:	e9 1d fe ff ff       	jmp    800410 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8005f3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005f6:	83 f8 2f             	cmp    $0x2f,%eax
  8005f9:	77 6c                	ja     800667 <vprintfmt+0x28c>
  8005fb:	89 c2                	mov    %eax,%edx
  8005fd:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800601:	83 c0 08             	add    $0x8,%eax
  800604:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800607:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  80060a:	48 85 d2             	test   %rdx,%rdx
  80060d:	48 b8 6f 31 80 00 00 	movabs $0x80316f,%rax
  800614:	00 00 00 
  800617:	48 0f 45 c2          	cmovne %rdx,%rax
  80061b:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  80061f:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800623:	7e 06                	jle    80062b <vprintfmt+0x250>
  800625:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800629:	75 4a                	jne    800675 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80062b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80062f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800633:	0f b6 00             	movzbl (%rax),%eax
  800636:	84 c0                	test   %al,%al
  800638:	0f 85 9a 00 00 00    	jne    8006d8 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  80063e:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800641:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  800645:	85 c0                	test   %eax,%eax
  800647:	0f 8e c3 fd ff ff    	jle    800410 <vprintfmt+0x35>
  80064d:	4c 89 ee             	mov    %r13,%rsi
  800650:	bf 20 00 00 00       	mov    $0x20,%edi
  800655:	41 ff d6             	call   *%r14
  800658:	41 83 ec 01          	sub    $0x1,%r12d
  80065c:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800660:	75 eb                	jne    80064d <vprintfmt+0x272>
  800662:	e9 a9 fd ff ff       	jmp    800410 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800667:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80066b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80066f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800673:	eb 92                	jmp    800607 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800675:	49 63 f7             	movslq %r15d,%rsi
  800678:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80067c:	48 b8 9e 0b 80 00 00 	movabs $0x800b9e,%rax
  800683:	00 00 00 
  800686:	ff d0                	call   *%rax
  800688:	48 89 c2             	mov    %rax,%rdx
  80068b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80068e:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800690:	8d 70 ff             	lea    -0x1(%rax),%esi
  800693:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800696:	85 c0                	test   %eax,%eax
  800698:	7e 91                	jle    80062b <vprintfmt+0x250>
  80069a:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80069f:	4c 89 ee             	mov    %r13,%rsi
  8006a2:	44 89 e7             	mov    %r12d,%edi
  8006a5:	41 ff d6             	call   *%r14
  8006a8:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8006ac:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006af:	83 f8 ff             	cmp    $0xffffffff,%eax
  8006b2:	75 eb                	jne    80069f <vprintfmt+0x2c4>
  8006b4:	e9 72 ff ff ff       	jmp    80062b <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8006b9:	0f b6 f8             	movzbl %al,%edi
  8006bc:	4c 89 ee             	mov    %r13,%rsi
  8006bf:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8006c2:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8006c6:	49 83 c4 01          	add    $0x1,%r12
  8006ca:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  8006d0:	84 c0                	test   %al,%al
  8006d2:	0f 84 66 ff ff ff    	je     80063e <vprintfmt+0x263>
  8006d8:	45 85 ff             	test   %r15d,%r15d
  8006db:	78 0a                	js     8006e7 <vprintfmt+0x30c>
  8006dd:	41 83 ef 01          	sub    $0x1,%r15d
  8006e1:	0f 88 57 ff ff ff    	js     80063e <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8006e7:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8006eb:	74 cc                	je     8006b9 <vprintfmt+0x2de>
  8006ed:	8d 50 e0             	lea    -0x20(%rax),%edx
  8006f0:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8006f5:	80 fa 5e             	cmp    $0x5e,%dl
  8006f8:	77 c2                	ja     8006bc <vprintfmt+0x2e1>
  8006fa:	eb bd                	jmp    8006b9 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8006fc:	40 84 f6             	test   %sil,%sil
  8006ff:	75 26                	jne    800727 <vprintfmt+0x34c>
    switch (lflag) {
  800701:	85 d2                	test   %edx,%edx
  800703:	74 59                	je     80075e <vprintfmt+0x383>
  800705:	83 fa 01             	cmp    $0x1,%edx
  800708:	74 7b                	je     800785 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  80070a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80070d:	83 f8 2f             	cmp    $0x2f,%eax
  800710:	0f 87 96 00 00 00    	ja     8007ac <vprintfmt+0x3d1>
  800716:	89 c2                	mov    %eax,%edx
  800718:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80071c:	83 c0 08             	add    $0x8,%eax
  80071f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800722:	4c 8b 22             	mov    (%rdx),%r12
  800725:	eb 17                	jmp    80073e <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800727:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80072a:	83 f8 2f             	cmp    $0x2f,%eax
  80072d:	77 21                	ja     800750 <vprintfmt+0x375>
  80072f:	89 c2                	mov    %eax,%edx
  800731:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800735:	83 c0 08             	add    $0x8,%eax
  800738:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80073b:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  80073e:	4d 85 e4             	test   %r12,%r12
  800741:	78 7a                	js     8007bd <vprintfmt+0x3e2>
            num = i;
  800743:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800746:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80074b:	e9 50 02 00 00       	jmp    8009a0 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800750:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800754:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800758:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80075c:	eb dd                	jmp    80073b <vprintfmt+0x360>
        return va_arg(*ap, int);
  80075e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800761:	83 f8 2f             	cmp    $0x2f,%eax
  800764:	77 11                	ja     800777 <vprintfmt+0x39c>
  800766:	89 c2                	mov    %eax,%edx
  800768:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80076c:	83 c0 08             	add    $0x8,%eax
  80076f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800772:	4c 63 22             	movslq (%rdx),%r12
  800775:	eb c7                	jmp    80073e <vprintfmt+0x363>
  800777:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80077b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80077f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800783:	eb ed                	jmp    800772 <vprintfmt+0x397>
        return va_arg(*ap, long);
  800785:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800788:	83 f8 2f             	cmp    $0x2f,%eax
  80078b:	77 11                	ja     80079e <vprintfmt+0x3c3>
  80078d:	89 c2                	mov    %eax,%edx
  80078f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800793:	83 c0 08             	add    $0x8,%eax
  800796:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800799:	4c 8b 22             	mov    (%rdx),%r12
  80079c:	eb a0                	jmp    80073e <vprintfmt+0x363>
  80079e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007a2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007a6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007aa:	eb ed                	jmp    800799 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  8007ac:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007b0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007b4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007b8:	e9 65 ff ff ff       	jmp    800722 <vprintfmt+0x347>
                putch('-', put_arg);
  8007bd:	4c 89 ee             	mov    %r13,%rsi
  8007c0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8007c5:	41 ff d6             	call   *%r14
                i = -i;
  8007c8:	49 f7 dc             	neg    %r12
  8007cb:	e9 73 ff ff ff       	jmp    800743 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  8007d0:	40 84 f6             	test   %sil,%sil
  8007d3:	75 32                	jne    800807 <vprintfmt+0x42c>
    switch (lflag) {
  8007d5:	85 d2                	test   %edx,%edx
  8007d7:	74 5d                	je     800836 <vprintfmt+0x45b>
  8007d9:	83 fa 01             	cmp    $0x1,%edx
  8007dc:	0f 84 82 00 00 00    	je     800864 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8007e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e5:	83 f8 2f             	cmp    $0x2f,%eax
  8007e8:	0f 87 a5 00 00 00    	ja     800893 <vprintfmt+0x4b8>
  8007ee:	89 c2                	mov    %eax,%edx
  8007f0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007f4:	83 c0 08             	add    $0x8,%eax
  8007f7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007fa:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8007fd:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800802:	e9 99 01 00 00       	jmp    8009a0 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800807:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80080a:	83 f8 2f             	cmp    $0x2f,%eax
  80080d:	77 19                	ja     800828 <vprintfmt+0x44d>
  80080f:	89 c2                	mov    %eax,%edx
  800811:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800815:	83 c0 08             	add    $0x8,%eax
  800818:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80081b:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80081e:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800823:	e9 78 01 00 00       	jmp    8009a0 <vprintfmt+0x5c5>
  800828:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80082c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800830:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800834:	eb e5                	jmp    80081b <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800836:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800839:	83 f8 2f             	cmp    $0x2f,%eax
  80083c:	77 18                	ja     800856 <vprintfmt+0x47b>
  80083e:	89 c2                	mov    %eax,%edx
  800840:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800844:	83 c0 08             	add    $0x8,%eax
  800847:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80084a:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  80084c:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800851:	e9 4a 01 00 00       	jmp    8009a0 <vprintfmt+0x5c5>
  800856:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80085a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80085e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800862:	eb e6                	jmp    80084a <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800864:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800867:	83 f8 2f             	cmp    $0x2f,%eax
  80086a:	77 19                	ja     800885 <vprintfmt+0x4aa>
  80086c:	89 c2                	mov    %eax,%edx
  80086e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800872:	83 c0 08             	add    $0x8,%eax
  800875:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800878:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80087b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800880:	e9 1b 01 00 00       	jmp    8009a0 <vprintfmt+0x5c5>
  800885:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800889:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80088d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800891:	eb e5                	jmp    800878 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800893:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800897:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80089b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80089f:	e9 56 ff ff ff       	jmp    8007fa <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  8008a4:	40 84 f6             	test   %sil,%sil
  8008a7:	75 2e                	jne    8008d7 <vprintfmt+0x4fc>
    switch (lflag) {
  8008a9:	85 d2                	test   %edx,%edx
  8008ab:	74 59                	je     800906 <vprintfmt+0x52b>
  8008ad:	83 fa 01             	cmp    $0x1,%edx
  8008b0:	74 7f                	je     800931 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  8008b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b5:	83 f8 2f             	cmp    $0x2f,%eax
  8008b8:	0f 87 9f 00 00 00    	ja     80095d <vprintfmt+0x582>
  8008be:	89 c2                	mov    %eax,%edx
  8008c0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008c4:	83 c0 08             	add    $0x8,%eax
  8008c7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008ca:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8008cd:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8008d2:	e9 c9 00 00 00       	jmp    8009a0 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8008d7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008da:	83 f8 2f             	cmp    $0x2f,%eax
  8008dd:	77 19                	ja     8008f8 <vprintfmt+0x51d>
  8008df:	89 c2                	mov    %eax,%edx
  8008e1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008e5:	83 c0 08             	add    $0x8,%eax
  8008e8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008eb:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8008ee:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8008f3:	e9 a8 00 00 00       	jmp    8009a0 <vprintfmt+0x5c5>
  8008f8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008fc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800900:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800904:	eb e5                	jmp    8008eb <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800906:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800909:	83 f8 2f             	cmp    $0x2f,%eax
  80090c:	77 15                	ja     800923 <vprintfmt+0x548>
  80090e:	89 c2                	mov    %eax,%edx
  800910:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800914:	83 c0 08             	add    $0x8,%eax
  800917:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80091a:	8b 12                	mov    (%rdx),%edx
            base = 8;
  80091c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800921:	eb 7d                	jmp    8009a0 <vprintfmt+0x5c5>
  800923:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800927:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80092b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80092f:	eb e9                	jmp    80091a <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800931:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800934:	83 f8 2f             	cmp    $0x2f,%eax
  800937:	77 16                	ja     80094f <vprintfmt+0x574>
  800939:	89 c2                	mov    %eax,%edx
  80093b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80093f:	83 c0 08             	add    $0x8,%eax
  800942:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800945:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800948:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  80094d:	eb 51                	jmp    8009a0 <vprintfmt+0x5c5>
  80094f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800953:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800957:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80095b:	eb e8                	jmp    800945 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  80095d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800961:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800965:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800969:	e9 5c ff ff ff       	jmp    8008ca <vprintfmt+0x4ef>
            putch('0', put_arg);
  80096e:	4c 89 ee             	mov    %r13,%rsi
  800971:	bf 30 00 00 00       	mov    $0x30,%edi
  800976:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800979:	4c 89 ee             	mov    %r13,%rsi
  80097c:	bf 78 00 00 00       	mov    $0x78,%edi
  800981:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800984:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800987:	83 f8 2f             	cmp    $0x2f,%eax
  80098a:	77 47                	ja     8009d3 <vprintfmt+0x5f8>
  80098c:	89 c2                	mov    %eax,%edx
  80098e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800992:	83 c0 08             	add    $0x8,%eax
  800995:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800998:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80099b:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8009a0:	48 83 ec 08          	sub    $0x8,%rsp
  8009a4:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  8009a8:	0f 94 c0             	sete   %al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	50                   	push   %rax
  8009af:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  8009b4:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8009b8:	4c 89 ee             	mov    %r13,%rsi
  8009bb:	4c 89 f7             	mov    %r14,%rdi
  8009be:	48 b8 c4 02 80 00 00 	movabs $0x8002c4,%rax
  8009c5:	00 00 00 
  8009c8:	ff d0                	call   *%rax
            break;
  8009ca:	48 83 c4 10          	add    $0x10,%rsp
  8009ce:	e9 3d fa ff ff       	jmp    800410 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  8009d3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009d7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009db:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009df:	eb b7                	jmp    800998 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  8009e1:	40 84 f6             	test   %sil,%sil
  8009e4:	75 2b                	jne    800a11 <vprintfmt+0x636>
    switch (lflag) {
  8009e6:	85 d2                	test   %edx,%edx
  8009e8:	74 56                	je     800a40 <vprintfmt+0x665>
  8009ea:	83 fa 01             	cmp    $0x1,%edx
  8009ed:	74 7f                	je     800a6e <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  8009ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f2:	83 f8 2f             	cmp    $0x2f,%eax
  8009f5:	0f 87 a2 00 00 00    	ja     800a9d <vprintfmt+0x6c2>
  8009fb:	89 c2                	mov    %eax,%edx
  8009fd:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a01:	83 c0 08             	add    $0x8,%eax
  800a04:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a07:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a0a:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800a0f:	eb 8f                	jmp    8009a0 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a11:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a14:	83 f8 2f             	cmp    $0x2f,%eax
  800a17:	77 19                	ja     800a32 <vprintfmt+0x657>
  800a19:	89 c2                	mov    %eax,%edx
  800a1b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a1f:	83 c0 08             	add    $0x8,%eax
  800a22:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a25:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a28:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a2d:	e9 6e ff ff ff       	jmp    8009a0 <vprintfmt+0x5c5>
  800a32:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a36:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a3a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a3e:	eb e5                	jmp    800a25 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800a40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a43:	83 f8 2f             	cmp    $0x2f,%eax
  800a46:	77 18                	ja     800a60 <vprintfmt+0x685>
  800a48:	89 c2                	mov    %eax,%edx
  800a4a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a4e:	83 c0 08             	add    $0x8,%eax
  800a51:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a54:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800a56:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800a5b:	e9 40 ff ff ff       	jmp    8009a0 <vprintfmt+0x5c5>
  800a60:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a64:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a68:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a6c:	eb e6                	jmp    800a54 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800a6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a71:	83 f8 2f             	cmp    $0x2f,%eax
  800a74:	77 19                	ja     800a8f <vprintfmt+0x6b4>
  800a76:	89 c2                	mov    %eax,%edx
  800a78:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a7c:	83 c0 08             	add    $0x8,%eax
  800a7f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a82:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a85:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800a8a:	e9 11 ff ff ff       	jmp    8009a0 <vprintfmt+0x5c5>
  800a8f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a93:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a97:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a9b:	eb e5                	jmp    800a82 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800a9d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800aa5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aa9:	e9 59 ff ff ff       	jmp    800a07 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800aae:	4c 89 ee             	mov    %r13,%rsi
  800ab1:	bf 25 00 00 00       	mov    $0x25,%edi
  800ab6:	41 ff d6             	call   *%r14
            break;
  800ab9:	e9 52 f9 ff ff       	jmp    800410 <vprintfmt+0x35>
            putch('%', put_arg);
  800abe:	4c 89 ee             	mov    %r13,%rsi
  800ac1:	bf 25 00 00 00       	mov    $0x25,%edi
  800ac6:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800ac9:	48 83 eb 01          	sub    $0x1,%rbx
  800acd:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800ad1:	75 f6                	jne    800ac9 <vprintfmt+0x6ee>
  800ad3:	e9 38 f9 ff ff       	jmp    800410 <vprintfmt+0x35>
}
  800ad8:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800adc:	5b                   	pop    %rbx
  800add:	41 5c                	pop    %r12
  800adf:	41 5d                	pop    %r13
  800ae1:	41 5e                	pop    %r14
  800ae3:	41 5f                	pop    %r15
  800ae5:	5d                   	pop    %rbp
  800ae6:	c3                   	ret

0000000000800ae7 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800ae7:	f3 0f 1e fa          	endbr64
  800aeb:	55                   	push   %rbp
  800aec:	48 89 e5             	mov    %rsp,%rbp
  800aef:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800af3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800af7:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800afc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800b00:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800b07:	48 85 ff             	test   %rdi,%rdi
  800b0a:	74 2b                	je     800b37 <vsnprintf+0x50>
  800b0c:	48 85 f6             	test   %rsi,%rsi
  800b0f:	74 26                	je     800b37 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800b11:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b15:	48 bf 7e 03 80 00 00 	movabs $0x80037e,%rdi
  800b1c:	00 00 00 
  800b1f:	48 b8 db 03 80 00 00 	movabs $0x8003db,%rax
  800b26:	00 00 00 
  800b29:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800b2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b2f:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800b32:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800b35:	c9                   	leave
  800b36:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800b37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b3c:	eb f7                	jmp    800b35 <vsnprintf+0x4e>

0000000000800b3e <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800b3e:	f3 0f 1e fa          	endbr64
  800b42:	55                   	push   %rbp
  800b43:	48 89 e5             	mov    %rsp,%rbp
  800b46:	48 83 ec 50          	sub    $0x50,%rsp
  800b4a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800b4e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800b52:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800b56:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800b5d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b61:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b65:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800b69:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800b6d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800b71:	48 b8 e7 0a 80 00 00 	movabs $0x800ae7,%rax
  800b78:	00 00 00 
  800b7b:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800b7d:	c9                   	leave
  800b7e:	c3                   	ret

0000000000800b7f <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800b7f:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800b83:	80 3f 00             	cmpb   $0x0,(%rdi)
  800b86:	74 10                	je     800b98 <strlen+0x19>
    size_t n = 0;
  800b88:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800b8d:	48 83 c0 01          	add    $0x1,%rax
  800b91:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b95:	75 f6                	jne    800b8d <strlen+0xe>
  800b97:	c3                   	ret
    size_t n = 0;
  800b98:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800b9d:	c3                   	ret

0000000000800b9e <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800b9e:	f3 0f 1e fa          	endbr64
  800ba2:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800ba5:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800baa:	48 85 f6             	test   %rsi,%rsi
  800bad:	74 10                	je     800bbf <strnlen+0x21>
  800baf:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800bb3:	74 0b                	je     800bc0 <strnlen+0x22>
  800bb5:	48 83 c2 01          	add    $0x1,%rdx
  800bb9:	48 39 d0             	cmp    %rdx,%rax
  800bbc:	75 f1                	jne    800baf <strnlen+0x11>
  800bbe:	c3                   	ret
  800bbf:	c3                   	ret
  800bc0:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800bc3:	c3                   	ret

0000000000800bc4 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800bc4:	f3 0f 1e fa          	endbr64
  800bc8:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd0:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800bd4:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800bd7:	48 83 c2 01          	add    $0x1,%rdx
  800bdb:	84 c9                	test   %cl,%cl
  800bdd:	75 f1                	jne    800bd0 <strcpy+0xc>
        ;
    return res;
}
  800bdf:	c3                   	ret

0000000000800be0 <strcat>:

char *
strcat(char *dst, const char *src) {
  800be0:	f3 0f 1e fa          	endbr64
  800be4:	55                   	push   %rbp
  800be5:	48 89 e5             	mov    %rsp,%rbp
  800be8:	41 54                	push   %r12
  800bea:	53                   	push   %rbx
  800beb:	48 89 fb             	mov    %rdi,%rbx
  800bee:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800bf1:	48 b8 7f 0b 80 00 00 	movabs $0x800b7f,%rax
  800bf8:	00 00 00 
  800bfb:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800bfd:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800c01:	4c 89 e6             	mov    %r12,%rsi
  800c04:	48 b8 c4 0b 80 00 00 	movabs $0x800bc4,%rax
  800c0b:	00 00 00 
  800c0e:	ff d0                	call   *%rax
    return dst;
}
  800c10:	48 89 d8             	mov    %rbx,%rax
  800c13:	5b                   	pop    %rbx
  800c14:	41 5c                	pop    %r12
  800c16:	5d                   	pop    %rbp
  800c17:	c3                   	ret

0000000000800c18 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c18:	f3 0f 1e fa          	endbr64
  800c1c:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800c1f:	48 85 d2             	test   %rdx,%rdx
  800c22:	74 1f                	je     800c43 <strncpy+0x2b>
  800c24:	48 01 fa             	add    %rdi,%rdx
  800c27:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800c2a:	48 83 c1 01          	add    $0x1,%rcx
  800c2e:	44 0f b6 06          	movzbl (%rsi),%r8d
  800c32:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800c36:	41 80 f8 01          	cmp    $0x1,%r8b
  800c3a:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800c3e:	48 39 ca             	cmp    %rcx,%rdx
  800c41:	75 e7                	jne    800c2a <strncpy+0x12>
    }
    return ret;
}
  800c43:	c3                   	ret

0000000000800c44 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800c44:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800c48:	48 89 f8             	mov    %rdi,%rax
  800c4b:	48 85 d2             	test   %rdx,%rdx
  800c4e:	74 24                	je     800c74 <strlcpy+0x30>
        while (--size > 0 && *src)
  800c50:	48 83 ea 01          	sub    $0x1,%rdx
  800c54:	74 1b                	je     800c71 <strlcpy+0x2d>
  800c56:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c5a:	0f b6 16             	movzbl (%rsi),%edx
  800c5d:	84 d2                	test   %dl,%dl
  800c5f:	74 10                	je     800c71 <strlcpy+0x2d>
            *dst++ = *src++;
  800c61:	48 83 c6 01          	add    $0x1,%rsi
  800c65:	48 83 c0 01          	add    $0x1,%rax
  800c69:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800c6c:	48 39 c8             	cmp    %rcx,%rax
  800c6f:	75 e9                	jne    800c5a <strlcpy+0x16>
        *dst = '\0';
  800c71:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800c74:	48 29 f8             	sub    %rdi,%rax
}
  800c77:	c3                   	ret

0000000000800c78 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800c78:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800c7c:	0f b6 07             	movzbl (%rdi),%eax
  800c7f:	84 c0                	test   %al,%al
  800c81:	74 13                	je     800c96 <strcmp+0x1e>
  800c83:	38 06                	cmp    %al,(%rsi)
  800c85:	75 0f                	jne    800c96 <strcmp+0x1e>
  800c87:	48 83 c7 01          	add    $0x1,%rdi
  800c8b:	48 83 c6 01          	add    $0x1,%rsi
  800c8f:	0f b6 07             	movzbl (%rdi),%eax
  800c92:	84 c0                	test   %al,%al
  800c94:	75 ed                	jne    800c83 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800c96:	0f b6 c0             	movzbl %al,%eax
  800c99:	0f b6 16             	movzbl (%rsi),%edx
  800c9c:	29 d0                	sub    %edx,%eax
}
  800c9e:	c3                   	ret

0000000000800c9f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800c9f:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800ca3:	48 85 d2             	test   %rdx,%rdx
  800ca6:	74 1f                	je     800cc7 <strncmp+0x28>
  800ca8:	0f b6 07             	movzbl (%rdi),%eax
  800cab:	84 c0                	test   %al,%al
  800cad:	74 1e                	je     800ccd <strncmp+0x2e>
  800caf:	3a 06                	cmp    (%rsi),%al
  800cb1:	75 1a                	jne    800ccd <strncmp+0x2e>
  800cb3:	48 83 c7 01          	add    $0x1,%rdi
  800cb7:	48 83 c6 01          	add    $0x1,%rsi
  800cbb:	48 83 ea 01          	sub    $0x1,%rdx
  800cbf:	75 e7                	jne    800ca8 <strncmp+0x9>

    if (!n) return 0;
  800cc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc6:	c3                   	ret
  800cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccc:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800ccd:	0f b6 07             	movzbl (%rdi),%eax
  800cd0:	0f b6 16             	movzbl (%rsi),%edx
  800cd3:	29 d0                	sub    %edx,%eax
}
  800cd5:	c3                   	ret

0000000000800cd6 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800cd6:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800cda:	0f b6 17             	movzbl (%rdi),%edx
  800cdd:	84 d2                	test   %dl,%dl
  800cdf:	74 18                	je     800cf9 <strchr+0x23>
        if (*str == c) {
  800ce1:	0f be d2             	movsbl %dl,%edx
  800ce4:	39 f2                	cmp    %esi,%edx
  800ce6:	74 17                	je     800cff <strchr+0x29>
    for (; *str; str++) {
  800ce8:	48 83 c7 01          	add    $0x1,%rdi
  800cec:	0f b6 17             	movzbl (%rdi),%edx
  800cef:	84 d2                	test   %dl,%dl
  800cf1:	75 ee                	jne    800ce1 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800cf3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf8:	c3                   	ret
  800cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfe:	c3                   	ret
            return (char *)str;
  800cff:	48 89 f8             	mov    %rdi,%rax
}
  800d02:	c3                   	ret

0000000000800d03 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800d03:	f3 0f 1e fa          	endbr64
  800d07:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800d0a:	0f b6 17             	movzbl (%rdi),%edx
  800d0d:	84 d2                	test   %dl,%dl
  800d0f:	74 13                	je     800d24 <strfind+0x21>
  800d11:	0f be d2             	movsbl %dl,%edx
  800d14:	39 f2                	cmp    %esi,%edx
  800d16:	74 0b                	je     800d23 <strfind+0x20>
  800d18:	48 83 c0 01          	add    $0x1,%rax
  800d1c:	0f b6 10             	movzbl (%rax),%edx
  800d1f:	84 d2                	test   %dl,%dl
  800d21:	75 ee                	jne    800d11 <strfind+0xe>
        ;
    return (char *)str;
}
  800d23:	c3                   	ret
  800d24:	c3                   	ret

0000000000800d25 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800d25:	f3 0f 1e fa          	endbr64
  800d29:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800d2c:	48 89 f8             	mov    %rdi,%rax
  800d2f:	48 f7 d8             	neg    %rax
  800d32:	83 e0 07             	and    $0x7,%eax
  800d35:	49 89 d1             	mov    %rdx,%r9
  800d38:	49 29 c1             	sub    %rax,%r9
  800d3b:	78 36                	js     800d73 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800d3d:	40 0f b6 c6          	movzbl %sil,%eax
  800d41:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800d48:	01 01 01 
  800d4b:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800d4f:	40 f6 c7 07          	test   $0x7,%dil
  800d53:	75 38                	jne    800d8d <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800d55:	4c 89 c9             	mov    %r9,%rcx
  800d58:	48 c1 f9 03          	sar    $0x3,%rcx
  800d5c:	74 0c                	je     800d6a <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800d5e:	fc                   	cld
  800d5f:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800d62:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800d66:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800d6a:	4d 85 c9             	test   %r9,%r9
  800d6d:	75 45                	jne    800db4 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800d6f:	4c 89 c0             	mov    %r8,%rax
  800d72:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800d73:	48 85 d2             	test   %rdx,%rdx
  800d76:	74 f7                	je     800d6f <memset+0x4a>
  800d78:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800d7b:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800d7e:	48 83 c0 01          	add    $0x1,%rax
  800d82:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800d86:	48 39 c2             	cmp    %rax,%rdx
  800d89:	75 f3                	jne    800d7e <memset+0x59>
  800d8b:	eb e2                	jmp    800d6f <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800d8d:	40 f6 c7 01          	test   $0x1,%dil
  800d91:	74 06                	je     800d99 <memset+0x74>
  800d93:	88 07                	mov    %al,(%rdi)
  800d95:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d99:	40 f6 c7 02          	test   $0x2,%dil
  800d9d:	74 07                	je     800da6 <memset+0x81>
  800d9f:	66 89 07             	mov    %ax,(%rdi)
  800da2:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800da6:	40 f6 c7 04          	test   $0x4,%dil
  800daa:	74 a9                	je     800d55 <memset+0x30>
  800dac:	89 07                	mov    %eax,(%rdi)
  800dae:	48 83 c7 04          	add    $0x4,%rdi
  800db2:	eb a1                	jmp    800d55 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800db4:	41 f6 c1 04          	test   $0x4,%r9b
  800db8:	74 1b                	je     800dd5 <memset+0xb0>
  800dba:	89 07                	mov    %eax,(%rdi)
  800dbc:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800dc0:	41 f6 c1 02          	test   $0x2,%r9b
  800dc4:	74 07                	je     800dcd <memset+0xa8>
  800dc6:	66 89 07             	mov    %ax,(%rdi)
  800dc9:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800dcd:	41 f6 c1 01          	test   $0x1,%r9b
  800dd1:	74 9c                	je     800d6f <memset+0x4a>
  800dd3:	eb 06                	jmp    800ddb <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800dd5:	41 f6 c1 02          	test   $0x2,%r9b
  800dd9:	75 eb                	jne    800dc6 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800ddb:	88 07                	mov    %al,(%rdi)
  800ddd:	eb 90                	jmp    800d6f <memset+0x4a>

0000000000800ddf <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800ddf:	f3 0f 1e fa          	endbr64
  800de3:	48 89 f8             	mov    %rdi,%rax
  800de6:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800de9:	48 39 fe             	cmp    %rdi,%rsi
  800dec:	73 3b                	jae    800e29 <memmove+0x4a>
  800dee:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800df2:	48 39 d7             	cmp    %rdx,%rdi
  800df5:	73 32                	jae    800e29 <memmove+0x4a>
        s += n;
        d += n;
  800df7:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800dfb:	48 89 d6             	mov    %rdx,%rsi
  800dfe:	48 09 fe             	or     %rdi,%rsi
  800e01:	48 09 ce             	or     %rcx,%rsi
  800e04:	40 f6 c6 07          	test   $0x7,%sil
  800e08:	75 12                	jne    800e1c <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800e0a:	48 83 ef 08          	sub    $0x8,%rdi
  800e0e:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800e12:	48 c1 e9 03          	shr    $0x3,%rcx
  800e16:	fd                   	std
  800e17:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800e1a:	fc                   	cld
  800e1b:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800e1c:	48 83 ef 01          	sub    $0x1,%rdi
  800e20:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800e24:	fd                   	std
  800e25:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800e27:	eb f1                	jmp    800e1a <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e29:	48 89 f2             	mov    %rsi,%rdx
  800e2c:	48 09 c2             	or     %rax,%rdx
  800e2f:	48 09 ca             	or     %rcx,%rdx
  800e32:	f6 c2 07             	test   $0x7,%dl
  800e35:	75 0c                	jne    800e43 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800e37:	48 c1 e9 03          	shr    $0x3,%rcx
  800e3b:	48 89 c7             	mov    %rax,%rdi
  800e3e:	fc                   	cld
  800e3f:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800e42:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800e43:	48 89 c7             	mov    %rax,%rdi
  800e46:	fc                   	cld
  800e47:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800e49:	c3                   	ret

0000000000800e4a <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800e4a:	f3 0f 1e fa          	endbr64
  800e4e:	55                   	push   %rbp
  800e4f:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800e52:	48 b8 df 0d 80 00 00 	movabs $0x800ddf,%rax
  800e59:	00 00 00 
  800e5c:	ff d0                	call   *%rax
}
  800e5e:	5d                   	pop    %rbp
  800e5f:	c3                   	ret

0000000000800e60 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800e60:	f3 0f 1e fa          	endbr64
  800e64:	55                   	push   %rbp
  800e65:	48 89 e5             	mov    %rsp,%rbp
  800e68:	41 57                	push   %r15
  800e6a:	41 56                	push   %r14
  800e6c:	41 55                	push   %r13
  800e6e:	41 54                	push   %r12
  800e70:	53                   	push   %rbx
  800e71:	48 83 ec 08          	sub    $0x8,%rsp
  800e75:	49 89 fe             	mov    %rdi,%r14
  800e78:	49 89 f7             	mov    %rsi,%r15
  800e7b:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800e7e:	48 89 f7             	mov    %rsi,%rdi
  800e81:	48 b8 7f 0b 80 00 00 	movabs $0x800b7f,%rax
  800e88:	00 00 00 
  800e8b:	ff d0                	call   *%rax
  800e8d:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800e90:	48 89 de             	mov    %rbx,%rsi
  800e93:	4c 89 f7             	mov    %r14,%rdi
  800e96:	48 b8 9e 0b 80 00 00 	movabs $0x800b9e,%rax
  800e9d:	00 00 00 
  800ea0:	ff d0                	call   *%rax
  800ea2:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800ea5:	48 39 c3             	cmp    %rax,%rbx
  800ea8:	74 36                	je     800ee0 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800eaa:	48 89 d8             	mov    %rbx,%rax
  800ead:	4c 29 e8             	sub    %r13,%rax
  800eb0:	49 39 c4             	cmp    %rax,%r12
  800eb3:	73 31                	jae    800ee6 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800eb5:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800eba:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800ebe:	4c 89 fe             	mov    %r15,%rsi
  800ec1:	48 b8 4a 0e 80 00 00 	movabs $0x800e4a,%rax
  800ec8:	00 00 00 
  800ecb:	ff d0                	call   *%rax
    return dstlen + srclen;
  800ecd:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800ed1:	48 83 c4 08          	add    $0x8,%rsp
  800ed5:	5b                   	pop    %rbx
  800ed6:	41 5c                	pop    %r12
  800ed8:	41 5d                	pop    %r13
  800eda:	41 5e                	pop    %r14
  800edc:	41 5f                	pop    %r15
  800ede:	5d                   	pop    %rbp
  800edf:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800ee0:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800ee4:	eb eb                	jmp    800ed1 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800ee6:	48 83 eb 01          	sub    $0x1,%rbx
  800eea:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800eee:	48 89 da             	mov    %rbx,%rdx
  800ef1:	4c 89 fe             	mov    %r15,%rsi
  800ef4:	48 b8 4a 0e 80 00 00 	movabs $0x800e4a,%rax
  800efb:	00 00 00 
  800efe:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800f00:	49 01 de             	add    %rbx,%r14
  800f03:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800f08:	eb c3                	jmp    800ecd <strlcat+0x6d>

0000000000800f0a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800f0a:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800f0e:	48 85 d2             	test   %rdx,%rdx
  800f11:	74 2d                	je     800f40 <memcmp+0x36>
  800f13:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800f18:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800f1c:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800f21:	44 38 c1             	cmp    %r8b,%cl
  800f24:	75 0f                	jne    800f35 <memcmp+0x2b>
    while (n-- > 0) {
  800f26:	48 83 c0 01          	add    $0x1,%rax
  800f2a:	48 39 c2             	cmp    %rax,%rdx
  800f2d:	75 e9                	jne    800f18 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800f2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f34:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800f35:	0f b6 c1             	movzbl %cl,%eax
  800f38:	45 0f b6 c0          	movzbl %r8b,%r8d
  800f3c:	44 29 c0             	sub    %r8d,%eax
  800f3f:	c3                   	ret
    return 0;
  800f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f45:	c3                   	ret

0000000000800f46 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800f46:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800f4a:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800f4e:	48 39 c7             	cmp    %rax,%rdi
  800f51:	73 0f                	jae    800f62 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800f53:	40 38 37             	cmp    %sil,(%rdi)
  800f56:	74 0e                	je     800f66 <memfind+0x20>
    for (; src < end; src++) {
  800f58:	48 83 c7 01          	add    $0x1,%rdi
  800f5c:	48 39 f8             	cmp    %rdi,%rax
  800f5f:	75 f2                	jne    800f53 <memfind+0xd>
  800f61:	c3                   	ret
  800f62:	48 89 f8             	mov    %rdi,%rax
  800f65:	c3                   	ret
  800f66:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800f69:	c3                   	ret

0000000000800f6a <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800f6a:	f3 0f 1e fa          	endbr64
  800f6e:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800f71:	0f b6 37             	movzbl (%rdi),%esi
  800f74:	40 80 fe 20          	cmp    $0x20,%sil
  800f78:	74 06                	je     800f80 <strtol+0x16>
  800f7a:	40 80 fe 09          	cmp    $0x9,%sil
  800f7e:	75 13                	jne    800f93 <strtol+0x29>
  800f80:	48 83 c7 01          	add    $0x1,%rdi
  800f84:	0f b6 37             	movzbl (%rdi),%esi
  800f87:	40 80 fe 20          	cmp    $0x20,%sil
  800f8b:	74 f3                	je     800f80 <strtol+0x16>
  800f8d:	40 80 fe 09          	cmp    $0x9,%sil
  800f91:	74 ed                	je     800f80 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800f93:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800f96:	83 e0 fd             	and    $0xfffffffd,%eax
  800f99:	3c 01                	cmp    $0x1,%al
  800f9b:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f9f:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  800fa5:	75 0f                	jne    800fb6 <strtol+0x4c>
  800fa7:	80 3f 30             	cmpb   $0x30,(%rdi)
  800faa:	74 14                	je     800fc0 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800fac:	85 d2                	test   %edx,%edx
  800fae:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fb3:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  800fb6:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800fbb:	4c 63 ca             	movslq %edx,%r9
  800fbe:	eb 36                	jmp    800ff6 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800fc0:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800fc4:	74 0f                	je     800fd5 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  800fc6:	85 d2                	test   %edx,%edx
  800fc8:	75 ec                	jne    800fb6 <strtol+0x4c>
        s++;
  800fca:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800fce:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  800fd3:	eb e1                	jmp    800fb6 <strtol+0x4c>
        s += 2;
  800fd5:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800fd9:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  800fde:	eb d6                	jmp    800fb6 <strtol+0x4c>
            dig -= '0';
  800fe0:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  800fe3:	44 0f b6 c1          	movzbl %cl,%r8d
  800fe7:	41 39 d0             	cmp    %edx,%r8d
  800fea:	7d 21                	jge    80100d <strtol+0xa3>
        val = val * base + dig;
  800fec:	49 0f af c1          	imul   %r9,%rax
  800ff0:	0f b6 c9             	movzbl %cl,%ecx
  800ff3:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  800ff6:	48 83 c7 01          	add    $0x1,%rdi
  800ffa:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  800ffe:	80 f9 39             	cmp    $0x39,%cl
  801001:	76 dd                	jbe    800fe0 <strtol+0x76>
        else if (dig - 'a' < 27)
  801003:	80 f9 7b             	cmp    $0x7b,%cl
  801006:	77 05                	ja     80100d <strtol+0xa3>
            dig -= 'a' - 10;
  801008:	83 e9 57             	sub    $0x57,%ecx
  80100b:	eb d6                	jmp    800fe3 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  80100d:	4d 85 d2             	test   %r10,%r10
  801010:	74 03                	je     801015 <strtol+0xab>
  801012:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801015:	48 89 c2             	mov    %rax,%rdx
  801018:	48 f7 da             	neg    %rdx
  80101b:	40 80 fe 2d          	cmp    $0x2d,%sil
  80101f:	48 0f 44 c2          	cmove  %rdx,%rax
}
  801023:	c3                   	ret

0000000000801024 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801024:	f3 0f 1e fa          	endbr64
  801028:	55                   	push   %rbp
  801029:	48 89 e5             	mov    %rsp,%rbp
  80102c:	53                   	push   %rbx
  80102d:	48 89 fa             	mov    %rdi,%rdx
  801030:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801033:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801038:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801042:	be 00 00 00 00       	mov    $0x0,%esi
  801047:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80104d:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80104f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801053:	c9                   	leave
  801054:	c3                   	ret

0000000000801055 <sys_cgetc>:

int
sys_cgetc(void) {
  801055:	f3 0f 1e fa          	endbr64
  801059:	55                   	push   %rbp
  80105a:	48 89 e5             	mov    %rsp,%rbp
  80105d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80105e:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801063:	ba 00 00 00 00       	mov    $0x0,%edx
  801068:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80106d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801072:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801077:	be 00 00 00 00       	mov    $0x0,%esi
  80107c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801082:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801084:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801088:	c9                   	leave
  801089:	c3                   	ret

000000000080108a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80108a:	f3 0f 1e fa          	endbr64
  80108e:	55                   	push   %rbp
  80108f:	48 89 e5             	mov    %rsp,%rbp
  801092:	53                   	push   %rbx
  801093:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801097:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80109a:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80109f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010ae:	be 00 00 00 00       	mov    $0x0,%esi
  8010b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010b9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8010bb:	48 85 c0             	test   %rax,%rax
  8010be:	7f 06                	jg     8010c6 <sys_env_destroy+0x3c>
}
  8010c0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010c4:	c9                   	leave
  8010c5:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8010c6:	49 89 c0             	mov    %rax,%r8
  8010c9:	b9 03 00 00 00       	mov    $0x3,%ecx
  8010ce:	48 ba 90 30 80 00 00 	movabs $0x803090,%rdx
  8010d5:	00 00 00 
  8010d8:	be 26 00 00 00       	mov    $0x26,%esi
  8010dd:	48 bf dc 32 80 00 00 	movabs $0x8032dc,%rdi
  8010e4:	00 00 00 
  8010e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ec:	49 b9 f4 2a 80 00 00 	movabs $0x802af4,%r9
  8010f3:	00 00 00 
  8010f6:	41 ff d1             	call   *%r9

00000000008010f9 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8010f9:	f3 0f 1e fa          	endbr64
  8010fd:	55                   	push   %rbp
  8010fe:	48 89 e5             	mov    %rsp,%rbp
  801101:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801102:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801107:	ba 00 00 00 00       	mov    $0x0,%edx
  80110c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801111:	bb 00 00 00 00       	mov    $0x0,%ebx
  801116:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80111b:	be 00 00 00 00       	mov    $0x0,%esi
  801120:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801126:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801128:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80112c:	c9                   	leave
  80112d:	c3                   	ret

000000000080112e <sys_yield>:

void
sys_yield(void) {
  80112e:	f3 0f 1e fa          	endbr64
  801132:	55                   	push   %rbp
  801133:	48 89 e5             	mov    %rsp,%rbp
  801136:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801137:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80113c:	ba 00 00 00 00       	mov    $0x0,%edx
  801141:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801146:	bb 00 00 00 00       	mov    $0x0,%ebx
  80114b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801150:	be 00 00 00 00       	mov    $0x0,%esi
  801155:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80115b:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80115d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801161:	c9                   	leave
  801162:	c3                   	ret

0000000000801163 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801163:	f3 0f 1e fa          	endbr64
  801167:	55                   	push   %rbp
  801168:	48 89 e5             	mov    %rsp,%rbp
  80116b:	53                   	push   %rbx
  80116c:	48 89 fa             	mov    %rdi,%rdx
  80116f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801172:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801177:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80117e:	00 00 00 
  801181:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801186:	be 00 00 00 00       	mov    $0x0,%esi
  80118b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801191:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801193:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801197:	c9                   	leave
  801198:	c3                   	ret

0000000000801199 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801199:	f3 0f 1e fa          	endbr64
  80119d:	55                   	push   %rbp
  80119e:	48 89 e5             	mov    %rsp,%rbp
  8011a1:	53                   	push   %rbx
  8011a2:	49 89 f8             	mov    %rdi,%r8
  8011a5:	48 89 d3             	mov    %rdx,%rbx
  8011a8:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8011ab:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011b0:	4c 89 c2             	mov    %r8,%rdx
  8011b3:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011b6:	be 00 00 00 00       	mov    $0x0,%esi
  8011bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011c1:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8011c3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011c7:	c9                   	leave
  8011c8:	c3                   	ret

00000000008011c9 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8011c9:	f3 0f 1e fa          	endbr64
  8011cd:	55                   	push   %rbp
  8011ce:	48 89 e5             	mov    %rsp,%rbp
  8011d1:	53                   	push   %rbx
  8011d2:	48 83 ec 08          	sub    $0x8,%rsp
  8011d6:	89 f8                	mov    %edi,%eax
  8011d8:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8011db:	48 63 f9             	movslq %ecx,%rdi
  8011de:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011e1:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011e6:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011e9:	be 00 00 00 00       	mov    $0x0,%esi
  8011ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011f4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011f6:	48 85 c0             	test   %rax,%rax
  8011f9:	7f 06                	jg     801201 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8011fb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011ff:	c9                   	leave
  801200:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801201:	49 89 c0             	mov    %rax,%r8
  801204:	b9 04 00 00 00       	mov    $0x4,%ecx
  801209:	48 ba 90 30 80 00 00 	movabs $0x803090,%rdx
  801210:	00 00 00 
  801213:	be 26 00 00 00       	mov    $0x26,%esi
  801218:	48 bf dc 32 80 00 00 	movabs $0x8032dc,%rdi
  80121f:	00 00 00 
  801222:	b8 00 00 00 00       	mov    $0x0,%eax
  801227:	49 b9 f4 2a 80 00 00 	movabs $0x802af4,%r9
  80122e:	00 00 00 
  801231:	41 ff d1             	call   *%r9

0000000000801234 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801234:	f3 0f 1e fa          	endbr64
  801238:	55                   	push   %rbp
  801239:	48 89 e5             	mov    %rsp,%rbp
  80123c:	53                   	push   %rbx
  80123d:	48 83 ec 08          	sub    $0x8,%rsp
  801241:	89 f8                	mov    %edi,%eax
  801243:	49 89 f2             	mov    %rsi,%r10
  801246:	48 89 cf             	mov    %rcx,%rdi
  801249:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80124c:	48 63 da             	movslq %edx,%rbx
  80124f:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801252:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801257:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80125a:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80125d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80125f:	48 85 c0             	test   %rax,%rax
  801262:	7f 06                	jg     80126a <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801264:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801268:	c9                   	leave
  801269:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80126a:	49 89 c0             	mov    %rax,%r8
  80126d:	b9 05 00 00 00       	mov    $0x5,%ecx
  801272:	48 ba 90 30 80 00 00 	movabs $0x803090,%rdx
  801279:	00 00 00 
  80127c:	be 26 00 00 00       	mov    $0x26,%esi
  801281:	48 bf dc 32 80 00 00 	movabs $0x8032dc,%rdi
  801288:	00 00 00 
  80128b:	b8 00 00 00 00       	mov    $0x0,%eax
  801290:	49 b9 f4 2a 80 00 00 	movabs $0x802af4,%r9
  801297:	00 00 00 
  80129a:	41 ff d1             	call   *%r9

000000000080129d <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80129d:	f3 0f 1e fa          	endbr64
  8012a1:	55                   	push   %rbp
  8012a2:	48 89 e5             	mov    %rsp,%rbp
  8012a5:	53                   	push   %rbx
  8012a6:	48 83 ec 08          	sub    $0x8,%rsp
  8012aa:	49 89 f9             	mov    %rdi,%r9
  8012ad:	89 f0                	mov    %esi,%eax
  8012af:	48 89 d3             	mov    %rdx,%rbx
  8012b2:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8012b5:	49 63 f0             	movslq %r8d,%rsi
  8012b8:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8012bb:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012c0:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012c9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012cb:	48 85 c0             	test   %rax,%rax
  8012ce:	7f 06                	jg     8012d6 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8012d0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012d4:	c9                   	leave
  8012d5:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012d6:	49 89 c0             	mov    %rax,%r8
  8012d9:	b9 06 00 00 00       	mov    $0x6,%ecx
  8012de:	48 ba 90 30 80 00 00 	movabs $0x803090,%rdx
  8012e5:	00 00 00 
  8012e8:	be 26 00 00 00       	mov    $0x26,%esi
  8012ed:	48 bf dc 32 80 00 00 	movabs $0x8032dc,%rdi
  8012f4:	00 00 00 
  8012f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fc:	49 b9 f4 2a 80 00 00 	movabs $0x802af4,%r9
  801303:	00 00 00 
  801306:	41 ff d1             	call   *%r9

0000000000801309 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801309:	f3 0f 1e fa          	endbr64
  80130d:	55                   	push   %rbp
  80130e:	48 89 e5             	mov    %rsp,%rbp
  801311:	53                   	push   %rbx
  801312:	48 83 ec 08          	sub    $0x8,%rsp
  801316:	48 89 f1             	mov    %rsi,%rcx
  801319:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80131c:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80131f:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801324:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801329:	be 00 00 00 00       	mov    $0x0,%esi
  80132e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801334:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801336:	48 85 c0             	test   %rax,%rax
  801339:	7f 06                	jg     801341 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80133b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80133f:	c9                   	leave
  801340:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801341:	49 89 c0             	mov    %rax,%r8
  801344:	b9 07 00 00 00       	mov    $0x7,%ecx
  801349:	48 ba 90 30 80 00 00 	movabs $0x803090,%rdx
  801350:	00 00 00 
  801353:	be 26 00 00 00       	mov    $0x26,%esi
  801358:	48 bf dc 32 80 00 00 	movabs $0x8032dc,%rdi
  80135f:	00 00 00 
  801362:	b8 00 00 00 00       	mov    $0x0,%eax
  801367:	49 b9 f4 2a 80 00 00 	movabs $0x802af4,%r9
  80136e:	00 00 00 
  801371:	41 ff d1             	call   *%r9

0000000000801374 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801374:	f3 0f 1e fa          	endbr64
  801378:	55                   	push   %rbp
  801379:	48 89 e5             	mov    %rsp,%rbp
  80137c:	53                   	push   %rbx
  80137d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801381:	48 63 ce             	movslq %esi,%rcx
  801384:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801387:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80138c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801391:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801396:	be 00 00 00 00       	mov    $0x0,%esi
  80139b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013a1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013a3:	48 85 c0             	test   %rax,%rax
  8013a6:	7f 06                	jg     8013ae <sys_env_set_status+0x3a>
}
  8013a8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013ac:	c9                   	leave
  8013ad:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013ae:	49 89 c0             	mov    %rax,%r8
  8013b1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013b6:	48 ba 90 30 80 00 00 	movabs $0x803090,%rdx
  8013bd:	00 00 00 
  8013c0:	be 26 00 00 00       	mov    $0x26,%esi
  8013c5:	48 bf dc 32 80 00 00 	movabs $0x8032dc,%rdi
  8013cc:	00 00 00 
  8013cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d4:	49 b9 f4 2a 80 00 00 	movabs $0x802af4,%r9
  8013db:	00 00 00 
  8013de:	41 ff d1             	call   *%r9

00000000008013e1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8013e1:	f3 0f 1e fa          	endbr64
  8013e5:	55                   	push   %rbp
  8013e6:	48 89 e5             	mov    %rsp,%rbp
  8013e9:	53                   	push   %rbx
  8013ea:	48 83 ec 08          	sub    $0x8,%rsp
  8013ee:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8013f1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013f4:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013fe:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801403:	be 00 00 00 00       	mov    $0x0,%esi
  801408:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80140e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801410:	48 85 c0             	test   %rax,%rax
  801413:	7f 06                	jg     80141b <sys_env_set_trapframe+0x3a>
}
  801415:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801419:	c9                   	leave
  80141a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80141b:	49 89 c0             	mov    %rax,%r8
  80141e:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801423:	48 ba 90 30 80 00 00 	movabs $0x803090,%rdx
  80142a:	00 00 00 
  80142d:	be 26 00 00 00       	mov    $0x26,%esi
  801432:	48 bf dc 32 80 00 00 	movabs $0x8032dc,%rdi
  801439:	00 00 00 
  80143c:	b8 00 00 00 00       	mov    $0x0,%eax
  801441:	49 b9 f4 2a 80 00 00 	movabs $0x802af4,%r9
  801448:	00 00 00 
  80144b:	41 ff d1             	call   *%r9

000000000080144e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80144e:	f3 0f 1e fa          	endbr64
  801452:	55                   	push   %rbp
  801453:	48 89 e5             	mov    %rsp,%rbp
  801456:	53                   	push   %rbx
  801457:	48 83 ec 08          	sub    $0x8,%rsp
  80145b:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80145e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801461:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801466:	bb 00 00 00 00       	mov    $0x0,%ebx
  80146b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801470:	be 00 00 00 00       	mov    $0x0,%esi
  801475:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80147b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80147d:	48 85 c0             	test   %rax,%rax
  801480:	7f 06                	jg     801488 <sys_env_set_pgfault_upcall+0x3a>
}
  801482:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801486:	c9                   	leave
  801487:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801488:	49 89 c0             	mov    %rax,%r8
  80148b:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801490:	48 ba 90 30 80 00 00 	movabs $0x803090,%rdx
  801497:	00 00 00 
  80149a:	be 26 00 00 00       	mov    $0x26,%esi
  80149f:	48 bf dc 32 80 00 00 	movabs $0x8032dc,%rdi
  8014a6:	00 00 00 
  8014a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ae:	49 b9 f4 2a 80 00 00 	movabs $0x802af4,%r9
  8014b5:	00 00 00 
  8014b8:	41 ff d1             	call   *%r9

00000000008014bb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8014bb:	f3 0f 1e fa          	endbr64
  8014bf:	55                   	push   %rbp
  8014c0:	48 89 e5             	mov    %rsp,%rbp
  8014c3:	53                   	push   %rbx
  8014c4:	89 f8                	mov    %edi,%eax
  8014c6:	49 89 f1             	mov    %rsi,%r9
  8014c9:	48 89 d3             	mov    %rdx,%rbx
  8014cc:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8014cf:	49 63 f0             	movslq %r8d,%rsi
  8014d2:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014d5:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014da:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014dd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014e3:	cd 30                	int    $0x30
}
  8014e5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014e9:	c9                   	leave
  8014ea:	c3                   	ret

00000000008014eb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8014eb:	f3 0f 1e fa          	endbr64
  8014ef:	55                   	push   %rbp
  8014f0:	48 89 e5             	mov    %rsp,%rbp
  8014f3:	53                   	push   %rbx
  8014f4:	48 83 ec 08          	sub    $0x8,%rsp
  8014f8:	48 89 fa             	mov    %rdi,%rdx
  8014fb:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8014fe:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801503:	bb 00 00 00 00       	mov    $0x0,%ebx
  801508:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80150d:	be 00 00 00 00       	mov    $0x0,%esi
  801512:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801518:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80151a:	48 85 c0             	test   %rax,%rax
  80151d:	7f 06                	jg     801525 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80151f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801523:	c9                   	leave
  801524:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801525:	49 89 c0             	mov    %rax,%r8
  801528:	b9 0f 00 00 00       	mov    $0xf,%ecx
  80152d:	48 ba 90 30 80 00 00 	movabs $0x803090,%rdx
  801534:	00 00 00 
  801537:	be 26 00 00 00       	mov    $0x26,%esi
  80153c:	48 bf dc 32 80 00 00 	movabs $0x8032dc,%rdi
  801543:	00 00 00 
  801546:	b8 00 00 00 00       	mov    $0x0,%eax
  80154b:	49 b9 f4 2a 80 00 00 	movabs $0x802af4,%r9
  801552:	00 00 00 
  801555:	41 ff d1             	call   *%r9

0000000000801558 <sys_gettime>:

int
sys_gettime(void) {
  801558:	f3 0f 1e fa          	endbr64
  80155c:	55                   	push   %rbp
  80155d:	48 89 e5             	mov    %rsp,%rbp
  801560:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801561:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801566:	ba 00 00 00 00       	mov    $0x0,%edx
  80156b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801570:	bb 00 00 00 00       	mov    $0x0,%ebx
  801575:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80157a:	be 00 00 00 00       	mov    $0x0,%esi
  80157f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801585:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801587:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80158b:	c9                   	leave
  80158c:	c3                   	ret

000000000080158d <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  80158d:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801591:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801598:	ff ff ff 
  80159b:	48 01 f8             	add    %rdi,%rax
  80159e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8015a2:	c3                   	ret

00000000008015a3 <fd2data>:

char *
fd2data(struct Fd *fd) {
  8015a3:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8015a7:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8015ae:	ff ff ff 
  8015b1:	48 01 f8             	add    %rdi,%rax
  8015b4:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8015b8:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8015be:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8015c2:	c3                   	ret

00000000008015c3 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8015c3:	f3 0f 1e fa          	endbr64
  8015c7:	55                   	push   %rbp
  8015c8:	48 89 e5             	mov    %rsp,%rbp
  8015cb:	41 57                	push   %r15
  8015cd:	41 56                	push   %r14
  8015cf:	41 55                	push   %r13
  8015d1:	41 54                	push   %r12
  8015d3:	53                   	push   %rbx
  8015d4:	48 83 ec 08          	sub    $0x8,%rsp
  8015d8:	49 89 ff             	mov    %rdi,%r15
  8015db:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8015e0:	49 bd 22 27 80 00 00 	movabs $0x802722,%r13
  8015e7:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8015ea:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8015f0:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8015f3:	48 89 df             	mov    %rbx,%rdi
  8015f6:	41 ff d5             	call   *%r13
  8015f9:	83 e0 04             	and    $0x4,%eax
  8015fc:	74 17                	je     801615 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8015fe:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801605:	4c 39 f3             	cmp    %r14,%rbx
  801608:	75 e6                	jne    8015f0 <fd_alloc+0x2d>
  80160a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801610:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801615:	4d 89 27             	mov    %r12,(%r15)
}
  801618:	48 83 c4 08          	add    $0x8,%rsp
  80161c:	5b                   	pop    %rbx
  80161d:	41 5c                	pop    %r12
  80161f:	41 5d                	pop    %r13
  801621:	41 5e                	pop    %r14
  801623:	41 5f                	pop    %r15
  801625:	5d                   	pop    %rbp
  801626:	c3                   	ret

0000000000801627 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801627:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  80162b:	83 ff 1f             	cmp    $0x1f,%edi
  80162e:	77 39                	ja     801669 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801630:	55                   	push   %rbp
  801631:	48 89 e5             	mov    %rsp,%rbp
  801634:	41 54                	push   %r12
  801636:	53                   	push   %rbx
  801637:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80163a:	48 63 df             	movslq %edi,%rbx
  80163d:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801644:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801648:	48 89 df             	mov    %rbx,%rdi
  80164b:	48 b8 22 27 80 00 00 	movabs $0x802722,%rax
  801652:	00 00 00 
  801655:	ff d0                	call   *%rax
  801657:	a8 04                	test   $0x4,%al
  801659:	74 14                	je     80166f <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80165b:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80165f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801664:	5b                   	pop    %rbx
  801665:	41 5c                	pop    %r12
  801667:	5d                   	pop    %rbp
  801668:	c3                   	ret
        return -E_INVAL;
  801669:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80166e:	c3                   	ret
        return -E_INVAL;
  80166f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801674:	eb ee                	jmp    801664 <fd_lookup+0x3d>

0000000000801676 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801676:	f3 0f 1e fa          	endbr64
  80167a:	55                   	push   %rbp
  80167b:	48 89 e5             	mov    %rsp,%rbp
  80167e:	41 54                	push   %r12
  801680:	53                   	push   %rbx
  801681:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801684:	48 b8 00 37 80 00 00 	movabs $0x803700,%rax
  80168b:	00 00 00 
  80168e:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  801695:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801698:	39 3b                	cmp    %edi,(%rbx)
  80169a:	74 47                	je     8016e3 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  80169c:	48 83 c0 08          	add    $0x8,%rax
  8016a0:	48 8b 18             	mov    (%rax),%rbx
  8016a3:	48 85 db             	test   %rbx,%rbx
  8016a6:	75 f0                	jne    801698 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016a8:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8016af:	00 00 00 
  8016b2:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8016b8:	89 fa                	mov    %edi,%edx
  8016ba:	48 bf b0 30 80 00 00 	movabs $0x8030b0,%rdi
  8016c1:	00 00 00 
  8016c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c9:	48 b9 7b 02 80 00 00 	movabs $0x80027b,%rcx
  8016d0:	00 00 00 
  8016d3:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8016d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8016da:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8016de:	5b                   	pop    %rbx
  8016df:	41 5c                	pop    %r12
  8016e1:	5d                   	pop    %rbp
  8016e2:	c3                   	ret
            return 0;
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e8:	eb f0                	jmp    8016da <dev_lookup+0x64>

00000000008016ea <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8016ea:	f3 0f 1e fa          	endbr64
  8016ee:	55                   	push   %rbp
  8016ef:	48 89 e5             	mov    %rsp,%rbp
  8016f2:	41 55                	push   %r13
  8016f4:	41 54                	push   %r12
  8016f6:	53                   	push   %rbx
  8016f7:	48 83 ec 18          	sub    $0x18,%rsp
  8016fb:	48 89 fb             	mov    %rdi,%rbx
  8016fe:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801701:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801708:	ff ff ff 
  80170b:	48 01 df             	add    %rbx,%rdi
  80170e:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801712:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801716:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  80171d:	00 00 00 
  801720:	ff d0                	call   *%rax
  801722:	41 89 c5             	mov    %eax,%r13d
  801725:	85 c0                	test   %eax,%eax
  801727:	78 06                	js     80172f <fd_close+0x45>
  801729:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  80172d:	74 1a                	je     801749 <fd_close+0x5f>
        return (must_exist ? res : 0);
  80172f:	45 84 e4             	test   %r12b,%r12b
  801732:	b8 00 00 00 00       	mov    $0x0,%eax
  801737:	44 0f 44 e8          	cmove  %eax,%r13d
}
  80173b:	44 89 e8             	mov    %r13d,%eax
  80173e:	48 83 c4 18          	add    $0x18,%rsp
  801742:	5b                   	pop    %rbx
  801743:	41 5c                	pop    %r12
  801745:	41 5d                	pop    %r13
  801747:	5d                   	pop    %rbp
  801748:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801749:	8b 3b                	mov    (%rbx),%edi
  80174b:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80174f:	48 b8 76 16 80 00 00 	movabs $0x801676,%rax
  801756:	00 00 00 
  801759:	ff d0                	call   *%rax
  80175b:	41 89 c5             	mov    %eax,%r13d
  80175e:	85 c0                	test   %eax,%eax
  801760:	78 1b                	js     80177d <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801762:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801766:	48 8b 40 20          	mov    0x20(%rax),%rax
  80176a:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801770:	48 85 c0             	test   %rax,%rax
  801773:	74 08                	je     80177d <fd_close+0x93>
  801775:	48 89 df             	mov    %rbx,%rdi
  801778:	ff d0                	call   *%rax
  80177a:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80177d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801782:	48 89 de             	mov    %rbx,%rsi
  801785:	bf 00 00 00 00       	mov    $0x0,%edi
  80178a:	48 b8 09 13 80 00 00 	movabs $0x801309,%rax
  801791:	00 00 00 
  801794:	ff d0                	call   *%rax
    return res;
  801796:	eb a3                	jmp    80173b <fd_close+0x51>

0000000000801798 <close>:

int
close(int fdnum) {
  801798:	f3 0f 1e fa          	endbr64
  80179c:	55                   	push   %rbp
  80179d:	48 89 e5             	mov    %rsp,%rbp
  8017a0:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8017a4:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8017a8:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  8017af:	00 00 00 
  8017b2:	ff d0                	call   *%rax
    if (res < 0) return res;
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	78 15                	js     8017cd <close+0x35>

    return fd_close(fd, 1);
  8017b8:	be 01 00 00 00       	mov    $0x1,%esi
  8017bd:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8017c1:	48 b8 ea 16 80 00 00 	movabs $0x8016ea,%rax
  8017c8:	00 00 00 
  8017cb:	ff d0                	call   *%rax
}
  8017cd:	c9                   	leave
  8017ce:	c3                   	ret

00000000008017cf <close_all>:

void
close_all(void) {
  8017cf:	f3 0f 1e fa          	endbr64
  8017d3:	55                   	push   %rbp
  8017d4:	48 89 e5             	mov    %rsp,%rbp
  8017d7:	41 54                	push   %r12
  8017d9:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8017da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017df:	49 bc 98 17 80 00 00 	movabs $0x801798,%r12
  8017e6:	00 00 00 
  8017e9:	89 df                	mov    %ebx,%edi
  8017eb:	41 ff d4             	call   *%r12
  8017ee:	83 c3 01             	add    $0x1,%ebx
  8017f1:	83 fb 20             	cmp    $0x20,%ebx
  8017f4:	75 f3                	jne    8017e9 <close_all+0x1a>
}
  8017f6:	5b                   	pop    %rbx
  8017f7:	41 5c                	pop    %r12
  8017f9:	5d                   	pop    %rbp
  8017fa:	c3                   	ret

00000000008017fb <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8017fb:	f3 0f 1e fa          	endbr64
  8017ff:	55                   	push   %rbp
  801800:	48 89 e5             	mov    %rsp,%rbp
  801803:	41 57                	push   %r15
  801805:	41 56                	push   %r14
  801807:	41 55                	push   %r13
  801809:	41 54                	push   %r12
  80180b:	53                   	push   %rbx
  80180c:	48 83 ec 18          	sub    $0x18,%rsp
  801810:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801813:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801817:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  80181e:	00 00 00 
  801821:	ff d0                	call   *%rax
  801823:	89 c3                	mov    %eax,%ebx
  801825:	85 c0                	test   %eax,%eax
  801827:	0f 88 b8 00 00 00    	js     8018e5 <dup+0xea>
    close(newfdnum);
  80182d:	44 89 e7             	mov    %r12d,%edi
  801830:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801837:	00 00 00 
  80183a:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  80183c:	4d 63 ec             	movslq %r12d,%r13
  80183f:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801846:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  80184a:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  80184e:	4c 89 ff             	mov    %r15,%rdi
  801851:	49 be a3 15 80 00 00 	movabs $0x8015a3,%r14
  801858:	00 00 00 
  80185b:	41 ff d6             	call   *%r14
  80185e:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801861:	4c 89 ef             	mov    %r13,%rdi
  801864:	41 ff d6             	call   *%r14
  801867:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  80186a:	48 89 df             	mov    %rbx,%rdi
  80186d:	48 b8 22 27 80 00 00 	movabs $0x802722,%rax
  801874:	00 00 00 
  801877:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801879:	a8 04                	test   $0x4,%al
  80187b:	74 2b                	je     8018a8 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  80187d:	41 89 c1             	mov    %eax,%r9d
  801880:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801886:	4c 89 f1             	mov    %r14,%rcx
  801889:	ba 00 00 00 00       	mov    $0x0,%edx
  80188e:	48 89 de             	mov    %rbx,%rsi
  801891:	bf 00 00 00 00       	mov    $0x0,%edi
  801896:	48 b8 34 12 80 00 00 	movabs $0x801234,%rax
  80189d:	00 00 00 
  8018a0:	ff d0                	call   *%rax
  8018a2:	89 c3                	mov    %eax,%ebx
  8018a4:	85 c0                	test   %eax,%eax
  8018a6:	78 4e                	js     8018f6 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  8018a8:	4c 89 ff             	mov    %r15,%rdi
  8018ab:	48 b8 22 27 80 00 00 	movabs $0x802722,%rax
  8018b2:	00 00 00 
  8018b5:	ff d0                	call   *%rax
  8018b7:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8018ba:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8018c0:	4c 89 e9             	mov    %r13,%rcx
  8018c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c8:	4c 89 fe             	mov    %r15,%rsi
  8018cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8018d0:	48 b8 34 12 80 00 00 	movabs $0x801234,%rax
  8018d7:	00 00 00 
  8018da:	ff d0                	call   *%rax
  8018dc:	89 c3                	mov    %eax,%ebx
  8018de:	85 c0                	test   %eax,%eax
  8018e0:	78 14                	js     8018f6 <dup+0xfb>

    return newfdnum;
  8018e2:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8018e5:	89 d8                	mov    %ebx,%eax
  8018e7:	48 83 c4 18          	add    $0x18,%rsp
  8018eb:	5b                   	pop    %rbx
  8018ec:	41 5c                	pop    %r12
  8018ee:	41 5d                	pop    %r13
  8018f0:	41 5e                	pop    %r14
  8018f2:	41 5f                	pop    %r15
  8018f4:	5d                   	pop    %rbp
  8018f5:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8018f6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8018fb:	4c 89 ee             	mov    %r13,%rsi
  8018fe:	bf 00 00 00 00       	mov    $0x0,%edi
  801903:	49 bc 09 13 80 00 00 	movabs $0x801309,%r12
  80190a:	00 00 00 
  80190d:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801910:	ba 00 10 00 00       	mov    $0x1000,%edx
  801915:	4c 89 f6             	mov    %r14,%rsi
  801918:	bf 00 00 00 00       	mov    $0x0,%edi
  80191d:	41 ff d4             	call   *%r12
    return res;
  801920:	eb c3                	jmp    8018e5 <dup+0xea>

0000000000801922 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801922:	f3 0f 1e fa          	endbr64
  801926:	55                   	push   %rbp
  801927:	48 89 e5             	mov    %rsp,%rbp
  80192a:	41 56                	push   %r14
  80192c:	41 55                	push   %r13
  80192e:	41 54                	push   %r12
  801930:	53                   	push   %rbx
  801931:	48 83 ec 10          	sub    $0x10,%rsp
  801935:	89 fb                	mov    %edi,%ebx
  801937:	49 89 f4             	mov    %rsi,%r12
  80193a:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80193d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801941:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  801948:	00 00 00 
  80194b:	ff d0                	call   *%rax
  80194d:	85 c0                	test   %eax,%eax
  80194f:	78 4c                	js     80199d <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801951:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801955:	41 8b 3e             	mov    (%r14),%edi
  801958:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80195c:	48 b8 76 16 80 00 00 	movabs $0x801676,%rax
  801963:	00 00 00 
  801966:	ff d0                	call   *%rax
  801968:	85 c0                	test   %eax,%eax
  80196a:	78 35                	js     8019a1 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80196c:	41 8b 46 08          	mov    0x8(%r14),%eax
  801970:	83 e0 03             	and    $0x3,%eax
  801973:	83 f8 01             	cmp    $0x1,%eax
  801976:	74 2d                	je     8019a5 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801978:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80197c:	48 8b 40 10          	mov    0x10(%rax),%rax
  801980:	48 85 c0             	test   %rax,%rax
  801983:	74 56                	je     8019db <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801985:	4c 89 ea             	mov    %r13,%rdx
  801988:	4c 89 e6             	mov    %r12,%rsi
  80198b:	4c 89 f7             	mov    %r14,%rdi
  80198e:	ff d0                	call   *%rax
}
  801990:	48 83 c4 10          	add    $0x10,%rsp
  801994:	5b                   	pop    %rbx
  801995:	41 5c                	pop    %r12
  801997:	41 5d                	pop    %r13
  801999:	41 5e                	pop    %r14
  80199b:	5d                   	pop    %rbp
  80199c:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80199d:	48 98                	cltq
  80199f:	eb ef                	jmp    801990 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019a1:	48 98                	cltq
  8019a3:	eb eb                	jmp    801990 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019a5:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8019ac:	00 00 00 
  8019af:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8019b5:	89 da                	mov    %ebx,%edx
  8019b7:	48 bf ea 32 80 00 00 	movabs $0x8032ea,%rdi
  8019be:	00 00 00 
  8019c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c6:	48 b9 7b 02 80 00 00 	movabs $0x80027b,%rcx
  8019cd:	00 00 00 
  8019d0:	ff d1                	call   *%rcx
        return -E_INVAL;
  8019d2:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  8019d9:	eb b5                	jmp    801990 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  8019db:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  8019e2:	eb ac                	jmp    801990 <read+0x6e>

00000000008019e4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  8019e4:	f3 0f 1e fa          	endbr64
  8019e8:	55                   	push   %rbp
  8019e9:	48 89 e5             	mov    %rsp,%rbp
  8019ec:	41 57                	push   %r15
  8019ee:	41 56                	push   %r14
  8019f0:	41 55                	push   %r13
  8019f2:	41 54                	push   %r12
  8019f4:	53                   	push   %rbx
  8019f5:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  8019f9:	48 85 d2             	test   %rdx,%rdx
  8019fc:	74 54                	je     801a52 <readn+0x6e>
  8019fe:	41 89 fd             	mov    %edi,%r13d
  801a01:	49 89 f6             	mov    %rsi,%r14
  801a04:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801a07:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801a0c:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801a11:	49 bf 22 19 80 00 00 	movabs $0x801922,%r15
  801a18:	00 00 00 
  801a1b:	4c 89 e2             	mov    %r12,%rdx
  801a1e:	48 29 f2             	sub    %rsi,%rdx
  801a21:	4c 01 f6             	add    %r14,%rsi
  801a24:	44 89 ef             	mov    %r13d,%edi
  801a27:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 20                	js     801a4e <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801a2e:	01 c3                	add    %eax,%ebx
  801a30:	85 c0                	test   %eax,%eax
  801a32:	74 08                	je     801a3c <readn+0x58>
  801a34:	48 63 f3             	movslq %ebx,%rsi
  801a37:	4c 39 e6             	cmp    %r12,%rsi
  801a3a:	72 df                	jb     801a1b <readn+0x37>
    }
    return res;
  801a3c:	48 63 c3             	movslq %ebx,%rax
}
  801a3f:	48 83 c4 08          	add    $0x8,%rsp
  801a43:	5b                   	pop    %rbx
  801a44:	41 5c                	pop    %r12
  801a46:	41 5d                	pop    %r13
  801a48:	41 5e                	pop    %r14
  801a4a:	41 5f                	pop    %r15
  801a4c:	5d                   	pop    %rbp
  801a4d:	c3                   	ret
        if (inc < 0) return inc;
  801a4e:	48 98                	cltq
  801a50:	eb ed                	jmp    801a3f <readn+0x5b>
    int inc = 1, res = 0;
  801a52:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a57:	eb e3                	jmp    801a3c <readn+0x58>

0000000000801a59 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801a59:	f3 0f 1e fa          	endbr64
  801a5d:	55                   	push   %rbp
  801a5e:	48 89 e5             	mov    %rsp,%rbp
  801a61:	41 56                	push   %r14
  801a63:	41 55                	push   %r13
  801a65:	41 54                	push   %r12
  801a67:	53                   	push   %rbx
  801a68:	48 83 ec 10          	sub    $0x10,%rsp
  801a6c:	89 fb                	mov    %edi,%ebx
  801a6e:	49 89 f4             	mov    %rsi,%r12
  801a71:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a74:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a78:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  801a7f:	00 00 00 
  801a82:	ff d0                	call   *%rax
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 47                	js     801acf <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a88:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801a8c:	41 8b 3e             	mov    (%r14),%edi
  801a8f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a93:	48 b8 76 16 80 00 00 	movabs $0x801676,%rax
  801a9a:	00 00 00 
  801a9d:	ff d0                	call   *%rax
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	78 30                	js     801ad3 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aa3:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801aa8:	74 2d                	je     801ad7 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801aaa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801aae:	48 8b 40 18          	mov    0x18(%rax),%rax
  801ab2:	48 85 c0             	test   %rax,%rax
  801ab5:	74 56                	je     801b0d <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801ab7:	4c 89 ea             	mov    %r13,%rdx
  801aba:	4c 89 e6             	mov    %r12,%rsi
  801abd:	4c 89 f7             	mov    %r14,%rdi
  801ac0:	ff d0                	call   *%rax
}
  801ac2:	48 83 c4 10          	add    $0x10,%rsp
  801ac6:	5b                   	pop    %rbx
  801ac7:	41 5c                	pop    %r12
  801ac9:	41 5d                	pop    %r13
  801acb:	41 5e                	pop    %r14
  801acd:	5d                   	pop    %rbp
  801ace:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801acf:	48 98                	cltq
  801ad1:	eb ef                	jmp    801ac2 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ad3:	48 98                	cltq
  801ad5:	eb eb                	jmp    801ac2 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ad7:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801ade:	00 00 00 
  801ae1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ae7:	89 da                	mov    %ebx,%edx
  801ae9:	48 bf 06 33 80 00 00 	movabs $0x803306,%rdi
  801af0:	00 00 00 
  801af3:	b8 00 00 00 00       	mov    $0x0,%eax
  801af8:	48 b9 7b 02 80 00 00 	movabs $0x80027b,%rcx
  801aff:	00 00 00 
  801b02:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b04:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801b0b:	eb b5                	jmp    801ac2 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801b0d:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801b14:	eb ac                	jmp    801ac2 <write+0x69>

0000000000801b16 <seek>:

int
seek(int fdnum, off_t offset) {
  801b16:	f3 0f 1e fa          	endbr64
  801b1a:	55                   	push   %rbp
  801b1b:	48 89 e5             	mov    %rsp,%rbp
  801b1e:	53                   	push   %rbx
  801b1f:	48 83 ec 18          	sub    $0x18,%rsp
  801b23:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b25:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801b29:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  801b30:	00 00 00 
  801b33:	ff d0                	call   *%rax
  801b35:	85 c0                	test   %eax,%eax
  801b37:	78 0c                	js     801b45 <seek+0x2f>

    fd->fd_offset = offset;
  801b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b3d:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801b40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b45:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801b49:	c9                   	leave
  801b4a:	c3                   	ret

0000000000801b4b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801b4b:	f3 0f 1e fa          	endbr64
  801b4f:	55                   	push   %rbp
  801b50:	48 89 e5             	mov    %rsp,%rbp
  801b53:	41 55                	push   %r13
  801b55:	41 54                	push   %r12
  801b57:	53                   	push   %rbx
  801b58:	48 83 ec 18          	sub    $0x18,%rsp
  801b5c:	89 fb                	mov    %edi,%ebx
  801b5e:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b61:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b65:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  801b6c:	00 00 00 
  801b6f:	ff d0                	call   *%rax
  801b71:	85 c0                	test   %eax,%eax
  801b73:	78 38                	js     801bad <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b75:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801b79:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801b7d:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b81:	48 b8 76 16 80 00 00 	movabs $0x801676,%rax
  801b88:	00 00 00 
  801b8b:	ff d0                	call   *%rax
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	78 1c                	js     801bad <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b91:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801b96:	74 20                	je     801bb8 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801b98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b9c:	48 8b 40 30          	mov    0x30(%rax),%rax
  801ba0:	48 85 c0             	test   %rax,%rax
  801ba3:	74 47                	je     801bec <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801ba5:	44 89 e6             	mov    %r12d,%esi
  801ba8:	4c 89 ef             	mov    %r13,%rdi
  801bab:	ff d0                	call   *%rax
}
  801bad:	48 83 c4 18          	add    $0x18,%rsp
  801bb1:	5b                   	pop    %rbx
  801bb2:	41 5c                	pop    %r12
  801bb4:	41 5d                	pop    %r13
  801bb6:	5d                   	pop    %rbp
  801bb7:	c3                   	ret
                thisenv->env_id, fdnum);
  801bb8:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801bbf:	00 00 00 
  801bc2:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bc8:	89 da                	mov    %ebx,%edx
  801bca:	48 bf d0 30 80 00 00 	movabs $0x8030d0,%rdi
  801bd1:	00 00 00 
  801bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd9:	48 b9 7b 02 80 00 00 	movabs $0x80027b,%rcx
  801be0:	00 00 00 
  801be3:	ff d1                	call   *%rcx
        return -E_INVAL;
  801be5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bea:	eb c1                	jmp    801bad <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801bec:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801bf1:	eb ba                	jmp    801bad <ftruncate+0x62>

0000000000801bf3 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801bf3:	f3 0f 1e fa          	endbr64
  801bf7:	55                   	push   %rbp
  801bf8:	48 89 e5             	mov    %rsp,%rbp
  801bfb:	41 54                	push   %r12
  801bfd:	53                   	push   %rbx
  801bfe:	48 83 ec 10          	sub    $0x10,%rsp
  801c02:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c05:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c09:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  801c10:	00 00 00 
  801c13:	ff d0                	call   *%rax
  801c15:	85 c0                	test   %eax,%eax
  801c17:	78 4e                	js     801c67 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c19:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801c1d:	41 8b 3c 24          	mov    (%r12),%edi
  801c21:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801c25:	48 b8 76 16 80 00 00 	movabs $0x801676,%rax
  801c2c:	00 00 00 
  801c2f:	ff d0                	call   *%rax
  801c31:	85 c0                	test   %eax,%eax
  801c33:	78 32                	js     801c67 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801c35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c39:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801c3e:	74 30                	je     801c70 <fstat+0x7d>

    stat->st_name[0] = 0;
  801c40:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801c43:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801c4a:	00 00 00 
    stat->st_isdir = 0;
  801c4d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801c54:	00 00 00 
    stat->st_dev = dev;
  801c57:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801c5e:	48 89 de             	mov    %rbx,%rsi
  801c61:	4c 89 e7             	mov    %r12,%rdi
  801c64:	ff 50 28             	call   *0x28(%rax)
}
  801c67:	48 83 c4 10          	add    $0x10,%rsp
  801c6b:	5b                   	pop    %rbx
  801c6c:	41 5c                	pop    %r12
  801c6e:	5d                   	pop    %rbp
  801c6f:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801c70:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801c75:	eb f0                	jmp    801c67 <fstat+0x74>

0000000000801c77 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801c77:	f3 0f 1e fa          	endbr64
  801c7b:	55                   	push   %rbp
  801c7c:	48 89 e5             	mov    %rsp,%rbp
  801c7f:	41 54                	push   %r12
  801c81:	53                   	push   %rbx
  801c82:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801c85:	be 00 00 00 00       	mov    $0x0,%esi
  801c8a:	48 b8 58 1f 80 00 00 	movabs $0x801f58,%rax
  801c91:	00 00 00 
  801c94:	ff d0                	call   *%rax
  801c96:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801c98:	85 c0                	test   %eax,%eax
  801c9a:	78 25                	js     801cc1 <stat+0x4a>

    int res = fstat(fd, stat);
  801c9c:	4c 89 e6             	mov    %r12,%rsi
  801c9f:	89 c7                	mov    %eax,%edi
  801ca1:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801ca8:	00 00 00 
  801cab:	ff d0                	call   *%rax
  801cad:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801cb0:	89 df                	mov    %ebx,%edi
  801cb2:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801cb9:	00 00 00 
  801cbc:	ff d0                	call   *%rax

    return res;
  801cbe:	44 89 e3             	mov    %r12d,%ebx
}
  801cc1:	89 d8                	mov    %ebx,%eax
  801cc3:	5b                   	pop    %rbx
  801cc4:	41 5c                	pop    %r12
  801cc6:	5d                   	pop    %rbp
  801cc7:	c3                   	ret

0000000000801cc8 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801cc8:	f3 0f 1e fa          	endbr64
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	41 54                	push   %r12
  801cd2:	53                   	push   %rbx
  801cd3:	48 83 ec 10          	sub    $0x10,%rsp
  801cd7:	41 89 fc             	mov    %edi,%r12d
  801cda:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801cdd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801ce4:	00 00 00 
  801ce7:	83 38 00             	cmpl   $0x0,(%rax)
  801cea:	74 6e                	je     801d5a <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801cec:	bf 03 00 00 00       	mov    $0x3,%edi
  801cf1:	48 b8 f6 2c 80 00 00 	movabs $0x802cf6,%rax
  801cf8:	00 00 00 
  801cfb:	ff d0                	call   *%rax
  801cfd:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801d04:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801d06:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801d0c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801d11:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801d18:	00 00 00 
  801d1b:	44 89 e6             	mov    %r12d,%esi
  801d1e:	89 c7                	mov    %eax,%edi
  801d20:	48 b8 34 2c 80 00 00 	movabs $0x802c34,%rax
  801d27:	00 00 00 
  801d2a:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801d2c:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801d33:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801d34:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d39:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d3d:	48 89 de             	mov    %rbx,%rsi
  801d40:	bf 00 00 00 00       	mov    $0x0,%edi
  801d45:	48 b8 9b 2b 80 00 00 	movabs $0x802b9b,%rax
  801d4c:	00 00 00 
  801d4f:	ff d0                	call   *%rax
}
  801d51:	48 83 c4 10          	add    $0x10,%rsp
  801d55:	5b                   	pop    %rbx
  801d56:	41 5c                	pop    %r12
  801d58:	5d                   	pop    %rbp
  801d59:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801d5a:	bf 03 00 00 00       	mov    $0x3,%edi
  801d5f:	48 b8 f6 2c 80 00 00 	movabs $0x802cf6,%rax
  801d66:	00 00 00 
  801d69:	ff d0                	call   *%rax
  801d6b:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801d72:	00 00 
  801d74:	e9 73 ff ff ff       	jmp    801cec <fsipc+0x24>

0000000000801d79 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801d79:	f3 0f 1e fa          	endbr64
  801d7d:	55                   	push   %rbp
  801d7e:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d81:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801d88:	00 00 00 
  801d8b:	8b 57 0c             	mov    0xc(%rdi),%edx
  801d8e:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801d90:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801d93:	be 00 00 00 00       	mov    $0x0,%esi
  801d98:	bf 02 00 00 00       	mov    $0x2,%edi
  801d9d:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  801da4:	00 00 00 
  801da7:	ff d0                	call   *%rax
}
  801da9:	5d                   	pop    %rbp
  801daa:	c3                   	ret

0000000000801dab <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801dab:	f3 0f 1e fa          	endbr64
  801daf:	55                   	push   %rbp
  801db0:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801db3:	8b 47 0c             	mov    0xc(%rdi),%eax
  801db6:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801dbd:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801dbf:	be 00 00 00 00       	mov    $0x0,%esi
  801dc4:	bf 06 00 00 00       	mov    $0x6,%edi
  801dc9:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  801dd0:	00 00 00 
  801dd3:	ff d0                	call   *%rax
}
  801dd5:	5d                   	pop    %rbp
  801dd6:	c3                   	ret

0000000000801dd7 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801dd7:	f3 0f 1e fa          	endbr64
  801ddb:	55                   	push   %rbp
  801ddc:	48 89 e5             	mov    %rsp,%rbp
  801ddf:	41 54                	push   %r12
  801de1:	53                   	push   %rbx
  801de2:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801de5:	8b 47 0c             	mov    0xc(%rdi),%eax
  801de8:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801def:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801df1:	be 00 00 00 00       	mov    $0x0,%esi
  801df6:	bf 05 00 00 00       	mov    $0x5,%edi
  801dfb:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  801e02:	00 00 00 
  801e05:	ff d0                	call   *%rax
    if (res < 0) return res;
  801e07:	85 c0                	test   %eax,%eax
  801e09:	78 3d                	js     801e48 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e0b:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  801e12:	00 00 00 
  801e15:	4c 89 e6             	mov    %r12,%rsi
  801e18:	48 89 df             	mov    %rbx,%rdi
  801e1b:	48 b8 c4 0b 80 00 00 	movabs $0x800bc4,%rax
  801e22:	00 00 00 
  801e25:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801e27:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801e2e:	00 
  801e2f:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e35:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801e3c:	00 
  801e3d:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801e43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e48:	5b                   	pop    %rbx
  801e49:	41 5c                	pop    %r12
  801e4b:	5d                   	pop    %rbp
  801e4c:	c3                   	ret

0000000000801e4d <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801e4d:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801e51:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801e58:	77 41                	ja     801e9b <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801e5a:	55                   	push   %rbp
  801e5b:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e5e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e65:	00 00 00 
  801e68:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801e6b:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  801e6d:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801e71:	48 8d 78 10          	lea    0x10(%rax),%rdi
  801e75:	48 b8 df 0d 80 00 00 	movabs $0x800ddf,%rax
  801e7c:	00 00 00 
  801e7f:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  801e81:	be 00 00 00 00       	mov    $0x0,%esi
  801e86:	bf 04 00 00 00       	mov    $0x4,%edi
  801e8b:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  801e92:	00 00 00 
  801e95:	ff d0                	call   *%rax
  801e97:	48 98                	cltq
}
  801e99:	5d                   	pop    %rbp
  801e9a:	c3                   	ret
        return -E_INVAL;
  801e9b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  801ea2:	c3                   	ret

0000000000801ea3 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801ea3:	f3 0f 1e fa          	endbr64
  801ea7:	55                   	push   %rbp
  801ea8:	48 89 e5             	mov    %rsp,%rbp
  801eab:	41 55                	push   %r13
  801ead:	41 54                	push   %r12
  801eaf:	53                   	push   %rbx
  801eb0:	48 83 ec 08          	sub    $0x8,%rsp
  801eb4:	49 89 f4             	mov    %rsi,%r12
  801eb7:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801eba:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801ec1:	00 00 00 
  801ec4:	8b 57 0c             	mov    0xc(%rdi),%edx
  801ec7:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  801ec9:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  801ecd:	be 00 00 00 00       	mov    $0x0,%esi
  801ed2:	bf 03 00 00 00       	mov    $0x3,%edi
  801ed7:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  801ede:	00 00 00 
  801ee1:	ff d0                	call   *%rax
  801ee3:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  801ee6:	4d 85 ed             	test   %r13,%r13
  801ee9:	78 2a                	js     801f15 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  801eeb:	4c 89 ea             	mov    %r13,%rdx
  801eee:	4c 39 eb             	cmp    %r13,%rbx
  801ef1:	72 30                	jb     801f23 <devfile_read+0x80>
  801ef3:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  801efa:	7f 27                	jg     801f23 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  801efc:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801f03:	00 00 00 
  801f06:	4c 89 e7             	mov    %r12,%rdi
  801f09:	48 b8 df 0d 80 00 00 	movabs $0x800ddf,%rax
  801f10:	00 00 00 
  801f13:	ff d0                	call   *%rax
}
  801f15:	4c 89 e8             	mov    %r13,%rax
  801f18:	48 83 c4 08          	add    $0x8,%rsp
  801f1c:	5b                   	pop    %rbx
  801f1d:	41 5c                	pop    %r12
  801f1f:	41 5d                	pop    %r13
  801f21:	5d                   	pop    %rbp
  801f22:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801f23:	48 b9 23 33 80 00 00 	movabs $0x803323,%rcx
  801f2a:	00 00 00 
  801f2d:	48 ba 40 33 80 00 00 	movabs $0x803340,%rdx
  801f34:	00 00 00 
  801f37:	be 7b 00 00 00       	mov    $0x7b,%esi
  801f3c:	48 bf 55 33 80 00 00 	movabs $0x803355,%rdi
  801f43:	00 00 00 
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4b:	49 b8 f4 2a 80 00 00 	movabs $0x802af4,%r8
  801f52:	00 00 00 
  801f55:	41 ff d0             	call   *%r8

0000000000801f58 <open>:
open(const char *path, int mode) {
  801f58:	f3 0f 1e fa          	endbr64
  801f5c:	55                   	push   %rbp
  801f5d:	48 89 e5             	mov    %rsp,%rbp
  801f60:	41 55                	push   %r13
  801f62:	41 54                	push   %r12
  801f64:	53                   	push   %rbx
  801f65:	48 83 ec 18          	sub    $0x18,%rsp
  801f69:	49 89 fc             	mov    %rdi,%r12
  801f6c:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801f6f:	48 b8 7f 0b 80 00 00 	movabs $0x800b7f,%rax
  801f76:	00 00 00 
  801f79:	ff d0                	call   *%rax
  801f7b:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801f81:	0f 87 8a 00 00 00    	ja     802011 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801f87:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801f8b:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  801f92:	00 00 00 
  801f95:	ff d0                	call   *%rax
  801f97:	89 c3                	mov    %eax,%ebx
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	78 50                	js     801fed <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  801f9d:	4c 89 e6             	mov    %r12,%rsi
  801fa0:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801fa7:	00 00 00 
  801faa:	48 89 df             	mov    %rbx,%rdi
  801fad:	48 b8 c4 0b 80 00 00 	movabs $0x800bc4,%rax
  801fb4:	00 00 00 
  801fb7:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801fb9:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fc0:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801fc4:	bf 01 00 00 00       	mov    $0x1,%edi
  801fc9:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  801fd0:	00 00 00 
  801fd3:	ff d0                	call   *%rax
  801fd5:	89 c3                	mov    %eax,%ebx
  801fd7:	85 c0                	test   %eax,%eax
  801fd9:	78 1f                	js     801ffa <open+0xa2>
    return fd2num(fd);
  801fdb:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801fdf:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  801fe6:	00 00 00 
  801fe9:	ff d0                	call   *%rax
  801feb:	89 c3                	mov    %eax,%ebx
}
  801fed:	89 d8                	mov    %ebx,%eax
  801fef:	48 83 c4 18          	add    $0x18,%rsp
  801ff3:	5b                   	pop    %rbx
  801ff4:	41 5c                	pop    %r12
  801ff6:	41 5d                	pop    %r13
  801ff8:	5d                   	pop    %rbp
  801ff9:	c3                   	ret
        fd_close(fd, 0);
  801ffa:	be 00 00 00 00       	mov    $0x0,%esi
  801fff:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802003:	48 b8 ea 16 80 00 00 	movabs $0x8016ea,%rax
  80200a:	00 00 00 
  80200d:	ff d0                	call   *%rax
        return res;
  80200f:	eb dc                	jmp    801fed <open+0x95>
        return -E_BAD_PATH;
  802011:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802016:	eb d5                	jmp    801fed <open+0x95>

0000000000802018 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802018:	f3 0f 1e fa          	endbr64
  80201c:	55                   	push   %rbp
  80201d:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802020:	be 00 00 00 00       	mov    $0x0,%esi
  802025:	bf 08 00 00 00       	mov    $0x8,%edi
  80202a:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  802031:	00 00 00 
  802034:	ff d0                	call   *%rax
}
  802036:	5d                   	pop    %rbp
  802037:	c3                   	ret

0000000000802038 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802038:	f3 0f 1e fa          	endbr64
  80203c:	55                   	push   %rbp
  80203d:	48 89 e5             	mov    %rsp,%rbp
  802040:	41 54                	push   %r12
  802042:	53                   	push   %rbx
  802043:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802046:	48 b8 a3 15 80 00 00 	movabs $0x8015a3,%rax
  80204d:	00 00 00 
  802050:	ff d0                	call   *%rax
  802052:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802055:	48 be 60 33 80 00 00 	movabs $0x803360,%rsi
  80205c:	00 00 00 
  80205f:	48 89 df             	mov    %rbx,%rdi
  802062:	48 b8 c4 0b 80 00 00 	movabs $0x800bc4,%rax
  802069:	00 00 00 
  80206c:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80206e:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802073:	41 2b 04 24          	sub    (%r12),%eax
  802077:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80207d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802084:	00 00 00 
    stat->st_dev = &devpipe;
  802087:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80208e:	00 00 00 
  802091:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802098:	b8 00 00 00 00       	mov    $0x0,%eax
  80209d:	5b                   	pop    %rbx
  80209e:	41 5c                	pop    %r12
  8020a0:	5d                   	pop    %rbp
  8020a1:	c3                   	ret

00000000008020a2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8020a2:	f3 0f 1e fa          	endbr64
  8020a6:	55                   	push   %rbp
  8020a7:	48 89 e5             	mov    %rsp,%rbp
  8020aa:	41 54                	push   %r12
  8020ac:	53                   	push   %rbx
  8020ad:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8020b0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8020b5:	48 89 fe             	mov    %rdi,%rsi
  8020b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8020bd:	49 bc 09 13 80 00 00 	movabs $0x801309,%r12
  8020c4:	00 00 00 
  8020c7:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8020ca:	48 89 df             	mov    %rbx,%rdi
  8020cd:	48 b8 a3 15 80 00 00 	movabs $0x8015a3,%rax
  8020d4:	00 00 00 
  8020d7:	ff d0                	call   *%rax
  8020d9:	48 89 c6             	mov    %rax,%rsi
  8020dc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8020e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8020e6:	41 ff d4             	call   *%r12
}
  8020e9:	5b                   	pop    %rbx
  8020ea:	41 5c                	pop    %r12
  8020ec:	5d                   	pop    %rbp
  8020ed:	c3                   	ret

00000000008020ee <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8020ee:	f3 0f 1e fa          	endbr64
  8020f2:	55                   	push   %rbp
  8020f3:	48 89 e5             	mov    %rsp,%rbp
  8020f6:	41 57                	push   %r15
  8020f8:	41 56                	push   %r14
  8020fa:	41 55                	push   %r13
  8020fc:	41 54                	push   %r12
  8020fe:	53                   	push   %rbx
  8020ff:	48 83 ec 18          	sub    $0x18,%rsp
  802103:	49 89 fc             	mov    %rdi,%r12
  802106:	49 89 f5             	mov    %rsi,%r13
  802109:	49 89 d7             	mov    %rdx,%r15
  80210c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802110:	48 b8 a3 15 80 00 00 	movabs $0x8015a3,%rax
  802117:	00 00 00 
  80211a:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80211c:	4d 85 ff             	test   %r15,%r15
  80211f:	0f 84 af 00 00 00    	je     8021d4 <devpipe_write+0xe6>
  802125:	48 89 c3             	mov    %rax,%rbx
  802128:	4c 89 f8             	mov    %r15,%rax
  80212b:	4d 89 ef             	mov    %r13,%r15
  80212e:	4c 01 e8             	add    %r13,%rax
  802131:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802135:	49 bd 99 11 80 00 00 	movabs $0x801199,%r13
  80213c:	00 00 00 
            sys_yield();
  80213f:	49 be 2e 11 80 00 00 	movabs $0x80112e,%r14
  802146:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802149:	8b 73 04             	mov    0x4(%rbx),%esi
  80214c:	48 63 ce             	movslq %esi,%rcx
  80214f:	48 63 03             	movslq (%rbx),%rax
  802152:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802158:	48 39 c1             	cmp    %rax,%rcx
  80215b:	72 2e                	jb     80218b <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80215d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802162:	48 89 da             	mov    %rbx,%rdx
  802165:	be 00 10 00 00       	mov    $0x1000,%esi
  80216a:	4c 89 e7             	mov    %r12,%rdi
  80216d:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802170:	85 c0                	test   %eax,%eax
  802172:	74 66                	je     8021da <devpipe_write+0xec>
            sys_yield();
  802174:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802177:	8b 73 04             	mov    0x4(%rbx),%esi
  80217a:	48 63 ce             	movslq %esi,%rcx
  80217d:	48 63 03             	movslq (%rbx),%rax
  802180:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802186:	48 39 c1             	cmp    %rax,%rcx
  802189:	73 d2                	jae    80215d <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80218b:	41 0f b6 3f          	movzbl (%r15),%edi
  80218f:	48 89 ca             	mov    %rcx,%rdx
  802192:	48 c1 ea 03          	shr    $0x3,%rdx
  802196:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80219d:	08 10 20 
  8021a0:	48 f7 e2             	mul    %rdx
  8021a3:	48 c1 ea 06          	shr    $0x6,%rdx
  8021a7:	48 89 d0             	mov    %rdx,%rax
  8021aa:	48 c1 e0 09          	shl    $0x9,%rax
  8021ae:	48 29 d0             	sub    %rdx,%rax
  8021b1:	48 c1 e0 03          	shl    $0x3,%rax
  8021b5:	48 29 c1             	sub    %rax,%rcx
  8021b8:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8021bd:	83 c6 01             	add    $0x1,%esi
  8021c0:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8021c3:	49 83 c7 01          	add    $0x1,%r15
  8021c7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8021cb:	49 39 c7             	cmp    %rax,%r15
  8021ce:	0f 85 75 ff ff ff    	jne    802149 <devpipe_write+0x5b>
    return n;
  8021d4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8021d8:	eb 05                	jmp    8021df <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8021da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021df:	48 83 c4 18          	add    $0x18,%rsp
  8021e3:	5b                   	pop    %rbx
  8021e4:	41 5c                	pop    %r12
  8021e6:	41 5d                	pop    %r13
  8021e8:	41 5e                	pop    %r14
  8021ea:	41 5f                	pop    %r15
  8021ec:	5d                   	pop    %rbp
  8021ed:	c3                   	ret

00000000008021ee <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8021ee:	f3 0f 1e fa          	endbr64
  8021f2:	55                   	push   %rbp
  8021f3:	48 89 e5             	mov    %rsp,%rbp
  8021f6:	41 57                	push   %r15
  8021f8:	41 56                	push   %r14
  8021fa:	41 55                	push   %r13
  8021fc:	41 54                	push   %r12
  8021fe:	53                   	push   %rbx
  8021ff:	48 83 ec 18          	sub    $0x18,%rsp
  802203:	49 89 fc             	mov    %rdi,%r12
  802206:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80220a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80220e:	48 b8 a3 15 80 00 00 	movabs $0x8015a3,%rax
  802215:	00 00 00 
  802218:	ff d0                	call   *%rax
  80221a:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80221d:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802223:	49 bd 99 11 80 00 00 	movabs $0x801199,%r13
  80222a:	00 00 00 
            sys_yield();
  80222d:	49 be 2e 11 80 00 00 	movabs $0x80112e,%r14
  802234:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802237:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80223c:	74 7d                	je     8022bb <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80223e:	8b 03                	mov    (%rbx),%eax
  802240:	3b 43 04             	cmp    0x4(%rbx),%eax
  802243:	75 26                	jne    80226b <devpipe_read+0x7d>
            if (i > 0) return i;
  802245:	4d 85 ff             	test   %r15,%r15
  802248:	75 77                	jne    8022c1 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80224a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80224f:	48 89 da             	mov    %rbx,%rdx
  802252:	be 00 10 00 00       	mov    $0x1000,%esi
  802257:	4c 89 e7             	mov    %r12,%rdi
  80225a:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80225d:	85 c0                	test   %eax,%eax
  80225f:	74 72                	je     8022d3 <devpipe_read+0xe5>
            sys_yield();
  802261:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802264:	8b 03                	mov    (%rbx),%eax
  802266:	3b 43 04             	cmp    0x4(%rbx),%eax
  802269:	74 df                	je     80224a <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80226b:	48 63 c8             	movslq %eax,%rcx
  80226e:	48 89 ca             	mov    %rcx,%rdx
  802271:	48 c1 ea 03          	shr    $0x3,%rdx
  802275:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  80227c:	08 10 20 
  80227f:	48 89 d0             	mov    %rdx,%rax
  802282:	48 f7 e6             	mul    %rsi
  802285:	48 c1 ea 06          	shr    $0x6,%rdx
  802289:	48 89 d0             	mov    %rdx,%rax
  80228c:	48 c1 e0 09          	shl    $0x9,%rax
  802290:	48 29 d0             	sub    %rdx,%rax
  802293:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80229a:	00 
  80229b:	48 89 c8             	mov    %rcx,%rax
  80229e:	48 29 d0             	sub    %rdx,%rax
  8022a1:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8022a6:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8022aa:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8022ae:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8022b1:	49 83 c7 01          	add    $0x1,%r15
  8022b5:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8022b9:	75 83                	jne    80223e <devpipe_read+0x50>
    return n;
  8022bb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8022bf:	eb 03                	jmp    8022c4 <devpipe_read+0xd6>
            if (i > 0) return i;
  8022c1:	4c 89 f8             	mov    %r15,%rax
}
  8022c4:	48 83 c4 18          	add    $0x18,%rsp
  8022c8:	5b                   	pop    %rbx
  8022c9:	41 5c                	pop    %r12
  8022cb:	41 5d                	pop    %r13
  8022cd:	41 5e                	pop    %r14
  8022cf:	41 5f                	pop    %r15
  8022d1:	5d                   	pop    %rbp
  8022d2:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d8:	eb ea                	jmp    8022c4 <devpipe_read+0xd6>

00000000008022da <pipe>:
pipe(int pfd[2]) {
  8022da:	f3 0f 1e fa          	endbr64
  8022de:	55                   	push   %rbp
  8022df:	48 89 e5             	mov    %rsp,%rbp
  8022e2:	41 55                	push   %r13
  8022e4:	41 54                	push   %r12
  8022e6:	53                   	push   %rbx
  8022e7:	48 83 ec 18          	sub    $0x18,%rsp
  8022eb:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8022ee:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8022f2:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  8022f9:	00 00 00 
  8022fc:	ff d0                	call   *%rax
  8022fe:	89 c3                	mov    %eax,%ebx
  802300:	85 c0                	test   %eax,%eax
  802302:	0f 88 a0 01 00 00    	js     8024a8 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802308:	b9 46 00 00 00       	mov    $0x46,%ecx
  80230d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802312:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802316:	bf 00 00 00 00       	mov    $0x0,%edi
  80231b:	48 b8 c9 11 80 00 00 	movabs $0x8011c9,%rax
  802322:	00 00 00 
  802325:	ff d0                	call   *%rax
  802327:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802329:	85 c0                	test   %eax,%eax
  80232b:	0f 88 77 01 00 00    	js     8024a8 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802331:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802335:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  80233c:	00 00 00 
  80233f:	ff d0                	call   *%rax
  802341:	89 c3                	mov    %eax,%ebx
  802343:	85 c0                	test   %eax,%eax
  802345:	0f 88 43 01 00 00    	js     80248e <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80234b:	b9 46 00 00 00       	mov    $0x46,%ecx
  802350:	ba 00 10 00 00       	mov    $0x1000,%edx
  802355:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802359:	bf 00 00 00 00       	mov    $0x0,%edi
  80235e:	48 b8 c9 11 80 00 00 	movabs $0x8011c9,%rax
  802365:	00 00 00 
  802368:	ff d0                	call   *%rax
  80236a:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80236c:	85 c0                	test   %eax,%eax
  80236e:	0f 88 1a 01 00 00    	js     80248e <pipe+0x1b4>
    va = fd2data(fd0);
  802374:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802378:	48 b8 a3 15 80 00 00 	movabs $0x8015a3,%rax
  80237f:	00 00 00 
  802382:	ff d0                	call   *%rax
  802384:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802387:	b9 46 00 00 00       	mov    $0x46,%ecx
  80238c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802391:	48 89 c6             	mov    %rax,%rsi
  802394:	bf 00 00 00 00       	mov    $0x0,%edi
  802399:	48 b8 c9 11 80 00 00 	movabs $0x8011c9,%rax
  8023a0:	00 00 00 
  8023a3:	ff d0                	call   *%rax
  8023a5:	89 c3                	mov    %eax,%ebx
  8023a7:	85 c0                	test   %eax,%eax
  8023a9:	0f 88 c5 00 00 00    	js     802474 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8023af:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8023b3:	48 b8 a3 15 80 00 00 	movabs $0x8015a3,%rax
  8023ba:	00 00 00 
  8023bd:	ff d0                	call   *%rax
  8023bf:	48 89 c1             	mov    %rax,%rcx
  8023c2:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8023c8:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8023ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8023d3:	4c 89 ee             	mov    %r13,%rsi
  8023d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8023db:	48 b8 34 12 80 00 00 	movabs $0x801234,%rax
  8023e2:	00 00 00 
  8023e5:	ff d0                	call   *%rax
  8023e7:	89 c3                	mov    %eax,%ebx
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	78 6e                	js     80245b <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8023ed:	be 00 10 00 00       	mov    $0x1000,%esi
  8023f2:	4c 89 ef             	mov    %r13,%rdi
  8023f5:	48 b8 63 11 80 00 00 	movabs $0x801163,%rax
  8023fc:	00 00 00 
  8023ff:	ff d0                	call   *%rax
  802401:	83 f8 02             	cmp    $0x2,%eax
  802404:	0f 85 ab 00 00 00    	jne    8024b5 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  80240a:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802411:	00 00 
  802413:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802417:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802419:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80241d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802424:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802428:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80242a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80242e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802435:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802439:	48 bb 8d 15 80 00 00 	movabs $0x80158d,%rbx
  802440:	00 00 00 
  802443:	ff d3                	call   *%rbx
  802445:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802449:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80244d:	ff d3                	call   *%rbx
  80244f:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802454:	bb 00 00 00 00       	mov    $0x0,%ebx
  802459:	eb 4d                	jmp    8024a8 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  80245b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802460:	4c 89 ee             	mov    %r13,%rsi
  802463:	bf 00 00 00 00       	mov    $0x0,%edi
  802468:	48 b8 09 13 80 00 00 	movabs $0x801309,%rax
  80246f:	00 00 00 
  802472:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802474:	ba 00 10 00 00       	mov    $0x1000,%edx
  802479:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80247d:	bf 00 00 00 00       	mov    $0x0,%edi
  802482:	48 b8 09 13 80 00 00 	movabs $0x801309,%rax
  802489:	00 00 00 
  80248c:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80248e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802493:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802497:	bf 00 00 00 00       	mov    $0x0,%edi
  80249c:	48 b8 09 13 80 00 00 	movabs $0x801309,%rax
  8024a3:	00 00 00 
  8024a6:	ff d0                	call   *%rax
}
  8024a8:	89 d8                	mov    %ebx,%eax
  8024aa:	48 83 c4 18          	add    $0x18,%rsp
  8024ae:	5b                   	pop    %rbx
  8024af:	41 5c                	pop    %r12
  8024b1:	41 5d                	pop    %r13
  8024b3:	5d                   	pop    %rbp
  8024b4:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8024b5:	48 b9 f8 30 80 00 00 	movabs $0x8030f8,%rcx
  8024bc:	00 00 00 
  8024bf:	48 ba 40 33 80 00 00 	movabs $0x803340,%rdx
  8024c6:	00 00 00 
  8024c9:	be 2e 00 00 00       	mov    $0x2e,%esi
  8024ce:	48 bf 67 33 80 00 00 	movabs $0x803367,%rdi
  8024d5:	00 00 00 
  8024d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024dd:	49 b8 f4 2a 80 00 00 	movabs $0x802af4,%r8
  8024e4:	00 00 00 
  8024e7:	41 ff d0             	call   *%r8

00000000008024ea <pipeisclosed>:
pipeisclosed(int fdnum) {
  8024ea:	f3 0f 1e fa          	endbr64
  8024ee:	55                   	push   %rbp
  8024ef:	48 89 e5             	mov    %rsp,%rbp
  8024f2:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8024f6:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8024fa:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  802501:	00 00 00 
  802504:	ff d0                	call   *%rax
    if (res < 0) return res;
  802506:	85 c0                	test   %eax,%eax
  802508:	78 35                	js     80253f <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80250a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80250e:	48 b8 a3 15 80 00 00 	movabs $0x8015a3,%rax
  802515:	00 00 00 
  802518:	ff d0                	call   *%rax
  80251a:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80251d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802522:	be 00 10 00 00       	mov    $0x1000,%esi
  802527:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80252b:	48 b8 99 11 80 00 00 	movabs $0x801199,%rax
  802532:	00 00 00 
  802535:	ff d0                	call   *%rax
  802537:	85 c0                	test   %eax,%eax
  802539:	0f 94 c0             	sete   %al
  80253c:	0f b6 c0             	movzbl %al,%eax
}
  80253f:	c9                   	leave
  802540:	c3                   	ret

0000000000802541 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802541:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802545:	48 89 f8             	mov    %rdi,%rax
  802548:	48 c1 e8 27          	shr    $0x27,%rax
  80254c:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802553:	7f 00 00 
  802556:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80255a:	f6 c2 01             	test   $0x1,%dl
  80255d:	74 6d                	je     8025cc <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80255f:	48 89 f8             	mov    %rdi,%rax
  802562:	48 c1 e8 1e          	shr    $0x1e,%rax
  802566:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80256d:	7f 00 00 
  802570:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802574:	f6 c2 01             	test   $0x1,%dl
  802577:	74 62                	je     8025db <get_uvpt_entry+0x9a>
  802579:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802580:	7f 00 00 
  802583:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802587:	f6 c2 80             	test   $0x80,%dl
  80258a:	75 4f                	jne    8025db <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80258c:	48 89 f8             	mov    %rdi,%rax
  80258f:	48 c1 e8 15          	shr    $0x15,%rax
  802593:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80259a:	7f 00 00 
  80259d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8025a1:	f6 c2 01             	test   $0x1,%dl
  8025a4:	74 44                	je     8025ea <get_uvpt_entry+0xa9>
  8025a6:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8025ad:	7f 00 00 
  8025b0:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8025b4:	f6 c2 80             	test   $0x80,%dl
  8025b7:	75 31                	jne    8025ea <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  8025b9:	48 c1 ef 0c          	shr    $0xc,%rdi
  8025bd:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8025c4:	7f 00 00 
  8025c7:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8025cb:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8025cc:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8025d3:	7f 00 00 
  8025d6:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8025da:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8025db:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8025e2:	7f 00 00 
  8025e5:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8025e9:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8025ea:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8025f1:	7f 00 00 
  8025f4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8025f8:	c3                   	ret

00000000008025f9 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8025f9:	f3 0f 1e fa          	endbr64
  8025fd:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802600:	48 89 f9             	mov    %rdi,%rcx
  802603:	48 c1 e9 27          	shr    $0x27,%rcx
  802607:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  80260e:	7f 00 00 
  802611:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802615:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  80261c:	f6 c1 01             	test   $0x1,%cl
  80261f:	0f 84 b2 00 00 00    	je     8026d7 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802625:	48 89 f9             	mov    %rdi,%rcx
  802628:	48 c1 e9 1e          	shr    $0x1e,%rcx
  80262c:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802633:	7f 00 00 
  802636:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80263a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802641:	40 f6 c6 01          	test   $0x1,%sil
  802645:	0f 84 8c 00 00 00    	je     8026d7 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  80264b:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802652:	7f 00 00 
  802655:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802659:	a8 80                	test   $0x80,%al
  80265b:	75 7b                	jne    8026d8 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  80265d:	48 89 f9             	mov    %rdi,%rcx
  802660:	48 c1 e9 15          	shr    $0x15,%rcx
  802664:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80266b:	7f 00 00 
  80266e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802672:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802679:	40 f6 c6 01          	test   $0x1,%sil
  80267d:	74 58                	je     8026d7 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  80267f:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802686:	7f 00 00 
  802689:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80268d:	a8 80                	test   $0x80,%al
  80268f:	75 6c                	jne    8026fd <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802691:	48 89 f9             	mov    %rdi,%rcx
  802694:	48 c1 e9 0c          	shr    $0xc,%rcx
  802698:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80269f:	7f 00 00 
  8026a2:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8026a6:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  8026ad:	40 f6 c6 01          	test   $0x1,%sil
  8026b1:	74 24                	je     8026d7 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  8026b3:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8026ba:	7f 00 00 
  8026bd:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8026c1:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8026c8:	ff ff 7f 
  8026cb:	48 21 c8             	and    %rcx,%rax
  8026ce:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8026d4:	48 09 d0             	or     %rdx,%rax
}
  8026d7:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8026d8:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8026df:	7f 00 00 
  8026e2:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8026e6:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8026ed:	ff ff 7f 
  8026f0:	48 21 c8             	and    %rcx,%rax
  8026f3:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8026f9:	48 01 d0             	add    %rdx,%rax
  8026fc:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8026fd:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802704:	7f 00 00 
  802707:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80270b:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802712:	ff ff 7f 
  802715:	48 21 c8             	and    %rcx,%rax
  802718:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  80271e:	48 01 d0             	add    %rdx,%rax
  802721:	c3                   	ret

0000000000802722 <get_prot>:

int
get_prot(void *va) {
  802722:	f3 0f 1e fa          	endbr64
  802726:	55                   	push   %rbp
  802727:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80272a:	48 b8 41 25 80 00 00 	movabs $0x802541,%rax
  802731:	00 00 00 
  802734:	ff d0                	call   *%rax
  802736:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802739:	83 e0 01             	and    $0x1,%eax
  80273c:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80273f:	89 d1                	mov    %edx,%ecx
  802741:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802747:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802749:	89 c1                	mov    %eax,%ecx
  80274b:	83 c9 02             	or     $0x2,%ecx
  80274e:	f6 c2 02             	test   $0x2,%dl
  802751:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802754:	89 c1                	mov    %eax,%ecx
  802756:	83 c9 01             	or     $0x1,%ecx
  802759:	48 85 d2             	test   %rdx,%rdx
  80275c:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80275f:	89 c1                	mov    %eax,%ecx
  802761:	83 c9 40             	or     $0x40,%ecx
  802764:	f6 c6 04             	test   $0x4,%dh
  802767:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80276a:	5d                   	pop    %rbp
  80276b:	c3                   	ret

000000000080276c <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80276c:	f3 0f 1e fa          	endbr64
  802770:	55                   	push   %rbp
  802771:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802774:	48 b8 41 25 80 00 00 	movabs $0x802541,%rax
  80277b:	00 00 00 
  80277e:	ff d0                	call   *%rax
    return pte & PTE_D;
  802780:	48 c1 e8 06          	shr    $0x6,%rax
  802784:	83 e0 01             	and    $0x1,%eax
}
  802787:	5d                   	pop    %rbp
  802788:	c3                   	ret

0000000000802789 <is_page_present>:

bool
is_page_present(void *va) {
  802789:	f3 0f 1e fa          	endbr64
  80278d:	55                   	push   %rbp
  80278e:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802791:	48 b8 41 25 80 00 00 	movabs $0x802541,%rax
  802798:	00 00 00 
  80279b:	ff d0                	call   *%rax
  80279d:	83 e0 01             	and    $0x1,%eax
}
  8027a0:	5d                   	pop    %rbp
  8027a1:	c3                   	ret

00000000008027a2 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8027a2:	f3 0f 1e fa          	endbr64
  8027a6:	55                   	push   %rbp
  8027a7:	48 89 e5             	mov    %rsp,%rbp
  8027aa:	41 57                	push   %r15
  8027ac:	41 56                	push   %r14
  8027ae:	41 55                	push   %r13
  8027b0:	41 54                	push   %r12
  8027b2:	53                   	push   %rbx
  8027b3:	48 83 ec 18          	sub    $0x18,%rsp
  8027b7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8027bb:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8027bf:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8027c4:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8027cb:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8027ce:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8027d5:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8027d8:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8027df:	00 00 00 
  8027e2:	eb 73                	jmp    802857 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8027e4:	48 89 d8             	mov    %rbx,%rax
  8027e7:	48 c1 e8 15          	shr    $0x15,%rax
  8027eb:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8027f2:	7f 00 00 
  8027f5:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8027f9:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8027ff:	f6 c2 01             	test   $0x1,%dl
  802802:	74 4b                	je     80284f <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802804:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802808:	f6 c2 80             	test   $0x80,%dl
  80280b:	74 11                	je     80281e <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  80280d:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802811:	f6 c4 04             	test   $0x4,%ah
  802814:	74 39                	je     80284f <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802816:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  80281c:	eb 20                	jmp    80283e <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80281e:	48 89 da             	mov    %rbx,%rdx
  802821:	48 c1 ea 0c          	shr    $0xc,%rdx
  802825:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80282c:	7f 00 00 
  80282f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802833:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802839:	f6 c4 04             	test   $0x4,%ah
  80283c:	74 11                	je     80284f <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  80283e:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802842:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802846:	48 89 df             	mov    %rbx,%rdi
  802849:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80284d:	ff d0                	call   *%rax
    next:
        va += size;
  80284f:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802852:	49 39 df             	cmp    %rbx,%r15
  802855:	72 3e                	jb     802895 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802857:	49 8b 06             	mov    (%r14),%rax
  80285a:	a8 01                	test   $0x1,%al
  80285c:	74 37                	je     802895 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80285e:	48 89 d8             	mov    %rbx,%rax
  802861:	48 c1 e8 1e          	shr    $0x1e,%rax
  802865:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  80286a:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802870:	f6 c2 01             	test   $0x1,%dl
  802873:	74 da                	je     80284f <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802875:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  80287a:	f6 c2 80             	test   $0x80,%dl
  80287d:	0f 84 61 ff ff ff    	je     8027e4 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802883:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802888:	f6 c4 04             	test   $0x4,%ah
  80288b:	74 c2                	je     80284f <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  80288d:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802893:	eb a9                	jmp    80283e <foreach_shared_region+0x9c>
    }
    return res;
}
  802895:	b8 00 00 00 00       	mov    $0x0,%eax
  80289a:	48 83 c4 18          	add    $0x18,%rsp
  80289e:	5b                   	pop    %rbx
  80289f:	41 5c                	pop    %r12
  8028a1:	41 5d                	pop    %r13
  8028a3:	41 5e                	pop    %r14
  8028a5:	41 5f                	pop    %r15
  8028a7:	5d                   	pop    %rbp
  8028a8:	c3                   	ret

00000000008028a9 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  8028a9:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  8028ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b2:	c3                   	ret

00000000008028b3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8028b3:	f3 0f 1e fa          	endbr64
  8028b7:	55                   	push   %rbp
  8028b8:	48 89 e5             	mov    %rsp,%rbp
  8028bb:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8028be:	48 be 77 33 80 00 00 	movabs $0x803377,%rsi
  8028c5:	00 00 00 
  8028c8:	48 b8 c4 0b 80 00 00 	movabs $0x800bc4,%rax
  8028cf:	00 00 00 
  8028d2:	ff d0                	call   *%rax
    return 0;
}
  8028d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d9:	5d                   	pop    %rbp
  8028da:	c3                   	ret

00000000008028db <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8028db:	f3 0f 1e fa          	endbr64
  8028df:	55                   	push   %rbp
  8028e0:	48 89 e5             	mov    %rsp,%rbp
  8028e3:	41 57                	push   %r15
  8028e5:	41 56                	push   %r14
  8028e7:	41 55                	push   %r13
  8028e9:	41 54                	push   %r12
  8028eb:	53                   	push   %rbx
  8028ec:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8028f3:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8028fa:	48 85 d2             	test   %rdx,%rdx
  8028fd:	74 7a                	je     802979 <devcons_write+0x9e>
  8028ff:	49 89 d6             	mov    %rdx,%r14
  802902:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802908:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  80290d:	49 bf df 0d 80 00 00 	movabs $0x800ddf,%r15
  802914:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802917:	4c 89 f3             	mov    %r14,%rbx
  80291a:	48 29 f3             	sub    %rsi,%rbx
  80291d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802922:	48 39 c3             	cmp    %rax,%rbx
  802925:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802929:	4c 63 eb             	movslq %ebx,%r13
  80292c:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802933:	48 01 c6             	add    %rax,%rsi
  802936:	4c 89 ea             	mov    %r13,%rdx
  802939:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802940:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802943:	4c 89 ee             	mov    %r13,%rsi
  802946:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  80294d:	48 b8 24 10 80 00 00 	movabs $0x801024,%rax
  802954:	00 00 00 
  802957:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802959:	41 01 dc             	add    %ebx,%r12d
  80295c:	49 63 f4             	movslq %r12d,%rsi
  80295f:	4c 39 f6             	cmp    %r14,%rsi
  802962:	72 b3                	jb     802917 <devcons_write+0x3c>
    return res;
  802964:	49 63 c4             	movslq %r12d,%rax
}
  802967:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80296e:	5b                   	pop    %rbx
  80296f:	41 5c                	pop    %r12
  802971:	41 5d                	pop    %r13
  802973:	41 5e                	pop    %r14
  802975:	41 5f                	pop    %r15
  802977:	5d                   	pop    %rbp
  802978:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802979:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80297f:	eb e3                	jmp    802964 <devcons_write+0x89>

0000000000802981 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802981:	f3 0f 1e fa          	endbr64
  802985:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802988:	ba 00 00 00 00       	mov    $0x0,%edx
  80298d:	48 85 c0             	test   %rax,%rax
  802990:	74 55                	je     8029e7 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802992:	55                   	push   %rbp
  802993:	48 89 e5             	mov    %rsp,%rbp
  802996:	41 55                	push   %r13
  802998:	41 54                	push   %r12
  80299a:	53                   	push   %rbx
  80299b:	48 83 ec 08          	sub    $0x8,%rsp
  80299f:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  8029a2:	48 bb 55 10 80 00 00 	movabs $0x801055,%rbx
  8029a9:	00 00 00 
  8029ac:	49 bc 2e 11 80 00 00 	movabs $0x80112e,%r12
  8029b3:	00 00 00 
  8029b6:	eb 03                	jmp    8029bb <devcons_read+0x3a>
  8029b8:	41 ff d4             	call   *%r12
  8029bb:	ff d3                	call   *%rbx
  8029bd:	85 c0                	test   %eax,%eax
  8029bf:	74 f7                	je     8029b8 <devcons_read+0x37>
    if (c < 0) return c;
  8029c1:	48 63 d0             	movslq %eax,%rdx
  8029c4:	78 13                	js     8029d9 <devcons_read+0x58>
    if (c == 0x04) return 0;
  8029c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8029cb:	83 f8 04             	cmp    $0x4,%eax
  8029ce:	74 09                	je     8029d9 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  8029d0:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8029d4:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8029d9:	48 89 d0             	mov    %rdx,%rax
  8029dc:	48 83 c4 08          	add    $0x8,%rsp
  8029e0:	5b                   	pop    %rbx
  8029e1:	41 5c                	pop    %r12
  8029e3:	41 5d                	pop    %r13
  8029e5:	5d                   	pop    %rbp
  8029e6:	c3                   	ret
  8029e7:	48 89 d0             	mov    %rdx,%rax
  8029ea:	c3                   	ret

00000000008029eb <cputchar>:
cputchar(int ch) {
  8029eb:	f3 0f 1e fa          	endbr64
  8029ef:	55                   	push   %rbp
  8029f0:	48 89 e5             	mov    %rsp,%rbp
  8029f3:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8029f7:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8029fb:	be 01 00 00 00       	mov    $0x1,%esi
  802a00:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802a04:	48 b8 24 10 80 00 00 	movabs $0x801024,%rax
  802a0b:	00 00 00 
  802a0e:	ff d0                	call   *%rax
}
  802a10:	c9                   	leave
  802a11:	c3                   	ret

0000000000802a12 <getchar>:
getchar(void) {
  802a12:	f3 0f 1e fa          	endbr64
  802a16:	55                   	push   %rbp
  802a17:	48 89 e5             	mov    %rsp,%rbp
  802a1a:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802a1e:	ba 01 00 00 00       	mov    $0x1,%edx
  802a23:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802a27:	bf 00 00 00 00       	mov    $0x0,%edi
  802a2c:	48 b8 22 19 80 00 00 	movabs $0x801922,%rax
  802a33:	00 00 00 
  802a36:	ff d0                	call   *%rax
  802a38:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802a3a:	85 c0                	test   %eax,%eax
  802a3c:	78 06                	js     802a44 <getchar+0x32>
  802a3e:	74 08                	je     802a48 <getchar+0x36>
  802a40:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802a44:	89 d0                	mov    %edx,%eax
  802a46:	c9                   	leave
  802a47:	c3                   	ret
    return res < 0 ? res : res ? c :
  802a48:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802a4d:	eb f5                	jmp    802a44 <getchar+0x32>

0000000000802a4f <iscons>:
iscons(int fdnum) {
  802a4f:	f3 0f 1e fa          	endbr64
  802a53:	55                   	push   %rbp
  802a54:	48 89 e5             	mov    %rsp,%rbp
  802a57:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802a5b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802a5f:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  802a66:	00 00 00 
  802a69:	ff d0                	call   *%rax
    if (res < 0) return res;
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	78 18                	js     802a87 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802a6f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a73:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802a7a:	00 00 00 
  802a7d:	8b 00                	mov    (%rax),%eax
  802a7f:	39 02                	cmp    %eax,(%rdx)
  802a81:	0f 94 c0             	sete   %al
  802a84:	0f b6 c0             	movzbl %al,%eax
}
  802a87:	c9                   	leave
  802a88:	c3                   	ret

0000000000802a89 <opencons>:
opencons(void) {
  802a89:	f3 0f 1e fa          	endbr64
  802a8d:	55                   	push   %rbp
  802a8e:	48 89 e5             	mov    %rsp,%rbp
  802a91:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802a95:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802a99:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  802aa0:	00 00 00 
  802aa3:	ff d0                	call   *%rax
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	78 49                	js     802af2 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802aa9:	b9 46 00 00 00       	mov    $0x46,%ecx
  802aae:	ba 00 10 00 00       	mov    $0x1000,%edx
  802ab3:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802ab7:	bf 00 00 00 00       	mov    $0x0,%edi
  802abc:	48 b8 c9 11 80 00 00 	movabs $0x8011c9,%rax
  802ac3:	00 00 00 
  802ac6:	ff d0                	call   *%rax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	78 26                	js     802af2 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802acc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ad0:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802ad7:	00 00 
  802ad9:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802adb:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802adf:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802ae6:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  802aed:	00 00 00 
  802af0:	ff d0                	call   *%rax
}
  802af2:	c9                   	leave
  802af3:	c3                   	ret

0000000000802af4 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802af4:	f3 0f 1e fa          	endbr64
  802af8:	55                   	push   %rbp
  802af9:	48 89 e5             	mov    %rsp,%rbp
  802afc:	41 56                	push   %r14
  802afe:	41 55                	push   %r13
  802b00:	41 54                	push   %r12
  802b02:	53                   	push   %rbx
  802b03:	48 83 ec 50          	sub    $0x50,%rsp
  802b07:	49 89 fc             	mov    %rdi,%r12
  802b0a:	41 89 f5             	mov    %esi,%r13d
  802b0d:	48 89 d3             	mov    %rdx,%rbx
  802b10:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802b14:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802b18:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802b1c:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802b23:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b27:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802b2b:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802b2f:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802b33:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802b3a:	00 00 00 
  802b3d:	4c 8b 30             	mov    (%rax),%r14
  802b40:	48 b8 f9 10 80 00 00 	movabs $0x8010f9,%rax
  802b47:	00 00 00 
  802b4a:	ff d0                	call   *%rax
  802b4c:	89 c6                	mov    %eax,%esi
  802b4e:	45 89 e8             	mov    %r13d,%r8d
  802b51:	4c 89 e1             	mov    %r12,%rcx
  802b54:	4c 89 f2             	mov    %r14,%rdx
  802b57:	48 bf 20 31 80 00 00 	movabs $0x803120,%rdi
  802b5e:	00 00 00 
  802b61:	b8 00 00 00 00       	mov    $0x0,%eax
  802b66:	49 bc 7b 02 80 00 00 	movabs $0x80027b,%r12
  802b6d:	00 00 00 
  802b70:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802b73:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802b77:	48 89 df             	mov    %rbx,%rdi
  802b7a:	48 b8 13 02 80 00 00 	movabs $0x800213,%rax
  802b81:	00 00 00 
  802b84:	ff d0                	call   *%rax
    cprintf("\n");
  802b86:	48 bf 04 33 80 00 00 	movabs $0x803304,%rdi
  802b8d:	00 00 00 
  802b90:	b8 00 00 00 00       	mov    $0x0,%eax
  802b95:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802b98:	cc                   	int3
  802b99:	eb fd                	jmp    802b98 <_panic+0xa4>

0000000000802b9b <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802b9b:	f3 0f 1e fa          	endbr64
  802b9f:	55                   	push   %rbp
  802ba0:	48 89 e5             	mov    %rsp,%rbp
  802ba3:	41 54                	push   %r12
  802ba5:	53                   	push   %rbx
  802ba6:	48 89 fb             	mov    %rdi,%rbx
  802ba9:	48 89 f7             	mov    %rsi,%rdi
  802bac:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802baf:	48 85 f6             	test   %rsi,%rsi
  802bb2:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bb9:	00 00 00 
  802bbc:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802bc0:	be 00 10 00 00       	mov    $0x1000,%esi
  802bc5:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  802bcc:	00 00 00 
  802bcf:	ff d0                	call   *%rax
    if (res < 0) {
  802bd1:	85 c0                	test   %eax,%eax
  802bd3:	78 45                	js     802c1a <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802bd5:	48 85 db             	test   %rbx,%rbx
  802bd8:	74 12                	je     802bec <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802bda:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802be1:	00 00 00 
  802be4:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802bea:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802bec:	4d 85 e4             	test   %r12,%r12
  802bef:	74 14                	je     802c05 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802bf1:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802bf8:	00 00 00 
  802bfb:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802c01:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802c05:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802c0c:	00 00 00 
  802c0f:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802c15:	5b                   	pop    %rbx
  802c16:	41 5c                	pop    %r12
  802c18:	5d                   	pop    %rbp
  802c19:	c3                   	ret
        if (from_env_store != NULL) {
  802c1a:	48 85 db             	test   %rbx,%rbx
  802c1d:	74 06                	je     802c25 <ipc_recv+0x8a>
            *from_env_store = 0;
  802c1f:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802c25:	4d 85 e4             	test   %r12,%r12
  802c28:	74 eb                	je     802c15 <ipc_recv+0x7a>
            *perm_store = 0;
  802c2a:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802c31:	00 
  802c32:	eb e1                	jmp    802c15 <ipc_recv+0x7a>

0000000000802c34 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802c34:	f3 0f 1e fa          	endbr64
  802c38:	55                   	push   %rbp
  802c39:	48 89 e5             	mov    %rsp,%rbp
  802c3c:	41 57                	push   %r15
  802c3e:	41 56                	push   %r14
  802c40:	41 55                	push   %r13
  802c42:	41 54                	push   %r12
  802c44:	53                   	push   %rbx
  802c45:	48 83 ec 18          	sub    $0x18,%rsp
  802c49:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802c4c:	48 89 d3             	mov    %rdx,%rbx
  802c4f:	49 89 cc             	mov    %rcx,%r12
  802c52:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802c55:	48 85 d2             	test   %rdx,%rdx
  802c58:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802c5f:	00 00 00 
  802c62:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c66:	89 f0                	mov    %esi,%eax
  802c68:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802c6c:	48 89 da             	mov    %rbx,%rdx
  802c6f:	48 89 c6             	mov    %rax,%rsi
  802c72:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  802c79:	00 00 00 
  802c7c:	ff d0                	call   *%rax
    while (res < 0) {
  802c7e:	85 c0                	test   %eax,%eax
  802c80:	79 65                	jns    802ce7 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c82:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c85:	75 33                	jne    802cba <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802c87:	49 bf 2e 11 80 00 00 	movabs $0x80112e,%r15
  802c8e:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c91:	49 be bb 14 80 00 00 	movabs $0x8014bb,%r14
  802c98:	00 00 00 
        sys_yield();
  802c9b:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c9e:	45 89 e8             	mov    %r13d,%r8d
  802ca1:	4c 89 e1             	mov    %r12,%rcx
  802ca4:	48 89 da             	mov    %rbx,%rdx
  802ca7:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802cab:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802cae:	41 ff d6             	call   *%r14
    while (res < 0) {
  802cb1:	85 c0                	test   %eax,%eax
  802cb3:	79 32                	jns    802ce7 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802cb5:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802cb8:	74 e1                	je     802c9b <ipc_send+0x67>
            panic("Error: %i\n", res);
  802cba:	89 c1                	mov    %eax,%ecx
  802cbc:	48 ba 83 33 80 00 00 	movabs $0x803383,%rdx
  802cc3:	00 00 00 
  802cc6:	be 42 00 00 00       	mov    $0x42,%esi
  802ccb:	48 bf 8e 33 80 00 00 	movabs $0x80338e,%rdi
  802cd2:	00 00 00 
  802cd5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cda:	49 b8 f4 2a 80 00 00 	movabs $0x802af4,%r8
  802ce1:	00 00 00 
  802ce4:	41 ff d0             	call   *%r8
    }
}
  802ce7:	48 83 c4 18          	add    $0x18,%rsp
  802ceb:	5b                   	pop    %rbx
  802cec:	41 5c                	pop    %r12
  802cee:	41 5d                	pop    %r13
  802cf0:	41 5e                	pop    %r14
  802cf2:	41 5f                	pop    %r15
  802cf4:	5d                   	pop    %rbp
  802cf5:	c3                   	ret

0000000000802cf6 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802cf6:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802cfa:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802cff:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802d06:	00 00 00 
  802d09:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802d0d:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802d11:	48 c1 e2 04          	shl    $0x4,%rdx
  802d15:	48 01 ca             	add    %rcx,%rdx
  802d18:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802d1e:	39 fa                	cmp    %edi,%edx
  802d20:	74 12                	je     802d34 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802d22:	48 83 c0 01          	add    $0x1,%rax
  802d26:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802d2c:	75 db                	jne    802d09 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802d2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d33:	c3                   	ret
            return envs[i].env_id;
  802d34:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802d38:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802d3c:	48 c1 e2 04          	shl    $0x4,%rdx
  802d40:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802d47:	00 00 00 
  802d4a:	48 01 d0             	add    %rdx,%rax
  802d4d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d53:	c3                   	ret

0000000000802d54 <__text_end>:
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
