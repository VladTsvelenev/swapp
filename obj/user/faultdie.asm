
obj/user/faultdie:     file format elf64-x86-64


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
  80001e:	e8 7a 00 00 00       	call   80009d <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <handler>:
/* Test user-level fault handler -- just exit when we fault */

#include <inc/lib.h>

bool
handler(struct UTrapframe *utf) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
    void *addr = (void *)utf->utf_fault_va;
    uint64_t err = utf->utf_err;
    cprintf("i faulted at va %lx, err %x\n",
  80002d:	8b 57 08             	mov    0x8(%rdi),%edx
  800030:	83 e2 07             	and    $0x7,%edx
  800033:	48 8b 37             	mov    (%rdi),%rsi
  800036:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  80003d:	00 00 00 
  800040:	b8 00 00 00 00       	mov    $0x0,%eax
  800045:	48 b9 2b 02 80 00 00 	movabs $0x80022b,%rcx
  80004c:	00 00 00 
  80004f:	ff d1                	call   *%rcx
            (unsigned long)addr, (unsigned)(err & 7));
    sys_env_destroy(sys_getenvid());
  800051:	48 b8 a9 10 80 00 00 	movabs $0x8010a9,%rax
  800058:	00 00 00 
  80005b:	ff d0                	call   *%rax
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	48 b8 3a 10 80 00 00 	movabs $0x80103a,%rax
  800066:	00 00 00 
  800069:	ff d0                	call   *%rax
    return 1;
}
  80006b:	b8 01 00 00 00       	mov    $0x1,%eax
  800070:	5d                   	pop    %rbp
  800071:	c3                   	ret

0000000000800072 <umain>:

void
umain(int argc, char **argv) {
  800072:	f3 0f 1e fa          	endbr64
  800076:	55                   	push   %rbp
  800077:	48 89 e5             	mov    %rsp,%rbp
    add_pgfault_handler(handler);
  80007a:	48 bf 25 00 80 00 00 	movabs $0x800025,%rdi
  800081:	00 00 00 
  800084:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  80008b:	00 00 00 
  80008e:	ff d0                	call   *%rax
    *(volatile int *)0xDEADBEEF = 0;
  800090:	b8 ef be ad de       	mov    $0xdeadbeef,%eax
  800095:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  80009b:	5d                   	pop    %rbp
  80009c:	c3                   	ret

000000000080009d <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80009d:	f3 0f 1e fa          	endbr64
  8000a1:	55                   	push   %rbp
  8000a2:	48 89 e5             	mov    %rsp,%rbp
  8000a5:	41 56                	push   %r14
  8000a7:	41 55                	push   %r13
  8000a9:	41 54                	push   %r12
  8000ab:	53                   	push   %rbx
  8000ac:	41 89 fd             	mov    %edi,%r13d
  8000af:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8000b2:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  8000b9:	00 00 00 
  8000bc:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  8000c3:	00 00 00 
  8000c6:	48 39 c2             	cmp    %rax,%rdx
  8000c9:	73 17                	jae    8000e2 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8000cb:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8000ce:	49 89 c4             	mov    %rax,%r12
  8000d1:	48 83 c3 08          	add    $0x8,%rbx
  8000d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000da:	ff 53 f8             	call   *-0x8(%rbx)
  8000dd:	4c 39 e3             	cmp    %r12,%rbx
  8000e0:	72 ef                	jb     8000d1 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8000e2:	48 b8 a9 10 80 00 00 	movabs $0x8010a9,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	call   *%rax
  8000ee:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f3:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000f7:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000fb:	48 c1 e0 04          	shl    $0x4,%rax
  8000ff:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800106:	00 00 00 
  800109:	48 01 d0             	add    %rdx,%rax
  80010c:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  800113:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800116:	45 85 ed             	test   %r13d,%r13d
  800119:	7e 0d                	jle    800128 <libmain+0x8b>
  80011b:	49 8b 06             	mov    (%r14),%rax
  80011e:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800125:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800128:	4c 89 f6             	mov    %r14,%rsi
  80012b:	44 89 ef             	mov    %r13d,%edi
  80012e:	48 b8 72 00 80 00 00 	movabs $0x800072,%rax
  800135:	00 00 00 
  800138:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80013a:	48 b8 4f 01 80 00 00 	movabs $0x80014f,%rax
  800141:	00 00 00 
  800144:	ff d0                	call   *%rax
#endif
}
  800146:	5b                   	pop    %rbx
  800147:	41 5c                	pop    %r12
  800149:	41 5d                	pop    %r13
  80014b:	41 5e                	pop    %r14
  80014d:	5d                   	pop    %rbp
  80014e:	c3                   	ret

000000000080014f <exit>:

#include <inc/lib.h>

void
exit(void) {
  80014f:	f3 0f 1e fa          	endbr64
  800153:	55                   	push   %rbp
  800154:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800157:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  80015e:	00 00 00 
  800161:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800163:	bf 00 00 00 00       	mov    $0x0,%edi
  800168:	48 b8 3a 10 80 00 00 	movabs $0x80103a,%rax
  80016f:	00 00 00 
  800172:	ff d0                	call   *%rax
}
  800174:	5d                   	pop    %rbp
  800175:	c3                   	ret

0000000000800176 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800176:	f3 0f 1e fa          	endbr64
  80017a:	55                   	push   %rbp
  80017b:	48 89 e5             	mov    %rsp,%rbp
  80017e:	53                   	push   %rbx
  80017f:	48 83 ec 08          	sub    $0x8,%rsp
  800183:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800186:	8b 06                	mov    (%rsi),%eax
  800188:	8d 50 01             	lea    0x1(%rax),%edx
  80018b:	89 16                	mov    %edx,(%rsi)
  80018d:	48 98                	cltq
  80018f:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800194:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80019a:	74 0a                	je     8001a6 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80019c:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8001a0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001a4:	c9                   	leave
  8001a5:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  8001a6:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8001aa:	be ff 00 00 00       	mov    $0xff,%esi
  8001af:	48 b8 d4 0f 80 00 00 	movabs $0x800fd4,%rax
  8001b6:	00 00 00 
  8001b9:	ff d0                	call   *%rax
        state->offset = 0;
  8001bb:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8001c1:	eb d9                	jmp    80019c <putch+0x26>

00000000008001c3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8001c3:	f3 0f 1e fa          	endbr64
  8001c7:	55                   	push   %rbp
  8001c8:	48 89 e5             	mov    %rsp,%rbp
  8001cb:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8001d2:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8001d5:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8001dc:	b9 21 00 00 00       	mov    $0x21,%ecx
  8001e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e6:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8001e9:	48 89 f1             	mov    %rsi,%rcx
  8001ec:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8001f3:	48 bf 76 01 80 00 00 	movabs $0x800176,%rdi
  8001fa:	00 00 00 
  8001fd:	48 b8 8b 03 80 00 00 	movabs $0x80038b,%rax
  800204:	00 00 00 
  800207:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800209:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800210:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800217:	48 b8 d4 0f 80 00 00 	movabs $0x800fd4,%rax
  80021e:	00 00 00 
  800221:	ff d0                	call   *%rax

    return state.count;
}
  800223:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800229:	c9                   	leave
  80022a:	c3                   	ret

000000000080022b <cprintf>:

int
cprintf(const char *fmt, ...) {
  80022b:	f3 0f 1e fa          	endbr64
  80022f:	55                   	push   %rbp
  800230:	48 89 e5             	mov    %rsp,%rbp
  800233:	48 83 ec 50          	sub    $0x50,%rsp
  800237:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80023b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80023f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800243:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800247:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  80024b:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800252:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800256:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80025a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80025e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800262:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800266:	48 b8 c3 01 80 00 00 	movabs $0x8001c3,%rax
  80026d:	00 00 00 
  800270:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800272:	c9                   	leave
  800273:	c3                   	ret

0000000000800274 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800274:	f3 0f 1e fa          	endbr64
  800278:	55                   	push   %rbp
  800279:	48 89 e5             	mov    %rsp,%rbp
  80027c:	41 57                	push   %r15
  80027e:	41 56                	push   %r14
  800280:	41 55                	push   %r13
  800282:	41 54                	push   %r12
  800284:	53                   	push   %rbx
  800285:	48 83 ec 18          	sub    $0x18,%rsp
  800289:	49 89 fc             	mov    %rdi,%r12
  80028c:	49 89 f5             	mov    %rsi,%r13
  80028f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800293:	8b 45 10             	mov    0x10(%rbp),%eax
  800296:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800299:	41 89 cf             	mov    %ecx,%r15d
  80029c:	4c 39 fa             	cmp    %r15,%rdx
  80029f:	73 5b                	jae    8002fc <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8002a1:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8002a5:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8002a9:	85 db                	test   %ebx,%ebx
  8002ab:	7e 0e                	jle    8002bb <print_num+0x47>
            putch(padc, put_arg);
  8002ad:	4c 89 ee             	mov    %r13,%rsi
  8002b0:	44 89 f7             	mov    %r14d,%edi
  8002b3:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8002b6:	83 eb 01             	sub    $0x1,%ebx
  8002b9:	75 f2                	jne    8002ad <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8002bb:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8002bf:	48 b9 38 40 80 00 00 	movabs $0x804038,%rcx
  8002c6:	00 00 00 
  8002c9:	48 b8 27 40 80 00 00 	movabs $0x804027,%rax
  8002d0:	00 00 00 
  8002d3:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8002d7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002db:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e0:	49 f7 f7             	div    %r15
  8002e3:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8002e7:	4c 89 ee             	mov    %r13,%rsi
  8002ea:	41 ff d4             	call   *%r12
}
  8002ed:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8002f1:	5b                   	pop    %rbx
  8002f2:	41 5c                	pop    %r12
  8002f4:	41 5d                	pop    %r13
  8002f6:	41 5e                	pop    %r14
  8002f8:	41 5f                	pop    %r15
  8002fa:	5d                   	pop    %rbp
  8002fb:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8002fc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800300:	ba 00 00 00 00       	mov    $0x0,%edx
  800305:	49 f7 f7             	div    %r15
  800308:	48 83 ec 08          	sub    $0x8,%rsp
  80030c:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800310:	52                   	push   %rdx
  800311:	45 0f be c9          	movsbl %r9b,%r9d
  800315:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800319:	48 89 c2             	mov    %rax,%rdx
  80031c:	48 b8 74 02 80 00 00 	movabs $0x800274,%rax
  800323:	00 00 00 
  800326:	ff d0                	call   *%rax
  800328:	48 83 c4 10          	add    $0x10,%rsp
  80032c:	eb 8d                	jmp    8002bb <print_num+0x47>

000000000080032e <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  80032e:	f3 0f 1e fa          	endbr64
    state->count++;
  800332:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800336:	48 8b 06             	mov    (%rsi),%rax
  800339:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80033d:	73 0a                	jae    800349 <sprintputch+0x1b>
        *state->start++ = ch;
  80033f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800343:	48 89 16             	mov    %rdx,(%rsi)
  800346:	40 88 38             	mov    %dil,(%rax)
    }
}
  800349:	c3                   	ret

000000000080034a <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80034a:	f3 0f 1e fa          	endbr64
  80034e:	55                   	push   %rbp
  80034f:	48 89 e5             	mov    %rsp,%rbp
  800352:	48 83 ec 50          	sub    $0x50,%rsp
  800356:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80035a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80035e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800362:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800369:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80036d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800371:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800375:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800379:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80037d:	48 b8 8b 03 80 00 00 	movabs $0x80038b,%rax
  800384:	00 00 00 
  800387:	ff d0                	call   *%rax
}
  800389:	c9                   	leave
  80038a:	c3                   	ret

