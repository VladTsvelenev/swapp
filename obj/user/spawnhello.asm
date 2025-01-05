
obj/user/spawnhello:     file format elf64-x86-64


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
  80001e:	e8 8b 00 00 00       	call   8000ae <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
    int r;
    cprintf("i am parent environment %08x\n", thisenv->env_id);
  80002d:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  800034:	00 00 00 
  800037:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80003d:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  800044:	00 00 00 
  800047:	b8 00 00 00 00       	mov    $0x0,%eax
  80004c:	48 ba e3 02 80 00 00 	movabs $0x8002e3,%rdx
  800053:	00 00 00 
  800056:	ff d2                	call   *%rdx
    if ((r = spawnl("hello", "hello", 0)) < 0)
  800058:	ba 00 00 00 00       	mov    $0x0,%edx
  80005d:	48 bf 1e 40 80 00 00 	movabs $0x80401e,%rdi
  800064:	00 00 00 
  800067:	48 89 fe             	mov    %rdi,%rsi
  80006a:	b8 00 00 00 00       	mov    $0x0,%eax
  80006f:	48 b9 e1 27 80 00 00 	movabs $0x8027e1,%rcx
  800076:	00 00 00 
  800079:	ff d1                	call   *%rcx
  80007b:	85 c0                	test   %eax,%eax
  80007d:	78 02                	js     800081 <umain+0x5c>
        panic("spawn(hello) failed: %i", r);
}
  80007f:	5d                   	pop    %rbp
  800080:	c3                   	ret
        panic("spawn(hello) failed: %i", r);
  800081:	89 c1                	mov    %eax,%ecx
  800083:	48 ba 24 40 80 00 00 	movabs $0x804024,%rdx
  80008a:	00 00 00 
  80008d:	be 08 00 00 00       	mov    $0x8,%esi
  800092:	48 bf 3c 40 80 00 00 	movabs $0x80403c,%rdi
  800099:	00 00 00 
  80009c:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a1:	49 b8 87 01 80 00 00 	movabs $0x800187,%r8
  8000a8:	00 00 00 
  8000ab:	41 ff d0             	call   *%r8

00000000008000ae <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8000ae:	f3 0f 1e fa          	endbr64
  8000b2:	55                   	push   %rbp
  8000b3:	48 89 e5             	mov    %rsp,%rbp
  8000b6:	41 56                	push   %r14
  8000b8:	41 55                	push   %r13
  8000ba:	41 54                	push   %r12
  8000bc:	53                   	push   %rbx
  8000bd:	41 89 fd             	mov    %edi,%r13d
  8000c0:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8000c3:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  8000ca:	00 00 00 
  8000cd:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  8000d4:	00 00 00 
  8000d7:	48 39 c2             	cmp    %rax,%rdx
  8000da:	73 17                	jae    8000f3 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8000dc:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8000df:	49 89 c4             	mov    %rax,%r12
  8000e2:	48 83 c3 08          	add    $0x8,%rbx
  8000e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000eb:	ff 53 f8             	call   *-0x8(%rbx)
  8000ee:	4c 39 e3             	cmp    %r12,%rbx
  8000f1:	72 ef                	jb     8000e2 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8000f3:	48 b8 61 11 80 00 00 	movabs $0x801161,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	call   *%rax
  8000ff:	25 ff 03 00 00       	and    $0x3ff,%eax
  800104:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800108:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80010c:	48 c1 e0 04          	shl    $0x4,%rax
  800110:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800117:	00 00 00 
  80011a:	48 01 d0             	add    %rdx,%rax
  80011d:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  800124:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800127:	45 85 ed             	test   %r13d,%r13d
  80012a:	7e 0d                	jle    800139 <libmain+0x8b>
  80012c:	49 8b 06             	mov    (%r14),%rax
  80012f:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800136:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800139:	4c 89 f6             	mov    %r14,%rsi
  80013c:	44 89 ef             	mov    %r13d,%edi
  80013f:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800146:	00 00 00 
  800149:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80014b:	48 b8 60 01 80 00 00 	movabs $0x800160,%rax
  800152:	00 00 00 
  800155:	ff d0                	call   *%rax
#endif
}
  800157:	5b                   	pop    %rbx
  800158:	41 5c                	pop    %r12
  80015a:	41 5d                	pop    %r13
  80015c:	41 5e                	pop    %r14
  80015e:	5d                   	pop    %rbp
  80015f:	c3                   	ret

0000000000800160 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800160:	f3 0f 1e fa          	endbr64
  800164:	55                   	push   %rbp
  800165:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800168:	48 b8 37 18 80 00 00 	movabs $0x801837,%rax
  80016f:	00 00 00 
  800172:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800174:	bf 00 00 00 00       	mov    $0x0,%edi
  800179:	48 b8 f2 10 80 00 00 	movabs $0x8010f2,%rax
  800180:	00 00 00 
  800183:	ff d0                	call   *%rax
}
  800185:	5d                   	pop    %rbp
  800186:	c3                   	ret

0000000000800187 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800187:	f3 0f 1e fa          	endbr64
  80018b:	55                   	push   %rbp
  80018c:	48 89 e5             	mov    %rsp,%rbp
  80018f:	41 56                	push   %r14
  800191:	41 55                	push   %r13
  800193:	41 54                	push   %r12
  800195:	53                   	push   %rbx
  800196:	48 83 ec 50          	sub    $0x50,%rsp
  80019a:	49 89 fc             	mov    %rdi,%r12
  80019d:	41 89 f5             	mov    %esi,%r13d
  8001a0:	48 89 d3             	mov    %rdx,%rbx
  8001a3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8001a7:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8001ab:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8001af:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8001b6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8001ba:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8001be:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8001c2:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8001c6:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001cd:	00 00 00 
  8001d0:	4c 8b 30             	mov    (%rax),%r14
  8001d3:	48 b8 61 11 80 00 00 	movabs $0x801161,%rax
  8001da:	00 00 00 
  8001dd:	ff d0                	call   *%rax
  8001df:	89 c6                	mov    %eax,%esi
  8001e1:	45 89 e8             	mov    %r13d,%r8d
  8001e4:	4c 89 e1             	mov    %r12,%rcx
  8001e7:	4c 89 f2             	mov    %r14,%rdx
  8001ea:	48 bf 18 43 80 00 00 	movabs $0x804318,%rdi
  8001f1:	00 00 00 
  8001f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f9:	49 bc e3 02 80 00 00 	movabs $0x8002e3,%r12
  800200:	00 00 00 
  800203:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800206:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  80020a:	48 89 df             	mov    %rbx,%rdi
  80020d:	48 b8 7b 02 80 00 00 	movabs $0x80027b,%rax
  800214:	00 00 00 
  800217:	ff d0                	call   *%rax
    cprintf("\n");
  800219:	48 bf 0f 42 80 00 00 	movabs $0x80420f,%rdi
  800220:	00 00 00 
  800223:	b8 00 00 00 00       	mov    $0x0,%eax
  800228:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80022b:	cc                   	int3
  80022c:	eb fd                	jmp    80022b <_panic+0xa4>

000000000080022e <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80022e:	f3 0f 1e fa          	endbr64
  800232:	55                   	push   %rbp
  800233:	48 89 e5             	mov    %rsp,%rbp
  800236:	53                   	push   %rbx
  800237:	48 83 ec 08          	sub    $0x8,%rsp
  80023b:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80023e:	8b 06                	mov    (%rsi),%eax
  800240:	8d 50 01             	lea    0x1(%rax),%edx
  800243:	89 16                	mov    %edx,(%rsi)
  800245:	48 98                	cltq
  800247:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80024c:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800252:	74 0a                	je     80025e <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800254:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800258:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80025c:	c9                   	leave
  80025d:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80025e:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800262:	be ff 00 00 00       	mov    $0xff,%esi
  800267:	48 b8 8c 10 80 00 00 	movabs $0x80108c,%rax
  80026e:	00 00 00 
  800271:	ff d0                	call   *%rax
        state->offset = 0;
  800273:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800279:	eb d9                	jmp    800254 <putch+0x26>

000000000080027b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80027b:	f3 0f 1e fa          	endbr64
  80027f:	55                   	push   %rbp
  800280:	48 89 e5             	mov    %rsp,%rbp
  800283:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80028a:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80028d:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800294:	b9 21 00 00 00       	mov    $0x21,%ecx
  800299:	b8 00 00 00 00       	mov    $0x0,%eax
  80029e:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8002a1:	48 89 f1             	mov    %rsi,%rcx
  8002a4:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8002ab:	48 bf 2e 02 80 00 00 	movabs $0x80022e,%rdi
  8002b2:	00 00 00 
  8002b5:	48 b8 43 04 80 00 00 	movabs $0x800443,%rax
  8002bc:	00 00 00 
  8002bf:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8002c1:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8002c8:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8002cf:	48 b8 8c 10 80 00 00 	movabs $0x80108c,%rax
  8002d6:	00 00 00 
  8002d9:	ff d0                	call   *%rax

    return state.count;
}
  8002db:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8002e1:	c9                   	leave
  8002e2:	c3                   	ret

00000000008002e3 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8002e3:	f3 0f 1e fa          	endbr64
  8002e7:	55                   	push   %rbp
  8002e8:	48 89 e5             	mov    %rsp,%rbp
  8002eb:	48 83 ec 50          	sub    $0x50,%rsp
  8002ef:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8002f3:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8002f7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8002fb:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8002ff:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800303:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80030a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80030e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800312:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800316:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80031a:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80031e:	48 b8 7b 02 80 00 00 	movabs $0x80027b,%rax
  800325:	00 00 00 
  800328:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80032a:	c9                   	leave
  80032b:	c3                   	ret

000000000080032c <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80032c:	f3 0f 1e fa          	endbr64
  800330:	55                   	push   %rbp
  800331:	48 89 e5             	mov    %rsp,%rbp
  800334:	41 57                	push   %r15
  800336:	41 56                	push   %r14
  800338:	41 55                	push   %r13
  80033a:	41 54                	push   %r12
  80033c:	53                   	push   %rbx
  80033d:	48 83 ec 18          	sub    $0x18,%rsp
  800341:	49 89 fc             	mov    %rdi,%r12
  800344:	49 89 f5             	mov    %rsi,%r13
  800347:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80034b:	8b 45 10             	mov    0x10(%rbp),%eax
  80034e:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800351:	41 89 cf             	mov    %ecx,%r15d
  800354:	4c 39 fa             	cmp    %r15,%rdx
  800357:	73 5b                	jae    8003b4 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800359:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80035d:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800361:	85 db                	test   %ebx,%ebx
  800363:	7e 0e                	jle    800373 <print_num+0x47>
            putch(padc, put_arg);
  800365:	4c 89 ee             	mov    %r13,%rsi
  800368:	44 89 f7             	mov    %r14d,%edi
  80036b:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80036e:	83 eb 01             	sub    $0x1,%ebx
  800371:	75 f2                	jne    800365 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800373:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800377:	48 b9 69 40 80 00 00 	movabs $0x804069,%rcx
  80037e:	00 00 00 
  800381:	48 b8 58 40 80 00 00 	movabs $0x804058,%rax
  800388:	00 00 00 
  80038b:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80038f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800393:	ba 00 00 00 00       	mov    $0x0,%edx
  800398:	49 f7 f7             	div    %r15
  80039b:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80039f:	4c 89 ee             	mov    %r13,%rsi
  8003a2:	41 ff d4             	call   *%r12
}
  8003a5:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8003a9:	5b                   	pop    %rbx
  8003aa:	41 5c                	pop    %r12
  8003ac:	41 5d                	pop    %r13
  8003ae:	41 5e                	pop    %r14
  8003b0:	41 5f                	pop    %r15
  8003b2:	5d                   	pop    %rbp
  8003b3:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8003b4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8003b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bd:	49 f7 f7             	div    %r15
  8003c0:	48 83 ec 08          	sub    $0x8,%rsp
  8003c4:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8003c8:	52                   	push   %rdx
  8003c9:	45 0f be c9          	movsbl %r9b,%r9d
  8003cd:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8003d1:	48 89 c2             	mov    %rax,%rdx
  8003d4:	48 b8 2c 03 80 00 00 	movabs $0x80032c,%rax
  8003db:	00 00 00 
  8003de:	ff d0                	call   *%rax
  8003e0:	48 83 c4 10          	add    $0x10,%rsp
  8003e4:	eb 8d                	jmp    800373 <print_num+0x47>

00000000008003e6 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8003e6:	f3 0f 1e fa          	endbr64
    state->count++;
  8003ea:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8003ee:	48 8b 06             	mov    (%rsi),%rax
  8003f1:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8003f5:	73 0a                	jae    800401 <sprintputch+0x1b>
        *state->start++ = ch;
  8003f7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8003fb:	48 89 16             	mov    %rdx,(%rsi)
  8003fe:	40 88 38             	mov    %dil,(%rax)
    }
}
  800401:	c3                   	ret

0000000000800402 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800402:	f3 0f 1e fa          	endbr64
  800406:	55                   	push   %rbp
  800407:	48 89 e5             	mov    %rsp,%rbp
  80040a:	48 83 ec 50          	sub    $0x50,%rsp
  80040e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800412:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800416:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80041a:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800421:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800425:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800429:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80042d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800431:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800435:	48 b8 43 04 80 00 00 	movabs $0x800443,%rax
  80043c:	00 00 00 
  80043f:	ff d0                	call   *%rax
}
  800441:	c9                   	leave
  800442:	c3                   	ret

