
obj/user/stresssched:     file format elf64-x86-64


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
  80001e:	e8 37 01 00 00       	call   80015a <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

volatile int counter;

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 83 ec 08          	sub    $0x8,%rsp
    int i, j;
    envid_t parent = sys_getenvid();
  800036:	48 b8 0d 12 80 00 00 	movabs $0x80120d,%rax
  80003d:	00 00 00 
  800040:	ff d0                	call   *%rax
  800042:	41 89 c5             	mov    %eax,%r13d

    /* Fork several environments */
    for (i = 0; i < 20; i++)
  800045:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (fork() == 0)
  80004a:	49 bc a1 16 80 00 00 	movabs $0x8016a1,%r12
  800051:	00 00 00 
  800054:	41 ff d4             	call   *%r12
  800057:	85 c0                	test   %eax,%eax
  800059:	74 50                	je     8000ab <umain+0x86>
    for (i = 0; i < 20; i++)
  80005b:	83 c3 01             	add    $0x1,%ebx
  80005e:	83 fb 14             	cmp    $0x14,%ebx
  800061:	75 f1                	jne    800054 <umain+0x2f>
            break;
    if (i == 20) {
        sys_yield();
  800063:	48 b8 42 12 80 00 00 	movabs $0x801242,%rax
  80006a:	00 00 00 
  80006d:	ff d0                	call   *%rax
        return;
  80006f:	e9 db 00 00 00       	jmp    80014f <umain+0x12a>
        for (j = 0; j < 10000; j++)
            counter++;
    }

    if (counter != 10 * 10000)
        panic("ran on two CPUs at once (counter is %d)", counter);
  800074:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80007b:	00 00 00 
  80007e:	8b 08                	mov    (%rax),%ecx
  800080:	48 ba 00 40 80 00 00 	movabs $0x804000,%rdx
  800087:	00 00 00 
  80008a:	be 1f 00 00 00       	mov    $0x1f,%esi
  80008f:	48 bf 30 41 80 00 00 	movabs $0x804130,%rdi
  800096:	00 00 00 
  800099:	b8 00 00 00 00       	mov    $0x0,%eax
  80009e:	49 b8 33 02 80 00 00 	movabs $0x800233,%r8
  8000a5:	00 00 00 
  8000a8:	41 ff d0             	call   *%r8
    while (envs[ENVX(parent)].env_status != ENV_FREE)
  8000ab:	44 89 ea             	mov    %r13d,%edx
  8000ae:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8000b4:	44 89 e8             	mov    %r13d,%eax
  8000b7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000bc:	48 8d 0c c0          	lea    (%rax,%rax,8),%rcx
  8000c0:	48 8d 0c 48          	lea    (%rax,%rcx,2),%rcx
  8000c4:	48 c1 e1 04          	shl    $0x4,%rcx
  8000c8:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8000cf:	00 00 00 
  8000d2:	48 01 c8             	add    %rcx,%rax
  8000d5:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	74 28                	je     800107 <umain+0xe2>
  8000df:	48 63 c2             	movslq %edx,%rax
  8000e2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000e6:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000ea:	48 c1 e0 04          	shl    $0x4,%rax
  8000ee:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000f5:	00 00 00 
  8000f8:	48 01 c2             	add    %rax,%rdx
        asm volatile("pause");
  8000fb:	f3 90                	pause
    while (envs[ENVX(parent)].env_status != ENV_FREE)
  8000fd:	8b 82 d4 00 00 00    	mov    0xd4(%rdx),%eax
  800103:	85 c0                	test   %eax,%eax
  800105:	75 f4                	jne    8000fb <umain+0xd6>
    for (i = 0; i < 20; i++)
  800107:	41 bc 0a 00 00 00    	mov    $0xa,%r12d
        sys_yield();
  80010d:	49 bd 42 12 80 00 00 	movabs $0x801242,%r13
  800114:	00 00 00 
            counter++;
  800117:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  80011e:	00 00 00 
        sys_yield();
  800121:	41 ff d5             	call   *%r13
  800124:	ba 10 27 00 00       	mov    $0x2710,%edx
            counter++;
  800129:	8b 03                	mov    (%rbx),%eax
  80012b:	83 c0 01             	add    $0x1,%eax
  80012e:	89 03                	mov    %eax,(%rbx)
        for (j = 0; j < 10000; j++)
  800130:	83 ea 01             	sub    $0x1,%edx
  800133:	75 f4                	jne    800129 <umain+0x104>
    for (i = 0; i < 10; i++) {
  800135:	41 83 ec 01          	sub    $0x1,%r12d
  800139:	75 e6                	jne    800121 <umain+0xfc>
    if (counter != 10 * 10000)
  80013b:	a1 00 60 80 00 00 00 	movabs 0x806000,%eax
  800142:	00 00 
  800144:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  800149:	0f 85 25 ff ff ff    	jne    800074 <umain+0x4f>

    /* Check that we see environments running on different CPUs */
    // cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
}
  80014f:	48 83 c4 08          	add    $0x8,%rsp
  800153:	5b                   	pop    %rbx
  800154:	41 5c                	pop    %r12
  800156:	41 5d                	pop    %r13
  800158:	5d                   	pop    %rbp
  800159:	c3                   	ret

000000000080015a <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80015a:	f3 0f 1e fa          	endbr64
  80015e:	55                   	push   %rbp
  80015f:	48 89 e5             	mov    %rsp,%rbp
  800162:	41 56                	push   %r14
  800164:	41 55                	push   %r13
  800166:	41 54                	push   %r12
  800168:	53                   	push   %rbx
  800169:	41 89 fd             	mov    %edi,%r13d
  80016c:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80016f:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  800176:	00 00 00 
  800179:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  800180:	00 00 00 
  800183:	48 39 c2             	cmp    %rax,%rdx
  800186:	73 17                	jae    80019f <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800188:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80018b:	49 89 c4             	mov    %rax,%r12
  80018e:	48 83 c3 08          	add    $0x8,%rbx
  800192:	b8 00 00 00 00       	mov    $0x0,%eax
  800197:	ff 53 f8             	call   *-0x8(%rbx)
  80019a:	4c 39 e3             	cmp    %r12,%rbx
  80019d:	72 ef                	jb     80018e <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  80019f:	48 b8 0d 12 80 00 00 	movabs $0x80120d,%rax
  8001a6:	00 00 00 
  8001a9:	ff d0                	call   *%rax
  8001ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b0:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8001b4:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8001b8:	48 c1 e0 04          	shl    $0x4,%rax
  8001bc:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8001c3:	00 00 00 
  8001c6:	48 01 d0             	add    %rdx,%rax
  8001c9:	48 a3 08 60 80 00 00 	movabs %rax,0x806008
  8001d0:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8001d3:	45 85 ed             	test   %r13d,%r13d
  8001d6:	7e 0d                	jle    8001e5 <libmain+0x8b>
  8001d8:	49 8b 06             	mov    (%r14),%rax
  8001db:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8001e2:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8001e5:	4c 89 f6             	mov    %r14,%rsi
  8001e8:	44 89 ef             	mov    %r13d,%edi
  8001eb:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8001f2:	00 00 00 
  8001f5:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8001f7:	48 b8 0c 02 80 00 00 	movabs $0x80020c,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	call   *%rax
#endif
}
  800203:	5b                   	pop    %rbx
  800204:	41 5c                	pop    %r12
  800206:	41 5d                	pop    %r13
  800208:	41 5e                	pop    %r14
  80020a:	5d                   	pop    %rbp
  80020b:	c3                   	ret

000000000080020c <exit>:

#include <inc/lib.h>

void
exit(void) {
  80020c:	f3 0f 1e fa          	endbr64
  800210:	55                   	push   %rbp
  800211:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800214:	48 b8 3f 1a 80 00 00 	movabs $0x801a3f,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800220:	bf 00 00 00 00       	mov    $0x0,%edi
  800225:	48 b8 9e 11 80 00 00 	movabs $0x80119e,%rax
  80022c:	00 00 00 
  80022f:	ff d0                	call   *%rax
}
  800231:	5d                   	pop    %rbp
  800232:	c3                   	ret

0000000000800233 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800233:	f3 0f 1e fa          	endbr64
  800237:	55                   	push   %rbp
  800238:	48 89 e5             	mov    %rsp,%rbp
  80023b:	41 56                	push   %r14
  80023d:	41 55                	push   %r13
  80023f:	41 54                	push   %r12
  800241:	53                   	push   %rbx
  800242:	48 83 ec 50          	sub    $0x50,%rsp
  800246:	49 89 fc             	mov    %rdi,%r12
  800249:	41 89 f5             	mov    %esi,%r13d
  80024c:	48 89 d3             	mov    %rdx,%rbx
  80024f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800253:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800257:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80025b:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800262:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800266:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80026a:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80026e:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800272:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800279:	00 00 00 
  80027c:	4c 8b 30             	mov    (%rax),%r14
  80027f:	48 b8 0d 12 80 00 00 	movabs $0x80120d,%rax
  800286:	00 00 00 
  800289:	ff d0                	call   *%rax
  80028b:	89 c6                	mov    %eax,%esi
  80028d:	45 89 e8             	mov    %r13d,%r8d
  800290:	4c 89 e1             	mov    %r12,%rcx
  800293:	4c 89 f2             	mov    %r14,%rdx
  800296:	48 bf 28 40 80 00 00 	movabs $0x804028,%rdi
  80029d:	00 00 00 
  8002a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a5:	49 bc 8f 03 80 00 00 	movabs $0x80038f,%r12
  8002ac:	00 00 00 
  8002af:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8002b2:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8002b6:	48 89 df             	mov    %rbx,%rdi
  8002b9:	48 b8 27 03 80 00 00 	movabs $0x800327,%rax
  8002c0:	00 00 00 
  8002c3:	ff d0                	call   *%rax
    cprintf("\n");
  8002c5:	48 bf 2a 43 80 00 00 	movabs $0x80432a,%rdi
  8002cc:	00 00 00 
  8002cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d4:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8002d7:	cc                   	int3
  8002d8:	eb fd                	jmp    8002d7 <_panic+0xa4>

00000000008002da <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8002da:	f3 0f 1e fa          	endbr64
  8002de:	55                   	push   %rbp
  8002df:	48 89 e5             	mov    %rsp,%rbp
  8002e2:	53                   	push   %rbx
  8002e3:	48 83 ec 08          	sub    $0x8,%rsp
  8002e7:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8002ea:	8b 06                	mov    (%rsi),%eax
  8002ec:	8d 50 01             	lea    0x1(%rax),%edx
  8002ef:	89 16                	mov    %edx,(%rsi)
  8002f1:	48 98                	cltq
  8002f3:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8002f8:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8002fe:	74 0a                	je     80030a <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800300:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800304:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800308:	c9                   	leave
  800309:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80030a:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80030e:	be ff 00 00 00       	mov    $0xff,%esi
  800313:	48 b8 38 11 80 00 00 	movabs $0x801138,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	call   *%rax
        state->offset = 0;
  80031f:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800325:	eb d9                	jmp    800300 <putch+0x26>

0000000000800327 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800327:	f3 0f 1e fa          	endbr64
  80032b:	55                   	push   %rbp
  80032c:	48 89 e5             	mov    %rsp,%rbp
  80032f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800336:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800339:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800340:	b9 21 00 00 00       	mov    $0x21,%ecx
  800345:	b8 00 00 00 00       	mov    $0x0,%eax
  80034a:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80034d:	48 89 f1             	mov    %rsi,%rcx
  800350:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800357:	48 bf da 02 80 00 00 	movabs $0x8002da,%rdi
  80035e:	00 00 00 
  800361:	48 b8 ef 04 80 00 00 	movabs $0x8004ef,%rax
  800368:	00 00 00 
  80036b:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  80036d:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800374:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  80037b:	48 b8 38 11 80 00 00 	movabs $0x801138,%rax
  800382:	00 00 00 
  800385:	ff d0                	call   *%rax

    return state.count;
}
  800387:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  80038d:	c9                   	leave
  80038e:	c3                   	ret

000000000080038f <cprintf>:

int
cprintf(const char *fmt, ...) {
  80038f:	f3 0f 1e fa          	endbr64
  800393:	55                   	push   %rbp
  800394:	48 89 e5             	mov    %rsp,%rbp
  800397:	48 83 ec 50          	sub    $0x50,%rsp
  80039b:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80039f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8003a3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003a7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8003ab:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8003af:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8003b6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003ba:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003be:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8003c2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8003c6:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8003ca:	48 b8 27 03 80 00 00 	movabs $0x800327,%rax
  8003d1:	00 00 00 
  8003d4:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8003d6:	c9                   	leave
  8003d7:	c3                   	ret

00000000008003d8 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8003d8:	f3 0f 1e fa          	endbr64
  8003dc:	55                   	push   %rbp
  8003dd:	48 89 e5             	mov    %rsp,%rbp
  8003e0:	41 57                	push   %r15
  8003e2:	41 56                	push   %r14
  8003e4:	41 55                	push   %r13
  8003e6:	41 54                	push   %r12
  8003e8:	53                   	push   %rbx
  8003e9:	48 83 ec 18          	sub    $0x18,%rsp
  8003ed:	49 89 fc             	mov    %rdi,%r12
  8003f0:	49 89 f5             	mov    %rsi,%r13
  8003f3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8003f7:	8b 45 10             	mov    0x10(%rbp),%eax
  8003fa:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8003fd:	41 89 cf             	mov    %ecx,%r15d
  800400:	4c 39 fa             	cmp    %r15,%rdx
  800403:	73 5b                	jae    800460 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800405:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800409:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80040d:	85 db                	test   %ebx,%ebx
  80040f:	7e 0e                	jle    80041f <print_num+0x47>
            putch(padc, put_arg);
  800411:	4c 89 ee             	mov    %r13,%rsi
  800414:	44 89 f7             	mov    %r14d,%edi
  800417:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80041a:	83 eb 01             	sub    $0x1,%ebx
  80041d:	75 f2                	jne    800411 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  80041f:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800423:	48 b9 5e 41 80 00 00 	movabs $0x80415e,%rcx
  80042a:	00 00 00 
  80042d:	48 b8 4d 41 80 00 00 	movabs $0x80414d,%rax
  800434:	00 00 00 
  800437:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80043b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80043f:	ba 00 00 00 00       	mov    $0x0,%edx
  800444:	49 f7 f7             	div    %r15
  800447:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80044b:	4c 89 ee             	mov    %r13,%rsi
  80044e:	41 ff d4             	call   *%r12
}
  800451:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800455:	5b                   	pop    %rbx
  800456:	41 5c                	pop    %r12
  800458:	41 5d                	pop    %r13
  80045a:	41 5e                	pop    %r14
  80045c:	41 5f                	pop    %r15
  80045e:	5d                   	pop    %rbp
  80045f:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800460:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800464:	ba 00 00 00 00       	mov    $0x0,%edx
  800469:	49 f7 f7             	div    %r15
  80046c:	48 83 ec 08          	sub    $0x8,%rsp
  800470:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800474:	52                   	push   %rdx
  800475:	45 0f be c9          	movsbl %r9b,%r9d
  800479:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80047d:	48 89 c2             	mov    %rax,%rdx
  800480:	48 b8 d8 03 80 00 00 	movabs $0x8003d8,%rax
  800487:	00 00 00 
  80048a:	ff d0                	call   *%rax
  80048c:	48 83 c4 10          	add    $0x10,%rsp
  800490:	eb 8d                	jmp    80041f <print_num+0x47>

0000000000800492 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800492:	f3 0f 1e fa          	endbr64
    state->count++;
  800496:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80049a:	48 8b 06             	mov    (%rsi),%rax
  80049d:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8004a1:	73 0a                	jae    8004ad <sprintputch+0x1b>
        *state->start++ = ch;
  8004a3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004a7:	48 89 16             	mov    %rdx,(%rsi)
  8004aa:	40 88 38             	mov    %dil,(%rax)
    }
}
  8004ad:	c3                   	ret

00000000008004ae <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8004ae:	f3 0f 1e fa          	endbr64
  8004b2:	55                   	push   %rbp
  8004b3:	48 89 e5             	mov    %rsp,%rbp
  8004b6:	48 83 ec 50          	sub    $0x50,%rsp
  8004ba:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8004be:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8004c2:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8004c6:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8004cd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004d1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004d5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8004d9:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8004dd:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8004e1:	48 b8 ef 04 80 00 00 	movabs $0x8004ef,%rax
  8004e8:	00 00 00 
  8004eb:	ff d0                	call   *%rax
}
  8004ed:	c9                   	leave
  8004ee:	c3                   	ret