000000000080038b <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80038b:	f3 0f 1e fa          	endbr64
  80038f:	55                   	push   %rbp
  800390:	48 89 e5             	mov    %rsp,%rbp
  800393:	41 57                	push   %r15
  800395:	41 56                	push   %r14
  800397:	41 55                	push   %r13
  800399:	41 54                	push   %r12
  80039b:	53                   	push   %rbx
  80039c:	48 83 ec 38          	sub    $0x38,%rsp
  8003a0:	49 89 fe             	mov    %rdi,%r14
  8003a3:	49 89 f5             	mov    %rsi,%r13
  8003a6:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  8003a9:	48 8b 01             	mov    (%rcx),%rax
  8003ac:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8003b0:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8003b4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003b8:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8003bc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8003c0:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  8003c4:	0f b6 3b             	movzbl (%rbx),%edi
  8003c7:	40 80 ff 25          	cmp    $0x25,%dil
  8003cb:	74 18                	je     8003e5 <vprintfmt+0x5a>
            if (!ch) return;
  8003cd:	40 84 ff             	test   %dil,%dil
  8003d0:	0f 84 b2 06 00 00    	je     800a88 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8003d6:	40 0f b6 ff          	movzbl %dil,%edi
  8003da:	4c 89 ee             	mov    %r13,%rsi
  8003dd:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8003e0:	4c 89 e3             	mov    %r12,%rbx
  8003e3:	eb db                	jmp    8003c0 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8003e5:	be 00 00 00 00       	mov    $0x0,%esi
  8003ea:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8003f3:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8003f9:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800400:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800404:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800409:	41 0f b6 04 24       	movzbl (%r12),%eax
  80040e:	88 45 a0             	mov    %al,-0x60(%rbp)
  800411:	83 e8 23             	sub    $0x23,%eax
  800414:	3c 57                	cmp    $0x57,%al
  800416:	0f 87 52 06 00 00    	ja     800a6e <vprintfmt+0x6e3>
  80041c:	0f b6 c0             	movzbl %al,%eax
  80041f:	48 b9 c0 42 80 00 00 	movabs $0x8042c0,%rcx
  800426:	00 00 00 
  800429:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  80042d:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800430:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  800434:	eb ce                	jmp    800404 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800436:	49 89 dc             	mov    %rbx,%r12
  800439:	be 01 00 00 00       	mov    $0x1,%esi
  80043e:	eb c4                	jmp    800404 <vprintfmt+0x79>
            padc = ch;
  800440:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800444:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800447:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80044a:	eb b8                	jmp    800404 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80044c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80044f:	83 f8 2f             	cmp    $0x2f,%eax
  800452:	77 24                	ja     800478 <vprintfmt+0xed>
  800454:	89 c1                	mov    %eax,%ecx
  800456:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  80045a:	83 c0 08             	add    $0x8,%eax
  80045d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800460:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800463:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800466:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80046a:	79 98                	jns    800404 <vprintfmt+0x79>
                width = precision;
  80046c:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800470:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800476:	eb 8c                	jmp    800404 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800478:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80047c:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800480:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800484:	eb da                	jmp    800460 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800486:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  80048b:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80048f:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800495:	3c 39                	cmp    $0x39,%al
  800497:	77 1c                	ja     8004b5 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800499:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  80049d:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  8004a1:	0f b6 c0             	movzbl %al,%eax
  8004a4:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8004a9:	0f b6 03             	movzbl (%rbx),%eax
  8004ac:	3c 39                	cmp    $0x39,%al
  8004ae:	76 e9                	jbe    800499 <vprintfmt+0x10e>
        process_precision:
  8004b0:	49 89 dc             	mov    %rbx,%r12
  8004b3:	eb b1                	jmp    800466 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  8004b5:	49 89 dc             	mov    %rbx,%r12
  8004b8:	eb ac                	jmp    800466 <vprintfmt+0xdb>
            width = MAX(0, width);
  8004ba:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  8004bd:	85 c9                	test   %ecx,%ecx
  8004bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c4:	0f 49 c1             	cmovns %ecx,%eax
  8004c7:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8004ca:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8004cd:	e9 32 ff ff ff       	jmp    800404 <vprintfmt+0x79>
            lflag++;
  8004d2:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8004d5:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8004d8:	e9 27 ff ff ff       	jmp    800404 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8004dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004e0:	83 f8 2f             	cmp    $0x2f,%eax
  8004e3:	77 19                	ja     8004fe <vprintfmt+0x173>
  8004e5:	89 c2                	mov    %eax,%edx
  8004e7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8004eb:	83 c0 08             	add    $0x8,%eax
  8004ee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004f1:	8b 3a                	mov    (%rdx),%edi
  8004f3:	4c 89 ee             	mov    %r13,%rsi
  8004f6:	41 ff d6             	call   *%r14
            break;
  8004f9:	e9 c2 fe ff ff       	jmp    8003c0 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8004fe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800502:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800506:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80050a:	eb e5                	jmp    8004f1 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  80050c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80050f:	83 f8 2f             	cmp    $0x2f,%eax
  800512:	77 5a                	ja     80056e <vprintfmt+0x1e3>
  800514:	89 c2                	mov    %eax,%edx
  800516:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80051a:	83 c0 08             	add    $0x8,%eax
  80051d:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800520:	8b 02                	mov    (%rdx),%eax
  800522:	89 c1                	mov    %eax,%ecx
  800524:	f7 d9                	neg    %ecx
  800526:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800529:	83 f9 13             	cmp    $0x13,%ecx
  80052c:	7f 4e                	jg     80057c <vprintfmt+0x1f1>
  80052e:	48 63 c1             	movslq %ecx,%rax
  800531:	48 ba 80 45 80 00 00 	movabs $0x804580,%rdx
  800538:	00 00 00 
  80053b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80053f:	48 85 c0             	test   %rax,%rax
  800542:	74 38                	je     80057c <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  800544:	48 89 c1             	mov    %rax,%rcx
  800547:	48 ba 16 42 80 00 00 	movabs $0x804216,%rdx
  80054e:	00 00 00 
  800551:	4c 89 ee             	mov    %r13,%rsi
  800554:	4c 89 f7             	mov    %r14,%rdi
  800557:	b8 00 00 00 00       	mov    $0x0,%eax
  80055c:	49 b8 4a 03 80 00 00 	movabs $0x80034a,%r8
  800563:	00 00 00 
  800566:	41 ff d0             	call   *%r8
  800569:	e9 52 fe ff ff       	jmp    8003c0 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  80056e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800572:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800576:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80057a:	eb a4                	jmp    800520 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  80057c:	48 ba 50 40 80 00 00 	movabs $0x804050,%rdx
  800583:	00 00 00 
  800586:	4c 89 ee             	mov    %r13,%rsi
  800589:	4c 89 f7             	mov    %r14,%rdi
  80058c:	b8 00 00 00 00       	mov    $0x0,%eax
  800591:	49 b8 4a 03 80 00 00 	movabs $0x80034a,%r8
  800598:	00 00 00 
  80059b:	41 ff d0             	call   *%r8
  80059e:	e9 1d fe ff ff       	jmp    8003c0 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8005a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005a6:	83 f8 2f             	cmp    $0x2f,%eax
  8005a9:	77 6c                	ja     800617 <vprintfmt+0x28c>
  8005ab:	89 c2                	mov    %eax,%edx
  8005ad:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8005b1:	83 c0 08             	add    $0x8,%eax
  8005b4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005b7:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8005ba:	48 85 d2             	test   %rdx,%rdx
  8005bd:	48 b8 49 40 80 00 00 	movabs $0x804049,%rax
  8005c4:	00 00 00 
  8005c7:	48 0f 45 c2          	cmovne %rdx,%rax
  8005cb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8005cf:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8005d3:	7e 06                	jle    8005db <vprintfmt+0x250>
  8005d5:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8005d9:	75 4a                	jne    800625 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8005db:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8005df:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8005e3:	0f b6 00             	movzbl (%rax),%eax
  8005e6:	84 c0                	test   %al,%al
  8005e8:	0f 85 9a 00 00 00    	jne    800688 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8005ee:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005f1:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8005f5:	85 c0                	test   %eax,%eax
  8005f7:	0f 8e c3 fd ff ff    	jle    8003c0 <vprintfmt+0x35>
  8005fd:	4c 89 ee             	mov    %r13,%rsi
  800600:	bf 20 00 00 00       	mov    $0x20,%edi
  800605:	41 ff d6             	call   *%r14
  800608:	41 83 ec 01          	sub    $0x1,%r12d
  80060c:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800610:	75 eb                	jne    8005fd <vprintfmt+0x272>
  800612:	e9 a9 fd ff ff       	jmp    8003c0 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800617:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80061b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80061f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800623:	eb 92                	jmp    8005b7 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800625:	49 63 f7             	movslq %r15d,%rsi
  800628:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80062c:	48 b8 4e 0b 80 00 00 	movabs $0x800b4e,%rax
  800633:	00 00 00 
  800636:	ff d0                	call   *%rax
  800638:	48 89 c2             	mov    %rax,%rdx
  80063b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80063e:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800640:	8d 70 ff             	lea    -0x1(%rax),%esi
  800643:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800646:	85 c0                	test   %eax,%eax
  800648:	7e 91                	jle    8005db <vprintfmt+0x250>
  80064a:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80064f:	4c 89 ee             	mov    %r13,%rsi
  800652:	44 89 e7             	mov    %r12d,%edi
  800655:	41 ff d6             	call   *%r14
  800658:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80065c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80065f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800662:	75 eb                	jne    80064f <vprintfmt+0x2c4>
  800664:	e9 72 ff ff ff       	jmp    8005db <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800669:	0f b6 f8             	movzbl %al,%edi
  80066c:	4c 89 ee             	mov    %r13,%rsi
  80066f:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800672:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800676:	49 83 c4 01          	add    $0x1,%r12
  80067a:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800680:	84 c0                	test   %al,%al
  800682:	0f 84 66 ff ff ff    	je     8005ee <vprintfmt+0x263>
  800688:	45 85 ff             	test   %r15d,%r15d
  80068b:	78 0a                	js     800697 <vprintfmt+0x30c>
  80068d:	41 83 ef 01          	sub    $0x1,%r15d
  800691:	0f 88 57 ff ff ff    	js     8005ee <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800697:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  80069b:	74 cc                	je     800669 <vprintfmt+0x2de>
  80069d:	8d 50 e0             	lea    -0x20(%rax),%edx
  8006a0:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8006a5:	80 fa 5e             	cmp    $0x5e,%dl
  8006a8:	77 c2                	ja     80066c <vprintfmt+0x2e1>
  8006aa:	eb bd                	jmp    800669 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8006ac:	40 84 f6             	test   %sil,%sil
  8006af:	75 26                	jne    8006d7 <vprintfmt+0x34c>
    switch (lflag) {
  8006b1:	85 d2                	test   %edx,%edx
  8006b3:	74 59                	je     80070e <vprintfmt+0x383>
  8006b5:	83 fa 01             	cmp    $0x1,%edx
  8006b8:	74 7b                	je     800735 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8006ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006bd:	83 f8 2f             	cmp    $0x2f,%eax
  8006c0:	0f 87 96 00 00 00    	ja     80075c <vprintfmt+0x3d1>
  8006c6:	89 c2                	mov    %eax,%edx
  8006c8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006cc:	83 c0 08             	add    $0x8,%eax
  8006cf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006d2:	4c 8b 22             	mov    (%rdx),%r12
  8006d5:	eb 17                	jmp    8006ee <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8006d7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006da:	83 f8 2f             	cmp    $0x2f,%eax
  8006dd:	77 21                	ja     800700 <vprintfmt+0x375>
  8006df:	89 c2                	mov    %eax,%edx
  8006e1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006e5:	83 c0 08             	add    $0x8,%eax
  8006e8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006eb:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8006ee:	4d 85 e4             	test   %r12,%r12
  8006f1:	78 7a                	js     80076d <vprintfmt+0x3e2>
            num = i;
  8006f3:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8006f6:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006fb:	e9 50 02 00 00       	jmp    800950 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800700:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800704:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800708:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80070c:	eb dd                	jmp    8006eb <vprintfmt+0x360>
        return va_arg(*ap, int);
  80070e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800711:	83 f8 2f             	cmp    $0x2f,%eax
  800714:	77 11                	ja     800727 <vprintfmt+0x39c>
  800716:	89 c2                	mov    %eax,%edx
  800718:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80071c:	83 c0 08             	add    $0x8,%eax
  80071f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800722:	4c 63 22             	movslq (%rdx),%r12
  800725:	eb c7                	jmp    8006ee <vprintfmt+0x363>
  800727:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80072b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80072f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800733:	eb ed                	jmp    800722 <vprintfmt+0x397>
        return va_arg(*ap, long);
  800735:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800738:	83 f8 2f             	cmp    $0x2f,%eax
  80073b:	77 11                	ja     80074e <vprintfmt+0x3c3>
  80073d:	89 c2                	mov    %eax,%edx
  80073f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800743:	83 c0 08             	add    $0x8,%eax
  800746:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800749:	4c 8b 22             	mov    (%rdx),%r12
  80074c:	eb a0                	jmp    8006ee <vprintfmt+0x363>
  80074e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800752:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800756:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80075a:	eb ed                	jmp    800749 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  80075c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800760:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800764:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800768:	e9 65 ff ff ff       	jmp    8006d2 <vprintfmt+0x347>
                putch('-', put_arg);
  80076d:	4c 89 ee             	mov    %r13,%rsi
  800770:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800775:	41 ff d6             	call   *%r14
                i = -i;
  800778:	49 f7 dc             	neg    %r12
  80077b:	e9 73 ff ff ff       	jmp    8006f3 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800780:	40 84 f6             	test   %sil,%sil
  800783:	75 32                	jne    8007b7 <vprintfmt+0x42c>
    switch (lflag) {
  800785:	85 d2                	test   %edx,%edx
  800787:	74 5d                	je     8007e6 <vprintfmt+0x45b>
  800789:	83 fa 01             	cmp    $0x1,%edx
  80078c:	0f 84 82 00 00 00    	je     800814 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800792:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800795:	83 f8 2f             	cmp    $0x2f,%eax
  800798:	0f 87 a5 00 00 00    	ja     800843 <vprintfmt+0x4b8>
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007a4:	83 c0 08             	add    $0x8,%eax
  8007a7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007aa:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8007ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8007b2:	e9 99 01 00 00       	jmp    800950 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8007b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ba:	83 f8 2f             	cmp    $0x2f,%eax
  8007bd:	77 19                	ja     8007d8 <vprintfmt+0x44d>
  8007bf:	89 c2                	mov    %eax,%edx
  8007c1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007c5:	83 c0 08             	add    $0x8,%eax
  8007c8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007cb:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8007ce:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8007d3:	e9 78 01 00 00       	jmp    800950 <vprintfmt+0x5c5>
  8007d8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007dc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007e0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007e4:	eb e5                	jmp    8007cb <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8007e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e9:	83 f8 2f             	cmp    $0x2f,%eax
  8007ec:	77 18                	ja     800806 <vprintfmt+0x47b>
  8007ee:	89 c2                	mov    %eax,%edx
  8007f0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007f4:	83 c0 08             	add    $0x8,%eax
  8007f7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007fa:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8007fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800801:	e9 4a 01 00 00       	jmp    800950 <vprintfmt+0x5c5>
  800806:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80080a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80080e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800812:	eb e6                	jmp    8007fa <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800814:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800817:	83 f8 2f             	cmp    $0x2f,%eax
  80081a:	77 19                	ja     800835 <vprintfmt+0x4aa>
  80081c:	89 c2                	mov    %eax,%edx
  80081e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800822:	83 c0 08             	add    $0x8,%eax
  800825:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800828:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80082b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800830:	e9 1b 01 00 00       	jmp    800950 <vprintfmt+0x5c5>
  800835:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800839:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80083d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800841:	eb e5                	jmp    800828 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800843:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800847:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80084b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80084f:	e9 56 ff ff ff       	jmp    8007aa <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800854:	40 84 f6             	test   %sil,%sil
  800857:	75 2e                	jne    800887 <vprintfmt+0x4fc>
    switch (lflag) {
  800859:	85 d2                	test   %edx,%edx
  80085b:	74 59                	je     8008b6 <vprintfmt+0x52b>
  80085d:	83 fa 01             	cmp    $0x1,%edx
  800860:	74 7f                	je     8008e1 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800862:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800865:	83 f8 2f             	cmp    $0x2f,%eax
  800868:	0f 87 9f 00 00 00    	ja     80090d <vprintfmt+0x582>
  80086e:	89 c2                	mov    %eax,%edx
  800870:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800874:	83 c0 08             	add    $0x8,%eax
  800877:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80087a:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80087d:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800882:	e9 c9 00 00 00       	jmp    800950 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800887:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088a:	83 f8 2f             	cmp    $0x2f,%eax
  80088d:	77 19                	ja     8008a8 <vprintfmt+0x51d>
  80088f:	89 c2                	mov    %eax,%edx
  800891:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800895:	83 c0 08             	add    $0x8,%eax
  800898:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80089b:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80089e:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8008a3:	e9 a8 00 00 00       	jmp    800950 <vprintfmt+0x5c5>
  8008a8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008ac:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008b0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008b4:	eb e5                	jmp    80089b <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8008b6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b9:	83 f8 2f             	cmp    $0x2f,%eax
  8008bc:	77 15                	ja     8008d3 <vprintfmt+0x548>
  8008be:	89 c2                	mov    %eax,%edx
  8008c0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008c4:	83 c0 08             	add    $0x8,%eax
  8008c7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008ca:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8008cc:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8008d1:	eb 7d                	jmp    800950 <vprintfmt+0x5c5>
  8008d3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008d7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008db:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008df:	eb e9                	jmp    8008ca <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8008e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e4:	83 f8 2f             	cmp    $0x2f,%eax
  8008e7:	77 16                	ja     8008ff <vprintfmt+0x574>
  8008e9:	89 c2                	mov    %eax,%edx
  8008eb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008ef:	83 c0 08             	add    $0x8,%eax
  8008f2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008f5:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8008f8:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008fd:	eb 51                	jmp    800950 <vprintfmt+0x5c5>
  8008ff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800903:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800907:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80090b:	eb e8                	jmp    8008f5 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  80090d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800911:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800915:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800919:	e9 5c ff ff ff       	jmp    80087a <vprintfmt+0x4ef>
            putch('0', put_arg);
  80091e:	4c 89 ee             	mov    %r13,%rsi
  800921:	bf 30 00 00 00       	mov    $0x30,%edi
  800926:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800929:	4c 89 ee             	mov    %r13,%rsi
  80092c:	bf 78 00 00 00       	mov    $0x78,%edi
  800931:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800934:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800937:	83 f8 2f             	cmp    $0x2f,%eax
  80093a:	77 47                	ja     800983 <vprintfmt+0x5f8>
  80093c:	89 c2                	mov    %eax,%edx
  80093e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800942:	83 c0 08             	add    $0x8,%eax
  800945:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800948:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80094b:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800950:	48 83 ec 08          	sub    $0x8,%rsp
  800954:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800958:	0f 94 c0             	sete   %al
  80095b:	0f b6 c0             	movzbl %al,%eax
  80095e:	50                   	push   %rax
  80095f:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800964:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800968:	4c 89 ee             	mov    %r13,%rsi
  80096b:	4c 89 f7             	mov    %r14,%rdi
  80096e:	48 b8 74 02 80 00 00 	movabs $0x800274,%rax
  800975:	00 00 00 
  800978:	ff d0                	call   *%rax
            break;
  80097a:	48 83 c4 10          	add    $0x10,%rsp
  80097e:	e9 3d fa ff ff       	jmp    8003c0 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800983:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800987:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80098b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80098f:	eb b7                	jmp    800948 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800991:	40 84 f6             	test   %sil,%sil
  800994:	75 2b                	jne    8009c1 <vprintfmt+0x636>
    switch (lflag) {
  800996:	85 d2                	test   %edx,%edx
  800998:	74 56                	je     8009f0 <vprintfmt+0x665>
  80099a:	83 fa 01             	cmp    $0x1,%edx
  80099d:	74 7f                	je     800a1e <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  80099f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a2:	83 f8 2f             	cmp    $0x2f,%eax
  8009a5:	0f 87 a2 00 00 00    	ja     800a4d <vprintfmt+0x6c2>
  8009ab:	89 c2                	mov    %eax,%edx
  8009ad:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009b1:	83 c0 08             	add    $0x8,%eax
  8009b4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009b7:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009ba:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8009bf:	eb 8f                	jmp    800950 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8009c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c4:	83 f8 2f             	cmp    $0x2f,%eax
  8009c7:	77 19                	ja     8009e2 <vprintfmt+0x657>
  8009c9:	89 c2                	mov    %eax,%edx
  8009cb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009cf:	83 c0 08             	add    $0x8,%eax
  8009d2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d5:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009d8:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009dd:	e9 6e ff ff ff       	jmp    800950 <vprintfmt+0x5c5>
  8009e2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009ea:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ee:	eb e5                	jmp    8009d5 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8009f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f3:	83 f8 2f             	cmp    $0x2f,%eax
  8009f6:	77 18                	ja     800a10 <vprintfmt+0x685>
  8009f8:	89 c2                	mov    %eax,%edx
  8009fa:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009fe:	83 c0 08             	add    $0x8,%eax
  800a01:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a04:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800a06:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800a0b:	e9 40 ff ff ff       	jmp    800950 <vprintfmt+0x5c5>
  800a10:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a14:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a18:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a1c:	eb e6                	jmp    800a04 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800a1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a21:	83 f8 2f             	cmp    $0x2f,%eax
  800a24:	77 19                	ja     800a3f <vprintfmt+0x6b4>
  800a26:	89 c2                	mov    %eax,%edx
  800a28:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a2c:	83 c0 08             	add    $0x8,%eax
  800a2f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a32:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a35:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800a3a:	e9 11 ff ff ff       	jmp    800950 <vprintfmt+0x5c5>
  800a3f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a43:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a47:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a4b:	eb e5                	jmp    800a32 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800a4d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a51:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a55:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a59:	e9 59 ff ff ff       	jmp    8009b7 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800a5e:	4c 89 ee             	mov    %r13,%rsi
  800a61:	bf 25 00 00 00       	mov    $0x25,%edi
  800a66:	41 ff d6             	call   *%r14
            break;
  800a69:	e9 52 f9 ff ff       	jmp    8003c0 <vprintfmt+0x35>
            putch('%', put_arg);
  800a6e:	4c 89 ee             	mov    %r13,%rsi
  800a71:	bf 25 00 00 00       	mov    $0x25,%edi
  800a76:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800a79:	48 83 eb 01          	sub    $0x1,%rbx
  800a7d:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800a81:	75 f6                	jne    800a79 <vprintfmt+0x6ee>
  800a83:	e9 38 f9 ff ff       	jmp    8003c0 <vprintfmt+0x35>
}
  800a88:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a8c:	5b                   	pop    %rbx
  800a8d:	41 5c                	pop    %r12
  800a8f:	41 5d                	pop    %r13
  800a91:	41 5e                	pop    %r14
  800a93:	41 5f                	pop    %r15
  800a95:	5d                   	pop    %rbp
  800a96:	c3                   	ret

0000000000800a97 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a97:	f3 0f 1e fa          	endbr64
  800a9b:	55                   	push   %rbp
  800a9c:	48 89 e5             	mov    %rsp,%rbp
  800a9f:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800aa3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800aa7:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800aac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800ab0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800ab7:	48 85 ff             	test   %rdi,%rdi
  800aba:	74 2b                	je     800ae7 <vsnprintf+0x50>
  800abc:	48 85 f6             	test   %rsi,%rsi
  800abf:	74 26                	je     800ae7 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800ac1:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800ac5:	48 bf 2e 03 80 00 00 	movabs $0x80032e,%rdi
  800acc:	00 00 00 
  800acf:	48 b8 8b 03 80 00 00 	movabs $0x80038b,%rax
  800ad6:	00 00 00 
  800ad9:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800adb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adf:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800ae2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ae5:	c9                   	leave
  800ae6:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800ae7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aec:	eb f7                	jmp    800ae5 <vsnprintf+0x4e>

0000000000800aee <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800aee:	f3 0f 1e fa          	endbr64
  800af2:	55                   	push   %rbp
  800af3:	48 89 e5             	mov    %rsp,%rbp
  800af6:	48 83 ec 50          	sub    $0x50,%rsp
  800afa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800afe:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800b02:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800b06:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800b0d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b11:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b15:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800b19:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800b1d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800b21:	48 b8 97 0a 80 00 00 	movabs $0x800a97,%rax
  800b28:	00 00 00 
  800b2b:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800b2d:	c9                   	leave
  800b2e:	c3                   	ret

0000000000800b2f <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800b2f:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800b33:	80 3f 00             	cmpb   $0x0,(%rdi)
  800b36:	74 10                	je     800b48 <strlen+0x19>
    size_t n = 0;
  800b38:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800b3d:	48 83 c0 01          	add    $0x1,%rax
  800b41:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b45:	75 f6                	jne    800b3d <strlen+0xe>
  800b47:	c3                   	ret
    size_t n = 0;
  800b48:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800b4d:	c3                   	ret

0000000000800b4e <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800b4e:	f3 0f 1e fa          	endbr64
  800b52:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800b55:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800b5a:	48 85 f6             	test   %rsi,%rsi
  800b5d:	74 10                	je     800b6f <strnlen+0x21>
  800b5f:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800b63:	74 0b                	je     800b70 <strnlen+0x22>
  800b65:	48 83 c2 01          	add    $0x1,%rdx
  800b69:	48 39 d0             	cmp    %rdx,%rax
  800b6c:	75 f1                	jne    800b5f <strnlen+0x11>
  800b6e:	c3                   	ret
  800b6f:	c3                   	ret
  800b70:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800b73:	c3                   	ret

0000000000800b74 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800b74:	f3 0f 1e fa          	endbr64
  800b78:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b80:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800b84:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800b87:	48 83 c2 01          	add    $0x1,%rdx
  800b8b:	84 c9                	test   %cl,%cl
  800b8d:	75 f1                	jne    800b80 <strcpy+0xc>
        ;
    return res;
}
  800b8f:	c3                   	ret

0000000000800b90 <strcat>:

char *
strcat(char *dst, const char *src) {
  800b90:	f3 0f 1e fa          	endbr64
  800b94:	55                   	push   %rbp
  800b95:	48 89 e5             	mov    %rsp,%rbp
  800b98:	41 54                	push   %r12
  800b9a:	53                   	push   %rbx
  800b9b:	48 89 fb             	mov    %rdi,%rbx
  800b9e:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800ba1:	48 b8 2f 0b 80 00 00 	movabs $0x800b2f,%rax
  800ba8:	00 00 00 
  800bab:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800bad:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800bb1:	4c 89 e6             	mov    %r12,%rsi
  800bb4:	48 b8 74 0b 80 00 00 	movabs $0x800b74,%rax
  800bbb:	00 00 00 
  800bbe:	ff d0                	call   *%rax
    return dst;
}
  800bc0:	48 89 d8             	mov    %rbx,%rax
  800bc3:	5b                   	pop    %rbx
  800bc4:	41 5c                	pop    %r12
  800bc6:	5d                   	pop    %rbp
  800bc7:	c3                   	ret

0000000000800bc8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bc8:	f3 0f 1e fa          	endbr64
  800bcc:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800bcf:	48 85 d2             	test   %rdx,%rdx
  800bd2:	74 1f                	je     800bf3 <strncpy+0x2b>
  800bd4:	48 01 fa             	add    %rdi,%rdx
  800bd7:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800bda:	48 83 c1 01          	add    $0x1,%rcx
  800bde:	44 0f b6 06          	movzbl (%rsi),%r8d
  800be2:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800be6:	41 80 f8 01          	cmp    $0x1,%r8b
  800bea:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800bee:	48 39 ca             	cmp    %rcx,%rdx
  800bf1:	75 e7                	jne    800bda <strncpy+0x12>
    }
    return ret;
}
  800bf3:	c3                   	ret

0000000000800bf4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800bf4:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800bf8:	48 89 f8             	mov    %rdi,%rax
  800bfb:	48 85 d2             	test   %rdx,%rdx
  800bfe:	74 24                	je     800c24 <strlcpy+0x30>
        while (--size > 0 && *src)
  800c00:	48 83 ea 01          	sub    $0x1,%rdx
  800c04:	74 1b                	je     800c21 <strlcpy+0x2d>
  800c06:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c0a:	0f b6 16             	movzbl (%rsi),%edx
  800c0d:	84 d2                	test   %dl,%dl
  800c0f:	74 10                	je     800c21 <strlcpy+0x2d>
            *dst++ = *src++;
  800c11:	48 83 c6 01          	add    $0x1,%rsi
  800c15:	48 83 c0 01          	add    $0x1,%rax
  800c19:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800c1c:	48 39 c8             	cmp    %rcx,%rax
  800c1f:	75 e9                	jne    800c0a <strlcpy+0x16>
        *dst = '\0';
  800c21:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800c24:	48 29 f8             	sub    %rdi,%rax
}
  800c27:	c3                   	ret

0000000000800c28 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800c28:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800c2c:	0f b6 07             	movzbl (%rdi),%eax
  800c2f:	84 c0                	test   %al,%al
  800c31:	74 13                	je     800c46 <strcmp+0x1e>
  800c33:	38 06                	cmp    %al,(%rsi)
  800c35:	75 0f                	jne    800c46 <strcmp+0x1e>
  800c37:	48 83 c7 01          	add    $0x1,%rdi
  800c3b:	48 83 c6 01          	add    $0x1,%rsi
  800c3f:	0f b6 07             	movzbl (%rdi),%eax
  800c42:	84 c0                	test   %al,%al
  800c44:	75 ed                	jne    800c33 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800c46:	0f b6 c0             	movzbl %al,%eax
  800c49:	0f b6 16             	movzbl (%rsi),%edx
  800c4c:	29 d0                	sub    %edx,%eax
}
  800c4e:	c3                   	ret

0000000000800c4f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800c4f:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800c53:	48 85 d2             	test   %rdx,%rdx
  800c56:	74 1f                	je     800c77 <strncmp+0x28>
  800c58:	0f b6 07             	movzbl (%rdi),%eax
  800c5b:	84 c0                	test   %al,%al
  800c5d:	74 1e                	je     800c7d <strncmp+0x2e>
  800c5f:	3a 06                	cmp    (%rsi),%al
  800c61:	75 1a                	jne    800c7d <strncmp+0x2e>
  800c63:	48 83 c7 01          	add    $0x1,%rdi
  800c67:	48 83 c6 01          	add    $0x1,%rsi
  800c6b:	48 83 ea 01          	sub    $0x1,%rdx
  800c6f:	75 e7                	jne    800c58 <strncmp+0x9>

    if (!n) return 0;
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
  800c76:	c3                   	ret
  800c77:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7c:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c7d:	0f b6 07             	movzbl (%rdi),%eax
  800c80:	0f b6 16             	movzbl (%rsi),%edx
  800c83:	29 d0                	sub    %edx,%eax
}
  800c85:	c3                   	ret

0000000000800c86 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800c86:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800c8a:	0f b6 17             	movzbl (%rdi),%edx
  800c8d:	84 d2                	test   %dl,%dl
  800c8f:	74 18                	je     800ca9 <strchr+0x23>
        if (*str == c) {
  800c91:	0f be d2             	movsbl %dl,%edx
  800c94:	39 f2                	cmp    %esi,%edx
  800c96:	74 17                	je     800caf <strchr+0x29>
    for (; *str; str++) {
  800c98:	48 83 c7 01          	add    $0x1,%rdi
  800c9c:	0f b6 17             	movzbl (%rdi),%edx
  800c9f:	84 d2                	test   %dl,%dl
  800ca1:	75 ee                	jne    800c91 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca8:	c3                   	ret
  800ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cae:	c3                   	ret
            return (char *)str;
  800caf:	48 89 f8             	mov    %rdi,%rax
}
  800cb2:	c3                   	ret

0000000000800cb3 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800cb3:	f3 0f 1e fa          	endbr64
  800cb7:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800cba:	0f b6 17             	movzbl (%rdi),%edx
  800cbd:	84 d2                	test   %dl,%dl
  800cbf:	74 13                	je     800cd4 <strfind+0x21>
  800cc1:	0f be d2             	movsbl %dl,%edx
  800cc4:	39 f2                	cmp    %esi,%edx
  800cc6:	74 0b                	je     800cd3 <strfind+0x20>
  800cc8:	48 83 c0 01          	add    $0x1,%rax
  800ccc:	0f b6 10             	movzbl (%rax),%edx
  800ccf:	84 d2                	test   %dl,%dl
  800cd1:	75 ee                	jne    800cc1 <strfind+0xe>
        ;
    return (char *)str;
}
  800cd3:	c3                   	ret
  800cd4:	c3                   	ret