0000000000800443 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800443:	f3 0f 1e fa          	endbr64
  800447:	55                   	push   %rbp
  800448:	48 89 e5             	mov    %rsp,%rbp
  80044b:	41 57                	push   %r15
  80044d:	41 56                	push   %r14
  80044f:	41 55                	push   %r13
  800451:	41 54                	push   %r12
  800453:	53                   	push   %rbx
  800454:	48 83 ec 38          	sub    $0x38,%rsp
  800458:	49 89 fe             	mov    %rdi,%r14
  80045b:	49 89 f5             	mov    %rsi,%r13
  80045e:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800461:	48 8b 01             	mov    (%rcx),%rax
  800464:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800468:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80046c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800470:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800474:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800478:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80047c:	0f b6 3b             	movzbl (%rbx),%edi
  80047f:	40 80 ff 25          	cmp    $0x25,%dil
  800483:	74 18                	je     80049d <vprintfmt+0x5a>
            if (!ch) return;
  800485:	40 84 ff             	test   %dil,%dil
  800488:	0f 84 b2 06 00 00    	je     800b40 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80048e:	40 0f b6 ff          	movzbl %dil,%edi
  800492:	4c 89 ee             	mov    %r13,%rsi
  800495:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800498:	4c 89 e3             	mov    %r12,%rbx
  80049b:	eb db                	jmp    800478 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  80049d:	be 00 00 00 00       	mov    $0x0,%esi
  8004a2:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8004a6:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8004ab:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8004b1:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8004b8:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8004bc:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8004c1:	41 0f b6 04 24       	movzbl (%r12),%eax
  8004c6:	88 45 a0             	mov    %al,-0x60(%rbp)
  8004c9:	83 e8 23             	sub    $0x23,%eax
  8004cc:	3c 57                	cmp    $0x57,%al
  8004ce:	0f 87 52 06 00 00    	ja     800b26 <vprintfmt+0x6e3>
  8004d4:	0f b6 c0             	movzbl %al,%eax
  8004d7:	48 b9 60 44 80 00 00 	movabs $0x804460,%rcx
  8004de:	00 00 00 
  8004e1:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8004e5:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8004e8:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8004ec:	eb ce                	jmp    8004bc <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8004ee:	49 89 dc             	mov    %rbx,%r12
  8004f1:	be 01 00 00 00       	mov    $0x1,%esi
  8004f6:	eb c4                	jmp    8004bc <vprintfmt+0x79>
            padc = ch;
  8004f8:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8004fc:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8004ff:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800502:	eb b8                	jmp    8004bc <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800504:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800507:	83 f8 2f             	cmp    $0x2f,%eax
  80050a:	77 24                	ja     800530 <vprintfmt+0xed>
  80050c:	89 c1                	mov    %eax,%ecx
  80050e:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800512:	83 c0 08             	add    $0x8,%eax
  800515:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800518:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  80051b:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  80051e:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800522:	79 98                	jns    8004bc <vprintfmt+0x79>
                width = precision;
  800524:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800528:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80052e:	eb 8c                	jmp    8004bc <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800530:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800534:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800538:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80053c:	eb da                	jmp    800518 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80053e:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800543:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800547:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80054d:	3c 39                	cmp    $0x39,%al
  80054f:	77 1c                	ja     80056d <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800551:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800555:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800559:	0f b6 c0             	movzbl %al,%eax
  80055c:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800561:	0f b6 03             	movzbl (%rbx),%eax
  800564:	3c 39                	cmp    $0x39,%al
  800566:	76 e9                	jbe    800551 <vprintfmt+0x10e>
        process_precision:
  800568:	49 89 dc             	mov    %rbx,%r12
  80056b:	eb b1                	jmp    80051e <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80056d:	49 89 dc             	mov    %rbx,%r12
  800570:	eb ac                	jmp    80051e <vprintfmt+0xdb>
            width = MAX(0, width);
  800572:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800575:	85 c9                	test   %ecx,%ecx
  800577:	b8 00 00 00 00       	mov    $0x0,%eax
  80057c:	0f 49 c1             	cmovns %ecx,%eax
  80057f:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800582:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800585:	e9 32 ff ff ff       	jmp    8004bc <vprintfmt+0x79>
            lflag++;
  80058a:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80058d:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800590:	e9 27 ff ff ff       	jmp    8004bc <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800595:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800598:	83 f8 2f             	cmp    $0x2f,%eax
  80059b:	77 19                	ja     8005b6 <vprintfmt+0x173>
  80059d:	89 c2                	mov    %eax,%edx
  80059f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8005a3:	83 c0 08             	add    $0x8,%eax
  8005a6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005a9:	8b 3a                	mov    (%rdx),%edi
  8005ab:	4c 89 ee             	mov    %r13,%rsi
  8005ae:	41 ff d6             	call   *%r14
            break;
  8005b1:	e9 c2 fe ff ff       	jmp    800478 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8005b6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005ba:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005be:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005c2:	eb e5                	jmp    8005a9 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8005c4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005c7:	83 f8 2f             	cmp    $0x2f,%eax
  8005ca:	77 5a                	ja     800626 <vprintfmt+0x1e3>
  8005cc:	89 c2                	mov    %eax,%edx
  8005ce:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8005d2:	83 c0 08             	add    $0x8,%eax
  8005d5:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8005d8:	8b 02                	mov    (%rdx),%eax
  8005da:	89 c1                	mov    %eax,%ecx
  8005dc:	f7 d9                	neg    %ecx
  8005de:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8005e1:	83 f9 13             	cmp    $0x13,%ecx
  8005e4:	7f 4e                	jg     800634 <vprintfmt+0x1f1>
  8005e6:	48 63 c1             	movslq %ecx,%rax
  8005e9:	48 ba 20 47 80 00 00 	movabs $0x804720,%rdx
  8005f0:	00 00 00 
  8005f3:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8005f7:	48 85 c0             	test   %rax,%rax
  8005fa:	74 38                	je     800634 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8005fc:	48 89 c1             	mov    %rax,%rcx
  8005ff:	48 ba 5d 42 80 00 00 	movabs $0x80425d,%rdx
  800606:	00 00 00 
  800609:	4c 89 ee             	mov    %r13,%rsi
  80060c:	4c 89 f7             	mov    %r14,%rdi
  80060f:	b8 00 00 00 00       	mov    $0x0,%eax
  800614:	49 b8 02 04 80 00 00 	movabs $0x800402,%r8
  80061b:	00 00 00 
  80061e:	41 ff d0             	call   *%r8
  800621:	e9 52 fe ff ff       	jmp    800478 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800626:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80062a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80062e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800632:	eb a4                	jmp    8005d8 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800634:	48 ba 81 40 80 00 00 	movabs $0x804081,%rdx
  80063b:	00 00 00 
  80063e:	4c 89 ee             	mov    %r13,%rsi
  800641:	4c 89 f7             	mov    %r14,%rdi
  800644:	b8 00 00 00 00       	mov    $0x0,%eax
  800649:	49 b8 02 04 80 00 00 	movabs $0x800402,%r8
  800650:	00 00 00 
  800653:	41 ff d0             	call   *%r8
  800656:	e9 1d fe ff ff       	jmp    800478 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80065b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80065e:	83 f8 2f             	cmp    $0x2f,%eax
  800661:	77 6c                	ja     8006cf <vprintfmt+0x28c>
  800663:	89 c2                	mov    %eax,%edx
  800665:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800669:	83 c0 08             	add    $0x8,%eax
  80066c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80066f:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800672:	48 85 d2             	test   %rdx,%rdx
  800675:	48 b8 7a 40 80 00 00 	movabs $0x80407a,%rax
  80067c:	00 00 00 
  80067f:	48 0f 45 c2          	cmovne %rdx,%rax
  800683:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800687:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80068b:	7e 06                	jle    800693 <vprintfmt+0x250>
  80068d:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800691:	75 4a                	jne    8006dd <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800693:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800697:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80069b:	0f b6 00             	movzbl (%rax),%eax
  80069e:	84 c0                	test   %al,%al
  8006a0:	0f 85 9a 00 00 00    	jne    800740 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8006a6:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006a9:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8006ad:	85 c0                	test   %eax,%eax
  8006af:	0f 8e c3 fd ff ff    	jle    800478 <vprintfmt+0x35>
  8006b5:	4c 89 ee             	mov    %r13,%rsi
  8006b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8006bd:	41 ff d6             	call   *%r14
  8006c0:	41 83 ec 01          	sub    $0x1,%r12d
  8006c4:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8006c8:	75 eb                	jne    8006b5 <vprintfmt+0x272>
  8006ca:	e9 a9 fd ff ff       	jmp    800478 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8006cf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006d3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006d7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006db:	eb 92                	jmp    80066f <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8006dd:	49 63 f7             	movslq %r15d,%rsi
  8006e0:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8006e4:	48 b8 06 0c 80 00 00 	movabs $0x800c06,%rax
  8006eb:	00 00 00 
  8006ee:	ff d0                	call   *%rax
  8006f0:	48 89 c2             	mov    %rax,%rdx
  8006f3:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006f6:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8006f8:	8d 70 ff             	lea    -0x1(%rax),%esi
  8006fb:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8006fe:	85 c0                	test   %eax,%eax
  800700:	7e 91                	jle    800693 <vprintfmt+0x250>
  800702:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800707:	4c 89 ee             	mov    %r13,%rsi
  80070a:	44 89 e7             	mov    %r12d,%edi
  80070d:	41 ff d6             	call   *%r14
  800710:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800714:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800717:	83 f8 ff             	cmp    $0xffffffff,%eax
  80071a:	75 eb                	jne    800707 <vprintfmt+0x2c4>
  80071c:	e9 72 ff ff ff       	jmp    800693 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800721:	0f b6 f8             	movzbl %al,%edi
  800724:	4c 89 ee             	mov    %r13,%rsi
  800727:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80072a:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80072e:	49 83 c4 01          	add    $0x1,%r12
  800732:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800738:	84 c0                	test   %al,%al
  80073a:	0f 84 66 ff ff ff    	je     8006a6 <vprintfmt+0x263>
  800740:	45 85 ff             	test   %r15d,%r15d
  800743:	78 0a                	js     80074f <vprintfmt+0x30c>
  800745:	41 83 ef 01          	sub    $0x1,%r15d
  800749:	0f 88 57 ff ff ff    	js     8006a6 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80074f:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800753:	74 cc                	je     800721 <vprintfmt+0x2de>
  800755:	8d 50 e0             	lea    -0x20(%rax),%edx
  800758:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80075d:	80 fa 5e             	cmp    $0x5e,%dl
  800760:	77 c2                	ja     800724 <vprintfmt+0x2e1>
  800762:	eb bd                	jmp    800721 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800764:	40 84 f6             	test   %sil,%sil
  800767:	75 26                	jne    80078f <vprintfmt+0x34c>
    switch (lflag) {
  800769:	85 d2                	test   %edx,%edx
  80076b:	74 59                	je     8007c6 <vprintfmt+0x383>
  80076d:	83 fa 01             	cmp    $0x1,%edx
  800770:	74 7b                	je     8007ed <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800772:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800775:	83 f8 2f             	cmp    $0x2f,%eax
  800778:	0f 87 96 00 00 00    	ja     800814 <vprintfmt+0x3d1>
  80077e:	89 c2                	mov    %eax,%edx
  800780:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800784:	83 c0 08             	add    $0x8,%eax
  800787:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80078a:	4c 8b 22             	mov    (%rdx),%r12
  80078d:	eb 17                	jmp    8007a6 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  80078f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800792:	83 f8 2f             	cmp    $0x2f,%eax
  800795:	77 21                	ja     8007b8 <vprintfmt+0x375>
  800797:	89 c2                	mov    %eax,%edx
  800799:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80079d:	83 c0 08             	add    $0x8,%eax
  8007a0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007a3:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8007a6:	4d 85 e4             	test   %r12,%r12
  8007a9:	78 7a                	js     800825 <vprintfmt+0x3e2>
            num = i;
  8007ab:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8007ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8007b3:	e9 50 02 00 00       	jmp    800a08 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8007b8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007bc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007c0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007c4:	eb dd                	jmp    8007a3 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8007c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c9:	83 f8 2f             	cmp    $0x2f,%eax
  8007cc:	77 11                	ja     8007df <vprintfmt+0x39c>
  8007ce:	89 c2                	mov    %eax,%edx
  8007d0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007d4:	83 c0 08             	add    $0x8,%eax
  8007d7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007da:	4c 63 22             	movslq (%rdx),%r12
  8007dd:	eb c7                	jmp    8007a6 <vprintfmt+0x363>
  8007df:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007e3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007e7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007eb:	eb ed                	jmp    8007da <vprintfmt+0x397>
        return va_arg(*ap, long);
  8007ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f0:	83 f8 2f             	cmp    $0x2f,%eax
  8007f3:	77 11                	ja     800806 <vprintfmt+0x3c3>
  8007f5:	89 c2                	mov    %eax,%edx
  8007f7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007fb:	83 c0 08             	add    $0x8,%eax
  8007fe:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800801:	4c 8b 22             	mov    (%rdx),%r12
  800804:	eb a0                	jmp    8007a6 <vprintfmt+0x363>
  800806:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80080a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80080e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800812:	eb ed                	jmp    800801 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800814:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800818:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80081c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800820:	e9 65 ff ff ff       	jmp    80078a <vprintfmt+0x347>
                putch('-', put_arg);
  800825:	4c 89 ee             	mov    %r13,%rsi
  800828:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80082d:	41 ff d6             	call   *%r14
                i = -i;
  800830:	49 f7 dc             	neg    %r12
  800833:	e9 73 ff ff ff       	jmp    8007ab <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800838:	40 84 f6             	test   %sil,%sil
  80083b:	75 32                	jne    80086f <vprintfmt+0x42c>
    switch (lflag) {
  80083d:	85 d2                	test   %edx,%edx
  80083f:	74 5d                	je     80089e <vprintfmt+0x45b>
  800841:	83 fa 01             	cmp    $0x1,%edx
  800844:	0f 84 82 00 00 00    	je     8008cc <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  80084a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80084d:	83 f8 2f             	cmp    $0x2f,%eax
  800850:	0f 87 a5 00 00 00    	ja     8008fb <vprintfmt+0x4b8>
  800856:	89 c2                	mov    %eax,%edx
  800858:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80085c:	83 c0 08             	add    $0x8,%eax
  80085f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800862:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800865:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80086a:	e9 99 01 00 00       	jmp    800a08 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80086f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800872:	83 f8 2f             	cmp    $0x2f,%eax
  800875:	77 19                	ja     800890 <vprintfmt+0x44d>
  800877:	89 c2                	mov    %eax,%edx
  800879:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80087d:	83 c0 08             	add    $0x8,%eax
  800880:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800883:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800886:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80088b:	e9 78 01 00 00       	jmp    800a08 <vprintfmt+0x5c5>
  800890:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800894:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800898:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80089c:	eb e5                	jmp    800883 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  80089e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a1:	83 f8 2f             	cmp    $0x2f,%eax
  8008a4:	77 18                	ja     8008be <vprintfmt+0x47b>
  8008a6:	89 c2                	mov    %eax,%edx
  8008a8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008ac:	83 c0 08             	add    $0x8,%eax
  8008af:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008b2:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8008b4:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8008b9:	e9 4a 01 00 00       	jmp    800a08 <vprintfmt+0x5c5>
  8008be:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008c6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ca:	eb e6                	jmp    8008b2 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8008cc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008cf:	83 f8 2f             	cmp    $0x2f,%eax
  8008d2:	77 19                	ja     8008ed <vprintfmt+0x4aa>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008da:	83 c0 08             	add    $0x8,%eax
  8008dd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008e0:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8008e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8008e8:	e9 1b 01 00 00       	jmp    800a08 <vprintfmt+0x5c5>
  8008ed:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008f1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008f5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008f9:	eb e5                	jmp    8008e0 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  8008fb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008ff:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800903:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800907:	e9 56 ff ff ff       	jmp    800862 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  80090c:	40 84 f6             	test   %sil,%sil
  80090f:	75 2e                	jne    80093f <vprintfmt+0x4fc>
    switch (lflag) {
  800911:	85 d2                	test   %edx,%edx
  800913:	74 59                	je     80096e <vprintfmt+0x52b>
  800915:	83 fa 01             	cmp    $0x1,%edx
  800918:	74 7f                	je     800999 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  80091a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091d:	83 f8 2f             	cmp    $0x2f,%eax
  800920:	0f 87 9f 00 00 00    	ja     8009c5 <vprintfmt+0x582>
  800926:	89 c2                	mov    %eax,%edx
  800928:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80092c:	83 c0 08             	add    $0x8,%eax
  80092f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800932:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800935:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80093a:	e9 c9 00 00 00       	jmp    800a08 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80093f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800942:	83 f8 2f             	cmp    $0x2f,%eax
  800945:	77 19                	ja     800960 <vprintfmt+0x51d>
  800947:	89 c2                	mov    %eax,%edx
  800949:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80094d:	83 c0 08             	add    $0x8,%eax
  800950:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800953:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800956:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80095b:	e9 a8 00 00 00       	jmp    800a08 <vprintfmt+0x5c5>
  800960:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800964:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800968:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80096c:	eb e5                	jmp    800953 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  80096e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800971:	83 f8 2f             	cmp    $0x2f,%eax
  800974:	77 15                	ja     80098b <vprintfmt+0x548>
  800976:	89 c2                	mov    %eax,%edx
  800978:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80097c:	83 c0 08             	add    $0x8,%eax
  80097f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800982:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800984:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800989:	eb 7d                	jmp    800a08 <vprintfmt+0x5c5>
  80098b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80098f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800993:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800997:	eb e9                	jmp    800982 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800999:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099c:	83 f8 2f             	cmp    $0x2f,%eax
  80099f:	77 16                	ja     8009b7 <vprintfmt+0x574>
  8009a1:	89 c2                	mov    %eax,%edx
  8009a3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009a7:	83 c0 08             	add    $0x8,%eax
  8009aa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ad:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8009b0:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8009b5:	eb 51                	jmp    800a08 <vprintfmt+0x5c5>
  8009b7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009bb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009bf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009c3:	eb e8                	jmp    8009ad <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8009c5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009c9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009cd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009d1:	e9 5c ff ff ff       	jmp    800932 <vprintfmt+0x4ef>
            putch('0', put_arg);
  8009d6:	4c 89 ee             	mov    %r13,%rsi
  8009d9:	bf 30 00 00 00       	mov    $0x30,%edi
  8009de:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  8009e1:	4c 89 ee             	mov    %r13,%rsi
  8009e4:	bf 78 00 00 00       	mov    $0x78,%edi
  8009e9:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  8009ec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ef:	83 f8 2f             	cmp    $0x2f,%eax
  8009f2:	77 47                	ja     800a3b <vprintfmt+0x5f8>
  8009f4:	89 c2                	mov    %eax,%edx
  8009f6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009fa:	83 c0 08             	add    $0x8,%eax
  8009fd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a00:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a03:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800a08:	48 83 ec 08          	sub    $0x8,%rsp
  800a0c:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800a10:	0f 94 c0             	sete   %al
  800a13:	0f b6 c0             	movzbl %al,%eax
  800a16:	50                   	push   %rax
  800a17:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800a1c:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800a20:	4c 89 ee             	mov    %r13,%rsi
  800a23:	4c 89 f7             	mov    %r14,%rdi
  800a26:	48 b8 2c 03 80 00 00 	movabs $0x80032c,%rax
  800a2d:	00 00 00 
  800a30:	ff d0                	call   *%rax
            break;
  800a32:	48 83 c4 10          	add    $0x10,%rsp
  800a36:	e9 3d fa ff ff       	jmp    800478 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800a3b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a43:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a47:	eb b7                	jmp    800a00 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800a49:	40 84 f6             	test   %sil,%sil
  800a4c:	75 2b                	jne    800a79 <vprintfmt+0x636>
    switch (lflag) {
  800a4e:	85 d2                	test   %edx,%edx
  800a50:	74 56                	je     800aa8 <vprintfmt+0x665>
  800a52:	83 fa 01             	cmp    $0x1,%edx
  800a55:	74 7f                	je     800ad6 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800a57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5a:	83 f8 2f             	cmp    $0x2f,%eax
  800a5d:	0f 87 a2 00 00 00    	ja     800b05 <vprintfmt+0x6c2>
  800a63:	89 c2                	mov    %eax,%edx
  800a65:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a69:	83 c0 08             	add    $0x8,%eax
  800a6c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a6f:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a72:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800a77:	eb 8f                	jmp    800a08 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7c:	83 f8 2f             	cmp    $0x2f,%eax
  800a7f:	77 19                	ja     800a9a <vprintfmt+0x657>
  800a81:	89 c2                	mov    %eax,%edx
  800a83:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a87:	83 c0 08             	add    $0x8,%eax
  800a8a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a8d:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a90:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a95:	e9 6e ff ff ff       	jmp    800a08 <vprintfmt+0x5c5>
  800a9a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a9e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800aa2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aa6:	eb e5                	jmp    800a8d <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800aa8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aab:	83 f8 2f             	cmp    $0x2f,%eax
  800aae:	77 18                	ja     800ac8 <vprintfmt+0x685>
  800ab0:	89 c2                	mov    %eax,%edx
  800ab2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ab6:	83 c0 08             	add    $0x8,%eax
  800ab9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800abc:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800abe:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800ac3:	e9 40 ff ff ff       	jmp    800a08 <vprintfmt+0x5c5>
  800ac8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800acc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ad0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad4:	eb e6                	jmp    800abc <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800ad6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad9:	83 f8 2f             	cmp    $0x2f,%eax
  800adc:	77 19                	ja     800af7 <vprintfmt+0x6b4>
  800ade:	89 c2                	mov    %eax,%edx
  800ae0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ae4:	83 c0 08             	add    $0x8,%eax
  800ae7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aea:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800aed:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800af2:	e9 11 ff ff ff       	jmp    800a08 <vprintfmt+0x5c5>
  800af7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800afb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800aff:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b03:	eb e5                	jmp    800aea <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800b05:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b09:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b0d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b11:	e9 59 ff ff ff       	jmp    800a6f <vprintfmt+0x62c>
            putch(ch, put_arg);
  800b16:	4c 89 ee             	mov    %r13,%rsi
  800b19:	bf 25 00 00 00       	mov    $0x25,%edi
  800b1e:	41 ff d6             	call   *%r14
            break;
  800b21:	e9 52 f9 ff ff       	jmp    800478 <vprintfmt+0x35>
            putch('%', put_arg);
  800b26:	4c 89 ee             	mov    %r13,%rsi
  800b29:	bf 25 00 00 00       	mov    $0x25,%edi
  800b2e:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800b31:	48 83 eb 01          	sub    $0x1,%rbx
  800b35:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800b39:	75 f6                	jne    800b31 <vprintfmt+0x6ee>
  800b3b:	e9 38 f9 ff ff       	jmp    800478 <vprintfmt+0x35>
}
  800b40:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800b44:	5b                   	pop    %rbx
  800b45:	41 5c                	pop    %r12
  800b47:	41 5d                	pop    %r13
  800b49:	41 5e                	pop    %r14
  800b4b:	41 5f                	pop    %r15
  800b4d:	5d                   	pop    %rbp
  800b4e:	c3                   	ret

0000000000800b4f <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800b4f:	f3 0f 1e fa          	endbr64
  800b53:	55                   	push   %rbp
  800b54:	48 89 e5             	mov    %rsp,%rbp
  800b57:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800b5b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b5f:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800b64:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800b68:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800b6f:	48 85 ff             	test   %rdi,%rdi
  800b72:	74 2b                	je     800b9f <vsnprintf+0x50>
  800b74:	48 85 f6             	test   %rsi,%rsi
  800b77:	74 26                	je     800b9f <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800b79:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b7d:	48 bf e6 03 80 00 00 	movabs $0x8003e6,%rdi
  800b84:	00 00 00 
  800b87:	48 b8 43 04 80 00 00 	movabs $0x800443,%rax
  800b8e:	00 00 00 
  800b91:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800b93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b97:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800b9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800b9d:	c9                   	leave
  800b9e:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800b9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ba4:	eb f7                	jmp    800b9d <vsnprintf+0x4e>

0000000000800ba6 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800ba6:	f3 0f 1e fa          	endbr64
  800baa:	55                   	push   %rbp
  800bab:	48 89 e5             	mov    %rsp,%rbp
  800bae:	48 83 ec 50          	sub    $0x50,%rsp
  800bb2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800bb6:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800bba:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800bbe:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800bc5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bc9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bcd:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800bd1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800bd5:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800bd9:	48 b8 4f 0b 80 00 00 	movabs $0x800b4f,%rax
  800be0:	00 00 00 
  800be3:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800be5:	c9                   	leave
  800be6:	c3                   	ret

0000000000800be7 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800be7:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800beb:	80 3f 00             	cmpb   $0x0,(%rdi)
  800bee:	74 10                	je     800c00 <strlen+0x19>
    size_t n = 0;
  800bf0:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800bf5:	48 83 c0 01          	add    $0x1,%rax
  800bf9:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800bfd:	75 f6                	jne    800bf5 <strlen+0xe>
  800bff:	c3                   	ret
    size_t n = 0;
  800c00:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800c05:	c3                   	ret

0000000000800c06 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800c06:	f3 0f 1e fa          	endbr64
  800c0a:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800c0d:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800c12:	48 85 f6             	test   %rsi,%rsi
  800c15:	74 10                	je     800c27 <strnlen+0x21>
  800c17:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800c1b:	74 0b                	je     800c28 <strnlen+0x22>
  800c1d:	48 83 c2 01          	add    $0x1,%rdx
  800c21:	48 39 d0             	cmp    %rdx,%rax
  800c24:	75 f1                	jne    800c17 <strnlen+0x11>
  800c26:	c3                   	ret
  800c27:	c3                   	ret
  800c28:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800c2b:	c3                   	ret

0000000000800c2c <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800c2c:	f3 0f 1e fa          	endbr64
  800c30:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800c33:	ba 00 00 00 00       	mov    $0x0,%edx
  800c38:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800c3c:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800c3f:	48 83 c2 01          	add    $0x1,%rdx
  800c43:	84 c9                	test   %cl,%cl
  800c45:	75 f1                	jne    800c38 <strcpy+0xc>
        ;
    return res;
}
  800c47:	c3                   	ret

0000000000800c48 <strcat>:

char *
strcat(char *dst, const char *src) {
  800c48:	f3 0f 1e fa          	endbr64
  800c4c:	55                   	push   %rbp
  800c4d:	48 89 e5             	mov    %rsp,%rbp
  800c50:	41 54                	push   %r12
  800c52:	53                   	push   %rbx
  800c53:	48 89 fb             	mov    %rdi,%rbx
  800c56:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800c59:	48 b8 e7 0b 80 00 00 	movabs $0x800be7,%rax
  800c60:	00 00 00 
  800c63:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800c65:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800c69:	4c 89 e6             	mov    %r12,%rsi
  800c6c:	48 b8 2c 0c 80 00 00 	movabs $0x800c2c,%rax
  800c73:	00 00 00 
  800c76:	ff d0                	call   *%rax
    return dst;
}
  800c78:	48 89 d8             	mov    %rbx,%rax
  800c7b:	5b                   	pop    %rbx
  800c7c:	41 5c                	pop    %r12
  800c7e:	5d                   	pop    %rbp
  800c7f:	c3                   	ret

0000000000800c80 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c80:	f3 0f 1e fa          	endbr64
  800c84:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800c87:	48 85 d2             	test   %rdx,%rdx
  800c8a:	74 1f                	je     800cab <strncpy+0x2b>
  800c8c:	48 01 fa             	add    %rdi,%rdx
  800c8f:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800c92:	48 83 c1 01          	add    $0x1,%rcx
  800c96:	44 0f b6 06          	movzbl (%rsi),%r8d
  800c9a:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800c9e:	41 80 f8 01          	cmp    $0x1,%r8b
  800ca2:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800ca6:	48 39 ca             	cmp    %rcx,%rdx
  800ca9:	75 e7                	jne    800c92 <strncpy+0x12>
    }
    return ret;
}
  800cab:	c3                   	ret

0000000000800cac <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800cac:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800cb0:	48 89 f8             	mov    %rdi,%rax
  800cb3:	48 85 d2             	test   %rdx,%rdx
  800cb6:	74 24                	je     800cdc <strlcpy+0x30>
        while (--size > 0 && *src)
  800cb8:	48 83 ea 01          	sub    $0x1,%rdx
  800cbc:	74 1b                	je     800cd9 <strlcpy+0x2d>
  800cbe:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800cc2:	0f b6 16             	movzbl (%rsi),%edx
  800cc5:	84 d2                	test   %dl,%dl
  800cc7:	74 10                	je     800cd9 <strlcpy+0x2d>
            *dst++ = *src++;
  800cc9:	48 83 c6 01          	add    $0x1,%rsi
  800ccd:	48 83 c0 01          	add    $0x1,%rax
  800cd1:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800cd4:	48 39 c8             	cmp    %rcx,%rax
  800cd7:	75 e9                	jne    800cc2 <strlcpy+0x16>
        *dst = '\0';
  800cd9:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800cdc:	48 29 f8             	sub    %rdi,%rax
}
  800cdf:	c3                   	ret

0000000000800ce0 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800ce0:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800ce4:	0f b6 07             	movzbl (%rdi),%eax
  800ce7:	84 c0                	test   %al,%al
  800ce9:	74 13                	je     800cfe <strcmp+0x1e>
  800ceb:	38 06                	cmp    %al,(%rsi)
  800ced:	75 0f                	jne    800cfe <strcmp+0x1e>
  800cef:	48 83 c7 01          	add    $0x1,%rdi
  800cf3:	48 83 c6 01          	add    $0x1,%rsi
  800cf7:	0f b6 07             	movzbl (%rdi),%eax
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 ed                	jne    800ceb <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800cfe:	0f b6 c0             	movzbl %al,%eax
  800d01:	0f b6 16             	movzbl (%rsi),%edx
  800d04:	29 d0                	sub    %edx,%eax
}
  800d06:	c3                   	ret

0000000000800d07 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800d07:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800d0b:	48 85 d2             	test   %rdx,%rdx
  800d0e:	74 1f                	je     800d2f <strncmp+0x28>
  800d10:	0f b6 07             	movzbl (%rdi),%eax
  800d13:	84 c0                	test   %al,%al
  800d15:	74 1e                	je     800d35 <strncmp+0x2e>
  800d17:	3a 06                	cmp    (%rsi),%al
  800d19:	75 1a                	jne    800d35 <strncmp+0x2e>
  800d1b:	48 83 c7 01          	add    $0x1,%rdi
  800d1f:	48 83 c6 01          	add    $0x1,%rsi
  800d23:	48 83 ea 01          	sub    $0x1,%rdx
  800d27:	75 e7                	jne    800d10 <strncmp+0x9>

    if (!n) return 0;
  800d29:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2e:	c3                   	ret
  800d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d34:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800d35:	0f b6 07             	movzbl (%rdi),%eax
  800d38:	0f b6 16             	movzbl (%rsi),%edx
  800d3b:	29 d0                	sub    %edx,%eax
}
  800d3d:	c3                   	ret

0000000000800d3e <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800d3e:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800d42:	0f b6 17             	movzbl (%rdi),%edx
  800d45:	84 d2                	test   %dl,%dl
  800d47:	74 18                	je     800d61 <strchr+0x23>
        if (*str == c) {
  800d49:	0f be d2             	movsbl %dl,%edx
  800d4c:	39 f2                	cmp    %esi,%edx
  800d4e:	74 17                	je     800d67 <strchr+0x29>
    for (; *str; str++) {
  800d50:	48 83 c7 01          	add    $0x1,%rdi
  800d54:	0f b6 17             	movzbl (%rdi),%edx
  800d57:	84 d2                	test   %dl,%dl
  800d59:	75 ee                	jne    800d49 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d60:	c3                   	ret
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
  800d66:	c3                   	ret
            return (char *)str;
  800d67:	48 89 f8             	mov    %rdi,%rax
}
  800d6a:	c3                   	ret

0000000000800d6b <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800d6b:	f3 0f 1e fa          	endbr64
  800d6f:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800d72:	0f b6 17             	movzbl (%rdi),%edx
  800d75:	84 d2                	test   %dl,%dl
  800d77:	74 13                	je     800d8c <strfind+0x21>
  800d79:	0f be d2             	movsbl %dl,%edx
  800d7c:	39 f2                	cmp    %esi,%edx
  800d7e:	74 0b                	je     800d8b <strfind+0x20>
  800d80:	48 83 c0 01          	add    $0x1,%rax
  800d84:	0f b6 10             	movzbl (%rax),%edx
  800d87:	84 d2                	test   %dl,%dl
  800d89:	75 ee                	jne    800d79 <strfind+0xe>
        ;
    return (char *)str;
}
  800d8b:	c3                   	ret
  800d8c:	c3                   	ret

0000000000800d8d <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800d8d:	f3 0f 1e fa          	endbr64
  800d91:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800d94:	48 89 f8             	mov    %rdi,%rax
  800d97:	48 f7 d8             	neg    %rax
  800d9a:	83 e0 07             	and    $0x7,%eax
  800d9d:	49 89 d1             	mov    %rdx,%r9
  800da0:	49 29 c1             	sub    %rax,%r9
  800da3:	78 36                	js     800ddb <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800da5:	40 0f b6 c6          	movzbl %sil,%eax
  800da9:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800db0:	01 01 01 
  800db3:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800db7:	40 f6 c7 07          	test   $0x7,%dil
  800dbb:	75 38                	jne    800df5 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800dbd:	4c 89 c9             	mov    %r9,%rcx
  800dc0:	48 c1 f9 03          	sar    $0x3,%rcx
  800dc4:	74 0c                	je     800dd2 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800dc6:	fc                   	cld
  800dc7:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800dca:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800dce:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800dd2:	4d 85 c9             	test   %r9,%r9
  800dd5:	75 45                	jne    800e1c <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800dd7:	4c 89 c0             	mov    %r8,%rax
  800dda:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800ddb:	48 85 d2             	test   %rdx,%rdx
  800dde:	74 f7                	je     800dd7 <memset+0x4a>
  800de0:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800de3:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800de6:	48 83 c0 01          	add    $0x1,%rax
  800dea:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800dee:	48 39 c2             	cmp    %rax,%rdx
  800df1:	75 f3                	jne    800de6 <memset+0x59>
  800df3:	eb e2                	jmp    800dd7 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800df5:	40 f6 c7 01          	test   $0x1,%dil
  800df9:	74 06                	je     800e01 <memset+0x74>
  800dfb:	88 07                	mov    %al,(%rdi)
  800dfd:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e01:	40 f6 c7 02          	test   $0x2,%dil
  800e05:	74 07                	je     800e0e <memset+0x81>
  800e07:	66 89 07             	mov    %ax,(%rdi)
  800e0a:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e0e:	40 f6 c7 04          	test   $0x4,%dil
  800e12:	74 a9                	je     800dbd <memset+0x30>
  800e14:	89 07                	mov    %eax,(%rdi)
  800e16:	48 83 c7 04          	add    $0x4,%rdi
  800e1a:	eb a1                	jmp    800dbd <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e1c:	41 f6 c1 04          	test   $0x4,%r9b
  800e20:	74 1b                	je     800e3d <memset+0xb0>
  800e22:	89 07                	mov    %eax,(%rdi)
  800e24:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e28:	41 f6 c1 02          	test   $0x2,%r9b
  800e2c:	74 07                	je     800e35 <memset+0xa8>
  800e2e:	66 89 07             	mov    %ax,(%rdi)
  800e31:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800e35:	41 f6 c1 01          	test   $0x1,%r9b
  800e39:	74 9c                	je     800dd7 <memset+0x4a>
  800e3b:	eb 06                	jmp    800e43 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e3d:	41 f6 c1 02          	test   $0x2,%r9b
  800e41:	75 eb                	jne    800e2e <memset+0xa1>
        if (ni & 1) *ptr = k;
  800e43:	88 07                	mov    %al,(%rdi)
  800e45:	eb 90                	jmp    800dd7 <memset+0x4a>

