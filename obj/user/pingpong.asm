
obj/user/pingpong:     file format elf64-x86-64


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
  80001e:	e8 17 01 00 00       	call   80013a <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
 * Only need to start one of these -- splits into two with fork. */

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
  800036:	48 83 ec 18          	sub    $0x18,%rsp
    envid_t who;

    if ((who = fork()) != 0) {
  80003a:	48 b8 da 15 80 00 00 	movabs $0x8015da,%rax
  800041:	00 00 00 
  800044:	ff d0                	call   *%rax
  800046:	89 45 cc             	mov    %eax,-0x34(%rbp)
  800049:	85 c0                	test   %eax,%eax
  80004b:	0f 85 93 00 00 00    	jne    8000e4 <umain+0xbf>
        cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
        ipc_send(who, 0, 0, 0, 0);
    }

    while (1) {
        uint32_t i = ipc_recv(&who, 0, 0, 0);
  800051:	49 bf 36 17 80 00 00 	movabs $0x801736,%r15
  800058:	00 00 00 
        cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005b:	49 be 46 11 80 00 00 	movabs $0x801146,%r14
  800062:	00 00 00 
  800065:	49 bd c8 02 80 00 00 	movabs $0x8002c8,%r13
  80006c:	00 00 00 
        uint32_t i = ipc_recv(&who, 0, 0, 0);
  80006f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800074:	ba 00 00 00 00       	mov    $0x0,%edx
  800079:	be 00 00 00 00       	mov    $0x0,%esi
  80007e:	48 8d 7d cc          	lea    -0x34(%rbp),%rdi
  800082:	41 ff d7             	call   *%r15
  800085:	89 c3                	mov    %eax,%ebx
        cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  800087:	44 8b 65 cc          	mov    -0x34(%rbp),%r12d
  80008b:	41 ff d6             	call   *%r14
  80008e:	89 c6                	mov    %eax,%esi
  800090:	44 89 e1             	mov    %r12d,%ecx
  800093:	89 da                	mov    %ebx,%edx
  800095:	48 bf 16 40 80 00 00 	movabs $0x804016,%rdi
  80009c:	00 00 00 
  80009f:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a4:	41 ff d5             	call   *%r13
        if (i == 10) return;
  8000a7:	83 fb 0a             	cmp    $0xa,%ebx
  8000aa:	74 29                	je     8000d5 <umain+0xb0>
        i++;
  8000ac:	83 c3 01             	add    $0x1,%ebx
        ipc_send(who, i, 0, 0, 0);
  8000af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8000b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8000bf:	89 de                	mov    %ebx,%esi
  8000c1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8000c4:	48 b8 cf 17 80 00 00 	movabs $0x8017cf,%rax
  8000cb:	00 00 00 
  8000ce:	ff d0                	call   *%rax
        if (i == 10) return;
  8000d0:	83 fb 0a             	cmp    $0xa,%ebx
  8000d3:	75 9a                	jne    80006f <umain+0x4a>
    }
}
  8000d5:	48 83 c4 18          	add    $0x18,%rsp
  8000d9:	5b                   	pop    %rbx
  8000da:	41 5c                	pop    %r12
  8000dc:	41 5d                	pop    %r13
  8000de:	41 5e                	pop    %r14
  8000e0:	41 5f                	pop    %r15
  8000e2:	5d                   	pop    %rbp
  8000e3:	c3                   	ret
  8000e4:	89 c3                	mov    %eax,%ebx
        cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000e6:	48 b8 46 11 80 00 00 	movabs $0x801146,%rax
  8000ed:	00 00 00 
  8000f0:	ff d0                	call   *%rax
  8000f2:	89 c6                	mov    %eax,%esi
  8000f4:	89 da                	mov    %ebx,%edx
  8000f6:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  8000fd:	00 00 00 
  800100:	b8 00 00 00 00       	mov    $0x0,%eax
  800105:	48 b9 c8 02 80 00 00 	movabs $0x8002c8,%rcx
  80010c:	00 00 00 
  80010f:	ff d1                	call   *%rcx
        ipc_send(who, 0, 0, 0, 0);
  800111:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800117:	b9 00 00 00 00       	mov    $0x0,%ecx
  80011c:	ba 00 00 00 00       	mov    $0x0,%edx
  800121:	be 00 00 00 00       	mov    $0x0,%esi
  800126:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800129:	48 b8 cf 17 80 00 00 	movabs $0x8017cf,%rax
  800130:	00 00 00 
  800133:	ff d0                	call   *%rax
  800135:	e9 17 ff ff ff       	jmp    800051 <umain+0x2c>

000000000080013a <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80013a:	f3 0f 1e fa          	endbr64
  80013e:	55                   	push   %rbp
  80013f:	48 89 e5             	mov    %rsp,%rbp
  800142:	41 56                	push   %r14
  800144:	41 55                	push   %r13
  800146:	41 54                	push   %r12
  800148:	53                   	push   %rbx
  800149:	41 89 fd             	mov    %edi,%r13d
  80014c:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80014f:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  800156:	00 00 00 
  800159:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  800160:	00 00 00 
  800163:	48 39 c2             	cmp    %rax,%rdx
  800166:	73 17                	jae    80017f <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800168:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80016b:	49 89 c4             	mov    %rax,%r12
  80016e:	48 83 c3 08          	add    $0x8,%rbx
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	ff 53 f8             	call   *-0x8(%rbx)
  80017a:	4c 39 e3             	cmp    %r12,%rbx
  80017d:	72 ef                	jb     80016e <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  80017f:	48 b8 46 11 80 00 00 	movabs $0x801146,%rax
  800186:	00 00 00 
  800189:	ff d0                	call   *%rax
  80018b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800190:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800194:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800198:	48 c1 e0 04          	shl    $0x4,%rax
  80019c:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8001a3:	00 00 00 
  8001a6:	48 01 d0             	add    %rdx,%rax
  8001a9:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8001b0:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8001b3:	45 85 ed             	test   %r13d,%r13d
  8001b6:	7e 0d                	jle    8001c5 <libmain+0x8b>
  8001b8:	49 8b 06             	mov    (%r14),%rax
  8001bb:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8001c2:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8001c5:	4c 89 f6             	mov    %r14,%rsi
  8001c8:	44 89 ef             	mov    %r13d,%edi
  8001cb:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8001d2:	00 00 00 
  8001d5:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8001d7:	48 b8 ec 01 80 00 00 	movabs $0x8001ec,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	call   *%rax
#endif
}
  8001e3:	5b                   	pop    %rbx
  8001e4:	41 5c                	pop    %r12
  8001e6:	41 5d                	pop    %r13
  8001e8:	41 5e                	pop    %r14
  8001ea:	5d                   	pop    %rbp
  8001eb:	c3                   	ret

00000000008001ec <exit>:

#include <inc/lib.h>

void
exit(void) {
  8001ec:	f3 0f 1e fa          	endbr64
  8001f0:	55                   	push   %rbp
  8001f1:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8001f4:	48 b8 31 1b 80 00 00 	movabs $0x801b31,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800200:	bf 00 00 00 00       	mov    $0x0,%edi
  800205:	48 b8 d7 10 80 00 00 	movabs $0x8010d7,%rax
  80020c:	00 00 00 
  80020f:	ff d0                	call   *%rax
}
  800211:	5d                   	pop    %rbp
  800212:	c3                   	ret

0000000000800213 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800213:	f3 0f 1e fa          	endbr64
  800217:	55                   	push   %rbp
  800218:	48 89 e5             	mov    %rsp,%rbp
  80021b:	53                   	push   %rbx
  80021c:	48 83 ec 08          	sub    $0x8,%rsp
  800220:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800223:	8b 06                	mov    (%rsi),%eax
  800225:	8d 50 01             	lea    0x1(%rax),%edx
  800228:	89 16                	mov    %edx,(%rsi)
  80022a:	48 98                	cltq
  80022c:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800231:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800237:	74 0a                	je     800243 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800239:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80023d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800241:	c9                   	leave
  800242:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800243:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800247:	be ff 00 00 00       	mov    $0xff,%esi
  80024c:	48 b8 71 10 80 00 00 	movabs $0x801071,%rax
  800253:	00 00 00 
  800256:	ff d0                	call   *%rax
        state->offset = 0;
  800258:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80025e:	eb d9                	jmp    800239 <putch+0x26>

0000000000800260 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800260:	f3 0f 1e fa          	endbr64
  800264:	55                   	push   %rbp
  800265:	48 89 e5             	mov    %rsp,%rbp
  800268:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80026f:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800272:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800279:	b9 21 00 00 00       	mov    $0x21,%ecx
  80027e:	b8 00 00 00 00       	mov    $0x0,%eax
  800283:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800286:	48 89 f1             	mov    %rsi,%rcx
  800289:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800290:	48 bf 13 02 80 00 00 	movabs $0x800213,%rdi
  800297:	00 00 00 
  80029a:	48 b8 28 04 80 00 00 	movabs $0x800428,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8002a6:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8002ad:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8002b4:	48 b8 71 10 80 00 00 	movabs $0x801071,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	call   *%rax

    return state.count;
}
  8002c0:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8002c6:	c9                   	leave
  8002c7:	c3                   	ret

00000000008002c8 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8002c8:	f3 0f 1e fa          	endbr64
  8002cc:	55                   	push   %rbp
  8002cd:	48 89 e5             	mov    %rsp,%rbp
  8002d0:	48 83 ec 50          	sub    $0x50,%rsp
  8002d4:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8002d8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8002dc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8002e0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8002e4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8002e8:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8002ef:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002f3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002f7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002fb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8002ff:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800303:	48 b8 60 02 80 00 00 	movabs $0x800260,%rax
  80030a:	00 00 00 
  80030d:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80030f:	c9                   	leave
  800310:	c3                   	ret

0000000000800311 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800311:	f3 0f 1e fa          	endbr64
  800315:	55                   	push   %rbp
  800316:	48 89 e5             	mov    %rsp,%rbp
  800319:	41 57                	push   %r15
  80031b:	41 56                	push   %r14
  80031d:	41 55                	push   %r13
  80031f:	41 54                	push   %r12
  800321:	53                   	push   %rbx
  800322:	48 83 ec 18          	sub    $0x18,%rsp
  800326:	49 89 fc             	mov    %rdi,%r12
  800329:	49 89 f5             	mov    %rsi,%r13
  80032c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800330:	8b 45 10             	mov    0x10(%rbp),%eax
  800333:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800336:	41 89 cf             	mov    %ecx,%r15d
  800339:	4c 39 fa             	cmp    %r15,%rdx
  80033c:	73 5b                	jae    800399 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80033e:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800342:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800346:	85 db                	test   %ebx,%ebx
  800348:	7e 0e                	jle    800358 <print_num+0x47>
            putch(padc, put_arg);
  80034a:	4c 89 ee             	mov    %r13,%rsi
  80034d:	44 89 f7             	mov    %r14d,%edi
  800350:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800353:	83 eb 01             	sub    $0x1,%ebx
  800356:	75 f2                	jne    80034a <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800358:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80035c:	48 b9 44 40 80 00 00 	movabs $0x804044,%rcx
  800363:	00 00 00 
  800366:	48 b8 33 40 80 00 00 	movabs $0x804033,%rax
  80036d:	00 00 00 
  800370:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800374:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800378:	ba 00 00 00 00       	mov    $0x0,%edx
  80037d:	49 f7 f7             	div    %r15
  800380:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800384:	4c 89 ee             	mov    %r13,%rsi
  800387:	41 ff d4             	call   *%r12
}
  80038a:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80038e:	5b                   	pop    %rbx
  80038f:	41 5c                	pop    %r12
  800391:	41 5d                	pop    %r13
  800393:	41 5e                	pop    %r14
  800395:	41 5f                	pop    %r15
  800397:	5d                   	pop    %rbp
  800398:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800399:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80039d:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a2:	49 f7 f7             	div    %r15
  8003a5:	48 83 ec 08          	sub    $0x8,%rsp
  8003a9:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8003ad:	52                   	push   %rdx
  8003ae:	45 0f be c9          	movsbl %r9b,%r9d
  8003b2:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8003b6:	48 89 c2             	mov    %rax,%rdx
  8003b9:	48 b8 11 03 80 00 00 	movabs $0x800311,%rax
  8003c0:	00 00 00 
  8003c3:	ff d0                	call   *%rax
  8003c5:	48 83 c4 10          	add    $0x10,%rsp
  8003c9:	eb 8d                	jmp    800358 <print_num+0x47>

00000000008003cb <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8003cb:	f3 0f 1e fa          	endbr64
    state->count++;
  8003cf:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8003d3:	48 8b 06             	mov    (%rsi),%rax
  8003d6:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8003da:	73 0a                	jae    8003e6 <sprintputch+0x1b>
        *state->start++ = ch;
  8003dc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8003e0:	48 89 16             	mov    %rdx,(%rsi)
  8003e3:	40 88 38             	mov    %dil,(%rax)
    }
}
  8003e6:	c3                   	ret

00000000008003e7 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8003e7:	f3 0f 1e fa          	endbr64
  8003eb:	55                   	push   %rbp
  8003ec:	48 89 e5             	mov    %rsp,%rbp
  8003ef:	48 83 ec 50          	sub    $0x50,%rsp
  8003f3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003f7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8003fb:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8003ff:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800406:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80040a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80040e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800412:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800416:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80041a:	48 b8 28 04 80 00 00 	movabs $0x800428,%rax
  800421:	00 00 00 
  800424:	ff d0                	call   *%rax
}
  800426:	c9                   	leave
  800427:	c3                   	ret

