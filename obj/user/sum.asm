
obj/user/sum:     file format elf64-x86-64


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
  80001e:	e8 6e 00 00 00       	call   800091 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 83 ec 18          	sub    $0x18,%rsp
  800036:	49 89 f4             	mov    %rsi,%r12
    char *end;
    cprintf("%ld\n", strtol(argv[1], &end, 10) + strtol(argv[2], &end, 10));
  800039:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  80003d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800042:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800046:	49 bd 0e 0f 80 00 00 	movabs $0x800f0e,%r13
  80004d:	00 00 00 
  800050:	41 ff d5             	call   *%r13
  800053:	48 89 c3             	mov    %rax,%rbx
  800056:	49 8b 7c 24 10       	mov    0x10(%r12),%rdi
  80005b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800060:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800064:	41 ff d5             	call   *%r13
  800067:	48 8d 34 03          	lea    (%rbx,%rax,1),%rsi
  80006b:	48 bf 00 30 80 00 00 	movabs $0x803000,%rdi
  800072:	00 00 00 
  800075:	b8 00 00 00 00       	mov    $0x0,%eax
  80007a:	48 ba 1f 02 80 00 00 	movabs $0x80021f,%rdx
  800081:	00 00 00 
  800084:	ff d2                	call   *%rdx
  800086:	48 83 c4 18          	add    $0x18,%rsp
  80008a:	5b                   	pop    %rbx
  80008b:	41 5c                	pop    %r12
  80008d:	41 5d                	pop    %r13
  80008f:	5d                   	pop    %rbp
  800090:	c3                   	ret

0000000000800091 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800091:	f3 0f 1e fa          	endbr64
  800095:	55                   	push   %rbp
  800096:	48 89 e5             	mov    %rsp,%rbp
  800099:	41 56                	push   %r14
  80009b:	41 55                	push   %r13
  80009d:	41 54                	push   %r12
  80009f:	53                   	push   %rbx
  8000a0:	41 89 fd             	mov    %edi,%r13d
  8000a3:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8000a6:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8000ad:	00 00 00 
  8000b0:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  8000b7:	00 00 00 
  8000ba:	48 39 c2             	cmp    %rax,%rdx
  8000bd:	73 17                	jae    8000d6 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8000bf:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8000c2:	49 89 c4             	mov    %rax,%r12
  8000c5:	48 83 c3 08          	add    $0x8,%rbx
  8000c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ce:	ff 53 f8             	call   *-0x8(%rbx)
  8000d1:	4c 39 e3             	cmp    %r12,%rbx
  8000d4:	72 ef                	jb     8000c5 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8000d6:	48 b8 9d 10 80 00 00 	movabs $0x80109d,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	call   *%rax
  8000e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000e7:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000eb:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000ef:	48 c1 e0 04          	shl    $0x4,%rax
  8000f3:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000fa:	00 00 00 
  8000fd:	48 01 d0             	add    %rdx,%rax
  800100:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800107:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80010a:	45 85 ed             	test   %r13d,%r13d
  80010d:	7e 0d                	jle    80011c <libmain+0x8b>
  80010f:	49 8b 06             	mov    (%r14),%rax
  800112:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800119:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80011c:	4c 89 f6             	mov    %r14,%rsi
  80011f:	44 89 ef             	mov    %r13d,%edi
  800122:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800129:	00 00 00 
  80012c:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80012e:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800135:	00 00 00 
  800138:	ff d0                	call   *%rax
#endif
}
  80013a:	5b                   	pop    %rbx
  80013b:	41 5c                	pop    %r12
  80013d:	41 5d                	pop    %r13
  80013f:	41 5e                	pop    %r14
  800141:	5d                   	pop    %rbp
  800142:	c3                   	ret

0000000000800143 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800143:	f3 0f 1e fa          	endbr64
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80014b:	48 b8 73 17 80 00 00 	movabs $0x801773,%rax
  800152:	00 00 00 
  800155:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800157:	bf 00 00 00 00       	mov    $0x0,%edi
  80015c:	48 b8 2e 10 80 00 00 	movabs $0x80102e,%rax
  800163:	00 00 00 
  800166:	ff d0                	call   *%rax
}
  800168:	5d                   	pop    %rbp
  800169:	c3                   	ret

000000000080016a <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80016a:	f3 0f 1e fa          	endbr64
  80016e:	55                   	push   %rbp
  80016f:	48 89 e5             	mov    %rsp,%rbp
  800172:	53                   	push   %rbx
  800173:	48 83 ec 08          	sub    $0x8,%rsp
  800177:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80017a:	8b 06                	mov    (%rsi),%eax
  80017c:	8d 50 01             	lea    0x1(%rax),%edx
  80017f:	89 16                	mov    %edx,(%rsi)
  800181:	48 98                	cltq
  800183:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800188:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80018e:	74 0a                	je     80019a <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800190:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800194:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800198:	c9                   	leave
  800199:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80019a:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80019e:	be ff 00 00 00       	mov    $0xff,%esi
  8001a3:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  8001aa:	00 00 00 
  8001ad:	ff d0                	call   *%rax
        state->offset = 0;
  8001af:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8001b5:	eb d9                	jmp    800190 <putch+0x26>

00000000008001b7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8001b7:	f3 0f 1e fa          	endbr64
  8001bb:	55                   	push   %rbp
  8001bc:	48 89 e5             	mov    %rsp,%rbp
  8001bf:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8001c6:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8001c9:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8001d0:	b9 21 00 00 00       	mov    $0x21,%ecx
  8001d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001da:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8001dd:	48 89 f1             	mov    %rsi,%rcx
  8001e0:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8001e7:	48 bf 6a 01 80 00 00 	movabs $0x80016a,%rdi
  8001ee:	00 00 00 
  8001f1:	48 b8 7f 03 80 00 00 	movabs $0x80037f,%rax
  8001f8:	00 00 00 
  8001fb:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8001fd:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800204:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  80020b:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  800212:	00 00 00 
  800215:	ff d0                	call   *%rax

    return state.count;
}
  800217:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  80021d:	c9                   	leave
  80021e:	c3                   	ret

000000000080021f <cprintf>:

int
cprintf(const char *fmt, ...) {
  80021f:	f3 0f 1e fa          	endbr64
  800223:	55                   	push   %rbp
  800224:	48 89 e5             	mov    %rsp,%rbp
  800227:	48 83 ec 50          	sub    $0x50,%rsp
  80022b:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80022f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800233:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800237:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80023b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  80023f:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800246:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80024a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80024e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800252:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800256:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80025a:	48 b8 b7 01 80 00 00 	movabs $0x8001b7,%rax
  800261:	00 00 00 
  800264:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800266:	c9                   	leave
  800267:	c3                   	ret

0000000000800268 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800268:	f3 0f 1e fa          	endbr64
  80026c:	55                   	push   %rbp
  80026d:	48 89 e5             	mov    %rsp,%rbp
  800270:	41 57                	push   %r15
  800272:	41 56                	push   %r14
  800274:	41 55                	push   %r13
  800276:	41 54                	push   %r12
  800278:	53                   	push   %rbx
  800279:	48 83 ec 18          	sub    $0x18,%rsp
  80027d:	49 89 fc             	mov    %rdi,%r12
  800280:	49 89 f5             	mov    %rsi,%r13
  800283:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800287:	8b 45 10             	mov    0x10(%rbp),%eax
  80028a:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80028d:	41 89 cf             	mov    %ecx,%r15d
  800290:	4c 39 fa             	cmp    %r15,%rdx
  800293:	73 5b                	jae    8002f0 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800295:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800299:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80029d:	85 db                	test   %ebx,%ebx
  80029f:	7e 0e                	jle    8002af <print_num+0x47>
            putch(padc, put_arg);
  8002a1:	4c 89 ee             	mov    %r13,%rsi
  8002a4:	44 89 f7             	mov    %r14d,%edi
  8002a7:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8002aa:	83 eb 01             	sub    $0x1,%ebx
  8002ad:	75 f2                	jne    8002a1 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8002af:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8002b3:	48 b9 20 30 80 00 00 	movabs $0x803020,%rcx
  8002ba:	00 00 00 
  8002bd:	48 b8 0f 30 80 00 00 	movabs $0x80300f,%rax
  8002c4:	00 00 00 
  8002c7:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8002cb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d4:	49 f7 f7             	div    %r15
  8002d7:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8002db:	4c 89 ee             	mov    %r13,%rsi
  8002de:	41 ff d4             	call   *%r12
}
  8002e1:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8002e5:	5b                   	pop    %rbx
  8002e6:	41 5c                	pop    %r12
  8002e8:	41 5d                	pop    %r13
  8002ea:	41 5e                	pop    %r14
  8002ec:	41 5f                	pop    %r15
  8002ee:	5d                   	pop    %rbp
  8002ef:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8002f0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f9:	49 f7 f7             	div    %r15
  8002fc:	48 83 ec 08          	sub    $0x8,%rsp
  800300:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800304:	52                   	push   %rdx
  800305:	45 0f be c9          	movsbl %r9b,%r9d
  800309:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80030d:	48 89 c2             	mov    %rax,%rdx
  800310:	48 b8 68 02 80 00 00 	movabs $0x800268,%rax
  800317:	00 00 00 
  80031a:	ff d0                	call   *%rax
  80031c:	48 83 c4 10          	add    $0x10,%rsp
  800320:	eb 8d                	jmp    8002af <print_num+0x47>

0000000000800322 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800322:	f3 0f 1e fa          	endbr64
    state->count++;
  800326:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80032a:	48 8b 06             	mov    (%rsi),%rax
  80032d:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800331:	73 0a                	jae    80033d <sprintputch+0x1b>
        *state->start++ = ch;
  800333:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800337:	48 89 16             	mov    %rdx,(%rsi)
  80033a:	40 88 38             	mov    %dil,(%rax)
    }
}
  80033d:	c3                   	ret

000000000080033e <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80033e:	f3 0f 1e fa          	endbr64
  800342:	55                   	push   %rbp
  800343:	48 89 e5             	mov    %rsp,%rbp
  800346:	48 83 ec 50          	sub    $0x50,%rsp
  80034a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80034e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800352:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800356:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80035d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800361:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800365:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800369:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80036d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800371:	48 b8 7f 03 80 00 00 	movabs $0x80037f,%rax
  800378:	00 00 00 
  80037b:	ff d0                	call   *%rax
}
  80037d:	c9                   	leave
  80037e:	c3                   	ret

