
obj/user/primes:     file format elf64-x86-64


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
  80001e:	e8 70 01 00 00       	call   800193 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <primeproc>:
 * of main and user/idle. */

#include <inc/lib.h>

unsigned
primeproc(void) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 57                	push   %r15
  80002f:	41 56                	push   %r14
  800031:	41 55                	push   %r13
  800033:	41 54                	push   %r12
  800035:	53                   	push   %rbx
  800036:	48 83 ec 18          	sub    $0x18,%rsp
    int i, id, p;
    envid_t envid;

    /* Fetch a prime from our left neighbor */
top:
    p = ipc_recv(&envid, 0, 0, 0);
  80003a:	49 bf 36 18 80 00 00 	movabs $0x801836,%r15
  800041:	00 00 00 
    cprintf("%d ", p);
  800044:	49 be c8 03 80 00 00 	movabs $0x8003c8,%r14
  80004b:	00 00 00 

    /* Fork a right neighbor to continue the chain */
    if ((id = fork()) < 0)
  80004e:	49 bd da 16 80 00 00 	movabs $0x8016da,%r13
  800055:	00 00 00 
    p = ipc_recv(&envid, 0, 0, 0);
  800058:	b9 00 00 00 00       	mov    $0x0,%ecx
  80005d:	ba 00 00 00 00       	mov    $0x0,%edx
  800062:	be 00 00 00 00       	mov    $0x0,%esi
  800067:	48 8d 7d cc          	lea    -0x34(%rbp),%rdi
  80006b:	41 ff d7             	call   *%r15
  80006e:	89 c3                	mov    %eax,%ebx
    cprintf("%d ", p);
  800070:	89 c6                	mov    %eax,%esi
  800072:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  800079:	00 00 00 
  80007c:	b8 00 00 00 00       	mov    $0x0,%eax
  800081:	41 ff d6             	call   *%r14
    if ((id = fork()) < 0)
  800084:	41 ff d5             	call   *%r13
  800087:	41 89 c4             	mov    %eax,%r12d
  80008a:	85 c0                	test   %eax,%eax
  80008c:	78 4d                	js     8000db <primeproc+0xb6>
        panic("fork: %i", id);
    if (id == 0)
  80008e:	74 c8                	je     800058 <primeproc+0x33>
        goto top;

    /* Filter out multiples of our prime */
    while (1) {
        i = ipc_recv(&envid, 0, 0, 0);
  800090:	49 bd 36 18 80 00 00 	movabs $0x801836,%r13
  800097:	00 00 00 
        if (i % p)
            ipc_send(id, i, 0, 0, 0);
  80009a:	49 be cf 18 80 00 00 	movabs $0x8018cf,%r14
  8000a1:	00 00 00 
        i = ipc_recv(&envid, 0, 0, 0);
  8000a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ae:	be 00 00 00 00       	mov    $0x0,%esi
  8000b3:	48 8d 7d cc          	lea    -0x34(%rbp),%rdi
  8000b7:	41 ff d5             	call   *%r13
  8000ba:	89 c6                	mov    %eax,%esi
        if (i % p)
  8000bc:	99                   	cltd
  8000bd:	f7 fb                	idiv   %ebx
  8000bf:	85 d2                	test   %edx,%edx
  8000c1:	74 e1                	je     8000a4 <primeproc+0x7f>
            ipc_send(id, i, 0, 0, 0);
  8000c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8000c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d3:	44 89 e7             	mov    %r12d,%edi
  8000d6:	41 ff d6             	call   *%r14
  8000d9:	eb c9                	jmp    8000a4 <primeproc+0x7f>
        panic("fork: %i", id);
  8000db:	89 c1                	mov    %eax,%ecx
  8000dd:	48 ba 04 40 80 00 00 	movabs $0x804004,%rdx
  8000e4:	00 00 00 
  8000e7:	be 19 00 00 00       	mov    $0x19,%esi
  8000ec:	48 bf 0d 40 80 00 00 	movabs $0x80400d,%rdi
  8000f3:	00 00 00 
  8000f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fb:	49 b8 6c 02 80 00 00 	movabs $0x80026c,%r8
  800102:	00 00 00 
  800105:	41 ff d0             	call   *%r8

0000000000800108 <umain>:
    }
}

void
umain(int argc, char **argv) {
  800108:	f3 0f 1e fa          	endbr64
  80010c:	55                   	push   %rbp
  80010d:	48 89 e5             	mov    %rsp,%rbp
  800110:	41 55                	push   %r13
  800112:	41 54                	push   %r12
  800114:	53                   	push   %rbx
  800115:	48 83 ec 08          	sub    $0x8,%rsp
    int id;

    /* Fork the first prime process in the chain */
    if ((id = fork()) < 0)
  800119:	48 b8 da 16 80 00 00 	movabs $0x8016da,%rax
  800120:	00 00 00 
  800123:	ff d0                	call   *%rax
  800125:	41 89 c4             	mov    %eax,%r12d
  800128:	85 c0                	test   %eax,%eax
  80012a:	78 2e                	js     80015a <umain+0x52>
        panic("fork: %i", id);
    if (id == 0)
        primeproc();

    /* Feed all the integers through */
    for (int i = 2;; i++)
  80012c:	bb 02 00 00 00       	mov    $0x2,%ebx
        ipc_send(id, i, 0, 0, 0);
  800131:	49 bd cf 18 80 00 00 	movabs $0x8018cf,%r13
  800138:	00 00 00 
    if (id == 0)
  80013b:	74 4a                	je     800187 <umain+0x7f>
        ipc_send(id, i, 0, 0, 0);
  80013d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800143:	b9 00 00 00 00       	mov    $0x0,%ecx
  800148:	ba 00 00 00 00       	mov    $0x0,%edx
  80014d:	89 de                	mov    %ebx,%esi
  80014f:	44 89 e7             	mov    %r12d,%edi
  800152:	41 ff d5             	call   *%r13
    for (int i = 2;; i++)
  800155:	83 c3 01             	add    $0x1,%ebx
  800158:	eb e3                	jmp    80013d <umain+0x35>
        panic("fork: %i", id);
  80015a:	89 c1                	mov    %eax,%ecx
  80015c:	48 ba 04 40 80 00 00 	movabs $0x804004,%rdx
  800163:	00 00 00 
  800166:	be 2b 00 00 00       	mov    $0x2b,%esi
  80016b:	48 bf 0d 40 80 00 00 	movabs $0x80400d,%rdi
  800172:	00 00 00 
  800175:	b8 00 00 00 00       	mov    $0x0,%eax
  80017a:	49 b8 6c 02 80 00 00 	movabs $0x80026c,%r8
  800181:	00 00 00 
  800184:	41 ff d0             	call   *%r8
        primeproc();
  800187:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80018e:	00 00 00 
  800191:	ff d0                	call   *%rax

0000000000800193 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800193:	f3 0f 1e fa          	endbr64
  800197:	55                   	push   %rbp
  800198:	48 89 e5             	mov    %rsp,%rbp
  80019b:	41 56                	push   %r14
  80019d:	41 55                	push   %r13
  80019f:	41 54                	push   %r12
  8001a1:	53                   	push   %rbx
  8001a2:	41 89 fd             	mov    %edi,%r13d
  8001a5:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8001a8:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  8001af:	00 00 00 
  8001b2:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  8001b9:	00 00 00 
  8001bc:	48 39 c2             	cmp    %rax,%rdx
  8001bf:	73 17                	jae    8001d8 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8001c1:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8001c4:	49 89 c4             	mov    %rax,%r12
  8001c7:	48 83 c3 08          	add    $0x8,%rbx
  8001cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d0:	ff 53 f8             	call   *-0x8(%rbx)
  8001d3:	4c 39 e3             	cmp    %r12,%rbx
  8001d6:	72 ef                	jb     8001c7 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8001d8:	48 b8 46 12 80 00 00 	movabs $0x801246,%rax
  8001df:	00 00 00 
  8001e2:	ff d0                	call   *%rax
  8001e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e9:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8001ed:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8001f1:	48 c1 e0 04          	shl    $0x4,%rax
  8001f5:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8001fc:	00 00 00 
  8001ff:	48 01 d0             	add    %rdx,%rax
  800202:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  800209:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80020c:	45 85 ed             	test   %r13d,%r13d
  80020f:	7e 0d                	jle    80021e <libmain+0x8b>
  800211:	49 8b 06             	mov    (%r14),%rax
  800214:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80021b:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80021e:	4c 89 f6             	mov    %r14,%rsi
  800221:	44 89 ef             	mov    %r13d,%edi
  800224:	48 b8 08 01 80 00 00 	movabs $0x800108,%rax
  80022b:	00 00 00 
  80022e:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800230:	48 b8 45 02 80 00 00 	movabs $0x800245,%rax
  800237:	00 00 00 
  80023a:	ff d0                	call   *%rax
#endif
}
  80023c:	5b                   	pop    %rbx
  80023d:	41 5c                	pop    %r12
  80023f:	41 5d                	pop    %r13
  800241:	41 5e                	pop    %r14
  800243:	5d                   	pop    %rbp
  800244:	c3                   	ret

0000000000800245 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800245:	f3 0f 1e fa          	endbr64
  800249:	55                   	push   %rbp
  80024a:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80024d:	48 b8 31 1c 80 00 00 	movabs $0x801c31,%rax
  800254:	00 00 00 
  800257:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800259:	bf 00 00 00 00       	mov    $0x0,%edi
  80025e:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  800265:	00 00 00 
  800268:	ff d0                	call   *%rax
}
  80026a:	5d                   	pop    %rbp
  80026b:	c3                   	ret

000000000080026c <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80026c:	f3 0f 1e fa          	endbr64
  800270:	55                   	push   %rbp
  800271:	48 89 e5             	mov    %rsp,%rbp
  800274:	41 56                	push   %r14
  800276:	41 55                	push   %r13
  800278:	41 54                	push   %r12
  80027a:	53                   	push   %rbx
  80027b:	48 83 ec 50          	sub    $0x50,%rsp
  80027f:	49 89 fc             	mov    %rdi,%r12
  800282:	41 89 f5             	mov    %esi,%r13d
  800285:	48 89 d3             	mov    %rdx,%rbx
  800288:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80028c:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800290:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800294:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  80029b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80029f:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8002a3:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8002a7:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8002ab:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8002b2:	00 00 00 
  8002b5:	4c 8b 30             	mov    (%rax),%r14
  8002b8:	48 b8 46 12 80 00 00 	movabs $0x801246,%rax
  8002bf:	00 00 00 
  8002c2:	ff d0                	call   *%rax
  8002c4:	89 c6                	mov    %eax,%esi
  8002c6:	45 89 e8             	mov    %r13d,%r8d
  8002c9:	4c 89 e1             	mov    %r12,%rcx
  8002cc:	4c 89 f2             	mov    %r14,%rdx
  8002cf:	48 bf d8 42 80 00 00 	movabs $0x8042d8,%rdi
  8002d6:	00 00 00 
  8002d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002de:	49 bc c8 03 80 00 00 	movabs $0x8003c8,%r12
  8002e5:	00 00 00 
  8002e8:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8002eb:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8002ef:	48 89 df             	mov    %rbx,%rdi
  8002f2:	48 b8 60 03 80 00 00 	movabs $0x800360,%rax
  8002f9:	00 00 00 
  8002fc:	ff d0                	call   *%rax
    cprintf("\n");
  8002fe:	48 bf 17 42 80 00 00 	movabs $0x804217,%rdi
  800305:	00 00 00 
  800308:	b8 00 00 00 00       	mov    $0x0,%eax
  80030d:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800310:	cc                   	int3
  800311:	eb fd                	jmp    800310 <_panic+0xa4>

0000000000800313 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800313:	f3 0f 1e fa          	endbr64
  800317:	55                   	push   %rbp
  800318:	48 89 e5             	mov    %rsp,%rbp
  80031b:	53                   	push   %rbx
  80031c:	48 83 ec 08          	sub    $0x8,%rsp
  800320:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800323:	8b 06                	mov    (%rsi),%eax
  800325:	8d 50 01             	lea    0x1(%rax),%edx
  800328:	89 16                	mov    %edx,(%rsi)
  80032a:	48 98                	cltq
  80032c:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800331:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800337:	74 0a                	je     800343 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800339:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80033d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800341:	c9                   	leave
  800342:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800343:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800347:	be ff 00 00 00       	mov    $0xff,%esi
  80034c:	48 b8 71 11 80 00 00 	movabs $0x801171,%rax
  800353:	00 00 00 
  800356:	ff d0                	call   *%rax
        state->offset = 0;
  800358:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80035e:	eb d9                	jmp    800339 <putch+0x26>

0000000000800360 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800360:	f3 0f 1e fa          	endbr64
  800364:	55                   	push   %rbp
  800365:	48 89 e5             	mov    %rsp,%rbp
  800368:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80036f:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800372:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800379:	b9 21 00 00 00       	mov    $0x21,%ecx
  80037e:	b8 00 00 00 00       	mov    $0x0,%eax
  800383:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800386:	48 89 f1             	mov    %rsi,%rcx
  800389:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800390:	48 bf 13 03 80 00 00 	movabs $0x800313,%rdi
  800397:	00 00 00 
  80039a:	48 b8 28 05 80 00 00 	movabs $0x800528,%rax
  8003a1:	00 00 00 
  8003a4:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8003a6:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8003ad:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8003b4:	48 b8 71 11 80 00 00 	movabs $0x801171,%rax
  8003bb:	00 00 00 
  8003be:	ff d0                	call   *%rax

    return state.count;
}
  8003c0:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8003c6:	c9                   	leave
  8003c7:	c3                   	ret

00000000008003c8 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8003c8:	f3 0f 1e fa          	endbr64
  8003cc:	55                   	push   %rbp
  8003cd:	48 89 e5             	mov    %rsp,%rbp
  8003d0:	48 83 ec 50          	sub    $0x50,%rsp
  8003d4:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8003d8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8003dc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003e0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8003e4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8003e8:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8003ef:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003f3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003f7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8003fb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8003ff:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800403:	48 b8 60 03 80 00 00 	movabs $0x800360,%rax
  80040a:	00 00 00 
  80040d:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80040f:	c9                   	leave
  800410:	c3                   	ret

0000000000800411 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800411:	f3 0f 1e fa          	endbr64
  800415:	55                   	push   %rbp
  800416:	48 89 e5             	mov    %rsp,%rbp
  800419:	41 57                	push   %r15
  80041b:	41 56                	push   %r14
  80041d:	41 55                	push   %r13
  80041f:	41 54                	push   %r12
  800421:	53                   	push   %rbx
  800422:	48 83 ec 18          	sub    $0x18,%rsp
  800426:	49 89 fc             	mov    %rdi,%r12
  800429:	49 89 f5             	mov    %rsi,%r13
  80042c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800430:	8b 45 10             	mov    0x10(%rbp),%eax
  800433:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800436:	41 89 cf             	mov    %ecx,%r15d
  800439:	4c 39 fa             	cmp    %r15,%rdx
  80043c:	73 5b                	jae    800499 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80043e:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800442:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800446:	85 db                	test   %ebx,%ebx
  800448:	7e 0e                	jle    800458 <print_num+0x47>
            putch(padc, put_arg);
  80044a:	4c 89 ee             	mov    %r13,%rsi
  80044d:	44 89 f7             	mov    %r14d,%edi
  800450:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800453:	83 eb 01             	sub    $0x1,%ebx
  800456:	75 f2                	jne    80044a <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800458:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80045c:	48 b9 36 40 80 00 00 	movabs $0x804036,%rcx
  800463:	00 00 00 
  800466:	48 b8 25 40 80 00 00 	movabs $0x804025,%rax
  80046d:	00 00 00 
  800470:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800474:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800478:	ba 00 00 00 00       	mov    $0x0,%edx
  80047d:	49 f7 f7             	div    %r15
  800480:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800484:	4c 89 ee             	mov    %r13,%rsi
  800487:	41 ff d4             	call   *%r12
}
  80048a:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80048e:	5b                   	pop    %rbx
  80048f:	41 5c                	pop    %r12
  800491:	41 5d                	pop    %r13
  800493:	41 5e                	pop    %r14
  800495:	41 5f                	pop    %r15
  800497:	5d                   	pop    %rbp
  800498:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800499:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80049d:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a2:	49 f7 f7             	div    %r15
  8004a5:	48 83 ec 08          	sub    $0x8,%rsp
  8004a9:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8004ad:	52                   	push   %rdx
  8004ae:	45 0f be c9          	movsbl %r9b,%r9d
  8004b2:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8004b6:	48 89 c2             	mov    %rax,%rdx
  8004b9:	48 b8 11 04 80 00 00 	movabs $0x800411,%rax
  8004c0:	00 00 00 
  8004c3:	ff d0                	call   *%rax
  8004c5:	48 83 c4 10          	add    $0x10,%rsp
  8004c9:	eb 8d                	jmp    800458 <print_num+0x47>

00000000008004cb <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8004cb:	f3 0f 1e fa          	endbr64
    state->count++;
  8004cf:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8004d3:	48 8b 06             	mov    (%rsi),%rax
  8004d6:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8004da:	73 0a                	jae    8004e6 <sprintputch+0x1b>
        *state->start++ = ch;
  8004dc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004e0:	48 89 16             	mov    %rdx,(%rsi)
  8004e3:	40 88 38             	mov    %dil,(%rax)
    }
}
  8004e6:	c3                   	ret

00000000008004e7 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8004e7:	f3 0f 1e fa          	endbr64
  8004eb:	55                   	push   %rbp
  8004ec:	48 89 e5             	mov    %rsp,%rbp
  8004ef:	48 83 ec 50          	sub    $0x50,%rsp
  8004f3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8004f7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8004fb:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8004ff:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800506:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80050a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80050e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800512:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800516:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80051a:	48 b8 28 05 80 00 00 	movabs $0x800528,%rax
  800521:	00 00 00 
  800524:	ff d0                	call   *%rax
}
  800526:	c9                   	leave
  800527:	c3                   	ret