0000000000800428 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800428:	f3 0f 1e fa          	endbr64
  80042c:	55                   	push   %rbp
  80042d:	48 89 e5             	mov    %rsp,%rbp
  800430:	41 57                	push   %r15
  800432:	41 56                	push   %r14
  800434:	41 55                	push   %r13
  800436:	41 54                	push   %r12
  800438:	53                   	push   %rbx
  800439:	48 83 ec 38          	sub    $0x38,%rsp
  80043d:	49 89 fe             	mov    %rdi,%r14
  800440:	49 89 f5             	mov    %rsi,%r13
  800443:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800446:	48 8b 01             	mov    (%rcx),%rax
  800449:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80044d:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800451:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800455:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800459:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80045d:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800461:	0f b6 3b             	movzbl (%rbx),%edi
  800464:	40 80 ff 25          	cmp    $0x25,%dil
  800468:	74 18                	je     800482 <vprintfmt+0x5a>
            if (!ch) return;
  80046a:	40 84 ff             	test   %dil,%dil
  80046d:	0f 84 b2 06 00 00    	je     800b25 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800473:	40 0f b6 ff          	movzbl %dil,%edi
  800477:	4c 89 ee             	mov    %r13,%rsi
  80047a:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  80047d:	4c 89 e3             	mov    %r12,%rbx
  800480:	eb db                	jmp    80045d <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800482:	be 00 00 00 00       	mov    $0x0,%esi
  800487:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  80048b:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800490:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800496:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80049d:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8004a1:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8004a6:	41 0f b6 04 24       	movzbl (%r12),%eax
  8004ab:	88 45 a0             	mov    %al,-0x60(%rbp)
  8004ae:	83 e8 23             	sub    $0x23,%eax
  8004b1:	3c 57                	cmp    $0x57,%al
  8004b3:	0f 87 52 06 00 00    	ja     800b0b <vprintfmt+0x6e3>
  8004b9:	0f b6 c0             	movzbl %al,%eax
  8004bc:	48 b9 00 43 80 00 00 	movabs $0x804300,%rcx
  8004c3:	00 00 00 
  8004c6:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8004ca:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8004cd:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8004d1:	eb ce                	jmp    8004a1 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8004d3:	49 89 dc             	mov    %rbx,%r12
  8004d6:	be 01 00 00 00       	mov    $0x1,%esi
  8004db:	eb c4                	jmp    8004a1 <vprintfmt+0x79>
            padc = ch;
  8004dd:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8004e1:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8004e4:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8004e7:	eb b8                	jmp    8004a1 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8004e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004ec:	83 f8 2f             	cmp    $0x2f,%eax
  8004ef:	77 24                	ja     800515 <vprintfmt+0xed>
  8004f1:	89 c1                	mov    %eax,%ecx
  8004f3:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8004f7:	83 c0 08             	add    $0x8,%eax
  8004fa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004fd:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800500:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800503:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800507:	79 98                	jns    8004a1 <vprintfmt+0x79>
                width = precision;
  800509:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  80050d:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800513:	eb 8c                	jmp    8004a1 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800515:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800519:	48 8d 41 08          	lea    0x8(%rcx),%rax
  80051d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800521:	eb da                	jmp    8004fd <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800523:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800528:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80052c:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800532:	3c 39                	cmp    $0x39,%al
  800534:	77 1c                	ja     800552 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800536:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  80053a:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80053e:	0f b6 c0             	movzbl %al,%eax
  800541:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800546:	0f b6 03             	movzbl (%rbx),%eax
  800549:	3c 39                	cmp    $0x39,%al
  80054b:	76 e9                	jbe    800536 <vprintfmt+0x10e>
        process_precision:
  80054d:	49 89 dc             	mov    %rbx,%r12
  800550:	eb b1                	jmp    800503 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800552:	49 89 dc             	mov    %rbx,%r12
  800555:	eb ac                	jmp    800503 <vprintfmt+0xdb>
            width = MAX(0, width);
  800557:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  80055a:	85 c9                	test   %ecx,%ecx
  80055c:	b8 00 00 00 00       	mov    $0x0,%eax
  800561:	0f 49 c1             	cmovns %ecx,%eax
  800564:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800567:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80056a:	e9 32 ff ff ff       	jmp    8004a1 <vprintfmt+0x79>
            lflag++;
  80056f:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800572:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800575:	e9 27 ff ff ff       	jmp    8004a1 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  80057a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80057d:	83 f8 2f             	cmp    $0x2f,%eax
  800580:	77 19                	ja     80059b <vprintfmt+0x173>
  800582:	89 c2                	mov    %eax,%edx
  800584:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800588:	83 c0 08             	add    $0x8,%eax
  80058b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80058e:	8b 3a                	mov    (%rdx),%edi
  800590:	4c 89 ee             	mov    %r13,%rsi
  800593:	41 ff d6             	call   *%r14
            break;
  800596:	e9 c2 fe ff ff       	jmp    80045d <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  80059b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80059f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005a3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005a7:	eb e5                	jmp    80058e <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8005a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005ac:	83 f8 2f             	cmp    $0x2f,%eax
  8005af:	77 5a                	ja     80060b <vprintfmt+0x1e3>
  8005b1:	89 c2                	mov    %eax,%edx
  8005b3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8005b7:	83 c0 08             	add    $0x8,%eax
  8005ba:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8005bd:	8b 02                	mov    (%rdx),%eax
  8005bf:	89 c1                	mov    %eax,%ecx
  8005c1:	f7 d9                	neg    %ecx
  8005c3:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8005c6:	83 f9 13             	cmp    $0x13,%ecx
  8005c9:	7f 4e                	jg     800619 <vprintfmt+0x1f1>
  8005cb:	48 63 c1             	movslq %ecx,%rax
  8005ce:	48 ba c0 45 80 00 00 	movabs $0x8045c0,%rdx
  8005d5:	00 00 00 
  8005d8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8005dc:	48 85 c0             	test   %rax,%rax
  8005df:	74 38                	je     800619 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8005e1:	48 89 c1             	mov    %rax,%rcx
  8005e4:	48 ba 73 42 80 00 00 	movabs $0x804273,%rdx
  8005eb:	00 00 00 
  8005ee:	4c 89 ee             	mov    %r13,%rsi
  8005f1:	4c 89 f7             	mov    %r14,%rdi
  8005f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f9:	49 b8 e7 03 80 00 00 	movabs $0x8003e7,%r8
  800600:	00 00 00 
  800603:	41 ff d0             	call   *%r8
  800606:	e9 52 fe ff ff       	jmp    80045d <vprintfmt+0x35>
            int err = va_arg(aq, int);
  80060b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80060f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800613:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800617:	eb a4                	jmp    8005bd <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800619:	48 ba 5c 40 80 00 00 	movabs $0x80405c,%rdx
  800620:	00 00 00 
  800623:	4c 89 ee             	mov    %r13,%rsi
  800626:	4c 89 f7             	mov    %r14,%rdi
  800629:	b8 00 00 00 00       	mov    $0x0,%eax
  80062e:	49 b8 e7 03 80 00 00 	movabs $0x8003e7,%r8
  800635:	00 00 00 
  800638:	41 ff d0             	call   *%r8
  80063b:	e9 1d fe ff ff       	jmp    80045d <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800640:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800643:	83 f8 2f             	cmp    $0x2f,%eax
  800646:	77 6c                	ja     8006b4 <vprintfmt+0x28c>
  800648:	89 c2                	mov    %eax,%edx
  80064a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80064e:	83 c0 08             	add    $0x8,%eax
  800651:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800654:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800657:	48 85 d2             	test   %rdx,%rdx
  80065a:	48 b8 55 40 80 00 00 	movabs $0x804055,%rax
  800661:	00 00 00 
  800664:	48 0f 45 c2          	cmovne %rdx,%rax
  800668:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  80066c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800670:	7e 06                	jle    800678 <vprintfmt+0x250>
  800672:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800676:	75 4a                	jne    8006c2 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800678:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80067c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800680:	0f b6 00             	movzbl (%rax),%eax
  800683:	84 c0                	test   %al,%al
  800685:	0f 85 9a 00 00 00    	jne    800725 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  80068b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80068e:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  800692:	85 c0                	test   %eax,%eax
  800694:	0f 8e c3 fd ff ff    	jle    80045d <vprintfmt+0x35>
  80069a:	4c 89 ee             	mov    %r13,%rsi
  80069d:	bf 20 00 00 00       	mov    $0x20,%edi
  8006a2:	41 ff d6             	call   *%r14
  8006a5:	41 83 ec 01          	sub    $0x1,%r12d
  8006a9:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8006ad:	75 eb                	jne    80069a <vprintfmt+0x272>
  8006af:	e9 a9 fd ff ff       	jmp    80045d <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8006b4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006b8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006c0:	eb 92                	jmp    800654 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8006c2:	49 63 f7             	movslq %r15d,%rsi
  8006c5:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8006c9:	48 b8 eb 0b 80 00 00 	movabs $0x800beb,%rax
  8006d0:	00 00 00 
  8006d3:	ff d0                	call   *%rax
  8006d5:	48 89 c2             	mov    %rax,%rdx
  8006d8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006db:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8006dd:	8d 70 ff             	lea    -0x1(%rax),%esi
  8006e0:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	7e 91                	jle    800678 <vprintfmt+0x250>
  8006e7:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  8006ec:	4c 89 ee             	mov    %r13,%rsi
  8006ef:	44 89 e7             	mov    %r12d,%edi
  8006f2:	41 ff d6             	call   *%r14
  8006f5:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8006f9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006fc:	83 f8 ff             	cmp    $0xffffffff,%eax
  8006ff:	75 eb                	jne    8006ec <vprintfmt+0x2c4>
  800701:	e9 72 ff ff ff       	jmp    800678 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800706:	0f b6 f8             	movzbl %al,%edi
  800709:	4c 89 ee             	mov    %r13,%rsi
  80070c:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80070f:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800713:	49 83 c4 01          	add    $0x1,%r12
  800717:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  80071d:	84 c0                	test   %al,%al
  80071f:	0f 84 66 ff ff ff    	je     80068b <vprintfmt+0x263>
  800725:	45 85 ff             	test   %r15d,%r15d
  800728:	78 0a                	js     800734 <vprintfmt+0x30c>
  80072a:	41 83 ef 01          	sub    $0x1,%r15d
  80072e:	0f 88 57 ff ff ff    	js     80068b <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800734:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800738:	74 cc                	je     800706 <vprintfmt+0x2de>
  80073a:	8d 50 e0             	lea    -0x20(%rax),%edx
  80073d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800742:	80 fa 5e             	cmp    $0x5e,%dl
  800745:	77 c2                	ja     800709 <vprintfmt+0x2e1>
  800747:	eb bd                	jmp    800706 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800749:	40 84 f6             	test   %sil,%sil
  80074c:	75 26                	jne    800774 <vprintfmt+0x34c>
    switch (lflag) {
  80074e:	85 d2                	test   %edx,%edx
  800750:	74 59                	je     8007ab <vprintfmt+0x383>
  800752:	83 fa 01             	cmp    $0x1,%edx
  800755:	74 7b                	je     8007d2 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800757:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80075a:	83 f8 2f             	cmp    $0x2f,%eax
  80075d:	0f 87 96 00 00 00    	ja     8007f9 <vprintfmt+0x3d1>
  800763:	89 c2                	mov    %eax,%edx
  800765:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800769:	83 c0 08             	add    $0x8,%eax
  80076c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80076f:	4c 8b 22             	mov    (%rdx),%r12
  800772:	eb 17                	jmp    80078b <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800774:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800777:	83 f8 2f             	cmp    $0x2f,%eax
  80077a:	77 21                	ja     80079d <vprintfmt+0x375>
  80077c:	89 c2                	mov    %eax,%edx
  80077e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800782:	83 c0 08             	add    $0x8,%eax
  800785:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800788:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  80078b:	4d 85 e4             	test   %r12,%r12
  80078e:	78 7a                	js     80080a <vprintfmt+0x3e2>
            num = i;
  800790:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800793:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800798:	e9 50 02 00 00       	jmp    8009ed <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80079d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007a1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007a5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007a9:	eb dd                	jmp    800788 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8007ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ae:	83 f8 2f             	cmp    $0x2f,%eax
  8007b1:	77 11                	ja     8007c4 <vprintfmt+0x39c>
  8007b3:	89 c2                	mov    %eax,%edx
  8007b5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007b9:	83 c0 08             	add    $0x8,%eax
  8007bc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007bf:	4c 63 22             	movslq (%rdx),%r12
  8007c2:	eb c7                	jmp    80078b <vprintfmt+0x363>
  8007c4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007c8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007cc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007d0:	eb ed                	jmp    8007bf <vprintfmt+0x397>
        return va_arg(*ap, long);
  8007d2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d5:	83 f8 2f             	cmp    $0x2f,%eax
  8007d8:	77 11                	ja     8007eb <vprintfmt+0x3c3>
  8007da:	89 c2                	mov    %eax,%edx
  8007dc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007e0:	83 c0 08             	add    $0x8,%eax
  8007e3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007e6:	4c 8b 22             	mov    (%rdx),%r12
  8007e9:	eb a0                	jmp    80078b <vprintfmt+0x363>
  8007eb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007ef:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007f3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007f7:	eb ed                	jmp    8007e6 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  8007f9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007fd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800801:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800805:	e9 65 ff ff ff       	jmp    80076f <vprintfmt+0x347>
                putch('-', put_arg);
  80080a:	4c 89 ee             	mov    %r13,%rsi
  80080d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800812:	41 ff d6             	call   *%r14
                i = -i;
  800815:	49 f7 dc             	neg    %r12
  800818:	e9 73 ff ff ff       	jmp    800790 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  80081d:	40 84 f6             	test   %sil,%sil
  800820:	75 32                	jne    800854 <vprintfmt+0x42c>
    switch (lflag) {
  800822:	85 d2                	test   %edx,%edx
  800824:	74 5d                	je     800883 <vprintfmt+0x45b>
  800826:	83 fa 01             	cmp    $0x1,%edx
  800829:	0f 84 82 00 00 00    	je     8008b1 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  80082f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800832:	83 f8 2f             	cmp    $0x2f,%eax
  800835:	0f 87 a5 00 00 00    	ja     8008e0 <vprintfmt+0x4b8>
  80083b:	89 c2                	mov    %eax,%edx
  80083d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800841:	83 c0 08             	add    $0x8,%eax
  800844:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800847:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80084a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80084f:	e9 99 01 00 00       	jmp    8009ed <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800854:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800857:	83 f8 2f             	cmp    $0x2f,%eax
  80085a:	77 19                	ja     800875 <vprintfmt+0x44d>
  80085c:	89 c2                	mov    %eax,%edx
  80085e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800862:	83 c0 08             	add    $0x8,%eax
  800865:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800868:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80086b:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800870:	e9 78 01 00 00       	jmp    8009ed <vprintfmt+0x5c5>
  800875:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800879:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80087d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800881:	eb e5                	jmp    800868 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800883:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800886:	83 f8 2f             	cmp    $0x2f,%eax
  800889:	77 18                	ja     8008a3 <vprintfmt+0x47b>
  80088b:	89 c2                	mov    %eax,%edx
  80088d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800891:	83 c0 08             	add    $0x8,%eax
  800894:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800897:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800899:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  80089e:	e9 4a 01 00 00       	jmp    8009ed <vprintfmt+0x5c5>
  8008a3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008a7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008ab:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008af:	eb e6                	jmp    800897 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8008b1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b4:	83 f8 2f             	cmp    $0x2f,%eax
  8008b7:	77 19                	ja     8008d2 <vprintfmt+0x4aa>
  8008b9:	89 c2                	mov    %eax,%edx
  8008bb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008bf:	83 c0 08             	add    $0x8,%eax
  8008c2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008c5:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8008c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8008cd:	e9 1b 01 00 00       	jmp    8009ed <vprintfmt+0x5c5>
  8008d2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008d6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008da:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008de:	eb e5                	jmp    8008c5 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  8008e0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008e4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008e8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ec:	e9 56 ff ff ff       	jmp    800847 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  8008f1:	40 84 f6             	test   %sil,%sil
  8008f4:	75 2e                	jne    800924 <vprintfmt+0x4fc>
    switch (lflag) {
  8008f6:	85 d2                	test   %edx,%edx
  8008f8:	74 59                	je     800953 <vprintfmt+0x52b>
  8008fa:	83 fa 01             	cmp    $0x1,%edx
  8008fd:	74 7f                	je     80097e <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  8008ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800902:	83 f8 2f             	cmp    $0x2f,%eax
  800905:	0f 87 9f 00 00 00    	ja     8009aa <vprintfmt+0x582>
  80090b:	89 c2                	mov    %eax,%edx
  80090d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800911:	83 c0 08             	add    $0x8,%eax
  800914:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800917:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80091a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80091f:	e9 c9 00 00 00       	jmp    8009ed <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800924:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800927:	83 f8 2f             	cmp    $0x2f,%eax
  80092a:	77 19                	ja     800945 <vprintfmt+0x51d>
  80092c:	89 c2                	mov    %eax,%edx
  80092e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800932:	83 c0 08             	add    $0x8,%eax
  800935:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800938:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80093b:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800940:	e9 a8 00 00 00       	jmp    8009ed <vprintfmt+0x5c5>
  800945:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800949:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80094d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800951:	eb e5                	jmp    800938 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800953:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800956:	83 f8 2f             	cmp    $0x2f,%eax
  800959:	77 15                	ja     800970 <vprintfmt+0x548>
  80095b:	89 c2                	mov    %eax,%edx
  80095d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800961:	83 c0 08             	add    $0x8,%eax
  800964:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800967:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800969:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80096e:	eb 7d                	jmp    8009ed <vprintfmt+0x5c5>
  800970:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800974:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800978:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80097c:	eb e9                	jmp    800967 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  80097e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800981:	83 f8 2f             	cmp    $0x2f,%eax
  800984:	77 16                	ja     80099c <vprintfmt+0x574>
  800986:	89 c2                	mov    %eax,%edx
  800988:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80098c:	83 c0 08             	add    $0x8,%eax
  80098f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800992:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800995:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  80099a:	eb 51                	jmp    8009ed <vprintfmt+0x5c5>
  80099c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009a0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009a8:	eb e8                	jmp    800992 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8009aa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ae:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009b2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009b6:	e9 5c ff ff ff       	jmp    800917 <vprintfmt+0x4ef>
            putch('0', put_arg);
  8009bb:	4c 89 ee             	mov    %r13,%rsi
  8009be:	bf 30 00 00 00       	mov    $0x30,%edi
  8009c3:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  8009c6:	4c 89 ee             	mov    %r13,%rsi
  8009c9:	bf 78 00 00 00       	mov    $0x78,%edi
  8009ce:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  8009d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d4:	83 f8 2f             	cmp    $0x2f,%eax
  8009d7:	77 47                	ja     800a20 <vprintfmt+0x5f8>
  8009d9:	89 c2                	mov    %eax,%edx
  8009db:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009df:	83 c0 08             	add    $0x8,%eax
  8009e2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009e5:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009e8:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8009ed:	48 83 ec 08          	sub    $0x8,%rsp
  8009f1:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  8009f5:	0f 94 c0             	sete   %al
  8009f8:	0f b6 c0             	movzbl %al,%eax
  8009fb:	50                   	push   %rax
  8009fc:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800a01:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800a05:	4c 89 ee             	mov    %r13,%rsi
  800a08:	4c 89 f7             	mov    %r14,%rdi
  800a0b:	48 b8 11 03 80 00 00 	movabs $0x800311,%rax
  800a12:	00 00 00 
  800a15:	ff d0                	call   *%rax
            break;
  800a17:	48 83 c4 10          	add    $0x10,%rsp
  800a1b:	e9 3d fa ff ff       	jmp    80045d <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800a20:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a24:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a28:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a2c:	eb b7                	jmp    8009e5 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800a2e:	40 84 f6             	test   %sil,%sil
  800a31:	75 2b                	jne    800a5e <vprintfmt+0x636>
    switch (lflag) {
  800a33:	85 d2                	test   %edx,%edx
  800a35:	74 56                	je     800a8d <vprintfmt+0x665>
  800a37:	83 fa 01             	cmp    $0x1,%edx
  800a3a:	74 7f                	je     800abb <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800a3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3f:	83 f8 2f             	cmp    $0x2f,%eax
  800a42:	0f 87 a2 00 00 00    	ja     800aea <vprintfmt+0x6c2>
  800a48:	89 c2                	mov    %eax,%edx
  800a4a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a4e:	83 c0 08             	add    $0x8,%eax
  800a51:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a54:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a57:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800a5c:	eb 8f                	jmp    8009ed <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a61:	83 f8 2f             	cmp    $0x2f,%eax
  800a64:	77 19                	ja     800a7f <vprintfmt+0x657>
  800a66:	89 c2                	mov    %eax,%edx
  800a68:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a6c:	83 c0 08             	add    $0x8,%eax
  800a6f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a72:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a75:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a7a:	e9 6e ff ff ff       	jmp    8009ed <vprintfmt+0x5c5>
  800a7f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a83:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a87:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a8b:	eb e5                	jmp    800a72 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800a8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a90:	83 f8 2f             	cmp    $0x2f,%eax
  800a93:	77 18                	ja     800aad <vprintfmt+0x685>
  800a95:	89 c2                	mov    %eax,%edx
  800a97:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a9b:	83 c0 08             	add    $0x8,%eax
  800a9e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aa1:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800aa3:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800aa8:	e9 40 ff ff ff       	jmp    8009ed <vprintfmt+0x5c5>
  800aad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ab1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ab5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ab9:	eb e6                	jmp    800aa1 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800abb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800abe:	83 f8 2f             	cmp    $0x2f,%eax
  800ac1:	77 19                	ja     800adc <vprintfmt+0x6b4>
  800ac3:	89 c2                	mov    %eax,%edx
  800ac5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ac9:	83 c0 08             	add    $0x8,%eax
  800acc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800acf:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800ad2:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800ad7:	e9 11 ff ff ff       	jmp    8009ed <vprintfmt+0x5c5>
  800adc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ae4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ae8:	eb e5                	jmp    800acf <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800aea:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aee:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800af2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800af6:	e9 59 ff ff ff       	jmp    800a54 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800afb:	4c 89 ee             	mov    %r13,%rsi
  800afe:	bf 25 00 00 00       	mov    $0x25,%edi
  800b03:	41 ff d6             	call   *%r14
            break;
  800b06:	e9 52 f9 ff ff       	jmp    80045d <vprintfmt+0x35>
            putch('%', put_arg);
  800b0b:	4c 89 ee             	mov    %r13,%rsi
  800b0e:	bf 25 00 00 00       	mov    $0x25,%edi
  800b13:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800b16:	48 83 eb 01          	sub    $0x1,%rbx
  800b1a:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800b1e:	75 f6                	jne    800b16 <vprintfmt+0x6ee>
  800b20:	e9 38 f9 ff ff       	jmp    80045d <vprintfmt+0x35>
}
  800b25:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800b29:	5b                   	pop    %rbx
  800b2a:	41 5c                	pop    %r12
  800b2c:	41 5d                	pop    %r13
  800b2e:	41 5e                	pop    %r14
  800b30:	41 5f                	pop    %r15
  800b32:	5d                   	pop    %rbp
  800b33:	c3                   	ret

0000000000800b34 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800b34:	f3 0f 1e fa          	endbr64
  800b38:	55                   	push   %rbp
  800b39:	48 89 e5             	mov    %rsp,%rbp
  800b3c:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800b40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b44:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800b49:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800b4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800b54:	48 85 ff             	test   %rdi,%rdi
  800b57:	74 2b                	je     800b84 <vsnprintf+0x50>
  800b59:	48 85 f6             	test   %rsi,%rsi
  800b5c:	74 26                	je     800b84 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800b5e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b62:	48 bf cb 03 80 00 00 	movabs $0x8003cb,%rdi
  800b69:	00 00 00 
  800b6c:	48 b8 28 04 80 00 00 	movabs $0x800428,%rax
  800b73:	00 00 00 
  800b76:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800b78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b7c:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800b7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800b82:	c9                   	leave
  800b83:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800b84:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b89:	eb f7                	jmp    800b82 <vsnprintf+0x4e>

0000000000800b8b <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800b8b:	f3 0f 1e fa          	endbr64
  800b8f:	55                   	push   %rbp
  800b90:	48 89 e5             	mov    %rsp,%rbp
  800b93:	48 83 ec 50          	sub    $0x50,%rsp
  800b97:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800b9b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800b9f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800ba3:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800baa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bae:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bb2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800bb6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800bba:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800bbe:	48 b8 34 0b 80 00 00 	movabs $0x800b34,%rax
  800bc5:	00 00 00 
  800bc8:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800bca:	c9                   	leave
  800bcb:	c3                   	ret

0000000000800bcc <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800bcc:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800bd0:	80 3f 00             	cmpb   $0x0,(%rdi)
  800bd3:	74 10                	je     800be5 <strlen+0x19>
    size_t n = 0;
  800bd5:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800bda:	48 83 c0 01          	add    $0x1,%rax
  800bde:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800be2:	75 f6                	jne    800bda <strlen+0xe>
  800be4:	c3                   	ret
    size_t n = 0;
  800be5:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800bea:	c3                   	ret

0000000000800beb <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800beb:	f3 0f 1e fa          	endbr64
  800bef:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800bf2:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800bf7:	48 85 f6             	test   %rsi,%rsi
  800bfa:	74 10                	je     800c0c <strnlen+0x21>
  800bfc:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800c00:	74 0b                	je     800c0d <strnlen+0x22>
  800c02:	48 83 c2 01          	add    $0x1,%rdx
  800c06:	48 39 d0             	cmp    %rdx,%rax
  800c09:	75 f1                	jne    800bfc <strnlen+0x11>
  800c0b:	c3                   	ret
  800c0c:	c3                   	ret
  800c0d:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800c10:	c3                   	ret

0000000000800c11 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800c11:	f3 0f 1e fa          	endbr64
  800c15:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800c18:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1d:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800c21:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800c24:	48 83 c2 01          	add    $0x1,%rdx
  800c28:	84 c9                	test   %cl,%cl
  800c2a:	75 f1                	jne    800c1d <strcpy+0xc>
        ;
    return res;
}
  800c2c:	c3                   	ret

0000000000800c2d <strcat>:

char *
strcat(char *dst, const char *src) {
  800c2d:	f3 0f 1e fa          	endbr64
  800c31:	55                   	push   %rbp
  800c32:	48 89 e5             	mov    %rsp,%rbp
  800c35:	41 54                	push   %r12
  800c37:	53                   	push   %rbx
  800c38:	48 89 fb             	mov    %rdi,%rbx
  800c3b:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800c3e:	48 b8 cc 0b 80 00 00 	movabs $0x800bcc,%rax
  800c45:	00 00 00 
  800c48:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800c4a:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800c4e:	4c 89 e6             	mov    %r12,%rsi
  800c51:	48 b8 11 0c 80 00 00 	movabs $0x800c11,%rax
  800c58:	00 00 00 
  800c5b:	ff d0                	call   *%rax
    return dst;
}
  800c5d:	48 89 d8             	mov    %rbx,%rax
  800c60:	5b                   	pop    %rbx
  800c61:	41 5c                	pop    %r12
  800c63:	5d                   	pop    %rbp
  800c64:	c3                   	ret

0000000000800c65 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c65:	f3 0f 1e fa          	endbr64
  800c69:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800c6c:	48 85 d2             	test   %rdx,%rdx
  800c6f:	74 1f                	je     800c90 <strncpy+0x2b>
  800c71:	48 01 fa             	add    %rdi,%rdx
  800c74:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800c77:	48 83 c1 01          	add    $0x1,%rcx
  800c7b:	44 0f b6 06          	movzbl (%rsi),%r8d
  800c7f:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800c83:	41 80 f8 01          	cmp    $0x1,%r8b
  800c87:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800c8b:	48 39 ca             	cmp    %rcx,%rdx
  800c8e:	75 e7                	jne    800c77 <strncpy+0x12>
    }
    return ret;
}
  800c90:	c3                   	ret

0000000000800c91 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800c91:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800c95:	48 89 f8             	mov    %rdi,%rax
  800c98:	48 85 d2             	test   %rdx,%rdx
  800c9b:	74 24                	je     800cc1 <strlcpy+0x30>
        while (--size > 0 && *src)
  800c9d:	48 83 ea 01          	sub    $0x1,%rdx
  800ca1:	74 1b                	je     800cbe <strlcpy+0x2d>
  800ca3:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800ca7:	0f b6 16             	movzbl (%rsi),%edx
  800caa:	84 d2                	test   %dl,%dl
  800cac:	74 10                	je     800cbe <strlcpy+0x2d>
            *dst++ = *src++;
  800cae:	48 83 c6 01          	add    $0x1,%rsi
  800cb2:	48 83 c0 01          	add    $0x1,%rax
  800cb6:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800cb9:	48 39 c8             	cmp    %rcx,%rax
  800cbc:	75 e9                	jne    800ca7 <strlcpy+0x16>
        *dst = '\0';
  800cbe:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800cc1:	48 29 f8             	sub    %rdi,%rax
}
  800cc4:	c3                   	ret

0000000000800cc5 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800cc5:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800cc9:	0f b6 07             	movzbl (%rdi),%eax
  800ccc:	84 c0                	test   %al,%al
  800cce:	74 13                	je     800ce3 <strcmp+0x1e>
  800cd0:	38 06                	cmp    %al,(%rsi)
  800cd2:	75 0f                	jne    800ce3 <strcmp+0x1e>
  800cd4:	48 83 c7 01          	add    $0x1,%rdi
  800cd8:	48 83 c6 01          	add    $0x1,%rsi
  800cdc:	0f b6 07             	movzbl (%rdi),%eax
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 ed                	jne    800cd0 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800ce3:	0f b6 c0             	movzbl %al,%eax
  800ce6:	0f b6 16             	movzbl (%rsi),%edx
  800ce9:	29 d0                	sub    %edx,%eax
}
  800ceb:	c3                   	ret