000000000080037f <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80037f:	f3 0f 1e fa          	endbr64
  800383:	55                   	push   %rbp
  800384:	48 89 e5             	mov    %rsp,%rbp
  800387:	41 57                	push   %r15
  800389:	41 56                	push   %r14
  80038b:	41 55                	push   %r13
  80038d:	41 54                	push   %r12
  80038f:	53                   	push   %rbx
  800390:	48 83 ec 38          	sub    $0x38,%rsp
  800394:	49 89 fe             	mov    %rdi,%r14
  800397:	49 89 f5             	mov    %rsi,%r13
  80039a:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  80039d:	48 8b 01             	mov    (%rcx),%rax
  8003a0:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8003a4:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8003a8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003ac:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8003b0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8003b4:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  8003b8:	0f b6 3b             	movzbl (%rbx),%edi
  8003bb:	40 80 ff 25          	cmp    $0x25,%dil
  8003bf:	74 18                	je     8003d9 <vprintfmt+0x5a>
            if (!ch) return;
  8003c1:	40 84 ff             	test   %dil,%dil
  8003c4:	0f 84 b2 06 00 00    	je     800a7c <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8003ca:	40 0f b6 ff          	movzbl %dil,%edi
  8003ce:	4c 89 ee             	mov    %r13,%rsi
  8003d1:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8003d4:	4c 89 e3             	mov    %r12,%rbx
  8003d7:	eb db                	jmp    8003b4 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8003d9:	be 00 00 00 00       	mov    $0x0,%esi
  8003de:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8003e2:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8003e7:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8003ed:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8003f4:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8003f8:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8003fd:	41 0f b6 04 24       	movzbl (%r12),%eax
  800402:	88 45 a0             	mov    %al,-0x60(%rbp)
  800405:	83 e8 23             	sub    $0x23,%eax
  800408:	3c 57                	cmp    $0x57,%al
  80040a:	0f 87 52 06 00 00    	ja     800a62 <vprintfmt+0x6e3>
  800410:	0f b6 c0             	movzbl %al,%eax
  800413:	48 b9 60 32 80 00 00 	movabs $0x803260,%rcx
  80041a:	00 00 00 
  80041d:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800421:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800424:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  800428:	eb ce                	jmp    8003f8 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  80042a:	49 89 dc             	mov    %rbx,%r12
  80042d:	be 01 00 00 00       	mov    $0x1,%esi
  800432:	eb c4                	jmp    8003f8 <vprintfmt+0x79>
            padc = ch;
  800434:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800438:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80043b:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80043e:	eb b8                	jmp    8003f8 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800440:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800443:	83 f8 2f             	cmp    $0x2f,%eax
  800446:	77 24                	ja     80046c <vprintfmt+0xed>
  800448:	89 c1                	mov    %eax,%ecx
  80044a:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  80044e:	83 c0 08             	add    $0x8,%eax
  800451:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800454:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800457:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  80045a:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80045e:	79 98                	jns    8003f8 <vprintfmt+0x79>
                width = precision;
  800460:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800464:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80046a:	eb 8c                	jmp    8003f8 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80046c:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800470:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800474:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800478:	eb da                	jmp    800454 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80047a:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  80047f:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800483:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800489:	3c 39                	cmp    $0x39,%al
  80048b:	77 1c                	ja     8004a9 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  80048d:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800491:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800495:	0f b6 c0             	movzbl %al,%eax
  800498:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80049d:	0f b6 03             	movzbl (%rbx),%eax
  8004a0:	3c 39                	cmp    $0x39,%al
  8004a2:	76 e9                	jbe    80048d <vprintfmt+0x10e>
        process_precision:
  8004a4:	49 89 dc             	mov    %rbx,%r12
  8004a7:	eb b1                	jmp    80045a <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  8004a9:	49 89 dc             	mov    %rbx,%r12
  8004ac:	eb ac                	jmp    80045a <vprintfmt+0xdb>
            width = MAX(0, width);
  8004ae:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  8004b1:	85 c9                	test   %ecx,%ecx
  8004b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b8:	0f 49 c1             	cmovns %ecx,%eax
  8004bb:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8004be:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8004c1:	e9 32 ff ff ff       	jmp    8003f8 <vprintfmt+0x79>
            lflag++;
  8004c6:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8004c9:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8004cc:	e9 27 ff ff ff       	jmp    8003f8 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8004d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004d4:	83 f8 2f             	cmp    $0x2f,%eax
  8004d7:	77 19                	ja     8004f2 <vprintfmt+0x173>
  8004d9:	89 c2                	mov    %eax,%edx
  8004db:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8004df:	83 c0 08             	add    $0x8,%eax
  8004e2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004e5:	8b 3a                	mov    (%rdx),%edi
  8004e7:	4c 89 ee             	mov    %r13,%rsi
  8004ea:	41 ff d6             	call   *%r14
            break;
  8004ed:	e9 c2 fe ff ff       	jmp    8003b4 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8004f2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004f6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8004fa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004fe:	eb e5                	jmp    8004e5 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800500:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800503:	83 f8 2f             	cmp    $0x2f,%eax
  800506:	77 5a                	ja     800562 <vprintfmt+0x1e3>
  800508:	89 c2                	mov    %eax,%edx
  80050a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80050e:	83 c0 08             	add    $0x8,%eax
  800511:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800514:	8b 02                	mov    (%rdx),%eax
  800516:	89 c1                	mov    %eax,%ecx
  800518:	f7 d9                	neg    %ecx
  80051a:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80051d:	83 f9 13             	cmp    $0x13,%ecx
  800520:	7f 4e                	jg     800570 <vprintfmt+0x1f1>
  800522:	48 63 c1             	movslq %ecx,%rax
  800525:	48 ba 20 35 80 00 00 	movabs $0x803520,%rdx
  80052c:	00 00 00 
  80052f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800533:	48 85 c0             	test   %rax,%rax
  800536:	74 38                	je     800570 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  800538:	48 89 c1             	mov    %rax,%rcx
  80053b:	48 ba 14 32 80 00 00 	movabs $0x803214,%rdx
  800542:	00 00 00 
  800545:	4c 89 ee             	mov    %r13,%rsi
  800548:	4c 89 f7             	mov    %r14,%rdi
  80054b:	b8 00 00 00 00       	mov    $0x0,%eax
  800550:	49 b8 3e 03 80 00 00 	movabs $0x80033e,%r8
  800557:	00 00 00 
  80055a:	41 ff d0             	call   *%r8
  80055d:	e9 52 fe ff ff       	jmp    8003b4 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800562:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800566:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80056a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80056e:	eb a4                	jmp    800514 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800570:	48 ba 38 30 80 00 00 	movabs $0x803038,%rdx
  800577:	00 00 00 
  80057a:	4c 89 ee             	mov    %r13,%rsi
  80057d:	4c 89 f7             	mov    %r14,%rdi
  800580:	b8 00 00 00 00       	mov    $0x0,%eax
  800585:	49 b8 3e 03 80 00 00 	movabs $0x80033e,%r8
  80058c:	00 00 00 
  80058f:	41 ff d0             	call   *%r8
  800592:	e9 1d fe ff ff       	jmp    8003b4 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800597:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80059a:	83 f8 2f             	cmp    $0x2f,%eax
  80059d:	77 6c                	ja     80060b <vprintfmt+0x28c>
  80059f:	89 c2                	mov    %eax,%edx
  8005a1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8005a5:	83 c0 08             	add    $0x8,%eax
  8005a8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005ab:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8005ae:	48 85 d2             	test   %rdx,%rdx
  8005b1:	48 b8 31 30 80 00 00 	movabs $0x803031,%rax
  8005b8:	00 00 00 
  8005bb:	48 0f 45 c2          	cmovne %rdx,%rax
  8005bf:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8005c3:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8005c7:	7e 06                	jle    8005cf <vprintfmt+0x250>
  8005c9:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8005cd:	75 4a                	jne    800619 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8005cf:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8005d3:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8005d7:	0f b6 00             	movzbl (%rax),%eax
  8005da:	84 c0                	test   %al,%al
  8005dc:	0f 85 9a 00 00 00    	jne    80067c <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8005e2:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005e5:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8005e9:	85 c0                	test   %eax,%eax
  8005eb:	0f 8e c3 fd ff ff    	jle    8003b4 <vprintfmt+0x35>
  8005f1:	4c 89 ee             	mov    %r13,%rsi
  8005f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8005f9:	41 ff d6             	call   *%r14
  8005fc:	41 83 ec 01          	sub    $0x1,%r12d
  800600:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800604:	75 eb                	jne    8005f1 <vprintfmt+0x272>
  800606:	e9 a9 fd ff ff       	jmp    8003b4 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80060b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80060f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800613:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800617:	eb 92                	jmp    8005ab <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800619:	49 63 f7             	movslq %r15d,%rsi
  80061c:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800620:	48 b8 42 0b 80 00 00 	movabs $0x800b42,%rax
  800627:	00 00 00 
  80062a:	ff d0                	call   *%rax
  80062c:	48 89 c2             	mov    %rax,%rdx
  80062f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800632:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800634:	8d 70 ff             	lea    -0x1(%rax),%esi
  800637:	89 75 ac             	mov    %esi,-0x54(%rbp)
  80063a:	85 c0                	test   %eax,%eax
  80063c:	7e 91                	jle    8005cf <vprintfmt+0x250>
  80063e:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800643:	4c 89 ee             	mov    %r13,%rsi
  800646:	44 89 e7             	mov    %r12d,%edi
  800649:	41 ff d6             	call   *%r14
  80064c:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800650:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800653:	83 f8 ff             	cmp    $0xffffffff,%eax
  800656:	75 eb                	jne    800643 <vprintfmt+0x2c4>
  800658:	e9 72 ff ff ff       	jmp    8005cf <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80065d:	0f b6 f8             	movzbl %al,%edi
  800660:	4c 89 ee             	mov    %r13,%rsi
  800663:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800666:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80066a:	49 83 c4 01          	add    $0x1,%r12
  80066e:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800674:	84 c0                	test   %al,%al
  800676:	0f 84 66 ff ff ff    	je     8005e2 <vprintfmt+0x263>
  80067c:	45 85 ff             	test   %r15d,%r15d
  80067f:	78 0a                	js     80068b <vprintfmt+0x30c>
  800681:	41 83 ef 01          	sub    $0x1,%r15d
  800685:	0f 88 57 ff ff ff    	js     8005e2 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80068b:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  80068f:	74 cc                	je     80065d <vprintfmt+0x2de>
  800691:	8d 50 e0             	lea    -0x20(%rax),%edx
  800694:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800699:	80 fa 5e             	cmp    $0x5e,%dl
  80069c:	77 c2                	ja     800660 <vprintfmt+0x2e1>
  80069e:	eb bd                	jmp    80065d <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8006a0:	40 84 f6             	test   %sil,%sil
  8006a3:	75 26                	jne    8006cb <vprintfmt+0x34c>
    switch (lflag) {
  8006a5:	85 d2                	test   %edx,%edx
  8006a7:	74 59                	je     800702 <vprintfmt+0x383>
  8006a9:	83 fa 01             	cmp    $0x1,%edx
  8006ac:	74 7b                	je     800729 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8006ae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006b1:	83 f8 2f             	cmp    $0x2f,%eax
  8006b4:	0f 87 96 00 00 00    	ja     800750 <vprintfmt+0x3d1>
  8006ba:	89 c2                	mov    %eax,%edx
  8006bc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006c0:	83 c0 08             	add    $0x8,%eax
  8006c3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006c6:	4c 8b 22             	mov    (%rdx),%r12
  8006c9:	eb 17                	jmp    8006e2 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8006cb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006ce:	83 f8 2f             	cmp    $0x2f,%eax
  8006d1:	77 21                	ja     8006f4 <vprintfmt+0x375>
  8006d3:	89 c2                	mov    %eax,%edx
  8006d5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006d9:	83 c0 08             	add    $0x8,%eax
  8006dc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006df:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8006e2:	4d 85 e4             	test   %r12,%r12
  8006e5:	78 7a                	js     800761 <vprintfmt+0x3e2>
            num = i;
  8006e7:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8006ea:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006ef:	e9 50 02 00 00       	jmp    800944 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8006f4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006f8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006fc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800700:	eb dd                	jmp    8006df <vprintfmt+0x360>
        return va_arg(*ap, int);
  800702:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800705:	83 f8 2f             	cmp    $0x2f,%eax
  800708:	77 11                	ja     80071b <vprintfmt+0x39c>
  80070a:	89 c2                	mov    %eax,%edx
  80070c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800710:	83 c0 08             	add    $0x8,%eax
  800713:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800716:	4c 63 22             	movslq (%rdx),%r12
  800719:	eb c7                	jmp    8006e2 <vprintfmt+0x363>
  80071b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80071f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800723:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800727:	eb ed                	jmp    800716 <vprintfmt+0x397>
        return va_arg(*ap, long);
  800729:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80072c:	83 f8 2f             	cmp    $0x2f,%eax
  80072f:	77 11                	ja     800742 <vprintfmt+0x3c3>
  800731:	89 c2                	mov    %eax,%edx
  800733:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800737:	83 c0 08             	add    $0x8,%eax
  80073a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80073d:	4c 8b 22             	mov    (%rdx),%r12
  800740:	eb a0                	jmp    8006e2 <vprintfmt+0x363>
  800742:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800746:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80074a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80074e:	eb ed                	jmp    80073d <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800750:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800754:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800758:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80075c:	e9 65 ff ff ff       	jmp    8006c6 <vprintfmt+0x347>
                putch('-', put_arg);
  800761:	4c 89 ee             	mov    %r13,%rsi
  800764:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800769:	41 ff d6             	call   *%r14
                i = -i;
  80076c:	49 f7 dc             	neg    %r12
  80076f:	e9 73 ff ff ff       	jmp    8006e7 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800774:	40 84 f6             	test   %sil,%sil
  800777:	75 32                	jne    8007ab <vprintfmt+0x42c>
    switch (lflag) {
  800779:	85 d2                	test   %edx,%edx
  80077b:	74 5d                	je     8007da <vprintfmt+0x45b>
  80077d:	83 fa 01             	cmp    $0x1,%edx
  800780:	0f 84 82 00 00 00    	je     800808 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800786:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800789:	83 f8 2f             	cmp    $0x2f,%eax
  80078c:	0f 87 a5 00 00 00    	ja     800837 <vprintfmt+0x4b8>
  800792:	89 c2                	mov    %eax,%edx
  800794:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800798:	83 c0 08             	add    $0x8,%eax
  80079b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80079e:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8007a1:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8007a6:	e9 99 01 00 00       	jmp    800944 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8007ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ae:	83 f8 2f             	cmp    $0x2f,%eax
  8007b1:	77 19                	ja     8007cc <vprintfmt+0x44d>
  8007b3:	89 c2                	mov    %eax,%edx
  8007b5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007b9:	83 c0 08             	add    $0x8,%eax
  8007bc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007bf:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8007c2:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8007c7:	e9 78 01 00 00       	jmp    800944 <vprintfmt+0x5c5>
  8007cc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007d0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007d4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007d8:	eb e5                	jmp    8007bf <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8007da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007dd:	83 f8 2f             	cmp    $0x2f,%eax
  8007e0:	77 18                	ja     8007fa <vprintfmt+0x47b>
  8007e2:	89 c2                	mov    %eax,%edx
  8007e4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007e8:	83 c0 08             	add    $0x8,%eax
  8007eb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007ee:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8007f0:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8007f5:	e9 4a 01 00 00       	jmp    800944 <vprintfmt+0x5c5>
  8007fa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007fe:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800802:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800806:	eb e6                	jmp    8007ee <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800808:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80080b:	83 f8 2f             	cmp    $0x2f,%eax
  80080e:	77 19                	ja     800829 <vprintfmt+0x4aa>
  800810:	89 c2                	mov    %eax,%edx
  800812:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800816:	83 c0 08             	add    $0x8,%eax
  800819:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80081c:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80081f:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800824:	e9 1b 01 00 00       	jmp    800944 <vprintfmt+0x5c5>
  800829:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80082d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800831:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800835:	eb e5                	jmp    80081c <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800837:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80083b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80083f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800843:	e9 56 ff ff ff       	jmp    80079e <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800848:	40 84 f6             	test   %sil,%sil
  80084b:	75 2e                	jne    80087b <vprintfmt+0x4fc>
    switch (lflag) {
  80084d:	85 d2                	test   %edx,%edx
  80084f:	74 59                	je     8008aa <vprintfmt+0x52b>
  800851:	83 fa 01             	cmp    $0x1,%edx
  800854:	74 7f                	je     8008d5 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800856:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800859:	83 f8 2f             	cmp    $0x2f,%eax
  80085c:	0f 87 9f 00 00 00    	ja     800901 <vprintfmt+0x582>
  800862:	89 c2                	mov    %eax,%edx
  800864:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800868:	83 c0 08             	add    $0x8,%eax
  80086b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80086e:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800871:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800876:	e9 c9 00 00 00       	jmp    800944 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80087b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087e:	83 f8 2f             	cmp    $0x2f,%eax
  800881:	77 19                	ja     80089c <vprintfmt+0x51d>
  800883:	89 c2                	mov    %eax,%edx
  800885:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800889:	83 c0 08             	add    $0x8,%eax
  80088c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80088f:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800892:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800897:	e9 a8 00 00 00       	jmp    800944 <vprintfmt+0x5c5>
  80089c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008a0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008a8:	eb e5                	jmp    80088f <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8008aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ad:	83 f8 2f             	cmp    $0x2f,%eax
  8008b0:	77 15                	ja     8008c7 <vprintfmt+0x548>
  8008b2:	89 c2                	mov    %eax,%edx
  8008b4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008b8:	83 c0 08             	add    $0x8,%eax
  8008bb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008be:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8008c0:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8008c5:	eb 7d                	jmp    800944 <vprintfmt+0x5c5>
  8008c7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008cb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008cf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008d3:	eb e9                	jmp    8008be <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8008d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d8:	83 f8 2f             	cmp    $0x2f,%eax
  8008db:	77 16                	ja     8008f3 <vprintfmt+0x574>
  8008dd:	89 c2                	mov    %eax,%edx
  8008df:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008e3:	83 c0 08             	add    $0x8,%eax
  8008e6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008e9:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8008ec:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008f1:	eb 51                	jmp    800944 <vprintfmt+0x5c5>
  8008f3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008f7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008fb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ff:	eb e8                	jmp    8008e9 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800901:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800905:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800909:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80090d:	e9 5c ff ff ff       	jmp    80086e <vprintfmt+0x4ef>
            putch('0', put_arg);
  800912:	4c 89 ee             	mov    %r13,%rsi
  800915:	bf 30 00 00 00       	mov    $0x30,%edi
  80091a:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  80091d:	4c 89 ee             	mov    %r13,%rsi
  800920:	bf 78 00 00 00       	mov    $0x78,%edi
  800925:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800928:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80092b:	83 f8 2f             	cmp    $0x2f,%eax
  80092e:	77 47                	ja     800977 <vprintfmt+0x5f8>
  800930:	89 c2                	mov    %eax,%edx
  800932:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800936:	83 c0 08             	add    $0x8,%eax
  800939:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80093c:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80093f:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800944:	48 83 ec 08          	sub    $0x8,%rsp
  800948:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  80094c:	0f 94 c0             	sete   %al
  80094f:	0f b6 c0             	movzbl %al,%eax
  800952:	50                   	push   %rax
  800953:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800958:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80095c:	4c 89 ee             	mov    %r13,%rsi
  80095f:	4c 89 f7             	mov    %r14,%rdi
  800962:	48 b8 68 02 80 00 00 	movabs $0x800268,%rax
  800969:	00 00 00 
  80096c:	ff d0                	call   *%rax
            break;
  80096e:	48 83 c4 10          	add    $0x10,%rsp
  800972:	e9 3d fa ff ff       	jmp    8003b4 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800977:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80097b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80097f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800983:	eb b7                	jmp    80093c <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800985:	40 84 f6             	test   %sil,%sil
  800988:	75 2b                	jne    8009b5 <vprintfmt+0x636>
    switch (lflag) {
  80098a:	85 d2                	test   %edx,%edx
  80098c:	74 56                	je     8009e4 <vprintfmt+0x665>
  80098e:	83 fa 01             	cmp    $0x1,%edx
  800991:	74 7f                	je     800a12 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800993:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800996:	83 f8 2f             	cmp    $0x2f,%eax
  800999:	0f 87 a2 00 00 00    	ja     800a41 <vprintfmt+0x6c2>
  80099f:	89 c2                	mov    %eax,%edx
  8009a1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009a5:	83 c0 08             	add    $0x8,%eax
  8009a8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ab:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009ae:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8009b3:	eb 8f                	jmp    800944 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8009b5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b8:	83 f8 2f             	cmp    $0x2f,%eax
  8009bb:	77 19                	ja     8009d6 <vprintfmt+0x657>
  8009bd:	89 c2                	mov    %eax,%edx
  8009bf:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009c3:	83 c0 08             	add    $0x8,%eax
  8009c6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009c9:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009cc:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009d1:	e9 6e ff ff ff       	jmp    800944 <vprintfmt+0x5c5>
  8009d6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009da:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009de:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009e2:	eb e5                	jmp    8009c9 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8009e4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e7:	83 f8 2f             	cmp    $0x2f,%eax
  8009ea:	77 18                	ja     800a04 <vprintfmt+0x685>
  8009ec:	89 c2                	mov    %eax,%edx
  8009ee:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009f2:	83 c0 08             	add    $0x8,%eax
  8009f5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009f8:	8b 12                	mov    (%rdx),%edx
            base = 16;
  8009fa:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8009ff:	e9 40 ff ff ff       	jmp    800944 <vprintfmt+0x5c5>
  800a04:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a08:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a0c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a10:	eb e6                	jmp    8009f8 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800a12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a15:	83 f8 2f             	cmp    $0x2f,%eax
  800a18:	77 19                	ja     800a33 <vprintfmt+0x6b4>
  800a1a:	89 c2                	mov    %eax,%edx
  800a1c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a20:	83 c0 08             	add    $0x8,%eax
  800a23:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a26:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a29:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800a2e:	e9 11 ff ff ff       	jmp    800944 <vprintfmt+0x5c5>
  800a33:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a37:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a3b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a3f:	eb e5                	jmp    800a26 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800a41:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a45:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a49:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a4d:	e9 59 ff ff ff       	jmp    8009ab <vprintfmt+0x62c>
            putch(ch, put_arg);
  800a52:	4c 89 ee             	mov    %r13,%rsi
  800a55:	bf 25 00 00 00       	mov    $0x25,%edi
  800a5a:	41 ff d6             	call   *%r14
            break;
  800a5d:	e9 52 f9 ff ff       	jmp    8003b4 <vprintfmt+0x35>
            putch('%', put_arg);
  800a62:	4c 89 ee             	mov    %r13,%rsi
  800a65:	bf 25 00 00 00       	mov    $0x25,%edi
  800a6a:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800a6d:	48 83 eb 01          	sub    $0x1,%rbx
  800a71:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800a75:	75 f6                	jne    800a6d <vprintfmt+0x6ee>
  800a77:	e9 38 f9 ff ff       	jmp    8003b4 <vprintfmt+0x35>
}
  800a7c:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a80:	5b                   	pop    %rbx
  800a81:	41 5c                	pop    %r12
  800a83:	41 5d                	pop    %r13
  800a85:	41 5e                	pop    %r14
  800a87:	41 5f                	pop    %r15
  800a89:	5d                   	pop    %rbp
  800a8a:	c3                   	ret

0000000000800a8b <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a8b:	f3 0f 1e fa          	endbr64
  800a8f:	55                   	push   %rbp
  800a90:	48 89 e5             	mov    %rsp,%rbp
  800a93:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800a97:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a9b:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800aa0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800aa4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800aab:	48 85 ff             	test   %rdi,%rdi
  800aae:	74 2b                	je     800adb <vsnprintf+0x50>
  800ab0:	48 85 f6             	test   %rsi,%rsi
  800ab3:	74 26                	je     800adb <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800ab5:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800ab9:	48 bf 22 03 80 00 00 	movabs $0x800322,%rdi
  800ac0:	00 00 00 
  800ac3:	48 b8 7f 03 80 00 00 	movabs $0x80037f,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800acf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad3:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800ad6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ad9:	c9                   	leave
  800ada:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800adb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ae0:	eb f7                	jmp    800ad9 <vsnprintf+0x4e>

0000000000800ae2 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800ae2:	f3 0f 1e fa          	endbr64
  800ae6:	55                   	push   %rbp
  800ae7:	48 89 e5             	mov    %rsp,%rbp
  800aea:	48 83 ec 50          	sub    $0x50,%rsp
  800aee:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800af2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800af6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800afa:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800b01:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b05:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b09:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800b0d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800b11:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800b15:	48 b8 8b 0a 80 00 00 	movabs $0x800a8b,%rax
  800b1c:	00 00 00 
  800b1f:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800b21:	c9                   	leave
  800b22:	c3                   	ret

0000000000800b23 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800b23:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800b27:	80 3f 00             	cmpb   $0x0,(%rdi)
  800b2a:	74 10                	je     800b3c <strlen+0x19>
    size_t n = 0;
  800b2c:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800b31:	48 83 c0 01          	add    $0x1,%rax
  800b35:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b39:	75 f6                	jne    800b31 <strlen+0xe>
  800b3b:	c3                   	ret
    size_t n = 0;
  800b3c:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800b41:	c3                   	ret

0000000000800b42 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800b42:	f3 0f 1e fa          	endbr64
  800b46:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800b49:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800b4e:	48 85 f6             	test   %rsi,%rsi
  800b51:	74 10                	je     800b63 <strnlen+0x21>
  800b53:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800b57:	74 0b                	je     800b64 <strnlen+0x22>
  800b59:	48 83 c2 01          	add    $0x1,%rdx
  800b5d:	48 39 d0             	cmp    %rdx,%rax
  800b60:	75 f1                	jne    800b53 <strnlen+0x11>
  800b62:	c3                   	ret
  800b63:	c3                   	ret
  800b64:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800b67:	c3                   	ret

0000000000800b68 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800b68:	f3 0f 1e fa          	endbr64
  800b6c:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b74:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800b78:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800b7b:	48 83 c2 01          	add    $0x1,%rdx
  800b7f:	84 c9                	test   %cl,%cl
  800b81:	75 f1                	jne    800b74 <strcpy+0xc>
        ;
    return res;
}
  800b83:	c3                   	ret

0000000000800b84 <strcat>:

char *
strcat(char *dst, const char *src) {
  800b84:	f3 0f 1e fa          	endbr64
  800b88:	55                   	push   %rbp
  800b89:	48 89 e5             	mov    %rsp,%rbp
  800b8c:	41 54                	push   %r12
  800b8e:	53                   	push   %rbx
  800b8f:	48 89 fb             	mov    %rdi,%rbx
  800b92:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800b95:	48 b8 23 0b 80 00 00 	movabs $0x800b23,%rax
  800b9c:	00 00 00 
  800b9f:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800ba1:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800ba5:	4c 89 e6             	mov    %r12,%rsi
  800ba8:	48 b8 68 0b 80 00 00 	movabs $0x800b68,%rax
  800baf:	00 00 00 
  800bb2:	ff d0                	call   *%rax
    return dst;
}
  800bb4:	48 89 d8             	mov    %rbx,%rax
  800bb7:	5b                   	pop    %rbx
  800bb8:	41 5c                	pop    %r12
  800bba:	5d                   	pop    %rbp
  800bbb:	c3                   	ret

0000000000800bbc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bbc:	f3 0f 1e fa          	endbr64
  800bc0:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800bc3:	48 85 d2             	test   %rdx,%rdx
  800bc6:	74 1f                	je     800be7 <strncpy+0x2b>
  800bc8:	48 01 fa             	add    %rdi,%rdx
  800bcb:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800bce:	48 83 c1 01          	add    $0x1,%rcx
  800bd2:	44 0f b6 06          	movzbl (%rsi),%r8d
  800bd6:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800bda:	41 80 f8 01          	cmp    $0x1,%r8b
  800bde:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800be2:	48 39 ca             	cmp    %rcx,%rdx
  800be5:	75 e7                	jne    800bce <strncpy+0x12>
    }
    return ret;
}
  800be7:	c3                   	ret