0000000000800528 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800528:	f3 0f 1e fa          	endbr64
  80052c:	55                   	push   %rbp
  80052d:	48 89 e5             	mov    %rsp,%rbp
  800530:	41 57                	push   %r15
  800532:	41 56                	push   %r14
  800534:	41 55                	push   %r13
  800536:	41 54                	push   %r12
  800538:	53                   	push   %rbx
  800539:	48 83 ec 38          	sub    $0x38,%rsp
  80053d:	49 89 fe             	mov    %rdi,%r14
  800540:	49 89 f5             	mov    %rsi,%r13
  800543:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800546:	48 8b 01             	mov    (%rcx),%rax
  800549:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80054d:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800551:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800555:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800559:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80055d:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800561:	0f b6 3b             	movzbl (%rbx),%edi
  800564:	40 80 ff 25          	cmp    $0x25,%dil
  800568:	74 18                	je     800582 <vprintfmt+0x5a>
            if (!ch) return;
  80056a:	40 84 ff             	test   %dil,%dil
  80056d:	0f 84 b2 06 00 00    	je     800c25 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800573:	40 0f b6 ff          	movzbl %dil,%edi
  800577:	4c 89 ee             	mov    %r13,%rsi
  80057a:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  80057d:	4c 89 e3             	mov    %r12,%rbx
  800580:	eb db                	jmp    80055d <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800582:	be 00 00 00 00       	mov    $0x0,%esi
  800587:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  80058b:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800590:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800596:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80059d:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8005a1:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8005a6:	41 0f b6 04 24       	movzbl (%r12),%eax
  8005ab:	88 45 a0             	mov    %al,-0x60(%rbp)
  8005ae:	83 e8 23             	sub    $0x23,%eax
  8005b1:	3c 57                	cmp    $0x57,%al
  8005b3:	0f 87 52 06 00 00    	ja     800c0b <vprintfmt+0x6e3>
  8005b9:	0f b6 c0             	movzbl %al,%eax
  8005bc:	48 b9 e0 43 80 00 00 	movabs $0x8043e0,%rcx
  8005c3:	00 00 00 
  8005c6:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8005ca:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8005cd:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8005d1:	eb ce                	jmp    8005a1 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8005d3:	49 89 dc             	mov    %rbx,%r12
  8005d6:	be 01 00 00 00       	mov    $0x1,%esi
  8005db:	eb c4                	jmp    8005a1 <vprintfmt+0x79>
            padc = ch;
  8005dd:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8005e1:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8005e4:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8005e7:	eb b8                	jmp    8005a1 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8005e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005ec:	83 f8 2f             	cmp    $0x2f,%eax
  8005ef:	77 24                	ja     800615 <vprintfmt+0xed>
  8005f1:	89 c1                	mov    %eax,%ecx
  8005f3:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8005f7:	83 c0 08             	add    $0x8,%eax
  8005fa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005fd:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800600:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800603:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800607:	79 98                	jns    8005a1 <vprintfmt+0x79>
                width = precision;
  800609:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  80060d:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800613:	eb 8c                	jmp    8005a1 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800615:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800619:	48 8d 41 08          	lea    0x8(%rcx),%rax
  80061d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800621:	eb da                	jmp    8005fd <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800623:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800628:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80062c:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800632:	3c 39                	cmp    $0x39,%al
  800634:	77 1c                	ja     800652 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800636:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  80063a:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80063e:	0f b6 c0             	movzbl %al,%eax
  800641:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800646:	0f b6 03             	movzbl (%rbx),%eax
  800649:	3c 39                	cmp    $0x39,%al
  80064b:	76 e9                	jbe    800636 <vprintfmt+0x10e>
        process_precision:
  80064d:	49 89 dc             	mov    %rbx,%r12
  800650:	eb b1                	jmp    800603 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800652:	49 89 dc             	mov    %rbx,%r12
  800655:	eb ac                	jmp    800603 <vprintfmt+0xdb>
            width = MAX(0, width);
  800657:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  80065a:	85 c9                	test   %ecx,%ecx
  80065c:	b8 00 00 00 00       	mov    $0x0,%eax
  800661:	0f 49 c1             	cmovns %ecx,%eax
  800664:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800667:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80066a:	e9 32 ff ff ff       	jmp    8005a1 <vprintfmt+0x79>
            lflag++;
  80066f:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800672:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800675:	e9 27 ff ff ff       	jmp    8005a1 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  80067a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80067d:	83 f8 2f             	cmp    $0x2f,%eax
  800680:	77 19                	ja     80069b <vprintfmt+0x173>
  800682:	89 c2                	mov    %eax,%edx
  800684:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800688:	83 c0 08             	add    $0x8,%eax
  80068b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80068e:	8b 3a                	mov    (%rdx),%edi
  800690:	4c 89 ee             	mov    %r13,%rsi
  800693:	41 ff d6             	call   *%r14
            break;
  800696:	e9 c2 fe ff ff       	jmp    80055d <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  80069b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80069f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006a3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006a7:	eb e5                	jmp    80068e <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8006a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006ac:	83 f8 2f             	cmp    $0x2f,%eax
  8006af:	77 5a                	ja     80070b <vprintfmt+0x1e3>
  8006b1:	89 c2                	mov    %eax,%edx
  8006b3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006b7:	83 c0 08             	add    $0x8,%eax
  8006ba:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8006bd:	8b 02                	mov    (%rdx),%eax
  8006bf:	89 c1                	mov    %eax,%ecx
  8006c1:	f7 d9                	neg    %ecx
  8006c3:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8006c6:	83 f9 13             	cmp    $0x13,%ecx
  8006c9:	7f 4e                	jg     800719 <vprintfmt+0x1f1>
  8006cb:	48 63 c1             	movslq %ecx,%rax
  8006ce:	48 ba a0 46 80 00 00 	movabs $0x8046a0,%rdx
  8006d5:	00 00 00 
  8006d8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8006dc:	48 85 c0             	test   %rax,%rax
  8006df:	74 38                	je     800719 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8006e1:	48 89 c1             	mov    %rax,%rcx
  8006e4:	48 ba 65 42 80 00 00 	movabs $0x804265,%rdx
  8006eb:	00 00 00 
  8006ee:	4c 89 ee             	mov    %r13,%rsi
  8006f1:	4c 89 f7             	mov    %r14,%rdi
  8006f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f9:	49 b8 e7 04 80 00 00 	movabs $0x8004e7,%r8
  800700:	00 00 00 
  800703:	41 ff d0             	call   *%r8
  800706:	e9 52 fe ff ff       	jmp    80055d <vprintfmt+0x35>
            int err = va_arg(aq, int);
  80070b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80070f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800713:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800717:	eb a4                	jmp    8006bd <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800719:	48 ba 4e 40 80 00 00 	movabs $0x80404e,%rdx
  800720:	00 00 00 
  800723:	4c 89 ee             	mov    %r13,%rsi
  800726:	4c 89 f7             	mov    %r14,%rdi
  800729:	b8 00 00 00 00       	mov    $0x0,%eax
  80072e:	49 b8 e7 04 80 00 00 	movabs $0x8004e7,%r8
  800735:	00 00 00 
  800738:	41 ff d0             	call   *%r8
  80073b:	e9 1d fe ff ff       	jmp    80055d <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800740:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800743:	83 f8 2f             	cmp    $0x2f,%eax
  800746:	77 6c                	ja     8007b4 <vprintfmt+0x28c>
  800748:	89 c2                	mov    %eax,%edx
  80074a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80074e:	83 c0 08             	add    $0x8,%eax
  800751:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800754:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800757:	48 85 d2             	test   %rdx,%rdx
  80075a:	48 b8 47 40 80 00 00 	movabs $0x804047,%rax
  800761:	00 00 00 
  800764:	48 0f 45 c2          	cmovne %rdx,%rax
  800768:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  80076c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800770:	7e 06                	jle    800778 <vprintfmt+0x250>
  800772:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800776:	75 4a                	jne    8007c2 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800778:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80077c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800780:	0f b6 00             	movzbl (%rax),%eax
  800783:	84 c0                	test   %al,%al
  800785:	0f 85 9a 00 00 00    	jne    800825 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  80078b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80078e:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  800792:	85 c0                	test   %eax,%eax
  800794:	0f 8e c3 fd ff ff    	jle    80055d <vprintfmt+0x35>
  80079a:	4c 89 ee             	mov    %r13,%rsi
  80079d:	bf 20 00 00 00       	mov    $0x20,%edi
  8007a2:	41 ff d6             	call   *%r14
  8007a5:	41 83 ec 01          	sub    $0x1,%r12d
  8007a9:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8007ad:	75 eb                	jne    80079a <vprintfmt+0x272>
  8007af:	e9 a9 fd ff ff       	jmp    80055d <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8007b4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007b8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007c0:	eb 92                	jmp    800754 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8007c2:	49 63 f7             	movslq %r15d,%rsi
  8007c5:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8007c9:	48 b8 eb 0c 80 00 00 	movabs $0x800ceb,%rax
  8007d0:	00 00 00 
  8007d3:	ff d0                	call   *%rax
  8007d5:	48 89 c2             	mov    %rax,%rdx
  8007d8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007db:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8007dd:	8d 70 ff             	lea    -0x1(%rax),%esi
  8007e0:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8007e3:	85 c0                	test   %eax,%eax
  8007e5:	7e 91                	jle    800778 <vprintfmt+0x250>
  8007e7:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  8007ec:	4c 89 ee             	mov    %r13,%rsi
  8007ef:	44 89 e7             	mov    %r12d,%edi
  8007f2:	41 ff d6             	call   *%r14
  8007f5:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8007f9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007fc:	83 f8 ff             	cmp    $0xffffffff,%eax
  8007ff:	75 eb                	jne    8007ec <vprintfmt+0x2c4>
  800801:	e9 72 ff ff ff       	jmp    800778 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800806:	0f b6 f8             	movzbl %al,%edi
  800809:	4c 89 ee             	mov    %r13,%rsi
  80080c:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80080f:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800813:	49 83 c4 01          	add    $0x1,%r12
  800817:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  80081d:	84 c0                	test   %al,%al
  80081f:	0f 84 66 ff ff ff    	je     80078b <vprintfmt+0x263>
  800825:	45 85 ff             	test   %r15d,%r15d
  800828:	78 0a                	js     800834 <vprintfmt+0x30c>
  80082a:	41 83 ef 01          	sub    $0x1,%r15d
  80082e:	0f 88 57 ff ff ff    	js     80078b <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800834:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800838:	74 cc                	je     800806 <vprintfmt+0x2de>
  80083a:	8d 50 e0             	lea    -0x20(%rax),%edx
  80083d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800842:	80 fa 5e             	cmp    $0x5e,%dl
  800845:	77 c2                	ja     800809 <vprintfmt+0x2e1>
  800847:	eb bd                	jmp    800806 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800849:	40 84 f6             	test   %sil,%sil
  80084c:	75 26                	jne    800874 <vprintfmt+0x34c>
    switch (lflag) {
  80084e:	85 d2                	test   %edx,%edx
  800850:	74 59                	je     8008ab <vprintfmt+0x383>
  800852:	83 fa 01             	cmp    $0x1,%edx
  800855:	74 7b                	je     8008d2 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800857:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085a:	83 f8 2f             	cmp    $0x2f,%eax
  80085d:	0f 87 96 00 00 00    	ja     8008f9 <vprintfmt+0x3d1>
  800863:	89 c2                	mov    %eax,%edx
  800865:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800869:	83 c0 08             	add    $0x8,%eax
  80086c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80086f:	4c 8b 22             	mov    (%rdx),%r12
  800872:	eb 17                	jmp    80088b <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800874:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800877:	83 f8 2f             	cmp    $0x2f,%eax
  80087a:	77 21                	ja     80089d <vprintfmt+0x375>
  80087c:	89 c2                	mov    %eax,%edx
  80087e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800882:	83 c0 08             	add    $0x8,%eax
  800885:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800888:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  80088b:	4d 85 e4             	test   %r12,%r12
  80088e:	78 7a                	js     80090a <vprintfmt+0x3e2>
            num = i;
  800890:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800893:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800898:	e9 50 02 00 00       	jmp    800aed <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80089d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008a1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008a5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008a9:	eb dd                	jmp    800888 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8008ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ae:	83 f8 2f             	cmp    $0x2f,%eax
  8008b1:	77 11                	ja     8008c4 <vprintfmt+0x39c>
  8008b3:	89 c2                	mov    %eax,%edx
  8008b5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008b9:	83 c0 08             	add    $0x8,%eax
  8008bc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008bf:	4c 63 22             	movslq (%rdx),%r12
  8008c2:	eb c7                	jmp    80088b <vprintfmt+0x363>
  8008c4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008cc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008d0:	eb ed                	jmp    8008bf <vprintfmt+0x397>
        return va_arg(*ap, long);
  8008d2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d5:	83 f8 2f             	cmp    $0x2f,%eax
  8008d8:	77 11                	ja     8008eb <vprintfmt+0x3c3>
  8008da:	89 c2                	mov    %eax,%edx
  8008dc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008e0:	83 c0 08             	add    $0x8,%eax
  8008e3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008e6:	4c 8b 22             	mov    (%rdx),%r12
  8008e9:	eb a0                	jmp    80088b <vprintfmt+0x363>
  8008eb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008ef:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008f3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008f7:	eb ed                	jmp    8008e6 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  8008f9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008fd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800901:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800905:	e9 65 ff ff ff       	jmp    80086f <vprintfmt+0x347>
                putch('-', put_arg);
  80090a:	4c 89 ee             	mov    %r13,%rsi
  80090d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800912:	41 ff d6             	call   *%r14
                i = -i;
  800915:	49 f7 dc             	neg    %r12
  800918:	e9 73 ff ff ff       	jmp    800890 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  80091d:	40 84 f6             	test   %sil,%sil
  800920:	75 32                	jne    800954 <vprintfmt+0x42c>
    switch (lflag) {
  800922:	85 d2                	test   %edx,%edx
  800924:	74 5d                	je     800983 <vprintfmt+0x45b>
  800926:	83 fa 01             	cmp    $0x1,%edx
  800929:	0f 84 82 00 00 00    	je     8009b1 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  80092f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800932:	83 f8 2f             	cmp    $0x2f,%eax
  800935:	0f 87 a5 00 00 00    	ja     8009e0 <vprintfmt+0x4b8>
  80093b:	89 c2                	mov    %eax,%edx
  80093d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800941:	83 c0 08             	add    $0x8,%eax
  800944:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800947:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80094a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80094f:	e9 99 01 00 00       	jmp    800aed <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800954:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800957:	83 f8 2f             	cmp    $0x2f,%eax
  80095a:	77 19                	ja     800975 <vprintfmt+0x44d>
  80095c:	89 c2                	mov    %eax,%edx
  80095e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800962:	83 c0 08             	add    $0x8,%eax
  800965:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800968:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80096b:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800970:	e9 78 01 00 00       	jmp    800aed <vprintfmt+0x5c5>
  800975:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800979:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80097d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800981:	eb e5                	jmp    800968 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800983:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800986:	83 f8 2f             	cmp    $0x2f,%eax
  800989:	77 18                	ja     8009a3 <vprintfmt+0x47b>
  80098b:	89 c2                	mov    %eax,%edx
  80098d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800991:	83 c0 08             	add    $0x8,%eax
  800994:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800997:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800999:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  80099e:	e9 4a 01 00 00       	jmp    800aed <vprintfmt+0x5c5>
  8009a3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009a7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009ab:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009af:	eb e6                	jmp    800997 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8009b1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b4:	83 f8 2f             	cmp    $0x2f,%eax
  8009b7:	77 19                	ja     8009d2 <vprintfmt+0x4aa>
  8009b9:	89 c2                	mov    %eax,%edx
  8009bb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009bf:	83 c0 08             	add    $0x8,%eax
  8009c2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009c5:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8009c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8009cd:	e9 1b 01 00 00       	jmp    800aed <vprintfmt+0x5c5>
  8009d2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009d6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009da:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009de:	eb e5                	jmp    8009c5 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  8009e0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009e8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ec:	e9 56 ff ff ff       	jmp    800947 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  8009f1:	40 84 f6             	test   %sil,%sil
  8009f4:	75 2e                	jne    800a24 <vprintfmt+0x4fc>
    switch (lflag) {
  8009f6:	85 d2                	test   %edx,%edx
  8009f8:	74 59                	je     800a53 <vprintfmt+0x52b>
  8009fa:	83 fa 01             	cmp    $0x1,%edx
  8009fd:	74 7f                	je     800a7e <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  8009ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a02:	83 f8 2f             	cmp    $0x2f,%eax
  800a05:	0f 87 9f 00 00 00    	ja     800aaa <vprintfmt+0x582>
  800a0b:	89 c2                	mov    %eax,%edx
  800a0d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a11:	83 c0 08             	add    $0x8,%eax
  800a14:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a17:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a1a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800a1f:	e9 c9 00 00 00       	jmp    800aed <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a27:	83 f8 2f             	cmp    $0x2f,%eax
  800a2a:	77 19                	ja     800a45 <vprintfmt+0x51d>
  800a2c:	89 c2                	mov    %eax,%edx
  800a2e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a32:	83 c0 08             	add    $0x8,%eax
  800a35:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a38:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a3b:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a40:	e9 a8 00 00 00       	jmp    800aed <vprintfmt+0x5c5>
  800a45:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a49:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a4d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a51:	eb e5                	jmp    800a38 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800a53:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a56:	83 f8 2f             	cmp    $0x2f,%eax
  800a59:	77 15                	ja     800a70 <vprintfmt+0x548>
  800a5b:	89 c2                	mov    %eax,%edx
  800a5d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a61:	83 c0 08             	add    $0x8,%eax
  800a64:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a67:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800a69:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800a6e:	eb 7d                	jmp    800aed <vprintfmt+0x5c5>
  800a70:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a74:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a78:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a7c:	eb e9                	jmp    800a67 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800a7e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a81:	83 f8 2f             	cmp    $0x2f,%eax
  800a84:	77 16                	ja     800a9c <vprintfmt+0x574>
  800a86:	89 c2                	mov    %eax,%edx
  800a88:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a8c:	83 c0 08             	add    $0x8,%eax
  800a8f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a92:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a95:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800a9a:	eb 51                	jmp    800aed <vprintfmt+0x5c5>
  800a9c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800aa4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aa8:	eb e8                	jmp    800a92 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800aaa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aae:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ab2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ab6:	e9 5c ff ff ff       	jmp    800a17 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800abb:	4c 89 ee             	mov    %r13,%rsi
  800abe:	bf 30 00 00 00       	mov    $0x30,%edi
  800ac3:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800ac6:	4c 89 ee             	mov    %r13,%rsi
  800ac9:	bf 78 00 00 00       	mov    $0x78,%edi
  800ace:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800ad1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad4:	83 f8 2f             	cmp    $0x2f,%eax
  800ad7:	77 47                	ja     800b20 <vprintfmt+0x5f8>
  800ad9:	89 c2                	mov    %eax,%edx
  800adb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800adf:	83 c0 08             	add    $0x8,%eax
  800ae2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ae5:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800ae8:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800aed:	48 83 ec 08          	sub    $0x8,%rsp
  800af1:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800af5:	0f 94 c0             	sete   %al
  800af8:	0f b6 c0             	movzbl %al,%eax
  800afb:	50                   	push   %rax
  800afc:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800b01:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800b05:	4c 89 ee             	mov    %r13,%rsi
  800b08:	4c 89 f7             	mov    %r14,%rdi
  800b0b:	48 b8 11 04 80 00 00 	movabs $0x800411,%rax
  800b12:	00 00 00 
  800b15:	ff d0                	call   *%rax
            break;
  800b17:	48 83 c4 10          	add    $0x10,%rsp
  800b1b:	e9 3d fa ff ff       	jmp    80055d <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800b20:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b24:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b28:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b2c:	eb b7                	jmp    800ae5 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800b2e:	40 84 f6             	test   %sil,%sil
  800b31:	75 2b                	jne    800b5e <vprintfmt+0x636>
    switch (lflag) {
  800b33:	85 d2                	test   %edx,%edx
  800b35:	74 56                	je     800b8d <vprintfmt+0x665>
  800b37:	83 fa 01             	cmp    $0x1,%edx
  800b3a:	74 7f                	je     800bbb <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800b3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3f:	83 f8 2f             	cmp    $0x2f,%eax
  800b42:	0f 87 a2 00 00 00    	ja     800bea <vprintfmt+0x6c2>
  800b48:	89 c2                	mov    %eax,%edx
  800b4a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b4e:	83 c0 08             	add    $0x8,%eax
  800b51:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b54:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b57:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800b5c:	eb 8f                	jmp    800aed <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b61:	83 f8 2f             	cmp    $0x2f,%eax
  800b64:	77 19                	ja     800b7f <vprintfmt+0x657>
  800b66:	89 c2                	mov    %eax,%edx
  800b68:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b6c:	83 c0 08             	add    $0x8,%eax
  800b6f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b72:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b75:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b7a:	e9 6e ff ff ff       	jmp    800aed <vprintfmt+0x5c5>
  800b7f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b83:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b87:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b8b:	eb e5                	jmp    800b72 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800b8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b90:	83 f8 2f             	cmp    $0x2f,%eax
  800b93:	77 18                	ja     800bad <vprintfmt+0x685>
  800b95:	89 c2                	mov    %eax,%edx
  800b97:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b9b:	83 c0 08             	add    $0x8,%eax
  800b9e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ba1:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800ba3:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800ba8:	e9 40 ff ff ff       	jmp    800aed <vprintfmt+0x5c5>
  800bad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bb5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bb9:	eb e6                	jmp    800ba1 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800bbb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbe:	83 f8 2f             	cmp    $0x2f,%eax
  800bc1:	77 19                	ja     800bdc <vprintfmt+0x6b4>
  800bc3:	89 c2                	mov    %eax,%edx
  800bc5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bc9:	83 c0 08             	add    $0x8,%eax
  800bcc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bcf:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800bd2:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800bd7:	e9 11 ff ff ff       	jmp    800aed <vprintfmt+0x5c5>
  800bdc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800be4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800be8:	eb e5                	jmp    800bcf <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800bea:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bee:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bf2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bf6:	e9 59 ff ff ff       	jmp    800b54 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800bfb:	4c 89 ee             	mov    %r13,%rsi
  800bfe:	bf 25 00 00 00       	mov    $0x25,%edi
  800c03:	41 ff d6             	call   *%r14
            break;
  800c06:	e9 52 f9 ff ff       	jmp    80055d <vprintfmt+0x35>
            putch('%', put_arg);
  800c0b:	4c 89 ee             	mov    %r13,%rsi
  800c0e:	bf 25 00 00 00       	mov    $0x25,%edi
  800c13:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800c16:	48 83 eb 01          	sub    $0x1,%rbx
  800c1a:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800c1e:	75 f6                	jne    800c16 <vprintfmt+0x6ee>
  800c20:	e9 38 f9 ff ff       	jmp    80055d <vprintfmt+0x35>
}
  800c25:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800c29:	5b                   	pop    %rbx
  800c2a:	41 5c                	pop    %r12
  800c2c:	41 5d                	pop    %r13
  800c2e:	41 5e                	pop    %r14
  800c30:	41 5f                	pop    %r15
  800c32:	5d                   	pop    %rbp
  800c33:	c3                   	ret

0000000000800c34 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800c34:	f3 0f 1e fa          	endbr64
  800c38:	55                   	push   %rbp
  800c39:	48 89 e5             	mov    %rsp,%rbp
  800c3c:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800c40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c44:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800c49:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800c4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800c54:	48 85 ff             	test   %rdi,%rdi
  800c57:	74 2b                	je     800c84 <vsnprintf+0x50>
  800c59:	48 85 f6             	test   %rsi,%rsi
  800c5c:	74 26                	je     800c84 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800c5e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c62:	48 bf cb 04 80 00 00 	movabs $0x8004cb,%rdi
  800c69:	00 00 00 
  800c6c:	48 b8 28 05 80 00 00 	movabs $0x800528,%rax
  800c73:	00 00 00 
  800c76:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800c78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c7c:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800c7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800c82:	c9                   	leave
  800c83:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800c84:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c89:	eb f7                	jmp    800c82 <vsnprintf+0x4e>

0000000000800c8b <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800c8b:	f3 0f 1e fa          	endbr64
  800c8f:	55                   	push   %rbp
  800c90:	48 89 e5             	mov    %rsp,%rbp
  800c93:	48 83 ec 50          	sub    $0x50,%rsp
  800c97:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c9b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800c9f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800ca3:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800caa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cae:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cb2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cb6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800cba:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800cbe:	48 b8 34 0c 80 00 00 	movabs $0x800c34,%rax
  800cc5:	00 00 00 
  800cc8:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800cca:	c9                   	leave
  800ccb:	c3                   	ret

0000000000800ccc <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800ccc:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800cd0:	80 3f 00             	cmpb   $0x0,(%rdi)
  800cd3:	74 10                	je     800ce5 <strlen+0x19>
    size_t n = 0;
  800cd5:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800cda:	48 83 c0 01          	add    $0x1,%rax
  800cde:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800ce2:	75 f6                	jne    800cda <strlen+0xe>
  800ce4:	c3                   	ret
    size_t n = 0;
  800ce5:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800cea:	c3                   	ret

0000000000800ceb <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800ceb:	f3 0f 1e fa          	endbr64
  800cef:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800cf2:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800cf7:	48 85 f6             	test   %rsi,%rsi
  800cfa:	74 10                	je     800d0c <strnlen+0x21>
  800cfc:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800d00:	74 0b                	je     800d0d <strnlen+0x22>
  800d02:	48 83 c2 01          	add    $0x1,%rdx
  800d06:	48 39 d0             	cmp    %rdx,%rax
  800d09:	75 f1                	jne    800cfc <strnlen+0x11>
  800d0b:	c3                   	ret
  800d0c:	c3                   	ret
  800d0d:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800d10:	c3                   	ret

0000000000800d11 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800d11:	f3 0f 1e fa          	endbr64
  800d15:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800d18:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1d:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800d21:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800d24:	48 83 c2 01          	add    $0x1,%rdx
  800d28:	84 c9                	test   %cl,%cl
  800d2a:	75 f1                	jne    800d1d <strcpy+0xc>
        ;
    return res;
}
  800d2c:	c3                   	ret

0000000000800d2d <strcat>:

char *
strcat(char *dst, const char *src) {
  800d2d:	f3 0f 1e fa          	endbr64
  800d31:	55                   	push   %rbp
  800d32:	48 89 e5             	mov    %rsp,%rbp
  800d35:	41 54                	push   %r12
  800d37:	53                   	push   %rbx
  800d38:	48 89 fb             	mov    %rdi,%rbx
  800d3b:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800d3e:	48 b8 cc 0c 80 00 00 	movabs $0x800ccc,%rax
  800d45:	00 00 00 
  800d48:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800d4a:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800d4e:	4c 89 e6             	mov    %r12,%rsi
  800d51:	48 b8 11 0d 80 00 00 	movabs $0x800d11,%rax
  800d58:	00 00 00 
  800d5b:	ff d0                	call   *%rax
    return dst;
}
  800d5d:	48 89 d8             	mov    %rbx,%rax
  800d60:	5b                   	pop    %rbx
  800d61:	41 5c                	pop    %r12
  800d63:	5d                   	pop    %rbp
  800d64:	c3                   	ret

0000000000800d65 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d65:	f3 0f 1e fa          	endbr64
  800d69:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800d6c:	48 85 d2             	test   %rdx,%rdx
  800d6f:	74 1f                	je     800d90 <strncpy+0x2b>
  800d71:	48 01 fa             	add    %rdi,%rdx
  800d74:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800d77:	48 83 c1 01          	add    $0x1,%rcx
  800d7b:	44 0f b6 06          	movzbl (%rsi),%r8d
  800d7f:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800d83:	41 80 f8 01          	cmp    $0x1,%r8b
  800d87:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800d8b:	48 39 ca             	cmp    %rcx,%rdx
  800d8e:	75 e7                	jne    800d77 <strncpy+0x12>
    }
    return ret;
}
  800d90:	c3                   	ret