0000000000800cd5 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800cd5:	f3 0f 1e fa          	endbr64
  800cd9:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800cdc:	48 89 f8             	mov    %rdi,%rax
  800cdf:	48 f7 d8             	neg    %rax
  800ce2:	83 e0 07             	and    $0x7,%eax
  800ce5:	49 89 d1             	mov    %rdx,%r9
  800ce8:	49 29 c1             	sub    %rax,%r9
  800ceb:	78 36                	js     800d23 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800ced:	40 0f b6 c6          	movzbl %sil,%eax
  800cf1:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800cf8:	01 01 01 
  800cfb:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800cff:	40 f6 c7 07          	test   $0x7,%dil
  800d03:	75 38                	jne    800d3d <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800d05:	4c 89 c9             	mov    %r9,%rcx
  800d08:	48 c1 f9 03          	sar    $0x3,%rcx
  800d0c:	74 0c                	je     800d1a <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800d0e:	fc                   	cld
  800d0f:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800d12:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800d16:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800d1a:	4d 85 c9             	test   %r9,%r9
  800d1d:	75 45                	jne    800d64 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800d1f:	4c 89 c0             	mov    %r8,%rax
  800d22:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800d23:	48 85 d2             	test   %rdx,%rdx
  800d26:	74 f7                	je     800d1f <memset+0x4a>
  800d28:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800d2b:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800d2e:	48 83 c0 01          	add    $0x1,%rax
  800d32:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800d36:	48 39 c2             	cmp    %rax,%rdx
  800d39:	75 f3                	jne    800d2e <memset+0x59>
  800d3b:	eb e2                	jmp    800d1f <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800d3d:	40 f6 c7 01          	test   $0x1,%dil
  800d41:	74 06                	je     800d49 <memset+0x74>
  800d43:	88 07                	mov    %al,(%rdi)
  800d45:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d49:	40 f6 c7 02          	test   $0x2,%dil
  800d4d:	74 07                	je     800d56 <memset+0x81>
  800d4f:	66 89 07             	mov    %ax,(%rdi)
  800d52:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d56:	40 f6 c7 04          	test   $0x4,%dil
  800d5a:	74 a9                	je     800d05 <memset+0x30>
  800d5c:	89 07                	mov    %eax,(%rdi)
  800d5e:	48 83 c7 04          	add    $0x4,%rdi
  800d62:	eb a1                	jmp    800d05 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d64:	41 f6 c1 04          	test   $0x4,%r9b
  800d68:	74 1b                	je     800d85 <memset+0xb0>
  800d6a:	89 07                	mov    %eax,(%rdi)
  800d6c:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d70:	41 f6 c1 02          	test   $0x2,%r9b
  800d74:	74 07                	je     800d7d <memset+0xa8>
  800d76:	66 89 07             	mov    %ax,(%rdi)
  800d79:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d7d:	41 f6 c1 01          	test   $0x1,%r9b
  800d81:	74 9c                	je     800d1f <memset+0x4a>
  800d83:	eb 06                	jmp    800d8b <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d85:	41 f6 c1 02          	test   $0x2,%r9b
  800d89:	75 eb                	jne    800d76 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800d8b:	88 07                	mov    %al,(%rdi)
  800d8d:	eb 90                	jmp    800d1f <memset+0x4a>

0000000000800d8f <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d8f:	f3 0f 1e fa          	endbr64
  800d93:	48 89 f8             	mov    %rdi,%rax
  800d96:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d99:	48 39 fe             	cmp    %rdi,%rsi
  800d9c:	73 3b                	jae    800dd9 <memmove+0x4a>
  800d9e:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800da2:	48 39 d7             	cmp    %rdx,%rdi
  800da5:	73 32                	jae    800dd9 <memmove+0x4a>
        s += n;
        d += n;
  800da7:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800dab:	48 89 d6             	mov    %rdx,%rsi
  800dae:	48 09 fe             	or     %rdi,%rsi
  800db1:	48 09 ce             	or     %rcx,%rsi
  800db4:	40 f6 c6 07          	test   $0x7,%sil
  800db8:	75 12                	jne    800dcc <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800dba:	48 83 ef 08          	sub    $0x8,%rdi
  800dbe:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800dc2:	48 c1 e9 03          	shr    $0x3,%rcx
  800dc6:	fd                   	std
  800dc7:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800dca:	fc                   	cld
  800dcb:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800dcc:	48 83 ef 01          	sub    $0x1,%rdi
  800dd0:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800dd4:	fd                   	std
  800dd5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800dd7:	eb f1                	jmp    800dca <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800dd9:	48 89 f2             	mov    %rsi,%rdx
  800ddc:	48 09 c2             	or     %rax,%rdx
  800ddf:	48 09 ca             	or     %rcx,%rdx
  800de2:	f6 c2 07             	test   $0x7,%dl
  800de5:	75 0c                	jne    800df3 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800de7:	48 c1 e9 03          	shr    $0x3,%rcx
  800deb:	48 89 c7             	mov    %rax,%rdi
  800dee:	fc                   	cld
  800def:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800df2:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800df3:	48 89 c7             	mov    %rax,%rdi
  800df6:	fc                   	cld
  800df7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800df9:	c3                   	ret

0000000000800dfa <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800dfa:	f3 0f 1e fa          	endbr64
  800dfe:	55                   	push   %rbp
  800dff:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800e02:	48 b8 8f 0d 80 00 00 	movabs $0x800d8f,%rax
  800e09:	00 00 00 
  800e0c:	ff d0                	call   *%rax
}
  800e0e:	5d                   	pop    %rbp
  800e0f:	c3                   	ret

0000000000800e10 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800e10:	f3 0f 1e fa          	endbr64
  800e14:	55                   	push   %rbp
  800e15:	48 89 e5             	mov    %rsp,%rbp
  800e18:	41 57                	push   %r15
  800e1a:	41 56                	push   %r14
  800e1c:	41 55                	push   %r13
  800e1e:	41 54                	push   %r12
  800e20:	53                   	push   %rbx
  800e21:	48 83 ec 08          	sub    $0x8,%rsp
  800e25:	49 89 fe             	mov    %rdi,%r14
  800e28:	49 89 f7             	mov    %rsi,%r15
  800e2b:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800e2e:	48 89 f7             	mov    %rsi,%rdi
  800e31:	48 b8 2f 0b 80 00 00 	movabs $0x800b2f,%rax
  800e38:	00 00 00 
  800e3b:	ff d0                	call   *%rax
  800e3d:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800e40:	48 89 de             	mov    %rbx,%rsi
  800e43:	4c 89 f7             	mov    %r14,%rdi
  800e46:	48 b8 4e 0b 80 00 00 	movabs $0x800b4e,%rax
  800e4d:	00 00 00 
  800e50:	ff d0                	call   *%rax
  800e52:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800e55:	48 39 c3             	cmp    %rax,%rbx
  800e58:	74 36                	je     800e90 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800e5a:	48 89 d8             	mov    %rbx,%rax
  800e5d:	4c 29 e8             	sub    %r13,%rax
  800e60:	49 39 c4             	cmp    %rax,%r12
  800e63:	73 31                	jae    800e96 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800e65:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800e6a:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e6e:	4c 89 fe             	mov    %r15,%rsi
  800e71:	48 b8 fa 0d 80 00 00 	movabs $0x800dfa,%rax
  800e78:	00 00 00 
  800e7b:	ff d0                	call   *%rax
    return dstlen + srclen;
  800e7d:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800e81:	48 83 c4 08          	add    $0x8,%rsp
  800e85:	5b                   	pop    %rbx
  800e86:	41 5c                	pop    %r12
  800e88:	41 5d                	pop    %r13
  800e8a:	41 5e                	pop    %r14
  800e8c:	41 5f                	pop    %r15
  800e8e:	5d                   	pop    %rbp
  800e8f:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800e90:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800e94:	eb eb                	jmp    800e81 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e96:	48 83 eb 01          	sub    $0x1,%rbx
  800e9a:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e9e:	48 89 da             	mov    %rbx,%rdx
  800ea1:	4c 89 fe             	mov    %r15,%rsi
  800ea4:	48 b8 fa 0d 80 00 00 	movabs $0x800dfa,%rax
  800eab:	00 00 00 
  800eae:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800eb0:	49 01 de             	add    %rbx,%r14
  800eb3:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800eb8:	eb c3                	jmp    800e7d <strlcat+0x6d>

0000000000800eba <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800eba:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800ebe:	48 85 d2             	test   %rdx,%rdx
  800ec1:	74 2d                	je     800ef0 <memcmp+0x36>
  800ec3:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800ec8:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800ecc:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800ed1:	44 38 c1             	cmp    %r8b,%cl
  800ed4:	75 0f                	jne    800ee5 <memcmp+0x2b>
    while (n-- > 0) {
  800ed6:	48 83 c0 01          	add    $0x1,%rax
  800eda:	48 39 c2             	cmp    %rax,%rdx
  800edd:	75 e9                	jne    800ec8 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800edf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee4:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800ee5:	0f b6 c1             	movzbl %cl,%eax
  800ee8:	45 0f b6 c0          	movzbl %r8b,%r8d
  800eec:	44 29 c0             	sub    %r8d,%eax
  800eef:	c3                   	ret
    return 0;
  800ef0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef5:	c3                   	ret

0000000000800ef6 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800ef6:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800efa:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800efe:	48 39 c7             	cmp    %rax,%rdi
  800f01:	73 0f                	jae    800f12 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800f03:	40 38 37             	cmp    %sil,(%rdi)
  800f06:	74 0e                	je     800f16 <memfind+0x20>
    for (; src < end; src++) {
  800f08:	48 83 c7 01          	add    $0x1,%rdi
  800f0c:	48 39 f8             	cmp    %rdi,%rax
  800f0f:	75 f2                	jne    800f03 <memfind+0xd>
  800f11:	c3                   	ret
  800f12:	48 89 f8             	mov    %rdi,%rax
  800f15:	c3                   	ret
  800f16:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800f19:	c3                   	ret

0000000000800f1a <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800f1a:	f3 0f 1e fa          	endbr64
  800f1e:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800f21:	0f b6 37             	movzbl (%rdi),%esi
  800f24:	40 80 fe 20          	cmp    $0x20,%sil
  800f28:	74 06                	je     800f30 <strtol+0x16>
  800f2a:	40 80 fe 09          	cmp    $0x9,%sil
  800f2e:	75 13                	jne    800f43 <strtol+0x29>
  800f30:	48 83 c7 01          	add    $0x1,%rdi
  800f34:	0f b6 37             	movzbl (%rdi),%esi
  800f37:	40 80 fe 20          	cmp    $0x20,%sil
  800f3b:	74 f3                	je     800f30 <strtol+0x16>
  800f3d:	40 80 fe 09          	cmp    $0x9,%sil
  800f41:	74 ed                	je     800f30 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800f43:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800f46:	83 e0 fd             	and    $0xfffffffd,%eax
  800f49:	3c 01                	cmp    $0x1,%al
  800f4b:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f4f:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  800f55:	75 0f                	jne    800f66 <strtol+0x4c>
  800f57:	80 3f 30             	cmpb   $0x30,(%rdi)
  800f5a:	74 14                	je     800f70 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800f5c:	85 d2                	test   %edx,%edx
  800f5e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f63:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800f6b:	4c 63 ca             	movslq %edx,%r9
  800f6e:	eb 36                	jmp    800fa6 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f70:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800f74:	74 0f                	je     800f85 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  800f76:	85 d2                	test   %edx,%edx
  800f78:	75 ec                	jne    800f66 <strtol+0x4c>
        s++;
  800f7a:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800f7e:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  800f83:	eb e1                	jmp    800f66 <strtol+0x4c>
        s += 2;
  800f85:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f89:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  800f8e:	eb d6                	jmp    800f66 <strtol+0x4c>
            dig -= '0';
  800f90:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  800f93:	44 0f b6 c1          	movzbl %cl,%r8d
  800f97:	41 39 d0             	cmp    %edx,%r8d
  800f9a:	7d 21                	jge    800fbd <strtol+0xa3>
        val = val * base + dig;
  800f9c:	49 0f af c1          	imul   %r9,%rax
  800fa0:	0f b6 c9             	movzbl %cl,%ecx
  800fa3:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  800fa6:	48 83 c7 01          	add    $0x1,%rdi
  800faa:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  800fae:	80 f9 39             	cmp    $0x39,%cl
  800fb1:	76 dd                	jbe    800f90 <strtol+0x76>
        else if (dig - 'a' < 27)
  800fb3:	80 f9 7b             	cmp    $0x7b,%cl
  800fb6:	77 05                	ja     800fbd <strtol+0xa3>
            dig -= 'a' - 10;
  800fb8:	83 e9 57             	sub    $0x57,%ecx
  800fbb:	eb d6                	jmp    800f93 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  800fbd:	4d 85 d2             	test   %r10,%r10
  800fc0:	74 03                	je     800fc5 <strtol+0xab>
  800fc2:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800fc5:	48 89 c2             	mov    %rax,%rdx
  800fc8:	48 f7 da             	neg    %rdx
  800fcb:	40 80 fe 2d          	cmp    $0x2d,%sil
  800fcf:	48 0f 44 c2          	cmove  %rdx,%rax
}
  800fd3:	c3                   	ret

0000000000800fd4 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800fd4:	f3 0f 1e fa          	endbr64
  800fd8:	55                   	push   %rbp
  800fd9:	48 89 e5             	mov    %rsp,%rbp
  800fdc:	53                   	push   %rbx
  800fdd:	48 89 fa             	mov    %rdi,%rdx
  800fe0:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fe8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fed:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800ff2:	be 00 00 00 00       	mov    $0x0,%esi
  800ff7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800ffd:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800fff:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801003:	c9                   	leave
  801004:	c3                   	ret

0000000000801005 <sys_cgetc>:

int
sys_cgetc(void) {
  801005:	f3 0f 1e fa          	endbr64
  801009:	55                   	push   %rbp
  80100a:	48 89 e5             	mov    %rsp,%rbp
  80100d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80100e:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801013:	ba 00 00 00 00       	mov    $0x0,%edx
  801018:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80101d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801022:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801027:	be 00 00 00 00       	mov    $0x0,%esi
  80102c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801032:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801034:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801038:	c9                   	leave
  801039:	c3                   	ret

000000000080103a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80103a:	f3 0f 1e fa          	endbr64
  80103e:	55                   	push   %rbp
  80103f:	48 89 e5             	mov    %rsp,%rbp
  801042:	53                   	push   %rbx
  801043:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801047:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80104a:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80104f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801054:	bb 00 00 00 00       	mov    $0x0,%ebx
  801059:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80105e:	be 00 00 00 00       	mov    $0x0,%esi
  801063:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801069:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80106b:	48 85 c0             	test   %rax,%rax
  80106e:	7f 06                	jg     801076 <sys_env_destroy+0x3c>
}
  801070:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801074:	c9                   	leave
  801075:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801076:	49 89 c0             	mov    %rax,%r8
  801079:	b9 03 00 00 00       	mov    $0x3,%ecx
  80107e:	48 ba 40 46 80 00 00 	movabs $0x804640,%rdx
  801085:	00 00 00 
  801088:	be 26 00 00 00       	mov    $0x26,%esi
  80108d:	48 bf b6 41 80 00 00 	movabs $0x8041b6,%rdi
  801094:	00 00 00 
  801097:	b8 00 00 00 00       	mov    $0x0,%eax
  80109c:	49 b9 b8 2d 80 00 00 	movabs $0x802db8,%r9
  8010a3:	00 00 00 
  8010a6:	41 ff d1             	call   *%r9

00000000008010a9 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8010a9:	f3 0f 1e fa          	endbr64
  8010ad:	55                   	push   %rbp
  8010ae:	48 89 e5             	mov    %rsp,%rbp
  8010b1:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010b2:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010bc:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010cb:	be 00 00 00 00       	mov    $0x0,%esi
  8010d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010d6:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8010d8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010dc:	c9                   	leave
  8010dd:	c3                   	ret

00000000008010de <sys_yield>:

void
sys_yield(void) {
  8010de:	f3 0f 1e fa          	endbr64
  8010e2:	55                   	push   %rbp
  8010e3:	48 89 e5             	mov    %rsp,%rbp
  8010e6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010e7:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801100:	be 00 00 00 00       	mov    $0x0,%esi
  801105:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80110b:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80110d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801111:	c9                   	leave
  801112:	c3                   	ret

0000000000801113 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801113:	f3 0f 1e fa          	endbr64
  801117:	55                   	push   %rbp
  801118:	48 89 e5             	mov    %rsp,%rbp
  80111b:	53                   	push   %rbx
  80111c:	48 89 fa             	mov    %rdi,%rdx
  80111f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801122:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801127:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80112e:	00 00 00 
  801131:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801136:	be 00 00 00 00       	mov    $0x0,%esi
  80113b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801141:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801143:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801147:	c9                   	leave
  801148:	c3                   	ret

0000000000801149 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801149:	f3 0f 1e fa          	endbr64
  80114d:	55                   	push   %rbp
  80114e:	48 89 e5             	mov    %rsp,%rbp
  801151:	53                   	push   %rbx
  801152:	49 89 f8             	mov    %rdi,%r8
  801155:	48 89 d3             	mov    %rdx,%rbx
  801158:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80115b:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801160:	4c 89 c2             	mov    %r8,%rdx
  801163:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801166:	be 00 00 00 00       	mov    $0x0,%esi
  80116b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801171:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801173:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801177:	c9                   	leave
  801178:	c3                   	ret

0000000000801179 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801179:	f3 0f 1e fa          	endbr64
  80117d:	55                   	push   %rbp
  80117e:	48 89 e5             	mov    %rsp,%rbp
  801181:	53                   	push   %rbx
  801182:	48 83 ec 08          	sub    $0x8,%rsp
  801186:	89 f8                	mov    %edi,%eax
  801188:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80118b:	48 63 f9             	movslq %ecx,%rdi
  80118e:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801191:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801196:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801199:	be 00 00 00 00       	mov    $0x0,%esi
  80119e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011a4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011a6:	48 85 c0             	test   %rax,%rax
  8011a9:	7f 06                	jg     8011b1 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8011ab:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011af:	c9                   	leave
  8011b0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011b1:	49 89 c0             	mov    %rax,%r8
  8011b4:	b9 04 00 00 00       	mov    $0x4,%ecx
  8011b9:	48 ba 40 46 80 00 00 	movabs $0x804640,%rdx
  8011c0:	00 00 00 
  8011c3:	be 26 00 00 00       	mov    $0x26,%esi
  8011c8:	48 bf b6 41 80 00 00 	movabs $0x8041b6,%rdi
  8011cf:	00 00 00 
  8011d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d7:	49 b9 b8 2d 80 00 00 	movabs $0x802db8,%r9
  8011de:	00 00 00 
  8011e1:	41 ff d1             	call   *%r9

00000000008011e4 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8011e4:	f3 0f 1e fa          	endbr64
  8011e8:	55                   	push   %rbp
  8011e9:	48 89 e5             	mov    %rsp,%rbp
  8011ec:	53                   	push   %rbx
  8011ed:	48 83 ec 08          	sub    $0x8,%rsp
  8011f1:	89 f8                	mov    %edi,%eax
  8011f3:	49 89 f2             	mov    %rsi,%r10
  8011f6:	48 89 cf             	mov    %rcx,%rdi
  8011f9:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8011fc:	48 63 da             	movslq %edx,%rbx
  8011ff:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801202:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801207:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80120a:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80120d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80120f:	48 85 c0             	test   %rax,%rax
  801212:	7f 06                	jg     80121a <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801214:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801218:	c9                   	leave
  801219:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80121a:	49 89 c0             	mov    %rax,%r8
  80121d:	b9 05 00 00 00       	mov    $0x5,%ecx
  801222:	48 ba 40 46 80 00 00 	movabs $0x804640,%rdx
  801229:	00 00 00 
  80122c:	be 26 00 00 00       	mov    $0x26,%esi
  801231:	48 bf b6 41 80 00 00 	movabs $0x8041b6,%rdi
  801238:	00 00 00 
  80123b:	b8 00 00 00 00       	mov    $0x0,%eax
  801240:	49 b9 b8 2d 80 00 00 	movabs $0x802db8,%r9
  801247:	00 00 00 
  80124a:	41 ff d1             	call   *%r9

000000000080124d <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80124d:	f3 0f 1e fa          	endbr64
  801251:	55                   	push   %rbp
  801252:	48 89 e5             	mov    %rsp,%rbp
  801255:	53                   	push   %rbx
  801256:	48 83 ec 08          	sub    $0x8,%rsp
  80125a:	49 89 f9             	mov    %rdi,%r9
  80125d:	89 f0                	mov    %esi,%eax
  80125f:	48 89 d3             	mov    %rdx,%rbx
  801262:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801265:	49 63 f0             	movslq %r8d,%rsi
  801268:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80126b:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801270:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801273:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801279:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80127b:	48 85 c0             	test   %rax,%rax
  80127e:	7f 06                	jg     801286 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801280:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801284:	c9                   	leave
  801285:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801286:	49 89 c0             	mov    %rax,%r8
  801289:	b9 06 00 00 00       	mov    $0x6,%ecx
  80128e:	48 ba 40 46 80 00 00 	movabs $0x804640,%rdx
  801295:	00 00 00 
  801298:	be 26 00 00 00       	mov    $0x26,%esi
  80129d:	48 bf b6 41 80 00 00 	movabs $0x8041b6,%rdi
  8012a4:	00 00 00 
  8012a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ac:	49 b9 b8 2d 80 00 00 	movabs $0x802db8,%r9
  8012b3:	00 00 00 
  8012b6:	41 ff d1             	call   *%r9

00000000008012b9 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8012b9:	f3 0f 1e fa          	endbr64
  8012bd:	55                   	push   %rbp
  8012be:	48 89 e5             	mov    %rsp,%rbp
  8012c1:	53                   	push   %rbx
  8012c2:	48 83 ec 08          	sub    $0x8,%rsp
  8012c6:	48 89 f1             	mov    %rsi,%rcx
  8012c9:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8012cc:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012cf:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012d4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012d9:	be 00 00 00 00       	mov    $0x0,%esi
  8012de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012e4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012e6:	48 85 c0             	test   %rax,%rax
  8012e9:	7f 06                	jg     8012f1 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8012eb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012ef:	c9                   	leave
  8012f0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012f1:	49 89 c0             	mov    %rax,%r8
  8012f4:	b9 07 00 00 00       	mov    $0x7,%ecx
  8012f9:	48 ba 40 46 80 00 00 	movabs $0x804640,%rdx
  801300:	00 00 00 
  801303:	be 26 00 00 00       	mov    $0x26,%esi
  801308:	48 bf b6 41 80 00 00 	movabs $0x8041b6,%rdi
  80130f:	00 00 00 
  801312:	b8 00 00 00 00       	mov    $0x0,%eax
  801317:	49 b9 b8 2d 80 00 00 	movabs $0x802db8,%r9
  80131e:	00 00 00 
  801321:	41 ff d1             	call   *%r9

0000000000801324 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801324:	f3 0f 1e fa          	endbr64
  801328:	55                   	push   %rbp
  801329:	48 89 e5             	mov    %rsp,%rbp
  80132c:	53                   	push   %rbx
  80132d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801331:	48 63 ce             	movslq %esi,%rcx
  801334:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801337:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80133c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801341:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801346:	be 00 00 00 00       	mov    $0x0,%esi
  80134b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801351:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801353:	48 85 c0             	test   %rax,%rax
  801356:	7f 06                	jg     80135e <sys_env_set_status+0x3a>
}
  801358:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80135c:	c9                   	leave
  80135d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80135e:	49 89 c0             	mov    %rax,%r8
  801361:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801366:	48 ba 40 46 80 00 00 	movabs $0x804640,%rdx
  80136d:	00 00 00 
  801370:	be 26 00 00 00       	mov    $0x26,%esi
  801375:	48 bf b6 41 80 00 00 	movabs $0x8041b6,%rdi
  80137c:	00 00 00 
  80137f:	b8 00 00 00 00       	mov    $0x0,%eax
  801384:	49 b9 b8 2d 80 00 00 	movabs $0x802db8,%r9
  80138b:	00 00 00 
  80138e:	41 ff d1             	call   *%r9

0000000000801391 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801391:	f3 0f 1e fa          	endbr64
  801395:	55                   	push   %rbp
  801396:	48 89 e5             	mov    %rsp,%rbp
  801399:	53                   	push   %rbx
  80139a:	48 83 ec 08          	sub    $0x8,%rsp
  80139e:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8013a1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013a4:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ae:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013b3:	be 00 00 00 00       	mov    $0x0,%esi
  8013b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013be:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013c0:	48 85 c0             	test   %rax,%rax
  8013c3:	7f 06                	jg     8013cb <sys_env_set_trapframe+0x3a>
}
  8013c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013c9:	c9                   	leave
  8013ca:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013cb:	49 89 c0             	mov    %rax,%r8
  8013ce:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8013d3:	48 ba 40 46 80 00 00 	movabs $0x804640,%rdx
  8013da:	00 00 00 
  8013dd:	be 26 00 00 00       	mov    $0x26,%esi
  8013e2:	48 bf b6 41 80 00 00 	movabs $0x8041b6,%rdi
  8013e9:	00 00 00 
  8013ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f1:	49 b9 b8 2d 80 00 00 	movabs $0x802db8,%r9
  8013f8:	00 00 00 
  8013fb:	41 ff d1             	call   *%r9