0000000000800be8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800be8:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800bec:	48 89 f8             	mov    %rdi,%rax
  800bef:	48 85 d2             	test   %rdx,%rdx
  800bf2:	74 24                	je     800c18 <strlcpy+0x30>
        while (--size > 0 && *src)
  800bf4:	48 83 ea 01          	sub    $0x1,%rdx
  800bf8:	74 1b                	je     800c15 <strlcpy+0x2d>
  800bfa:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800bfe:	0f b6 16             	movzbl (%rsi),%edx
  800c01:	84 d2                	test   %dl,%dl
  800c03:	74 10                	je     800c15 <strlcpy+0x2d>
            *dst++ = *src++;
  800c05:	48 83 c6 01          	add    $0x1,%rsi
  800c09:	48 83 c0 01          	add    $0x1,%rax
  800c0d:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800c10:	48 39 c8             	cmp    %rcx,%rax
  800c13:	75 e9                	jne    800bfe <strlcpy+0x16>
        *dst = '\0';
  800c15:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800c18:	48 29 f8             	sub    %rdi,%rax
}
  800c1b:	c3                   	ret

0000000000800c1c <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800c1c:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800c20:	0f b6 07             	movzbl (%rdi),%eax
  800c23:	84 c0                	test   %al,%al
  800c25:	74 13                	je     800c3a <strcmp+0x1e>
  800c27:	38 06                	cmp    %al,(%rsi)
  800c29:	75 0f                	jne    800c3a <strcmp+0x1e>
  800c2b:	48 83 c7 01          	add    $0x1,%rdi
  800c2f:	48 83 c6 01          	add    $0x1,%rsi
  800c33:	0f b6 07             	movzbl (%rdi),%eax
  800c36:	84 c0                	test   %al,%al
  800c38:	75 ed                	jne    800c27 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800c3a:	0f b6 c0             	movzbl %al,%eax
  800c3d:	0f b6 16             	movzbl (%rsi),%edx
  800c40:	29 d0                	sub    %edx,%eax
}
  800c42:	c3                   	ret

0000000000800c43 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800c43:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800c47:	48 85 d2             	test   %rdx,%rdx
  800c4a:	74 1f                	je     800c6b <strncmp+0x28>
  800c4c:	0f b6 07             	movzbl (%rdi),%eax
  800c4f:	84 c0                	test   %al,%al
  800c51:	74 1e                	je     800c71 <strncmp+0x2e>
  800c53:	3a 06                	cmp    (%rsi),%al
  800c55:	75 1a                	jne    800c71 <strncmp+0x2e>
  800c57:	48 83 c7 01          	add    $0x1,%rdi
  800c5b:	48 83 c6 01          	add    $0x1,%rsi
  800c5f:	48 83 ea 01          	sub    $0x1,%rdx
  800c63:	75 e7                	jne    800c4c <strncmp+0x9>

    if (!n) return 0;
  800c65:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6a:	c3                   	ret
  800c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c70:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c71:	0f b6 07             	movzbl (%rdi),%eax
  800c74:	0f b6 16             	movzbl (%rsi),%edx
  800c77:	29 d0                	sub    %edx,%eax
}
  800c79:	c3                   	ret

0000000000800c7a <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800c7a:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800c7e:	0f b6 17             	movzbl (%rdi),%edx
  800c81:	84 d2                	test   %dl,%dl
  800c83:	74 18                	je     800c9d <strchr+0x23>
        if (*str == c) {
  800c85:	0f be d2             	movsbl %dl,%edx
  800c88:	39 f2                	cmp    %esi,%edx
  800c8a:	74 17                	je     800ca3 <strchr+0x29>
    for (; *str; str++) {
  800c8c:	48 83 c7 01          	add    $0x1,%rdi
  800c90:	0f b6 17             	movzbl (%rdi),%edx
  800c93:	84 d2                	test   %dl,%dl
  800c95:	75 ee                	jne    800c85 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9c:	c3                   	ret
  800c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca2:	c3                   	ret
            return (char *)str;
  800ca3:	48 89 f8             	mov    %rdi,%rax
}
  800ca6:	c3                   	ret

0000000000800ca7 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800ca7:	f3 0f 1e fa          	endbr64
  800cab:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800cae:	0f b6 17             	movzbl (%rdi),%edx
  800cb1:	84 d2                	test   %dl,%dl
  800cb3:	74 13                	je     800cc8 <strfind+0x21>
  800cb5:	0f be d2             	movsbl %dl,%edx
  800cb8:	39 f2                	cmp    %esi,%edx
  800cba:	74 0b                	je     800cc7 <strfind+0x20>
  800cbc:	48 83 c0 01          	add    $0x1,%rax
  800cc0:	0f b6 10             	movzbl (%rax),%edx
  800cc3:	84 d2                	test   %dl,%dl
  800cc5:	75 ee                	jne    800cb5 <strfind+0xe>
        ;
    return (char *)str;
}
  800cc7:	c3                   	ret
  800cc8:	c3                   	ret

0000000000800cc9 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800cc9:	f3 0f 1e fa          	endbr64
  800ccd:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800cd0:	48 89 f8             	mov    %rdi,%rax
  800cd3:	48 f7 d8             	neg    %rax
  800cd6:	83 e0 07             	and    $0x7,%eax
  800cd9:	49 89 d1             	mov    %rdx,%r9
  800cdc:	49 29 c1             	sub    %rax,%r9
  800cdf:	78 36                	js     800d17 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800ce1:	40 0f b6 c6          	movzbl %sil,%eax
  800ce5:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800cec:	01 01 01 
  800cef:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800cf3:	40 f6 c7 07          	test   $0x7,%dil
  800cf7:	75 38                	jne    800d31 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800cf9:	4c 89 c9             	mov    %r9,%rcx
  800cfc:	48 c1 f9 03          	sar    $0x3,%rcx
  800d00:	74 0c                	je     800d0e <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800d02:	fc                   	cld
  800d03:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800d06:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800d0a:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800d0e:	4d 85 c9             	test   %r9,%r9
  800d11:	75 45                	jne    800d58 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800d13:	4c 89 c0             	mov    %r8,%rax
  800d16:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800d17:	48 85 d2             	test   %rdx,%rdx
  800d1a:	74 f7                	je     800d13 <memset+0x4a>
  800d1c:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800d1f:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800d22:	48 83 c0 01          	add    $0x1,%rax
  800d26:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800d2a:	48 39 c2             	cmp    %rax,%rdx
  800d2d:	75 f3                	jne    800d22 <memset+0x59>
  800d2f:	eb e2                	jmp    800d13 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800d31:	40 f6 c7 01          	test   $0x1,%dil
  800d35:	74 06                	je     800d3d <memset+0x74>
  800d37:	88 07                	mov    %al,(%rdi)
  800d39:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d3d:	40 f6 c7 02          	test   $0x2,%dil
  800d41:	74 07                	je     800d4a <memset+0x81>
  800d43:	66 89 07             	mov    %ax,(%rdi)
  800d46:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d4a:	40 f6 c7 04          	test   $0x4,%dil
  800d4e:	74 a9                	je     800cf9 <memset+0x30>
  800d50:	89 07                	mov    %eax,(%rdi)
  800d52:	48 83 c7 04          	add    $0x4,%rdi
  800d56:	eb a1                	jmp    800cf9 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d58:	41 f6 c1 04          	test   $0x4,%r9b
  800d5c:	74 1b                	je     800d79 <memset+0xb0>
  800d5e:	89 07                	mov    %eax,(%rdi)
  800d60:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d64:	41 f6 c1 02          	test   $0x2,%r9b
  800d68:	74 07                	je     800d71 <memset+0xa8>
  800d6a:	66 89 07             	mov    %ax,(%rdi)
  800d6d:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d71:	41 f6 c1 01          	test   $0x1,%r9b
  800d75:	74 9c                	je     800d13 <memset+0x4a>
  800d77:	eb 06                	jmp    800d7f <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d79:	41 f6 c1 02          	test   $0x2,%r9b
  800d7d:	75 eb                	jne    800d6a <memset+0xa1>
        if (ni & 1) *ptr = k;
  800d7f:	88 07                	mov    %al,(%rdi)
  800d81:	eb 90                	jmp    800d13 <memset+0x4a>

0000000000800d83 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d83:	f3 0f 1e fa          	endbr64
  800d87:	48 89 f8             	mov    %rdi,%rax
  800d8a:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d8d:	48 39 fe             	cmp    %rdi,%rsi
  800d90:	73 3b                	jae    800dcd <memmove+0x4a>
  800d92:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800d96:	48 39 d7             	cmp    %rdx,%rdi
  800d99:	73 32                	jae    800dcd <memmove+0x4a>
        s += n;
        d += n;
  800d9b:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d9f:	48 89 d6             	mov    %rdx,%rsi
  800da2:	48 09 fe             	or     %rdi,%rsi
  800da5:	48 09 ce             	or     %rcx,%rsi
  800da8:	40 f6 c6 07          	test   $0x7,%sil
  800dac:	75 12                	jne    800dc0 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800dae:	48 83 ef 08          	sub    $0x8,%rdi
  800db2:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800db6:	48 c1 e9 03          	shr    $0x3,%rcx
  800dba:	fd                   	std
  800dbb:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800dbe:	fc                   	cld
  800dbf:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800dc0:	48 83 ef 01          	sub    $0x1,%rdi
  800dc4:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800dc8:	fd                   	std
  800dc9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800dcb:	eb f1                	jmp    800dbe <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800dcd:	48 89 f2             	mov    %rsi,%rdx
  800dd0:	48 09 c2             	or     %rax,%rdx
  800dd3:	48 09 ca             	or     %rcx,%rdx
  800dd6:	f6 c2 07             	test   $0x7,%dl
  800dd9:	75 0c                	jne    800de7 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800ddb:	48 c1 e9 03          	shr    $0x3,%rcx
  800ddf:	48 89 c7             	mov    %rax,%rdi
  800de2:	fc                   	cld
  800de3:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800de6:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800de7:	48 89 c7             	mov    %rax,%rdi
  800dea:	fc                   	cld
  800deb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800ded:	c3                   	ret

0000000000800dee <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800dee:	f3 0f 1e fa          	endbr64
  800df2:	55                   	push   %rbp
  800df3:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800df6:	48 b8 83 0d 80 00 00 	movabs $0x800d83,%rax
  800dfd:	00 00 00 
  800e00:	ff d0                	call   *%rax
}
  800e02:	5d                   	pop    %rbp
  800e03:	c3                   	ret

0000000000800e04 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800e04:	f3 0f 1e fa          	endbr64
  800e08:	55                   	push   %rbp
  800e09:	48 89 e5             	mov    %rsp,%rbp
  800e0c:	41 57                	push   %r15
  800e0e:	41 56                	push   %r14
  800e10:	41 55                	push   %r13
  800e12:	41 54                	push   %r12
  800e14:	53                   	push   %rbx
  800e15:	48 83 ec 08          	sub    $0x8,%rsp
  800e19:	49 89 fe             	mov    %rdi,%r14
  800e1c:	49 89 f7             	mov    %rsi,%r15
  800e1f:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800e22:	48 89 f7             	mov    %rsi,%rdi
  800e25:	48 b8 23 0b 80 00 00 	movabs $0x800b23,%rax
  800e2c:	00 00 00 
  800e2f:	ff d0                	call   *%rax
  800e31:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800e34:	48 89 de             	mov    %rbx,%rsi
  800e37:	4c 89 f7             	mov    %r14,%rdi
  800e3a:	48 b8 42 0b 80 00 00 	movabs $0x800b42,%rax
  800e41:	00 00 00 
  800e44:	ff d0                	call   *%rax
  800e46:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800e49:	48 39 c3             	cmp    %rax,%rbx
  800e4c:	74 36                	je     800e84 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800e4e:	48 89 d8             	mov    %rbx,%rax
  800e51:	4c 29 e8             	sub    %r13,%rax
  800e54:	49 39 c4             	cmp    %rax,%r12
  800e57:	73 31                	jae    800e8a <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800e59:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800e5e:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e62:	4c 89 fe             	mov    %r15,%rsi
  800e65:	48 b8 ee 0d 80 00 00 	movabs $0x800dee,%rax
  800e6c:	00 00 00 
  800e6f:	ff d0                	call   *%rax
    return dstlen + srclen;
  800e71:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800e75:	48 83 c4 08          	add    $0x8,%rsp
  800e79:	5b                   	pop    %rbx
  800e7a:	41 5c                	pop    %r12
  800e7c:	41 5d                	pop    %r13
  800e7e:	41 5e                	pop    %r14
  800e80:	41 5f                	pop    %r15
  800e82:	5d                   	pop    %rbp
  800e83:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800e84:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800e88:	eb eb                	jmp    800e75 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e8a:	48 83 eb 01          	sub    $0x1,%rbx
  800e8e:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e92:	48 89 da             	mov    %rbx,%rdx
  800e95:	4c 89 fe             	mov    %r15,%rsi
  800e98:	48 b8 ee 0d 80 00 00 	movabs $0x800dee,%rax
  800e9f:	00 00 00 
  800ea2:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800ea4:	49 01 de             	add    %rbx,%r14
  800ea7:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800eac:	eb c3                	jmp    800e71 <strlcat+0x6d>