00000000008004ef <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8004ef:	f3 0f 1e fa          	endbr64
  8004f3:	55                   	push   %rbp
  8004f4:	48 89 e5             	mov    %rsp,%rbp
  8004f7:	41 57                	push   %r15
  8004f9:	41 56                	push   %r14
  8004fb:	41 55                	push   %r13
  8004fd:	41 54                	push   %r12
  8004ff:	53                   	push   %rbx
  800500:	48 83 ec 38          	sub    $0x38,%rsp
  800504:	49 89 fe             	mov    %rdi,%r14
  800507:	49 89 f5             	mov    %rsi,%r13
  80050a:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  80050d:	48 8b 01             	mov    (%rcx),%rax
  800510:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800514:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800518:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80051c:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800520:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800524:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800528:	0f b6 3b             	movzbl (%rbx),%edi
  80052b:	40 80 ff 25          	cmp    $0x25,%dil
  80052f:	74 18                	je     800549 <vprintfmt+0x5a>
            if (!ch) return;
  800531:	40 84 ff             	test   %dil,%dil
  800534:	0f 84 b2 06 00 00    	je     800bec <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80053a:	40 0f b6 ff          	movzbl %dil,%edi
  80053e:	4c 89 ee             	mov    %r13,%rsi
  800541:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800544:	4c 89 e3             	mov    %r12,%rbx
  800547:	eb db                	jmp    800524 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800549:	be 00 00 00 00       	mov    $0x0,%esi
  80054e:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  800552:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800557:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80055d:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800564:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800568:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  80056d:	41 0f b6 04 24       	movzbl (%r12),%eax
  800572:	88 45 a0             	mov    %al,-0x60(%rbp)
  800575:	83 e8 23             	sub    $0x23,%eax
  800578:	3c 57                	cmp    $0x57,%al
  80057a:	0f 87 52 06 00 00    	ja     800bd2 <vprintfmt+0x6e3>
  800580:	0f b6 c0             	movzbl %al,%eax
  800583:	48 b9 00 44 80 00 00 	movabs $0x804400,%rcx
  80058a:	00 00 00 
  80058d:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800591:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800594:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  800598:	eb ce                	jmp    800568 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  80059a:	49 89 dc             	mov    %rbx,%r12
  80059d:	be 01 00 00 00       	mov    $0x1,%esi
  8005a2:	eb c4                	jmp    800568 <vprintfmt+0x79>
            padc = ch;
  8005a4:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8005a8:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8005ab:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8005ae:	eb b8                	jmp    800568 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8005b0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005b3:	83 f8 2f             	cmp    $0x2f,%eax
  8005b6:	77 24                	ja     8005dc <vprintfmt+0xed>
  8005b8:	89 c1                	mov    %eax,%ecx
  8005ba:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8005be:	83 c0 08             	add    $0x8,%eax
  8005c1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005c4:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8005c7:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8005ca:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8005ce:	79 98                	jns    800568 <vprintfmt+0x79>
                width = precision;
  8005d0:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  8005d4:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8005da:	eb 8c                	jmp    800568 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8005dc:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8005e0:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8005e4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005e8:	eb da                	jmp    8005c4 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  8005ea:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  8005ef:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8005f3:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  8005f9:	3c 39                	cmp    $0x39,%al
  8005fb:	77 1c                	ja     800619 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  8005fd:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800601:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800605:	0f b6 c0             	movzbl %al,%eax
  800608:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80060d:	0f b6 03             	movzbl (%rbx),%eax
  800610:	3c 39                	cmp    $0x39,%al
  800612:	76 e9                	jbe    8005fd <vprintfmt+0x10e>
        process_precision:
  800614:	49 89 dc             	mov    %rbx,%r12
  800617:	eb b1                	jmp    8005ca <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800619:	49 89 dc             	mov    %rbx,%r12
  80061c:	eb ac                	jmp    8005ca <vprintfmt+0xdb>
            width = MAX(0, width);
  80061e:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800621:	85 c9                	test   %ecx,%ecx
  800623:	b8 00 00 00 00       	mov    $0x0,%eax
  800628:	0f 49 c1             	cmovns %ecx,%eax
  80062b:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  80062e:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800631:	e9 32 ff ff ff       	jmp    800568 <vprintfmt+0x79>
            lflag++;
  800636:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800639:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80063c:	e9 27 ff ff ff       	jmp    800568 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800641:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800644:	83 f8 2f             	cmp    $0x2f,%eax
  800647:	77 19                	ja     800662 <vprintfmt+0x173>
  800649:	89 c2                	mov    %eax,%edx
  80064b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80064f:	83 c0 08             	add    $0x8,%eax
  800652:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800655:	8b 3a                	mov    (%rdx),%edi
  800657:	4c 89 ee             	mov    %r13,%rsi
  80065a:	41 ff d6             	call   *%r14
            break;
  80065d:	e9 c2 fe ff ff       	jmp    800524 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  800662:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800666:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80066a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80066e:	eb e5                	jmp    800655 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800670:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800673:	83 f8 2f             	cmp    $0x2f,%eax
  800676:	77 5a                	ja     8006d2 <vprintfmt+0x1e3>
  800678:	89 c2                	mov    %eax,%edx
  80067a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80067e:	83 c0 08             	add    $0x8,%eax
  800681:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800684:	8b 02                	mov    (%rdx),%eax
  800686:	89 c1                	mov    %eax,%ecx
  800688:	f7 d9                	neg    %ecx
  80068a:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80068d:	83 f9 13             	cmp    $0x13,%ecx
  800690:	7f 4e                	jg     8006e0 <vprintfmt+0x1f1>
  800692:	48 63 c1             	movslq %ecx,%rax
  800695:	48 ba c0 46 80 00 00 	movabs $0x8046c0,%rdx
  80069c:	00 00 00 
  80069f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8006a3:	48 85 c0             	test   %rax,%rax
  8006a6:	74 38                	je     8006e0 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8006a8:	48 89 c1             	mov    %rax,%rcx
  8006ab:	48 ba 78 43 80 00 00 	movabs $0x804378,%rdx
  8006b2:	00 00 00 
  8006b5:	4c 89 ee             	mov    %r13,%rsi
  8006b8:	4c 89 f7             	mov    %r14,%rdi
  8006bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c0:	49 b8 ae 04 80 00 00 	movabs $0x8004ae,%r8
  8006c7:	00 00 00 
  8006ca:	41 ff d0             	call   *%r8
  8006cd:	e9 52 fe ff ff       	jmp    800524 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8006d2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006d6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006da:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006de:	eb a4                	jmp    800684 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8006e0:	48 ba 76 41 80 00 00 	movabs $0x804176,%rdx
  8006e7:	00 00 00 
  8006ea:	4c 89 ee             	mov    %r13,%rsi
  8006ed:	4c 89 f7             	mov    %r14,%rdi
  8006f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f5:	49 b8 ae 04 80 00 00 	movabs $0x8004ae,%r8
  8006fc:	00 00 00 
  8006ff:	41 ff d0             	call   *%r8
  800702:	e9 1d fe ff ff       	jmp    800524 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800707:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80070a:	83 f8 2f             	cmp    $0x2f,%eax
  80070d:	77 6c                	ja     80077b <vprintfmt+0x28c>
  80070f:	89 c2                	mov    %eax,%edx
  800711:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800715:	83 c0 08             	add    $0x8,%eax
  800718:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80071b:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  80071e:	48 85 d2             	test   %rdx,%rdx
  800721:	48 b8 6f 41 80 00 00 	movabs $0x80416f,%rax
  800728:	00 00 00 
  80072b:	48 0f 45 c2          	cmovne %rdx,%rax
  80072f:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800733:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800737:	7e 06                	jle    80073f <vprintfmt+0x250>
  800739:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  80073d:	75 4a                	jne    800789 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80073f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800743:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800747:	0f b6 00             	movzbl (%rax),%eax
  80074a:	84 c0                	test   %al,%al
  80074c:	0f 85 9a 00 00 00    	jne    8007ec <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  800752:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800755:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  800759:	85 c0                	test   %eax,%eax
  80075b:	0f 8e c3 fd ff ff    	jle    800524 <vprintfmt+0x35>
  800761:	4c 89 ee             	mov    %r13,%rsi
  800764:	bf 20 00 00 00       	mov    $0x20,%edi
  800769:	41 ff d6             	call   *%r14
  80076c:	41 83 ec 01          	sub    $0x1,%r12d
  800770:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800774:	75 eb                	jne    800761 <vprintfmt+0x272>
  800776:	e9 a9 fd ff ff       	jmp    800524 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80077b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80077f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800783:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800787:	eb 92                	jmp    80071b <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800789:	49 63 f7             	movslq %r15d,%rsi
  80078c:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800790:	48 b8 b2 0c 80 00 00 	movabs $0x800cb2,%rax
  800797:	00 00 00 
  80079a:	ff d0                	call   *%rax
  80079c:	48 89 c2             	mov    %rax,%rdx
  80079f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007a2:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8007a4:	8d 70 ff             	lea    -0x1(%rax),%esi
  8007a7:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8007aa:	85 c0                	test   %eax,%eax
  8007ac:	7e 91                	jle    80073f <vprintfmt+0x250>
  8007ae:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  8007b3:	4c 89 ee             	mov    %r13,%rsi
  8007b6:	44 89 e7             	mov    %r12d,%edi
  8007b9:	41 ff d6             	call   *%r14
  8007bc:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8007c0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007c3:	83 f8 ff             	cmp    $0xffffffff,%eax
  8007c6:	75 eb                	jne    8007b3 <vprintfmt+0x2c4>
  8007c8:	e9 72 ff ff ff       	jmp    80073f <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8007cd:	0f b6 f8             	movzbl %al,%edi
  8007d0:	4c 89 ee             	mov    %r13,%rsi
  8007d3:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8007d6:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8007da:	49 83 c4 01          	add    $0x1,%r12
  8007de:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  8007e4:	84 c0                	test   %al,%al
  8007e6:	0f 84 66 ff ff ff    	je     800752 <vprintfmt+0x263>
  8007ec:	45 85 ff             	test   %r15d,%r15d
  8007ef:	78 0a                	js     8007fb <vprintfmt+0x30c>
  8007f1:	41 83 ef 01          	sub    $0x1,%r15d
  8007f5:	0f 88 57 ff ff ff    	js     800752 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8007fb:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8007ff:	74 cc                	je     8007cd <vprintfmt+0x2de>
  800801:	8d 50 e0             	lea    -0x20(%rax),%edx
  800804:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800809:	80 fa 5e             	cmp    $0x5e,%dl
  80080c:	77 c2                	ja     8007d0 <vprintfmt+0x2e1>
  80080e:	eb bd                	jmp    8007cd <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800810:	40 84 f6             	test   %sil,%sil
  800813:	75 26                	jne    80083b <vprintfmt+0x34c>
    switch (lflag) {
  800815:	85 d2                	test   %edx,%edx
  800817:	74 59                	je     800872 <vprintfmt+0x383>
  800819:	83 fa 01             	cmp    $0x1,%edx
  80081c:	74 7b                	je     800899 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  80081e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800821:	83 f8 2f             	cmp    $0x2f,%eax
  800824:	0f 87 96 00 00 00    	ja     8008c0 <vprintfmt+0x3d1>
  80082a:	89 c2                	mov    %eax,%edx
  80082c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800830:	83 c0 08             	add    $0x8,%eax
  800833:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800836:	4c 8b 22             	mov    (%rdx),%r12
  800839:	eb 17                	jmp    800852 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  80083b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80083e:	83 f8 2f             	cmp    $0x2f,%eax
  800841:	77 21                	ja     800864 <vprintfmt+0x375>
  800843:	89 c2                	mov    %eax,%edx
  800845:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800849:	83 c0 08             	add    $0x8,%eax
  80084c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80084f:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800852:	4d 85 e4             	test   %r12,%r12
  800855:	78 7a                	js     8008d1 <vprintfmt+0x3e2>
            num = i;
  800857:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  80085a:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80085f:	e9 50 02 00 00       	jmp    800ab4 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800864:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800868:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80086c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800870:	eb dd                	jmp    80084f <vprintfmt+0x360>
        return va_arg(*ap, int);
  800872:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800875:	83 f8 2f             	cmp    $0x2f,%eax
  800878:	77 11                	ja     80088b <vprintfmt+0x39c>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800880:	83 c0 08             	add    $0x8,%eax
  800883:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800886:	4c 63 22             	movslq (%rdx),%r12
  800889:	eb c7                	jmp    800852 <vprintfmt+0x363>
  80088b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80088f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800893:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800897:	eb ed                	jmp    800886 <vprintfmt+0x397>
        return va_arg(*ap, long);
  800899:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089c:	83 f8 2f             	cmp    $0x2f,%eax
  80089f:	77 11                	ja     8008b2 <vprintfmt+0x3c3>
  8008a1:	89 c2                	mov    %eax,%edx
  8008a3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008a7:	83 c0 08             	add    $0x8,%eax
  8008aa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008ad:	4c 8b 22             	mov    (%rdx),%r12
  8008b0:	eb a0                	jmp    800852 <vprintfmt+0x363>
  8008b2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008ba:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008be:	eb ed                	jmp    8008ad <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  8008c0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008c8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008cc:	e9 65 ff ff ff       	jmp    800836 <vprintfmt+0x347>
                putch('-', put_arg);
  8008d1:	4c 89 ee             	mov    %r13,%rsi
  8008d4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8008d9:	41 ff d6             	call   *%r14
                i = -i;
  8008dc:	49 f7 dc             	neg    %r12
  8008df:	e9 73 ff ff ff       	jmp    800857 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  8008e4:	40 84 f6             	test   %sil,%sil
  8008e7:	75 32                	jne    80091b <vprintfmt+0x42c>
    switch (lflag) {
  8008e9:	85 d2                	test   %edx,%edx
  8008eb:	74 5d                	je     80094a <vprintfmt+0x45b>
  8008ed:	83 fa 01             	cmp    $0x1,%edx
  8008f0:	0f 84 82 00 00 00    	je     800978 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8008f6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f9:	83 f8 2f             	cmp    $0x2f,%eax
  8008fc:	0f 87 a5 00 00 00    	ja     8009a7 <vprintfmt+0x4b8>
  800902:	89 c2                	mov    %eax,%edx
  800904:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800908:	83 c0 08             	add    $0x8,%eax
  80090b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80090e:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800911:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800916:	e9 99 01 00 00       	jmp    800ab4 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80091b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091e:	83 f8 2f             	cmp    $0x2f,%eax
  800921:	77 19                	ja     80093c <vprintfmt+0x44d>
  800923:	89 c2                	mov    %eax,%edx
  800925:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800929:	83 c0 08             	add    $0x8,%eax
  80092c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80092f:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800932:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800937:	e9 78 01 00 00       	jmp    800ab4 <vprintfmt+0x5c5>
  80093c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800940:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800944:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800948:	eb e5                	jmp    80092f <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  80094a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094d:	83 f8 2f             	cmp    $0x2f,%eax
  800950:	77 18                	ja     80096a <vprintfmt+0x47b>
  800952:	89 c2                	mov    %eax,%edx
  800954:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800958:	83 c0 08             	add    $0x8,%eax
  80095b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80095e:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800960:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800965:	e9 4a 01 00 00       	jmp    800ab4 <vprintfmt+0x5c5>
  80096a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80096e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800972:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800976:	eb e6                	jmp    80095e <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800978:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097b:	83 f8 2f             	cmp    $0x2f,%eax
  80097e:	77 19                	ja     800999 <vprintfmt+0x4aa>
  800980:	89 c2                	mov    %eax,%edx
  800982:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800986:	83 c0 08             	add    $0x8,%eax
  800989:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80098c:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80098f:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800994:	e9 1b 01 00 00       	jmp    800ab4 <vprintfmt+0x5c5>
  800999:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80099d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009a1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009a5:	eb e5                	jmp    80098c <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  8009a7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ab:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009af:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009b3:	e9 56 ff ff ff       	jmp    80090e <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  8009b8:	40 84 f6             	test   %sil,%sil
  8009bb:	75 2e                	jne    8009eb <vprintfmt+0x4fc>
    switch (lflag) {
  8009bd:	85 d2                	test   %edx,%edx
  8009bf:	74 59                	je     800a1a <vprintfmt+0x52b>
  8009c1:	83 fa 01             	cmp    $0x1,%edx
  8009c4:	74 7f                	je     800a45 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  8009c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c9:	83 f8 2f             	cmp    $0x2f,%eax
  8009cc:	0f 87 9f 00 00 00    	ja     800a71 <vprintfmt+0x582>
  8009d2:	89 c2                	mov    %eax,%edx
  8009d4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009d8:	83 c0 08             	add    $0x8,%eax
  8009db:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009de:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8009e1:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8009e6:	e9 c9 00 00 00       	jmp    800ab4 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8009eb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ee:	83 f8 2f             	cmp    $0x2f,%eax
  8009f1:	77 19                	ja     800a0c <vprintfmt+0x51d>
  8009f3:	89 c2                	mov    %eax,%edx
  8009f5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009f9:	83 c0 08             	add    $0x8,%eax
  8009fc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ff:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a02:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a07:	e9 a8 00 00 00       	jmp    800ab4 <vprintfmt+0x5c5>
  800a0c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a10:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a14:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a18:	eb e5                	jmp    8009ff <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800a1a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1d:	83 f8 2f             	cmp    $0x2f,%eax
  800a20:	77 15                	ja     800a37 <vprintfmt+0x548>
  800a22:	89 c2                	mov    %eax,%edx
  800a24:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a28:	83 c0 08             	add    $0x8,%eax
  800a2b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a2e:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800a30:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800a35:	eb 7d                	jmp    800ab4 <vprintfmt+0x5c5>
  800a37:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a3f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a43:	eb e9                	jmp    800a2e <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800a45:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a48:	83 f8 2f             	cmp    $0x2f,%eax
  800a4b:	77 16                	ja     800a63 <vprintfmt+0x574>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a53:	83 c0 08             	add    $0x8,%eax
  800a56:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a59:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a5c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800a61:	eb 51                	jmp    800ab4 <vprintfmt+0x5c5>
  800a63:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a67:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a6b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a6f:	eb e8                	jmp    800a59 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800a71:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a75:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a79:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a7d:	e9 5c ff ff ff       	jmp    8009de <vprintfmt+0x4ef>
            putch('0', put_arg);
  800a82:	4c 89 ee             	mov    %r13,%rsi
  800a85:	bf 30 00 00 00       	mov    $0x30,%edi
  800a8a:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800a8d:	4c 89 ee             	mov    %r13,%rsi
  800a90:	bf 78 00 00 00       	mov    $0x78,%edi
  800a95:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800a98:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9b:	83 f8 2f             	cmp    $0x2f,%eax
  800a9e:	77 47                	ja     800ae7 <vprintfmt+0x5f8>
  800aa0:	89 c2                	mov    %eax,%edx
  800aa2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aa6:	83 c0 08             	add    $0x8,%eax
  800aa9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aac:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800aaf:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800ab4:	48 83 ec 08          	sub    $0x8,%rsp
  800ab8:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800abc:	0f 94 c0             	sete   %al
  800abf:	0f b6 c0             	movzbl %al,%eax
  800ac2:	50                   	push   %rax
  800ac3:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800ac8:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800acc:	4c 89 ee             	mov    %r13,%rsi
  800acf:	4c 89 f7             	mov    %r14,%rdi
  800ad2:	48 b8 d8 03 80 00 00 	movabs $0x8003d8,%rax
  800ad9:	00 00 00 
  800adc:	ff d0                	call   *%rax
            break;
  800ade:	48 83 c4 10          	add    $0x10,%rsp
  800ae2:	e9 3d fa ff ff       	jmp    800524 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800ae7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aeb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800aef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800af3:	eb b7                	jmp    800aac <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800af5:	40 84 f6             	test   %sil,%sil
  800af8:	75 2b                	jne    800b25 <vprintfmt+0x636>
    switch (lflag) {
  800afa:	85 d2                	test   %edx,%edx
  800afc:	74 56                	je     800b54 <vprintfmt+0x665>
  800afe:	83 fa 01             	cmp    $0x1,%edx
  800b01:	74 7f                	je     800b82 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800b03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b06:	83 f8 2f             	cmp    $0x2f,%eax
  800b09:	0f 87 a2 00 00 00    	ja     800bb1 <vprintfmt+0x6c2>
  800b0f:	89 c2                	mov    %eax,%edx
  800b11:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b15:	83 c0 08             	add    $0x8,%eax
  800b18:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b1b:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b1e:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800b23:	eb 8f                	jmp    800ab4 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b28:	83 f8 2f             	cmp    $0x2f,%eax
  800b2b:	77 19                	ja     800b46 <vprintfmt+0x657>
  800b2d:	89 c2                	mov    %eax,%edx
  800b2f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b33:	83 c0 08             	add    $0x8,%eax
  800b36:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b39:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b3c:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b41:	e9 6e ff ff ff       	jmp    800ab4 <vprintfmt+0x5c5>
  800b46:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b4a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b4e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b52:	eb e5                	jmp    800b39 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800b54:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b57:	83 f8 2f             	cmp    $0x2f,%eax
  800b5a:	77 18                	ja     800b74 <vprintfmt+0x685>
  800b5c:	89 c2                	mov    %eax,%edx
  800b5e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b62:	83 c0 08             	add    $0x8,%eax
  800b65:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b68:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800b6a:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800b6f:	e9 40 ff ff ff       	jmp    800ab4 <vprintfmt+0x5c5>
  800b74:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b78:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b7c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b80:	eb e6                	jmp    800b68 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800b82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b85:	83 f8 2f             	cmp    $0x2f,%eax
  800b88:	77 19                	ja     800ba3 <vprintfmt+0x6b4>
  800b8a:	89 c2                	mov    %eax,%edx
  800b8c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b90:	83 c0 08             	add    $0x8,%eax
  800b93:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b96:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b99:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800b9e:	e9 11 ff ff ff       	jmp    800ab4 <vprintfmt+0x5c5>
  800ba3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ba7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bab:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800baf:	eb e5                	jmp    800b96 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800bb1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bb9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bbd:	e9 59 ff ff ff       	jmp    800b1b <vprintfmt+0x62c>
            putch(ch, put_arg);
  800bc2:	4c 89 ee             	mov    %r13,%rsi
  800bc5:	bf 25 00 00 00       	mov    $0x25,%edi
  800bca:	41 ff d6             	call   *%r14
            break;
  800bcd:	e9 52 f9 ff ff       	jmp    800524 <vprintfmt+0x35>
            putch('%', put_arg);
  800bd2:	4c 89 ee             	mov    %r13,%rsi
  800bd5:	bf 25 00 00 00       	mov    $0x25,%edi
  800bda:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800bdd:	48 83 eb 01          	sub    $0x1,%rbx
  800be1:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800be5:	75 f6                	jne    800bdd <vprintfmt+0x6ee>
  800be7:	e9 38 f9 ff ff       	jmp    800524 <vprintfmt+0x35>
}
  800bec:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800bf0:	5b                   	pop    %rbx
  800bf1:	41 5c                	pop    %r12
  800bf3:	41 5d                	pop    %r13
  800bf5:	41 5e                	pop    %r14
  800bf7:	41 5f                	pop    %r15
  800bf9:	5d                   	pop    %rbp
  800bfa:	c3                   	ret

0000000000800bfb <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800bfb:	f3 0f 1e fa          	endbr64
  800bff:	55                   	push   %rbp
  800c00:	48 89 e5             	mov    %rsp,%rbp
  800c03:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800c07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c0b:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800c10:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800c14:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800c1b:	48 85 ff             	test   %rdi,%rdi
  800c1e:	74 2b                	je     800c4b <vsnprintf+0x50>
  800c20:	48 85 f6             	test   %rsi,%rsi
  800c23:	74 26                	je     800c4b <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800c25:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c29:	48 bf 92 04 80 00 00 	movabs $0x800492,%rdi
  800c30:	00 00 00 
  800c33:	48 b8 ef 04 80 00 00 	movabs $0x8004ef,%rax
  800c3a:	00 00 00 
  800c3d:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800c3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c43:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800c46:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800c49:	c9                   	leave
  800c4a:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800c4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c50:	eb f7                	jmp    800c49 <vsnprintf+0x4e>

0000000000800c52 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800c52:	f3 0f 1e fa          	endbr64
  800c56:	55                   	push   %rbp
  800c57:	48 89 e5             	mov    %rsp,%rbp
  800c5a:	48 83 ec 50          	sub    $0x50,%rsp
  800c5e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c62:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800c66:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800c6a:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800c71:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c75:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c79:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c7d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800c81:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800c85:	48 b8 fb 0b 80 00 00 	movabs $0x800bfb,%rax
  800c8c:	00 00 00 
  800c8f:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800c91:	c9                   	leave
  800c92:	c3                   	ret

0000000000800c93 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800c93:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800c97:	80 3f 00             	cmpb   $0x0,(%rdi)
  800c9a:	74 10                	je     800cac <strlen+0x19>
    size_t n = 0;
  800c9c:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800ca1:	48 83 c0 01          	add    $0x1,%rax
  800ca5:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800ca9:	75 f6                	jne    800ca1 <strlen+0xe>
  800cab:	c3                   	ret
    size_t n = 0;
  800cac:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800cb1:	c3                   	ret

0000000000800cb2 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800cb2:	f3 0f 1e fa          	endbr64
  800cb6:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800cb9:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800cbe:	48 85 f6             	test   %rsi,%rsi
  800cc1:	74 10                	je     800cd3 <strnlen+0x21>
  800cc3:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800cc7:	74 0b                	je     800cd4 <strnlen+0x22>
  800cc9:	48 83 c2 01          	add    $0x1,%rdx
  800ccd:	48 39 d0             	cmp    %rdx,%rax
  800cd0:	75 f1                	jne    800cc3 <strnlen+0x11>
  800cd2:	c3                   	ret
  800cd3:	c3                   	ret
  800cd4:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800cd7:	c3                   	ret

0000000000800cd8 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800cd8:	f3 0f 1e fa          	endbr64
  800cdc:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800cdf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce4:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800ce8:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800ceb:	48 83 c2 01          	add    $0x1,%rdx
  800cef:	84 c9                	test   %cl,%cl
  800cf1:	75 f1                	jne    800ce4 <strcpy+0xc>
        ;
    return res;
}
  800cf3:	c3                   	ret

0000000000800cf4 <strcat>:

char *
strcat(char *dst, const char *src) {
  800cf4:	f3 0f 1e fa          	endbr64
  800cf8:	55                   	push   %rbp
  800cf9:	48 89 e5             	mov    %rsp,%rbp
  800cfc:	41 54                	push   %r12
  800cfe:	53                   	push   %rbx
  800cff:	48 89 fb             	mov    %rdi,%rbx
  800d02:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800d05:	48 b8 93 0c 80 00 00 	movabs $0x800c93,%rax
  800d0c:	00 00 00 
  800d0f:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800d11:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800d15:	4c 89 e6             	mov    %r12,%rsi
  800d18:	48 b8 d8 0c 80 00 00 	movabs $0x800cd8,%rax
  800d1f:	00 00 00 
  800d22:	ff d0                	call   *%rax
    return dst;
}
  800d24:	48 89 d8             	mov    %rbx,%rax
  800d27:	5b                   	pop    %rbx
  800d28:	41 5c                	pop    %r12
  800d2a:	5d                   	pop    %rbp
  800d2b:	c3                   	ret

0000000000800d2c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d2c:	f3 0f 1e fa          	endbr64
  800d30:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800d33:	48 85 d2             	test   %rdx,%rdx
  800d36:	74 1f                	je     800d57 <strncpy+0x2b>
  800d38:	48 01 fa             	add    %rdi,%rdx
  800d3b:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800d3e:	48 83 c1 01          	add    $0x1,%rcx
  800d42:	44 0f b6 06          	movzbl (%rsi),%r8d
  800d46:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800d4a:	41 80 f8 01          	cmp    $0x1,%r8b
  800d4e:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800d52:	48 39 ca             	cmp    %rcx,%rdx
  800d55:	75 e7                	jne    800d3e <strncpy+0x12>
    }
    return ret;
}
  800d57:	c3                   	ret

0000000000800d58 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800d58:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800d5c:	48 89 f8             	mov    %rdi,%rax
  800d5f:	48 85 d2             	test   %rdx,%rdx
  800d62:	74 24                	je     800d88 <strlcpy+0x30>
        while (--size > 0 && *src)
  800d64:	48 83 ea 01          	sub    $0x1,%rdx
  800d68:	74 1b                	je     800d85 <strlcpy+0x2d>
  800d6a:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d6e:	0f b6 16             	movzbl (%rsi),%edx
  800d71:	84 d2                	test   %dl,%dl
  800d73:	74 10                	je     800d85 <strlcpy+0x2d>
            *dst++ = *src++;
  800d75:	48 83 c6 01          	add    $0x1,%rsi
  800d79:	48 83 c0 01          	add    $0x1,%rax
  800d7d:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800d80:	48 39 c8             	cmp    %rcx,%rax
  800d83:	75 e9                	jne    800d6e <strlcpy+0x16>
        *dst = '\0';
  800d85:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800d88:	48 29 f8             	sub    %rdi,%rax
}
  800d8b:	c3                   	ret

0000000000800d8c <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800d8c:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800d90:	0f b6 07             	movzbl (%rdi),%eax
  800d93:	84 c0                	test   %al,%al
  800d95:	74 13                	je     800daa <strcmp+0x1e>
  800d97:	38 06                	cmp    %al,(%rsi)
  800d99:	75 0f                	jne    800daa <strcmp+0x1e>
  800d9b:	48 83 c7 01          	add    $0x1,%rdi
  800d9f:	48 83 c6 01          	add    $0x1,%rsi
  800da3:	0f b6 07             	movzbl (%rdi),%eax
  800da6:	84 c0                	test   %al,%al
  800da8:	75 ed                	jne    800d97 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800daa:	0f b6 c0             	movzbl %al,%eax
  800dad:	0f b6 16             	movzbl (%rsi),%edx
  800db0:	29 d0                	sub    %edx,%eax
}
  800db2:	c3                   	ret