0000000000800e47 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800e47:	f3 0f 1e fa          	endbr64
  800e4b:	48 89 f8             	mov    %rdi,%rax
  800e4e:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800e51:	48 39 fe             	cmp    %rdi,%rsi
  800e54:	73 3b                	jae    800e91 <memmove+0x4a>
  800e56:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800e5a:	48 39 d7             	cmp    %rdx,%rdi
  800e5d:	73 32                	jae    800e91 <memmove+0x4a>
        s += n;
        d += n;
  800e5f:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e63:	48 89 d6             	mov    %rdx,%rsi
  800e66:	48 09 fe             	or     %rdi,%rsi
  800e69:	48 09 ce             	or     %rcx,%rsi
  800e6c:	40 f6 c6 07          	test   $0x7,%sil
  800e70:	75 12                	jne    800e84 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800e72:	48 83 ef 08          	sub    $0x8,%rdi
  800e76:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800e7a:	48 c1 e9 03          	shr    $0x3,%rcx
  800e7e:	fd                   	std
  800e7f:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800e82:	fc                   	cld
  800e83:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800e84:	48 83 ef 01          	sub    $0x1,%rdi
  800e88:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800e8c:	fd                   	std
  800e8d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800e8f:	eb f1                	jmp    800e82 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e91:	48 89 f2             	mov    %rsi,%rdx
  800e94:	48 09 c2             	or     %rax,%rdx
  800e97:	48 09 ca             	or     %rcx,%rdx
  800e9a:	f6 c2 07             	test   $0x7,%dl
  800e9d:	75 0c                	jne    800eab <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800e9f:	48 c1 e9 03          	shr    $0x3,%rcx
  800ea3:	48 89 c7             	mov    %rax,%rdi
  800ea6:	fc                   	cld
  800ea7:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800eaa:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800eab:	48 89 c7             	mov    %rax,%rdi
  800eae:	fc                   	cld
  800eaf:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800eb1:	c3                   	ret

0000000000800eb2 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800eb2:	f3 0f 1e fa          	endbr64
  800eb6:	55                   	push   %rbp
  800eb7:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800eba:	48 b8 47 0e 80 00 00 	movabs $0x800e47,%rax
  800ec1:	00 00 00 
  800ec4:	ff d0                	call   *%rax
}
  800ec6:	5d                   	pop    %rbp
  800ec7:	c3                   	ret

0000000000800ec8 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800ec8:	f3 0f 1e fa          	endbr64
  800ecc:	55                   	push   %rbp
  800ecd:	48 89 e5             	mov    %rsp,%rbp
  800ed0:	41 57                	push   %r15
  800ed2:	41 56                	push   %r14
  800ed4:	41 55                	push   %r13
  800ed6:	41 54                	push   %r12
  800ed8:	53                   	push   %rbx
  800ed9:	48 83 ec 08          	sub    $0x8,%rsp
  800edd:	49 89 fe             	mov    %rdi,%r14
  800ee0:	49 89 f7             	mov    %rsi,%r15
  800ee3:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800ee6:	48 89 f7             	mov    %rsi,%rdi
  800ee9:	48 b8 e7 0b 80 00 00 	movabs $0x800be7,%rax
  800ef0:	00 00 00 
  800ef3:	ff d0                	call   *%rax
  800ef5:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800ef8:	48 89 de             	mov    %rbx,%rsi
  800efb:	4c 89 f7             	mov    %r14,%rdi
  800efe:	48 b8 06 0c 80 00 00 	movabs $0x800c06,%rax
  800f05:	00 00 00 
  800f08:	ff d0                	call   *%rax
  800f0a:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800f0d:	48 39 c3             	cmp    %rax,%rbx
  800f10:	74 36                	je     800f48 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800f12:	48 89 d8             	mov    %rbx,%rax
  800f15:	4c 29 e8             	sub    %r13,%rax
  800f18:	49 39 c4             	cmp    %rax,%r12
  800f1b:	73 31                	jae    800f4e <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800f1d:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800f22:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f26:	4c 89 fe             	mov    %r15,%rsi
  800f29:	48 b8 b2 0e 80 00 00 	movabs $0x800eb2,%rax
  800f30:	00 00 00 
  800f33:	ff d0                	call   *%rax
    return dstlen + srclen;
  800f35:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800f39:	48 83 c4 08          	add    $0x8,%rsp
  800f3d:	5b                   	pop    %rbx
  800f3e:	41 5c                	pop    %r12
  800f40:	41 5d                	pop    %r13
  800f42:	41 5e                	pop    %r14
  800f44:	41 5f                	pop    %r15
  800f46:	5d                   	pop    %rbp
  800f47:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800f48:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800f4c:	eb eb                	jmp    800f39 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800f4e:	48 83 eb 01          	sub    $0x1,%rbx
  800f52:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f56:	48 89 da             	mov    %rbx,%rdx
  800f59:	4c 89 fe             	mov    %r15,%rsi
  800f5c:	48 b8 b2 0e 80 00 00 	movabs $0x800eb2,%rax
  800f63:	00 00 00 
  800f66:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800f68:	49 01 de             	add    %rbx,%r14
  800f6b:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800f70:	eb c3                	jmp    800f35 <strlcat+0x6d>

0000000000800f72 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800f72:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800f76:	48 85 d2             	test   %rdx,%rdx
  800f79:	74 2d                	je     800fa8 <memcmp+0x36>
  800f7b:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800f80:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800f84:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800f89:	44 38 c1             	cmp    %r8b,%cl
  800f8c:	75 0f                	jne    800f9d <memcmp+0x2b>
    while (n-- > 0) {
  800f8e:	48 83 c0 01          	add    $0x1,%rax
  800f92:	48 39 c2             	cmp    %rax,%rdx
  800f95:	75 e9                	jne    800f80 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800f97:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9c:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800f9d:	0f b6 c1             	movzbl %cl,%eax
  800fa0:	45 0f b6 c0          	movzbl %r8b,%r8d
  800fa4:	44 29 c0             	sub    %r8d,%eax
  800fa7:	c3                   	ret
    return 0;
  800fa8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fad:	c3                   	ret

0000000000800fae <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800fae:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800fb2:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800fb6:	48 39 c7             	cmp    %rax,%rdi
  800fb9:	73 0f                	jae    800fca <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800fbb:	40 38 37             	cmp    %sil,(%rdi)
  800fbe:	74 0e                	je     800fce <memfind+0x20>
    for (; src < end; src++) {
  800fc0:	48 83 c7 01          	add    $0x1,%rdi
  800fc4:	48 39 f8             	cmp    %rdi,%rax
  800fc7:	75 f2                	jne    800fbb <memfind+0xd>
  800fc9:	c3                   	ret
  800fca:	48 89 f8             	mov    %rdi,%rax
  800fcd:	c3                   	ret
  800fce:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800fd1:	c3                   	ret

0000000000800fd2 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800fd2:	f3 0f 1e fa          	endbr64
  800fd6:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800fd9:	0f b6 37             	movzbl (%rdi),%esi
  800fdc:	40 80 fe 20          	cmp    $0x20,%sil
  800fe0:	74 06                	je     800fe8 <strtol+0x16>
  800fe2:	40 80 fe 09          	cmp    $0x9,%sil
  800fe6:	75 13                	jne    800ffb <strtol+0x29>
  800fe8:	48 83 c7 01          	add    $0x1,%rdi
  800fec:	0f b6 37             	movzbl (%rdi),%esi
  800fef:	40 80 fe 20          	cmp    $0x20,%sil
  800ff3:	74 f3                	je     800fe8 <strtol+0x16>
  800ff5:	40 80 fe 09          	cmp    $0x9,%sil
  800ff9:	74 ed                	je     800fe8 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800ffb:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800ffe:	83 e0 fd             	and    $0xfffffffd,%eax
  801001:	3c 01                	cmp    $0x1,%al
  801003:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801007:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  80100d:	75 0f                	jne    80101e <strtol+0x4c>
  80100f:	80 3f 30             	cmpb   $0x30,(%rdi)
  801012:	74 14                	je     801028 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801014:	85 d2                	test   %edx,%edx
  801016:	b8 0a 00 00 00       	mov    $0xa,%eax
  80101b:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  80101e:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801023:	4c 63 ca             	movslq %edx,%r9
  801026:	eb 36                	jmp    80105e <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801028:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80102c:	74 0f                	je     80103d <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  80102e:	85 d2                	test   %edx,%edx
  801030:	75 ec                	jne    80101e <strtol+0x4c>
        s++;
  801032:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801036:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  80103b:	eb e1                	jmp    80101e <strtol+0x4c>
        s += 2;
  80103d:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801041:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801046:	eb d6                	jmp    80101e <strtol+0x4c>
            dig -= '0';
  801048:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  80104b:	44 0f b6 c1          	movzbl %cl,%r8d
  80104f:	41 39 d0             	cmp    %edx,%r8d
  801052:	7d 21                	jge    801075 <strtol+0xa3>
        val = val * base + dig;
  801054:	49 0f af c1          	imul   %r9,%rax
  801058:	0f b6 c9             	movzbl %cl,%ecx
  80105b:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  80105e:	48 83 c7 01          	add    $0x1,%rdi
  801062:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801066:	80 f9 39             	cmp    $0x39,%cl
  801069:	76 dd                	jbe    801048 <strtol+0x76>
        else if (dig - 'a' < 27)
  80106b:	80 f9 7b             	cmp    $0x7b,%cl
  80106e:	77 05                	ja     801075 <strtol+0xa3>
            dig -= 'a' - 10;
  801070:	83 e9 57             	sub    $0x57,%ecx
  801073:	eb d6                	jmp    80104b <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801075:	4d 85 d2             	test   %r10,%r10
  801078:	74 03                	je     80107d <strtol+0xab>
  80107a:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80107d:	48 89 c2             	mov    %rax,%rdx
  801080:	48 f7 da             	neg    %rdx
  801083:	40 80 fe 2d          	cmp    $0x2d,%sil
  801087:	48 0f 44 c2          	cmove  %rdx,%rax
}
  80108b:	c3                   	ret

000000000080108c <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80108c:	f3 0f 1e fa          	endbr64
  801090:	55                   	push   %rbp
  801091:	48 89 e5             	mov    %rsp,%rbp
  801094:	53                   	push   %rbx
  801095:	48 89 fa             	mov    %rdi,%rdx
  801098:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80109b:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010aa:	be 00 00 00 00       	mov    $0x0,%esi
  8010af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010b5:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8010b7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010bb:	c9                   	leave
  8010bc:	c3                   	ret

00000000008010bd <sys_cgetc>:

int
sys_cgetc(void) {
  8010bd:	f3 0f 1e fa          	endbr64
  8010c1:	55                   	push   %rbp
  8010c2:	48 89 e5             	mov    %rsp,%rbp
  8010c5:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010c6:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d0:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010da:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010df:	be 00 00 00 00       	mov    $0x0,%esi
  8010e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010ea:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8010ec:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010f0:	c9                   	leave
  8010f1:	c3                   	ret

00000000008010f2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8010f2:	f3 0f 1e fa          	endbr64
  8010f6:	55                   	push   %rbp
  8010f7:	48 89 e5             	mov    %rsp,%rbp
  8010fa:	53                   	push   %rbx
  8010fb:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8010ff:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801102:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801107:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80110c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801111:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801116:	be 00 00 00 00       	mov    $0x0,%esi
  80111b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801121:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801123:	48 85 c0             	test   %rax,%rax
  801126:	7f 06                	jg     80112e <sys_env_destroy+0x3c>
}
  801128:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80112c:	c9                   	leave
  80112d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80112e:	49 89 c0             	mov    %rax,%r8
  801131:	b9 03 00 00 00       	mov    $0x3,%ecx
  801136:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  80113d:	00 00 00 
  801140:	be 26 00 00 00       	mov    $0x26,%esi
  801145:	48 bf e7 41 80 00 00 	movabs $0x8041e7,%rdi
  80114c:	00 00 00 
  80114f:	b8 00 00 00 00       	mov    $0x0,%eax
  801154:	49 b9 87 01 80 00 00 	movabs $0x800187,%r9
  80115b:	00 00 00 
  80115e:	41 ff d1             	call   *%r9

0000000000801161 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801161:	f3 0f 1e fa          	endbr64
  801165:	55                   	push   %rbp
  801166:	48 89 e5             	mov    %rsp,%rbp
  801169:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80116a:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80116f:	ba 00 00 00 00       	mov    $0x0,%edx
  801174:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801179:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801183:	be 00 00 00 00       	mov    $0x0,%esi
  801188:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80118e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801190:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801194:	c9                   	leave
  801195:	c3                   	ret

0000000000801196 <sys_yield>:

void
sys_yield(void) {
  801196:	f3 0f 1e fa          	endbr64
  80119a:	55                   	push   %rbp
  80119b:	48 89 e5             	mov    %rsp,%rbp
  80119e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80119f:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8011a9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011b8:	be 00 00 00 00       	mov    $0x0,%esi
  8011bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011c3:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8011c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011c9:	c9                   	leave
  8011ca:	c3                   	ret

00000000008011cb <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8011cb:	f3 0f 1e fa          	endbr64
  8011cf:	55                   	push   %rbp
  8011d0:	48 89 e5             	mov    %rsp,%rbp
  8011d3:	53                   	push   %rbx
  8011d4:	48 89 fa             	mov    %rdi,%rdx
  8011d7:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8011da:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011df:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8011e6:	00 00 00 
  8011e9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ee:	be 00 00 00 00       	mov    $0x0,%esi
  8011f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011f9:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8011fb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011ff:	c9                   	leave
  801200:	c3                   	ret

0000000000801201 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801201:	f3 0f 1e fa          	endbr64
  801205:	55                   	push   %rbp
  801206:	48 89 e5             	mov    %rsp,%rbp
  801209:	53                   	push   %rbx
  80120a:	49 89 f8             	mov    %rdi,%r8
  80120d:	48 89 d3             	mov    %rdx,%rbx
  801210:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801213:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801218:	4c 89 c2             	mov    %r8,%rdx
  80121b:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80121e:	be 00 00 00 00       	mov    $0x0,%esi
  801223:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801229:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80122b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80122f:	c9                   	leave
  801230:	c3                   	ret

0000000000801231 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801231:	f3 0f 1e fa          	endbr64
  801235:	55                   	push   %rbp
  801236:	48 89 e5             	mov    %rsp,%rbp
  801239:	53                   	push   %rbx
  80123a:	48 83 ec 08          	sub    $0x8,%rsp
  80123e:	89 f8                	mov    %edi,%eax
  801240:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801243:	48 63 f9             	movslq %ecx,%rdi
  801246:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801249:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80124e:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801251:	be 00 00 00 00       	mov    $0x0,%esi
  801256:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80125c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80125e:	48 85 c0             	test   %rax,%rax
  801261:	7f 06                	jg     801269 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801263:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801267:	c9                   	leave
  801268:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801269:	49 89 c0             	mov    %rax,%r8
  80126c:	b9 04 00 00 00       	mov    $0x4,%ecx
  801271:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  801278:	00 00 00 
  80127b:	be 26 00 00 00       	mov    $0x26,%esi
  801280:	48 bf e7 41 80 00 00 	movabs $0x8041e7,%rdi
  801287:	00 00 00 
  80128a:	b8 00 00 00 00       	mov    $0x0,%eax
  80128f:	49 b9 87 01 80 00 00 	movabs $0x800187,%r9
  801296:	00 00 00 
  801299:	41 ff d1             	call   *%r9

000000000080129c <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80129c:	f3 0f 1e fa          	endbr64
  8012a0:	55                   	push   %rbp
  8012a1:	48 89 e5             	mov    %rsp,%rbp
  8012a4:	53                   	push   %rbx
  8012a5:	48 83 ec 08          	sub    $0x8,%rsp
  8012a9:	89 f8                	mov    %edi,%eax
  8012ab:	49 89 f2             	mov    %rsi,%r10
  8012ae:	48 89 cf             	mov    %rcx,%rdi
  8012b1:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8012b4:	48 63 da             	movslq %edx,%rbx
  8012b7:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012ba:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012bf:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012c2:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8012c5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012c7:	48 85 c0             	test   %rax,%rax
  8012ca:	7f 06                	jg     8012d2 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8012cc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012d0:	c9                   	leave
  8012d1:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012d2:	49 89 c0             	mov    %rax,%r8
  8012d5:	b9 05 00 00 00       	mov    $0x5,%ecx
  8012da:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  8012e1:	00 00 00 
  8012e4:	be 26 00 00 00       	mov    $0x26,%esi
  8012e9:	48 bf e7 41 80 00 00 	movabs $0x8041e7,%rdi
  8012f0:	00 00 00 
  8012f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f8:	49 b9 87 01 80 00 00 	movabs $0x800187,%r9
  8012ff:	00 00 00 
  801302:	41 ff d1             	call   *%r9

0000000000801305 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801305:	f3 0f 1e fa          	endbr64
  801309:	55                   	push   %rbp
  80130a:	48 89 e5             	mov    %rsp,%rbp
  80130d:	53                   	push   %rbx
  80130e:	48 83 ec 08          	sub    $0x8,%rsp
  801312:	49 89 f9             	mov    %rdi,%r9
  801315:	89 f0                	mov    %esi,%eax
  801317:	48 89 d3             	mov    %rdx,%rbx
  80131a:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80131d:	49 63 f0             	movslq %r8d,%rsi
  801320:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801323:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801328:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80132b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801331:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801333:	48 85 c0             	test   %rax,%rax
  801336:	7f 06                	jg     80133e <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801338:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80133c:	c9                   	leave
  80133d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80133e:	49 89 c0             	mov    %rax,%r8
  801341:	b9 06 00 00 00       	mov    $0x6,%ecx
  801346:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  80134d:	00 00 00 
  801350:	be 26 00 00 00       	mov    $0x26,%esi
  801355:	48 bf e7 41 80 00 00 	movabs $0x8041e7,%rdi
  80135c:	00 00 00 
  80135f:	b8 00 00 00 00       	mov    $0x0,%eax
  801364:	49 b9 87 01 80 00 00 	movabs $0x800187,%r9
  80136b:	00 00 00 
  80136e:	41 ff d1             	call   *%r9

0000000000801371 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801371:	f3 0f 1e fa          	endbr64
  801375:	55                   	push   %rbp
  801376:	48 89 e5             	mov    %rsp,%rbp
  801379:	53                   	push   %rbx
  80137a:	48 83 ec 08          	sub    $0x8,%rsp
  80137e:	48 89 f1             	mov    %rsi,%rcx
  801381:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801384:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801387:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80138c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801391:	be 00 00 00 00       	mov    $0x0,%esi
  801396:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80139c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80139e:	48 85 c0             	test   %rax,%rax
  8013a1:	7f 06                	jg     8013a9 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8013a3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013a7:	c9                   	leave
  8013a8:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013a9:	49 89 c0             	mov    %rax,%r8
  8013ac:	b9 07 00 00 00       	mov    $0x7,%ecx
  8013b1:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  8013b8:	00 00 00 
  8013bb:	be 26 00 00 00       	mov    $0x26,%esi
  8013c0:	48 bf e7 41 80 00 00 	movabs $0x8041e7,%rdi
  8013c7:	00 00 00 
  8013ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8013cf:	49 b9 87 01 80 00 00 	movabs $0x800187,%r9
  8013d6:	00 00 00 
  8013d9:	41 ff d1             	call   *%r9

00000000008013dc <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8013dc:	f3 0f 1e fa          	endbr64
  8013e0:	55                   	push   %rbp
  8013e1:	48 89 e5             	mov    %rsp,%rbp
  8013e4:	53                   	push   %rbx
  8013e5:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8013e9:	48 63 ce             	movslq %esi,%rcx
  8013ec:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013ef:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013fe:	be 00 00 00 00       	mov    $0x0,%esi
  801403:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801409:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80140b:	48 85 c0             	test   %rax,%rax
  80140e:	7f 06                	jg     801416 <sys_env_set_status+0x3a>
}
  801410:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801414:	c9                   	leave
  801415:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801416:	49 89 c0             	mov    %rax,%r8
  801419:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80141e:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  801425:	00 00 00 
  801428:	be 26 00 00 00       	mov    $0x26,%esi
  80142d:	48 bf e7 41 80 00 00 	movabs $0x8041e7,%rdi
  801434:	00 00 00 
  801437:	b8 00 00 00 00       	mov    $0x0,%eax
  80143c:	49 b9 87 01 80 00 00 	movabs $0x800187,%r9
  801443:	00 00 00 
  801446:	41 ff d1             	call   *%r9

0000000000801449 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801449:	f3 0f 1e fa          	endbr64
  80144d:	55                   	push   %rbp
  80144e:	48 89 e5             	mov    %rsp,%rbp
  801451:	53                   	push   %rbx
  801452:	48 83 ec 08          	sub    $0x8,%rsp
  801456:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801459:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80145c:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801461:	bb 00 00 00 00       	mov    $0x0,%ebx
  801466:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80146b:	be 00 00 00 00       	mov    $0x0,%esi
  801470:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801476:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801478:	48 85 c0             	test   %rax,%rax
  80147b:	7f 06                	jg     801483 <sys_env_set_trapframe+0x3a>
}
  80147d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801481:	c9                   	leave
  801482:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801483:	49 89 c0             	mov    %rax,%r8
  801486:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80148b:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  801492:	00 00 00 
  801495:	be 26 00 00 00       	mov    $0x26,%esi
  80149a:	48 bf e7 41 80 00 00 	movabs $0x8041e7,%rdi
  8014a1:	00 00 00 
  8014a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a9:	49 b9 87 01 80 00 00 	movabs $0x800187,%r9
  8014b0:	00 00 00 
  8014b3:	41 ff d1             	call   *%r9

00000000008014b6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8014b6:	f3 0f 1e fa          	endbr64
  8014ba:	55                   	push   %rbp
  8014bb:	48 89 e5             	mov    %rsp,%rbp
  8014be:	53                   	push   %rbx
  8014bf:	48 83 ec 08          	sub    $0x8,%rsp
  8014c3:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8014c6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014c9:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014d3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014d8:	be 00 00 00 00       	mov    $0x0,%esi
  8014dd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014e3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014e5:	48 85 c0             	test   %rax,%rax
  8014e8:	7f 06                	jg     8014f0 <sys_env_set_pgfault_upcall+0x3a>
}
  8014ea:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014ee:	c9                   	leave
  8014ef:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014f0:	49 89 c0             	mov    %rax,%r8
  8014f3:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8014f8:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  8014ff:	00 00 00 
  801502:	be 26 00 00 00       	mov    $0x26,%esi
  801507:	48 bf e7 41 80 00 00 	movabs $0x8041e7,%rdi
  80150e:	00 00 00 
  801511:	b8 00 00 00 00       	mov    $0x0,%eax
  801516:	49 b9 87 01 80 00 00 	movabs $0x800187,%r9
  80151d:	00 00 00 
  801520:	41 ff d1             	call   *%r9

0000000000801523 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801523:	f3 0f 1e fa          	endbr64
  801527:	55                   	push   %rbp
  801528:	48 89 e5             	mov    %rsp,%rbp
  80152b:	53                   	push   %rbx
  80152c:	89 f8                	mov    %edi,%eax
  80152e:	49 89 f1             	mov    %rsi,%r9
  801531:	48 89 d3             	mov    %rdx,%rbx
  801534:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801537:	49 63 f0             	movslq %r8d,%rsi
  80153a:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80153d:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801542:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801545:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80154b:	cd 30                	int    $0x30
}
  80154d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801551:	c9                   	leave
  801552:	c3                   	ret