0000000000800eae <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800eae:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800eb2:	48 85 d2             	test   %rdx,%rdx
  800eb5:	74 2d                	je     800ee4 <memcmp+0x36>
  800eb7:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800ebc:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800ec0:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800ec5:	44 38 c1             	cmp    %r8b,%cl
  800ec8:	75 0f                	jne    800ed9 <memcmp+0x2b>
    while (n-- > 0) {
  800eca:	48 83 c0 01          	add    $0x1,%rax
  800ece:	48 39 c2             	cmp    %rax,%rdx
  800ed1:	75 e9                	jne    800ebc <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed8:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800ed9:	0f b6 c1             	movzbl %cl,%eax
  800edc:	45 0f b6 c0          	movzbl %r8b,%r8d
  800ee0:	44 29 c0             	sub    %r8d,%eax
  800ee3:	c3                   	ret
    return 0;
  800ee4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee9:	c3                   	ret

0000000000800eea <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800eea:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800eee:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800ef2:	48 39 c7             	cmp    %rax,%rdi
  800ef5:	73 0f                	jae    800f06 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800ef7:	40 38 37             	cmp    %sil,(%rdi)
  800efa:	74 0e                	je     800f0a <memfind+0x20>
    for (; src < end; src++) {
  800efc:	48 83 c7 01          	add    $0x1,%rdi
  800f00:	48 39 f8             	cmp    %rdi,%rax
  800f03:	75 f2                	jne    800ef7 <memfind+0xd>
  800f05:	c3                   	ret
  800f06:	48 89 f8             	mov    %rdi,%rax
  800f09:	c3                   	ret
  800f0a:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800f0d:	c3                   	ret

0000000000800f0e <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800f0e:	f3 0f 1e fa          	endbr64
  800f12:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800f15:	0f b6 37             	movzbl (%rdi),%esi
  800f18:	40 80 fe 20          	cmp    $0x20,%sil
  800f1c:	74 06                	je     800f24 <strtol+0x16>
  800f1e:	40 80 fe 09          	cmp    $0x9,%sil
  800f22:	75 13                	jne    800f37 <strtol+0x29>
  800f24:	48 83 c7 01          	add    $0x1,%rdi
  800f28:	0f b6 37             	movzbl (%rdi),%esi
  800f2b:	40 80 fe 20          	cmp    $0x20,%sil
  800f2f:	74 f3                	je     800f24 <strtol+0x16>
  800f31:	40 80 fe 09          	cmp    $0x9,%sil
  800f35:	74 ed                	je     800f24 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800f37:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800f3a:	83 e0 fd             	and    $0xfffffffd,%eax
  800f3d:	3c 01                	cmp    $0x1,%al
  800f3f:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f43:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  800f49:	75 0f                	jne    800f5a <strtol+0x4c>
  800f4b:	80 3f 30             	cmpb   $0x30,(%rdi)
  800f4e:	74 14                	je     800f64 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800f50:	85 d2                	test   %edx,%edx
  800f52:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f57:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  800f5a:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800f5f:	4c 63 ca             	movslq %edx,%r9
  800f62:	eb 36                	jmp    800f9a <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f64:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800f68:	74 0f                	je     800f79 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  800f6a:	85 d2                	test   %edx,%edx
  800f6c:	75 ec                	jne    800f5a <strtol+0x4c>
        s++;
  800f6e:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800f72:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  800f77:	eb e1                	jmp    800f5a <strtol+0x4c>
        s += 2;
  800f79:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f7d:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  800f82:	eb d6                	jmp    800f5a <strtol+0x4c>
            dig -= '0';
  800f84:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  800f87:	44 0f b6 c1          	movzbl %cl,%r8d
  800f8b:	41 39 d0             	cmp    %edx,%r8d
  800f8e:	7d 21                	jge    800fb1 <strtol+0xa3>
        val = val * base + dig;
  800f90:	49 0f af c1          	imul   %r9,%rax
  800f94:	0f b6 c9             	movzbl %cl,%ecx
  800f97:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  800f9a:	48 83 c7 01          	add    $0x1,%rdi
  800f9e:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  800fa2:	80 f9 39             	cmp    $0x39,%cl
  800fa5:	76 dd                	jbe    800f84 <strtol+0x76>
        else if (dig - 'a' < 27)
  800fa7:	80 f9 7b             	cmp    $0x7b,%cl
  800faa:	77 05                	ja     800fb1 <strtol+0xa3>
            dig -= 'a' - 10;
  800fac:	83 e9 57             	sub    $0x57,%ecx
  800faf:	eb d6                	jmp    800f87 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  800fb1:	4d 85 d2             	test   %r10,%r10
  800fb4:	74 03                	je     800fb9 <strtol+0xab>
  800fb6:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800fb9:	48 89 c2             	mov    %rax,%rdx
  800fbc:	48 f7 da             	neg    %rdx
  800fbf:	40 80 fe 2d          	cmp    $0x2d,%sil
  800fc3:	48 0f 44 c2          	cmove  %rdx,%rax
}
  800fc7:	c3                   	ret

0000000000800fc8 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800fc8:	f3 0f 1e fa          	endbr64
  800fcc:	55                   	push   %rbp
  800fcd:	48 89 e5             	mov    %rsp,%rbp
  800fd0:	53                   	push   %rbx
  800fd1:	48 89 fa             	mov    %rdi,%rdx
  800fd4:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800fd7:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fdc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fe6:	be 00 00 00 00       	mov    $0x0,%esi
  800feb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800ff1:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800ff3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800ff7:	c9                   	leave
  800ff8:	c3                   	ret

0000000000800ff9 <sys_cgetc>:

int
sys_cgetc(void) {
  800ff9:	f3 0f 1e fa          	endbr64
  800ffd:	55                   	push   %rbp
  800ffe:	48 89 e5             	mov    %rsp,%rbp
  801001:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801002:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801007:	ba 00 00 00 00       	mov    $0x0,%edx
  80100c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801011:	bb 00 00 00 00       	mov    $0x0,%ebx
  801016:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80101b:	be 00 00 00 00       	mov    $0x0,%esi
  801020:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801026:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801028:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80102c:	c9                   	leave
  80102d:	c3                   	ret

000000000080102e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80102e:	f3 0f 1e fa          	endbr64
  801032:	55                   	push   %rbp
  801033:	48 89 e5             	mov    %rsp,%rbp
  801036:	53                   	push   %rbx
  801037:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80103b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80103e:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801043:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801048:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801052:	be 00 00 00 00       	mov    $0x0,%esi
  801057:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80105d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80105f:	48 85 c0             	test   %rax,%rax
  801062:	7f 06                	jg     80106a <sys_env_destroy+0x3c>
}
  801064:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801068:	c9                   	leave
  801069:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80106a:	49 89 c0             	mov    %rax,%r8
  80106d:	b9 03 00 00 00       	mov    $0x3,%ecx
  801072:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  801079:	00 00 00 
  80107c:	be 26 00 00 00       	mov    $0x26,%esi
  801081:	48 bf 9e 31 80 00 00 	movabs $0x80319e,%rdi
  801088:	00 00 00 
  80108b:	b8 00 00 00 00       	mov    $0x0,%eax
  801090:	49 b9 98 2a 80 00 00 	movabs $0x802a98,%r9
  801097:	00 00 00 
  80109a:	41 ff d1             	call   *%r9

000000000080109d <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80109d:	f3 0f 1e fa          	endbr64
  8010a1:	55                   	push   %rbp
  8010a2:	48 89 e5             	mov    %rsp,%rbp
  8010a5:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010a6:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b0:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ba:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010bf:	be 00 00 00 00       	mov    $0x0,%esi
  8010c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010ca:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8010cc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010d0:	c9                   	leave
  8010d1:	c3                   	ret

00000000008010d2 <sys_yield>:

void
sys_yield(void) {
  8010d2:	f3 0f 1e fa          	endbr64
  8010d6:	55                   	push   %rbp
  8010d7:	48 89 e5             	mov    %rsp,%rbp
  8010da:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010db:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ef:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010f4:	be 00 00 00 00       	mov    $0x0,%esi
  8010f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010ff:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801101:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801105:	c9                   	leave
  801106:	c3                   	ret

0000000000801107 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801107:	f3 0f 1e fa          	endbr64
  80110b:	55                   	push   %rbp
  80110c:	48 89 e5             	mov    %rsp,%rbp
  80110f:	53                   	push   %rbx
  801110:	48 89 fa             	mov    %rdi,%rdx
  801113:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801116:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80111b:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801122:	00 00 00 
  801125:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80112a:	be 00 00 00 00       	mov    $0x0,%esi
  80112f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801135:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801137:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80113b:	c9                   	leave
  80113c:	c3                   	ret

000000000080113d <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80113d:	f3 0f 1e fa          	endbr64
  801141:	55                   	push   %rbp
  801142:	48 89 e5             	mov    %rsp,%rbp
  801145:	53                   	push   %rbx
  801146:	49 89 f8             	mov    %rdi,%r8
  801149:	48 89 d3             	mov    %rdx,%rbx
  80114c:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80114f:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801154:	4c 89 c2             	mov    %r8,%rdx
  801157:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80115a:	be 00 00 00 00       	mov    $0x0,%esi
  80115f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801165:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801167:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80116b:	c9                   	leave
  80116c:	c3                   	ret

000000000080116d <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80116d:	f3 0f 1e fa          	endbr64
  801171:	55                   	push   %rbp
  801172:	48 89 e5             	mov    %rsp,%rbp
  801175:	53                   	push   %rbx
  801176:	48 83 ec 08          	sub    $0x8,%rsp
  80117a:	89 f8                	mov    %edi,%eax
  80117c:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80117f:	48 63 f9             	movslq %ecx,%rdi
  801182:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801185:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80118a:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80118d:	be 00 00 00 00       	mov    $0x0,%esi
  801192:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801198:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80119a:	48 85 c0             	test   %rax,%rax
  80119d:	7f 06                	jg     8011a5 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  80119f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011a3:	c9                   	leave
  8011a4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011a5:	49 89 c0             	mov    %rax,%r8
  8011a8:	b9 04 00 00 00       	mov    $0x4,%ecx
  8011ad:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  8011b4:	00 00 00 
  8011b7:	be 26 00 00 00       	mov    $0x26,%esi
  8011bc:	48 bf 9e 31 80 00 00 	movabs $0x80319e,%rdi
  8011c3:	00 00 00 
  8011c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cb:	49 b9 98 2a 80 00 00 	movabs $0x802a98,%r9
  8011d2:	00 00 00 
  8011d5:	41 ff d1             	call   *%r9

00000000008011d8 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8011d8:	f3 0f 1e fa          	endbr64
  8011dc:	55                   	push   %rbp
  8011dd:	48 89 e5             	mov    %rsp,%rbp
  8011e0:	53                   	push   %rbx
  8011e1:	48 83 ec 08          	sub    $0x8,%rsp
  8011e5:	89 f8                	mov    %edi,%eax
  8011e7:	49 89 f2             	mov    %rsi,%r10
  8011ea:	48 89 cf             	mov    %rcx,%rdi
  8011ed:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8011f0:	48 63 da             	movslq %edx,%rbx
  8011f3:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011f6:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011fb:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011fe:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801201:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801203:	48 85 c0             	test   %rax,%rax
  801206:	7f 06                	jg     80120e <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801208:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80120c:	c9                   	leave
  80120d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80120e:	49 89 c0             	mov    %rax,%r8
  801211:	b9 05 00 00 00       	mov    $0x5,%ecx
  801216:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  80121d:	00 00 00 
  801220:	be 26 00 00 00       	mov    $0x26,%esi
  801225:	48 bf 9e 31 80 00 00 	movabs $0x80319e,%rdi
  80122c:	00 00 00 
  80122f:	b8 00 00 00 00       	mov    $0x0,%eax
  801234:	49 b9 98 2a 80 00 00 	movabs $0x802a98,%r9
  80123b:	00 00 00 
  80123e:	41 ff d1             	call   *%r9

0000000000801241 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801241:	f3 0f 1e fa          	endbr64
  801245:	55                   	push   %rbp
  801246:	48 89 e5             	mov    %rsp,%rbp
  801249:	53                   	push   %rbx
  80124a:	48 83 ec 08          	sub    $0x8,%rsp
  80124e:	49 89 f9             	mov    %rdi,%r9
  801251:	89 f0                	mov    %esi,%eax
  801253:	48 89 d3             	mov    %rdx,%rbx
  801256:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801259:	49 63 f0             	movslq %r8d,%rsi
  80125c:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80125f:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801264:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801267:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80126d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80126f:	48 85 c0             	test   %rax,%rax
  801272:	7f 06                	jg     80127a <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801274:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801278:	c9                   	leave
  801279:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80127a:	49 89 c0             	mov    %rax,%r8
  80127d:	b9 06 00 00 00       	mov    $0x6,%ecx
  801282:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  801289:	00 00 00 
  80128c:	be 26 00 00 00       	mov    $0x26,%esi
  801291:	48 bf 9e 31 80 00 00 	movabs $0x80319e,%rdi
  801298:	00 00 00 
  80129b:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a0:	49 b9 98 2a 80 00 00 	movabs $0x802a98,%r9
  8012a7:	00 00 00 
  8012aa:	41 ff d1             	call   *%r9

00000000008012ad <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8012ad:	f3 0f 1e fa          	endbr64
  8012b1:	55                   	push   %rbp
  8012b2:	48 89 e5             	mov    %rsp,%rbp
  8012b5:	53                   	push   %rbx
  8012b6:	48 83 ec 08          	sub    $0x8,%rsp
  8012ba:	48 89 f1             	mov    %rsi,%rcx
  8012bd:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8012c0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012c3:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012c8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012cd:	be 00 00 00 00       	mov    $0x0,%esi
  8012d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012d8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012da:	48 85 c0             	test   %rax,%rax
  8012dd:	7f 06                	jg     8012e5 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8012df:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012e3:	c9                   	leave
  8012e4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012e5:	49 89 c0             	mov    %rax,%r8
  8012e8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8012ed:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  8012f4:	00 00 00 
  8012f7:	be 26 00 00 00       	mov    $0x26,%esi
  8012fc:	48 bf 9e 31 80 00 00 	movabs $0x80319e,%rdi
  801303:	00 00 00 
  801306:	b8 00 00 00 00       	mov    $0x0,%eax
  80130b:	49 b9 98 2a 80 00 00 	movabs $0x802a98,%r9
  801312:	00 00 00 
  801315:	41 ff d1             	call   *%r9

0000000000801318 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801318:	f3 0f 1e fa          	endbr64
  80131c:	55                   	push   %rbp
  80131d:	48 89 e5             	mov    %rsp,%rbp
  801320:	53                   	push   %rbx
  801321:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801325:	48 63 ce             	movslq %esi,%rcx
  801328:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80132b:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801330:	bb 00 00 00 00       	mov    $0x0,%ebx
  801335:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80133a:	be 00 00 00 00       	mov    $0x0,%esi
  80133f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801345:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801347:	48 85 c0             	test   %rax,%rax
  80134a:	7f 06                	jg     801352 <sys_env_set_status+0x3a>
}
  80134c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801350:	c9                   	leave
  801351:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801352:	49 89 c0             	mov    %rax,%r8
  801355:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80135a:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  801361:	00 00 00 
  801364:	be 26 00 00 00       	mov    $0x26,%esi
  801369:	48 bf 9e 31 80 00 00 	movabs $0x80319e,%rdi
  801370:	00 00 00 
  801373:	b8 00 00 00 00       	mov    $0x0,%eax
  801378:	49 b9 98 2a 80 00 00 	movabs $0x802a98,%r9
  80137f:	00 00 00 
  801382:	41 ff d1             	call   *%r9

0000000000801385 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801385:	f3 0f 1e fa          	endbr64
  801389:	55                   	push   %rbp
  80138a:	48 89 e5             	mov    %rsp,%rbp
  80138d:	53                   	push   %rbx
  80138e:	48 83 ec 08          	sub    $0x8,%rsp
  801392:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801395:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801398:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80139d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013a7:	be 00 00 00 00       	mov    $0x0,%esi
  8013ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013b2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013b4:	48 85 c0             	test   %rax,%rax
  8013b7:	7f 06                	jg     8013bf <sys_env_set_trapframe+0x3a>
}
  8013b9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013bd:	c9                   	leave
  8013be:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013bf:	49 89 c0             	mov    %rax,%r8
  8013c2:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8013c7:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  8013ce:	00 00 00 
  8013d1:	be 26 00 00 00       	mov    $0x26,%esi
  8013d6:	48 bf 9e 31 80 00 00 	movabs $0x80319e,%rdi
  8013dd:	00 00 00 
  8013e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e5:	49 b9 98 2a 80 00 00 	movabs $0x802a98,%r9
  8013ec:	00 00 00 
  8013ef:	41 ff d1             	call   *%r9

00000000008013f2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8013f2:	f3 0f 1e fa          	endbr64
  8013f6:	55                   	push   %rbp
  8013f7:	48 89 e5             	mov    %rsp,%rbp
  8013fa:	53                   	push   %rbx
  8013fb:	48 83 ec 08          	sub    $0x8,%rsp
  8013ff:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801402:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801405:	b8 0c 00 00 00       	mov    $0xc,%eax
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
  801424:	7f 06                	jg     80142c <sys_env_set_pgfault_upcall+0x3a>
}
  801426:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80142a:	c9                   	leave
  80142b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80142c:	49 89 c0             	mov    %rax,%r8
  80142f:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801434:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  80143b:	00 00 00 
  80143e:	be 26 00 00 00       	mov    $0x26,%esi
  801443:	48 bf 9e 31 80 00 00 	movabs $0x80319e,%rdi
  80144a:	00 00 00 
  80144d:	b8 00 00 00 00       	mov    $0x0,%eax
  801452:	49 b9 98 2a 80 00 00 	movabs $0x802a98,%r9
  801459:	00 00 00 
  80145c:	41 ff d1             	call   *%r9

000000000080145f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80145f:	f3 0f 1e fa          	endbr64
  801463:	55                   	push   %rbp
  801464:	48 89 e5             	mov    %rsp,%rbp
  801467:	53                   	push   %rbx
  801468:	89 f8                	mov    %edi,%eax
  80146a:	49 89 f1             	mov    %rsi,%r9
  80146d:	48 89 d3             	mov    %rdx,%rbx
  801470:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801473:	49 63 f0             	movslq %r8d,%rsi
  801476:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801479:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80147e:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801481:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801487:	cd 30                	int    $0x30
}
  801489:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80148d:	c9                   	leave
  80148e:	c3                   	ret

000000000080148f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80148f:	f3 0f 1e fa          	endbr64
  801493:	55                   	push   %rbp
  801494:	48 89 e5             	mov    %rsp,%rbp
  801497:	53                   	push   %rbx
  801498:	48 83 ec 08          	sub    $0x8,%rsp
  80149c:	48 89 fa             	mov    %rdi,%rdx
  80149f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8014a2:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014ac:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014b1:	be 00 00 00 00       	mov    $0x0,%esi
  8014b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014bc:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014be:	48 85 c0             	test   %rax,%rax
  8014c1:	7f 06                	jg     8014c9 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8014c3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014c7:	c9                   	leave
  8014c8:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014c9:	49 89 c0             	mov    %rax,%r8
  8014cc:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8014d1:	48 ba e0 35 80 00 00 	movabs $0x8035e0,%rdx
  8014d8:	00 00 00 
  8014db:	be 26 00 00 00       	mov    $0x26,%esi
  8014e0:	48 bf 9e 31 80 00 00 	movabs $0x80319e,%rdi
  8014e7:	00 00 00 
  8014ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ef:	49 b9 98 2a 80 00 00 	movabs $0x802a98,%r9
  8014f6:	00 00 00 
  8014f9:	41 ff d1             	call   *%r9

00000000008014fc <sys_gettime>:

int
sys_gettime(void) {
  8014fc:	f3 0f 1e fa          	endbr64
  801500:	55                   	push   %rbp
  801501:	48 89 e5             	mov    %rsp,%rbp
  801504:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801505:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80150a:	ba 00 00 00 00       	mov    $0x0,%edx
  80150f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801514:	bb 00 00 00 00       	mov    $0x0,%ebx
  801519:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80151e:	be 00 00 00 00       	mov    $0x0,%esi
  801523:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801529:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80152b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80152f:	c9                   	leave
  801530:	c3                   	ret

0000000000801531 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801531:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801535:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80153c:	ff ff ff 
  80153f:	48 01 f8             	add    %rdi,%rax
  801542:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801546:	c3                   	ret

0000000000801547 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801547:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80154b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801552:	ff ff ff 
  801555:	48 01 f8             	add    %rdi,%rax
  801558:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80155c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801562:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801566:	c3                   	ret

0000000000801567 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801567:	f3 0f 1e fa          	endbr64
  80156b:	55                   	push   %rbp
  80156c:	48 89 e5             	mov    %rsp,%rbp
  80156f:	41 57                	push   %r15
  801571:	41 56                	push   %r14
  801573:	41 55                	push   %r13
  801575:	41 54                	push   %r12
  801577:	53                   	push   %rbx
  801578:	48 83 ec 08          	sub    $0x8,%rsp
  80157c:	49 89 ff             	mov    %rdi,%r15
  80157f:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801584:	49 bd c6 26 80 00 00 	movabs $0x8026c6,%r13
  80158b:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80158e:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801594:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801597:	48 89 df             	mov    %rbx,%rdi
  80159a:	41 ff d5             	call   *%r13
  80159d:	83 e0 04             	and    $0x4,%eax
  8015a0:	74 17                	je     8015b9 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8015a2:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8015a9:	4c 39 f3             	cmp    %r14,%rbx
  8015ac:	75 e6                	jne    801594 <fd_alloc+0x2d>
  8015ae:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8015b4:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8015b9:	4d 89 27             	mov    %r12,(%r15)
}
  8015bc:	48 83 c4 08          	add    $0x8,%rsp
  8015c0:	5b                   	pop    %rbx
  8015c1:	41 5c                	pop    %r12
  8015c3:	41 5d                	pop    %r13
  8015c5:	41 5e                	pop    %r14
  8015c7:	41 5f                	pop    %r15
  8015c9:	5d                   	pop    %rbp
  8015ca:	c3                   	ret

00000000008015cb <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8015cb:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8015cf:	83 ff 1f             	cmp    $0x1f,%edi
  8015d2:	77 39                	ja     80160d <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8015d4:	55                   	push   %rbp
  8015d5:	48 89 e5             	mov    %rsp,%rbp
  8015d8:	41 54                	push   %r12
  8015da:	53                   	push   %rbx
  8015db:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8015de:	48 63 df             	movslq %edi,%rbx
  8015e1:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8015e8:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8015ec:	48 89 df             	mov    %rbx,%rdi
  8015ef:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  8015f6:	00 00 00 
  8015f9:	ff d0                	call   *%rax
  8015fb:	a8 04                	test   $0x4,%al
  8015fd:	74 14                	je     801613 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8015ff:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801603:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801608:	5b                   	pop    %rbx
  801609:	41 5c                	pop    %r12
  80160b:	5d                   	pop    %rbp
  80160c:	c3                   	ret
        return -E_INVAL;
  80160d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801612:	c3                   	ret
        return -E_INVAL;
  801613:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801618:	eb ee                	jmp    801608 <fd_lookup+0x3d>

000000000080161a <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  80161a:	f3 0f 1e fa          	endbr64
  80161e:	55                   	push   %rbp
  80161f:	48 89 e5             	mov    %rsp,%rbp
  801622:	41 54                	push   %r12
  801624:	53                   	push   %rbx
  801625:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801628:	48 b8 a0 36 80 00 00 	movabs $0x8036a0,%rax
  80162f:	00 00 00 
  801632:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  801639:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  80163c:	39 3b                	cmp    %edi,(%rbx)
  80163e:	74 47                	je     801687 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801640:	48 83 c0 08          	add    $0x8,%rax
  801644:	48 8b 18             	mov    (%rax),%rbx
  801647:	48 85 db             	test   %rbx,%rbx
  80164a:	75 f0                	jne    80163c <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80164c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801653:	00 00 00 
  801656:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80165c:	89 fa                	mov    %edi,%edx
  80165e:	48 bf 00 36 80 00 00 	movabs $0x803600,%rdi
  801665:	00 00 00 
  801668:	b8 00 00 00 00       	mov    $0x0,%eax
  80166d:	48 b9 1f 02 80 00 00 	movabs $0x80021f,%rcx
  801674:	00 00 00 
  801677:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801679:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  80167e:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801682:	5b                   	pop    %rbx
  801683:	41 5c                	pop    %r12
  801685:	5d                   	pop    %rbp
  801686:	c3                   	ret
            return 0;
  801687:	b8 00 00 00 00       	mov    $0x0,%eax
  80168c:	eb f0                	jmp    80167e <dev_lookup+0x64>