0000000000800db3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800db3:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800db7:	48 85 d2             	test   %rdx,%rdx
  800dba:	74 1f                	je     800ddb <strncmp+0x28>
  800dbc:	0f b6 07             	movzbl (%rdi),%eax
  800dbf:	84 c0                	test   %al,%al
  800dc1:	74 1e                	je     800de1 <strncmp+0x2e>
  800dc3:	3a 06                	cmp    (%rsi),%al
  800dc5:	75 1a                	jne    800de1 <strncmp+0x2e>
  800dc7:	48 83 c7 01          	add    $0x1,%rdi
  800dcb:	48 83 c6 01          	add    $0x1,%rsi
  800dcf:	48 83 ea 01          	sub    $0x1,%rdx
  800dd3:	75 e7                	jne    800dbc <strncmp+0x9>

    if (!n) return 0;
  800dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800dda:	c3                   	ret
  800ddb:	b8 00 00 00 00       	mov    $0x0,%eax
  800de0:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800de1:	0f b6 07             	movzbl (%rdi),%eax
  800de4:	0f b6 16             	movzbl (%rsi),%edx
  800de7:	29 d0                	sub    %edx,%eax
}
  800de9:	c3                   	ret

0000000000800dea <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800dea:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800dee:	0f b6 17             	movzbl (%rdi),%edx
  800df1:	84 d2                	test   %dl,%dl
  800df3:	74 18                	je     800e0d <strchr+0x23>
        if (*str == c) {
  800df5:	0f be d2             	movsbl %dl,%edx
  800df8:	39 f2                	cmp    %esi,%edx
  800dfa:	74 17                	je     800e13 <strchr+0x29>
    for (; *str; str++) {
  800dfc:	48 83 c7 01          	add    $0x1,%rdi
  800e00:	0f b6 17             	movzbl (%rdi),%edx
  800e03:	84 d2                	test   %dl,%dl
  800e05:	75 ee                	jne    800df5 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800e07:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0c:	c3                   	ret
  800e0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e12:	c3                   	ret
            return (char *)str;
  800e13:	48 89 f8             	mov    %rdi,%rax
}
  800e16:	c3                   	ret

0000000000800e17 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800e17:	f3 0f 1e fa          	endbr64
  800e1b:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800e1e:	0f b6 17             	movzbl (%rdi),%edx
  800e21:	84 d2                	test   %dl,%dl
  800e23:	74 13                	je     800e38 <strfind+0x21>
  800e25:	0f be d2             	movsbl %dl,%edx
  800e28:	39 f2                	cmp    %esi,%edx
  800e2a:	74 0b                	je     800e37 <strfind+0x20>
  800e2c:	48 83 c0 01          	add    $0x1,%rax
  800e30:	0f b6 10             	movzbl (%rax),%edx
  800e33:	84 d2                	test   %dl,%dl
  800e35:	75 ee                	jne    800e25 <strfind+0xe>
        ;
    return (char *)str;
}
  800e37:	c3                   	ret
  800e38:	c3                   	ret

0000000000800e39 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800e39:	f3 0f 1e fa          	endbr64
  800e3d:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800e40:	48 89 f8             	mov    %rdi,%rax
  800e43:	48 f7 d8             	neg    %rax
  800e46:	83 e0 07             	and    $0x7,%eax
  800e49:	49 89 d1             	mov    %rdx,%r9
  800e4c:	49 29 c1             	sub    %rax,%r9
  800e4f:	78 36                	js     800e87 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800e51:	40 0f b6 c6          	movzbl %sil,%eax
  800e55:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800e5c:	01 01 01 
  800e5f:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800e63:	40 f6 c7 07          	test   $0x7,%dil
  800e67:	75 38                	jne    800ea1 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800e69:	4c 89 c9             	mov    %r9,%rcx
  800e6c:	48 c1 f9 03          	sar    $0x3,%rcx
  800e70:	74 0c                	je     800e7e <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800e72:	fc                   	cld
  800e73:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800e76:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800e7a:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800e7e:	4d 85 c9             	test   %r9,%r9
  800e81:	75 45                	jne    800ec8 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800e83:	4c 89 c0             	mov    %r8,%rax
  800e86:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800e87:	48 85 d2             	test   %rdx,%rdx
  800e8a:	74 f7                	je     800e83 <memset+0x4a>
  800e8c:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800e8f:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800e92:	48 83 c0 01          	add    $0x1,%rax
  800e96:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800e9a:	48 39 c2             	cmp    %rax,%rdx
  800e9d:	75 f3                	jne    800e92 <memset+0x59>
  800e9f:	eb e2                	jmp    800e83 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800ea1:	40 f6 c7 01          	test   $0x1,%dil
  800ea5:	74 06                	je     800ead <memset+0x74>
  800ea7:	88 07                	mov    %al,(%rdi)
  800ea9:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ead:	40 f6 c7 02          	test   $0x2,%dil
  800eb1:	74 07                	je     800eba <memset+0x81>
  800eb3:	66 89 07             	mov    %ax,(%rdi)
  800eb6:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800eba:	40 f6 c7 04          	test   $0x4,%dil
  800ebe:	74 a9                	je     800e69 <memset+0x30>
  800ec0:	89 07                	mov    %eax,(%rdi)
  800ec2:	48 83 c7 04          	add    $0x4,%rdi
  800ec6:	eb a1                	jmp    800e69 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800ec8:	41 f6 c1 04          	test   $0x4,%r9b
  800ecc:	74 1b                	je     800ee9 <memset+0xb0>
  800ece:	89 07                	mov    %eax,(%rdi)
  800ed0:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ed4:	41 f6 c1 02          	test   $0x2,%r9b
  800ed8:	74 07                	je     800ee1 <memset+0xa8>
  800eda:	66 89 07             	mov    %ax,(%rdi)
  800edd:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800ee1:	41 f6 c1 01          	test   $0x1,%r9b
  800ee5:	74 9c                	je     800e83 <memset+0x4a>
  800ee7:	eb 06                	jmp    800eef <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ee9:	41 f6 c1 02          	test   $0x2,%r9b
  800eed:	75 eb                	jne    800eda <memset+0xa1>
        if (ni & 1) *ptr = k;
  800eef:	88 07                	mov    %al,(%rdi)
  800ef1:	eb 90                	jmp    800e83 <memset+0x4a>

0000000000800ef3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800ef3:	f3 0f 1e fa          	endbr64
  800ef7:	48 89 f8             	mov    %rdi,%rax
  800efa:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800efd:	48 39 fe             	cmp    %rdi,%rsi
  800f00:	73 3b                	jae    800f3d <memmove+0x4a>
  800f02:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800f06:	48 39 d7             	cmp    %rdx,%rdi
  800f09:	73 32                	jae    800f3d <memmove+0x4a>
        s += n;
        d += n;
  800f0b:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f0f:	48 89 d6             	mov    %rdx,%rsi
  800f12:	48 09 fe             	or     %rdi,%rsi
  800f15:	48 09 ce             	or     %rcx,%rsi
  800f18:	40 f6 c6 07          	test   $0x7,%sil
  800f1c:	75 12                	jne    800f30 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800f1e:	48 83 ef 08          	sub    $0x8,%rdi
  800f22:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800f26:	48 c1 e9 03          	shr    $0x3,%rcx
  800f2a:	fd                   	std
  800f2b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800f2e:	fc                   	cld
  800f2f:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800f30:	48 83 ef 01          	sub    $0x1,%rdi
  800f34:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800f38:	fd                   	std
  800f39:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800f3b:	eb f1                	jmp    800f2e <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f3d:	48 89 f2             	mov    %rsi,%rdx
  800f40:	48 09 c2             	or     %rax,%rdx
  800f43:	48 09 ca             	or     %rcx,%rdx
  800f46:	f6 c2 07             	test   $0x7,%dl
  800f49:	75 0c                	jne    800f57 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800f4b:	48 c1 e9 03          	shr    $0x3,%rcx
  800f4f:	48 89 c7             	mov    %rax,%rdi
  800f52:	fc                   	cld
  800f53:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800f56:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800f57:	48 89 c7             	mov    %rax,%rdi
  800f5a:	fc                   	cld
  800f5b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800f5d:	c3                   	ret

0000000000800f5e <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800f5e:	f3 0f 1e fa          	endbr64
  800f62:	55                   	push   %rbp
  800f63:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800f66:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  800f6d:	00 00 00 
  800f70:	ff d0                	call   *%rax
}
  800f72:	5d                   	pop    %rbp
  800f73:	c3                   	ret

0000000000800f74 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800f74:	f3 0f 1e fa          	endbr64
  800f78:	55                   	push   %rbp
  800f79:	48 89 e5             	mov    %rsp,%rbp
  800f7c:	41 57                	push   %r15
  800f7e:	41 56                	push   %r14
  800f80:	41 55                	push   %r13
  800f82:	41 54                	push   %r12
  800f84:	53                   	push   %rbx
  800f85:	48 83 ec 08          	sub    $0x8,%rsp
  800f89:	49 89 fe             	mov    %rdi,%r14
  800f8c:	49 89 f7             	mov    %rsi,%r15
  800f8f:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800f92:	48 89 f7             	mov    %rsi,%rdi
  800f95:	48 b8 93 0c 80 00 00 	movabs $0x800c93,%rax
  800f9c:	00 00 00 
  800f9f:	ff d0                	call   *%rax
  800fa1:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800fa4:	48 89 de             	mov    %rbx,%rsi
  800fa7:	4c 89 f7             	mov    %r14,%rdi
  800faa:	48 b8 b2 0c 80 00 00 	movabs $0x800cb2,%rax
  800fb1:	00 00 00 
  800fb4:	ff d0                	call   *%rax
  800fb6:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800fb9:	48 39 c3             	cmp    %rax,%rbx
  800fbc:	74 36                	je     800ff4 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800fbe:	48 89 d8             	mov    %rbx,%rax
  800fc1:	4c 29 e8             	sub    %r13,%rax
  800fc4:	49 39 c4             	cmp    %rax,%r12
  800fc7:	73 31                	jae    800ffa <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800fc9:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800fce:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800fd2:	4c 89 fe             	mov    %r15,%rsi
  800fd5:	48 b8 5e 0f 80 00 00 	movabs $0x800f5e,%rax
  800fdc:	00 00 00 
  800fdf:	ff d0                	call   *%rax
    return dstlen + srclen;
  800fe1:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800fe5:	48 83 c4 08          	add    $0x8,%rsp
  800fe9:	5b                   	pop    %rbx
  800fea:	41 5c                	pop    %r12
  800fec:	41 5d                	pop    %r13
  800fee:	41 5e                	pop    %r14
  800ff0:	41 5f                	pop    %r15
  800ff2:	5d                   	pop    %rbp
  800ff3:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800ff4:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800ff8:	eb eb                	jmp    800fe5 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800ffa:	48 83 eb 01          	sub    $0x1,%rbx
  800ffe:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801002:	48 89 da             	mov    %rbx,%rdx
  801005:	4c 89 fe             	mov    %r15,%rsi
  801008:	48 b8 5e 0f 80 00 00 	movabs $0x800f5e,%rax
  80100f:	00 00 00 
  801012:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801014:	49 01 de             	add    %rbx,%r14
  801017:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  80101c:	eb c3                	jmp    800fe1 <strlcat+0x6d>

000000000080101e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  80101e:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801022:	48 85 d2             	test   %rdx,%rdx
  801025:	74 2d                	je     801054 <memcmp+0x36>
  801027:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  80102c:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801030:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  801035:	44 38 c1             	cmp    %r8b,%cl
  801038:	75 0f                	jne    801049 <memcmp+0x2b>
    while (n-- > 0) {
  80103a:	48 83 c0 01          	add    $0x1,%rax
  80103e:	48 39 c2             	cmp    %rax,%rdx
  801041:	75 e9                	jne    80102c <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801043:	b8 00 00 00 00       	mov    $0x0,%eax
  801048:	c3                   	ret
            return (int)*s1 - (int)*s2;
  801049:	0f b6 c1             	movzbl %cl,%eax
  80104c:	45 0f b6 c0          	movzbl %r8b,%r8d
  801050:	44 29 c0             	sub    %r8d,%eax
  801053:	c3                   	ret
    return 0;
  801054:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801059:	c3                   	ret

000000000080105a <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  80105a:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  80105e:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801062:	48 39 c7             	cmp    %rax,%rdi
  801065:	73 0f                	jae    801076 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801067:	40 38 37             	cmp    %sil,(%rdi)
  80106a:	74 0e                	je     80107a <memfind+0x20>
    for (; src < end; src++) {
  80106c:	48 83 c7 01          	add    $0x1,%rdi
  801070:	48 39 f8             	cmp    %rdi,%rax
  801073:	75 f2                	jne    801067 <memfind+0xd>
  801075:	c3                   	ret
  801076:	48 89 f8             	mov    %rdi,%rax
  801079:	c3                   	ret
  80107a:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80107d:	c3                   	ret

000000000080107e <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80107e:	f3 0f 1e fa          	endbr64
  801082:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801085:	0f b6 37             	movzbl (%rdi),%esi
  801088:	40 80 fe 20          	cmp    $0x20,%sil
  80108c:	74 06                	je     801094 <strtol+0x16>
  80108e:	40 80 fe 09          	cmp    $0x9,%sil
  801092:	75 13                	jne    8010a7 <strtol+0x29>
  801094:	48 83 c7 01          	add    $0x1,%rdi
  801098:	0f b6 37             	movzbl (%rdi),%esi
  80109b:	40 80 fe 20          	cmp    $0x20,%sil
  80109f:	74 f3                	je     801094 <strtol+0x16>
  8010a1:	40 80 fe 09          	cmp    $0x9,%sil
  8010a5:	74 ed                	je     801094 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8010a7:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8010aa:	83 e0 fd             	and    $0xfffffffd,%eax
  8010ad:	3c 01                	cmp    $0x1,%al
  8010af:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8010b3:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  8010b9:	75 0f                	jne    8010ca <strtol+0x4c>
  8010bb:	80 3f 30             	cmpb   $0x30,(%rdi)
  8010be:	74 14                	je     8010d4 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8010c0:	85 d2                	test   %edx,%edx
  8010c2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010c7:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  8010ca:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8010cf:	4c 63 ca             	movslq %edx,%r9
  8010d2:	eb 36                	jmp    80110a <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8010d4:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8010d8:	74 0f                	je     8010e9 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  8010da:	85 d2                	test   %edx,%edx
  8010dc:	75 ec                	jne    8010ca <strtol+0x4c>
        s++;
  8010de:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8010e2:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  8010e7:	eb e1                	jmp    8010ca <strtol+0x4c>
        s += 2;
  8010e9:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8010ed:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  8010f2:	eb d6                	jmp    8010ca <strtol+0x4c>
            dig -= '0';
  8010f4:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  8010f7:	44 0f b6 c1          	movzbl %cl,%r8d
  8010fb:	41 39 d0             	cmp    %edx,%r8d
  8010fe:	7d 21                	jge    801121 <strtol+0xa3>
        val = val * base + dig;
  801100:	49 0f af c1          	imul   %r9,%rax
  801104:	0f b6 c9             	movzbl %cl,%ecx
  801107:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  80110a:	48 83 c7 01          	add    $0x1,%rdi
  80110e:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801112:	80 f9 39             	cmp    $0x39,%cl
  801115:	76 dd                	jbe    8010f4 <strtol+0x76>
        else if (dig - 'a' < 27)
  801117:	80 f9 7b             	cmp    $0x7b,%cl
  80111a:	77 05                	ja     801121 <strtol+0xa3>
            dig -= 'a' - 10;
  80111c:	83 e9 57             	sub    $0x57,%ecx
  80111f:	eb d6                	jmp    8010f7 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801121:	4d 85 d2             	test   %r10,%r10
  801124:	74 03                	je     801129 <strtol+0xab>
  801126:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801129:	48 89 c2             	mov    %rax,%rdx
  80112c:	48 f7 da             	neg    %rdx
  80112f:	40 80 fe 2d          	cmp    $0x2d,%sil
  801133:	48 0f 44 c2          	cmove  %rdx,%rax
}
  801137:	c3                   	ret

0000000000801138 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801138:	f3 0f 1e fa          	endbr64
  80113c:	55                   	push   %rbp
  80113d:	48 89 e5             	mov    %rsp,%rbp
  801140:	53                   	push   %rbx
  801141:	48 89 fa             	mov    %rdi,%rdx
  801144:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801147:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80114c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801151:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801156:	be 00 00 00 00       	mov    $0x0,%esi
  80115b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801161:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801163:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801167:	c9                   	leave
  801168:	c3                   	ret

0000000000801169 <sys_cgetc>:

int
sys_cgetc(void) {
  801169:	f3 0f 1e fa          	endbr64
  80116d:	55                   	push   %rbp
  80116e:	48 89 e5             	mov    %rsp,%rbp
  801171:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801172:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801177:	ba 00 00 00 00       	mov    $0x0,%edx
  80117c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801181:	bb 00 00 00 00       	mov    $0x0,%ebx
  801186:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80118b:	be 00 00 00 00       	mov    $0x0,%esi
  801190:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801196:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801198:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80119c:	c9                   	leave
  80119d:	c3                   	ret

000000000080119e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80119e:	f3 0f 1e fa          	endbr64
  8011a2:	55                   	push   %rbp
  8011a3:	48 89 e5             	mov    %rsp,%rbp
  8011a6:	53                   	push   %rbx
  8011a7:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8011ab:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011ae:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011b3:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011bd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011c2:	be 00 00 00 00       	mov    $0x0,%esi
  8011c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011cd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011cf:	48 85 c0             	test   %rax,%rax
  8011d2:	7f 06                	jg     8011da <sys_env_destroy+0x3c>
}
  8011d4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011d8:	c9                   	leave
  8011d9:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011da:	49 89 c0             	mov    %rax,%r8
  8011dd:	b9 03 00 00 00       	mov    $0x3,%ecx
  8011e2:	48 ba 70 40 80 00 00 	movabs $0x804070,%rdx
  8011e9:	00 00 00 
  8011ec:	be 26 00 00 00       	mov    $0x26,%esi
  8011f1:	48 bf dc 42 80 00 00 	movabs $0x8042dc,%rdi
  8011f8:	00 00 00 
  8011fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801200:	49 b9 33 02 80 00 00 	movabs $0x800233,%r9
  801207:	00 00 00 
  80120a:	41 ff d1             	call   *%r9

000000000080120d <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80120d:	f3 0f 1e fa          	endbr64
  801211:	55                   	push   %rbp
  801212:	48 89 e5             	mov    %rsp,%rbp
  801215:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801216:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80121b:	ba 00 00 00 00       	mov    $0x0,%edx
  801220:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801225:	bb 00 00 00 00       	mov    $0x0,%ebx
  80122a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80122f:	be 00 00 00 00       	mov    $0x0,%esi
  801234:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80123a:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80123c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801240:	c9                   	leave
  801241:	c3                   	ret

0000000000801242 <sys_yield>:

void
sys_yield(void) {
  801242:	f3 0f 1e fa          	endbr64
  801246:	55                   	push   %rbp
  801247:	48 89 e5             	mov    %rsp,%rbp
  80124a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80124b:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801250:	ba 00 00 00 00       	mov    $0x0,%edx
  801255:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80125a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80125f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801264:	be 00 00 00 00       	mov    $0x0,%esi
  801269:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80126f:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801271:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801275:	c9                   	leave
  801276:	c3                   	ret

0000000000801277 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801277:	f3 0f 1e fa          	endbr64
  80127b:	55                   	push   %rbp
  80127c:	48 89 e5             	mov    %rsp,%rbp
  80127f:	53                   	push   %rbx
  801280:	48 89 fa             	mov    %rdi,%rdx
  801283:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801286:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80128b:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801292:	00 00 00 
  801295:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80129a:	be 00 00 00 00       	mov    $0x0,%esi
  80129f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012a5:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8012a7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012ab:	c9                   	leave
  8012ac:	c3                   	ret

00000000008012ad <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8012ad:	f3 0f 1e fa          	endbr64
  8012b1:	55                   	push   %rbp
  8012b2:	48 89 e5             	mov    %rsp,%rbp
  8012b5:	53                   	push   %rbx
  8012b6:	49 89 f8             	mov    %rdi,%r8
  8012b9:	48 89 d3             	mov    %rdx,%rbx
  8012bc:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8012bf:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012c4:	4c 89 c2             	mov    %r8,%rdx
  8012c7:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012ca:	be 00 00 00 00       	mov    $0x0,%esi
  8012cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012d5:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8012d7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012db:	c9                   	leave
  8012dc:	c3                   	ret

00000000008012dd <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8012dd:	f3 0f 1e fa          	endbr64
  8012e1:	55                   	push   %rbp
  8012e2:	48 89 e5             	mov    %rsp,%rbp
  8012e5:	53                   	push   %rbx
  8012e6:	48 83 ec 08          	sub    $0x8,%rsp
  8012ea:	89 f8                	mov    %edi,%eax
  8012ec:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8012ef:	48 63 f9             	movslq %ecx,%rdi
  8012f2:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012f5:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012fa:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012fd:	be 00 00 00 00       	mov    $0x0,%esi
  801302:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801308:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80130a:	48 85 c0             	test   %rax,%rax
  80130d:	7f 06                	jg     801315 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  80130f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801313:	c9                   	leave
  801314:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801315:	49 89 c0             	mov    %rax,%r8
  801318:	b9 04 00 00 00       	mov    $0x4,%ecx
  80131d:	48 ba 70 40 80 00 00 	movabs $0x804070,%rdx
  801324:	00 00 00 
  801327:	be 26 00 00 00       	mov    $0x26,%esi
  80132c:	48 bf dc 42 80 00 00 	movabs $0x8042dc,%rdi
  801333:	00 00 00 
  801336:	b8 00 00 00 00       	mov    $0x0,%eax
  80133b:	49 b9 33 02 80 00 00 	movabs $0x800233,%r9
  801342:	00 00 00 
  801345:	41 ff d1             	call   *%r9

0000000000801348 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801348:	f3 0f 1e fa          	endbr64
  80134c:	55                   	push   %rbp
  80134d:	48 89 e5             	mov    %rsp,%rbp
  801350:	53                   	push   %rbx
  801351:	48 83 ec 08          	sub    $0x8,%rsp
  801355:	89 f8                	mov    %edi,%eax
  801357:	49 89 f2             	mov    %rsi,%r10
  80135a:	48 89 cf             	mov    %rcx,%rdi
  80135d:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801360:	48 63 da             	movslq %edx,%rbx
  801363:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801366:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80136b:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80136e:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801371:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801373:	48 85 c0             	test   %rax,%rax
  801376:	7f 06                	jg     80137e <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801378:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80137c:	c9                   	leave
  80137d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80137e:	49 89 c0             	mov    %rax,%r8
  801381:	b9 05 00 00 00       	mov    $0x5,%ecx
  801386:	48 ba 70 40 80 00 00 	movabs $0x804070,%rdx
  80138d:	00 00 00 
  801390:	be 26 00 00 00       	mov    $0x26,%esi
  801395:	48 bf dc 42 80 00 00 	movabs $0x8042dc,%rdi
  80139c:	00 00 00 
  80139f:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a4:	49 b9 33 02 80 00 00 	movabs $0x800233,%r9
  8013ab:	00 00 00 
  8013ae:	41 ff d1             	call   *%r9

00000000008013b1 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8013b1:	f3 0f 1e fa          	endbr64
  8013b5:	55                   	push   %rbp
  8013b6:	48 89 e5             	mov    %rsp,%rbp
  8013b9:	53                   	push   %rbx
  8013ba:	48 83 ec 08          	sub    $0x8,%rsp
  8013be:	49 89 f9             	mov    %rdi,%r9
  8013c1:	89 f0                	mov    %esi,%eax
  8013c3:	48 89 d3             	mov    %rdx,%rbx
  8013c6:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8013c9:	49 63 f0             	movslq %r8d,%rsi
  8013cc:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8013cf:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013d4:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013dd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013df:	48 85 c0             	test   %rax,%rax
  8013e2:	7f 06                	jg     8013ea <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8013e4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013e8:	c9                   	leave
  8013e9:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013ea:	49 89 c0             	mov    %rax,%r8
  8013ed:	b9 06 00 00 00       	mov    $0x6,%ecx
  8013f2:	48 ba 70 40 80 00 00 	movabs $0x804070,%rdx
  8013f9:	00 00 00 
  8013fc:	be 26 00 00 00       	mov    $0x26,%esi
  801401:	48 bf dc 42 80 00 00 	movabs $0x8042dc,%rdi
  801408:	00 00 00 
  80140b:	b8 00 00 00 00       	mov    $0x0,%eax
  801410:	49 b9 33 02 80 00 00 	movabs $0x800233,%r9
  801417:	00 00 00 
  80141a:	41 ff d1             	call   *%r9

000000000080141d <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80141d:	f3 0f 1e fa          	endbr64
  801421:	55                   	push   %rbp
  801422:	48 89 e5             	mov    %rsp,%rbp
  801425:	53                   	push   %rbx
  801426:	48 83 ec 08          	sub    $0x8,%rsp
  80142a:	48 89 f1             	mov    %rsi,%rcx
  80142d:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801430:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801433:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801438:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80143d:	be 00 00 00 00       	mov    $0x0,%esi
  801442:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801448:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80144a:	48 85 c0             	test   %rax,%rax
  80144d:	7f 06                	jg     801455 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80144f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801453:	c9                   	leave
  801454:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801455:	49 89 c0             	mov    %rax,%r8
  801458:	b9 07 00 00 00       	mov    $0x7,%ecx
  80145d:	48 ba 70 40 80 00 00 	movabs $0x804070,%rdx
  801464:	00 00 00 
  801467:	be 26 00 00 00       	mov    $0x26,%esi
  80146c:	48 bf dc 42 80 00 00 	movabs $0x8042dc,%rdi
  801473:	00 00 00 
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	49 b9 33 02 80 00 00 	movabs $0x800233,%r9
  801482:	00 00 00 
  801485:	41 ff d1             	call   *%r9

0000000000801488 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801488:	f3 0f 1e fa          	endbr64
  80148c:	55                   	push   %rbp
  80148d:	48 89 e5             	mov    %rsp,%rbp
  801490:	53                   	push   %rbx
  801491:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801495:	48 63 ce             	movslq %esi,%rcx
  801498:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80149b:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014aa:	be 00 00 00 00       	mov    $0x0,%esi
  8014af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014b5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014b7:	48 85 c0             	test   %rax,%rax
  8014ba:	7f 06                	jg     8014c2 <sys_env_set_status+0x3a>
}
  8014bc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014c0:	c9                   	leave
  8014c1:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014c2:	49 89 c0             	mov    %rax,%r8
  8014c5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014ca:	48 ba 70 40 80 00 00 	movabs $0x804070,%rdx
  8014d1:	00 00 00 
  8014d4:	be 26 00 00 00       	mov    $0x26,%esi
  8014d9:	48 bf dc 42 80 00 00 	movabs $0x8042dc,%rdi
  8014e0:	00 00 00 
  8014e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e8:	49 b9 33 02 80 00 00 	movabs $0x800233,%r9
  8014ef:	00 00 00 
  8014f2:	41 ff d1             	call   *%r9

00000000008014f5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8014f5:	f3 0f 1e fa          	endbr64
  8014f9:	55                   	push   %rbp
  8014fa:	48 89 e5             	mov    %rsp,%rbp
  8014fd:	53                   	push   %rbx
  8014fe:	48 83 ec 08          	sub    $0x8,%rsp
  801502:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801505:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801508:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80150d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801512:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801517:	be 00 00 00 00       	mov    $0x0,%esi
  80151c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801522:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801524:	48 85 c0             	test   %rax,%rax
  801527:	7f 06                	jg     80152f <sys_env_set_trapframe+0x3a>
}
  801529:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80152d:	c9                   	leave
  80152e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80152f:	49 89 c0             	mov    %rax,%r8
  801532:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801537:	48 ba 70 40 80 00 00 	movabs $0x804070,%rdx
  80153e:	00 00 00 
  801541:	be 26 00 00 00       	mov    $0x26,%esi
  801546:	48 bf dc 42 80 00 00 	movabs $0x8042dc,%rdi
  80154d:	00 00 00 
  801550:	b8 00 00 00 00       	mov    $0x0,%eax
  801555:	49 b9 33 02 80 00 00 	movabs $0x800233,%r9
  80155c:	00 00 00 
  80155f:	41 ff d1             	call   *%r9