0000000000801553 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801553:	f3 0f 1e fa          	endbr64
  801557:	55                   	push   %rbp
  801558:	48 89 e5             	mov    %rsp,%rbp
  80155b:	53                   	push   %rbx
  80155c:	48 83 ec 08          	sub    $0x8,%rsp
  801560:	48 89 fa             	mov    %rdi,%rdx
  801563:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801566:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80156b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801570:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801575:	be 00 00 00 00       	mov    $0x0,%esi
  80157a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801580:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801582:	48 85 c0             	test   %rax,%rax
  801585:	7f 06                	jg     80158d <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801587:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80158b:	c9                   	leave
  80158c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80158d:	49 89 c0             	mov    %rax,%r8
  801590:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801595:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  80159c:	00 00 00 
  80159f:	be 26 00 00 00       	mov    $0x26,%esi
  8015a4:	48 bf e7 41 80 00 00 	movabs $0x8041e7,%rdi
  8015ab:	00 00 00 
  8015ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b3:	49 b9 87 01 80 00 00 	movabs $0x800187,%r9
  8015ba:	00 00 00 
  8015bd:	41 ff d1             	call   *%r9

00000000008015c0 <sys_gettime>:

int
sys_gettime(void) {
  8015c0:	f3 0f 1e fa          	endbr64
  8015c4:	55                   	push   %rbp
  8015c5:	48 89 e5             	mov    %rsp,%rbp
  8015c8:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015c9:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d3:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015dd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015e2:	be 00 00 00 00       	mov    $0x0,%esi
  8015e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015ed:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8015ef:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015f3:	c9                   	leave
  8015f4:	c3                   	ret

00000000008015f5 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  8015f5:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8015f9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801600:	ff ff ff 
  801603:	48 01 f8             	add    %rdi,%rax
  801606:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80160a:	c3                   	ret

000000000080160b <fd2data>:

char *
fd2data(struct Fd *fd) {
  80160b:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80160f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801616:	ff ff ff 
  801619:	48 01 f8             	add    %rdi,%rax
  80161c:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801620:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801626:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80162a:	c3                   	ret

000000000080162b <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80162b:	f3 0f 1e fa          	endbr64
  80162f:	55                   	push   %rbp
  801630:	48 89 e5             	mov    %rsp,%rbp
  801633:	41 57                	push   %r15
  801635:	41 56                	push   %r14
  801637:	41 55                	push   %r13
  801639:	41 54                	push   %r12
  80163b:	53                   	push   %rbx
  80163c:	48 83 ec 08          	sub    $0x8,%rsp
  801640:	49 89 ff             	mov    %rdi,%r15
  801643:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801648:	49 bd 12 30 80 00 00 	movabs $0x803012,%r13
  80164f:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801652:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801658:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  80165b:	48 89 df             	mov    %rbx,%rdi
  80165e:	41 ff d5             	call   *%r13
  801661:	83 e0 04             	and    $0x4,%eax
  801664:	74 17                	je     80167d <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801666:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80166d:	4c 39 f3             	cmp    %r14,%rbx
  801670:	75 e6                	jne    801658 <fd_alloc+0x2d>
  801672:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801678:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  80167d:	4d 89 27             	mov    %r12,(%r15)
}
  801680:	48 83 c4 08          	add    $0x8,%rsp
  801684:	5b                   	pop    %rbx
  801685:	41 5c                	pop    %r12
  801687:	41 5d                	pop    %r13
  801689:	41 5e                	pop    %r14
  80168b:	41 5f                	pop    %r15
  80168d:	5d                   	pop    %rbp
  80168e:	c3                   	ret

000000000080168f <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  80168f:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801693:	83 ff 1f             	cmp    $0x1f,%edi
  801696:	77 39                	ja     8016d1 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801698:	55                   	push   %rbp
  801699:	48 89 e5             	mov    %rsp,%rbp
  80169c:	41 54                	push   %r12
  80169e:	53                   	push   %rbx
  80169f:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8016a2:	48 63 df             	movslq %edi,%rbx
  8016a5:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8016ac:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8016b0:	48 89 df             	mov    %rbx,%rdi
  8016b3:	48 b8 12 30 80 00 00 	movabs $0x803012,%rax
  8016ba:	00 00 00 
  8016bd:	ff d0                	call   *%rax
  8016bf:	a8 04                	test   $0x4,%al
  8016c1:	74 14                	je     8016d7 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8016c3:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8016c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cc:	5b                   	pop    %rbx
  8016cd:	41 5c                	pop    %r12
  8016cf:	5d                   	pop    %rbp
  8016d0:	c3                   	ret
        return -E_INVAL;
  8016d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016d6:	c3                   	ret
        return -E_INVAL;
  8016d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016dc:	eb ee                	jmp    8016cc <fd_lookup+0x3d>

00000000008016de <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8016de:	f3 0f 1e fa          	endbr64
  8016e2:	55                   	push   %rbp
  8016e3:	48 89 e5             	mov    %rsp,%rbp
  8016e6:	41 54                	push   %r12
  8016e8:	53                   	push   %rbx
  8016e9:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  8016ec:	48 b8 c0 47 80 00 00 	movabs $0x8047c0,%rax
  8016f3:	00 00 00 
  8016f6:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  8016fd:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801700:	39 3b                	cmp    %edi,(%rbx)
  801702:	74 47                	je     80174b <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801704:	48 83 c0 08          	add    $0x8,%rax
  801708:	48 8b 18             	mov    (%rax),%rbx
  80170b:	48 85 db             	test   %rbx,%rbx
  80170e:	75 f0                	jne    801700 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801710:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801717:	00 00 00 
  80171a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801720:	89 fa                	mov    %edi,%edx
  801722:	48 bf 80 43 80 00 00 	movabs $0x804380,%rdi
  801729:	00 00 00 
  80172c:	b8 00 00 00 00       	mov    $0x0,%eax
  801731:	48 b9 e3 02 80 00 00 	movabs $0x8002e3,%rcx
  801738:	00 00 00 
  80173b:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  80173d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801742:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801746:	5b                   	pop    %rbx
  801747:	41 5c                	pop    %r12
  801749:	5d                   	pop    %rbp
  80174a:	c3                   	ret
            return 0;
  80174b:	b8 00 00 00 00       	mov    $0x0,%eax
  801750:	eb f0                	jmp    801742 <dev_lookup+0x64>

0000000000801752 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801752:	f3 0f 1e fa          	endbr64
  801756:	55                   	push   %rbp
  801757:	48 89 e5             	mov    %rsp,%rbp
  80175a:	41 55                	push   %r13
  80175c:	41 54                	push   %r12
  80175e:	53                   	push   %rbx
  80175f:	48 83 ec 18          	sub    $0x18,%rsp
  801763:	48 89 fb             	mov    %rdi,%rbx
  801766:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801769:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801770:	ff ff ff 
  801773:	48 01 df             	add    %rbx,%rdi
  801776:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80177a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80177e:	48 b8 8f 16 80 00 00 	movabs $0x80168f,%rax
  801785:	00 00 00 
  801788:	ff d0                	call   *%rax
  80178a:	41 89 c5             	mov    %eax,%r13d
  80178d:	85 c0                	test   %eax,%eax
  80178f:	78 06                	js     801797 <fd_close+0x45>
  801791:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801795:	74 1a                	je     8017b1 <fd_close+0x5f>
        return (must_exist ? res : 0);
  801797:	45 84 e4             	test   %r12b,%r12b
  80179a:	b8 00 00 00 00       	mov    $0x0,%eax
  80179f:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8017a3:	44 89 e8             	mov    %r13d,%eax
  8017a6:	48 83 c4 18          	add    $0x18,%rsp
  8017aa:	5b                   	pop    %rbx
  8017ab:	41 5c                	pop    %r12
  8017ad:	41 5d                	pop    %r13
  8017af:	5d                   	pop    %rbp
  8017b0:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017b1:	8b 3b                	mov    (%rbx),%edi
  8017b3:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8017b7:	48 b8 de 16 80 00 00 	movabs $0x8016de,%rax
  8017be:	00 00 00 
  8017c1:	ff d0                	call   *%rax
  8017c3:	41 89 c5             	mov    %eax,%r13d
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	78 1b                	js     8017e5 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8017ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ce:	48 8b 40 20          	mov    0x20(%rax),%rax
  8017d2:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8017d8:	48 85 c0             	test   %rax,%rax
  8017db:	74 08                	je     8017e5 <fd_close+0x93>
  8017dd:	48 89 df             	mov    %rbx,%rdi
  8017e0:	ff d0                	call   *%rax
  8017e2:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8017e5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8017ea:	48 89 de             	mov    %rbx,%rsi
  8017ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8017f2:	48 b8 71 13 80 00 00 	movabs $0x801371,%rax
  8017f9:	00 00 00 
  8017fc:	ff d0                	call   *%rax
    return res;
  8017fe:	eb a3                	jmp    8017a3 <fd_close+0x51>

0000000000801800 <close>:

int
close(int fdnum) {
  801800:	f3 0f 1e fa          	endbr64
  801804:	55                   	push   %rbp
  801805:	48 89 e5             	mov    %rsp,%rbp
  801808:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80180c:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801810:	48 b8 8f 16 80 00 00 	movabs $0x80168f,%rax
  801817:	00 00 00 
  80181a:	ff d0                	call   *%rax
    if (res < 0) return res;
  80181c:	85 c0                	test   %eax,%eax
  80181e:	78 15                	js     801835 <close+0x35>

    return fd_close(fd, 1);
  801820:	be 01 00 00 00       	mov    $0x1,%esi
  801825:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801829:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  801830:	00 00 00 
  801833:	ff d0                	call   *%rax
}
  801835:	c9                   	leave
  801836:	c3                   	ret

0000000000801837 <close_all>:

void
close_all(void) {
  801837:	f3 0f 1e fa          	endbr64
  80183b:	55                   	push   %rbp
  80183c:	48 89 e5             	mov    %rsp,%rbp
  80183f:	41 54                	push   %r12
  801841:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801842:	bb 00 00 00 00       	mov    $0x0,%ebx
  801847:	49 bc 00 18 80 00 00 	movabs $0x801800,%r12
  80184e:	00 00 00 
  801851:	89 df                	mov    %ebx,%edi
  801853:	41 ff d4             	call   *%r12
  801856:	83 c3 01             	add    $0x1,%ebx
  801859:	83 fb 20             	cmp    $0x20,%ebx
  80185c:	75 f3                	jne    801851 <close_all+0x1a>
}
  80185e:	5b                   	pop    %rbx
  80185f:	41 5c                	pop    %r12
  801861:	5d                   	pop    %rbp
  801862:	c3                   	ret

0000000000801863 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801863:	f3 0f 1e fa          	endbr64
  801867:	55                   	push   %rbp
  801868:	48 89 e5             	mov    %rsp,%rbp
  80186b:	41 57                	push   %r15
  80186d:	41 56                	push   %r14
  80186f:	41 55                	push   %r13
  801871:	41 54                	push   %r12
  801873:	53                   	push   %rbx
  801874:	48 83 ec 18          	sub    $0x18,%rsp
  801878:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80187b:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  80187f:	48 b8 8f 16 80 00 00 	movabs $0x80168f,%rax
  801886:	00 00 00 
  801889:	ff d0                	call   *%rax
  80188b:	89 c3                	mov    %eax,%ebx
  80188d:	85 c0                	test   %eax,%eax
  80188f:	0f 88 b8 00 00 00    	js     80194d <dup+0xea>
    close(newfdnum);
  801895:	44 89 e7             	mov    %r12d,%edi
  801898:	48 b8 00 18 80 00 00 	movabs $0x801800,%rax
  80189f:	00 00 00 
  8018a2:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8018a4:	4d 63 ec             	movslq %r12d,%r13
  8018a7:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8018ae:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8018b2:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8018b6:	4c 89 ff             	mov    %r15,%rdi
  8018b9:	49 be 0b 16 80 00 00 	movabs $0x80160b,%r14
  8018c0:	00 00 00 
  8018c3:	41 ff d6             	call   *%r14
  8018c6:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8018c9:	4c 89 ef             	mov    %r13,%rdi
  8018cc:	41 ff d6             	call   *%r14
  8018cf:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8018d2:	48 89 df             	mov    %rbx,%rdi
  8018d5:	48 b8 12 30 80 00 00 	movabs $0x803012,%rax
  8018dc:	00 00 00 
  8018df:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8018e1:	a8 04                	test   $0x4,%al
  8018e3:	74 2b                	je     801910 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8018e5:	41 89 c1             	mov    %eax,%r9d
  8018e8:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8018ee:	4c 89 f1             	mov    %r14,%rcx
  8018f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f6:	48 89 de             	mov    %rbx,%rsi
  8018f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8018fe:	48 b8 9c 12 80 00 00 	movabs $0x80129c,%rax
  801905:	00 00 00 
  801908:	ff d0                	call   *%rax
  80190a:	89 c3                	mov    %eax,%ebx
  80190c:	85 c0                	test   %eax,%eax
  80190e:	78 4e                	js     80195e <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801910:	4c 89 ff             	mov    %r15,%rdi
  801913:	48 b8 12 30 80 00 00 	movabs $0x803012,%rax
  80191a:	00 00 00 
  80191d:	ff d0                	call   *%rax
  80191f:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801922:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801928:	4c 89 e9             	mov    %r13,%rcx
  80192b:	ba 00 00 00 00       	mov    $0x0,%edx
  801930:	4c 89 fe             	mov    %r15,%rsi
  801933:	bf 00 00 00 00       	mov    $0x0,%edi
  801938:	48 b8 9c 12 80 00 00 	movabs $0x80129c,%rax
  80193f:	00 00 00 
  801942:	ff d0                	call   *%rax
  801944:	89 c3                	mov    %eax,%ebx
  801946:	85 c0                	test   %eax,%eax
  801948:	78 14                	js     80195e <dup+0xfb>

    return newfdnum;
  80194a:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  80194d:	89 d8                	mov    %ebx,%eax
  80194f:	48 83 c4 18          	add    $0x18,%rsp
  801953:	5b                   	pop    %rbx
  801954:	41 5c                	pop    %r12
  801956:	41 5d                	pop    %r13
  801958:	41 5e                	pop    %r14
  80195a:	41 5f                	pop    %r15
  80195c:	5d                   	pop    %rbp
  80195d:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80195e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801963:	4c 89 ee             	mov    %r13,%rsi
  801966:	bf 00 00 00 00       	mov    $0x0,%edi
  80196b:	49 bc 71 13 80 00 00 	movabs $0x801371,%r12
  801972:	00 00 00 
  801975:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801978:	ba 00 10 00 00       	mov    $0x1000,%edx
  80197d:	4c 89 f6             	mov    %r14,%rsi
  801980:	bf 00 00 00 00       	mov    $0x0,%edi
  801985:	41 ff d4             	call   *%r12
    return res;
  801988:	eb c3                	jmp    80194d <dup+0xea>

000000000080198a <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  80198a:	f3 0f 1e fa          	endbr64
  80198e:	55                   	push   %rbp
  80198f:	48 89 e5             	mov    %rsp,%rbp
  801992:	41 56                	push   %r14
  801994:	41 55                	push   %r13
  801996:	41 54                	push   %r12
  801998:	53                   	push   %rbx
  801999:	48 83 ec 10          	sub    $0x10,%rsp
  80199d:	89 fb                	mov    %edi,%ebx
  80199f:	49 89 f4             	mov    %rsi,%r12
  8019a2:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019a5:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019a9:	48 b8 8f 16 80 00 00 	movabs $0x80168f,%rax
  8019b0:	00 00 00 
  8019b3:	ff d0                	call   *%rax
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	78 4c                	js     801a05 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019b9:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8019bd:	41 8b 3e             	mov    (%r14),%edi
  8019c0:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8019c4:	48 b8 de 16 80 00 00 	movabs $0x8016de,%rax
  8019cb:	00 00 00 
  8019ce:	ff d0                	call   *%rax
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	78 35                	js     801a09 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019d4:	41 8b 46 08          	mov    0x8(%r14),%eax
  8019d8:	83 e0 03             	and    $0x3,%eax
  8019db:	83 f8 01             	cmp    $0x1,%eax
  8019de:	74 2d                	je     801a0d <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8019e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8019e8:	48 85 c0             	test   %rax,%rax
  8019eb:	74 56                	je     801a43 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  8019ed:	4c 89 ea             	mov    %r13,%rdx
  8019f0:	4c 89 e6             	mov    %r12,%rsi
  8019f3:	4c 89 f7             	mov    %r14,%rdi
  8019f6:	ff d0                	call   *%rax
}
  8019f8:	48 83 c4 10          	add    $0x10,%rsp
  8019fc:	5b                   	pop    %rbx
  8019fd:	41 5c                	pop    %r12
  8019ff:	41 5d                	pop    %r13
  801a01:	41 5e                	pop    %r14
  801a03:	5d                   	pop    %rbp
  801a04:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a05:	48 98                	cltq
  801a07:	eb ef                	jmp    8019f8 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a09:	48 98                	cltq
  801a0b:	eb eb                	jmp    8019f8 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a0d:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801a14:	00 00 00 
  801a17:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a1d:	89 da                	mov    %ebx,%edx
  801a1f:	48 bf f5 41 80 00 00 	movabs $0x8041f5,%rdi
  801a26:	00 00 00 
  801a29:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2e:	48 b9 e3 02 80 00 00 	movabs $0x8002e3,%rcx
  801a35:	00 00 00 
  801a38:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a3a:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801a41:	eb b5                	jmp    8019f8 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801a43:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a4a:	eb ac                	jmp    8019f8 <read+0x6e>

0000000000801a4c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801a4c:	f3 0f 1e fa          	endbr64
  801a50:	55                   	push   %rbp
  801a51:	48 89 e5             	mov    %rsp,%rbp
  801a54:	41 57                	push   %r15
  801a56:	41 56                	push   %r14
  801a58:	41 55                	push   %r13
  801a5a:	41 54                	push   %r12
  801a5c:	53                   	push   %rbx
  801a5d:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801a61:	48 85 d2             	test   %rdx,%rdx
  801a64:	74 54                	je     801aba <readn+0x6e>
  801a66:	41 89 fd             	mov    %edi,%r13d
  801a69:	49 89 f6             	mov    %rsi,%r14
  801a6c:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801a6f:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801a74:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801a79:	49 bf 8a 19 80 00 00 	movabs $0x80198a,%r15
  801a80:	00 00 00 
  801a83:	4c 89 e2             	mov    %r12,%rdx
  801a86:	48 29 f2             	sub    %rsi,%rdx
  801a89:	4c 01 f6             	add    %r14,%rsi
  801a8c:	44 89 ef             	mov    %r13d,%edi
  801a8f:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801a92:	85 c0                	test   %eax,%eax
  801a94:	78 20                	js     801ab6 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801a96:	01 c3                	add    %eax,%ebx
  801a98:	85 c0                	test   %eax,%eax
  801a9a:	74 08                	je     801aa4 <readn+0x58>
  801a9c:	48 63 f3             	movslq %ebx,%rsi
  801a9f:	4c 39 e6             	cmp    %r12,%rsi
  801aa2:	72 df                	jb     801a83 <readn+0x37>
    }
    return res;
  801aa4:	48 63 c3             	movslq %ebx,%rax
}
  801aa7:	48 83 c4 08          	add    $0x8,%rsp
  801aab:	5b                   	pop    %rbx
  801aac:	41 5c                	pop    %r12
  801aae:	41 5d                	pop    %r13
  801ab0:	41 5e                	pop    %r14
  801ab2:	41 5f                	pop    %r15
  801ab4:	5d                   	pop    %rbp
  801ab5:	c3                   	ret
        if (inc < 0) return inc;
  801ab6:	48 98                	cltq
  801ab8:	eb ed                	jmp    801aa7 <readn+0x5b>
    int inc = 1, res = 0;
  801aba:	bb 00 00 00 00       	mov    $0x0,%ebx
  801abf:	eb e3                	jmp    801aa4 <readn+0x58>

0000000000801ac1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801ac1:	f3 0f 1e fa          	endbr64
  801ac5:	55                   	push   %rbp
  801ac6:	48 89 e5             	mov    %rsp,%rbp
  801ac9:	41 56                	push   %r14
  801acb:	41 55                	push   %r13
  801acd:	41 54                	push   %r12
  801acf:	53                   	push   %rbx
  801ad0:	48 83 ec 10          	sub    $0x10,%rsp
  801ad4:	89 fb                	mov    %edi,%ebx
  801ad6:	49 89 f4             	mov    %rsi,%r12
  801ad9:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801adc:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ae0:	48 b8 8f 16 80 00 00 	movabs $0x80168f,%rax
  801ae7:	00 00 00 
  801aea:	ff d0                	call   *%rax
  801aec:	85 c0                	test   %eax,%eax
  801aee:	78 47                	js     801b37 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801af0:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801af4:	41 8b 3e             	mov    (%r14),%edi
  801af7:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801afb:	48 b8 de 16 80 00 00 	movabs $0x8016de,%rax
  801b02:	00 00 00 
  801b05:	ff d0                	call   *%rax
  801b07:	85 c0                	test   %eax,%eax
  801b09:	78 30                	js     801b3b <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b0b:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801b10:	74 2d                	je     801b3f <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801b12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b16:	48 8b 40 18          	mov    0x18(%rax),%rax
  801b1a:	48 85 c0             	test   %rax,%rax
  801b1d:	74 56                	je     801b75 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801b1f:	4c 89 ea             	mov    %r13,%rdx
  801b22:	4c 89 e6             	mov    %r12,%rsi
  801b25:	4c 89 f7             	mov    %r14,%rdi
  801b28:	ff d0                	call   *%rax
}
  801b2a:	48 83 c4 10          	add    $0x10,%rsp
  801b2e:	5b                   	pop    %rbx
  801b2f:	41 5c                	pop    %r12
  801b31:	41 5d                	pop    %r13
  801b33:	41 5e                	pop    %r14
  801b35:	5d                   	pop    %rbp
  801b36:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b37:	48 98                	cltq
  801b39:	eb ef                	jmp    801b2a <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b3b:	48 98                	cltq
  801b3d:	eb eb                	jmp    801b2a <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b3f:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801b46:	00 00 00 
  801b49:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b4f:	89 da                	mov    %ebx,%edx
  801b51:	48 bf 11 42 80 00 00 	movabs $0x804211,%rdi
  801b58:	00 00 00 
  801b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b60:	48 b9 e3 02 80 00 00 	movabs $0x8002e3,%rcx
  801b67:	00 00 00 
  801b6a:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b6c:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801b73:	eb b5                	jmp    801b2a <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801b75:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801b7c:	eb ac                	jmp    801b2a <write+0x69>

0000000000801b7e <seek>:

int
seek(int fdnum, off_t offset) {
  801b7e:	f3 0f 1e fa          	endbr64
  801b82:	55                   	push   %rbp
  801b83:	48 89 e5             	mov    %rsp,%rbp
  801b86:	53                   	push   %rbx
  801b87:	48 83 ec 18          	sub    $0x18,%rsp
  801b8b:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b8d:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801b91:	48 b8 8f 16 80 00 00 	movabs $0x80168f,%rax
  801b98:	00 00 00 
  801b9b:	ff d0                	call   *%rax
  801b9d:	85 c0                	test   %eax,%eax
  801b9f:	78 0c                	js     801bad <seek+0x2f>

    fd->fd_offset = offset;
  801ba1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba5:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ba8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bad:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801bb1:	c9                   	leave
  801bb2:	c3                   	ret

0000000000801bb3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801bb3:	f3 0f 1e fa          	endbr64
  801bb7:	55                   	push   %rbp
  801bb8:	48 89 e5             	mov    %rsp,%rbp
  801bbb:	41 55                	push   %r13
  801bbd:	41 54                	push   %r12
  801bbf:	53                   	push   %rbx
  801bc0:	48 83 ec 18          	sub    $0x18,%rsp
  801bc4:	89 fb                	mov    %edi,%ebx
  801bc6:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bc9:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801bcd:	48 b8 8f 16 80 00 00 	movabs $0x80168f,%rax
  801bd4:	00 00 00 
  801bd7:	ff d0                	call   *%rax
  801bd9:	85 c0                	test   %eax,%eax
  801bdb:	78 38                	js     801c15 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801bdd:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801be1:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801be5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801be9:	48 b8 de 16 80 00 00 	movabs $0x8016de,%rax
  801bf0:	00 00 00 
  801bf3:	ff d0                	call   *%rax
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	78 1c                	js     801c15 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bf9:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801bfe:	74 20                	je     801c20 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c00:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c04:	48 8b 40 30          	mov    0x30(%rax),%rax
  801c08:	48 85 c0             	test   %rax,%rax
  801c0b:	74 47                	je     801c54 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801c0d:	44 89 e6             	mov    %r12d,%esi
  801c10:	4c 89 ef             	mov    %r13,%rdi
  801c13:	ff d0                	call   *%rax
}
  801c15:	48 83 c4 18          	add    $0x18,%rsp
  801c19:	5b                   	pop    %rbx
  801c1a:	41 5c                	pop    %r12
  801c1c:	41 5d                	pop    %r13
  801c1e:	5d                   	pop    %rbp
  801c1f:	c3                   	ret
                thisenv->env_id, fdnum);
  801c20:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801c27:	00 00 00 
  801c2a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c30:	89 da                	mov    %ebx,%edx
  801c32:	48 bf a8 43 80 00 00 	movabs $0x8043a8,%rdi
  801c39:	00 00 00 
  801c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c41:	48 b9 e3 02 80 00 00 	movabs $0x8002e3,%rcx
  801c48:	00 00 00 
  801c4b:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c52:	eb c1                	jmp    801c15 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c54:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801c59:	eb ba                	jmp    801c15 <ftruncate+0x62>