0000000000800d91 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800d91:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800d95:	48 89 f8             	mov    %rdi,%rax
  800d98:	48 85 d2             	test   %rdx,%rdx
  800d9b:	74 24                	je     800dc1 <strlcpy+0x30>
        while (--size > 0 && *src)
  800d9d:	48 83 ea 01          	sub    $0x1,%rdx
  800da1:	74 1b                	je     800dbe <strlcpy+0x2d>
  800da3:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800da7:	0f b6 16             	movzbl (%rsi),%edx
  800daa:	84 d2                	test   %dl,%dl
  800dac:	74 10                	je     800dbe <strlcpy+0x2d>
            *dst++ = *src++;
  800dae:	48 83 c6 01          	add    $0x1,%rsi
  800db2:	48 83 c0 01          	add    $0x1,%rax
  800db6:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800db9:	48 39 c8             	cmp    %rcx,%rax
  800dbc:	75 e9                	jne    800da7 <strlcpy+0x16>
        *dst = '\0';
  800dbe:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800dc1:	48 29 f8             	sub    %rdi,%rax
}
  800dc4:	c3                   	ret

0000000000800dc5 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800dc5:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800dc9:	0f b6 07             	movzbl (%rdi),%eax
  800dcc:	84 c0                	test   %al,%al
  800dce:	74 13                	je     800de3 <strcmp+0x1e>
  800dd0:	38 06                	cmp    %al,(%rsi)
  800dd2:	75 0f                	jne    800de3 <strcmp+0x1e>
  800dd4:	48 83 c7 01          	add    $0x1,%rdi
  800dd8:	48 83 c6 01          	add    $0x1,%rsi
  800ddc:	0f b6 07             	movzbl (%rdi),%eax
  800ddf:	84 c0                	test   %al,%al
  800de1:	75 ed                	jne    800dd0 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800de3:	0f b6 c0             	movzbl %al,%eax
  800de6:	0f b6 16             	movzbl (%rsi),%edx
  800de9:	29 d0                	sub    %edx,%eax
}
  800deb:	c3                   	ret

0000000000800dec <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800dec:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800df0:	48 85 d2             	test   %rdx,%rdx
  800df3:	74 1f                	je     800e14 <strncmp+0x28>
  800df5:	0f b6 07             	movzbl (%rdi),%eax
  800df8:	84 c0                	test   %al,%al
  800dfa:	74 1e                	je     800e1a <strncmp+0x2e>
  800dfc:	3a 06                	cmp    (%rsi),%al
  800dfe:	75 1a                	jne    800e1a <strncmp+0x2e>
  800e00:	48 83 c7 01          	add    $0x1,%rdi
  800e04:	48 83 c6 01          	add    $0x1,%rsi
  800e08:	48 83 ea 01          	sub    $0x1,%rdx
  800e0c:	75 e7                	jne    800df5 <strncmp+0x9>

    if (!n) return 0;
  800e0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e13:	c3                   	ret
  800e14:	b8 00 00 00 00       	mov    $0x0,%eax
  800e19:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800e1a:	0f b6 07             	movzbl (%rdi),%eax
  800e1d:	0f b6 16             	movzbl (%rsi),%edx
  800e20:	29 d0                	sub    %edx,%eax
}
  800e22:	c3                   	ret

0000000000800e23 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800e23:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800e27:	0f b6 17             	movzbl (%rdi),%edx
  800e2a:	84 d2                	test   %dl,%dl
  800e2c:	74 18                	je     800e46 <strchr+0x23>
        if (*str == c) {
  800e2e:	0f be d2             	movsbl %dl,%edx
  800e31:	39 f2                	cmp    %esi,%edx
  800e33:	74 17                	je     800e4c <strchr+0x29>
    for (; *str; str++) {
  800e35:	48 83 c7 01          	add    $0x1,%rdi
  800e39:	0f b6 17             	movzbl (%rdi),%edx
  800e3c:	84 d2                	test   %dl,%dl
  800e3e:	75 ee                	jne    800e2e <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800e40:	b8 00 00 00 00       	mov    $0x0,%eax
  800e45:	c3                   	ret
  800e46:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4b:	c3                   	ret
            return (char *)str;
  800e4c:	48 89 f8             	mov    %rdi,%rax
}
  800e4f:	c3                   	ret

0000000000800e50 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800e50:	f3 0f 1e fa          	endbr64
  800e54:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800e57:	0f b6 17             	movzbl (%rdi),%edx
  800e5a:	84 d2                	test   %dl,%dl
  800e5c:	74 13                	je     800e71 <strfind+0x21>
  800e5e:	0f be d2             	movsbl %dl,%edx
  800e61:	39 f2                	cmp    %esi,%edx
  800e63:	74 0b                	je     800e70 <strfind+0x20>
  800e65:	48 83 c0 01          	add    $0x1,%rax
  800e69:	0f b6 10             	movzbl (%rax),%edx
  800e6c:	84 d2                	test   %dl,%dl
  800e6e:	75 ee                	jne    800e5e <strfind+0xe>
        ;
    return (char *)str;
}
  800e70:	c3                   	ret
  800e71:	c3                   	ret

0000000000800e72 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800e72:	f3 0f 1e fa          	endbr64
  800e76:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800e79:	48 89 f8             	mov    %rdi,%rax
  800e7c:	48 f7 d8             	neg    %rax
  800e7f:	83 e0 07             	and    $0x7,%eax
  800e82:	49 89 d1             	mov    %rdx,%r9
  800e85:	49 29 c1             	sub    %rax,%r9
  800e88:	78 36                	js     800ec0 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800e8a:	40 0f b6 c6          	movzbl %sil,%eax
  800e8e:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800e95:	01 01 01 
  800e98:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800e9c:	40 f6 c7 07          	test   $0x7,%dil
  800ea0:	75 38                	jne    800eda <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800ea2:	4c 89 c9             	mov    %r9,%rcx
  800ea5:	48 c1 f9 03          	sar    $0x3,%rcx
  800ea9:	74 0c                	je     800eb7 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800eab:	fc                   	cld
  800eac:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800eaf:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800eb3:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800eb7:	4d 85 c9             	test   %r9,%r9
  800eba:	75 45                	jne    800f01 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800ebc:	4c 89 c0             	mov    %r8,%rax
  800ebf:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800ec0:	48 85 d2             	test   %rdx,%rdx
  800ec3:	74 f7                	je     800ebc <memset+0x4a>
  800ec5:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800ec8:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800ecb:	48 83 c0 01          	add    $0x1,%rax
  800ecf:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800ed3:	48 39 c2             	cmp    %rax,%rdx
  800ed6:	75 f3                	jne    800ecb <memset+0x59>
  800ed8:	eb e2                	jmp    800ebc <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800eda:	40 f6 c7 01          	test   $0x1,%dil
  800ede:	74 06                	je     800ee6 <memset+0x74>
  800ee0:	88 07                	mov    %al,(%rdi)
  800ee2:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ee6:	40 f6 c7 02          	test   $0x2,%dil
  800eea:	74 07                	je     800ef3 <memset+0x81>
  800eec:	66 89 07             	mov    %ax,(%rdi)
  800eef:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800ef3:	40 f6 c7 04          	test   $0x4,%dil
  800ef7:	74 a9                	je     800ea2 <memset+0x30>
  800ef9:	89 07                	mov    %eax,(%rdi)
  800efb:	48 83 c7 04          	add    $0x4,%rdi
  800eff:	eb a1                	jmp    800ea2 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800f01:	41 f6 c1 04          	test   $0x4,%r9b
  800f05:	74 1b                	je     800f22 <memset+0xb0>
  800f07:	89 07                	mov    %eax,(%rdi)
  800f09:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f0d:	41 f6 c1 02          	test   $0x2,%r9b
  800f11:	74 07                	je     800f1a <memset+0xa8>
  800f13:	66 89 07             	mov    %ax,(%rdi)
  800f16:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800f1a:	41 f6 c1 01          	test   $0x1,%r9b
  800f1e:	74 9c                	je     800ebc <memset+0x4a>
  800f20:	eb 06                	jmp    800f28 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f22:	41 f6 c1 02          	test   $0x2,%r9b
  800f26:	75 eb                	jne    800f13 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800f28:	88 07                	mov    %al,(%rdi)
  800f2a:	eb 90                	jmp    800ebc <memset+0x4a>

0000000000800f2c <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800f2c:	f3 0f 1e fa          	endbr64
  800f30:	48 89 f8             	mov    %rdi,%rax
  800f33:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800f36:	48 39 fe             	cmp    %rdi,%rsi
  800f39:	73 3b                	jae    800f76 <memmove+0x4a>
  800f3b:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800f3f:	48 39 d7             	cmp    %rdx,%rdi
  800f42:	73 32                	jae    800f76 <memmove+0x4a>
        s += n;
        d += n;
  800f44:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f48:	48 89 d6             	mov    %rdx,%rsi
  800f4b:	48 09 fe             	or     %rdi,%rsi
  800f4e:	48 09 ce             	or     %rcx,%rsi
  800f51:	40 f6 c6 07          	test   $0x7,%sil
  800f55:	75 12                	jne    800f69 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800f57:	48 83 ef 08          	sub    $0x8,%rdi
  800f5b:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800f5f:	48 c1 e9 03          	shr    $0x3,%rcx
  800f63:	fd                   	std
  800f64:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800f67:	fc                   	cld
  800f68:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800f69:	48 83 ef 01          	sub    $0x1,%rdi
  800f6d:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800f71:	fd                   	std
  800f72:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800f74:	eb f1                	jmp    800f67 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f76:	48 89 f2             	mov    %rsi,%rdx
  800f79:	48 09 c2             	or     %rax,%rdx
  800f7c:	48 09 ca             	or     %rcx,%rdx
  800f7f:	f6 c2 07             	test   $0x7,%dl
  800f82:	75 0c                	jne    800f90 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800f84:	48 c1 e9 03          	shr    $0x3,%rcx
  800f88:	48 89 c7             	mov    %rax,%rdi
  800f8b:	fc                   	cld
  800f8c:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800f8f:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800f90:	48 89 c7             	mov    %rax,%rdi
  800f93:	fc                   	cld
  800f94:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800f96:	c3                   	ret

0000000000800f97 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800f97:	f3 0f 1e fa          	endbr64
  800f9b:	55                   	push   %rbp
  800f9c:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800f9f:	48 b8 2c 0f 80 00 00 	movabs $0x800f2c,%rax
  800fa6:	00 00 00 
  800fa9:	ff d0                	call   *%rax
}
  800fab:	5d                   	pop    %rbp
  800fac:	c3                   	ret

0000000000800fad <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800fad:	f3 0f 1e fa          	endbr64
  800fb1:	55                   	push   %rbp
  800fb2:	48 89 e5             	mov    %rsp,%rbp
  800fb5:	41 57                	push   %r15
  800fb7:	41 56                	push   %r14
  800fb9:	41 55                	push   %r13
  800fbb:	41 54                	push   %r12
  800fbd:	53                   	push   %rbx
  800fbe:	48 83 ec 08          	sub    $0x8,%rsp
  800fc2:	49 89 fe             	mov    %rdi,%r14
  800fc5:	49 89 f7             	mov    %rsi,%r15
  800fc8:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800fcb:	48 89 f7             	mov    %rsi,%rdi
  800fce:	48 b8 cc 0c 80 00 00 	movabs $0x800ccc,%rax
  800fd5:	00 00 00 
  800fd8:	ff d0                	call   *%rax
  800fda:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800fdd:	48 89 de             	mov    %rbx,%rsi
  800fe0:	4c 89 f7             	mov    %r14,%rdi
  800fe3:	48 b8 eb 0c 80 00 00 	movabs $0x800ceb,%rax
  800fea:	00 00 00 
  800fed:	ff d0                	call   *%rax
  800fef:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800ff2:	48 39 c3             	cmp    %rax,%rbx
  800ff5:	74 36                	je     80102d <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800ff7:	48 89 d8             	mov    %rbx,%rax
  800ffa:	4c 29 e8             	sub    %r13,%rax
  800ffd:	49 39 c4             	cmp    %rax,%r12
  801000:	73 31                	jae    801033 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  801002:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801007:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80100b:	4c 89 fe             	mov    %r15,%rsi
  80100e:	48 b8 97 0f 80 00 00 	movabs $0x800f97,%rax
  801015:	00 00 00 
  801018:	ff d0                	call   *%rax
    return dstlen + srclen;
  80101a:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80101e:	48 83 c4 08          	add    $0x8,%rsp
  801022:	5b                   	pop    %rbx
  801023:	41 5c                	pop    %r12
  801025:	41 5d                	pop    %r13
  801027:	41 5e                	pop    %r14
  801029:	41 5f                	pop    %r15
  80102b:	5d                   	pop    %rbp
  80102c:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  80102d:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  801031:	eb eb                	jmp    80101e <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  801033:	48 83 eb 01          	sub    $0x1,%rbx
  801037:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80103b:	48 89 da             	mov    %rbx,%rdx
  80103e:	4c 89 fe             	mov    %r15,%rsi
  801041:	48 b8 97 0f 80 00 00 	movabs $0x800f97,%rax
  801048:	00 00 00 
  80104b:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  80104d:	49 01 de             	add    %rbx,%r14
  801050:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801055:	eb c3                	jmp    80101a <strlcat+0x6d>

0000000000801057 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801057:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  80105b:	48 85 d2             	test   %rdx,%rdx
  80105e:	74 2d                	je     80108d <memcmp+0x36>
  801060:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801065:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801069:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  80106e:	44 38 c1             	cmp    %r8b,%cl
  801071:	75 0f                	jne    801082 <memcmp+0x2b>
    while (n-- > 0) {
  801073:	48 83 c0 01          	add    $0x1,%rax
  801077:	48 39 c2             	cmp    %rax,%rdx
  80107a:	75 e9                	jne    801065 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  80107c:	b8 00 00 00 00       	mov    $0x0,%eax
  801081:	c3                   	ret
            return (int)*s1 - (int)*s2;
  801082:	0f b6 c1             	movzbl %cl,%eax
  801085:	45 0f b6 c0          	movzbl %r8b,%r8d
  801089:	44 29 c0             	sub    %r8d,%eax
  80108c:	c3                   	ret
    return 0;
  80108d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801092:	c3                   	ret

0000000000801093 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  801093:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  801097:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80109b:	48 39 c7             	cmp    %rax,%rdi
  80109e:	73 0f                	jae    8010af <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8010a0:	40 38 37             	cmp    %sil,(%rdi)
  8010a3:	74 0e                	je     8010b3 <memfind+0x20>
    for (; src < end; src++) {
  8010a5:	48 83 c7 01          	add    $0x1,%rdi
  8010a9:	48 39 f8             	cmp    %rdi,%rax
  8010ac:	75 f2                	jne    8010a0 <memfind+0xd>
  8010ae:	c3                   	ret
  8010af:	48 89 f8             	mov    %rdi,%rax
  8010b2:	c3                   	ret
  8010b3:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8010b6:	c3                   	ret

00000000008010b7 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8010b7:	f3 0f 1e fa          	endbr64
  8010bb:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8010be:	0f b6 37             	movzbl (%rdi),%esi
  8010c1:	40 80 fe 20          	cmp    $0x20,%sil
  8010c5:	74 06                	je     8010cd <strtol+0x16>
  8010c7:	40 80 fe 09          	cmp    $0x9,%sil
  8010cb:	75 13                	jne    8010e0 <strtol+0x29>
  8010cd:	48 83 c7 01          	add    $0x1,%rdi
  8010d1:	0f b6 37             	movzbl (%rdi),%esi
  8010d4:	40 80 fe 20          	cmp    $0x20,%sil
  8010d8:	74 f3                	je     8010cd <strtol+0x16>
  8010da:	40 80 fe 09          	cmp    $0x9,%sil
  8010de:	74 ed                	je     8010cd <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8010e0:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8010e3:	83 e0 fd             	and    $0xfffffffd,%eax
  8010e6:	3c 01                	cmp    $0x1,%al
  8010e8:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8010ec:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  8010f2:	75 0f                	jne    801103 <strtol+0x4c>
  8010f4:	80 3f 30             	cmpb   $0x30,(%rdi)
  8010f7:	74 14                	je     80110d <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8010f9:	85 d2                	test   %edx,%edx
  8010fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  801100:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801103:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801108:	4c 63 ca             	movslq %edx,%r9
  80110b:	eb 36                	jmp    801143 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80110d:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801111:	74 0f                	je     801122 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801113:	85 d2                	test   %edx,%edx
  801115:	75 ec                	jne    801103 <strtol+0x4c>
        s++;
  801117:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  80111b:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  801120:	eb e1                	jmp    801103 <strtol+0x4c>
        s += 2;
  801122:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801126:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  80112b:	eb d6                	jmp    801103 <strtol+0x4c>
            dig -= '0';
  80112d:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  801130:	44 0f b6 c1          	movzbl %cl,%r8d
  801134:	41 39 d0             	cmp    %edx,%r8d
  801137:	7d 21                	jge    80115a <strtol+0xa3>
        val = val * base + dig;
  801139:	49 0f af c1          	imul   %r9,%rax
  80113d:	0f b6 c9             	movzbl %cl,%ecx
  801140:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  801143:	48 83 c7 01          	add    $0x1,%rdi
  801147:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  80114b:	80 f9 39             	cmp    $0x39,%cl
  80114e:	76 dd                	jbe    80112d <strtol+0x76>
        else if (dig - 'a' < 27)
  801150:	80 f9 7b             	cmp    $0x7b,%cl
  801153:	77 05                	ja     80115a <strtol+0xa3>
            dig -= 'a' - 10;
  801155:	83 e9 57             	sub    $0x57,%ecx
  801158:	eb d6                	jmp    801130 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  80115a:	4d 85 d2             	test   %r10,%r10
  80115d:	74 03                	je     801162 <strtol+0xab>
  80115f:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801162:	48 89 c2             	mov    %rax,%rdx
  801165:	48 f7 da             	neg    %rdx
  801168:	40 80 fe 2d          	cmp    $0x2d,%sil
  80116c:	48 0f 44 c2          	cmove  %rdx,%rax
}
  801170:	c3                   	ret

0000000000801171 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801171:	f3 0f 1e fa          	endbr64
  801175:	55                   	push   %rbp
  801176:	48 89 e5             	mov    %rsp,%rbp
  801179:	53                   	push   %rbx
  80117a:	48 89 fa             	mov    %rdi,%rdx
  80117d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801180:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801185:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80118f:	be 00 00 00 00       	mov    $0x0,%esi
  801194:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80119a:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80119c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011a0:	c9                   	leave
  8011a1:	c3                   	ret

00000000008011a2 <sys_cgetc>:

int
sys_cgetc(void) {
  8011a2:	f3 0f 1e fa          	endbr64
  8011a6:	55                   	push   %rbp
  8011a7:	48 89 e5             	mov    %rsp,%rbp
  8011aa:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011ab:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011bf:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011c4:	be 00 00 00 00       	mov    $0x0,%esi
  8011c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011cf:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8011d1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011d5:	c9                   	leave
  8011d6:	c3                   	ret

00000000008011d7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8011d7:	f3 0f 1e fa          	endbr64
  8011db:	55                   	push   %rbp
  8011dc:	48 89 e5             	mov    %rsp,%rbp
  8011df:	53                   	push   %rbx
  8011e0:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8011e4:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011e7:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011ec:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011fb:	be 00 00 00 00       	mov    $0x0,%esi
  801200:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801206:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801208:	48 85 c0             	test   %rax,%rax
  80120b:	7f 06                	jg     801213 <sys_env_destroy+0x3c>
}
  80120d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801211:	c9                   	leave
  801212:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801213:	49 89 c0             	mov    %rax,%r8
  801216:	b9 03 00 00 00       	mov    $0x3,%ecx
  80121b:	48 ba 20 43 80 00 00 	movabs $0x804320,%rdx
  801222:	00 00 00 
  801225:	be 26 00 00 00       	mov    $0x26,%esi
  80122a:	48 bf b4 41 80 00 00 	movabs $0x8041b4,%rdi
  801231:	00 00 00 
  801234:	b8 00 00 00 00       	mov    $0x0,%eax
  801239:	49 b9 6c 02 80 00 00 	movabs $0x80026c,%r9
  801240:	00 00 00 
  801243:	41 ff d1             	call   *%r9

0000000000801246 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801246:	f3 0f 1e fa          	endbr64
  80124a:	55                   	push   %rbp
  80124b:	48 89 e5             	mov    %rsp,%rbp
  80124e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80124f:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801254:	ba 00 00 00 00       	mov    $0x0,%edx
  801259:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80125e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801263:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801268:	be 00 00 00 00       	mov    $0x0,%esi
  80126d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801273:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801275:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801279:	c9                   	leave
  80127a:	c3                   	ret

000000000080127b <sys_yield>:

void
sys_yield(void) {
  80127b:	f3 0f 1e fa          	endbr64
  80127f:	55                   	push   %rbp
  801280:	48 89 e5             	mov    %rsp,%rbp
  801283:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801284:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801289:	ba 00 00 00 00       	mov    $0x0,%edx
  80128e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801293:	bb 00 00 00 00       	mov    $0x0,%ebx
  801298:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80129d:	be 00 00 00 00       	mov    $0x0,%esi
  8012a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012a8:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8012aa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012ae:	c9                   	leave
  8012af:	c3                   	ret

00000000008012b0 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8012b0:	f3 0f 1e fa          	endbr64
  8012b4:	55                   	push   %rbp
  8012b5:	48 89 e5             	mov    %rsp,%rbp
  8012b8:	53                   	push   %rbx
  8012b9:	48 89 fa             	mov    %rdi,%rdx
  8012bc:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8012bf:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012c4:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8012cb:	00 00 00 
  8012ce:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012d3:	be 00 00 00 00       	mov    $0x0,%esi
  8012d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012de:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8012e0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012e4:	c9                   	leave
  8012e5:	c3                   	ret

00000000008012e6 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8012e6:	f3 0f 1e fa          	endbr64
  8012ea:	55                   	push   %rbp
  8012eb:	48 89 e5             	mov    %rsp,%rbp
  8012ee:	53                   	push   %rbx
  8012ef:	49 89 f8             	mov    %rdi,%r8
  8012f2:	48 89 d3             	mov    %rdx,%rbx
  8012f5:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8012f8:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012fd:	4c 89 c2             	mov    %r8,%rdx
  801300:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801303:	be 00 00 00 00       	mov    $0x0,%esi
  801308:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80130e:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801310:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801314:	c9                   	leave
  801315:	c3                   	ret

0000000000801316 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801316:	f3 0f 1e fa          	endbr64
  80131a:	55                   	push   %rbp
  80131b:	48 89 e5             	mov    %rsp,%rbp
  80131e:	53                   	push   %rbx
  80131f:	48 83 ec 08          	sub    $0x8,%rsp
  801323:	89 f8                	mov    %edi,%eax
  801325:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801328:	48 63 f9             	movslq %ecx,%rdi
  80132b:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80132e:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801333:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801336:	be 00 00 00 00       	mov    $0x0,%esi
  80133b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801341:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801343:	48 85 c0             	test   %rax,%rax
  801346:	7f 06                	jg     80134e <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801348:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80134c:	c9                   	leave
  80134d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80134e:	49 89 c0             	mov    %rax,%r8
  801351:	b9 04 00 00 00       	mov    $0x4,%ecx
  801356:	48 ba 20 43 80 00 00 	movabs $0x804320,%rdx
  80135d:	00 00 00 
  801360:	be 26 00 00 00       	mov    $0x26,%esi
  801365:	48 bf b4 41 80 00 00 	movabs $0x8041b4,%rdi
  80136c:	00 00 00 
  80136f:	b8 00 00 00 00       	mov    $0x0,%eax
  801374:	49 b9 6c 02 80 00 00 	movabs $0x80026c,%r9
  80137b:	00 00 00 
  80137e:	41 ff d1             	call   *%r9

0000000000801381 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801381:	f3 0f 1e fa          	endbr64
  801385:	55                   	push   %rbp
  801386:	48 89 e5             	mov    %rsp,%rbp
  801389:	53                   	push   %rbx
  80138a:	48 83 ec 08          	sub    $0x8,%rsp
  80138e:	89 f8                	mov    %edi,%eax
  801390:	49 89 f2             	mov    %rsi,%r10
  801393:	48 89 cf             	mov    %rcx,%rdi
  801396:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801399:	48 63 da             	movslq %edx,%rbx
  80139c:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80139f:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013a4:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013a7:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8013aa:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013ac:	48 85 c0             	test   %rax,%rax
  8013af:	7f 06                	jg     8013b7 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8013b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013b5:	c9                   	leave
  8013b6:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013b7:	49 89 c0             	mov    %rax,%r8
  8013ba:	b9 05 00 00 00       	mov    $0x5,%ecx
  8013bf:	48 ba 20 43 80 00 00 	movabs $0x804320,%rdx
  8013c6:	00 00 00 
  8013c9:	be 26 00 00 00       	mov    $0x26,%esi
  8013ce:	48 bf b4 41 80 00 00 	movabs $0x8041b4,%rdi
  8013d5:	00 00 00 
  8013d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013dd:	49 b9 6c 02 80 00 00 	movabs $0x80026c,%r9
  8013e4:	00 00 00 
  8013e7:	41 ff d1             	call   *%r9

00000000008013ea <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8013ea:	f3 0f 1e fa          	endbr64
  8013ee:	55                   	push   %rbp
  8013ef:	48 89 e5             	mov    %rsp,%rbp
  8013f2:	53                   	push   %rbx
  8013f3:	48 83 ec 08          	sub    $0x8,%rsp
  8013f7:	49 89 f9             	mov    %rdi,%r9
  8013fa:	89 f0                	mov    %esi,%eax
  8013fc:	48 89 d3             	mov    %rdx,%rbx
  8013ff:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801402:	49 63 f0             	movslq %r8d,%rsi
  801405:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801408:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80140d:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801410:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801416:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801418:	48 85 c0             	test   %rax,%rax
  80141b:	7f 06                	jg     801423 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80141d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801421:	c9                   	leave
  801422:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801423:	49 89 c0             	mov    %rax,%r8
  801426:	b9 06 00 00 00       	mov    $0x6,%ecx
  80142b:	48 ba 20 43 80 00 00 	movabs $0x804320,%rdx
  801432:	00 00 00 
  801435:	be 26 00 00 00       	mov    $0x26,%esi
  80143a:	48 bf b4 41 80 00 00 	movabs $0x8041b4,%rdi
  801441:	00 00 00 
  801444:	b8 00 00 00 00       	mov    $0x0,%eax
  801449:	49 b9 6c 02 80 00 00 	movabs $0x80026c,%r9
  801450:	00 00 00 
  801453:	41 ff d1             	call   *%r9

0000000000801456 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801456:	f3 0f 1e fa          	endbr64
  80145a:	55                   	push   %rbp
  80145b:	48 89 e5             	mov    %rsp,%rbp
  80145e:	53                   	push   %rbx
  80145f:	48 83 ec 08          	sub    $0x8,%rsp
  801463:	48 89 f1             	mov    %rsi,%rcx
  801466:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801469:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80146c:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801471:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801476:	be 00 00 00 00       	mov    $0x0,%esi
  80147b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801481:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801483:	48 85 c0             	test   %rax,%rax
  801486:	7f 06                	jg     80148e <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801488:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80148c:	c9                   	leave
  80148d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80148e:	49 89 c0             	mov    %rax,%r8
  801491:	b9 07 00 00 00       	mov    $0x7,%ecx
  801496:	48 ba 20 43 80 00 00 	movabs $0x804320,%rdx
  80149d:	00 00 00 
  8014a0:	be 26 00 00 00       	mov    $0x26,%esi
  8014a5:	48 bf b4 41 80 00 00 	movabs $0x8041b4,%rdi
  8014ac:	00 00 00 
  8014af:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b4:	49 b9 6c 02 80 00 00 	movabs $0x80026c,%r9
  8014bb:	00 00 00 
  8014be:	41 ff d1             	call   *%r9

00000000008014c1 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8014c1:	f3 0f 1e fa          	endbr64
  8014c5:	55                   	push   %rbp
  8014c6:	48 89 e5             	mov    %rsp,%rbp
  8014c9:	53                   	push   %rbx
  8014ca:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8014ce:	48 63 ce             	movslq %esi,%rcx
  8014d1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014d4:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014de:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014e3:	be 00 00 00 00       	mov    $0x0,%esi
  8014e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014ee:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014f0:	48 85 c0             	test   %rax,%rax
  8014f3:	7f 06                	jg     8014fb <sys_env_set_status+0x3a>
}
  8014f5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014f9:	c9                   	leave
  8014fa:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014fb:	49 89 c0             	mov    %rax,%r8
  8014fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801503:	48 ba 20 43 80 00 00 	movabs $0x804320,%rdx
  80150a:	00 00 00 
  80150d:	be 26 00 00 00       	mov    $0x26,%esi
  801512:	48 bf b4 41 80 00 00 	movabs $0x8041b4,%rdi
  801519:	00 00 00 
  80151c:	b8 00 00 00 00       	mov    $0x0,%eax
  801521:	49 b9 6c 02 80 00 00 	movabs $0x80026c,%r9
  801528:	00 00 00 
  80152b:	41 ff d1             	call   *%r9

000000000080152e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80152e:	f3 0f 1e fa          	endbr64
  801532:	55                   	push   %rbp
  801533:	48 89 e5             	mov    %rsp,%rbp
  801536:	53                   	push   %rbx
  801537:	48 83 ec 08          	sub    $0x8,%rsp
  80153b:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80153e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801541:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801546:	bb 00 00 00 00       	mov    $0x0,%ebx
  80154b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801550:	be 00 00 00 00       	mov    $0x0,%esi
  801555:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80155b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80155d:	48 85 c0             	test   %rax,%rax
  801560:	7f 06                	jg     801568 <sys_env_set_trapframe+0x3a>
}
  801562:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801566:	c9                   	leave
  801567:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801568:	49 89 c0             	mov    %rax,%r8
  80156b:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801570:	48 ba 20 43 80 00 00 	movabs $0x804320,%rdx
  801577:	00 00 00 
  80157a:	be 26 00 00 00       	mov    $0x26,%esi
  80157f:	48 bf b4 41 80 00 00 	movabs $0x8041b4,%rdi
  801586:	00 00 00 
  801589:	b8 00 00 00 00       	mov    $0x0,%eax
  80158e:	49 b9 6c 02 80 00 00 	movabs $0x80026c,%r9
  801595:	00 00 00 
  801598:	41 ff d1             	call   *%r9

