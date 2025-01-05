
obj/user/spawninit:     file format elf64-x86-64


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
  80001e:	e8 a1 00 00 00       	call   8000c4 <libmain>
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
  80004c:	48 ba f9 02 80 00 00 	movabs $0x8002f9,%rdx
  800053:	00 00 00 
  800056:	ff d2                	call   *%rdx
    if ((r = spawnl("init", "init", "one", "two", 0)) < 0)
  800058:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80005e:	48 b9 1e 40 80 00 00 	movabs $0x80401e,%rcx
  800065:	00 00 00 
  800068:	48 ba 22 40 80 00 00 	movabs $0x804022,%rdx
  80006f:	00 00 00 
  800072:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800079:	00 00 00 
  80007c:	48 89 fe             	mov    %rdi,%rsi
  80007f:	b8 00 00 00 00       	mov    $0x0,%eax
  800084:	49 b9 f7 27 80 00 00 	movabs $0x8027f7,%r9
  80008b:	00 00 00 
  80008e:	41 ff d1             	call   *%r9
  800091:	85 c0                	test   %eax,%eax
  800093:	78 02                	js     800097 <umain+0x72>
        panic("spawnl(init) failed: %i", r);
}
  800095:	5d                   	pop    %rbp
  800096:	c3                   	ret
        panic("spawnl(init) failed: %i", r);
  800097:	89 c1                	mov    %eax,%ecx
  800099:	48 ba 2b 40 80 00 00 	movabs $0x80402b,%rdx
  8000a0:	00 00 00 
  8000a3:	be 08 00 00 00       	mov    $0x8,%esi
  8000a8:	48 bf 43 40 80 00 00 	movabs $0x804043,%rdi
  8000af:	00 00 00 
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	49 b8 9d 01 80 00 00 	movabs $0x80019d,%r8
  8000be:	00 00 00 
  8000c1:	41 ff d0             	call   *%r8

00000000008000c4 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8000c4:	f3 0f 1e fa          	endbr64
  8000c8:	55                   	push   %rbp
  8000c9:	48 89 e5             	mov    %rsp,%rbp
  8000cc:	41 56                	push   %r14
  8000ce:	41 55                	push   %r13
  8000d0:	41 54                	push   %r12
  8000d2:	53                   	push   %rbx
  8000d3:	41 89 fd             	mov    %edi,%r13d
  8000d6:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8000d9:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  8000e0:	00 00 00 
  8000e3:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  8000ea:	00 00 00 
  8000ed:	48 39 c2             	cmp    %rax,%rdx
  8000f0:	73 17                	jae    800109 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8000f2:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8000f5:	49 89 c4             	mov    %rax,%r12
  8000f8:	48 83 c3 08          	add    $0x8,%rbx
  8000fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800101:	ff 53 f8             	call   *-0x8(%rbx)
  800104:	4c 39 e3             	cmp    %r12,%rbx
  800107:	72 ef                	jb     8000f8 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800109:	48 b8 77 11 80 00 00 	movabs $0x801177,%rax
  800110:	00 00 00 
  800113:	ff d0                	call   *%rax
  800115:	25 ff 03 00 00       	and    $0x3ff,%eax
  80011a:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80011e:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800122:	48 c1 e0 04          	shl    $0x4,%rax
  800126:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  80012d:	00 00 00 
  800130:	48 01 d0             	add    %rdx,%rax
  800133:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  80013a:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80013d:	45 85 ed             	test   %r13d,%r13d
  800140:	7e 0d                	jle    80014f <libmain+0x8b>
  800142:	49 8b 06             	mov    (%r14),%rax
  800145:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80014c:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80014f:	4c 89 f6             	mov    %r14,%rsi
  800152:	44 89 ef             	mov    %r13d,%edi
  800155:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80015c:	00 00 00 
  80015f:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800161:	48 b8 76 01 80 00 00 	movabs $0x800176,%rax
  800168:	00 00 00 
  80016b:	ff d0                	call   *%rax
#endif
}
  80016d:	5b                   	pop    %rbx
  80016e:	41 5c                	pop    %r12
  800170:	41 5d                	pop    %r13
  800172:	41 5e                	pop    %r14
  800174:	5d                   	pop    %rbp
  800175:	c3                   	ret

0000000000800176 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800176:	f3 0f 1e fa          	endbr64
  80017a:	55                   	push   %rbp
  80017b:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80017e:	48 b8 4d 18 80 00 00 	movabs $0x80184d,%rax
  800185:	00 00 00 
  800188:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80018a:	bf 00 00 00 00       	mov    $0x0,%edi
  80018f:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  800196:	00 00 00 
  800199:	ff d0                	call   *%rax
}
  80019b:	5d                   	pop    %rbp
  80019c:	c3                   	ret

000000000080019d <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80019d:	f3 0f 1e fa          	endbr64
  8001a1:	55                   	push   %rbp
  8001a2:	48 89 e5             	mov    %rsp,%rbp
  8001a5:	41 56                	push   %r14
  8001a7:	41 55                	push   %r13
  8001a9:	41 54                	push   %r12
  8001ab:	53                   	push   %rbx
  8001ac:	48 83 ec 50          	sub    $0x50,%rsp
  8001b0:	49 89 fc             	mov    %rdi,%r12
  8001b3:	41 89 f5             	mov    %esi,%r13d
  8001b6:	48 89 d3             	mov    %rdx,%rbx
  8001b9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8001bd:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8001c1:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8001c5:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8001cc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8001d0:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8001d4:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8001d8:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8001dc:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001e3:	00 00 00 
  8001e6:	4c 8b 30             	mov    (%rax),%r14
  8001e9:	48 b8 77 11 80 00 00 	movabs $0x801177,%rax
  8001f0:	00 00 00 
  8001f3:	ff d0                	call   *%rax
  8001f5:	89 c6                	mov    %eax,%esi
  8001f7:	45 89 e8             	mov    %r13d,%r8d
  8001fa:	4c 89 e1             	mov    %r12,%rcx
  8001fd:	4c 89 f2             	mov    %r14,%rdx
  800200:	48 bf 18 43 80 00 00 	movabs $0x804318,%rdi
  800207:	00 00 00 
  80020a:	b8 00 00 00 00       	mov    $0x0,%eax
  80020f:	49 bc f9 02 80 00 00 	movabs $0x8002f9,%r12
  800216:	00 00 00 
  800219:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  80021c:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800220:	48 89 df             	mov    %rbx,%rdi
  800223:	48 b8 91 02 80 00 00 	movabs $0x800291,%rax
  80022a:	00 00 00 
  80022d:	ff d0                	call   *%rax
    cprintf("\n");
  80022f:	48 bf 15 42 80 00 00 	movabs $0x804215,%rdi
  800236:	00 00 00 
  800239:	b8 00 00 00 00       	mov    $0x0,%eax
  80023e:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800241:	cc                   	int3
  800242:	eb fd                	jmp    800241 <_panic+0xa4>

0000000000800244 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800244:	f3 0f 1e fa          	endbr64
  800248:	55                   	push   %rbp
  800249:	48 89 e5             	mov    %rsp,%rbp
  80024c:	53                   	push   %rbx
  80024d:	48 83 ec 08          	sub    $0x8,%rsp
  800251:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800254:	8b 06                	mov    (%rsi),%eax
  800256:	8d 50 01             	lea    0x1(%rax),%edx
  800259:	89 16                	mov    %edx,(%rsi)
  80025b:	48 98                	cltq
  80025d:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800262:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800268:	74 0a                	je     800274 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80026a:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80026e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800272:	c9                   	leave
  800273:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800274:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800278:	be ff 00 00 00       	mov    $0xff,%esi
  80027d:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  800284:	00 00 00 
  800287:	ff d0                	call   *%rax
        state->offset = 0;
  800289:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80028f:	eb d9                	jmp    80026a <putch+0x26>

0000000000800291 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800291:	f3 0f 1e fa          	endbr64
  800295:	55                   	push   %rbp
  800296:	48 89 e5             	mov    %rsp,%rbp
  800299:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8002a0:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8002a3:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8002aa:	b9 21 00 00 00       	mov    $0x21,%ecx
  8002af:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b4:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8002b7:	48 89 f1             	mov    %rsi,%rcx
  8002ba:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8002c1:	48 bf 44 02 80 00 00 	movabs $0x800244,%rdi
  8002c8:	00 00 00 
  8002cb:	48 b8 59 04 80 00 00 	movabs $0x800459,%rax
  8002d2:	00 00 00 
  8002d5:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8002d7:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8002de:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8002e5:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  8002ec:	00 00 00 
  8002ef:	ff d0                	call   *%rax

    return state.count;
}
  8002f1:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8002f7:	c9                   	leave
  8002f8:	c3                   	ret

00000000008002f9 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8002f9:	f3 0f 1e fa          	endbr64
  8002fd:	55                   	push   %rbp
  8002fe:	48 89 e5             	mov    %rsp,%rbp
  800301:	48 83 ec 50          	sub    $0x50,%rsp
  800305:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800309:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80030d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800311:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800315:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800319:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800320:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800324:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800328:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80032c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800330:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800334:	48 b8 91 02 80 00 00 	movabs $0x800291,%rax
  80033b:	00 00 00 
  80033e:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800340:	c9                   	leave
  800341:	c3                   	ret

0000000000800342 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800342:	f3 0f 1e fa          	endbr64
  800346:	55                   	push   %rbp
  800347:	48 89 e5             	mov    %rsp,%rbp
  80034a:	41 57                	push   %r15
  80034c:	41 56                	push   %r14
  80034e:	41 55                	push   %r13
  800350:	41 54                	push   %r12
  800352:	53                   	push   %rbx
  800353:	48 83 ec 18          	sub    $0x18,%rsp
  800357:	49 89 fc             	mov    %rdi,%r12
  80035a:	49 89 f5             	mov    %rsi,%r13
  80035d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800361:	8b 45 10             	mov    0x10(%rbp),%eax
  800364:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800367:	41 89 cf             	mov    %ecx,%r15d
  80036a:	4c 39 fa             	cmp    %r15,%rdx
  80036d:	73 5b                	jae    8003ca <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80036f:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800373:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800377:	85 db                	test   %ebx,%ebx
  800379:	7e 0e                	jle    800389 <print_num+0x47>
            putch(padc, put_arg);
  80037b:	4c 89 ee             	mov    %r13,%rsi
  80037e:	44 89 f7             	mov    %r14d,%edi
  800381:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800384:	83 eb 01             	sub    $0x1,%ebx
  800387:	75 f2                	jne    80037b <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800389:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80038d:	48 b9 6f 40 80 00 00 	movabs $0x80406f,%rcx
  800394:	00 00 00 
  800397:	48 b8 5e 40 80 00 00 	movabs $0x80405e,%rax
  80039e:	00 00 00 
  8003a1:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8003a5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8003a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ae:	49 f7 f7             	div    %r15
  8003b1:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8003b5:	4c 89 ee             	mov    %r13,%rsi
  8003b8:	41 ff d4             	call   *%r12
}
  8003bb:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8003bf:	5b                   	pop    %rbx
  8003c0:	41 5c                	pop    %r12
  8003c2:	41 5d                	pop    %r13
  8003c4:	41 5e                	pop    %r14
  8003c6:	41 5f                	pop    %r15
  8003c8:	5d                   	pop    %rbp
  8003c9:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8003ca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8003ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d3:	49 f7 f7             	div    %r15
  8003d6:	48 83 ec 08          	sub    $0x8,%rsp
  8003da:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8003de:	52                   	push   %rdx
  8003df:	45 0f be c9          	movsbl %r9b,%r9d
  8003e3:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8003e7:	48 89 c2             	mov    %rax,%rdx
  8003ea:	48 b8 42 03 80 00 00 	movabs $0x800342,%rax
  8003f1:	00 00 00 
  8003f4:	ff d0                	call   *%rax
  8003f6:	48 83 c4 10          	add    $0x10,%rsp
  8003fa:	eb 8d                	jmp    800389 <print_num+0x47>

00000000008003fc <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8003fc:	f3 0f 1e fa          	endbr64
    state->count++;
  800400:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800404:	48 8b 06             	mov    (%rsi),%rax
  800407:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80040b:	73 0a                	jae    800417 <sprintputch+0x1b>
        *state->start++ = ch;
  80040d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800411:	48 89 16             	mov    %rdx,(%rsi)
  800414:	40 88 38             	mov    %dil,(%rax)
    }
}
  800417:	c3                   	ret

0000000000800418 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800418:	f3 0f 1e fa          	endbr64
  80041c:	55                   	push   %rbp
  80041d:	48 89 e5             	mov    %rsp,%rbp
  800420:	48 83 ec 50          	sub    $0x50,%rsp
  800424:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800428:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80042c:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800430:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800437:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80043b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80043f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800443:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800447:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80044b:	48 b8 59 04 80 00 00 	movabs $0x800459,%rax
  800452:	00 00 00 
  800455:	ff d0                	call   *%rax
}
  800457:	c9                   	leave
  800458:	c3                   	ret