00000000008013fe <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8013fe:	f3 0f 1e fa          	endbr64
  801402:	55                   	push   %rbp
  801403:	48 89 e5             	mov    %rsp,%rbp
  801406:	53                   	push   %rbx
  801407:	48 83 ec 08          	sub    $0x8,%rsp
  80140b:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80140e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801411:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801416:	bb 00 00 00 00       	mov    $0x0,%ebx
  80141b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801420:	be 00 00 00 00       	mov    $0x0,%esi
  801425:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80142b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80142d:	48 85 c0             	test   %rax,%rax
  801430:	7f 06                	jg     801438 <sys_env_set_pgfault_upcall+0x3a>
}
  801432:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801436:	c9                   	leave
  801437:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801438:	49 89 c0             	mov    %rax,%r8
  80143b:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801440:	48 ba 40 46 80 00 00 	movabs $0x804640,%rdx
  801447:	00 00 00 
  80144a:	be 26 00 00 00       	mov    $0x26,%esi
  80144f:	48 bf b6 41 80 00 00 	movabs $0x8041b6,%rdi
  801456:	00 00 00 
  801459:	b8 00 00 00 00       	mov    $0x0,%eax
  80145e:	49 b9 b8 2d 80 00 00 	movabs $0x802db8,%r9
  801465:	00 00 00 
  801468:	41 ff d1             	call   *%r9

000000000080146b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80146b:	f3 0f 1e fa          	endbr64
  80146f:	55                   	push   %rbp
  801470:	48 89 e5             	mov    %rsp,%rbp
  801473:	53                   	push   %rbx
  801474:	89 f8                	mov    %edi,%eax
  801476:	49 89 f1             	mov    %rsi,%r9
  801479:	48 89 d3             	mov    %rdx,%rbx
  80147c:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80147f:	49 63 f0             	movslq %r8d,%rsi
  801482:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801485:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80148a:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80148d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801493:	cd 30                	int    $0x30
}
  801495:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801499:	c9                   	leave
  80149a:	c3                   	ret

000000000080149b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80149b:	f3 0f 1e fa          	endbr64
  80149f:	55                   	push   %rbp
  8014a0:	48 89 e5             	mov    %rsp,%rbp
  8014a3:	53                   	push   %rbx
  8014a4:	48 83 ec 08          	sub    $0x8,%rsp
  8014a8:	48 89 fa             	mov    %rdi,%rdx
  8014ab:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8014ae:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014b8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014bd:	be 00 00 00 00       	mov    $0x0,%esi
  8014c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014c8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014ca:	48 85 c0             	test   %rax,%rax
  8014cd:	7f 06                	jg     8014d5 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8014cf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014d3:	c9                   	leave
  8014d4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014d5:	49 89 c0             	mov    %rax,%r8
  8014d8:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8014dd:	48 ba 40 46 80 00 00 	movabs $0x804640,%rdx
  8014e4:	00 00 00 
  8014e7:	be 26 00 00 00       	mov    $0x26,%esi
  8014ec:	48 bf b6 41 80 00 00 	movabs $0x8041b6,%rdi
  8014f3:	00 00 00 
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fb:	49 b9 b8 2d 80 00 00 	movabs $0x802db8,%r9
  801502:	00 00 00 
  801505:	41 ff d1             	call   *%r9

0000000000801508 <sys_gettime>:

int
sys_gettime(void) {
  801508:	f3 0f 1e fa          	endbr64
  80150c:	55                   	push   %rbp
  80150d:	48 89 e5             	mov    %rsp,%rbp
  801510:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801511:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801516:	ba 00 00 00 00       	mov    $0x0,%edx
  80151b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801520:	bb 00 00 00 00       	mov    $0x0,%ebx
  801525:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80152a:	be 00 00 00 00       	mov    $0x0,%esi
  80152f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801535:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801537:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80153b:	c9                   	leave
  80153c:	c3                   	ret

000000000080153d <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  80153d:	f3 0f 1e fa          	endbr64
  801541:	55                   	push   %rbp
  801542:	48 89 e5             	mov    %rsp,%rbp
  801545:	41 56                	push   %r14
  801547:	41 55                	push   %r13
  801549:	41 54                	push   %r12
  80154b:	53                   	push   %rbx
  80154c:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  80154f:	48 b8 68 60 80 00 00 	movabs $0x806068,%rax
  801556:	00 00 00 
  801559:	48 83 38 00          	cmpq   $0x0,(%rax)
  80155d:	74 27                	je     801586 <_handle_vectored_pagefault+0x49>
  80155f:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  801564:	49 bd 20 60 80 00 00 	movabs $0x806020,%r13
  80156b:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  80156e:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  801571:	4c 89 e7             	mov    %r12,%rdi
  801574:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  801579:	84 c0                	test   %al,%al
  80157b:	75 45                	jne    8015c2 <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80157d:	48 83 c3 01          	add    $0x1,%rbx
  801581:	49 3b 1e             	cmp    (%r14),%rbx
  801584:	72 eb                	jb     801571 <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  801586:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  80158d:	00 
  80158e:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  801593:	4d 8b 04 24          	mov    (%r12),%r8
  801597:	48 ba 60 46 80 00 00 	movabs $0x804660,%rdx
  80159e:	00 00 00 
  8015a1:	be 1d 00 00 00       	mov    $0x1d,%esi
  8015a6:	48 bf c4 41 80 00 00 	movabs $0x8041c4,%rdi
  8015ad:	00 00 00 
  8015b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b5:	49 ba b8 2d 80 00 00 	movabs $0x802db8,%r10
  8015bc:	00 00 00 
  8015bf:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  8015c2:	5b                   	pop    %rbx
  8015c3:	41 5c                	pop    %r12
  8015c5:	41 5d                	pop    %r13
  8015c7:	41 5e                	pop    %r14
  8015c9:	5d                   	pop    %rbp
  8015ca:	c3                   	ret

00000000008015cb <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  8015cb:	f3 0f 1e fa          	endbr64
  8015cf:	55                   	push   %rbp
  8015d0:	48 89 e5             	mov    %rsp,%rbp
  8015d3:	53                   	push   %rbx
  8015d4:	48 83 ec 08          	sub    $0x8,%rsp
  8015d8:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  8015db:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  8015e2:	00 00 00 
  8015e5:	80 38 00             	cmpb   $0x0,(%rax)
  8015e8:	0f 84 84 00 00 00    	je     801672 <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  8015ee:	48 b8 68 60 80 00 00 	movabs $0x806068,%rax
  8015f5:	00 00 00 
  8015f8:	48 8b 10             	mov    (%rax),%rdx
  8015fb:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  801600:	48 b9 20 60 80 00 00 	movabs $0x806020,%rcx
  801607:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  80160a:	48 85 d2             	test   %rdx,%rdx
  80160d:	74 19                	je     801628 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  80160f:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  801613:	0f 84 e8 00 00 00    	je     801701 <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  801619:	48 83 c0 01          	add    $0x1,%rax
  80161d:	48 39 d0             	cmp    %rdx,%rax
  801620:	75 ed                	jne    80160f <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  801622:	48 83 fa 08          	cmp    $0x8,%rdx
  801626:	74 1c                	je     801644 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  801628:	48 8d 42 01          	lea    0x1(%rdx),%rax
  80162c:	48 a3 68 60 80 00 00 	movabs %rax,0x806068
  801633:	00 00 00 
  801636:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80163d:	00 00 00 
  801640:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801644:	48 b8 a9 10 80 00 00 	movabs $0x8010a9,%rax
  80164b:	00 00 00 
  80164e:	ff d0                	call   *%rax
  801650:	89 c7                	mov    %eax,%edi
  801652:	48 be cb 17 80 00 00 	movabs $0x8017cb,%rsi
  801659:	00 00 00 
  80165c:	48 b8 fe 13 80 00 00 	movabs $0x8013fe,%rax
  801663:	00 00 00 
  801666:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  801668:	85 c0                	test   %eax,%eax
  80166a:	78 68                	js     8016d4 <add_pgfault_handler+0x109>
    return res;
}
  80166c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801670:	c9                   	leave
  801671:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  801672:	48 b8 a9 10 80 00 00 	movabs $0x8010a9,%rax
  801679:	00 00 00 
  80167c:	ff d0                	call   *%rax
  80167e:	89 c7                	mov    %eax,%edi
  801680:	b9 06 00 00 00       	mov    $0x6,%ecx
  801685:	ba 00 10 00 00       	mov    $0x1000,%edx
  80168a:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  801691:	00 00 00 
  801694:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  80169b:	00 00 00 
  80169e:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  8016a0:	48 ba 68 60 80 00 00 	movabs $0x806068,%rdx
  8016a7:	00 00 00 
  8016aa:	48 8b 02             	mov    (%rdx),%rax
  8016ad:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8016b1:	48 89 0a             	mov    %rcx,(%rdx)
  8016b4:	48 ba 20 60 80 00 00 	movabs $0x806020,%rdx
  8016bb:	00 00 00 
  8016be:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  8016c2:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  8016c9:	00 00 00 
  8016cc:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  8016cf:	e9 70 ff ff ff       	jmp    801644 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8016d4:	89 c1                	mov    %eax,%ecx
  8016d6:	48 ba d2 41 80 00 00 	movabs $0x8041d2,%rdx
  8016dd:	00 00 00 
  8016e0:	be 3d 00 00 00       	mov    $0x3d,%esi
  8016e5:	48 bf c4 41 80 00 00 	movabs $0x8041c4,%rdi
  8016ec:	00 00 00 
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f4:	49 b8 b8 2d 80 00 00 	movabs $0x802db8,%r8
  8016fb:	00 00 00 
  8016fe:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  801701:	b8 00 00 00 00       	mov    $0x0,%eax
  801706:	e9 61 ff ff ff       	jmp    80166c <add_pgfault_handler+0xa1>

000000000080170b <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  80170b:	f3 0f 1e fa          	endbr64
  80170f:	55                   	push   %rbp
  801710:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  801713:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80171a:	00 00 00 
  80171d:	80 38 00             	cmpb   $0x0,(%rax)
  801720:	74 33                	je     801755 <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  801722:	48 a1 68 60 80 00 00 	movabs 0x806068,%rax
  801729:	00 00 00 
  80172c:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  801731:	48 ba 20 60 80 00 00 	movabs $0x806020,%rdx
  801738:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80173b:	48 85 c0             	test   %rax,%rax
  80173e:	0f 84 85 00 00 00    	je     8017c9 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  801744:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  801748:	74 40                	je     80178a <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80174a:	48 83 c1 01          	add    $0x1,%rcx
  80174e:	48 39 c1             	cmp    %rax,%rcx
  801751:	75 f1                	jne    801744 <remove_pgfault_handler+0x39>
  801753:	eb 74                	jmp    8017c9 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  801755:	48 b9 ea 41 80 00 00 	movabs $0x8041ea,%rcx
  80175c:	00 00 00 
  80175f:	48 ba 04 42 80 00 00 	movabs $0x804204,%rdx
  801766:	00 00 00 
  801769:	be 43 00 00 00       	mov    $0x43,%esi
  80176e:	48 bf c4 41 80 00 00 	movabs $0x8041c4,%rdi
  801775:	00 00 00 
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
  80177d:	49 b8 b8 2d 80 00 00 	movabs $0x802db8,%r8
  801784:	00 00 00 
  801787:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  80178a:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  801791:	00 
  801792:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801796:	48 29 ca             	sub    %rcx,%rdx
  801799:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8017a0:	00 00 00 
  8017a3:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  8017a7:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  8017ac:	48 89 ce             	mov    %rcx,%rsi
  8017af:	48 b8 8f 0d 80 00 00 	movabs $0x800d8f,%rax
  8017b6:	00 00 00 
  8017b9:	ff d0                	call   *%rax
            _pfhandler_off--;
  8017bb:	48 b8 68 60 80 00 00 	movabs $0x806068,%rax
  8017c2:	00 00 00 
  8017c5:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  8017c9:	5d                   	pop    %rbp
  8017ca:	c3                   	ret

00000000008017cb <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  8017cb:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  8017ce:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  8017d5:	00 00 00 
    call *%rax
  8017d8:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  8017da:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  8017dd:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8017e4:	00 
    movq UTRAP_RSP(%rsp), %rsp
  8017e5:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  8017ec:	00 
    pushq %rbx
  8017ed:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  8017ee:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  8017f5:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  8017f8:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  8017fc:	4c 8b 3c 24          	mov    (%rsp),%r15
  801800:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801805:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80180a:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80180f:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801814:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801819:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80181e:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801823:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801828:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80182d:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801832:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801837:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80183c:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801841:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801846:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  80184a:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  80184e:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  80184f:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  801850:	c3                   	ret

0000000000801851 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801851:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801855:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80185c:	ff ff ff 
  80185f:	48 01 f8             	add    %rdi,%rax
  801862:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801866:	c3                   	ret

0000000000801867 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801867:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80186b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801872:	ff ff ff 
  801875:	48 01 f8             	add    %rdi,%rax
  801878:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80187c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801882:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801886:	c3                   	ret

0000000000801887 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801887:	f3 0f 1e fa          	endbr64
  80188b:	55                   	push   %rbp
  80188c:	48 89 e5             	mov    %rsp,%rbp
  80188f:	41 57                	push   %r15
  801891:	41 56                	push   %r14
  801893:	41 55                	push   %r13
  801895:	41 54                	push   %r12
  801897:	53                   	push   %rbx
  801898:	48 83 ec 08          	sub    $0x8,%rsp
  80189c:	49 89 ff             	mov    %rdi,%r15
  80189f:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8018a4:	49 bd e6 29 80 00 00 	movabs $0x8029e6,%r13
  8018ab:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8018ae:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8018b4:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8018b7:	48 89 df             	mov    %rbx,%rdi
  8018ba:	41 ff d5             	call   *%r13
  8018bd:	83 e0 04             	and    $0x4,%eax
  8018c0:	74 17                	je     8018d9 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8018c2:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8018c9:	4c 39 f3             	cmp    %r14,%rbx
  8018cc:	75 e6                	jne    8018b4 <fd_alloc+0x2d>
  8018ce:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8018d4:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8018d9:	4d 89 27             	mov    %r12,(%r15)
}
  8018dc:	48 83 c4 08          	add    $0x8,%rsp
  8018e0:	5b                   	pop    %rbx
  8018e1:	41 5c                	pop    %r12
  8018e3:	41 5d                	pop    %r13
  8018e5:	41 5e                	pop    %r14
  8018e7:	41 5f                	pop    %r15
  8018e9:	5d                   	pop    %rbp
  8018ea:	c3                   	ret

00000000008018eb <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8018eb:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8018ef:	83 ff 1f             	cmp    $0x1f,%edi
  8018f2:	77 39                	ja     80192d <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8018f4:	55                   	push   %rbp
  8018f5:	48 89 e5             	mov    %rsp,%rbp
  8018f8:	41 54                	push   %r12
  8018fa:	53                   	push   %rbx
  8018fb:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8018fe:	48 63 df             	movslq %edi,%rbx
  801901:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801908:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  80190c:	48 89 df             	mov    %rbx,%rdi
  80190f:	48 b8 e6 29 80 00 00 	movabs $0x8029e6,%rax
  801916:	00 00 00 
  801919:	ff d0                	call   *%rax
  80191b:	a8 04                	test   $0x4,%al
  80191d:	74 14                	je     801933 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80191f:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801923:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801928:	5b                   	pop    %rbx
  801929:	41 5c                	pop    %r12
  80192b:	5d                   	pop    %rbp
  80192c:	c3                   	ret
        return -E_INVAL;
  80192d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801932:	c3                   	ret
        return -E_INVAL;
  801933:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801938:	eb ee                	jmp    801928 <fd_lookup+0x3d>

000000000080193a <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  80193a:	f3 0f 1e fa          	endbr64
  80193e:	55                   	push   %rbp
  80193f:	48 89 e5             	mov    %rsp,%rbp
  801942:	41 54                	push   %r12
  801944:	53                   	push   %rbx
  801945:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801948:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  80194f:	00 00 00 
  801952:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801959:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  80195c:	39 3b                	cmp    %edi,(%rbx)
  80195e:	74 47                	je     8019a7 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801960:	48 83 c0 08          	add    $0x8,%rax
  801964:	48 8b 18             	mov    (%rax),%rbx
  801967:	48 85 db             	test   %rbx,%rbx
  80196a:	75 f0                	jne    80195c <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80196c:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801973:	00 00 00 
  801976:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80197c:	89 fa                	mov    %edi,%edx
  80197e:	48 bf 90 46 80 00 00 	movabs $0x804690,%rdi
  801985:	00 00 00 
  801988:	b8 00 00 00 00       	mov    $0x0,%eax
  80198d:	48 b9 2b 02 80 00 00 	movabs $0x80022b,%rcx
  801994:	00 00 00 
  801997:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801999:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  80199e:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8019a2:	5b                   	pop    %rbx
  8019a3:	41 5c                	pop    %r12
  8019a5:	5d                   	pop    %rbp
  8019a6:	c3                   	ret
            return 0;
  8019a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ac:	eb f0                	jmp    80199e <dev_lookup+0x64>

00000000008019ae <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8019ae:	f3 0f 1e fa          	endbr64
  8019b2:	55                   	push   %rbp
  8019b3:	48 89 e5             	mov    %rsp,%rbp
  8019b6:	41 55                	push   %r13
  8019b8:	41 54                	push   %r12
  8019ba:	53                   	push   %rbx
  8019bb:	48 83 ec 18          	sub    $0x18,%rsp
  8019bf:	48 89 fb             	mov    %rdi,%rbx
  8019c2:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8019c5:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8019cc:	ff ff ff 
  8019cf:	48 01 df             	add    %rbx,%rdi
  8019d2:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8019d6:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019da:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  8019e1:	00 00 00 
  8019e4:	ff d0                	call   *%rax
  8019e6:	41 89 c5             	mov    %eax,%r13d
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	78 06                	js     8019f3 <fd_close+0x45>
  8019ed:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  8019f1:	74 1a                	je     801a0d <fd_close+0x5f>
        return (must_exist ? res : 0);
  8019f3:	45 84 e4             	test   %r12b,%r12b
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fb:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8019ff:	44 89 e8             	mov    %r13d,%eax
  801a02:	48 83 c4 18          	add    $0x18,%rsp
  801a06:	5b                   	pop    %rbx
  801a07:	41 5c                	pop    %r12
  801a09:	41 5d                	pop    %r13
  801a0b:	5d                   	pop    %rbp
  801a0c:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a0d:	8b 3b                	mov    (%rbx),%edi
  801a0f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a13:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  801a1a:	00 00 00 
  801a1d:	ff d0                	call   *%rax
  801a1f:	41 89 c5             	mov    %eax,%r13d
  801a22:	85 c0                	test   %eax,%eax
  801a24:	78 1b                	js     801a41 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801a26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a2a:	48 8b 40 20          	mov    0x20(%rax),%rax
  801a2e:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801a34:	48 85 c0             	test   %rax,%rax
  801a37:	74 08                	je     801a41 <fd_close+0x93>
  801a39:	48 89 df             	mov    %rbx,%rdi
  801a3c:	ff d0                	call   *%rax
  801a3e:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801a41:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a46:	48 89 de             	mov    %rbx,%rsi
  801a49:	bf 00 00 00 00       	mov    $0x0,%edi
  801a4e:	48 b8 b9 12 80 00 00 	movabs $0x8012b9,%rax
  801a55:	00 00 00 
  801a58:	ff d0                	call   *%rax
    return res;
  801a5a:	eb a3                	jmp    8019ff <fd_close+0x51>