000000000080159b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80159b:	f3 0f 1e fa          	endbr64
  80159f:	55                   	push   %rbp
  8015a0:	48 89 e5             	mov    %rsp,%rbp
  8015a3:	53                   	push   %rbx
  8015a4:	48 83 ec 08          	sub    $0x8,%rsp
  8015a8:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8015ab:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015ae:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015bd:	be 00 00 00 00       	mov    $0x0,%esi
  8015c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015c8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015ca:	48 85 c0             	test   %rax,%rax
  8015cd:	7f 06                	jg     8015d5 <sys_env_set_pgfault_upcall+0x3a>
}
  8015cf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015d3:	c9                   	leave
  8015d4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015d5:	49 89 c0             	mov    %rax,%r8
  8015d8:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8015dd:	48 ba 20 43 80 00 00 	movabs $0x804320,%rdx
  8015e4:	00 00 00 
  8015e7:	be 26 00 00 00       	mov    $0x26,%esi
  8015ec:	48 bf b4 41 80 00 00 	movabs $0x8041b4,%rdi
  8015f3:	00 00 00 
  8015f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fb:	49 b9 6c 02 80 00 00 	movabs $0x80026c,%r9
  801602:	00 00 00 
  801605:	41 ff d1             	call   *%r9

0000000000801608 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801608:	f3 0f 1e fa          	endbr64
  80160c:	55                   	push   %rbp
  80160d:	48 89 e5             	mov    %rsp,%rbp
  801610:	53                   	push   %rbx
  801611:	89 f8                	mov    %edi,%eax
  801613:	49 89 f1             	mov    %rsi,%r9
  801616:	48 89 d3             	mov    %rdx,%rbx
  801619:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80161c:	49 63 f0             	movslq %r8d,%rsi
  80161f:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801622:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801627:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80162a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801630:	cd 30                	int    $0x30
}
  801632:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801636:	c9                   	leave
  801637:	c3                   	ret

0000000000801638 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801638:	f3 0f 1e fa          	endbr64
  80163c:	55                   	push   %rbp
  80163d:	48 89 e5             	mov    %rsp,%rbp
  801640:	53                   	push   %rbx
  801641:	48 83 ec 08          	sub    $0x8,%rsp
  801645:	48 89 fa             	mov    %rdi,%rdx
  801648:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80164b:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801650:	bb 00 00 00 00       	mov    $0x0,%ebx
  801655:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80165a:	be 00 00 00 00       	mov    $0x0,%esi
  80165f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801665:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801667:	48 85 c0             	test   %rax,%rax
  80166a:	7f 06                	jg     801672 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80166c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801670:	c9                   	leave
  801671:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801672:	49 89 c0             	mov    %rax,%r8
  801675:	b9 0f 00 00 00       	mov    $0xf,%ecx
  80167a:	48 ba 20 43 80 00 00 	movabs $0x804320,%rdx
  801681:	00 00 00 
  801684:	be 26 00 00 00       	mov    $0x26,%esi
  801689:	48 bf b4 41 80 00 00 	movabs $0x8041b4,%rdi
  801690:	00 00 00 
  801693:	b8 00 00 00 00       	mov    $0x0,%eax
  801698:	49 b9 6c 02 80 00 00 	movabs $0x80026c,%r9
  80169f:	00 00 00 
  8016a2:	41 ff d1             	call   *%r9

00000000008016a5 <sys_gettime>:

int
sys_gettime(void) {
  8016a5:	f3 0f 1e fa          	endbr64
  8016a9:	55                   	push   %rbp
  8016aa:	48 89 e5             	mov    %rsp,%rbp
  8016ad:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8016ae:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8016b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016c2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016c7:	be 00 00 00 00       	mov    $0x0,%esi
  8016cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016d2:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8016d4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016d8:	c9                   	leave
  8016d9:	c3                   	ret

00000000008016da <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8016da:	f3 0f 1e fa          	endbr64
  8016de:	55                   	push   %rbp
  8016df:	48 89 e5             	mov    %rsp,%rbp
  8016e2:	41 56                	push   %r14
  8016e4:	41 55                	push   %r13
  8016e6:	41 54                	push   %r12
  8016e8:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  8016e9:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8016f0:	00 00 00 
  8016f3:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8016fa:	b8 09 00 00 00       	mov    $0x9,%eax
  8016ff:	cd 30                	int    $0x30
  801701:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  801704:	85 c0                	test   %eax,%eax
  801706:	78 7f                	js     801787 <fork+0xad>
  801708:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  80170a:	0f 84 83 00 00 00    	je     801793 <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  801710:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  801716:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  80171d:	00 00 00 
  801720:	b9 00 00 00 00       	mov    $0x0,%ecx
  801725:	89 c2                	mov    %eax,%edx
  801727:	be 00 00 00 00       	mov    $0x0,%esi
  80172c:	bf 00 00 00 00       	mov    $0x0,%edi
  801731:	48 b8 81 13 80 00 00 	movabs $0x801381,%rax
  801738:	00 00 00 
  80173b:	ff d0                	call   *%rax
  80173d:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  801740:	85 c0                	test   %eax,%eax
  801742:	0f 88 81 00 00 00    	js     8017c9 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  801748:	4d 85 f6             	test   %r14,%r14
  80174b:	74 20                	je     80176d <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80174d:	48 be 56 2f 80 00 00 	movabs $0x802f56,%rsi
  801754:	00 00 00 
  801757:	44 89 e7             	mov    %r12d,%edi
  80175a:	48 b8 9b 15 80 00 00 	movabs $0x80159b,%rax
  801761:	00 00 00 
  801764:	ff d0                	call   *%rax
  801766:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  801769:	85 c0                	test   %eax,%eax
  80176b:	78 70                	js     8017dd <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  80176d:	be 02 00 00 00       	mov    $0x2,%esi
  801772:	89 df                	mov    %ebx,%edi
  801774:	48 b8 c1 14 80 00 00 	movabs $0x8014c1,%rax
  80177b:	00 00 00 
  80177e:	ff d0                	call   *%rax
  801780:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  801783:	85 c0                	test   %eax,%eax
  801785:	78 6a                	js     8017f1 <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  801787:	44 89 e0             	mov    %r12d,%eax
  80178a:	5b                   	pop    %rbx
  80178b:	41 5c                	pop    %r12
  80178d:	41 5d                	pop    %r13
  80178f:	41 5e                	pop    %r14
  801791:	5d                   	pop    %rbp
  801792:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  801793:	48 b8 46 12 80 00 00 	movabs $0x801246,%rax
  80179a:	00 00 00 
  80179d:	ff d0                	call   *%rax
  80179f:	25 ff 03 00 00       	and    $0x3ff,%eax
  8017a4:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8017a8:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8017ac:	48 c1 e0 04          	shl    $0x4,%rax
  8017b0:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8017b7:	00 00 00 
  8017ba:	48 01 d0             	add    %rdx,%rax
  8017bd:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8017c4:	00 00 00 
        return 0;
  8017c7:	eb be                	jmp    801787 <fork+0xad>
        sys_env_destroy(envid);
  8017c9:	44 89 e7             	mov    %r12d,%edi
  8017cc:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  8017d3:	00 00 00 
  8017d6:	ff d0                	call   *%rax
        return res;
  8017d8:	45 89 ec             	mov    %r13d,%r12d
  8017db:	eb aa                	jmp    801787 <fork+0xad>
            sys_env_destroy(envid);
  8017dd:	44 89 e7             	mov    %r12d,%edi
  8017e0:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  8017e7:	00 00 00 
  8017ea:	ff d0                	call   *%rax
            return res;
  8017ec:	45 89 ec             	mov    %r13d,%r12d
  8017ef:	eb 96                	jmp    801787 <fork+0xad>
        sys_env_destroy(envid);
  8017f1:	89 df                	mov    %ebx,%edi
  8017f3:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  8017fa:	00 00 00 
  8017fd:	ff d0                	call   *%rax
        return res;
  8017ff:	45 89 ec             	mov    %r13d,%r12d
  801802:	eb 83                	jmp    801787 <fork+0xad>

0000000000801804 <sfork>:

envid_t
sfork() {
  801804:	f3 0f 1e fa          	endbr64
  801808:	55                   	push   %rbp
  801809:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  80180c:	48 ba c2 41 80 00 00 	movabs $0x8041c2,%rdx
  801813:	00 00 00 
  801816:	be 37 00 00 00       	mov    $0x37,%esi
  80181b:	48 bf dd 41 80 00 00 	movabs $0x8041dd,%rdi
  801822:	00 00 00 
  801825:	b8 00 00 00 00       	mov    $0x0,%eax
  80182a:	48 b9 6c 02 80 00 00 	movabs $0x80026c,%rcx
  801831:	00 00 00 
  801834:	ff d1                	call   *%rcx

0000000000801836 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  801836:	f3 0f 1e fa          	endbr64
  80183a:	55                   	push   %rbp
  80183b:	48 89 e5             	mov    %rsp,%rbp
  80183e:	41 54                	push   %r12
  801840:	53                   	push   %rbx
  801841:	48 89 fb             	mov    %rdi,%rbx
  801844:	48 89 f7             	mov    %rsi,%rdi
  801847:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  80184a:	48 85 f6             	test   %rsi,%rsi
  80184d:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  801854:	00 00 00 
  801857:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  80185b:	be 00 10 00 00       	mov    $0x1000,%esi
  801860:	48 b8 38 16 80 00 00 	movabs $0x801638,%rax
  801867:	00 00 00 
  80186a:	ff d0                	call   *%rax
    if (res < 0) {
  80186c:	85 c0                	test   %eax,%eax
  80186e:	78 45                	js     8018b5 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  801870:	48 85 db             	test   %rbx,%rbx
  801873:	74 12                	je     801887 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  801875:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80187c:	00 00 00 
  80187f:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  801885:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  801887:	4d 85 e4             	test   %r12,%r12
  80188a:	74 14                	je     8018a0 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  80188c:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801893:	00 00 00 
  801896:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  80189c:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  8018a0:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8018a7:	00 00 00 
  8018aa:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  8018b0:	5b                   	pop    %rbx
  8018b1:	41 5c                	pop    %r12
  8018b3:	5d                   	pop    %rbp
  8018b4:	c3                   	ret
        if (from_env_store != NULL) {
  8018b5:	48 85 db             	test   %rbx,%rbx
  8018b8:	74 06                	je     8018c0 <ipc_recv+0x8a>
            *from_env_store = 0;
  8018ba:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  8018c0:	4d 85 e4             	test   %r12,%r12
  8018c3:	74 eb                	je     8018b0 <ipc_recv+0x7a>
            *perm_store = 0;
  8018c5:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8018cc:	00 
  8018cd:	eb e1                	jmp    8018b0 <ipc_recv+0x7a>

00000000008018cf <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8018cf:	f3 0f 1e fa          	endbr64
  8018d3:	55                   	push   %rbp
  8018d4:	48 89 e5             	mov    %rsp,%rbp
  8018d7:	41 57                	push   %r15
  8018d9:	41 56                	push   %r14
  8018db:	41 55                	push   %r13
  8018dd:	41 54                	push   %r12
  8018df:	53                   	push   %rbx
  8018e0:	48 83 ec 18          	sub    $0x18,%rsp
  8018e4:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  8018e7:	48 89 d3             	mov    %rdx,%rbx
  8018ea:	49 89 cc             	mov    %rcx,%r12
  8018ed:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8018f0:	48 85 d2             	test   %rdx,%rdx
  8018f3:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8018fa:	00 00 00 
  8018fd:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  801901:	89 f0                	mov    %esi,%eax
  801903:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801907:	48 89 da             	mov    %rbx,%rdx
  80190a:	48 89 c6             	mov    %rax,%rsi
  80190d:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  801914:	00 00 00 
  801917:	ff d0                	call   *%rax
    while (res < 0) {
  801919:	85 c0                	test   %eax,%eax
  80191b:	79 65                	jns    801982 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80191d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801920:	75 33                	jne    801955 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  801922:	49 bf 7b 12 80 00 00 	movabs $0x80127b,%r15
  801929:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  80192c:	49 be 08 16 80 00 00 	movabs $0x801608,%r14
  801933:	00 00 00 
        sys_yield();
  801936:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  801939:	45 89 e8             	mov    %r13d,%r8d
  80193c:	4c 89 e1             	mov    %r12,%rcx
  80193f:	48 89 da             	mov    %rbx,%rdx
  801942:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  801946:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  801949:	41 ff d6             	call   *%r14
    while (res < 0) {
  80194c:	85 c0                	test   %eax,%eax
  80194e:	79 32                	jns    801982 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  801950:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801953:	74 e1                	je     801936 <ipc_send+0x67>
            panic("Error: %i\n", res);
  801955:	89 c1                	mov    %eax,%ecx
  801957:	48 ba e8 41 80 00 00 	movabs $0x8041e8,%rdx
  80195e:	00 00 00 
  801961:	be 42 00 00 00       	mov    $0x42,%esi
  801966:	48 bf f3 41 80 00 00 	movabs $0x8041f3,%rdi
  80196d:	00 00 00 
  801970:	b8 00 00 00 00       	mov    $0x0,%eax
  801975:	49 b8 6c 02 80 00 00 	movabs $0x80026c,%r8
  80197c:	00 00 00 
  80197f:	41 ff d0             	call   *%r8
    }
}
  801982:	48 83 c4 18          	add    $0x18,%rsp
  801986:	5b                   	pop    %rbx
  801987:	41 5c                	pop    %r12
  801989:	41 5d                	pop    %r13
  80198b:	41 5e                	pop    %r14
  80198d:	41 5f                	pop    %r15
  80198f:	5d                   	pop    %rbp
  801990:	c3                   	ret

0000000000801991 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  801991:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  801995:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80199a:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  8019a1:	00 00 00 
  8019a4:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8019a8:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8019ac:	48 c1 e2 04          	shl    $0x4,%rdx
  8019b0:	48 01 ca             	add    %rcx,%rdx
  8019b3:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8019b9:	39 fa                	cmp    %edi,%edx
  8019bb:	74 12                	je     8019cf <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  8019bd:	48 83 c0 01          	add    $0x1,%rax
  8019c1:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8019c7:	75 db                	jne    8019a4 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  8019c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ce:	c3                   	ret
            return envs[i].env_id;
  8019cf:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8019d3:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8019d7:	48 c1 e2 04          	shl    $0x4,%rdx
  8019db:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8019e2:	00 00 00 
  8019e5:	48 01 d0             	add    %rdx,%rax
  8019e8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8019ee:	c3                   	ret

00000000008019ef <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  8019ef:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8019f3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019fa:	ff ff ff 
  8019fd:	48 01 f8             	add    %rdi,%rax
  801a00:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801a04:	c3                   	ret

0000000000801a05 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801a05:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a09:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a10:	ff ff ff 
  801a13:	48 01 f8             	add    %rdi,%rax
  801a16:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801a1a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801a20:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a24:	c3                   	ret

0000000000801a25 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801a25:	f3 0f 1e fa          	endbr64
  801a29:	55                   	push   %rbp
  801a2a:	48 89 e5             	mov    %rsp,%rbp
  801a2d:	41 57                	push   %r15
  801a2f:	41 56                	push   %r14
  801a31:	41 55                	push   %r13
  801a33:	41 54                	push   %r12
  801a35:	53                   	push   %rbx
  801a36:	48 83 ec 08          	sub    $0x8,%rsp
  801a3a:	49 89 ff             	mov    %rdi,%r15
  801a3d:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801a42:	49 bd 84 2b 80 00 00 	movabs $0x802b84,%r13
  801a49:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801a4c:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801a52:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801a55:	48 89 df             	mov    %rbx,%rdi
  801a58:	41 ff d5             	call   *%r13
  801a5b:	83 e0 04             	and    $0x4,%eax
  801a5e:	74 17                	je     801a77 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801a60:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801a67:	4c 39 f3             	cmp    %r14,%rbx
  801a6a:	75 e6                	jne    801a52 <fd_alloc+0x2d>
  801a6c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801a72:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801a77:	4d 89 27             	mov    %r12,(%r15)
}
  801a7a:	48 83 c4 08          	add    $0x8,%rsp
  801a7e:	5b                   	pop    %rbx
  801a7f:	41 5c                	pop    %r12
  801a81:	41 5d                	pop    %r13
  801a83:	41 5e                	pop    %r14
  801a85:	41 5f                	pop    %r15
  801a87:	5d                   	pop    %rbp
  801a88:	c3                   	ret

0000000000801a89 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801a89:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801a8d:	83 ff 1f             	cmp    $0x1f,%edi
  801a90:	77 39                	ja     801acb <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801a92:	55                   	push   %rbp
  801a93:	48 89 e5             	mov    %rsp,%rbp
  801a96:	41 54                	push   %r12
  801a98:	53                   	push   %rbx
  801a99:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801a9c:	48 63 df             	movslq %edi,%rbx
  801a9f:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801aa6:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801aaa:	48 89 df             	mov    %rbx,%rdi
  801aad:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  801ab4:	00 00 00 
  801ab7:	ff d0                	call   *%rax
  801ab9:	a8 04                	test   $0x4,%al
  801abb:	74 14                	je     801ad1 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801abd:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801ac1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac6:	5b                   	pop    %rbx
  801ac7:	41 5c                	pop    %r12
  801ac9:	5d                   	pop    %rbp
  801aca:	c3                   	ret
        return -E_INVAL;
  801acb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ad0:	c3                   	ret
        return -E_INVAL;
  801ad1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ad6:	eb ee                	jmp    801ac6 <fd_lookup+0x3d>

0000000000801ad8 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801ad8:	f3 0f 1e fa          	endbr64
  801adc:	55                   	push   %rbp
  801add:	48 89 e5             	mov    %rsp,%rbp
  801ae0:	41 54                	push   %r12
  801ae2:	53                   	push   %rbx
  801ae3:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801ae6:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  801aed:	00 00 00 
  801af0:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801af7:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801afa:	39 3b                	cmp    %edi,(%rbx)
  801afc:	74 47                	je     801b45 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801afe:	48 83 c0 08          	add    $0x8,%rax
  801b02:	48 8b 18             	mov    (%rax),%rbx
  801b05:	48 85 db             	test   %rbx,%rbx
  801b08:	75 f0                	jne    801afa <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801b0a:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801b11:	00 00 00 
  801b14:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b1a:	89 fa                	mov    %edi,%edx
  801b1c:	48 bf 40 43 80 00 00 	movabs $0x804340,%rdi
  801b23:	00 00 00 
  801b26:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2b:	48 b9 c8 03 80 00 00 	movabs $0x8003c8,%rcx
  801b32:	00 00 00 
  801b35:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801b37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801b3c:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801b40:	5b                   	pop    %rbx
  801b41:	41 5c                	pop    %r12
  801b43:	5d                   	pop    %rbp
  801b44:	c3                   	ret
            return 0;
  801b45:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4a:	eb f0                	jmp    801b3c <dev_lookup+0x64>

0000000000801b4c <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801b4c:	f3 0f 1e fa          	endbr64
  801b50:	55                   	push   %rbp
  801b51:	48 89 e5             	mov    %rsp,%rbp
  801b54:	41 55                	push   %r13
  801b56:	41 54                	push   %r12
  801b58:	53                   	push   %rbx
  801b59:	48 83 ec 18          	sub    $0x18,%rsp
  801b5d:	48 89 fb             	mov    %rdi,%rbx
  801b60:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801b63:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801b6a:	ff ff ff 
  801b6d:	48 01 df             	add    %rbx,%rdi
  801b70:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801b74:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b78:	48 b8 89 1a 80 00 00 	movabs $0x801a89,%rax
  801b7f:	00 00 00 
  801b82:	ff d0                	call   *%rax
  801b84:	41 89 c5             	mov    %eax,%r13d
  801b87:	85 c0                	test   %eax,%eax
  801b89:	78 06                	js     801b91 <fd_close+0x45>
  801b8b:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801b8f:	74 1a                	je     801bab <fd_close+0x5f>
        return (must_exist ? res : 0);
  801b91:	45 84 e4             	test   %r12b,%r12b
  801b94:	b8 00 00 00 00       	mov    $0x0,%eax
  801b99:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801b9d:	44 89 e8             	mov    %r13d,%eax
  801ba0:	48 83 c4 18          	add    $0x18,%rsp
  801ba4:	5b                   	pop    %rbx
  801ba5:	41 5c                	pop    %r12
  801ba7:	41 5d                	pop    %r13
  801ba9:	5d                   	pop    %rbp
  801baa:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801bab:	8b 3b                	mov    (%rbx),%edi
  801bad:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801bb1:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  801bb8:	00 00 00 
  801bbb:	ff d0                	call   *%rax
  801bbd:	41 89 c5             	mov    %eax,%r13d
  801bc0:	85 c0                	test   %eax,%eax
  801bc2:	78 1b                	js     801bdf <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801bc4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bc8:	48 8b 40 20          	mov    0x20(%rax),%rax
  801bcc:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801bd2:	48 85 c0             	test   %rax,%rax
  801bd5:	74 08                	je     801bdf <fd_close+0x93>
  801bd7:	48 89 df             	mov    %rbx,%rdi
  801bda:	ff d0                	call   *%rax
  801bdc:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801bdf:	ba 00 10 00 00       	mov    $0x1000,%edx
  801be4:	48 89 de             	mov    %rbx,%rsi
  801be7:	bf 00 00 00 00       	mov    $0x0,%edi
  801bec:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  801bf3:	00 00 00 
  801bf6:	ff d0                	call   *%rax
    return res;
  801bf8:	eb a3                	jmp    801b9d <fd_close+0x51>

0000000000801bfa <close>:

int
close(int fdnum) {
  801bfa:	f3 0f 1e fa          	endbr64
  801bfe:	55                   	push   %rbp
  801bff:	48 89 e5             	mov    %rsp,%rbp
  801c02:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801c06:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801c0a:	48 b8 89 1a 80 00 00 	movabs $0x801a89,%rax
  801c11:	00 00 00 
  801c14:	ff d0                	call   *%rax
    if (res < 0) return res;
  801c16:	85 c0                	test   %eax,%eax
  801c18:	78 15                	js     801c2f <close+0x35>

    return fd_close(fd, 1);
  801c1a:	be 01 00 00 00       	mov    $0x1,%esi
  801c1f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801c23:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  801c2a:	00 00 00 
  801c2d:	ff d0                	call   *%rax
}
  801c2f:	c9                   	leave
  801c30:	c3                   	ret

0000000000801c31 <close_all>:

void
close_all(void) {
  801c31:	f3 0f 1e fa          	endbr64
  801c35:	55                   	push   %rbp
  801c36:	48 89 e5             	mov    %rsp,%rbp
  801c39:	41 54                	push   %r12
  801c3b:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801c3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c41:	49 bc fa 1b 80 00 00 	movabs $0x801bfa,%r12
  801c48:	00 00 00 
  801c4b:	89 df                	mov    %ebx,%edi
  801c4d:	41 ff d4             	call   *%r12
  801c50:	83 c3 01             	add    $0x1,%ebx
  801c53:	83 fb 20             	cmp    $0x20,%ebx
  801c56:	75 f3                	jne    801c4b <close_all+0x1a>
}
  801c58:	5b                   	pop    %rbx
  801c59:	41 5c                	pop    %r12
  801c5b:	5d                   	pop    %rbp
  801c5c:	c3                   	ret

0000000000801c5d <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801c5d:	f3 0f 1e fa          	endbr64
  801c61:	55                   	push   %rbp
  801c62:	48 89 e5             	mov    %rsp,%rbp
  801c65:	41 57                	push   %r15
  801c67:	41 56                	push   %r14
  801c69:	41 55                	push   %r13
  801c6b:	41 54                	push   %r12
  801c6d:	53                   	push   %rbx
  801c6e:	48 83 ec 18          	sub    $0x18,%rsp
  801c72:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801c75:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801c79:	48 b8 89 1a 80 00 00 	movabs $0x801a89,%rax
  801c80:	00 00 00 
  801c83:	ff d0                	call   *%rax
  801c85:	89 c3                	mov    %eax,%ebx
  801c87:	85 c0                	test   %eax,%eax
  801c89:	0f 88 b8 00 00 00    	js     801d47 <dup+0xea>
    close(newfdnum);
  801c8f:	44 89 e7             	mov    %r12d,%edi
  801c92:	48 b8 fa 1b 80 00 00 	movabs $0x801bfa,%rax
  801c99:	00 00 00 
  801c9c:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801c9e:	4d 63 ec             	movslq %r12d,%r13
  801ca1:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801ca8:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801cac:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801cb0:	4c 89 ff             	mov    %r15,%rdi
  801cb3:	49 be 05 1a 80 00 00 	movabs $0x801a05,%r14
  801cba:	00 00 00 
  801cbd:	41 ff d6             	call   *%r14
  801cc0:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801cc3:	4c 89 ef             	mov    %r13,%rdi
  801cc6:	41 ff d6             	call   *%r14
  801cc9:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801ccc:	48 89 df             	mov    %rbx,%rdi
  801ccf:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  801cd6:	00 00 00 
  801cd9:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801cdb:	a8 04                	test   $0x4,%al
  801cdd:	74 2b                	je     801d0a <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801cdf:	41 89 c1             	mov    %eax,%r9d
  801ce2:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801ce8:	4c 89 f1             	mov    %r14,%rcx
  801ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf0:	48 89 de             	mov    %rbx,%rsi
  801cf3:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf8:	48 b8 81 13 80 00 00 	movabs $0x801381,%rax
  801cff:	00 00 00 
  801d02:	ff d0                	call   *%rax
  801d04:	89 c3                	mov    %eax,%ebx
  801d06:	85 c0                	test   %eax,%eax
  801d08:	78 4e                	js     801d58 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801d0a:	4c 89 ff             	mov    %r15,%rdi
  801d0d:	48 b8 84 2b 80 00 00 	movabs $0x802b84,%rax
  801d14:	00 00 00 
  801d17:	ff d0                	call   *%rax
  801d19:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801d1c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801d22:	4c 89 e9             	mov    %r13,%rcx
  801d25:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2a:	4c 89 fe             	mov    %r15,%rsi
  801d2d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d32:	48 b8 81 13 80 00 00 	movabs $0x801381,%rax
  801d39:	00 00 00 
  801d3c:	ff d0                	call   *%rax
  801d3e:	89 c3                	mov    %eax,%ebx
  801d40:	85 c0                	test   %eax,%eax
  801d42:	78 14                	js     801d58 <dup+0xfb>

    return newfdnum;
  801d44:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801d47:	89 d8                	mov    %ebx,%eax
  801d49:	48 83 c4 18          	add    $0x18,%rsp
  801d4d:	5b                   	pop    %rbx
  801d4e:	41 5c                	pop    %r12
  801d50:	41 5d                	pop    %r13
  801d52:	41 5e                	pop    %r14
  801d54:	41 5f                	pop    %r15
  801d56:	5d                   	pop    %rbp
  801d57:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801d58:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d5d:	4c 89 ee             	mov    %r13,%rsi
  801d60:	bf 00 00 00 00       	mov    $0x0,%edi
  801d65:	49 bc 56 14 80 00 00 	movabs $0x801456,%r12
  801d6c:	00 00 00 
  801d6f:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801d72:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d77:	4c 89 f6             	mov    %r14,%rsi
  801d7a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d7f:	41 ff d4             	call   *%r12
    return res;
  801d82:	eb c3                	jmp    801d47 <dup+0xea>

0000000000801d84 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801d84:	f3 0f 1e fa          	endbr64
  801d88:	55                   	push   %rbp
  801d89:	48 89 e5             	mov    %rsp,%rbp
  801d8c:	41 56                	push   %r14
  801d8e:	41 55                	push   %r13
  801d90:	41 54                	push   %r12
  801d92:	53                   	push   %rbx
  801d93:	48 83 ec 10          	sub    $0x10,%rsp
  801d97:	89 fb                	mov    %edi,%ebx
  801d99:	49 89 f4             	mov    %rsi,%r12
  801d9c:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d9f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801da3:	48 b8 89 1a 80 00 00 	movabs $0x801a89,%rax
  801daa:	00 00 00 
  801dad:	ff d0                	call   *%rax
  801daf:	85 c0                	test   %eax,%eax
  801db1:	78 4c                	js     801dff <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801db3:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801db7:	41 8b 3e             	mov    (%r14),%edi
  801dba:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801dbe:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  801dc5:	00 00 00 
  801dc8:	ff d0                	call   *%rax
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	78 35                	js     801e03 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801dce:	41 8b 46 08          	mov    0x8(%r14),%eax
  801dd2:	83 e0 03             	and    $0x3,%eax
  801dd5:	83 f8 01             	cmp    $0x1,%eax
  801dd8:	74 2d                	je     801e07 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801dda:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dde:	48 8b 40 10          	mov    0x10(%rax),%rax
  801de2:	48 85 c0             	test   %rax,%rax
  801de5:	74 56                	je     801e3d <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801de7:	4c 89 ea             	mov    %r13,%rdx
  801dea:	4c 89 e6             	mov    %r12,%rsi
  801ded:	4c 89 f7             	mov    %r14,%rdi
  801df0:	ff d0                	call   *%rax
}
  801df2:	48 83 c4 10          	add    $0x10,%rsp
  801df6:	5b                   	pop    %rbx
  801df7:	41 5c                	pop    %r12
  801df9:	41 5d                	pop    %r13
  801dfb:	41 5e                	pop    %r14
  801dfd:	5d                   	pop    %rbp
  801dfe:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dff:	48 98                	cltq
  801e01:	eb ef                	jmp    801df2 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e03:	48 98                	cltq
  801e05:	eb eb                	jmp    801df2 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801e07:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801e0e:	00 00 00 
  801e11:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e17:	89 da                	mov    %ebx,%edx
  801e19:	48 bf fd 41 80 00 00 	movabs $0x8041fd,%rdi
  801e20:	00 00 00 
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
  801e28:	48 b9 c8 03 80 00 00 	movabs $0x8003c8,%rcx
  801e2f:	00 00 00 
  801e32:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e34:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801e3b:	eb b5                	jmp    801df2 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801e3d:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801e44:	eb ac                	jmp    801df2 <read+0x6e>

0000000000801e46 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801e46:	f3 0f 1e fa          	endbr64
  801e4a:	55                   	push   %rbp
  801e4b:	48 89 e5             	mov    %rsp,%rbp
  801e4e:	41 57                	push   %r15
  801e50:	41 56                	push   %r14
  801e52:	41 55                	push   %r13
  801e54:	41 54                	push   %r12
  801e56:	53                   	push   %rbx
  801e57:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801e5b:	48 85 d2             	test   %rdx,%rdx
  801e5e:	74 54                	je     801eb4 <readn+0x6e>
  801e60:	41 89 fd             	mov    %edi,%r13d
  801e63:	49 89 f6             	mov    %rsi,%r14
  801e66:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801e69:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801e6e:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801e73:	49 bf 84 1d 80 00 00 	movabs $0x801d84,%r15
  801e7a:	00 00 00 
  801e7d:	4c 89 e2             	mov    %r12,%rdx
  801e80:	48 29 f2             	sub    %rsi,%rdx
  801e83:	4c 01 f6             	add    %r14,%rsi
  801e86:	44 89 ef             	mov    %r13d,%edi
  801e89:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	78 20                	js     801eb0 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801e90:	01 c3                	add    %eax,%ebx
  801e92:	85 c0                	test   %eax,%eax
  801e94:	74 08                	je     801e9e <readn+0x58>
  801e96:	48 63 f3             	movslq %ebx,%rsi
  801e99:	4c 39 e6             	cmp    %r12,%rsi
  801e9c:	72 df                	jb     801e7d <readn+0x37>
    }
    return res;
  801e9e:	48 63 c3             	movslq %ebx,%rax
}
  801ea1:	48 83 c4 08          	add    $0x8,%rsp
  801ea5:	5b                   	pop    %rbx
  801ea6:	41 5c                	pop    %r12
  801ea8:	41 5d                	pop    %r13
  801eaa:	41 5e                	pop    %r14
  801eac:	41 5f                	pop    %r15
  801eae:	5d                   	pop    %rbp
  801eaf:	c3                   	ret
        if (inc < 0) return inc;
  801eb0:	48 98                	cltq
  801eb2:	eb ed                	jmp    801ea1 <readn+0x5b>
    int inc = 1, res = 0;
  801eb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801eb9:	eb e3                	jmp    801e9e <readn+0x58>

0000000000801ebb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801ebb:	f3 0f 1e fa          	endbr64
  801ebf:	55                   	push   %rbp
  801ec0:	48 89 e5             	mov    %rsp,%rbp
  801ec3:	41 56                	push   %r14
  801ec5:	41 55                	push   %r13
  801ec7:	41 54                	push   %r12
  801ec9:	53                   	push   %rbx
  801eca:	48 83 ec 10          	sub    $0x10,%rsp
  801ece:	89 fb                	mov    %edi,%ebx
  801ed0:	49 89 f4             	mov    %rsi,%r12
  801ed3:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ed6:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801eda:	48 b8 89 1a 80 00 00 	movabs $0x801a89,%rax
  801ee1:	00 00 00 
  801ee4:	ff d0                	call   *%rax
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	78 47                	js     801f31 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801eea:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801eee:	41 8b 3e             	mov    (%r14),%edi
  801ef1:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ef5:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  801efc:	00 00 00 
  801eff:	ff d0                	call   *%rax
  801f01:	85 c0                	test   %eax,%eax
  801f03:	78 30                	js     801f35 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f05:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801f0a:	74 2d                	je     801f39 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801f0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f10:	48 8b 40 18          	mov    0x18(%rax),%rax
  801f14:	48 85 c0             	test   %rax,%rax
  801f17:	74 56                	je     801f6f <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801f19:	4c 89 ea             	mov    %r13,%rdx
  801f1c:	4c 89 e6             	mov    %r12,%rsi
  801f1f:	4c 89 f7             	mov    %r14,%rdi
  801f22:	ff d0                	call   *%rax
}
  801f24:	48 83 c4 10          	add    $0x10,%rsp
  801f28:	5b                   	pop    %rbx
  801f29:	41 5c                	pop    %r12
  801f2b:	41 5d                	pop    %r13
  801f2d:	41 5e                	pop    %r14
  801f2f:	5d                   	pop    %rbp
  801f30:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f31:	48 98                	cltq
  801f33:	eb ef                	jmp    801f24 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f35:	48 98                	cltq
  801f37:	eb eb                	jmp    801f24 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801f39:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801f40:	00 00 00 
  801f43:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801f49:	89 da                	mov    %ebx,%edx
  801f4b:	48 bf 19 42 80 00 00 	movabs $0x804219,%rdi
  801f52:	00 00 00 
  801f55:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5a:	48 b9 c8 03 80 00 00 	movabs $0x8003c8,%rcx
  801f61:	00 00 00 
  801f64:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f66:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801f6d:	eb b5                	jmp    801f24 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801f6f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801f76:	eb ac                	jmp    801f24 <write+0x69>

0000000000801f78 <seek>:

int
seek(int fdnum, off_t offset) {
  801f78:	f3 0f 1e fa          	endbr64
  801f7c:	55                   	push   %rbp
  801f7d:	48 89 e5             	mov    %rsp,%rbp
  801f80:	53                   	push   %rbx
  801f81:	48 83 ec 18          	sub    $0x18,%rsp
  801f85:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f87:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f8b:	48 b8 89 1a 80 00 00 	movabs $0x801a89,%rax
  801f92:	00 00 00 
  801f95:	ff d0                	call   *%rax
  801f97:	85 c0                	test   %eax,%eax
  801f99:	78 0c                	js     801fa7 <seek+0x2f>

    fd->fd_offset = offset;
  801f9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f9f:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801fab:	c9                   	leave
  801fac:	c3                   	ret

0000000000801fad <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801fad:	f3 0f 1e fa          	endbr64
  801fb1:	55                   	push   %rbp
  801fb2:	48 89 e5             	mov    %rsp,%rbp
  801fb5:	41 55                	push   %r13
  801fb7:	41 54                	push   %r12
  801fb9:	53                   	push   %rbx
  801fba:	48 83 ec 18          	sub    $0x18,%rsp
  801fbe:	89 fb                	mov    %edi,%ebx
  801fc0:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801fc3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801fc7:	48 b8 89 1a 80 00 00 	movabs $0x801a89,%rax
  801fce:	00 00 00 
  801fd1:	ff d0                	call   *%rax
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	78 38                	js     80200f <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801fd7:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801fdb:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801fdf:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801fe3:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  801fea:	00 00 00 
  801fed:	ff d0                	call   *%rax
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	78 1c                	js     80200f <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ff3:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801ff8:	74 20                	je     80201a <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801ffa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ffe:	48 8b 40 30          	mov    0x30(%rax),%rax
  802002:	48 85 c0             	test   %rax,%rax
  802005:	74 47                	je     80204e <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  802007:	44 89 e6             	mov    %r12d,%esi
  80200a:	4c 89 ef             	mov    %r13,%rdi
  80200d:	ff d0                	call   *%rax
}
  80200f:	48 83 c4 18          	add    $0x18,%rsp
  802013:	5b                   	pop    %rbx
  802014:	41 5c                	pop    %r12
  802016:	41 5d                	pop    %r13
  802018:	5d                   	pop    %rbp
  802019:	c3                   	ret
                thisenv->env_id, fdnum);
  80201a:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802021:	00 00 00 
  802024:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  80202a:	89 da                	mov    %ebx,%edx
  80202c:	48 bf 60 43 80 00 00 	movabs $0x804360,%rdi
  802033:	00 00 00 
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
  80203b:	48 b9 c8 03 80 00 00 	movabs $0x8003c8,%rcx
  802042:	00 00 00 
  802045:	ff d1                	call   *%rcx
        return -E_INVAL;
  802047:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80204c:	eb c1                	jmp    80200f <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  80204e:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802053:	eb ba                	jmp    80200f <ftruncate+0x62>

0000000000802055 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  802055:	f3 0f 1e fa          	endbr64
  802059:	55                   	push   %rbp
  80205a:	48 89 e5             	mov    %rsp,%rbp
  80205d:	41 54                	push   %r12
  80205f:	53                   	push   %rbx
  802060:	48 83 ec 10          	sub    $0x10,%rsp
  802064:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802067:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80206b:	48 b8 89 1a 80 00 00 	movabs $0x801a89,%rax
  802072:	00 00 00 
  802075:	ff d0                	call   *%rax
  802077:	85 c0                	test   %eax,%eax
  802079:	78 4e                	js     8020c9 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80207b:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  80207f:	41 8b 3c 24          	mov    (%r12),%edi
  802083:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  802087:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  80208e:	00 00 00 
  802091:	ff d0                	call   *%rax
  802093:	85 c0                	test   %eax,%eax
  802095:	78 32                	js     8020c9 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  802097:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80209b:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  8020a0:	74 30                	je     8020d2 <fstat+0x7d>

    stat->st_name[0] = 0;
  8020a2:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  8020a5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  8020ac:	00 00 00 
    stat->st_isdir = 0;
  8020af:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8020b6:	00 00 00 
    stat->st_dev = dev;
  8020b9:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  8020c0:	48 89 de             	mov    %rbx,%rsi
  8020c3:	4c 89 e7             	mov    %r12,%rdi
  8020c6:	ff 50 28             	call   *0x28(%rax)
}
  8020c9:	48 83 c4 10          	add    $0x10,%rsp
  8020cd:	5b                   	pop    %rbx
  8020ce:	41 5c                	pop    %r12
  8020d0:	5d                   	pop    %rbp
  8020d1:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  8020d2:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8020d7:	eb f0                	jmp    8020c9 <fstat+0x74>