0000000000800459 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800459:	f3 0f 1e fa          	endbr64
  80045d:	55                   	push   %rbp
  80045e:	48 89 e5             	mov    %rsp,%rbp
  800461:	41 57                	push   %r15
  800463:	41 56                	push   %r14
  800465:	41 55                	push   %r13
  800467:	41 54                	push   %r12
  800469:	53                   	push   %rbx
  80046a:	48 83 ec 38          	sub    $0x38,%rsp
  80046e:	49 89 fe             	mov    %rdi,%r14
  800471:	49 89 f5             	mov    %rsi,%r13
  800474:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800477:	48 8b 01             	mov    (%rcx),%rax
  80047a:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80047e:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800482:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800486:	48 8b 41 10          	mov    0x10(%rcx),%rax
  80048a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80048e:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800492:	0f b6 3b             	movzbl (%rbx),%edi
  800495:	40 80 ff 25          	cmp    $0x25,%dil
  800499:	74 18                	je     8004b3 <vprintfmt+0x5a>
            if (!ch) return;
  80049b:	40 84 ff             	test   %dil,%dil
  80049e:	0f 84 b2 06 00 00    	je     800b56 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8004a4:	40 0f b6 ff          	movzbl %dil,%edi
  8004a8:	4c 89 ee             	mov    %r13,%rsi
  8004ab:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8004ae:	4c 89 e3             	mov    %r12,%rbx
  8004b1:	eb db                	jmp    80048e <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8004b3:	be 00 00 00 00       	mov    $0x0,%esi
  8004b8:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8004bc:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8004c1:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8004c7:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8004ce:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8004d2:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8004d7:	41 0f b6 04 24       	movzbl (%r12),%eax
  8004dc:	88 45 a0             	mov    %al,-0x60(%rbp)
  8004df:	83 e8 23             	sub    $0x23,%eax
  8004e2:	3c 57                	cmp    $0x57,%al
  8004e4:	0f 87 52 06 00 00    	ja     800b3c <vprintfmt+0x6e3>
  8004ea:	0f b6 c0             	movzbl %al,%eax
  8004ed:	48 b9 60 44 80 00 00 	movabs $0x804460,%rcx
  8004f4:	00 00 00 
  8004f7:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8004fb:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8004fe:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  800502:	eb ce                	jmp    8004d2 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800504:	49 89 dc             	mov    %rbx,%r12
  800507:	be 01 00 00 00       	mov    $0x1,%esi
  80050c:	eb c4                	jmp    8004d2 <vprintfmt+0x79>
            padc = ch;
  80050e:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800512:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800515:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800518:	eb b8                	jmp    8004d2 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80051a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80051d:	83 f8 2f             	cmp    $0x2f,%eax
  800520:	77 24                	ja     800546 <vprintfmt+0xed>
  800522:	89 c1                	mov    %eax,%ecx
  800524:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800528:	83 c0 08             	add    $0x8,%eax
  80052b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80052e:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800531:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800534:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800538:	79 98                	jns    8004d2 <vprintfmt+0x79>
                width = precision;
  80053a:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  80053e:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800544:	eb 8c                	jmp    8004d2 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800546:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80054a:	48 8d 41 08          	lea    0x8(%rcx),%rax
  80054e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800552:	eb da                	jmp    80052e <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800554:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800559:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80055d:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800563:	3c 39                	cmp    $0x39,%al
  800565:	77 1c                	ja     800583 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800567:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  80056b:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80056f:	0f b6 c0             	movzbl %al,%eax
  800572:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800577:	0f b6 03             	movzbl (%rbx),%eax
  80057a:	3c 39                	cmp    $0x39,%al
  80057c:	76 e9                	jbe    800567 <vprintfmt+0x10e>
        process_precision:
  80057e:	49 89 dc             	mov    %rbx,%r12
  800581:	eb b1                	jmp    800534 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800583:	49 89 dc             	mov    %rbx,%r12
  800586:	eb ac                	jmp    800534 <vprintfmt+0xdb>
            width = MAX(0, width);
  800588:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  80058b:	85 c9                	test   %ecx,%ecx
  80058d:	b8 00 00 00 00       	mov    $0x0,%eax
  800592:	0f 49 c1             	cmovns %ecx,%eax
  800595:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800598:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80059b:	e9 32 ff ff ff       	jmp    8004d2 <vprintfmt+0x79>
            lflag++;
  8005a0:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8005a3:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8005a6:	e9 27 ff ff ff       	jmp    8004d2 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8005ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005ae:	83 f8 2f             	cmp    $0x2f,%eax
  8005b1:	77 19                	ja     8005cc <vprintfmt+0x173>
  8005b3:	89 c2                	mov    %eax,%edx
  8005b5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8005b9:	83 c0 08             	add    $0x8,%eax
  8005bc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005bf:	8b 3a                	mov    (%rdx),%edi
  8005c1:	4c 89 ee             	mov    %r13,%rsi
  8005c4:	41 ff d6             	call   *%r14
            break;
  8005c7:	e9 c2 fe ff ff       	jmp    80048e <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8005cc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005d0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005d4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005d8:	eb e5                	jmp    8005bf <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8005da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005dd:	83 f8 2f             	cmp    $0x2f,%eax
  8005e0:	77 5a                	ja     80063c <vprintfmt+0x1e3>
  8005e2:	89 c2                	mov    %eax,%edx
  8005e4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8005e8:	83 c0 08             	add    $0x8,%eax
  8005eb:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8005ee:	8b 02                	mov    (%rdx),%eax
  8005f0:	89 c1                	mov    %eax,%ecx
  8005f2:	f7 d9                	neg    %ecx
  8005f4:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8005f7:	83 f9 13             	cmp    $0x13,%ecx
  8005fa:	7f 4e                	jg     80064a <vprintfmt+0x1f1>
  8005fc:	48 63 c1             	movslq %ecx,%rax
  8005ff:	48 ba 20 47 80 00 00 	movabs $0x804720,%rdx
  800606:	00 00 00 
  800609:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80060d:	48 85 c0             	test   %rax,%rax
  800610:	74 38                	je     80064a <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  800612:	48 89 c1             	mov    %rax,%rcx
  800615:	48 ba 63 42 80 00 00 	movabs $0x804263,%rdx
  80061c:	00 00 00 
  80061f:	4c 89 ee             	mov    %r13,%rsi
  800622:	4c 89 f7             	mov    %r14,%rdi
  800625:	b8 00 00 00 00       	mov    $0x0,%eax
  80062a:	49 b8 18 04 80 00 00 	movabs $0x800418,%r8
  800631:	00 00 00 
  800634:	41 ff d0             	call   *%r8
  800637:	e9 52 fe ff ff       	jmp    80048e <vprintfmt+0x35>
            int err = va_arg(aq, int);
  80063c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800640:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800644:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800648:	eb a4                	jmp    8005ee <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  80064a:	48 ba 87 40 80 00 00 	movabs $0x804087,%rdx
  800651:	00 00 00 
  800654:	4c 89 ee             	mov    %r13,%rsi
  800657:	4c 89 f7             	mov    %r14,%rdi
  80065a:	b8 00 00 00 00       	mov    $0x0,%eax
  80065f:	49 b8 18 04 80 00 00 	movabs $0x800418,%r8
  800666:	00 00 00 
  800669:	41 ff d0             	call   *%r8
  80066c:	e9 1d fe ff ff       	jmp    80048e <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800671:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800674:	83 f8 2f             	cmp    $0x2f,%eax
  800677:	77 6c                	ja     8006e5 <vprintfmt+0x28c>
  800679:	89 c2                	mov    %eax,%edx
  80067b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80067f:	83 c0 08             	add    $0x8,%eax
  800682:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800685:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800688:	48 85 d2             	test   %rdx,%rdx
  80068b:	48 b8 80 40 80 00 00 	movabs $0x804080,%rax
  800692:	00 00 00 
  800695:	48 0f 45 c2          	cmovne %rdx,%rax
  800699:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  80069d:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8006a1:	7e 06                	jle    8006a9 <vprintfmt+0x250>
  8006a3:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8006a7:	75 4a                	jne    8006f3 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8006a9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8006ad:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8006b1:	0f b6 00             	movzbl (%rax),%eax
  8006b4:	84 c0                	test   %al,%al
  8006b6:	0f 85 9a 00 00 00    	jne    800756 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8006bc:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006bf:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8006c3:	85 c0                	test   %eax,%eax
  8006c5:	0f 8e c3 fd ff ff    	jle    80048e <vprintfmt+0x35>
  8006cb:	4c 89 ee             	mov    %r13,%rsi
  8006ce:	bf 20 00 00 00       	mov    $0x20,%edi
  8006d3:	41 ff d6             	call   *%r14
  8006d6:	41 83 ec 01          	sub    $0x1,%r12d
  8006da:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8006de:	75 eb                	jne    8006cb <vprintfmt+0x272>
  8006e0:	e9 a9 fd ff ff       	jmp    80048e <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8006e5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006e9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006ed:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006f1:	eb 92                	jmp    800685 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8006f3:	49 63 f7             	movslq %r15d,%rsi
  8006f6:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8006fa:	48 b8 1c 0c 80 00 00 	movabs $0x800c1c,%rax
  800701:	00 00 00 
  800704:	ff d0                	call   *%rax
  800706:	48 89 c2             	mov    %rax,%rdx
  800709:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80070c:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80070e:	8d 70 ff             	lea    -0x1(%rax),%esi
  800711:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800714:	85 c0                	test   %eax,%eax
  800716:	7e 91                	jle    8006a9 <vprintfmt+0x250>
  800718:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80071d:	4c 89 ee             	mov    %r13,%rsi
  800720:	44 89 e7             	mov    %r12d,%edi
  800723:	41 ff d6             	call   *%r14
  800726:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80072a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80072d:	83 f8 ff             	cmp    $0xffffffff,%eax
  800730:	75 eb                	jne    80071d <vprintfmt+0x2c4>
  800732:	e9 72 ff ff ff       	jmp    8006a9 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800737:	0f b6 f8             	movzbl %al,%edi
  80073a:	4c 89 ee             	mov    %r13,%rsi
  80073d:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800740:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800744:	49 83 c4 01          	add    $0x1,%r12
  800748:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  80074e:	84 c0                	test   %al,%al
  800750:	0f 84 66 ff ff ff    	je     8006bc <vprintfmt+0x263>
  800756:	45 85 ff             	test   %r15d,%r15d
  800759:	78 0a                	js     800765 <vprintfmt+0x30c>
  80075b:	41 83 ef 01          	sub    $0x1,%r15d
  80075f:	0f 88 57 ff ff ff    	js     8006bc <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800765:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800769:	74 cc                	je     800737 <vprintfmt+0x2de>
  80076b:	8d 50 e0             	lea    -0x20(%rax),%edx
  80076e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800773:	80 fa 5e             	cmp    $0x5e,%dl
  800776:	77 c2                	ja     80073a <vprintfmt+0x2e1>
  800778:	eb bd                	jmp    800737 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  80077a:	40 84 f6             	test   %sil,%sil
  80077d:	75 26                	jne    8007a5 <vprintfmt+0x34c>
    switch (lflag) {
  80077f:	85 d2                	test   %edx,%edx
  800781:	74 59                	je     8007dc <vprintfmt+0x383>
  800783:	83 fa 01             	cmp    $0x1,%edx
  800786:	74 7b                	je     800803 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800788:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80078b:	83 f8 2f             	cmp    $0x2f,%eax
  80078e:	0f 87 96 00 00 00    	ja     80082a <vprintfmt+0x3d1>
  800794:	89 c2                	mov    %eax,%edx
  800796:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80079a:	83 c0 08             	add    $0x8,%eax
  80079d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007a0:	4c 8b 22             	mov    (%rdx),%r12
  8007a3:	eb 17                	jmp    8007bc <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8007a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a8:	83 f8 2f             	cmp    $0x2f,%eax
  8007ab:	77 21                	ja     8007ce <vprintfmt+0x375>
  8007ad:	89 c2                	mov    %eax,%edx
  8007af:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007b3:	83 c0 08             	add    $0x8,%eax
  8007b6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007b9:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8007bc:	4d 85 e4             	test   %r12,%r12
  8007bf:	78 7a                	js     80083b <vprintfmt+0x3e2>
            num = i;
  8007c1:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8007c4:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8007c9:	e9 50 02 00 00       	jmp    800a1e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8007ce:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007d2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007d6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007da:	eb dd                	jmp    8007b9 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8007dc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007df:	83 f8 2f             	cmp    $0x2f,%eax
  8007e2:	77 11                	ja     8007f5 <vprintfmt+0x39c>
  8007e4:	89 c2                	mov    %eax,%edx
  8007e6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007ea:	83 c0 08             	add    $0x8,%eax
  8007ed:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007f0:	4c 63 22             	movslq (%rdx),%r12
  8007f3:	eb c7                	jmp    8007bc <vprintfmt+0x363>
  8007f5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007f9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007fd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800801:	eb ed                	jmp    8007f0 <vprintfmt+0x397>
        return va_arg(*ap, long);
  800803:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800806:	83 f8 2f             	cmp    $0x2f,%eax
  800809:	77 11                	ja     80081c <vprintfmt+0x3c3>
  80080b:	89 c2                	mov    %eax,%edx
  80080d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800811:	83 c0 08             	add    $0x8,%eax
  800814:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800817:	4c 8b 22             	mov    (%rdx),%r12
  80081a:	eb a0                	jmp    8007bc <vprintfmt+0x363>
  80081c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800820:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800824:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800828:	eb ed                	jmp    800817 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  80082a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80082e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800832:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800836:	e9 65 ff ff ff       	jmp    8007a0 <vprintfmt+0x347>
                putch('-', put_arg);
  80083b:	4c 89 ee             	mov    %r13,%rsi
  80083e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800843:	41 ff d6             	call   *%r14
                i = -i;
  800846:	49 f7 dc             	neg    %r12
  800849:	e9 73 ff ff ff       	jmp    8007c1 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  80084e:	40 84 f6             	test   %sil,%sil
  800851:	75 32                	jne    800885 <vprintfmt+0x42c>
    switch (lflag) {
  800853:	85 d2                	test   %edx,%edx
  800855:	74 5d                	je     8008b4 <vprintfmt+0x45b>
  800857:	83 fa 01             	cmp    $0x1,%edx
  80085a:	0f 84 82 00 00 00    	je     8008e2 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800860:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800863:	83 f8 2f             	cmp    $0x2f,%eax
  800866:	0f 87 a5 00 00 00    	ja     800911 <vprintfmt+0x4b8>
  80086c:	89 c2                	mov    %eax,%edx
  80086e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800872:	83 c0 08             	add    $0x8,%eax
  800875:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800878:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80087b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800880:	e9 99 01 00 00       	jmp    800a1e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800885:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800888:	83 f8 2f             	cmp    $0x2f,%eax
  80088b:	77 19                	ja     8008a6 <vprintfmt+0x44d>
  80088d:	89 c2                	mov    %eax,%edx
  80088f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800893:	83 c0 08             	add    $0x8,%eax
  800896:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800899:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80089c:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8008a1:	e9 78 01 00 00       	jmp    800a1e <vprintfmt+0x5c5>
  8008a6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008aa:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008ae:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008b2:	eb e5                	jmp    800899 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8008b4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b7:	83 f8 2f             	cmp    $0x2f,%eax
  8008ba:	77 18                	ja     8008d4 <vprintfmt+0x47b>
  8008bc:	89 c2                	mov    %eax,%edx
  8008be:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008c2:	83 c0 08             	add    $0x8,%eax
  8008c5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008c8:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8008ca:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8008cf:	e9 4a 01 00 00       	jmp    800a1e <vprintfmt+0x5c5>
  8008d4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008d8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008dc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008e0:	eb e6                	jmp    8008c8 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8008e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e5:	83 f8 2f             	cmp    $0x2f,%eax
  8008e8:	77 19                	ja     800903 <vprintfmt+0x4aa>
  8008ea:	89 c2                	mov    %eax,%edx
  8008ec:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008f0:	83 c0 08             	add    $0x8,%eax
  8008f3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008f6:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8008f9:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8008fe:	e9 1b 01 00 00       	jmp    800a1e <vprintfmt+0x5c5>
  800903:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800907:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80090b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80090f:	eb e5                	jmp    8008f6 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800911:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800915:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800919:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80091d:	e9 56 ff ff ff       	jmp    800878 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800922:	40 84 f6             	test   %sil,%sil
  800925:	75 2e                	jne    800955 <vprintfmt+0x4fc>
    switch (lflag) {
  800927:	85 d2                	test   %edx,%edx
  800929:	74 59                	je     800984 <vprintfmt+0x52b>
  80092b:	83 fa 01             	cmp    $0x1,%edx
  80092e:	74 7f                	je     8009af <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800930:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800933:	83 f8 2f             	cmp    $0x2f,%eax
  800936:	0f 87 9f 00 00 00    	ja     8009db <vprintfmt+0x582>
  80093c:	89 c2                	mov    %eax,%edx
  80093e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800942:	83 c0 08             	add    $0x8,%eax
  800945:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800948:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80094b:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800950:	e9 c9 00 00 00       	jmp    800a1e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800955:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800958:	83 f8 2f             	cmp    $0x2f,%eax
  80095b:	77 19                	ja     800976 <vprintfmt+0x51d>
  80095d:	89 c2                	mov    %eax,%edx
  80095f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800963:	83 c0 08             	add    $0x8,%eax
  800966:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800969:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80096c:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800971:	e9 a8 00 00 00       	jmp    800a1e <vprintfmt+0x5c5>
  800976:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80097a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80097e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800982:	eb e5                	jmp    800969 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800984:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800987:	83 f8 2f             	cmp    $0x2f,%eax
  80098a:	77 15                	ja     8009a1 <vprintfmt+0x548>
  80098c:	89 c2                	mov    %eax,%edx
  80098e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800992:	83 c0 08             	add    $0x8,%eax
  800995:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800998:	8b 12                	mov    (%rdx),%edx
            base = 8;
  80099a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80099f:	eb 7d                	jmp    800a1e <vprintfmt+0x5c5>
  8009a1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009a5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009a9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ad:	eb e9                	jmp    800998 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8009af:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b2:	83 f8 2f             	cmp    $0x2f,%eax
  8009b5:	77 16                	ja     8009cd <vprintfmt+0x574>
  8009b7:	89 c2                	mov    %eax,%edx
  8009b9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009bd:	83 c0 08             	add    $0x8,%eax
  8009c0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009c3:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8009c6:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8009cb:	eb 51                	jmp    800a1e <vprintfmt+0x5c5>
  8009cd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009d1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009d5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009d9:	eb e8                	jmp    8009c3 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8009db:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009df:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009e3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009e7:	e9 5c ff ff ff       	jmp    800948 <vprintfmt+0x4ef>
            putch('0', put_arg);
  8009ec:	4c 89 ee             	mov    %r13,%rsi
  8009ef:	bf 30 00 00 00       	mov    $0x30,%edi
  8009f4:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  8009f7:	4c 89 ee             	mov    %r13,%rsi
  8009fa:	bf 78 00 00 00       	mov    $0x78,%edi
  8009ff:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800a02:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a05:	83 f8 2f             	cmp    $0x2f,%eax
  800a08:	77 47                	ja     800a51 <vprintfmt+0x5f8>
  800a0a:	89 c2                	mov    %eax,%edx
  800a0c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a10:	83 c0 08             	add    $0x8,%eax
  800a13:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a16:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a19:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800a1e:	48 83 ec 08          	sub    $0x8,%rsp
  800a22:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800a26:	0f 94 c0             	sete   %al
  800a29:	0f b6 c0             	movzbl %al,%eax
  800a2c:	50                   	push   %rax
  800a2d:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800a32:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800a36:	4c 89 ee             	mov    %r13,%rsi
  800a39:	4c 89 f7             	mov    %r14,%rdi
  800a3c:	48 b8 42 03 80 00 00 	movabs $0x800342,%rax
  800a43:	00 00 00 
  800a46:	ff d0                	call   *%rax
            break;
  800a48:	48 83 c4 10          	add    $0x10,%rsp
  800a4c:	e9 3d fa ff ff       	jmp    80048e <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800a51:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a55:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a59:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a5d:	eb b7                	jmp    800a16 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800a5f:	40 84 f6             	test   %sil,%sil
  800a62:	75 2b                	jne    800a8f <vprintfmt+0x636>
    switch (lflag) {
  800a64:	85 d2                	test   %edx,%edx
  800a66:	74 56                	je     800abe <vprintfmt+0x665>
  800a68:	83 fa 01             	cmp    $0x1,%edx
  800a6b:	74 7f                	je     800aec <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800a6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a70:	83 f8 2f             	cmp    $0x2f,%eax
  800a73:	0f 87 a2 00 00 00    	ja     800b1b <vprintfmt+0x6c2>
  800a79:	89 c2                	mov    %eax,%edx
  800a7b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a7f:	83 c0 08             	add    $0x8,%eax
  800a82:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a85:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a88:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800a8d:	eb 8f                	jmp    800a1e <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a8f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a92:	83 f8 2f             	cmp    $0x2f,%eax
  800a95:	77 19                	ja     800ab0 <vprintfmt+0x657>
  800a97:	89 c2                	mov    %eax,%edx
  800a99:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a9d:	83 c0 08             	add    $0x8,%eax
  800aa0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aa3:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800aa6:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800aab:	e9 6e ff ff ff       	jmp    800a1e <vprintfmt+0x5c5>
  800ab0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ab4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ab8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800abc:	eb e5                	jmp    800aa3 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800abe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac1:	83 f8 2f             	cmp    $0x2f,%eax
  800ac4:	77 18                	ja     800ade <vprintfmt+0x685>
  800ac6:	89 c2                	mov    %eax,%edx
  800ac8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800acc:	83 c0 08             	add    $0x8,%eax
  800acf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ad2:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800ad4:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800ad9:	e9 40 ff ff ff       	jmp    800a1e <vprintfmt+0x5c5>
  800ade:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ae6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aea:	eb e6                	jmp    800ad2 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800aec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aef:	83 f8 2f             	cmp    $0x2f,%eax
  800af2:	77 19                	ja     800b0d <vprintfmt+0x6b4>
  800af4:	89 c2                	mov    %eax,%edx
  800af6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800afa:	83 c0 08             	add    $0x8,%eax
  800afd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b00:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b03:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800b08:	e9 11 ff ff ff       	jmp    800a1e <vprintfmt+0x5c5>
  800b0d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b11:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b15:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b19:	eb e5                	jmp    800b00 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800b1b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b1f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b23:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b27:	e9 59 ff ff ff       	jmp    800a85 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800b2c:	4c 89 ee             	mov    %r13,%rsi
  800b2f:	bf 25 00 00 00       	mov    $0x25,%edi
  800b34:	41 ff d6             	call   *%r14
            break;
  800b37:	e9 52 f9 ff ff       	jmp    80048e <vprintfmt+0x35>
            putch('%', put_arg);
  800b3c:	4c 89 ee             	mov    %r13,%rsi
  800b3f:	bf 25 00 00 00       	mov    $0x25,%edi
  800b44:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800b47:	48 83 eb 01          	sub    $0x1,%rbx
  800b4b:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800b4f:	75 f6                	jne    800b47 <vprintfmt+0x6ee>
  800b51:	e9 38 f9 ff ff       	jmp    80048e <vprintfmt+0x35>
}
  800b56:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800b5a:	5b                   	pop    %rbx
  800b5b:	41 5c                	pop    %r12
  800b5d:	41 5d                	pop    %r13
  800b5f:	41 5e                	pop    %r14
  800b61:	41 5f                	pop    %r15
  800b63:	5d                   	pop    %rbp
  800b64:	c3                   	ret

0000000000800b65 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800b65:	f3 0f 1e fa          	endbr64
  800b69:	55                   	push   %rbp
  800b6a:	48 89 e5             	mov    %rsp,%rbp
  800b6d:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800b71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b75:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800b7a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800b7e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800b85:	48 85 ff             	test   %rdi,%rdi
  800b88:	74 2b                	je     800bb5 <vsnprintf+0x50>
  800b8a:	48 85 f6             	test   %rsi,%rsi
  800b8d:	74 26                	je     800bb5 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800b8f:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b93:	48 bf fc 03 80 00 00 	movabs $0x8003fc,%rdi
  800b9a:	00 00 00 
  800b9d:	48 b8 59 04 80 00 00 	movabs $0x800459,%rax
  800ba4:	00 00 00 
  800ba7:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800ba9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bad:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800bb0:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800bb3:	c9                   	leave
  800bb4:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800bb5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bba:	eb f7                	jmp    800bb3 <vsnprintf+0x4e>

0000000000800bbc <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800bbc:	f3 0f 1e fa          	endbr64
  800bc0:	55                   	push   %rbp
  800bc1:	48 89 e5             	mov    %rsp,%rbp
  800bc4:	48 83 ec 50          	sub    $0x50,%rsp
  800bc8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800bcc:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800bd0:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800bd4:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800bdb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bdf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800be3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800be7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800beb:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800bef:	48 b8 65 0b 80 00 00 	movabs $0x800b65,%rax
  800bf6:	00 00 00 
  800bf9:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800bfb:	c9                   	leave
  800bfc:	c3                   	ret

0000000000800bfd <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800bfd:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800c01:	80 3f 00             	cmpb   $0x0,(%rdi)
  800c04:	74 10                	je     800c16 <strlen+0x19>
    size_t n = 0;
  800c06:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800c0b:	48 83 c0 01          	add    $0x1,%rax
  800c0f:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c13:	75 f6                	jne    800c0b <strlen+0xe>
  800c15:	c3                   	ret
    size_t n = 0;
  800c16:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800c1b:	c3                   	ret

0000000000800c1c <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800c1c:	f3 0f 1e fa          	endbr64
  800c20:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800c23:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800c28:	48 85 f6             	test   %rsi,%rsi
  800c2b:	74 10                	je     800c3d <strnlen+0x21>
  800c2d:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800c31:	74 0b                	je     800c3e <strnlen+0x22>
  800c33:	48 83 c2 01          	add    $0x1,%rdx
  800c37:	48 39 d0             	cmp    %rdx,%rax
  800c3a:	75 f1                	jne    800c2d <strnlen+0x11>
  800c3c:	c3                   	ret
  800c3d:	c3                   	ret
  800c3e:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800c41:	c3                   	ret

0000000000800c42 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800c42:	f3 0f 1e fa          	endbr64
  800c46:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800c49:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4e:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800c52:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800c55:	48 83 c2 01          	add    $0x1,%rdx
  800c59:	84 c9                	test   %cl,%cl
  800c5b:	75 f1                	jne    800c4e <strcpy+0xc>
        ;
    return res;
}
  800c5d:	c3                   	ret

0000000000800c5e <strcat>:

char *
strcat(char *dst, const char *src) {
  800c5e:	f3 0f 1e fa          	endbr64
  800c62:	55                   	push   %rbp
  800c63:	48 89 e5             	mov    %rsp,%rbp
  800c66:	41 54                	push   %r12
  800c68:	53                   	push   %rbx
  800c69:	48 89 fb             	mov    %rdi,%rbx
  800c6c:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800c6f:	48 b8 fd 0b 80 00 00 	movabs $0x800bfd,%rax
  800c76:	00 00 00 
  800c79:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800c7b:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800c7f:	4c 89 e6             	mov    %r12,%rsi
  800c82:	48 b8 42 0c 80 00 00 	movabs $0x800c42,%rax
  800c89:	00 00 00 
  800c8c:	ff d0                	call   *%rax
    return dst;
}
  800c8e:	48 89 d8             	mov    %rbx,%rax
  800c91:	5b                   	pop    %rbx
  800c92:	41 5c                	pop    %r12
  800c94:	5d                   	pop    %rbp
  800c95:	c3                   	ret

0000000000800c96 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c96:	f3 0f 1e fa          	endbr64
  800c9a:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800c9d:	48 85 d2             	test   %rdx,%rdx
  800ca0:	74 1f                	je     800cc1 <strncpy+0x2b>
  800ca2:	48 01 fa             	add    %rdi,%rdx
  800ca5:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800ca8:	48 83 c1 01          	add    $0x1,%rcx
  800cac:	44 0f b6 06          	movzbl (%rsi),%r8d
  800cb0:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800cb4:	41 80 f8 01          	cmp    $0x1,%r8b
  800cb8:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800cbc:	48 39 ca             	cmp    %rcx,%rdx
  800cbf:	75 e7                	jne    800ca8 <strncpy+0x12>
    }
    return ret;
}
  800cc1:	c3                   	ret

0000000000800cc2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800cc2:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800cc6:	48 89 f8             	mov    %rdi,%rax
  800cc9:	48 85 d2             	test   %rdx,%rdx
  800ccc:	74 24                	je     800cf2 <strlcpy+0x30>
        while (--size > 0 && *src)
  800cce:	48 83 ea 01          	sub    $0x1,%rdx
  800cd2:	74 1b                	je     800cef <strlcpy+0x2d>
  800cd4:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800cd8:	0f b6 16             	movzbl (%rsi),%edx
  800cdb:	84 d2                	test   %dl,%dl
  800cdd:	74 10                	je     800cef <strlcpy+0x2d>
            *dst++ = *src++;
  800cdf:	48 83 c6 01          	add    $0x1,%rsi
  800ce3:	48 83 c0 01          	add    $0x1,%rax
  800ce7:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800cea:	48 39 c8             	cmp    %rcx,%rax
  800ced:	75 e9                	jne    800cd8 <strlcpy+0x16>
        *dst = '\0';
  800cef:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800cf2:	48 29 f8             	sub    %rdi,%rax
}
  800cf5:	c3                   	ret

0000000000800cf6 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800cf6:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800cfa:	0f b6 07             	movzbl (%rdi),%eax
  800cfd:	84 c0                	test   %al,%al
  800cff:	74 13                	je     800d14 <strcmp+0x1e>
  800d01:	38 06                	cmp    %al,(%rsi)
  800d03:	75 0f                	jne    800d14 <strcmp+0x1e>
  800d05:	48 83 c7 01          	add    $0x1,%rdi
  800d09:	48 83 c6 01          	add    $0x1,%rsi
  800d0d:	0f b6 07             	movzbl (%rdi),%eax
  800d10:	84 c0                	test   %al,%al
  800d12:	75 ed                	jne    800d01 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800d14:	0f b6 c0             	movzbl %al,%eax
  800d17:	0f b6 16             	movzbl (%rsi),%edx
  800d1a:	29 d0                	sub    %edx,%eax
}
  800d1c:	c3                   	ret

0000000000800d1d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800d1d:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800d21:	48 85 d2             	test   %rdx,%rdx
  800d24:	74 1f                	je     800d45 <strncmp+0x28>
  800d26:	0f b6 07             	movzbl (%rdi),%eax
  800d29:	84 c0                	test   %al,%al
  800d2b:	74 1e                	je     800d4b <strncmp+0x2e>
  800d2d:	3a 06                	cmp    (%rsi),%al
  800d2f:	75 1a                	jne    800d4b <strncmp+0x2e>
  800d31:	48 83 c7 01          	add    $0x1,%rdi
  800d35:	48 83 c6 01          	add    $0x1,%rsi
  800d39:	48 83 ea 01          	sub    $0x1,%rdx
  800d3d:	75 e7                	jne    800d26 <strncmp+0x9>

    if (!n) return 0;
  800d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d44:	c3                   	ret
  800d45:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4a:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800d4b:	0f b6 07             	movzbl (%rdi),%eax
  800d4e:	0f b6 16             	movzbl (%rsi),%edx
  800d51:	29 d0                	sub    %edx,%eax
}
  800d53:	c3                   	ret