0000000000801a5c <close>:

int
close(int fdnum) {
  801a5c:	f3 0f 1e fa          	endbr64
  801a60:	55                   	push   %rbp
  801a61:	48 89 e5             	mov    %rsp,%rbp
  801a64:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801a68:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801a6c:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  801a73:	00 00 00 
  801a76:	ff d0                	call   *%rax
    if (res < 0) return res;
  801a78:	85 c0                	test   %eax,%eax
  801a7a:	78 15                	js     801a91 <close+0x35>

    return fd_close(fd, 1);
  801a7c:	be 01 00 00 00       	mov    $0x1,%esi
  801a81:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801a85:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801a8c:	00 00 00 
  801a8f:	ff d0                	call   *%rax
}
  801a91:	c9                   	leave
  801a92:	c3                   	ret

0000000000801a93 <close_all>:

void
close_all(void) {
  801a93:	f3 0f 1e fa          	endbr64
  801a97:	55                   	push   %rbp
  801a98:	48 89 e5             	mov    %rsp,%rbp
  801a9b:	41 54                	push   %r12
  801a9d:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801a9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aa3:	49 bc 5c 1a 80 00 00 	movabs $0x801a5c,%r12
  801aaa:	00 00 00 
  801aad:	89 df                	mov    %ebx,%edi
  801aaf:	41 ff d4             	call   *%r12
  801ab2:	83 c3 01             	add    $0x1,%ebx
  801ab5:	83 fb 20             	cmp    $0x20,%ebx
  801ab8:	75 f3                	jne    801aad <close_all+0x1a>
}
  801aba:	5b                   	pop    %rbx
  801abb:	41 5c                	pop    %r12
  801abd:	5d                   	pop    %rbp
  801abe:	c3                   	ret

0000000000801abf <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801abf:	f3 0f 1e fa          	endbr64
  801ac3:	55                   	push   %rbp
  801ac4:	48 89 e5             	mov    %rsp,%rbp
  801ac7:	41 57                	push   %r15
  801ac9:	41 56                	push   %r14
  801acb:	41 55                	push   %r13
  801acd:	41 54                	push   %r12
  801acf:	53                   	push   %rbx
  801ad0:	48 83 ec 18          	sub    $0x18,%rsp
  801ad4:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801ad7:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801adb:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  801ae2:	00 00 00 
  801ae5:	ff d0                	call   *%rax
  801ae7:	89 c3                	mov    %eax,%ebx
  801ae9:	85 c0                	test   %eax,%eax
  801aeb:	0f 88 b8 00 00 00    	js     801ba9 <dup+0xea>
    close(newfdnum);
  801af1:	44 89 e7             	mov    %r12d,%edi
  801af4:	48 b8 5c 1a 80 00 00 	movabs $0x801a5c,%rax
  801afb:	00 00 00 
  801afe:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801b00:	4d 63 ec             	movslq %r12d,%r13
  801b03:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801b0a:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801b0e:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801b12:	4c 89 ff             	mov    %r15,%rdi
  801b15:	49 be 67 18 80 00 00 	movabs $0x801867,%r14
  801b1c:	00 00 00 
  801b1f:	41 ff d6             	call   *%r14
  801b22:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801b25:	4c 89 ef             	mov    %r13,%rdi
  801b28:	41 ff d6             	call   *%r14
  801b2b:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801b2e:	48 89 df             	mov    %rbx,%rdi
  801b31:	48 b8 e6 29 80 00 00 	movabs $0x8029e6,%rax
  801b38:	00 00 00 
  801b3b:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801b3d:	a8 04                	test   $0x4,%al
  801b3f:	74 2b                	je     801b6c <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801b41:	41 89 c1             	mov    %eax,%r9d
  801b44:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801b4a:	4c 89 f1             	mov    %r14,%rcx
  801b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b52:	48 89 de             	mov    %rbx,%rsi
  801b55:	bf 00 00 00 00       	mov    $0x0,%edi
  801b5a:	48 b8 e4 11 80 00 00 	movabs $0x8011e4,%rax
  801b61:	00 00 00 
  801b64:	ff d0                	call   *%rax
  801b66:	89 c3                	mov    %eax,%ebx
  801b68:	85 c0                	test   %eax,%eax
  801b6a:	78 4e                	js     801bba <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801b6c:	4c 89 ff             	mov    %r15,%rdi
  801b6f:	48 b8 e6 29 80 00 00 	movabs $0x8029e6,%rax
  801b76:	00 00 00 
  801b79:	ff d0                	call   *%rax
  801b7b:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801b7e:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801b84:	4c 89 e9             	mov    %r13,%rcx
  801b87:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8c:	4c 89 fe             	mov    %r15,%rsi
  801b8f:	bf 00 00 00 00       	mov    $0x0,%edi
  801b94:	48 b8 e4 11 80 00 00 	movabs $0x8011e4,%rax
  801b9b:	00 00 00 
  801b9e:	ff d0                	call   *%rax
  801ba0:	89 c3                	mov    %eax,%ebx
  801ba2:	85 c0                	test   %eax,%eax
  801ba4:	78 14                	js     801bba <dup+0xfb>

    return newfdnum;
  801ba6:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801ba9:	89 d8                	mov    %ebx,%eax
  801bab:	48 83 c4 18          	add    $0x18,%rsp
  801baf:	5b                   	pop    %rbx
  801bb0:	41 5c                	pop    %r12
  801bb2:	41 5d                	pop    %r13
  801bb4:	41 5e                	pop    %r14
  801bb6:	41 5f                	pop    %r15
  801bb8:	5d                   	pop    %rbp
  801bb9:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801bba:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bbf:	4c 89 ee             	mov    %r13,%rsi
  801bc2:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc7:	49 bc b9 12 80 00 00 	movabs $0x8012b9,%r12
  801bce:	00 00 00 
  801bd1:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801bd4:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bd9:	4c 89 f6             	mov    %r14,%rsi
  801bdc:	bf 00 00 00 00       	mov    $0x0,%edi
  801be1:	41 ff d4             	call   *%r12
    return res;
  801be4:	eb c3                	jmp    801ba9 <dup+0xea>

0000000000801be6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801be6:	f3 0f 1e fa          	endbr64
  801bea:	55                   	push   %rbp
  801beb:	48 89 e5             	mov    %rsp,%rbp
  801bee:	41 56                	push   %r14
  801bf0:	41 55                	push   %r13
  801bf2:	41 54                	push   %r12
  801bf4:	53                   	push   %rbx
  801bf5:	48 83 ec 10          	sub    $0x10,%rsp
  801bf9:	89 fb                	mov    %edi,%ebx
  801bfb:	49 89 f4             	mov    %rsi,%r12
  801bfe:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c01:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c05:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  801c0c:	00 00 00 
  801c0f:	ff d0                	call   *%rax
  801c11:	85 c0                	test   %eax,%eax
  801c13:	78 4c                	js     801c61 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c15:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801c19:	41 8b 3e             	mov    (%r14),%edi
  801c1c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c20:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  801c27:	00 00 00 
  801c2a:	ff d0                	call   *%rax
  801c2c:	85 c0                	test   %eax,%eax
  801c2e:	78 35                	js     801c65 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c30:	41 8b 46 08          	mov    0x8(%r14),%eax
  801c34:	83 e0 03             	and    $0x3,%eax
  801c37:	83 f8 01             	cmp    $0x1,%eax
  801c3a:	74 2d                	je     801c69 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801c3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c40:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c44:	48 85 c0             	test   %rax,%rax
  801c47:	74 56                	je     801c9f <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801c49:	4c 89 ea             	mov    %r13,%rdx
  801c4c:	4c 89 e6             	mov    %r12,%rsi
  801c4f:	4c 89 f7             	mov    %r14,%rdi
  801c52:	ff d0                	call   *%rax
}
  801c54:	48 83 c4 10          	add    $0x10,%rsp
  801c58:	5b                   	pop    %rbx
  801c59:	41 5c                	pop    %r12
  801c5b:	41 5d                	pop    %r13
  801c5d:	41 5e                	pop    %r14
  801c5f:	5d                   	pop    %rbp
  801c60:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c61:	48 98                	cltq
  801c63:	eb ef                	jmp    801c54 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c65:	48 98                	cltq
  801c67:	eb eb                	jmp    801c54 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c69:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801c70:	00 00 00 
  801c73:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c79:	89 da                	mov    %ebx,%edx
  801c7b:	48 bf 19 42 80 00 00 	movabs $0x804219,%rdi
  801c82:	00 00 00 
  801c85:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8a:	48 b9 2b 02 80 00 00 	movabs $0x80022b,%rcx
  801c91:	00 00 00 
  801c94:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c96:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801c9d:	eb b5                	jmp    801c54 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801c9f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801ca6:	eb ac                	jmp    801c54 <read+0x6e>

0000000000801ca8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801ca8:	f3 0f 1e fa          	endbr64
  801cac:	55                   	push   %rbp
  801cad:	48 89 e5             	mov    %rsp,%rbp
  801cb0:	41 57                	push   %r15
  801cb2:	41 56                	push   %r14
  801cb4:	41 55                	push   %r13
  801cb6:	41 54                	push   %r12
  801cb8:	53                   	push   %rbx
  801cb9:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801cbd:	48 85 d2             	test   %rdx,%rdx
  801cc0:	74 54                	je     801d16 <readn+0x6e>
  801cc2:	41 89 fd             	mov    %edi,%r13d
  801cc5:	49 89 f6             	mov    %rsi,%r14
  801cc8:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801ccb:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801cd0:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801cd5:	49 bf e6 1b 80 00 00 	movabs $0x801be6,%r15
  801cdc:	00 00 00 
  801cdf:	4c 89 e2             	mov    %r12,%rdx
  801ce2:	48 29 f2             	sub    %rsi,%rdx
  801ce5:	4c 01 f6             	add    %r14,%rsi
  801ce8:	44 89 ef             	mov    %r13d,%edi
  801ceb:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	78 20                	js     801d12 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801cf2:	01 c3                	add    %eax,%ebx
  801cf4:	85 c0                	test   %eax,%eax
  801cf6:	74 08                	je     801d00 <readn+0x58>
  801cf8:	48 63 f3             	movslq %ebx,%rsi
  801cfb:	4c 39 e6             	cmp    %r12,%rsi
  801cfe:	72 df                	jb     801cdf <readn+0x37>
    }
    return res;
  801d00:	48 63 c3             	movslq %ebx,%rax
}
  801d03:	48 83 c4 08          	add    $0x8,%rsp
  801d07:	5b                   	pop    %rbx
  801d08:	41 5c                	pop    %r12
  801d0a:	41 5d                	pop    %r13
  801d0c:	41 5e                	pop    %r14
  801d0e:	41 5f                	pop    %r15
  801d10:	5d                   	pop    %rbp
  801d11:	c3                   	ret
        if (inc < 0) return inc;
  801d12:	48 98                	cltq
  801d14:	eb ed                	jmp    801d03 <readn+0x5b>
    int inc = 1, res = 0;
  801d16:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d1b:	eb e3                	jmp    801d00 <readn+0x58>

0000000000801d1d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801d1d:	f3 0f 1e fa          	endbr64
  801d21:	55                   	push   %rbp
  801d22:	48 89 e5             	mov    %rsp,%rbp
  801d25:	41 56                	push   %r14
  801d27:	41 55                	push   %r13
  801d29:	41 54                	push   %r12
  801d2b:	53                   	push   %rbx
  801d2c:	48 83 ec 10          	sub    $0x10,%rsp
  801d30:	89 fb                	mov    %edi,%ebx
  801d32:	49 89 f4             	mov    %rsi,%r12
  801d35:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d38:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d3c:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  801d43:	00 00 00 
  801d46:	ff d0                	call   *%rax
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	78 47                	js     801d93 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d4c:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801d50:	41 8b 3e             	mov    (%r14),%edi
  801d53:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d57:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  801d5e:	00 00 00 
  801d61:	ff d0                	call   *%rax
  801d63:	85 c0                	test   %eax,%eax
  801d65:	78 30                	js     801d97 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d67:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801d6c:	74 2d                	je     801d9b <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801d6e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d72:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d76:	48 85 c0             	test   %rax,%rax
  801d79:	74 56                	je     801dd1 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801d7b:	4c 89 ea             	mov    %r13,%rdx
  801d7e:	4c 89 e6             	mov    %r12,%rsi
  801d81:	4c 89 f7             	mov    %r14,%rdi
  801d84:	ff d0                	call   *%rax
}
  801d86:	48 83 c4 10          	add    $0x10,%rsp
  801d8a:	5b                   	pop    %rbx
  801d8b:	41 5c                	pop    %r12
  801d8d:	41 5d                	pop    %r13
  801d8f:	41 5e                	pop    %r14
  801d91:	5d                   	pop    %rbp
  801d92:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d93:	48 98                	cltq
  801d95:	eb ef                	jmp    801d86 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d97:	48 98                	cltq
  801d99:	eb eb                	jmp    801d86 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801d9b:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801da2:	00 00 00 
  801da5:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801dab:	89 da                	mov    %ebx,%edx
  801dad:	48 bf 35 42 80 00 00 	movabs $0x804235,%rdi
  801db4:	00 00 00 
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbc:	48 b9 2b 02 80 00 00 	movabs $0x80022b,%rcx
  801dc3:	00 00 00 
  801dc6:	ff d1                	call   *%rcx
        return -E_INVAL;
  801dc8:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801dcf:	eb b5                	jmp    801d86 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801dd1:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801dd8:	eb ac                	jmp    801d86 <write+0x69>

0000000000801dda <seek>:

int
seek(int fdnum, off_t offset) {
  801dda:	f3 0f 1e fa          	endbr64
  801dde:	55                   	push   %rbp
  801ddf:	48 89 e5             	mov    %rsp,%rbp
  801de2:	53                   	push   %rbx
  801de3:	48 83 ec 18          	sub    $0x18,%rsp
  801de7:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801de9:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ded:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  801df4:	00 00 00 
  801df7:	ff d0                	call   *%rax
  801df9:	85 c0                	test   %eax,%eax
  801dfb:	78 0c                	js     801e09 <seek+0x2f>

    fd->fd_offset = offset;
  801dfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e01:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801e04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e09:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e0d:	c9                   	leave
  801e0e:	c3                   	ret

0000000000801e0f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801e0f:	f3 0f 1e fa          	endbr64
  801e13:	55                   	push   %rbp
  801e14:	48 89 e5             	mov    %rsp,%rbp
  801e17:	41 55                	push   %r13
  801e19:	41 54                	push   %r12
  801e1b:	53                   	push   %rbx
  801e1c:	48 83 ec 18          	sub    $0x18,%rsp
  801e20:	89 fb                	mov    %edi,%ebx
  801e22:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e25:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e29:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  801e30:	00 00 00 
  801e33:	ff d0                	call   *%rax
  801e35:	85 c0                	test   %eax,%eax
  801e37:	78 38                	js     801e71 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e39:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801e3d:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801e41:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e45:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  801e4c:	00 00 00 
  801e4f:	ff d0                	call   *%rax
  801e51:	85 c0                	test   %eax,%eax
  801e53:	78 1c                	js     801e71 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e55:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801e5a:	74 20                	je     801e7c <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801e5c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e60:	48 8b 40 30          	mov    0x30(%rax),%rax
  801e64:	48 85 c0             	test   %rax,%rax
  801e67:	74 47                	je     801eb0 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801e69:	44 89 e6             	mov    %r12d,%esi
  801e6c:	4c 89 ef             	mov    %r13,%rdi
  801e6f:	ff d0                	call   *%rax
}
  801e71:	48 83 c4 18          	add    $0x18,%rsp
  801e75:	5b                   	pop    %rbx
  801e76:	41 5c                	pop    %r12
  801e78:	41 5d                	pop    %r13
  801e7a:	5d                   	pop    %rbp
  801e7b:	c3                   	ret
                thisenv->env_id, fdnum);
  801e7c:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801e83:	00 00 00 
  801e86:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e8c:	89 da                	mov    %ebx,%edx
  801e8e:	48 bf b0 46 80 00 00 	movabs $0x8046b0,%rdi
  801e95:	00 00 00 
  801e98:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9d:	48 b9 2b 02 80 00 00 	movabs $0x80022b,%rcx
  801ea4:	00 00 00 
  801ea7:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ea9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eae:	eb c1                	jmp    801e71 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801eb0:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801eb5:	eb ba                	jmp    801e71 <ftruncate+0x62>

0000000000801eb7 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801eb7:	f3 0f 1e fa          	endbr64
  801ebb:	55                   	push   %rbp
  801ebc:	48 89 e5             	mov    %rsp,%rbp
  801ebf:	41 54                	push   %r12
  801ec1:	53                   	push   %rbx
  801ec2:	48 83 ec 10          	sub    $0x10,%rsp
  801ec6:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ec9:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ecd:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  801ed4:	00 00 00 
  801ed7:	ff d0                	call   *%rax
  801ed9:	85 c0                	test   %eax,%eax
  801edb:	78 4e                	js     801f2b <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801edd:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801ee1:	41 8b 3c 24          	mov    (%r12),%edi
  801ee5:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801ee9:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  801ef0:	00 00 00 
  801ef3:	ff d0                	call   *%rax
  801ef5:	85 c0                	test   %eax,%eax
  801ef7:	78 32                	js     801f2b <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801ef9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801efd:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801f02:	74 30                	je     801f34 <fstat+0x7d>

    stat->st_name[0] = 0;
  801f04:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801f07:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801f0e:	00 00 00 
    stat->st_isdir = 0;
  801f11:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801f18:	00 00 00 
    stat->st_dev = dev;
  801f1b:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801f22:	48 89 de             	mov    %rbx,%rsi
  801f25:	4c 89 e7             	mov    %r12,%rdi
  801f28:	ff 50 28             	call   *0x28(%rax)
}
  801f2b:	48 83 c4 10          	add    $0x10,%rsp
  801f2f:	5b                   	pop    %rbx
  801f30:	41 5c                	pop    %r12
  801f32:	5d                   	pop    %rbp
  801f33:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801f34:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f39:	eb f0                	jmp    801f2b <fstat+0x74>

0000000000801f3b <stat>:

int
stat(const char *path, struct Stat *stat) {
  801f3b:	f3 0f 1e fa          	endbr64
  801f3f:	55                   	push   %rbp
  801f40:	48 89 e5             	mov    %rsp,%rbp
  801f43:	41 54                	push   %r12
  801f45:	53                   	push   %rbx
  801f46:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801f49:	be 00 00 00 00       	mov    $0x0,%esi
  801f4e:	48 b8 1c 22 80 00 00 	movabs $0x80221c,%rax
  801f55:	00 00 00 
  801f58:	ff d0                	call   *%rax
  801f5a:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801f5c:	85 c0                	test   %eax,%eax
  801f5e:	78 25                	js     801f85 <stat+0x4a>

    int res = fstat(fd, stat);
  801f60:	4c 89 e6             	mov    %r12,%rsi
  801f63:	89 c7                	mov    %eax,%edi
  801f65:	48 b8 b7 1e 80 00 00 	movabs $0x801eb7,%rax
  801f6c:	00 00 00 
  801f6f:	ff d0                	call   *%rax
  801f71:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801f74:	89 df                	mov    %ebx,%edi
  801f76:	48 b8 5c 1a 80 00 00 	movabs $0x801a5c,%rax
  801f7d:	00 00 00 
  801f80:	ff d0                	call   *%rax

    return res;
  801f82:	44 89 e3             	mov    %r12d,%ebx
}
  801f85:	89 d8                	mov    %ebx,%eax
  801f87:	5b                   	pop    %rbx
  801f88:	41 5c                	pop    %r12
  801f8a:	5d                   	pop    %rbp
  801f8b:	c3                   	ret

0000000000801f8c <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801f8c:	f3 0f 1e fa          	endbr64
  801f90:	55                   	push   %rbp
  801f91:	48 89 e5             	mov    %rsp,%rbp
  801f94:	41 54                	push   %r12
  801f96:	53                   	push   %rbx
  801f97:	48 83 ec 10          	sub    $0x10,%rsp
  801f9b:	41 89 fc             	mov    %edi,%r12d
  801f9e:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801fa1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801fa8:	00 00 00 
  801fab:	83 38 00             	cmpl   $0x0,(%rax)
  801fae:	74 6e                	je     80201e <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801fb0:	bf 03 00 00 00       	mov    $0x3,%edi
  801fb5:	48 b8 ba 2f 80 00 00 	movabs $0x802fba,%rax
  801fbc:	00 00 00 
  801fbf:	ff d0                	call   *%rax
  801fc1:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801fc8:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801fca:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801fd0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801fd5:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  801fdc:	00 00 00 
  801fdf:	44 89 e6             	mov    %r12d,%esi
  801fe2:	89 c7                	mov    %eax,%edi
  801fe4:	48 b8 f8 2e 80 00 00 	movabs $0x802ef8,%rax
  801feb:	00 00 00 
  801fee:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801ff0:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801ff7:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801ff8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ffd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802001:	48 89 de             	mov    %rbx,%rsi
  802004:	bf 00 00 00 00       	mov    $0x0,%edi
  802009:	48 b8 5f 2e 80 00 00 	movabs $0x802e5f,%rax
  802010:	00 00 00 
  802013:	ff d0                	call   *%rax
}
  802015:	48 83 c4 10          	add    $0x10,%rsp
  802019:	5b                   	pop    %rbx
  80201a:	41 5c                	pop    %r12
  80201c:	5d                   	pop    %rbp
  80201d:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80201e:	bf 03 00 00 00       	mov    $0x3,%edi
  802023:	48 b8 ba 2f 80 00 00 	movabs $0x802fba,%rax
  80202a:	00 00 00 
  80202d:	ff d0                	call   *%rax
  80202f:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802036:	00 00 
  802038:	e9 73 ff ff ff       	jmp    801fb0 <fsipc+0x24>

000000000080203d <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  80203d:	f3 0f 1e fa          	endbr64
  802041:	55                   	push   %rbp
  802042:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802045:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80204c:	00 00 00 
  80204f:	8b 57 0c             	mov    0xc(%rdi),%edx
  802052:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802054:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802057:	be 00 00 00 00       	mov    $0x0,%esi
  80205c:	bf 02 00 00 00       	mov    $0x2,%edi
  802061:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  802068:	00 00 00 
  80206b:	ff d0                	call   *%rax
}
  80206d:	5d                   	pop    %rbp
  80206e:	c3                   	ret