00000000008020d9 <stat>:

int
stat(const char *path, struct Stat *stat) {
  8020d9:	f3 0f 1e fa          	endbr64
  8020dd:	55                   	push   %rbp
  8020de:	48 89 e5             	mov    %rsp,%rbp
  8020e1:	41 54                	push   %r12
  8020e3:	53                   	push   %rbx
  8020e4:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  8020e7:	be 00 00 00 00       	mov    $0x0,%esi
  8020ec:	48 b8 ba 23 80 00 00 	movabs $0x8023ba,%rax
  8020f3:	00 00 00 
  8020f6:	ff d0                	call   *%rax
  8020f8:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	78 25                	js     802123 <stat+0x4a>

    int res = fstat(fd, stat);
  8020fe:	4c 89 e6             	mov    %r12,%rsi
  802101:	89 c7                	mov    %eax,%edi
  802103:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  80210a:	00 00 00 
  80210d:	ff d0                	call   *%rax
  80210f:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802112:	89 df                	mov    %ebx,%edi
  802114:	48 b8 fa 1b 80 00 00 	movabs $0x801bfa,%rax
  80211b:	00 00 00 
  80211e:	ff d0                	call   *%rax

    return res;
  802120:	44 89 e3             	mov    %r12d,%ebx
}
  802123:	89 d8                	mov    %ebx,%eax
  802125:	5b                   	pop    %rbx
  802126:	41 5c                	pop    %r12
  802128:	5d                   	pop    %rbp
  802129:	c3                   	ret

000000000080212a <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  80212a:	f3 0f 1e fa          	endbr64
  80212e:	55                   	push   %rbp
  80212f:	48 89 e5             	mov    %rsp,%rbp
  802132:	41 54                	push   %r12
  802134:	53                   	push   %rbx
  802135:	48 83 ec 10          	sub    $0x10,%rsp
  802139:	41 89 fc             	mov    %edi,%r12d
  80213c:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80213f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802146:	00 00 00 
  802149:	83 38 00             	cmpl   $0x0,(%rax)
  80214c:	74 6e                	je     8021bc <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  80214e:	bf 03 00 00 00       	mov    $0x3,%edi
  802153:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  80215a:	00 00 00 
  80215d:	ff d0                	call   *%rax
  80215f:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802166:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802168:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  80216e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802173:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80217a:	00 00 00 
  80217d:	44 89 e6             	mov    %r12d,%esi
  802180:	89 c7                	mov    %eax,%edi
  802182:	48 b8 cf 18 80 00 00 	movabs $0x8018cf,%rax
  802189:	00 00 00 
  80218c:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  80218e:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802195:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802196:	b9 00 00 00 00       	mov    $0x0,%ecx
  80219b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80219f:	48 89 de             	mov    %rbx,%rsi
  8021a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a7:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  8021ae:	00 00 00 
  8021b1:	ff d0                	call   *%rax
}
  8021b3:	48 83 c4 10          	add    $0x10,%rsp
  8021b7:	5b                   	pop    %rbx
  8021b8:	41 5c                	pop    %r12
  8021ba:	5d                   	pop    %rbp
  8021bb:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8021bc:	bf 03 00 00 00       	mov    $0x3,%edi
  8021c1:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  8021c8:	00 00 00 
  8021cb:	ff d0                	call   *%rax
  8021cd:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  8021d4:	00 00 
  8021d6:	e9 73 ff ff ff       	jmp    80214e <fsipc+0x24>

00000000008021db <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8021db:	f3 0f 1e fa          	endbr64
  8021df:	55                   	push   %rbp
  8021e0:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8021e3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8021ea:	00 00 00 
  8021ed:	8b 57 0c             	mov    0xc(%rdi),%edx
  8021f0:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8021f2:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8021f5:	be 00 00 00 00       	mov    $0x0,%esi
  8021fa:	bf 02 00 00 00       	mov    $0x2,%edi
  8021ff:	48 b8 2a 21 80 00 00 	movabs $0x80212a,%rax
  802206:	00 00 00 
  802209:	ff d0                	call   *%rax
}
  80220b:	5d                   	pop    %rbp
  80220c:	c3                   	ret

000000000080220d <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80220d:	f3 0f 1e fa          	endbr64
  802211:	55                   	push   %rbp
  802212:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802215:	8b 47 0c             	mov    0xc(%rdi),%eax
  802218:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80221f:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802221:	be 00 00 00 00       	mov    $0x0,%esi
  802226:	bf 06 00 00 00       	mov    $0x6,%edi
  80222b:	48 b8 2a 21 80 00 00 	movabs $0x80212a,%rax
  802232:	00 00 00 
  802235:	ff d0                	call   *%rax
}
  802237:	5d                   	pop    %rbp
  802238:	c3                   	ret

0000000000802239 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802239:	f3 0f 1e fa          	endbr64
  80223d:	55                   	push   %rbp
  80223e:	48 89 e5             	mov    %rsp,%rbp
  802241:	41 54                	push   %r12
  802243:	53                   	push   %rbx
  802244:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802247:	8b 47 0c             	mov    0xc(%rdi),%eax
  80224a:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802251:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802253:	be 00 00 00 00       	mov    $0x0,%esi
  802258:	bf 05 00 00 00       	mov    $0x5,%edi
  80225d:	48 b8 2a 21 80 00 00 	movabs $0x80212a,%rax
  802264:	00 00 00 
  802267:	ff d0                	call   *%rax
    if (res < 0) return res;
  802269:	85 c0                	test   %eax,%eax
  80226b:	78 3d                	js     8022aa <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80226d:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  802274:	00 00 00 
  802277:	4c 89 e6             	mov    %r12,%rsi
  80227a:	48 89 df             	mov    %rbx,%rdi
  80227d:	48 b8 11 0d 80 00 00 	movabs $0x800d11,%rax
  802284:	00 00 00 
  802287:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  802289:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  802290:	00 
  802291:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802297:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  80229e:	00 
  80229f:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8022a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022aa:	5b                   	pop    %rbx
  8022ab:	41 5c                	pop    %r12
  8022ad:	5d                   	pop    %rbp
  8022ae:	c3                   	ret

00000000008022af <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8022af:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  8022b3:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  8022ba:	77 41                	ja     8022fd <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8022bc:	55                   	push   %rbp
  8022bd:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8022c0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8022c7:	00 00 00 
  8022ca:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8022cd:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  8022cf:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  8022d3:	48 8d 78 10          	lea    0x10(%rax),%rdi
  8022d7:	48 b8 2c 0f 80 00 00 	movabs $0x800f2c,%rax
  8022de:	00 00 00 
  8022e1:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  8022e3:	be 00 00 00 00       	mov    $0x0,%esi
  8022e8:	bf 04 00 00 00       	mov    $0x4,%edi
  8022ed:	48 b8 2a 21 80 00 00 	movabs $0x80212a,%rax
  8022f4:	00 00 00 
  8022f7:	ff d0                	call   *%rax
  8022f9:	48 98                	cltq
}
  8022fb:	5d                   	pop    %rbp
  8022fc:	c3                   	ret
        return -E_INVAL;
  8022fd:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802304:	c3                   	ret

0000000000802305 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802305:	f3 0f 1e fa          	endbr64
  802309:	55                   	push   %rbp
  80230a:	48 89 e5             	mov    %rsp,%rbp
  80230d:	41 55                	push   %r13
  80230f:	41 54                	push   %r12
  802311:	53                   	push   %rbx
  802312:	48 83 ec 08          	sub    $0x8,%rsp
  802316:	49 89 f4             	mov    %rsi,%r12
  802319:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80231c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802323:	00 00 00 
  802326:	8b 57 0c             	mov    0xc(%rdi),%edx
  802329:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  80232b:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  80232f:	be 00 00 00 00       	mov    $0x0,%esi
  802334:	bf 03 00 00 00       	mov    $0x3,%edi
  802339:	48 b8 2a 21 80 00 00 	movabs $0x80212a,%rax
  802340:	00 00 00 
  802343:	ff d0                	call   *%rax
  802345:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802348:	4d 85 ed             	test   %r13,%r13
  80234b:	78 2a                	js     802377 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  80234d:	4c 89 ea             	mov    %r13,%rdx
  802350:	4c 39 eb             	cmp    %r13,%rbx
  802353:	72 30                	jb     802385 <devfile_read+0x80>
  802355:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  80235c:	7f 27                	jg     802385 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  80235e:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802365:	00 00 00 
  802368:	4c 89 e7             	mov    %r12,%rdi
  80236b:	48 b8 2c 0f 80 00 00 	movabs $0x800f2c,%rax
  802372:	00 00 00 
  802375:	ff d0                	call   *%rax
}
  802377:	4c 89 e8             	mov    %r13,%rax
  80237a:	48 83 c4 08          	add    $0x8,%rsp
  80237e:	5b                   	pop    %rbx
  80237f:	41 5c                	pop    %r12
  802381:	41 5d                	pop    %r13
  802383:	5d                   	pop    %rbp
  802384:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  802385:	48 b9 36 42 80 00 00 	movabs $0x804236,%rcx
  80238c:	00 00 00 
  80238f:	48 ba 53 42 80 00 00 	movabs $0x804253,%rdx
  802396:	00 00 00 
  802399:	be 7b 00 00 00       	mov    $0x7b,%esi
  80239e:	48 bf 68 42 80 00 00 	movabs $0x804268,%rdi
  8023a5:	00 00 00 
  8023a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ad:	49 b8 6c 02 80 00 00 	movabs $0x80026c,%r8
  8023b4:	00 00 00 
  8023b7:	41 ff d0             	call   *%r8

00000000008023ba <open>:
open(const char *path, int mode) {
  8023ba:	f3 0f 1e fa          	endbr64
  8023be:	55                   	push   %rbp
  8023bf:	48 89 e5             	mov    %rsp,%rbp
  8023c2:	41 55                	push   %r13
  8023c4:	41 54                	push   %r12
  8023c6:	53                   	push   %rbx
  8023c7:	48 83 ec 18          	sub    $0x18,%rsp
  8023cb:	49 89 fc             	mov    %rdi,%r12
  8023ce:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8023d1:	48 b8 cc 0c 80 00 00 	movabs $0x800ccc,%rax
  8023d8:	00 00 00 
  8023db:	ff d0                	call   *%rax
  8023dd:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8023e3:	0f 87 8a 00 00 00    	ja     802473 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8023e9:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8023ed:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  8023f4:	00 00 00 
  8023f7:	ff d0                	call   *%rax
  8023f9:	89 c3                	mov    %eax,%ebx
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	78 50                	js     80244f <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  8023ff:	4c 89 e6             	mov    %r12,%rsi
  802402:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  802409:	00 00 00 
  80240c:	48 89 df             	mov    %rbx,%rdi
  80240f:	48 b8 11 0d 80 00 00 	movabs $0x800d11,%rax
  802416:	00 00 00 
  802419:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80241b:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802422:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802426:	bf 01 00 00 00       	mov    $0x1,%edi
  80242b:	48 b8 2a 21 80 00 00 	movabs $0x80212a,%rax
  802432:	00 00 00 
  802435:	ff d0                	call   *%rax
  802437:	89 c3                	mov    %eax,%ebx
  802439:	85 c0                	test   %eax,%eax
  80243b:	78 1f                	js     80245c <open+0xa2>
    return fd2num(fd);
  80243d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802441:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  802448:	00 00 00 
  80244b:	ff d0                	call   *%rax
  80244d:	89 c3                	mov    %eax,%ebx
}
  80244f:	89 d8                	mov    %ebx,%eax
  802451:	48 83 c4 18          	add    $0x18,%rsp
  802455:	5b                   	pop    %rbx
  802456:	41 5c                	pop    %r12
  802458:	41 5d                	pop    %r13
  80245a:	5d                   	pop    %rbp
  80245b:	c3                   	ret
        fd_close(fd, 0);
  80245c:	be 00 00 00 00       	mov    $0x0,%esi
  802461:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802465:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  80246c:	00 00 00 
  80246f:	ff d0                	call   *%rax
        return res;
  802471:	eb dc                	jmp    80244f <open+0x95>
        return -E_BAD_PATH;
  802473:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802478:	eb d5                	jmp    80244f <open+0x95>

000000000080247a <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80247a:	f3 0f 1e fa          	endbr64
  80247e:	55                   	push   %rbp
  80247f:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802482:	be 00 00 00 00       	mov    $0x0,%esi
  802487:	bf 08 00 00 00       	mov    $0x8,%edi
  80248c:	48 b8 2a 21 80 00 00 	movabs $0x80212a,%rax
  802493:	00 00 00 
  802496:	ff d0                	call   *%rax
}
  802498:	5d                   	pop    %rbp
  802499:	c3                   	ret

000000000080249a <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80249a:	f3 0f 1e fa          	endbr64
  80249e:	55                   	push   %rbp
  80249f:	48 89 e5             	mov    %rsp,%rbp
  8024a2:	41 54                	push   %r12
  8024a4:	53                   	push   %rbx
  8024a5:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8024a8:	48 b8 05 1a 80 00 00 	movabs $0x801a05,%rax
  8024af:	00 00 00 
  8024b2:	ff d0                	call   *%rax
  8024b4:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8024b7:	48 be 73 42 80 00 00 	movabs $0x804273,%rsi
  8024be:	00 00 00 
  8024c1:	48 89 df             	mov    %rbx,%rdi
  8024c4:	48 b8 11 0d 80 00 00 	movabs $0x800d11,%rax
  8024cb:	00 00 00 
  8024ce:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8024d0:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8024d5:	41 2b 04 24          	sub    (%r12),%eax
  8024d9:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8024df:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8024e6:	00 00 00 
    stat->st_dev = &devpipe;
  8024e9:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  8024f0:	00 00 00 
  8024f3:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8024fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ff:	5b                   	pop    %rbx
  802500:	41 5c                	pop    %r12
  802502:	5d                   	pop    %rbp
  802503:	c3                   	ret

0000000000802504 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802504:	f3 0f 1e fa          	endbr64
  802508:	55                   	push   %rbp
  802509:	48 89 e5             	mov    %rsp,%rbp
  80250c:	41 54                	push   %r12
  80250e:	53                   	push   %rbx
  80250f:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802512:	ba 00 10 00 00       	mov    $0x1000,%edx
  802517:	48 89 fe             	mov    %rdi,%rsi
  80251a:	bf 00 00 00 00       	mov    $0x0,%edi
  80251f:	49 bc 56 14 80 00 00 	movabs $0x801456,%r12
  802526:	00 00 00 
  802529:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80252c:	48 89 df             	mov    %rbx,%rdi
  80252f:	48 b8 05 1a 80 00 00 	movabs $0x801a05,%rax
  802536:	00 00 00 
  802539:	ff d0                	call   *%rax
  80253b:	48 89 c6             	mov    %rax,%rsi
  80253e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802543:	bf 00 00 00 00       	mov    $0x0,%edi
  802548:	41 ff d4             	call   *%r12
}
  80254b:	5b                   	pop    %rbx
  80254c:	41 5c                	pop    %r12
  80254e:	5d                   	pop    %rbp
  80254f:	c3                   	ret

0000000000802550 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
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
  802568:	49 89 f5             	mov    %rsi,%r13
  80256b:	49 89 d7             	mov    %rdx,%r15
  80256e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802572:	48 b8 05 1a 80 00 00 	movabs $0x801a05,%rax
  802579:	00 00 00 
  80257c:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80257e:	4d 85 ff             	test   %r15,%r15
  802581:	0f 84 af 00 00 00    	je     802636 <devpipe_write+0xe6>
  802587:	48 89 c3             	mov    %rax,%rbx
  80258a:	4c 89 f8             	mov    %r15,%rax
  80258d:	4d 89 ef             	mov    %r13,%r15
  802590:	4c 01 e8             	add    %r13,%rax
  802593:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802597:	49 bd e6 12 80 00 00 	movabs $0x8012e6,%r13
  80259e:	00 00 00 
            sys_yield();
  8025a1:	49 be 7b 12 80 00 00 	movabs $0x80127b,%r14
  8025a8:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8025ab:	8b 73 04             	mov    0x4(%rbx),%esi
  8025ae:	48 63 ce             	movslq %esi,%rcx
  8025b1:	48 63 03             	movslq (%rbx),%rax
  8025b4:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8025ba:	48 39 c1             	cmp    %rax,%rcx
  8025bd:	72 2e                	jb     8025ed <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025bf:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8025c4:	48 89 da             	mov    %rbx,%rdx
  8025c7:	be 00 10 00 00       	mov    $0x1000,%esi
  8025cc:	4c 89 e7             	mov    %r12,%rdi
  8025cf:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8025d2:	85 c0                	test   %eax,%eax
  8025d4:	74 66                	je     80263c <devpipe_write+0xec>
            sys_yield();
  8025d6:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8025d9:	8b 73 04             	mov    0x4(%rbx),%esi
  8025dc:	48 63 ce             	movslq %esi,%rcx
  8025df:	48 63 03             	movslq (%rbx),%rax
  8025e2:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8025e8:	48 39 c1             	cmp    %rax,%rcx
  8025eb:	73 d2                	jae    8025bf <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8025ed:	41 0f b6 3f          	movzbl (%r15),%edi
  8025f1:	48 89 ca             	mov    %rcx,%rdx
  8025f4:	48 c1 ea 03          	shr    $0x3,%rdx
  8025f8:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8025ff:	08 10 20 
  802602:	48 f7 e2             	mul    %rdx
  802605:	48 c1 ea 06          	shr    $0x6,%rdx
  802609:	48 89 d0             	mov    %rdx,%rax
  80260c:	48 c1 e0 09          	shl    $0x9,%rax
  802610:	48 29 d0             	sub    %rdx,%rax
  802613:	48 c1 e0 03          	shl    $0x3,%rax
  802617:	48 29 c1             	sub    %rax,%rcx
  80261a:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80261f:	83 c6 01             	add    $0x1,%esi
  802622:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802625:	49 83 c7 01          	add    $0x1,%r15
  802629:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80262d:	49 39 c7             	cmp    %rax,%r15
  802630:	0f 85 75 ff ff ff    	jne    8025ab <devpipe_write+0x5b>
    return n;
  802636:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80263a:	eb 05                	jmp    802641 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  80263c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802641:	48 83 c4 18          	add    $0x18,%rsp
  802645:	5b                   	pop    %rbx
  802646:	41 5c                	pop    %r12
  802648:	41 5d                	pop    %r13
  80264a:	41 5e                	pop    %r14
  80264c:	41 5f                	pop    %r15
  80264e:	5d                   	pop    %rbp
  80264f:	c3                   	ret

0000000000802650 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802650:	f3 0f 1e fa          	endbr64
  802654:	55                   	push   %rbp
  802655:	48 89 e5             	mov    %rsp,%rbp
  802658:	41 57                	push   %r15
  80265a:	41 56                	push   %r14
  80265c:	41 55                	push   %r13
  80265e:	41 54                	push   %r12
  802660:	53                   	push   %rbx
  802661:	48 83 ec 18          	sub    $0x18,%rsp
  802665:	49 89 fc             	mov    %rdi,%r12
  802668:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80266c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802670:	48 b8 05 1a 80 00 00 	movabs $0x801a05,%rax
  802677:	00 00 00 
  80267a:	ff d0                	call   *%rax
  80267c:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80267f:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802685:	49 bd e6 12 80 00 00 	movabs $0x8012e6,%r13
  80268c:	00 00 00 
            sys_yield();
  80268f:	49 be 7b 12 80 00 00 	movabs $0x80127b,%r14
  802696:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802699:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80269e:	74 7d                	je     80271d <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8026a0:	8b 03                	mov    (%rbx),%eax
  8026a2:	3b 43 04             	cmp    0x4(%rbx),%eax
  8026a5:	75 26                	jne    8026cd <devpipe_read+0x7d>
            if (i > 0) return i;
  8026a7:	4d 85 ff             	test   %r15,%r15
  8026aa:	75 77                	jne    802723 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8026ac:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8026b1:	48 89 da             	mov    %rbx,%rdx
  8026b4:	be 00 10 00 00       	mov    $0x1000,%esi
  8026b9:	4c 89 e7             	mov    %r12,%rdi
  8026bc:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	74 72                	je     802735 <devpipe_read+0xe5>
            sys_yield();
  8026c3:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8026c6:	8b 03                	mov    (%rbx),%eax
  8026c8:	3b 43 04             	cmp    0x4(%rbx),%eax
  8026cb:	74 df                	je     8026ac <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026cd:	48 63 c8             	movslq %eax,%rcx
  8026d0:	48 89 ca             	mov    %rcx,%rdx
  8026d3:	48 c1 ea 03          	shr    $0x3,%rdx
  8026d7:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8026de:	08 10 20 
  8026e1:	48 89 d0             	mov    %rdx,%rax
  8026e4:	48 f7 e6             	mul    %rsi
  8026e7:	48 c1 ea 06          	shr    $0x6,%rdx
  8026eb:	48 89 d0             	mov    %rdx,%rax
  8026ee:	48 c1 e0 09          	shl    $0x9,%rax
  8026f2:	48 29 d0             	sub    %rdx,%rax
  8026f5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8026fc:	00 
  8026fd:	48 89 c8             	mov    %rcx,%rax
  802700:	48 29 d0             	sub    %rdx,%rax
  802703:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802708:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80270c:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802710:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802713:	49 83 c7 01          	add    $0x1,%r15
  802717:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80271b:	75 83                	jne    8026a0 <devpipe_read+0x50>
    return n;
  80271d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802721:	eb 03                	jmp    802726 <devpipe_read+0xd6>
            if (i > 0) return i;
  802723:	4c 89 f8             	mov    %r15,%rax
}
  802726:	48 83 c4 18          	add    $0x18,%rsp
  80272a:	5b                   	pop    %rbx
  80272b:	41 5c                	pop    %r12
  80272d:	41 5d                	pop    %r13
  80272f:	41 5e                	pop    %r14
  802731:	41 5f                	pop    %r15
  802733:	5d                   	pop    %rbp
  802734:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802735:	b8 00 00 00 00       	mov    $0x0,%eax
  80273a:	eb ea                	jmp    802726 <devpipe_read+0xd6>