000000000080168e <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80168e:	f3 0f 1e fa          	endbr64
  801692:	55                   	push   %rbp
  801693:	48 89 e5             	mov    %rsp,%rbp
  801696:	41 55                	push   %r13
  801698:	41 54                	push   %r12
  80169a:	53                   	push   %rbx
  80169b:	48 83 ec 18          	sub    $0x18,%rsp
  80169f:	48 89 fb             	mov    %rdi,%rbx
  8016a2:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8016a5:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8016ac:	ff ff ff 
  8016af:	48 01 df             	add    %rbx,%rdi
  8016b2:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8016b6:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8016ba:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  8016c1:	00 00 00 
  8016c4:	ff d0                	call   *%rax
  8016c6:	41 89 c5             	mov    %eax,%r13d
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	78 06                	js     8016d3 <fd_close+0x45>
  8016cd:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  8016d1:	74 1a                	je     8016ed <fd_close+0x5f>
        return (must_exist ? res : 0);
  8016d3:	45 84 e4             	test   %r12b,%r12b
  8016d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016db:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8016df:	44 89 e8             	mov    %r13d,%eax
  8016e2:	48 83 c4 18          	add    $0x18,%rsp
  8016e6:	5b                   	pop    %rbx
  8016e7:	41 5c                	pop    %r12
  8016e9:	41 5d                	pop    %r13
  8016eb:	5d                   	pop    %rbp
  8016ec:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016ed:	8b 3b                	mov    (%rbx),%edi
  8016ef:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8016f3:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  8016fa:	00 00 00 
  8016fd:	ff d0                	call   *%rax
  8016ff:	41 89 c5             	mov    %eax,%r13d
  801702:	85 c0                	test   %eax,%eax
  801704:	78 1b                	js     801721 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801706:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80170a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80170e:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801714:	48 85 c0             	test   %rax,%rax
  801717:	74 08                	je     801721 <fd_close+0x93>
  801719:	48 89 df             	mov    %rbx,%rdi
  80171c:	ff d0                	call   *%rax
  80171e:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801721:	ba 00 10 00 00       	mov    $0x1000,%edx
  801726:	48 89 de             	mov    %rbx,%rsi
  801729:	bf 00 00 00 00       	mov    $0x0,%edi
  80172e:	48 b8 ad 12 80 00 00 	movabs $0x8012ad,%rax
  801735:	00 00 00 
  801738:	ff d0                	call   *%rax
    return res;
  80173a:	eb a3                	jmp    8016df <fd_close+0x51>

000000000080173c <close>:

int
close(int fdnum) {
  80173c:	f3 0f 1e fa          	endbr64
  801740:	55                   	push   %rbp
  801741:	48 89 e5             	mov    %rsp,%rbp
  801744:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801748:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80174c:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  801753:	00 00 00 
  801756:	ff d0                	call   *%rax
    if (res < 0) return res;
  801758:	85 c0                	test   %eax,%eax
  80175a:	78 15                	js     801771 <close+0x35>

    return fd_close(fd, 1);
  80175c:	be 01 00 00 00       	mov    $0x1,%esi
  801761:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801765:	48 b8 8e 16 80 00 00 	movabs $0x80168e,%rax
  80176c:	00 00 00 
  80176f:	ff d0                	call   *%rax
}
  801771:	c9                   	leave
  801772:	c3                   	ret

0000000000801773 <close_all>:

void
close_all(void) {
  801773:	f3 0f 1e fa          	endbr64
  801777:	55                   	push   %rbp
  801778:	48 89 e5             	mov    %rsp,%rbp
  80177b:	41 54                	push   %r12
  80177d:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80177e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801783:	49 bc 3c 17 80 00 00 	movabs $0x80173c,%r12
  80178a:	00 00 00 
  80178d:	89 df                	mov    %ebx,%edi
  80178f:	41 ff d4             	call   *%r12
  801792:	83 c3 01             	add    $0x1,%ebx
  801795:	83 fb 20             	cmp    $0x20,%ebx
  801798:	75 f3                	jne    80178d <close_all+0x1a>
}
  80179a:	5b                   	pop    %rbx
  80179b:	41 5c                	pop    %r12
  80179d:	5d                   	pop    %rbp
  80179e:	c3                   	ret

000000000080179f <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80179f:	f3 0f 1e fa          	endbr64
  8017a3:	55                   	push   %rbp
  8017a4:	48 89 e5             	mov    %rsp,%rbp
  8017a7:	41 57                	push   %r15
  8017a9:	41 56                	push   %r14
  8017ab:	41 55                	push   %r13
  8017ad:	41 54                	push   %r12
  8017af:	53                   	push   %rbx
  8017b0:	48 83 ec 18          	sub    $0x18,%rsp
  8017b4:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8017b7:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8017bb:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  8017c2:	00 00 00 
  8017c5:	ff d0                	call   *%rax
  8017c7:	89 c3                	mov    %eax,%ebx
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	0f 88 b8 00 00 00    	js     801889 <dup+0xea>
    close(newfdnum);
  8017d1:	44 89 e7             	mov    %r12d,%edi
  8017d4:	48 b8 3c 17 80 00 00 	movabs $0x80173c,%rax
  8017db:	00 00 00 
  8017de:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8017e0:	4d 63 ec             	movslq %r12d,%r13
  8017e3:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8017ea:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8017ee:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8017f2:	4c 89 ff             	mov    %r15,%rdi
  8017f5:	49 be 47 15 80 00 00 	movabs $0x801547,%r14
  8017fc:	00 00 00 
  8017ff:	41 ff d6             	call   *%r14
  801802:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801805:	4c 89 ef             	mov    %r13,%rdi
  801808:	41 ff d6             	call   *%r14
  80180b:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  80180e:	48 89 df             	mov    %rbx,%rdi
  801811:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  801818:	00 00 00 
  80181b:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  80181d:	a8 04                	test   $0x4,%al
  80181f:	74 2b                	je     80184c <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801821:	41 89 c1             	mov    %eax,%r9d
  801824:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80182a:	4c 89 f1             	mov    %r14,%rcx
  80182d:	ba 00 00 00 00       	mov    $0x0,%edx
  801832:	48 89 de             	mov    %rbx,%rsi
  801835:	bf 00 00 00 00       	mov    $0x0,%edi
  80183a:	48 b8 d8 11 80 00 00 	movabs $0x8011d8,%rax
  801841:	00 00 00 
  801844:	ff d0                	call   *%rax
  801846:	89 c3                	mov    %eax,%ebx
  801848:	85 c0                	test   %eax,%eax
  80184a:	78 4e                	js     80189a <dup+0xfb>
    }
    prot = get_prot(oldfd);
  80184c:	4c 89 ff             	mov    %r15,%rdi
  80184f:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  801856:	00 00 00 
  801859:	ff d0                	call   *%rax
  80185b:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  80185e:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801864:	4c 89 e9             	mov    %r13,%rcx
  801867:	ba 00 00 00 00       	mov    $0x0,%edx
  80186c:	4c 89 fe             	mov    %r15,%rsi
  80186f:	bf 00 00 00 00       	mov    $0x0,%edi
  801874:	48 b8 d8 11 80 00 00 	movabs $0x8011d8,%rax
  80187b:	00 00 00 
  80187e:	ff d0                	call   *%rax
  801880:	89 c3                	mov    %eax,%ebx
  801882:	85 c0                	test   %eax,%eax
  801884:	78 14                	js     80189a <dup+0xfb>

    return newfdnum;
  801886:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801889:	89 d8                	mov    %ebx,%eax
  80188b:	48 83 c4 18          	add    $0x18,%rsp
  80188f:	5b                   	pop    %rbx
  801890:	41 5c                	pop    %r12
  801892:	41 5d                	pop    %r13
  801894:	41 5e                	pop    %r14
  801896:	41 5f                	pop    %r15
  801898:	5d                   	pop    %rbp
  801899:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80189a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80189f:	4c 89 ee             	mov    %r13,%rsi
  8018a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a7:	49 bc ad 12 80 00 00 	movabs $0x8012ad,%r12
  8018ae:	00 00 00 
  8018b1:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8018b4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8018b9:	4c 89 f6             	mov    %r14,%rsi
  8018bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8018c1:	41 ff d4             	call   *%r12
    return res;
  8018c4:	eb c3                	jmp    801889 <dup+0xea>

00000000008018c6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8018c6:	f3 0f 1e fa          	endbr64
  8018ca:	55                   	push   %rbp
  8018cb:	48 89 e5             	mov    %rsp,%rbp
  8018ce:	41 56                	push   %r14
  8018d0:	41 55                	push   %r13
  8018d2:	41 54                	push   %r12
  8018d4:	53                   	push   %rbx
  8018d5:	48 83 ec 10          	sub    $0x10,%rsp
  8018d9:	89 fb                	mov    %edi,%ebx
  8018db:	49 89 f4             	mov    %rsi,%r12
  8018de:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8018e1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018e5:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  8018ec:	00 00 00 
  8018ef:	ff d0                	call   *%rax
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	78 4c                	js     801941 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8018f5:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8018f9:	41 8b 3e             	mov    (%r14),%edi
  8018fc:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801900:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  801907:	00 00 00 
  80190a:	ff d0                	call   *%rax
  80190c:	85 c0                	test   %eax,%eax
  80190e:	78 35                	js     801945 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801910:	41 8b 46 08          	mov    0x8(%r14),%eax
  801914:	83 e0 03             	and    $0x3,%eax
  801917:	83 f8 01             	cmp    $0x1,%eax
  80191a:	74 2d                	je     801949 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  80191c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801920:	48 8b 40 10          	mov    0x10(%rax),%rax
  801924:	48 85 c0             	test   %rax,%rax
  801927:	74 56                	je     80197f <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801929:	4c 89 ea             	mov    %r13,%rdx
  80192c:	4c 89 e6             	mov    %r12,%rsi
  80192f:	4c 89 f7             	mov    %r14,%rdi
  801932:	ff d0                	call   *%rax
}
  801934:	48 83 c4 10          	add    $0x10,%rsp
  801938:	5b                   	pop    %rbx
  801939:	41 5c                	pop    %r12
  80193b:	41 5d                	pop    %r13
  80193d:	41 5e                	pop    %r14
  80193f:	5d                   	pop    %rbp
  801940:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801941:	48 98                	cltq
  801943:	eb ef                	jmp    801934 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801945:	48 98                	cltq
  801947:	eb eb                	jmp    801934 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801949:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801950:	00 00 00 
  801953:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801959:	89 da                	mov    %ebx,%edx
  80195b:	48 bf ac 31 80 00 00 	movabs $0x8031ac,%rdi
  801962:	00 00 00 
  801965:	b8 00 00 00 00       	mov    $0x0,%eax
  80196a:	48 b9 1f 02 80 00 00 	movabs $0x80021f,%rcx
  801971:	00 00 00 
  801974:	ff d1                	call   *%rcx
        return -E_INVAL;
  801976:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80197d:	eb b5                	jmp    801934 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  80197f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801986:	eb ac                	jmp    801934 <read+0x6e>

0000000000801988 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801988:	f3 0f 1e fa          	endbr64
  80198c:	55                   	push   %rbp
  80198d:	48 89 e5             	mov    %rsp,%rbp
  801990:	41 57                	push   %r15
  801992:	41 56                	push   %r14
  801994:	41 55                	push   %r13
  801996:	41 54                	push   %r12
  801998:	53                   	push   %rbx
  801999:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  80199d:	48 85 d2             	test   %rdx,%rdx
  8019a0:	74 54                	je     8019f6 <readn+0x6e>
  8019a2:	41 89 fd             	mov    %edi,%r13d
  8019a5:	49 89 f6             	mov    %rsi,%r14
  8019a8:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  8019ab:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  8019b0:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  8019b5:	49 bf c6 18 80 00 00 	movabs $0x8018c6,%r15
  8019bc:	00 00 00 
  8019bf:	4c 89 e2             	mov    %r12,%rdx
  8019c2:	48 29 f2             	sub    %rsi,%rdx
  8019c5:	4c 01 f6             	add    %r14,%rsi
  8019c8:	44 89 ef             	mov    %r13d,%edi
  8019cb:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	78 20                	js     8019f2 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  8019d2:	01 c3                	add    %eax,%ebx
  8019d4:	85 c0                	test   %eax,%eax
  8019d6:	74 08                	je     8019e0 <readn+0x58>
  8019d8:	48 63 f3             	movslq %ebx,%rsi
  8019db:	4c 39 e6             	cmp    %r12,%rsi
  8019de:	72 df                	jb     8019bf <readn+0x37>
    }
    return res;
  8019e0:	48 63 c3             	movslq %ebx,%rax
}
  8019e3:	48 83 c4 08          	add    $0x8,%rsp
  8019e7:	5b                   	pop    %rbx
  8019e8:	41 5c                	pop    %r12
  8019ea:	41 5d                	pop    %r13
  8019ec:	41 5e                	pop    %r14
  8019ee:	41 5f                	pop    %r15
  8019f0:	5d                   	pop    %rbp
  8019f1:	c3                   	ret
        if (inc < 0) return inc;
  8019f2:	48 98                	cltq
  8019f4:	eb ed                	jmp    8019e3 <readn+0x5b>
    int inc = 1, res = 0;
  8019f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019fb:	eb e3                	jmp    8019e0 <readn+0x58>

00000000008019fd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8019fd:	f3 0f 1e fa          	endbr64
  801a01:	55                   	push   %rbp
  801a02:	48 89 e5             	mov    %rsp,%rbp
  801a05:	41 56                	push   %r14
  801a07:	41 55                	push   %r13
  801a09:	41 54                	push   %r12
  801a0b:	53                   	push   %rbx
  801a0c:	48 83 ec 10          	sub    $0x10,%rsp
  801a10:	89 fb                	mov    %edi,%ebx
  801a12:	49 89 f4             	mov    %rsi,%r12
  801a15:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a18:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a1c:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	call   *%rax
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	78 47                	js     801a73 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a2c:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801a30:	41 8b 3e             	mov    (%r14),%edi
  801a33:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a37:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  801a3e:	00 00 00 
  801a41:	ff d0                	call   *%rax
  801a43:	85 c0                	test   %eax,%eax
  801a45:	78 30                	js     801a77 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a47:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801a4c:	74 2d                	je     801a7b <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801a4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a52:	48 8b 40 18          	mov    0x18(%rax),%rax
  801a56:	48 85 c0             	test   %rax,%rax
  801a59:	74 56                	je     801ab1 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801a5b:	4c 89 ea             	mov    %r13,%rdx
  801a5e:	4c 89 e6             	mov    %r12,%rsi
  801a61:	4c 89 f7             	mov    %r14,%rdi
  801a64:	ff d0                	call   *%rax
}
  801a66:	48 83 c4 10          	add    $0x10,%rsp
  801a6a:	5b                   	pop    %rbx
  801a6b:	41 5c                	pop    %r12
  801a6d:	41 5d                	pop    %r13
  801a6f:	41 5e                	pop    %r14
  801a71:	5d                   	pop    %rbp
  801a72:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a73:	48 98                	cltq
  801a75:	eb ef                	jmp    801a66 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a77:	48 98                	cltq
  801a79:	eb eb                	jmp    801a66 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a7b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a82:	00 00 00 
  801a85:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a8b:	89 da                	mov    %ebx,%edx
  801a8d:	48 bf c8 31 80 00 00 	movabs $0x8031c8,%rdi
  801a94:	00 00 00 
  801a97:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9c:	48 b9 1f 02 80 00 00 	movabs $0x80021f,%rcx
  801aa3:	00 00 00 
  801aa6:	ff d1                	call   *%rcx
        return -E_INVAL;
  801aa8:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801aaf:	eb b5                	jmp    801a66 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801ab1:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801ab8:	eb ac                	jmp    801a66 <write+0x69>

0000000000801aba <seek>:

int
seek(int fdnum, off_t offset) {
  801aba:	f3 0f 1e fa          	endbr64
  801abe:	55                   	push   %rbp
  801abf:	48 89 e5             	mov    %rsp,%rbp
  801ac2:	53                   	push   %rbx
  801ac3:	48 83 ec 18          	sub    $0x18,%rsp
  801ac7:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ac9:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801acd:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  801ad4:	00 00 00 
  801ad7:	ff d0                	call   *%rax
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	78 0c                	js     801ae9 <seek+0x2f>

    fd->fd_offset = offset;
  801add:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ae1:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ae4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801aed:	c9                   	leave
  801aee:	c3                   	ret

0000000000801aef <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801aef:	f3 0f 1e fa          	endbr64
  801af3:	55                   	push   %rbp
  801af4:	48 89 e5             	mov    %rsp,%rbp
  801af7:	41 55                	push   %r13
  801af9:	41 54                	push   %r12
  801afb:	53                   	push   %rbx
  801afc:	48 83 ec 18          	sub    $0x18,%rsp
  801b00:	89 fb                	mov    %edi,%ebx
  801b02:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b05:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b09:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  801b10:	00 00 00 
  801b13:	ff d0                	call   *%rax
  801b15:	85 c0                	test   %eax,%eax
  801b17:	78 38                	js     801b51 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b19:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801b1d:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801b21:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b25:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  801b2c:	00 00 00 
  801b2f:	ff d0                	call   *%rax
  801b31:	85 c0                	test   %eax,%eax
  801b33:	78 1c                	js     801b51 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b35:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801b3a:	74 20                	je     801b5c <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801b3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b40:	48 8b 40 30          	mov    0x30(%rax),%rax
  801b44:	48 85 c0             	test   %rax,%rax
  801b47:	74 47                	je     801b90 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801b49:	44 89 e6             	mov    %r12d,%esi
  801b4c:	4c 89 ef             	mov    %r13,%rdi
  801b4f:	ff d0                	call   *%rax
}
  801b51:	48 83 c4 18          	add    $0x18,%rsp
  801b55:	5b                   	pop    %rbx
  801b56:	41 5c                	pop    %r12
  801b58:	41 5d                	pop    %r13
  801b5a:	5d                   	pop    %rbp
  801b5b:	c3                   	ret
                thisenv->env_id, fdnum);
  801b5c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b63:	00 00 00 
  801b66:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b6c:	89 da                	mov    %ebx,%edx
  801b6e:	48 bf 20 36 80 00 00 	movabs $0x803620,%rdi
  801b75:	00 00 00 
  801b78:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7d:	48 b9 1f 02 80 00 00 	movabs $0x80021f,%rcx
  801b84:	00 00 00 
  801b87:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b8e:	eb c1                	jmp    801b51 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801b90:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801b95:	eb ba                	jmp    801b51 <ftruncate+0x62>

0000000000801b97 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801b97:	f3 0f 1e fa          	endbr64
  801b9b:	55                   	push   %rbp
  801b9c:	48 89 e5             	mov    %rsp,%rbp
  801b9f:	41 54                	push   %r12
  801ba1:	53                   	push   %rbx
  801ba2:	48 83 ec 10          	sub    $0x10,%rsp
  801ba6:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ba9:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801bad:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  801bb4:	00 00 00 
  801bb7:	ff d0                	call   *%rax
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	78 4e                	js     801c0b <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801bbd:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801bc1:	41 8b 3c 24          	mov    (%r12),%edi
  801bc5:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801bc9:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  801bd0:	00 00 00 
  801bd3:	ff d0                	call   *%rax
  801bd5:	85 c0                	test   %eax,%eax
  801bd7:	78 32                	js     801c0b <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801bd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bdd:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801be2:	74 30                	je     801c14 <fstat+0x7d>

    stat->st_name[0] = 0;
  801be4:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801be7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801bee:	00 00 00 
    stat->st_isdir = 0;
  801bf1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801bf8:	00 00 00 
    stat->st_dev = dev;
  801bfb:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801c02:	48 89 de             	mov    %rbx,%rsi
  801c05:	4c 89 e7             	mov    %r12,%rdi
  801c08:	ff 50 28             	call   *0x28(%rax)
}
  801c0b:	48 83 c4 10          	add    $0x10,%rsp
  801c0f:	5b                   	pop    %rbx
  801c10:	41 5c                	pop    %r12
  801c12:	5d                   	pop    %rbp
  801c13:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801c14:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801c19:	eb f0                	jmp    801c0b <fstat+0x74>

0000000000801c1b <stat>:

int
stat(const char *path, struct Stat *stat) {
  801c1b:	f3 0f 1e fa          	endbr64
  801c1f:	55                   	push   %rbp
  801c20:	48 89 e5             	mov    %rsp,%rbp
  801c23:	41 54                	push   %r12
  801c25:	53                   	push   %rbx
  801c26:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801c29:	be 00 00 00 00       	mov    $0x0,%esi
  801c2e:	48 b8 fc 1e 80 00 00 	movabs $0x801efc,%rax
  801c35:	00 00 00 
  801c38:	ff d0                	call   *%rax
  801c3a:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	78 25                	js     801c65 <stat+0x4a>

    int res = fstat(fd, stat);
  801c40:	4c 89 e6             	mov    %r12,%rsi
  801c43:	89 c7                	mov    %eax,%edi
  801c45:	48 b8 97 1b 80 00 00 	movabs $0x801b97,%rax
  801c4c:	00 00 00 
  801c4f:	ff d0                	call   *%rax
  801c51:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801c54:	89 df                	mov    %ebx,%edi
  801c56:	48 b8 3c 17 80 00 00 	movabs $0x80173c,%rax
  801c5d:	00 00 00 
  801c60:	ff d0                	call   *%rax

    return res;
  801c62:	44 89 e3             	mov    %r12d,%ebx
}
  801c65:	89 d8                	mov    %ebx,%eax
  801c67:	5b                   	pop    %rbx
  801c68:	41 5c                	pop    %r12
  801c6a:	5d                   	pop    %rbp
  801c6b:	c3                   	ret

0000000000801c6c <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801c6c:	f3 0f 1e fa          	endbr64
  801c70:	55                   	push   %rbp
  801c71:	48 89 e5             	mov    %rsp,%rbp
  801c74:	41 54                	push   %r12
  801c76:	53                   	push   %rbx
  801c77:	48 83 ec 10          	sub    $0x10,%rsp
  801c7b:	41 89 fc             	mov    %edi,%r12d
  801c7e:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801c81:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c88:	00 00 00 
  801c8b:	83 38 00             	cmpl   $0x0,(%rax)
  801c8e:	74 6e                	je     801cfe <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801c90:	bf 03 00 00 00       	mov    $0x3,%edi
  801c95:	48 b8 9a 2c 80 00 00 	movabs $0x802c9a,%rax
  801c9c:	00 00 00 
  801c9f:	ff d0                	call   *%rax
  801ca1:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801ca8:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801caa:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801cb0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801cb5:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801cbc:	00 00 00 
  801cbf:	44 89 e6             	mov    %r12d,%esi
  801cc2:	89 c7                	mov    %eax,%edi
  801cc4:	48 b8 d8 2b 80 00 00 	movabs $0x802bd8,%rax
  801ccb:	00 00 00 
  801cce:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801cd0:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801cd7:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801cd8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cdd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ce1:	48 89 de             	mov    %rbx,%rsi
  801ce4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ce9:	48 b8 3f 2b 80 00 00 	movabs $0x802b3f,%rax
  801cf0:	00 00 00 
  801cf3:	ff d0                	call   *%rax
}
  801cf5:	48 83 c4 10          	add    $0x10,%rsp
  801cf9:	5b                   	pop    %rbx
  801cfa:	41 5c                	pop    %r12
  801cfc:	5d                   	pop    %rbp
  801cfd:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801cfe:	bf 03 00 00 00       	mov    $0x3,%edi
  801d03:	48 b8 9a 2c 80 00 00 	movabs $0x802c9a,%rax
  801d0a:	00 00 00 
  801d0d:	ff d0                	call   *%rax
  801d0f:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801d16:	00 00 
  801d18:	e9 73 ff ff ff       	jmp    801c90 <fsipc+0x24>

0000000000801d1d <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801d1d:	f3 0f 1e fa          	endbr64
  801d21:	55                   	push   %rbp
  801d22:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d25:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801d2c:	00 00 00 
  801d2f:	8b 57 0c             	mov    0xc(%rdi),%edx
  801d32:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801d34:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801d37:	be 00 00 00 00       	mov    $0x0,%esi
  801d3c:	bf 02 00 00 00       	mov    $0x2,%edi
  801d41:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  801d48:	00 00 00 
  801d4b:	ff d0                	call   *%rax
}
  801d4d:	5d                   	pop    %rbp
  801d4e:	c3                   	ret

0000000000801d4f <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801d4f:	f3 0f 1e fa          	endbr64
  801d53:	55                   	push   %rbp
  801d54:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d57:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d5a:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d61:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801d63:	be 00 00 00 00       	mov    $0x0,%esi
  801d68:	bf 06 00 00 00       	mov    $0x6,%edi
  801d6d:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  801d74:	00 00 00 
  801d77:	ff d0                	call   *%rax
}
  801d79:	5d                   	pop    %rbp
  801d7a:	c3                   	ret

0000000000801d7b <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801d7b:	f3 0f 1e fa          	endbr64
  801d7f:	55                   	push   %rbp
  801d80:	48 89 e5             	mov    %rsp,%rbp
  801d83:	41 54                	push   %r12
  801d85:	53                   	push   %rbx
  801d86:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d89:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d8c:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d93:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801d95:	be 00 00 00 00       	mov    $0x0,%esi
  801d9a:	bf 05 00 00 00       	mov    $0x5,%edi
  801d9f:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  801da6:	00 00 00 
  801da9:	ff d0                	call   *%rax
    if (res < 0) return res;
  801dab:	85 c0                	test   %eax,%eax
  801dad:	78 3d                	js     801dec <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801daf:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  801db6:	00 00 00 
  801db9:	4c 89 e6             	mov    %r12,%rsi
  801dbc:	48 89 df             	mov    %rbx,%rdi
  801dbf:	48 b8 68 0b 80 00 00 	movabs $0x800b68,%rax
  801dc6:	00 00 00 
  801dc9:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801dcb:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801dd2:	00 
  801dd3:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dd9:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801de0:	00 
  801de1:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dec:	5b                   	pop    %rbx
  801ded:	41 5c                	pop    %r12
  801def:	5d                   	pop    %rbp
  801df0:	c3                   	ret

0000000000801df1 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801df1:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801df5:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801dfc:	77 41                	ja     801e3f <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801dfe:	55                   	push   %rbp
  801dff:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e02:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e09:	00 00 00 
  801e0c:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801e0f:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  801e11:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801e15:	48 8d 78 10          	lea    0x10(%rax),%rdi
  801e19:	48 b8 83 0d 80 00 00 	movabs $0x800d83,%rax
  801e20:	00 00 00 
  801e23:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  801e25:	be 00 00 00 00       	mov    $0x0,%esi
  801e2a:	bf 04 00 00 00       	mov    $0x4,%edi
  801e2f:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  801e36:	00 00 00 
  801e39:	ff d0                	call   *%rax
  801e3b:	48 98                	cltq
}
  801e3d:	5d                   	pop    %rbp
  801e3e:	c3                   	ret
        return -E_INVAL;
  801e3f:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  801e46:	c3                   	ret

0000000000801e47 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801e47:	f3 0f 1e fa          	endbr64
  801e4b:	55                   	push   %rbp
  801e4c:	48 89 e5             	mov    %rsp,%rbp
  801e4f:	41 55                	push   %r13
  801e51:	41 54                	push   %r12
  801e53:	53                   	push   %rbx
  801e54:	48 83 ec 08          	sub    $0x8,%rsp
  801e58:	49 89 f4             	mov    %rsi,%r12
  801e5b:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e5e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e65:	00 00 00 
  801e68:	8b 57 0c             	mov    0xc(%rdi),%edx
  801e6b:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  801e6d:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  801e71:	be 00 00 00 00       	mov    $0x0,%esi
  801e76:	bf 03 00 00 00       	mov    $0x3,%edi
  801e7b:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  801e82:	00 00 00 
  801e85:	ff d0                	call   *%rax
  801e87:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  801e8a:	4d 85 ed             	test   %r13,%r13
  801e8d:	78 2a                	js     801eb9 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  801e8f:	4c 89 ea             	mov    %r13,%rdx
  801e92:	4c 39 eb             	cmp    %r13,%rbx
  801e95:	72 30                	jb     801ec7 <devfile_read+0x80>
  801e97:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  801e9e:	7f 27                	jg     801ec7 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  801ea0:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801ea7:	00 00 00 
  801eaa:	4c 89 e7             	mov    %r12,%rdi
  801ead:	48 b8 83 0d 80 00 00 	movabs $0x800d83,%rax
  801eb4:	00 00 00 
  801eb7:	ff d0                	call   *%rax
}
  801eb9:	4c 89 e8             	mov    %r13,%rax
  801ebc:	48 83 c4 08          	add    $0x8,%rsp
  801ec0:	5b                   	pop    %rbx
  801ec1:	41 5c                	pop    %r12
  801ec3:	41 5d                	pop    %r13
  801ec5:	5d                   	pop    %rbp
  801ec6:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801ec7:	48 b9 e5 31 80 00 00 	movabs $0x8031e5,%rcx
  801ece:	00 00 00 
  801ed1:	48 ba 02 32 80 00 00 	movabs $0x803202,%rdx
  801ed8:	00 00 00 
  801edb:	be 7b 00 00 00       	mov    $0x7b,%esi
  801ee0:	48 bf 17 32 80 00 00 	movabs $0x803217,%rdi
  801ee7:	00 00 00 
  801eea:	b8 00 00 00 00       	mov    $0x0,%eax
  801eef:	49 b8 98 2a 80 00 00 	movabs $0x802a98,%r8
  801ef6:	00 00 00 
  801ef9:	41 ff d0             	call   *%r8

0000000000801efc <open>:
open(const char *path, int mode) {
  801efc:	f3 0f 1e fa          	endbr64
  801f00:	55                   	push   %rbp
  801f01:	48 89 e5             	mov    %rsp,%rbp
  801f04:	41 55                	push   %r13
  801f06:	41 54                	push   %r12
  801f08:	53                   	push   %rbx
  801f09:	48 83 ec 18          	sub    $0x18,%rsp
  801f0d:	49 89 fc             	mov    %rdi,%r12
  801f10:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801f13:	48 b8 23 0b 80 00 00 	movabs $0x800b23,%rax
  801f1a:	00 00 00 
  801f1d:	ff d0                	call   *%rax
  801f1f:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801f25:	0f 87 8a 00 00 00    	ja     801fb5 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801f2b:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801f2f:	48 b8 67 15 80 00 00 	movabs $0x801567,%rax
  801f36:	00 00 00 
  801f39:	ff d0                	call   *%rax
  801f3b:	89 c3                	mov    %eax,%ebx
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	78 50                	js     801f91 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  801f41:	4c 89 e6             	mov    %r12,%rsi
  801f44:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801f4b:	00 00 00 
  801f4e:	48 89 df             	mov    %rbx,%rdi
  801f51:	48 b8 68 0b 80 00 00 	movabs $0x800b68,%rax
  801f58:	00 00 00 
  801f5b:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801f5d:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f64:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801f68:	bf 01 00 00 00       	mov    $0x1,%edi
  801f6d:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  801f74:	00 00 00 
  801f77:	ff d0                	call   *%rax
  801f79:	89 c3                	mov    %eax,%ebx
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	78 1f                	js     801f9e <open+0xa2>
    return fd2num(fd);
  801f7f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f83:	48 b8 31 15 80 00 00 	movabs $0x801531,%rax
  801f8a:	00 00 00 
  801f8d:	ff d0                	call   *%rax
  801f8f:	89 c3                	mov    %eax,%ebx
}
  801f91:	89 d8                	mov    %ebx,%eax
  801f93:	48 83 c4 18          	add    $0x18,%rsp
  801f97:	5b                   	pop    %rbx
  801f98:	41 5c                	pop    %r12
  801f9a:	41 5d                	pop    %r13
  801f9c:	5d                   	pop    %rbp
  801f9d:	c3                   	ret
        fd_close(fd, 0);
  801f9e:	be 00 00 00 00       	mov    $0x0,%esi
  801fa3:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801fa7:	48 b8 8e 16 80 00 00 	movabs $0x80168e,%rax
  801fae:	00 00 00 
  801fb1:	ff d0                	call   *%rax
        return res;
  801fb3:	eb dc                	jmp    801f91 <open+0x95>
        return -E_BAD_PATH;
  801fb5:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801fba:	eb d5                	jmp    801f91 <open+0x95>

0000000000801fbc <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801fbc:	f3 0f 1e fa          	endbr64
  801fc0:	55                   	push   %rbp
  801fc1:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801fc4:	be 00 00 00 00       	mov    $0x0,%esi
  801fc9:	bf 08 00 00 00       	mov    $0x8,%edi
  801fce:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  801fd5:	00 00 00 
  801fd8:	ff d0                	call   *%rax
}
  801fda:	5d                   	pop    %rbp
  801fdb:	c3                   	ret

0000000000801fdc <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801fdc:	f3 0f 1e fa          	endbr64
  801fe0:	55                   	push   %rbp
  801fe1:	48 89 e5             	mov    %rsp,%rbp
  801fe4:	41 54                	push   %r12
  801fe6:	53                   	push   %rbx
  801fe7:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801fea:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  801ff1:	00 00 00 
  801ff4:	ff d0                	call   *%rax
  801ff6:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801ff9:	48 be 22 32 80 00 00 	movabs $0x803222,%rsi
  802000:	00 00 00 
  802003:	48 89 df             	mov    %rbx,%rdi
  802006:	48 b8 68 0b 80 00 00 	movabs $0x800b68,%rax
  80200d:	00 00 00 
  802010:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802012:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802017:	41 2b 04 24          	sub    (%r12),%eax
  80201b:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802021:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802028:	00 00 00 
    stat->st_dev = &devpipe;
  80202b:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802032:	00 00 00 
  802035:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80203c:	b8 00 00 00 00       	mov    $0x0,%eax
  802041:	5b                   	pop    %rbx
  802042:	41 5c                	pop    %r12
  802044:	5d                   	pop    %rbp
  802045:	c3                   	ret

0000000000802046 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802046:	f3 0f 1e fa          	endbr64
  80204a:	55                   	push   %rbp
  80204b:	48 89 e5             	mov    %rsp,%rbp
  80204e:	41 54                	push   %r12
  802050:	53                   	push   %rbx
  802051:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802054:	ba 00 10 00 00       	mov    $0x1000,%edx
  802059:	48 89 fe             	mov    %rdi,%rsi
  80205c:	bf 00 00 00 00       	mov    $0x0,%edi
  802061:	49 bc ad 12 80 00 00 	movabs $0x8012ad,%r12
  802068:	00 00 00 
  80206b:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80206e:	48 89 df             	mov    %rbx,%rdi
  802071:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  802078:	00 00 00 
  80207b:	ff d0                	call   *%rax
  80207d:	48 89 c6             	mov    %rax,%rsi
  802080:	ba 00 10 00 00       	mov    $0x1000,%edx
  802085:	bf 00 00 00 00       	mov    $0x0,%edi
  80208a:	41 ff d4             	call   *%r12
}
  80208d:	5b                   	pop    %rbx
  80208e:	41 5c                	pop    %r12
  802090:	5d                   	pop    %rbp
  802091:	c3                   	ret

0000000000802092 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802092:	f3 0f 1e fa          	endbr64
  802096:	55                   	push   %rbp
  802097:	48 89 e5             	mov    %rsp,%rbp
  80209a:	41 57                	push   %r15
  80209c:	41 56                	push   %r14
  80209e:	41 55                	push   %r13
  8020a0:	41 54                	push   %r12
  8020a2:	53                   	push   %rbx
  8020a3:	48 83 ec 18          	sub    $0x18,%rsp
  8020a7:	49 89 fc             	mov    %rdi,%r12
  8020aa:	49 89 f5             	mov    %rsi,%r13
  8020ad:	49 89 d7             	mov    %rdx,%r15
  8020b0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8020b4:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  8020bb:	00 00 00 
  8020be:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8020c0:	4d 85 ff             	test   %r15,%r15
  8020c3:	0f 84 af 00 00 00    	je     802178 <devpipe_write+0xe6>
  8020c9:	48 89 c3             	mov    %rax,%rbx
  8020cc:	4c 89 f8             	mov    %r15,%rax
  8020cf:	4d 89 ef             	mov    %r13,%r15
  8020d2:	4c 01 e8             	add    %r13,%rax
  8020d5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8020d9:	49 bd 3d 11 80 00 00 	movabs $0x80113d,%r13
  8020e0:	00 00 00 
            sys_yield();
  8020e3:	49 be d2 10 80 00 00 	movabs $0x8010d2,%r14
  8020ea:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8020ed:	8b 73 04             	mov    0x4(%rbx),%esi
  8020f0:	48 63 ce             	movslq %esi,%rcx
  8020f3:	48 63 03             	movslq (%rbx),%rax
  8020f6:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8020fc:	48 39 c1             	cmp    %rax,%rcx
  8020ff:	72 2e                	jb     80212f <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802101:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802106:	48 89 da             	mov    %rbx,%rdx
  802109:	be 00 10 00 00       	mov    $0x1000,%esi
  80210e:	4c 89 e7             	mov    %r12,%rdi
  802111:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802114:	85 c0                	test   %eax,%eax
  802116:	74 66                	je     80217e <devpipe_write+0xec>
            sys_yield();
  802118:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80211b:	8b 73 04             	mov    0x4(%rbx),%esi
  80211e:	48 63 ce             	movslq %esi,%rcx
  802121:	48 63 03             	movslq (%rbx),%rax
  802124:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80212a:	48 39 c1             	cmp    %rax,%rcx
  80212d:	73 d2                	jae    802101 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80212f:	41 0f b6 3f          	movzbl (%r15),%edi
  802133:	48 89 ca             	mov    %rcx,%rdx
  802136:	48 c1 ea 03          	shr    $0x3,%rdx
  80213a:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802141:	08 10 20 
  802144:	48 f7 e2             	mul    %rdx
  802147:	48 c1 ea 06          	shr    $0x6,%rdx
  80214b:	48 89 d0             	mov    %rdx,%rax
  80214e:	48 c1 e0 09          	shl    $0x9,%rax
  802152:	48 29 d0             	sub    %rdx,%rax
  802155:	48 c1 e0 03          	shl    $0x3,%rax
  802159:	48 29 c1             	sub    %rax,%rcx
  80215c:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802161:	83 c6 01             	add    $0x1,%esi
  802164:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802167:	49 83 c7 01          	add    $0x1,%r15
  80216b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80216f:	49 39 c7             	cmp    %rax,%r15
  802172:	0f 85 75 ff ff ff    	jne    8020ed <devpipe_write+0x5b>
    return n;
  802178:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80217c:	eb 05                	jmp    802183 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  80217e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802183:	48 83 c4 18          	add    $0x18,%rsp
  802187:	5b                   	pop    %rbx
  802188:	41 5c                	pop    %r12
  80218a:	41 5d                	pop    %r13
  80218c:	41 5e                	pop    %r14
  80218e:	41 5f                	pop    %r15
  802190:	5d                   	pop    %rbp
  802191:	c3                   	ret