0000000000801562 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801562:	f3 0f 1e fa          	endbr64
  801566:	55                   	push   %rbp
  801567:	48 89 e5             	mov    %rsp,%rbp
  80156a:	53                   	push   %rbx
  80156b:	48 83 ec 08          	sub    $0x8,%rsp
  80156f:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801572:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801575:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80157a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80157f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801584:	be 00 00 00 00       	mov    $0x0,%esi
  801589:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80158f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801591:	48 85 c0             	test   %rax,%rax
  801594:	7f 06                	jg     80159c <sys_env_set_pgfault_upcall+0x3a>
}
  801596:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80159a:	c9                   	leave
  80159b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80159c:	49 89 c0             	mov    %rax,%r8
  80159f:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8015a4:	48 ba 70 40 80 00 00 	movabs $0x804070,%rdx
  8015ab:	00 00 00 
  8015ae:	be 26 00 00 00       	mov    $0x26,%esi
  8015b3:	48 bf dc 42 80 00 00 	movabs $0x8042dc,%rdi
  8015ba:	00 00 00 
  8015bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c2:	49 b9 33 02 80 00 00 	movabs $0x800233,%r9
  8015c9:	00 00 00 
  8015cc:	41 ff d1             	call   *%r9

00000000008015cf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8015cf:	f3 0f 1e fa          	endbr64
  8015d3:	55                   	push   %rbp
  8015d4:	48 89 e5             	mov    %rsp,%rbp
  8015d7:	53                   	push   %rbx
  8015d8:	89 f8                	mov    %edi,%eax
  8015da:	49 89 f1             	mov    %rsi,%r9
  8015dd:	48 89 d3             	mov    %rdx,%rbx
  8015e0:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8015e3:	49 63 f0             	movslq %r8d,%rsi
  8015e6:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015e9:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015ee:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015f7:	cd 30                	int    $0x30
}
  8015f9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015fd:	c9                   	leave
  8015fe:	c3                   	ret

00000000008015ff <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8015ff:	f3 0f 1e fa          	endbr64
  801603:	55                   	push   %rbp
  801604:	48 89 e5             	mov    %rsp,%rbp
  801607:	53                   	push   %rbx
  801608:	48 83 ec 08          	sub    $0x8,%rsp
  80160c:	48 89 fa             	mov    %rdi,%rdx
  80160f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801612:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801617:	bb 00 00 00 00       	mov    $0x0,%ebx
  80161c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801621:	be 00 00 00 00       	mov    $0x0,%esi
  801626:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80162c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80162e:	48 85 c0             	test   %rax,%rax
  801631:	7f 06                	jg     801639 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801633:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801637:	c9                   	leave
  801638:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801639:	49 89 c0             	mov    %rax,%r8
  80163c:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801641:	48 ba 70 40 80 00 00 	movabs $0x804070,%rdx
  801648:	00 00 00 
  80164b:	be 26 00 00 00       	mov    $0x26,%esi
  801650:	48 bf dc 42 80 00 00 	movabs $0x8042dc,%rdi
  801657:	00 00 00 
  80165a:	b8 00 00 00 00       	mov    $0x0,%eax
  80165f:	49 b9 33 02 80 00 00 	movabs $0x800233,%r9
  801666:	00 00 00 
  801669:	41 ff d1             	call   *%r9

000000000080166c <sys_gettime>:

int
sys_gettime(void) {
  80166c:	f3 0f 1e fa          	endbr64
  801670:	55                   	push   %rbp
  801671:	48 89 e5             	mov    %rsp,%rbp
  801674:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801675:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80167a:	ba 00 00 00 00       	mov    $0x0,%edx
  80167f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801684:	bb 00 00 00 00       	mov    $0x0,%ebx
  801689:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80168e:	be 00 00 00 00       	mov    $0x0,%esi
  801693:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801699:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80169b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80169f:	c9                   	leave
  8016a0:	c3                   	ret

00000000008016a1 <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8016a1:	f3 0f 1e fa          	endbr64
  8016a5:	55                   	push   %rbp
  8016a6:	48 89 e5             	mov    %rsp,%rbp
  8016a9:	41 56                	push   %r14
  8016ab:	41 55                	push   %r13
  8016ad:	41 54                	push   %r12
  8016af:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  8016b0:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  8016b7:	00 00 00 
  8016ba:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8016c1:	b8 09 00 00 00       	mov    $0x9,%eax
  8016c6:	cd 30                	int    $0x30
  8016c8:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	78 7f                	js     80174e <fork+0xad>
  8016cf:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  8016d1:	0f 84 83 00 00 00    	je     80175a <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  8016d7:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  8016dd:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  8016e4:	00 00 00 
  8016e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016ec:	89 c2                	mov    %eax,%edx
  8016ee:	be 00 00 00 00       	mov    $0x0,%esi
  8016f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f8:	48 b8 48 13 80 00 00 	movabs $0x801348,%rax
  8016ff:	00 00 00 
  801702:	ff d0                	call   *%rax
  801704:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  801707:	85 c0                	test   %eax,%eax
  801709:	0f 88 81 00 00 00    	js     801790 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  80170f:	4d 85 f6             	test   %r14,%r14
  801712:	74 20                	je     801734 <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801714:	48 be 64 2d 80 00 00 	movabs $0x802d64,%rsi
  80171b:	00 00 00 
  80171e:	44 89 e7             	mov    %r12d,%edi
  801721:	48 b8 62 15 80 00 00 	movabs $0x801562,%rax
  801728:	00 00 00 
  80172b:	ff d0                	call   *%rax
  80172d:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  801730:	85 c0                	test   %eax,%eax
  801732:	78 70                	js     8017a4 <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801734:	be 02 00 00 00       	mov    $0x2,%esi
  801739:	89 df                	mov    %ebx,%edi
  80173b:	48 b8 88 14 80 00 00 	movabs $0x801488,%rax
  801742:	00 00 00 
  801745:	ff d0                	call   *%rax
  801747:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  80174a:	85 c0                	test   %eax,%eax
  80174c:	78 6a                	js     8017b8 <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  80174e:	44 89 e0             	mov    %r12d,%eax
  801751:	5b                   	pop    %rbx
  801752:	41 5c                	pop    %r12
  801754:	41 5d                	pop    %r13
  801756:	41 5e                	pop    %r14
  801758:	5d                   	pop    %rbp
  801759:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  80175a:	48 b8 0d 12 80 00 00 	movabs $0x80120d,%rax
  801761:	00 00 00 
  801764:	ff d0                	call   *%rax
  801766:	25 ff 03 00 00       	and    $0x3ff,%eax
  80176b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80176f:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801773:	48 c1 e0 04          	shl    $0x4,%rax
  801777:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  80177e:	00 00 00 
  801781:	48 01 d0             	add    %rdx,%rax
  801784:	48 a3 08 60 80 00 00 	movabs %rax,0x806008
  80178b:	00 00 00 
        return 0;
  80178e:	eb be                	jmp    80174e <fork+0xad>
        sys_env_destroy(envid);
  801790:	44 89 e7             	mov    %r12d,%edi
  801793:	48 b8 9e 11 80 00 00 	movabs $0x80119e,%rax
  80179a:	00 00 00 
  80179d:	ff d0                	call   *%rax
        return res;
  80179f:	45 89 ec             	mov    %r13d,%r12d
  8017a2:	eb aa                	jmp    80174e <fork+0xad>
            sys_env_destroy(envid);
  8017a4:	44 89 e7             	mov    %r12d,%edi
  8017a7:	48 b8 9e 11 80 00 00 	movabs $0x80119e,%rax
  8017ae:	00 00 00 
  8017b1:	ff d0                	call   *%rax
            return res;
  8017b3:	45 89 ec             	mov    %r13d,%r12d
  8017b6:	eb 96                	jmp    80174e <fork+0xad>
        sys_env_destroy(envid);
  8017b8:	89 df                	mov    %ebx,%edi
  8017ba:	48 b8 9e 11 80 00 00 	movabs $0x80119e,%rax
  8017c1:	00 00 00 
  8017c4:	ff d0                	call   *%rax
        return res;
  8017c6:	45 89 ec             	mov    %r13d,%r12d
  8017c9:	eb 83                	jmp    80174e <fork+0xad>

00000000008017cb <sfork>:

envid_t
sfork() {
  8017cb:	f3 0f 1e fa          	endbr64
  8017cf:	55                   	push   %rbp
  8017d0:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  8017d3:	48 ba ea 42 80 00 00 	movabs $0x8042ea,%rdx
  8017da:	00 00 00 
  8017dd:	be 37 00 00 00       	mov    $0x37,%esi
  8017e2:	48 bf 05 43 80 00 00 	movabs $0x804305,%rdi
  8017e9:	00 00 00 
  8017ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f1:	48 b9 33 02 80 00 00 	movabs $0x800233,%rcx
  8017f8:	00 00 00 
  8017fb:	ff d1                	call   *%rcx

00000000008017fd <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  8017fd:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801801:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801808:	ff ff ff 
  80180b:	48 01 f8             	add    %rdi,%rax
  80180e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801812:	c3                   	ret

0000000000801813 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801813:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801817:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80181e:	ff ff ff 
  801821:	48 01 f8             	add    %rdi,%rax
  801824:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801828:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80182e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801832:	c3                   	ret

0000000000801833 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801833:	f3 0f 1e fa          	endbr64
  801837:	55                   	push   %rbp
  801838:	48 89 e5             	mov    %rsp,%rbp
  80183b:	41 57                	push   %r15
  80183d:	41 56                	push   %r14
  80183f:	41 55                	push   %r13
  801841:	41 54                	push   %r12
  801843:	53                   	push   %rbx
  801844:	48 83 ec 08          	sub    $0x8,%rsp
  801848:	49 89 ff             	mov    %rdi,%r15
  80184b:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801850:	49 bd 92 29 80 00 00 	movabs $0x802992,%r13
  801857:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80185a:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801860:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801863:	48 89 df             	mov    %rbx,%rdi
  801866:	41 ff d5             	call   *%r13
  801869:	83 e0 04             	and    $0x4,%eax
  80186c:	74 17                	je     801885 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  80186e:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801875:	4c 39 f3             	cmp    %r14,%rbx
  801878:	75 e6                	jne    801860 <fd_alloc+0x2d>
  80187a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801880:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801885:	4d 89 27             	mov    %r12,(%r15)
}
  801888:	48 83 c4 08          	add    $0x8,%rsp
  80188c:	5b                   	pop    %rbx
  80188d:	41 5c                	pop    %r12
  80188f:	41 5d                	pop    %r13
  801891:	41 5e                	pop    %r14
  801893:	41 5f                	pop    %r15
  801895:	5d                   	pop    %rbp
  801896:	c3                   	ret

0000000000801897 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801897:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  80189b:	83 ff 1f             	cmp    $0x1f,%edi
  80189e:	77 39                	ja     8018d9 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8018a0:	55                   	push   %rbp
  8018a1:	48 89 e5             	mov    %rsp,%rbp
  8018a4:	41 54                	push   %r12
  8018a6:	53                   	push   %rbx
  8018a7:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8018aa:	48 63 df             	movslq %edi,%rbx
  8018ad:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8018b4:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8018b8:	48 89 df             	mov    %rbx,%rdi
  8018bb:	48 b8 92 29 80 00 00 	movabs $0x802992,%rax
  8018c2:	00 00 00 
  8018c5:	ff d0                	call   *%rax
  8018c7:	a8 04                	test   $0x4,%al
  8018c9:	74 14                	je     8018df <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8018cb:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8018cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d4:	5b                   	pop    %rbx
  8018d5:	41 5c                	pop    %r12
  8018d7:	5d                   	pop    %rbp
  8018d8:	c3                   	ret
        return -E_INVAL;
  8018d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018de:	c3                   	ret
        return -E_INVAL;
  8018df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018e4:	eb ee                	jmp    8018d4 <fd_lookup+0x3d>

00000000008018e6 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8018e6:	f3 0f 1e fa          	endbr64
  8018ea:	55                   	push   %rbp
  8018eb:	48 89 e5             	mov    %rsp,%rbp
  8018ee:	41 54                	push   %r12
  8018f0:	53                   	push   %rbx
  8018f1:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  8018f4:	48 b8 60 47 80 00 00 	movabs $0x804760,%rax
  8018fb:	00 00 00 
  8018fe:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801905:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801908:	39 3b                	cmp    %edi,(%rbx)
  80190a:	74 47                	je     801953 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  80190c:	48 83 c0 08          	add    $0x8,%rax
  801910:	48 8b 18             	mov    (%rax),%rbx
  801913:	48 85 db             	test   %rbx,%rbx
  801916:	75 f0                	jne    801908 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801918:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  80191f:	00 00 00 
  801922:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801928:	89 fa                	mov    %edi,%edx
  80192a:	48 bf 90 40 80 00 00 	movabs $0x804090,%rdi
  801931:	00 00 00 
  801934:	b8 00 00 00 00       	mov    $0x0,%eax
  801939:	48 b9 8f 03 80 00 00 	movabs $0x80038f,%rcx
  801940:	00 00 00 
  801943:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801945:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  80194a:	49 89 1c 24          	mov    %rbx,(%r12)
}
  80194e:	5b                   	pop    %rbx
  80194f:	41 5c                	pop    %r12
  801951:	5d                   	pop    %rbp
  801952:	c3                   	ret
            return 0;
  801953:	b8 00 00 00 00       	mov    $0x0,%eax
  801958:	eb f0                	jmp    80194a <dev_lookup+0x64>

000000000080195a <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80195a:	f3 0f 1e fa          	endbr64
  80195e:	55                   	push   %rbp
  80195f:	48 89 e5             	mov    %rsp,%rbp
  801962:	41 55                	push   %r13
  801964:	41 54                	push   %r12
  801966:	53                   	push   %rbx
  801967:	48 83 ec 18          	sub    $0x18,%rsp
  80196b:	48 89 fb             	mov    %rdi,%rbx
  80196e:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801971:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801978:	ff ff ff 
  80197b:	48 01 df             	add    %rbx,%rdi
  80197e:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801982:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801986:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  80198d:	00 00 00 
  801990:	ff d0                	call   *%rax
  801992:	41 89 c5             	mov    %eax,%r13d
  801995:	85 c0                	test   %eax,%eax
  801997:	78 06                	js     80199f <fd_close+0x45>
  801999:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  80199d:	74 1a                	je     8019b9 <fd_close+0x5f>
        return (must_exist ? res : 0);
  80199f:	45 84 e4             	test   %r12b,%r12b
  8019a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a7:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8019ab:	44 89 e8             	mov    %r13d,%eax
  8019ae:	48 83 c4 18          	add    $0x18,%rsp
  8019b2:	5b                   	pop    %rbx
  8019b3:	41 5c                	pop    %r12
  8019b5:	41 5d                	pop    %r13
  8019b7:	5d                   	pop    %rbp
  8019b8:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019b9:	8b 3b                	mov    (%rbx),%edi
  8019bb:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8019bf:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  8019c6:	00 00 00 
  8019c9:	ff d0                	call   *%rax
  8019cb:	41 89 c5             	mov    %eax,%r13d
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	78 1b                	js     8019ed <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8019d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019d6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8019da:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8019e0:	48 85 c0             	test   %rax,%rax
  8019e3:	74 08                	je     8019ed <fd_close+0x93>
  8019e5:	48 89 df             	mov    %rbx,%rdi
  8019e8:	ff d0                	call   *%rax
  8019ea:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8019ed:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019f2:	48 89 de             	mov    %rbx,%rsi
  8019f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8019fa:	48 b8 1d 14 80 00 00 	movabs $0x80141d,%rax
  801a01:	00 00 00 
  801a04:	ff d0                	call   *%rax
    return res;
  801a06:	eb a3                	jmp    8019ab <fd_close+0x51>

0000000000801a08 <close>:

int
close(int fdnum) {
  801a08:	f3 0f 1e fa          	endbr64
  801a0c:	55                   	push   %rbp
  801a0d:	48 89 e5             	mov    %rsp,%rbp
  801a10:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801a14:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801a18:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  801a1f:	00 00 00 
  801a22:	ff d0                	call   *%rax
    if (res < 0) return res;
  801a24:	85 c0                	test   %eax,%eax
  801a26:	78 15                	js     801a3d <close+0x35>

    return fd_close(fd, 1);
  801a28:	be 01 00 00 00       	mov    $0x1,%esi
  801a2d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801a31:	48 b8 5a 19 80 00 00 	movabs $0x80195a,%rax
  801a38:	00 00 00 
  801a3b:	ff d0                	call   *%rax
}
  801a3d:	c9                   	leave
  801a3e:	c3                   	ret

0000000000801a3f <close_all>:

void
close_all(void) {
  801a3f:	f3 0f 1e fa          	endbr64
  801a43:	55                   	push   %rbp
  801a44:	48 89 e5             	mov    %rsp,%rbp
  801a47:	41 54                	push   %r12
  801a49:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801a4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a4f:	49 bc 08 1a 80 00 00 	movabs $0x801a08,%r12
  801a56:	00 00 00 
  801a59:	89 df                	mov    %ebx,%edi
  801a5b:	41 ff d4             	call   *%r12
  801a5e:	83 c3 01             	add    $0x1,%ebx
  801a61:	83 fb 20             	cmp    $0x20,%ebx
  801a64:	75 f3                	jne    801a59 <close_all+0x1a>
}
  801a66:	5b                   	pop    %rbx
  801a67:	41 5c                	pop    %r12
  801a69:	5d                   	pop    %rbp
  801a6a:	c3                   	ret