000000000080273c <pipe>:
pipe(int pfd[2]) {
  80273c:	f3 0f 1e fa          	endbr64
  802740:	55                   	push   %rbp
  802741:	48 89 e5             	mov    %rsp,%rbp
  802744:	41 55                	push   %r13
  802746:	41 54                	push   %r12
  802748:	53                   	push   %rbx
  802749:	48 83 ec 18          	sub    $0x18,%rsp
  80274d:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802750:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802754:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  80275b:	00 00 00 
  80275e:	ff d0                	call   *%rax
  802760:	89 c3                	mov    %eax,%ebx
  802762:	85 c0                	test   %eax,%eax
  802764:	0f 88 a0 01 00 00    	js     80290a <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80276a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80276f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802774:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802778:	bf 00 00 00 00       	mov    $0x0,%edi
  80277d:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  802784:	00 00 00 
  802787:	ff d0                	call   *%rax
  802789:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80278b:	85 c0                	test   %eax,%eax
  80278d:	0f 88 77 01 00 00    	js     80290a <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802793:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802797:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  80279e:	00 00 00 
  8027a1:	ff d0                	call   *%rax
  8027a3:	89 c3                	mov    %eax,%ebx
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	0f 88 43 01 00 00    	js     8028f0 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8027ad:	b9 46 00 00 00       	mov    $0x46,%ecx
  8027b2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027b7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c0:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  8027c7:	00 00 00 
  8027ca:	ff d0                	call   *%rax
  8027cc:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8027ce:	85 c0                	test   %eax,%eax
  8027d0:	0f 88 1a 01 00 00    	js     8028f0 <pipe+0x1b4>
    va = fd2data(fd0);
  8027d6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8027da:	48 b8 05 1a 80 00 00 	movabs $0x801a05,%rax
  8027e1:	00 00 00 
  8027e4:	ff d0                	call   *%rax
  8027e6:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8027e9:	b9 46 00 00 00       	mov    $0x46,%ecx
  8027ee:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027f3:	48 89 c6             	mov    %rax,%rsi
  8027f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8027fb:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  802802:	00 00 00 
  802805:	ff d0                	call   *%rax
  802807:	89 c3                	mov    %eax,%ebx
  802809:	85 c0                	test   %eax,%eax
  80280b:	0f 88 c5 00 00 00    	js     8028d6 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802811:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802815:	48 b8 05 1a 80 00 00 	movabs $0x801a05,%rax
  80281c:	00 00 00 
  80281f:	ff d0                	call   *%rax
  802821:	48 89 c1             	mov    %rax,%rcx
  802824:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80282a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802830:	ba 00 00 00 00       	mov    $0x0,%edx
  802835:	4c 89 ee             	mov    %r13,%rsi
  802838:	bf 00 00 00 00       	mov    $0x0,%edi
  80283d:	48 b8 81 13 80 00 00 	movabs $0x801381,%rax
  802844:	00 00 00 
  802847:	ff d0                	call   *%rax
  802849:	89 c3                	mov    %eax,%ebx
  80284b:	85 c0                	test   %eax,%eax
  80284d:	78 6e                	js     8028bd <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80284f:	be 00 10 00 00       	mov    $0x1000,%esi
  802854:	4c 89 ef             	mov    %r13,%rdi
  802857:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  80285e:	00 00 00 
  802861:	ff d0                	call   *%rax
  802863:	83 f8 02             	cmp    $0x2,%eax
  802866:	0f 85 ab 00 00 00    	jne    802917 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  80286c:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  802873:	00 00 
  802875:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802879:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80287b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80287f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802886:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80288a:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80288c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802890:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802897:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80289b:	48 bb ef 19 80 00 00 	movabs $0x8019ef,%rbx
  8028a2:	00 00 00 
  8028a5:	ff d3                	call   *%rbx
  8028a7:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8028ab:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8028af:	ff d3                	call   *%rbx
  8028b1:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8028b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028bb:	eb 4d                	jmp    80290a <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8028bd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028c2:	4c 89 ee             	mov    %r13,%rsi
  8028c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ca:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  8028d1:	00 00 00 
  8028d4:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8028d6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028db:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028df:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e4:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  8028eb:	00 00 00 
  8028ee:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8028f0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028f5:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8028f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8028fe:	48 b8 56 14 80 00 00 	movabs $0x801456,%rax
  802905:	00 00 00 
  802908:	ff d0                	call   *%rax
}
  80290a:	89 d8                	mov    %ebx,%eax
  80290c:	48 83 c4 18          	add    $0x18,%rsp
  802910:	5b                   	pop    %rbx
  802911:	41 5c                	pop    %r12
  802913:	41 5d                	pop    %r13
  802915:	5d                   	pop    %rbp
  802916:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802917:	48 b9 88 43 80 00 00 	movabs $0x804388,%rcx
  80291e:	00 00 00 
  802921:	48 ba 53 42 80 00 00 	movabs $0x804253,%rdx
  802928:	00 00 00 
  80292b:	be 2e 00 00 00       	mov    $0x2e,%esi
  802930:	48 bf 7a 42 80 00 00 	movabs $0x80427a,%rdi
  802937:	00 00 00 
  80293a:	b8 00 00 00 00       	mov    $0x0,%eax
  80293f:	49 b8 6c 02 80 00 00 	movabs $0x80026c,%r8
  802946:	00 00 00 
  802949:	41 ff d0             	call   *%r8

000000000080294c <pipeisclosed>:
pipeisclosed(int fdnum) {
  80294c:	f3 0f 1e fa          	endbr64
  802950:	55                   	push   %rbp
  802951:	48 89 e5             	mov    %rsp,%rbp
  802954:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802958:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80295c:	48 b8 89 1a 80 00 00 	movabs $0x801a89,%rax
  802963:	00 00 00 
  802966:	ff d0                	call   *%rax
    if (res < 0) return res;
  802968:	85 c0                	test   %eax,%eax
  80296a:	78 35                	js     8029a1 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80296c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802970:	48 b8 05 1a 80 00 00 	movabs $0x801a05,%rax
  802977:	00 00 00 
  80297a:	ff d0                	call   *%rax
  80297c:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80297f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802984:	be 00 10 00 00       	mov    $0x1000,%esi
  802989:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80298d:	48 b8 e6 12 80 00 00 	movabs $0x8012e6,%rax
  802994:	00 00 00 
  802997:	ff d0                	call   *%rax
  802999:	85 c0                	test   %eax,%eax
  80299b:	0f 94 c0             	sete   %al
  80299e:	0f b6 c0             	movzbl %al,%eax
}
  8029a1:	c9                   	leave
  8029a2:	c3                   	ret

00000000008029a3 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8029a3:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8029a7:	48 89 f8             	mov    %rdi,%rax
  8029aa:	48 c1 e8 27          	shr    $0x27,%rax
  8029ae:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8029b5:	7f 00 00 
  8029b8:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8029bc:	f6 c2 01             	test   $0x1,%dl
  8029bf:	74 6d                	je     802a2e <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8029c1:	48 89 f8             	mov    %rdi,%rax
  8029c4:	48 c1 e8 1e          	shr    $0x1e,%rax
  8029c8:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8029cf:	7f 00 00 
  8029d2:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8029d6:	f6 c2 01             	test   $0x1,%dl
  8029d9:	74 62                	je     802a3d <get_uvpt_entry+0x9a>
  8029db:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8029e2:	7f 00 00 
  8029e5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8029e9:	f6 c2 80             	test   $0x80,%dl
  8029ec:	75 4f                	jne    802a3d <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8029ee:	48 89 f8             	mov    %rdi,%rax
  8029f1:	48 c1 e8 15          	shr    $0x15,%rax
  8029f5:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8029fc:	7f 00 00 
  8029ff:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a03:	f6 c2 01             	test   $0x1,%dl
  802a06:	74 44                	je     802a4c <get_uvpt_entry+0xa9>
  802a08:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802a0f:	7f 00 00 
  802a12:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a16:	f6 c2 80             	test   $0x80,%dl
  802a19:	75 31                	jne    802a4c <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802a1b:	48 c1 ef 0c          	shr    $0xc,%rdi
  802a1f:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a26:	7f 00 00 
  802a29:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802a2d:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802a2e:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802a35:	7f 00 00 
  802a38:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802a3c:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802a3d:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802a44:	7f 00 00 
  802a47:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802a4b:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802a4c:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802a53:	7f 00 00 
  802a56:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802a5a:	c3                   	ret

0000000000802a5b <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802a5b:	f3 0f 1e fa          	endbr64
  802a5f:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802a62:	48 89 f9             	mov    %rdi,%rcx
  802a65:	48 c1 e9 27          	shr    $0x27,%rcx
  802a69:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802a70:	7f 00 00 
  802a73:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802a77:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802a7e:	f6 c1 01             	test   $0x1,%cl
  802a81:	0f 84 b2 00 00 00    	je     802b39 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802a87:	48 89 f9             	mov    %rdi,%rcx
  802a8a:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802a8e:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802a95:	7f 00 00 
  802a98:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a9c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802aa3:	40 f6 c6 01          	test   $0x1,%sil
  802aa7:	0f 84 8c 00 00 00    	je     802b39 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802aad:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802ab4:	7f 00 00 
  802ab7:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802abb:	a8 80                	test   $0x80,%al
  802abd:	75 7b                	jne    802b3a <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802abf:	48 89 f9             	mov    %rdi,%rcx
  802ac2:	48 c1 e9 15          	shr    $0x15,%rcx
  802ac6:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802acd:	7f 00 00 
  802ad0:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802ad4:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802adb:	40 f6 c6 01          	test   $0x1,%sil
  802adf:	74 58                	je     802b39 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802ae1:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802ae8:	7f 00 00 
  802aeb:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802aef:	a8 80                	test   $0x80,%al
  802af1:	75 6c                	jne    802b5f <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802af3:	48 89 f9             	mov    %rdi,%rcx
  802af6:	48 c1 e9 0c          	shr    $0xc,%rcx
  802afa:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802b01:	7f 00 00 
  802b04:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802b08:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802b0f:	40 f6 c6 01          	test   $0x1,%sil
  802b13:	74 24                	je     802b39 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802b15:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802b1c:	7f 00 00 
  802b1f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b23:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802b2a:	ff ff 7f 
  802b2d:	48 21 c8             	and    %rcx,%rax
  802b30:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802b36:	48 09 d0             	or     %rdx,%rax
}
  802b39:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802b3a:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802b41:	7f 00 00 
  802b44:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b48:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802b4f:	ff ff 7f 
  802b52:	48 21 c8             	and    %rcx,%rax
  802b55:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802b5b:	48 01 d0             	add    %rdx,%rax
  802b5e:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802b5f:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802b66:	7f 00 00 
  802b69:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b6d:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802b74:	ff ff 7f 
  802b77:	48 21 c8             	and    %rcx,%rax
  802b7a:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802b80:	48 01 d0             	add    %rdx,%rax
  802b83:	c3                   	ret

0000000000802b84 <get_prot>:

int
get_prot(void *va) {
  802b84:	f3 0f 1e fa          	endbr64
  802b88:	55                   	push   %rbp
  802b89:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802b8c:	48 b8 a3 29 80 00 00 	movabs $0x8029a3,%rax
  802b93:	00 00 00 
  802b96:	ff d0                	call   *%rax
  802b98:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802b9b:	83 e0 01             	and    $0x1,%eax
  802b9e:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802ba1:	89 d1                	mov    %edx,%ecx
  802ba3:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802ba9:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802bab:	89 c1                	mov    %eax,%ecx
  802bad:	83 c9 02             	or     $0x2,%ecx
  802bb0:	f6 c2 02             	test   $0x2,%dl
  802bb3:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802bb6:	89 c1                	mov    %eax,%ecx
  802bb8:	83 c9 01             	or     $0x1,%ecx
  802bbb:	48 85 d2             	test   %rdx,%rdx
  802bbe:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802bc1:	89 c1                	mov    %eax,%ecx
  802bc3:	83 c9 40             	or     $0x40,%ecx
  802bc6:	f6 c6 04             	test   $0x4,%dh
  802bc9:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802bcc:	5d                   	pop    %rbp
  802bcd:	c3                   	ret

0000000000802bce <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802bce:	f3 0f 1e fa          	endbr64
  802bd2:	55                   	push   %rbp
  802bd3:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802bd6:	48 b8 a3 29 80 00 00 	movabs $0x8029a3,%rax
  802bdd:	00 00 00 
  802be0:	ff d0                	call   *%rax
    return pte & PTE_D;
  802be2:	48 c1 e8 06          	shr    $0x6,%rax
  802be6:	83 e0 01             	and    $0x1,%eax
}
  802be9:	5d                   	pop    %rbp
  802bea:	c3                   	ret

0000000000802beb <is_page_present>:

bool
is_page_present(void *va) {
  802beb:	f3 0f 1e fa          	endbr64
  802bef:	55                   	push   %rbp
  802bf0:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802bf3:	48 b8 a3 29 80 00 00 	movabs $0x8029a3,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	call   *%rax
  802bff:	83 e0 01             	and    $0x1,%eax
}
  802c02:	5d                   	pop    %rbp
  802c03:	c3                   	ret

0000000000802c04 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802c04:	f3 0f 1e fa          	endbr64
  802c08:	55                   	push   %rbp
  802c09:	48 89 e5             	mov    %rsp,%rbp
  802c0c:	41 57                	push   %r15
  802c0e:	41 56                	push   %r14
  802c10:	41 55                	push   %r13
  802c12:	41 54                	push   %r12
  802c14:	53                   	push   %rbx
  802c15:	48 83 ec 18          	sub    $0x18,%rsp
  802c19:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802c1d:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802c21:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802c26:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802c2d:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c30:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802c37:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802c3a:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802c41:	00 00 00 
  802c44:	eb 73                	jmp    802cb9 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802c46:	48 89 d8             	mov    %rbx,%rax
  802c49:	48 c1 e8 15          	shr    $0x15,%rax
  802c4d:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802c54:	7f 00 00 
  802c57:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802c5b:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802c61:	f6 c2 01             	test   $0x1,%dl
  802c64:	74 4b                	je     802cb1 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802c66:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802c6a:	f6 c2 80             	test   $0x80,%dl
  802c6d:	74 11                	je     802c80 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802c6f:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802c73:	f6 c4 04             	test   $0x4,%ah
  802c76:	74 39                	je     802cb1 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802c78:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802c7e:	eb 20                	jmp    802ca0 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802c80:	48 89 da             	mov    %rbx,%rdx
  802c83:	48 c1 ea 0c          	shr    $0xc,%rdx
  802c87:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802c8e:	7f 00 00 
  802c91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802c95:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802c9b:	f6 c4 04             	test   $0x4,%ah
  802c9e:	74 11                	je     802cb1 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802ca0:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802ca4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ca8:	48 89 df             	mov    %rbx,%rdi
  802cab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802caf:	ff d0                	call   *%rax
    next:
        va += size;
  802cb1:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802cb4:	49 39 df             	cmp    %rbx,%r15
  802cb7:	72 3e                	jb     802cf7 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802cb9:	49 8b 06             	mov    (%r14),%rax
  802cbc:	a8 01                	test   $0x1,%al
  802cbe:	74 37                	je     802cf7 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802cc0:	48 89 d8             	mov    %rbx,%rax
  802cc3:	48 c1 e8 1e          	shr    $0x1e,%rax
  802cc7:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802ccc:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802cd2:	f6 c2 01             	test   $0x1,%dl
  802cd5:	74 da                	je     802cb1 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802cd7:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802cdc:	f6 c2 80             	test   $0x80,%dl
  802cdf:	0f 84 61 ff ff ff    	je     802c46 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802ce5:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802cea:	f6 c4 04             	test   $0x4,%ah
  802ced:	74 c2                	je     802cb1 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802cef:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802cf5:	eb a9                	jmp    802ca0 <foreach_shared_region+0x9c>
    }
    return res;
}
  802cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cfc:	48 83 c4 18          	add    $0x18,%rsp
  802d00:	5b                   	pop    %rbx
  802d01:	41 5c                	pop    %r12
  802d03:	41 5d                	pop    %r13
  802d05:	41 5e                	pop    %r14
  802d07:	41 5f                	pop    %r15
  802d09:	5d                   	pop    %rbp
  802d0a:	c3                   	ret

0000000000802d0b <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802d0b:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d14:	c3                   	ret

0000000000802d15 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802d15:	f3 0f 1e fa          	endbr64
  802d19:	55                   	push   %rbp
  802d1a:	48 89 e5             	mov    %rsp,%rbp
  802d1d:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802d20:	48 be 8a 42 80 00 00 	movabs $0x80428a,%rsi
  802d27:	00 00 00 
  802d2a:	48 b8 11 0d 80 00 00 	movabs $0x800d11,%rax
  802d31:	00 00 00 
  802d34:	ff d0                	call   *%rax
    return 0;
}
  802d36:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3b:	5d                   	pop    %rbp
  802d3c:	c3                   	ret

0000000000802d3d <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802d3d:	f3 0f 1e fa          	endbr64
  802d41:	55                   	push   %rbp
  802d42:	48 89 e5             	mov    %rsp,%rbp
  802d45:	41 57                	push   %r15
  802d47:	41 56                	push   %r14
  802d49:	41 55                	push   %r13
  802d4b:	41 54                	push   %r12
  802d4d:	53                   	push   %rbx
  802d4e:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802d55:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802d5c:	48 85 d2             	test   %rdx,%rdx
  802d5f:	74 7a                	je     802ddb <devcons_write+0x9e>
  802d61:	49 89 d6             	mov    %rdx,%r14
  802d64:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d6a:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802d6f:	49 bf 2c 0f 80 00 00 	movabs $0x800f2c,%r15
  802d76:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802d79:	4c 89 f3             	mov    %r14,%rbx
  802d7c:	48 29 f3             	sub    %rsi,%rbx
  802d7f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802d84:	48 39 c3             	cmp    %rax,%rbx
  802d87:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802d8b:	4c 63 eb             	movslq %ebx,%r13
  802d8e:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802d95:	48 01 c6             	add    %rax,%rsi
  802d98:	4c 89 ea             	mov    %r13,%rdx
  802d9b:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802da2:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802da5:	4c 89 ee             	mov    %r13,%rsi
  802da8:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802daf:	48 b8 71 11 80 00 00 	movabs $0x801171,%rax
  802db6:	00 00 00 
  802db9:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802dbb:	41 01 dc             	add    %ebx,%r12d
  802dbe:	49 63 f4             	movslq %r12d,%rsi
  802dc1:	4c 39 f6             	cmp    %r14,%rsi
  802dc4:	72 b3                	jb     802d79 <devcons_write+0x3c>
    return res;
  802dc6:	49 63 c4             	movslq %r12d,%rax
}
  802dc9:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802dd0:	5b                   	pop    %rbx
  802dd1:	41 5c                	pop    %r12
  802dd3:	41 5d                	pop    %r13
  802dd5:	41 5e                	pop    %r14
  802dd7:	41 5f                	pop    %r15
  802dd9:	5d                   	pop    %rbp
  802dda:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802ddb:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802de1:	eb e3                	jmp    802dc6 <devcons_write+0x89>

0000000000802de3 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802de3:	f3 0f 1e fa          	endbr64
  802de7:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802dea:	ba 00 00 00 00       	mov    $0x0,%edx
  802def:	48 85 c0             	test   %rax,%rax
  802df2:	74 55                	je     802e49 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802df4:	55                   	push   %rbp
  802df5:	48 89 e5             	mov    %rsp,%rbp
  802df8:	41 55                	push   %r13
  802dfa:	41 54                	push   %r12
  802dfc:	53                   	push   %rbx
  802dfd:	48 83 ec 08          	sub    $0x8,%rsp
  802e01:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802e04:	48 bb a2 11 80 00 00 	movabs $0x8011a2,%rbx
  802e0b:	00 00 00 
  802e0e:	49 bc 7b 12 80 00 00 	movabs $0x80127b,%r12
  802e15:	00 00 00 
  802e18:	eb 03                	jmp    802e1d <devcons_read+0x3a>
  802e1a:	41 ff d4             	call   *%r12
  802e1d:	ff d3                	call   *%rbx
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 f7                	je     802e1a <devcons_read+0x37>
    if (c < 0) return c;
  802e23:	48 63 d0             	movslq %eax,%rdx
  802e26:	78 13                	js     802e3b <devcons_read+0x58>
    if (c == 0x04) return 0;
  802e28:	ba 00 00 00 00       	mov    $0x0,%edx
  802e2d:	83 f8 04             	cmp    $0x4,%eax
  802e30:	74 09                	je     802e3b <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802e32:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802e36:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802e3b:	48 89 d0             	mov    %rdx,%rax
  802e3e:	48 83 c4 08          	add    $0x8,%rsp
  802e42:	5b                   	pop    %rbx
  802e43:	41 5c                	pop    %r12
  802e45:	41 5d                	pop    %r13
  802e47:	5d                   	pop    %rbp
  802e48:	c3                   	ret
  802e49:	48 89 d0             	mov    %rdx,%rax
  802e4c:	c3                   	ret

0000000000802e4d <cputchar>:
cputchar(int ch) {
  802e4d:	f3 0f 1e fa          	endbr64
  802e51:	55                   	push   %rbp
  802e52:	48 89 e5             	mov    %rsp,%rbp
  802e55:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802e59:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802e5d:	be 01 00 00 00       	mov    $0x1,%esi
  802e62:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802e66:	48 b8 71 11 80 00 00 	movabs $0x801171,%rax
  802e6d:	00 00 00 
  802e70:	ff d0                	call   *%rax
}
  802e72:	c9                   	leave
  802e73:	c3                   	ret