0000000000802192 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802192:	f3 0f 1e fa          	endbr64
  802196:	55                   	push   %rbp
  802197:	48 89 e5             	mov    %rsp,%rbp
  80219a:	41 57                	push   %r15
  80219c:	41 56                	push   %r14
  80219e:	41 55                	push   %r13
  8021a0:	41 54                	push   %r12
  8021a2:	53                   	push   %rbx
  8021a3:	48 83 ec 18          	sub    $0x18,%rsp
  8021a7:	49 89 fc             	mov    %rdi,%r12
  8021aa:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8021ae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8021b2:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  8021b9:	00 00 00 
  8021bc:	ff d0                	call   *%rax
  8021be:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8021c1:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021c7:	49 bd 3d 11 80 00 00 	movabs $0x80113d,%r13
  8021ce:	00 00 00 
            sys_yield();
  8021d1:	49 be d2 10 80 00 00 	movabs $0x8010d2,%r14
  8021d8:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8021db:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8021e0:	74 7d                	je     80225f <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8021e2:	8b 03                	mov    (%rbx),%eax
  8021e4:	3b 43 04             	cmp    0x4(%rbx),%eax
  8021e7:	75 26                	jne    80220f <devpipe_read+0x7d>
            if (i > 0) return i;
  8021e9:	4d 85 ff             	test   %r15,%r15
  8021ec:	75 77                	jne    802265 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021ee:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021f3:	48 89 da             	mov    %rbx,%rdx
  8021f6:	be 00 10 00 00       	mov    $0x1000,%esi
  8021fb:	4c 89 e7             	mov    %r12,%rdi
  8021fe:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802201:	85 c0                	test   %eax,%eax
  802203:	74 72                	je     802277 <devpipe_read+0xe5>
            sys_yield();
  802205:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802208:	8b 03                	mov    (%rbx),%eax
  80220a:	3b 43 04             	cmp    0x4(%rbx),%eax
  80220d:	74 df                	je     8021ee <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80220f:	48 63 c8             	movslq %eax,%rcx
  802212:	48 89 ca             	mov    %rcx,%rdx
  802215:	48 c1 ea 03          	shr    $0x3,%rdx
  802219:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802220:	08 10 20 
  802223:	48 89 d0             	mov    %rdx,%rax
  802226:	48 f7 e6             	mul    %rsi
  802229:	48 c1 ea 06          	shr    $0x6,%rdx
  80222d:	48 89 d0             	mov    %rdx,%rax
  802230:	48 c1 e0 09          	shl    $0x9,%rax
  802234:	48 29 d0             	sub    %rdx,%rax
  802237:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80223e:	00 
  80223f:	48 89 c8             	mov    %rcx,%rax
  802242:	48 29 d0             	sub    %rdx,%rax
  802245:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80224a:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80224e:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802252:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802255:	49 83 c7 01          	add    $0x1,%r15
  802259:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80225d:	75 83                	jne    8021e2 <devpipe_read+0x50>
    return n;
  80225f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802263:	eb 03                	jmp    802268 <devpipe_read+0xd6>
            if (i > 0) return i;
  802265:	4c 89 f8             	mov    %r15,%rax
}
  802268:	48 83 c4 18          	add    $0x18,%rsp
  80226c:	5b                   	pop    %rbx
  80226d:	41 5c                	pop    %r12
  80226f:	41 5d                	pop    %r13
  802271:	41 5e                	pop    %r14
  802273:	41 5f                	pop    %r15
  802275:	5d                   	pop    %rbp
  802276:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802277:	b8 00 00 00 00       	mov    $0x0,%eax
  80227c:	eb ea                	jmp    802268 <devpipe_read+0xd6>

000000000080227e <pipe>:
pipe(int pfd[2]) {
  80227e:	f3 0f 1e fa          	endbr64
  802282:	55                   	push   %rbp
  802283:	48 89 e5             	mov    %rsp,%rbp
  802286:	41 55                	push   %r13
  802288:	41 54                	push   %r12
  80228a:	53                   	push   %rbx
  80228b:	48 83 ec 18          	sub    $0x18,%rsp
  80228f:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802292:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802296:	48 b8 67 15 80 00 00 	movabs $0x801567,%rax
  80229d:	00 00 00 
  8022a0:	ff d0                	call   *%rax
  8022a2:	89 c3                	mov    %eax,%ebx
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	0f 88 a0 01 00 00    	js     80244c <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8022ac:	b9 46 00 00 00       	mov    $0x46,%ecx
  8022b1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022b6:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8022ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8022bf:	48 b8 6d 11 80 00 00 	movabs $0x80116d,%rax
  8022c6:	00 00 00 
  8022c9:	ff d0                	call   *%rax
  8022cb:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	0f 88 77 01 00 00    	js     80244c <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8022d5:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8022d9:	48 b8 67 15 80 00 00 	movabs $0x801567,%rax
  8022e0:	00 00 00 
  8022e3:	ff d0                	call   *%rax
  8022e5:	89 c3                	mov    %eax,%ebx
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	0f 88 43 01 00 00    	js     802432 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8022ef:	b9 46 00 00 00       	mov    $0x46,%ecx
  8022f4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022f9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802302:	48 b8 6d 11 80 00 00 	movabs $0x80116d,%rax
  802309:	00 00 00 
  80230c:	ff d0                	call   *%rax
  80230e:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802310:	85 c0                	test   %eax,%eax
  802312:	0f 88 1a 01 00 00    	js     802432 <pipe+0x1b4>
    va = fd2data(fd0);
  802318:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80231c:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  802323:	00 00 00 
  802326:	ff d0                	call   *%rax
  802328:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80232b:	b9 46 00 00 00       	mov    $0x46,%ecx
  802330:	ba 00 10 00 00       	mov    $0x1000,%edx
  802335:	48 89 c6             	mov    %rax,%rsi
  802338:	bf 00 00 00 00       	mov    $0x0,%edi
  80233d:	48 b8 6d 11 80 00 00 	movabs $0x80116d,%rax
  802344:	00 00 00 
  802347:	ff d0                	call   *%rax
  802349:	89 c3                	mov    %eax,%ebx
  80234b:	85 c0                	test   %eax,%eax
  80234d:	0f 88 c5 00 00 00    	js     802418 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802353:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802357:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  80235e:	00 00 00 
  802361:	ff d0                	call   *%rax
  802363:	48 89 c1             	mov    %rax,%rcx
  802366:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80236c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802372:	ba 00 00 00 00       	mov    $0x0,%edx
  802377:	4c 89 ee             	mov    %r13,%rsi
  80237a:	bf 00 00 00 00       	mov    $0x0,%edi
  80237f:	48 b8 d8 11 80 00 00 	movabs $0x8011d8,%rax
  802386:	00 00 00 
  802389:	ff d0                	call   *%rax
  80238b:	89 c3                	mov    %eax,%ebx
  80238d:	85 c0                	test   %eax,%eax
  80238f:	78 6e                	js     8023ff <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802391:	be 00 10 00 00       	mov    $0x1000,%esi
  802396:	4c 89 ef             	mov    %r13,%rdi
  802399:	48 b8 07 11 80 00 00 	movabs $0x801107,%rax
  8023a0:	00 00 00 
  8023a3:	ff d0                	call   *%rax
  8023a5:	83 f8 02             	cmp    $0x2,%eax
  8023a8:	0f 85 ab 00 00 00    	jne    802459 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8023ae:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8023b5:	00 00 
  8023b7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023bb:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8023bd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023c1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8023c8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8023cc:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8023ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023d2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8023d9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023dd:	48 bb 31 15 80 00 00 	movabs $0x801531,%rbx
  8023e4:	00 00 00 
  8023e7:	ff d3                	call   *%rbx
  8023e9:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8023ed:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8023f1:	ff d3                	call   *%rbx
  8023f3:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8023f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023fd:	eb 4d                	jmp    80244c <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8023ff:	ba 00 10 00 00       	mov    $0x1000,%edx
  802404:	4c 89 ee             	mov    %r13,%rsi
  802407:	bf 00 00 00 00       	mov    $0x0,%edi
  80240c:	48 b8 ad 12 80 00 00 	movabs $0x8012ad,%rax
  802413:	00 00 00 
  802416:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802418:	ba 00 10 00 00       	mov    $0x1000,%edx
  80241d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802421:	bf 00 00 00 00       	mov    $0x0,%edi
  802426:	48 b8 ad 12 80 00 00 	movabs $0x8012ad,%rax
  80242d:	00 00 00 
  802430:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802432:	ba 00 10 00 00       	mov    $0x1000,%edx
  802437:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80243b:	bf 00 00 00 00       	mov    $0x0,%edi
  802440:	48 b8 ad 12 80 00 00 	movabs $0x8012ad,%rax
  802447:	00 00 00 
  80244a:	ff d0                	call   *%rax
}
  80244c:	89 d8                	mov    %ebx,%eax
  80244e:	48 83 c4 18          	add    $0x18,%rsp
  802452:	5b                   	pop    %rbx
  802453:	41 5c                	pop    %r12
  802455:	41 5d                	pop    %r13
  802457:	5d                   	pop    %rbp
  802458:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802459:	48 b9 48 36 80 00 00 	movabs $0x803648,%rcx
  802460:	00 00 00 
  802463:	48 ba 02 32 80 00 00 	movabs $0x803202,%rdx
  80246a:	00 00 00 
  80246d:	be 2e 00 00 00       	mov    $0x2e,%esi
  802472:	48 bf 29 32 80 00 00 	movabs $0x803229,%rdi
  802479:	00 00 00 
  80247c:	b8 00 00 00 00       	mov    $0x0,%eax
  802481:	49 b8 98 2a 80 00 00 	movabs $0x802a98,%r8
  802488:	00 00 00 
  80248b:	41 ff d0             	call   *%r8

000000000080248e <pipeisclosed>:
pipeisclosed(int fdnum) {
  80248e:	f3 0f 1e fa          	endbr64
  802492:	55                   	push   %rbp
  802493:	48 89 e5             	mov    %rsp,%rbp
  802496:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80249a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80249e:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  8024a5:	00 00 00 
  8024a8:	ff d0                	call   *%rax
    if (res < 0) return res;
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	78 35                	js     8024e3 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8024ae:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8024b2:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  8024b9:	00 00 00 
  8024bc:	ff d0                	call   *%rax
  8024be:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024c1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024c6:	be 00 10 00 00       	mov    $0x1000,%esi
  8024cb:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8024cf:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  8024d6:	00 00 00 
  8024d9:	ff d0                	call   *%rax
  8024db:	85 c0                	test   %eax,%eax
  8024dd:	0f 94 c0             	sete   %al
  8024e0:	0f b6 c0             	movzbl %al,%eax
}
  8024e3:	c9                   	leave
  8024e4:	c3                   	ret

00000000008024e5 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8024e5:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8024e9:	48 89 f8             	mov    %rdi,%rax
  8024ec:	48 c1 e8 27          	shr    $0x27,%rax
  8024f0:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8024f7:	7f 00 00 
  8024fa:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8024fe:	f6 c2 01             	test   $0x1,%dl
  802501:	74 6d                	je     802570 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802503:	48 89 f8             	mov    %rdi,%rax
  802506:	48 c1 e8 1e          	shr    $0x1e,%rax
  80250a:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802511:	7f 00 00 
  802514:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802518:	f6 c2 01             	test   $0x1,%dl
  80251b:	74 62                	je     80257f <get_uvpt_entry+0x9a>
  80251d:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802524:	7f 00 00 
  802527:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80252b:	f6 c2 80             	test   $0x80,%dl
  80252e:	75 4f                	jne    80257f <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802530:	48 89 f8             	mov    %rdi,%rax
  802533:	48 c1 e8 15          	shr    $0x15,%rax
  802537:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80253e:	7f 00 00 
  802541:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802545:	f6 c2 01             	test   $0x1,%dl
  802548:	74 44                	je     80258e <get_uvpt_entry+0xa9>
  80254a:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802551:	7f 00 00 
  802554:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802558:	f6 c2 80             	test   $0x80,%dl
  80255b:	75 31                	jne    80258e <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80255d:	48 c1 ef 0c          	shr    $0xc,%rdi
  802561:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802568:	7f 00 00 
  80256b:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80256f:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802570:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802577:	7f 00 00 
  80257a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80257e:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80257f:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802586:	7f 00 00 
  802589:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80258d:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80258e:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802595:	7f 00 00 
  802598:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80259c:	c3                   	ret

000000000080259d <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  80259d:	f3 0f 1e fa          	endbr64
  8025a1:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8025a4:	48 89 f9             	mov    %rdi,%rcx
  8025a7:	48 c1 e9 27          	shr    $0x27,%rcx
  8025ab:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8025b2:	7f 00 00 
  8025b5:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8025b9:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8025c0:	f6 c1 01             	test   $0x1,%cl
  8025c3:	0f 84 b2 00 00 00    	je     80267b <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8025c9:	48 89 f9             	mov    %rdi,%rcx
  8025cc:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8025d0:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8025d7:	7f 00 00 
  8025da:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8025de:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8025e5:	40 f6 c6 01          	test   $0x1,%sil
  8025e9:	0f 84 8c 00 00 00    	je     80267b <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8025ef:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8025f6:	7f 00 00 
  8025f9:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8025fd:	a8 80                	test   $0x80,%al
  8025ff:	75 7b                	jne    80267c <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802601:	48 89 f9             	mov    %rdi,%rcx
  802604:	48 c1 e9 15          	shr    $0x15,%rcx
  802608:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80260f:	7f 00 00 
  802612:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802616:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  80261d:	40 f6 c6 01          	test   $0x1,%sil
  802621:	74 58                	je     80267b <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802623:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80262a:	7f 00 00 
  80262d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802631:	a8 80                	test   $0x80,%al
  802633:	75 6c                	jne    8026a1 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802635:	48 89 f9             	mov    %rdi,%rcx
  802638:	48 c1 e9 0c          	shr    $0xc,%rcx
  80263c:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802643:	7f 00 00 
  802646:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80264a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802651:	40 f6 c6 01          	test   $0x1,%sil
  802655:	74 24                	je     80267b <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802657:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80265e:	7f 00 00 
  802661:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802665:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80266c:	ff ff 7f 
  80266f:	48 21 c8             	and    %rcx,%rax
  802672:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802678:	48 09 d0             	or     %rdx,%rax
}
  80267b:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  80267c:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802683:	7f 00 00 
  802686:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80268a:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802691:	ff ff 7f 
  802694:	48 21 c8             	and    %rcx,%rax
  802697:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  80269d:	48 01 d0             	add    %rdx,%rax
  8026a0:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8026a1:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8026a8:	7f 00 00 
  8026ab:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8026af:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8026b6:	ff ff 7f 
  8026b9:	48 21 c8             	and    %rcx,%rax
  8026bc:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8026c2:	48 01 d0             	add    %rdx,%rax
  8026c5:	c3                   	ret

00000000008026c6 <get_prot>:

int
get_prot(void *va) {
  8026c6:	f3 0f 1e fa          	endbr64
  8026ca:	55                   	push   %rbp
  8026cb:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8026ce:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  8026d5:	00 00 00 
  8026d8:	ff d0                	call   *%rax
  8026da:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8026dd:	83 e0 01             	and    $0x1,%eax
  8026e0:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8026e3:	89 d1                	mov    %edx,%ecx
  8026e5:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8026eb:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8026ed:	89 c1                	mov    %eax,%ecx
  8026ef:	83 c9 02             	or     $0x2,%ecx
  8026f2:	f6 c2 02             	test   $0x2,%dl
  8026f5:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8026f8:	89 c1                	mov    %eax,%ecx
  8026fa:	83 c9 01             	or     $0x1,%ecx
  8026fd:	48 85 d2             	test   %rdx,%rdx
  802700:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802703:	89 c1                	mov    %eax,%ecx
  802705:	83 c9 40             	or     $0x40,%ecx
  802708:	f6 c6 04             	test   $0x4,%dh
  80270b:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80270e:	5d                   	pop    %rbp
  80270f:	c3                   	ret

0000000000802710 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802710:	f3 0f 1e fa          	endbr64
  802714:	55                   	push   %rbp
  802715:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802718:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  80271f:	00 00 00 
  802722:	ff d0                	call   *%rax
    return pte & PTE_D;
  802724:	48 c1 e8 06          	shr    $0x6,%rax
  802728:	83 e0 01             	and    $0x1,%eax
}
  80272b:	5d                   	pop    %rbp
  80272c:	c3                   	ret

000000000080272d <is_page_present>:

bool
is_page_present(void *va) {
  80272d:	f3 0f 1e fa          	endbr64
  802731:	55                   	push   %rbp
  802732:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802735:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  80273c:	00 00 00 
  80273f:	ff d0                	call   *%rax
  802741:	83 e0 01             	and    $0x1,%eax
}
  802744:	5d                   	pop    %rbp
  802745:	c3                   	ret

0000000000802746 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802746:	f3 0f 1e fa          	endbr64
  80274a:	55                   	push   %rbp
  80274b:	48 89 e5             	mov    %rsp,%rbp
  80274e:	41 57                	push   %r15
  802750:	41 56                	push   %r14
  802752:	41 55                	push   %r13
  802754:	41 54                	push   %r12
  802756:	53                   	push   %rbx
  802757:	48 83 ec 18          	sub    $0x18,%rsp
  80275b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80275f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802763:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802768:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  80276f:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802772:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802779:	7f 00 00 
    while (va < USER_STACK_TOP) {
  80277c:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802783:	00 00 00 
  802786:	eb 73                	jmp    8027fb <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802788:	48 89 d8             	mov    %rbx,%rax
  80278b:	48 c1 e8 15          	shr    $0x15,%rax
  80278f:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802796:	7f 00 00 
  802799:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  80279d:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8027a3:	f6 c2 01             	test   $0x1,%dl
  8027a6:	74 4b                	je     8027f3 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8027a8:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8027ac:	f6 c2 80             	test   $0x80,%dl
  8027af:	74 11                	je     8027c2 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8027b1:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8027b5:	f6 c4 04             	test   $0x4,%ah
  8027b8:	74 39                	je     8027f3 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8027ba:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  8027c0:	eb 20                	jmp    8027e2 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8027c2:	48 89 da             	mov    %rbx,%rdx
  8027c5:	48 c1 ea 0c          	shr    $0xc,%rdx
  8027c9:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8027d0:	7f 00 00 
  8027d3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  8027d7:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8027dd:	f6 c4 04             	test   $0x4,%ah
  8027e0:	74 11                	je     8027f3 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  8027e2:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  8027e6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8027ea:	48 89 df             	mov    %rbx,%rdi
  8027ed:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8027f1:	ff d0                	call   *%rax
    next:
        va += size;
  8027f3:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  8027f6:	49 39 df             	cmp    %rbx,%r15
  8027f9:	72 3e                	jb     802839 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8027fb:	49 8b 06             	mov    (%r14),%rax
  8027fe:	a8 01                	test   $0x1,%al
  802800:	74 37                	je     802839 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802802:	48 89 d8             	mov    %rbx,%rax
  802805:	48 c1 e8 1e          	shr    $0x1e,%rax
  802809:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  80280e:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802814:	f6 c2 01             	test   $0x1,%dl
  802817:	74 da                	je     8027f3 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802819:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  80281e:	f6 c2 80             	test   $0x80,%dl
  802821:	0f 84 61 ff ff ff    	je     802788 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802827:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80282c:	f6 c4 04             	test   $0x4,%ah
  80282f:	74 c2                	je     8027f3 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802831:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802837:	eb a9                	jmp    8027e2 <foreach_shared_region+0x9c>
    }
    return res;
}
  802839:	b8 00 00 00 00       	mov    $0x0,%eax
  80283e:	48 83 c4 18          	add    $0x18,%rsp
  802842:	5b                   	pop    %rbx
  802843:	41 5c                	pop    %r12
  802845:	41 5d                	pop    %r13
  802847:	41 5e                	pop    %r14
  802849:	41 5f                	pop    %r15
  80284b:	5d                   	pop    %rbp
  80284c:	c3                   	ret