0000000000800cec <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800cec:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800cf0:	48 85 d2             	test   %rdx,%rdx
  800cf3:	74 1f                	je     800d14 <strncmp+0x28>
  800cf5:	0f b6 07             	movzbl (%rdi),%eax
  800cf8:	84 c0                	test   %al,%al
  800cfa:	74 1e                	je     800d1a <strncmp+0x2e>
  800cfc:	3a 06                	cmp    (%rsi),%al
  800cfe:	75 1a                	jne    800d1a <strncmp+0x2e>
  800d00:	48 83 c7 01          	add    $0x1,%rdi
  800d04:	48 83 c6 01          	add    $0x1,%rsi
  800d08:	48 83 ea 01          	sub    $0x1,%rdx
  800d0c:	75 e7                	jne    800cf5 <strncmp+0x9>

    if (!n) return 0;
  800d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d13:	c3                   	ret
  800d14:	b8 00 00 00 00       	mov    $0x0,%eax
  800d19:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800d1a:	0f b6 07             	movzbl (%rdi),%eax
  800d1d:	0f b6 16             	movzbl (%rsi),%edx
  800d20:	29 d0                	sub    %edx,%eax
}
  800d22:	c3                   	ret

0000000000800d23 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800d23:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800d27:	0f b6 17             	movzbl (%rdi),%edx
  800d2a:	84 d2                	test   %dl,%dl
  800d2c:	74 18                	je     800d46 <strchr+0x23>
        if (*str == c) {
  800d2e:	0f be d2             	movsbl %dl,%edx
  800d31:	39 f2                	cmp    %esi,%edx
  800d33:	74 17                	je     800d4c <strchr+0x29>
    for (; *str; str++) {
  800d35:	48 83 c7 01          	add    $0x1,%rdi
  800d39:	0f b6 17             	movzbl (%rdi),%edx
  800d3c:	84 d2                	test   %dl,%dl
  800d3e:	75 ee                	jne    800d2e <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800d40:	b8 00 00 00 00       	mov    $0x0,%eax
  800d45:	c3                   	ret
  800d46:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4b:	c3                   	ret
            return (char *)str;
  800d4c:	48 89 f8             	mov    %rdi,%rax
}
  800d4f:	c3                   	ret

0000000000800d50 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800d50:	f3 0f 1e fa          	endbr64
  800d54:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800d57:	0f b6 17             	movzbl (%rdi),%edx
  800d5a:	84 d2                	test   %dl,%dl
  800d5c:	74 13                	je     800d71 <strfind+0x21>
  800d5e:	0f be d2             	movsbl %dl,%edx
  800d61:	39 f2                	cmp    %esi,%edx
  800d63:	74 0b                	je     800d70 <strfind+0x20>
  800d65:	48 83 c0 01          	add    $0x1,%rax
  800d69:	0f b6 10             	movzbl (%rax),%edx
  800d6c:	84 d2                	test   %dl,%dl
  800d6e:	75 ee                	jne    800d5e <strfind+0xe>
        ;
    return (char *)str;
}
  800d70:	c3                   	ret
  800d71:	c3                   	ret

0000000000800d72 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800d72:	f3 0f 1e fa          	endbr64
  800d76:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800d79:	48 89 f8             	mov    %rdi,%rax
  800d7c:	48 f7 d8             	neg    %rax
  800d7f:	83 e0 07             	and    $0x7,%eax
  800d82:	49 89 d1             	mov    %rdx,%r9
  800d85:	49 29 c1             	sub    %rax,%r9
  800d88:	78 36                	js     800dc0 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800d8a:	40 0f b6 c6          	movzbl %sil,%eax
  800d8e:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800d95:	01 01 01 
  800d98:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800d9c:	40 f6 c7 07          	test   $0x7,%dil
  800da0:	75 38                	jne    800dda <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800da2:	4c 89 c9             	mov    %r9,%rcx
  800da5:	48 c1 f9 03          	sar    $0x3,%rcx
  800da9:	74 0c                	je     800db7 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800dab:	fc                   	cld
  800dac:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800daf:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800db3:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800db7:	4d 85 c9             	test   %r9,%r9
  800dba:	75 45                	jne    800e01 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800dbc:	4c 89 c0             	mov    %r8,%rax
  800dbf:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800dc0:	48 85 d2             	test   %rdx,%rdx
  800dc3:	74 f7                	je     800dbc <memset+0x4a>
  800dc5:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800dc8:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800dcb:	48 83 c0 01          	add    $0x1,%rax
  800dcf:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800dd3:	48 39 c2             	cmp    %rax,%rdx
  800dd6:	75 f3                	jne    800dcb <memset+0x59>
  800dd8:	eb e2                	jmp    800dbc <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800dda:	40 f6 c7 01          	test   $0x1,%dil
  800dde:	74 06                	je     800de6 <memset+0x74>
  800de0:	88 07                	mov    %al,(%rdi)
  800de2:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800de6:	40 f6 c7 02          	test   $0x2,%dil
  800dea:	74 07                	je     800df3 <memset+0x81>
  800dec:	66 89 07             	mov    %ax,(%rdi)
  800def:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800df3:	40 f6 c7 04          	test   $0x4,%dil
  800df7:	74 a9                	je     800da2 <memset+0x30>
  800df9:	89 07                	mov    %eax,(%rdi)
  800dfb:	48 83 c7 04          	add    $0x4,%rdi
  800dff:	eb a1                	jmp    800da2 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e01:	41 f6 c1 04          	test   $0x4,%r9b
  800e05:	74 1b                	je     800e22 <memset+0xb0>
  800e07:	89 07                	mov    %eax,(%rdi)
  800e09:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e0d:	41 f6 c1 02          	test   $0x2,%r9b
  800e11:	74 07                	je     800e1a <memset+0xa8>
  800e13:	66 89 07             	mov    %ax,(%rdi)
  800e16:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800e1a:	41 f6 c1 01          	test   $0x1,%r9b
  800e1e:	74 9c                	je     800dbc <memset+0x4a>
  800e20:	eb 06                	jmp    800e28 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e22:	41 f6 c1 02          	test   $0x2,%r9b
  800e26:	75 eb                	jne    800e13 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800e28:	88 07                	mov    %al,(%rdi)
  800e2a:	eb 90                	jmp    800dbc <memset+0x4a>

0000000000800e2c <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800e2c:	f3 0f 1e fa          	endbr64
  800e30:	48 89 f8             	mov    %rdi,%rax
  800e33:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800e36:	48 39 fe             	cmp    %rdi,%rsi
  800e39:	73 3b                	jae    800e76 <memmove+0x4a>
  800e3b:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800e3f:	48 39 d7             	cmp    %rdx,%rdi
  800e42:	73 32                	jae    800e76 <memmove+0x4a>
        s += n;
        d += n;
  800e44:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e48:	48 89 d6             	mov    %rdx,%rsi
  800e4b:	48 09 fe             	or     %rdi,%rsi
  800e4e:	48 09 ce             	or     %rcx,%rsi
  800e51:	40 f6 c6 07          	test   $0x7,%sil
  800e55:	75 12                	jne    800e69 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800e57:	48 83 ef 08          	sub    $0x8,%rdi
  800e5b:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800e5f:	48 c1 e9 03          	shr    $0x3,%rcx
  800e63:	fd                   	std
  800e64:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800e67:	fc                   	cld
  800e68:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800e69:	48 83 ef 01          	sub    $0x1,%rdi
  800e6d:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800e71:	fd                   	std
  800e72:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800e74:	eb f1                	jmp    800e67 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e76:	48 89 f2             	mov    %rsi,%rdx
  800e79:	48 09 c2             	or     %rax,%rdx
  800e7c:	48 09 ca             	or     %rcx,%rdx
  800e7f:	f6 c2 07             	test   $0x7,%dl
  800e82:	75 0c                	jne    800e90 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800e84:	48 c1 e9 03          	shr    $0x3,%rcx
  800e88:	48 89 c7             	mov    %rax,%rdi
  800e8b:	fc                   	cld
  800e8c:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800e8f:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800e90:	48 89 c7             	mov    %rax,%rdi
  800e93:	fc                   	cld
  800e94:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800e96:	c3                   	ret

0000000000800e97 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800e97:	f3 0f 1e fa          	endbr64
  800e9b:	55                   	push   %rbp
  800e9c:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800e9f:	48 b8 2c 0e 80 00 00 	movabs $0x800e2c,%rax
  800ea6:	00 00 00 
  800ea9:	ff d0                	call   *%rax
}
  800eab:	5d                   	pop    %rbp
  800eac:	c3                   	ret

0000000000800ead <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800ead:	f3 0f 1e fa          	endbr64
  800eb1:	55                   	push   %rbp
  800eb2:	48 89 e5             	mov    %rsp,%rbp
  800eb5:	41 57                	push   %r15
  800eb7:	41 56                	push   %r14
  800eb9:	41 55                	push   %r13
  800ebb:	41 54                	push   %r12
  800ebd:	53                   	push   %rbx
  800ebe:	48 83 ec 08          	sub    $0x8,%rsp
  800ec2:	49 89 fe             	mov    %rdi,%r14
  800ec5:	49 89 f7             	mov    %rsi,%r15
  800ec8:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800ecb:	48 89 f7             	mov    %rsi,%rdi
  800ece:	48 b8 cc 0b 80 00 00 	movabs $0x800bcc,%rax
  800ed5:	00 00 00 
  800ed8:	ff d0                	call   *%rax
  800eda:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800edd:	48 89 de             	mov    %rbx,%rsi
  800ee0:	4c 89 f7             	mov    %r14,%rdi
  800ee3:	48 b8 eb 0b 80 00 00 	movabs $0x800beb,%rax
  800eea:	00 00 00 
  800eed:	ff d0                	call   *%rax
  800eef:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800ef2:	48 39 c3             	cmp    %rax,%rbx
  800ef5:	74 36                	je     800f2d <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800ef7:	48 89 d8             	mov    %rbx,%rax
  800efa:	4c 29 e8             	sub    %r13,%rax
  800efd:	49 39 c4             	cmp    %rax,%r12
  800f00:	73 31                	jae    800f33 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800f02:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800f07:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f0b:	4c 89 fe             	mov    %r15,%rsi
  800f0e:	48 b8 97 0e 80 00 00 	movabs $0x800e97,%rax
  800f15:	00 00 00 
  800f18:	ff d0                	call   *%rax
    return dstlen + srclen;
  800f1a:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800f1e:	48 83 c4 08          	add    $0x8,%rsp
  800f22:	5b                   	pop    %rbx
  800f23:	41 5c                	pop    %r12
  800f25:	41 5d                	pop    %r13
  800f27:	41 5e                	pop    %r14
  800f29:	41 5f                	pop    %r15
  800f2b:	5d                   	pop    %rbp
  800f2c:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800f2d:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800f31:	eb eb                	jmp    800f1e <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800f33:	48 83 eb 01          	sub    $0x1,%rbx
  800f37:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f3b:	48 89 da             	mov    %rbx,%rdx
  800f3e:	4c 89 fe             	mov    %r15,%rsi
  800f41:	48 b8 97 0e 80 00 00 	movabs $0x800e97,%rax
  800f48:	00 00 00 
  800f4b:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800f4d:	49 01 de             	add    %rbx,%r14
  800f50:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800f55:	eb c3                	jmp    800f1a <strlcat+0x6d>

0000000000800f57 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800f57:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800f5b:	48 85 d2             	test   %rdx,%rdx
  800f5e:	74 2d                	je     800f8d <memcmp+0x36>
  800f60:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800f65:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800f69:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800f6e:	44 38 c1             	cmp    %r8b,%cl
  800f71:	75 0f                	jne    800f82 <memcmp+0x2b>
    while (n-- > 0) {
  800f73:	48 83 c0 01          	add    $0x1,%rax
  800f77:	48 39 c2             	cmp    %rax,%rdx
  800f7a:	75 e9                	jne    800f65 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800f7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f81:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800f82:	0f b6 c1             	movzbl %cl,%eax
  800f85:	45 0f b6 c0          	movzbl %r8b,%r8d
  800f89:	44 29 c0             	sub    %r8d,%eax
  800f8c:	c3                   	ret
    return 0;
  800f8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f92:	c3                   	ret

0000000000800f93 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800f93:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800f97:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800f9b:	48 39 c7             	cmp    %rax,%rdi
  800f9e:	73 0f                	jae    800faf <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800fa0:	40 38 37             	cmp    %sil,(%rdi)
  800fa3:	74 0e                	je     800fb3 <memfind+0x20>
    for (; src < end; src++) {
  800fa5:	48 83 c7 01          	add    $0x1,%rdi
  800fa9:	48 39 f8             	cmp    %rdi,%rax
  800fac:	75 f2                	jne    800fa0 <memfind+0xd>
  800fae:	c3                   	ret
  800faf:	48 89 f8             	mov    %rdi,%rax
  800fb2:	c3                   	ret
  800fb3:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800fb6:	c3                   	ret

0000000000800fb7 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800fb7:	f3 0f 1e fa          	endbr64
  800fbb:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800fbe:	0f b6 37             	movzbl (%rdi),%esi
  800fc1:	40 80 fe 20          	cmp    $0x20,%sil
  800fc5:	74 06                	je     800fcd <strtol+0x16>
  800fc7:	40 80 fe 09          	cmp    $0x9,%sil
  800fcb:	75 13                	jne    800fe0 <strtol+0x29>
  800fcd:	48 83 c7 01          	add    $0x1,%rdi
  800fd1:	0f b6 37             	movzbl (%rdi),%esi
  800fd4:	40 80 fe 20          	cmp    $0x20,%sil
  800fd8:	74 f3                	je     800fcd <strtol+0x16>
  800fda:	40 80 fe 09          	cmp    $0x9,%sil
  800fde:	74 ed                	je     800fcd <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800fe0:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800fe3:	83 e0 fd             	and    $0xfffffffd,%eax
  800fe6:	3c 01                	cmp    $0x1,%al
  800fe8:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800fec:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  800ff2:	75 0f                	jne    801003 <strtol+0x4c>
  800ff4:	80 3f 30             	cmpb   $0x30,(%rdi)
  800ff7:	74 14                	je     80100d <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800ff9:	85 d2                	test   %edx,%edx
  800ffb:	b8 0a 00 00 00       	mov    $0xa,%eax
  801000:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801003:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801008:	4c 63 ca             	movslq %edx,%r9
  80100b:	eb 36                	jmp    801043 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80100d:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801011:	74 0f                	je     801022 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801013:	85 d2                	test   %edx,%edx
  801015:	75 ec                	jne    801003 <strtol+0x4c>
        s++;
  801017:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  80101b:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  801020:	eb e1                	jmp    801003 <strtol+0x4c>
        s += 2;
  801022:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801026:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  80102b:	eb d6                	jmp    801003 <strtol+0x4c>
            dig -= '0';
  80102d:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  801030:	44 0f b6 c1          	movzbl %cl,%r8d
  801034:	41 39 d0             	cmp    %edx,%r8d
  801037:	7d 21                	jge    80105a <strtol+0xa3>
        val = val * base + dig;
  801039:	49 0f af c1          	imul   %r9,%rax
  80103d:	0f b6 c9             	movzbl %cl,%ecx
  801040:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  801043:	48 83 c7 01          	add    $0x1,%rdi
  801047:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  80104b:	80 f9 39             	cmp    $0x39,%cl
  80104e:	76 dd                	jbe    80102d <strtol+0x76>
        else if (dig - 'a' < 27)
  801050:	80 f9 7b             	cmp    $0x7b,%cl
  801053:	77 05                	ja     80105a <strtol+0xa3>
            dig -= 'a' - 10;
  801055:	83 e9 57             	sub    $0x57,%ecx
  801058:	eb d6                	jmp    801030 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  80105a:	4d 85 d2             	test   %r10,%r10
  80105d:	74 03                	je     801062 <strtol+0xab>
  80105f:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801062:	48 89 c2             	mov    %rax,%rdx
  801065:	48 f7 da             	neg    %rdx
  801068:	40 80 fe 2d          	cmp    $0x2d,%sil
  80106c:	48 0f 44 c2          	cmove  %rdx,%rax
}
  801070:	c3                   	ret

0000000000801071 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801071:	f3 0f 1e fa          	endbr64
  801075:	55                   	push   %rbp
  801076:	48 89 e5             	mov    %rsp,%rbp
  801079:	53                   	push   %rbx
  80107a:	48 89 fa             	mov    %rdi,%rdx
  80107d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801080:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801085:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80108f:	be 00 00 00 00       	mov    $0x0,%esi
  801094:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80109a:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80109c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010a0:	c9                   	leave
  8010a1:	c3                   	ret

00000000008010a2 <sys_cgetc>:

int
sys_cgetc(void) {
  8010a2:	f3 0f 1e fa          	endbr64
  8010a6:	55                   	push   %rbp
  8010a7:	48 89 e5             	mov    %rsp,%rbp
  8010aa:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010ab:	b8 01 00 00 00       	mov    $0x1,%eax
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
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8010d1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010d5:	c9                   	leave
  8010d6:	c3                   	ret

00000000008010d7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8010d7:	f3 0f 1e fa          	endbr64
  8010db:	55                   	push   %rbp
  8010dc:	48 89 e5             	mov    %rsp,%rbp
  8010df:	53                   	push   %rbx
  8010e0:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8010e4:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8010e7:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010ec:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010fb:	be 00 00 00 00       	mov    $0x0,%esi
  801100:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801106:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801108:	48 85 c0             	test   %rax,%rax
  80110b:	7f 06                	jg     801113 <sys_env_destroy+0x3c>
}
  80110d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801111:	c9                   	leave
  801112:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801113:	49 89 c0             	mov    %rax,%r8
  801116:	b9 03 00 00 00       	mov    $0x3,%ecx
  80111b:	48 ba 80 46 80 00 00 	movabs $0x804680,%rdx
  801122:	00 00 00 
  801125:	be 26 00 00 00       	mov    $0x26,%esi
  80112a:	48 bf c2 41 80 00 00 	movabs $0x8041c2,%rdi
  801131:	00 00 00 
  801134:	b8 00 00 00 00       	mov    $0x0,%eax
  801139:	49 b9 56 2e 80 00 00 	movabs $0x802e56,%r9
  801140:	00 00 00 
  801143:	41 ff d1             	call   *%r9

0000000000801146 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801146:	f3 0f 1e fa          	endbr64
  80114a:	55                   	push   %rbp
  80114b:	48 89 e5             	mov    %rsp,%rbp
  80114e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80114f:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801154:	ba 00 00 00 00       	mov    $0x0,%edx
  801159:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80115e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801163:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801168:	be 00 00 00 00       	mov    $0x0,%esi
  80116d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801173:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801175:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801179:	c9                   	leave
  80117a:	c3                   	ret

000000000080117b <sys_yield>:

void
sys_yield(void) {
  80117b:	f3 0f 1e fa          	endbr64
  80117f:	55                   	push   %rbp
  801180:	48 89 e5             	mov    %rsp,%rbp
  801183:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801184:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801189:	ba 00 00 00 00       	mov    $0x0,%edx
  80118e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801193:	bb 00 00 00 00       	mov    $0x0,%ebx
  801198:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80119d:	be 00 00 00 00       	mov    $0x0,%esi
  8011a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011a8:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8011aa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011ae:	c9                   	leave
  8011af:	c3                   	ret

00000000008011b0 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8011b0:	f3 0f 1e fa          	endbr64
  8011b4:	55                   	push   %rbp
  8011b5:	48 89 e5             	mov    %rsp,%rbp
  8011b8:	53                   	push   %rbx
  8011b9:	48 89 fa             	mov    %rdi,%rdx
  8011bc:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8011bf:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011c4:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8011cb:	00 00 00 
  8011ce:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011d3:	be 00 00 00 00       	mov    $0x0,%esi
  8011d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011de:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8011e0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011e4:	c9                   	leave
  8011e5:	c3                   	ret

00000000008011e6 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8011e6:	f3 0f 1e fa          	endbr64
  8011ea:	55                   	push   %rbp
  8011eb:	48 89 e5             	mov    %rsp,%rbp
  8011ee:	53                   	push   %rbx
  8011ef:	49 89 f8             	mov    %rdi,%r8
  8011f2:	48 89 d3             	mov    %rdx,%rbx
  8011f5:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8011f8:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011fd:	4c 89 c2             	mov    %r8,%rdx
  801200:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801203:	be 00 00 00 00       	mov    $0x0,%esi
  801208:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80120e:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801210:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801214:	c9                   	leave
  801215:	c3                   	ret

0000000000801216 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801216:	f3 0f 1e fa          	endbr64
  80121a:	55                   	push   %rbp
  80121b:	48 89 e5             	mov    %rsp,%rbp
  80121e:	53                   	push   %rbx
  80121f:	48 83 ec 08          	sub    $0x8,%rsp
  801223:	89 f8                	mov    %edi,%eax
  801225:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801228:	48 63 f9             	movslq %ecx,%rdi
  80122b:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80122e:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801233:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801236:	be 00 00 00 00       	mov    $0x0,%esi
  80123b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801241:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801243:	48 85 c0             	test   %rax,%rax
  801246:	7f 06                	jg     80124e <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801248:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80124c:	c9                   	leave
  80124d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80124e:	49 89 c0             	mov    %rax,%r8
  801251:	b9 04 00 00 00       	mov    $0x4,%ecx
  801256:	48 ba 80 46 80 00 00 	movabs $0x804680,%rdx
  80125d:	00 00 00 
  801260:	be 26 00 00 00       	mov    $0x26,%esi
  801265:	48 bf c2 41 80 00 00 	movabs $0x8041c2,%rdi
  80126c:	00 00 00 
  80126f:	b8 00 00 00 00       	mov    $0x0,%eax
  801274:	49 b9 56 2e 80 00 00 	movabs $0x802e56,%r9
  80127b:	00 00 00 
  80127e:	41 ff d1             	call   *%r9

0000000000801281 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801281:	f3 0f 1e fa          	endbr64
  801285:	55                   	push   %rbp
  801286:	48 89 e5             	mov    %rsp,%rbp
  801289:	53                   	push   %rbx
  80128a:	48 83 ec 08          	sub    $0x8,%rsp
  80128e:	89 f8                	mov    %edi,%eax
  801290:	49 89 f2             	mov    %rsi,%r10
  801293:	48 89 cf             	mov    %rcx,%rdi
  801296:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801299:	48 63 da             	movslq %edx,%rbx
  80129c:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80129f:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012a4:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012a7:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8012aa:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012ac:	48 85 c0             	test   %rax,%rax
  8012af:	7f 06                	jg     8012b7 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8012b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012b5:	c9                   	leave
  8012b6:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012b7:	49 89 c0             	mov    %rax,%r8
  8012ba:	b9 05 00 00 00       	mov    $0x5,%ecx
  8012bf:	48 ba 80 46 80 00 00 	movabs $0x804680,%rdx
  8012c6:	00 00 00 
  8012c9:	be 26 00 00 00       	mov    $0x26,%esi
  8012ce:	48 bf c2 41 80 00 00 	movabs $0x8041c2,%rdi
  8012d5:	00 00 00 
  8012d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012dd:	49 b9 56 2e 80 00 00 	movabs $0x802e56,%r9
  8012e4:	00 00 00 
  8012e7:	41 ff d1             	call   *%r9

00000000008012ea <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8012ea:	f3 0f 1e fa          	endbr64
  8012ee:	55                   	push   %rbp
  8012ef:	48 89 e5             	mov    %rsp,%rbp
  8012f2:	53                   	push   %rbx
  8012f3:	48 83 ec 08          	sub    $0x8,%rsp
  8012f7:	49 89 f9             	mov    %rdi,%r9
  8012fa:	89 f0                	mov    %esi,%eax
  8012fc:	48 89 d3             	mov    %rdx,%rbx
  8012ff:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801302:	49 63 f0             	movslq %r8d,%rsi
  801305:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801308:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80130d:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801310:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801316:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801318:	48 85 c0             	test   %rax,%rax
  80131b:	7f 06                	jg     801323 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80131d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801321:	c9                   	leave
  801322:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801323:	49 89 c0             	mov    %rax,%r8
  801326:	b9 06 00 00 00       	mov    $0x6,%ecx
  80132b:	48 ba 80 46 80 00 00 	movabs $0x804680,%rdx
  801332:	00 00 00 
  801335:	be 26 00 00 00       	mov    $0x26,%esi
  80133a:	48 bf c2 41 80 00 00 	movabs $0x8041c2,%rdi
  801341:	00 00 00 
  801344:	b8 00 00 00 00       	mov    $0x0,%eax
  801349:	49 b9 56 2e 80 00 00 	movabs $0x802e56,%r9
  801350:	00 00 00 
  801353:	41 ff d1             	call   *%r9

0000000000801356 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801356:	f3 0f 1e fa          	endbr64
  80135a:	55                   	push   %rbp
  80135b:	48 89 e5             	mov    %rsp,%rbp
  80135e:	53                   	push   %rbx
  80135f:	48 83 ec 08          	sub    $0x8,%rsp
  801363:	48 89 f1             	mov    %rsi,%rcx
  801366:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801369:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80136c:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801371:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801376:	be 00 00 00 00       	mov    $0x0,%esi
  80137b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801381:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801383:	48 85 c0             	test   %rax,%rax
  801386:	7f 06                	jg     80138e <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801388:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80138c:	c9                   	leave
  80138d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80138e:	49 89 c0             	mov    %rax,%r8
  801391:	b9 07 00 00 00       	mov    $0x7,%ecx
  801396:	48 ba 80 46 80 00 00 	movabs $0x804680,%rdx
  80139d:	00 00 00 
  8013a0:	be 26 00 00 00       	mov    $0x26,%esi
  8013a5:	48 bf c2 41 80 00 00 	movabs $0x8041c2,%rdi
  8013ac:	00 00 00 
  8013af:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b4:	49 b9 56 2e 80 00 00 	movabs $0x802e56,%r9
  8013bb:	00 00 00 
  8013be:	41 ff d1             	call   *%r9

00000000008013c1 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8013c1:	f3 0f 1e fa          	endbr64
  8013c5:	55                   	push   %rbp
  8013c6:	48 89 e5             	mov    %rsp,%rbp
  8013c9:	53                   	push   %rbx
  8013ca:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8013ce:	48 63 ce             	movslq %esi,%rcx
  8013d1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013d4:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013de:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e3:	be 00 00 00 00       	mov    $0x0,%esi
  8013e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013ee:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013f0:	48 85 c0             	test   %rax,%rax
  8013f3:	7f 06                	jg     8013fb <sys_env_set_status+0x3a>
}
  8013f5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013f9:	c9                   	leave
  8013fa:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013fb:	49 89 c0             	mov    %rax,%r8
  8013fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801403:	48 ba 80 46 80 00 00 	movabs $0x804680,%rdx
  80140a:	00 00 00 
  80140d:	be 26 00 00 00       	mov    $0x26,%esi
  801412:	48 bf c2 41 80 00 00 	movabs $0x8041c2,%rdi
  801419:	00 00 00 
  80141c:	b8 00 00 00 00       	mov    $0x0,%eax
  801421:	49 b9 56 2e 80 00 00 	movabs $0x802e56,%r9
  801428:	00 00 00 
  80142b:	41 ff d1             	call   *%r9

000000000080142e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80142e:	f3 0f 1e fa          	endbr64
  801432:	55                   	push   %rbp
  801433:	48 89 e5             	mov    %rsp,%rbp
  801436:	53                   	push   %rbx
  801437:	48 83 ec 08          	sub    $0x8,%rsp
  80143b:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80143e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801441:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801446:	bb 00 00 00 00       	mov    $0x0,%ebx
  80144b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801450:	be 00 00 00 00       	mov    $0x0,%esi
  801455:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80145b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80145d:	48 85 c0             	test   %rax,%rax
  801460:	7f 06                	jg     801468 <sys_env_set_trapframe+0x3a>
}
  801462:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801466:	c9                   	leave
  801467:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801468:	49 89 c0             	mov    %rax,%r8
  80146b:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801470:	48 ba 80 46 80 00 00 	movabs $0x804680,%rdx
  801477:	00 00 00 
  80147a:	be 26 00 00 00       	mov    $0x26,%esi
  80147f:	48 bf c2 41 80 00 00 	movabs $0x8041c2,%rdi
  801486:	00 00 00 
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
  80148e:	49 b9 56 2e 80 00 00 	movabs $0x802e56,%r9
  801495:	00 00 00 
  801498:	41 ff d1             	call   *%r9