0000000000802e74 <getchar>:
getchar(void) {
  802e74:	f3 0f 1e fa          	endbr64
  802e78:	55                   	push   %rbp
  802e79:	48 89 e5             	mov    %rsp,%rbp
  802e7c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802e80:	ba 01 00 00 00       	mov    $0x1,%edx
  802e85:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802e89:	bf 00 00 00 00       	mov    $0x0,%edi
  802e8e:	48 b8 84 1d 80 00 00 	movabs $0x801d84,%rax
  802e95:	00 00 00 
  802e98:	ff d0                	call   *%rax
  802e9a:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802e9c:	85 c0                	test   %eax,%eax
  802e9e:	78 06                	js     802ea6 <getchar+0x32>
  802ea0:	74 08                	je     802eaa <getchar+0x36>
  802ea2:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802ea6:	89 d0                	mov    %edx,%eax
  802ea8:	c9                   	leave
  802ea9:	c3                   	ret
    return res < 0 ? res : res ? c :
  802eaa:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802eaf:	eb f5                	jmp    802ea6 <getchar+0x32>

0000000000802eb1 <iscons>:
iscons(int fdnum) {
  802eb1:	f3 0f 1e fa          	endbr64
  802eb5:	55                   	push   %rbp
  802eb6:	48 89 e5             	mov    %rsp,%rbp
  802eb9:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802ebd:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802ec1:	48 b8 89 1a 80 00 00 	movabs $0x801a89,%rax
  802ec8:	00 00 00 
  802ecb:	ff d0                	call   *%rax
    if (res < 0) return res;
  802ecd:	85 c0                	test   %eax,%eax
  802ecf:	78 18                	js     802ee9 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802ed1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ed5:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802edc:	00 00 00 
  802edf:	8b 00                	mov    (%rax),%eax
  802ee1:	39 02                	cmp    %eax,(%rdx)
  802ee3:	0f 94 c0             	sete   %al
  802ee6:	0f b6 c0             	movzbl %al,%eax
}
  802ee9:	c9                   	leave
  802eea:	c3                   	ret

0000000000802eeb <opencons>:
opencons(void) {
  802eeb:	f3 0f 1e fa          	endbr64
  802eef:	55                   	push   %rbp
  802ef0:	48 89 e5             	mov    %rsp,%rbp
  802ef3:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802ef7:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802efb:	48 b8 25 1a 80 00 00 	movabs $0x801a25,%rax
  802f02:	00 00 00 
  802f05:	ff d0                	call   *%rax
  802f07:	85 c0                	test   %eax,%eax
  802f09:	78 49                	js     802f54 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802f0b:	b9 46 00 00 00       	mov    $0x46,%ecx
  802f10:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f15:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802f19:	bf 00 00 00 00       	mov    $0x0,%edi
  802f1e:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  802f25:	00 00 00 
  802f28:	ff d0                	call   *%rax
  802f2a:	85 c0                	test   %eax,%eax
  802f2c:	78 26                	js     802f54 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802f2e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f32:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802f39:	00 00 
  802f3b:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802f3d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802f41:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802f48:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  802f4f:	00 00 00 
  802f52:	ff d0                	call   *%rax
}
  802f54:	c9                   	leave
  802f55:	c3                   	ret

0000000000802f56 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  802f56:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  802f59:	48 b8 dc 2f 80 00 00 	movabs $0x802fdc,%rax
  802f60:	00 00 00 
    call *%rax
  802f63:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  802f65:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  802f68:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802f6f:	00 
    movq UTRAP_RSP(%rsp), %rsp
  802f70:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  802f77:	00 
    pushq %rbx
  802f78:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  802f79:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  802f80:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  802f83:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  802f87:	4c 8b 3c 24          	mov    (%rsp),%r15
  802f8b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802f90:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802f95:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802f9a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802f9f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802fa4:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802fa9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802fae:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802fb3:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802fb8:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802fbd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802fc2:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802fc7:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802fcc:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802fd1:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  802fd5:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  802fd9:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  802fda:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  802fdb:	c3                   	ret

0000000000802fdc <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  802fdc:	f3 0f 1e fa          	endbr64
  802fe0:	55                   	push   %rbp
  802fe1:	48 89 e5             	mov    %rsp,%rbp
  802fe4:	41 56                	push   %r14
  802fe6:	41 55                	push   %r13
  802fe8:	41 54                	push   %r12
  802fea:	53                   	push   %rbx
  802feb:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  802fee:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  802ff5:	00 00 00 
  802ff8:	48 83 38 00          	cmpq   $0x0,(%rax)
  802ffc:	74 27                	je     803025 <_handle_vectored_pagefault+0x49>
  802ffe:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  803003:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  80300a:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  80300d:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  803010:	4c 89 e7             	mov    %r12,%rdi
  803013:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  803018:	84 c0                	test   %al,%al
  80301a:	75 45                	jne    803061 <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80301c:	48 83 c3 01          	add    $0x1,%rbx
  803020:	49 3b 1e             	cmp    (%r14),%rbx
  803023:	72 eb                	jb     803010 <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  803025:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  80302c:	00 
  80302d:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  803032:	4d 8b 04 24          	mov    (%r12),%r8
  803036:	48 ba b0 43 80 00 00 	movabs $0x8043b0,%rdx
  80303d:	00 00 00 
  803040:	be 1d 00 00 00       	mov    $0x1d,%esi
  803045:	48 bf 96 42 80 00 00 	movabs $0x804296,%rdi
  80304c:	00 00 00 
  80304f:	b8 00 00 00 00       	mov    $0x0,%eax
  803054:	49 ba 6c 02 80 00 00 	movabs $0x80026c,%r10
  80305b:	00 00 00 
  80305e:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  803061:	5b                   	pop    %rbx
  803062:	41 5c                	pop    %r12
  803064:	41 5d                	pop    %r13
  803066:	41 5e                	pop    %r14
  803068:	5d                   	pop    %rbp
  803069:	c3                   	ret

000000000080306a <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  80306a:	f3 0f 1e fa          	endbr64
  80306e:	55                   	push   %rbp
  80306f:	48 89 e5             	mov    %rsp,%rbp
  803072:	53                   	push   %rbx
  803073:	48 83 ec 08          	sub    $0x8,%rsp
  803077:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  80307a:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803081:	00 00 00 
  803084:	80 38 00             	cmpb   $0x0,(%rax)
  803087:	0f 84 84 00 00 00    	je     803111 <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  80308d:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803094:	00 00 00 
  803097:	48 8b 10             	mov    (%rax),%rdx
  80309a:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  80309f:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  8030a6:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8030a9:	48 85 d2             	test   %rdx,%rdx
  8030ac:	74 19                	je     8030c7 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  8030ae:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  8030b2:	0f 84 e8 00 00 00    	je     8031a0 <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  8030b8:	48 83 c0 01          	add    $0x1,%rax
  8030bc:	48 39 d0             	cmp    %rdx,%rax
  8030bf:	75 ed                	jne    8030ae <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  8030c1:	48 83 fa 08          	cmp    $0x8,%rdx
  8030c5:	74 1c                	je     8030e3 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  8030c7:	48 8d 42 01          	lea    0x1(%rdx),%rax
  8030cb:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  8030d2:	00 00 00 
  8030d5:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8030dc:	00 00 00 
  8030df:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8030e3:	48 b8 46 12 80 00 00 	movabs $0x801246,%rax
  8030ea:	00 00 00 
  8030ed:	ff d0                	call   *%rax
  8030ef:	89 c7                	mov    %eax,%edi
  8030f1:	48 be 56 2f 80 00 00 	movabs $0x802f56,%rsi
  8030f8:	00 00 00 
  8030fb:	48 b8 9b 15 80 00 00 	movabs $0x80159b,%rax
  803102:	00 00 00 
  803105:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803107:	85 c0                	test   %eax,%eax
  803109:	78 68                	js     803173 <add_pgfault_handler+0x109>
    return res;
}
  80310b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80310f:	c9                   	leave
  803110:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  803111:	48 b8 46 12 80 00 00 	movabs $0x801246,%rax
  803118:	00 00 00 
  80311b:	ff d0                	call   *%rax
  80311d:	89 c7                	mov    %eax,%edi
  80311f:	b9 06 00 00 00       	mov    $0x6,%ecx
  803124:	ba 00 10 00 00       	mov    $0x1000,%edx
  803129:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  803130:	00 00 00 
  803133:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  80313a:	00 00 00 
  80313d:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  80313f:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  803146:	00 00 00 
  803149:	48 8b 02             	mov    (%rdx),%rax
  80314c:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803150:	48 89 0a             	mov    %rcx,(%rdx)
  803153:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  80315a:	00 00 00 
  80315d:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  803161:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803168:	00 00 00 
  80316b:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  80316e:	e9 70 ff ff ff       	jmp    8030e3 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803173:	89 c1                	mov    %eax,%ecx
  803175:	48 ba a4 42 80 00 00 	movabs $0x8042a4,%rdx
  80317c:	00 00 00 
  80317f:	be 3d 00 00 00       	mov    $0x3d,%esi
  803184:	48 bf 96 42 80 00 00 	movabs $0x804296,%rdi
  80318b:	00 00 00 
  80318e:	b8 00 00 00 00       	mov    $0x0,%eax
  803193:	49 b8 6c 02 80 00 00 	movabs $0x80026c,%r8
  80319a:	00 00 00 
  80319d:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  8031a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a5:	e9 61 ff ff ff       	jmp    80310b <add_pgfault_handler+0xa1>

00000000008031aa <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  8031aa:	f3 0f 1e fa          	endbr64
  8031ae:	55                   	push   %rbp
  8031af:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  8031b2:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8031b9:	00 00 00 
  8031bc:	80 38 00             	cmpb   $0x0,(%rax)
  8031bf:	74 33                	je     8031f4 <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8031c1:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  8031c8:	00 00 00 
  8031cb:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  8031d0:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  8031d7:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8031da:	48 85 c0             	test   %rax,%rax
  8031dd:	0f 84 85 00 00 00    	je     803268 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  8031e3:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  8031e7:	74 40                	je     803229 <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8031e9:	48 83 c1 01          	add    $0x1,%rcx
  8031ed:	48 39 c1             	cmp    %rax,%rcx
  8031f0:	75 f1                	jne    8031e3 <remove_pgfault_handler+0x39>
  8031f2:	eb 74                	jmp    803268 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  8031f4:	48 b9 bc 42 80 00 00 	movabs $0x8042bc,%rcx
  8031fb:	00 00 00 
  8031fe:	48 ba 53 42 80 00 00 	movabs $0x804253,%rdx
  803205:	00 00 00 
  803208:	be 43 00 00 00       	mov    $0x43,%esi
  80320d:	48 bf 96 42 80 00 00 	movabs $0x804296,%rdi
  803214:	00 00 00 
  803217:	b8 00 00 00 00       	mov    $0x0,%eax
  80321c:	49 b8 6c 02 80 00 00 	movabs $0x80026c,%r8
  803223:	00 00 00 
  803226:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  803229:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  803230:	00 
  803231:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803235:	48 29 ca             	sub    %rcx,%rdx
  803238:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80323f:	00 00 00 
  803242:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  803246:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  80324b:	48 89 ce             	mov    %rcx,%rsi
  80324e:	48 b8 2c 0f 80 00 00 	movabs $0x800f2c,%rax
  803255:	00 00 00 
  803258:	ff d0                	call   *%rax
            _pfhandler_off--;
  80325a:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803261:	00 00 00 
  803264:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  803268:	5d                   	pop    %rbp
  803269:	c3                   	ret

000000000080326a <__text_end>:
  80326a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803271:	00 00 00 
  803274:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80327b:	00 00 00 
  80327e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803285:	00 00 00 
  803288:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80328f:	00 00 00 
  803292:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803299:	00 00 00 
  80329c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032a3:	00 00 00 
  8032a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032ad:	00 00 00 
  8032b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032b7:	00 00 00 
  8032ba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032c1:	00 00 00 
  8032c4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032cb:	00 00 00 
  8032ce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032d5:	00 00 00 
  8032d8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032df:	00 00 00 
  8032e2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032e9:	00 00 00 
  8032ec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032f3:	00 00 00 
  8032f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032fd:	00 00 00 
  803300:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803307:	00 00 00 
  80330a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803311:	00 00 00 
  803314:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80331b:	00 00 00 
  80331e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803325:	00 00 00 
  803328:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80332f:	00 00 00 
  803332:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803339:	00 00 00 
  80333c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803343:	00 00 00 
  803346:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80334d:	00 00 00 
  803350:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803357:	00 00 00 
  80335a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803361:	00 00 00 
  803364:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80336b:	00 00 00 
  80336e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803375:	00 00 00 
  803378:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80337f:	00 00 00 
  803382:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803389:	00 00 00 
  80338c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803393:	00 00 00 
  803396:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80339d:	00 00 00 
  8033a0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033a7:	00 00 00 
  8033aa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033b1:	00 00 00 
  8033b4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033bb:	00 00 00 
  8033be:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033c5:	00 00 00 
  8033c8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033cf:	00 00 00 
  8033d2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033d9:	00 00 00 
  8033dc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033e3:	00 00 00 
  8033e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033ed:	00 00 00 
  8033f0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033f7:	00 00 00 
  8033fa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803401:	00 00 00 
  803404:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80340b:	00 00 00 
  80340e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803415:	00 00 00 
  803418:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80341f:	00 00 00 
  803422:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803429:	00 00 00 
  80342c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803433:	00 00 00 
  803436:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80343d:	00 00 00 
  803440:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803447:	00 00 00 
  80344a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803451:	00 00 00 
  803454:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80345b:	00 00 00 
  80345e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803465:	00 00 00 
  803468:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80346f:	00 00 00 
  803472:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803479:	00 00 00 
  80347c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803483:	00 00 00 
  803486:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80348d:	00 00 00 
  803490:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803497:	00 00 00 
  80349a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034a1:	00 00 00 
  8034a4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ab:	00 00 00 
  8034ae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034b5:	00 00 00 
  8034b8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034bf:	00 00 00 
  8034c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034c9:	00 00 00 
  8034cc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034d3:	00 00 00 
  8034d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034dd:	00 00 00 
  8034e0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034e7:	00 00 00 
  8034ea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034f1:	00 00 00 
  8034f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034fb:	00 00 00 
  8034fe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803505:	00 00 00 
  803508:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80350f:	00 00 00 
  803512:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803519:	00 00 00 
  80351c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803523:	00 00 00 
  803526:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80352d:	00 00 00 
  803530:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803537:	00 00 00 
  80353a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803541:	00 00 00 
  803544:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80354b:	00 00 00 
  80354e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803555:	00 00 00 
  803558:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80355f:	00 00 00 
  803562:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803569:	00 00 00 
  80356c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803573:	00 00 00 
  803576:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80357d:	00 00 00 
  803580:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803587:	00 00 00 
  80358a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803591:	00 00 00 
  803594:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80359b:	00 00 00 
  80359e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a5:	00 00 00 
  8035a8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035af:	00 00 00 
  8035b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b9:	00 00 00 
  8035bc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035c3:	00 00 00 
  8035c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035cd:	00 00 00 
  8035d0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035d7:	00 00 00 
  8035da:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035e1:	00 00 00 
  8035e4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035eb:	00 00 00 
  8035ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035f5:	00 00 00 
  8035f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ff:	00 00 00 
  803602:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803609:	00 00 00 
  80360c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803613:	00 00 00 
  803616:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80361d:	00 00 00 
  803620:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803627:	00 00 00 
  80362a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803631:	00 00 00 
  803634:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80363b:	00 00 00 
  80363e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803645:	00 00 00 
  803648:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80364f:	00 00 00 
  803652:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803659:	00 00 00 
  80365c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803663:	00 00 00 
  803666:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80366d:	00 00 00 
  803670:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803677:	00 00 00 
  80367a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803681:	00 00 00 
  803684:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80368b:	00 00 00 
  80368e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803695:	00 00 00 
  803698:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80369f:	00 00 00 
  8036a2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036a9:	00 00 00 
  8036ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036b3:	00 00 00 
  8036b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036bd:	00 00 00 
  8036c0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036c7:	00 00 00 
  8036ca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036d1:	00 00 00 
  8036d4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036db:	00 00 00 
  8036de:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036e5:	00 00 00 
  8036e8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ef:	00 00 00 
  8036f2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036f9:	00 00 00 
  8036fc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803703:	00 00 00 
  803706:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80370d:	00 00 00 
  803710:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803717:	00 00 00 
  80371a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803721:	00 00 00 
  803724:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80372b:	00 00 00 
  80372e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803735:	00 00 00 
  803738:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80373f:	00 00 00 
  803742:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803749:	00 00 00 
  80374c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803753:	00 00 00 
  803756:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80375d:	00 00 00 
  803760:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803767:	00 00 00 
  80376a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803771:	00 00 00 
  803774:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80377b:	00 00 00 
  80377e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803785:	00 00 00 
  803788:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80378f:	00 00 00 
  803792:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803799:	00 00 00 
  80379c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a3:	00 00 00 
  8037a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ad:	00 00 00 
  8037b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b7:	00 00 00 
  8037ba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c1:	00 00 00 
  8037c4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037cb:	00 00 00 
  8037ce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d5:	00 00 00 
  8037d8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037df:	00 00 00 
  8037e2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e9:	00 00 00 
  8037ec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f3:	00 00 00 
  8037f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037fd:	00 00 00 
  803800:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803807:	00 00 00 
  80380a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803811:	00 00 00 
  803814:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80381b:	00 00 00 
  80381e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803825:	00 00 00 
  803828:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80382f:	00 00 00 
  803832:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803839:	00 00 00 
  80383c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803843:	00 00 00 
  803846:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80384d:	00 00 00 
  803850:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803857:	00 00 00 
  80385a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803861:	00 00 00 
  803864:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80386b:	00 00 00 
  80386e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803875:	00 00 00 
  803878:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80387f:	00 00 00 
  803882:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803889:	00 00 00 
  80388c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803893:	00 00 00 
  803896:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80389d:	00 00 00 
  8038a0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a7:	00 00 00 
  8038aa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b1:	00 00 00 
  8038b4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038bb:	00 00 00 
  8038be:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c5:	00 00 00 
  8038c8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038cf:	00 00 00 
  8038d2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d9:	00 00 00 
  8038dc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e3:	00 00 00 
  8038e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ed:	00 00 00 
  8038f0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f7:	00 00 00 
  8038fa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803901:	00 00 00 
  803904:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80390b:	00 00 00 
  80390e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803915:	00 00 00 
  803918:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80391f:	00 00 00 
  803922:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803929:	00 00 00 
  80392c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803933:	00 00 00 
  803936:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80393d:	00 00 00 
  803940:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803947:	00 00 00 
  80394a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803951:	00 00 00 
  803954:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80395b:	00 00 00 
  80395e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803965:	00 00 00 
  803968:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80396f:	00 00 00 
  803972:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803979:	00 00 00 
  80397c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803983:	00 00 00 
  803986:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80398d:	00 00 00 
  803990:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803997:	00 00 00 
  80399a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a1:	00 00 00 
  8039a4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ab:	00 00 00 
  8039ae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b5:	00 00 00 
  8039b8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039bf:	00 00 00 
  8039c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c9:	00 00 00 
  8039cc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d3:	00 00 00 
  8039d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039dd:	00 00 00 
  8039e0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e7:	00 00 00 
  8039ea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f1:	00 00 00 
  8039f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039fb:	00 00 00 
  8039fe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a05:	00 00 00 
  803a08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a0f:	00 00 00 
  803a12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a19:	00 00 00 
  803a1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a23:	00 00 00 
  803a26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a2d:	00 00 00 
  803a30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a37:	00 00 00 
  803a3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a41:	00 00 00 
  803a44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a4b:	00 00 00 
  803a4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a55:	00 00 00 
  803a58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a5f:	00 00 00 
  803a62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a69:	00 00 00 
  803a6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a73:	00 00 00 
  803a76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a7d:	00 00 00 
  803a80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a87:	00 00 00 
  803a8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a91:	00 00 00 
  803a94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a9b:	00 00 00 
  803a9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa5:	00 00 00 
  803aa8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aaf:	00 00 00 
  803ab2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab9:	00 00 00 
  803abc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac3:	00 00 00 
  803ac6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803acd:	00 00 00 
  803ad0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad7:	00 00 00 
  803ada:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae1:	00 00 00 
  803ae4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aeb:	00 00 00 
  803aee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af5:	00 00 00 
  803af8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aff:	00 00 00 
  803b02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b09:	00 00 00 
  803b0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b13:	00 00 00 
  803b16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b1d:	00 00 00 
  803b20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b27:	00 00 00 
  803b2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b31:	00 00 00 
  803b34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b3b:	00 00 00 
  803b3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b45:	00 00 00 
  803b48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b4f:	00 00 00 
  803b52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b59:	00 00 00 
  803b5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b63:	00 00 00 
  803b66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b6d:	00 00 00 
  803b70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b77:	00 00 00 
  803b7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b81:	00 00 00 
  803b84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b8b:	00 00 00 
  803b8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b95:	00 00 00 
  803b98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b9f:	00 00 00 
  803ba2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba9:	00 00 00 
  803bac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb3:	00 00 00 
  803bb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bbd:	00 00 00 
  803bc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc7:	00 00 00 
  803bca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd1:	00 00 00 
  803bd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bdb:	00 00 00 
  803bde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be5:	00 00 00 
  803be8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bef:	00 00 00 
  803bf2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf9:	00 00 00 
  803bfc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c03:	00 00 00 
  803c06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c0d:	00 00 00 
  803c10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c17:	00 00 00 
  803c1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c21:	00 00 00 
  803c24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c2b:	00 00 00 
  803c2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c35:	00 00 00 
  803c38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c3f:	00 00 00 
  803c42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c49:	00 00 00 
  803c4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c53:	00 00 00 
  803c56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c5d:	00 00 00 
  803c60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c67:	00 00 00 
  803c6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c71:	00 00 00 
  803c74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c7b:	00 00 00 
  803c7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c85:	00 00 00 
  803c88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c8f:	00 00 00 
  803c92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c99:	00 00 00 
  803c9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca3:	00 00 00 
  803ca6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cad:	00 00 00 
  803cb0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb7:	00 00 00 
  803cba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc1:	00 00 00 
  803cc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ccb:	00 00 00 
  803cce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd5:	00 00 00 
  803cd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cdf:	00 00 00 
  803ce2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce9:	00 00 00 
  803cec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf3:	00 00 00 
  803cf6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cfd:	00 00 00 
  803d00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d07:	00 00 00 
  803d0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d11:	00 00 00 
  803d14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d1b:	00 00 00 
  803d1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d25:	00 00 00 
  803d28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d2f:	00 00 00 
  803d32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d39:	00 00 00 
  803d3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d43:	00 00 00 
  803d46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d4d:	00 00 00 
  803d50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d57:	00 00 00 
  803d5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d61:	00 00 00 
  803d64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d6b:	00 00 00 
  803d6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d75:	00 00 00 
  803d78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d7f:	00 00 00 
  803d82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d89:	00 00 00 
  803d8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d93:	00 00 00 
  803d96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d9d:	00 00 00 
  803da0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da7:	00 00 00 
  803daa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db1:	00 00 00 
  803db4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dbb:	00 00 00 
  803dbe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc5:	00 00 00 
  803dc8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dcf:	00 00 00 
  803dd2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd9:	00 00 00 
  803ddc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de3:	00 00 00 
  803de6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ded:	00 00 00 
  803df0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df7:	00 00 00 
  803dfa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e01:	00 00 00 
  803e04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e0b:	00 00 00 
  803e0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e15:	00 00 00 
  803e18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e1f:	00 00 00 
  803e22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e29:	00 00 00 
  803e2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e33:	00 00 00 
  803e36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e3d:	00 00 00 
  803e40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e47:	00 00 00 
  803e4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e51:	00 00 00 
  803e54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e5b:	00 00 00 
  803e5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e65:	00 00 00 
  803e68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e6f:	00 00 00 
  803e72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e79:	00 00 00 
  803e7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e83:	00 00 00 
  803e86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e8d:	00 00 00 
  803e90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e97:	00 00 00 
  803e9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea1:	00 00 00 
  803ea4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eab:	00 00 00 
  803eae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb5:	00 00 00 
  803eb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ebf:	00 00 00 
  803ec2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec9:	00 00 00 
  803ecc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed3:	00 00 00 
  803ed6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803edd:	00 00 00 
  803ee0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee7:	00 00 00 
  803eea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef1:	00 00 00 
  803ef4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803efb:	00 00 00 
  803efe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f05:	00 00 00 
  803f08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f0f:	00 00 00 
  803f12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f19:	00 00 00 
  803f1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f23:	00 00 00 
  803f26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f2d:	00 00 00 
  803f30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f37:	00 00 00 
  803f3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f41:	00 00 00 
  803f44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f4b:	00 00 00 
  803f4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f55:	00 00 00 
  803f58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f5f:	00 00 00 
  803f62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f69:	00 00 00 
  803f6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f73:	00 00 00 
  803f76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f7d:	00 00 00 
  803f80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f87:	00 00 00 
  803f8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f91:	00 00 00 
  803f94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f9b:	00 00 00 
  803f9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa5:	00 00 00 
  803fa8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803faf:	00 00 00 
  803fb2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb9:	00 00 00 
  803fbc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc3:	00 00 00 
  803fc6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fcd:	00 00 00 
  803fd0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd7:	00 00 00 
  803fda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe1:	00 00 00 
  803fe4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803feb:	00 00 00 
  803fee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff5:	00 00 00 
  803ff8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  803fff:	00 