0000000000801c5b <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801c5b:	f3 0f 1e fa          	endbr64
  801c5f:	55                   	push   %rbp
  801c60:	48 89 e5             	mov    %rsp,%rbp
  801c63:	41 54                	push   %r12
  801c65:	53                   	push   %rbx
  801c66:	48 83 ec 10          	sub    $0x10,%rsp
  801c6a:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c6d:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c71:	48 b8 8f 16 80 00 00 	movabs $0x80168f,%rax
  801c78:	00 00 00 
  801c7b:	ff d0                	call   *%rax
  801c7d:	85 c0                	test   %eax,%eax
  801c7f:	78 4e                	js     801ccf <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c81:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801c85:	41 8b 3c 24          	mov    (%r12),%edi
  801c89:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801c8d:	48 b8 de 16 80 00 00 	movabs $0x8016de,%rax
  801c94:	00 00 00 
  801c97:	ff d0                	call   *%rax
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	78 32                	js     801ccf <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801c9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ca1:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801ca6:	74 30                	je     801cd8 <fstat+0x7d>

    stat->st_name[0] = 0;
  801ca8:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801cab:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801cb2:	00 00 00 
    stat->st_isdir = 0;
  801cb5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801cbc:	00 00 00 
    stat->st_dev = dev;
  801cbf:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801cc6:	48 89 de             	mov    %rbx,%rsi
  801cc9:	4c 89 e7             	mov    %r12,%rdi
  801ccc:	ff 50 28             	call   *0x28(%rax)
}
  801ccf:	48 83 c4 10          	add    $0x10,%rsp
  801cd3:	5b                   	pop    %rbx
  801cd4:	41 5c                	pop    %r12
  801cd6:	5d                   	pop    %rbp
  801cd7:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801cd8:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801cdd:	eb f0                	jmp    801ccf <fstat+0x74>

0000000000801cdf <stat>:

int
stat(const char *path, struct Stat *stat) {
  801cdf:	f3 0f 1e fa          	endbr64
  801ce3:	55                   	push   %rbp
  801ce4:	48 89 e5             	mov    %rsp,%rbp
  801ce7:	41 54                	push   %r12
  801ce9:	53                   	push   %rbx
  801cea:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801ced:	be 00 00 00 00       	mov    $0x0,%esi
  801cf2:	48 b8 c0 1f 80 00 00 	movabs $0x801fc0,%rax
  801cf9:	00 00 00 
  801cfc:	ff d0                	call   *%rax
  801cfe:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801d00:	85 c0                	test   %eax,%eax
  801d02:	78 25                	js     801d29 <stat+0x4a>

    int res = fstat(fd, stat);
  801d04:	4c 89 e6             	mov    %r12,%rsi
  801d07:	89 c7                	mov    %eax,%edi
  801d09:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  801d10:	00 00 00 
  801d13:	ff d0                	call   *%rax
  801d15:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801d18:	89 df                	mov    %ebx,%edi
  801d1a:	48 b8 00 18 80 00 00 	movabs $0x801800,%rax
  801d21:	00 00 00 
  801d24:	ff d0                	call   *%rax

    return res;
  801d26:	44 89 e3             	mov    %r12d,%ebx
}
  801d29:	89 d8                	mov    %ebx,%eax
  801d2b:	5b                   	pop    %rbx
  801d2c:	41 5c                	pop    %r12
  801d2e:	5d                   	pop    %rbp
  801d2f:	c3                   	ret

0000000000801d30 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801d30:	f3 0f 1e fa          	endbr64
  801d34:	55                   	push   %rbp
  801d35:	48 89 e5             	mov    %rsp,%rbp
  801d38:	41 54                	push   %r12
  801d3a:	53                   	push   %rbx
  801d3b:	48 83 ec 10          	sub    $0x10,%rsp
  801d3f:	41 89 fc             	mov    %edi,%r12d
  801d42:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801d45:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801d4c:	00 00 00 
  801d4f:	83 38 00             	cmpl   $0x0,(%rax)
  801d52:	74 6e                	je     801dc2 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801d54:	bf 03 00 00 00       	mov    $0x3,%edi
  801d59:	48 b8 3f 35 80 00 00 	movabs $0x80353f,%rax
  801d60:	00 00 00 
  801d63:	ff d0                	call   *%rax
  801d65:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801d6c:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801d6e:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801d74:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801d79:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  801d80:	00 00 00 
  801d83:	44 89 e6             	mov    %r12d,%esi
  801d86:	89 c7                	mov    %eax,%edi
  801d88:	48 b8 7d 34 80 00 00 	movabs $0x80347d,%rax
  801d8f:	00 00 00 
  801d92:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801d94:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801d9b:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801d9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801da1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801da5:	48 89 de             	mov    %rbx,%rsi
  801da8:	bf 00 00 00 00       	mov    $0x0,%edi
  801dad:	48 b8 e4 33 80 00 00 	movabs $0x8033e4,%rax
  801db4:	00 00 00 
  801db7:	ff d0                	call   *%rax
}
  801db9:	48 83 c4 10          	add    $0x10,%rsp
  801dbd:	5b                   	pop    %rbx
  801dbe:	41 5c                	pop    %r12
  801dc0:	5d                   	pop    %rbp
  801dc1:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801dc2:	bf 03 00 00 00       	mov    $0x3,%edi
  801dc7:	48 b8 3f 35 80 00 00 	movabs $0x80353f,%rax
  801dce:	00 00 00 
  801dd1:	ff d0                	call   *%rax
  801dd3:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801dda:	00 00 
  801ddc:	e9 73 ff ff ff       	jmp    801d54 <fsipc+0x24>

0000000000801de1 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801de1:	f3 0f 1e fa          	endbr64
  801de5:	55                   	push   %rbp
  801de6:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801de9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801df0:	00 00 00 
  801df3:	8b 57 0c             	mov    0xc(%rdi),%edx
  801df6:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801df8:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801dfb:	be 00 00 00 00       	mov    $0x0,%esi
  801e00:	bf 02 00 00 00       	mov    $0x2,%edi
  801e05:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  801e0c:	00 00 00 
  801e0f:	ff d0                	call   *%rax
}
  801e11:	5d                   	pop    %rbp
  801e12:	c3                   	ret

0000000000801e13 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801e13:	f3 0f 1e fa          	endbr64
  801e17:	55                   	push   %rbp
  801e18:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e1b:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e1e:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801e25:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801e27:	be 00 00 00 00       	mov    $0x0,%esi
  801e2c:	bf 06 00 00 00       	mov    $0x6,%edi
  801e31:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  801e38:	00 00 00 
  801e3b:	ff d0                	call   *%rax
}
  801e3d:	5d                   	pop    %rbp
  801e3e:	c3                   	ret

0000000000801e3f <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801e3f:	f3 0f 1e fa          	endbr64
  801e43:	55                   	push   %rbp
  801e44:	48 89 e5             	mov    %rsp,%rbp
  801e47:	41 54                	push   %r12
  801e49:	53                   	push   %rbx
  801e4a:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e4d:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e50:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801e57:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801e59:	be 00 00 00 00       	mov    $0x0,%esi
  801e5e:	bf 05 00 00 00       	mov    $0x5,%edi
  801e63:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  801e6a:	00 00 00 
  801e6d:	ff d0                	call   *%rax
    if (res < 0) return res;
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	78 3d                	js     801eb0 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e73:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  801e7a:	00 00 00 
  801e7d:	4c 89 e6             	mov    %r12,%rsi
  801e80:	48 89 df             	mov    %rbx,%rdi
  801e83:	48 b8 2c 0c 80 00 00 	movabs $0x800c2c,%rax
  801e8a:	00 00 00 
  801e8d:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801e8f:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801e96:	00 
  801e97:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e9d:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801ea4:	00 
  801ea5:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb0:	5b                   	pop    %rbx
  801eb1:	41 5c                	pop    %r12
  801eb3:	5d                   	pop    %rbp
  801eb4:	c3                   	ret

0000000000801eb5 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801eb5:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801eb9:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801ec0:	77 41                	ja     801f03 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801ec2:	55                   	push   %rbp
  801ec3:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ec6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801ecd:	00 00 00 
  801ed0:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801ed3:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  801ed5:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801ed9:	48 8d 78 10          	lea    0x10(%rax),%rdi
  801edd:	48 b8 47 0e 80 00 00 	movabs $0x800e47,%rax
  801ee4:	00 00 00 
  801ee7:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  801ee9:	be 00 00 00 00       	mov    $0x0,%esi
  801eee:	bf 04 00 00 00       	mov    $0x4,%edi
  801ef3:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  801efa:	00 00 00 
  801efd:	ff d0                	call   *%rax
  801eff:	48 98                	cltq
}
  801f01:	5d                   	pop    %rbp
  801f02:	c3                   	ret
        return -E_INVAL;
  801f03:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  801f0a:	c3                   	ret

0000000000801f0b <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801f0b:	f3 0f 1e fa          	endbr64
  801f0f:	55                   	push   %rbp
  801f10:	48 89 e5             	mov    %rsp,%rbp
  801f13:	41 55                	push   %r13
  801f15:	41 54                	push   %r12
  801f17:	53                   	push   %rbx
  801f18:	48 83 ec 08          	sub    $0x8,%rsp
  801f1c:	49 89 f4             	mov    %rsi,%r12
  801f1f:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f22:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801f29:	00 00 00 
  801f2c:	8b 57 0c             	mov    0xc(%rdi),%edx
  801f2f:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  801f31:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  801f35:	be 00 00 00 00       	mov    $0x0,%esi
  801f3a:	bf 03 00 00 00       	mov    $0x3,%edi
  801f3f:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  801f46:	00 00 00 
  801f49:	ff d0                	call   *%rax
  801f4b:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  801f4e:	4d 85 ed             	test   %r13,%r13
  801f51:	78 2a                	js     801f7d <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  801f53:	4c 89 ea             	mov    %r13,%rdx
  801f56:	4c 39 eb             	cmp    %r13,%rbx
  801f59:	72 30                	jb     801f8b <devfile_read+0x80>
  801f5b:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  801f62:	7f 27                	jg     801f8b <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  801f64:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801f6b:	00 00 00 
  801f6e:	4c 89 e7             	mov    %r12,%rdi
  801f71:	48 b8 47 0e 80 00 00 	movabs $0x800e47,%rax
  801f78:	00 00 00 
  801f7b:	ff d0                	call   *%rax
}
  801f7d:	4c 89 e8             	mov    %r13,%rax
  801f80:	48 83 c4 08          	add    $0x8,%rsp
  801f84:	5b                   	pop    %rbx
  801f85:	41 5c                	pop    %r12
  801f87:	41 5d                	pop    %r13
  801f89:	5d                   	pop    %rbp
  801f8a:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801f8b:	48 b9 2e 42 80 00 00 	movabs $0x80422e,%rcx
  801f92:	00 00 00 
  801f95:	48 ba 4b 42 80 00 00 	movabs $0x80424b,%rdx
  801f9c:	00 00 00 
  801f9f:	be 7b 00 00 00       	mov    $0x7b,%esi
  801fa4:	48 bf 60 42 80 00 00 	movabs $0x804260,%rdi
  801fab:	00 00 00 
  801fae:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb3:	49 b8 87 01 80 00 00 	movabs $0x800187,%r8
  801fba:	00 00 00 
  801fbd:	41 ff d0             	call   *%r8

0000000000801fc0 <open>:
open(const char *path, int mode) {
  801fc0:	f3 0f 1e fa          	endbr64
  801fc4:	55                   	push   %rbp
  801fc5:	48 89 e5             	mov    %rsp,%rbp
  801fc8:	41 55                	push   %r13
  801fca:	41 54                	push   %r12
  801fcc:	53                   	push   %rbx
  801fcd:	48 83 ec 18          	sub    $0x18,%rsp
  801fd1:	49 89 fc             	mov    %rdi,%r12
  801fd4:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801fd7:	48 b8 e7 0b 80 00 00 	movabs $0x800be7,%rax
  801fde:	00 00 00 
  801fe1:	ff d0                	call   *%rax
  801fe3:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801fe9:	0f 87 8a 00 00 00    	ja     802079 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801fef:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801ff3:	48 b8 2b 16 80 00 00 	movabs $0x80162b,%rax
  801ffa:	00 00 00 
  801ffd:	ff d0                	call   *%rax
  801fff:	89 c3                	mov    %eax,%ebx
  802001:	85 c0                	test   %eax,%eax
  802003:	78 50                	js     802055 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802005:	4c 89 e6             	mov    %r12,%rsi
  802008:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  80200f:	00 00 00 
  802012:	48 89 df             	mov    %rbx,%rdi
  802015:	48 b8 2c 0c 80 00 00 	movabs $0x800c2c,%rax
  80201c:	00 00 00 
  80201f:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802021:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802028:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80202c:	bf 01 00 00 00       	mov    $0x1,%edi
  802031:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  802038:	00 00 00 
  80203b:	ff d0                	call   *%rax
  80203d:	89 c3                	mov    %eax,%ebx
  80203f:	85 c0                	test   %eax,%eax
  802041:	78 1f                	js     802062 <open+0xa2>
    return fd2num(fd);
  802043:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802047:	48 b8 f5 15 80 00 00 	movabs $0x8015f5,%rax
  80204e:	00 00 00 
  802051:	ff d0                	call   *%rax
  802053:	89 c3                	mov    %eax,%ebx
}
  802055:	89 d8                	mov    %ebx,%eax
  802057:	48 83 c4 18          	add    $0x18,%rsp
  80205b:	5b                   	pop    %rbx
  80205c:	41 5c                	pop    %r12
  80205e:	41 5d                	pop    %r13
  802060:	5d                   	pop    %rbp
  802061:	c3                   	ret
        fd_close(fd, 0);
  802062:	be 00 00 00 00       	mov    $0x0,%esi
  802067:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80206b:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  802072:	00 00 00 
  802075:	ff d0                	call   *%rax
        return res;
  802077:	eb dc                	jmp    802055 <open+0x95>
        return -E_BAD_PATH;
  802079:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80207e:	eb d5                	jmp    802055 <open+0x95>

0000000000802080 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802080:	f3 0f 1e fa          	endbr64
  802084:	55                   	push   %rbp
  802085:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802088:	be 00 00 00 00       	mov    $0x0,%esi
  80208d:	bf 08 00 00 00       	mov    $0x8,%edi
  802092:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  802099:	00 00 00 
  80209c:	ff d0                	call   *%rax
}
  80209e:	5d                   	pop    %rbp
  80209f:	c3                   	ret

00000000008020a0 <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  8020a0:	f3 0f 1e fa          	endbr64
  8020a4:	55                   	push   %rbp
  8020a5:	48 89 e5             	mov    %rsp,%rbp
  8020a8:	41 55                	push   %r13
  8020aa:	41 54                	push   %r12
  8020ac:	53                   	push   %rbx
  8020ad:	48 83 ec 08          	sub    $0x8,%rsp
  8020b1:	48 89 fb             	mov    %rdi,%rbx
  8020b4:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  8020b7:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  8020ba:	48 b8 12 30 80 00 00 	movabs $0x803012,%rax
  8020c1:	00 00 00 
  8020c4:	ff d0                	call   *%rax
  8020c6:	41 89 c1             	mov    %eax,%r9d
  8020c9:	4d 89 e0             	mov    %r12,%r8
  8020cc:	49 29 d8             	sub    %rbx,%r8
  8020cf:	48 89 d9             	mov    %rbx,%rcx
  8020d2:	44 89 ea             	mov    %r13d,%edx
  8020d5:	48 89 de             	mov    %rbx,%rsi
  8020d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8020dd:	48 b8 9c 12 80 00 00 	movabs $0x80129c,%rax
  8020e4:	00 00 00 
  8020e7:	ff d0                	call   *%rax
}
  8020e9:	48 83 c4 08          	add    $0x8,%rsp
  8020ed:	5b                   	pop    %rbx
  8020ee:	41 5c                	pop    %r12
  8020f0:	41 5d                	pop    %r13
  8020f2:	5d                   	pop    %rbp
  8020f3:	c3                   	ret