000000000080149b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80149b:	f3 0f 1e fa          	endbr64
  80149f:	55                   	push   %rbp
  8014a0:	48 89 e5             	mov    %rsp,%rbp
  8014a3:	53                   	push   %rbx
  8014a4:	48 83 ec 08          	sub    $0x8,%rsp
  8014a8:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8014ab:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014ae:	b8 0c 00 00 00       	mov    $0xc,%eax
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
  8014cd:	7f 06                	jg     8014d5 <sys_env_set_pgfault_upcall+0x3a>
}
  8014cf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014d3:	c9                   	leave
  8014d4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014d5:	49 89 c0             	mov    %rax,%r8
  8014d8:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8014dd:	48 ba 80 46 80 00 00 	movabs $0x804680,%rdx
  8014e4:	00 00 00 
  8014e7:	be 26 00 00 00       	mov    $0x26,%esi
  8014ec:	48 bf c2 41 80 00 00 	movabs $0x8041c2,%rdi
  8014f3:	00 00 00 
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fb:	49 b9 56 2e 80 00 00 	movabs $0x802e56,%r9
  801502:	00 00 00 
  801505:	41 ff d1             	call   *%r9

0000000000801508 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801508:	f3 0f 1e fa          	endbr64
  80150c:	55                   	push   %rbp
  80150d:	48 89 e5             	mov    %rsp,%rbp
  801510:	53                   	push   %rbx
  801511:	89 f8                	mov    %edi,%eax
  801513:	49 89 f1             	mov    %rsi,%r9
  801516:	48 89 d3             	mov    %rdx,%rbx
  801519:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80151c:	49 63 f0             	movslq %r8d,%rsi
  80151f:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801522:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801527:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80152a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801530:	cd 30                	int    $0x30
}
  801532:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801536:	c9                   	leave
  801537:	c3                   	ret

0000000000801538 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801538:	f3 0f 1e fa          	endbr64
  80153c:	55                   	push   %rbp
  80153d:	48 89 e5             	mov    %rsp,%rbp
  801540:	53                   	push   %rbx
  801541:	48 83 ec 08          	sub    $0x8,%rsp
  801545:	48 89 fa             	mov    %rdi,%rdx
  801548:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80154b:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801550:	bb 00 00 00 00       	mov    $0x0,%ebx
  801555:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80155a:	be 00 00 00 00       	mov    $0x0,%esi
  80155f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801565:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801567:	48 85 c0             	test   %rax,%rax
  80156a:	7f 06                	jg     801572 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80156c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801570:	c9                   	leave
  801571:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801572:	49 89 c0             	mov    %rax,%r8
  801575:	b9 0f 00 00 00       	mov    $0xf,%ecx
  80157a:	48 ba 80 46 80 00 00 	movabs $0x804680,%rdx
  801581:	00 00 00 
  801584:	be 26 00 00 00       	mov    $0x26,%esi
  801589:	48 bf c2 41 80 00 00 	movabs $0x8041c2,%rdi
  801590:	00 00 00 
  801593:	b8 00 00 00 00       	mov    $0x0,%eax
  801598:	49 b9 56 2e 80 00 00 	movabs $0x802e56,%r9
  80159f:	00 00 00 
  8015a2:	41 ff d1             	call   *%r9

00000000008015a5 <sys_gettime>:

int
sys_gettime(void) {
  8015a5:	f3 0f 1e fa          	endbr64
  8015a9:	55                   	push   %rbp
  8015aa:	48 89 e5             	mov    %rsp,%rbp
  8015ad:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015ae:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015c2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015c7:	be 00 00 00 00       	mov    $0x0,%esi
  8015cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015d2:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8015d4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015d8:	c9                   	leave
  8015d9:	c3                   	ret

00000000008015da <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8015da:	f3 0f 1e fa          	endbr64
  8015de:	55                   	push   %rbp
  8015df:	48 89 e5             	mov    %rsp,%rbp
  8015e2:	41 56                	push   %r14
  8015e4:	41 55                	push   %r13
  8015e6:	41 54                	push   %r12
  8015e8:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  8015e9:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8015f0:	00 00 00 
  8015f3:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8015fa:	b8 09 00 00 00       	mov    $0x9,%eax
  8015ff:	cd 30                	int    $0x30
  801601:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  801604:	85 c0                	test   %eax,%eax
  801606:	78 7f                	js     801687 <fork+0xad>
  801608:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  80160a:	0f 84 83 00 00 00    	je     801693 <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  801610:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  801616:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  80161d:	00 00 00 
  801620:	b9 00 00 00 00       	mov    $0x0,%ecx
  801625:	89 c2                	mov    %eax,%edx
  801627:	be 00 00 00 00       	mov    $0x0,%esi
  80162c:	bf 00 00 00 00       	mov    $0x0,%edi
  801631:	48 b8 81 12 80 00 00 	movabs $0x801281,%rax
  801638:	00 00 00 
  80163b:	ff d0                	call   *%rax
  80163d:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  801640:	85 c0                	test   %eax,%eax
  801642:	0f 88 81 00 00 00    	js     8016c9 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  801648:	4d 85 f6             	test   %r14,%r14
  80164b:	74 20                	je     80166d <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80164d:	48 be fd 2e 80 00 00 	movabs $0x802efd,%rsi
  801654:	00 00 00 
  801657:	44 89 e7             	mov    %r12d,%edi
  80165a:	48 b8 9b 14 80 00 00 	movabs $0x80149b,%rax
  801661:	00 00 00 
  801664:	ff d0                	call   *%rax
  801666:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  801669:	85 c0                	test   %eax,%eax
  80166b:	78 70                	js     8016dd <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  80166d:	be 02 00 00 00       	mov    $0x2,%esi
  801672:	89 df                	mov    %ebx,%edi
  801674:	48 b8 c1 13 80 00 00 	movabs $0x8013c1,%rax
  80167b:	00 00 00 
  80167e:	ff d0                	call   *%rax
  801680:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  801683:	85 c0                	test   %eax,%eax
  801685:	78 6a                	js     8016f1 <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  801687:	44 89 e0             	mov    %r12d,%eax
  80168a:	5b                   	pop    %rbx
  80168b:	41 5c                	pop    %r12
  80168d:	41 5d                	pop    %r13
  80168f:	41 5e                	pop    %r14
  801691:	5d                   	pop    %rbp
  801692:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  801693:	48 b8 46 11 80 00 00 	movabs $0x801146,%rax
  80169a:	00 00 00 
  80169d:	ff d0                	call   *%rax
  80169f:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016a4:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8016a8:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8016ac:	48 c1 e0 04          	shl    $0x4,%rax
  8016b0:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8016b7:	00 00 00 
  8016ba:	48 01 d0             	add    %rdx,%rax
  8016bd:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8016c4:	00 00 00 
        return 0;
  8016c7:	eb be                	jmp    801687 <fork+0xad>
        sys_env_destroy(envid);
  8016c9:	44 89 e7             	mov    %r12d,%edi
  8016cc:	48 b8 d7 10 80 00 00 	movabs $0x8010d7,%rax
  8016d3:	00 00 00 
  8016d6:	ff d0                	call   *%rax
        return res;
  8016d8:	45 89 ec             	mov    %r13d,%r12d
  8016db:	eb aa                	jmp    801687 <fork+0xad>
            sys_env_destroy(envid);
  8016dd:	44 89 e7             	mov    %r12d,%edi
  8016e0:	48 b8 d7 10 80 00 00 	movabs $0x8010d7,%rax
  8016e7:	00 00 00 
  8016ea:	ff d0                	call   *%rax
            return res;
  8016ec:	45 89 ec             	mov    %r13d,%r12d
  8016ef:	eb 96                	jmp    801687 <fork+0xad>
        sys_env_destroy(envid);
  8016f1:	89 df                	mov    %ebx,%edi
  8016f3:	48 b8 d7 10 80 00 00 	movabs $0x8010d7,%rax
  8016fa:	00 00 00 
  8016fd:	ff d0                	call   *%rax
        return res;
  8016ff:	45 89 ec             	mov    %r13d,%r12d
  801702:	eb 83                	jmp    801687 <fork+0xad>

0000000000801704 <sfork>:

envid_t
sfork() {
  801704:	f3 0f 1e fa          	endbr64
  801708:	55                   	push   %rbp
  801709:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  80170c:	48 ba d0 41 80 00 00 	movabs $0x8041d0,%rdx
  801713:	00 00 00 
  801716:	be 37 00 00 00       	mov    $0x37,%esi
  80171b:	48 bf eb 41 80 00 00 	movabs $0x8041eb,%rdi
  801722:	00 00 00 
  801725:	b8 00 00 00 00       	mov    $0x0,%eax
  80172a:	48 b9 56 2e 80 00 00 	movabs $0x802e56,%rcx
  801731:	00 00 00 
  801734:	ff d1                	call   *%rcx

0000000000801736 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  801736:	f3 0f 1e fa          	endbr64
  80173a:	55                   	push   %rbp
  80173b:	48 89 e5             	mov    %rsp,%rbp
  80173e:	41 54                	push   %r12
  801740:	53                   	push   %rbx
  801741:	48 89 fb             	mov    %rdi,%rbx
  801744:	48 89 f7             	mov    %rsi,%rdi
  801747:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  80174a:	48 85 f6             	test   %rsi,%rsi
  80174d:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  801754:	00 00 00 
  801757:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  80175b:	be 00 10 00 00       	mov    $0x1000,%esi
  801760:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  801767:	00 00 00 
  80176a:	ff d0                	call   *%rax
    if (res < 0) {
  80176c:	85 c0                	test   %eax,%eax
  80176e:	78 45                	js     8017b5 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  801770:	48 85 db             	test   %rbx,%rbx
  801773:	74 12                	je     801787 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  801775:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80177c:	00 00 00 
  80177f:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  801785:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  801787:	4d 85 e4             	test   %r12,%r12
  80178a:	74 14                	je     8017a0 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  80178c:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801793:	00 00 00 
  801796:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  80179c:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  8017a0:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8017a7:	00 00 00 
  8017aa:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  8017b0:	5b                   	pop    %rbx
  8017b1:	41 5c                	pop    %r12
  8017b3:	5d                   	pop    %rbp
  8017b4:	c3                   	ret
        if (from_env_store != NULL) {
  8017b5:	48 85 db             	test   %rbx,%rbx
  8017b8:	74 06                	je     8017c0 <ipc_recv+0x8a>
            *from_env_store = 0;
  8017ba:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  8017c0:	4d 85 e4             	test   %r12,%r12
  8017c3:	74 eb                	je     8017b0 <ipc_recv+0x7a>
            *perm_store = 0;
  8017c5:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8017cc:	00 
  8017cd:	eb e1                	jmp    8017b0 <ipc_recv+0x7a>

00000000008017cf <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8017cf:	f3 0f 1e fa          	endbr64
  8017d3:	55                   	push   %rbp
  8017d4:	48 89 e5             	mov    %rsp,%rbp
  8017d7:	41 57                	push   %r15
  8017d9:	41 56                	push   %r14
  8017db:	41 55                	push   %r13
  8017dd:	41 54                	push   %r12
  8017df:	53                   	push   %rbx
  8017e0:	48 83 ec 18          	sub    $0x18,%rsp
  8017e4:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  8017e7:	48 89 d3             	mov    %rdx,%rbx
  8017ea:	49 89 cc             	mov    %rcx,%r12
  8017ed:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8017f0:	48 85 d2             	test   %rdx,%rdx
  8017f3:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8017fa:	00 00 00 
  8017fd:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  801801:	89 f0                	mov    %esi,%eax
  801803:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801807:	48 89 da             	mov    %rbx,%rdx
  80180a:	48 89 c6             	mov    %rax,%rsi
  80180d:	48 b8 08 15 80 00 00 	movabs $0x801508,%rax
  801814:	00 00 00 
  801817:	ff d0                	call   *%rax
    while (res < 0) {
  801819:	85 c0                	test   %eax,%eax
  80181b:	79 65                	jns    801882 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80181d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801820:	75 33                	jne    801855 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  801822:	49 bf 7b 11 80 00 00 	movabs $0x80117b,%r15
  801829:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  80182c:	49 be 08 15 80 00 00 	movabs $0x801508,%r14
  801833:	00 00 00 
        sys_yield();
  801836:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  801839:	45 89 e8             	mov    %r13d,%r8d
  80183c:	4c 89 e1             	mov    %r12,%rcx
  80183f:	48 89 da             	mov    %rbx,%rdx
  801842:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  801846:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  801849:	41 ff d6             	call   *%r14
    while (res < 0) {
  80184c:	85 c0                	test   %eax,%eax
  80184e:	79 32                	jns    801882 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  801850:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801853:	74 e1                	je     801836 <ipc_send+0x67>
            panic("Error: %i\n", res);
  801855:	89 c1                	mov    %eax,%ecx
  801857:	48 ba f6 41 80 00 00 	movabs $0x8041f6,%rdx
  80185e:	00 00 00 
  801861:	be 42 00 00 00       	mov    $0x42,%esi
  801866:	48 bf 01 42 80 00 00 	movabs $0x804201,%rdi
  80186d:	00 00 00 
  801870:	b8 00 00 00 00       	mov    $0x0,%eax
  801875:	49 b8 56 2e 80 00 00 	movabs $0x802e56,%r8
  80187c:	00 00 00 
  80187f:	41 ff d0             	call   *%r8
    }
}
  801882:	48 83 c4 18          	add    $0x18,%rsp
  801886:	5b                   	pop    %rbx
  801887:	41 5c                	pop    %r12
  801889:	41 5d                	pop    %r13
  80188b:	41 5e                	pop    %r14
  80188d:	41 5f                	pop    %r15
  80188f:	5d                   	pop    %rbp
  801890:	c3                   	ret

0000000000801891 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  801891:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  801895:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80189a:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  8018a1:	00 00 00 
  8018a4:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8018a8:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8018ac:	48 c1 e2 04          	shl    $0x4,%rdx
  8018b0:	48 01 ca             	add    %rcx,%rdx
  8018b3:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8018b9:	39 fa                	cmp    %edi,%edx
  8018bb:	74 12                	je     8018cf <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  8018bd:	48 83 c0 01          	add    $0x1,%rax
  8018c1:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8018c7:	75 db                	jne    8018a4 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  8018c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ce:	c3                   	ret
            return envs[i].env_id;
  8018cf:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8018d3:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8018d7:	48 c1 e2 04          	shl    $0x4,%rdx
  8018db:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8018e2:	00 00 00 
  8018e5:	48 01 d0             	add    %rdx,%rax
  8018e8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8018ee:	c3                   	ret

00000000008018ef <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  8018ef:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8018f3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8018fa:	ff ff ff 
  8018fd:	48 01 f8             	add    %rdi,%rax
  801900:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801904:	c3                   	ret

0000000000801905 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801905:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801909:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801910:	ff ff ff 
  801913:	48 01 f8             	add    %rdi,%rax
  801916:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80191a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801920:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801924:	c3                   	ret

0000000000801925 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801925:	f3 0f 1e fa          	endbr64
  801929:	55                   	push   %rbp
  80192a:	48 89 e5             	mov    %rsp,%rbp
  80192d:	41 57                	push   %r15
  80192f:	41 56                	push   %r14
  801931:	41 55                	push   %r13
  801933:	41 54                	push   %r12
  801935:	53                   	push   %rbx
  801936:	48 83 ec 08          	sub    $0x8,%rsp
  80193a:	49 89 ff             	mov    %rdi,%r15
  80193d:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801942:	49 bd 84 2a 80 00 00 	movabs $0x802a84,%r13
  801949:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80194c:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801952:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801955:	48 89 df             	mov    %rbx,%rdi
  801958:	41 ff d5             	call   *%r13
  80195b:	83 e0 04             	and    $0x4,%eax
  80195e:	74 17                	je     801977 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801960:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801967:	4c 39 f3             	cmp    %r14,%rbx
  80196a:	75 e6                	jne    801952 <fd_alloc+0x2d>
  80196c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801972:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801977:	4d 89 27             	mov    %r12,(%r15)
}
  80197a:	48 83 c4 08          	add    $0x8,%rsp
  80197e:	5b                   	pop    %rbx
  80197f:	41 5c                	pop    %r12
  801981:	41 5d                	pop    %r13
  801983:	41 5e                	pop    %r14
  801985:	41 5f                	pop    %r15
  801987:	5d                   	pop    %rbp
  801988:	c3                   	ret

0000000000801989 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801989:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  80198d:	83 ff 1f             	cmp    $0x1f,%edi
  801990:	77 39                	ja     8019cb <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801992:	55                   	push   %rbp
  801993:	48 89 e5             	mov    %rsp,%rbp
  801996:	41 54                	push   %r12
  801998:	53                   	push   %rbx
  801999:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80199c:	48 63 df             	movslq %edi,%rbx
  80199f:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8019a6:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8019aa:	48 89 df             	mov    %rbx,%rdi
  8019ad:	48 b8 84 2a 80 00 00 	movabs $0x802a84,%rax
  8019b4:	00 00 00 
  8019b7:	ff d0                	call   *%rax
  8019b9:	a8 04                	test   $0x4,%al
  8019bb:	74 14                	je     8019d1 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8019bd:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8019c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c6:	5b                   	pop    %rbx
  8019c7:	41 5c                	pop    %r12
  8019c9:	5d                   	pop    %rbp
  8019ca:	c3                   	ret
        return -E_INVAL;
  8019cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019d0:	c3                   	ret
        return -E_INVAL;
  8019d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d6:	eb ee                	jmp    8019c6 <fd_lookup+0x3d>

00000000008019d8 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8019d8:	f3 0f 1e fa          	endbr64
  8019dc:	55                   	push   %rbp
  8019dd:	48 89 e5             	mov    %rsp,%rbp
  8019e0:	41 54                	push   %r12
  8019e2:	53                   	push   %rbx
  8019e3:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  8019e6:	48 b8 80 47 80 00 00 	movabs $0x804780,%rax
  8019ed:	00 00 00 
  8019f0:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  8019f7:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8019fa:	39 3b                	cmp    %edi,(%rbx)
  8019fc:	74 47                	je     801a45 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  8019fe:	48 83 c0 08          	add    $0x8,%rax
  801a02:	48 8b 18             	mov    (%rax),%rbx
  801a05:	48 85 db             	test   %rbx,%rbx
  801a08:	75 f0                	jne    8019fa <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a0a:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801a11:	00 00 00 
  801a14:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a1a:	89 fa                	mov    %edi,%edx
  801a1c:	48 bf a0 46 80 00 00 	movabs $0x8046a0,%rdi
  801a23:	00 00 00 
  801a26:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2b:	48 b9 c8 02 80 00 00 	movabs $0x8002c8,%rcx
  801a32:	00 00 00 
  801a35:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801a37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801a3c:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801a40:	5b                   	pop    %rbx
  801a41:	41 5c                	pop    %r12
  801a43:	5d                   	pop    %rbp
  801a44:	c3                   	ret
            return 0;
  801a45:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4a:	eb f0                	jmp    801a3c <dev_lookup+0x64>

0000000000801a4c <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801a4c:	f3 0f 1e fa          	endbr64
  801a50:	55                   	push   %rbp
  801a51:	48 89 e5             	mov    %rsp,%rbp
  801a54:	41 55                	push   %r13
  801a56:	41 54                	push   %r12
  801a58:	53                   	push   %rbx
  801a59:	48 83 ec 18          	sub    $0x18,%rsp
  801a5d:	48 89 fb             	mov    %rdi,%rbx
  801a60:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a63:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801a6a:	ff ff ff 
  801a6d:	48 01 df             	add    %rbx,%rdi
  801a70:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801a74:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a78:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  801a7f:	00 00 00 
  801a82:	ff d0                	call   *%rax
  801a84:	41 89 c5             	mov    %eax,%r13d
  801a87:	85 c0                	test   %eax,%eax
  801a89:	78 06                	js     801a91 <fd_close+0x45>
  801a8b:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801a8f:	74 1a                	je     801aab <fd_close+0x5f>
        return (must_exist ? res : 0);
  801a91:	45 84 e4             	test   %r12b,%r12b
  801a94:	b8 00 00 00 00       	mov    $0x0,%eax
  801a99:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801a9d:	44 89 e8             	mov    %r13d,%eax
  801aa0:	48 83 c4 18          	add    $0x18,%rsp
  801aa4:	5b                   	pop    %rbx
  801aa5:	41 5c                	pop    %r12
  801aa7:	41 5d                	pop    %r13
  801aa9:	5d                   	pop    %rbp
  801aaa:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801aab:	8b 3b                	mov    (%rbx),%edi
  801aad:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ab1:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801ab8:	00 00 00 
  801abb:	ff d0                	call   *%rax
  801abd:	41 89 c5             	mov    %eax,%r13d
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	78 1b                	js     801adf <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801ac4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ac8:	48 8b 40 20          	mov    0x20(%rax),%rax
  801acc:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801ad2:	48 85 c0             	test   %rax,%rax
  801ad5:	74 08                	je     801adf <fd_close+0x93>
  801ad7:	48 89 df             	mov    %rbx,%rdi
  801ada:	ff d0                	call   *%rax
  801adc:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801adf:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ae4:	48 89 de             	mov    %rbx,%rsi
  801ae7:	bf 00 00 00 00       	mov    $0x0,%edi
  801aec:	48 b8 56 13 80 00 00 	movabs $0x801356,%rax
  801af3:	00 00 00 
  801af6:	ff d0                	call   *%rax
    return res;
  801af8:	eb a3                	jmp    801a9d <fd_close+0x51>

0000000000801afa <close>:

int
close(int fdnum) {
  801afa:	f3 0f 1e fa          	endbr64
  801afe:	55                   	push   %rbp
  801aff:	48 89 e5             	mov    %rsp,%rbp
  801b02:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801b06:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b0a:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  801b11:	00 00 00 
  801b14:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b16:	85 c0                	test   %eax,%eax
  801b18:	78 15                	js     801b2f <close+0x35>

    return fd_close(fd, 1);
  801b1a:	be 01 00 00 00       	mov    $0x1,%esi
  801b1f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801b23:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  801b2a:	00 00 00 
  801b2d:	ff d0                	call   *%rax
}
  801b2f:	c9                   	leave
  801b30:	c3                   	ret

0000000000801b31 <close_all>:

void
close_all(void) {
  801b31:	f3 0f 1e fa          	endbr64
  801b35:	55                   	push   %rbp
  801b36:	48 89 e5             	mov    %rsp,%rbp
  801b39:	41 54                	push   %r12
  801b3b:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801b3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b41:	49 bc fa 1a 80 00 00 	movabs $0x801afa,%r12
  801b48:	00 00 00 
  801b4b:	89 df                	mov    %ebx,%edi
  801b4d:	41 ff d4             	call   *%r12
  801b50:	83 c3 01             	add    $0x1,%ebx
  801b53:	83 fb 20             	cmp    $0x20,%ebx
  801b56:	75 f3                	jne    801b4b <close_all+0x1a>
}
  801b58:	5b                   	pop    %rbx
  801b59:	41 5c                	pop    %r12
  801b5b:	5d                   	pop    %rbp
  801b5c:	c3                   	ret

0000000000801b5d <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801b5d:	f3 0f 1e fa          	endbr64
  801b61:	55                   	push   %rbp
  801b62:	48 89 e5             	mov    %rsp,%rbp
  801b65:	41 57                	push   %r15
  801b67:	41 56                	push   %r14
  801b69:	41 55                	push   %r13
  801b6b:	41 54                	push   %r12
  801b6d:	53                   	push   %rbx
  801b6e:	48 83 ec 18          	sub    $0x18,%rsp
  801b72:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801b75:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801b79:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  801b80:	00 00 00 
  801b83:	ff d0                	call   *%rax
  801b85:	89 c3                	mov    %eax,%ebx
  801b87:	85 c0                	test   %eax,%eax
  801b89:	0f 88 b8 00 00 00    	js     801c47 <dup+0xea>
    close(newfdnum);
  801b8f:	44 89 e7             	mov    %r12d,%edi
  801b92:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  801b99:	00 00 00 
  801b9c:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801b9e:	4d 63 ec             	movslq %r12d,%r13
  801ba1:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801ba8:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801bac:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801bb0:	4c 89 ff             	mov    %r15,%rdi
  801bb3:	49 be 05 19 80 00 00 	movabs $0x801905,%r14
  801bba:	00 00 00 
  801bbd:	41 ff d6             	call   *%r14
  801bc0:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801bc3:	4c 89 ef             	mov    %r13,%rdi
  801bc6:	41 ff d6             	call   *%r14
  801bc9:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801bcc:	48 89 df             	mov    %rbx,%rdi
  801bcf:	48 b8 84 2a 80 00 00 	movabs $0x802a84,%rax
  801bd6:	00 00 00 
  801bd9:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801bdb:	a8 04                	test   $0x4,%al
  801bdd:	74 2b                	je     801c0a <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801bdf:	41 89 c1             	mov    %eax,%r9d
  801be2:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801be8:	4c 89 f1             	mov    %r14,%rcx
  801beb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf0:	48 89 de             	mov    %rbx,%rsi
  801bf3:	bf 00 00 00 00       	mov    $0x0,%edi
  801bf8:	48 b8 81 12 80 00 00 	movabs $0x801281,%rax
  801bff:	00 00 00 
  801c02:	ff d0                	call   *%rax
  801c04:	89 c3                	mov    %eax,%ebx
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 4e                	js     801c58 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801c0a:	4c 89 ff             	mov    %r15,%rdi
  801c0d:	48 b8 84 2a 80 00 00 	movabs $0x802a84,%rax
  801c14:	00 00 00 
  801c17:	ff d0                	call   *%rax
  801c19:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801c1c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c22:	4c 89 e9             	mov    %r13,%rcx
  801c25:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2a:	4c 89 fe             	mov    %r15,%rsi
  801c2d:	bf 00 00 00 00       	mov    $0x0,%edi
  801c32:	48 b8 81 12 80 00 00 	movabs $0x801281,%rax
  801c39:	00 00 00 
  801c3c:	ff d0                	call   *%rax
  801c3e:	89 c3                	mov    %eax,%ebx
  801c40:	85 c0                	test   %eax,%eax
  801c42:	78 14                	js     801c58 <dup+0xfb>

    return newfdnum;
  801c44:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801c47:	89 d8                	mov    %ebx,%eax
  801c49:	48 83 c4 18          	add    $0x18,%rsp
  801c4d:	5b                   	pop    %rbx
  801c4e:	41 5c                	pop    %r12
  801c50:	41 5d                	pop    %r13
  801c52:	41 5e                	pop    %r14
  801c54:	41 5f                	pop    %r15
  801c56:	5d                   	pop    %rbp
  801c57:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801c58:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c5d:	4c 89 ee             	mov    %r13,%rsi
  801c60:	bf 00 00 00 00       	mov    $0x0,%edi
  801c65:	49 bc 56 13 80 00 00 	movabs $0x801356,%r12
  801c6c:	00 00 00 
  801c6f:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801c72:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c77:	4c 89 f6             	mov    %r14,%rsi
  801c7a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c7f:	41 ff d4             	call   *%r12
    return res;
  801c82:	eb c3                	jmp    801c47 <dup+0xea>

0000000000801c84 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801c84:	f3 0f 1e fa          	endbr64
  801c88:	55                   	push   %rbp
  801c89:	48 89 e5             	mov    %rsp,%rbp
  801c8c:	41 56                	push   %r14
  801c8e:	41 55                	push   %r13
  801c90:	41 54                	push   %r12
  801c92:	53                   	push   %rbx
  801c93:	48 83 ec 10          	sub    $0x10,%rsp
  801c97:	89 fb                	mov    %edi,%ebx
  801c99:	49 89 f4             	mov    %rsi,%r12
  801c9c:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c9f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ca3:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  801caa:	00 00 00 
  801cad:	ff d0                	call   *%rax
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	78 4c                	js     801cff <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cb3:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801cb7:	41 8b 3e             	mov    (%r14),%edi
  801cba:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801cbe:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801cc5:	00 00 00 
  801cc8:	ff d0                	call   *%rax
  801cca:	85 c0                	test   %eax,%eax
  801ccc:	78 35                	js     801d03 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801cce:	41 8b 46 08          	mov    0x8(%r14),%eax
  801cd2:	83 e0 03             	and    $0x3,%eax
  801cd5:	83 f8 01             	cmp    $0x1,%eax
  801cd8:	74 2d                	je     801d07 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801cda:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cde:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ce2:	48 85 c0             	test   %rax,%rax
  801ce5:	74 56                	je     801d3d <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801ce7:	4c 89 ea             	mov    %r13,%rdx
  801cea:	4c 89 e6             	mov    %r12,%rsi
  801ced:	4c 89 f7             	mov    %r14,%rdi
  801cf0:	ff d0                	call   *%rax
}
  801cf2:	48 83 c4 10          	add    $0x10,%rsp
  801cf6:	5b                   	pop    %rbx
  801cf7:	41 5c                	pop    %r12
  801cf9:	41 5d                	pop    %r13
  801cfb:	41 5e                	pop    %r14
  801cfd:	5d                   	pop    %rbp
  801cfe:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cff:	48 98                	cltq
  801d01:	eb ef                	jmp    801cf2 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d03:	48 98                	cltq
  801d05:	eb eb                	jmp    801cf2 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d07:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801d0e:	00 00 00 
  801d11:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d17:	89 da                	mov    %ebx,%edx
  801d19:	48 bf 0b 42 80 00 00 	movabs $0x80420b,%rdi
  801d20:	00 00 00 
  801d23:	b8 00 00 00 00       	mov    $0x0,%eax
  801d28:	48 b9 c8 02 80 00 00 	movabs $0x8002c8,%rcx
  801d2f:	00 00 00 
  801d32:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d34:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801d3b:	eb b5                	jmp    801cf2 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801d3d:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801d44:	eb ac                	jmp    801cf2 <read+0x6e>

0000000000801d46 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801d46:	f3 0f 1e fa          	endbr64
  801d4a:	55                   	push   %rbp
  801d4b:	48 89 e5             	mov    %rsp,%rbp
  801d4e:	41 57                	push   %r15
  801d50:	41 56                	push   %r14
  801d52:	41 55                	push   %r13
  801d54:	41 54                	push   %r12
  801d56:	53                   	push   %rbx
  801d57:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801d5b:	48 85 d2             	test   %rdx,%rdx
  801d5e:	74 54                	je     801db4 <readn+0x6e>
  801d60:	41 89 fd             	mov    %edi,%r13d
  801d63:	49 89 f6             	mov    %rsi,%r14
  801d66:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801d69:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801d6e:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801d73:	49 bf 84 1c 80 00 00 	movabs $0x801c84,%r15
  801d7a:	00 00 00 
  801d7d:	4c 89 e2             	mov    %r12,%rdx
  801d80:	48 29 f2             	sub    %rsi,%rdx
  801d83:	4c 01 f6             	add    %r14,%rsi
  801d86:	44 89 ef             	mov    %r13d,%edi
  801d89:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801d8c:	85 c0                	test   %eax,%eax
  801d8e:	78 20                	js     801db0 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801d90:	01 c3                	add    %eax,%ebx
  801d92:	85 c0                	test   %eax,%eax
  801d94:	74 08                	je     801d9e <readn+0x58>
  801d96:	48 63 f3             	movslq %ebx,%rsi
  801d99:	4c 39 e6             	cmp    %r12,%rsi
  801d9c:	72 df                	jb     801d7d <readn+0x37>
    }
    return res;
  801d9e:	48 63 c3             	movslq %ebx,%rax
}
  801da1:	48 83 c4 08          	add    $0x8,%rsp
  801da5:	5b                   	pop    %rbx
  801da6:	41 5c                	pop    %r12
  801da8:	41 5d                	pop    %r13
  801daa:	41 5e                	pop    %r14
  801dac:	41 5f                	pop    %r15
  801dae:	5d                   	pop    %rbp
  801daf:	c3                   	ret
        if (inc < 0) return inc;
  801db0:	48 98                	cltq
  801db2:	eb ed                	jmp    801da1 <readn+0x5b>
    int inc = 1, res = 0;
  801db4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801db9:	eb e3                	jmp    801d9e <readn+0x58>

0000000000801dbb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801dbb:	f3 0f 1e fa          	endbr64
  801dbf:	55                   	push   %rbp
  801dc0:	48 89 e5             	mov    %rsp,%rbp
  801dc3:	41 56                	push   %r14
  801dc5:	41 55                	push   %r13
  801dc7:	41 54                	push   %r12
  801dc9:	53                   	push   %rbx
  801dca:	48 83 ec 10          	sub    $0x10,%rsp
  801dce:	89 fb                	mov    %edi,%ebx
  801dd0:	49 89 f4             	mov    %rsi,%r12
  801dd3:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dd6:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801dda:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  801de1:	00 00 00 
  801de4:	ff d0                	call   *%rax
  801de6:	85 c0                	test   %eax,%eax
  801de8:	78 47                	js     801e31 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801dea:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801dee:	41 8b 3e             	mov    (%r14),%edi
  801df1:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801df5:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801dfc:	00 00 00 
  801dff:	ff d0                	call   *%rax
  801e01:	85 c0                	test   %eax,%eax
  801e03:	78 30                	js     801e35 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e05:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801e0a:	74 2d                	je     801e39 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801e0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e10:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e14:	48 85 c0             	test   %rax,%rax
  801e17:	74 56                	je     801e6f <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801e19:	4c 89 ea             	mov    %r13,%rdx
  801e1c:	4c 89 e6             	mov    %r12,%rsi
  801e1f:	4c 89 f7             	mov    %r14,%rdi
  801e22:	ff d0                	call   *%rax
}
  801e24:	48 83 c4 10          	add    $0x10,%rsp
  801e28:	5b                   	pop    %rbx
  801e29:	41 5c                	pop    %r12
  801e2b:	41 5d                	pop    %r13
  801e2d:	41 5e                	pop    %r14
  801e2f:	5d                   	pop    %rbp
  801e30:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e31:	48 98                	cltq
  801e33:	eb ef                	jmp    801e24 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e35:	48 98                	cltq
  801e37:	eb eb                	jmp    801e24 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801e39:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801e40:	00 00 00 
  801e43:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e49:	89 da                	mov    %ebx,%edx
  801e4b:	48 bf 27 42 80 00 00 	movabs $0x804227,%rdi
  801e52:	00 00 00 
  801e55:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5a:	48 b9 c8 02 80 00 00 	movabs $0x8002c8,%rcx
  801e61:	00 00 00 
  801e64:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e66:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801e6d:	eb b5                	jmp    801e24 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801e6f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801e76:	eb ac                	jmp    801e24 <write+0x69>

0000000000801e78 <seek>:

int
seek(int fdnum, off_t offset) {
  801e78:	f3 0f 1e fa          	endbr64
  801e7c:	55                   	push   %rbp
  801e7d:	48 89 e5             	mov    %rsp,%rbp
  801e80:	53                   	push   %rbx
  801e81:	48 83 ec 18          	sub    $0x18,%rsp
  801e85:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e87:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801e8b:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  801e92:	00 00 00 
  801e95:	ff d0                	call   *%rax
  801e97:	85 c0                	test   %eax,%eax
  801e99:	78 0c                	js     801ea7 <seek+0x2f>

    fd->fd_offset = offset;
  801e9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e9f:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ea2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801eab:	c9                   	leave
  801eac:	c3                   	ret

0000000000801ead <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801ead:	f3 0f 1e fa          	endbr64
  801eb1:	55                   	push   %rbp
  801eb2:	48 89 e5             	mov    %rsp,%rbp
  801eb5:	41 55                	push   %r13
  801eb7:	41 54                	push   %r12
  801eb9:	53                   	push   %rbx
  801eba:	48 83 ec 18          	sub    $0x18,%rsp
  801ebe:	89 fb                	mov    %edi,%ebx
  801ec0:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ec3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ec7:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  801ece:	00 00 00 
  801ed1:	ff d0                	call   *%rax
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	78 38                	js     801f0f <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ed7:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801edb:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801edf:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ee3:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801eea:	00 00 00 
  801eed:	ff d0                	call   *%rax
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	78 1c                	js     801f0f <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ef3:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801ef8:	74 20                	je     801f1a <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801efa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801efe:	48 8b 40 30          	mov    0x30(%rax),%rax
  801f02:	48 85 c0             	test   %rax,%rax
  801f05:	74 47                	je     801f4e <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801f07:	44 89 e6             	mov    %r12d,%esi
  801f0a:	4c 89 ef             	mov    %r13,%rdi
  801f0d:	ff d0                	call   *%rax
}
  801f0f:	48 83 c4 18          	add    $0x18,%rsp
  801f13:	5b                   	pop    %rbx
  801f14:	41 5c                	pop    %r12
  801f16:	41 5d                	pop    %r13
  801f18:	5d                   	pop    %rbp
  801f19:	c3                   	ret
                thisenv->env_id, fdnum);
  801f1a:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801f21:	00 00 00 
  801f24:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801f2a:	89 da                	mov    %ebx,%edx
  801f2c:	48 bf c0 46 80 00 00 	movabs $0x8046c0,%rdi
  801f33:	00 00 00 
  801f36:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3b:	48 b9 c8 02 80 00 00 	movabs $0x8002c8,%rcx
  801f42:	00 00 00 
  801f45:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f4c:	eb c1                	jmp    801f0f <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f4e:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f53:	eb ba                	jmp    801f0f <ftruncate+0x62>

0000000000801f55 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801f55:	f3 0f 1e fa          	endbr64
  801f59:	55                   	push   %rbp
  801f5a:	48 89 e5             	mov    %rsp,%rbp
  801f5d:	41 54                	push   %r12
  801f5f:	53                   	push   %rbx
  801f60:	48 83 ec 10          	sub    $0x10,%rsp
  801f64:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f67:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f6b:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  801f72:	00 00 00 
  801f75:	ff d0                	call   *%rax
  801f77:	85 c0                	test   %eax,%eax
  801f79:	78 4e                	js     801fc9 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f7b:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801f7f:	41 8b 3c 24          	mov    (%r12),%edi
  801f83:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801f87:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801f8e:	00 00 00 
  801f91:	ff d0                	call   *%rax
  801f93:	85 c0                	test   %eax,%eax
  801f95:	78 32                	js     801fc9 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801f97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f9b:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801fa0:	74 30                	je     801fd2 <fstat+0x7d>

    stat->st_name[0] = 0;
  801fa2:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801fa5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801fac:	00 00 00 
    stat->st_isdir = 0;
  801faf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801fb6:	00 00 00 
    stat->st_dev = dev;
  801fb9:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801fc0:	48 89 de             	mov    %rbx,%rsi
  801fc3:	4c 89 e7             	mov    %r12,%rdi
  801fc6:	ff 50 28             	call   *0x28(%rax)
}
  801fc9:	48 83 c4 10          	add    $0x10,%rsp
  801fcd:	5b                   	pop    %rbx
  801fce:	41 5c                	pop    %r12
  801fd0:	5d                   	pop    %rbp
  801fd1:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801fd2:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801fd7:	eb f0                	jmp    801fc9 <fstat+0x74>

0000000000801fd9 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801fd9:	f3 0f 1e fa          	endbr64
  801fdd:	55                   	push   %rbp
  801fde:	48 89 e5             	mov    %rsp,%rbp
  801fe1:	41 54                	push   %r12
  801fe3:	53                   	push   %rbx
  801fe4:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801fe7:	be 00 00 00 00       	mov    $0x0,%esi
  801fec:	48 b8 ba 22 80 00 00 	movabs $0x8022ba,%rax
  801ff3:	00 00 00 
  801ff6:	ff d0                	call   *%rax
  801ff8:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	78 25                	js     802023 <stat+0x4a>

    int res = fstat(fd, stat);
  801ffe:	4c 89 e6             	mov    %r12,%rsi
  802001:	89 c7                	mov    %eax,%edi
  802003:	48 b8 55 1f 80 00 00 	movabs $0x801f55,%rax
  80200a:	00 00 00 
  80200d:	ff d0                	call   *%rax
  80200f:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802012:	89 df                	mov    %ebx,%edi
  802014:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  80201b:	00 00 00 
  80201e:	ff d0                	call   *%rax

    return res;
  802020:	44 89 e3             	mov    %r12d,%ebx
}
  802023:	89 d8                	mov    %ebx,%eax
  802025:	5b                   	pop    %rbx
  802026:	41 5c                	pop    %r12
  802028:	5d                   	pop    %rbp
  802029:	c3                   	ret

000000000080202a <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  80202a:	f3 0f 1e fa          	endbr64
  80202e:	55                   	push   %rbp
  80202f:	48 89 e5             	mov    %rsp,%rbp
  802032:	41 54                	push   %r12
  802034:	53                   	push   %rbx
  802035:	48 83 ec 10          	sub    $0x10,%rsp
  802039:	41 89 fc             	mov    %edi,%r12d
  80203c:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80203f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802046:	00 00 00 
  802049:	83 38 00             	cmpl   $0x0,(%rax)
  80204c:	74 6e                	je     8020bc <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  80204e:	bf 03 00 00 00       	mov    $0x3,%edi
  802053:	48 b8 91 18 80 00 00 	movabs $0x801891,%rax
  80205a:	00 00 00 
  80205d:	ff d0                	call   *%rax
  80205f:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802066:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802068:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  80206e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802073:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80207a:	00 00 00 
  80207d:	44 89 e6             	mov    %r12d,%esi
  802080:	89 c7                	mov    %eax,%edi
  802082:	48 b8 cf 17 80 00 00 	movabs $0x8017cf,%rax
  802089:	00 00 00 
  80208c:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  80208e:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802095:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802096:	b9 00 00 00 00       	mov    $0x0,%ecx
  80209b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80209f:	48 89 de             	mov    %rbx,%rsi
  8020a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a7:	48 b8 36 17 80 00 00 	movabs $0x801736,%rax
  8020ae:	00 00 00 
  8020b1:	ff d0                	call   *%rax
}
  8020b3:	48 83 c4 10          	add    $0x10,%rsp
  8020b7:	5b                   	pop    %rbx
  8020b8:	41 5c                	pop    %r12
  8020ba:	5d                   	pop    %rbp
  8020bb:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8020bc:	bf 03 00 00 00       	mov    $0x3,%edi
  8020c1:	48 b8 91 18 80 00 00 	movabs $0x801891,%rax
  8020c8:	00 00 00 
  8020cb:	ff d0                	call   *%rax
  8020cd:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  8020d4:	00 00 
  8020d6:	e9 73 ff ff ff       	jmp    80204e <fsipc+0x24>

00000000008020db <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8020db:	f3 0f 1e fa          	endbr64
  8020df:	55                   	push   %rbp
  8020e0:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8020e3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8020ea:	00 00 00 
  8020ed:	8b 57 0c             	mov    0xc(%rdi),%edx
  8020f0:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8020f2:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8020f5:	be 00 00 00 00       	mov    $0x0,%esi
  8020fa:	bf 02 00 00 00       	mov    $0x2,%edi
  8020ff:	48 b8 2a 20 80 00 00 	movabs $0x80202a,%rax
  802106:	00 00 00 
  802109:	ff d0                	call   *%rax
}
  80210b:	5d                   	pop    %rbp
  80210c:	c3                   	ret

000000000080210d <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80210d:	f3 0f 1e fa          	endbr64
  802111:	55                   	push   %rbp
  802112:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802115:	8b 47 0c             	mov    0xc(%rdi),%eax
  802118:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80211f:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802121:	be 00 00 00 00       	mov    $0x0,%esi
  802126:	bf 06 00 00 00       	mov    $0x6,%edi
  80212b:	48 b8 2a 20 80 00 00 	movabs $0x80202a,%rax
  802132:	00 00 00 
  802135:	ff d0                	call   *%rax
}
  802137:	5d                   	pop    %rbp
  802138:	c3                   	ret

0000000000802139 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802139:	f3 0f 1e fa          	endbr64
  80213d:	55                   	push   %rbp
  80213e:	48 89 e5             	mov    %rsp,%rbp
  802141:	41 54                	push   %r12
  802143:	53                   	push   %rbx
  802144:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802147:	8b 47 0c             	mov    0xc(%rdi),%eax
  80214a:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802151:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802153:	be 00 00 00 00       	mov    $0x0,%esi
  802158:	bf 05 00 00 00       	mov    $0x5,%edi
  80215d:	48 b8 2a 20 80 00 00 	movabs $0x80202a,%rax
  802164:	00 00 00 
  802167:	ff d0                	call   *%rax
    if (res < 0) return res;
  802169:	85 c0                	test   %eax,%eax
  80216b:	78 3d                	js     8021aa <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80216d:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  802174:	00 00 00 
  802177:	4c 89 e6             	mov    %r12,%rsi
  80217a:	48 89 df             	mov    %rbx,%rdi
  80217d:	48 b8 11 0c 80 00 00 	movabs $0x800c11,%rax
  802184:	00 00 00 
  802187:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  802189:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  802190:	00 
  802191:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802197:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  80219e:	00 
  80219f:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8021a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021aa:	5b                   	pop    %rbx
  8021ab:	41 5c                	pop    %r12
  8021ad:	5d                   	pop    %rbp
  8021ae:	c3                   	ret

00000000008021af <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8021af:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  8021b3:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  8021ba:	77 41                	ja     8021fd <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8021bc:	55                   	push   %rbp
  8021bd:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8021c0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8021c7:	00 00 00 
  8021ca:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8021cd:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  8021cf:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  8021d3:	48 8d 78 10          	lea    0x10(%rax),%rdi
  8021d7:	48 b8 2c 0e 80 00 00 	movabs $0x800e2c,%rax
  8021de:	00 00 00 
  8021e1:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  8021e3:	be 00 00 00 00       	mov    $0x0,%esi
  8021e8:	bf 04 00 00 00       	mov    $0x4,%edi
  8021ed:	48 b8 2a 20 80 00 00 	movabs $0x80202a,%rax
  8021f4:	00 00 00 
  8021f7:	ff d0                	call   *%rax
  8021f9:	48 98                	cltq
}
  8021fb:	5d                   	pop    %rbp
  8021fc:	c3                   	ret
        return -E_INVAL;
  8021fd:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802204:	c3                   	ret

0000000000802205 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802205:	f3 0f 1e fa          	endbr64
  802209:	55                   	push   %rbp
  80220a:	48 89 e5             	mov    %rsp,%rbp
  80220d:	41 55                	push   %r13
  80220f:	41 54                	push   %r12
  802211:	53                   	push   %rbx
  802212:	48 83 ec 08          	sub    $0x8,%rsp
  802216:	49 89 f4             	mov    %rsi,%r12
  802219:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80221c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802223:	00 00 00 
  802226:	8b 57 0c             	mov    0xc(%rdi),%edx
  802229:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  80222b:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  80222f:	be 00 00 00 00       	mov    $0x0,%esi
  802234:	bf 03 00 00 00       	mov    $0x3,%edi
  802239:	48 b8 2a 20 80 00 00 	movabs $0x80202a,%rax
  802240:	00 00 00 
  802243:	ff d0                	call   *%rax
  802245:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802248:	4d 85 ed             	test   %r13,%r13
  80224b:	78 2a                	js     802277 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  80224d:	4c 89 ea             	mov    %r13,%rdx
  802250:	4c 39 eb             	cmp    %r13,%rbx
  802253:	72 30                	jb     802285 <devfile_read+0x80>
  802255:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  80225c:	7f 27                	jg     802285 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  80225e:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802265:	00 00 00 
  802268:	4c 89 e7             	mov    %r12,%rdi
  80226b:	48 b8 2c 0e 80 00 00 	movabs $0x800e2c,%rax
  802272:	00 00 00 
  802275:	ff d0                	call   *%rax
}
  802277:	4c 89 e8             	mov    %r13,%rax
  80227a:	48 83 c4 08          	add    $0x8,%rsp
  80227e:	5b                   	pop    %rbx
  80227f:	41 5c                	pop    %r12
  802281:	41 5d                	pop    %r13
  802283:	5d                   	pop    %rbp
  802284:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  802285:	48 b9 44 42 80 00 00 	movabs $0x804244,%rcx
  80228c:	00 00 00 
  80228f:	48 ba 61 42 80 00 00 	movabs $0x804261,%rdx
  802296:	00 00 00 
  802299:	be 7b 00 00 00       	mov    $0x7b,%esi
  80229e:	48 bf 76 42 80 00 00 	movabs $0x804276,%rdi
  8022a5:	00 00 00 
  8022a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ad:	49 b8 56 2e 80 00 00 	movabs $0x802e56,%r8
  8022b4:	00 00 00 
  8022b7:	41 ff d0             	call   *%r8

00000000008022ba <open>:
open(const char *path, int mode) {
  8022ba:	f3 0f 1e fa          	endbr64
  8022be:	55                   	push   %rbp
  8022bf:	48 89 e5             	mov    %rsp,%rbp
  8022c2:	41 55                	push   %r13
  8022c4:	41 54                	push   %r12
  8022c6:	53                   	push   %rbx
  8022c7:	48 83 ec 18          	sub    $0x18,%rsp
  8022cb:	49 89 fc             	mov    %rdi,%r12
  8022ce:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8022d1:	48 b8 cc 0b 80 00 00 	movabs $0x800bcc,%rax
  8022d8:	00 00 00 
  8022db:	ff d0                	call   *%rax
  8022dd:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8022e3:	0f 87 8a 00 00 00    	ja     802373 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8022e9:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8022ed:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  8022f4:	00 00 00 
  8022f7:	ff d0                	call   *%rax
  8022f9:	89 c3                	mov    %eax,%ebx
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	78 50                	js     80234f <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  8022ff:	4c 89 e6             	mov    %r12,%rsi
  802302:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  802309:	00 00 00 
  80230c:	48 89 df             	mov    %rbx,%rdi
  80230f:	48 b8 11 0c 80 00 00 	movabs $0x800c11,%rax
  802316:	00 00 00 
  802319:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80231b:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802322:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802326:	bf 01 00 00 00       	mov    $0x1,%edi
  80232b:	48 b8 2a 20 80 00 00 	movabs $0x80202a,%rax
  802332:	00 00 00 
  802335:	ff d0                	call   *%rax
  802337:	89 c3                	mov    %eax,%ebx
  802339:	85 c0                	test   %eax,%eax
  80233b:	78 1f                	js     80235c <open+0xa2>
    return fd2num(fd);
  80233d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802341:	48 b8 ef 18 80 00 00 	movabs $0x8018ef,%rax
  802348:	00 00 00 
  80234b:	ff d0                	call   *%rax
  80234d:	89 c3                	mov    %eax,%ebx
}
  80234f:	89 d8                	mov    %ebx,%eax
  802351:	48 83 c4 18          	add    $0x18,%rsp
  802355:	5b                   	pop    %rbx
  802356:	41 5c                	pop    %r12
  802358:	41 5d                	pop    %r13
  80235a:	5d                   	pop    %rbp
  80235b:	c3                   	ret
        fd_close(fd, 0);
  80235c:	be 00 00 00 00       	mov    $0x0,%esi
  802361:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802365:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  80236c:	00 00 00 
  80236f:	ff d0                	call   *%rax
        return res;
  802371:	eb dc                	jmp    80234f <open+0x95>
        return -E_BAD_PATH;
  802373:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802378:	eb d5                	jmp    80234f <open+0x95>

000000000080237a <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80237a:	f3 0f 1e fa          	endbr64
  80237e:	55                   	push   %rbp
  80237f:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802382:	be 00 00 00 00       	mov    $0x0,%esi
  802387:	bf 08 00 00 00       	mov    $0x8,%edi
  80238c:	48 b8 2a 20 80 00 00 	movabs $0x80202a,%rax
  802393:	00 00 00 
  802396:	ff d0                	call   *%rax
}
  802398:	5d                   	pop    %rbp
  802399:	c3                   	ret

000000000080239a <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80239a:	f3 0f 1e fa          	endbr64
  80239e:	55                   	push   %rbp
  80239f:	48 89 e5             	mov    %rsp,%rbp
  8023a2:	41 54                	push   %r12
  8023a4:	53                   	push   %rbx
  8023a5:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8023a8:	48 b8 05 19 80 00 00 	movabs $0x801905,%rax
  8023af:	00 00 00 
  8023b2:	ff d0                	call   *%rax
  8023b4:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8023b7:	48 be 81 42 80 00 00 	movabs $0x804281,%rsi
  8023be:	00 00 00 
  8023c1:	48 89 df             	mov    %rbx,%rdi
  8023c4:	48 b8 11 0c 80 00 00 	movabs $0x800c11,%rax
  8023cb:	00 00 00 
  8023ce:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8023d0:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8023d5:	41 2b 04 24          	sub    (%r12),%eax
  8023d9:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8023df:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8023e6:	00 00 00 
    stat->st_dev = &devpipe;
  8023e9:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  8023f0:	00 00 00 
  8023f3:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8023fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ff:	5b                   	pop    %rbx
  802400:	41 5c                	pop    %r12
  802402:	5d                   	pop    %rbp
  802403:	c3                   	ret

0000000000802404 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802404:	f3 0f 1e fa          	endbr64
  802408:	55                   	push   %rbp
  802409:	48 89 e5             	mov    %rsp,%rbp
  80240c:	41 54                	push   %r12
  80240e:	53                   	push   %rbx
  80240f:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802412:	ba 00 10 00 00       	mov    $0x1000,%edx
  802417:	48 89 fe             	mov    %rdi,%rsi
  80241a:	bf 00 00 00 00       	mov    $0x0,%edi
  80241f:	49 bc 56 13 80 00 00 	movabs $0x801356,%r12
  802426:	00 00 00 
  802429:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80242c:	48 89 df             	mov    %rbx,%rdi
  80242f:	48 b8 05 19 80 00 00 	movabs $0x801905,%rax
  802436:	00 00 00 
  802439:	ff d0                	call   *%rax
  80243b:	48 89 c6             	mov    %rax,%rsi
  80243e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802443:	bf 00 00 00 00       	mov    $0x0,%edi
  802448:	41 ff d4             	call   *%r12
}
  80244b:	5b                   	pop    %rbx
  80244c:	41 5c                	pop    %r12
  80244e:	5d                   	pop    %rbp
  80244f:	c3                   	ret

0000000000802450 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802450:	f3 0f 1e fa          	endbr64
  802454:	55                   	push   %rbp
  802455:	48 89 e5             	mov    %rsp,%rbp
  802458:	41 57                	push   %r15
  80245a:	41 56                	push   %r14
  80245c:	41 55                	push   %r13
  80245e:	41 54                	push   %r12
  802460:	53                   	push   %rbx
  802461:	48 83 ec 18          	sub    $0x18,%rsp
  802465:	49 89 fc             	mov    %rdi,%r12
  802468:	49 89 f5             	mov    %rsi,%r13
  80246b:	49 89 d7             	mov    %rdx,%r15
  80246e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802472:	48 b8 05 19 80 00 00 	movabs $0x801905,%rax
  802479:	00 00 00 
  80247c:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80247e:	4d 85 ff             	test   %r15,%r15
  802481:	0f 84 af 00 00 00    	je     802536 <devpipe_write+0xe6>
  802487:	48 89 c3             	mov    %rax,%rbx
  80248a:	4c 89 f8             	mov    %r15,%rax
  80248d:	4d 89 ef             	mov    %r13,%r15
  802490:	4c 01 e8             	add    %r13,%rax
  802493:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802497:	49 bd e6 11 80 00 00 	movabs $0x8011e6,%r13
  80249e:	00 00 00 
            sys_yield();
  8024a1:	49 be 7b 11 80 00 00 	movabs $0x80117b,%r14
  8024a8:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8024ab:	8b 73 04             	mov    0x4(%rbx),%esi
  8024ae:	48 63 ce             	movslq %esi,%rcx
  8024b1:	48 63 03             	movslq (%rbx),%rax
  8024b4:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8024ba:	48 39 c1             	cmp    %rax,%rcx
  8024bd:	72 2e                	jb     8024ed <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024bf:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024c4:	48 89 da             	mov    %rbx,%rdx
  8024c7:	be 00 10 00 00       	mov    $0x1000,%esi
  8024cc:	4c 89 e7             	mov    %r12,%rdi
  8024cf:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	74 66                	je     80253c <devpipe_write+0xec>
            sys_yield();
  8024d6:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8024d9:	8b 73 04             	mov    0x4(%rbx),%esi
  8024dc:	48 63 ce             	movslq %esi,%rcx
  8024df:	48 63 03             	movslq (%rbx),%rax
  8024e2:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8024e8:	48 39 c1             	cmp    %rax,%rcx
  8024eb:	73 d2                	jae    8024bf <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024ed:	41 0f b6 3f          	movzbl (%r15),%edi
  8024f1:	48 89 ca             	mov    %rcx,%rdx
  8024f4:	48 c1 ea 03          	shr    $0x3,%rdx
  8024f8:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8024ff:	08 10 20 
  802502:	48 f7 e2             	mul    %rdx
  802505:	48 c1 ea 06          	shr    $0x6,%rdx
  802509:	48 89 d0             	mov    %rdx,%rax
  80250c:	48 c1 e0 09          	shl    $0x9,%rax
  802510:	48 29 d0             	sub    %rdx,%rax
  802513:	48 c1 e0 03          	shl    $0x3,%rax
  802517:	48 29 c1             	sub    %rax,%rcx
  80251a:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80251f:	83 c6 01             	add    $0x1,%esi
  802522:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802525:	49 83 c7 01          	add    $0x1,%r15
  802529:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80252d:	49 39 c7             	cmp    %rax,%r15
  802530:	0f 85 75 ff ff ff    	jne    8024ab <devpipe_write+0x5b>
    return n;
  802536:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80253a:	eb 05                	jmp    802541 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  80253c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802541:	48 83 c4 18          	add    $0x18,%rsp
  802545:	5b                   	pop    %rbx
  802546:	41 5c                	pop    %r12
  802548:	41 5d                	pop    %r13
  80254a:	41 5e                	pop    %r14
  80254c:	41 5f                	pop    %r15
  80254e:	5d                   	pop    %rbp
  80254f:	c3                   	ret