000000000080284d <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  80284d:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802851:	b8 00 00 00 00       	mov    $0x0,%eax
  802856:	c3                   	ret

0000000000802857 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802857:	f3 0f 1e fa          	endbr64
  80285b:	55                   	push   %rbp
  80285c:	48 89 e5             	mov    %rsp,%rbp
  80285f:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802862:	48 be 39 32 80 00 00 	movabs $0x803239,%rsi
  802869:	00 00 00 
  80286c:	48 b8 68 0b 80 00 00 	movabs $0x800b68,%rax
  802873:	00 00 00 
  802876:	ff d0                	call   *%rax
    return 0;
}
  802878:	b8 00 00 00 00       	mov    $0x0,%eax
  80287d:	5d                   	pop    %rbp
  80287e:	c3                   	ret

000000000080287f <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80287f:	f3 0f 1e fa          	endbr64
  802883:	55                   	push   %rbp
  802884:	48 89 e5             	mov    %rsp,%rbp
  802887:	41 57                	push   %r15
  802889:	41 56                	push   %r14
  80288b:	41 55                	push   %r13
  80288d:	41 54                	push   %r12
  80288f:	53                   	push   %rbx
  802890:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802897:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  80289e:	48 85 d2             	test   %rdx,%rdx
  8028a1:	74 7a                	je     80291d <devcons_write+0x9e>
  8028a3:	49 89 d6             	mov    %rdx,%r14
  8028a6:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8028ac:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8028b1:	49 bf 83 0d 80 00 00 	movabs $0x800d83,%r15
  8028b8:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8028bb:	4c 89 f3             	mov    %r14,%rbx
  8028be:	48 29 f3             	sub    %rsi,%rbx
  8028c1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8028c6:	48 39 c3             	cmp    %rax,%rbx
  8028c9:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8028cd:	4c 63 eb             	movslq %ebx,%r13
  8028d0:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8028d7:	48 01 c6             	add    %rax,%rsi
  8028da:	4c 89 ea             	mov    %r13,%rdx
  8028dd:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8028e4:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8028e7:	4c 89 ee             	mov    %r13,%rsi
  8028ea:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8028f1:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  8028f8:	00 00 00 
  8028fb:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8028fd:	41 01 dc             	add    %ebx,%r12d
  802900:	49 63 f4             	movslq %r12d,%rsi
  802903:	4c 39 f6             	cmp    %r14,%rsi
  802906:	72 b3                	jb     8028bb <devcons_write+0x3c>
    return res;
  802908:	49 63 c4             	movslq %r12d,%rax
}
  80290b:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802912:	5b                   	pop    %rbx
  802913:	41 5c                	pop    %r12
  802915:	41 5d                	pop    %r13
  802917:	41 5e                	pop    %r14
  802919:	41 5f                	pop    %r15
  80291b:	5d                   	pop    %rbp
  80291c:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  80291d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802923:	eb e3                	jmp    802908 <devcons_write+0x89>

0000000000802925 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802925:	f3 0f 1e fa          	endbr64
  802929:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80292c:	ba 00 00 00 00       	mov    $0x0,%edx
  802931:	48 85 c0             	test   %rax,%rax
  802934:	74 55                	je     80298b <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802936:	55                   	push   %rbp
  802937:	48 89 e5             	mov    %rsp,%rbp
  80293a:	41 55                	push   %r13
  80293c:	41 54                	push   %r12
  80293e:	53                   	push   %rbx
  80293f:	48 83 ec 08          	sub    $0x8,%rsp
  802943:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802946:	48 bb f9 0f 80 00 00 	movabs $0x800ff9,%rbx
  80294d:	00 00 00 
  802950:	49 bc d2 10 80 00 00 	movabs $0x8010d2,%r12
  802957:	00 00 00 
  80295a:	eb 03                	jmp    80295f <devcons_read+0x3a>
  80295c:	41 ff d4             	call   *%r12
  80295f:	ff d3                	call   *%rbx
  802961:	85 c0                	test   %eax,%eax
  802963:	74 f7                	je     80295c <devcons_read+0x37>
    if (c < 0) return c;
  802965:	48 63 d0             	movslq %eax,%rdx
  802968:	78 13                	js     80297d <devcons_read+0x58>
    if (c == 0x04) return 0;
  80296a:	ba 00 00 00 00       	mov    $0x0,%edx
  80296f:	83 f8 04             	cmp    $0x4,%eax
  802972:	74 09                	je     80297d <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802974:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802978:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80297d:	48 89 d0             	mov    %rdx,%rax
  802980:	48 83 c4 08          	add    $0x8,%rsp
  802984:	5b                   	pop    %rbx
  802985:	41 5c                	pop    %r12
  802987:	41 5d                	pop    %r13
  802989:	5d                   	pop    %rbp
  80298a:	c3                   	ret
  80298b:	48 89 d0             	mov    %rdx,%rax
  80298e:	c3                   	ret

000000000080298f <cputchar>:
cputchar(int ch) {
  80298f:	f3 0f 1e fa          	endbr64
  802993:	55                   	push   %rbp
  802994:	48 89 e5             	mov    %rsp,%rbp
  802997:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  80299b:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80299f:	be 01 00 00 00       	mov    $0x1,%esi
  8029a4:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8029a8:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  8029af:	00 00 00 
  8029b2:	ff d0                	call   *%rax
}
  8029b4:	c9                   	leave
  8029b5:	c3                   	ret

00000000008029b6 <getchar>:
getchar(void) {
  8029b6:	f3 0f 1e fa          	endbr64
  8029ba:	55                   	push   %rbp
  8029bb:	48 89 e5             	mov    %rsp,%rbp
  8029be:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8029c2:	ba 01 00 00 00       	mov    $0x1,%edx
  8029c7:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8029cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8029d0:	48 b8 c6 18 80 00 00 	movabs $0x8018c6,%rax
  8029d7:	00 00 00 
  8029da:	ff d0                	call   *%rax
  8029dc:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8029de:	85 c0                	test   %eax,%eax
  8029e0:	78 06                	js     8029e8 <getchar+0x32>
  8029e2:	74 08                	je     8029ec <getchar+0x36>
  8029e4:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8029e8:	89 d0                	mov    %edx,%eax
  8029ea:	c9                   	leave
  8029eb:	c3                   	ret
    return res < 0 ? res : res ? c :
  8029ec:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8029f1:	eb f5                	jmp    8029e8 <getchar+0x32>

00000000008029f3 <iscons>:
iscons(int fdnum) {
  8029f3:	f3 0f 1e fa          	endbr64
  8029f7:	55                   	push   %rbp
  8029f8:	48 89 e5             	mov    %rsp,%rbp
  8029fb:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8029ff:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802a03:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  802a0a:	00 00 00 
  802a0d:	ff d0                	call   *%rax
    if (res < 0) return res;
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	78 18                	js     802a2b <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802a13:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a17:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802a1e:	00 00 00 
  802a21:	8b 00                	mov    (%rax),%eax
  802a23:	39 02                	cmp    %eax,(%rdx)
  802a25:	0f 94 c0             	sete   %al
  802a28:	0f b6 c0             	movzbl %al,%eax
}
  802a2b:	c9                   	leave
  802a2c:	c3                   	ret

0000000000802a2d <opencons>:
opencons(void) {
  802a2d:	f3 0f 1e fa          	endbr64
  802a31:	55                   	push   %rbp
  802a32:	48 89 e5             	mov    %rsp,%rbp
  802a35:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802a39:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802a3d:	48 b8 67 15 80 00 00 	movabs $0x801567,%rax
  802a44:	00 00 00 
  802a47:	ff d0                	call   *%rax
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	78 49                	js     802a96 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802a4d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802a52:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a57:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802a5b:	bf 00 00 00 00       	mov    $0x0,%edi
  802a60:	48 b8 6d 11 80 00 00 	movabs $0x80116d,%rax
  802a67:	00 00 00 
  802a6a:	ff d0                	call   *%rax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	78 26                	js     802a96 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802a70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a74:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802a7b:	00 00 
  802a7d:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802a7f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802a83:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802a8a:	48 b8 31 15 80 00 00 	movabs $0x801531,%rax
  802a91:	00 00 00 
  802a94:	ff d0                	call   *%rax
}
  802a96:	c9                   	leave
  802a97:	c3                   	ret

0000000000802a98 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802a98:	f3 0f 1e fa          	endbr64
  802a9c:	55                   	push   %rbp
  802a9d:	48 89 e5             	mov    %rsp,%rbp
  802aa0:	41 56                	push   %r14
  802aa2:	41 55                	push   %r13
  802aa4:	41 54                	push   %r12
  802aa6:	53                   	push   %rbx
  802aa7:	48 83 ec 50          	sub    $0x50,%rsp
  802aab:	49 89 fc             	mov    %rdi,%r12
  802aae:	41 89 f5             	mov    %esi,%r13d
  802ab1:	48 89 d3             	mov    %rdx,%rbx
  802ab4:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802ab8:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802abc:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802ac0:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802ac7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802acb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802acf:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802ad3:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802ad7:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802ade:	00 00 00 
  802ae1:	4c 8b 30             	mov    (%rax),%r14
  802ae4:	48 b8 9d 10 80 00 00 	movabs $0x80109d,%rax
  802aeb:	00 00 00 
  802aee:	ff d0                	call   *%rax
  802af0:	89 c6                	mov    %eax,%esi
  802af2:	45 89 e8             	mov    %r13d,%r8d
  802af5:	4c 89 e1             	mov    %r12,%rcx
  802af8:	4c 89 f2             	mov    %r14,%rdx
  802afb:	48 bf 70 36 80 00 00 	movabs $0x803670,%rdi
  802b02:	00 00 00 
  802b05:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0a:	49 bc 1f 02 80 00 00 	movabs $0x80021f,%r12
  802b11:	00 00 00 
  802b14:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802b17:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802b1b:	48 89 df             	mov    %rbx,%rdi
  802b1e:	48 b8 b7 01 80 00 00 	movabs $0x8001b7,%rax
  802b25:	00 00 00 
  802b28:	ff d0                	call   *%rax
    cprintf("\n");
  802b2a:	48 bf 03 30 80 00 00 	movabs $0x803003,%rdi
  802b31:	00 00 00 
  802b34:	b8 00 00 00 00       	mov    $0x0,%eax
  802b39:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802b3c:	cc                   	int3
  802b3d:	eb fd                	jmp    802b3c <_panic+0xa4>

0000000000802b3f <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802b3f:	f3 0f 1e fa          	endbr64
  802b43:	55                   	push   %rbp
  802b44:	48 89 e5             	mov    %rsp,%rbp
  802b47:	41 54                	push   %r12
  802b49:	53                   	push   %rbx
  802b4a:	48 89 fb             	mov    %rdi,%rbx
  802b4d:	48 89 f7             	mov    %rsi,%rdi
  802b50:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802b53:	48 85 f6             	test   %rsi,%rsi
  802b56:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b5d:	00 00 00 
  802b60:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802b64:	be 00 10 00 00       	mov    $0x1000,%esi
  802b69:	48 b8 8f 14 80 00 00 	movabs $0x80148f,%rax
  802b70:	00 00 00 
  802b73:	ff d0                	call   *%rax
    if (res < 0) {
  802b75:	85 c0                	test   %eax,%eax
  802b77:	78 45                	js     802bbe <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802b79:	48 85 db             	test   %rbx,%rbx
  802b7c:	74 12                	je     802b90 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802b7e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b85:	00 00 00 
  802b88:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b8e:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802b90:	4d 85 e4             	test   %r12,%r12
  802b93:	74 14                	je     802ba9 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802b95:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b9c:	00 00 00 
  802b9f:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802ba5:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802ba9:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802bb0:	00 00 00 
  802bb3:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802bb9:	5b                   	pop    %rbx
  802bba:	41 5c                	pop    %r12
  802bbc:	5d                   	pop    %rbp
  802bbd:	c3                   	ret
        if (from_env_store != NULL) {
  802bbe:	48 85 db             	test   %rbx,%rbx
  802bc1:	74 06                	je     802bc9 <ipc_recv+0x8a>
            *from_env_store = 0;
  802bc3:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802bc9:	4d 85 e4             	test   %r12,%r12
  802bcc:	74 eb                	je     802bb9 <ipc_recv+0x7a>
            *perm_store = 0;
  802bce:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802bd5:	00 
  802bd6:	eb e1                	jmp    802bb9 <ipc_recv+0x7a>

0000000000802bd8 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802bd8:	f3 0f 1e fa          	endbr64
  802bdc:	55                   	push   %rbp
  802bdd:	48 89 e5             	mov    %rsp,%rbp
  802be0:	41 57                	push   %r15
  802be2:	41 56                	push   %r14
  802be4:	41 55                	push   %r13
  802be6:	41 54                	push   %r12
  802be8:	53                   	push   %rbx
  802be9:	48 83 ec 18          	sub    $0x18,%rsp
  802bed:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802bf0:	48 89 d3             	mov    %rdx,%rbx
  802bf3:	49 89 cc             	mov    %rcx,%r12
  802bf6:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802bf9:	48 85 d2             	test   %rdx,%rdx
  802bfc:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802c03:	00 00 00 
  802c06:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c0a:	89 f0                	mov    %esi,%eax
  802c0c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802c10:	48 89 da             	mov    %rbx,%rdx
  802c13:	48 89 c6             	mov    %rax,%rsi
  802c16:	48 b8 5f 14 80 00 00 	movabs $0x80145f,%rax
  802c1d:	00 00 00 
  802c20:	ff d0                	call   *%rax
    while (res < 0) {
  802c22:	85 c0                	test   %eax,%eax
  802c24:	79 65                	jns    802c8b <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c26:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c29:	75 33                	jne    802c5e <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802c2b:	49 bf d2 10 80 00 00 	movabs $0x8010d2,%r15
  802c32:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c35:	49 be 5f 14 80 00 00 	movabs $0x80145f,%r14
  802c3c:	00 00 00 
        sys_yield();
  802c3f:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c42:	45 89 e8             	mov    %r13d,%r8d
  802c45:	4c 89 e1             	mov    %r12,%rcx
  802c48:	48 89 da             	mov    %rbx,%rdx
  802c4b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802c4f:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802c52:	41 ff d6             	call   *%r14
    while (res < 0) {
  802c55:	85 c0                	test   %eax,%eax
  802c57:	79 32                	jns    802c8b <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c59:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c5c:	74 e1                	je     802c3f <ipc_send+0x67>
            panic("Error: %i\n", res);
  802c5e:	89 c1                	mov    %eax,%ecx
  802c60:	48 ba 45 32 80 00 00 	movabs $0x803245,%rdx
  802c67:	00 00 00 
  802c6a:	be 42 00 00 00       	mov    $0x42,%esi
  802c6f:	48 bf 50 32 80 00 00 	movabs $0x803250,%rdi
  802c76:	00 00 00 
  802c79:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7e:	49 b8 98 2a 80 00 00 	movabs $0x802a98,%r8
  802c85:	00 00 00 
  802c88:	41 ff d0             	call   *%r8
    }
}
  802c8b:	48 83 c4 18          	add    $0x18,%rsp
  802c8f:	5b                   	pop    %rbx
  802c90:	41 5c                	pop    %r12
  802c92:	41 5d                	pop    %r13
  802c94:	41 5e                	pop    %r14
  802c96:	41 5f                	pop    %r15
  802c98:	5d                   	pop    %rbp
  802c99:	c3                   	ret

0000000000802c9a <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802c9a:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802c9e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802ca3:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802caa:	00 00 00 
  802cad:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802cb1:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802cb5:	48 c1 e2 04          	shl    $0x4,%rdx
  802cb9:	48 01 ca             	add    %rcx,%rdx
  802cbc:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802cc2:	39 fa                	cmp    %edi,%edx
  802cc4:	74 12                	je     802cd8 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802cc6:	48 83 c0 01          	add    $0x1,%rax
  802cca:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802cd0:	75 db                	jne    802cad <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cd7:	c3                   	ret
            return envs[i].env_id;
  802cd8:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802cdc:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802ce0:	48 c1 e2 04          	shl    $0x4,%rdx
  802ce4:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802ceb:	00 00 00 
  802cee:	48 01 d0             	add    %rdx,%rax
  802cf1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cf7:	c3                   	ret

0000000000802cf8 <__text_end>:
  802cf8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802cff:	00 00 00 
  802d02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d09:	00 00 00 
  802d0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d13:	00 00 00 
  802d16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d1d:	00 00 00 
  802d20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d27:	00 00 00 
  802d2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d31:	00 00 00 
  802d34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d3b:	00 00 00 
  802d3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d45:	00 00 00 
  802d48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d4f:	00 00 00 
  802d52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d59:	00 00 00 
  802d5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d63:	00 00 00 
  802d66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d6d:	00 00 00 
  802d70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d77:	00 00 00 
  802d7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d81:	00 00 00 
  802d84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d8b:	00 00 00 
  802d8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d95:	00 00 00 
  802d98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d9f:	00 00 00 
  802da2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802da9:	00 00 00 
  802dac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802db3:	00 00 00 
  802db6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dbd:	00 00 00 
  802dc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dc7:	00 00 00 
  802dca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd1:	00 00 00 
  802dd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ddb:	00 00 00 
  802dde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de5:	00 00 00 
  802de8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802def:	00 00 00 
  802df2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df9:	00 00 00 
  802dfc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e03:	00 00 00 
  802e06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e0d:	00 00 00 
  802e10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e17:	00 00 00 
  802e1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e21:	00 00 00 
  802e24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e2b:	00 00 00 
  802e2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e35:	00 00 00 
  802e38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e3f:	00 00 00 
  802e42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e49:	00 00 00 
  802e4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e53:	00 00 00 
  802e56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e5d:	00 00 00 
  802e60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e67:	00 00 00 
  802e6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e71:	00 00 00 
  802e74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e7b:	00 00 00 
  802e7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e85:	00 00 00 
  802e88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e8f:	00 00 00 
  802e92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e99:	00 00 00 
  802e9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea3:	00 00 00 
  802ea6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ead:	00 00 00 
  802eb0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb7:	00 00 00 
  802eba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec1:	00 00 00 
  802ec4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ecb:	00 00 00 
  802ece:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed5:	00 00 00 
  802ed8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802edf:	00 00 00 
  802ee2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee9:	00 00 00 
  802eec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef3:	00 00 00 
  802ef6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802efd:	00 00 00 
  802f00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f07:	00 00 00 
  802f0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f11:	00 00 00 
  802f14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f1b:	00 00 00 
  802f1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f25:	00 00 00 
  802f28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f2f:	00 00 00 
  802f32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f39:	00 00 00 
  802f3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f43:	00 00 00 
  802f46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f4d:	00 00 00 
  802f50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f57:	00 00 00 
  802f5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f61:	00 00 00 
  802f64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f6b:	00 00 00 
  802f6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f75:	00 00 00 
  802f78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f7f:	00 00 00 
  802f82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f89:	00 00 00 
  802f8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f93:	00 00 00 
  802f96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f9d:	00 00 00 
  802fa0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa7:	00 00 00 
  802faa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb1:	00 00 00 
  802fb4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fbb:	00 00 00 
  802fbe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc5:	00 00 00 
  802fc8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fcf:	00 00 00 
  802fd2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd9:	00 00 00 
  802fdc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe3:	00 00 00 
  802fe6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fed:	00 00 00 
  802ff0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff7:	00 00 00 
  802ffa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