0000000000801a6b <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801a6b:	f3 0f 1e fa          	endbr64
  801a6f:	55                   	push   %rbp
  801a70:	48 89 e5             	mov    %rsp,%rbp
  801a73:	41 57                	push   %r15
  801a75:	41 56                	push   %r14
  801a77:	41 55                	push   %r13
  801a79:	41 54                	push   %r12
  801a7b:	53                   	push   %rbx
  801a7c:	48 83 ec 18          	sub    $0x18,%rsp
  801a80:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801a83:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801a87:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  801a8e:	00 00 00 
  801a91:	ff d0                	call   *%rax
  801a93:	89 c3                	mov    %eax,%ebx
  801a95:	85 c0                	test   %eax,%eax
  801a97:	0f 88 b8 00 00 00    	js     801b55 <dup+0xea>
    close(newfdnum);
  801a9d:	44 89 e7             	mov    %r12d,%edi
  801aa0:	48 b8 08 1a 80 00 00 	movabs $0x801a08,%rax
  801aa7:	00 00 00 
  801aaa:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801aac:	4d 63 ec             	movslq %r12d,%r13
  801aaf:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801ab6:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801aba:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801abe:	4c 89 ff             	mov    %r15,%rdi
  801ac1:	49 be 13 18 80 00 00 	movabs $0x801813,%r14
  801ac8:	00 00 00 
  801acb:	41 ff d6             	call   *%r14
  801ace:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801ad1:	4c 89 ef             	mov    %r13,%rdi
  801ad4:	41 ff d6             	call   *%r14
  801ad7:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801ada:	48 89 df             	mov    %rbx,%rdi
  801add:	48 b8 92 29 80 00 00 	movabs $0x802992,%rax
  801ae4:	00 00 00 
  801ae7:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801ae9:	a8 04                	test   $0x4,%al
  801aeb:	74 2b                	je     801b18 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801aed:	41 89 c1             	mov    %eax,%r9d
  801af0:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801af6:	4c 89 f1             	mov    %r14,%rcx
  801af9:	ba 00 00 00 00       	mov    $0x0,%edx
  801afe:	48 89 de             	mov    %rbx,%rsi
  801b01:	bf 00 00 00 00       	mov    $0x0,%edi
  801b06:	48 b8 48 13 80 00 00 	movabs $0x801348,%rax
  801b0d:	00 00 00 
  801b10:	ff d0                	call   *%rax
  801b12:	89 c3                	mov    %eax,%ebx
  801b14:	85 c0                	test   %eax,%eax
  801b16:	78 4e                	js     801b66 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801b18:	4c 89 ff             	mov    %r15,%rdi
  801b1b:	48 b8 92 29 80 00 00 	movabs $0x802992,%rax
  801b22:	00 00 00 
  801b25:	ff d0                	call   *%rax
  801b27:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801b2a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801b30:	4c 89 e9             	mov    %r13,%rcx
  801b33:	ba 00 00 00 00       	mov    $0x0,%edx
  801b38:	4c 89 fe             	mov    %r15,%rsi
  801b3b:	bf 00 00 00 00       	mov    $0x0,%edi
  801b40:	48 b8 48 13 80 00 00 	movabs $0x801348,%rax
  801b47:	00 00 00 
  801b4a:	ff d0                	call   *%rax
  801b4c:	89 c3                	mov    %eax,%ebx
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	78 14                	js     801b66 <dup+0xfb>

    return newfdnum;
  801b52:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801b55:	89 d8                	mov    %ebx,%eax
  801b57:	48 83 c4 18          	add    $0x18,%rsp
  801b5b:	5b                   	pop    %rbx
  801b5c:	41 5c                	pop    %r12
  801b5e:	41 5d                	pop    %r13
  801b60:	41 5e                	pop    %r14
  801b62:	41 5f                	pop    %r15
  801b64:	5d                   	pop    %rbp
  801b65:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801b66:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b6b:	4c 89 ee             	mov    %r13,%rsi
  801b6e:	bf 00 00 00 00       	mov    $0x0,%edi
  801b73:	49 bc 1d 14 80 00 00 	movabs $0x80141d,%r12
  801b7a:	00 00 00 
  801b7d:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801b80:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b85:	4c 89 f6             	mov    %r14,%rsi
  801b88:	bf 00 00 00 00       	mov    $0x0,%edi
  801b8d:	41 ff d4             	call   *%r12
    return res;
  801b90:	eb c3                	jmp    801b55 <dup+0xea>

0000000000801b92 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801b92:	f3 0f 1e fa          	endbr64
  801b96:	55                   	push   %rbp
  801b97:	48 89 e5             	mov    %rsp,%rbp
  801b9a:	41 56                	push   %r14
  801b9c:	41 55                	push   %r13
  801b9e:	41 54                	push   %r12
  801ba0:	53                   	push   %rbx
  801ba1:	48 83 ec 10          	sub    $0x10,%rsp
  801ba5:	89 fb                	mov    %edi,%ebx
  801ba7:	49 89 f4             	mov    %rsi,%r12
  801baa:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bad:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801bb1:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  801bb8:	00 00 00 
  801bbb:	ff d0                	call   *%rax
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	78 4c                	js     801c0d <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801bc1:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801bc5:	41 8b 3e             	mov    (%r14),%edi
  801bc8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801bcc:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801bd3:	00 00 00 
  801bd6:	ff d0                	call   *%rax
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	78 35                	js     801c11 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801bdc:	41 8b 46 08          	mov    0x8(%r14),%eax
  801be0:	83 e0 03             	and    $0x3,%eax
  801be3:	83 f8 01             	cmp    $0x1,%eax
  801be6:	74 2d                	je     801c15 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801be8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bec:	48 8b 40 10          	mov    0x10(%rax),%rax
  801bf0:	48 85 c0             	test   %rax,%rax
  801bf3:	74 56                	je     801c4b <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801bf5:	4c 89 ea             	mov    %r13,%rdx
  801bf8:	4c 89 e6             	mov    %r12,%rsi
  801bfb:	4c 89 f7             	mov    %r14,%rdi
  801bfe:	ff d0                	call   *%rax
}
  801c00:	48 83 c4 10          	add    $0x10,%rsp
  801c04:	5b                   	pop    %rbx
  801c05:	41 5c                	pop    %r12
  801c07:	41 5d                	pop    %r13
  801c09:	41 5e                	pop    %r14
  801c0b:	5d                   	pop    %rbp
  801c0c:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c0d:	48 98                	cltq
  801c0f:	eb ef                	jmp    801c00 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c11:	48 98                	cltq
  801c13:	eb eb                	jmp    801c00 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c15:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  801c1c:	00 00 00 
  801c1f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c25:	89 da                	mov    %ebx,%edx
  801c27:	48 bf 10 43 80 00 00 	movabs $0x804310,%rdi
  801c2e:	00 00 00 
  801c31:	b8 00 00 00 00       	mov    $0x0,%eax
  801c36:	48 b9 8f 03 80 00 00 	movabs $0x80038f,%rcx
  801c3d:	00 00 00 
  801c40:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c42:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801c49:	eb b5                	jmp    801c00 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801c4b:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801c52:	eb ac                	jmp    801c00 <read+0x6e>

0000000000801c54 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801c54:	f3 0f 1e fa          	endbr64
  801c58:	55                   	push   %rbp
  801c59:	48 89 e5             	mov    %rsp,%rbp
  801c5c:	41 57                	push   %r15
  801c5e:	41 56                	push   %r14
  801c60:	41 55                	push   %r13
  801c62:	41 54                	push   %r12
  801c64:	53                   	push   %rbx
  801c65:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801c69:	48 85 d2             	test   %rdx,%rdx
  801c6c:	74 54                	je     801cc2 <readn+0x6e>
  801c6e:	41 89 fd             	mov    %edi,%r13d
  801c71:	49 89 f6             	mov    %rsi,%r14
  801c74:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801c77:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801c7c:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801c81:	49 bf 92 1b 80 00 00 	movabs $0x801b92,%r15
  801c88:	00 00 00 
  801c8b:	4c 89 e2             	mov    %r12,%rdx
  801c8e:	48 29 f2             	sub    %rsi,%rdx
  801c91:	4c 01 f6             	add    %r14,%rsi
  801c94:	44 89 ef             	mov    %r13d,%edi
  801c97:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801c9a:	85 c0                	test   %eax,%eax
  801c9c:	78 20                	js     801cbe <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801c9e:	01 c3                	add    %eax,%ebx
  801ca0:	85 c0                	test   %eax,%eax
  801ca2:	74 08                	je     801cac <readn+0x58>
  801ca4:	48 63 f3             	movslq %ebx,%rsi
  801ca7:	4c 39 e6             	cmp    %r12,%rsi
  801caa:	72 df                	jb     801c8b <readn+0x37>
    }
    return res;
  801cac:	48 63 c3             	movslq %ebx,%rax
}
  801caf:	48 83 c4 08          	add    $0x8,%rsp
  801cb3:	5b                   	pop    %rbx
  801cb4:	41 5c                	pop    %r12
  801cb6:	41 5d                	pop    %r13
  801cb8:	41 5e                	pop    %r14
  801cba:	41 5f                	pop    %r15
  801cbc:	5d                   	pop    %rbp
  801cbd:	c3                   	ret
        if (inc < 0) return inc;
  801cbe:	48 98                	cltq
  801cc0:	eb ed                	jmp    801caf <readn+0x5b>
    int inc = 1, res = 0;
  801cc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cc7:	eb e3                	jmp    801cac <readn+0x58>

0000000000801cc9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801cc9:	f3 0f 1e fa          	endbr64
  801ccd:	55                   	push   %rbp
  801cce:	48 89 e5             	mov    %rsp,%rbp
  801cd1:	41 56                	push   %r14
  801cd3:	41 55                	push   %r13
  801cd5:	41 54                	push   %r12
  801cd7:	53                   	push   %rbx
  801cd8:	48 83 ec 10          	sub    $0x10,%rsp
  801cdc:	89 fb                	mov    %edi,%ebx
  801cde:	49 89 f4             	mov    %rsi,%r12
  801ce1:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ce4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ce8:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  801cef:	00 00 00 
  801cf2:	ff d0                	call   *%rax
  801cf4:	85 c0                	test   %eax,%eax
  801cf6:	78 47                	js     801d3f <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cf8:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801cfc:	41 8b 3e             	mov    (%r14),%edi
  801cff:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d03:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801d0a:	00 00 00 
  801d0d:	ff d0                	call   *%rax
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	78 30                	js     801d43 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d13:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801d18:	74 2d                	je     801d47 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801d1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d1e:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d22:	48 85 c0             	test   %rax,%rax
  801d25:	74 56                	je     801d7d <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801d27:	4c 89 ea             	mov    %r13,%rdx
  801d2a:	4c 89 e6             	mov    %r12,%rsi
  801d2d:	4c 89 f7             	mov    %r14,%rdi
  801d30:	ff d0                	call   *%rax
}
  801d32:	48 83 c4 10          	add    $0x10,%rsp
  801d36:	5b                   	pop    %rbx
  801d37:	41 5c                	pop    %r12
  801d39:	41 5d                	pop    %r13
  801d3b:	41 5e                	pop    %r14
  801d3d:	5d                   	pop    %rbp
  801d3e:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d3f:	48 98                	cltq
  801d41:	eb ef                	jmp    801d32 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d43:	48 98                	cltq
  801d45:	eb eb                	jmp    801d32 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801d47:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  801d4e:	00 00 00 
  801d51:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d57:	89 da                	mov    %ebx,%edx
  801d59:	48 bf 2c 43 80 00 00 	movabs $0x80432c,%rdi
  801d60:	00 00 00 
  801d63:	b8 00 00 00 00       	mov    $0x0,%eax
  801d68:	48 b9 8f 03 80 00 00 	movabs $0x80038f,%rcx
  801d6f:	00 00 00 
  801d72:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d74:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801d7b:	eb b5                	jmp    801d32 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801d7d:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801d84:	eb ac                	jmp    801d32 <write+0x69>

0000000000801d86 <seek>:

int
seek(int fdnum, off_t offset) {
  801d86:	f3 0f 1e fa          	endbr64
  801d8a:	55                   	push   %rbp
  801d8b:	48 89 e5             	mov    %rsp,%rbp
  801d8e:	53                   	push   %rbx
  801d8f:	48 83 ec 18          	sub    $0x18,%rsp
  801d93:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d95:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801d99:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  801da0:	00 00 00 
  801da3:	ff d0                	call   *%rax
  801da5:	85 c0                	test   %eax,%eax
  801da7:	78 0c                	js     801db5 <seek+0x2f>

    fd->fd_offset = offset;
  801da9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dad:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801db0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801db9:	c9                   	leave
  801dba:	c3                   	ret

0000000000801dbb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801dbb:	f3 0f 1e fa          	endbr64
  801dbf:	55                   	push   %rbp
  801dc0:	48 89 e5             	mov    %rsp,%rbp
  801dc3:	41 55                	push   %r13
  801dc5:	41 54                	push   %r12
  801dc7:	53                   	push   %rbx
  801dc8:	48 83 ec 18          	sub    $0x18,%rsp
  801dcc:	89 fb                	mov    %edi,%ebx
  801dce:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dd1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801dd5:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  801ddc:	00 00 00 
  801ddf:	ff d0                	call   *%rax
  801de1:	85 c0                	test   %eax,%eax
  801de3:	78 38                	js     801e1d <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801de5:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801de9:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801ded:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801df1:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801df8:	00 00 00 
  801dfb:	ff d0                	call   *%rax
  801dfd:	85 c0                	test   %eax,%eax
  801dff:	78 1c                	js     801e1d <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e01:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801e06:	74 20                	je     801e28 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801e08:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e0c:	48 8b 40 30          	mov    0x30(%rax),%rax
  801e10:	48 85 c0             	test   %rax,%rax
  801e13:	74 47                	je     801e5c <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801e15:	44 89 e6             	mov    %r12d,%esi
  801e18:	4c 89 ef             	mov    %r13,%rdi
  801e1b:	ff d0                	call   *%rax
}
  801e1d:	48 83 c4 18          	add    $0x18,%rsp
  801e21:	5b                   	pop    %rbx
  801e22:	41 5c                	pop    %r12
  801e24:	41 5d                	pop    %r13
  801e26:	5d                   	pop    %rbp
  801e27:	c3                   	ret
                thisenv->env_id, fdnum);
  801e28:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  801e2f:	00 00 00 
  801e32:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e38:	89 da                	mov    %ebx,%edx
  801e3a:	48 bf b0 40 80 00 00 	movabs $0x8040b0,%rdi
  801e41:	00 00 00 
  801e44:	b8 00 00 00 00       	mov    $0x0,%eax
  801e49:	48 b9 8f 03 80 00 00 	movabs $0x80038f,%rcx
  801e50:	00 00 00 
  801e53:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e5a:	eb c1                	jmp    801e1d <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801e5c:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801e61:	eb ba                	jmp    801e1d <ftruncate+0x62>

0000000000801e63 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801e63:	f3 0f 1e fa          	endbr64
  801e67:	55                   	push   %rbp
  801e68:	48 89 e5             	mov    %rsp,%rbp
  801e6b:	41 54                	push   %r12
  801e6d:	53                   	push   %rbx
  801e6e:	48 83 ec 10          	sub    $0x10,%rsp
  801e72:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e75:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801e79:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  801e80:	00 00 00 
  801e83:	ff d0                	call   *%rax
  801e85:	85 c0                	test   %eax,%eax
  801e87:	78 4e                	js     801ed7 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e89:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801e8d:	41 8b 3c 24          	mov    (%r12),%edi
  801e91:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801e95:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801e9c:	00 00 00 
  801e9f:	ff d0                	call   *%rax
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	78 32                	js     801ed7 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801ea5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ea9:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801eae:	74 30                	je     801ee0 <fstat+0x7d>

    stat->st_name[0] = 0;
  801eb0:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801eb3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801eba:	00 00 00 
    stat->st_isdir = 0;
  801ebd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ec4:	00 00 00 
    stat->st_dev = dev;
  801ec7:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801ece:	48 89 de             	mov    %rbx,%rsi
  801ed1:	4c 89 e7             	mov    %r12,%rdi
  801ed4:	ff 50 28             	call   *0x28(%rax)
}
  801ed7:	48 83 c4 10          	add    $0x10,%rsp
  801edb:	5b                   	pop    %rbx
  801edc:	41 5c                	pop    %r12
  801ede:	5d                   	pop    %rbp
  801edf:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801ee0:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ee5:	eb f0                	jmp    801ed7 <fstat+0x74>

0000000000801ee7 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801ee7:	f3 0f 1e fa          	endbr64
  801eeb:	55                   	push   %rbp
  801eec:	48 89 e5             	mov    %rsp,%rbp
  801eef:	41 54                	push   %r12
  801ef1:	53                   	push   %rbx
  801ef2:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801ef5:	be 00 00 00 00       	mov    $0x0,%esi
  801efa:	48 b8 c8 21 80 00 00 	movabs $0x8021c8,%rax
  801f01:	00 00 00 
  801f04:	ff d0                	call   *%rax
  801f06:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	78 25                	js     801f31 <stat+0x4a>

    int res = fstat(fd, stat);
  801f0c:	4c 89 e6             	mov    %r12,%rsi
  801f0f:	89 c7                	mov    %eax,%edi
  801f11:	48 b8 63 1e 80 00 00 	movabs $0x801e63,%rax
  801f18:	00 00 00 
  801f1b:	ff d0                	call   *%rax
  801f1d:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801f20:	89 df                	mov    %ebx,%edi
  801f22:	48 b8 08 1a 80 00 00 	movabs $0x801a08,%rax
  801f29:	00 00 00 
  801f2c:	ff d0                	call   *%rax

    return res;
  801f2e:	44 89 e3             	mov    %r12d,%ebx
}
  801f31:	89 d8                	mov    %ebx,%eax
  801f33:	5b                   	pop    %rbx
  801f34:	41 5c                	pop    %r12
  801f36:	5d                   	pop    %rbp
  801f37:	c3                   	ret

0000000000801f38 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801f38:	f3 0f 1e fa          	endbr64
  801f3c:	55                   	push   %rbp
  801f3d:	48 89 e5             	mov    %rsp,%rbp
  801f40:	41 54                	push   %r12
  801f42:	53                   	push   %rbx
  801f43:	48 83 ec 10          	sub    $0x10,%rsp
  801f47:	41 89 fc             	mov    %edi,%r12d
  801f4a:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801f4d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801f54:	00 00 00 
  801f57:	83 38 00             	cmpl   $0x0,(%rax)
  801f5a:	74 6e                	je     801fca <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801f5c:	bf 03 00 00 00       	mov    $0x3,%edi
  801f61:	48 b8 45 2f 80 00 00 	movabs $0x802f45,%rax
  801f68:	00 00 00 
  801f6b:	ff d0                	call   *%rax
  801f6d:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801f74:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801f76:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801f7c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801f81:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  801f88:	00 00 00 
  801f8b:	44 89 e6             	mov    %r12d,%esi
  801f8e:	89 c7                	mov    %eax,%edi
  801f90:	48 b8 83 2e 80 00 00 	movabs $0x802e83,%rax
  801f97:	00 00 00 
  801f9a:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801f9c:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801fa3:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801fa4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fa9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fad:	48 89 de             	mov    %rbx,%rsi
  801fb0:	bf 00 00 00 00       	mov    $0x0,%edi
  801fb5:	48 b8 ea 2d 80 00 00 	movabs $0x802dea,%rax
  801fbc:	00 00 00 
  801fbf:	ff d0                	call   *%rax
}
  801fc1:	48 83 c4 10          	add    $0x10,%rsp
  801fc5:	5b                   	pop    %rbx
  801fc6:	41 5c                	pop    %r12
  801fc8:	5d                   	pop    %rbp
  801fc9:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801fca:	bf 03 00 00 00       	mov    $0x3,%edi
  801fcf:	48 b8 45 2f 80 00 00 	movabs $0x802f45,%rax
  801fd6:	00 00 00 
  801fd9:	ff d0                	call   *%rax
  801fdb:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801fe2:	00 00 
  801fe4:	e9 73 ff ff ff       	jmp    801f5c <fsipc+0x24>

0000000000801fe9 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801fe9:	f3 0f 1e fa          	endbr64
  801fed:	55                   	push   %rbp
  801fee:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ff1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801ff8:	00 00 00 
  801ffb:	8b 57 0c             	mov    0xc(%rdi),%edx
  801ffe:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802000:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802003:	be 00 00 00 00       	mov    $0x0,%esi
  802008:	bf 02 00 00 00       	mov    $0x2,%edi
  80200d:	48 b8 38 1f 80 00 00 	movabs $0x801f38,%rax
  802014:	00 00 00 
  802017:	ff d0                	call   *%rax
}
  802019:	5d                   	pop    %rbp
  80201a:	c3                   	ret

000000000080201b <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80201b:	f3 0f 1e fa          	endbr64
  80201f:	55                   	push   %rbp
  802020:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802023:	8b 47 0c             	mov    0xc(%rdi),%eax
  802026:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80202d:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  80202f:	be 00 00 00 00       	mov    $0x0,%esi
  802034:	bf 06 00 00 00       	mov    $0x6,%edi
  802039:	48 b8 38 1f 80 00 00 	movabs $0x801f38,%rax
  802040:	00 00 00 
  802043:	ff d0                	call   *%rax
}
  802045:	5d                   	pop    %rbp
  802046:	c3                   	ret

0000000000802047 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802047:	f3 0f 1e fa          	endbr64
  80204b:	55                   	push   %rbp
  80204c:	48 89 e5             	mov    %rsp,%rbp
  80204f:	41 54                	push   %r12
  802051:	53                   	push   %rbx
  802052:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802055:	8b 47 0c             	mov    0xc(%rdi),%eax
  802058:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80205f:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802061:	be 00 00 00 00       	mov    $0x0,%esi
  802066:	bf 05 00 00 00       	mov    $0x5,%edi
  80206b:	48 b8 38 1f 80 00 00 	movabs $0x801f38,%rax
  802072:	00 00 00 
  802075:	ff d0                	call   *%rax
    if (res < 0) return res;
  802077:	85 c0                	test   %eax,%eax
  802079:	78 3d                	js     8020b8 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80207b:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  802082:	00 00 00 
  802085:	4c 89 e6             	mov    %r12,%rsi
  802088:	48 89 df             	mov    %rbx,%rdi
  80208b:	48 b8 d8 0c 80 00 00 	movabs $0x800cd8,%rax
  802092:	00 00 00 
  802095:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  802097:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  80209e:	00 
  80209f:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8020a5:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  8020ac:	00 
  8020ad:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8020b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b8:	5b                   	pop    %rbx
  8020b9:	41 5c                	pop    %r12
  8020bb:	5d                   	pop    %rbp
  8020bc:	c3                   	ret

00000000008020bd <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8020bd:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  8020c1:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  8020c8:	77 41                	ja     80210b <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8020ca:	55                   	push   %rbp
  8020cb:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8020ce:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8020d5:	00 00 00 
  8020d8:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8020db:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  8020dd:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  8020e1:	48 8d 78 10          	lea    0x10(%rax),%rdi
  8020e5:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  8020ec:	00 00 00 
  8020ef:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  8020f1:	be 00 00 00 00       	mov    $0x0,%esi
  8020f6:	bf 04 00 00 00       	mov    $0x4,%edi
  8020fb:	48 b8 38 1f 80 00 00 	movabs $0x801f38,%rax
  802102:	00 00 00 
  802105:	ff d0                	call   *%rax
  802107:	48 98                	cltq
}
  802109:	5d                   	pop    %rbp
  80210a:	c3                   	ret
        return -E_INVAL;
  80210b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802112:	c3                   	ret