00000000008020f4 <spawn>:
spawn(const char *prog, const char **argv) {
  8020f4:	f3 0f 1e fa          	endbr64
  8020f8:	55                   	push   %rbp
  8020f9:	48 89 e5             	mov    %rsp,%rbp
  8020fc:	41 57                	push   %r15
  8020fe:	41 56                	push   %r14
  802100:	41 55                	push   %r13
  802102:	41 54                	push   %r12
  802104:	53                   	push   %rbx
  802105:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  80210c:	49 89 f4             	mov    %rsi,%r12
    int fd = open(prog, O_RDONLY);
  80210f:	be 00 00 00 00       	mov    $0x0,%esi
  802114:	48 b8 c0 1f 80 00 00 	movabs $0x801fc0,%rax
  80211b:	00 00 00 
  80211e:	ff d0                	call   *%rax
  802120:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
    if (fd < 0) return fd;
  802126:	85 c0                	test   %eax,%eax
  802128:	0f 88 30 06 00 00    	js     80275e <spawn+0x66a>
  80212e:	89 c7                	mov    %eax,%edi
    res = readn(fd, elf_buf, sizeof(elf_buf));
  802130:	ba 00 02 00 00       	mov    $0x200,%edx
  802135:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  80213c:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  802143:	00 00 00 
  802146:	ff d0                	call   *%rax
  802148:	89 c6                	mov    %eax,%esi
    if (res != sizeof(elf_buf)) {
  80214a:	3d 00 02 00 00       	cmp    $0x200,%eax
  80214f:	0f 85 7d 02 00 00    	jne    8023d2 <spawn+0x2de>
        elf->e_elf[1] != 1 /* little endian */ ||
  802155:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  80215c:	ff ff 00 
  80215f:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  802166:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  80216d:	01 01 00 
  802170:	48 39 d0             	cmp    %rdx,%rax
  802173:	0f 85 95 02 00 00    	jne    80240e <spawn+0x31a>
        elf->e_type != ET_EXEC /* executable */ ||
  802179:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  802180:	00 3e 00 
  802183:	0f 85 85 02 00 00    	jne    80240e <spawn+0x31a>

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  802189:	b8 09 00 00 00       	mov    $0x9,%eax
  80218e:	cd 30                	int    $0x30
  802190:	41 89 c6             	mov    %eax,%r14d
  802193:	89 c3                	mov    %eax,%ebx
    if ((int)(res = sys_exofork()) < 0) goto error2;
  802195:	85 c0                	test   %eax,%eax
  802197:	0f 88 a9 05 00 00    	js     802746 <spawn+0x652>
    envid_t child = res;
  80219d:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  8021a3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8021a8:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8021ac:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8021b0:	48 c1 e0 04          	shl    $0x4,%rax
  8021b4:	48 be 00 00 a0 1f 80 	movabs $0x801fa00000,%rsi
  8021bb:	00 00 00 
  8021be:	48 01 c6             	add    %rax,%rsi
  8021c1:	48 8b 06             	mov    (%rsi),%rax
  8021c4:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  8021cb:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  8021d2:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  8021d9:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  8021e0:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  8021e7:	48 29 ce             	sub    %rcx,%rsi
  8021ea:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  8021f0:	c1 e9 03             	shr    $0x3,%ecx
  8021f3:	89 c9                	mov    %ecx,%ecx
  8021f5:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  8021f8:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8021ff:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  802206:	49 8b 3c 24          	mov    (%r12),%rdi
  80220a:	48 85 ff             	test   %rdi,%rdi
  80220d:	0f 84 7f 05 00 00    	je     802792 <spawn+0x69e>
  802213:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    string_size = 0;
  802219:	41 bf 00 00 00 00    	mov    $0x0,%r15d
        string_size += strlen(argv[argc]) + 1;
  80221f:	48 bb e7 0b 80 00 00 	movabs $0x800be7,%rbx
  802226:	00 00 00 
  802229:	ff d3                	call   *%rbx
  80222b:	4c 01 f8             	add    %r15,%rax
  80222e:	4c 8d 78 01          	lea    0x1(%rax),%r15
    for (argc = 0; argv[argc] != 0; argc++)
  802232:	4c 89 ea             	mov    %r13,%rdx
  802235:	49 83 c5 01          	add    $0x1,%r13
  802239:	4b 8b 7c ec f8       	mov    -0x8(%r12,%r13,8),%rdi
  80223e:	48 85 ff             	test   %rdi,%rdi
  802241:	75 e6                	jne    802229 <spawn+0x135>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802243:	49 89 d5             	mov    %rdx,%r13
  802246:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  80224d:	48 f7 d0             	not    %rax
  802250:	48 8d 98 00 00 41 00 	lea    0x410000(%rax),%rbx
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802257:	49 89 df             	mov    %rbx,%r15
  80225a:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  80225e:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  802265:	89 d0                	mov    %edx,%eax
  802267:	83 c0 01             	add    $0x1,%eax
  80226a:	48 98                	cltq
  80226c:	48 c1 e0 03          	shl    $0x3,%rax
  802270:	49 29 c7             	sub    %rax,%r15
  802273:	4c 89 bd f0 fc ff ff 	mov    %r15,-0x310(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  80227a:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  80227e:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  802284:	0f 86 ff 04 00 00    	jbe    802789 <spawn+0x695>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  80228a:	b9 06 00 00 00       	mov    $0x6,%ecx
  80228f:	ba 00 00 01 00       	mov    $0x10000,%edx
  802294:	be 00 00 40 00       	mov    $0x400000,%esi
  802299:	48 b8 31 12 80 00 00 	movabs $0x801231,%rax
  8022a0:	00 00 00 
  8022a3:	ff d0                	call   *%rax
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	0f 88 e1 04 00 00    	js     80278e <spawn+0x69a>
    for (i = 0; i < argc; i++) {
  8022ad:	4c 89 e8             	mov    %r13,%rax
  8022b0:	45 85 ed             	test   %r13d,%r13d
  8022b3:	7e 54                	jle    802309 <spawn+0x215>
  8022b5:	4d 89 fd             	mov    %r15,%r13
  8022b8:	48 98                	cltq
  8022ba:	4d 8d 3c c7          	lea    (%r15,%rax,8),%r15
        argv_store[i] = UTEMP2USTACK(string_store);
  8022be:	48 b8 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rax
  8022c5:	00 00 00 
  8022c8:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  8022cf:	ff 
  8022d0:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  8022d4:	49 8b 34 24          	mov    (%r12),%rsi
  8022d8:	48 89 df             	mov    %rbx,%rdi
  8022db:	48 b8 2c 0c 80 00 00 	movabs $0x800c2c,%rax
  8022e2:	00 00 00 
  8022e5:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  8022e7:	49 8b 3c 24          	mov    (%r12),%rdi
  8022eb:	48 b8 e7 0b 80 00 00 	movabs $0x800be7,%rax
  8022f2:	00 00 00 
  8022f5:	ff d0                	call   *%rax
  8022f7:	48 8d 5c 03 01       	lea    0x1(%rbx,%rax,1),%rbx
    for (i = 0; i < argc; i++) {
  8022fc:	49 83 c5 08          	add    $0x8,%r13
  802300:	49 83 c4 08          	add    $0x8,%r12
  802304:	4d 39 fd             	cmp    %r15,%r13
  802307:	75 b5                	jne    8022be <spawn+0x1ca>
    argv_store[argc] = 0;
  802309:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  802310:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  802317:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802318:	48 81 fb 00 00 41 00 	cmp    $0x410000,%rbx
  80231f:	0f 85 30 01 00 00    	jne    802455 <spawn+0x361>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  802325:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  80232c:	00 00 00 
  80232f:	48 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%rsi
  802336:	48 8d 84 0e 00 00 c0 	lea    -0x400000(%rsi,%rcx,1),%rax
  80233d:	ff 
  80233e:	48 89 46 f8          	mov    %rax,-0x8(%rsi)
    argv_store[-2] = argc;
  802342:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  802349:	48 89 46 f0          	mov    %rax,-0x10(%rsi)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  80234d:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  802354:	00 00 00 
  802357:	48 8d 84 06 00 00 c0 	lea    -0x400000(%rsi,%rax,1),%rax
  80235e:	ff 
  80235f:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  802366:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  80236c:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  802372:	44 89 f2             	mov    %r14d,%edx
  802375:	be 00 00 40 00       	mov    $0x400000,%esi
  80237a:	bf 00 00 00 00       	mov    $0x0,%edi
  80237f:	48 b8 9c 12 80 00 00 	movabs $0x80129c,%rax
  802386:	00 00 00 
  802389:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  80238b:	48 bb 71 13 80 00 00 	movabs $0x801371,%rbx
  802392:	00 00 00 
  802395:	ba 00 00 01 00       	mov    $0x10000,%edx
  80239a:	be 00 00 40 00       	mov    $0x400000,%esi
  80239f:	bf 00 00 00 00       	mov    $0x0,%edi
  8023a4:	ff d3                	call   *%rbx
  8023a6:	85 c0                	test   %eax,%eax
  8023a8:	78 eb                	js     802395 <spawn+0x2a1>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  8023aa:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  8023b1:	4c 8d b4 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r14
  8023b8:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8023b9:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  8023c0:	00 
  8023c1:	0f 84 68 02 00 00    	je     80262f <spawn+0x53b>
  8023c7:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  8023cd:	e9 c5 01 00 00       	jmp    802597 <spawn+0x4a3>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  8023d2:	48 bf d0 43 80 00 00 	movabs $0x8043d0,%rdi
  8023d9:	00 00 00 
  8023dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e1:	48 ba e3 02 80 00 00 	movabs $0x8002e3,%rdx
  8023e8:	00 00 00 
  8023eb:	ff d2                	call   *%rdx
        close(fd);
  8023ed:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  8023f3:	48 b8 00 18 80 00 00 	movabs $0x801800,%rax
  8023fa:	00 00 00 
  8023fd:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  8023ff:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  802406:	ff ff ff 
  802409:	e9 50 03 00 00       	jmp    80275e <spawn+0x66a>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80240e:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802413:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  802419:	48 bf 6b 42 80 00 00 	movabs $0x80426b,%rdi
  802420:	00 00 00 
  802423:	b8 00 00 00 00       	mov    $0x0,%eax
  802428:	48 b9 e3 02 80 00 00 	movabs $0x8002e3,%rcx
  80242f:	00 00 00 
  802432:	ff d1                	call   *%rcx
        close(fd);
  802434:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  80243a:	48 b8 00 18 80 00 00 	movabs $0x801800,%rax
  802441:	00 00 00 
  802444:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802446:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  80244d:	ff ff ff 
  802450:	e9 09 03 00 00       	jmp    80275e <spawn+0x66a>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802455:	48 b9 00 44 80 00 00 	movabs $0x804400,%rcx
  80245c:	00 00 00 
  80245f:	48 ba 4b 42 80 00 00 	movabs $0x80424b,%rdx
  802466:	00 00 00 
  802469:	be f0 00 00 00       	mov    $0xf0,%esi
  80246e:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  802475:	00 00 00 
  802478:	b8 00 00 00 00       	mov    $0x0,%eax
  80247d:	49 b8 87 01 80 00 00 	movabs $0x800187,%r8
  802484:	00 00 00 
  802487:	41 ff d0             	call   *%r8
    /* seek() fd to fileoffset  */
    /* read filesz to UTEMP */
    /* Map read section conents to child */
    /* Unmap it from parent */
    if (filesz != 0) {
        res = sys_alloc_region(CURENVID, UTEMP, filesz, perm | PROT_W);
  80248a:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  802490:	83 c9 02             	or     $0x2,%ecx
  802493:	48 89 da             	mov    %rbx,%rdx
  802496:	be 00 00 40 00       	mov    $0x400000,%esi
  80249b:	bf 00 00 00 00       	mov    $0x0,%edi
  8024a0:	48 b8 31 12 80 00 00 	movabs $0x801231,%rax
  8024a7:	00 00 00 
  8024aa:	ff d0                	call   *%rax
        if (res < 0) {
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	0f 88 7e 02 00 00    	js     802732 <spawn+0x63e>
            return res;
        }

        res = seek(fd, fileoffset);
  8024b4:	8b b5 e8 fc ff ff    	mov    -0x318(%rbp),%esi
  8024ba:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  8024c0:	48 b8 7e 1b 80 00 00 	movabs $0x801b7e,%rax
  8024c7:	00 00 00 
  8024ca:	ff d0                	call   *%rax
        if (res < 0) {
  8024cc:	85 c0                	test   %eax,%eax
  8024ce:	0f 88 a2 02 00 00    	js     802776 <spawn+0x682>
            return res;
        }

        res = readn(fd, (void *)UTEMP, filesz);
  8024d4:	48 89 da             	mov    %rbx,%rdx
  8024d7:	be 00 00 40 00       	mov    $0x400000,%esi
  8024dc:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  8024e2:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  8024e9:	00 00 00 
  8024ec:	ff d0                	call   *%rax
        if (res < 0) {
  8024ee:	85 c0                	test   %eax,%eax
  8024f0:	0f 88 84 02 00 00    	js     80277a <spawn+0x686>
            return res;
        }

        res = sys_map_region(CURENVID, (void *)UTEMP, child, (void *)va, filesz, perm);
  8024f6:	44 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%r9d
  8024fd:	49 89 d8             	mov    %rbx,%r8
  802500:	4c 89 e1             	mov    %r12,%rcx
  802503:	8b 95 e0 fc ff ff    	mov    -0x320(%rbp),%edx
  802509:	be 00 00 40 00       	mov    $0x400000,%esi
  80250e:	bf 00 00 00 00       	mov    $0x0,%edi
  802513:	48 b8 9c 12 80 00 00 	movabs $0x80129c,%rax
  80251a:	00 00 00 
  80251d:	ff d0                	call   *%rax
        if (res < 0) {
  80251f:	85 c0                	test   %eax,%eax
  802521:	0f 88 57 02 00 00    	js     80277e <spawn+0x68a>
            return res;
        }

        res = sys_unmap_region(CURENVID, UTEMP, filesz);
  802527:	48 89 da             	mov    %rbx,%rdx
  80252a:	be 00 00 40 00       	mov    $0x400000,%esi
  80252f:	bf 00 00 00 00       	mov    $0x0,%edi
  802534:	48 b8 71 13 80 00 00 	movabs $0x801371,%rax
  80253b:	00 00 00 
  80253e:	ff d0                	call   *%rax
        if (res < 0) {
  802540:	85 c0                	test   %eax,%eax
  802542:	0f 89 ca 00 00 00    	jns    802612 <spawn+0x51e>
  802548:	89 c3                	mov    %eax,%ebx
  80254a:	e9 e5 01 00 00       	jmp    802734 <spawn+0x640>
            return res;
        }
    }

    if (memsz > filesz) {
        res = sys_alloc_region(child, (void *)(va + filesz), (memsz - filesz), perm | ALLOC_ZERO);
  80254f:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  802555:	81 c9 00 00 10 00    	or     $0x100000,%ecx
  80255b:	4c 89 ea             	mov    %r13,%rdx
  80255e:	48 29 da             	sub    %rbx,%rdx
  802561:	4a 8d 34 23          	lea    (%rbx,%r12,1),%rsi
  802565:	8b bd e0 fc ff ff    	mov    -0x320(%rbp),%edi
  80256b:	48 b8 31 12 80 00 00 	movabs $0x801231,%rax
  802572:	00 00 00 
  802575:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  802577:	85 c0                	test   %eax,%eax
  802579:	0f 88 a1 00 00 00    	js     802620 <spawn+0x52c>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  80257f:	49 83 c7 01          	add    $0x1,%r15
  802583:	49 83 c6 38          	add    $0x38,%r14
  802587:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  80258e:	49 39 c7             	cmp    %rax,%r15
  802591:	0f 83 98 00 00 00    	jae    80262f <spawn+0x53b>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  802597:	41 83 3e 01          	cmpl   $0x1,(%r14)
  80259b:	75 e2                	jne    80257f <spawn+0x48b>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  80259d:	41 8b 46 04          	mov    0x4(%r14),%eax
  8025a1:	89 c2                	mov    %eax,%edx
  8025a3:	83 e2 02             	and    $0x2,%edx
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  8025a6:	89 d1                	mov    %edx,%ecx
  8025a8:	83 c9 04             	or     $0x4,%ecx
  8025ab:	a8 04                	test   $0x4,%al
  8025ad:	0f 45 d1             	cmovne %ecx,%edx
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  8025b0:	83 e0 01             	and    $0x1,%eax
  8025b3:	09 d0                	or     %edx,%eax
  8025b5:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  8025bb:	49 8b 46 08          	mov    0x8(%r14),%rax
  8025bf:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
  8025c5:	49 8b 5e 20          	mov    0x20(%r14),%rbx
  8025c9:	4d 8b 6e 28          	mov    0x28(%r14),%r13
  8025cd:	4d 8b 66 10          	mov    0x10(%r14),%r12
  8025d1:	8b 8d cc fd ff ff    	mov    -0x234(%rbp),%ecx
  8025d7:	89 8d e0 fc ff ff    	mov    %ecx,-0x320(%rbp)
    if (res) {
  8025dd:	44 89 e2             	mov    %r12d,%edx
  8025e0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8025e6:	74 14                	je     8025fc <spawn+0x508>
        va -= res;
  8025e8:	48 63 ca             	movslq %edx,%rcx
  8025eb:	49 29 cc             	sub    %rcx,%r12
        memsz += res;
  8025ee:	49 01 cd             	add    %rcx,%r13
        filesz += res;
  8025f1:	48 01 cb             	add    %rcx,%rbx
        fileoffset -= res;
  8025f4:	29 d0                	sub    %edx,%eax
  8025f6:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
    if (filesz > HUGE_PAGE_SIZE) {
  8025fc:	48 81 fb 00 00 20 00 	cmp    $0x200000,%rbx
  802603:	0f 87 79 01 00 00    	ja     802782 <spawn+0x68e>
    if (filesz != 0) {
  802609:	48 85 db             	test   %rbx,%rbx
  80260c:	0f 85 78 fe ff ff    	jne    80248a <spawn+0x396>
    if (memsz > filesz) {
  802612:	4c 39 eb             	cmp    %r13,%rbx
  802615:	0f 83 64 ff ff ff    	jae    80257f <spawn+0x48b>
  80261b:	e9 2f ff ff ff       	jmp    80254f <spawn+0x45b>
        if (res < 0) {
  802620:	ba 00 00 00 00       	mov    $0x0,%edx
  802625:	0f 4e d0             	cmovle %eax,%edx
  802628:	89 d3                	mov    %edx,%ebx
  80262a:	e9 05 01 00 00       	jmp    802734 <spawn+0x640>
    close(fd);
  80262f:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802635:	48 b8 00 18 80 00 00 	movabs $0x801800,%rax
  80263c:	00 00 00 
  80263f:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  802641:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  802648:	48 bf a0 20 80 00 00 	movabs $0x8020a0,%rdi
  80264f:	00 00 00 
  802652:	48 b8 92 30 80 00 00 	movabs $0x803092,%rax
  802659:	00 00 00 
  80265c:	ff d0                	call   *%rax
  80265e:	85 c0                	test   %eax,%eax
  802660:	78 49                	js     8026ab <spawn+0x5b7>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  802662:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  802669:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  80266f:	48 b8 49 14 80 00 00 	movabs $0x801449,%rax
  802676:	00 00 00 
  802679:	ff d0                	call   *%rax
  80267b:	85 c0                	test   %eax,%eax
  80267d:	78 59                	js     8026d8 <spawn+0x5e4>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80267f:	be 02 00 00 00       	mov    $0x2,%esi
  802684:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  80268a:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  802691:	00 00 00 
  802694:	ff d0                	call   *%rax
  802696:	85 c0                	test   %eax,%eax
  802698:	78 6b                	js     802705 <spawn+0x611>
    return child;
  80269a:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8026a0:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
  8026a6:	e9 b3 00 00 00       	jmp    80275e <spawn+0x66a>
        panic("copy_shared_region: %i", res);
  8026ab:	89 c1                	mov    %eax,%ecx
  8026ad:	48 ba 91 42 80 00 00 	movabs $0x804291,%rdx
  8026b4:	00 00 00 
  8026b7:	be 84 00 00 00       	mov    $0x84,%esi
  8026bc:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  8026c3:	00 00 00 
  8026c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cb:	49 b8 87 01 80 00 00 	movabs $0x800187,%r8
  8026d2:	00 00 00 
  8026d5:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  8026d8:	89 c1                	mov    %eax,%ecx
  8026da:	48 ba a8 42 80 00 00 	movabs $0x8042a8,%rdx
  8026e1:	00 00 00 
  8026e4:	be 87 00 00 00       	mov    $0x87,%esi
  8026e9:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  8026f0:	00 00 00 
  8026f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f8:	49 b8 87 01 80 00 00 	movabs $0x800187,%r8
  8026ff:	00 00 00 
  802702:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  802705:	89 c1                	mov    %eax,%ecx
  802707:	48 ba c2 42 80 00 00 	movabs $0x8042c2,%rdx
  80270e:	00 00 00 
  802711:	be 8a 00 00 00       	mov    $0x8a,%esi
  802716:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  80271d:	00 00 00 
  802720:	b8 00 00 00 00       	mov    $0x0,%eax
  802725:	49 b8 87 01 80 00 00 	movabs $0x800187,%r8
  80272c:	00 00 00 
  80272f:	41 ff d0             	call   *%r8
  802732:	89 c3                	mov    %eax,%ebx
    sys_env_destroy(child);
  802734:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  80273a:	48 b8 f2 10 80 00 00 	movabs $0x8010f2,%rax
  802741:	00 00 00 
  802744:	ff d0                	call   *%rax
    close(fd);
  802746:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  80274c:	48 b8 00 18 80 00 00 	movabs $0x801800,%rax
  802753:	00 00 00 
  802756:	ff d0                	call   *%rax
    return res;
  802758:	89 9d fc fc ff ff    	mov    %ebx,-0x304(%rbp)
}
  80275e:	8b 85 fc fc ff ff    	mov    -0x304(%rbp),%eax
  802764:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  80276b:	5b                   	pop    %rbx
  80276c:	41 5c                	pop    %r12
  80276e:	41 5d                	pop    %r13
  802770:	41 5e                	pop    %r14
  802772:	41 5f                	pop    %r15
  802774:	5d                   	pop    %rbp
  802775:	c3                   	ret
  802776:	89 c3                	mov    %eax,%ebx
  802778:	eb ba                	jmp    802734 <spawn+0x640>
  80277a:	89 c3                	mov    %eax,%ebx
  80277c:	eb b6                	jmp    802734 <spawn+0x640>
  80277e:	89 c3                	mov    %eax,%ebx
  802780:	eb b2                	jmp    802734 <spawn+0x640>
        return -E_INVAL;
  802782:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
  802787:	eb ab                	jmp    802734 <spawn+0x640>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  802789:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    if ((res = init_stack(child, argv, &child_tf)) < 0) goto error;
  80278e:	89 c3                	mov    %eax,%ebx
  802790:	eb a2                	jmp    802734 <spawn+0x640>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  802792:	b9 06 00 00 00       	mov    $0x6,%ecx
  802797:	ba 00 00 01 00       	mov    $0x10000,%edx
  80279c:	be 00 00 40 00       	mov    $0x400000,%esi
  8027a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8027a6:	48 b8 31 12 80 00 00 	movabs $0x801231,%rax
  8027ad:	00 00 00 
  8027b0:	ff d0                	call   *%rax
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	78 d8                	js     80278e <spawn+0x69a>
    for (argc = 0; argv[argc] != 0; argc++)
  8027b6:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  8027bd:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  8027c1:	48 c7 85 f0 fc ff ff 	movq   $0x40fff8,-0x310(%rbp)
  8027c8:	f8 ff 40 00 
  8027cc:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  8027d3:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  8027d7:	bb 00 00 41 00       	mov    $0x410000,%ebx
  8027dc:	e9 28 fb ff ff       	jmp    802309 <spawn+0x215>

00000000008027e1 <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  8027e1:	f3 0f 1e fa          	endbr64
  8027e5:	55                   	push   %rbp
  8027e6:	48 89 e5             	mov    %rsp,%rbp
  8027e9:	48 83 ec 50          	sub    $0x50,%rsp
  8027ed:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8027f1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8027f5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8027f9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  8027fd:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802804:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802808:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80280c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802810:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  802814:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  802819:	eb 15                	jmp    802830 <spawnl+0x4f>
  80281b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80281f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802823:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802827:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  80282b:	74 1c                	je     802849 <spawnl+0x68>
  80282d:	83 c1 01             	add    $0x1,%ecx
  802830:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802833:	83 f8 2f             	cmp    $0x2f,%eax
  802836:	77 e3                	ja     80281b <spawnl+0x3a>
  802838:	89 c2                	mov    %eax,%edx
  80283a:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  80283e:	4c 01 d2             	add    %r10,%rdx
  802841:	83 c0 08             	add    $0x8,%eax
  802844:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802847:	eb de                	jmp    802827 <spawnl+0x46>
    const char *argv[argc + 2];
  802849:	8d 41 02             	lea    0x2(%rcx),%eax
  80284c:	48 98                	cltq
  80284e:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  802855:	00 
  802856:	49 89 c0             	mov    %rax,%r8
  802859:	49 83 e0 f0          	and    $0xfffffffffffffff0,%r8
  80285d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802863:	48 89 e2             	mov    %rsp,%rdx
  802866:	48 29 c2             	sub    %rax,%rdx
  802869:	48 39 d4             	cmp    %rdx,%rsp
  80286c:	74 12                	je     802880 <spawnl+0x9f>
  80286e:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  802875:	48 83 8c 24 f8 0f 00 	orq    $0x0,0xff8(%rsp)
  80287c:	00 00 
  80287e:	eb e9                	jmp    802869 <spawnl+0x88>
  802880:	4c 89 c0             	mov    %r8,%rax
  802883:	25 ff 0f 00 00       	and    $0xfff,%eax
  802888:	48 29 c4             	sub    %rax,%rsp
  80288b:	48 85 c0             	test   %rax,%rax
  80288e:	74 06                	je     802896 <spawnl+0xb5>
  802890:	48 83 4c 04 f8 00    	orq    $0x0,-0x8(%rsp,%rax,1)
  802896:	4c 8d 4c 24 07       	lea    0x7(%rsp),%r9
  80289b:	4c 89 c8             	mov    %r9,%rax
  80289e:	48 c1 e8 03          	shr    $0x3,%rax
  8028a2:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
    argv[0] = arg0;
  8028a6:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  8028ad:	00 
    argv[argc + 1] = NULL;
  8028ae:	8d 41 01             	lea    0x1(%rcx),%eax
  8028b1:	48 98                	cltq
  8028b3:	49 c7 04 c1 00 00 00 	movq   $0x0,(%r9,%rax,8)
  8028ba:	00 
    va_start(vl, arg0);
  8028bb:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  8028c2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8028c6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8028ca:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8028ce:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  8028d2:	85 c9                	test   %ecx,%ecx
  8028d4:	74 41                	je     802917 <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  8028d6:	49 89 c0             	mov    %rax,%r8
  8028d9:	49 8d 41 08          	lea    0x8(%r9),%rax
  8028dd:	8d 51 ff             	lea    -0x1(%rcx),%edx
  8028e0:	49 8d 74 d1 10       	lea    0x10(%r9,%rdx,8),%rsi
  8028e5:	eb 1b                	jmp    802902 <spawnl+0x121>
  8028e7:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8028eb:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  8028ef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8028f3:	48 8b 11             	mov    (%rcx),%rdx
  8028f6:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  8028f9:	48 83 c0 08          	add    $0x8,%rax
  8028fd:	48 39 f0             	cmp    %rsi,%rax
  802900:	74 15                	je     802917 <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  802902:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802905:	83 fa 2f             	cmp    $0x2f,%edx
  802908:	77 dd                	ja     8028e7 <spawnl+0x106>
  80290a:	89 d1                	mov    %edx,%ecx
  80290c:	4c 01 c1             	add    %r8,%rcx
  80290f:	83 c2 08             	add    $0x8,%edx
  802912:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802915:	eb dc                	jmp    8028f3 <spawnl+0x112>
    return spawn(prog, argv);
  802917:	4c 89 ce             	mov    %r9,%rsi
  80291a:	48 b8 f4 20 80 00 00 	movabs $0x8020f4,%rax
  802921:	00 00 00 
  802924:	ff d0                	call   *%rax
}
  802926:	c9                   	leave
  802927:	c3                   	ret

0000000000802928 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802928:	f3 0f 1e fa          	endbr64
  80292c:	55                   	push   %rbp
  80292d:	48 89 e5             	mov    %rsp,%rbp
  802930:	41 54                	push   %r12
  802932:	53                   	push   %rbx
  802933:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802936:	48 b8 0b 16 80 00 00 	movabs $0x80160b,%rax
  80293d:	00 00 00 
  802940:	ff d0                	call   *%rax
  802942:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802945:	48 be d9 42 80 00 00 	movabs $0x8042d9,%rsi
  80294c:	00 00 00 
  80294f:	48 89 df             	mov    %rbx,%rdi
  802952:	48 b8 2c 0c 80 00 00 	movabs $0x800c2c,%rax
  802959:	00 00 00 
  80295c:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80295e:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802963:	41 2b 04 24          	sub    (%r12),%eax
  802967:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80296d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802974:	00 00 00 
    stat->st_dev = &devpipe;
  802977:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  80297e:	00 00 00 
  802981:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802988:	b8 00 00 00 00       	mov    $0x0,%eax
  80298d:	5b                   	pop    %rbx
  80298e:	41 5c                	pop    %r12
  802990:	5d                   	pop    %rbp
  802991:	c3                   	ret

0000000000802992 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802992:	f3 0f 1e fa          	endbr64
  802996:	55                   	push   %rbp
  802997:	48 89 e5             	mov    %rsp,%rbp
  80299a:	41 54                	push   %r12
  80299c:	53                   	push   %rbx
  80299d:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8029a0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8029a5:	48 89 fe             	mov    %rdi,%rsi
  8029a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ad:	49 bc 71 13 80 00 00 	movabs $0x801371,%r12
  8029b4:	00 00 00 
  8029b7:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8029ba:	48 89 df             	mov    %rbx,%rdi
  8029bd:	48 b8 0b 16 80 00 00 	movabs $0x80160b,%rax
  8029c4:	00 00 00 
  8029c7:	ff d0                	call   *%rax
  8029c9:	48 89 c6             	mov    %rax,%rsi
  8029cc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8029d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8029d6:	41 ff d4             	call   *%r12
}
  8029d9:	5b                   	pop    %rbx
  8029da:	41 5c                	pop    %r12
  8029dc:	5d                   	pop    %rbp
  8029dd:	c3                   	ret

00000000008029de <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8029de:	f3 0f 1e fa          	endbr64
  8029e2:	55                   	push   %rbp
  8029e3:	48 89 e5             	mov    %rsp,%rbp
  8029e6:	41 57                	push   %r15
  8029e8:	41 56                	push   %r14
  8029ea:	41 55                	push   %r13
  8029ec:	41 54                	push   %r12
  8029ee:	53                   	push   %rbx
  8029ef:	48 83 ec 18          	sub    $0x18,%rsp
  8029f3:	49 89 fc             	mov    %rdi,%r12
  8029f6:	49 89 f5             	mov    %rsi,%r13
  8029f9:	49 89 d7             	mov    %rdx,%r15
  8029fc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802a00:	48 b8 0b 16 80 00 00 	movabs $0x80160b,%rax
  802a07:	00 00 00 
  802a0a:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802a0c:	4d 85 ff             	test   %r15,%r15
  802a0f:	0f 84 af 00 00 00    	je     802ac4 <devpipe_write+0xe6>
  802a15:	48 89 c3             	mov    %rax,%rbx
  802a18:	4c 89 f8             	mov    %r15,%rax
  802a1b:	4d 89 ef             	mov    %r13,%r15
  802a1e:	4c 01 e8             	add    %r13,%rax
  802a21:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802a25:	49 bd 01 12 80 00 00 	movabs $0x801201,%r13
  802a2c:	00 00 00 
            sys_yield();
  802a2f:	49 be 96 11 80 00 00 	movabs $0x801196,%r14
  802a36:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802a39:	8b 73 04             	mov    0x4(%rbx),%esi
  802a3c:	48 63 ce             	movslq %esi,%rcx
  802a3f:	48 63 03             	movslq (%rbx),%rax
  802a42:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802a48:	48 39 c1             	cmp    %rax,%rcx
  802a4b:	72 2e                	jb     802a7b <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802a4d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802a52:	48 89 da             	mov    %rbx,%rdx
  802a55:	be 00 10 00 00       	mov    $0x1000,%esi
  802a5a:	4c 89 e7             	mov    %r12,%rdi
  802a5d:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802a60:	85 c0                	test   %eax,%eax
  802a62:	74 66                	je     802aca <devpipe_write+0xec>
            sys_yield();
  802a64:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802a67:	8b 73 04             	mov    0x4(%rbx),%esi
  802a6a:	48 63 ce             	movslq %esi,%rcx
  802a6d:	48 63 03             	movslq (%rbx),%rax
  802a70:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802a76:	48 39 c1             	cmp    %rax,%rcx
  802a79:	73 d2                	jae    802a4d <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a7b:	41 0f b6 3f          	movzbl (%r15),%edi
  802a7f:	48 89 ca             	mov    %rcx,%rdx
  802a82:	48 c1 ea 03          	shr    $0x3,%rdx
  802a86:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802a8d:	08 10 20 
  802a90:	48 f7 e2             	mul    %rdx
  802a93:	48 c1 ea 06          	shr    $0x6,%rdx
  802a97:	48 89 d0             	mov    %rdx,%rax
  802a9a:	48 c1 e0 09          	shl    $0x9,%rax
  802a9e:	48 29 d0             	sub    %rdx,%rax
  802aa1:	48 c1 e0 03          	shl    $0x3,%rax
  802aa5:	48 29 c1             	sub    %rax,%rcx
  802aa8:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802aad:	83 c6 01             	add    $0x1,%esi
  802ab0:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802ab3:	49 83 c7 01          	add    $0x1,%r15
  802ab7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802abb:	49 39 c7             	cmp    %rax,%r15
  802abe:	0f 85 75 ff ff ff    	jne    802a39 <devpipe_write+0x5b>
    return n;
  802ac4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802ac8:	eb 05                	jmp    802acf <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802aca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802acf:	48 83 c4 18          	add    $0x18,%rsp
  802ad3:	5b                   	pop    %rbx
  802ad4:	41 5c                	pop    %r12
  802ad6:	41 5d                	pop    %r13
  802ad8:	41 5e                	pop    %r14
  802ada:	41 5f                	pop    %r15
  802adc:	5d                   	pop    %rbp
  802add:	c3                   	ret

0000000000802ade <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802ade:	f3 0f 1e fa          	endbr64
  802ae2:	55                   	push   %rbp
  802ae3:	48 89 e5             	mov    %rsp,%rbp
  802ae6:	41 57                	push   %r15
  802ae8:	41 56                	push   %r14
  802aea:	41 55                	push   %r13
  802aec:	41 54                	push   %r12
  802aee:	53                   	push   %rbx
  802aef:	48 83 ec 18          	sub    $0x18,%rsp
  802af3:	49 89 fc             	mov    %rdi,%r12
  802af6:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802afa:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802afe:	48 b8 0b 16 80 00 00 	movabs $0x80160b,%rax
  802b05:	00 00 00 
  802b08:	ff d0                	call   *%rax
  802b0a:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802b0d:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802b13:	49 bd 01 12 80 00 00 	movabs $0x801201,%r13
  802b1a:	00 00 00 
            sys_yield();
  802b1d:	49 be 96 11 80 00 00 	movabs $0x801196,%r14
  802b24:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802b27:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802b2c:	74 7d                	je     802bab <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802b2e:	8b 03                	mov    (%rbx),%eax
  802b30:	3b 43 04             	cmp    0x4(%rbx),%eax
  802b33:	75 26                	jne    802b5b <devpipe_read+0x7d>
            if (i > 0) return i;
  802b35:	4d 85 ff             	test   %r15,%r15
  802b38:	75 77                	jne    802bb1 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802b3a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802b3f:	48 89 da             	mov    %rbx,%rdx
  802b42:	be 00 10 00 00       	mov    $0x1000,%esi
  802b47:	4c 89 e7             	mov    %r12,%rdi
  802b4a:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802b4d:	85 c0                	test   %eax,%eax
  802b4f:	74 72                	je     802bc3 <devpipe_read+0xe5>
            sys_yield();
  802b51:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802b54:	8b 03                	mov    (%rbx),%eax
  802b56:	3b 43 04             	cmp    0x4(%rbx),%eax
  802b59:	74 df                	je     802b3a <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802b5b:	48 63 c8             	movslq %eax,%rcx
  802b5e:	48 89 ca             	mov    %rcx,%rdx
  802b61:	48 c1 ea 03          	shr    $0x3,%rdx
  802b65:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802b6c:	08 10 20 
  802b6f:	48 89 d0             	mov    %rdx,%rax
  802b72:	48 f7 e6             	mul    %rsi
  802b75:	48 c1 ea 06          	shr    $0x6,%rdx
  802b79:	48 89 d0             	mov    %rdx,%rax
  802b7c:	48 c1 e0 09          	shl    $0x9,%rax
  802b80:	48 29 d0             	sub    %rdx,%rax
  802b83:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802b8a:	00 
  802b8b:	48 89 c8             	mov    %rcx,%rax
  802b8e:	48 29 d0             	sub    %rdx,%rax
  802b91:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802b96:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802b9a:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802b9e:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802ba1:	49 83 c7 01          	add    $0x1,%r15
  802ba5:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802ba9:	75 83                	jne    802b2e <devpipe_read+0x50>
    return n;
  802bab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802baf:	eb 03                	jmp    802bb4 <devpipe_read+0xd6>
            if (i > 0) return i;
  802bb1:	4c 89 f8             	mov    %r15,%rax
}
  802bb4:	48 83 c4 18          	add    $0x18,%rsp
  802bb8:	5b                   	pop    %rbx
  802bb9:	41 5c                	pop    %r12
  802bbb:	41 5d                	pop    %r13
  802bbd:	41 5e                	pop    %r14
  802bbf:	41 5f                	pop    %r15
  802bc1:	5d                   	pop    %rbp
  802bc2:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802bc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc8:	eb ea                	jmp    802bb4 <devpipe_read+0xd6>

0000000000802bca <pipe>:
pipe(int pfd[2]) {
  802bca:	f3 0f 1e fa          	endbr64
  802bce:	55                   	push   %rbp
  802bcf:	48 89 e5             	mov    %rsp,%rbp
  802bd2:	41 55                	push   %r13
  802bd4:	41 54                	push   %r12
  802bd6:	53                   	push   %rbx
  802bd7:	48 83 ec 18          	sub    $0x18,%rsp
  802bdb:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802bde:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802be2:	48 b8 2b 16 80 00 00 	movabs $0x80162b,%rax
  802be9:	00 00 00 
  802bec:	ff d0                	call   *%rax
  802bee:	89 c3                	mov    %eax,%ebx
  802bf0:	85 c0                	test   %eax,%eax
  802bf2:	0f 88 a0 01 00 00    	js     802d98 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802bf8:	b9 46 00 00 00       	mov    $0x46,%ecx
  802bfd:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c02:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802c06:	bf 00 00 00 00       	mov    $0x0,%edi
  802c0b:	48 b8 31 12 80 00 00 	movabs $0x801231,%rax
  802c12:	00 00 00 
  802c15:	ff d0                	call   *%rax
  802c17:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	0f 88 77 01 00 00    	js     802d98 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802c21:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802c25:	48 b8 2b 16 80 00 00 	movabs $0x80162b,%rax
  802c2c:	00 00 00 
  802c2f:	ff d0                	call   *%rax
  802c31:	89 c3                	mov    %eax,%ebx
  802c33:	85 c0                	test   %eax,%eax
  802c35:	0f 88 43 01 00 00    	js     802d7e <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802c3b:	b9 46 00 00 00       	mov    $0x46,%ecx
  802c40:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c45:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c49:	bf 00 00 00 00       	mov    $0x0,%edi
  802c4e:	48 b8 31 12 80 00 00 	movabs $0x801231,%rax
  802c55:	00 00 00 
  802c58:	ff d0                	call   *%rax
  802c5a:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802c5c:	85 c0                	test   %eax,%eax
  802c5e:	0f 88 1a 01 00 00    	js     802d7e <pipe+0x1b4>
    va = fd2data(fd0);
  802c64:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802c68:	48 b8 0b 16 80 00 00 	movabs $0x80160b,%rax
  802c6f:	00 00 00 
  802c72:	ff d0                	call   *%rax
  802c74:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802c77:	b9 46 00 00 00       	mov    $0x46,%ecx
  802c7c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c81:	48 89 c6             	mov    %rax,%rsi
  802c84:	bf 00 00 00 00       	mov    $0x0,%edi
  802c89:	48 b8 31 12 80 00 00 	movabs $0x801231,%rax
  802c90:	00 00 00 
  802c93:	ff d0                	call   *%rax
  802c95:	89 c3                	mov    %eax,%ebx
  802c97:	85 c0                	test   %eax,%eax
  802c99:	0f 88 c5 00 00 00    	js     802d64 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802c9f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802ca3:	48 b8 0b 16 80 00 00 	movabs $0x80160b,%rax
  802caa:	00 00 00 
  802cad:	ff d0                	call   *%rax
  802caf:	48 89 c1             	mov    %rax,%rcx
  802cb2:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802cb8:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802cbe:	ba 00 00 00 00       	mov    $0x0,%edx
  802cc3:	4c 89 ee             	mov    %r13,%rsi
  802cc6:	bf 00 00 00 00       	mov    $0x0,%edi
  802ccb:	48 b8 9c 12 80 00 00 	movabs $0x80129c,%rax
  802cd2:	00 00 00 
  802cd5:	ff d0                	call   *%rax
  802cd7:	89 c3                	mov    %eax,%ebx
  802cd9:	85 c0                	test   %eax,%eax
  802cdb:	78 6e                	js     802d4b <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802cdd:	be 00 10 00 00       	mov    $0x1000,%esi
  802ce2:	4c 89 ef             	mov    %r13,%rdi
  802ce5:	48 b8 cb 11 80 00 00 	movabs $0x8011cb,%rax
  802cec:	00 00 00 
  802cef:	ff d0                	call   *%rax
  802cf1:	83 f8 02             	cmp    $0x2,%eax
  802cf4:	0f 85 ab 00 00 00    	jne    802da5 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802cfa:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  802d01:	00 00 
  802d03:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d07:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802d09:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d0d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802d14:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802d18:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802d1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d1e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802d25:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802d29:	48 bb f5 15 80 00 00 	movabs $0x8015f5,%rbx
  802d30:	00 00 00 
  802d33:	ff d3                	call   *%rbx
  802d35:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802d39:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802d3d:	ff d3                	call   *%rbx
  802d3f:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802d44:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d49:	eb 4d                	jmp    802d98 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802d4b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d50:	4c 89 ee             	mov    %r13,%rsi
  802d53:	bf 00 00 00 00       	mov    $0x0,%edi
  802d58:	48 b8 71 13 80 00 00 	movabs $0x801371,%rax
  802d5f:	00 00 00 
  802d62:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802d64:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d69:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d6d:	bf 00 00 00 00       	mov    $0x0,%edi
  802d72:	48 b8 71 13 80 00 00 	movabs $0x801371,%rax
  802d79:	00 00 00 
  802d7c:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802d7e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d83:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802d87:	bf 00 00 00 00       	mov    $0x0,%edi
  802d8c:	48 b8 71 13 80 00 00 	movabs $0x801371,%rax
  802d93:	00 00 00 
  802d96:	ff d0                	call   *%rax
}
  802d98:	89 d8                	mov    %ebx,%eax
  802d9a:	48 83 c4 18          	add    $0x18,%rsp
  802d9e:	5b                   	pop    %rbx
  802d9f:	41 5c                	pop    %r12
  802da1:	41 5d                	pop    %r13
  802da3:	5d                   	pop    %rbp
  802da4:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802da5:	48 b9 30 44 80 00 00 	movabs $0x804430,%rcx
  802dac:	00 00 00 
  802daf:	48 ba 4b 42 80 00 00 	movabs $0x80424b,%rdx
  802db6:	00 00 00 
  802db9:	be 2e 00 00 00       	mov    $0x2e,%esi
  802dbe:	48 bf e0 42 80 00 00 	movabs $0x8042e0,%rdi
  802dc5:	00 00 00 
  802dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcd:	49 b8 87 01 80 00 00 	movabs $0x800187,%r8
  802dd4:	00 00 00 
  802dd7:	41 ff d0             	call   *%r8

0000000000802dda <pipeisclosed>:
pipeisclosed(int fdnum) {
  802dda:	f3 0f 1e fa          	endbr64
  802dde:	55                   	push   %rbp
  802ddf:	48 89 e5             	mov    %rsp,%rbp
  802de2:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802de6:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802dea:	48 b8 8f 16 80 00 00 	movabs $0x80168f,%rax
  802df1:	00 00 00 
  802df4:	ff d0                	call   *%rax
    if (res < 0) return res;
  802df6:	85 c0                	test   %eax,%eax
  802df8:	78 35                	js     802e2f <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802dfa:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802dfe:	48 b8 0b 16 80 00 00 	movabs $0x80160b,%rax
  802e05:	00 00 00 
  802e08:	ff d0                	call   *%rax
  802e0a:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802e0d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802e12:	be 00 10 00 00       	mov    $0x1000,%esi
  802e17:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802e1b:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  802e22:	00 00 00 
  802e25:	ff d0                	call   *%rax
  802e27:	85 c0                	test   %eax,%eax
  802e29:	0f 94 c0             	sete   %al
  802e2c:	0f b6 c0             	movzbl %al,%eax
}
  802e2f:	c9                   	leave
  802e30:	c3                   	ret

0000000000802e31 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802e31:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802e35:	48 89 f8             	mov    %rdi,%rax
  802e38:	48 c1 e8 27          	shr    $0x27,%rax
  802e3c:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802e43:	7f 00 00 
  802e46:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802e4a:	f6 c2 01             	test   $0x1,%dl
  802e4d:	74 6d                	je     802ebc <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802e4f:	48 89 f8             	mov    %rdi,%rax
  802e52:	48 c1 e8 1e          	shr    $0x1e,%rax
  802e56:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802e5d:	7f 00 00 
  802e60:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802e64:	f6 c2 01             	test   $0x1,%dl
  802e67:	74 62                	je     802ecb <get_uvpt_entry+0x9a>
  802e69:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802e70:	7f 00 00 
  802e73:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802e77:	f6 c2 80             	test   $0x80,%dl
  802e7a:	75 4f                	jne    802ecb <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802e7c:	48 89 f8             	mov    %rdi,%rax
  802e7f:	48 c1 e8 15          	shr    $0x15,%rax
  802e83:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802e8a:	7f 00 00 
  802e8d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802e91:	f6 c2 01             	test   $0x1,%dl
  802e94:	74 44                	je     802eda <get_uvpt_entry+0xa9>
  802e96:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802e9d:	7f 00 00 
  802ea0:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802ea4:	f6 c2 80             	test   $0x80,%dl
  802ea7:	75 31                	jne    802eda <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802ea9:	48 c1 ef 0c          	shr    $0xc,%rdi
  802ead:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802eb4:	7f 00 00 
  802eb7:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802ebb:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802ebc:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802ec3:	7f 00 00 
  802ec6:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802eca:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802ecb:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802ed2:	7f 00 00 
  802ed5:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802ed9:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802eda:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802ee1:	7f 00 00 
  802ee4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802ee8:	c3                   	ret

0000000000802ee9 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802ee9:	f3 0f 1e fa          	endbr64
  802eed:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802ef0:	48 89 f9             	mov    %rdi,%rcx
  802ef3:	48 c1 e9 27          	shr    $0x27,%rcx
  802ef7:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802efe:	7f 00 00 
  802f01:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802f05:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802f0c:	f6 c1 01             	test   $0x1,%cl
  802f0f:	0f 84 b2 00 00 00    	je     802fc7 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802f15:	48 89 f9             	mov    %rdi,%rcx
  802f18:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802f1c:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802f23:	7f 00 00 
  802f26:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802f2a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802f31:	40 f6 c6 01          	test   $0x1,%sil
  802f35:	0f 84 8c 00 00 00    	je     802fc7 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802f3b:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802f42:	7f 00 00 
  802f45:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802f49:	a8 80                	test   $0x80,%al
  802f4b:	75 7b                	jne    802fc8 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802f4d:	48 89 f9             	mov    %rdi,%rcx
  802f50:	48 c1 e9 15          	shr    $0x15,%rcx
  802f54:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802f5b:	7f 00 00 
  802f5e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802f62:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802f69:	40 f6 c6 01          	test   $0x1,%sil
  802f6d:	74 58                	je     802fc7 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802f6f:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802f76:	7f 00 00 
  802f79:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802f7d:	a8 80                	test   $0x80,%al
  802f7f:	75 6c                	jne    802fed <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802f81:	48 89 f9             	mov    %rdi,%rcx
  802f84:	48 c1 e9 0c          	shr    $0xc,%rcx
  802f88:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802f8f:	7f 00 00 
  802f92:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802f96:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802f9d:	40 f6 c6 01          	test   $0x1,%sil
  802fa1:	74 24                	je     802fc7 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802fa3:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802faa:	7f 00 00 
  802fad:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802fb1:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802fb8:	ff ff 7f 
  802fbb:	48 21 c8             	and    %rcx,%rax
  802fbe:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802fc4:	48 09 d0             	or     %rdx,%rax
}
  802fc7:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802fc8:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802fcf:	7f 00 00 
  802fd2:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802fd6:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802fdd:	ff ff 7f 
  802fe0:	48 21 c8             	and    %rcx,%rax
  802fe3:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802fe9:	48 01 d0             	add    %rdx,%rax
  802fec:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802fed:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802ff4:	7f 00 00 
  802ff7:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802ffb:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  803002:	ff ff 7f 
  803005:	48 21 c8             	and    %rcx,%rax
  803008:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  80300e:	48 01 d0             	add    %rdx,%rax
  803011:	c3                   	ret

0000000000803012 <get_prot>:

int
get_prot(void *va) {
  803012:	f3 0f 1e fa          	endbr64
  803016:	55                   	push   %rbp
  803017:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80301a:	48 b8 31 2e 80 00 00 	movabs $0x802e31,%rax
  803021:	00 00 00 
  803024:	ff d0                	call   *%rax
  803026:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  803029:	83 e0 01             	and    $0x1,%eax
  80302c:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80302f:	89 d1                	mov    %edx,%ecx
  803031:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  803037:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  803039:	89 c1                	mov    %eax,%ecx
  80303b:	83 c9 02             	or     $0x2,%ecx
  80303e:	f6 c2 02             	test   $0x2,%dl
  803041:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  803044:	89 c1                	mov    %eax,%ecx
  803046:	83 c9 01             	or     $0x1,%ecx
  803049:	48 85 d2             	test   %rdx,%rdx
  80304c:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80304f:	89 c1                	mov    %eax,%ecx
  803051:	83 c9 40             	or     $0x40,%ecx
  803054:	f6 c6 04             	test   $0x4,%dh
  803057:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80305a:	5d                   	pop    %rbp
  80305b:	c3                   	ret

000000000080305c <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80305c:	f3 0f 1e fa          	endbr64
  803060:	55                   	push   %rbp
  803061:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803064:	48 b8 31 2e 80 00 00 	movabs $0x802e31,%rax
  80306b:	00 00 00 
  80306e:	ff d0                	call   *%rax
    return pte & PTE_D;
  803070:	48 c1 e8 06          	shr    $0x6,%rax
  803074:	83 e0 01             	and    $0x1,%eax
}
  803077:	5d                   	pop    %rbp
  803078:	c3                   	ret

0000000000803079 <is_page_present>:

bool
is_page_present(void *va) {
  803079:	f3 0f 1e fa          	endbr64
  80307d:	55                   	push   %rbp
  80307e:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  803081:	48 b8 31 2e 80 00 00 	movabs $0x802e31,%rax
  803088:	00 00 00 
  80308b:	ff d0                	call   *%rax
  80308d:	83 e0 01             	and    $0x1,%eax
}
  803090:	5d                   	pop    %rbp
  803091:	c3                   	ret

0000000000803092 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  803092:	f3 0f 1e fa          	endbr64
  803096:	55                   	push   %rbp
  803097:	48 89 e5             	mov    %rsp,%rbp
  80309a:	41 57                	push   %r15
  80309c:	41 56                	push   %r14
  80309e:	41 55                	push   %r13
  8030a0:	41 54                	push   %r12
  8030a2:	53                   	push   %rbx
  8030a3:	48 83 ec 18          	sub    $0x18,%rsp
  8030a7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8030ab:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8030af:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8030b4:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8030bb:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8030be:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8030c5:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8030c8:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8030cf:	00 00 00 
  8030d2:	eb 73                	jmp    803147 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8030d4:	48 89 d8             	mov    %rbx,%rax
  8030d7:	48 c1 e8 15          	shr    $0x15,%rax
  8030db:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8030e2:	7f 00 00 
  8030e5:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8030e9:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8030ef:	f6 c2 01             	test   $0x1,%dl
  8030f2:	74 4b                	je     80313f <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8030f4:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8030f8:	f6 c2 80             	test   $0x80,%dl
  8030fb:	74 11                	je     80310e <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8030fd:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  803101:	f6 c4 04             	test   $0x4,%ah
  803104:	74 39                	je     80313f <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  803106:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  80310c:	eb 20                	jmp    80312e <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80310e:	48 89 da             	mov    %rbx,%rdx
  803111:	48 c1 ea 0c          	shr    $0xc,%rdx
  803115:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80311c:	7f 00 00 
  80311f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  803123:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  803129:	f6 c4 04             	test   $0x4,%ah
  80312c:	74 11                	je     80313f <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  80312e:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  803132:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803136:	48 89 df             	mov    %rbx,%rdi
  803139:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80313d:	ff d0                	call   *%rax
    next:
        va += size;
  80313f:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  803142:	49 39 df             	cmp    %rbx,%r15
  803145:	72 3e                	jb     803185 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  803147:	49 8b 06             	mov    (%r14),%rax
  80314a:	a8 01                	test   $0x1,%al
  80314c:	74 37                	je     803185 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80314e:	48 89 d8             	mov    %rbx,%rax
  803151:	48 c1 e8 1e          	shr    $0x1e,%rax
  803155:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  80315a:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803160:	f6 c2 01             	test   $0x1,%dl
  803163:	74 da                	je     80313f <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  803165:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  80316a:	f6 c2 80             	test   $0x80,%dl
  80316d:	0f 84 61 ff ff ff    	je     8030d4 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  803173:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  803178:	f6 c4 04             	test   $0x4,%ah
  80317b:	74 c2                	je     80313f <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  80317d:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  803183:	eb a9                	jmp    80312e <foreach_shared_region+0x9c>
    }
    return res;
}
  803185:	b8 00 00 00 00       	mov    $0x0,%eax
  80318a:	48 83 c4 18          	add    $0x18,%rsp
  80318e:	5b                   	pop    %rbx
  80318f:	41 5c                	pop    %r12
  803191:	41 5d                	pop    %r13
  803193:	41 5e                	pop    %r14
  803195:	41 5f                	pop    %r15
  803197:	5d                   	pop    %rbp
  803198:	c3                   	ret

0000000000803199 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  803199:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  80319d:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a2:	c3                   	ret

00000000008031a3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8031a3:	f3 0f 1e fa          	endbr64
  8031a7:	55                   	push   %rbp
  8031a8:	48 89 e5             	mov    %rsp,%rbp
  8031ab:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8031ae:	48 be f0 42 80 00 00 	movabs $0x8042f0,%rsi
  8031b5:	00 00 00 
  8031b8:	48 b8 2c 0c 80 00 00 	movabs $0x800c2c,%rax
  8031bf:	00 00 00 
  8031c2:	ff d0                	call   *%rax
    return 0;
}
  8031c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c9:	5d                   	pop    %rbp
  8031ca:	c3                   	ret

00000000008031cb <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8031cb:	f3 0f 1e fa          	endbr64
  8031cf:	55                   	push   %rbp
  8031d0:	48 89 e5             	mov    %rsp,%rbp
  8031d3:	41 57                	push   %r15
  8031d5:	41 56                	push   %r14
  8031d7:	41 55                	push   %r13
  8031d9:	41 54                	push   %r12
  8031db:	53                   	push   %rbx
  8031dc:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8031e3:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8031ea:	48 85 d2             	test   %rdx,%rdx
  8031ed:	74 7a                	je     803269 <devcons_write+0x9e>
  8031ef:	49 89 d6             	mov    %rdx,%r14
  8031f2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8031f8:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8031fd:	49 bf 47 0e 80 00 00 	movabs $0x800e47,%r15
  803204:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  803207:	4c 89 f3             	mov    %r14,%rbx
  80320a:	48 29 f3             	sub    %rsi,%rbx
  80320d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803212:	48 39 c3             	cmp    %rax,%rbx
  803215:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  803219:	4c 63 eb             	movslq %ebx,%r13
  80321c:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  803223:	48 01 c6             	add    %rax,%rsi
  803226:	4c 89 ea             	mov    %r13,%rdx
  803229:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  803230:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  803233:	4c 89 ee             	mov    %r13,%rsi
  803236:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  80323d:	48 b8 8c 10 80 00 00 	movabs $0x80108c,%rax
  803244:	00 00 00 
  803247:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  803249:	41 01 dc             	add    %ebx,%r12d
  80324c:	49 63 f4             	movslq %r12d,%rsi
  80324f:	4c 39 f6             	cmp    %r14,%rsi
  803252:	72 b3                	jb     803207 <devcons_write+0x3c>
    return res;
  803254:	49 63 c4             	movslq %r12d,%rax
}
  803257:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80325e:	5b                   	pop    %rbx
  80325f:	41 5c                	pop    %r12
  803261:	41 5d                	pop    %r13
  803263:	41 5e                	pop    %r14
  803265:	41 5f                	pop    %r15
  803267:	5d                   	pop    %rbp
  803268:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  803269:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80326f:	eb e3                	jmp    803254 <devcons_write+0x89>

0000000000803271 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  803271:	f3 0f 1e fa          	endbr64
  803275:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  803278:	ba 00 00 00 00       	mov    $0x0,%edx
  80327d:	48 85 c0             	test   %rax,%rax
  803280:	74 55                	je     8032d7 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  803282:	55                   	push   %rbp
  803283:	48 89 e5             	mov    %rsp,%rbp
  803286:	41 55                	push   %r13
  803288:	41 54                	push   %r12
  80328a:	53                   	push   %rbx
  80328b:	48 83 ec 08          	sub    $0x8,%rsp
  80328f:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  803292:	48 bb bd 10 80 00 00 	movabs $0x8010bd,%rbx
  803299:	00 00 00 
  80329c:	49 bc 96 11 80 00 00 	movabs $0x801196,%r12
  8032a3:	00 00 00 
  8032a6:	eb 03                	jmp    8032ab <devcons_read+0x3a>
  8032a8:	41 ff d4             	call   *%r12
  8032ab:	ff d3                	call   *%rbx
  8032ad:	85 c0                	test   %eax,%eax
  8032af:	74 f7                	je     8032a8 <devcons_read+0x37>
    if (c < 0) return c;
  8032b1:	48 63 d0             	movslq %eax,%rdx
  8032b4:	78 13                	js     8032c9 <devcons_read+0x58>
    if (c == 0x04) return 0;
  8032b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8032bb:	83 f8 04             	cmp    $0x4,%eax
  8032be:	74 09                	je     8032c9 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  8032c0:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8032c4:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8032c9:	48 89 d0             	mov    %rdx,%rax
  8032cc:	48 83 c4 08          	add    $0x8,%rsp
  8032d0:	5b                   	pop    %rbx
  8032d1:	41 5c                	pop    %r12
  8032d3:	41 5d                	pop    %r13
  8032d5:	5d                   	pop    %rbp
  8032d6:	c3                   	ret
  8032d7:	48 89 d0             	mov    %rdx,%rax
  8032da:	c3                   	ret

00000000008032db <cputchar>:
cputchar(int ch) {
  8032db:	f3 0f 1e fa          	endbr64
  8032df:	55                   	push   %rbp
  8032e0:	48 89 e5             	mov    %rsp,%rbp
  8032e3:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8032e7:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8032eb:	be 01 00 00 00       	mov    $0x1,%esi
  8032f0:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8032f4:	48 b8 8c 10 80 00 00 	movabs $0x80108c,%rax
  8032fb:	00 00 00 
  8032fe:	ff d0                	call   *%rax
}
  803300:	c9                   	leave
  803301:	c3                   	ret

0000000000803302 <getchar>:
getchar(void) {
  803302:	f3 0f 1e fa          	endbr64
  803306:	55                   	push   %rbp
  803307:	48 89 e5             	mov    %rsp,%rbp
  80330a:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  80330e:	ba 01 00 00 00       	mov    $0x1,%edx
  803313:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  803317:	bf 00 00 00 00       	mov    $0x0,%edi
  80331c:	48 b8 8a 19 80 00 00 	movabs $0x80198a,%rax
  803323:	00 00 00 
  803326:	ff d0                	call   *%rax
  803328:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  80332a:	85 c0                	test   %eax,%eax
  80332c:	78 06                	js     803334 <getchar+0x32>
  80332e:	74 08                	je     803338 <getchar+0x36>
  803330:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  803334:	89 d0                	mov    %edx,%eax
  803336:	c9                   	leave
  803337:	c3                   	ret
    return res < 0 ? res : res ? c :
  803338:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  80333d:	eb f5                	jmp    803334 <getchar+0x32>

000000000080333f <iscons>:
iscons(int fdnum) {
  80333f:	f3 0f 1e fa          	endbr64
  803343:	55                   	push   %rbp
  803344:	48 89 e5             	mov    %rsp,%rbp
  803347:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80334b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80334f:	48 b8 8f 16 80 00 00 	movabs $0x80168f,%rax
  803356:	00 00 00 
  803359:	ff d0                	call   *%rax
    if (res < 0) return res;
  80335b:	85 c0                	test   %eax,%eax
  80335d:	78 18                	js     803377 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  80335f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803363:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  80336a:	00 00 00 
  80336d:	8b 00                	mov    (%rax),%eax
  80336f:	39 02                	cmp    %eax,(%rdx)
  803371:	0f 94 c0             	sete   %al
  803374:	0f b6 c0             	movzbl %al,%eax
}
  803377:	c9                   	leave
  803378:	c3                   	ret

0000000000803379 <opencons>:
opencons(void) {
  803379:	f3 0f 1e fa          	endbr64
  80337d:	55                   	push   %rbp
  80337e:	48 89 e5             	mov    %rsp,%rbp
  803381:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  803385:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  803389:	48 b8 2b 16 80 00 00 	movabs $0x80162b,%rax
  803390:	00 00 00 
  803393:	ff d0                	call   *%rax
  803395:	85 c0                	test   %eax,%eax
  803397:	78 49                	js     8033e2 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  803399:	b9 46 00 00 00       	mov    $0x46,%ecx
  80339e:	ba 00 10 00 00       	mov    $0x1000,%edx
  8033a3:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  8033a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ac:	48 b8 31 12 80 00 00 	movabs $0x801231,%rax
  8033b3:	00 00 00 
  8033b6:	ff d0                	call   *%rax
  8033b8:	85 c0                	test   %eax,%eax
  8033ba:	78 26                	js     8033e2 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  8033bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033c0:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  8033c7:	00 00 
  8033c9:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  8033cb:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8033cf:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  8033d6:	48 b8 f5 15 80 00 00 	movabs $0x8015f5,%rax
  8033dd:	00 00 00 
  8033e0:	ff d0                	call   *%rax
}
  8033e2:	c9                   	leave
  8033e3:	c3                   	ret

00000000008033e4 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  8033e4:	f3 0f 1e fa          	endbr64
  8033e8:	55                   	push   %rbp
  8033e9:	48 89 e5             	mov    %rsp,%rbp
  8033ec:	41 54                	push   %r12
  8033ee:	53                   	push   %rbx
  8033ef:	48 89 fb             	mov    %rdi,%rbx
  8033f2:	48 89 f7             	mov    %rsi,%rdi
  8033f5:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8033f8:	48 85 f6             	test   %rsi,%rsi
  8033fb:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803402:	00 00 00 
  803405:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  803409:	be 00 10 00 00       	mov    $0x1000,%esi
  80340e:	48 b8 53 15 80 00 00 	movabs $0x801553,%rax
  803415:	00 00 00 
  803418:	ff d0                	call   *%rax
    if (res < 0) {
  80341a:	85 c0                	test   %eax,%eax
  80341c:	78 45                	js     803463 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  80341e:	48 85 db             	test   %rbx,%rbx
  803421:	74 12                	je     803435 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  803423:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80342a:	00 00 00 
  80342d:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  803433:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  803435:	4d 85 e4             	test   %r12,%r12
  803438:	74 14                	je     80344e <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  80343a:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803441:	00 00 00 
  803444:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  80344a:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  80344e:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803455:	00 00 00 
  803458:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  80345e:	5b                   	pop    %rbx
  80345f:	41 5c                	pop    %r12
  803461:	5d                   	pop    %rbp
  803462:	c3                   	ret
        if (from_env_store != NULL) {
  803463:	48 85 db             	test   %rbx,%rbx
  803466:	74 06                	je     80346e <ipc_recv+0x8a>
            *from_env_store = 0;
  803468:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  80346e:	4d 85 e4             	test   %r12,%r12
  803471:	74 eb                	je     80345e <ipc_recv+0x7a>
            *perm_store = 0;
  803473:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  80347a:	00 
  80347b:	eb e1                	jmp    80345e <ipc_recv+0x7a>

000000000080347d <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  80347d:	f3 0f 1e fa          	endbr64
  803481:	55                   	push   %rbp
  803482:	48 89 e5             	mov    %rsp,%rbp
  803485:	41 57                	push   %r15
  803487:	41 56                	push   %r14
  803489:	41 55                	push   %r13
  80348b:	41 54                	push   %r12
  80348d:	53                   	push   %rbx
  80348e:	48 83 ec 18          	sub    $0x18,%rsp
  803492:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  803495:	48 89 d3             	mov    %rdx,%rbx
  803498:	49 89 cc             	mov    %rcx,%r12
  80349b:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  80349e:	48 85 d2             	test   %rdx,%rdx
  8034a1:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8034a8:	00 00 00 
  8034ab:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8034af:	89 f0                	mov    %esi,%eax
  8034b1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8034b5:	48 89 da             	mov    %rbx,%rdx
  8034b8:	48 89 c6             	mov    %rax,%rsi
  8034bb:	48 b8 23 15 80 00 00 	movabs $0x801523,%rax
  8034c2:	00 00 00 
  8034c5:	ff d0                	call   *%rax
    while (res < 0) {
  8034c7:	85 c0                	test   %eax,%eax
  8034c9:	79 65                	jns    803530 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  8034cb:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8034ce:	75 33                	jne    803503 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  8034d0:	49 bf 96 11 80 00 00 	movabs $0x801196,%r15
  8034d7:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8034da:	49 be 23 15 80 00 00 	movabs $0x801523,%r14
  8034e1:	00 00 00 
        sys_yield();
  8034e4:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8034e7:	45 89 e8             	mov    %r13d,%r8d
  8034ea:	4c 89 e1             	mov    %r12,%rcx
  8034ed:	48 89 da             	mov    %rbx,%rdx
  8034f0:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8034f4:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  8034f7:	41 ff d6             	call   *%r14
    while (res < 0) {
  8034fa:	85 c0                	test   %eax,%eax
  8034fc:	79 32                	jns    803530 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  8034fe:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803501:	74 e1                	je     8034e4 <ipc_send+0x67>
            panic("Error: %i\n", res);
  803503:	89 c1                	mov    %eax,%ecx
  803505:	48 ba fc 42 80 00 00 	movabs $0x8042fc,%rdx
  80350c:	00 00 00 
  80350f:	be 42 00 00 00       	mov    $0x42,%esi
  803514:	48 bf 07 43 80 00 00 	movabs $0x804307,%rdi
  80351b:	00 00 00 
  80351e:	b8 00 00 00 00       	mov    $0x0,%eax
  803523:	49 b8 87 01 80 00 00 	movabs $0x800187,%r8
  80352a:	00 00 00 
  80352d:	41 ff d0             	call   *%r8
    }
}
  803530:	48 83 c4 18          	add    $0x18,%rsp
  803534:	5b                   	pop    %rbx
  803535:	41 5c                	pop    %r12
  803537:	41 5d                	pop    %r13
  803539:	41 5e                	pop    %r14
  80353b:	41 5f                	pop    %r15
  80353d:	5d                   	pop    %rbp
  80353e:	c3                   	ret

000000000080353f <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  80353f:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  803543:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  803548:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  80354f:	00 00 00 
  803552:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803556:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80355a:	48 c1 e2 04          	shl    $0x4,%rdx
  80355e:	48 01 ca             	add    %rcx,%rdx
  803561:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  803567:	39 fa                	cmp    %edi,%edx
  803569:	74 12                	je     80357d <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  80356b:	48 83 c0 01          	add    $0x1,%rax
  80356f:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  803575:	75 db                	jne    803552 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  803577:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80357c:	c3                   	ret
            return envs[i].env_id;
  80357d:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803581:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803585:	48 c1 e2 04          	shl    $0x4,%rdx
  803589:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  803590:	00 00 00 
  803593:	48 01 d0             	add    %rdx,%rax
  803596:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80359c:	c3                   	ret

000000000080359d <__text_end>:
  80359d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a4:	00 00 00 
  8035a7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ae:	00 00 00 
  8035b1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b8:	00 00 00 
  8035bb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035c2:	00 00 00 
  8035c5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035cc:	00 00 00 
  8035cf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035d6:	00 00 00 
  8035d9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035e0:	00 00 00 
  8035e3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ea:	00 00 00 
  8035ed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035f4:	00 00 00 
  8035f7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035fe:	00 00 00 
  803601:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803608:	00 00 00 
  80360b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803612:	00 00 00 
  803615:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80361c:	00 00 00 
  80361f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803626:	00 00 00 
  803629:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803630:	00 00 00 
  803633:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80363a:	00 00 00 
  80363d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803644:	00 00 00 
  803647:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80364e:	00 00 00 
  803651:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803658:	00 00 00 
  80365b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803662:	00 00 00 
  803665:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80366c:	00 00 00 
  80366f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803676:	00 00 00 
  803679:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803680:	00 00 00 
  803683:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80368a:	00 00 00 
  80368d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803694:	00 00 00 
  803697:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80369e:	00 00 00 
  8036a1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036a8:	00 00 00 
  8036ab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036b2:	00 00 00 
  8036b5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036bc:	00 00 00 
  8036bf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036c6:	00 00 00 
  8036c9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036d0:	00 00 00 
  8036d3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036da:	00 00 00 
  8036dd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036e4:	00 00 00 
  8036e7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ee:	00 00 00 
  8036f1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036f8:	00 00 00 
  8036fb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803702:	00 00 00 
  803705:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80370c:	00 00 00 
  80370f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803716:	00 00 00 
  803719:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803720:	00 00 00 
  803723:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80372a:	00 00 00 
  80372d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803734:	00 00 00 
  803737:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80373e:	00 00 00 
  803741:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803748:	00 00 00 
  80374b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803752:	00 00 00 
  803755:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80375c:	00 00 00 
  80375f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803766:	00 00 00 
  803769:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803770:	00 00 00 
  803773:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80377a:	00 00 00 
  80377d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803784:	00 00 00 
  803787:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80378e:	00 00 00 
  803791:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803798:	00 00 00 
  80379b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a2:	00 00 00 
  8037a5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ac:	00 00 00 
  8037af:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b6:	00 00 00 
  8037b9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c0:	00 00 00 
  8037c3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ca:	00 00 00 
  8037cd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d4:	00 00 00 
  8037d7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037de:	00 00 00 
  8037e1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e8:	00 00 00 
  8037eb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f2:	00 00 00 
  8037f5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037fc:	00 00 00 
  8037ff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803806:	00 00 00 
  803809:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803810:	00 00 00 
  803813:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80381a:	00 00 00 
  80381d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803824:	00 00 00 
  803827:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80382e:	00 00 00 
  803831:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803838:	00 00 00 
  80383b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803842:	00 00 00 
  803845:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80384c:	00 00 00 
  80384f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803856:	00 00 00 
  803859:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803860:	00 00 00 
  803863:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80386a:	00 00 00 
  80386d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803874:	00 00 00 
  803877:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80387e:	00 00 00 
  803881:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803888:	00 00 00 
  80388b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803892:	00 00 00 
  803895:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80389c:	00 00 00 
  80389f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a6:	00 00 00 
  8038a9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b0:	00 00 00 
  8038b3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ba:	00 00 00 
  8038bd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c4:	00 00 00 
  8038c7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ce:	00 00 00 
  8038d1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d8:	00 00 00 
  8038db:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e2:	00 00 00 
  8038e5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ec:	00 00 00 
  8038ef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f6:	00 00 00 
  8038f9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803900:	00 00 00 
  803903:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80390a:	00 00 00 
  80390d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803914:	00 00 00 
  803917:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80391e:	00 00 00 
  803921:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803928:	00 00 00 
  80392b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803932:	00 00 00 
  803935:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80393c:	00 00 00 
  80393f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803946:	00 00 00 
  803949:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803950:	00 00 00 
  803953:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80395a:	00 00 00 
  80395d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803964:	00 00 00 
  803967:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80396e:	00 00 00 
  803971:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803978:	00 00 00 
  80397b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803982:	00 00 00 
  803985:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80398c:	00 00 00 
  80398f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803996:	00 00 00 
  803999:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a0:	00 00 00 
  8039a3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039aa:	00 00 00 
  8039ad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b4:	00 00 00 
  8039b7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039be:	00 00 00 
  8039c1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c8:	00 00 00 
  8039cb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d2:	00 00 00 
  8039d5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039dc:	00 00 00 
  8039df:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e6:	00 00 00 
  8039e9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f0:	00 00 00 
  8039f3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039fa:	00 00 00 
  8039fd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a04:	00 00 00 
  803a07:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a0e:	00 00 00 
  803a11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a18:	00 00 00 
  803a1b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a22:	00 00 00 
  803a25:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a2c:	00 00 00 
  803a2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a36:	00 00 00 
  803a39:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a40:	00 00 00 
  803a43:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a4a:	00 00 00 
  803a4d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a54:	00 00 00 
  803a57:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a5e:	00 00 00 
  803a61:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a68:	00 00 00 
  803a6b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a72:	00 00 00 
  803a75:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a7c:	00 00 00 
  803a7f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a86:	00 00 00 
  803a89:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a90:	00 00 00 
  803a93:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a9a:	00 00 00 
  803a9d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa4:	00 00 00 
  803aa7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aae:	00 00 00 
  803ab1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab8:	00 00 00 
  803abb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac2:	00 00 00 
  803ac5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803acc:	00 00 00 
  803acf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad6:	00 00 00 
  803ad9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae0:	00 00 00 
  803ae3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aea:	00 00 00 
  803aed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af4:	00 00 00 
  803af7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803afe:	00 00 00 
  803b01:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b08:	00 00 00 
  803b0b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b12:	00 00 00 
  803b15:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b1c:	00 00 00 
  803b1f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b26:	00 00 00 
  803b29:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b30:	00 00 00 
  803b33:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b3a:	00 00 00 
  803b3d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b44:	00 00 00 
  803b47:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b4e:	00 00 00 
  803b51:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b58:	00 00 00 
  803b5b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b62:	00 00 00 
  803b65:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b6c:	00 00 00 
  803b6f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b76:	00 00 00 
  803b79:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b80:	00 00 00 
  803b83:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b8a:	00 00 00 
  803b8d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b94:	00 00 00 
  803b97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b9e:	00 00 00 
  803ba1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba8:	00 00 00 
  803bab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb2:	00 00 00 
  803bb5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bbc:	00 00 00 
  803bbf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc6:	00 00 00 
  803bc9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd0:	00 00 00 
  803bd3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bda:	00 00 00 
  803bdd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be4:	00 00 00 
  803be7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bee:	00 00 00 
  803bf1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf8:	00 00 00 
  803bfb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c02:	00 00 00 
  803c05:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c0c:	00 00 00 
  803c0f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c16:	00 00 00 
  803c19:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c20:	00 00 00 
  803c23:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c2a:	00 00 00 
  803c2d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c34:	00 00 00 
  803c37:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c3e:	00 00 00 
  803c41:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c48:	00 00 00 
  803c4b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c52:	00 00 00 
  803c55:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c5c:	00 00 00 
  803c5f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c66:	00 00 00 
  803c69:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c70:	00 00 00 
  803c73:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c7a:	00 00 00 
  803c7d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c84:	00 00 00 
  803c87:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c8e:	00 00 00 
  803c91:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c98:	00 00 00 
  803c9b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca2:	00 00 00 
  803ca5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cac:	00 00 00 
  803caf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb6:	00 00 00 
  803cb9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc0:	00 00 00 
  803cc3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cca:	00 00 00 
  803ccd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd4:	00 00 00 
  803cd7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cde:	00 00 00 
  803ce1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce8:	00 00 00 
  803ceb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf2:	00 00 00 
  803cf5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cfc:	00 00 00 
  803cff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d06:	00 00 00 
  803d09:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d10:	00 00 00 
  803d13:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d1a:	00 00 00 
  803d1d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d24:	00 00 00 
  803d27:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d2e:	00 00 00 
  803d31:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d38:	00 00 00 
  803d3b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d42:	00 00 00 
  803d45:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d4c:	00 00 00 
  803d4f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d56:	00 00 00 
  803d59:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d60:	00 00 00 
  803d63:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d6a:	00 00 00 
  803d6d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d74:	00 00 00 
  803d77:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d7e:	00 00 00 
  803d81:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d88:	00 00 00 
  803d8b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d92:	00 00 00 
  803d95:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d9c:	00 00 00 
  803d9f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da6:	00 00 00 
  803da9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db0:	00 00 00 
  803db3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dba:	00 00 00 
  803dbd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc4:	00 00 00 
  803dc7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dce:	00 00 00 
  803dd1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd8:	00 00 00 
  803ddb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de2:	00 00 00 
  803de5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dec:	00 00 00 
  803def:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df6:	00 00 00 
  803df9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e00:	00 00 00 
  803e03:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e0a:	00 00 00 
  803e0d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e14:	00 00 00 
  803e17:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e1e:	00 00 00 
  803e21:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e28:	00 00 00 
  803e2b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e32:	00 00 00 
  803e35:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e3c:	00 00 00 
  803e3f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e46:	00 00 00 
  803e49:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e50:	00 00 00 
  803e53:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e5a:	00 00 00 
  803e5d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e64:	00 00 00 
  803e67:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e6e:	00 00 00 
  803e71:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e78:	00 00 00 
  803e7b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e82:	00 00 00 
  803e85:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e8c:	00 00 00 
  803e8f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e96:	00 00 00 
  803e99:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea0:	00 00 00 
  803ea3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eaa:	00 00 00 
  803ead:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb4:	00 00 00 
  803eb7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ebe:	00 00 00 
  803ec1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec8:	00 00 00 
  803ecb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed2:	00 00 00 
  803ed5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803edc:	00 00 00 
  803edf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee6:	00 00 00 
  803ee9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef0:	00 00 00 
  803ef3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803efa:	00 00 00 
  803efd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f04:	00 00 00 
  803f07:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f0e:	00 00 00 
  803f11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f18:	00 00 00 
  803f1b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f22:	00 00 00 
  803f25:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f2c:	00 00 00 
  803f2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f36:	00 00 00 
  803f39:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f40:	00 00 00 
  803f43:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f4a:	00 00 00 
  803f4d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f54:	00 00 00 
  803f57:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f5e:	00 00 00 
  803f61:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f68:	00 00 00 
  803f6b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f72:	00 00 00 
  803f75:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f7c:	00 00 00 
  803f7f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f86:	00 00 00 
  803f89:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f90:	00 00 00 
  803f93:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f9a:	00 00 00 
  803f9d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa4:	00 00 00 
  803fa7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fae:	00 00 00 
  803fb1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb8:	00 00 00 
  803fbb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc2:	00 00 00 
  803fc5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fcc:	00 00 00 
  803fcf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd6:	00 00 00 
  803fd9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe0:	00 00 00 
  803fe3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fea:	00 00 00 
  803fed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff4:	00 00 00 
  803ff7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  803ffe:	00 00 