0000000000800d54 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800d54:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800d58:	0f b6 17             	movzbl (%rdi),%edx
  800d5b:	84 d2                	test   %dl,%dl
  800d5d:	74 18                	je     800d77 <strchr+0x23>
        if (*str == c) {
  800d5f:	0f be d2             	movsbl %dl,%edx
  800d62:	39 f2                	cmp    %esi,%edx
  800d64:	74 17                	je     800d7d <strchr+0x29>
    for (; *str; str++) {
  800d66:	48 83 c7 01          	add    $0x1,%rdi
  800d6a:	0f b6 17             	movzbl (%rdi),%edx
  800d6d:	84 d2                	test   %dl,%dl
  800d6f:	75 ee                	jne    800d5f <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800d71:	b8 00 00 00 00       	mov    $0x0,%eax
  800d76:	c3                   	ret
  800d77:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7c:	c3                   	ret
            return (char *)str;
  800d7d:	48 89 f8             	mov    %rdi,%rax
}
  800d80:	c3                   	ret

0000000000800d81 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800d81:	f3 0f 1e fa          	endbr64
  800d85:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800d88:	0f b6 17             	movzbl (%rdi),%edx
  800d8b:	84 d2                	test   %dl,%dl
  800d8d:	74 13                	je     800da2 <strfind+0x21>
  800d8f:	0f be d2             	movsbl %dl,%edx
  800d92:	39 f2                	cmp    %esi,%edx
  800d94:	74 0b                	je     800da1 <strfind+0x20>
  800d96:	48 83 c0 01          	add    $0x1,%rax
  800d9a:	0f b6 10             	movzbl (%rax),%edx
  800d9d:	84 d2                	test   %dl,%dl
  800d9f:	75 ee                	jne    800d8f <strfind+0xe>
        ;
    return (char *)str;
}
  800da1:	c3                   	ret
  800da2:	c3                   	ret

0000000000800da3 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800da3:	f3 0f 1e fa          	endbr64
  800da7:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800daa:	48 89 f8             	mov    %rdi,%rax
  800dad:	48 f7 d8             	neg    %rax
  800db0:	83 e0 07             	and    $0x7,%eax
  800db3:	49 89 d1             	mov    %rdx,%r9
  800db6:	49 29 c1             	sub    %rax,%r9
  800db9:	78 36                	js     800df1 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800dbb:	40 0f b6 c6          	movzbl %sil,%eax
  800dbf:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800dc6:	01 01 01 
  800dc9:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800dcd:	40 f6 c7 07          	test   $0x7,%dil
  800dd1:	75 38                	jne    800e0b <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800dd3:	4c 89 c9             	mov    %r9,%rcx
  800dd6:	48 c1 f9 03          	sar    $0x3,%rcx
  800dda:	74 0c                	je     800de8 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800ddc:	fc                   	cld
  800ddd:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800de0:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800de4:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800de8:	4d 85 c9             	test   %r9,%r9
  800deb:	75 45                	jne    800e32 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800ded:	4c 89 c0             	mov    %r8,%rax
  800df0:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800df1:	48 85 d2             	test   %rdx,%rdx
  800df4:	74 f7                	je     800ded <memset+0x4a>
  800df6:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800df9:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800dfc:	48 83 c0 01          	add    $0x1,%rax
  800e00:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800e04:	48 39 c2             	cmp    %rax,%rdx
  800e07:	75 f3                	jne    800dfc <memset+0x59>
  800e09:	eb e2                	jmp    800ded <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800e0b:	40 f6 c7 01          	test   $0x1,%dil
  800e0f:	74 06                	je     800e17 <memset+0x74>
  800e11:	88 07                	mov    %al,(%rdi)
  800e13:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e17:	40 f6 c7 02          	test   $0x2,%dil
  800e1b:	74 07                	je     800e24 <memset+0x81>
  800e1d:	66 89 07             	mov    %ax,(%rdi)
  800e20:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e24:	40 f6 c7 04          	test   $0x4,%dil
  800e28:	74 a9                	je     800dd3 <memset+0x30>
  800e2a:	89 07                	mov    %eax,(%rdi)
  800e2c:	48 83 c7 04          	add    $0x4,%rdi
  800e30:	eb a1                	jmp    800dd3 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e32:	41 f6 c1 04          	test   $0x4,%r9b
  800e36:	74 1b                	je     800e53 <memset+0xb0>
  800e38:	89 07                	mov    %eax,(%rdi)
  800e3a:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e3e:	41 f6 c1 02          	test   $0x2,%r9b
  800e42:	74 07                	je     800e4b <memset+0xa8>
  800e44:	66 89 07             	mov    %ax,(%rdi)
  800e47:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800e4b:	41 f6 c1 01          	test   $0x1,%r9b
  800e4f:	74 9c                	je     800ded <memset+0x4a>
  800e51:	eb 06                	jmp    800e59 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e53:	41 f6 c1 02          	test   $0x2,%r9b
  800e57:	75 eb                	jne    800e44 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800e59:	88 07                	mov    %al,(%rdi)
  800e5b:	eb 90                	jmp    800ded <memset+0x4a>

0000000000800e5d <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800e5d:	f3 0f 1e fa          	endbr64
  800e61:	48 89 f8             	mov    %rdi,%rax
  800e64:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800e67:	48 39 fe             	cmp    %rdi,%rsi
  800e6a:	73 3b                	jae    800ea7 <memmove+0x4a>
  800e6c:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800e70:	48 39 d7             	cmp    %rdx,%rdi
  800e73:	73 32                	jae    800ea7 <memmove+0x4a>
        s += n;
        d += n;
  800e75:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e79:	48 89 d6             	mov    %rdx,%rsi
  800e7c:	48 09 fe             	or     %rdi,%rsi
  800e7f:	48 09 ce             	or     %rcx,%rsi
  800e82:	40 f6 c6 07          	test   $0x7,%sil
  800e86:	75 12                	jne    800e9a <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800e88:	48 83 ef 08          	sub    $0x8,%rdi
  800e8c:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800e90:	48 c1 e9 03          	shr    $0x3,%rcx
  800e94:	fd                   	std
  800e95:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800e98:	fc                   	cld
  800e99:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800e9a:	48 83 ef 01          	sub    $0x1,%rdi
  800e9e:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800ea2:	fd                   	std
  800ea3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800ea5:	eb f1                	jmp    800e98 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800ea7:	48 89 f2             	mov    %rsi,%rdx
  800eaa:	48 09 c2             	or     %rax,%rdx
  800ead:	48 09 ca             	or     %rcx,%rdx
  800eb0:	f6 c2 07             	test   $0x7,%dl
  800eb3:	75 0c                	jne    800ec1 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800eb5:	48 c1 e9 03          	shr    $0x3,%rcx
  800eb9:	48 89 c7             	mov    %rax,%rdi
  800ebc:	fc                   	cld
  800ebd:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800ec0:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800ec1:	48 89 c7             	mov    %rax,%rdi
  800ec4:	fc                   	cld
  800ec5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800ec7:	c3                   	ret

0000000000800ec8 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800ec8:	f3 0f 1e fa          	endbr64
  800ecc:	55                   	push   %rbp
  800ecd:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800ed0:	48 b8 5d 0e 80 00 00 	movabs $0x800e5d,%rax
  800ed7:	00 00 00 
  800eda:	ff d0                	call   *%rax
}
  800edc:	5d                   	pop    %rbp
  800edd:	c3                   	ret

0000000000800ede <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800ede:	f3 0f 1e fa          	endbr64
  800ee2:	55                   	push   %rbp
  800ee3:	48 89 e5             	mov    %rsp,%rbp
  800ee6:	41 57                	push   %r15
  800ee8:	41 56                	push   %r14
  800eea:	41 55                	push   %r13
  800eec:	41 54                	push   %r12
  800eee:	53                   	push   %rbx
  800eef:	48 83 ec 08          	sub    $0x8,%rsp
  800ef3:	49 89 fe             	mov    %rdi,%r14
  800ef6:	49 89 f7             	mov    %rsi,%r15
  800ef9:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800efc:	48 89 f7             	mov    %rsi,%rdi
  800eff:	48 b8 fd 0b 80 00 00 	movabs $0x800bfd,%rax
  800f06:	00 00 00 
  800f09:	ff d0                	call   *%rax
  800f0b:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800f0e:	48 89 de             	mov    %rbx,%rsi
  800f11:	4c 89 f7             	mov    %r14,%rdi
  800f14:	48 b8 1c 0c 80 00 00 	movabs $0x800c1c,%rax
  800f1b:	00 00 00 
  800f1e:	ff d0                	call   *%rax
  800f20:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800f23:	48 39 c3             	cmp    %rax,%rbx
  800f26:	74 36                	je     800f5e <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800f28:	48 89 d8             	mov    %rbx,%rax
  800f2b:	4c 29 e8             	sub    %r13,%rax
  800f2e:	49 39 c4             	cmp    %rax,%r12
  800f31:	73 31                	jae    800f64 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800f33:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800f38:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f3c:	4c 89 fe             	mov    %r15,%rsi
  800f3f:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  800f46:	00 00 00 
  800f49:	ff d0                	call   *%rax
    return dstlen + srclen;
  800f4b:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800f4f:	48 83 c4 08          	add    $0x8,%rsp
  800f53:	5b                   	pop    %rbx
  800f54:	41 5c                	pop    %r12
  800f56:	41 5d                	pop    %r13
  800f58:	41 5e                	pop    %r14
  800f5a:	41 5f                	pop    %r15
  800f5c:	5d                   	pop    %rbp
  800f5d:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800f5e:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800f62:	eb eb                	jmp    800f4f <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800f64:	48 83 eb 01          	sub    $0x1,%rbx
  800f68:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f6c:	48 89 da             	mov    %rbx,%rdx
  800f6f:	4c 89 fe             	mov    %r15,%rsi
  800f72:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  800f79:	00 00 00 
  800f7c:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800f7e:	49 01 de             	add    %rbx,%r14
  800f81:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800f86:	eb c3                	jmp    800f4b <strlcat+0x6d>

0000000000800f88 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800f88:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800f8c:	48 85 d2             	test   %rdx,%rdx
  800f8f:	74 2d                	je     800fbe <memcmp+0x36>
  800f91:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800f96:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800f9a:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800f9f:	44 38 c1             	cmp    %r8b,%cl
  800fa2:	75 0f                	jne    800fb3 <memcmp+0x2b>
    while (n-- > 0) {
  800fa4:	48 83 c0 01          	add    $0x1,%rax
  800fa8:	48 39 c2             	cmp    %rax,%rdx
  800fab:	75 e9                	jne    800f96 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800fad:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb2:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800fb3:	0f b6 c1             	movzbl %cl,%eax
  800fb6:	45 0f b6 c0          	movzbl %r8b,%r8d
  800fba:	44 29 c0             	sub    %r8d,%eax
  800fbd:	c3                   	ret
    return 0;
  800fbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc3:	c3                   	ret

0000000000800fc4 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800fc4:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800fc8:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800fcc:	48 39 c7             	cmp    %rax,%rdi
  800fcf:	73 0f                	jae    800fe0 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800fd1:	40 38 37             	cmp    %sil,(%rdi)
  800fd4:	74 0e                	je     800fe4 <memfind+0x20>
    for (; src < end; src++) {
  800fd6:	48 83 c7 01          	add    $0x1,%rdi
  800fda:	48 39 f8             	cmp    %rdi,%rax
  800fdd:	75 f2                	jne    800fd1 <memfind+0xd>
  800fdf:	c3                   	ret
  800fe0:	48 89 f8             	mov    %rdi,%rax
  800fe3:	c3                   	ret
  800fe4:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800fe7:	c3                   	ret

0000000000800fe8 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800fe8:	f3 0f 1e fa          	endbr64
  800fec:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800fef:	0f b6 37             	movzbl (%rdi),%esi
  800ff2:	40 80 fe 20          	cmp    $0x20,%sil
  800ff6:	74 06                	je     800ffe <strtol+0x16>
  800ff8:	40 80 fe 09          	cmp    $0x9,%sil
  800ffc:	75 13                	jne    801011 <strtol+0x29>
  800ffe:	48 83 c7 01          	add    $0x1,%rdi
  801002:	0f b6 37             	movzbl (%rdi),%esi
  801005:	40 80 fe 20          	cmp    $0x20,%sil
  801009:	74 f3                	je     800ffe <strtol+0x16>
  80100b:	40 80 fe 09          	cmp    $0x9,%sil
  80100f:	74 ed                	je     800ffe <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801011:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801014:	83 e0 fd             	and    $0xfffffffd,%eax
  801017:	3c 01                	cmp    $0x1,%al
  801019:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80101d:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  801023:	75 0f                	jne    801034 <strtol+0x4c>
  801025:	80 3f 30             	cmpb   $0x30,(%rdi)
  801028:	74 14                	je     80103e <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80102a:	85 d2                	test   %edx,%edx
  80102c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801031:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801034:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801039:	4c 63 ca             	movslq %edx,%r9
  80103c:	eb 36                	jmp    801074 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80103e:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801042:	74 0f                	je     801053 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801044:	85 d2                	test   %edx,%edx
  801046:	75 ec                	jne    801034 <strtol+0x4c>
        s++;
  801048:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  80104c:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  801051:	eb e1                	jmp    801034 <strtol+0x4c>
        s += 2;
  801053:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801057:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  80105c:	eb d6                	jmp    801034 <strtol+0x4c>
            dig -= '0';
  80105e:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  801061:	44 0f b6 c1          	movzbl %cl,%r8d
  801065:	41 39 d0             	cmp    %edx,%r8d
  801068:	7d 21                	jge    80108b <strtol+0xa3>
        val = val * base + dig;
  80106a:	49 0f af c1          	imul   %r9,%rax
  80106e:	0f b6 c9             	movzbl %cl,%ecx
  801071:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  801074:	48 83 c7 01          	add    $0x1,%rdi
  801078:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  80107c:	80 f9 39             	cmp    $0x39,%cl
  80107f:	76 dd                	jbe    80105e <strtol+0x76>
        else if (dig - 'a' < 27)
  801081:	80 f9 7b             	cmp    $0x7b,%cl
  801084:	77 05                	ja     80108b <strtol+0xa3>
            dig -= 'a' - 10;
  801086:	83 e9 57             	sub    $0x57,%ecx
  801089:	eb d6                	jmp    801061 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  80108b:	4d 85 d2             	test   %r10,%r10
  80108e:	74 03                	je     801093 <strtol+0xab>
  801090:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801093:	48 89 c2             	mov    %rax,%rdx
  801096:	48 f7 da             	neg    %rdx
  801099:	40 80 fe 2d          	cmp    $0x2d,%sil
  80109d:	48 0f 44 c2          	cmove  %rdx,%rax
}
  8010a1:	c3                   	ret

00000000008010a2 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8010a2:	f3 0f 1e fa          	endbr64
  8010a6:	55                   	push   %rbp
  8010a7:	48 89 e5             	mov    %rsp,%rbp
  8010aa:	53                   	push   %rbx
  8010ab:	48 89 fa             	mov    %rdi,%rdx
  8010ae:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8010b1:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010c0:	be 00 00 00 00       	mov    $0x0,%esi
  8010c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010cb:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8010cd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010d1:	c9                   	leave
  8010d2:	c3                   	ret

00000000008010d3 <sys_cgetc>:

int
sys_cgetc(void) {
  8010d3:	f3 0f 1e fa          	endbr64
  8010d7:	55                   	push   %rbp
  8010d8:	48 89 e5             	mov    %rsp,%rbp
  8010db:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010dc:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010f5:	be 00 00 00 00       	mov    $0x0,%esi
  8010fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801100:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801102:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801106:	c9                   	leave
  801107:	c3                   	ret

0000000000801108 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801108:	f3 0f 1e fa          	endbr64
  80110c:	55                   	push   %rbp
  80110d:	48 89 e5             	mov    %rsp,%rbp
  801110:	53                   	push   %rbx
  801111:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801115:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801118:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80111d:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801122:	bb 00 00 00 00       	mov    $0x0,%ebx
  801127:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80112c:	be 00 00 00 00       	mov    $0x0,%esi
  801131:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801137:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801139:	48 85 c0             	test   %rax,%rax
  80113c:	7f 06                	jg     801144 <sys_env_destroy+0x3c>
}
  80113e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801142:	c9                   	leave
  801143:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801144:	49 89 c0             	mov    %rax,%r8
  801147:	b9 03 00 00 00       	mov    $0x3,%ecx
  80114c:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  801153:	00 00 00 
  801156:	be 26 00 00 00       	mov    $0x26,%esi
  80115b:	48 bf ed 41 80 00 00 	movabs $0x8041ed,%rdi
  801162:	00 00 00 
  801165:	b8 00 00 00 00       	mov    $0x0,%eax
  80116a:	49 b9 9d 01 80 00 00 	movabs $0x80019d,%r9
  801171:	00 00 00 
  801174:	41 ff d1             	call   *%r9

0000000000801177 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801177:	f3 0f 1e fa          	endbr64
  80117b:	55                   	push   %rbp
  80117c:	48 89 e5             	mov    %rsp,%rbp
  80117f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801180:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801185:	ba 00 00 00 00       	mov    $0x0,%edx
  80118a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80118f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801194:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801199:	be 00 00 00 00       	mov    $0x0,%esi
  80119e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011a4:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8011a6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011aa:	c9                   	leave
  8011ab:	c3                   	ret

00000000008011ac <sys_yield>:

void
sys_yield(void) {
  8011ac:	f3 0f 1e fa          	endbr64
  8011b0:	55                   	push   %rbp
  8011b1:	48 89 e5             	mov    %rsp,%rbp
  8011b4:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011b5:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8011bf:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ce:	be 00 00 00 00       	mov    $0x0,%esi
  8011d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011d9:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8011db:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011df:	c9                   	leave
  8011e0:	c3                   	ret

00000000008011e1 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8011e1:	f3 0f 1e fa          	endbr64
  8011e5:	55                   	push   %rbp
  8011e6:	48 89 e5             	mov    %rsp,%rbp
  8011e9:	53                   	push   %rbx
  8011ea:	48 89 fa             	mov    %rdi,%rdx
  8011ed:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8011f0:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011f5:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8011fc:	00 00 00 
  8011ff:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801204:	be 00 00 00 00       	mov    $0x0,%esi
  801209:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80120f:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801211:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801215:	c9                   	leave
  801216:	c3                   	ret

0000000000801217 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801217:	f3 0f 1e fa          	endbr64
  80121b:	55                   	push   %rbp
  80121c:	48 89 e5             	mov    %rsp,%rbp
  80121f:	53                   	push   %rbx
  801220:	49 89 f8             	mov    %rdi,%r8
  801223:	48 89 d3             	mov    %rdx,%rbx
  801226:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801229:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80122e:	4c 89 c2             	mov    %r8,%rdx
  801231:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801234:	be 00 00 00 00       	mov    $0x0,%esi
  801239:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80123f:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801241:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801245:	c9                   	leave
  801246:	c3                   	ret

0000000000801247 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801247:	f3 0f 1e fa          	endbr64
  80124b:	55                   	push   %rbp
  80124c:	48 89 e5             	mov    %rsp,%rbp
  80124f:	53                   	push   %rbx
  801250:	48 83 ec 08          	sub    $0x8,%rsp
  801254:	89 f8                	mov    %edi,%eax
  801256:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801259:	48 63 f9             	movslq %ecx,%rdi
  80125c:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80125f:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801264:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801267:	be 00 00 00 00       	mov    $0x0,%esi
  80126c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801272:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801274:	48 85 c0             	test   %rax,%rax
  801277:	7f 06                	jg     80127f <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801279:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80127d:	c9                   	leave
  80127e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80127f:	49 89 c0             	mov    %rax,%r8
  801282:	b9 04 00 00 00       	mov    $0x4,%ecx
  801287:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  80128e:	00 00 00 
  801291:	be 26 00 00 00       	mov    $0x26,%esi
  801296:	48 bf ed 41 80 00 00 	movabs $0x8041ed,%rdi
  80129d:	00 00 00 
  8012a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a5:	49 b9 9d 01 80 00 00 	movabs $0x80019d,%r9
  8012ac:	00 00 00 
  8012af:	41 ff d1             	call   *%r9

00000000008012b2 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8012b2:	f3 0f 1e fa          	endbr64
  8012b6:	55                   	push   %rbp
  8012b7:	48 89 e5             	mov    %rsp,%rbp
  8012ba:	53                   	push   %rbx
  8012bb:	48 83 ec 08          	sub    $0x8,%rsp
  8012bf:	89 f8                	mov    %edi,%eax
  8012c1:	49 89 f2             	mov    %rsi,%r10
  8012c4:	48 89 cf             	mov    %rcx,%rdi
  8012c7:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8012ca:	48 63 da             	movslq %edx,%rbx
  8012cd:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012d0:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012d5:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012d8:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8012db:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012dd:	48 85 c0             	test   %rax,%rax
  8012e0:	7f 06                	jg     8012e8 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8012e2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012e6:	c9                   	leave
  8012e7:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012e8:	49 89 c0             	mov    %rax,%r8
  8012eb:	b9 05 00 00 00       	mov    $0x5,%ecx
  8012f0:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  8012f7:	00 00 00 
  8012fa:	be 26 00 00 00       	mov    $0x26,%esi
  8012ff:	48 bf ed 41 80 00 00 	movabs $0x8041ed,%rdi
  801306:	00 00 00 
  801309:	b8 00 00 00 00       	mov    $0x0,%eax
  80130e:	49 b9 9d 01 80 00 00 	movabs $0x80019d,%r9
  801315:	00 00 00 
  801318:	41 ff d1             	call   *%r9

000000000080131b <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80131b:	f3 0f 1e fa          	endbr64
  80131f:	55                   	push   %rbp
  801320:	48 89 e5             	mov    %rsp,%rbp
  801323:	53                   	push   %rbx
  801324:	48 83 ec 08          	sub    $0x8,%rsp
  801328:	49 89 f9             	mov    %rdi,%r9
  80132b:	89 f0                	mov    %esi,%eax
  80132d:	48 89 d3             	mov    %rdx,%rbx
  801330:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801333:	49 63 f0             	movslq %r8d,%rsi
  801336:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801339:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80133e:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801341:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801347:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801349:	48 85 c0             	test   %rax,%rax
  80134c:	7f 06                	jg     801354 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80134e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801352:	c9                   	leave
  801353:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801354:	49 89 c0             	mov    %rax,%r8
  801357:	b9 06 00 00 00       	mov    $0x6,%ecx
  80135c:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  801363:	00 00 00 
  801366:	be 26 00 00 00       	mov    $0x26,%esi
  80136b:	48 bf ed 41 80 00 00 	movabs $0x8041ed,%rdi
  801372:	00 00 00 
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
  80137a:	49 b9 9d 01 80 00 00 	movabs $0x80019d,%r9
  801381:	00 00 00 
  801384:	41 ff d1             	call   *%r9

0000000000801387 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801387:	f3 0f 1e fa          	endbr64
  80138b:	55                   	push   %rbp
  80138c:	48 89 e5             	mov    %rsp,%rbp
  80138f:	53                   	push   %rbx
  801390:	48 83 ec 08          	sub    $0x8,%rsp
  801394:	48 89 f1             	mov    %rsi,%rcx
  801397:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80139a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80139d:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013a2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013a7:	be 00 00 00 00       	mov    $0x0,%esi
  8013ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013b2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013b4:	48 85 c0             	test   %rax,%rax
  8013b7:	7f 06                	jg     8013bf <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8013b9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013bd:	c9                   	leave
  8013be:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013bf:	49 89 c0             	mov    %rax,%r8
  8013c2:	b9 07 00 00 00       	mov    $0x7,%ecx
  8013c7:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  8013ce:	00 00 00 
  8013d1:	be 26 00 00 00       	mov    $0x26,%esi
  8013d6:	48 bf ed 41 80 00 00 	movabs $0x8041ed,%rdi
  8013dd:	00 00 00 
  8013e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e5:	49 b9 9d 01 80 00 00 	movabs $0x80019d,%r9
  8013ec:	00 00 00 
  8013ef:	41 ff d1             	call   *%r9

00000000008013f2 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8013f2:	f3 0f 1e fa          	endbr64
  8013f6:	55                   	push   %rbp
  8013f7:	48 89 e5             	mov    %rsp,%rbp
  8013fa:	53                   	push   %rbx
  8013fb:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8013ff:	48 63 ce             	movslq %esi,%rcx
  801402:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801405:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80140a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80140f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801414:	be 00 00 00 00       	mov    $0x0,%esi
  801419:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80141f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801421:	48 85 c0             	test   %rax,%rax
  801424:	7f 06                	jg     80142c <sys_env_set_status+0x3a>
}
  801426:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80142a:	c9                   	leave
  80142b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80142c:	49 89 c0             	mov    %rax,%r8
  80142f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801434:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  80143b:	00 00 00 
  80143e:	be 26 00 00 00       	mov    $0x26,%esi
  801443:	48 bf ed 41 80 00 00 	movabs $0x8041ed,%rdi
  80144a:	00 00 00 
  80144d:	b8 00 00 00 00       	mov    $0x0,%eax
  801452:	49 b9 9d 01 80 00 00 	movabs $0x80019d,%r9
  801459:	00 00 00 
  80145c:	41 ff d1             	call   *%r9

000000000080145f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80145f:	f3 0f 1e fa          	endbr64
  801463:	55                   	push   %rbp
  801464:	48 89 e5             	mov    %rsp,%rbp
  801467:	53                   	push   %rbx
  801468:	48 83 ec 08          	sub    $0x8,%rsp
  80146c:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80146f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801472:	b8 0b 00 00 00       	mov    $0xb,%eax
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
  801491:	7f 06                	jg     801499 <sys_env_set_trapframe+0x3a>
}
  801493:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801497:	c9                   	leave
  801498:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801499:	49 89 c0             	mov    %rax,%r8
  80149c:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8014a1:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  8014a8:	00 00 00 
  8014ab:	be 26 00 00 00       	mov    $0x26,%esi
  8014b0:	48 bf ed 41 80 00 00 	movabs $0x8041ed,%rdi
  8014b7:	00 00 00 
  8014ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bf:	49 b9 9d 01 80 00 00 	movabs $0x80019d,%r9
  8014c6:	00 00 00 
  8014c9:	41 ff d1             	call   *%r9