0000000000802113 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802113:	f3 0f 1e fa          	endbr64
  802117:	55                   	push   %rbp
  802118:	48 89 e5             	mov    %rsp,%rbp
  80211b:	41 55                	push   %r13
  80211d:	41 54                	push   %r12
  80211f:	53                   	push   %rbx
  802120:	48 83 ec 08          	sub    $0x8,%rsp
  802124:	49 89 f4             	mov    %rsi,%r12
  802127:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80212a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802131:	00 00 00 
  802134:	8b 57 0c             	mov    0xc(%rdi),%edx
  802137:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802139:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  80213d:	be 00 00 00 00       	mov    $0x0,%esi
  802142:	bf 03 00 00 00       	mov    $0x3,%edi
  802147:	48 b8 38 1f 80 00 00 	movabs $0x801f38,%rax
  80214e:	00 00 00 
  802151:	ff d0                	call   *%rax
  802153:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802156:	4d 85 ed             	test   %r13,%r13
  802159:	78 2a                	js     802185 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  80215b:	4c 89 ea             	mov    %r13,%rdx
  80215e:	4c 39 eb             	cmp    %r13,%rbx
  802161:	72 30                	jb     802193 <devfile_read+0x80>
  802163:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  80216a:	7f 27                	jg     802193 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  80216c:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802173:	00 00 00 
  802176:	4c 89 e7             	mov    %r12,%rdi
  802179:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  802180:	00 00 00 
  802183:	ff d0                	call   *%rax
}
  802185:	4c 89 e8             	mov    %r13,%rax
  802188:	48 83 c4 08          	add    $0x8,%rsp
  80218c:	5b                   	pop    %rbx
  80218d:	41 5c                	pop    %r12
  80218f:	41 5d                	pop    %r13
  802191:	5d                   	pop    %rbp
  802192:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  802193:	48 b9 49 43 80 00 00 	movabs $0x804349,%rcx
  80219a:	00 00 00 
  80219d:	48 ba 66 43 80 00 00 	movabs $0x804366,%rdx
  8021a4:	00 00 00 
  8021a7:	be 7b 00 00 00       	mov    $0x7b,%esi
  8021ac:	48 bf 7b 43 80 00 00 	movabs $0x80437b,%rdi
  8021b3:	00 00 00 
  8021b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bb:	49 b8 33 02 80 00 00 	movabs $0x800233,%r8
  8021c2:	00 00 00 
  8021c5:	41 ff d0             	call   *%r8

00000000008021c8 <open>:
open(const char *path, int mode) {
  8021c8:	f3 0f 1e fa          	endbr64
  8021cc:	55                   	push   %rbp
  8021cd:	48 89 e5             	mov    %rsp,%rbp
  8021d0:	41 55                	push   %r13
  8021d2:	41 54                	push   %r12
  8021d4:	53                   	push   %rbx
  8021d5:	48 83 ec 18          	sub    $0x18,%rsp
  8021d9:	49 89 fc             	mov    %rdi,%r12
  8021dc:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8021df:	48 b8 93 0c 80 00 00 	movabs $0x800c93,%rax
  8021e6:	00 00 00 
  8021e9:	ff d0                	call   *%rax
  8021eb:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8021f1:	0f 87 8a 00 00 00    	ja     802281 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8021f7:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8021fb:	48 b8 33 18 80 00 00 	movabs $0x801833,%rax
  802202:	00 00 00 
  802205:	ff d0                	call   *%rax
  802207:	89 c3                	mov    %eax,%ebx
  802209:	85 c0                	test   %eax,%eax
  80220b:	78 50                	js     80225d <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80220d:	4c 89 e6             	mov    %r12,%rsi
  802210:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  802217:	00 00 00 
  80221a:	48 89 df             	mov    %rbx,%rdi
  80221d:	48 b8 d8 0c 80 00 00 	movabs $0x800cd8,%rax
  802224:	00 00 00 
  802227:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802229:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802230:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802234:	bf 01 00 00 00       	mov    $0x1,%edi
  802239:	48 b8 38 1f 80 00 00 	movabs $0x801f38,%rax
  802240:	00 00 00 
  802243:	ff d0                	call   *%rax
  802245:	89 c3                	mov    %eax,%ebx
  802247:	85 c0                	test   %eax,%eax
  802249:	78 1f                	js     80226a <open+0xa2>
    return fd2num(fd);
  80224b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80224f:	48 b8 fd 17 80 00 00 	movabs $0x8017fd,%rax
  802256:	00 00 00 
  802259:	ff d0                	call   *%rax
  80225b:	89 c3                	mov    %eax,%ebx
}
  80225d:	89 d8                	mov    %ebx,%eax
  80225f:	48 83 c4 18          	add    $0x18,%rsp
  802263:	5b                   	pop    %rbx
  802264:	41 5c                	pop    %r12
  802266:	41 5d                	pop    %r13
  802268:	5d                   	pop    %rbp
  802269:	c3                   	ret
        fd_close(fd, 0);
  80226a:	be 00 00 00 00       	mov    $0x0,%esi
  80226f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802273:	48 b8 5a 19 80 00 00 	movabs $0x80195a,%rax
  80227a:	00 00 00 
  80227d:	ff d0                	call   *%rax
        return res;
  80227f:	eb dc                	jmp    80225d <open+0x95>
        return -E_BAD_PATH;
  802281:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802286:	eb d5                	jmp    80225d <open+0x95>

0000000000802288 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802288:	f3 0f 1e fa          	endbr64
  80228c:	55                   	push   %rbp
  80228d:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802290:	be 00 00 00 00       	mov    $0x0,%esi
  802295:	bf 08 00 00 00       	mov    $0x8,%edi
  80229a:	48 b8 38 1f 80 00 00 	movabs $0x801f38,%rax
  8022a1:	00 00 00 
  8022a4:	ff d0                	call   *%rax
}
  8022a6:	5d                   	pop    %rbp
  8022a7:	c3                   	ret

00000000008022a8 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8022a8:	f3 0f 1e fa          	endbr64
  8022ac:	55                   	push   %rbp
  8022ad:	48 89 e5             	mov    %rsp,%rbp
  8022b0:	41 54                	push   %r12
  8022b2:	53                   	push   %rbx
  8022b3:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8022b6:	48 b8 13 18 80 00 00 	movabs $0x801813,%rax
  8022bd:	00 00 00 
  8022c0:	ff d0                	call   *%rax
  8022c2:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8022c5:	48 be 86 43 80 00 00 	movabs $0x804386,%rsi
  8022cc:	00 00 00 
  8022cf:	48 89 df             	mov    %rbx,%rdi
  8022d2:	48 b8 d8 0c 80 00 00 	movabs $0x800cd8,%rax
  8022d9:	00 00 00 
  8022dc:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8022de:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8022e3:	41 2b 04 24          	sub    (%r12),%eax
  8022e7:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8022ed:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8022f4:	00 00 00 
    stat->st_dev = &devpipe;
  8022f7:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  8022fe:	00 00 00 
  802301:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802308:	b8 00 00 00 00       	mov    $0x0,%eax
  80230d:	5b                   	pop    %rbx
  80230e:	41 5c                	pop    %r12
  802310:	5d                   	pop    %rbp
  802311:	c3                   	ret

0000000000802312 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802312:	f3 0f 1e fa          	endbr64
  802316:	55                   	push   %rbp
  802317:	48 89 e5             	mov    %rsp,%rbp
  80231a:	41 54                	push   %r12
  80231c:	53                   	push   %rbx
  80231d:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802320:	ba 00 10 00 00       	mov    $0x1000,%edx
  802325:	48 89 fe             	mov    %rdi,%rsi
  802328:	bf 00 00 00 00       	mov    $0x0,%edi
  80232d:	49 bc 1d 14 80 00 00 	movabs $0x80141d,%r12
  802334:	00 00 00 
  802337:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80233a:	48 89 df             	mov    %rbx,%rdi
  80233d:	48 b8 13 18 80 00 00 	movabs $0x801813,%rax
  802344:	00 00 00 
  802347:	ff d0                	call   *%rax
  802349:	48 89 c6             	mov    %rax,%rsi
  80234c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802351:	bf 00 00 00 00       	mov    $0x0,%edi
  802356:	41 ff d4             	call   *%r12
}
  802359:	5b                   	pop    %rbx
  80235a:	41 5c                	pop    %r12
  80235c:	5d                   	pop    %rbp
  80235d:	c3                   	ret

000000000080235e <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  80235e:	f3 0f 1e fa          	endbr64
  802362:	55                   	push   %rbp
  802363:	48 89 e5             	mov    %rsp,%rbp
  802366:	41 57                	push   %r15
  802368:	41 56                	push   %r14
  80236a:	41 55                	push   %r13
  80236c:	41 54                	push   %r12
  80236e:	53                   	push   %rbx
  80236f:	48 83 ec 18          	sub    $0x18,%rsp
  802373:	49 89 fc             	mov    %rdi,%r12
  802376:	49 89 f5             	mov    %rsi,%r13
  802379:	49 89 d7             	mov    %rdx,%r15
  80237c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802380:	48 b8 13 18 80 00 00 	movabs $0x801813,%rax
  802387:	00 00 00 
  80238a:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80238c:	4d 85 ff             	test   %r15,%r15
  80238f:	0f 84 af 00 00 00    	je     802444 <devpipe_write+0xe6>
  802395:	48 89 c3             	mov    %rax,%rbx
  802398:	4c 89 f8             	mov    %r15,%rax
  80239b:	4d 89 ef             	mov    %r13,%r15
  80239e:	4c 01 e8             	add    %r13,%rax
  8023a1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023a5:	49 bd ad 12 80 00 00 	movabs $0x8012ad,%r13
  8023ac:	00 00 00 
            sys_yield();
  8023af:	49 be 42 12 80 00 00 	movabs $0x801242,%r14
  8023b6:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8023b9:	8b 73 04             	mov    0x4(%rbx),%esi
  8023bc:	48 63 ce             	movslq %esi,%rcx
  8023bf:	48 63 03             	movslq (%rbx),%rax
  8023c2:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8023c8:	48 39 c1             	cmp    %rax,%rcx
  8023cb:	72 2e                	jb     8023fb <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023cd:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8023d2:	48 89 da             	mov    %rbx,%rdx
  8023d5:	be 00 10 00 00       	mov    $0x1000,%esi
  8023da:	4c 89 e7             	mov    %r12,%rdi
  8023dd:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	74 66                	je     80244a <devpipe_write+0xec>
            sys_yield();
  8023e4:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8023e7:	8b 73 04             	mov    0x4(%rbx),%esi
  8023ea:	48 63 ce             	movslq %esi,%rcx
  8023ed:	48 63 03             	movslq (%rbx),%rax
  8023f0:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8023f6:	48 39 c1             	cmp    %rax,%rcx
  8023f9:	73 d2                	jae    8023cd <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023fb:	41 0f b6 3f          	movzbl (%r15),%edi
  8023ff:	48 89 ca             	mov    %rcx,%rdx
  802402:	48 c1 ea 03          	shr    $0x3,%rdx
  802406:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80240d:	08 10 20 
  802410:	48 f7 e2             	mul    %rdx
  802413:	48 c1 ea 06          	shr    $0x6,%rdx
  802417:	48 89 d0             	mov    %rdx,%rax
  80241a:	48 c1 e0 09          	shl    $0x9,%rax
  80241e:	48 29 d0             	sub    %rdx,%rax
  802421:	48 c1 e0 03          	shl    $0x3,%rax
  802425:	48 29 c1             	sub    %rax,%rcx
  802428:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80242d:	83 c6 01             	add    $0x1,%esi
  802430:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802433:	49 83 c7 01          	add    $0x1,%r15
  802437:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80243b:	49 39 c7             	cmp    %rax,%r15
  80243e:	0f 85 75 ff ff ff    	jne    8023b9 <devpipe_write+0x5b>
    return n;
  802444:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802448:	eb 05                	jmp    80244f <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  80244a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244f:	48 83 c4 18          	add    $0x18,%rsp
  802453:	5b                   	pop    %rbx
  802454:	41 5c                	pop    %r12
  802456:	41 5d                	pop    %r13
  802458:	41 5e                	pop    %r14
  80245a:	41 5f                	pop    %r15
  80245c:	5d                   	pop    %rbp
  80245d:	c3                   	ret

000000000080245e <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80245e:	f3 0f 1e fa          	endbr64
  802462:	55                   	push   %rbp
  802463:	48 89 e5             	mov    %rsp,%rbp
  802466:	41 57                	push   %r15
  802468:	41 56                	push   %r14
  80246a:	41 55                	push   %r13
  80246c:	41 54                	push   %r12
  80246e:	53                   	push   %rbx
  80246f:	48 83 ec 18          	sub    $0x18,%rsp
  802473:	49 89 fc             	mov    %rdi,%r12
  802476:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80247a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80247e:	48 b8 13 18 80 00 00 	movabs $0x801813,%rax
  802485:	00 00 00 
  802488:	ff d0                	call   *%rax
  80248a:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80248d:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802493:	49 bd ad 12 80 00 00 	movabs $0x8012ad,%r13
  80249a:	00 00 00 
            sys_yield();
  80249d:	49 be 42 12 80 00 00 	movabs $0x801242,%r14
  8024a4:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8024a7:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8024ac:	74 7d                	je     80252b <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8024ae:	8b 03                	mov    (%rbx),%eax
  8024b0:	3b 43 04             	cmp    0x4(%rbx),%eax
  8024b3:	75 26                	jne    8024db <devpipe_read+0x7d>
            if (i > 0) return i;
  8024b5:	4d 85 ff             	test   %r15,%r15
  8024b8:	75 77                	jne    802531 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024ba:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024bf:	48 89 da             	mov    %rbx,%rdx
  8024c2:	be 00 10 00 00       	mov    $0x1000,%esi
  8024c7:	4c 89 e7             	mov    %r12,%rdi
  8024ca:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	74 72                	je     802543 <devpipe_read+0xe5>
            sys_yield();
  8024d1:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8024d4:	8b 03                	mov    (%rbx),%eax
  8024d6:	3b 43 04             	cmp    0x4(%rbx),%eax
  8024d9:	74 df                	je     8024ba <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024db:	48 63 c8             	movslq %eax,%rcx
  8024de:	48 89 ca             	mov    %rcx,%rdx
  8024e1:	48 c1 ea 03          	shr    $0x3,%rdx
  8024e5:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8024ec:	08 10 20 
  8024ef:	48 89 d0             	mov    %rdx,%rax
  8024f2:	48 f7 e6             	mul    %rsi
  8024f5:	48 c1 ea 06          	shr    $0x6,%rdx
  8024f9:	48 89 d0             	mov    %rdx,%rax
  8024fc:	48 c1 e0 09          	shl    $0x9,%rax
  802500:	48 29 d0             	sub    %rdx,%rax
  802503:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80250a:	00 
  80250b:	48 89 c8             	mov    %rcx,%rax
  80250e:	48 29 d0             	sub    %rdx,%rax
  802511:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802516:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80251a:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80251e:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802521:	49 83 c7 01          	add    $0x1,%r15
  802525:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802529:	75 83                	jne    8024ae <devpipe_read+0x50>
    return n;
  80252b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80252f:	eb 03                	jmp    802534 <devpipe_read+0xd6>
            if (i > 0) return i;
  802531:	4c 89 f8             	mov    %r15,%rax
}
  802534:	48 83 c4 18          	add    $0x18,%rsp
  802538:	5b                   	pop    %rbx
  802539:	41 5c                	pop    %r12
  80253b:	41 5d                	pop    %r13
  80253d:	41 5e                	pop    %r14
  80253f:	41 5f                	pop    %r15
  802541:	5d                   	pop    %rbp
  802542:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802543:	b8 00 00 00 00       	mov    $0x0,%eax
  802548:	eb ea                	jmp    802534 <devpipe_read+0xd6>

000000000080254a <pipe>:
pipe(int pfd[2]) {
  80254a:	f3 0f 1e fa          	endbr64
  80254e:	55                   	push   %rbp
  80254f:	48 89 e5             	mov    %rsp,%rbp
  802552:	41 55                	push   %r13
  802554:	41 54                	push   %r12
  802556:	53                   	push   %rbx
  802557:	48 83 ec 18          	sub    $0x18,%rsp
  80255b:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  80255e:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802562:	48 b8 33 18 80 00 00 	movabs $0x801833,%rax
  802569:	00 00 00 
  80256c:	ff d0                	call   *%rax
  80256e:	89 c3                	mov    %eax,%ebx
  802570:	85 c0                	test   %eax,%eax
  802572:	0f 88 a0 01 00 00    	js     802718 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802578:	b9 46 00 00 00       	mov    $0x46,%ecx
  80257d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802582:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802586:	bf 00 00 00 00       	mov    $0x0,%edi
  80258b:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  802592:	00 00 00 
  802595:	ff d0                	call   *%rax
  802597:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802599:	85 c0                	test   %eax,%eax
  80259b:	0f 88 77 01 00 00    	js     802718 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8025a1:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8025a5:	48 b8 33 18 80 00 00 	movabs $0x801833,%rax
  8025ac:	00 00 00 
  8025af:	ff d0                	call   *%rax
  8025b1:	89 c3                	mov    %eax,%ebx
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	0f 88 43 01 00 00    	js     8026fe <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8025bb:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025c0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025c5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ce:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  8025d5:	00 00 00 
  8025d8:	ff d0                	call   *%rax
  8025da:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8025dc:	85 c0                	test   %eax,%eax
  8025de:	0f 88 1a 01 00 00    	js     8026fe <pipe+0x1b4>
    va = fd2data(fd0);
  8025e4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8025e8:	48 b8 13 18 80 00 00 	movabs $0x801813,%rax
  8025ef:	00 00 00 
  8025f2:	ff d0                	call   *%rax
  8025f4:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8025f7:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025fc:	ba 00 10 00 00       	mov    $0x1000,%edx
  802601:	48 89 c6             	mov    %rax,%rsi
  802604:	bf 00 00 00 00       	mov    $0x0,%edi
  802609:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  802610:	00 00 00 
  802613:	ff d0                	call   *%rax
  802615:	89 c3                	mov    %eax,%ebx
  802617:	85 c0                	test   %eax,%eax
  802619:	0f 88 c5 00 00 00    	js     8026e4 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80261f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802623:	48 b8 13 18 80 00 00 	movabs $0x801813,%rax
  80262a:	00 00 00 
  80262d:	ff d0                	call   *%rax
  80262f:	48 89 c1             	mov    %rax,%rcx
  802632:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802638:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80263e:	ba 00 00 00 00       	mov    $0x0,%edx
  802643:	4c 89 ee             	mov    %r13,%rsi
  802646:	bf 00 00 00 00       	mov    $0x0,%edi
  80264b:	48 b8 48 13 80 00 00 	movabs $0x801348,%rax
  802652:	00 00 00 
  802655:	ff d0                	call   *%rax
  802657:	89 c3                	mov    %eax,%ebx
  802659:	85 c0                	test   %eax,%eax
  80265b:	78 6e                	js     8026cb <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80265d:	be 00 10 00 00       	mov    $0x1000,%esi
  802662:	4c 89 ef             	mov    %r13,%rdi
  802665:	48 b8 77 12 80 00 00 	movabs $0x801277,%rax
  80266c:	00 00 00 
  80266f:	ff d0                	call   *%rax
  802671:	83 f8 02             	cmp    $0x2,%eax
  802674:	0f 85 ab 00 00 00    	jne    802725 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  80267a:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  802681:	00 00 
  802683:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802687:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802689:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80268d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802694:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802698:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80269a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80269e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8026a5:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8026a9:	48 bb fd 17 80 00 00 	movabs $0x8017fd,%rbx
  8026b0:	00 00 00 
  8026b3:	ff d3                	call   *%rbx
  8026b5:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8026b9:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8026bd:	ff d3                	call   *%rbx
  8026bf:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8026c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026c9:	eb 4d                	jmp    802718 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8026cb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026d0:	4c 89 ee             	mov    %r13,%rsi
  8026d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d8:	48 b8 1d 14 80 00 00 	movabs $0x80141d,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8026e4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026e9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f2:	48 b8 1d 14 80 00 00 	movabs $0x80141d,%rax
  8026f9:	00 00 00 
  8026fc:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8026fe:	ba 00 10 00 00       	mov    $0x1000,%edx
  802703:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802707:	bf 00 00 00 00       	mov    $0x0,%edi
  80270c:	48 b8 1d 14 80 00 00 	movabs $0x80141d,%rax
  802713:	00 00 00 
  802716:	ff d0                	call   *%rax
}
  802718:	89 d8                	mov    %ebx,%eax
  80271a:	48 83 c4 18          	add    $0x18,%rsp
  80271e:	5b                   	pop    %rbx
  80271f:	41 5c                	pop    %r12
  802721:	41 5d                	pop    %r13
  802723:	5d                   	pop    %rbp
  802724:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802725:	48 b9 d8 40 80 00 00 	movabs $0x8040d8,%rcx
  80272c:	00 00 00 
  80272f:	48 ba 66 43 80 00 00 	movabs $0x804366,%rdx
  802736:	00 00 00 
  802739:	be 2e 00 00 00       	mov    $0x2e,%esi
  80273e:	48 bf 8d 43 80 00 00 	movabs $0x80438d,%rdi
  802745:	00 00 00 
  802748:	b8 00 00 00 00       	mov    $0x0,%eax
  80274d:	49 b8 33 02 80 00 00 	movabs $0x800233,%r8
  802754:	00 00 00 
  802757:	41 ff d0             	call   *%r8

000000000080275a <pipeisclosed>:
pipeisclosed(int fdnum) {
  80275a:	f3 0f 1e fa          	endbr64
  80275e:	55                   	push   %rbp
  80275f:	48 89 e5             	mov    %rsp,%rbp
  802762:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802766:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80276a:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  802771:	00 00 00 
  802774:	ff d0                	call   *%rax
    if (res < 0) return res;
  802776:	85 c0                	test   %eax,%eax
  802778:	78 35                	js     8027af <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80277a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80277e:	48 b8 13 18 80 00 00 	movabs $0x801813,%rax
  802785:	00 00 00 
  802788:	ff d0                	call   *%rax
  80278a:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80278d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802792:	be 00 10 00 00       	mov    $0x1000,%esi
  802797:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80279b:	48 b8 ad 12 80 00 00 	movabs $0x8012ad,%rax
  8027a2:	00 00 00 
  8027a5:	ff d0                	call   *%rax
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	0f 94 c0             	sete   %al
  8027ac:	0f b6 c0             	movzbl %al,%eax
}
  8027af:	c9                   	leave
  8027b0:	c3                   	ret