000000000080206f <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80206f:	f3 0f 1e fa          	endbr64
  802073:	55                   	push   %rbp
  802074:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802077:	8b 47 0c             	mov    0xc(%rdi),%eax
  80207a:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802081:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802083:	be 00 00 00 00       	mov    $0x0,%esi
  802088:	bf 06 00 00 00       	mov    $0x6,%edi
  80208d:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  802094:	00 00 00 
  802097:	ff d0                	call   *%rax
}
  802099:	5d                   	pop    %rbp
  80209a:	c3                   	ret

000000000080209b <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  80209b:	f3 0f 1e fa          	endbr64
  80209f:	55                   	push   %rbp
  8020a0:	48 89 e5             	mov    %rsp,%rbp
  8020a3:	41 54                	push   %r12
  8020a5:	53                   	push   %rbx
  8020a6:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8020a9:	8b 47 0c             	mov    0xc(%rdi),%eax
  8020ac:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8020b3:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  8020b5:	be 00 00 00 00       	mov    $0x0,%esi
  8020ba:	bf 05 00 00 00       	mov    $0x5,%edi
  8020bf:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  8020c6:	00 00 00 
  8020c9:	ff d0                	call   *%rax
    if (res < 0) return res;
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	78 3d                	js     80210c <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8020cf:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  8020d6:	00 00 00 
  8020d9:	4c 89 e6             	mov    %r12,%rsi
  8020dc:	48 89 df             	mov    %rbx,%rdi
  8020df:	48 b8 74 0b 80 00 00 	movabs $0x800b74,%rax
  8020e6:	00 00 00 
  8020e9:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8020eb:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  8020f2:	00 
  8020f3:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8020f9:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  802100:	00 
  802101:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802107:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80210c:	5b                   	pop    %rbx
  80210d:	41 5c                	pop    %r12
  80210f:	5d                   	pop    %rbp
  802110:	c3                   	ret

0000000000802111 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802111:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  802115:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  80211c:	77 41                	ja     80215f <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  80211e:	55                   	push   %rbp
  80211f:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  802122:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802129:	00 00 00 
  80212c:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  80212f:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802131:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802135:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802139:	48 b8 8f 0d 80 00 00 	movabs $0x800d8f,%rax
  802140:	00 00 00 
  802143:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802145:	be 00 00 00 00       	mov    $0x0,%esi
  80214a:	bf 04 00 00 00       	mov    $0x4,%edi
  80214f:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  802156:	00 00 00 
  802159:	ff d0                	call   *%rax
  80215b:	48 98                	cltq
}
  80215d:	5d                   	pop    %rbp
  80215e:	c3                   	ret
        return -E_INVAL;
  80215f:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802166:	c3                   	ret

0000000000802167 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802167:	f3 0f 1e fa          	endbr64
  80216b:	55                   	push   %rbp
  80216c:	48 89 e5             	mov    %rsp,%rbp
  80216f:	41 55                	push   %r13
  802171:	41 54                	push   %r12
  802173:	53                   	push   %rbx
  802174:	48 83 ec 08          	sub    $0x8,%rsp
  802178:	49 89 f4             	mov    %rsi,%r12
  80217b:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80217e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802185:	00 00 00 
  802188:	8b 57 0c             	mov    0xc(%rdi),%edx
  80218b:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  80218d:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802191:	be 00 00 00 00       	mov    $0x0,%esi
  802196:	bf 03 00 00 00       	mov    $0x3,%edi
  80219b:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  8021a2:	00 00 00 
  8021a5:	ff d0                	call   *%rax
  8021a7:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  8021aa:	4d 85 ed             	test   %r13,%r13
  8021ad:	78 2a                	js     8021d9 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  8021af:	4c 89 ea             	mov    %r13,%rdx
  8021b2:	4c 39 eb             	cmp    %r13,%rbx
  8021b5:	72 30                	jb     8021e7 <devfile_read+0x80>
  8021b7:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  8021be:	7f 27                	jg     8021e7 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  8021c0:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8021c7:	00 00 00 
  8021ca:	4c 89 e7             	mov    %r12,%rdi
  8021cd:	48 b8 8f 0d 80 00 00 	movabs $0x800d8f,%rax
  8021d4:	00 00 00 
  8021d7:	ff d0                	call   *%rax
}
  8021d9:	4c 89 e8             	mov    %r13,%rax
  8021dc:	48 83 c4 08          	add    $0x8,%rsp
  8021e0:	5b                   	pop    %rbx
  8021e1:	41 5c                	pop    %r12
  8021e3:	41 5d                	pop    %r13
  8021e5:	5d                   	pop    %rbp
  8021e6:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8021e7:	48 b9 52 42 80 00 00 	movabs $0x804252,%rcx
  8021ee:	00 00 00 
  8021f1:	48 ba 04 42 80 00 00 	movabs $0x804204,%rdx
  8021f8:	00 00 00 
  8021fb:	be 7b 00 00 00       	mov    $0x7b,%esi
  802200:	48 bf 6f 42 80 00 00 	movabs $0x80426f,%rdi
  802207:	00 00 00 
  80220a:	b8 00 00 00 00       	mov    $0x0,%eax
  80220f:	49 b8 b8 2d 80 00 00 	movabs $0x802db8,%r8
  802216:	00 00 00 
  802219:	41 ff d0             	call   *%r8

000000000080221c <open>:
open(const char *path, int mode) {
  80221c:	f3 0f 1e fa          	endbr64
  802220:	55                   	push   %rbp
  802221:	48 89 e5             	mov    %rsp,%rbp
  802224:	41 55                	push   %r13
  802226:	41 54                	push   %r12
  802228:	53                   	push   %rbx
  802229:	48 83 ec 18          	sub    $0x18,%rsp
  80222d:	49 89 fc             	mov    %rdi,%r12
  802230:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802233:	48 b8 2f 0b 80 00 00 	movabs $0x800b2f,%rax
  80223a:	00 00 00 
  80223d:	ff d0                	call   *%rax
  80223f:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802245:	0f 87 8a 00 00 00    	ja     8022d5 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80224b:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80224f:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  802256:	00 00 00 
  802259:	ff d0                	call   *%rax
  80225b:	89 c3                	mov    %eax,%ebx
  80225d:	85 c0                	test   %eax,%eax
  80225f:	78 50                	js     8022b1 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802261:	4c 89 e6             	mov    %r12,%rsi
  802264:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  80226b:	00 00 00 
  80226e:	48 89 df             	mov    %rbx,%rdi
  802271:	48 b8 74 0b 80 00 00 	movabs $0x800b74,%rax
  802278:	00 00 00 
  80227b:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80227d:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802284:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802288:	bf 01 00 00 00       	mov    $0x1,%edi
  80228d:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  802294:	00 00 00 
  802297:	ff d0                	call   *%rax
  802299:	89 c3                	mov    %eax,%ebx
  80229b:	85 c0                	test   %eax,%eax
  80229d:	78 1f                	js     8022be <open+0xa2>
    return fd2num(fd);
  80229f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022a3:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  8022aa:	00 00 00 
  8022ad:	ff d0                	call   *%rax
  8022af:	89 c3                	mov    %eax,%ebx
}
  8022b1:	89 d8                	mov    %ebx,%eax
  8022b3:	48 83 c4 18          	add    $0x18,%rsp
  8022b7:	5b                   	pop    %rbx
  8022b8:	41 5c                	pop    %r12
  8022ba:	41 5d                	pop    %r13
  8022bc:	5d                   	pop    %rbp
  8022bd:	c3                   	ret
        fd_close(fd, 0);
  8022be:	be 00 00 00 00       	mov    $0x0,%esi
  8022c3:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022c7:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  8022ce:	00 00 00 
  8022d1:	ff d0                	call   *%rax
        return res;
  8022d3:	eb dc                	jmp    8022b1 <open+0x95>
        return -E_BAD_PATH;
  8022d5:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8022da:	eb d5                	jmp    8022b1 <open+0x95>

00000000008022dc <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8022dc:	f3 0f 1e fa          	endbr64
  8022e0:	55                   	push   %rbp
  8022e1:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8022e4:	be 00 00 00 00       	mov    $0x0,%esi
  8022e9:	bf 08 00 00 00       	mov    $0x8,%edi
  8022ee:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  8022f5:	00 00 00 
  8022f8:	ff d0                	call   *%rax
}
  8022fa:	5d                   	pop    %rbp
  8022fb:	c3                   	ret

00000000008022fc <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8022fc:	f3 0f 1e fa          	endbr64
  802300:	55                   	push   %rbp
  802301:	48 89 e5             	mov    %rsp,%rbp
  802304:	41 54                	push   %r12
  802306:	53                   	push   %rbx
  802307:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80230a:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  802311:	00 00 00 
  802314:	ff d0                	call   *%rax
  802316:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802319:	48 be 7a 42 80 00 00 	movabs $0x80427a,%rsi
  802320:	00 00 00 
  802323:	48 89 df             	mov    %rbx,%rdi
  802326:	48 b8 74 0b 80 00 00 	movabs $0x800b74,%rax
  80232d:	00 00 00 
  802330:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802332:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802337:	41 2b 04 24          	sub    (%r12),%eax
  80233b:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802341:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802348:	00 00 00 
    stat->st_dev = &devpipe;
  80234b:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802352:	00 00 00 
  802355:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80235c:	b8 00 00 00 00       	mov    $0x0,%eax
  802361:	5b                   	pop    %rbx
  802362:	41 5c                	pop    %r12
  802364:	5d                   	pop    %rbp
  802365:	c3                   	ret

0000000000802366 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802366:	f3 0f 1e fa          	endbr64
  80236a:	55                   	push   %rbp
  80236b:	48 89 e5             	mov    %rsp,%rbp
  80236e:	41 54                	push   %r12
  802370:	53                   	push   %rbx
  802371:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802374:	ba 00 10 00 00       	mov    $0x1000,%edx
  802379:	48 89 fe             	mov    %rdi,%rsi
  80237c:	bf 00 00 00 00       	mov    $0x0,%edi
  802381:	49 bc b9 12 80 00 00 	movabs $0x8012b9,%r12
  802388:	00 00 00 
  80238b:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80238e:	48 89 df             	mov    %rbx,%rdi
  802391:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  802398:	00 00 00 
  80239b:	ff d0                	call   *%rax
  80239d:	48 89 c6             	mov    %rax,%rsi
  8023a0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8023aa:	41 ff d4             	call   *%r12
}
  8023ad:	5b                   	pop    %rbx
  8023ae:	41 5c                	pop    %r12
  8023b0:	5d                   	pop    %rbp
  8023b1:	c3                   	ret

00000000008023b2 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8023b2:	f3 0f 1e fa          	endbr64
  8023b6:	55                   	push   %rbp
  8023b7:	48 89 e5             	mov    %rsp,%rbp
  8023ba:	41 57                	push   %r15
  8023bc:	41 56                	push   %r14
  8023be:	41 55                	push   %r13
  8023c0:	41 54                	push   %r12
  8023c2:	53                   	push   %rbx
  8023c3:	48 83 ec 18          	sub    $0x18,%rsp
  8023c7:	49 89 fc             	mov    %rdi,%r12
  8023ca:	49 89 f5             	mov    %rsi,%r13
  8023cd:	49 89 d7             	mov    %rdx,%r15
  8023d0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8023d4:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  8023db:	00 00 00 
  8023de:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8023e0:	4d 85 ff             	test   %r15,%r15
  8023e3:	0f 84 af 00 00 00    	je     802498 <devpipe_write+0xe6>
  8023e9:	48 89 c3             	mov    %rax,%rbx
  8023ec:	4c 89 f8             	mov    %r15,%rax
  8023ef:	4d 89 ef             	mov    %r13,%r15
  8023f2:	4c 01 e8             	add    %r13,%rax
  8023f5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023f9:	49 bd 49 11 80 00 00 	movabs $0x801149,%r13
  802400:	00 00 00 
            sys_yield();
  802403:	49 be de 10 80 00 00 	movabs $0x8010de,%r14
  80240a:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80240d:	8b 73 04             	mov    0x4(%rbx),%esi
  802410:	48 63 ce             	movslq %esi,%rcx
  802413:	48 63 03             	movslq (%rbx),%rax
  802416:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80241c:	48 39 c1             	cmp    %rax,%rcx
  80241f:	72 2e                	jb     80244f <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802421:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802426:	48 89 da             	mov    %rbx,%rdx
  802429:	be 00 10 00 00       	mov    $0x1000,%esi
  80242e:	4c 89 e7             	mov    %r12,%rdi
  802431:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802434:	85 c0                	test   %eax,%eax
  802436:	74 66                	je     80249e <devpipe_write+0xec>
            sys_yield();
  802438:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80243b:	8b 73 04             	mov    0x4(%rbx),%esi
  80243e:	48 63 ce             	movslq %esi,%rcx
  802441:	48 63 03             	movslq (%rbx),%rax
  802444:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80244a:	48 39 c1             	cmp    %rax,%rcx
  80244d:	73 d2                	jae    802421 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80244f:	41 0f b6 3f          	movzbl (%r15),%edi
  802453:	48 89 ca             	mov    %rcx,%rdx
  802456:	48 c1 ea 03          	shr    $0x3,%rdx
  80245a:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802461:	08 10 20 
  802464:	48 f7 e2             	mul    %rdx
  802467:	48 c1 ea 06          	shr    $0x6,%rdx
  80246b:	48 89 d0             	mov    %rdx,%rax
  80246e:	48 c1 e0 09          	shl    $0x9,%rax
  802472:	48 29 d0             	sub    %rdx,%rax
  802475:	48 c1 e0 03          	shl    $0x3,%rax
  802479:	48 29 c1             	sub    %rax,%rcx
  80247c:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802481:	83 c6 01             	add    $0x1,%esi
  802484:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802487:	49 83 c7 01          	add    $0x1,%r15
  80248b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80248f:	49 39 c7             	cmp    %rax,%r15
  802492:	0f 85 75 ff ff ff    	jne    80240d <devpipe_write+0x5b>
    return n;
  802498:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80249c:	eb 05                	jmp    8024a3 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  80249e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a3:	48 83 c4 18          	add    $0x18,%rsp
  8024a7:	5b                   	pop    %rbx
  8024a8:	41 5c                	pop    %r12
  8024aa:	41 5d                	pop    %r13
  8024ac:	41 5e                	pop    %r14
  8024ae:	41 5f                	pop    %r15
  8024b0:	5d                   	pop    %rbp
  8024b1:	c3                   	ret

00000000008024b2 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8024b2:	f3 0f 1e fa          	endbr64
  8024b6:	55                   	push   %rbp
  8024b7:	48 89 e5             	mov    %rsp,%rbp
  8024ba:	41 57                	push   %r15
  8024bc:	41 56                	push   %r14
  8024be:	41 55                	push   %r13
  8024c0:	41 54                	push   %r12
  8024c2:	53                   	push   %rbx
  8024c3:	48 83 ec 18          	sub    $0x18,%rsp
  8024c7:	49 89 fc             	mov    %rdi,%r12
  8024ca:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8024ce:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8024d2:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  8024d9:	00 00 00 
  8024dc:	ff d0                	call   *%rax
  8024de:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8024e1:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024e7:	49 bd 49 11 80 00 00 	movabs $0x801149,%r13
  8024ee:	00 00 00 
            sys_yield();
  8024f1:	49 be de 10 80 00 00 	movabs $0x8010de,%r14
  8024f8:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8024fb:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802500:	74 7d                	je     80257f <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802502:	8b 03                	mov    (%rbx),%eax
  802504:	3b 43 04             	cmp    0x4(%rbx),%eax
  802507:	75 26                	jne    80252f <devpipe_read+0x7d>
            if (i > 0) return i;
  802509:	4d 85 ff             	test   %r15,%r15
  80250c:	75 77                	jne    802585 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80250e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802513:	48 89 da             	mov    %rbx,%rdx
  802516:	be 00 10 00 00       	mov    $0x1000,%esi
  80251b:	4c 89 e7             	mov    %r12,%rdi
  80251e:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802521:	85 c0                	test   %eax,%eax
  802523:	74 72                	je     802597 <devpipe_read+0xe5>
            sys_yield();
  802525:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802528:	8b 03                	mov    (%rbx),%eax
  80252a:	3b 43 04             	cmp    0x4(%rbx),%eax
  80252d:	74 df                	je     80250e <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80252f:	48 63 c8             	movslq %eax,%rcx
  802532:	48 89 ca             	mov    %rcx,%rdx
  802535:	48 c1 ea 03          	shr    $0x3,%rdx
  802539:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802540:	08 10 20 
  802543:	48 89 d0             	mov    %rdx,%rax
  802546:	48 f7 e6             	mul    %rsi
  802549:	48 c1 ea 06          	shr    $0x6,%rdx
  80254d:	48 89 d0             	mov    %rdx,%rax
  802550:	48 c1 e0 09          	shl    $0x9,%rax
  802554:	48 29 d0             	sub    %rdx,%rax
  802557:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80255e:	00 
  80255f:	48 89 c8             	mov    %rcx,%rax
  802562:	48 29 d0             	sub    %rdx,%rax
  802565:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80256a:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80256e:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802572:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802575:	49 83 c7 01          	add    $0x1,%r15
  802579:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80257d:	75 83                	jne    802502 <devpipe_read+0x50>
    return n;
  80257f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802583:	eb 03                	jmp    802588 <devpipe_read+0xd6>
            if (i > 0) return i;
  802585:	4c 89 f8             	mov    %r15,%rax
}
  802588:	48 83 c4 18          	add    $0x18,%rsp
  80258c:	5b                   	pop    %rbx
  80258d:	41 5c                	pop    %r12
  80258f:	41 5d                	pop    %r13
  802591:	41 5e                	pop    %r14
  802593:	41 5f                	pop    %r15
  802595:	5d                   	pop    %rbp
  802596:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802597:	b8 00 00 00 00       	mov    $0x0,%eax
  80259c:	eb ea                	jmp    802588 <devpipe_read+0xd6>

000000000080259e <pipe>:
pipe(int pfd[2]) {
  80259e:	f3 0f 1e fa          	endbr64
  8025a2:	55                   	push   %rbp
  8025a3:	48 89 e5             	mov    %rsp,%rbp
  8025a6:	41 55                	push   %r13
  8025a8:	41 54                	push   %r12
  8025aa:	53                   	push   %rbx
  8025ab:	48 83 ec 18          	sub    $0x18,%rsp
  8025af:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8025b2:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8025b6:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  8025bd:	00 00 00 
  8025c0:	ff d0                	call   *%rax
  8025c2:	89 c3                	mov    %eax,%ebx
  8025c4:	85 c0                	test   %eax,%eax
  8025c6:	0f 88 a0 01 00 00    	js     80276c <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8025cc:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025d1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025d6:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8025da:	bf 00 00 00 00       	mov    $0x0,%edi
  8025df:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  8025e6:	00 00 00 
  8025e9:	ff d0                	call   *%rax
  8025eb:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	0f 88 77 01 00 00    	js     80276c <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8025f5:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8025f9:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  802600:	00 00 00 
  802603:	ff d0                	call   *%rax
  802605:	89 c3                	mov    %eax,%ebx
  802607:	85 c0                	test   %eax,%eax
  802609:	0f 88 43 01 00 00    	js     802752 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80260f:	b9 46 00 00 00       	mov    $0x46,%ecx
  802614:	ba 00 10 00 00       	mov    $0x1000,%edx
  802619:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80261d:	bf 00 00 00 00       	mov    $0x0,%edi
  802622:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  802629:	00 00 00 
  80262c:	ff d0                	call   *%rax
  80262e:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802630:	85 c0                	test   %eax,%eax
  802632:	0f 88 1a 01 00 00    	js     802752 <pipe+0x1b4>
    va = fd2data(fd0);
  802638:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80263c:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  802643:	00 00 00 
  802646:	ff d0                	call   *%rax
  802648:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80264b:	b9 46 00 00 00       	mov    $0x46,%ecx
  802650:	ba 00 10 00 00       	mov    $0x1000,%edx
  802655:	48 89 c6             	mov    %rax,%rsi
  802658:	bf 00 00 00 00       	mov    $0x0,%edi
  80265d:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  802664:	00 00 00 
  802667:	ff d0                	call   *%rax
  802669:	89 c3                	mov    %eax,%ebx
  80266b:	85 c0                	test   %eax,%eax
  80266d:	0f 88 c5 00 00 00    	js     802738 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802673:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802677:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  80267e:	00 00 00 
  802681:	ff d0                	call   *%rax
  802683:	48 89 c1             	mov    %rax,%rcx
  802686:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80268c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802692:	ba 00 00 00 00       	mov    $0x0,%edx
  802697:	4c 89 ee             	mov    %r13,%rsi
  80269a:	bf 00 00 00 00       	mov    $0x0,%edi
  80269f:	48 b8 e4 11 80 00 00 	movabs $0x8011e4,%rax
  8026a6:	00 00 00 
  8026a9:	ff d0                	call   *%rax
  8026ab:	89 c3                	mov    %eax,%ebx
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	78 6e                	js     80271f <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8026b1:	be 00 10 00 00       	mov    $0x1000,%esi
  8026b6:	4c 89 ef             	mov    %r13,%rdi
  8026b9:	48 b8 13 11 80 00 00 	movabs $0x801113,%rax
  8026c0:	00 00 00 
  8026c3:	ff d0                	call   *%rax
  8026c5:	83 f8 02             	cmp    $0x2,%eax
  8026c8:	0f 85 ab 00 00 00    	jne    802779 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8026ce:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  8026d5:	00 00 
  8026d7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026db:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8026dd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026e1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8026e8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8026ec:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8026ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026f2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8026f9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8026fd:	48 bb 51 18 80 00 00 	movabs $0x801851,%rbx
  802704:	00 00 00 
  802707:	ff d3                	call   *%rbx
  802709:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80270d:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802711:	ff d3                	call   *%rbx
  802713:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802718:	bb 00 00 00 00       	mov    $0x0,%ebx
  80271d:	eb 4d                	jmp    80276c <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  80271f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802724:	4c 89 ee             	mov    %r13,%rsi
  802727:	bf 00 00 00 00       	mov    $0x0,%edi
  80272c:	48 b8 b9 12 80 00 00 	movabs $0x8012b9,%rax
  802733:	00 00 00 
  802736:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802738:	ba 00 10 00 00       	mov    $0x1000,%edx
  80273d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802741:	bf 00 00 00 00       	mov    $0x0,%edi
  802746:	48 b8 b9 12 80 00 00 	movabs $0x8012b9,%rax
  80274d:	00 00 00 
  802750:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802752:	ba 00 10 00 00       	mov    $0x1000,%edx
  802757:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80275b:	bf 00 00 00 00       	mov    $0x0,%edi
  802760:	48 b8 b9 12 80 00 00 	movabs $0x8012b9,%rax
  802767:	00 00 00 
  80276a:	ff d0                	call   *%rax
}
  80276c:	89 d8                	mov    %ebx,%eax
  80276e:	48 83 c4 18          	add    $0x18,%rsp
  802772:	5b                   	pop    %rbx
  802773:	41 5c                	pop    %r12
  802775:	41 5d                	pop    %r13
  802777:	5d                   	pop    %rbp
  802778:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802779:	48 b9 d8 46 80 00 00 	movabs $0x8046d8,%rcx
  802780:	00 00 00 
  802783:	48 ba 04 42 80 00 00 	movabs $0x804204,%rdx
  80278a:	00 00 00 
  80278d:	be 2e 00 00 00       	mov    $0x2e,%esi
  802792:	48 bf 81 42 80 00 00 	movabs $0x804281,%rdi
  802799:	00 00 00 
  80279c:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a1:	49 b8 b8 2d 80 00 00 	movabs $0x802db8,%r8
  8027a8:	00 00 00 
  8027ab:	41 ff d0             	call   *%r8