00000000008014cc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8014cc:	f3 0f 1e fa          	endbr64
  8014d0:	55                   	push   %rbp
  8014d1:	48 89 e5             	mov    %rsp,%rbp
  8014d4:	53                   	push   %rbx
  8014d5:	48 83 ec 08          	sub    $0x8,%rsp
  8014d9:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8014dc:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014df:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014ee:	be 00 00 00 00       	mov    $0x0,%esi
  8014f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014f9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014fb:	48 85 c0             	test   %rax,%rax
  8014fe:	7f 06                	jg     801506 <sys_env_set_pgfault_upcall+0x3a>
}
  801500:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801504:	c9                   	leave
  801505:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801506:	49 89 c0             	mov    %rax,%r8
  801509:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80150e:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  801515:	00 00 00 
  801518:	be 26 00 00 00       	mov    $0x26,%esi
  80151d:	48 bf ed 41 80 00 00 	movabs $0x8041ed,%rdi
  801524:	00 00 00 
  801527:	b8 00 00 00 00       	mov    $0x0,%eax
  80152c:	49 b9 9d 01 80 00 00 	movabs $0x80019d,%r9
  801533:	00 00 00 
  801536:	41 ff d1             	call   *%r9

0000000000801539 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801539:	f3 0f 1e fa          	endbr64
  80153d:	55                   	push   %rbp
  80153e:	48 89 e5             	mov    %rsp,%rbp
  801541:	53                   	push   %rbx
  801542:	89 f8                	mov    %edi,%eax
  801544:	49 89 f1             	mov    %rsi,%r9
  801547:	48 89 d3             	mov    %rdx,%rbx
  80154a:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80154d:	49 63 f0             	movslq %r8d,%rsi
  801550:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801553:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801558:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80155b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801561:	cd 30                	int    $0x30
}
  801563:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801567:	c9                   	leave
  801568:	c3                   	ret

0000000000801569 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801569:	f3 0f 1e fa          	endbr64
  80156d:	55                   	push   %rbp
  80156e:	48 89 e5             	mov    %rsp,%rbp
  801571:	53                   	push   %rbx
  801572:	48 83 ec 08          	sub    $0x8,%rsp
  801576:	48 89 fa             	mov    %rdi,%rdx
  801579:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80157c:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801581:	bb 00 00 00 00       	mov    $0x0,%ebx
  801586:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80158b:	be 00 00 00 00       	mov    $0x0,%esi
  801590:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801596:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801598:	48 85 c0             	test   %rax,%rax
  80159b:	7f 06                	jg     8015a3 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80159d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015a1:	c9                   	leave
  8015a2:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015a3:	49 89 c0             	mov    %rax,%r8
  8015a6:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8015ab:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  8015b2:	00 00 00 
  8015b5:	be 26 00 00 00       	mov    $0x26,%esi
  8015ba:	48 bf ed 41 80 00 00 	movabs $0x8041ed,%rdi
  8015c1:	00 00 00 
  8015c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c9:	49 b9 9d 01 80 00 00 	movabs $0x80019d,%r9
  8015d0:	00 00 00 
  8015d3:	41 ff d1             	call   *%r9

00000000008015d6 <sys_gettime>:

int
sys_gettime(void) {
  8015d6:	f3 0f 1e fa          	endbr64
  8015da:	55                   	push   %rbp
  8015db:	48 89 e5             	mov    %rsp,%rbp
  8015de:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015df:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015f3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015f8:	be 00 00 00 00       	mov    $0x0,%esi
  8015fd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801603:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801605:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801609:	c9                   	leave
  80160a:	c3                   	ret

000000000080160b <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  80160b:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80160f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801616:	ff ff ff 
  801619:	48 01 f8             	add    %rdi,%rax
  80161c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801620:	c3                   	ret

0000000000801621 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801621:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801625:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80162c:	ff ff ff 
  80162f:	48 01 f8             	add    %rdi,%rax
  801632:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801636:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80163c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801640:	c3                   	ret

0000000000801641 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801641:	f3 0f 1e fa          	endbr64
  801645:	55                   	push   %rbp
  801646:	48 89 e5             	mov    %rsp,%rbp
  801649:	41 57                	push   %r15
  80164b:	41 56                	push   %r14
  80164d:	41 55                	push   %r13
  80164f:	41 54                	push   %r12
  801651:	53                   	push   %rbx
  801652:	48 83 ec 08          	sub    $0x8,%rsp
  801656:	49 89 ff             	mov    %rdi,%r15
  801659:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80165e:	49 bd 28 30 80 00 00 	movabs $0x803028,%r13
  801665:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801668:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  80166e:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801671:	48 89 df             	mov    %rbx,%rdi
  801674:	41 ff d5             	call   *%r13
  801677:	83 e0 04             	and    $0x4,%eax
  80167a:	74 17                	je     801693 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  80167c:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801683:	4c 39 f3             	cmp    %r14,%rbx
  801686:	75 e6                	jne    80166e <fd_alloc+0x2d>
  801688:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  80168e:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801693:	4d 89 27             	mov    %r12,(%r15)
}
  801696:	48 83 c4 08          	add    $0x8,%rsp
  80169a:	5b                   	pop    %rbx
  80169b:	41 5c                	pop    %r12
  80169d:	41 5d                	pop    %r13
  80169f:	41 5e                	pop    %r14
  8016a1:	41 5f                	pop    %r15
  8016a3:	5d                   	pop    %rbp
  8016a4:	c3                   	ret

00000000008016a5 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8016a5:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8016a9:	83 ff 1f             	cmp    $0x1f,%edi
  8016ac:	77 39                	ja     8016e7 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8016ae:	55                   	push   %rbp
  8016af:	48 89 e5             	mov    %rsp,%rbp
  8016b2:	41 54                	push   %r12
  8016b4:	53                   	push   %rbx
  8016b5:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8016b8:	48 63 df             	movslq %edi,%rbx
  8016bb:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8016c2:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8016c6:	48 89 df             	mov    %rbx,%rdi
  8016c9:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  8016d0:	00 00 00 
  8016d3:	ff d0                	call   *%rax
  8016d5:	a8 04                	test   $0x4,%al
  8016d7:	74 14                	je     8016ed <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8016d9:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8016dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e2:	5b                   	pop    %rbx
  8016e3:	41 5c                	pop    %r12
  8016e5:	5d                   	pop    %rbp
  8016e6:	c3                   	ret
        return -E_INVAL;
  8016e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016ec:	c3                   	ret
        return -E_INVAL;
  8016ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f2:	eb ee                	jmp    8016e2 <fd_lookup+0x3d>

00000000008016f4 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8016f4:	f3 0f 1e fa          	endbr64
  8016f8:	55                   	push   %rbp
  8016f9:	48 89 e5             	mov    %rsp,%rbp
  8016fc:	41 54                	push   %r12
  8016fe:	53                   	push   %rbx
  8016ff:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801702:	48 b8 c0 47 80 00 00 	movabs $0x8047c0,%rax
  801709:	00 00 00 
  80170c:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801713:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801716:	39 3b                	cmp    %edi,(%rbx)
  801718:	74 47                	je     801761 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  80171a:	48 83 c0 08          	add    $0x8,%rax
  80171e:	48 8b 18             	mov    (%rax),%rbx
  801721:	48 85 db             	test   %rbx,%rbx
  801724:	75 f0                	jne    801716 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801726:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80172d:	00 00 00 
  801730:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801736:	89 fa                	mov    %edi,%edx
  801738:	48 bf 80 43 80 00 00 	movabs $0x804380,%rdi
  80173f:	00 00 00 
  801742:	b8 00 00 00 00       	mov    $0x0,%eax
  801747:	48 b9 f9 02 80 00 00 	movabs $0x8002f9,%rcx
  80174e:	00 00 00 
  801751:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801753:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801758:	49 89 1c 24          	mov    %rbx,(%r12)
}
  80175c:	5b                   	pop    %rbx
  80175d:	41 5c                	pop    %r12
  80175f:	5d                   	pop    %rbp
  801760:	c3                   	ret
            return 0;
  801761:	b8 00 00 00 00       	mov    $0x0,%eax
  801766:	eb f0                	jmp    801758 <dev_lookup+0x64>

0000000000801768 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801768:	f3 0f 1e fa          	endbr64
  80176c:	55                   	push   %rbp
  80176d:	48 89 e5             	mov    %rsp,%rbp
  801770:	41 55                	push   %r13
  801772:	41 54                	push   %r12
  801774:	53                   	push   %rbx
  801775:	48 83 ec 18          	sub    $0x18,%rsp
  801779:	48 89 fb             	mov    %rdi,%rbx
  80177c:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80177f:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801786:	ff ff ff 
  801789:	48 01 df             	add    %rbx,%rdi
  80178c:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801790:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801794:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  80179b:	00 00 00 
  80179e:	ff d0                	call   *%rax
  8017a0:	41 89 c5             	mov    %eax,%r13d
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 06                	js     8017ad <fd_close+0x45>
  8017a7:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  8017ab:	74 1a                	je     8017c7 <fd_close+0x5f>
        return (must_exist ? res : 0);
  8017ad:	45 84 e4             	test   %r12b,%r12b
  8017b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b5:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8017b9:	44 89 e8             	mov    %r13d,%eax
  8017bc:	48 83 c4 18          	add    $0x18,%rsp
  8017c0:	5b                   	pop    %rbx
  8017c1:	41 5c                	pop    %r12
  8017c3:	41 5d                	pop    %r13
  8017c5:	5d                   	pop    %rbp
  8017c6:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017c7:	8b 3b                	mov    (%rbx),%edi
  8017c9:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8017cd:	48 b8 f4 16 80 00 00 	movabs $0x8016f4,%rax
  8017d4:	00 00 00 
  8017d7:	ff d0                	call   *%rax
  8017d9:	41 89 c5             	mov    %eax,%r13d
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	78 1b                	js     8017fb <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8017e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017e4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8017e8:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8017ee:	48 85 c0             	test   %rax,%rax
  8017f1:	74 08                	je     8017fb <fd_close+0x93>
  8017f3:	48 89 df             	mov    %rbx,%rdi
  8017f6:	ff d0                	call   *%rax
  8017f8:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8017fb:	ba 00 10 00 00       	mov    $0x1000,%edx
  801800:	48 89 de             	mov    %rbx,%rsi
  801803:	bf 00 00 00 00       	mov    $0x0,%edi
  801808:	48 b8 87 13 80 00 00 	movabs $0x801387,%rax
  80180f:	00 00 00 
  801812:	ff d0                	call   *%rax
    return res;
  801814:	eb a3                	jmp    8017b9 <fd_close+0x51>

0000000000801816 <close>:

int
close(int fdnum) {
  801816:	f3 0f 1e fa          	endbr64
  80181a:	55                   	push   %rbp
  80181b:	48 89 e5             	mov    %rsp,%rbp
  80181e:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801822:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801826:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  80182d:	00 00 00 
  801830:	ff d0                	call   *%rax
    if (res < 0) return res;
  801832:	85 c0                	test   %eax,%eax
  801834:	78 15                	js     80184b <close+0x35>

    return fd_close(fd, 1);
  801836:	be 01 00 00 00       	mov    $0x1,%esi
  80183b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80183f:	48 b8 68 17 80 00 00 	movabs $0x801768,%rax
  801846:	00 00 00 
  801849:	ff d0                	call   *%rax
}
  80184b:	c9                   	leave
  80184c:	c3                   	ret

000000000080184d <close_all>:

void
close_all(void) {
  80184d:	f3 0f 1e fa          	endbr64
  801851:	55                   	push   %rbp
  801852:	48 89 e5             	mov    %rsp,%rbp
  801855:	41 54                	push   %r12
  801857:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801858:	bb 00 00 00 00       	mov    $0x0,%ebx
  80185d:	49 bc 16 18 80 00 00 	movabs $0x801816,%r12
  801864:	00 00 00 
  801867:	89 df                	mov    %ebx,%edi
  801869:	41 ff d4             	call   *%r12
  80186c:	83 c3 01             	add    $0x1,%ebx
  80186f:	83 fb 20             	cmp    $0x20,%ebx
  801872:	75 f3                	jne    801867 <close_all+0x1a>
}
  801874:	5b                   	pop    %rbx
  801875:	41 5c                	pop    %r12
  801877:	5d                   	pop    %rbp
  801878:	c3                   	ret

0000000000801879 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801879:	f3 0f 1e fa          	endbr64
  80187d:	55                   	push   %rbp
  80187e:	48 89 e5             	mov    %rsp,%rbp
  801881:	41 57                	push   %r15
  801883:	41 56                	push   %r14
  801885:	41 55                	push   %r13
  801887:	41 54                	push   %r12
  801889:	53                   	push   %rbx
  80188a:	48 83 ec 18          	sub    $0x18,%rsp
  80188e:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801891:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801895:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  80189c:	00 00 00 
  80189f:	ff d0                	call   *%rax
  8018a1:	89 c3                	mov    %eax,%ebx
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	0f 88 b8 00 00 00    	js     801963 <dup+0xea>
    close(newfdnum);
  8018ab:	44 89 e7             	mov    %r12d,%edi
  8018ae:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  8018b5:	00 00 00 
  8018b8:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8018ba:	4d 63 ec             	movslq %r12d,%r13
  8018bd:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8018c4:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8018c8:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8018cc:	4c 89 ff             	mov    %r15,%rdi
  8018cf:	49 be 21 16 80 00 00 	movabs $0x801621,%r14
  8018d6:	00 00 00 
  8018d9:	41 ff d6             	call   *%r14
  8018dc:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8018df:	4c 89 ef             	mov    %r13,%rdi
  8018e2:	41 ff d6             	call   *%r14
  8018e5:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8018e8:	48 89 df             	mov    %rbx,%rdi
  8018eb:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  8018f2:	00 00 00 
  8018f5:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8018f7:	a8 04                	test   $0x4,%al
  8018f9:	74 2b                	je     801926 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8018fb:	41 89 c1             	mov    %eax,%r9d
  8018fe:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801904:	4c 89 f1             	mov    %r14,%rcx
  801907:	ba 00 00 00 00       	mov    $0x0,%edx
  80190c:	48 89 de             	mov    %rbx,%rsi
  80190f:	bf 00 00 00 00       	mov    $0x0,%edi
  801914:	48 b8 b2 12 80 00 00 	movabs $0x8012b2,%rax
  80191b:	00 00 00 
  80191e:	ff d0                	call   *%rax
  801920:	89 c3                	mov    %eax,%ebx
  801922:	85 c0                	test   %eax,%eax
  801924:	78 4e                	js     801974 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801926:	4c 89 ff             	mov    %r15,%rdi
  801929:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  801930:	00 00 00 
  801933:	ff d0                	call   *%rax
  801935:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801938:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80193e:	4c 89 e9             	mov    %r13,%rcx
  801941:	ba 00 00 00 00       	mov    $0x0,%edx
  801946:	4c 89 fe             	mov    %r15,%rsi
  801949:	bf 00 00 00 00       	mov    $0x0,%edi
  80194e:	48 b8 b2 12 80 00 00 	movabs $0x8012b2,%rax
  801955:	00 00 00 
  801958:	ff d0                	call   *%rax
  80195a:	89 c3                	mov    %eax,%ebx
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 14                	js     801974 <dup+0xfb>

    return newfdnum;
  801960:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801963:	89 d8                	mov    %ebx,%eax
  801965:	48 83 c4 18          	add    $0x18,%rsp
  801969:	5b                   	pop    %rbx
  80196a:	41 5c                	pop    %r12
  80196c:	41 5d                	pop    %r13
  80196e:	41 5e                	pop    %r14
  801970:	41 5f                	pop    %r15
  801972:	5d                   	pop    %rbp
  801973:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801974:	ba 00 10 00 00       	mov    $0x1000,%edx
  801979:	4c 89 ee             	mov    %r13,%rsi
  80197c:	bf 00 00 00 00       	mov    $0x0,%edi
  801981:	49 bc 87 13 80 00 00 	movabs $0x801387,%r12
  801988:	00 00 00 
  80198b:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  80198e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801993:	4c 89 f6             	mov    %r14,%rsi
  801996:	bf 00 00 00 00       	mov    $0x0,%edi
  80199b:	41 ff d4             	call   *%r12
    return res;
  80199e:	eb c3                	jmp    801963 <dup+0xea>

00000000008019a0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8019a0:	f3 0f 1e fa          	endbr64
  8019a4:	55                   	push   %rbp
  8019a5:	48 89 e5             	mov    %rsp,%rbp
  8019a8:	41 56                	push   %r14
  8019aa:	41 55                	push   %r13
  8019ac:	41 54                	push   %r12
  8019ae:	53                   	push   %rbx
  8019af:	48 83 ec 10          	sub    $0x10,%rsp
  8019b3:	89 fb                	mov    %edi,%ebx
  8019b5:	49 89 f4             	mov    %rsi,%r12
  8019b8:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019bb:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019bf:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  8019c6:	00 00 00 
  8019c9:	ff d0                	call   *%rax
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	78 4c                	js     801a1b <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019cf:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8019d3:	41 8b 3e             	mov    (%r14),%edi
  8019d6:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8019da:	48 b8 f4 16 80 00 00 	movabs $0x8016f4,%rax
  8019e1:	00 00 00 
  8019e4:	ff d0                	call   *%rax
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	78 35                	js     801a1f <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019ea:	41 8b 46 08          	mov    0x8(%r14),%eax
  8019ee:	83 e0 03             	and    $0x3,%eax
  8019f1:	83 f8 01             	cmp    $0x1,%eax
  8019f4:	74 2d                	je     801a23 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8019f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019fa:	48 8b 40 10          	mov    0x10(%rax),%rax
  8019fe:	48 85 c0             	test   %rax,%rax
  801a01:	74 56                	je     801a59 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801a03:	4c 89 ea             	mov    %r13,%rdx
  801a06:	4c 89 e6             	mov    %r12,%rsi
  801a09:	4c 89 f7             	mov    %r14,%rdi
  801a0c:	ff d0                	call   *%rax
}
  801a0e:	48 83 c4 10          	add    $0x10,%rsp
  801a12:	5b                   	pop    %rbx
  801a13:	41 5c                	pop    %r12
  801a15:	41 5d                	pop    %r13
  801a17:	41 5e                	pop    %r14
  801a19:	5d                   	pop    %rbp
  801a1a:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a1b:	48 98                	cltq
  801a1d:	eb ef                	jmp    801a0e <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a1f:	48 98                	cltq
  801a21:	eb eb                	jmp    801a0e <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a23:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801a2a:	00 00 00 
  801a2d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a33:	89 da                	mov    %ebx,%edx
  801a35:	48 bf fb 41 80 00 00 	movabs $0x8041fb,%rdi
  801a3c:	00 00 00 
  801a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a44:	48 b9 f9 02 80 00 00 	movabs $0x8002f9,%rcx
  801a4b:	00 00 00 
  801a4e:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a50:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801a57:	eb b5                	jmp    801a0e <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801a59:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a60:	eb ac                	jmp    801a0e <read+0x6e>