0000000000802550 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802550:	f3 0f 1e fa          	endbr64
  802554:	55                   	push   %rbp
  802555:	48 89 e5             	mov    %rsp,%rbp
  802558:	41 57                	push   %r15
  80255a:	41 56                	push   %r14
  80255c:	41 55                	push   %r13
  80255e:	41 54                	push   %r12
  802560:	53                   	push   %rbx
  802561:	48 83 ec 18          	sub    $0x18,%rsp
  802565:	49 89 fc             	mov    %rdi,%r12
  802568:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80256c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802570:	48 b8 05 19 80 00 00 	movabs $0x801905,%rax
  802577:	00 00 00 
  80257a:	ff d0                	call   *%rax
  80257c:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80257f:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802585:	49 bd e6 11 80 00 00 	movabs $0x8011e6,%r13
  80258c:	00 00 00 
            sys_yield();
  80258f:	49 be 7b 11 80 00 00 	movabs $0x80117b,%r14
  802596:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802599:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80259e:	74 7d                	je     80261d <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8025a0:	8b 03                	mov    (%rbx),%eax
  8025a2:	3b 43 04             	cmp    0x4(%rbx),%eax
  8025a5:	75 26                	jne    8025cd <devpipe_read+0x7d>
            if (i > 0) return i;
  8025a7:	4d 85 ff             	test   %r15,%r15
  8025aa:	75 77                	jne    802623 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025ac:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8025b1:	48 89 da             	mov    %rbx,%rdx
  8025b4:	be 00 10 00 00       	mov    $0x1000,%esi
  8025b9:	4c 89 e7             	mov    %r12,%rdi
  8025bc:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	74 72                	je     802635 <devpipe_read+0xe5>
            sys_yield();
  8025c3:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8025c6:	8b 03                	mov    (%rbx),%eax
  8025c8:	3b 43 04             	cmp    0x4(%rbx),%eax
  8025cb:	74 df                	je     8025ac <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025cd:	48 63 c8             	movslq %eax,%rcx
  8025d0:	48 89 ca             	mov    %rcx,%rdx
  8025d3:	48 c1 ea 03          	shr    $0x3,%rdx
  8025d7:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8025de:	08 10 20 
  8025e1:	48 89 d0             	mov    %rdx,%rax
  8025e4:	48 f7 e6             	mul    %rsi
  8025e7:	48 c1 ea 06          	shr    $0x6,%rdx
  8025eb:	48 89 d0             	mov    %rdx,%rax
  8025ee:	48 c1 e0 09          	shl    $0x9,%rax
  8025f2:	48 29 d0             	sub    %rdx,%rax
  8025f5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8025fc:	00 
  8025fd:	48 89 c8             	mov    %rcx,%rax
  802600:	48 29 d0             	sub    %rdx,%rax
  802603:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802608:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80260c:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802610:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802613:	49 83 c7 01          	add    $0x1,%r15
  802617:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80261b:	75 83                	jne    8025a0 <devpipe_read+0x50>
    return n;
  80261d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802621:	eb 03                	jmp    802626 <devpipe_read+0xd6>
            if (i > 0) return i;
  802623:	4c 89 f8             	mov    %r15,%rax
}
  802626:	48 83 c4 18          	add    $0x18,%rsp
  80262a:	5b                   	pop    %rbx
  80262b:	41 5c                	pop    %r12
  80262d:	41 5d                	pop    %r13
  80262f:	41 5e                	pop    %r14
  802631:	41 5f                	pop    %r15
  802633:	5d                   	pop    %rbp
  802634:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802635:	b8 00 00 00 00       	mov    $0x0,%eax
  80263a:	eb ea                	jmp    802626 <devpipe_read+0xd6>

000000000080263c <pipe>:
pipe(int pfd[2]) {
  80263c:	f3 0f 1e fa          	endbr64
  802640:	55                   	push   %rbp
  802641:	48 89 e5             	mov    %rsp,%rbp
  802644:	41 55                	push   %r13
  802646:	41 54                	push   %r12
  802648:	53                   	push   %rbx
  802649:	48 83 ec 18          	sub    $0x18,%rsp
  80264d:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802650:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802654:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  80265b:	00 00 00 
  80265e:	ff d0                	call   *%rax
  802660:	89 c3                	mov    %eax,%ebx
  802662:	85 c0                	test   %eax,%eax
  802664:	0f 88 a0 01 00 00    	js     80280a <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80266a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80266f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802674:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802678:	bf 00 00 00 00       	mov    $0x0,%edi
  80267d:	48 b8 16 12 80 00 00 	movabs $0x801216,%rax
  802684:	00 00 00 
  802687:	ff d0                	call   *%rax
  802689:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80268b:	85 c0                	test   %eax,%eax
  80268d:	0f 88 77 01 00 00    	js     80280a <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802693:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802697:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  80269e:	00 00 00 
  8026a1:	ff d0                	call   *%rax
  8026a3:	89 c3                	mov    %eax,%ebx
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	0f 88 43 01 00 00    	js     8027f0 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8026ad:	b9 46 00 00 00       	mov    $0x46,%ecx
  8026b2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026b7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c0:	48 b8 16 12 80 00 00 	movabs $0x801216,%rax
  8026c7:	00 00 00 
  8026ca:	ff d0                	call   *%rax
  8026cc:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8026ce:	85 c0                	test   %eax,%eax
  8026d0:	0f 88 1a 01 00 00    	js     8027f0 <pipe+0x1b4>
    va = fd2data(fd0);
  8026d6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8026da:	48 b8 05 19 80 00 00 	movabs $0x801905,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	call   *%rax
  8026e6:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8026e9:	b9 46 00 00 00       	mov    $0x46,%ecx
  8026ee:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026f3:	48 89 c6             	mov    %rax,%rsi
  8026f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8026fb:	48 b8 16 12 80 00 00 	movabs $0x801216,%rax
  802702:	00 00 00 
  802705:	ff d0                	call   *%rax
  802707:	89 c3                	mov    %eax,%ebx
  802709:	85 c0                	test   %eax,%eax
  80270b:	0f 88 c5 00 00 00    	js     8027d6 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802711:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802715:	48 b8 05 19 80 00 00 	movabs $0x801905,%rax
  80271c:	00 00 00 
  80271f:	ff d0                	call   *%rax
  802721:	48 89 c1             	mov    %rax,%rcx
  802724:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80272a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802730:	ba 00 00 00 00       	mov    $0x0,%edx
  802735:	4c 89 ee             	mov    %r13,%rsi
  802738:	bf 00 00 00 00       	mov    $0x0,%edi
  80273d:	48 b8 81 12 80 00 00 	movabs $0x801281,%rax
  802744:	00 00 00 
  802747:	ff d0                	call   *%rax
  802749:	89 c3                	mov    %eax,%ebx
  80274b:	85 c0                	test   %eax,%eax
  80274d:	78 6e                	js     8027bd <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80274f:	be 00 10 00 00       	mov    $0x1000,%esi
  802754:	4c 89 ef             	mov    %r13,%rdi
  802757:	48 b8 b0 11 80 00 00 	movabs $0x8011b0,%rax
  80275e:	00 00 00 
  802761:	ff d0                	call   *%rax
  802763:	83 f8 02             	cmp    $0x2,%eax
  802766:	0f 85 ab 00 00 00    	jne    802817 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  80276c:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  802773:	00 00 
  802775:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802779:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80277b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80277f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802786:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80278a:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80278c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802790:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802797:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80279b:	48 bb ef 18 80 00 00 	movabs $0x8018ef,%rbx
  8027a2:	00 00 00 
  8027a5:	ff d3                	call   *%rbx
  8027a7:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8027ab:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8027af:	ff d3                	call   *%rbx
  8027b1:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8027b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027bb:	eb 4d                	jmp    80280a <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8027bd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027c2:	4c 89 ee             	mov    %r13,%rsi
  8027c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ca:	48 b8 56 13 80 00 00 	movabs $0x801356,%rax
  8027d1:	00 00 00 
  8027d4:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8027d6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027db:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027df:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e4:	48 b8 56 13 80 00 00 	movabs $0x801356,%rax
  8027eb:	00 00 00 
  8027ee:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8027f0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027f5:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8027f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8027fe:	48 b8 56 13 80 00 00 	movabs $0x801356,%rax
  802805:	00 00 00 
  802808:	ff d0                	call   *%rax
}
  80280a:	89 d8                	mov    %ebx,%eax
  80280c:	48 83 c4 18          	add    $0x18,%rsp
  802810:	5b                   	pop    %rbx
  802811:	41 5c                	pop    %r12
  802813:	41 5d                	pop    %r13
  802815:	5d                   	pop    %rbp
  802816:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802817:	48 b9 e8 46 80 00 00 	movabs $0x8046e8,%rcx
  80281e:	00 00 00 
  802821:	48 ba 61 42 80 00 00 	movabs $0x804261,%rdx
  802828:	00 00 00 
  80282b:	be 2e 00 00 00       	mov    $0x2e,%esi
  802830:	48 bf 88 42 80 00 00 	movabs $0x804288,%rdi
  802837:	00 00 00 
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	49 b8 56 2e 80 00 00 	movabs $0x802e56,%r8
  802846:	00 00 00 
  802849:	41 ff d0             	call   *%r8

000000000080284c <pipeisclosed>:
pipeisclosed(int fdnum) {
  80284c:	f3 0f 1e fa          	endbr64
  802850:	55                   	push   %rbp
  802851:	48 89 e5             	mov    %rsp,%rbp
  802854:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802858:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80285c:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  802863:	00 00 00 
  802866:	ff d0                	call   *%rax
    if (res < 0) return res;
  802868:	85 c0                	test   %eax,%eax
  80286a:	78 35                	js     8028a1 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80286c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802870:	48 b8 05 19 80 00 00 	movabs $0x801905,%rax
  802877:	00 00 00 
  80287a:	ff d0                	call   *%rax
  80287c:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80287f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802884:	be 00 10 00 00       	mov    $0x1000,%esi
  802889:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80288d:	48 b8 e6 11 80 00 00 	movabs $0x8011e6,%rax
  802894:	00 00 00 
  802897:	ff d0                	call   *%rax
  802899:	85 c0                	test   %eax,%eax
  80289b:	0f 94 c0             	sete   %al
  80289e:	0f b6 c0             	movzbl %al,%eax
}
  8028a1:	c9                   	leave
  8028a2:	c3                   	ret

00000000008028a3 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8028a3:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8028a7:	48 89 f8             	mov    %rdi,%rax
  8028aa:	48 c1 e8 27          	shr    $0x27,%rax
  8028ae:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8028b5:	7f 00 00 
  8028b8:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028bc:	f6 c2 01             	test   $0x1,%dl
  8028bf:	74 6d                	je     80292e <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8028c1:	48 89 f8             	mov    %rdi,%rax
  8028c4:	48 c1 e8 1e          	shr    $0x1e,%rax
  8028c8:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8028cf:	7f 00 00 
  8028d2:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028d6:	f6 c2 01             	test   $0x1,%dl
  8028d9:	74 62                	je     80293d <get_uvpt_entry+0x9a>
  8028db:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8028e2:	7f 00 00 
  8028e5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028e9:	f6 c2 80             	test   $0x80,%dl
  8028ec:	75 4f                	jne    80293d <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8028ee:	48 89 f8             	mov    %rdi,%rax
  8028f1:	48 c1 e8 15          	shr    $0x15,%rax
  8028f5:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8028fc:	7f 00 00 
  8028ff:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802903:	f6 c2 01             	test   $0x1,%dl
  802906:	74 44                	je     80294c <get_uvpt_entry+0xa9>
  802908:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80290f:	7f 00 00 
  802912:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802916:	f6 c2 80             	test   $0x80,%dl
  802919:	75 31                	jne    80294c <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80291b:	48 c1 ef 0c          	shr    $0xc,%rdi
  80291f:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802926:	7f 00 00 
  802929:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80292d:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80292e:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802935:	7f 00 00 
  802938:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80293c:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80293d:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802944:	7f 00 00 
  802947:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80294b:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80294c:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802953:	7f 00 00 
  802956:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80295a:	c3                   	ret

000000000080295b <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  80295b:	f3 0f 1e fa          	endbr64
  80295f:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802962:	48 89 f9             	mov    %rdi,%rcx
  802965:	48 c1 e9 27          	shr    $0x27,%rcx
  802969:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802970:	7f 00 00 
  802973:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802977:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  80297e:	f6 c1 01             	test   $0x1,%cl
  802981:	0f 84 b2 00 00 00    	je     802a39 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802987:	48 89 f9             	mov    %rdi,%rcx
  80298a:	48 c1 e9 1e          	shr    $0x1e,%rcx
  80298e:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802995:	7f 00 00 
  802998:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80299c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8029a3:	40 f6 c6 01          	test   $0x1,%sil
  8029a7:	0f 84 8c 00 00 00    	je     802a39 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8029ad:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8029b4:	7f 00 00 
  8029b7:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8029bb:	a8 80                	test   $0x80,%al
  8029bd:	75 7b                	jne    802a3a <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8029bf:	48 89 f9             	mov    %rdi,%rcx
  8029c2:	48 c1 e9 15          	shr    $0x15,%rcx
  8029c6:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8029cd:	7f 00 00 
  8029d0:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8029d4:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  8029db:	40 f6 c6 01          	test   $0x1,%sil
  8029df:	74 58                	je     802a39 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  8029e1:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8029e8:	7f 00 00 
  8029eb:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8029ef:	a8 80                	test   $0x80,%al
  8029f1:	75 6c                	jne    802a5f <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  8029f3:	48 89 f9             	mov    %rdi,%rcx
  8029f6:	48 c1 e9 0c          	shr    $0xc,%rcx
  8029fa:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a01:	7f 00 00 
  802a04:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a08:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802a0f:	40 f6 c6 01          	test   $0x1,%sil
  802a13:	74 24                	je     802a39 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802a15:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a1c:	7f 00 00 
  802a1f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a23:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802a2a:	ff ff 7f 
  802a2d:	48 21 c8             	and    %rcx,%rax
  802a30:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802a36:	48 09 d0             	or     %rdx,%rax
}
  802a39:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802a3a:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802a41:	7f 00 00 
  802a44:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a48:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802a4f:	ff ff 7f 
  802a52:	48 21 c8             	and    %rcx,%rax
  802a55:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802a5b:	48 01 d0             	add    %rdx,%rax
  802a5e:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802a5f:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802a66:	7f 00 00 
  802a69:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a6d:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802a74:	ff ff 7f 
  802a77:	48 21 c8             	and    %rcx,%rax
  802a7a:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802a80:	48 01 d0             	add    %rdx,%rax
  802a83:	c3                   	ret

0000000000802a84 <get_prot>:

int
get_prot(void *va) {
  802a84:	f3 0f 1e fa          	endbr64
  802a88:	55                   	push   %rbp
  802a89:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802a8c:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  802a93:	00 00 00 
  802a96:	ff d0                	call   *%rax
  802a98:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802a9b:	83 e0 01             	and    $0x1,%eax
  802a9e:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802aa1:	89 d1                	mov    %edx,%ecx
  802aa3:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802aa9:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802aab:	89 c1                	mov    %eax,%ecx
  802aad:	83 c9 02             	or     $0x2,%ecx
  802ab0:	f6 c2 02             	test   $0x2,%dl
  802ab3:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802ab6:	89 c1                	mov    %eax,%ecx
  802ab8:	83 c9 01             	or     $0x1,%ecx
  802abb:	48 85 d2             	test   %rdx,%rdx
  802abe:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802ac1:	89 c1                	mov    %eax,%ecx
  802ac3:	83 c9 40             	or     $0x40,%ecx
  802ac6:	f6 c6 04             	test   $0x4,%dh
  802ac9:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802acc:	5d                   	pop    %rbp
  802acd:	c3                   	ret

0000000000802ace <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802ace:	f3 0f 1e fa          	endbr64
  802ad2:	55                   	push   %rbp
  802ad3:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802ad6:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  802add:	00 00 00 
  802ae0:	ff d0                	call   *%rax
    return pte & PTE_D;
  802ae2:	48 c1 e8 06          	shr    $0x6,%rax
  802ae6:	83 e0 01             	and    $0x1,%eax
}
  802ae9:	5d                   	pop    %rbp
  802aea:	c3                   	ret

0000000000802aeb <is_page_present>:

bool
is_page_present(void *va) {
  802aeb:	f3 0f 1e fa          	endbr64
  802aef:	55                   	push   %rbp
  802af0:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802af3:	48 b8 a3 28 80 00 00 	movabs $0x8028a3,%rax
  802afa:	00 00 00 
  802afd:	ff d0                	call   *%rax
  802aff:	83 e0 01             	and    $0x1,%eax
}
  802b02:	5d                   	pop    %rbp
  802b03:	c3                   	ret

0000000000802b04 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802b04:	f3 0f 1e fa          	endbr64
  802b08:	55                   	push   %rbp
  802b09:	48 89 e5             	mov    %rsp,%rbp
  802b0c:	41 57                	push   %r15
  802b0e:	41 56                	push   %r14
  802b10:	41 55                	push   %r13
  802b12:	41 54                	push   %r12
  802b14:	53                   	push   %rbx
  802b15:	48 83 ec 18          	sub    $0x18,%rsp
  802b19:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802b1d:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802b21:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802b26:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802b2d:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802b30:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802b37:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802b3a:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802b41:	00 00 00 
  802b44:	eb 73                	jmp    802bb9 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802b46:	48 89 d8             	mov    %rbx,%rax
  802b49:	48 c1 e8 15          	shr    $0x15,%rax
  802b4d:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802b54:	7f 00 00 
  802b57:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802b5b:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802b61:	f6 c2 01             	test   $0x1,%dl
  802b64:	74 4b                	je     802bb1 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802b66:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802b6a:	f6 c2 80             	test   $0x80,%dl
  802b6d:	74 11                	je     802b80 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802b6f:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802b73:	f6 c4 04             	test   $0x4,%ah
  802b76:	74 39                	je     802bb1 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802b78:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802b7e:	eb 20                	jmp    802ba0 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802b80:	48 89 da             	mov    %rbx,%rdx
  802b83:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b87:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802b8e:	7f 00 00 
  802b91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802b95:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802b9b:	f6 c4 04             	test   $0x4,%ah
  802b9e:	74 11                	je     802bb1 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802ba0:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802ba4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ba8:	48 89 df             	mov    %rbx,%rdi
  802bab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802baf:	ff d0                	call   *%rax
    next:
        va += size;
  802bb1:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802bb4:	49 39 df             	cmp    %rbx,%r15
  802bb7:	72 3e                	jb     802bf7 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802bb9:	49 8b 06             	mov    (%r14),%rax
  802bbc:	a8 01                	test   $0x1,%al
  802bbe:	74 37                	je     802bf7 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802bc0:	48 89 d8             	mov    %rbx,%rax
  802bc3:	48 c1 e8 1e          	shr    $0x1e,%rax
  802bc7:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802bcc:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802bd2:	f6 c2 01             	test   $0x1,%dl
  802bd5:	74 da                	je     802bb1 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802bd7:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802bdc:	f6 c2 80             	test   $0x80,%dl
  802bdf:	0f 84 61 ff ff ff    	je     802b46 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802be5:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802bea:	f6 c4 04             	test   $0x4,%ah
  802bed:	74 c2                	je     802bb1 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802bef:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802bf5:	eb a9                	jmp    802ba0 <foreach_shared_region+0x9c>
    }
    return res;
}
  802bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bfc:	48 83 c4 18          	add    $0x18,%rsp
  802c00:	5b                   	pop    %rbx
  802c01:	41 5c                	pop    %r12
  802c03:	41 5d                	pop    %r13
  802c05:	41 5e                	pop    %r14
  802c07:	41 5f                	pop    %r15
  802c09:	5d                   	pop    %rbp
  802c0a:	c3                   	ret

0000000000802c0b <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802c0b:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c14:	c3                   	ret

0000000000802c15 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802c15:	f3 0f 1e fa          	endbr64
  802c19:	55                   	push   %rbp
  802c1a:	48 89 e5             	mov    %rsp,%rbp
  802c1d:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802c20:	48 be 98 42 80 00 00 	movabs $0x804298,%rsi
  802c27:	00 00 00 
  802c2a:	48 b8 11 0c 80 00 00 	movabs $0x800c11,%rax
  802c31:	00 00 00 
  802c34:	ff d0                	call   *%rax
    return 0;
}
  802c36:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3b:	5d                   	pop    %rbp
  802c3c:	c3                   	ret