00000000008027b1 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8027b1:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8027b5:	48 89 f8             	mov    %rdi,%rax
  8027b8:	48 c1 e8 27          	shr    $0x27,%rax
  8027bc:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8027c3:	7f 00 00 
  8027c6:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027ca:	f6 c2 01             	test   $0x1,%dl
  8027cd:	74 6d                	je     80283c <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8027cf:	48 89 f8             	mov    %rdi,%rax
  8027d2:	48 c1 e8 1e          	shr    $0x1e,%rax
  8027d6:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8027dd:	7f 00 00 
  8027e0:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027e4:	f6 c2 01             	test   $0x1,%dl
  8027e7:	74 62                	je     80284b <get_uvpt_entry+0x9a>
  8027e9:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8027f0:	7f 00 00 
  8027f3:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027f7:	f6 c2 80             	test   $0x80,%dl
  8027fa:	75 4f                	jne    80284b <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8027fc:	48 89 f8             	mov    %rdi,%rax
  8027ff:	48 c1 e8 15          	shr    $0x15,%rax
  802803:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80280a:	7f 00 00 
  80280d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802811:	f6 c2 01             	test   $0x1,%dl
  802814:	74 44                	je     80285a <get_uvpt_entry+0xa9>
  802816:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80281d:	7f 00 00 
  802820:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802824:	f6 c2 80             	test   $0x80,%dl
  802827:	75 31                	jne    80285a <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802829:	48 c1 ef 0c          	shr    $0xc,%rdi
  80282d:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802834:	7f 00 00 
  802837:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80283b:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80283c:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802843:	7f 00 00 
  802846:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80284a:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80284b:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802852:	7f 00 00 
  802855:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802859:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80285a:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802861:	7f 00 00 
  802864:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802868:	c3                   	ret

0000000000802869 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802869:	f3 0f 1e fa          	endbr64
  80286d:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802870:	48 89 f9             	mov    %rdi,%rcx
  802873:	48 c1 e9 27          	shr    $0x27,%rcx
  802877:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  80287e:	7f 00 00 
  802881:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802885:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  80288c:	f6 c1 01             	test   $0x1,%cl
  80288f:	0f 84 b2 00 00 00    	je     802947 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802895:	48 89 f9             	mov    %rdi,%rcx
  802898:	48 c1 e9 1e          	shr    $0x1e,%rcx
  80289c:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8028a3:	7f 00 00 
  8028a6:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8028aa:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8028b1:	40 f6 c6 01          	test   $0x1,%sil
  8028b5:	0f 84 8c 00 00 00    	je     802947 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8028bb:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8028c2:	7f 00 00 
  8028c5:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8028c9:	a8 80                	test   $0x80,%al
  8028cb:	75 7b                	jne    802948 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8028cd:	48 89 f9             	mov    %rdi,%rcx
  8028d0:	48 c1 e9 15          	shr    $0x15,%rcx
  8028d4:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8028db:	7f 00 00 
  8028de:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8028e2:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  8028e9:	40 f6 c6 01          	test   $0x1,%sil
  8028ed:	74 58                	je     802947 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  8028ef:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8028f6:	7f 00 00 
  8028f9:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8028fd:	a8 80                	test   $0x80,%al
  8028ff:	75 6c                	jne    80296d <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802901:	48 89 f9             	mov    %rdi,%rcx
  802904:	48 c1 e9 0c          	shr    $0xc,%rcx
  802908:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80290f:	7f 00 00 
  802912:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802916:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  80291d:	40 f6 c6 01          	test   $0x1,%sil
  802921:	74 24                	je     802947 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802923:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80292a:	7f 00 00 
  80292d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802931:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802938:	ff ff 7f 
  80293b:	48 21 c8             	and    %rcx,%rax
  80293e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802944:	48 09 d0             	or     %rdx,%rax
}
  802947:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802948:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80294f:	7f 00 00 
  802952:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802956:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80295d:	ff ff 7f 
  802960:	48 21 c8             	and    %rcx,%rax
  802963:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802969:	48 01 d0             	add    %rdx,%rax
  80296c:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  80296d:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802974:	7f 00 00 
  802977:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80297b:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802982:	ff ff 7f 
  802985:	48 21 c8             	and    %rcx,%rax
  802988:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  80298e:	48 01 d0             	add    %rdx,%rax
  802991:	c3                   	ret

0000000000802992 <get_prot>:

int
get_prot(void *va) {
  802992:	f3 0f 1e fa          	endbr64
  802996:	55                   	push   %rbp
  802997:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80299a:	48 b8 b1 27 80 00 00 	movabs $0x8027b1,%rax
  8029a1:	00 00 00 
  8029a4:	ff d0                	call   *%rax
  8029a6:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8029a9:	83 e0 01             	and    $0x1,%eax
  8029ac:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8029af:	89 d1                	mov    %edx,%ecx
  8029b1:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8029b7:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8029b9:	89 c1                	mov    %eax,%ecx
  8029bb:	83 c9 02             	or     $0x2,%ecx
  8029be:	f6 c2 02             	test   $0x2,%dl
  8029c1:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8029c4:	89 c1                	mov    %eax,%ecx
  8029c6:	83 c9 01             	or     $0x1,%ecx
  8029c9:	48 85 d2             	test   %rdx,%rdx
  8029cc:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8029cf:	89 c1                	mov    %eax,%ecx
  8029d1:	83 c9 40             	or     $0x40,%ecx
  8029d4:	f6 c6 04             	test   $0x4,%dh
  8029d7:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8029da:	5d                   	pop    %rbp
  8029db:	c3                   	ret

00000000008029dc <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8029dc:	f3 0f 1e fa          	endbr64
  8029e0:	55                   	push   %rbp
  8029e1:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8029e4:	48 b8 b1 27 80 00 00 	movabs $0x8027b1,%rax
  8029eb:	00 00 00 
  8029ee:	ff d0                	call   *%rax
    return pte & PTE_D;
  8029f0:	48 c1 e8 06          	shr    $0x6,%rax
  8029f4:	83 e0 01             	and    $0x1,%eax
}
  8029f7:	5d                   	pop    %rbp
  8029f8:	c3                   	ret

00000000008029f9 <is_page_present>:

bool
is_page_present(void *va) {
  8029f9:	f3 0f 1e fa          	endbr64
  8029fd:	55                   	push   %rbp
  8029fe:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802a01:	48 b8 b1 27 80 00 00 	movabs $0x8027b1,%rax
  802a08:	00 00 00 
  802a0b:	ff d0                	call   *%rax
  802a0d:	83 e0 01             	and    $0x1,%eax
}
  802a10:	5d                   	pop    %rbp
  802a11:	c3                   	ret

0000000000802a12 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802a12:	f3 0f 1e fa          	endbr64
  802a16:	55                   	push   %rbp
  802a17:	48 89 e5             	mov    %rsp,%rbp
  802a1a:	41 57                	push   %r15
  802a1c:	41 56                	push   %r14
  802a1e:	41 55                	push   %r13
  802a20:	41 54                	push   %r12
  802a22:	53                   	push   %rbx
  802a23:	48 83 ec 18          	sub    $0x18,%rsp
  802a27:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802a2b:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802a2f:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802a34:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802a3b:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802a3e:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802a45:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802a48:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802a4f:	00 00 00 
  802a52:	eb 73                	jmp    802ac7 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802a54:	48 89 d8             	mov    %rbx,%rax
  802a57:	48 c1 e8 15          	shr    $0x15,%rax
  802a5b:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802a62:	7f 00 00 
  802a65:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802a69:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802a6f:	f6 c2 01             	test   $0x1,%dl
  802a72:	74 4b                	je     802abf <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802a74:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802a78:	f6 c2 80             	test   $0x80,%dl
  802a7b:	74 11                	je     802a8e <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802a7d:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802a81:	f6 c4 04             	test   $0x4,%ah
  802a84:	74 39                	je     802abf <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802a86:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802a8c:	eb 20                	jmp    802aae <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802a8e:	48 89 da             	mov    %rbx,%rdx
  802a91:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a95:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a9c:	7f 00 00 
  802a9f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802aa3:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802aa9:	f6 c4 04             	test   $0x4,%ah
  802aac:	74 11                	je     802abf <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802aae:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802ab2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ab6:	48 89 df             	mov    %rbx,%rdi
  802ab9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802abd:	ff d0                	call   *%rax
    next:
        va += size;
  802abf:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802ac2:	49 39 df             	cmp    %rbx,%r15
  802ac5:	72 3e                	jb     802b05 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802ac7:	49 8b 06             	mov    (%r14),%rax
  802aca:	a8 01                	test   $0x1,%al
  802acc:	74 37                	je     802b05 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802ace:	48 89 d8             	mov    %rbx,%rax
  802ad1:	48 c1 e8 1e          	shr    $0x1e,%rax
  802ad5:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802ada:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802ae0:	f6 c2 01             	test   $0x1,%dl
  802ae3:	74 da                	je     802abf <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802ae5:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802aea:	f6 c2 80             	test   $0x80,%dl
  802aed:	0f 84 61 ff ff ff    	je     802a54 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802af3:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802af8:	f6 c4 04             	test   $0x4,%ah
  802afb:	74 c2                	je     802abf <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802afd:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802b03:	eb a9                	jmp    802aae <foreach_shared_region+0x9c>
    }
    return res;
}
  802b05:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0a:	48 83 c4 18          	add    $0x18,%rsp
  802b0e:	5b                   	pop    %rbx
  802b0f:	41 5c                	pop    %r12
  802b11:	41 5d                	pop    %r13
  802b13:	41 5e                	pop    %r14
  802b15:	41 5f                	pop    %r15
  802b17:	5d                   	pop    %rbp
  802b18:	c3                   	ret

0000000000802b19 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802b19:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b22:	c3                   	ret

0000000000802b23 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802b23:	f3 0f 1e fa          	endbr64
  802b27:	55                   	push   %rbp
  802b28:	48 89 e5             	mov    %rsp,%rbp
  802b2b:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802b2e:	48 be 9d 43 80 00 00 	movabs $0x80439d,%rsi
  802b35:	00 00 00 
  802b38:	48 b8 d8 0c 80 00 00 	movabs $0x800cd8,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	call   *%rax
    return 0;
}
  802b44:	b8 00 00 00 00       	mov    $0x0,%eax
  802b49:	5d                   	pop    %rbp
  802b4a:	c3                   	ret

0000000000802b4b <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802b4b:	f3 0f 1e fa          	endbr64
  802b4f:	55                   	push   %rbp
  802b50:	48 89 e5             	mov    %rsp,%rbp
  802b53:	41 57                	push   %r15
  802b55:	41 56                	push   %r14
  802b57:	41 55                	push   %r13
  802b59:	41 54                	push   %r12
  802b5b:	53                   	push   %rbx
  802b5c:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802b63:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802b6a:	48 85 d2             	test   %rdx,%rdx
  802b6d:	74 7a                	je     802be9 <devcons_write+0x9e>
  802b6f:	49 89 d6             	mov    %rdx,%r14
  802b72:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802b78:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802b7d:	49 bf f3 0e 80 00 00 	movabs $0x800ef3,%r15
  802b84:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802b87:	4c 89 f3             	mov    %r14,%rbx
  802b8a:	48 29 f3             	sub    %rsi,%rbx
  802b8d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802b92:	48 39 c3             	cmp    %rax,%rbx
  802b95:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802b99:	4c 63 eb             	movslq %ebx,%r13
  802b9c:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802ba3:	48 01 c6             	add    %rax,%rsi
  802ba6:	4c 89 ea             	mov    %r13,%rdx
  802ba9:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802bb0:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802bb3:	4c 89 ee             	mov    %r13,%rsi
  802bb6:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802bbd:	48 b8 38 11 80 00 00 	movabs $0x801138,%rax
  802bc4:	00 00 00 
  802bc7:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802bc9:	41 01 dc             	add    %ebx,%r12d
  802bcc:	49 63 f4             	movslq %r12d,%rsi
  802bcf:	4c 39 f6             	cmp    %r14,%rsi
  802bd2:	72 b3                	jb     802b87 <devcons_write+0x3c>
    return res;
  802bd4:	49 63 c4             	movslq %r12d,%rax
}
  802bd7:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802bde:	5b                   	pop    %rbx
  802bdf:	41 5c                	pop    %r12
  802be1:	41 5d                	pop    %r13
  802be3:	41 5e                	pop    %r14
  802be5:	41 5f                	pop    %r15
  802be7:	5d                   	pop    %rbp
  802be8:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802be9:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802bef:	eb e3                	jmp    802bd4 <devcons_write+0x89>

0000000000802bf1 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802bf1:	f3 0f 1e fa          	endbr64
  802bf5:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802bf8:	ba 00 00 00 00       	mov    $0x0,%edx
  802bfd:	48 85 c0             	test   %rax,%rax
  802c00:	74 55                	je     802c57 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802c02:	55                   	push   %rbp
  802c03:	48 89 e5             	mov    %rsp,%rbp
  802c06:	41 55                	push   %r13
  802c08:	41 54                	push   %r12
  802c0a:	53                   	push   %rbx
  802c0b:	48 83 ec 08          	sub    $0x8,%rsp
  802c0f:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802c12:	48 bb 69 11 80 00 00 	movabs $0x801169,%rbx
  802c19:	00 00 00 
  802c1c:	49 bc 42 12 80 00 00 	movabs $0x801242,%r12
  802c23:	00 00 00 
  802c26:	eb 03                	jmp    802c2b <devcons_read+0x3a>
  802c28:	41 ff d4             	call   *%r12
  802c2b:	ff d3                	call   *%rbx
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	74 f7                	je     802c28 <devcons_read+0x37>
    if (c < 0) return c;
  802c31:	48 63 d0             	movslq %eax,%rdx
  802c34:	78 13                	js     802c49 <devcons_read+0x58>
    if (c == 0x04) return 0;
  802c36:	ba 00 00 00 00       	mov    $0x0,%edx
  802c3b:	83 f8 04             	cmp    $0x4,%eax
  802c3e:	74 09                	je     802c49 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802c40:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802c44:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802c49:	48 89 d0             	mov    %rdx,%rax
  802c4c:	48 83 c4 08          	add    $0x8,%rsp
  802c50:	5b                   	pop    %rbx
  802c51:	41 5c                	pop    %r12
  802c53:	41 5d                	pop    %r13
  802c55:	5d                   	pop    %rbp
  802c56:	c3                   	ret
  802c57:	48 89 d0             	mov    %rdx,%rax
  802c5a:	c3                   	ret

0000000000802c5b <cputchar>:
cputchar(int ch) {
  802c5b:	f3 0f 1e fa          	endbr64
  802c5f:	55                   	push   %rbp
  802c60:	48 89 e5             	mov    %rsp,%rbp
  802c63:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802c67:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802c6b:	be 01 00 00 00       	mov    $0x1,%esi
  802c70:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802c74:	48 b8 38 11 80 00 00 	movabs $0x801138,%rax
  802c7b:	00 00 00 
  802c7e:	ff d0                	call   *%rax
}
  802c80:	c9                   	leave
  802c81:	c3                   	ret