0000000000801a62 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801a62:	f3 0f 1e fa          	endbr64
  801a66:	55                   	push   %rbp
  801a67:	48 89 e5             	mov    %rsp,%rbp
  801a6a:	41 57                	push   %r15
  801a6c:	41 56                	push   %r14
  801a6e:	41 55                	push   %r13
  801a70:	41 54                	push   %r12
  801a72:	53                   	push   %rbx
  801a73:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801a77:	48 85 d2             	test   %rdx,%rdx
  801a7a:	74 54                	je     801ad0 <readn+0x6e>
  801a7c:	41 89 fd             	mov    %edi,%r13d
  801a7f:	49 89 f6             	mov    %rsi,%r14
  801a82:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801a85:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801a8a:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801a8f:	49 bf a0 19 80 00 00 	movabs $0x8019a0,%r15
  801a96:	00 00 00 
  801a99:	4c 89 e2             	mov    %r12,%rdx
  801a9c:	48 29 f2             	sub    %rsi,%rdx
  801a9f:	4c 01 f6             	add    %r14,%rsi
  801aa2:	44 89 ef             	mov    %r13d,%edi
  801aa5:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	78 20                	js     801acc <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801aac:	01 c3                	add    %eax,%ebx
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	74 08                	je     801aba <readn+0x58>
  801ab2:	48 63 f3             	movslq %ebx,%rsi
  801ab5:	4c 39 e6             	cmp    %r12,%rsi
  801ab8:	72 df                	jb     801a99 <readn+0x37>
    }
    return res;
  801aba:	48 63 c3             	movslq %ebx,%rax
}
  801abd:	48 83 c4 08          	add    $0x8,%rsp
  801ac1:	5b                   	pop    %rbx
  801ac2:	41 5c                	pop    %r12
  801ac4:	41 5d                	pop    %r13
  801ac6:	41 5e                	pop    %r14
  801ac8:	41 5f                	pop    %r15
  801aca:	5d                   	pop    %rbp
  801acb:	c3                   	ret
        if (inc < 0) return inc;
  801acc:	48 98                	cltq
  801ace:	eb ed                	jmp    801abd <readn+0x5b>
    int inc = 1, res = 0;
  801ad0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ad5:	eb e3                	jmp    801aba <readn+0x58>

0000000000801ad7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801ad7:	f3 0f 1e fa          	endbr64
  801adb:	55                   	push   %rbp
  801adc:	48 89 e5             	mov    %rsp,%rbp
  801adf:	41 56                	push   %r14
  801ae1:	41 55                	push   %r13
  801ae3:	41 54                	push   %r12
  801ae5:	53                   	push   %rbx
  801ae6:	48 83 ec 10          	sub    $0x10,%rsp
  801aea:	89 fb                	mov    %edi,%ebx
  801aec:	49 89 f4             	mov    %rsi,%r12
  801aef:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801af2:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801af6:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  801afd:	00 00 00 
  801b00:	ff d0                	call   *%rax
  801b02:	85 c0                	test   %eax,%eax
  801b04:	78 47                	js     801b4d <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b06:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801b0a:	41 8b 3e             	mov    (%r14),%edi
  801b0d:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b11:	48 b8 f4 16 80 00 00 	movabs $0x8016f4,%rax
  801b18:	00 00 00 
  801b1b:	ff d0                	call   *%rax
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	78 30                	js     801b51 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b21:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801b26:	74 2d                	je     801b55 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801b28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b2c:	48 8b 40 18          	mov    0x18(%rax),%rax
  801b30:	48 85 c0             	test   %rax,%rax
  801b33:	74 56                	je     801b8b <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801b35:	4c 89 ea             	mov    %r13,%rdx
  801b38:	4c 89 e6             	mov    %r12,%rsi
  801b3b:	4c 89 f7             	mov    %r14,%rdi
  801b3e:	ff d0                	call   *%rax
}
  801b40:	48 83 c4 10          	add    $0x10,%rsp
  801b44:	5b                   	pop    %rbx
  801b45:	41 5c                	pop    %r12
  801b47:	41 5d                	pop    %r13
  801b49:	41 5e                	pop    %r14
  801b4b:	5d                   	pop    %rbp
  801b4c:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b4d:	48 98                	cltq
  801b4f:	eb ef                	jmp    801b40 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b51:	48 98                	cltq
  801b53:	eb eb                	jmp    801b40 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b55:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801b5c:	00 00 00 
  801b5f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b65:	89 da                	mov    %ebx,%edx
  801b67:	48 bf 17 42 80 00 00 	movabs $0x804217,%rdi
  801b6e:	00 00 00 
  801b71:	b8 00 00 00 00       	mov    $0x0,%eax
  801b76:	48 b9 f9 02 80 00 00 	movabs $0x8002f9,%rcx
  801b7d:	00 00 00 
  801b80:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b82:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801b89:	eb b5                	jmp    801b40 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801b8b:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801b92:	eb ac                	jmp    801b40 <write+0x69>

0000000000801b94 <seek>:

int
seek(int fdnum, off_t offset) {
  801b94:	f3 0f 1e fa          	endbr64
  801b98:	55                   	push   %rbp
  801b99:	48 89 e5             	mov    %rsp,%rbp
  801b9c:	53                   	push   %rbx
  801b9d:	48 83 ec 18          	sub    $0x18,%rsp
  801ba1:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ba3:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ba7:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  801bae:	00 00 00 
  801bb1:	ff d0                	call   *%rax
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	78 0c                	js     801bc3 <seek+0x2f>

    fd->fd_offset = offset;
  801bb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bbb:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801bbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801bc7:	c9                   	leave
  801bc8:	c3                   	ret

0000000000801bc9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801bc9:	f3 0f 1e fa          	endbr64
  801bcd:	55                   	push   %rbp
  801bce:	48 89 e5             	mov    %rsp,%rbp
  801bd1:	41 55                	push   %r13
  801bd3:	41 54                	push   %r12
  801bd5:	53                   	push   %rbx
  801bd6:	48 83 ec 18          	sub    $0x18,%rsp
  801bda:	89 fb                	mov    %edi,%ebx
  801bdc:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bdf:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801be3:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  801bea:	00 00 00 
  801bed:	ff d0                	call   *%rax
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	78 38                	js     801c2b <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801bf3:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801bf7:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801bfb:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801bff:	48 b8 f4 16 80 00 00 	movabs $0x8016f4,%rax
  801c06:	00 00 00 
  801c09:	ff d0                	call   *%rax
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	78 1c                	js     801c2b <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c0f:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801c14:	74 20                	je     801c36 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c1a:	48 8b 40 30          	mov    0x30(%rax),%rax
  801c1e:	48 85 c0             	test   %rax,%rax
  801c21:	74 47                	je     801c6a <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801c23:	44 89 e6             	mov    %r12d,%esi
  801c26:	4c 89 ef             	mov    %r13,%rdi
  801c29:	ff d0                	call   *%rax
}
  801c2b:	48 83 c4 18          	add    $0x18,%rsp
  801c2f:	5b                   	pop    %rbx
  801c30:	41 5c                	pop    %r12
  801c32:	41 5d                	pop    %r13
  801c34:	5d                   	pop    %rbp
  801c35:	c3                   	ret
                thisenv->env_id, fdnum);
  801c36:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801c3d:	00 00 00 
  801c40:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c46:	89 da                	mov    %ebx,%edx
  801c48:	48 bf a8 43 80 00 00 	movabs $0x8043a8,%rdi
  801c4f:	00 00 00 
  801c52:	b8 00 00 00 00       	mov    $0x0,%eax
  801c57:	48 b9 f9 02 80 00 00 	movabs $0x8002f9,%rcx
  801c5e:	00 00 00 
  801c61:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c63:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c68:	eb c1                	jmp    801c2b <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c6a:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801c6f:	eb ba                	jmp    801c2b <ftruncate+0x62>

0000000000801c71 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801c71:	f3 0f 1e fa          	endbr64
  801c75:	55                   	push   %rbp
  801c76:	48 89 e5             	mov    %rsp,%rbp
  801c79:	41 54                	push   %r12
  801c7b:	53                   	push   %rbx
  801c7c:	48 83 ec 10          	sub    $0x10,%rsp
  801c80:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c83:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c87:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  801c8e:	00 00 00 
  801c91:	ff d0                	call   *%rax
  801c93:	85 c0                	test   %eax,%eax
  801c95:	78 4e                	js     801ce5 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c97:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801c9b:	41 8b 3c 24          	mov    (%r12),%edi
  801c9f:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801ca3:	48 b8 f4 16 80 00 00 	movabs $0x8016f4,%rax
  801caa:	00 00 00 
  801cad:	ff d0                	call   *%rax
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	78 32                	js     801ce5 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801cb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cb7:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801cbc:	74 30                	je     801cee <fstat+0x7d>

    stat->st_name[0] = 0;
  801cbe:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801cc1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801cc8:	00 00 00 
    stat->st_isdir = 0;
  801ccb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801cd2:	00 00 00 
    stat->st_dev = dev;
  801cd5:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801cdc:	48 89 de             	mov    %rbx,%rsi
  801cdf:	4c 89 e7             	mov    %r12,%rdi
  801ce2:	ff 50 28             	call   *0x28(%rax)
}
  801ce5:	48 83 c4 10          	add    $0x10,%rsp
  801ce9:	5b                   	pop    %rbx
  801cea:	41 5c                	pop    %r12
  801cec:	5d                   	pop    %rbp
  801ced:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801cee:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801cf3:	eb f0                	jmp    801ce5 <fstat+0x74>

0000000000801cf5 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801cf5:	f3 0f 1e fa          	endbr64
  801cf9:	55                   	push   %rbp
  801cfa:	48 89 e5             	mov    %rsp,%rbp
  801cfd:	41 54                	push   %r12
  801cff:	53                   	push   %rbx
  801d00:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801d03:	be 00 00 00 00       	mov    $0x0,%esi
  801d08:	48 b8 d6 1f 80 00 00 	movabs $0x801fd6,%rax
  801d0f:	00 00 00 
  801d12:	ff d0                	call   *%rax
  801d14:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801d16:	85 c0                	test   %eax,%eax
  801d18:	78 25                	js     801d3f <stat+0x4a>

    int res = fstat(fd, stat);
  801d1a:	4c 89 e6             	mov    %r12,%rsi
  801d1d:	89 c7                	mov    %eax,%edi
  801d1f:	48 b8 71 1c 80 00 00 	movabs $0x801c71,%rax
  801d26:	00 00 00 
  801d29:	ff d0                	call   *%rax
  801d2b:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801d2e:	89 df                	mov    %ebx,%edi
  801d30:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  801d37:	00 00 00 
  801d3a:	ff d0                	call   *%rax

    return res;
  801d3c:	44 89 e3             	mov    %r12d,%ebx
}
  801d3f:	89 d8                	mov    %ebx,%eax
  801d41:	5b                   	pop    %rbx
  801d42:	41 5c                	pop    %r12
  801d44:	5d                   	pop    %rbp
  801d45:	c3                   	ret

0000000000801d46 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801d46:	f3 0f 1e fa          	endbr64
  801d4a:	55                   	push   %rbp
  801d4b:	48 89 e5             	mov    %rsp,%rbp
  801d4e:	41 54                	push   %r12
  801d50:	53                   	push   %rbx
  801d51:	48 83 ec 10          	sub    $0x10,%rsp
  801d55:	41 89 fc             	mov    %edi,%r12d
  801d58:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801d5b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801d62:	00 00 00 
  801d65:	83 38 00             	cmpl   $0x0,(%rax)
  801d68:	74 6e                	je     801dd8 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801d6a:	bf 03 00 00 00       	mov    $0x3,%edi
  801d6f:	48 b8 55 35 80 00 00 	movabs $0x803555,%rax
  801d76:	00 00 00 
  801d79:	ff d0                	call   *%rax
  801d7b:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801d82:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801d84:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801d8a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801d8f:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  801d96:	00 00 00 
  801d99:	44 89 e6             	mov    %r12d,%esi
  801d9c:	89 c7                	mov    %eax,%edi
  801d9e:	48 b8 93 34 80 00 00 	movabs $0x803493,%rax
  801da5:	00 00 00 
  801da8:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801daa:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801db1:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801db2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801db7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801dbb:	48 89 de             	mov    %rbx,%rsi
  801dbe:	bf 00 00 00 00       	mov    $0x0,%edi
  801dc3:	48 b8 fa 33 80 00 00 	movabs $0x8033fa,%rax
  801dca:	00 00 00 
  801dcd:	ff d0                	call   *%rax
}
  801dcf:	48 83 c4 10          	add    $0x10,%rsp
  801dd3:	5b                   	pop    %rbx
  801dd4:	41 5c                	pop    %r12
  801dd6:	5d                   	pop    %rbp
  801dd7:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801dd8:	bf 03 00 00 00       	mov    $0x3,%edi
  801ddd:	48 b8 55 35 80 00 00 	movabs $0x803555,%rax
  801de4:	00 00 00 
  801de7:	ff d0                	call   *%rax
  801de9:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801df0:	00 00 
  801df2:	e9 73 ff ff ff       	jmp    801d6a <fsipc+0x24>

0000000000801df7 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801df7:	f3 0f 1e fa          	endbr64
  801dfb:	55                   	push   %rbp
  801dfc:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dff:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801e06:	00 00 00 
  801e09:	8b 57 0c             	mov    0xc(%rdi),%edx
  801e0c:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801e0e:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801e11:	be 00 00 00 00       	mov    $0x0,%esi
  801e16:	bf 02 00 00 00       	mov    $0x2,%edi
  801e1b:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  801e22:	00 00 00 
  801e25:	ff d0                	call   *%rax
}
  801e27:	5d                   	pop    %rbp
  801e28:	c3                   	ret

0000000000801e29 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801e29:	f3 0f 1e fa          	endbr64
  801e2d:	55                   	push   %rbp
  801e2e:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e31:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e34:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801e3b:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801e3d:	be 00 00 00 00       	mov    $0x0,%esi
  801e42:	bf 06 00 00 00       	mov    $0x6,%edi
  801e47:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  801e4e:	00 00 00 
  801e51:	ff d0                	call   *%rax
}
  801e53:	5d                   	pop    %rbp
  801e54:	c3                   	ret

0000000000801e55 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801e55:	f3 0f 1e fa          	endbr64
  801e59:	55                   	push   %rbp
  801e5a:	48 89 e5             	mov    %rsp,%rbp
  801e5d:	41 54                	push   %r12
  801e5f:	53                   	push   %rbx
  801e60:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e63:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e66:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801e6d:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801e6f:	be 00 00 00 00       	mov    $0x0,%esi
  801e74:	bf 05 00 00 00       	mov    $0x5,%edi
  801e79:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  801e80:	00 00 00 
  801e83:	ff d0                	call   *%rax
    if (res < 0) return res;
  801e85:	85 c0                	test   %eax,%eax
  801e87:	78 3d                	js     801ec6 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e89:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  801e90:	00 00 00 
  801e93:	4c 89 e6             	mov    %r12,%rsi
  801e96:	48 89 df             	mov    %rbx,%rdi
  801e99:	48 b8 42 0c 80 00 00 	movabs $0x800c42,%rax
  801ea0:	00 00 00 
  801ea3:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801ea5:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801eac:	00 
  801ead:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801eb3:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801eba:	00 
  801ebb:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801ec1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec6:	5b                   	pop    %rbx
  801ec7:	41 5c                	pop    %r12
  801ec9:	5d                   	pop    %rbp
  801eca:	c3                   	ret

0000000000801ecb <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801ecb:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801ecf:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801ed6:	77 41                	ja     801f19 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801ed8:	55                   	push   %rbp
  801ed9:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801edc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801ee3:	00 00 00 
  801ee6:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801ee9:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  801eeb:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801eef:	48 8d 78 10          	lea    0x10(%rax),%rdi
  801ef3:	48 b8 5d 0e 80 00 00 	movabs $0x800e5d,%rax
  801efa:	00 00 00 
  801efd:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  801eff:	be 00 00 00 00       	mov    $0x0,%esi
  801f04:	bf 04 00 00 00       	mov    $0x4,%edi
  801f09:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  801f10:	00 00 00 
  801f13:	ff d0                	call   *%rax
  801f15:	48 98                	cltq
}
  801f17:	5d                   	pop    %rbp
  801f18:	c3                   	ret
        return -E_INVAL;
  801f19:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  801f20:	c3                   	ret

0000000000801f21 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801f21:	f3 0f 1e fa          	endbr64
  801f25:	55                   	push   %rbp
  801f26:	48 89 e5             	mov    %rsp,%rbp
  801f29:	41 55                	push   %r13
  801f2b:	41 54                	push   %r12
  801f2d:	53                   	push   %rbx
  801f2e:	48 83 ec 08          	sub    $0x8,%rsp
  801f32:	49 89 f4             	mov    %rsi,%r12
  801f35:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f38:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801f3f:	00 00 00 
  801f42:	8b 57 0c             	mov    0xc(%rdi),%edx
  801f45:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  801f47:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  801f4b:	be 00 00 00 00       	mov    $0x0,%esi
  801f50:	bf 03 00 00 00       	mov    $0x3,%edi
  801f55:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  801f5c:	00 00 00 
  801f5f:	ff d0                	call   *%rax
  801f61:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  801f64:	4d 85 ed             	test   %r13,%r13
  801f67:	78 2a                	js     801f93 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  801f69:	4c 89 ea             	mov    %r13,%rdx
  801f6c:	4c 39 eb             	cmp    %r13,%rbx
  801f6f:	72 30                	jb     801fa1 <devfile_read+0x80>
  801f71:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  801f78:	7f 27                	jg     801fa1 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  801f7a:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801f81:	00 00 00 
  801f84:	4c 89 e7             	mov    %r12,%rdi
  801f87:	48 b8 5d 0e 80 00 00 	movabs $0x800e5d,%rax
  801f8e:	00 00 00 
  801f91:	ff d0                	call   *%rax
}
  801f93:	4c 89 e8             	mov    %r13,%rax
  801f96:	48 83 c4 08          	add    $0x8,%rsp
  801f9a:	5b                   	pop    %rbx
  801f9b:	41 5c                	pop    %r12
  801f9d:	41 5d                	pop    %r13
  801f9f:	5d                   	pop    %rbp
  801fa0:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801fa1:	48 b9 34 42 80 00 00 	movabs $0x804234,%rcx
  801fa8:	00 00 00 
  801fab:	48 ba 51 42 80 00 00 	movabs $0x804251,%rdx
  801fb2:	00 00 00 
  801fb5:	be 7b 00 00 00       	mov    $0x7b,%esi
  801fba:	48 bf 66 42 80 00 00 	movabs $0x804266,%rdi
  801fc1:	00 00 00 
  801fc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc9:	49 b8 9d 01 80 00 00 	movabs $0x80019d,%r8
  801fd0:	00 00 00 
  801fd3:	41 ff d0             	call   *%r8

0000000000801fd6 <open>:
open(const char *path, int mode) {
  801fd6:	f3 0f 1e fa          	endbr64
  801fda:	55                   	push   %rbp
  801fdb:	48 89 e5             	mov    %rsp,%rbp
  801fde:	41 55                	push   %r13
  801fe0:	41 54                	push   %r12
  801fe2:	53                   	push   %rbx
  801fe3:	48 83 ec 18          	sub    $0x18,%rsp
  801fe7:	49 89 fc             	mov    %rdi,%r12
  801fea:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801fed:	48 b8 fd 0b 80 00 00 	movabs $0x800bfd,%rax
  801ff4:	00 00 00 
  801ff7:	ff d0                	call   *%rax
  801ff9:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801fff:	0f 87 8a 00 00 00    	ja     80208f <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802005:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802009:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  802010:	00 00 00 
  802013:	ff d0                	call   *%rax
  802015:	89 c3                	mov    %eax,%ebx
  802017:	85 c0                	test   %eax,%eax
  802019:	78 50                	js     80206b <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80201b:	4c 89 e6             	mov    %r12,%rsi
  80201e:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  802025:	00 00 00 
  802028:	48 89 df             	mov    %rbx,%rdi
  80202b:	48 b8 42 0c 80 00 00 	movabs $0x800c42,%rax
  802032:	00 00 00 
  802035:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802037:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80203e:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802042:	bf 01 00 00 00       	mov    $0x1,%edi
  802047:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  80204e:	00 00 00 
  802051:	ff d0                	call   *%rax
  802053:	89 c3                	mov    %eax,%ebx
  802055:	85 c0                	test   %eax,%eax
  802057:	78 1f                	js     802078 <open+0xa2>
    return fd2num(fd);
  802059:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80205d:	48 b8 0b 16 80 00 00 	movabs $0x80160b,%rax
  802064:	00 00 00 
  802067:	ff d0                	call   *%rax
  802069:	89 c3                	mov    %eax,%ebx
}
  80206b:	89 d8                	mov    %ebx,%eax
  80206d:	48 83 c4 18          	add    $0x18,%rsp
  802071:	5b                   	pop    %rbx
  802072:	41 5c                	pop    %r12
  802074:	41 5d                	pop    %r13
  802076:	5d                   	pop    %rbp
  802077:	c3                   	ret
        fd_close(fd, 0);
  802078:	be 00 00 00 00       	mov    $0x0,%esi
  80207d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802081:	48 b8 68 17 80 00 00 	movabs $0x801768,%rax
  802088:	00 00 00 
  80208b:	ff d0                	call   *%rax
        return res;
  80208d:	eb dc                	jmp    80206b <open+0x95>
        return -E_BAD_PATH;
  80208f:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802094:	eb d5                	jmp    80206b <open+0x95>

0000000000802096 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802096:	f3 0f 1e fa          	endbr64
  80209a:	55                   	push   %rbp
  80209b:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80209e:	be 00 00 00 00       	mov    $0x0,%esi
  8020a3:	bf 08 00 00 00       	mov    $0x8,%edi
  8020a8:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  8020af:	00 00 00 
  8020b2:	ff d0                	call   *%rax
}
  8020b4:	5d                   	pop    %rbp
  8020b5:	c3                   	ret

00000000008020b6 <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  8020b6:	f3 0f 1e fa          	endbr64
  8020ba:	55                   	push   %rbp
  8020bb:	48 89 e5             	mov    %rsp,%rbp
  8020be:	41 55                	push   %r13
  8020c0:	41 54                	push   %r12
  8020c2:	53                   	push   %rbx
  8020c3:	48 83 ec 08          	sub    $0x8,%rsp
  8020c7:	48 89 fb             	mov    %rdi,%rbx
  8020ca:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  8020cd:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  8020d0:	48 b8 28 30 80 00 00 	movabs $0x803028,%rax
  8020d7:	00 00 00 
  8020da:	ff d0                	call   *%rax
  8020dc:	41 89 c1             	mov    %eax,%r9d
  8020df:	4d 89 e0             	mov    %r12,%r8
  8020e2:	49 29 d8             	sub    %rbx,%r8
  8020e5:	48 89 d9             	mov    %rbx,%rcx
  8020e8:	44 89 ea             	mov    %r13d,%edx
  8020eb:	48 89 de             	mov    %rbx,%rsi
  8020ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f3:	48 b8 b2 12 80 00 00 	movabs $0x8012b2,%rax
  8020fa:	00 00 00 
  8020fd:	ff d0                	call   *%rax
}
  8020ff:	48 83 c4 08          	add    $0x8,%rsp
  802103:	5b                   	pop    %rbx
  802104:	41 5c                	pop    %r12
  802106:	41 5d                	pop    %r13
  802108:	5d                   	pop    %rbp
  802109:	c3                   	ret