00000000008027ae <pipeisclosed>:
pipeisclosed(int fdnum) {
  8027ae:	f3 0f 1e fa          	endbr64
  8027b2:	55                   	push   %rbp
  8027b3:	48 89 e5             	mov    %rsp,%rbp
  8027b6:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8027ba:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8027be:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  8027c5:	00 00 00 
  8027c8:	ff d0                	call   *%rax
    if (res < 0) return res;
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	78 35                	js     802803 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8027ce:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8027d2:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  8027d9:	00 00 00 
  8027dc:	ff d0                	call   *%rax
  8027de:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8027e1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8027e6:	be 00 10 00 00       	mov    $0x1000,%esi
  8027eb:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8027ef:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  8027f6:	00 00 00 
  8027f9:	ff d0                	call   *%rax
  8027fb:	85 c0                	test   %eax,%eax
  8027fd:	0f 94 c0             	sete   %al
  802800:	0f b6 c0             	movzbl %al,%eax
}
  802803:	c9                   	leave
  802804:	c3                   	ret

0000000000802805 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802805:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802809:	48 89 f8             	mov    %rdi,%rax
  80280c:	48 c1 e8 27          	shr    $0x27,%rax
  802810:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802817:	7f 00 00 
  80281a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80281e:	f6 c2 01             	test   $0x1,%dl
  802821:	74 6d                	je     802890 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802823:	48 89 f8             	mov    %rdi,%rax
  802826:	48 c1 e8 1e          	shr    $0x1e,%rax
  80282a:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802831:	7f 00 00 
  802834:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802838:	f6 c2 01             	test   $0x1,%dl
  80283b:	74 62                	je     80289f <get_uvpt_entry+0x9a>
  80283d:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802844:	7f 00 00 
  802847:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80284b:	f6 c2 80             	test   $0x80,%dl
  80284e:	75 4f                	jne    80289f <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802850:	48 89 f8             	mov    %rdi,%rax
  802853:	48 c1 e8 15          	shr    $0x15,%rax
  802857:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80285e:	7f 00 00 
  802861:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802865:	f6 c2 01             	test   $0x1,%dl
  802868:	74 44                	je     8028ae <get_uvpt_entry+0xa9>
  80286a:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802871:	7f 00 00 
  802874:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802878:	f6 c2 80             	test   $0x80,%dl
  80287b:	75 31                	jne    8028ae <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80287d:	48 c1 ef 0c          	shr    $0xc,%rdi
  802881:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802888:	7f 00 00 
  80288b:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80288f:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802890:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802897:	7f 00 00 
  80289a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80289e:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80289f:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8028a6:	7f 00 00 
  8028a9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8028ad:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8028ae:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8028b5:	7f 00 00 
  8028b8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8028bc:	c3                   	ret

00000000008028bd <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8028bd:	f3 0f 1e fa          	endbr64
  8028c1:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8028c4:	48 89 f9             	mov    %rdi,%rcx
  8028c7:	48 c1 e9 27          	shr    $0x27,%rcx
  8028cb:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8028d2:	7f 00 00 
  8028d5:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8028d9:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8028e0:	f6 c1 01             	test   $0x1,%cl
  8028e3:	0f 84 b2 00 00 00    	je     80299b <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8028e9:	48 89 f9             	mov    %rdi,%rcx
  8028ec:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8028f0:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8028f7:	7f 00 00 
  8028fa:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8028fe:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802905:	40 f6 c6 01          	test   $0x1,%sil
  802909:	0f 84 8c 00 00 00    	je     80299b <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  80290f:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802916:	7f 00 00 
  802919:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80291d:	a8 80                	test   $0x80,%al
  80291f:	75 7b                	jne    80299c <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802921:	48 89 f9             	mov    %rdi,%rcx
  802924:	48 c1 e9 15          	shr    $0x15,%rcx
  802928:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80292f:	7f 00 00 
  802932:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802936:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  80293d:	40 f6 c6 01          	test   $0x1,%sil
  802941:	74 58                	je     80299b <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802943:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80294a:	7f 00 00 
  80294d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802951:	a8 80                	test   $0x80,%al
  802953:	75 6c                	jne    8029c1 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802955:	48 89 f9             	mov    %rdi,%rcx
  802958:	48 c1 e9 0c          	shr    $0xc,%rcx
  80295c:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802963:	7f 00 00 
  802966:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80296a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802971:	40 f6 c6 01          	test   $0x1,%sil
  802975:	74 24                	je     80299b <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802977:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80297e:	7f 00 00 
  802981:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802985:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80298c:	ff ff 7f 
  80298f:	48 21 c8             	and    %rcx,%rax
  802992:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802998:	48 09 d0             	or     %rdx,%rax
}
  80299b:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  80299c:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8029a3:	7f 00 00 
  8029a6:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8029aa:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8029b1:	ff ff 7f 
  8029b4:	48 21 c8             	and    %rcx,%rax
  8029b7:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8029bd:	48 01 d0             	add    %rdx,%rax
  8029c0:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8029c1:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8029c8:	7f 00 00 
  8029cb:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8029cf:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8029d6:	ff ff 7f 
  8029d9:	48 21 c8             	and    %rcx,%rax
  8029dc:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8029e2:	48 01 d0             	add    %rdx,%rax
  8029e5:	c3                   	ret

00000000008029e6 <get_prot>:

int
get_prot(void *va) {
  8029e6:	f3 0f 1e fa          	endbr64
  8029ea:	55                   	push   %rbp
  8029eb:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8029ee:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  8029f5:	00 00 00 
  8029f8:	ff d0                	call   *%rax
  8029fa:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8029fd:	83 e0 01             	and    $0x1,%eax
  802a00:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802a03:	89 d1                	mov    %edx,%ecx
  802a05:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802a0b:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802a0d:	89 c1                	mov    %eax,%ecx
  802a0f:	83 c9 02             	or     $0x2,%ecx
  802a12:	f6 c2 02             	test   $0x2,%dl
  802a15:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802a18:	89 c1                	mov    %eax,%ecx
  802a1a:	83 c9 01             	or     $0x1,%ecx
  802a1d:	48 85 d2             	test   %rdx,%rdx
  802a20:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802a23:	89 c1                	mov    %eax,%ecx
  802a25:	83 c9 40             	or     $0x40,%ecx
  802a28:	f6 c6 04             	test   $0x4,%dh
  802a2b:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802a2e:	5d                   	pop    %rbp
  802a2f:	c3                   	ret

0000000000802a30 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802a30:	f3 0f 1e fa          	endbr64
  802a34:	55                   	push   %rbp
  802a35:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802a38:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  802a3f:	00 00 00 
  802a42:	ff d0                	call   *%rax
    return pte & PTE_D;
  802a44:	48 c1 e8 06          	shr    $0x6,%rax
  802a48:	83 e0 01             	and    $0x1,%eax
}
  802a4b:	5d                   	pop    %rbp
  802a4c:	c3                   	ret

0000000000802a4d <is_page_present>:

bool
is_page_present(void *va) {
  802a4d:	f3 0f 1e fa          	endbr64
  802a51:	55                   	push   %rbp
  802a52:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802a55:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  802a5c:	00 00 00 
  802a5f:	ff d0                	call   *%rax
  802a61:	83 e0 01             	and    $0x1,%eax
}
  802a64:	5d                   	pop    %rbp
  802a65:	c3                   	ret

0000000000802a66 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802a66:	f3 0f 1e fa          	endbr64
  802a6a:	55                   	push   %rbp
  802a6b:	48 89 e5             	mov    %rsp,%rbp
  802a6e:	41 57                	push   %r15
  802a70:	41 56                	push   %r14
  802a72:	41 55                	push   %r13
  802a74:	41 54                	push   %r12
  802a76:	53                   	push   %rbx
  802a77:	48 83 ec 18          	sub    $0x18,%rsp
  802a7b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802a7f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802a83:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802a88:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802a8f:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802a92:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802a99:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802a9c:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802aa3:	00 00 00 
  802aa6:	eb 73                	jmp    802b1b <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802aa8:	48 89 d8             	mov    %rbx,%rax
  802aab:	48 c1 e8 15          	shr    $0x15,%rax
  802aaf:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802ab6:	7f 00 00 
  802ab9:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802abd:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802ac3:	f6 c2 01             	test   $0x1,%dl
  802ac6:	74 4b                	je     802b13 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802ac8:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802acc:	f6 c2 80             	test   $0x80,%dl
  802acf:	74 11                	je     802ae2 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802ad1:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802ad5:	f6 c4 04             	test   $0x4,%ah
  802ad8:	74 39                	je     802b13 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802ada:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802ae0:	eb 20                	jmp    802b02 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802ae2:	48 89 da             	mov    %rbx,%rdx
  802ae5:	48 c1 ea 0c          	shr    $0xc,%rdx
  802ae9:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802af0:	7f 00 00 
  802af3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802af7:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802afd:	f6 c4 04             	test   $0x4,%ah
  802b00:	74 11                	je     802b13 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802b02:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802b06:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802b0a:	48 89 df             	mov    %rbx,%rdi
  802b0d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b11:	ff d0                	call   *%rax
    next:
        va += size;
  802b13:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802b16:	49 39 df             	cmp    %rbx,%r15
  802b19:	72 3e                	jb     802b59 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802b1b:	49 8b 06             	mov    (%r14),%rax
  802b1e:	a8 01                	test   $0x1,%al
  802b20:	74 37                	je     802b59 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802b22:	48 89 d8             	mov    %rbx,%rax
  802b25:	48 c1 e8 1e          	shr    $0x1e,%rax
  802b29:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802b2e:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802b34:	f6 c2 01             	test   $0x1,%dl
  802b37:	74 da                	je     802b13 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802b39:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802b3e:	f6 c2 80             	test   $0x80,%dl
  802b41:	0f 84 61 ff ff ff    	je     802aa8 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802b47:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802b4c:	f6 c4 04             	test   $0x4,%ah
  802b4f:	74 c2                	je     802b13 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802b51:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802b57:	eb a9                	jmp    802b02 <foreach_shared_region+0x9c>
    }
    return res;
}
  802b59:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5e:	48 83 c4 18          	add    $0x18,%rsp
  802b62:	5b                   	pop    %rbx
  802b63:	41 5c                	pop    %r12
  802b65:	41 5d                	pop    %r13
  802b67:	41 5e                	pop    %r14
  802b69:	41 5f                	pop    %r15
  802b6b:	5d                   	pop    %rbp
  802b6c:	c3                   	ret

0000000000802b6d <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802b6d:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802b71:	b8 00 00 00 00       	mov    $0x0,%eax
  802b76:	c3                   	ret

0000000000802b77 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802b77:	f3 0f 1e fa          	endbr64
  802b7b:	55                   	push   %rbp
  802b7c:	48 89 e5             	mov    %rsp,%rbp
  802b7f:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802b82:	48 be 91 42 80 00 00 	movabs $0x804291,%rsi
  802b89:	00 00 00 
  802b8c:	48 b8 74 0b 80 00 00 	movabs $0x800b74,%rax
  802b93:	00 00 00 
  802b96:	ff d0                	call   *%rax
    return 0;
}
  802b98:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9d:	5d                   	pop    %rbp
  802b9e:	c3                   	ret

0000000000802b9f <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802b9f:	f3 0f 1e fa          	endbr64
  802ba3:	55                   	push   %rbp
  802ba4:	48 89 e5             	mov    %rsp,%rbp
  802ba7:	41 57                	push   %r15
  802ba9:	41 56                	push   %r14
  802bab:	41 55                	push   %r13
  802bad:	41 54                	push   %r12
  802baf:	53                   	push   %rbx
  802bb0:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802bb7:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802bbe:	48 85 d2             	test   %rdx,%rdx
  802bc1:	74 7a                	je     802c3d <devcons_write+0x9e>
  802bc3:	49 89 d6             	mov    %rdx,%r14
  802bc6:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802bcc:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802bd1:	49 bf 8f 0d 80 00 00 	movabs $0x800d8f,%r15
  802bd8:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802bdb:	4c 89 f3             	mov    %r14,%rbx
  802bde:	48 29 f3             	sub    %rsi,%rbx
  802be1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802be6:	48 39 c3             	cmp    %rax,%rbx
  802be9:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802bed:	4c 63 eb             	movslq %ebx,%r13
  802bf0:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802bf7:	48 01 c6             	add    %rax,%rsi
  802bfa:	4c 89 ea             	mov    %r13,%rdx
  802bfd:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802c04:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802c07:	4c 89 ee             	mov    %r13,%rsi
  802c0a:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802c11:	48 b8 d4 0f 80 00 00 	movabs $0x800fd4,%rax
  802c18:	00 00 00 
  802c1b:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802c1d:	41 01 dc             	add    %ebx,%r12d
  802c20:	49 63 f4             	movslq %r12d,%rsi
  802c23:	4c 39 f6             	cmp    %r14,%rsi
  802c26:	72 b3                	jb     802bdb <devcons_write+0x3c>
    return res;
  802c28:	49 63 c4             	movslq %r12d,%rax
}
  802c2b:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802c32:	5b                   	pop    %rbx
  802c33:	41 5c                	pop    %r12
  802c35:	41 5d                	pop    %r13
  802c37:	41 5e                	pop    %r14
  802c39:	41 5f                	pop    %r15
  802c3b:	5d                   	pop    %rbp
  802c3c:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802c3d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802c43:	eb e3                	jmp    802c28 <devcons_write+0x89>

0000000000802c45 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802c45:	f3 0f 1e fa          	endbr64
  802c49:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802c4c:	ba 00 00 00 00       	mov    $0x0,%edx
  802c51:	48 85 c0             	test   %rax,%rax
  802c54:	74 55                	je     802cab <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802c56:	55                   	push   %rbp
  802c57:	48 89 e5             	mov    %rsp,%rbp
  802c5a:	41 55                	push   %r13
  802c5c:	41 54                	push   %r12
  802c5e:	53                   	push   %rbx
  802c5f:	48 83 ec 08          	sub    $0x8,%rsp
  802c63:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802c66:	48 bb 05 10 80 00 00 	movabs $0x801005,%rbx
  802c6d:	00 00 00 
  802c70:	49 bc de 10 80 00 00 	movabs $0x8010de,%r12
  802c77:	00 00 00 
  802c7a:	eb 03                	jmp    802c7f <devcons_read+0x3a>
  802c7c:	41 ff d4             	call   *%r12
  802c7f:	ff d3                	call   *%rbx
  802c81:	85 c0                	test   %eax,%eax
  802c83:	74 f7                	je     802c7c <devcons_read+0x37>
    if (c < 0) return c;
  802c85:	48 63 d0             	movslq %eax,%rdx
  802c88:	78 13                	js     802c9d <devcons_read+0x58>
    if (c == 0x04) return 0;
  802c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  802c8f:	83 f8 04             	cmp    $0x4,%eax
  802c92:	74 09                	je     802c9d <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802c94:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802c98:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802c9d:	48 89 d0             	mov    %rdx,%rax
  802ca0:	48 83 c4 08          	add    $0x8,%rsp
  802ca4:	5b                   	pop    %rbx
  802ca5:	41 5c                	pop    %r12
  802ca7:	41 5d                	pop    %r13
  802ca9:	5d                   	pop    %rbp
  802caa:	c3                   	ret
  802cab:	48 89 d0             	mov    %rdx,%rax
  802cae:	c3                   	ret

0000000000802caf <cputchar>:
cputchar(int ch) {
  802caf:	f3 0f 1e fa          	endbr64
  802cb3:	55                   	push   %rbp
  802cb4:	48 89 e5             	mov    %rsp,%rbp
  802cb7:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802cbb:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802cbf:	be 01 00 00 00       	mov    $0x1,%esi
  802cc4:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802cc8:	48 b8 d4 0f 80 00 00 	movabs $0x800fd4,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	call   *%rax
}
  802cd4:	c9                   	leave
  802cd5:	c3                   	ret