0000000000802c82 <getchar>:
getchar(void) {
  802c82:	f3 0f 1e fa          	endbr64
  802c86:	55                   	push   %rbp
  802c87:	48 89 e5             	mov    %rsp,%rbp
  802c8a:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802c8e:	ba 01 00 00 00       	mov    $0x1,%edx
  802c93:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802c97:	bf 00 00 00 00       	mov    $0x0,%edi
  802c9c:	48 b8 92 1b 80 00 00 	movabs $0x801b92,%rax
  802ca3:	00 00 00 
  802ca6:	ff d0                	call   *%rax
  802ca8:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802caa:	85 c0                	test   %eax,%eax
  802cac:	78 06                	js     802cb4 <getchar+0x32>
  802cae:	74 08                	je     802cb8 <getchar+0x36>
  802cb0:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802cb4:	89 d0                	mov    %edx,%eax
  802cb6:	c9                   	leave
  802cb7:	c3                   	ret
    return res < 0 ? res : res ? c :
  802cb8:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802cbd:	eb f5                	jmp    802cb4 <getchar+0x32>

0000000000802cbf <iscons>:
iscons(int fdnum) {
  802cbf:	f3 0f 1e fa          	endbr64
  802cc3:	55                   	push   %rbp
  802cc4:	48 89 e5             	mov    %rsp,%rbp
  802cc7:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802ccb:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802ccf:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  802cd6:	00 00 00 
  802cd9:	ff d0                	call   *%rax
    if (res < 0) return res;
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	78 18                	js     802cf7 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802cdf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ce3:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802cea:	00 00 00 
  802ced:	8b 00                	mov    (%rax),%eax
  802cef:	39 02                	cmp    %eax,(%rdx)
  802cf1:	0f 94 c0             	sete   %al
  802cf4:	0f b6 c0             	movzbl %al,%eax
}
  802cf7:	c9                   	leave
  802cf8:	c3                   	ret

0000000000802cf9 <opencons>:
opencons(void) {
  802cf9:	f3 0f 1e fa          	endbr64
  802cfd:	55                   	push   %rbp
  802cfe:	48 89 e5             	mov    %rsp,%rbp
  802d01:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802d05:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802d09:	48 b8 33 18 80 00 00 	movabs $0x801833,%rax
  802d10:	00 00 00 
  802d13:	ff d0                	call   *%rax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	78 49                	js     802d62 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802d19:	b9 46 00 00 00       	mov    $0x46,%ecx
  802d1e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d23:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802d27:	bf 00 00 00 00       	mov    $0x0,%edi
  802d2c:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  802d33:	00 00 00 
  802d36:	ff d0                	call   *%rax
  802d38:	85 c0                	test   %eax,%eax
  802d3a:	78 26                	js     802d62 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802d3c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d40:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802d47:	00 00 
  802d49:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802d4b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802d4f:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802d56:	48 b8 fd 17 80 00 00 	movabs $0x8017fd,%rax
  802d5d:	00 00 00 
  802d60:	ff d0                	call   *%rax
}
  802d62:	c9                   	leave
  802d63:	c3                   	ret

0000000000802d64 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  802d64:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  802d67:	48 b8 a3 2f 80 00 00 	movabs $0x802fa3,%rax
  802d6e:	00 00 00 
    call *%rax
  802d71:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  802d73:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  802d76:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802d7d:	00 
    movq UTRAP_RSP(%rsp), %rsp
  802d7e:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  802d85:	00 
    pushq %rbx
  802d86:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  802d87:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  802d8e:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  802d91:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  802d95:	4c 8b 3c 24          	mov    (%rsp),%r15
  802d99:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802d9e:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802da3:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802da8:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802dad:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802db2:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802db7:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802dbc:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802dc1:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802dc6:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802dcb:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802dd0:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802dd5:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802dda:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802ddf:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  802de3:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  802de7:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  802de8:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  802de9:	c3                   	ret

0000000000802dea <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802dea:	f3 0f 1e fa          	endbr64
  802dee:	55                   	push   %rbp
  802def:	48 89 e5             	mov    %rsp,%rbp
  802df2:	41 54                	push   %r12
  802df4:	53                   	push   %rbx
  802df5:	48 89 fb             	mov    %rdi,%rbx
  802df8:	48 89 f7             	mov    %rsi,%rdi
  802dfb:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802dfe:	48 85 f6             	test   %rsi,%rsi
  802e01:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802e08:	00 00 00 
  802e0b:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802e0f:	be 00 10 00 00       	mov    $0x1000,%esi
  802e14:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  802e1b:	00 00 00 
  802e1e:	ff d0                	call   *%rax
    if (res < 0) {
  802e20:	85 c0                	test   %eax,%eax
  802e22:	78 45                	js     802e69 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802e24:	48 85 db             	test   %rbx,%rbx
  802e27:	74 12                	je     802e3b <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802e29:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  802e30:	00 00 00 
  802e33:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802e39:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802e3b:	4d 85 e4             	test   %r12,%r12
  802e3e:	74 14                	je     802e54 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802e40:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  802e47:	00 00 00 
  802e4a:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802e50:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802e54:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  802e5b:	00 00 00 
  802e5e:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802e64:	5b                   	pop    %rbx
  802e65:	41 5c                	pop    %r12
  802e67:	5d                   	pop    %rbp
  802e68:	c3                   	ret
        if (from_env_store != NULL) {
  802e69:	48 85 db             	test   %rbx,%rbx
  802e6c:	74 06                	je     802e74 <ipc_recv+0x8a>
            *from_env_store = 0;
  802e6e:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802e74:	4d 85 e4             	test   %r12,%r12
  802e77:	74 eb                	je     802e64 <ipc_recv+0x7a>
            *perm_store = 0;
  802e79:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802e80:	00 
  802e81:	eb e1                	jmp    802e64 <ipc_recv+0x7a>

0000000000802e83 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802e83:	f3 0f 1e fa          	endbr64
  802e87:	55                   	push   %rbp
  802e88:	48 89 e5             	mov    %rsp,%rbp
  802e8b:	41 57                	push   %r15
  802e8d:	41 56                	push   %r14
  802e8f:	41 55                	push   %r13
  802e91:	41 54                	push   %r12
  802e93:	53                   	push   %rbx
  802e94:	48 83 ec 18          	sub    $0x18,%rsp
  802e98:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802e9b:	48 89 d3             	mov    %rdx,%rbx
  802e9e:	49 89 cc             	mov    %rcx,%r12
  802ea1:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802ea4:	48 85 d2             	test   %rdx,%rdx
  802ea7:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802eae:	00 00 00 
  802eb1:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802eb5:	89 f0                	mov    %esi,%eax
  802eb7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802ebb:	48 89 da             	mov    %rbx,%rdx
  802ebe:	48 89 c6             	mov    %rax,%rsi
  802ec1:	48 b8 cf 15 80 00 00 	movabs $0x8015cf,%rax
  802ec8:	00 00 00 
  802ecb:	ff d0                	call   *%rax
    while (res < 0) {
  802ecd:	85 c0                	test   %eax,%eax
  802ecf:	79 65                	jns    802f36 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802ed1:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802ed4:	75 33                	jne    802f09 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802ed6:	49 bf 42 12 80 00 00 	movabs $0x801242,%r15
  802edd:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802ee0:	49 be cf 15 80 00 00 	movabs $0x8015cf,%r14
  802ee7:	00 00 00 
        sys_yield();
  802eea:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802eed:	45 89 e8             	mov    %r13d,%r8d
  802ef0:	4c 89 e1             	mov    %r12,%rcx
  802ef3:	48 89 da             	mov    %rbx,%rdx
  802ef6:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802efa:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802efd:	41 ff d6             	call   *%r14
    while (res < 0) {
  802f00:	85 c0                	test   %eax,%eax
  802f02:	79 32                	jns    802f36 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802f04:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802f07:	74 e1                	je     802eea <ipc_send+0x67>
            panic("Error: %i\n", res);
  802f09:	89 c1                	mov    %eax,%ecx
  802f0b:	48 ba a9 43 80 00 00 	movabs $0x8043a9,%rdx
  802f12:	00 00 00 
  802f15:	be 42 00 00 00       	mov    $0x42,%esi
  802f1a:	48 bf b4 43 80 00 00 	movabs $0x8043b4,%rdi
  802f21:	00 00 00 
  802f24:	b8 00 00 00 00       	mov    $0x0,%eax
  802f29:	49 b8 33 02 80 00 00 	movabs $0x800233,%r8
  802f30:	00 00 00 
  802f33:	41 ff d0             	call   *%r8
    }
}
  802f36:	48 83 c4 18          	add    $0x18,%rsp
  802f3a:	5b                   	pop    %rbx
  802f3b:	41 5c                	pop    %r12
  802f3d:	41 5d                	pop    %r13
  802f3f:	41 5e                	pop    %r14
  802f41:	41 5f                	pop    %r15
  802f43:	5d                   	pop    %rbp
  802f44:	c3                   	ret

0000000000802f45 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802f45:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802f49:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802f4e:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802f55:	00 00 00 
  802f58:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802f5c:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802f60:	48 c1 e2 04          	shl    $0x4,%rdx
  802f64:	48 01 ca             	add    %rcx,%rdx
  802f67:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802f6d:	39 fa                	cmp    %edi,%edx
  802f6f:	74 12                	je     802f83 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802f71:	48 83 c0 01          	add    $0x1,%rax
  802f75:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802f7b:	75 db                	jne    802f58 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f82:	c3                   	ret
            return envs[i].env_id;
  802f83:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802f87:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802f8b:	48 c1 e2 04          	shl    $0x4,%rdx
  802f8f:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802f96:	00 00 00 
  802f99:	48 01 d0             	add    %rdx,%rax
  802f9c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fa2:	c3                   	ret

0000000000802fa3 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  802fa3:	f3 0f 1e fa          	endbr64
  802fa7:	55                   	push   %rbp
  802fa8:	48 89 e5             	mov    %rsp,%rbp
  802fab:	41 56                	push   %r14
  802fad:	41 55                	push   %r13
  802faf:	41 54                	push   %r12
  802fb1:	53                   	push   %rbx
  802fb2:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  802fb5:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  802fbc:	00 00 00 
  802fbf:	48 83 38 00          	cmpq   $0x0,(%rax)
  802fc3:	74 27                	je     802fec <_handle_vectored_pagefault+0x49>
  802fc5:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  802fca:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  802fd1:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  802fd4:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  802fd7:	4c 89 e7             	mov    %r12,%rdi
  802fda:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  802fdf:	84 c0                	test   %al,%al
  802fe1:	75 45                	jne    803028 <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  802fe3:	48 83 c3 01          	add    $0x1,%rbx
  802fe7:	49 3b 1e             	cmp    (%r14),%rbx
  802fea:	72 eb                	jb     802fd7 <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  802fec:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  802ff3:	00 
  802ff4:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  802ff9:	4d 8b 04 24          	mov    (%r12),%r8
  802ffd:	48 ba 00 41 80 00 00 	movabs $0x804100,%rdx
  803004:	00 00 00 
  803007:	be 1d 00 00 00       	mov    $0x1d,%esi
  80300c:	48 bf be 43 80 00 00 	movabs $0x8043be,%rdi
  803013:	00 00 00 
  803016:	b8 00 00 00 00       	mov    $0x0,%eax
  80301b:	49 ba 33 02 80 00 00 	movabs $0x800233,%r10
  803022:	00 00 00 
  803025:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  803028:	5b                   	pop    %rbx
  803029:	41 5c                	pop    %r12
  80302b:	41 5d                	pop    %r13
  80302d:	41 5e                	pop    %r14
  80302f:	5d                   	pop    %rbp
  803030:	c3                   	ret

0000000000803031 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  803031:	f3 0f 1e fa          	endbr64
  803035:	55                   	push   %rbp
  803036:	48 89 e5             	mov    %rsp,%rbp
  803039:	53                   	push   %rbx
  80303a:	48 83 ec 08          	sub    $0x8,%rsp
  80303e:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  803041:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803048:	00 00 00 
  80304b:	80 38 00             	cmpb   $0x0,(%rax)
  80304e:	0f 84 84 00 00 00    	je     8030d8 <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  803054:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  80305b:	00 00 00 
  80305e:	48 8b 10             	mov    (%rax),%rdx
  803061:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  803066:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  80306d:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803070:	48 85 d2             	test   %rdx,%rdx
  803073:	74 19                	je     80308e <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  803075:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  803079:	0f 84 e8 00 00 00    	je     803167 <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80307f:	48 83 c0 01          	add    $0x1,%rax
  803083:	48 39 d0             	cmp    %rdx,%rax
  803086:	75 ed                	jne    803075 <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  803088:	48 83 fa 08          	cmp    $0x8,%rdx
  80308c:	74 1c                	je     8030aa <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  80308e:	48 8d 42 01          	lea    0x1(%rdx),%rax
  803092:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  803099:	00 00 00 
  80309c:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8030a3:	00 00 00 
  8030a6:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8030aa:	48 b8 0d 12 80 00 00 	movabs $0x80120d,%rax
  8030b1:	00 00 00 
  8030b4:	ff d0                	call   *%rax
  8030b6:	89 c7                	mov    %eax,%edi
  8030b8:	48 be 64 2d 80 00 00 	movabs $0x802d64,%rsi
  8030bf:	00 00 00 
  8030c2:	48 b8 62 15 80 00 00 	movabs $0x801562,%rax
  8030c9:	00 00 00 
  8030cc:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	78 68                	js     80313a <add_pgfault_handler+0x109>
    return res;
}
  8030d2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8030d6:	c9                   	leave
  8030d7:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  8030d8:	48 b8 0d 12 80 00 00 	movabs $0x80120d,%rax
  8030df:	00 00 00 
  8030e2:	ff d0                	call   *%rax
  8030e4:	89 c7                	mov    %eax,%edi
  8030e6:	b9 06 00 00 00       	mov    $0x6,%ecx
  8030eb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030f0:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  8030f7:	00 00 00 
  8030fa:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  803101:	00 00 00 
  803104:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  803106:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  80310d:	00 00 00 
  803110:	48 8b 02             	mov    (%rdx),%rax
  803113:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803117:	48 89 0a             	mov    %rcx,(%rdx)
  80311a:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803121:	00 00 00 
  803124:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  803128:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80312f:	00 00 00 
  803132:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  803135:	e9 70 ff ff ff       	jmp    8030aa <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  80313a:	89 c1                	mov    %eax,%ecx
  80313c:	48 ba cc 43 80 00 00 	movabs $0x8043cc,%rdx
  803143:	00 00 00 
  803146:	be 3d 00 00 00       	mov    $0x3d,%esi
  80314b:	48 bf be 43 80 00 00 	movabs $0x8043be,%rdi
  803152:	00 00 00 
  803155:	b8 00 00 00 00       	mov    $0x0,%eax
  80315a:	49 b8 33 02 80 00 00 	movabs $0x800233,%r8
  803161:	00 00 00 
  803164:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  803167:	b8 00 00 00 00       	mov    $0x0,%eax
  80316c:	e9 61 ff ff ff       	jmp    8030d2 <add_pgfault_handler+0xa1>

0000000000803171 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  803171:	f3 0f 1e fa          	endbr64
  803175:	55                   	push   %rbp
  803176:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  803179:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803180:	00 00 00 
  803183:	80 38 00             	cmpb   $0x0,(%rax)
  803186:	74 33                	je     8031bb <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803188:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  80318f:	00 00 00 
  803192:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  803197:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  80319e:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8031a1:	48 85 c0             	test   %rax,%rax
  8031a4:	0f 84 85 00 00 00    	je     80322f <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  8031aa:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  8031ae:	74 40                	je     8031f0 <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8031b0:	48 83 c1 01          	add    $0x1,%rcx
  8031b4:	48 39 c1             	cmp    %rax,%rcx
  8031b7:	75 f1                	jne    8031aa <remove_pgfault_handler+0x39>
  8031b9:	eb 74                	jmp    80322f <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  8031bb:	48 b9 e4 43 80 00 00 	movabs $0x8043e4,%rcx
  8031c2:	00 00 00 
  8031c5:	48 ba 66 43 80 00 00 	movabs $0x804366,%rdx
  8031cc:	00 00 00 
  8031cf:	be 43 00 00 00       	mov    $0x43,%esi
  8031d4:	48 bf be 43 80 00 00 	movabs $0x8043be,%rdi
  8031db:	00 00 00 
  8031de:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e3:	49 b8 33 02 80 00 00 	movabs $0x800233,%r8
  8031ea:	00 00 00 
  8031ed:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  8031f0:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  8031f7:	00 
  8031f8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8031fc:	48 29 ca             	sub    %rcx,%rdx
  8031ff:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803206:	00 00 00 
  803209:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  80320d:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  803212:	48 89 ce             	mov    %rcx,%rsi
  803215:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  80321c:	00 00 00 
  80321f:	ff d0                	call   *%rax
            _pfhandler_off--;
  803221:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803228:	00 00 00 
  80322b:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  80322f:	5d                   	pop    %rbp
  803230:	c3                   	ret

0000000000803231 <__text_end>:
  803231:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803238:	00 00 00 
  80323b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803242:	00 00 00 
  803245:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80324c:	00 00 00 
  80324f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803256:	00 00 00 
  803259:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803260:	00 00 00 
  803263:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80326a:	00 00 00 
  80326d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803274:	00 00 00 
  803277:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80327e:	00 00 00 
  803281:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803288:	00 00 00 
  80328b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803292:	00 00 00 
  803295:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80329c:	00 00 00 
  80329f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032a6:	00 00 00 
  8032a9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032b0:	00 00 00 
  8032b3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032ba:	00 00 00 
  8032bd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032c4:	00 00 00 
  8032c7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032ce:	00 00 00 
  8032d1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032d8:	00 00 00 
  8032db:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032e2:	00 00 00 
  8032e5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032ec:	00 00 00 
  8032ef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032f6:	00 00 00 
  8032f9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803300:	00 00 00 
  803303:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80330a:	00 00 00 
  80330d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803314:	00 00 00 
  803317:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80331e:	00 00 00 
  803321:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803328:	00 00 00 
  80332b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803332:	00 00 00 
  803335:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80333c:	00 00 00 
  80333f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803346:	00 00 00 
  803349:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803350:	00 00 00 
  803353:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80335a:	00 00 00 
  80335d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803364:	00 00 00 
  803367:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80336e:	00 00 00 
  803371:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803378:	00 00 00 
  80337b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803382:	00 00 00 
  803385:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80338c:	00 00 00 
  80338f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803396:	00 00 00 
  803399:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033a0:	00 00 00 
  8033a3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033aa:	00 00 00 
  8033ad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033b4:	00 00 00 
  8033b7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033be:	00 00 00 
  8033c1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033c8:	00 00 00 
  8033cb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033d2:	00 00 00 
  8033d5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033dc:	00 00 00 
  8033df:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033e6:	00 00 00 
  8033e9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033f0:	00 00 00 
  8033f3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033fa:	00 00 00 
  8033fd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803404:	00 00 00 
  803407:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80340e:	00 00 00 
  803411:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803418:	00 00 00 
  80341b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803422:	00 00 00 
  803425:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80342c:	00 00 00 
  80342f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803436:	00 00 00 
  803439:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803440:	00 00 00 
  803443:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80344a:	00 00 00 
  80344d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803454:	00 00 00 
  803457:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80345e:	00 00 00 
  803461:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803468:	00 00 00 
  80346b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803472:	00 00 00 
  803475:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80347c:	00 00 00 
  80347f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803486:	00 00 00 
  803489:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803490:	00 00 00 
  803493:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80349a:	00 00 00 
  80349d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034a4:	00 00 00 
  8034a7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ae:	00 00 00 
  8034b1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034b8:	00 00 00 
  8034bb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034c2:	00 00 00 
  8034c5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034cc:	00 00 00 
  8034cf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034d6:	00 00 00 
  8034d9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034e0:	00 00 00 
  8034e3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ea:	00 00 00 
  8034ed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034f4:	00 00 00 
  8034f7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034fe:	00 00 00 
  803501:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803508:	00 00 00 
  80350b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803512:	00 00 00 
  803515:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80351c:	00 00 00 
  80351f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803526:	00 00 00 
  803529:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803530:	00 00 00 
  803533:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80353a:	00 00 00 
  80353d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803544:	00 00 00 
  803547:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80354e:	00 00 00 
  803551:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803558:	00 00 00 
  80355b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803562:	00 00 00 
  803565:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80356c:	00 00 00 
  80356f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803576:	00 00 00 
  803579:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803580:	00 00 00 
  803583:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80358a:	00 00 00 
  80358d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803594:	00 00 00 
  803597:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80359e:	00 00 00 
  8035a1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a8:	00 00 00 
  8035ab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b2:	00 00 00 
  8035b5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035bc:	00 00 00 
  8035bf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035c6:	00 00 00 
  8035c9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035d0:	00 00 00 
  8035d3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035da:	00 00 00 
  8035dd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035e4:	00 00 00 
  8035e7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ee:	00 00 00 
  8035f1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035f8:	00 00 00 
  8035fb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803602:	00 00 00 
  803605:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80360c:	00 00 00 
  80360f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803616:	00 00 00 
  803619:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803620:	00 00 00 
  803623:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80362a:	00 00 00 
  80362d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803634:	00 00 00 
  803637:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80363e:	00 00 00 
  803641:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803648:	00 00 00 
  80364b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803652:	00 00 00 
  803655:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80365c:	00 00 00 
  80365f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803666:	00 00 00 
  803669:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803670:	00 00 00 
  803673:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80367a:	00 00 00 
  80367d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803684:	00 00 00 
  803687:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80368e:	00 00 00 
  803691:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803698:	00 00 00 
  80369b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036a2:	00 00 00 
  8036a5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ac:	00 00 00 
  8036af:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036b6:	00 00 00 
  8036b9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036c0:	00 00 00 
  8036c3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ca:	00 00 00 
  8036cd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036d4:	00 00 00 
  8036d7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036de:	00 00 00 
  8036e1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036e8:	00 00 00 
  8036eb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036f2:	00 00 00 
  8036f5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036fc:	00 00 00 
  8036ff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803706:	00 00 00 
  803709:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803710:	00 00 00 
  803713:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80371a:	00 00 00 
  80371d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803724:	00 00 00 
  803727:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80372e:	00 00 00 
  803731:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803738:	00 00 00 
  80373b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803742:	00 00 00 
  803745:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80374c:	00 00 00 
  80374f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803756:	00 00 00 
  803759:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803760:	00 00 00 
  803763:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80376a:	00 00 00 
  80376d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803774:	00 00 00 
  803777:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80377e:	00 00 00 
  803781:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803788:	00 00 00 
  80378b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803792:	00 00 00 
  803795:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80379c:	00 00 00 
  80379f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a6:	00 00 00 
  8037a9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b0:	00 00 00 
  8037b3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ba:	00 00 00 
  8037bd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c4:	00 00 00 
  8037c7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ce:	00 00 00 
  8037d1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d8:	00 00 00 
  8037db:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e2:	00 00 00 
  8037e5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ec:	00 00 00 
  8037ef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f6:	00 00 00 
  8037f9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803800:	00 00 00 
  803803:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80380a:	00 00 00 
  80380d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803814:	00 00 00 
  803817:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80381e:	00 00 00 
  803821:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803828:	00 00 00 
  80382b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803832:	00 00 00 
  803835:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80383c:	00 00 00 
  80383f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803846:	00 00 00 
  803849:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803850:	00 00 00 
  803853:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80385a:	00 00 00 
  80385d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803864:	00 00 00 
  803867:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80386e:	00 00 00 
  803871:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803878:	00 00 00 
  80387b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803882:	00 00 00 
  803885:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80388c:	00 00 00 
  80388f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803896:	00 00 00 
  803899:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a0:	00 00 00 
  8038a3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038aa:	00 00 00 
  8038ad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b4:	00 00 00 
  8038b7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038be:	00 00 00 
  8038c1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c8:	00 00 00 
  8038cb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d2:	00 00 00 
  8038d5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038dc:	00 00 00 
  8038df:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e6:	00 00 00 
  8038e9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f0:	00 00 00 
  8038f3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038fa:	00 00 00 
  8038fd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803904:	00 00 00 
  803907:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80390e:	00 00 00 
  803911:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803918:	00 00 00 
  80391b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803922:	00 00 00 
  803925:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80392c:	00 00 00 
  80392f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803936:	00 00 00 
  803939:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803940:	00 00 00 
  803943:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80394a:	00 00 00 
  80394d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803954:	00 00 00 
  803957:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80395e:	00 00 00 
  803961:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803968:	00 00 00 
  80396b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803972:	00 00 00 
  803975:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80397c:	00 00 00 
  80397f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803986:	00 00 00 
  803989:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803990:	00 00 00 
  803993:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80399a:	00 00 00 
  80399d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a4:	00 00 00 
  8039a7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ae:	00 00 00 
  8039b1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b8:	00 00 00 
  8039bb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c2:	00 00 00 
  8039c5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039cc:	00 00 00 
  8039cf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d6:	00 00 00 
  8039d9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e0:	00 00 00 
  8039e3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ea:	00 00 00 
  8039ed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f4:	00 00 00 
  8039f7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039fe:	00 00 00 
  803a01:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a08:	00 00 00 
  803a0b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a12:	00 00 00 
  803a15:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a1c:	00 00 00 
  803a1f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a26:	00 00 00 
  803a29:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a30:	00 00 00 
  803a33:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a3a:	00 00 00 
  803a3d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a44:	00 00 00 
  803a47:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a4e:	00 00 00 
  803a51:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a58:	00 00 00 
  803a5b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a62:	00 00 00 
  803a65:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a6c:	00 00 00 
  803a6f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a76:	00 00 00 
  803a79:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a80:	00 00 00 
  803a83:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a8a:	00 00 00 
  803a8d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a94:	00 00 00 
  803a97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a9e:	00 00 00 
  803aa1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa8:	00 00 00 
  803aab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab2:	00 00 00 
  803ab5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803abc:	00 00 00 
  803abf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac6:	00 00 00 
  803ac9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad0:	00 00 00 
  803ad3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ada:	00 00 00 
  803add:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae4:	00 00 00 
  803ae7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aee:	00 00 00 
  803af1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af8:	00 00 00 
  803afb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b02:	00 00 00 
  803b05:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b0c:	00 00 00 
  803b0f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b16:	00 00 00 
  803b19:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b20:	00 00 00 
  803b23:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b2a:	00 00 00 
  803b2d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b34:	00 00 00 
  803b37:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b3e:	00 00 00 
  803b41:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b48:	00 00 00 
  803b4b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b52:	00 00 00 
  803b55:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b5c:	00 00 00 
  803b5f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b66:	00 00 00 
  803b69:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b70:	00 00 00 
  803b73:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b7a:	00 00 00 
  803b7d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b84:	00 00 00 
  803b87:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b8e:	00 00 00 
  803b91:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b98:	00 00 00 
  803b9b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba2:	00 00 00 
  803ba5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bac:	00 00 00 
  803baf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb6:	00 00 00 
  803bb9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc0:	00 00 00 
  803bc3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bca:	00 00 00 
  803bcd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd4:	00 00 00 
  803bd7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bde:	00 00 00 
  803be1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be8:	00 00 00 
  803beb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf2:	00 00 00 
  803bf5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bfc:	00 00 00 
  803bff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c06:	00 00 00 
  803c09:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c10:	00 00 00 
  803c13:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c1a:	00 00 00 
  803c1d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c24:	00 00 00 
  803c27:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c2e:	00 00 00 
  803c31:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c38:	00 00 00 
  803c3b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c42:	00 00 00 
  803c45:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c4c:	00 00 00 
  803c4f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c56:	00 00 00 
  803c59:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c60:	00 00 00 
  803c63:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c6a:	00 00 00 
  803c6d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c74:	00 00 00 
  803c77:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c7e:	00 00 00 
  803c81:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c88:	00 00 00 
  803c8b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c92:	00 00 00 
  803c95:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c9c:	00 00 00 
  803c9f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca6:	00 00 00 
  803ca9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb0:	00 00 00 
  803cb3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cba:	00 00 00 
  803cbd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc4:	00 00 00 
  803cc7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cce:	00 00 00 
  803cd1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd8:	00 00 00 
  803cdb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce2:	00 00 00 
  803ce5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cec:	00 00 00 
  803cef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf6:	00 00 00 
  803cf9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d00:	00 00 00 
  803d03:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d0a:	00 00 00 
  803d0d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d14:	00 00 00 
  803d17:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d1e:	00 00 00 
  803d21:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d28:	00 00 00 
  803d2b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d32:	00 00 00 
  803d35:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d3c:	00 00 00 
  803d3f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d46:	00 00 00 
  803d49:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d50:	00 00 00 
  803d53:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d5a:	00 00 00 
  803d5d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d64:	00 00 00 
  803d67:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d6e:	00 00 00 
  803d71:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d78:	00 00 00 
  803d7b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d82:	00 00 00 
  803d85:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d8c:	00 00 00 
  803d8f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d96:	00 00 00 
  803d99:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da0:	00 00 00 
  803da3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803daa:	00 00 00 
  803dad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db4:	00 00 00 
  803db7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dbe:	00 00 00 
  803dc1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc8:	00 00 00 
  803dcb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd2:	00 00 00 
  803dd5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ddc:	00 00 00 
  803ddf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de6:	00 00 00 
  803de9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df0:	00 00 00 
  803df3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dfa:	00 00 00 
  803dfd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e04:	00 00 00 
  803e07:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e0e:	00 00 00 
  803e11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e18:	00 00 00 
  803e1b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e22:	00 00 00 
  803e25:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e2c:	00 00 00 
  803e2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e36:	00 00 00 
  803e39:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e40:	00 00 00 
  803e43:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e4a:	00 00 00 
  803e4d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e54:	00 00 00 
  803e57:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e5e:	00 00 00 
  803e61:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e68:	00 00 00 
  803e6b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e72:	00 00 00 
  803e75:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e7c:	00 00 00 
  803e7f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e86:	00 00 00 
  803e89:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e90:	00 00 00 
  803e93:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e9a:	00 00 00 
  803e9d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea4:	00 00 00 
  803ea7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eae:	00 00 00 
  803eb1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb8:	00 00 00 
  803ebb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec2:	00 00 00 
  803ec5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ecc:	00 00 00 
  803ecf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed6:	00 00 00 
  803ed9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee0:	00 00 00 
  803ee3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eea:	00 00 00 
  803eed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef4:	00 00 00 
  803ef7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803efe:	00 00 00 
  803f01:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f08:	00 00 00 
  803f0b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f12:	00 00 00 
  803f15:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f1c:	00 00 00 
  803f1f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f26:	00 00 00 
  803f29:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f30:	00 00 00 
  803f33:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f3a:	00 00 00 
  803f3d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f44:	00 00 00 
  803f47:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f4e:	00 00 00 
  803f51:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f58:	00 00 00 
  803f5b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f62:	00 00 00 
  803f65:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f6c:	00 00 00 
  803f6f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f76:	00 00 00 
  803f79:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f80:	00 00 00 
  803f83:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f8a:	00 00 00 
  803f8d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f94:	00 00 00 
  803f97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f9e:	00 00 00 
  803fa1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa8:	00 00 00 
  803fab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb2:	00 00 00 
  803fb5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fbc:	00 00 00 
  803fbf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc6:	00 00 00 
  803fc9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd0:	00 00 00 
  803fd3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fda:	00 00 00 
  803fdd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe4:	00 00 00 
  803fe7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fee:	00 00 00 
  803ff1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff8:	00 00 00 
  803ffb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