000000000080210a <spawn>:
spawn(const char *prog, const char **argv) {
  80210a:	f3 0f 1e fa          	endbr64
  80210e:	55                   	push   %rbp
  80210f:	48 89 e5             	mov    %rsp,%rbp
  802112:	41 57                	push   %r15
  802114:	41 56                	push   %r14
  802116:	41 55                	push   %r13
  802118:	41 54                	push   %r12
  80211a:	53                   	push   %rbx
  80211b:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  802122:	49 89 f4             	mov    %rsi,%r12
    int fd = open(prog, O_RDONLY);
  802125:	be 00 00 00 00       	mov    $0x0,%esi
  80212a:	48 b8 d6 1f 80 00 00 	movabs $0x801fd6,%rax
  802131:	00 00 00 
  802134:	ff d0                	call   *%rax
  802136:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
    if (fd < 0) return fd;
  80213c:	85 c0                	test   %eax,%eax
  80213e:	0f 88 30 06 00 00    	js     802774 <spawn+0x66a>
  802144:	89 c7                	mov    %eax,%edi
    res = readn(fd, elf_buf, sizeof(elf_buf));
  802146:	ba 00 02 00 00       	mov    $0x200,%edx
  80214b:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  802152:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  802159:	00 00 00 
  80215c:	ff d0                	call   *%rax
  80215e:	89 c6                	mov    %eax,%esi
    if (res != sizeof(elf_buf)) {
  802160:	3d 00 02 00 00       	cmp    $0x200,%eax
  802165:	0f 85 7d 02 00 00    	jne    8023e8 <spawn+0x2de>
        elf->e_elf[1] != 1 /* little endian */ ||
  80216b:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  802172:	ff ff 00 
  802175:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  80217c:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  802183:	01 01 00 
  802186:	48 39 d0             	cmp    %rdx,%rax
  802189:	0f 85 95 02 00 00    	jne    802424 <spawn+0x31a>
        elf->e_type != ET_EXEC /* executable */ ||
  80218f:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  802196:	00 3e 00 
  802199:	0f 85 85 02 00 00    	jne    802424 <spawn+0x31a>

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  80219f:	b8 09 00 00 00       	mov    $0x9,%eax
  8021a4:	cd 30                	int    $0x30
  8021a6:	41 89 c6             	mov    %eax,%r14d
  8021a9:	89 c3                	mov    %eax,%ebx
    if ((int)(res = sys_exofork()) < 0) goto error2;
  8021ab:	85 c0                	test   %eax,%eax
  8021ad:	0f 88 a9 05 00 00    	js     80275c <spawn+0x652>
    envid_t child = res;
  8021b3:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  8021b9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8021be:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8021c2:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8021c6:	48 c1 e0 04          	shl    $0x4,%rax
  8021ca:	48 be 00 00 a0 1f 80 	movabs $0x801fa00000,%rsi
  8021d1:	00 00 00 
  8021d4:	48 01 c6             	add    %rax,%rsi
  8021d7:	48 8b 06             	mov    (%rsi),%rax
  8021da:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  8021e1:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  8021e8:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  8021ef:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  8021f6:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  8021fd:	48 29 ce             	sub    %rcx,%rsi
  802200:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  802206:	c1 e9 03             	shr    $0x3,%ecx
  802209:	89 c9                	mov    %ecx,%ecx
  80220b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  80220e:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802215:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  80221c:	49 8b 3c 24          	mov    (%r12),%rdi
  802220:	48 85 ff             	test   %rdi,%rdi
  802223:	0f 84 7f 05 00 00    	je     8027a8 <spawn+0x69e>
  802229:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    string_size = 0;
  80222f:	41 bf 00 00 00 00    	mov    $0x0,%r15d
        string_size += strlen(argv[argc]) + 1;
  802235:	48 bb fd 0b 80 00 00 	movabs $0x800bfd,%rbx
  80223c:	00 00 00 
  80223f:	ff d3                	call   *%rbx
  802241:	4c 01 f8             	add    %r15,%rax
  802244:	4c 8d 78 01          	lea    0x1(%rax),%r15
    for (argc = 0; argv[argc] != 0; argc++)
  802248:	4c 89 ea             	mov    %r13,%rdx
  80224b:	49 83 c5 01          	add    $0x1,%r13
  80224f:	4b 8b 7c ec f8       	mov    -0x8(%r12,%r13,8),%rdi
  802254:	48 85 ff             	test   %rdi,%rdi
  802257:	75 e6                	jne    80223f <spawn+0x135>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802259:	49 89 d5             	mov    %rdx,%r13
  80225c:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  802263:	48 f7 d0             	not    %rax
  802266:	48 8d 98 00 00 41 00 	lea    0x410000(%rax),%rbx
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  80226d:	49 89 df             	mov    %rbx,%r15
  802270:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  802274:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  80227b:	89 d0                	mov    %edx,%eax
  80227d:	83 c0 01             	add    $0x1,%eax
  802280:	48 98                	cltq
  802282:	48 c1 e0 03          	shl    $0x3,%rax
  802286:	49 29 c7             	sub    %rax,%r15
  802289:	4c 89 bd f0 fc ff ff 	mov    %r15,-0x310(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  802290:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  802294:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80229a:	0f 86 ff 04 00 00    	jbe    80279f <spawn+0x695>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  8022a0:	b9 06 00 00 00       	mov    $0x6,%ecx
  8022a5:	ba 00 00 01 00       	mov    $0x10000,%edx
  8022aa:	be 00 00 40 00       	mov    $0x400000,%esi
  8022af:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  8022b6:	00 00 00 
  8022b9:	ff d0                	call   *%rax
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	0f 88 e1 04 00 00    	js     8027a4 <spawn+0x69a>
    for (i = 0; i < argc; i++) {
  8022c3:	4c 89 e8             	mov    %r13,%rax
  8022c6:	45 85 ed             	test   %r13d,%r13d
  8022c9:	7e 54                	jle    80231f <spawn+0x215>
  8022cb:	4d 89 fd             	mov    %r15,%r13
  8022ce:	48 98                	cltq
  8022d0:	4d 8d 3c c7          	lea    (%r15,%rax,8),%r15
        argv_store[i] = UTEMP2USTACK(string_store);
  8022d4:	48 b8 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rax
  8022db:	00 00 00 
  8022de:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  8022e5:	ff 
  8022e6:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  8022ea:	49 8b 34 24          	mov    (%r12),%rsi
  8022ee:	48 89 df             	mov    %rbx,%rdi
  8022f1:	48 b8 42 0c 80 00 00 	movabs $0x800c42,%rax
  8022f8:	00 00 00 
  8022fb:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  8022fd:	49 8b 3c 24          	mov    (%r12),%rdi
  802301:	48 b8 fd 0b 80 00 00 	movabs $0x800bfd,%rax
  802308:	00 00 00 
  80230b:	ff d0                	call   *%rax
  80230d:	48 8d 5c 03 01       	lea    0x1(%rbx,%rax,1),%rbx
    for (i = 0; i < argc; i++) {
  802312:	49 83 c5 08          	add    $0x8,%r13
  802316:	49 83 c4 08          	add    $0x8,%r12
  80231a:	4d 39 fd             	cmp    %r15,%r13
  80231d:	75 b5                	jne    8022d4 <spawn+0x1ca>
    argv_store[argc] = 0;
  80231f:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  802326:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  80232d:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  80232e:	48 81 fb 00 00 41 00 	cmp    $0x410000,%rbx
  802335:	0f 85 30 01 00 00    	jne    80246b <spawn+0x361>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  80233b:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  802342:	00 00 00 
  802345:	48 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%rsi
  80234c:	48 8d 84 0e 00 00 c0 	lea    -0x400000(%rsi,%rcx,1),%rax
  802353:	ff 
  802354:	48 89 46 f8          	mov    %rax,-0x8(%rsi)
    argv_store[-2] = argc;
  802358:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  80235f:	48 89 46 f0          	mov    %rax,-0x10(%rsi)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  802363:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  80236a:	00 00 00 
  80236d:	48 8d 84 06 00 00 c0 	lea    -0x400000(%rsi,%rax,1),%rax
  802374:	ff 
  802375:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  80237c:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  802382:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  802388:	44 89 f2             	mov    %r14d,%edx
  80238b:	be 00 00 40 00       	mov    $0x400000,%esi
  802390:	bf 00 00 00 00       	mov    $0x0,%edi
  802395:	48 b8 b2 12 80 00 00 	movabs $0x8012b2,%rax
  80239c:	00 00 00 
  80239f:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  8023a1:	48 bb 87 13 80 00 00 	movabs $0x801387,%rbx
  8023a8:	00 00 00 
  8023ab:	ba 00 00 01 00       	mov    $0x10000,%edx
  8023b0:	be 00 00 40 00       	mov    $0x400000,%esi
  8023b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ba:	ff d3                	call   *%rbx
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	78 eb                	js     8023ab <spawn+0x2a1>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  8023c0:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  8023c7:	4c 8d b4 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r14
  8023ce:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8023cf:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  8023d6:	00 
  8023d7:	0f 84 68 02 00 00    	je     802645 <spawn+0x53b>
  8023dd:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  8023e3:	e9 c5 01 00 00       	jmp    8025ad <spawn+0x4a3>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  8023e8:	48 bf d0 43 80 00 00 	movabs $0x8043d0,%rdi
  8023ef:	00 00 00 
  8023f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f7:	48 ba f9 02 80 00 00 	movabs $0x8002f9,%rdx
  8023fe:	00 00 00 
  802401:	ff d2                	call   *%rdx
        close(fd);
  802403:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802409:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  802410:	00 00 00 
  802413:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802415:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  80241c:	ff ff ff 
  80241f:	e9 50 03 00 00       	jmp    802774 <spawn+0x66a>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802424:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802429:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  80242f:	48 bf 71 42 80 00 00 	movabs $0x804271,%rdi
  802436:	00 00 00 
  802439:	b8 00 00 00 00       	mov    $0x0,%eax
  80243e:	48 b9 f9 02 80 00 00 	movabs $0x8002f9,%rcx
  802445:	00 00 00 
  802448:	ff d1                	call   *%rcx
        close(fd);
  80244a:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802450:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  802457:	00 00 00 
  80245a:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  80245c:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  802463:	ff ff ff 
  802466:	e9 09 03 00 00       	jmp    802774 <spawn+0x66a>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  80246b:	48 b9 00 44 80 00 00 	movabs $0x804400,%rcx
  802472:	00 00 00 
  802475:	48 ba 51 42 80 00 00 	movabs $0x804251,%rdx
  80247c:	00 00 00 
  80247f:	be f0 00 00 00       	mov    $0xf0,%esi
  802484:	48 bf 8b 42 80 00 00 	movabs $0x80428b,%rdi
  80248b:	00 00 00 
  80248e:	b8 00 00 00 00       	mov    $0x0,%eax
  802493:	49 b8 9d 01 80 00 00 	movabs $0x80019d,%r8
  80249a:	00 00 00 
  80249d:	41 ff d0             	call   *%r8
    /* seek() fd to fileoffset  */
    /* read filesz to UTEMP */
    /* Map read section conents to child */
    /* Unmap it from parent */
    if (filesz != 0) {
        res = sys_alloc_region(CURENVID, UTEMP, filesz, perm | PROT_W);
  8024a0:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  8024a6:	83 c9 02             	or     $0x2,%ecx
  8024a9:	48 89 da             	mov    %rbx,%rdx
  8024ac:	be 00 00 40 00       	mov    $0x400000,%esi
  8024b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b6:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  8024bd:	00 00 00 
  8024c0:	ff d0                	call   *%rax
        if (res < 0) {
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	0f 88 7e 02 00 00    	js     802748 <spawn+0x63e>
            return res;
        }

        res = seek(fd, fileoffset);
  8024ca:	8b b5 e8 fc ff ff    	mov    -0x318(%rbp),%esi
  8024d0:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  8024d6:	48 b8 94 1b 80 00 00 	movabs $0x801b94,%rax
  8024dd:	00 00 00 
  8024e0:	ff d0                	call   *%rax
        if (res < 0) {
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	0f 88 a2 02 00 00    	js     80278c <spawn+0x682>
            return res;
        }

        res = readn(fd, (void *)UTEMP, filesz);
  8024ea:	48 89 da             	mov    %rbx,%rdx
  8024ed:	be 00 00 40 00       	mov    $0x400000,%esi
  8024f2:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  8024f8:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8024ff:	00 00 00 
  802502:	ff d0                	call   *%rax
        if (res < 0) {
  802504:	85 c0                	test   %eax,%eax
  802506:	0f 88 84 02 00 00    	js     802790 <spawn+0x686>
            return res;
        }

        res = sys_map_region(CURENVID, (void *)UTEMP, child, (void *)va, filesz, perm);
  80250c:	44 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%r9d
  802513:	49 89 d8             	mov    %rbx,%r8
  802516:	4c 89 e1             	mov    %r12,%rcx
  802519:	8b 95 e0 fc ff ff    	mov    -0x320(%rbp),%edx
  80251f:	be 00 00 40 00       	mov    $0x400000,%esi
  802524:	bf 00 00 00 00       	mov    $0x0,%edi
  802529:	48 b8 b2 12 80 00 00 	movabs $0x8012b2,%rax
  802530:	00 00 00 
  802533:	ff d0                	call   *%rax
        if (res < 0) {
  802535:	85 c0                	test   %eax,%eax
  802537:	0f 88 57 02 00 00    	js     802794 <spawn+0x68a>
            return res;
        }

        res = sys_unmap_region(CURENVID, UTEMP, filesz);
  80253d:	48 89 da             	mov    %rbx,%rdx
  802540:	be 00 00 40 00       	mov    $0x400000,%esi
  802545:	bf 00 00 00 00       	mov    $0x0,%edi
  80254a:	48 b8 87 13 80 00 00 	movabs $0x801387,%rax
  802551:	00 00 00 
  802554:	ff d0                	call   *%rax
        if (res < 0) {
  802556:	85 c0                	test   %eax,%eax
  802558:	0f 89 ca 00 00 00    	jns    802628 <spawn+0x51e>
  80255e:	89 c3                	mov    %eax,%ebx
  802560:	e9 e5 01 00 00       	jmp    80274a <spawn+0x640>
            return res;
        }
    }

    if (memsz > filesz) {
        res = sys_alloc_region(child, (void *)(va + filesz), (memsz - filesz), perm | ALLOC_ZERO);
  802565:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  80256b:	81 c9 00 00 10 00    	or     $0x100000,%ecx
  802571:	4c 89 ea             	mov    %r13,%rdx
  802574:	48 29 da             	sub    %rbx,%rdx
  802577:	4a 8d 34 23          	lea    (%rbx,%r12,1),%rsi
  80257b:	8b bd e0 fc ff ff    	mov    -0x320(%rbp),%edi
  802581:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  802588:	00 00 00 
  80258b:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  80258d:	85 c0                	test   %eax,%eax
  80258f:	0f 88 a1 00 00 00    	js     802636 <spawn+0x52c>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  802595:	49 83 c7 01          	add    $0x1,%r15
  802599:	49 83 c6 38          	add    $0x38,%r14
  80259d:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  8025a4:	49 39 c7             	cmp    %rax,%r15
  8025a7:	0f 83 98 00 00 00    	jae    802645 <spawn+0x53b>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  8025ad:	41 83 3e 01          	cmpl   $0x1,(%r14)
  8025b1:	75 e2                	jne    802595 <spawn+0x48b>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  8025b3:	41 8b 46 04          	mov    0x4(%r14),%eax
  8025b7:	89 c2                	mov    %eax,%edx
  8025b9:	83 e2 02             	and    $0x2,%edx
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  8025bc:	89 d1                	mov    %edx,%ecx
  8025be:	83 c9 04             	or     $0x4,%ecx
  8025c1:	a8 04                	test   $0x4,%al
  8025c3:	0f 45 d1             	cmovne %ecx,%edx
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  8025c6:	83 e0 01             	and    $0x1,%eax
  8025c9:	09 d0                	or     %edx,%eax
  8025cb:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  8025d1:	49 8b 46 08          	mov    0x8(%r14),%rax
  8025d5:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
  8025db:	49 8b 5e 20          	mov    0x20(%r14),%rbx
  8025df:	4d 8b 6e 28          	mov    0x28(%r14),%r13
  8025e3:	4d 8b 66 10          	mov    0x10(%r14),%r12
  8025e7:	8b 8d cc fd ff ff    	mov    -0x234(%rbp),%ecx
  8025ed:	89 8d e0 fc ff ff    	mov    %ecx,-0x320(%rbp)
    if (res) {
  8025f3:	44 89 e2             	mov    %r12d,%edx
  8025f6:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8025fc:	74 14                	je     802612 <spawn+0x508>
        va -= res;
  8025fe:	48 63 ca             	movslq %edx,%rcx
  802601:	49 29 cc             	sub    %rcx,%r12
        memsz += res;
  802604:	49 01 cd             	add    %rcx,%r13
        filesz += res;
  802607:	48 01 cb             	add    %rcx,%rbx
        fileoffset -= res;
  80260a:	29 d0                	sub    %edx,%eax
  80260c:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
    if (filesz > HUGE_PAGE_SIZE) {
  802612:	48 81 fb 00 00 20 00 	cmp    $0x200000,%rbx
  802619:	0f 87 79 01 00 00    	ja     802798 <spawn+0x68e>
    if (filesz != 0) {
  80261f:	48 85 db             	test   %rbx,%rbx
  802622:	0f 85 78 fe ff ff    	jne    8024a0 <spawn+0x396>
    if (memsz > filesz) {
  802628:	4c 39 eb             	cmp    %r13,%rbx
  80262b:	0f 83 64 ff ff ff    	jae    802595 <spawn+0x48b>
  802631:	e9 2f ff ff ff       	jmp    802565 <spawn+0x45b>
        if (res < 0) {
  802636:	ba 00 00 00 00       	mov    $0x0,%edx
  80263b:	0f 4e d0             	cmovle %eax,%edx
  80263e:	89 d3                	mov    %edx,%ebx
  802640:	e9 05 01 00 00       	jmp    80274a <spawn+0x640>
    close(fd);
  802645:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  80264b:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  802652:	00 00 00 
  802655:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  802657:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  80265e:	48 bf b6 20 80 00 00 	movabs $0x8020b6,%rdi
  802665:	00 00 00 
  802668:	48 b8 a8 30 80 00 00 	movabs $0x8030a8,%rax
  80266f:	00 00 00 
  802672:	ff d0                	call   *%rax
  802674:	85 c0                	test   %eax,%eax
  802676:	78 49                	js     8026c1 <spawn+0x5b7>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  802678:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  80267f:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802685:	48 b8 5f 14 80 00 00 	movabs $0x80145f,%rax
  80268c:	00 00 00 
  80268f:	ff d0                	call   *%rax
  802691:	85 c0                	test   %eax,%eax
  802693:	78 59                	js     8026ee <spawn+0x5e4>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802695:	be 02 00 00 00       	mov    $0x2,%esi
  80269a:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  8026a0:	48 b8 f2 13 80 00 00 	movabs $0x8013f2,%rax
  8026a7:	00 00 00 
  8026aa:	ff d0                	call   *%rax
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	78 6b                	js     80271b <spawn+0x611>
    return child;
  8026b0:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8026b6:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
  8026bc:	e9 b3 00 00 00       	jmp    802774 <spawn+0x66a>
        panic("copy_shared_region: %i", res);
  8026c1:	89 c1                	mov    %eax,%ecx
  8026c3:	48 ba 97 42 80 00 00 	movabs $0x804297,%rdx
  8026ca:	00 00 00 
  8026cd:	be 84 00 00 00       	mov    $0x84,%esi
  8026d2:	48 bf 8b 42 80 00 00 	movabs $0x80428b,%rdi
  8026d9:	00 00 00 
  8026dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e1:	49 b8 9d 01 80 00 00 	movabs $0x80019d,%r8
  8026e8:	00 00 00 
  8026eb:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  8026ee:	89 c1                	mov    %eax,%ecx
  8026f0:	48 ba ae 42 80 00 00 	movabs $0x8042ae,%rdx
  8026f7:	00 00 00 
  8026fa:	be 87 00 00 00       	mov    $0x87,%esi
  8026ff:	48 bf 8b 42 80 00 00 	movabs $0x80428b,%rdi
  802706:	00 00 00 
  802709:	b8 00 00 00 00       	mov    $0x0,%eax
  80270e:	49 b8 9d 01 80 00 00 	movabs $0x80019d,%r8
  802715:	00 00 00 
  802718:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  80271b:	89 c1                	mov    %eax,%ecx
  80271d:	48 ba c8 42 80 00 00 	movabs $0x8042c8,%rdx
  802724:	00 00 00 
  802727:	be 8a 00 00 00       	mov    $0x8a,%esi
  80272c:	48 bf 8b 42 80 00 00 	movabs $0x80428b,%rdi
  802733:	00 00 00 
  802736:	b8 00 00 00 00       	mov    $0x0,%eax
  80273b:	49 b8 9d 01 80 00 00 	movabs $0x80019d,%r8
  802742:	00 00 00 
  802745:	41 ff d0             	call   *%r8
  802748:	89 c3                	mov    %eax,%ebx
    sys_env_destroy(child);
  80274a:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802750:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  802757:	00 00 00 
  80275a:	ff d0                	call   *%rax
    close(fd);
  80275c:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802762:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  802769:	00 00 00 
  80276c:	ff d0                	call   *%rax
    return res;
  80276e:	89 9d fc fc ff ff    	mov    %ebx,-0x304(%rbp)
}
  802774:	8b 85 fc fc ff ff    	mov    -0x304(%rbp),%eax
  80277a:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  802781:	5b                   	pop    %rbx
  802782:	41 5c                	pop    %r12
  802784:	41 5d                	pop    %r13
  802786:	41 5e                	pop    %r14
  802788:	41 5f                	pop    %r15
  80278a:	5d                   	pop    %rbp
  80278b:	c3                   	ret
  80278c:	89 c3                	mov    %eax,%ebx
  80278e:	eb ba                	jmp    80274a <spawn+0x640>
  802790:	89 c3                	mov    %eax,%ebx
  802792:	eb b6                	jmp    80274a <spawn+0x640>
  802794:	89 c3                	mov    %eax,%ebx
  802796:	eb b2                	jmp    80274a <spawn+0x640>
        return -E_INVAL;
  802798:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
  80279d:	eb ab                	jmp    80274a <spawn+0x640>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  80279f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    if ((res = init_stack(child, argv, &child_tf)) < 0) goto error;
  8027a4:	89 c3                	mov    %eax,%ebx
  8027a6:	eb a2                	jmp    80274a <spawn+0x640>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  8027a8:	b9 06 00 00 00       	mov    $0x6,%ecx
  8027ad:	ba 00 00 01 00       	mov    $0x10000,%edx
  8027b2:	be 00 00 40 00       	mov    $0x400000,%esi
  8027b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8027bc:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  8027c3:	00 00 00 
  8027c6:	ff d0                	call   *%rax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	78 d8                	js     8027a4 <spawn+0x69a>
    for (argc = 0; argv[argc] != 0; argc++)
  8027cc:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  8027d3:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  8027d7:	48 c7 85 f0 fc ff ff 	movq   $0x40fff8,-0x310(%rbp)
  8027de:	f8 ff 40 00 
  8027e2:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  8027e9:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  8027ed:	bb 00 00 41 00       	mov    $0x410000,%ebx
  8027f2:	e9 28 fb ff ff       	jmp    80231f <spawn+0x215>

00000000008027f7 <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  8027f7:	f3 0f 1e fa          	endbr64
  8027fb:	55                   	push   %rbp
  8027fc:	48 89 e5             	mov    %rsp,%rbp
  8027ff:	48 83 ec 50          	sub    $0x50,%rsp
  802803:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802807:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80280b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80280f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  802813:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  80281a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80281e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802822:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802826:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  80282a:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  80282f:	eb 15                	jmp    802846 <spawnl+0x4f>
  802831:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802835:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802839:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80283d:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  802841:	74 1c                	je     80285f <spawnl+0x68>
  802843:	83 c1 01             	add    $0x1,%ecx
  802846:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802849:	83 f8 2f             	cmp    $0x2f,%eax
  80284c:	77 e3                	ja     802831 <spawnl+0x3a>
  80284e:	89 c2                	mov    %eax,%edx
  802850:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  802854:	4c 01 d2             	add    %r10,%rdx
  802857:	83 c0 08             	add    $0x8,%eax
  80285a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80285d:	eb de                	jmp    80283d <spawnl+0x46>
    const char *argv[argc + 2];
  80285f:	8d 41 02             	lea    0x2(%rcx),%eax
  802862:	48 98                	cltq
  802864:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  80286b:	00 
  80286c:	49 89 c0             	mov    %rax,%r8
  80286f:	49 83 e0 f0          	and    $0xfffffffffffffff0,%r8
  802873:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802879:	48 89 e2             	mov    %rsp,%rdx
  80287c:	48 29 c2             	sub    %rax,%rdx
  80287f:	48 39 d4             	cmp    %rdx,%rsp
  802882:	74 12                	je     802896 <spawnl+0x9f>
  802884:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  80288b:	48 83 8c 24 f8 0f 00 	orq    $0x0,0xff8(%rsp)
  802892:	00 00 
  802894:	eb e9                	jmp    80287f <spawnl+0x88>
  802896:	4c 89 c0             	mov    %r8,%rax
  802899:	25 ff 0f 00 00       	and    $0xfff,%eax
  80289e:	48 29 c4             	sub    %rax,%rsp
  8028a1:	48 85 c0             	test   %rax,%rax
  8028a4:	74 06                	je     8028ac <spawnl+0xb5>
  8028a6:	48 83 4c 04 f8 00    	orq    $0x0,-0x8(%rsp,%rax,1)
  8028ac:	4c 8d 4c 24 07       	lea    0x7(%rsp),%r9
  8028b1:	4c 89 c8             	mov    %r9,%rax
  8028b4:	48 c1 e8 03          	shr    $0x3,%rax
  8028b8:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
    argv[0] = arg0;
  8028bc:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  8028c3:	00 
    argv[argc + 1] = NULL;
  8028c4:	8d 41 01             	lea    0x1(%rcx),%eax
  8028c7:	48 98                	cltq
  8028c9:	49 c7 04 c1 00 00 00 	movq   $0x0,(%r9,%rax,8)
  8028d0:	00 
    va_start(vl, arg0);
  8028d1:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  8028d8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8028dc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8028e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8028e4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  8028e8:	85 c9                	test   %ecx,%ecx
  8028ea:	74 41                	je     80292d <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  8028ec:	49 89 c0             	mov    %rax,%r8
  8028ef:	49 8d 41 08          	lea    0x8(%r9),%rax
  8028f3:	8d 51 ff             	lea    -0x1(%rcx),%edx
  8028f6:	49 8d 74 d1 10       	lea    0x10(%r9,%rdx,8),%rsi
  8028fb:	eb 1b                	jmp    802918 <spawnl+0x121>
  8028fd:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802901:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  802905:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802909:	48 8b 11             	mov    (%rcx),%rdx
  80290c:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  80290f:	48 83 c0 08          	add    $0x8,%rax
  802913:	48 39 f0             	cmp    %rsi,%rax
  802916:	74 15                	je     80292d <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  802918:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80291b:	83 fa 2f             	cmp    $0x2f,%edx
  80291e:	77 dd                	ja     8028fd <spawnl+0x106>
  802920:	89 d1                	mov    %edx,%ecx
  802922:	4c 01 c1             	add    %r8,%rcx
  802925:	83 c2 08             	add    $0x8,%edx
  802928:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80292b:	eb dc                	jmp    802909 <spawnl+0x112>
    return spawn(prog, argv);
  80292d:	4c 89 ce             	mov    %r9,%rsi
  802930:	48 b8 0a 21 80 00 00 	movabs $0x80210a,%rax
  802937:	00 00 00 
  80293a:	ff d0                	call   *%rax
}
  80293c:	c9                   	leave
  80293d:	c3                   	ret

000000000080293e <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80293e:	f3 0f 1e fa          	endbr64
  802942:	55                   	push   %rbp
  802943:	48 89 e5             	mov    %rsp,%rbp
  802946:	41 54                	push   %r12
  802948:	53                   	push   %rbx
  802949:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80294c:	48 b8 21 16 80 00 00 	movabs $0x801621,%rax
  802953:	00 00 00 
  802956:	ff d0                	call   *%rax
  802958:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80295b:	48 be df 42 80 00 00 	movabs $0x8042df,%rsi
  802962:	00 00 00 
  802965:	48 89 df             	mov    %rbx,%rdi
  802968:	48 b8 42 0c 80 00 00 	movabs $0x800c42,%rax
  80296f:	00 00 00 
  802972:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802974:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802979:	41 2b 04 24          	sub    (%r12),%eax
  80297d:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802983:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80298a:	00 00 00 
    stat->st_dev = &devpipe;
  80298d:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802994:	00 00 00 
  802997:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80299e:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a3:	5b                   	pop    %rbx
  8029a4:	41 5c                	pop    %r12
  8029a6:	5d                   	pop    %rbp
  8029a7:	c3                   	ret

00000000008029a8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8029a8:	f3 0f 1e fa          	endbr64
  8029ac:	55                   	push   %rbp
  8029ad:	48 89 e5             	mov    %rsp,%rbp
  8029b0:	41 54                	push   %r12
  8029b2:	53                   	push   %rbx
  8029b3:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8029b6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8029bb:	48 89 fe             	mov    %rdi,%rsi
  8029be:	bf 00 00 00 00       	mov    $0x0,%edi
  8029c3:	49 bc 87 13 80 00 00 	movabs $0x801387,%r12
  8029ca:	00 00 00 
  8029cd:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8029d0:	48 89 df             	mov    %rbx,%rdi
  8029d3:	48 b8 21 16 80 00 00 	movabs $0x801621,%rax
  8029da:	00 00 00 
  8029dd:	ff d0                	call   *%rax
  8029df:	48 89 c6             	mov    %rax,%rsi
  8029e2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8029e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ec:	41 ff d4             	call   *%r12
}
  8029ef:	5b                   	pop    %rbx
  8029f0:	41 5c                	pop    %r12
  8029f2:	5d                   	pop    %rbp
  8029f3:	c3                   	ret

00000000008029f4 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8029f4:	f3 0f 1e fa          	endbr64
  8029f8:	55                   	push   %rbp
  8029f9:	48 89 e5             	mov    %rsp,%rbp
  8029fc:	41 57                	push   %r15
  8029fe:	41 56                	push   %r14
  802a00:	41 55                	push   %r13
  802a02:	41 54                	push   %r12
  802a04:	53                   	push   %rbx
  802a05:	48 83 ec 18          	sub    $0x18,%rsp
  802a09:	49 89 fc             	mov    %rdi,%r12
  802a0c:	49 89 f5             	mov    %rsi,%r13
  802a0f:	49 89 d7             	mov    %rdx,%r15
  802a12:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802a16:	48 b8 21 16 80 00 00 	movabs $0x801621,%rax
  802a1d:	00 00 00 
  802a20:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802a22:	4d 85 ff             	test   %r15,%r15
  802a25:	0f 84 af 00 00 00    	je     802ada <devpipe_write+0xe6>
  802a2b:	48 89 c3             	mov    %rax,%rbx
  802a2e:	4c 89 f8             	mov    %r15,%rax
  802a31:	4d 89 ef             	mov    %r13,%r15
  802a34:	4c 01 e8             	add    %r13,%rax
  802a37:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802a3b:	49 bd 17 12 80 00 00 	movabs $0x801217,%r13
  802a42:	00 00 00 
            sys_yield();
  802a45:	49 be ac 11 80 00 00 	movabs $0x8011ac,%r14
  802a4c:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802a4f:	8b 73 04             	mov    0x4(%rbx),%esi
  802a52:	48 63 ce             	movslq %esi,%rcx
  802a55:	48 63 03             	movslq (%rbx),%rax
  802a58:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802a5e:	48 39 c1             	cmp    %rax,%rcx
  802a61:	72 2e                	jb     802a91 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802a63:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802a68:	48 89 da             	mov    %rbx,%rdx
  802a6b:	be 00 10 00 00       	mov    $0x1000,%esi
  802a70:	4c 89 e7             	mov    %r12,%rdi
  802a73:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802a76:	85 c0                	test   %eax,%eax
  802a78:	74 66                	je     802ae0 <devpipe_write+0xec>
            sys_yield();
  802a7a:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802a7d:	8b 73 04             	mov    0x4(%rbx),%esi
  802a80:	48 63 ce             	movslq %esi,%rcx
  802a83:	48 63 03             	movslq (%rbx),%rax
  802a86:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802a8c:	48 39 c1             	cmp    %rax,%rcx
  802a8f:	73 d2                	jae    802a63 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a91:	41 0f b6 3f          	movzbl (%r15),%edi
  802a95:	48 89 ca             	mov    %rcx,%rdx
  802a98:	48 c1 ea 03          	shr    $0x3,%rdx
  802a9c:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802aa3:	08 10 20 
  802aa6:	48 f7 e2             	mul    %rdx
  802aa9:	48 c1 ea 06          	shr    $0x6,%rdx
  802aad:	48 89 d0             	mov    %rdx,%rax
  802ab0:	48 c1 e0 09          	shl    $0x9,%rax
  802ab4:	48 29 d0             	sub    %rdx,%rax
  802ab7:	48 c1 e0 03          	shl    $0x3,%rax
  802abb:	48 29 c1             	sub    %rax,%rcx
  802abe:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802ac3:	83 c6 01             	add    $0x1,%esi
  802ac6:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802ac9:	49 83 c7 01          	add    $0x1,%r15
  802acd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ad1:	49 39 c7             	cmp    %rax,%r15
  802ad4:	0f 85 75 ff ff ff    	jne    802a4f <devpipe_write+0x5b>
    return n;
  802ada:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802ade:	eb 05                	jmp    802ae5 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802ae0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ae5:	48 83 c4 18          	add    $0x18,%rsp
  802ae9:	5b                   	pop    %rbx
  802aea:	41 5c                	pop    %r12
  802aec:	41 5d                	pop    %r13
  802aee:	41 5e                	pop    %r14
  802af0:	41 5f                	pop    %r15
  802af2:	5d                   	pop    %rbp
  802af3:	c3                   	ret

0000000000802af4 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802af4:	f3 0f 1e fa          	endbr64
  802af8:	55                   	push   %rbp
  802af9:	48 89 e5             	mov    %rsp,%rbp
  802afc:	41 57                	push   %r15
  802afe:	41 56                	push   %r14
  802b00:	41 55                	push   %r13
  802b02:	41 54                	push   %r12
  802b04:	53                   	push   %rbx
  802b05:	48 83 ec 18          	sub    $0x18,%rsp
  802b09:	49 89 fc             	mov    %rdi,%r12
  802b0c:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802b10:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802b14:	48 b8 21 16 80 00 00 	movabs $0x801621,%rax
  802b1b:	00 00 00 
  802b1e:	ff d0                	call   *%rax
  802b20:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802b23:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802b29:	49 bd 17 12 80 00 00 	movabs $0x801217,%r13
  802b30:	00 00 00 
            sys_yield();
  802b33:	49 be ac 11 80 00 00 	movabs $0x8011ac,%r14
  802b3a:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802b3d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802b42:	74 7d                	je     802bc1 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802b44:	8b 03                	mov    (%rbx),%eax
  802b46:	3b 43 04             	cmp    0x4(%rbx),%eax
  802b49:	75 26                	jne    802b71 <devpipe_read+0x7d>
            if (i > 0) return i;
  802b4b:	4d 85 ff             	test   %r15,%r15
  802b4e:	75 77                	jne    802bc7 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802b50:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802b55:	48 89 da             	mov    %rbx,%rdx
  802b58:	be 00 10 00 00       	mov    $0x1000,%esi
  802b5d:	4c 89 e7             	mov    %r12,%rdi
  802b60:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802b63:	85 c0                	test   %eax,%eax
  802b65:	74 72                	je     802bd9 <devpipe_read+0xe5>
            sys_yield();
  802b67:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802b6a:	8b 03                	mov    (%rbx),%eax
  802b6c:	3b 43 04             	cmp    0x4(%rbx),%eax
  802b6f:	74 df                	je     802b50 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802b71:	48 63 c8             	movslq %eax,%rcx
  802b74:	48 89 ca             	mov    %rcx,%rdx
  802b77:	48 c1 ea 03          	shr    $0x3,%rdx
  802b7b:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802b82:	08 10 20 
  802b85:	48 89 d0             	mov    %rdx,%rax
  802b88:	48 f7 e6             	mul    %rsi
  802b8b:	48 c1 ea 06          	shr    $0x6,%rdx
  802b8f:	48 89 d0             	mov    %rdx,%rax
  802b92:	48 c1 e0 09          	shl    $0x9,%rax
  802b96:	48 29 d0             	sub    %rdx,%rax
  802b99:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802ba0:	00 
  802ba1:	48 89 c8             	mov    %rcx,%rax
  802ba4:	48 29 d0             	sub    %rdx,%rax
  802ba7:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802bac:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802bb0:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802bb4:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802bb7:	49 83 c7 01          	add    $0x1,%r15
  802bbb:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802bbf:	75 83                	jne    802b44 <devpipe_read+0x50>
    return n;
  802bc1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802bc5:	eb 03                	jmp    802bca <devpipe_read+0xd6>
            if (i > 0) return i;
  802bc7:	4c 89 f8             	mov    %r15,%rax
}
  802bca:	48 83 c4 18          	add    $0x18,%rsp
  802bce:	5b                   	pop    %rbx
  802bcf:	41 5c                	pop    %r12
  802bd1:	41 5d                	pop    %r13
  802bd3:	41 5e                	pop    %r14
  802bd5:	41 5f                	pop    %r15
  802bd7:	5d                   	pop    %rbp
  802bd8:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bde:	eb ea                	jmp    802bca <devpipe_read+0xd6>

0000000000802be0 <pipe>:
pipe(int pfd[2]) {
  802be0:	f3 0f 1e fa          	endbr64
  802be4:	55                   	push   %rbp
  802be5:	48 89 e5             	mov    %rsp,%rbp
  802be8:	41 55                	push   %r13
  802bea:	41 54                	push   %r12
  802bec:	53                   	push   %rbx
  802bed:	48 83 ec 18          	sub    $0x18,%rsp
  802bf1:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802bf4:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802bf8:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  802bff:	00 00 00 
  802c02:	ff d0                	call   *%rax
  802c04:	89 c3                	mov    %eax,%ebx
  802c06:	85 c0                	test   %eax,%eax
  802c08:	0f 88 a0 01 00 00    	js     802dae <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802c0e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802c13:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c18:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802c1c:	bf 00 00 00 00       	mov    $0x0,%edi
  802c21:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  802c28:	00 00 00 
  802c2b:	ff d0                	call   *%rax
  802c2d:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802c2f:	85 c0                	test   %eax,%eax
  802c31:	0f 88 77 01 00 00    	js     802dae <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802c37:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802c3b:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  802c42:	00 00 00 
  802c45:	ff d0                	call   *%rax
  802c47:	89 c3                	mov    %eax,%ebx
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	0f 88 43 01 00 00    	js     802d94 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802c51:	b9 46 00 00 00       	mov    $0x46,%ecx
  802c56:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c5b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c5f:	bf 00 00 00 00       	mov    $0x0,%edi
  802c64:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  802c6b:	00 00 00 
  802c6e:	ff d0                	call   *%rax
  802c70:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802c72:	85 c0                	test   %eax,%eax
  802c74:	0f 88 1a 01 00 00    	js     802d94 <pipe+0x1b4>
    va = fd2data(fd0);
  802c7a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802c7e:	48 b8 21 16 80 00 00 	movabs $0x801621,%rax
  802c85:	00 00 00 
  802c88:	ff d0                	call   *%rax
  802c8a:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802c8d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802c92:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c97:	48 89 c6             	mov    %rax,%rsi
  802c9a:	bf 00 00 00 00       	mov    $0x0,%edi
  802c9f:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  802ca6:	00 00 00 
  802ca9:	ff d0                	call   *%rax
  802cab:	89 c3                	mov    %eax,%ebx
  802cad:	85 c0                	test   %eax,%eax
  802caf:	0f 88 c5 00 00 00    	js     802d7a <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802cb5:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802cb9:	48 b8 21 16 80 00 00 	movabs $0x801621,%rax
  802cc0:	00 00 00 
  802cc3:	ff d0                	call   *%rax
  802cc5:	48 89 c1             	mov    %rax,%rcx
  802cc8:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802cce:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802cd4:	ba 00 00 00 00       	mov    $0x0,%edx
  802cd9:	4c 89 ee             	mov    %r13,%rsi
  802cdc:	bf 00 00 00 00       	mov    $0x0,%edi
  802ce1:	48 b8 b2 12 80 00 00 	movabs $0x8012b2,%rax
  802ce8:	00 00 00 
  802ceb:	ff d0                	call   *%rax
  802ced:	89 c3                	mov    %eax,%ebx
  802cef:	85 c0                	test   %eax,%eax
  802cf1:	78 6e                	js     802d61 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802cf3:	be 00 10 00 00       	mov    $0x1000,%esi
  802cf8:	4c 89 ef             	mov    %r13,%rdi
  802cfb:	48 b8 e1 11 80 00 00 	movabs $0x8011e1,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	call   *%rax
  802d07:	83 f8 02             	cmp    $0x2,%eax
  802d0a:	0f 85 ab 00 00 00    	jne    802dbb <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802d10:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  802d17:	00 00 
  802d19:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d1d:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802d1f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d23:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802d2a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802d2e:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802d30:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d34:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802d3b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802d3f:	48 bb 0b 16 80 00 00 	movabs $0x80160b,%rbx
  802d46:	00 00 00 
  802d49:	ff d3                	call   *%rbx
  802d4b:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802d4f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802d53:	ff d3                	call   *%rbx
  802d55:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802d5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d5f:	eb 4d                	jmp    802dae <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802d61:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d66:	4c 89 ee             	mov    %r13,%rsi
  802d69:	bf 00 00 00 00       	mov    $0x0,%edi
  802d6e:	48 b8 87 13 80 00 00 	movabs $0x801387,%rax
  802d75:	00 00 00 
  802d78:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802d7a:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d7f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d83:	bf 00 00 00 00       	mov    $0x0,%edi
  802d88:	48 b8 87 13 80 00 00 	movabs $0x801387,%rax
  802d8f:	00 00 00 
  802d92:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802d94:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d99:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802d9d:	bf 00 00 00 00       	mov    $0x0,%edi
  802da2:	48 b8 87 13 80 00 00 	movabs $0x801387,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	call   *%rax
}
  802dae:	89 d8                	mov    %ebx,%eax
  802db0:	48 83 c4 18          	add    $0x18,%rsp
  802db4:	5b                   	pop    %rbx
  802db5:	41 5c                	pop    %r12
  802db7:	41 5d                	pop    %r13
  802db9:	5d                   	pop    %rbp
  802dba:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802dbb:	48 b9 30 44 80 00 00 	movabs $0x804430,%rcx
  802dc2:	00 00 00 
  802dc5:	48 ba 51 42 80 00 00 	movabs $0x804251,%rdx
  802dcc:	00 00 00 
  802dcf:	be 2e 00 00 00       	mov    $0x2e,%esi
  802dd4:	48 bf e6 42 80 00 00 	movabs $0x8042e6,%rdi
  802ddb:	00 00 00 
  802dde:	b8 00 00 00 00       	mov    $0x0,%eax
  802de3:	49 b8 9d 01 80 00 00 	movabs $0x80019d,%r8
  802dea:	00 00 00 
  802ded:	41 ff d0             	call   *%r8

0000000000802df0 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802df0:	f3 0f 1e fa          	endbr64
  802df4:	55                   	push   %rbp
  802df5:	48 89 e5             	mov    %rsp,%rbp
  802df8:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802dfc:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802e00:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  802e07:	00 00 00 
  802e0a:	ff d0                	call   *%rax
    if (res < 0) return res;
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	78 35                	js     802e45 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802e10:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802e14:	48 b8 21 16 80 00 00 	movabs $0x801621,%rax
  802e1b:	00 00 00 
  802e1e:	ff d0                	call   *%rax
  802e20:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802e23:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802e28:	be 00 10 00 00       	mov    $0x1000,%esi
  802e2d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802e31:	48 b8 17 12 80 00 00 	movabs $0x801217,%rax
  802e38:	00 00 00 
  802e3b:	ff d0                	call   *%rax
  802e3d:	85 c0                	test   %eax,%eax
  802e3f:	0f 94 c0             	sete   %al
  802e42:	0f b6 c0             	movzbl %al,%eax
}
  802e45:	c9                   	leave
  802e46:	c3                   	ret

0000000000802e47 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802e47:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802e4b:	48 89 f8             	mov    %rdi,%rax
  802e4e:	48 c1 e8 27          	shr    $0x27,%rax
  802e52:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802e59:	7f 00 00 
  802e5c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802e60:	f6 c2 01             	test   $0x1,%dl
  802e63:	74 6d                	je     802ed2 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802e65:	48 89 f8             	mov    %rdi,%rax
  802e68:	48 c1 e8 1e          	shr    $0x1e,%rax
  802e6c:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802e73:	7f 00 00 
  802e76:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802e7a:	f6 c2 01             	test   $0x1,%dl
  802e7d:	74 62                	je     802ee1 <get_uvpt_entry+0x9a>
  802e7f:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802e86:	7f 00 00 
  802e89:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802e8d:	f6 c2 80             	test   $0x80,%dl
  802e90:	75 4f                	jne    802ee1 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802e92:	48 89 f8             	mov    %rdi,%rax
  802e95:	48 c1 e8 15          	shr    $0x15,%rax
  802e99:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802ea0:	7f 00 00 
  802ea3:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802ea7:	f6 c2 01             	test   $0x1,%dl
  802eaa:	74 44                	je     802ef0 <get_uvpt_entry+0xa9>
  802eac:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802eb3:	7f 00 00 
  802eb6:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802eba:	f6 c2 80             	test   $0x80,%dl
  802ebd:	75 31                	jne    802ef0 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802ebf:	48 c1 ef 0c          	shr    $0xc,%rdi
  802ec3:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802eca:	7f 00 00 
  802ecd:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802ed1:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802ed2:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802ed9:	7f 00 00 
  802edc:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802ee0:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802ee1:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802ee8:	7f 00 00 
  802eeb:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802eef:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802ef0:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802ef7:	7f 00 00 
  802efa:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802efe:	c3                   	ret

0000000000802eff <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802eff:	f3 0f 1e fa          	endbr64
  802f03:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802f06:	48 89 f9             	mov    %rdi,%rcx
  802f09:	48 c1 e9 27          	shr    $0x27,%rcx
  802f0d:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802f14:	7f 00 00 
  802f17:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802f1b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802f22:	f6 c1 01             	test   $0x1,%cl
  802f25:	0f 84 b2 00 00 00    	je     802fdd <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802f2b:	48 89 f9             	mov    %rdi,%rcx
  802f2e:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802f32:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802f39:	7f 00 00 
  802f3c:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802f40:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802f47:	40 f6 c6 01          	test   $0x1,%sil
  802f4b:	0f 84 8c 00 00 00    	je     802fdd <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802f51:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802f58:	7f 00 00 
  802f5b:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802f5f:	a8 80                	test   $0x80,%al
  802f61:	75 7b                	jne    802fde <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802f63:	48 89 f9             	mov    %rdi,%rcx
  802f66:	48 c1 e9 15          	shr    $0x15,%rcx
  802f6a:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802f71:	7f 00 00 
  802f74:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802f78:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802f7f:	40 f6 c6 01          	test   $0x1,%sil
  802f83:	74 58                	je     802fdd <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802f85:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802f8c:	7f 00 00 
  802f8f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802f93:	a8 80                	test   $0x80,%al
  802f95:	75 6c                	jne    803003 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802f97:	48 89 f9             	mov    %rdi,%rcx
  802f9a:	48 c1 e9 0c          	shr    $0xc,%rcx
  802f9e:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802fa5:	7f 00 00 
  802fa8:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802fac:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802fb3:	40 f6 c6 01          	test   $0x1,%sil
  802fb7:	74 24                	je     802fdd <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802fb9:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802fc0:	7f 00 00 
  802fc3:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802fc7:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802fce:	ff ff 7f 
  802fd1:	48 21 c8             	and    %rcx,%rax
  802fd4:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802fda:	48 09 d0             	or     %rdx,%rax
}
  802fdd:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802fde:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802fe5:	7f 00 00 
  802fe8:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802fec:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802ff3:	ff ff 7f 
  802ff6:	48 21 c8             	and    %rcx,%rax
  802ff9:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802fff:	48 01 d0             	add    %rdx,%rax
  803002:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  803003:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80300a:	7f 00 00 
  80300d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803011:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  803018:	ff ff 7f 
  80301b:	48 21 c8             	and    %rcx,%rax
  80301e:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  803024:	48 01 d0             	add    %rdx,%rax
  803027:	c3                   	ret

0000000000803028 <get_prot>:

int
get_prot(void *va) {
  803028:	f3 0f 1e fa          	endbr64
  80302c:	55                   	push   %rbp
  80302d:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803030:	48 b8 47 2e 80 00 00 	movabs $0x802e47,%rax
  803037:	00 00 00 
  80303a:	ff d0                	call   *%rax
  80303c:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  80303f:	83 e0 01             	and    $0x1,%eax
  803042:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  803045:	89 d1                	mov    %edx,%ecx
  803047:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  80304d:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80304f:	89 c1                	mov    %eax,%ecx
  803051:	83 c9 02             	or     $0x2,%ecx
  803054:	f6 c2 02             	test   $0x2,%dl
  803057:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80305a:	89 c1                	mov    %eax,%ecx
  80305c:	83 c9 01             	or     $0x1,%ecx
  80305f:	48 85 d2             	test   %rdx,%rdx
  803062:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  803065:	89 c1                	mov    %eax,%ecx
  803067:	83 c9 40             	or     $0x40,%ecx
  80306a:	f6 c6 04             	test   $0x4,%dh
  80306d:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  803070:	5d                   	pop    %rbp
  803071:	c3                   	ret

0000000000803072 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  803072:	f3 0f 1e fa          	endbr64
  803076:	55                   	push   %rbp
  803077:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80307a:	48 b8 47 2e 80 00 00 	movabs $0x802e47,%rax
  803081:	00 00 00 
  803084:	ff d0                	call   *%rax
    return pte & PTE_D;
  803086:	48 c1 e8 06          	shr    $0x6,%rax
  80308a:	83 e0 01             	and    $0x1,%eax
}
  80308d:	5d                   	pop    %rbp
  80308e:	c3                   	ret

000000000080308f <is_page_present>:

bool
is_page_present(void *va) {
  80308f:	f3 0f 1e fa          	endbr64
  803093:	55                   	push   %rbp
  803094:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  803097:	48 b8 47 2e 80 00 00 	movabs $0x802e47,%rax
  80309e:	00 00 00 
  8030a1:	ff d0                	call   *%rax
  8030a3:	83 e0 01             	and    $0x1,%eax
}
  8030a6:	5d                   	pop    %rbp
  8030a7:	c3                   	ret

00000000008030a8 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8030a8:	f3 0f 1e fa          	endbr64
  8030ac:	55                   	push   %rbp
  8030ad:	48 89 e5             	mov    %rsp,%rbp
  8030b0:	41 57                	push   %r15
  8030b2:	41 56                	push   %r14
  8030b4:	41 55                	push   %r13
  8030b6:	41 54                	push   %r12
  8030b8:	53                   	push   %rbx
  8030b9:	48 83 ec 18          	sub    $0x18,%rsp
  8030bd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8030c1:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8030c5:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8030ca:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8030d1:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8030d4:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8030db:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8030de:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8030e5:	00 00 00 
  8030e8:	eb 73                	jmp    80315d <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8030ea:	48 89 d8             	mov    %rbx,%rax
  8030ed:	48 c1 e8 15          	shr    $0x15,%rax
  8030f1:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8030f8:	7f 00 00 
  8030fb:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8030ff:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  803105:	f6 c2 01             	test   $0x1,%dl
  803108:	74 4b                	je     803155 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  80310a:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  80310e:	f6 c2 80             	test   $0x80,%dl
  803111:	74 11                	je     803124 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  803113:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  803117:	f6 c4 04             	test   $0x4,%ah
  80311a:	74 39                	je     803155 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  80311c:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  803122:	eb 20                	jmp    803144 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  803124:	48 89 da             	mov    %rbx,%rdx
  803127:	48 c1 ea 0c          	shr    $0xc,%rdx
  80312b:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  803132:	7f 00 00 
  803135:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  803139:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80313f:	f6 c4 04             	test   $0x4,%ah
  803142:	74 11                	je     803155 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  803144:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  803148:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80314c:	48 89 df             	mov    %rbx,%rdi
  80314f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803153:	ff d0                	call   *%rax
    next:
        va += size;
  803155:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  803158:	49 39 df             	cmp    %rbx,%r15
  80315b:	72 3e                	jb     80319b <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  80315d:	49 8b 06             	mov    (%r14),%rax
  803160:	a8 01                	test   $0x1,%al
  803162:	74 37                	je     80319b <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803164:	48 89 d8             	mov    %rbx,%rax
  803167:	48 c1 e8 1e          	shr    $0x1e,%rax
  80316b:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  803170:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803176:	f6 c2 01             	test   $0x1,%dl
  803179:	74 da                	je     803155 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  80317b:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  803180:	f6 c2 80             	test   $0x80,%dl
  803183:	0f 84 61 ff ff ff    	je     8030ea <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  803189:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80318e:	f6 c4 04             	test   $0x4,%ah
  803191:	74 c2                	je     803155 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  803193:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  803199:	eb a9                	jmp    803144 <foreach_shared_region+0x9c>
    }
    return res;
}
  80319b:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a0:	48 83 c4 18          	add    $0x18,%rsp
  8031a4:	5b                   	pop    %rbx
  8031a5:	41 5c                	pop    %r12
  8031a7:	41 5d                	pop    %r13
  8031a9:	41 5e                	pop    %r14
  8031ab:	41 5f                	pop    %r15
  8031ad:	5d                   	pop    %rbp
  8031ae:	c3                   	ret

00000000008031af <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  8031af:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  8031b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b8:	c3                   	ret

00000000008031b9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8031b9:	f3 0f 1e fa          	endbr64
  8031bd:	55                   	push   %rbp
  8031be:	48 89 e5             	mov    %rsp,%rbp
  8031c1:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8031c4:	48 be f6 42 80 00 00 	movabs $0x8042f6,%rsi
  8031cb:	00 00 00 
  8031ce:	48 b8 42 0c 80 00 00 	movabs $0x800c42,%rax
  8031d5:	00 00 00 
  8031d8:	ff d0                	call   *%rax
    return 0;
}
  8031da:	b8 00 00 00 00       	mov    $0x0,%eax
  8031df:	5d                   	pop    %rbp
  8031e0:	c3                   	ret

00000000008031e1 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8031e1:	f3 0f 1e fa          	endbr64
  8031e5:	55                   	push   %rbp
  8031e6:	48 89 e5             	mov    %rsp,%rbp
  8031e9:	41 57                	push   %r15
  8031eb:	41 56                	push   %r14
  8031ed:	41 55                	push   %r13
  8031ef:	41 54                	push   %r12
  8031f1:	53                   	push   %rbx
  8031f2:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8031f9:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  803200:	48 85 d2             	test   %rdx,%rdx
  803203:	74 7a                	je     80327f <devcons_write+0x9e>
  803205:	49 89 d6             	mov    %rdx,%r14
  803208:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80320e:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  803213:	49 bf 5d 0e 80 00 00 	movabs $0x800e5d,%r15
  80321a:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  80321d:	4c 89 f3             	mov    %r14,%rbx
  803220:	48 29 f3             	sub    %rsi,%rbx
  803223:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803228:	48 39 c3             	cmp    %rax,%rbx
  80322b:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  80322f:	4c 63 eb             	movslq %ebx,%r13
  803232:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  803239:	48 01 c6             	add    %rax,%rsi
  80323c:	4c 89 ea             	mov    %r13,%rdx
  80323f:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  803246:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  803249:	4c 89 ee             	mov    %r13,%rsi
  80324c:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  803253:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  80325a:	00 00 00 
  80325d:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  80325f:	41 01 dc             	add    %ebx,%r12d
  803262:	49 63 f4             	movslq %r12d,%rsi
  803265:	4c 39 f6             	cmp    %r14,%rsi
  803268:	72 b3                	jb     80321d <devcons_write+0x3c>
    return res;
  80326a:	49 63 c4             	movslq %r12d,%rax
}
  80326d:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  803274:	5b                   	pop    %rbx
  803275:	41 5c                	pop    %r12
  803277:	41 5d                	pop    %r13
  803279:	41 5e                	pop    %r14
  80327b:	41 5f                	pop    %r15
  80327d:	5d                   	pop    %rbp
  80327e:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  80327f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  803285:	eb e3                	jmp    80326a <devcons_write+0x89>

0000000000803287 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  803287:	f3 0f 1e fa          	endbr64
  80328b:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80328e:	ba 00 00 00 00       	mov    $0x0,%edx
  803293:	48 85 c0             	test   %rax,%rax
  803296:	74 55                	je     8032ed <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  803298:	55                   	push   %rbp
  803299:	48 89 e5             	mov    %rsp,%rbp
  80329c:	41 55                	push   %r13
  80329e:	41 54                	push   %r12
  8032a0:	53                   	push   %rbx
  8032a1:	48 83 ec 08          	sub    $0x8,%rsp
  8032a5:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  8032a8:	48 bb d3 10 80 00 00 	movabs $0x8010d3,%rbx
  8032af:	00 00 00 
  8032b2:	49 bc ac 11 80 00 00 	movabs $0x8011ac,%r12
  8032b9:	00 00 00 
  8032bc:	eb 03                	jmp    8032c1 <devcons_read+0x3a>
  8032be:	41 ff d4             	call   *%r12
  8032c1:	ff d3                	call   *%rbx
  8032c3:	85 c0                	test   %eax,%eax
  8032c5:	74 f7                	je     8032be <devcons_read+0x37>
    if (c < 0) return c;
  8032c7:	48 63 d0             	movslq %eax,%rdx
  8032ca:	78 13                	js     8032df <devcons_read+0x58>
    if (c == 0x04) return 0;
  8032cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8032d1:	83 f8 04             	cmp    $0x4,%eax
  8032d4:	74 09                	je     8032df <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  8032d6:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8032da:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8032df:	48 89 d0             	mov    %rdx,%rax
  8032e2:	48 83 c4 08          	add    $0x8,%rsp
  8032e6:	5b                   	pop    %rbx
  8032e7:	41 5c                	pop    %r12
  8032e9:	41 5d                	pop    %r13
  8032eb:	5d                   	pop    %rbp
  8032ec:	c3                   	ret
  8032ed:	48 89 d0             	mov    %rdx,%rax
  8032f0:	c3                   	ret

00000000008032f1 <cputchar>:
cputchar(int ch) {
  8032f1:	f3 0f 1e fa          	endbr64
  8032f5:	55                   	push   %rbp
  8032f6:	48 89 e5             	mov    %rsp,%rbp
  8032f9:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8032fd:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  803301:	be 01 00 00 00       	mov    $0x1,%esi
  803306:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80330a:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  803311:	00 00 00 
  803314:	ff d0                	call   *%rax
}
  803316:	c9                   	leave
  803317:	c3                   	ret

0000000000803318 <getchar>:
getchar(void) {
  803318:	f3 0f 1e fa          	endbr64
  80331c:	55                   	push   %rbp
  80331d:	48 89 e5             	mov    %rsp,%rbp
  803320:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  803324:	ba 01 00 00 00       	mov    $0x1,%edx
  803329:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  80332d:	bf 00 00 00 00       	mov    $0x0,%edi
  803332:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  803339:	00 00 00 
  80333c:	ff d0                	call   *%rax
  80333e:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  803340:	85 c0                	test   %eax,%eax
  803342:	78 06                	js     80334a <getchar+0x32>
  803344:	74 08                	je     80334e <getchar+0x36>
  803346:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  80334a:	89 d0                	mov    %edx,%eax
  80334c:	c9                   	leave
  80334d:	c3                   	ret
    return res < 0 ? res : res ? c :
  80334e:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  803353:	eb f5                	jmp    80334a <getchar+0x32>

0000000000803355 <iscons>:
iscons(int fdnum) {
  803355:	f3 0f 1e fa          	endbr64
  803359:	55                   	push   %rbp
  80335a:	48 89 e5             	mov    %rsp,%rbp
  80335d:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  803361:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  803365:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  80336c:	00 00 00 
  80336f:	ff d0                	call   *%rax
    if (res < 0) return res;
  803371:	85 c0                	test   %eax,%eax
  803373:	78 18                	js     80338d <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  803375:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803379:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  803380:	00 00 00 
  803383:	8b 00                	mov    (%rax),%eax
  803385:	39 02                	cmp    %eax,(%rdx)
  803387:	0f 94 c0             	sete   %al
  80338a:	0f b6 c0             	movzbl %al,%eax
}
  80338d:	c9                   	leave
  80338e:	c3                   	ret

000000000080338f <opencons>:
opencons(void) {
  80338f:	f3 0f 1e fa          	endbr64
  803393:	55                   	push   %rbp
  803394:	48 89 e5             	mov    %rsp,%rbp
  803397:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  80339b:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80339f:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  8033a6:	00 00 00 
  8033a9:	ff d0                	call   *%rax
  8033ab:	85 c0                	test   %eax,%eax
  8033ad:	78 49                	js     8033f8 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8033af:	b9 46 00 00 00       	mov    $0x46,%ecx
  8033b4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8033b9:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  8033bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8033c2:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  8033c9:	00 00 00 
  8033cc:	ff d0                	call   *%rax
  8033ce:	85 c0                	test   %eax,%eax
  8033d0:	78 26                	js     8033f8 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  8033d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033d6:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  8033dd:	00 00 
  8033df:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  8033e1:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8033e5:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  8033ec:	48 b8 0b 16 80 00 00 	movabs $0x80160b,%rax
  8033f3:	00 00 00 
  8033f6:	ff d0                	call   *%rax
}
  8033f8:	c9                   	leave
  8033f9:	c3                   	ret

00000000008033fa <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  8033fa:	f3 0f 1e fa          	endbr64
  8033fe:	55                   	push   %rbp
  8033ff:	48 89 e5             	mov    %rsp,%rbp
  803402:	41 54                	push   %r12
  803404:	53                   	push   %rbx
  803405:	48 89 fb             	mov    %rdi,%rbx
  803408:	48 89 f7             	mov    %rsi,%rdi
  80340b:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  80340e:	48 85 f6             	test   %rsi,%rsi
  803411:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803418:	00 00 00 
  80341b:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  80341f:	be 00 10 00 00       	mov    $0x1000,%esi
  803424:	48 b8 69 15 80 00 00 	movabs $0x801569,%rax
  80342b:	00 00 00 
  80342e:	ff d0                	call   *%rax
    if (res < 0) {
  803430:	85 c0                	test   %eax,%eax
  803432:	78 45                	js     803479 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  803434:	48 85 db             	test   %rbx,%rbx
  803437:	74 12                	je     80344b <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  803439:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803440:	00 00 00 
  803443:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  803449:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  80344b:	4d 85 e4             	test   %r12,%r12
  80344e:	74 14                	je     803464 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  803450:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803457:	00 00 00 
  80345a:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  803460:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  803464:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80346b:	00 00 00 
  80346e:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  803474:	5b                   	pop    %rbx
  803475:	41 5c                	pop    %r12
  803477:	5d                   	pop    %rbp
  803478:	c3                   	ret
        if (from_env_store != NULL) {
  803479:	48 85 db             	test   %rbx,%rbx
  80347c:	74 06                	je     803484 <ipc_recv+0x8a>
            *from_env_store = 0;
  80347e:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  803484:	4d 85 e4             	test   %r12,%r12
  803487:	74 eb                	je     803474 <ipc_recv+0x7a>
            *perm_store = 0;
  803489:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  803490:	00 
  803491:	eb e1                	jmp    803474 <ipc_recv+0x7a>

0000000000803493 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  803493:	f3 0f 1e fa          	endbr64
  803497:	55                   	push   %rbp
  803498:	48 89 e5             	mov    %rsp,%rbp
  80349b:	41 57                	push   %r15
  80349d:	41 56                	push   %r14
  80349f:	41 55                	push   %r13
  8034a1:	41 54                	push   %r12
  8034a3:	53                   	push   %rbx
  8034a4:	48 83 ec 18          	sub    $0x18,%rsp
  8034a8:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  8034ab:	48 89 d3             	mov    %rdx,%rbx
  8034ae:	49 89 cc             	mov    %rcx,%r12
  8034b1:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8034b4:	48 85 d2             	test   %rdx,%rdx
  8034b7:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8034be:	00 00 00 
  8034c1:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8034c5:	89 f0                	mov    %esi,%eax
  8034c7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8034cb:	48 89 da             	mov    %rbx,%rdx
  8034ce:	48 89 c6             	mov    %rax,%rsi
  8034d1:	48 b8 39 15 80 00 00 	movabs $0x801539,%rax
  8034d8:	00 00 00 
  8034db:	ff d0                	call   *%rax
    while (res < 0) {
  8034dd:	85 c0                	test   %eax,%eax
  8034df:	79 65                	jns    803546 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  8034e1:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8034e4:	75 33                	jne    803519 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  8034e6:	49 bf ac 11 80 00 00 	movabs $0x8011ac,%r15
  8034ed:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8034f0:	49 be 39 15 80 00 00 	movabs $0x801539,%r14
  8034f7:	00 00 00 
        sys_yield();
  8034fa:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8034fd:	45 89 e8             	mov    %r13d,%r8d
  803500:	4c 89 e1             	mov    %r12,%rcx
  803503:	48 89 da             	mov    %rbx,%rdx
  803506:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80350a:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  80350d:	41 ff d6             	call   *%r14
    while (res < 0) {
  803510:	85 c0                	test   %eax,%eax
  803512:	79 32                	jns    803546 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803514:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803517:	74 e1                	je     8034fa <ipc_send+0x67>
            panic("Error: %i\n", res);
  803519:	89 c1                	mov    %eax,%ecx
  80351b:	48 ba 02 43 80 00 00 	movabs $0x804302,%rdx
  803522:	00 00 00 
  803525:	be 42 00 00 00       	mov    $0x42,%esi
  80352a:	48 bf 0d 43 80 00 00 	movabs $0x80430d,%rdi
  803531:	00 00 00 
  803534:	b8 00 00 00 00       	mov    $0x0,%eax
  803539:	49 b8 9d 01 80 00 00 	movabs $0x80019d,%r8
  803540:	00 00 00 
  803543:	41 ff d0             	call   *%r8
    }
}
  803546:	48 83 c4 18          	add    $0x18,%rsp
  80354a:	5b                   	pop    %rbx
  80354b:	41 5c                	pop    %r12
  80354d:	41 5d                	pop    %r13
  80354f:	41 5e                	pop    %r14
  803551:	41 5f                	pop    %r15
  803553:	5d                   	pop    %rbp
  803554:	c3                   	ret

0000000000803555 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  803555:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  803559:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80355e:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  803565:	00 00 00 
  803568:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80356c:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803570:	48 c1 e2 04          	shl    $0x4,%rdx
  803574:	48 01 ca             	add    %rcx,%rdx
  803577:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  80357d:	39 fa                	cmp    %edi,%edx
  80357f:	74 12                	je     803593 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  803581:	48 83 c0 01          	add    $0x1,%rax
  803585:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  80358b:	75 db                	jne    803568 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  80358d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803592:	c3                   	ret
            return envs[i].env_id;
  803593:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803597:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80359b:	48 c1 e2 04          	shl    $0x4,%rdx
  80359f:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8035a6:	00 00 00 
  8035a9:	48 01 d0             	add    %rdx,%rax
  8035ac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8035b2:	c3                   	ret

00000000008035b3 <__text_end>:
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