0000000000802c3d <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802c3d:	f3 0f 1e fa          	endbr64
  802c41:	55                   	push   %rbp
  802c42:	48 89 e5             	mov    %rsp,%rbp
  802c45:	41 57                	push   %r15
  802c47:	41 56                	push   %r14
  802c49:	41 55                	push   %r13
  802c4b:	41 54                	push   %r12
  802c4d:	53                   	push   %rbx
  802c4e:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802c55:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802c5c:	48 85 d2             	test   %rdx,%rdx
  802c5f:	74 7a                	je     802cdb <devcons_write+0x9e>
  802c61:	49 89 d6             	mov    %rdx,%r14
  802c64:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802c6a:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802c6f:	49 bf 2c 0e 80 00 00 	movabs $0x800e2c,%r15
  802c76:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802c79:	4c 89 f3             	mov    %r14,%rbx
  802c7c:	48 29 f3             	sub    %rsi,%rbx
  802c7f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802c84:	48 39 c3             	cmp    %rax,%rbx
  802c87:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802c8b:	4c 63 eb             	movslq %ebx,%r13
  802c8e:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802c95:	48 01 c6             	add    %rax,%rsi
  802c98:	4c 89 ea             	mov    %r13,%rdx
  802c9b:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802ca2:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802ca5:	4c 89 ee             	mov    %r13,%rsi
  802ca8:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802caf:	48 b8 71 10 80 00 00 	movabs $0x801071,%rax
  802cb6:	00 00 00 
  802cb9:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802cbb:	41 01 dc             	add    %ebx,%r12d
  802cbe:	49 63 f4             	movslq %r12d,%rsi
  802cc1:	4c 39 f6             	cmp    %r14,%rsi
  802cc4:	72 b3                	jb     802c79 <devcons_write+0x3c>
    return res;
  802cc6:	49 63 c4             	movslq %r12d,%rax
}
  802cc9:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802cd0:	5b                   	pop    %rbx
  802cd1:	41 5c                	pop    %r12
  802cd3:	41 5d                	pop    %r13
  802cd5:	41 5e                	pop    %r14
  802cd7:	41 5f                	pop    %r15
  802cd9:	5d                   	pop    %rbp
  802cda:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802cdb:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802ce1:	eb e3                	jmp    802cc6 <devcons_write+0x89>

0000000000802ce3 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802ce3:	f3 0f 1e fa          	endbr64
  802ce7:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802cea:	ba 00 00 00 00       	mov    $0x0,%edx
  802cef:	48 85 c0             	test   %rax,%rax
  802cf2:	74 55                	je     802d49 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802cf4:	55                   	push   %rbp
  802cf5:	48 89 e5             	mov    %rsp,%rbp
  802cf8:	41 55                	push   %r13
  802cfa:	41 54                	push   %r12
  802cfc:	53                   	push   %rbx
  802cfd:	48 83 ec 08          	sub    $0x8,%rsp
  802d01:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802d04:	48 bb a2 10 80 00 00 	movabs $0x8010a2,%rbx
  802d0b:	00 00 00 
  802d0e:	49 bc 7b 11 80 00 00 	movabs $0x80117b,%r12
  802d15:	00 00 00 
  802d18:	eb 03                	jmp    802d1d <devcons_read+0x3a>
  802d1a:	41 ff d4             	call   *%r12
  802d1d:	ff d3                	call   *%rbx
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 f7                	je     802d1a <devcons_read+0x37>
    if (c < 0) return c;
  802d23:	48 63 d0             	movslq %eax,%rdx
  802d26:	78 13                	js     802d3b <devcons_read+0x58>
    if (c == 0x04) return 0;
  802d28:	ba 00 00 00 00       	mov    $0x0,%edx
  802d2d:	83 f8 04             	cmp    $0x4,%eax
  802d30:	74 09                	je     802d3b <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802d32:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802d36:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802d3b:	48 89 d0             	mov    %rdx,%rax
  802d3e:	48 83 c4 08          	add    $0x8,%rsp
  802d42:	5b                   	pop    %rbx
  802d43:	41 5c                	pop    %r12
  802d45:	41 5d                	pop    %r13
  802d47:	5d                   	pop    %rbp
  802d48:	c3                   	ret
  802d49:	48 89 d0             	mov    %rdx,%rax
  802d4c:	c3                   	ret

0000000000802d4d <cputchar>:
cputchar(int ch) {
  802d4d:	f3 0f 1e fa          	endbr64
  802d51:	55                   	push   %rbp
  802d52:	48 89 e5             	mov    %rsp,%rbp
  802d55:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802d59:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802d5d:	be 01 00 00 00       	mov    $0x1,%esi
  802d62:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802d66:	48 b8 71 10 80 00 00 	movabs $0x801071,%rax
  802d6d:	00 00 00 
  802d70:	ff d0                	call   *%rax
}
  802d72:	c9                   	leave
  802d73:	c3                   	ret

0000000000802d74 <getchar>:
getchar(void) {
  802d74:	f3 0f 1e fa          	endbr64
  802d78:	55                   	push   %rbp
  802d79:	48 89 e5             	mov    %rsp,%rbp
  802d7c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802d80:	ba 01 00 00 00       	mov    $0x1,%edx
  802d85:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802d89:	bf 00 00 00 00       	mov    $0x0,%edi
  802d8e:	48 b8 84 1c 80 00 00 	movabs $0x801c84,%rax
  802d95:	00 00 00 
  802d98:	ff d0                	call   *%rax
  802d9a:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	78 06                	js     802da6 <getchar+0x32>
  802da0:	74 08                	je     802daa <getchar+0x36>
  802da2:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802da6:	89 d0                	mov    %edx,%eax
  802da8:	c9                   	leave
  802da9:	c3                   	ret
    return res < 0 ? res : res ? c :
  802daa:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802daf:	eb f5                	jmp    802da6 <getchar+0x32>

0000000000802db1 <iscons>:
iscons(int fdnum) {
  802db1:	f3 0f 1e fa          	endbr64
  802db5:	55                   	push   %rbp
  802db6:	48 89 e5             	mov    %rsp,%rbp
  802db9:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802dbd:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802dc1:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  802dc8:	00 00 00 
  802dcb:	ff d0                	call   *%rax
    if (res < 0) return res;
  802dcd:	85 c0                	test   %eax,%eax
  802dcf:	78 18                	js     802de9 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802dd1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802dd5:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802ddc:	00 00 00 
  802ddf:	8b 00                	mov    (%rax),%eax
  802de1:	39 02                	cmp    %eax,(%rdx)
  802de3:	0f 94 c0             	sete   %al
  802de6:	0f b6 c0             	movzbl %al,%eax
}
  802de9:	c9                   	leave
  802dea:	c3                   	ret

0000000000802deb <opencons>:
opencons(void) {
  802deb:	f3 0f 1e fa          	endbr64
  802def:	55                   	push   %rbp
  802df0:	48 89 e5             	mov    %rsp,%rbp
  802df3:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802df7:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802dfb:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  802e02:	00 00 00 
  802e05:	ff d0                	call   *%rax
  802e07:	85 c0                	test   %eax,%eax
  802e09:	78 49                	js     802e54 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802e0b:	b9 46 00 00 00       	mov    $0x46,%ecx
  802e10:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e15:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802e19:	bf 00 00 00 00       	mov    $0x0,%edi
  802e1e:	48 b8 16 12 80 00 00 	movabs $0x801216,%rax
  802e25:	00 00 00 
  802e28:	ff d0                	call   *%rax
  802e2a:	85 c0                	test   %eax,%eax
  802e2c:	78 26                	js     802e54 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802e2e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e32:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802e39:	00 00 
  802e3b:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802e3d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802e41:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802e48:	48 b8 ef 18 80 00 00 	movabs $0x8018ef,%rax
  802e4f:	00 00 00 
  802e52:	ff d0                	call   *%rax
}
  802e54:	c9                   	leave
  802e55:	c3                   	ret

0000000000802e56 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802e56:	f3 0f 1e fa          	endbr64
  802e5a:	55                   	push   %rbp
  802e5b:	48 89 e5             	mov    %rsp,%rbp
  802e5e:	41 56                	push   %r14
  802e60:	41 55                	push   %r13
  802e62:	41 54                	push   %r12
  802e64:	53                   	push   %rbx
  802e65:	48 83 ec 50          	sub    $0x50,%rsp
  802e69:	49 89 fc             	mov    %rdi,%r12
  802e6c:	41 89 f5             	mov    %esi,%r13d
  802e6f:	48 89 d3             	mov    %rdx,%rbx
  802e72:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802e76:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802e7a:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802e7e:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802e85:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e89:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802e8d:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802e91:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802e95:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  802e9c:	00 00 00 
  802e9f:	4c 8b 30             	mov    (%rax),%r14
  802ea2:	48 b8 46 11 80 00 00 	movabs $0x801146,%rax
  802ea9:	00 00 00 
  802eac:	ff d0                	call   *%rax
  802eae:	89 c6                	mov    %eax,%esi
  802eb0:	45 89 e8             	mov    %r13d,%r8d
  802eb3:	4c 89 e1             	mov    %r12,%rcx
  802eb6:	4c 89 f2             	mov    %r14,%rdx
  802eb9:	48 bf 10 47 80 00 00 	movabs $0x804710,%rdi
  802ec0:	00 00 00 
  802ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec8:	49 bc c8 02 80 00 00 	movabs $0x8002c8,%r12
  802ecf:	00 00 00 
  802ed2:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802ed5:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802ed9:	48 89 df             	mov    %rbx,%rdi
  802edc:	48 b8 60 02 80 00 00 	movabs $0x800260,%rax
  802ee3:	00 00 00 
  802ee6:	ff d0                	call   *%rax
    cprintf("\n");
  802ee8:	48 bf 25 42 80 00 00 	movabs $0x804225,%rdi
  802eef:	00 00 00 
  802ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef7:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802efa:	cc                   	int3
  802efb:	eb fd                	jmp    802efa <_panic+0xa4>

0000000000802efd <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  802efd:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  802f00:	48 b8 83 2f 80 00 00 	movabs $0x802f83,%rax
  802f07:	00 00 00 
    call *%rax
  802f0a:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  802f0c:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  802f0f:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802f16:	00 
    movq UTRAP_RSP(%rsp), %rsp
  802f17:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  802f1e:	00 
    pushq %rbx
  802f1f:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  802f20:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  802f27:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  802f2a:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  802f2e:	4c 8b 3c 24          	mov    (%rsp),%r15
  802f32:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802f37:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802f3c:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802f41:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802f46:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802f4b:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802f50:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802f55:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802f5a:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802f5f:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802f64:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802f69:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802f6e:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802f73:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802f78:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  802f7c:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  802f80:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  802f81:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  802f82:	c3                   	ret

0000000000802f83 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  802f83:	f3 0f 1e fa          	endbr64
  802f87:	55                   	push   %rbp
  802f88:	48 89 e5             	mov    %rsp,%rbp
  802f8b:	41 56                	push   %r14
  802f8d:	41 55                	push   %r13
  802f8f:	41 54                	push   %r12
  802f91:	53                   	push   %rbx
  802f92:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  802f95:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  802f9c:	00 00 00 
  802f9f:	48 83 38 00          	cmpq   $0x0,(%rax)
  802fa3:	74 27                	je     802fcc <_handle_vectored_pagefault+0x49>
  802fa5:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  802faa:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  802fb1:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  802fb4:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  802fb7:	4c 89 e7             	mov    %r12,%rdi
  802fba:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  802fbf:	84 c0                	test   %al,%al
  802fc1:	75 45                	jne    803008 <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  802fc3:	48 83 c3 01          	add    $0x1,%rbx
  802fc7:	49 3b 1e             	cmp    (%r14),%rbx
  802fca:	72 eb                	jb     802fb7 <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  802fcc:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  802fd3:	00 
  802fd4:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  802fd9:	4d 8b 04 24          	mov    (%r12),%r8
  802fdd:	48 ba 38 47 80 00 00 	movabs $0x804738,%rdx
  802fe4:	00 00 00 
  802fe7:	be 1d 00 00 00       	mov    $0x1d,%esi
  802fec:	48 bf a4 42 80 00 00 	movabs $0x8042a4,%rdi
  802ff3:	00 00 00 
  802ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffb:	49 ba 56 2e 80 00 00 	movabs $0x802e56,%r10
  803002:	00 00 00 
  803005:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  803008:	5b                   	pop    %rbx
  803009:	41 5c                	pop    %r12
  80300b:	41 5d                	pop    %r13
  80300d:	41 5e                	pop    %r14
  80300f:	5d                   	pop    %rbp
  803010:	c3                   	ret

0000000000803011 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  803011:	f3 0f 1e fa          	endbr64
  803015:	55                   	push   %rbp
  803016:	48 89 e5             	mov    %rsp,%rbp
  803019:	53                   	push   %rbx
  80301a:	48 83 ec 08          	sub    $0x8,%rsp
  80301e:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  803021:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803028:	00 00 00 
  80302b:	80 38 00             	cmpb   $0x0,(%rax)
  80302e:	0f 84 84 00 00 00    	je     8030b8 <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  803034:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  80303b:	00 00 00 
  80303e:	48 8b 10             	mov    (%rax),%rdx
  803041:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  803046:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  80304d:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803050:	48 85 d2             	test   %rdx,%rdx
  803053:	74 19                	je     80306e <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  803055:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  803059:	0f 84 e8 00 00 00    	je     803147 <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80305f:	48 83 c0 01          	add    $0x1,%rax
  803063:	48 39 d0             	cmp    %rdx,%rax
  803066:	75 ed                	jne    803055 <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  803068:	48 83 fa 08          	cmp    $0x8,%rdx
  80306c:	74 1c                	je     80308a <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  80306e:	48 8d 42 01          	lea    0x1(%rdx),%rax
  803072:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  803079:	00 00 00 
  80307c:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803083:	00 00 00 
  803086:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80308a:	48 b8 46 11 80 00 00 	movabs $0x801146,%rax
  803091:	00 00 00 
  803094:	ff d0                	call   *%rax
  803096:	89 c7                	mov    %eax,%edi
  803098:	48 be fd 2e 80 00 00 	movabs $0x802efd,%rsi
  80309f:	00 00 00 
  8030a2:	48 b8 9b 14 80 00 00 	movabs $0x80149b,%rax
  8030a9:	00 00 00 
  8030ac:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8030ae:	85 c0                	test   %eax,%eax
  8030b0:	78 68                	js     80311a <add_pgfault_handler+0x109>
    return res;
}
  8030b2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8030b6:	c9                   	leave
  8030b7:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  8030b8:	48 b8 46 11 80 00 00 	movabs $0x801146,%rax
  8030bf:	00 00 00 
  8030c2:	ff d0                	call   *%rax
  8030c4:	89 c7                	mov    %eax,%edi
  8030c6:	b9 06 00 00 00       	mov    $0x6,%ecx
  8030cb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030d0:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  8030d7:	00 00 00 
  8030da:	48 b8 16 12 80 00 00 	movabs $0x801216,%rax
  8030e1:	00 00 00 
  8030e4:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  8030e6:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  8030ed:	00 00 00 
  8030f0:	48 8b 02             	mov    (%rdx),%rax
  8030f3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8030f7:	48 89 0a             	mov    %rcx,(%rdx)
  8030fa:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803101:	00 00 00 
  803104:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  803108:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80310f:	00 00 00 
  803112:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  803115:	e9 70 ff ff ff       	jmp    80308a <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  80311a:	89 c1                	mov    %eax,%ecx
  80311c:	48 ba b2 42 80 00 00 	movabs $0x8042b2,%rdx
  803123:	00 00 00 
  803126:	be 3d 00 00 00       	mov    $0x3d,%esi
  80312b:	48 bf a4 42 80 00 00 	movabs $0x8042a4,%rdi
  803132:	00 00 00 
  803135:	b8 00 00 00 00       	mov    $0x0,%eax
  80313a:	49 b8 56 2e 80 00 00 	movabs $0x802e56,%r8
  803141:	00 00 00 
  803144:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  803147:	b8 00 00 00 00       	mov    $0x0,%eax
  80314c:	e9 61 ff ff ff       	jmp    8030b2 <add_pgfault_handler+0xa1>

0000000000803151 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  803151:	f3 0f 1e fa          	endbr64
  803155:	55                   	push   %rbp
  803156:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  803159:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803160:	00 00 00 
  803163:	80 38 00             	cmpb   $0x0,(%rax)
  803166:	74 33                	je     80319b <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803168:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  80316f:	00 00 00 
  803172:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  803177:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  80317e:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803181:	48 85 c0             	test   %rax,%rax
  803184:	0f 84 85 00 00 00    	je     80320f <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  80318a:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  80318e:	74 40                	je     8031d0 <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803190:	48 83 c1 01          	add    $0x1,%rcx
  803194:	48 39 c1             	cmp    %rax,%rcx
  803197:	75 f1                	jne    80318a <remove_pgfault_handler+0x39>
  803199:	eb 74                	jmp    80320f <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  80319b:	48 b9 ca 42 80 00 00 	movabs $0x8042ca,%rcx
  8031a2:	00 00 00 
  8031a5:	48 ba 61 42 80 00 00 	movabs $0x804261,%rdx
  8031ac:	00 00 00 
  8031af:	be 43 00 00 00       	mov    $0x43,%esi
  8031b4:	48 bf a4 42 80 00 00 	movabs $0x8042a4,%rdi
  8031bb:	00 00 00 
  8031be:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c3:	49 b8 56 2e 80 00 00 	movabs $0x802e56,%r8
  8031ca:	00 00 00 
  8031cd:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  8031d0:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  8031d7:	00 
  8031d8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8031dc:	48 29 ca             	sub    %rcx,%rdx
  8031df:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8031e6:	00 00 00 
  8031e9:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  8031ed:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  8031f2:	48 89 ce             	mov    %rcx,%rsi
  8031f5:	48 b8 2c 0e 80 00 00 	movabs $0x800e2c,%rax
  8031fc:	00 00 00 
  8031ff:	ff d0                	call   *%rax
            _pfhandler_off--;
  803201:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803208:	00 00 00 
  80320b:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  80320f:	5d                   	pop    %rbp
  803210:	c3                   	ret

0000000000803211 <__text_end>:
  803211:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803218:	00 00 00 
  80321b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803222:	00 00 00 
  803225:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80322c:	00 00 00 
  80322f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803236:	00 00 00 
  803239:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803240:	00 00 00 
  803243:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80324a:	00 00 00 
  80324d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803254:	00 00 00 
  803257:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80325e:	00 00 00 
  803261:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803268:	00 00 00 
  80326b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803272:	00 00 00 
  803275:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80327c:	00 00 00 
  80327f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803286:	00 00 00 
  803289:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803290:	00 00 00 
  803293:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80329a:	00 00 00 
  80329d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032a4:	00 00 00 
  8032a7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032ae:	00 00 00 
  8032b1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032b8:	00 00 00 
  8032bb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032c2:	00 00 00 
  8032c5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032cc:	00 00 00 
  8032cf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032d6:	00 00 00 
  8032d9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032e0:	00 00 00 
  8032e3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032ea:	00 00 00 
  8032ed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032f4:	00 00 00 
  8032f7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032fe:	00 00 00 
  803301:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803308:	00 00 00 
  80330b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803312:	00 00 00 
  803315:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80331c:	00 00 00 
  80331f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803326:	00 00 00 
  803329:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803330:	00 00 00 
  803333:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80333a:	00 00 00 
  80333d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803344:	00 00 00 
  803347:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80334e:	00 00 00 
  803351:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803358:	00 00 00 
  80335b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803362:	00 00 00 
  803365:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80336c:	00 00 00 
  80336f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803376:	00 00 00 
  803379:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803380:	00 00 00 
  803383:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80338a:	00 00 00 
  80338d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803394:	00 00 00 
  803397:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80339e:	00 00 00 
  8033a1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033a8:	00 00 00 
  8033ab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033b2:	00 00 00 
  8033b5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033bc:	00 00 00 
  8033bf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033c6:	00 00 00 
  8033c9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033d0:	00 00 00 
  8033d3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033da:	00 00 00 
  8033dd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033e4:	00 00 00 
  8033e7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033ee:	00 00 00 
  8033f1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033f8:	00 00 00 
  8033fb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803402:	00 00 00 
  803405:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80340c:	00 00 00 
  80340f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803416:	00 00 00 
  803419:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803420:	00 00 00 
  803423:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80342a:	00 00 00 
  80342d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803434:	00 00 00 
  803437:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80343e:	00 00 00 
  803441:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803448:	00 00 00 
  80344b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803452:	00 00 00 
  803455:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80345c:	00 00 00 
  80345f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803466:	00 00 00 
  803469:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803470:	00 00 00 
  803473:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80347a:	00 00 00 
  80347d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803484:	00 00 00 
  803487:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80348e:	00 00 00 
  803491:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803498:	00 00 00 
  80349b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034a2:	00 00 00 
  8034a5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ac:	00 00 00 
  8034af:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034b6:	00 00 00 
  8034b9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034c0:	00 00 00 
  8034c3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ca:	00 00 00 
  8034cd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034d4:	00 00 00 
  8034d7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034de:	00 00 00 
  8034e1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034e8:	00 00 00 
  8034eb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034f2:	00 00 00 
  8034f5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034fc:	00 00 00 
  8034ff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803506:	00 00 00 
  803509:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803510:	00 00 00 
  803513:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80351a:	00 00 00 
  80351d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803524:	00 00 00 
  803527:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80352e:	00 00 00 
  803531:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803538:	00 00 00 
  80353b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803542:	00 00 00 
  803545:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80354c:	00 00 00 
  80354f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803556:	00 00 00 
  803559:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803560:	00 00 00 
  803563:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80356a:	00 00 00 
  80356d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803574:	00 00 00 
  803577:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80357e:	00 00 00 
  803581:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803588:	00 00 00 
  80358b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803592:	00 00 00 
  803595:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80359c:	00 00 00 
  80359f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a6:	00 00 00 
  8035a9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b0:	00 00 00 
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