0000000000802cd6 <getchar>:
getchar(void) {
  802cd6:	f3 0f 1e fa          	endbr64
  802cda:	55                   	push   %rbp
  802cdb:	48 89 e5             	mov    %rsp,%rbp
  802cde:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802ce2:	ba 01 00 00 00       	mov    $0x1,%edx
  802ce7:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802ceb:	bf 00 00 00 00       	mov    $0x0,%edi
  802cf0:	48 b8 e6 1b 80 00 00 	movabs $0x801be6,%rax
  802cf7:	00 00 00 
  802cfa:	ff d0                	call   *%rax
  802cfc:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	78 06                	js     802d08 <getchar+0x32>
  802d02:	74 08                	je     802d0c <getchar+0x36>
  802d04:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802d08:	89 d0                	mov    %edx,%eax
  802d0a:	c9                   	leave
  802d0b:	c3                   	ret
    return res < 0 ? res : res ? c :
  802d0c:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802d11:	eb f5                	jmp    802d08 <getchar+0x32>

0000000000802d13 <iscons>:
iscons(int fdnum) {
  802d13:	f3 0f 1e fa          	endbr64
  802d17:	55                   	push   %rbp
  802d18:	48 89 e5             	mov    %rsp,%rbp
  802d1b:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802d1f:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802d23:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  802d2a:	00 00 00 
  802d2d:	ff d0                	call   *%rax
    if (res < 0) return res;
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	78 18                	js     802d4b <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802d33:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d37:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802d3e:	00 00 00 
  802d41:	8b 00                	mov    (%rax),%eax
  802d43:	39 02                	cmp    %eax,(%rdx)
  802d45:	0f 94 c0             	sete   %al
  802d48:	0f b6 c0             	movzbl %al,%eax
}
  802d4b:	c9                   	leave
  802d4c:	c3                   	ret

0000000000802d4d <opencons>:
opencons(void) {
  802d4d:	f3 0f 1e fa          	endbr64
  802d51:	55                   	push   %rbp
  802d52:	48 89 e5             	mov    %rsp,%rbp
  802d55:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802d59:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802d5d:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  802d64:	00 00 00 
  802d67:	ff d0                	call   *%rax
  802d69:	85 c0                	test   %eax,%eax
  802d6b:	78 49                	js     802db6 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802d6d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802d72:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d77:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802d7b:	bf 00 00 00 00       	mov    $0x0,%edi
  802d80:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  802d87:	00 00 00 
  802d8a:	ff d0                	call   *%rax
  802d8c:	85 c0                	test   %eax,%eax
  802d8e:	78 26                	js     802db6 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802d90:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d94:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802d9b:	00 00 
  802d9d:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802d9f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802da3:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802daa:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  802db1:	00 00 00 
  802db4:	ff d0                	call   *%rax
}
  802db6:	c9                   	leave
  802db7:	c3                   	ret

0000000000802db8 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802db8:	f3 0f 1e fa          	endbr64
  802dbc:	55                   	push   %rbp
  802dbd:	48 89 e5             	mov    %rsp,%rbp
  802dc0:	41 56                	push   %r14
  802dc2:	41 55                	push   %r13
  802dc4:	41 54                	push   %r12
  802dc6:	53                   	push   %rbx
  802dc7:	48 83 ec 50          	sub    $0x50,%rsp
  802dcb:	49 89 fc             	mov    %rdi,%r12
  802dce:	41 89 f5             	mov    %esi,%r13d
  802dd1:	48 89 d3             	mov    %rdx,%rbx
  802dd4:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802dd8:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802ddc:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802de0:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802de7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802deb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802def:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802df3:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802df7:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  802dfe:	00 00 00 
  802e01:	4c 8b 30             	mov    (%rax),%r14
  802e04:	48 b8 a9 10 80 00 00 	movabs $0x8010a9,%rax
  802e0b:	00 00 00 
  802e0e:	ff d0                	call   *%rax
  802e10:	89 c6                	mov    %eax,%esi
  802e12:	45 89 e8             	mov    %r13d,%r8d
  802e15:	4c 89 e1             	mov    %r12,%rcx
  802e18:	4c 89 f2             	mov    %r14,%rdx
  802e1b:	48 bf 00 47 80 00 00 	movabs $0x804700,%rdi
  802e22:	00 00 00 
  802e25:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2a:	49 bc 2b 02 80 00 00 	movabs $0x80022b,%r12
  802e31:	00 00 00 
  802e34:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802e37:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802e3b:	48 89 df             	mov    %rbx,%rdi
  802e3e:	48 b8 c3 01 80 00 00 	movabs $0x8001c3,%rax
  802e45:	00 00 00 
  802e48:	ff d0                	call   *%rax
    cprintf("\n");
  802e4a:	48 bf 33 42 80 00 00 	movabs $0x804233,%rdi
  802e51:	00 00 00 
  802e54:	b8 00 00 00 00       	mov    $0x0,%eax
  802e59:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802e5c:	cc                   	int3
  802e5d:	eb fd                	jmp    802e5c <_panic+0xa4>

0000000000802e5f <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802e5f:	f3 0f 1e fa          	endbr64
  802e63:	55                   	push   %rbp
  802e64:	48 89 e5             	mov    %rsp,%rbp
  802e67:	41 54                	push   %r12
  802e69:	53                   	push   %rbx
  802e6a:	48 89 fb             	mov    %rdi,%rbx
  802e6d:	48 89 f7             	mov    %rsi,%rdi
  802e70:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802e73:	48 85 f6             	test   %rsi,%rsi
  802e76:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802e7d:	00 00 00 
  802e80:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802e84:	be 00 10 00 00       	mov    $0x1000,%esi
  802e89:	48 b8 9b 14 80 00 00 	movabs $0x80149b,%rax
  802e90:	00 00 00 
  802e93:	ff d0                	call   *%rax
    if (res < 0) {
  802e95:	85 c0                	test   %eax,%eax
  802e97:	78 45                	js     802ede <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802e99:	48 85 db             	test   %rbx,%rbx
  802e9c:	74 12                	je     802eb0 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802e9e:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802ea5:	00 00 00 
  802ea8:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802eae:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802eb0:	4d 85 e4             	test   %r12,%r12
  802eb3:	74 14                	je     802ec9 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802eb5:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802ebc:	00 00 00 
  802ebf:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802ec5:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802ec9:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802ed0:	00 00 00 
  802ed3:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802ed9:	5b                   	pop    %rbx
  802eda:	41 5c                	pop    %r12
  802edc:	5d                   	pop    %rbp
  802edd:	c3                   	ret
        if (from_env_store != NULL) {
  802ede:	48 85 db             	test   %rbx,%rbx
  802ee1:	74 06                	je     802ee9 <ipc_recv+0x8a>
            *from_env_store = 0;
  802ee3:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802ee9:	4d 85 e4             	test   %r12,%r12
  802eec:	74 eb                	je     802ed9 <ipc_recv+0x7a>
            *perm_store = 0;
  802eee:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802ef5:	00 
  802ef6:	eb e1                	jmp    802ed9 <ipc_recv+0x7a>

0000000000802ef8 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802ef8:	f3 0f 1e fa          	endbr64
  802efc:	55                   	push   %rbp
  802efd:	48 89 e5             	mov    %rsp,%rbp
  802f00:	41 57                	push   %r15
  802f02:	41 56                	push   %r14
  802f04:	41 55                	push   %r13
  802f06:	41 54                	push   %r12
  802f08:	53                   	push   %rbx
  802f09:	48 83 ec 18          	sub    $0x18,%rsp
  802f0d:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802f10:	48 89 d3             	mov    %rdx,%rbx
  802f13:	49 89 cc             	mov    %rcx,%r12
  802f16:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802f19:	48 85 d2             	test   %rdx,%rdx
  802f1c:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802f23:	00 00 00 
  802f26:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802f2a:	89 f0                	mov    %esi,%eax
  802f2c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802f30:	48 89 da             	mov    %rbx,%rdx
  802f33:	48 89 c6             	mov    %rax,%rsi
  802f36:	48 b8 6b 14 80 00 00 	movabs $0x80146b,%rax
  802f3d:	00 00 00 
  802f40:	ff d0                	call   *%rax
    while (res < 0) {
  802f42:	85 c0                	test   %eax,%eax
  802f44:	79 65                	jns    802fab <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802f46:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802f49:	75 33                	jne    802f7e <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802f4b:	49 bf de 10 80 00 00 	movabs $0x8010de,%r15
  802f52:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802f55:	49 be 6b 14 80 00 00 	movabs $0x80146b,%r14
  802f5c:	00 00 00 
        sys_yield();
  802f5f:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802f62:	45 89 e8             	mov    %r13d,%r8d
  802f65:	4c 89 e1             	mov    %r12,%rcx
  802f68:	48 89 da             	mov    %rbx,%rdx
  802f6b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802f6f:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802f72:	41 ff d6             	call   *%r14
    while (res < 0) {
  802f75:	85 c0                	test   %eax,%eax
  802f77:	79 32                	jns    802fab <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802f79:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802f7c:	74 e1                	je     802f5f <ipc_send+0x67>
            panic("Error: %i\n", res);
  802f7e:	89 c1                	mov    %eax,%ecx
  802f80:	48 ba 9d 42 80 00 00 	movabs $0x80429d,%rdx
  802f87:	00 00 00 
  802f8a:	be 42 00 00 00       	mov    $0x42,%esi
  802f8f:	48 bf a8 42 80 00 00 	movabs $0x8042a8,%rdi
  802f96:	00 00 00 
  802f99:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9e:	49 b8 b8 2d 80 00 00 	movabs $0x802db8,%r8
  802fa5:	00 00 00 
  802fa8:	41 ff d0             	call   *%r8
    }
}
  802fab:	48 83 c4 18          	add    $0x18,%rsp
  802faf:	5b                   	pop    %rbx
  802fb0:	41 5c                	pop    %r12
  802fb2:	41 5d                	pop    %r13
  802fb4:	41 5e                	pop    %r14
  802fb6:	41 5f                	pop    %r15
  802fb8:	5d                   	pop    %rbp
  802fb9:	c3                   	ret

0000000000802fba <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802fba:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802fbe:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802fc3:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802fca:	00 00 00 
  802fcd:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802fd1:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802fd5:	48 c1 e2 04          	shl    $0x4,%rdx
  802fd9:	48 01 ca             	add    %rcx,%rdx
  802fdc:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802fe2:	39 fa                	cmp    %edi,%edx
  802fe4:	74 12                	je     802ff8 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802fe6:	48 83 c0 01          	add    $0x1,%rax
  802fea:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802ff0:	75 db                	jne    802fcd <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802ff2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ff7:	c3                   	ret
            return envs[i].env_id;
  802ff8:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802ffc:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803000:	48 c1 e2 04          	shl    $0x4,%rdx
  803004:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  80300b:	00 00 00 
  80300e:	48 01 d0             	add    %rdx,%rax
  803011:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803017:	c3                   	ret

0000000000803018 <__text_end>:
  803018:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80301f:	00 00 00 
  803022:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803029:	00 00 00 
  80302c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803033:	00 00 00 
  803036:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80303d:	00 00 00 
  803040:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803047:	00 00 00 
  80304a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803051:	00 00 00 
  803054:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80305b:	00 00 00 
  80305e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803065:	00 00 00 
  803068:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80306f:	00 00 00 
  803072:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803079:	00 00 00 
  80307c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803083:	00 00 00 
  803086:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80308d:	00 00 00 
  803090:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803097:	00 00 00 
  80309a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030a1:	00 00 00 
  8030a4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030ab:	00 00 00 
  8030ae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030b5:	00 00 00 
  8030b8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030bf:	00 00 00 
  8030c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030c9:	00 00 00 
  8030cc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030d3:	00 00 00 
  8030d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030dd:	00 00 00 
  8030e0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030e7:	00 00 00 
  8030ea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030f1:	00 00 00 
  8030f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030fb:	00 00 00 
  8030fe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803105:	00 00 00 
  803108:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80310f:	00 00 00 
  803112:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803119:	00 00 00 
  80311c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803123:	00 00 00 
  803126:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80312d:	00 00 00 
  803130:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803137:	00 00 00 
  80313a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803141:	00 00 00 
  803144:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80314b:	00 00 00 
  80314e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803155:	00 00 00 
  803158:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80315f:	00 00 00 
  803162:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803169:	00 00 00 
  80316c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803173:	00 00 00 
  803176:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80317d:	00 00 00 
  803180:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803187:	00 00 00 
  80318a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803191:	00 00 00 
  803194:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80319b:	00 00 00 
  80319e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031a5:	00 00 00 
  8031a8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031af:	00 00 00 
  8031b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031b9:	00 00 00 
  8031bc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031c3:	00 00 00 
  8031c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031cd:	00 00 00 
  8031d0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031d7:	00 00 00 
  8031da:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031e1:	00 00 00 
  8031e4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031eb:	00 00 00 
  8031ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031f5:	00 00 00 
  8031f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031ff:	00 00 00 
  803202:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803209:	00 00 00 
  80320c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803213:	00 00 00 
  803216:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80321d:	00 00 00 
  803220:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803227:	00 00 00 
  80322a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803231:	00 00 00 
  803234:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80323b:	00 00 00 
  80323e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803245:	00 00 00 
  803248:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80324f:	00 00 00 
  803252:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803259:	00 00 00 
  80325c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803263:	00 00 00 
  803266:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80326d:	00 00 00 
  803270:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803277:	00 00 00 
  80327a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803281:	00 00 00 
  803284:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80328b:	00 00 00 
  80328e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803295:	00 00 00 
  803298:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80329f:	00 00 00 
  8032a2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032a9:	00 00 00 
  8032ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032b3:	00 00 00 
  8032b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032bd:	00 00 00 
  8032c0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032c7:	00 00 00 
  8032ca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032d1:	00 00 00 
  8032d4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032db:	00 00 00 
  8032de:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032e5:	00 00 00 
  8032e8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032ef:	00 00 00 
  8032f2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032f9:	00 00 00 
  8032fc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803303:	00 00 00 
  803306:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80330d:	00 00 00 
  803310:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803317:	00 00 00 
  80331a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803321:	00 00 00 
  803324:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80332b:	00 00 00 
  80332e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803335:	00 00 00 
  803338:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80333f:	00 00 00 
  803342:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803349:	00 00 00 
  80334c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803353:	00 00 00 
  803356:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80335d:	00 00 00 
  803360:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803367:	00 00 00 
  80336a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803371:	00 00 00 
  803374:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80337b:	00 00 00 
  80337e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803385:	00 00 00 
  803388:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80338f:	00 00 00 
  803392:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803399:	00 00 00 
  80339c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033a3:	00 00 00 
  8033a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033ad:	00 00 00 
  8033b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033b7:	00 00 00 
  8033ba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033c1:	00 00 00 
  8033c4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033cb:	00 00 00 
  8033ce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033d5:	00 00 00 
  8033d8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033df:	00 00 00 
  8033e2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033e9:	00 00 00 
  8033ec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033f3:	00 00 00 
  8033f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033fd:	00 00 00 
  803400:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803407:	00 00 00 
  80340a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803411:	00 00 00 
  803414:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80341b:	00 00 00 
  80341e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803425:	00 00 00 
  803428:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80342f:	00 00 00 
  803432:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803439:	00 00 00 
  80343c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803443:	00 00 00 
  803446:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80344d:	00 00 00 
  803450:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803457:	00 00 00 
  80345a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803461:	00 00 00 
  803464:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80346b:	00 00 00 
  80346e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803475:	00 00 00 
  803478:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80347f:	00 00 00 
  803482:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803489:	00 00 00 
  80348c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803493:	00 00 00 
  803496:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80349d:	00 00 00 
  8034a0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034a7:	00 00 00 
  8034aa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034b1:	00 00 00 
  8034b4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034bb:	00 00 00 
  8034be:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034c5:	00 00 00 
  8034c8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034cf:	00 00 00 
  8034d2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034d9:	00 00 00 
  8034dc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034e3:	00 00 00 
  8034e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ed:	00 00 00 
  8034f0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034f7:	00 00 00 
  8034fa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803501:	00 00 00 
  803504:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80350b:	00 00 00 
  80350e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803515:	00 00 00 
  803518:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80351f:	00 00 00 
  803522:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803529:	00 00 00 
  80352c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803533:	00 00 00 
  803536:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80353d:	00 00 00 
  803540:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803547:	00 00 00 
  80354a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803551:	00 00 00 
  803554:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80355b:	00 00 00 
  80355e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803565:	00 00 00 
  803568:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80356f:	00 00 00 
  803572:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803579:	00 00 00 
  80357c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803583:	00 00 00 
  803586:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80358d:	00 00 00 
  803590:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803597:	00 00 00 
  80359a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a1:	00 00 00 
  8035a4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ab:	00 00 00 
  8035ae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b5:	00 00 00 
  8035b8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035bf:	00 00 00 
  8035c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035c9:	00 00 00 
  8035cc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035d3:	00 00 00 
  8035d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035dd:	00 00 00 
  8035e0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035e7:	00 00 00 
  8035ea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035f1:	00 00 00 
  8035f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035fb:	00 00 00 
  8035fe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803605:	00 00 00 
  803608:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80360f:	00 00 00 
  803612:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803619:	00 00 00 
  80361c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803623:	00 00 00 
  803626:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80362d:	00 00 00 
  803630:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803637:	00 00 00 
  80363a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803641:	00 00 00 
  803644:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80364b:	00 00 00 
  80364e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803655:	00 00 00 
  803658:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80365f:	00 00 00 
  803662:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803669:	00 00 00 
  80366c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803673:	00 00 00 
  803676:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80367d:	00 00 00 
  803680:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803687:	00 00 00 
  80368a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803691:	00 00 00 
  803694:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80369b:	00 00 00 
  80369e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036a5:	00 00 00 
  8036a8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036af:	00 00 00 
  8036b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036b9:	00 00 00 
  8036bc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036c3:	00 00 00 
  8036c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036cd:	00 00 00 
  8036d0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036d7:	00 00 00 
  8036da:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036e1:	00 00 00 
  8036e4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036eb:	00 00 00 
  8036ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036f5:	00 00 00 
  8036f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ff:	00 00 00 
  803702:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803709:	00 00 00 
  80370c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803713:	00 00 00 
  803716:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80371d:	00 00 00 
  803720:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803727:	00 00 00 
  80372a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803731:	00 00 00 
  803734:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80373b:	00 00 00 
  80373e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803745:	00 00 00 
  803748:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80374f:	00 00 00 
  803752:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803759:	00 00 00 
  80375c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803763:	00 00 00 
  803766:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80376d:	00 00 00 
  803770:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803777:	00 00 00 
  80377a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803781:	00 00 00 
  803784:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80378b:	00 00 00 
  80378e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803795:	00 00 00 
  803798:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80379f:	00 00 00 
  8037a2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a9:	00 00 00 
  8037ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b3:	00 00 00 
  8037b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037bd:	00 00 00 
  8037c0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c7:	00 00 00 
  8037ca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d1:	00 00 00 
  8037d4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037db:	00 00 00 
  8037de:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e5:	00 00 00 
  8037e8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ef:	00 00 00 
  8037f2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f9:	00 00 00 
  8037fc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803803:	00 00 00 
  803806:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80380d:	00 00 00 
  803810:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803817:	00 00 00 
  80381a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803821:	00 00 00 
  803824:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80382b:	00 00 00 
  80382e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803835:	00 00 00 
  803838:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80383f:	00 00 00 
  803842:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803849:	00 00 00 
  80384c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803853:	00 00 00 
  803856:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80385d:	00 00 00 
  803860:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803867:	00 00 00 
  80386a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803871:	00 00 00 
  803874:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80387b:	00 00 00 
  80387e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803885:	00 00 00 
  803888:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80388f:	00 00 00 
  803892:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803899:	00 00 00 
  80389c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a3:	00 00 00 
  8038a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ad:	00 00 00 
  8038b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b7:	00 00 00 
  8038ba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c1:	00 00 00 
  8038c4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038cb:	00 00 00 
  8038ce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d5:	00 00 00 
  8038d8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038df:	00 00 00 
  8038e2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e9:	00 00 00 
  8038ec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f3:	00 00 00 
  8038f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038fd:	00 00 00 
  803900:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803907:	00 00 00 
  80390a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803911:	00 00 00 
  803914:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80391b:	00 00 00 
  80391e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803925:	00 00 00 
  803928:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80392f:	00 00 00 
  803932:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803939:	00 00 00 
  80393c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803943:	00 00 00 
  803946:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80394d:	00 00 00 
  803950:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803957:	00 00 00 
  80395a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803961:	00 00 00 
  803964:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80396b:	00 00 00 
  80396e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803975:	00 00 00 
  803978:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80397f:	00 00 00 
  803982:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803989:	00 00 00 
  80398c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803993:	00 00 00 
  803996:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80399d:	00 00 00 
  8039a0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a7:	00 00 00 
  8039aa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b1:	00 00 00 
  8039b4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039bb:	00 00 00 
  8039be:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c5:	00 00 00 
  8039c8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039cf:	00 00 00 
  8039d2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d9:	00 00 00 
  8039dc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e3:	00 00 00 
  8039e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ed:	00 00 00 
  8039f0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f7:	00 00 00 
  8039fa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a01:	00 00 00 
  803a04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a0b:	00 00 00 
  803a0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a15:	00 00 00 
  803a18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a1f:	00 00 00 
  803a22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a29:	00 00 00 
  803a2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a33:	00 00 00 
  803a36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a3d:	00 00 00 
  803a40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a47:	00 00 00 
  803a4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a51:	00 00 00 
  803a54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a5b:	00 00 00 
  803a5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a65:	00 00 00 
  803a68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a6f:	00 00 00 
  803a72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a79:	00 00 00 
  803a7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a83:	00 00 00 
  803a86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a8d:	00 00 00 
  803a90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a97:	00 00 00 
  803a9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa1:	00 00 00 
  803aa4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aab:	00 00 00 
  803aae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab5:	00 00 00 
  803ab8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803abf:	00 00 00 
  803ac2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac9:	00 00 00 
  803acc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad3:	00 00 00 
  803ad6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803add:	00 00 00 
  803ae0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae7:	00 00 00 
  803aea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af1:	00 00 00 
  803af4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803afb:	00 00 00 
  803afe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b05:	00 00 00 
  803b08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b0f:	00 00 00 
  803b12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b19:	00 00 00 
  803b1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b23:	00 00 00 
  803b26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b2d:	00 00 00 
  803b30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b37:	00 00 00 
  803b3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b41:	00 00 00 
  803b44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b4b:	00 00 00 
  803b4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b55:	00 00 00 
  803b58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b5f:	00 00 00 
  803b62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b69:	00 00 00 
  803b6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b73:	00 00 00 
  803b76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b7d:	00 00 00 
  803b80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b87:	00 00 00 
  803b8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b91:	00 00 00 
  803b94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b9b:	00 00 00 
  803b9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba5:	00 00 00 
  803ba8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803baf:	00 00 00 
  803bb2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb9:	00 00 00 
  803bbc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc3:	00 00 00 
  803bc6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bcd:	00 00 00 
  803bd0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd7:	00 00 00 
  803bda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be1:	00 00 00 
  803be4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803beb:	00 00 00 
  803bee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf5:	00 00 00 
  803bf8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bff:	00 00 00 
  803c02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c09:	00 00 00 
  803c0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c13:	00 00 00 
  803c16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c1d:	00 00 00 
  803c20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c27:	00 00 00 
  803c2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c31:	00 00 00 
  803c34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c3b:	00 00 00 
  803c3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c45:	00 00 00 
  803c48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c4f:	00 00 00 
  803c52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c59:	00 00 00 
  803c5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c63:	00 00 00 
  803c66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c6d:	00 00 00 
  803c70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c77:	00 00 00 
  803c7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c81:	00 00 00 
  803c84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c8b:	00 00 00 
  803c8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c95:	00 00 00 
  803c98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c9f:	00 00 00 
  803ca2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca9:	00 00 00 
  803cac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb3:	00 00 00 
  803cb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cbd:	00 00 00 
  803cc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc7:	00 00 00 
  803cca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd1:	00 00 00 
  803cd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cdb:	00 00 00 
  803cde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce5:	00 00 00 
  803ce8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cef:	00 00 00 
  803cf2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf9:	00 00 00 
  803cfc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d03:	00 00 00 
  803d06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d0d:	00 00 00 
  803d10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d17:	00 00 00 
  803d1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d21:	00 00 00 
  803d24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d2b:	00 00 00 
  803d2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d35:	00 00 00 
  803d38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d3f:	00 00 00 
  803d42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d49:	00 00 00 
  803d4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d53:	00 00 00 
  803d56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d5d:	00 00 00 
  803d60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d67:	00 00 00 
  803d6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d71:	00 00 00 
  803d74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d7b:	00 00 00 
  803d7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d85:	00 00 00 
  803d88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d8f:	00 00 00 
  803d92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d99:	00 00 00 
  803d9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da3:	00 00 00 
  803da6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dad:	00 00 00 
  803db0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db7:	00 00 00 
  803dba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc1:	00 00 00 
  803dc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dcb:	00 00 00 
  803dce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd5:	00 00 00 
  803dd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ddf:	00 00 00 
  803de2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de9:	00 00 00 
  803dec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df3:	00 00 00 
  803df6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dfd:	00 00 00 
  803e00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e07:	00 00 00 
  803e0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e11:	00 00 00 
  803e14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e1b:	00 00 00 
  803e1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e25:	00 00 00 
  803e28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e2f:	00 00 00 
  803e32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e39:	00 00 00 
  803e3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e43:	00 00 00 
  803e46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e4d:	00 00 00 
  803e50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e57:	00 00 00 
  803e5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e61:	00 00 00 
  803e64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e6b:	00 00 00 
  803e6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e75:	00 00 00 
  803e78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e7f:	00 00 00 
  803e82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e89:	00 00 00 
  803e8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e93:	00 00 00 
  803e96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e9d:	00 00 00 
  803ea0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea7:	00 00 00 
  803eaa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb1:	00 00 00 
  803eb4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ebb:	00 00 00 
  803ebe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec5:	00 00 00 
  803ec8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ecf:	00 00 00 
  803ed2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed9:	00 00 00 
  803edc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee3:	00 00 00 
  803ee6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eed:	00 00 00 
  803ef0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef7:	00 00 00 
  803efa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f01:	00 00 00 
  803f04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f0b:	00 00 00 
  803f0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f15:	00 00 00 
  803f18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f1f:	00 00 00 
  803f22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f29:	00 00 00 
  803f2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f33:	00 00 00 
  803f36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f3d:	00 00 00 
  803f40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f47:	00 00 00 
  803f4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f51:	00 00 00 
  803f54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f5b:	00 00 00 
  803f5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f65:	00 00 00 
  803f68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f6f:	00 00 00 
  803f72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f79:	00 00 00 
  803f7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f83:	00 00 00 
  803f86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f8d:	00 00 00 
  803f90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f97:	00 00 00 
  803f9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa1:	00 00 00 
  803fa4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fab:	00 00 00 
  803fae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb5:	00 00 00 
  803fb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fbf:	00 00 00 
  803fc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc9:	00 00 00 
  803fcc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd3:	00 00 00 
  803fd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fdd:	00 00 00 
  803fe0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe7:	00 00 00 
  803fea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff1:	00 00 00 
  803ff4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ffb:	00 00 00 
  803ffe:	66 90                	xchg   %ax,%ax
